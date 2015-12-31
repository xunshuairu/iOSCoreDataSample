//
//  ViewController.swift
//  iOSCoreDataSample
//
//  Created by GaoLianjing on 12/30/15.
//  Copyright © 2015 GaoLianjing. All rights reserved.
//

import UIKit
import CoreData //  For Core Data



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //var name = [String]()
    var people = [NSManagedObject]() // For Core Data
    
    //  Insert Data to data model
    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first;
            self.saveName(textField!.text!)
            self.tableView.reloadData();
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default)
        { (action:UIAlertAction) -> Void in}
        
        
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //  Save data to data model
    func saveName(name: String) {
    
        // 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // 3
        person.setValue(name, forKey: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //  Remove data from data model
    func deleteName(row:Int) {
        // 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            
            let person = results[row] as! NSManagedObject
            
            managedContext.deleteObject(person)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //  Update data 
    func updataName(row:Int, name:String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let person = results[row] as! NSManagedObject
            person.setValue(name, forKey: "name")
            people[row] = person
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        let alert = UIAlertController(title: "Update Name", message: "Input a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first;
            self.updataName(indexPath.row, name: textField!.text!)
            self.tableView.reloadData();
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default)
            { (action:UIAlertAction) -> Void in}
        
        
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.deleteName(indexPath.row)
            people.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        // 2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        // 3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let person = people[indexPath.row]
        
        cell!.textLabel!.text = person.valueForKey("name") as? String
        //  The only way Core Data provides to read the value is KVC(key value coding)
        
        return cell!
    }
    
    
}

