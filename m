Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6341DF54C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgEWGtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387700AbgEWGtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:49:02 -0400
IronPort-SDR: L0p02vG6O2PLKCOoOum9Y2S9VZAUMyO8bG6xxG2esBDclZpX2lNuQa93NPNWoG9hCCFxdeWRq4
 VdM65RJu96UA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:50 -0700
IronPort-SDR: 5oL25e3arMioAbghomujU5T+I0pT0kiSfUwtbM1CBz+w8SnABXuPI9Pp1jnSV0UAKO/Jj7D8eT
 dgK8tuxFdl7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966899"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/16] ice: Call ice_aq_set_mac_cfg
Date:   Fri, 22 May 2020 23:48:40 -0700
Message-Id: <20200523064847.3972158-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

As per the specification, the driver needs to call set_mac_cfg
(opcode 0x0603) to be able to exercise jumbo frames. Call the
function during initialization and the post reset rebuild flow.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 21 ++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 69 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  2 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  5 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  6 ++
 5 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index deada2e3d7c0..f80fb6570f8f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1068,6 +1068,25 @@ struct ice_aqc_set_phy_cfg_data {
 	u8 rsvd1;
 };
 
+/* Set MAC Config command data structure (direct 0x0603) */
+struct ice_aqc_set_mac_cfg {
+	__le16 max_frame_size;
+	u8 params;
+#define ICE_AQ_SET_MAC_PACE_S		3
+#define ICE_AQ_SET_MAC_PACE_M		(0xF << ICE_AQ_SET_MAC_PACE_S)
+#define ICE_AQ_SET_MAC_PACE_TYPE_M	BIT(7)
+#define ICE_AQ_SET_MAC_PACE_TYPE_RATE	0
+#define ICE_AQ_SET_MAC_PACE_TYPE_FIXED	ICE_AQ_SET_MAC_PACE_TYPE_M
+	u8 tx_tmr_priority;
+	__le16 tx_tmr_value;
+	__le16 fc_refresh_threshold;
+	u8 drop_opts;
+#define ICE_AQ_SET_MAC_AUTO_DROP_MASK		BIT(0)
+#define ICE_AQ_SET_MAC_AUTO_DROP_NONE		0
+#define ICE_AQ_SET_MAC_AUTO_DROP_BLOCKING_PKTS	BIT(0)
+	u8 reserved[7];
+};
+
 /* Restart AN command data structure (direct 0x0605)
  * Also used for response, with only the lport_num field present.
  */
@@ -1774,6 +1793,7 @@ struct ice_aq_desc {
 		struct ice_aqc_download_pkg download_pkg;
 		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
+		struct ice_aqc_set_mac_cfg set_mac_cfg;
 		struct ice_aqc_set_event_mask set_event_mask;
 		struct ice_aqc_get_link_status get_link_status;
 		struct ice_aqc_event_lan_overflow lan_overflow;
@@ -1870,6 +1890,7 @@ enum ice_adminq_opc {
 	/* PHY commands */
 	ice_aqc_opc_get_phy_caps			= 0x0600,
 	ice_aqc_opc_set_phy_cfg				= 0x0601,
+	ice_aqc_opc_set_mac_cfg				= 0x0603,
 	ice_aqc_opc_restart_an				= 0x0605,
 	ice_aqc_opc_get_link_status			= 0x0607,
 	ice_aqc_opc_set_event_mask			= 0x0613,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3a4c14150107..0a0b00fffaf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -315,6 +315,71 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 	return 0;
 }
 
+/**
+ * ice_fill_tx_timer_and_fc_thresh
+ * @hw: pointer to the HW struct
+ * @cmd: pointer to MAC cfg structure
+ *
+ * Add Tx timer and FC refresh threshold info to Set MAC Config AQ command
+ * descriptor
+ */
+static void
+ice_fill_tx_timer_and_fc_thresh(struct ice_hw *hw,
+				struct ice_aqc_set_mac_cfg *cmd)
+{
+	u16 fc_thres_val, tx_timer_val;
+	u32 val;
+
+	/* We read back the transmit timer and FC threshold value of
+	 * LFC. Thus, we will use index =
+	 * PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA_MAX_INDEX.
+	 *
+	 * Also, because we are operating on transmit timer and FC
+	 * threshold of LFC, we don't turn on any bit in tx_tmr_priority
+	 */
+#define IDX_OF_LFC PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA_MAX_INDEX
+
+	/* Retrieve the transmit timer */
+	val = rd32(hw, PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA(IDX_OF_LFC));
+	tx_timer_val = val &
+		PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA_HSEC_CTL_TX_PAUSE_QUANTA_M;
+	cmd->tx_tmr_value = cpu_to_le16(tx_timer_val);
+
+	/* Retrieve the FC threshold */
+	val = rd32(hw, PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER(IDX_OF_LFC));
+	fc_thres_val = val & PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_M;
+
+	cmd->fc_refresh_threshold = cpu_to_le16(fc_thres_val);
+}
+
+/**
+ * ice_aq_set_mac_cfg
+ * @hw: pointer to the HW struct
+ * @max_frame_size: Maximum Frame Size to be supported
+ * @cd: pointer to command details structure or NULL
+ *
+ * Set MAC configuration (0x0603)
+ */
+enum ice_status
+ice_aq_set_mac_cfg(struct ice_hw *hw, u16 max_frame_size, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_set_mac_cfg *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.set_mac_cfg;
+
+	if (max_frame_size == 0)
+		return ICE_ERR_PARAM;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_mac_cfg);
+
+	cmd->max_frame_size = cpu_to_le16(max_frame_size);
+
+	ice_fill_tx_timer_and_fc_thresh(hw, cmd);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+}
+
 /**
  * ice_init_fltr_mgmt_struct - initializes filter management list and locks
  * @hw: pointer to the HW struct
@@ -745,6 +810,10 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	status = ice_aq_manage_mac_read(hw, mac_buf, mac_buf_len, NULL);
 	devm_kfree(ice_hw_to_dev(hw), mac_buf);
 
+	if (status)
+		goto err_unroll_fltr_mgmt_struct;
+	/* enable jumbo frame support at MAC level */
+	status = ice_aq_set_mac_cfg(hw, ICE_AQ_SET_MAC_FRAME_SIZE_MAX, NULL);
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
 	/* Obtain counter base index which would be used by flow director */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 8104f3d64d96..bea755a658eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -108,6 +108,8 @@ enum ice_status
 ice_aq_set_link_restart_an(struct ice_port_info *pi, bool ena_link,
 			   struct ice_sq_cd *cd);
 enum ice_status
+ice_aq_set_mac_cfg(struct ice_hw *hw, u16 max_frame_size, struct ice_sq_cd *cd);
+enum ice_status
 ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 		     struct ice_link_status *link, struct ice_sq_cd *cd);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index c8b037d25053..1f9b427a35fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -219,6 +219,11 @@
 #define VPLAN_TX_QBASE_VFNUMQ_M			ICE_M(0xFF, 16)
 #define VPLAN_TXQ_MAPENA(_VF)			(0x00073800 + ((_VF) * 4))
 #define VPLAN_TXQ_MAPENA_TX_ENA_M		BIT(0)
+#define PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA(_i)	(0x001E36E0 + ((_i) * 32))
+#define PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA_MAX_INDEX 8
+#define PRTMAC_HSEC_CTL_TX_PAUSE_QUANTA_HSEC_CTL_TX_PAUSE_QUANTA_M ICE_M(0xFFFF, 0)
+#define PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER(_i) (0x001E3800 + ((_i) * 32))
+#define PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_M ICE_M(0xFFFF, 0)
 #define GL_MDCK_TX_TDPU				0x00049348
 #define GL_MDCK_TX_TDPU_RCU_ANTISPOOF_ITR_DIS_M BIT(1)
 #define GL_MDET_RX				0x00294C00
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c69567210584..220f1bfc6376 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4901,6 +4901,12 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_init_ctrlq;
 	}
 
+	ret = ice_aq_set_mac_cfg(hw, ICE_AQ_SET_MAC_FRAME_SIZE_MAX, NULL);
+	if (ret) {
+		dev_err(dev, "set_mac_cfg failed %s\n", ice_stat_str(ret));
+		goto err_init_ctrlq;
+	}
+
 	err = ice_sched_init_port(hw->port_info);
 	if (err)
 		goto err_sched_init_port;
-- 
2.26.2

