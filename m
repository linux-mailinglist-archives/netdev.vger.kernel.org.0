Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3122260FB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGTNgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:36:19 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:27246 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgGTNgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:36:19 -0400
Received: from localhost.localdomain ([93.22.38.146])
        by mwinf5d51 with ME
        id 5RcC2300C39BigV03RcCZl; Mon, 20 Jul 2020 15:36:15 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 20 Jul 2020 15:36:15 +0200
X-ME-IP: 93.22.38.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kuba@kernel.org, davem@davemloft.net, romieu@fr.zoreil.com,
        venza@brownhat.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] sis: switch from 'pci_' to 'dma_' API
Date:   Mon, 20 Jul 2020 15:36:09 +0200
Message-Id: <20200720133609.370347-1-christophe.jaillet@wanadoo.fr>
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


When memory is allocated in 'epic_init_one()' (sis190.c), GFP_KERNEL can be
used because this is a net_device_ops' 'ndo_open' function. This function
is protected by the rtnl_lock() semaphore. So only a mutex is used and no
spin_lock is acquired.

When memory is allocated in 'sis900_probe()' (sis900.c), GFP_KERNEL can be
used because it is a probe function and no spin_lock is acquired.


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
 drivers/net/ethernet/sis/sis190.c | 52 ++++++++++--------
 drivers/net/ethernet/sis/sis900.c | 89 +++++++++++++++++--------------
 2 files changed, 80 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index 5a4b6e3ab38f..676b193833c0 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -494,9 +494,9 @@ static struct sk_buff *sis190_alloc_rx_skb(struct sis190_private *tp,
 	skb = netdev_alloc_skb(tp->dev, rx_buf_sz);
 	if (unlikely(!skb))
 		goto skb_alloc_failed;
-	mapping = pci_map_single(tp->pci_dev, skb->data, tp->rx_buf_sz,
-			PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(tp->pci_dev, mapping))
+	mapping = dma_map_single(&tp->pci_dev->dev, skb->data, tp->rx_buf_sz,
+				 DMA_FROM_DEVICE);
+	if (dma_mapping_error(&tp->pci_dev->dev, mapping))
 		goto out;
 	sis190_map_to_asic(desc, mapping, rx_buf_sz);
 
@@ -542,8 +542,8 @@ static bool sis190_try_rx_copy(struct sis190_private *tp,
 	if (!skb)
 		goto out;
 
-	pci_dma_sync_single_for_cpu(tp->pci_dev, addr, tp->rx_buf_sz,
-				PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_cpu(&tp->pci_dev->dev, addr, tp->rx_buf_sz,
+				DMA_FROM_DEVICE);
 	skb_copy_to_linear_data(skb, sk_buff[0]->data, pkt_size);
 	*sk_buff = skb;
 	done = true;
@@ -612,12 +612,14 @@ static int sis190_rx_interrupt(struct net_device *dev,
 
 
 			if (sis190_try_rx_copy(tp, &skb, pkt_size, addr)) {
-				pci_dma_sync_single_for_device(pdev, addr,
-					tp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&pdev->dev, addr,
+							   tp->rx_buf_sz,
+							   DMA_FROM_DEVICE);
 				sis190_give_to_asic(desc, tp->rx_buf_sz);
 			} else {
-				pci_unmap_single(pdev, addr, tp->rx_buf_sz,
-						 PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&pdev->dev, addr,
+						 tp->rx_buf_sz,
+						 DMA_FROM_DEVICE);
 				tp->Rx_skbuff[entry] = NULL;
 				sis190_make_unusable_by_asic(desc);
 			}
@@ -654,7 +656,8 @@ static void sis190_unmap_tx_skb(struct pci_dev *pdev, struct sk_buff *skb,
 
 	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
 
-	pci_unmap_single(pdev, le32_to_cpu(desc->addr), len, PCI_DMA_TODEVICE);
+	dma_unmap_single(&pdev->dev, le32_to_cpu(desc->addr), len,
+			 DMA_TO_DEVICE);
 
 	memset(desc, 0x00, sizeof(*desc));
 }
@@ -785,8 +788,8 @@ static void sis190_free_rx_skb(struct sis190_private *tp,
 {
 	struct pci_dev *pdev = tp->pci_dev;
 
-	pci_unmap_single(pdev, le32_to_cpu(desc->addr), tp->rx_buf_sz,
-			 PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pdev->dev, le32_to_cpu(desc->addr), tp->rx_buf_sz,
+			 DMA_FROM_DEVICE);
 	dev_kfree_skb(*sk_buff);
 	*sk_buff = NULL;
 	sis190_make_unusable_by_asic(desc);
@@ -1069,11 +1072,13 @@ static int sis190_open(struct net_device *dev)
 	 * Rx and Tx descriptors need 256 bytes alignment.
 	 * pci_alloc_consistent() guarantees a stronger alignment.
 	 */
-	tp->TxDescRing = pci_alloc_consistent(pdev, TX_RING_BYTES, &tp->tx_dma);
+	tp->TxDescRing = dma_alloc_coherent(&pdev->dev, TX_RING_BYTES,
+					    &tp->tx_dma, GFP_KERNEL);
 	if (!tp->TxDescRing)
 		goto out;
 
-	tp->RxDescRing = pci_alloc_consistent(pdev, RX_RING_BYTES, &tp->rx_dma);
+	tp->RxDescRing = dma_alloc_coherent(&pdev->dev, RX_RING_BYTES,
+					    &tp->rx_dma, GFP_KERNEL);
 	if (!tp->RxDescRing)
 		goto err_free_tx_0;
 
@@ -1095,9 +1100,11 @@ static int sis190_open(struct net_device *dev)
 	sis190_delete_timer(dev);
 	sis190_rx_clear(tp);
 err_free_rx_1:
-	pci_free_consistent(pdev, RX_RING_BYTES, tp->RxDescRing, tp->rx_dma);
+	dma_free_coherent(&pdev->dev, RX_RING_BYTES, tp->RxDescRing,
+			  tp->rx_dma);
 err_free_tx_0:
-	pci_free_consistent(pdev, TX_RING_BYTES, tp->TxDescRing, tp->tx_dma);
+	dma_free_coherent(&pdev->dev, TX_RING_BYTES, tp->TxDescRing,
+			  tp->tx_dma);
 	goto out;
 }
 
@@ -1159,8 +1166,10 @@ static int sis190_close(struct net_device *dev)
 
 	free_irq(pdev->irq, dev);
 
-	pci_free_consistent(pdev, TX_RING_BYTES, tp->TxDescRing, tp->tx_dma);
-	pci_free_consistent(pdev, RX_RING_BYTES, tp->RxDescRing, tp->rx_dma);
+	dma_free_coherent(&pdev->dev, TX_RING_BYTES, tp->TxDescRing,
+			  tp->tx_dma);
+	dma_free_coherent(&pdev->dev, RX_RING_BYTES, tp->RxDescRing,
+			  tp->rx_dma);
 
 	tp->TxDescRing = NULL;
 	tp->RxDescRing = NULL;
@@ -1197,8 +1206,9 @@ static netdev_tx_t sis190_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	mapping = pci_map_single(tp->pci_dev, skb->data, len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(tp->pci_dev, mapping)) {
+	mapping = dma_map_single(&tp->pci_dev->dev, skb->data, len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&tp->pci_dev->dev, mapping)) {
 		netif_err(tp, tx_err, dev,
 				"PCI mapping failed, dropping packet");
 		return NETDEV_TX_BUSY;
@@ -1498,7 +1508,7 @@ static struct net_device *sis190_init_board(struct pci_dev *pdev)
 		goto err_pci_disable_2;
 	}
 
-	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (rc < 0) {
 		if (netif_msg_probe(tp))
 			pr_err("%s: DMA configuration failed\n",
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 81ed7589e33c..82e020add19f 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -446,7 +446,7 @@ static int sis900_probe(struct pci_dev *pci_dev,
 	ret = pci_enable_device(pci_dev);
 	if(ret) return ret;
 
-	i = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	i = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
 	if(i){
 		printk(KERN_ERR "sis900.c: architecture does not support "
 			"32bit PCI busmaster DMA\n");
@@ -481,7 +481,8 @@ static int sis900_probe(struct pci_dev *pci_dev,
 
 	pci_set_drvdata(pci_dev, net_dev);
 
-	ring_space = pci_alloc_consistent(pci_dev, TX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pci_dev->dev, TX_TOTAL_SIZE,
+					&ring_dma, GFP_KERNEL);
 	if (!ring_space) {
 		ret = -ENOMEM;
 		goto err_out_unmap;
@@ -489,7 +490,8 @@ static int sis900_probe(struct pci_dev *pci_dev,
 	sis_priv->tx_ring = ring_space;
 	sis_priv->tx_ring_dma = ring_dma;
 
-	ring_space = pci_alloc_consistent(pci_dev, RX_TOTAL_SIZE, &ring_dma);
+	ring_space = dma_alloc_coherent(&pci_dev->dev, RX_TOTAL_SIZE,
+					&ring_dma, GFP_KERNEL);
 	if (!ring_space) {
 		ret = -ENOMEM;
 		goto err_unmap_tx;
@@ -572,11 +574,11 @@ static int sis900_probe(struct pci_dev *pci_dev,
 	return 0;
 
 err_unmap_rx:
-	pci_free_consistent(pci_dev, RX_TOTAL_SIZE, sis_priv->rx_ring,
-		sis_priv->rx_ring_dma);
+	dma_free_coherent(&pci_dev->dev, RX_TOTAL_SIZE, sis_priv->rx_ring,
+			  sis_priv->rx_ring_dma);
 err_unmap_tx:
-	pci_free_consistent(pci_dev, TX_TOTAL_SIZE, sis_priv->tx_ring,
-		sis_priv->tx_ring_dma);
+	dma_free_coherent(&pci_dev->dev, TX_TOTAL_SIZE, sis_priv->tx_ring,
+			  sis_priv->tx_ring_dma);
 err_out_unmap:
 	pci_iounmap(pci_dev, ioaddr);
 err_out_cleardev:
@@ -1188,10 +1190,12 @@ sis900_init_rx_ring(struct net_device *net_dev)
 		}
 		sis_priv->rx_skbuff[i] = skb;
 		sis_priv->rx_ring[i].cmdsts = RX_BUF_SIZE;
-		sis_priv->rx_ring[i].bufptr = pci_map_single(sis_priv->pci_dev,
-				skb->data, RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(sis_priv->pci_dev,
-				sis_priv->rx_ring[i].bufptr))) {
+		sis_priv->rx_ring[i].bufptr = dma_map_single(&sis_priv->pci_dev->dev,
+							     skb->data,
+							     RX_BUF_SIZE,
+							     DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
+					       sis_priv->rx_ring[i].bufptr))) {
 			dev_kfree_skb(skb);
 			sis_priv->rx_skbuff[i] = NULL;
 			break;
@@ -1561,9 +1565,9 @@ static void sis900_tx_timeout(struct net_device *net_dev, unsigned int txqueue)
 		struct sk_buff *skb = sis_priv->tx_skbuff[i];
 
 		if (skb) {
-			pci_unmap_single(sis_priv->pci_dev,
-				sis_priv->tx_ring[i].bufptr, skb->len,
-				PCI_DMA_TODEVICE);
+			dma_unmap_single(&sis_priv->pci_dev->dev,
+					 sis_priv->tx_ring[i].bufptr,
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_irq(skb);
 			sis_priv->tx_skbuff[i] = NULL;
 			sis_priv->tx_ring[i].cmdsts = 0;
@@ -1612,10 +1616,11 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	sis_priv->tx_skbuff[entry] = skb;
 
 	/* set the transmit buffer descriptor and enable Transmit State Machine */
-	sis_priv->tx_ring[entry].bufptr = pci_map_single(sis_priv->pci_dev,
-		skb->data, skb->len, PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sis_priv->pci_dev,
-		sis_priv->tx_ring[entry].bufptr))) {
+	sis_priv->tx_ring[entry].bufptr = dma_map_single(&sis_priv->pci_dev->dev,
+							 skb->data, skb->len,
+							 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
+				       sis_priv->tx_ring[entry].bufptr))) {
 			dev_kfree_skb_any(skb);
 			sis_priv->tx_skbuff[entry] = NULL;
 			net_dev->stats.tx_dropped++;
@@ -1778,9 +1783,9 @@ static int sis900_rx(struct net_device *net_dev)
 			struct sk_buff * skb;
 			struct sk_buff * rx_skb;
 
-			pci_unmap_single(sis_priv->pci_dev,
-				sis_priv->rx_ring[entry].bufptr, RX_BUF_SIZE,
-				PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&sis_priv->pci_dev->dev,
+					 sis_priv->rx_ring[entry].bufptr,
+					 RX_BUF_SIZE, DMA_FROM_DEVICE);
 
 			/* refill the Rx buffer, what if there is not enough
 			 * memory for new socket buffer ?? */
@@ -1826,10 +1831,11 @@ static int sis900_rx(struct net_device *net_dev)
 			sis_priv->rx_skbuff[entry] = skb;
 			sis_priv->rx_ring[entry].cmdsts = RX_BUF_SIZE;
 			sis_priv->rx_ring[entry].bufptr =
-				pci_map_single(sis_priv->pci_dev, skb->data,
-					RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(sis_priv->pci_dev,
-				sis_priv->rx_ring[entry].bufptr))) {
+				dma_map_single(&sis_priv->pci_dev->dev,
+					       skb->data, RX_BUF_SIZE,
+					       DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
+						       sis_priv->rx_ring[entry].bufptr))) {
 				dev_kfree_skb_irq(skb);
 				sis_priv->rx_skbuff[entry] = NULL;
 				break;
@@ -1860,10 +1866,11 @@ static int sis900_rx(struct net_device *net_dev)
 			sis_priv->rx_skbuff[entry] = skb;
 			sis_priv->rx_ring[entry].cmdsts = RX_BUF_SIZE;
 			sis_priv->rx_ring[entry].bufptr =
-				pci_map_single(sis_priv->pci_dev, skb->data,
-					RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(sis_priv->pci_dev,
-					sis_priv->rx_ring[entry].bufptr))) {
+				dma_map_single(&sis_priv->pci_dev->dev,
+					       skb->data, RX_BUF_SIZE,
+					       DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(&sis_priv->pci_dev->dev,
+						       sis_priv->rx_ring[entry].bufptr))) {
 				dev_kfree_skb_irq(skb);
 				sis_priv->rx_skbuff[entry] = NULL;
 				break;
@@ -1928,9 +1935,9 @@ static void sis900_finish_xmit (struct net_device *net_dev)
 		}
 		/* Free the original skb. */
 		skb = sis_priv->tx_skbuff[entry];
-		pci_unmap_single(sis_priv->pci_dev,
-			sis_priv->tx_ring[entry].bufptr, skb->len,
-			PCI_DMA_TODEVICE);
+		dma_unmap_single(&sis_priv->pci_dev->dev,
+				 sis_priv->tx_ring[entry].bufptr, skb->len,
+				 DMA_TO_DEVICE);
 		dev_consume_skb_irq(skb);
 		sis_priv->tx_skbuff[entry] = NULL;
 		sis_priv->tx_ring[entry].bufptr = 0;
@@ -1979,8 +1986,9 @@ static int sis900_close(struct net_device *net_dev)
 	for (i = 0; i < NUM_RX_DESC; i++) {
 		skb = sis_priv->rx_skbuff[i];
 		if (skb) {
-			pci_unmap_single(pdev, sis_priv->rx_ring[i].bufptr,
-					 RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&pdev->dev,
+					 sis_priv->rx_ring[i].bufptr,
+					 RX_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 			sis_priv->rx_skbuff[i] = NULL;
 		}
@@ -1988,8 +1996,9 @@ static int sis900_close(struct net_device *net_dev)
 	for (i = 0; i < NUM_TX_DESC; i++) {
 		skb = sis_priv->tx_skbuff[i];
 		if (skb) {
-			pci_unmap_single(pdev, sis_priv->tx_ring[i].bufptr,
-					 skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&pdev->dev,
+					 sis_priv->tx_ring[i].bufptr,
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			sis_priv->tx_skbuff[i] = NULL;
 		}
@@ -2484,10 +2493,10 @@ static void sis900_remove(struct pci_dev *pci_dev)
 		kfree(phy);
 	}
 
-	pci_free_consistent(pci_dev, RX_TOTAL_SIZE, sis_priv->rx_ring,
-		sis_priv->rx_ring_dma);
-	pci_free_consistent(pci_dev, TX_TOTAL_SIZE, sis_priv->tx_ring,
-		sis_priv->tx_ring_dma);
+	dma_free_coherent(&pci_dev->dev, RX_TOTAL_SIZE, sis_priv->rx_ring,
+			  sis_priv->rx_ring_dma);
+	dma_free_coherent(&pci_dev->dev, TX_TOTAL_SIZE, sis_priv->tx_ring,
+			  sis_priv->tx_ring_dma);
 	pci_iounmap(pci_dev, sis_priv->ioaddr);
 	free_netdev(net_dev);
 	pci_release_regions(pci_dev);
-- 
2.25.1

