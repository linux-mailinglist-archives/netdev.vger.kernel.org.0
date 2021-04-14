Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6543C35FE67
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhDNX0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233356AbhDNX0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C36161164;
        Wed, 14 Apr 2021 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442752;
        bh=iZpSdjfygwyJS0IaWQ5eJMSvRz/uK2J9fQNwAxaxlic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7iJByK6N30CJBbzrRsO/eG+1segE0yPU55R8A6AzROYLPOM7mBtIfZAWslcg33aD
         Kk+d1qGKe03S9PJCGP+FRAfOMzzTxUetHldM2+2NFsGoYFPSzY9vGAe63DK0fSKpXx
         y5j2Cmp5cboHxQ8kK3//xy8hoSHqYHVYhF8QgddTWMKQLXGRYGeV8WU6cd7pRJKUEh
         w0r9hWmcP/GWhhywaL8zfG2SKlGzzphpSFDNr0g+poN+uLw4K68/7Ib1IkbDfNc1ON
         vLtkXw351mCMxCfu3mi/bAiW10wBSf00aYvIL4Bt4S9GPOEqZvpoOTh54MO2IVluAE
         LvYKK8PDLbsag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Cc : Steffen Klassert" <steffen.klassert@secunet.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net 1/3] net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
Date:   Wed, 14 Apr 2021 16:25:38 -0700
Message-Id: <20210414232540.138232-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414232540.138232-1-saeed@kernel.org>
References: <20210414232540.138232-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

mlx5e_ipsec_feature_check belongs to mlx5e_tunnel_features_check.
Also, IPsec is not the default configuration so it should be
checked at the end instead of the beginning of mlx5e_features_check.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h      | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  8 +++++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 3e80742a3caf..cfa98272e4a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -93,8 +93,8 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
 
-static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
-					     netdev_features_t features)
+static inline netdev_features_t
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 {
 	struct sec_path *sp = skb_sec_path(skb);
 
@@ -102,9 +102,11 @@ static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_dev
 		struct xfrm_state *x = sp->xvec[0];
 
 		if (x && x->xso.offload_handle)
-			return true;
+			return features;
 	}
-	return false;
+
+	/* Disable CSUM and GSO for software IPsec */
+	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 #else
@@ -120,8 +122,9 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 }
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
-static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
-					     netdev_features_t features) { return false; }
+static inline netdev_features_t
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
+{ return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5db63b9f3b70..1b7fa0264652 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4552,6 +4552,11 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 		/* Support Geneve offload for default UDP port */
 		if (port == GENEVE_UDP_PORT && mlx5_geneve_tx_allowed(priv->mdev))
 			return features;
+#endif
+		break;
+#ifdef CONFIG_MLX5_EN_IPSEC
+	case IPPROTO_ESP:
+		return mlx5e_ipsec_feature_check(skb, features);
 #endif
 	}
 
@@ -4569,9 +4574,6 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 	features = vlan_features_check(skb, features);
 	features = vxlan_features_check(skb, features);
 
-	if (mlx5e_ipsec_feature_check(skb, netdev, features))
-		return features;
-
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
 	    (features & NETIF_F_CSUM_MASK || features & NETIF_F_GSO_MASK))
-- 
2.30.2

