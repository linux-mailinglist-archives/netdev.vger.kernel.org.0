Return-Path: <netdev+bounces-9352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4009E728957
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AEBB1C20E9D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B69F31EEC;
	Thu,  8 Jun 2023 20:25:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F71F187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:25:50 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA6F2D6A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686255949; x=1717791949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6wXa/WLdbTOf0K9TbRDWv33weGAggmddEG6MH4bOtA=;
  b=HP0SpP2+OFzRh0GsjKbGcrXh8/mkBfBFR4sV6GTgtK4OGaNrX08rXkb9
   GPmDGfC5QKcJJPj27nthuAgoV8F5g/Ciq14s3SVb9bRSuuIULB7ST7rZR
   T89oDodl1nRMVRMVVUhFrcumpMlseUc/hu9WLldxKebHeuD9YeAWF2iKH
   KByCbp1Az/0NqrXkYCBBIyeHPAAOXHrIdHOT4S/PLXSW4X+vk9fwF1JhF
   dLp9JCNQmLT8QyicCmNhZb1Ryj7bP3qlxfMmJyIylCWUq0ySGUT9TJJs2
   Qc8v1kBEFZ5LhvYNUpWFwOCBwZMC6yJ93TplgVAwK2bvL6Y2gY4tvYBQW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385776281"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385776281"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822767844"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822767844"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2023 13:25:47 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Karol Kolacinski <karol.kolacinski@intel.com>,
	anthony.l.nguyen@intel.com,
	richardcochran@gmail.com,
	Jacob Keller <jacob.e.keller@intel.com>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net-next 1/5] ice: handle extts in the miscellaneous interrupt thread
Date: Thu,  8 Jun 2023 13:21:11 -0700
Message-Id: <20230608202115.453965-2-anthony.l.nguyen@intel.com>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

The ice_ptp_extts_work() and ice_ptp_periodic_work() functions are both
scheduled on the same kthread worker, pf.ptp.kworker. The
ice_ptp_periodic_work() function sends to the firmware to interact with the
PHY, and must block to wait for responses.

This can cause delay in responding to the PFINT_OICR_TSYN_EVNT interrupt
cause, ultimately resulting in disruption to processing an input signal of
the frequency is high enough. In our testing, even 100 Hz signals get
disrupted.

Fix this by instead processing the signal inside the miscellaneous
interrupt thread prior to handling Tx timestamps.

Use atomic bits in a new pf->misc_thread bitmap in order to safely
communicate which tasks require processing within the
ice_misc_intr_thread_fn(). This ensures the communication of desired tasks
from the ice_misc_intr() are correctly processed without racing even in the
event that the interrupt triggers again before the thread function exits.

Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  7 ++++++
 drivers/net/ethernet/intel/ice/ice_main.c | 29 ++++++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 12 +++-------
 drivers/net/ethernet/intel/ice/ice_ptp.h  |  4 ++--
 4 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b4bca1d964a9..4ba3d99439a0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -508,6 +508,12 @@ enum ice_pf_flags {
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
+enum ice_misc_thread_tasks {
+	ICE_MISC_THREAD_EXTTS_EVENT,
+	ICE_MISC_THREAD_TX_TSTAMP,
+	ICE_MISC_THREAD_NBITS		/* must be last */
+};
+
 struct ice_switchdev_info {
 	struct ice_vsi *control_vsi;
 	struct ice_vsi *uplink_vsi;
@@ -550,6 +556,7 @@ struct ice_pf {
 	DECLARE_BITMAP(features, ICE_F_MAX);
 	DECLARE_BITMAP(state, ICE_STATE_NBITS);
 	DECLARE_BITMAP(flags, ICE_PF_FLAGS_NBITS);
+	DECLARE_BITMAP(misc_thread, ICE_MISC_THREAD_NBITS);
 	unsigned long *avail_txqs;	/* bitmap to track PF Tx queue usage */
 	unsigned long *avail_rxqs;	/* bitmap to track PF Rx queue usage */
 	unsigned long serv_tmr_period;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 62e91512aeab..314a42808e39 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3139,20 +3139,28 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 	if (oicr & PFINT_OICR_TSYN_TX_M) {
 		ena_mask &= ~PFINT_OICR_TSYN_TX_M;
-		if (!hw->reset_ongoing)
+		if (!hw->reset_ongoing) {
+			set_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread);
 			ret = IRQ_WAKE_THREAD;
+		}
 	}
 
 	if (oicr & PFINT_OICR_TSYN_EVNT_M) {
 		u8 tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 		u32 gltsyn_stat = rd32(hw, GLTSYN_STAT(tmr_idx));
 
-		/* Save EVENTs from GTSYN register */
-		pf->ptp.ext_ts_irq |= gltsyn_stat & (GLTSYN_STAT_EVENT0_M |
-						     GLTSYN_STAT_EVENT1_M |
-						     GLTSYN_STAT_EVENT2_M);
 		ena_mask &= ~PFINT_OICR_TSYN_EVNT_M;
-		kthread_queue_work(pf->ptp.kworker, &pf->ptp.extts_work);
+
+		if (hw->func_caps.ts_func_info.src_tmr_owned) {
+			/* Save EVENTs from GLTSYN register */
+			pf->ptp.ext_ts_irq |= gltsyn_stat &
+					      (GLTSYN_STAT_EVENT0_M |
+					       GLTSYN_STAT_EVENT1_M |
+					       GLTSYN_STAT_EVENT2_M);
+
+			set_bit(ICE_MISC_THREAD_EXTTS_EVENT, pf->misc_thread);
+			ret = IRQ_WAKE_THREAD;
+		}
 	}
 
 #define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
@@ -3196,8 +3204,13 @@ static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 	if (ice_is_reset_in_progress(pf->state))
 		return IRQ_HANDLED;
 
-	while (!ice_ptp_process_ts(pf))
-		usleep_range(50, 100);
+	if (test_and_clear_bit(ICE_MISC_THREAD_EXTTS_EVENT, pf->misc_thread))
+		ice_ptp_extts_event(pf);
+
+	if (test_and_clear_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread)) {
+		while (!ice_ptp_process_ts(pf))
+			usleep_range(50, 100);
+	}
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index d4b6c997141d..6f51ebaf1d70 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1458,15 +1458,11 @@ static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 }
 
 /**
- * ice_ptp_extts_work - Workqueue task function
- * @work: external timestamp work structure
- *
- * Service for PTP external clock event
+ * ice_ptp_extts_event - Process PTP external clock event
+ * @pf: Board private structure
  */
-static void ice_ptp_extts_work(struct kthread_work *work)
+void ice_ptp_extts_event(struct ice_pf *pf)
 {
-	struct ice_ptp *ptp = container_of(work, struct ice_ptp, extts_work);
-	struct ice_pf *pf = container_of(ptp, struct ice_pf, ptp);
 	struct ptp_clock_event event;
 	struct ice_hw *hw = &pf->hw;
 	u8 chan, tmr_idx;
@@ -2558,7 +2554,6 @@ void ice_ptp_prepare_for_reset(struct ice_pf *pf)
 	ice_ptp_cfg_timestamp(pf, false);
 
 	kthread_cancel_delayed_work_sync(&ptp->work);
-	kthread_cancel_work_sync(&ptp->extts_work);
 
 	if (test_bit(ICE_PFR_REQ, pf->state))
 		return;
@@ -2656,7 +2651,6 @@ static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
 
 	/* Initialize work functions */
 	kthread_init_delayed_work(&ptp->work, ice_ptp_periodic_work);
-	kthread_init_work(&ptp->extts_work, ice_ptp_extts_work);
 
 	/* Allocate a kworker for handling work required for the ports
 	 * connected to the PTP hardware clock.
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 9cda2f43e0e5..9f8902c1e743 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -169,7 +169,6 @@ struct ice_ptp_port {
  * struct ice_ptp - data used for integrating with CONFIG_PTP_1588_CLOCK
  * @port: data for the PHY port initialization procedure
  * @work: delayed work function for periodic tasks
- * @extts_work: work function for handling external Tx timestamps
  * @cached_phc_time: a cached copy of the PHC time for timestamp extension
  * @cached_phc_jiffies: jiffies when cached_phc_time was last updated
  * @ext_ts_chan: the external timestamp channel in use
@@ -190,7 +189,6 @@ struct ice_ptp_port {
 struct ice_ptp {
 	struct ice_ptp_port port;
 	struct kthread_delayed_work work;
-	struct kthread_work extts_work;
 	u64 cached_phc_time;
 	unsigned long cached_phc_jiffies;
 	u8 ext_ts_chan;
@@ -256,6 +254,7 @@ int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena);
 int ice_get_ptp_clock_index(struct ice_pf *pf);
 
+void ice_ptp_extts_event(struct ice_pf *pf);
 s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
 bool ice_ptp_process_ts(struct ice_pf *pf);
 
@@ -284,6 +283,7 @@ static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
 	return -1;
 }
 
+static inline void ice_ptp_extts_event(struct ice_pf *pf) { }
 static inline s8
 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 {
-- 
2.38.1


