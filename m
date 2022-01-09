Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33184488BB8
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 19:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbiAISns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 13:43:48 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:64432 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAISnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 13:43:47 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6dAPnvyS6soWh6dAQnw4cz; Sun, 09 Jan 2022 19:43:46 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 19:43:46 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH] igbvf: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 19:43:40 +0100
Message-Id: <dc75b24883381a060eaad21cb0deffb5a027b05f.1641753812.git.christophe.jaillet@wanadoo.fr>
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
This patch was not part of the 1st serie I've sent. So there is no
Reviewed-by tag.
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index b78407289741..43ced78c3a2e 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2684,25 +2684,18 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct igbvf_adapter *adapter;
 	struct e1000_hw *hw;
 	const struct igbvf_info *ei = igbvf_info_tbl[ent->driver_data];
-
 	static int cards_found;
-	int err, pci_using_dac;
+	int err;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
 		return err;
 
-	pci_using_dac = 0;
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (!err) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"No usable DMA configuration, aborting\n");
-			goto err_dma;
-		}
+	if (err) {
+		dev_err(&pdev->dev,
+			"No usable DMA configuration, aborting\n");
+		goto err_dma;
 	}
 
 	err = pci_request_regions(pdev, igbvf_driver_name);
@@ -2783,10 +2776,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
 			       IGBVF_GSO_PARTIAL_FEATURES;
 
-	netdev->features = netdev->hw_features;
-
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
-- 
2.32.0

