Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A451B23D2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgDUK25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:28:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60580 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728513AbgDUK24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:28:56 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Apr 2020 13:28:53 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03LASrmr019072;
        Tue, 21 Apr 2020 13:28:53 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V3 mlx5-next 05/15] bonding: Add helper function to get the xmit slave based on hash
Date:   Tue, 21 Apr 2020 13:28:34 +0300
Message-Id: <20200421102844.23640-6-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200421102844.23640-1-maorg@mellanox.com>
References: <20200421102844.23640-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both xor and 802.3ad modes use bond_xmit_hash to get the xmit slave.
Export the logic to helper function so it could be used in the
following patches by the .ndo to get the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
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

