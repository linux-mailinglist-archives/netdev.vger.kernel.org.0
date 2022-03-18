Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D720A4DE2E6
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbiCRUyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240858AbiCRUyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC238DEF2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 849B4B8257B
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0845DC340EF;
        Fri, 18 Mar 2022 20:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636792;
        bh=7T4hQGXhAzV7Iws09npCV2601ptzOLw8gnHFzZO3UPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isXAxtL4OHuXhJBFiazYrU+l6NPgsiGIUB0AcEFgyAELiqScx2b3DJSJZIMe54HF5
         YcxKP/8pcOUaMk/culBNnwyf07zwdEL1ceiA3TSbT+o4vNeEO1DoKg3w5NH+UTse2J
         cG7Vxchzj1L0EC9vLtLe9dLnaDcBmLhKFhnUVo5dvdvrmSvZvJV4tRJEnsupM0TA/i
         IK0DLPhGTpfljtnwqF2uOMi58EOs+wh4eajPvqRwJgbAyYTC4qX83YcbiyommWuR1T
         pfZU3xSHN65p6o2/W0KIkkzPyvQLndHzYnhRUoyn1MBCeXAGIjDjGxb6roetcdx6Qe
         mPqRhhqkJCeOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Store DMA address inside struct page
Date:   Fri, 18 Mar 2022 13:52:38 -0700
Message-Id: <20220318205248.33367-6-saeed@kernel.org>
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

Use page_pool_set_dma_addr() to store the DMA address of a page inside
struct page, in order to avoid passing struct mlx5e_dma_info to XDP
handlers. Previously, struct mlx5e_dma_info was used to pass both the
DMA address and the page, and it worked well for the single-fragment
case.

When XDP multi buffer is in use, and a fragmented xdp_frame has to be
transmitted, the driver needs to know the DMA addresses of fragments,
however, the array of fragments in struct skb_shared_info doesn't
contain them. In order to pass the DMA addresses, the driver puts them
into struct page itself, which is accessible from the array of fragments
in struct skb_shared_info. The existing XDP handlers are modified to
remove the dependency on struct mlx5e_dma_info.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +--
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 14 +++----
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 40 ++++++++++---------
 6 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2704c7537481..f5b2449fa15a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -515,7 +515,7 @@ struct mlx5e_xdp_info {
 		} frame;
 		struct {
 			struct mlx5e_rq *rq;
-			struct mlx5e_dma_info di;
+			struct page *page;
 		} page;
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 210d23bf3701..c208ea307bff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -44,10 +44,8 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget);
 int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 
 /* RX */
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-				struct mlx5e_dma_info *dma_info,
-				bool recycle);
+void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page);
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle);
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq));
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 3a837030e96e..91dd5c59657b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -57,7 +57,7 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 
 static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
-		    struct mlx5e_dma_info *di, struct xdp_buff *xdp)
+		    struct page *page, struct xdp_buff *xdp)
 {
 	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
@@ -110,13 +110,13 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 		xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
 
-		dma_addr = di->addr + (xdpf->data - (void *)xdpf);
+		dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
 		dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len,
 					   DMA_TO_DEVICE);
 
 		xdptxd.dma_addr = dma_addr;
 		xdpi.page.rq    = rq;
-		xdpi.page.di    = *di;
+		xdpi.page.page = page;
 	}
 
 	return INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
@@ -124,7 +124,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 }
 
 /* returns true if packet was consumed by xdp */
-bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
+bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 		      struct bpf_prog *prog, struct xdp_buff *xdp)
 {
 	u32 act;
@@ -135,7 +135,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, di, xdp)))
+		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, page, xdp)))
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
 		return true;
@@ -147,7 +147,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
 		if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
-			mlx5e_page_dma_unmap(rq, di);
+			mlx5e_page_dma_unmap(rq, page);
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
@@ -384,7 +384,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
-			mlx5e_page_release_dynamic(xdpi.page.rq, &xdpi.page.di, recycle);
+			mlx5e_page_release_dynamic(xdpi.page.rq, xdpi.page.page, recycle);
 			break;
 		case MLX5E_XDP_XMIT_MODE_XSK:
 			/* AF_XDP send */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 20d8af66c072..8a92cf007991 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -47,7 +47,7 @@
 
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
-bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
+bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 		      struct bpf_prog *prog, struct xdp_buff *xdp);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 91b90bbb2b28..f21cae712ce5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -780,7 +780,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		 * entered, and it's safe to call mlx5e_page_release_dynamic
 		 * directly.
 		 */
-		mlx5e_page_release_dynamic(rq, dma_info, false);
+		mlx5e_page_release_dynamic(rq, dma_info->page, false);
 	}
 
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e9ad5b3a30ed..56bb58704bf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -222,8 +222,7 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
 }
 
-static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq,
-				      struct mlx5e_dma_info *dma_info)
+static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
 {
 	struct mlx5e_page_cache *cache = &rq->page_cache;
 	u32 tail_next = (cache->tail + 1) & (MLX5E_CACHE_SIZE - 1);
@@ -234,12 +233,13 @@ static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq,
 		return false;
 	}
 
-	if (!dev_page_is_reusable(dma_info->page)) {
+	if (!dev_page_is_reusable(page)) {
 		stats->cache_waive++;
 		return false;
 	}
 
-	cache->page_cache[cache->tail] = *dma_info;
+	cache->page_cache[cache->tail].page = page;
+	cache->page_cache[cache->tail].addr = page_pool_get_dma_addr(page);
 	cache->tail = tail_next;
 	return true;
 }
@@ -287,6 +287,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 		dma_info->page = NULL;
 		return -ENOMEM;
 	}
+	page_pool_set_dma_addr(dma_info->page, dma_info->addr);
 
 	return 0;
 }
@@ -300,26 +301,27 @@ static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 		return mlx5e_page_alloc_pool(rq, dma_info);
 }
 
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
+void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page)
 {
-	dma_unmap_page_attrs(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir,
+	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
+
+	dma_unmap_page_attrs(rq->pdev, dma_addr, PAGE_SIZE, rq->buff.map_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
+	page_pool_set_dma_addr(page, 0);
 }
 
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-				struct mlx5e_dma_info *dma_info,
-				bool recycle)
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle)
 {
 	if (likely(recycle)) {
-		if (mlx5e_rx_cache_put(rq, dma_info))
+		if (mlx5e_rx_cache_put(rq, page))
 			return;
 
-		mlx5e_page_dma_unmap(rq, dma_info);
-		page_pool_recycle_direct(rq->page_pool, dma_info->page);
+		mlx5e_page_dma_unmap(rq, page);
+		page_pool_recycle_direct(rq->page_pool, page);
 	} else {
-		mlx5e_page_dma_unmap(rq, dma_info);
-		page_pool_release_page(rq->page_pool, dma_info->page);
-		put_page(dma_info->page);
+		mlx5e_page_dma_unmap(rq, page);
+		page_pool_release_page(rq->page_pool, page);
+		put_page(page);
 	}
 }
 
@@ -334,7 +336,7 @@ static inline void mlx5e_page_release(struct mlx5e_rq *rq,
 		 */
 		xsk_buff_free(dma_info->xsk);
 	else
-		mlx5e_page_release_dynamic(rq, dma_info, recycle);
+		mlx5e_page_release_dynamic(rq, dma_info->page, recycle);
 }
 
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
@@ -1544,7 +1546,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, di, prog, &xdp))
+		if (mlx5e_xdp_handle(rq, di->page, prog, &xdp))
 			return NULL; /* page/packet was consumed by XDP */
 
 		rx_headroom = xdp.data - xdp.data_hard_start;
@@ -1632,7 +1634,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	di = head_wi->di;
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (prog && mlx5e_xdp_handle(rq, di, prog, &xdp)) {
+	if (prog && mlx5e_xdp_handle(rq, di->page, prog, &xdp)) {
 		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
 			int i;
 
@@ -1934,7 +1936,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, di, prog, &xdp)) {
+		if (mlx5e_xdp_handle(rq, di->page, prog, &xdp)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 			return NULL; /* page/packet was consumed by XDP */
-- 
2.35.1

