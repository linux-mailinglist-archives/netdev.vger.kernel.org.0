Return-Path: <netdev+bounces-9356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5F8728963
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3125A2817BD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284853446B;
	Thu,  8 Jun 2023 20:25:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1832131EEE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:25:52 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D25C2D68
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686255950; x=1717791950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ZfnT2BMfI5TlkIY66sMqwoJkUQ12bTQek9AneAgFK0=;
  b=Y0jXFsdwq8eCrd7KULIMUiZOUXp7IkBWfIz8AhowseQrNnKY1a/5/5G6
   KFu3A8BpW71ZR0QeCjhu0XZUf14SZrJNRxZLTZfROPzPpw1Ke66Fqaie1
   EnvQKxlBTMBCs56oybH+VJVYEFzsYmvAeZ5nJE7E8CCYgTXj9YlXE1Xug
   nUVuRv1hUN07GQzZ+f1NQlq/4doYYvcQdK1cCWj+NPIK0UQruujsxzTOH
   ukcgD2wdRmrLdt9dvGH4eHSp6iQPYZSB0ktPVyWdsLIsjAlEtMiEAVjzC
   sPkSXR72SnJguLoEEzIyj5EWDGygk72CyOWY/D1Sd2czqkbRFTUj4TpIY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385776296"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385776296"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822767856"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822767856"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2023 13:25:48 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Jacob Keller <jacob.e.keller@intel.com>,
	anthony.l.nguyen@intel.com,
	richardcochran@gmail.com,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net-next 3/5] ice: introduce ICE_TX_TSTAMP_WORK enumeration
Date: Thu,  8 Jun 2023 13:21:13 -0700
Message-Id: <20230608202115.453965-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
References: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_ptp_process_ts() function and its various helper functions return a
boolean value indicating whether any work is remaining. This use of a
boolean has grown confusing as we have multiple helpers that pass status
between each other. Readers must be aware of what "true" and "false" mean,
and it is very easy to get their meaning inverted. The names of the
functions are not standard "yes/no" questions, which is the best practice
for boolean returns.

Replace this use of an enumeration with a custom type, enum
ice_tx_tstamp_work. This enumeration clearly indicates whether all work is
done, or if more work is pending.

To aid in readability, factor the actual list iteration and processing out
into ice_ptp_process_tx_tstamp(), making it void. Then call this in
ice_ptp_tx_tstamp() ensuring that we always check the Tracker list at the
end when determining the appropriate return value.

Now the return value is an explicit name instead of the true or false
value. This is easier to follow and makes reading the resulting callers
much simpler.

In addition, this paves the way for future work to allow E822 hardware to
process timestamps for all functions using a single interrupt on the clock
owning PF.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 50 ++++++++++++++---------
 drivers/net/ethernet/intel/ice/ice_ptp.h  | 12 +++++-
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 45dab7f62198..6811e2a3c154 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3202,7 +3202,7 @@ static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 		ice_ptp_extts_event(pf);
 
 	if (test_and_clear_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread)) {
-		while (!ice_ptp_process_ts(pf))
+		while (ice_ptp_process_ts(pf) == ICE_TX_TSTAMP_WORK_PENDING)
 			usleep_range(50, 100);
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 6f51ebaf1d70..81d96a40d5a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -617,7 +617,7 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
 }
 
 /**
- * ice_ptp_tx_tstamp - Process Tx timestamps for a port
+ * ice_ptp_process_tx_tstamp - Process Tx timestamps for a port
  * @tx: the PTP Tx timestamp tracker
  *
  * Process timestamps captured by the PHY associated with this port. To do
@@ -633,15 +633,6 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
  * 6) extend the 40 bit timestamp value to get a 64 bit timestamp value
  * 7) send this 64 bit timestamp to the stack
  *
- * Returns true if all timestamps were handled, and false if any slots remain
- * without a timestamp.
- *
- * After looping, if we still have waiting SKBs, return false. This may cause
- * us effectively poll even when not strictly necessary. We do this because
- * it's possible a new timestamp was requested around the same time as the
- * interrupt. In some cases hardware might not interrupt us again when the
- * timestamp is captured.
- *
  * Note that we do not hold the tracking lock while reading the Tx timestamp.
  * This is because reading the timestamp requires taking a mutex that might
  * sleep.
@@ -673,10 +664,9 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
  * the packet will never be sent by hardware and discard it without reading
  * the timestamp register.
  */
-static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
+static void ice_ptp_process_tx_tstamp(struct ice_ptp_tx *tx)
 {
 	struct ice_ptp_port *ptp_port;
-	bool more_timestamps;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	u64 tstamp_ready;
@@ -685,7 +675,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	u8 idx;
 
 	if (!tx->init)
-		return true;
+		return;
 
 	ptp_port = container_of(tx, struct ice_ptp_port, tx);
 	pf = ptp_port_to_pf(ptp_port);
@@ -694,7 +684,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	/* Read the Tx ready status first */
 	err = ice_get_phy_tx_tstamp_ready(hw, tx->block, &tstamp_ready);
 	if (err)
-		return false;
+		return;
 
 	/* Drop packets if the link went down */
 	link_up = ptp_port->link_up;
@@ -782,15 +772,34 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		skb_tstamp_tx(skb, &shhwtstamps);
 		dev_kfree_skb_any(skb);
 	}
+}
 
-	/* Check if we still have work to do. If so, re-queue this task to
-	 * poll for remaining timestamps.
-	 */
+/**
+ * ice_ptp_tx_tstamp - Process Tx timestamps for this function.
+ * @tx: Tx tracking structure to initialize
+ *
+ * Returns: ICE_TX_TSTAMP_WORK_PENDING if there are any outstanding incomplete
+ * Tx timestamps, or ICE_TX_TSTAMP_WORK_DONE otherwise.
+ */
+static enum ice_tx_tstamp_work ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
+{
+	bool more_timestamps;
+
+	if (!tx->init)
+		return ICE_TX_TSTAMP_WORK_DONE;
+
+	/* Process the Tx timestamp tracker */
+	ice_ptp_process_tx_tstamp(tx);
+
+	/* Check if there are outstanding Tx timestamps */
 	spin_lock(&tx->lock);
 	more_timestamps = tx->init && !bitmap_empty(tx->in_use, tx->len);
 	spin_unlock(&tx->lock);
 
-	return !more_timestamps;
+	if (more_timestamps)
+		return ICE_TX_TSTAMP_WORK_PENDING;
+
+	return ICE_TX_TSTAMP_WORK_DONE;
 }
 
 /**
@@ -2426,9 +2435,10 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
  * ice_ptp_process_ts - Process the PTP Tx timestamps
  * @pf: Board private structure
  *
- * Returns true if timestamps are processed.
+ * Returns: ICE_TX_TSTAMP_WORK_PENDING if there are any outstanding Tx
+ * timestamps that need processing, and ICE_TX_TSTAMP_WORK_DONE otherwise.
  */
-bool ice_ptp_process_ts(struct ice_pf *pf)
+enum ice_tx_tstamp_work ice_ptp_process_ts(struct ice_pf *pf)
 {
 	return ice_ptp_tx_tstamp(&pf->ptp.port.tx);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 9f8902c1e743..995a57019ba7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -108,6 +108,16 @@ struct ice_tx_tstamp {
 	u64 cached_tstamp;
 };
 
+/**
+ * enum ice_tx_tstamp_work - Status of Tx timestamp work function
+ * @ICE_TX_TSTAMP_WORK_DONE: Tx timestamp processing is complete
+ * @ICE_TX_TSTAMP_WORK_PENDING: More Tx timestamps are pending
+ */
+enum ice_tx_tstamp_work {
+	ICE_TX_TSTAMP_WORK_DONE = 0,
+	ICE_TX_TSTAMP_WORK_PENDING,
+};
+
 /**
  * struct ice_ptp_tx - Tracking structure for all Tx timestamp requests on a port
  * @lock: lock to prevent concurrent access to fields of this struct
@@ -256,7 +266,7 @@ int ice_get_ptp_clock_index(struct ice_pf *pf);
 
 void ice_ptp_extts_event(struct ice_pf *pf);
 s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
-bool ice_ptp_process_ts(struct ice_pf *pf);
+enum ice_tx_tstamp_work ice_ptp_process_ts(struct ice_pf *pf);
 
 void
 ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-- 
2.38.1


