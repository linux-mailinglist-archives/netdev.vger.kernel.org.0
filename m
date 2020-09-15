Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BB426B0EC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgIOWWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbgIOQ0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:26:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B082EC06174A;
        Tue, 15 Sep 2020 09:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Dg3QMDAfcEis/hsZmMpMP+Q9kpA1vlPk2AbV6jANyAg=; b=iNYURyeqwuLiQug7b7pn9v6SrP
        6Mfe/HxwjPL4z9ZVrY2NRfqQHJCx+DBLStBAJwrGGPffpg1ZeUI7oMf/d8WajMpC4yp1/JRfgcXXp
        fZ84ymIpaUrL2VMQ56gGUMCYUvreHd221mwxqNX9T0TEPVLyTSNrk5JbOgk0lAuavkBOl9YZbUFPB
        ammfzXjV8C8c8yFwa9ayAFrWf8EmpX6Y88nmXtHR4fXebg46J570KYWMdRFPF0kfKvcODsMopX+uf
        8GL4/wQyfkAYtxVjTU9BoZb06SCavAzbLH/PURXuYzB9UehmOlgSsPaY++NQGBlsutTqXkivuu/xR
        hy7AgQHg==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDmg-0005k5-1X; Tue, 15 Sep 2020 16:26:22 +0000
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
Subject: [PATCH 15/18] dma-mapping: add a new dma_alloc_pages API
Date:   Tue, 15 Sep 2020 17:51:19 +0200
Message-Id: <20200915155122.1768241-16-hch@lst.de>
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

This API is the equivalent of alloc_pages, except that the returned memory
is guaranteed to be DMA addressable by the passed in device.  The
implementation will also be used to provide a more sensible replacement
for DMA_ATTR_NON_CONSISTENT flag.

Additionally dma_alloc_noncoherent is switched over to use dma_alloc_pages
as its backend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/core-api/dma-attributes.rst |  8 ---
 arch/alpha/kernel/pci_iommu.c             |  2 +
 arch/arm/mm/dma-mapping-nommu.c           |  2 +
 arch/arm/mm/dma-mapping.c                 |  4 ++
 arch/ia64/hp/common/sba_iommu.c           |  2 +
 arch/mips/jazz/jazzdma.c                  |  7 +--
 arch/powerpc/kernel/dma-iommu.c           |  2 +
 arch/powerpc/platforms/ps3/system-bus.c   |  4 ++
 arch/powerpc/platforms/pseries/vio.c      |  2 +
 arch/s390/pci/pci_dma.c                   |  2 +
 arch/x86/kernel/amd_gart_64.c             |  2 +
 drivers/iommu/dma-iommu.c                 |  2 +
 drivers/iommu/intel/iommu.c               |  4 ++
 drivers/parisc/ccio-dma.c                 |  2 +
 drivers/parisc/sba_iommu.c                |  2 +
 drivers/xen/swiotlb-xen.c                 |  2 +
 include/linux/dma-direct.h                |  5 ++
 include/linux/dma-mapping.h               | 34 ++++++------
 include/linux/dma-noncoherent.h           |  3 --
 kernel/dma/direct.c                       | 52 ++++++++++++++++++-
 kernel/dma/mapping.c                      | 63 +++++++++++++++++++++--
 kernel/dma/ops_helpers.c                  | 35 +++++++++++++
 kernel/dma/virt.c                         |  2 +
 23 files changed, 206 insertions(+), 37 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 29dcbe8826e85e..1887d92e8e9269 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -25,14 +25,6 @@ Since it is optional for platforms to implement DMA_ATTR_WRITE_COMBINE,
 those that do not will simply ignore the attribute and exhibit default
 behavior.
 
-DMA_ATTR_NON_CONSISTENT
------------------------
-
-DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
-consistent or non-consistent memory as it sees fit.  By using this API,
-you are guaranteeing to the platform that you have all the correct and
-necessary sync points for this memory in the driver.
-
 DMA_ATTR_NO_KERNEL_MAPPING
 --------------------------
 
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 6f7de4f4e191e7..447e0fd0ed3895 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -952,5 +952,7 @@ const struct dma_map_ops alpha_pci_ops = {
 	.dma_supported		= alpha_pci_supported,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(alpha_pci_ops);
diff --git a/arch/arm/mm/dma-mapping-nommu.c b/arch/arm/mm/dma-mapping-nommu.c
index 287ef898a55e11..43c6d66b6e733a 100644
--- a/arch/arm/mm/dma-mapping-nommu.c
+++ b/arch/arm/mm/dma-mapping-nommu.c
@@ -176,6 +176,8 @@ static void arm_nommu_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist
 const struct dma_map_ops arm_nommu_dma_ops = {
 	.alloc			= arm_nommu_dma_alloc,
 	.free			= arm_nommu_dma_free,
+	.alloc_pages		= dma_direct_alloc_pages,
+	.free_pages		= dma_direct_free_pages,
 	.mmap			= arm_nommu_dma_mmap,
 	.map_page		= arm_nommu_dma_map_page,
 	.unmap_page		= arm_nommu_dma_unmap_page,
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 8a8949174b1c06..7738b4d23f692f 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -199,6 +199,8 @@ static int arm_dma_supported(struct device *dev, u64 mask)
 const struct dma_map_ops arm_dma_ops = {
 	.alloc			= arm_dma_alloc,
 	.free			= arm_dma_free,
+	.alloc_pages		= dma_direct_alloc_pages,
+	.free_pages		= dma_direct_free_pages,
 	.mmap			= arm_dma_mmap,
 	.get_sgtable		= arm_dma_get_sgtable,
 	.map_page		= arm_dma_map_page,
@@ -226,6 +228,8 @@ static int arm_coherent_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 const struct dma_map_ops arm_coherent_dma_ops = {
 	.alloc			= arm_coherent_dma_alloc,
 	.free			= arm_coherent_dma_free,
+	.alloc_pages		= dma_direct_alloc_pages,
+	.free_pages		= dma_direct_free_pages,
 	.mmap			= arm_coherent_dma_mmap,
 	.get_sgtable		= arm_dma_get_sgtable,
 	.map_page		= arm_coherent_dma_map_page,
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index b49b73a95067d2..cafbb848a34e4d 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2070,6 +2070,8 @@ static const struct dma_map_ops sba_dma_ops = {
 	.dma_supported		= sba_dma_supported,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 };
 
 static int __init
diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index 2bf849caf507b1..f53bc043334c01 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -506,9 +506,6 @@ static void *jazz_dma_alloc(struct device *dev, size_t size,
 	*dma_handle = vdma_alloc(virt_to_phys(ret), size);
 	if (*dma_handle == DMA_MAPPING_ERROR)
 		goto out_free_pages;
-
-	if (attrs & DMA_ATTR_NON_CONSISTENT)
-		return ret;
 	arch_dma_prep_coherent(page, size);
 	return (void *)(UNCAC_BASE + __pa(ret));
 
@@ -521,8 +518,6 @@ static void jazz_dma_free(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle, unsigned long attrs)
 {
 	vdma_free(dma_handle);
-	if (!(attrs & DMA_ATTR_NON_CONSISTENT))
-		vaddr = __va(vaddr - UNCAC_BASE);
 	__free_pages(virt_to_page(vaddr), get_order(size));
 }
 
@@ -622,5 +617,7 @@ const struct dma_map_ops jazz_dma_ops = {
 	.sync_sg_for_device	= jazz_dma_sync_sg_for_device,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(jazz_dma_ops);
diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 569fecd7b5b234..d4e702d74b3393 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -137,4 +137,6 @@ const struct dma_map_ops dma_iommu_ops = {
 	.get_required_mask	= dma_iommu_get_required_mask,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 };
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 3542b7bd6a4689..7bc5f9be3e12d8 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -696,6 +696,8 @@ static const struct dma_map_ops ps3_sb_dma_ops = {
 	.unmap_page = ps3_unmap_page,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
+	.alloc_pages = dma_common_alloc_pages,
+	.free_pages = dma_common_free_pages,
 };
 
 static const struct dma_map_ops ps3_ioc0_dma_ops = {
@@ -708,6 +710,8 @@ static const struct dma_map_ops ps3_ioc0_dma_ops = {
 	.unmap_page = ps3_unmap_page,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
+	.alloc_pages = dma_common_alloc_pages,
+	.free_pages = dma_common_free_pages,
 };
 
 /**
diff --git a/arch/powerpc/platforms/pseries/vio.c b/arch/powerpc/platforms/pseries/vio.c
index 0487b26f6f1af3..98ed7b09b3fe50 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -608,6 +608,8 @@ static const struct dma_map_ops vio_dma_mapping_ops = {
 	.get_required_mask = dma_iommu_get_required_mask,
 	.mmap		   = dma_common_mmap,
 	.get_sgtable	   = dma_common_get_sgtable,
+	.alloc_pages	   = dma_common_alloc_pages,
+	.free_pages	   = dma_common_free_pages,
 };
 
 /**
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 4a37d8f4de9d9d..9291023e9469c2 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -668,6 +668,8 @@ const struct dma_map_ops s390_pci_dma_ops = {
 	.unmap_page	= s390_dma_unmap_pages,
 	.mmap		= dma_common_mmap,
 	.get_sgtable	= dma_common_get_sgtable,
+	.alloc_pages	= dma_common_alloc_pages,
+	.free_pages	= dma_common_free_pages,
 	/* dma_supported is unconditionally true without a callback */
 };
 EXPORT_SYMBOL_GPL(s390_pci_dma_ops);
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 153374b996a279..c96dcaa572ebd3 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -677,6 +677,8 @@ static const struct dma_map_ops gart_dma_ops = {
 	.get_sgtable			= dma_common_get_sgtable,
 	.dma_supported			= dma_direct_supported,
 	.get_required_mask		= dma_direct_get_required_mask,
+	.alloc_pages			= dma_direct_alloc_pages,
+	.free_pages			= dma_direct_free_pages,
 };
 
 static void gart_iommu_shutdown(void)
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 5141d49a046baa..00a5b49248e334 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1120,6 +1120,8 @@ static unsigned long iommu_dma_get_merge_boundary(struct device *dev)
 static const struct dma_map_ops iommu_dma_ops = {
 	.alloc			= iommu_dma_alloc,
 	.free			= iommu_dma_free,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 	.mmap			= iommu_dma_mmap,
 	.get_sgtable		= iommu_dma_get_sgtable,
 	.map_page		= iommu_dma_map_page,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7983c13b9eef7d..26eb7aafa0bda6 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3669,6 +3669,8 @@ static const struct dma_map_ops intel_dma_ops = {
 	.dma_supported = dma_direct_supported,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
+	.alloc_pages = dma_common_alloc_pages,
+	.free_pages = dma_common_free_pages,
 	.get_required_mask = intel_get_required_mask,
 };
 
@@ -3922,6 +3924,8 @@ static const struct dma_map_ops bounce_dma_ops = {
 	.sync_sg_for_device	= bounce_sync_sg_for_device,
 	.map_resource		= bounce_map_resource,
 	.unmap_resource		= bounce_unmap_resource,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 	.dma_supported		= dma_direct_supported,
 };
 
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index ba16b7f8f80612..8cf0b9c8bdf795 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1024,6 +1024,8 @@ static const struct dma_map_ops ccio_ops = {
 	.map_sg = 		ccio_map_sg,
 	.unmap_sg = 		ccio_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
+	.alloc_pages =		dma_common_alloc_pages,
+	.free_pages =		dma_common_free_pages,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 959bda193b9603..6fcde7980358ae 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1076,6 +1076,8 @@ static const struct dma_map_ops sba_ops = {
 	.map_sg =		sba_map_sg,
 	.unmap_sg =		sba_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
+	.alloc_pages =		dma_common_alloc_pages,
+	.free_pages =		dma_common_free_pages,
 };
 
 
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 39a0f2e0847c95..030a225624b060 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -578,4 +578,6 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.dma_supported = xen_swiotlb_dma_supported,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
+	.alloc_pages = dma_common_alloc_pages,
+	.free_pages = dma_common_free_pages,
 };
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 805010ea5346f9..c11bb935fc7fe3 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -77,6 +77,11 @@ void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
+struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
+void dma_direct_free_pages(struct device *dev, size_t size,
+		struct page *page, dma_addr_t dma_addr,
+		enum dma_data_direction dir);
 int dma_direct_get_sgtable(struct device *dev, struct sg_table *sgt,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 5b4e97b0846fd3..bf592cf0db4acb 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -27,11 +27,6 @@
  * buffered to improve performance.
  */
 #define DMA_ATTR_WRITE_COMBINE		(1UL << 2)
-/*
- * DMA_ATTR_NON_CONSISTENT: Lets the platform to choose to return either
- * consistent or non-consistent memory as it sees fit.
- */
-#define DMA_ATTR_NON_CONSISTENT		(1UL << 3)
 /*
  * DMA_ATTR_NO_KERNEL_MAPPING: Lets the platform to avoid creating a kernel
  * virtual mapping for the allocated buffer.
@@ -80,6 +75,11 @@ struct dma_map_ops {
 	void (*free)(struct device *dev, size_t size,
 			      void *vaddr, dma_addr_t dma_handle,
 			      unsigned long attrs);
+	struct page *(*alloc_pages)(struct device *dev, size_t size,
+			dma_addr_t *dma_handle, enum dma_data_direction dir,
+			gfp_t gfp);
+	void (*free_pages)(struct device *dev, size_t size, struct page *vaddr,
+			dma_addr_t dma_handle, enum dma_data_direction dir);
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			  void *, dma_addr_t, size_t,
 			  unsigned long attrs);
@@ -381,17 +381,14 @@ static inline unsigned long dma_get_merge_boundary(struct device *dev)
 }
 #endif /* CONFIG_HAS_DMA */
 
-static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
-{
-	return dma_alloc_attrs(dev, size, dma_handle, gfp,
-			DMA_ATTR_NON_CONSISTENT);
-}
-static inline void dma_free_noncoherent(struct device *dev, size_t size,
-		void *vaddr, dma_addr_t dma_handle, enum dma_data_direction dir)
-{
-	dma_free_attrs(dev, size, vaddr, dma_handle, DMA_ATTR_NON_CONSISTENT);
-}
+struct page *dma_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
+void dma_free_pages(struct device *dev, size_t size, struct page *page,
+		dma_addr_t dma_handle, enum dma_data_direction dir);
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir);
 
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
@@ -517,7 +514,10 @@ static inline void dma_sync_sgtable_for_device(struct device *dev,
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
-
+struct page *dma_common_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
+void dma_common_free_pages(struct device *dev, size_t size, struct page *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir);
 struct page **dma_common_find_pages(void *cpu_addr);
 void *dma_common_contiguous_remap(struct page *page, size_t size,
 			pgprot_t prot, const void *caller);
diff --git a/include/linux/dma-noncoherent.h b/include/linux/dma-noncoherent.h
index 0888656369a45b..e61283e06576a8 100644
--- a/include/linux/dma-noncoherent.h
+++ b/include/linux/dma-noncoherent.h
@@ -31,9 +31,6 @@ static __always_inline bool dma_alloc_need_uncached(struct device *dev,
 		return false;
 	if (attrs & DMA_ATTR_NO_KERNEL_MAPPING)
 		return false;
-	if (IS_ENABLED(CONFIG_DMA_NONCOHERENT_CACHE_SYNC) &&
-	    (attrs & DMA_ATTR_NON_CONSISTENT))
-		return false;
 	return true;
 }
 
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 54db9cfdaecc6d..9ba320383b0d19 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (C) 2018 Christoph Hellwig.
+ * Copyright (C) 2018-2020 Christoph Hellwig.
  *
  * DMA operations that map physical memory directly without using an IOMMU.
  */
@@ -287,6 +287,56 @@ void dma_direct_free(struct device *dev, size_t size,
 	dma_free_contiguous(dev, dma_direct_to_page(dev, dma_addr), size);
 }
 
+struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
+{
+	struct page *page;
+	void *ret;
+
+	if (dma_should_alloc_from_pool(dev, gfp, 0)) {
+		page = dma_alloc_from_pool(dev, size, &ret, gfp,
+				dma_coherent_ok);
+		if (!page)
+			return NULL;
+		goto done;
+	}
+
+	page = __dma_direct_alloc_pages(dev, size, gfp);
+	if (!page)
+		return NULL;
+	ret = page_address(page);
+	if (force_dma_unencrypted(dev)) {
+		if (set_memory_decrypted((unsigned long)ret,
+				1 << get_order(size)))
+			goto out_free_pages;
+	}
+	memset(ret, 0, size);
+done:
+	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page));
+	return page;
+out_free_pages:
+	dma_free_contiguous(dev, page, size);
+	return NULL;
+}
+
+void dma_direct_free_pages(struct device *dev, size_t size,
+		struct page *page, dma_addr_t dma_addr,
+		enum dma_data_direction dir)
+{
+	unsigned int page_order = get_order(size);
+	void *vaddr = page_address(page);
+
+	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
+	if (dma_should_free_from_pool(dev, 0) &&
+	    dma_free_from_pool(dev, vaddr, size))
+		return;
+
+	if (force_dma_unencrypted(dev))
+		set_memory_encrypted((unsigned long)vaddr, 1 << page_order);
+
+	dma_free_contiguous(dev, page, size);
+}
+
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_SWIOTLB)
 void dma_direct_sync_sg_for_device(struct device *dev,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index e71abcec8d3913..6f86c925b8251d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -330,9 +330,7 @@ pgprot_t dma_pgprot(struct device *dev, pgprot_t prot, unsigned long attrs)
 {
 	if (force_dma_unencrypted(dev))
 		prot = pgprot_decrypted(prot);
-	if (dev_is_dma_coherent(dev) ||
-	    (IS_ENABLED(CONFIG_DMA_NONCOHERENT_CACHE_SYNC) &&
-             (attrs & DMA_ATTR_NON_CONSISTENT)))
+	if (dev_is_dma_coherent(dev))
 		return prot;
 #ifdef CONFIG_ARCH_HAS_DMA_WRITE_COMBINE
 	if (attrs & DMA_ATTR_WRITE_COMBINE)
@@ -461,6 +459,65 @@ void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 }
 EXPORT_SYMBOL(dma_free_attrs);
 
+struct page *dma_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	struct page *page;
+
+	if (WARN_ON_ONCE(!dev->coherent_dma_mask))
+		return NULL;
+	if (WARN_ON_ONCE(gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)))
+		return NULL;
+
+	size = PAGE_ALIGN(size);
+	if (dma_alloc_direct(dev, ops))
+		page = dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
+	else if (ops->alloc_pages)
+		page = ops->alloc_pages(dev, size, dma_handle, dir, gfp);
+	else
+		return NULL;
+
+	debug_dma_map_page(dev, page, 0, size, dir, *dma_handle);
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(dma_alloc_pages);
+
+void dma_free_pages(struct device *dev, size_t size, struct page *page,
+		dma_addr_t dma_handle, enum dma_data_direction dir)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	size = PAGE_ALIGN(size);
+	debug_dma_unmap_page(dev, dma_handle, size, dir);
+
+	if (dma_alloc_direct(dev, ops))
+		dma_direct_free_pages(dev, size, page, dma_handle, dir);
+	else if (ops->free_pages)
+		ops->free_pages(dev, size, page, dma_handle, dir);
+}
+EXPORT_SYMBOL_GPL(dma_free_pages);
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
+{
+	struct page *page;
+
+	page = dma_alloc_pages(dev, size, dma_handle, dir, gfp);
+	if (!page)
+		return NULL;
+	return page_address(page);
+}
+EXPORT_SYMBOL_GPL(dma_alloc_noncoherent);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir)
+{
+	dma_free_pages(dev, size, virt_to_page(vaddr), dma_handle, dir);
+}
+EXPORT_SYMBOL_GPL(dma_free_noncoherent);
+
 int dma_supported(struct device *dev, u64 mask)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index e443c69be4299f..5828e5e01b7913 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -3,6 +3,7 @@
  * Helpers for DMA ops implementations.  These generally rely on the fact that
  * the allocated memory contains normal pages in the direct kernel mapping.
  */
+#include <linux/dma-contiguous.h>
 #include <linux/dma-noncoherent.h>
 
 /*
@@ -49,3 +50,37 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 	return -ENXIO;
 #endif /* CONFIG_MMU */
 }
+
+struct page *dma_common_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	struct page *page;
+
+	page = dma_alloc_contiguous(dev, size, gfp);
+	if (!page)
+		page = alloc_pages_node(dev_to_node(dev), gfp, get_order(size));
+	if (!page)
+		return NULL;
+
+	*dma_handle = ops->map_page(dev, page, 0, size, dir,
+				    DMA_ATTR_SKIP_CPU_SYNC);
+	if (*dma_handle == DMA_MAPPING_ERROR) {
+		dma_free_contiguous(dev, page, size);
+		return NULL;
+	}
+
+	memset(page_address(page), 0, size);
+	return page;
+}
+
+void dma_common_free_pages(struct device *dev, size_t size, struct page *page,
+		dma_addr_t dma_handle, enum dma_data_direction dir)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (ops->unmap_page)
+		ops->unmap_page(dev, dma_handle, size, dir,
+				DMA_ATTR_SKIP_CPU_SYNC);
+	dma_free_contiguous(dev, page, size);
+}
diff --git a/kernel/dma/virt.c b/kernel/dma/virt.c
index ebe128833af7b5..6986bf1fd6689c 100644
--- a/kernel/dma/virt.c
+++ b/kernel/dma/virt.c
@@ -55,5 +55,7 @@ const struct dma_map_ops dma_virt_ops = {
 	.free			= dma_virt_free,
 	.map_page		= dma_virt_map_page,
 	.map_sg			= dma_virt_map_sg,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(dma_virt_ops);
-- 
2.28.0

