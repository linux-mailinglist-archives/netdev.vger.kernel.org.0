Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED3362CF9
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 04:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbhDQCp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 22:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhDQCp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 22:45:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C2DC061574;
        Fri, 16 Apr 2021 19:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KKMtvHSgNW7S58z3axbykETvXWb5tpXd2Z8SNBiD9zQ=; b=LhLD1fhuCsV7BtQtcrHVH1gYQp
        9GEIraorVlZbmHPkWyahLQVQh9+m4uwCmjRsVwwEypQXIaIeH2PfCkTw2x8kctuuH1K0x3niwyFRh
        THPgoV7tEPovlE1DPEVdlAwS3fQCv1sCfy4IcHovruS3kJGDvVXPGSC33hp36EtGgNR1vcN3Fe+XA
        UlaxzgJbqTKWrf/1YcjyDSenlWRQxafaqjc9os09werOMuWY/bT1ASR6W/ItCco36dOhKyExdD91a
        KN3TLYyQTGe9ubc58nQIjYSIIRySiqQ3bNUhLYSt7NU9cRlSXcjTPp1L7+KTR2dKO1y7oDutz9DzE
        mMsf//0A==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXaxW-00AkpT-63; Sat, 17 Apr 2021 02:45:25 +0000
Date:   Sat, 17 Apr 2021 03:45:22 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     brouer@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        ilias.apalodimas@linaro.org, mcroce@linux.microsoft.com,
        grygorii.strashko@ti.com, arnd@kernel.org, hch@lst.de,
        linux-snps-arc@lists.infradead.org, mhocko@kernel.org,
        mgorman@suse.de
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210417024522.GP2531743@casper.infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416230724.2519198-2-willy@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Replacement patch to fix compiler warning.

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 16 Apr 2021 16:34:55 -0400
Subject: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
To: brouer@redhat.com
Cc: linux-kernel@vger.kernel.org,
    linux-mm@kvack.org,
    netdev@vger.kernel.org,
    linuxppc-dev@lists.ozlabs.org,
    linux-arm-kernel@lists.infradead.org,
    linux-mips@vger.kernel.org,
    ilias.apalodimas@linaro.org,
    mcroce@linux.microsoft.com,
    grygorii.strashko@ti.com,
    arnd@kernel.org,
    hch@lst.de,
    linux-snps-arc@lists.infradead.org,
    mhocko@kernel.org,
    mgorman@suse.de

32-bit architectures which expect 8-byte alignment for 8-byte integers
and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
page inadvertently expanded in 2019.  When the dma_addr_t was added,
it forced the alignment of the union to 8 bytes, which inserted a 4 byte
gap between 'flags' and the union.

Fix this by storing the dma_addr_t in one or two adjacent unsigned longs.
This restores the alignment to that of an unsigned long, and also fixes a
potential problem where (on a big endian platform), the bit used to denote
PageTail could inadvertently get set, and a racing get_user_pages_fast()
could dereference a bogus compound_head().

Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h |  4 ++--
 include/net/page_pool.h  | 12 +++++++++++-
 net/core/page_pool.c     | 12 +++++++-----
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6613b26a8894..5aacc1c10a45 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -97,10 +97,10 @@ struct page {
 		};
 		struct {	/* page_pool used by netstack */
 			/**
-			 * @dma_addr: might require a 64-bit value even on
+			 * @dma_addr: might require a 64-bit value on
 			 * 32-bit architectures.
 			 */
-			dma_addr_t dma_addr;
+			unsigned long dma_addr[2];
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b5b195305346..ad6154dc206c 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -198,7 +198,17 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	return page->dma_addr;
+	dma_addr_t ret = page->dma_addr[0];
+	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
+	return ret;
+}
+
+static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+{
+	page->dma_addr[0] = addr;
+	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+		page->dma_addr[1] = addr >> 16 >> 16;
 }
 
 static inline bool is_page_pool_compiled_in(void)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..f014fd8c19a6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -174,8 +174,10 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
 					  struct page *page,
 					  unsigned int dma_sync_size)
 {
+	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
+
 	dma_sync_size = min(dma_sync_size, pool->p.max_len);
-	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
+	dma_sync_single_range_for_device(pool->p.dev, dma_addr,
 					 pool->p.offset, dma_sync_size,
 					 pool->p.dma_dir);
 }
@@ -226,7 +228,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		put_page(page);
 		return NULL;
 	}
-	page->dma_addr = dma;
+	page_pool_set_dma_addr(page, dma);
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
@@ -294,13 +296,13 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 		 */
 		goto skip_dma_unmap;
 
-	dma = page->dma_addr;
+	dma = page_pool_get_dma_addr(page);
 
-	/* When page is unmapped, it cannot be returned our pool */
+	/* When page is unmapped, it cannot be returned to our pool */
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
-	page->dma_addr = 0;
+	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
-- 
2.30.2

