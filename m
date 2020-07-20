Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5863622605D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGTNCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:02:48 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:22732 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGTNCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:02:48 -0400
Received: from localhost.localdomain ([93.22.38.146])
        by mwinf5d51 with ME
        id 5R2j2300339BigV03R2jDm; Mon, 20 Jul 2020 15:02:45 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 20 Jul 2020 15:02:45 +0200
X-ME-IP: 93.22.38.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kuba@kernel.org, davem@davemloft.net, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] r6040: switch from 'pci_' to 'dma_' API
Date:   Mon, 20 Jul 2020 15:02:42 +0200
Message-Id: <20200720130242.366855-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'r6040_open()', GFP_KERNEL can be used because
this is a net_device_ops' 'ndo_open' function. This function is protected
by the rtnl_lock() semaphore. So only a mutex is used and no spin_lock is
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
 drivers/net/ethernet/rdc/r6040.c | 64 +++++++++++++++++---------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index f5ecc410ff85..7c74318620b1 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -262,9 +262,9 @@ static void r6040_free_txbufs(struct net_device *dev)
 
 	for (i = 0; i < TX_DCNT; i++) {
 		if (lp->tx_insert_ptr->skb_ptr) {
-			pci_unmap_single(lp->pdev,
-				le32_to_cpu(lp->tx_insert_ptr->buf),
-				MAX_BUF_SIZE, PCI_DMA_TODEVICE);
+			dma_unmap_single(&lp->pdev->dev,
+					 le32_to_cpu(lp->tx_insert_ptr->buf),
+					 MAX_BUF_SIZE, DMA_TO_DEVICE);
 			dev_kfree_skb(lp->tx_insert_ptr->skb_ptr);
 			lp->tx_insert_ptr->skb_ptr = NULL;
 		}
@@ -279,9 +279,9 @@ static void r6040_free_rxbufs(struct net_device *dev)
 
 	for (i = 0; i < RX_DCNT; i++) {
 		if (lp->rx_insert_ptr->skb_ptr) {
-			pci_unmap_single(lp->pdev,
-				le32_to_cpu(lp->rx_insert_ptr->buf),
-				MAX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&lp->pdev->dev,
+					 le32_to_cpu(lp->rx_insert_ptr->buf),
+					 MAX_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(lp->rx_insert_ptr->skb_ptr);
 			lp->rx_insert_ptr->skb_ptr = NULL;
 		}
@@ -335,9 +335,10 @@ static int r6040_alloc_rxbufs(struct net_device *dev)
 			goto err_exit;
 		}
 		desc->skb_ptr = skb;
-		desc->buf = cpu_to_le32(pci_map_single(lp->pdev,
-					desc->skb_ptr->data,
-					MAX_BUF_SIZE, PCI_DMA_FROMDEVICE));
+		desc->buf = cpu_to_le32(dma_map_single(&lp->pdev->dev,
+						       desc->skb_ptr->data,
+						       MAX_BUF_SIZE,
+						       DMA_FROM_DEVICE));
 		desc->status = DSC_OWNER_MAC;
 		desc = desc->vndescp;
 	} while (desc != lp->rx_ring);
@@ -484,14 +485,14 @@ static int r6040_close(struct net_device *dev)
 
 	/* Free Descriptor memory */
 	if (lp->rx_ring) {
-		pci_free_consistent(pdev,
-				RX_DESC_SIZE, lp->rx_ring, lp->rx_ring_dma);
+		dma_free_coherent(&pdev->dev, RX_DESC_SIZE, lp->rx_ring,
+				  lp->rx_ring_dma);
 		lp->rx_ring = NULL;
 	}
 
 	if (lp->tx_ring) {
-		pci_free_consistent(pdev,
-				TX_DESC_SIZE, lp->tx_ring, lp->tx_ring_dma);
+		dma_free_coherent(&pdev->dev, TX_DESC_SIZE, lp->tx_ring,
+				  lp->tx_ring_dma);
 		lp->tx_ring = NULL;
 	}
 
@@ -544,8 +545,8 @@ static int r6040_rx(struct net_device *dev, int limit)
 
 		/* Do not count the CRC */
 		skb_put(skb_ptr, descptr->len - 4);
-		pci_unmap_single(priv->pdev, le32_to_cpu(descptr->buf),
-					MAX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&priv->pdev->dev, le32_to_cpu(descptr->buf),
+				 MAX_BUF_SIZE, DMA_FROM_DEVICE);
 		skb_ptr->protocol = eth_type_trans(skb_ptr, priv->dev);
 
 		/* Send to upper layer */
@@ -555,9 +556,10 @@ static int r6040_rx(struct net_device *dev, int limit)
 
 		/* put new skb into descriptor */
 		descptr->skb_ptr = new_skb;
-		descptr->buf = cpu_to_le32(pci_map_single(priv->pdev,
-						descptr->skb_ptr->data,
-					MAX_BUF_SIZE, PCI_DMA_FROMDEVICE));
+		descptr->buf = cpu_to_le32(dma_map_single(&priv->pdev->dev,
+							  descptr->skb_ptr->data,
+							  MAX_BUF_SIZE,
+							  DMA_FROM_DEVICE));
 
 next_descr:
 		/* put the descriptor back to the MAC */
@@ -597,8 +599,8 @@ static void r6040_tx(struct net_device *dev)
 		dev->stats.tx_packets++;
 		dev->stats.tx_bytes += skb_ptr->len;
 
-		pci_unmap_single(priv->pdev, le32_to_cpu(descptr->buf),
-			skb_ptr->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev, le32_to_cpu(descptr->buf),
+				 skb_ptr->len, DMA_TO_DEVICE);
 		/* Free buffer */
 		dev_kfree_skb(skb_ptr);
 		descptr->skb_ptr = NULL;
@@ -750,14 +752,16 @@ static int r6040_open(struct net_device *dev)
 
 	/* Allocate Descriptor memory */
 	lp->rx_ring =
-		pci_alloc_consistent(lp->pdev, RX_DESC_SIZE, &lp->rx_ring_dma);
+		dma_alloc_coherent(&lp->pdev->dev, RX_DESC_SIZE,
+				   &lp->rx_ring_dma, GFP_KERNEL);
 	if (!lp->rx_ring) {
 		ret = -ENOMEM;
 		goto err_free_irq;
 	}
 
 	lp->tx_ring =
-		pci_alloc_consistent(lp->pdev, TX_DESC_SIZE, &lp->tx_ring_dma);
+		dma_alloc_coherent(&lp->pdev->dev, TX_DESC_SIZE,
+				   &lp->tx_ring_dma, GFP_KERNEL);
 	if (!lp->tx_ring) {
 		ret = -ENOMEM;
 		goto err_free_rx_ring;
@@ -773,11 +777,11 @@ static int r6040_open(struct net_device *dev)
 	return 0;
 
 err_free_tx_ring:
-	pci_free_consistent(lp->pdev, TX_DESC_SIZE, lp->tx_ring,
-			lp->tx_ring_dma);
+	dma_free_coherent(&lp->pdev->dev, TX_DESC_SIZE, lp->tx_ring,
+			  lp->tx_ring_dma);
 err_free_rx_ring:
-	pci_free_consistent(lp->pdev, RX_DESC_SIZE, lp->rx_ring,
-			lp->rx_ring_dma);
+	dma_free_coherent(&lp->pdev->dev, RX_DESC_SIZE, lp->rx_ring,
+			  lp->rx_ring_dma);
 err_free_irq:
 	free_irq(dev->irq, dev);
 out:
@@ -811,8 +815,8 @@ static netdev_tx_t r6040_start_xmit(struct sk_buff *skb,
 	descptr = lp->tx_insert_ptr;
 	descptr->len = skb->len;
 	descptr->skb_ptr = skb;
-	descptr->buf = cpu_to_le32(pci_map_single(lp->pdev,
-		skb->data, skb->len, PCI_DMA_TODEVICE));
+	descptr->buf = cpu_to_le32(dma_map_single(&lp->pdev->dev, skb->data,
+						  skb->len, DMA_TO_DEVICE));
 	descptr->status = DSC_OWNER_MAC;
 
 	skb_tx_timestamp(skb);
@@ -1029,12 +1033,12 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out;
 
 	/* this should always be supported */
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(&pdev->dev, "32-bit PCI DMA addresses not supported by the card\n");
 		goto err_out_disable_dev;
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(&pdev->dev, "32-bit PCI DMA addresses not supported by the card\n");
 		goto err_out_disable_dev;
-- 
2.25.1

