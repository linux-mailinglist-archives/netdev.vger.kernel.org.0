Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666A33685ED
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhDVRa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:60043 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238481AbhDVRaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:13 -0400
IronPort-SDR: R2QuNyHhOcoCwz0zRqv6WBwe2zO7WcUmfD6mPW9mK2OSrP8ZcN8+kpb4yAgrIrVIXyrQrGJd7A
 yzwE94XA4OTQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991482"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991482"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:35 -0700
IronPort-SDR: 5XfRWv2s2ZiSl/sM8F+1HfuCAIYT7fxkbHVkHm7EjfcA360PppY1VM/TRwW4KycnUMFEvSJ9SM
 NbjaIpcsLQRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286277"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 06/12] ice: Add helper function to get the VF's VSI
Date:   Thu, 22 Apr 2021 10:31:24 -0700
Message-Id: <20210422173130.1143082-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, the driver gets the VF's VSI by using a long string of
dereferences (i.e. vf->pf->vsi[vf->lan_vsi_idx]). If the method to get
the VF's VSI were to change the driver would have to change it in every
location. Fix this by adding the helper ice_get_vf_vsi().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 82 +++++++++----------
 1 file changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c40560a9443b..baada80c98ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -7,6 +7,15 @@
 #include "ice_fltr.h"
 #include "ice_virtchnl_allowlist.h"
 
+/**
+ * ice_get_vf_vsi - get VF's VSI based on the stored index
+ * @vf: VF used to get VSI
+ */
+static struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf)
+{
+	return vf->pf->vsi[vf->lan_vsi_idx];
+}
+
 /**
  * ice_validate_vf_id - helper to check if VF ID is valid
  * @pf: pointer to the PF structure
@@ -198,7 +207,7 @@ static void ice_vf_invalidate_vsi(struct ice_vf *vf)
  */
 static void ice_vf_vsi_release(struct ice_vf *vf)
 {
-	ice_vsi_release(vf->pf->vsi[vf->lan_vsi_idx]);
+	ice_vsi_release(ice_get_vf_vsi(vf));
 	ice_vf_invalidate_vsi(vf);
 }
 
@@ -274,7 +283,7 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 	struct ice_hw *hw;
 
 	hw = &pf->hw;
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 
 	dev = ice_pf_to_dev(pf);
 	wr32(hw, VPINT_ALLOC(vf->vf_id), 0);
@@ -349,10 +358,7 @@ void ice_set_vf_state_qs_dis(struct ice_vf *vf)
  */
 static void ice_dis_vf_qs(struct ice_vf *vf)
 {
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
 	ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
 	ice_vsi_stop_all_rx_rings(vsi);
@@ -639,8 +645,8 @@ static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
  */
 static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
 	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	u16 vlan_id = 0;
 	int err;
 
@@ -676,8 +682,8 @@ static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
  */
 static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
 	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	enum ice_status status;
 	u8 broadcast[ETH_ALEN];
 
@@ -778,8 +784,8 @@ static void ice_ena_vf_msix_mappings(struct ice_vf *vf)
  */
 static void ice_ena_vf_q_mappings(struct ice_vf *vf, u16 max_txq, u16 max_rxq)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
 	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	struct ice_hw *hw = &vf->pf->hw;
 	u32 reg;
 
@@ -826,7 +832,7 @@ static void ice_ena_vf_q_mappings(struct ice_vf *vf, u16 max_txq, u16 max_rxq)
  */
 static void ice_ena_vf_mappings(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
 	ice_ena_vf_msix_mappings(vf);
 	ice_ena_vf_q_mappings(vf, vsi->alloc_txq, vsi->alloc_rxq);
@@ -1089,7 +1095,7 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m,
 
 static void ice_vf_clear_counters(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
 	vf->num_mac = 0;
 	vsi->num_vlan = 0;
@@ -1149,8 +1155,8 @@ static void ice_vf_rebuild_aggregator_node_cfg(struct ice_vsi *vsi)
  */
 static void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
 	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
 	ice_vf_set_host_trust_cfg(vf);
 
@@ -1190,10 +1196,8 @@ static int ice_vf_rebuild_vsi_with_release(struct ice_vf *vf)
  */
 static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 {
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-
-	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	if (ice_vsi_rebuild(vsi, true)) {
 		dev_err(ice_pf_to_dev(pf), "failed to rebuild VF %d VSI\n",
@@ -1392,7 +1396,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	set_bit(ICE_VF_STATE_DIS, vf->vf_states);
 	ice_trigger_vf_reset(vf, is_vflr, false);
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 
 	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
 		ice_dis_vf_qs(vf);
@@ -1441,7 +1445,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		else
 			promisc_m = ICE_UCAST_PROMISC_BITS;
 
-		vsi = pf->vsi[vf->lan_vsi_idx];
+		vsi = ice_get_vf_vsi(vf);
 		if (ice_vf_set_vsi_promisc(vf, vsi, promisc_m, true))
 			dev_err(dev, "disabling promiscuous mode failed\n");
 	}
@@ -1887,7 +1891,7 @@ static struct ice_vf *ice_get_vf_from_pfq(struct ice_pf *pf, u16 pfq)
 		struct ice_vsi *vsi;
 		u16 rxq_idx;
 
-		vsi = pf->vsi[vf->lan_vsi_idx];
+		vsi = ice_get_vf_vsi(vf);
 
 		ice_for_each_rxq(vsi, rxq_idx)
 			if (vsi->rxq_map[rxq_idx] == pfq)
@@ -2027,8 +2031,7 @@ static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
  */
 static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
-	struct ice_port_info *pi = vsi->port_info;
+	struct ice_port_info *pi = ice_vf_get_port_info(vf);
 	u16 max_frame_size;
 
 	max_frame_size = pi->phy.link_info.max_frame_size;
@@ -2076,7 +2079,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 				  VIRTCHNL_VF_OFFLOAD_VLAN;
 
 	vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto err;
@@ -2243,7 +2246,6 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_rss_key *vrk =
 		(struct virtchnl_rss_key *)msg;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -2266,7 +2268,7 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2290,7 +2292,6 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 {
 	struct virtchnl_rss_lut *vrl = (struct virtchnl_rss_lut *)msg;
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -2313,7 +2314,7 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2396,7 +2397,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	if (ret)
 		return ret;
 
-	vf_vsi = pf->vsi[vf->lan_vsi_idx];
+	vf_vsi = ice_get_vf_vsi(vf);
 	if (!vf_vsi) {
 		netdev_err(netdev, "VSI %d for VF %d is null\n",
 			   vf->lan_vsi_idx, vf->vf_id);
@@ -2501,7 +2502,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2637,7 +2638,6 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 	struct virtchnl_queue_select *vqs =
 		(struct virtchnl_queue_select *)msg;
 	struct ice_eth_stats stats = { 0 };
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -2650,7 +2650,7 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2740,7 +2740,6 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_queue_select *vqs =
 	    (struct virtchnl_queue_select *)msg;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	unsigned long q_map;
 	u16 vf_q_id;
@@ -2760,7 +2759,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2830,7 +2829,6 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_queue_select *vqs =
 	    (struct virtchnl_queue_select *)msg;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	unsigned long q_map;
 	u16 vf_q_id;
@@ -2851,7 +2849,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -3016,7 +3014,7 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -3093,7 +3091,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -3328,7 +3326,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 		goto handle_mac_exit;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto handle_mac_exit;
@@ -3560,7 +3558,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	}
 
 	hw = &pf->hw;
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -3727,7 +3725,6 @@ static int ice_vc_remove_vlan_msg(struct ice_vf *vf, u8 *msg)
 static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -3740,7 +3737,7 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (ice_vsi_manage_vlan_stripping(vsi, true))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
@@ -3758,7 +3755,6 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -3771,7 +3767,7 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 		goto error_param;
 	}
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -3797,7 +3793,7 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
  */
 static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 {
-	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
 	if (!vsi)
 		return -EINVAL;
@@ -4185,7 +4181,7 @@ int ice_get_vf_stats(struct net_device *netdev, int vf_id,
 	if (ret)
 		return ret;
 
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi)
 		return -EINVAL;
 
-- 
2.26.2

