Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AC96270B0
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiKMQgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbiKMQgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:36:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F951183C;
        Sun, 13 Nov 2022 08:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IZIXQnSGcHYeM4XJWAJat9lbPLpIQMPCw7wwtVshmX8=; b=uXVEEcm5gNDlzy32h/Z90s3u66
        L9AFXb3lYOW33nsHgdUJhj2drBZbUy/yrtfv5+jlSl16oZ2K0eUrstr4/vkAOMDeK0YRcE0vpuXRB
        T7yNkNTfybeOTC2ZzcNUHoPpb1Rw7oCMKLnkaHwulVzTV1oEu9GTjmIoI467k0/4Tbae96MmpZNwB
        Mef6tL8fexZfMSjajxytehZa28hwRmsizcTReO6x0yMiaLaSvOdXG4oRf1DXvTmlV20+2llg3MTZ4
        aZVZsV9nOXU1Xxo7WUU+Y73zq1wo50jxwwpOh4ju6HzoH6lb8zPu54zWSFeJ1poQ8JWYZNDyayNMI
        2cTpXJOQ==;
Received: from 213-225-8-167.nat.highway.a1.net ([213.225.8.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouFxa-00CLUM-DA; Sun, 13 Nov 2022 16:35:55 +0000
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
Subject: [PATCH 3/7] RDMA/qib: don't pass bogus GFP_ flags to dma_alloc_coherent
Date:   Sun, 13 Nov 2022 17:35:31 +0100
Message-Id: <20221113163535.884299-4-hch@lst.de>
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

dma_alloc_coherent is an opaque allocator that only uses the GFP_ flags
for allocation context control.  Don't pass GFP_USER which doesn't make
sense for a kernel DMA allocation or __GFP_COMP which makes no sense
for an allocation that can't in any way be converted to a page pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/hw/qib/qib_iba6120.c |  2 +-
 drivers/infiniband/hw/qib/qib_init.c    | 21 ++++-----------------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index aea571943768b..07386117f21ad 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2075,7 +2075,7 @@ static void alloc_dummy_hdrq(struct qib_devdata *dd)
 	dd->cspec->dummy_hdrq = dma_alloc_coherent(&dd->pcidev->dev,
 					dd->rcd[0]->rcvhdrq_size,
 					&dd->cspec->dummy_hdrq_phys,
-					GFP_ATOMIC | __GFP_COMP);
+					GFP_ATOMIC);
 	if (!dd->cspec->dummy_hdrq) {
 		qib_devinfo(dd->pcidev, "Couldn't allocate dummy hdrq\n");
 		/* fallback to just 0'ing */
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 45211008449fb..33667becd52b0 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1546,18 +1546,14 @@ int qib_create_rcvhdrq(struct qib_devdata *dd, struct qib_ctxtdata *rcd)
 
 	if (!rcd->rcvhdrq) {
 		dma_addr_t phys_hdrqtail;
-		gfp_t gfp_flags;
 
 		amt = ALIGN(dd->rcvhdrcnt * dd->rcvhdrentsize *
 			    sizeof(u32), PAGE_SIZE);
-		gfp_flags = (rcd->ctxt >= dd->first_user_ctxt) ?
-			GFP_USER : GFP_KERNEL;
 
 		old_node_id = dev_to_node(&dd->pcidev->dev);
 		set_dev_node(&dd->pcidev->dev, rcd->node_id);
-		rcd->rcvhdrq = dma_alloc_coherent(
-			&dd->pcidev->dev, amt, &rcd->rcvhdrq_phys,
-			gfp_flags | __GFP_COMP);
+		rcd->rcvhdrq = dma_alloc_coherent(&dd->pcidev->dev, amt,
+				&rcd->rcvhdrq_phys, GFP_KERNEL);
 		set_dev_node(&dd->pcidev->dev, old_node_id);
 
 		if (!rcd->rcvhdrq) {
@@ -1577,7 +1573,7 @@ int qib_create_rcvhdrq(struct qib_devdata *dd, struct qib_ctxtdata *rcd)
 			set_dev_node(&dd->pcidev->dev, rcd->node_id);
 			rcd->rcvhdrtail_kvaddr = dma_alloc_coherent(
 				&dd->pcidev->dev, PAGE_SIZE, &phys_hdrqtail,
-				gfp_flags);
+				GFP_KERNEL);
 			set_dev_node(&dd->pcidev->dev, old_node_id);
 			if (!rcd->rcvhdrtail_kvaddr)
 				goto bail_free;
@@ -1621,17 +1617,8 @@ int qib_setup_eagerbufs(struct qib_ctxtdata *rcd)
 	struct qib_devdata *dd = rcd->dd;
 	unsigned e, egrcnt, egrperchunk, chunk, egrsize, egroff;
 	size_t size;
-	gfp_t gfp_flags;
 	int old_node_id;
 
-	/*
-	 * GFP_USER, but without GFP_FS, so buffer cache can be
-	 * coalesced (we hope); otherwise, even at order 4,
-	 * heavy filesystem activity makes these fail, and we can
-	 * use compound pages.
-	 */
-	gfp_flags = __GFP_RECLAIM | __GFP_IO | __GFP_COMP;
-
 	egrcnt = rcd->rcvegrcnt;
 	egroff = rcd->rcvegr_tid_base;
 	egrsize = dd->rcvegrbufsize;
@@ -1663,7 +1650,7 @@ int qib_setup_eagerbufs(struct qib_ctxtdata *rcd)
 		rcd->rcvegrbuf[e] =
 			dma_alloc_coherent(&dd->pcidev->dev, size,
 					   &rcd->rcvegrbuf_phys[e],
-					   gfp_flags);
+					   GFP_KERNEL);
 		set_dev_node(&dd->pcidev->dev, old_node_id);
 		if (!rcd->rcvegrbuf[e])
 			goto bail_rcvegrbuf_phys;
-- 
2.30.2

