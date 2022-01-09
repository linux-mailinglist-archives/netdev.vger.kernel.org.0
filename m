Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB084889B2
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 14:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiAINvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 08:51:46 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57464 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiAINvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 08:51:46 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6YbnnCeYpUujj6YbnnIXUk; Sun, 09 Jan 2022 14:51:44 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 14:51:44 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] cxgb3: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 14:51:22 +0100
Message-Id: <a0e2539aefb0034091aca02c98440ea9459f1258.1641736234.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index e2637bd2f423..63521312cb90 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3204,7 +3204,7 @@ static void cxgb3_init_iscsi_mac(struct net_device *dev)
 			NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int i, err, pci_using_dac = 0;
+	int i, err;
 	resource_size_t mmio_start, mmio_len;
 	const struct adapter_info *ai;
 	struct adapter *adapter = NULL;
@@ -3231,9 +3231,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_device;
 	}
 
-	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
-		pci_using_dac = 1;
-	} else if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) != 0) {
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
 		goto out_release_regions;
 	}
@@ -3309,8 +3308,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->features |= netdev->hw_features |
 				    NETIF_F_HW_VLAN_CTAG_TX;
 		netdev->vlan_features |= netdev->features & VLAN_FEAT;
-		if (pci_using_dac)
-			netdev->features |= NETIF_F_HIGHDMA;
+
+		netdev->features |= NETIF_F_HIGHDMA;
 
 		netdev->netdev_ops = &cxgb_netdev_ops;
 		netdev->ethtool_ops = &cxgb_ethtool_ops;
-- 
2.32.0

