Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596CD267F7B
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgIMMa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 08:30:56 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:52600 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbgIMMav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 08:30:51 -0400
Received: from localhost.localdomain ([93.23.14.57])
        by mwinf5d73 with ME
        id TQWk2300E1Drbmd03QWlUL; Sun, 13 Sep 2020 14:30:48 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 14:30:48 +0200
X-ME-IP: 93.23.14.57
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, natechancellor@gmail.com,
        vaibhavgupta40@gmail.com, leon@kernel.org
Cc:     linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tulip: uli526x: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Sep 2020 14:30:42 +0200
Message-Id: <20200913123042.354723-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'uli526x_init_one()' GFP_KERNEL can be used
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
 drivers/net/ethernet/dec/tulip/uli526x.c | 44 +++++++++++++-----------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index f942399f0f32..13e73ed15ef0 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -282,7 +282,7 @@ static int uli526x_init_one(struct pci_dev *pdev,
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		pr_warn("32-bit PCI DMA not available\n");
 		err = -ENODEV;
 		goto err_out_free;
@@ -317,11 +317,15 @@ static int uli526x_init_one(struct pci_dev *pdev,
 	/* Allocate Tx/Rx descriptor memory */
 	err = -ENOMEM;
 
-	db->desc_pool_ptr = pci_alloc_consistent(pdev, sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20, &db->desc_pool_dma_ptr);
+	db->desc_pool_ptr = dma_alloc_coherent(&pdev->dev,
+					       sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20,
+					       &db->desc_pool_dma_ptr, GFP_KERNEL);
 	if (!db->desc_pool_ptr)
 		goto err_out_release;
 
-	db->buf_pool_ptr = pci_alloc_consistent(pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4, &db->buf_pool_dma_ptr);
+	db->buf_pool_ptr = dma_alloc_coherent(&pdev->dev,
+					      TX_BUF_ALLOC * TX_DESC_CNT + 4,
+					      &db->buf_pool_dma_ptr, GFP_KERNEL);
 	if (!db->buf_pool_ptr)
 		goto err_out_free_tx_desc;
 
@@ -401,11 +405,12 @@ static int uli526x_init_one(struct pci_dev *pdev,
 err_out_unmap:
 	pci_iounmap(pdev, db->ioaddr);
 err_out_free_tx_buf:
-	pci_free_consistent(pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
-			    db->buf_pool_ptr, db->buf_pool_dma_ptr);
+	dma_free_coherent(&pdev->dev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
+			  db->buf_pool_ptr, db->buf_pool_dma_ptr);
 err_out_free_tx_desc:
-	pci_free_consistent(pdev, sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20,
-			    db->desc_pool_ptr, db->desc_pool_dma_ptr);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20,
+			  db->desc_pool_ptr, db->desc_pool_dma_ptr);
 err_out_release:
 	pci_release_regions(pdev);
 err_out_disable:
@@ -424,11 +429,11 @@ static void uli526x_remove_one(struct pci_dev *pdev)
 
 	unregister_netdev(dev);
 	pci_iounmap(pdev, db->ioaddr);
-	pci_free_consistent(db->pdev, sizeof(struct tx_desc) *
-				DESC_ALL_CNT + 0x20, db->desc_pool_ptr,
- 				db->desc_pool_dma_ptr);
-	pci_free_consistent(db->pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
-				db->buf_pool_ptr, db->buf_pool_dma_ptr);
+	dma_free_coherent(&db->pdev->dev,
+			  sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20,
+			  db->desc_pool_ptr, db->desc_pool_dma_ptr);
+	dma_free_coherent(&db->pdev->dev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
+			  db->buf_pool_ptr, db->buf_pool_dma_ptr);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	free_netdev(dev);
@@ -810,7 +815,8 @@ static void uli526x_rx_packet(struct net_device *dev, struct uli526x_board_info
 		db->rx_avail_cnt--;
 		db->interval_rx_cnt++;
 
-		pci_unmap_single(db->pdev, le32_to_cpu(rxptr->rdes2), RX_ALLOC_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&db->pdev->dev, le32_to_cpu(rxptr->rdes2),
+				 RX_ALLOC_SIZE, DMA_FROM_DEVICE);
 		if ( (rdes0 & 0x300) != 0x300) {
 			/* A packet without First/Last flag */
 			/* reuse this SKB */
@@ -1234,10 +1240,8 @@ static void uli526x_reuse_skb(struct uli526x_board_info *db, struct sk_buff * sk
 
 	if (!(rxptr->rdes0 & cpu_to_le32(0x80000000))) {
 		rxptr->rx_skb_ptr = skb;
-		rxptr->rdes2 = cpu_to_le32(pci_map_single(db->pdev,
-							  skb_tail_pointer(skb),
-							  RX_ALLOC_SIZE,
-							  PCI_DMA_FROMDEVICE));
+		rxptr->rdes2 = cpu_to_le32(dma_map_single(&db->pdev->dev, skb_tail_pointer(skb),
+							  RX_ALLOC_SIZE, DMA_FROM_DEVICE));
 		wmb();
 		rxptr->rdes0 = cpu_to_le32(0x80000000);
 		db->rx_avail_cnt++;
@@ -1409,10 +1413,8 @@ static void allocate_rx_buffer(struct net_device *dev)
 		if (skb == NULL)
 			break;
 		rxptr->rx_skb_ptr = skb; /* FIXME (?) */
-		rxptr->rdes2 = cpu_to_le32(pci_map_single(db->pdev,
-							  skb_tail_pointer(skb),
-							  RX_ALLOC_SIZE,
-							  PCI_DMA_FROMDEVICE));
+		rxptr->rdes2 = cpu_to_le32(dma_map_single(&db->pdev->dev, skb_tail_pointer(skb),
+							  RX_ALLOC_SIZE, DMA_FROM_DEVICE));
 		wmb();
 		rxptr->rdes0 = cpu_to_le32(0x80000000);
 		rxptr = rxptr->next_rx_desc;
-- 
2.25.1

