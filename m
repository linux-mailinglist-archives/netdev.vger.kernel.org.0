Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A9E3FA578
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhH1L3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:29:49 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:17998 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhH1L3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:29:43 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d25 with ME
        id mzUp2500J3riaq203zUqo8; Sat, 28 Aug 2021 13:28:51 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 28 Aug 2021 13:28:51 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: pasemi: Remove usage of the deprecated "pci-dma-compat.h" API
Date:   Sat, 28 Aug 2021 13:28:48 +0200
Message-Id: <bc6cd281eae024b26fd9c7ef6678d2d1dc9d74fd.1630150008.git.christophe.jaillet@wanadoo.fr>
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

An 'unlikely()' has been removed when calling 'dma_mapping_error()' because
this function, which is inlined, already has such an annotation.


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
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)


[1]: https://lore.kernel.org/kernel-janitors/20200421081257.GA131897@infradead.org/
[2]: https://lore.kernel.org/kernel-janitors/alpine.DEB.2.22.394.2007120902170.2424@hadrien/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
It has been compile tested.
---
 drivers/net/ethernet/pasemi/pasemi_mac.c | 32 ++++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 040a15a828b4..04a27ba26cc7 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -247,12 +247,13 @@ static int pasemi_mac_unmap_tx_skb(struct pasemi_mac *mac,
 	int f;
 	struct pci_dev *pdev = mac->dma_pdev;
 
-	pci_unmap_single(pdev, dmas[0], skb_headlen(skb), PCI_DMA_TODEVICE);
+	dma_unmap_single(&pdev->dev, dmas[0], skb_headlen(skb), DMA_TO_DEVICE);
 
 	for (f = 0; f < nfrags; f++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		pci_unmap_page(pdev, dmas[f+1], skb_frag_size(frag), PCI_DMA_TODEVICE);
+		dma_unmap_page(&pdev->dev, dmas[f + 1], skb_frag_size(frag),
+			       DMA_TO_DEVICE);
 	}
 	dev_kfree_skb_irq(skb);
 
@@ -548,10 +549,8 @@ static void pasemi_mac_free_rx_buffers(struct pasemi_mac *mac)
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		info = &RX_DESC_INFO(rx, i);
 		if (info->skb && info->dma) {
-			pci_unmap_single(mac->dma_pdev,
-					 info->dma,
-					 info->skb->len,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&mac->dma_pdev->dev, info->dma,
+					 info->skb->len, DMA_FROM_DEVICE);
 			dev_kfree_skb_any(info->skb);
 		}
 		info->dma = 0;
@@ -600,11 +599,11 @@ static void pasemi_mac_replenish_rx_ring(struct net_device *dev,
 		if (unlikely(!skb))
 			break;
 
-		dma = pci_map_single(mac->dma_pdev, skb->data,
+		dma = dma_map_single(&mac->dma_pdev->dev, skb->data,
 				     mac->bufsz - LOCAL_SKB_ALIGN,
-				     PCI_DMA_FROMDEVICE);
+				     DMA_FROM_DEVICE);
 
-		if (unlikely(pci_dma_mapping_error(mac->dma_pdev, dma))) {
+		if (dma_mapping_error(&mac->dma_pdev->dev, dma)) {
 			dev_kfree_skb_irq(info->skb);
 			break;
 		}
@@ -741,8 +740,9 @@ static int pasemi_mac_clean_rx(struct pasemi_mac_rxring *rx,
 
 		len = (macrx & XCT_MACRX_LLEN_M) >> XCT_MACRX_LLEN_S;
 
-		pci_unmap_single(pdev, dma, mac->bufsz - LOCAL_SKB_ALIGN,
-				 PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&pdev->dev, dma,
+				 mac->bufsz - LOCAL_SKB_ALIGN,
+				 DMA_FROM_DEVICE);
 
 		if (macrx & XCT_MACRX_CRC) {
 			/* CRC error flagged */
@@ -1444,10 +1444,10 @@ static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 
 	nfrags = skb_shinfo(skb)->nr_frags;
 
-	map[0] = pci_map_single(mac->dma_pdev, skb->data, skb_headlen(skb),
-				PCI_DMA_TODEVICE);
+	map[0] = dma_map_single(&mac->dma_pdev->dev, skb->data,
+				skb_headlen(skb), DMA_TO_DEVICE);
 	map_size[0] = skb_headlen(skb);
-	if (pci_dma_mapping_error(mac->dma_pdev, map[0]))
+	if (dma_mapping_error(&mac->dma_pdev->dev, map[0]))
 		goto out_err_nolock;
 
 	for (i = 0; i < nfrags; i++) {
@@ -1534,8 +1534,8 @@ static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 	spin_unlock_irqrestore(&txring->lock, flags);
 out_err_nolock:
 	while (nfrags--)
-		pci_unmap_single(mac->dma_pdev, map[nfrags], map_size[nfrags],
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&mac->dma_pdev->dev, map[nfrags],
+				 map_size[nfrags], DMA_TO_DEVICE);
 
 	return NETDEV_TX_BUSY;
 }
-- 
2.30.2

