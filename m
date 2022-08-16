Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50DB59610B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiHPRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiHPRYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:24:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8952A254
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660670642; x=1692206642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2lPK9DXbPS51o9vUJyE2OA8rfMlJ2Dm8kkaKXHCNjVE=;
  b=U5vtqAAni+xDkVDUfY+PlTjR9rAIY+bHS6MMSEUozcCr6NOl7hxweLpP
   dKKfztGjzyrAZeiTrhUdOzsEsHWeB/9bUA9BHYudoSKM/cQEPXS0gOECy
   b0qMnVfW0d+9KIbvy1ItZNew57vUJq02/1vpNtofABtfW13hnQR/2Mxup
   QItOIXmsssvqDsS6lKtGNVHSCFcxzAd+FiU5TINmbRTAR9irJGDKZz/0V
   7Gj/4ZSBCR+ZY4GuJkOztQ8K3yjFKGxpjC1WYmApJOJkuR4AxNYOgJeSy
   CTworWZhARxYhGgDIw1t5qeDn5ZuNU1vMrEECJApMteGCQMm44pyl35xK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="318281045"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="318281045"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:24:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="610340379"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2022 10:24:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 6/6] ice: introduce ice_ptp_reset_cached_phctime function
Date:   Tue, 16 Aug 2022 10:23:52 -0700
Message-Id: <20220816172352.2532304-7-anthony.l.nguyen@intel.com>
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

If the PTP hardware clock is adjusted, the ice driver must update the
cached PHC timestamp. This is required in order to perform timestamp
extension on the shorter timestamps captured by the PHY.

Currently, we simply call ice_ptp_update_cached_phctime in the settime and
adjtime callbacks. This has a few issues:

1) if ICE_CFG_BUSY is set because another thread is updating the Rx rings,
   we will exit with an error. This is not checked, and the functions do
   not re-schedule the update. This could leave the cached timestamp
   incorrect until the next scheduled work item execution.

2) even if we did handle an update, any currently outstanding Tx timestamp
   would be extended using the wrong cached PHC time. This would produce
   incorrect results.

To fix these issues, introduce a new ice_ptp_reset_cached_phctime function.
This function calls the ice_ptp_update_cached_phctime, and discards
outstanding Tx timestamps.

If the ice_ptp_update_cached_phctime function fails because ICE_CFG_BUSY is
set, we log a warning and schedule the thread to execute soon. The update
function is modified so that it always updates the cached copy in the PF
regardless. This ensures we have the most up to date values possible and
minimizes the risk of a packet timestamp being extended with the wrong
value.

It would be nice if we could skip reporting Rx timestamps until the cached
values are up to date. However, we can't access the Rx rings while
ICE_CFG_BUSY is set because they are actively being updated by another
thread.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 99 ++++++++++++++++++------
 1 file changed, 76 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f125b8135348..5a2fd4d690f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -880,8 +880,10 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
  * structure and the Rx rings.
  *
  * This function must be called periodically to ensure that the cached value
- * is never more than 2 seconds old. It must also be called whenever the PHC
- * time has been changed.
+ * is never more than 2 seconds old.
+ *
+ * Note that the cached copy in the PF PTP structure is always updated, even
+ * if we can't update the copy in the Rx rings.
  *
  * Return:
  * * 0 - OK, successfully updated
@@ -894,9 +896,6 @@ static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 	u64 systime;
 	int i;
 
-	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
-		return -EAGAIN;
-
 	update_before = pf->ptp.cached_phc_jiffies + msecs_to_jiffies(2000);
 	if (pf->ptp.cached_phc_time &&
 	    time_is_before_jiffies(update_before)) {
@@ -914,6 +913,9 @@ static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 	WRITE_ONCE(pf->ptp.cached_phc_time, systime);
 	WRITE_ONCE(pf->ptp.cached_phc_jiffies, jiffies);
 
+	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
+		return -EAGAIN;
+
 	ice_for_each_vsi(pf, i) {
 		struct ice_vsi *vsi = pf->vsi[i];
 		int j;
@@ -935,6 +937,52 @@ static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_ptp_reset_cached_phctime - Reset cached PHC time after an update
+ * @pf: Board specific private structure
+ *
+ * This function must be called when the cached PHC time is no longer valid,
+ * such as after a time adjustment. It discards any outstanding Tx timestamps,
+ * and updates the cached PHC time for both the PF and Rx rings. If updating
+ * the PHC time cannot be done immediately, a warning message is logged and
+ * the work item is scheduled.
+ *
+ * These steps are required in order to ensure that we do not accidentally
+ * report a timestamp extended by the wrong PHC cached copy. Note that we
+ * do not directly update the cached timestamp here because it is possible
+ * this might produce an error when ICE_CFG_BUSY is set. If this occurred, we
+ * would have to try again. During that time window, timestamps might be
+ * requested and returned with an invalid extension. Thus, on failure to
+ * immediately update the cached PHC time we would need to zero the value
+ * anyways. For this reason, we just zero the value immediately and queue the
+ * update work item.
+ */
+static void ice_ptp_reset_cached_phctime(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
+
+	/* Update the cached PHC time immediately if possible, otherwise
+	 * schedule the work item to execute soon.
+	 */
+	err = ice_ptp_update_cached_phctime(pf);
+	if (err) {
+		/* If another thread is updating the Rx rings, we won't
+		 * properly reset them here. This could lead to reporting of
+		 * invalid timestamps, but there isn't much we can do.
+		 */
+		dev_warn(dev, "%s: ICE_CFG_BUSY, unable to immediately update cached PHC time\n",
+			 __func__);
+
+		/* Queue the work item to update the Rx rings when possible */
+		kthread_queue_delayed_work(pf->ptp.kworker, &pf->ptp.work,
+					   msecs_to_jiffies(10));
+	}
+
+	/* Flush any outstanding Tx timestamps */
+	ice_ptp_flush_tx_tracker(pf, &pf->ptp.port.tx);
+}
+
 /**
  * ice_ptp_read_time - Read the time from the device
  * @pf: Board private structure
@@ -1803,7 +1851,7 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 	ice_ptp_unlock(hw);
 
 	if (!err)
-		ice_ptp_update_cached_phctime(pf);
+		ice_ptp_reset_cached_phctime(pf);
 
 	/* Reenable periodic outputs */
 	ice_ptp_enable_all_clkout(pf);
@@ -1882,7 +1930,7 @@ static int ice_ptp_adjtime(struct ptp_clock_info *info, s64 delta)
 		return err;
 	}
 
-	ice_ptp_update_cached_phctime(pf);
+	ice_ptp_reset_cached_phctime(pf);
 
 	return 0;
 }
@@ -2090,26 +2138,31 @@ void
 ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb)
 {
+	struct skb_shared_hwtstamps *hwtstamps;
+	u64 ts_ns, cached_time;
 	u32 ts_high;
-	u64 ts_ns;
 
-	/* Populate timesync data into skb */
-	if (rx_desc->wb.time_stamp_low & ICE_PTP_TS_VALID) {
-		struct skb_shared_hwtstamps *hwtstamps;
+	if (!(rx_desc->wb.time_stamp_low & ICE_PTP_TS_VALID))
+		return;
 
-		/* Use ice_ptp_extend_32b_ts directly, using the ring-specific
-		 * cached PHC value, rather than accessing the PF. This also
-		 * allows us to simply pass the upper 32bits of nanoseconds
-		 * directly. Calling ice_ptp_extend_40b_ts is unnecessary as
-		 * it would just discard these bits itself.
-		 */
-		ts_high = le32_to_cpu(rx_desc->wb.flex_ts.ts_high);
-		ts_ns = ice_ptp_extend_32b_ts(rx_ring->cached_phctime, ts_high);
+	cached_time = READ_ONCE(rx_ring->cached_phctime);
 
-		hwtstamps = skb_hwtstamps(skb);
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
-		hwtstamps->hwtstamp = ns_to_ktime(ts_ns);
-	}
+	/* Do not report a timestamp if we don't have a cached PHC time */
+	if (!cached_time)
+		return;
+
+	/* Use ice_ptp_extend_32b_ts directly, using the ring-specific cached
+	 * PHC value, rather than accessing the PF. This also allows us to
+	 * simply pass the upper 32bits of nanoseconds directly. Calling
+	 * ice_ptp_extend_40b_ts is unnecessary as it would just discard these
+	 * bits itself.
+	 */
+	ts_high = le32_to_cpu(rx_desc->wb.flex_ts.ts_high);
+	ts_ns = ice_ptp_extend_32b_ts(cached_time, ts_high);
+
+	hwtstamps = skb_hwtstamps(skb);
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = ns_to_ktime(ts_ns);
 }
 
 /**
-- 
2.35.1

