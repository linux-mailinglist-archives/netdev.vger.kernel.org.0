Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AE824EBCD
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 08:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHWG0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 02:26:50 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:20429 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgHWG0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 02:26:50 -0400
Received: from localhost.localdomain ([93.22.133.217])
        by mwinf5d33 with ME
        id JuSk230054hbG4l03uSlRZ; Sun, 23 Aug 2020 08:26:46 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 Aug 2020 08:26:46 +0200
X-ME-IP: 93.22.133.217
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     ionut@badula.org, davem@davemloft.net, kuba@kernel.org,
        snelson@pensando.io, leon@kernel.org, hkallweit1@gmail.com,
        vaibhavgupta40@gmail.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] starfire: switch from 'pci_' to 'dma_' API
Date:   Sun, 23 Aug 2020 08:26:41 +0200
Message-Id: <20200823062641.163283-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'netdev_open()', GFP_ATOMIC must be used
because it can be called from a .ndo_tx_timeout function.
So this function can be called with the 'netif_tx_lock' acquired.
The call chain is:
  --> tx_timeout                 (.ndo_tx_timeout function)
    --> netdev_open


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
 drivers/net/ethernet/adaptec/starfire.c | 77 ++++++++++++++-----------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index ba0055bb1614..abbb728c49cc 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -886,7 +886,9 @@ static int netdev_open(struct net_device *dev)
 		tx_ring_size = ((sizeof(starfire_tx_desc) * TX_RING_SIZE + QUEUE_ALIGN - 1) / QUEUE_ALIGN) * QUEUE_ALIGN;
 		rx_ring_size = sizeof(struct starfire_rx_desc) * RX_RING_SIZE;
 		np->queue_mem_size = tx_done_q_size + rx_done_q_size + tx_ring_size + rx_ring_size;
-		np->queue_mem = pci_alloc_consistent(np->pci_dev, np->queue_mem_size, &np->queue_mem_dma);
+		np->queue_mem = dma_alloc_coherent(&np->pci_dev->dev,
+						   np->queue_mem_size,
+						   &np->queue_mem_dma, GFP_ATOMIC);
 		if (np->queue_mem == NULL) {
 			free_irq(irq, dev);
 			return -ENOMEM;
@@ -1136,9 +1138,11 @@ static void init_ring(struct net_device *dev)
 		np->rx_info[i].skb = skb;
 		if (skb == NULL)
 			break;
-		np->rx_info[i].mapping = pci_map_single(np->pci_dev, skb->data, np->rx_buf_sz, PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(np->pci_dev,
-					  np->rx_info[i].mapping)) {
+		np->rx_info[i].mapping = dma_map_single(&np->pci_dev->dev,
+							skb->data,
+							np->rx_buf_sz,
+							DMA_FROM_DEVICE);
+		if (dma_mapping_error(&np->pci_dev->dev, np->rx_info[i].mapping)) {
 			dev_kfree_skb(skb);
 			np->rx_info[i].skb = NULL;
 			break;
@@ -1217,18 +1221,19 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 			status |= skb_first_frag_len(skb) | (skb_num_frags(skb) << 16);
 
 			np->tx_info[entry].mapping =
-				pci_map_single(np->pci_dev, skb->data, skb_first_frag_len(skb), PCI_DMA_TODEVICE);
+				dma_map_single(&np->pci_dev->dev, skb->data,
+					       skb_first_frag_len(skb),
+					       DMA_TO_DEVICE);
 		} else {
 			const skb_frag_t *this_frag = &skb_shinfo(skb)->frags[i - 1];
 			status |= skb_frag_size(this_frag);
 			np->tx_info[entry].mapping =
-				pci_map_single(np->pci_dev,
+				dma_map_single(&np->pci_dev->dev,
 					       skb_frag_address(this_frag),
 					       skb_frag_size(this_frag),
-					       PCI_DMA_TODEVICE);
+					       DMA_TO_DEVICE);
 		}
-		if (pci_dma_mapping_error(np->pci_dev,
-					  np->tx_info[entry].mapping)) {
+		if (dma_mapping_error(&np->pci_dev->dev, np->tx_info[entry].mapping)) {
 			dev->stats.tx_dropped++;
 			goto err_out;
 		}
@@ -1271,18 +1276,16 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 	entry = prev_tx % TX_RING_SIZE;
 	np->tx_info[entry].skb = NULL;
 	if (i > 0) {
-		pci_unmap_single(np->pci_dev,
+		dma_unmap_single(&np->pci_dev->dev,
 				 np->tx_info[entry].mapping,
-				 skb_first_frag_len(skb),
-				 PCI_DMA_TODEVICE);
+				 skb_first_frag_len(skb), DMA_TO_DEVICE);
 		np->tx_info[entry].mapping = 0;
 		entry = (entry + np->tx_info[entry].used_slots) % TX_RING_SIZE;
 		for (j = 1; j < i; j++) {
-			pci_unmap_single(np->pci_dev,
+			dma_unmap_single(&np->pci_dev->dev,
 					 np->tx_info[entry].mapping,
-					 skb_frag_size(
-						&skb_shinfo(skb)->frags[j-1]),
-					 PCI_DMA_TODEVICE);
+					 skb_frag_size(&skb_shinfo(skb)->frags[j - 1]),
+					 DMA_TO_DEVICE);
 			entry++;
 		}
 	}
@@ -1356,20 +1359,20 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 				u16 entry = (tx_status & 0x7fff) / sizeof(starfire_tx_desc);
 				struct sk_buff *skb = np->tx_info[entry].skb;
 				np->tx_info[entry].skb = NULL;
-				pci_unmap_single(np->pci_dev,
+				dma_unmap_single(&np->pci_dev->dev,
 						 np->tx_info[entry].mapping,
 						 skb_first_frag_len(skb),
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 				np->tx_info[entry].mapping = 0;
 				np->dirty_tx += np->tx_info[entry].used_slots;
 				entry = (entry + np->tx_info[entry].used_slots) % TX_RING_SIZE;
 				{
 					int i;
 					for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-						pci_unmap_single(np->pci_dev,
+						dma_unmap_single(&np->pci_dev->dev,
 								 np->tx_info[entry].mapping,
 								 skb_frag_size(&skb_shinfo(skb)->frags[i]),
-								 PCI_DMA_TODEVICE);
+								 DMA_TO_DEVICE);
 						np->dirty_tx++;
 						entry++;
 					}
@@ -1461,16 +1464,18 @@ static int __netdev_rx(struct net_device *dev, int *quota)
 		if (pkt_len < rx_copybreak &&
 		    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
 			skb_reserve(skb, 2);	/* 16 byte align the IP header */
-			pci_dma_sync_single_for_cpu(np->pci_dev,
-						    np->rx_info[entry].mapping,
-						    pkt_len, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&np->pci_dev->dev,
+						np->rx_info[entry].mapping,
+						pkt_len, DMA_FROM_DEVICE);
 			skb_copy_to_linear_data(skb, np->rx_info[entry].skb->data, pkt_len);
-			pci_dma_sync_single_for_device(np->pci_dev,
-						       np->rx_info[entry].mapping,
-						       pkt_len, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&np->pci_dev->dev,
+						   np->rx_info[entry].mapping,
+						   pkt_len, DMA_FROM_DEVICE);
 			skb_put(skb, pkt_len);
 		} else {
-			pci_unmap_single(np->pci_dev, np->rx_info[entry].mapping, np->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&np->pci_dev->dev,
+					 np->rx_info[entry].mapping,
+					 np->rx_buf_sz, DMA_FROM_DEVICE);
 			skb = np->rx_info[entry].skb;
 			skb_put(skb, pkt_len);
 			np->rx_info[entry].skb = NULL;
@@ -1588,9 +1593,9 @@ static void refill_rx_ring(struct net_device *dev)
 			if (skb == NULL)
 				break;	/* Better luck next round. */
 			np->rx_info[entry].mapping =
-				pci_map_single(np->pci_dev, skb->data, np->rx_buf_sz, PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(np->pci_dev,
-						np->rx_info[entry].mapping)) {
+				dma_map_single(&np->pci_dev->dev, skb->data,
+					       np->rx_buf_sz, DMA_FROM_DEVICE);
+			if (dma_mapping_error(&np->pci_dev->dev, np->rx_info[entry].mapping)) {
 				dev_kfree_skb(skb);
 				np->rx_info[entry].skb = NULL;
 				break;
@@ -1963,7 +1968,9 @@ static int netdev_close(struct net_device *dev)
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		np->rx_ring[i].rxaddr = cpu_to_dma(0xBADF00D0); /* An invalid address. */
 		if (np->rx_info[i].skb != NULL) {
-			pci_unmap_single(np->pci_dev, np->rx_info[i].mapping, np->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&np->pci_dev->dev,
+					 np->rx_info[i].mapping,
+					 np->rx_buf_sz, DMA_FROM_DEVICE);
 			dev_kfree_skb(np->rx_info[i].skb);
 		}
 		np->rx_info[i].skb = NULL;
@@ -1973,9 +1980,8 @@ static int netdev_close(struct net_device *dev)
 		struct sk_buff *skb = np->tx_info[i].skb;
 		if (skb == NULL)
 			continue;
-		pci_unmap_single(np->pci_dev,
-				 np->tx_info[i].mapping,
-				 skb_first_frag_len(skb), PCI_DMA_TODEVICE);
+		dma_unmap_single(&np->pci_dev->dev, np->tx_info[i].mapping,
+				 skb_first_frag_len(skb), DMA_TO_DEVICE);
 		np->tx_info[i].mapping = 0;
 		dev_kfree_skb(skb);
 		np->tx_info[i].skb = NULL;
@@ -2018,7 +2024,8 @@ static void starfire_remove_one(struct pci_dev *pdev)
 	unregister_netdev(dev);
 
 	if (np->queue_mem)
-		pci_free_consistent(pdev, np->queue_mem_size, np->queue_mem, np->queue_mem_dma);
+		dma_free_coherent(&pdev->dev, np->queue_mem_size,
+				  np->queue_mem, np->queue_mem_dma);
 
 
 	/* XXX: add wakeup code -- requires firmware for MagicPacket */
-- 
2.25.1

