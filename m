Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8D267E20
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 08:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIMGOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 02:14:33 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57650 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgIMGO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 02:14:28 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d69 with ME
        id TJEL230011Drbmd03JELev; Sun, 13 Sep 2020 08:14:24 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 08:14:24 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, snelson@pensando.io,
        jeffrey.t.kirsher@intel.com, mhabets@solarflare.com,
        yuehaibing@huawei.com, mchehab+huawei@kernel.org, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: dl2k: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Sep 2020 08:14:17 +0200
Message-Id: <20200913061417.347682-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'rio_probe1()' GFP_KERNEL can be used because
it is a probe function and no lock is taken in the between.


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
 drivers/net/ethernet/dlink/dl2k.c | 80 ++++++++++++++++---------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index e8e563d6e86b..734acb834c98 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -222,13 +222,15 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata (pdev, dev);
 
-	ring_space = pci_alloc_consistent (pdev, TX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_iounmap;
 	np->tx_ring = ring_space;
 	np->tx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent (pdev, RX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_unmap_tx;
 	np->rx_ring = ring_space;
@@ -279,9 +281,11 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_out_unmap_rx:
-	pci_free_consistent (pdev, RX_TOTAL_SIZE, np->rx_ring, np->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
+			  np->rx_ring_dma);
 err_out_unmap_tx:
-	pci_free_consistent (pdev, TX_TOTAL_SIZE, np->tx_ring, np->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
+			  np->tx_ring_dma);
 err_out_iounmap:
 #ifdef MEM_MAPPING
 	pci_iounmap(pdev, np->ioaddr);
@@ -435,8 +439,9 @@ static void free_list(struct net_device *dev)
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		skb = np->rx_skbuff[i];
 		if (skb) {
-			pci_unmap_single(np->pdev, desc_to_dma(&np->rx_ring[i]),
-					 skb->len, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&np->pdev->dev,
+					 desc_to_dma(&np->rx_ring[i]),
+					 skb->len, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 			np->rx_skbuff[i] = NULL;
 		}
@@ -446,8 +451,9 @@ static void free_list(struct net_device *dev)
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		skb = np->tx_skbuff[i];
 		if (skb) {
-			pci_unmap_single(np->pdev, desc_to_dma(&np->tx_ring[i]),
-					 skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&np->pdev->dev,
+					 desc_to_dma(&np->tx_ring[i]),
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			np->tx_skbuff[i] = NULL;
 		}
@@ -504,9 +510,8 @@ static int alloc_list(struct net_device *dev)
 						sizeof(struct netdev_desc));
 		/* Rubicon now supports 40 bits of addressing space. */
 		np->rx_ring[i].fraginfo =
-		    cpu_to_le64(pci_map_single(
-				  np->pdev, skb->data, np->rx_buf_sz,
-				  PCI_DMA_FROMDEVICE));
+		    cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
+					       np->rx_buf_sz, DMA_FROM_DEVICE));
 		np->rx_ring[i].fraginfo |= cpu_to_le64((u64)np->rx_buf_sz << 48);
 	}
 
@@ -672,9 +677,8 @@ rio_timer (struct timer_list *t)
 				}
 				np->rx_skbuff[entry] = skb;
 				np->rx_ring[entry].fraginfo =
-				    cpu_to_le64 (pci_map_single
-					 (np->pdev, skb->data, np->rx_buf_sz,
-					  PCI_DMA_FROMDEVICE));
+				    cpu_to_le64 (dma_map_single(&np->pdev->dev, skb->data,
+								np->rx_buf_sz, DMA_FROM_DEVICE));
 			}
 			np->rx_ring[entry].fraginfo |=
 			    cpu_to_le64((u64)np->rx_buf_sz << 48);
@@ -728,9 +732,8 @@ start_xmit (struct sk_buff *skb, struct net_device *dev)
 		    ((u64)np->vlan << 32) |
 		    ((u64)skb->priority << 45);
 	}
-	txdesc->fraginfo = cpu_to_le64 (pci_map_single (np->pdev, skb->data,
-							skb->len,
-							PCI_DMA_TODEVICE));
+	txdesc->fraginfo = cpu_to_le64 (dma_map_single(&np->pdev->dev, skb->data,
+						       skb->len, DMA_TO_DEVICE));
 	txdesc->fraginfo |= cpu_to_le64((u64)skb->len << 48);
 
 	/* DL2K bug: DMA fails to get next descriptor ptr in 10Mbps mode
@@ -827,9 +830,9 @@ rio_free_tx (struct net_device *dev, int irq)
 		if (!(np->tx_ring[entry].status & cpu_to_le64(TFDDone)))
 			break;
 		skb = np->tx_skbuff[entry];
-		pci_unmap_single (np->pdev,
-				  desc_to_dma(&np->tx_ring[entry]),
-				  skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&np->pdev->dev,
+				 desc_to_dma(&np->tx_ring[entry]), skb->len,
+				 DMA_TO_DEVICE);
 		if (irq)
 			dev_consume_skb_irq(skb);
 		else
@@ -949,25 +952,25 @@ receive_packet (struct net_device *dev)
 
 			/* Small skbuffs for short packets */
 			if (pkt_len > copy_thresh) {
-				pci_unmap_single (np->pdev,
-						  desc_to_dma(desc),
-						  np->rx_buf_sz,
-						  PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&np->pdev->dev,
+						 desc_to_dma(desc),
+						 np->rx_buf_sz,
+						 DMA_FROM_DEVICE);
 				skb_put (skb = np->rx_skbuff[entry], pkt_len);
 				np->rx_skbuff[entry] = NULL;
 			} else if ((skb = netdev_alloc_skb_ip_align(dev, pkt_len))) {
-				pci_dma_sync_single_for_cpu(np->pdev,
-							    desc_to_dma(desc),
-							    np->rx_buf_sz,
-							    PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&np->pdev->dev,
+							desc_to_dma(desc),
+							np->rx_buf_sz,
+							DMA_FROM_DEVICE);
 				skb_copy_to_linear_data (skb,
 						  np->rx_skbuff[entry]->data,
 						  pkt_len);
 				skb_put (skb, pkt_len);
-				pci_dma_sync_single_for_device(np->pdev,
-							       desc_to_dma(desc),
-							       np->rx_buf_sz,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&np->pdev->dev,
+							   desc_to_dma(desc),
+							   np->rx_buf_sz,
+							   DMA_FROM_DEVICE);
 			}
 			skb->protocol = eth_type_trans (skb, dev);
 #if 0
@@ -1000,9 +1003,8 @@ receive_packet (struct net_device *dev)
 			}
 			np->rx_skbuff[entry] = skb;
 			np->rx_ring[entry].fraginfo =
-			    cpu_to_le64 (pci_map_single
-					 (np->pdev, skb->data, np->rx_buf_sz,
-					  PCI_DMA_FROMDEVICE));
+			    cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
+						       np->rx_buf_sz, DMA_FROM_DEVICE));
 		}
 		np->rx_ring[entry].fraginfo |=
 		    cpu_to_le64((u64)np->rx_buf_sz << 48);
@@ -1796,10 +1798,10 @@ rio_remove1 (struct pci_dev *pdev)
 		struct netdev_private *np = netdev_priv(dev);
 
 		unregister_netdev (dev);
-		pci_free_consistent (pdev, RX_TOTAL_SIZE, np->rx_ring,
-				     np->rx_ring_dma);
-		pci_free_consistent (pdev, TX_TOTAL_SIZE, np->tx_ring,
-				     np->tx_ring_dma);
+		dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
+				  np->rx_ring_dma);
+		dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
+				  np->tx_ring_dma);
 #ifdef MEM_MAPPING
 		pci_iounmap(pdev, np->ioaddr);
 #endif
-- 
2.25.1

