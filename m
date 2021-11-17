Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E9454C6D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbhKQRue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239616AbhKQRub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 12:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32C2362F90;
        Wed, 17 Nov 2021 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637171252;
        bh=R5UqN0eO6LTlWmOxysnZEzJ2ekVsBfMFOIPQ1OyV02Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkEvU5F0RMtHEViW5dyJVpFMJcbeaIUKneh2F8aefPfdvVWj/ZBLzEmcSmOuox+Hx
         k49Y0OjrCnIWP0XyTsPaVO229gB0MQiCBfc7b/ZthmbNvMO8LYwWTAdwc2nWOf13kH
         ici1ORCJjcEEt7AetJSH8pXPcGOgx2dS7lzJDtwnOtO8R9xu9POMY9ECcfRBNlPP1k
         5kjCTY+8ekS5iY8kAxc7QicbMYUHKSXA5iDg9xTkSaVpBDeFzQ9eqpzJPfD8s9LKe0
         W5YmkJCMOyKeGpdY05dL5B5vEpnLPFpwBDGwJ358eEoqBnlUbkUF8mXG78W2l6XR3j
         YAos+85GQl83Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 2/2] vlan: use new netdev_refs infra
Date:   Wed, 17 Nov 2021 09:47:23 -0800
Message-Id: <20211117174723.2305681-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117174723.2305681-1-kuba@kernel.org>
References: <20211117174723.2305681-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Example user of the new netdev_refs infra.

VLAN is not the simplest - the ref ptr is stored on the IOCTL path
and netlink path but only taken during netdev registration.

No changes to the assembly output with debug disabled,
save for the few places where explicit temporary variables
were added.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c |  3 +-
 include/linux/if_vlan.h                      | 11 +++-
 net/8021q/vlan.c                             | 13 ++--
 net/8021q/vlan_core.c                        |  4 +-
 net/8021q/vlan_dev.c                         | 63 ++++++++++----------
 net/8021q/vlan_gvrp.c                        |  5 +-
 net/8021q/vlan_mvrp.c                        |  5 +-
 net/8021q/vlan_netlink.c                     |  4 +-
 net/8021q/vlanproc.c                         |  6 +-
 9 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e6a4a768b10b..459c17fc9287 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1250,9 +1250,10 @@ static int bnxt_tc_resolve_tunnel_hdrs(struct bnxt *bp,
 	dst_dev = rt->dst.dev;
 	if (is_vlan_dev(dst_dev)) {
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
+		struct net_device *real_dev = __vlan_dev_real_dev(dst_dev);
 		struct vlan_dev_priv *vlan = vlan_dev_priv(dst_dev);
 
-		if (vlan->real_dev != real_dst_dev) {
+		if (real_dev != real_dst_dev) {
 			netdev_info(bp->dev,
 				    "dst_dev(%s) doesn't use PF-if(%s)\n",
 				    netdev_name(dst_dev),
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 41a518336673..bb46fa2b1327 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -8,6 +8,7 @@
 #define _LINUX_IF_VLAN_H_
 
 #include <linux/netdevice.h>
+#include <linux/netdev_refs.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/bug.h>
@@ -176,7 +177,7 @@ struct vlan_dev_priv {
 	u16					vlan_id;
 	u16					flags;
 
-	struct net_device			*real_dev;
+	struct netdev_ref			real_dev;
 	unsigned char				real_dev_addr[ETH_ALEN];
 
 	struct proc_dir_entry			*dent;
@@ -191,6 +192,14 @@ static inline struct vlan_dev_priv *vlan_dev_priv(const struct net_device *dev)
 	return netdev_priv(dev);
 }
 
+static inline struct net_device *
+__vlan_dev_real_dev(const struct net_device *dev)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+
+	return netdev_ref_ptr(&vlan->real_dev);
+}
+
 static inline u16
 vlan_dev_get_egress_qos_mask(struct net_device *dev, u32 skprio)
 {
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index a3a0a5e994f5..b5a8677e89ad 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -89,7 +89,7 @@ static void vlan_stacked_transfer_operstate(const struct net_device *rootdev,
 void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 	struct vlan_info *vlan_info;
 	struct vlan_group *grp;
 	u16 vlan_id = vlan->vlan_id;
@@ -148,7 +148,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
 int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = __netdev_ref_ptr(&vlan->real_dev);
 	u16 vlan_id = vlan->vlan_id;
 	struct vlan_info *vlan_info;
 	struct vlan_group *grp;
@@ -185,7 +185,7 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 		goto out_unregister_netdev;
 
 	/* Account for reference in struct vlan_dev_priv */
-	dev_hold(real_dev);
+	__netdev_hold_stored(&vlan->real_dev);
 
 	vlan_stacked_transfer_operstate(real_dev, dev, vlan);
 	linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
@@ -272,7 +272,7 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
 	vlan = vlan_dev_priv(new_dev);
 	vlan->vlan_proto = htons(ETH_P_8021Q);
 	vlan->vlan_id = vlan_id;
-	vlan->real_dev = real_dev;
+	__netdev_ref_store(&vlan->real_dev, real_dev);
 	vlan->dent = NULL;
 	vlan->flags = VLAN_FLAG_REORDER_HDR;
 
@@ -321,6 +321,7 @@ static void vlan_transfer_features(struct net_device *dev,
 				   struct net_device *vlandev)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 
 	vlandev->gso_max_size = dev->gso_max_size;
 	vlandev->gso_max_segs = dev->gso_max_segs;
@@ -335,8 +336,8 @@ static void vlan_transfer_features(struct net_device *dev,
 #endif
 
 	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
-	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
-	vlandev->hw_enc_features = vlan_tnl_features(vlan->real_dev);
+	vlandev->priv_flags |= (real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
+	vlandev->hw_enc_features = vlan_tnl_features(real_dev);
 
 	netdev_update_features(vlandev);
 }
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 59bc13b5f14f..ab183724374d 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -101,10 +101,10 @@ EXPORT_SYMBOL(__vlan_find_dev_deep_rcu);
 
 struct net_device *vlan_dev_real_dev(const struct net_device *dev)
 {
-	struct net_device *ret = vlan_dev_priv(dev)->real_dev;
+	struct net_device *ret = __vlan_dev_real_dev(dev);
 
 	while (is_vlan_dev(ret))
-		ret = vlan_dev_priv(ret)->real_dev;
+		ret = __vlan_dev_real_dev(ret);
 
 	return ret;
 }
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ab6dee28536d..c78f2cbc42c3 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -78,7 +78,7 @@ static int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 		saddr = dev->dev_addr;
 
 	/* Now make the underlying real hard header */
-	dev = vlan->real_dev;
+	dev = netdev_ref_ptr(&vlan->real_dev);
 	rc = dev_hard_header(skb, dev, type, daddr, saddr, len + vhdrlen);
 	if (rc > 0)
 		rc += vhdrlen;
@@ -116,7 +116,7 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 		__vlan_hwaccel_put_tag(skb, vlan->vlan_proto, vlan_tci);
 	}
 
-	skb->dev = vlan->real_dev;
+	skb->dev = netdev_ref_ptr(&vlan->real_dev);
 	len = skb->len;
 	if (unlikely(netpoll_tx_running(dev)))
 		return vlan_netpoll_send_skb(vlan, skb);
@@ -140,7 +140,7 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 
 static int vlan_dev_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	unsigned int max_mtu = real_dev->mtu;
 
 	if (netif_reduces_vlan_mtu(real_dev))
@@ -241,7 +241,7 @@ int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
 
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result, size_t size)
 {
-	strscpy_pad(result, vlan_dev_priv(dev)->real_dev->name, size);
+	strscpy_pad(result, __vlan_dev_real_dev(dev)->name, size);
 }
 
 bool vlan_dev_inherit_address(struct net_device *dev,
@@ -258,7 +258,7 @@ bool vlan_dev_inherit_address(struct net_device *dev,
 static int vlan_dev_open(struct net_device *dev)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 	int err;
 
 	if (!(real_dev->flags & IFF_UP) &&
@@ -310,7 +310,7 @@ static int vlan_dev_open(struct net_device *dev)
 static int vlan_dev_stop(struct net_device *dev)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 
 	dev_mc_unsync(real_dev, dev);
 	dev_uc_unsync(real_dev, dev);
@@ -329,7 +329,7 @@ static int vlan_dev_stop(struct net_device *dev)
 
 static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	struct sockaddr *addr = p;
 	int err;
 
@@ -355,7 +355,7 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 
 static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	struct ifreq ifrr;
 	int err = -EOPNOTSUPP;
@@ -385,7 +385,7 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static int vlan_dev_neigh_setup(struct net_device *dev, struct neigh_parms *pa)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int err = 0;
 
@@ -399,7 +399,7 @@ static int vlan_dev_neigh_setup(struct net_device *dev, struct neigh_parms *pa)
 static int vlan_dev_fcoe_ddp_setup(struct net_device *dev, u16 xid,
 				   struct scatterlist *sgl, unsigned int sgc)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int rc = 0;
 
@@ -411,7 +411,7 @@ static int vlan_dev_fcoe_ddp_setup(struct net_device *dev, u16 xid,
 
 static int vlan_dev_fcoe_ddp_done(struct net_device *dev, u16 xid)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int len = 0;
 
@@ -423,7 +423,7 @@ static int vlan_dev_fcoe_ddp_done(struct net_device *dev, u16 xid)
 
 static int vlan_dev_fcoe_enable(struct net_device *dev)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int rc = -EINVAL;
 
@@ -434,7 +434,7 @@ static int vlan_dev_fcoe_enable(struct net_device *dev)
 
 static int vlan_dev_fcoe_disable(struct net_device *dev)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int rc = -EINVAL;
 
@@ -446,7 +446,7 @@ static int vlan_dev_fcoe_disable(struct net_device *dev)
 static int vlan_dev_fcoe_ddp_target(struct net_device *dev, u16 xid,
 				    struct scatterlist *sgl, unsigned int sgc)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int rc = 0;
 
@@ -460,7 +460,7 @@ static int vlan_dev_fcoe_ddp_target(struct net_device *dev, u16 xid,
 #ifdef NETDEV_FCOE_WWNN
 static int vlan_dev_fcoe_get_wwn(struct net_device *dev, u64 *wwn, int type)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	const struct net_device_ops *ops = real_dev->netdev_ops;
 	int rc = -EINVAL;
 
@@ -472,7 +472,7 @@ static int vlan_dev_fcoe_get_wwn(struct net_device *dev, u64 *wwn, int type)
 
 static void vlan_dev_change_rx_flags(struct net_device *dev, int change)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 
 	if (dev->flags & IFF_UP) {
 		if (change & IFF_ALLMULTI)
@@ -484,8 +484,10 @@ static void vlan_dev_change_rx_flags(struct net_device *dev, int change)
 
 static void vlan_dev_set_rx_mode(struct net_device *vlan_dev)
 {
-	dev_mc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
-	dev_uc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
+	struct net_device *real_dev = __vlan_dev_real_dev(vlan_dev);
+
+	dev_mc_sync(real_dev, vlan_dev);
+	dev_uc_sync(real_dev, vlan_dev);
 }
 
 /*
@@ -529,7 +531,7 @@ static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev
 				     unsigned int len)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 
 	if (saddr == NULL)
 		saddr = dev->dev_addr;
@@ -552,7 +554,7 @@ static const struct net_device_ops vlan_netdev_ops;
 static int vlan_dev_init(struct net_device *dev)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 
 	netif_carrier_off(dev);
 
@@ -636,7 +638,7 @@ void vlan_dev_uninit(struct net_device *dev)
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 	netdev_features_t old_features = features;
 	netdev_features_t lower_features;
 
@@ -659,9 +661,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 static int vlan_ethtool_get_link_ksettings(struct net_device *dev,
 					   struct ethtool_link_ksettings *cmd)
 {
-	const struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 
-	return __ethtool_get_link_ksettings(vlan->real_dev, cmd);
+	return __ethtool_get_link_ksettings(real_dev, cmd);
 }
 
 static void vlan_ethtool_get_drvinfo(struct net_device *dev,
@@ -676,13 +678,14 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 				    struct ethtool_ts_info *info)
 {
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
-	struct phy_device *phydev = vlan->real_dev->phydev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
+	const struct ethtool_ops *ops = real_dev->ethtool_ops;
+	struct phy_device *phydev = real_dev->phydev;
 
 	if (phy_has_tsinfo(phydev)) {
 		return phy_ts_info(phydev, info);
 	} else if (ops->get_ts_info) {
-		return ops->get_ts_info(vlan->real_dev, info);
+		return ops->get_ts_info(real_dev, info);
 	} else {
 		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 			SOF_TIMESTAMPING_SOFTWARE;
@@ -735,7 +738,7 @@ static void vlan_dev_poll_controller(struct net_device *dev)
 static int vlan_dev_netpoll_setup(struct net_device *dev, struct netpoll_info *npinfo)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 	struct netpoll *netpoll;
 	int err = 0;
 
@@ -771,7 +774,7 @@ static void vlan_dev_netpoll_cleanup(struct net_device *dev)
 
 static int vlan_dev_get_iflink(const struct net_device *dev)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 
 	return real_dev->ifindex;
 }
@@ -785,7 +788,7 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->encap.id = vlan->vlan_id;
 	path->encap.proto = vlan->vlan_proto;
 	path->dev = ctx->dev;
-	ctx->dev = vlan->real_dev;
+	ctx->dev = netdev_ref_ptr(&vlan->real_dev);
 	if (ctx->num_vlans >= ARRAY_SIZE(ctx->vlan))
 		return -ENOSPC;
 
@@ -845,7 +848,7 @@ static void vlan_dev_free(struct net_device *dev)
 	vlan->vlan_pcpu_stats = NULL;
 
 	/* Get rid of the vlan's reference to real_dev */
-	dev_put(vlan->real_dev);
+	netdev_put(&vlan->real_dev);
 }
 
 void vlan_setup(struct net_device *dev)
diff --git a/net/8021q/vlan_gvrp.c b/net/8021q/vlan_gvrp.c
index 6b34b72aa466..aa8df972f93c 100644
--- a/net/8021q/vlan_gvrp.c
+++ b/net/8021q/vlan_gvrp.c
@@ -31,7 +31,8 @@ int vlan_gvrp_request_join(const struct net_device *dev)
 
 	if (vlan->vlan_proto != htons(ETH_P_8021Q))
 		return 0;
-	return garp_request_join(vlan->real_dev, &vlan_gvrp_app,
+	return garp_request_join(netdev_ref_ptr(&vlan->real_dev),
+				 &vlan_gvrp_app,
 				 &vlan_id, sizeof(vlan_id), GVRP_ATTR_VID);
 }
 
@@ -42,7 +43,7 @@ void vlan_gvrp_request_leave(const struct net_device *dev)
 
 	if (vlan->vlan_proto != htons(ETH_P_8021Q))
 		return;
-	garp_request_leave(vlan->real_dev, &vlan_gvrp_app,
+	garp_request_leave(netdev_ref_ptr(&vlan->real_dev), &vlan_gvrp_app,
 			   &vlan_id, sizeof(vlan_id), GVRP_ATTR_VID);
 }
 
diff --git a/net/8021q/vlan_mvrp.c b/net/8021q/vlan_mvrp.c
index 689eceeaa360..ab534307fb89 100644
--- a/net/8021q/vlan_mvrp.c
+++ b/net/8021q/vlan_mvrp.c
@@ -37,7 +37,8 @@ int vlan_mvrp_request_join(const struct net_device *dev)
 
 	if (vlan->vlan_proto != htons(ETH_P_8021Q))
 		return 0;
-	return mrp_request_join(vlan->real_dev, &vlan_mrp_app,
+	return mrp_request_join(netdev_ref_ptr(&vlan->real_dev),
+				&vlan_mrp_app,
 				&vlan_id, sizeof(vlan_id), MVRP_ATTR_VID);
 }
 
@@ -48,7 +49,7 @@ void vlan_mvrp_request_leave(const struct net_device *dev)
 
 	if (vlan->vlan_proto != htons(ETH_P_8021Q))
 		return;
-	mrp_request_leave(vlan->real_dev, &vlan_mrp_app,
+	mrp_request_leave(netdev_ref_ptr(&vlan->real_dev), &vlan_mrp_app,
 			  &vlan_id, sizeof(vlan_id), MVRP_ATTR_VID);
 }
 
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 0db85aeb119b..7499f73d9961 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -166,7 +166,7 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 
 	vlan->vlan_proto = proto;
 	vlan->vlan_id	 = nla_get_u16(data[IFLA_VLAN_ID]);
-	vlan->real_dev	 = real_dev;
+	__netdev_ref_store(&vlan->real_dev, real_dev);
 	dev->priv_flags |= (real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
 	vlan->flags	 = VLAN_FLAG_REORDER_HDR;
 
@@ -274,7 +274,7 @@ static int vlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 static struct net *vlan_get_link_net(const struct net_device *dev)
 {
-	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+	struct net_device *real_dev = __vlan_dev_real_dev(dev);
 
 	return dev_net(real_dev);
 }
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index ec87dea23719..5784fb5fa2a9 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -231,9 +231,10 @@ static int vlan_seq_show(struct seq_file *seq, void *v)
 	} else {
 		const struct net_device *vlandev = v;
 		const struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
+		struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 
 		seq_printf(seq, "%-15s| %d  | %s\n",  vlandev->name,
-			   vlan->vlan_id,    vlan->real_dev->name);
+			   vlan->vlan_id,    real_dev->name);
 	}
 	return 0;
 }
@@ -242,6 +243,7 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 {
 	struct net_device *vlandev = (struct net_device *) seq->private;
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
+	struct net_device *real_dev = netdev_ref_ptr(&vlan->real_dev);
 	struct rtnl_link_stats64 temp;
 	const struct rtnl_link_stats64 *stats;
 	static const char fmt64[] = "%30s %12llu\n";
@@ -262,7 +264,7 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 	seq_puts(seq, "\n");
 	seq_printf(seq, fmt64, "total frames transmitted", stats->tx_packets);
 	seq_printf(seq, fmt64, "total bytes transmitted", stats->tx_bytes);
-	seq_printf(seq, "Device: %s", vlan->real_dev->name);
+	seq_printf(seq, "Device: %s", real_dev->name);
 	/* now show all PRIORITY mappings relating to this VLAN */
 	seq_printf(seq, "\nINGRESS priority mappings: "
 			"0:%u  1:%u  2:%u  3:%u  4:%u  5:%u  6:%u 7:%u\n",
-- 
2.31.1

