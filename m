Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2F344047A
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhJ2U7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhJ2U7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37FE3610D2;
        Fri, 29 Oct 2021 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541004;
        bh=Vvdx1iY9A8pDtChE7B5DnOQkDYVlGZtn+K5xCZnQzeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9Wi8RS9HeO+IquyRMrRkL7MgtX5upg8zK96/XcTuo2DJmieOI2ng8VsA4CXeiAqw
         9A/InAPV3fGnn4glKVWb9Qqev90hZiGeAeo3lYIuKPRcZpOmDgqUsW+5q99tnjO8+L
         eYunTF/v+YI9QezjNDKG9Q1nthYx+Yj+vUpODTgbHa5ALKUll6SkfjuWS3HWgGX0Mx
         kVelXbqkW3qePBRKo4u9hsBxIgoDPvV7UlRNWwLbaEp72EKyQVygYqlusL8/vSUhZM
         t8HeDh5ETmrvRkm4WU6mOrhO7SxEcupcpqcbcE5CgexhdhlOESCh+VhJc6yw1DBvBr
         XOs8KzqTn5iQA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/14] net/mlx5e: IPsec: Refactor checksum code in tx data path
Date:   Fri, 29 Oct 2021 13:56:21 -0700
Message-Id: <20211029205632.390403-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Part of code that is related solely to IPsec is always compiled in the
driver code regardless if the IPsec functionality is enabled or disabled
in the driver code, this will add unnecessary branch in case IPsec is
disabled at Tx data path.

Move IPsec related code to IPsec related file such that in case of IPsec
is disabled and because of unlikely macro the compiler should be able to
optimize and omit the checksum IPsec code all together from Tx data path

Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 26 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 20 ++------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 5120a59361e6..b98db50c3418 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -127,6 +127,25 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+static inline bool
+mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5_wqe_eth_seg *eseg)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
+	if (!mlx5e_ipsec_eseg_meta(eseg))
+		return false;
+
+	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
+	if (xo->inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
+		sq->stats->csum_partial_inner++;
+	}
+
+	return true;
+}
 #else
 static inline
 void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
@@ -143,6 +162,13 @@ static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false;
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 { return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
+
+static inline bool
+mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5_wqe_eth_seg *eseg)
+{
+	return false;
+}
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 188994d091c5..7fd33b356cc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -38,6 +38,7 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
@@ -213,30 +214,13 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
 
-static void
-ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			    struct mlx5_wqe_eth_seg *eseg)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (xo->inner_ipproto) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
-	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
-		sq->stats->csum_partial_inner++;
-	}
-}
-
 static inline void
 mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5e_accel_tx_state *accel,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
-	if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
-		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+	if (unlikely(mlx5e_ipsec_txwqe_build_eseg_csum(sq, skb, eseg)))
 		return;
-	}
 
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-- 
2.31.1

