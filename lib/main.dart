import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

void main() {
  Stetho.initialize();
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage1(title: 'ToDO List'),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  MyHomePage1({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1> {
  int _counter = 0;

  var taskTitleController = new TextEditingController();
  var taskDescController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();

  var addLabel = 'Add';
  var saveLabel = 'Save';
  var todoLabel = 'Todo';
  var taskLabel = 'Task';
  var deadlineLabel = 'Deadline';
  var taskDescLabel = 'Descrption';
  var addedConfirmation = 'Task created successfully...,';
  var savedConfirmation = 'Task saved successfully...,';
  var taskCompletedConfirmation = 'Task completed successfully...,';
  var errorNoTitle = 'Title should not be empty';
  var errorNoDesc = 'Descrption should not be empty';
  String updatedid;
  final TodoBloc todoBloc = TodoBloc();

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 40.0,
            ),
            child: Column(
              children: <Widget>[
                // task creation and updation related UI
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              child: Text(deadlineLabel + ":"),
                              alignment: Alignment.centerLeft,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: InkWell(
                              child: Container(
                                height: 38.0,
                                padding:
                                EdgeInsets.only(right: 10.0, left: 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54)),
                                child: Align(
                                  child: Text("${selectedDate.toLocal()}"
                                      .split(' ')[0]),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              child: Text(taskLabel + ":"),
                              alignment: Alignment.centerLeft,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Container(
                              height: 38.0,
                              padding: EdgeInsets.only(right: 10.0, left: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54)),
                              child: Align(
                                child: TextFormField(
                                  controller: taskTitleController,
                                  decoration:
                                  InputDecoration(border: InputBorder.none),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              child: Text(taskDescLabel + ":"),
                              alignment: Alignment.centerLeft,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Container(
                              height: 38.0,
                              padding: EdgeInsets.only(right: 10.0, left: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54)),
                              child: Align(
                                child: TextFormField(
                                  controller: taskDescController,
                                  decoration:
                                  InputDecoration(border: InputBorder.none),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54)),
                        width: MediaQuery.of(context).size.width,
                        height: 38.0,
                        child: InkWell(
                          child: Center(child: Text(addLabel.toUpperCase())),
                          onTap: () {

                            _handleValidations();

                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15.0,
                ),

                Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),

                SizedBox(
                  height: 3.0,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 38.0,
                  child: Center(
                    child: Text(
                      todoLabel.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ),

                SizedBox(
                  height: 3.0,
                ),

                Divider(
                  thickness: 2.0,
                  color: Colors.black,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        left: 2.0, right: 2.0, bottom: 2.0),
                    child: Container(

                      //This is where the magic starts
                        child: getTodosWidget())),
              ],
            ),
          ),
          onWillPop: () {
            onPopScope();
          }),
    );
  }

  Widget getTodosWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */
      return snapshot.data.length != 0
          ? ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: snapshot.data.length,
        itemBuilder: (context, itemPosition) {
          Todo todo = snapshot.data[itemPosition];
          final Widget dismissibleCard = new Dismissible(
            background: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              color: Colors.redAccent,
            ),
            onDismissed: (direction) {
              /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
              todoBloc.deleteTodoById(todo.id);
              showSnackBar("Item Deleted Successfully.");
            },
            direction: _dismissDirection,
            key: new ObjectKey(todo),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[200], width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: Text(
                    todo.taskTitle,
                    style: TextStyle(
                        fontSize: 16.5,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.w500,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      //Reverse the value
                      todo.isDone = !todo.isDone;
                      /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                      todoBloc.updateTodo(todo);
                    },
                    child: Container(
                      //decoration: BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: todo.isDone
                            ? Icon(
                          Icons.done,
                          size: 26.0,
                          color: Colors.indigoAccent,
                        )
                            : Icon(
                          Icons.check_box_outline_blank,
                          size: 26.0,
                          color: Colors.tealAccent,
                        ),
                      ),
                    ),
                  ),
                  title: InkWell(
                    onTap: () {
                      updatetext(todo.id, todo.taskTitle, todo.taskdesc,
                          todo.isDone, todo.deadLine);
                    },
                    child: Text(
                      todo.deadLine,
                      style: TextStyle(
                          fontSize: 16.5,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w500,
                          color: checkDeadline(todo.deadLine) == true
                              ? Colors.black
                              : Colors.red,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ),
                )),
          );
          //  showSnackBar("Item Deleted Successfully..");
          return dismissibleCard;
        },
      )
          : Container(
          child: Center(
            //this is used whenever there 0 Todo
            //in the data base
            child: noTodoMessageWidget(),
          ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    todoBloc.getTodos();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<bool> onPopScope() {
    return Future.value(true);
  }

  void _handleValidations() {
    if (taskTitleController.text.length == 0 ||
        taskTitleController.text.isEmpty ||
        taskTitleController.text == null) {
      showSnackBar(errorNoTitle);
    } else {
      if (taskDescController.text.length == 0 ||
          taskDescController.text.isEmpty ||
          taskDescController.text == null) {
        showSnackBar(errorNoDesc);
      } else {
        handleToDOInsertion();
      }
    }
  }

  void handleToDOInsertion() async {
    final newTodo = Todo(
        deadLine: "$selectedDate.toLocal()}".split(' ')[0],
        taskTitle: taskTitleController.text,
        taskdesc: taskDescController.text,
        isDone: false);

    if (newTodo.taskTitle.isNotEmpty &&
        newTodo.taskdesc.isNotEmpty &&
        newTodo.deadLine.isNotEmpty) {
      /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
      todoBloc.addTodo(newTodo);
      taskDescController.clear();
      taskTitleController.clear();
      showSnackBar("Task Created Successfully..");
    }
    if (newTodo.taskTitle.isNotEmpty &&
        newTodo.taskdesc.isNotEmpty &&
        newTodo.deadLine.isNotEmpty) {
      /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
      todoBloc.addTodo(newTodo);
      taskDescController.clear();
      taskTitleController.clear();
      showSnackBar("Task Created Successfully..");
    }

    /* dbHelper.add(ToDo(null, "$selectedDate.toLocal()}".split(' ')[0],
        taskTitleController.text, taskDescController.text));
*/
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  bool checkDeadline(String deadline) {
    bool status;
    var selcted = DateTime.parse(deadline);
    var now = new DateTime.now();
    if (selcted.isBefore(now)) {
      status = false;
    } else if (selcted == now) {
      status = true;
    } else if (selcted.isAfter(now)) {
      status = true;
    }
    return status;
  }

  void updatetext(
      int id, String taskTitle, String taskdesc, bool isDone, String deadline) {
    taskTitleController.text = taskTitle;
    taskDescController.text = taskdesc;
    selectedDate = DateTime.parse(deadline);
    // _selectDate(context.);
    final newTodo = Todo(
        deadLine: "$selectedDate.toLocal()}".split(' ')[0],
        taskTitle: taskTitleController.text,
        taskdesc: taskDescController.text,
        isDone: false);
    if (newTodo.taskTitle.isNotEmpty &&
        newTodo.taskdesc.isNotEmpty &&
        newTodo.deadLine.isNotEmpty) {
      /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
      todoBloc.updateTodo(newTodo);
      taskDescController.clear();
      taskTitleController.clear();
      showSnackBar("Task Updated Successfully..");
    }
  }
}

/* TODO BLOC */
class TodoBloc {
  //Get instance of the Repository
  final _todoRepository = TodoRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<Todo>>.broadcast();

  get todos => _todoController.stream;

  TodoBloc() {
    getTodos();
  }

  getTodos() async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _todoController.sink.add(await _todoRepository.getAllTodos());
  }

  addTodo(Todo todo) async {
    await _todoRepository.insertTodo(todo);
    getTodos();
  }

  updateTodo(Todo todo) async {
    await _todoRepository.updateTodo(todo);
    getTodos();
  }

  deleteTodoById(int id) async {
    _todoRepository.deleteTodoById(id);
    getTodos();
  }

  dispose() {
    _todoController.close();
  }
}

class TodoRepository {
  final todoDao = TodoDao();

  Future getAllTodos() => todoDao.getTodos();

  Future insertTodo(Todo todo) => todoDao.createTodo(todo);

  Future updateTodo(Todo todo) => todoDao.updateTodo(todo);

  Future deleteTodoById(int id) => todoDao.deleteTodo(id);

  //We are not going to use this in the demo
  Future deleteAllTodos() => todoDao.deleteAllTodos();
}

class Todo {
  int id;

  //description is the text we see on
  //main screen card text
  String deadLine;
  String taskTitle;
  String taskdesc;

  //isDone used to mark what Todo item is completed
  bool isDone = false;

  //When using curly braces { } we note dart that
  //the parameters are optional
  Todo(
      {this.id,
        this.deadLine,
        this.taskTitle,
        this.taskdesc,
        this.isDone = false});

  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
    //Factory method will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Todo object

    id: data['id'],
    taskTitle: data['taskTitle'],
    deadLine: data['deadLine'],
    taskdesc: data['taskdesc'],

    //Since sqlite doesn't have boolean type for true/false,
    //we will use 0 to denote that it is false
    //and 1 for true
    isDone: data['is_done'] == 0 ? false : true,
  );

  Map<String, dynamic> toDatabaseJson() => {
    //A method will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON

    "id": this.id,
    "taskTitle": this.taskTitle,
    "deadLine": this.deadLine,
    "taskdesc": this.taskdesc,
    "is_done": this.isDone == false ? 0 : 1,
  };
}

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Todo records
  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = db.insert(todoTABLE, todo.toDatabaseJson());
    return result;
  }

  //Get All Todo items
  //Searches if query string was passed
  Future<List<Todo>> getTodos() async {
    final db = await dbProvider.database;

    var dbClient = await db;
    List<Map> maps = await dbClient.query(todoTABLE,
        columns: ['id', 'taskTitle', 'deadLine', 'taskdesc', 'is_done']);
    List<Todo> todo = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        todo.add(Todo.fromDatabaseJson(maps[i]));
      }
    }
    return todo;
  }

  //Update Todo record
  Future<int> updateTodo(Todo todo) async {
    final db = await dbProvider.database;

    var result = await db.update(todoTABLE, todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result;
  }

  //Delete Todo records
  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      todoTABLE,
    );

    return result;
  }
}

final todoTABLE = 'Todo';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var databaepath = await getDatabasesPath();
    //"ReactiveTodo.db is our database instance name
    String path = join(databaepath, "Todo.db");

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $todoTABLE ("
        "id INTEGER PRIMARY KEY, "
        "deadLine TEXT, "
        "taskTitle TEXT, "
        "taskDesc TEXT, "
    /*SQLITE doesn't have boolean type
        so we store isDone as integer where 0 is false
        and 1 is true*/
        "is_done INTEGER "
        ")");
  }
}
