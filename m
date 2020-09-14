Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38095268FB6
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgINPYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgINPY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:24:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49367C06174A;
        Mon, 14 Sep 2020 08:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3uuWATlux5CLwoYUg+NN5gOtHb6T7EXPohKT/lTJKJI=; b=U0IBgU2QceYv7cYz0f441RijWy
        jX6Uz56bUrKfzqiHUqW4Am8nd+6lVMXE3/VPeI6Dyctys5vWsqG7p9TZjmsaB4shTobADfofWCt2s
        1s3TKwLjbf+g5qtDtSLFgL8DmFzhOuChm2RFQ+dWaxRQVaecIXZU24GAOneelMTCvJ13zxrzITOvg
        ExNdpySucaD8C2anmkAXbMOJB2da5zC7FBZvWjUSKNpv1i+Go/vuMfGDKG5gApZgbramlUxDAnvlC
        0pbLEfVZA10XQ/7JqJFE/O3mSpo7OqirHTyfcD2gC9N8uRPiSLShe9jiyo8nmIV8jkTp7pR6eEG4A
        UuqWKTxw==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHqKm-0004Mq-MA; Mon, 14 Sep 2020 15:24:01 +0000
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
Subject: [PATCH 17/17] firewire-ohci: use dma_alloc_pages
Date:   Mon, 14 Sep 2020 16:44:33 +0200
Message-Id: <20200914144433.1622958-18-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914144433.1622958-1-hch@lst.de>
References: <20200914144433.1622958-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_alloc_pages to allocate DMAable pages instead of hoping that
the architecture either has GFP_DMA32 or not more than 4G of memory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/firewire/ohci.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 020cb15a4d8fcc..9811c40956e54d 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -674,17 +674,16 @@ static void ar_context_link_page(struct ar_context *ctx, unsigned int index)
 
 static void ar_context_release(struct ar_context *ctx)
 {
+	struct device *dev = ctx->ohci->card.device;
 	unsigned int i;
 
 	vunmap(ctx->buffer);
 
-	for (i = 0; i < AR_BUFFERS; i++)
-		if (ctx->pages[i]) {
-			dma_unmap_page(ctx->ohci->card.device,
-				       ar_buffer_bus(ctx, i),
-				       PAGE_SIZE, DMA_FROM_DEVICE);
-			__free_page(ctx->pages[i]);
-		}
+	for (i = 0; i < AR_BUFFERS; i++) {
+		if (ctx->pages[i])
+			dma_free_pages(dev, PAGE_SIZE, ctx->pages[i],
+				       ar_buffer_bus(ctx, i), DMA_FROM_DEVICE);
+	}
 }
 
 static void ar_context_abort(struct ar_context *ctx, const char *error_msg)
@@ -970,6 +969,7 @@ static void ar_context_tasklet(unsigned long data)
 static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 			   unsigned int descriptors_offset, u32 regs)
 {
+	struct device *dev = ohci->card.device;
 	unsigned int i;
 	dma_addr_t dma_addr;
 	struct page *pages[AR_BUFFERS + AR_WRAPAROUND_PAGES];
@@ -980,17 +980,13 @@ static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
 
 	for (i = 0; i < AR_BUFFERS; i++) {
-		ctx->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32);
+		ctx->pages[i] = dma_alloc_pages(dev, PAGE_SIZE, &dma_addr,
+						DMA_FROM_DEVICE, GFP_KERNEL);
 		if (!ctx->pages[i])
 			goto out_of_memory;
-		dma_addr = dma_map_page(ohci->card.device, ctx->pages[i],
-					0, PAGE_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(ohci->card.device, dma_addr)) {
-			__free_page(ctx->pages[i]);
-			ctx->pages[i] = NULL;
-			goto out_of_memory;
-		}
 		set_page_private(ctx->pages[i], dma_addr);
+		dma_sync_single_for_device(dev, dma_addr, PAGE_SIZE,
+					   DMA_FROM_DEVICE);
 	}
 
 	for (i = 0; i < AR_BUFFERS; i++)
-- 
2.28.0

