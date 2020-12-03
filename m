Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52DE2CCDE0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgLCEWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:42 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18396 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgLCEWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867cc0000>; Wed, 02 Dec 2020 20:21:32 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:31 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Aya Levin" <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 14/15] net/mlx5e: Split between RX/TX tunnel FW support indication
Date:   Wed, 2 Dec 2020 20:21:07 -0800
Message-ID: <20201203042108.232706-15-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969292; bh=4XO6H5o0CvucECdSyAaSR8jkD8V6JNAcpp4wFJlweHk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=NzW1Yntrsu+Tq4KIzKbdfm6ZoJS96hw/vSFFSnexL2rkjyY81qc3O4W2Mb5aT6k7E
         c00tyCXt05iH6ky0PjHq6JgIkmj6mkbNZGYOXFLKEuNM03LxDu0tVQBjTCTyYjiQvM
         nim3Ss4vTZm8RxLJnLTHbZ18azbKKZogysO1TAGnzUNN8bhKA9WM4zm56ZEDeu78D+
         9prmRbSbefvAL1N6w0nJBUCE8J3O6heJP/Dh+ltOVNwiASExz6nz5ae/SAA1dKBsM9
         L0GocT5ktOj/aB3lLxMZO00JBK8l3kT23BIiFh4MADIc4yOTm6IYewlXckH7UxFS47
         a5M1L9UO84PVg==
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index dc744702aee4..5749557749b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -287,8 +287,7 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv=
);
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
=20
-bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 proto_typ=
e);
-bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev);
+u8 mlx5e_get_proto_by_tunnel_type(enum mlx5e_tunnel_types tt);
=20
 #endif /* __MLX5E_FLOW_STEER_H__ */
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index 1f48f99c0997..fa8149f6eb08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -772,25 +772,31 @@ static struct mlx5e_etype_proto ttc_tunnel_rules[] =
=3D {
=20
 };
=20
-bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 proto_typ=
e)
+u8 mlx5e_get_proto_by_tunnel_type(enum mlx5e_tunnel_types tt)
+{
+	return ttc_tunnel_rules[tt].proto;
+}
+
+static bool mlx5e_tunnel_proto_supported_rx(struct mlx5_core_dev *mdev, u8=
 proto_type)
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
=20
-bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev)
+static bool mlx5e_tunnel_any_rx_proto_supported(struct mlx5_core_dev *mdev=
)
 {
 	int tt;
=20
 	for (tt =3D 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
-		if (mlx5e_tunnel_proto_supported(mdev, ttc_tunnel_rules[tt].proto))
+		if (mlx5e_tunnel_proto_supported_rx(mdev, ttc_tunnel_rules[tt].proto))
 			return true;
 	}
 	return false;
@@ -798,7 +804,7 @@ bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_=
dev *mdev)
=20
 bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev)
 {
-	return (mlx5e_any_tunnel_proto_supported(mdev) &&
+	return (mlx5e_tunnel_any_rx_proto_supported(mdev) &&
 		MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ft_field_support.inner_ip_version));
 }
=20
@@ -899,8 +905,8 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_=
priv *priv,
 	dest.type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft   =3D params->inner_ttc->ft.t;
 	for (tt =3D 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
-		if (!mlx5e_tunnel_proto_supported(priv->mdev,
-						  ttc_tunnel_rules[tt].proto))
+		if (!mlx5e_tunnel_proto_supported_rx(priv->mdev,
+						     ttc_tunnel_rules[tt].proto))
 			continue;
 		trules[tt] =3D mlx5e_generate_ttc_rule(priv, ft, &dest,
 						     ttc_tunnel_rules[tt].etype,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index fd12d906d239..26be6eb44fed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4279,6 +4279,20 @@ int mlx5e_get_vf_stats(struct net_device *dev,
 }
 #endif
=20
+static bool mlx5e_tunnel_proto_supported_tx(struct mlx5_core_dev *mdev, u8=
 proto_type)
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
 static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_cor=
e_dev *mdev,
 							   struct sk_buff *skb)
 {
@@ -4321,7 +4335,7 @@ static netdev_features_t mlx5e_tunnel_features_check(=
struct mlx5e_priv *priv,
 		break;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
-		if (mlx5e_tunnel_proto_supported(priv->mdev, IPPROTO_IPIP))
+		if (mlx5e_tunnel_proto_supported_tx(priv->mdev, IPPROTO_IPIP))
 			return features;
 		break;
 	case IPPROTO_UDP:
@@ -4906,6 +4920,17 @@ void mlx5e_vxlan_set_netdev_info(struct mlx5e_priv *=
priv)
 	priv->netdev->udp_tunnel_nic_info =3D &priv->nic_info;
 }
=20
+static bool mlx5e_tunnel_any_tx_proto_supported(struct mlx5_core_dev *mdev=
)
+{
+	int tt;
+
+	for (tt =3D 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
+		if (mlx5e_tunnel_proto_supported_tx(mdev, mlx5e_get_proto_by_tunnel_type=
(tt)))
+			return true;
+	}
+	return (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev));
+}
+
 static void mlx5e_build_nic_netdev(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
@@ -4951,8 +4976,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
=20
 	mlx5e_vxlan_set_netdev_info(priv);
=20
-	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev) ||
-	    mlx5e_any_tunnel_proto_supported(mdev)) {
+	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev->hw_enc_features |=3D NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |=3D NETIF_F_TSO;
 		netdev->hw_enc_features |=3D NETIF_F_TSO6;
@@ -4969,7 +4993,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
=20
-	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
+	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
 		netdev->hw_features     |=3D NETIF_F_GSO_GRE |
 					   NETIF_F_GSO_GRE_CSUM;
 		netdev->hw_enc_features |=3D NETIF_F_GSO_GRE |
@@ -4978,7 +5002,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 						NETIF_F_GSO_GRE_CSUM;
 	}
=20
-	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_IPIP)) {
+	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
 		netdev->hw_features |=3D NETIF_F_GSO_IPXIP4 |
 				       NETIF_F_GSO_IPXIP6;
 		netdev->hw_enc_features |=3D NETIF_F_GSO_IPXIP4 |
--=20
2.26.2

