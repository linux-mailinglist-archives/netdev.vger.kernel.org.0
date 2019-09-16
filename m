Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C27B3BC6
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfIPNso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:48:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34627 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387751AbfIPNsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:48:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so4150465pfa.1
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZPeLMo9MFvVW4yL0ZJQGO2vpPx1mzULdNeE2N0hHoNo=;
        b=ry/KIFGyTIjV87OjhUll6s4GmkkiI62rg6l24IptjAsB+5RL0LOgDxf8LfRGqttDsQ
         FBZJxK/x+Pa4raGf5cDiQv6JLY+b1U/8J7vcnh9ukMWv5xJTZPoBySw7EqNlxFolbxgg
         n/ir+mENlOBMfAhnBcz6nJpL+8qHJ4rNMwqAretfI56uNn4Wb3hm+KcmbXAZP2I1XGrT
         SSXCrUFozAZ/dvorngbGZ9clFtOWXubX3HvveFQjaGbAMyth9XramzC9osVq0tGs9Njl
         pBjaFfAlaISPCZcLDXJRyJO7E/tnZvieYayLBlfTgg32DbZau7bVZ4zsMpaR7MEAOgp5
         dUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZPeLMo9MFvVW4yL0ZJQGO2vpPx1mzULdNeE2N0hHoNo=;
        b=svoWsNsctObLACdIpwHm3Gi4eF2DuG7Zsb692/hPDS3cLumU2uoY37VEv0yOKSdfva
         NUe8thP5aNgYPwA2Qk6Uf8qARHCX+r3Pbk2r+uPg6Xkpkd349cbWMyUmsuNErmvKzJly
         uCduSOQzzSnxeJ5u+mf7TMR+kTNOrhOH90vNMmFOFlGS4cZ1s8DJHP5V9QxrRCoLbPeu
         nIBAWzmI56RQ1ftVNtX/i0Eq9ebUewh/YQe6aJZGoonJAJLVaXDxnBRG2/5tfPoCZVdr
         nwW+MlVXcfr4AQd62pYtlwHoN1vOzJ2zyOWVvm3z3wa3LyvcqEXkrimDOL1W4hAxQuRH
         nweQ==
X-Gm-Message-State: APjAAAVGH6nZOO+PULLHksk2oVYDLa5sivOjj+FSf14XDklFLtQUeGwZ
        w0Z5No6G+OeP7VMbLBfczmE=
X-Google-Smtp-Source: APXvYqzHsT0un85d7+rbFlEzNuR5iCY6NQRKaIWrJRDwBwZgX2oHyfcTqsQLcF4n+gOIE/YsZ9hHGQ==
X-Received: by 2002:a63:ab05:: with SMTP id p5mr9639474pgf.414.1568641722741;
        Mon, 16 Sep 2019 06:48:42 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:48:41 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 04/11] bonding: use dynamic lockdep key instead of subclass
Date:   Mon, 16 Sep 2019 22:47:55 +0900
Message-Id: <20190916134802.8252-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
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
[   53.930344] WARNING: possible recursive locking detected
[   53.931041] 5.3.0-rc8+ #179 Not tainted
[   53.931554] --------------------------------------------
[   53.932285] ip/984 is trying to acquire lock:
[   53.932854] 00000000e313b280 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[   53.934144]
[   53.934144] but task is already holding lock:
[   53.934907] 00000000f5a0c2e3 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[   53.936268]
[   53.936268] other info that might help us debug this:
[   53.937135]  Possible unsafe locking scenario:
[   53.937135]
[   53.937910]        CPU0
[   53.938247]        ----
[   53.938577]   lock(&(&bond->stats_lock)->rlock#2/2);
[   53.939234]   lock(&(&bond->stats_lock)->rlock#2/2);
[   53.939903]
[   53.939903]  *** DEADLOCK ***
[   53.939903]
[   53.940745]  May be due to missing lock nesting notation
[   53.940745]
[   53.941626] 3 locks held by ip/984:
[   53.942005]  #0: 000000009e3df2a0 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[   53.942942]  #1: 00000000f5a0c2e3 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bond]
[   53.944194]  #2: 000000005b301abc (rcu_read_lock){....}, at: bond_get_stats+0x9f/0x500 [bonding]
[   53.945168]
[   53.945168] stack backtrace:
[   53.945672] CPU: 0 PID: 984 Comm: ip Not tainted 5.3.0-rc8+ #179
[   53.946606] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   53.947529] Call Trace:
[   53.947795]  dump_stack+0x7c/0xbb
[   53.948213]  __lock_acquire+0x26a9/0x3de0
[   53.948666]  ? register_lock_class+0x14d0/0x14d0
[   53.949206]  lock_acquire+0x164/0x3b0
[   53.949647]  ? bond_get_stats+0xb8/0x500 [bonding]
[   53.950169]  _raw_spin_lock_nested+0x2e/0x60
[   53.950630]  ? bond_get_stats+0xb8/0x500 [bonding]
[   53.951132]  bond_get_stats+0xb8/0x500 [bonding]
[   53.951655]  ? bond_arp_rcv+0xf10/0xf10 [bonding]
[   53.952220]  ? register_lock_class+0x14d0/0x14d0
[   53.952751]  ? bond_get_stats+0xb8/0x500 [bonding]
[   53.953277]  dev_get_stats+0x1ec/0x270
[   53.984289]  bond_get_stats+0x1d1/0x500 [bonding]
[   53.984803]  ? bond_arp_rcv+0xf10/0xf10 [bonding]
[   53.985323]  ? dev_get_alias+0xe2/0x190
[   53.985748]  ? nla_put_ifalias+0x71/0x100
[   53.986213]  ? rtnl_phys_switch_id_fill+0x91/0x100
[   53.986720]  dev_get_stats+0x1ec/0x270
[   53.987100]  rtnl_fill_stats+0x44/0xbe0
[   53.987494]  ? nla_put+0xc2/0x140
[   53.987828]  rtnl_fill_ifinfo+0xec7/0x35b0
[ ... ]

Fixes: d3fff6c443fe ("net: add netdev_lockdep_set_classes() helper")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - This patch is not changed
v1 -> v2 :
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

