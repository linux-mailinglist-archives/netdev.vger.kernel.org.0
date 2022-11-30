Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEA163E0EB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiK3ToB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiK3Tnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:45 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB9E93A59
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837424; x=1701373424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OgBfh9YI9spFlMefmUYG5ym74HSsYtotFbHmMDByShA=;
  b=FMPmjQHr7zza4wNyVVDhx31YqMmja+1saQcxQzbIjy2Q0+FQc5xxiX2R
   lJUX3keQMrujoD+MnpkheICb1NyvlLoWds1lkj+GFdTei0SoXXE2BoDDU
   vvTlPW701Z9fzU7xOQVdKW5prhMPxzBonk+YaDOEdD4X1iCtdx+UxIsx2
   sCAkXf0Z9dY/vlVK/N4CC5tGHmXxH2PG92LOhBGAERtTeO0QunI9Mr2ZS
   U+3MP22u1kTs/Ku+5LDQaf+Q0DMKv6TOI0gK5+6xrd+By5RxEGs7wvkcs
   Od/WKxfykdCg/quW8VNp7DpGGeaxQVTDxjk5Mq3IAs/OYoDVOOhNuo0h2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098388"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098388"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752289"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752289"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 06/14] ice: handle discarding old Tx requests in ice_ptp_tx_tstamp
Date:   Wed, 30 Nov 2022 11:43:22 -0800
Message-Id: <20221130194330.3257836-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Currently the driver uses the PTP kthread to process handling and
discarding of stale Tx timestamp requests. The function
ice_ptp_tx_tstamp_cleanup is used for this.

A separate thread creates complications for the driver as we now have both
the main Tx timestamp processing IRQ checking timestamps as well as the
kthread.

Rather than using the kthread to handle this, simply check for stale
timestamps within the ice_ptp_tx_tstamp function. This function must
already process the timestamps anyways.

If a Tx timestamp has been waiting for 2 seconds we simply clear the bit
and discard the SKB. This avoids the complication of having separate
threads polling, reducing overall CPU work.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 106 ++++++++++-------------
 1 file changed, 45 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 1564c72189bf..58e527f202c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -626,15 +626,32 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
  * Note that we only take the tracking lock when clearing the bit and when
  * checking if we need to re-queue this task. The only place where bits can be
  * set is the hard xmit routine where an SKB has a request flag set. The only
- * places where we clear bits are this work function, or the periodic cleanup
- * thread. If the cleanup thread clears a bit we're processing we catch it
- * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
- * starts a new timestamp, we might not begin processing it right away but we
- * will notice it at the end when we re-queue the task. If a Tx thread starts
- * a new timestamp just after this function exits without re-queuing,
- * the interrupt when the timestamp finishes should trigger. Avoiding holding
- * the lock for the entire function is important in order to ensure that Tx
- * threads do not get blocked while waiting for the lock.
+ * places where we clear bits are this work function, or when flushing the Tx
+ * timestamp tracker.
+ *
+ * If the Tx tracker gets flushed while we're processing a packet, we catch
+ * this because we grab the SKB pointer under lock. If the SKB is NULL we know
+ * that another thread already discarded the SKB and we can avoid passing it
+ * up to the stack.
+ *
+ * If a Tx thread starts a new timestamp, we might not begin processing it
+ * right away but we will notice it at the end when we re-queue the task.
+ *
+ * If a Tx thread starts a new timestamp just after this function exits, the
+ * interrupt for that timestamp should re-trigger this function once
+ * a timestamp is ready.
+ *
+ * Note that minimizing the time we hold the lock is important. If we held the
+ * lock for the entire function we would unnecessarily block the Tx hot path
+ * which needs to set the timestamp index. Limiting how long we hold the lock
+ * ensures we do not block Tx threads.
+ *
+ * If a Tx packet has been waiting for more than 2 seconds, it is not possible
+ * to correctly extend the timestamp using the cached PHC time. It is
+ * extremely unlikely that a packet will ever take this long to timestamp. If
+ * we detect a Tx timestamp request that has waited for this long we assume
+ * the packet will never be sent by hardware and discard it without reading
+ * the timestamp register.
  */
 static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 {
@@ -653,9 +670,20 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		struct skb_shared_hwtstamps shhwtstamps = {};
 		u8 phy_idx = idx + tx->offset;
 		u64 raw_tstamp, tstamp;
+		bool drop_ts = false;
 		struct sk_buff *skb;
 		int err;
 
+		/* Drop packets which have waited for more than 2 seconds */
+		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
+			drop_ts = true;
+
+			/* Count the number of Tx timestamps that timed out */
+			pf->ptp.tx_hwtstamp_timeouts++;
+
+			goto skip_ts_read;
+		}
+
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
 		err = ice_read_phy_tstamp(&pf->hw, tx->block, phy_idx,
@@ -670,9 +698,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
 			continue;
 
-		/* The timestamp is valid, so we'll go ahead and clear this
-		 * index and then send the timestamp up to the stack.
-		 */
+skip_ts_read:
 		spin_lock(&tx->lock);
 		tx->tstamps[idx].cached_tstamp = raw_tstamp;
 		clear_bit(idx, tx->in_use);
@@ -680,12 +706,17 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		tx->tstamps[idx].skb = NULL;
 		spin_unlock(&tx->lock);
 
-		/* it's (unlikely but) possible we raced with the cleanup
-		 * thread for discarding old timestamp requests.
+		/* It is unlikely but possible that the SKB will have been
+		 * flushed at this point due to link change or teardown.
 		 */
 		if (!skb)
 			continue;
 
+		if (drop_ts) {
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
 		/* Extend the timestamp using cached PHC time */
 		tstamp = ice_ptp_extend_40b_ts(pf, raw_tstamp);
 		if (tstamp) {
@@ -826,51 +857,6 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	return ice_ptp_alloc_tx_tracker(tx);
 }
 
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
-		ice_read_phy_tstamp(hw, tx->block, idx + tx->offset,
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
 /**
  * ice_ptp_update_cached_phctime - Update the cached PHC time values
  * @pf: Board specific private structure
@@ -2359,8 +2345,6 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	err = ice_ptp_update_cached_phctime(pf);
 
-	ice_ptp_tx_tstamp_cleanup(pf, &pf->ptp.port.tx);
-
 	/* Run twice a second or reschedule if phc update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
 				   msecs_to_jiffies(err ? 10 : 500));
-- 
2.35.1

