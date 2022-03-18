Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57F4DE2E8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbiCRUyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240871AbiCRUyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB312DF36
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F29B8257C
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FC8C340F5;
        Fri, 18 Mar 2022 20:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636794;
        bh=X5LXqSq0JP0ENBYfmRtS9PeHsibFM6508qxn/o8ZXJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1UftFgWTTOU58q0nH7yNP3QyFe7CQk2GLR+Zuv8l1b3Q99pk3N8+uQor12BWnf8O
         3Y3UHm4GANOp2A7T2QK/RUo1VSRiJRmDpnfhSXra9pU8YM0nf0qseVzlBrDuq9h0LD
         LQvjKvxNi6F5/vXtW2jW9uWwxBFTPkLx1HM3Og+LzrSSmQd0pKhXWh4Dtyprq4p7B0
         fXerXe7ETX68tKUVMga4xh8AIf9BeyUNNHnGUpK4V9MudP3q7cyvrPFIYPgxgDG9So
         rBwWgIjcysimmqO37MqOLPgKarx0UaqYyol32pBzFdQ4sgNdz6iGhEYqNgfxtRU5V9
         +GRDmqnUBOM7Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Implement sending multi buffer XDP frames
Date:   Fri, 18 Mar 2022 13:52:42 -0700
Message-Id: <20220318205248.33367-10-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

xmit_xdp_frame is extended to support sending fragmented XDP frames. The
next commit will start using this functionality.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 96 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  2 +
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  3 +-
 4 files changed, 80 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index cf935a7bf387..8653ac0fd865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -538,6 +538,7 @@ struct mlx5e_xdpsq;
 typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xmit_data *,
+					struct skb_shared_info *,
 					int);
 
 struct mlx5e_xdpsq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index b220e613d102..52e0f0028c35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -120,7 +120,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	}
 
 	if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0)))
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0)))
 		return false;
 
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
@@ -263,13 +263,27 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq
 	return MLX5E_XDP_CHECK_OK;
 }
 
+INDIRECT_CALLABLE_SCOPE bool
+mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
+		     struct skb_shared_info *sinfo, int check_result);
+
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-			   int check_result)
+			   struct skb_shared_info *sinfo, int check_result)
 {
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
+	if (unlikely(sinfo)) {
+		/* MPWQE is enabled, but a multi-buffer packet is queued for
+		 * transmission. MPWQE can't send fragmented packets, so close
+		 * the current session and fall back to a regular WQE.
+		 */
+		if (unlikely(sq->mpwqe.wqe))
+			mlx5e_xdp_mpwqe_complete(sq);
+		return mlx5e_xmit_xdp_frame(sq, xdptxd, sinfo, 0);
+	}
+
 	if (unlikely(xdptxd->len > sq->hw_mtu)) {
 		stats->err++;
 		return false;
@@ -297,9 +311,9 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 	return true;
 }
 
-INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
+static int mlx5e_xmit_xdp_frame_check_stop_room(struct mlx5e_xdpsq *sq, int stop_room)
 {
-	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, stop_room))) {
 		/* SQ is full, ring doorbell */
 		mlx5e_xmit_xdp_doorbell(sq);
 		sq->stats->full++;
@@ -309,37 +323,66 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 	return MLX5E_XDP_CHECK_OK;
 }
 
+INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
+{
+	return mlx5e_xmit_xdp_frame_check_stop_room(sq, 1);
+}
+
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     int check_result)
+		     struct skb_shared_info *sinfo, int check_result)
 {
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
-	u16                       pi   = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(wq, pi);
-
-	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
-	struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
-	struct mlx5_wqe_data_seg *dseg = wqe->data;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5_wqe_data_seg *dseg;
+	struct mlx5_wqe_eth_seg *eseg;
+	struct mlx5e_tx_wqe *wqe;
 
 	dma_addr_t dma_addr = xdptxd->dma_addr;
 	u32 dma_len = xdptxd->len;
 	u16 ds_cnt, inline_hdr_sz;
+	u8 num_wqebbs = 1;
+	int num_frags = 0;
+	u16 pi;
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	net_prefetchw(wqe);
-
 	if (unlikely(dma_len < MLX5E_XDP_MIN_INLINE || sq->hw_mtu < dma_len)) {
 		stats->err++;
 		return false;
 	}
 
-	if (!check_result)
-		check_result = mlx5e_xmit_xdp_frame_check(sq);
+	ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + 1;
+	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE)
+		ds_cnt++;
+
+	/* check_result must be 0 if sinfo is passed. */
+	if (!check_result) {
+		int stop_room = 1;
+
+		if (unlikely(sinfo)) {
+			ds_cnt += sinfo->nr_frags;
+			num_frags = sinfo->nr_frags;
+			num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
+			/* Assuming MLX5_CAP_GEN(mdev, max_wqe_sz_sq) is big
+			 * enough to hold all fragments.
+			 */
+			stop_room = MLX5E_STOP_ROOM(num_wqebbs);
+		}
+
+		check_result = mlx5e_xmit_xdp_frame_check_stop_room(sq, stop_room);
+	}
 	if (unlikely(check_result < 0))
 		return false;
 
-	ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + 1;
+	pi = mlx5e_xdpsq_get_next_pi(sq, num_wqebbs);
+	wqe = mlx5_wq_cyc_get_wqe(wq, pi);
+	net_prefetchw(wqe);
+
+	cseg = &wqe->ctrl;
+	eseg = &wqe->eth;
+	dseg = wqe->data;
+
 	inline_hdr_sz = 0;
 
 	/* copy the inline part if required */
@@ -351,7 +394,6 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		dma_addr += MLX5E_XDP_MIN_INLINE;
 		inline_hdr_sz = MLX5E_XDP_MIN_INLINE;
 		dseg++;
-		ds_cnt++;
 	}
 
 	/* write the dma part */
@@ -361,8 +403,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_SEND);
 
 	if (unlikely(test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state))) {
-		u8 num_pkts = 1;
-		u8 num_wqebbs;
+		u8 num_pkts = 1 + num_frags;
+		int i;
 
 		memset(&cseg->signature, 0, sizeof(*cseg) -
 		       sizeof(cseg->opmod_idx_opcode) - sizeof(cseg->qpn_ds));
@@ -371,9 +413,21 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
 		dseg->lkey = sq->mkey_be;
 
+		for (i = 0; i < num_frags; i++) {
+			skb_frag_t *frag = &sinfo->frags[i];
+			dma_addr_t addr;
+
+			addr = page_pool_get_dma_addr(skb_frag_page(frag)) +
+				skb_frag_off(frag);
+
+			dseg++;
+			dseg->addr = cpu_to_be64(addr);
+			dseg->byte_count = cpu_to_be32(skb_frag_size(frag));
+			dseg->lkey = sq->mkey_be;
+		}
+
 		cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
 
-		num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
 		sq->db.wqe_info[pi] = (struct mlx5e_xdp_wqe_info) {
 			.num_wqebbs = num_wqebbs,
 			.num_pkts = num_pkts,
@@ -566,7 +620,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0);
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0);
 		if (unlikely(!ret)) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index ce31828b6c19..4868fa1b82d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -59,9 +59,11 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
+							  struct skb_shared_info *sinfo,
 							  int check_result));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 						    struct mlx5e_xmit_data *xdptxd,
+						    struct skb_shared_info *sinfo,
 						    int check_result));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 5a889835039c..3ec0c17db010 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -103,7 +103,8 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, check_result);
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL,
+				      check_result);
 		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
 				mlx5e_xdp_mpwqe_complete(sq);
-- 
2.35.1

