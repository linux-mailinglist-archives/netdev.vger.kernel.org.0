Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BF023C085
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHDUIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:08:23 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:54968 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725981AbgHDUIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:08:21 -0400
Received: from localhost.localdomain ([93.23.13.33])
        by mwinf5d72 with ME
        id BY8B2300Q0in9Tx03Y8CAQ; Tue, 04 Aug 2020 22:08:17 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 04 Aug 2020 22:08:17 +0200
X-ME-IP: 93.23.13.33
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     khc@pm.waw.pl, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] wan: wanxl: switch from 'pci_' to 'dma_' API
Date:   Tue,  4 Aug 2020 22:08:09 +0200
Message-Id: <20200804200809.714999-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'wanxl_pci_init_one()', GFP_KERNEL can be used
because it is a probe function and no lock is acquired.
Moreover, just a few lines above, GFP_KERNEL is already used.


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
 drivers/net/wan/wanxl.c | 54 ++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 499f7cd19a4a..dc0cc953c4af 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -99,7 +99,7 @@ static inline port_status_t *get_status(struct port *port)
 static inline dma_addr_t pci_map_single_debug(struct pci_dev *pdev, void *ptr,
 					      size_t size, int direction)
 {
-	dma_addr_t addr = pci_map_single(pdev, ptr, size, direction);
+	dma_addr_t addr = dma_map_single(&pdev->dev, ptr, size, direction);
 	if (addr + size > 0x100000000LL)
 		pr_crit("%s: pci_map_single() returned memory at 0x%llx!\n",
 			pci_name(pdev), (unsigned long long)addr);
@@ -180,8 +180,8 @@ static inline void wanxl_tx_intr(struct port *port)
 			dev->stats.tx_bytes += skb->len;
 		}
                 desc->stat = PACKET_EMPTY; /* Free descriptor */
-		pci_unmap_single(port->card->pdev, desc->address, skb->len,
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&port->card->pdev->dev, desc->address,
+				 skb->len, DMA_TO_DEVICE);
 		dev_consume_skb_irq(skb);
                 port->tx_in = (port->tx_in + 1) % TX_BUFFERS;
         }
@@ -207,9 +207,9 @@ static inline void wanxl_rx_intr(struct card *card)
 			if (!skb)
 				dev->stats.rx_dropped++;
 			else {
-				pci_unmap_single(card->pdev, desc->address,
-						 BUFFER_LENGTH,
-						 PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&card->pdev->dev,
+						 desc->address, BUFFER_LENGTH,
+						 DMA_FROM_DEVICE);
 				skb_put(skb, desc->length);
 
 #ifdef DEBUG_PKT
@@ -227,9 +227,10 @@ static inline void wanxl_rx_intr(struct card *card)
 			if (!skb) {
 				skb = dev_alloc_skb(BUFFER_LENGTH);
 				desc->address = skb ?
-					pci_map_single(card->pdev, skb->data,
+					dma_map_single(&card->pdev->dev,
+						       skb->data,
 						       BUFFER_LENGTH,
-						       PCI_DMA_FROMDEVICE) : 0;
+						       DMA_FROM_DEVICE) : 0;
 				card->rx_skbs[card->rx_in] = skb;
 			}
 		}
@@ -291,8 +292,8 @@ static netdev_tx_t wanxl_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif
 
 	port->tx_skbs[port->tx_out] = skb;
-	desc->address = pci_map_single(port->card->pdev, skb->data, skb->len,
-				       PCI_DMA_TODEVICE);
+	desc->address = dma_map_single(&port->card->pdev->dev, skb->data,
+				       skb->len, DMA_TO_DEVICE);
 	desc->length = skb->len;
 	desc->stat = PACKET_FULL;
 	writel(1 << (DOORBELL_TO_CARD_TX_0 + port->node),
@@ -451,9 +452,9 @@ static int wanxl_close(struct net_device *dev)
 
 		if (desc->stat != PACKET_EMPTY) {
 			desc->stat = PACKET_EMPTY;
-			pci_unmap_single(port->card->pdev, desc->address,
-					 port->tx_skbs[i]->len,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&port->card->pdev->dev,
+					 desc->address, port->tx_skbs[i]->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb(port->tx_skbs[i]);
 		}
 	}
@@ -524,9 +525,9 @@ static void wanxl_pci_remove_one(struct pci_dev *pdev)
 
 	for (i = 0; i < RX_QUEUE_LENGTH; i++)
 		if (card->rx_skbs[i]) {
-			pci_unmap_single(card->pdev,
+			dma_unmap_single(&card->pdev->dev,
 					 card->status->rx_descs[i].address,
-					 BUFFER_LENGTH, PCI_DMA_FROMDEVICE);
+					 BUFFER_LENGTH, DMA_FROM_DEVICE);
 			dev_kfree_skb(card->rx_skbs[i]);
 		}
 
@@ -534,8 +535,8 @@ static void wanxl_pci_remove_one(struct pci_dev *pdev)
 		iounmap(card->plx);
 
 	if (card->status)
-		pci_free_consistent(pdev, sizeof(struct card_status),
-				    card->status, card->status_address);
+		dma_free_coherent(&pdev->dev, sizeof(struct card_status),
+				  card->status, card->status_address);
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -579,8 +580,8 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	   We set both dma_mask and consistent_dma_mask to 28 bits
 	   and pray pci_alloc_consistent() will use this info. It should
 	   work on most platforms */
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(28)) ||
-	    pci_set_dma_mask(pdev, DMA_BIT_MASK(28))) {
+	if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(28)) ||
+	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(28))) {
 		pr_err("No usable DMA configuration\n");
 		pci_disable_device(pdev);
 		return -EIO;
@@ -608,9 +609,9 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, card);
 	card->pdev = pdev;
 
-	card->status = pci_alloc_consistent(pdev,
-					    sizeof(struct card_status),
-					    &card->status_address);
+	card->status = dma_alloc_coherent(&pdev->dev,
+					  sizeof(struct card_status),
+					  &card->status_address, GFP_KERNEL);
 	if (card->status == NULL) {
 		wanxl_pci_remove_one(pdev);
 		return -ENOBUFS;
@@ -625,8 +626,8 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	/* FIXME when PCI/DMA subsystems are fixed.
 	   We set both dma_mask and consistent_dma_mask back to 32 bits
 	   to indicate the card can do 32-bit DMA addressing */
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-	    pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) ||
+	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		pr_err("No usable DMA configuration\n");
 		wanxl_pci_remove_one(pdev);
 		return -EIO;
@@ -699,9 +700,8 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 		card->rx_skbs[i] = skb;
 		if (skb)
 			card->status->rx_descs[i].address =
-				pci_map_single(card->pdev, skb->data,
-					       BUFFER_LENGTH,
-					       PCI_DMA_FROMDEVICE);
+				dma_map_single(&card->pdev->dev, skb->data,
+					       BUFFER_LENGTH, DMA_FROM_DEVICE);
 	}
 
 	mem = ioremap(mem_phy, PDM_OFFSET + sizeof(firmware));
-- 
2.25.1

