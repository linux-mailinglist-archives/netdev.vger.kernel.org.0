Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789796448DF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiLFQLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbiLFQLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:11:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EFB303C2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YoCKSCTx4k22RkKAc07hjRz7rBFtTZNQG7kvSXZRaNI=; b=wKuhGxz/3Ny0sAVktiKgSJWyeN
        X9pKboXpTiufF9WNRMIiF7g6a40OyEeLBqIRA0vOV7ZiQOpRevYI0BYC87hi2D0BBwPgIJ/coKZFN
        1dT1eZ4+FdbywdomzsMEk7OQ1m9UJqMcmxLlhi/vACnoaVIFmakk2D2FaKEmv6p31En6swGXPfP3G
        ZMA7yr+sV30zMYlVFdI6ZGtkNekqvTfxYafSk8Ccv5H79kocTgI2ilxSowyAgbTHjywPFz92f9zA3
        yyXDYKN1vsMoVDaf3Z+TU0T/hQGgw5LIumookO2NELOQdftD7C0MpFaTknhJEAxYYsUPnZ/hchX+H
        QlThIXEQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2aRv-004aAo-9A; Tue, 06 Dec 2022 16:05:39 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 26/26] mlx5: Convert to netmem
Date:   Tue,  6 Dec 2022 16:05:37 +0000
Message-Id: <20221206160537.1092343-2-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the netmem APIs instead of the page_pool APIs.  Possibly we should
add a netmem equivalent of skb_add_rx_frag(), but that can happen
later.  Saves one call to compound_head() in the call to put_page()
in mlx5e_page_release_dynamic() which saves 58 bytes of text.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  23 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 130 +++++++++---------
 6 files changed, 93 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ff5b302531d5..f334f87273c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -467,7 +467,7 @@ struct mlx5e_txqsq {
 } ____cacheline_aligned_in_smp;
 
 union mlx5e_alloc_unit {
-	struct page *page;
+	struct netmem *nmem;
 	struct xdp_buff *xsk;
 };
 
@@ -501,7 +501,7 @@ struct mlx5e_xdp_info {
 		} frame;
 		struct {
 			struct mlx5e_rq *rq;
-			struct page *page;
+			struct netmem *nmem;
 		} page;
 	};
 };
@@ -619,7 +619,7 @@ struct mlx5e_mpw_info {
 struct mlx5e_page_cache {
 	u32 head;
 	u32 tail;
-	struct page *page_cache[MLX5E_CACHE_SIZE];
+	struct netmem *page_cache[MLX5E_CACHE_SIZE];
 };
 
 struct mlx5e_rq;
@@ -657,13 +657,13 @@ struct mlx5e_rq_frags_info {
 
 struct mlx5e_dma_info {
 	dma_addr_t addr;
-	struct page *page;
+	struct netmem *nmem;
 };
 
 struct mlx5e_shampo_hd {
 	u32 mkey;
 	struct mlx5e_dma_info *info;
-	struct page *last_page;
+	struct netmem *last_nmem;
 	u16 hd_per_wq;
 	u16 hd_per_wqe;
 	unsigned long *bitmap;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd757..aa231d96c52c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -65,8 +65,8 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget);
 int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 
 /* RX */
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page);
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle);
+void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct netmem *nmem);
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct netmem *nmem, bool recycle);
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq));
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 20507ef2f956..8e9136381592 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -57,7 +57,7 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 
 static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
-		    struct page *page, struct xdp_buff *xdp)
+		    struct netmem *nmem, struct xdp_buff *xdp)
 {
 	struct skb_shared_info *sinfo = NULL;
 	struct mlx5e_xmit_data xdptxd;
@@ -116,7 +116,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
 	xdpi.page.rq = rq;
 
-	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
+	dma_addr = netmem_get_dma_addr(nmem) + (xdpf->data - (void *)xdpf);
 	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_BIDIRECTIONAL);
 
 	if (unlikely(xdp_frame_has_frags(xdpf))) {
@@ -127,7 +127,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 			dma_addr_t addr;
 			u32 len;
 
-			addr = page_pool_get_dma_addr(skb_frag_page(frag)) +
+			addr = netmem_get_dma_addr(skb_frag_netmem(frag)) +
 				skb_frag_off(frag);
 			len = skb_frag_size(frag);
 			dma_sync_single_for_device(sq->pdev, addr, len,
@@ -141,14 +141,14 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 				      mlx5e_xmit_xdp_frame, sq, &xdptxd, sinfo, 0)))
 		return false;
 
-	xdpi.page.page = page;
+	xdpi.page.nmem = nmem;
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 
 	if (unlikely(xdp_frame_has_frags(xdpf))) {
 		for (i = 0; i < sinfo->nr_frags; i++) {
 			skb_frag_t *frag = &sinfo->frags[i];
 
-			xdpi.page.page = skb_frag_page(frag);
+			xdpi.page.nmem = skb_frag_netmem(frag);
 			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 		}
 	}
@@ -157,7 +157,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 }
 
 /* returns true if packet was consumed by xdp */
-bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
+bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct netmem *nmem,
 		      struct bpf_prog *prog, struct xdp_buff *xdp)
 {
 	u32 act;
@@ -168,19 +168,19 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, page, xdp)))
+		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, nmem, xdp)))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
 		return true;
 	case XDP_REDIRECT:
-		/* When XDP enabled then page-refcnt==1 here */
+		/* When XDP enabled then nmem->refcnt==1 here */
 		err = xdp_do_redirect(rq->netdev, xdp, prog);
 		if (unlikely(err))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
 		if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
-			mlx5e_page_dma_unmap(rq, page);
+			mlx5e_page_dma_unmap(rq, nmem);
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
@@ -445,7 +445,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 			skb_frag_t *frag = &sinfo->frags[i];
 			dma_addr_t addr;
 
-			addr = page_pool_get_dma_addr(skb_frag_page(frag)) +
+			addr = netmem_get_dma_addr(skb_frag_netmem(frag)) +
 				skb_frag_off(frag);
 
 			dseg++;
@@ -495,7 +495,8 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
-			mlx5e_page_release_dynamic(xdpi.page.rq, xdpi.page.page, recycle);
+			mlx5e_page_release_dynamic(xdpi.page.rq,
+						xdpi.page.nmem, recycle);
 			break;
 		case MLX5E_XDP_XMIT_MODE_XSK:
 			/* AF_XDP send */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index bc2d9034af5b..5bc875f131a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -46,7 +46,7 @@
 
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
-bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
+bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct netmem *nmem,
 		      struct bpf_prog *prog, struct xdp_buff *xdp);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 217c8a478977..e6b7a6b263ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -555,16 +555,18 @@ static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
 
 static int mlx5e_alloc_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 {
-	rq->wqe_overflow.page = alloc_page(GFP_KERNEL);
-	if (!rq->wqe_overflow.page)
+	struct page *page = alloc_page(GFP_KERNEL);
+	if (!page)
 		return -ENOMEM;
 
-	rq->wqe_overflow.addr = dma_map_page(rq->pdev, rq->wqe_overflow.page, 0,
+	rq->wqe_overflow.addr = dma_map_page(rq->pdev, page, 0,
 					     PAGE_SIZE, rq->buff.map_dir);
 	if (dma_mapping_error(rq->pdev, rq->wqe_overflow.addr)) {
-		__free_page(rq->wqe_overflow.page);
+		__free_page(page);
 		return -ENOMEM;
 	}
+
+	rq->wqe_overflow.nmem = page_netmem(page);
 	return 0;
 }
 
@@ -572,7 +574,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 {
 	 dma_unmap_page(rq->pdev, rq->wqe_overflow.addr, PAGE_SIZE,
 			rq->buff.map_dir);
-	 __free_page(rq->wqe_overflow.page);
+	 __free_page(netmem_page(rq->wqe_overflow.nmem));
 }
 
 static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b1ea0b995d9c..77dee6138dc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -274,7 +274,7 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem);
 }
 
-static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
+static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct netmem *nmem)
 {
 	struct mlx5e_page_cache *cache = &rq->page_cache;
 	u32 tail_next = (cache->tail + 1) & (MLX5E_CACHE_SIZE - 1);
@@ -285,12 +285,12 @@ static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
 		return false;
 	}
 
-	if (!dev_page_is_reusable(page)) {
+	if (!dev_page_is_reusable(netmem_page(nmem))) {
 		stats->cache_waive++;
 		return false;
 	}
 
-	cache->page_cache[cache->tail] = page;
+	cache->page_cache[cache->tail] = nmem;
 	cache->tail = tail_next;
 	return true;
 }
@@ -306,16 +306,16 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, union mlx5e_alloc_uni
 		return false;
 	}
 
-	if (page_ref_count(cache->page_cache[cache->head]) != 1) {
+	if (netmem_ref_count(cache->page_cache[cache->head]) != 1) {
 		stats->cache_busy++;
 		return false;
 	}
 
-	au->page = cache->page_cache[cache->head];
+	au->nmem = cache->page_cache[cache->head];
 	cache->head = (cache->head + 1) & (MLX5E_CACHE_SIZE - 1);
 	stats->cache_reuse++;
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = netmem_get_dma_addr(au->nmem);
 	/* Non-XSK always uses PAGE_SIZE. */
 	dma_sync_single_for_device(rq->pdev, addr, PAGE_SIZE, rq->buff.map_dir);
 	return true;
@@ -328,43 +328,45 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_u
 	if (mlx5e_rx_cache_get(rq, au))
 		return 0;
 
-	au->page = page_pool_dev_alloc_pages(rq->page_pool);
-	if (unlikely(!au->page))
+	au->nmem = page_pool_dev_alloc_netmem(rq->page_pool);
+	if (unlikely(!au->nmem))
 		return -ENOMEM;
 
 	/* Non-XSK always uses PAGE_SIZE. */
-	addr = dma_map_page(rq->pdev, au->page, 0, PAGE_SIZE, rq->buff.map_dir);
+	addr = dma_map_page(rq->pdev, netmem_page(au->nmem), 0, PAGE_SIZE,
+				rq->buff.map_dir);
 	if (unlikely(dma_mapping_error(rq->pdev, addr))) {
-		page_pool_recycle_direct(rq->page_pool, au->page);
-		au->page = NULL;
+		page_pool_recycle_netmem(rq->page_pool, au->nmem);
+		au->nmem = NULL;
 		return -ENOMEM;
 	}
-	page_pool_set_dma_addr(au->page, addr);
+	netmem_set_dma_addr(au->nmem, addr);
 
 	return 0;
 }
 
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page)
+void mlx5e_nmem_dma_unmap(struct mlx5e_rq *rq, struct netmem *nmem)
 {
-	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
+	dma_addr_t dma_addr = netmem_get_dma_addr(nmem);
 
 	dma_unmap_page_attrs(rq->pdev, dma_addr, PAGE_SIZE, rq->buff.map_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
-	page_pool_set_dma_addr(page, 0);
+	netmem_set_dma_addr(nmem, 0);
 }
 
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle)
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct netmem *nmem,
+		bool recycle)
 {
 	if (likely(recycle)) {
-		if (mlx5e_rx_cache_put(rq, page))
+		if (mlx5e_rx_cache_put(rq, nmem))
 			return;
 
-		mlx5e_page_dma_unmap(rq, page);
-		page_pool_recycle_direct(rq->page_pool, page);
+		mlx5e_nmem_dma_unmap(rq, nmem);
+		page_pool_recycle_netmem(rq->page_pool, nmem);
 	} else {
-		mlx5e_page_dma_unmap(rq, page);
-		page_pool_release_page(rq->page_pool, page);
-		put_page(page);
+		mlx5e_nmem_dma_unmap(rq, nmem);
+		page_pool_release_netmem(rq->page_pool, nmem);
+		netmem_put(nmem);
 	}
 }
 
@@ -389,7 +391,7 @@ static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
 				     bool recycle)
 {
 	if (frag->last_in_page)
-		mlx5e_page_release_dynamic(rq, frag->au->page, recycle);
+		mlx5e_page_release_dynamic(rq, frag->au->nmem, recycle);
 }
 
 static inline struct mlx5e_wqe_frag_info *get_frag(struct mlx5e_rq *rq, u16 ix)
@@ -413,7 +415,7 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 			goto free_frags;
 
 		headroom = i == 0 ? rq->buff.headroom : 0;
-		addr = page_pool_get_dma_addr(frag->au->page);
+		addr = netmem_get_dma_addr(frag->au->nmem);
 		wqe->data[i].addr = cpu_to_be64(addr + frag->offset + headroom);
 	}
 
@@ -475,21 +477,21 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 		   union mlx5e_alloc_unit *au, u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
-	dma_addr_t addr = page_pool_get_dma_addr(au->page);
+	dma_addr_t addr = netmem_get_dma_addr(au->nmem);
 
 	dma_sync_single_for_cpu(rq->pdev, addr + frag_offset, len,
 				rq->buff.map_dir);
-	page_ref_inc(au->page);
+	netmem_get(au->nmem);
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-			au->page, frag_offset, len, truesize);
+			netmem_page(au->nmem), frag_offset, len, truesize);
 }
 
 static inline void
 mlx5e_copy_skb_header(struct mlx5e_rq *rq, struct sk_buff *skb,
-		      struct page *page, dma_addr_t addr,
+		      struct netmem *nmem, dma_addr_t addr,
 		      int offset_from, int dma_offset, u32 headlen)
 {
-	const void *from = page_address(page) + offset_from;
+	const void *from = netmem_address(nmem) + offset_from;
 	/* Aligning len to sizeof(long) optimizes memcpy performance */
 	unsigned int len = ALIGN(headlen, sizeof(long));
 
@@ -522,7 +524,7 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 	} else {
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
 			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-				mlx5e_page_release_dynamic(rq, alloc_units[i].page, recycle);
+				mlx5e_page_release_dynamic(rq, alloc_units[i].nmem, recycle);
 	}
 }
 
@@ -586,7 +588,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 	u16 entries, pi, header_offset, err, wqe_bbs, new_entries;
 	u32 lkey = rq->mdev->mlx5e_res.hw_objs.mkey;
-	struct page *page = shampo->last_page;
+	struct netmem *nmem = shampo->last_nmem;
 	u64 addr = shampo->last_addr;
 	struct mlx5e_dma_info *dma_info;
 	struct mlx5e_umr_wqe *umr_wqe;
@@ -613,11 +615,11 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 			err = mlx5e_page_alloc_pool(rq, &au);
 			if (unlikely(err))
 				goto err_unmap;
-			page = dma_info->page = au.page;
-			addr = dma_info->addr = page_pool_get_dma_addr(au.page);
+			nmem = dma_info->nmem = au.nmem;
+			addr = dma_info->addr = netmem_get_dma_addr(au.nmem);
 		} else {
 			dma_info->addr = addr + header_offset;
-			dma_info->page = page;
+			dma_info->nmem = nmem;
 		}
 
 update_klm:
@@ -635,7 +637,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	};
 
 	shampo->pi = (shampo->pi + new_entries) & (shampo->hd_per_wq - 1);
-	shampo->last_page = page;
+	shampo->last_nmem = nmem;
 	shampo->last_addr = addr;
 	sq->pc += wqe_bbs;
 	sq->doorbell_cseg = &umr_wqe->ctrl;
@@ -647,7 +649,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
 			dma_info->addr = ALIGN_DOWN(dma_info->addr, PAGE_SIZE);
-			mlx5e_page_release_dynamic(rq, dma_info->page, true);
+			mlx5e_page_release_dynamic(rq, dma_info->nmem, true);
 		}
 	}
 	rq->stats->buff_alloc_err++;
@@ -721,7 +723,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		err = mlx5e_page_alloc_pool(rq, au);
 		if (unlikely(err))
 			goto err_unmap;
-		addr = page_pool_get_dma_addr(au->page);
+		addr = netmem_get_dma_addr(au->nmem);
 		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
 			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
 		};
@@ -752,7 +754,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 err_unmap:
 	while (--i >= 0) {
 		au--;
-		mlx5e_page_release_dynamic(rq, au->page, true);
+		mlx5e_page_release_dynamic(rq, au->nmem, true);
 	}
 
 err:
@@ -771,7 +773,7 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 {
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 	int hd_per_wq = shampo->hd_per_wq;
-	struct page *deleted_page = NULL;
+	struct netmem *deleted_nmem = NULL;
 	struct mlx5e_dma_info *hd_info;
 	int i, index = start;
 
@@ -784,9 +786,9 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 
 		hd_info = &shampo->info[index];
 		hd_info->addr = ALIGN_DOWN(hd_info->addr, PAGE_SIZE);
-		if (hd_info->page != deleted_page) {
-			deleted_page = hd_info->page;
-			mlx5e_page_release_dynamic(rq, hd_info->page, false);
+		if (hd_info->nmem != deleted_nmem) {
+			deleted_nmem = hd_info->nmem;
+			mlx5e_page_release_dynamic(rq, hd_info->nmem, false);
 		}
 	}
 
@@ -1125,7 +1127,7 @@ static void *mlx5e_shampo_get_packet_hd(struct mlx5e_rq *rq, u16 header_index)
 	struct mlx5e_dma_info *last_head = &rq->mpwqe.shampo->info[header_index];
 	u16 head_offset = (last_head->addr & (PAGE_SIZE - 1)) + rq->buff.headroom;
 
-	return page_address(last_head->page) + head_offset;
+	return netmem_address(last_head->nmem) + head_offset;
 }
 
 static void mlx5e_shampo_update_ipv4_udp_hdr(struct mlx5e_rq *rq, struct iphdr *ipv4)
@@ -1584,11 +1586,11 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 	dma_addr_t addr;
 	u32 frag_size;
 
-	va             = page_address(au->page) + wi->offset;
+	va             = netmem_address(au->nmem) + wi->offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = netmem_get_dma_addr(au->nmem);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
@@ -1599,7 +1601,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp))
+		if (mlx5e_xdp_handle(rq, au->nmem, prog, &xdp))
 			return NULL; /* page/packet was consumed by XDP */
 
 		rx_headroom = xdp.data - xdp.data_hard_start;
@@ -1612,7 +1614,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	page_ref_inc(au->page);
+	netmem_get(au->nmem);
 
 	return skb;
 }
@@ -1634,10 +1636,10 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	u32 truesize;
 	void *va;
 
-	va = page_address(au->page) + wi->offset;
+	va = netmem_address(au->nmem) + wi->offset;
 	frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = netmem_get_dma_addr(au->nmem);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, wi->offset,
 				      rq->buff.frame0_sz, rq->buff.map_dir);
 	net_prefetchw(va); /* xdp_frame data area */
@@ -1658,7 +1660,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 
 		frag_consumed_bytes = min_t(u32, frag_info->frag_size, cqe_bcnt);
 
-		addr = page_pool_get_dma_addr(au->page);
+		addr = netmem_get_dma_addr(au->nmem);
 		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
 					frag_consumed_bytes, rq->buff.map_dir);
 
@@ -1672,11 +1674,11 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 		}
 
 		frag = &sinfo->frags[sinfo->nr_frags++];
-		__skb_frag_set_page(frag, au->page);
+		__skb_frag_set_netmem(frag, au->nmem);
 		skb_frag_off_set(frag, wi->offset);
 		skb_frag_size_set(frag, frag_consumed_bytes);
 
-		if (page_is_pfmemalloc(au->page))
+		if (netmem_is_pfmemalloc(au->nmem))
 			xdp_buff_set_frag_pfmemalloc(&xdp);
 
 		sinfo->xdp_frags_size += frag_consumed_bytes;
@@ -1690,7 +1692,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	au = head_wi->au;
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
+	if (prog && mlx5e_xdp_handle(rq, au->nmem, prog, &xdp)) {
 		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
 			int i;
 
@@ -1707,7 +1709,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	if (unlikely(!skb))
 		return NULL;
 
-	page_ref_inc(au->page);
+	netmem_get(au->nmem);
 
 	if (unlikely(xdp_buff_has_frags(&xdp))) {
 		int i;
@@ -1956,8 +1958,8 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 	mlx5e_fill_skb_data(skb, rq, au, byte_cnt, frag_offset);
 	/* copy header */
-	addr = page_pool_get_dma_addr(head_au->page);
-	mlx5e_copy_skb_header(rq, skb, head_au->page, addr,
+	addr = netmem_get_dma_addr(head_au->nmem);
+	mlx5e_copy_skb_header(rq, skb, head_au->nmem, addr,
 			      head_offset, head_offset, headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
@@ -1985,11 +1987,11 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 	}
 
-	va             = page_address(au->page) + head_offset;
+	va             = netmem_address(au->nmem) + head_offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = netmem_get_dma_addr(au->nmem);
 	dma_sync_single_range_for_cpu(rq->pdev, addr, head_offset,
 				      frag_size, rq->buff.map_dir);
 	net_prefetch(data);
@@ -2000,7 +2002,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
+		if (mlx5e_xdp_handle(rq, au->nmem, prog, &xdp)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 			return NULL; /* page/packet was consumed by XDP */
@@ -2016,7 +2018,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	page_ref_inc(au->page);
+	netmem_get(au->nmem);
 
 	return skb;
 }
@@ -2033,7 +2035,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	void *hdr, *data;
 	u32 frag_size;
 
-	hdr		= page_address(head->page) + head_offset;
+	hdr		= netmem_address(head->nmem) + head_offset;
 	data		= hdr + rx_headroom;
 	frag_size	= MLX5_SKB_FRAG_SZ(rx_headroom + head_size);
 
@@ -2048,7 +2050,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			return NULL;
 
 		/* queue up for recycling/reuse */
-		page_ref_inc(head->page);
+		netmem_get(head->nmem);
 
 	} else {
 		/* allocate SKB and copy header for large header */
@@ -2061,7 +2063,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		}
 
 		prefetchw(skb->data);
-		mlx5e_copy_skb_header(rq, skb, head->page, head->addr,
+		mlx5e_copy_skb_header(rq, skb, head->nmem, head->addr,
 				      head_offset + rx_headroom,
 				      rx_headroom, head_size);
 		/* skb linear part was allocated with headlen and aligned to long */
@@ -2113,7 +2115,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 
 	if (((header_index + 1) & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) == 0) {
 		shampo->info[header_index].addr = ALIGN_DOWN(addr, PAGE_SIZE);
-		mlx5e_page_release_dynamic(rq, shampo->info[header_index].page, true);
+		mlx5e_page_release_dynamic(rq, shampo->info[header_index].nmem, true);
 	}
 	bitmap_clear(shampo->bitmap, header_index, 1);
 }
-- 
2.35.1

