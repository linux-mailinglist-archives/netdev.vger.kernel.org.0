Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E063A4657
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhFKQTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:16322 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231172AbhFKQTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:38 -0400
IronPort-SDR: KCGqWQ+qc2E8Nu5GUKIxhRawfnfZy02P75tDAGS7NZmE5+HwKw2G+kLsBA5yH0JNmfnt6GD2hz
 bnkeQh58ipDQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404872"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404872"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:26 -0700
IronPort-SDR: 5Oomr9X4YsqT2ESkxtNJABwYu5E1YCvIwqlfslOma48UtbicGBzPszrMXEO4ui7VR6hPEF7Fs8
 oXWIFKKk3ydQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423485"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 4/8] ice: add low level PTP clock access functions
Date:   Fri, 11 Jun 2021 09:19:56 -0700
Message-Id: <20210611162000.2438023-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add the ice_ptp_hw.c file and some associated definitions to the ice
driver folder. This file contains basic low level definitions for
functions that interact with the device hardware.

For now, only E810-based devices are supported. The ice hardware
supports 2 major variants which have different PHYs with different
procedures necessary for interacting with the device clock.

Because the device captures timestamps in the PHY, each PHY has its own
internal timer. The timers are synchronized in hardware by first
preparing the source timer and the PHY timer shadow registers, and then
issuing a synchronization command. This ensures that both the source
timer and PHY timers are programmed simultaneously. The timers
themselves are all driven from the same oscillator source.

The functions in ice_ptp_hw.c abstract over the differences between how
the PHYs in E810 are programmed vs how the PHYs in E822 devices are
programmed. This series only implements E810 support, but E822 support
will be added in a future change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  17 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 653 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  79 +++
 drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
 include/linux/kernel.h                        |  12 +
 5 files changed, 770 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_hw.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_hw.h

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 84d5d43fe029..f6f5ced50be2 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -433,6 +433,23 @@
 #define GLV_UPRCL(_i)				(0x003B2000 + ((_i) * 8))
 #define GLV_UPTCL(_i)				(0x0030A000 + ((_i) * 8))
 #define PRTRPB_RDPC				0x000AC260
+#define GLTSYN_CMD				0x00088810
+#define GLTSYN_CMD_SYNC				0x00088814
+#define GLTSYN_ENA(_i)				(0x00088808 + ((_i) * 4))
+#define GLTSYN_ENA_TSYN_ENA_M			BIT(0)
+#define GLTSYN_INCVAL_H(_i)			(0x00088920 + ((_i) * 4))
+#define GLTSYN_INCVAL_L(_i)			(0x00088918 + ((_i) * 4))
+#define GLTSYN_SHADJ_H(_i)			(0x00088910 + ((_i) * 4))
+#define GLTSYN_SHADJ_L(_i)			(0x00088908 + ((_i) * 4))
+#define GLTSYN_SHTIME_0(_i)			(0x000888E0 + ((_i) * 4))
+#define GLTSYN_SHTIME_H(_i)			(0x000888F0 + ((_i) * 4))
+#define GLTSYN_SHTIME_L(_i)			(0x000888E8 + ((_i) * 4))
+#define GLTSYN_STAT(_i)				(0x000888C0 + ((_i) * 4))
+#define GLTSYN_SYNC_DLAY			0x00088818
+#define GLTSYN_TIME_H(_i)			(0x000888D8 + ((_i) * 4))
+#define GLTSYN_TIME_L(_i)			(0x000888D0 + ((_i) * 4))
+#define PFTSYN_SEM				0x00088880
+#define PFTSYN_SEM_BUSY_M			BIT(0)
 #define VSIQF_FD_CNT(_VSI)			(0x00464000 + ((_VSI) * 4))
 #define VSIQF_FD_CNT_FD_GCNT_S			0
 #define VSIQF_FD_CNT_FD_GCNT_M			ICE_M(0x3FFF, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
new file mode 100644
index 000000000000..267312fad59a
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -0,0 +1,653 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021, Intel Corporation. */
+
+#include "ice_common.h"
+#include "ice_ptp_hw.h"
+
+/* Low level functions for interacting with and managing the device clock used
+ * for the Precision Time Protocol.
+ *
+ * The ice hardware represents the current time using three registers:
+ *
+ *    GLTSYN_TIME_H     GLTSYN_TIME_L     GLTSYN_TIME_R
+ *  +---------------+ +---------------+ +---------------+
+ *  |    32 bits    | |    32 bits    | |    32 bits    |
+ *  +---------------+ +---------------+ +---------------+
+ *
+ * The registers are incremented every clock tick using a 40bit increment
+ * value defined over two registers:
+ *
+ *                     GLTSYN_INCVAL_H   GLTSYN_INCVAL_L
+ *                    +---------------+ +---------------+
+ *                    |    8 bit s    | |    32 bits    |
+ *                    +---------------+ +---------------+
+ *
+ * The increment value is added to the GLSTYN_TIME_R and GLSTYN_TIME_L
+ * registers every clock source tick. Depending on the specific device
+ * configuration, the clock source frequency could be one of a number of
+ * values.
+ *
+ * For E810 devices, the increment frequency is 812.5 MHz
+ *
+ * The hardware captures timestamps in the PHY for incoming packets, and for
+ * outgoing packets on request. To support this, the PHY maintains a timer
+ * that matches the lower 64 bits of the global source timer.
+ *
+ * In order to ensure that the PHY timers and the source timer are equivalent,
+ * shadow registers are used to prepare the desired initial values. A special
+ * sync command is issued to trigger copying from the shadow registers into
+ * the appropriate source and PHY registers simultaneously.
+ */
+
+/**
+ * ice_get_ptp_src_clock_index - determine source clock index
+ * @hw: pointer to HW struct
+ *
+ * Determine the source clock index currently in use, based on device
+ * capabilities reported during initialization.
+ */
+u8 ice_get_ptp_src_clock_index(struct ice_hw *hw)
+{
+	return hw->func_caps.ts_func_info.tmr_index_assoc;
+}
+
+/* E810 functions
+ *
+ * The following functions operate on the E810 series devices which use
+ * a separate external PHY.
+ */
+
+/**
+ * ice_read_phy_reg_e810 - Read register from external PHY on E810
+ * @hw: pointer to the HW struct
+ * @addr: the address to read from
+ * @val: On return, the value read from the PHY
+ *
+ * Read a register from the external PHY on the E810 device.
+ */
+static int ice_read_phy_reg_e810(struct ice_hw *hw, u32 addr, u32 *val)
+{
+	struct ice_sbq_msg_input msg = {0};
+	int status;
+
+	msg.msg_addr_low = lower_16_bits(addr);
+	msg.msg_addr_high = upper_16_bits(addr);
+	msg.opcode = ice_sbq_msg_rd;
+	msg.dest_dev = rmn_0;
+
+	status = ice_sbq_rw_reg(hw, &msg);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to send message to PHY, status %d\n",
+			  status);
+		return status;
+	}
+
+	*val = msg.data;
+
+	return 0;
+}
+
+/**
+ * ice_write_phy_reg_e810 - Write register on external PHY on E810
+ * @hw: pointer to the HW struct
+ * @addr: the address to writem to
+ * @val: the value to write to the PHY
+ *
+ * Write a value to a register of the external PHY on the E810 device.
+ */
+static int ice_write_phy_reg_e810(struct ice_hw *hw, u32 addr, u32 val)
+{
+	struct ice_sbq_msg_input msg = {0};
+	int status;
+
+	msg.msg_addr_low = lower_16_bits(addr);
+	msg.msg_addr_high = upper_16_bits(addr);
+	msg.opcode = ice_sbq_msg_wr;
+	msg.dest_dev = rmn_0;
+	msg.data = val;
+
+	status = ice_sbq_rw_reg(hw, &msg);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to send message to PHY, status %d\n",
+			  status);
+		return status;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_read_phy_tstamp_e810 - Read a PHY timestamp out of the external PHY
+ * @hw: pointer to the HW struct
+ * @lport: the lport to read from
+ * @idx: the timestamp index to read
+ * @tstamp: on return, the 40bit timestamp value
+ *
+ * Read a 40bit timestamp value out of the timestamp block of the external PHY
+ * on the E810 device.
+ */
+static int
+ice_read_phy_tstamp_e810(struct ice_hw *hw, u8 lport, u8 idx, u64 *tstamp)
+{
+	u32 lo_addr, hi_addr, lo, hi;
+	int status;
+
+	lo_addr = TS_EXT(LOW_TX_MEMORY_BANK_START, lport, idx);
+	hi_addr = TS_EXT(HIGH_TX_MEMORY_BANK_START, lport, idx);
+
+	status = ice_read_phy_reg_e810(hw, lo_addr, &lo);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read low PTP timestamp register, status %d\n",
+			  status);
+		return status;
+	}
+
+	status = ice_read_phy_reg_e810(hw, hi_addr, &hi);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read high PTP timestamp register, status %d\n",
+			  status);
+		return status;
+	}
+
+	/* For E810 devices, the timestamp is reported with the lower 32 bits
+	 * in the low register, and the upper 8 bits in the high register.
+	 */
+	*tstamp = ((u64)hi) << TS_HIGH_S | ((u64)lo & TS_LOW_M);
+
+	return 0;
+}
+
+/**
+ * ice_clear_phy_tstamp_e810 - Clear a timestamp from the external PHY
+ * @hw: pointer to the HW struct
+ * @lport: the lport to read from
+ * @idx: the timestamp index to reset
+ *
+ * Clear a timestamp, resetting its valid bit, from the timestamp block of the
+ * external PHY on the E810 device.
+ */
+static int ice_clear_phy_tstamp_e810(struct ice_hw *hw, u8 lport, u8 idx)
+{
+	u32 lo_addr, hi_addr;
+	int status;
+
+	lo_addr = TS_EXT(LOW_TX_MEMORY_BANK_START, lport, idx);
+	hi_addr = TS_EXT(HIGH_TX_MEMORY_BANK_START, lport, idx);
+
+	status = ice_write_phy_reg_e810(hw, lo_addr, 0);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to clear low PTP timestamp register, status %d\n",
+			  status);
+		return status;
+	}
+
+	status = ice_write_phy_reg_e810(hw, hi_addr, 0);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to clear high PTP timestamp register, status %d\n",
+			  status);
+		return status;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_ptp_init_phy_e810 - Enable PTP function on the external PHY
+ * @hw: pointer to HW struct
+ *
+ * Enable the timesync PTP functionality for the external PHY connected to
+ * this function.
+ */
+int ice_ptp_init_phy_e810(struct ice_hw *hw)
+{
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_ENA(tmr_idx),
+					GLTSYN_ENA_TSYN_ENA_M);
+	if (status)
+		ice_debug(hw, ICE_DBG_PTP, "PTP failed in ena_phy_time_syn %d\n",
+			  status);
+
+	return status;
+}
+
+/**
+ * ice_ptp_prep_phy_time_e810 - Prepare PHY port with initial time
+ * @hw: Board private structure
+ * @time: Time to initialize the PHY port clock to
+ *
+ * Program the PHY port ETH_GLTSYN_SHTIME registers in preparation setting the
+ * initial clock time. The time will not actually be programmed until the
+ * driver issues an INIT_TIME command.
+ *
+ * The time value is the upper 32 bits of the PHY timer, usually in units of
+ * nominal nanoseconds.
+ */
+static int ice_ptp_prep_phy_time_e810(struct ice_hw *hw, u32 time)
+{
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHTIME_0(tmr_idx), 0);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write SHTIME_0, status %d\n",
+			  status);
+		return status;
+	}
+
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHTIME_L(tmr_idx), time);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write SHTIME_L, status %d\n",
+			  status);
+		return status;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_ptp_prep_phy_adj_e810 - Prep PHY port for a time adjustment
+ * @hw: pointer to HW struct
+ * @adj: adjustment value to program
+ *
+ * Prepare the PHY port for an atomic adjustment by programming the PHY
+ * ETH_GLTSYN_SHADJ_L and ETH_GLTSYN_SHADJ_H registers. The actual adjustment
+ * is completed by issuing an ADJ_TIME sync command.
+ *
+ * The adjustment value only contains the portion used for the upper 32bits of
+ * the PHY timer, usually in units of nominal nanoseconds. Negative
+ * adjustments are supported using 2s complement arithmetic.
+ */
+static int ice_ptp_prep_phy_adj_e810(struct ice_hw *hw, s32 adj)
+{
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+
+	/* Adjustments are represented as signed 2's complement values in
+	 * nanoseconds. Sub-nanosecond adjustment is not supported.
+	 */
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_L(tmr_idx), 0);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write adj to PHY SHADJ_L, status %d\n",
+			  status);
+		return status;
+	}
+
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_H(tmr_idx), adj);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write adj to PHY SHADJ_H, status %d\n",
+			  status);
+		return status;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_ptp_prep_phy_incval_e810 - Prep PHY port increment value change
+ * @hw: pointer to HW struct
+ * @incval: The new 40bit increment value to prepare
+ *
+ * Prepare the PHY port for a new increment value by programming the PHY
+ * ETH_GLTSYN_SHADJ_L and ETH_GLTSYN_SHADJ_H registers. The actual change is
+ * completed by issuing an INIT_INCVAL command.
+ */
+static int ice_ptp_prep_phy_incval_e810(struct ice_hw *hw, u64 incval)
+{
+	u32 high, low;
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+	low = lower_32_bits(incval);
+	high = upper_32_bits(incval);
+
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_L(tmr_idx), low);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write incval to PHY SHADJ_L, status %d\n",
+			  status);
+		return status;
+	}
+
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_SHADJ_H(tmr_idx), high);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write incval PHY SHADJ_H, status %d\n",
+			  status);
+		return status;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_ptp_port_cmd_e810 - Prepare all external PHYs for a timer command
+ * @hw: pointer to HW struct
+ * @cmd: Command to be sent to the port
+ *
+ * Prepare the external PHYs connected to this device for a timer sync
+ * command.
+ */
+static int ice_ptp_port_cmd_e810(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
+{
+	u32 cmd_val, val;
+	int status;
+
+	switch (cmd) {
+	case INIT_TIME:
+		cmd_val = GLTSYN_CMD_INIT_TIME;
+		break;
+	case INIT_INCVAL:
+		cmd_val = GLTSYN_CMD_INIT_INCVAL;
+		break;
+	case ADJ_TIME:
+		cmd_val = GLTSYN_CMD_ADJ_TIME;
+		break;
+	case READ_TIME:
+		cmd_val = GLTSYN_CMD_READ_TIME;
+		break;
+	case ADJ_TIME_AT_TIME:
+		cmd_val = GLTSYN_CMD_ADJ_INIT_TIME;
+		break;
+	}
+
+	/* Read, modify, write */
+	status = ice_read_phy_reg_e810(hw, ETH_GLTSYN_CMD, &val);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read GLTSYN_CMD, status %d\n", status);
+		return status;
+	}
+
+	/* Modify necessary bits only and perform write */
+	val &= ~TS_CMD_MASK_E810;
+	val |= cmd_val;
+
+	status = ice_write_phy_reg_e810(hw, ETH_GLTSYN_CMD, val);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write back GLTSYN_CMD, status %d\n", status);
+		return status;
+	}
+
+	return 0;
+}
+
+/* Device agnostic functions
+ *
+ * The following functions implement useful behavior to hide the differences
+ * between E810 and other devices. They call the device-specific
+ * implementations where necessary.
+ *
+ * Currently, the driver only supports E810, but future work will enable
+ * support for E822-based devices.
+ */
+
+/**
+ * ice_ptp_lock - Acquire PTP global semaphore register lock
+ * @hw: pointer to the HW struct
+ *
+ * Acquire the global PTP hardware semaphore lock. Returns true if the lock
+ * was acquired, false otherwise.
+ *
+ * The PFTSYN_SEM register sets the busy bit on read, returning the previous
+ * value. If software sees the busy bit cleared, this means that this function
+ * acquired the lock (and the busy bit is now set). If software sees the busy
+ * bit set, it means that another function acquired the lock.
+ *
+ * Software must clear the busy bit with a write to release the lock for other
+ * functions when done.
+ */
+bool ice_ptp_lock(struct ice_hw *hw)
+{
+	u32 hw_lock;
+	int i;
+
+#define MAX_TRIES 5
+
+	for (i = 0; i < MAX_TRIES; i++) {
+		hw_lock = rd32(hw, PFTSYN_SEM + (PFTSYN_SEM_BYTES * hw->pf_id));
+		hw_lock = hw_lock & PFTSYN_SEM_BUSY_M;
+		if (hw_lock) {
+			/* Somebody is holding the lock */
+			usleep_range(10000, 20000);
+			continue;
+		} else {
+			break;
+		}
+	}
+
+	return !hw_lock;
+}
+
+/**
+ * ice_ptp_unlock - Release PTP global semaphore register lock
+ * @hw: pointer to the HW struct
+ *
+ * Release the global PTP hardware semaphore lock. This is done by writing to
+ * the PFTSYN_SEM register.
+ */
+void ice_ptp_unlock(struct ice_hw *hw)
+{
+	wr32(hw, PFTSYN_SEM + (PFTSYN_SEM_BYTES * hw->pf_id), 0);
+}
+
+/**
+ * ice_ptp_src_cmd - Prepare source timer for a timer command
+ * @hw: pointer to HW structure
+ * @cmd: Timer command
+ *
+ * Prepare the source timer for an upcoming timer sync command.
+ */
+static void ice_ptp_src_cmd(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
+{
+	u32 cmd_val;
+	u8 tmr_idx;
+
+	tmr_idx = ice_get_ptp_src_clock_index(hw);
+	cmd_val = tmr_idx << SEL_CPK_SRC;
+
+	switch (cmd) {
+	case INIT_TIME:
+		cmd_val |= GLTSYN_CMD_INIT_TIME;
+		break;
+	case INIT_INCVAL:
+		cmd_val |= GLTSYN_CMD_INIT_INCVAL;
+		break;
+	case ADJ_TIME:
+		cmd_val |= GLTSYN_CMD_ADJ_TIME;
+		break;
+	case ADJ_TIME_AT_TIME:
+		cmd_val |= GLTSYN_CMD_ADJ_INIT_TIME;
+		break;
+	case READ_TIME:
+		cmd_val |= GLTSYN_CMD_READ_TIME;
+		break;
+	}
+
+	wr32(hw, GLTSYN_CMD, cmd_val);
+}
+
+/**
+ * ice_ptp_tmr_cmd - Prepare and trigger a timer sync command
+ * @hw: pointer to HW struct
+ * @cmd: the command to issue
+ *
+ * Prepare the source timer and PHY timers and then trigger the requested
+ * command. This causes the shadow registers previously written in preparation
+ * for the command to be synchronously applied to both the source and PHY
+ * timers.
+ */
+static int ice_ptp_tmr_cmd(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
+{
+	int status;
+
+	/* First, prepare the source timer */
+	ice_ptp_src_cmd(hw, cmd);
+
+	/* Next, prepare the ports */
+	status = ice_ptp_port_cmd_e810(hw, cmd);
+	if (status) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to prepare PHY ports for timer command %u, status %d\n",
+			  cmd, status);
+		return status;
+	}
+
+	/* Write the sync command register to drive both source and PHY timer commands
+	 * synchronously
+	 */
+	wr32(hw, GLTSYN_CMD_SYNC, SYNC_EXEC_CMD);
+
+	return 0;
+}
+
+/**
+ * ice_ptp_init_time - Initialize device time to provided value
+ * @hw: pointer to HW struct
+ * @time: 64bits of time (GLTSYN_TIME_L and GLTSYN_TIME_H)
+ *
+ * Initialize the device to the specified time provided. This requires a three
+ * step process:
+ *
+ * 1) write the new init time to the source timer shadow registers
+ * 2) write the new init time to the PHY timer shadow registers
+ * 3) issue an init_time timer command to synchronously switch both the source
+ *    and port timers to the new init time value at the next clock cycle.
+ */
+int ice_ptp_init_time(struct ice_hw *hw, u64 time)
+{
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+
+	/* Source timers */
+	wr32(hw, GLTSYN_SHTIME_L(tmr_idx), lower_32_bits(time));
+	wr32(hw, GLTSYN_SHTIME_H(tmr_idx), upper_32_bits(time));
+	wr32(hw, GLTSYN_SHTIME_0(tmr_idx), 0);
+
+	/* PHY timers */
+	/* Fill Rx and Tx ports and send msg to PHY */
+	status = ice_ptp_prep_phy_time_e810(hw, time & 0xFFFFFFFF);
+	if (status)
+		return status;
+
+	return ice_ptp_tmr_cmd(hw, INIT_TIME);
+}
+
+/**
+ * ice_ptp_write_incval - Program PHC with new increment value
+ * @hw: pointer to HW struct
+ * @incval: Source timer increment value per clock cycle
+ *
+ * Program the PHC with a new increment value. This requires a three-step
+ * process:
+ *
+ * 1) Write the increment value to the source timer shadow registers
+ * 2) Write the increment value to the PHY timer shadow registers
+ * 3) Issue an INIT_INCVAL timer command to synchronously switch both the
+ *    source and port timers to the new increment value at the next clock
+ *    cycle.
+ */
+int ice_ptp_write_incval(struct ice_hw *hw, u64 incval)
+{
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+
+	/* Shadow Adjust */
+	wr32(hw, GLTSYN_SHADJ_L(tmr_idx), lower_32_bits(incval));
+	wr32(hw, GLTSYN_SHADJ_H(tmr_idx), upper_32_bits(incval));
+
+	status = ice_ptp_prep_phy_incval_e810(hw, incval);
+	if (status)
+		return status;
+
+	return ice_ptp_tmr_cmd(hw, INIT_INCVAL);
+}
+
+/**
+ * ice_ptp_write_incval_locked - Program new incval while holding semaphore
+ * @hw: pointer to HW struct
+ * @incval: Source timer increment value per clock cycle
+ *
+ * Program a new PHC incval while holding the PTP semaphore.
+ */
+int ice_ptp_write_incval_locked(struct ice_hw *hw, u64 incval)
+{
+	int status;
+
+	if (!ice_ptp_lock(hw))
+		return -EBUSY;
+
+	status = ice_ptp_write_incval(hw, incval);
+
+	ice_ptp_unlock(hw);
+
+	return status;
+}
+
+/**
+ * ice_ptp_adj_clock - Adjust PHC clock time atomically
+ * @hw: pointer to HW struct
+ * @adj: Adjustment in nanoseconds
+ *
+ * Perform an atomic adjustment of the PHC time by the specified number of
+ * nanoseconds. This requires a three-step process:
+ *
+ * 1) Write the adjustment to the source timer shadow registers
+ * 2) Write the adjustment to the PHY timer shadow registers
+ * 3) Issue an ADJ_TIME timer command to synchronously apply the adjustment to
+ *    both the source and port timers at the next clock cycle.
+ */
+int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj)
+{
+	int status;
+	u8 tmr_idx;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+
+	/* Write the desired clock adjustment into the GLTSYN_SHADJ register.
+	 * For an ADJ_TIME command, this set of registers represents the value
+	 * to add to the clock time. It supports subtraction by interpreting
+	 * the value as a 2's complement integer.
+	 */
+	wr32(hw, GLTSYN_SHADJ_L(tmr_idx), 0);
+	wr32(hw, GLTSYN_SHADJ_H(tmr_idx), adj);
+
+	status = ice_ptp_prep_phy_adj_e810(hw, adj);
+	if (status)
+		return status;
+
+	return ice_ptp_tmr_cmd(hw, ADJ_TIME);
+}
+
+/**
+ * ice_read_phy_tstamp - Read a PHY timestamp from the timestamo block
+ * @hw: pointer to the HW struct
+ * @block: the block to read from
+ * @idx: the timestamp index to read
+ * @tstamp: on return, the 40bit timestamp value
+ *
+ * Read a 40bit timestamp value out of the timestamp block.
+ */
+int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp)
+{
+	return ice_read_phy_tstamp_e810(hw, block, idx, tstamp);
+}
+
+/**
+ * ice_clear_phy_tstamp - Clear a timestamp from the timestamp block
+ * @hw: pointer to the HW struct
+ * @block: the block to read from
+ * @idx: the timestamp index to reset
+ *
+ * Clear a timestamp, resetting its valid bit, from the timestamp block.
+ */
+int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx)
+{
+	return ice_clear_phy_tstamp_e810(hw, block, idx);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
new file mode 100644
index 000000000000..55a414e87018
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021, Intel Corporation. */
+
+#ifndef _ICE_PTP_HW_H_
+#define _ICE_PTP_HW_H_
+
+enum ice_ptp_tmr_cmd {
+	INIT_TIME,
+	INIT_INCVAL,
+	ADJ_TIME,
+	ADJ_TIME_AT_TIME,
+	READ_TIME
+};
+
+/* Increment value to generate nanoseconds in the GLTSYN_TIME_L register for
+ * the E810 devices. Based off of a PLL with an 812.5 MHz frequency.
+ */
+#define ICE_PTP_NOMINAL_INCVAL_E810 0x13b13b13bULL
+
+/* Device agnostic functions */
+u8 ice_get_ptp_src_clock_index(struct ice_hw *hw);
+bool ice_ptp_lock(struct ice_hw *hw);
+void ice_ptp_unlock(struct ice_hw *hw);
+int ice_ptp_init_time(struct ice_hw *hw, u64 time);
+int ice_ptp_write_incval(struct ice_hw *hw, u64 incval);
+int ice_ptp_write_incval_locked(struct ice_hw *hw, u64 incval);
+int ice_ptp_adj_clock(struct ice_hw *hw, s32 adj);
+int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp);
+int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx);
+
+/* E810 family functions */
+int ice_ptp_init_phy_e810(struct ice_hw *hw);
+
+#define PFTSYN_SEM_BYTES	4
+
+/* PHY timer commands */
+#define SEL_CPK_SRC	8
+
+/* Time Sync command Definitions */
+#define GLTSYN_CMD_INIT_TIME		BIT(0)
+#define GLTSYN_CMD_INIT_INCVAL		BIT(1)
+#define GLTSYN_CMD_ADJ_TIME		BIT(2)
+#define GLTSYN_CMD_ADJ_INIT_TIME	(BIT(2) | BIT(3))
+#define GLTSYN_CMD_READ_TIME		BIT(7)
+
+#define TS_CMD_MASK_E810		0xFF
+#define SYNC_EXEC_CMD			0x3
+
+/* E810 timesync enable register */
+#define ETH_GLTSYN_ENA(_i)		(0x03000348 + ((_i) * 4))
+
+/* E810 shadow init time registers */
+#define ETH_GLTSYN_SHTIME_0(i)		(0x03000368 + ((i) * 32))
+#define ETH_GLTSYN_SHTIME_L(i)		(0x0300036C + ((i) * 32))
+
+/* E810 shadow time adjust registers */
+#define ETH_GLTSYN_SHADJ_L(_i)		(0x03000378 + ((_i) * 32))
+#define ETH_GLTSYN_SHADJ_H(_i)		(0x0300037C + ((_i) * 32))
+
+/* E810 timer command register */
+#define ETH_GLTSYN_CMD			0x03000344
+
+/* Source timer incval macros */
+#define INCVAL_HIGH_M			0xFF
+
+/* Timestamp block macros */
+#define TS_LOW_M			0xFFFFFFFF
+#define TS_HIGH_S			32
+
+#define BYTES_PER_IDX_ADDR_L_U		8
+
+/* External PHY timestamp address */
+#define TS_EXT(a, port, idx) ((a) + (0x1000 * (port)) +			\
+				 ((idx) * BYTES_PER_IDX_ADDR_L_U))
+
+#define LOW_TX_MEMORY_BANK_START	0x03090000
+#define HIGH_TX_MEMORY_BANK_START	0x03090004
+
+#endif /* _ICE_PTP_HW_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 0e5d8d52728b..d33d1906103c 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -49,6 +49,7 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
 #define ICE_DBG_RDMA		BIT_ULL(15)
 #define ICE_DBG_PKG		BIT_ULL(16)
 #define ICE_DBG_RES		BIT_ULL(17)
+#define ICE_DBG_PTP		BIT_ULL(19)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
 #define ICE_DBG_AQ_DESC		BIT_ULL(25)
 #define ICE_DBG_AQ_DESC_BUF	BIT_ULL(26)
@@ -842,6 +843,14 @@ struct ice_hw {
 
 	u8 ucast_shared;	/* true if VSIs can share unicast addr */
 
+#define ICE_PHY_PER_NAC		1
+#define ICE_MAX_QUAD		2
+#define ICE_NUM_QUAD_TYPE	2
+#define ICE_PORTS_PER_QUAD	4
+#define ICE_PHY_0_LAST_QUAD	1
+#define ICE_PORTS_PER_PHY	8
+#define ICE_NUM_EXTERNAL_PORTS		ICE_PORTS_PER_PHY
+
 	/* Active package version (currently active) */
 	struct ice_pkg_ver active_pkg_ver;
 	u32 active_track_id;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 15d8bad3d2f2..e73f3bc3dba5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -71,6 +71,18 @@
  */
 #define lower_32_bits(n) ((u32)((n) & 0xffffffff))
 
+/**
+ * upper_16_bits - return bits 16-31 of a number
+ * @n: the number we're accessing
+ */
+#define upper_16_bits(n) ((u16)((n) >> 16))
+
+/**
+ * lower_16_bits - return bits 0-15 of a number
+ * @n: the number we're accessing
+ */
+#define lower_16_bits(n) ((u16)((n) & 0xffff))
+
 struct completion;
 struct pt_regs;
 struct user;
-- 
2.26.2

