Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24C33E262
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCPXvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhCPXvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88AEE64F0C;
        Tue, 16 Mar 2021 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938678;
        bh=a/goXm8N525IczIFiDFQQ+gJsnPp3LRXvpUecE8Vz6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZC+BtujWYPiNabiOZ1G3bz6gGTJg1znDi7kuB1EDkh4xh/JN7a79thlJ0khgV6hTO
         SsUnMyMhyWXKA5ZuWLfkd3zTpGlU7tKFypvGGrS0l5uQ5DJfkK38CdpOZ2ybfPfFSv
         tfkTMCK4i6nVt4333pc5udDOHBqwWrRxoG3PcAoa8BT4Cscy9RruQ/bk9QYuVAO+y2
         4cS6qrDZizecPB4fUviXRLr3Nlablb1/HXH2TiWc/aWJjM6bt9kbMLQR7mrN3e/9Do
         Y0zCQw5hRhAR62FBZ2faWG5i1a1tcZlJg/tPfACZYBY1qvzcwkBI94+tMAQfVcJxLH
         vVc77hZ08Fc+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Use nic mode netdev ndos and ethtool ops for uplink representor
Date:   Tue, 16 Mar 2021 16:51:03 -0700
Message-Id: <20210316235112.72626-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove dedicated uplink rep netdev ndos and ethtools ops.
We will re-use the native NIC port net device instance and ethtool ops for
the Uplink representor.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 133 +-----------------
 1 file changed, 4 insertions(+), 129 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b83652ed35cc..9533085005c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -69,16 +69,6 @@ static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 		 fw_rev_sub(mdev), mdev->board_id);
 }
 
-static void mlx5e_uplink_rep_get_drvinfo(struct net_device *dev,
-					 struct ethtool_drvinfo *drvinfo)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	mlx5e_rep_get_drvinfo(dev, drvinfo);
-	strlcpy(drvinfo->bus_info, pci_name(priv->mdev->pdev),
-		sizeof(drvinfo->bus_info));
-}
-
 static const struct counter_desc sw_rep_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_bytes) },
@@ -285,46 +275,6 @@ static u32 mlx5e_rep_get_rxfh_indir_size(struct net_device *netdev)
 	return mlx5e_ethtool_get_rxfh_indir_size(priv);
 }
 
-static void mlx5e_uplink_rep_get_pause_stats(struct net_device *netdev,
-					     struct ethtool_pause_stats *stats)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	mlx5e_stats_pause_get(priv, stats);
-}
-
-static void mlx5e_uplink_rep_get_pauseparam(struct net_device *netdev,
-					    struct ethtool_pauseparam *pauseparam)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	mlx5e_ethtool_get_pauseparam(priv, pauseparam);
-}
-
-static int mlx5e_uplink_rep_set_pauseparam(struct net_device *netdev,
-					   struct ethtool_pauseparam *pauseparam)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	return mlx5e_ethtool_set_pauseparam(priv, pauseparam);
-}
-
-static int mlx5e_uplink_rep_get_link_ksettings(struct net_device *netdev,
-					       struct ethtool_link_ksettings *link_ksettings)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	return mlx5e_ethtool_get_link_ksettings(priv, link_ksettings);
-}
-
-static int mlx5e_uplink_rep_set_link_ksettings(struct net_device *netdev,
-					       const struct ethtool_link_ksettings *link_ksettings)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	return mlx5e_ethtool_set_link_ksettings(priv, link_ksettings);
-}
-
 static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -344,34 +294,6 @@ static const struct ethtool_ops mlx5e_rep_ethtool_ops = {
 	.get_rxfh_indir_size = mlx5e_rep_get_rxfh_indir_size,
 };
 
-static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES |
-				     ETHTOOL_COALESCE_USE_ADAPTIVE,
-	.get_drvinfo	   = mlx5e_uplink_rep_get_drvinfo,
-	.get_link	   = ethtool_op_get_link,
-	.get_strings       = mlx5e_rep_get_strings,
-	.get_sset_count    = mlx5e_rep_get_sset_count,
-	.get_ethtool_stats = mlx5e_rep_get_ethtool_stats,
-	.get_ringparam     = mlx5e_rep_get_ringparam,
-	.set_ringparam     = mlx5e_rep_set_ringparam,
-	.get_channels      = mlx5e_rep_get_channels,
-	.set_channels      = mlx5e_rep_set_channels,
-	.get_coalesce      = mlx5e_rep_get_coalesce,
-	.set_coalesce      = mlx5e_rep_set_coalesce,
-	.get_link_ksettings = mlx5e_uplink_rep_get_link_ksettings,
-	.set_link_ksettings = mlx5e_uplink_rep_set_link_ksettings,
-	.get_rxfh_key_size   = mlx5e_rep_get_rxfh_key_size,
-	.get_rxfh_indir_size = mlx5e_rep_get_rxfh_indir_size,
-	.get_rxfh          = mlx5e_get_rxfh,
-	.set_rxfh          = mlx5e_set_rxfh,
-	.get_rxnfc         = mlx5e_get_rxnfc,
-	.set_rxnfc         = mlx5e_set_rxnfc,
-	.get_pause_stats   = mlx5e_uplink_rep_get_pause_stats,
-	.get_pauseparam    = mlx5e_uplink_rep_get_pauseparam,
-	.set_pauseparam    = mlx5e_uplink_rep_set_pauseparam,
-};
-
 static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
 				 struct mlx5_eswitch_rep *rep)
 {
@@ -568,34 +490,6 @@ static int mlx5e_rep_change_mtu(struct net_device *netdev, int new_mtu)
 	return mlx5e_change_mtu(netdev, new_mtu, NULL);
 }
 
-static int mlx5e_uplink_rep_change_mtu(struct net_device *netdev, int new_mtu)
-{
-	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu_ctx);
-}
-
-static int mlx5e_uplink_rep_set_mac(struct net_device *netdev, void *addr)
-{
-	struct sockaddr *saddr = addr;
-
-	if (!is_valid_ether_addr(saddr->sa_data))
-		return -EADDRNOTAVAIL;
-
-	ether_addr_copy(netdev->dev_addr, saddr->sa_data);
-	return 0;
-}
-
-static int mlx5e_uplink_rep_set_vf_vlan(struct net_device *dev, int vf, u16 vlan, u8 qos,
-					__be16 vlan_proto)
-{
-	netdev_warn_once(dev, "legacy vf vlan setting isn't supported in switchdev mode\n");
-
-	if (vlan != 0)
-		return -EOPNOTSUPP;
-
-	/* allow setting 0-vid for compatibility with libvirt */
-	return 0;
-}
-
 static struct devlink_port *mlx5e_rep_get_devlink_port(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -641,29 +535,10 @@ static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_change_carrier      = mlx5e_rep_change_carrier,
 };
 
-static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
-	.ndo_open                = mlx5e_open,
-	.ndo_stop                = mlx5e_close,
-	.ndo_start_xmit          = mlx5e_xmit,
-	.ndo_set_mac_address     = mlx5e_uplink_rep_set_mac,
-	.ndo_setup_tc            = mlx5e_rep_setup_tc,
-	.ndo_get_devlink_port    = mlx5e_rep_get_devlink_port,
-	.ndo_get_stats64         = mlx5e_get_stats,
-	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
-	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
-	.ndo_change_mtu          = mlx5e_uplink_rep_change_mtu,
-	.ndo_features_check      = mlx5e_features_check,
-	.ndo_set_vf_mac          = mlx5e_set_vf_mac,
-	.ndo_set_vf_rate         = mlx5e_set_vf_rate,
-	.ndo_get_vf_config       = mlx5e_get_vf_config,
-	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
-	.ndo_set_vf_vlan         = mlx5e_uplink_rep_set_vf_vlan,
-	.ndo_set_features        = mlx5e_set_features,
-};
-
 bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
+	return netdev->netdev_ops == &mlx5e_netdev_ops &&
+	       mlx5e_is_uplink_rep(netdev_priv(netdev));
 }
 
 bool mlx5e_eswitch_vf_rep(struct net_device *netdev)
@@ -718,10 +593,10 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 {
 	SET_NETDEV_DEV(netdev, mdev->device);
 	if (rep->vport == MLX5_VPORT_UPLINK) {
-		netdev->netdev_ops = &mlx5e_netdev_ops_uplink_rep;
+		netdev->netdev_ops = &mlx5e_netdev_ops;
 		/* we want a persistent mac for the uplink rep */
 		mlx5_query_mac_address(mdev, netdev->dev_addr);
-		netdev->ethtool_ops = &mlx5e_uplink_rep_ethtool_ops;
+		netdev->ethtool_ops = &mlx5e_ethtool_ops;
 		mlx5e_dcbnl_build_rep_netdev(netdev);
 	} else {
 		netdev->netdev_ops = &mlx5e_netdev_ops_rep;
-- 
2.30.2

