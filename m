Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB226A99E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgIOQVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 12:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbgIOQUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:20:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072EEC0611BD;
        Tue, 15 Sep 2020 09:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=i+wSADPYCfjiINNNap/OtPKewAd3CUR2UpLQDRhWXVM=; b=KV4MHtGI1c35fx301ypBZ2ix5f
        j6+9ZBm5fX2GTWrmr4Ucexej6a/A5AgmrccjxIJaXRVSJ25VeGNarsOyAh2mV63O4QoWYIt397+p/
        PEj6Fh9y7Z9MocC0Hlfy6ktdLodgEKBx1jPzxDDRVZFQxq6HUKkZ+ruLNJ7tWvxCUBT0Uc4ZWj9aI
        eodnHxY42TKdaain8L+MAGrX7+JkUf2CCLX1ArOSkzY+hjEXko2GALiYhYarDUPJ5lEjgchOlPjSa
        oTRbf+Wq093khDrwEuwBqMXFNj+Kn+GSdd95aFRR1UNfKr4GP9znnnjfctGimxooOjIWir3e/76iY
        9DM3BvgA==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDgI-0005Cn-PU; Tue, 15 Sep 2020 16:19:47 +0000
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
Subject: [PATCH 12/18] sgiseeq: convert to dma_alloc_noncoherent
Date:   Tue, 15 Sep 2020 17:51:16 +0200
Message-Id: <20200915155122.1768241-13-hch@lst.de>
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

Use the new non-coherent DMA API including proper ownership transfers.
This includes adding additional calls to dma_sync_desc_dev as the
old syncing was rather ad-hoc.

Thanks to Thomas Bogendoerfer for debugging the ownership transfer
issues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/seeq/sgiseeq.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 8507ff2420143a..37ff25a84030eb 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -112,14 +112,18 @@ struct sgiseeq_private {
 
 static inline void dma_sync_desc_cpu(struct net_device *dev, void *addr)
 {
-	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
-		       DMA_FROM_DEVICE);
+	struct sgiseeq_private *sp = netdev_priv(dev);
+
+	dma_sync_single_for_cpu(dev->dev.parent, VIRT_TO_DMA(sp, addr),
+			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
 }
 
 static inline void dma_sync_desc_dev(struct net_device *dev, void *addr)
 {
-	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
-		       DMA_TO_DEVICE);
+	struct sgiseeq_private *sp = netdev_priv(dev);
+
+	dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
+			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
 }
 
 static inline void hpc3_eth_reset(struct hpc3_ethregs *hregs)
@@ -403,6 +407,8 @@ static inline void sgiseeq_rx(struct net_device *dev, struct sgiseeq_private *sp
 		rd = &sp->rx_desc[sp->rx_new];
 		dma_sync_desc_cpu(dev, rd);
 	}
+	dma_sync_desc_dev(dev, rd);
+
 	dma_sync_desc_cpu(dev, &sp->rx_desc[orig_end]);
 	sp->rx_desc[orig_end].rdma.cntinfo &= ~(HPCDMA_EOR);
 	dma_sync_desc_dev(dev, &sp->rx_desc[orig_end]);
@@ -443,6 +449,7 @@ static inline void kick_tx(struct net_device *dev,
 		dma_sync_desc_cpu(dev, td);
 	}
 	if (td->tdma.cntinfo & HPCDMA_XIU) {
+		dma_sync_desc_dev(dev, td);
 		hregs->tx_ndptr = VIRT_TO_DMA(sp, td);
 		hregs->tx_ctrl = HPC3_ETXCTRL_ACTIVE;
 	}
@@ -476,6 +483,7 @@ static inline void sgiseeq_tx(struct net_device *dev, struct sgiseeq_private *sp
 		if (!(td->tdma.cntinfo & (HPCDMA_XIU)))
 			break;
 		if (!(td->tdma.cntinfo & (HPCDMA_ETXD))) {
+			dma_sync_desc_dev(dev, td);
 			if (!(status & HPC3_ETXCTRL_ACTIVE)) {
 				hregs->tx_ndptr = VIRT_TO_DMA(sp, td);
 				hregs->tx_ctrl = HPC3_ETXCTRL_ACTIVE;
@@ -740,8 +748,8 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */
-	sr = dma_alloc_attrs(&pdev->dev, sizeof(*sp->srings), &sp->srings_dma,
-			     GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	sr = dma_alloc_noncoherent(&pdev->dev, sizeof(*sp->srings),
+			&sp->srings_dma, DMA_BIDIRECTIONAL, GFP_KERNEL);
 	if (!sr) {
 		printk(KERN_ERR "Sgiseeq: Page alloc failed, aborting.\n");
 		err = -ENOMEM;
@@ -802,8 +810,8 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_free_attrs:
-	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
-		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_BIDIRECTIONAL);
 err_out_free_dev:
 	free_netdev(dev);
 
@@ -817,8 +825,8 @@ static int sgiseeq_remove(struct platform_device *pdev)
 	struct sgiseeq_private *sp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
-		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_BIDIRECTIONAL);
 	free_netdev(dev);
 
 	return 0;
-- 
2.28.0

