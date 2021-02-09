Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E547314574
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBIBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:16:30 -0500
Received: from mga07.intel.com ([134.134.136.100]:36361 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhBIBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:16:28 -0500
IronPort-SDR: 0znHXAdWImvglNRTnHPOR25qOc8V9K/qDva74EVbVKyzVWqoPm932NRd65rXVdcb9JHXKoYVFv
 bt2eg98pmlwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245879730"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245879730"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:47 -0800
IronPort-SDR: 5I1aj2zDCvALQLDp/ZXILZnH4Hf0xbiqvmVDpyhYTS6OP7bw/ApG6+A8NMw5lTv7FveV+wsqEJ
 AjjCCbX527iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669592"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 02/12] ice: implement new LLDP filter command
Date:   Mon,  8 Feb 2021 17:16:26 -0800
Message-Id: <20210209011636.1989093-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

There is an issue with some NVMs where an already existent LLDP
filter is blocking the creation of a filter to allow LLDP packets
to be redirected to the default VSI for the interface.  This is
blocking all LLDP functionality based in the kernel when the FW
LLDP agent is disabled (e.g. software based DCBx).

Implement the new AQ command to allow adding VSI destinations to
existent filters on NVM versions that support the new command.

The new lldp_fltr_ctrl AQ command supports Rx filters only, so the
code flow for adding filters to disable Tx of control frames will
remain intact.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 12 +++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 47 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 10 ++--
 drivers/net/ethernet/intel/ice/ice_lib.c      | 13 +++--
 drivers/net/ethernet/intel/ice/ice_type.h     |  5 ++
 6 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index a51470b68d54..51a1af766e8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1528,6 +1528,16 @@ struct ice_aqc_lldp_stop_start_specific_agent {
 	u8 reserved[15];
 };
 
+/* LLDP Filter Control (direct 0x0A0A) */
+struct ice_aqc_lldp_filter_ctrl {
+	u8 cmd_flags;
+#define ICE_AQC_LLDP_FILTER_ACTION_ADD		0x0
+#define ICE_AQC_LLDP_FILTER_ACTION_DELETE	0x1
+	u8 reserved1;
+	__le16 vsi_num;
+	u8 reserved2[12];
+};
+
 /* Get/Set RSS key (indirect 0x0B04/0x0B02) */
 struct ice_aqc_get_set_rss_key {
 #define ICE_AQC_GSET_RSS_KEY_VSI_VALID	BIT(15)
@@ -1851,6 +1861,7 @@ struct ice_aq_desc {
 		struct ice_aqc_lldp_start lldp_start;
 		struct ice_aqc_lldp_set_local_mib lldp_set_mib;
 		struct ice_aqc_lldp_stop_start_specific_agent lldp_agent_ctrl;
+		struct ice_aqc_lldp_filter_ctrl lldp_filter_ctrl;
 		struct ice_aqc_get_set_rss_lut get_set_rss_lut;
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
 		struct ice_aqc_add_txqs add_txqs;
@@ -1991,6 +2002,7 @@ enum ice_adminq_opc {
 	ice_aqc_opc_get_cee_dcb_cfg			= 0x0A07,
 	ice_aqc_opc_lldp_set_local_mib			= 0x0A08,
 	ice_aqc_opc_lldp_stop_start_specific_agent	= 0x0A09,
+	ice_aqc_opc_lldp_filter_ctrl			= 0x0A0A,
 
 	/* RSS commands */
 	ice_aqc_opc_set_rss_key				= 0x0B02,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 607d33d05a0c..45d5445a0456 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4366,3 +4366,50 @@ ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 
 	return ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
 }
+
+/**
+ * ice_fw_supports_lldp_fltr - check NVM version supports lldp_fltr_ctrl
+ * @hw: pointer to HW struct
+ */
+bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw)
+{
+	if (hw->mac_type != ICE_MAC_E810)
+		return false;
+
+	if (hw->api_maj_ver == ICE_FW_API_LLDP_FLTR_MAJ) {
+		if (hw->api_min_ver > ICE_FW_API_LLDP_FLTR_MIN)
+			return true;
+		if (hw->api_min_ver == ICE_FW_API_LLDP_FLTR_MIN &&
+		    hw->api_patch >= ICE_FW_API_LLDP_FLTR_PATCH)
+			return true;
+	} else if (hw->api_maj_ver > ICE_FW_API_LLDP_FLTR_MAJ) {
+		return true;
+	}
+	return false;
+}
+
+/**
+ * ice_lldp_fltr_add_remove - add or remove a LLDP Rx switch filter
+ * @hw: pointer to HW struct
+ * @vsi_num: absolute HW index for VSI
+ * @add: boolean for if adding or removing a filter
+ */
+enum ice_status
+ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add)
+{
+	struct ice_aqc_lldp_filter_ctrl *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.lldp_filter_ctrl;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_lldp_filter_ctrl);
+
+	if (add)
+		cmd->cmd_flags = ICE_AQC_LLDP_FILTER_ACTION_ADD;
+	else
+		cmd->cmd_flags = ICE_AQC_LLDP_FILTER_ACTION_DELETE;
+
+	cmd->vsi_num = cpu_to_le16(vsi_num);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 3ebb973878c7..baf4064fcbfe 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -175,4 +175,7 @@ ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 enum ice_status
 ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 		    struct ice_sq_cd *cd);
+bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw);
+enum ice_status
+ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e01b7e34da5e..6db81579643f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1242,6 +1242,11 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			enum ice_status status;
 			bool dcbx_agent_status;
 
+			/* Remove rule to direct LLDP packets to default VSI.
+			 * The FW LLDP engine will now be consuming them.
+			 */
+			ice_cfg_sw_lldp(vsi, false, false);
+
 			/* AQ command to start FW LLDP agent will return an
 			 * error if the agent is already started
 			 */
@@ -1270,11 +1275,6 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			if (status)
 				dev_dbg(dev, "Fail to init DCB\n");
 
-			/* Remove rule to direct LLDP packets to default VSI.
-			 * The FW LLDP engine will now be consuming them.
-			 */
-			ice_cfg_sw_lldp(vsi, false, false);
-
 			/* Register for MIB change events */
 			status = ice_cfg_lldp_mib_change(&pf->hw, true);
 			if (status)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index ad9c22a1b97a..c486aeecdb2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2145,11 +2145,18 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
 	dev = ice_pf_to_dev(pf);
 	eth_fltr = create ? ice_fltr_add_eth : ice_fltr_remove_eth;
 
-	if (tx)
+	if (tx) {
 		status = eth_fltr(vsi, ETH_P_LLDP, ICE_FLTR_TX,
 				  ICE_DROP_PACKET);
-	else
-		status = eth_fltr(vsi, ETH_P_LLDP, ICE_FLTR_RX, ICE_FWD_TO_VSI);
+	} else {
+		if (ice_fw_supports_lldp_fltr_ctrl(&pf->hw)) {
+			status = ice_lldp_fltr_add_remove(&pf->hw, vsi->vsi_num,
+							  create);
+		} else {
+			status = eth_fltr(vsi, ETH_P_LLDP, ICE_FLTR_RX,
+					  ICE_FWD_TO_VSI);
+		}
+	}
 
 	if (status)
 		dev_err(dev, "Fail %s %s LLDP rule on VSI %i error: %s\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a98800a91045..3107b6945862 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -902,4 +902,9 @@ struct ice_hw_port_stats {
 /* Hash redirection LUT for VSI - maximum array size */
 #define ICE_VSIQF_HLUT_ARRAY_SIZE	((VSIQF_HLUT_MAX_INDEX + 1) * 4)
 
+/* AQ API version for LLDP_FILTER_CONTROL */
+#define ICE_FW_API_LLDP_FLTR_MAJ	1
+#define ICE_FW_API_LLDP_FLTR_MIN	7
+#define ICE_FW_API_LLDP_FLTR_PATCH	1
+
 #endif /* _ICE_TYPE_H_ */
-- 
2.26.2

