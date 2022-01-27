Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324A049EDCE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbiA0Vwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:52:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:32610 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344476AbiA0Vwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 16:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643320365; x=1674856365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KgjUDI8NpyG1XM6jEklGTS+WolViKHcrD5QCl7K3s6M=;
  b=U36nGJZKnN6ZbeQS1cufnjfK5Z24MPO3ZHu4aOxs5VSvIYafGebM93Do
   l96CwZywGvueI1g0l/Pa+AI1kmyJsb+BNExVuokw5NYI4WZpBeYCN3wlX
   IvYFAqFQNUseyQMN5hiw4DqIwqLQPpRVvi15fKtc6r7wqDy9KvvGLG1m/
   Y3v3Y83wqcQINQd/RIjqE3xk/VharfD8AXvS8rCyTKSEvhIadYcKggLWc
   Frdo+8BrFJGrP3IdOvIXdJblSOQeXGXFVZq7WYRe4MZcUUOjUx/X8EH8c
   +fYP/gMRRsxFNGTYXMaGSrwnh6mYZkVG92vlEiWDN/bcpSGGzribLNxa1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246918953"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246918953"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:52:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="625391796"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 13:52:44 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 09/10] igb: Remove useless DMA-32 fallback configuration
Date:   Thu, 27 Jan 2022 13:52:23 -0800
Message-Id: <20220127215224.422113-10-anthony.l.nguyen@intel.com>
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
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 38ba92022cd4..bfa321e4003f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3164,8 +3164,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	s32 ret_val;
 	static int global_quad_port_a; /* global quad port a indication */
 	const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
-	int err, pci_using_dac;
 	u8 part_str[E1000_PBANUM_LENGTH];
+	int err;
 
 	/* Catch broken hardware that put the wrong VF device ID in
 	 * the PCIe SR-IOV capability.
@@ -3180,17 +3180,11 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 
 	err = pci_request_mem_regions(pdev, igb_driver_name);
@@ -3306,8 +3300,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hw->mac.type >= e1000_i350)
 		netdev->hw_features |= NETIF_F_NTUPLE;
 
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
-- 
2.31.1

