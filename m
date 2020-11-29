Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA792C79AF
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 16:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgK2PKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 10:10:33 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:51238 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2PKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 10:10:33 -0500
Received: from localhost.localdomain ([81.185.163.10])
        by mwinf5d38 with ME
        id yF8k2300L0DmPsp03F8kDk; Sun, 29 Nov 2020 16:08:48 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 29 Nov 2020 16:08:48 +0100
X-ME-IP: 81.185.163.10
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     buytenh@wantstofly.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, gustavoars@kernel.org, allen.lkml@gmail.com,
        romain.perier@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mwl8k: switch from 'pci_' to 'dma_' API
Date:   Sun, 29 Nov 2020 16:08:44 +0100
Message-Id: <20201129150844.1466214-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

he wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'mwl8k_rxq_init()' and 'mwl8k_txq_init()'
GFP_KERNEL can be used because this flag is already used in a 'kcalloc()'
call, just a few line below.

When memory is allocated in 'mwl8k_firmware_load_success()' GFP_KERNEL can
be used because this flag is already used within 'ieee80211_register_hw()'
which is called just a few line below.

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
 drivers/net/wireless/marvell/mwl8k.c | 72 +++++++++++++++-------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 23efd7075df6..abf3b0233ccc 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -605,8 +605,9 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 	dma_addr_t dma_addr;
 	int loops;
 
-	dma_addr = pci_map_single(priv->pdev, data, length, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, dma_addr))
+	dma_addr = dma_map_single(&priv->pdev->dev, data, length,
+				  DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, dma_addr))
 		return -ENOMEM;
 
 	iowrite32(dma_addr, regs + MWL8K_HIU_GEN_PTR);
@@ -635,7 +636,7 @@ mwl8k_send_fw_load_cmd(struct mwl8k_priv *priv, void *data, int length)
 		udelay(1);
 	} while (--loops);
 
-	pci_unmap_single(priv->pdev, dma_addr, length, PCI_DMA_TODEVICE);
+	dma_unmap_single(&priv->pdev->dev, dma_addr, length, DMA_TO_DEVICE);
 
 	return loops ? 0 : -ETIMEDOUT;
 }
@@ -1169,7 +1170,8 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 
 	size = MWL8K_RX_DESCS * priv->rxd_ops->rxd_size;
 
-	rxq->rxd = pci_zalloc_consistent(priv->pdev, size, &rxq->rxd_dma);
+	rxq->rxd = dma_alloc_coherent(&priv->pdev->dev, size, &rxq->rxd_dma,
+				      GFP_KERNEL);
 	if (rxq->rxd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc RX descriptors\n");
 		return -ENOMEM;
@@ -1177,7 +1179,8 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 
 	rxq->buf = kcalloc(MWL8K_RX_DESCS, sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
-		pci_free_consistent(priv->pdev, size, rxq->rxd, rxq->rxd_dma);
+		dma_free_coherent(&priv->pdev->dev, size, rxq->rxd,
+				  rxq->rxd_dma);
 		return -ENOMEM;
 	}
 
@@ -1218,7 +1221,7 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 		if (skb == NULL)
 			break;
 
-		addr = pci_map_single(priv->pdev, skb->data,
+		addr = dma_map_single(&priv->pdev->dev, skb->data,
 				      MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
 
 		rxq->rxd_count++;
@@ -1249,9 +1252,9 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
 		if (rxq->buf[i].skb != NULL) {
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 dma_unmap_addr(&rxq->buf[i], dma),
-					 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
+					 MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
 			dma_unmap_addr_set(&rxq->buf[i], dma, 0);
 
 			kfree_skb(rxq->buf[i].skb);
@@ -1262,9 +1265,9 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 	kfree(rxq->buf);
 	rxq->buf = NULL;
 
-	pci_free_consistent(priv->pdev,
-			    MWL8K_RX_DESCS * priv->rxd_ops->rxd_size,
-			    rxq->rxd, rxq->rxd_dma);
+	dma_free_coherent(&priv->pdev->dev,
+			  MWL8K_RX_DESCS * priv->rxd_ops->rxd_size, rxq->rxd,
+			  rxq->rxd_dma);
 	rxq->rxd = NULL;
 }
 
@@ -1343,9 +1346,9 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 
 		rxq->buf[rxq->head].skb = NULL;
 
-		pci_unmap_single(priv->pdev,
+		dma_unmap_single(&priv->pdev->dev,
 				 dma_unmap_addr(&rxq->buf[rxq->head], dma),
-				 MWL8K_RX_MAXSZ, PCI_DMA_FROMDEVICE);
+				 MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
 		dma_unmap_addr_set(&rxq->buf[rxq->head], dma, 0);
 
 		rxq->head++;
@@ -1460,7 +1463,8 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 
 	size = MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc);
 
-	txq->txd = pci_zalloc_consistent(priv->pdev, size, &txq->txd_dma);
+	txq->txd = dma_alloc_coherent(&priv->pdev->dev, size, &txq->txd_dma,
+				      GFP_KERNEL);
 	if (txq->txd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc TX descriptors\n");
 		return -ENOMEM;
@@ -1468,7 +1472,8 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
-		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
+		dma_free_coherent(&priv->pdev->dev, size, txq->txd,
+				  txq->txd_dma);
 		return -ENOMEM;
 	}
 
@@ -1707,7 +1712,7 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		txq->skb[tx] = NULL;
 
 		BUG_ON(skb == NULL);
-		pci_unmap_single(priv->pdev, addr, size, PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev, addr, size, DMA_TO_DEVICE);
 
 		mwl8k_remove_dma_header(skb, tx_desc->qos_control);
 
@@ -1774,9 +1779,9 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 	kfree(txq->skb);
 	txq->skb = NULL;
 
-	pci_free_consistent(priv->pdev,
-			    MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc),
-			    txq->txd, txq->txd_dma);
+	dma_free_coherent(&priv->pdev->dev,
+			  MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc),
+			  txq->txd, txq->txd_dma);
 	txq->txd = NULL;
 }
 
@@ -2041,10 +2046,10 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 		qos |= MWL8K_QOS_ACK_POLICY_NORMAL;
 	}
 
-	dma = pci_map_single(priv->pdev, skb->data,
-				skb->len, PCI_DMA_TODEVICE);
+	dma = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
 
-	if (pci_dma_mapping_error(priv->pdev, dma)) {
+	if (dma_mapping_error(&priv->pdev->dev, dma)) {
 		wiphy_debug(hw->wiphy,
 			    "failed to dma map skb, dropping TX frame.\n");
 		if (start_ba_session) {
@@ -2077,8 +2082,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 			}
 			mwl8k_tx_start(priv);
 			spin_unlock_bh(&priv->tx_lock);
-			pci_unmap_single(priv->pdev, dma, skb->len,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pdev->dev, dma, skb->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			return;
 		}
@@ -2237,9 +2242,9 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 
 	cmd->result = (__force __le16) 0xffff;
 	dma_size = le16_to_cpu(cmd->length);
-	dma_addr = pci_map_single(priv->pdev, cmd, dma_size,
-				  PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(priv->pdev, dma_addr)) {
+	dma_addr = dma_map_single(&priv->pdev->dev, cmd, dma_size,
+				  DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&priv->pdev->dev, dma_addr)) {
 		rc = -ENOMEM;
 		goto exit;
 	}
@@ -2257,8 +2262,8 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	priv->hostcmd_wait = NULL;
 
 
-	pci_unmap_single(priv->pdev, dma_addr, dma_size,
-					PCI_DMA_BIDIRECTIONAL);
+	dma_unmap_single(&priv->pdev->dev, dma_addr, dma_size,
+			 DMA_BIDIRECTIONAL);
 
 	if (!timeout) {
 		wiphy_err(hw->wiphy, "Command %s timeout after %u ms\n",
@@ -6126,7 +6131,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	tasklet_disable(&priv->poll_rx_task);
 
 	/* Power management cookie */
-	priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
+	priv->cookie = dma_alloc_coherent(&priv->pdev->dev, 4,
+					  &priv->cookie_dma, GFP_KERNEL);
 	if (priv->cookie == NULL)
 		return -ENOMEM;
 
@@ -6174,8 +6180,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 err_free_cookie:
 	if (priv->cookie != NULL)
-		pci_free_consistent(priv->pdev, 4,
-				priv->cookie, priv->cookie_dma);
+		dma_free_coherent(&priv->pdev->dev, 4, priv->cookie,
+				  priv->cookie_dma);
 
 	return rc;
 }
@@ -6338,7 +6344,7 @@ static void mwl8k_remove(struct pci_dev *pdev)
 
 	mwl8k_rxq_deinit(hw, 0);
 
-	pci_free_consistent(priv->pdev, 4, priv->cookie, priv->cookie_dma);
+	dma_free_coherent(&priv->pdev->dev, 4, priv->cookie, priv->cookie_dma);
 
 unmap:
 	pci_iounmap(pdev, priv->regs);
-- 
2.27.0

