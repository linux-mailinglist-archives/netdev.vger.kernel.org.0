Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A0E225E8C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgGTM31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:29:27 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:51751 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgGTM30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:29:26 -0400
Received: from localhost.localdomain ([93.22.38.146])
        by mwinf5d51 with ME
        id 5QVF2300M39BigV03QVGlh; Mon, 20 Jul 2020 14:29:19 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 20 Jul 2020 14:29:19 +0200
X-ME-IP: 93.22.38.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kuba@kernel.org, davem@davemloft.net, mhabets@solarflare.com,
        hkallweit1@gmail.com, snelson@pensando.io, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: packetengines: switch from 'pci_' to 'dma_' API
Date:   Mon, 20 Jul 2020 14:29:12 +0200
Message-Id: <20200720122912.365571-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'hamachi_init_one()' (hamachi.c), GFP_KERNEL
can be used because it is a probe function and no lock is acquired.

When memory is allocated in 'yellowfin_init_one()' (yellowfin.c),
GFP_KERNEL can be used because it is a probe function and no lock is
acquired.


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
 drivers/net/ethernet/packetengines/hamachi.c  | 111 ++++++++++--------
 .../net/ethernet/packetengines/yellowfin.c    |  83 +++++++------
 2 files changed, 110 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/packetengines/hamachi.c b/drivers/net/ethernet/packetengines/hamachi.c
index 70816d2e2990..d058a63602a9 100644
--- a/drivers/net/ethernet/packetengines/hamachi.c
+++ b/drivers/net/ethernet/packetengines/hamachi.c
@@ -644,13 +644,15 @@ static int hamachi_init_one(struct pci_dev *pdev,
 	hmp->mii_if.phy_id_mask = 0x1f;
 	hmp->mii_if.reg_num_mask = 0x1f;
 
-	ring_space = pci_alloc_consistent(pdev, TX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_cleardev;
 	hmp->tx_ring = ring_space;
 	hmp->tx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent(pdev, RX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_unmap_tx;
 	hmp->rx_ring = ring_space;
@@ -773,11 +775,11 @@ static int hamachi_init_one(struct pci_dev *pdev,
 	return 0;
 
 err_out_unmap_rx:
-	pci_free_consistent(pdev, RX_TOTAL_SIZE, hmp->rx_ring,
-		hmp->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, hmp->rx_ring,
+			  hmp->rx_ring_dma);
 err_out_unmap_tx:
-	pci_free_consistent(pdev, TX_TOTAL_SIZE, hmp->tx_ring,
-		hmp->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, hmp->tx_ring,
+			  hmp->tx_ring_dma);
 err_out_cleardev:
 	free_netdev (dev);
 err_out_iounmap:
@@ -1001,9 +1003,9 @@ static inline int hamachi_tx(struct net_device *dev)
 		/* Free the original skb. */
 		skb = hmp->tx_skbuff[entry];
 		if (skb) {
-			pci_unmap_single(hmp->pci_dev,
-				leXX_to_cpu(hmp->tx_ring[entry].addr),
-				skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&hmp->pci_dev->dev,
+					 leXX_to_cpu(hmp->tx_ring[entry].addr),
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			hmp->tx_skbuff[entry] = NULL;
 		}
@@ -1093,8 +1095,9 @@ static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueue)
 			hmp->tx_ring[i].status_n_length &= cpu_to_le32(0x0000ffff);
 		skb = hmp->tx_skbuff[i];
 		if (skb){
-			pci_unmap_single(hmp->pci_dev, leXX_to_cpu(hmp->tx_ring[i].addr),
-				skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&hmp->pci_dev->dev,
+					 leXX_to_cpu(hmp->tx_ring[i].addr),
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			hmp->tx_skbuff[i] = NULL;
 		}
@@ -1115,9 +1118,9 @@ static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		struct sk_buff *skb = hmp->rx_skbuff[i];
 
 		if (skb){
-			pci_unmap_single(hmp->pci_dev,
-				leXX_to_cpu(hmp->rx_ring[i].addr),
-				hmp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&hmp->pci_dev->dev,
+					 leXX_to_cpu(hmp->rx_ring[i].addr),
+					 hmp->rx_buf_sz, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 			hmp->rx_skbuff[i] = NULL;
 		}
@@ -1131,8 +1134,10 @@ static void hamachi_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		if (skb == NULL)
 			break;
 
-                hmp->rx_ring[i].addr = cpu_to_leXX(pci_map_single(hmp->pci_dev,
-			skb->data, hmp->rx_buf_sz, PCI_DMA_FROMDEVICE));
+		hmp->rx_ring[i].addr = cpu_to_leXX(dma_map_single(&hmp->pci_dev->dev,
+								  skb->data,
+								  hmp->rx_buf_sz,
+								  DMA_FROM_DEVICE));
 		hmp->rx_ring[i].status_n_length = cpu_to_le32(DescOwn |
 			DescEndPacket | DescIntr | (hmp->rx_buf_sz - 2));
 	}
@@ -1183,8 +1188,10 @@ static void hamachi_init_ring(struct net_device *dev)
 		if (skb == NULL)
 			break;
 		skb_reserve(skb, 2); /* 16 byte align the IP header. */
-                hmp->rx_ring[i].addr = cpu_to_leXX(pci_map_single(hmp->pci_dev,
-			skb->data, hmp->rx_buf_sz, PCI_DMA_FROMDEVICE));
+		hmp->rx_ring[i].addr = cpu_to_leXX(dma_map_single(&hmp->pci_dev->dev,
+								  skb->data,
+								  hmp->rx_buf_sz,
+								  DMA_FROM_DEVICE));
 		/* -2 because it doesn't REALLY have that first 2 bytes -KDU */
 		hmp->rx_ring[i].status_n_length = cpu_to_le32(DescOwn |
 			DescEndPacket | DescIntr | (hmp->rx_buf_sz -2));
@@ -1233,8 +1240,10 @@ static netdev_tx_t hamachi_start_xmit(struct sk_buff *skb,
 
 	hmp->tx_skbuff[entry] = skb;
 
-        hmp->tx_ring[entry].addr = cpu_to_leXX(pci_map_single(hmp->pci_dev,
-		skb->data, skb->len, PCI_DMA_TODEVICE));
+	hmp->tx_ring[entry].addr = cpu_to_leXX(dma_map_single(&hmp->pci_dev->dev,
+							      skb->data,
+							      skb->len,
+							      DMA_TO_DEVICE));
 
 	/* Hmmmm, could probably put a DescIntr on these, but the way
 		the driver is currently coded makes Tx interrupts unnecessary
@@ -1333,10 +1342,10 @@ static irqreturn_t hamachi_interrupt(int irq, void *dev_instance)
 					skb = hmp->tx_skbuff[entry];
 					/* Free the original skb. */
 					if (skb){
-						pci_unmap_single(hmp->pci_dev,
-							leXX_to_cpu(hmp->tx_ring[entry].addr),
-							skb->len,
-							PCI_DMA_TODEVICE);
+						dma_unmap_single(&hmp->pci_dev->dev,
+								 leXX_to_cpu(hmp->tx_ring[entry].addr),
+								 skb->len,
+								 DMA_TO_DEVICE);
 						dev_consume_skb_irq(skb);
 						hmp->tx_skbuff[entry] = NULL;
 					}
@@ -1413,10 +1422,9 @@ static int hamachi_rx(struct net_device *dev)
 
 		if (desc_status & DescOwn)
 			break;
-		pci_dma_sync_single_for_cpu(hmp->pci_dev,
-					    leXX_to_cpu(desc->addr),
-					    hmp->rx_buf_sz,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&hmp->pci_dev->dev,
+					leXX_to_cpu(desc->addr),
+					hmp->rx_buf_sz, DMA_FROM_DEVICE);
 		buf_addr = (u8 *) hmp->rx_skbuff[entry]->data;
 		frame_status = get_unaligned_le32(&(buf_addr[data_size - 12]));
 		if (hamachi_debug > 4)
@@ -1483,10 +1491,10 @@ static int hamachi_rx(struct net_device *dev)
 				  "not good with RX_CHECKSUM\n", dev->name);
 #endif
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
-				pci_dma_sync_single_for_cpu(hmp->pci_dev,
-							    leXX_to_cpu(hmp->rx_ring[entry].addr),
-							    hmp->rx_buf_sz,
-							    PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&hmp->pci_dev->dev,
+							leXX_to_cpu(hmp->rx_ring[entry].addr),
+							hmp->rx_buf_sz,
+							DMA_FROM_DEVICE);
 				/* Call copy + cksum if available. */
 #if 1 || USE_IP_COPYSUM
 				skb_copy_to_linear_data(skb,
@@ -1496,14 +1504,15 @@ static int hamachi_rx(struct net_device *dev)
 				skb_put_data(skb, hmp->rx_ring_dma
 					     + entry*sizeof(*desc), pkt_len);
 #endif
-				pci_dma_sync_single_for_device(hmp->pci_dev,
-							       leXX_to_cpu(hmp->rx_ring[entry].addr),
-							       hmp->rx_buf_sz,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&hmp->pci_dev->dev,
+							   leXX_to_cpu(hmp->rx_ring[entry].addr),
+							   hmp->rx_buf_sz,
+							   DMA_FROM_DEVICE);
 			} else {
-				pci_unmap_single(hmp->pci_dev,
+				dma_unmap_single(&hmp->pci_dev->dev,
 						 leXX_to_cpu(hmp->rx_ring[entry].addr),
-						 hmp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+						 hmp->rx_buf_sz,
+						 DMA_FROM_DEVICE);
 				skb_put(skb = hmp->rx_skbuff[entry], pkt_len);
 				hmp->rx_skbuff[entry] = NULL;
 			}
@@ -1586,8 +1595,10 @@ static int hamachi_rx(struct net_device *dev)
 			if (skb == NULL)
 				break;		/* Better luck next round. */
 			skb_reserve(skb, 2);	/* Align IP on 16 byte boundaries */
-                	desc->addr = cpu_to_leXX(pci_map_single(hmp->pci_dev,
-				skb->data, hmp->rx_buf_sz, PCI_DMA_FROMDEVICE));
+			desc->addr = cpu_to_leXX(dma_map_single(&hmp->pci_dev->dev,
+								skb->data,
+								hmp->rx_buf_sz,
+								DMA_FROM_DEVICE));
 		}
 		desc->status_n_length = cpu_to_le32(hmp->rx_buf_sz);
 		if (entry >= RX_RING_SIZE-1)
@@ -1704,9 +1715,9 @@ static int hamachi_close(struct net_device *dev)
 		skb = hmp->rx_skbuff[i];
 		hmp->rx_ring[i].status_n_length = 0;
 		if (skb) {
-			pci_unmap_single(hmp->pci_dev,
-				leXX_to_cpu(hmp->rx_ring[i].addr),
-				hmp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&hmp->pci_dev->dev,
+					 leXX_to_cpu(hmp->rx_ring[i].addr),
+					 hmp->rx_buf_sz, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 			hmp->rx_skbuff[i] = NULL;
 		}
@@ -1715,9 +1726,9 @@ static int hamachi_close(struct net_device *dev)
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		skb = hmp->tx_skbuff[i];
 		if (skb) {
-			pci_unmap_single(hmp->pci_dev,
-				leXX_to_cpu(hmp->tx_ring[i].addr),
-				skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&hmp->pci_dev->dev,
+					 leXX_to_cpu(hmp->tx_ring[i].addr),
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			hmp->tx_skbuff[i] = NULL;
 		}
@@ -1899,10 +1910,10 @@ static void hamachi_remove_one(struct pci_dev *pdev)
 	if (dev) {
 		struct hamachi_private *hmp = netdev_priv(dev);
 
-		pci_free_consistent(pdev, RX_TOTAL_SIZE, hmp->rx_ring,
-			hmp->rx_ring_dma);
-		pci_free_consistent(pdev, TX_TOTAL_SIZE, hmp->tx_ring,
-			hmp->tx_ring_dma);
+		dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, hmp->rx_ring,
+				  hmp->rx_ring_dma);
+		dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, hmp->tx_ring,
+				  hmp->tx_ring_dma);
 		unregister_netdev(dev);
 		iounmap(hmp->base);
 		free_netdev(dev);
diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
index 520779f05e1a..647a1431b359 100644
--- a/drivers/net/ethernet/packetengines/yellowfin.c
+++ b/drivers/net/ethernet/packetengines/yellowfin.c
@@ -434,19 +434,22 @@ static int yellowfin_init_one(struct pci_dev *pdev,
 	np->drv_flags = drv_flags;
 	np->base = ioaddr;
 
-	ring_space = pci_alloc_consistent(pdev, TX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, TX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_cleardev;
 	np->tx_ring = ring_space;
 	np->tx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent(pdev, RX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, RX_TOTAL_SIZE, &ring_dma,
+					GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_unmap_tx;
 	np->rx_ring = ring_space;
 	np->rx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent(pdev, STATUS_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pdev->dev, STATUS_TOTAL_SIZE,
+					&ring_dma, GFP_KERNEL);
 	if (!ring_space)
 		goto err_out_unmap_rx;
 	np->tx_status = ring_space;
@@ -505,12 +508,14 @@ static int yellowfin_init_one(struct pci_dev *pdev,
 	return 0;
 
 err_out_unmap_status:
-        pci_free_consistent(pdev, STATUS_TOTAL_SIZE, np->tx_status,
-		np->tx_status_dma);
+	dma_free_coherent(&pdev->dev, STATUS_TOTAL_SIZE, np->tx_status,
+			  np->tx_status_dma);
 err_out_unmap_rx:
-        pci_free_consistent(pdev, RX_TOTAL_SIZE, np->rx_ring, np->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
+			  np->rx_ring_dma);
 err_out_unmap_tx:
-        pci_free_consistent(pdev, TX_TOTAL_SIZE, np->tx_ring, np->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
+			  np->tx_ring_dma);
 err_out_cleardev:
 	pci_iounmap(pdev, ioaddr);
 err_out_free_res:
@@ -740,8 +745,10 @@ static int yellowfin_init_ring(struct net_device *dev)
 		if (skb == NULL)
 			break;
 		skb_reserve(skb, 2);	/* 16 byte align the IP header. */
-		yp->rx_ring[i].addr = cpu_to_le32(pci_map_single(yp->pci_dev,
-			skb->data, yp->rx_buf_sz, PCI_DMA_FROMDEVICE));
+		yp->rx_ring[i].addr = cpu_to_le32(dma_map_single(&yp->pci_dev->dev,
+								 skb->data,
+								 yp->rx_buf_sz,
+								 DMA_FROM_DEVICE));
 	}
 	if (i != RX_RING_SIZE) {
 		for (j = 0; j < i; j++)
@@ -831,8 +838,9 @@ static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
 	yp->tx_skbuff[entry] = skb;
 
 #ifdef NO_TXSTATS
-	yp->tx_ring[entry].addr = cpu_to_le32(pci_map_single(yp->pci_dev,
-		skb->data, len, PCI_DMA_TODEVICE));
+	yp->tx_ring[entry].addr = cpu_to_le32(dma_map_single(&yp->pci_dev->dev,
+							     skb->data,
+							     len, DMA_TO_DEVICE));
 	yp->tx_ring[entry].result_status = 0;
 	if (entry >= TX_RING_SIZE-1) {
 		/* New stop command. */
@@ -847,8 +855,9 @@ static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
 	yp->cur_tx++;
 #else
 	yp->tx_ring[entry<<1].request_cnt = len;
-	yp->tx_ring[entry<<1].addr = cpu_to_le32(pci_map_single(yp->pci_dev,
-		skb->data, len, PCI_DMA_TODEVICE));
+	yp->tx_ring[entry<<1].addr = cpu_to_le32(dma_map_single(&yp->pci_dev->dev,
+								skb->data,
+								len, DMA_TO_DEVICE));
 	/* The input_last (status-write) command is constant, but we must
 	   rewrite the subsequent 'stop' command. */
 
@@ -923,8 +932,9 @@ static irqreturn_t yellowfin_interrupt(int irq, void *dev_instance)
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += skb->len;
 			/* Free the original skb. */
-			pci_unmap_single(yp->pci_dev, le32_to_cpu(yp->tx_ring[entry].addr),
-				skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&yp->pci_dev->dev,
+					 le32_to_cpu(yp->tx_ring[entry].addr),
+					 skb->len, DMA_TO_DEVICE);
 			dev_consume_skb_irq(skb);
 			yp->tx_skbuff[entry] = NULL;
 		}
@@ -980,9 +990,9 @@ static irqreturn_t yellowfin_interrupt(int irq, void *dev_instance)
 					dev->stats.tx_packets++;
 				}
 				/* Free the original skb. */
-				pci_unmap_single(yp->pci_dev,
-					yp->tx_ring[entry<<1].addr, skb->len,
-					PCI_DMA_TODEVICE);
+				dma_unmap_single(&yp->pci_dev->dev,
+						 yp->tx_ring[entry << 1].addr,
+						 skb->len, DMA_TO_DEVICE);
 				dev_consume_skb_irq(skb);
 				yp->tx_skbuff[entry] = 0;
 				/* Mark status as empty. */
@@ -1055,8 +1065,9 @@ static int yellowfin_rx(struct net_device *dev)
 
 		if(!desc->result_status)
 			break;
-		pci_dma_sync_single_for_cpu(yp->pci_dev, le32_to_cpu(desc->addr),
-			yp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&yp->pci_dev->dev,
+					le32_to_cpu(desc->addr),
+					yp->rx_buf_sz, DMA_FROM_DEVICE);
 		desc_status = le32_to_cpu(desc->result_status) >> 16;
 		buf_addr = rx_skb->data;
 		data_size = (le32_to_cpu(desc->dbdma_cmd) -
@@ -1121,10 +1132,10 @@ static int yellowfin_rx(struct net_device *dev)
 			   without copying to a properly sized skbuff. */
 			if (pkt_len > rx_copybreak) {
 				skb_put(skb = rx_skb, pkt_len);
-				pci_unmap_single(yp->pci_dev,
-					le32_to_cpu(yp->rx_ring[entry].addr),
-					yp->rx_buf_sz,
-					PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&yp->pci_dev->dev,
+						 le32_to_cpu(yp->rx_ring[entry].addr),
+						 yp->rx_buf_sz,
+						 DMA_FROM_DEVICE);
 				yp->rx_skbuff[entry] = NULL;
 			} else {
 				skb = netdev_alloc_skb(dev, pkt_len + 2);
@@ -1133,10 +1144,10 @@ static int yellowfin_rx(struct net_device *dev)
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
 				skb_copy_to_linear_data(skb, rx_skb->data, pkt_len);
 				skb_put(skb, pkt_len);
-				pci_dma_sync_single_for_device(yp->pci_dev,
-								le32_to_cpu(desc->addr),
-								yp->rx_buf_sz,
-								PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&yp->pci_dev->dev,
+							   le32_to_cpu(desc->addr),
+							   yp->rx_buf_sz,
+							   DMA_FROM_DEVICE);
 			}
 			skb->protocol = eth_type_trans(skb, dev);
 			netif_rx(skb);
@@ -1155,8 +1166,10 @@ static int yellowfin_rx(struct net_device *dev)
 				break;				/* Better luck next round. */
 			yp->rx_skbuff[entry] = skb;
 			skb_reserve(skb, 2);	/* Align IP on 16 byte boundaries */
-			yp->rx_ring[entry].addr = cpu_to_le32(pci_map_single(yp->pci_dev,
-				skb->data, yp->rx_buf_sz, PCI_DMA_FROMDEVICE));
+			yp->rx_ring[entry].addr = cpu_to_le32(dma_map_single(&yp->pci_dev->dev,
+									     skb->data,
+									     yp->rx_buf_sz,
+									     DMA_FROM_DEVICE));
 		}
 		yp->rx_ring[entry].dbdma_cmd = cpu_to_le32(CMD_STOP);
 		yp->rx_ring[entry].result_status = 0;	/* Clear complete bit. */
@@ -1379,10 +1392,12 @@ static void yellowfin_remove_one(struct pci_dev *pdev)
 	BUG_ON(!dev);
 	np = netdev_priv(dev);
 
-        pci_free_consistent(pdev, STATUS_TOTAL_SIZE, np->tx_status,
-		np->tx_status_dma);
-	pci_free_consistent(pdev, RX_TOTAL_SIZE, np->rx_ring, np->rx_ring_dma);
-	pci_free_consistent(pdev, TX_TOTAL_SIZE, np->tx_ring, np->tx_ring_dma);
+	dma_free_coherent(&pdev->dev, STATUS_TOTAL_SIZE, np->tx_status,
+			  np->tx_status_dma);
+	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, np->rx_ring,
+			  np->rx_ring_dma);
+	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, np->tx_ring,
+			  np->tx_ring_dma);
 	unregister_netdev (dev);
 
 	pci_iounmap(pdev, np->base);
-- 
2.25.1

