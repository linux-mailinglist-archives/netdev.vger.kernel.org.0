Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB7169509
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgBWCWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgBWCWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64B12067D;
        Sun, 23 Feb 2020 02:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424535;
        bh=wFwM4hp2ZQbje9BGLoQIHLMUbB8xnKuuD3qi3cKQKdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg1AbLeXqzp8XxvNTglktZvfioVMEmjrgBk6WBaEIOv7Hw8oh+urvTFHyqiei10rd
         /xIq0LNzvNb3HHFRi6AzDt5E6q9AvUXPbv8O47PT124KvCmlWGG3Ca7ztHUYtXv1g+
         BfePsNmf3jWoeBix4ZVPtspdA6IDesw+SG93iaZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 46/58] ice: Use ice_pf_to_dev
Date:   Sat, 22 Feb 2020 21:21:07 -0500
Message-Id: <20200223022119.707-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 9a946843ba5c173e259fef7a035feac994a65b59 ]

Use ice_pf_to_dev(pf) instead of &pf->pdev->dev
Use ice_pf_to_dev(vsi->back) instead of &vsi->back->pdev->dev
When a pointer to the pf instance is available, use ice_pf_to_dev
instead of ice_hw_to_dev

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c        | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c         | 14 +++++++-------
 drivers/net/ethernet/intel/ice/ice_main.c        | 16 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  8 ++++----
 6 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 77d6a0291e975..6939c14858b20 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -320,7 +320,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			if (err)
 				return err;
 
-			dev_info(&vsi->back->pdev->dev, "Registered XDP mem model MEM_TYPE_ZERO_COPY on Rx ring %d\n",
+			dev_info(ice_pf_to_dev(vsi->back), "Registered XDP mem model MEM_TYPE_ZERO_COPY on Rx ring %d\n",
 				 ring->q_index);
 		} else {
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
@@ -399,7 +399,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
 	if (err) {
-		dev_err(&vsi->back->pdev->dev,
+		dev_err(ice_pf_to_dev(vsi->back),
 			"Failed to set LAN Rx queue context for absolute Rx queue %d error: %d\n",
 			pf_q, err);
 		return -EIO;
@@ -422,7 +422,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	      ice_alloc_rx_bufs_slow_zc(ring, ICE_DESC_UNUSED(ring)) :
 	      ice_alloc_rx_bufs(ring, ICE_DESC_UNUSED(ring));
 	if (err)
-		dev_info(&vsi->back->pdev->dev,
+		dev_info(ice_pf_to_dev(vsi->back),
 			 "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
 			 ring->xsk_umem ? "UMEM enabled " : "",
 			 ring->q_index, pf_q);
@@ -817,13 +817,13 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	 * queues at the hardware level anyway.
 	 */
 	if (status == ICE_ERR_RESET_ONGOING) {
-		dev_dbg(&vsi->back->pdev->dev,
+		dev_dbg(ice_pf_to_dev(vsi->back),
 			"Reset in progress. LAN Tx queues already disabled\n");
 	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
-		dev_dbg(&vsi->back->pdev->dev,
+		dev_dbg(ice_pf_to_dev(vsi->back),
 			"LAN Tx queues do not exist, nothing to disable\n");
 	} else if (status) {
-		dev_err(&vsi->back->pdev->dev,
+		dev_err(ice_pf_to_dev(vsi->back),
 			"Failed to disable LAN Tx queues, error: %d\n", status);
 		return -ENODEV;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 926c9772f0860..265cf69b321bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -882,7 +882,7 @@ ice_dcbnl_vsi_del_app(struct ice_vsi *vsi,
 	sapp.protocol = app->prot_id;
 	sapp.priority = app->priority;
 	err = ice_dcbnl_delapp(vsi->netdev, &sapp);
-	dev_dbg(&vsi->back->pdev->dev,
+	dev_dbg(ice_pf_to_dev(vsi->back),
 		"Deleting app for VSI idx=%d err=%d sel=%d proto=0x%x, prio=%d\n",
 		vsi->idx, err, app->selector, app->prot_id, app->priority);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f956f7bb4ef2d..9bd166e3dff3d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1054,7 +1054,7 @@ ice_set_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 		fec = ICE_FEC_NONE;
 		break;
 	default:
-		dev_warn(&vsi->back->pdev->dev, "Unsupported FEC mode: %d\n",
+		dev_warn(ice_pf_to_dev(vsi->back), "Unsupported FEC mode: %d\n",
 			 fecparam->fec);
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e0e3c6400e4b9..b43bb51f6067a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -116,7 +116,7 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 		vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
 		break;
 	default:
-		dev_dbg(&vsi->back->pdev->dev,
+		dev_dbg(ice_pf_to_dev(vsi->back),
 			"Not setting number of Tx/Rx descriptors for VSI type %d\n",
 			vsi->type);
 		break;
@@ -697,7 +697,7 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	vsi->num_txq = tx_count;
 
 	if (vsi->type == ICE_VSI_VF && vsi->num_txq != vsi->num_rxq) {
-		dev_dbg(&vsi->back->pdev->dev, "VF VSI should have same number of Tx and Rx queues. Hence making them equal\n");
+		dev_dbg(ice_pf_to_dev(vsi->back), "VF VSI should have same number of Tx and Rx queues. Hence making them equal\n");
 		/* since there is a chance that num_rxq could have been changed
 		 * in the above for loop, make num_txq equal to num_rxq.
 		 */
@@ -1306,7 +1306,7 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
 
 		err = ice_setup_rx_ctx(vsi->rx_rings[i]);
 		if (err) {
-			dev_err(&vsi->back->pdev->dev,
+			dev_err(ice_pf_to_dev(vsi->back),
 				"ice_setup_rx_ctx failed for RxQ %d, err %d\n",
 				i, err);
 			return err;
@@ -1476,7 +1476,7 @@ int ice_vsi_manage_vlan_insertion(struct ice_vsi *vsi)
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
 	if (status) {
-		dev_err(&vsi->back->pdev->dev, "update VSI for VLAN insert failed, err %d aq_err %d\n",
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for VLAN insert failed, err %d aq_err %d\n",
 			status, hw->adminq.sq_last_status);
 		ret = -EIO;
 		goto out;
@@ -1522,7 +1522,7 @@ int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
 	if (status) {
-		dev_err(&vsi->back->pdev->dev, "update VSI for VLAN strip failed, ena = %d err %d aq_err %d\n",
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for VLAN strip failed, ena = %d err %d aq_err %d\n",
 			ena, status, hw->adminq.sq_last_status);
 		ret = -EIO;
 		goto out;
@@ -1696,7 +1696,7 @@ ice_vsi_set_q_vectors_reg_idx(struct ice_vsi *vsi)
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
 		if (!q_vector) {
-			dev_err(&vsi->back->pdev->dev,
+			dev_err(ice_pf_to_dev(vsi->back),
 				"Failed to set reg_idx on q_vector %d VSI %d\n",
 				i, vsi->vsi_num);
 			goto clear_reg_idx;
@@ -2718,6 +2718,6 @@ ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set)
 		status = ice_remove_mac(&vsi->back->hw, &tmp_add_list);
 
 cfg_mac_fltr_exit:
-	ice_free_fltr_list(&vsi->back->pdev->dev, &tmp_add_list);
+	ice_free_fltr_list(ice_pf_to_dev(vsi->back), &tmp_add_list);
 	return status;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b4cbeb4f3177f..c9b35b202639d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -269,7 +269,7 @@ static int ice_cfg_promisc(struct ice_vsi *vsi, u8 promisc_m, bool set_promisc)
  */
 static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 {
-	struct device *dev = &vsi->back->pdev->dev;
+	struct device *dev = ice_pf_to_dev(vsi->back);
 	struct net_device *netdev = vsi->netdev;
 	bool promisc_forced_on = false;
 	struct ice_pf *pf = vsi->back;
@@ -1364,7 +1364,7 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	dev = &vsi->back->pdev->dev;
+	dev = ice_pf_to_dev(vsi->back);
 
 	pi = vsi->port_info;
 
@@ -1682,7 +1682,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
  */
 static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 {
-	struct device *dev = &vsi->back->pdev->dev;
+	struct device *dev = ice_pf_to_dev(vsi->back);
 	int i;
 
 	for (i = 0; i < vsi->num_xdp_txq; i++) {
@@ -3858,14 +3858,14 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	/* Don't set any netdev advanced features with device in Safe Mode */
 	if (ice_is_safe_mode(vsi->back)) {
-		dev_err(&vsi->back->pdev->dev,
+		dev_err(ice_pf_to_dev(vsi->back),
 			"Device is in Safe Mode - not enabling advanced netdev features\n");
 		return ret;
 	}
 
 	/* Do not change setting during reset */
 	if (ice_is_reset_in_progress(pf->state)) {
-		dev_err(&vsi->back->pdev->dev,
+		dev_err(ice_pf_to_dev(vsi->back),
 			"Device is resetting, changing advanced netdev features temporarily unavailable.\n");
 		return -EBUSY;
 	}
@@ -4408,7 +4408,7 @@ int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 	int i, err = 0;
 
 	if (!vsi->num_txq) {
-		dev_err(&vsi->back->pdev->dev, "VSI %d has 0 Tx queues\n",
+		dev_err(ice_pf_to_dev(vsi->back), "VSI %d has 0 Tx queues\n",
 			vsi->vsi_num);
 		return -EINVAL;
 	}
@@ -4439,7 +4439,7 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	int i, err = 0;
 
 	if (!vsi->num_rxq) {
-		dev_err(&vsi->back->pdev->dev, "VSI %d has 0 Rx queues\n",
+		dev_err(ice_pf_to_dev(vsi->back), "VSI %d has 0 Rx queues\n",
 			vsi->vsi_num);
 		return -EINVAL;
 	}
@@ -4968,7 +4968,7 @@ static int ice_vsi_update_bridge_mode(struct ice_vsi *vsi, u16 bmode)
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
 	if (status) {
-		dev_err(&vsi->back->pdev->dev, "update VSI for bridge mode failed, bmode = %d err %d aq_err %d\n",
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for bridge mode failed, bmode = %d err %d aq_err %d\n",
 			bmode, status, hw->adminq.sq_last_status);
 		ret = -EIO;
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index edb374296d1f3..e2114f24a19e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -508,7 +508,7 @@ static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 vid, bool enable)
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
 	if (status) {
-		dev_info(&vsi->back->pdev->dev, "update VSI for port VLAN failed, err %d aq_err %d\n",
+		dev_info(ice_pf_to_dev(vsi->back), "update VSI for port VLAN failed, err %d aq_err %d\n",
 			 status, hw->adminq.sq_last_status);
 		ret = -EIO;
 		goto out;
@@ -2019,7 +2019,7 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 			continue;
 
 		if (ice_vsi_ctrl_rx_ring(vsi, true, vf_q_id)) {
-			dev_err(&vsi->back->pdev->dev,
+			dev_err(ice_pf_to_dev(vsi->back),
 				"Failed to enable Rx ring %d on VSI %d\n",
 				vf_q_id, vsi->vsi_num);
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2122,7 +2122,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
 						 ring, &txq_meta)) {
-				dev_err(&vsi->back->pdev->dev,
+				dev_err(ice_pf_to_dev(vsi->back),
 					"Failed to stop Tx ring %d on VSI %d\n",
 					vf_q_id, vsi->vsi_num);
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2149,7 +2149,7 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 				continue;
 
 			if (ice_vsi_ctrl_rx_ring(vsi, false, vf_q_id)) {
-				dev_err(&vsi->back->pdev->dev,
+				dev_err(ice_pf_to_dev(vsi->back),
 					"Failed to stop Rx ring %d on VSI %d\n",
 					vf_q_id, vsi->vsi_num);
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-- 
2.20.1

