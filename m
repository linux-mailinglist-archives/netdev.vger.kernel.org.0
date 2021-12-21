Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E28647C5D9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhLUSJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:9404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240917AbhLUSJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110145; x=1671646145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h/v/L6JDKPyaX6ynapkP3E+qB51G1FU4zTIUth+xpRc=;
  b=Js23NGilg+F0TH5QSCZWmPglumYMSM4iwd8anavtQ7JSjJLiNogBfL8N
   MClCkOQQWqp0RHxX+4iRl2POCBOJxxJIzL8qUmh//ItkkqCYc6xwPxZzQ
   WC74W2eyfOWFGeNqyt2fwMcbA4hlAzYt+/koC5pt+rXMkZLALubTT6KGt
   UNh35hpcGVNinWzYuxi29y5jcxrZ8EUBd79xfohl7vFqBbRtnyAcLMkGg
   SKmVgttlR0vbH6oh3u0/WA4nkiJIAEutucfHQib93rqdiCo5C5GZlo/6Z
   B5bn1xvkeIRbe9PB2H0Gbl+huJaUXhoDtlrQu3hOvVm2QXdFdhTBRJDTl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264838"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264838"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342478"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Patrick Talbert <ptalbert@redhat.com>,
        Pasi Vaananen <pvaanane@redhat.com>
Subject: [PATCH net-next 01/10] ice: Fix E810 PTP reset flow
Date:   Tue, 21 Dec 2021 09:48:36 -0800
Message-Id: <20211221174845.3063640-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

The PF reset does not reset PHC and PHY clocks so it's unnecessary to
stop them and reinitialize after the reset.
Configuring timestamping changes the VSI fields so it needs to be
performed after VSIs are initialized, which was not done in case of a
reset.

Suggested-by: Patrick Talbert <ptalbert@redhat.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Pasi Vaananen <pvaanane@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c |   8 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 192 ++++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_ptp.h  |   8 +
 3 files changed, 173 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 865f2231bb24..35dd25db81fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -539,7 +539,7 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	ice_pf_dis_all_vsi(pf, false);
 
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
-		ice_ptp_release(pf);
+		ice_ptp_prepare_for_reset(pf);
 
 	if (hw->port_info)
 		ice_sched_clear_port(hw->port_info);
@@ -6685,7 +6685,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	 * fail.
 	 */
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
-		ice_ptp_init(pf);
+		ice_ptp_reset(pf);
 
 	/* rebuild PF VSI */
 	err = ice_vsi_rebuild_by_type(pf, ICE_VSI_PF);
@@ -6694,6 +6694,10 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_vsi_rebuild;
 	}
 
+	/* configure PTP timestamping after VSI rebuild */
+	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
+		ice_ptp_cfg_timestamp(pf, false);
+
 	err = ice_vsi_rebuild_by_type(pf, ICE_VSI_SWITCHDEV_CTRL);
 	if (err) {
 		dev_err(dev, "Switchdev CTRL VSI rebuild failed: %d\n", err);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 0014a1002ed3..4d9e122837fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -313,7 +313,7 @@ static void ice_set_rx_tstamp(struct ice_pf *pf, bool on)
  * This function will configure timestamping during PTP initialization
  * and deinitialization
  */
-static void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena)
+void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena)
 {
 	ice_set_tx_tstamp(pf, ena);
 	ice_set_rx_tstamp(pf, ena);
@@ -1776,6 +1776,122 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 				   msecs_to_jiffies(500));
 }
 
+/**
+ * ice_ptp_reset - Initialize PTP hardware clock support after reset
+ * @pf: Board private structure
+ */
+void ice_ptp_reset(struct ice_pf *pf)
+{
+	struct ice_ptp *ptp = &pf->ptp;
+	struct ice_hw *hw = &pf->hw;
+	struct timespec64 ts;
+	u64 time_diff;
+	int err = 1;
+	u8 src_idx;
+
+	if (test_bit(ICE_PFR_REQ, pf->state))
+		goto pfr;
+
+	src_idx = hw->func_caps.ts_func_info.tmr_index_owned;
+
+	wr32(hw, GLTSYN_SYNC_DLAY, 0);
+
+	/* Enable source clocks */
+	wr32(hw, GLTSYN_ENA(src_idx), GLTSYN_ENA_TSYN_ENA_M);
+
+	/* Enable PHY time sync */
+	err = ice_ptp_init_phy_e810(hw);
+	if (err)
+		goto err;
+
+	/* Clear event status indications for auxiliary pins */
+	(void)rd32(hw, GLTSYN_STAT(src_idx));
+
+	/* Acquire the global hardware lock */
+	if (!ice_ptp_lock(hw)) {
+		err = -EBUSY;
+		goto err;
+	}
+
+	/* Write the increment time value to PHY and LAN */
+	err = ice_ptp_write_incval(hw, ICE_PTP_NOMINAL_INCVAL_E810);
+	if (err) {
+		ice_ptp_unlock(hw);
+		goto err;
+	}
+
+	/* Write the initial Time value to PHY and LAN using the cached PHC
+	 * time before the reset and time difference between stopping and
+	 * starting the clock.
+	 */
+	if (ptp->cached_phc_time) {
+		time_diff = ktime_get_real_ns() - ptp->reset_time;
+		ts = ns_to_timespec64(ptp->cached_phc_time + time_diff);
+	} else {
+		ts = ktime_to_timespec64(ktime_get_real());
+	}
+	err = ice_ptp_write_init(pf, &ts);
+	if (err) {
+		ice_ptp_unlock(hw);
+		goto err;
+	}
+
+	/* Release the global hardware lock */
+	ice_ptp_unlock(hw);
+
+pfr:
+	/* Init Tx structures */
+	if (ice_is_e810(&pf->hw))
+		err = ice_ptp_init_tx_e810(pf, &ptp->port.tx);
+	if (err)
+		goto err;
+
+	set_bit(ICE_FLAG_PTP, pf->flags);
+
+	/* Start periodic work going */
+	kthread_queue_delayed_work(ptp->kworker, &ptp->work, 0);
+
+	dev_info(ice_pf_to_dev(pf), "PTP reset successful\n");
+	return;
+
+err:
+	dev_err(ice_pf_to_dev(pf), "PTP reset failed %d\n", err);
+}
+
+/**
+ * ice_ptp_prepare_for_reset - Prepare PTP for reset
+ * @pf: Board private structure
+ */
+void ice_ptp_prepare_for_reset(struct ice_pf *pf)
+{
+	struct ice_ptp *ptp = &pf->ptp;
+	u8 src_tmr;
+
+	clear_bit(ICE_FLAG_PTP, pf->flags);
+
+	/* Disable timestamping for both Tx and Rx */
+	ice_ptp_cfg_timestamp(pf, false);
+
+	kthread_cancel_delayed_work_sync(&ptp->work);
+	kthread_cancel_work_sync(&ptp->extts_work);
+
+	if (test_bit(ICE_PFR_REQ, pf->state))
+		return;
+
+	ice_ptp_release_tx_tracker(pf, &pf->ptp.port.tx);
+
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
+	src_tmr = ice_get_ptp_src_clock_index(&pf->hw);
+
+	/* Disable source clock */
+	wr32(&pf->hw, GLTSYN_ENA(src_tmr), (u32)~GLTSYN_ENA_TSYN_ENA_M);
+
+	/* Acquire PHC and system timer to restore after reset */
+	ptp->reset_time = ktime_get_real_ns();
+}
+
 /**
  * ice_ptp_init_owner - Initialize PTP_1588_CLOCK device
  * @pf: Board private structure
@@ -1786,7 +1902,6 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
  */
 static int ice_ptp_init_owner(struct ice_pf *pf)
 {
-	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	struct timespec64 ts;
 	u8 src_idx;
@@ -1845,11 +1960,38 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
 err_clk:
 	pf->ptp.clock = NULL;
 err_exit:
-	dev_err(dev, "PTP failed to register clock, err %d\n", err);
-
 	return err;
 }
 
+/**
+ * ice_ptp_init_work - Initialize PTP work threads
+ * @pf: Board private structure
+ * @ptp: PF PTP structure
+ */
+static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
+{
+	struct kthread_worker *kworker;
+
+	/* Initialize work functions */
+	kthread_init_delayed_work(&ptp->work, ice_ptp_periodic_work);
+	kthread_init_work(&ptp->extts_work, ice_ptp_extts_work);
+
+	/* Allocate a kworker for handling work required for the ports
+	 * connected to the PTP hardware clock.
+	 */
+	kworker = kthread_create_worker(0, "ice-ptp-%s",
+					dev_name(ice_pf_to_dev(pf)));
+	if (IS_ERR(kworker))
+		return PTR_ERR(kworker);
+
+	ptp->kworker = kworker;
+
+	/* Start periodic work going */
+	kthread_queue_delayed_work(ptp->kworker, &ptp->work, 0);
+
+	return 0;
+}
+
 /**
  * ice_ptp_init - Initialize the PTP support after device probe or reset
  * @pf: Board private structure
@@ -1860,8 +2002,7 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
  */
 void ice_ptp_init(struct ice_pf *pf)
 {
-	struct device *dev = ice_pf_to_dev(pf);
-	struct kthread_worker *kworker;
+	struct ice_ptp *ptp = &pf->ptp;
 	struct ice_hw *hw = &pf->hw;
 	int err;
 
@@ -1873,44 +2014,29 @@ void ice_ptp_init(struct ice_pf *pf)
 	if (hw->func_caps.ts_func_info.src_tmr_owned) {
 		err = ice_ptp_init_owner(pf);
 		if (err)
-			return;
+			goto err;
 	}
 
-	/* Disable timestamping for both Tx and Rx */
-	ice_ptp_cfg_timestamp(pf, false);
-
-	/* Initialize the PTP port Tx timestamp tracker */
-	ice_ptp_init_tx_e810(pf, &pf->ptp.port.tx);
-
-	/* Initialize work functions */
-	kthread_init_delayed_work(&pf->ptp.work, ice_ptp_periodic_work);
-	kthread_init_work(&pf->ptp.extts_work, ice_ptp_extts_work);
-
-	/* Allocate a kworker for handling work required for the ports
-	 * connected to the PTP hardware clock.
-	 */
-	kworker = kthread_create_worker(0, "ice-ptp-%s", dev_name(dev));
-	if (IS_ERR(kworker)) {
-		err = PTR_ERR(kworker);
-		goto err_kworker;
-	}
-	pf->ptp.kworker = kworker;
+	err = ice_ptp_init_tx_e810(pf, &pf->ptp.port.tx);
+	if (err)
+		goto err;
 
 	set_bit(ICE_FLAG_PTP, pf->flags);
+	err = ice_ptp_init_work(pf, ptp);
+	if (err)
+		goto err;
 
-	/* Start periodic work going */
-	kthread_queue_delayed_work(pf->ptp.kworker, &pf->ptp.work, 0);
-
-	dev_info(dev, "PTP init successful\n");
+	dev_info(ice_pf_to_dev(pf), "PTP init successful\n");
 	return;
 
-err_kworker:
+err:
 	/* If we registered a PTP clock, release it */
 	if (pf->ptp.clock) {
-		ptp_clock_unregister(pf->ptp.clock);
+		ptp_clock_unregister(ptp->clock);
 		pf->ptp.clock = NULL;
 	}
-	dev_err(dev, "PTP failed %d\n", err);
+	clear_bit(ICE_FLAG_PTP, pf->flags);
+	dev_err(ice_pf_to_dev(pf), "PTP failed %d\n", err);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 53c15fc9d996..e7411d5003d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -127,6 +127,7 @@ struct ice_ptp_port {
  * @info: structure defining PTP hardware capabilities
  * @clock: pointer to registered PTP clock device
  * @tstamp_config: hardware timestamping configuration
+ * @reset_time: kernel time after clock stop on reset
  */
 struct ice_ptp {
 	struct ice_ptp_port port;
@@ -140,6 +141,7 @@ struct ice_ptp {
 	struct ptp_clock_info info;
 	struct ptp_clock *clock;
 	struct hwtstamp_config tstamp_config;
+	u64 reset_time;
 };
 
 #define __ptp_port_to_ptp(p) \
@@ -180,6 +182,7 @@ struct ice_ptp {
 struct ice_pf;
 int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr);
+void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena);
 int ice_get_ptp_clock_index(struct ice_pf *pf);
 
 s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
@@ -188,6 +191,8 @@ void ice_ptp_process_ts(struct ice_pf *pf);
 void
 ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb);
+void ice_ptp_reset(struct ice_pf *pf);
+void ice_ptp_prepare_for_reset(struct ice_pf *pf);
 void ice_ptp_init(struct ice_pf *pf);
 void ice_ptp_release(struct ice_pf *pf);
 #else /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
@@ -201,6 +206,7 @@ static inline int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 	return -EOPNOTSUPP;
 }
 
+static inline void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena) { }
 static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
 {
 	return -1;
@@ -216,6 +222,8 @@ static inline void ice_ptp_process_ts(struct ice_pf *pf) { }
 static inline void
 ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb) { }
+static inline void ice_ptp_reset(struct ice_pf *pf) { }
+static inline void ice_ptp_prepare_for_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_init(struct ice_pf *pf) { }
 static inline void ice_ptp_release(struct ice_pf *pf) { }
 #endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
-- 
2.31.1

