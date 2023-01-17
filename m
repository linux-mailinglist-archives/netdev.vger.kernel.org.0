Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6866E616
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjAQSdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjAQSa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:30:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA0C3A59E;
        Tue, 17 Jan 2023 10:01:38 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30HG4E3S020812;
        Tue, 17 Jan 2023 10:01:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=aAwf+sckOccAby9dy+1+IXU2CBXM8J3zTlL3SiuGn7Y=;
 b=Pb1TKQoFw/28NSjW3NaiAEC48c/PU0Rkv8L1tvs3ajiYDD2cpD67SjOr62++UP7qib0g
 HJDLBp0kqv1cZvT9G/GpvlQm7LknEZZk/kWEQgzJZptCRdGa2tJOqzGA/QCYJqeMLI9j
 K7vcyemZC5isc741CVCozxEqK/v5L0X7wEpw4SnTN8nmzCSOpuI+D5FrhANZaJTod8FD
 mdLaT0cef8Dwjo66+HL9UlRn69CWUV1svVRhWj6tEvt1mMnyvb25TyUYojUTJn3CmHH3
 9513kSUu6E9aW3zeIddjKv4rsMf8FjfybEgDbCqokRMv3ZG3PF5tQx6YMLWB5pfIzxmB 9Q== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3n5w8ghdat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Jan 2023 10:01:17 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server id
 15.1.2375.34; Tue, 17 Jan 2023 10:01:14 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "Arkadiusz Kubalewski" <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-clk@vger.kernel.org>, Vadim Fedorenko <vadfed@meta.com>
Subject: [RFC PATCH v5 3/4] ice: add admin commands to access cgu configuration
Date:   Tue, 17 Jan 2023 10:00:50 -0800
Message-ID: <20230117180051.2983639-4-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117180051.2983639-1-vadfed@meta.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::8]
X-Proofpoint-GUID: 7_dmLczOZYtnZ10o3biFxzad394tth9x
X-Proofpoint-ORIG-GUID: 7_dmLczOZYtnZ10o3biFxzad394tth9x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_08,2023-01-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Add firmware admin command to access clock generation unit
configuration, it is required to enable Extended PTP and SyncE features
in the driver.
Add definitions of possible hardware variations of input and output pins
related to clock generation unit and functions to access the data.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 240 ++++++++-
 drivers/net/ethernet/intel/ice/ice_common.c   | 467 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  43 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  17 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 408 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   | 240 +++++++++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 8 files changed, 1412 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2f0b604abc5e..3368dba42789 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -199,6 +199,7 @@ enum ice_feature {
 	ICE_F_DSCP,
 	ICE_F_PTP_EXTTS,
 	ICE_F_SMA_CTRL,
+	ICE_F_CGU,
 	ICE_F_GNSS,
 	ICE_F_MAX
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 958c1e435232..542b48a2ca92 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1339,6 +1339,32 @@ struct ice_aqc_set_mac_lb {
 	u8 reserved[15];
 };
 
+/* Set PHY recovered clock output (direct 0x0630) */
+struct ice_aqc_set_phy_rec_clk_out {
+	u8 phy_output;
+	u8 port_num;
+#define ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT	0xFF
+	u8 flags;
+#define ICE_AQC_SET_PHY_REC_CLK_OUT_OUT_EN	BIT(0)
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
+#define ICE_AQC_GET_PHY_REC_CLK_OUT_CURR_PORT	0xFF
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
@@ -1355,6 +1381,8 @@ struct ice_aqc_link_topo_params {
 #define ICE_AQC_LINK_TOPO_NODE_TYPE_CAGE	6
 #define ICE_AQC_LINK_TOPO_NODE_TYPE_MEZZ	7
 #define ICE_AQC_LINK_TOPO_NODE_TYPE_ID_EEPROM	8
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL	9
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_MUX	10
 #define ICE_AQC_LINK_TOPO_NODE_CTX_S		4
 #define ICE_AQC_LINK_TOPO_NODE_CTX_M		\
 				(0xF << ICE_AQC_LINK_TOPO_NODE_CTX_S)
@@ -1391,7 +1419,12 @@ struct ice_aqc_link_topo_addr {
 struct ice_aqc_get_link_topo {
 	struct ice_aqc_link_topo_addr addr;
 	u8 node_part_num;
-#define ICE_AQC_GET_LINK_TOPO_NODE_NR_PCA9575	0x21
+#define ICE_AQC_GET_LINK_TOPO_NODE_NR_PCA9575		0x21
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032	0x24
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_SI5383_5384	0x25
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_E822_PHY		0x30
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_C827		0x31
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_GEN_CLK_MUX	0x47
 	u8 rsvd[9];
 };
 
@@ -2066,6 +2099,186 @@ struct ice_aqc_get_pkg_info_resp {
 	struct ice_aqc_get_pkg_info pkg_info[];
 };
 
+/* Get CGU abilities command response data structure (indirect 0x0C61) */
+struct ice_aqc_get_cgu_abilities {
+	u8 num_inputs;
+	u8 num_outputs;
+	u8 pps_dpll_idx;
+	u8 eec_dpll_idx;
+	__le32 max_in_freq;
+	__le32 max_in_phase_adj;
+	__le32 max_out_freq;
+	__le32 max_out_phase_adj;
+	u8 cgu_part_num;
+	u8 rsvd[3];
+};
+
+/* Set CGU input config (direct 0x0C62) */
+struct ice_aqc_set_cgu_input_config {
+	u8 input_idx;
+	u8 flags1;
+#define ICE_AQC_SET_CGU_IN_CFG_FLG1_UPDATE_FREQ		BIT(6)
+#define ICE_AQC_SET_CGU_IN_CFG_FLG1_UPDATE_DELAY	BIT(7)
+	u8 flags2;
+#define ICE_AQC_SET_CGU_IN_CFG_FLG2_INPUT_EN		BIT(5)
+#define ICE_AQC_SET_CGU_IN_CFG_FLG2_ESYNC_EN		BIT(6)
+	u8 rsvd;
+	__le32 freq;
+	__le32 phase_delay;
+	u8 rsvd2[2];
+	__le16 node_handle;
+};
+
+/* Get CGU input config response descriptor structure (direct 0x0C63) */
+struct ice_aqc_get_cgu_input_config {
+	u8 input_idx;
+	u8 status;
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_LOS		BIT(0)
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_SCM_FAIL		BIT(1)
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_CFM_FAIL		BIT(2)
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_GST_FAIL		BIT(3)
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_PFM_FAIL		BIT(4)
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_ESYNC_FAIL	BIT(6)
+#define ICE_AQC_GET_CGU_IN_CFG_STATUS_ESYNC_CAP		BIT(7)
+	u8 type;
+#define ICE_AQC_GET_CGU_IN_CFG_TYPE_READ_ONLY		BIT(0)
+#define ICE_AQC_GET_CGU_IN_CFG_TYPE_GPS			BIT(4)
+#define ICE_AQC_GET_CGU_IN_CFG_TYPE_EXTERNAL		BIT(5)
+#define ICE_AQC_GET_CGU_IN_CFG_TYPE_PHY			BIT(6)
+	u8 flags1;
+#define ICE_AQC_GET_CGU_IN_CFG_FLG1_PHASE_DELAY_SUPP	BIT(0)
+#define ICE_AQC_GET_CGU_IN_CFG_FLG1_1PPS_SUPP		BIT(2)
+#define ICE_AQC_GET_CGU_IN_CFG_FLG1_10MHZ_SUPP		BIT(3)
+#define ICE_AQC_GET_CGU_IN_CFG_FLG1_ANYFREQ		BIT(7)
+	__le32 freq;
+	__le32 phase_delay;
+	u8 flags2;
+#define ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN		BIT(5)
+#define ICE_AQC_GET_CGU_IN_CFG_FLG2_ESYNC_EN		BIT(6)
+	u8 rsvd[1];
+	__le16 node_handle;
+};
+
+/* Set CGU output config (direct 0x0C64) */
+struct ice_aqc_set_cgu_output_config {
+	u8 output_idx;
+	u8 flags;
+#define ICE_AQC_SET_CGU_OUT_CFG_OUT_EN		BIT(0)
+#define ICE_AQC_SET_CGU_OUT_CFG_ESYNC_EN	BIT(1)
+#define ICE_AQC_SET_CGU_OUT_CFG_UPDATE_FREQ     BIT(2)
+#define ICE_AQC_SET_CGU_OUT_CFG_UPDATE_PHASE    BIT(3)
+#define ICE_AQC_SET_CGU_OUT_CFG_UPDATE_SRC_SEL  BIT(4)
+	u8 src_sel;
+#define ICE_AQC_SET_CGU_OUT_CFG_DPLL_SRC_SEL    ICE_M(0x1F, 0)
+	u8 rsvd;
+	__le32 freq;
+	__le32 phase_delay;
+	u8 rsvd2[2];
+	__le16 node_handle;
+};
+
+/* Get CGU output config (direct 0x0C65) */
+struct ice_aqc_get_cgu_output_config {
+	u8 output_idx;
+	u8 flags;
+#define ICE_AQC_GET_CGU_OUT_CFG_OUT_EN		BIT(0)
+#define ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN	BIT(1)
+#define ICE_AQC_GET_CGU_OUT_CFG_ESYNC_ABILITY	BIT(2)
+	u8 src_sel;
+#define ICE_AQC_GET_CGU_OUT_CFG_DPLL_SRC_SEL_SHIFT	0
+#define ICE_AQC_GET_CGU_OUT_CFG_DPLL_SRC_SEL \
+	ICE_M(0x1F, ICE_AQC_GET_CGU_OUT_CFG_DPLL_SRC_SEL_SHIFT)
+#define ICE_AQC_GET_CGU_OUT_CFG_DPLL_MODE_SHIFT		5
+#define ICE_AQC_GET_CGU_OUT_CFG_DPLL_MODE \
+	ICE_M(0x7, ICE_AQC_GET_CGU_OUT_CFG_DPLL_MODE_SHIFT)
+	u8 rsvd;
+	__le32 freq;
+	__le32 src_freq;
+	u8 rsvd2[2];
+	__le16 node_handle;
+};
+
+/* Get CGU DPLL status (direct 0x0C66) */
+struct ice_aqc_get_cgu_dpll_status {
+	u8 dpll_num;
+	u8 ref_state;
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_LOS		BIT(0)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_SCM		BIT(1)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_CFM		BIT(2)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_GST		BIT(3)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_PFM		BIT(4)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_FAST_LOCK_EN	BIT(5)
+#define ICE_AQC_GET_CGU_DPLL_STATUS_REF_SW_ESYNC	BIT(6)
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
+#define ICE_AQC_GET_CGU_DPLL_STATUS_EEC_MODE_1		0xA
+#define ICE_AQC_GET_CGU_DPLL_STATUS_EEC_MODE_2		0xB
+#define ICE_AQC_GET_CGU_DPLL_STATUS_EEC_MODE_UNKNOWN	0xF
+	u8 rsvd[1];
+	__le16 node_handle;
+};
+
+/* Set CGU DPLL config (direct 0x0C67) */
+struct ice_aqc_set_cgu_dpll_config {
+	u8 dpll_num;
+	u8 ref_state;
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_SW_LOS		BIT(0)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_SW_SCM		BIT(1)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_SW_CFM		BIT(2)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_SW_GST		BIT(3)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_SW_PFM		BIT(4)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_FLOCK_EN	BIT(5)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_REF_SW_ESYNC	BIT(6)
+	u8 rsvd;
+	u8 config;
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_CLK_REF_SEL		ICE_M(0x1F, 0)
+#define ICE_AQC_SET_CGU_DPLL_CONFIG_MODE		ICE_M(0x7, 5)
+	u8 rsvd2[8];
+	u8 eec_mode;
+	u8 rsvd3[1];
+	__le16 node_handle;
+};
+
+/* Set CGU reference priority (direct 0x0C68) */
+struct ice_aqc_set_cgu_ref_prio {
+	u8 dpll_num;
+	u8 ref_idx;
+	u8 ref_priority;
+	u8 rsvd[11];
+	__le16 node_handle;
+};
+
+/* Get CGU reference priority (direct 0x0C69) */
+struct ice_aqc_get_cgu_ref_prio {
+	u8 dpll_num;
+	u8 ref_idx;
+	u8 ref_priority; /* Valid only in response */
+	u8 rsvd[13];
+};
+
+/* Get CGU info (direct 0x0C6A) */
+struct ice_aqc_get_cgu_info {
+	__le32 cgu_id;
+	__le32 cgu_cfg_ver;
+	__le32 cgu_fw_ver;
+	u8 node_part_num;
+	u8 dev_rev;
+	__le16 node_handle;
+};
+
 /* Driver Shared Parameters (direct, 0x0C90) */
 struct ice_aqc_driver_shared_params {
 	u8 set_or_get_op;
@@ -2135,6 +2348,8 @@ struct ice_aq_desc {
 		struct ice_aqc_get_phy_caps get_phy;
 		struct ice_aqc_set_phy_cfg set_phy;
 		struct ice_aqc_restart_an restart_an;
+		struct ice_aqc_set_phy_rec_clk_out set_phy_rec_clk_out;
+		struct ice_aqc_get_phy_rec_clk_out get_phy_rec_clk_out;
 		struct ice_aqc_gpio read_write_gpio;
 		struct ice_aqc_sff_eeprom read_write_sff_param;
 		struct ice_aqc_set_port_id_led set_port_id_led;
@@ -2174,6 +2389,15 @@ struct ice_aq_desc {
 		struct ice_aqc_fw_logging fw_logging;
 		struct ice_aqc_get_clear_fw_log get_clear_fw_log;
 		struct ice_aqc_download_pkg download_pkg;
+		struct ice_aqc_set_cgu_input_config set_cgu_input_config;
+		struct ice_aqc_get_cgu_input_config get_cgu_input_config;
+		struct ice_aqc_set_cgu_output_config set_cgu_output_config;
+		struct ice_aqc_get_cgu_output_config get_cgu_output_config;
+		struct ice_aqc_get_cgu_dpll_status get_cgu_dpll_status;
+		struct ice_aqc_set_cgu_dpll_config set_cgu_dpll_config;
+		struct ice_aqc_set_cgu_ref_prio set_cgu_ref_prio;
+		struct ice_aqc_get_cgu_ref_prio get_cgu_ref_prio;
+		struct ice_aqc_get_cgu_info get_cgu_info;
 		struct ice_aqc_driver_shared_params drv_shared_params;
 		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
@@ -2297,6 +2521,8 @@ enum ice_adminq_opc {
 	ice_aqc_opc_get_link_status			= 0x0607,
 	ice_aqc_opc_set_event_mask			= 0x0613,
 	ice_aqc_opc_set_mac_lb				= 0x0620,
+	ice_aqc_opc_set_phy_rec_clk_out			= 0x0630,
+	ice_aqc_opc_get_phy_rec_clk_out			= 0x0631,
 	ice_aqc_opc_get_link_topo			= 0x06E0,
 	ice_aqc_opc_read_i2c				= 0x06E2,
 	ice_aqc_opc_write_i2c				= 0x06E3,
@@ -2350,6 +2576,18 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_pkg				= 0x0C42,
 	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
 
+	/* 1588/SyncE commands/events */
+	ice_aqc_opc_get_cgu_abilities			= 0x0C61,
+	ice_aqc_opc_set_cgu_input_config		= 0x0C62,
+	ice_aqc_opc_get_cgu_input_config		= 0x0C63,
+	ice_aqc_opc_set_cgu_output_config		= 0x0C64,
+	ice_aqc_opc_get_cgu_output_config		= 0x0C65,
+	ice_aqc_opc_get_cgu_dpll_status			= 0x0C66,
+	ice_aqc_opc_set_cgu_dpll_config			= 0x0C67,
+	ice_aqc_opc_set_cgu_ref_prio			= 0x0C68,
+	ice_aqc_opc_get_cgu_ref_prio			= 0x0C69,
+	ice_aqc_opc_get_cgu_info			= 0x0C6A,
+
 	ice_aqc_opc_driver_shared_params		= 0x0C90,
 
 	/* Standalone Commands/Events */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d02b55b6aa9c..67c8934ee8f9 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -409,6 +409,83 @@ ice_aq_get_link_topo_handle(struct ice_port_info *pi, u8 node_type,
 	return ice_aq_send_cmd(pi->hw, &desc, NULL, 0, cd);
 }
 
+/**
+ * ice_aq_get_netlist_node
+ * @hw: pointer to the hw struct
+ * @cmd: get_link_topo AQ structure
+ * @node_part_number: output node part number if node found
+ * @node_handle: output node handle parameter if node found
+ *
+ * Get netlist node handle.
+ */
+int
+ice_aq_get_netlist_node(struct ice_hw *hw, struct ice_aqc_get_link_topo *cmd,
+			u8 *node_part_number, u16 *node_handle)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_link_topo);
+	desc.params.get_link_topo = *cmd;
+
+	if (ice_aq_send_cmd(hw, &desc, NULL, 0, NULL))
+		return -EINTR;
+
+	if (node_handle)
+		*node_handle =
+			le16_to_cpu(desc.params.get_link_topo.addr.handle);
+	if (node_part_number)
+		*node_part_number = desc.params.get_link_topo.node_part_num;
+
+	return 0;
+}
+
+#define MAX_NETLIST_SIZE	10
+
+/**
+ * ice_find_netlist_node
+ * @hw: pointer to the hw struct
+ * @node_type_ctx: type of netlist node to look for
+ * @node_part_number: node part number to look for
+ * @node_handle: output parameter if node found - optional
+ *
+ * Find and return the node handle for a given node type and part number in the
+ * netlist. When found ICE_SUCCESS is returned, ICE_ERR_DOES_NOT_EXIST
+ * otherwise. If node_handle provided, it would be set to found node handle.
+ */
+int
+ice_find_netlist_node(struct ice_hw *hw, u8 node_type_ctx, u8 node_part_number,
+		      u16 *node_handle)
+{
+	struct ice_aqc_get_link_topo cmd;
+	u8 rec_node_part_number;
+	u16 rec_node_handle;
+	u8 idx;
+
+	for (idx = 0; idx < MAX_NETLIST_SIZE; idx++) {
+		int status;
+
+		memset(&cmd, 0, sizeof(cmd));
+
+		cmd.addr.topo_params.node_type_ctx =
+			(node_type_ctx << ICE_AQC_LINK_TOPO_NODE_TYPE_S);
+		cmd.addr.topo_params.index = idx;
+
+		status = ice_aq_get_netlist_node(hw, &cmd,
+						 &rec_node_part_number,
+						 &rec_node_handle);
+		if (status)
+			return status;
+
+		if (rec_node_part_number == node_part_number) {
+			if (node_handle)
+				*node_handle = rec_node_handle;
+			return 0;
+		}
+	}
+
+	return -ENOTBLK;
+}
+
 /**
  * ice_is_media_cage_present
  * @pi: port information structure
@@ -4904,6 +4981,396 @@ ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
 	return status;
 }
 
+/**
+ * ice_aq_get_cgu_abilities
+ * @hw: pointer to the HW struct
+ * @abilities: CGU abilities
+ *
+ * Get CGU abilities (0x0C61)
+ */
+int
+ice_aq_get_cgu_abilities(struct ice_hw *hw,
+			 struct ice_aqc_get_cgu_abilities *abilities)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_cgu_abilities);
+	return ice_aq_send_cmd(hw, &desc, abilities, sizeof(*abilities), NULL);
+}
+
+/**
+ * ice_aq_set_input_pin_cfg
+ * @hw: pointer to the HW struct
+ * @input_idx: Input index
+ * @flags1: Input flags
+ * @flags2: Input flags
+ * @freq: Frequency in Hz
+ * @phase_delay: Delay in ps
+ *
+ * Set CGU input config (0x0C62)
+ */
+int
+ice_aq_set_input_pin_cfg(struct ice_hw *hw, u8 input_idx, u8 flags1, u8 flags2,
+			 u32 freq, s32 phase_delay)
+{
+	struct ice_aqc_set_cgu_input_config *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_cgu_input_config);
+	cmd = &desc.params.set_cgu_input_config;
+	cmd->input_idx = input_idx;
+	cmd->flags1 = flags1;
+	cmd->flags2 = flags2;
+	cmd->freq = cpu_to_le32(freq);
+	cmd->phase_delay = cpu_to_le32(phase_delay);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
+/**
+ * ice_aq_get_input_pin_cfg
+ * @hw: pointer to the HW struct
+ * @input_idx: Input index
+ * @status: Pin status
+ * @type: Pin type
+ * @flags1: Input flags
+ * @flags2: Input flags
+ * @freq: Frequency in Hz
+ * @phase_delay: Delay in ps
+ *
+ * Get CGU input config (0x0C63)
+ */
+int
+ice_aq_get_input_pin_cfg(struct ice_hw *hw, u8 input_idx, u8 *status, u8 *type,
+			 u8 *flags1, u8 *flags2, u32 *freq, s32 *phase_delay)
+{
+	struct ice_aqc_get_cgu_input_config *cmd;
+	struct ice_aq_desc desc;
+	int ret;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_cgu_input_config);
+	cmd = &desc.params.get_cgu_input_config;
+	cmd->input_idx = input_idx;
+
+	ret = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!ret) {
+		if (status)
+			*status = cmd->status;
+		if (type)
+			*type = cmd->type;
+		if (flags1)
+			*flags1 = cmd->flags1;
+		if (flags2)
+			*flags2 = cmd->flags2;
+		if (freq)
+			*freq = le32_to_cpu(cmd->freq);
+		if (phase_delay)
+			*phase_delay = le32_to_cpu(cmd->phase_delay);
+	}
+
+	return ret;
+}
+
+/**
+ * ice_aq_set_output_pin_cfg
+ * @hw: pointer to the HW struct
+ * @output_idx: Output index
+ * @flags: Output flags
+ * @src_sel: Index of DPLL block
+ * @freq: Output frequency
+ * @phase_delay: Output phase compensation
+ *
+ * Set CGU output config (0x0C64)
+ */
+int
+ice_aq_set_output_pin_cfg(struct ice_hw *hw, u8 output_idx, u8 flags,
+			  u8 src_sel, u32 freq, s32 phase_delay)
+{
+	struct ice_aqc_set_cgu_output_config *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_cgu_output_config);
+	cmd = &desc.params.set_cgu_output_config;
+	cmd->output_idx = output_idx;
+	cmd->flags = flags;
+	cmd->src_sel = src_sel;
+	cmd->freq = cpu_to_le32(freq);
+	cmd->phase_delay = cpu_to_le32(phase_delay);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
+/**
+ * ice_aq_get_output_pin_cfg
+ * @hw: pointer to the HW struct
+ * @output_idx: Output index
+ * @flags: Output flags
+ * @src_sel: Internal DPLL source
+ * @freq: Output frequency
+ * @src_freq: Source frequency
+ *
+ * Get CGU output config (0x0C65)
+ */
+int
+ice_aq_get_output_pin_cfg(struct ice_hw *hw, u8 output_idx, u8 *flags,
+			  u8 *src_sel, u32 *freq, u32 *src_freq)
+{
+	struct ice_aqc_get_cgu_output_config *cmd;
+	struct ice_aq_desc desc;
+	int ret;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_cgu_output_config);
+	cmd = &desc.params.get_cgu_output_config;
+	cmd->output_idx = output_idx;
+
+	ret = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!ret) {
+		if (flags)
+			*flags = cmd->flags;
+		if (src_sel)
+			*src_sel = cmd->src_sel;
+		if (freq)
+			*freq = le32_to_cpu(cmd->freq);
+		if (src_freq)
+			*src_freq = le32_to_cpu(cmd->src_freq);
+	}
+
+	return ret;
+}
+
+/**
+ * convert_s48_to_s64 - convert 48 bit value to 64 bit value
+ * @signed_48: signed 64 bit variable storing signed 48 bit value
+ *
+ * Convert signed 48 bit value to its 64 bit representation.
+ *
+ * Return: signed 64 bit representation of signed 48 bit value.
+ */
+static inline
+s64 convert_s48_to_s64(s64 signed_48)
+{
+	const s64 MASK_SIGN_BITS = GENMASK_ULL(63, 48);
+	const s64 SIGN_BIT_47 = BIT_ULL(47);
+
+	return ((signed_48 & SIGN_BIT_47) ? (s64)(MASK_SIGN_BITS | signed_48)
+		: signed_48);
+}
+
+/**
+ * ice_aq_get_cgu_dpll_status
+ * @hw: pointer to the HW struct
+ * @dpll_num: DPLL index
+ * @ref_state: Reference clock state
+ * @dpll_state: DPLL state
+ * @phase_offset: Phase offset in ns
+ * @eec_mode: EEC_mode
+ *
+ * Get CGU DPLL status (0x0C66)
+ */
+int
+ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
+			   u16 *dpll_state, s64 *phase_offset, u8 *eec_mode)
+{
+	struct ice_aqc_get_cgu_dpll_status *cmd;
+	const s64 NSEC_PER_PSEC = 1000LL;
+	struct ice_aq_desc desc;
+	int status;
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
+		*phase_offset = convert_s48_to_s64(*phase_offset)
+				/ NSEC_PER_PSEC;
+		*eec_mode = cmd->eec_mode;
+	}
+
+	return status;
+}
+
+/**
+ * ice_aq_set_cgu_dpll_config
+ * @hw: pointer to the HW struct
+ * @dpll_num: DPLL index
+ * @ref_state: Reference clock state
+ * @config: DPLL config
+ * @eec_mode: EEC mode
+ *
+ * Set CGU DPLL config (0x0C67)
+ */
+int
+ice_aq_set_cgu_dpll_config(struct ice_hw *hw, u8 dpll_num, u8 ref_state,
+			   u8 config, u8 eec_mode)
+{
+	struct ice_aqc_set_cgu_dpll_config *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_cgu_dpll_config);
+	cmd = &desc.params.set_cgu_dpll_config;
+	cmd->dpll_num = dpll_num;
+	cmd->ref_state = ref_state;
+	cmd->config = config;
+	cmd->eec_mode = eec_mode;
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
+/**
+ * ice_aq_set_cgu_ref_prio
+ * @hw: pointer to the HW struct
+ * @dpll_num: DPLL index
+ * @ref_idx: Reference pin index
+ * @ref_priority: Reference input priority
+ *
+ * Set CGU reference priority (0x0C68)
+ */
+int
+ice_aq_set_cgu_ref_prio(struct ice_hw *hw, u8 dpll_num, u8 ref_idx,
+			u8 ref_priority)
+{
+	struct ice_aqc_set_cgu_ref_prio *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_cgu_ref_prio);
+	cmd = &desc.params.set_cgu_ref_prio;
+	cmd->dpll_num = dpll_num;
+	cmd->ref_idx = ref_idx;
+	cmd->ref_priority = ref_priority;
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
+/**
+ * ice_aq_get_cgu_ref_prio
+ * @hw: pointer to the HW struct
+ * @dpll_num: DPLL index
+ * @ref_idx: Reference pin index
+ * @ref_prio: Reference input priority
+ *
+ * Get CGU reference priority (0x0C69)
+ */
+int
+ice_aq_get_cgu_ref_prio(struct ice_hw *hw, u8 dpll_num, u8 ref_idx,
+			u8 *ref_prio)
+{
+	struct ice_aqc_get_cgu_ref_prio *cmd;
+	struct ice_aq_desc desc;
+	int status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_cgu_ref_prio);
+	cmd = &desc.params.get_cgu_ref_prio;
+	cmd->dpll_num = dpll_num;
+	cmd->ref_idx = ref_idx;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!status)
+		*ref_prio = cmd->ref_priority;
+
+	return status;
+}
+
+/**
+ * ice_aq_get_cgu_info
+ * @hw: pointer to the HW struct
+ * @cgu_id: CGU ID
+ * @cgu_cfg_ver: CGU config version
+ * @cgu_fw_ver: CGU firmware version
+ *
+ * Get CGU info (0x0C6A)
+ */
+int
+ice_aq_get_cgu_info(struct ice_hw *hw, u32 *cgu_id, u32 *cgu_cfg_ver,
+		    u32 *cgu_fw_ver)
+{
+	struct ice_aqc_get_cgu_info *cmd;
+	struct ice_aq_desc desc;
+	int status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_cgu_info);
+	cmd = &desc.params.get_cgu_info;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (!status) {
+		*cgu_id = le32_to_cpu(cmd->cgu_id);
+		*cgu_cfg_ver = le32_to_cpu(cmd->cgu_cfg_ver);
+		*cgu_fw_ver = le32_to_cpu(cmd->cgu_fw_ver);
+	}
+
+	return status;
+}
+
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
+int
+ice_aq_set_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, bool enable,
+			   u32 *freq)
+{
+	struct ice_aqc_set_phy_rec_clk_out *cmd;
+	struct ice_aq_desc desc;
+	int status;
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
+int
+ice_aq_get_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, u8 *port_num,
+			   u8 *flags, u32 *freq)
+{
+	struct ice_aqc_get_phy_rec_clk_out *cmd;
+	struct ice_aq_desc desc;
+	int status;
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
 /**
  * ice_replay_pre_init - replay pre initialization
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 4c6a0b5c9304..637c3e5eea8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -94,6 +94,12 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 		    struct ice_aqc_get_phy_caps_data *caps,
 		    struct ice_sq_cd *cd);
 int
+ice_find_netlist_node(struct ice_hw *hw, u8 node_type_ctx, u8 node_part_number,
+		      u16 *node_handle);
+int
+ice_aq_get_netlist_node(struct ice_hw *hw, struct ice_aqc_get_link_topo *cmd,
+			u8 *node_part_number, u16 *node_handle);
+int
 ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
 		 enum ice_adminq_opc opc, struct ice_sq_cd *cd);
 int
@@ -192,6 +198,43 @@ void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf);
 struct ice_q_ctx *
 ice_get_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 q_handle);
 int ice_sbq_rw_reg(struct ice_hw *hw, struct ice_sbq_msg_input *in);
+int
+ice_aq_get_cgu_abilities(struct ice_hw *hw,
+			 struct ice_aqc_get_cgu_abilities *abilities);
+int
+ice_aq_set_input_pin_cfg(struct ice_hw *hw, u8 input_idx, u8 flags1, u8 flags2,
+			 u32 freq, s32 phase_delay);
+int
+ice_aq_get_input_pin_cfg(struct ice_hw *hw, u8 input_idx, u8 *status, u8 *type,
+			 u8 *flags1, u8 *flags2, u32 *freq, s32 *phase_delay);
+int
+ice_aq_set_output_pin_cfg(struct ice_hw *hw, u8 output_idx, u8 flags,
+			  u8 src_sel, u32 freq, s32 phase_delay);
+int
+ice_aq_get_output_pin_cfg(struct ice_hw *hw, u8 output_idx, u8 *flags,
+			  u8 *src_sel, u32 *freq, u32 *src_freq);
+int
+ice_aq_get_cgu_dpll_status(struct ice_hw *hw, u8 dpll_num, u8 *ref_state,
+			   u16 *dpll_state, s64 *phase_offset, u8 *eec_mode);
+int
+ice_aq_set_cgu_dpll_config(struct ice_hw *hw, u8 dpll_num, u8 ref_state,
+			   u8 config, u8 eec_mode);
+int
+ice_aq_set_cgu_ref_prio(struct ice_hw *hw, u8 dpll_num, u8 ref_idx,
+			u8 ref_priority);
+int
+ice_aq_get_cgu_ref_prio(struct ice_hw *hw, u8 dpll_num, u8 ref_idx,
+			u8 *ref_prio);
+int
+ice_aq_get_cgu_info(struct ice_hw *hw, u32 *cgu_id, u32 *cgu_cfg_ver,
+		    u32 *cgu_fw_ver);
+
+int
+ice_aq_set_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, bool enable,
+			   u32 *freq);
+int
+ice_aq_get_phy_rec_clk_out(struct ice_hw *hw, u8 phy_output, u8 *port_num,
+			   u8 *flags, u32 *freq);
 void
 ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 94aa834cd9a6..6d965e030772 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4426,13 +4426,22 @@ void ice_init_feature_support(struct ice_pf *pf)
 	case ICE_DEV_ID_E810C_BACKPLANE:
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
+	case ICE_DEV_ID_E810_XXV_BACKPLANE:
+	case ICE_DEV_ID_E810_XXV_QSFP:
+	case ICE_DEV_ID_E810_XXV_SFP:
 		ice_set_feature_support(pf, ICE_F_DSCP);
 		ice_set_feature_support(pf, ICE_F_PTP_EXTTS);
-		if (ice_is_e810t(&pf->hw)) {
+		if (ice_is_phy_rclk_present(&pf->hw))
+			ice_set_feature_support(pf, ICE_F_PHY_RCLK);
+		/* If we don't own the timer - don't enable other caps */
+		if (!pf->hw.func_caps.ts_func_info.src_tmr_owned)
+			break;
+		if (ice_is_cgu_present(&pf->hw))
+			ice_set_feature_support(pf, ICE_F_CGU);
+		if (ice_is_clock_mux_present_e810t(&pf->hw))
 			ice_set_feature_support(pf, ICE_F_SMA_CTRL);
-			if (ice_gnss_is_gps_present(&pf->hw))
-				ice_set_feature_support(pf, ICE_F_GNSS);
-		}
+		if (ice_gnss_is_gps_present(&pf->hw))
+			ice_set_feature_support(pf, ICE_F_GNSS);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index a38614d21ea8..01bf15941f85 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -3213,6 +3213,91 @@ ice_get_pca9575_handle(struct ice_hw *hw, u16 *pca9575_handle)
 	return 0;
 }
 
+/**
+ * ice_is_phy_rclk_present
+ * @hw: pointer to the hw struct
+ *
+ * Check if the PHY Recovered Clock device is present in the netlist
+ * Return:
+ * * true - device found in netlist
+ * * false - device not found
+ */
+bool ice_is_phy_rclk_present(struct ice_hw *hw)
+{
+	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+				  ICE_ACQ_GET_LINK_TOPO_NODE_NR_C827, NULL) &&
+	    ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+				  ICE_ACQ_GET_LINK_TOPO_NODE_NR_E822_PHY, NULL))
+		return false;
+
+	return true;
+}
+
+/**
+ * ice_is_clock_mux_present_e810t
+ * @hw: pointer to the hw struct
+ *
+ * Check if the Clock Multiplexer device is present in the netlist
+ * Return:
+ * * true - device found in netlist
+ * * false - device not found
+ */
+bool ice_is_clock_mux_present_e810t(struct ice_hw *hw)
+{
+	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_MUX,
+				  ICE_ACQ_GET_LINK_TOPO_NODE_NR_GEN_CLK_MUX,
+				  NULL))
+		return false;
+
+	return true;
+}
+
+/**
+ * ice_get_pf_c827_idx - find and return the C827 index for the current pf
+ * @hw: pointer to the hw struct
+ * @idx: index of the found C827 PHY
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+int ice_get_pf_c827_idx(struct ice_hw *hw, u8 *idx)
+{
+	struct ice_aqc_get_link_topo cmd;
+	u8 node_part_number;
+	u16 node_handle;
+	int status;
+	u8 ctx;
+
+	if (hw->mac_type != ICE_MAC_E810)
+		return -ENODEV;
+
+	if (hw->device_id != ICE_DEV_ID_E810C_QSFP) {
+		*idx = C827_0;
+		return 0;
+	}
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	ctx = ICE_AQC_LINK_TOPO_NODE_TYPE_PHY << ICE_AQC_LINK_TOPO_NODE_TYPE_S;
+	ctx |= ICE_AQC_LINK_TOPO_NODE_CTX_PORT << ICE_AQC_LINK_TOPO_NODE_CTX_S;
+	cmd.addr.topo_params.node_type_ctx = ctx;
+	cmd.addr.topo_params.index = 0;
+
+	status = ice_aq_get_netlist_node(hw, &cmd, &node_part_number,
+					 &node_handle);
+	if (status || node_part_number != ICE_ACQ_GET_LINK_TOPO_NODE_NR_C827)
+		return -ENOENT;
+
+	if (node_handle == E810C_QSFP_C827_0_HANDLE)
+		*idx = C827_0;
+	else if (node_handle == E810C_QSFP_C827_1_HANDLE)
+		*idx = C827_1;
+	else
+		return -EIO;
+
+	return 0;
+}
+
 /**
  * ice_read_sma_ctrl_e810t
  * @hw: pointer to the hw struct
@@ -3381,3 +3466,326 @@ int ice_get_phy_tx_tstamp_ready(struct ice_hw *hw, u8 block, u64 *tstamp_ready)
 		return ice_get_phy_tx_tstamp_ready_e822(hw, block,
 							tstamp_ready);
 }
+
+/**
+ * ice_is_cgu_present
+ * @hw: pointer to the hw struct
+ *
+ * Check if the Clock Generation Unit (CGU) device is present in the netlist
+ * Return:
+ * * true - cgu is present
+ * * false - cgu is not present
+ */
+bool ice_is_cgu_present(struct ice_hw *hw)
+{
+	if (!ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+				   ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032,
+				   NULL)) {
+		hw->cgu_part_number = ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032;
+		return true;
+	} else if (!ice_find_netlist_node(hw,
+					  ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+					  ICE_ACQ_GET_LINK_TOPO_NODE_NR_SI5383_5384,
+					  NULL)) {
+		hw->cgu_part_number = ICE_ACQ_GET_LINK_TOPO_NODE_NR_SI5383_5384;
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_cgu_get_pin_desc_e823
+ * @hw: pointer to the hw struct
+ * @input: if request is done against input or output pin
+ * @size: number of inputs/outputs
+ *
+ * Return: pointer to pin description array associated to given hw.
+ */
+static const struct ice_cgu_pin_desc *
+ice_cgu_get_pin_desc_e823(struct ice_hw *hw, bool input, int *size)
+{
+	static const struct ice_cgu_pin_desc *t;
+
+	if (hw->cgu_part_number ==
+	    ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032) {
+		if (input) {
+			t = ice_e823_zl_cgu_inputs;
+			*size = ARRAY_SIZE(ice_e823_zl_cgu_inputs);
+		} else {
+			t = ice_e823_zl_cgu_outputs;
+			*size = ARRAY_SIZE(ice_e823_zl_cgu_outputs);
+		}
+	} else if (hw->cgu_part_number ==
+		   ICE_ACQ_GET_LINK_TOPO_NODE_NR_SI5383_5384) {
+		if (input) {
+			t = ice_e823_si_cgu_inputs;
+			*size = ARRAY_SIZE(ice_e823_si_cgu_inputs);
+		} else {
+			t = ice_e823_si_cgu_outputs;
+			*size = ARRAY_SIZE(ice_e823_si_cgu_outputs);
+		}
+	} else {
+		t = NULL;
+		*size = 0;
+	}
+
+	return t;
+}
+
+/**
+ * ice_cgu_get_pin_desc
+ * @hw: pointer to the hw struct
+ * @input: if request is done against input or output pins
+ * @size: size of array returned by function
+ *
+ * Return: pointer to pin description array associated to given hw.
+ */
+static const struct ice_cgu_pin_desc *
+ice_cgu_get_pin_desc(struct ice_hw *hw, bool input, int *size)
+{
+	const struct ice_cgu_pin_desc *t = NULL;
+
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E810C_SFP:
+		if (input) {
+			t = ice_e810t_sfp_cgu_inputs;
+			*size = ARRAY_SIZE(ice_e810t_sfp_cgu_inputs);
+		} else {
+			t = ice_e810t_sfp_cgu_outputs;
+			*size = ARRAY_SIZE(ice_e810t_sfp_cgu_outputs);
+		}
+		break;
+	case ICE_DEV_ID_E810C_QSFP:
+		if (input) {
+			t = ice_e810t_qsfp_cgu_inputs;
+			*size = ARRAY_SIZE(ice_e810t_qsfp_cgu_inputs);
+		} else {
+			t = ice_e810t_qsfp_cgu_outputs;
+			*size = ARRAY_SIZE(ice_e810t_qsfp_cgu_outputs);
+		}
+		break;
+	case ICE_DEV_ID_E823L_10G_BASE_T:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823L_BACKPLANE:
+	case ICE_DEV_ID_E823L_QSFP:
+	case ICE_DEV_ID_E823L_SFP:
+	case ICE_DEV_ID_E823C_10G_BASE_T:
+	case ICE_DEV_ID_E823C_BACKPLANE:
+	case ICE_DEV_ID_E823C_QSFP:
+	case ICE_DEV_ID_E823C_SFP:
+	case ICE_DEV_ID_E823C_SGMII:
+		t = ice_cgu_get_pin_desc_e823(hw, input, size);
+		break;
+	default:
+		break;
+	}
+
+	return t;
+}
+
+/**
+ * ice_cgu_get_pin_type
+ * @hw: pointer to the hw struct
+ * @pin: pin index
+ * @input: if request is done against input or output pin
+ *
+ * Return: type of a pin.
+ */
+enum dpll_pin_type ice_cgu_get_pin_type(struct ice_hw *hw, u8 pin, bool input)
+{
+	const struct ice_cgu_pin_desc *t;
+	int t_size;
+
+	t = ice_cgu_get_pin_desc(hw, input, &t_size);
+
+	if (!t)
+		return 0;
+
+	if (pin >= t_size)
+		return 0;
+
+	return t[pin].type;
+}
+
+/**
+ * ice_cgu_get_pin_sig_type_mask
+ * @hw: pointer to the hw struct
+ * @pin: pin index
+ * @input: if request is done against input or output pin
+ *
+ * Return: signal type bit mask of a pin.
+ */
+unsigned long
+ice_cgu_get_pin_sig_type_mask(struct ice_hw *hw, u8 pin, bool input)
+{
+	const struct ice_cgu_pin_desc *t;
+	int t_size;
+
+	t = ice_cgu_get_pin_desc(hw, input, &t_size);
+
+	if (!t)
+		return 0;
+
+	if (pin >= t_size)
+		return 0;
+
+	return t[pin].sig_type_mask;
+}
+
+/**
+ * ice_cgu_get_pin_name
+ * @hw: pointer to the hw struct
+ * @pin: pin index
+ * @input: if request is done against input or output pin
+ *
+ * Return:
+ * * null terminated char array with name
+ * * NULL in case of failure
+ */
+const char *ice_cgu_get_pin_name(struct ice_hw *hw, u8 pin, bool input)
+{
+	const struct ice_cgu_pin_desc *t;
+	int t_size;
+
+	t = ice_cgu_get_pin_desc(hw, input, &t_size);
+
+	if (!t)
+		return NULL;
+
+	if (pin >= t_size)
+		return NULL;
+
+	return t[pin].name;
+}
+
+/**
+ * ice_get_cgu_state - get the state of the DPLL
+ * @hw: pointer to the hw struct
+ * @dpll_idx: Index of internal DPLL unit
+ * @last_dpll_state: last known state of DPLL
+ * @pin: pointer to a buffer for returning currently active pin
+ * @ref_state: reference clock state
+ * @phase_offset: pointer to a buffer for returning phase offset
+ * @dpll_state: state of the DPLL (output)
+ *
+ * This function will read the state of the DPLL(dpll_idx). Non-null
+ * 'pin', 'ref_state', 'eec_mode' and 'phase_offset' parameters are used to
+ * retrieve currently active pin, state, mode and phase_offset respectively.
+ *
+ * Return: state of the DPLL
+ */
+int ice_get_cgu_state(struct ice_hw *hw, u8 dpll_idx,
+		      enum ice_cgu_state last_dpll_state, u8 *pin,
+		      u8 *ref_state, u8 *eec_mode, s64 *phase_offset,
+		      enum ice_cgu_state *dpll_state)
+{
+	u8 hw_ref_state, hw_eec_mode;
+	s64 hw_phase_offset;
+	u16 hw_dpll_state;
+	int status;
+
+	status = ice_aq_get_cgu_dpll_status(hw, dpll_idx, &hw_ref_state,
+					    &hw_dpll_state, &hw_phase_offset,
+					    &hw_eec_mode);
+	if (status) {
+		*dpll_state = ICE_CGU_STATE_INVALID;
+		return status;
+	}
+
+	if (pin) {
+		/* current ref pin in dpll_state_refsel_status_X register */
+		*pin = (hw_dpll_state &
+			ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SEL) >>
+		       ICE_AQC_GET_CGU_DPLL_STATUS_STATE_CLK_REF_SHIFT;
+	}
+
+	if (phase_offset)
+		*phase_offset = hw_phase_offset;
+
+	if (ref_state)
+		*ref_state = hw_ref_state;
+
+	if (eec_mode)
+		*eec_mode = hw_eec_mode;
+
+	if (!dpll_state)
+		return status;
+
+	/* According to ZL DPLL documentation, once state reach LOCKED_HO_ACQ
+	 * it would never return to FREERUN. This aligns to ITU-T G.781
+	 * Recommendation. We cannot report HOLDOVER as HO memory is cleared
+	 * while switching to another reference.
+	 * Only for situations where previous state was either: "LOCKED without
+	 * HO_ACQ" or "HOLDOVER" we actually back to FREERUN.
+	 */
+	if (hw_dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_LOCK) {
+		if (hw_dpll_state & ICE_AQC_GET_CGU_DPLL_STATUS_STATE_HO_READY)
+			*dpll_state = ICE_CGU_STATE_LOCKED_HO_ACQ;
+		else
+			*dpll_state = ICE_CGU_STATE_LOCKED;
+	} else if (last_dpll_state == ICE_CGU_STATE_LOCKED_HO_ACQ ||
+		   last_dpll_state == ICE_CGU_STATE_HOLDOVER) {
+		*dpll_state = ICE_CGU_STATE_HOLDOVER;
+	}
+	return status;
+}
+
+/**
+ * ice_get_cgu_rclk_pin_info - get info on available recovered clock pins
+ * @hw: pointer to the hw struct
+ * @base_idx: returns index of first recovered clock pin on device
+ * @pin_num: returns number of recovered clock pins available on device
+ *
+ * Based on hw provide caller info about recovery clock pins available on the
+ * board.
+ *
+ * Return:
+ * * 0 - success, information is valid
+ * * negative - failure, information is not valid
+ */
+int ice_get_cgu_rclk_pin_info(struct ice_hw *hw, u8 *base_idx, u8 *pin_num)
+{
+	int ret;
+
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E810C_SFP:
+	case ICE_DEV_ID_E810C_QSFP:
+		u8 phy_idx;
+
+		ret = ice_get_pf_c827_idx(hw, &phy_idx);
+		if (ret)
+			return ret;
+		*base_idx = E810T_CGU_INPUT_C827(phy_idx, ICE_RCLKA_PIN);
+		*pin_num = ICE_E810_RCLK_PINS_NUM;
+		ret = 0;
+		break;
+	case ICE_DEV_ID_E823L_10G_BASE_T:
+	case ICE_DEV_ID_E823L_1GBE:
+	case ICE_DEV_ID_E823L_BACKPLANE:
+	case ICE_DEV_ID_E823L_QSFP:
+	case ICE_DEV_ID_E823L_SFP:
+	case ICE_DEV_ID_E823C_10G_BASE_T:
+	case ICE_DEV_ID_E823C_BACKPLANE:
+	case ICE_DEV_ID_E823C_QSFP:
+	case ICE_DEV_ID_E823C_SFP:
+	case ICE_DEV_ID_E823C_SGMII:
+		*pin_num = ICE_E822_RCLK_PINS_NUM;
+		ret = 0;
+		if (hw->cgu_part_number ==
+		    ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032)
+			*base_idx = ZL_REF1P;
+		else if (hw->cgu_part_number ==
+			 ICE_ACQ_GET_LINK_TOPO_NODE_NR_SI5383_5384)
+			*base_idx = SI_REF1P;
+		else
+			ret = -ENODEV;
+
+		break;
+	default:
+		ret = -ENODEV;
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 3b68cb91bd81..855880f026fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -3,6 +3,7 @@
 
 #ifndef _ICE_PTP_HW_H_
 #define _ICE_PTP_HW_H_
+#include <uapi/linux/dpll.h>
 
 enum ice_ptp_tmr_cmd {
 	INIT_TIME,
@@ -109,6 +110,232 @@ struct ice_cgu_pll_params_e822 {
 	u32 post_pll_div;
 };
 
+#define E810C_QSFP_C827_0_HANDLE	2
+#define E810C_QSFP_C827_1_HANDLE	3
+enum ice_e810_c827_idx {
+	C827_0,
+	C827_1
+};
+
+enum ice_phy_rclk_pins {
+	ICE_RCLKA_PIN = 0,		/* SCL pin */
+	ICE_RCLKB_PIN,			/* SDA pin */
+};
+
+#define ICE_E810_RCLK_PINS_NUM		(ICE_RCLKB_PIN + 1)
+#define ICE_E822_RCLK_PINS_NUM		(ICE_RCLKA_PIN + 1)
+#define E810T_CGU_INPUT_C827(_phy, _pin) ((_phy) * ICE_E810_RCLK_PINS_NUM + \
+					  (_pin) + ZL_REF1P)
+enum ice_cgu_state {
+	ICE_CGU_STATE_UNKNOWN = -1,
+	ICE_CGU_STATE_INVALID,		/* state is not valid */
+	ICE_CGU_STATE_FREERUN,		/* clock is free-running */
+	ICE_CGU_STATE_LOCKED,		/* clock is locked to the reference,
+					 * but the holdover memory is not valid
+					 */
+	ICE_CGU_STATE_LOCKED_HO_ACQ,	/* clock is locked to the reference
+					 * and holdover memory is valid
+					 */
+	ICE_CGU_STATE_HOLDOVER,		/* clock is in holdover mode */
+	ICE_CGU_STATE_MAX
+};
+
+#define MAX_CGU_STATE_NAME_LEN		14
+struct ice_cgu_state_desc {
+	char name[MAX_CGU_STATE_NAME_LEN];
+	enum ice_cgu_state state;
+};
+
+enum ice_zl_cgu_in_pins {
+	ZL_REF0P = 0,
+	ZL_REF0N,
+	ZL_REF1P,
+	ZL_REF1N,
+	ZL_REF2P,
+	ZL_REF2N,
+	ZL_REF3P,
+	ZL_REF3N,
+	ZL_REF4P,
+	ZL_REF4N,
+	NUM_ZL_CGU_INPUT_PINS
+};
+
+enum ice_zl_cgu_out_pins {
+	ZL_OUT0 = 0,
+	ZL_OUT1,
+	ZL_OUT2,
+	ZL_OUT3,
+	ZL_OUT4,
+	ZL_OUT5,
+	ZL_OUT6,
+	NUM_ZL_CGU_OUTPUT_PINS
+};
+
+enum ice_si_cgu_in_pins {
+	SI_REF0P = 0,
+	SI_REF0N,
+	SI_REF1P,
+	SI_REF1N,
+	SI_REF2P,
+	SI_REF2N,
+	SI_REF3,
+	SI_REF4,
+	NUM_SI_CGU_INPUT_PINS
+};
+
+enum ice_si_cgu_out_pins {
+	SI_OUT0 = 0,
+	SI_OUT1,
+	SI_OUT2,
+	SI_OUT3,
+	SI_OUT4,
+	NUM_SI_CGU_OUTPUT_PINS
+};
+
+#define MAX_CGU_PIN_NAME_LEN		16
+#define ICE_SIG_TYPE_MASK_1PPS_10MHZ	(BIT(DPLL_PIN_SIGNAL_TYPE_1_PPS) | \
+					 BIT(DPLL_PIN_SIGNAL_TYPE_10_MHZ))
+struct ice_cgu_pin_desc {
+	char name[MAX_CGU_PIN_NAME_LEN];
+	u8 index;
+	enum dpll_pin_type type;
+	unsigned long sig_type_mask;
+};
+
+static const struct ice_cgu_pin_desc ice_e810t_sfp_cgu_inputs[] = {
+	{ "CVL-SDP22",	  ZL_REF0P, DPLL_PIN_TYPE_INT_OSCILLATOR,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "CVL-SDP20",	  ZL_REF0N, DPLL_PIN_TYPE_INT_OSCILLATOR,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "C827_0-RCLKA", ZL_REF1P, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "C827_0-RCLKB", ZL_REF1N, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "SMA1",	  ZL_REF3P, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "SMA2/U.FL2",	  ZL_REF3N, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "GNSS-1PPS",	  ZL_REF4P, DPLL_PIN_TYPE_GNSS,
+		BIT(DPLL_PIN_SIGNAL_TYPE_1_PPS) },
+	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+};
+
+static const struct ice_cgu_pin_desc ice_e810t_qsfp_cgu_inputs[] = {
+	{ "CVL-SDP22",	  ZL_REF0P, DPLL_PIN_TYPE_INT_OSCILLATOR,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "CVL-SDP20",	  ZL_REF0N, DPLL_PIN_TYPE_INT_OSCILLATOR,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "C827_0-RCLKA", ZL_REF1P, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "C827_0-RCLKB", ZL_REF1N, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "C827_1-RCLKA", ZL_REF2P, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "C827_1-RCLKB", ZL_REF2N, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "SMA1",	  ZL_REF3P, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "SMA2/U.FL2",	  ZL_REF3N, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "GNSS-1PPS",	  ZL_REF4P, DPLL_PIN_TYPE_GNSS,
+		BIT(DPLL_PIN_SIGNAL_TYPE_1_PPS) },
+	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR,
+			BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+};
+
+static const struct ice_cgu_pin_desc ice_e810t_sfp_cgu_outputs[] = {
+	{ "REF-SMA1",	    ZL_OUT0, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "REF-SMA2/U.FL2", ZL_OUT1, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "PHY-CLK",	    ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "MAC-CLK",	    ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "CVL-SDP21",	    ZL_OUT4, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "CVL-SDP23",	    ZL_OUT5, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+};
+
+static const struct ice_cgu_pin_desc ice_e810t_qsfp_cgu_outputs[] = {
+	{ "REF-SMA1",	    ZL_OUT0, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "REF-SMA2/U.FL2", ZL_OUT1, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "PHY-CLK",	    ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "PHY2-CLK",	    ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "MAC-CLK",	    ZL_OUT4, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "CVL-SDP21",	    ZL_OUT5, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "CVL-SDP23",	    ZL_OUT6, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+};
+
+static const struct ice_cgu_pin_desc ice_e823_si_cgu_inputs[] = {
+	{ "NONE",	  SI_REF0P, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "NONE",	  SI_REF0N, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "SYNCE0_DP",	  SI_REF1P, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "SYNCE0_DN",	  SI_REF1N, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "EXT_CLK_SYNC", SI_REF2P, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "NONE",	  SI_REF2N, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "EXT_PPS_OUT",  SI_REF3,  DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "INT_PPS_OUT",  SI_REF4,  DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+};
+
+static const struct ice_cgu_pin_desc ice_e823_si_cgu_outputs[] = {
+	{ "1588-TIME_SYNC", SI_OUT0, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "PHY-CLK",	    SI_OUT1, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "10MHZ-SMA2",	    SI_OUT2, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "PPS-SMA1",	    SI_OUT3, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+};
+
+static const struct ice_cgu_pin_desc ice_e823_zl_cgu_inputs[] = {
+	{ "NONE",	  ZL_REF0P, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "INT_PPS_OUT",  ZL_REF0N, DPLL_PIN_TYPE_EXT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_1_PPS) },
+	{ "SYNCE0_DP",	  ZL_REF1P, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "SYNCE0_DN",	  ZL_REF1N, DPLL_PIN_TYPE_MUX,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "NONE",	  ZL_REF2P, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "NONE",	  ZL_REF2N, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "EXT_CLK_SYNC", ZL_REF3P, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "NONE",	  ZL_REF3N, DPLL_PIN_TYPE_UNSPEC, 0 },
+	{ "EXT_PPS_OUT",  ZL_REF4P, DPLL_PIN_TYPE_EXT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_1_PPS) },
+	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR,
+			BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+};
+
+static const struct ice_cgu_pin_desc ice_e823_zl_cgu_outputs[] = {
+	{ "PPS-SMA1",	   ZL_OUT0, DPLL_PIN_TYPE_EXT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_1_PPS) },
+	{ "10MHZ-SMA2",	   ZL_OUT1, DPLL_PIN_TYPE_EXT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_10_MHZ) },
+	{ "PHY-CLK",	   ZL_OUT2, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "1588-TIME_REF", ZL_OUT3, DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+		BIT(DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) },
+	{ "CPK-TIME_SYNC", ZL_OUT4, DPLL_PIN_TYPE_EXT,
+		ICE_SIG_TYPE_MASK_1PPS_10MHZ },
+	{ "NONE",	   ZL_OUT5, DPLL_PIN_TYPE_UNSPEC, 0 },
+};
+
 extern const struct
 ice_cgu_pll_params_e822 e822_cgu_params[NUM_ICE_TIME_REF_FREQ];
 
@@ -197,6 +424,19 @@ int ice_read_sma_ctrl_e810t(struct ice_hw *hw, u8 *data);
 int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data);
 int ice_read_pca9575_reg_e810t(struct ice_hw *hw, u8 offset, u8 *data);
 bool ice_is_pca9575_present(struct ice_hw *hw);
+bool ice_is_phy_rclk_present(struct ice_hw *hw);
+bool ice_is_clock_mux_present_e810t(struct ice_hw *hw);
+int ice_get_pf_c827_idx(struct ice_hw *hw, u8 *idx);
+bool ice_is_cgu_present(struct ice_hw *hw);
+enum dpll_pin_type ice_cgu_get_pin_type(struct ice_hw *hw, u8 pin, bool input);
+unsigned long
+ice_cgu_get_pin_sig_type_mask(struct ice_hw *hw, u8 pin, bool input);
+const char *ice_cgu_get_pin_name(struct ice_hw *hw, u8 pin, bool input);
+int ice_get_cgu_state(struct ice_hw *hw, u8 dpll_idx,
+		      enum ice_cgu_state last_dpll_state, u8 *pin,
+		      u8 *ref_state, u8 *eec_mode, s64 *phase_offset,
+		      enum ice_cgu_state *dpll_state);
+int ice_get_cgu_rclk_pin_info(struct ice_hw *hw, u8 *base_idx, u8 *pin_num);
 
 #define PFTSYN_SEM_BYTES	4
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e3f622cad425..c49f573d724f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -962,6 +962,7 @@ struct ice_hw {
 	DECLARE_BITMAP(hw_ptype, ICE_FLOW_PTYPE_MAX);
 	u8 dvm_ena;
 	u16 io_expander_handle;
+	u8 cgu_part_number;
 };
 
 /* Statistics collected by each port, VSI, VEB, and S-channel */
-- 
2.30.2

