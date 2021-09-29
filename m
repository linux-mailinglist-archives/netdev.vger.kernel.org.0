Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBD041C8F4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbhI2QAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13835 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343773AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWN6Cl2z8yM0;
        Wed, 29 Sep 2021 23:53:20 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:57 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 018/167] net: mlx5: convert prototype of mlx5e_ipsec_feature_check, mlx5e_tunnel_features_check and mlx5e_fix_uplink_rep_features
Date:   Wed, 29 Sep 2021 23:51:05 +0800
Message-ID: <20210929155334.12454-19-shenjian15@huawei.com>
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

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
mlx5e_tunnel_features_check, mlx5e_ipsec_feature_check
and mlx5e_fix_uplink_rep_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 15 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 34 +++++++++----------
 2 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 5120a59361e6..62ab97cca915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -93,8 +93,8 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
 
-static inline netdev_features_t
-mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
+static inline void
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp = skb_sec_path(skb);
@@ -118,13 +118,12 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 				goto out_disable;
 		}
 
-		return features;
-
+		return;
 	}
 
 	/* Disable CSUM and GSO for software IPsec */
 out_disable:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 #else
@@ -140,9 +139,9 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 }
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
-static inline netdev_features_t
-mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
-{ return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
+static inline void
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
+{ *features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4092210fb079..07f88bc4be1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3379,22 +3379,20 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
-static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev,
-						       netdev_features_t features)
+static void mlx5e_fix_uplink_rep_features(struct net_device *netdev,
+					  netdev_features_t *features)
 {
-	features &= ~NETIF_F_HW_TLS_RX;
+	*features &= ~NETIF_F_HW_TLS_RX;
 	if (netdev->features & NETIF_F_HW_TLS_RX)
 		netdev_warn(netdev, "Disabling hw_tls_rx, not supported in switchdev mode\n");
 
-	features &= ~NETIF_F_HW_TLS_TX;
+	*features &= ~NETIF_F_HW_TLS_TX;
 	if (netdev->features & NETIF_F_HW_TLS_TX)
 		netdev_warn(netdev, "Disabling hw_tls_tx, not supported in switchdev mode\n");
 
-	features &= ~NETIF_F_NTUPLE;
+	*features &= ~NETIF_F_NTUPLE;
 	if (netdev->features & NETIF_F_NTUPLE)
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
-
-	return features;
 }
 
 static void mlx5e_fix_features(struct net_device *netdev,
@@ -3429,7 +3427,7 @@ static void mlx5e_fix_features(struct net_device *netdev,
 	}
 
 	if (mlx5e_is_uplink_rep(priv))
-		features = mlx5e_fix_uplink_rep_features(netdev, features);
+		mlx5e_fix_uplink_rep_features(netdev, &features);
 
 	mutex_unlock(&priv->state_lock);
 }
@@ -3847,9 +3845,9 @@ static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_core_dev
 	return false;
 }
 
-static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
-						     struct sk_buff *skb,
-						     netdev_features_t features)
+static void mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
+					struct sk_buff *skb,
+					netdev_features_t *features)
 {
 	unsigned int offset = 0;
 	struct udphdr *udph;
@@ -3870,12 +3868,12 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 	switch (proto) {
 	case IPPROTO_GRE:
 		if (mlx5e_gre_tunnel_inner_proto_offload_supported(priv->mdev, skb))
-			return features;
+			return;
 		break;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
 		if (mlx5e_tunnel_proto_supported_tx(priv->mdev, IPPROTO_IPIP))
-			return features;
+			return;
 		break;
 	case IPPROTO_UDP:
 		udph = udp_hdr(skb);
@@ -3883,23 +3881,23 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 		/* Verify if UDP port is being offloaded by HW */
 		if (mlx5_vxlan_lookup_port(priv->mdev->vxlan, port))
-			return features;
+			return;
 
 #if IS_ENABLED(CONFIG_GENEVE)
 		/* Support Geneve offload for default UDP port */
 		if (port == GENEVE_UDP_PORT && mlx5_geneve_tx_allowed(priv->mdev))
-			return features;
+			return;
 #endif
 		break;
 #ifdef CONFIG_MLX5_EN_IPSEC
 	case IPPROTO_ESP:
-		return mlx5e_ipsec_feature_check(skb, features);
+		mlx5e_ipsec_feature_check(skb, *features);
 #endif
 	}
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
@@ -3913,7 +3911,7 @@ void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
 	    (*features & NETIF_F_CSUM_MASK || *features & NETIF_F_GSO_MASK))
-		*features = mlx5e_tunnel_features_check(priv, skb, *features);
+		mlx5e_tunnel_features_check(priv, skb, features);
 }
 
 static void mlx5e_tx_timeout_work(struct work_struct *work)
-- 
2.33.0

