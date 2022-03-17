Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38234DCE2D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiCQSzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237493AbiCQSzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0661637DD
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69600617AF
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D6AC340F3;
        Thu, 17 Mar 2022 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543269;
        bh=gsmnkEh76OHSiPlp0KOflJkXB/o+HWlfIwoNQW0rsBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ID3er3aCDdvKpNZCkJa+x4fjGcQnJiLikpy8aKwYjDPZ3AKJ+IV6v0BTiDmhXHnen
         VwkoVgziA0G+QzxvN2WwPF4rEZ6MgJJAsLQ6sGD8oUmBRmDp6NnbVoH2w824KAoTO+
         FenLaz2iW9+NFbuGjIZ9nEIx4IDF0F0fuX65a4F3CFvPlav5m2l3tlfY1hvGvCtzr8
         hv/UQ3IixUJW2yt9oS0KN0AbaCAZoqKnkkg/9+6jV8+zvyz1GPRCtOTnbfiCmZUR6U
         mAjFbQaqtBAbmXsjh3OOPqha3l55/0/qRn/jRVtJ7beDatKKauX7CMkecYIHDghLHH
         8me3KbnD63Xng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Build SKB in place over the first fragment in non-linear legacy RQ
Date:   Thu, 17 Mar 2022 11:54:12 -0700
Message-Id: <20220317185424.287982-4-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
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

As a performance optimization and preparation to enabling XDP multi
buffer on non-linear legacy RQ, build the linear part of the SKB over
the first fragment, instead of allocating a new buffer and copying the
first 256 bytes there.

To achieve this, add headroom and tailroom to the first fragment.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 43 ++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 48 ++++++++++---------
 2 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 0f258e7a65e0..5c4711be6fae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -188,12 +188,18 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk)
 {
-	bool is_linear_skb = (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) ?
-		mlx5e_rx_is_linear_skb(params, xsk) :
-		mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk);
+	u16 linear_headroom = mlx5e_get_linear_rq_headroom(params, xsk);
 
-	return is_linear_skb || params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO ?
-		mlx5e_get_linear_rq_headroom(params, xsk) : 0;
+	if (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC)
+		return linear_headroom;
+
+	if (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
+		return linear_headroom;
+
+	if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO)
+		return linear_headroom;
+
+	return 0;
 }
 
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
@@ -392,10 +398,10 @@ void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e
 	};
 }
 
-static int mlx5e_max_nonlinear_mtu(int frag_size)
+static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size)
 {
 	/* Optimization for small packets: the last fragment is bigger than the others. */
-	return (MLX5E_MAX_RX_FRAGS - 1) * frag_size + PAGE_SIZE;
+	return first_frag_size + (MLX5E_MAX_RX_FRAGS - 2) * frag_size + PAGE_SIZE;
 }
 
 #define DEFAULT_FRAG_SIZE (2048)
@@ -407,7 +413,9 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	int frag_size_max = DEFAULT_FRAG_SIZE;
+	int first_frag_size_max;
 	u32 buf_size = 0;
+	u16 headroom;
 	int max_mtu;
 	int i;
 
@@ -427,11 +435,15 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		goto out;
 	}
 
-	max_mtu = mlx5e_max_nonlinear_mtu(frag_size_max);
+	headroom = mlx5e_get_linear_rq_headroom(params, xsk);
+	first_frag_size_max = SKB_WITH_OVERHEAD(frag_size_max - headroom);
+
+	max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max);
 	if (byte_count > max_mtu) {
 		frag_size_max = PAGE_SIZE;
+		first_frag_size_max = SKB_WITH_OVERHEAD(frag_size_max - headroom);
 
-		max_mtu = mlx5e_max_nonlinear_mtu(frag_size_max);
+		max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max);
 		if (byte_count > max_mtu) {
 			mlx5_core_err(mdev, "MTU %u is too big for non-linear legacy RQ (max %d)\n",
 				      params->sw_mtu, max_mtu);
@@ -443,13 +455,22 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	while (buf_size < byte_count) {
 		int frag_size = byte_count - buf_size;
 
-		if (i < MLX5E_MAX_RX_FRAGS - 1)
+		if (i == 0)
+			frag_size = min(frag_size, first_frag_size_max);
+		else if (i < MLX5E_MAX_RX_FRAGS - 1)
 			frag_size = min(frag_size, frag_size_max);
 
 		info->arr[i].frag_size = frag_size;
+		buf_size += frag_size;
+
+		if (i == 0) {
+			/* Ensure that headroom and tailroom are included. */
+			frag_size += headroom;
+			frag_size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		}
+
 		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
 
-		buf_size += frag_size;
 		i++;
 	}
 	info->num_frags = i;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6eda906342c0..b06aac087b2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1560,43 +1560,45 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
-	struct mlx5e_wqe_frag_info *head_wi = wi;
-	u16 headlen      = min_t(u32, MLX5E_RX_MAX_HEAD, cqe_bcnt);
-	u16 frag_headlen = headlen;
-	u16 byte_cnt     = cqe_bcnt - headlen;
+	u16 rx_headroom = rq->buff.headroom;
+	struct mlx5e_dma_info *di = wi->di;
+	u32 frag_consumed_bytes;
+	u32 first_frag_size;
 	struct sk_buff *skb;
+	void *va;
+
+	va = page_address(di->page) + wi->offset;
+	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
+	first_frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + frag_consumed_bytes);
+
+	dma_sync_single_range_for_cpu(rq->pdev, di->addr, wi->offset,
+				      first_frag_size, DMA_FROM_DEVICE);
+	net_prefetch(va + rx_headroom);
 
 	/* XDP is not supported in this configuration, as incoming packets
 	 * might spread among multiple pages.
 	 */
-	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
-	if (unlikely(!skb)) {
-		rq->stats->buff_alloc_err++;
+	skb = mlx5e_build_linear_skb(rq, va, first_frag_size, rx_headroom,
+				     frag_consumed_bytes, 0);
+	if (unlikely(!skb))
 		return NULL;
-	}
 
-	net_prefetchw(skb->data);
+	page_ref_inc(di->page);
 
-	while (byte_cnt) {
-		u16 frag_consumed_bytes =
-			min_t(u16, frag_info->frag_size - frag_headlen, byte_cnt);
+	cqe_bcnt -= frag_consumed_bytes;
+	frag_info++;
+	wi++;
 
-		mlx5e_add_skb_frag(rq, skb, wi->di, wi->offset + frag_headlen,
+	while (cqe_bcnt) {
+		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
+
+		mlx5e_add_skb_frag(rq, skb, wi->di, wi->offset,
 				   frag_consumed_bytes, frag_info->frag_stride);
-		byte_cnt -= frag_consumed_bytes;
-		frag_headlen = 0;
+		cqe_bcnt -= frag_consumed_bytes;
 		frag_info++;
 		wi++;
 	}
 
-	/* copy header */
-	mlx5e_copy_skb_header(rq->pdev, skb, head_wi->di, head_wi->offset, head_wi->offset,
-			      headlen);
-	/* skb linear part was allocated with headlen and aligned to long */
-	skb->tail += headlen;
-	skb->len  += headlen;
-
 	return skb;
 }
 
-- 
2.35.1

