Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511B83EDAB0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhHPQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:18:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:27628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhHPQSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:18:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203046308"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="203046308"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 09:17:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="487524073"
Received: from amlin-018-053.igk.intel.com ([10.102.18.53])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2021 09:17:42 -0700
From:   Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        shuah@kernel.org, arkadiusz.kubalewski@intel.com, arnd@arndb.de,
        nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: [RFC net-next 3/7] ice: add get_dpll_state ptp interface usage
Date:   Mon, 16 Aug 2021 18:07:13 +0200
Message-Id: <20210816160717.31285-4-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new Admin Queue Command definitions for
getting status of Digital Phase Locked Loop.

Implement new part of ptp interface for getting
state of Digital Phase Locked Loop.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 33 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 37 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 40 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  6 +++
 5 files changed, 119 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 6c727745bb29..f0c5a1f4910b 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1916,6 +1916,36 @@ struct ice_aqc_get_pkg_info_resp {
 	struct ice_aqc_get_pkg_info pkg_info[];
 };
 
+/* Get CGU DPLL status (direct 0x0C66) */
+struct ice_aqc_get_cgu_dpll_status {
+	u8 dpll_num;
+	u8 ref_state;
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_LOS		BIT(0)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_SCM		BIT(1)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_CFM		BIT(2)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_GST		BIT(3)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_PFM		BIT(4)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_ESYNC	BIT(6)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_FAST_LOCK_EN	BIT(7)
+	__le16 dpll_state;
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_LOCK		BIT(0)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO		BIT(1)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO_READY	BIT(2)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_FLHIT		BIT(5)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_PSLHIT	BIT(7)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SHIFT 8
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SEL	\
+	MAKEMASK(0x1F, ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SHIFT)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE_SHIFT	13
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE \
+	MAKEMASK(0x7, ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE_SHIFT)
+	__le32 phase_offset_h;
+	__le32 phase_offset_l;
+	u8 eec_mode;
+	u8 rsvd[1];
+	__le16 node_handle;
+};
+
 /* Driver Shared Parameters (direct, 0x0C90) */
 struct ice_aqc_driver_shared_params {
 	u8 set_or_get_op;
@@ -2020,6 +2050,7 @@ struct ice_aq_desc {
 		struct ice_aqc_fw_logging fw_logging;
 		struct ice_aqc_get_clear_fw_log get_clear_fw_log;
 		struct ice_aqc_download_pkg download_pkg;
+		struct ice_aqc_get_cgu_dpll_status get_cgu_dpll_status;
 		struct ice_aqc_driver_shared_params drv_shared_params;
 		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
@@ -2184,6 +2215,8 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_pkg				= 0x0C42,
 	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
 
+	ice_aqc_opc_get_cgu_dpll_status                 = 0x0C66,
+
 	ice_aqc_opc_driver_shared_params		= 0x0C90,
 
 	/* Standalone Commands/Events */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1a3c6b60fdca..1935412941ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5012,3 +5012,40 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 	}
 	return false;
 }
+
+/**
+ * ice_aq_get_cgu_dpll_status - get DPLL status from Firmware
+ * @hw: pointer to the HW struct
+ * @dpll_num: DPLL index
+ * @ref_state: Reference clock state
+ * @dpll_state: DPLL state
+ * @phase_offset: Phase offset in ps
+ * @eec_mode: EEC_mode
+ *
+ * Get CGU DPLL status from Firmware (0x0C66)
+ * Returns 0 on success, negative on failure.
+ */
+enum ice_status
+ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
+			   u16 *dpll_state, u64 *phase_offset, u8 *eec_mode)
+{
+	struct ice_aqc_get_cgu_dpll_status *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_cgu_dpll_status);
+	cmd = &desc.params.get_cgu_dpll_status;
+	cmd->dpll_num = dpll_num;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!status) {
+		*ref_state = cmd->ref_state;
+		*dpll_state = le16_to_cpu(cmd->dpll_state);
+		*phase_offset = le32_to_cpu(cmd->phase_offset_h);
+		*phase_offset <<= 32;
+		*phase_offset += le32_to_cpu(cmd->phase_offset_l);
+		*eec_mode = cmd->eec_mode;
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index fb16070f02e2..eb2e082c43cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -199,4 +199,7 @@ bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw);
 enum ice_status
 ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add);
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
+enum ice_status
+ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
+			   u16 *dpll_state, u64 *phase_offset, u8 *eec_mode);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 031d044ffe7d..d48200a838e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1255,6 +1255,45 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 	return 0;
 }
 
+/**
+ * ice_ptp_get_dpll_state - Get state of the DPLL
+ * @info: the driver's PTP info structure
+ * @ds: structure with states that is going to be filled by driver
+ *
+ * Get the synchronization state of Digital Phase Locked Loop from
+ * hardware.
+ * Returns 0 on success, negative otherwise.
+ */
+static int
+ice_ptp_get_dpll_state(struct ptp_clock_info *info, struct ptp_dpll_state *ds)
+{
+	struct ice_pf *pf = ptp_info_to_pf(info);
+	u8 ref_state, eec_mode, state;
+	struct ice_hw *hw = &pf->hw;
+	u64 phase_offset;
+	u16 dpll_state;
+	int ret, i;
+
+	for (i = 0; i < ICE_CGU_DPLL_MAX; i++) {
+		ret = ice_aq_get_cgu_dpll_status(hw, i, &ref_state,
+						 &dpll_state, &phase_offset,
+						 &eec_mode);
+		if (ret)
+			return ret;
+		state = dpll_state >>
+			ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE_SHIFT;
+		if (state &  ICE_AQC_GET_CGU_DPLL_STATUS_STATE_LOCK)
+			ds->state[i] = DPLL_STATE_LOCKED;
+		else if (state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO)
+			ds->state[i] = DPLL_STATE_HOLDOVER;
+		else
+			ds->state[i] = DPLL_STATE_FREERUN;
+	}
+	ds->dpll_num = ICE_CGU_DPLL_MAX;
+
+	return ret;
+}
+
 /**
  * ice_ptp_adjtime_nonatomic - Do a non-atomic clock adjustment
  * @info: the driver's PTP info structure
@@ -1613,6 +1652,7 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 	info->adjfine = ice_ptp_adjfine;
 	info->gettimex64 = ice_ptp_gettimex64;
 	info->settime64 = ice_ptp_settime64;
+	info->get_dpll_state = ice_ptp_get_dpll_state;
 
 	if (ice_is_e810(&pf->hw))
 		ice_ptp_set_funcs_e810(pf, info);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 5fd3c673480c..c68376f864f7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -112,6 +112,12 @@ struct ice_cgu_pll_params_e822 {
 extern const struct
 ice_cgu_pll_params_e822 e822_cgu_params[NUM_ICE_TIME_REF_FREQ];
 
+enum ice_e810t_cgu_dpll {
+	ICE_CGU_DPLL_SYNCE,
+	ICE_CGU_DPLL_PTP,
+	ICE_CGU_DPLL_MAX
+};
+
 /* Table of constants related to possible TIME_REF sources */
 extern const struct ice_time_ref_info_e822 e822_time_ref[NUM_ICE_TIME_REF_FREQ];
 
-- 
2.24.0

