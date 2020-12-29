Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D562E7003
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 12:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgL2LmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 06:42:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55467 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726181AbgL2LmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 06:42:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 29 Dec 2020 13:41:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BTBfKQf031596;
        Tue, 29 Dec 2020 13:41:20 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, andy@greyhouse.net,
        vfalico@gmail.com, j.vosburgh@gmail.com,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH RFC net-next 1/6] net: netdevice: Add operation ndo_sk_get_slave
Date:   Tue, 29 Dec 2020 13:40:59 +0200
Message-Id: <20201229114104.7120-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201229114104.7120-1-tariqt@nvidia.com>
References: <20201229114104.7120-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ndo_sk_get_slave returns a slave given a socket.
Additionally, we implement a helper netdev_sk_get_lowest_dev()
to get the lowest slave netdevice.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/netdevice.h |  4 ++++
 net/core/dev.c            | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bf167993c05..5938769c5a97 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1412,6 +1412,8 @@ struct net_device_ops {
 	struct net_device*	(*ndo_get_xmit_slave)(struct net_device *dev,
 						      struct sk_buff *skb,
 						      bool all_slaves);
+	struct net_device*	(*ndo_sk_get_slave)(struct net_device *dev,
+						    struct sock *sk);
 	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
@@ -2876,6 +2878,8 @@ int init_dummy_netdev(struct net_device *dev);
 struct net_device *netdev_get_xmit_slave(struct net_device *dev,
 					 struct sk_buff *skb,
 					 bool all_slaves);
+struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
+					    struct sock *sk);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
diff --git a/net/core/dev.c b/net/core/dev.c
index a46334906c94..a2101945363c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8102,6 +8102,38 @@ struct net_device *netdev_get_xmit_slave(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_get_xmit_slave);
 
+static struct net_device *netdev_sk_get_slave(struct net_device *dev, struct sock *sk)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_sk_get_slave)
+		return NULL;
+	return ops->ndo_sk_get_slave(dev, sk);
+}
+
+/**
+ * netdev_sk_get_lowest_dev - Get the lowest device in chain given device and socket
+ * @dev: device
+ * @sk: the socket
+ *
+ * %NULL is returned if no slave is found.
+ */
+
+struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
+					    struct sock *sk)
+{
+	struct net_device *slave;
+
+	slave = netdev_sk_get_slave(dev, sk);
+	while (slave) {
+		dev = slave;
+		slave = netdev_sk_get_slave(dev, sk);
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL(netdev_sk_get_lowest_dev);
+
 static void netdev_adjacent_add_links(struct net_device *dev)
 {
 	struct netdev_adjacent *iter;
-- 
2.21.0

