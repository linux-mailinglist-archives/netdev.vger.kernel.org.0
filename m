Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3756D6270A7
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiKMQgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiKMQf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:35:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3317510FCF;
        Sun, 13 Nov 2022 08:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=QmrATxoWw4i+ZCEet0QcrcoeounoBlCDdVUnFfxBeEE=; b=t5j7lXGJ7y4k7mshKGThP6/oMi
        PZD5z8vzrJKInWEJS4o8ibNxZiBKoCq226HnMrLpXIidMD9P2aHEZeZmUGoy5rH4j5ndBBQ9aD9x0
        4vcmIw7caELmyeuHlHqh+IXIushQHrso5BEN7RojMe/GxKraazPWw4GAs2rI9iZFLXGtag+W/kRGT
        DtraYp58Tzl37x5w7RJKHitxhUygtt0kYRry70+CnVBhmY6rNXj8W3qXpO7jcZ3SIPm80b201dV5J
        EieadWtmFHV/T7JuVFxN7h280v67rKSYAjdrGOMPrT6A5pqNqlTALgBPVOkb/WUk3itkWgqMhzXJH
        vYQjJamw==;
Received: from 213-225-8-167.nat.highway.a1.net ([213.225.8.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouFxR-00CLSB-JY; Sun, 13 Nov 2022 16:35:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 1/7] media: videobuf-dma-contig: use dma_mmap_coherent
Date:   Sun, 13 Nov 2022 17:35:29 +0100
Message-Id: <20221113163535.884299-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221113163535.884299-1-hch@lst.de>
References: <20221113163535.884299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_alloc_coherent does not return a physical address, but a DMA address,
which might be remapped or have an offset.  Passing the DMA address to
vm_iomap_memory is thus broken.

Use the proper dma_mmap_coherent helper instead, and stop passing
__GFP_COMP to dma_alloc_coherent, as the memory management inside the
DMA allocator is hidden from the callers and does not require it.

With this the gfp_t argument to __videobuf_dc_alloc can be removed and
hard coded to GFP_KERNEL.

Fixes: a8f3c203e19b ("[media] videobuf-dma-contig: add cache support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 52312ce2ba056..f2c4393595574 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -36,12 +36,11 @@ struct videobuf_dma_contig_memory {
 
 static int __videobuf_dc_alloc(struct device *dev,
 			       struct videobuf_dma_contig_memory *mem,
-			       unsigned long size, gfp_t flags)
+			       unsigned long size)
 {
 	mem->size = size;
-	mem->vaddr = dma_alloc_coherent(dev, mem->size,
-					&mem->dma_handle, flags);
-
+	mem->vaddr = dma_alloc_coherent(dev, mem->size, &mem->dma_handle,
+					GFP_KERNEL);
 	if (!mem->vaddr) {
 		dev_err(dev, "memory alloc size %ld failed\n", mem->size);
 		return -ENOMEM;
@@ -258,8 +257,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 			return videobuf_dma_contig_user_get(mem, vb);
 
 		/* allocate memory for the read() method */
-		if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(vb->size),
-					GFP_KERNEL))
+		if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(vb->size)))
 			return -ENOMEM;
 		break;
 	case V4L2_MEMORY_OVERLAY:
@@ -295,22 +293,18 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(buf->bsize),
-				GFP_KERNEL | __GFP_COMP))
+	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(buf->bsize)))
 		goto error;
 
-	/* Try to remap memory */
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
 	/* the "vm_pgoff" is just used in v4l2 to find the
 	 * corresponding buffer data structure which is allocated
 	 * earlier and it does not mean the offset from the physical
 	 * buffer start address as usual. So set it to 0 to pass
-	 * the sanity check in vm_iomap_memory().
+	 * the sanity check in dma_mmap_coherent().
 	 */
 	vma->vm_pgoff = 0;
-
-	retval = vm_iomap_memory(vma, mem->dma_handle, mem->size);
+	retval = dma_mmap_coherent(q->dev, vma, mem->vaddr, mem->dma_handle,
+				   mem->size);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
 			retval);
-- 
2.30.2

