Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D513E2115
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240831AbhHFBk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:40:26 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13284 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhHFBkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 21:40:24 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ggp293gK2z83FW;
        Fri,  6 Aug 2021 09:35:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 09:40:06 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 09:40:05 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <mcroce@microsoft.com>, <willy@infradead.org>,
        <alexander.duyck@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net V2] page_pool: mask the page->signature before the checking
Date:   Fri, 6 Aug 2021 09:39:07 +0800
Message-ID: <1628213947-39384-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in commit c07aea3ef4d4 ("mm: add a signature in
struct page"):
"The page->signature field is aliased to page->lru.next and
page->compound_head."

And as the comment in page_is_pfmemalloc():
"lru.next has bit 1 set if the page is allocated from the
pfmemalloc reserves. Callers may simply overwrite it if they
do not need to preserve that information."

The page->signature is OR’ed with PP_SIGNATURE when a page is
allocated in page pool, see __page_pool_alloc_pages_slow(),
and page->signature is checked directly with PP_SIGNATURE in
page_pool_return_skb_page(), which might cause resoure leaking
problem for a page from page pool if bit 1 of lru.next is set
for a pfmemalloc page. What happens here is that the original
pp->signature is OR'ed with PP_SIGNATURE after the allocation
in order to preserve any existing bits(such as the bit 1, used
to indicate a pfmemalloc page), so when those bits are present,
those page is not considered to be from page pool and the DMA
mapping of those pages will be left stale.

As bit 0 is for page->compound_head, So mask both bit 0/1 before
the checking in page_pool_return_skb_page(). And we will return
those pfmemalloc pages back to the page allocator after cleaning
up the DMA mapping.

Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V2: explain more on why we need to mask those bits.
---
 net/core/page_pool.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5e4eb45..8ab7b40 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -634,7 +634,15 @@ bool page_pool_return_skb_page(struct page *page)
 	struct page_pool *pp;
 
 	page = compound_head(page);
-	if (unlikely(page->pp_magic != PP_SIGNATURE))
+
+	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
+	 * in order to preserve any existing bits, such as bit 0 for the
+	 * head page of compound page and bit 1 for pfmemalloc page, so
+	 * mask those bits for freeing side when doing below checking,
+	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
+	 * to avoid recycling the pfmemalloc page.
+	 */
+	if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
 		return false;
 
 	pp = page->pp;
-- 
2.7.4

