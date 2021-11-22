Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940B44593B0
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhKVRJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:32906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238230AbhKVRJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 12:09:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68EF760249;
        Mon, 22 Nov 2021 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637600790;
        bh=tuBlnQUjwLD8WEkgVD735Fmbbji8ms5Wvq0kwzfpGzQ=;
        h=From:To:Cc:Subject:Date:From;
        b=o5cp13lM8jJrRrRCU4dYRZXLITkozVjWiHhngiQuhO5y1xuyxMGdY1la+B2zf44qy
         I6vUP2UjzlBJjHlna0jqmEluTAq7RUJcQ8RyffY+eUSanP0+sg+I1wWXCl18LEwjzM
         URRrG7STjqbugsTBQRFcnUNZlTVYtoNgM+55tT1pBdDXdVFmqbU9ZhWIY5YoKM15Ei
         IKDjniYeCm5KO5CyGDCqohpw7VKA4BGrLYaUkzY1dtJsFhJVC/G6fogfzqevWTKu8F
         4Ns3z/dyBTrDeuZnZxyynjZePWGJq1P5Q2kgdTUmHOP5qXKouK7+65v+B6JDyedM6R
         RKpsrkEpZXCoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, atenart@kernel.org,
        aroulin@cumulusnetworks.com, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: remove .ndo_change_proto_down
Date:   Mon, 22 Nov 2021 09:06:28 -0800
Message-Id: <20211122170628.446133-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.ndo_change_proto_down was added seemingly to enable out-of-tree
implementations. Over 2.5yrs later we still have no real users
upstream. Hardwire the generic implementation for now, we can
revert once real users materialize. (rocker is a test vehicle,
not a user.)

We need to drop the optimization on the sysfs side, because
unlike ndos priv_flags will be changed at runtime, so we'd
need READ_ONCE/WRITE_ONCE everywhere..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_main.c | 12 -----------
 drivers/net/macvlan.c                     |  3 +--
 drivers/net/vxlan.c                       |  3 +--
 include/linux/netdevice.h                 | 11 ++--------
 net/8021q/vlanproc.c                      |  2 +-
 net/core/dev.c                            | 26 ++++-------------------
 net/core/net-sysfs.c                      |  8 -------
 net/core/rtnetlink.c                      |  3 +--
 8 files changed, 10 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index ba4062881eed..b620470c7905 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1995,17 +1995,6 @@ static int rocker_port_get_phys_port_name(struct net_device *dev,
 	return err ? -EOPNOTSUPP : 0;
 }
 
-static int rocker_port_change_proto_down(struct net_device *dev,
-					 bool proto_down)
-{
-	struct rocker_port *rocker_port = netdev_priv(dev);
-
-	if (rocker_port->dev->flags & IFF_UP)
-		rocker_port_set_enable(rocker_port, !proto_down);
-	rocker_port->dev->proto_down = proto_down;
-	return 0;
-}
-
 static void rocker_port_neigh_destroy(struct net_device *dev,
 				      struct neighbour *n)
 {
@@ -2037,7 +2026,6 @@ static const struct net_device_ops rocker_port_netdev_ops = {
 	.ndo_set_mac_address		= rocker_port_set_mac_address,
 	.ndo_change_mtu			= rocker_port_change_mtu,
 	.ndo_get_phys_port_name		= rocker_port_get_phys_port_name,
-	.ndo_change_proto_down		= rocker_port_change_proto_down,
 	.ndo_neigh_destroy		= rocker_port_neigh_destroy,
 	.ndo_get_port_parent_id		= rocker_port_get_port_parent_id,
 };
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 75b453acd778..6ef5f77be4d0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1171,7 +1171,6 @@ static const struct net_device_ops macvlan_netdev_ops = {
 #endif
 	.ndo_get_iflink		= macvlan_dev_get_iflink,
 	.ndo_features_check	= passthru_features_check,
-	.ndo_change_proto_down  = dev_change_proto_down_generic,
 };
 
 void macvlan_common_setup(struct net_device *dev)
@@ -1182,7 +1181,7 @@ void macvlan_common_setup(struct net_device *dev)
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);
-	dev->priv_flags	       |= IFF_UNICAST_FLT;
+	dev->priv_flags	       |= IFF_UNICAST_FLT | IFF_CHANGE_PROTO_DOWN;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->needs_free_netdev	= true;
 	dev->header_ops		= &macvlan_hard_header_ops;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 82bd794fceb3..fecff0a46612 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3234,7 +3234,6 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_fdb_dump		= vxlan_fdb_dump,
 	.ndo_fdb_get		= vxlan_fdb_get,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
-	.ndo_change_proto_down  = dev_change_proto_down_generic,
 };
 
 static const struct net_device_ops vxlan_netdev_raw_ops = {
@@ -3305,7 +3304,7 @@ static void vxlan_setup(struct net_device *dev)
 	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	netif_keep_dst(dev);
-	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE | IFF_CHANGE_PROTO_DOWN;
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index df049864661d..72e9c2858e1d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1297,11 +1297,6 @@ struct netdev_net_notifier {
  *	TX queue.
  * int (*ndo_get_iflink)(const struct net_device *dev);
  *	Called to get the iflink value of this device.
- * void (*ndo_change_proto_down)(struct net_device *dev,
- *				 bool proto_down);
- *	This function is used to pass protocol port error state information
- *	to the switch driver. The switch driver can react to the proto_down
- *      by doing a phys down on the associated switch port.
  * int (*ndo_fill_metadata_dst)(struct net_device *dev, struct sk_buff *skb);
  *	This function is used to get egress tunnel information for given skb.
  *	This is useful for retrieving outer tunnel header parameters while
@@ -1542,8 +1537,6 @@ struct net_device_ops {
 						      int queue_index,
 						      u32 maxrate);
 	int			(*ndo_get_iflink)(const struct net_device *dev);
-	int			(*ndo_change_proto_down)(struct net_device *dev,
-							 bool proto_down);
 	int			(*ndo_fill_metadata_dst)(struct net_device *dev,
 						       struct sk_buff *skb);
 	void			(*ndo_set_rx_headroom)(struct net_device *dev,
@@ -1646,6 +1639,7 @@ enum netdev_priv_flags {
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
 	IFF_LIVE_RENAME_OK		= 1<<30,
 	IFF_TX_SKB_NO_LINEAR		= 1<<31,
+	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
 
 #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
@@ -1982,7 +1976,7 @@ struct net_device {
 
 	/* Read-mostly cache-line for fast-path access */
 	unsigned int		flags;
-	unsigned int		priv_flags;
+	unsigned long long	priv_flags;
 	const struct net_device_ops *netdev_ops;
 	int			ifindex;
 	unsigned short		gflags;
@@ -3735,7 +3729,6 @@ int dev_get_port_parent_id(struct net_device *dev,
 			   struct netdev_phys_item_id *ppid, bool recurse);
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
 int dev_change_proto_down(struct net_device *dev, bool proto_down);
-int dev_change_proto_down_generic(struct net_device *dev, bool proto_down);
 void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
 				  u32 value);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index ec87dea23719..08bf6c839e25 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -252,7 +252,7 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 
 	stats = dev_get_stats(vlandev, &temp);
 	seq_printf(seq,
-		   "%s  VID: %d	 REORDER_HDR: %i  dev->priv_flags: %hx\n",
+		   "%s  VID: %d	 REORDER_HDR: %i  dev->priv_flags: %llx\n",
 		   vlandev->name, vlan->vlan_id,
 		   (int)(vlan->flags & 1), vlandev->priv_flags);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9c4fc8c3f981..823917de0d2b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8558,35 +8558,17 @@ bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b)
 EXPORT_SYMBOL(netdev_port_same_parent_id);
 
 /**
- *	dev_change_proto_down - update protocol port state information
+ *	dev_change_proto_down - set carrier according to proto_down.
+ *
  *	@dev: device
  *	@proto_down: new value
- *
- *	This info can be used by switch drivers to set the phys state of the
- *	port.
  */
 int dev_change_proto_down(struct net_device *dev, bool proto_down)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
-
-	if (!ops->ndo_change_proto_down)
+	if (!(dev->priv_flags & IFF_CHANGE_PROTO_DOWN))
 		return -EOPNOTSUPP;
 	if (!netif_device_present(dev))
 		return -ENODEV;
-	return ops->ndo_change_proto_down(dev, proto_down);
-}
-EXPORT_SYMBOL(dev_change_proto_down);
-
-/**
- *	dev_change_proto_down_generic - generic implementation for
- * 	ndo_change_proto_down that sets carrier according to
- * 	proto_down.
- *
- *	@dev: device
- *	@proto_down: new value
- */
-int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
-{
 	if (proto_down)
 		netif_carrier_off(dev);
 	else
@@ -8594,7 +8576,7 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
 	dev->proto_down = proto_down;
 	return 0;
 }
-EXPORT_SYMBOL(dev_change_proto_down_generic);
+EXPORT_SYMBOL(dev_change_proto_down);
 
 /**
  *	dev_change_proto_down_reason - proto down reason
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4edd58d34f16..affe34d71d31 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -488,14 +488,6 @@ static ssize_t proto_down_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
-	struct net_device *netdev = to_net_dev(dev);
-
-	/* The check is also done in change_proto_down; this helps returning
-	 * early without hitting the trylock/restart in netdev_store.
-	 */
-	if (!netdev->netdev_ops->ndo_change_proto_down)
-		return -EOPNOTSUPP;
-
 	return netdev_store(dev, attr, buf, len, change_proto_down);
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index fd030e02f16d..6f25c0a8aebe 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2539,13 +2539,12 @@ static int do_set_proto_down(struct net_device *dev,
 			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *pdreason[IFLA_PROTO_DOWN_REASON_MAX + 1];
-	const struct net_device_ops *ops = dev->netdev_ops;
 	unsigned long mask = 0;
 	u32 value;
 	bool proto_down;
 	int err;
 
-	if (!ops->ndo_change_proto_down) {
+	if (!(dev->priv_flags & IFF_CHANGE_PROTO_DOWN)) {
 		NL_SET_ERR_MSG(extack,  "Protodown not supported by device");
 		return -EOPNOTSUPP;
 	}
-- 
2.31.1

