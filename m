Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2422E908
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgG0Jai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:30:38 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:59885 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgG0Jai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:30:38 -0400
Received: from localhost.localdomain ([93.23.16.147])
        by mwinf5d31 with ME
        id 89WV2300A3ANib9039WVhH; Mon, 27 Jul 2020 11:30:35 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 27 Jul 2020 11:30:35 +0200
X-ME-IP: 93.23.16.147
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: hifn_795x - switch from 'pci_' to 'dma_' API
Date:   Mon, 27 Jul 2020 11:30:27 +0200
Message-Id: <20200727093027.46331-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'hifn_probe()' GFP_KERNEL can be used
because it is a probe function and no spin_lock is taken.

@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/crypto/hifn_795x.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 354836468c5d..3363ca4b1a98 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1235,7 +1235,8 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
 	int idx;
 	dma_addr_t addr;
 
-	addr = pci_map_page(dev->pdev, page, offset, size, PCI_DMA_TODEVICE);
+	addr = dma_map_page(&dev->pdev->dev, page, offset, size,
+			    DMA_TO_DEVICE);
 
 	idx = dma->srci;
 
@@ -1293,7 +1294,8 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	int idx;
 	dma_addr_t addr;
 
-	addr = pci_map_page(dev->pdev, page, offset, size, PCI_DMA_FROMDEVICE);
+	addr = dma_map_page(&dev->pdev->dev, page, offset, size,
+			    DMA_FROM_DEVICE);
 
 	idx = dma->dsti;
 	dma->dstr[idx].p = __cpu_to_le32(addr);
@@ -2470,7 +2472,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		goto err_out_disable_pci_device;
 
@@ -2514,8 +2516,9 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	dev->desc_virt = pci_zalloc_consistent(pdev, sizeof(struct hifn_dma),
-					       &dev->desc_dma);
+	dev->desc_virt = dma_alloc_coherent(&pdev->dev,
+					    sizeof(struct hifn_dma),
+					    &dev->desc_dma, GFP_KERNEL);
 	if (!dev->desc_virt) {
 		dev_err(&pdev->dev, "Failed to allocate descriptor rings.\n");
 		err = -ENOMEM;
@@ -2572,8 +2575,8 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	free_irq(dev->irq, dev);
 	tasklet_kill(&dev->tasklet);
 err_out_free_desc:
-	pci_free_consistent(pdev, sizeof(struct hifn_dma),
-			dev->desc_virt, dev->desc_dma);
+	dma_free_coherent(&pdev->dev, sizeof(struct hifn_dma), dev->desc_virt,
+			  dev->desc_dma);
 
 err_out_unmap_bars:
 	for (i = 0; i < 3; ++i)
@@ -2610,8 +2613,8 @@ static void hifn_remove(struct pci_dev *pdev)
 
 		hifn_flush(dev);
 
-		pci_free_consistent(pdev, sizeof(struct hifn_dma),
-				dev->desc_virt, dev->desc_dma);
+		dma_free_coherent(&pdev->dev, sizeof(struct hifn_dma),
+				  dev->desc_virt, dev->desc_dma);
 		for (i = 0; i < 3; ++i)
 			if (dev->bar[i])
 				iounmap(dev->bar[i]);
-- 
2.25.1

