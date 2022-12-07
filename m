Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48DF64630D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiLGVKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiLGVJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E4A73F75
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447387; x=1701983387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S244xeew6nv2MJ8aVH0zKmhBMS1pMuKy+SKQLdZKVxw=;
  b=SIueGzXbpcr0VABLjgd+NnO5yWUcxwN2bW6nNEmgrRZrUQXi2PpACfUC
   TzTdMNZ3TCqm8Y8S+xbwnsQGIwNvgXjKYRaIo+41Tay1d5rgnlHxroV2W
   Q5tdW4gPxFFKVwN2Q5IoEUT4yHg2BDv/kpUZdNlYVc4r4SH5c7dS1dUQD
   AnSSClJC5KxGgUchrOwWV3ADc4ENPiT+fpsTDxeo2KA0Lhp/9BbSiteKO
   trO/j1ue5nvDom2cAbH045W6z5x942bFAKPTiPmjvrr4gEDPBAZcHCEaH
   RFgg8upNtveylNm8GjdcUo418OcKPetADubi9QoytxTFE+Wd3dm0FS/Br
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697121"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697121"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508870"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508870"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Siddaraju DH <siddaraju.dh@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 14/15] ice: make Tx and Rx vernier offset calibration independent
Date:   Wed,  7 Dec 2022 13:09:36 -0800
Message-Id: <20221207210937.1099650-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Siddaraju DH <siddaraju.dh@intel.com>

The Tx and Rx calibration and timestamp generation blocks are independent.
However, the ice driver waits until both blocks are ready before
configuring either block.

This can result in delay of configuring one block because we have not yet
received a packet in the other block.

There is no reason to wait to finish programming Tx just because we haven't
received a packet. Similarly there is no reason to wait to program Rx just
because we haven't transmitted a packet.

Instead of checking both offset status before programming either block,
refactor the ice_phy_cfg_tx_offset_e822 and ice_phy_cfg_rx_offset_e822
functions so that they perform their own offset status checks.
Additionally, make them also check the offset ready bit to determine if
the offset values have already been programmed.

Call the individual configure functions directly in
ice_ptp_wait_for_offset_valid. The functions will now correctly check
status, and program the offsets if ready. Once the offset is programmed,
the functions will exit quickly after just checking the offset ready
register.

Remove the ice_phy_calc_vernier_e822 in ice_ptp_hw.c, as well as the offset
valid check functions in ice_ptp.c entirely as they are no longer
necessary.

With this change, the Tx and Rx blocks will each be enabled as soon as
possible without waiting for the other block to complete calibration. This
can enable timestamps faster in setups which have a low rate of transmitted
or received packets. In particular, it can stop a situation where one port
never receives traffic, and thus never finishes calibration of the Tx
block, resulting in continuous faults reported by the ptp4l daemon
application.

Signed-off-by: Siddaraju DH <siddaraju.dh@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 128 ++++---------------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 133 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |   3 +-
 3 files changed, 91 insertions(+), 173 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index e383dd7f0caf..b1cc1f45e419 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1219,132 +1219,46 @@ static int ice_ptp_check_tx_fifo(struct ice_ptp_port *port)
 }
 
 /**
- * ice_ptp_check_tx_offset_valid - Check if the Tx PHY offset is valid
- * @port: the PTP port to check
- *
- * Checks whether the Tx offset for the PHY associated with this port is
- * valid. Returns 0 if the offset is valid, and a non-zero error code if it is
- * not.
- */
-static int ice_ptp_check_tx_offset_valid(struct ice_ptp_port *port)
-{
-	struct ice_pf *pf = ptp_port_to_pf(port);
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_hw *hw = &pf->hw;
-	u32 val;
-	int err;
-
-	err = ice_ptp_check_tx_fifo(port);
-	if (err)
-		return err;
-
-	err = ice_read_phy_reg_e822(hw, port->port_num, P_REG_TX_OV_STATUS,
-				    &val);
-	if (err) {
-		dev_err(dev, "Failed to read TX_OV_STATUS for port %d, err %d\n",
-			port->port_num, err);
-		return -EAGAIN;
-	}
-
-	if (!(val & P_REG_TX_OV_STATUS_OV_M))
-		return -EAGAIN;
-
-	return 0;
-}
-
-/**
- * ice_ptp_check_rx_offset_valid - Check if the Rx PHY offset is valid
- * @port: the PTP port to check
- *
- * Checks whether the Rx offset for the PHY associated with this port is
- * valid. Returns 0 if the offset is valid, and a non-zero error code if it is
- * not.
- */
-static int ice_ptp_check_rx_offset_valid(struct ice_ptp_port *port)
-{
-	struct ice_pf *pf = ptp_port_to_pf(port);
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_hw *hw = &pf->hw;
-	int err;
-	u32 val;
-
-	err = ice_read_phy_reg_e822(hw, port->port_num, P_REG_RX_OV_STATUS,
-				    &val);
-	if (err) {
-		dev_err(dev, "Failed to read RX_OV_STATUS for port %d, err %d\n",
-			port->port_num, err);
-		return err;
-	}
-
-	if (!(val & P_REG_RX_OV_STATUS_OV_M))
-		return -EAGAIN;
-
-	return 0;
-}
-
-/**
- * ice_ptp_check_offset_valid - Check port offset valid bit
- * @port: Port for which offset valid bit is checked
- *
- * Returns 0 if both Tx and Rx offset are valid, and -EAGAIN if one of the
- * offset is not ready.
- */
-static int ice_ptp_check_offset_valid(struct ice_ptp_port *port)
-{
-	int tx_err, rx_err;
-
-	/* always check both Tx and Rx offset validity */
-	tx_err = ice_ptp_check_tx_offset_valid(port);
-	rx_err = ice_ptp_check_rx_offset_valid(port);
-
-	if (tx_err || rx_err)
-		return -EAGAIN;
-
-	return 0;
-}
-
-/**
- * ice_ptp_wait_for_offset_valid - Check for valid Tx and Rx offsets
+ * ice_ptp_wait_for_offsets - Check for valid Tx and Rx offsets
  * @work: Pointer to the kthread_work structure for this task
  *
- * Check whether both the Tx and Rx offsets are valid for enabling the vernier
- * calibration.
+ * Check whether hardware has completed measuring the Tx and Rx offset values
+ * used to configure and enable vernier timestamp calibration.
+ *
+ * Once the offset in either direction is measured, configure the associated
+ * registers with the calibrated offset values and enable timestamping. The Tx
+ * and Rx directions are configured independently as soon as their associated
+ * offsets are known.
  *
- * Once we have valid offsets from hardware, update the total Tx and Rx
- * offsets, and exit bypass mode. This enables more precise timestamps using
- * the extra data measured during the vernier calibration process.
+ * This function reschedules itself until both Tx and Rx calibration have
+ * completed.
  */
-static void ice_ptp_wait_for_offset_valid(struct kthread_work *work)
+static void ice_ptp_wait_for_offsets(struct kthread_work *work)
 {
 	struct ice_ptp_port *port;
-	int err;
-	struct device *dev;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
+	int tx_err;
+	int rx_err;
 
 	port = container_of(work, struct ice_ptp_port, ov_work.work);
 	pf = ptp_port_to_pf(port);
 	hw = &pf->hw;
-	dev = ice_pf_to_dev(pf);
 
 	if (ice_is_reset_in_progress(pf->state))
 		return;
 
-	if (ice_ptp_check_offset_valid(port)) {
-		/* Offsets not ready yet, try again later */
+	tx_err = ice_ptp_check_tx_fifo(port);
+	if (!tx_err)
+		tx_err = ice_phy_cfg_tx_offset_e822(hw, port->port_num);
+	rx_err = ice_phy_cfg_rx_offset_e822(hw, port->port_num);
+	if (tx_err || rx_err) {
+		/* Tx and/or Rx offset not yet configured, try again later */
 		kthread_queue_delayed_work(pf->ptp.kworker,
 					   &port->ov_work,
 					   msecs_to_jiffies(100));
 		return;
 	}
-
-	/* Offsets are valid, so Vernier mode calculations are started */
-	err = ice_phy_calc_vernier_e822(hw, port->port_num);
-	if (err) {
-		dev_warn(dev, "Failed to prepare Vernier mode for PHY port %u, err %d\n",
-			 port->port_num, err);
-		return;
-	}
 }
 
 /**
@@ -2549,7 +2463,7 @@ void ice_ptp_reset(struct ice_pf *pf)
 		err = ice_ptp_init_tx_e810(pf, &ptp->port.tx);
 	} else {
 		kthread_init_delayed_work(&ptp->port.ov_work,
-					  ice_ptp_wait_for_offset_valid);
+					  ice_ptp_wait_for_offsets);
 		err = ice_ptp_init_tx_e822(pf, &ptp->port.tx,
 					   ptp->port.port_num);
 	}
@@ -2712,7 +2626,7 @@ static int ice_ptp_init_port(struct ice_pf *pf, struct ice_ptp_port *ptp_port)
 		return ice_ptp_init_tx_e810(pf, &ptp_port->tx);
 
 	kthread_init_delayed_work(&ptp_port->ov_work,
-				  ice_ptp_wait_for_offset_valid);
+				  ice_ptp_wait_for_offsets);
 	return ice_ptp_init_tx_e822(pf, &ptp_port->tx, ptp_port->port_num);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index d5d51427580a..a38614d21ea8 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -1741,21 +1741,48 @@ ice_calc_fixed_tx_offset_e822(struct ice_hw *hw, enum ice_ptp_link_spd link_spd)
  * adjust Tx timestamps by. This is calculated by combining some known static
  * latency along with the Vernier offset computations done by hardware.
  *
- * This function must be called only after the offset registers are valid,
- * i.e. after the Vernier calibration wait has passed, to ensure that the PHY
- * has measured the offset.
+ * This function will not return successfully until the Tx offset calculations
+ * have been completed, which requires waiting until at least one packet has
+ * been transmitted by the device. It is safe to call this function
+ * periodically until calibration succeeds, as it will only program the offset
+ * once.
  *
  * To avoid overflow, when calculating the offset based on the known static
  * latency values, we use measurements in 1/100th of a nanosecond, and divide
  * the TUs per second up front. This avoids overflow while allowing
  * calculation of the adjustment using integer arithmetic.
+ *
+ * Returns zero on success, -EBUSY if the hardware vernier offset
+ * calibration has not completed, or another error code on failure.
  */
-static int ice_phy_cfg_tx_offset_e822(struct ice_hw *hw, u8 port)
+int ice_phy_cfg_tx_offset_e822(struct ice_hw *hw, u8 port)
 {
 	enum ice_ptp_link_spd link_spd;
 	enum ice_ptp_fec_mode fec_mode;
 	u64 total_offset, val;
 	int err;
+	u32 reg;
+
+	/* Nothing to do if we've already programmed the offset */
+	err = ice_read_phy_reg_e822(hw, port, P_REG_TX_OR, &reg);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read TX_OR for port %u, err %d\n",
+			  port, err);
+		return err;
+	}
+
+	if (reg)
+		return 0;
+
+	err = ice_read_phy_reg_e822(hw, port, P_REG_TX_OV_STATUS, &reg);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read TX_OV_STATUS for port %u, err %d\n",
+			  port, err);
+		return err;
+	}
+
+	if (!(reg & P_REG_TX_OV_STATUS_OV_M))
+		return -EBUSY;
 
 	err = ice_phy_get_speed_and_fec_e822(hw, port, &link_spd, &fec_mode);
 	if (err)
@@ -1809,6 +1836,9 @@ static int ice_phy_cfg_tx_offset_e822(struct ice_hw *hw, u8 port)
 	if (err)
 		return err;
 
+	dev_info(ice_hw_to_dev(hw), "Port=%d Tx vernier offset calibration complete\n",
+		 port);
+
 	return 0;
 }
 
@@ -2011,6 +2041,11 @@ ice_calc_fixed_rx_offset_e822(struct ice_hw *hw, enum ice_ptp_link_spd link_spd)
  * measurements taken in hardware with some data about known fixed delay as
  * well as adjusting for multi-lane alignment delay.
  *
+ * This function will not return successfully until the Rx offset calculations
+ * have been completed, which requires waiting until at least one packet has
+ * been received by the device. It is safe to call this function periodically
+ * until calibration succeeds, as it will only program the offset once.
+ *
  * This function must be called only after the offset registers are valid,
  * i.e. after the Vernier calibration wait has passed, to ensure that the PHY
  * has measured the offset.
@@ -2019,13 +2054,38 @@ ice_calc_fixed_rx_offset_e822(struct ice_hw *hw, enum ice_ptp_link_spd link_spd)
  * latency values, we use measurements in 1/100th of a nanosecond, and divide
  * the TUs per second up front. This avoids overflow while allowing
  * calculation of the adjustment using integer arithmetic.
+ *
+ * Returns zero on success, -EBUSY if the hardware vernier offset
+ * calibration has not completed, or another error code on failure.
  */
-static int ice_phy_cfg_rx_offset_e822(struct ice_hw *hw, u8 port)
+int ice_phy_cfg_rx_offset_e822(struct ice_hw *hw, u8 port)
 {
 	enum ice_ptp_link_spd link_spd;
 	enum ice_ptp_fec_mode fec_mode;
 	u64 total_offset, pmd, val;
 	int err;
+	u32 reg;
+
+	/* Nothing to do if we've already programmed the offset */
+	err = ice_read_phy_reg_e822(hw, port, P_REG_RX_OR, &reg);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read RX_OR for port %u, err %d\n",
+			  port, err);
+		return err;
+	}
+
+	if (reg)
+		return 0;
+
+	err = ice_read_phy_reg_e822(hw, port, P_REG_RX_OV_STATUS, &reg);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read RX_OV_STATUS for port %u, err %d\n",
+			  port, err);
+		return err;
+	}
+
+	if (!(reg & P_REG_RX_OV_STATUS_OV_M))
+		return -EBUSY;
 
 	err = ice_phy_get_speed_and_fec_e822(hw, port, &link_spd, &fec_mode);
 	if (err)
@@ -2086,6 +2146,9 @@ static int ice_phy_cfg_rx_offset_e822(struct ice_hw *hw, u8 port)
 	if (err)
 		return err;
 
+	dev_info(ice_hw_to_dev(hw), "Port=%d Rx vernier offset calibration complete\n",
+		 port);
+
 	return 0;
 }
 
@@ -2357,66 +2420,6 @@ int ice_start_phy_timer_e822(struct ice_hw *hw, u8 port)
 	return 0;
 }
 
-/**
- * ice_phy_calc_vernier_e822 - Perform vernier calculations
- * @hw: pointer to the HW struct
- * @port: the PHY port to configure
- *
- * Perform vernier calculations for the Tx and Rx offset. This will enable
- * hardware to include the more precise offset calibrations,
- * increasing precision of the generated timestamps.
- *
- * This cannot be done until hardware has measured the offsets, which requires
- * waiting until at least one packet has been sent and received by the device.
- */
-int ice_phy_calc_vernier_e822(struct ice_hw *hw, u8 port)
-{
-	int err;
-	u32 val;
-
-	err = ice_read_phy_reg_e822(hw, port, P_REG_TX_OV_STATUS, &val);
-	if (err) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to read TX_OV_STATUS for port %u, err %d\n",
-			  port, err);
-		return err;
-	}
-
-	if (!(val & P_REG_TX_OV_STATUS_OV_M)) {
-		ice_debug(hw, ICE_DBG_PTP, "Tx offset is not yet valid for port %u\n",
-			  port);
-		return -EBUSY;
-	}
-
-	err = ice_read_phy_reg_e822(hw, port, P_REG_RX_OV_STATUS, &val);
-	if (err) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to read RX_OV_STATUS for port %u, err %d\n",
-			  port, err);
-		return err;
-	}
-
-	if (!(val & P_REG_TX_OV_STATUS_OV_M)) {
-		ice_debug(hw, ICE_DBG_PTP, "Rx offset is not yet valid for port %u\n",
-			  port);
-		return -EBUSY;
-	}
-
-	err = ice_phy_cfg_tx_offset_e822(hw, port);
-	if (err) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to program total Tx offset for port %u, err %d\n",
-			  port, err);
-		return err;
-	}
-
-	err = ice_phy_cfg_rx_offset_e822(hw, port);
-	if (err) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to program total Rx offset for port %u, err %d\n",
-			  port, err);
-		return err;
-	}
-
-	return 0;
-}
-
 /**
  * ice_get_phy_tx_tstamp_ready_e822 - Read Tx memory status register
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index b781dadf5a39..3b68cb91bd81 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -188,7 +188,8 @@ static inline u64 ice_e822_pps_delay(enum ice_time_ref_freq time_ref)
 /* E822 Vernier calibration functions */
 int ice_stop_phy_timer_e822(struct ice_hw *hw, u8 port, bool soft_reset);
 int ice_start_phy_timer_e822(struct ice_hw *hw, u8 port);
-int ice_phy_calc_vernier_e822(struct ice_hw *hw, u8 port);
+int ice_phy_cfg_tx_offset_e822(struct ice_hw *hw, u8 port);
+int ice_phy_cfg_rx_offset_e822(struct ice_hw *hw, u8 port);
 
 /* E810 family functions */
 int ice_ptp_init_phy_e810(struct ice_hw *hw);
-- 
2.35.1

