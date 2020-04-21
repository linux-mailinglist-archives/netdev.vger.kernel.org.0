Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C2B1B23B9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgDUK25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:28:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60581 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728490AbgDUK24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:28:56 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Apr 2020 13:28:53 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03LASrmn019072;
        Tue, 21 Apr 2020 13:28:53 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V3 mlx5-next 01/15] net/core: Introduce master_get_xmit_slave
Date:   Tue, 21 Apr 2020 13:28:30 +0300
Message-Id: <20200421102844.23640-2-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200421102844.23640-1-maorg@mellanox.com>
References: <20200421102844.23640-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ndo to get the xmit slave of master device.
User should release the slave when it's not longer needed.
When slave selection method is based on hash, then the user can ask to
get the xmit slave assume all the slaves can transmit.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
---
 include/linux/netdevice.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 130a668049ab..ab324a2b04c8 100644
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
@@ -4676,6 +4679,36 @@ static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 	skb->mac_len = mac_len;
 }
 
+/**
+ * master_get_xmit_slave - Get the xmit slave of master device
+ * @skb: The packet
+ * @all_slaves: assume all the slaves are active
+ *
+ * This can be called from any context and does its own locking.
+ * The returned handle has the usage count incremented and the caller must
+ * use dev_put() to release it when it is no longer needed.
+ * %NULL is returned if no slave is found.
+ */
+
+static inline
+struct net_device *master_get_xmit_slave(struct net_device *dev,
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
+
 static inline bool netif_is_macsec(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_MACSEC;
-- 
2.17.2

