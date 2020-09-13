Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFE8267E06
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 07:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgIMFq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 01:46:57 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:31544 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMFqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 01:46:47 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d69 with ME
        id THmd2300A1Drbmd03Hmejg; Sun, 13 Sep 2020 07:46:41 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 07:46:41 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        vaibhavgupta40@gmail.com, gustavoars@kernel.org, arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] natsemi: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Sep 2020 07:46:28 +0200
Message-Id: <20200913054628.346243-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200912194625.345319-1-christophe.jaillet@wanadoo.fr>
References: <20200912194625.345319-1-christophe.jaillet@wanadoo.fr>From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'alloc_ring()' (natsemi.c) GFP_KERNEL can be
used because it is only called from 'netdev_open()', which is a '.ndo_open'
function. Such function are synchronized with the rtnl_lock() semaphore.

When memory is allocated in 'ns83820_init_one()' (ns83820.c) GFP_KERNEL can
be used because it is a probe function and no lock is taken in the between.


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

V2: fix description (duplicated comment and wrong file name)
---
 drivers/net/ethernet/natsemi/natsemi.c | 63 +++++++++++++-------------
 drivers/net/ethernet/natsemi/ns83820.c | 61 +++++++++++++------------
 2 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 3de8430ee8c5..05d43fd7ea98 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -1916,9 +1916,9 @@ static void ns_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static int alloc_ring(struct net_device *dev)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	np->rx_ring = pci_alloc_consistent(np->pci_dev,
-		sizeof(struct netdev_desc) * (RX_RING_SIZE+TX_RING_SIZE),
-		&np->ring_dma);
+	np->rx_ring = dma_alloc_coherent(&np->pci_dev->dev,
+					 sizeof(struct netdev_desc) * (RX_RING_SIZE + TX_RING_SIZE),
+					 &np->ring_dma, GFP_KERNEL);
 	if (!np->rx_ring)
 		return -ENOMEM;
 	np->tx_ring = &np->rx_ring[RX_RING_SIZE];
@@ -1939,10 +1939,10 @@ static void refill_rx(struct net_device *dev)
 			np->rx_skbuff[entry] = skb;
 			if (skb == NULL)
 				break; /* Better luck next round. */
-			np->rx_dma[entry] = pci_map_single(np->pci_dev,
-				skb->data, buflen, PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(np->pci_dev,
-						  np->rx_dma[entry])) {
+			np->rx_dma[entry] = dma_map_single(&np->pci_dev->dev,
+							   skb->data, buflen,
+							   DMA_FROM_DEVICE);
+			if (dma_mapping_error(&np->pci_dev->dev, np->rx_dma[entry])) {
 				dev_kfree_skb_any(skb);
 				np->rx_skbuff[entry] = NULL;
 				break; /* Better luck next round. */
@@ -2013,9 +2013,8 @@ static void drain_tx(struct net_device *dev)
 
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		if (np->tx_skbuff[i]) {
-			pci_unmap_single(np->pci_dev,
-				np->tx_dma[i], np->tx_skbuff[i]->len,
-				PCI_DMA_TODEVICE);
+			dma_unmap_single(&np->pci_dev->dev, np->tx_dma[i],
+					 np->tx_skbuff[i]->len, DMA_TO_DEVICE);
 			dev_kfree_skb(np->tx_skbuff[i]);
 			dev->stats.tx_dropped++;
 		}
@@ -2034,9 +2033,9 @@ static void drain_rx(struct net_device *dev)
 		np->rx_ring[i].cmd_status = 0;
 		np->rx_ring[i].addr = cpu_to_le32(0xBADF00D0); /* An invalid address. */
 		if (np->rx_skbuff[i]) {
-			pci_unmap_single(np->pci_dev, np->rx_dma[i],
-				buflen + NATSEMI_PADDING,
-				PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&np->pci_dev->dev, np->rx_dma[i],
+					 buflen + NATSEMI_PADDING,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(np->rx_skbuff[i]);
 		}
 		np->rx_skbuff[i] = NULL;
@@ -2052,9 +2051,9 @@ static void drain_ring(struct net_device *dev)
 static void free_ring(struct net_device *dev)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	pci_free_consistent(np->pci_dev,
-		sizeof(struct netdev_desc) * (RX_RING_SIZE+TX_RING_SIZE),
-		np->rx_ring, np->ring_dma);
+	dma_free_coherent(&np->pci_dev->dev,
+			  sizeof(struct netdev_desc) * (RX_RING_SIZE + TX_RING_SIZE),
+			  np->rx_ring, np->ring_dma);
 }
 
 static void reinit_rx(struct net_device *dev)
@@ -2101,9 +2100,9 @@ static netdev_tx_t start_tx(struct sk_buff *skb, struct net_device *dev)
 	entry = np->cur_tx % TX_RING_SIZE;
 
 	np->tx_skbuff[entry] = skb;
-	np->tx_dma[entry] = pci_map_single(np->pci_dev,
-				skb->data,skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(np->pci_dev, np->tx_dma[entry])) {
+	np->tx_dma[entry] = dma_map_single(&np->pci_dev->dev, skb->data,
+					   skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&np->pci_dev->dev, np->tx_dma[entry])) {
 		np->tx_skbuff[entry] = NULL;
 		dev_kfree_skb_irq(skb);
 		dev->stats.tx_dropped++;
@@ -2169,9 +2168,8 @@ static void netdev_tx_done(struct net_device *dev)
 				dev->stats.tx_window_errors++;
 			dev->stats.tx_errors++;
 		}
-		pci_unmap_single(np->pci_dev,np->tx_dma[entry],
-					np->tx_skbuff[entry]->len,
-					PCI_DMA_TODEVICE);
+		dma_unmap_single(&np->pci_dev->dev, np->tx_dma[entry],
+				 np->tx_skbuff[entry]->len, DMA_TO_DEVICE);
 		/* Free the original skb. */
 		dev_consume_skb_irq(np->tx_skbuff[entry]);
 		np->tx_skbuff[entry] = NULL;
@@ -2359,21 +2357,22 @@ static void netdev_rx(struct net_device *dev, int *work_done, int work_to_do)
 			    (skb = netdev_alloc_skb(dev, pkt_len + RX_OFFSET)) != NULL) {
 				/* 16 byte align the IP header */
 				skb_reserve(skb, RX_OFFSET);
-				pci_dma_sync_single_for_cpu(np->pci_dev,
-					np->rx_dma[entry],
-					buflen,
-					PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&np->pci_dev->dev,
+							np->rx_dma[entry],
+							buflen,
+							DMA_FROM_DEVICE);
 				skb_copy_to_linear_data(skb,
 					np->rx_skbuff[entry]->data, pkt_len);
 				skb_put(skb, pkt_len);
-				pci_dma_sync_single_for_device(np->pci_dev,
-					np->rx_dma[entry],
-					buflen,
-					PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&np->pci_dev->dev,
+							   np->rx_dma[entry],
+							   buflen,
+							   DMA_FROM_DEVICE);
 			} else {
-				pci_unmap_single(np->pci_dev, np->rx_dma[entry],
+				dma_unmap_single(&np->pci_dev->dev,
+						 np->rx_dma[entry],
 						 buflen + NATSEMI_PADDING,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 				skb_put(skb = np->rx_skbuff[entry], pkt_len);
 				np->rx_skbuff[entry] = NULL;
 			}
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 8e24c7acf79b..d171b5180201 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -526,8 +526,8 @@ static inline int ns83820_add_rx_skb(struct ns83820 *dev, struct sk_buff *skb)
 
 	dev->rx_info.next_empty = (next_empty + 1) % NR_RX_DESC;
 	cmdsts = REAL_RX_BUF_SIZE | CMDSTS_INTR;
-	buf = pci_map_single(dev->pci_dev, skb->data,
-			     REAL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+	buf = dma_map_single(&dev->pci_dev->dev, skb->data, REAL_RX_BUF_SIZE,
+			     DMA_FROM_DEVICE);
 	build_rx_desc(dev, sg, 0, buf, cmdsts, 0);
 	/* update link of previous rx */
 	if (likely(next_empty != dev->rx_info.next_rx))
@@ -858,8 +858,8 @@ static void rx_irq(struct net_device *ndev)
 		mb();
 		clear_rx_desc(dev, next_rx);
 
-		pci_unmap_single(dev->pci_dev, bufptr,
-				 RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&dev->pci_dev->dev, bufptr, RX_BUF_SIZE,
+				 DMA_FROM_DEVICE);
 		len = cmdsts & CMDSTS_LEN_MASK;
 #ifdef NS83820_VLAN_ACCEL_SUPPORT
 		/* NH: As was mentioned below, this chip is kinda
@@ -985,17 +985,13 @@ static void do_tx_done(struct net_device *ndev)
 		len = cmdsts & CMDSTS_LEN_MASK;
 		addr = desc_addr_get(desc + DESC_BUFPTR);
 		if (skb) {
-			pci_unmap_single(dev->pci_dev,
-					addr,
-					len,
-					PCI_DMA_TODEVICE);
+			dma_unmap_single(&dev->pci_dev->dev, addr, len,
+					 DMA_TO_DEVICE);
 			dev_consume_skb_irq(skb);
 			atomic_dec(&dev->nr_tx_skbs);
 		} else
-			pci_unmap_page(dev->pci_dev,
-					addr,
-					len,
-					PCI_DMA_TODEVICE);
+			dma_unmap_page(&dev->pci_dev->dev, addr, len,
+				       DMA_TO_DEVICE);
 
 		tx_done_idx = (tx_done_idx + 1) % NR_TX_DESC;
 		dev->tx_done_idx = tx_done_idx;
@@ -1023,10 +1019,10 @@ static void ns83820_cleanup_tx(struct ns83820 *dev)
 		dev->tx_skbs[i] = NULL;
 		if (skb) {
 			__le32 *desc = dev->tx_descs + (i * DESC_SIZE);
-			pci_unmap_single(dev->pci_dev,
-					desc_addr_get(desc + DESC_BUFPTR),
-					le32_to_cpu(desc[DESC_CMDSTS]) & CMDSTS_LEN_MASK,
-					PCI_DMA_TODEVICE);
+			dma_unmap_single(&dev->pci_dev->dev,
+					 desc_addr_get(desc + DESC_BUFPTR),
+					 le32_to_cpu(desc[DESC_CMDSTS]) & CMDSTS_LEN_MASK,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_irq(skb);
 			atomic_dec(&dev->nr_tx_skbs);
 		}
@@ -1121,7 +1117,8 @@ static netdev_tx_t ns83820_hard_start_xmit(struct sk_buff *skb,
 	len = skb->len;
 	if (nr_frags)
 		len -= skb->data_len;
-	buf = pci_map_single(dev->pci_dev, skb->data, len, PCI_DMA_TODEVICE);
+	buf = dma_map_single(&dev->pci_dev->dev, skb->data, len,
+			     DMA_TO_DEVICE);
 
 	first_desc = dev->tx_descs + (free_idx * DESC_SIZE);
 
@@ -1902,12 +1899,12 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 
 	/* See if we can set the dma mask early on; failure is fatal. */
 	if (sizeof(dma_addr_t) == 8 &&
-		!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
+		!dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-	} else if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
+	} else if (!dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 	} else {
-		dev_warn(&pci_dev->dev, "pci_set_dma_mask failed!\n");
+		dev_warn(&pci_dev->dev, "dma_set_mask failed!\n");
 		return -ENODEV;
 	}
 
@@ -1938,10 +1935,12 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	pci_set_master(pci_dev);
 	addr = pci_resource_start(pci_dev, 1);
 	dev->base = ioremap(addr, PAGE_SIZE);
-	dev->tx_descs = pci_alloc_consistent(pci_dev,
-			4 * DESC_SIZE * NR_TX_DESC, &dev->tx_phy_descs);
-	dev->rx_info.descs = pci_alloc_consistent(pci_dev,
-			4 * DESC_SIZE * NR_RX_DESC, &dev->rx_info.phy_descs);
+	dev->tx_descs = dma_alloc_coherent(&pci_dev->dev,
+					   4 * DESC_SIZE * NR_TX_DESC,
+					   &dev->tx_phy_descs, GFP_KERNEL);
+	dev->rx_info.descs = dma_alloc_coherent(&pci_dev->dev,
+						4 * DESC_SIZE * NR_RX_DESC,
+						&dev->rx_info.phy_descs, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!dev->base || !dev->tx_descs || !dev->rx_info.descs)
 		goto out_disable;
@@ -2183,8 +2182,10 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 out_disable:
 	if (dev->base)
 		iounmap(dev->base);
-	pci_free_consistent(pci_dev, 4 * DESC_SIZE * NR_TX_DESC, dev->tx_descs, dev->tx_phy_descs);
-	pci_free_consistent(pci_dev, 4 * DESC_SIZE * NR_RX_DESC, dev->rx_info.descs, dev->rx_info.phy_descs);
+	dma_free_coherent(&pci_dev->dev, 4 * DESC_SIZE * NR_TX_DESC,
+			  dev->tx_descs, dev->tx_phy_descs);
+	dma_free_coherent(&pci_dev->dev, 4 * DESC_SIZE * NR_RX_DESC,
+			  dev->rx_info.descs, dev->rx_info.phy_descs);
 	pci_disable_device(pci_dev);
 out_free:
 	free_netdev(ndev);
@@ -2205,10 +2206,10 @@ static void ns83820_remove_one(struct pci_dev *pci_dev)
 	unregister_netdev(ndev);
 	free_irq(dev->pci_dev->irq, ndev);
 	iounmap(dev->base);
-	pci_free_consistent(dev->pci_dev, 4 * DESC_SIZE * NR_TX_DESC,
-			dev->tx_descs, dev->tx_phy_descs);
-	pci_free_consistent(dev->pci_dev, 4 * DESC_SIZE * NR_RX_DESC,
-			dev->rx_info.descs, dev->rx_info.phy_descs);
+	dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_TX_DESC,
+			  dev->tx_descs, dev->tx_phy_descs);
+	dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_RX_DESC,
+			  dev->rx_info.descs, dev->rx_info.phy_descs);
 	pci_disable_device(dev->pci_dev);
 	free_netdev(ndev);
 }
-- 
2.25.1

