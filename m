Return-Path: <netdev+bounces-5600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C62771239C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 483891C21202
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E4115499;
	Fri, 26 May 2023 09:28:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3E715498
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:28:29 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96524195;
	Fri, 26 May 2023 02:28:23 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QSKNL70jZzTjvF;
	Fri, 26 May 2023 17:28:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 17:28:21 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Alexander
 Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet
	<edumazet@google.com>
Subject: [PATCH net-next 2/2] page_pool: support non-frag page for page_pool_alloc_frag()
Date: Fri, 26 May 2023 17:26:15 +0800
Message-ID: <20230526092616.40355-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230526092616.40355-1-linyunsheng@huawei.com>
References: <20230526092616.40355-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is performance penalty with using page frag support when
user requests a larger frag size and a page only supports one
frag user, see [1].

It seems like user may request different frag size depending
on the mtu and packet size, provide an option to allocate
non-frag page when a whole page is not able to hold two frags,
so that user has a unified interface for the memory allocation
with least memory utilization and performance penalty.

1. https://lore.kernel.org/netdev/ZEU+vospFdm08IeE@localhost.localdomain/

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
CC: Lorenzo Bianconi <lorenzo@kernel.org>
CC: Alexander Duyck <alexander.duyck@gmail.com>
---
 net/core/page_pool.c | 47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 0868aa8f6323..e84ec6eabefd 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -699,14 +699,27 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 	unsigned int max_size = PAGE_SIZE << pool->p.order;
 	struct page *page = pool->frag_page;
 
-	if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
-		    size > max_size))
+	if (unlikely(size > max_size))
 		return NULL;
 
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
+		*offset = 0;
+		return page_pool_alloc_pages(pool, gfp);
+	}
+
 	size = ALIGN(size, dma_get_cache_alignment());
-	*offset = pool->frag_offset;
 
-	if (page && *offset + size > max_size) {
+	if (page) {
+		*offset = pool->frag_offset;
+
+		if (*offset + size <= max_size) {
+			pool->frag_users++;
+			pool->frag_offset = *offset + size;
+			alloc_stat_inc(pool, fast);
+			return page;
+		}
+
+		pool->frag_page = NULL;
 		page = page_pool_drain_frag(pool, page);
 		if (page) {
 			alloc_stat_inc(pool, fast);
@@ -714,26 +727,24 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 		}
 	}
 
-	if (!page) {
-		page = page_pool_alloc_pages(pool, gfp);
-		if (unlikely(!page)) {
-			pool->frag_page = NULL;
-			return NULL;
-		}
-
-		pool->frag_page = page;
+	page = page_pool_alloc_pages(pool, gfp);
+	if (unlikely(!page))
+		return NULL;
 
 frag_reset:
-		pool->frag_users = 1;
+	/* return page as non-frag page if a page is not able to
+	 * hold two frags for the current requested size.
+	 */
+	if (unlikely(size << 1 > max_size)) {
 		*offset = 0;
-		pool->frag_offset = size;
-		page_pool_fragment_page(page, BIAS_MAX);
 		return page;
 	}
 
-	pool->frag_users++;
-	pool->frag_offset = *offset + size;
-	alloc_stat_inc(pool, fast);
+	pool->frag_page = page;
+	pool->frag_users = 1;
+	*offset = 0;
+	pool->frag_offset = size;
+	page_pool_fragment_page(page, BIAS_MAX);
 	return page;
 }
 EXPORT_SYMBOL(page_pool_alloc_frag);
-- 
2.33.0


