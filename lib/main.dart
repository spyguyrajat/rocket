import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CryptoScreen(),
    );
  }
}

class CryptoScreen extends StatefulWidget {
  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<dynamic> cryptos = [];
  bool isLoading = true;
  int _selectedIndex = 0; // to keep track of selected bottom nav bar item

  static List<Widget> _widgetOptions = <Widget>[
    CryptoListView(), // the main crypto screen
    ProfileScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 100.0,
            color: Colors.blue,
          ),
          SizedBox(height: 16.0),
          Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 16.0),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tincidunt tincidunt mi, et placerat orci iaculis nec.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Rocket - The Crypto App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'Rocket is an innovative platform designed for crypto enthusiasts and learners alike. Dive into the world of cryptocurrencies and harness the power of Rocket Money to learn, trade, and experiment. Whether you\'re a beginner or an experienced trader, Rocket provides a simulated environment using Rocket Coins to buy, sell, and understand the dynamics of the crypto market.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class CryptoListView extends StatefulWidget {
  @override
  _CryptoListViewState createState() => _CryptoListViewState();
}

class _CryptoListViewState extends State<CryptoListView> {
  List<dynamic> cryptos = [];
  List<dynamic> dummys = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _refreshCryptoList() async {
    await fetchData();
  }

  fetchData() async {
    final response = await http
        .get(Uri.parse('https://bitbns.com/order/getTickerWithVolume/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data);
      setState(() {
        dummys = data.entries.map((e) => e.key).toList();
        cryptos = data.entries.map((e) => e.value).toList();
        // print(cryptos.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rocket - The Crypto App')),
      body: RefreshIndicator(
        onRefresh: _refreshCryptoList,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 2 items per row
            childAspectRatio: 2 / 1, // Ratio for item size
          ),
          itemCount: cryptos.length,
          itemBuilder: (context, index) {
            final crypto = cryptos[index];
            final dummy = dummys[index];
            return Card(
              child: ListTile(
                title: Text(dummy),
                subtitle: Text('Price: ${crypto['last_traded_price']}'),
              ),
            );
          },
        ),
      ),
      // ... (rest of the code remains unchanged)
    );
  }
}
