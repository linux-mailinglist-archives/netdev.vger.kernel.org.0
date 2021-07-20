Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8933D052C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhGTWhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:37:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:50224 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhGTWhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341471"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341471"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407124"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 01/12] e1000e: Add handshake with the CSME to support S0ix
Date:   Tue, 20 Jul 2021 16:20:50 -0700
Message-Id: <20210720232101.3087589-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

On the corporate system, the driver will ask from the CSME
(manageability engine) to perform device settings are required
to allow S0ix residency.
This patch provides initial support.

Reviewed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.h |   2 +
 drivers/net/ethernet/intel/e1000e/netdev.c  | 328 +++++++++++---------
 2 files changed, 176 insertions(+), 154 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 1502895eb45d..e59456d867db 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -47,6 +47,8 @@
 #define E1000_SHRAH_PCH_LPT(_i)		(0x0540C + ((_i) * 8))
 
 #define E1000_H2ME		0x05B50	/* Host to ME */
+#define E1000_H2ME_START_DPG	0x00000001	/* indicate the ME of DPG */
+#define E1000_H2ME_EXIT_DPG	0x00000002	/* indicate the ME exit DPG */
 #define E1000_H2ME_ULP		0x00000800	/* ULP Indication Bit */
 #define E1000_H2ME_ENFORCE_SETTINGS	0x00001000	/* Enforce Settings */
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 757a54c39eef..4fa6f9f7d199 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6343,42 +6343,104 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
-	/* Disable the periodic inband message,
-	 * don't request PCIe clock in K1 page770_17[10:9] = 10b
-	 */
-	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
-	phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
-	phy_data |= BIT(10);
-	e1e_wphy(hw, HV_PM_CTRL, phy_data);
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+		/* Request ME configure the device for S0ix */
+		mac_data = er32(H2ME);
+		mac_data |= E1000_H2ME_START_DPG;
+		mac_data &= ~E1000_H2ME_EXIT_DPG;
+		ew32(H2ME, mac_data);
+	} else {
+		/* Request driver configure the device to S0ix */
+		/* Disable the periodic inband message,
+		 * don't request PCIe clock in K1 page770_17[10:9] = 10b
+		 */
+		e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+		phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
+		phy_data |= BIT(10);
+		e1e_wphy(hw, HV_PM_CTRL, phy_data);
 
-	/* Make sure we don't exit K1 every time a new packet arrives
-	 * 772_29[5] = 1 CS_Mode_Stay_In_K1
-	 */
-	e1e_rphy(hw, I217_CGFREG, &phy_data);
-	phy_data |= BIT(5);
-	e1e_wphy(hw, I217_CGFREG, phy_data);
+		/* Make sure we don't exit K1 every time a new packet arrives
+		 * 772_29[5] = 1 CS_Mode_Stay_In_K1
+		 */
+		e1e_rphy(hw, I217_CGFREG, &phy_data);
+		phy_data |= BIT(5);
+		e1e_wphy(hw, I217_CGFREG, phy_data);
 
-	/* Change the MAC/PHY interface to SMBus
-	 * Force the SMBus in PHY page769_23[0] = 1
-	 * Force the SMBus in MAC CTRL_EXT[11] = 1
-	 */
-	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
-	phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
-	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
-	mac_data = er32(CTRL_EXT);
-	mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
-	ew32(CTRL_EXT, mac_data);
+		/* Change the MAC/PHY interface to SMBus
+		 * Force the SMBus in PHY page769_23[0] = 1
+		 * Force the SMBus in MAC CTRL_EXT[11] = 1
+		 */
+		e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+		phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
+		e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+		mac_data = er32(CTRL_EXT);
+		mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
+		ew32(CTRL_EXT, mac_data);
+
+		/* DFT control: PHY bit: page769_20[0] = 1
+		 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
+		 */
+		e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
+		phy_data |= BIT(0);
+		e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
+
+		mac_data = er32(EXTCNF_CTRL);
+		mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
+		ew32(EXTCNF_CTRL, mac_data);
+
+		/* Enable the Dynamic Power Gating in the MAC */
+		mac_data = er32(FEXTNVM7);
+		mac_data |= BIT(22);
+		ew32(FEXTNVM7, mac_data);
+
+		/* Disable disconnected cable conditioning for Power Gating */
+		mac_data = er32(DPGFR);
+		mac_data |= BIT(2);
+		ew32(DPGFR, mac_data);
+
+		/* Don't wake from dynamic Power Gating with clock request */
+		mac_data = er32(FEXTNVM12);
+		mac_data |= BIT(12);
+		ew32(FEXTNVM12, mac_data);
+
+		/* Ungate PGCB clock */
+		mac_data = er32(FEXTNVM9);
+		mac_data &= ~BIT(28);
+		ew32(FEXTNVM9, mac_data);
+
+		/* Enable K1 off to enable mPHY Power Gating */
+		mac_data = er32(FEXTNVM6);
+		mac_data |= BIT(31);
+		ew32(FEXTNVM6, mac_data);
+
+		/* Enable mPHY power gating for any link and speed */
+		mac_data = er32(FEXTNVM8);
+		mac_data |= BIT(9);
+		ew32(FEXTNVM8, mac_data);
+
+		/* Enable the Dynamic Clock Gating in the DMA and MAC */
+		mac_data = er32(CTRL_EXT);
+		mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
+		ew32(CTRL_EXT, mac_data);
+
+		/* No MAC DPG gating SLP_S0 in modern standby
+		 * Switch the logic of the lanphypc to use PMC counter
+		 */
+		mac_data = er32(FEXTNVM5);
+		mac_data |= BIT(7);
+		ew32(FEXTNVM5, mac_data);
+	}
 
-	/* DFT control: PHY bit: page769_20[0] = 1
-	 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
-	 */
-	e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
-	phy_data |= BIT(0);
-	e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
+	/* Disable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(31);
+	mac_data &= ~BIT(0);
+	ew32(FEXTNVM7, mac_data);
 
-	mac_data = er32(EXTCNF_CTRL);
-	mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
-	ew32(EXTCNF_CTRL, mac_data);
+	/* Dynamic Power Gating Enable */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= BIT(3);
+	ew32(CTRL_EXT, mac_data);
 
 	/* Check MAC Tx/Rx packet buffer pointers.
 	 * Reset MAC Tx/Rx packet buffer pointers to suppress any
@@ -6414,59 +6476,6 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	mac_data = er32(RDFPC);
 	if (mac_data)
 		ew32(RDFPC, 0);
-
-	/* Enable the Dynamic Power Gating in the MAC */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(22);
-	ew32(FEXTNVM7, mac_data);
-
-	/* Disable the time synchronization clock */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(31);
-	mac_data &= ~BIT(0);
-	ew32(FEXTNVM7, mac_data);
-
-	/* Dynamic Power Gating Enable */
-	mac_data = er32(CTRL_EXT);
-	mac_data |= BIT(3);
-	ew32(CTRL_EXT, mac_data);
-
-	/* Disable disconnected cable conditioning for Power Gating */
-	mac_data = er32(DPGFR);
-	mac_data |= BIT(2);
-	ew32(DPGFR, mac_data);
-
-	/* Don't wake from dynamic Power Gating with clock request */
-	mac_data = er32(FEXTNVM12);
-	mac_data |= BIT(12);
-	ew32(FEXTNVM12, mac_data);
-
-	/* Ungate PGCB clock */
-	mac_data = er32(FEXTNVM9);
-	mac_data &= ~BIT(28);
-	ew32(FEXTNVM9, mac_data);
-
-	/* Enable K1 off to enable mPHY Power Gating */
-	mac_data = er32(FEXTNVM6);
-	mac_data |= BIT(31);
-	ew32(FEXTNVM6, mac_data);
-
-	/* Enable mPHY power gating for any link and speed */
-	mac_data = er32(FEXTNVM8);
-	mac_data |= BIT(9);
-	ew32(FEXTNVM8, mac_data);
-
-	/* Enable the Dynamic Clock Gating in the DMA and MAC */
-	mac_data = er32(CTRL_EXT);
-	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
-	ew32(CTRL_EXT, mac_data);
-
-	/* No MAC DPG gating SLP_S0 in modern standby
-	 * Switch the logic of the lanphypc to use PMC counter
-	 */
-	mac_data = er32(FEXTNVM5);
-	mac_data |= BIT(7);
-	ew32(FEXTNVM5, mac_data);
 }
 
 static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
@@ -6475,87 +6484,98 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
-	/* Disable the Dynamic Power Gating in the MAC */
-	mac_data = er32(FEXTNVM7);
-	mac_data &= 0xFFBFFFFF;
-	ew32(FEXTNVM7, mac_data);
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+		/* Request ME unconfigure the device from S0ix */
+		mac_data = er32(H2ME);
+		mac_data &= ~E1000_H2ME_START_DPG;
+		mac_data |= E1000_H2ME_EXIT_DPG;
+		ew32(H2ME, mac_data);
+	} else {
+		/* Request driver unconfigure the device from S0ix */
+
+		/* Disable the Dynamic Power Gating in the MAC */
+		mac_data = er32(FEXTNVM7);
+		mac_data &= 0xFFBFFFFF;
+		ew32(FEXTNVM7, mac_data);
+
+		/* Disable mPHY power gating for any link and speed */
+		mac_data = er32(FEXTNVM8);
+		mac_data &= ~BIT(9);
+		ew32(FEXTNVM8, mac_data);
+
+		/* Disable K1 off */
+		mac_data = er32(FEXTNVM6);
+		mac_data &= ~BIT(31);
+		ew32(FEXTNVM6, mac_data);
+
+		/* Disable Ungate PGCB clock */
+		mac_data = er32(FEXTNVM9);
+		mac_data |= BIT(28);
+		ew32(FEXTNVM9, mac_data);
+
+		/* Cancel not waking from dynamic
+		 * Power Gating with clock request
+		 */
+		mac_data = er32(FEXTNVM12);
+		mac_data &= ~BIT(12);
+		ew32(FEXTNVM12, mac_data);
 
-	/* Enable the time synchronization clock */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(0);
-	ew32(FEXTNVM7, mac_data);
+		/* Cancel disable disconnected cable conditioning
+		 * for Power Gating
+		 */
+		mac_data = er32(DPGFR);
+		mac_data &= ~BIT(2);
+		ew32(DPGFR, mac_data);
 
-	/* Disable mPHY power gating for any link and speed */
-	mac_data = er32(FEXTNVM8);
-	mac_data &= ~BIT(9);
-	ew32(FEXTNVM8, mac_data);
+		/* Disable the Dynamic Clock Gating in the DMA and MAC */
+		mac_data = er32(CTRL_EXT);
+		mac_data &= 0xFFF7FFFF;
+		ew32(CTRL_EXT, mac_data);
 
-	/* Disable K1 off */
-	mac_data = er32(FEXTNVM6);
-	mac_data &= ~BIT(31);
-	ew32(FEXTNVM6, mac_data);
+		/* Revert the lanphypc logic to use the internal Gbe counter
+		 * and not the PMC counter
+		 */
+		mac_data = er32(FEXTNVM5);
+		mac_data &= 0xFFFFFF7F;
+		ew32(FEXTNVM5, mac_data);
 
-	/* Disable Ungate PGCB clock */
-	mac_data = er32(FEXTNVM9);
-	mac_data |= BIT(28);
-	ew32(FEXTNVM9, mac_data);
+		/* Enable the periodic inband message,
+		 * Request PCIe clock in K1 page770_17[10:9] =01b
+		 */
+		e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+		phy_data &= 0xFBFF;
+		phy_data |= HV_PM_CTRL_K1_CLK_REQ;
+		e1e_wphy(hw, HV_PM_CTRL, phy_data);
 
-	/* Cancel not waking from dynamic
-	 * Power Gating with clock request
-	 */
-	mac_data = er32(FEXTNVM12);
-	mac_data &= ~BIT(12);
-	ew32(FEXTNVM12, mac_data);
+		/* Return back configuration
+		 * 772_29[5] = 0 CS_Mode_Stay_In_K1
+		 */
+		e1e_rphy(hw, I217_CGFREG, &phy_data);
+		phy_data &= 0xFFDF;
+		e1e_wphy(hw, I217_CGFREG, phy_data);
 
-	/* Cancel disable disconnected cable conditioning
-	 * for Power Gating
-	 */
-	mac_data = er32(DPGFR);
-	mac_data &= ~BIT(2);
-	ew32(DPGFR, mac_data);
+		/* Change the MAC/PHY interface to Kumeran
+		 * Unforce the SMBus in PHY page769_23[0] = 0
+		 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
+		 */
+		e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+		phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
+		e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+		mac_data = er32(CTRL_EXT);
+		mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
+		ew32(CTRL_EXT, mac_data);
+	}
 
 	/* Disable Dynamic Power Gating */
 	mac_data = er32(CTRL_EXT);
 	mac_data &= 0xFFFFFFF7;
 	ew32(CTRL_EXT, mac_data);
 
-	/* Disable the Dynamic Clock Gating in the DMA and MAC */
-	mac_data = er32(CTRL_EXT);
-	mac_data &= 0xFFF7FFFF;
-	ew32(CTRL_EXT, mac_data);
-
-	/* Revert the lanphypc logic to use the internal Gbe counter
-	 * and not the PMC counter
-	 */
-	mac_data = er32(FEXTNVM5);
-	mac_data &= 0xFFFFFF7F;
-	ew32(FEXTNVM5, mac_data);
-
-	/* Enable the periodic inband message,
-	 * Request PCIe clock in K1 page770_17[10:9] =01b
-	 */
-	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
-	phy_data &= 0xFBFF;
-	phy_data |= HV_PM_CTRL_K1_CLK_REQ;
-	e1e_wphy(hw, HV_PM_CTRL, phy_data);
-
-	/* Return back configuration
-	 * 772_29[5] = 0 CS_Mode_Stay_In_K1
-	 */
-	e1e_rphy(hw, I217_CGFREG, &phy_data);
-	phy_data &= 0xFFDF;
-	e1e_wphy(hw, I217_CGFREG, phy_data);
-
-	/* Change the MAC/PHY interface to Kumeran
-	 * Unforce the SMBus in PHY page769_23[0] = 0
-	 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
-	 */
-	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
-	phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
-	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
-	mac_data = er32(CTRL_EXT);
-	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
-	ew32(CTRL_EXT, mac_data);
+	/* Enable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data &= ~BIT(31);
+	mac_data |= BIT(0);
+	ew32(FEXTNVM7, mac_data);
 }
 
 static int e1000e_pm_freeze(struct device *dev)
-- 
2.26.2

