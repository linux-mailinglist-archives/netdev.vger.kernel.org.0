Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA9163E0E8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiK3Tnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiK3Tno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7769993A6D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837422; x=1701373422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GpFNvsJSjZrdN10Wn6utiExRXsQ1OKie0JeLWZJKNG4=;
  b=ST3bdM3NDSU6dVtHYZd5y58H4QYr0hztLF8p3JV/nhp96CjyblYmKSIr
   hqnX/YUf6SEqIWQCMOmMuhzNDH0IxhphG2v81yJ83Oc+fXnPQUKxpn7Hx
   TDUR0fr9LFkDk7M3jkSEbMY/ZB2K2/14j1xPrlyFEGGyPOEX20wo4Br0L
   MWgNlfArXgl6RquMVE18xjrhGOTkx8ezsM0exxCQ1KXq31/Hv2RFaCSiD
   dFbKAFMdXFj0QlwrXzYwF4WV1ZneSoeUx2tAAgR7jQQK6BFzwnW0Tz+wb
   SRnzo7EhJsvZLIvMmsJkS+rQ1MVNGcxgfgR2Dtadcjfv8H7tvaza2U0GC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098364"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098364"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752276"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752276"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Milena Olech <milena.olech@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 02/14] ice: Remove the E822 vernier "bypass" logic
Date:   Wed, 30 Nov 2022 11:43:18 -0800
Message-Id: <20221130194330.3257836-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Milena Olech <milena.olech@intel.com>

The E822 devices support an extended "vernier" calibration which enables
higher precision timestamps by accounting for delays in the PHY, and
compensating for them. These delays are measured by hardware as part of its
vernier calibration logic.

The driver currently starts the PHY in "bypass" mode which skips
the compensation. Then it later attempts to switch from bypass to vernier.
This unfortunately does not work as expected. Instead of properly
compensating for the delays, the hardware continues operating in bypass
without the improved precision expected.

Because we cannot dynamically switch between bypass and vernier mode,
refactor the driver to always operate in vernier mode. This has a slight
downside: Tx timestamp and Rx timestamp requests that occur as the very
first packet set after link up will not complete properly and may be
reported to applications as missing timestamps.

This occurs frequently in test environments where traffic is light or
targeted specifically at testing PTP. However, in practice most
environments will have transmitted or received some data over the network
before such initial requests are made.

Signed-off-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c    |  10 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 145 +-------------------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |   4 +-
 3 files changed, 14 insertions(+), 145 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f41f4674cadd..9539d2d37c5b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1252,10 +1252,10 @@ static void ice_ptp_wait_for_offset_valid(struct kthread_work *work)
 		return;
 	}
 
-	/* Offsets are valid, so it is safe to exit bypass mode */
-	err = ice_phy_exit_bypass_e822(hw, port->port_num);
+	/* Offsets are valid, so Vernier mode calculations are started */
+	err = ice_phy_calc_vernier_e822(hw, port->port_num);
 	if (err) {
-		dev_warn(dev, "Failed to exit bypass mode for PHY port %u, err %d\n",
+		dev_warn(dev, "Failed to prepare Vernier mode for PHY port %u, err %d\n",
 			 port->port_num, err);
 		return;
 	}
@@ -1320,8 +1320,8 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 	ptp_port->tx.calibrating = true;
 	ptp_port->tx_fifo_busy_cnt = 0;
 
-	/* Start the PHY timer in bypass mode */
-	err = ice_start_phy_timer_e822(hw, port, true);
+	/* Start the PHY timer in Vernier mode */
+	err = ice_start_phy_timer_e822(hw, port);
 	if (err)
 		goto out_unlock;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 1f8dd50db524..242c4db65171 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -1786,47 +1786,6 @@ static int ice_phy_cfg_tx_offset_e822(struct ice_hw *hw, u8 port)
 	return 0;
 }
 
-/**
- * ice_phy_cfg_fixed_tx_offset_e822 - Configure Tx offset for bypass mode
- * @hw: pointer to the HW struct
- * @port: the PHY port to configure
- *
- * Calculate and program the fixed Tx offset, and indicate that the offset is
- * ready. This can be used when operating in bypass mode.
- */
-static int
-ice_phy_cfg_fixed_tx_offset_e822(struct ice_hw *hw, u8 port)
-{
-	enum ice_ptp_link_spd link_spd;
-	enum ice_ptp_fec_mode fec_mode;
-	u64 total_offset;
-	int err;
-
-	err = ice_phy_get_speed_and_fec_e822(hw, port, &link_spd, &fec_mode);
-	if (err)
-		return err;
-
-	total_offset = ice_calc_fixed_tx_offset_e822(hw, link_spd);
-
-	/* Program the fixed Tx offset into the P_REG_TOTAL_TX_OFFSET_L
-	 * register, then indicate that the Tx offset is ready. After this,
-	 * timestamps will be enabled.
-	 *
-	 * Note that this skips including the more precise offsets generated
-	 * by the Vernier calibration.
-	 */
-	err = ice_write_64b_phy_reg_e822(hw, port, P_REG_TOTAL_TX_OFFSET_L,
-					 total_offset);
-	if (err)
-		return err;
-
-	err = ice_write_phy_reg_e822(hw, port, P_REG_TX_OR, 1);
-	if (err)
-		return err;
-
-	return 0;
-}
-
 /**
  * ice_phy_calc_pmd_adj_e822 - Calculate PMD adjustment for Rx
  * @hw: pointer to the HW struct
@@ -2104,47 +2063,6 @@ static int ice_phy_cfg_rx_offset_e822(struct ice_hw *hw, u8 port)
 	return 0;
 }
 
-/**
- * ice_phy_cfg_fixed_rx_offset_e822 - Configure fixed Rx offset for bypass mode
- * @hw: pointer to the HW struct
- * @port: the PHY port to configure
- *
- * Calculate and program the fixed Rx offset, and indicate that the offset is
- * ready. This can be used when operating in bypass mode.
- */
-static int
-ice_phy_cfg_fixed_rx_offset_e822(struct ice_hw *hw, u8 port)
-{
-	enum ice_ptp_link_spd link_spd;
-	enum ice_ptp_fec_mode fec_mode;
-	u64 total_offset;
-	int err;
-
-	err = ice_phy_get_speed_and_fec_e822(hw, port, &link_spd, &fec_mode);
-	if (err)
-		return err;
-
-	total_offset = ice_calc_fixed_rx_offset_e822(hw, link_spd);
-
-	/* Program the fixed Rx offset into the P_REG_TOTAL_RX_OFFSET_L
-	 * register, then indicate that the Rx offset is ready. After this,
-	 * timestamps will be enabled.
-	 *
-	 * Note that this skips including the more precise offsets generated
-	 * by Vernier calibration.
-	 */
-	err = ice_write_64b_phy_reg_e822(hw, port, P_REG_TOTAL_RX_OFFSET_L,
-					 total_offset);
-	if (err)
-		return err;
-
-	err = ice_write_phy_reg_e822(hw, port, P_REG_RX_OR, 1);
-	if (err)
-		return err;
-
-	return 0;
-}
-
 /**
  * ice_read_phy_and_phc_time_e822 - Simultaneously capture PHC and PHY time
  * @hw: pointer to the HW struct
@@ -2323,20 +2241,14 @@ ice_stop_phy_timer_e822(struct ice_hw *hw, u8 port, bool soft_reset)
  * ice_start_phy_timer_e822 - Start the PHY clock timer
  * @hw: pointer to the HW struct
  * @port: the PHY port to start
- * @bypass: if true, start the PHY in bypass mode
  *
  * Start the clock of a PHY port. This must be done as part of the flow to
  * re-calibrate Tx and Rx timestamping offsets whenever the clock time is
  * initialized or when link speed changes.
  *
- * Bypass mode enables timestamps immediately without waiting for Vernier
- * calibration to complete. Hardware will still continue taking Vernier
- * measurements on Tx or Rx of packets, but they will not be applied to
- * timestamps. Use ice_phy_exit_bypass_e822 to exit bypass mode once hardware
- * has completed offset calculation.
+ * Hardware will take Vernier measurements on Tx or Rx of packets.
  */
-int
-ice_start_phy_timer_e822(struct ice_hw *hw, u8 port, bool bypass)
+int ice_start_phy_timer_e822(struct ice_hw *hw, u8 port)
 {
 	u32 lo, hi, val;
 	u64 incval;
@@ -2414,44 +2326,24 @@ ice_start_phy_timer_e822(struct ice_hw *hw, u8 port, bool bypass)
 	if (err)
 		return err;
 
-	if (bypass) {
-		val |= P_REG_PS_BYPASS_MODE_M;
-		/* Enter BYPASS mode, enabling timestamps immediately. */
-		err = ice_write_phy_reg_e822(hw, port, P_REG_PS, val);
-		if (err)
-			return err;
-
-		/* Program the fixed Tx offset */
-		err = ice_phy_cfg_fixed_tx_offset_e822(hw, port);
-		if (err)
-			return err;
-
-		/* Program the fixed Rx offset */
-		err = ice_phy_cfg_fixed_rx_offset_e822(hw, port);
-		if (err)
-			return err;
-	}
-
 	ice_debug(hw, ICE_DBG_PTP, "Enabled clock on PHY port %u\n", port);
 
 	return 0;
 }
 
 /**
- * ice_phy_exit_bypass_e822 - Exit bypass mode, after vernier calculations
+ * ice_phy_calc_vernier_e822 - Perform vernier calculations
  * @hw: pointer to the HW struct
  * @port: the PHY port to configure
  *
- * After hardware finishes vernier calculations for the Tx and Rx offset, this
- * function can be used to exit bypass mode by updating the total Tx and Rx
- * offsets, and then disabling bypass. This will enable hardware to include
- * the more precise offset calibrations, increasing precision of the generated
- * timestamps.
+ * Perform vernier calculations for the Tx and Rx offset. This will enable
+ * hardware to include the more precise offset calibrations,
+ * increasing precision of the generated timestamps.
  *
  * This cannot be done until hardware has measured the offsets, which requires
  * waiting until at least one packet has been sent and received by the device.
  */
-int ice_phy_exit_bypass_e822(struct ice_hw *hw, u8 port)
+int ice_phy_calc_vernier_e822(struct ice_hw *hw, u8 port)
 {
 	int err;
 	u32 val;
@@ -2496,29 +2388,6 @@ int ice_phy_exit_bypass_e822(struct ice_hw *hw, u8 port)
 		return err;
 	}
 
-	/* Exit bypass mode now that the offset has been updated */
-	err = ice_read_phy_reg_e822(hw, port, P_REG_PS, &val);
-	if (err) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to read P_REG_PS for port %u, err %d\n",
-			  port, err);
-		return err;
-	}
-
-	if (!(val & P_REG_PS_BYPASS_MODE_M))
-		ice_debug(hw, ICE_DBG_PTP, "Port %u not in bypass mode\n",
-			  port);
-
-	val &= ~P_REG_PS_BYPASS_MODE_M;
-	err = ice_write_phy_reg_e822(hw, port, P_REG_PS, val);
-	if (err) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to disable bypass for port %u, err %d\n",
-			  port, err);
-		return err;
-	}
-
-	dev_info(ice_hw_to_dev(hw), "Exiting bypass mode on PHY port %u\n",
-		 port);
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 2bda64c76abc..db4f57cb9ec9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -184,8 +184,8 @@ static inline u64 ice_e822_pps_delay(enum ice_time_ref_freq time_ref)
 
 /* E822 Vernier calibration functions */
 int ice_stop_phy_timer_e822(struct ice_hw *hw, u8 port, bool soft_reset);
-int ice_start_phy_timer_e822(struct ice_hw *hw, u8 port, bool bypass);
-int ice_phy_exit_bypass_e822(struct ice_hw *hw, u8 port);
+int ice_start_phy_timer_e822(struct ice_hw *hw, u8 port);
+int ice_phy_calc_vernier_e822(struct ice_hw *hw, u8 port);
 
 /* E810 family functions */
 int ice_ptp_init_phy_e810(struct ice_hw *hw);
-- 
2.35.1

