Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB24321E106
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 21:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGMTzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 15:55:16 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:51104 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgGMTzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 15:55:16 -0400
Received: from localhost.localdomain ([93.22.151.12])
        by mwinf5d22 with ME
        id 2jv52300C0GHuWt03jv6A5; Mon, 13 Jul 2020 21:55:10 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 13 Jul 2020 21:55:10 +0200
X-ME-IP: 93.22.151.12
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        natechancellor@gmail.com, snelson@pensando.io,
        vaibhavgupta40@gmail.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] amd8111e: switch from 'pci_' to 'dma_' API
Date:   Mon, 13 Jul 2020 21:55:03 +0200
Message-Id: <20200713195503.281339-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GPF_ with a correct flag.
It has been compile tested.

When memory is allocated in 'amd8111e_init_ring()', GFP_ATOMIC must be used
because a spin_lock is hold.
One of the call chains is:
   amd8111e_open
   ** spin_lock_irq(&lp->lock);
   --> amd8111e_restart
      --> amd8111e_init_ring
   ** spin_unlock_irq(&lp->lock);

The rest of the patch is produced by coccinelle with a few adjustments to
please checkpatch.pl.

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
 drivers/net/ethernet/amd/amd8111e.c | 81 ++++++++++++++++-------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 5d389a984394..b6c43b58ed3d 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -226,7 +226,9 @@ static int amd8111e_free_skbs(struct net_device *dev)
 	/* Freeing transmit skbs */
 	for(i = 0; i < NUM_TX_BUFFERS; i++){
 		if(lp->tx_skbuff[i]){
-			pci_unmap_single(lp->pci_dev,lp->tx_dma_addr[i],					lp->tx_skbuff[i]->len,PCI_DMA_TODEVICE);
+			dma_unmap_single(&lp->pci_dev->dev,
+					 lp->tx_dma_addr[i],
+					 lp->tx_skbuff[i]->len, DMA_TO_DEVICE);
 			dev_kfree_skb (lp->tx_skbuff[i]);
 			lp->tx_skbuff[i] = NULL;
 			lp->tx_dma_addr[i] = 0;
@@ -236,8 +238,9 @@ static int amd8111e_free_skbs(struct net_device *dev)
 	for (i = 0; i < NUM_RX_BUFFERS; i++){
 		rx_skbuff = lp->rx_skbuff[i];
 		if(rx_skbuff != NULL){
-			pci_unmap_single(lp->pci_dev,lp->rx_dma_addr[i],
-				  lp->rx_buff_len - 2,PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&lp->pci_dev->dev,
+					 lp->rx_dma_addr[i],
+					 lp->rx_buff_len - 2, DMA_FROM_DEVICE);
 			dev_kfree_skb(lp->rx_skbuff[i]);
 			lp->rx_skbuff[i] = NULL;
 			lp->rx_dma_addr[i] = 0;
@@ -287,20 +290,20 @@ static int amd8111e_init_ring(struct net_device *dev)
 		amd8111e_free_skbs(dev);
 
 	else{
-		 /* allocate the tx and rx descriptors */
-	     	if((lp->tx_ring = pci_alloc_consistent(lp->pci_dev,
-			sizeof(struct amd8111e_tx_dr)*NUM_TX_RING_DR,
-			&lp->tx_ring_dma_addr)) == NULL)
-
+		/* allocate the tx and rx descriptors */
+		lp->tx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
+			sizeof(struct amd8111e_tx_dr) * NUM_TX_RING_DR,
+			&lp->tx_ring_dma_addr, GFP_ATOMIC);
+		if (!lp->tx_ring)
 			goto err_no_mem;
 
-	     	if((lp->rx_ring = pci_alloc_consistent(lp->pci_dev,
-			sizeof(struct amd8111e_rx_dr)*NUM_RX_RING_DR,
-			&lp->rx_ring_dma_addr)) == NULL)
-
+		lp->rx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
+			sizeof(struct amd8111e_rx_dr) * NUM_RX_RING_DR,
+			&lp->rx_ring_dma_addr, GFP_ATOMIC);
+		if (!lp->rx_ring)
 			goto err_free_tx_ring;
-
 	}
+
 	/* Set new receive buff size */
 	amd8111e_set_rx_buff_len(dev);
 
@@ -318,8 +321,10 @@ static int amd8111e_init_ring(struct net_device *dev)
 	}
         /* Initilaizing receive descriptors */
 	for (i = 0; i < NUM_RX_BUFFERS; i++) {
-		lp->rx_dma_addr[i] = pci_map_single(lp->pci_dev,
-			lp->rx_skbuff[i]->data,lp->rx_buff_len-2, PCI_DMA_FROMDEVICE);
+		lp->rx_dma_addr[i] = dma_map_single(&lp->pci_dev->dev,
+						    lp->rx_skbuff[i]->data,
+						    lp->rx_buff_len - 2,
+						    DMA_FROM_DEVICE);
 
 		lp->rx_ring[i].buff_phy_addr = cpu_to_le32(lp->rx_dma_addr[i]);
 		lp->rx_ring[i].buff_count = cpu_to_le16(lp->rx_buff_len-2);
@@ -338,15 +343,15 @@ static int amd8111e_init_ring(struct net_device *dev)
 
 err_free_rx_ring:
 
-	pci_free_consistent(lp->pci_dev,
-		sizeof(struct amd8111e_rx_dr)*NUM_RX_RING_DR,lp->rx_ring,
-		lp->rx_ring_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev,
+			  sizeof(struct amd8111e_rx_dr) * NUM_RX_RING_DR,
+			  lp->rx_ring, lp->rx_ring_dma_addr);
 
 err_free_tx_ring:
 
-	pci_free_consistent(lp->pci_dev,
-		 sizeof(struct amd8111e_tx_dr)*NUM_TX_RING_DR,lp->tx_ring,
-		 lp->tx_ring_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev,
+			  sizeof(struct amd8111e_tx_dr) * NUM_TX_RING_DR,
+			  lp->tx_ring, lp->tx_ring_dma_addr);
 
 err_no_mem:
 	return -ENOMEM;
@@ -612,16 +617,16 @@ static void amd8111e_free_ring(struct amd8111e_priv *lp)
 {
 	/* Free transmit and receive descriptor rings */
 	if(lp->rx_ring){
-		pci_free_consistent(lp->pci_dev,
-			sizeof(struct amd8111e_rx_dr)*NUM_RX_RING_DR,
-			lp->rx_ring, lp->rx_ring_dma_addr);
+		dma_free_coherent(&lp->pci_dev->dev,
+				  sizeof(struct amd8111e_rx_dr) * NUM_RX_RING_DR,
+				  lp->rx_ring, lp->rx_ring_dma_addr);
 		lp->rx_ring = NULL;
 	}
 
 	if(lp->tx_ring){
-		pci_free_consistent(lp->pci_dev,
-			sizeof(struct amd8111e_tx_dr)*NUM_TX_RING_DR,
-			lp->tx_ring, lp->tx_ring_dma_addr);
+		dma_free_coherent(&lp->pci_dev->dev,
+				  sizeof(struct amd8111e_tx_dr) * NUM_TX_RING_DR,
+				  lp->tx_ring, lp->tx_ring_dma_addr);
 
 		lp->tx_ring = NULL;
 	}
@@ -649,9 +654,10 @@ static int amd8111e_tx(struct net_device *dev)
 
 		/* We must free the original skb */
 		if (lp->tx_skbuff[tx_index]) {
-			pci_unmap_single(lp->pci_dev, lp->tx_dma_addr[tx_index],
-				  	lp->tx_skbuff[tx_index]->len,
-					PCI_DMA_TODEVICE);
+			dma_unmap_single(&lp->pci_dev->dev,
+					 lp->tx_dma_addr[tx_index],
+					 lp->tx_skbuff[tx_index]->len,
+					 DMA_TO_DEVICE);
 			dev_consume_skb_irq(lp->tx_skbuff[tx_index]);
 			lp->tx_skbuff[tx_index] = NULL;
 			lp->tx_dma_addr[tx_index] = 0;
@@ -737,14 +743,14 @@ static int amd8111e_rx_poll(struct napi_struct *napi, int budget)
 
 		skb_reserve(new_skb, 2);
 		skb = lp->rx_skbuff[rx_index];
-		pci_unmap_single(lp->pci_dev,lp->rx_dma_addr[rx_index],
-				 lp->rx_buff_len-2, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&lp->pci_dev->dev, lp->rx_dma_addr[rx_index],
+				 lp->rx_buff_len - 2, DMA_FROM_DEVICE);
 		skb_put(skb, pkt_len);
 		lp->rx_skbuff[rx_index] = new_skb;
-		lp->rx_dma_addr[rx_index] = pci_map_single(lp->pci_dev,
+		lp->rx_dma_addr[rx_index] = dma_map_single(&lp->pci_dev->dev,
 							   new_skb->data,
-							   lp->rx_buff_len-2,
-							   PCI_DMA_FROMDEVICE);
+							   lp->rx_buff_len - 2,
+							   DMA_FROM_DEVICE);
 
 		skb->protocol = eth_type_trans(skb, dev);
 
@@ -1270,7 +1276,8 @@ static netdev_tx_t amd8111e_start_xmit(struct sk_buff *skb,
 	}
 #endif
 	lp->tx_dma_addr[tx_index] =
-	    pci_map_single(lp->pci_dev, skb->data, skb->len, PCI_DMA_TODEVICE);
+	    dma_map_single(&lp->pci_dev->dev, skb->data, skb->len,
+			   DMA_TO_DEVICE);
 	lp->tx_ring[tx_index].buff_phy_addr =
 	    cpu_to_le32(lp->tx_dma_addr[tx_index]);
 
@@ -1773,7 +1780,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	}
 
 	/* Initialize DMA */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) < 0) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) < 0) {
 		dev_err(&pdev->dev, "DMA not supported\n");
 		err = -ENODEV;
 		goto err_free_reg;
-- 
2.25.1

