Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6145C115A
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfI1Qtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:49:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45234 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1Qtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:49:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id u12so2247998pls.12;
        Sat, 28 Sep 2019 09:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x3DkLlNxAab2KL5voiX+odB3OOCM5FoX7tYfq/LUPRs=;
        b=TrTOqLMV7RwSTD2hQpKA6EAbERjT35rxkRn9XJ0we6btLRygCjn3nBzk3LNUhH6VoP
         B/ZBdrJiOBEMVu0JYUDVypSMv9rEvQsAvowpPjShBm6cujUmTs55OnLiLNETW8vQahJV
         WgApe9l8uDzCqLFS8LL2B+rEVZJRpWrlWEwbkBm4RjCf4smPhlPkVJuG+kCnMdK2EPSS
         r52fHODCWu+dyTyBxLQmJNnuWX/tiey38gU3YH9+Oo4ER8po0nfIfX3O+UfcVmoWjZNB
         zCzAep/y2zAGu08I6ixwmHvHsyI6Uk+G4uMcT6GmLOySm43MOk7f73pKnh0Z4KqhjPQ3
         ejGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x3DkLlNxAab2KL5voiX+odB3OOCM5FoX7tYfq/LUPRs=;
        b=siyCPWtgGN/jKBe+WzUrEn2jJdSllfMyM5BTI/DF6+NaJB7Qv+OEg0HC2VKbyqq4Pj
         aUUSvPzzXELWWgRW/fyhmkQK0aBntXtOom8RFWrMR2KVzY0ETOFvun5ksDm3HI9PZCkW
         2m969JeAzYVQEsvqmIOHd64qVqpXu2rBf6j46UuwEqImaG9gcHt6N5hZM0FYmiABY9Ca
         b3eN5ERrNT7U0d8A0OySpq4CBrtF235lGQhDjLvCWkKdb/5aWhZGBL+bOOJJ8tWd4Rkx
         P8Go5xOkU/G7+iL9k3PdVwEuWdx1aeQTHibC4Pr89/62h9jRFF3O5bURvdNPtZPRUaaC
         a3uA==
X-Gm-Message-State: APjAAAX8eJpi4plv79f9kNVvMl40ey+fqZZoy8p0AxPAPOK6rkY8DNAi
        YuE8AgjSaOKpOle/12DB69I=
X-Google-Smtp-Source: APXvYqyu/frR49EK+yWlygP8n4tUzwjm5eD42GQyGlzbQUQFX8+mOp9xvWaXZqPBnk5l4WxbCqg8TQ==
X-Received: by 2002:a17:902:a588:: with SMTP id az8mr8094854plb.184.1569689377951;
        Sat, 28 Sep 2019 09:49:37 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:49:37 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 04/12] bonding: use dynamic lockdep key instead of subclass
Date:   Sat, 28 Sep 2019 16:48:35 +0000
Message-Id: <20190928164843.31800-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All bonding device has same lockdep key and subclass is initialized with
nest_level.
But actual nest_level value can be changed when a lower device is attached.
And at this moment, the subclass should be updated but it seems to be
unsafe.
So this patch makes bonding use dynamic lockdep key instead of the
subclass.

Test commands:
    ip link add bond0 type bond

    for i in {1..5}
    do
	    let A=$i-1
	    ip link add bond$i type bond
	    ip link set bond$i master bond$A
    done
    ip link set bond5 master bond0

Splat looks like:
[   29.858108] WARNING: possible recursive locking detected                                                          
[   29.858630] 5.3.0+ #3 Not tainted                                                               
[   29.858946] --------------------------------------------
[   29.859501] ip/629 is trying to acquire lock:
[   29.860591] ffff88806801cf00 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[   29.861677]                                                                              
[   29.861677] but task is already holding lock: 
[   29.862307] ffff88806801ada0 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[   29.863406]                                            
[   29.863406] other info that might help us debug this:
[   29.864092]  Possible unsafe locking scenario: 
[   29.864092]                                       
[   29.864715]        CPU0                       
[   29.864968]        ----                             
[   29.865225]   lock(&(&bond->stats_lock)->rlock#2/2);            
[   29.865731]   lock(&(&bond->stats_lock)->rlock#2/2);            
[   29.866235]                                         
[   29.866235]  *** DEADLOCK ***                     
[   29.866235]                                               
[   29.866829]  May be due to missing lock nesting notation
[   29.866829]                                          
[   29.867632] 3 locks held by ip/629:                 
[   29.868077]  #0: ffffffffb4ec7a30 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0                               
[   29.869141]  #1: ffff88806801ada0 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[   29.870504]  #2: ffffffffb4b22780 (rcu_read_lock){....}, at: bond_get_stats+0x9f/0x500 [bonding]
[   29.875917]                                                                  
[   29.875917] stack backtrace:                                                 
[   29.876533] CPU: 0 PID: 629 Comm: ip Not tainted 5.3.0+ #3                   
[   29.877254] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   29.878344] Call Trace:                                                           
[   29.878697]  dump_stack+0x7c/0xbb                               
[   29.879167]  __lock_acquire+0x26a9/0x3df0                                         
[   29.879660]  ? register_lock_class+0x14d0/0x14d0                                  
[   29.880067]  lock_acquire+0x164/0x3b0                           
[   29.880402]  ? bond_get_stats+0xb8/0x500 [bonding]                                
[   29.880826]  _raw_spin_lock_nested+0x2e/0x60                    
[   29.881206]  ? bond_get_stats+0xb8/0x500 [bonding]          
[   29.881725]  bond_get_stats+0xb8/0x500 [bonding]                                  
[ ... ]

Fixes: d3fff6c443fe ("net: add netdev_lockdep_set_classes() helper")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v4 :
 - This patch is not changed

 drivers/net/bonding/bond_main.c | 61 ++++++++++++++++++++++++++++++---
 include/net/bonding.h           |  3 ++
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0db12fcfc953..7f574e74ed78 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1857,6 +1857,32 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	return res;
 }
 
+static void bond_dev_set_lockdep_one(struct net_device *dev,
+				     struct netdev_queue *txq,
+				     void *_unused)
+{
+	struct bonding *bond = netdev_priv(dev);
+
+	lockdep_set_class(&txq->_xmit_lock, &bond->xmit_lock_key);
+}
+
+static void bond_update_lock_key(struct net_device *dev)
+{
+	struct bonding *bond = netdev_priv(dev);
+
+	lockdep_unregister_key(&bond->stats_lock_key);
+	lockdep_unregister_key(&bond->addr_lock_key);
+	lockdep_unregister_key(&bond->xmit_lock_key);
+
+	lockdep_register_key(&bond->stats_lock_key);
+	lockdep_register_key(&bond->addr_lock_key);
+	lockdep_register_key(&bond->xmit_lock_key);
+
+	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &bond->addr_lock_key);
+	netdev_for_each_tx_queue(dev, bond_dev_set_lockdep_one, NULL);
+}
+
 /* Try to release the slave device <slave> from the bond device <master>
  * It is legal to access curr_active_slave without a lock because all the function
  * is RTNL-locked. If "all" is true it means that the function is being called
@@ -2022,6 +2048,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 		slave_dev->priv_flags &= ~IFF_BONDING;
 
 	bond_free_slave(slave);
+	if (netif_is_bond_master(slave_dev))
+		bond_update_lock_key(slave_dev);
 
 	return 0;
 }
@@ -3459,7 +3487,7 @@ static void bond_get_stats(struct net_device *bond_dev,
 	struct list_head *iter;
 	struct slave *slave;
 
-	spin_lock_nested(&bond->stats_lock, bond_get_nest_level(bond_dev));
+	spin_lock(&bond->stats_lock);
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	rcu_read_lock();
@@ -4297,8 +4325,6 @@ void bond_setup(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 
-	spin_lock_init(&bond->mode_lock);
-	spin_lock_init(&bond->stats_lock);
 	bond->params = bonding_defaults;
 
 	/* Initialize pointers */
@@ -4367,6 +4393,9 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	list_del(&bond->bond_list);
 
+	lockdep_unregister_key(&bond->stats_lock_key);
+	lockdep_unregister_key(&bond->addr_lock_key);
+	lockdep_unregister_key(&bond->xmit_lock_key);
 	bond_debug_unregister(bond);
 }
 
@@ -4758,6 +4787,29 @@ static int bond_check_params(struct bond_params *params)
 	return 0;
 }
 
+static struct lock_class_key qdisc_tx_busylock_key;
+static struct lock_class_key qdisc_running_key;
+
+static void bond_dev_set_lockdep_class(struct net_device *dev)
+{
+	struct bonding *bond = netdev_priv(dev);
+
+	dev->qdisc_tx_busylock = &qdisc_tx_busylock_key;
+	dev->qdisc_running_key = &qdisc_running_key;
+
+	spin_lock_init(&bond->mode_lock);
+
+	spin_lock_init(&bond->stats_lock);
+	lockdep_register_key(&bond->stats_lock_key);
+	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
+
+	lockdep_register_key(&bond->addr_lock_key);
+	lockdep_set_class(&dev->addr_list_lock, &bond->addr_lock_key);
+
+	lockdep_register_key(&bond->xmit_lock_key);
+	netdev_for_each_tx_queue(dev, bond_dev_set_lockdep_one, NULL);
+}
+
 /* Called from registration process */
 static int bond_init(struct net_device *bond_dev)
 {
@@ -4771,8 +4823,7 @@ static int bond_init(struct net_device *bond_dev)
 		return -ENOMEM;
 
 	bond->nest_level = SINGLE_DEPTH_NESTING;
-	netdev_lockdep_set_classes(bond_dev);
-
+	bond_dev_set_lockdep_class(bond_dev);
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
 	bond_prepare_sysfs_group(bond);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f7fe45689142..c39ac7061e41 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -239,6 +239,9 @@ struct bonding {
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
+	struct lock_class_key stats_lock_key;
+	struct lock_class_key xmit_lock_key;
+	struct lock_class_key addr_lock_key;
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.17.1

