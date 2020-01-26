Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FB6149AC2
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgAZNVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:21:41 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39275 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729240AbgAZNVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:21:37 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jan 2020 15:21:29 +0200
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00QDLTp5002251;
        Sun, 26 Jan 2020 15:21:29 +0200
From:   Maor Gottlieb <maorg@mellanox.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@mellanox.com, davem@davemloft.net
Cc:     Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        saeedm@mellanox.com, jgg@mellanox.com, leonro@mellanox.com,
        alexr@mellanox.com, markz@mellanox.com, parav@mellanox.com,
        eranbe@mellanox.com, linux-rdma@vger.kernel.org
Subject: [RFC PATCH 2/4] bonding: Rename slave_arr to active_slaves
Date:   Sun, 26 Jan 2020 15:21:24 +0200
Message-Id: <20200126132126.9981-3-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200126132126.9981-1-maorg@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch does renaming of slave_arr to active_slaves, since we will
have two arrays, one for the active slaves and the second to all
slaves.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 drivers/net/bonding/bond_alb.c  |  4 +-
 drivers/net/bonding/bond_main.c | 84 ++++++++++++++++++---------------
 include/net/bonding.h           |  2 +-
 3 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 4f2e6910c623..15ff1d1999f7 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1360,7 +1360,7 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 				struct bond_up_slave *slaves;
 				unsigned int count;
 
-				slaves = rcu_dereference(bond->slave_arr);
+				slaves = rcu_dereference(bond->active_slaves);
 				count = slaves ? READ_ONCE(slaves->count) : 0;
 				if (likely(count))
 					tx_slave = slaves->arr[hash_index %
@@ -1474,7 +1474,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			struct bond_up_slave *slaves;
 			unsigned int count;
 
-			slaves = rcu_dereference(bond->slave_arr);
+			slaves = rcu_dereference(bond->active_slaves);
 			count = slaves ? READ_ONCE(slaves->count) : 0;
 			if (likely(count))
 				tx_slave = slaves->arr[bond_xmit_hash(bond, skb) %
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 48d5ec770b94..14a592824f0c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4038,6 +4038,29 @@ static void bond_slave_arr_handler(struct work_struct *work)
 	bond_slave_arr_work_rearm(bond, 1);
 }
 
+static void bond_skip_slave(struct bond_up_slave *slaves,
+			    struct slave *skipslave)
+{
+	int idx;
+
+	/* Rare situation where caller has asked to skip a specific
+	 * slave but allocation failed (most likely!). BTW this is
+	 * only possible when the call is initiated from
+	 * __bond_release_one(). In this situation; overwrite the
+	 * skipslave entry in the array with the last entry from the
+	 * array to avoid a situation where the xmit path may choose
+	 * this to-be-skipped slave to send a packet out.
+	 */
+	for (idx = 0; slaves && idx < slaves->count; idx++) {
+		if (skipslave == slaves->arr[idx]) {
+			slaves->arr[idx] =
+				slaves->arr[slaves->count - 1];
+			slaves->count--;
+			break;
+		}
+	}
+}
+
 /* Build the usable slaves array in control path for modes that use xmit-hash
  * to determine the slave interface -
  * (a) BOND_MODE_8023AD
@@ -4048,9 +4071,9 @@ static void bond_slave_arr_handler(struct work_struct *work)
  */
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 {
+	struct bond_up_slave *active_slaves, *old_active_slaves;
 	struct slave *slave;
 	struct list_head *iter;
-	struct bond_up_slave *new_arr, *old_arr;
 	int agg_id = 0;
 	int ret = 0;
 
@@ -4058,9 +4081,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	WARN_ON(lockdep_is_held(&bond->mode_lock));
 #endif
 
-	new_arr = kzalloc(offsetof(struct bond_up_slave, arr[bond->slave_cnt]),
-			  GFP_KERNEL);
-	if (!new_arr) {
+	active_slaves = kzalloc(struct_size(active_slaves, arr,
+					    bond->slave_cnt), GFP_KERNEL);
+	if (!active_slaves) {
 		ret = -ENOMEM;
 		pr_err("Failed to build slave-array.\n");
 		goto out;
@@ -4070,14 +4093,14 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 
 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
 			pr_debug("bond_3ad_get_active_agg_info failed\n");
-			kfree_rcu(new_arr, rcu);
+			kfree_rcu(active_slaves, rcu);
 			/* No active aggragator means it's not safe to use
 			 * the previous array.
 			 */
-			old_arr = rtnl_dereference(bond->slave_arr);
-			if (old_arr) {
-				RCU_INIT_POINTER(bond->slave_arr, NULL);
-				kfree_rcu(old_arr, rcu);
+			old_active_slaves = rtnl_dereference(bond->active_slaves);
+			if (old_active_slaves) {
+				RCU_INIT_POINTER(bond->active_slaves, NULL);
+				kfree_rcu(old_active_slaves, rcu);
 			}
 			goto out;
 		}
@@ -4097,37 +4120,20 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 			continue;
 
 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
-			  new_arr->count);
+			  active_slaves->count);
 
-		new_arr->arr[new_arr->count++] = slave;
+		active_slaves->arr[active_slaves->count++] = slave;
 	}
 
-	old_arr = rtnl_dereference(bond->slave_arr);
-	rcu_assign_pointer(bond->slave_arr, new_arr);
-	if (old_arr)
-		kfree_rcu(old_arr, rcu);
+	old_active_slaves = rtnl_dereference(bond->active_slaves);
+	rcu_assign_pointer(bond->active_slaves, active_slaves);
+	if (old_active_slaves)
+		kfree_rcu(old_active_slaves, rcu);
 out:
-	if (ret != 0 && skipslave) {
-		int idx;
-
-		/* Rare situation where caller has asked to skip a specific
-		 * slave but allocation failed (most likely!). BTW this is
-		 * only possible when the call is initiated from
-		 * __bond_release_one(). In this situation; overwrite the
-		 * skipslave entry in the array with the last entry from the
-		 * array to avoid a situation where the xmit path may choose
-		 * this to-be-skipped slave to send a packet out.
-		 */
-		old_arr = rtnl_dereference(bond->slave_arr);
-		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
-			if (skipslave == old_arr->arr[idx]) {
-				old_arr->arr[idx] =
-				    old_arr->arr[old_arr->count-1];
-				old_arr->count--;
-				break;
-			}
-		}
-	}
+	if (ret != 0 && skipslave)
+		bond_skip_slave(rtnl_dereference(bond->active_slaves),
+				skipslave);
+
 	return ret;
 }
 
@@ -4143,7 +4149,7 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 	struct bond_up_slave *slaves;
 	unsigned int count;
 
-	slaves = rcu_dereference(bond->slave_arr);
+	slaves = rcu_dereference(bond->active_slaves);
 	count = slaves ? READ_ONCE(slaves->count) : 0;
 	if (likely(count)) {
 		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
@@ -4435,9 +4441,9 @@ static void bond_uninit(struct net_device *bond_dev)
 		__bond_release_one(bond_dev, slave->dev, true, true);
 	netdev_info(bond_dev, "Released all slaves\n");
 
-	arr = rtnl_dereference(bond->slave_arr);
+	arr = rtnl_dereference(bond->active_slaves);
 	if (arr) {
-		RCU_INIT_POINTER(bond->slave_arr, NULL);
+		RCU_INIT_POINTER(bond->active_slaves, NULL);
 		kfree_rcu(arr, rcu);
 	}
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 3d56b026bb9e..b77daffc1b52 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -200,7 +200,7 @@ struct bonding {
 	struct   slave __rcu *curr_active_slave;
 	struct   slave __rcu *current_arp_slave;
 	struct   slave __rcu *primary_slave;
-	struct   bond_up_slave __rcu *slave_arr; /* Array of usable slaves */
+	struct   bond_up_slave __rcu *active_slaves; /* Array of usable slaves */
 	bool     force_primary;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
-- 
2.17.2

