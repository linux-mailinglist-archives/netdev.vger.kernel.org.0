Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3664889BB
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 14:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbiAIN7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 08:59:53 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:56151 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiAIN7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 08:59:52 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6YjenCh7DUujj6YjfnIYDW; Sun, 09 Jan 2022 14:59:51 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 14:59:51 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] cxgb4vf: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 14:59:48 +0100
Message-Id: <b14986ea39cea2ca9a6cd0476a3fc167c853ee67.1641736772.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
1.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   | 20 +++++--------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index acac2be0e3f0..7de3800437c9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2899,7 +2899,6 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct port_info *pi;
 	unsigned int pmask;
-	int pci_using_dac;
 	int err, pidx;
 
 	/*
@@ -2920,19 +2919,12 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	}
 
 	/*
-	 * Set up our DMA mask: try for 64-bit address masking first and
-	 * fall back to 32-bit if we can't get 64 bits ...
+	 * Set up our DMA mask
 	 */
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (err == 0) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err != 0) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto err_release_regions;
-		}
-		pci_using_dac = 0;
+	if (err) {
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto err_release_regions;
 	}
 
 	/*
@@ -3078,9 +3070,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		netdev->hw_features = NETIF_F_SG | TSO_FLAGS | NETIF_F_GRO |
 			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-		netdev->features = netdev->hw_features;
-		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
+		netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 		netdev->vlan_features = netdev->features & VLAN_FEAT;
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
-- 
2.32.0

