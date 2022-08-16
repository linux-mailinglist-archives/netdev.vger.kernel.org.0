Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318B1596109
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiHPRYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiHPRYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:24:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7074550A1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660670641; x=1692206641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vSHwx2u14k/jcmgcecSsSTaar9QIG7xFqJRT+7SQJSc=;
  b=V+Ef4VdUirT+BX/InXgFXT8ew8ft3p/G2wpolL4XV2p/kbVXvPNGz/l1
   N00vUVNaYEbdnw84zgNbjgjc7G4IoPVZknfaw9GRKqHkMSk3ZD0QCglss
   cCM2x3uve7G/URB92MEuOXTuVELMPx4Fdc6tsunqlXsYNt008N3pWh/kr
   GQXny1Oj5SdGTQtTz+0UMlWoq72Iuq7M0aOHzl8qujOYugoR+djmdhH7Q
   QJyHksxIvD3fiQjCd0Q7y8dkPVtX+KqDTBraVS4CguCb2VkrCGSVLCy7/
   Z/A5s5l9jwSdn289yePVGbX7CZplNGrSReuCNi4FvJRiQzEsaDtHHdl28
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="318281042"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="318281042"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:24:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="610340374"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2022 10:24:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/6] ice: re-arrange some static functions in ice_ptp.c
Date:   Tue, 16 Aug 2022 10:23:51 -0700
Message-Id: <20220816172352.2532304-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
References: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

A following change is going to want to make use of ice_ptp_flush_tx_tracker
earlier in the ice_ptp.c file. To make this work, move the Tx timestamp
tracking functions higher up in the file, and pull the
ice_ptp_update_cached_timestamp function below them. This should have no
functional change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 758 +++++++++++------------
 1 file changed, 379 insertions(+), 379 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 10352eca2ecd..f125b8135348 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -490,69 +490,6 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
 	return ((u64)hi << 32) | lo;
 }
 
-/**
- * ice_ptp_update_cached_phctime - Update the cached PHC time values
- * @pf: Board specific private structure
- *
- * This function updates the system time values which are cached in the PF
- * structure and the Rx rings.
- *
- * This function must be called periodically to ensure that the cached value
- * is never more than 2 seconds old. It must also be called whenever the PHC
- * time has been changed.
- *
- * Return:
- * * 0 - OK, successfully updated
- * * -EAGAIN - PF was busy, need to reschedule the update
- */
-static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
-{
-	struct device *dev = ice_pf_to_dev(pf);
-	unsigned long update_before;
-	u64 systime;
-	int i;
-
-	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
-		return -EAGAIN;
-
-	update_before = pf->ptp.cached_phc_jiffies + msecs_to_jiffies(2000);
-	if (pf->ptp.cached_phc_time &&
-	    time_is_before_jiffies(update_before)) {
-		unsigned long time_taken = jiffies - pf->ptp.cached_phc_jiffies;
-
-		dev_warn(dev, "%u msecs passed between update to cached PHC time\n",
-			 jiffies_to_msecs(time_taken));
-		pf->ptp.late_cached_phc_updates++;
-	}
-
-	/* Read the current PHC time */
-	systime = ice_ptp_read_src_clk_reg(pf, NULL);
-
-	/* Update the cached PHC time stored in the PF structure */
-	WRITE_ONCE(pf->ptp.cached_phc_time, systime);
-	WRITE_ONCE(pf->ptp.cached_phc_jiffies, jiffies);
-
-	ice_for_each_vsi(pf, i) {
-		struct ice_vsi *vsi = pf->vsi[i];
-		int j;
-
-		if (!vsi)
-			continue;
-
-		if (vsi->type != ICE_VSI_PF)
-			continue;
-
-		ice_for_each_rxq(vsi, j) {
-			if (!vsi->rx_rings[j])
-				continue;
-			WRITE_ONCE(vsi->rx_rings[j]->cached_phctime, systime);
-		}
-	}
-	clear_bit(ICE_CFG_BUSY, pf->state);
-
-	return 0;
-}
-
 /**
  * ice_ptp_extend_32b_ts - Convert a 32b nanoseconds timestamp to 64b
  * @cached_phc_time: recently cached copy of PHC time
@@ -663,75 +600,411 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 }
 
 /**
- * ice_ptp_read_time - Read the time from the device
- * @pf: Board private structure
- * @ts: timespec structure to hold the current time value
- * @sts: Optional parameter for holding a pair of system timestamps from
- *       the system clock. Will be ignored if NULL is given.
+ * ice_ptp_tx_tstamp_work - Process Tx timestamps for a port
+ * @work: pointer to the kthread_work struct
  *
- * This function reads the source clock registers and stores them in a timespec.
- * However, since the registers are 64 bits of nanoseconds, we must convert the
- * result to a timespec before we can return.
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
  */
-static void
-ice_ptp_read_time(struct ice_pf *pf, struct timespec64 *ts,
-		  struct ptp_system_timestamp *sts)
+static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
 {
-	u64 time_ns = ice_ptp_read_src_clk_reg(pf, sts);
+	struct ice_ptp_port *ptp_port;
+	struct ice_ptp_tx *tx;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	u8 idx;
 
-	*ts = ns_to_timespec64(time_ns);
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
+		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
+
+		err = ice_read_phy_tstamp(hw, tx->quad, phy_idx,
+					  &raw_tstamp);
+		if (err)
+			continue;
+
+		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
+
+		/* Check if the timestamp is invalid or stale */
+		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
+		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
+			continue;
+
+		/* The timestamp is valid, so we'll go ahead and clear this
+		 * index and then send the timestamp up to the stack.
+		 */
+		spin_lock(&tx->lock);
+		tx->tstamps[idx].cached_tstamp = raw_tstamp;
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
+		if (tstamp) {
+			shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
+			ice_trace(tx_tstamp_complete, skb, idx);
+		}
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
 }
 
 /**
- * ice_ptp_write_init - Set PHC time to provided value
- * @pf: Board private structure
- * @ts: timespec structure that holds the new time value
+ * ice_ptp_alloc_tx_tracker - Initialize tracking for Tx timestamps
+ * @tx: Tx tracking structure to initialize
  *
- * Set the PHC time to the specified time provided in the timespec.
+ * Assumes that the length has already been initialized. Do not call directly,
+ * use the ice_ptp_init_tx_e822 or ice_ptp_init_tx_e810 instead.
  */
-static int ice_ptp_write_init(struct ice_pf *pf, struct timespec64 *ts)
+static int
+ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 {
-	u64 ns = timespec64_to_ns(ts);
-	struct ice_hw *hw = &pf->hw;
+	tx->tstamps = kcalloc(tx->len, sizeof(*tx->tstamps), GFP_KERNEL);
+	if (!tx->tstamps)
+		return -ENOMEM;
 
-	return ice_ptp_init_time(hw, ns);
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
 }
 
 /**
- * ice_ptp_write_adj - Adjust PHC clock time atomically
+ * ice_ptp_flush_tx_tracker - Flush any remaining timestamps from the tracker
  * @pf: Board private structure
- * @adj: Adjustment in nanoseconds
- *
- * Perform an atomic adjustment of the PHC time by the specified number of
- * nanoseconds.
+ * @tx: the tracker to flush
  */
-static int ice_ptp_write_adj(struct ice_pf *pf, s32 adj)
+static void
+ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
-	struct ice_hw *hw = &pf->hw;
+	u8 idx;
 
-	return ice_ptp_adj_clock(hw, adj);
+	for (idx = 0; idx < tx->len; idx++) {
+		u8 phy_idx = idx + tx->quad_offset;
+
+		spin_lock(&tx->lock);
+		if (tx->tstamps[idx].skb) {
+			dev_kfree_skb_any(tx->tstamps[idx].skb);
+			tx->tstamps[idx].skb = NULL;
+			pf->ptp.tx_hwtstamp_flushed++;
+		}
+		clear_bit(idx, tx->in_use);
+		spin_unlock(&tx->lock);
+
+		/* Clear any potential residual timestamp in the PHY block */
+		if (!pf->hw.reset_ongoing)
+			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
+	}
 }
 
 /**
- * ice_base_incval - Get base timer increment value
+ * ice_ptp_release_tx_tracker - Release allocated memory for Tx tracker
  * @pf: Board private structure
+ * @tx: Tx tracking structure to release
  *
- * Look up the base timer increment value for this device. The base increment
- * value is used to define the nominal clock tick rate. This increment value
- * is programmed during device initialization. It is also used as the basis
- * for calculating adjustments using scaled_ppm.
+ * Free memory associated with the Tx timestamp tracker.
  */
-static u64 ice_base_incval(struct ice_pf *pf)
+static void
+ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
-	struct ice_hw *hw = &pf->hw;
-	u64 incval;
+	tx->init = 0;
 
-	if (ice_is_e810(hw))
-		incval = ICE_PTP_NOMINAL_INCVAL_E810;
-	else if (ice_e822_time_ref(hw) < NUM_ICE_TIME_REF_FREQ)
-		incval = ice_e822_nominal_incval(ice_e822_time_ref(hw));
-	else
-		incval = UNKNOWN_INCVAL_E822;
+	kthread_cancel_work_sync(&tx->work);
+
+	ice_ptp_flush_tx_tracker(pf, tx);
+
+	kfree(tx->tstamps);
+	tx->tstamps = NULL;
+
+	bitmap_free(tx->in_use);
+	tx->in_use = NULL;
+
+	tx->len = 0;
+}
+
+/**
+ * ice_ptp_init_tx_e822 - Initialize tracking for Tx timestamps
+ * @pf: Board private structure
+ * @tx: the Tx tracking structure to initialize
+ * @port: the port this structure tracks
+ *
+ * Initialize the Tx timestamp tracker for this port. For generic MAC devices,
+ * the timestamp block is shared for all ports in the same quad. To avoid
+ * ports using the same timestamp index, logically break the block of
+ * registers into chunks based on the port number.
+ */
+static int
+ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
+{
+	tx->quad = port / ICE_PORTS_PER_QUAD;
+	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
+	tx->len = INDEX_PER_PORT;
+
+	return ice_ptp_alloc_tx_tracker(tx);
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
+ * @pf: pointer to the PF struct
+ * @tx: PTP Tx tracker to clean up
+ *
+ * Loop through the Tx timestamp requests and see if any of them have been
+ * waiting for a long time. Discard any SKBs that have been waiting for more
+ * than 2 seconds. This is long enough to be reasonably sure that the
+ * timestamp will never be captured. This might happen if the packet gets
+ * discarded before it reaches the PHY timestamping block.
+ */
+static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
+{
+	struct ice_hw *hw = &pf->hw;
+	u8 idx;
+
+	if (!tx->init)
+		return;
+
+	for_each_set_bit(idx, tx->in_use, tx->len) {
+		struct sk_buff *skb;
+		u64 raw_tstamp;
+
+		/* Check if this SKB has been waiting for too long */
+		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
+			continue;
+
+		/* Read tstamp to be able to use this register again */
+		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
+				    &raw_tstamp);
+
+		spin_lock(&tx->lock);
+		skb = tx->tstamps[idx].skb;
+		tx->tstamps[idx].skb = NULL;
+		clear_bit(idx, tx->in_use);
+		spin_unlock(&tx->lock);
+
+		/* Count the number of Tx timestamps which have timed out */
+		pf->ptp.tx_hwtstamp_timeouts++;
+
+		/* Free the SKB after we've cleared the bit */
+		dev_kfree_skb_any(skb);
+	}
+}
+
+/**
+ * ice_ptp_update_cached_phctime - Update the cached PHC time values
+ * @pf: Board specific private structure
+ *
+ * This function updates the system time values which are cached in the PF
+ * structure and the Rx rings.
+ *
+ * This function must be called periodically to ensure that the cached value
+ * is never more than 2 seconds old. It must also be called whenever the PHC
+ * time has been changed.
+ *
+ * Return:
+ * * 0 - OK, successfully updated
+ * * -EAGAIN - PF was busy, need to reschedule the update
+ */
+static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	unsigned long update_before;
+	u64 systime;
+	int i;
+
+	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
+		return -EAGAIN;
+
+	update_before = pf->ptp.cached_phc_jiffies + msecs_to_jiffies(2000);
+	if (pf->ptp.cached_phc_time &&
+	    time_is_before_jiffies(update_before)) {
+		unsigned long time_taken = jiffies - pf->ptp.cached_phc_jiffies;
+
+		dev_warn(dev, "%u msecs passed between update to cached PHC time\n",
+			 jiffies_to_msecs(time_taken));
+		pf->ptp.late_cached_phc_updates++;
+	}
+
+	/* Read the current PHC time */
+	systime = ice_ptp_read_src_clk_reg(pf, NULL);
+
+	/* Update the cached PHC time stored in the PF structure */
+	WRITE_ONCE(pf->ptp.cached_phc_time, systime);
+	WRITE_ONCE(pf->ptp.cached_phc_jiffies, jiffies);
+
+	ice_for_each_vsi(pf, i) {
+		struct ice_vsi *vsi = pf->vsi[i];
+		int j;
+
+		if (!vsi)
+			continue;
+
+		if (vsi->type != ICE_VSI_PF)
+			continue;
+
+		ice_for_each_rxq(vsi, j) {
+			if (!vsi->rx_rings[j])
+				continue;
+			WRITE_ONCE(vsi->rx_rings[j]->cached_phctime, systime);
+		}
+	}
+	clear_bit(ICE_CFG_BUSY, pf->state);
+
+	return 0;
+}
+
+/**
+ * ice_ptp_read_time - Read the time from the device
+ * @pf: Board private structure
+ * @ts: timespec structure to hold the current time value
+ * @sts: Optional parameter for holding a pair of system timestamps from
+ *       the system clock. Will be ignored if NULL is given.
+ *
+ * This function reads the source clock registers and stores them in a timespec.
+ * However, since the registers are 64 bits of nanoseconds, we must convert the
+ * result to a timespec before we can return.
+ */
+static void
+ice_ptp_read_time(struct ice_pf *pf, struct timespec64 *ts,
+		  struct ptp_system_timestamp *sts)
+{
+	u64 time_ns = ice_ptp_read_src_clk_reg(pf, sts);
+
+	*ts = ns_to_timespec64(time_ns);
+}
+
+/**
+ * ice_ptp_write_init - Set PHC time to provided value
+ * @pf: Board private structure
+ * @ts: timespec structure that holds the new time value
+ *
+ * Set the PHC time to the specified time provided in the timespec.
+ */
+static int ice_ptp_write_init(struct ice_pf *pf, struct timespec64 *ts)
+{
+	u64 ns = timespec64_to_ns(ts);
+	struct ice_hw *hw = &pf->hw;
+
+	return ice_ptp_init_time(hw, ns);
+}
+
+/**
+ * ice_ptp_write_adj - Adjust PHC clock time atomically
+ * @pf: Board private structure
+ * @adj: Adjustment in nanoseconds
+ *
+ * Perform an atomic adjustment of the PHC time by the specified number of
+ * nanoseconds.
+ */
+static int ice_ptp_write_adj(struct ice_pf *pf, s32 adj)
+{
+	struct ice_hw *hw = &pf->hw;
+
+	return ice_ptp_adj_clock(hw, adj);
+}
+
+/**
+ * ice_base_incval - Get base timer increment value
+ * @pf: Board private structure
+ *
+ * Look up the base timer increment value for this device. The base increment
+ * value is used to define the nominal clock tick rate. This increment value
+ * is programmed during device initialization. It is also used as the basis
+ * for calculating adjustments using scaled_ppm.
+ */
+static u64 ice_base_incval(struct ice_pf *pf)
+{
+	struct ice_hw *hw = &pf->hw;
+	u64 incval;
+
+	if (ice_is_e810(hw))
+		incval = ICE_PTP_NOMINAL_INCVAL_E810;
+	else if (ice_e822_time_ref(hw) < NUM_ICE_TIME_REF_FREQ)
+		incval = ice_e822_nominal_incval(ice_e822_time_ref(hw));
+	else
+		incval = UNKNOWN_INCVAL_E822;
 
 	dev_dbg(ice_pf_to_dev(pf), "PTP: using base increment value of 0x%016llx\n",
 		incval);
@@ -2036,113 +2309,6 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
 	return 0;
 }
 
-/**
- * ice_ptp_tx_tstamp_work - Process Tx timestamps for a port
- * @work: pointer to the kthread_work struct
- *
- * Process timestamps captured by the PHY associated with this port. To do
- * this, loop over each index with a waiting skb.
- *
- * If a given index has a valid timestamp, perform the following steps:
- *
- * 1) copy the timestamp out of the PHY register
- * 4) clear the timestamp valid bit in the PHY register
- * 5) unlock the index by clearing the associated in_use bit.
- * 2) extend the 40b timestamp value to get a 64bit timestamp
- * 3) send that timestamp to the stack
- *
- * After looping, if we still have waiting SKBs, then re-queue the work. This
- * may cause us effectively poll even when not strictly necessary. We do this
- * because it's possible a new timestamp was requested around the same time as
- * the interrupt. In some cases hardware might not interrupt us again when the
- * timestamp is captured.
- *
- * Note that we only take the tracking lock when clearing the bit and when
- * checking if we need to re-queue this task. The only place where bits can be
- * set is the hard xmit routine where an SKB has a request flag set. The only
- * places where we clear bits are this work function, or the periodic cleanup
- * thread. If the cleanup thread clears a bit we're processing we catch it
- * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
- * starts a new timestamp, we might not begin processing it right away but we
- * will notice it at the end when we re-queue the work item. If a Tx thread
- * starts a new timestamp just after this function exits without re-queuing,
- * the interrupt when the timestamp finishes should trigger. Avoiding holding
- * the lock for the entire function is important in order to ensure that Tx
- * threads do not get blocked while waiting for the lock.
- */
-static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
-{
-	struct ice_ptp_port *ptp_port;
-	struct ice_ptp_tx *tx;
-	struct ice_pf *pf;
-	struct ice_hw *hw;
-	u8 idx;
-
-	tx = container_of(work, struct ice_ptp_tx, work);
-	if (!tx->init)
-		return;
-
-	ptp_port = container_of(tx, struct ice_ptp_port, tx);
-	pf = ptp_port_to_pf(ptp_port);
-	hw = &pf->hw;
-
-	for_each_set_bit(idx, tx->in_use, tx->len) {
-		struct skb_shared_hwtstamps shhwtstamps = {};
-		u8 phy_idx = idx + tx->quad_offset;
-		u64 raw_tstamp, tstamp;
-		struct sk_buff *skb;
-		int err;
-
-		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
-
-		err = ice_read_phy_tstamp(hw, tx->quad, phy_idx,
-					  &raw_tstamp);
-		if (err)
-			continue;
-
-		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
-
-		/* Check if the timestamp is invalid or stale */
-		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
-		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
-			continue;
-
-		/* The timestamp is valid, so we'll go ahead and clear this
-		 * index and then send the timestamp up to the stack.
-		 */
-		spin_lock(&tx->lock);
-		tx->tstamps[idx].cached_tstamp = raw_tstamp;
-		clear_bit(idx, tx->in_use);
-		skb = tx->tstamps[idx].skb;
-		tx->tstamps[idx].skb = NULL;
-		spin_unlock(&tx->lock);
-
-		/* it's (unlikely but) possible we raced with the cleanup
-		 * thread for discarding old timestamp requests.
-		 */
-		if (!skb)
-			continue;
-
-		/* Extend the timestamp using cached PHC time */
-		tstamp = ice_ptp_extend_40b_ts(pf, raw_tstamp);
-		if (tstamp) {
-			shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
-			ice_trace(tx_tstamp_complete, skb, idx);
-		}
-
-		skb_tstamp_tx(skb, &shhwtstamps);
-		dev_kfree_skb_any(skb);
-	}
-
-	/* Check if we still have work to do. If so, re-queue this task to
-	 * poll for remaining timestamps.
-	 */
-	spin_lock(&tx->lock);
-	if (!bitmap_empty(tx->in_use, tx->len))
-		kthread_queue_work(pf->ptp.kworker, &tx->work);
-	spin_unlock(&tx->lock);
-}
-
 /**
  * ice_ptp_request_ts - Request an available Tx timestamp index
  * @tx: the PTP Tx timestamp tracker to request from
@@ -2195,172 +2361,6 @@ void ice_ptp_process_ts(struct ice_pf *pf)
 		kthread_queue_work(pf->ptp.kworker, &pf->ptp.port.tx.work);
 }
 
-/**
- * ice_ptp_alloc_tx_tracker - Initialize tracking for Tx timestamps
- * @tx: Tx tracking structure to initialize
- *
- * Assumes that the length has already been initialized. Do not call directly,
- * use the ice_ptp_init_tx_e822 or ice_ptp_init_tx_e810 instead.
- */
-static int
-ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
-{
-	tx->tstamps = kcalloc(tx->len, sizeof(*tx->tstamps), GFP_KERNEL);
-	if (!tx->tstamps)
-		return -ENOMEM;
-
-	tx->in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
-	if (!tx->in_use) {
-		kfree(tx->tstamps);
-		tx->tstamps = NULL;
-		return -ENOMEM;
-	}
-
-	spin_lock_init(&tx->lock);
-	kthread_init_work(&tx->work, ice_ptp_tx_tstamp_work);
-
-	tx->init = 1;
-
-	return 0;
-}
-
-/**
- * ice_ptp_flush_tx_tracker - Flush any remaining timestamps from the tracker
- * @pf: Board private structure
- * @tx: the tracker to flush
- */
-static void
-ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
-{
-	u8 idx;
-
-	for (idx = 0; idx < tx->len; idx++) {
-		u8 phy_idx = idx + tx->quad_offset;
-
-		spin_lock(&tx->lock);
-		if (tx->tstamps[idx].skb) {
-			dev_kfree_skb_any(tx->tstamps[idx].skb);
-			tx->tstamps[idx].skb = NULL;
-			pf->ptp.tx_hwtstamp_flushed++;
-		}
-		clear_bit(idx, tx->in_use);
-		spin_unlock(&tx->lock);
-
-		/* Clear any potential residual timestamp in the PHY block */
-		if (!pf->hw.reset_ongoing)
-			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
-	}
-}
-
-/**
- * ice_ptp_release_tx_tracker - Release allocated memory for Tx tracker
- * @pf: Board private structure
- * @tx: Tx tracking structure to release
- *
- * Free memory associated with the Tx timestamp tracker.
- */
-static void
-ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
-{
-	tx->init = 0;
-
-	kthread_cancel_work_sync(&tx->work);
-
-	ice_ptp_flush_tx_tracker(pf, tx);
-
-	kfree(tx->tstamps);
-	tx->tstamps = NULL;
-
-	bitmap_free(tx->in_use);
-	tx->in_use = NULL;
-
-	tx->len = 0;
-}
-
-/**
- * ice_ptp_init_tx_e822 - Initialize tracking for Tx timestamps
- * @pf: Board private structure
- * @tx: the Tx tracking structure to initialize
- * @port: the port this structure tracks
- *
- * Initialize the Tx timestamp tracker for this port. For generic MAC devices,
- * the timestamp block is shared for all ports in the same quad. To avoid
- * ports using the same timestamp index, logically break the block of
- * registers into chunks based on the port number.
- */
-static int
-ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
-{
-	tx->quad = port / ICE_PORTS_PER_QUAD;
-	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
-	tx->len = INDEX_PER_PORT;
-
-	return ice_ptp_alloc_tx_tracker(tx);
-}
-
-/**
- * ice_ptp_init_tx_e810 - Initialize tracking for Tx timestamps
- * @pf: Board private structure
- * @tx: the Tx tracking structure to initialize
- *
- * Initialize the Tx timestamp tracker for this PF. For E810 devices, each
- * port has its own block of timestamps, independent of the other ports.
- */
-static int
-ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
-{
-	tx->quad = pf->hw.port_info->lport;
-	tx->quad_offset = 0;
-	tx->len = INDEX_PER_QUAD;
-
-	return ice_ptp_alloc_tx_tracker(tx);
-}
-
-/**
- * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
- * @pf: pointer to the PF struct
- * @tx: PTP Tx tracker to clean up
- *
- * Loop through the Tx timestamp requests and see if any of them have been
- * waiting for a long time. Discard any SKBs that have been waiting for more
- * than 2 seconds. This is long enough to be reasonably sure that the
- * timestamp will never be captured. This might happen if the packet gets
- * discarded before it reaches the PHY timestamping block.
- */
-static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
-{
-	struct ice_hw *hw = &pf->hw;
-	u8 idx;
-
-	if (!tx->init)
-		return;
-
-	for_each_set_bit(idx, tx->in_use, tx->len) {
-		struct sk_buff *skb;
-		u64 raw_tstamp;
-
-		/* Check if this SKB has been waiting for too long */
-		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
-			continue;
-
-		/* Read tstamp to be able to use this register again */
-		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
-				    &raw_tstamp);
-
-		spin_lock(&tx->lock);
-		skb = tx->tstamps[idx].skb;
-		tx->tstamps[idx].skb = NULL;
-		clear_bit(idx, tx->in_use);
-		spin_unlock(&tx->lock);
-
-		/* Count the number of Tx timestamps which have timed out */
-		pf->ptp.tx_hwtstamp_timeouts++;
-
-		/* Free the SKB after we've cleared the bit */
-		dev_kfree_skb_any(skb);
-	}
-}
-
 static void ice_ptp_periodic_work(struct kthread_work *work)
 {
 	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
-- 
2.35.1

