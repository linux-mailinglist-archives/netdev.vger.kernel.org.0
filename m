Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2651DF54B
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbgEWGtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387694AbgEWGs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:48:57 -0400
IronPort-SDR: 9Aby8n29doYIx9ZZxyIfGFIiyj/1D6vz3O8hgJnmSJ5El0R0THS1JV12qNMzKYz7ogbpnBIHNw
 3JLmidM7OE6A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:50 -0700
IronPort-SDR: OnCx9kuf4Pee01cKiVC6HEI+nugdgYdkdnL4gOwj9aNFzcvE1b7YCAyIV4pE723UnbBFGgorsM
 wwMBjn1H5oxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966893"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/16] ice: Restore filters following reset
Date:   Fri, 22 May 2020 23:48:38 -0700
Message-Id: <20200523064847.3972158-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Following a reset, Flow Director filters are cleared from the hardware.
Rebuild the filters using the software structures containing the filter
rules.

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  2 +
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 65 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c      | 17 +++--
 drivers/net/ethernet/intel/ice/ice_main.c     | 31 +++++++++
 4 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 298a65a3799c..38739ee8cd94 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -566,6 +566,8 @@ int
 ice_get_fdir_fltr_ids(struct ice_hw *hw, struct ethtool_rxnfc *cmd,
 		      u32 *rule_locs);
 void ice_fdir_release_flows(struct ice_hw *hw);
+void ice_fdir_replay_flows(struct ice_hw *hw);
+void ice_fdir_replay_fltrs(struct ice_pf *pf);
 int ice_fdir_create_dflt_rules(struct ice_pf *pf);
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index f240c062860b..a0002032be61 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -348,6 +348,53 @@ void ice_fdir_release_flows(struct ice_hw *hw)
 		ice_fdir_erase_flow_from_hw(hw, ICE_BLK_FD, flow);
 }
 
+/**
+ * ice_fdir_replay_flows - replay HW Flow Director filter info
+ * @hw: pointer to HW instance
+ */
+void ice_fdir_replay_flows(struct ice_hw *hw)
+{
+	int flow;
+
+	for (flow = 0; flow < ICE_FLTR_PTYPE_MAX; flow++) {
+		int tun;
+
+		if (!hw->fdir_prof[flow] || !hw->fdir_prof[flow]->cnt)
+			continue;
+		for (tun = 0; tun < ICE_FD_HW_SEG_MAX; tun++) {
+			struct ice_flow_prof *hw_prof;
+			struct ice_fd_hw_prof *prof;
+			u64 prof_id;
+			int j;
+
+			prof = hw->fdir_prof[flow];
+			prof_id = flow + tun * ICE_FLTR_PTYPE_MAX;
+			ice_flow_add_prof(hw, ICE_BLK_FD, ICE_FLOW_RX, prof_id,
+					  prof->fdir_seg[tun], TNL_SEG_CNT(tun),
+					  &hw_prof);
+			for (j = 0; j < prof->cnt; j++) {
+				enum ice_flow_priority prio;
+				u64 entry_h = 0;
+				int err;
+
+				prio = ICE_FLOW_PRIO_NORMAL;
+				err = ice_flow_add_entry(hw, ICE_BLK_FD,
+							 prof_id,
+							 prof->vsi_h[0],
+							 prof->vsi_h[j],
+							 prio, prof->fdir_seg,
+							 &entry_h);
+				if (err) {
+					dev_err(ice_hw_to_dev(hw), "Could not replay Flow Director, flow type %d\n",
+						flow);
+					continue;
+				}
+				prof->entry_h[j][tun] = entry_h;
+			}
+		}
+	}
+}
+
 /**
  * ice_parse_rx_flow_user_data - deconstruct user-defined data
  * @fsp: pointer to ethtool Rx flow specification
@@ -1225,6 +1272,24 @@ ice_fdir_write_all_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input,
 	return 0;
 }
 
+/**
+ * ice_fdir_replay_fltrs - replay filters from the HW filter list
+ * @pf: board private structure
+ */
+void ice_fdir_replay_fltrs(struct ice_pf *pf)
+{
+	struct ice_fdir_fltr *f_rule;
+	struct ice_hw *hw = &pf->hw;
+
+	list_for_each_entry(f_rule, &hw->fdir_list_head, fltr_node) {
+		int err = ice_fdir_write_all_fltr(pf, f_rule, true);
+
+		if (err)
+			dev_dbg(ice_pf_to_dev(pf), "Flow Director error %d, could not reprogram filter %d\n",
+				err, f_rule->fltr_id);
+	}
+}
+
 /**
  * ice_fdir_create_dflt_rules - create default perfect filters
  * @pf: PF data structure
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 43c949e0a760..ff77fc3f633e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2748,6 +2748,8 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		goto err_vsi;
 
 	ice_vsi_get_qs(vsi);
+
+	ice_alloc_fd_res(vsi);
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* Initialize VSI struct elements and create VSI in FW */
@@ -2756,6 +2758,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		goto err_vsi;
 
 	switch (vsi->type) {
+	case ICE_VSI_CTRL:
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
 		if (ret)
@@ -2780,12 +2783,14 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 			if (ret)
 				goto err_vectors;
 		}
-		/* Do not exit if configuring RSS had an issue, at least
-		 * receive traffic on first queue. Hence no need to capture
-		 * return value
-		 */
-		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
-			ice_vsi_cfg_rss_lut_key(vsi);
+		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
+		if (vsi->type != ICE_VSI_CTRL)
+			/* Do not exit if configuring RSS had an issue, at
+			 * least receive traffic on first queue. Hence no
+			 * need to capture return value
+			 */
+			if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
+				ice_vsi_cfg_rss_lut_key(vsi);
 		break;
 	case ICE_VSI_VF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fecc3b29a4de..d06a3311a2dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4895,6 +4895,21 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_sched_init_port;
 	}
 
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
+		wr32(hw, PFQF_FD_ENA, PFQF_FD_ENA_FD_ENA_M);
+		if (!rd32(hw, PFQF_FD_SIZE)) {
+			u16 unused, guar, b_effort;
+
+			guar = hw->func_caps.fd_fltr_guar;
+			b_effort = hw->func_caps.fd_fltr_best_effort;
+
+			/* force guaranteed filter pool for PF */
+			ice_alloc_fd_guar_item(hw, &unused, guar);
+			/* force shared filter pool for PF */
+			ice_alloc_fd_shrd_item(hw, &unused, b_effort);
+		}
+	}
+
 	if (test_bit(ICE_FLAG_DCB_ENA, pf->flags))
 		ice_dcb_rebuild(pf);
 
@@ -4913,6 +4928,22 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		}
 	}
 
+	/* If Flow Director is active */
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
+		err = ice_vsi_rebuild_by_type(pf, ICE_VSI_CTRL);
+		if (err) {
+			dev_err(dev, "control VSI rebuild failed: %d\n", err);
+			goto err_vsi_rebuild;
+		}
+
+		/* replay HW Flow Director recipes */
+		if (hw->fdir_prof)
+			ice_fdir_replay_flows(hw);
+
+		/* replay Flow Director filters */
+		ice_fdir_replay_fltrs(pf);
+	}
+
 	ice_update_pf_netdev_link(pf);
 
 	/* tell the firmware we are up */
-- 
2.26.2

