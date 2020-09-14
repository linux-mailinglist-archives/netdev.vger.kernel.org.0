Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0811E268F11
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgINPHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgINPG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:06:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15D8C06174A;
        Mon, 14 Sep 2020 08:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Guqxj07xwr5MuMGWT2PdBQLUVmSBHz1SxHMxp26SQAM=; b=RQyjQHnFNjLhYXRu+xmRV3KJiG
        MI4IBCdvEOohACxvVh+/xYssZZYT/IHYbakxqGhpgZ+8s/1SjVgBhq4La1P7D7SzWc0LrP+gpv0Dj
        /x3krhZ2DWcnxNij0hB9XwtUGZPPcbNjJ8uT3YlRdl7jfJBRTJ3TYLcG8DwbWQNHbUCIKCdbXCFrU
        XpVBEJGxs7Z9ZqwAQPVb2AJ1jbglHYJLt0GPZJbv5s0RO4qpWeMmA74RaIcfsDKvmjT4gEnd3bWPp
        kUpswxcg1eMD/zSb1FKwpQHCKOo0P4y025Vf0Oap/avayb6TqAW2XUTkfB0ZjbxPOaVbQgi4x1e+A
        gNbK6IOA==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHq3q-0002xu-5N; Mon, 14 Sep 2020 15:06:30 +0000
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
Subject: [PATCH 09/17] sgiwd93: convert to dma_alloc_noncoherent
Date:   Mon, 14 Sep 2020 16:44:25 +0200
Message-Id: <20200914144433.1622958-10-hch@lst.de>
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

