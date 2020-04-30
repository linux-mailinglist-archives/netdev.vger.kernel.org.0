Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927581C061B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgD3TV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:21:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44305 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726366AbgD3TVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:21:55 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Apr 2020 22:21:53 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03UJLqAJ004128;
        Thu, 30 Apr 2020 22:21:52 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V8 mlx5-next 01/16] net/core: Introduce netdev_get_xmit_slave
Date:   Thu, 30 Apr 2020 22:21:31 +0300
Message-Id: <20200430192146.12863-2-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200430192146.12863-1-maorg@mellanox.com>
References: <20200430192146.12863-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ndo to get the xmit slave of master device. The reference
counters are not incremented so the caller must be careful with locks.
User can ask to get the xmit slave assume all the slaves can
transmit by set all_slaves arg to true.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/linux/netdevice.h | 12 ++++++++++++
 net/core/dev.c            | 22 ++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..26bc0f11b7ad 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1146,6 +1146,12 @@ struct netdev_net_notifier {
  * int (*ndo_del_slave)(struct net_device *dev, struct net_device *slave_dev);
  *	Called to release previously enslaved netdev.
  *
+ * struct net_device *(*ndo_get_xmit_slave)(struct net_device *dev,
+ *					    struct sk_buff *skb,
+ *					    bool all_slaves);
+ *	Get the xmit slave of master device. If all_slaves is true, function
+ *	assume all the slaves can transmit.
+ *
  *      Feature/offload setting functions.
  * netdev_features_t (*ndo_fix_features)(struct net_device *dev,
  *		netdev_features_t features);
@@ -1389,6 +1395,9 @@ struct net_device_ops {
 						 struct netlink_ext_ack *extack);
 	int			(*ndo_del_slave)(struct net_device *dev,
 						 struct net_device *slave_dev);
+	struct net_device*	(*ndo_get_xmit_slave)(struct net_device *dev,
+						      struct sk_buff *skb,
+						      bool all_slaves);
 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
@@ -2731,6 +2740,9 @@ void netdev_freemem(struct net_device *dev);
 void synchronize_net(void);
 int init_dummy_netdev(struct net_device *dev);
 
+struct net_device *netdev_get_xmit_slave(struct net_device *dev,
+					 struct sk_buff *skb,
+					 bool all_slaves);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..294e59e20080 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7786,6 +7786,28 @@ void netdev_bonding_info_change(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_bonding_info_change);
 
+/**
+ * netdev_get_xmit_slave - Get the xmit slave of master device
+ * @skb: The packet
+ * @all_slaves: assume all the slaves are active
+ *
+ * The reference counters are not incremented so the caller must be
+ * careful with locks. The caller must hold RCU lock.
+ * %NULL is returned if no slave is found.
+ */
+
+struct net_device *netdev_get_xmit_slave(struct net_device *dev,
+					 struct sk_buff *skb,
+					 bool all_slaves)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_get_xmit_slave)
+		return NULL;
+	return ops->ndo_get_xmit_slave(dev, skb, all_slaves);
+}
+EXPORT_SYMBOL(netdev_get_xmit_slave);
+
 static void netdev_adjacent_add_links(struct net_device *dev)
 {
 	struct netdev_adjacent *iter;
-- 
2.17.2

