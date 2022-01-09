Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40489488AF8
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 18:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiAIRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 12:22:30 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:62383 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiAIRW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 12:22:29 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6btjnvZHLsoWh6btknvxGl; Sun, 09 Jan 2022 18:22:28 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 18:22:28 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH] ixgbevf: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 18:22:26 +0100
Message-Id: <e9f8c8b59fe4a3b4dd34d37ccfaf9862b7ee14ba.1641748940.git.christophe.jaillet@wanadoo.fr>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 0015fcf1df2b..7c33be9074e9 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4511,22 +4511,17 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbevf_adapter *adapter = NULL;
 	struct ixgbe_hw *hw = NULL;
 	const struct ixgbevf_info *ii = ixgbevf_info_tbl[ent->driver_data];
-	int err, pci_using_dac;
 	bool disable_dev = false;
+	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "No usable DMA configuration, aborting\n");
-			goto err_dma;
-		}
-		pci_using_dac = 0;
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "No usable DMA configuration, aborting\n");
+		goto err_dma;
 	}
 
 	err = pci_request_regions(pdev, ixgbevf_driver_name);
@@ -4606,10 +4601,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
 			       IXGBEVF_GSO_PARTIAL_FEATURES;
 
-	netdev->features = netdev->hw_features;
-
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_SG |
-- 
2.32.0

