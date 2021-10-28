Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3723543E0A2
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhJ1MQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:16:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:9831 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhJ1MQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:16:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="253961489"
X-IronPort-AV: E=Sophos;i="5.87,189,1631602800"; 
   d="scan'208";a="253961489"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 05:13:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,189,1631602800"; 
   d="scan'208";a="466106587"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga002.jf.intel.com with ESMTP; 28 Oct 2021 05:13:47 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: [RFC v6 net-next 5/6] ice: add support for SyncE recovered clocks
Date:   Thu, 28 Oct 2021 13:58:31 +0200
Message-Id: <20211028115832.1385376-6-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20211028115832.1385376-1-maciej.machnikowski@intel.com>
References: <20211028115832.1385376-1-maciej.machnikowski@intel.com>
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
index 0e314d6f5cf7..1beb05c038ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1279,6 +1279,31 @@ struct ice_aqc_set_mac_lb {
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
@@ -1836,6 +1861,28 @@ struct ice_aqc_get_cgu_dpll_status {
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
@@ -2031,6 +2078,8 @@ struct ice_aq_desc {
 		struct ice_aqc_get_phy_caps get_phy;
 		struct ice_aqc_set_phy_cfg set_phy;
 		struct ice_aqc_restart_an restart_an;
+		struct ice_aqc_set_phy_rec_clk_out set_phy_rec_clk_out;
+		struct ice_aqc_get_phy_rec_clk_out get_phy_rec_clk_out;
 		struct ice_aqc_gpio read_write_gpio;
 		struct ice_aqc_sff_eeprom read_write_sff_param;
 		struct ice_aqc_set_port_id_led set_port_id_led;
@@ -2186,6 +2235,8 @@ enum ice_adminq_opc {
 	ice_aqc_opc_get_link_status			= 0x0607,
 	ice_aqc_opc_set_event_mask			= 0x0613,
 	ice_aqc_opc_set_mac_lb				= 0x0620,
+	ice_aqc_opc_set_phy_rec_clk_out			= 0x0630,
+	ice_aqc_opc_get_phy_rec_clk_out			= 0x0631,
 	ice_aqc_opc_get_link_topo			= 0x06E0,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
 	ice_aqc_opc_set_gpio				= 0x06EC,
@@ -2236,6 +2287,8 @@ enum ice_adminq_opc {
 
 	/* 1588/SyncE commands/events */
 	ice_aqc_opc_get_cgu_dpll_status			= 0x0C66,
+	ice_aqc_opc_read_cgu_reg			= 0x0C6E,
+	ice_aqc_opc_write_cgu_reg			= 0x0C6F,
 
 	ice_aqc_opc_driver_shared_params		= 0x0C90,
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8f64dc386922..02aa5c1405fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5193,3 +5193,68 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 	return false;
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
index 29fa400cded3..906a9c8b07de 100644
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
index b4c87afeadc3..52919b9f067a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6172,6 +6172,94 @@ ice_get_eec_src(struct net_device *netdev, u32 *src,
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
+	return ret;
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
+	return ret;
+}
+
 /**
  * ice_down - Shutdown the connection
  * @vsi: The VSI being stopped
@@ -8420,4 +8508,7 @@ static const struct net_device_ops ice_netdev_ops = {
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

