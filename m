Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D388F267977
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 12:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgILKZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 06:25:28 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:22254 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgILKZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 06:25:27 -0400
Received: from localhost.localdomain ([93.22.150.101])
        by mwinf5d66 with ME
        id SyRN230082BWSNM03yRNMu; Sat, 12 Sep 2020 12:25:25 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Sep 2020 12:25:25 +0200
X-ME-IP: 93.22.150.101
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, andy@greyhouse.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tlan: switch from 'pci_' to 'dma_' API
Date:   Sat, 12 Sep 2020 12:25:18 +0200
Message-Id: <20200912102519.337303-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'tlan_init()' GFP_KERNEL can be used because
it is only called from a probe function or a module_init function and no
lock is taken in the between.
The call chain is:
  tlan_probe                        (module_init function)
    --> tlan_eisa_probe
or
  tlan_init_one                     (probe function)

then in both cases:
    --> tlan_probe1
      --> tlan_init


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
 drivers/net/ethernet/ti/tlan.c | 61 ++++++++++++++++------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 76a342ea3797..1203a3c0febb 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -305,9 +305,8 @@ static void tlan_remove_one(struct pci_dev *pdev)
 	unregister_netdev(dev);
 
 	if (priv->dma_storage) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->dma_size, priv->dma_storage,
-				    priv->dma_storage_dma);
+		dma_free_coherent(&priv->pci_dev->dev, priv->dma_size,
+				  priv->dma_storage, priv->dma_storage_dma);
 	}
 
 #ifdef CONFIG_PCI
@@ -482,7 +481,7 @@ static int tlan_probe1(struct pci_dev *pdev, long ioaddr, int irq, int rev,
 
 		priv->adapter = &board_info[ent->driver_data];
 
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (rc) {
 			pr_err("No suitable PCI mapping available\n");
 			goto err_out_free_dev;
@@ -584,8 +583,8 @@ static int tlan_probe1(struct pci_dev *pdev, long ioaddr, int irq, int rev,
 	return 0;
 
 err_out_uninit:
-	pci_free_consistent(priv->pci_dev, priv->dma_size, priv->dma_storage,
-			    priv->dma_storage_dma);
+	dma_free_coherent(&priv->pci_dev->dev, priv->dma_size,
+			  priv->dma_storage, priv->dma_storage_dma);
 err_out_free_dev:
 	free_netdev(dev);
 err_out_regions:
@@ -609,9 +608,9 @@ static void tlan_eisa_cleanup(void)
 		dev = tlan_eisa_devices;
 		priv = netdev_priv(dev);
 		if (priv->dma_storage) {
-			pci_free_consistent(priv->pci_dev, priv->dma_size,
-					    priv->dma_storage,
-					    priv->dma_storage_dma);
+			dma_free_coherent(&priv->pci_dev->dev, priv->dma_size,
+					  priv->dma_storage,
+					  priv->dma_storage_dma);
 		}
 		release_region(dev->base_addr, 0x10);
 		unregister_netdev(dev);
@@ -826,9 +825,8 @@ static int tlan_init(struct net_device *dev)
 
 	dma_size = (TLAN_NUM_RX_LISTS + TLAN_NUM_TX_LISTS)
 		* (sizeof(struct tlan_list));
-	priv->dma_storage = pci_alloc_consistent(priv->pci_dev,
-						 dma_size,
-						 &priv->dma_storage_dma);
+	priv->dma_storage = dma_alloc_coherent(&priv->pci_dev->dev, dma_size,
+					       &priv->dma_storage_dma, GFP_KERNEL);
 	priv->dma_size = dma_size;
 
 	if (priv->dma_storage == NULL) {
@@ -1069,9 +1067,9 @@ static netdev_tx_t tlan_start_tx(struct sk_buff *skb, struct net_device *dev)
 
 	tail_list->forward = 0;
 
-	tail_list->buffer[0].address = pci_map_single(priv->pci_dev,
+	tail_list->buffer[0].address = dma_map_single(&priv->pci_dev->dev,
 						      skb->data, txlen,
-						      PCI_DMA_TODEVICE);
+						      DMA_TO_DEVICE);
 	tlan_store_skb(tail_list, skb);
 
 	tail_list->frame_size = (u16) txlen;
@@ -1365,10 +1363,10 @@ static u32 tlan_handle_tx_eof(struct net_device *dev, u16 host_int)
 		struct sk_buff *skb = tlan_get_skb(head_list);
 
 		ack++;
-		pci_unmap_single(priv->pci_dev, head_list->buffer[0].address,
-				 max(skb->len,
-				     (unsigned int)TLAN_MIN_FRAME_SIZE),
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pci_dev->dev,
+				 head_list->buffer[0].address,
+				 max(skb->len, (unsigned int)TLAN_MIN_FRAME_SIZE),
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		head_list->buffer[8].address = 0;
 		head_list->buffer[9].address = 0;
@@ -1511,8 +1509,8 @@ static u32 tlan_handle_rx_eof(struct net_device *dev, u16 host_int)
 			goto drop_and_reuse;
 
 		skb = tlan_get_skb(head_list);
-		pci_unmap_single(priv->pci_dev, frame_dma,
-				 TLAN_MAX_FRAME_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&priv->pci_dev->dev, frame_dma,
+				 TLAN_MAX_FRAME_SIZE, DMA_FROM_DEVICE);
 		skb_put(skb, frame_size);
 
 		dev->stats.rx_bytes += frame_size;
@@ -1521,8 +1519,8 @@ static u32 tlan_handle_rx_eof(struct net_device *dev, u16 host_int)
 		netif_rx(skb);
 
 		head_list->buffer[0].address =
-			pci_map_single(priv->pci_dev, new_skb->data,
-				       TLAN_MAX_FRAME_SIZE, PCI_DMA_FROMDEVICE);
+			dma_map_single(&priv->pci_dev->dev, new_skb->data,
+				       TLAN_MAX_FRAME_SIZE, DMA_FROM_DEVICE);
 
 		tlan_store_skb(head_list, new_skb);
 drop_and_reuse:
@@ -1923,10 +1921,10 @@ static void tlan_reset_lists(struct net_device *dev)
 		if (!skb)
 			break;
 
-		list->buffer[0].address = pci_map_single(priv->pci_dev,
+		list->buffer[0].address = dma_map_single(&priv->pci_dev->dev,
 							 skb->data,
 							 TLAN_MAX_FRAME_SIZE,
-							 PCI_DMA_FROMDEVICE);
+							 DMA_FROM_DEVICE);
 		tlan_store_skb(list, skb);
 		list->buffer[1].count = 0;
 		list->buffer[1].address = 0;
@@ -1954,12 +1952,10 @@ static void tlan_free_lists(struct net_device *dev)
 		list = priv->tx_list + i;
 		skb = tlan_get_skb(list);
 		if (skb) {
-			pci_unmap_single(
-				priv->pci_dev,
-				list->buffer[0].address,
-				max(skb->len,
-				    (unsigned int)TLAN_MIN_FRAME_SIZE),
-				PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pci_dev->dev,
+					 list->buffer[0].address,
+					 max(skb->len, (unsigned int)TLAN_MIN_FRAME_SIZE),
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			list->buffer[8].address = 0;
 			list->buffer[9].address = 0;
@@ -1970,10 +1966,9 @@ static void tlan_free_lists(struct net_device *dev)
 		list = priv->rx_list + i;
 		skb = tlan_get_skb(list);
 		if (skb) {
-			pci_unmap_single(priv->pci_dev,
+			dma_unmap_single(&priv->pci_dev->dev,
 					 list->buffer[0].address,
-					 TLAN_MAX_FRAME_SIZE,
-					 PCI_DMA_FROMDEVICE);
+					 TLAN_MAX_FRAME_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			list->buffer[8].address = 0;
 			list->buffer[9].address = 0;
-- 
2.25.1

