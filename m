Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09670414572
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhIVJo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:44:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9754 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbhIVJol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:44:41 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HDtc769tWzWMxn;
        Wed, 22 Sep 2021 17:41:59 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:02 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 5/7] skbuff: keep track of pp page when __skb_frag_ref() is called
Date:   Wed, 22 Sep 2021 17:41:29 +0800
Message-ID: <20210922094131.15625-6-linyunsheng@huawei.com>
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

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ethernet/marvell/sky2.c        |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |  2 +-
 include/linux/skbuff.h                     | 30 +++++++++++++++++-----
 include/net/page_pool.h                    | 19 +++++++++++++-
 net/core/page_pool.c                       | 14 +---------
 net/core/skbuff.c                          |  4 +--
 net/tls/tls_device.c                       |  2 +-
 7 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e9fc74e54b22..91b62f468a26 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2503,7 +2503,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__skb_frag_unref(frag, false);
+			__skb_frag_unref(frag);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 7f6d3b82c29b..ce31b1fd554f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -526,7 +526,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_priv *priv,
 fail:
 	while (nr > 0) {
 		nr--;
-		__skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
+		__skb_frag_unref(skb_shinfo(skb)->frags + nr);
 	}
 	return 0;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 35eebc2310a5..a2d3b6fe0c32 100644
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
@@ -3091,18 +3100,19 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
- * @recycle: recycle the page if allocated via page_pool
  *
  * Releases a reference on the paged fragment @frag
  * or recycles the page via the page_pool API.
  */
-static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
+static inline void __skb_frag_unref(skb_frag_t *frag)
 {
 	struct page *page = skb_frag_page(frag);
 
 #ifdef CONFIG_PAGE_POOL
-	if (recycle && page_pool_return_skb_page(page))
+	if (page_pool_is_pp_page(page)) {
+		page_pool_return_skb_page(page);
 		return;
+	}
 #endif
 	put_page(page);
 }
@@ -3116,7 +3126,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f]);
 }
 
 /**
@@ -4720,9 +4730,17 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
 
 static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
 {
+	struct page *page;
+
 	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
 		return false;
-	return page_pool_return_skb_page(virt_to_head_page(data));
+
+	page = virt_to_head_page(data);
+	if (!page_pool_is_pp_page(page))
+		return false;
+
+	page_pool_return_skb_page(page);
+	return true;
 }
 
 #endif	/* __KERNEL__ */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3855f069627f..f9738da37d9f 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
-bool page_pool_return_skb_page(struct page *page);
+void page_pool_return_skb_page(struct page *page);
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
@@ -231,6 +231,23 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
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
 static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
 							  long nr)
 {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e9516477f9d2..96a28accce0e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -738,20 +738,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
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
@@ -760,7 +750,5 @@ bool page_pool_return_skb_page(struct page *page)
 	 * 'flipped' fragment being in use or not.
 	 */
 	page_pool_put_full_page(pp, page, false);
-
-	return true;
 }
 EXPORT_SYMBOL(page_pool_return_skb_page);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2170bea2c7de..db8af3eff255 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -668,7 +668,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+		__skb_frag_unref(&shinfo->frags[i]);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -3563,7 +3563,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom, skb->pp_recycle);
+		__skb_frag_unref(fragfrom);
 	}
 
 	/* Reposition in the original skb */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b932469ee69c..bd9f1567aa39 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -128,7 +128,7 @@ static void destroy_record(struct tls_record_info *record)
 	int i;
 
 	for (i = 0; i < record->num_frags; i++)
-		__skb_frag_unref(&record->frags[i], false);
+		__skb_frag_unref(&record->frags[i]);
 	kfree(record);
 }
 
-- 
2.33.0

