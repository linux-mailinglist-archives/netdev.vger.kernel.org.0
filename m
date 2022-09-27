Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8485ECEBF
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiI0Uhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiI0Ug7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC25480F65
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C2AB81C16
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D613BC433C1;
        Tue, 27 Sep 2022 20:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311015;
        bh=MPlo2gZCOQ5k4FdTb7oWiYgpfRYQvo3utyNNZ3HiLJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/C+OrzDgbHZBNkUAfFsnlixNtIqi7xLjEiqlsmNskz5EiKkjdNYUE0pVKwKZP9Dw
         sXbNpmnN0at5JzK/Bkze0ZNlEuV0nrUwa+M3bIDrhcka52WfTbWOTioFuGewZ9ddLR
         nYz/oD+WivMhEd9GKNnBrhwY3Jd4vuuWbFsHEs7YC4N4OL6vQsgzdGJHNW3yKPTN+2
         ValUeS2qANXEN9Srxr3UWLcUv25qHdzG2FahzROWyIbx3jHaSQbPG01GdidUWVSzQG
         6Ye5a4y90rZq5rc/BVLEhxp13qaJnnb0Qg/TShGqdvtnn4CFoCZ0iJ3AQaEc0gZVAc
         4amIcNSslqYmQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 16/16] net/mlx5e: Use runtime values of striding RQ parameters in datapath
Date:   Tue, 27 Sep 2022 13:36:11 -0700
Message-Id: <20220927203611.244301-17-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Some of the parameters of striding RQ are compile-time constants, but
they are going to become dynamically calculated at runtime in a
following commit. This commit prepares the datapath to take cached
runtime parameters, prefilled at queue creation.

New fields added to struct mlx5e_rq fit into an existing 7-byte hole.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 12 ++----
 .../ethernet/mellanox/mlx5/core/en/params.c   | 14 ++++++-
 .../ethernet/mellanox/mlx5/core/en/params.h   |  5 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 41 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 35 ++++++++--------
 5 files changed, 65 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0c716db88cf4..9ff746a09a17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -107,7 +107,6 @@ struct page_pool;
  * dropped by the driver at a later stage.
  */
 #define MLX5E_REQUIRED_WQE_MTTS		(MLX5_ALIGN_MTTS(MLX5_MPWRQ_PAGES_PER_WQE + 1))
-#define MLX5E_REQUIRED_MTTS(wqes)	(wqes * MLX5E_REQUIRED_WQE_MTTS)
 #define MLX5E_MAX_RQ_NUM_MTTS	\
 	(ALIGN_DOWN(U16_MAX, 4) * 2) /* So that MLX5_MTT_OCTW(num_mtts) fits into u16 */
 #define MLX5E_ORDER2_MAX_PACKET_MTU (order_base_2(10 * 1024))
@@ -150,13 +149,6 @@ struct page_pool;
 #define MLX5E_TX_XSK_POLL_BUDGET       64
 #define MLX5E_SQ_RECOVER_MIN_INTERVAL  500 /* msecs */
 
-#define MLX5E_UMR_WQE_INLINE_SZ \
-	(sizeof(struct mlx5e_umr_wqe) + \
-	 ALIGN(MLX5_MPWRQ_PAGES_PER_WQE * sizeof(struct mlx5_mtt), \
-	       MLX5_UMR_MTT_ALIGNMENT))
-#define MLX5E_UMR_WQEBBS \
-	(DIV_ROUND_UP(MLX5E_UMR_WQE_INLINE_SZ, MLX5_SEND_WQE_BB))
-
 #define MLX5E_KLM_UMR_WQE_SZ(sgl_len)\
 	(sizeof(struct mlx5e_umr_wqe) +\
 	(sizeof(struct mlx5_klm) * (sgl_len)))
@@ -712,6 +704,10 @@ struct mlx5e_rq {
 			u8                     umr_last_bulk;
 			u8                     umr_completed;
 			u8                     min_wqe_bulk;
+			u8                     page_shift;
+			u8                     pages_per_wqe;
+			u8                     umr_wqebbs;
+			u8                     mtts_per_wqe;
 			struct mlx5e_shampo_hd *shampo;
 		} mpwqe;
 	};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9a58f8f978b1..5f8912e8404d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -7,6 +7,17 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec.h"
 
+u16 mlx5e_mpwrq_umr_wqe_sz(u8 pages_per_wqe)
+{
+	return sizeof(struct mlx5e_umr_wqe) +
+		ALIGN(pages_per_wqe * sizeof(struct mlx5_mtt), MLX5_UMR_MTT_ALIGNMENT);
+}
+
+u8 mlx5e_mpwrq_umr_wqebbs(u8 pages_per_wqe)
+{
+	return DIV_ROUND_UP(mlx5e_mpwrq_umr_wqe_sz(pages_per_wqe), MLX5_SEND_WQE_BB);
+}
+
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk)
 {
@@ -786,7 +797,8 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 	if (params->rq_wq_type != MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
 		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 
-	wqebbs = MLX5E_UMR_WQEBBS * BIT(mlx5e_get_rq_log_wq_sz(rqp->rqc));
+	wqebbs = mlx5e_mpwrq_umr_wqebbs(MLX5_MPWRQ_PAGES_PER_WQE) *
+		(1 << mlx5e_get_rq_log_wq_sz(rqp->rqc));
 
 	/* If XDP program is attached, XSK may be turned on at any time without
 	 * restarting the channel. ICOSQ must be big enough to fit UMR WQEs of
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index f2c1a23dca61..2bb9aba57ea0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -84,6 +84,11 @@ static inline bool mlx5e_qid_validate(const struct mlx5e_profile *profile,
 	return qid < params->num_channels * profile->rq_groups;
 }
 
+/* Striding RQ dynamic parameters */
+
+u16 mlx5e_mpwrq_umr_wqe_sz(u8 pages_per_wqe);
+u8 mlx5e_mpwrq_umr_wqebbs(u8 pages_per_wqe);
+
 /* Parameter calculations */
 
 void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 978805931347..f71b2d3bce98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -71,17 +71,20 @@
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
 	bool striding_rq_umr, inline_umr;
-	u16 max_wqe_sz_cap;
+	u16 max_wqebbs;
+	u16 umr_wqebbs;
 
 	striding_rq_umr = MLX5_CAP_GEN(mdev, striding_rq) && MLX5_CAP_GEN(mdev, umr_ptr_rlky) &&
 			  MLX5_CAP_ETH(mdev, reg_umr_sq);
-	max_wqe_sz_cap = mlx5e_get_max_sq_aligned_wqebbs(mdev) * MLX5_SEND_WQE_BB;
-	inline_umr = max_wqe_sz_cap >= MLX5E_UMR_WQE_INLINE_SZ;
+	max_wqebbs = mlx5e_get_max_sq_aligned_wqebbs(mdev);
+	umr_wqebbs = mlx5e_mpwrq_umr_wqebbs(MLX5_MPWRQ_PAGES_PER_WQE);
+	inline_umr = umr_wqebbs <= max_wqebbs;
 	if (!striding_rq_umr)
 		return false;
 	if (!inline_umr) {
-		mlx5_core_warn(mdev, "Cannot support Striding RQ: UMR WQE size (%d) exceeds maximum supported (%d).\n",
-			       (int)MLX5E_UMR_WQE_INLINE_SZ, max_wqe_sz_cap);
+		mlx5_core_warn(mdev, "Cannot support Striding RQ: UMR WQE size (%u) exceeds maximum supported (%u).\n",
+			       umr_wqebbs * MLX5_SEND_WQE_BB,
+			       max_wqebbs * MLX5_SEND_WQE_BB);
 		return false;
 	}
 	return true;
@@ -206,7 +209,10 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 {
 	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
-	u8 ds_cnt = DIV_ROUND_UP(MLX5E_UMR_WQE_INLINE_SZ, MLX5_SEND_WQE_DS);
+	u8 ds_cnt;
+
+	ds_cnt = DIV_ROUND_UP(mlx5e_mpwrq_umr_wqe_sz(rq->mpwqe.pages_per_wqe),
+			      MLX5_SEND_WQE_DS);
 
 	cseg->qpn_ds    = cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				      ds_cnt);
@@ -214,7 +220,7 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 
 	ucseg->flags = MLX5_UMR_TRANSLATION_OFFSET_EN | MLX5_UMR_INLINE;
 	ucseg->xlt_octowords =
-		cpu_to_be16(MLX5_MTT_OCTW(MLX5_MPWRQ_PAGES_PER_WQE));
+		cpu_to_be16(MLX5_MTT_OCTW(rq->mpwqe.pages_per_wqe));
 	ucseg->mkey_mask     = cpu_to_be64(MLX5_MKEY_MASK_FREE);
 }
 
@@ -263,7 +269,7 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 	size_t alloc_size;
 
 	alloc_size = array_size(wq_sz, struct_size(rq->mpwqe.info, dma_info,
-						   MLX5_MPWRQ_PAGES_PER_WQE));
+						   rq->mpwqe.pages_per_wqe));
 
 	rq->mpwqe.info = kvzalloc_node(alloc_size, GFP_KERNEL, node);
 	if (!rq->mpwqe.info)
@@ -359,9 +365,9 @@ static int mlx5e_create_umr_klm_mkey(struct mlx5_core_dev *mdev,
 
 static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq *rq)
 {
-	u64 num_mtts = MLX5E_REQUIRED_MTTS(mlx5_wq_ll_get_size(&rq->mpwqe.wq));
+	u64 num_mtts = mlx5_wq_ll_get_size(&rq->mpwqe.wq) * rq->mpwqe.mtts_per_wqe;
 
-	return mlx5e_create_umr_mtt_mkey(mdev, num_mtts, PAGE_SHIFT,
+	return mlx5e_create_umr_mtt_mkey(mdev, num_mtts, rq->mpwqe.page_shift,
 					 &rq->umr_mkey, rq->wqe_overflow.addr);
 }
 
@@ -379,11 +385,6 @@ static int mlx5e_create_rq_hd_umr_mkey(struct mlx5_core_dev *mdev,
 					 &rq->mpwqe.shampo->mkey);
 }
 
-static u64 mlx5e_get_mpwqe_offset(u16 wqe_ix)
-{
-	return MLX5E_REQUIRED_MTTS(wqe_ix) << PAGE_SHIFT;
-}
-
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 {
 	struct mlx5e_wqe_frag_info next_frag = {};
@@ -590,7 +591,12 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 		wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
 
-		pool_size = MLX5_MPWRQ_PAGES_PER_WQE <<
+		rq->mpwqe.page_shift = PAGE_SHIFT;
+		rq->mpwqe.pages_per_wqe = MLX5_MPWRQ_PAGES_PER_WQE;
+		rq->mpwqe.umr_wqebbs = mlx5e_mpwrq_umr_wqebbs(rq->mpwqe.pages_per_wqe);
+		rq->mpwqe.mtts_per_wqe = MLX5E_REQUIRED_WQE_MTTS;
+
+		pool_size = rq->mpwqe.pages_per_wqe <<
 			mlx5e_mpwqe_get_log_rq_size(params, xsk);
 
 		rq->mpwqe.log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
@@ -680,7 +686,8 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 				mlx5_wq_ll_get_wqe(&rq->mpwqe.wq, i);
 			u32 byte_count =
 				rq->mpwqe.num_strides << rq->mpwqe.log_stride_sz;
-			u64 dma_offset = mlx5e_get_mpwqe_offset(i);
+			u64 dma_offset = mul_u32_u32(i, rq->mpwqe.mtts_per_wqe) <<
+				rq->mpwqe.page_shift;
 			u16 headroom = test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state) ?
 				       0 : rq->buff.headroom;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b910fc1dbc72..e2f360da6437 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -77,7 +77,7 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
 
 static struct mlx5e_mpw_info *mlx5e_get_mpw_info(struct mlx5e_rq *rq, int i)
 {
-	size_t isz = struct_size(rq->mpwqe.info, dma_info, MLX5_MPWRQ_PAGES_PER_WQE);
+	size_t isz = struct_size(rq->mpwqe.info, dma_info, rq->mpwqe.pages_per_wqe);
 
 	return (struct mlx5e_mpw_info *)((char *)rq->mpwqe.info + array_size(i, isz));
 }
@@ -272,6 +272,7 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq,
 	stats->cache_reuse++;
 
 	dma_sync_single_for_device(rq->pdev, dma_info->addr,
+				   /* Non-XSK always uses PAGE_SIZE. */
 				   PAGE_SIZE,
 				   DMA_FROM_DEVICE);
 	return true;
@@ -287,6 +288,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 	if (unlikely(!dma_info->page))
 		return -ENOMEM;
 
+	/* Non-XSK always uses PAGE_SIZE. */
 	dma_info->addr = dma_map_page_attrs(rq->pdev, dma_info->page, 0, PAGE_SIZE,
 					    rq->buff.map_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(rq->pdev, dma_info->addr))) {
@@ -489,13 +491,12 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 	int i;
 
 	/* A common case for AF_XDP. */
-	if (bitmap_full(wi->xdp_xmit_bitmap, MLX5_MPWRQ_PAGES_PER_WQE))
+	if (bitmap_full(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe))
 		return;
 
-	no_xdp_xmit = bitmap_empty(wi->xdp_xmit_bitmap,
-				   MLX5_MPWRQ_PAGES_PER_WQE);
+	no_xdp_xmit = bitmap_empty(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
 
-	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++)
+	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
 		if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
 			mlx5e_page_release(rq, &dma_info[i], recycle);
 }
@@ -680,7 +681,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	 * one-by-one, failing and moving frames to the Reuse Ring.
 	 */
 	if (rq->xsk_pool &&
-	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool, MLX5_MPWRQ_PAGES_PER_WQE))) {
+	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe))) {
 		err = -ENOMEM;
 		goto err;
 	}
@@ -691,33 +692,33 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 			goto err;
 	}
 
-	pi = mlx5e_icosq_get_next_pi(sq, MLX5E_UMR_WQEBBS);
+	pi = mlx5e_icosq_get_next_pi(sq, rq->mpwqe.umr_wqebbs);
 	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
 	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, offsetof(struct mlx5e_umr_wqe, inline_mtts));
 
-	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++, dma_info++) {
+	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, dma_info++) {
 		err = mlx5e_page_alloc(rq, dma_info);
 		if (unlikely(err))
 			goto err_unmap;
 		umr_wqe->inline_mtts[i].ptag = cpu_to_be64(dma_info->addr | MLX5_EN_WR);
 	}
 
-	bitmap_zero(wi->xdp_xmit_bitmap, MLX5_MPWRQ_PAGES_PER_WQE);
+	bitmap_zero(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
 	wi->consumed_strides = 0;
 
 	umr_wqe->ctrl.opmod_idx_opcode =
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
 	umr_wqe->uctrl.xlt_offset =
-		cpu_to_be16(MLX5_ALIGNED_MTTS_OCTW(MLX5E_REQUIRED_MTTS(ix)));
+		cpu_to_be16(MLX5_ALIGNED_MTTS_OCTW(ix * rq->mpwqe.mtts_per_wqe));
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type   = MLX5E_ICOSQ_WQE_UMR_RX,
-		.num_wqebbs = MLX5E_UMR_WQEBBS,
+		.num_wqebbs = rq->mpwqe.umr_wqebbs,
 		.umr.rq     = rq,
 	};
 
-	sq->pc += MLX5E_UMR_WQEBBS;
+	sq->pc += rq->mpwqe.umr_wqebbs;
 
 	sq->doorbell_cseg = &umr_wqe->ctrl;
 
@@ -1805,8 +1806,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, wqe_id);
 	u16 stride_ix      = mpwrq_get_cqe_stride_index(cqe);
 	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
-	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
-	u32 page_idx       = wqe_offset >> PAGE_SHIFT;
+	u32 head_offset    = wqe_offset & ((1 << rq->mpwqe.page_shift) - 1);
+	u32 page_idx       = wqe_offset >> rq->mpwqe.page_shift;
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5_wq_ll *wq;
 	struct sk_buff *skb;
@@ -1863,6 +1864,7 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq, struct mlx5e_dma_i
 	net_prefetchw(skb->data);
 
 	while (data_bcnt) {
+		/* Non-linear mode, hence non-XSK, which always uses PAGE_SIZE. */
 		u32 pg_consumed_bytes = min_t(u32, PAGE_SIZE - data_offset, data_bcnt);
 		unsigned int truesize;
 
@@ -1900,6 +1902,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	net_prefetchw(skb->data);
 
+	/* Non-linear mode, hence non-XSK, which always uses PAGE_SIZE. */
 	if (unlikely(frag_offset >= PAGE_SIZE)) {
 		di++;
 		frag_offset -= PAGE_SIZE;
@@ -2157,8 +2160,8 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, wqe_id);
 	u16 stride_ix      = mpwrq_get_cqe_stride_index(cqe);
 	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
-	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
-	u32 page_idx       = wqe_offset >> PAGE_SHIFT;
+	u32 head_offset    = wqe_offset & ((1 << rq->mpwqe.page_shift) - 1);
+	u32 page_idx       = wqe_offset >> rq->mpwqe.page_shift;
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5_wq_ll *wq;
 	struct sk_buff *skb;
-- 
2.37.3

