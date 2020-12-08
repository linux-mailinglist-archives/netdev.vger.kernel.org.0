Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792982D335B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgLHUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731148AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 05/15] net/mlx5e: Change skb fifo push/pop API to be used without SQ
Date:   Tue,  8 Dec 2020 11:35:45 -0800
Message-Id: <20201208193555.674504-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

The skb fifo push/pop API used pre-defined attributes within the
mlx5e_txqsq.
In order to share the skb fifo API with other non-SQ use cases,
change the API input to get newly defined mlx5e_skb_fifo struct.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   |  6 +++---
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c014e8ff66aa..7f3bd3d406b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -331,6 +331,13 @@ struct mlx5e_tx_mpwqe {
 	u8 inline_on;
 };
 
+struct mlx5e_skb_fifo {
+	struct sk_buff **fifo;
+	u16 *pc;
+	u16 *cc;
+	u16 mask;
+};
+
 struct mlx5e_txqsq {
 	/* data path */
 
@@ -351,11 +358,10 @@ struct mlx5e_txqsq {
 	/* read only */
 	struct mlx5_wq_cyc         wq;
 	u32                        dma_fifo_mask;
-	u16                        skb_fifo_mask;
 	struct mlx5e_sq_stats     *stats;
 	struct {
 		struct mlx5e_sq_dma       *dma_fifo;
-		struct sk_buff           **skb_fifo;
+		struct mlx5e_skb_fifo      skb_fifo;
 		struct mlx5e_tx_wqe_info  *wqe_info;
 	} db;
 	void __iomem              *uar_map;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index ac47efaaebd5..115ab19ffab1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -250,21 +250,24 @@ mlx5e_dma_push(struct mlx5e_txqsq *sq, dma_addr_t addr, u32 size,
 	dma->type = map_type;
 }
 
-static inline struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_txqsq *sq, u16 i)
+static inline
+struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_skb_fifo *fifo, u16 i)
 {
-	return &sq->db.skb_fifo[i & sq->skb_fifo_mask];
+	return &fifo->fifo[i & fifo->mask];
 }
 
-static inline void mlx5e_skb_fifo_push(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+static inline
+void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 {
-	struct sk_buff **skb_item = mlx5e_skb_fifo_get(sq, sq->skb_fifo_pc++);
+	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
 
 	*skb_item = skb;
 }
 
-static inline struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_txqsq *sq)
+static inline
+struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
-	return *mlx5e_skb_fifo_get(sq, sq->skb_fifo_cc++);
+	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
 
 static inline void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 15750119b413..f18787d79fd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1086,7 +1086,7 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
 static void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
 {
 	kvfree(sq->db.wqe_info);
-	kvfree(sq->db.skb_fifo);
+	kvfree(sq->db.skb_fifo.fifo);
 	kvfree(sq->db.dma_fifo);
 }
 
@@ -1098,19 +1098,22 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
 	sq->db.dma_fifo = kvzalloc_node(array_size(df_sz,
 						   sizeof(*sq->db.dma_fifo)),
 					GFP_KERNEL, numa);
-	sq->db.skb_fifo = kvzalloc_node(array_size(df_sz,
-						   sizeof(*sq->db.skb_fifo)),
+	sq->db.skb_fifo.fifo = kvzalloc_node(array_size(df_sz,
+							sizeof(*sq->db.skb_fifo.fifo)),
 					GFP_KERNEL, numa);
 	sq->db.wqe_info = kvzalloc_node(array_size(wq_sz,
 						   sizeof(*sq->db.wqe_info)),
 					GFP_KERNEL, numa);
-	if (!sq->db.dma_fifo || !sq->db.skb_fifo || !sq->db.wqe_info) {
+	if (!sq->db.dma_fifo || !sq->db.skb_fifo.fifo || !sq->db.wqe_info) {
 		mlx5e_free_txqsq_db(sq);
 		return -ENOMEM;
 	}
 
 	sq->dma_fifo_mask = df_sz - 1;
-	sq->skb_fifo_mask = df_sz - 1;
+
+	sq->db.skb_fifo.pc   = &sq->skb_fifo_pc;
+	sq->db.skb_fifo.cc   = &sq->skb_fifo_cc;
+	sq->db.skb_fifo.mask = df_sz - 1;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 76496c92e786..149d26ae814e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -579,7 +579,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		goto err_unmap;
 	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
 
-	mlx5e_skb_fifo_push(sq, skb);
+	mlx5e_skb_fifo_push(&sq->db.skb_fifo, skb);
 
 	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
 
@@ -719,7 +719,7 @@ static void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_txqsq *sq, struct mlx5e_t
 	int i;
 
 	for (i = 0; i < wi->num_fifo_pkts; i++) {
-		struct sk_buff *skb = mlx5e_skb_fifo_pop(sq);
+		struct sk_buff *skb = mlx5e_skb_fifo_pop(&sq->db.skb_fifo);
 
 		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
 	}
@@ -839,7 +839,7 @@ static void mlx5e_tx_wi_kfree_fifo_skbs(struct mlx5e_txqsq *sq, struct mlx5e_tx_
 	int i;
 
 	for (i = 0; i < wi->num_fifo_pkts; i++)
-		dev_kfree_skb_any(mlx5e_skb_fifo_pop(sq));
+		dev_kfree_skb_any(mlx5e_skb_fifo_pop(&sq->db.skb_fifo));
 }
 
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
-- 
2.26.2

