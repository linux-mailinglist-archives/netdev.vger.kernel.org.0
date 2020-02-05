Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7066152784
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgBEIWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 03:22:52 -0500
Received: from mx140-tc.baidu.com ([61.135.168.140]:52373 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725875AbgBEIWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 03:22:51 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 026FE2040051;
        Wed,  5 Feb 2020 16:22:35 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH] page_pool: fill page only when refill condition is true
Date:   Wed,  5 Feb 2020 16:22:34 +0800
Message-Id: <1580890954-21322-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"do {} while" in page_pool_refill_alloc_cache will always
refill page once whether refill is true or false, and whether
alloc.count of pool is less than PP_ALLOC_CACHE_REFILL.

so fix it by calling page_pool_refill_alloc_cache() only when
refill is true

Fixes: 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b7cbe35df37..35ce663cb9de 100644
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
@@ -156,7 +154,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
 	bool refill = false;
-	struct page *page;
+	struct page *page = NULL;
 
 	/* Test for safe-context, caller should provide this guarantee */
 	if (likely(in_serving_softirq())) {
@@ -168,7 +166,8 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 		refill = true;
 	}
 
-	page = page_pool_refill_alloc_cache(pool, refill);
+	if (refill)
+		page = page_pool_refill_alloc_cache(pool);
 	return page;
 }
 
-- 
2.16.2

