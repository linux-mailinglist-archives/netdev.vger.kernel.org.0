Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607AD149ABE
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgAZNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:21:35 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43675 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726275AbgAZNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:21:34 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jan 2020 15:21:29 +0200
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00QDLTp6002251;
        Sun, 26 Jan 2020 15:21:29 +0200
From:   Maor Gottlieb <maorg@mellanox.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@mellanox.com, davem@davemloft.net
Cc:     Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        saeedm@mellanox.com, jgg@mellanox.com, leonro@mellanox.com,
        alexr@mellanox.com, markz@mellanox.com, parav@mellanox.com,
        eranbe@mellanox.com, linux-rdma@vger.kernel.org
Subject: [RFC PATCH 3/4] bonding: Add helpers to get xmit slave
Date:   Sun, 26 Jan 2020 15:21:25 +0200
Message-Id: <20200126132126.9981-4-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200126132126.9981-1-maorg@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helpers will be used by both the xmit function
and the get xmit slave ndo.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 drivers/net/bonding/bond_alb.c  | 37 +++++++++----
 drivers/net/bonding/bond_main.c | 94 +++++++++++++++++++++------------
 include/net/bond_alb.h          |  4 ++
 3 files changed, 90 insertions(+), 45 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 15ff1d1999f7..5bf097404062 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1334,11 +1334,11 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 	return NETDEV_TX_OK;
 }
 
-netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
+struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
+				      struct sk_buff *skb)
 {
-	struct bonding *bond = netdev_priv(bond_dev);
-	struct ethhdr *eth_data;
 	struct slave *tx_slave = NULL;
+	struct ethhdr *eth_data;
 	u32 hash_index;
 
 	skb_reset_mac_header(skb);
@@ -1369,21 +1369,30 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			break;
 		}
 	}
-	return bond_do_alb_xmit(skb, bond, tx_slave);
+	return tx_slave;
 }
 
-netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
+netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct ethhdr *eth_data;
+	struct slave *tx_slave;
+
+	tx_slave = bond_xmit_tlb_slave_get(bond, skb);
+	return bond_do_alb_xmit(skb, bond, tx_slave);
+}
+
+struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
+				      struct sk_buff *skb)
+{
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct slave *tx_slave = NULL;
 	static const __be32 ip_bcast = htonl(0xffffffff);
-	int hash_size = 0;
-	bool do_tx_balance = true;
-	u32 hash_index = 0;
+	struct slave *tx_slave = NULL;
 	const u8 *hash_start = NULL;
+	bool do_tx_balance = true;
+	struct ethhdr *eth_data;
 	struct ipv6hdr *ip6hdr;
+	u32 hash_index = 0;
+	int hash_size = 0;
 
 	skb_reset_mac_header(skb);
 	eth_data = eth_hdr(skb);
@@ -1481,7 +1490,15 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 						       count];
 		}
 	}
+	return tx_slave;
+}
+
+netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
+{
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *tx_slave = NULL;
 
+	tx_slave = bond_xmit_alb_slave_get(bond, skb);
 	return bond_do_alb_xmit(skb, bond, tx_slave);
 }
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 14a592824f0c..adab1e3549ff 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -82,6 +82,7 @@
 #include <net/bonding.h>
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
+#include <net/lag.h>
 
 #include "bonding_priv.h"
 
@@ -3406,10 +3407,26 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 		(__force u32)flow_get_u32_src(&flow);
 	hash ^= (hash >> 16);
 	hash ^= (hash >> 8);
-
 	return hash >> 1;
 }
 
+static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
+						 struct sk_buff *skb,
+						 struct bond_up_slave *slaves)
+{
+	struct slave *slave;
+	unsigned int count;
+	u32 hash;
+
+	hash = bond_xmit_hash(bond, skb);
+	count = slaves ? READ_ONCE(slaves->count) : 0;
+	if (unlikely(!count))
+		return NULL;
+
+	slave = slaves->arr[hash % count];
+	return slave;
+}
+
 /*-------------------------- Device entry points ----------------------------*/
 
 void bond_work_init_all(struct bonding *bond)
@@ -3874,16 +3891,15 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 }
 
 /**
- * bond_xmit_slave_id - transmit skb through slave with slave_id
+ * bond_get_slave_by_id - get xmit slave with slave_id
  * @bond: bonding device that is transmitting
- * @skb: buffer to transmit
  * @slave_id: slave id up to slave_cnt-1 through which to transmit
  *
- * This function tries to transmit through slave with slave_id but in case
+ * This function tries to get slave with slave_id but in case
  * it fails, it tries to find the first available slave for transmission.
- * The skb is consumed in all cases, thus the function is void.
  */
-static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int slave_id)
+static struct slave *bond_get_slave_by_id(struct bonding *bond,
+					  int slave_id)
 {
 	struct list_head *iter;
 	struct slave *slave;
@@ -3892,10 +3908,8 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
 	/* Here we start from the slave with slave_id */
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (--i < 0) {
-			if (bond_slave_can_tx(slave)) {
-				bond_dev_queue_xmit(bond, skb, slave->dev);
-				return;
-			}
+			if (bond_slave_can_tx(slave))
+				return slave;
 		}
 	}
 
@@ -3904,13 +3918,11 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (--i < 0)
 			break;
-		if (bond_slave_can_tx(slave)) {
-			bond_dev_queue_xmit(bond, skb, slave->dev);
-			return;
-		}
+		if (bond_slave_can_tx(slave))
+			return slave;
 	}
-	/* no slave that can tx has been found */
-	bond_tx_drop(bond->dev, skb);
+
+	return NULL;
 }
 
 /**
@@ -3946,10 +3958,9 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
 	return slave_id;
 }
 
-static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
-					struct net_device *bond_dev)
+static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
+						    struct sk_buff *skb)
 {
-	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	int slave_cnt;
 	u32 slave_id;
@@ -3971,24 +3982,40 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 		if (iph->protocol == IPPROTO_IGMP) {
 			slave = rcu_dereference(bond->curr_active_slave);
 			if (slave)
-				bond_dev_queue_xmit(bond, skb, slave->dev);
-			else
-				bond_xmit_slave_id(bond, skb, 0);
-			return NETDEV_TX_OK;
+				return slave;
+			return bond_get_slave_by_id(bond, 0);
 		}
 	}
 
 non_igmp:
 	slave_cnt = READ_ONCE(bond->slave_cnt);
 	if (likely(slave_cnt)) {
-		slave_id = bond_rr_gen_slave_id(bond);
-		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-	} else {
-		bond_tx_drop(bond_dev, skb);
+		slave_id = bond_rr_gen_slave_id(bond) % slave_cnt;
+		return bond_get_slave_by_id(bond, slave_id);
 	}
+	return NULL;
+}
+
+static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
+					struct net_device *bond_dev)
+{
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave;
+
+	slave = bond_xmit_roundrobin_slave_get(bond, skb);
+	if (slave)
+		bond_dev_queue_xmit(bond, skb, slave->dev);
+	else
+		bond_tx_drop(bond_dev, skb);
 	return NETDEV_TX_OK;
 }
 
+static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
+						      struct sk_buff *skb)
+{
+	return rcu_dereference(bond->curr_active_slave);
+}
+
 /* In active-backup mode, we know that bond->curr_active_slave is always valid if
  * the bond has a usable interface.
  */
@@ -3998,7 +4025,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 
-	slave = rcu_dereference(bond->curr_active_slave);
+	slave = bond_xmit_activebackup_slave_get(bond, skb);
 	if (slave)
 		bond_dev_queue_xmit(bond, skb, slave->dev);
 	else
@@ -4145,18 +4172,15 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
-	struct slave *slave;
 	struct bond_up_slave *slaves;
-	unsigned int count;
+	struct slave *slave;
 
 	slaves = rcu_dereference(bond->active_slaves);
-	count = slaves ? READ_ONCE(slaves->count) : 0;
-	if (likely(count)) {
-		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
+	slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
+	if (likely(slave))
 		bond_dev_queue_xmit(bond, skb, slave->dev);
-	} else {
+	else
 		bond_tx_drop(dev, skb);
-	}
 
 	return NETDEV_TX_OK;
 }
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index b3504fcd773d..f6af76c87a6c 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -158,6 +158,10 @@ void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char
 void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
 int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
+				      struct sk_buff *skb);
+struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
+				      struct sk_buff *skb);
 void bond_alb_monitor(struct work_struct *);
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
 void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
-- 
2.17.2

