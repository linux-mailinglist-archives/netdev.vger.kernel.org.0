Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06D2EA539
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfJ3VM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:12:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LXvtBXEVpwFWBBrDenmZhZZJyqaYLLSNmXotvCjOTBQ=; b=TQ0TRt8uKHWLXzjE99A1+Qkknq
        p8bYarvtyw7D4Pd1tYv9qAQcWdg5m8ehqHWR302n53EeAh00GdsQwFV99BPFHiYHRMDmmC+O7vYif
        S8QSRDVknXiTVgTDUmnigxCzdYpIoWFrGZ+6Y+FPu39UlbbdhXXgdRbHMkGOkyhgR+OK1okCHi4rs
        ypKTjUOrvHQ+GMkIURYE6cdlqQxf299hOuq//gJyCnurtJ1V61isawq3U/o9BjO3o57BYjEYv3qu0
        F6p3hidYVJ0q5Vq6l7FgZhdvfsfxFuZmrOIG57cxDnN6RTGHwj1GFTuVPTr372ir8LX069E/NRUAd
        tOxYhqMg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPvGy-0007fi-Hp; Wed, 30 Oct 2019 21:12:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: sgi: ioc3-eth: simplify setting the DMA mask
Date:   Wed, 30 Oct 2019 14:12:32 -0700
Message-Id: <20191030211233.30157-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030211233.30157-1-hch@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to fall back to a lower mask these days, the DMA mask
just communictes the hardware supported features.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 8a684d882e63..dc2e22652b55 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1173,26 +1173,14 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ioc3 *ioc3;
 	unsigned long ioc3_base, ioc3_size;
 	u32 vendor, model, rev;
-	int err, pci_using_dac;
+	int err;
 
 	/* Configure DMA attributes. */
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (!err) {
-		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (err < 0) {
-			pr_err("%s: Unable to obtain 64 bit DMA for consistent allocations\n",
-			       pci_name(pdev));
-			goto out;
-		}
-	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (err) {
-			pr_err("%s: No usable DMA configuration, aborting.\n",
-			       pci_name(pdev));
-			goto out;
-		}
-		pci_using_dac = 0;
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		pr_err("%s: No usable DMA configuration, aborting.\n",
+		       pci_name(pdev));
+		goto out;
 	}
 
 	if (pci_enable_device(pdev))
@@ -1204,8 +1192,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable;
 	}
 
-	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+	dev->features |= NETIF_F_HIGHDMA;
 
 	err = pci_request_regions(pdev, "ioc3");
 	if (err)
-- 
2.20.1

