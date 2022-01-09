Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628B548886C
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 10:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiAIJEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 04:04:12 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:62852 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiAIJEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 04:04:12 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6U7VnHG92FGqt6U7WnEdtC; Sun, 09 Jan 2022 10:04:10 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 10:04:10 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] be2net: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 10:03:49 +0100
Message-Id: <637696d7141faa68c29fc34b70f9aa67d5e605f0.1641718999.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So if dma_set_mask_and_coherent() succeeds, 'netdev->features' will have
NETIF_F_HIGHDMA in all cases. Move the assignment of this feature in
be_netdev_init() instead be_probe() which is a much logical place.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 84b3ba9bdb18..d0c262f2695a 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5194,7 +5194,8 @@ static void be_netdev_init(struct net_device *netdev)
 		netdev->hw_features |= NETIF_F_RXHASH;
 
 	netdev->features |= netdev->hw_features |
-		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER;
+		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER |
+		NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
@@ -5840,14 +5841,9 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (!status) {
-		netdev->features |= NETIF_F_HIGHDMA;
-	} else {
-		status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (status) {
-			dev_err(&pdev->dev, "Could not set PCI DMA Mask\n");
-			goto free_netdev;
-		}
+	if (status) {
+		dev_err(&pdev->dev, "Could not set PCI DMA Mask\n");
+		goto free_netdev;
 	}
 
 	status = pci_enable_pcie_error_reporting(pdev);
-- 
2.32.0

