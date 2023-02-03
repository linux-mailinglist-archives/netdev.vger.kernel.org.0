Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2ED68A470
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjBCVPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjBCVPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:15:42 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A67571BF9
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675458926; x=1706994926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vZy2wRpqeQCVzDhYuQZlIBIkXZGw+UG5BosaacPJKV0=;
  b=EqgnrfxD+9hH96q4h9Q8yMecZsRWlHxy5EDwl8+OG1VQ6xHKJe2tHAY8
   ZAN2WsAiTAx5R30Uhoz5pPXrmRHzD5mllYErC9M3ZhM/0H8BpvXlx3PFH
   Q756R1OJMJoj8Hs5k/CQBiTC9XWO0/UdkgW6Hz2OPmQE8D3P6V/FAh159
   NR0+djgGhb9FBoetBt6pO+KAvkfQJHMnXDbFDfD3WMU77D8vw7Ld+a2x7
   1v9ngnYYgdKm0+EbyRamU4QBT2Cr9RAVeaSw41nEawUpJBjMFI4qc5WCN
   erUBSDFMmlo8dTjHZ2ZXPxN/OjcUjqcyrwFhGsYKvteucWGijc7NYAEpn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="393446825"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="393446825"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 13:15:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="911280480"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="911280480"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2023 13:15:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 04/10] ice: split ice_vsi_setup into smaller functions
Date:   Fri,  3 Feb 2023 13:14:50 -0800
Message-Id: <20230203211456.705649-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
References: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Main goal is to reuse the same functions in VSI config and rebuild
paths.
To do this split ice_vsi_setup into smaller pieces and reuse it during
rebuild.

ice_vsi_alloc() should only alloc memory, not set the default values
for VSI.
Move setting defaults to separate function. This will allow config of
already allocated VSI, for example in reload path.

The path is mostly moving code around without introducing new
functionality. Functions ice_vsi_cfg() and ice_vsi_decfg() were
added, but they are using code that already exist.

Use flag to pass information about VSI initialization during rebuild
instead of using boolean value.

Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c    | 986 +++++++++-----------
 drivers/net/ethernet/intel/ice/ice_lib.h    |   7 +-
 drivers/net/ethernet/intel/ice/ice_main.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c |   2 +-
 4 files changed, 469 insertions(+), 538 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b3f03f9932d2..f9690c0fe5da 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -347,6 +347,106 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_vsi_free_stats - Free the ring statistics structures
+ * @vsi: VSI pointer
+ */
+static void ice_vsi_free_stats(struct ice_vsi *vsi)
+{
+	struct ice_vsi_stats *vsi_stat;
+	struct ice_pf *pf = vsi->back;
+	int i;
+
+	if (vsi->type == ICE_VSI_CHNL)
+		return;
+	if (!pf->vsi_stats)
+		return;
+
+	vsi_stat = pf->vsi_stats[vsi->idx];
+	if (!vsi_stat)
+		return;
+
+	ice_for_each_alloc_txq(vsi, i) {
+		if (vsi_stat->tx_ring_stats[i]) {
+			kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
+			WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
+		}
+	}
+
+	ice_for_each_alloc_rxq(vsi, i) {
+		if (vsi_stat->rx_ring_stats[i]) {
+			kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
+			WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
+		}
+	}
+
+	kfree(vsi_stat->tx_ring_stats);
+	kfree(vsi_stat->rx_ring_stats);
+	kfree(vsi_stat);
+	pf->vsi_stats[vsi->idx] = NULL;
+}
+
+/**
+ * ice_vsi_alloc_ring_stats - Allocates Tx and Rx ring stats for the VSI
+ * @vsi: VSI which is having stats allocated
+ */
+static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
+{
+	struct ice_ring_stats **tx_ring_stats;
+	struct ice_ring_stats **rx_ring_stats;
+	struct ice_vsi_stats *vsi_stats;
+	struct ice_pf *pf = vsi->back;
+	u16 i;
+
+	vsi_stats = pf->vsi_stats[vsi->idx];
+	tx_ring_stats = vsi_stats->tx_ring_stats;
+	rx_ring_stats = vsi_stats->rx_ring_stats;
+
+	/* Allocate Tx ring stats */
+	ice_for_each_alloc_txq(vsi, i) {
+		struct ice_ring_stats *ring_stats;
+		struct ice_tx_ring *ring;
+
+		ring = vsi->tx_rings[i];
+		ring_stats = tx_ring_stats[i];
+
+		if (!ring_stats) {
+			ring_stats = kzalloc(sizeof(*ring_stats), GFP_KERNEL);
+			if (!ring_stats)
+				goto err_out;
+
+			WRITE_ONCE(tx_ring_stats[i], ring_stats);
+		}
+
+		ring->ring_stats = ring_stats;
+	}
+
+	/* Allocate Rx ring stats */
+	ice_for_each_alloc_rxq(vsi, i) {
+		struct ice_ring_stats *ring_stats;
+		struct ice_rx_ring *ring;
+
+		ring = vsi->rx_rings[i];
+		ring_stats = rx_ring_stats[i];
+
+		if (!ring_stats) {
+			ring_stats = kzalloc(sizeof(*ring_stats), GFP_KERNEL);
+			if (!ring_stats)
+				goto err_out;
+
+			WRITE_ONCE(rx_ring_stats[i], ring_stats);
+		}
+
+		ring->ring_stats = ring_stats;
+	}
+
+	return 0;
+
+err_out:
+	ice_vsi_free_stats(vsi);
+	return -ENOMEM;
+}
+
 /**
  * ice_vsi_free - clean up and deallocate the provided VSI
  * @vsi: pointer to VSI being cleared
@@ -384,6 +484,7 @@ int ice_vsi_free(struct ice_vsi *vsi)
 	if (vsi->idx < pf->next_vsi && vsi->type == ICE_VSI_CTRL && vsi->vf)
 		pf->next_vsi = vsi->idx;
 
+	ice_vsi_free_stats(vsi);
 	ice_vsi_free_arrays(vsi);
 	mutex_unlock(&pf->sw_mutex);
 	devm_kfree(dev, vsi);
@@ -461,6 +562,10 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 	if (!pf->vsi_stats)
 		return -ENOENT;
 
+	if (pf->vsi_stats[vsi->idx])
+	/* realloc will happen in rebuild path */
+		return 0;
+
 	vsi_stat = kzalloc(sizeof(*vsi_stat), GFP_KERNEL);
 	if (!vsi_stat)
 		return -ENOMEM;
@@ -490,9 +595,57 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 	return -ENOMEM;
 }
 
+/**
+ * ice_vsi_alloc_def - set default values for already allocated VSI
+ * @vsi: ptr to VSI
+ * @vf: VF for ICE_VSI_VF and ICE_VSI_CTRL
+ * @ch: ptr to channel
+ */
+static int
+ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_vf *vf,
+		  struct ice_channel *ch)
+{
+	if (vsi->type != ICE_VSI_CHNL) {
+		ice_vsi_set_num_qs(vsi, vf);
+		if (ice_vsi_alloc_arrays(vsi))
+			return -ENOMEM;
+	}
+
+	switch (vsi->type) {
+	case ICE_VSI_SWITCHDEV_CTRL:
+		/* Setup eswitch MSIX irq handler for VSI */
+		vsi->irq_handler = ice_eswitch_msix_clean_rings;
+		break;
+	case ICE_VSI_PF:
+		/* Setup default MSIX irq handler for VSI */
+		vsi->irq_handler = ice_msix_clean_rings;
+		break;
+	case ICE_VSI_CTRL:
+		/* Setup ctrl VSI MSIX irq handler */
+		vsi->irq_handler = ice_msix_clean_ctrl_vsi;
+		break;
+	case ICE_VSI_CHNL:
+		if (!ch)
+			return -EINVAL;
+
+		vsi->num_rxq = ch->num_rxq;
+		vsi->num_txq = ch->num_txq;
+		vsi->next_base_q = ch->base_q;
+		break;
+	case ICE_VSI_VF:
+		break;
+	default:
+		ice_vsi_free_arrays(vsi);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * ice_vsi_alloc - Allocates the next available struct VSI in the PF
  * @pf: board private structure
+ * @pi: pointer to the port_info instance
  * @vsi_type: type of VSI
  * @ch: ptr to channel
  * @vf: VF for ICE_VSI_VF and ICE_VSI_CTRL
@@ -504,8 +657,9 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
  * returns a pointer to a VSI on success, NULL on failure.
  */
 static struct ice_vsi *
-ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
-	      struct ice_channel *ch, struct ice_vf *vf)
+ice_vsi_alloc(struct ice_pf *pf, struct ice_port_info *pi,
+	      enum ice_vsi_type vsi_type, struct ice_channel *ch,
+	      struct ice_vf *vf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_vsi *vsi = NULL;
@@ -531,61 +685,11 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
 
 	vsi->type = vsi_type;
 	vsi->back = pf;
+	vsi->port_info = pi;
+	/* For VSIs which don't have a connected VF, this will be NULL */
+	vsi->vf = vf;
 	set_bit(ICE_VSI_DOWN, vsi->state);
 
-	if (vsi_type == ICE_VSI_VF)
-		ice_vsi_set_num_qs(vsi, vf);
-	else if (vsi_type != ICE_VSI_CHNL)
-		ice_vsi_set_num_qs(vsi, NULL);
-
-	switch (vsi->type) {
-	case ICE_VSI_SWITCHDEV_CTRL:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-
-		/* Setup eswitch MSIX irq handler for VSI */
-		vsi->irq_handler = ice_eswitch_msix_clean_rings;
-		break;
-	case ICE_VSI_PF:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-
-		/* Setup default MSIX irq handler for VSI */
-		vsi->irq_handler = ice_msix_clean_rings;
-		break;
-	case ICE_VSI_CTRL:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-
-		/* Setup ctrl VSI MSIX irq handler */
-		vsi->irq_handler = ice_msix_clean_ctrl_vsi;
-
-		/* For the PF control VSI this is NULL, for the VF control VSI
-		 * this will be the first VF to allocate it.
-		 */
-		vsi->vf = vf;
-		break;
-	case ICE_VSI_VF:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-		vsi->vf = vf;
-		break;
-	case ICE_VSI_CHNL:
-		if (!ch)
-			goto err_rings;
-		vsi->num_rxq = ch->num_rxq;
-		vsi->num_txq = ch->num_txq;
-		vsi->next_base_q = ch->base_q;
-		break;
-	case ICE_VSI_LB:
-		if (ice_vsi_alloc_arrays(vsi))
-			goto err_rings;
-		break;
-	default:
-		dev_warn(dev, "Unknown VSI type %d\n", vsi->type);
-		goto unlock_pf;
-	}
-
 	if (vsi->type == ICE_VSI_CTRL && !vf) {
 		/* Use the last VSI slot as the index for PF control VSI */
 		vsi->idx = pf->num_alloc_vsi - 1;
@@ -604,15 +708,6 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
 	if (vsi->type == ICE_VSI_CTRL && vf)
 		vf->ctrl_vsi_idx = vsi->idx;
 
-	/* allocate memory for Tx/Rx ring stat pointers */
-	if (ice_vsi_alloc_stat_arrays(vsi))
-		goto err_rings;
-
-	goto unlock_pf;
-
-err_rings:
-	devm_kfree(dev, vsi);
-	vsi = NULL;
 unlock_pf:
 	mutex_unlock(&pf->sw_mutex);
 	return vsi;
@@ -1177,12 +1272,12 @@ ice_chnl_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 /**
  * ice_vsi_init - Create and initialize a VSI
  * @vsi: the VSI being configured
- * @init_vsi: is this call creating a VSI
+ * @init_vsi: flag, tell if VSI need to be initialized
  *
  * This initializes a VSI context depending on the VSI type to be added and
  * passes it down to the add_vsi aq command to create a new VSI.
  */
-static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
+static int ice_vsi_init(struct ice_vsi *vsi, int init_vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
@@ -1244,7 +1339,7 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 		/* if updating VSI context, make sure to set valid_section:
 		 * to indicate which section of VSI context being updated
 		 */
-		if (!init_vsi)
+		if (!(init_vsi & ICE_VSI_FLAG_INIT))
 			ctxt->info.valid_sections |=
 				cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
 	}
@@ -1257,7 +1352,8 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 		if (ret)
 			goto out;
 
-		if (!init_vsi) /* means VSI being updated */
+		if (!(init_vsi & ICE_VSI_FLAG_INIT))
+			/* means VSI being updated */
 			/* must to indicate which section of VSI context are
 			 * being modified
 			 */
@@ -1272,7 +1368,7 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 			cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
 	}
 
-	if (init_vsi) {
+	if (init_vsi & ICE_VSI_FLAG_INIT) {
 		ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
 		if (ret) {
 			dev_err(dev, "Add VSI failed, err %d\n", ret);
@@ -1584,142 +1680,42 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_free_stats - Free the ring statistics structures
- * @vsi: VSI pointer
+ * ice_vsi_manage_rss_lut - disable/enable RSS
+ * @vsi: the VSI being changed
+ * @ena: boolean value indicating if this is an enable or disable request
+ *
+ * In the event of disable request for RSS, this function will zero out RSS
+ * LUT, while in the event of enable request for RSS, it will reconfigure RSS
+ * LUT.
  */
-static void ice_vsi_free_stats(struct ice_vsi *vsi)
+void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
 {
-	struct ice_vsi_stats *vsi_stat;
-	struct ice_pf *pf = vsi->back;
-	int i;
-
-	if (vsi->type == ICE_VSI_CHNL)
-		return;
-	if (!pf->vsi_stats)
-		return;
+	u8 *lut;
 
-	vsi_stat = pf->vsi_stats[vsi->idx];
-	if (!vsi_stat)
+	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
+	if (!lut)
 		return;
 
-	ice_for_each_alloc_txq(vsi, i) {
-		if (vsi_stat->tx_ring_stats[i]) {
-			kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
-			WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
-		}
-	}
-
-	ice_for_each_alloc_rxq(vsi, i) {
-		if (vsi_stat->rx_ring_stats[i]) {
-			kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
-			WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
-		}
+	if (ena) {
+		if (vsi->rss_lut_user)
+			memcpy(lut, vsi->rss_lut_user, vsi->rss_table_size);
+		else
+			ice_fill_rss_lut(lut, vsi->rss_table_size,
+					 vsi->rss_size);
 	}
 
-	kfree(vsi_stat->tx_ring_stats);
-	kfree(vsi_stat->rx_ring_stats);
-	kfree(vsi_stat);
-	pf->vsi_stats[vsi->idx] = NULL;
+	ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
+	kfree(lut);
 }
 
 /**
- * ice_vsi_alloc_ring_stats - Allocates Tx and Rx ring stats for the VSI
- * @vsi: VSI which is having stats allocated
+ * ice_vsi_cfg_crc_strip - Configure CRC stripping for a VSI
+ * @vsi: VSI to be configured
+ * @disable: set to true to have FCS / CRC in the frame data
  */
-static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
+void ice_vsi_cfg_crc_strip(struct ice_vsi *vsi, bool disable)
 {
-	struct ice_ring_stats **tx_ring_stats;
-	struct ice_ring_stats **rx_ring_stats;
-	struct ice_vsi_stats *vsi_stats;
-	struct ice_pf *pf = vsi->back;
-	u16 i;
-
-	vsi_stats = pf->vsi_stats[vsi->idx];
-	tx_ring_stats = vsi_stats->tx_ring_stats;
-	rx_ring_stats = vsi_stats->rx_ring_stats;
-
-	/* Allocate Tx ring stats */
-	ice_for_each_alloc_txq(vsi, i) {
-		struct ice_ring_stats *ring_stats;
-		struct ice_tx_ring *ring;
-
-		ring = vsi->tx_rings[i];
-		ring_stats = tx_ring_stats[i];
-
-		if (!ring_stats) {
-			ring_stats = kzalloc(sizeof(*ring_stats), GFP_KERNEL);
-			if (!ring_stats)
-				goto err_out;
-
-			WRITE_ONCE(tx_ring_stats[i], ring_stats);
-		}
-
-		ring->ring_stats = ring_stats;
-	}
-
-	/* Allocate Rx ring stats */
-	ice_for_each_alloc_rxq(vsi, i) {
-		struct ice_ring_stats *ring_stats;
-		struct ice_rx_ring *ring;
-
-		ring = vsi->rx_rings[i];
-		ring_stats = rx_ring_stats[i];
-
-		if (!ring_stats) {
-			ring_stats = kzalloc(sizeof(*ring_stats), GFP_KERNEL);
-			if (!ring_stats)
-				goto err_out;
-
-			WRITE_ONCE(rx_ring_stats[i], ring_stats);
-		}
-
-		ring->ring_stats = ring_stats;
-	}
-
-	return 0;
-
-err_out:
-	ice_vsi_free_stats(vsi);
-	return -ENOMEM;
-}
-
-/**
- * ice_vsi_manage_rss_lut - disable/enable RSS
- * @vsi: the VSI being changed
- * @ena: boolean value indicating if this is an enable or disable request
- *
- * In the event of disable request for RSS, this function will zero out RSS
- * LUT, while in the event of enable request for RSS, it will reconfigure RSS
- * LUT.
- */
-void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
-{
-	u8 *lut;
-
-	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
-	if (!lut)
-		return;
-
-	if (ena) {
-		if (vsi->rss_lut_user)
-			memcpy(lut, vsi->rss_lut_user, vsi->rss_table_size);
-		else
-			ice_fill_rss_lut(lut, vsi->rss_table_size,
-					 vsi->rss_size);
-	}
-
-	ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
-	kfree(lut);
-}
-
-/**
- * ice_vsi_cfg_crc_strip - Configure CRC stripping for a VSI
- * @vsi: VSI to be configured
- * @disable: set to true to have FCS / CRC in the frame data
- */
-void ice_vsi_cfg_crc_strip(struct ice_vsi *vsi, bool disable)
-{
-	int i;
+	int i;
 
 	ice_for_each_rxq(vsi, i)
 		if (disable)
@@ -2645,45 +2641,99 @@ static void ice_set_agg_vsi(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_setup - Set up a VSI by a given type
- * @pf: board private structure
- * @pi: pointer to the port_info instance
- * @vsi_type: VSI type
- * @vf: pointer to VF to which this VSI connects. This field is used primarily
- *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
- * @ch: ptr to channel
- *
- * This allocates the sw VSI structure and its queue resources.
+ * ice_free_vf_ctrl_res - Free the VF control VSI resource
+ * @pf: pointer to PF structure
+ * @vsi: the VSI to free resources for
  *
- * Returns pointer to the successfully allocated and configured VSI sw struct on
- * success, NULL on failure.
+ * Check if the VF control VSI resource is still in use. If no VF is using it
+ * any more, release the VSI resource. Otherwise, leave it to be cleaned up
+ * once no other VF uses it.
  */
-struct ice_vsi *
-ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
-	      enum ice_vsi_type vsi_type, struct ice_vf *vf,
-	      struct ice_channel *ch)
+static void ice_free_vf_ctrl_res(struct ice_pf *pf,  struct ice_vsi *vsi)
+{
+	struct ice_vf *vf;
+	unsigned int bkt;
+
+	rcu_read_lock();
+	ice_for_each_vf_rcu(pf, bkt, vf) {
+		if (vf != vsi->vf && vf->ctrl_vsi_idx != ICE_NO_VSI) {
+			rcu_read_unlock();
+			return;
+		}
+	}
+	rcu_read_unlock();
+
+	/* No other VFs left that have control VSI. It is now safe to reclaim
+	 * SW interrupts back to the common pool.
+	 */
+	ice_free_res(pf->irq_tracker, vsi->base_vector,
+		     ICE_RES_VF_CTRL_VEC_ID);
+	pf->num_avail_sw_msix += vsi->num_q_vectors;
+}
+
+static int ice_vsi_cfg_tc_lan(struct ice_pf *pf, struct ice_vsi *vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_vsi *vsi;
 	int ret, i;
 
-	vsi = ice_vsi_alloc(pf, vsi_type, ch, vf);
+	/* configure VSI nodes based on number of queues and TC's */
+	ice_for_each_traffic_class(i) {
+		if (!(vsi->tc_cfg.ena_tc & BIT(i)))
+			continue;
 
-	if (!vsi) {
-		dev_err(dev, "could not allocate VSI\n");
-		return NULL;
+		if (vsi->type == ICE_VSI_CHNL) {
+			if (!vsi->alloc_txq && vsi->num_txq)
+				max_txqs[i] = vsi->num_txq;
+			else
+				max_txqs[i] = pf->num_lan_tx;
+		} else {
+			max_txqs[i] = vsi->alloc_txq;
+		}
 	}
 
-	vsi->port_info = pi;
+	dev_dbg(dev, "vsi->tc_cfg.ena_tc = %d\n", vsi->tc_cfg.ena_tc);
+	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+			      max_txqs);
+	if (ret) {
+		dev_err(dev, "VSI %d failed lan queue config, error %d\n",
+			vsi->vsi_num, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_vsi_cfg_def - configure default VSI based on the type
+ * @vsi: pointer to VSI
+ * @vf: pointer to VF to which this VSI connects. This field is used primarily
+ *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
+ * @ch: ptr to channel
+ */
+static int
+ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
+{
+	struct device *dev = ice_pf_to_dev(vsi->back);
+	struct ice_pf *pf = vsi->back;
+	int ret;
+
 	vsi->vsw = pf->first_sw;
 
+	ret = ice_vsi_alloc_def(vsi, vf, ch);
+	if (ret)
+		return ret;
+
+	/* allocate memory for Tx/Rx ring stat pointers */
+	if (ice_vsi_alloc_stat_arrays(vsi))
+		goto unroll_vsi_alloc;
+
 	ice_alloc_fd_res(vsi);
 
 	if (ice_vsi_get_qs(vsi)) {
 		dev_err(dev, "Failed to allocate queues. vsi->idx = %d\n",
 			vsi->idx);
-		goto unroll_vsi_alloc;
+		goto unroll_vsi_alloc_stat;
 	}
 
 	/* set RSS capabilities */
@@ -2724,6 +2774,14 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 			goto unroll_vector_base;
 
 		ice_vsi_map_rings_to_vectors(vsi);
+		if (ice_is_xdp_ena_vsi(vsi)) {
+			ret = ice_vsi_determine_xdp_res(vsi);
+			if (ret)
+				goto unroll_vector_base;
+			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
+			if (ret)
+				goto unroll_vector_base;
+		}
 
 		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
 		if (vsi->type != ICE_VSI_CTRL)
@@ -2788,52 +2846,8 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		goto unroll_vsi_init;
 	}
 
-	/* configure VSI nodes based on number of queues and TC's */
-	ice_for_each_traffic_class(i) {
-		if (!(vsi->tc_cfg.ena_tc & BIT(i)))
-			continue;
-
-		if (vsi->type == ICE_VSI_CHNL) {
-			if (!vsi->alloc_txq && vsi->num_txq)
-				max_txqs[i] = vsi->num_txq;
-			else
-				max_txqs[i] = pf->num_lan_tx;
-		} else {
-			max_txqs[i] = vsi->alloc_txq;
-		}
-	}
-
-	dev_dbg(dev, "vsi->tc_cfg.ena_tc = %d\n", vsi->tc_cfg.ena_tc);
-	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
-			      max_txqs);
-	if (ret) {
-		dev_err(dev, "VSI %d failed lan queue config, error %d\n",
-			vsi->vsi_num, ret);
-		goto unroll_clear_rings;
-	}
-
-	/* Add switch rule to drop all Tx Flow Control Frames, of look up
-	 * type ETHERTYPE from VSIs, and restrict malicious VF from sending
-	 * out PAUSE or PFC frames. If enabled, FW can still send FC frames.
-	 * The rule is added once for PF VSI in order to create appropriate
-	 * recipe, since VSI/VSI list is ignored with drop action...
-	 * Also add rules to handle LLDP Tx packets.  Tx LLDP packets need to
-	 * be dropped so that VFs cannot send LLDP packets to reconfig DCB
-	 * settings in the HW.
-	 */
-	if (!ice_is_safe_mode(pf))
-		if (vsi->type == ICE_VSI_PF) {
-			ice_fltr_add_eth(vsi, ETH_P_PAUSE, ICE_FLTR_TX,
-					 ICE_DROP_PACKET);
-			ice_cfg_sw_lldp(vsi, true, true);
-		}
-
-	if (!vsi->agg_node)
-		ice_set_agg_vsi(vsi);
-	return vsi;
+	return 0;
 
-unroll_clear_rings:
-	ice_vsi_clear_rings(vsi);
 unroll_vector_base:
 	/* reclaim SW interrupts back to the common pool */
 	ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
@@ -2841,43 +2855,182 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 unroll_alloc_q_vector:
 	ice_vsi_free_q_vectors(vsi);
 unroll_vsi_init:
-	ice_vsi_free_stats(vsi);
 	ice_vsi_delete(vsi);
 unroll_get_qs:
 	ice_vsi_put_qs(vsi);
+unroll_vsi_alloc_stat:
+	ice_vsi_free_stats(vsi);
 unroll_vsi_alloc:
-	if (vsi_type == ICE_VSI_VF)
-		ice_enable_lag(pf->lag);
-	ice_vsi_free(vsi);
-
-	return NULL;
+	ice_vsi_free_arrays(vsi);
+	return ret;
 }
 
 /**
- * ice_vsi_release_msix - Clear the queue to Interrupt mapping in HW
- * @vsi: the VSI being cleaned up
+ * ice_vsi_cfg - configure VSI and tc on it
+ * @vsi: pointer to VSI
+ * @vf: pointer to VF to which this VSI connects. This field is used primarily
+ *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
+ * @ch: ptr to channel
  */
-static void ice_vsi_release_msix(struct ice_vsi *vsi)
+int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
 {
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
-	u32 txq = 0;
-	u32 rxq = 0;
-	int i, q;
+	int ret;
 
-	ice_for_each_q_vector(vsi, i) {
-		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+	ret = ice_vsi_cfg_def(vsi, vf, ch);
+	if (ret)
+		return ret;
 
-		ice_write_intrl(q_vector, 0);
-		for (q = 0; q < q_vector->num_ring_tx; q++) {
-			ice_write_itr(&q_vector->tx, 0);
-			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), 0);
-			if (ice_is_xdp_ena_vsi(vsi)) {
-				u32 xdp_txq = txq + vsi->num_xdp_txq;
+	ret = ice_vsi_cfg_tc_lan(vsi->back, vsi);
+	if (ret)
+		ice_vsi_decfg(vsi);
 
-				wr32(hw, QINT_TQCTL(vsi->txq_map[xdp_txq]), 0);
-			}
-			txq++;
+	return ret;
+}
+
+/**
+ * ice_vsi_decfg - remove all VSI configuration
+ * @vsi: pointer to VSI
+ */
+void ice_vsi_decfg(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	int err;
+
+	/* The Rx rule will only exist to remove if the LLDP FW
+	 * engine is currently stopped
+	 */
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
+	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		ice_cfg_sw_lldp(vsi, false, false);
+
+	ice_fltr_remove_all(vsi);
+	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
+	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
+	if (err)
+		dev_err(ice_pf_to_dev(pf), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
+			vsi->vsi_num, err);
+
+	if (ice_is_xdp_ena_vsi(vsi))
+		/* return value check can be skipped here, it always returns
+		 * 0 if reset is in progress
+		 */
+		ice_destroy_xdp_rings(vsi);
+
+	ice_vsi_clear_rings(vsi);
+	ice_vsi_free_q_vectors(vsi);
+	ice_vsi_delete(vsi);
+	ice_vsi_put_qs(vsi);
+	ice_vsi_free_arrays(vsi);
+
+	/* SR-IOV determines needed MSIX resources all at once instead of per
+	 * VSI since when VFs are spawned we know how many VFs there are and how
+	 * many interrupts each VF needs. SR-IOV MSIX resources are also
+	 * cleared in the same manner.
+	 */
+	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
+		ice_free_vf_ctrl_res(pf, vsi);
+	} else if (vsi->type != ICE_VSI_VF) {
+		/* reclaim SW interrupts back to the common pool */
+		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
+		pf->num_avail_sw_msix += vsi->num_q_vectors;
+		vsi->base_vector = 0;
+	}
+
+	if (vsi->type == ICE_VSI_VF &&
+	    vsi->agg_node && vsi->agg_node->valid)
+		vsi->agg_node->num_vsis--;
+	if (vsi->agg_node) {
+		vsi->agg_node->valid = false;
+		vsi->agg_node->agg_id = 0;
+	}
+}
+
+/**
+ * ice_vsi_setup - Set up a VSI by a given type
+ * @pf: board private structure
+ * @pi: pointer to the port_info instance
+ * @vsi_type: VSI type
+ * @vf: pointer to VF to which this VSI connects. This field is used primarily
+ *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
+ * @ch: ptr to channel
+ *
+ * This allocates the sw VSI structure and its queue resources.
+ *
+ * Returns pointer to the successfully allocated and configured VSI sw struct on
+ * success, NULL on failure.
+ */
+struct ice_vsi *
+ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
+	      enum ice_vsi_type vsi_type, struct ice_vf *vf,
+	      struct ice_channel *ch)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vsi *vsi;
+	int ret;
+
+	vsi = ice_vsi_alloc(pf, pi, vsi_type, ch, vf);
+	if (!vsi) {
+		dev_err(dev, "could not allocate VSI\n");
+		return NULL;
+	}
+
+	ret = ice_vsi_cfg(vsi, vf, ch);
+	if (ret)
+		goto err_vsi_cfg;
+
+	/* Add switch rule to drop all Tx Flow Control Frames, of look up
+	 * type ETHERTYPE from VSIs, and restrict malicious VF from sending
+	 * out PAUSE or PFC frames. If enabled, FW can still send FC frames.
+	 * The rule is added once for PF VSI in order to create appropriate
+	 * recipe, since VSI/VSI list is ignored with drop action...
+	 * Also add rules to handle LLDP Tx packets.  Tx LLDP packets need to
+	 * be dropped so that VFs cannot send LLDP packets to reconfig DCB
+	 * settings in the HW.
+	 */
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF) {
+		ice_fltr_add_eth(vsi, ETH_P_PAUSE, ICE_FLTR_TX,
+				 ICE_DROP_PACKET);
+		ice_cfg_sw_lldp(vsi, true, true);
+	}
+
+	if (!vsi->agg_node)
+		ice_set_agg_vsi(vsi);
+
+	return vsi;
+
+err_vsi_cfg:
+	if (vsi_type == ICE_VSI_VF)
+		ice_enable_lag(pf->lag);
+	ice_vsi_free(vsi);
+
+	return NULL;
+}
+
+/**
+ * ice_vsi_release_msix - Clear the queue to Interrupt mapping in HW
+ * @vsi: the VSI being cleaned up
+ */
+static void ice_vsi_release_msix(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	u32 txq = 0;
+	u32 rxq = 0;
+	int i, q;
+
+	ice_for_each_q_vector(vsi, i) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
+		ice_write_intrl(q_vector, 0);
+		for (q = 0; q < q_vector->num_ring_tx; q++) {
+			ice_write_itr(&q_vector->tx, 0);
+			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), 0);
+			if (ice_is_xdp_ena_vsi(vsi)) {
+				u32 xdp_txq = txq + vsi->num_xdp_txq;
+
+				wr32(hw, QINT_TQCTL(vsi->txq_map[xdp_txq]), 0);
+			}
+			txq++;
 		}
 
 		for (q = 0; q < q_vector->num_ring_rx; q++) {
@@ -3111,37 +3264,6 @@ void ice_napi_del(struct ice_vsi *vsi)
 		netif_napi_del(&vsi->q_vectors[v_idx]->napi);
 }
 
-/**
- * ice_free_vf_ctrl_res - Free the VF control VSI resource
- * @pf: pointer to PF structure
- * @vsi: the VSI to free resources for
- *
- * Check if the VF control VSI resource is still in use. If no VF is using it
- * any more, release the VSI resource. Otherwise, leave it to be cleaned up
- * once no other VF uses it.
- */
-static void ice_free_vf_ctrl_res(struct ice_pf *pf,  struct ice_vsi *vsi)
-{
-	struct ice_vf *vf;
-	unsigned int bkt;
-
-	rcu_read_lock();
-	ice_for_each_vf_rcu(pf, bkt, vf) {
-		if (vf != vsi->vf && vf->ctrl_vsi_idx != ICE_NO_VSI) {
-			rcu_read_unlock();
-			return;
-		}
-	}
-	rcu_read_unlock();
-
-	/* No other VFs left that have control VSI. It is now safe to reclaim
-	 * SW interrupts back to the common pool.
-	 */
-	ice_free_res(pf->irq_tracker, vsi->base_vector,
-		     ICE_RES_VF_CTRL_VEC_ID);
-	pf->num_avail_sw_msix += vsi->num_q_vectors;
-}
-
 /**
  * ice_vsi_release - Delete a VSI and free its resources
  * @vsi: the VSI being removed
@@ -3151,7 +3273,6 @@ static void ice_free_vf_ctrl_res(struct ice_pf *pf,  struct ice_vsi *vsi)
 int ice_vsi_release(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf;
-	int err;
 
 	if (!vsi->back)
 		return -ENODEV;
@@ -3169,41 +3290,14 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	}
 
+	if (vsi->type == ICE_VSI_PF)
+		ice_devlink_destroy_pf_port(pf);
+
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
 	ice_vsi_close(vsi);
-
-	/* SR-IOV determines needed MSIX resources all at once instead of per
-	 * VSI since when VFs are spawned we know how many VFs there are and how
-	 * many interrupts each VF needs. SR-IOV MSIX resources are also
-	 * cleared in the same manner.
-	 */
-	if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
-		ice_free_vf_ctrl_res(pf, vsi);
-	} else if (vsi->type != ICE_VSI_VF) {
-		/* reclaim SW interrupts back to the common pool */
-		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
-		pf->num_avail_sw_msix += vsi->num_q_vectors;
-	}
-
-	/* The Rx rule will only exist to remove if the LLDP FW
-	 * engine is currently stopped
-	 */
-	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
-	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-		ice_cfg_sw_lldp(vsi, false, false);
-
-	if (ice_is_vsi_dflt_vsi(vsi))
-		ice_clear_dflt_vsi(vsi);
-	ice_fltr_remove_all(vsi);
-	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
-	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
-	if (err)
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
-			vsi->vsi_num, err);
-	ice_vsi_delete(vsi);
-	ice_vsi_free_q_vectors(vsi);
+	ice_vsi_decfg(vsi);
 
 	if (vsi->netdev) {
 		if (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state)) {
@@ -3217,13 +3311,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
-	if (vsi->type == ICE_VSI_VF &&
-	    vsi->agg_node && vsi->agg_node->valid)
-		vsi->agg_node->num_vsis--;
-	ice_vsi_clear_rings(vsi);
-	ice_vsi_free_stats(vsi);
-	ice_vsi_put_qs(vsi);
-
 	/* retain SW VSI data structure since it is needed to unregister and
 	 * free VSI netdev when PF is not in reset recovery pending state,\
 	 * for ex: during rmmod.
@@ -3392,29 +3479,24 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi, int prev_txq, int prev_rxq)
 /**
  * ice_vsi_rebuild - Rebuild VSI after reset
  * @vsi: VSI to be rebuild
- * @init_vsi: is this an initialization or a reconfigure of the VSI
+ * @init_vsi: flag, tell if VSI need to be initialized
  *
  * Returns 0 on success and negative value on failure
  */
-int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
+int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi)
 {
-	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_coalesce_stored *coalesce;
-	int ret, i, prev_txq, prev_rxq;
+	int ret, prev_txq, prev_rxq;
 	int prev_num_q_vectors = 0;
-	enum ice_vsi_type vtype;
 	struct ice_pf *pf;
 
 	if (!vsi)
 		return -EINVAL;
 
 	pf = vsi->back;
-	vtype = vsi->type;
-	if (WARN_ON(vtype == ICE_VSI_VF && !vsi->vf))
+	if (WARN_ON(vsi->type == ICE_VSI_VF && !vsi->vf))
 		return -EINVAL;
 
-	ice_vsi_init_vlan_ops(vsi);
-
 	coalesce = kcalloc(vsi->num_q_vectors,
 			   sizeof(struct ice_coalesce_stored), GFP_KERNEL);
 	if (!coalesce)
@@ -3425,163 +3507,16 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	prev_txq = vsi->num_txq;
 	prev_rxq = vsi->num_rxq;
 
-	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
-	ret = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
+	ice_vsi_decfg(vsi);
+	ret = ice_vsi_cfg_def(vsi, vsi->vf, vsi->ch);
 	if (ret)
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
-			vsi->vsi_num, ret);
-	ice_vsi_free_q_vectors(vsi);
-
-	/* SR-IOV determines needed MSIX resources all at once instead of per
-	 * VSI since when VFs are spawned we know how many VFs there are and how
-	 * many interrupts each VF needs. SR-IOV MSIX resources are also
-	 * cleared in the same manner.
-	 */
-	if (vtype != ICE_VSI_VF) {
-		/* reclaim SW interrupts back to the common pool */
-		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
-		pf->num_avail_sw_msix += vsi->num_q_vectors;
-		vsi->base_vector = 0;
-	}
-
-	if (ice_is_xdp_ena_vsi(vsi))
-		/* return value check can be skipped here, it always returns
-		 * 0 if reset is in progress
-		 */
-		ice_destroy_xdp_rings(vsi);
-	ice_vsi_put_qs(vsi);
-	ice_vsi_clear_rings(vsi);
-	ice_vsi_free_arrays(vsi);
-	if (vtype == ICE_VSI_VF)
-		ice_vsi_set_num_qs(vsi, vsi->vf);
-	else
-		ice_vsi_set_num_qs(vsi, NULL);
-
-	ret = ice_vsi_alloc_arrays(vsi);
-	if (ret < 0)
-		goto err_vsi;
-
-	ice_vsi_get_qs(vsi);
-
-	ice_alloc_fd_res(vsi);
-	ice_vsi_set_tc_cfg(vsi);
-
-	/* Initialize VSI struct elements and create VSI in FW */
-	ret = ice_vsi_init(vsi, init_vsi);
-	if (ret < 0)
-		goto err_vsi;
-
-	switch (vtype) {
-	case ICE_VSI_CTRL:
-	case ICE_VSI_SWITCHDEV_CTRL:
-	case ICE_VSI_PF:
-		ret = ice_vsi_alloc_q_vectors(vsi);
-		if (ret)
-			goto err_rings;
-
-		ret = ice_vsi_setup_vector_base(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_alloc_rings(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_alloc_ring_stats(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ice_vsi_map_rings_to_vectors(vsi);
-
-		vsi->stat_offsets_loaded = false;
-		if (ice_is_xdp_ena_vsi(vsi)) {
-			ret = ice_vsi_determine_xdp_res(vsi);
-			if (ret)
-				goto err_vectors;
-			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
-			if (ret)
-				goto err_vectors;
-		}
-		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
-		if (vtype != ICE_VSI_CTRL)
-			/* Do not exit if configuring RSS had an issue, at
-			 * least receive traffic on first queue. Hence no
-			 * need to capture return value
-			 */
-			if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
-				ice_vsi_cfg_rss_lut_key(vsi);
-
-		/* disable or enable CRC stripping */
-		if (vsi->netdev)
-			ice_vsi_cfg_crc_strip(vsi, !!(vsi->netdev->features &
-					      NETIF_F_RXFCS));
-
-		break;
-	case ICE_VSI_VF:
-		ret = ice_vsi_alloc_q_vectors(vsi);
-		if (ret)
-			goto err_rings;
-
-		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_alloc_rings(vsi);
-		if (ret)
-			goto err_vectors;
-
-		ret = ice_vsi_alloc_ring_stats(vsi);
-		if (ret)
-			goto err_vectors;
-
-		vsi->stat_offsets_loaded = false;
-		break;
-	case ICE_VSI_CHNL:
-		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
-			ice_vsi_cfg_rss_lut_key(vsi);
-			ice_vsi_set_rss_flow_fld(vsi);
-		}
-		break;
-	default:
-		break;
-	}
-
-	/* configure VSI nodes based on number of queues and TC's */
-	for (i = 0; i < vsi->tc_cfg.numtc; i++) {
-		/* configure VSI nodes based on number of queues and TC's.
-		 * ADQ creates VSIs for each TC/Channel but doesn't
-		 * allocate queues instead it reconfigures the PF queues
-		 * as per the TC command. So max_txqs should point to the
-		 * PF Tx queues.
-		 */
-		if (vtype == ICE_VSI_CHNL)
-			max_txqs[i] = pf->num_lan_tx;
-		else
-			max_txqs[i] = vsi->alloc_txq;
-
-		if (ice_is_xdp_ena_vsi(vsi))
-			max_txqs[i] += vsi->num_xdp_txq;
-	}
-
-	if (test_bit(ICE_FLAG_TC_MQPRIO, pf->flags))
-		/* If MQPRIO is set, means channel code path, hence for main
-		 * VSI's, use TC as 1
-		 */
-		ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, 1, max_txqs);
-	else
-		ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx,
-				      vsi->tc_cfg.ena_tc, max_txqs);
+		goto err_vsi_cfg;
 
+	ret = ice_vsi_cfg_tc_lan(pf, vsi);
 	if (ret) {
-		dev_err(ice_pf_to_dev(pf), "VSI %d failed lan queue config, error %d\n",
-			vsi->vsi_num, ret);
-		if (init_vsi) {
+		if (init_vsi & ICE_VSI_FLAG_INIT) {
 			ret = -EIO;
-			goto err_vectors;
+			goto err_vsi_cfg_tc_lan;
 		} else {
 			kfree(coalesce);
 			return ice_schedule_reset(pf, ICE_RESET_PFR);
@@ -3589,25 +3524,16 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	}
 
 	if (ice_vsi_realloc_stat_arrays(vsi, prev_txq, prev_rxq))
-		goto err_vectors;
+		goto err_vsi_cfg_tc_lan;
 
 	ice_vsi_rebuild_set_coalesce(vsi, coalesce, prev_num_q_vectors);
 	kfree(coalesce);
 
 	return 0;
 
-err_vectors:
-	ice_vsi_free_q_vectors(vsi);
-err_rings:
-	if (vsi->netdev) {
-		vsi->current_netdev_flags = 0;
-		unregister_netdev(vsi->netdev);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
-err_vsi:
-	ice_vsi_free(vsi);
-	set_bit(ICE_RESET_FAILED, pf->state);
+err_vsi_cfg_tc_lan:
+	ice_vsi_decfg(vsi);
+err_vsi_cfg:
 	kfree(coalesce);
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 6203114b805c..ad4d5314ca76 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -61,8 +61,11 @@ int ice_vsi_release(struct ice_vsi *vsi);
 
 void ice_vsi_close(struct ice_vsi *vsi);
 
+int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf,
+		struct ice_channel *ch);
 int ice_ena_vsi(struct ice_vsi *vsi, bool locked);
 
+void ice_vsi_decfg(struct ice_vsi *vsi);
 void ice_dis_vsi(struct ice_vsi *vsi, bool locked);
 
 int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
@@ -70,7 +73,9 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id);
 int
 ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id);
 
-int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi);
+#define ICE_VSI_FLAG_INIT	BIT(0)
+#define ICE_VSI_FLAG_NO_INIT	0
+int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 int ice_wait_for_reset(struct ice_pf *pf, unsigned long timeout);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 703a732c421d..9c21dde0fcdf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4220,13 +4220,13 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 
 	/* set for the next time the netdev is started */
 	if (!netif_running(vsi->netdev)) {
-		ice_vsi_rebuild(vsi, false);
+		ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 		dev_dbg(ice_pf_to_dev(pf), "Link is down, queue count change happens when link is brought up\n");
 		goto done;
 	}
 
 	ice_vsi_close(vsi);
-	ice_vsi_rebuild(vsi, false);
+	ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
 done:
@@ -7056,7 +7056,7 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 			continue;
 
 		/* rebuild the VSI */
-		err = ice_vsi_rebuild(vsi, true);
+		err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_INIT);
 		if (err) {
 			dev_err(dev, "rebuild VSI failed, err %d, VSI index %d, type %s\n",
 				err, vsi->idx, ice_vsi_type_str(type));
@@ -8465,7 +8465,7 @@ static int ice_rebuild_channels(struct ice_pf *pf)
 		type = vsi->type;
 
 		/* rebuild ADQ VSI */
-		err = ice_vsi_rebuild(vsi, true);
+		err = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_INIT);
 		if (err) {
 			dev_err(dev, "VSI (type:%s) at index %d rebuild failed, err %d\n",
 				ice_vsi_type_str(type), vsi->idx, err);
@@ -8697,14 +8697,14 @@ static int ice_setup_tc_mqprio_qdisc(struct net_device *netdev, void *type_data)
 	cur_rxq = vsi->num_rxq;
 
 	/* proceed with rebuild main VSI using correct number of queues */
-	ret = ice_vsi_rebuild(vsi, false);
+	ret = ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 	if (ret) {
 		/* fallback to current number of queues */
 		dev_info(dev, "Rebuild failed with new queues, try with current number of queues\n");
 		vsi->req_txq = cur_txq;
 		vsi->req_rxq = cur_rxq;
 		clear_bit(ICE_RESET_FAILED, pf->state);
-		if (ice_vsi_rebuild(vsi, false)) {
+		if (ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT)) {
 			dev_err(dev, "Rebuild of main VSI failed again\n");
 			return ret;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 375eb6493f0f..c3b406df269f 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -256,7 +256,7 @@ static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 	if (WARN_ON(!vsi))
 		return -EINVAL;
 
-	if (ice_vsi_rebuild(vsi, true)) {
+	if (ice_vsi_rebuild(vsi, ICE_VSI_FLAG_INIT)) {
 		dev_err(ice_pf_to_dev(pf), "failed to rebuild VF %d VSI\n",
 			vf->vf_id);
 		return -EIO;
-- 
2.38.1

