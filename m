Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA01B8D43
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 09:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgDZHRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 03:17:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41443 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgDZHRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 03:17:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Apr 2020 10:17:23 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03Q7HMTD023889;
        Sun, 26 Apr 2020 10:17:22 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V6 mlx5-next 07/16] bonding: Add function to get the xmit slave in active-backup mode
Date:   Sun, 26 Apr 2020 10:17:08 +0300
Message-Id: <20200426071717.17088-8-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200426071717.17088-1-maorg@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function to get the xmit slave in active-backup mode.
It's only one line function that return the curr_active_slave,
but it will used both in the xmit flow and by the new .ndo to get
the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 09c8485e965d..1b0ae750d732 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4042,6 +4042,12 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
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
@@ -4051,7 +4057,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 
-	slave = rcu_dereference(bond->curr_active_slave);
+	slave = bond_xmit_activebackup_slave_get(bond, skb);
 	if (slave)
 		bond_dev_queue_xmit(bond, skb, slave->dev);
 	else
-- 
2.17.2

