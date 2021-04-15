Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA9D35FEDB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhDOA24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:28:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:27426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhDOA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:48 -0400
IronPort-SDR: VRj+aQT1zPbmW+YuOmxxUYTgZCNIEtDgtdpZs0bVsb4lkWnDSDq7YlbLXKlpFRMwE04kD3BFIs
 U78ULeX90eaA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262227"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262227"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: t4QbZ7uFV/n4aXRoJbuUVdde+UNQ+Eb7MPHNR3z707ij4wUHkbCsOV4ZvjftTpVrK4HXFyTL/L
 sN1gPqwinGgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379516"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 07/15] ice: refactor ITR data structures
Date:   Wed, 14 Apr 2021 17:30:05 -0700
Message-Id: <20210415003013.19717-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Use a dedicated bitfield in order to both increase
the amount of checking around the length of ITR writes
as well as simplify the checks of dynamic mode.

Basically unpack the "high bit means dynamic" logic
into bitfields.

Also, remove some unused ITR defines.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c    |  3 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 15 +++++-----
 drivers/net/ethernet/intel/ice/ice_lib.c     |  7 -----
 drivers/net/ethernet/intel/ice/ice_txrx.c    |  4 +--
 drivers/net/ethernet/intel/ice/ice_txrx.h    | 30 +++++++++-----------
 5 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 21eb5d447d31..5985a7e5ca8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -113,6 +113,9 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
 	q_vector->v_idx = v_idx;
 	q_vector->tx.itr_setting = ICE_DFLT_TX_ITR;
 	q_vector->rx.itr_setting = ICE_DFLT_RX_ITR;
+	q_vector->tx.itr_mode = ITR_DYNAMIC;
+	q_vector->rx.itr_mode = ITR_DYNAMIC;
+
 	if (vsi->type == ICE_VSI_VF)
 		goto out;
 	/* only set affinity_mask if the CPU is online */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 6c057eb6cc45..68c8ad8d157e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3510,13 +3510,13 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
-		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc->itr_setting);
-		ec->rx_coalesce_usecs = rc->itr_setting & ~ICE_ITR_DYNAMIC;
+		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc);
+		ec->rx_coalesce_usecs = rc->itr_setting;
 		ec->rx_coalesce_usecs_high = rc->ring->q_vector->intrl;
 		break;
 	case ICE_TX_CONTAINER:
-		ec->use_adaptive_tx_coalesce = ITR_IS_DYNAMIC(rc->itr_setting);
-		ec->tx_coalesce_usecs = rc->itr_setting & ~ICE_ITR_DYNAMIC;
+		ec->use_adaptive_tx_coalesce = ITR_IS_DYNAMIC(rc);
+		ec->tx_coalesce_usecs = rc->itr_setting;
 		break;
 	default:
 		dev_dbg(ice_pf_to_dev(pf), "Invalid c_type %d\n", c_type);
@@ -3661,7 +3661,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		return -EINVAL;
 	}
 
-	itr_setting = rc->itr_setting & ~ICE_ITR_DYNAMIC;
+	itr_setting = rc->itr_setting;
 	if (coalesce_usecs != itr_setting && use_adaptive_coalesce) {
 		netdev_info(vsi->netdev, "%s interrupt throttling cannot be changed if adaptive-%s is enabled\n",
 			    c_type_str, c_type_str);
@@ -3675,8 +3675,9 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 	}
 
 	if (use_adaptive_coalesce) {
-		rc->itr_setting |= ICE_ITR_DYNAMIC;
+		rc->itr_mode = ITR_DYNAMIC;
 	} else {
+		rc->itr_mode = ITR_STATIC;
 		/* store user facing value how it was set */
 		rc->itr_setting = coalesce_usecs;
 		/* write the change to the register */
@@ -3747,8 +3748,6 @@ ice_print_if_odd_usecs(struct net_device *netdev, u16 itr_setting,
 	if (use_adaptive_coalesce)
 		return;
 
-	itr_setting = ITR_TO_REG(itr_setting);
-
 	if (itr_setting != coalesce_usecs && (coalesce_usecs % 2))
 		netdev_info(netdev, "User set %s-usecs to %d, device only supports even values. Rounding down and attempting to set %s-usecs to %d\n",
 			    c_type_str, coalesce_usecs, c_type_str,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a080cf7bc2d1..45837e9eee86 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1816,10 +1816,6 @@ static void __ice_write_itr(struct ice_q_vector *q_vector,
  * ice_write_itr - write throttle rate to queue specific register
  * @rc: pointer to ring container
  * @itr: throttle rate in microseconds to write
- *
- * This function is resilient to having the 0x8000 bit set which
- * is indicating that an ITR value is "DYNAMIC", and will write
- * the correct value to the register.
  */
 void ice_write_itr(struct ice_ring_container *rc, u16 itr)
 {
@@ -1830,9 +1826,6 @@ void ice_write_itr(struct ice_ring_container *rc, u16 itr)
 
 	q_vector = rc->ring->q_vector;
 
-	/* clear the "DYNAMIC" bit */
-	itr = ITR_TO_REG(itr);
-
 	__ice_write_itr(q_vector, rc, itr);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1ce9ad02477d..e2b4b29ea207 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1236,7 +1236,7 @@ static void ice_net_dim(struct ice_q_vector *q_vector)
 	struct ice_ring_container *tx = &q_vector->tx;
 	struct ice_ring_container *rx = &q_vector->rx;
 
-	if (ITR_IS_DYNAMIC(tx->itr_setting)) {
+	if (ITR_IS_DYNAMIC(tx)) {
 		struct dim_sample dim_sample = {};
 		u64 packets = 0, bytes = 0;
 		struct ice_ring *ring;
@@ -1252,7 +1252,7 @@ static void ice_net_dim(struct ice_q_vector *q_vector)
 		net_dim(&tx->dim, dim_sample);
 	}
 
-	if (ITR_IS_DYNAMIC(rx->itr_setting)) {
+	if (ITR_IS_DYNAMIC(rx)) {
 		struct dim_sample dim_sample = {};
 		u64 packets = 0, bytes = 0;
 		struct ice_ring *ring;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ae12b4e6453b..c5a92ac787d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -223,23 +223,20 @@ enum ice_rx_dtype {
 #define ICE_TX_ITR	ICE_IDX_ITR1
 #define ICE_ITR_8K	124
 #define ICE_ITR_20K	50
-#define ICE_ITR_MAX	8160
-#define ICE_DFLT_TX_ITR	(ICE_ITR_20K | ICE_ITR_DYNAMIC)
-#define ICE_DFLT_RX_ITR	(ICE_ITR_20K | ICE_ITR_DYNAMIC)
-#define ICE_ITR_DYNAMIC	0x8000  /* used as flag for itr_setting */
-#define ITR_IS_DYNAMIC(setting) (!!((setting) & ICE_ITR_DYNAMIC))
-#define ITR_TO_REG(setting)	((setting) & ~ICE_ITR_DYNAMIC)
+#define ICE_ITR_MAX	8160 /* 0x1FE0 */
+#define ICE_DFLT_TX_ITR	ICE_ITR_20K
+#define ICE_DFLT_RX_ITR	ICE_ITR_20K
+enum ice_dynamic_itr {
+	ITR_STATIC = 0,
+	ITR_DYNAMIC = 1
+};
+
+#define ITR_IS_DYNAMIC(rc) ((rc)->itr_mode == ITR_DYNAMIC)
 #define ICE_ITR_GRAN_S		1	/* ITR granularity is always 2us */
 #define ICE_ITR_GRAN_US		BIT(ICE_ITR_GRAN_S)
 #define ICE_ITR_MASK		0x1FFE	/* ITR register value alignment mask */
 #define ITR_REG_ALIGN(setting)	((setting) & ICE_ITR_MASK)
 
-#define ICE_ITR_ADAPTIVE_MIN_INC	0x0002
-#define ICE_ITR_ADAPTIVE_MIN_USECS	0x0002
-#define ICE_ITR_ADAPTIVE_MAX_USECS	0x00FA
-#define ICE_ITR_ADAPTIVE_LATENCY	0x8000
-#define ICE_ITR_ADAPTIVE_BULK		0x0000
-
 #define ICE_DFLT_INTRL	0
 #define ICE_MAX_INTRL	236
 
@@ -341,11 +338,12 @@ struct ice_ring_container {
 	struct ice_ring *ring;
 	struct dim dim;		/* data for net_dim algorithm */
 	u16 itr_idx;		/* index in the interrupt vector */
-	/* high bit set means dynamic ITR, rest is used to store user
-	 * readable ITR value in usecs and must be converted before programming
-	 * to a register.
+	/* this matches the maximum number of ITR bits, but in usec
+	 * values, so it is shifted left one bit (bit zero is ignored)
 	 */
-	u16 itr_setting;
+	u16 itr_setting:13;
+	u16 itr_reserved:2;
+	u16 itr_mode:1;
 };
 
 struct ice_coalesce_stored {
-- 
2.26.2

