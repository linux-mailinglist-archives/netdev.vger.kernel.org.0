Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C07446A50
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 22:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhKEVLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 17:11:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:26186 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233818AbhKEVLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 17:11:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10159"; a="292815887"
X-IronPort-AV: E=Sophos;i="5.87,212,1631602800"; 
   d="scan'208";a="292815887"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 14:08:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,212,1631602800"; 
   d="scan'208";a="450720725"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga006.jf.intel.com with ESMTP; 05 Nov 2021 14:08:41 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: [PATCH v2 net-next 3/6] ice: add support for reading SyncE DPLL state
Date:   Fri,  5 Nov 2021 21:53:28 +0100
Message-Id: <20211105205331.2024623-4-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
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

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  5 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 34 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 36 ++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  5 +-
 drivers/net/ethernet/intel/ice/ice_devids.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_main.c     | 46 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 34 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 48 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   | 22 +++++++++
 9 files changed, 232 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3dc4caa41565..1dff7ca704d4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -609,6 +609,11 @@ struct ice_pf {
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
index 339c2a86f680..11226af7a9a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1808,6 +1808,36 @@ struct ice_aqc_add_rdma_qset_data {
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
@@ -2039,6 +2069,7 @@ struct ice_aq_desc {
 		struct ice_aqc_fw_logging fw_logging;
 		struct ice_aqc_get_clear_fw_log get_clear_fw_log;
 		struct ice_aqc_download_pkg download_pkg;
+		struct ice_aqc_get_cgu_dpll_status get_cgu_dpll_status;
 		struct ice_aqc_driver_shared_params drv_shared_params;
 		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
@@ -2205,6 +2236,9 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_pkg				= 0x0C42,
 	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
 
+	/* 1588/SyncE commands/events */
+	ice_aqc_opc_get_cgu_dpll_status			= 0x0C66,
+
 	ice_aqc_opc_driver_shared_params		= 0x0C90,
 
 	/* Standalone Commands/Events */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 35903b282885..8069141ac105 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4644,6 +4644,42 @@ ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
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
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index b20a5c085246..aaed388a40a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -106,6 +106,7 @@ enum ice_status
 ice_aq_manage_mac_write(struct ice_hw *hw, const u8 *mac_addr, u8 flags,
 			struct ice_sq_cd *cd);
 bool ice_is_e810(struct ice_hw *hw);
+bool ice_is_e810t(struct ice_hw *hw);
 enum ice_status ice_clear_pf_cfg(struct ice_hw *hw);
 enum ice_status
 ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
@@ -162,6 +163,9 @@ ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u16 tc_bitmap,
 int
 ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 		      u16 *rdma_qset, u16 num_qsets, u32 *qset_teid);
+enum ice_status
+ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
+			   u16 *dpll_state, u64 *phase_offset, u8 *eec_mode);
 int
 ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
 		      u16 *q_id);
@@ -189,7 +193,6 @@ ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
-bool ice_is_e810t(struct ice_hw *hw);
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_txsched_elem_data *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 61dd2f18dee8..0b654d417d29 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -58,4 +58,7 @@
 /* Intel(R) Ethernet Connection E822-L 1GbE */
 #define ICE_DEV_ID_E822L_SGMII		0x189A
 
+#define ICE_SUBDEV_ID_E810T		0x000E
+#define ICE_SUBDEV_ID_E810T2		0x000F
+
 #endif /* _ICE_DEVIDS_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f099797f35e3..7fac27903ab4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6240,6 +6240,50 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_get_eec_state - get state of SyncE DPLL
+ * @netdev: network interface device structure
+ * @state: state of SyncE DPLL
+ * @extack: netlink extended ack
+ */
+static int
+ice_get_eec_state(struct net_device *netdev, enum if_eec_state *state,
+		  struct netlink_ext_ack *extack)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (!ice_is_feature_supported(pf, ICE_F_CGU))
+		return -EOPNOTSUPP;
+
+	*state = pf->synce_dpll_state;
+
+	return 0;
+}
+
+/**
+ * ice_get_eec_src - get reference index of SyncE DPLL
+ * @netdev: network interface device structure
+ * @src: index of source reference of the SyncE DPLL
+ * @extack: netlink extended ack
+ */
+static int
+ice_get_eec_src(struct net_device *netdev, u32 *src,
+		struct netlink_ext_ack *extack)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (!ice_is_feature_supported(pf, ICE_F_CGU))
+		return -EOPNOTSUPP;
+
+	*src = pf->synce_dpll_pin;
+
+	return 0;
+}
+
 /**
  * ice_down - Shutdown the connection
  * @vsi: The VSI being stopped
@@ -8601,4 +8645,6 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
+	.ndo_get_eec_state = ice_get_eec_state,
+	.ndo_get_eec_src = ice_get_eec_src,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index bf7247c6f58e..a38d0ab4d6d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1766,6 +1766,36 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
 	}
 }
 
+static void ice_handle_cgu_state(struct ice_pf *pf)
+{
+	enum if_eec_state cgu_state;
+	u8 pin;
+
+	cgu_state = ice_get_zl_dpll_state(&pf->hw, ICE_CGU_DPLL_SYNCE, &pin);
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
+	cgu_state = ice_get_zl_dpll_state(&pf->hw, ICE_CGU_DPLL_PTP, &pin);
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
@@ -1774,6 +1804,9 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return;
 
+	if (ice_is_feature_supported(pf, ICE_F_CGU))
+		ice_handle_cgu_state(pf);
+
 	ice_ptp_update_cached_phctime(pf);
 
 	ice_ptp_tx_tstamp_cleanup(&pf->ptp.port.tx);
@@ -1958,3 +1991,4 @@ void ice_ptp_release(struct ice_pf *pf)
 
 	dev_info(ice_pf_to_dev(pf), "Removed PTP clock\n");
 }
+
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index aa257db36765..7a9482918a20 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -375,6 +375,54 @@ static int ice_ptp_port_cmd_e810(struct ice_hw *hw, enum ice_ptp_tmr_cmd cmd)
 	return 0;
 }
 
+/**
+ * ice_get_zl_dpll_state - get the state of the DPLL
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
+ice_get_zl_dpll_state(struct ice_hw *hw, u8 dpll_idx, u8 *pin)
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
+	if (dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_LOCK) {
+		if (dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO_READY)
+			return IF_EEC_STATE_LOCKED_HO_ACQ;
+		else
+			return IF_EEC_STATE_LOCKED;
+	} else if ((dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO) &&
+		  (dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO_READY)) {
+		return IF_EEC_STATE_HOLDOVER;
+	}
+	return IF_EEC_STATE_FREERUN;
+}
+
 /* Device agnostic functions
  *
  * The following functions implement useful behavior to hide the differences
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index b2984b5c22c1..fcd543531b2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -33,6 +33,8 @@ int ice_ptp_init_phy_e810(struct ice_hw *hw);
 int ice_read_sma_ctrl_e810t(struct ice_hw *hw, u8 *data);
 int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data);
 bool ice_is_pca9575_present(struct ice_hw *hw);
+enum if_eec_state
+ice_get_zl_dpll_state(struct ice_hw *hw, u8 dpll_idx, u8 *pin);
 
 #define PFTSYN_SEM_BYTES	4
 
@@ -98,4 +100,24 @@ bool ice_is_pca9575_present(struct ice_hw *hw);
 #define ICE_SMA_MAX_BIT_E810T	7
 #define ICE_PCA9575_P1_OFFSET	8
 
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

