Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E72264630C
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiLGVKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiLGVJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AF573F6E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447386; x=1701983386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NbXS1Sbc69lsNcSeMrVIjPvnUiifLYzREOyWoMDFWNU=;
  b=AAKpkcNd6ipk+jJgpZN8h+hh5tvOy0UkTxogi7S5tZQtaRubn4DtKrDH
   JS7iGMloRipi3KUIz1B6EWN11KVw+i7v//IOe17qk7qDRlUX4e21f+Ag8
   Ukp9VLAJRLi7PDe3QIY1kPXQPvsDbLIweZiGKVsYDdLVhXORHQQw+ZTNw
   rBh9CJAyl9g+t96WvBOO6ypB03VnKt6qzav+cITMRcZFVs/1wW1bhfm8+
   V+4q2S744YSNbKyv4GYAdG1KLn4xju+em+Pom/WhMsQ6WfX0fhgJhcdBg
   vaQOMap3jhIkbC1Z0Brk98oQrN351U+VzNiQQoAPJvVE+wUVYXPFaCtGJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697112"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697112"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508860"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508860"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 12/15] ice: handle flushing stale Tx timestamps in ice_ptp_tx_tstamp
Date:   Wed,  7 Dec 2022 13:09:34 -0800
Message-Id: <20221207210937.1099650-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In the event of a PTP clock time change due to .adjtime or .settime, the
ice driver needs to update the cached copy of the PHC time and also discard
any outstanding Tx timestamps.

This is required because otherwise the wrong copy of the PHC time will be
used when extending the Tx timestamp. This could result in reporting
incorrect timestamps to the stack.

The current approach taken to handle this is to call
ice_ptp_flush_tx_tracker, which will discard any timestamps which are not
yet complete.

This is problematic for two reasons:

1) it could lead to a potential race condition where the wrong timestamp is
   associated with a future packet.

   This can occur with the following flow:

   1. Thread A gets request to transmit a timestamped packet, and picks an
      index and transmits the packet

   2. Thread B calls ice_ptp_flush_tx_tracker and sees the index in use,
      marking is as disarded. No timestamp read occurs because the status
      bit is not set, but the index is released for re-use

   3. Thread A gets a new request to transmit another timestamped packet,
      picks the same (now unused) index and transmits that packet.

   4. The PHY transmits the first packet and updates the timestamp slot and
      generates an interrupt.

   5. The ice_ptp_tx_tstamp thread executes and sees the interrupt and a
      valid timestamp but associates it with the new Tx SKB and not the one
      that actual timestamp for the packet as expected.

   This could result in the previous timestamp being assigned to a new
   packet producing incorrect timestamps and leading to incorrect behavior
   in PTP applications.

   This is most likely to occur when the packet rate for Tx timestamp
   requests is very high.

2) on E822 hardware, we must avoid reading a timestamp index more than once
   each time its status bit is set and an interrupt is generated by
   hardware.

   We do have some extensive checks for the unread flag to ensure that only
   one of either the ice_ptp_flush_tx_tracker or ice_ptp_tx_tstamp threads
   read the timestamp. However, even with this we can still have cases
   where we "flush" a timestamp that was actually completed in hardware.
   This can lead to cases where we don't read the timestamp index as
   appropriate.

To fix both of these issues, we must avoid calling ice_ptp_flush_tx_tracker
outside of the teardown path.

Rather than using ice_ptp_flush_tx_tracker, introduce a new state bitmap,
the stale bitmap. Start this as cleared when we begin a new timestamp
request. When we're about to extend a timestamp and send it up to the
stack, first check to see if that stale bit was set. If so, drop the
timestamp without sending it to the stack.

When we need to update the cached PHC timestamp out of band, just mark all
currently outstanding timestamps as stale. This will ensure that once
hardware completes the timestamp we'll ignore it correctly and avoid
reporting bogus timestamps to userspace.

With this change, we fix potential issues caused  by calling
ice_ptp_flush_tx_tracker during normal operation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 104 +++++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_ptp.h |   2 +
 2 files changed, 70 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index fbafa82ea1ed..d40c570297c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -625,11 +625,13 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
  *
  * If a given index has a valid timestamp, perform the following steps:
  *
- * 1) copy the timestamp out of the PHY register
- * 4) clear the timestamp valid bit in the PHY register
- * 5) unlock the index by clearing the associated in_use bit.
- * 2) extend the 40b timestamp value to get a 64bit timestamp
- * 3) send that timestamp to the stack
+ * 1) check that the timestamp request is not stale
+ * 2) check that a timestamp is ready and available in the PHY memory bank
+ * 3) read and copy the timestamp out of the PHY register
+ * 4) unlock the index by clearing the associated in_use bit
+ * 5) check if the timestamp is stale, and discard if so
+ * 6) extend the 40 bit timestamp value to get a 64 bit timestamp value
+ * 7) send this 64 bit timestamp to the stack
  *
  * Returns true if all timestamps were handled, and false if any slots remain
  * without a timestamp.
@@ -640,16 +642,16 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
  * interrupt. In some cases hardware might not interrupt us again when the
  * timestamp is captured.
  *
- * Note that we only take the tracking lock when clearing the bit and when
- * checking if we need to re-queue this task. The only place where bits can be
- * set is the hard xmit routine where an SKB has a request flag set. The only
- * places where we clear bits are this work function, or when flushing the Tx
- * timestamp tracker.
+ * Note that we do not hold the tracking lock while reading the Tx timestamp.
+ * This is because reading the timestamp requires taking a mutex that might
+ * sleep.
  *
- * If the Tx tracker gets flushed while we're processing a packet, we catch
- * this because we grab the SKB pointer under lock. If the SKB is NULL we know
- * that another thread already discarded the SKB and we can avoid passing it
- * up to the stack.
+ * The only place where we set in_use is when a new timestamp is initiated
+ * with a slot index. This is only called in the hard xmit routine where an
+ * SKB has a request flag set. The only places where we clear this bit is this
+ * function, or during teardown when the Tx timestamp tracker is being
+ * removed. A timestamp index will never be re-used until the in_use bit for
+ * that index is cleared.
  *
  * If a Tx thread starts a new timestamp, we might not begin processing it
  * right away but we will notice it at the end when we re-queue the task.
@@ -658,10 +660,11 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
  * interrupt for that timestamp should re-trigger this function once
  * a timestamp is ready.
  *
- * Note that minimizing the time we hold the lock is important. If we held the
- * lock for the entire function we would unnecessarily block the Tx hot path
- * which needs to set the timestamp index. Limiting how long we hold the lock
- * ensures we do not block Tx threads.
+ * In cases where the PTP hardware clock was directly adjusted, some
+ * timestamps may not be able to safely use the timestamp extension math. In
+ * this case, software will set the stale bit for any outstanding Tx
+ * timestamps when the clock is adjusted. Then this function will discard
+ * those captured timestamps instead of sending them to the stack.
  *
  * If a Tx packet has been waiting for more than 2 seconds, it is not possible
  * to correctly extend the timestamp using the cached PHC time. It is
@@ -750,6 +753,8 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		clear_bit(idx, tx->in_use);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
+		if (test_and_clear_bit(idx, tx->stale))
+			drop_ts = true;
 		spin_unlock(&tx->lock);
 
 		/* It is unlikely but possible that the SKB will have been
@@ -794,21 +799,24 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 static int
 ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 {
+	unsigned long *in_use, *stale;
 	struct ice_tx_tstamp *tstamps;
-	unsigned long *in_use;
 
 	tstamps = kcalloc(tx->len, sizeof(*tstamps), GFP_KERNEL);
 	in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
+	stale = bitmap_zalloc(tx->len, GFP_KERNEL);
 
-	if (!tstamps || !in_use) {
+	if (!tstamps || !in_use || !stale) {
 		kfree(tstamps);
 		bitmap_free(in_use);
+		bitmap_free(stale);
 
 		return -ENOMEM;
 	}
 
 	tx->tstamps = tstamps;
 	tx->in_use = in_use;
+	tx->stale = stale;
 	tx->init = 1;
 	tx->link_down = 0;
 	tx->calibrating = 0;
@@ -838,6 +846,7 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 			pf->ptp.tx_hwtstamp_flushed++;
 		}
 		clear_bit(idx, tx->in_use);
+		clear_bit(idx, tx->stale);
 		spin_unlock(&tx->lock);
 
 		/* Clear any potential residual timestamp in the PHY block */
@@ -846,6 +855,28 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	}
 }
 
+/**
+ * ice_ptp_mark_tx_tracker_stale - Mark unfinished timestamps as stale
+ * @tx: the tracker to mark
+ *
+ * Mark currently outstanding Tx timestamps as stale. This prevents sending
+ * their timestamp value to the stack. This is required to prevent extending
+ * the 40bit hardware timestamp incorrectly.
+ *
+ * This should be called when the PTP clock is modified such as after a set
+ * time request.
+ */
+static void
+ice_ptp_mark_tx_tracker_stale(struct ice_ptp_tx *tx)
+{
+	u8 idx;
+
+	spin_lock(&tx->lock);
+	for_each_set_bit(idx, tx->in_use, tx->len)
+		set_bit(idx, tx->stale);
+	spin_unlock(&tx->lock);
+}
+
 /**
  * ice_ptp_release_tx_tracker - Release allocated memory for Tx tracker
  * @pf: Board private structure
@@ -871,6 +902,9 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	bitmap_free(tx->in_use);
 	tx->in_use = NULL;
 
+	bitmap_free(tx->stale);
+	tx->stale = NULL;
+
 	tx->len = 0;
 }
 
@@ -989,20 +1023,13 @@ static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
  * @pf: Board specific private structure
  *
  * This function must be called when the cached PHC time is no longer valid,
- * such as after a time adjustment. It discards any outstanding Tx timestamps,
- * and updates the cached PHC time for both the PF and Rx rings. If updating
- * the PHC time cannot be done immediately, a warning message is logged and
- * the work item is scheduled.
- *
- * These steps are required in order to ensure that we do not accidentally
- * report a timestamp extended by the wrong PHC cached copy. Note that we
- * do not directly update the cached timestamp here because it is possible
- * this might produce an error when ICE_CFG_BUSY is set. If this occurred, we
- * would have to try again. During that time window, timestamps might be
- * requested and returned with an invalid extension. Thus, on failure to
- * immediately update the cached PHC time we would need to zero the value
- * anyways. For this reason, we just zero the value immediately and queue the
- * update work item.
+ * such as after a time adjustment. It marks any currently outstanding Tx
+ * timestamps as stale and updates the cached PHC time for both the PF and Rx
+ * rings.
+ *
+ * If updating the PHC time cannot be done immediately, a warning message is
+ * logged and the work item is scheduled immediately to minimize the window
+ * with a wrong cached timestamp.
  */
 static void ice_ptp_reset_cached_phctime(struct ice_pf *pf)
 {
@@ -1026,8 +1053,12 @@ static void ice_ptp_reset_cached_phctime(struct ice_pf *pf)
 					   msecs_to_jiffies(10));
 	}
 
-	/* Flush any outstanding Tx timestamps */
-	ice_ptp_flush_tx_tracker(pf, &pf->ptp.port.tx);
+	/* Mark any outstanding timestamps as stale, since they might have
+	 * been captured in hardware before the time update. This could lead
+	 * to us extending them with the wrong cached value resulting in
+	 * incorrect timestamp values.
+	 */
+	ice_ptp_mark_tx_tracker_stale(&pf->ptp.port.tx);
 }
 
 /**
@@ -2382,6 +2413,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 		 * requests.
 		 */
 		set_bit(idx, tx->in_use);
+		clear_bit(idx, tx->stale);
 		tx->tstamps[idx].start = jiffies;
 		tx->tstamps[idx].skb = skb_get(skb);
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 75dcab8e1124..c03849dc7941 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -113,6 +113,7 @@ struct ice_tx_tstamp {
  * @lock: lock to prevent concurrent access to fields of this struct
  * @tstamps: array of len to store outstanding requests
  * @in_use: bitmap of len to indicate which slots are in use
+ * @stale: bitmap of len to indicate slots which have stale timestamps
  * @block: which memory block (quad or port) the timestamps are captured in
  * @offset: offset into timestamp block to get the real index
  * @len: length of the tstamps and in_use fields.
@@ -126,6 +127,7 @@ struct ice_ptp_tx {
 	spinlock_t lock; /* lock protecting in_use bitmap */
 	struct ice_tx_tstamp *tstamps;
 	unsigned long *in_use;
+	unsigned long *stale;
 	u8 block;
 	u8 offset;
 	u8 len;
-- 
2.35.1

