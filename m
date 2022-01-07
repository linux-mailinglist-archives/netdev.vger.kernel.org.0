Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7C0487461
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 10:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346280AbiAGJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 04:00:18 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17332 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiAGJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 04:00:18 -0500
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JVcbM3jrKz9s5N;
        Fri,  7 Jan 2022 16:59:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 17:00:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 17:00:14 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>
Subject: [PATCH net-next] page_pool: remove spinlock in page_pool_refill_alloc_cache()
Date:   Fri, 7 Jan 2022 17:00:42 +0800
Message-ID: <20220107090042.13605-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As page_pool_refill_alloc_cache() is only called by
__page_pool_get_cached(), which assumes non-concurrent access
as suggested by the comment in __page_pool_get_cached(), and
ptr_ring allows concurrent access between consumer and producer,
so remove the spinlock in page_pool_refill_alloc_cache().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/page_pool.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a6978427d6c..6efad8b29e9c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -130,9 +130,6 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	pref_nid = numa_mem_id(); /* will be zero like page_to_nid() */
 #endif
 
-	/* Slower-path: Get pages from locked ring queue */
-	spin_lock(&r->consumer_lock);
-
 	/* Refill alloc array, but only if NUMA match */
 	do {
 		page = __ptr_ring_consume(r);
@@ -157,7 +154,6 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	if (likely(pool->alloc.count > 0))
 		page = pool->alloc.cache[--pool->alloc.count];
 
-	spin_unlock(&r->consumer_lock);
 	return page;
 }
 
-- 
2.33.0

