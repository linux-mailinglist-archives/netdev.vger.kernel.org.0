Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B885F1000
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiI3QaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiI3QaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:30:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665F6E028
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F085D62396
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494F8C43140;
        Fri, 30 Sep 2022 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555376;
        bh=RCO0un2f4V7sBS19gyQcZ5tcar6k00CrIRzRWLIxNvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJnqJ8xOwN34iqUQP05b5SACpyQ2sVTmPSzZivZcS4oZo7IkfBESGbWf1jLp1iI/r
         dislbzUnF5KO2+1S6vHaK7Y3tJmZ6q0q71wumb+B7Z1lx/FQsGnoRsPRX6pmgSCzUS
         afnSEgzkROU4zdzrMcvR5tsF8L20LKQkosaPuB3hZiH2jsvcYZxUZmT3AWJiP83p3t
         lX8kO8Baic18s/cyDCLtMHLugSm3auff0x0jVSLM/3hmDqn9xONEmZUQQKMlBL1aQO
         abG9WmUrxIxQUUdxmYF2oqfok8tx5e54VVEHIQ5ioQq8obviF+1OGnK0G2gQBcV9ic
         NvM24c1T0nAZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 10/16] net/mlx5e: xsk: Use xsk_buff_alloc_batch on striding RQ
Date:   Fri, 30 Sep 2022 09:28:57 -0700
Message-Id: <20220930162903.62262-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
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

XSK provides a function to allocate frames in batches for more efficient
processing. This commit starts using this function on striding RQ and
creates an optimized flow for XSK. A side effect is an opportunity to
optimize the regular RX flow by dropping branching for XSK cases.

Performance improvement is up to 6.4% in the aligned mode and up to 7.5%
in the unaligned mode.

Aligned mode, 2048-byte frames: 12.9 Mpps -> 13.8 Mpps
Aligned mode, 4096-byte frames: 11.8 Mpps -> 12.5 Mpps
Unaligned mode, 2048-byte frames: 11.9 Mpps -> 12.8 Mpps
Unaligned mode, 3072-byte frames: 11.4 Mpps -> 12.1 Mpps
Unaligned mode, 4096-byte frames: 11.0 Mpps -> 11.2 Mpps

CPU: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  7 ++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 88 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++---------
 4 files changed, 106 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index f4f306bb8e6d..4456ad5cedf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -452,4 +452,11 @@ static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size
 
 	return mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room);
 }
+
+static inline struct mlx5e_mpw_info *mlx5e_get_mpw_info(struct mlx5e_rq *rq, int i)
+{
+	size_t isz = struct_size(rq->mpwqe.info, alloc_units, rq->mpwqe.pages_per_wqe);
+
+	return (struct mlx5e_mpw_info *)((char *)rq->mpwqe.info + array_size(i, isz));
+}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 812a370f6aea..7bd49f0b1271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -8,6 +8,90 @@
 
 /* RX data path */
 
+int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
+{
+	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
+	struct mlx5e_icosq *icosq = rq->icosq;
+	struct mlx5_wq_cyc *wq = &icosq->wq;
+	struct mlx5e_umr_wqe *umr_wqe;
+	int batch, i;
+	u32 offset; /* 17-bit value with MTT. */
+	u16 pi;
+
+	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe)))
+		goto err;
+
+	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].xsk));
+	batch = xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->alloc_units,
+				     rq->mpwqe.pages_per_wqe);
+
+	/* If batch < pages_per_wqe, either:
+	 * 1. Some (or all) descriptors were invalid.
+	 * 2. dma_need_sync is true, and it fell back to allocating one frame.
+	 * In either case, try to continue allocating frames one by one, until
+	 * the first error, which will mean there are no more valid descriptors.
+	 */
+	for (; batch < rq->mpwqe.pages_per_wqe; batch++) {
+		wi->alloc_units[batch].xsk = xsk_buff_alloc(rq->xsk_pool);
+		if (unlikely(!wi->alloc_units[batch].xsk))
+			goto err_reuse_batch;
+	}
+
+	pi = mlx5e_icosq_get_next_pi(icosq, rq->mpwqe.umr_wqebbs);
+	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
+	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, sizeof(struct mlx5e_umr_wqe));
+
+	if (unlikely(rq->mpwqe.unaligned)) {
+		for (i = 0; i < batch; i++) {
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+
+			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
+				.key = rq->mkey_be,
+				.va = cpu_to_be64(addr),
+			};
+		}
+	} else {
+		for (i = 0; i < batch; i++) {
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+
+			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
+				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
+			};
+		}
+	}
+
+	bitmap_zero(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
+	wi->consumed_strides = 0;
+
+	umr_wqe->ctrl.opmod_idx_opcode =
+		cpu_to_be32((icosq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) | MLX5_OPCODE_UMR);
+
+	offset = ix * rq->mpwqe.mtts_per_wqe;
+	if (likely(!rq->mpwqe.unaligned))
+		offset = MLX5_ALIGNED_MTTS_OCTW(offset);
+	umr_wqe->uctrl.xlt_offset = cpu_to_be16(offset);
+
+	icosq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
+		.wqe_type = MLX5E_ICOSQ_WQE_UMR_RX,
+		.num_wqebbs = rq->mpwqe.umr_wqebbs,
+		.umr.rq = rq,
+	};
+
+	icosq->pc += rq->mpwqe.umr_wqebbs;
+
+	icosq->doorbell_cseg = &umr_wqe->ctrl;
+
+	return 0;
+
+err_reuse_batch:
+	while (--batch >= 0)
+		xsk_buff_free(wi->alloc_units[batch].xsk);
+
+err:
+	rq->stats->buff_alloc_err++;
+	return -ENOMEM;
+}
+
 int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
@@ -112,7 +196,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	 */
 	WARN_ON_ONCE(head_offset);
 
-	xdp->data_end = xdp->data + cqe_bcnt;
+	xsk_buff_set_size(xdp, cqe_bcnt);
 	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
@@ -159,7 +243,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	 */
 	WARN_ON_ONCE(wi->offset);
 
-	xdp->data_end = xdp->data + cqe_bcnt;
+	xsk_buff_set_size(xdp, cqe_bcnt);
 	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 7898a78237b8..84a496a8d72f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -9,6 +9,7 @@
 
 /* RX data path */
 
+int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix);
 int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5f411c29157f..329702e185a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -75,13 +75,6 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
 	.handle_rx_cqe_mpwqe_shampo = mlx5e_handle_rx_cqe_mpwrq_shampo,
 };
 
-static struct mlx5e_mpw_info *mlx5e_get_mpw_info(struct mlx5e_rq *rq, int i)
-{
-	size_t isz = struct_size(rq->mpwqe.info, alloc_units, rq->mpwqe.pages_per_wqe);
-
-	return (struct mlx5e_mpw_info *)((char *)rq->mpwqe.info + array_size(i, isz));
-}
-
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
 	return config->rx_filter == HWTSTAMP_FILTER_ALL;
@@ -668,15 +661,6 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	int err;
 	int i;
 
-	/* Check in advance that we have enough frames, instead of allocating
-	 * one-by-one, failing and moving frames to the Reuse Ring.
-	 */
-	if (rq->xsk_pool &&
-	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe))) {
-		err = -ENOMEM;
-		goto err;
-	}
-
 	if (test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state)) {
 		err = mlx5e_alloc_rx_hd_mpwqe(rq);
 		if (unlikely(err))
@@ -687,33 +671,16 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe = mlx5_wq_cyc_get_wqe(wq, pi);
 	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, sizeof(struct mlx5e_umr_wqe));
 
-	if (unlikely(rq->mpwqe.unaligned)) {
-		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
-			dma_addr_t addr;
-
-			err = mlx5e_page_alloc(rq, au);
-			if (unlikely(err))
-				goto err_unmap;
-			/* Unaligned means XSK. */
-			addr = xsk_buff_xdp_get_frame_dma(au->xsk);
-			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
-				.key = rq->mkey_be,
-				.va = cpu_to_be64(addr),
-			};
-		}
-	} else {
-		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
-			dma_addr_t addr;
+	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
+		dma_addr_t addr;
 
-			err = mlx5e_page_alloc(rq, au);
-			if (unlikely(err))
-				goto err_unmap;
-			addr = rq->xsk_pool ? xsk_buff_xdp_get_frame_dma(au->xsk) :
-					      page_pool_get_dma_addr(au->page);
-			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
-				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
-			};
-		}
+		err = mlx5e_page_alloc_pool(rq, au);
+		if (unlikely(err))
+			goto err_unmap;
+		addr = page_pool_get_dma_addr(au->page);
+		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
+			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
+		};
 	}
 
 	bitmap_zero(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
@@ -723,9 +690,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
 
-	offset = ix * rq->mpwqe.mtts_per_wqe;
-	if (!rq->mpwqe.unaligned)
-		offset = MLX5_ALIGNED_MTTS_OCTW(offset);
+	offset = MLX5_ALIGNED_MTTS_OCTW(ix * rq->mpwqe.mtts_per_wqe);
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(offset);
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
@@ -1016,7 +981,8 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	head = rq->mpwqe.actual_wq_head;
 	i = missing;
 	do {
-		alloc_err = mlx5e_alloc_rx_mpwqe(rq, head);
+		alloc_err = rq->xsk_pool ? mlx5e_xsk_alloc_rx_mpwqe(rq, head) :
+					   mlx5e_alloc_rx_mpwqe(rq, head);
 
 		if (unlikely(alloc_err))
 			break;
-- 
2.37.3

