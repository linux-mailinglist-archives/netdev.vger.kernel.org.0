Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4041B0378
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDTHyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:54:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56967 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726006AbgDTHyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 03:54:36 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Apr 2020 10:54:30 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03K7sUfA026672;
        Mon, 20 Apr 2020 10:54:30 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V2 mlx5-next 01/10] net/core: Introduce master_xmit_slave_get
Date:   Mon, 20 Apr 2020 10:54:17 +0300
Message-Id: <20200420075426.31462-2-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200420075426.31462-1-maorg@mellanox.com>
References: <20200420075426.31462-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ndo to get the xmit slave of master device.
User should release the slave when it's not longer needed.
When slave selection method is based on hash, then the user can ask to
get the xmit slave assume all the slaves can transmit by setting the
LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 include/linux/netdevice.h |  3 +++
 include/net/lag.h         | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..e8852f3ad0b6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1389,6 +1389,9 @@ struct net_device_ops {
 						 struct netlink_ext_ack *extack);
 	int			(*ndo_del_slave)(struct net_device *dev,
 						 struct net_device *slave_dev);
+	struct net_device*	(*ndo_xmit_get_slave)(struct net_device *master_dev,
+						      struct sk_buff *skb,
+						      u16 flags);
 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
diff --git a/include/net/lag.h b/include/net/lag.h
index 95b880e6fdde..c43b035989c4 100644
--- a/include/net/lag.h
+++ b/include/net/lag.h
@@ -6,6 +6,38 @@
 #include <linux/if_team.h>
 #include <net/bonding.h>
 
+enum lag_get_slaves_flags {
+	LAG_FLAGS_HASH_ALL_SLAVES = 1<<0
+};
+
+/**
+ * master_xmit_slave_get - Get the xmit slave of master device
+ * @skb: The packet
+ * @flags: lag_get_slaves_flags
+ *
+ * This can be called from any context and does its own locking.
+ * The returned handle has the usage count incremented and the caller must
+ * use dev_put() to release it when it is no longer needed.
+ * %NULL is returned if no slave is found.
+ */
+
+static inline
+struct net_device *master_xmit_get_slave(struct net_device *master_dev,
+					 struct sk_buff *skb,
+					 u16 flags)
+{
+	const struct net_device_ops *ops = master_dev->netdev_ops;
+	struct net_device *slave = NULL;
+
+	rcu_read_lock();
+	if (ops->ndo_xmit_get_slave)
+		slave = ops->ndo_xmit_get_slave(master_dev, skb, flags);
+	if (slave)
+		dev_hold(slave);
+	rcu_read_unlock();
+	return slave;
+}
+
 static inline bool net_lag_port_dev_txable(const struct net_device *port_dev)
 {
 	if (netif_is_team_port(port_dev))
-- 
2.17.2

