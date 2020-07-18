Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C1C224A9D
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgGRKam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:30:42 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:42033 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgGRKal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 06:30:41 -0400
Received: from localhost.localdomain ([93.22.37.252])
        by mwinf5d41 with ME
        id 4aWa2300L5SQgGV03aWbBS; Sat, 18 Jul 2020 12:30:38 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 18 Jul 2020 12:30:38 +0200
X-ME-IP: 93.22.37.252
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     isdn@linux-pingi.de, davem@davemloft.net,
        sergey.senozhatsky@gmail.com, wangkefeng.wang@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mISDN: switch from 'pci_' to 'dma_' API
Date:   Sat, 18 Jul 2020 12:30:33 +0200
Message-Id: <20200718103033.352247-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'setup_hw()' (hfcpci.c) GFP_KERNEL can be used
because it is called from the probe function and no lock is taken.
The call chain is:
   hfc_probe()
   --> setup_card()
   --> setup_hw()

When memory is allocated in 'inittiger()' (netjet.c) GFP_ATOMIC must be
used because a spin_lock is taken by the caller (i.e. 'nj_init_card()')
This is also consistent with the other allocations done in the function.

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
 drivers/isdn/hardware/mISDN/hfcpci.c | 12 +++++++-----
 drivers/isdn/hardware/mISDN/netjet.c |  8 ++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index abdf787c1a71..904a4f4c5ff9 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -158,7 +158,8 @@ release_io_hfcpci(struct hfc_pci *hc)
 	/* disable memory mapped ports + busmaster */
 	pci_write_config_word(hc->pdev, PCI_COMMAND, 0);
 	del_timer(&hc->hw.timer);
-	pci_free_consistent(hc->pdev, 0x8000, hc->hw.fifos, hc->hw.dmahandle);
+	dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
+			  hc->hw.dmahandle);
 	iounmap(hc->hw.pci_io);
 }
 
@@ -2004,8 +2005,9 @@ setup_hw(struct hfc_pci *hc)
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
-	pci_set_dma_mask(hc->pdev, 0xFFFF8000);
-	buffer = pci_alloc_consistent(hc->pdev, 0x8000, &hc->hw.dmahandle);
+	dma_set_mask(&hc->pdev->dev, 0xFFFF8000);
+	buffer = dma_alloc_coherent(&hc->pdev->dev, 0x8000, &hc->hw.dmahandle,
+				    GFP_KERNEL);
 	/* We silently assume the address is okay if nonzero */
 	if (!buffer) {
 		printk(KERN_WARNING
@@ -2018,8 +2020,8 @@ setup_hw(struct hfc_pci *hc)
 	if (unlikely(!hc->hw.pci_io)) {
 		printk(KERN_WARNING
 		       "HFC-PCI: Error in ioremap for PCI!\n");
-		pci_free_consistent(hc->pdev, 0x8000, hc->hw.fifos,
-				    hc->hw.dmahandle);
+		dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
+				  hc->hw.dmahandle);
 		return 1;
 	}
 
diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 6aae97e827b7..ee925b58bbce 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -297,8 +297,8 @@ inittiger(struct tiger_hw *card)
 {
 	int i;
 
-	card->dma_p = pci_alloc_consistent(card->pdev, NJ_DMA_SIZE,
-					   &card->dma);
+	card->dma_p = dma_alloc_coherent(&card->pdev->dev, NJ_DMA_SIZE,
+					 &card->dma, GFP_ATOMIC);
 	if (!card->dma_p) {
 		pr_info("%s: No DMA memory\n", card->name);
 		return -ENOMEM;
@@ -965,8 +965,8 @@ nj_release(struct tiger_hw *card)
 		kfree(card->bc[i].hrbuf);
 	}
 	if (card->dma_p)
-		pci_free_consistent(card->pdev, NJ_DMA_SIZE,
-				    card->dma_p, card->dma);
+		dma_free_coherent(&card->pdev->dev, NJ_DMA_SIZE, card->dma_p,
+				  card->dma);
 	write_lock_irqsave(&card_lock, flags);
 	list_del(&card->list);
 	write_unlock_irqrestore(&card_lock, flags);
-- 
2.25.1

