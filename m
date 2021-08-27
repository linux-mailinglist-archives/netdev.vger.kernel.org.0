Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0A3FA040
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhH0UBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:01:51 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:42290 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231418AbhH0UBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 16:01:50 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d77 with ME
        id mk0z250053riaq203k0zhT; Fri, 27 Aug 2021 22:00:59 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 27 Aug 2021 22:00:59 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] fddi: switch from 'pci_' to 'dma_' API
Date:   Fri, 27 Aug 2021 22:00:57 +0200
Message-Id: <abc49c24a591b4701dd39fa76506cfdf19aff3cd.1630094399.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1], Christoph Hellwig has proposed to remove the wrappers in
include/linux/pci-dma-compat.h.

Some reasons why this API should be removed have been given by Julia
Lawall in [2].

A coccinelle script has been used to perform the needed transformation
Only relevant parts are given below.

It has been compile tested.

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

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


[1]: https://lore.kernel.org/kernel-janitors/20200421081257.GA131897@infradead.org/
[2]: https://lore.kernel.org/kernel-janitors/alpine.DEB.2.22.394.2007120902170.2424@hadrien/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/fddi/skfp/skfddi.c | 41 ++++++++++++++++------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index f62e98fada1a..c5cb421f9890 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -1174,8 +1174,8 @@ static void send_queued_packets(struct s_smc *smc)
 
 		txd = (struct s_smt_fp_txd *) HWM_GET_CURR_TXD(smc, queue);
 
-		dma_address = pci_map_single(&bp->pdev, skb->data,
-					     skb->len, PCI_DMA_TODEVICE);
+		dma_address = dma_map_single(&(&bp->pdev)->dev, skb->data,
+					     skb->len, DMA_TO_DEVICE);
 		if (frame_status & LAN_TX) {
 			txd->txd_os.skb = skb;			// save skb
 			txd->txd_os.dma_addr = dma_address;	// save dma mapping
@@ -1184,8 +1184,8 @@ static void send_queued_packets(struct s_smc *smc)
                       frame_status | FIRST_FRAG | LAST_FRAG | EN_IRQ_EOF);
 
 		if (!(frame_status & LAN_TX)) {		// local only frame
-			pci_unmap_single(&bp->pdev, dma_address,
-					 skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&(&bp->pdev)->dev, dma_address,
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_irq(skb);
 		}
 		spin_unlock_irqrestore(&bp->DriverLock, Flags);
@@ -1467,8 +1467,9 @@ void dma_complete(struct s_smc *smc, volatile union s_fp_descr *descr, int flag)
 		if (r->rxd_os.skb && r->rxd_os.dma_addr) {
 			int MaxFrameSize = bp->MaxFrameSize;
 
-			pci_unmap_single(&bp->pdev, r->rxd_os.dma_addr,
-					 MaxFrameSize, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&(&bp->pdev)->dev,
+					 r->rxd_os.dma_addr, MaxFrameSize,
+					 DMA_FROM_DEVICE);
 			r->rxd_os.dma_addr = 0;
 		}
 	}
@@ -1503,8 +1504,8 @@ void mac_drv_tx_complete(struct s_smc *smc, volatile struct s_smt_fp_txd *txd)
 	txd->txd_os.skb = NULL;
 
 	// release the DMA mapping
-	pci_unmap_single(&smc->os.pdev, txd->txd_os.dma_addr,
-			 skb->len, PCI_DMA_TODEVICE);
+	dma_unmap_single(&(&smc->os.pdev)->dev, txd->txd_os.dma_addr,
+			 skb->len, DMA_TO_DEVICE);
 	txd->txd_os.dma_addr = 0;
 
 	smc->os.MacStat.gen.tx_packets++;	// Count transmitted packets.
@@ -1707,10 +1708,9 @@ void mac_drv_requeue_rxd(struct s_smc *smc, volatile struct s_smt_fp_rxd *rxd,
 				skb_reserve(skb, 3);
 				skb_put(skb, MaxFrameSize);
 				v_addr = skb->data;
-				b_addr = pci_map_single(&smc->os.pdev,
-							v_addr,
-							MaxFrameSize,
-							PCI_DMA_FROMDEVICE);
+				b_addr = dma_map_single(&(&smc->os.pdev)->dev,
+							v_addr, MaxFrameSize,
+							DMA_FROM_DEVICE);
 				rxd->rxd_os.dma_addr = b_addr;
 			} else {
 				// no skb available, use local buffer
@@ -1723,10 +1723,8 @@ void mac_drv_requeue_rxd(struct s_smc *smc, volatile struct s_smt_fp_rxd *rxd,
 			// we use skb from old rxd
 			rxd->rxd_os.skb = skb;
 			v_addr = skb->data;
-			b_addr = pci_map_single(&smc->os.pdev,
-						v_addr,
-						MaxFrameSize,
-						PCI_DMA_FROMDEVICE);
+			b_addr = dma_map_single(&(&smc->os.pdev)->dev, v_addr,
+						MaxFrameSize, DMA_FROM_DEVICE);
 			rxd->rxd_os.dma_addr = b_addr;
 		}
 		hwm_rx_frag(smc, v_addr, b_addr, MaxFrameSize,
@@ -1778,10 +1776,8 @@ void mac_drv_fill_rxd(struct s_smc *smc)
 			skb_reserve(skb, 3);
 			skb_put(skb, MaxFrameSize);
 			v_addr = skb->data;
-			b_addr = pci_map_single(&smc->os.pdev,
-						v_addr,
-						MaxFrameSize,
-						PCI_DMA_FROMDEVICE);
+			b_addr = dma_map_single(&(&smc->os.pdev)->dev, v_addr,
+						MaxFrameSize, DMA_FROM_DEVICE);
 			rxd->rxd_os.dma_addr = b_addr;
 		} else {
 			// no skb available, use local buffer
@@ -1838,8 +1834,9 @@ void mac_drv_clear_rxd(struct s_smc *smc, volatile struct s_smt_fp_rxd *rxd,
 			skfddi_priv *bp = &smc->os;
 			int MaxFrameSize = bp->MaxFrameSize;
 
-			pci_unmap_single(&bp->pdev, rxd->rxd_os.dma_addr,
-					 MaxFrameSize, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&(&bp->pdev)->dev,
+					 rxd->rxd_os.dma_addr, MaxFrameSize,
+					 DMA_FROM_DEVICE);
 
 			dev_kfree_skb(skb);
 			rxd->rxd_os.skb = NULL;
-- 
2.30.2

