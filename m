Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A381B5BD9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgDWM4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60444 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728450AbgDWM4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:02 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw1t003234;
        Thu, 23 Apr 2020 15:55:58 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 05/16] bonding: Add helper function to get the xmit slave based on hash
Date:   Thu, 23 Apr 2020 15:55:44 +0300
Message-Id: <20200423125555.21759-6-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both xor and 802.3ad modes use bond_xmit_hash to get the xmit slave.
Export the logic to helper function so it could be used in the
following patches by the .ndo to get the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2cb41d480ae2..8e6305955c75 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4185,6 +4185,23 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	return ret;
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
 /* Use this Xmit function for 3AD as well as XOR modes. The current
  * usable slave array is formed in the control path. The xmit function
  * just calculates hash and sends the packet out.
@@ -4193,18 +4210,15 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
-	struct slave *slave;
 	struct bond_up_slave *slaves;
-	unsigned int count;
+	struct slave *slave;
 
 	slaves = rcu_dereference(bond->usable_slaves);
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
-- 
2.17.2

