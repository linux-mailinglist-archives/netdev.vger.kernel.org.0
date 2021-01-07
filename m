Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2F92EE6E1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbhAGUaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbhAGUaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C75235DD;
        Thu,  7 Jan 2021 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051346;
        bh=i4fNz/Vj/UPWGRJ7vQXMX8WI5evz960Vffzw6DWcwco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZDbFt2b8FBzLU+5MXBAE1AsviagtZjreeFZGHYmWOGa9iMXqp9q+QIrREitnQrfO
         XVbe+mBrn9w4JAkCaujun550X1f2SNYxwZQCXXD0/4wE/22dGjzGrOKJ3EmrLBUtRl
         M0Q3JOJv5n0vxkNYma+fr69V0NbWhIFsBcBn5jAxxyn2yHjvB9X7pAgHFx50qTy65X
         CvEMVfiTj+oUEmYNdkHLOCfS0ZC2Kitjjvmf7qdDSQG8/wbaEHCm9NdcKnQAu7oTq8
         td8gF7fY0pRWBwZsTnjqCiyt2iqw23+bToEzUFKbIifjpkDjsqJmBzFosZ1o93eQaB
         BWvv/HSO1prYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/11] net/mlx5e: Fix SWP offsets when vlan inserted by driver
Date:   Thu,  7 Jan 2021 12:28:39 -0800
Message-Id: <20210107202845.470205-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

In case WQE includes inline header the vlan is inserted by driver even
if vlan offload is set. On geneve over vlan interface where software
parser is used the SWP offsets should be updated according to the added
vlan.

Fixes: e3cfc7e6b7bd ("net/mlx5e: TX, Add geneve tunnel stateless offload support")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h        | 9 +++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h  | 8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c          | 9 +++++----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 7943eb30b837..4880f2179273 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -371,6 +371,15 @@ struct mlx5e_swp_spec {
 	u8 tun_l4_proto;
 };
 
+static inline void mlx5e_eseg_swp_offsets_add_vlan(struct mlx5_wqe_eth_seg *eseg)
+{
+	/* SWP offsets are in 2-bytes words */
+	eseg->swp_outer_l3_offset += VLAN_HLEN / 2;
+	eseg->swp_outer_l4_offset += VLAN_HLEN / 2;
+	eseg->swp_inner_l3_offset += VLAN_HLEN / 2;
+	eseg->swp_inner_l4_offset += VLAN_HLEN / 2;
+}
+
 static inline void
 mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 		   struct mlx5e_swp_spec *swp_spec)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 899b98aca0d3..1fae7fab8297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -51,7 +51,7 @@ static inline bool mlx5_geneve_tx_allowed(struct mlx5_core_dev *mdev)
 }
 
 static inline void
-mlx5e_tx_tunnel_accel(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
+mlx5e_tx_tunnel_accel(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
 	struct mlx5e_swp_spec swp_spec = {};
 	unsigned int offset = 0;
@@ -85,6 +85,8 @@ mlx5e_tx_tunnel_accel(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
 	}
 
 	mlx5e_set_eseg_swp(skb, eseg, &swp_spec);
+	if (skb_vlan_tag_present(skb) &&  ihs)
+		mlx5e_eseg_swp_offsets_add_vlan(eseg);
 }
 
 #else
@@ -163,7 +165,7 @@ static inline unsigned int mlx5e_accel_tx_ids_len(struct mlx5e_txqsq *sq,
 
 static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 				       struct sk_buff *skb,
-				       struct mlx5_wqe_eth_seg *eseg)
+				       struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (xfrm_offload(skb))
@@ -172,7 +174,7 @@ static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 
 #if IS_ENABLED(CONFIG_GENEVE)
 	if (skb->encapsulation)
-		mlx5e_tx_tunnel_accel(skb, eseg);
+		mlx5e_tx_tunnel_accel(skb, eseg, ihs);
 #endif
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index e47e2a0059d0..61ed671fe741 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -682,9 +682,9 @@ void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
 
 static bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
 				   struct sk_buff *skb, struct mlx5e_accel_tx_state *accel,
-				   struct mlx5_wqe_eth_seg *eseg)
+				   struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
-	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg)))
+	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg, ihs)))
 		return false;
 
 	mlx5e_txwqe_build_eseg_csum(sq, skb, accel, eseg);
@@ -714,7 +714,8 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
 			struct mlx5_wqe_eth_seg eseg = {};
 
-			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg)))
+			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg,
+							     attr.ihs)))
 				return NETDEV_TX_OK;
 
 			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
@@ -731,7 +732,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* May update the WQE, but may not post other WQEs. */
 	mlx5e_accel_tx_finish(sq, wqe, &accel,
 			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
-	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth)))
+	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs)))
 		return NETDEV_TX_OK;
 
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
-- 
2.26.2

