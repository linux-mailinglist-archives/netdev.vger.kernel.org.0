Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4583241D53F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348978AbhI3ILJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:11:09 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24202 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348889AbhI3ILH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 04:11:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKm8b18XDz8tS0;
        Thu, 30 Sep 2021 16:08:31 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:09:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:09:23 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next v4 3/3] skbuff: keep track of pp page when pp_frag_count is used
Date:   Thu, 30 Sep 2021 16:07:47 +0800
Message-ID: <20210930080747.28297-4-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930080747.28297-1-linyunsheng@huawei.com>
References: <20210930080747.28297-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the skb->pp_recycle and page->pp_magic may not be enough
to track if a frag page is from page pool after the calling
of __skb_frag_ref(), mostly because of a data race, see:
commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
recycling page_pool packets").

There may be clone and expand head case that might lose the
track if a frag page is from page pool or not.

And not being able to keep track of pp page may cause problem
for the skb_split() case in tso_fragment() too:
Supposing a skb has 3 frag pages, all coming from a page pool,
and is split to skb1 and skb2:
skb1: first frag page + first half of second frag page
skb2: second half of second frag page + third frag page

How do we set the skb->pp_recycle of skb1 and skb2?
1. If we set both of them to 1, then we may have a similar
   race as the above commit for second frag page.
2. If we set only one of them to 1, then we may have resource
   leaking problem as both first frag page and third frag page
   are indeed from page pool.

Increment the pp_frag_count of pp page frag in __skb_frag_ref(),
and only use page->pp_magic to indicate a pp page frag in
__skb_frag_unref() to keep track of pp page frag.

Similar handling is done for the head page of a skb too.

As we need the head page of a compound page to decide if it is
from page pool at first, so __page_frag_cache_drain() and
page_ref_inc() is used to avoid unnecessary compound_head()
calling.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h  | 30 ++++++++++++++++++++----------
 include/net/page_pool.h | 24 +++++++++++++++++++++++-
 net/core/page_pool.c    | 17 ++---------------
 net/core/skbuff.c       | 10 ++++++++--
 4 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 841e2f0f5240..aeee150d4a04 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3073,7 +3073,19 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
  */
 static inline void __skb_frag_ref(skb_frag_t *frag)
 {
-	get_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+	page = compound_head(page);
+
+#ifdef CONFIG_PAGE_POOL
+	if (page_pool_is_pp_page(page) &&
+	    page_pool_is_pp_page_frag(page)) {
+		page_pool_atomic_inc_frag_count(page);
+		return;
+	}
+#endif
+
+	page_ref_inc(page);
 }
 
 /**
@@ -3100,11 +3112,16 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
 	struct page *page = skb_frag_page(frag);
 
+	page = compound_head(page);
+
 #ifdef CONFIG_PAGE_POOL
-	if (recycle && page_pool_return_skb_page(page))
+	if (page_pool_is_pp_page(page) &&
+	    (recycle || page_pool_is_pp_page_frag(page))) {
+		page_pool_return_skb_page(page);
 		return;
+	}
 #endif
-	put_page(page);
+	__page_frag_cache_drain(page, 1);
 }
 
 /**
@@ -4718,12 +4735,5 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 }
 #endif
 
-static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
-{
-	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
-		return false;
-	return page_pool_return_skb_page(virt_to_page(data));
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3855f069627f..740a8ca7f4a6 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
-bool page_pool_return_skb_page(struct page *page);
+void page_pool_return_skb_page(struct page *page);
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
@@ -231,6 +231,28 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
 	atomic_long_set(&page->pp_frag_count, nr);
 }
 
+static inline void page_pool_atomic_inc_frag_count(struct page *page)
+{
+	atomic_long_inc(&page->pp_frag_count);
+}
+
+static inline bool page_pool_is_pp_page(struct page *page)
+{
+	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
+	 * in order to preserve any existing bits, such as bit 0 for the
+	 * head page of compound page and bit 1 for pfmemalloc page, so
+	 * mask those bits for freeing side when doing below checking,
+	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
+	 * to avoid recycling the pfmemalloc page.
+	 */
+	return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
+}
+
+static inline bool page_pool_is_pp_page_frag(struct page *page)
+{
+	return !!atomic_long_read(&page->pp_frag_count);
+}
+
 static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
 							  long nr)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2c643b72ce16..d141e00459c9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -219,6 +219,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 {
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
+	page_pool_set_frag_count(page, 0);
 }
 
 static void page_pool_clear_pp_info(struct page *page)
@@ -736,22 +737,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 }
 EXPORT_SYMBOL(page_pool_update_nid);
 
-bool page_pool_return_skb_page(struct page *page)
+void page_pool_return_skb_page(struct page *page)
 {
 	struct page_pool *pp;
 
-	page = compound_head(page);
-
-	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
-	 * in order to preserve any existing bits, such as bit 0 for the
-	 * head page of compound page and bit 1 for pfmemalloc page, so
-	 * mask those bits for freeing side when doing below checking,
-	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
-	 * to avoid recycling the pfmemalloc page.
-	 */
-	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
-		return false;
-
 	pp = page->pp;
 
 	/* Driver set this to memory recycling info. Reset it on recycle.
@@ -760,7 +749,5 @@ bool page_pool_return_skb_page(struct page *page)
 	 * 'flipped' fragment being in use or not.
 	 */
 	page_pool_put_full_page(pp, page, false);
-
-	return true;
 }
 EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 74601bbc56ac..e3691b025d30 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -646,9 +646,15 @@ static void skb_free_head(struct sk_buff *skb)
 	unsigned char *head = skb->head;
 
 	if (skb->head_frag) {
-		if (skb_pp_recycle(skb, head))
+		struct page *page = virt_to_head_page(head);
+
+		if (page_pool_is_pp_page(page) &&
+		    (skb->pp_recycle || page_pool_is_pp_page_frag(page))) {
+			page_pool_return_skb_page(page);
 			return;
-		skb_free_frag(head);
+		}
+
+		__page_frag_cache_drain(page, 1);
 	} else {
 		kfree(head);
 	}
-- 
2.33.0

