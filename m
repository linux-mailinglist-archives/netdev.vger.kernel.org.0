Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0B39ABA7
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFCUNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhFCUNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CACA61405;
        Thu,  3 Jun 2021 20:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751124;
        bh=JiBCw6CYoiby+nKpOcpaLfWxOm6HvxoyX9DfvAT+me0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hkf5mBxG++84u91LzXJet3zfauwptC18fdzv42lmUClQ8IJmz0mfEBbCevu/VWgMy
         9ITCh7rinypHFv+wSS77L2qcKmN11YAcqLOIIqyBulhV5drfXPTTQfNIZONEVozJsm
         8aWpD91DujxQKFpUKbddZk/+njXoO0OLYLzxIjm9ix24xUo6DLD2PM6TP7Qb07cdZc
         17iykDbDEKPRNhsqYxLM+OoqnH3exiNVZ3PyCEUXAhduC/Yut7KWON2zTPCekLxOkJ
         SMoKtIF5KobBxGyLaZ1ss6yZjc+PCi4m6e1SKiLJVUDtFQ9SWBuz8WF5uN6WShsqT/
         urUV5HkZUbgAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/10] net/mlx5e: Remove unreachable code in mlx5e_xmit()
Date:   Thu,  3 Jun 2021 13:11:55 -0700
Message-Id: <20210603201155.109184-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

After some commits, mlx5e_txwqe_build_eseg() lost its ability to return
boolean value and became effectively void.

Change its return type to void and remove unreachable branches.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h      |  4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 17 ++++-------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 00af0b831a28..d964665eaa63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -162,7 +162,7 @@ static inline unsigned int mlx5e_accel_tx_ids_len(struct mlx5e_txqsq *sq,
 /* Part of the eseg touched by TX offloads */
 #define MLX5E_ACCEL_ESEG_LEN offsetof(struct mlx5_wqe_eth_seg, mss)
 
-static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
+static inline void mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 				       struct sk_buff *skb,
 				       struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
@@ -175,8 +175,6 @@ static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 	if (skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL)
 		mlx5e_tx_tunnel_accel(skb, eseg, ihs);
 #endif
-
-	return true;
 }
 
 static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 8ba62671f5f1..669ff58107e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -706,16 +706,12 @@ void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
 		mlx5e_tx_mpwqe_session_complete(sq);
 }
 
-static bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
+static void mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
 				   struct sk_buff *skb, struct mlx5e_accel_tx_state *accel,
 				   struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
-	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg, ihs)))
-		return false;
-
+	mlx5e_accel_tx_eseg(priv, skb, eseg, ihs);
 	mlx5e_txwqe_build_eseg_csum(sq, skb, accel, eseg);
-
-	return true;
 }
 
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -744,10 +740,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
 			struct mlx5_wqe_eth_seg eseg = {};
 
-			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg,
-							     attr.ihs)))
-				return NETDEV_TX_OK;
-
+			mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg, attr.ihs);
 			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
 			return NETDEV_TX_OK;
 		}
@@ -762,9 +755,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* May update the WQE, but may not post other WQEs. */
 	mlx5e_accel_tx_finish(sq, wqe, &accel,
 			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
-	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs)))
-		return NETDEV_TX_OK;
-
+	mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs);
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
 
 	return NETDEV_TX_OK;
-- 
2.31.1

