Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC42149EDD6
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiA0Vxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:53:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:32606 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241116AbiA0Vwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 16:52:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643320362; x=1674856362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tJ38W2r/g6fpBppzdQWc25vX43g0kFKsR0Xfthn0tMw=;
  b=RKTzbUb8pmwKmaIIK7rFR8PkaLwOs+oUyb4GDIkAnnqGFJ4ug9r7ix9X
   1CmljVPDzI24zDeJES4j2aOTrJydMZM1/WNJnBxah5GcdSkGr8LeGpBFx
   FmZ8YF3v7Zwkw3oKxM+BklpQa/9wnBHERaiXp7nsxx9UQpp1jjRxqXwaQ
   4DlkIFc02L+F3DPle9HKq6LdmYBDMd8q2F4vBz4PxYSy5eWLz+F0yIQvG
   Rjzn8v6JmAYcHIArd6JG12iQURVCAqUIUBkh1aHQU2cnQnrPJ1n13nwvy
   NlcQpQ7+HLom4hvvMDzQ3gILTF9+oTe8LJ43r94vfM8aHO88XthhrlWR2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246918937"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="246918937"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 13:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="625391769"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 13:52:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Christoph Hellwig <hch@lst.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 02/10] ixgbe: Remove useless DMA-32 fallback configuration
Date:   Thu, 27 Jan 2022 13:52:16 -0800
Message-Id: <20220127215224.422113-3-anthony.l.nguyen@intel.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 +++++++------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 89b467006291..2c8a4a06f56a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10632,9 +10632,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbe_adapter *adapter = NULL;
 	struct ixgbe_hw *hw;
 	const struct ixgbe_info *ii = ixgbe_info_tbl[ent->driver_data];
-	int i, err, pci_using_dac, expected_gts;
 	unsigned int indices = MAX_TX_QUEUES;
 	u8 part_str[IXGBE_PBANUM_LENGTH];
+	int i, err, expected_gts;
 	bool disable_dev = false;
 #ifdef IXGBE_FCOE
 	u16 device_caps;
@@ -10654,16 +10654,11 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		return err;
 
-	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"No usable DMA configuration, aborting\n");
-			goto err_dma;
-		}
-		pci_using_dac = 0;
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev,
+			"No usable DMA configuration, aborting\n");
+		goto err_dma;
 	}
 
 	err = pci_request_mem_regions(pdev, ixgbe_driver_name);
@@ -10861,8 +10856,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->hw_features |= NETIF_F_NTUPLE |
 				       NETIF_F_HW_TC;
 
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->hw_enc_features |= netdev->vlan_features;
-- 
2.31.1

