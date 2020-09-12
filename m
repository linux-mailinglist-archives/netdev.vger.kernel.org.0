Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574A6267A01
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 13:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgILLhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 07:37:41 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:30955 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgILLhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 07:37:36 -0400
Received: from localhost.localdomain ([93.22.150.101])
        by mwinf5d26 with ME
        id SzV12300C2BWSNM03zV1aR; Sat, 12 Sep 2020 13:29:04 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Sep 2020 13:29:04 +0200
X-ME-IP: 93.22.150.101
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        mst@redhat.com, mhabets@solarflare.com, vaibhavgupta40@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] sc92031: switch from 'pci_' to 'dma_' API
Date:   Sat, 12 Sep 2020 13:28:58 +0200
Message-Id: <20200912112858.339548-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'sc92031_open()' GFP_KERNEL can be used
because it is a '.ndo_open' function and no lock is taken in the between.
'.ndo_open' functions are synchronized with the rtnl_lock() semaphore.


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
 drivers/net/ethernet/silan/sc92031.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index f94078f8ebe5..91b60c51079b 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -993,15 +993,15 @@ static int sc92031_open(struct net_device *dev)
 	struct sc92031_priv *priv = netdev_priv(dev);
 	struct pci_dev *pdev = priv->pdev;
 
-	priv->rx_ring = pci_alloc_consistent(pdev, RX_BUF_LEN,
-			&priv->rx_ring_dma_addr);
+	priv->rx_ring = dma_alloc_coherent(&pdev->dev, RX_BUF_LEN,
+					   &priv->rx_ring_dma_addr, GFP_KERNEL);
 	if (unlikely(!priv->rx_ring)) {
 		err = -ENOMEM;
 		goto out_alloc_rx_ring;
 	}
 
-	priv->tx_bufs = pci_alloc_consistent(pdev, TX_BUF_TOT_LEN,
-			&priv->tx_bufs_dma_addr);
+	priv->tx_bufs = dma_alloc_coherent(&pdev->dev, TX_BUF_TOT_LEN,
+					   &priv->tx_bufs_dma_addr, GFP_KERNEL);
 	if (unlikely(!priv->tx_bufs)) {
 		err = -ENOMEM;
 		goto out_alloc_tx_bufs;
@@ -1031,11 +1031,11 @@ static int sc92031_open(struct net_device *dev)
 	return 0;
 
 out_request_irq:
-	pci_free_consistent(pdev, TX_BUF_TOT_LEN, priv->tx_bufs,
-			priv->tx_bufs_dma_addr);
+	dma_free_coherent(&pdev->dev, TX_BUF_TOT_LEN, priv->tx_bufs,
+			  priv->tx_bufs_dma_addr);
 out_alloc_tx_bufs:
-	pci_free_consistent(pdev, RX_BUF_LEN, priv->rx_ring,
-			priv->rx_ring_dma_addr);
+	dma_free_coherent(&pdev->dev, RX_BUF_LEN, priv->rx_ring,
+			  priv->rx_ring_dma_addr);
 out_alloc_rx_ring:
 	return err;
 }
@@ -1058,10 +1058,10 @@ static int sc92031_stop(struct net_device *dev)
 	spin_unlock_bh(&priv->lock);
 
 	free_irq(pdev->irq, dev);
-	pci_free_consistent(pdev, TX_BUF_TOT_LEN, priv->tx_bufs,
-			priv->tx_bufs_dma_addr);
-	pci_free_consistent(pdev, RX_BUF_LEN, priv->rx_ring,
-			priv->rx_ring_dma_addr);
+	dma_free_coherent(&pdev->dev, TX_BUF_TOT_LEN, priv->tx_bufs,
+			  priv->tx_bufs_dma_addr);
+	dma_free_coherent(&pdev->dev, RX_BUF_LEN, priv->rx_ring,
+			  priv->rx_ring_dma_addr);
 
 	return 0;
 }
@@ -1407,11 +1407,11 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (unlikely(err < 0))
 		goto out_set_dma_mask;
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (unlikely(err < 0))
 		goto out_set_dma_mask;
 
-- 
2.25.1

