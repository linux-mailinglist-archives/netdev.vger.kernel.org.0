Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8792EDCC7
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 11:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfKDKpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 05:45:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:45082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727553AbfKDKpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 05:45:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0E75B1D2;
        Mon,  4 Nov 2019 10:45:22 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [net v3 3/5] net: sgi: ioc3-eth: simplify setting the DMA mask
Date:   Mon,  4 Nov 2019 11:45:13 +0100
Message-Id: <20191104104515.7066-3-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104104515.7066-1-tbogendoerfer@suse.de>
References: <20191104104515.7066-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

There is no need to fall back to a lower mask these days, the DMA mask
just communicates the hardware supported features.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
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
2.16.4

