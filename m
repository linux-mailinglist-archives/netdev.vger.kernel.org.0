Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA1221E14D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGMUSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:18:53 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:21565 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgGMUSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:18:53 -0400
Received: from localhost.localdomain ([93.22.151.12])
        by mwinf5d22 with ME
        id 2kJo230030GHuWt03kJoYs; Mon, 13 Jul 2020 22:18:49 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 13 Jul 2020 22:18:49 +0200
X-ME-IP: 93.22.151.12
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, pcnet32@frontier.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] pcnet32: switch from 'pci_' to 'dma_' API
Date:   Mon, 13 Jul 2020 22:18:45 +0200
Message-Id: <20200713201846.282847-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'pcnet32_realloc_tx_ring()' and
'pcnet32_realloc_rx_ring()', GFP_ATOMIC must be used because a spin_lock is
hold.
The call chain is:
   pcnet32_set_ringparam
   ** spin_lock_irqsave(&lp->lock, flags);
   --> pcnet32_realloc_tx_ring
   --> pcnet32_realloc_rx_ring
   ** spin_unlock_irqrestore(&lp->lock, flags);

When memory is in 'pcnet32_probe1()' and 'pcnet32_alloc_ring()', GFP_KERNEL
can be used.

While at it, update a few comments and pr_err messages to be more in line
with the new function names.


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
 drivers/net/ethernet/amd/pcnet32.c | 181 +++++++++++++----------------
 1 file changed, 84 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index f47140391f67..187b0b9a6e1d 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -250,7 +250,7 @@ struct pcnet32_access {
 
 /*
  * The first field of pcnet32_private is read by the ethernet device
- * so the structure should be allocated using pci_alloc_consistent().
+ * so the structure should be allocated using dma_alloc_coherent().
  */
 struct pcnet32_private {
 	struct pcnet32_init_block *init_block;
@@ -258,7 +258,7 @@ struct pcnet32_private {
 	struct pcnet32_rx_head	*rx_ring;
 	struct pcnet32_tx_head	*tx_ring;
 	dma_addr_t		init_dma_addr;/* DMA address of beginning of the init block,
-				   returned by pci_alloc_consistent */
+				   returned by dma_alloc_coherent */
 	struct pci_dev		*pci_dev;
 	const char		*name;
 	/* The saved address of a sent-in-place packet/buffer, for skfree(). */
@@ -485,9 +485,9 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 	pcnet32_purge_tx_ring(dev);
 
 	new_tx_ring =
-		pci_zalloc_consistent(lp->pci_dev,
-				      sizeof(struct pcnet32_tx_head) * entries,
-				      &new_ring_dma_addr);
+		dma_alloc_coherent(&lp->pci_dev->dev,
+				   sizeof(struct pcnet32_tx_head) * entries,
+				   &new_ring_dma_addr, GFP_ATOMIC);
 	if (new_tx_ring == NULL)
 		return;
 
@@ -501,9 +501,9 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 
 	kfree(lp->tx_skbuff);
 	kfree(lp->tx_dma_addr);
-	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
-			    lp->tx_ring, lp->tx_ring_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev,
+			  sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
+			  lp->tx_ring, lp->tx_ring_dma_addr);
 
 	lp->tx_ring_size = entries;
 	lp->tx_mod_mask = lp->tx_ring_size - 1;
@@ -517,10 +517,9 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 free_new_lists:
 	kfree(new_dma_addr_list);
 free_new_tx_ring:
-	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_tx_head) * entries,
-			    new_tx_ring,
-			    new_ring_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev,
+			  sizeof(struct pcnet32_tx_head) * entries,
+			  new_tx_ring, new_ring_dma_addr);
 }
 
 /*
@@ -545,9 +544,9 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 	unsigned int entries = BIT(size);
 
 	new_rx_ring =
-		pci_zalloc_consistent(lp->pci_dev,
-				      sizeof(struct pcnet32_rx_head) * entries,
-				      &new_ring_dma_addr);
+		dma_alloc_coherent(&lp->pci_dev->dev,
+				   sizeof(struct pcnet32_rx_head) * entries,
+				   &new_ring_dma_addr, GFP_ATOMIC);
 	if (new_rx_ring == NULL)
 		return;
 
@@ -580,10 +579,9 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 		skb_reserve(rx_skbuff, NET_IP_ALIGN);
 
 		new_dma_addr_list[new] =
-			    pci_map_single(lp->pci_dev, rx_skbuff->data,
-					   PKT_BUF_SIZE, PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(lp->pci_dev,
-					  new_dma_addr_list[new])) {
+			    dma_map_single(&lp->pci_dev->dev, rx_skbuff->data,
+					   PKT_BUF_SIZE, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&lp->pci_dev->dev, new_dma_addr_list[new])) {
 			netif_err(lp, drv, dev, "%s dma mapping failed\n",
 				  __func__);
 			dev_kfree_skb(new_skb_list[new]);
@@ -596,22 +594,20 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 	/* and free any unneeded buffers */
 	for (; new < lp->rx_ring_size; new++) {
 		if (lp->rx_skbuff[new]) {
-			if (!pci_dma_mapping_error(lp->pci_dev,
-						   lp->rx_dma_addr[new]))
-				pci_unmap_single(lp->pci_dev,
+			if (!dma_mapping_error(&lp->pci_dev->dev, lp->rx_dma_addr[new]))
+				dma_unmap_single(&lp->pci_dev->dev,
 						 lp->rx_dma_addr[new],
 						 PKT_BUF_SIZE,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 			dev_kfree_skb(lp->rx_skbuff[new]);
 		}
 	}
 
 	kfree(lp->rx_skbuff);
 	kfree(lp->rx_dma_addr);
-	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_rx_head) *
-			    lp->rx_ring_size, lp->rx_ring,
-			    lp->rx_ring_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev,
+			  sizeof(struct pcnet32_rx_head) * lp->rx_ring_size,
+			  lp->rx_ring, lp->rx_ring_dma_addr);
 
 	lp->rx_ring_size = entries;
 	lp->rx_mod_mask = lp->rx_ring_size - 1;
@@ -625,12 +621,11 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 free_all_new:
 	while (--new >= lp->rx_ring_size) {
 		if (new_skb_list[new]) {
-			if (!pci_dma_mapping_error(lp->pci_dev,
-						   new_dma_addr_list[new]))
-				pci_unmap_single(lp->pci_dev,
+			if (!dma_mapping_error(&lp->pci_dev->dev, new_dma_addr_list[new]))
+				dma_unmap_single(&lp->pci_dev->dev,
 						 new_dma_addr_list[new],
 						 PKT_BUF_SIZE,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 			dev_kfree_skb(new_skb_list[new]);
 		}
 	}
@@ -638,10 +633,9 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 free_new_lists:
 	kfree(new_dma_addr_list);
 free_new_rx_ring:
-	pci_free_consistent(lp->pci_dev,
-			    sizeof(struct pcnet32_rx_head) * entries,
-			    new_rx_ring,
-			    new_ring_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev,
+			  sizeof(struct pcnet32_rx_head) * entries,
+			  new_rx_ring, new_ring_dma_addr);
 }
 
 static void pcnet32_purge_rx_ring(struct net_device *dev)
@@ -654,12 +648,11 @@ static void pcnet32_purge_rx_ring(struct net_device *dev)
 		lp->rx_ring[i].status = 0;	/* CPU owns buffer */
 		wmb();		/* Make sure adapter sees owner change */
 		if (lp->rx_skbuff[i]) {
-			if (!pci_dma_mapping_error(lp->pci_dev,
-						   lp->rx_dma_addr[i]))
-				pci_unmap_single(lp->pci_dev,
+			if (!dma_mapping_error(&lp->pci_dev->dev, lp->rx_dma_addr[i]))
+				dma_unmap_single(&lp->pci_dev->dev,
 						 lp->rx_dma_addr[i],
 						 PKT_BUF_SIZE,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 			dev_kfree_skb_any(lp->rx_skbuff[i]);
 		}
 		lp->rx_skbuff[i] = NULL;
@@ -1036,9 +1029,9 @@ static int pcnet32_loopback_test(struct net_device *dev, uint64_t * data1)
 			*packet++ = i;
 
 		lp->tx_dma_addr[x] =
-			pci_map_single(lp->pci_dev, skb->data, skb->len,
-				       PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(lp->pci_dev, lp->tx_dma_addr[x])) {
+			dma_map_single(&lp->pci_dev->dev, skb->data, skb->len,
+				       DMA_TO_DEVICE);
+		if (dma_mapping_error(&lp->pci_dev->dev, lp->tx_dma_addr[x])) {
 			netif_printk(lp, hw, KERN_DEBUG, dev,
 				     "DMA mapping error at line: %d!\n",
 				     __LINE__);
@@ -1226,21 +1219,21 @@ static void pcnet32_rx_entry(struct net_device *dev,
 		 */
 		if (newskb) {
 			skb_reserve(newskb, NET_IP_ALIGN);
-			new_dma_addr = pci_map_single(lp->pci_dev,
+			new_dma_addr = dma_map_single(&lp->pci_dev->dev,
 						      newskb->data,
 						      PKT_BUF_SIZE,
-						      PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(lp->pci_dev, new_dma_addr)) {
+						      DMA_FROM_DEVICE);
+			if (dma_mapping_error(&lp->pci_dev->dev, new_dma_addr)) {
 				netif_err(lp, rx_err, dev,
 					  "DMA mapping error.\n");
 				dev_kfree_skb(newskb);
 				skb = NULL;
 			} else {
 				skb = lp->rx_skbuff[entry];
-				pci_unmap_single(lp->pci_dev,
+				dma_unmap_single(&lp->pci_dev->dev,
 						 lp->rx_dma_addr[entry],
 						 PKT_BUF_SIZE,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 				skb_put(skb, pkt_len);
 				lp->rx_skbuff[entry] = newskb;
 				lp->rx_dma_addr[entry] = new_dma_addr;
@@ -1259,17 +1252,15 @@ static void pcnet32_rx_entry(struct net_device *dev,
 	if (!rx_in_place) {
 		skb_reserve(skb, NET_IP_ALIGN);
 		skb_put(skb, pkt_len);	/* Make room */
-		pci_dma_sync_single_for_cpu(lp->pci_dev,
-					    lp->rx_dma_addr[entry],
-					    pkt_len,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&lp->pci_dev->dev,
+					lp->rx_dma_addr[entry], pkt_len,
+					DMA_FROM_DEVICE);
 		skb_copy_to_linear_data(skb,
 				 (unsigned char *)(lp->rx_skbuff[entry]->data),
 				 pkt_len);
-		pci_dma_sync_single_for_device(lp->pci_dev,
-					       lp->rx_dma_addr[entry],
-					       pkt_len,
-					       PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&lp->pci_dev->dev,
+					   lp->rx_dma_addr[entry], pkt_len,
+					   DMA_FROM_DEVICE);
 	}
 	dev->stats.rx_bytes += skb->len;
 	skb->protocol = eth_type_trans(skb, dev);
@@ -1358,10 +1349,10 @@ static int pcnet32_tx(struct net_device *dev)
 
 		/* We must free the original skb */
 		if (lp->tx_skbuff[entry]) {
-			pci_unmap_single(lp->pci_dev,
+			dma_unmap_single(&lp->pci_dev->dev,
 					 lp->tx_dma_addr[entry],
-					 lp->tx_skbuff[entry]->
-					 len, PCI_DMA_TODEVICE);
+					 lp->tx_skbuff[entry]->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(lp->tx_skbuff[entry]);
 			lp->tx_skbuff[entry] = NULL;
 			lp->tx_dma_addr[entry] = 0;
@@ -1551,7 +1542,7 @@ pcnet32_probe_pci(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_disable_dev;
 	}
 
-	err = pci_set_dma_mask(pdev, PCNET32_DMA_MASK);
+	err = dma_set_mask(&pdev->dev, PCNET32_DMA_MASK);
 	if (err) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
@@ -1834,12 +1825,13 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 
 	dev->base_addr = ioaddr;
 	lp = netdev_priv(dev);
-	/* pci_alloc_consistent returns page-aligned memory, so we do not have to check the alignment */
-	lp->init_block = pci_alloc_consistent(pdev, sizeof(*lp->init_block),
-					      &lp->init_dma_addr);
+	/* dma_alloc_coherent returns page-aligned memory, so we do not have to check the alignment */
+	lp->init_block = dma_alloc_coherent(&pdev->dev,
+					    sizeof(*lp->init_block),
+					    &lp->init_dma_addr, GFP_KERNEL);
 	if (!lp->init_block) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
-			pr_err("Consistent memory allocation failed\n");
+			pr_err("Coherent memory allocation failed\n");
 		ret = -ENOMEM;
 		goto err_free_netdev;
 	}
@@ -1998,8 +1990,8 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 
 err_free_ring:
 	pcnet32_free_ring(dev);
-	pci_free_consistent(lp->pci_dev, sizeof(*lp->init_block),
-			    lp->init_block, lp->init_dma_addr);
+	dma_free_coherent(&lp->pci_dev->dev, sizeof(*lp->init_block),
+			  lp->init_block, lp->init_dma_addr);
 err_free_netdev:
 	free_netdev(dev);
 err_release_region:
@@ -2012,21 +2004,19 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 {
 	struct pcnet32_private *lp = netdev_priv(dev);
 
-	lp->tx_ring = pci_alloc_consistent(lp->pci_dev,
-					   sizeof(struct pcnet32_tx_head) *
-					   lp->tx_ring_size,
-					   &lp->tx_ring_dma_addr);
+	lp->tx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
+					 sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
+					 &lp->tx_ring_dma_addr, GFP_KERNEL);
 	if (lp->tx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+		netif_err(lp, drv, dev, "Coherent memory allocation failed\n");
 		return -ENOMEM;
 	}
 
-	lp->rx_ring = pci_alloc_consistent(lp->pci_dev,
-					   sizeof(struct pcnet32_rx_head) *
-					   lp->rx_ring_size,
-					   &lp->rx_ring_dma_addr);
+	lp->rx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
+					 sizeof(struct pcnet32_rx_head) * lp->rx_ring_size,
+					 &lp->rx_ring_dma_addr, GFP_KERNEL);
 	if (lp->rx_ring == NULL) {
-		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
+		netif_err(lp, drv, dev, "Coherent memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -2070,18 +2060,16 @@ static void pcnet32_free_ring(struct net_device *dev)
 	lp->rx_dma_addr = NULL;
 
 	if (lp->tx_ring) {
-		pci_free_consistent(lp->pci_dev,
-				    sizeof(struct pcnet32_tx_head) *
-				    lp->tx_ring_size, lp->tx_ring,
-				    lp->tx_ring_dma_addr);
+		dma_free_coherent(&lp->pci_dev->dev,
+				  sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
+				  lp->tx_ring, lp->tx_ring_dma_addr);
 		lp->tx_ring = NULL;
 	}
 
 	if (lp->rx_ring) {
-		pci_free_consistent(lp->pci_dev,
-				    sizeof(struct pcnet32_rx_head) *
-				    lp->rx_ring_size, lp->rx_ring,
-				    lp->rx_ring_dma_addr);
+		dma_free_coherent(&lp->pci_dev->dev,
+				  sizeof(struct pcnet32_rx_head) * lp->rx_ring_size,
+				  lp->rx_ring, lp->rx_ring_dma_addr);
 		lp->rx_ring = NULL;
 	}
 }
@@ -2342,12 +2330,11 @@ static void pcnet32_purge_tx_ring(struct net_device *dev)
 		lp->tx_ring[i].status = 0;	/* CPU owns buffer */
 		wmb();		/* Make sure adapter sees owner change */
 		if (lp->tx_skbuff[i]) {
-			if (!pci_dma_mapping_error(lp->pci_dev,
-						   lp->tx_dma_addr[i]))
-				pci_unmap_single(lp->pci_dev,
+			if (!dma_mapping_error(&lp->pci_dev->dev, lp->tx_dma_addr[i]))
+				dma_unmap_single(&lp->pci_dev->dev,
 						 lp->tx_dma_addr[i],
 						 lp->tx_skbuff[i]->len,
-						 PCI_DMA_TODEVICE);
+						 DMA_TO_DEVICE);
 			dev_kfree_skb_any(lp->tx_skbuff[i]);
 		}
 		lp->tx_skbuff[i] = NULL;
@@ -2382,10 +2369,9 @@ static int pcnet32_init_ring(struct net_device *dev)
 		rmb();
 		if (lp->rx_dma_addr[i] == 0) {
 			lp->rx_dma_addr[i] =
-			    pci_map_single(lp->pci_dev, rx_skbuff->data,
-					   PKT_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(lp->pci_dev,
-						  lp->rx_dma_addr[i])) {
+			    dma_map_single(&lp->pci_dev->dev, rx_skbuff->data,
+					   PKT_BUF_SIZE, DMA_FROM_DEVICE);
+			if (dma_mapping_error(&lp->pci_dev->dev, lp->rx_dma_addr[i])) {
 				/* there is not much we can do at this point */
 				netif_err(lp, drv, dev,
 					  "%s pci dma mapping error\n",
@@ -2523,8 +2509,9 @@ static netdev_tx_t pcnet32_start_xmit(struct sk_buff *skb,
 	lp->tx_ring[entry].misc = 0x00000000;
 
 	lp->tx_dma_addr[entry] =
-	    pci_map_single(lp->pci_dev, skb->data, skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(lp->pci_dev, lp->tx_dma_addr[entry])) {
+	    dma_map_single(&lp->pci_dev->dev, skb->data, skb->len,
+			   DMA_TO_DEVICE);
+	if (dma_mapping_error(&lp->pci_dev->dev, lp->tx_dma_addr[entry])) {
 		dev_kfree_skb_any(skb);
 		dev->stats.tx_dropped++;
 		goto drop_packet;
@@ -2947,8 +2934,8 @@ static void pcnet32_remove_one(struct pci_dev *pdev)
 		unregister_netdev(dev);
 		pcnet32_free_ring(dev);
 		release_region(dev->base_addr, PCNET32_TOTAL_SIZE);
-		pci_free_consistent(lp->pci_dev, sizeof(*lp->init_block),
-				    lp->init_block, lp->init_dma_addr);
+		dma_free_coherent(&lp->pci_dev->dev, sizeof(*lp->init_block),
+				  lp->init_block, lp->init_dma_addr);
 		free_netdev(dev);
 		pci_disable_device(pdev);
 	}
@@ -3030,8 +3017,8 @@ static void __exit pcnet32_cleanup_module(void)
 		unregister_netdev(pcnet32_dev);
 		pcnet32_free_ring(pcnet32_dev);
 		release_region(pcnet32_dev->base_addr, PCNET32_TOTAL_SIZE);
-		pci_free_consistent(lp->pci_dev, sizeof(*lp->init_block),
-				    lp->init_block, lp->init_dma_addr);
+		dma_free_coherent(&lp->pci_dev->dev, sizeof(*lp->init_block),
+				  lp->init_block, lp->init_dma_addr);
 		free_netdev(pcnet32_dev);
 		pcnet32_dev = next_dev;
 	}
-- 
2.25.1

