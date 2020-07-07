Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACB1217A3D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgGGVY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbgGGVYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 17:24:49 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55AD62078B;
        Tue,  7 Jul 2020 21:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594157088;
        bh=vRxRsTth+H5cX1Y+uj4WuThPPRoXWKx5bLW7RxBp3t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaISoAZ03tYVaOqd8M1Ddz5H54ZWB++8yVkih59xAoezFZ29F5BZ6msIW2vMB+I1V
         RvbUBWNbAryGj2L5KPzJ0AW81cEbsmwgHb9ukY0gtUzCcdFFzGH5PE3bBIH564IOXh
         TsFHj8enAdftsVMxMpC/qSs2CIW7sj3T3XfJmrHk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 9/9] mlx4: convert to new udp_tunnel_nic infra
Date:   Tue,  7 Jul 2020 14:24:34 -0700
Message-Id: <20200707212434.3244001-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707212434.3244001-1-kuba@kernel.org>
References: <20200707212434.3244001-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to new infra, make use of the ability to sleep in the callback.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 107 ++++--------------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   2 -
 2 files changed, 25 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 5bd3cd37d50f..2b8608f8f0a9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1816,7 +1816,7 @@ int mlx4_en_start_port(struct net_device *dev)
 	queue_work(mdev->workqueue, &priv->rx_mode_task);
 
 	if (priv->mdev->dev->caps.tunnel_offload_mode == MLX4_TUNNEL_OFFLOAD_MODE_VXLAN)
-		udp_tunnel_get_rx_info(dev);
+		udp_tunnel_nic_reset_ntf(dev);
 
 	priv->port_up = true;
 
@@ -2628,89 +2628,32 @@ static int mlx4_en_get_phys_port_id(struct net_device *dev,
 	return 0;
 }
 
-static void mlx4_en_add_vxlan_offloads(struct work_struct *work)
+static int mlx4_udp_tunnel_sync(struct net_device *dev, unsigned int table)
 {
+	struct mlx4_en_priv *priv = netdev_priv(dev);
+	struct udp_tunnel_info ti;
 	int ret;
-	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
-						 vxlan_add_task);
 
-	ret = mlx4_config_vxlan_port(priv->mdev->dev, priv->vxlan_port);
-	if (ret)
-		goto out;
+	udp_tunnel_nic_get_port(dev, table, 0, &ti);
+	priv->vxlan_port = ti.port;
 
-	ret = mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
-				  VXLAN_STEER_BY_OUTER_MAC, 1);
-out:
-	if (ret) {
-		en_err(priv, "failed setting L2 tunnel configuration ret %d\n", ret);
-		return;
-	}
-}
-
-static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
-{
-	int ret;
-	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
-						 vxlan_del_task);
-	ret = mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
-				  VXLAN_STEER_BY_OUTER_MAC, 0);
+	ret = mlx4_config_vxlan_port(priv->mdev->dev, priv->vxlan_port);
 	if (ret)
-		en_err(priv, "failed setting L2 tunnel configuration ret %d\n", ret);
+		return ret;
 
-	priv->vxlan_port = 0;
+	return mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
+				   VXLAN_STEER_BY_OUTER_MAC,
+				   !!priv->vxlan_port);
 }
 
-static void mlx4_en_add_vxlan_port(struct  net_device *dev,
-				   struct udp_tunnel_info *ti)
-{
-	struct mlx4_en_priv *priv = netdev_priv(dev);
-	__be16 port = ti->port;
-	__be16 current_port;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (ti->sa_family != AF_INET)
-		return;
-
-	if (priv->mdev->dev->caps.tunnel_offload_mode != MLX4_TUNNEL_OFFLOAD_MODE_VXLAN)
-		return;
-
-	current_port = priv->vxlan_port;
-	if (current_port && current_port != port) {
-		en_warn(priv, "vxlan port %d configured, can't add port %d\n",
-			ntohs(current_port), ntohs(port));
-		return;
-	}
-
-	priv->vxlan_port = port;
-	queue_work(priv->mdev->workqueue, &priv->vxlan_add_task);
-}
-
-static void mlx4_en_del_vxlan_port(struct  net_device *dev,
-				   struct udp_tunnel_info *ti)
-{
-	struct mlx4_en_priv *priv = netdev_priv(dev);
-	__be16 port = ti->port;
-	__be16 current_port;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (ti->sa_family != AF_INET)
-		return;
-
-	if (priv->mdev->dev->caps.tunnel_offload_mode != MLX4_TUNNEL_OFFLOAD_MODE_VXLAN)
-		return;
-
-	current_port = priv->vxlan_port;
-	if (current_port != port) {
-		en_dbg(DRV, priv, "vxlan port %d isn't configured, ignoring\n", ntohs(port));
-		return;
-	}
-
-	queue_work(priv->mdev->workqueue, &priv->vxlan_del_task);
-}
+static const struct udp_tunnel_nic_info mlx4_udp_tunnels = {
+	.sync_table	= mlx4_udp_tunnel_sync,
+	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+			  UDP_TUNNEL_NIC_INFO_IPV4_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+};
 
 static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 						struct net_device *dev,
@@ -2914,8 +2857,8 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_rx_flow_steer	= mlx4_en_filter_rfs,
 #endif
 	.ndo_get_phys_port_id	= mlx4_en_get_phys_port_id,
-	.ndo_udp_tunnel_add	= mlx4_en_add_vxlan_port,
-	.ndo_udp_tunnel_del	= mlx4_en_del_vxlan_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
@@ -2948,8 +2891,8 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
 	.ndo_rx_flow_steer	= mlx4_en_filter_rfs,
 #endif
 	.ndo_get_phys_port_id	= mlx4_en_get_phys_port_id,
-	.ndo_udp_tunnel_add	= mlx4_en_add_vxlan_port,
-	.ndo_udp_tunnel_del	= mlx4_en_del_vxlan_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
@@ -3250,8 +3193,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate);
 	INIT_DELAYED_WORK(&priv->stats_task, mlx4_en_do_get_stats);
 	INIT_DELAYED_WORK(&priv->service_task, mlx4_en_service_task);
-	INIT_WORK(&priv->vxlan_add_task, mlx4_en_add_vxlan_offloads);
-	INIT_WORK(&priv->vxlan_del_task, mlx4_en_del_vxlan_offloads);
 #ifdef CONFIG_RFS_ACCEL
 	INIT_LIST_HEAD(&priv->filters);
 	spin_lock_init(&priv->filters_lock);
@@ -3406,6 +3347,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 				       NETIF_F_GSO_UDP_TUNNEL |
 				       NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				       NETIF_F_GSO_PARTIAL;
+
+		dev->udp_tunnel_nic_info = &mlx4_udp_tunnels;
 	}
 
 	dev->vlan_features = dev->hw_features;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 9f5603612960..a46efe37cfa9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -599,8 +599,6 @@ struct mlx4_en_priv {
 	struct work_struct linkstate_task;
 	struct delayed_work stats_task;
 	struct delayed_work service_task;
-	struct work_struct vxlan_add_task;
-	struct work_struct vxlan_del_task;
 	struct mlx4_en_perf_stats pstats;
 	struct mlx4_en_pkt_stats pkstats;
 	struct mlx4_en_counter_stats pf_stats;
-- 
2.26.2

