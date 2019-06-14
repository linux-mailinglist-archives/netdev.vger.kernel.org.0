Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939D045EF1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfFNNsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:48:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbfFNNr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:47:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EZXX45MA5Kr/jRAVRE8+C8CWSuTwR7IM5YlBjilZCgk=; b=h+BXnX3J4b+gwgk8yPNC/LWr1d
        p0nnzOOFRXth82UzpFCB2ZuQda+YSnZqn1gWN/qSy0zb/PDbkxwFXXm4UiBO6y21DGjJKIpj+/E7T
        t81qzz/2oo9KHsBbfxcBTc0XdOWVcD8Me/I1N4dbHkRIHmscQ3E5EqrB++XzFTrpq2R8zML45F/Ps
        oaAmNvGeU78znGJDV3igN+bPWzpoiS+4Hp8Fqr+cK6dinRTkZnWt3NgNbOOp66Pzk7n5TbtG2mGCw
        5/Tp8vxU8u23qdHv/v9KZKGd58ml8mZRHwcNFbLAEjZXspFap861gPdI5rNvUFMPWJb+9Ka6ShI2/
        EDWZG46A==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYT-0004pk-75; Fri, 14 Jun 2019 13:47:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] drm: move drm_pci_{alloc,free} to drm_legacy
Date:   Fri, 14 Jun 2019 15:47:14 +0200
Message-Id: <20190614134726.3827-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions are rather broken in that they try to pass __GFP_COMP
to dma_alloc_coherent, call virt_to_page on the return value and
mess with PageReserved.  And not actually used by any modern driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/drm_bufs.c | 85 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_pci.c  | 89 --------------------------------------
 2 files changed, 85 insertions(+), 89 deletions(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index bfc419ed9d6c..7418872d87c6 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -38,6 +38,91 @@
 
 #include <linux/nospec.h>
 
+/**
+ * drm_pci_alloc - Allocate a PCI consistent memory block, for DMA.
+ * @dev: DRM device
+ * @size: size of block to allocate
+ * @align: alignment of block
+ *
+ * FIXME: This is a needless abstraction of the Linux dma-api and should be
+ * removed.
+ *
+ * Return: A handle to the allocated memory block on success or NULL on
+ * failure.
+ */
+drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
+{
+	drm_dma_handle_t *dmah;
+	unsigned long addr;
+	size_t sz;
+
+	/* pci_alloc_consistent only guarantees alignment to the smallest
+	 * PAGE_SIZE order which is greater than or equal to the requested size.
+	 * Return NULL here for now to make sure nobody tries for larger alignment
+	 */
+	if (align > size)
+		return NULL;
+
+	dmah = kmalloc(sizeof(drm_dma_handle_t), GFP_KERNEL);
+	if (!dmah)
+		return NULL;
+
+	dmah->size = size;
+	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size,
+					 &dmah->busaddr,
+					 GFP_KERNEL | __GFP_COMP);
+
+	if (dmah->vaddr == NULL) {
+		kfree(dmah);
+		return NULL;
+	}
+
+	/* XXX - Is virt_to_page() legal for consistent mem? */
+	/* Reserve */
+	for (addr = (unsigned long)dmah->vaddr, sz = size;
+	     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
+		SetPageReserved(virt_to_page((void *)addr));
+	}
+
+	return dmah;
+}
+
+/*
+ * Free a PCI consistent memory block without freeing its descriptor.
+ *
+ * This function is for internal use in the Linux-specific DRM core code.
+ */
+void __drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
+{
+	unsigned long addr;
+	size_t sz;
+
+	if (dmah->vaddr) {
+		/* XXX - Is virt_to_page() legal for consistent mem? */
+		/* Unreserve */
+		for (addr = (unsigned long)dmah->vaddr, sz = dmah->size;
+		     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
+			ClearPageReserved(virt_to_page((void *)addr));
+		}
+		dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
+				  dmah->busaddr);
+	}
+}
+
+/**
+ * drm_pci_free - Free a PCI consistent memory block
+ * @dev: DRM device
+ * @dmah: handle to memory block
+ *
+ * FIXME: This is a needless abstraction of the Linux dma-api and should be
+ * removed.
+ */
+void drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
+{
+	__drm_legacy_pci_free(dev, dmah);
+	kfree(dmah);
+}
+
 static struct drm_map_list *drm_find_matching_map(struct drm_device *dev,
 						  struct drm_local_map *map)
 {
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 693748ad8b88..77a215f2a8e4 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -31,95 +31,6 @@
 #include "drm_internal.h"
 #include "drm_legacy.h"
 
-/**
- * drm_pci_alloc - Allocate a PCI consistent memory block, for DMA.
- * @dev: DRM device
- * @size: size of block to allocate
- * @align: alignment of block
- *
- * FIXME: This is a needless abstraction of the Linux dma-api and should be
- * removed.
- *
- * Return: A handle to the allocated memory block on success or NULL on
- * failure.
- */
-drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
-{
-	drm_dma_handle_t *dmah;
-	unsigned long addr;
-	size_t sz;
-
-	/* pci_alloc_consistent only guarantees alignment to the smallest
-	 * PAGE_SIZE order which is greater than or equal to the requested size.
-	 * Return NULL here for now to make sure nobody tries for larger alignment
-	 */
-	if (align > size)
-		return NULL;
-
-	dmah = kmalloc(sizeof(drm_dma_handle_t), GFP_KERNEL);
-	if (!dmah)
-		return NULL;
-
-	dmah->size = size;
-	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size,
-					 &dmah->busaddr,
-					 GFP_KERNEL | __GFP_COMP);
-
-	if (dmah->vaddr == NULL) {
-		kfree(dmah);
-		return NULL;
-	}
-
-	/* XXX - Is virt_to_page() legal for consistent mem? */
-	/* Reserve */
-	for (addr = (unsigned long)dmah->vaddr, sz = size;
-	     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-		SetPageReserved(virt_to_page((void *)addr));
-	}
-
-	return dmah;
-}
-
-EXPORT_SYMBOL(drm_pci_alloc);
-
-/*
- * Free a PCI consistent memory block without freeing its descriptor.
- *
- * This function is for internal use in the Linux-specific DRM core code.
- */
-void __drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
-{
-	unsigned long addr;
-	size_t sz;
-
-	if (dmah->vaddr) {
-		/* XXX - Is virt_to_page() legal for consistent mem? */
-		/* Unreserve */
-		for (addr = (unsigned long)dmah->vaddr, sz = dmah->size;
-		     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-			ClearPageReserved(virt_to_page((void *)addr));
-		}
-		dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
-				  dmah->busaddr);
-	}
-}
-
-/**
- * drm_pci_free - Free a PCI consistent memory block
- * @dev: DRM device
- * @dmah: handle to memory block
- *
- * FIXME: This is a needless abstraction of the Linux dma-api and should be
- * removed.
- */
-void drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
-{
-	__drm_legacy_pci_free(dev, dmah);
-	kfree(dmah);
-}
-
-EXPORT_SYMBOL(drm_pci_free);
-
 #ifdef CONFIG_PCI
 
 static int drm_get_pci_domain(struct drm_device *dev)
-- 
2.20.1

