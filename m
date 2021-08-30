Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC2D3FAF81
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 03:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhH3BUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 21:20:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9381 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236163AbhH3BUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 21:20:19 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GyXRz5x0gz8wBw;
        Mon, 30 Aug 2021 09:15:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 09:19:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 30 Aug 2021 09:19:24 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 2/2] skbuff: keep track of pp page when __skb_frag_ref() is called
Date:   Mon, 30 Aug 2021 09:18:10 +0800
Message-ID: <1630286290-43714-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

So increment the frag count when __skb_frag_ref() is called,
and only use page->pp_magic to indicate if a frag page is from
page pool, to avoid the above data race.

For 32 bit systems with 64 bit dma, we preserve the orginial
behavior as frag count is used to trace how many time does a
frag page is called with __skb_frag_ref().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h  | 13 ++++++++++++-
 include/net/page_pool.h | 17 +++++++++++++++++
 net/core/page_pool.c    | 12 ++----------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6bdb0db..8311482 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3073,6 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
  */
 static inline void __skb_frag_ref(skb_frag_t *frag)
 {
+	struct page *page = skb_frag_page(frag);
+
+#ifdef CONFIG_PAGE_POOL
+	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
+	    page_pool_is_pp_page(page)) {
+		page_pool_atomic_inc_frag_count(page);
+		return;
+	}
+#endif
+
 	get_page(skb_frag_page(frag));
 }
 
@@ -3101,7 +3111,8 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 	struct page *page = skb_frag_page(frag);
 
 #ifdef CONFIG_PAGE_POOL
-	if (recycle && page_pool_return_skb_page(page))
+	if ((!PAGE_POOL_DMA_USE_PP_FRAG_COUNT || recycle) &&
+	    page_pool_return_skb_page(page))
 		return;
 #endif
 	put_page(page);
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2ad0706..8b43e3d9 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -244,6 +244,23 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
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
index ba9f14d..442d37b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -24,7 +24,7 @@
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
-#define BIAS_MAX	LONG_MAX
+#define BIAS_MAX	(LONG_MAX / 2)
 
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
@@ -741,15 +741,7 @@ bool page_pool_return_skb_page(struct page *page)
 	struct page_pool *pp;
 
 	page = compound_head(page);
-
-	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
-	 * in order to preserve any existing bits, such as bit 0 for the
-	 * head page of compound page and bit 1 for pfmemalloc page, so
-	 * mask those bits for freeing side when doing below checking,
-	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
-	 * to avoid recycling the pfmemalloc page.
-	 */
-	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
+	if (!page_pool_is_pp_page(page))
 		return false;
 
 	pp = page->pp;
-- 
2.7.4

