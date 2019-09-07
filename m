Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52BDAC6CE
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394631AbfIGNqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:46:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35631 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394625AbfIGNqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:46:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so5152243pgv.2
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HAYWwtEHy06UdxyP1W8EGDeOSCoeIrn8ybEJbaZ1LAc=;
        b=l/mXyivnSLaXswjUfNlKbawU5pxfb7zMxazU/V1M6JQZ1Gfo2Uu1V7cnCiLH+iJPHb
         /8yge/FD967KxVyqC3RBqpTU1dLW5Rfo6yICegYLp4GgZCRrNso8/brhZLT0XS9te/8T
         ph86ZnjZec+/xy7mdH46cOTHsx+CoQ58saLrCuSissazEqO+G5jlhLl7/nWjZF0dwbC3
         bvb58UrMP4o8mUuIAvjIlNbo3hh2PPq5C0o15WQq6pP+D5uNC5l7uXzcVfgEaBd23RkQ
         MkAHDVRfmsUhhMRzOYa7Rm9zJUf5Z1lmghuQexWvezwHGLYfR2a1qz19pQrDHT9Y4wWw
         Hg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HAYWwtEHy06UdxyP1W8EGDeOSCoeIrn8ybEJbaZ1LAc=;
        b=jK8gSSIcVLNjPMjUrr+sm6rlUB1uzeNB5a241RzlkwxHP0r4mDEPCou2Uo+3fsleUB
         M6dl00IvYZkZLUKa+cJHtilk4uZ96nhQvfTxxf5up5ymlqCzqlFeGOTUC+Qn48j4IsE7
         Bo8xI7p1KeJNQd5DDL+gC1Fu1v5mLgjzlgCjGcSnpYmhfthfklN83y3lZmnNjQ0ywwsI
         81CNibQO0zn2s58mX54DntM7ijkMKP2atHqeE1iagH+38AxRPCbkecKjmaJ1Q+OUTHxj
         KPk9iz8Ttus3EAbEe2tOUTpeFTk5UyUtsUHJ2rx0hY/vLHs4+0WZwJ3/K9SFRjs8nvOr
         DBkQ==
X-Gm-Message-State: APjAAAWuEBPbhsD8VeI3WP2sPq9xfeX6XGOx1PqVUelOwdAcEVGYtCoW
        PuGvnberE+T6+YlxUJEqpqGvsV6YaF4=
X-Google-Smtp-Source: APXvYqxgNr5HWrLqHo+TKkEJ9evPsTR0t1tR0C+vNLtpRESKIGh/4LiYRQPlhKzdQQGVv2hkIX/Waw==
X-Received: by 2002:a65:4808:: with SMTP id h8mr12545030pgs.22.1567863982473;
        Sat, 07 Sep 2019 06:46:22 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id c17sm7877740pfo.57.2019.09.07.06.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:46:21 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 04/11] bonding: use dynamic lockdep key instead of subclass
Date:   Sat,  7 Sep 2019 22:46:13 +0900
Message-Id: <20190907134613.32230-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
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
[  327.477830] ============================================
[  327.477830] WARNING: possible recursive locking detected
[  327.477830] 5.3.0-rc7+ #322 Not tainted
[  327.477830] --------------------------------------------
[  327.477830] ip/1399 is trying to acquire lock:
[  327.477830] 00000000f604be63 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  327.477830]
[  327.477830] but task is already holding lock:
[  327.477830] 00000000e9d31238 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  327.477830]
[  327.477830] other info that might help us debug this:
[  327.477830]  Possible unsafe locking scenario:
[  327.477830]
[  327.477830]        CPU0
[  327.477830]        ----
[  327.477830]   lock(&(&bond->stats_lock)->rlock#2/2);
[  327.477830]   lock(&(&bond->stats_lock)->rlock#2/2);
[  327.477830]
[  327.477830]  *** DEADLOCK ***
[  327.477830]
[  327.477830]  May be due to missing lock nesting notation
[  327.477830]
[  327.477830] 3 locks held by ip/1399:
[  327.477830]  #0: 00000000a762c4e3 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x466/0x8a0
[  327.477830]  #1: 00000000e9d31238 (&(&bond->stats_lock)->rlock#2/2){+.+.}, at: bond_get_stats+0xb8/0x500 [bonding]
[  327.477830]  #2: 000000008f7ebff4 (rcu_read_lock){....}, at: bond_get_stats+0x9f/0x500 [bonding]
[  327.477830]
[  327.477830] stack backtrace:
[  327.477830] CPU: 0 PID: 1399 Comm: ip Not tainted 5.3.0-rc7+ #322
[  327.477830] Call Trace:
[  327.477830]  dump_stack+0x7c/0xbb
[  327.477830]  __lock_acquire+0x26a9/0x3de0
[  327.477830]  ? __change_page_attr_set_clr+0x133b/0x1d20
[  327.477830]  ? register_lock_class+0x14d0/0x14d0
[  327.477830]  lock_acquire+0x164/0x3b0
[  327.477830]  ? bond_get_stats+0xb8/0x500 [bonding]
[  327.666914]  _raw_spin_lock_nested+0x2e/0x60
[  327.666914]  ? bond_get_stats+0xb8/0x500 [bonding]
[  327.678302]  bond_get_stats+0xb8/0x500 [bonding]
[  327.678302]  ? bond_arp_rcv+0xf10/0xf10 [bonding]
[  327.678302]  ? register_lock_class+0x14d0/0x14d0
[  327.678302]  ? bond_get_stats+0xb8/0x500 [bonding]
[  327.678302]  dev_get_stats+0x1ec/0x270
[  327.678302]  bond_get_stats+0x1d1/0x500 [bonding]
[  327.678302]  ? lock_acquire+0x164/0x3b0
[  327.678302]  ? bond_arp_rcv+0xf10/0xf10 [bonding]
[  327.678302]  ? rtnl_is_locked+0x16/0x30
[  327.678302]  ? devlink_compat_switch_id_get+0x18/0x140
[  327.678302]  ? dev_get_alias+0xe2/0x190
[  327.731145]  ? dev_get_port_parent_id+0x12a/0x340
[  327.731145]  ? rtnl_phys_switch_id_fill+0x88/0xe0
[  327.731145]  dev_get_stats+0x1ec/0x270
[  327.731145]  rtnl_fill_stats+0x44/0xbe0
[  327.731145]  ? nla_put+0xc2/0x140
[  ... ]

Fixes: d3fff6c443fe ("net: add netdev_lockdep_set_classes() helper")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

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

