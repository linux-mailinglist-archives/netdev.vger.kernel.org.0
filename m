Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497EC262007
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbgIHUIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:08:54 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:50437 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgIHUIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:08:50 -0400
Received: from localhost.localdomain ([93.22.150.22])
        by mwinf5d58 with ME
        id RY8h2300w0VEKhH03Y8hPA; Tue, 08 Sep 2020 22:08:46 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 08 Sep 2020 22:08:46 +0200
X-ME-IP: 93.22.150.22
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hippi@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] hippi: switch from 'pci_' to 'dma_' API
Date:   Tue,  8 Sep 2020 22:08:39 +0200
Message-Id: <20200908200839.323530-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'rr_init_one()' GFP_KERNEL can be used because
it is a probe function and no spinlock is taken in the between.

When memory is allocated in 'rr_open()' GFP_KERNEL can be used because
it is a '.ndo_open' function (see struct net_device_ops) and no spinlock is
taken in the between.
'.ndo_open' functions are synchronized using the rtnl_lock() semaphore.


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
 drivers/net/hippi/rrunner.c | 117 +++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 55 deletions(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index a4b3fce69ecd..df0f125fbb33 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -151,7 +151,8 @@ static int rr_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out;
 	}
 
-	tmpptr = pci_alloc_consistent(pdev, TX_TOTAL_SIZE, &ring_dma);
+	tmpptr = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
+				    GFP_KERNEL);
 	rrpriv->tx_ring = tmpptr;
 	rrpriv->tx_ring_dma = ring_dma;
 
@@ -160,7 +161,8 @@ static int rr_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out;
 	}
 
-	tmpptr = pci_alloc_consistent(pdev, RX_TOTAL_SIZE, &ring_dma);
+	tmpptr = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
+				    GFP_KERNEL);
 	rrpriv->rx_ring = tmpptr;
 	rrpriv->rx_ring_dma = ring_dma;
 
@@ -169,7 +171,8 @@ static int rr_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out;
 	}
 
-	tmpptr = pci_alloc_consistent(pdev, EVT_RING_SIZE, &ring_dma);
+	tmpptr = dma_alloc_coherent(&pdev->dev, EVT_RING_SIZE, &ring_dma,
+				    GFP_KERNEL);
 	rrpriv->evt_ring = tmpptr;
 	rrpriv->evt_ring_dma = ring_dma;
 
@@ -198,14 +201,14 @@ static int rr_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
  out:
 	if (rrpriv->evt_ring)
-		pci_free_consistent(pdev, EVT_RING_SIZE, rrpriv->evt_ring,
-				    rrpriv->evt_ring_dma);
+		dma_free_coherent(&pdev->dev, EVT_RING_SIZE, rrpriv->evt_ring,
+				  rrpriv->evt_ring_dma);
 	if (rrpriv->rx_ring)
-		pci_free_consistent(pdev, RX_TOTAL_SIZE, rrpriv->rx_ring,
-				    rrpriv->rx_ring_dma);
+		dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, rrpriv->rx_ring,
+				  rrpriv->rx_ring_dma);
 	if (rrpriv->tx_ring)
-		pci_free_consistent(pdev, TX_TOTAL_SIZE, rrpriv->tx_ring,
-				    rrpriv->tx_ring_dma);
+		dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, rrpriv->tx_ring,
+				  rrpriv->tx_ring_dma);
 	if (rrpriv->regs)
 		pci_iounmap(pdev, rrpriv->regs);
 	if (pdev)
@@ -228,12 +231,12 @@ static void rr_remove_one(struct pci_dev *pdev)
 	}
 
 	unregister_netdev(dev);
-	pci_free_consistent(pdev, EVT_RING_SIZE, rr->evt_ring,
-			    rr->evt_ring_dma);
-	pci_free_consistent(pdev, RX_TOTAL_SIZE, rr->rx_ring,
-			    rr->rx_ring_dma);
-	pci_free_consistent(pdev, TX_TOTAL_SIZE, rr->tx_ring,
-			    rr->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, EVT_RING_SIZE, rr->evt_ring,
+			  rr->evt_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, rr->rx_ring,
+			  rr->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, rr->tx_ring,
+			  rr->tx_ring_dma);
 	pci_iounmap(pdev, rr->regs);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -648,8 +651,8 @@ static int rr_init1(struct net_device *dev)
 			goto error;
 		}
 		rrpriv->rx_skbuff[i] = skb;
-	        addr = pci_map_single(rrpriv->pci_dev, skb->data,
-			dev->mtu + HIPPI_HLEN, PCI_DMA_FROMDEVICE);
+		addr = dma_map_single(&rrpriv->pci_dev->dev, skb->data,
+				      dev->mtu + HIPPI_HLEN, DMA_FROM_DEVICE);
 		/*
 		 * Sanity test to see if we conflict with the DMA
 		 * limitations of the Roadrunner.
@@ -699,10 +702,10 @@ static int rr_init1(struct net_device *dev)
 		struct sk_buff *skb = rrpriv->rx_skbuff[i];
 
 		if (skb) {
-	        	pci_unmap_single(rrpriv->pci_dev,
+			dma_unmap_single(&rrpriv->pci_dev->dev,
 					 rrpriv->rx_ring[i].addr.addrlo,
 					 dev->mtu + HIPPI_HLEN,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 			rrpriv->rx_ring[i].size = 0;
 			set_rraddr(&rrpriv->rx_ring[i].addr, 0);
 			dev_kfree_skb(skb);
@@ -953,18 +956,18 @@ static void rx_int(struct net_device *dev, u32 rxlimit, u32 index)
 					dev->stats.rx_dropped++;
 					goto defer;
 				} else {
-					pci_dma_sync_single_for_cpu(rrpriv->pci_dev,
-								    desc->addr.addrlo,
-								    pkt_len,
-								    PCI_DMA_FROMDEVICE);
+					dma_sync_single_for_cpu(&rrpriv->pci_dev->dev,
+								desc->addr.addrlo,
+								pkt_len,
+								DMA_FROM_DEVICE);
 
 					skb_put_data(skb, rx_skb->data,
 						     pkt_len);
 
-					pci_dma_sync_single_for_device(rrpriv->pci_dev,
-								       desc->addr.addrlo,
-								       pkt_len,
-								       PCI_DMA_FROMDEVICE);
+					dma_sync_single_for_device(&rrpriv->pci_dev->dev,
+								   desc->addr.addrlo,
+								   pkt_len,
+								   DMA_FROM_DEVICE);
 				}
 			}else{
 				struct sk_buff *newskb;
@@ -974,16 +977,17 @@ static void rx_int(struct net_device *dev, u32 rxlimit, u32 index)
 				if (newskb){
 					dma_addr_t addr;
 
-	        			pci_unmap_single(rrpriv->pci_dev,
-						desc->addr.addrlo, dev->mtu +
-						HIPPI_HLEN, PCI_DMA_FROMDEVICE);
+					dma_unmap_single(&rrpriv->pci_dev->dev,
+							 desc->addr.addrlo,
+							 dev->mtu + HIPPI_HLEN,
+							 DMA_FROM_DEVICE);
 					skb = rx_skb;
 					skb_put(skb, pkt_len);
 					rrpriv->rx_skbuff[index] = newskb;
-	        			addr = pci_map_single(rrpriv->pci_dev,
-						newskb->data,
-						dev->mtu + HIPPI_HLEN,
-						PCI_DMA_FROMDEVICE);
+					addr = dma_map_single(&rrpriv->pci_dev->dev,
+							      newskb->data,
+							      dev->mtu + HIPPI_HLEN,
+							      DMA_FROM_DEVICE);
 					set_rraddr(&desc->addr, addr);
 				} else {
 					printk("%s: Out of memory, deferring "
@@ -1068,9 +1072,9 @@ static irqreturn_t rr_interrupt(int irq, void *dev_id)
 				dev->stats.tx_packets++;
 				dev->stats.tx_bytes += skb->len;
 
-				pci_unmap_single(rrpriv->pci_dev,
+				dma_unmap_single(&rrpriv->pci_dev->dev,
 						 desc->addr.addrlo, skb->len,
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 				dev_kfree_skb_irq(skb);
 
 				rrpriv->tx_skbuff[txcon] = NULL;
@@ -1110,8 +1114,9 @@ static inline void rr_raz_tx(struct rr_private *rrpriv,
 		if (skb) {
 			struct tx_desc *desc = &(rrpriv->tx_ring[i]);
 
-	        	pci_unmap_single(rrpriv->pci_dev, desc->addr.addrlo,
-				skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&rrpriv->pci_dev->dev,
+					 desc->addr.addrlo, skb->len,
+					 DMA_TO_DEVICE);
 			desc->size = 0;
 			set_rraddr(&desc->addr, 0);
 			dev_kfree_skb(skb);
@@ -1132,8 +1137,10 @@ static inline void rr_raz_rx(struct rr_private *rrpriv,
 		if (skb) {
 			struct rx_desc *desc = &(rrpriv->rx_ring[i]);
 
-	        	pci_unmap_single(rrpriv->pci_dev, desc->addr.addrlo,
-				dev->mtu + HIPPI_HLEN, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&rrpriv->pci_dev->dev,
+					 desc->addr.addrlo,
+					 dev->mtu + HIPPI_HLEN,
+					 DMA_FROM_DEVICE);
 			desc->size = 0;
 			set_rraddr(&desc->addr, 0);
 			dev_kfree_skb(skb);
@@ -1188,17 +1195,17 @@ static int rr_open(struct net_device *dev)
 		goto error;
 	}
 
-	rrpriv->rx_ctrl = pci_alloc_consistent(pdev,
-					       256 * sizeof(struct ring_ctrl),
-					       &dma_addr);
+	rrpriv->rx_ctrl = dma_alloc_coherent(&pdev->dev,
+					     256 * sizeof(struct ring_ctrl),
+					     &dma_addr, GFP_KERNEL);
 	if (!rrpriv->rx_ctrl) {
 		ecode = -ENOMEM;
 		goto error;
 	}
 	rrpriv->rx_ctrl_dma = dma_addr;
 
-	rrpriv->info = pci_alloc_consistent(pdev, sizeof(struct rr_info),
-					    &dma_addr);
+	rrpriv->info = dma_alloc_coherent(&pdev->dev, sizeof(struct rr_info),
+					  &dma_addr, GFP_KERNEL);
 	if (!rrpriv->info) {
 		ecode = -ENOMEM;
 		goto error;
@@ -1237,13 +1244,13 @@ static int rr_open(struct net_device *dev)
 	spin_unlock_irqrestore(&rrpriv->lock, flags);
 
 	if (rrpriv->info) {
-		pci_free_consistent(pdev, sizeof(struct rr_info), rrpriv->info,
-				    rrpriv->info_dma);
+		dma_free_coherent(&pdev->dev, sizeof(struct rr_info),
+				  rrpriv->info, rrpriv->info_dma);
 		rrpriv->info = NULL;
 	}
 	if (rrpriv->rx_ctrl) {
-		pci_free_consistent(pdev, 256 * sizeof(struct ring_ctrl),
-				    rrpriv->rx_ctrl, rrpriv->rx_ctrl_dma);
+		dma_free_coherent(&pdev->dev, 256 * sizeof(struct ring_ctrl),
+				  rrpriv->rx_ctrl, rrpriv->rx_ctrl_dma);
 		rrpriv->rx_ctrl = NULL;
 	}
 
@@ -1365,12 +1372,12 @@ static int rr_close(struct net_device *dev)
 	rr_raz_tx(rrpriv, dev);
 	rr_raz_rx(rrpriv, dev);
 
-	pci_free_consistent(pdev, 256 * sizeof(struct ring_ctrl),
-			    rrpriv->rx_ctrl, rrpriv->rx_ctrl_dma);
+	dma_free_coherent(&pdev->dev, 256 * sizeof(struct ring_ctrl),
+			  rrpriv->rx_ctrl, rrpriv->rx_ctrl_dma);
 	rrpriv->rx_ctrl = NULL;
 
-	pci_free_consistent(pdev, sizeof(struct rr_info), rrpriv->info,
-			    rrpriv->info_dma);
+	dma_free_coherent(&pdev->dev, sizeof(struct rr_info), rrpriv->info,
+			  rrpriv->info_dma);
 	rrpriv->info = NULL;
 
 	spin_unlock_irqrestore(&rrpriv->lock, flags);
@@ -1430,8 +1437,8 @@ static netdev_tx_t rr_start_xmit(struct sk_buff *skb,
 	index = txctrl->pi;
 
 	rrpriv->tx_skbuff[index] = skb;
-	set_rraddr(&rrpriv->tx_ring[index].addr, pci_map_single(
-		rrpriv->pci_dev, skb->data, len + 8, PCI_DMA_TODEVICE));
+	set_rraddr(&rrpriv->tx_ring[index].addr,
+		   dma_map_single(&rrpriv->pci_dev->dev, skb->data, len + 8, DMA_TO_DEVICE));
 	rrpriv->tx_ring[index].size = len + 8; /* include IFIELD */
 	rrpriv->tx_ring[index].mode = PACKET_START | PACKET_END;
 	txctrl->pi = (index + 1) % TX_RING_ENTRIES;
-- 
2.25.1

