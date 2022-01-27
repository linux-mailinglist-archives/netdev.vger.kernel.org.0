Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C14A49EDCF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbiA0Vwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:52:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:32610 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244421AbiA0Vwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 16:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643320364; x=1674856364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GJG2cYEKQ0lKcEQFA2yiTsXbQBFgdcaA0v61ej5kOi4=;
  b=VIf7PlkuGwBZBhaELX+/L7ikDvXH9iZHf3EmMrdjyNOYhU7XDHACgdjv
   At92SOv8/ZW+s6o7vRGJBsjHsb8OzThMZaOsRZ6ZeiZYp+Et7BnxDKDyy
   rGdZWGX6Ch6h1XQAFx//1B2O2Ok07FHiD+s3TOSmhoNnqFMeN4wF20q2a
   weGK8quKVGplJJ9YKfqO2DSGRgoCBSY+xEEV8n8fNdmECcVdoOKF2pCGm
   2h6raADyUdJs+yVOD9CsjF/htmxdTWiACFV/27xiBNl1RCTXE2a0HUENn
   3AgqUGV5ysUUmmvWN8PJ/t7PRX7oQbwK0aKcNMUGBtHpo3eZO82fl2Euo
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246918951"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246918951"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:52:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="625391790"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 13:52:44 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 08/10] igc: Remove useless DMA-32 fallback configuration
Date:   Thu, 27 Jan 2022 13:52:22 -0800
Message-Id: <20220127215224.422113-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
References: <20220127215224.422113-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
1.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2f17f36e94fd..6b51baadee3d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6251,23 +6251,17 @@ static int igc_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct igc_hw *hw;
 	const struct igc_info *ei = igc_info_tbl[ent->driver_data];
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
 
 	err = pci_request_mem_regions(pdev, igc_driver_name);
@@ -6367,8 +6361,7 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 	netdev->hw_features |= netdev->features;
 
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
-- 
2.31.1

