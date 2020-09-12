Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AD7267AC3
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgILOMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:12:44 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:26729 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgILOMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:12:39 -0400
Received: from localhost.localdomain ([93.22.150.101])
        by mwinf5d61 with ME
        id T2Cb230012BWSNM032Cbu9; Sat, 12 Sep 2020 16:12:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Sep 2020 16:12:37 +0200
X-ME-IP: 93.22.150.101
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, andy@greyhouse.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: tehuti: switch from 'pci_' to 'dma_' API
Date:   Sat, 12 Sep 2020 16:12:32 +0200
Message-Id: <20200912141232.343630-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'bdx_fifo_init()' GFP_ATOMIC must be used
because it can be called from a '.ndo_set_rx_mode' function. Such functions
hold the 'netif_addr_lock' spinlock.

  .ndo_set_rx_mode              (see struct net_device_ops)
    --> bdx_change_mtu
      --> bdx_open
        --> bdx_rx_init
        --> bdx_tx_init
          --> bdx_fifo_init


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
 drivers/net/ethernet/tehuti/tehuti.c | 53 +++++++++++++---------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index e28727297563..a142e4c9fc03 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -153,11 +153,11 @@ bdx_fifo_init(struct bdx_priv *priv, struct fifo *f, int fsz_type,
 	u16 memsz = FIFO_SIZE * (1 << fsz_type);
 
 	memset(f, 0, sizeof(struct fifo));
-	/* pci_alloc_consistent gives us 4k-aligned memory */
-	f->va = pci_alloc_consistent(priv->pdev,
-				     memsz + FIFO_EXTRA_SPACE, &f->da);
+	/* dma_alloc_coherent gives us 4k-aligned memory */
+	f->va = dma_alloc_coherent(&priv->pdev->dev, memsz + FIFO_EXTRA_SPACE,
+				   &f->da, GFP_ATOMIC);
 	if (!f->va) {
-		pr_err("pci_alloc_consistent failed\n");
+		pr_err("dma_alloc_coherent failed\n");
 		RET(-ENOMEM);
 	}
 	f->reg_CFG0 = reg_CFG0;
@@ -183,8 +183,8 @@ static void bdx_fifo_free(struct bdx_priv *priv, struct fifo *f)
 {
 	ENTER;
 	if (f->va) {
-		pci_free_consistent(priv->pdev,
-				    f->memsz + FIFO_EXTRA_SPACE, f->va, f->da);
+		dma_free_coherent(&priv->pdev->dev,
+				  f->memsz + FIFO_EXTRA_SPACE, f->va, f->da);
 		f->va = NULL;
 	}
 	RET();
@@ -1033,9 +1033,8 @@ static void bdx_rx_free_skbs(struct bdx_priv *priv, struct rxf_fifo *f)
 	for (i = 0; i < db->nelem; i++) {
 		dm = bdx_rxdb_addr_elem(db, i);
 		if (dm->dma) {
-			pci_unmap_single(priv->pdev,
-					 dm->dma, f->m.pktsz,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, dm->dma,
+					 f->m.pktsz, DMA_FROM_DEVICE);
 			dev_kfree_skb(dm->skb);
 		}
 	}
@@ -1097,9 +1096,8 @@ static void bdx_rx_alloc_skbs(struct bdx_priv *priv, struct rxf_fifo *f)
 
 		idx = bdx_rxdb_alloc_elem(db);
 		dm = bdx_rxdb_addr_elem(db, idx);
-		dm->dma = pci_map_single(priv->pdev,
-					 skb->data, f->m.pktsz,
-					 PCI_DMA_FROMDEVICE);
+		dm->dma = dma_map_single(&priv->pdev->dev, skb->data,
+					 f->m.pktsz, DMA_FROM_DEVICE);
 		dm->skb = skb;
 		rxfd = (struct rxf_desc *)(f->m.va + f->m.wptr);
 		rxfd->info = CPU_CHIP_SWAP32(0x10003);	/* INFO=1 BC=3 */
@@ -1259,16 +1257,15 @@ static int bdx_rx_receive(struct bdx_priv *priv, struct rxd_fifo *f, int budget)
 		    (skb2 = netdev_alloc_skb(priv->ndev, len + NET_IP_ALIGN))) {
 			skb_reserve(skb2, NET_IP_ALIGN);
 			/*skb_put(skb2, len); */
-			pci_dma_sync_single_for_cpu(priv->pdev,
-						    dm->dma, rxf_fifo->m.pktsz,
-						    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&priv->pdev->dev, dm->dma,
+						rxf_fifo->m.pktsz,
+						DMA_FROM_DEVICE);
 			memcpy(skb2->data, skb->data, len);
 			bdx_recycle_skb(priv, rxdd);
 			skb = skb2;
 		} else {
-			pci_unmap_single(priv->pdev,
-					 dm->dma, rxf_fifo->m.pktsz,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, dm->dma,
+					 rxf_fifo->m.pktsz, DMA_FROM_DEVICE);
 			bdx_rxdb_free_elem(db, rxdd->va_lo);
 		}
 
@@ -1478,8 +1475,8 @@ bdx_tx_map_skb(struct bdx_priv *priv, struct sk_buff *skb,
 	int i;
 
 	db->wptr->len = skb_headlen(skb);
-	db->wptr->addr.dma = pci_map_single(priv->pdev, skb->data,
-					    db->wptr->len, PCI_DMA_TODEVICE);
+	db->wptr->addr.dma = dma_map_single(&priv->pdev->dev, skb->data,
+					    db->wptr->len, DMA_TO_DEVICE);
 	pbl->len = CPU_CHIP_SWAP32(db->wptr->len);
 	pbl->pa_lo = CPU_CHIP_SWAP32(L32_64(db->wptr->addr.dma));
 	pbl->pa_hi = CPU_CHIP_SWAP32(H32_64(db->wptr->addr.dma));
@@ -1716,8 +1713,8 @@ static void bdx_tx_cleanup(struct bdx_priv *priv)
 		BDX_ASSERT(db->rptr->len == 0);
 		do {
 			BDX_ASSERT(db->rptr->addr.dma == 0);
-			pci_unmap_page(priv->pdev, db->rptr->addr.dma,
-				       db->rptr->len, PCI_DMA_TODEVICE);
+			dma_unmap_page(&priv->pdev->dev, db->rptr->addr.dma,
+				       db->rptr->len, DMA_TO_DEVICE);
 			bdx_tx_db_inc_rptr(db);
 		} while (db->rptr->len > 0);
 		tx_level -= db->rptr->len;	/* '-' koz len is negative */
@@ -1765,8 +1762,8 @@ static void bdx_tx_free_skbs(struct bdx_priv *priv)
 	ENTER;
 	while (db->rptr != db->wptr) {
 		if (likely(db->rptr->len))
-			pci_unmap_page(priv->pdev, db->rptr->addr.dma,
-				       db->rptr->len, PCI_DMA_TODEVICE);
+			dma_unmap_page(&priv->pdev->dev, db->rptr->addr.dma,
+				       db->rptr->len, DMA_TO_DEVICE);
 		else
 			dev_kfree_skb(db->rptr->addr.skb);
 		bdx_tx_db_inc_rptr(db);
@@ -1902,12 +1899,12 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)			/* it triggers interrupt, dunno why. */
 		goto err_pci;		/* it's not a problem though */
 
-	if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) &&
-	    !(err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))) {
+	if (!(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) &&
+	    !(err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
 		pci_using_dac = 1;
 	} else {
-		if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
-		    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+		if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) ||
+		    (err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)))) {
 			pr_err("No usable DMA configuration, aborting\n");
 			goto err_dma;
 		}
-- 
2.25.1

