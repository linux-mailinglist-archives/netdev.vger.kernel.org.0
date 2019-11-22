Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC6107A98
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfKVW3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:29:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:7936 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKVW3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:29:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409027361"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:29:10 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 10/15] ice: Add ice_pf_to_dev(pf) macro
Date:   Fri, 22 Nov 2019 14:29:00 -0800
Message-Id: <20191122222905.670858-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
References: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

We use &pf->dev->pdev all over the code. Add a simple
macro to do this for us. When multiple de-references
like this are being done add a local struct device
variable.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 drivers/net/ethernet/intel/ice/ice_base.c     |  22 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 112 +++++-----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  14 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  57 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 155 ++++++++------
 drivers/net/ethernet/intel/ice/ice_main.c     | 171 ++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 191 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   4 +-
 10 files changed, 389 insertions(+), 341 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8d7e8fc55585..cb7259c27353 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -130,6 +130,8 @@ extern const char ice_drv_ver[];
 				     ICE_PROMISC_VLAN_TX  | \
 				     ICE_PROMISC_VLAN_RX)
 
+#define ice_pf_to_dev(pf) (&((pf)->pdev->dev))
+
 struct ice_txq_meta {
 	u32 q_teid;	/* Tx-scheduler element identifier */
 	u16 q_id;	/* Entry in VSI's txq_map bitmap */
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 69d2da14fe5c..77d6a0291e97 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -101,7 +101,8 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, int v_idx)
 	struct ice_q_vector *q_vector;
 
 	/* allocate q_vector */
-	q_vector = devm_kzalloc(&pf->pdev->dev, sizeof(*q_vector), GFP_KERNEL);
+	q_vector = devm_kzalloc(ice_pf_to_dev(pf), sizeof(*q_vector),
+				GFP_KERNEL);
 	if (!q_vector)
 		return -ENOMEM;
 
@@ -138,10 +139,11 @@ static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
 	struct ice_q_vector *q_vector;
 	struct ice_pf *pf = vsi->back;
 	struct ice_ring *ring;
+	struct device *dev;
 
+	dev = ice_pf_to_dev(pf);
 	if (!vsi->q_vectors[v_idx]) {
-		dev_dbg(&pf->pdev->dev, "Queue vector at index %d not found\n",
-			v_idx);
+		dev_dbg(dev, "Queue vector at index %d not found\n", v_idx);
 		return;
 	}
 	q_vector = vsi->q_vectors[v_idx];
@@ -155,7 +157,7 @@ static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
 	if (vsi->netdev)
 		netif_napi_del(&q_vector->napi);
 
-	devm_kfree(&pf->pdev->dev, q_vector);
+	devm_kfree(dev, q_vector);
 	vsi->q_vectors[v_idx] = NULL;
 }
 
@@ -482,7 +484,7 @@ int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
 	/* wait for the change to finish */
 	ret = ice_pf_rxq_wait(pf, pf_q, ena);
 	if (ret)
-		dev_err(&pf->pdev->dev,
+		dev_err(ice_pf_to_dev(pf),
 			"VSI idx %d Rx ring %d %sable timeout\n",
 			vsi->idx, pf_q, (ena ? "en" : "dis"));
 
@@ -500,11 +502,12 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	int v_idx = 0, num_q_vectors;
+	struct device *dev;
 	int err;
 
+	dev = ice_pf_to_dev(pf);
 	if (vsi->q_vectors[0]) {
-		dev_dbg(&pf->pdev->dev, "VSI %d has existing q_vectors\n",
-			vsi->vsi_num);
+		dev_dbg(dev, "VSI %d has existing q_vectors\n", vsi->vsi_num);
 		return -EEXIST;
 	}
 
@@ -522,8 +525,7 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 	while (v_idx--)
 		ice_free_q_vector(vsi, v_idx);
 
-	dev_err(&pf->pdev->dev,
-		"Failed to allocate %d q_vector for VSI %d, ret=%d\n",
+	dev_err(dev, "Failed to allocate %d q_vector for VSI %d, ret=%d\n",
 		vsi->num_q_vectors, vsi->vsi_num, err);
 	vsi->num_q_vectors = 0;
 	return err;
@@ -640,7 +642,7 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc, ring->q_handle,
 				 1, qg_buf, buf_len, NULL);
 	if (status) {
-		dev_err(&pf->pdev->dev,
+		dev_err(ice_pf_to_dev(pf),
 			"Failed to set LAN Tx queue context, error: %d\n",
 			status);
 		return -ENODEV;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 06736709968e..20b63443237c 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -160,6 +160,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 {
 	struct ice_aqc_port_ets_elem buf = { 0 };
 	struct ice_dcbx_cfg *old_cfg, *curr_cfg;
+	struct device *dev = ice_pf_to_dev(pf);
 	int ret = ICE_DCB_NO_HW_CHG;
 	struct ice_vsi *pf_vsi;
 
@@ -171,15 +172,15 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 
 	/* Enable DCB tagging only when more than one TC */
 	if (ice_dcb_get_num_tc(new_cfg) > 1) {
-		dev_dbg(&pf->pdev->dev, "DCB tagging enabled (num TC > 1)\n");
+		dev_dbg(dev, "DCB tagging enabled (num TC > 1)\n");
 		set_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	} else {
-		dev_dbg(&pf->pdev->dev, "DCB tagging disabled (num TC = 1)\n");
+		dev_dbg(dev, "DCB tagging disabled (num TC = 1)\n");
 		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	}
 
 	if (!memcmp(new_cfg, curr_cfg, sizeof(*new_cfg))) {
-		dev_dbg(&pf->pdev->dev, "No change in DCB config required\n");
+		dev_dbg(dev, "No change in DCB config required\n");
 		return ret;
 	}
 
@@ -188,10 +189,10 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	if (!old_cfg)
 		return -ENOMEM;
 
-	dev_info(&pf->pdev->dev, "Commit DCB Configuration to the hardware\n");
+	dev_info(dev, "Commit DCB Configuration to the hardware\n");
 	pf_vsi = ice_get_main_vsi(pf);
 	if (!pf_vsi) {
-		dev_dbg(&pf->pdev->dev, "PF VSI doesn't exist\n");
+		dev_dbg(dev, "PF VSI doesn't exist\n");
 		ret = -EINVAL;
 		goto free_cfg;
 	}
@@ -213,7 +214,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	if (pf->hw.port_info->is_sw_lldp) {
 		ret = ice_set_dcb_cfg(pf->hw.port_info);
 		if (ret) {
-			dev_err(&pf->pdev->dev, "Set DCB Config failed\n");
+			dev_err(dev, "Set DCB Config failed\n");
 			/* Restore previous settings to local config */
 			memcpy(curr_cfg, old_cfg, sizeof(*curr_cfg));
 			goto out;
@@ -222,7 +223,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Query Port ETS failed\n");
+		dev_err(dev, "Query Port ETS failed\n");
 		goto out;
 	}
 
@@ -269,6 +270,7 @@ static bool
 ice_dcb_need_recfg(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
 		   struct ice_dcbx_cfg *new_cfg)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	bool need_reconfig = false;
 
 	/* Check if ETS configuration has changed */
@@ -279,33 +281,33 @@ ice_dcb_need_recfg(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
 			   &old_cfg->etscfg.prio_table,
 			   sizeof(new_cfg->etscfg.prio_table))) {
 			need_reconfig = true;
-			dev_dbg(&pf->pdev->dev, "ETS UP2TC changed.\n");
+			dev_dbg(dev, "ETS UP2TC changed.\n");
 		}
 
 		if (memcmp(&new_cfg->etscfg.tcbwtable,
 			   &old_cfg->etscfg.tcbwtable,
 			   sizeof(new_cfg->etscfg.tcbwtable)))
-			dev_dbg(&pf->pdev->dev, "ETS TC BW Table changed.\n");
+			dev_dbg(dev, "ETS TC BW Table changed.\n");
 
 		if (memcmp(&new_cfg->etscfg.tsatable,
 			   &old_cfg->etscfg.tsatable,
 			   sizeof(new_cfg->etscfg.tsatable)))
-			dev_dbg(&pf->pdev->dev, "ETS TSA Table changed.\n");
+			dev_dbg(dev, "ETS TSA Table changed.\n");
 	}
 
 	/* Check if PFC configuration has changed */
 	if (memcmp(&new_cfg->pfc, &old_cfg->pfc, sizeof(new_cfg->pfc))) {
 		need_reconfig = true;
-		dev_dbg(&pf->pdev->dev, "PFC config change detected.\n");
+		dev_dbg(dev, "PFC config change detected.\n");
 	}
 
 	/* Check if APP Table has changed */
 	if (memcmp(&new_cfg->app, &old_cfg->app, sizeof(new_cfg->app))) {
 		need_reconfig = true;
-		dev_dbg(&pf->pdev->dev, "APP Table change detected.\n");
+		dev_dbg(dev, "APP Table change detected.\n");
 	}
 
-	dev_dbg(&pf->pdev->dev, "dcb need_reconfig=%d\n", need_reconfig);
+	dev_dbg(dev, "dcb need_reconfig=%d\n", need_reconfig);
 	return need_reconfig;
 }
 
@@ -317,11 +319,12 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *local_dcbx_cfg, *desired_dcbx_cfg, *prev_cfg;
 	struct ice_aqc_port_ets_elem buf = { 0 };
+	struct device *dev = ice_pf_to_dev(pf);
 	enum ice_status ret;
 
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Query Port ETS failed\n");
+		dev_err(dev, "Query Port ETS failed\n");
 		goto dcb_error;
 	}
 
@@ -340,16 +343,14 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	ice_cfg_etsrec_defaults(pf->hw.port_info);
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Failed to set DCB to unwilling\n");
+		dev_err(dev, "Failed to set DCB to unwilling\n");
 		goto dcb_error;
 	}
 
 	/* Retrieve DCB config and ensure same as current in SW */
 	prev_cfg = kmemdup(local_dcbx_cfg, sizeof(*prev_cfg), GFP_KERNEL);
-	if (!prev_cfg) {
-		dev_err(&pf->pdev->dev, "Failed to alloc space for DCB cfg\n");
+	if (!prev_cfg)
 		goto dcb_error;
-	}
 
 	ice_init_dcb(&pf->hw, true);
 	if (pf->hw.port_info->dcbx_status == ICE_DCBX_STATUS_DIS)
@@ -359,7 +360,7 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 
 	if (ice_dcb_need_recfg(pf, prev_cfg, local_dcbx_cfg)) {
 		/* difference in cfg detected - disable DCB till next MIB */
-		dev_err(&pf->pdev->dev, "Set local MIB not accurate\n");
+		dev_err(dev, "Set local MIB not accurate\n");
 		kfree(prev_cfg);
 		goto dcb_error;
 	}
@@ -375,20 +376,20 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	ice_cfg_etsrec_defaults(pf->hw.port_info);
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Failed to set desired config\n");
+		dev_err(dev, "Failed to set desired config\n");
 		goto dcb_error;
 	}
-	dev_info(&pf->pdev->dev, "DCB restored after reset\n");
+	dev_info(dev, "DCB restored after reset\n");
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Query Port ETS failed\n");
+		dev_err(dev, "Query Port ETS failed\n");
 		goto dcb_error;
 	}
 
 	return;
 
 dcb_error:
-	dev_err(&pf->pdev->dev, "Disabling DCB until new settings occur\n");
+	dev_err(dev, "Disabling DCB until new settings occur\n");
 	prev_cfg = kzalloc(sizeof(*prev_cfg), GFP_KERNEL);
 	if (!prev_cfg)
 		return;
@@ -419,7 +420,7 @@ static int ice_dcb_init_cfg(struct ice_pf *pf, bool locked)
 
 	memset(&pi->local_dcbx_cfg, 0, sizeof(*newcfg));
 
-	dev_info(&pf->pdev->dev, "Configuring initial DCB values\n");
+	dev_info(ice_pf_to_dev(pf), "Configuring initial DCB values\n");
 	if (ice_pf_dcb_cfg(pf, newcfg, locked))
 		ret = -EINVAL;
 
@@ -507,13 +508,13 @@ static bool ice_dcb_tc_contig(u8 *prio_table)
 static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
+	struct device *dev = ice_pf_to_dev(pf);
 	int ret;
 
 	/* Configure SW DCB default with ETS non-willing */
 	ret = ice_dcb_sw_dflt_cfg(pf, false, true);
 	if (ret) {
-		dev_err(&pf->pdev->dev,
-			"Failed to set local DCB config %d\n", ret);
+		dev_err(dev, "Failed to set local DCB config %d\n", ret);
 		return ret;
 	}
 
@@ -521,7 +522,7 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 	dcbcfg->etscfg.willing = 1;
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret)
-		dev_err(&pf->pdev->dev, "Failed to set DCB to unwilling\n");
+		dev_err(dev, "Failed to set DCB to unwilling\n");
 
 	return ret;
 }
@@ -542,10 +543,12 @@ static void ice_pf_dcb_recfg(struct ice_pf *pf)
 
 	/* Update each VSI */
 	ice_for_each_vsi(pf, v) {
-		if (!pf->vsi[v])
+		struct ice_vsi *vsi = pf->vsi[v];
+
+		if (!vsi)
 			continue;
 
-		if (pf->vsi[v]->type == ICE_VSI_PF) {
+		if (vsi->type == ICE_VSI_PF) {
 			tc_map = ice_dcb_get_ena_tc(dcbcfg);
 
 			/* If DCBX request non-contiguous TC, then configure
@@ -559,17 +562,16 @@ static void ice_pf_dcb_recfg(struct ice_pf *pf)
 			tc_map = ICE_DFLT_TRAFFIC_CLASS;
 		}
 
-		ret = ice_vsi_cfg_tc(pf->vsi[v], tc_map);
+		ret = ice_vsi_cfg_tc(vsi, tc_map);
 		if (ret) {
-			dev_err(&pf->pdev->dev,
-				"Failed to config TC for VSI index: %d\n",
-				pf->vsi[v]->idx);
+			dev_err(ice_pf_to_dev(pf), "Failed to config TC for VSI index: %d\n",
+				vsi->idx);
 			continue;
 		}
 
-		ice_vsi_map_rings_to_vectors(pf->vsi[v]);
-		if (pf->vsi[v]->type == ICE_VSI_PF)
-			ice_dcbnl_set_all(pf->vsi[v]);
+		ice_vsi_map_rings_to_vectors(vsi);
+		if (vsi->type == ICE_VSI_PF)
+			ice_dcbnl_set_all(vsi);
 	}
 }
 
@@ -580,7 +582,7 @@ static void ice_pf_dcb_recfg(struct ice_pf *pf)
  */
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 {
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_port_info *port_info;
 	struct ice_hw *hw = &pf->hw;
 	int err;
@@ -589,23 +591,22 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 
 	err = ice_init_dcb(hw, false);
 	if (err && !port_info->is_sw_lldp) {
-		dev_err(&pf->pdev->dev, "Error initializing DCB %d\n", err);
+		dev_err(dev, "Error initializing DCB %d\n", err);
 		goto dcb_init_err;
 	}
 
-	dev_info(&pf->pdev->dev,
+	dev_info(dev,
 		 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
 		 pf->hw.func_caps.common_cap.maxtc);
 	if (err) {
 		struct ice_vsi *pf_vsi;
 
 		/* FW LLDP is disabled, activate SW DCBX/LLDP mode */
-		dev_info(&pf->pdev->dev,
-			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
+		dev_info(dev, "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
 		clear_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 		err = ice_dcb_sw_dflt_cfg(pf, true, locked);
 		if (err) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"Failed to set local DCB config %d\n", err);
 			err = -EIO;
 			goto dcb_init_err;
@@ -616,8 +617,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		 */
 		pf_vsi = ice_get_main_vsi(pf);
 		if (!pf_vsi) {
-			dev_err(&pf->pdev->dev,
-				"Failed to set local DCB config\n");
+			dev_err(dev, "Failed to set local DCB config\n");
 			err = -EIO;
 			goto dcb_init_err;
 		}
@@ -732,6 +732,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event)
 {
 	struct ice_aqc_port_ets_elem buf = { 0 };
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_aqc_lldp_get_mib *mib;
 	struct ice_dcbx_cfg tmp_dcbx_cfg;
 	bool need_reconfig = false;
@@ -745,8 +746,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 		return;
 
 	if (pf->dcbx_cap & DCB_CAP_DCBX_HOST) {
-		dev_dbg(&pf->pdev->dev,
-			"MIB Change Event in HOST mode\n");
+		dev_dbg(dev, "MIB Change Event in HOST mode\n");
 		return;
 	}
 
@@ -755,21 +755,20 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	/* Ignore if event is not for Nearest Bridge */
 	type = ((mib->type >> ICE_AQ_LLDP_BRID_TYPE_S) &
 		ICE_AQ_LLDP_BRID_TYPE_M);
-	dev_dbg(&pf->pdev->dev, "LLDP event MIB bridge type 0x%x\n", type);
+	dev_dbg(dev, "LLDP event MIB bridge type 0x%x\n", type);
 	if (type != ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID)
 		return;
 
 	/* Check MIB Type and return if event for Remote MIB update */
 	type = mib->type & ICE_AQ_LLDP_MIB_TYPE_M;
-	dev_dbg(&pf->pdev->dev,
-		"LLDP event mib type %s\n", type ? "remote" : "local");
+	dev_dbg(dev, "LLDP event mib type %s\n", type ? "remote" : "local");
 	if (type == ICE_AQ_LLDP_MIB_REMOTE) {
 		/* Update the remote cached instance and return */
 		ret = ice_aq_get_dcb_cfg(pi->hw, ICE_AQ_LLDP_MIB_REMOTE,
 					 ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID,
 					 &pi->remote_dcbx_cfg);
 		if (ret) {
-			dev_err(&pf->pdev->dev, "Failed to get remote DCB config\n");
+			dev_err(dev, "Failed to get remote DCB config\n");
 			return;
 		}
 	}
@@ -783,14 +782,13 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	/* Get updated DCBX data from firmware */
 	ret = ice_get_dcb_cfg(pf->hw.port_info);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Failed to get DCB config\n");
+		dev_err(dev, "Failed to get DCB config\n");
 		return;
 	}
 
 	/* No change detected in DCBX configs */
 	if (!memcmp(&tmp_dcbx_cfg, &pi->local_dcbx_cfg, sizeof(tmp_dcbx_cfg))) {
-		dev_dbg(&pf->pdev->dev,
-			"No change detected in DCBX configuration.\n");
+		dev_dbg(dev, "No change detected in DCBX configuration.\n");
 		return;
 	}
 
@@ -802,16 +800,16 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 
 	/* Enable DCB tagging only when more than one TC */
 	if (ice_dcb_get_num_tc(&pi->local_dcbx_cfg) > 1) {
-		dev_dbg(&pf->pdev->dev, "DCB tagging enabled (num TC > 1)\n");
+		dev_dbg(dev, "DCB tagging enabled (num TC > 1)\n");
 		set_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	} else {
-		dev_dbg(&pf->pdev->dev, "DCB tagging disabled (num TC = 1)\n");
+		dev_dbg(dev, "DCB tagging disabled (num TC = 1)\n");
 		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
 	}
 
 	pf_vsi = ice_get_main_vsi(pf);
 	if (!pf_vsi) {
-		dev_dbg(&pf->pdev->dev, "PF VSI doesn't exist\n");
+		dev_dbg(dev, "PF VSI doesn't exist\n");
 		return;
 	}
 
@@ -820,7 +818,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Query Port ETS failed\n");
+		dev_err(dev, "Query Port ETS failed\n");
 		rtnl_unlock();
 		return;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index e90e25b7da77..c81d7f69d5c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -58,7 +58,7 @@ ice_dcb_get_tc(struct ice_vsi __always_unused *vsi,
 static inline int
 ice_init_pf_dcb(struct ice_pf *pf, bool __always_unused locked)
 {
-	dev_dbg(&pf->pdev->dev, "DCB not supported\n");
+	dev_dbg(ice_pf_to_dev(pf), "DCB not supported\n");
 	return -EOPNOTSUPP;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 3c90fc0a3feb..d870c1aedc17 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -179,7 +179,7 @@ static u8 ice_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
 	else
 		pf->hw.port_info->local_dcbx_cfg.dcbx_mode = ICE_DCBX_MODE_IEEE;
 
-	dev_info(&pf->pdev->dev, "DCBx mode = 0x%x\n", mode);
+	dev_info(ice_pf_to_dev(pf), "DCBx mode = 0x%x\n", mode);
 	return ICE_DCB_HW_CHG_RST;
 }
 
@@ -297,7 +297,7 @@ ice_dcbnl_get_pfc_cfg(struct net_device *netdev, int prio, u8 *setting)
 		return;
 
 	*setting = (pi->local_dcbx_cfg.pfc.pfcena >> prio) & 0x1;
-	dev_dbg(&pf->pdev->dev,
+	dev_dbg(ice_pf_to_dev(pf),
 		"Get PFC Config up=%d, setting=%d, pfcenable=0x%x\n",
 		prio, *setting, pi->local_dcbx_cfg.pfc.pfcena);
 }
@@ -328,7 +328,7 @@ static void ice_dcbnl_set_pfc_cfg(struct net_device *netdev, int prio, u8 set)
 	else
 		new_cfg->pfc.pfcena &= ~BIT(prio);
 
-	dev_dbg(&pf->pdev->dev, "Set PFC config UP:%d set:%d pfcena:0x%x\n",
+	dev_dbg(ice_pf_to_dev(pf), "Set PFC config UP:%d set:%d pfcena:0x%x\n",
 		prio, set, new_cfg->pfc.pfcena);
 }
 
@@ -359,7 +359,7 @@ static u8 ice_dcbnl_getstate(struct net_device *netdev)
 
 	state = test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 
-	dev_dbg(&pf->pdev->dev, "DCB enabled state = %d\n", state);
+	dev_dbg(ice_pf_to_dev(pf), "DCB enabled state = %d\n", state);
 	return state;
 }
 
@@ -418,7 +418,7 @@ ice_dcbnl_get_pg_tc_cfg_tx(struct net_device *netdev, int prio,
 		return;
 
 	*pgid = pi->local_dcbx_cfg.etscfg.prio_table[prio];
-	dev_dbg(&pf->pdev->dev,
+	dev_dbg(ice_pf_to_dev(pf),
 		"Get PG config prio=%d tc=%d\n", prio, *pgid);
 }
 
@@ -479,7 +479,7 @@ ice_dcbnl_get_pg_bwg_cfg_tx(struct net_device *netdev, int pgid, u8 *bw_pct)
 		return;
 
 	*bw_pct = pi->local_dcbx_cfg.etscfg.tcbwtable[pgid];
-	dev_dbg(&pf->pdev->dev, "Get PG BW config tc=%d bw_pct=%d\n",
+	dev_dbg(ice_pf_to_dev(pf), "Get PG BW config tc=%d bw_pct=%d\n",
 		pgid, *bw_pct);
 }
 
@@ -597,7 +597,7 @@ static u8 ice_dcbnl_get_cap(struct net_device *netdev, int capid, u8 *cap)
 		break;
 	}
 
-	dev_dbg(&pf->pdev->dev, "DCBX Get Capability cap=%d capval=0x%x\n",
+	dev_dbg(ice_pf_to_dev(pf), "DCBX Get Capability cap=%d capval=0x%x\n",
 		capid, *cap);
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 0ee78fd1bdfb..5b229f3703b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -248,7 +248,7 @@ ice_get_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
 	int ret = 0;
 	u16 *buf;
 
-	dev = &pf->pdev->dev;
+	dev = ice_pf_to_dev(pf);
 
 	eeprom->magic = hw->vendor_id | (hw->device_id << 16);
 
@@ -343,6 +343,7 @@ static u64 ice_eeprom_test(struct net_device *netdev)
 static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
 {
 	struct ice_pf *pf = (struct ice_pf *)hw->back;
+	struct device *dev = ice_pf_to_dev(pf);
 	static const u32 patterns[] = {
 		0x5A5A5A5A, 0xA5A5A5A5,
 		0x00000000, 0xFFFFFFFF
@@ -358,7 +359,7 @@ static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
 		val = rd32(hw, reg);
 		if (val == pattern)
 			continue;
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"%s: reg pattern test failed - reg 0x%08x pat 0x%08x val 0x%08x\n"
 			, __func__, reg, pattern, val);
 		return 1;
@@ -367,7 +368,7 @@ static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
 	wr32(hw, reg, orig_val);
 	val = rd32(hw, reg);
 	if (val != orig_val) {
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"%s: reg restore test failed - reg 0x%08x orig 0x%08x val 0x%08x\n"
 			, __func__, reg, orig_val, val);
 		return 1;
@@ -507,7 +508,7 @@ static int ice_lbtest_create_frame(struct ice_pf *pf, u8 **ret_data, u16 size)
 	if (!pf)
 		return -EINVAL;
 
-	data = devm_kzalloc(&pf->pdev->dev, size, GFP_KERNEL);
+	data = devm_kzalloc(ice_pf_to_dev(pf), size, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -649,9 +650,11 @@ static u64 ice_loopback_test(struct net_device *netdev)
 	u8 broadcast[ETH_ALEN], ret = 0;
 	int num_frames, valid_frames;
 	LIST_HEAD(tmp_list);
+	struct device *dev;
 	u8 *tx_frame;
 	int i;
 
+	dev = ice_pf_to_dev(pf);
 	netdev_info(netdev, "loopback test\n");
 
 	test_vsi = ice_lb_vsi_setup(pf, pf->hw.port_info);
@@ -712,12 +715,12 @@ static u64 ice_loopback_test(struct net_device *netdev)
 		ret = 10;
 
 lbtest_free_frame:
-	devm_kfree(&pf->pdev->dev, tx_frame);
+	devm_kfree(dev, tx_frame);
 remove_mac_filters:
 	if (ice_remove_mac(&pf->hw, &tmp_list))
 		netdev_err(netdev, "Could not remove MAC filter for the test VSI");
 free_mac_list:
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_list);
+	ice_free_fltr_list(dev, &tmp_list);
 lbtest_mac_dis:
 	/* Disable MAC loopback after the test is completed. */
 	if (ice_aq_set_mac_loopback(&pf->hw, false, NULL))
@@ -774,6 +777,9 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	bool if_running = netif_running(netdev);
 	struct ice_pf *pf = np->vsi->back;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
 
 	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
 		netdev_info(netdev, "offline testing starting\n");
@@ -781,7 +787,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 		set_bit(__ICE_TESTING, pf->state);
 
 		if (ice_active_vfs(pf)) {
-			dev_warn(&pf->pdev->dev,
+			dev_warn(dev,
 				 "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
 			data[ICE_ETH_TEST_REG] = 1;
 			data[ICE_ETH_TEST_EEPROM] = 1;
@@ -816,8 +822,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 			int status = ice_open(netdev);
 
 			if (status) {
-				dev_err(&pf->pdev->dev,
-					"Could not open device %s, err %d",
+				dev_err(dev, "Could not open device %s, err %d",
 					pf->int_name, status);
 			}
 		}
@@ -1155,12 +1160,14 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 	DECLARE_BITMAP(orig_flags, ICE_PF_FLAGS_NBITS);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
 	int ret = 0;
 	u32 i;
 
 	if (flags > BIT(ICE_PRIV_FLAG_ARRAY_SIZE))
 		return -EINVAL;
 
+	dev = ice_pf_to_dev(pf);
 	set_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
 
 	bitmap_copy(orig_flags, pf->flags, ICE_PF_FLAGS_NBITS);
@@ -1189,7 +1196,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 * events to respond to.
 			 */
 			if (status)
-				dev_info(&pf->pdev->dev,
+				dev_info(dev,
 					 "Failed to unreg for LLDP events\n");
 
 			/* The AQ call to stop the FW LLDP agent will generate
@@ -1197,15 +1204,14 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 */
 			status = ice_aq_stop_lldp(&pf->hw, true, true, NULL);
 			if (status)
-				dev_warn(&pf->pdev->dev,
-					 "Fail to stop LLDP agent\n");
+				dev_warn(dev, "Fail to stop LLDP agent\n");
 			/* Use case for having the FW LLDP agent stopped
 			 * will likely not need DCB, so failure to init is
 			 * not a concern of ethtool
 			 */
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
-				dev_warn(&pf->pdev->dev, "Fail to init DCB\n");
+				dev_warn(dev, "Fail to init DCB\n");
 		} else {
 			enum ice_status status;
 			bool dcbx_agent_status;
@@ -1215,8 +1221,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 */
 			status = ice_aq_start_lldp(&pf->hw, true, NULL);
 			if (status)
-				dev_warn(&pf->pdev->dev,
-					 "Fail to start LLDP Agent\n");
+				dev_warn(dev, "Fail to start LLDP Agent\n");
 
 			/* AQ command to start FW DCBX agent will fail if
 			 * the agent is already started
@@ -1225,10 +1230,9 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 							&dcbx_agent_status,
 							NULL);
 			if (status)
-				dev_dbg(&pf->pdev->dev,
-					"Failed to start FW DCBX\n");
+				dev_dbg(dev, "Failed to start FW DCBX\n");
 
-			dev_info(&pf->pdev->dev, "FW DCBX agent is %s\n",
+			dev_info(dev, "FW DCBX agent is %s\n",
 				 dcbx_agent_status ? "ACTIVE" : "DISABLED");
 
 			/* Failure to configure MIB change or init DCB is not
@@ -1238,7 +1242,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 */
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
-				dev_dbg(&pf->pdev->dev, "Fail to init DCB\n");
+				dev_dbg(dev, "Fail to init DCB\n");
 
 			/* Remove rule to direct LLDP packets to default VSI.
 			 * The FW LLDP engine will now be consuming them.
@@ -1248,7 +1252,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			/* Register for MIB change events */
 			status = ice_cfg_lldp_mib_change(&pf->hw, true);
 			if (status)
-				dev_dbg(&pf->pdev->dev,
+				dev_dbg(dev,
 					"Fail to enable MIB change events\n");
 		}
 	}
@@ -3089,8 +3093,10 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
 	u8 *seed = NULL;
 
+	dev = ice_pf_to_dev(pf);
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
@@ -3103,8 +3109,7 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 	if (key) {
 		if (!vsi->rss_hkey_user) {
 			vsi->rss_hkey_user =
-				devm_kzalloc(&pf->pdev->dev,
-					     ICE_VSIQF_HKEY_ARRAY_SIZE,
+				devm_kzalloc(dev, ICE_VSIQF_HKEY_ARRAY_SIZE,
 					     GFP_KERNEL);
 			if (!vsi->rss_hkey_user)
 				return -ENOMEM;
@@ -3114,8 +3119,7 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 	}
 
 	if (!vsi->rss_lut_user) {
-		vsi->rss_lut_user = devm_kzalloc(&pf->pdev->dev,
-						 vsi->rss_table_size,
+		vsi->rss_lut_user = devm_kzalloc(dev, vsi->rss_table_size,
 						 GFP_KERNEL);
 		if (!vsi->rss_lut_user)
 			return -ENOMEM;
@@ -3177,7 +3181,7 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		ec->tx_coalesce_usecs = rc->itr_setting & ~ICE_ITR_DYNAMIC;
 		break;
 	default:
-		dev_dbg(&pf->pdev->dev, "Invalid c_type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(pf), "Invalid c_type %d\n", c_type);
 		return -EINVAL;
 	}
 
@@ -3317,7 +3321,8 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 
 		break;
 	default:
-		dev_dbg(&pf->pdev->dev, "Invalid container type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(pf), "Invalid container type %d\n",
+			c_type);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index de9f616b163e..b546c69a4bbc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -52,26 +52,29 @@ static int ice_vsi_ctrl_rx_rings(struct ice_vsi *vsi, bool ena)
 static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
 
 	/* allocate memory for both Tx and Rx ring pointers */
-	vsi->tx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_txq,
+	vsi->tx_rings = devm_kcalloc(dev, vsi->alloc_txq,
 				     sizeof(*vsi->tx_rings), GFP_KERNEL);
 	if (!vsi->tx_rings)
 		return -ENOMEM;
 
-	vsi->rx_rings = devm_kcalloc(&pf->pdev->dev, vsi->alloc_rxq,
+	vsi->rx_rings = devm_kcalloc(dev, vsi->alloc_rxq,
 				     sizeof(*vsi->rx_rings), GFP_KERNEL);
 	if (!vsi->rx_rings)
 		goto err_rings;
 
 	/* XDP will have vsi->alloc_txq Tx queues as well, so double the size */
-	vsi->txq_map = devm_kcalloc(&pf->pdev->dev, (2 * vsi->alloc_txq),
+	vsi->txq_map = devm_kcalloc(dev, (2 * vsi->alloc_txq),
 				    sizeof(*vsi->txq_map), GFP_KERNEL);
 
 	if (!vsi->txq_map)
 		goto err_txq_map;
 
-	vsi->rxq_map = devm_kcalloc(&pf->pdev->dev, vsi->alloc_rxq,
+	vsi->rxq_map = devm_kcalloc(dev, vsi->alloc_rxq,
 				    sizeof(*vsi->rxq_map), GFP_KERNEL);
 	if (!vsi->rxq_map)
 		goto err_rxq_map;
@@ -81,7 +84,7 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 		return 0;
 
 	/* allocate memory for q_vector pointers */
-	vsi->q_vectors = devm_kcalloc(&pf->pdev->dev, vsi->num_q_vectors,
+	vsi->q_vectors = devm_kcalloc(dev, vsi->num_q_vectors,
 				      sizeof(*vsi->q_vectors), GFP_KERNEL);
 	if (!vsi->q_vectors)
 		goto err_vectors;
@@ -89,13 +92,13 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	return 0;
 
 err_vectors:
-	devm_kfree(&pf->pdev->dev, vsi->rxq_map);
+	devm_kfree(dev, vsi->rxq_map);
 err_rxq_map:
-	devm_kfree(&pf->pdev->dev, vsi->txq_map);
+	devm_kfree(dev, vsi->txq_map);
 err_txq_map:
-	devm_kfree(&pf->pdev->dev, vsi->rx_rings);
+	devm_kfree(dev, vsi->rx_rings);
 err_rings:
-	devm_kfree(&pf->pdev->dev, vsi->tx_rings);
+	devm_kfree(dev, vsi->tx_rings);
 	return -ENOMEM;
 }
 
@@ -169,7 +172,7 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		vsi->alloc_rxq = 1;
 		break;
 	default:
-		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
+		dev_warn(ice_pf_to_dev(pf), "Unknown VSI type %d\n", vsi->type);
 		break;
 	}
 
@@ -227,8 +230,8 @@ void ice_vsi_delete(struct ice_vsi *vsi)
 
 	status = ice_free_vsi(&pf->hw, vsi->idx, ctxt, false, NULL);
 	if (status)
-		dev_err(&pf->pdev->dev, "Failed to delete VSI %i in FW\n",
-			vsi->vsi_num);
+		dev_err(ice_pf_to_dev(pf), "Failed to delete VSI %i in FW - error: %d\n",
+			vsi->vsi_num, status);
 
 	kfree(ctxt);
 }
@@ -240,26 +243,29 @@ void ice_vsi_delete(struct ice_vsi *vsi)
 static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
 
 	/* free the ring and vector containers */
 	if (vsi->q_vectors) {
-		devm_kfree(&pf->pdev->dev, vsi->q_vectors);
+		devm_kfree(dev, vsi->q_vectors);
 		vsi->q_vectors = NULL;
 	}
 	if (vsi->tx_rings) {
-		devm_kfree(&pf->pdev->dev, vsi->tx_rings);
+		devm_kfree(dev, vsi->tx_rings);
 		vsi->tx_rings = NULL;
 	}
 	if (vsi->rx_rings) {
-		devm_kfree(&pf->pdev->dev, vsi->rx_rings);
+		devm_kfree(dev, vsi->rx_rings);
 		vsi->rx_rings = NULL;
 	}
 	if (vsi->txq_map) {
-		devm_kfree(&pf->pdev->dev, vsi->txq_map);
+		devm_kfree(dev, vsi->txq_map);
 		vsi->txq_map = NULL;
 	}
 	if (vsi->rxq_map) {
-		devm_kfree(&pf->pdev->dev, vsi->rxq_map);
+		devm_kfree(dev, vsi->rxq_map);
 		vsi->rxq_map = NULL;
 	}
 }
@@ -276,6 +282,7 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 int ice_vsi_clear(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = NULL;
+	struct device *dev;
 
 	if (!vsi)
 		return 0;
@@ -284,10 +291,10 @@ int ice_vsi_clear(struct ice_vsi *vsi)
 		return -EINVAL;
 
 	pf = vsi->back;
+	dev = ice_pf_to_dev(pf);
 
 	if (!pf->vsi[vsi->idx] || pf->vsi[vsi->idx] != vsi) {
-		dev_dbg(&pf->pdev->dev, "vsi does not exist at pf->vsi[%d]\n",
-			vsi->idx);
+		dev_dbg(dev, "vsi does not exist at pf->vsi[%d]\n", vsi->idx);
 		return -EINVAL;
 	}
 
@@ -300,7 +307,7 @@ int ice_vsi_clear(struct ice_vsi *vsi)
 
 	ice_vsi_free_arrays(vsi);
 	mutex_unlock(&pf->sw_mutex);
-	devm_kfree(&pf->pdev->dev, vsi);
+	devm_kfree(dev, vsi);
 
 	return 0;
 }
@@ -333,6 +340,7 @@ static irqreturn_t ice_msix_clean_rings(int __always_unused irq, void *data)
 static struct ice_vsi *
 ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_vsi *vsi = NULL;
 
 	/* Need to protect the allocation of the VSIs at the PF level */
@@ -343,11 +351,11 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 	 * is available to be populated
 	 */
 	if (pf->next_vsi == ICE_NO_VSI) {
-		dev_dbg(&pf->pdev->dev, "out of VSI slots!\n");
+		dev_dbg(dev, "out of VSI slots!\n");
 		goto unlock_pf;
 	}
 
-	vsi = devm_kzalloc(&pf->pdev->dev, sizeof(*vsi), GFP_KERNEL);
+	vsi = devm_kzalloc(dev, sizeof(*vsi), GFP_KERNEL);
 	if (!vsi)
 		goto unlock_pf;
 
@@ -379,7 +387,7 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 			goto err_rings;
 		break;
 	default:
-		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
+		dev_warn(dev, "Unknown VSI type %d\n", vsi->type);
 		goto unlock_pf;
 	}
 
@@ -392,7 +400,7 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 	goto unlock_pf;
 
 err_rings:
-	devm_kfree(&pf->pdev->dev, vsi);
+	devm_kfree(dev, vsi);
 	vsi = NULL;
 unlock_pf:
 	mutex_unlock(&pf->sw_mutex);
@@ -481,14 +489,15 @@ bool ice_is_safe_mode(struct ice_pf *pf)
  */
 static void ice_rss_clean(struct ice_vsi *vsi)
 {
-	struct ice_pf *pf;
+	struct ice_pf *pf = vsi->back;
+	struct device *dev;
 
-	pf = vsi->back;
+	dev = ice_pf_to_dev(pf);
 
 	if (vsi->rss_hkey_user)
-		devm_kfree(&pf->pdev->dev, vsi->rss_hkey_user);
+		devm_kfree(dev, vsi->rss_hkey_user);
 	if (vsi->rss_lut_user)
-		devm_kfree(&pf->pdev->dev, vsi->rss_lut_user);
+		devm_kfree(dev, vsi->rss_lut_user);
 }
 
 /**
@@ -526,7 +535,7 @@ static void ice_vsi_set_rss_params(struct ice_vsi *vsi)
 	case ICE_VSI_LB:
 		break;
 	default:
-		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n",
+		dev_warn(ice_pf_to_dev(pf), "Unknown VSI type %d\n",
 			 vsi->type);
 		break;
 	}
@@ -702,9 +711,11 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 {
 	u8 lut_type, hash_type;
+	struct device *dev;
 	struct ice_pf *pf;
 
 	pf = vsi->back;
+	dev = ice_pf_to_dev(pf);
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
@@ -718,11 +729,11 @@ static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 		hash_type = ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
 		break;
 	case ICE_VSI_LB:
-		dev_dbg(&pf->pdev->dev, "Unsupported VSI type %s\n",
+		dev_dbg(dev, "Unsupported VSI type %s\n",
 			ice_vsi_type_str(vsi->type));
 		return;
 	default:
-		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
+		dev_warn(dev, "Unknown VSI type %d\n", vsi->type);
 		return;
 	}
 
@@ -796,8 +807,7 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 
 	ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
 	if (ret) {
-		dev_err(&pf->pdev->dev,
-			"Add VSI failed, err %d\n", ret);
+		dev_err(ice_pf_to_dev(pf), "Add VSI failed, err %d\n", ret);
 		ret = -EIO;
 		goto out;
 	}
@@ -826,14 +836,16 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
 	u16 num_q_vectors;
 
+	dev = ice_pf_to_dev(pf);
 	/* SRIOV doesn't grab irq_tracker entries for each VSI */
 	if (vsi->type == ICE_VSI_VF)
 		return 0;
 
 	if (vsi->base_vector) {
-		dev_dbg(&pf->pdev->dev, "VSI %d has non-zero base vector %d\n",
+		dev_dbg(dev, "VSI %d has non-zero base vector %d\n",
 			vsi->vsi_num, vsi->base_vector);
 		return -EEXIST;
 	}
@@ -843,7 +855,7 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	vsi->base_vector = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
 				       vsi->idx);
 	if (vsi->base_vector < 0) {
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"Failed to get tracking for %d vectors for VSI %d, err=%d\n",
 			num_q_vectors, vsi->vsi_num, vsi->base_vector);
 		return -ENOENT;
@@ -886,8 +898,10 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
 	int i;
 
+	dev = ice_pf_to_dev(pf);
 	/* Allocate Tx rings */
 	for (i = 0; i < vsi->alloc_txq; i++) {
 		struct ice_ring *ring;
@@ -902,7 +916,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->reg_idx = vsi->txq_map[i];
 		ring->ring_active = false;
 		ring->vsi = vsi;
-		ring->dev = &pf->pdev->dev;
+		ring->dev = dev;
 		ring->count = vsi->num_tx_desc;
 		vsi->tx_rings[i] = ring;
 	}
@@ -921,7 +935,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->ring_active = false;
 		ring->vsi = vsi;
 		ring->netdev = vsi->netdev;
-		ring->dev = &pf->pdev->dev;
+		ring->dev = dev;
 		ring->count = vsi->num_rx_desc;
 		vsi->rx_rings[i] = ring;
 	}
@@ -973,9 +987,11 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	struct ice_aqc_get_set_rss_keys *key;
 	struct ice_pf *pf = vsi->back;
 	enum ice_status status;
+	struct device *dev;
 	int err = 0;
 	u8 *lut;
 
+	dev = ice_pf_to_dev(pf);
 	vsi->rss_size = min_t(int, vsi->rss_size, vsi->num_rxq);
 
 	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
@@ -991,8 +1007,7 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 				    vsi->rss_table_size);
 
 	if (status) {
-		dev_err(&pf->pdev->dev,
-			"set_rss_lut failed, error %d\n", status);
+		dev_err(dev, "set_rss_lut failed, error %d\n", status);
 		err = -EIO;
 		goto ice_vsi_cfg_rss_exit;
 	}
@@ -1014,8 +1029,7 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	status = ice_aq_set_rss_key(&pf->hw, vsi->idx, key);
 
 	if (status) {
-		dev_err(&pf->pdev->dev, "set_rss_key failed, error %d\n",
-			status);
+		dev_err(dev, "set_rss_key failed, error %d\n", status);
 		err = -EIO;
 	}
 
@@ -1041,7 +1055,7 @@ int ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 	struct ice_fltr_list_entry *tmp;
 	struct ice_pf *pf = vsi->back;
 
-	tmp = devm_kzalloc(&pf->pdev->dev, sizeof(*tmp), GFP_ATOMIC);
+	tmp = devm_kzalloc(ice_pf_to_dev(pf), sizeof(*tmp), GFP_ATOMIC);
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1133,9 +1147,11 @@ int ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid)
 	struct ice_pf *pf = vsi->back;
 	LIST_HEAD(tmp_add_list);
 	enum ice_status status;
+	struct device *dev;
 	int err = 0;
 
-	tmp = devm_kzalloc(&pf->pdev->dev, sizeof(*tmp), GFP_KERNEL);
+	dev = ice_pf_to_dev(pf);
+	tmp = devm_kzalloc(dev, sizeof(*tmp), GFP_KERNEL);
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1152,11 +1168,11 @@ int ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid)
 	status = ice_add_vlan(&pf->hw, &tmp_add_list);
 	if (status) {
 		err = -ENODEV;
-		dev_err(&pf->pdev->dev, "Failure Adding VLAN %d on VSI %i\n",
-			vid, vsi->vsi_num);
+		dev_err(dev, "Failure Adding VLAN %d on VSI %i\n", vid,
+			vsi->vsi_num);
 	}
 
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+	ice_free_fltr_list(dev, &tmp_add_list);
 	return err;
 }
 
@@ -1173,9 +1189,11 @@ int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid)
 	struct ice_pf *pf = vsi->back;
 	LIST_HEAD(tmp_add_list);
 	enum ice_status status;
+	struct device *dev;
 	int err = 0;
 
-	list = devm_kzalloc(&pf->pdev->dev, sizeof(*list), GFP_KERNEL);
+	dev = ice_pf_to_dev(pf);
+	list = devm_kzalloc(dev, sizeof(*list), GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 
@@ -1191,17 +1209,17 @@ int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid)
 
 	status = ice_remove_vlan(&pf->hw, &tmp_add_list);
 	if (status == ICE_ERR_DOES_NOT_EXIST) {
-		dev_dbg(&pf->pdev->dev,
+		dev_dbg(dev,
 			"Failed to remove VLAN %d on VSI %i, it does not exist, status: %d\n",
 			vid, vsi->vsi_num, status);
 	} else if (status) {
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"Error removing VLAN %d on vsi %i error: %d\n",
 			vid, vsi->vsi_num, status);
 		err = -EIO;
 	}
 
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+	ice_free_fltr_list(dev, &tmp_add_list);
 	return err;
 }
 
@@ -1683,8 +1701,10 @@ ice_vsi_add_rem_eth_mac(struct ice_vsi *vsi, bool add_rule)
 	struct ice_pf *pf = vsi->back;
 	LIST_HEAD(tmp_add_list);
 	enum ice_status status;
+	struct device *dev;
 
-	list = devm_kzalloc(&pf->pdev->dev, sizeof(*list), GFP_KERNEL);
+	dev = ice_pf_to_dev(pf);
+	list = devm_kzalloc(dev, sizeof(*list), GFP_KERNEL);
 	if (!list)
 		return;
 
@@ -1704,11 +1724,11 @@ ice_vsi_add_rem_eth_mac(struct ice_vsi *vsi, bool add_rule)
 		status = ice_remove_eth_mac(&pf->hw, &tmp_add_list);
 
 	if (status)
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"Failure Adding or Removing Ethertype on VSI %i error: %d\n",
 			vsi->vsi_num, status);
 
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+	ice_free_fltr_list(dev, &tmp_add_list);
 }
 
 /**
@@ -1723,8 +1743,10 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
 	struct ice_pf *pf = vsi->back;
 	LIST_HEAD(tmp_add_list);
 	enum ice_status status;
+	struct device *dev;
 
-	list = devm_kzalloc(&pf->pdev->dev, sizeof(*list), GFP_KERNEL);
+	dev = ice_pf_to_dev(pf);
+	list = devm_kzalloc(dev, sizeof(*list), GFP_KERNEL);
 	if (!list)
 		return;
 
@@ -1751,12 +1773,11 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
 		status = ice_remove_eth_mac(&pf->hw, &tmp_add_list);
 
 	if (status)
-		dev_err(&pf->pdev->dev,
-			"Fail %s %s LLDP rule on VSI %i error: %d\n",
+		dev_err(dev, "Fail %s %s LLDP rule on VSI %i error: %d\n",
 			create ? "adding" : "removing", tx ? "TX" : "RX",
 			vsi->vsi_num, status);
 
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+	ice_free_fltr_list(dev, &tmp_add_list);
 }
 
 /**
@@ -1778,7 +1799,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	      enum ice_vsi_type type, u16 vf_id)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	enum ice_status status;
 	struct ice_vsi *vsi;
 	int ret, i;
@@ -1887,8 +1908,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
 	if (status) {
-		dev_err(&pf->pdev->dev,
-			"VSI %d failed lan queue config, error %d\n",
+		dev_err(dev, "VSI %d failed lan queue config, error %d\n",
 			vsi->vsi_num, status);
 		goto unroll_vector_base;
 	}
@@ -2000,8 +2020,7 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 		/* clear the affinity_mask in the IRQ descriptor */
 		irq_set_affinity_hint(irq_num, NULL);
 		synchronize_irq(irq_num);
-		devm_free_irq(&pf->pdev->dev, irq_num,
-			      vsi->q_vectors[i]);
+		devm_free_irq(ice_pf_to_dev(pf), irq_num, vsi->q_vectors[i]);
 	}
 }
 
@@ -2187,7 +2206,7 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
 		return -EINVAL;
 
 	if (!needed || needed > res->num_entries || id >= ICE_RES_VALID_BIT) {
-		dev_err(&pf->pdev->dev,
+		dev_err(ice_pf_to_dev(pf),
 			"param err: needed=%d, num_entries = %d id=0x%04x\n",
 			needed, res->num_entries, id);
 		return -EINVAL;
@@ -2469,7 +2488,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
 	if (status) {
-		dev_err(&pf->pdev->dev,
+		dev_err(ice_pf_to_dev(pf),
 			"VSI %d failed lan queue config, error %d\n",
 			vsi->vsi_num, status);
 		goto err_vectors;
@@ -2532,9 +2551,12 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 	struct ice_vsi_ctx *ctx;
 	struct ice_pf *pf = vsi->back;
 	enum ice_status status;
+	struct device *dev;
 	int i, ret = 0;
 	u8 num_tc = 0;
 
+	dev = ice_pf_to_dev(pf);
+
 	ice_for_each_traffic_class(i) {
 		/* build bitmap of enabled TCs */
 		if (ena_tc & BIT(i))
@@ -2559,7 +2581,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);
 	status = ice_update_vsi(&pf->hw, vsi->idx, ctx, NULL);
 	if (status) {
-		dev_info(&pf->pdev->dev, "Failed VSI Update\n");
+		dev_info(dev, "Failed VSI Update\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -2568,8 +2590,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 				 max_txqs);
 
 	if (status) {
-		dev_err(&pf->pdev->dev,
-			"VSI %d failed TC config, error %d\n",
+		dev_err(dev, "VSI %d failed TC config, error %d\n",
 			vsi->vsi_num, status);
 		ret = -EIO;
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0f68910ba87d..ea577588b274 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -161,7 +161,7 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 	 * had an error
 	 */
 	if (status && vsi->netdev->reg_state == NETREG_REGISTERED) {
-		dev_err(&pf->pdev->dev,
+		dev_err(ice_pf_to_dev(pf),
 			"Could not add MAC filters error %d. Unregistering device\n",
 			status);
 		unregister_netdev(vsi->netdev);
@@ -495,7 +495,7 @@ ice_prepare_for_reset(struct ice_pf *pf)
  */
 static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 {
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 
 	dev_dbg(dev, "reset_type 0x%x requested\n", reset_type);
@@ -792,6 +792,7 @@ static int
 ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	       u16 link_speed)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_phy_info *phy_info;
 	struct ice_vsi *vsi;
 	u16 old_link_speed;
@@ -809,7 +810,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	 */
 	result = ice_update_link_info(pi);
 	if (result)
-		dev_dbg(&pf->pdev->dev,
+		dev_dbg(dev,
 			"Failed to update link status and re-enable link events for port %d\n",
 			pi->lport);
 
@@ -828,7 +829,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 
 		result = ice_aq_set_link_restart_an(pi, false, NULL);
 		if (result) {
-			dev_dbg(&pf->pdev->dev,
+			dev_dbg(dev,
 				"Failed to set link down, VSI %d error %d\n",
 				vsi->vsi_num, result);
 			return result;
@@ -924,7 +925,7 @@ ice_handle_link_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 				!!(link_data->link_info & ICE_AQ_LINK_UP),
 				le16_to_cpu(link_data->link_speed));
 	if (status)
-		dev_dbg(&pf->pdev->dev,
+		dev_dbg(ice_pf_to_dev(pf),
 			"Could not process link event, error %d\n", status);
 
 	return status;
@@ -937,6 +938,7 @@ ice_handle_link_event(struct ice_pf *pf, struct ice_rq_event_info *event)
  */
 static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_rq_event_info event;
 	struct ice_hw *hw = &pf->hw;
 	struct ice_ctl_q_info *cq;
@@ -958,8 +960,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		qtype = "Mailbox";
 		break;
 	default:
-		dev_warn(&pf->pdev->dev, "Unknown control queue type 0x%x\n",
-			 q_type);
+		dev_warn(dev, "Unknown control queue type 0x%x\n", q_type);
 		return 0;
 	}
 
@@ -971,15 +972,15 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		   PF_FW_ARQLEN_ARQCRIT_M)) {
 		oldval = val;
 		if (val & PF_FW_ARQLEN_ARQVFE_M)
-			dev_dbg(&pf->pdev->dev,
-				"%s Receive Queue VF Error detected\n", qtype);
+			dev_dbg(dev, "%s Receive Queue VF Error detected\n",
+				qtype);
 		if (val & PF_FW_ARQLEN_ARQOVFL_M) {
-			dev_dbg(&pf->pdev->dev,
+			dev_dbg(dev,
 				"%s Receive Queue Overflow Error detected\n",
 				qtype);
 		}
 		if (val & PF_FW_ARQLEN_ARQCRIT_M)
-			dev_dbg(&pf->pdev->dev,
+			dev_dbg(dev,
 				"%s Receive Queue Critical Error detected\n",
 				qtype);
 		val &= ~(PF_FW_ARQLEN_ARQVFE_M | PF_FW_ARQLEN_ARQOVFL_M |
@@ -993,16 +994,14 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		   PF_FW_ATQLEN_ATQCRIT_M)) {
 		oldval = val;
 		if (val & PF_FW_ATQLEN_ATQVFE_M)
-			dev_dbg(&pf->pdev->dev,
+			dev_dbg(dev,
 				"%s Send Queue VF Error detected\n", qtype);
 		if (val & PF_FW_ATQLEN_ATQOVFL_M) {
-			dev_dbg(&pf->pdev->dev,
-				"%s Send Queue Overflow Error detected\n",
+			dev_dbg(dev, "%s Send Queue Overflow Error detected\n",
 				qtype);
 		}
 		if (val & PF_FW_ATQLEN_ATQCRIT_M)
-			dev_dbg(&pf->pdev->dev,
-				"%s Send Queue Critical Error detected\n",
+			dev_dbg(dev, "%s Send Queue Critical Error detected\n",
 				qtype);
 		val &= ~(PF_FW_ATQLEN_ATQVFE_M | PF_FW_ATQLEN_ATQOVFL_M |
 			 PF_FW_ATQLEN_ATQCRIT_M);
@@ -1023,8 +1022,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		if (ret == ICE_ERR_AQ_NO_WORK)
 			break;
 		if (ret) {
-			dev_err(&pf->pdev->dev,
-				"%s Receive Queue event error %d\n", qtype,
+			dev_err(dev, "%s Receive Queue event error %d\n", qtype,
 				ret);
 			break;
 		}
@@ -1034,8 +1032,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		switch (opcode) {
 		case ice_aqc_opc_get_link_status:
 			if (ice_handle_link_event(pf, &event))
-				dev_err(&pf->pdev->dev,
-					"Could not handle link event\n");
+				dev_err(dev, "Could not handle link event\n");
 			break;
 		case ice_mbx_opc_send_msg_to_pf:
 			ice_vc_process_vf_msg(pf, &event);
@@ -1047,7 +1044,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			ice_dcb_process_lldp_set_mib_change(pf, &event);
 			break;
 		default:
-			dev_dbg(&pf->pdev->dev,
+			dev_dbg(dev,
 				"%s Receive Queue unknown event 0x%04x ignored\n",
 				qtype, opcode);
 			break;
@@ -1198,6 +1195,7 @@ static void ice_service_timer(struct timer_list *t)
  */
 static void ice_handle_mdd_event(struct ice_pf *pf)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	bool mdd_detected = false;
 	u32 reg;
@@ -1219,7 +1217,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				GL_MDET_TX_PQM_QNUM_S);
 
 		if (netif_msg_tx_err(pf))
-			dev_info(&pf->pdev->dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
+			dev_info(dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_TX_PQM, 0xffffffff);
 		mdd_detected = true;
@@ -1237,7 +1235,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				GL_MDET_TX_TCLAN_QNUM_S);
 
 		if (netif_msg_rx_err(pf))
-			dev_info(&pf->pdev->dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
+			dev_info(dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_TX_TCLAN, 0xffffffff);
 		mdd_detected = true;
@@ -1255,7 +1253,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				GL_MDET_RX_QNUM_S);
 
 		if (netif_msg_rx_err(pf))
-			dev_info(&pf->pdev->dev, "Malicious Driver Detection event %d on RX queue %d PF# %d VF# %d\n",
+			dev_info(dev, "Malicious Driver Detection event %d on RX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_RX, 0xffffffff);
 		mdd_detected = true;
@@ -1267,21 +1265,21 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, PF_MDET_TX_PQM);
 		if (reg & PF_MDET_TX_PQM_VALID_M) {
 			wr32(hw, PF_MDET_TX_PQM, 0xFFFF);
-			dev_info(&pf->pdev->dev, "TX driver issue detected, PF reset issued\n");
+			dev_info(dev, "TX driver issue detected, PF reset issued\n");
 			pf_mdd_detected = true;
 		}
 
 		reg = rd32(hw, PF_MDET_TX_TCLAN);
 		if (reg & PF_MDET_TX_TCLAN_VALID_M) {
 			wr32(hw, PF_MDET_TX_TCLAN, 0xFFFF);
-			dev_info(&pf->pdev->dev, "TX driver issue detected, PF reset issued\n");
+			dev_info(dev, "TX driver issue detected, PF reset issued\n");
 			pf_mdd_detected = true;
 		}
 
 		reg = rd32(hw, PF_MDET_RX);
 		if (reg & PF_MDET_RX_VALID_M) {
 			wr32(hw, PF_MDET_RX, 0xFFFF);
-			dev_info(&pf->pdev->dev, "RX driver issue detected, PF reset issued\n");
+			dev_info(dev, "RX driver issue detected, PF reset issued\n");
 			pf_mdd_detected = true;
 		}
 		/* Queue belongs to the PF initiate a reset */
@@ -1301,7 +1299,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_TX_PQM_VALID_M) {
 			wr32(hw, VP_MDET_TX_PQM(i), 0xFFFF);
 			vf_mdd_detected = true;
-			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
+			dev_info(dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
 
@@ -1309,7 +1307,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_TX_TCLAN_VALID_M) {
 			wr32(hw, VP_MDET_TX_TCLAN(i), 0xFFFF);
 			vf_mdd_detected = true;
-			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
+			dev_info(dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
 
@@ -1317,7 +1315,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_TX_TDPU_VALID_M) {
 			wr32(hw, VP_MDET_TX_TDPU(i), 0xFFFF);
 			vf_mdd_detected = true;
-			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
+			dev_info(dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
 
@@ -1325,7 +1323,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_RX_VALID_M) {
 			wr32(hw, VP_MDET_RX(i), 0xFFFF);
 			vf_mdd_detected = true;
-			dev_info(&pf->pdev->dev, "RX driver issue detected on VF %d\n",
+			dev_info(dev, "RX driver issue detected on VF %d\n",
 				 i);
 		}
 
@@ -1333,7 +1331,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 			vf->num_mdd_events++;
 			if (vf->num_mdd_events &&
 			    vf->num_mdd_events <= ICE_MDD_EVENTS_THRESHOLD)
-				dev_info(&pf->pdev->dev,
+				dev_info(dev,
 					 "VF %d has had %llu MDD events since last boot, Admin might need to reload AVF driver with this number of events\n",
 					 i, vf->num_mdd_events);
 		}
@@ -1580,11 +1578,13 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 	int q_vectors = vsi->num_q_vectors;
 	struct ice_pf *pf = vsi->back;
 	int base = vsi->base_vector;
+	struct device *dev;
 	int rx_int_idx = 0;
 	int tx_int_idx = 0;
 	int vector, err;
 	int irq_num;
 
+	dev = ice_pf_to_dev(pf);
 	for (vector = 0; vector < q_vectors; vector++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[vector];
 
@@ -1604,8 +1604,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 			/* skip this unused q_vector */
 			continue;
 		}
-		err = devm_request_irq(&pf->pdev->dev, irq_num,
-				       vsi->irq_handler, 0,
+		err = devm_request_irq(dev, irq_num, vsi->irq_handler, 0,
 				       q_vector->name, q_vector);
 		if (err) {
 			netdev_err(vsi->netdev,
@@ -1631,7 +1630,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 		irq_num = pf->msix_entries[base + vector].vector,
 		irq_set_affinity_notifier(irq_num, NULL);
 		irq_set_affinity_hint(irq_num, NULL);
-		devm_free_irq(&pf->pdev->dev, irq_num, &vsi->q_vectors[vector]);
+		devm_free_irq(dev, irq_num, &vsi->q_vectors[vector]);
 	}
 	return err;
 }
@@ -1720,9 +1719,11 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 		.mapping_mode = ICE_VSI_MAP_CONTIG
 	};
 	enum ice_status status;
+	struct device *dev;
 	int i, v_idx;
 
-	vsi->xdp_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_xdp_txq,
+	dev = ice_pf_to_dev(pf);
+	vsi->xdp_rings = devm_kcalloc(dev, vsi->num_xdp_txq,
 				      sizeof(*vsi->xdp_rings), GFP_KERNEL);
 	if (!vsi->xdp_rings)
 		return -ENOMEM;
@@ -1769,8 +1770,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
 	if (status) {
-		dev_err(&pf->pdev->dev,
-			"Failed VSI LAN queue config for XDP, error:%d\n",
+		dev_err(dev, "Failed VSI LAN queue config for XDP, error:%d\n",
 			status);
 		goto clear_xdp_rings;
 	}
@@ -1792,7 +1792,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	}
 	mutex_unlock(&pf->avail_q_mutex);
 
-	devm_kfree(&pf->pdev->dev, vsi->xdp_rings);
+	devm_kfree(dev, vsi->xdp_rings);
 	return -ENOMEM;
 }
 
@@ -1845,7 +1845,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 			vsi->xdp_rings[i] = NULL;
 		}
 
-	devm_kfree(&pf->pdev->dev, vsi->xdp_rings);
+	devm_kfree(ice_pf_to_dev(pf), vsi->xdp_rings);
 	vsi->xdp_rings = NULL;
 
 	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
@@ -1992,8 +1992,10 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 	struct ice_pf *pf = (struct ice_pf *)data;
 	struct ice_hw *hw = &pf->hw;
 	irqreturn_t ret = IRQ_NONE;
+	struct device *dev;
 	u32 oicr, ena_mask;
 
+	dev = ice_pf_to_dev(pf);
 	set_bit(__ICE_ADMINQ_EVENT_PENDING, pf->state);
 	set_bit(__ICE_MAILBOXQ_EVENT_PENDING, pf->state);
 
@@ -2029,8 +2031,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		else if (reset == ICE_RESET_EMPR)
 			pf->empr_count++;
 		else
-			dev_dbg(&pf->pdev->dev, "Invalid reset type %d\n",
-				reset);
+			dev_dbg(dev, "Invalid reset type %d\n", reset);
 
 		/* If a reset cycle isn't already in progress, we set a bit in
 		 * pf->state so that the service task can start a reset/rebuild.
@@ -2064,8 +2065,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 	if (oicr & PFINT_OICR_HMC_ERR_M) {
 		ena_mask &= ~PFINT_OICR_HMC_ERR_M;
-		dev_dbg(&pf->pdev->dev,
-			"HMC Error interrupt - info 0x%x, data 0x%x\n",
+		dev_dbg(dev, "HMC Error interrupt - info 0x%x, data 0x%x\n",
 			rd32(hw, PFHMC_ERRORINFO),
 			rd32(hw, PFHMC_ERRORDATA));
 	}
@@ -2073,8 +2073,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 	/* Report any remaining unexpected interrupts */
 	oicr &= ena_mask;
 	if (oicr) {
-		dev_dbg(&pf->pdev->dev, "unhandled interrupt oicr=0x%08x\n",
-			oicr);
+		dev_dbg(dev, "unhandled interrupt oicr=0x%08x\n", oicr);
 		/* If a critical error is pending there is no choice but to
 		 * reset the device.
 		 */
@@ -2132,7 +2131,7 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 
 	if (pf->msix_entries) {
 		synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
-		devm_free_irq(&pf->pdev->dev,
+		devm_free_irq(ice_pf_to_dev(pf),
 			      pf->msix_entries[pf->oicr_idx].vector, pf);
 	}
 
@@ -2176,13 +2175,13 @@ static void ice_ena_ctrlq_interrupts(struct ice_hw *hw, u16 reg_idx)
  */
 static int ice_req_irq_msix_misc(struct ice_pf *pf)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	int oicr_idx, err = 0;
 
 	if (!pf->int_name[0])
 		snprintf(pf->int_name, sizeof(pf->int_name) - 1, "%s-%s:misc",
-			 dev_driver_string(&pf->pdev->dev),
-			 dev_name(&pf->pdev->dev));
+			 dev_driver_string(dev), dev_name(dev));
 
 	/* Do not request IRQ but do enable OICR interrupt since settings are
 	 * lost during reset. Note that this function is called only during
@@ -2199,12 +2198,10 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
 	pf->num_avail_sw_msix -= 1;
 	pf->oicr_idx = oicr_idx;
 
-	err = devm_request_irq(&pf->pdev->dev,
-			       pf->msix_entries[pf->oicr_idx].vector,
+	err = devm_request_irq(dev, pf->msix_entries[pf->oicr_idx].vector,
 			       ice_misc_intr, 0, pf->int_name, pf);
 	if (err) {
-		dev_err(&pf->pdev->dev,
-			"devm_request_irq for %s failed: %d\n",
+		dev_err(dev, "devm_request_irq for %s failed: %d\n",
 			pf->int_name, err);
 		ice_free_res(pf->irq_tracker, 1, ICE_RES_MISC_VEC_ID);
 		pf->num_avail_sw_msix += 1;
@@ -2337,7 +2334,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	ice_set_ops(netdev);
 
 	if (vsi->type == ICE_VSI_PF) {
-		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
+		SET_NETDEV_DEV(netdev, ice_pf_to_dev(pf));
 		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
 		ether_addr_copy(netdev->dev_addr, mac_addr);
 		ether_addr_copy(netdev->perm_addr, mac_addr);
@@ -2664,7 +2661,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
 	if (!pf->avail_rxqs) {
-		devm_kfree(&pf->pdev->dev, pf->avail_txqs);
+		devm_kfree(ice_pf_to_dev(pf), pf->avail_txqs);
 		pf->avail_txqs = NULL;
 		return -ENOMEM;
 	}
@@ -2681,6 +2678,7 @@ static int ice_init_pf(struct ice_pf *pf)
  */
 static int ice_ena_msix_range(struct ice_pf *pf)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	int v_left, v_actual, v_budget = 0;
 	int needed, err, i;
 
@@ -2701,7 +2699,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_budget += needed;
 	v_left -= needed;
 
-	pf->msix_entries = devm_kcalloc(&pf->pdev->dev, v_budget,
+	pf->msix_entries = devm_kcalloc(dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 
 	if (!pf->msix_entries) {
@@ -2717,13 +2715,13 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 					 ICE_MIN_MSIX, v_budget);
 
 	if (v_actual < 0) {
-		dev_err(&pf->pdev->dev, "unable to reserve MSI-X vectors\n");
+		dev_err(dev, "unable to reserve MSI-X vectors\n");
 		err = v_actual;
 		goto msix_err;
 	}
 
 	if (v_actual < v_budget) {
-		dev_warn(&pf->pdev->dev,
+		dev_warn(dev,
 			 "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
 /* 2 vectors for LAN (traffic + OICR) */
@@ -2742,11 +2740,11 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	return v_actual;
 
 msix_err:
-	devm_kfree(&pf->pdev->dev, pf->msix_entries);
+	devm_kfree(dev, pf->msix_entries);
 	goto exit_err;
 
 no_hw_vecs_left_err:
-	dev_err(&pf->pdev->dev,
+	dev_err(dev,
 		"not enough device MSI-X vectors. requested = %d, available = %d\n",
 		needed, v_left);
 	err = -ERANGE;
@@ -2762,7 +2760,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 static void ice_dis_msix(struct ice_pf *pf)
 {
 	pci_disable_msix(pf->pdev);
-	devm_kfree(&pf->pdev->dev, pf->msix_entries);
+	devm_kfree(ice_pf_to_dev(pf), pf->msix_entries);
 	pf->msix_entries = NULL;
 }
 
@@ -2775,7 +2773,7 @@ static void ice_clear_interrupt_scheme(struct ice_pf *pf)
 	ice_dis_msix(pf);
 
 	if (pf->irq_tracker) {
-		devm_kfree(&pf->pdev->dev, pf->irq_tracker);
+		devm_kfree(ice_pf_to_dev(pf), pf->irq_tracker);
 		pf->irq_tracker = NULL;
 	}
 }
@@ -2795,7 +2793,7 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 
 	/* set up vector assignment tracking */
 	pf->irq_tracker =
-		devm_kzalloc(&pf->pdev->dev, sizeof(*pf->irq_tracker) +
+		devm_kzalloc(ice_pf_to_dev(pf), sizeof(*pf->irq_tracker) +
 			     (sizeof(u16) * vectors), GFP_KERNEL);
 	if (!pf->irq_tracker) {
 		ice_dis_msix(pf);
@@ -2819,7 +2817,7 @@ static void
 ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 {
 	struct ice_pf *pf = (struct ice_pf *)hw->back;
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 
 	switch (*status) {
 	case ICE_SUCCESS:
@@ -2938,7 +2936,7 @@ static void
 ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
 {
 	enum ice_status status = ICE_ERR_PARAM;
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 
 	/* Load DDP Package */
@@ -2978,7 +2976,7 @@ ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
 static void ice_verify_cacheline_size(struct ice_pf *pf)
 {
 	if (rd32(&pf->hw, GLPCI_CNF2) & GLPCI_CNF2_CACHELINE_SIZE_M)
-		dev_warn(&pf->pdev->dev,
+		dev_warn(ice_pf_to_dev(pf),
 			 "%d Byte cache line assumption is invalid, driver may have Tx timeouts!\n",
 			 ICE_CACHE_LINE_BYTES);
 }
@@ -3048,7 +3046,7 @@ static void ice_request_fw(struct ice_pf *pf)
 {
 	char *opt_fw_filename = ice_get_opt_fw_name(pf);
 	const struct firmware *firmware = NULL;
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	int err = 0;
 
 	/* optional device-specific DDP (if present) overrides the default DDP
@@ -3239,7 +3237,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	err = ice_setup_pf_sw(pf);
 	if (err) {
-		dev_err(dev, "probe failed due to setup PF switch:%d\n", err);
+		dev_err(dev, "probe failed due to setup PF switch: %d\n", err);
 		goto err_alloc_sw_unroll;
 	}
 
@@ -3287,7 +3285,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 err_alloc_sw_unroll:
 	set_bit(__ICE_SERVICE_DIS, pf->state);
 	set_bit(__ICE_DOWN, pf->state);
-	devm_kfree(&pf->pdev->dev, pf->first_sw);
+	devm_kfree(dev, pf->first_sw);
 err_msix_misc_unroll:
 	ice_free_irq_msix_misc(pf);
 err_init_interrupt_unroll:
@@ -4409,7 +4407,7 @@ static int ice_vsi_open(struct ice_vsi *vsi)
 		goto err_setup_rx;
 
 	snprintf(int_name, sizeof(int_name) - 1, "%s-%s",
-		 dev_driver_string(&pf->pdev->dev), vsi->netdev->name);
+		 dev_driver_string(ice_pf_to_dev(pf)), vsi->netdev->name);
 	err = ice_vsi_req_irq_msix(vsi, int_name);
 	if (err)
 		goto err_setup_rx;
@@ -4458,7 +4456,7 @@ static void ice_vsi_release_all(struct ice_pf *pf)
 
 		err = ice_vsi_release(pf->vsi[i]);
 		if (err)
-			dev_dbg(&pf->pdev->dev,
+			dev_dbg(ice_pf_to_dev(pf),
 				"Failed to release pf->vsi[%d], err %d, vsi_num = %d\n",
 				i, err, pf->vsi[i]->vsi_num);
 	}
@@ -4473,6 +4471,7 @@ static void ice_vsi_release_all(struct ice_pf *pf)
  */
 static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	enum ice_status status;
 	int i, err;
 
@@ -4485,7 +4484,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		/* rebuild the VSI */
 		err = ice_vsi_rebuild(vsi);
 		if (err) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"rebuild VSI failed, err %d, VSI index %d, type %s\n",
 				err, vsi->idx, ice_vsi_type_str(type));
 			return err;
@@ -4494,7 +4493,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		/* replay filters for the VSI */
 		status = ice_replay_vsi(&pf->hw, vsi->idx);
 		if (status) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"replay VSI failed, status %d, VSI index %d, type %s\n",
 				status, vsi->idx, ice_vsi_type_str(type));
 			return -EIO;
@@ -4508,14 +4507,14 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		/* enable the VSI */
 		err = ice_ena_vsi(vsi, false);
 		if (err) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"enable VSI failed, err %d, VSI index %d, type %s\n",
 				err, vsi->idx, ice_vsi_type_str(type));
 			return err;
 		}
 
-		dev_info(&pf->pdev->dev, "VSI rebuilt. VSI index %d, type %s\n",
-			 vsi->idx, ice_vsi_type_str(type));
+		dev_info(dev, "VSI rebuilt. VSI index %d, type %s\n", vsi->idx,
+			 ice_vsi_type_str(type));
 	}
 
 	return 0;
@@ -4554,7 +4553,7 @@ static void ice_update_pf_netdev_link(struct ice_pf *pf)
  */
 static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 {
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status ret;
 	int err;
@@ -4600,7 +4599,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	err = ice_update_link_info(hw->port_info);
 	if (err)
-		dev_err(&pf->pdev->dev, "Get link status error %d\n", err);
+		dev_err(dev, "Get link status error %d\n", err);
 
 	/* start misc vector */
 	err = ice_req_irq_msix_misc(pf);
@@ -4759,7 +4758,9 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
+	struct device *dev;
 
+	dev = ice_pf_to_dev(pf);
 	if (seed) {
 		struct ice_aqc_get_set_rss_keys *buf =
 				  (struct ice_aqc_get_set_rss_keys *)seed;
@@ -4767,8 +4768,7 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		status = ice_aq_set_rss_key(hw, vsi->idx, buf);
 
 		if (status) {
-			dev_err(&pf->pdev->dev,
-				"Cannot set RSS key, err %d aq_err %d\n",
+			dev_err(dev, "Cannot set RSS key, err %d aq_err %d\n",
 				status, hw->adminq.rq_last_status);
 			return -EIO;
 		}
@@ -4778,8 +4778,7 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		status = ice_aq_set_rss_lut(hw, vsi->idx, vsi->rss_lut_type,
 					    lut, lut_size);
 		if (status) {
-			dev_err(&pf->pdev->dev,
-				"Cannot set RSS lut, err %d aq_err %d\n",
+			dev_err(dev, "Cannot set RSS lut, err %d aq_err %d\n",
 				status, hw->adminq.rq_last_status);
 			return -EIO;
 		}
@@ -4802,15 +4801,16 @@ int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
+	struct device *dev;
 
+	dev = ice_pf_to_dev(pf);
 	if (seed) {
 		struct ice_aqc_get_set_rss_keys *buf =
 				  (struct ice_aqc_get_set_rss_keys *)seed;
 
 		status = ice_aq_get_rss_key(hw, vsi->idx, buf);
 		if (status) {
-			dev_err(&pf->pdev->dev,
-				"Cannot get RSS key, err %d aq_err %d\n",
+			dev_err(dev, "Cannot get RSS key, err %d aq_err %d\n",
 				status, hw->adminq.rq_last_status);
 			return -EIO;
 		}
@@ -4820,8 +4820,7 @@ int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		status = ice_aq_get_rss_lut(hw, vsi->idx, vsi->rss_lut_type,
 					    lut, lut_size);
 		if (status) {
-			dev_err(&pf->pdev->dev,
-				"Cannot get RSS lut, err %d aq_err %d\n",
+			dev_err(dev, "Cannot get RSS lut, err %d aq_err %d\n",
 				status, hw->adminq.rq_last_status);
 			return -EIO;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 565fc9780ebe..269204ca0b1d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -185,12 +185,14 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 {
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
+	struct device *dev;
 	int first, last, v;
 	struct ice_hw *hw;
 
 	hw = &pf->hw;
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
+	dev = ice_pf_to_dev(pf);
 	wr32(hw, VPINT_ALLOC(vf->vf_id), 0);
 	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), 0);
 
@@ -209,13 +211,12 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 	if (vsi->tx_mapping_mode == ICE_VSI_MAP_CONTIG)
 		wr32(hw, VPLAN_TX_QBASE(vf->vf_id), 0);
 	else
-		dev_err(&pf->pdev->dev,
-			"Scattered mode for VF Tx queues is not yet implemented\n");
+		dev_err(dev, "Scattered mode for VF Tx queues is not yet implemented\n");
 
 	if (vsi->rx_mapping_mode == ICE_VSI_MAP_CONTIG)
 		wr32(hw, VPLAN_RX_QBASE(vf->vf_id), 0);
 	else
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"Scattered mode for VF Rx queues is not yet implemented\n");
 }
 
@@ -290,6 +291,7 @@ static void ice_dis_vf_qs(struct ice_vf *vf)
  */
 void ice_free_vfs(struct ice_pf *pf)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	int tmp, i;
 
@@ -311,7 +313,7 @@ void ice_free_vfs(struct ice_pf *pf)
 	if (!pci_vfs_assigned(pf->pdev))
 		pci_disable_sriov(pf->pdev);
 	else
-		dev_warn(&pf->pdev->dev, "VFs are assigned - not disabling SR-IOV\n");
+		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
 	tmp = pf->num_alloc_vfs;
 	pf->num_vf_qps = 0;
@@ -326,10 +328,9 @@ void ice_free_vfs(struct ice_pf *pf)
 	}
 
 	if (ice_sriov_free_msix_res(pf))
-		dev_err(&pf->pdev->dev,
-			"Failed to free MSIX resources used by SR-IOV\n");
+		dev_err(dev, "Failed to free MSIX resources used by SR-IOV\n");
 
-	devm_kfree(&pf->pdev->dev, pf->vf);
+	devm_kfree(dev, pf->vf);
 	pf->vf = NULL;
 
 	/* This check is for when the driver is unloaded while VFs are
@@ -368,9 +369,11 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 {
 	struct ice_pf *pf = vf->pf;
 	u32 reg, reg_idx, bit_idx;
+	struct device *dev;
 	struct ice_hw *hw;
 	int vf_abs_id, i;
 
+	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
 	vf_abs_id = vf->vf_id + hw->func_caps.vf_base_id;
 
@@ -416,7 +419,7 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 		if ((reg & VF_TRANS_PENDING_M) == 0)
 			break;
 
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"VF %d PCI transactions stuck\n", vf->vf_id);
 		udelay(ICE_PCI_CIAD_WAIT_DELAY_US);
 	}
@@ -532,14 +535,16 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	LIST_HEAD(tmp_add_list);
 	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
+	struct device *dev;
 	int status = 0;
 
+	dev = ice_pf_to_dev(pf);
 	/* first vector index is the VFs OICR index */
 	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
 
 	vsi = ice_vf_vsi_setup(pf, pf->hw.port_info, vf->vf_id);
 	if (!vsi) {
-		dev_err(&pf->pdev->dev, "Failed to create VF VSI\n");
+		dev_err(dev, "Failed to create VF VSI\n");
 		return -ENOMEM;
 	}
 
@@ -567,8 +572,7 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 
 	status = ice_add_mac(&pf->hw, &tmp_add_list);
 	if (status)
-		dev_err(&pf->pdev->dev,
-			"could not add mac filters error %d\n", status);
+		dev_err(dev, "could not add mac filters error %d\n", status);
 	else
 		vf->num_mac = 1;
 
@@ -579,7 +583,7 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	 * more vectors.
 	 */
 ice_alloc_vsi_res_exit:
-	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+	ice_free_fltr_list(dev, &tmp_add_list);
 	return status;
 }
 
@@ -635,10 +639,12 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 	int abs_vf_id, abs_first, abs_last;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
+	struct device *dev;
 	int first, last, v;
 	struct ice_hw *hw;
 	u32 reg;
 
+	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	first = vf->first_vector_idx;
@@ -686,8 +692,7 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 			VPLAN_TX_QBASE_VFNUMQ_M));
 		wr32(hw, VPLAN_TX_QBASE(vf->vf_id), reg);
 	} else {
-		dev_err(&pf->pdev->dev,
-			"Scattered mode for VF Tx queues is not yet implemented\n");
+		dev_err(dev, "Scattered mode for VF Tx queues is not yet implemented\n");
 	}
 
 	/* set regardless of mapping mode */
@@ -705,8 +710,7 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 			VPLAN_RX_QBASE_VFNUMQ_M));
 		wr32(hw, VPLAN_RX_QBASE(vf->vf_id), reg);
 	} else {
-		dev_err(&pf->pdev->dev,
-			"Scattered mode for VF Rx queues is not yet implemented\n");
+		dev_err(dev, "Scattered mode for VF Rx queues is not yet implemented\n");
 	}
 }
 
@@ -852,6 +856,7 @@ static int ice_check_avail_res(struct ice_pf *pf)
 {
 	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
 	u16 num_msix, num_txq, num_rxq, num_avail_msix;
+	struct device *dev = ice_pf_to_dev(pf);
 
 	if (!pf->num_alloc_vfs || max_valid_res_idx < 0)
 		return -EINVAL;
@@ -884,8 +889,7 @@ static int ice_check_avail_res(struct ice_pf *pf)
 					     ICE_DFLT_INTR_PER_VF,
 					     ICE_MIN_INTR_PER_VF);
 	} else {
-		dev_err(&pf->pdev->dev,
-			"Number of VFs %d exceeds max VF count %d\n",
+		dev_err(dev, "Number of VFs %d exceeds max VF count %d\n",
 			pf->num_alloc_vfs, ICE_MAX_VF_COUNT);
 		return -EIO;
 	}
@@ -1023,12 +1027,12 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m,
  */
 static bool ice_config_res_vfs(struct ice_pf *pf)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	int v;
 
 	if (ice_check_avail_res(pf)) {
-		dev_err(&pf->pdev->dev,
-			"Cannot allocate VF resources, try with fewer number of VFs\n");
+		dev_err(dev, "Cannot allocate VF resources, try with fewer number of VFs\n");
 		return false;
 	}
 
@@ -1041,9 +1045,8 @@ static bool ice_config_res_vfs(struct ice_pf *pf)
 		struct ice_vf *vf = &pf->vf[v];
 
 		vf->num_vf_qs = pf->num_vf_qps;
-		dev_dbg(&pf->pdev->dev,
-			"VF-id %d has %d queues configured\n",
-			vf->vf_id, vf->num_vf_qs);
+		dev_dbg(dev, "VF-id %d has %d queues configured\n", vf->vf_id,
+			vf->num_vf_qs);
 		ice_cleanup_and_realloc_vf(vf);
 	}
 
@@ -1067,6 +1070,7 @@ static bool ice_config_res_vfs(struct ice_pf *pf)
  */
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	struct ice_vf *vf;
 	int v, i;
@@ -1125,7 +1129,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	 * time, but continue on with the operation.
 	 */
 	if (v < pf->num_alloc_vfs)
-		dev_warn(&pf->pdev->dev, "VF reset check timeout\n");
+		dev_warn(dev, "VF reset check timeout\n");
 
 	/* free VF resources to begin resetting the VSI state */
 	for (v = 0; v < pf->num_alloc_vfs; v++) {
@@ -1142,8 +1146,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	}
 
 	if (ice_sriov_free_msix_res(pf))
-		dev_err(&pf->pdev->dev,
-			"Failed to free MSIX resources used by SR-IOV\n");
+		dev_err(dev, "Failed to free MSIX resources used by SR-IOV\n");
 
 	if (!ice_config_res_vfs(pf))
 		return false;
@@ -1181,16 +1184,18 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 {
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
+	struct device *dev;
 	struct ice_hw *hw;
 	bool rsd = false;
 	u8 promisc_m;
 	u32 reg;
 	int i;
 
+	dev = ice_pf_to_dev(pf);
+
 	if (ice_is_vf_disabled(vf)) {
-		dev_dbg(&pf->pdev->dev,
-			"VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
-			 vf->vf_id);
+		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
+			vf->vf_id);
 		return true;
 	}
 
@@ -1232,8 +1237,7 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	 * continue on with the operation.
 	 */
 	if (!rsd)
-		dev_warn(&pf->pdev->dev, "VF reset check timeout on VF %d\n",
-			 vf->vf_id);
+		dev_warn(dev, "VF reset check timeout on VF %d\n", vf->vf_id);
 
 	/* disable promiscuous modes in case they were enabled
 	 * ignore any error if disabling process failed
@@ -1247,7 +1251,7 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 		vsi = pf->vsi[vf->lan_vsi_idx];
 		if (ice_vf_set_vsi_promisc(vf, vsi, promisc_m, true))
-			dev_err(&pf->pdev->dev, "disabling promiscuous mode failed\n");
+			dev_err(dev, "disabling promiscuous mode failed\n");
 	}
 
 	/* free VF resources to begin resetting the VSI state */
@@ -1325,6 +1329,7 @@ static void ice_vc_notify_vf_reset(struct ice_vf *vf)
  */
 static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	struct ice_vf *vfs;
 	int i, ret;
@@ -1341,8 +1346,7 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 		goto err_unroll_intr;
 	}
 	/* allocate memory */
-	vfs = devm_kcalloc(&pf->pdev->dev, num_alloc_vfs, sizeof(*vfs),
-			   GFP_KERNEL);
+	vfs = devm_kcalloc(dev, num_alloc_vfs, sizeof(*vfs), GFP_KERNEL);
 	if (!vfs) {
 		ret = -ENOMEM;
 		goto err_pci_disable_sriov;
@@ -1371,7 +1375,7 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 
 err_unroll_sriov:
 	pf->vf = NULL;
-	devm_kfree(&pf->pdev->dev, vfs);
+	devm_kfree(dev, vfs);
 	vfs = NULL;
 	pf->num_alloc_vfs = 0;
 err_pci_disable_sriov:
@@ -1416,7 +1420,7 @@ static bool ice_pf_state_is_nominal(struct ice_pf *pf)
 static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 {
 	int pre_existing_vfs = pci_num_vf(pf->pdev);
-	struct device *dev = &pf->pdev->dev;
+	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
 	if (!ice_pf_state_is_nominal(pf)) {
@@ -1461,10 +1465,10 @@ static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
+	struct device *dev = ice_pf_to_dev(pf);
 
 	if (ice_is_safe_mode(pf)) {
-		dev_err(&pf->pdev->dev,
-			"SR-IOV cannot be configured - Device is in Safe Mode\n");
+		dev_err(dev, "SR-IOV cannot be configured - Device is in Safe Mode\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1474,8 +1478,7 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (!pci_vfs_assigned(pdev)) {
 		ice_free_vfs(pf);
 	} else {
-		dev_err(&pf->pdev->dev,
-			"can't free VFs because some are assigned to VMs.\n");
+		dev_err(dev, "can't free VFs because some are assigned to VMs.\n");
 		return -EBUSY;
 	}
 
@@ -1538,6 +1541,7 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
 {
 	enum ice_status aq_ret;
+	struct device *dev;
 	struct ice_pf *pf;
 
 	/* validate the request */
@@ -1546,16 +1550,18 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 
 	pf = vf->pf;
 
+	dev = ice_pf_to_dev(pf);
+
 	/* single place to detect unsuccessful return values */
 	if (v_retval) {
 		vf->num_inval_msgs++;
-		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
-			 vf->vf_id, v_opcode, v_retval);
+		dev_info(dev, "VF %d failed opcode %d, retval: %d\n", vf->vf_id,
+			 v_opcode, v_retval);
 		if (vf->num_inval_msgs > ICE_DFLT_NUM_INVAL_MSGS_ALLOWED) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"Number of invalid messages exceeded for VF %d\n",
 				vf->vf_id);
-			dev_err(&pf->pdev->dev, "Use PF Control I/F to enable the VF\n");
+			dev_err(dev, "Use PF Control I/F to enable the VF\n");
 			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
 			return -EIO;
 		}
@@ -1568,7 +1574,7 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
 				       msg, msglen, NULL);
 	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
-		dev_info(&pf->pdev->dev,
+		dev_info(dev,
 			 "Unable to send the message to VF %d ret %d aq_err %d\n",
 			 vf->vf_id, aq_ret, pf->hw.mailboxq.sq_last_status);
 		return -EIO;
@@ -2273,7 +2279,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 	if (qci->num_queue_pairs > ICE_MAX_BASE_QS_PER_VF ||
 	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
-		dev_err(&pf->pdev->dev,
+		dev_err(ice_pf_to_dev(pf),
 			"VF-%d requesting more than supported number of queues: %d\n",
 			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2386,9 +2392,12 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 	enum virtchnl_ops vc_op;
 	enum ice_status status;
 	struct ice_vsi *vsi;
+	struct device *dev;
 	int mac_count = 0;
 	int i;
 
+	dev = ice_pf_to_dev(pf);
+
 	if (set)
 		vc_op = VIRTCHNL_OP_ADD_ETH_ADDR;
 	else
@@ -2402,7 +2411,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 
 	if (set && !ice_is_vf_trusted(vf) &&
 	    (vf->num_mac + al->num_elements) > ICE_MAX_MACADDR_PER_VF) {
-		dev_err(&pf->pdev->dev,
+		dev_err(dev,
 			"Can't add more MAC addresses, because VF-%d is not trusted, switch the VF to trusted mode in order to add more functionalities\n",
 			vf->vf_id);
 		/* There is no need to let VF know about not being trusted
@@ -2427,13 +2436,13 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 				/* VF is trying to add filters that the PF
 				 * already added. Just continue.
 				 */
-				dev_info(&pf->pdev->dev,
+				dev_info(dev,
 					 "MAC %pM already set for VF %d\n",
 					 maddr, vf->vf_id);
 				continue;
 			} else {
 				/* VF can't remove dflt_lan_addr/bcast MAC */
-				dev_err(&pf->pdev->dev,
+				dev_err(dev,
 					"VF can't remove default MAC address or MAC %pM programmed by PF for VF %d\n",
 					maddr, vf->vf_id);
 				continue;
@@ -2442,7 +2451,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 
 		/* check for the invalid cases and bail if necessary */
 		if (is_zero_ether_addr(maddr)) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"invalid MAC %pM provided for VF %d\n",
 				maddr, vf->vf_id);
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2451,7 +2460,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 
 		if (is_unicast_ether_addr(maddr) &&
 		    !ice_can_vf_change_mac(vf)) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"can't change unicast MAC for untrusted VF %d\n",
 				vf->vf_id);
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2462,12 +2471,12 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 		status = ice_vsi_cfg_mac_fltr(vsi, maddr, set);
 		if (status == ICE_ERR_DOES_NOT_EXIST ||
 		    status == ICE_ERR_ALREADY_EXISTS) {
-			dev_info(&pf->pdev->dev,
+			dev_info(dev,
 				 "can't %s MAC filters %pM for VF %d, error %d\n",
 				 set ? "add" : "remove", maddr, vf->vf_id,
 				 status);
 		} else if (status) {
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"can't %s MAC filters for VF %d, error %d\n",
 				set ? "add" : "remove", vf->vf_id, status);
 			v_ret = ice_err_to_virt_err(status);
@@ -2532,7 +2541,9 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	u16 max_allowed_vf_queues;
 	u16 tx_rx_queue_left;
 	u16 cur_queues;
+	struct device *dev;
 
+	dev = ice_pf_to_dev(pf);
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2543,17 +2554,15 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 				 ice_get_avail_rxq_count(pf));
 	max_allowed_vf_queues = tx_rx_queue_left + cur_queues;
 	if (!req_queues) {
-		dev_err(&pf->pdev->dev,
-			"VF %d tried to request 0 queues. Ignoring.\n",
+		dev_err(dev, "VF %d tried to request 0 queues. Ignoring.\n",
 			vf->vf_id);
 	} else if (req_queues > ICE_MAX_BASE_QS_PER_VF) {
-		dev_err(&pf->pdev->dev,
-			"VF %d tried to request more than %d queues.\n",
+		dev_err(dev, "VF %d tried to request more than %d queues.\n",
 			vf->vf_id, ICE_MAX_BASE_QS_PER_VF);
 		vfres->num_queue_pairs = ICE_MAX_BASE_QS_PER_VF;
 	} else if (req_queues > cur_queues &&
 		   req_queues - cur_queues > tx_rx_queue_left) {
-		dev_warn(&pf->pdev->dev,
+		dev_warn(dev,
 			 "VF %d requested %u more queues, but only %u left.\n",
 			 vf->vf_id, req_queues - cur_queues, tx_rx_queue_left);
 		vfres->num_queue_pairs = min_t(u16, max_allowed_vf_queues,
@@ -2562,8 +2571,7 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 		/* request is successful, then reset VF */
 		vf->num_req_qs = req_queues;
 		ice_vc_reset_vf(vf);
-		dev_info(&pf->pdev->dev,
-			 "VF %d granted request of %u queues.\n",
+		dev_info(dev, "VF %d granted request of %u queues.\n",
 			 vf->vf_id, req_queues);
 		return 0;
 	}
@@ -2592,36 +2600,37 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_pf *pf = np->vsi->back;
 	struct ice_vsi *vsi;
+	struct device *dev;
 	struct ice_vf *vf;
 	int ret = 0;
 
+	dev = ice_pf_to_dev(pf);
 	/* validate the request */
 	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(&pf->pdev->dev, "invalid VF id: %d\n", vf_id);
+		dev_err(dev, "invalid VF id: %d\n", vf_id);
 		return -EINVAL;
 	}
 
 	if (vlan_id > ICE_MAX_VLANID || qos > 7) {
-		dev_err(&pf->pdev->dev, "Invalid VF Parameters\n");
+		dev_err(dev, "Invalid VF Parameters\n");
 		return -EINVAL;
 	}
 
 	if (vlan_proto != htons(ETH_P_8021Q)) {
-		dev_err(&pf->pdev->dev, "VF VLAN protocol is not supported\n");
+		dev_err(dev, "VF VLAN protocol is not supported\n");
 		return -EPROTONOSUPPORT;
 	}
 
 	vf = &pf->vf[vf_id];
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(&pf->pdev->dev, "VF %d in reset. Try again.\n", vf_id);
+		dev_err(dev, "VF %d in reset. Try again.\n", vf_id);
 		return -EBUSY;
 	}
 
 	if (le16_to_cpu(vsi->info.pvid) == vlanprio) {
 		/* duplicate request, so just return success */
-		dev_info(&pf->pdev->dev,
-			 "Duplicate pvid %d request\n", vlanprio);
+		dev_dbg(dev, "Duplicate pvid %d request\n", vlanprio);
 		return ret;
 	}
 
@@ -2640,7 +2649,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	}
 
 	if (vlan_id) {
-		dev_info(&pf->pdev->dev, "Setting VLAN %d, QOS 0x%x on VF %d\n",
+		dev_info(dev, "Setting VLAN %d, QoS 0x%x on VF %d\n",
 			 vlan_id, qos, vf_id);
 
 		/* add new VLAN filter for each MAC */
@@ -2685,11 +2694,13 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	struct ice_pf *pf = vf->pf;
 	bool vlan_promisc = false;
 	struct ice_vsi *vsi;
+	struct device *dev;
 	struct ice_hw *hw;
 	int status = 0;
 	u8 promisc_m;
 	int i;
 
+	dev = ice_pf_to_dev(pf);
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2707,7 +2718,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 
 	if (add_v && !ice_is_vf_trusted(vf) &&
 	    vf->num_vlan >= ICE_MAX_VLAN_PER_VF) {
-		dev_info(&pf->pdev->dev,
+		dev_info(dev,
 			 "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
 			 vf->vf_id);
 		/* There is no need to let VF know about being not trusted,
@@ -2719,7 +2730,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	for (i = 0; i < vfl->num_elements; i++) {
 		if (vfl->vlan_id[i] > ICE_MAX_VLANID) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"invalid VF VLAN id %d\n", vfl->vlan_id[i]);
 			goto error_param;
 		}
@@ -2747,7 +2758,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 
 			if (!ice_is_vf_trusted(vf) &&
 			    vf->num_vlan >= ICE_MAX_VLAN_PER_VF) {
-				dev_info(&pf->pdev->dev,
+				dev_info(dev,
 					 "VF-%d is not trusted, switch the VF to trusted mode, in order to add more VLAN addresses\n",
 					 vf->vf_id);
 				/* There is no need to let VF know about being
@@ -2768,7 +2779,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 				status = ice_cfg_vlan_pruning(vsi, true, false);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(&pf->pdev->dev,
+					dev_err(dev,
 						"Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
 						vid, status);
 					goto error_param;
@@ -2782,7 +2793,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 							     promisc_m, vid);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-					dev_err(&pf->pdev->dev,
+					dev_err(dev,
 						"Enable Unicast/multicast promiscuous mode on VLAN ID:%d failed error-%d\n",
 						vid, status);
 				}
@@ -2969,8 +2980,10 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	u16 msglen = event->msg_len;
 	u8 *msg = event->msg_buf;
 	struct ice_vf *vf = NULL;
+	struct device *dev;
 	int err = 0;
 
+	dev = ice_pf_to_dev(pf);
 	if (vf_id >= pf->num_alloc_vfs) {
 		err = -EINVAL;
 		goto error_handler;
@@ -2997,7 +3010,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	if (err) {
 		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
 				      NULL, 0);
-		dev_err(&pf->pdev->dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
+		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
 			vf_id, v_opcode, msglen, err);
 		return;
 	}
@@ -3009,7 +3022,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_GET_VF_RESOURCES:
 		err = ice_vc_get_vf_res_msg(vf, msg);
 		if (ice_vf_init_vlan_stripping(vf))
-			dev_err(&pf->pdev->dev,
+			dev_err(dev,
 				"Failed to initialize VLAN stripping for VF %d\n",
 				vf->vf_id);
 		ice_vc_notify_vf_link_state(vf);
@@ -3062,8 +3075,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
-		dev_err(&pf->pdev->dev, "Unsupported opcode %d from VF %d\n",
-			v_opcode, vf_id);
+		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
+			vf_id);
 		err = ice_vc_send_msg_to_vf(vf, v_opcode,
 					    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
 					    NULL, 0);
@@ -3073,8 +3086,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		/* Helper function cares less about error return values here
 		 * as it is busy with pending work.
 		 */
-		dev_info(&pf->pdev->dev,
-			 "PF failed to honor VF %d, opcode %d, error %d\n",
+		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
 			 vf_id, v_opcode, err);
 	}
 }
@@ -3145,9 +3157,12 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	struct ice_pf *pf = vsi->back;
 	struct ice_vsi_ctx *ctx;
 	enum ice_status status;
+	struct device *dev;
 	struct ice_vf *vf;
 	int ret = 0;
 
+	dev = ice_pf_to_dev(pf);
+
 	/* validate the request */
 	if (vf_id >= pf->num_alloc_vfs) {
 		netdev_err(netdev, "invalid VF id: %d\n", vf_id);
@@ -3161,7 +3176,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	}
 
 	if (ena == vf->spoofchk) {
-		dev_dbg(&pf->pdev->dev, "VF spoofchk already %s\n",
+		dev_dbg(dev, "VF spoofchk already %s\n",
 			ena ? "ON" : "OFF");
 		return 0;
 	}
@@ -3179,7 +3194,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 
 	status = ice_update_vsi(&pf->hw, vsi->idx, ctx, NULL);
 	if (status) {
-		dev_dbg(&pf->pdev->dev,
+		dev_dbg(dev,
 			"Error %d, failed to update VSI* parameters\n", status);
 		ret = -EIO;
 		goto out;
@@ -3280,11 +3295,14 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct device *dev;
 	struct ice_vf *vf;
 
+	dev = ice_pf_to_dev(pf);
+
 	/* validate the request */
 	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(&pf->pdev->dev, "invalid VF id: %d\n", vf_id);
+		dev_err(dev, "invalid VF id: %d\n", vf_id);
 		return -EINVAL;
 	}
 
@@ -3299,7 +3317,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	ice_wait_on_vf_reset(vf);
 
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(&pf->pdev->dev, "VF %d in reset. Try again.\n", vf_id);
+		dev_err(dev, "VF %d in reset. Try again.\n", vf_id);
 		return -EBUSY;
 	}
 
@@ -3309,7 +3327,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 
 	vf->trusted = trusted;
 	ice_vc_reset_vf(vf);
-	dev_info(&pf->pdev->dev, "VF %u is now %strusted\n",
+	dev_info(dev, "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
 	return 0;
@@ -3329,11 +3347,14 @@ int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 	struct ice_pf *pf = np->vsi->back;
 	struct virtchnl_pf_event pfe = { 0 };
 	struct ice_link_status *ls;
+	struct device *dev;
 	struct ice_vf *vf;
 	struct ice_hw *hw;
 
+	dev = ice_pf_to_dev(pf);
+
 	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(&pf->pdev->dev, "Invalid VF Identifier %d\n", vf_id);
+		dev_err(dev, "Invalid VF Identifier %d\n", vf_id);
 		return -EINVAL;
 	}
 
@@ -3342,7 +3363,7 @@ int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 	ls = &pf->hw.port_info->phy.link_info;
 
 	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(&pf->pdev->dev, "vf %d in reset. Try again.\n", vf_id);
+		dev_err(dev, "vf %d in reset. Try again.\n", vf_id);
 		return -EBUSY;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index fcffad0069d6..cf9b8b22d24f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -331,7 +331,7 @@ static int ice_xsk_umem_dma_map(struct ice_vsi *vsi, struct xdp_umem *umem)
 	struct device *dev;
 	unsigned int i;
 
-	dev = &pf->pdev->dev;
+	dev = ice_pf_to_dev(pf);
 	for (i = 0; i < umem->npgs; i++) {
 		dma_addr_t dma = dma_map_page_attrs(dev, umem->pgs[i], 0,
 						    PAGE_SIZE,
@@ -369,7 +369,7 @@ static void ice_xsk_umem_dma_unmap(struct ice_vsi *vsi, struct xdp_umem *umem)
 	struct device *dev;
 	unsigned int i;
 
-	dev = &pf->pdev->dev;
+	dev = ice_pf_to_dev(pf);
 	for (i = 0; i < umem->npgs; i++) {
 		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
 				     DMA_BIDIRECTIONAL, ICE_RX_DMA_ATTR);
-- 
2.23.0

