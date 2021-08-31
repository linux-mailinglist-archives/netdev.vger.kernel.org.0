Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507153FC725
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhHaMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 08:13:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:40061 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhHaMMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 08:12:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="282172588"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="282172588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 05:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="509920500"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga001.jf.intel.com with ESMTP; 31 Aug 2021 05:08:12 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 2/2] ice: add support for reading SyncE DPLL state
Date:   Tue, 31 Aug 2021 13:52:33 +0200
Message-Id: <20210831115233.239720-3-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210831115233.239720-1-maciej.machnikowski@intel.com>
References: <20210831115233.239720-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement SyncE DPLL monitoring for E810-T devices.
Poll loop will periodically check the state of the DPLL and cache it
in the pf structure. State changes will be logged in the system log.

Cached state can be read using the RTM_GETEECSTATE rtnetlink
message.

Different SyncE EEC sources will be reported depending on the pin
driving the DPLL:
 - pins 0-1: can be driven by PTP clock
 - pins 2-5: are used by SyncE recovered clocks
 - pins 6-7: can be used to connect external frequency sources
 - pin 8: is connected to the optional GNSS receiver

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  5 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 34 ++++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 62 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  4 ++
 drivers/net/ethernet/intel/ice/ice_devids.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 57 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 35 +++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 44 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   | 22 +++++++
 9 files changed, 266 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index eadcb9958346..6fb7e07e8a62 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -508,6 +508,11 @@ struct ice_pf {
 #define ICE_VF_AGG_NODE_ID_START	65
 #define ICE_MAX_VF_AGG_NODES		32
 	struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
+
+	enum if_eec_state synce_dpll_state;
+	u8 synce_dpll_pin;
+	enum if_eec_state ptp_dpll_state;
+	u8 ptp_dpll_pin;
 };
 
 struct ice_netdev_priv {
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 21b4c7cd6f05..b84da5e9d025 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1727,6 +1727,36 @@ struct ice_aqc_add_rdma_qset_data {
 	struct ice_aqc_add_tx_rdma_qset_entry rdma_qsets[];
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
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SHIFT	8
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SEL	\
+	ICE_M(0x1F, ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SHIFT)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE_SHIFT	13
+#define ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE \
+	ICE_M(0x7, ICE_AQC_GET_CGU_DPLL_STATUS_STATE_MODE_SHIFT)
+	__le32 phase_offset_h;
+	__le32 phase_offset_l;
+	u8 eec_mode;
+	u8 rsvd[1];
+	__le16 node_handle;
+};
+
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
  * Note: The 0xFF10 command has no input parameters.
@@ -1954,6 +1984,7 @@ struct ice_aq_desc {
 		struct ice_aqc_fw_logging fw_logging;
 		struct ice_aqc_get_clear_fw_log get_clear_fw_log;
 		struct ice_aqc_download_pkg download_pkg;
+		struct ice_aqc_get_cgu_dpll_status get_cgu_dpll_status;
 		struct ice_aqc_driver_shared_params drv_shared_params;
 		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
@@ -2108,6 +2139,9 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_pkg				= 0x0C42,
 	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
 
+	/* 1588/SyncE commands/events */
+	ice_aqc_opc_get_cgu_dpll_status			= 0x0C66,
+
 	ice_aqc_opc_driver_shared_params		= 0x0C90,
 
 	/* Standalone Commands/Events */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2fb81e359cdf..e7474643a421 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -69,6 +69,31 @@ bool ice_is_e810(struct ice_hw *hw)
 	return hw->mac_type == ICE_MAC_E810;
 }
 
+/**
+ * ice_is_e810t
+ * @hw: pointer to the hardware structure
+ *
+ * returns true if the device is E810T based, false if not.
+ */
+bool ice_is_e810t(struct ice_hw *hw)
+{
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E810C_SFP:
+		if (hw->subsystem_device_id == ICE_SUBDEV_ID_E810T ||
+		    hw->subsystem_device_id == ICE_SUBDEV_ID_E810T2)
+			return true;
+		break;
+	case ICE_DEV_ID_E810C_QSFP:
+		if (hw->subsystem_device_id == ICE_SUBDEV_ID_E810T2)
+			return true;
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /**
  * ice_clear_pf_cfg - Clear PF configuration
  * @hw: pointer to the hardware structure
@@ -4520,6 +4545,42 @@ ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
 	return ice_status_to_errno(status);
 }
 
+/**
+ * ice_aq_get_cgu_dpll_status
+ * @hw: pointer to the HW struct
+ * @dpll_num: DPLL index
+ * @ref_state: Reference clock state
+ * @dpll_state: DPLL state
+ * @phase_offset: Phase offset in ps
+ * @eec_mode: EEC_mode
+ *
+ * Get CGU DPLL status (0x0C66)
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
+
 /**
  * ice_replay_pre_init - replay pre initialization
  * @hw: pointer to the HW struct
@@ -4974,3 +5035,4 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 	}
 	return false;
 }
+
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index fb16070f02e2..ccd76c0cbf2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -100,6 +100,7 @@ enum ice_status
 ice_aq_manage_mac_write(struct ice_hw *hw, const u8 *mac_addr, u8 flags,
 			struct ice_sq_cd *cd);
 bool ice_is_e810(struct ice_hw *hw);
+bool ice_is_e810t(struct ice_hw *hw);
 enum ice_status ice_clear_pf_cfg(struct ice_hw *hw);
 enum ice_status
 ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
@@ -156,6 +157,9 @@ ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u16 tc_bitmap,
 int
 ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 		      u16 *rdma_qset, u16 num_qsets, u32 *qset_teid);
+enum ice_status
+ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
+			   u16 *dpll_state, u64 *phase_offset, u8 *eec_mode);
 int
 ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
 		      u16 *q_id);
diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 9d8194671f6a..e52dbeddb783 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -52,4 +52,7 @@
 /* Intel(R) Ethernet Connection E822-L 1GbE */
 #define ICE_DEV_ID_E822L_SGMII		0x189A
 
+#define ICE_SUBDEV_ID_E810T		0x000E
+#define ICE_SUBDEV_ID_E810T2		0x000F
+
 #endif /* _ICE_DEVIDS_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 60d55d043a94..b39eceed7841 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5973,6 +5973,62 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_get_eec_state - get state of SyncE DPLL
+ * @netdev: network interface device structure
+ * @state: state of SyncE DPLL
+ * @src: source type driving SyncE DPLL
+ * @pin_idx: index of pin driving SyncE DPLL
+ */
+static int
+ice_get_eec_state(struct net_device *netdev, struct if_eec_state_msg *state,
+		  struct netlink_ext_ack *extack)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (!ice_is_e810t(&pf->hw))
+		return -EOPNOTSUPP;
+
+	state->state = pf->synce_dpll_state;
+	state->flags |= EEC_FLAG_STATE_VAL;
+
+	/* Don't report source and pin if we are not locked */
+	if (pf->synce_dpll_state != IF_EEC_STATE_LOCKED)
+		return 0;
+
+
+	state->pin = pf->synce_dpll_pin;
+	state->flags |= EEC_FLAG_PIN_VAL;
+
+	switch (pf->synce_dpll_pin) {
+	case REF0P:
+	case REF0N:
+		state->src = IF_EEC_SRC_PTP;
+		break;
+	case REF1P:
+	case REF1N:
+	case REF2P:
+	case REF2N:
+		state->src = IF_EEC_SRC_SYNCE;
+		break;
+	case REF3P:
+	case REF3N:
+		state->src = IF_EEC_SRC_EXT;
+		break;
+	case REF4P:
+		state->src = IF_EEC_SRC_GNSS;
+		break;
+	default:
+		state->src = IF_EEC_SRC_UNKNOWN;
+		break;
+	}
+	state->flags |= EEC_FLAG_SRC_VAL;
+
+	return 0;
+}
+
 /**
  * ice_down - Shutdown the connection
  * @vsi: The VSI being stopped
@@ -7263,4 +7319,5 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
+	.ndo_get_eec_state = ice_get_eec_state,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9e3ddb9b8b51..24dde2d31e2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1370,6 +1370,36 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
 	}
 }
 
+static void ice_handle_cgu_state(struct ice_pf *pf)
+{
+	enum if_eec_state cgu_state;
+	u8 pin;
+
+	cgu_state = ice_get_dpll_state(&pf->hw, ICE_CGU_DPLL_SYNCE, &pin);
+	if (pf->synce_dpll_state != cgu_state) {
+		pf->synce_dpll_state = cgu_state;
+		pf->synce_dpll_pin = pin;
+
+		dev_warn(ice_pf_to_dev(pf),
+			 "<DPLL%i> state changed to: %d, pin %d",
+			 ICE_CGU_DPLL_SYNCE,
+			 pf->synce_dpll_state,
+			 pin);
+	}
+
+	cgu_state = ice_get_dpll_state(&pf->hw, ICE_CGU_DPLL_PTP, &pin);
+	if (pf->ptp_dpll_state != cgu_state) {
+		pf->ptp_dpll_state = cgu_state;
+		pf->ptp_dpll_pin = pin;
+
+		dev_warn(ice_pf_to_dev(pf),
+			 "<DPLL%i> state changed to: %d, pin %d",
+			 ICE_CGU_DPLL_PTP,
+			 pf->ptp_dpll_state,
+			 pin);
+	}
+}
+
 static void ice_ptp_periodic_work(struct kthread_work *work)
 {
 	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
@@ -1378,6 +1408,10 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return;
 
+	if (ice_is_e810t(&pf->hw) &&
+	    &pf->hw.func_caps.ts_func_info.src_tmr_owned)
+		ice_handle_cgu_state(pf);
+
 	ice_ptp_update_cached_phctime(pf);
 
 	ice_ptp_tx_tstamp_cleanup(&pf->ptp.port.tx);
@@ -1556,3 +1590,4 @@ void ice_ptp_release(struct ice_pf *pf)
 
 	dev_info(ice_pf_to_dev(pf), "Removed PTP clock\n");
 }
+
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 3eca0e4eab0b..df09f176512b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -375,6 +375,50 @@ static int ice_ptp_port_cmd_e810(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
 	return 0;
 }
 
+/**
+ * ice_get_dpll_state - get the state of the DPLL
+ * @hw: pointer to the hw struct
+ * @dpll_idx: Index of internal DPLL unit
+ * @pin: pointer to a buffer for returning currently active pin
+ *
+ * This function will read the state of the DPLL(dpll_idx). If optional
+ * parameter pin is given it'll be used to retrieve currently active pin.
+ *
+ * Return: state of the DPLL
+ */
+enum if_eec_state
+ice_get_dpll_state(struct ice_hw *hw, u8 dpll_idx, u8 *pin)
+{
+	enum ice_status status;
+	u64 phase_offset;
+	u16 dpll_state;
+	u8 ref_state;
+	u8 eec_mode;
+
+	if (dpll_idx >= ICE_CGU_DPLL_MAX)
+		return IF_EEC_STATE_INVALID;
+
+	status = ice_aq_get_cgu_dpll_status(hw, dpll_idx, &ref_state,
+					    &dpll_state, &phase_offset,
+					    &eec_mode);
+	if (status)
+		return IF_EEC_STATE_INVALID;
+
+	if (pin) {
+		/* current ref pin in dpll_state_refsel_status_X register */
+		*pin = (dpll_state &
+			ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SEL) >>
+		       ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SHIFT;
+	}
+
+	if (dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_LOCK)
+		return IF_EEC_STATE_LOCKED;
+	else if (dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO)
+		return IF_EEC_STATE_HOLDOVER;
+
+	return IF_EEC_STATE_FREERUN;
+}
+
 /* Device agnostic functions
  *
  * The following functions implement useful behavior to hide the differences
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 55a414e87018..cc5dc79fc926 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -30,6 +30,8 @@ int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx);
 
 /* E810 family functions */
 int ice_ptp_init_phy_e810(struct ice_hw *hw);
+enum if_eec_state
+ice_get_dpll_state(struct ice_hw *hw, u8 dpll_idx, u8 *pin);
 
 #define PFTSYN_SEM_BYTES	4
 
@@ -76,4 +78,24 @@ int ice_ptp_init_phy_e810(struct ice_hw *hw);
 #define LOW_TX_MEMORY_BANK_START	0x03090000
 #define HIGH_TX_MEMORY_BANK_START	0x03090004
 
+enum ice_e810t_cgu_dpll {
+	ICE_CGU_DPLL_SYNCE,
+	ICE_CGU_DPLL_PTP,
+	ICE_CGU_DPLL_MAX
+};
+
+enum ice_e810t_cgu_pins {
+	REF0P,
+	REF0N,
+	REF1P,
+	REF1N,
+	REF2P,
+	REF2N,
+	REF3P,
+	REF3N,
+	REF4P,
+	REF4N,
+	NUM_E810T_CGU_PINS
+};
+
 #endif /* _ICE_PTP_HW_H_ */
-- 
2.26.3

