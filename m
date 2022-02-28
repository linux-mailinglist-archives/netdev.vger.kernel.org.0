Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F514C77E9
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiB1Sfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240793AbiB1Sf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:35:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EF31CFE7
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 10:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646072438; x=1677608438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQRB8Hjn1X/73f8O5SSZAuL8j4CzumFYcrDMR5Z2IVI=;
  b=CDNUtUaW5lrYameUhjpb80SLeY8ZTIob/vFPhfjpkcXDLGWoioVKxJPQ
   yfCucCdGZxsrXTQ6at3PCcKgcq0E7CpK1zVlPufzTd1wtPdQM3WxTWo3I
   xFPsNEC9WHWgI/jpAGKCIT/Ws1lvHoE8exXstkft/rpn3wzCcd3kwq8Id
   5F/VgD4OOFEz9OKn0lEiY2NQsOT82eCWSwyQWLtGmAIdUzwhgdTEvKOjx
   h+dUa5CufAfhBOgRlSi/drqw874Tk0PTdGksYIkaWc6SwVX9KpXmM8y+F
   qtutrTJSwxdwHVRnhc41nquVGhNCCbN4oXB0r+bN2x96b8siWtRMvBZhh
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316165878"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="316165878"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 10:20:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575406560"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 10:20:35 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Nir Efrati <nir.efrati@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net 3/4] e1000e: Fix possible HW unit hang after an s0ix exit
Date:   Mon, 28 Feb 2022 10:20:44 -0800
Message-Id: <20220228182045.1562938-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220228182045.1562938-1-anthony.l.nguyen@intel.com>
References: <20220228182045.1562938-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Disable the OEM bit/Gig Disable/restart AN impact and disable the PHY
LAN connected device (LCD) reset during power management flows. This
fixes possible HW unit hangs on the s0ix exit on some corporate ADL
platforms.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix)
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Suggested-by: Nir Efrati <nir.efrati@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h      |  1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 ++++
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 +
 drivers/net/ethernet/intel/e1000e/netdev.c  | 26 +++++++++++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index bcf680e83811..13382df2f2ef 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -630,6 +630,7 @@ struct e1000_phy_info {
 	bool disable_polarity_correction;
 	bool is_mdix;
 	bool polarity_correction;
+	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index c908c84b86d2..e298da712758 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2050,6 +2050,10 @@ static s32 e1000_check_reset_block_ich8lan(struct e1000_hw *hw)
 	bool blocked = false;
 	int i = 0;
 
+	/* Check the PHY (LCD) reset flag */
+	if (hw->phy.reset_disable)
+		return true;
+
 	while ((blocked = !(er32(FWSM) & E1000_ICH_FWSM_RSPCIPHY)) &&
 	       (i++ < 30))
 		usleep_range(10000, 11000);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 2504b11c3169..638a3ddd7ada 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -271,6 +271,7 @@
 #define I217_CGFREG_ENABLE_MTA_RESET	0x0002
 #define I217_MEMPWR			PHY_REG(772, 26)
 #define I217_MEMPWR_DISABLE_SMB_RELEASE	0x0010
+#define I217_MEMPWR_MOEM		0x1000
 
 /* Receive Address Initial CRC Calculation */
 #define E1000_PCH_RAICC(_n)	(0x05F50 + ((_n) * 4))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a42aeb555f34..c5bdef3ffe26 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6987,8 +6987,21 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
+		/* Mask OEM Bits / Gig Disable / Restart AN (772_26[12] = 1) */
+		e1e_rphy(hw, I217_MEMPWR, &phy_data);
+		phy_data |= I217_MEMPWR_MOEM;
+		e1e_wphy(hw, I217_MEMPWR, phy_data);
+
+		/* Disable LCD reset */
+		hw->phy.reset_disable = true;
+	}
+
 	e1000e_flush_lpic(pdev);
 
 	e1000e_pm_freeze(dev);
@@ -7010,6 +7023,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
+	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7020,6 +7035,17 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	if (rc)
 		return rc;
 
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
+		/* Unmask OEM Bits / Gig Disable / Restart AN 772_26[12] = 0 */
+		e1e_rphy(hw, I217_MEMPWR, &phy_data);
+		phy_data &= ~I217_MEMPWR_MOEM;
+		e1e_wphy(hw, I217_MEMPWR, phy_data);
+
+		/* Enable LCD reset */
+		hw->phy.reset_disable = false;
+	}
+
 	return e1000e_pm_thaw(dev);
 }
 
-- 
2.31.1

