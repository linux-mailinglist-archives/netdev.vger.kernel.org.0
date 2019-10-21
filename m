Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBAADF4A7
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbfJUSBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:01:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:30872 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfJUSBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 14:01:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 11:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,324,1566889200"; 
   d="scan'208";a="196186046"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 11:01:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 2/5] e1000e: Add support for S0ix
Date:   Mon, 21 Oct 2019 11:01:40 -0700
Message-Id: <20191021180143.11775-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
References: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Implement flow for S0ix support. Modern SoCs support S0ix low power
states during idle periods, which are sub-states of ACPI S0 that increase
power saving while supporting an instant-on experience for providing
lower latency that ACPI S0. The S0ix states shut off parts of the SoC
when they are not in use, while still maintaning optimal performance.
This patch add support for S0ix started from an Ice Lake platform.

Suggested-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 182 +++++++++++++++++++++
 drivers/net/ethernet/intel/e1000e/regs.h   |   4 +
 2 files changed, 186 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d7d56e42a6aa..42f57ab8fb8e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6294,6 +6294,174 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 	pm_runtime_put_sync(netdev->dev.parent);
 }
 
+/* S0ix implementation */
+static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 mac_data;
+	u16 phy_data;
+
+	/* Disable the periodic inband message,
+	 * don't request PCIe clock in K1 page770_17[10:9] = 10b
+	 */
+	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+	phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
+	phy_data |= BIT(10);
+	e1e_wphy(hw, HV_PM_CTRL, phy_data);
+
+	/* Make sure we don't exit K1 every time a new packet arrives
+	 * 772_29[5] = 1 CS_Mode_Stay_In_K1
+	 */
+	e1e_rphy(hw, I217_CGFREG, &phy_data);
+	phy_data |= BIT(5);
+	e1e_wphy(hw, I217_CGFREG, phy_data);
+
+	/* Change the MAC/PHY interface to SMBus
+	 * Force the SMBus in PHY page769_23[0] = 1
+	 * Force the SMBus in MAC CTRL_EXT[11] = 1
+	 */
+	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+	phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
+	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+	mac_data = er32(CTRL_EXT);
+	mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, mac_data);
+
+	/* DFT control: PHY bit: page769_20[0] = 1
+	 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
+	 */
+	e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
+	phy_data |= BIT(0);
+	e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
+
+	mac_data = er32(EXTCNF_CTRL);
+	mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
+	ew32(EXTCNF_CTRL, mac_data);
+
+	/* Check MAC Tx/Rx packet buffer pointers.
+	 * Reset MAC Tx/Rx packet buffer pointers to suppress any
+	 * pending traffic indication that would prevent power gating.
+	 */
+	mac_data = er32(TDFH);
+	if (mac_data)
+		ew32(TDFH, 0);
+	mac_data = er32(TDFT);
+	if (mac_data)
+		ew32(TDFT, 0);
+	mac_data = er32(TDFHS);
+	if (mac_data)
+		ew32(TDFHS, 0);
+	mac_data = er32(TDFTS);
+	if (mac_data)
+		ew32(TDFTS, 0);
+	mac_data = er32(TDFPC);
+	if (mac_data)
+		ew32(TDFPC, 0);
+	mac_data = er32(RDFH);
+	if (mac_data)
+		ew32(RDFH, 0);
+	mac_data = er32(RDFT);
+	if (mac_data)
+		ew32(RDFT, 0);
+	mac_data = er32(RDFHS);
+	if (mac_data)
+		ew32(RDFHS, 0);
+	mac_data = er32(RDFTS);
+	if (mac_data)
+		ew32(RDFTS, 0);
+	mac_data = er32(RDFPC);
+	if (mac_data)
+		ew32(RDFPC, 0);
+
+	/* Enable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(22);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Disable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(31);
+	mac_data &= ~BIT(0);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Dynamic Power Gating Enable */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= BIT(3);
+	ew32(CTRL_EXT, mac_data);
+
+	/* Enable the Dynamic Clock Gating in the DMA and MAC */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
+	ew32(CTRL_EXT, mac_data);
+
+	/* No MAC DPG gating SLP_S0 in modern standby
+	 * Switch the logic of the lanphypc to use PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data |= BIT(7);
+	ew32(FEXTNVM5, mac_data);
+}
+
+static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 mac_data;
+	u16 phy_data;
+
+	/* Disable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data &= 0xFFBFFFFF;
+	ew32(FEXTNVM7, mac_data);
+
+	/* Enable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(0);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Disable Dynamic Power Gating */
+	mac_data = er32(CTRL_EXT);
+	mac_data &= 0xFFFFFFF7;
+	ew32(CTRL_EXT, mac_data);
+
+	/* Disable the Dynamic Clock Gating in the DMA and MAC */
+	mac_data = er32(CTRL_EXT);
+	mac_data &= 0xFFF7FFFF;
+	ew32(CTRL_EXT, mac_data);
+
+	/* Revert the lanphypc logic to use the internal Gbe counter
+	 * and not the PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data &= 0xFFFFFF7F;
+	ew32(FEXTNVM5, mac_data);
+
+	/* Enable the periodic inband message,
+	 * Request PCIe clock in K1 page770_17[10:9] =01b
+	 */
+	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+	phy_data &= 0xFBFF;
+	phy_data |= HV_PM_CTRL_K1_CLK_REQ;
+	e1e_wphy(hw, HV_PM_CTRL, phy_data);
+
+	/* Return back configuration
+	 * 772_29[5] = 0 CS_Mode_Stay_In_K1
+	 */
+	e1e_rphy(hw, I217_CGFREG, &phy_data);
+	phy_data &= 0xFFDF;
+	e1e_wphy(hw, I217_CGFREG, phy_data);
+
+	/* Change the MAC/PHY interface to Kumeran
+	 * Unforce the SMBus in PHY page769_23[0] = 0
+	 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
+	 */
+	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+	phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
+	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+	mac_data = er32(CTRL_EXT);
+	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, mac_data);
+}
+
 static int e1000e_pm_freeze(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
@@ -6649,7 +6817,10 @@ static int e1000e_pm_thaw(struct device *dev)
 
 static int e1000e_pm_suspend(struct device *dev)
 {
+	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
 	int rc;
 
 	e1000e_flush_lpic(pdev);
@@ -6660,14 +6831,25 @@ static int e1000e_pm_suspend(struct device *dev)
 	if (rc)
 		e1000e_pm_thaw(dev);
 
+	/* Introduce S0ix implementation */
+	if (hw->mac.type >= e1000_pch_cnp)
+		e1000e_s0ix_entry_flow(adapter);
+
 	return rc;
 }
 
 static int e1000e_pm_resume(struct device *dev)
 {
+	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct e1000_hw *hw = &adapter->hw;
 	int rc;
 
+	/* Introduce S0ix implementation */
+	if (hw->mac.type >= e1000_pch_cnp)
+		e1000e_s0ix_exit_flow(adapter);
+
 	rc = __e1000_resume(pdev);
 	if (rc)
 		return rc;
diff --git a/drivers/net/ethernet/intel/e1000e/regs.h b/drivers/net/ethernet/intel/e1000e/regs.h
index 47f5ca793970..df59fd1d660c 100644
--- a/drivers/net/ethernet/intel/e1000e/regs.h
+++ b/drivers/net/ethernet/intel/e1000e/regs.h
@@ -18,6 +18,7 @@
 #define E1000_FEXTNVM	0x00028	/* Future Extended NVM - RW */
 #define E1000_FEXTNVM3	0x0003C	/* Future Extended NVM 3 - RW */
 #define E1000_FEXTNVM4	0x00024	/* Future Extended NVM 4 - RW */
+#define E1000_FEXTNVM5	0x00014	/* Future Extended NVM 5 - RW */
 #define E1000_FEXTNVM6	0x00010	/* Future Extended NVM 6 - RW */
 #define E1000_FEXTNVM7	0x000E4	/* Future Extended NVM 7 - RW */
 #define E1000_FEXTNVM9	0x5BB4	/* Future Extended NVM 9 - RW */
@@ -234,4 +235,7 @@
 #define E1000_RXMTRL	0x0B634	/* Time sync Rx EtherType and Msg Type - RW */
 #define E1000_RXUDP	0x0B638	/* Time Sync Rx UDP Port - RW */
 
+/* PHY registers */
+#define I82579_DFT_CTRL	PHY_REG(769, 20)
+
 #endif
-- 
2.21.0

