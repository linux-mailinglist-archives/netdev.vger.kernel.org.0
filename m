Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634CC47C5DC
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240962AbhLUSJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:9414 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240935AbhLUSJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110146; x=1671646146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5hMt6PPXwKi40lgw1H+P/BuN4ScCaJCjA/JBgPgaLVA=;
  b=nIu6JfFE3S8zc9CMt7qz+ez7tfTDMTNLO4xcK40+KUGcsWqzOegPMzN1
   ZjyJR3IBgyCkJZE+jF5BSjggU6rFD//S0UOKqNRd0rEbEbVRDNb1SJldl
   eTGGnKdUWobqcjnHZSDIL2leClnrs++bFMngW/VAmJdCCklczAfede71o
   LU9bSsSsmZqe+UQy4vj8cZ2IqkSnYRpfyXbqCThVJuac1BLIgYKuI/QoY
   Np1Ia6+ZqAfcz4S+Laqfj1VVBG6lZz9I3V62asb/YxE7E101NNw1J559b
   u4fxdwZ18KXwpeUcYJdj+7eRsg/TyywRHpcdM/RWg85tR7G/lqCW+zyeL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264847"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264847"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342491"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 05/10] ice: introduce ice_ptp_init_phc function
Date:   Tue, 21 Dec 2021 09:48:40 -0800
Message-Id: <20211221174845.3063640-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When we enable support for E822 devices, there are some additional
steps required to initialize the PTP hardware clock. To make this easier
to implement as device-specific behavior, refactor the register setups
in ice_ptp_init_owner to a new ice_ptp_init_phc function defined in
ice_ptp_hw.c

This function will have a common section, and an e810 specific
sub-implementation.

This will enable easily extending the functionality to cover the E822
specific setup required to initialize the hardware clock generation
unit. It also makes it clear which steps are E810 specific vs which ones
are necessary for all ice devices.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 53 ++++++++-------------
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 34 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |  1 +
 3 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 686527c48977..bec330842696 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1797,26 +1797,17 @@ void ice_ptp_reset(struct ice_pf *pf)
 	struct timespec64 ts;
 	u64 time_diff;
 	int err = 1;
-	u8 src_idx;
 
 	if (test_bit(ICE_PFR_REQ, pf->state))
 		goto pfr;
 
-	src_idx = hw->func_caps.ts_func_info.tmr_index_owned;
-
-	wr32(hw, GLTSYN_SYNC_DLAY, 0);
-
-	/* Enable source clocks */
-	wr32(hw, GLTSYN_ENA(src_idx), GLTSYN_ENA_TSYN_ENA_M);
+	if (!hw->func_caps.ts_func_info.src_tmr_owned)
+		goto pfr;
 
-	/* Enable PHY time sync */
-	err = ice_ptp_init_phy_e810(hw);
+	err = ice_ptp_init_phc(hw);
 	if (err)
 		goto err;
 
-	/* Clear event status indications for auxiliary pins */
-	(void)rd32(hw, GLTSYN_STAT(src_idx));
-
 	/* Acquire the global hardware lock */
 	if (!ice_ptp_lock(hw)) {
 		err = -EBUSY;
@@ -1914,24 +1905,14 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
 	struct timespec64 ts;
-	u8 src_idx;
 	int err;
 
-	wr32(hw, GLTSYN_SYNC_DLAY, 0);
-
-	/* Clear some HW residue and enable source clock */
-	src_idx = hw->func_caps.ts_func_info.tmr_index_owned;
-
-	/* Enable source clocks */
-	wr32(hw, GLTSYN_ENA(src_idx), GLTSYN_ENA_TSYN_ENA_M);
-
-	/* Enable PHY time sync */
-	err = ice_ptp_init_phy_e810(hw);
-	if (err)
-		goto err_exit;
-
-	/* Clear event status indications for auxiliary pins */
-	(void)rd32(hw, GLTSYN_STAT(src_idx));
+	err = ice_ptp_init_phc(hw);
+	if (err) {
+		dev_err(ice_pf_to_dev(pf), "Failed to initialize PHC, err %d\n",
+			err);
+		return err;
+	}
 
 	/* Acquire the global hardware lock */
 	if (!ice_ptp_lock(hw)) {
@@ -2003,12 +1984,16 @@ static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
 }
 
 /**
- * ice_ptp_init - Initialize the PTP support after device probe or reset
+ * ice_ptp_init - Initialize PTP hardware clock support
  * @pf: Board private structure
  *
- * This function sets device up for PTP support. The first time it is run, it
- * will create a clock device. It does not create a clock device if one
- * already exists. It also reconfigures the device after a reset.
+ * Set up the device for interacting with the PTP hardware clock for all
+ * functions, both the function that owns the clock hardware, and the
+ * functions connected to the clock hardware.
+ *
+ * The clock owner will allocate and register a ptp_clock with the
+ * PTP_1588_CLOCK infrastructure. All functions allocate a kthread and work
+ * items used for asynchronous work such as Tx timestamps and periodic work.
  */
 void ice_ptp_init(struct ice_pf *pf)
 {
@@ -2020,7 +2005,9 @@ void ice_ptp_init(struct ice_pf *pf)
 	if (!ice_is_e810(hw))
 		return;
 
-	/* Check if this PF owns the source timer */
+	/* If this function owns the clock hardware, it must allocate and
+	 * configure the PTP clock device to represent it.
+	 */
 	if (hw->func_caps.ts_func_info.src_tmr_owned) {
 		err = ice_ptp_init_owner(pf);
 		if (err)
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 859805012387..bcc280094f7f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -213,6 +213,21 @@ int ice_ptp_init_phy_e810(struct ice_hw *hw)
 	return err;
 }
 
+/**
+ * ice_ptp_init_phc_e810 - Perform E810 specific PHC initialization
+ * @hw: pointer to HW struct
+ *
+ * Perform E810-specific PTP hardware clock initialization steps.
+ */
+static int ice_ptp_init_phc_e810(struct ice_hw *hw)
+{
+	/* Ensure synchronization delay is zero */
+	wr32(hw, GLTSYN_SYNC_DLAY, 0);
+
+	/* Initialize the PHY */
+	return ice_ptp_init_phy_e810(hw);
+}
+
 /**
  * ice_ptp_prep_phy_time_e810 - Prepare PHY port with initial time
  * @hw: Board private structure
@@ -800,3 +815,22 @@ bool ice_is_pca9575_present(struct ice_hw *hw)
 
 	return !status && handle;
 }
+
+/**
+ * ice_ptp_init_phc - Initialize PTP hardware clock
+ * @hw: pointer to the HW struct
+ *
+ * Perform the steps required to initialize the PTP hardware clock.
+ */
+int ice_ptp_init_phc(struct ice_hw *hw)
+{
+	u8 src_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+
+	/* Enable source clocks */
+	wr32(hw, GLTSYN_ENA(src_idx), GLTSYN_ENA_TSYN_ENA_M);
+
+	/* Clear event err indications for auxiliary pins */
+	(void)rd32(hw, GLTSYN_STAT(src_idx));
+
+	return ice_ptp_init_phc_e810(hw);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index b2984b5c22c1..fea328d3a53b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -27,6 +27,7 @@ int ice_ptp_write_incval_locked(struct ice_hw *hw, u64 incval);
 int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj);
 int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp);
 int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx);
+int ice_ptp_init_phc(struct ice_hw *hw);
 
 /* E810 family functions */
 int ice_ptp_init_phy_e810(struct ice_hw *hw);
-- 
2.31.1

