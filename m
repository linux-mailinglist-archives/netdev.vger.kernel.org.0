Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4CC3623E9
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbhDPP3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243009AbhDPP3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:29:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCF8C06175F;
        Fri, 16 Apr 2021 08:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1toLz+6Q9HQNcw3MQRhWkEtoAVrOWnWFJOtvRcLCOTo=; b=AfDcl5h/43wjmPGPvOHoHHxUtH
        VUrHqD3LImr52YJgVp8v99CpXw49O+3ABZxg5dh2xjPUhMw9cBqhZ/eHIxjqVBmWAJ5j2VFJliPqP
        BQOm1fzjrGaws2wsSyby1unfkL+/Wxc1aXKKpQCeRlWZhNlLgNueCFlXNMIQiSGoqCfvjgZ9Is6GB
        hFY2A2C7bLXBzhULxoFqzdLwiH6FLDnAub0LrzdQzZam5myqe1duHZgtATotK/lfgrQQkIZGYhNry
        QenDpI12d1AnF7t8sVRmpZ4hU7p/p1rPmDOPveX4AC6sl4F0D+bQ9ZY+9PGK+tPLJDf+e8Y0+WANo
        iep2axvg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXQNv-00A7Ug-LK; Fri, 16 Apr 2021 15:28:22 +0000
Date:   Fri, 16 Apr 2021 16:27:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210416152755.GL2531743@casper.infradead.org>
References: <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415200832.32796445@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> See below patch.  Where I swap32 the dma address to satisfy
> page->compound having bit zero cleared. (It is the simplest fix I could
> come up with).

I think this is slightly simpler, and as a bonus code that assumes the
old layout won't compile.

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
index b5b195305346..db7c7020746a 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -198,7 +198,17 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	return page->dma_addr;
+	dma_addr_t ret = page->dma_addr[0];
+	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+		ret |= (dma_addr_t)page->dma_addr[1] << 32;
+	return ret;
+}
+
+static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+{
+	page->dma_addr[0] = addr;
+	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+		page->dma_addr[1] = addr >> 32;
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
