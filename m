Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E004827D1
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 16:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiAAOs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 09:48:29 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:63306 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiAAOs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 09:48:28 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 3fgIngmSLTdRT3fgInU0RI; Sat, 01 Jan 2022 15:48:27 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 01 Jan 2022 15:48:27 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] tehuti: Use dma_set_mask_and_coherent() and simplify code
Date:   Sat,  1 Jan 2022 15:48:25 +0100
Message-Id: <b1efca5650e17c5e21cb880dbdf71c93e3c77f36.1641048461.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_set_mask_and_coherent() instead of unrolling it with some
dma_set_mask()+dma_set_coherent_mask().

Moreover, as stated in [1], dma_set_mask_and_coherent() with a 64-bit mask
will never fail if dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

That said, 'pci_using_dac' can only be 1 after a successful
dma_set_mask_and_coherent().

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/tehuti/tehuti.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 89bc1602661c..985073eba3bd 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1884,10 +1884,10 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *ndev;
 	struct bdx_priv *priv;
-	int err, pci_using_dac, port;
 	unsigned long pciaddr;
 	u32 regionSize;
 	struct pci_nic *nic;
+	int err, port;
 
 	ENTER;
 
@@ -1900,16 +1900,10 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)			/* it triggers interrupt, dunno why. */
 		goto err_pci;		/* it's not a problem though */
 
-	if (!(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) &&
-	    !(err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
-		pci_using_dac = 1;
-	} else {
-		if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) ||
-		    (err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)))) {
-			pr_err("No usable DMA configuration, aborting\n");
-			goto err_dma;
-		}
-		pci_using_dac = 0;
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		pr_err("No usable DMA configuration, aborting\n");
+		goto err_dma;
 	}
 
 	err = pci_request_regions(pdev, BDX_DRV_NAME);
@@ -1982,16 +1976,14 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* these fields are used for info purposes only
 		 * so we can have them same for all ports of the board */
 		ndev->if_port = port;
-		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO
-		    | NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM
-		    ;
+		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO |
+		    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
+		    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM |
+		    NETIF_F_HIGHDMA;
+
 		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX;
 
-		if (pci_using_dac)
-			ndev->features |= NETIF_F_HIGHDMA;
-
 	/************** priv ****************/
 		priv = nic->priv[port] = netdev_priv(ndev);
 
-- 
2.32.0

