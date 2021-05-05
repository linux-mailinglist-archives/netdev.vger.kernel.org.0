Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D053743F8
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhEEQxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236705AbhEEQub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6D4E61952;
        Wed,  5 May 2021 16:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232652;
        bh=Y8VaKQ/W1YLxBCnWLU7ZSSPoPp+ymXUucgo4S9fjp4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6x/hP/JmyDrNd6WCFU93adsEN/zVd52HvxvFkESuujeV37OYP0d4HpIv+OW2T1IC
         10bcktVSzntggd9kjyNYO57x76Arfg8xE/9OnMsqQSB+99s3Q4XG70W/vy0NOGVF74
         YtVTdmt4JVCtZoFIsoHNRQaSecCSg39P6AEq2ILNo5PBNVCn16mv7pi45l2NdNtf8s
         Xo4WXS9t3nkI+cXV13QrLUSoc8VpdhrTfn8yy8l/9vvX98Brre+JqQABsZ/ORqbd5Q
         WBvrTmm9MCSvopNfYzMjWr5QaRQDyrVtnWfUbOorQ2NvHFs+GS4bJUk0cw4+wrPhTZ
         9pRZl1OmLRTnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/85] ice: handle increasing Tx or Rx ring sizes
Date:   Wed,  5 May 2021 12:35:53 -0400
Message-Id: <20210505163648.3462507-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 2ec5638559c13b923250eccf495d2a033fccb3e7 ]

There is an issue when the Tx or Rx ring size increases using
'ethtool -L ...' where the new rings don't get the correct ITR
values because when we rebuild the VSI we don't know that some
of the rings may be new.

Fix this by looking at the original number of rings and
determining if the rings in ice_vsi_rebuild_set_coalesce()
were not present in the original rings received in
ice_vsi_rebuild_get_coalesce().

Also change the code to return an error if we can't allocate
memory for the coalesce data in ice_vsi_rebuild().

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 123 ++++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +
 2 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 170367eaa95a..e1384503dd4d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2684,38 +2684,46 @@ int ice_vsi_release(struct ice_vsi *vsi)
 }
 
 /**
- * ice_vsi_rebuild_update_coalesce - set coalesce for a q_vector
+ * ice_vsi_rebuild_update_coalesce_intrl - set interrupt rate limit for a q_vector
  * @q_vector: pointer to q_vector which is being updated
- * @coalesce: pointer to array of struct with stored coalesce
+ * @stored_intrl_setting: original INTRL setting
  *
  * Set coalesce param in q_vector and update these parameters in HW.
  */
 static void
-ice_vsi_rebuild_update_coalesce(struct ice_q_vector *q_vector,
-				struct ice_coalesce_stored *coalesce)
+ice_vsi_rebuild_update_coalesce_intrl(struct ice_q_vector *q_vector,
+				      u16 stored_intrl_setting)
 {
-	struct ice_ring_container *rx_rc = &q_vector->rx;
-	struct ice_ring_container *tx_rc = &q_vector->tx;
 	struct ice_hw *hw = &q_vector->vsi->back->hw;
 
-	tx_rc->itr_setting = coalesce->itr_tx;
-	rx_rc->itr_setting = coalesce->itr_rx;
-
-	/* dynamic ITR values will be updated during Tx/Rx */
-	if (!ITR_IS_DYNAMIC(tx_rc->itr_setting))
-		wr32(hw, GLINT_ITR(tx_rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(tx_rc->itr_setting) >>
-		     ICE_ITR_GRAN_S);
-	if (!ITR_IS_DYNAMIC(rx_rc->itr_setting))
-		wr32(hw, GLINT_ITR(rx_rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(rx_rc->itr_setting) >>
-		     ICE_ITR_GRAN_S);
-
-	q_vector->intrl = coalesce->intrl;
+	q_vector->intrl = stored_intrl_setting;
 	wr32(hw, GLINT_RATE(q_vector->reg_idx),
 	     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
 }
 
+/**
+ * ice_vsi_rebuild_update_coalesce_itr - set coalesce for a q_vector
+ * @q_vector: pointer to q_vector which is being updated
+ * @rc: pointer to ring container
+ * @stored_itr_setting: original ITR setting
+ *
+ * Set coalesce param in q_vector and update these parameters in HW.
+ */
+static void
+ice_vsi_rebuild_update_coalesce_itr(struct ice_q_vector *q_vector,
+				    struct ice_ring_container *rc,
+				    u16 stored_itr_setting)
+{
+	struct ice_hw *hw = &q_vector->vsi->back->hw;
+
+	rc->itr_setting = stored_itr_setting;
+
+	/* dynamic ITR values will be updated during Tx/Rx */
+	if (!ITR_IS_DYNAMIC(rc->itr_setting))
+		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
+		     ITR_REG_ALIGN(rc->itr_setting) >> ICE_ITR_GRAN_S);
+}
+
 /**
  * ice_vsi_rebuild_get_coalesce - get coalesce from all q_vectors
  * @vsi: VSI connected with q_vectors
@@ -2735,6 +2743,11 @@ ice_vsi_rebuild_get_coalesce(struct ice_vsi *vsi,
 		coalesce[i].itr_tx = q_vector->tx.itr_setting;
 		coalesce[i].itr_rx = q_vector->rx.itr_setting;
 		coalesce[i].intrl = q_vector->intrl;
+
+		if (i < vsi->num_txq)
+			coalesce[i].tx_valid = true;
+		if (i < vsi->num_rxq)
+			coalesce[i].rx_valid = true;
 	}
 
 	return vsi->num_q_vectors;
@@ -2759,17 +2772,59 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 	if ((size && !coalesce) || !vsi)
 		return;
 
-	for (i = 0; i < size && i < vsi->num_q_vectors; i++)
-		ice_vsi_rebuild_update_coalesce(vsi->q_vectors[i],
-						&coalesce[i]);
-
-	/* number of q_vectors increased, so assume coalesce settings were
-	 * changed globally (i.e. ethtool -C eth0 instead of per-queue) and use
-	 * the previous settings from q_vector 0 for all of the new q_vectors
+	/* There are a couple of cases that have to be handled here:
+	 *   1. The case where the number of queue vectors stays the same, but
+	 *      the number of Tx or Rx rings changes (the first for loop)
+	 *   2. The case where the number of queue vectors increased (the
+	 *      second for loop)
 	 */
-	for (; i < vsi->num_q_vectors; i++)
-		ice_vsi_rebuild_update_coalesce(vsi->q_vectors[i],
-						&coalesce[0]);
+	for (i = 0; i < size && i < vsi->num_q_vectors; i++) {
+		/* There are 2 cases to handle here and they are the same for
+		 * both Tx and Rx:
+		 *   if the entry was valid previously (coalesce[i].[tr]x_valid
+		 *   and the loop variable is less than the number of rings
+		 *   allocated, then write the previous values
+		 *
+		 *   if the entry was not valid previously, but the number of
+		 *   rings is less than are allocated (this means the number of
+		 *   rings increased from previously), then write out the
+		 *   values in the first element
+		 */
+		if (i < vsi->alloc_rxq && coalesce[i].rx_valid)
+			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
+							    &vsi->q_vectors[i]->rx,
+							    coalesce[i].itr_rx);
+		else if (i < vsi->alloc_rxq)
+			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
+							    &vsi->q_vectors[i]->rx,
+							    coalesce[0].itr_rx);
+
+		if (i < vsi->alloc_txq && coalesce[i].tx_valid)
+			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
+							    &vsi->q_vectors[i]->tx,
+							    coalesce[i].itr_tx);
+		else if (i < vsi->alloc_txq)
+			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
+							    &vsi->q_vectors[i]->tx,
+							    coalesce[0].itr_tx);
+
+		ice_vsi_rebuild_update_coalesce_intrl(vsi->q_vectors[i],
+						      coalesce[i].intrl);
+	}
+
+	/* the number of queue vectors increased so write whatever is in
+	 * the first element
+	 */
+	for (; i < vsi->num_q_vectors; i++) {
+		ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
+						    &vsi->q_vectors[i]->tx,
+						    coalesce[0].itr_tx);
+		ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
+						    &vsi->q_vectors[i]->rx,
+						    coalesce[0].itr_rx);
+		ice_vsi_rebuild_update_coalesce_intrl(vsi->q_vectors[i],
+						      coalesce[0].intrl);
+	}
 }
 
 /**
@@ -2798,9 +2853,11 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 	coalesce = kcalloc(vsi->num_q_vectors,
 			   sizeof(struct ice_coalesce_stored), GFP_KERNEL);
-	if (coalesce)
-		prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi,
-								  coalesce);
+	if (!coalesce)
+		return -ENOMEM;
+
+	prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi, coalesce);
+
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	ice_vsi_free_q_vectors(vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ff1a1cbd078e..eab7ceae926b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -351,6 +351,8 @@ struct ice_coalesce_stored {
 	u16 itr_tx;
 	u16 itr_rx;
 	u8 intrl;
+	u8 tx_valid;
+	u8 rx_valid;
 };
 
 /* iterator for handling rings in ring container */
-- 
2.30.2

