Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF3A6652BB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjAKEWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjAKEWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:22:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D8B8FCF
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=X98r58MbAgZPQ4+1bekghvQ632iWN8JTQMfdSkUSkNQ=; b=OLOZYsZtuOdqFm6rh9vApicxj0
        YxilqtkFg9Oh9hVGvdjGPAkPwtg4tAD4191gQ0FFNvHAdZ8D2XHfJ6nJKRaRMvGX9/z0/B7g6CiuB
        az34Nlwn8x88CPEvBaFmpfp5RAKZavkYXw2fzPbniaDcv7rPqRS16OQ9XTWya5w3QhoCPL5dQ1K4a
        h3o5Lx/F3vdVmKlJkPkrcQbxKozqoxXwCwxulplEzCamliGZNoNpqpVWdx6MGYCASYobcsUs6gRnK
        LEWmQdjZTnBWjx7eBp+ML3uT/eHQsbSqAiyFiO6/LRRsLXNP+aRLHOYD78Q//HFE4JfkoQIWT6cJ2
        0ShX1ejA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFSd0-003nzY-LT; Wed, 11 Jan 2023 04:22:18 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v3 26/26] hns3: Convert to netmem
Date:   Wed, 11 Jan 2023 04:22:14 +0000
Message-Id: <20230111042214.907030-27-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111042214.907030-1-willy@infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
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

Use the new netmem APIs in the hns3 driver.  Convert
page_pool_dev_alloc_frag() to return a netmem as this is the only user
of the API.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 16 ++++++++--------
 include/net/page_pool.h                         |  7 +++----
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b4c4fb873568..ca0dc201bd47 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3355,15 +3355,15 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 	struct page *p;
 
 	if (ring->page_pool) {
-		p = page_pool_dev_alloc_frag(ring->page_pool,
+		struct netmem *nmem = page_pool_dev_alloc_frag(ring->page_pool,
 					     &cb->page_offset,
 					     hns3_buf_size(ring));
-		if (unlikely(!p))
+		if (unlikely(!nmem))
 			return -ENOMEM;
 
-		cb->priv = p;
-		cb->buf = page_address(p);
-		cb->dma = page_pool_get_dma_addr(p);
+		cb->priv = nmem;
+		cb->buf = netmem_address(nmem);
+		cb->dma = netmem_get_dma_addr(nmem);
 		cb->type = DESC_TYPE_PP_FRAG;
 		cb->reuse_flag = 0;
 		return 0;
@@ -3395,7 +3395,7 @@ static void hns3_free_buffer(struct hns3_enet_ring *ring,
 		if (cb->type & DESC_TYPE_PAGE && cb->pagecnt_bias)
 			__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
 		else if (cb->type & DESC_TYPE_PP_FRAG)
-			page_pool_put_full_page(ring->page_pool, cb->priv,
+			page_pool_put_full_netmem(ring->page_pool, cb->priv,
 						false);
 	}
 	memset(cb, 0, sizeof(*cb));
@@ -4043,8 +4043,8 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 		if (dev_page_is_reusable(desc_cb->priv))
 			desc_cb->reuse_flag = 1;
 		else if (desc_cb->type & DESC_TYPE_PP_FRAG)
-			page_pool_put_full_page(ring->page_pool, desc_cb->priv,
-						false);
+			page_pool_put_full_netmem(ring->page_pool,
+						desc_cb->priv, false);
 		else /* This page cannot be reused so discard it */
 			__page_frag_cache_drain(desc_cb->priv,
 						desc_cb->pagecnt_bias);
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index af8ba8a0dd05..0a2588e6a0f3 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -334,13 +334,12 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 struct netmem *page_pool_alloc_frag(struct page_pool *pool,
 		unsigned int *offset, unsigned int size, gfp_t gfp);
 
-static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
-						    unsigned int *offset,
-						    unsigned int size)
+static inline struct netmem *page_pool_dev_alloc_frag(struct page_pool *pool,
+		unsigned int *offset, unsigned int size)
 {
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	return netmem_page(page_pool_alloc_frag(pool, offset, size, gfp));
+	return page_pool_alloc_frag(pool, offset, size, gfp);
 }
 
 /* get the stored dma direction. A driver might decide to treat this locally and
-- 
2.35.1

