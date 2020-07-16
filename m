Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7B1222B7E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgGPTFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:05:53 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:52582 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgGPTFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:05:53 -0400
Received: from localhost.localdomain ([93.22.39.121])
        by mwinf5d33 with ME
        id 3v5g230032cqCS503v5g58; Thu, 16 Jul 2020 21:05:48 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 16 Jul 2020 21:05:48 +0200
X-ME-IP: 93.22.39.121
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        jgg@ziepe.ca, chao@kernel.org, wu000273@umn.edu,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        vaibhavgupta40@gmail.com, jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: sun: cassini: switch from 'pci_' to 'dma_' API
Date:   Thu, 16 Jul 2020 21:03:58 +0200
Message-Id: <20200716190358.318180-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'cas_tx_tiny_alloc()', GFP_KERNEL can be used
because a few lines below in its only caller, 'cas_alloc_rxds()', is also
called. This function makes an explicit use of GFP_KERNEL.

When memory is allocated in 'cas_init_one()', GFP_KERNEL can be used
because it is a probe function and no lock is acquired.


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
 drivers/net/ethernet/sun/cassini.c | 104 +++++++++++++++--------------
 1 file changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index e04c3d73a246..e2bc7a25f6d1 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -443,8 +443,8 @@ static void cas_phy_powerdown(struct cas *cp)
 /* cp->lock held. note: the last put_page will free the buffer */
 static int cas_page_free(struct cas *cp, cas_page_t *page)
 {
-	pci_unmap_page(cp->pdev, page->dma_addr, cp->page_size,
-		       PCI_DMA_FROMDEVICE);
+	dma_unmap_page(&cp->pdev->dev, page->dma_addr, cp->page_size,
+		       DMA_FROM_DEVICE);
 	__free_pages(page->buffer, cp->page_order);
 	kfree(page);
 	return 0;
@@ -474,8 +474,8 @@ static cas_page_t *cas_page_alloc(struct cas *cp, const gfp_t flags)
 	page->buffer = alloc_pages(flags, cp->page_order);
 	if (!page->buffer)
 		goto page_err;
-	page->dma_addr = pci_map_page(cp->pdev, page->buffer, 0,
-				      cp->page_size, PCI_DMA_FROMDEVICE);
+	page->dma_addr = dma_map_page(&cp->pdev->dev, page->buffer, 0,
+				      cp->page_size, DMA_FROM_DEVICE);
 	return page;
 
 page_err:
@@ -1863,8 +1863,8 @@ static inline void cas_tx_ringN(struct cas *cp, int ring, int limit)
 			daddr = le64_to_cpu(txd->buffer);
 			dlen = CAS_VAL(TX_DESC_BUFLEN,
 				       le64_to_cpu(txd->control));
-			pci_unmap_page(cp->pdev, daddr, dlen,
-				       PCI_DMA_TODEVICE);
+			dma_unmap_page(&cp->pdev->dev, daddr, dlen,
+				       DMA_TO_DEVICE);
 			entry = TX_DESC_NEXT(ring, entry);
 
 			/* tiny buffer may follow */
@@ -1957,12 +1957,13 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		i = hlen;
 		if (!dlen) /* attach FCS */
 			i += cp->crc_size;
-		pci_dma_sync_single_for_cpu(cp->pdev, page->dma_addr + off, i,
-				    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr + off,
+					i, DMA_FROM_DEVICE);
 		addr = cas_page_map(page->buffer);
 		memcpy(p, addr + off, i);
-		pci_dma_sync_single_for_device(cp->pdev, page->dma_addr + off, i,
-				    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&cp->pdev->dev,
+					   page->dma_addr + off, i,
+					   DMA_FROM_DEVICE);
 		cas_page_unmap(addr);
 		RX_USED_ADD(page, 0x100);
 		p += hlen;
@@ -1988,16 +1989,17 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		i = hlen;
 		if (i == dlen)  /* attach FCS */
 			i += cp->crc_size;
-		pci_dma_sync_single_for_cpu(cp->pdev, page->dma_addr + off, i,
-				    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr + off,
+					i, DMA_FROM_DEVICE);
 
 		/* make sure we always copy a header */
 		swivel = 0;
 		if (p == (char *) skb->data) { /* not split */
 			addr = cas_page_map(page->buffer);
 			memcpy(p, addr + off, RX_COPY_MIN);
-			pci_dma_sync_single_for_device(cp->pdev, page->dma_addr + off, i,
-					PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&cp->pdev->dev,
+						   page->dma_addr + off, i,
+						   DMA_FROM_DEVICE);
 			cas_page_unmap(addr);
 			off += RX_COPY_MIN;
 			swivel = RX_COPY_MIN;
@@ -2024,12 +2026,14 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 
 			i = CAS_VAL(RX_COMP2_NEXT_INDEX, words[1]);
 			page = cp->rx_pages[CAS_VAL(RX_INDEX_RING, i)][CAS_VAL(RX_INDEX_NUM, i)];
-			pci_dma_sync_single_for_cpu(cp->pdev, page->dma_addr,
-					    hlen + cp->crc_size,
-					    PCI_DMA_FROMDEVICE);
-			pci_dma_sync_single_for_device(cp->pdev, page->dma_addr,
-					    hlen + cp->crc_size,
-					    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&cp->pdev->dev,
+						page->dma_addr,
+						hlen + cp->crc_size,
+						DMA_FROM_DEVICE);
+			dma_sync_single_for_device(&cp->pdev->dev,
+						   page->dma_addr,
+						   hlen + cp->crc_size,
+						   DMA_FROM_DEVICE);
 
 			skb_shinfo(skb)->nr_frags++;
 			skb->data_len += hlen;
@@ -2066,12 +2070,13 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		i = hlen;
 		if (i == dlen) /* attach FCS */
 			i += cp->crc_size;
-		pci_dma_sync_single_for_cpu(cp->pdev, page->dma_addr + off, i,
-				    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr + off,
+					i, DMA_FROM_DEVICE);
 		addr = cas_page_map(page->buffer);
 		memcpy(p, addr + off, i);
-		pci_dma_sync_single_for_device(cp->pdev, page->dma_addr + off, i,
-				    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&cp->pdev->dev,
+					   page->dma_addr + off, i,
+					   DMA_FROM_DEVICE);
 		cas_page_unmap(addr);
 		if (p == (char *) skb->data) /* not split */
 			RX_USED_ADD(page, cp->mtu_stride);
@@ -2083,14 +2088,16 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			p += hlen;
 			i = CAS_VAL(RX_COMP2_NEXT_INDEX, words[1]);
 			page = cp->rx_pages[CAS_VAL(RX_INDEX_RING, i)][CAS_VAL(RX_INDEX_NUM, i)];
-			pci_dma_sync_single_for_cpu(cp->pdev, page->dma_addr,
-					    dlen + cp->crc_size,
-					    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&cp->pdev->dev,
+						page->dma_addr,
+						dlen + cp->crc_size,
+						DMA_FROM_DEVICE);
 			addr = cas_page_map(page->buffer);
 			memcpy(p, addr, dlen + cp->crc_size);
-			pci_dma_sync_single_for_device(cp->pdev, page->dma_addr,
-					    dlen + cp->crc_size,
-					    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&cp->pdev->dev,
+						   page->dma_addr,
+						   dlen + cp->crc_size,
+						   DMA_FROM_DEVICE);
 			cas_page_unmap(addr);
 			RX_USED_ADD(page, dlen + cp->crc_size);
 		}
@@ -2766,9 +2773,8 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	len = skb_headlen(skb);
-	mapping = pci_map_page(cp->pdev, virt_to_page(skb->data),
-			       offset_in_page(skb->data), len,
-			       PCI_DMA_TODEVICE);
+	mapping = dma_map_page(&cp->pdev->dev, virt_to_page(skb->data),
+			       offset_in_page(skb->data), len, DMA_TO_DEVICE);
 
 	tentry = entry;
 	tabort = cas_calc_tabort(cp, (unsigned long) skb->data, len);
@@ -3882,8 +3888,8 @@ static void cas_clean_txd(struct cas *cp, int ring)
 			daddr = le64_to_cpu(txd[ent].buffer);
 			dlen  =  CAS_VAL(TX_DESC_BUFLEN,
 					 le64_to_cpu(txd[ent].control));
-			pci_unmap_page(cp->pdev, daddr, dlen,
-				       PCI_DMA_TODEVICE);
+			dma_unmap_page(&cp->pdev->dev, daddr, dlen,
+				       DMA_TO_DEVICE);
 
 			if (frag != skb_shinfo(skb)->nr_frags) {
 				i++;
@@ -4181,9 +4187,8 @@ static void cas_tx_tiny_free(struct cas *cp)
 		if (!cp->tx_tiny_bufs[i])
 			continue;
 
-		pci_free_consistent(pdev, TX_TINY_BUF_BLOCK,
-				    cp->tx_tiny_bufs[i],
-				    cp->tx_tiny_dvma[i]);
+		dma_free_coherent(&pdev->dev, TX_TINY_BUF_BLOCK,
+				  cp->tx_tiny_bufs[i], cp->tx_tiny_dvma[i]);
 		cp->tx_tiny_bufs[i] = NULL;
 	}
 }
@@ -4195,8 +4200,8 @@ static int cas_tx_tiny_alloc(struct cas *cp)
 
 	for (i = 0; i < N_TX_RINGS; i++) {
 		cp->tx_tiny_bufs[i] =
-			pci_alloc_consistent(pdev, TX_TINY_BUF_BLOCK,
-					     &cp->tx_tiny_dvma[i]);
+			dma_alloc_coherent(&pdev->dev, TX_TINY_BUF_BLOCK,
+					   &cp->tx_tiny_dvma[i], GFP_KERNEL);
 		if (!cp->tx_tiny_bufs[i]) {
 			cas_tx_tiny_free(cp);
 			return -1;
@@ -4958,10 +4963,9 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 
 	/* Configure DMA attributes. */
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev,
-						  DMA_BIT_MASK(64));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err < 0) {
 			dev_err(&pdev->dev, "Unable to obtain 64-bit DMA "
 			       "for consistent allocations\n");
@@ -4969,7 +4973,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "No usable DMA configuration, "
 			       "aborting\n");
@@ -5048,8 +5052,8 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		cas_saturn_firmware_init(cp);
 
 	cp->init_block =
-		pci_alloc_consistent(pdev, sizeof(struct cas_init_block),
-				     &cp->block_dvma);
+		dma_alloc_coherent(&pdev->dev, sizeof(struct cas_init_block),
+				   &cp->block_dvma, GFP_KERNEL);
 	if (!cp->init_block) {
 		dev_err(&pdev->dev, "Cannot allocate init block, aborting\n");
 		goto err_out_iounmap;
@@ -5109,8 +5113,8 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_out_free_consistent:
-	pci_free_consistent(pdev, sizeof(struct cas_init_block),
-			    cp->init_block, cp->block_dvma);
+	dma_free_coherent(&pdev->dev, sizeof(struct cas_init_block),
+			  cp->init_block, cp->block_dvma);
 
 err_out_iounmap:
 	mutex_lock(&cp->pm_mutex);
@@ -5164,8 +5168,8 @@ static void cas_remove_one(struct pci_dev *pdev)
 				      cp->orig_cacheline_size);
 	}
 #endif
-	pci_free_consistent(pdev, sizeof(struct cas_init_block),
-			    cp->init_block, cp->block_dvma);
+	dma_free_coherent(&pdev->dev, sizeof(struct cas_init_block),
+			  cp->init_block, cp->block_dvma);
 	pci_iounmap(pdev, cp->regs);
 	free_netdev(dev);
 	pci_release_regions(pdev);
-- 
2.25.1

