Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4126B0BF
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgIOWTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgIOQcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:32:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6002CC06174A;
        Tue, 15 Sep 2020 09:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Y4Zt5Q6wslvCqwY7SHiicX4jOFlI8lEV5uqNCn2aPDc=; b=BF8YbwryBXqc7mtPROjOHHMQzI
        aCOvb2dbe8fLen0MFlQ6bZdJO1rQP3g4d4dO9bC7wb3bPnpXsd//7pQm0XAe1CmnocDvI3mNw9x84
        DqMUZtD3QsVy3CT7VDTqkPTc3a5yO5/TZLXDAt220oVQgGJ5BfYy8yaS2AQg9qMpEcy+I3LkNY7il
        JzIkJb66RHJirHSLpWuLrzgjJYckHJ3vo00GUu01LuPsQths42SyDL/0HOTCDVBBkLabE6ifyxjAQ
        ojf3+iDcfdbfdvsdoVmpGVpJvbYCHk+tqW16FLi5PeV0QL06+xx8fYIueiaHF7UduNRuvBDsvbu9C
        G1h7Ntow==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDqu-00064n-5h; Tue, 15 Sep 2020 16:30:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 17/18] dma-iommu: implement ->alloc_noncoherent
Date:   Tue, 15 Sep 2020 17:51:21 +0200
Message-Id: <20200915155122.1768241-18-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915155122.1768241-1-hch@lst.de>
References: <20200915155122.1768241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the alloc_noncoherent method to provide memory that is neither
coherent not contiguous.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/iommu/dma-iommu.c | 41 +++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 00a5b49248e334..c12c1dc43d312e 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -572,6 +572,7 @@ static struct page **__iommu_dma_alloc_pages(struct device *dev,
  * @size: Size of buffer in bytes
  * @dma_handle: Out argument for allocated DMA handle
  * @gfp: Allocation flags
+ * @prot: pgprot_t to use for the remapped mapping
  * @attrs: DMA attributes for this allocation
  *
  * If @size is less than PAGE_SIZE, then a full CPU page will be allocated,
@@ -580,14 +581,14 @@ static struct page **__iommu_dma_alloc_pages(struct device *dev,
  * Return: Mapped virtual address, or NULL on failure.
  */
 static void *iommu_dma_alloc_remap(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, pgprot_t prot,
+		unsigned long attrs)
 {
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iova_domain *iovad = &cookie->iovad;
 	bool coherent = dev_is_dma_coherent(dev);
 	int ioprot = dma_info_to_prot(DMA_BIDIRECTIONAL, coherent, attrs);
-	pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
 	unsigned int count, min_size, alloc_sizes = domain->pgsize_bitmap;
 	struct page **pages;
 	struct sg_table sgt;
@@ -1030,8 +1031,10 @@ static void *iommu_dma_alloc(struct device *dev, size_t size,
 	gfp |= __GFP_ZERO;
 
 	if (IS_ENABLED(CONFIG_DMA_REMAP) && gfpflags_allow_blocking(gfp) &&
-	    !(attrs & DMA_ATTR_FORCE_CONTIGUOUS))
-		return iommu_dma_alloc_remap(dev, size, handle, gfp, attrs);
+	    !(attrs & DMA_ATTR_FORCE_CONTIGUOUS)) {
+		return iommu_dma_alloc_remap(dev, size, handle, gfp,
+				dma_pgprot(dev, PAGE_KERNEL, attrs), attrs);
+	}
 
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    !gfpflags_allow_blocking(gfp) && !coherent)
@@ -1052,6 +1055,34 @@ static void *iommu_dma_alloc(struct device *dev, size_t size,
 	return cpu_addr;
 }
 
+#ifdef CONFIG_DMA_REMAP
+static void *iommu_dma_alloc_noncoherent(struct device *dev, size_t size,
+		dma_addr_t *handle, enum dma_data_direction dir, gfp_t gfp)
+{
+	if (!gfpflags_allow_blocking(gfp)) {
+		struct page *page;
+
+		page = dma_common_alloc_pages(dev, size, handle, dir, gfp);
+		if (!page)
+			return NULL;
+		return page_address(page);
+	}
+
+	return iommu_dma_alloc_remap(dev, size, handle, gfp | __GFP_ZERO,
+				     PAGE_KERNEL, 0);
+}
+
+static void iommu_dma_free_noncoherent(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t handle, enum dma_data_direction dir)
+{
+	__iommu_dma_unmap(dev, handle, size);
+	__iommu_dma_free(dev, size, cpu_addr);
+}
+#else
+#define iommu_dma_alloc_noncoherent		NULL
+#define iommu_dma_free_noncoherent		NULL
+#endif /* CONFIG_DMA_REMAP */
+
 static int iommu_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs)
@@ -1122,6 +1153,8 @@ static const struct dma_map_ops iommu_dma_ops = {
 	.free			= iommu_dma_free,
 	.alloc_pages		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
+	.alloc_noncoherent	= iommu_dma_alloc_noncoherent,
+	.free_noncoherent	= iommu_dma_free_noncoherent,
 	.mmap			= iommu_dma_mmap,
 	.get_sgtable		= iommu_dma_get_sgtable,
 	.map_page		= iommu_dma_map_page,
-- 
2.28.0

