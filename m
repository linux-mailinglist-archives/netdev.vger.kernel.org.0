Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515641B23CD
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgDUK31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:29:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60643 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728616AbgDUK3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:29:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Apr 2020 13:28:54 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03LASrmv019072;
        Tue, 21 Apr 2020 13:28:53 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V3 mlx5-next 09/15] bonding: Implement ndo_get_xmit_slave
Date:   Tue, 21 Apr 2020 13:28:38 +0300
Message-Id: <20200421102844.23640-10-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200421102844.23640-1-maorg@mellanox.com>
References: <20200421102844.23640-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation of ndo_get_xmit_slave. When user set all_slaves
to true, the xmit slave result is based on the hash, then the slave
will be selected from the array of all the slaves.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 drivers/net/bonding/bond_main.c | 43 +++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c37fd57bfcd4..b586a7235652 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4349,6 +4349,48 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return txq;
 }
 
+static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
+					      struct sk_buff *skb,
+					      bool all_slaves)
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
+		if (all_slaves)
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
@@ -4470,6 +4512,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_del_slave		= bond_release,
 	.ndo_fix_features	= bond_fix_features,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_get_xmit_slave	= bond_xmit_get_slave,
 };
 
 static const struct device_type bond_type = {
-- 
2.17.2

