Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665B844C091
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhKJMDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:03:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:54408 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231738AbhKJMDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 07:03:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="293484876"
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="293484876"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 04:00:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="452276662"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2021 04:00:09 -0800
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: [PATCH v3 net-next 5/6] ice: add support for SyncE recovered clocks
Date:   Wed, 10 Nov 2021 12:44:47 +0100
Message-Id: <20211110114448.2792314-6-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement NDO functions for handling SyncE recovered clocks.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 53 +++++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 65 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  6 ++
 drivers/net/ethernet/intel/ice/ice_main.c     | 91 +++++++++++++++++++
 include/linux/netdevice.h                     | 11 +++
 5 files changed, 226 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 11226af7a9a4..dace00a35c44 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1281,6 +1281,31 @@ struct ice_aqc_set_mac_lb {
 	u8 reserved[15];
 };
 
+/* Set PHY recovered clock output (direct 0x0630) */
+struct ice_aqc_set_phy_rec_clk_out {
+	u8 phy_output;
+	u8 port_num;
+	u8 flags;
+#define ICE_AQC_SET_PHY_REC_CLK_OUT_OUT_EN	BIT(0)
+#define ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT	0xFF
+	u8 rsvd;
+	__le32 freq;
+	u8 rsvd2[6];
+	__le16 node_handle;
+};
+
+/* Get PHY recovered clock output (direct 0x0631) */
+struct ice_aqc_get_phy_rec_clk_out {
+	u8 phy_output;
+	u8 port_num;
+	u8 flags;
+#define ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN	BIT(0)
+	u8 rsvd;
+	__le32 freq;
+	u8 rsvd2[6];
+	__le16 node_handle;
+};
+
 struct ice_aqc_link_topo_params {
 	u8 lport_num;
 	u8 lport_num_valid;
@@ -1838,6 +1863,28 @@ struct ice_aqc_get_cgu_dpll_status {
 	__le16 node_handle;
 };
 
+/* Read CGU register (direct 0x0C6E) */
+struct ice_aqc_read_cgu_reg {
+	__le16 offset;
+#define ICE_AQC_READ_CGU_REG_MAX_DATA_LEN	16
+	u8 data_len;
+	u8 rsvd[13];
+};
+
+/* Read CGU register response (direct 0x0C6E) */
+struct ice_aqc_read_cgu_reg_resp {
+	u8 data[ICE_AQC_READ_CGU_REG_MAX_DATA_LEN];
+};
+
+/* Write CGU register (direct 0x0C6F) */
+struct ice_aqc_write_cgu_reg {
+	__le16 offset;
+#define ICE_AQC_WRITE_CGU_REG_MAX_DATA_LEN	7
+	u8 data_len;
+	u8 data[ICE_AQC_WRITE_CGU_REG_MAX_DATA_LEN];
+	u8 rsvd[6];
+};
+
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
  * Note: The 0xFF10 command has no input parameters.
@@ -2033,6 +2080,8 @@ struct ice_aq_desc {
 		struct ice_aqc_get_phy_caps get_phy;
 		struct ice_aqc_set_phy_cfg set_phy;
 		struct ice_aqc_restart_an restart_an;
+		struct ice_aqc_set_phy_rec_clk_out set_phy_rec_clk_out;
+		struct ice_aqc_get_phy_rec_clk_out get_phy_rec_clk_out;
 		struct ice_aqc_gpio read_write_gpio;
 		struct ice_aqc_sff_eeprom read_write_sff_param;
 		struct ice_aqc_set_port_id_led set_port_id_led;
@@ -2188,6 +2237,8 @@ enum ice_adminq_opc {
 	ice_aqc_opc_get_link_status			= 0x0607,
 	ice_aqc_opc_set_event_mask			= 0x0613,
 	ice_aqc_opc_set_mac_lb				= 0x0620,
+	ice_aqc_opc_set_phy_rec_clk_out			= 0x0630,
+	ice_aqc_opc_get_phy_rec_clk_out			= 0x0631,
 	ice_aqc_opc_get_link_topo			= 0x06E0,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
 	ice_aqc_opc_set_gpio				= 0x06EC,
@@ -2238,6 +2289,8 @@ enum ice_adminq_opc {
 
 	/* 1588/SyncE commands/events */
 	ice_aqc_opc_get_cgu_dpll_status			= 0x0C66,
+	ice_aqc_opc_read_cgu_reg			= 0x0C6E,
+	ice_aqc_opc_write_cgu_reg			= 0x0C6F,
 
 	ice_aqc_opc_driver_shared_params		= 0x0C90,
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8069141ac105..29d302ea1e56 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5242,3 +5242,68 @@ bool ice_is_clock_mux_present_e810t(struct ice_hw *hw)
 	return true;
 }
 
+/**
+ * ice_aq_set_phy_rec_clk_out - set RCLK phy out
+ * @hw: pointer to the HW struct
+ * @phy_output: PHY reference clock output pin
+ * @enable: GPIO state to be applied
+ * @freq: PHY output frequency
+ *
+ * Set CGU reference priority (0x0630)
+ * Return 0 on success or negative value on failure.
+ */
+enum ice_status
+ice_aq_set_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, bool enable,
+			   u32 *freq)
+{
+	struct ice_aqc_set_phy_rec_clk_out *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_phy_rec_clk_out);
+	cmd = &desc.params.set_phy_rec_clk_out;
+	cmd->phy_output = phy_output;
+	cmd->port_num = ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT;
+	cmd->flags = enable & ICE_AQC_SET_PHY_REC_CLK_OUT_OUT_EN;
+	cmd->freq = cpu_to_le32(*freq);
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!status)
+		*freq = le32_to_cpu(cmd->freq);
+
+	return status;
+}
+
+/**
+ * ice_aq_get_phy_rec_clk_out
+ * @hw: pointer to the HW struct
+ * @phy_output: PHY reference clock output pin
+ * @port_num: Port number
+ * @flags: PHY flags
+ * @freq: PHY output frequency
+ *
+ * Get PHY recovered clock output (0x0631)
+ */
+enum ice_status
+ice_aq_get_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, u8 *port_num,
+			   u8 *flags, u32 *freq)
+{
+	struct ice_aqc_get_phy_rec_clk_out *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_phy_rec_clk_out);
+	cmd = &desc.params.get_phy_rec_clk_out;
+	cmd->phy_output = phy_output;
+	cmd->port_num = *port_num;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!status) {
+		*port_num = cmd->port_num;
+		*flags = cmd->flags;
+		*freq = le32_to_cpu(cmd->freq);
+	}
+
+	return status;
+}
+
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index aaed388a40a8..8a99c8364173 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -166,6 +166,12 @@ ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 enum ice_status
 ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
 			   u16 *dpll_state, u64 *phase_offset, u8 *eec_mode);
+enum ice_status
+ice_aq_set_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, bool enable,
+			   u32 *freq);
+enum ice_status
+ice_aq_get_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, u8 *port_num,
+			   u8 *flags, u32 *freq);
 int
 ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
 		      u16 *q_id);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7fac27903ab4..98834aa3f3dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6284,6 +6284,94 @@ ice_get_eec_src(struct net_device *netdev, u32 *src,
 	return 0;
 }
 
+/**
+ * ice_get_rclk_range - get range of recovered clock indices
+ * @netdev: network interface device structure
+ * @min_idx: min rclk index
+ * @max_idx: max rclk index
+ * @extack: netlink extended ack
+ */
+static int
+ice_get_rclk_range(struct net_device *netdev, u32 *min_idx, u32 *max_idx,
+		   struct netlink_ext_ack *extack)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (!ice_is_feature_supported(pf, ICE_F_CGU))
+		return -EOPNOTSUPP;
+
+	*min_idx = REF1P;
+	*max_idx = REF1N;
+
+	return 0;
+}
+
+/**
+ * ice_set_rclk_out - set recovered clock redirection to the output pin
+ * @netdev: network interface device structure
+ * @out_idx: output index
+ * @ena: true will enable redirection, false will disable it
+ * @extack: netlink extended ack
+ */
+static int
+ice_set_rclk_out(struct net_device *netdev, u32 out_idx, bool ena,
+		 struct netlink_ext_ack *extack)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	enum ice_status ret;
+	u32 freq;
+
+	if (!ice_is_feature_supported(pf, ICE_F_CGU))
+		return -EOPNOTSUPP;
+
+	if (out_idx < REF1P || out_idx > REF1N)
+		return -EINVAL;
+
+	ret = ice_aq_set_phy_rec_clk_out(&pf->hw, out_idx - REF1P, ena, &freq);
+
+	return ice_status_to_errno(ret);
+}
+
+/**
+ * ice_get_rclk_state - Get state of recovered clock pin for a given netdev
+ * @netdev: network interface device structure
+ * @out_idx: output index
+ * @ena: returns true if the pin is enabled
+ * @extack: netlink extended ack
+ */
+static int
+ice_get_rclk_state(struct net_device *netdev, u32 out_idx, bool *ena,
+		   struct netlink_ext_ack *extack)
+{
+	u8 port_num = ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT;
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	enum ice_status ret;
+	u32 freq;
+	u8 flags;
+
+	if (!ice_is_feature_supported(pf, ICE_F_CGU))
+		return -EOPNOTSUPP;
+
+	if (out_idx < REF1P || out_idx > REF1N)
+		return -EINVAL;
+
+	ret = ice_aq_get_phy_rec_clk_out(&pf->hw, out_idx - REF1P, &port_num,
+					 &flags, &freq);
+
+	if (!ret && (flags & ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN))
+		*ena = true;
+	else
+		*ena = false;
+
+	return ice_status_to_errno(ret);
+}
+
 /**
  * ice_down - Shutdown the connection
  * @vsi: The VSI being stopped
@@ -8647,4 +8735,7 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
 	.ndo_get_eec_state = ice_get_eec_state,
 	.ndo_get_eec_src = ice_get_eec_src,
+	.ndo_get_rclk_range = ice_get_rclk_range,
+	.ndo_set_rclk_out = ice_set_rclk_out,
+	.ndo_get_rclk_state = ice_get_rclk_state,
 };
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 708bd8336155..9faa005506d1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1351,6 +1351,17 @@ struct netdev_net_notifier {
  *			  struct netlink_ext_ack *extack);
  *	Get the index of the source signal that's currently used as EEC's
  *	reference
+ * int (*ndo_get_rclk_range)(struct net_device *dev, u32 *min_idx, u32 *max_idx,
+ *			     struct netlink_ext_ack *extack);
+ *	Get range of valid output indices for the set/get Recovered Clock
+ *	functions
+ * int (*ndo_set_rclk_out)(struct net_device *dev, u32 out_idx, bool ena,
+ *			   struct netlink_ext_ack *extack);
+ *	Set the receive clock recovery redirection to a given Recovered Clock
+ *	output.
+ * int (*ndo_get_rclk_state)(struct net_device *dev, u32 out_idx, bool *ena,
+ *			     struct netlink_ext_ack *extack);
+ *	Get current state of the recovered clock to pin mapping.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
-- 
2.26.3

