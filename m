Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4067A1B3A50
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgDVIkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:40:06 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36694 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgDVIkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:40:03 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Apr 2020 11:39:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03M8dxgd006118;
        Wed, 22 Apr 2020 11:39:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V4 mlx5-next 01/15] net/core: Introduce netdev_get_xmit_slave
Date:   Wed, 22 Apr 2020 11:39:37 +0300
Message-Id: <20200422083951.17424-2-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200422083951.17424-1-maorg@mellanox.com>
References: <20200422083951.17424-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ndo to get the xmit slave of master device.
Caller should call dev_put() when it no longer works with
slave netdevice.
User can ask to get the xmit slave assume all the slaves can
transmit by set all_slaves arg to true.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 include/linux/netdevice.h |  6 ++++++
 net/core/dev.c            | 30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..d1206f08e099 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1389,6 +1389,9 @@ struct net_device_ops {
 						 struct netlink_ext_ack *extack);
 	int			(*ndo_del_slave)(struct net_device *dev,
 						 struct net_device *slave_dev);
+	struct net_device*	(*ndo_get_xmit_slave)(struct net_device *dev,
+						      struct sk_buff *skb,
+						      bool all_slaves);
 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
@@ -2731,6 +2734,9 @@ void netdev_freemem(struct net_device *dev);
 void synchronize_net(void);
 int init_dummy_netdev(struct net_device *dev);
 
+struct net_device *netdev_get_xmit_slave(struct net_device *dev,
+					 struct sk_buff *skb,
+					 bool all_slaves);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
diff --git a/net/core/dev.c b/net/core/dev.c
index 9c9e763bfe0e..294553551ba5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7785,6 +7785,36 @@ void netdev_bonding_info_change(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_bonding_info_change);
 
+/**
+ * netdev_get_xmit_slave - Get the xmit slave of master device
+ * @skb: The packet
+ * @all_slaves: assume all the slaves are active
+ *
+ * This can be called from any context and does its own locking.
+ * The returned handle has the usage count incremented and the caller must
+ * use dev_put() to release it when it is no longer needed.
+ * %NULL is returned if no slave is found.
+ */
+
+struct net_device *netdev_get_xmit_slave(struct net_device *dev,
+					 struct sk_buff *skb,
+					 bool all_slaves)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct net_device *slave_dev;
+
+	if (!ops->ndo_get_xmit_slave)
+		return NULL;
+
+	rcu_read_lock();
+	slave_dev = ops->ndo_get_xmit_slave(dev, skb, all_slaves);
+	if (slave_dev)
+		dev_hold(slave_dev);
+	rcu_read_unlock();
+	return slave_dev;
+}
+EXPORT_SYMBOL(netdev_get_xmit_slave);
+
 static void netdev_adjacent_add_links(struct net_device *dev)
 {
 	struct netdev_adjacent *iter;
-- 
2.17.2

