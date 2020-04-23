Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE181B5BDA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgDWM4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:04 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60438 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728448AbgDWM4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:02 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:58 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw1p003234;
        Thu, 23 Apr 2020 15:55:58 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 01/16] net/core: Introduce netdev_get_xmit_slave
Date:   Thu, 23 Apr 2020 15:55:40 +0300
Message-Id: <20200423125555.21759-2-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
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
 net/core/dev.c            | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

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
index 9c9e763bfe0e..e6c10980abfd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7785,6 +7785,28 @@ void netdev_bonding_info_change(struct net_device *dev,
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

