Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7752D3352
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgLHUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731143AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 14/15] net/mlx5e: Split between RX/TX tunnel FW support indication
Date:   Tue,  8 Dec 2020 11:35:54 -0800
Message-Id: <20201208193555.674504-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Use the new FW caps to advertise for ip-in-ip tunnel support separately
for RX and TX.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 20 +++++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 34 ++++++++++++++++---
 3 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index dc744702aee4..5749557749b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -287,8 +287,7 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
 
-bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 proto_type);
-bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev);
+u8 mlx5e_get_proto_by_tunnel_type(enum mlx5e_tunnel_types tt);
 
 #endif /* __MLX5E_FLOW_STEER_H__ */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1f48f99c0997..fa8149f6eb08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -772,25 +772,31 @@ static struct mlx5e_etype_proto ttc_tunnel_rules[] = {
 
 };
 
-bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 proto_type)
+u8 mlx5e_get_proto_by_tunnel_type(enum mlx5e_tunnel_types tt)
+{
+	return ttc_tunnel_rules[tt].proto;
+}
+
+static bool mlx5e_tunnel_proto_supported_rx(struct mlx5_core_dev *mdev, u8 proto_type)
 {
 	switch (proto_type) {
 	case IPPROTO_GRE:
 		return MLX5_CAP_ETH(mdev, tunnel_stateless_gre);
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
-		return MLX5_CAP_ETH(mdev, tunnel_stateless_ip_over_ip);
+		return (MLX5_CAP_ETH(mdev, tunnel_stateless_ip_over_ip) ||
+			MLX5_CAP_ETH(mdev, tunnel_stateless_ip_over_ip_rx));
 	default:
 		return false;
 	}
 }
 
-bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev)
+static bool mlx5e_tunnel_any_rx_proto_supported(struct mlx5_core_dev *mdev)
 {
 	int tt;
 
 	for (tt = 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
-		if (mlx5e_tunnel_proto_supported(mdev, ttc_tunnel_rules[tt].proto))
+		if (mlx5e_tunnel_proto_supported_rx(mdev, ttc_tunnel_rules[tt].proto))
 			return true;
 	}
 	return false;
@@ -798,7 +804,7 @@ bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev)
 
 bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev)
 {
-	return (mlx5e_any_tunnel_proto_supported(mdev) &&
+	return (mlx5e_tunnel_any_rx_proto_supported(mdev) &&
 		MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ft_field_support.inner_ip_version));
 }
 
@@ -899,8 +905,8 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_priv *priv,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft   = params->inner_ttc->ft.t;
 	for (tt = 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
-		if (!mlx5e_tunnel_proto_supported(priv->mdev,
-						  ttc_tunnel_rules[tt].proto))
+		if (!mlx5e_tunnel_proto_supported_rx(priv->mdev,
+						     ttc_tunnel_rules[tt].proto))
 			continue;
 		trules[tt] = mlx5e_generate_ttc_rule(priv, ft, &dest,
 						     ttc_tunnel_rules[tt].etype,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3275c4e7cbdf..2490d68cbd32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4280,6 +4280,20 @@ int mlx5e_get_vf_stats(struct net_device *dev,
 }
 #endif
 
+static bool mlx5e_tunnel_proto_supported_tx(struct mlx5_core_dev *mdev, u8 proto_type)
+{
+	switch (proto_type) {
+	case IPPROTO_GRE:
+		return MLX5_CAP_ETH(mdev, tunnel_stateless_gre);
+	case IPPROTO_IPIP:
+	case IPPROTO_IPV6:
+		return (MLX5_CAP_ETH(mdev, tunnel_stateless_ip_over_ip) ||
+			MLX5_CAP_ETH(mdev, tunnel_stateless_ip_over_ip_tx));
+	default:
+		return false;
+	}
+}
+
 static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_core_dev *mdev,
 							   struct sk_buff *skb)
 {
@@ -4322,7 +4336,7 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 		break;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
-		if (mlx5e_tunnel_proto_supported(priv->mdev, IPPROTO_IPIP))
+		if (mlx5e_tunnel_proto_supported_tx(priv->mdev, IPPROTO_IPIP))
 			return features;
 		break;
 	case IPPROTO_UDP:
@@ -4882,6 +4896,17 @@ void mlx5e_vxlan_set_netdev_info(struct mlx5e_priv *priv)
 	priv->netdev->udp_tunnel_nic_info = &priv->nic_info;
 }
 
+static bool mlx5e_tunnel_any_tx_proto_supported(struct mlx5_core_dev *mdev)
+{
+	int tt;
+
+	for (tt = 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
+		if (mlx5e_tunnel_proto_supported_tx(mdev, mlx5e_get_proto_by_tunnel_type(tt)))
+			return true;
+	}
+	return (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev));
+}
+
 static void mlx5e_build_nic_netdev(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4927,8 +4952,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	mlx5e_vxlan_set_netdev_info(priv);
 
-	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev) ||
-	    mlx5e_any_tunnel_proto_supported(mdev)) {
+	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |= NETIF_F_TSO;
 		netdev->hw_enc_features |= NETIF_F_TSO6;
@@ -4945,7 +4969,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
-	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
+	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
 		netdev->hw_features     |= NETIF_F_GSO_GRE |
 					   NETIF_F_GSO_GRE_CSUM;
 		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
@@ -4954,7 +4978,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 						NETIF_F_GSO_GRE_CSUM;
 	}
 
-	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_IPIP)) {
+	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
 		netdev->hw_features |= NETIF_F_GSO_IPXIP4 |
 				       NETIF_F_GSO_IPXIP6;
 		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4 |
-- 
2.26.2

