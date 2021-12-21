Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C678847C5DA
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240945AbhLUSJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:9411 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240929AbhLUSJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110145; x=1671646145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j7mjFHhaE37dTtlWKEXr8YxA7C9QOHSg/3Y5z+yf2+A=;
  b=kc8r0iCMtottOQPeVMEh/Wwtgdz5B+Z7LvCNqfH9RDlv/Nu/VCK8zzR7
   lGgTJC3Q/1mmXse5ekTIfRz0UNKx6yRhR0gh6uAGNlO9DIR7kMo4SAeE5
   yhBAI+nBFO0VUYH7ljrr6DdTneO2yhChpavgRS1wCh+7AtmHG473X8tTN
   nDr01h63px6RXFdKp1yPnEa/7VN+7K1Xc6ETs+b2CFNPFvmtw3uFs8Nxj
   BWT/BagHFezFaL3G/1p4IEd9aP0IsaBX661E0fXmnsFPMXQgbOuTgDAf1
   4AwplVpiNR6bBV67S+c6Hxir0fUR3QOhQtjkEYWFQBu26vVCUG5K47GTb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264842"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264842"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342488"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 04/10] ice: use 'int err' instead of 'int status' in ice_ptp_hw.c
Date:   Tue, 21 Dec 2021 09:48:39 -0800
Message-Id: <20211221174845.3063640-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_ptp_hw.c file introduced a bunch of uses of "int status" instead
of the more traditional "int err" or "int ret". These are actually
traditional Linux error codes (as opposed to the recently removed
ice_status enumeration values).

We're about to add a bunch of new functions to ice_ptp_hw.c. It's
normally preferred in the ice driver to use "int ret" or "int err" when
dealing with error code values.

Instead of making the new functions use "int status" lets just fix all
of ice_ptp_hw.c to use "int err". This will match the new functions and
ensures a consistent style across at least the PTP related files.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 206 ++++++++++----------
 1 file changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 29f947c0cd2e..859805012387 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -68,18 +68,18 @@ u8 ice_get_ptp_src_clock_index(struct ice_hw *hw)
 static int ice_read_phy_reg_e810(struct ice_hw *hw, u32 addr, u32 *val)
 {
 	struct ice_sbq_msg_input msg = {0};
-	int status;
+	int err;
 
 	msg.msg_addr_low = lower_16_bits(addr);
 	msg.msg_addr_high = upper_16_bits(addr);
 	msg.opcode = ice_sbq_msg_rd;
 	msg.dest_dev = rmn_0;
 
-	status = ice_sbq_rw_reg(hw, &msg);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to send message to PHY, status %d\n",
-			  status);
-		return status;
+	err = ice_sbq_rw_reg(hw, &msg);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to send message to PHY, err %d\n",
+			  err);
+		return err;
 	}
 
 	*val = msg.data;
@@ -98,7 +98,7 @@ static int ice_read_phy_reg_e810(struct ice_hw *hw, u32 addr, u32 *val)
 static int ice_write_phy_reg_e810(struct ice_hw *hw, u32 addr, u32 val)
 {
 	struct ice_sbq_msg_input msg = {0};
-	int status;
+	int err;
 
 	msg.msg_addr_low = lower_16_bits(addr);
 	msg.msg_addr_high = upper_16_bits(addr);
@@ -106,11 +106,11 @@ static int ice_write_phy_reg_e810(struct ice_hw *hw, u32 addr, u32 val)
 	msg.dest_dev = rmn_0;
 	msg.data = val;
 
-	status = ice_sbq_rw_reg(hw, &msg);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to send message to PHY, status %d\n",
-			  status);
-		return status;
+	err = ice_sbq_rw_reg(hw, &msg);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to send message to PHY, err %d\n",
+			  err);
+		return err;
 	}
 
 	return 0;
@@ -130,23 +130,23 @@ static int
 ice_read_phy_tstamp_e810(struct ice_hw *hw, u8 lport, u8 idx, u64 *tstamp)
 {
 	u32 lo_addr, hi_addr, lo, hi;
-	int status;
+	int err;
 
 	lo_addr = TS_EXT(LOW_TX_MEMORY_BANK_START, lport, idx);
 	hi_addr = TS_EXT(HIGH_TX_MEMORY_BANK_START, lport, idx);
 
-	status = ice_read_phy_reg_e810(hw, lo_addr, &lo);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to read low PTP timestamp register, status %d\n",
-			  status);
-		return status;
+	err = ice_read_phy_reg_e810(hw, lo_addr, &lo);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read low PTP timestamp register, err %d\n",
+			  err);
+		return err;
 	}
 
-	status = ice_read_phy_reg_e810(hw, hi_addr, &hi);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to read high PTP timestamp register, status %d\n",
-			  status);
-		return status;
+	err = ice_read_phy_reg_e810(hw, hi_addr, &hi);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read high PTP timestamp register, err %d\n",
+			  err);
+		return err;
 	}
 
 	/* For E810 devices, the timestamp is reported with the lower 32 bits
@@ -169,23 +169,23 @@ ice_read_phy_tstamp_e810(struct ice_hw *hw, u8 lport, u8 idx, u64 *tstamp)
 static int ice_clear_phy_tstamp_e810(struct ice_hw *hw, u8 lport, u8 idx)
 {
 	u32 lo_addr, hi_addr;
-	int status;
+	int err;
 
 	lo_addr = TS_EXT(LOW_TX_MEMORY_BANK_START, lport, idx);
 	hi_addr = TS_EXT(HIGH_TX_MEMORY_BANK_START, lport, idx);
 
-	status = ice_write_phy_reg_e810(hw, lo_addr, 0);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to clear low PTP timestamp register, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, lo_addr, 0);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to clear low PTP timestamp register, err %d\n",
+			  err);
+		return err;
 	}
 
-	status = ice_write_phy_reg_e810(hw, hi_addr, 0);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to clear high PTP timestamp register, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, hi_addr, 0);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to clear high PTP timestamp register, err %d\n",
+			  err);
+		return err;
 	}
 
 	return 0;
@@ -200,17 +200,17 @@ static int ice_clear_phy_tstamp_e810(struct ice_hw *hw, u8 lport, u8 idx)
  */
 int ice_ptp_init_phy_e810(struct ice_hw *hw)
 {
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_ENA(tmr_idx),
-					GLTSYN_ENA_TSYN_ENA_M);
-	if (status)
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_ENA(tmr_idx),
+				     GLTSYN_ENA_TSYN_ENA_M);
+	if (err)
 		ice_debug(hw, ICE_DBG_PTP, "PTP failed in ena_phy_time_syn %d\n",
-			  status);
+			  err);
 
-	return status;
+	return err;
 }
 
 /**
@@ -227,22 +227,22 @@ int ice_ptp_init_phy_e810(struct ice_hw *hw)
  */
 static int ice_ptp_prep_phy_time_e810(struct ice_hw *hw, u32 time)
 {
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHTIME_0(tmr_idx), 0);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write SHTIME_0, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHTIME_0(tmr_idx), 0);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write SHTIME_0, err %d\n",
+			  err);
+		return err;
 	}
 
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHTIME_L(tmr_idx), time);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write SHTIME_L, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHTIME_L(tmr_idx), time);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write SHTIME_L, err %d\n",
+			  err);
+		return err;
 	}
 
 	return 0;
@@ -263,26 +263,26 @@ static int ice_ptp_prep_phy_time_e810(struct ice_hw *hw, u32 time)
  */
 static int ice_ptp_prep_phy_adj_e810(struct ice_hw *hw, s32 adj)
 {
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 
 	/* Adjustments are represented as signed 2's complement values in
 	 * nanoseconds. Sub-nanosecond adjustment is not supported.
 	 */
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_L(tmr_idx), 0);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write adj to PHY SHADJ_L, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_L(tmr_idx), 0);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write adj to PHY SHADJ_L, err %d\n",
+			  err);
+		return err;
 	}
 
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_H(tmr_idx), adj);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write adj to PHY SHADJ_H, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_H(tmr_idx), adj);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write adj to PHY SHADJ_H, err %d\n",
+			  err);
+		return err;
 	}
 
 	return 0;
@@ -300,25 +300,25 @@ static int ice_ptp_prep_phy_adj_e810(struct ice_hw *hw, s32 adj)
 static int ice_ptp_prep_phy_incval_e810(struct ice_hw *hw, u64 incval)
 {
 	u32 high, low;
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 	low = lower_32_bits(incval);
 	high = upper_32_bits(incval);
 
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_L(tmr_idx), low);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write incval to PHY SHADJ_L, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_L(tmr_idx), low);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write incval to PHY SHADJ_L, err %d\n",
+			  err);
+		return err;
 	}
 
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_H(tmr_idx), high);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write incval PHY SHADJ_H, status %d\n",
-			  status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_H(tmr_idx), high);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write incval PHY SHADJ_H, err %d\n",
+			  err);
+		return err;
 	}
 
 	return 0;
@@ -335,7 +335,7 @@ static int ice_ptp_prep_phy_incval_e810(struct ice_hw *hw, u64 incval)
 static int ice_ptp_port_cmd_e810(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
 {
 	u32 cmd_val, val;
-	int status;
+	int err;
 
 	switch (cmd) {
 	case INIT_TIME:
@@ -356,20 +356,20 @@ static int ice_ptp_port_cmd_e810(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
 	}
 
 	/* Read, modify, write */
-	status = ice_read_phy_reg_e810(hw, ETH_GLTSYN_CMD, &val);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to read GLTSYN_CMD, status %d\n", status);
-		return status;
+	err = ice_read_phy_reg_e810(hw, ETH_GLTSYN_CMD, &val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read GLTSYN_CMD, err %d\n", err);
+		return err;
 	}
 
 	/* Modify necessary bits only and perform write */
 	val &= ~TS_CMD_MASK_E810;
 	val |= cmd_val;
 
-	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_CMD, val);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to write back GLTSYN_CMD, status %d\n", status);
-		return status;
+	err = ice_write_phy_reg_e810(hw, ETH_GLTSYN_CMD, val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write back GLTSYN_CMD, err %d\n", err);
+		return err;
 	}
 
 	return 0;
@@ -480,17 +480,17 @@ static void ice_ptp_src_cmd(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
  */
 static int ice_ptp_tmr_cmd(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
 {
-	int status;
+	int err;
 
 	/* First, prepare the source timer */
 	ice_ptp_src_cmd(hw, cmd);
 
 	/* Next, prepare the ports */
-	status = ice_ptp_port_cmd_e810(hw, cmd);
-	if (status) {
-		ice_debug(hw, ICE_DBG_PTP, "Failed to prepare PHY ports for timer command %u, status %d\n",
-			  cmd, status);
-		return status;
+	err = ice_ptp_port_cmd_e810(hw, cmd);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to prepare PHY ports for timer command %u, err %d\n",
+			  cmd, err);
+		return err;
 	}
 
 	/* Write the sync command register to drive both source and PHY timer commands
@@ -516,8 +516,8 @@ static int ice_ptp_tmr_cmd(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
  */
 int ice_ptp_init_time(struct ice_hw *hw, u64 time)
 {
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 
@@ -528,9 +528,9 @@ int ice_ptp_init_time(struct ice_hw *hw, u64 time)
 
 	/* PHY timers */
 	/* Fill Rx and Tx ports and send msg to PHY */
-	status = ice_ptp_prep_phy_time_e810(hw, time & 0xFFFFFFFF);
-	if (status)
-		return status;
+	err = ice_ptp_prep_phy_time_e810(hw, time & 0xFFFFFFFF);
+	if (err)
+		return err;
 
 	return ice_ptp_tmr_cmd(hw, INIT_TIME);
 }
@@ -551,8 +551,8 @@ int ice_ptp_init_time(struct ice_hw *hw, u64 time)
  */
 int ice_ptp_write_incval(struct ice_hw *hw, u64 incval)
 {
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 
@@ -560,9 +560,9 @@ int ice_ptp_write_incval(struct ice_hw *hw, u64 incval)
 	wr32(hw, GLTSYN_SHADJ_L(tmr_idx), lower_32_bits(incval));
 	wr32(hw, GLTSYN_SHADJ_H(tmr_idx), upper_32_bits(incval));
 
-	status = ice_ptp_prep_phy_incval_e810(hw, incval);
-	if (status)
-		return status;
+	err = ice_ptp_prep_phy_incval_e810(hw, incval);
+	if (err)
+		return err;
 
 	return ice_ptp_tmr_cmd(hw, INIT_INCVAL);
 }
@@ -576,16 +576,16 @@ int ice_ptp_write_incval(struct ice_hw *hw, u64 incval)
  */
 int ice_ptp_write_incval_locked(struct ice_hw *hw, u64 incval)
 {
-	int status;
+	int err;
 
 	if (!ice_ptp_lock(hw))
 		return -EBUSY;
 
-	status = ice_ptp_write_incval(hw, incval);
+	err = ice_ptp_write_incval(hw, incval);
 
 	ice_ptp_unlock(hw);
 
-	return status;
+	return err;
 }
 
 /**
@@ -603,8 +603,8 @@ int ice_ptp_write_incval_locked(struct ice_hw *hw, u64 incval)
  */
 int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj)
 {
-	int status;
 	u8 tmr_idx;
+	int err;
 
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 
@@ -616,9 +616,9 @@ int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj)
 	wr32(hw, GLTSYN_SHADJ_L(tmr_idx), 0);
 	wr32(hw, GLTSYN_SHADJ_H(tmr_idx), adj);
 
-	status = ice_ptp_prep_phy_adj_e810(hw, adj);
-	if (status)
-		return status;
+	err = ice_ptp_prep_phy_adj_e810(hw, adj);
+	if (err)
+		return err;
 
 	return ice_ptp_tmr_cmd(hw, ADJ_TIME);
 }
-- 
2.31.1

