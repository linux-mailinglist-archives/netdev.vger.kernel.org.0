Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613483F18F0
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhHSMP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:15:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:50609 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239281AbhHSMPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:15:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="277560958"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="277560958"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 05:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="532195096"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 19 Aug 2021 05:15:16 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 intel-next 2/9] ice: move ice_container_type onto ice_ring_container
Date:   Thu, 19 Aug 2021 13:59:57 +0200
Message-Id: <20210819120004.34392-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ice_container_type is scoped only for ice_ethtool.c. Next
commit that will split the ice_ring struct onto Rx/Tx specific ring
structs is going to also modify the type of linked list of rings that is
within ice_ring_container. Therefore, the functions that are taking the
ice_ring_container as an input argument will need to be aware of a ring
type that will be looked up.

Embed ice_container_type within ice_ring_container and initialize it
properly when allocating the q_vectors.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c    |  2 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 38 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_txrx.h    |  6 ++++
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 59a0f312dab9..feb07750acb6 100644
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
index 54ccba8992ee..91efc8389df6 100644
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
@@ -3618,7 +3611,6 @@ ice_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
 
 /**
  * ice_set_rc_coalesce - set ITR values for specific ring container
- * @c_type: container type, Rx or Tx
  * @ec: ethtool structure from user to update ITR settings
  * @rc: ring container that the ITR values will come from
  * @vsi: VSI associated to the ring container
@@ -3630,10 +3622,10 @@ ice_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
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
@@ -3641,7 +3633,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 	if (!rc->ring)
 		return -EINVAL;
 
-	switch (c_type) {
+	switch (rc->type) {
 	case ICE_RX_CONTAINER:
 		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
 		    (ec->rx_coalesce_usecs_high &&
@@ -3674,7 +3666,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		break;
 	default:
 		dev_dbg(ice_pf_to_dev(pf), "Invalid container type %d\n",
-			c_type);
+			rc->type);
 		return -EINVAL;
 	}
 
@@ -3723,22 +3715,22 @@ static int
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
index 901f16f1d286..58127376cfe4 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -336,6 +336,11 @@ static inline bool ice_ring_is_xdp(struct ice_ring *ring)
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
@@ -347,6 +352,7 @@ struct ice_ring_container {
 	u16 itr_setting:13;
 	u16 itr_reserved:2;
 	u16 itr_mode:1;
+	enum ice_container_type type;
 };
 
 struct ice_coalesce_stored {
-- 
2.20.1

