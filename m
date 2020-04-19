Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248D71AFAC8
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgDSNkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 09:40:13 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51017 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726061AbgDSNkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 09:40:11 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Apr 2020 16:40:03 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03JDe3Xo019088;
        Sun, 19 Apr 2020 16:40:03 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH mlx5-next 3/9] bonding: Implement ndo_xmit_slave_get
Date:   Sun, 19 Apr 2020 16:39:27 +0300
Message-Id: <20200419133933.28258-4-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200419133933.28258-1-maorg@mellanox.com>
References: <20200419133933.28258-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation of ndo_xmit_slave_get.
When user sets the LAG_FLAGS_HASH_ALL_SLAVES bit and the xmit slave
result is based on the hash, then the slave will be selected from the
array of all the slaves.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 drivers/net/bonding/bond_main.c | 123 +++++++++++++++++++++++++++-----
 include/net/bonding.h           |   1 +
 2 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7e04be86fda8..320bcb1394fd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4137,6 +4137,40 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
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
+	if (usable)
+		kfree_rcu(usable, rcu);
+
+	all = rtnl_dereference(bond->all_slaves);
+	rcu_assign_pointer(bond->all_slaves, all_slaves);
+	if (all)
+		kfree_rcu(all, rcu);
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
@@ -4147,7 +4181,7 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
  */
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 {
-	struct bond_up_slave *usable_slaves, *old_usable_slaves;
+	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
 	struct slave *slave;
 	struct list_head *iter;
 	int agg_id = 0;
@@ -4159,7 +4193,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 
 	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
 					    bond->slave_cnt), GFP_KERNEL);
-	if (!usable_slaves) {
+	all_slaves = kzalloc(struct_size(all_slaves, arr,
+					 bond->slave_cnt), GFP_KERNEL);
+	if (!usable_slaves || !all_slaves) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4168,20 +4204,19 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 
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
 
@@ -4191,8 +4226,6 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 		}
 		if (!bond_slave_can_tx(slave))
 			continue;
-		if (skipslave == slave)
-			continue;
 
 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
 			  usable_slaves->count);
@@ -4200,14 +4233,17 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
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
@@ -4313,6 +4349,48 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return txq;
 }
 
+static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
+					      struct sk_buff *skb,
+					      u16 flags)
+{
+	struct bonding *bond = netdev_priv(master_dev);
+	struct bond_up_slave *slaves;
+	struct slave *slave = NULL;
+
+	switch (BOND_MODE(bond)) {
+	case BOND_MODE_ROUNDROBIN:
+		slave = bond_xmit_roundrobin_slave_get(bond, skb);
+		break;
+	case BOND_MODE_ACTIVEBACKUP:
+		slave = bond_xmit_activebackup_slave_get(bond, skb);
+		break;
+	case BOND_MODE_8023AD:
+	case BOND_MODE_XOR:
+		if (flags & LAG_FLAGS_HASH_ALL_SLAVES)
+			slaves = rcu_dereference(bond->all_slaves);
+		else
+			slaves = rcu_dereference(bond->usable_slaves);
+		slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
+		break;
+	case BOND_MODE_BROADCAST:
+		break;
+	case BOND_MODE_ALB:
+		slave = bond_xmit_alb_slave_get(bond, skb);
+		break;
+	case BOND_MODE_TLB:
+		slave = bond_xmit_tlb_slave_get(bond, skb);
+		break;
+	default:
+		/* Should never happen, mode already checked */
+		WARN_ONCE(true, "Unknown bonding mode");
+		break;
+	}
+
+	if (slave)
+		return slave->dev;
+	return NULL;
+}
+
 static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
@@ -4434,6 +4512,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_del_slave		= bond_release,
 	.ndo_fix_features	= bond_fix_features,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_xmit_get_slave	= bond_xmit_get_slave,
 };
 
 static const struct device_type bond_type = {
@@ -4501,9 +4580,9 @@ void bond_setup(struct net_device *bond_dev)
 static void bond_uninit(struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct bond_up_slave *usable, *all;
 	struct list_head *iter;
 	struct slave *slave;
-	struct bond_up_slave *arr;
 
 	bond_netpoll_cleanup(bond_dev);
 
@@ -4512,10 +4591,16 @@ static void bond_uninit(struct net_device *bond_dev)
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
index 33bdb6d5182d..a2a7f461fa63 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -201,6 +201,7 @@ struct bonding {
 	struct   slave __rcu *current_arp_slave;
 	struct   slave __rcu *primary_slave;
 	struct   bond_up_slave __rcu *usable_slaves; /* Array of usable slaves */
+	struct   bond_up_slave __rcu *all_slaves; /* Array of all slaves */
 	bool     force_primary;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
-- 
2.17.2

