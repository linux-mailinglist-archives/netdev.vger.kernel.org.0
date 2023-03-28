Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82B6CCBAB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjC1U5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC1U5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CFB30D6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F186E61965
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4266CC433AE;
        Tue, 28 Mar 2023 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037011;
        bh=I23JbWt3pnwxk2S5aZ56ZAfB7RVuunEPLupu2dZDWzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe/QOdOTeFISyWJA5dfL7J/VOuEGiH1kAK/OR26pwzNBAjlSkASSeZpeIMnKFiWsE
         +RZeaAmyKEtzpb6eyuPb9OJWPi7O8A8cmQ+1dkETNFggIFjVgsTzTRvywdAEZ354u2
         og0aI/yxaD5E8OGaxwI9ey65qZvO1q56unnbQCuNQR/KArGZJl0GUFjdT1EWVCG+x6
         fgoRsT8AhETXXzzUYiM/nAIZKPLQQ06V+g36jetU1XyyYQiycGPFGn7UWCYeAugD/W
         ZrZs7TE4eGOmXoQHP9P1QT/pOA2sjOmjBCAFeKr334ZCT7F613xRS+aPmBxDcJXfEe
         zVufZNC4NYoMg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: RX, Enable dma map and sync from page_pool allocator
Date:   Tue, 28 Mar 2023 13:56:14 -0700
Message-Id: <20230328205623.142075-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

Remove driver dma mapping and unmapping of pages. Let the
page_pool api do it.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 --
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +++--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 22 -------------------
 4 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index dab00a2c2eb7..04419f56ac85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -65,7 +65,6 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget);
 int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 
 /* RX */
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page);
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle);
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c5dae48b7932..5e6ef602c748 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -209,8 +209,6 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq,
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
-		if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
-			mlx5e_page_dma_unmap(rq, virt_to_page(xdp->data));
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b0322a20b71b..2a73680021c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -733,7 +733,6 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			  struct mlx5e_rq_param *rqp,
 			  int node, struct mlx5e_rq *rq)
 {
-	struct page_pool_params pp_params = { 0 };
 	struct mlx5_core_dev *mdev = rq->mdev;
 	void *rqc = rqp->rqc;
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rqc, wq);
@@ -829,12 +828,15 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		xsk_pool_set_rxq_info(rq->xsk_pool, &rq->xdp_rxq);
 	} else {
 		/* Create a page_pool and register it with rxq */
+		struct page_pool_params pp_params = { 0 };
+
 		pp_params.order     = 0;
-		pp_params.flags     = 0; /* No-internal DMA mapping in page_pool */
+		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 		pp_params.pool_size = pool_size;
 		pp_params.nid       = node;
 		pp_params.dev       = rq->pdev;
 		pp_params.dma_dir   = rq->buff.map_dir;
+		pp_params.max_len   = PAGE_SIZE;
 
 		/* page_pool can be used even when there is no rq->xdp_prog,
 		 * given page_pool does not handle DMA mapping there is no
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 192f12a7d9a9..01c789b89cb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -273,40 +273,18 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 
 static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct page **pagep)
 {
-	dma_addr_t addr;
-
 	*pagep = page_pool_dev_alloc_pages(rq->page_pool);
 	if (unlikely(!*pagep))
 		return -ENOMEM;
 
-	/* Non-XSK always uses PAGE_SIZE. */
-	addr = dma_map_page(rq->pdev, *pagep, 0, PAGE_SIZE, rq->buff.map_dir);
-	if (unlikely(dma_mapping_error(rq->pdev, addr))) {
-		page_pool_recycle_direct(rq->page_pool, *pagep);
-		*pagep = NULL;
-		return -ENOMEM;
-	}
-	page_pool_set_dma_addr(*pagep, addr);
-
 	return 0;
 }
 
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page)
-{
-	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
-
-	dma_unmap_page_attrs(rq->pdev, dma_addr, PAGE_SIZE, rq->buff.map_dir,
-			     DMA_ATTR_SKIP_CPU_SYNC);
-	page_pool_set_dma_addr(page, 0);
-}
-
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool recycle)
 {
 	if (likely(recycle)) {
-		mlx5e_page_dma_unmap(rq, page);
 		page_pool_recycle_direct(rq->page_pool, page);
 	} else {
-		mlx5e_page_dma_unmap(rq, page);
 		page_pool_release_page(rq->page_pool, page);
 		put_page(page);
 	}
-- 
2.39.2

