Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0535FEDC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhDOA25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:28:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231477AbhDOA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:48 -0400
IronPort-SDR: muV0/KqAP9Uc8SA3qvwAsbSVzFjKaz+UvU8bkWoGbnHlvIVFS2NnmDCr22FnRxyrci25VHdDCt
 0T9Ra52QtZhg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262230"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262230"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: UJKyb9oCG+hIPbUPTlnsY1xd1pgq7p7ZINFkPHVT77nebWnFum75OK1D2RQFo8cS0WKHaKFJQo
 N9nlGIzwrPsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379512"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 05/15] ice: replace custom AIM algorithm with kernel's DIM library
Date:   Wed, 14 Apr 2021 17:30:03 -0700
Message-Id: <20210415003013.19717-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice driver has support for adaptive interrupt moderation, an
algorithm for tuning the interrupt rate dynamically. This algorithm
is based on various assumptions about ring size, socket buffer size,
link speed, SKB overhead, ethernet frame overhead and more.

The Linux kernel has support for a dynamic interrupt moderation
algorithm known as "dimlib". Replace the custom driver-specific
implementation of dynamic interrupt moderation with the kernel's
algorithm.

The Intel hardware has a different hardware implementation than the
originators of the dimlib code had to work with, which requires the
driver to use a slightly different set of inputs for the actual
moderation values, while getting all the advice from dimlib of
better/worse, shift left or right.

The change made for this implementation is to use a pair of values
for each of the 5 "slots" that the dimlib moderation expects, and
the driver will program those pairs when dimlib recommends a slot to
use. The currently implementation uses two tables, one for receive
and one for transmit, and the pairs of values in each slot set the
maximum delay of an interrupt and a maximum number of interrupts per
second (both expressed in microseconds).

There are two separate kinds of bugs fixed by using DIMLIB, one is
UDP single stream send was too slow, and the other is that 8K
ping-pong was going to the most aggressive moderation and has much
too high latency.

The overall result of using DIMLIB is that we meet or exceed our
performance expectations set based on the old algorithm.

Co-developed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig           |   1 +
 drivers/net/ethernet/intel/ice/ice.h         |   5 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |   6 +
 drivers/net/ethernet/intel/ice/ice_lib.c     |  13 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 108 +++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 303 +++----------------
 drivers/net/ethernet/intel/ice/ice_txrx.h    |   6 +-
 7 files changed, 175 insertions(+), 267 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 5aa86318ed3e..c1d155690341 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -294,6 +294,7 @@ config ICE
 	tristate "Intel(R) Ethernet Connection E800 Series Support"
 	default n
 	depends on PCI_MSI
+	select DIMLIB
 	select NET_DEVLINK
 	select PLDMFW
 	help
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5e1a680e8a8e..7ae10fd87265 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -36,6 +36,7 @@
 #include <linux/bpf.h>
 #include <linux/avf/virtchnl.h>
 #include <linux/cpu_rmap.h>
+#include <linux/dim.h>
 #include <net/devlink.h>
 #include <net/ipv6.h>
 #include <net/xdp_sock.h>
@@ -351,7 +352,7 @@ struct ice_q_vector {
 	u16 reg_idx;
 	u8 num_ring_rx;			/* total number of Rx rings in vector */
 	u8 num_ring_tx;			/* total number of Tx rings in vector */
-	u8 itr_countdown;		/* when 0 should adjust adaptive ITR */
+	u8 wb_on_itr:1;			/* if true, WB on ITR is enabled */
 	/* in usecs, need to use ice_intrl_to_usecs_reg() before writing this
 	 * value to the device
 	 */
@@ -366,6 +367,8 @@ struct ice_q_vector {
 	struct irq_affinity_notify affinity_notify;
 
 	char name[ICE_INT_NAME_STR_LEN];
+
+	u16 total_events;	/* net_dim(): number of interrupts processed */
 } ____cacheline_internodealigned_in_smp;
 
 enum ice_pf_flags {
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e273560d9e6e..6c057eb6cc45 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3634,6 +3634,12 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 				    ICE_MAX_INTRL);
 			return -EINVAL;
 		}
+		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl &&
+		    (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)) {
+			netdev_info(vsi->netdev, "Invalid value, %s-usecs-high cannot be changed if adaptive-tx or adaptive-rx is enabled\n",
+				    c_type_str);
+			return -EINVAL;
+		}
 		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl) {
 			rc->ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
 			ice_write_intrl(rc->ring->q_vector,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index bb47376386f4..a080cf7bc2d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -385,6 +385,8 @@ static irqreturn_t ice_msix_clean_rings(int __always_unused irq, void *data)
 	if (!q_vector->tx.ring && !q_vector->rx.ring)
 		return IRQ_HANDLED;
 
+	q_vector->total_events++;
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
@@ -3270,20 +3272,15 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 /**
  * ice_update_ring_stats - Update ring statistics
  * @ring: ring to update
- * @cont: used to increment per-vector counters
  * @pkts: number of processed packets
  * @bytes: number of processed bytes
  *
  * This function assumes that caller has acquired a u64_stats_sync lock.
  */
-static void
-ice_update_ring_stats(struct ice_ring *ring, struct ice_ring_container *cont,
-		      u64 pkts, u64 bytes)
+static void ice_update_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes)
 {
 	ring->stats.bytes += bytes;
 	ring->stats.pkts += pkts;
-	cont->total_bytes += bytes;
-	cont->total_pkts += pkts;
 }
 
 /**
@@ -3295,7 +3292,7 @@ ice_update_ring_stats(struct ice_ring *ring, struct ice_ring_container *cont,
 void ice_update_tx_ring_stats(struct ice_ring *tx_ring, u64 pkts, u64 bytes)
 {
 	u64_stats_update_begin(&tx_ring->syncp);
-	ice_update_ring_stats(tx_ring, &tx_ring->q_vector->tx, pkts, bytes);
+	ice_update_ring_stats(tx_ring, pkts, bytes);
 	u64_stats_update_end(&tx_ring->syncp);
 }
 
@@ -3308,7 +3305,7 @@ void ice_update_tx_ring_stats(struct ice_ring *tx_ring, u64 pkts, u64 bytes)
 void ice_update_rx_ring_stats(struct ice_ring *rx_ring, u64 pkts, u64 bytes)
 {
 	u64_stats_update_begin(&rx_ring->syncp);
-	ice_update_ring_stats(rx_ring, &rx_ring->q_vector->rx, pkts, bytes);
+	ice_update_ring_stats(rx_ring, pkts, bytes);
 	u64_stats_update_end(&rx_ring->syncp);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 035c593bce61..1e023d163447 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5196,6 +5196,105 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 	return err;
 }
 
+/* THEORY OF MODERATION:
+ * The below code creates custom DIM profiles for use by this driver, because
+ * the ice driver hardware works differently than the hardware that DIMLIB was
+ * originally made for. ice hardware doesn't have packet count limits that
+ * can trigger an interrupt, but it *does* have interrupt rate limit support,
+ * and this code adds that capability to be used by the driver when it's using
+ * DIMLIB. The DIMLIB code was always designed to be a suggestion to the driver
+ * for how to "respond" to traffic and interrupts, so this driver uses a
+ * slightly different set of moderation parameters to get best performance.
+ */
+struct ice_dim {
+	/* the throttle rate for interrupts, basically worst case delay before
+	 * an initial interrupt fires, value is stored in microseconds.
+	 */
+	u16 itr;
+	/* the rate limit for interrupts, which can cap a delay from a small
+	 * ITR at a certain amount of interrupts per second. f.e. a 2us ITR
+	 * could yield as much as 500,000 interrupts per second, but with a
+	 * 10us rate limit, it limits to 100,000 interrupts per second. Value
+	 * is stored in microseconds.
+	 */
+	u16 intrl;
+};
+
+/* Make a different profile for Rx that doesn't allow quite so aggressive
+ * moderation at the high end (it maxes out at 128us or about 8k interrupts a
+ * second. The INTRL/rate parameters here are only useful to cap small ITR
+ * values, which is why for larger ITR's - like 128, which can only generate
+ * 8k interrupts per second, there is no point to rate limit and the values
+ * are set to zero. The rate limit values do affect latency, and so must
+ * be reasonably small so to not impact latency sensitive tests.
+ */
+static const struct ice_dim rx_profile[] = {
+	{2, 10},
+	{8, 16},
+	{32, 0},
+	{96, 0},
+	{128, 0}
+};
+
+/* The transmit profile, which has the same sorts of values
+ * as the previous struct
+ */
+static const struct ice_dim tx_profile[] = {
+	{2, 10},
+	{8, 16},
+	{64, 0},
+	{128, 0},
+	{256, 0}
+};
+
+static void ice_tx_dim_work(struct work_struct *work)
+{
+	struct ice_ring_container *rc;
+	struct ice_q_vector *q_vector;
+	struct dim *dim;
+	u16 itr, intrl;
+
+	dim = container_of(work, struct dim, work);
+	rc = container_of(dim, struct ice_ring_container, dim);
+	q_vector = container_of(rc, struct ice_q_vector, tx);
+
+	if (dim->profile_ix >= ARRAY_SIZE(tx_profile))
+		dim->profile_ix = ARRAY_SIZE(tx_profile) - 1;
+
+	/* look up the values in our local table */
+	itr = tx_profile[dim->profile_ix].itr;
+	intrl = tx_profile[dim->profile_ix].intrl;
+
+	ice_write_itr(rc, itr);
+	ice_write_intrl(q_vector, intrl);
+
+	dim->state = DIM_START_MEASURE;
+}
+
+static void ice_rx_dim_work(struct work_struct *work)
+{
+	struct ice_ring_container *rc;
+	struct ice_q_vector *q_vector;
+	struct dim *dim;
+	u16 itr, intrl;
+
+	dim = container_of(work, struct dim, work);
+	rc = container_of(dim, struct ice_ring_container, dim);
+	q_vector = container_of(rc, struct ice_q_vector, rx);
+
+	if (dim->profile_ix >= ARRAY_SIZE(rx_profile))
+		dim->profile_ix = ARRAY_SIZE(rx_profile) - 1;
+
+	/* look up the values in our local table */
+	itr = rx_profile[dim->profile_ix].itr;
+	intrl = rx_profile[dim->profile_ix].intrl;
+
+	ice_write_itr(rc, itr);
+	ice_write_intrl(q_vector, intrl);
+
+	dim->state = DIM_START_MEASURE;
+}
+
 /**
  * ice_napi_enable_all - Enable NAPI for all q_vectors in the VSI
  * @vsi: the VSI being configured
@@ -5210,6 +5309,12 @@ static void ice_napi_enable_all(struct ice_vsi *vsi)
 	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
+		INIT_WORK(&q_vector->tx.dim.work, ice_tx_dim_work);
+		q_vector->tx.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+
+		INIT_WORK(&q_vector->rx.dim.work, ice_rx_dim_work);
+		q_vector->rx.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+
 		if (q_vector->rx.ring || q_vector->tx.ring)
 			napi_enable(&q_vector->napi);
 	}
@@ -5618,6 +5723,9 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 
 		if (q_vector->rx.ring || q_vector->tx.ring)
 			napi_disable(&q_vector->napi);
+
+		cancel_work_sync(&q_vector->tx.dim.work);
+		cancel_work_sync(&q_vector->rx.dim.work);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dfdf2c1fa9d3..97c3efb932dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1223,216 +1223,50 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 }
 
 /**
- * ice_adjust_itr_by_size_and_speed - Adjust ITR based on current traffic
- * @port_info: port_info structure containing the current link speed
- * @avg_pkt_size: average size of Tx or Rx packets based on clean routine
- * @itr: ITR value to update
+ * ice_net_dim - Update net DIM algorithm
+ * @q_vector: the vector associated with the interrupt
  *
- * Calculate how big of an increment should be applied to the ITR value passed
- * in based on wmem_default, SKB overhead, ethernet overhead, and the current
- * link speed.
+ * Create a DIM sample and notify net_dim() so that it can possibly decide
+ * a new ITR value based on incoming packets, bytes, and interrupts.
  *
- * The following is a calculation derived from:
- *  wmem_default / (size + overhead) = desired_pkts_per_int
- *  rate / bits_per_byte / (size + ethernet overhead) = pkt_rate
- *  (desired_pkt_rate / pkt_rate) * usecs_per_sec = ITR value
- *
- * Assuming wmem_default is 212992 and overhead is 640 bytes per
- * packet, (256 skb, 64 headroom, 320 shared info), we can reduce the
- * formula down to:
- *
- *	 wmem_default * bits_per_byte * usecs_per_sec   pkt_size + 24
- * ITR = -------------------------------------------- * --------------
- *			     rate			pkt_size + 640
+ * This function is a no-op if the ring is not configured to dynamic ITR.
  */
-static unsigned int
-ice_adjust_itr_by_size_and_speed(struct ice_port_info *port_info,
-				 unsigned int avg_pkt_size,
-				 unsigned int itr)
+static void ice_net_dim(struct ice_q_vector *q_vector)
 {
-	switch (port_info->phy.link_info.link_speed) {
-	case ICE_AQ_LINK_SPEED_100GB:
-		itr += DIV_ROUND_UP(17 * (avg_pkt_size + 24),
-				    avg_pkt_size + 640);
-		break;
-	case ICE_AQ_LINK_SPEED_50GB:
-		itr += DIV_ROUND_UP(34 * (avg_pkt_size + 24),
-				    avg_pkt_size + 640);
-		break;
-	case ICE_AQ_LINK_SPEED_40GB:
-		itr += DIV_ROUND_UP(43 * (avg_pkt_size + 24),
-				    avg_pkt_size + 640);
-		break;
-	case ICE_AQ_LINK_SPEED_25GB:
-		itr += DIV_ROUND_UP(68 * (avg_pkt_size + 24),
-				    avg_pkt_size + 640);
-		break;
-	case ICE_AQ_LINK_SPEED_20GB:
-		itr += DIV_ROUND_UP(85 * (avg_pkt_size + 24),
-				    avg_pkt_size + 640);
-		break;
-	case ICE_AQ_LINK_SPEED_10GB:
-	default:
-		itr += DIV_ROUND_UP(170 * (avg_pkt_size + 24),
-				    avg_pkt_size + 640);
-		break;
-	}
-
-	if ((itr & ICE_ITR_MASK) > ICE_ITR_ADAPTIVE_MAX_USECS) {
-		itr &= ICE_ITR_ADAPTIVE_LATENCY;
-		itr += ICE_ITR_ADAPTIVE_MAX_USECS;
-	}
+	struct ice_ring_container *tx = &q_vector->tx;
+	struct ice_ring_container *rx = &q_vector->rx;
 
-	return itr;
-}
+	if (ITR_IS_DYNAMIC(tx->itr_setting)) {
+		struct dim_sample dim_sample = {};
+		u64 packets = 0, bytes = 0;
+		struct ice_ring *ring;
 
-/**
- * ice_update_itr - update the adaptive ITR value based on statistics
- * @q_vector: structure containing interrupt and ring information
- * @rc: structure containing ring performance data
- *
- * Stores a new ITR value based on packets and byte
- * counts during the last interrupt.  The advantage of per interrupt
- * computation is faster updates and more accurate ITR for the current
- * traffic pattern.  Constants in this function were computed
- * based on theoretical maximum wire speed and thresholds were set based
- * on testing data as well as attempting to minimize response time
- * while increasing bulk throughput.
- */
-static void
-ice_update_itr(struct ice_q_vector *q_vector, struct ice_ring_container *rc)
-{
-	unsigned long next_update = jiffies;
-	unsigned int packets, bytes, itr;
-	bool container_is_rx;
+		ice_for_each_ring(ring, q_vector->tx) {
+			packets += ring->stats.pkts;
+			bytes += ring->stats.bytes;
+		}
 
-	if (!rc->ring || !ITR_IS_DYNAMIC(rc->itr_setting))
-		return;
+		dim_update_sample(q_vector->total_events, packets, bytes,
+				  &dim_sample);
 
-	/* If itr_countdown is set it means we programmed an ITR within
-	 * the last 4 interrupt cycles. This has a side effect of us
-	 * potentially firing an early interrupt. In order to work around
-	 * this we need to throw out any data received for a few
-	 * interrupts following the update.
-	 */
-	if (q_vector->itr_countdown) {
-		itr = rc->target_itr;
-		goto clear_counts;
+		net_dim(&tx->dim, dim_sample);
 	}
 
-	container_is_rx = (&q_vector->rx == rc);
-	/* For Rx we want to push the delay up and default to low latency.
-	 * for Tx we want to pull the delay down and default to high latency.
-	 */
-	itr = container_is_rx ?
-		ICE_ITR_ADAPTIVE_MIN_USECS | ICE_ITR_ADAPTIVE_LATENCY :
-		ICE_ITR_ADAPTIVE_MAX_USECS | ICE_ITR_ADAPTIVE_LATENCY;
-
-	/* If we didn't update within up to 1 - 2 jiffies we can assume
-	 * that either packets are coming in so slow there hasn't been
-	 * any work, or that there is so much work that NAPI is dealing
-	 * with interrupt moderation and we don't need to do anything.
-	 */
-	if (time_after(next_update, rc->next_update))
-		goto clear_counts;
-
-	prefetch(q_vector->vsi->port_info);
-
-	packets = rc->total_pkts;
-	bytes = rc->total_bytes;
-
-	if (container_is_rx) {
-		/* If Rx there are 1 to 4 packets and bytes are less than
-		 * 9000 assume insufficient data to use bulk rate limiting
-		 * approach unless Tx is already in bulk rate limiting. We
-		 * are likely latency driven.
-		 */
-		if (packets && packets < 4 && bytes < 9000 &&
-		    (q_vector->tx.target_itr & ICE_ITR_ADAPTIVE_LATENCY)) {
-			itr = ICE_ITR_ADAPTIVE_LATENCY;
-			goto adjust_by_size_and_speed;
-		}
-	} else if (packets < 4) {
-		/* If we have Tx and Rx ITR maxed and Tx ITR is running in
-		 * bulk mode and we are receiving 4 or fewer packets just
-		 * reset the ITR_ADAPTIVE_LATENCY bit for latency mode so
-		 * that the Rx can relax.
-		 */
-		if (rc->target_itr == ICE_ITR_ADAPTIVE_MAX_USECS &&
-		    (q_vector->rx.target_itr & ICE_ITR_MASK) ==
-		    ICE_ITR_ADAPTIVE_MAX_USECS)
-			goto clear_counts;
-	} else if (packets > 32) {
-		/* If we have processed over 32 packets in a single interrupt
-		 * for Tx assume we need to switch over to "bulk" mode.
-		 */
-		rc->target_itr &= ~ICE_ITR_ADAPTIVE_LATENCY;
-	}
+	if (ITR_IS_DYNAMIC(rx->itr_setting)) {
+		struct dim_sample dim_sample = {};
+		u64 packets = 0, bytes = 0;
+		struct ice_ring *ring;
 
-	/* We have no packets to actually measure against. This means
-	 * either one of the other queues on this vector is active or
-	 * we are a Tx queue doing TSO with too high of an interrupt rate.
-	 *
-	 * Between 4 and 56 we can assume that our current interrupt delay
-	 * is only slightly too low. As such we should increase it by a small
-	 * fixed amount.
-	 */
-	if (packets < 56) {
-		itr = rc->target_itr + ICE_ITR_ADAPTIVE_MIN_INC;
-		if ((itr & ICE_ITR_MASK) > ICE_ITR_ADAPTIVE_MAX_USECS) {
-			itr &= ICE_ITR_ADAPTIVE_LATENCY;
-			itr += ICE_ITR_ADAPTIVE_MAX_USECS;
+		ice_for_each_ring(ring, q_vector->rx) {
+			packets += ring->stats.pkts;
+			bytes += ring->stats.bytes;
 		}
-		goto clear_counts;
-	}
-
-	if (packets <= 256) {
-		itr = min(q_vector->tx.current_itr, q_vector->rx.current_itr);
-		itr &= ICE_ITR_MASK;
-
-		/* Between 56 and 112 is our "goldilocks" zone where we are
-		 * working out "just right". Just report that our current
-		 * ITR is good for us.
-		 */
-		if (packets <= 112)
-			goto clear_counts;
 
-		/* If packet count is 128 or greater we are likely looking
-		 * at a slight overrun of the delay we want. Try halving
-		 * our delay to see if that will cut the number of packets
-		 * in half per interrupt.
-		 */
-		itr >>= 1;
-		itr &= ICE_ITR_MASK;
-		if (itr < ICE_ITR_ADAPTIVE_MIN_USECS)
-			itr = ICE_ITR_ADAPTIVE_MIN_USECS;
+		dim_update_sample(q_vector->total_events, packets, bytes,
+				  &dim_sample);
 
-		goto clear_counts;
+		net_dim(&rx->dim, dim_sample);
 	}
-
-	/* The paths below assume we are dealing with a bulk ITR since
-	 * number of packets is greater than 256. We are just going to have
-	 * to compute a value and try to bring the count under control,
-	 * though for smaller packet sizes there isn't much we can do as
-	 * NAPI polling will likely be kicking in sooner rather than later.
-	 */
-	itr = ICE_ITR_ADAPTIVE_BULK;
-
-adjust_by_size_and_speed:
-
-	/* based on checks above packets cannot be 0 so division is safe */
-	itr = ice_adjust_itr_by_size_and_speed(q_vector->vsi->port_info,
-					       bytes / packets, itr);
-
-clear_counts:
-	/* write back value */
-	rc->target_itr = itr;
-
-	/* next update should occur within next jiffy */
-	rc->next_update = next_update + 1;
-
-	rc->total_bytes = 0;
-	rc->total_pkts = 0;
 }
 
 /**
@@ -1456,72 +1290,35 @@ static u32 ice_buildreg_itr(u16 itr_idx, u16 itr)
 		(itr << (GLINT_DYN_CTL_INTERVAL_S - ICE_ITR_GRAN_S));
 }
 
-/* The act of updating the ITR will cause it to immediately trigger. In order
- * to prevent this from throwing off adaptive update statistics we defer the
- * update so that it can only happen so often. So after either Tx or Rx are
- * updated we make the adaptive scheme wait until either the ITR completely
- * expires via the next_update expiration or we have been through at least
- * 3 interrupts.
- */
-#define ITR_COUNTDOWN_START 3
-
 /**
- * ice_update_ena_itr - Update ITR and re-enable MSIX interrupt
- * @q_vector: q_vector for which ITR is being updated and interrupt enabled
+ * ice_update_ena_itr - Update ITR moderation and re-enable MSI-X interrupt
+ * @q_vector: the vector associated with the interrupt to enable
+ *
+ * Update the net_dim() algorithm and re-enable the interrupt associated with
+ * this vector.
+ *
+ * If the VSI is down, the interrupt will not be re-enabled.
  */
 static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 {
-	struct ice_ring_container *tx = &q_vector->tx;
-	struct ice_ring_container *rx = &q_vector->rx;
 	struct ice_vsi *vsi = q_vector->vsi;
 	u32 itr_val;
 
-	/* when exiting WB_ON_ITR just reset the countdown and let ITR
-	 * resume it's normal "interrupts-enabled" path
-	 */
-	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE)
-		q_vector->itr_countdown = 0;
-
-	/* This will do nothing if dynamic updates are not enabled */
-	ice_update_itr(q_vector, tx);
-	ice_update_itr(q_vector, rx);
+	if (test_bit(ICE_DOWN, vsi->state))
+		return;
 
-	/* This block of logic allows us to get away with only updating
-	 * one ITR value with each interrupt. The idea is to perform a
-	 * pseudo-lazy update with the following criteria.
-	 *
-	 * 1. Rx is given higher priority than Tx if both are in same state
-	 * 2. If we must reduce an ITR that is given highest priority.
-	 * 3. We then give priority to increasing ITR based on amount.
+	/* When exiting WB_ON_ITR, let ITR resume its normal
+	 * interrupts-enabled path.
 	 */
-	if (rx->target_itr < rx->current_itr) {
-		/* Rx ITR needs to be reduced, this is highest priority */
-		itr_val = ice_buildreg_itr(rx->itr_idx, rx->target_itr);
-		rx->current_itr = rx->target_itr;
-		q_vector->itr_countdown = ITR_COUNTDOWN_START;
-	} else if ((tx->target_itr < tx->current_itr) ||
-		   ((rx->target_itr - rx->current_itr) <
-		    (tx->target_itr - tx->current_itr))) {
-		/* Tx ITR needs to be reduced, this is second priority
-		 * Tx ITR needs to be increased more than Rx, fourth priority
-		 */
-		itr_val = ice_buildreg_itr(tx->itr_idx, tx->target_itr);
-		tx->current_itr = tx->target_itr;
-		q_vector->itr_countdown = ITR_COUNTDOWN_START;
-	} else if (rx->current_itr != rx->target_itr) {
-		/* Rx ITR needs to be increased, third priority */
-		itr_val = ice_buildreg_itr(rx->itr_idx, rx->target_itr);
-		rx->current_itr = rx->target_itr;
-		q_vector->itr_countdown = ITR_COUNTDOWN_START;
-	} else {
-		/* Still have to re-enable the interrupts */
-		itr_val = ice_buildreg_itr(ICE_ITR_NONE, 0);
-		if (q_vector->itr_countdown)
-			q_vector->itr_countdown--;
-	}
+	if (q_vector->wb_on_itr)
+		q_vector->wb_on_itr = false;
+
+	/* This will do nothing if dynamic updates are not enabled. */
+	ice_net_dim(q_vector);
 
-	if (!test_bit(ICE_VSI_DOWN, vsi->state))
-		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
+	/* net_dim() updates ITR out-of-band using a work item */
+	itr_val = ice_buildreg_itr(ICE_ITR_NONE, 0);
+	wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
 }
 
 /**
@@ -1543,7 +1340,7 @@ static void ice_set_wb_on_itr(struct ice_q_vector *q_vector)
 	struct ice_vsi *vsi = q_vector->vsi;
 
 	/* already in wb_on_itr mode no need to change it */
-	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE)
+	if (q_vector->wb_on_itr)
 		return;
 
 	/* use previously set ITR values for all of the ITR indices by
@@ -1555,7 +1352,7 @@ static void ice_set_wb_on_itr(struct ice_q_vector *q_vector)
 	      GLINT_DYN_CTL_ITR_INDX_M) | GLINT_DYN_CTL_INTENA_MSK_M |
 	     GLINT_DYN_CTL_WB_ON_ITR_M);
 
-	q_vector->itr_countdown = ICE_IN_WB_ON_ITR_MODE;
+	q_vector->wb_on_itr = true;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 701552d88bea..ae12b4e6453b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -339,12 +339,8 @@ static inline bool ice_ring_is_xdp(struct ice_ring *ring)
 struct ice_ring_container {
 	/* head of linked-list of rings */
 	struct ice_ring *ring;
-	unsigned long next_update;	/* jiffies value of next queue update */
-	unsigned int total_bytes;	/* total bytes processed this int */
-	unsigned int total_pkts;	/* total packets processed this int */
+	struct dim dim;		/* data for net_dim algorithm */
 	u16 itr_idx;		/* index in the interrupt vector */
-	u16 target_itr;		/* value in usecs divided by the hw->itr_gran */
-	u16 current_itr;	/* value in usecs divided by the hw->itr_gran */
 	/* high bit set means dynamic ITR, rest is used to store user
 	 * readable ITR value in usecs and must be converted before programming
 	 * to a register.
-- 
2.26.2

