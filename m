Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE102EED12
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbhAHFcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727676AbhAHFcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1DAF233FB;
        Fri,  8 Jan 2021 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083863;
        bh=McerwxI2K1bc0kkLDTiM5M/ec5W4HuZgMqRKaKf1jRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmonhGxLfv3QisUqbHPmZzWUOBfJabx36vyz6Wr2DI5qSY+jcrRUt2RxQibKYBsQU
         dWOL71D74qvCCtV4174VKyLVsoxAWvkW66093kV0mt42WWfl25aP2GyfvWFLV0OhD1
         348IzcWXw1qRVfNGT1n4czImheVxhZiBM5LbT0cbFhtArNDcDRrFpmab9XVdm1cA+V
         kkQOdQJGzL9xyRnLui0LuKomjkxb9iYJDhOrC8ASS/BNdZpjyW8QhNLlrMDp646uO1
         toQU23lHUAVgwD96Q2vUxak7fbckDgbIWMHCGki6+mhOEx0eemZmnO2B6GvLgd8QY6
         u6tiDYYRLM6fw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: IPsec, Inline feature_check fast-path function
Date:   Thu,  7 Jan 2021 21:30:53 -0800
Message-Id: <20210108053054.660499-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
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
index f27f509ab028..c00eef14ee6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4375,10 +4375,8 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
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

