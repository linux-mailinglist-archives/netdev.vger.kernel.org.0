Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921922F28C1
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391924AbhALHPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391912AbhALHPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 820FF22D2C;
        Tue, 12 Jan 2021 07:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435627;
        bh=FZq3WyksYyFcNQNebkItcEjNBoXI6eirg5XZn++yrbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2+/rtZy70IYrs8R1K+bI7miJJwEcJRu94zuUnhJzpAZMMbKFy7h48xfDLKCYJwel
         wDt16QEE8fCqadbWuMhOWtrWwqaxVXNN12chM0k2ApR1FLD57oZoXL67aWBnJs9CZ0
         /kEDUZOrpXohxoqLqc5rgxy6JkYXm0F2E3C0BQwn3RtO3a1+ED60s1qIofg50XGXkn
         fo+PZe8NReYgsfInmArBHmf7O/PxN+rV+PDw6vDXJTEG+XnAjmM/OuWWAywjHTXPv5
         1VgAfoCEnHXC56hkqpAa34rqKR8pLdm7F/SKgjK6u4Yau0piQyoU4Kt5OAnjsKunsf
         41ZryGh55pKag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 08/11] net/mlx5e: IPsec, Enclose csum logic under ipsec config
Date:   Mon, 11 Jan 2021 23:05:31 -0800
Message-Id: <20210112070534.136841-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

All IPsec logic should be wrapped under the compile flag,
including its checksum logic.
Introduce an inline function in ipsec datapath header,
with a corresponding stub.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c        |  3 +--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 9df9b9a8e09b..fabf4b6b2b84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -87,6 +87,11 @@ static inline bool mlx5e_ipsec_is_tx_flow(struct mlx5e_accel_tx_ipsec_state *ips
 	return ipsec_st->x;
 }
 
+static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
+{
+	return eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC);
+}
+
 void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
 #else
@@ -96,6 +101,11 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 				       struct mlx5_cqe64 *cqe)
 {}
 
+static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
+{
+	return false;
+}
+
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 61ed671fe741..74f233eece54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -241,9 +241,8 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial++;
 #endif
-	} else if (unlikely(eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC))) {
+	} else if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
 		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
-
 	} else
 		sq->stats->csum_none++;
 }
-- 
2.26.2

