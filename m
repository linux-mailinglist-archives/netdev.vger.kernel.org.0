Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89B49FAC5
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfH1Goi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:35208 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfH1GoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443790"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] igc: Remove useless forward declaration
Date:   Tue, 27 Aug 2019 23:43:56 -0700
Message-Id: <20190828064407.30168-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Move igc_phy_setup_autoneg, igc_wait_autoneg and igc_set_fc_watermarks
up to avoid forward declaration.
It is not necessary to forward declare these static methods.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c |  73 +++++----
 drivers/net/ethernet/intel/igc/igc_phy.c | 192 +++++++++++------------
 2 files changed, 129 insertions(+), 136 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index ba4646737288..5eeb4c8caf4a 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -7,9 +7,6 @@
 #include "igc_mac.h"
 #include "igc_hw.h"
 
-/* forward declaration */
-static s32 igc_set_fc_watermarks(struct igc_hw *hw);
-
 /**
  * igc_disable_pcie_master - Disables PCI-express master access
  * @hw: pointer to the HW structure
@@ -74,6 +71,41 @@ void igc_init_rx_addrs(struct igc_hw *hw, u16 rar_count)
 		hw->mac.ops.rar_set(hw, mac_addr, i);
 }
 
+/**
+ * igc_set_fc_watermarks - Set flow control high/low watermarks
+ * @hw: pointer to the HW structure
+ *
+ * Sets the flow control high/low threshold (watermark) registers.  If
+ * flow control XON frame transmission is enabled, then set XON frame
+ * transmission as well.
+ */
+static s32 igc_set_fc_watermarks(struct igc_hw *hw)
+{
+	u32 fcrtl = 0, fcrth = 0;
+
+	/* Set the flow control receive threshold registers.  Normally,
+	 * these registers will be set to a default threshold that may be
+	 * adjusted later by the driver's runtime code.  However, if the
+	 * ability to transmit pause frames is not enabled, then these
+	 * registers will be set to 0.
+	 */
+	if (hw->fc.current_mode & igc_fc_tx_pause) {
+		/* We need to set up the Receive Threshold high and low water
+		 * marks as well as (optionally) enabling the transmission of
+		 * XON frames.
+		 */
+		fcrtl = hw->fc.low_water;
+		if (hw->fc.send_xon)
+			fcrtl |= IGC_FCRTL_XONE;
+
+		fcrth = hw->fc.high_water;
+	}
+	wr32(IGC_FCRTL, fcrtl);
+	wr32(IGC_FCRTH, fcrth);
+
+	return 0;
+}
+
 /**
  * igc_setup_link - Setup flow control and link settings
  * @hw: pointer to the HW structure
@@ -194,41 +226,6 @@ s32 igc_force_mac_fc(struct igc_hw *hw)
 	return ret_val;
 }
 
-/**
- * igc_set_fc_watermarks - Set flow control high/low watermarks
- * @hw: pointer to the HW structure
- *
- * Sets the flow control high/low threshold (watermark) registers.  If
- * flow control XON frame transmission is enabled, then set XON frame
- * transmission as well.
- */
-static s32 igc_set_fc_watermarks(struct igc_hw *hw)
-{
-	u32 fcrtl = 0, fcrth = 0;
-
-	/* Set the flow control receive threshold registers.  Normally,
-	 * these registers will be set to a default threshold that may be
-	 * adjusted later by the driver's runtime code.  However, if the
-	 * ability to transmit pause frames is not enabled, then these
-	 * registers will be set to 0.
-	 */
-	if (hw->fc.current_mode & igc_fc_tx_pause) {
-		/* We need to set up the Receive Threshold high and low water
-		 * marks as well as (optionally) enabling the transmission of
-		 * XON frames.
-		 */
-		fcrtl = hw->fc.low_water;
-		if (hw->fc.send_xon)
-			fcrtl |= IGC_FCRTL_XONE;
-
-		fcrth = hw->fc.high_water;
-	}
-	wr32(IGC_FCRTL, fcrtl);
-	wr32(IGC_FCRTH, fcrth);
-
-	return 0;
-}
-
 /**
  * igc_clear_hw_cntrs_base - Clear base hardware counters
  * @hw: pointer to the HW structure
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 4c8f96a9a148..f4b05af0dd2f 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -3,10 +3,6 @@
 
 #include "igc_phy.h"
 
-/* forward declaration */
-static s32 igc_phy_setup_autoneg(struct igc_hw *hw);
-static s32 igc_wait_autoneg(struct igc_hw *hw);
-
 /**
  * igc_check_reset_block - Check if PHY reset is blocked
  * @hw: pointer to the HW structure
@@ -207,100 +203,6 @@ s32 igc_phy_hw_reset(struct igc_hw *hw)
 	return ret_val;
 }
 
-/**
- * igc_copper_link_autoneg - Setup/Enable autoneg for copper link
- * @hw: pointer to the HW structure
- *
- * Performs initial bounds checking on autoneg advertisement parameter, then
- * configure to advertise the full capability.  Setup the PHY to autoneg
- * and restart the negotiation process between the link partner.  If
- * autoneg_wait_to_complete, then wait for autoneg to complete before exiting.
- */
-static s32 igc_copper_link_autoneg(struct igc_hw *hw)
-{
-	struct igc_phy_info *phy = &hw->phy;
-	u16 phy_ctrl;
-	s32 ret_val;
-
-	/* Perform some bounds checking on the autoneg advertisement
-	 * parameter.
-	 */
-	phy->autoneg_advertised &= phy->autoneg_mask;
-
-	/* If autoneg_advertised is zero, we assume it was not defaulted
-	 * by the calling code so we set to advertise full capability.
-	 */
-	if (phy->autoneg_advertised == 0)
-		phy->autoneg_advertised = phy->autoneg_mask;
-
-	hw_dbg("Reconfiguring auto-neg advertisement params\n");
-	ret_val = igc_phy_setup_autoneg(hw);
-	if (ret_val) {
-		hw_dbg("Error Setting up Auto-Negotiation\n");
-		goto out;
-	}
-	hw_dbg("Restarting Auto-Neg\n");
-
-	/* Restart auto-negotiation by setting the Auto Neg Enable bit and
-	 * the Auto Neg Restart bit in the PHY control register.
-	 */
-	ret_val = phy->ops.read_reg(hw, PHY_CONTROL, &phy_ctrl);
-	if (ret_val)
-		goto out;
-
-	phy_ctrl |= (MII_CR_AUTO_NEG_EN | MII_CR_RESTART_AUTO_NEG);
-	ret_val = phy->ops.write_reg(hw, PHY_CONTROL, phy_ctrl);
-	if (ret_val)
-		goto out;
-
-	/* Does the user want to wait for Auto-Neg to complete here, or
-	 * check at a later time (for example, callback routine).
-	 */
-	if (phy->autoneg_wait_to_complete) {
-		ret_val = igc_wait_autoneg(hw);
-		if (ret_val) {
-			hw_dbg("Error while waiting for autoneg to complete\n");
-			goto out;
-		}
-	}
-
-	hw->mac.get_link_status = true;
-
-out:
-	return ret_val;
-}
-
-/**
- * igc_wait_autoneg - Wait for auto-neg completion
- * @hw: pointer to the HW structure
- *
- * Waits for auto-negotiation to complete or for the auto-negotiation time
- * limit to expire, which ever happens first.
- */
-static s32 igc_wait_autoneg(struct igc_hw *hw)
-{
-	u16 i, phy_status;
-	s32 ret_val = 0;
-
-	/* Break after autoneg completes or PHY_AUTO_NEG_LIMIT expires. */
-	for (i = PHY_AUTO_NEG_LIMIT; i > 0; i--) {
-		ret_val = hw->phy.ops.read_reg(hw, PHY_STATUS, &phy_status);
-		if (ret_val)
-			break;
-		ret_val = hw->phy.ops.read_reg(hw, PHY_STATUS, &phy_status);
-		if (ret_val)
-			break;
-		if (phy_status & MII_SR_AUTONEG_COMPLETE)
-			break;
-		msleep(100);
-	}
-
-	/* PHY_AUTO_NEG_TIME expiration doesn't guarantee auto-negotiation
-	 * has completed.
-	 */
-	return ret_val;
-}
-
 /**
  * igc_phy_setup_autoneg - Configure PHY for auto-negotiation
  * @hw: pointer to the HW structure
@@ -485,6 +387,100 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 	return ret_val;
 }
 
+/**
+ * igc_wait_autoneg - Wait for auto-neg completion
+ * @hw: pointer to the HW structure
+ *
+ * Waits for auto-negotiation to complete or for the auto-negotiation time
+ * limit to expire, which ever happens first.
+ */
+static s32 igc_wait_autoneg(struct igc_hw *hw)
+{
+	u16 i, phy_status;
+	s32 ret_val = 0;
+
+	/* Break after autoneg completes or PHY_AUTO_NEG_LIMIT expires. */
+	for (i = PHY_AUTO_NEG_LIMIT; i > 0; i--) {
+		ret_val = hw->phy.ops.read_reg(hw, PHY_STATUS, &phy_status);
+		if (ret_val)
+			break;
+		ret_val = hw->phy.ops.read_reg(hw, PHY_STATUS, &phy_status);
+		if (ret_val)
+			break;
+		if (phy_status & MII_SR_AUTONEG_COMPLETE)
+			break;
+		msleep(100);
+	}
+
+	/* PHY_AUTO_NEG_TIME expiration doesn't guarantee auto-negotiation
+	 * has completed.
+	 */
+	return ret_val;
+}
+
+/**
+ * igc_copper_link_autoneg - Setup/Enable autoneg for copper link
+ * @hw: pointer to the HW structure
+ *
+ * Performs initial bounds checking on autoneg advertisement parameter, then
+ * configure to advertise the full capability.  Setup the PHY to autoneg
+ * and restart the negotiation process between the link partner.  If
+ * autoneg_wait_to_complete, then wait for autoneg to complete before exiting.
+ */
+static s32 igc_copper_link_autoneg(struct igc_hw *hw)
+{
+	struct igc_phy_info *phy = &hw->phy;
+	u16 phy_ctrl;
+	s32 ret_val;
+
+	/* Perform some bounds checking on the autoneg advertisement
+	 * parameter.
+	 */
+	phy->autoneg_advertised &= phy->autoneg_mask;
+
+	/* If autoneg_advertised is zero, we assume it was not defaulted
+	 * by the calling code so we set to advertise full capability.
+	 */
+	if (phy->autoneg_advertised == 0)
+		phy->autoneg_advertised = phy->autoneg_mask;
+
+	hw_dbg("Reconfiguring auto-neg advertisement params\n");
+	ret_val = igc_phy_setup_autoneg(hw);
+	if (ret_val) {
+		hw_dbg("Error Setting up Auto-Negotiation\n");
+		goto out;
+	}
+	hw_dbg("Restarting Auto-Neg\n");
+
+	/* Restart auto-negotiation by setting the Auto Neg Enable bit and
+	 * the Auto Neg Restart bit in the PHY control register.
+	 */
+	ret_val = phy->ops.read_reg(hw, PHY_CONTROL, &phy_ctrl);
+	if (ret_val)
+		goto out;
+
+	phy_ctrl |= (MII_CR_AUTO_NEG_EN | MII_CR_RESTART_AUTO_NEG);
+	ret_val = phy->ops.write_reg(hw, PHY_CONTROL, phy_ctrl);
+	if (ret_val)
+		goto out;
+
+	/* Does the user want to wait for Auto-Neg to complete here, or
+	 * check at a later time (for example, callback routine).
+	 */
+	if (phy->autoneg_wait_to_complete) {
+		ret_val = igc_wait_autoneg(hw);
+		if (ret_val) {
+			hw_dbg("Error while waiting for autoneg to complete\n");
+			goto out;
+		}
+	}
+
+	hw->mac.get_link_status = true;
+
+out:
+	return ret_val;
+}
+
 /**
  * igc_setup_copper_link - Configure copper link settings
  * @hw: pointer to the HW structure
-- 
2.21.0

