import Foundation

let numbers = [9, 29, 19, 79]

// Imperative example
var tripledNumbers:[Int] = []
for number in numbers {
    tripledNumbers.append(number * 3)
}
print(tripledNumbers)

// Declarative example
let tripledIntNumbers = numbers.map { $0 * 3 }
print(tripledIntNumbers)


let oneToFour = [1, 2, 3, 4]
let firstNumber = oneToFour.lazy.map({ $0 * 3}).first!

print(firstNumber) // 3

// Nested functions
func returnTwenty() -> Int {
    var y = 10
    func add() {
        y += 10
    }
    add()
    return y
}
returnTwenty()

// Return another function as its value
func makeIncrementer() -> (Int -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

// Enums

enum MLSTeam {
    case Montreal
    case Toronto
    case NewYork
    case Columbus
    case LA
    case Seattle
}
let theTeam = MLSTeam.Montreal

switch theTeam {
case .Montreal:
    print("Montreal Impact")
case .Toronto:
    print("Toronto FC")
case .NewYork:
    print("Newyork Redbulls")
case .Columbus:
    print("Columbus Crew")
case .LA:
    print("LA Galaxy")
case .Seattle:
    print("Seattle Sounders")
}


enum NHLTeam { case Canadines, Senators, Rangers, Penguins, BlackHawks, Capitals}

enum Team {
    case Hockey(NHLTeam)
    case Soccer(MLSTeam)
}

struct HockeyAndSoccerTeams {
    var hockey: NHLTeam
    var soccer: MLSTeam
}


enum HockeyAndSoccerTeams2 {
    case Value(hockey: NHLTeam, soccer: MLSTeam)
}

func swapTwoIntegers(inout a: Int, inout b: Int) {
    let tempA = a
    a = b
    b = tempA
}

func swapTwoValues<T>(inout a: T, inout b: T) {
    let tempA = a
    a = b
    b = tempA
}



//let simpleMathOperator: (Double, Double) -> Double

typealias SimpleOperator = (Double, Double) -> Double

var simpleMathOperator: SimpleOperator

func addTwoNumbers(a: Double, b: Double) -> Double { return a + b }

simpleMathOperator = addTwoNumbers
let result = simpleMathOperator(3.5, 5.5) // result is 9


//func calcualte(a: Int,
//               b: Int,
//               funcA: AddSubtractOperator,
//               funcB: SquareTripleOperator) -> Int {
//    return funcA(funcB(a), funcB(b))
//}


let name: String = "John Doe"

func sayHello(name: String) {
    print("Hello \(name)")
}

// we pass a String type with its respective value
sayHello("John Doe") // or
sayHello(name)

// store a function in a variable to be able to pass it around
let sayHelloFunc = sayHello

// fn Copmposition

let content = "10,20,40,30,80,60"
func extractElements(content: String) -> [String] {
    return content.characters.split(",").map { String($0) }
}
let elements = extractElements(content)

func formatWithCurrency(content: [String]) -> [String] {
    return content.map {"\($0)$"}
}

let contentArray = ["10", "20", "40", "30", "80", "60"]
let formattedElements = formatWithCurrency(contentArray)

// Functional way

let composedFunction = { data in
    formatWithCurrency(extractElements(data))
}

composedFunction(content)

// Custom operator

infix operator |> { associativity left }
func |> <T, V>(f: T -> V, g: V -> V ) -> T -> V {
    return { x in g(f(x)) }
}

let composedWithCustomOperator = extractElements |> formatWithCurrency
composedWithCustomOperator("10,20,40,30,80,60")


//{ (parameters) -> ReturnType in
//    // body of closure
//}
//
//func({(Int) -> (Int) in
////statements
//})

// CLosures

let anArray = [10, 20, 40, 30, 80, 60]
anArray.sort({ (param1: Int, param2: Int) -> Bool in
    return param1 < param2
})

anArray.sort({ (param1, param2) in
    return param1 < param2
})

anArray.sort { (param1, param2) in
    return param1 < param2
}

anArray.sort {
    return $0 < $1
}

anArray.sort { $0 < $1 }

// Value types vs. Reference types

struct ourStruct {
    var data: Int = 3
}

var valueA = ourStruct()
var valueB = valueA // valueA is copied to valueB
valueA.data = 5 // Changes valueA, not valueB
print("\(valueA.data), \(valueB.data)") // prints "5, 3"


class ourClass {
    var data: Int = 3
}
var referenceA = ourClass()
var referenceB = referenceA // referenceA is copied to referenceB
referenceA.data = 5 // changes the instance referred to by referenceA and referenceB
print("\(referenceA.data), \(referenceB.data)") // prints "5, 5"

// Functional Data Structures

enum Tree <T> {
    case Leaf(T)
    indirect case Node(Tree, Tree)
}

let ourGenericTree = Tree.Node(Tree.Leaf("First"), Tree.Node(Tree.Leaf("Second"), Tree.Leaf("Third")))
print(ourGenericTree)

// Associated Type Protocols

protocol Container {
    associatedtype ItemType
    func append(item: ItemType)
}

// Optionals

enum Optional<T> {
    case None
    case Some(T)
}

func mapOptionals<T, V>(transform: T -> V, input: T?) -> V? {
    switch input {
    case .Some(let value): return transform(value)
    case .None: return .None
    }
}

class User {
    var firstName: String?
    var lastName: String?
}

func extractUserName(name: String) -> String {
    return "\(name)"
}

//var nonOptionalUserName: String {
//    let user = User()
//    user.name = "John Doe"
//    let someUserName = mapOptionals(extractUserName, input: user.name)
//    return someUserName ?? ""
//}
//
//print(nonOptionalUserName)

// fmap

infix operator <^> { associativity left }

func <^><T, V>(transform: T -> V, input: T?) -> V? {
    switch input {
    case .Some(let value): return transform(value)
    case .None: return .None
    }
}

//var nonOptionalUserName: String {
//    let user = User()
//    user.name = "John Doe"
//    let someUserName = extractUserName <^> user.name
//    return someUserName ?? ""
//}

// apply

infix operator <*> { associativity left }

func <*><T, V>(transform: (T -> V)?, input: T?) -> V? {
    switch transform {
    case .Some(let fx): return fx <^> input
    case .None: return .None
    }
}

// Currying is deprecated

func curriedExtractFullUserName(firstName: String)(lastName: String) -> String {
    return "\(firstName) \(lastName)"
}

// Swift 3.0 version for currying

func explicityRetunClosure(firstName: String) -> (String) -> String {
    return { (lastName: String) -> String in
        return "\(firstName) \(lastName)"
    }
}

func extractFullUserName(firstName: String, lastName: String) -> String {
    return "\(firstName) \(lastName)"
}

let fnIncludingFirstName = curriedExtractFullUserName("John")
let extractedFullName = fnIncludingFirstName(lastName: "Doe")

var fullName: String {
    let user = User()
    user.firstName = "John"
    user.lastName = "Doe"
    //    let fullUserName = curriedExtractFullUserName <^> user.firstName <*> user.lastName
    let fullUserName = explicityRetunClosure <^> user.firstName <*> user.lastName
    return fullUserName ?? ""
}

print(fullName)

// Optional mapping

let optionalString: String? = "A String literal"
let resulted = optionalString.map { value in "\(value) is mapped" }

print(resulted)

// Monad

let optionalArray: [String?] = ["First", "Second", nil, "Fourth"]
let nonOptionalArray = optionalArray.flatMap { $0 }
print(nonOptionalArray)

// Lens example

struct Producer {
    let name: String
    let address: String
}

struct Product {
    let name: String
    let price: Double
    let quantity: Int
    let producer: Producer
}

struct FunctionalProductTracker {
    let products: [Product]
    let lastModified: NSDate
    
    func addNewProduct(item: Product) -> (date: NSDate, products: [Product]) {
        let newProducts = self.products + [item]
        return (date: NSDate(), products: newProducts)
    }
}

struct Lens<Whole, Part> {
    let get: Whole -> Part
    let set: (Part, Whole) -> Whole
}

let prodProducerLens: Lens<Product, Producer> = Lens(get: { $0.producer},
                                                     set: { Product(name: $1.name, price: $1.price, quantity: $1.quantity, producer: $0)})

let producer = Producer(name: "ABC", address: "Toronto, Ontario, Canada")

var bananas = Product(name: "Banana", price: 0.79, quantity: 2, producer: producer)

let mexicanBananas = Product(name: bananas.name, price: bananas.price, quantity: bananas.quantity, producer: Producer(name: "XYZ", address: "New Mexico, Mexico"))


let mexicanBananas2 = prodProducerLens.set(Producer(name: "QAZ", address: "Yucatan, Mexico"), mexicanBananas)


print(mexicanBananas2)






