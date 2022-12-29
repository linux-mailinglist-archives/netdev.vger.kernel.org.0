Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF9658CAD
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiL2M0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiL2M0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:26:39 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E7F263C;
        Thu, 29 Dec 2022 04:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672316798; x=1703852798;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dn3epGzIAwWUMYhcvjgvIraCnxNDGBxxZThnjliU4Tw=;
  b=Z+3/Dx+hEFfWZ/sCBI1YvpUQ59mO+HGjoUbRf7n6iQ4+do1cOFk5K+p8
   5Azf0GI9dNqszWyFX3nc0jDoXLIeUPxFyF5Ud1q8hM6inagu2ILLTKESv
   Q8mSZQ/5pFugLwP/I153CGTF1MHth9nHcluMcqtTGf/mqi/Fv03FS8DHf
   ANDoLtuS1KrFAHO2VQ+emWXJ5FauZLYz9YdY3/y/vvcX7wS6kzpnua9Ao
   N40jQpOcz9oSejYeS3pk51Ke1jFjWO6G9wCjEUf44T6wH1B6n+iLQnYYC
   JL8ZEm3pMwuhnXstN31Q+SEenPHonuSHa05q6jihbnRahJxdSNebhViht
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="348243043"
X-IronPort-AV: E=Sophos;i="5.96,284,1665471600"; 
   d="scan'208";a="348243043"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 04:26:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="795956079"
X-IronPort-AV: E=Sophos;i="5.96,284,1665471600"; 
   d="scan'208";a="795956079"
Received: from unknown (HELO rajath-NUC10i7FNH..) ([10.223.165.88])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 04:26:34 -0800
From:   Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rajat.khandelwal@intel.com,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
Subject: [PATCH] igc: Mask replay rollover/timeout errors in I225_LMVP
Date:   Thu, 29 Dec 2022 17:56:40 +0530
Message-Id: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPU logs get flooded with replay rollover/timeout AER errors in
the system with i225_lmvp connected, usually inside thunderbolt devices.

One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
an Intel Foxville chipset, which uses the igc driver.
On connecting ethernet, CPU logs get inundated with these errors. The point
is we shouldn't be spamming the logs with such correctible errors as it
confuses other kernel developers less familiar with PCI errors, support
staff, and users who happen to look at the logs.

Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 28 +++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebff0e04045d..a3a6e8086c8d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6201,6 +6201,26 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	return value;
 }
 
+#ifdef CONFIG_PCIEAER
+static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	u32 aer_pos, corr_mask;
+
+	if (pdev->device != IGC_DEV_ID_I225_LMVP)
+		return;
+
+	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (!aer_pos)
+		return;
+
+	pci_read_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, &corr_mask);
+
+	corr_mask |= PCI_ERR_COR_REP_ROLL | PCI_ERR_COR_REP_TIMER;
+	pci_write_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, corr_mask);
+}
+#endif
+
 /**
  * igc_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -6236,8 +6256,6 @@ static int igc_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_pci_reg;
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	err = pci_enable_ptm(pdev, NULL);
 	if (err < 0)
 		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
@@ -6272,6 +6290,12 @@ static int igc_probe(struct pci_dev *pdev,
 	if (!adapter->io_addr)
 		goto err_ioremap;
 
+#ifdef CONFIG_PCIEAER
+	igc_mask_aer_replay_correctible(adapter);
+#endif
+
+	pci_enable_pcie_error_reporting(pdev);
+
 	/* hw->hw_addr can be zeroed, so use adapter->io_addr for unmap */
 	hw->hw_addr = adapter->io_addr;
 
-- 
2.34.1

