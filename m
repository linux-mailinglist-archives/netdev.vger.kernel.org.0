Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173545ECEBC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiI0Uhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiI0Ug5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401A76E8AF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB14BB81C17
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F757C433D7;
        Tue, 27 Sep 2022 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311013;
        bh=w3F/VSPbiTeOWGcu5eDG5Z0zpI2c69ks6k/YyV2lpsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GA83rVcUivU44a5e77Z2dZrh+9UBmUjIxzDCXk0YPn37/QQhExJ7YrOgGawUnh3pR
         EhKTPuFps4zrJ/bHv6RHdK8eD/8jbXsBC/S/36vdLPbrR0ZxLm9xJbrIzuAVgFfDcG
         D2CvE/hMfqjEfHel7GoRFbtjueLyXOm3MFngfmDyI8q5XXAWAYoXaNRQjlkHmbzXlc
         4wdt0grM+Xy35BqKfobAPu0u1XN7cFoOcmYALAE67VSaAV9gObgL4oYRKtEH58oBNk
         jl7ZpSAg9FRpqAxtwZLtvXTfv7k8DQJOnYtoU8p8S52P2qeo1AYLd7Fji7j95eq9MA
         +LlSCK6r51MdQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 15/16] net/mlx5e: Make dma_info array dynamic in struct mlx5e_mpw_info
Date:   Tue, 27 Sep 2022 13:36:10 -0700
Message-Id: <20220927203611.244301-16-saeed@kernel.org>
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

This commit moves the dma_info array to the end of struct mlx5e_mpw_info
to make it a flexible array. It also removes the intermediate struct
mlx5e_umr_dma_info, which used to contain only this array. The
flexibility of dma_info will allow to choose its size dynamically in a
following commit.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 +----
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 27 ++++++++++++-------
 4 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4778298f4645..0c716db88cf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -619,14 +619,10 @@ struct mlx5e_wqe_frag_info {
 	bool last_in_page;
 };
 
-struct mlx5e_umr_dma_info {
-	struct mlx5e_dma_info  dma_info[MLX5_MPWRQ_PAGES_PER_WQE];
-};
-
 struct mlx5e_mpw_info {
-	struct mlx5e_umr_dma_info umr;
 	u16 consumed_strides;
 	DECLARE_BITMAP(xdp_xmit_bitmap, MLX5_MPWRQ_PAGES_PER_WQE);
+	struct mlx5e_dma_info dma_info[];
 };
 
 #define MLX5E_MAX_RX_FRAGS 4
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 9a1553598a7c..6245dfde6666 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -30,7 +30,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    u32 head_offset,
 						    u32 page_idx)
 {
-	struct xdp_buff *xdp = wi->umr.dma_info[page_idx].xsk;
+	struct xdp_buff *xdp = wi->dma_info[page_idx].xsk;
 	struct bpf_prog *prog;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a38f0c6f06d9..978805931347 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -260,10 +260,12 @@ static void mlx5e_rq_shampo_hd_info_free(struct mlx5e_rq *rq)
 static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 {
 	int wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
+	size_t alloc_size;
 
-	rq->mpwqe.info = kvzalloc_node(array_size(wq_sz,
-						  sizeof(*rq->mpwqe.info)),
-				       GFP_KERNEL, node);
+	alloc_size = array_size(wq_sz, struct_size(rq->mpwqe.info, dma_info,
+						   MLX5_MPWRQ_PAGES_PER_WQE));
+
+	rq->mpwqe.info = kvzalloc_node(alloc_size, GFP_KERNEL, node);
 	if (!rq->mpwqe.info)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4d3e7897b51b..b910fc1dbc72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -75,6 +75,13 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
 	.handle_rx_cqe_mpwqe_shampo = mlx5e_handle_rx_cqe_mpwrq_shampo,
 };
 
+static struct mlx5e_mpw_info *mlx5e_get_mpw_info(struct mlx5e_rq *rq, int i)
+{
+	size_t isz = struct_size(rq->mpwqe.info, dma_info, MLX5_MPWRQ_PAGES_PER_WQE);
+
+	return (struct mlx5e_mpw_info *)((char *)rq->mpwqe.info + array_size(i, isz));
+}
+
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
 	return config->rx_filter == HWTSTAMP_FILTER_ALL;
@@ -478,7 +485,7 @@ static void
 mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle)
 {
 	bool no_xdp_xmit;
-	struct mlx5e_dma_info *dma_info = wi->umr.dma_info;
+	struct mlx5e_dma_info *dma_info = wi->dma_info;
 	int i;
 
 	/* A common case for AF_XDP. */
@@ -660,8 +667,8 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 
 static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
-	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[ix];
-	struct mlx5e_dma_info *dma_info = &wi->umr.dma_info[0];
+	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
+	struct mlx5e_dma_info *dma_info = &wi->dma_info[0];
 	struct mlx5e_icosq *sq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
@@ -768,7 +775,7 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 
 static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
-	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[ix];
+	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
 	/* Don't recycle, this function is called on rq/netdev close */
 	mlx5e_free_rx_mpwqe(rq, wi, false);
 }
@@ -1795,7 +1802,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 {
 	u16 cstrides       = mpwrq_get_cqe_consumed_strides(cqe);
 	u16 wqe_id         = be16_to_cpu(cqe->wqe_id);
-	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[wqe_id];
+	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, wqe_id);
 	u16 stride_ix      = mpwrq_get_cqe_stride_index(cqe);
 	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
 	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
@@ -1878,7 +1885,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
-	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	struct mlx5e_dma_info *di = &wi->dma_info[page_idx];
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
 	struct mlx5e_dma_info *head_di = di;
@@ -1912,7 +1919,7 @@ static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
-	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	struct mlx5e_dma_info *di = &wi->dma_info[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
@@ -2078,7 +2085,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	struct mlx5e_mpw_info *wi;
 	struct mlx5_wq_ll *wq;
 
-	wi = &rq->mpwqe.info[wqe_id];
+	wi = mlx5e_get_mpw_info(rq, wqe_id);
 	wi->consumed_strides += cstrides;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
@@ -2124,7 +2131,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (likely(head_size)) {
-		di = &wi->umr.dma_info[page_idx];
+		di = &wi->dma_info[page_idx];
 		mlx5e_fill_skb_data(*skb, rq, di, data_bcnt, data_offset);
 	}
 
@@ -2147,7 +2154,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 {
 	u16 cstrides       = mpwrq_get_cqe_consumed_strides(cqe);
 	u16 wqe_id         = be16_to_cpu(cqe->wqe_id);
-	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[wqe_id];
+	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, wqe_id);
 	u16 stride_ix      = mpwrq_get_cqe_stride_index(cqe);
 	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
 	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
-- 
2.37.3

