Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB37B3A4653
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFKQTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:16322 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFKQTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:37 -0400
IronPort-SDR: W8FPt9a+HjGE8ihBxwY8iRqpvh/+YUoCPjhZvT1BLy18D31Z35X6bZJE6uL2/MwuGWQx3ToVXM
 7/L3lSv/jx1w==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404877"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404877"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:27 -0700
IronPort-SDR: 5+GlQBE6Q79xkY5CYXTDDgB3zsTwFkYFwLei/mNlcvO+8VPAgEThM2qa4XuHb0AvOeQUjlH3GW
 w17y6XJ8Fbtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423495"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 8/8] ice: enable transmit timestamps for E810 devices
Date:   Fri, 11 Jun 2021 09:20:00 -0700
Message-Id: <20210611162000.2438023-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add support for enabling Tx timestamp requests for outgoing packets on
E810 devices.

The ice hardware can support multiple outstanding Tx timestamp requests.
When sending a descriptor to hardware, a Tx timestamp request is made by
setting a request bit, and assigning an index that represents which Tx
timestamp index to store the timestamp in.

Hardware makes no effort to synchronize the index use, so it is up to
software to ensure that Tx timestamp indexes are not re-used before the
timestamp is reported back.

To do this, introduce a Tx timestamp tracker which will keep track of
currently in-use indexes.

In the hot path, if a packet has a timestamp request, an index will be
requested from the tracker. Unfortunately, this does require a lock as
the indexes are shared across all queues on a PHY. There are not enough
indexes to reliably assign only 1 to each queue.

For the E810 devices, the timestamp indexes are not shared across PHYs,
so each port can have its own tracking.

Once hardware captures a timestamp, an interrupt is fired. In this
interrupt, trigger a new work item that will figure out which timestamp
was completed, and report the timestamp back to the stack.

This function loops through the Tx timestamp indexes and checks whether
there is now a valid timestamp. If so, it clears the PHY timestamp
indication in the PHY memory, locks and removes the SKB and bit in the
tracker, then reports the timestamp to the stack.

It is possible in some cases that a timestamp request will be initiated
but never completed. This might occur if the packet is dropped by
software or hardware before it reaches the PHY.

Add a task to the periodic work function that will check whether
a timestamp request is more than a few seconds old. If so, the timestamp
index is cleared in the PHY, and the SKB is released.

Just as with Rx timestamps, the Tx timestamps are only 40 bits wide, and
use the same overall logic for extending to 64 bits of nanoseconds.

With this change, E810 devices should be able to perform basic PTP
functionality.

Future changes will extend the support to cover the E822-based devices.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c     |   9 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   6 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   5 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 369 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  91 +++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  37 ++
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +
 9 files changed, 518 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 0b44baf0dcff..c36057efc7ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -287,6 +287,15 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 	/* make sure the context is associated with the right VSI */
 	tlan_ctx->src_vsi = ice_get_hw_vsi_num(hw, vsi->idx);
 
+	/* Restrict Tx timestamps to the PF VSI */
+	switch (vsi->type) {
+	case ICE_VSI_PF:
+		tlan_ctx->tsyn_ena = 1;
+		break;
+	default:
+		break;
+	}
+
 	tlan_ctx->tso_ena = ICE_TX_LEGACY;
 	tlan_ctx->tso_qnum = pf_q;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 38d784742bf3..d95a5daca114 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3204,14 +3204,16 @@ ice_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return ethtool_op_get_ts_info(dev, info);
 
-	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
 
 	info->phc_index = ice_get_ptp_clock_index(pf);
 
-	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON);
 
 	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index f6f5ced50be2..6989a76c42a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -202,6 +202,7 @@
 #define PFINT_MBX_CTL_ITR_INDX_M		ICE_M(0x3, 11)
 #define PFINT_MBX_CTL_CAUSE_ENA_M		BIT(30)
 #define PFINT_OICR				0x0016CA00
+#define PFINT_OICR_TSYN_TX_M			BIT(11)
 #define PFINT_OICR_ECC_ERR_M			BIT(16)
 #define PFINT_OICR_MAL_DETECT_M			BIT(19)
 #define PFINT_OICR_GRST_M			BIT(20)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7bb10fa032e1..a46aba5e9c12 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1298,6 +1298,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->reg_idx = vsi->txq_map[i];
 		ring->ring_active = false;
 		ring->vsi = vsi;
+		ring->tx_tstamps = &pf->ptp.port.tx;
 		ring->dev = dev;
 		ring->count = vsi->num_tx_desc;
 		WRITE_ONCE(vsi->tx_rings[i], ring);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 082e704472be..96276533822e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2792,6 +2792,11 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		}
 	}
 
+	if (oicr & PFINT_OICR_TSYN_TX_M) {
+		ena_mask &= ~PFINT_OICR_TSYN_TX_M;
+		ice_ptp_process_ts(pf);
+	}
+
 #define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
 	if (oicr & ICE_AUX_CRIT_ERR) {
 		struct iidc_event *event;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index b22b7a93f6ca..e14f81321768 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -4,6 +4,37 @@
 #include "ice.h"
 #include "ice_lib.h"
 
+/**
+ * ice_set_tx_tstamp - Enable or disable Tx timestamping
+ * @pf: The PF pointer to search in
+ * @on: bool value for whether timestamps are enabled or disabled
+ */
+static void ice_set_tx_tstamp(struct ice_pf *pf, bool on)
+{
+	struct ice_vsi *vsi;
+	u32 val;
+	u16 i;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
+		return;
+
+	/* Set the timestamp enable flag for all the Tx rings */
+	ice_for_each_rxq(vsi, i) {
+		if (!vsi->tx_rings[i])
+			continue;
+		vsi->tx_rings[i]->ptp_tx = on;
+	}
+
+	/* Configure the Tx timestamp interrupt */
+	val = rd32(&pf->hw, PFINT_OICR_ENA);
+	if (on)
+		val |= PFINT_OICR_TSYN_TX_M;
+	else
+		val &= ~PFINT_OICR_TSYN_TX_M;
+	wr32(&pf->hw, PFINT_OICR_ENA, val);
+}
+
 /**
  * ice_set_rx_tstamp - Enable or disable Rx timestamping
  * @pf: The PF pointer to search in
@@ -36,12 +67,16 @@ static void ice_set_rx_tstamp(struct ice_pf *pf, bool on)
  */
 static void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena)
 {
+	ice_set_tx_tstamp(pf, ena);
 	ice_set_rx_tstamp(pf, ena);
 
-	if (ena)
+	if (ena) {
 		pf->ptp.tstamp_config.rx_filter = HWTSTAMP_FILTER_ALL;
-	else
+		pf->ptp.tstamp_config.tx_type = HWTSTAMP_TX_ON;
+	} else {
 		pf->ptp.tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
+		pf->ptp.tstamp_config.tx_type = HWTSTAMP_TX_OFF;
+	}
 }
 
 /**
@@ -318,6 +353,40 @@ static u64 ice_ptp_extend_32b_ts(u64 cached_phc_time, u32 in_tstamp)
 	return ns;
 }
 
+/**
+ * ice_ptp_extend_40b_ts - Convert a 40b timestamp to 64b nanoseconds
+ * @pf: Board private structure
+ * @in_tstamp: Ingress/egress 40b timestamp value
+ *
+ * The Tx and Rx timestamps are 40 bits wide, including 32 bits of nominal
+ * nanoseconds, 7 bits of sub-nanoseconds, and a valid bit.
+ *
+ *  *--------------------------------------------------------------*
+ *  | 32 bits of nanoseconds | 7 high bits of sub ns underflow | v |
+ *  *--------------------------------------------------------------*
+ *
+ * The low bit is an indicator of whether the timestamp is valid. The next
+ * 7 bits are a capture of the upper 7 bits of the sub-nanosecond underflow,
+ * and the remaining 32 bits are the lower 32 bits of the PHC timer.
+ *
+ * It is assumed that the caller verifies the timestamp is valid prior to
+ * calling this function.
+ *
+ * Extract the 32bit nominal nanoseconds and extend them. Use the cached PHC
+ * time stored in the device private PTP structure as the basis for timestamp
+ * extension.
+ *
+ * See ice_ptp_extend_32b_ts for a detailed explanation of the extension
+ * algorithm.
+ */
+static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
+{
+	const u64 mask = GENMASK_ULL(31, 0);
+
+	return ice_ptp_extend_32b_ts(pf->ptp.cached_phc_time,
+				     (in_tstamp >> 8) & mask);
+}
+
 /**
  * ice_ptp_read_time - Read the time from the device
  * @pf: Board private structure
@@ -574,6 +643,10 @@ ice_ptp_set_timestamp_mode(struct ice_pf *pf, struct hwtstamp_config *config)
 
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
+		ice_set_tx_tstamp(pf, false);
+		break;
+	case HWTSTAMP_TX_ON:
+		ice_set_tx_tstamp(pf, true);
 		break;
 	default:
 		return -ERANGE;
@@ -724,6 +797,291 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_ptp_tx_tstamp_work - Process Tx timestamps for a port
+ * @work: pointer to the kthread_work struct
+ *
+ * Process timestamps captured by the PHY associated with this port. To do
+ * this, loop over each index with a waiting skb.
+ *
+ * If a given index has a valid timestamp, perform the following steps:
+ *
+ * 1) copy the timestamp out of the PHY register
+ * 4) clear the timestamp valid bit in the PHY register
+ * 5) unlock the index by clearing the associated in_use bit.
+ * 2) extend the 40b timestamp value to get a 64bit timestamp
+ * 3) send that timestamp to the stack
+ *
+ * After looping, if we still have waiting SKBs, then re-queue the work. This
+ * may cause us effectively poll even when not strictly necessary. We do this
+ * because it's possible a new timestamp was requested around the same time as
+ * the interrupt. In some cases hardware might not interrupt us again when the
+ * timestamp is captured.
+ *
+ * Note that we only take the tracking lock when clearing the bit and when
+ * checking if we need to re-queue this task. The only place where bits can be
+ * set is the hard xmit routine where an SKB has a request flag set. The only
+ * places where we clear bits are this work function, or the periodic cleanup
+ * thread. If the cleanup thread clears a bit we're processing we catch it
+ * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
+ * starts a new timestamp, we might not begin processing it right away but we
+ * will notice it at the end when we re-queue the work item. If a Tx thread
+ * starts a new timestamp just after this function exits without re-queuing,
+ * the interrupt when the timestamp finishes should trigger. Avoiding holding
+ * the lock for the entire function is important in order to ensure that Tx
+ * threads do not get blocked while waiting for the lock.
+ */
+static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
+{
+	struct ice_ptp_port *ptp_port;
+	struct ice_ptp_tx *tx;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	u8 idx;
+
+	tx = container_of(work, struct ice_ptp_tx, work);
+	if (!tx->init)
+		return;
+
+	ptp_port = container_of(tx, struct ice_ptp_port, tx);
+	pf = ptp_port_to_pf(ptp_port);
+	hw = &pf->hw;
+
+	for_each_set_bit(idx, tx->in_use, tx->len) {
+		struct skb_shared_hwtstamps shhwtstamps = {};
+		u8 phy_idx = idx + tx->quad_offset;
+		u64 raw_tstamp, tstamp;
+		struct sk_buff *skb;
+		int err;
+
+		err = ice_read_phy_tstamp(hw, tx->quad, phy_idx,
+					  &raw_tstamp);
+		if (err)
+			continue;
+
+		/* Check if the timestamp is valid */
+		if (!(raw_tstamp & ICE_PTP_TS_VALID))
+			continue;
+
+		/* clear the timestamp register, so that it won't show valid
+		 * again when re-used.
+		 */
+		ice_clear_phy_tstamp(hw, tx->quad, phy_idx);
+
+		/* The timestamp is valid, so we'll go ahead and clear this
+		 * index and then send the timestamp up to the stack.
+		 */
+		spin_lock(&tx->lock);
+		clear_bit(idx, tx->in_use);
+		skb = tx->tstamps[idx].skb;
+		tx->tstamps[idx].skb = NULL;
+		spin_unlock(&tx->lock);
+
+		/* it's (unlikely but) possible we raced with the cleanup
+		 * thread for discarding old timestamp requests.
+		 */
+		if (!skb)
+			continue;
+
+		/* Extend the timestamp using cached PHC time */
+		tstamp = ice_ptp_extend_40b_ts(pf, raw_tstamp);
+		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
+
+		skb_tstamp_tx(skb, &shhwtstamps);
+		dev_kfree_skb_any(skb);
+	}
+
+	/* Check if we still have work to do. If so, re-queue this task to
+	 * poll for remaining timestamps.
+	 */
+	spin_lock(&tx->lock);
+	if (!bitmap_empty(tx->in_use, tx->len))
+		kthread_queue_work(pf->ptp.kworker, &tx->work);
+	spin_unlock(&tx->lock);
+}
+
+/**
+ * ice_ptp_request_ts - Request an available Tx timestamp index
+ * @tx: the PTP Tx timestamp tracker to request from
+ * @skb: the SKB to associate with this timestamp request
+ */
+s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
+{
+	u8 idx;
+
+	/* Check if this tracker is initialized */
+	if (!tx->init)
+		return -1;
+
+	spin_lock(&tx->lock);
+	/* Find and set the first available index */
+	idx = find_first_zero_bit(tx->in_use, tx->len);
+	if (idx < tx->len) {
+		/* We got a valid index that no other thread could have set. Store
+		 * a reference to the skb and the start time to allow discarding old
+		 * requests.
+		 */
+		set_bit(idx, tx->in_use);
+		tx->tstamps[idx].start = jiffies;
+		tx->tstamps[idx].skb = skb_get(skb);
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+	}
+
+	spin_unlock(&tx->lock);
+
+	/* return the appropriate PHY timestamp register index, -1 if no
+	 * indexes were available.
+	 */
+	if (idx >= tx->len)
+		return -1;
+	else
+		return idx + tx->quad_offset;
+}
+
+/**
+ * ice_ptp_process_ts - Spawn kthread work to handle timestamps
+ * @pf: Board private structure
+ *
+ * Queue work required to process the PTP Tx timestamps outside of interrupt
+ * context.
+ */
+void ice_ptp_process_ts(struct ice_pf *pf)
+{
+	if (pf->ptp.port.tx.init)
+		kthread_queue_work(pf->ptp.kworker, &pf->ptp.port.tx.work);
+}
+
+/**
+ * ice_ptp_alloc_tx_tracker - Initialize tracking for Tx timestamps
+ * @tx: Tx tracking structure to initialize
+ *
+ * Assumes that the length has already been initialized. Do not call directly,
+ * use the ice_ptp_init_tx_e822 or ice_ptp_init_tx_e810 instead.
+ */
+static int
+ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
+{
+	tx->tstamps = kcalloc(tx->len, sizeof(*tx->tstamps), GFP_KERNEL);
+	if (!tx->tstamps)
+		return -ENOMEM;
+
+	tx->in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
+	if (!tx->in_use) {
+		kfree(tx->tstamps);
+		tx->tstamps = NULL;
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&tx->lock);
+	kthread_init_work(&tx->work, ice_ptp_tx_tstamp_work);
+
+	tx->init = 1;
+
+	return 0;
+}
+
+/**
+ * ice_ptp_flush_tx_tracker - Flush any remaining timestamps from the tracker
+ * @pf: Board private structure
+ * @tx: the tracker to flush
+ */
+static void
+ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
+{
+	u8 idx;
+
+	for (idx = 0; idx < tx->len; idx++) {
+		u8 phy_idx = idx + tx->quad_offset;
+
+		/* Clear any potential residual timestamp in the PHY block */
+		if (!pf->hw.reset_ongoing)
+			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
+
+		if (tx->tstamps[idx].skb) {
+			dev_kfree_skb_any(tx->tstamps[idx].skb);
+			tx->tstamps[idx].skb = NULL;
+		}
+	}
+}
+
+/**
+ * ice_ptp_release_tx_tracker - Release allocated memory for Tx tracker
+ * @pf: Board private structure
+ * @tx: Tx tracking structure to release
+ *
+ * Free memory associated with the Tx timestamp tracker.
+ */
+static void
+ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
+{
+	tx->init = 0;
+
+	kthread_cancel_work_sync(&tx->work);
+
+	ice_ptp_flush_tx_tracker(pf, tx);
+
+	kfree(tx->tstamps);
+	tx->tstamps = NULL;
+
+	kfree(tx->in_use);
+	tx->in_use = NULL;
+
+	tx->len = 0;
+}
+
+/**
+ * ice_ptp_init_tx_e810 - Initialize tracking for Tx timestamps
+ * @pf: Board private structure
+ * @tx: the Tx tracking structure to initialize
+ *
+ * Initialize the Tx timestamp tracker for this PF. For E810 devices, each
+ * port has its own block of timestamps, independent of the other ports.
+ */
+static int
+ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
+{
+	tx->quad = pf->hw.port_info->lport;
+	tx->quad_offset = 0;
+	tx->len = INDEX_PER_QUAD;
+
+	return ice_ptp_alloc_tx_tracker(tx);
+}
+
+/**
+ * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
+ * @tx: PTP Tx tracker to clean up
+ *
+ * Loop through the Tx timestamp requests and see if any of them have been
+ * waiting for a long time. Discard any SKBs that have been waiting for more
+ * than 2 seconds. This is long enough to be reasonably sure that the
+ * timestamp will never be captured. This might happen if the packet gets
+ * discarded before it reaches the PHY timestamping block.
+ */
+static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
+{
+	u8 idx;
+
+	if (!tx->init)
+		return;
+
+	for_each_set_bit(idx, tx->in_use, tx->len) {
+		struct sk_buff *skb;
+
+		/* Check if this SKB has been waiting for too long */
+		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
+			continue;
+
+		spin_lock(&tx->lock);
+		skb = tx->tstamps[idx].skb;
+		tx->tstamps[idx].skb = NULL;
+		clear_bit(idx, tx->in_use);
+		spin_unlock(&tx->lock);
+
+		/* Free the SKB after we've cleared the bit */
+		dev_kfree_skb_any(skb);
+	}
+}
+
 static void ice_ptp_periodic_work(struct kthread_work *work)
 {
 	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
@@ -734,6 +1092,8 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	ice_ptp_update_cached_phctime(pf);
 
+	ice_ptp_tx_tstamp_cleanup(&pf->ptp.port.tx);
+
 	/* Run twice a second */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
 				   msecs_to_jiffies(500));
@@ -842,6 +1202,9 @@ void ice_ptp_init(struct ice_pf *pf)
 	/* Disable timestamping for both Tx and Rx */
 	ice_ptp_cfg_timestamp(pf, false);
 
+	/* Initialize the PTP port Tx timestamp tracker */
+	ice_ptp_init_tx_e810(pf, &pf->ptp.port.tx);
+
 	/* Initialize work functions */
 	kthread_init_delayed_work(&pf->ptp.work, ice_ptp_periodic_work);
 
@@ -884,6 +1247,8 @@ void ice_ptp_release(struct ice_pf *pf)
 	/* Disable timestamping for both Tx and Rx */
 	ice_ptp_cfg_timestamp(pf, false);
 
+	ice_ptp_release_tx_tracker(pf, &pf->ptp.port.tx);
+
 	clear_bit(ICE_FLAG_PTP, pf->flags);
 
 	kthread_cancel_delayed_work_sync(&pf->ptp.work);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 48850391ab28..41e14f98f0e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -9,8 +9,82 @@
 
 #include "ice_ptp_hw.h"
 
+/* The ice hardware captures Tx hardware timestamps in the PHY. The timestamp
+ * is stored in a buffer of registers. Depending on the specific hardware,
+ * this buffer might be shared across multiple PHY ports.
+ *
+ * On transmit of a packet to be timestamped, software is responsible for
+ * selecting an open index. Hardware makes no attempt to lock or prevent
+ * re-use of an index for multiple packets.
+ *
+ * To handle this, timestamp indexes must be tracked by software to ensure
+ * that an index is not re-used for multiple transmitted packets. The
+ * structures and functions declared in this file track the available Tx
+ * register indexes, as well as provide storage for the SKB pointers.
+ *
+ * To allow multiple ports to access the shared register block independently,
+ * the blocks are split up so that indexes are assigned to each port based on
+ * hardware logical port number.
+ */
+
+/**
+ * struct ice_tx_tstamp - Tracking for a single Tx timestamp
+ * @skb: pointer to the SKB for this timestamp request
+ * @start: jiffies when the timestamp was first requested
+ *
+ * This structure tracks a single timestamp request. The SKB pointer is
+ * provided when initiating a request. The start time is used to ensure that
+ * we discard old requests that were not fulfilled within a 2 second time
+ * window.
+ */
+struct ice_tx_tstamp {
+	struct sk_buff *skb;
+	unsigned long start;
+};
+
+/**
+ * struct ice_ptp_tx - Tracking structure for all Tx timestamp requests on a port
+ * @work: work function to handle processing of Tx timestamps
+ * @lock: lock to prevent concurrent write to in_use bitmap
+ * @tstamps: array of len to store outstanding requests
+ * @in_use: bitmap of len to indicate which slots are in use
+ * @quad: which quad the timestamps are captured in
+ * @quad_offset: offset into timestamp block of the quad to get the real index
+ * @len: length of the tstamps and in_use fields.
+ * @init: if true, the tracker is initialized;
+ */
+struct ice_ptp_tx {
+	struct kthread_work work;
+	spinlock_t lock; /* lock protecting in_use bitmap */
+	struct ice_tx_tstamp *tstamps;
+	unsigned long *in_use;
+	u8 quad;
+	u8 quad_offset;
+	u8 len;
+	u8 init;
+};
+
+/* Quad and port information for initializing timestamp blocks */
+#define INDEX_PER_QUAD			64
+#define INDEX_PER_PORT			(INDEX_PER_QUAD / ICE_PORTS_PER_QUAD)
+
+/**
+ * struct ice_ptp_port - data used to initialize an external port for PTP
+ *
+ * This structure contains PTP data related to the external ports. Currently
+ * it is used for tracking the Tx timestamps of a port. In the future this
+ * structure will also hold information for the E822 port initialization
+ * logic.
+ *
+ * @tx: Tx timestamp tracking for this port
+ */
+struct ice_ptp_port {
+	struct ice_ptp_tx tx;
+};
+
 /**
  * struct ice_ptp - data used for integrating with CONFIG_PTP_1588_CLOCK
+ * @port: data for the PHY port initialization procedure
  * @work: delayed work function for periodic tasks
  * @cached_phc_time: a cached copy of the PHC time for timestamp extension
  * @kworker: kwork thread for handling periodic work
@@ -19,6 +93,7 @@
  * @tstamp_config: hardware timestamping configuration
  */
 struct ice_ptp {
+	struct ice_ptp_port port;
 	struct kthread_delayed_work work;
 	u64 cached_phc_time;
 	struct kthread_worker *kworker;
@@ -27,6 +102,11 @@ struct ice_ptp {
 	struct hwtstamp_config tstamp_config;
 };
 
+#define __ptp_port_to_ptp(p) \
+	container_of((p), struct ice_ptp, port)
+#define ptp_port_to_pf(p) \
+	container_of(__ptp_port_to_ptp((p)), struct ice_pf, ptp)
+
 #define __ptp_info_to_ptp(i) \
 	container_of((i), struct ice_ptp, info)
 #define ptp_info_to_pf(i) \
@@ -40,6 +120,10 @@ struct ice_pf;
 int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 int ice_get_ptp_clock_index(struct ice_pf *pf);
+
+s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
+void ice_ptp_process_ts(struct ice_pf *pf);
+
 void
 ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb);
@@ -61,6 +145,13 @@ static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
 	return -1;
 }
 
+static inline
+ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
+{
+	return -1;
+}
+
+static inline void ice_ptp_process_ts(struct ice_pf *pf) { }
 static inline void
 ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb) { }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 04748aa4c7c8..917eba7fdd0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2136,6 +2136,41 @@ static bool ice_chk_linearize(struct sk_buff *skb, unsigned int count)
 	return count != ICE_MAX_BUF_TXD;
 }
 
+/**
+ * ice_tstamp - set up context descriptor for hardware timestamp
+ * @tx_ring: pointer to the Tx ring to send buffer on
+ * @skb: pointer to the SKB we're sending
+ * @first: Tx buffer
+ * @off: Tx offload parameters
+ */
+static void
+ice_tstamp(struct ice_ring *tx_ring, struct sk_buff *skb,
+	   struct ice_tx_buf *first, struct ice_tx_offload_params *off)
+{
+	s8 idx;
+
+	/* only timestamp the outbound packet if the user has requested it */
+	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
+		return;
+
+	if (!tx_ring->ptp_tx)
+		return;
+
+	/* Tx timestamps cannot be sampled when doing TSO */
+	if (first->tx_flags & ICE_TX_FLAGS_TSO)
+		return;
+
+	/* Grab an open timestamp slot */
+	idx = ice_ptp_request_ts(tx_ring->tx_tstamps, skb);
+	if (idx < 0)
+		return;
+
+	off->cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
+			     (ICE_TX_CTX_DESC_TSYN << ICE_TXD_CTX_QW1_CMD_S) |
+			     ((u64)idx << ICE_TXD_CTX_QW1_TSO_LEN_S));
+	first->tx_flags |= ICE_TX_FLAGS_TSYN;
+}
+
 /**
  * ice_xmit_frame_ring - Sends buffer on Tx ring
  * @skb: send buffer
@@ -2205,6 +2240,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 					ICE_TX_CTX_DESC_SWTCH_UPLINK <<
 					ICE_TXD_CTX_QW1_CMD_S);
 
+	ice_tstamp(tx_ring, skb, first, &offload);
+
 	if (offload.cd_qw1 & ICE_TX_DESC_DTYPE_CTX) {
 		struct ice_tx_ctx_desc *cdesc;
 		u16 i = tx_ring->next_to_use;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 1069f3a9b6cb..1e46e80f3d6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -118,6 +118,7 @@ static inline int ice_skb_pad(void)
  * freed instead of returned like skb packets.
  */
 #define ICE_TX_FLAGS_DUMMY_PKT	BIT(3)
+#define ICE_TX_FLAGS_TSYN	BIT(4)
 #define ICE_TX_FLAGS_IPV4	BIT(5)
 #define ICE_TX_FLAGS_IPV6	BIT(6)
 #define ICE_TX_FLAGS_TUNNEL	BIT(7)
@@ -311,8 +312,10 @@ struct ice_ring {
 	u32 txq_teid;			/* Added Tx queue TEID */
 	u16 rx_buf_len;
 	u8 dcb_tc;			/* Traffic class of ring */
+	struct ice_ptp_tx *tx_tstamps;
 	u64 cached_phctime;
 	u8 ptp_rx:1;
+	u8 ptp_tx:1;
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ice_ring_uses_build_skb(struct ice_ring *ring)
-- 
2.26.2

