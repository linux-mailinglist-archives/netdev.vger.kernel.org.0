Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECCEF1F0E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbfKFTiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:38:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:25883 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732203AbfKFTiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:38:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 11:37:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="402473269"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 11:37:59 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 04/14] ice: handle DCBx non-contiguous TC request
Date:   Wed,  6 Nov 2019 11:37:46 -0800
Message-Id: <20191106193756.23819-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
References: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

If DCBx request non-contiguous TCs, then the driver will configure default
traffic class (TC0). This is done to prevent Tx hang since the driver
currently does not support non-contiguous TC.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 141 ++++++++++++++-----
 1 file changed, 102 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index dd47869c4ad4..13da89e22123 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -3,6 +3,8 @@
 
 #include "ice_dcb_lib.h"
 
+static void ice_pf_dcb_recfg(struct ice_pf *pf);
+
 /**
  * ice_vsi_cfg_netdev_tc - Setup the netdev TC configuration
  * @vsi: the VSI being configured
@@ -137,42 +139,6 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 	}
 }
 
-/**
- * ice_pf_dcb_recfg - Reconfigure all VEBs and VSIs
- * @pf: pointer to the PF struct
- *
- * Assumed caller has already disabled all VSIs before
- * calling this function. Reconfiguring DCB based on
- * local_dcbx_cfg.
- */
-static void ice_pf_dcb_recfg(struct ice_pf *pf)
-{
-	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
-	u8 tc_map = 0;
-	int v, ret;
-
-	/* Update each VSI */
-	ice_for_each_vsi(pf, v) {
-		if (!pf->vsi[v])
-			continue;
-
-		if (pf->vsi[v]->type == ICE_VSI_PF)
-			tc_map = ice_dcb_get_ena_tc(dcbcfg);
-		else
-			tc_map = ICE_DFLT_TRAFFIC_CLASS;
-
-		ret = ice_vsi_cfg_tc(pf->vsi[v], tc_map);
-		if (ret) {
-			dev_err(&pf->pdev->dev,
-				"Failed to config TC for VSI index: %d\n",
-				pf->vsi[v]->idx);
-			continue;
-		}
-
-		ice_vsi_map_rings_to_vectors(pf->vsi[v]);
-	}
-}
-
 /**
  * ice_pf_dcb_cfg - Apply new DCB configuration
  * @pf: pointer to the PF struct
@@ -437,9 +403,10 @@ static int ice_dcb_init_cfg(struct ice_pf *pf, bool locked)
 /**
  * ice_dcb_sw_default_config - Apply a default DCB config
  * @pf: PF to apply config to
+ * @ets_willing: configure ets willing
  * @locked: was this function called with RTNL held
  */
-static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
+static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool ets_willing, bool locked)
 {
 	struct ice_aqc_port_ets_elem buf = { 0 };
 	struct ice_dcbx_cfg *dcbcfg;
@@ -454,7 +421,7 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
 	memset(dcbcfg, 0, sizeof(*dcbcfg));
 	memset(&pi->local_dcbx_cfg, 0, sizeof(*dcbcfg));
 
-	dcbcfg->etscfg.willing = 1;
+	dcbcfg->etscfg.willing = ets_willing ? 1 : 0;
 	dcbcfg->etscfg.maxtcs = hw->func_caps.common_cap.maxtc;
 	dcbcfg->etscfg.tcbwtable[0] = 100;
 	dcbcfg->etscfg.tsatable[0] = ICE_IEEE_TSA_ETS;
@@ -479,6 +446,102 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
 	return ice_query_port_ets(pi, &buf, sizeof(buf), NULL);
 }
 
+/**
+ * ice_dcb_tc_contig - Check that TCs are contiguous
+ * @prio_table: pointer to priority table
+ *
+ * Check if TCs begin with TC0 and are contiguous
+ */
+static bool ice_dcb_tc_contig(u8 *prio_table)
+{
+	u8 max_tc = 0;
+	int i;
+
+	for (i = 0; i < CEE_DCBX_MAX_PRIO; i++) {
+		u8 cur_tc = prio_table[i];
+
+		if (cur_tc > max_tc)
+			return false;
+		else if (cur_tc == max_tc)
+			max_tc++;
+	}
+
+	return true;
+}
+
+/**
+ * ice_dcb_noncontig_cfg - Configure DCB for non-contiguous TCs
+ * @pf: pointer to the PF struct
+ *
+ * If non-contiguous TCs, then configure SW DCB with TC0 and ETS non-willing
+ */
+static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
+{
+	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
+	int ret;
+
+	/* Configure SW DCB default with ETS non-willing */
+	ret = ice_dcb_sw_dflt_cfg(pf, false, true);
+	if (ret) {
+		dev_err(&pf->pdev->dev,
+			"Failed to set local DCB config %d\n", ret);
+		return ret;
+	}
+
+	/* Reconfigure with ETS willing so that FW will send LLDP MIB event */
+	dcbcfg->etscfg.willing = 1;
+	ret = ice_set_dcb_cfg(pf->hw.port_info);
+	if (ret)
+		dev_err(&pf->pdev->dev, "Failed to set DCB to unwilling\n");
+
+	return ret;
+}
+
+/**
+ * ice_pf_dcb_recfg - Reconfigure all VEBs and VSIs
+ * @pf: pointer to the PF struct
+ *
+ * Assumed caller has already disabled all VSIs before
+ * calling this function. Reconfiguring DCB based on
+ * local_dcbx_cfg.
+ */
+static void ice_pf_dcb_recfg(struct ice_pf *pf)
+{
+	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
+	u8 tc_map = 0;
+	int v, ret;
+
+	/* Update each VSI */
+	ice_for_each_vsi(pf, v) {
+		if (!pf->vsi[v])
+			continue;
+
+		if (pf->vsi[v]->type == ICE_VSI_PF) {
+			tc_map = ice_dcb_get_ena_tc(dcbcfg);
+
+			/* If DCBX request non-contiguous TC, then configure
+			 * default TC
+			 */
+			if (!ice_dcb_tc_contig(dcbcfg->etscfg.prio_table)) {
+				tc_map = ICE_DFLT_TRAFFIC_CLASS;
+				ice_dcb_noncontig_cfg(pf);
+			}
+		} else {
+			tc_map = ICE_DFLT_TRAFFIC_CLASS;
+		}
+
+		ret = ice_vsi_cfg_tc(pf->vsi[v], tc_map);
+		if (ret) {
+			dev_err(&pf->pdev->dev,
+				"Failed to config TC for VSI index: %d\n",
+				pf->vsi[v]->idx);
+			continue;
+		}
+
+		ice_vsi_map_rings_to_vectors(pf->vsi[v]);
+	}
+}
+
 /**
  * ice_init_pf_dcb - initialize DCB for a PF
  * @pf: PF to initialize DCB for
@@ -507,7 +570,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		dev_info(&pf->pdev->dev,
 			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
 		clear_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
-		err = ice_dcb_sw_dflt_cfg(pf, locked);
+		err = ice_dcb_sw_dflt_cfg(pf, true, locked);
 		if (err) {
 			dev_err(&pf->pdev->dev,
 				"Failed to set local DCB config %d\n", err);
-- 
2.21.0

