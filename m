Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC59156C37
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfFZOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59884 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727957AbfFZOgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:19 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY7027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 09/16] net/mlx5e: Allow ICO SQ to be used by multiple RQs
Date:   Wed, 26 Jun 2019 17:35:31 +0300
Message-Id: <1561559738-4213-10-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Prepare to creation of the XSK RQ, which will require posting UMRs, too.
The same ICO SQ will be used for both RQs and also to trigger interrupts
by posting NOPs. UMR WQEs can't be reused any more. Optimization
introduced in commit ab966d7e4ff98 ("net/mlx5e: RX, Recycle buffer of
UMR WQEs") is reverted.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  9 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 27 +++++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h      |  5 -----
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 992d5cb646b2..c7676635bc8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -348,6 +348,13 @@ enum {
 
 struct mlx5e_sq_wqe_info {
 	u8  opcode;
+
+	/* Auxiliary data for different opcodes. */
+	union {
+		struct {
+			struct mlx5e_rq *rq;
+		} umr;
+	};
 };
 
 struct mlx5e_txqsq {
@@ -571,6 +578,7 @@ struct mlx5e_rq {
 			u8                     log_stride_sz;
 			u8                     umr_in_progress;
 			u8                     umr_last_bulk;
+			u8                     umr_completed;
 		} mpwqe;
 	};
 	struct {
@@ -798,6 +806,7 @@ void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
+void mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
 void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix);
 void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 234a3fd39901..ec34df777c96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -427,11 +427,6 @@ static void mlx5e_post_rx_mpwqe(struct mlx5e_rq *rq, u8 n)
 	mlx5_wq_ll_update_db_record(wq);
 }
 
-static inline u16 mlx5e_icosq_wrap_cnt(struct mlx5e_icosq *sq)
-{
-	return mlx5_wq_cyc_get_ctr_wrap_cnt(&sq->wq, sq->pc);
-}
-
 static inline void mlx5e_fill_icosq_frag_edge(struct mlx5e_icosq *sq,
 					      struct mlx5_wq_cyc *wq,
 					      u16 pi, u16 nnops)
@@ -467,9 +462,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	}
 
 	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
-	if (unlikely(mlx5e_icosq_wrap_cnt(sq) < 2))
-		memcpy(umr_wqe, &rq->mpwqe.umr_wqe,
-		       offsetof(struct mlx5e_umr_wqe, inline_mtts));
+	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, offsetof(struct mlx5e_umr_wqe, inline_mtts));
 
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++, dma_info++) {
 		err = mlx5e_page_alloc_mapped(rq, dma_info);
@@ -487,6 +480,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
 
 	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_UMR;
+	sq->db.ico_wqe[pi].umr.rq = rq;
 	sq->pc += MLX5E_UMR_WQEBBS;
 
 	sq->doorbell_cseg = &umr_wqe->ctrl;
@@ -544,11 +538,10 @@ bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	return !!err;
 }
 
-static void mlx5e_poll_ico_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq)
+void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
 	struct mlx5_cqe64 *cqe;
-	u8  completed_umr = 0;
 	u16 sqcc;
 	int i;
 
@@ -589,7 +582,7 @@ static void mlx5e_poll_ico_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq)
 
 			if (likely(wi->opcode == MLX5_OPCODE_UMR)) {
 				sqcc += MLX5E_UMR_WQEBBS;
-				completed_umr++;
+				wi->umr.rq->mpwqe.umr_completed++;
 			} else if (likely(wi->opcode == MLX5_OPCODE_NOP)) {
 				sqcc++;
 			} else {
@@ -605,24 +598,24 @@ static void mlx5e_poll_ico_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq)
 	sq->cc = sqcc;
 
 	mlx5_cqwq_update_db_record(&cq->wq);
-
-	if (likely(completed_umr)) {
-		mlx5e_post_rx_mpwqe(rq, completed_umr);
-		rq->mpwqe.umr_in_progress -= completed_umr;
-	}
 }
 
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 {
 	struct mlx5e_icosq *sq = &rq->channel->icosq;
 	struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
+	u8  umr_completed = rq->mpwqe.umr_completed;
 	u8  missing, i;
 	u16 head;
 
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return false;
 
-	mlx5e_poll_ico_cq(&sq->cq, rq);
+	if (umr_completed) {
+		mlx5e_post_rx_mpwqe(rq, umr_completed);
+		rq->mpwqe.umr_in_progress -= umr_completed;
+		rq->mpwqe.umr_completed = 0;
+	}
 
 	missing = mlx5_wq_ll_missing(wq) - rq->mpwqe.umr_in_progress;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index f9862bf75491..de4d5ae431af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -107,7 +107,9 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		busy |= work_done == budget;
 	}
 
-	busy |= c->rq.post_wqes(rq);
+	mlx5e_poll_ico_cq(&c->icosq.cq);
+
+	busy |= rq->post_wqes(rq);
 
 	if (busy) {
 		if (likely(mlx5e_channel_no_affinity_change(c)))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index 1f87cce421e0..f1ec58c9e9e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -134,11 +134,6 @@ static inline void mlx5_wq_cyc_update_db_record(struct mlx5_wq_cyc *wq)
 	*wq->db = cpu_to_be32(wq->wqe_ctr);
 }
 
-static inline u16 mlx5_wq_cyc_get_ctr_wrap_cnt(struct mlx5_wq_cyc *wq, u16 ctr)
-{
-	return ctr >> wq->fbc.log_sz;
-}
-
 static inline u16 mlx5_wq_cyc_ctr2ix(struct mlx5_wq_cyc *wq, u16 ctr)
 {
 	return ctr & wq->fbc.sz_m1;
-- 
1.8.3.1

