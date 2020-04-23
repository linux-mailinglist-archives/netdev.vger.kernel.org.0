Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5B11B5BE9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgDWM4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:25 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57454 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728526AbgDWM4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:07 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw1w003234;
        Thu, 23 Apr 2020 15:55:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 08/16] bonding: Add array of all slaves
Date:   Thu, 23 Apr 2020 15:55:47 +0300
Message-Id: <20200423125555.21759-9-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep all slaves in array so it could be used to get the xmit slave
assume all the slaves are active.
The logic to add slave to the array is like the usable slaves, except
that we also add slaves that currently can't transmit - not up or active.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 78 +++++++++++++++++++++++++--------
 include/net/bonding.h           |  3 +-
 2 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1b0ae750d732..2de693f0262e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4120,6 +4120,38 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
 	}
 }
 
+static void bond_set_slave_arr(struct bonding *bond,
+			       struct bond_up_slave *usable_slaves,
+			       struct bond_up_slave *all_slaves)
+{
+	struct bond_up_slave *usable, *all;
+
+	usable = rtnl_dereference(bond->usable_slaves);
+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
+	kfree_rcu(usable, rcu);
+
+	all = rtnl_dereference(bond->all_slaves);
+	rcu_assign_pointer(bond->all_slaves, all_slaves);
+	kfree_rcu(all, rcu);
+}
+
+static void bond_reset_slave_arr(struct bonding *bond)
+{
+	struct bond_up_slave *usable, *all;
+
+	usable = rtnl_dereference(bond->usable_slaves);
+	if (usable) {
+		RCU_INIT_POINTER(bond->usable_slaves, NULL);
+		kfree_rcu(usable, rcu);
+	}
+
+	all = rtnl_dereference(bond->all_slaves);
+	if (all) {
+		RCU_INIT_POINTER(bond->all_slaves, NULL);
+		kfree_rcu(all, rcu);
+	}
+}
+
 /* Build the usable slaves array in control path for modes that use xmit-hash
  * to determine the slave interface -
  * (a) BOND_MODE_8023AD
@@ -4130,7 +4162,7 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
  */
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 {
-	struct bond_up_slave *usable_slaves, *old_usable_slaves;
+	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
 	struct slave *slave;
 	struct list_head *iter;
 	int agg_id = 0;
@@ -4142,7 +4174,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 
 	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
 					    bond->slave_cnt), GFP_KERNEL);
-	if (!usable_slaves) {
+	all_slaves = kzalloc(struct_size(all_slaves, arr,
+					 bond->slave_cnt), GFP_KERNEL);
+	if (!usable_slaves || !all_slaves) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4151,20 +4185,19 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 
 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
 			pr_debug("bond_3ad_get_active_agg_info failed\n");
-			kfree_rcu(usable_slaves, rcu);
 			/* No active aggragator means it's not safe to use
 			 * the previous array.
 			 */
-			old_usable_slaves = rtnl_dereference(bond->usable_slaves);
-			if (old_usable_slaves) {
-				RCU_INIT_POINTER(bond->usable_slaves, NULL);
-				kfree_rcu(old_usable_slaves, rcu);
-			}
+			bond_reset_slave_arr(bond);
 			goto out;
 		}
 		agg_id = ad_info.aggregator_id;
 	}
 	bond_for_each_slave(bond, slave, iter) {
+		if (skipslave == slave)
+			continue;
+
+		all_slaves->arr[all_slaves->count++] = slave;
 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 			struct aggregator *agg;
 
@@ -4174,8 +4207,6 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 		}
 		if (!bond_slave_can_tx(slave))
 			continue;
-		if (skipslave == slave)
-			continue;
 
 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
 			  usable_slaves->count);
@@ -4183,14 +4214,17 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 		usable_slaves->arr[usable_slaves->count++] = slave;
 	}
 
-	old_usable_slaves = rtnl_dereference(bond->usable_slaves);
-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
-	if (old_usable_slaves)
-		kfree_rcu(old_usable_slaves, rcu);
+	bond_set_slave_arr(bond, usable_slaves, all_slaves);
+	return ret;
 out:
-	if (ret != 0 && skipslave)
+	if (ret != 0 && skipslave) {
+		bond_skip_slave(rtnl_dereference(bond->all_slaves),
+				skipslave);
 		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
 				skipslave);
+	}
+	kfree_rcu(all_slaves, rcu);
+	kfree_rcu(usable_slaves, rcu);
 
 	return ret;
 }
@@ -4501,9 +4535,9 @@ void bond_setup(struct net_device *bond_dev)
 static void bond_uninit(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct bond_up_slave *usable, *all;
 	struct list_head *iter;
 	struct slave *slave;
-	struct bond_up_slave *arr;
 
 	bond_netpoll_cleanup(bond_dev);
 
@@ -4512,10 +4546,16 @@ static void bond_uninit(struct net_device *bond_dev)
 		__bond_release_one(bond_dev, slave->dev, true, true);
 	netdev_info(bond_dev, "Released all slaves\n");
 
-	arr = rtnl_dereference(bond->usable_slaves);
-	if (arr) {
+	usable = rtnl_dereference(bond->usable_slaves);
+	if (usable) {
 		RCU_INIT_POINTER(bond->usable_slaves, NULL);
-		kfree_rcu(arr, rcu);
+		kfree_rcu(usable, rcu);
+	}
+
+	all = rtnl_dereference(bond->all_slaves);
+	if (all) {
+		RCU_INIT_POINTER(bond->all_slaves, NULL);
+		kfree_rcu(all, rcu);
 	}
 
 	list_del(&bond->bond_list);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 33bdb6d5182d..b5e49bedbc9f 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -200,7 +200,8 @@ struct bonding {
 	struct   slave __rcu *curr_active_slave;
 	struct   slave __rcu *current_arp_slave;
 	struct   slave __rcu *primary_slave;
-	struct   bond_up_slave __rcu *usable_slaves; /* Array of usable slaves */
+	struct   bond_up_slave __rcu *usable_slaves;
+	struct   bond_up_slave __rcu *all_slaves;
 	bool     force_primary;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
-- 
2.17.2

