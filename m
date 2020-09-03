Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65EC25C9FF
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgICULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:11:01 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:45393 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728129AbgICULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:11:00 -0400
Received: from localhost.localdomain ([93.22.39.180])
        by mwinf5d73 with ME
        id PYAx230093tCsMp03YAyMu; Thu, 03 Sep 2020 22:10:59 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 03 Sep 2020 22:10:59 +0200
X-ME-IP: 93.22.39.180
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, steve.glendinning@shawell.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH RESEND] smsc9420: switch from 'pci_' to 'dma_' API
Date:   Thu,  3 Sep 2020 22:10:55 +0200
Message-Id: <20200903201055.296320-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'smsc9420_probe()', GFP_KERNEL can be used
because it is a probe function and no lock is acquired.

While at it, rewrite the size passed to 'dma_alloc_coherent()' the same way
as the one passed to 'dma_free_coherent()'. This form is less verbose:
   sizeof(struct smsc9420_dma_desc) * RX_RING_SIZE +
   sizeof(struct smsc9420_dma_desc) * TX_RING_SIZE,
vs
   sizeof(struct smsc9420_dma_desc) * (RX_RING_SIZE + TX_RING_SIZE)


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

RESEND because it was previously sent when the branch was closed
---
 drivers/net/ethernet/smsc/smsc9420.c | 51 +++++++++++++++-------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 42bef04d65ba..68969549a5c7 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -497,8 +497,9 @@ static void smsc9420_free_tx_ring(struct smsc9420_pdata *pd)
 
 		if (skb) {
 			BUG_ON(!pd->tx_buffers[i].mapping);
-			pci_unmap_single(pd->pdev, pd->tx_buffers[i].mapping,
-					 skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&pd->pdev->dev,
+					 pd->tx_buffers[i].mapping, skb->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 		}
 
@@ -530,8 +531,9 @@ static void smsc9420_free_rx_ring(struct smsc9420_pdata *pd)
 			dev_kfree_skb_any(pd->rx_buffers[i].skb);
 
 		if (pd->rx_buffers[i].mapping)
-			pci_unmap_single(pd->pdev, pd->rx_buffers[i].mapping,
-				PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&pd->pdev->dev,
+					 pd->rx_buffers[i].mapping,
+					 PKT_BUF_SZ, DMA_FROM_DEVICE);
 
 		pd->rx_ring[i].status = 0;
 		pd->rx_ring[i].length = 0;
@@ -749,8 +751,8 @@ static void smsc9420_rx_handoff(struct smsc9420_pdata *pd, const int index,
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += packet_length;
 
-	pci_unmap_single(pd->pdev, pd->rx_buffers[index].mapping,
-		PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pd->pdev->dev, pd->rx_buffers[index].mapping,
+			 PKT_BUF_SZ, DMA_FROM_DEVICE);
 	pd->rx_buffers[index].mapping = 0;
 
 	skb = pd->rx_buffers[index].skb;
@@ -782,9 +784,9 @@ static int smsc9420_alloc_rx_buffer(struct smsc9420_pdata *pd, int index)
 	if (unlikely(!skb))
 		return -ENOMEM;
 
-	mapping = pci_map_single(pd->pdev, skb_tail_pointer(skb),
-				 PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(pd->pdev, mapping)) {
+	mapping = dma_map_single(&pd->pdev->dev, skb_tail_pointer(skb),
+				 PKT_BUF_SZ, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&pd->pdev->dev, mapping)) {
 		dev_kfree_skb_any(skb);
 		netif_warn(pd, rx_err, pd->dev, "pci_map_single failed!\n");
 		return -ENOMEM;
@@ -901,8 +903,10 @@ static void smsc9420_complete_tx(struct net_device *dev)
 		BUG_ON(!pd->tx_buffers[index].skb);
 		BUG_ON(!pd->tx_buffers[index].mapping);
 
-		pci_unmap_single(pd->pdev, pd->tx_buffers[index].mapping,
-			pd->tx_buffers[index].skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&pd->pdev->dev,
+				 pd->tx_buffers[index].mapping,
+				 pd->tx_buffers[index].skb->len,
+				 DMA_TO_DEVICE);
 		pd->tx_buffers[index].mapping = 0;
 
 		dev_kfree_skb_any(pd->tx_buffers[index].skb);
@@ -932,9 +936,9 @@ static netdev_tx_t smsc9420_hard_start_xmit(struct sk_buff *skb,
 	BUG_ON(pd->tx_buffers[index].skb);
 	BUG_ON(pd->tx_buffers[index].mapping);
 
-	mapping = pci_map_single(pd->pdev, skb->data,
-				 skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(pd->pdev, mapping)) {
+	mapping = dma_map_single(&pd->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&pd->pdev->dev, mapping)) {
 		netif_warn(pd, tx_err, pd->dev,
 			   "pci_map_single failed, dropping packet\n");
 		return NETDEV_TX_BUSY;
@@ -1522,7 +1526,7 @@ smsc9420_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_free_netdev_2;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		netdev_err(dev, "No usable DMA configuration, aborting\n");
 		goto out_free_regions_3;
 	}
@@ -1540,10 +1544,9 @@ smsc9420_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pd = netdev_priv(dev);
 
 	/* pci descriptors are created in the PCI consistent area */
-	pd->rx_ring = pci_alloc_consistent(pdev,
-		sizeof(struct smsc9420_dma_desc) * RX_RING_SIZE +
-		sizeof(struct smsc9420_dma_desc) * TX_RING_SIZE,
-		&pd->rx_dma_addr);
+	pd->rx_ring = dma_alloc_coherent(&pdev->dev,
+		sizeof(struct smsc9420_dma_desc) * (RX_RING_SIZE + TX_RING_SIZE),
+		&pd->rx_dma_addr, GFP_KERNEL);
 
 	if (!pd->rx_ring)
 		goto out_free_io_4;
@@ -1599,8 +1602,9 @@ smsc9420_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 out_free_dmadesc_5:
-	pci_free_consistent(pdev, sizeof(struct smsc9420_dma_desc) *
-		(RX_RING_SIZE + TX_RING_SIZE), pd->rx_ring, pd->rx_dma_addr);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct smsc9420_dma_desc) * (RX_RING_SIZE + TX_RING_SIZE),
+			  pd->rx_ring, pd->rx_dma_addr);
 out_free_io_4:
 	iounmap(virt_addr - LAN9420_CPSR_ENDIAN_OFFSET);
 out_free_regions_3:
@@ -1632,8 +1636,9 @@ static void smsc9420_remove(struct pci_dev *pdev)
 	BUG_ON(!pd->tx_ring);
 	BUG_ON(!pd->rx_ring);
 
-	pci_free_consistent(pdev, sizeof(struct smsc9420_dma_desc) *
-		(RX_RING_SIZE + TX_RING_SIZE), pd->rx_ring, pd->rx_dma_addr);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct smsc9420_dma_desc) * (RX_RING_SIZE + TX_RING_SIZE),
+			  pd->rx_ring, pd->rx_dma_addr);
 
 	iounmap(pd->ioaddr - LAN9420_CPSR_ENDIAN_OFFSET);
 	pci_release_regions(pdev);
-- 
2.25.1

