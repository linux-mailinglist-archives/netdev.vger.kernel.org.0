Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C7926B0CC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgIOWTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbgIOQ3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:29:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C3AC06178B;
        Tue, 15 Sep 2020 09:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1/bEcy21h9dr4Lop81Jp+A+3tsDr/+YN8bI8sHR6ers=; b=olAOSynYlsHEGJhf6TUlmrckuE
        /r0LGBccgU4hRqqI8td0cmd/yN43a1NVzzTHUUoIBhJriadMr+CZIn81GdOqHwGRRCnoGg0Lpn2As
        D87gTkZYobl3hk2YFKI39vdQ/6KaZsMZZHwt9r8yylGEHBzR9RNXvP3ZAPY1xXRi6Vcg2UuFPe53e
        0Nr6Ng4Fo3q7nEb85kHX3sqaqpJfeXNhK6gIhRiDcpSKQqPiwby8Brgzeb7Q8bHIHFeQFHcfeCFaO
        30AdYUq1MYULU/w9BF2KXnq/TBqPJ/HePxZDgzUFxWt8R3Pzl7zV2oGhwr/DJ8H/v8eE7+ssTVi/j
        0mVYXghw==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDon-0005qq-4D; Tue, 15 Sep 2020 16:28:33 +0000
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
Subject: [PATCH 16/18] dma-mapping: add new {alloc,free}_noncoherent dma_map_ops methods
Date:   Tue, 15 Sep 2020 17:51:20 +0200
Message-Id: <20200915155122.1768241-17-hch@lst.de>
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

This will allow IOMMU drivers to allocate non-contigous memory and
return a vmapped virtual address.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/dma-mapping.h |  5 +++++
 kernel/dma/mapping.c        | 33 +++++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index bf592cf0db4acb..b4b5d75260d6dc 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -80,6 +80,11 @@ struct dma_map_ops {
 			gfp_t gfp);
 	void (*free_pages)(struct device *dev, size_t size, struct page *vaddr,
 			dma_addr_t dma_handle, enum dma_data_direction dir);
+	void* (*alloc_noncoherent)(struct device *dev, size_t size,
+			dma_addr_t *dma_handle, enum dma_data_direction dir,
+			gfp_t gfp);
+	void (*free_noncoherent)(struct device *dev, size_t size, void *vaddr,
+			dma_addr_t dma_handle, enum dma_data_direction dir);
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			  void *, dma_addr_t, size_t,
 			  unsigned long attrs);
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 6f86c925b8251d..8614d7d2ee59a9 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -502,19 +502,40 @@ EXPORT_SYMBOL_GPL(dma_free_pages);
 void *dma_alloc_noncoherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
 {
-	struct page *page;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	void *vaddr;
 
-	page = dma_alloc_pages(dev, size, dma_handle, dir, gfp);
-	if (!page)
-		return NULL;
-	return page_address(page);
+	if (!ops || !ops->alloc_noncoherent) {
+		struct page *page;
+
+		page = dma_alloc_pages(dev, size, dma_handle, dir, gfp);
+		if (!page)
+			return NULL;
+		return page_address(page);
+	}
+
+	size = PAGE_ALIGN(size);
+	vaddr = ops->alloc_noncoherent(dev, size, dma_handle, dir, gfp);
+	if (vaddr)
+		debug_dma_map_page(dev, virt_to_page(vaddr), 0, size, dir,
+				   *dma_handle);
+	return vaddr;
 }
 EXPORT_SYMBOL_GPL(dma_alloc_noncoherent);
 
 void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 		dma_addr_t dma_handle, enum dma_data_direction dir)
 {
-	dma_free_pages(dev, size, virt_to_page(vaddr), dma_handle, dir);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (!ops || !ops->free_noncoherent) {
+		dma_free_pages(dev, size, virt_to_page(vaddr), dma_handle, dir);
+		return;
+	}
+
+	size = PAGE_ALIGN(size);
+	debug_dma_unmap_page(dev, dma_handle, size, dir);
+	ops->free_noncoherent(dev, size, vaddr, dma_handle, dir);
 }
 EXPORT_SYMBOL_GPL(dma_free_noncoherent);
 
-- 
2.28.0

