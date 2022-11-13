Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC81D6270BC
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiKMQgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiKMQg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:36:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE731183C;
        Sun, 13 Nov 2022 08:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FrKTW2jC/YO2/WPGYjBN4j0fLdu07wAq+vKIs1aTDt0=; b=gBRLp/Wqhnjj7vSyEDOzq1Ylp/
        6Tf29mv6KdGs4oNOLvYvc+/P60fwD/5ZTPU1/lbVLUsLtkJHRo+qtCUeCUVDGDwzhgNISfn0/6nLO
        X3FJ9CEAE8Cr1sflf5EKKHZzHKr8gSwKQbSij8Ga6biPZMe9g2nOdftFxwZ4W9Os6Bg/9VkG2urxB
        jHSeUJFjQt3sIRtU+TQN9owu8fgaAS4h7UrV/RvQuyO4+qYsqpKmWMw9vuOP0VcFh6W1TLNlHZ9pa
        N3pPIyId+IGhiNqGFElCB72ffRIGv8YFFQCvUdzCuJhCXItuM/3LKuzCbFOxiD36TC3p36SrAUCVE
        itKktNFA==;
Received: from 213-225-8-167.nat.highway.a1.net ([213.225.8.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouFxn-00CLab-8i; Sun, 13 Nov 2022 16:36:08 +0000
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
Subject: [PATCH 6/7] ALSA: memalloc: don't pass bogus GFP_ flags to dma_alloc_*
Date:   Sun, 13 Nov 2022 17:35:34 +0100
Message-Id: <20221113163535.884299-7-hch@lst.de>
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

dma_alloc_coherent/dma_alloc_wc is an opaque allocator that only uses
the GFP_ flags for allocation context control.  Don't pass __GFP_COMP
which makes no sense for an allocation that can't in any way be
converted to a page pointer.

Note that for dma_alloc_noncoherent and dma_alloc_noncontigous in
combination with the DMA mmap helpers __GFP_COMP looks sketchy as well,
so I would suggest to drop that as well after a careful audit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 sound/core/memalloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 03cffe7713667..fe03cf796e8bb 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -20,7 +20,6 @@
 
 #define DEFAULT_GFP \
 	(GFP_KERNEL | \
-	 __GFP_COMP |    /* compound page lets parts be mapped */ \
 	 __GFP_RETRY_MAYFAIL | /* don't trigger OOM-killer */ \
 	 __GFP_NOWARN)   /* no stack trace print - this call is non-critical */
 
@@ -542,7 +541,7 @@ static void *snd_dma_noncontig_alloc(struct snd_dma_buffer *dmab, size_t size)
 	void *p;
 
 	sgt = dma_alloc_noncontiguous(dmab->dev.dev, size, dmab->dev.dir,
-				      DEFAULT_GFP, 0);
+				      DEFAULT_GFP | __GFP_COMP, 0);
 	if (!sgt) {
 #ifdef CONFIG_SND_DMA_SGBUF
 		if (dmab->dev.type == SNDRV_DMA_TYPE_DEV_WC_SG)
@@ -810,7 +809,7 @@ static void *snd_dma_noncoherent_alloc(struct snd_dma_buffer *dmab, size_t size)
 	void *p;
 
 	p = dma_alloc_noncoherent(dmab->dev.dev, size, &dmab->addr,
-				  dmab->dev.dir, DEFAULT_GFP);
+				  dmab->dev.dir, DEFAULT_GFP | __GFP_COMP);
 	if (p)
 		dmab->dev.need_sync = dma_need_sync(dmab->dev.dev, dmab->addr);
 	return p;
-- 
2.30.2

