Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACC12738DE
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgIVCsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbgIVCrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:47 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB69F22262;
        Tue, 22 Sep 2020 02:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742866;
        bh=9lGIVuJcPfPjelBIueA1s0kKAT4Q3rcIwiAchyA/UBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSoDliFgwEAWbHVMGB5nfDcwUyOvGrXNemyaV0pB+Xxk4qzAL3SFh7ydzqOPuQ5KN
         PSUJWECcMCA1bFZroYjMMIP9VVW8vGR75hlTijy80O1jDMyO6bBq57x02ad81Cztqs
         7zta6uKiin9VMBHOkLPjztuUhzayErR7aW0gqVz4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 08/12] net/mlx5e: Support multiple SKBs in a TX WQE
Date:   Mon, 21 Sep 2020 19:47:00 -0700
Message-Id: <20200922024704.544482-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

TX MPWQE support for SKBs is coming in one of the following patches, and
a single MPWQE can send multiple SKBs. This commit prepares the TX path
code to handle such cases:

1. An additional FIFO for SKBs is added, just like the FIFO for DMA
chunks.

2. struct mlx5e_tx_wqe_info will contain num_fifo_pkts. If a given WQE
contains only one packet, num_fifo_pkts will be zero, and the SKB will
be stored in mlx5e_tx_wqe_info, as usual. If num_fifo_pkts > 0, the SKB
pointer will be NULL, and the SKBs will be stored in the FIFO.

This change has no performance impact in TCP single stream test and
XDP_TX single stream test.

When compiled with a recent GCC, this change shows no visible
performance impact on UDP pktgen (burst 32) single stream test either:
  Packet rate: 16.95 Mpps (±0.15 Mpps) -> 16.96 Mpps (±0.12 Mpps)
  Instructions per packet: 429 -> 421
  Cycles per packet: 160 -> 156
  Instructions per cycle: 2.69 -> 2.70

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx
GCC 10.2.0

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 18 +++++
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 10 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 69 ++++++++++++++-----
 5 files changed, 87 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 95aab8b429cf..04c6ff2386bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -318,11 +318,13 @@ struct mlx5e_txqsq {
 
 	/* dirtied @completion */
 	u16                        cc;
+	u16                        skb_fifo_cc;
 	u32                        dma_fifo_cc;
 	struct dim                 dim; /* Adaptive Moderation */
 
 	/* dirtied @xmit */
 	u16                        pc ____cacheline_aligned_in_smp;
+	u16                        skb_fifo_pc;
 	u32                        dma_fifo_pc;
 
 	struct mlx5e_cq            cq;
@@ -330,9 +332,11 @@ struct mlx5e_txqsq {
 	/* read only */
 	struct mlx5_wq_cyc         wq;
 	u32                        dma_fifo_mask;
+	u16                        skb_fifo_mask;
 	struct mlx5e_sq_stats     *stats;
 	struct {
 		struct mlx5e_sq_dma       *dma_fifo;
+		struct sk_buff           **skb_fifo;
 		struct mlx5e_tx_wqe_info  *wqe_info;
 	} db;
 	void __iomem              *uar_map;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 277725c05de4..03fe92323f48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -105,6 +105,7 @@ struct mlx5e_tx_wqe_info {
 	u32 num_bytes;
 	u8 num_wqebbs;
 	u8 num_dma;
+	u8 num_fifo_pkts;
 #ifdef CONFIG_MLX5_EN_TLS
 	struct page *resync_dump_frag_page;
 #endif
@@ -231,6 +232,23 @@ mlx5e_dma_push(struct mlx5e_txqsq *sq, dma_addr_t addr, u32 size,
 	dma->type = map_type;
 }
 
+static inline struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_txqsq *sq, u16 i)
+{
+	return &sq->db.skb_fifo[i & sq->skb_fifo_mask];
+}
+
+static inline void mlx5e_skb_fifo_push(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+{
+	struct sk_buff **skb_item = mlx5e_skb_fifo_get(sq, sq->skb_fifo_pc++);
+
+	*skb_item = skb;
+}
+
+static inline struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_txqsq *sq)
+{
+	return *mlx5e_skb_fifo_get(sq, sq->skb_fifo_cc++);
+}
+
 static inline void
 mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index fcfb156cf09d..7521c9be735b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -29,20 +29,24 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
-static inline void
+static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					  struct mlx5e_tx_wqe_info *wi,
 					  u32 *dma_fifo_cc)
 {
-	if (unlikely(wi->resync_dump_frag_page))
+	if (unlikely(wi->resync_dump_frag_page)) {
 		mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma_fifo_cc);
+		return true;
+	}
+	return false;
 }
 #else
-static inline void
+static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					  struct mlx5e_tx_wqe_info *wi,
 					  u32 *dma_fifo_cc)
 {
+	return false;
 }
 
 #endif /* CONFIG_MLX5_EN_TLS */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b057a6c3a6d5..c331aa9714f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1047,6 +1047,7 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
 static void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
 {
 	kvfree(sq->db.wqe_info);
+	kvfree(sq->db.skb_fifo);
 	kvfree(sq->db.dma_fifo);
 }
 
@@ -1058,15 +1059,19 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
 	sq->db.dma_fifo = kvzalloc_node(array_size(df_sz,
 						   sizeof(*sq->db.dma_fifo)),
 					GFP_KERNEL, numa);
+	sq->db.skb_fifo = kvzalloc_node(array_size(df_sz,
+						   sizeof(*sq->db.skb_fifo)),
+					GFP_KERNEL, numa);
 	sq->db.wqe_info = kvzalloc_node(array_size(wq_sz,
 						   sizeof(*sq->db.wqe_info)),
 					GFP_KERNEL, numa);
-	if (!sq->db.dma_fifo || !sq->db.wqe_info) {
+	if (!sq->db.dma_fifo || !sq->db.skb_fifo || !sq->db.wqe_info) {
 		mlx5e_free_txqsq_db(sq);
 		return -ENOMEM;
 	}
 
 	sq->dma_fifo_mask = df_sz - 1;
+	sq->skb_fifo_mask = df_sz - 1;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index aea30399f664..857d1c0397d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -342,6 +342,7 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		.num_bytes = attr->num_bytes,
 		.num_dma = num_dma,
 		.num_wqebbs = wqe_attr->num_wqebbs,
+		.num_fifo_pkts = 0,
 	};
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | attr->opcode);
@@ -489,6 +490,18 @@ static void mlx5e_consume_skb(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	napi_consume_skb(skb, napi_budget);
 }
 
+static void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_txqsq *sq, struct mlx5e_tx_wqe_info *wi,
+					  struct mlx5_cqe64 *cqe, int napi_budget)
+{
+	int i;
+
+	for (i = 0; i < wi->num_fifo_pkts; i++) {
+		struct sk_buff *skb = mlx5e_skb_fifo_pop(sq);
+
+		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
+	}
+}
+
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_sq_stats *stats;
@@ -534,26 +547,33 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
 		do {
-			struct sk_buff *skb;
-
 			last_wqe = (sqcc == wqe_counter);
 
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi = &sq->db.wqe_info[ci];
-			skb = wi->skb;
 
 			sqcc += wi->num_wqebbs;
 
-			if (unlikely(!skb)) {
-				mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+			if (likely(wi->skb)) {
+				mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+				mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
+
+				npkts++;
+				nbytes += wi->num_bytes;
 				continue;
 			}
 
-			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
-			mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
+			if (unlikely(mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi,
+									       &dma_fifo_cc)))
+				continue;
 
-			npkts++;
-			nbytes += wi->num_bytes;
+			if (wi->num_fifo_pkts) {
+				mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+				mlx5e_tx_wi_consume_fifo_skbs(sq, wi, cqe, napi_budget);
+
+				npkts += wi->num_fifo_pkts;
+				nbytes += wi->num_bytes;
+			}
 		} while (!last_wqe);
 
 		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
@@ -592,12 +612,19 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 	return (i == MLX5E_TX_CQ_POLL_BUDGET);
 }
 
+static void mlx5e_tx_wi_kfree_fifo_skbs(struct mlx5e_txqsq *sq, struct mlx5e_tx_wqe_info *wi)
+{
+	int i;
+
+	for (i = 0; i < wi->num_fifo_pkts; i++)
+		dev_kfree_skb_any(mlx5e_skb_fifo_pop(sq));
+}
+
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
 	u32 dma_fifo_cc, nbytes = 0;
 	u16 ci, sqcc, npkts = 0;
-	struct sk_buff *skb;
 
 	sqcc = sq->cc;
 	dma_fifo_cc = sq->dma_fifo_cc;
@@ -605,20 +632,28 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 	while (sqcc != sq->pc) {
 		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi = &sq->db.wqe_info[ci];
-		skb = wi->skb;
 
 		sqcc += wi->num_wqebbs;
 
-		if (!skb) {
-			mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+		if (likely(wi->skb)) {
+			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+			dev_kfree_skb_any(wi->skb);
+
+			npkts++;
+			nbytes += wi->num_bytes;
 			continue;
 		}
 
-		mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
-		dev_kfree_skb_any(skb);
+		if (unlikely(mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc)))
+			continue;
 
-		npkts++;
-		nbytes += wi->num_bytes;
+		if (wi->num_fifo_pkts) {
+			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+			mlx5e_tx_wi_kfree_fifo_skbs(sq, wi);
+
+			npkts += wi->num_fifo_pkts;
+			nbytes += wi->num_bytes;
+		}
 	}
 
 	sq->dma_fifo_cc = dma_fifo_cc;
-- 
2.26.2

