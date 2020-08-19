Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFAB2495F9
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgHSG7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgHSG5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:57:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91869C061344;
        Tue, 18 Aug 2020 23:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=UY0tckKGFIZZsE9dyPrKXHZNzvsyuAMAL1eBzPrnJ9k=; b=CBtpV0oglLLWQX4L/baQIACPIZ
        EsnCcpiKFeCKsqox1mITJlAtKLndAOjB/GXan091IqGRbVukda8wJnyGj+mmqMvCAY3Abrhbo+eL1
        aUhzHqa8rBfE/fYTsaH+TIKba0DYutLNU3qtjXOKYzhA66SFCY0BmXT5M4KzCo+mv5Z55GM0NWxtR
        yqgo4NFSy3JTvBcME8JsHHhHLtj9ie3AG9Go3yU6J2HwbP+HQm6KkUBwmpMGoGRDLSOl4XvPmPvH9
        Ka8U79gK9lSofPwA/uj/QeRGL0oIG9rptP0JVZQAxalJfaw0GnF5mWxo1dIitkK9o9W2GZiU2WnlA
        L/pz455A==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I1W-0008SH-Mv; Wed, 19 Aug 2020 06:56:40 +0000
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
Subject: [PATCH 19/28] dma-mapping: replace DMA_ATTR_NON_CONSISTENT with dma_{alloc,free}_pages
Date:   Wed, 19 Aug 2020 08:55:46 +0200
Message-Id: <20200819065555.1802761-20-hch@lst.de>
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

Add a new API to allocate and free pages that are guaranteed to be
addressable by a device, but otherwise behave like pages allocated by
alloc_pages.  The intended APIs to sync them for use with the device
and cpu are dma_sync_single_for_{device,cpu} that are also used for
streaming mappings.

Switch all drivers over to this new API, but keep the usage of the
crufty dma_cache_sync API for now, which will be cleaned up on a driver
by driver basis.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/core-api/dma-api.rst        | 68 +++++++++++------------
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
 drivers/net/ethernet/i825xx/lasi_82596.c  | 13 ++---
 drivers/net/ethernet/seeq/sgiseeq.c       | 12 ++--
 drivers/parisc/ccio-dma.c                 |  2 +
 drivers/parisc/sba_iommu.c                |  2 +
 drivers/scsi/53c700.c                     |  8 +--
 drivers/scsi/sgiwd93.c                    | 12 ++--
 drivers/xen/swiotlb-xen.c                 |  2 +
 include/linux/dma-direct.h                |  5 ++
 include/linux/dma-mapping.h               | 29 ++++++++--
 include/linux/dma-noncoherent.h           |  3 -
 kernel/dma/direct.c                       | 51 ++++++++++++++++-
 kernel/dma/mapping.c                      | 43 +++++++++++++-
 kernel/dma/ops_helpers.c                  | 35 ++++++++++++
 kernel/dma/virt.c                         |  2 +
 sound/mips/hal2.c                         | 20 +++----
 29 files changed, 254 insertions(+), 96 deletions(-)

diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
index 90239348b30f6f..047fcfffa0e5cf 100644
--- a/Documentation/core-api/dma-api.rst
+++ b/Documentation/core-api/dma-api.rst
@@ -516,48 +516,53 @@ routines, e.g.:::
 	}
 
 
-Part II - Advanced dma usage
-----------------------------
+Part II - Non-coherent DMA allocations
+--------------------------------------
 
-Warning: These pieces of the DMA API should not be used in the
-majority of cases, since they cater for unlikely corner cases that
-don't belong in usual drivers.
+These APIs allow to allocate pages that can be used like normal pages
+in the kernel direct mapping, but are guaranteed to be DMA addressable.
 
 If you don't understand how cache line coherency works between a
 processor and an I/O device, you should not be using this part of the
-API at all.
+API.
 
 ::
 
 	void *
-	dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
-			gfp_t flag, unsigned long attrs)
+	dma_alloc_pages(struct device *dev, size_t size, dma_addr_t *dma_handle,
+			enum dma_data_direction dir, gfp_t gfp)
+
+This routine allocates a region of <size> bytes of consistent memory.  It
+returns a pointer to the allocated region (in the processor's virtual address
+space) or NULL if the allocation failed. The returned memory is guanteed to
+behave like memory allocated using alloc_pages.
+
+It also returns a <dma_handle> which may be cast to an unsigned integer the
+same width as the bus and given to the device as the DMA address base of
+the region.
 
-Identical to dma_alloc_coherent() except that when the
-DMA_ATTR_NON_CONSISTENT flags is passed in the attrs argument, the
-platform will choose to return either consistent or non-consistent memory
-as it sees fit.  By using this API, you are guaranteeing to the platform
-that you have all the correct and necessary sync points for this memory
-in the driver should it choose to return non-consistent memory.
+The dir parameter specified if data is read and/or written by the device,
+see dma_map_single() for details.
 
-Note: where the platform can return consistent memory, it will
-guarantee that the sync points become nops.
+The gfp parameter allows the caller to specify the ``GFP_`` flags (see
+kmalloc()) for the allocation, but rejects flags used to specify a memory
+zone such as GFP_DMA or GFP_HIGHMEM.
 
-Warning:  Handling non-consistent memory is a real pain.  You should
-only use this API if you positively know your driver will be
-required to work on one of the rare (usually non-PCI) architectures
-that simply cannot make consistent memory.
+Before giving the memory to the device, dma_sync_single_for_device() needs
+to be called, and before reading memory written by the device,
+dma_sync_single_for_cpu(), just like for streaming DMA mappings that are
+reused.
 
 ::
 
 	void
-	dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
-		       dma_addr_t dma_handle, unsigned long attrs)
+	dma_free_pages(struct device *dev, size_t size, void *cpu_addr,
+			dma_addr_t dma_handle, enum dma_data_direction dir)
 
-Free memory allocated by the dma_alloc_attrs().  All common
-parameters must be identical to those otherwise passed to dma_free_coherent,
-and the attrs argument must be identical to the attrs passed to
-dma_alloc_attrs().
+Free a region of memory previously allocated using dma_alloc_pages().  dev,
+size and dma_handle and dir must all be the same as those passed into
+dma_alloc_pages().  cpu_addr must be the virtual address returned by
+the dma_alloc_pages().
 
 ::
 
@@ -575,17 +580,6 @@ memory or doing partial flushes.
 	into the width returned by this call.  It will also always be a power
 	of two for easy alignment.
 
-::
-
-	void
-	dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-		       enum dma_data_direction direction)
-
-Do a partial sync of memory that was allocated by dma_alloc_attrs() with
-the DMA_ATTR_NON_CONSISTENT flag starting at virtual address vaddr and
-continuing on for size.  Again, you *must* observe the cache line
-boundaries when doing this.
-
 
 Part III - Debug drivers use of the DMA-API
 -------------------------------------------
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
index 81037907268d5c..291121e3b5a583 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -957,5 +957,7 @@ const struct dma_map_ops alpha_pci_ops = {
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
index 656a4888c300b5..a51adc11a0b54b 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2071,6 +2071,8 @@ static const struct dma_map_ops sba_dma_ops = {
 	.dma_supported		= sba_dma_supported,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
+	.alloc_pages		= dma_common_alloc_pages,
+	.free_pages		= dma_common_free_pages,
 };
 
 static int __init
diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index d0b5a2ba2b1a8a..0f9a9cb7fe7a95 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -505,9 +505,6 @@ static void *jazz_dma_alloc(struct device *dev, size_t size,
 	*dma_handle = vdma_alloc(virt_to_phys(ret), size);
 	if (*dma_handle == DMA_MAPPING_ERROR)
 		goto out_free_pages;
-
-	if (attrs & DMA_ATTR_NON_CONSISTENT)
-		return ret;
 	arch_dma_prep_coherent(page, size);
 	return (void *)(UNCAC_BASE + __pa(ret));
 
@@ -520,8 +517,6 @@ static void jazz_dma_free(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle, unsigned long attrs)
 {
 	vdma_free(dma_handle);
-	if (!(attrs & DMA_ATTR_NON_CONSISTENT))
-		vaddr = __va(vaddr - UNCAC_BASE);
 	__free_pages(virt_to_page(vaddr), get_order(size));
 }
 
@@ -622,5 +617,7 @@ const struct dma_map_ops jazz_dma_ops = {
 	.cache_sync		= arch_dma_cache_sync,
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
index 64b1399a73f04d..44004f790bdc44 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -670,6 +670,8 @@ const struct dma_map_ops s390_pci_dma_ops = {
 	.unmap_page	= s390_dma_unmap_pages,
 	.mmap		= dma_common_mmap,
 	.get_sgtable	= dma_common_get_sgtable,
+	.alloc_pages	= dma_common_alloc_pages,
+	.free_pages	= dma_common_free_pages,
 	/* dma_supported is unconditionally true without a callback */
 };
 EXPORT_SYMBOL_GPL(s390_pci_dma_ops);
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index adbf616d35d15d..0310e6569350da 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -678,6 +678,8 @@ static const struct dma_map_ops gart_dma_ops = {
 	.get_sgtable			= dma_common_get_sgtable,
 	.dma_supported			= dma_direct_supported,
 	.get_required_mask		= dma_direct_get_required_mask,
+	.alloc_pages			= dma_direct_alloc_pages,
+	.free_pages			= dma_direct_free_pages,
 };
 
 static void gart_iommu_shutdown(void)
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 4959f5df21bd07..3da06df0f327c2 100644
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
index 99aa80456b7145..41fb349c1fd76b 100644
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
 
diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index 8c5ab9b7553e75..0c493b7237a910 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -184,9 +184,8 @@ lan_init_chip(struct parisc_device *dev)
 
 	lp = netdev_priv(netdevice);
 	lp->options = dev->id.sversion == 0x72 ? OPT_SWAP_PORT : 0;
-	lp->dma = dma_alloc_attrs(dev->dev.parent, sizeof(struct i596_dma),
-			      &lp->dma_addr, GFP_KERNEL,
-			      DMA_ATTR_NON_CONSISTENT);
+	lp->dma = dma_alloc_pages(dev->dev.parent, sizeof(struct i596_dma),
+				  &lp->dma_addr, DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!lp->dma)
 		goto out_free_netdev;
 
@@ -196,8 +195,8 @@ lan_init_chip(struct parisc_device *dev)
 	return 0;
 
 out_free_dma:
-	dma_free_attrs(dev->dev.parent, sizeof(struct i596_dma),
-		       lp->dma, lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(dev->dev.parent, sizeof(struct i596_dma),
+		       lp->dma, lp->dma_addr, DMA_BIDIRECTIONAL);
 out_free_netdev:
 	free_netdev(netdevice);
 	return retval;
@@ -209,8 +208,8 @@ static int __exit lan_remove_chip(struct parisc_device *pdev)
 	struct i596_private *lp = netdev_priv(dev);
 
 	unregister_netdev (dev);
-	dma_free_attrs(&pdev->dev, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(&pdev->dev, sizeof(struct i596_private), lp->dma,
+		       lp->dma_addr, DMA_BIDIRECTIONAL);
 	free_netdev (dev);
 	return 0;
 }
diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 8507ff2420143a..39599bbb5d45b6 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -740,8 +740,8 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */
-	sr = dma_alloc_attrs(&pdev->dev, sizeof(*sp->srings), &sp->srings_dma,
-			     GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	sr = dma_alloc_pages(&pdev->dev, sizeof(*sp->srings), &sp->srings_dma,
+			     DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!sr) {
 		printk(KERN_ERR "Sgiseeq: Page alloc failed, aborting.\n");
 		err = -ENOMEM;
@@ -802,8 +802,8 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_free_attrs:
-	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
-		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_BIDIRECTIONAL);
 err_out_free_dev:
 	free_netdev(dev);
 
@@ -817,8 +817,8 @@ static int sgiseeq_remove(struct platform_device *pdev)
 	struct sgiseeq_private *sp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
-		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_BIDIRECTIONAL);
 	free_netdev(dev);
 
 	return 0;
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index a5507f75b524c4..ae557e740781e3 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1025,6 +1025,8 @@ static const struct dma_map_ops ccio_ops = {
 	.map_sg = 		ccio_map_sg,
 	.unmap_sg = 		ccio_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
+	.alloc_pages =		dma_common_alloc_pages,
+	.free_pages =		dma_common_free_pages,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index d4314fba026914..d3514c5761a944 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1077,6 +1077,8 @@ static const struct dma_map_ops sba_ops = {
 	.map_sg =		sba_map_sg,
 	.unmap_sg =		sba_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
+	.alloc_pages =		dma_common_alloc_pages,
+	.free_pages =		dma_common_free_pages,
 };
 
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index b197ed9399e2e0..521950d0731e4a 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -300,8 +300,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	memory = dma_alloc_coherent(dev, TOTAL_MEM_SIZE, &pScript, GFP_KERNEL);
 	if (!memory) {
 		hostdata->noncoherent = 1;
-		memory = dma_alloc_attrs(dev, TOTAL_MEM_SIZE, &pScript,
-					 GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+		memory = dma_alloc_pages(dev, TOTAL_MEM_SIZE, &pScript,
+					 GFP_KERNEL, DMA_BIDIRECTIONAL);
 	}
 	if (!memory) {
 		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
@@ -414,8 +414,8 @@ NCR_700_release(struct Scsi_Host *host)
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 	if (hostdata->noncoherent)
-		dma_free_attrs(hostdata->dev, TOTAL_MEM_SIZE, hostdata->script,
-			       hostdata->pScript, DMA_ATTR_NON_CONSISTENT);
+		dma_free_pages(hostdata->dev, TOTAL_MEM_SIZE, hostdata->script,
+			       hostdata->pScript, DMA_BIDIRECTIONAL);
 	else
 		dma_free_coherent(hostdata->dev, TOTAL_MEM_SIZE,
 				  hostdata->script, hostdata->pScript);
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 3bdf0deb8f1529..133adcf99e9340 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -234,8 +234,8 @@ static int sgiwd93_probe(struct platform_device *pdev)
 
 	hdata = host_to_hostdata(host);
 	hdata->dev = &pdev->dev;
-	hdata->cpu = dma_alloc_attrs(&pdev->dev, HPC_DMA_SIZE, &hdata->dma,
-				     GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	hdata->cpu = dma_alloc_pages(&pdev->dev, HPC_DMA_SIZE, &hdata->dma,
+				     DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!hdata->cpu) {
 		printk(KERN_WARNING "sgiwd93: Could not allocate memory for "
 		       "host %d buffer.\n", unit);
@@ -274,8 +274,8 @@ static int sgiwd93_probe(struct platform_device *pdev)
 out_irq:
 	free_irq(irq, host);
 out_free:
-	dma_free_attrs(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
-		       DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
+			DMA_BIDIRECTIONAL);
 out_put:
 	scsi_host_put(host);
 out:
@@ -291,8 +291,8 @@ static int sgiwd93_remove(struct platform_device *pdev)
 
 	scsi_remove_host(host);
 	free_irq(pd->irq, host);
-	dma_free_attrs(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
-		       DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
+			DMA_BIDIRECTIONAL);
 	scsi_host_put(host);
 	return 0;
 }
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
index 3797ecccc15466..7871ce3887cf85 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -85,6 +85,11 @@ void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
+void *dma_direct_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
+void dma_direct_free_pages(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t dma_addr,
+		enum dma_data_direction dir);
 int dma_direct_get_sgtable(struct device *dev, struct sg_table *sgt,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 016b96b384bdda..73fa6e10c5c8b5 100644
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
+	void *(*alloc_pages)(struct device *dev, size_t size,
+			dma_addr_t *dma_handle, enum dma_data_direction dir,
+			gfp_t gfp);
+	void (*free_pages)(struct device *dev, size_t size, void *vaddr,
+			dma_addr_t dma_handle, enum dma_data_direction dir);
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			  void *, dma_addr_t, size_t,
 			  unsigned long attrs);
@@ -254,6 +254,11 @@ void *dmam_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dmam_free_coherent(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle);
+void *dma_alloc_pages(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		enum dma_data_direction dir, gfp_t gfp);
+void dma_free_pages(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir);
+/* dma_cache_sync is deprecated: don't use in new code */
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction dir);
 int dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt,
@@ -339,6 +344,15 @@ static inline void dmam_free_coherent(struct device *dev, size_t size,
 		void *vaddr, dma_addr_t dma_handle)
 {
 }
+static inline void *dma_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
+{
+	return NULL;
+}
+static inline void dma_free_pages(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir)
+{
+}
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction dir)
 {
@@ -513,7 +527,10 @@ static inline void dma_sync_sgtable_for_device(struct device *dev,
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
-
+void *dma_common_alloc_pages(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
+void dma_common_free_pages(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir);
 struct page **dma_common_find_pages(void *cpu_addr);
 void *dma_common_contiguous_remap(struct page *page, size_t size,
 			pgprot_t prot, const void *caller);
diff --git a/include/linux/dma-noncoherent.h b/include/linux/dma-noncoherent.h
index b9bc6c557ea46f..1eecfd24d434f8 100644
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
index e7963e51660792..a0c4be0953b2b5 100644
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
@@ -282,6 +282,55 @@ void dma_direct_free(struct device *dev, size_t size,
 	dma_free_contiguous(dev, dma_direct_to_page(dev, dma_addr), size);
 }
 
+void *dma_direct_alloc_pages(struct device *dev, size_t size,
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
+	return ret;
+out_free_pages:
+	dma_free_contiguous(dev, page, size);
+	return NULL;
+}
+
+void dma_direct_free_pages(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t dma_addr,
+		enum dma_data_direction dir)
+{
+	unsigned int page_order = get_order(size);
+
+	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
+	if (dma_should_free_from_pool(dev, 0) &&
+	    dma_free_from_pool(dev, cpu_addr, size))
+		return;
+
+	if (force_dma_unencrypted(dev))
+		set_memory_encrypted((unsigned long)cpu_addr, 1 << page_order);
+
+	dma_free_contiguous(dev, dma_direct_to_page(dev, dma_addr), size);
+}
+
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_SWIOTLB)
 void dma_direct_sync_sg_for_device(struct device *dev,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 848c95c27d79ff..dacdb7226caacd 100644
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
@@ -461,6 +459,45 @@ void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 }
 EXPORT_SYMBOL(dma_free_attrs);
 
+void *dma_alloc_pages(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		enum dma_data_direction dir, gfp_t gfp)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	void *vaddr;
+
+	if (WARN_ON_ONCE(!dev->coherent_dma_mask))
+		return NULL;
+	if (WARN_ON_ONCE(gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)))
+		return NULL;
+
+	size = PAGE_ALIGN(size);
+	if (dma_alloc_direct(dev, ops))
+		vaddr = dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
+	else if (ops->alloc_pages)
+		vaddr = ops->alloc_pages(dev, size, dma_handle, dir, gfp);
+	else
+		return NULL;
+
+	debug_dma_map_page(dev, virt_to_page(vaddr), 0, size, dir, *dma_handle);
+	return vaddr;
+}
+EXPORT_SYMBOL_GPL(dma_alloc_pages);
+
+void dma_free_pages(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	size = PAGE_ALIGN(size);
+	debug_dma_unmap_page(dev, dma_handle, size, dir);
+
+	if (dma_alloc_direct(dev, ops))
+		dma_direct_free_pages(dev, size, vaddr, dma_handle, dir);
+	else if (ops->free_pages)
+		ops->free_pages(dev, size, vaddr, dma_handle, dir);
+}
+EXPORT_SYMBOL_GPL(dma_free_pages);
+
 int dma_supported(struct device *dev, u64 mask)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index e443c69be4299f..17e66a41dc9c78 100644
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
+void *dma_common_alloc_pages(struct device *dev, size_t size,
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
+	return page_address(page);
+}
+
+void dma_common_free_pages(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, enum dma_data_direction dir)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (ops->unmap_page)
+		ops->unmap_page(dev, dma_handle, size, dir,
+				DMA_ATTR_SKIP_CPU_SYNC);
+	dma_free_contiguous(dev, virt_to_page(vaddr), size);
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
diff --git a/sound/mips/hal2.c b/sound/mips/hal2.c
index ec84bc4c3a6e77..746c410bd9bf11 100644
--- a/sound/mips/hal2.c
+++ b/sound/mips/hal2.c
@@ -449,15 +449,15 @@ static int hal2_alloc_dmabuf(struct snd_hal2 *hal2, struct hal2_codec *codec)
 	int count = H2_BUF_SIZE / H2_BLOCK_SIZE;
 	int i;
 
-	codec->buffer = dma_alloc_attrs(dev, H2_BUF_SIZE, &buffer_dma,
-					GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	codec->buffer = dma_alloc_pages(dev, H2_BUF_SIZE, &buffer_dma,
+					DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!codec->buffer)
 		return -ENOMEM;
-	desc = dma_alloc_attrs(dev, count * sizeof(struct hal2_desc),
-			       &desc_dma, GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	desc = dma_alloc_pages(dev, count * sizeof(struct hal2_desc), &desc_dma,
+			       DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!desc) {
-		dma_free_attrs(dev, H2_BUF_SIZE, codec->buffer, buffer_dma,
-			       DMA_ATTR_NON_CONSISTENT);
+		dma_free_pages(dev, H2_BUF_SIZE, codec->buffer, buffer_dma,
+				DMA_BIDIRECTIONAL);
 		return -ENOMEM;
 	}
 	codec->buffer_dma = buffer_dma;
@@ -480,10 +480,10 @@ static void hal2_free_dmabuf(struct snd_hal2 *hal2, struct hal2_codec *codec)
 {
 	struct device *dev = hal2->card->dev;
 
-	dma_free_attrs(dev, codec->desc_count * sizeof(struct hal2_desc),
-		       codec->desc, codec->desc_dma, DMA_ATTR_NON_CONSISTENT);
-	dma_free_attrs(dev, H2_BUF_SIZE, codec->buffer, codec->buffer_dma,
-		       DMA_ATTR_NON_CONSISTENT);
+	dma_free_pages(dev, codec->desc_count * sizeof(struct hal2_desc),
+		       codec->desc, codec->desc_dma, DMA_BIDIRECTIONAL);
+	dma_free_pages(dev, H2_BUF_SIZE, codec->buffer, codec->buffer_dma,
+			DMA_BIDIRECTIONAL);
 }
 
 static const struct snd_pcm_hardware hal2_pcm_hw = {
-- 
2.28.0

