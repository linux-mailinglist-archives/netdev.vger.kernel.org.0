Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CE414570
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhIVJoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:44:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9753 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbhIVJok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:44:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HDtc75qZVzWMr4;
        Wed, 22 Sep 2021 17:41:59 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:01 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:01 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 2/7] page_pool: support non-split page with PP_FLAG_PAGE_FRAG
Date:   Wed, 22 Sep 2021 17:41:26 +0800
Message-ID: <20210922094131.15625-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922094131.15625-1-linyunsheng@huawei.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
expected to call page_pool_alloc_pages() directly because of
the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().

The patch removes the above checking to enable non-split page
support when PP_FLAG_PAGE_FRAG is set.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/page_pool.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a65bd7972e37..f7e71dcb6a2e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -315,11 +315,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 
 	/* Fast-path: Get a page from cache */
 	page = __page_pool_get_cached(pool);
-	if (page)
-		return page;
 
 	/* Slow-path: cache empty, do real allocation */
-	page = __page_pool_alloc_pages_slow(pool, gfp);
+	if (!page)
+		page = __page_pool_alloc_pages_slow(pool, gfp);
+
+	if (likely(page))
+		page_pool_set_frag_count(page, 1);
+
 	return page;
 }
 EXPORT_SYMBOL(page_pool_alloc_pages);
@@ -428,8 +431,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 		     unsigned int dma_sync_size, bool allow_direct)
 {
 	/* It is not the last user for the page frag case */
-	if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
-	    page_pool_atomic_sub_frag_count_return(page, 1))
+	if (page_pool_atomic_sub_frag_count_return(page, 1))
 		return NULL;
 
 	/* This allocator is optimized for the XDP mode that uses
-- 
2.33.0

