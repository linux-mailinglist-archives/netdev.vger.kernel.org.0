Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A86249691
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHSHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgHSG4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:56:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99364C061344;
        Tue, 18 Aug 2020 23:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3H4NansDDN6m4kLuhIk/kp+Z4N3mSn8cpB0zE9ycnQw=; b=FfmYzkf9G6zwFUNNR629I5LzS3
        sycbpl6XBJNQxWdPFjivtYFvAIE2BLJ2qzBGSbrb4qsZMMfJP9/eHP8S4mQZ2+1Qp/sFoX35RiYzA
        HkdgOwz29iCkQAeMrmvVDYWraKQlEbIhijWnbLTMYghTv+7s9PA7sbl0esYUqgLYg5nrbhp5tTocC
        MkluoLqBfAzc4H5hViUIudDFe/lF5vGUx/dU2cLYx7jpBj8d8QnwTRzaMwN5nNPDKwz3V69GXE5aG
        zl6z181fqk4Jsg3atxLUAO9BbSDDhHAHpg0t5QmSPP39kziJBaZbtnr9s/ut+FwVdfRsInPqqIqLh
        2U/MY4HQ==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I1A-0008Nq-7N; Wed, 19 Aug 2020 06:56:16 +0000
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
Subject: [PATCH 10/28] MIPS/jazzdma: decouple from dma-direct
Date:   Wed, 19 Aug 2020 08:55:37 +0200
Message-Id: <20200819065555.1802761-11-hch@lst.de>
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

The jazzdma ops implement support for a very basic IOMMU.  Thus we really
should not use the dma-direct code that takes physical address limits
into account.  This survived through the great MIPS DMA ops cleanup mostly
because I was lazy, but now it is time to fully split the implementations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/mips/jazz/jazzdma.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index fe40dbed04c1d6..d0b5a2ba2b1a8a 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -16,7 +16,6 @@
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
 #include <linux/gfp.h>
-#include <linux/dma-direct.h>
 #include <linux/dma-noncoherent.h>
 #include <asm/mipsregs.h>
 #include <asm/jazz.h>
@@ -492,26 +491,38 @@ int vdma_get_enable(int channel)
 static void *jazz_dma_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
+	struct page *page;
 	void *ret;
 
-	ret = dma_direct_alloc_pages(dev, size, dma_handle, gfp, attrs);
-	if (!ret)
-		return NULL;
+	if (attrs & DMA_ATTR_NO_WARN)
+		gfp |= __GFP_NOWARN;
 
-	*dma_handle = vdma_alloc(virt_to_phys(ret), size);
-	if (*dma_handle == DMA_MAPPING_ERROR) {
-		dma_direct_free_pages(dev, size, ret, *dma_handle, attrs);
+	size = PAGE_ALIGN(size);
+	page = alloc_pages(gfp, get_order(size));
+	if (!page)
 		return NULL;
-	}
+	ret = page_address(page);
+	*dma_handle = vdma_alloc(virt_to_phys(ret), size);
+	if (*dma_handle == DMA_MAPPING_ERROR)
+		goto out_free_pages;
+
+	if (attrs & DMA_ATTR_NON_CONSISTENT)
+		return ret;
+	arch_dma_prep_coherent(page, size);
+	return (void *)(UNCAC_BASE + __pa(ret));
 
-	return ret;
+out_free_pages:
+	__free_pages(page, get_order(size));
+	return NULL;
 }
 
 static void jazz_dma_free(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle, unsigned long attrs)
 {
 	vdma_free(dma_handle);
-	dma_direct_free_pages(dev, size, vaddr, dma_handle, attrs);
+	if (!(attrs & DMA_ATTR_NON_CONSISTENT))
+		vaddr = __va(vaddr - UNCAC_BASE);
+	__free_pages(virt_to_page(vaddr), get_order(size));
 }
 
 static dma_addr_t jazz_dma_map_page(struct device *dev, struct page *page,
@@ -608,7 +619,6 @@ const struct dma_map_ops jazz_dma_ops = {
 	.sync_single_for_device	= jazz_dma_sync_single_for_device,
 	.sync_sg_for_cpu	= jazz_dma_sync_sg_for_cpu,
 	.sync_sg_for_device	= jazz_dma_sync_sg_for_device,
-	.dma_supported		= dma_direct_supported,
 	.cache_sync		= arch_dma_cache_sync,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-- 
2.28.0

