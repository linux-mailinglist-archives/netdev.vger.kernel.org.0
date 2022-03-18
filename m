Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BAB4DE2F4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbiCRUyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240529AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AD1DEDB
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1B54B8257D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1463DC340F0;
        Fri, 18 Mar 2022 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636790;
        bh=XSVDhxudbvNR5uNkCUmxGJ0COkZPxwbCpqD2EntUT+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdLPpqyUzXgdZm3gsiHWWaGM8murLYbKuMUuOxU40q/FWT/oa09OKONgLbxOHgVj2
         n2Z+vAH6YkrifM7ZNV/nJSb1fgdARqZLp78SAqiT9OFYESZYdT0sq39nGQT5N/km9k
         GBkKWjp7XADUXNnE9cQt/P6dDgIXd3mTFu3RfsvDZP47Bm6kc0WHiq/n4/Itm4Qf40
         F9ShoXibFNhEofZTy54N01JyrwJU81mvLRWNmbDFpt4nARkTIv/CWDBS8GxyDQuSn3
         NkM1kWcIvTRctM3tHz9k6TwqApuhJ9o3gnCYBJyLPEVJjVUoTEIKawJ8dfeUARCDhU
         wkM1LTIBNlXLg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Prepare non-linear legacy RQ for XDP multi buffer support
Date:   Fri, 18 Mar 2022 13:52:34 -0700
Message-Id: <20220318205248.33367-2-saeed@kernel.org>
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

mlx5e_skb_from_cqe_nonlinear creates an xdp_buff first, putting the
first fragment as the linear part, and the rest of fragments as
fragments to struct skb_shared_info in the tailroom. Then it creates an
SKB in place, based on the xdp_buff. The XDP program is not called in
this commit yet.

This commit contains no functional change, except the SKB is built over
the whole frag_stride of the first fragment, instead of the minimal size
required (headroom, data and skb_shared_info).

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 75 +++++++++++++++----
 1 file changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4b8699f39200..dd8ff62e1693 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1567,45 +1567,92 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+	struct mlx5e_wqe_frag_info *head_wi = wi;
 	u16 rx_headroom = rq->buff.headroom;
 	struct mlx5e_dma_info *di = wi->di;
+	struct skb_shared_info *sinfo;
 	u32 frag_consumed_bytes;
-	u32 first_frag_size;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
+	u32 truesize;
 	void *va;
 
 	va = page_address(di->page) + wi->offset;
 	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
-	first_frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + frag_consumed_bytes);
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, wi->offset,
-				      first_frag_size, DMA_FROM_DEVICE);
+				      rq->buff.frame0_sz, DMA_FROM_DEVICE);
 	net_prefetch(va + rx_headroom);
 
-	/* XDP is not supported in this configuration, as incoming packets
-	 * might spread among multiple pages.
-	 */
-	skb = mlx5e_build_linear_skb(rq, va, first_frag_size, rx_headroom,
-				     frag_consumed_bytes, 0);
-	if (unlikely(!skb))
-		return NULL;
-
-	page_ref_inc(di->page);
+	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &xdp);
+	sinfo = xdp_get_shared_info_from_buff(&xdp);
+	truesize = 0;
 
 	cqe_bcnt -= frag_consumed_bytes;
 	frag_info++;
 	wi++;
 
 	while (cqe_bcnt) {
+		skb_frag_t *frag;
+
+		di = wi->di;
+
 		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-		mlx5e_add_skb_frag(rq, skb, wi->di, wi->offset,
-				   frag_consumed_bytes, frag_info->frag_stride);
+		dma_sync_single_for_cpu(rq->pdev, di->addr + wi->offset,
+					frag_consumed_bytes, DMA_FROM_DEVICE);
+
+		if (!xdp_buff_has_frags(&xdp)) {
+			/* Init on the first fragment to avoid cold cache access
+			 * when possible.
+			 */
+			sinfo->nr_frags = 0;
+			sinfo->xdp_frags_size = 0;
+			xdp_buff_set_frags_flag(&xdp);
+		}
+
+		frag = &sinfo->frags[sinfo->nr_frags++];
+		__skb_frag_set_page(frag, di->page);
+		skb_frag_off_set(frag, wi->offset);
+		skb_frag_size_set(frag, frag_consumed_bytes);
+
+		if (page_is_pfmemalloc(di->page))
+			xdp_buff_set_frag_pfmemalloc(&xdp);
+
+		sinfo->xdp_frags_size += frag_consumed_bytes;
+		truesize += frag_info->frag_stride;
+
 		cqe_bcnt -= frag_consumed_bytes;
 		frag_info++;
 		wi++;
 	}
 
+	di = head_wi->di;
+
+	skb = mlx5e_build_linear_skb(rq, xdp.data_hard_start, rq->buff.frame0_sz,
+				     xdp.data - xdp.data_hard_start,
+				     xdp.data_end - xdp.data,
+				     xdp.data - xdp.data_meta);
+	if (unlikely(!skb))
+		return NULL;
+
+	page_ref_inc(di->page);
+
+	if (unlikely(xdp_buff_has_frags(&xdp))) {
+		int i;
+
+		/* sinfo->nr_frags is reset by build_skb, calculate again. */
+		xdp_update_skb_shared_info(skb, wi - head_wi - 1,
+					   sinfo->xdp_frags_size, truesize,
+					   xdp_buff_is_frag_pfmemalloc(&xdp));
+
+		for (i = 0; i < sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &sinfo->frags[i];
+
+			page_ref_inc(skb_frag_page(frag));
+		}
+	}
+
 	return skb;
 }
 
-- 
2.35.1

