Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAAB6232AF
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiKISlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiKISlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8522228E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6524861C7B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B354FC433D6;
        Wed,  9 Nov 2022 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019262;
        bh=VOjncjq39lUr9Yr6F6UVe6jgB2rgGXwJGD2Jzubmdjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uow5DtoD8GnvvKidTP96xdsUrb7VtlMWP4hQbUNbK5PYLqoIHmEQV18bmL++KWI7Z
         DMRlf52gi/WX9TG7qzQjR/PxhYbLyGbqz84LjYJgFVW2I4YImmGMQQfM08ilyeDUa4
         9DL7UIWBAzuZ6GFeHP4pI1JeEnY6uP58Yc8sp0jZ7t4dbYRFVo1+RLVYHBw3nBpump
         +jfzi7ih3x7VjL3Byp+j0b10lw8YU1ipPDAwupTANPWwVraImCkOmVlcPQzAjuMd1F
         lpP99GxYtsPS1A9SF4iPyyJHyFGnfWKVaEB/LEy4XRvsbRRQNuQ9tihGjr8NjAZoyi
         7BqZvTgwwOm8g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [V3 net 06/10] net/mlx5e: Fix usage of DMA sync API
Date:   Wed,  9 Nov 2022 10:40:46 -0800
Message-Id: <20221109184050.108379-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109184050.108379-1-saeed@kernel.org>
References: <20221109184050.108379-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

DMA sync functions should use the same direction that was used by DMA
mapping. Use DMA_BIDIRECTIONAL for XDP_TX from regular RQ, which reuses
the same mapping that was used for RX, and DMA_TO_DEVICE for XDP_TX from
XSK RQ and XDP_REDIRECT, which establish a new mapping in this
direction. On the RX side, use the same direction that was used when
setting up the mapping (DMA_BIDIRECTIONAL for XDP, DMA_FROM_DEVICE
otherwise).

Also don't skip sync for device when establishing a DMA_FROM_DEVICE
mapping for RX, as some architectures (ARM) may require invalidating
caches before the device can use the mapping. It doesn't break the
bugfix made in
commit 0b7cfa4082fb ("net/mlx5e: Fix page DMA map/unmap attributes"),
since the bug happened on unmap.

Fixes: 0b7cfa4082fb ("net/mlx5e: Fix page DMA map/unmap attributes")
Fixes: b5503b994ed5 ("net/mlx5e: XDP TX forwarding support")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 27 ++++++++++---------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 4685c652c97e..20507ef2f956 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -117,7 +117,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	xdpi.page.rq = rq;
 
 	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
-	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_TO_DEVICE);
+	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_BIDIRECTIONAL);
 
 	if (unlikely(xdp_frame_has_frags(xdpf))) {
 		sinfo = xdp_get_shared_info_from_frame(xdpf);
@@ -131,7 +131,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 				skb_frag_off(frag);
 			len = skb_frag_size(frag);
 			dma_sync_single_for_device(sq->pdev, addr, len,
-						   DMA_TO_DEVICE);
+						   DMA_BIDIRECTIONAL);
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 58084650151f..a61a43fc8d5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -266,7 +266,7 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, union mlx5e_alloc_uni
 
 	addr = page_pool_get_dma_addr(au->page);
 	/* Non-XSK always uses PAGE_SIZE. */
-	dma_sync_single_for_device(rq->pdev, addr, PAGE_SIZE, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(rq->pdev, addr, PAGE_SIZE, rq->buff.map_dir);
 	return true;
 }
 
@@ -282,8 +282,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_u
 		return -ENOMEM;
 
 	/* Non-XSK always uses PAGE_SIZE. */
-	addr = dma_map_page_attrs(rq->pdev, au->page, 0, PAGE_SIZE,
-				  rq->buff.map_dir, DMA_ATTR_SKIP_CPU_SYNC);
+	addr = dma_map_page(rq->pdev, au->page, 0, PAGE_SIZE, rq->buff.map_dir);
 	if (unlikely(dma_mapping_error(rq->pdev, addr))) {
 		page_pool_recycle_direct(rq->page_pool, au->page);
 		au->page = NULL;
@@ -427,14 +426,15 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 {
 	dma_addr_t addr = page_pool_get_dma_addr(au->page);
 
-	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len,
+				rq->buff.map_dir);
 	page_ref_inc(au->page);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 			au->page, frag_offset, len, truesize);
 }
 
 static inline void
-mlx5e_copy_skb_header(struct device *pdev, struct sk_buff *skb,
+mlx5e_copy_skb_header(struct mlx5e_rq *rq, struct sk_buff *skb,
 		      struct page *page, dma_addr_t addr,
 		      int offset_from, int dma_offset, u32 headlen)
 {
@@ -442,7 +442,8 @@ mlx5e_copy_skb_header(struct device *pdev, struct sk_buff *skb,
 	/* Aligning len to sizeof(long) optimizes memcpy performance */
 	unsigned int len = ALIGN(headlen, sizeof(long));
 
-	dma_sync_single_for_cpu(pdev, addr + dma_offset, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(rq->pdev, addr + dma_offset, len,
+				rq->buff.map_dir);
 	skb_copy_to_linear_data(skb, from, len);
 }
 
@@ -1538,7 +1539,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 
 	addr = page_pool_get_dma_addr(au->page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
-				      frag_size, DMA_FROM_DEVICE);
+				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
 
 	prog = rcu_dereference(rq->xdp_prog);
@@ -1587,7 +1588,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 	addr = page_pool_get_dma_addr(au->page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
-				      rq->buff.frame0_sz, DMA_FROM_DEVICE);
+				      rq->buff.frame0_sz, rq->buff.map_dir);
 	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
 
@@ -1608,7 +1609,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 		addr = page_pool_get_dma_addr(au->page);
 		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
-					frag_consumed_bytes, DMA_FROM_DEVICE);
+					frag_consumed_bytes, rq->buff.map_dir);
 
 		if (!xdp_buff_has_frags(&xdp)) {
 			/* Init on the first fragment to avoid cold cache access
@@ -1905,7 +1906,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	mlx5e_fill_skb_data(skb, rq, au, byte_cnt, frag_offset);
 	/* copy header */
 	addr = page_pool_get_dma_addr(head_au->page);
-	mlx5e_copy_skb_header(rq->pdev, skb, head_au->page, addr,
+	mlx5e_copy_skb_header(rq, skb, head_au->page, addr,
 			      head_offset, head_offset, headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
@@ -1939,7 +1940,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	addr = page_pool_get_dma_addr(au->page);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, head_offset,
-				      frag_size, DMA_FROM_DEVICE);
+				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
 
 	prog = rcu_dereference(rq->xdp_prog);
@@ -1987,7 +1988,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	if (likely(frag_size <= BIT(MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE))) {
 		/* build SKB around header */
-		dma_sync_single_range_for_cpu(rq->pdev, head->addr, 0, frag_size, DMA_FROM_DEVICE);
+		dma_sync_single_range_for_cpu(rq->pdev, head->addr, 0, frag_size, rq->buff.map_dir);
 		prefetchw(hdr);
 		prefetch(data);
 		skb = mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_size, 0);
@@ -2009,7 +2010,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		}
 
 		prefetchw(skb->data);
-		mlx5e_copy_skb_header(rq->pdev, skb, head->page, head->addr,
+		mlx5e_copy_skb_header(rq, skb, head->page, head->addr,
 				      head_offset + rx_headroom,
 				      rx_headroom, head_size);
 		/* skb linear part was allocated with headlen and aligned to long */
-- 
2.38.1

