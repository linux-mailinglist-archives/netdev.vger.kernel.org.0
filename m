Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA248396E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 01:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiADAP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 19:15:27 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:49960 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiADAP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 19:15:27 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 4XU2nddpN65jH4XU2n26xb; Tue, 04 Jan 2022 01:15:24 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 04 Jan 2022 01:15:24 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] intel: Simplify DMA setting
Date:   Tue,  4 Jan 2022 01:15:20 +0100
Message-Id: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/intel/e1000e/netdev.c    | 22 ++++++-------------
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  9 +++-----
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  9 +++-----
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 --
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   | 19 +++++-----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 ++++++-----------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 20 +++++------------
 7 files changed, 31 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 635a95927e93..4f6ee5c44f75 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7385,9 +7385,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	resource_size_t flash_start, flash_len;
 	static int cards_found;
 	u16 aspm_disable_flag = 0;
-	int bars, i, err, pci_using_dac;
 	u16 eeprom_data = 0;
 	u16 eeprom_apme_mask = E1000_EEPROM_APME;
+	int bars, i, err;
 	s32 ret_val = 0;
 
 	if (ei->flags2 & FLAG2_DISABLE_ASPM_L0S)
@@ -7401,17 +7401,11 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM);
@@ -7547,10 +7541,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
-	}
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->vlan_features |= NETIF_F_HIGHDMA;
 
 	/* MTU range: 68 - max_hw_frame_size */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ef3375e84821..ccd7e33aa80d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15282,12 +15282,9 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* set up for high or low dma */
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
+		dev_err(&pdev->dev,
+			"DMA configuration failed: 0x%x\n", err);
+		goto err_dma;
 	}
 
 	/* set up pci connections */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 504fea4e90fb..16c73ad1b0d3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4365,12 +4365,9 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
+		dev_err(&pdev->dev,
+			"DMA configuration failed: 0x%x\n", err);
+		goto err_dma;
 	}
 
 	err = pci_request_regions(pdev, iavf_driver_name);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 476533f63e09..4016031e1ba1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4435,8 +4435,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* set up for high or low DMA */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (err)
-		err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(dev, "DMA configuration failed: 0x%x\n", err);
 		return err;
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 99d481904ce6..affdefcca7e3 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -361,7 +361,6 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev = NULL;
 	struct ixgb_adapter *adapter;
 	static int cards_found = 0;
-	int pci_using_dac;
 	u8 addr[ETH_ALEN];
 	int i;
 	int err;
@@ -370,16 +369,10 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		return err;
 
-	pci_using_dac = 0;
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (!err) {
-		pci_using_dac = 1;
-	} else {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			pr_err("No usable DMA configuration, aborting\n");
-			goto err_dma_mask;
-		}
+	if (err) {
+		pr_err("No usable DMA configuration, aborting\n");
+		goto err_dma_mask;
 	}
 
 	err = pci_request_regions(pdev, ixgb_driver_name);
@@ -444,10 +437,8 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features |= NETIF_F_RXCSUM;
 
-	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
-	}
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->vlan_features |= NETIF_F_HIGHDMA;
 
 	/* MTU range: 68 - 16114 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index abb118f0ae69..2bfeeaac5ef8 100644
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
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2459ecf65125..a54c23079da6 100644
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

