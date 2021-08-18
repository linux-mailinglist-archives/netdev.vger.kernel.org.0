Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51463EF8AD
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbhHRDeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8873 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhHRDeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:23 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GqD0n1Tyjz8sZd;
        Wed, 18 Aug 2021 11:29:45 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:27 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:27 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
Subject: [PATCH RFC 2/7] skbuff: add interface to manipulate frag count for tx recycling
Date:   Wed, 18 Aug 2021 11:32:18 +0800
Message-ID: <1629257542-36145-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

As the case of tcp, there may be fragmenting, coalescing or
retransmiting case that might lose the track if a frag page
is from page pool or not.

So increment the frag count when __skb_frag_ref() is called,
and use the bit 0 in frag->bv_page to indicate if a page is
from a page pool, which automically pass down to another
frag->bv_page when doing a '*new_frag = *frag' or memcpying
the shinfo.

It seems we could do the trick for rx too if it makes sense.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/skbuff.h  | 43 ++++++++++++++++++++++++++++++++++++++++---
 include/net/page_pool.h |  5 +++++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6bdb0db..2878d26 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -331,6 +331,11 @@ static inline unsigned int skb_frag_size(const skb_frag_t *frag)
 	return frag->bv_len;
 }
 
+static inline bool skb_frag_is_pp(const skb_frag_t *frag)
+{
+	return (unsigned long)frag->bv_page & 1UL;
+}
+
 /**
  * skb_frag_size_set() - Sets the size of a skb fragment
  * @frag: skb fragment
@@ -2190,6 +2195,21 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 		skb->pfmemalloc	= true;
 }
 
+static inline void __skb_fill_pp_page_desc(struct sk_buff *skb, int i,
+					   struct page *page, int off,
+					   int size)
+{
+	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+	frag->bv_page = (struct page *)((unsigned long)page | 0x1UL);
+	frag->bv_offset = off;
+	skb_frag_size_set(frag, size);
+
+	page = compound_head(page);
+	if (page_is_pfmemalloc(page))
+		skb->pfmemalloc = true;
+}
+
 /**
  * skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
@@ -2211,6 +2231,14 @@ static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
 	skb_shinfo(skb)->nr_frags = i + 1;
 }
 
+static inline void skb_fill_pp_page_desc(struct sk_buff *skb, int i,
+					 struct page *page, int off,
+					 int size)
+{
+	__skb_fill_pp_page_desc(skb, i, page, off, size);
+	skb_shinfo(skb)->nr_frags = i + 1;
+}
+
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		     int size, unsigned int truesize);
 
@@ -3062,7 +3090,10 @@ static inline void skb_frag_off_copy(skb_frag_t *fragto,
  */
 static inline struct page *skb_frag_page(const skb_frag_t *frag)
 {
-	return frag->bv_page;
+	unsigned long page = (unsigned long)frag->bv_page;
+
+	page &= ~1UL;
+	return (struct page *)page;
 }
 
 /**
@@ -3073,7 +3104,12 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
  */
 static inline void __skb_frag_ref(skb_frag_t *frag)
 {
-	get_page(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+
+	if (skb_frag_is_pp(frag))
+		page_pool_atomic_inc_frag_count(page);
+	else
+		get_page(page);
 }
 
 /**
@@ -3101,7 +3137,8 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 	struct page *page = skb_frag_page(frag);
 
 #ifdef CONFIG_PAGE_POOL
-	if (recycle && page_pool_return_skb_page(page))
+	if ((recycle || skb_frag_is_pp(frag)) &&
+	    page_pool_return_skb_page(page))
 		return;
 #endif
 	put_page(page);
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8d4ae4b..86babb2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -270,6 +270,11 @@ static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
 	return ret;
 }
 
+static void page_pool_atomic_inc_frag_count(struct page *page)
+{
+	atomic_long_inc(&page->pp_frag_count);
+}
+
 static inline bool is_page_pool_compiled_in(void)
 {
 #ifdef CONFIG_PAGE_POOL
-- 
2.7.4

