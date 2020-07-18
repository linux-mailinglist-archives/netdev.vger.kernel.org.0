Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D419224ADD
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGRLDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:03:45 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:26306 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgGRLDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:03:45 -0400
Received: from localhost.localdomain ([93.22.37.252])
        by mwinf5d41 with ME
        id 4b3f2300S5SQgGV03b3gSr; Sat, 18 Jul 2020 13:03:42 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 18 Jul 2020 13:03:42 +0200
X-ME-IP: 93.22.37.252
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kuba@kernel.org, davem@davemloft.net, snelson@pensando.io,
        leon@kernel.org, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/fealnx: switch from 'pci_' to 'dma_' API
Date:   Sat, 18 Jul 2020 13:03:38 +0200
Message-Id: <20200718110338.355408-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated, GFP_KERNEL can be used because it is called from
the probe function (i.e. 'fealnx_init_one()') and no lock is taken.

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
 drivers/net/ethernet/fealnx.c | 91 ++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index 73e896a7d8fd..c696651dd735 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -543,7 +543,8 @@ static int fealnx_init_one(struct pci_dev *pdev,
 	np->mii.phy_id_mask = 0x1f;
 	np->mii.reg_num_mask = 0x1f;
 
-	ring_space = pci_alloc_consistent(pdev, RX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space) {
 		err = -ENOMEM;
 		goto err_out_free_dev;
@@ -551,7 +552,8 @@ static int fealnx_init_one(struct pci_dev *pdev,
 	np->rx_ring = ring_space;
 	np->rx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent(pdev, TX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space) {
 		err = -ENOMEM;
 		goto err_out_free_rx;
@@ -656,9 +658,11 @@ static int fealnx_init_one(struct pci_dev *pdev,
 	return 0;
 
 err_out_free_tx:
-	pci_free_consistent(pdev, TX_TOTAL_SIZE, np->tx_ring, np->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
+			  np->tx_ring_dma);
 err_out_free_rx:
-	pci_free_consistent(pdev, RX_TOTAL_SIZE, np->rx_ring, np->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
+			  np->rx_ring_dma);
 err_out_free_dev:
 	free_netdev(dev);
 err_out_unmap:
@@ -676,10 +680,10 @@ static void fealnx_remove_one(struct pci_dev *pdev)
 	if (dev) {
 		struct netdev_private *np = netdev_priv(dev);
 
-		pci_free_consistent(pdev, TX_TOTAL_SIZE, np->tx_ring,
-			np->tx_ring_dma);
-		pci_free_consistent(pdev, RX_TOTAL_SIZE, np->rx_ring,
-			np->rx_ring_dma);
+		dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
+				  np->tx_ring_dma);
+		dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
+				  np->rx_ring_dma);
 		unregister_netdev(dev);
 		pci_iounmap(pdev, np->mem);
 		free_netdev(dev);
@@ -1056,8 +1060,10 @@ static void allocate_rx_buffers(struct net_device *dev)
 			np->lack_rxbuf = np->lack_rxbuf->next_desc_logical;
 
 		np->lack_rxbuf->skbuff = skb;
-		np->lack_rxbuf->buffer = pci_map_single(np->pci_dev, skb->data,
-			np->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		np->lack_rxbuf->buffer = dma_map_single(&np->pci_dev->dev,
+							skb->data,
+							np->rx_buf_sz,
+							DMA_FROM_DEVICE);
 		np->lack_rxbuf->status = RXOWN;
 		++np->really_rx_count;
 	}
@@ -1251,8 +1257,10 @@ static void init_ring(struct net_device *dev)
 
 		++np->really_rx_count;
 		np->rx_ring[i].skbuff = skb;
-		np->rx_ring[i].buffer = pci_map_single(np->pci_dev, skb->data,
-			np->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		np->rx_ring[i].buffer = dma_map_single(&np->pci_dev->dev,
+						       skb->data,
+						       np->rx_buf_sz,
+						       DMA_FROM_DEVICE);
 		np->rx_ring[i].status = RXOWN;
 		np->rx_ring[i].control |= RXIC;
 	}
@@ -1290,8 +1298,8 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 #define one_buffer
 #define BPT 1022
 #if defined(one_buffer)
-	np->cur_tx_copy->buffer = pci_map_single(np->pci_dev, skb->data,
-		skb->len, PCI_DMA_TODEVICE);
+	np->cur_tx_copy->buffer = dma_map_single(&np->pci_dev->dev, skb->data,
+						 skb->len, DMA_TO_DEVICE);
 	np->cur_tx_copy->control = TXIC | TXLD | TXFD | CRCEnable | PADEnable;
 	np->cur_tx_copy->control |= (skb->len << PKTSShift);	/* pkt size */
 	np->cur_tx_copy->control |= (skb->len << TBSShift);	/* buffer size */
@@ -1306,8 +1314,9 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 		struct fealnx_desc *next;
 
 		/* for the first descriptor */
-		np->cur_tx_copy->buffer = pci_map_single(np->pci_dev, skb->data,
-			BPT, PCI_DMA_TODEVICE);
+		np->cur_tx_copy->buffer = dma_map_single(&np->pci_dev->dev,
+							 skb->data, BPT,
+							 DMA_TO_DEVICE);
 		np->cur_tx_copy->control = TXIC | TXFD | CRCEnable | PADEnable;
 		np->cur_tx_copy->control |= (skb->len << PKTSShift);	/* pkt size */
 		np->cur_tx_copy->control |= (BPT << TBSShift);	/* buffer size */
@@ -1321,8 +1330,9 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 // 89/12/29 add,
 		if (np->pci_dev->device == 0x891)
 			np->cur_tx_copy->control |= ETIControl | RetryTxLC;
-		next->buffer = pci_map_single(ep->pci_dev, skb->data + BPT,
-                                skb->len - BPT, PCI_DMA_TODEVICE);
+		next->buffer = dma_map_single(&ep->pci_dev->dev,
+					      skb->data + BPT, skb->len - BPT,
+					      DMA_TO_DEVICE);
 
 		next->status = TXOWN;
 		np->cur_tx_copy->status = TXOWN;
@@ -1330,8 +1340,9 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 		np->cur_tx_copy = next->next_desc_logical;
 		np->free_tx_count -= 2;
 	} else {
-		np->cur_tx_copy->buffer = pci_map_single(np->pci_dev, skb->data,
-			skb->len, PCI_DMA_TODEVICE);
+		np->cur_tx_copy->buffer = dma_map_single(&np->pci_dev->dev,
+							 skb->data, skb->len,
+							 DMA_TO_DEVICE);
 		np->cur_tx_copy->control = TXIC | TXLD | TXFD | CRCEnable | PADEnable;
 		np->cur_tx_copy->control |= (skb->len << PKTSShift);	/* pkt size */
 		np->cur_tx_copy->control |= (skb->len << TBSShift);	/* buffer size */
@@ -1371,8 +1382,8 @@ static void reset_tx_descriptors(struct net_device *dev)
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		cur = &np->tx_ring[i];
 		if (cur->skbuff) {
-			pci_unmap_single(np->pci_dev, cur->buffer,
-				cur->skbuff->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&np->pci_dev->dev, cur->buffer,
+					 cur->skbuff->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(cur->skbuff);
 			cur->skbuff = NULL;
 		}
@@ -1515,8 +1526,10 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 			}
 
 			/* Free the original skb. */
-			pci_unmap_single(np->pci_dev, np->cur_tx->buffer,
-				np->cur_tx->skbuff->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&np->pci_dev->dev,
+					 np->cur_tx->buffer,
+					 np->cur_tx->skbuff->len,
+					 DMA_TO_DEVICE);
 			dev_consume_skb_irq(np->cur_tx->skbuff);
 			np->cur_tx->skbuff = NULL;
 			--np->really_tx_count;
@@ -1682,10 +1695,10 @@ static int netdev_rx(struct net_device *dev)
 			if (pkt_len < rx_copybreak &&
 			    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
-				pci_dma_sync_single_for_cpu(np->pci_dev,
-							    np->cur_rx->buffer,
-							    np->rx_buf_sz,
-							    PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&np->pci_dev->dev,
+							np->cur_rx->buffer,
+							np->rx_buf_sz,
+							DMA_FROM_DEVICE);
 				/* Call copy + cksum if available. */
 
 #if ! defined(__alpha__)
@@ -1696,15 +1709,15 @@ static int netdev_rx(struct net_device *dev)
 				skb_put_data(skb, np->cur_rx->skbuff->data,
 					     pkt_len);
 #endif
-				pci_dma_sync_single_for_device(np->pci_dev,
-							       np->cur_rx->buffer,
-							       np->rx_buf_sz,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&np->pci_dev->dev,
+							   np->cur_rx->buffer,
+							   np->rx_buf_sz,
+							   DMA_FROM_DEVICE);
 			} else {
-				pci_unmap_single(np->pci_dev,
+				dma_unmap_single(&np->pci_dev->dev,
 						 np->cur_rx->buffer,
 						 np->rx_buf_sz,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 				skb_put(skb = np->cur_rx->skbuff, pkt_len);
 				np->cur_rx->skbuff = NULL;
 				--np->really_rx_count;
@@ -1896,8 +1909,9 @@ static int netdev_close(struct net_device *dev)
 
 		np->rx_ring[i].status = 0;
 		if (skb) {
-			pci_unmap_single(np->pci_dev, np->rx_ring[i].buffer,
-				np->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&np->pci_dev->dev,
+					 np->rx_ring[i].buffer, np->rx_buf_sz,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 			np->rx_ring[i].skbuff = NULL;
 		}
@@ -1907,8 +1921,9 @@ static int netdev_close(struct net_device *dev)
 		struct sk_buff *skb = np->tx_ring[i].skbuff;
 
 		if (skb) {
-			pci_unmap_single(np->pci_dev, np->tx_ring[i].buffer,
-				skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&np->pci_dev->dev,
+					 np->tx_ring[i].buffer, skb->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			np->tx_ring[i].skbuff = NULL;
 		}
-- 
2.25.1

