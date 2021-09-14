Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE440AD32
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhINMOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:14:04 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16199 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhINMN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:13:59 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H82JX5qDPz1DGv5;
        Tue, 14 Sep 2021 20:11:40 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:40 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:39 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next v2 3/3] skbuff: keep track of pp page when __skb_frag_ref() is called
Date:   Tue, 14 Sep 2021 20:11:14 +0800
Message-ID: <20210914121114.28559-4-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914121114.28559-1-linyunsheng@huawei.com>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
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

So increment the frag count when __skb_frag_ref() is called,
and only use page->pp_magic to indicate if a frag page is from
page pool, to avoid the above data race.

For 32 bit systems with 64 bit dma, we preserve the orginial
behavior as frag count is used to trace how many time does a
frag page is called with __skb_frag_ref().

We still use both skb->pp_recycle and page->pp_magic to decide
the head page for a skb is from page pool or not.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h  | 40 ++++++++++++++++++++++++++++++++++++----
 include/net/page_pool.h | 28 +++++++++++++++++++++++++++-
 net/core/page_pool.c    | 16 ++--------------
 3 files changed, 65 insertions(+), 19 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 35eebc2310a5..4d975ab27078 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3073,7 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
  */
 static inline void __skb_frag_ref(skb_frag_t *frag)
 {
-	get_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+#ifdef CONFIG_PAGE_POOL
+	if (page_pool_is_pp_page(page)) {
+		page_pool_atomic_inc_frag_count(page);
+		return;
+	}
+#endif
+
+	get_page(page);
 }
 
 /**
@@ -3088,6 +3097,22 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 	__skb_frag_ref(&skb_shinfo(skb)->frags[f]);
 }
 
+/**
+ * skb_frag_is_pp_page - decide if a page is recyclable.
+ * @page: frag page
+ * @recycle: skb->pp_recycle
+ *
+ * For 32 bit systems with 64 bit dma, the skb->pp_recycle is
+ * also used to decide if a page can be recycled to the page
+ * pool.
+ */
+static inline bool skb_frag_is_pp_page(struct page *page,
+				       bool recycle)
+{
+	return page_pool_is_pp_page(page) ||
+		(recycle && __page_pool_is_pp_page(page));
+}
+
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
@@ -3101,8 +3126,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 	struct page *page = skb_frag_page(frag);
 
 #ifdef CONFIG_PAGE_POOL
-	if (recycle && page_pool_return_skb_page(page))
+	if (skb_frag_is_pp_page(page, recycle)) {
+		page_pool_return_skb_page(page);
 		return;
+	}
 #endif
 	put_page(page);
 }
@@ -4720,9 +4747,14 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 
 static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
 {
-	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
+	struct page *page = virt_to_head_page(data);
+
+	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle ||
+	    !__page_pool_is_pp_page(page))
 		return false;
-	return page_pool_return_skb_page(virt_to_head_page(data));
+
+	page_pool_return_skb_page(page);
+	return true;
 }
 
 #endif	/* __KERNEL__ */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2ad0706566c5..eb103d86f453 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
-bool page_pool_return_skb_page(struct page *page);
+void page_pool_return_skb_page(struct page *page);
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
@@ -244,6 +244,32 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
 	atomic_long_set(&page->pp_frag_count, nr);
 }
 
+static inline void page_pool_atomic_inc_frag_count(struct page *page)
+{
+	atomic_long_inc(&page->pp_frag_count);
+}
+
+static inline bool __page_pool_is_pp_page(struct page *page)
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
+static inline bool page_pool_is_pp_page(struct page *page)
+{
+	/* For systems with the same dma addr as the bus addr, we can use
+	 * page->pp_magic to indicate a pp page uniquely.
+	 */
+	return !PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
+			__page_pool_is_pp_page(page);
+}
+
 static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
 							  long nr)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 09d7b8614ef5..3a419871d4bc 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -24,7 +24,7 @@
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
-#define BIAS_MAX	LONG_MAX
+#define BIAS_MAX	(LONG_MAX / 2)
 
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
@@ -736,20 +736,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 }
 EXPORT_SYMBOL(page_pool_update_nid);
 
-bool page_pool_return_skb_page(struct page *page)
+void page_pool_return_skb_page(struct page *page)
 {
 	struct page_pool *pp;
 
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
@@ -758,7 +748,5 @@ bool page_pool_return_skb_page(struct page *page)
 	 * 'flipped' fragment being in use or not.
 	 */
 	page_pool_put_full_page(pp, page, false);
-
-	return true;
 }
 EXPORT_SYMBOL(page_pool_return_skb_page);
-- 
2.33.0

