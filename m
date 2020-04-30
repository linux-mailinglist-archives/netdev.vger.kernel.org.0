Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E1E1C053A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgD3Suq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:50:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41377 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726819AbgD3Sun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:50:43 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Apr 2020 21:50:37 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03UIoaNa028837;
        Thu, 30 Apr 2020 21:50:37 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V7 mlx5-next 09/11] bonding: Implement ndo_get_xmit_slave
Date:   Thu, 30 Apr 2020 21:50:26 +0300
Message-Id: <20200430185033.11476-10-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200430185033.11476-1-maorg@mellanox.com>
References: <20200430185033.11476-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation of ndo_get_xmit_slave. Find the slave by using the
helper function according to the bond mode. If the caller set all_slaves
to true, then it assumes that all slaves are available to transmit.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/bonding/bond_main.c | 43 +++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2de693f0262e..39b1ad7edbb4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4347,6 +4347,48 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
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
@@ -4468,6 +4510,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_del_slave		= bond_release,
 	.ndo_fix_features	= bond_fix_features,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_get_xmit_slave	= bond_xmit_get_slave,
 };
 
 static const struct device_type bond_type = {
-- 
2.17.2

