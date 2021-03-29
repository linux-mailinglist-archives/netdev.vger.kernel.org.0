Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B4F34D8F1
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhC2USO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:19969 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhC2UR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:27 -0400
IronPort-SDR: j7TbWDHjOj/1noPpmoFZ4nDOexQ6vLm7Zy/VhhlR9I1d+evMGGqCsK5d0kSQ05ZCS0EUKdXjSU
 Ijki+kGE1aaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160817"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160817"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: gScNW1+OiVD/poxCio8GIHUJlmKUMneMW0+55XHR6+wVANUPWuaEs57rqPVd1qQB0gkcygRfJ5
 D/r7eDIkIPow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700540"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chinh T Cao <chinh.t.cao@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 3/9] ice: Recognize 860 as iSCSI port in CEE mode
Date:   Mon, 29 Mar 2021 13:18:51 -0700
Message-Id: <20210329201857.3509461-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chinh T Cao <chinh.t.cao@intel.com>

iSCSI can use both TCP ports 860 and 3260. However, in our current
implementation, the ice_aqc_opc_get_cee_dcb_cfg (0x0A07) AQ command
doesn't provide a way to communicate the protocol port number to the
AQ's caller. Thus, we assume that 3260 is the iSCSI port number at the
AQ's caller layer.

Rely on the dcbx-willing mode, desired QoS and remote QoS configuration to
determine which port number that iSCSI will use.

Fixes: 0ebd3ff13cca ("ice: Add code for DCB initialization part 2/4")
Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c  | 38 +++++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_type.h |  1 +
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index e42727941ef5..211ac6f907ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -738,22 +738,27 @@ ice_aq_get_cee_dcb_cfg(struct ice_hw *hw,
 /**
  * ice_cee_to_dcb_cfg
  * @cee_cfg: pointer to CEE configuration struct
- * @dcbcfg: DCB configuration struct
+ * @pi: port information structure
  *
  * Convert CEE configuration from firmware to DCB configuration
  */
 static void
 ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
-		   struct ice_dcbx_cfg *dcbcfg)
+		   struct ice_port_info *pi)
 {
 	u32 status, tlv_status = le32_to_cpu(cee_cfg->tlv_status);
 	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift;
+	u8 i, j, err, sync, oper, app_index, ice_app_sel_type;
 	u16 app_prio = le16_to_cpu(cee_cfg->oper_app_prio);
-	u8 i, err, sync, oper, app_index, ice_app_sel_type;
 	u16 ice_aqc_cee_app_mask, ice_aqc_cee_app_shift;
+	struct ice_dcbx_cfg *cmp_dcbcfg, *dcbcfg;
 	u16 ice_app_prot_id_type;
 
-	/* CEE PG data to ETS config */
+	dcbcfg = &pi->qos_cfg.local_dcbx_cfg;
+	dcbcfg->dcbx_mode = ICE_DCBX_MODE_CEE;
+	dcbcfg->tlv_status = tlv_status;
+
+	/* CEE PG data */
 	dcbcfg->etscfg.maxtcs = cee_cfg->oper_num_tc;
 
 	/* Note that the FW creates the oper_prio_tc nibbles reversed
@@ -780,10 +785,16 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 		}
 	}
 
-	/* CEE PFC data to ETS config */
+	/* CEE PFC data */
 	dcbcfg->pfc.pfcena = cee_cfg->oper_pfc_en;
 	dcbcfg->pfc.pfccap = ICE_MAX_TRAFFIC_CLASS;
 
+	/* CEE APP TLV data */
+	if (dcbcfg->app_mode == ICE_DCBX_APPS_NON_WILLING)
+		cmp_dcbcfg = &pi->qos_cfg.desired_dcbx_cfg;
+	else
+		cmp_dcbcfg = &pi->qos_cfg.remote_dcbx_cfg;
+
 	app_index = 0;
 	for (i = 0; i < 3; i++) {
 		if (i == 0) {
@@ -802,6 +813,18 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 			ice_aqc_cee_app_shift = ICE_AQC_CEE_APP_ISCSI_S;
 			ice_app_sel_type = ICE_APP_SEL_TCPIP;
 			ice_app_prot_id_type = ICE_APP_PROT_ID_ISCSI;
+
+			for (j = 0; j < cmp_dcbcfg->numapps; j++) {
+				u16 prot_id = cmp_dcbcfg->app[j].prot_id;
+				u8 sel = cmp_dcbcfg->app[j].selector;
+
+				if  (sel == ICE_APP_SEL_TCPIP &&
+				     (prot_id == ICE_APP_PROT_ID_ISCSI ||
+				      prot_id == ICE_APP_PROT_ID_ISCSI_860)) {
+					ice_app_prot_id_type = prot_id;
+					break;
+				}
+			}
 		} else {
 			/* FIP APP */
 			ice_aqc_cee_status_mask = ICE_AQC_CEE_FIP_STATUS_M;
@@ -892,11 +915,8 @@ enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi)
 	ret = ice_aq_get_cee_dcb_cfg(pi->hw, &cee_cfg, NULL);
 	if (!ret) {
 		/* CEE mode */
-		dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
-		dcbx_cfg->dcbx_mode = ICE_DCBX_MODE_CEE;
-		dcbx_cfg->tlv_status = le32_to_cpu(cee_cfg.tlv_status);
-		ice_cee_to_dcb_cfg(&cee_cfg, dcbx_cfg);
 		ret = ice_get_ieee_or_cee_dcb_cfg(pi, ICE_DCBX_MODE_CEE);
+		ice_cee_to_dcb_cfg(&cee_cfg, pi);
 	} else if (pi->hw->adminq.sq_last_status == ICE_AQ_RC_ENOENT) {
 		/* CEE mode not enabled try querying IEEE data */
 		dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a6cb0c35748c..266036b7a49a 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -535,6 +535,7 @@ struct ice_dcb_app_priority_table {
 #define ICE_TLV_STATUS_ERR	0x4
 #define ICE_APP_PROT_ID_FCOE	0x8906
 #define ICE_APP_PROT_ID_ISCSI	0x0cbc
+#define ICE_APP_PROT_ID_ISCSI_860 0x035c
 #define ICE_APP_PROT_ID_FIP	0x8914
 #define ICE_APP_SEL_ETHTYPE	0x1
 #define ICE_APP_SEL_TCPIP	0x2
-- 
2.26.2

