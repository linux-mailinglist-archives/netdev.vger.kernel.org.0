Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B0422BA5A
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgGWXro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:43317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgGWXrl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:41 -0400
IronPort-SDR: 1BunNy07f04+v250hOop5/qVRHfM6iIa2sC7OF0Bza55GxwWfeCaDm9cRwWZ+qRjR4F0lHKQiJ
 sqN2jy87H42g==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515440"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515440"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:27 -0700
IronPort-SDR: XGUlZHiBAzXHWSIRiP3+rX0TLpeowHe8GITw0iVkNGjRVTzXVK9jNhTHEfN7rTt+J6mdwUbIR6
 v4CI0oTko3zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742319"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 13/15] ice: add AQC get link topology handle support
Date:   Thu, 23 Jul 2020 16:47:18 -0700
Message-Id: <20200723234720.1547308-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Add AQC get link topology handle support. This is needed to determine
Direct Attach (DA) or backplane media type for PHY types that support
either. Get link topology handle cage node type request can be used to
determine if a cage is present or not. If a cage is present for PHY
types that supports both DA and backplane media type, then the media
type is DA, else the media type is backplane.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 53 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 66 ++++++++++++++++++-
 2 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 31b6fd8dc0dc..4315a784b975 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1194,6 +1194,57 @@ struct ice_aqc_set_mac_lb {
 	u8 reserved[15];
 };
 
+struct ice_aqc_link_topo_addr {
+	u8 lport_num;
+	u8 lport_num_valid;
+#define ICE_AQC_LINK_TOPO_PORT_NUM_VALID	BIT(0)
+	u8 node_type_ctx;
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_S		0
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_M	(0xF << ICE_AQC_LINK_TOPO_NODE_TYPE_S)
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_PHY		0
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_GPIO_CTRL	1
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_MUX_CTRL	2
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_LED_CTRL	3
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_LED		4
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_THERMAL	5
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_CAGE	6
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_MEZZ	7
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_ID_EEPROM	8
+#define ICE_AQC_LINK_TOPO_NODE_CTX_S		4
+#define ICE_AQC_LINK_TOPO_NODE_CTX_M		\
+				(0xF << ICE_AQC_LINK_TOPO_NODE_CTX_S)
+#define ICE_AQC_LINK_TOPO_NODE_CTX_GLOBAL	0
+#define ICE_AQC_LINK_TOPO_NODE_CTX_BOARD	1
+#define ICE_AQC_LINK_TOPO_NODE_CTX_PORT		2
+#define ICE_AQC_LINK_TOPO_NODE_CTX_NODE		3
+#define ICE_AQC_LINK_TOPO_NODE_CTX_PROVIDED	4
+#define ICE_AQC_LINK_TOPO_NODE_CTX_OVERRIDE	5
+	u8 index;
+	__le16 handle;
+#define ICE_AQC_LINK_TOPO_HANDLE_S	0
+#define ICE_AQC_LINK_TOPO_HANDLE_M	(0x3FF << ICE_AQC_LINK_TOPO_HANDLE_S)
+/* Used to decode the handle field */
+#define ICE_AQC_LINK_TOPO_HANDLE_BRD_TYPE_M	BIT(9)
+#define ICE_AQC_LINK_TOPO_HANDLE_BRD_TYPE_LOM	BIT(9)
+#define ICE_AQC_LINK_TOPO_HANDLE_BRD_TYPE_MEZZ	0
+#define ICE_AQC_LINK_TOPO_HANDLE_NODE_S		0
+/* In case of a Mezzanine type */
+#define ICE_AQC_LINK_TOPO_HANDLE_MEZZ_NODE_M	\
+				(0x3F << ICE_AQC_LINK_TOPO_HANDLE_NODE_S)
+#define ICE_AQC_LINK_TOPO_HANDLE_MEZZ_S	6
+#define ICE_AQC_LINK_TOPO_HANDLE_MEZZ_M	(0x7 << ICE_AQC_LINK_TOPO_HANDLE_MEZZ_S)
+/* In case of a LOM type */
+#define ICE_AQC_LINK_TOPO_HANDLE_LOM_NODE_M	\
+				(0x1FF << ICE_AQC_LINK_TOPO_HANDLE_NODE_S)
+};
+
+/* Get Link Topology Handle (direct, 0x06E0) */
+struct ice_aqc_get_link_topo {
+	struct ice_aqc_link_topo_addr addr;
+	u8 node_part_num;
+	u8 rsvd[9];
+};
+
 /* Set Port Identification LED (direct, 0x06E9) */
 struct ice_aqc_set_port_id_led {
 	u8 lport_num;
@@ -1764,6 +1815,7 @@ struct ice_aq_desc {
 		struct ice_aqc_set_event_mask set_event_mask;
 		struct ice_aqc_get_link_status get_link_status;
 		struct ice_aqc_event_lan_overflow lan_overflow;
+		struct ice_aqc_get_link_topo get_link_topo;
 	} params;
 };
 
@@ -1863,6 +1915,7 @@ enum ice_adminq_opc {
 	ice_aqc_opc_get_link_status			= 0x0607,
 	ice_aqc_opc_set_event_mask			= 0x0613,
 	ice_aqc_opc_set_mac_lb				= 0x0620,
+	ice_aqc_opc_get_link_topo			= 0x06E0,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
 	ice_aqc_opc_sff_eeprom				= 0x06EE,
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 695711e48acc..d8df97158249 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -199,6 +199,56 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 	return status;
 }
 
+/**
+ * ice_aq_get_link_topo_handle - get link topology node return status
+ * @pi: port information structure
+ * @node_type: requested node type
+ * @cd: pointer to command details structure or NULL
+ *
+ * Get link topology node return status for specified node type (0x06E0)
+ *
+ * Node type cage can be used to determine if cage is present. If AQC
+ * returns error (ENOENT), then no cage present. If no cage present, then
+ * connection type is backplane or BASE-T.
+ */
+static enum ice_status
+ice_aq_get_link_topo_handle(struct ice_port_info *pi, u8 node_type,
+			    struct ice_sq_cd *cd)
+{
+	struct ice_aqc_get_link_topo *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.get_link_topo;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_link_topo);
+
+	cmd->addr.node_type_ctx = (ICE_AQC_LINK_TOPO_NODE_CTX_PORT <<
+				   ICE_AQC_LINK_TOPO_NODE_CTX_S);
+
+	/* set node type */
+	cmd->addr.node_type_ctx |= (ICE_AQC_LINK_TOPO_NODE_TYPE_M & node_type);
+
+	return ice_aq_send_cmd(pi->hw, &desc, NULL, 0, cd);
+}
+
+/**
+ * ice_is_media_cage_present
+ * @pi: port information structure
+ *
+ * Returns true if media cage is present, else false. If no cage, then
+ * media type is backplane or BASE-T.
+ */
+static bool ice_is_media_cage_present(struct ice_port_info *pi)
+{
+	/* Node type cage can be used to determine if cage is present. If AQC
+	 * returns error (ENOENT), then no cage present. If no cage present then
+	 * connection type is backplane or BASE-T.
+	 */
+	return !ice_aq_get_link_topo_handle(pi,
+					    ICE_AQC_LINK_TOPO_NODE_TYPE_CAGE,
+					    NULL);
+}
+
 /**
  * ice_get_media_type - Gets media type
  * @pi: port information structure
@@ -224,7 +274,6 @@ static enum ice_media_type ice_get_media_type(struct ice_port_info *pi)
 		case ICE_PHY_TYPE_LOW_10G_SFI_C2C:
 		case ICE_PHY_TYPE_LOW_25GBASE_SR:
 		case ICE_PHY_TYPE_LOW_25GBASE_LR:
-		case ICE_PHY_TYPE_LOW_25G_AUI_C2C:
 		case ICE_PHY_TYPE_LOW_40GBASE_SR4:
 		case ICE_PHY_TYPE_LOW_40GBASE_LR4:
 		case ICE_PHY_TYPE_LOW_50GBASE_SR2:
@@ -255,6 +304,16 @@ static enum ice_media_type ice_get_media_type(struct ice_port_info *pi)
 		case ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4:
 		case ICE_PHY_TYPE_LOW_100GBASE_CP2:
 			return ICE_MEDIA_DA;
+		case ICE_PHY_TYPE_LOW_25G_AUI_C2C:
+		case ICE_PHY_TYPE_LOW_40G_XLAUI:
+		case ICE_PHY_TYPE_LOW_50G_LAUI2:
+		case ICE_PHY_TYPE_LOW_50G_AUI2:
+		case ICE_PHY_TYPE_LOW_50G_AUI1:
+		case ICE_PHY_TYPE_LOW_100G_AUI4:
+		case ICE_PHY_TYPE_LOW_100G_CAUI4:
+			if (ice_is_media_cage_present(pi))
+				return ICE_MEDIA_DA;
+			fallthrough;
 		case ICE_PHY_TYPE_LOW_1000BASE_KX:
 		case ICE_PHY_TYPE_LOW_2500BASE_KX:
 		case ICE_PHY_TYPE_LOW_2500BASE_X:
@@ -272,6 +331,11 @@ static enum ice_media_type ice_get_media_type(struct ice_port_info *pi)
 		}
 	} else {
 		switch (hw_link_info->phy_type_high) {
+		case ICE_PHY_TYPE_HIGH_100G_AUI2:
+		case ICE_PHY_TYPE_HIGH_100G_CAUI2:
+			if (ice_is_media_cage_present(pi))
+				return ICE_MEDIA_DA;
+			fallthrough;
 		case ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4:
 			return ICE_MEDIA_BACKPLANE;
 		}
-- 
2.26.2

