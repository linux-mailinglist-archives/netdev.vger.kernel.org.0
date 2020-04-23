Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05FD1B5BF7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgDWM4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57423 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726503AbgDWM4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:02 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:58 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw1s003234;
        Thu, 23 Apr 2020 15:55:58 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 04/16] bonding/alb: Add helper functions to get the xmit slave
Date:   Thu, 23 Apr 2020 15:55:43 +0300
Message-Id: <20200423125555.21759-5-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two helper functions to get the xmit slave of bond in alb or tlb
mode. Extract the logic of find the xmit slave from the xmit flow
to function. Xmit flow will xmit through this slave and in the
following patches the new .ndo will call to the helper function
to return the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_alb.c | 35 +++++++++++++++++++++++++---------
 include/net/bond_alb.h         |  4 ++++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 7bb49b049dcc..e863c694c309 100644
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
@@ -1369,20 +1369,29 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
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
+	struct slave *tx_slave = NULL;
+	const u8 *hash_start = NULL;
 	bool do_tx_balance = true;
+	struct ethhdr *eth_data;
 	u32 hash_index = 0;
-	const u8 *hash_start = NULL;
+	int hash_size = 0;
 
 	skb_reset_mac_header(skb);
 	eth_data = eth_hdr(skb);
@@ -1501,7 +1510,15 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
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

