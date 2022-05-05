Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BEC51C9F4
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385602AbiEEUKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385580AbiEEUKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C644854FA5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781220; x=1683317220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4mK7ZTu2MC/jFTN8sUdSFrs5l5chCi4yyCNq16JsQNs=;
  b=K3uxkQ8dbbRFcej9157r9n19wv4AARbCRupphgol8vWMiMGgUz+y2pQL
   u4kcVop8D8xd2b0mjdLw7VMT57Hwe0+xV8afKTAL7qcpoR5U7sJ0BMWI1
   KLSBK5OkfRMd8gZqO0LPxNcnZct0X+rj2ikaoSlTN47K7jtgyolj/AD7t
   PvOwyzzPqWIBlDIFbhk+S4JpfnZaIy38cm2obsbl7DUWKH/HZcOboaKKb
   9P+0f0UiVXK0UGfYrzydMCApJNlQtPnsW/osBKKPG3ZhLQR3dHIBDwH7y
   a8MSgK2aXaijyhMDCGlqRraAlbM2itYPgMALgKRZzlqocQnYiCHWproOU
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="354672208"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="354672208"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111717"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:06:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 06/10] ice: always check VF VSI pointer values
Date:   Thu,  5 May 2022 13:03:55 -0700
Message-Id: <20220505200359.3080110-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
References: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_get_vf_vsi function can return NULL in some cases, such as if
handling messages during a reset where the VSI is being removed and
recreated.

Several places throughout the driver do not bother to check whether this
VSI pointer is valid. Static analysis tools maybe report issues because
they detect paths where a potentially NULL pointer could be dereferenced.

Fix this by checking the return value of ice_get_vf_vsi everywhere.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  5 ++-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  7 +++-
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 32 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 28 +++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  5 +++
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |  7 +++-
 6 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index d12852d698af..3991d62473bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -773,9 +773,12 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
 
 	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
-	vsi = ice_get_vf_vsi(vf);
 	devlink_port = &vf->devlink_port;
 
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi)
+		return -EINVAL;
+
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PCI_VF;
 	attrs.pci_vf.pf = pf->hw.bus.func;
 	attrs.pci_vf.vf = vf->vf_id;
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 848f2adea563..a91b81c3088b 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -293,8 +293,13 @@ static int ice_repr_add(struct ice_vf *vf)
 	struct ice_q_vector *q_vector;
 	struct ice_netdev_priv *np;
 	struct ice_repr *repr;
+	struct ice_vsi *vsi;
 	int err;
 
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi)
+		return -EINVAL;
+
 	repr = kzalloc(sizeof(*repr), GFP_KERNEL);
 	if (!repr)
 		return -ENOMEM;
@@ -313,7 +318,7 @@ static int ice_repr_add(struct ice_vf *vf)
 		goto err_alloc;
 	}
 
-	repr->src_vsi = ice_get_vf_vsi(vf);
+	repr->src_vsi = vsi;
 	repr->vf = vf;
 	vf->repr = repr;
 	np = netdev_priv(repr->netdev);
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 0c438219f7a3..bb1721f1321d 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -46,7 +46,12 @@ static void ice_free_vf_entries(struct ice_pf *pf)
  */
 static void ice_vf_vsi_release(struct ice_vf *vf)
 {
-	ice_vsi_release(ice_get_vf_vsi(vf));
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
+
+	if (WARN_ON(!vsi))
+		return;
+
+	ice_vsi_release(vsi);
 	ice_vf_invalidate_vsi(vf);
 }
 
@@ -104,6 +109,8 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 
 	hw = &pf->hw;
 	vsi = ice_get_vf_vsi(vf);
+	if (WARN_ON(!vsi))
+		return;
 
 	dev = ice_pf_to_dev(pf);
 	wr32(hw, VPINT_ALLOC(vf->vf_id), 0);
@@ -341,6 +348,9 @@ static void ice_ena_vf_q_mappings(struct ice_vf *vf, u16 max_txq, u16 max_rxq)
 	struct ice_hw *hw = &vf->pf->hw;
 	u32 reg;
 
+	if (WARN_ON(!vsi))
+		return;
+
 	/* set regardless of mapping mode */
 	wr32(hw, VPLAN_TXQ_MAPENA(vf->vf_id), VPLAN_TXQ_MAPENA_TX_ENA_M);
 
@@ -386,6 +396,9 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 {
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
+	if (WARN_ON(!vsi))
+		return;
+
 	ice_ena_vf_msix_mappings(vf);
 	ice_ena_vf_q_mappings(vf, vsi->alloc_txq, vsi->alloc_rxq);
 }
@@ -1128,6 +1141,8 @@ static struct ice_vf *ice_get_vf_from_pfq(struct ice_pf *pf, u16 pfq)
 		u16 rxq_idx;
 
 		vsi = ice_get_vf_vsi(vf);
+		if (!vsi)
+			continue;
 
 		ice_for_each_rxq(vsi, rxq_idx)
 			if (vsi->rxq_map[rxq_idx] == pfq) {
@@ -1521,8 +1536,15 @@ static int ice_calc_all_vfs_min_tx_rate(struct ice_pf *pf)
 static bool
 ice_min_tx_rate_oversubscribed(struct ice_vf *vf, int min_tx_rate)
 {
-	int link_speed_mbps = ice_get_link_speed_mbps(ice_get_vf_vsi(vf));
-	int all_vfs_min_tx_rate = ice_calc_all_vfs_min_tx_rate(vf->pf);
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
+	int all_vfs_min_tx_rate;
+	int link_speed_mbps;
+
+	if (WARN_ON(!vsi))
+		return false;
+
+	link_speed_mbps = ice_get_link_speed_mbps(vsi);
+	all_vfs_min_tx_rate = ice_calc_all_vfs_min_tx_rate(vf->pf);
 
 	/* this VF's previous rate is being overwritten */
 	all_vfs_min_tx_rate -= vf->min_tx_rate;
@@ -1566,6 +1588,10 @@ ice_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
 		goto out_put_vf;
 
 	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		ret = -EINVAL;
+		goto out_put_vf;
+	}
 
 	/* when max_tx_rate is zero that means no max Tx rate limiting, so only
 	 * check if max_tx_rate is non-zero
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 6578059d9479..aefd66a4db80 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -220,8 +220,10 @@ static void ice_vf_clear_counters(struct ice_vf *vf)
 {
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
+	if (vsi)
+		vsi->num_vlan = 0;
+
 	vf->num_mac = 0;
-	vsi->num_vlan = 0;
 	memset(&vf->mdd_tx_events, 0, sizeof(vf->mdd_tx_events));
 	memset(&vf->mdd_rx_events, 0, sizeof(vf->mdd_rx_events));
 }
@@ -251,6 +253,9 @@ static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	struct ice_pf *pf = vf->pf;
 
+	if (WARN_ON(!vsi))
+		return -EINVAL;
+
 	if (ice_vsi_rebuild(vsi, true)) {
 		dev_err(ice_pf_to_dev(pf), "failed to rebuild VF %d VSI\n",
 			vf->vf_id);
@@ -514,6 +519,10 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	ice_trigger_vf_reset(vf, flags & ICE_VF_RESET_VFLR, false);
 
 	vsi = ice_get_vf_vsi(vf);
+	if (WARN_ON(!vsi)) {
+		err = -EIO;
+		goto out_unlock;
+	}
 
 	ice_dis_vf_qs(vf);
 
@@ -572,6 +581,11 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 
 	vf->vf_ops->post_vsi_rebuild(vf);
 	vsi = ice_get_vf_vsi(vf);
+	if (WARN_ON(!vsi)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	ice_eswitch_update_repr(vsi);
 	ice_eswitch_replay_vf_mac_rule(vf);
 
@@ -610,6 +624,9 @@ void ice_dis_vf_qs(struct ice_vf *vf)
 {
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
+	if (WARN_ON(!vsi))
+		return;
+
 	ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
 	ice_vsi_stop_all_rx_rings(vsi);
 	ice_set_vf_state_qs_dis(vf);
@@ -790,6 +807,9 @@ static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
 	u8 broadcast[ETH_ALEN];
 	int status;
 
+	if (WARN_ON(!vsi))
+		return -EINVAL;
+
 	if (ice_is_eswitch_mode_switchdev(vf->pf))
 		return 0;
 
@@ -875,6 +895,9 @@ static int ice_vf_rebuild_host_tx_rate_cfg(struct ice_vf *vf)
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	int err;
 
+	if (WARN_ON(!vsi))
+		return -EINVAL;
+
 	if (vf->min_tx_rate) {
 		err = ice_set_min_bw_limit(vsi, (u64)vf->min_tx_rate * 1000);
 		if (err) {
@@ -938,6 +961,9 @@ void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 
+	if (WARN_ON(!vsi))
+		return;
+
 	ice_vf_set_host_trust_cfg(vf);
 
 	if (ice_vf_rebuild_host_mac_cfg(vf))
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 83583ea33a1d..b47577a2841a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -2342,6 +2342,11 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 	}
 
 	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
 	if (vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index dbc1965c0609..c6a58343d81d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1344,7 +1344,12 @@ static void ice_vf_fdir_dump_info(struct ice_vf *vf)
 	pf = vf->pf;
 	hw = &pf->hw;
 	dev = ice_pf_to_dev(pf);
-	vf_vsi = pf->vsi[vf->lan_vsi_idx];
+	vf_vsi = ice_get_vf_vsi(vf);
+	if (!vf_vsi) {
+		dev_dbg(dev, "VF %d: invalid VSI pointer\n", vf->vf_id);
+		return;
+	}
+
 	vsi_num = ice_get_hw_vsi_num(hw, vf_vsi->idx);
 
 	fd_size = rd32(hw, VSIQF_FD_SIZE(vsi_num));
-- 
2.35.1

