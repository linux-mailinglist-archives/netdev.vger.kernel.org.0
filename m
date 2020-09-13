Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075C1267E3D
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 08:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgIMG5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 02:57:22 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:37145 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgIMG5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 02:57:21 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d69 with ME
        id TJxE230041Drbmd03JxEmw; Sun, 13 Sep 2020 08:57:18 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 08:57:18 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        gustavoars@kernel.org, vaibhavgupta40@gmail.com, mst@redhat.com,
        leon@kernel.org
Cc:     linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tulip: windbond-840: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Sep 2020 08:57:11 +0200
Message-Id: <20200913065711.351802-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'alloc_ringdesc()' GFP_KERNEL can be used
because it is only called from 'netdev_open()' which is a '.ndo_open'
function. Such functions are synchronized using the rtnl_lock() semaphore
and no lock is taken in the between.


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
 drivers/net/ethernet/dec/tulip/winbond-840.c | 73 ++++++++++----------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 5a43be327f58..7388e58486a6 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -364,7 +364,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	irq = pdev->irq;
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		pr_warn("Device %s disabled due to DMA limitations\n",
 			pci_name(pdev));
 		return -EIO;
@@ -802,8 +802,9 @@ static void init_rxtx_rings(struct net_device *dev)
 		np->rx_skbuff[i] = skb;
 		if (skb == NULL)
 			break;
-		np->rx_addr[i] = pci_map_single(np->pci_dev,skb->data,
-					np->rx_buf_sz,PCI_DMA_FROMDEVICE);
+		np->rx_addr[i] = dma_map_single(&np->pci_dev->dev, skb->data,
+						np->rx_buf_sz,
+						DMA_FROM_DEVICE);
 
 		np->rx_ring[i].buffer1 = np->rx_addr[i];
 		np->rx_ring[i].status = DescOwned;
@@ -833,20 +834,17 @@ static void free_rxtx_rings(struct netdev_private* np)
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		np->rx_ring[i].status = 0;
 		if (np->rx_skbuff[i]) {
-			pci_unmap_single(np->pci_dev,
-						np->rx_addr[i],
-						np->rx_skbuff[i]->len,
-						PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&np->pci_dev->dev, np->rx_addr[i],
+					 np->rx_skbuff[i]->len,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(np->rx_skbuff[i]);
 		}
 		np->rx_skbuff[i] = NULL;
 	}
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		if (np->tx_skbuff[i]) {
-			pci_unmap_single(np->pci_dev,
-						np->tx_addr[i],
-						np->tx_skbuff[i]->len,
-						PCI_DMA_TODEVICE);
+			dma_unmap_single(&np->pci_dev->dev, np->tx_addr[i],
+					 np->tx_skbuff[i]->len, DMA_TO_DEVICE);
 			dev_kfree_skb(np->tx_skbuff[i]);
 		}
 		np->tx_skbuff[i] = NULL;
@@ -964,10 +962,10 @@ static int alloc_ringdesc(struct net_device *dev)
 
 	np->rx_buf_sz = (dev->mtu <= 1500 ? PKT_BUF_SZ : dev->mtu + 32);
 
-	np->rx_ring = pci_alloc_consistent(np->pci_dev,
-			sizeof(struct w840_rx_desc)*RX_RING_SIZE +
-			sizeof(struct w840_tx_desc)*TX_RING_SIZE,
-			&np->ring_dma_addr);
+	np->rx_ring = dma_alloc_coherent(&np->pci_dev->dev,
+					 sizeof(struct w840_rx_desc) * RX_RING_SIZE +
+					 sizeof(struct w840_tx_desc) * TX_RING_SIZE,
+					 &np->ring_dma_addr, GFP_KERNEL);
 	if(!np->rx_ring)
 		return -ENOMEM;
 	init_rxtx_rings(dev);
@@ -976,10 +974,10 @@ static int alloc_ringdesc(struct net_device *dev)
 
 static void free_ringdesc(struct netdev_private *np)
 {
-	pci_free_consistent(np->pci_dev,
-			sizeof(struct w840_rx_desc)*RX_RING_SIZE +
-			sizeof(struct w840_tx_desc)*TX_RING_SIZE,
-			np->rx_ring, np->ring_dma_addr);
+	dma_free_coherent(&np->pci_dev->dev,
+			  sizeof(struct w840_rx_desc) * RX_RING_SIZE +
+			  sizeof(struct w840_tx_desc) * TX_RING_SIZE,
+			  np->rx_ring, np->ring_dma_addr);
 
 }
 
@@ -994,8 +992,8 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 	/* Calculate the next Tx descriptor entry. */
 	entry = np->cur_tx % TX_RING_SIZE;
 
-	np->tx_addr[entry] = pci_map_single(np->pci_dev,
-				skb->data,skb->len, PCI_DMA_TODEVICE);
+	np->tx_addr[entry] = dma_map_single(&np->pci_dev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 	np->tx_skbuff[entry] = skb;
 
 	np->tx_ring[entry].buffer1 = np->tx_addr[entry];
@@ -1078,9 +1076,8 @@ static void netdev_tx_done(struct net_device *dev)
 			np->stats.tx_packets++;
 		}
 		/* Free the original skb. */
-		pci_unmap_single(np->pci_dev,np->tx_addr[entry],
-					np->tx_skbuff[entry]->len,
-					PCI_DMA_TODEVICE);
+		dma_unmap_single(&np->pci_dev->dev, np->tx_addr[entry],
+				 np->tx_skbuff[entry]->len, DMA_TO_DEVICE);
 		np->tx_q_bytes -= np->tx_skbuff[entry]->len;
 		dev_kfree_skb_irq(np->tx_skbuff[entry]);
 		np->tx_skbuff[entry] = NULL;
@@ -1217,18 +1214,21 @@ static int netdev_rx(struct net_device *dev)
 			if (pkt_len < rx_copybreak &&
 			    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
-				pci_dma_sync_single_for_cpu(np->pci_dev,np->rx_addr[entry],
-							    np->rx_skbuff[entry]->len,
-							    PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&np->pci_dev->dev,
+							np->rx_addr[entry],
+							np->rx_skbuff[entry]->len,
+							DMA_FROM_DEVICE);
 				skb_copy_to_linear_data(skb, np->rx_skbuff[entry]->data, pkt_len);
 				skb_put(skb, pkt_len);
-				pci_dma_sync_single_for_device(np->pci_dev,np->rx_addr[entry],
-							       np->rx_skbuff[entry]->len,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&np->pci_dev->dev,
+							   np->rx_addr[entry],
+							   np->rx_skbuff[entry]->len,
+							   DMA_FROM_DEVICE);
 			} else {
-				pci_unmap_single(np->pci_dev,np->rx_addr[entry],
-							np->rx_skbuff[entry]->len,
-							PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&np->pci_dev->dev,
+						 np->rx_addr[entry],
+						 np->rx_skbuff[entry]->len,
+						 DMA_FROM_DEVICE);
 				skb_put(skb = np->rx_skbuff[entry], pkt_len);
 				np->rx_skbuff[entry] = NULL;
 			}
@@ -1258,9 +1258,10 @@ static int netdev_rx(struct net_device *dev)
 			np->rx_skbuff[entry] = skb;
 			if (skb == NULL)
 				break;			/* Better luck next round. */
-			np->rx_addr[entry] = pci_map_single(np->pci_dev,
-							skb->data,
-							np->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			np->rx_addr[entry] = dma_map_single(&np->pci_dev->dev,
+							    skb->data,
+							    np->rx_buf_sz,
+							    DMA_FROM_DEVICE);
 			np->rx_ring[entry].buffer1 = np->rx_addr[entry];
 		}
 		wmb();
-- 
2.25.1

