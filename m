Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7C4883F1
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 15:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbiAHOWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 09:22:17 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:51793 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiAHOWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 09:22:16 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6CbmnLdHIBazo6Cbmn7Pa3; Sat, 08 Jan 2022 15:22:15 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 08 Jan 2022 15:22:15 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] myri10ge: Simplify DMA setting
Date:   Sat,  8 Jan 2022 15:22:13 +0100
Message-Id: <e92b0c3a3c1574a97a4e6fd0c30225f10fa59d18.1641651693.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

If dma_set_mask_and_coherent() succeeds, 'dac_enabled' is known to be 1.

Simplify code and remove some dead code accordingly.


[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 83a5e29c836a..50ac3ee2577a 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3742,7 +3742,6 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct myri10ge_priv *mgp;
 	struct device *dev = &pdev->dev;
 	int status = -ENXIO;
-	int dac_enabled;
 	unsigned hdr_offset, ss_offset;
 	static int board_number;
 
@@ -3782,14 +3781,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	myri10ge_mask_surprise_down(pdev);
 	pci_set_master(pdev);
-	dac_enabled = 1;
 	status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (status != 0) {
-		dac_enabled = 0;
-		dev_err(&pdev->dev,
-			"64-bit pci address mask was refused, trying 32-bit\n");
-		status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	}
 	if (status != 0) {
 		dev_err(&pdev->dev, "Error %d setting DMA mask\n", status);
 		goto abort_with_enabled;
@@ -3874,10 +3866,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* fake NETIF_F_HW_VLAN_CTAG_RX for good GRO performance */
 	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 
-	netdev->features = netdev->hw_features;
-
-	if (dac_enabled)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= mgp->features;
 	if (mgp->fw_ver_tiny < 37)
-- 
2.32.0

