Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BE824956A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHSG4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgHSG4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:56:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA911C061389;
        Tue, 18 Aug 2020 23:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=AizzKTdergNVxrKhEOEhnPghjjTSMqeAtkqlKtBp/X0=; b=vH6bxrETaqMxdx4mGW1el0GaJ+
        NSVeG0+Sh1NWGRby+YHyglVGxyHksQXNJYqQqa9ssWp4C4h3A+SYPLZMdV23zRnCpgPJjJXWg/Lay
        3Ir0i12xQJQKx7lVNo97rQppxb+/aS4MuRXBMNs7gGALVE09O6cPX3LkEQjclkpmeIpQ/9EXrohw6
        a3zeu5THytGVk9DlrVgqJzLNHCGD7lD1uWGzwx0UVCF58MT7u8xcpVGUZDh4889T2ZMrTXNwMfMwr
        bxy2SfXAPCiFeopJuD84TIjMcyqgAV5sWCTNtUbG+Z7AAKkhx870HN70mDO5NY/psIClSv4j5Qpt6
        Qd6PhpeA==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I1E-0008Od-IN; Wed, 19 Aug 2020 06:56:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 12/28] dma-direct: remove dma_direct_{alloc,free}_pages
Date:   Wed, 19 Aug 2020 08:55:39 +0200
Message-Id: <20200819065555.1802761-13-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just merge these helpers into the main dma_direct_{alloc,free} routines,
as the additional checks are always false for the two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/kernel/amd_gart_64.c |  6 +++---
 include/linux/dma-direct.h    |  4 ----
 kernel/dma/direct.c           | 39 ++++++++++++++---------------------
 kernel/dma/pool.c             |  2 +-
 4 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index e89031e9c84761..adbf616d35d15d 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -468,7 +468,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 {
 	void *vaddr;
 
-	vaddr = dma_direct_alloc_pages(dev, size, dma_addr, flag, attrs);
+	vaddr = dma_direct_alloc(dev, size, dma_addr, flag, attrs);
 	if (!vaddr ||
 	    !force_iommu || dev->coherent_dma_mask <= DMA_BIT_MASK(24))
 		return vaddr;
@@ -480,7 +480,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 		goto out_free;
 	return vaddr;
 out_free:
-	dma_direct_free_pages(dev, size, vaddr, *dma_addr, attrs);
+	dma_direct_free(dev, size, vaddr, *dma_addr, attrs);
 	return NULL;
 }
 
@@ -490,7 +490,7 @@ gart_free_coherent(struct device *dev, size_t size, void *vaddr,
 		   dma_addr_t dma_addr, unsigned long attrs)
 {
 	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, 0);
-	dma_direct_free_pages(dev, size, vaddr, dma_addr, attrs);
+	dma_direct_free(dev, size, vaddr, dma_addr, attrs);
 }
 
 static int no_agp;
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 738485b3578062..6a96a8ecac7cbc 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -80,10 +80,6 @@ void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
-void *dma_direct_alloc_pages(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs);
-void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
-		dma_addr_t dma_addr, unsigned long attrs);
 int dma_direct_get_sgtable(struct device *dev, struct sg_table *sgt,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 1123e767f4315f..8da9a62dd9a72c 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -151,13 +151,18 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	return page;
 }
 
-void *dma_direct_alloc_pages(struct device *dev, size_t size,
+void *dma_direct_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	struct page *page;
 	void *ret;
 	int err;
 
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
+	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
+	    dma_alloc_need_uncached(dev, attrs))
+		return arch_dma_alloc(dev, size, dma_handle, gfp, attrs);
+
 	size = PAGE_ALIGN(size);
 
 	if (dma_should_alloc_from_pool(dev, gfp, attrs)) {
@@ -251,11 +256,18 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	return NULL;
 }
 
-void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
-		dma_addr_t dma_addr, unsigned long attrs)
+void dma_direct_free(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
 	unsigned int page_order = get_order(size);
 
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
+	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
+	    dma_alloc_need_uncached(dev, attrs)) {
+		arch_dma_free(dev, size, cpu_addr, dma_addr, attrs);
+		return;
+	}
+
 	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
 	if (dma_should_free_from_pool(dev, attrs) &&
 	    dma_free_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
@@ -279,27 +291,6 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 	dma_free_contiguous(dev, dma_direct_to_page(dev, dma_addr), size);
 }
 
-void *dma_direct_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
-{
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
-	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    dma_alloc_need_uncached(dev, attrs))
-		return arch_dma_alloc(dev, size, dma_handle, gfp, attrs);
-	return dma_direct_alloc_pages(dev, size, dma_handle, gfp, attrs);
-}
-
-void dma_direct_free(struct device *dev, size_t size,
-		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
-{
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
-	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    dma_alloc_need_uncached(dev, attrs))
-		arch_dma_free(dev, size, cpu_addr, dma_addr, attrs);
-	else
-		dma_direct_free_pages(dev, size, cpu_addr, dma_addr, attrs);
-}
-
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_SWIOTLB)
 void dma_direct_sync_sg_for_device(struct device *dev,
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 6bc74a2d51273e..222cebf1f10548 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -86,7 +86,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 #endif
 	/*
 	 * Memory in the atomic DMA pools must be unencrypted, the pools do not
-	 * shrink so no re-encryption occurs in dma_direct_free_pages().
+	 * shrink so no re-encryption occurs in dma_direct_free().
 	 */
 	ret = set_memory_decrypted((unsigned long)page_to_virt(page),
 				   1 << order);
-- 
2.28.0

