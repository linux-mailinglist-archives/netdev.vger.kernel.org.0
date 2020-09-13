Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C366267F88
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 14:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgIMMpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 08:45:03 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:35190 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbgIMMpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 08:45:01 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d73 with ME
        id TQkw230021Drbmd03QkwRq; Sun, 13 Sep 2020 14:44:58 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 14:44:58 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, mhabets@solarflare.com,
        arnd@arndb.de, hkallweit1@gmail.com, mdf@kernel.org,
        mst@redhat.com, vaibhavgupta40@gmail.com, leon@kernel.org
Cc:     linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tulip: de2104x: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Sep 2020 14:44:53 +0200
Message-Id: <20200913124453.355542-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'de_alloc_rings()' GFP_KERNEL can be used
because it is only called from 'de_open()' which is a '.ndo_open'
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
 drivers/net/ethernet/dec/tulip/de2104x.c | 62 ++++++++++++++----------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index cb116b530f5e..0931881403b6 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -443,21 +443,23 @@ static void de_rx (struct de_private *de)
 		}
 
 		if (!copying_skb) {
-			pci_unmap_single(de->pdev, mapping,
-					 buflen, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&de->pdev->dev, mapping, buflen,
+					 DMA_FROM_DEVICE);
 			skb_put(skb, len);
 
 			mapping =
 			de->rx_skb[rx_tail].mapping =
-				pci_map_single(de->pdev, copy_skb->data,
-					       buflen, PCI_DMA_FROMDEVICE);
+				dma_map_single(&de->pdev->dev, copy_skb->data,
+					       buflen, DMA_FROM_DEVICE);
 			de->rx_skb[rx_tail].skb = copy_skb;
 		} else {
-			pci_dma_sync_single_for_cpu(de->pdev, mapping, len, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&de->pdev->dev, mapping, len,
+						DMA_FROM_DEVICE);
 			skb_reserve(copy_skb, RX_OFFSET);
 			skb_copy_from_linear_data(skb, skb_put(copy_skb, len),
 						  len);
-			pci_dma_sync_single_for_device(de->pdev, mapping, len, PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&de->pdev->dev, mapping,
+						   len, DMA_FROM_DEVICE);
 
 			/* We'll reuse the original ring buffer. */
 			skb = copy_skb;
@@ -554,13 +556,15 @@ static void de_tx (struct de_private *de)
 			goto next;
 
 		if (unlikely(skb == DE_SETUP_SKB)) {
-			pci_unmap_single(de->pdev, de->tx_skb[tx_tail].mapping,
-					 sizeof(de->setup_frame), PCI_DMA_TODEVICE);
+			dma_unmap_single(&de->pdev->dev,
+					 de->tx_skb[tx_tail].mapping,
+					 sizeof(de->setup_frame),
+					 DMA_TO_DEVICE);
 			goto next;
 		}
 
-		pci_unmap_single(de->pdev, de->tx_skb[tx_tail].mapping,
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&de->pdev->dev, de->tx_skb[tx_tail].mapping,
+				 skb->len, DMA_TO_DEVICE);
 
 		if (status & LastFrag) {
 			if (status & TxError) {
@@ -620,7 +624,8 @@ static netdev_tx_t de_start_xmit (struct sk_buff *skb,
 	txd = &de->tx_ring[entry];
 
 	len = skb->len;
-	mapping = pci_map_single(de->pdev, skb->data, len, PCI_DMA_TODEVICE);
+	mapping = dma_map_single(&de->pdev->dev, skb->data, len,
+				 DMA_TO_DEVICE);
 	if (entry == (DE_TX_RING_SIZE - 1))
 		flags |= RingEnd;
 	if (!tx_free || (tx_free == (DE_TX_RING_SIZE / 2)))
@@ -763,8 +768,8 @@ static void __de_set_rx_mode (struct net_device *dev)
 
 	de->tx_skb[entry].skb = DE_SETUP_SKB;
 	de->tx_skb[entry].mapping = mapping =
-	    pci_map_single (de->pdev, de->setup_frame,
-			    sizeof (de->setup_frame), PCI_DMA_TODEVICE);
+	    dma_map_single(&de->pdev->dev, de->setup_frame,
+			   sizeof(de->setup_frame), DMA_TO_DEVICE);
 
 	/* Put the setup frame on the Tx list. */
 	txd = &de->tx_ring[entry];
@@ -1279,8 +1284,10 @@ static int de_refill_rx (struct de_private *de)
 		if (!skb)
 			goto err_out;
 
-		de->rx_skb[i].mapping = pci_map_single(de->pdev,
-			skb->data, de->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		de->rx_skb[i].mapping = dma_map_single(&de->pdev->dev,
+						       skb->data,
+						       de->rx_buf_sz,
+						       DMA_FROM_DEVICE);
 		de->rx_skb[i].skb = skb;
 
 		de->rx_ring[i].opts1 = cpu_to_le32(DescOwn);
@@ -1313,7 +1320,8 @@ static int de_init_rings (struct de_private *de)
 
 static int de_alloc_rings (struct de_private *de)
 {
-	de->rx_ring = pci_alloc_consistent(de->pdev, DE_RING_BYTES, &de->ring_dma);
+	de->rx_ring = dma_alloc_coherent(&de->pdev->dev, DE_RING_BYTES,
+					 &de->ring_dma, GFP_KERNEL);
 	if (!de->rx_ring)
 		return -ENOMEM;
 	de->tx_ring = &de->rx_ring[DE_RX_RING_SIZE];
@@ -1333,8 +1341,9 @@ static void de_clean_rings (struct de_private *de)
 
 	for (i = 0; i < DE_RX_RING_SIZE; i++) {
 		if (de->rx_skb[i].skb) {
-			pci_unmap_single(de->pdev, de->rx_skb[i].mapping,
-					 de->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&de->pdev->dev,
+					 de->rx_skb[i].mapping, de->rx_buf_sz,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(de->rx_skb[i].skb);
 		}
 	}
@@ -1344,15 +1353,15 @@ static void de_clean_rings (struct de_private *de)
 		if ((skb) && (skb != DE_DUMMY_SKB)) {
 			if (skb != DE_SETUP_SKB) {
 				de->dev->stats.tx_dropped++;
-				pci_unmap_single(de->pdev,
-					de->tx_skb[i].mapping,
-					skb->len, PCI_DMA_TODEVICE);
+				dma_unmap_single(&de->pdev->dev,
+						 de->tx_skb[i].mapping,
+						 skb->len, DMA_TO_DEVICE);
 				dev_kfree_skb(skb);
 			} else {
-				pci_unmap_single(de->pdev,
-					de->tx_skb[i].mapping,
-					sizeof(de->setup_frame),
-					PCI_DMA_TODEVICE);
+				dma_unmap_single(&de->pdev->dev,
+						 de->tx_skb[i].mapping,
+						 sizeof(de->setup_frame),
+						 DMA_TO_DEVICE);
 			}
 		}
 	}
@@ -1364,7 +1373,8 @@ static void de_clean_rings (struct de_private *de)
 static void de_free_rings (struct de_private *de)
 {
 	de_clean_rings(de);
-	pci_free_consistent(de->pdev, DE_RING_BYTES, de->rx_ring, de->ring_dma);
+	dma_free_coherent(&de->pdev->dev, DE_RING_BYTES, de->rx_ring,
+			  de->ring_dma);
 	de->rx_ring = NULL;
 	de->tx_ring = NULL;
 }
-- 
2.25.1

