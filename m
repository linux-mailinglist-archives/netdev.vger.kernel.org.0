Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B7E267F91
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 14:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgIMMz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 08:55:59 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:47123 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725932AbgIMMzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 08:55:54 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d73 with ME
        id TQvo230021Drbmd03Qvo3d; Sun, 13 Sep 2020 14:55:51 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 14:55:51 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, yanaijie@huawei.com,
        snelson@pensando.io, mst@redhat.com, vaibhavgupta40@gmail.com,
        leon@kernel.org
Cc:     gustavoars@kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tulip: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Sep 2020 14:55:46 +0200
Message-Id: <20200913125546.355946-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'tulip_init_one()' GFP_KERNEL can be used
because it is a probe function and no lock is taken in the between.


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
 drivers/net/ethernet/dec/tulip/interrupt.c  | 56 ++++++++++--------
 drivers/net/ethernet/dec/tulip/tulip_core.c | 65 +++++++++++----------
 2 files changed, 66 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/interrupt.c b/drivers/net/ethernet/dec/tulip/interrupt.c
index c1ca0765d56d..4ebb43eb7c1d 100644
--- a/drivers/net/ethernet/dec/tulip/interrupt.c
+++ b/drivers/net/ethernet/dec/tulip/interrupt.c
@@ -74,8 +74,8 @@ int tulip_refill_rx(struct net_device *dev)
 			if (skb == NULL)
 				break;
 
-			mapping = pci_map_single(tp->pdev, skb->data, PKT_BUF_SZ,
-						 PCI_DMA_FROMDEVICE);
+			mapping = dma_map_single(&tp->pdev->dev, skb->data,
+						 PKT_BUF_SZ, DMA_FROM_DEVICE);
 			if (dma_mapping_error(&tp->pdev->dev, mapping)) {
 				dev_kfree_skb(skb);
 				tp->rx_buffers[entry].skb = NULL;
@@ -210,9 +210,10 @@ int tulip_poll(struct napi_struct *napi, int budget)
                                if (pkt_len < tulip_rx_copybreak &&
                                    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
                                        skb_reserve(skb, 2);    /* 16 byte align the IP header */
-                                       pci_dma_sync_single_for_cpu(tp->pdev,
-								   tp->rx_buffers[entry].mapping,
-								   pkt_len, PCI_DMA_FROMDEVICE);
+					dma_sync_single_for_cpu(&tp->pdev->dev,
+								tp->rx_buffers[entry].mapping,
+								pkt_len,
+								DMA_FROM_DEVICE);
 #if ! defined(__alpha__)
                                        skb_copy_to_linear_data(skb, tp->rx_buffers[entry].skb->data,
                                                         pkt_len);
@@ -222,9 +223,10 @@ int tulip_poll(struct napi_struct *napi, int budget)
                                                     tp->rx_buffers[entry].skb->data,
                                                     pkt_len);
 #endif
-                                       pci_dma_sync_single_for_device(tp->pdev,
-								      tp->rx_buffers[entry].mapping,
-								      pkt_len, PCI_DMA_FROMDEVICE);
+					dma_sync_single_for_device(&tp->pdev->dev,
+								   tp->rx_buffers[entry].mapping,
+								   pkt_len,
+								   DMA_FROM_DEVICE);
                                } else {        /* Pass up the skb already on the Rx ring. */
                                        char *temp = skb_put(skb = tp->rx_buffers[entry].skb,
                                                             pkt_len);
@@ -240,8 +242,10 @@ int tulip_poll(struct napi_struct *napi, int budget)
                                        }
 #endif
 
-                                       pci_unmap_single(tp->pdev, tp->rx_buffers[entry].mapping,
-                                                        PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
+					dma_unmap_single(&tp->pdev->dev,
+							 tp->rx_buffers[entry].mapping,
+							 PKT_BUF_SZ,
+							 DMA_FROM_DEVICE);
 
                                        tp->rx_buffers[entry].skb = NULL;
                                        tp->rx_buffers[entry].mapping = 0;
@@ -436,9 +440,10 @@ static int tulip_rx(struct net_device *dev)
 			if (pkt_len < tulip_rx_copybreak &&
 			    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
-				pci_dma_sync_single_for_cpu(tp->pdev,
-							    tp->rx_buffers[entry].mapping,
-							    pkt_len, PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&tp->pdev->dev,
+							tp->rx_buffers[entry].mapping,
+							pkt_len,
+							DMA_FROM_DEVICE);
 #if ! defined(__alpha__)
 				skb_copy_to_linear_data(skb, tp->rx_buffers[entry].skb->data,
 						 pkt_len);
@@ -448,9 +453,10 @@ static int tulip_rx(struct net_device *dev)
 					     tp->rx_buffers[entry].skb->data,
 					     pkt_len);
 #endif
-				pci_dma_sync_single_for_device(tp->pdev,
-							       tp->rx_buffers[entry].mapping,
-							       pkt_len, PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&tp->pdev->dev,
+							   tp->rx_buffers[entry].mapping,
+							   pkt_len,
+							   DMA_FROM_DEVICE);
 			} else { 	/* Pass up the skb already on the Rx ring. */
 				char *temp = skb_put(skb = tp->rx_buffers[entry].skb,
 						     pkt_len);
@@ -466,8 +472,9 @@ static int tulip_rx(struct net_device *dev)
 				}
 #endif
 
-				pci_unmap_single(tp->pdev, tp->rx_buffers[entry].mapping,
-						 PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&tp->pdev->dev,
+						 tp->rx_buffers[entry].mapping,
+						 PKT_BUF_SZ, DMA_FROM_DEVICE);
 
 				tp->rx_buffers[entry].skb = NULL;
 				tp->rx_buffers[entry].mapping = 0;
@@ -597,10 +604,10 @@ irqreturn_t tulip_interrupt(int irq, void *dev_instance)
 				if (tp->tx_buffers[entry].skb == NULL) {
 					/* test because dummy frames not mapped */
 					if (tp->tx_buffers[entry].mapping)
-						pci_unmap_single(tp->pdev,
-							 tp->tx_buffers[entry].mapping,
-							 sizeof(tp->setup_frame),
-							 PCI_DMA_TODEVICE);
+						dma_unmap_single(&tp->pdev->dev,
+								 tp->tx_buffers[entry].mapping,
+								 sizeof(tp->setup_frame),
+								 DMA_TO_DEVICE);
 					continue;
 				}
 
@@ -629,9 +636,10 @@ irqreturn_t tulip_interrupt(int irq, void *dev_instance)
 					dev->stats.tx_packets++;
 				}
 
-				pci_unmap_single(tp->pdev, tp->tx_buffers[entry].mapping,
+				dma_unmap_single(&tp->pdev->dev,
+						 tp->tx_buffers[entry].mapping,
 						 tp->tx_buffers[entry].skb->len,
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 
 				/* Free the original skb. */
 				dev_kfree_skb_irq(tp->tx_buffers[entry].skb);
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 3a8659c5da06..e7b0d7de40fd 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -350,9 +350,9 @@ static void tulip_up(struct net_device *dev)
 		*setup_frm++ = eaddrs[1]; *setup_frm++ = eaddrs[1];
 		*setup_frm++ = eaddrs[2]; *setup_frm++ = eaddrs[2];
 
-		mapping = pci_map_single(tp->pdev, tp->setup_frame,
+		mapping = dma_map_single(&tp->pdev->dev, tp->setup_frame,
 					 sizeof(tp->setup_frame),
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 		tp->tx_buffers[tp->cur_tx].skb = NULL;
 		tp->tx_buffers[tp->cur_tx].mapping = mapping;
 
@@ -630,8 +630,8 @@ static void tulip_init_ring(struct net_device *dev)
 		tp->rx_buffers[i].skb = skb;
 		if (skb == NULL)
 			break;
-		mapping = pci_map_single(tp->pdev, skb->data,
-					 PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
+		mapping = dma_map_single(&tp->pdev->dev, skb->data,
+					 PKT_BUF_SZ, DMA_FROM_DEVICE);
 		tp->rx_buffers[i].mapping = mapping;
 		tp->rx_ring[i].status = cpu_to_le32(DescOwned);	/* Owned by Tulip chip */
 		tp->rx_ring[i].buffer1 = cpu_to_le32(mapping);
@@ -664,8 +664,8 @@ tulip_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	entry = tp->cur_tx % TX_RING_SIZE;
 
 	tp->tx_buffers[entry].skb = skb;
-	mapping = pci_map_single(tp->pdev, skb->data,
-				 skb->len, PCI_DMA_TODEVICE);
+	mapping = dma_map_single(&tp->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
 	tp->tx_buffers[entry].mapping = mapping;
 	tp->tx_ring[entry].buffer1 = cpu_to_le32(mapping);
 
@@ -716,16 +716,17 @@ static void tulip_clean_tx_ring(struct tulip_private *tp)
 		if (tp->tx_buffers[entry].skb == NULL) {
 			/* test because dummy frames not mapped */
 			if (tp->tx_buffers[entry].mapping)
-				pci_unmap_single(tp->pdev,
-					tp->tx_buffers[entry].mapping,
-					sizeof(tp->setup_frame),
-					PCI_DMA_TODEVICE);
+				dma_unmap_single(&tp->pdev->dev,
+						 tp->tx_buffers[entry].mapping,
+						 sizeof(tp->setup_frame),
+						 DMA_TO_DEVICE);
 			continue;
 		}
 
-		pci_unmap_single(tp->pdev, tp->tx_buffers[entry].mapping,
-				tp->tx_buffers[entry].skb->len,
-				PCI_DMA_TODEVICE);
+		dma_unmap_single(&tp->pdev->dev,
+				 tp->tx_buffers[entry].mapping,
+				 tp->tx_buffers[entry].skb->len,
+				 DMA_TO_DEVICE);
 
 		/* Free the original skb. */
 		dev_kfree_skb_irq(tp->tx_buffers[entry].skb);
@@ -795,8 +796,8 @@ static void tulip_free_ring (struct net_device *dev)
 		/* An invalid address. */
 		tp->rx_ring[i].buffer1 = cpu_to_le32(0xBADF00D0);
 		if (skb) {
-			pci_unmap_single(tp->pdev, mapping, PKT_BUF_SZ,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&tp->pdev->dev, mapping, PKT_BUF_SZ,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb (skb);
 		}
 	}
@@ -805,8 +806,9 @@ static void tulip_free_ring (struct net_device *dev)
 		struct sk_buff *skb = tp->tx_buffers[i].skb;
 
 		if (skb != NULL) {
-			pci_unmap_single(tp->pdev, tp->tx_buffers[i].mapping,
-					 skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&tp->pdev->dev,
+					 tp->tx_buffers[i].mapping, skb->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb (skb);
 		}
 		tp->tx_buffers[i].skb = NULL;
@@ -1149,9 +1151,10 @@ static void set_rx_mode(struct net_device *dev)
 
 			tp->tx_buffers[entry].skb = NULL;
 			tp->tx_buffers[entry].mapping =
-				pci_map_single(tp->pdev, tp->setup_frame,
+				dma_map_single(&tp->pdev->dev,
+					       tp->setup_frame,
 					       sizeof(tp->setup_frame),
-					       PCI_DMA_TODEVICE);
+					       DMA_TO_DEVICE);
 			/* Put the setup frame on the Tx list. */
 			if (entry == TX_RING_SIZE-1)
 				tx_flags |= DESC_RING_WRAP;		/* Wrap ring. */
@@ -1422,10 +1425,10 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp = netdev_priv(dev);
 	tp->dev = dev;
 
-	tp->rx_ring = pci_alloc_consistent(pdev,
-					   sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
-					   sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
-					   &tp->rx_ring_dma);
+	tp->rx_ring = dma_alloc_coherent(&pdev->dev,
+					 sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
+					 sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
+					 &tp->rx_ring_dma, GFP_KERNEL);
 	if (!tp->rx_ring)
 		goto err_out_mtable;
 	tp->tx_ring = (struct tulip_tx_desc *)(tp->rx_ring + RX_RING_SIZE);
@@ -1757,10 +1760,10 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_out_free_ring:
-	pci_free_consistent (pdev,
-			     sizeof (struct tulip_rx_desc) * RX_RING_SIZE +
-			     sizeof (struct tulip_tx_desc) * TX_RING_SIZE,
-			     tp->rx_ring, tp->rx_ring_dma);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
+			  sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
+			  tp->rx_ring, tp->rx_ring_dma);
 
 err_out_mtable:
 	kfree (tp->mtable);
@@ -1878,10 +1881,10 @@ static void tulip_remove_one(struct pci_dev *pdev)
 
 	tp = netdev_priv(dev);
 	unregister_netdev(dev);
-	pci_free_consistent (pdev,
-			     sizeof (struct tulip_rx_desc) * RX_RING_SIZE +
-			     sizeof (struct tulip_tx_desc) * TX_RING_SIZE,
-			     tp->rx_ring, tp->rx_ring_dma);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct tulip_rx_desc) * RX_RING_SIZE +
+			  sizeof(struct tulip_tx_desc) * TX_RING_SIZE,
+			  tp->rx_ring, tp->rx_ring_dma);
 	kfree (tp->mtable);
 	pci_iounmap(pdev, tp->base_addr);
 	free_netdev (dev);
-- 
2.25.1

