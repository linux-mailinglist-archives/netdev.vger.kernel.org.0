Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7227742F82A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbhJOQdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:33:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:37917 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241359AbhJOQdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 12:33:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10138"; a="208059627"
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="208059627"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 09:31:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="528205561"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 15 Oct 2021 09:31:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com,
        songliubraving@fb.com, bpf@vger.kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/9] ice: move ice_container_type onto ice_ring_container
Date:   Fri, 15 Oct 2021 09:29:01 -0700
Message-Id: <20211015162908.145341-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
References: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Currently ice_container_type is scoped only for ice_ethtool.c. Next
commit that will split the ice_ring struct onto Rx/Tx specific ring
structs is going to also modify the type of linked list of rings that is
within ice_ring_container. Therefore, the functions that are taking the
ice_ring_container as an input argument will need to be aware of a ring
type that will be looked up.

Embed ice_container_type within ice_ring_container and initialize it
properly when allocating the q_vectors.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c    |  2 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 38 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_txrx.h    |  6 ++++
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index d7a5ac9346bc..b932759d6347 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -115,6 +115,8 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 	q_vector->rx.itr_setting = ICE_DFLT_RX_ITR;
 	q_vector->tx.itr_mode = ITR_DYNAMIC;
 	q_vector->rx.itr_mode = ITR_DYNAMIC;
+	q_vector->tx.type = ICE_TX_CONTAINER;
+	q_vector->rx.type = ICE_RX_CONTAINER;
 
 	if (vsi->type == ICE_VSI_VF)
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 201979cc47fb..ecaf5c05eaf6 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3501,15 +3501,9 @@ static int ice_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 	return 0;
 }
 
-enum ice_container_type {
-	ICE_RX_CONTAINER,
-	ICE_TX_CONTAINER,
-};
-
 /**
  * ice_get_rc_coalesce - get ITR values for specific ring container
  * @ec: ethtool structure to fill with driver's coalesce settings
- * @c_type: container type, Rx or Tx
  * @rc: ring container that the ITR values will come from
  *
  * Query the device for ice_ring_container specific ITR values. This is
@@ -3519,13 +3513,12 @@ enum ice_container_type {
  * Returns 0 on success, negative otherwise.
  */
 static int
-ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
-		    struct ice_ring_container *rc)
+ice_get_rc_coalesce(struct ethtool_coalesce *ec, struct ice_ring_container *rc)
 {
 	if (!rc->ring)
 		return -EINVAL;
 
-	switch (c_type) {
+	switch (rc->type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc);
 		ec->rx_coalesce_usecs = rc->itr_setting;
@@ -3536,7 +3529,7 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		ec->tx_coalesce_usecs = rc->itr_setting;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", rc->type);
 		return -EINVAL;
 	}
 
@@ -3557,18 +3550,18 @@ static int
 ice_get_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
 {
 	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
-		if (ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx))
 			return -EINVAL;
-		if (ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx))
 			return -EINVAL;
 	} else if (q_num < vsi->num_rxq) {
-		if (ice_get_rc_coalesce(ec, ICE_RX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx))
 			return -EINVAL;
 	} else if (q_num < vsi->num_txq) {
-		if (ice_get_rc_coalesce(ec, ICE_TX_CONTAINER,
+		if (ice_get_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx))
 			return -EINVAL;
 	} else {
@@ -3620,7 +3613,6 @@ ice_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
 
 /**
  * ice_set_rc_coalesce - set ITR values for specific ring container
- * @c_type: container type, Rx or Tx
  * @ec: ethtool structure from user to update ITR settings
  * @rc: ring container that the ITR values will come from
  * @vsi: VSI associated to the ring container
@@ -3632,10 +3624,10 @@ ice_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
  * Returns 0 on success, negative otherwise.
  */
 static int
-ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
+ice_set_rc_coalesce(struct ethtool_coalesce *ec,
 		    struct ice_ring_container *rc, struct ice_vsi *vsi)
 {
-	const char *c_type_str = (c_type == ICE_RX_CONTAINER) ? "rx" : "tx";
+	const char *c_type_str = (rc->type == ICE_RX_CONTAINER) ? "rx" : "tx";
 	u32 use_adaptive_coalesce, coalesce_usecs;
 	struct ice_pf *pf = vsi->back;
 	u16 itr_setting;
@@ -3643,7 +3635,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 	if (!rc->ring)
 		return -EINVAL;
 
-	switch (c_type) {
+	switch (rc->type) {
 	case ICE_RX_CONTAINER:
 		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
 		    (ec->rx_coalesce_usecs_high &&
@@ -3676,7 +3668,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		break;
 	default:
 		dev_dbg(ice_pf_to_dev(pf), "Invalid container type %d\n",
-			c_type);
+			rc->type);
 		return -EINVAL;
 	}
 
@@ -3725,22 +3717,22 @@ static int
 ice_set_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
 {
 	if (q_num < vsi->num_rxq && q_num < vsi->num_txq) {
-		if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx,
 					vsi))
 			return -EINVAL;
 
-		if (ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx,
 					vsi))
 			return -EINVAL;
 	} else if (q_num < vsi->num_rxq) {
-		if (ice_set_rc_coalesce(ICE_RX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->rx_rings[q_num]->q_vector->rx,
 					vsi))
 			return -EINVAL;
 	} else if (q_num < vsi->num_txq) {
-		if (ice_set_rc_coalesce(ICE_TX_CONTAINER, ec,
+		if (ice_set_rc_coalesce(ec,
 					&vsi->tx_rings[q_num]->q_vector->tx,
 					vsi))
 			return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 24e123cd6554..bf40608f9bac 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -330,6 +330,11 @@ static inline bool ice_ring_is_xdp(struct ice_ring *ring)
 	return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
 }
 
+enum ice_container_type {
+	ICE_RX_CONTAINER,
+	ICE_TX_CONTAINER,
+};
+
 struct ice_ring_container {
 	/* head of linked-list of rings */
 	struct ice_ring *ring;
@@ -341,6 +346,7 @@ struct ice_ring_container {
 	u16 itr_setting:13;
 	u16 itr_reserved:2;
 	u16 itr_mode:1;
+	enum ice_container_type type;
 };
 
 struct ice_coalesce_stored {
-- 
2.31.1

