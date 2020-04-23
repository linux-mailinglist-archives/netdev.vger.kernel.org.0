Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59311B5BDE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgDWM4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57422 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728352AbgDWM4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:02 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw1u003234;
        Thu, 23 Apr 2020 15:55:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 06/16] bonding: Add helper function to get the xmit slave in rr mode
Date:   Thu, 23 Apr 2020 15:55:45 +0300
Message-Id: <20200423125555.21759-7-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function to get the xmit slave when bond is in round
robin mode. Change bond_xmit_slave_id to bond_get_slave_by_id, then
the logic for find the next slave for transmit could be used
both by the xmit flow and the .ndo to get the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 56 ++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8e6305955c75..09c8485e965d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3923,16 +3923,15 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
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
@@ -3941,10 +3940,8 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
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
 
@@ -3953,13 +3950,11 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
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
@@ -3995,10 +3990,9 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
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
@@ -4020,21 +4014,31 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
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
 
-- 
2.17.2

