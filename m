Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759442F28C3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391936AbhALHPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388596AbhALHPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 892C622D3E;
        Tue, 12 Jan 2021 07:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435629;
        bh=OMtit12LbLsMxtNXiusGzBMKXHrpMydHq0RWcIUnndo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Miu47jimkEjhw0uS9oEn1HXJ8fjAcKStvmmfFLDmMa4JvEW6XL6MWL2BSsadj9MaC
         lgUxS/EiAjozqEFA6Bu+v7UeGqJ1a1MtF+jN4A+gi59s0a7xS0miVna3OJIQkiLODd
         zAp8e1EEYnNaKbQJRwmmbFGk1ZM4iw8I/B2qKpIlneSL/lff86knHedN1HLE1MqR2e
         C1G2FLBD5pOhQLwHebzIU49hJQvW22uikRnfIrQIypH/k1u2a6KU1+zG3Y7hjbyzsG
         d2KVNH1cR12Z5jsDgoik5hZJQxMpiV9eKn1jEE06Jcunu5/MjCcl0xOsPGs6EpprzY
         +ZdNTXAlZrURQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/11] net/mlx5e: IPsec, Inline feature_check fast-path function
Date:   Mon, 11 Jan 2021 23:05:33 -0800
Message-Id: <20210112070534.136841-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Feature check functions are in the TX fast-path of all SKBs, not only
IPsec traffic.
Move the IPsec feature check function into a header and turn it inline.
Use a stub and clean the config flag condition in Eth main driver file.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 14 --------------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 19 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 --
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index a9b45606dbdb..a97e8d205094 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -497,20 +497,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 	}
 }
 
-bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
-			       netdev_features_t features)
-{
-	struct sec_path *sp = skb_sec_path(skb);
-	struct xfrm_state *x;
-
-	if (sp && sp->len) {
-		x = sp->xvec[0];
-		if (x && x->xso.offload_handle)
-			return true;
-	}
-	return false;
-}
-
 void mlx5e_ipsec_build_inverse_table(void)
 {
 	u16 mss_inv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index fabf4b6b2b84..3e80742a3caf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -57,8 +57,6 @@ struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
 					  struct sk_buff *skb, u32 *cqe_bcnt);
 
 void mlx5e_ipsec_inverse_table_init(void);
-bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
-			       netdev_features_t features);
 void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
 			    struct xfrm_offload *xo);
 void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
@@ -94,6 +92,21 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 
 void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
+
+static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
+					     netdev_features_t features)
+{
+	struct sec_path *sp = skb_sec_path(skb);
+
+	if (sp && sp->len) {
+		struct xfrm_state *x = sp->xvec[0];
+
+		if (x && x->xso.offload_handle)
+			return true;
+	}
+	return false;
+}
+
 #else
 static inline
 void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
@@ -107,6 +120,8 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 }
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
+static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
+					     netdev_features_t features) { return false; }
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1f66756f66f9..ee86b2b57f4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4376,10 +4376,8 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 	features = vlan_features_check(skb, features);
 	features = vxlan_features_check(skb, features);
 
-#ifdef CONFIG_MLX5_EN_IPSEC
 	if (mlx5e_ipsec_feature_check(skb, netdev, features))
 		return features;
-#endif
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-- 
2.26.2

