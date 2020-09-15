Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8443B26B179
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgIOWbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgIOQRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:17:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A2CC061A2B;
        Tue, 15 Sep 2020 09:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Guqxj07xwr5MuMGWT2PdBQLUVmSBHz1SxHMxp26SQAM=; b=Itp/Q3JRcH/NoLIHSU3m7qeF67
        gdhEr5XoAv7CiO4A0JxQ9Ti91ecohZg09mmgvHrQ+qoZ6uxG9jjAF5CYBRkGY4hkrZ8oLusOXawRu
        itEmIISOfcaM1ZycQkbekQzpocP6mbHhti1ust7wPgdCSXc66m8BGmkDx98nY/j8QwaRK1bMXlU+m
        bYtvv7XU/3VQJbFpljGBOuuUeAEg3A3Iw5CUCndXJ/8B9we1WY5JyUIiuhTRei/9HurInzcXik9Ju
        uioPNWsVFBKt3ob9SdqR4jaV4K2ad4/sztjOMkemAO/dxqRpZQjqa6xUWACYYBfwxKEGU2wvZU38V
        7RUXb+ng==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDZx-0004jl-Hl; Tue, 15 Sep 2020 16:13:13 +0000
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
Subject: [PATCH 09/18] sgiwd93: convert to dma_alloc_noncoherent
Date:   Tue, 15 Sep 2020 17:51:13 +0200
Message-Id: <20200915155122.1768241-10-hch@lst.de>
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
This also means we can allocate the memory as DMA_TO_DEVICE instead
of bidirectional.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sgiwd93.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 3bdf0deb8f1529..cf1030c9dda17f 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -95,7 +95,7 @@ void fill_hpc_entries(struct ip22_hostdata *hd, struct scsi_cmnd *cmd, int din)
 	 */
 	hcp->desc.pbuf = 0;
 	hcp->desc.cntinfo = HPCDMA_EOX;
-	dma_cache_sync(hd->dev, hd->cpu,
+	dma_sync_single_for_device(hd->dev, hd->dma,
 		       (unsigned long)(hcp + 1) - (unsigned long)hd->cpu,
 		       DMA_TO_DEVICE);
 }
@@ -234,8 +234,8 @@ static int sgiwd93_probe(struct platform_device *pdev)
 
 	hdata = host_to_hostdata(host);
 	hdata->dev = &pdev->dev;
-	hdata->cpu = dma_alloc_attrs(&pdev->dev, HPC_DMA_SIZE, &hdata->dma,
-				     GFP_KERNEL, DMA_ATTR_NON_CONSISTENT);
+	hdata->cpu = dma_alloc_noncoherent(&pdev->dev, HPC_DMA_SIZE,
+				&hdata->dma, DMA_TO_DEVICE, GFP_KERNEL);
 	if (!hdata->cpu) {
 		printk(KERN_WARNING "sgiwd93: Could not allocate memory for "
 		       "host %d buffer.\n", unit);
@@ -274,8 +274,8 @@ static int sgiwd93_probe(struct platform_device *pdev)
 out_irq:
 	free_irq(irq, host);
 out_free:
-	dma_free_attrs(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
-		       DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
+			DMA_TO_DEVICE);
 out_put:
 	scsi_host_put(host);
 out:
@@ -291,8 +291,8 @@ static int sgiwd93_remove(struct platform_device *pdev)
 
 	scsi_remove_host(host);
 	free_irq(pd->irq, host);
-	dma_free_attrs(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
-		       DMA_ATTR_NON_CONSISTENT);
+	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
+			DMA_TO_DEVICE);
 	scsi_host_put(host);
 	return 0;
 }
-- 
2.28.0

