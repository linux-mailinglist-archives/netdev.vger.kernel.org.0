Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D502C158823
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 03:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBKCN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 21:13:59 -0500
Received: from mx133-tc.baidu.com ([61.135.168.133]:20578 "EHLO
        tc-sys-mailedm03.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727612AbgBKCN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 21:13:59 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm03.tc.baidu.com (Postfix) with ESMTP id 334394500032;
        Tue, 11 Feb 2020 10:13:44 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH][v2] page_pool: refill page when alloc.count of pool is zero
Date:   Tue, 11 Feb 2020 10:13:44 +0800
Message-Id: <1581387224-20719-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"do {} while" in page_pool_refill_alloc_cache will always
refill page once whether refill is true or false, and whether
alloc.count of pool is less than PP_ALLOC_CACHE_REFILL or not
this is wrong, and will cause overflow of pool->alloc.cache

the caller of __page_pool_get_cached should provide guarantee
that pool->alloc.cache is safe to access, so in_serving_softirq
should be removed as suggested by Jesper Dangaard Brouer in
https://patchwork.ozlabs.org/patch/1233713/

so fix this issue by calling page_pool_refill_alloc_cache()
only when pool->alloc.count is zero

Fixes: 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Suggested: Jesper Dangaard Brouer <brouer@redhat.com>
---
v1-->v2: remove the in_serving_softirq test

 net/core/page_pool.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b7cbe35df37..10d2b255df5e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -99,8 +99,7 @@ EXPORT_SYMBOL(page_pool_create);
 static void __page_pool_return_page(struct page_pool *pool, struct page *page);
 
 noinline
-static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
-						 bool refill)
+static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 {
 	struct ptr_ring *r = &pool->ring;
 	struct page *page;
@@ -141,8 +140,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
 			page = NULL;
 			break;
 		}
-	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL &&
-		 refill);
+	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
 	if (likely(pool->alloc.count > 0))
@@ -155,20 +153,16 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
 /* fast path */
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
-	bool refill = false;
 	struct page *page;
 
-	/* Test for safe-context, caller should provide this guarantee */
-	if (likely(in_serving_softirq())) {
-		if (likely(pool->alloc.count)) {
-			/* Fast-path */
-			page = pool->alloc.cache[--pool->alloc.count];
-			return page;
-		}
-		refill = true;
+	/* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
+	if (likely(pool->alloc.count)) {
+		/* Fast-path */
+		page = pool->alloc.cache[--pool->alloc.count];
+	} else {
+		page = page_pool_refill_alloc_cache(pool);
 	}
 
-	page = page_pool_refill_alloc_cache(pool, refill);
 	return page;
 }
 
-- 
2.16.2

