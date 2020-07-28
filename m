Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3971F23152A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgG1VsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbgG1VsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 17:48:03 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2F720774;
        Tue, 28 Jul 2020 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595972882;
        bh=4jmIevgc7csXE5wv7vKmwUJe0/ctQBLIV5vXcXgoITo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyUGf9hCNjn4DIQsgwrwzZYFfO0MdJNS/BxXptdI3xDpHNPJGJ5Z8BeuNcs2XBWBW
         ld1dPJkMAzoEBzz0IJxjDoDKf1+SBObAdIcv2Ac0vierZqipZLG5wN4zqSOuZ2QYGV
         STUEXkzTpjdtP1PXowvYeE99uUeo9s9s9OWUWYRQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/2] mlx5: convert to new udp_tunnel infrastructure
Date:   Tue, 28 Jul 2020 14:47:59 -0700
Message-Id: <20200728214759.325418-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728214759.325418-1-kuba@kernel.org>
References: <20200728214759.325418-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate nic_info dynamically - n_entries is not constant.

Attach the tunnel offload info only to the uplink representor.
We expect the "main" netdev to be unregistered in switchdev
mode, and there to be only one uplink representor.

Drop the udp_tunnel_drop_rx_info() call, it was not there until
commit b3c2ed21c0bd ("net/mlx5e: Fix VXLAN configuration restore after function reload")
so the device doesn't need it, and core should handle reloads and
reset just fine.

v2:
 - don't drop the ndos on reprs, and register info on uplink repr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 88 ++-----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  7 +-
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 87 +++++++++---------
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |  6 +-
 5 files changed, 55 insertions(+), 135 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c44669102626..c3e399f3e834 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1113,8 +1113,6 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
 
-void mlx5e_add_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti);
-void mlx5e_del_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti);
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 				       struct net_device *netdev,
 				       netdev_features_t features);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9d5d8b28bcd8..fe2fd3e58cbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4214,83 +4214,6 @@ int mlx5e_get_vf_stats(struct net_device *dev,
 }
 #endif
 
-struct mlx5e_vxlan_work {
-	struct work_struct	work;
-	struct mlx5e_priv	*priv;
-	u16			port;
-};
-
-static void mlx5e_vxlan_add_work(struct work_struct *work)
-{
-	struct mlx5e_vxlan_work *vxlan_work =
-		container_of(work, struct mlx5e_vxlan_work, work);
-	struct mlx5e_priv *priv = vxlan_work->priv;
-	u16 port = vxlan_work->port;
-
-	mutex_lock(&priv->state_lock);
-	mlx5_vxlan_add_port(priv->mdev->vxlan, port);
-	mutex_unlock(&priv->state_lock);
-
-	kfree(vxlan_work);
-}
-
-static void mlx5e_vxlan_del_work(struct work_struct *work)
-{
-	struct mlx5e_vxlan_work *vxlan_work =
-		container_of(work, struct mlx5e_vxlan_work, work);
-	struct mlx5e_priv *priv         = vxlan_work->priv;
-	u16 port = vxlan_work->port;
-
-	mutex_lock(&priv->state_lock);
-	mlx5_vxlan_del_port(priv->mdev->vxlan, port);
-	mutex_unlock(&priv->state_lock);
-	kfree(vxlan_work);
-}
-
-static void mlx5e_vxlan_queue_work(struct mlx5e_priv *priv, u16 port, int add)
-{
-	struct mlx5e_vxlan_work *vxlan_work;
-
-	vxlan_work = kmalloc(sizeof(*vxlan_work), GFP_ATOMIC);
-	if (!vxlan_work)
-		return;
-
-	if (add)
-		INIT_WORK(&vxlan_work->work, mlx5e_vxlan_add_work);
-	else
-		INIT_WORK(&vxlan_work->work, mlx5e_vxlan_del_work);
-
-	vxlan_work->priv = priv;
-	vxlan_work->port = port;
-	queue_work(priv->wq, &vxlan_work->work);
-}
-
-void mlx5e_add_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (!mlx5_vxlan_allowed(priv->mdev->vxlan))
-		return;
-
-	mlx5e_vxlan_queue_work(priv, be16_to_cpu(ti->port), 1);
-}
-
-void mlx5e_del_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (!mlx5_vxlan_allowed(priv->mdev->vxlan))
-		return;
-
-	mlx5e_vxlan_queue_work(priv, be16_to_cpu(ti->port), 0);
-}
-
 static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 						     struct sk_buff *skb,
 						     netdev_features_t features)
@@ -4620,8 +4543,8 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_change_mtu          = mlx5e_change_nic_mtu,
 	.ndo_do_ioctl            = mlx5e_ioctl,
 	.ndo_set_tx_maxrate      = mlx5e_set_tx_maxrate,
-	.ndo_udp_tunnel_add      = mlx5e_add_vxlan_port,
-	.ndo_udp_tunnel_del      = mlx5e_del_vxlan_port,
+	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
 	.ndo_bpf		 = mlx5e_xdp,
@@ -4935,6 +4858,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
 
+	mlx5_vxlan_set_netdev_info(mdev->vxlan, netdev);
+
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev) ||
 	    mlx5e_any_tunnel_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
@@ -5240,8 +5165,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_get_rx_info(netdev);
+	udp_tunnel_nic_reset_ntf(priv->netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -5256,8 +5180,6 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(priv->netdev))
 		mlx5e_close(priv->netdev);
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_drop_rx_info(priv->netdev);
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c300729fb498..e9b86bc39716 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -37,6 +37,7 @@
 #include <net/act_api.h>
 #include <net/devlink.h>
 #include <net/ipv6_stubs.h>
+#include <net/udp_tunnel.h>
 
 #include "eswitch.h"
 #include "esw/chains.h"
@@ -47,6 +48,7 @@
 #include "en/rep/neigh.h"
 #include "fs_core.h"
 #include "lib/mlx5.h"
+#include "lib/vxlan.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
 
@@ -633,8 +635,8 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
 	.ndo_change_mtu          = mlx5e_uplink_rep_change_mtu,
-	.ndo_udp_tunnel_add      = mlx5e_add_vxlan_port,
-	.ndo_udp_tunnel_del      = mlx5e_del_vxlan_port,
+	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_set_vf_mac          = mlx5e_set_vf_mac,
 	.ndo_set_vf_rate         = mlx5e_set_vf_rate,
@@ -705,6 +707,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 		/* we want a persistent mac for the uplink rep */
 		mlx5_query_mac_address(mdev, netdev->dev_addr);
 		netdev->ethtool_ops = &mlx5e_uplink_rep_ethtool_ops;
+		mlx5_vxlan_set_netdev_info(mdev->vxlan, netdev);
 		mlx5e_dcbnl_build_rep_netdev(netdev);
 	} else {
 		netdev->netdev_ops = &mlx5e_netdev_ops_rep;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index be34330d89cc..c83b6906e96d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -35,6 +35,7 @@
 #include <linux/refcount.h>
 #include <linux/mlx5/driver.h>
 #include <net/vxlan.h>
+#include "../core/en.h"
 #include "mlx5_core.h"
 #include "vxlan.h"
 
@@ -42,13 +43,12 @@ struct mlx5_vxlan {
 	struct mlx5_core_dev		*mdev;
 	/* max_num_ports is usuallly 4, 16 buckets is more than enough */
 	DECLARE_HASHTABLE(htable, 4);
-	int				num_ports;
 	struct mutex                    sync_lock; /* sync add/del port HW operations */
+	struct udp_tunnel_nic_info	nic_info;
 };
 
 struct mlx5_vxlan_port {
 	struct hlist_node hlist;
-	refcount_t refcount;
 	u16 udp_port;
 };
 
@@ -106,73 +106,58 @@ static struct mlx5_vxlan_port *vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 p
 	return NULL;
 }
 
-int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
+static int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 {
 	struct mlx5_vxlan_port *vxlanp;
-	int ret = 0;
+	int ret;
 
-	mutex_lock(&vxlan->sync_lock);
-	vxlanp = vxlan_lookup_port(vxlan, port);
-	if (vxlanp) {
-		refcount_inc(&vxlanp->refcount);
-		goto unlock;
-	}
-
-	if (vxlan->num_ports >= mlx5_vxlan_max_udp_ports(vxlan->mdev)) {
-		mlx5_core_info(vxlan->mdev,
-			       "UDP port (%d) not offloaded, max number of UDP ports (%d) are already offloaded\n",
-			       port, mlx5_vxlan_max_udp_ports(vxlan->mdev));
-		ret = -ENOSPC;
-		goto unlock;
-	}
+	vxlanp = kzalloc(sizeof(*vxlanp), GFP_KERNEL);
+	if (!vxlanp)
+		return -ENOMEM;
+	vxlanp->udp_port = port;
 
 	ret = mlx5_vxlan_core_add_port_cmd(vxlan->mdev, port);
-	if (ret)
-		goto unlock;
-
-	vxlanp = kzalloc(sizeof(*vxlanp), GFP_KERNEL);
-	if (!vxlanp) {
-		ret = -ENOMEM;
-		goto err_delete_port;
+	if (ret) {
+		kfree(vxlanp);
+		return ret;
 	}
 
-	vxlanp->udp_port = port;
-	refcount_set(&vxlanp->refcount, 1);
-
+	mutex_lock(&vxlan->sync_lock);
 	hash_add_rcu(vxlan->htable, &vxlanp->hlist, port);
-
-	vxlan->num_ports++;
 	mutex_unlock(&vxlan->sync_lock);
+
 	return 0;
+}
 
-err_delete_port:
-	mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
+static int mlx5_vxlan_set_port(struct net_device *netdev, unsigned int table,
+			       unsigned int entry, struct udp_tunnel_info *ti)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-unlock:
-	mutex_unlock(&vxlan->sync_lock);
-	return ret;
+	return mlx5_vxlan_add_port(priv->mdev->vxlan, ntohs(ti->port));
 }
 
-int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
+static int mlx5_vxlan_unset_port(struct net_device *netdev, unsigned int table,
+				 unsigned int entry, struct udp_tunnel_info *ti)
 {
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_vxlan *vxlan = priv->mdev->vxlan;
 	struct mlx5_vxlan_port *vxlanp;
+	u16 port = ntohs(ti->port);
 	int ret = 0;
 
 	mutex_lock(&vxlan->sync_lock);
 
 	vxlanp = vxlan_lookup_port(vxlan, port);
-	if (!vxlanp) {
+	if (WARN_ON(!vxlanp)) {
 		ret = -ENOENT;
 		goto out_unlock;
 	}
 
-	if (refcount_dec_and_test(&vxlanp->refcount)) {
-		hash_del_rcu(&vxlanp->hlist);
-		synchronize_rcu();
-		mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
-		kfree(vxlanp);
-		vxlan->num_ports--;
-	}
+	hash_del_rcu(&vxlanp->hlist);
+	synchronize_rcu();
+	mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
+	kfree(vxlanp);
 
 out_unlock:
 	mutex_unlock(&vxlan->sync_lock);
@@ -193,6 +178,14 @@ struct mlx5_vxlan *mlx5_vxlan_create(struct mlx5_core_dev *mdev)
 	vxlan->mdev = mdev;
 	mutex_init(&vxlan->sync_lock);
 	hash_init(vxlan->htable);
+	vxlan->nic_info.set_port = mlx5_vxlan_set_port;
+	vxlan->nic_info.unset_port = mlx5_vxlan_unset_port;
+	vxlan->nic_info.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+				UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN;
+	vxlan->nic_info.tables[0].tunnel_types = UDP_TUNNEL_TYPE_VXLAN;
+	/* Don't count the space hard-coded to the IANA port */
+	vxlan->nic_info.tables[0].n_entries =
+		mlx5_vxlan_max_udp_ports(vxlan->mdev) - 1;
 
 	/* Hardware adds 4789 (IANA_VXLAN_UDP_PORT) by default */
 	mlx5_vxlan_add_port(vxlan, IANA_VXLAN_UDP_PORT);
@@ -218,3 +211,9 @@ void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan)
 
 	kfree(vxlan);
 }
+
+void mlx5_vxlan_set_netdev_info(struct mlx5_vxlan *vxlan, struct net_device *netdev)
+{
+	if (mlx5_vxlan_allowed(vxlan))
+		netdev->udp_tunnel_nic_info = &vxlan->nic_info;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
index 6d599f4a8acd..6b7eeb94ec35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
@@ -48,15 +48,13 @@ static inline bool mlx5_vxlan_allowed(struct mlx5_vxlan *vxlan)
 #if IS_ENABLED(CONFIG_VXLAN)
 struct mlx5_vxlan *mlx5_vxlan_create(struct mlx5_core_dev *mdev);
 void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan);
-int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port);
-int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port);
+void mlx5_vxlan_set_netdev_info(struct mlx5_vxlan *vxlan, struct net_device *netdev);
 bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port);
 #else
 static inline struct mlx5_vxlan*
 mlx5_vxlan_create(struct mlx5_core_dev *mdev) { return ERR_PTR(-EOPNOTSUPP); }
 static inline void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan) { return; }
-static inline int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port) { return -EOPNOTSUPP; }
-static inline int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port) { return -EOPNOTSUPP; }
+static inline void mlx5_vxlan_set_netdev_info(struct mlx5_vxlan *vxlan, struct net_device *netdev) { return; }
 static inline bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port) { return false; }
 #endif
 
-- 
2.26.2

