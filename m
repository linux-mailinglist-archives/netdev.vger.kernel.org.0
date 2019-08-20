Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433AE957F9
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 09:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfHTHMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 03:12:55 -0400
Received: from verein.lst.de ([213.95.11.211]:54234 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbfHTHMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 03:12:55 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F09A68B02; Tue, 20 Aug 2019 09:12:50 +0200 (CEST)
Date:   Tue, 20 Aug 2019 09:12:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        Nicolin Chen <nicoleotsuka@gmail.com>, kvalo@codeaurora.org,
        davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        tobias.klausmann@freenet.de
Subject: Re: regression in ath10k dma allocation
Message-ID: <20190820071250.GA28968@lst.de>
References: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de> <20190816164301.GA3629@lst.de> <af96ea6a-2b17-9b66-7aba-b7dae5bcbba5@mni.thm.de> <20190816222506.GA24413@Asurada-Nvidia.nvidia.com> <20190818031328.11848-1-hdanton@sina.com> <acd7a4b0-fde8-1aa2-af07-2b469e5d5ca7@mni.thm.de> <20190820065833.1628-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820065833.1628-1-hdanton@sina.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 02:58:33PM +0800, Hillf Danton wrote:
> 
> On Tue, 20 Aug 2019 05:05:14 +0200 Christoph Hellwig wrote:
> > 
> > Tobias, plase try this patch:
> > 

New version below:

---
From b8a805e93be5a5662323b8ac61fe686df839c4ac Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Aug 2019 11:45:49 +0900
Subject: dma-direct: fix zone selection after an unaddressable CMA allocation

The new dma_alloc_contiguous hides if we allocate CMA or regular
pages, and thus fails to retry a ZONE_NORMAL allocation if the CMA
allocation succeeds but isn't addressable.  That means we either fail
outright or dip into a small zone that might not succeed either.

Thanks to Hillf Danton for debugging this issue.

Fixes: b1d2dc009dec ("dma-contiguous: add dma_{alloc,free}_contiguous() helpers")
Reported-by: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/dma-iommu.c      |  3 +++
 include/linux/dma-contiguous.h |  5 +----
 kernel/dma/contiguous.c        |  9 +++------
 kernel/dma/direct.c            | 10 +++++++++-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index d991d40f797f..f68a62c3c32b 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -965,10 +965,13 @@ static void *iommu_dma_alloc_pages(struct device *dev, size_t size,
 {
 	bool coherent = dev_is_dma_coherent(dev);
 	size_t alloc_size = PAGE_ALIGN(size);
+	int node = dev_to_node(dev);
 	struct page *page = NULL;
 	void *cpu_addr;
 
 	page = dma_alloc_contiguous(dev, alloc_size, gfp);
+	if (!page)
+		page = alloc_pages_node(node, gfp, get_order(alloc_size));
 	if (!page)
 		return NULL;
 
diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
index c05d4e661489..03f8e98e3bcc 100644
--- a/include/linux/dma-contiguous.h
+++ b/include/linux/dma-contiguous.h
@@ -160,10 +160,7 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
 		gfp_t gfp)
 {
-	int node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
-	size_t align = get_order(PAGE_ALIGN(size));
-
-	return alloc_pages_node(node, gfp, align);
+	return NULL;
 }
 
 static inline void dma_free_contiguous(struct device *dev, struct page *page,
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 2bd410f934b3..e6b450fdbeb6 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -230,9 +230,7 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
  */
 struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 {
-	int node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
-	size_t count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	size_t align = get_order(PAGE_ALIGN(size));
+	size_t count = size >> PAGE_SHIFT;
 	struct page *page = NULL;
 	struct cma *cma = NULL;
 
@@ -243,14 +241,12 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 
 	/* CMA can be used only in the context which permits sleeping */
 	if (cma && gfpflags_allow_blocking(gfp)) {
+		size_t align = get_order(size);
 		size_t cma_align = min_t(size_t, align, CONFIG_CMA_ALIGNMENT);
 
 		page = cma_alloc(cma, count, cma_align, gfp & __GFP_NOWARN);
 	}
 
-	/* Fallback allocation of normal pages */
-	if (!page)
-		page = alloc_pages_node(node, gfp, align);
 	return page;
 }
 
@@ -258,6 +254,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
  * dma_free_contiguous() - release allocated pages
  * @dev:   Pointer to device for which the pages were allocated.
  * @page:  Pointer to the allocated pages.
+	int node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
  * @size:  Size of allocated pages.
  *
  * This function releases memory allocated by dma_alloc_contiguous(). As the
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 795c9b095d75..706113c6bebc 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -85,6 +85,8 @@ static bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
+	size_t alloc_size = PAGE_ALIGN(size);
+	int node = dev_to_node(dev);
 	struct page *page = NULL;
 	u64 phys_mask;
 
@@ -95,8 +97,14 @@ struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	gfp &= ~__GFP_ZERO;
 	gfp |= __dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
 			&phys_mask);
+	page = dma_alloc_contiguous(dev, alloc_size, gfp);
+	if (page && !dma_coherent_ok(dev, page_to_phys(page), size)) {
+		dma_free_contiguous(dev, page, alloc_size);
+		page = NULL;
+	}
 again:
-	page = dma_alloc_contiguous(dev, size, gfp);
+	if (!page)
+		page = alloc_pages_node(node, gfp, get_order(alloc_size));
 	if (page && !dma_coherent_ok(dev, page_to_phys(page), size)) {
 		dma_free_contiguous(dev, page, size);
 		page = NULL;
-- 
2.20.1

