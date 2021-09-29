Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66841C937
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345864AbhI2QCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13846 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245242AbhI2P7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWZ2rTLz8yrt;
        Wed, 29 Sep 2021 23:53:30 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 087/167] net: mellanox: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:14 +0800
Message-ID: <20210929155334.12454-88-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |   8 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 181 ++++++++++------
 .../net/ethernet/mellanox/mlx4/en_resources.c |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  19 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   8 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  15 +-
 .../mellanox/mlx5/core/en_accel/tls.c         |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |   6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 205 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  25 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  19 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  36 +--
 19 files changed, 344 insertions(+), 242 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ef518b1040f7..f0eb54f8b486 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1237,13 +1237,13 @@ static int mlx4_en_check_rxfh_func(struct net_device *dev, u8 hfunc)
 	if (hfunc == ETH_RSS_HASH_TOP) {
 		if (!(priv->mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS_TOP))
 			return -EINVAL;
-		if (!(dev->features & NETIF_F_RXHASH))
+		if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, dev->features))
 			en_warn(priv, "Toeplitz hash function should be used in conjunction with RX hashing for optimal performance\n");
 		return 0;
 	} else if (hfunc == ETH_RSS_HASH_XOR) {
 		if (!(priv->mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS_XOR))
 			return -EINVAL;
-		if (dev->features & NETIF_F_RXHASH)
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, dev->features))
 			en_warn(priv, "Enabling both XOR Hash function and RX Hashing can limit RPS functionality\n");
 		return 0;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 109472d6b61f..6762ffff1400 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -103,7 +103,7 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
-	if (features & NETIF_F_LOOPBACK)
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, features))
 		priv->ctrl_flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
 	else
 		priv->ctrl_flags &= cpu_to_be32(~MLX4_WQE_CTRL_FORCE_LOOPBACK);
@@ -115,7 +115,8 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	 * and not performing the selftest or flb disabled
 	 */
 	if (mlx4_is_mfunc(priv->mdev->dev) &&
-	    !(features & NETIF_F_LOOPBACK) && !priv->validate_loopback)
+	    !netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, features) &&
+	    !priv->validate_loopback)
 		priv->flags |= MLX4_EN_FLAG_RX_FILTER_NEEDED;
 
 	/* Set dmac in Tx WQE if we are in SRIOV mode or if loopback selftest
@@ -130,7 +131,8 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	    priv->rss_map.indir_qp && priv->rss_map.indir_qp->qpn) {
 		int i;
 		int err = 0;
-		int loopback = !!(features & NETIF_F_LOOPBACK);
+		int loopback = netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT,
+						       features);
 
 		for (i = 0; i < priv->rx_ring_num; i++) {
 			int ret;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 5d95e878bad2..222ba5bb7cc8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2503,11 +2503,11 @@ static void mlx4_en_fix_features(struct net_device *netdev,
 	 * enable/disable make sure S-TAG flag is always in same state as
 	 * C-TAG.
 	 */
-	if (*features & NETIF_F_HW_VLAN_CTAG_RX &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) &&
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
-		*features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 	else
-		*features &= ~NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 }
 
 static int mlx4_en_set_features(struct net_device *netdev,
@@ -2517,14 +2517,16 @@ static int mlx4_en_set_features(struct net_device *netdev,
 	bool reset = false;
 	int ret = 0;
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXFCS)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXFCS_BIT)) {
 		en_info(priv, "Turn %s RX-FCS\n",
-			(features & NETIF_F_RXFCS) ? "ON" : "OFF");
+			netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						features) ? "ON" : "OFF");
 		reset = true;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXALL)) {
-		u8 ignore_fcs_value = (features & NETIF_F_RXALL) ? 1 : 0;
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXALL_BIT)) {
+		u8 ignore_fcs_value = netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+							      features) ? 1 : 0;
 
 		en_info(priv, "Turn %s RX-ALL\n",
 			ignore_fcs_value ? "ON" : "OFF");
@@ -2534,23 +2536,27 @@ static int mlx4_en_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_RX)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		en_info(priv, "Turn %s RX vlan strip offload\n",
-			(features & NETIF_F_HW_VLAN_CTAG_RX) ? "ON" : "OFF");
+			netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						features) ? "ON" : "OFF");
 		reset = true;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_TX))
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		en_info(priv, "Turn %s TX vlan strip offload\n",
-			(features & NETIF_F_HW_VLAN_CTAG_TX) ? "ON" : "OFF");
+			netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						features) ? "ON" : "OFF");
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_STAG_TX))
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_STAG_TX_BIT))
 		en_info(priv, "Turn %s TX S-VLAN strip offload\n",
-			(features & NETIF_F_HW_VLAN_STAG_TX) ? "ON" : "OFF");
+			netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
+						features) ? "ON" : "OFF");
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_LOOPBACK)) {
+	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_LOOPBACK_BIT)) {
 		en_info(priv, "Turn %s loopback\n",
-			(features & NETIF_F_LOOPBACK) ? "ON" : "OFF");
+			netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT,
+						features) ? "ON" : "OFF");
 		mlx4_en_update_loopback_state(netdev, features);
 	}
 
@@ -2689,7 +2695,8 @@ static void mlx4_en_features_check(struct sk_buff *skb, struct net_device *dev,
 		if (!priv->vxlan_port ||
 		    (ip_hdr(skb)->version != 4) ||
 		    (udp_hdr(skb)->dest != priv->vxlan_port))
-			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+						  NETIF_F_GSO_MASK, features);
 	}
 }
 
@@ -3315,42 +3322,59 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	/*
 	 * Set driver features
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM, &dev->hw_features);
 	if (mdev->LSO_support)
-		dev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&dev->hw_features);
 
 	if (mdev->dev->caps.tunnel_offload_mode ==
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
-		dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-		dev->features    |= NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		dev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				       NETIF_F_RXCSUM |
-				       NETIF_F_TSO | NETIF_F_TSO6 |
-				       NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				       NETIF_F_GSO_PARTIAL;
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_PARTIAL,
+					&dev->hw_features);
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_PARTIAL,
+					&dev->features);
+		netdev_feature_zero(&dev->gso_partial_features);
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				       &dev->gso_partial_features);
+		netdev_feature_zero(&dev->hw_enc_features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM |
+					NETIF_F_TSO | NETIF_F_TSO6 |
+					NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_PARTIAL,
+					&dev->hw_enc_features);
 
 		dev->udp_tunnel_nic_info = &mlx4_udp_tunnels;
 	}
 
-	dev->vlan_features = dev->hw_features;
+	netdev_feature_copy(&dev->vlan_features, dev->hw_features);
 
-	dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_RXHASH;
-	dev->features = dev->hw_features | NETIF_F_HIGHDMA |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_VLAN_CTAG_FILTER;
-	dev->hw_features |= NETIF_F_LOOPBACK |
-			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_RXHASH,
+				&dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HIGHDMA |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&dev->features);
+	netdev_feature_set_bits(NETIF_F_LOOPBACK |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&dev->hw_features);
 
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN)) {
-		dev->features |= NETIF_F_HW_VLAN_STAG_RX |
-			NETIF_F_HW_VLAN_STAG_FILTER;
-		dev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_STAG_RX |
+					NETIF_F_HW_VLAN_STAG_FILTER,
+					&dev->features);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_RX_BIT,
+				       &dev->hw_features);
 	}
 
 	if (mlx4_is_slave(mdev->dev)) {
@@ -3359,38 +3383,43 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 
 		err = get_phv_bit(mdev->dev, port, &phv);
 		if (!err && phv) {
-			dev->hw_features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
+					       &dev->hw_features);
 			priv->pflags |= MLX4_EN_PRIV_FLAGS_PHV;
 		}
 		err = mlx4_get_is_vlan_offload_disabled(mdev->dev, port,
 							&vlan_offload_disabled);
 		if (!err && vlan_offload_disabled) {
-			dev->hw_features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-					      NETIF_F_HW_VLAN_CTAG_RX |
-					      NETIF_F_HW_VLAN_STAG_TX |
-					      NETIF_F_HW_VLAN_STAG_RX);
-			dev->features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-					   NETIF_F_HW_VLAN_CTAG_RX |
-					   NETIF_F_HW_VLAN_STAG_TX |
-					   NETIF_F_HW_VLAN_STAG_RX);
+			netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+						  NETIF_F_HW_VLAN_CTAG_RX |
+						  NETIF_F_HW_VLAN_STAG_TX |
+						  NETIF_F_HW_VLAN_STAG_RX |
+						  NETIF_F_HW_VLAN_STAG_FILTER,
+						  &dev->hw_features);
+			netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+						  NETIF_F_HW_VLAN_CTAG_RX |
+						  NETIF_F_HW_VLAN_STAG_TX |
+						  NETIF_F_HW_VLAN_STAG_RX,
+						  &dev->features);
 		}
 	} else {
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_PHV_EN &&
 		    !(mdev->dev->caps.flags2 &
 		      MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
-			dev->hw_features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
+					       &dev->hw_features);
 	}
 
 	if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_FCS_KEEP)
-		dev->hw_features |= NETIF_F_RXFCS;
+		netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &dev->hw_features);
 
 	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_IGNORE_FCS)
-		dev->hw_features |= NETIF_F_RXALL;
+		netdev_feature_set_bit(NETIF_F_RXALL_BIT, &dev->hw_features);
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED &&
 	    mdev->dev->caps.dmfs_high_steer_mode != MLX4_STEERING_DMFS_A0_STATIC)
-		dev->hw_features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &dev->hw_features);
 
 	if (mdev->dev->caps.steering_mode != MLX4_STEERING_MODE_A0)
 		dev->priv_flags |= IFF_UNICAST_FLT;
@@ -3494,12 +3523,12 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	if (priv->hwtstamp_config.tx_type == ts_config.tx_type &&
 	    priv->hwtstamp_config.rx_filter == ts_config.rx_filter &&
-	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX) &&
-	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS))
+	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT))
 		return 0; /* Nothing to change */
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX) &&
-	    (features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+	    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
 	    (priv->hwtstamp_config.rx_filter != HWTSTAMP_FILTER_NONE)) {
 		en_warn(priv, "Can't turn ON rx vlan offload while time-stamping rx filter is ON\n");
 		return -EINVAL;
@@ -3525,26 +3554,34 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	mlx4_en_safe_replace_resources(priv, tmp);
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX)) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
-			dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       &dev->features);
 		else
-			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						 &dev->features);
 	} else if (ts_config.rx_filter == HWTSTAMP_FILTER_NONE) {
 		/* RX time-stamping is OFF, update the RX vlan offload
 		 * to the latest wanted state
 		 */
-		if (dev->wanted_features & NETIF_F_HW_VLAN_CTAG_RX)
-			dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    dev->wanted_features))
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       &dev->features);
 		else
-			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						 &dev->features);
 	}
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS)) {
-		if (features & NETIF_F_RXFCS)
-			dev->features |= NETIF_F_RXFCS;
+	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
+		if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, features))
+			netdev_feature_set_bit(NETIF_F_RXFCS_BIT,
+					       &dev->features);
 		else
-			dev->features &= ~NETIF_F_RXFCS;
+			netdev_feature_clear_bit(NETIF_F_RXFCS_BIT,
+						 &dev->features);
 	}
 
 	/* RX vlan offload and RX time-stamping can't co-exist !
@@ -3552,9 +3589,11 @@ int mlx4_en_reset_config(struct net_device *dev,
 	 * Turn Off RX vlan offload in case of time-stamping is ON
 	 */
 	if (ts_config.rx_filter != HWTSTAMP_FILTER_NONE) {
-		if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    dev->features))
 			en_warn(priv, "Turning off RX vlan offload since RX time-stamping is ON\n");
-		dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					 &dev->features);
 	}
 
 	if (port_up) {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_resources.c b/drivers/net/ethernet/mellanox/mlx4/en_resources.c
index 6883ac75d37f..8539d395f8be 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_resources.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_resources.c
@@ -76,12 +76,12 @@ void mlx4_en_fill_qp_context(struct mlx4_en_priv *priv, int size, int stride,
 	    context->pri_path.counter_index !=
 			    MLX4_SINK_COUNTER_INDEX(mdev->dev)) {
 		/* disable multicast loopback to qp with same counter */
-		if (!(dev->features & NETIF_F_LOOPBACK))
+		if (!netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, dev->features))
 			context->pri_path.fl |= MLX4_FL_ETH_SRC_CHECK_MC_LB;
 		context->pri_path.control |= MLX4_CTRL_ETH_SRC_CHECK_IF_COUNTER;
 	}
 	context->db_rec_addr = cpu_to_be64(priv->res.db.dma << 2);
-	if (!(dev->features & NETIF_F_HW_VLAN_CTAG_RX))
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, dev->features))
 		context->param3 |= cpu_to_be32(1 << 30);
 
 	if (!is_tx && !rss &&
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 557d7daac2d3..872654c3bbe9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -643,7 +643,8 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 	hw_checksum = csum_unfold((__force __sum16)cqe->checksum);
 
 	if (cqe->vlan_my_qpn & cpu_to_be32(MLX4_CQE_CVLAN_PRESENT_MASK) &&
-	    !(dev_features & NETIF_F_HW_VLAN_CTAG_RX)) {
+	    !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				     dev_features)) {
 		hw_checksum = get_fixed_vlan_csum(hw_checksum, hdr);
 		hdr += sizeof(struct vlan_hdr);
 	}
@@ -837,7 +838,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 		}
 		skb_record_rx_queue(skb, cq_ring);
 
-		if (likely(dev->features & NETIF_F_RXCSUM)) {
+		if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features))) {
 			/* TODO: For IP non TCP/UDP packets when csum complete is
 			 * not an option (not supported or any other reason) we can
 			 * actually check cqe IPOK status bit and report
@@ -849,7 +850,8 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			    cqe->checksum == cpu_to_be16(0xffff)) {
 				bool l2_tunnel;
 
-				l2_tunnel = (dev->hw_enc_features & NETIF_F_RXCSUM) &&
+				l2_tunnel = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+								    dev->hw_enc_features) &&
 					(cqe->vlan_my_qpn & cpu_to_be32(MLX4_CQE_L2_TUNNEL));
 				ip_summed = CHECKSUM_UNNECESSARY;
 				hash_type = PKT_HASH_TYPE_L4;
@@ -873,19 +875,21 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			ring->csum_none++;
 		}
 		skb->ip_summed = ip_summed;
-		if (dev->features & NETIF_F_RXHASH)
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, dev->features))
 			skb_set_hash(skb,
 				     be32_to_cpu(cqe->immed_rss_invalid),
 				     hash_type);
 
 		if ((cqe->vlan_my_qpn &
 		     cpu_to_be32(MLX4_CQE_CVLAN_PRESENT_MASK)) &&
-		    (dev->features & NETIF_F_HW_VLAN_CTAG_RX))
+		     netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					     dev->features))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       be16_to_cpu(cqe->sl_vid));
 		else if ((cqe->vlan_my_qpn &
 			  cpu_to_be32(MLX4_CQE_SVLAN_PRESENT_MASK)) &&
-			 (dev->features & NETIF_F_HW_VLAN_STAG_RX))
+			 netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_RX_BIT,
+						 dev->features))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD),
 					       be16_to_cpu(cqe->sl_vid));
 
@@ -1084,7 +1088,8 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	/* Cancel FCS removal if FW allows */
 	if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_FCS_KEEP) {
 		context->param3 |= cpu_to_be32(1 << 29);
-		if (priv->dev->features & NETIF_F_RXFCS)
+		if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+					    priv->dev->features))
 			ring->fcs_del = 0;
 		else
 			ring->fcs_del = ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 6bf558c5ec10..3b7efe939860 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -771,8 +771,9 @@ void mlx4_en_cleanup_filters(struct mlx4_en_priv *priv);
 void mlx4_en_ex_selftest(struct net_device *dev, u32 *flags, u64 *buf);
 void mlx4_en_ptp_overflow_check(struct mlx4_en_dev *mdev);
 
-#define DEV_FEATURE_CHANGED(dev, new_features, feature) \
-	((dev->features & feature) ^ (new_features & feature))
+#define DEV_FEATURE_CHANGED(dev, new_features, feature_bit)		\
+	(netdev_feature_test_bit(feature_bit, (dev)->features) !=	\
+	 netdev_feature_test_bit(feature_bit, new_features))
 
 int mlx4_en_moderation_update(struct mlx4_en_priv *priv);
 int mlx4_en_reset_config(struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7cab08a2f715..b703ea308429 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -540,16 +540,17 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
-	netdev->features |= NETIF_F_HW_ESP;
-	netdev->hw_enc_features |= NETIF_F_HW_ESP;
+	netdev_feature_set_bit(NETIF_F_HW_ESP_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_ESP_BIT, &netdev->hw_enc_features);
 
 	if (!MLX5_CAP_ETH(mdev, swp_csum)) {
 		mlx5_core_dbg(mdev, "mlx5e: SWP checksum not supported\n");
 		return;
 	}
 
-	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
-	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
+	netdev_feature_set_bit(NETIF_F_HW_ESP_TX_CSUM_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
+			       &netdev->hw_enc_features);
 
 	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
 	    !MLX5_CAP_ETH(mdev, swp_lso)) {
@@ -558,10 +559,11 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	}
 
 	if (mlx5_is_ipsec_device(mdev))
-		netdev->gso_partial_features |= NETIF_F_GSO_ESP;
+		netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT,
+				       &netdev->gso_partial_features);
 
 	mlx5_core_dbg(mdev, "mlx5e: ESP GSO capability turned on\n");
-	netdev->features |= NETIF_F_GSO_ESP;
-	netdev->hw_features |= NETIF_F_GSO_ESP;
-	netdev->hw_enc_features |= NETIF_F_GSO_ESP;
+	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, &netdev->hw_enc_features);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 62ab97cca915..b0e92a7b4902 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -123,7 +123,8 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
 
 	/* Disable CSUM and GSO for software IPsec */
 out_disable:
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 #else
@@ -141,7 +142,10 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 static inline void
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
-{ *features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
+{
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
+}
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index d93aadbf10da..bde7da10f442 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -63,12 +63,15 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 		return;
 
 	if (mlx5e_accel_is_ktls_tx(mdev)) {
-		netdev->hw_features |= NETIF_F_HW_TLS_TX;
-		netdev->features    |= NETIF_F_HW_TLS_TX;
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+				       &netdev->features);
 	}
 
 	if (mlx5e_accel_is_ktls_rx(mdev))
-		netdev->hw_features |= NETIF_F_HW_TLS_RX;
+		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
+				       &netdev->hw_features);
 
 	netdev->tlsdev_ops = &mlx5e_ktls_ops;
 }
@@ -99,7 +102,8 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 	if (!priv->tls->rx_wq)
 		return -ENOMEM;
 
-	if (priv->netdev->features & NETIF_F_HW_TLS_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT,
+				    &priv->netdev->features)) {
 		err = mlx5e_accel_fs_tcp_create(priv);
 		if (err) {
 			destroy_workqueue(priv->tls->rx_wq);
@@ -115,7 +119,8 @@ void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 	if (!mlx5e_accel_is_ktls_rx(priv->mdev))
 		return;
 
-	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT,
+				    &priv->netdev->features))
 		mlx5e_accel_fs_tcp_destroy(priv);
 
 	destroy_workqueue(priv->tls->rx_wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index b8fc863aa68d..bd2998782634 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -203,18 +203,22 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 
 	caps = mlx5_accel_tls_device_caps(priv->mdev);
 	if (caps & MLX5_ACCEL_TLS_TX) {
-		netdev->features          |= NETIF_F_HW_TLS_TX;
-		netdev->hw_features       |= NETIF_F_HW_TLS_TX;
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+				       &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
+				       &netdev->hw_features);
 	}
 
 	if (caps & MLX5_ACCEL_TLS_RX) {
-		netdev->features          |= NETIF_F_HW_TLS_RX;
-		netdev->hw_features       |= NETIF_F_HW_TLS_RX;
+		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
+				       &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
+				       &netdev->hw_features);
 	}
 
 	if (!(caps & MLX5_ACCEL_TLS_LRO)) {
-		netdev->features          &= ~NETIF_F_LRO;
-		netdev->hw_features       &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->hw_features);
 	}
 
 	netdev->tlsdev_ops = &mlx5e_tls_ops;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index fe5d82fa6e92..ce62ed5143bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -181,7 +181,8 @@ static void _mlx5e_cleanup_tables(struct mlx5e_priv *priv)
 
 void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv)
 {
-	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+				     priv->netdev->hw_features))
 		return;
 
 	_mlx5e_cleanup_tables(priv);
@@ -358,7 +359,8 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 	int err = -ENOMEM;
 	int i;
 
-	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+				     priv->netdev->hw_features))
 		return 0;
 
 	priv->fs.arfs = kvzalloc(sizeof(*priv->fs.arfs), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 485f208691ea..e00cd310cf89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -480,7 +480,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 
-	arfs_enabled = opened && (priv->netdev->features & NETIF_F_NTUPLE);
+	arfs_enabled = opened && netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+							 priv->netdev->features);
 	if (arfs_enabled)
 		mlx5e_arfs_disable(priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index c06b4b938ae7..520e5c3e5fb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1287,7 +1287,8 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
-		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
+					 &priv->netdev->hw_features);
 	}
 
 	err = mlx5e_create_inner_ttc_table(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 07f88bc4be1c..4370b7241522 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3183,12 +3183,12 @@ static int mlx5e_set_mac(struct net_device *netdev, void *addr)
 	return 0;
 }
 
-#define MLX5E_SET_FEATURE(features, feature, enable)	\
-	do {						\
-		if (enable)				\
-			*features |= feature;		\
-		else					\
-			*features &= ~feature;		\
+#define MLX5E_SET_FEATURE(features, feature, enable)			\
+	do {								\
+		if (enable)						\
+			netdev_feature_set_bit(feature, features);	\
+		else							\
+			netdev_feature_clear_bit(feature, features);	\
 	} while (0)
 
 typedef int (*mlx5e_feature_handler)(struct net_device *netdev, bool enable);
@@ -3330,49 +3330,56 @@ static int set_feature_arfs(struct net_device *netdev, bool enable)
 static int mlx5e_handle_feature(struct net_device *netdev,
 				netdev_features_t *features,
 				netdev_features_t wanted_features,
-				netdev_features_t feature,
+				u32 feature_bit,
 				mlx5e_feature_handler feature_handler)
 {
-	netdev_features_t changes = wanted_features ^ netdev->features;
-	bool enable = !!(wanted_features & feature);
+	netdev_features_t changes;
+	bool enable;
 	int err;
 
-	if (!(changes & feature))
+	netdev_feature_xor(&changes, wanted_features, netdev->features);
+	enable = netdev_feature_test_bit(feature_bit, wanted_features);
+
+	if (!netdev_feature_test_bit(feature_bit, changes))
 		return 0;
 
 	err = feature_handler(netdev, enable);
 	if (err) {
-		netdev_err(netdev, "%s feature %pNF failed, err %d\n",
-			   enable ? "Enable" : "Disable", &feature, err);
+		netdev_err(netdev, "%s feature bit %u failed, err %d\n",
+			   enable ? "Enable" : "Disable", feature_bit, err);
 		return err;
 	}
 
-	MLX5E_SET_FEATURE(features, feature, enable);
+	MLX5E_SET_FEATURE(features, feature_bit, enable);
 	return 0;
 }
 
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t oper_features = netdev->features;
+	netdev_features_t oper_features;
 	int err = 0;
 
+	netdev_feature_copy(&oper_features, netdev->features);
+
 #define MLX5E_HANDLE_FEATURE(feature, handler) \
 	mlx5e_handle_feature(netdev, &oper_features, features, feature, handler)
 
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO_BIT, set_feature_lro);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				    set_feature_cvlan_filter);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_hw_tc);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL, set_feature_rx_all);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXFCS, set_feature_rx_fcs);
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_RX, set_feature_rx_vlan);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC_BIT, set_feature_hw_tc);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL_BIT, set_feature_rx_all);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXFCS_BIT, set_feature_rx_fcs);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    set_feature_rx_vlan);
 #ifdef CONFIG_MLX5_EN_ARFS
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE, set_feature_arfs);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_NTUPLE_BIT, set_feature_arfs);
 #endif
-	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX, mlx5e_ktls_set_feature_rx);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TLS_RX_BIT,
+				    mlx5e_ktls_set_feature_rx);
 
 	if (err) {
-		netdev->features = oper_features;
+		netdev_feature_copy(&netdev->features, oper_features);
 		return -EINVAL;
 	}
 
@@ -3382,16 +3389,16 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 static void mlx5e_fix_uplink_rep_features(struct net_device *netdev,
 					  netdev_features_t *features)
 {
-	*features &= ~NETIF_F_HW_TLS_RX;
-	if (netdev->features & NETIF_F_HW_TLS_RX)
+	netdev_feature_clear_bit(NETIF_F_HW_TLS_RX_BIT, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT, netdev->features))
 		netdev_warn(netdev, "Disabling hw_tls_rx, not supported in switchdev mode\n");
 
-	*features &= ~NETIF_F_HW_TLS_TX;
-	if (netdev->features & NETIF_F_HW_TLS_TX)
+	netdev_feature_clear_bit(NETIF_F_HW_TLS_TX_BIT, features);
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_TX_BIT, netdev->features))
 		netdev_warn(netdev, "Disabling hw_tls_tx, not supported in switchdev mode\n");
 
-	*features &= ~NETIF_F_NTUPLE;
-	if (netdev->features & NETIF_F_NTUPLE)
+	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, features);
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, netdev->features))
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
 }
 
@@ -3408,26 +3415,26 @@ static void mlx5e_fix_features(struct net_device *netdev,
 		/* HW strips the outer C-tag header, this is a problem
 		 * for S-tag traffic.
 		 */
-		*features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
 		if (!params->vlan_strip_disable)
 			netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag vlan\n");
 	}
 
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		if (*features & NETIF_F_LRO) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
-			*features &= ~NETIF_F_LRO;
+			netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		*features &= ~NETIF_F_RXHASH;
-		if (netdev->features & NETIF_F_RXHASH)
+		netdev_feature_clear_bit(NETIF_F_RXHASH_BIT, features);
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features))
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
 	}
 
 	if (mlx5e_is_uplink_rep(priv))
-		mlx5e_fix_uplink_rep_features(netdev, &features);
+		mlx5e_fix_uplink_rep_features(netdev, features);
 
 	mutex_unlock(&priv->state_lock);
 }
@@ -3897,7 +3904,8 @@ static void mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
@@ -3910,7 +3918,8 @@ void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-	    (*features & NETIF_F_CSUM_MASK || *features & NETIF_F_GSO_MASK))
+	    (netdev_feature_test_bits(NETIF_F_CSUM_MASK, *features) ||
+	     netdev_feature_test_bits(NETIF_F_GSO_MASK, *features)))
 		mlx5e_tunnel_features_check(priv, skb, features);
 }
 
@@ -4318,21 +4327,23 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->ethtool_ops	  = &mlx5e_ethtool_ops;
 
-	netdev->vlan_features    |= NETIF_F_SG;
-	netdev->vlan_features    |= NETIF_F_HW_CSUM;
-	netdev->vlan_features    |= NETIF_F_GRO;
-	netdev->vlan_features    |= NETIF_F_TSO;
-	netdev->vlan_features    |= NETIF_F_TSO6;
-	netdev->vlan_features    |= NETIF_F_RXCSUM;
-	netdev->vlan_features    |= NETIF_F_RXHASH;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->vlan_features);
 
-	netdev->mpls_features    |= NETIF_F_SG;
-	netdev->mpls_features    |= NETIF_F_HW_CSUM;
-	netdev->mpls_features    |= NETIF_F_TSO;
-	netdev->mpls_features    |= NETIF_F_TSO6;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->mpls_features);
 
-	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			       &netdev->hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &netdev->hw_enc_features);
 
 	/* Tunneled LRO is not supported in the driver, and the same RQs are
 	 * shared between inner and outer TIRs, so the driver can't disable LRO
@@ -4343,65 +4354,83 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    !MLX5_CAP_ETH(mdev, tunnel_lro_vxlan) &&
 	    !MLX5_CAP_ETH(mdev, tunnel_lro_gre) &&
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
-		netdev->vlan_features    |= NETIF_F_LRO;
-
-	netdev->hw_features       = netdev->vlan_features;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->vlan_features);
+
+	netdev_feature_copy(&netdev->hw_features, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			       &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			       &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
+			       &netdev->hw_features);
 
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
-		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
-		netdev->hw_enc_features |= NETIF_F_TSO;
-		netdev->hw_enc_features |= NETIF_F_TSO6;
-		netdev->hw_enc_features |= NETIF_F_GSO_PARTIAL;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
+				       &netdev->hw_enc_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT,
+				       &netdev->hw_enc_features);
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+				       &netdev->hw_enc_features);
+		netdev_feature_set_bit(NETIF_F_GSO_PARTIAL_BIT,
+				       &netdev->hw_enc_features);
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       &netdev->hw_enc_features);
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       &netdev->vlan_features);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
+				       &netdev->hw_enc_features);
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
+				       &netdev->gso_partial_features);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-		netdev->hw_features |= NETIF_F_GSO_IPXIP4 |
-				       NETIF_F_GSO_IPXIP6;
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4 |
-					   NETIF_F_GSO_IPXIP6;
-		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP4 |
-						NETIF_F_GSO_IPXIP6;
+		netdev_feature_set_bits(NETIF_F_GSO_IPXIP4 |
+					NETIF_F_GSO_IPXIP6,
+					&netdev->hw_features);
+		netdev_feature_set_bits(NETIF_F_GSO_IPXIP4 |
+					NETIF_F_GSO_IPXIP6,
+					&netdev->hw_enc_features);
+		netdev_feature_set_bits(NETIF_F_GSO_IPXIP4 |
+					NETIF_F_GSO_IPXIP6,
+					&netdev->gso_partial_features);
 	}
 
-	netdev->hw_features	                 |= NETIF_F_GSO_PARTIAL;
-	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4;
-	netdev->hw_features                      |= NETIF_F_GSO_UDP_L4;
-	netdev->features                         |= NETIF_F_GSO_UDP_L4;
+	netdev_feature_set_bit(NETIF_F_GSO_PARTIAL_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
+			       &netdev->gso_partial_features);
+	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, &netdev->features);
 
 	mlx5_query_port_fcs(mdev, &fcs_supported, &fcs_enabled);
 
 	if (fcs_supported)
-		netdev->hw_features |= NETIF_F_RXALL;
+		netdev_feature_set_bit(NETIF_F_RXALL_BIT, &netdev->hw_features);
 
 	if (MLX5_CAP_ETH(mdev, scatter_fcs))
-		netdev->hw_features |= NETIF_F_RXFCS;
+		netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &netdev->hw_features);
 
 	if (mlx5_qos_is_supported(mdev))
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
 
-	netdev->features          = netdev->hw_features;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 
 	/* Defaults */
 	if (fcs_enabled)
-		netdev->features  &= ~NETIF_F_RXALL;
-	netdev->features  &= ~NETIF_F_LRO;
-	netdev->features  &= ~NETIF_F_RXFCS;
+		netdev_feature_clear_bit(NETIF_F_RXALL_BIT, &netdev->features);
+	netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
+	netdev_feature_clear_bit(NETIF_F_RXFCS_BIT, &netdev->features);
 
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
 	if (FT_CAP(flow_modify_en) &&
@@ -4409,15 +4438,15 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    FT_CAP(identified_miss_table_mode) &&
 	    FT_CAP(flow_table_modify)) {
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-		netdev->hw_features      |= NETIF_F_HW_TC;
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
-		netdev->hw_features	 |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
 #endif
 	}
 
-	netdev->features         |= NETIF_F_HIGHDMA;
-	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, &netdev->features);
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ae71a17fdb27..113f11a7ba69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -633,19 +633,20 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->watchdog_timeo    = 15 * HZ;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	netdev->hw_features    |= NETIF_F_HW_TC;
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
 #endif
-	netdev->hw_features    |= NETIF_F_SG;
-	netdev->hw_features    |= NETIF_F_IP_CSUM;
-	netdev->hw_features    |= NETIF_F_IPV6_CSUM;
-	netdev->hw_features    |= NETIF_F_GRO;
-	netdev->hw_features    |= NETIF_F_TSO;
-	netdev->hw_features    |= NETIF_F_TSO6;
-	netdev->hw_features    |= NETIF_F_RXCSUM;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->hw_features);
 
-	netdev->features |= netdev->hw_features;
-	netdev->features |= NETIF_F_VLAN_CHALLENGED;
-	netdev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &netdev->features);
 }
 
 static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
@@ -1009,7 +1010,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5e_rep_neigh_init(rpriv);
 	mlx5e_rep_bridge_init(priv);
 
-	netdev->wanted_features |= NETIF_F_HW_TC;
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->wanted_features);
 
 	rtnl_lock();
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3c65fd0bcf31..f869d50c2cf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -976,7 +976,8 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 	int network_depth = 0;
 	__be16 proto;
 
-	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      netdev->features)))
 		goto csum_none;
 
 	if (lro) {
@@ -1073,7 +1074,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 								  rq->clock, get_cqe_ts(cqe));
 	skb_record_rx_queue(skb, rq->ix);
 
-	if (likely(netdev->features & NETIF_F_RXHASH))
+	if (likely(netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features)))
 		mlx5e_skb_set_hash(cqe, skb);
 
 	if (cqe_has_vlan(cqe)) {
@@ -1662,7 +1663,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	skb->protocol = *((__be16 *)(skb->data));
 
-	if (netdev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features)) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
 		stats->csum_complete++;
@@ -1676,7 +1677,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 								  rq->clock, get_cqe_ts(cqe));
 	skb_record_rx_queue(skb, rq->ix);
 
-	if (likely(netdev->features & NETIF_F_RXHASH))
+	if (likely(netdev_feature_test_bit(NETIF_F_RXHASH_BIT, netdev->features)))
 		mlx5e_skb_set_hash(cqe, skb);
 
 	/* 20 bytes of ipoib header and 4 for encap existing */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0e03cefc5eeb..8f4b5d37c08d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4834,7 +4834,7 @@ static int mlx5e_tc_netdev_event(struct notifier_block *this,
 	priv = container_of(fs, struct mlx5e_priv, fs);
 	peer_priv = netdev_priv(ndev);
 	if (priv == peer_priv ||
-	    !(priv->netdev->features & NETIF_F_HW_TC))
+	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, priv->netdev->features))
 		return NOTIFY_DONE;
 
 	mlx5e_tc_hairpin_update_dead_peer(priv, peer_priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 67571e5040d6..b06c5fadfa4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -87,14 +87,14 @@ int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 	mlx5e_timestamp_init(priv);
 
 	/* netdev init */
-	netdev->hw_features    |= NETIF_F_SG;
-	netdev->hw_features    |= NETIF_F_IP_CSUM;
-	netdev->hw_features    |= NETIF_F_IPV6_CSUM;
-	netdev->hw_features    |= NETIF_F_GRO;
-	netdev->hw_features    |= NETIF_F_TSO;
-	netdev->hw_features    |= NETIF_F_TSO6;
-	netdev->hw_features    |= NETIF_F_RXCSUM;
-	netdev->hw_features    |= NETIF_F_RXHASH;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->hw_features);
 
 	netdev->netdev_ops = &mlx5i_netdev_ops;
 	netdev->ethtool_ops = &mlx5i_ethtool_ops;
@@ -326,7 +326,8 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
-		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
+					 &priv->netdev->hw_features);
 	}
 
 	err = mlx5e_create_ttc_table(priv);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0e81ae723bc8..d5a8bc944947 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1105,43 +1105,45 @@ typedef int (*mlxsw_sp_feature_handler)(struct net_device *dev, bool enable);
 
 static int mlxsw_sp_handle_feature(struct net_device *dev,
 				   netdev_features_t wanted_features,
-				   netdev_features_t feature,
+				   u32 feature_bit,
 				   mlxsw_sp_feature_handler feature_handler)
 {
-	netdev_features_t changes = wanted_features ^ dev->features;
-	bool enable = !!(wanted_features & feature);
+	bool enable = netdev_feature_test_bit(feature_bit, wanted_features);
+	netdev_features_t changes;
 	int err;
 
-	if (!(changes & feature))
+	netdev_feature_xor(&changes, wanted_features, dev->features);
+
+	if (!netdev_feature_test_bit(feature_bit, changes))
 		return 0;
 
 	err = feature_handler(dev, enable);
 	if (err) {
-		netdev_err(dev, "%s feature %pNF failed, err %d\n",
-			   enable ? "Enable" : "Disable", &feature, err);
+		netdev_err(dev, "%s feature bit %u failed, err %d\n",
+			   enable ? "Enable" : "Disable", feature_bit, err);
 		return err;
 	}
 
 	if (enable)
-		dev->features |= feature;
+		netdev_feature_set_bit(feature_bit, &dev->features);
 	else
-		dev->features &= ~feature;
-
+		netdev_feature_clear_bit(feature_bit, &dev->features);
 	return 0;
 }
 static int mlxsw_sp_set_features(struct net_device *dev,
 				 netdev_features_t features)
 {
-	netdev_features_t oper_features = dev->features;
+	netdev_features_t oper_features;
 	int err = 0;
 
-	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC,
+	netdev_feature_copy(&oper_features, dev->features);
+	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC_BIT,
 				       mlxsw_sp_feature_hw_tc);
-	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK,
+	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK_BIT,
 				       mlxsw_sp_feature_loopback);
 
 	if (err) {
-		dev->features = oper_features;
+		netdev_feature_copy(&dev->features, oper_features);
 		return -EINVAL;
 	}
 
@@ -1570,9 +1572,11 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 
 	netif_carrier_off(dev);
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_LLTX | NETIF_F_SG |
-			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
-	dev->hw_features |= NETIF_F_HW_TC | NETIF_F_LOOPBACK;
+	netdev_feature_set_bits(NETIF_F_NETNS_LOCAL | NETIF_F_LLTX |
+				NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_TC, &dev->features);
+	netdev_feature_set_bits(NETIF_F_HW_TC | NETIF_F_LOOPBACK,
+				&dev->hw_features);
 
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
-- 
2.33.0

