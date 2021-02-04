Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350B330E8D9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhBDArd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:47:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234526AbhBDAo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:44:27 -0500
IronPort-SDR: 6F7B1A4htiN1dBM6MUWqZ3Jyv+BAdH+HvBSc6CiRWFM+prxvZ5fKlH0ZV4NuOliUE57Bkl/pC/
 we2uMxlEz7Tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638228"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638228"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:13 -0800
IronPort-SDR: YV3bQcCx9cOQjbCVEm9aieSfiHUS9k89RxW8oggIZWCGY4jlQ4f8wJFibTz3WWLIMsXOlo4uKJ
 hTtgXot/rYVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687493"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 06/15] igc: Expose the gPHY firmware version
Date:   Wed,  3 Feb 2021 16:42:50 -0800
Message-Id: <20210204004259.3662059-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Extend reporting of NVM image version to include the gPHY (i225 PHY)
firmware version.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  9 +++++++--
 drivers/net/ethernet/intel/igc/igc_phy.c     | 18 ++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_phy.h     |  1 +
 drivers/net/ethernet/intel/igc/igc_regs.h    |  1 +
 5 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 2d8b1716a20c..5d2809dfd06a 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -218,7 +218,7 @@ struct igc_adapter {
 	struct timespec64 prev_ptp_time; /* Pre-reset PTP clock */
 	ktime_t ptp_reset_start; /* Reset time in clock mono */
 
-	char fw_version[16];
+	char fw_version[32];
 };
 
 void igc_up(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 7dd1ca7f3ed5..a3811d7e59bc 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -131,16 +131,21 @@ static void igc_ethtool_get_drvinfo(struct net_device *netdev,
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	struct igc_hw *hw = &adapter->hw;
 	u16 nvm_version = 0;
+	u16 gphy_version;
 
 	strscpy(drvinfo->driver, igc_driver_name, sizeof(drvinfo->driver));
 
 	/* NVM image version is reported as firmware version for i225 device */
 	hw->nvm.ops.read(hw, IGC_NVM_DEV_STARTER, 1, &nvm_version);
 
+	/* gPHY firmware version is reported as PHY FW version */
+	gphy_version = igc_read_phy_fw_version(hw);
+
 	scnprintf(adapter->fw_version,
 		  sizeof(adapter->fw_version),
-		  "%x",
-		  nvm_version);
+		  "%x:%x",
+		  nvm_version,
+		  gphy_version);
 
 	strscpy(drvinfo->fw_version, adapter->fw_version,
 		sizeof(drvinfo->fw_version));
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 8e1799508edc..83aeb5e7076f 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -791,3 +791,21 @@ s32 igc_read_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 *data)
 
 	return ret_val;
 }
+
+/**
+ * igc_read_phy_fw_version - Read gPHY firmware version
+ * @hw: pointer to the HW structure
+ */
+u16 igc_read_phy_fw_version(struct igc_hw *hw)
+{
+	struct igc_phy_info *phy = &hw->phy;
+	u16 gphy_version = 0;
+	u16 ret_val;
+
+	/* NVM image version is reported as firmware version for i225 device */
+	ret_val = phy->ops.read_reg(hw, IGC_GPHY_VERSION, &gphy_version);
+	if (ret_val)
+		hw_dbg("igc_phy: read wrong gphy version\n");
+
+	return gphy_version;
+}
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.h b/drivers/net/ethernet/intel/igc/igc_phy.h
index 25cba33de7e2..1b031372d206 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.h
+++ b/drivers/net/ethernet/intel/igc/igc_phy.h
@@ -17,5 +17,6 @@ void igc_power_up_phy_copper(struct igc_hw *hw);
 void igc_power_down_phy_copper(struct igc_hw *hw);
 s32 igc_write_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 data);
 s32 igc_read_phy_reg_gpy(struct igc_hw *hw, u32 offset, u16 *data);
+u16 igc_read_phy_fw_version(struct igc_hw *hw);
 
 #endif
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index b52dd9d737e8..3e5cb7aef9da 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -13,6 +13,7 @@
 #define IGC_MDICNFG		0x00E04  /* MDC/MDIO Configuration - RW */
 #define IGC_CONNSW		0x00034  /* Copper/Fiber switch control - RW */
 #define IGC_I225_PHPM		0x00E14  /* I225 PHY Power Management */
+#define IGC_GPHY_VERSION	0x0001E  /* I225 gPHY Firmware Version */
 
 /* Internal Packet Buffer Size Registers */
 #define IGC_RXPBS		0x02404  /* Rx Packet Buffer Size - RW */
-- 
2.26.2

