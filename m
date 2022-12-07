Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ED7646308
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLGVKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiLGVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:48 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D02B73F58
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447386; x=1701983386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XLJc2T5qOnj7SAeTSiXuOSj+xHPd5u4q3zv+1tBzywE=;
  b=LWJe/OWxueQmKsy/lSlVAfoqdKcnrD8h925UCJpB/13zFdCLfhmPoO0n
   kBlzGDRC692LR9DH0ehc82a98KE95sVSKGGjPxNOc+OwewVpg9QR3p/oD
   lrVCiMo7y4Znkk2QkV3Ql2UnbOeZn5WF9/nacwibaJflQ9O/miqMEbLaJ
   pijxIFKtSiAqonXQCdoGSHtUq7X9lxRQJr8kStb2ytTNvEgNnU4vrv2wU
   nQ32+pRzqCmJ71pCMK1kPR/81vl4hb+IahmrmDdZ5AbX0F3A5cMPmGAMe
   hnSHyu14/MgR9ORBYBqMfXjRGagiZmOZb/VrKRSsM9FgBC2H0UpfRaH/k
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697076"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697076"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508840"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508840"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 09/15] ice: protect init and calibrating check in ice_ptp_request_ts
Date:   Wed,  7 Dec 2022 13:09:31 -0800
Message-Id: <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
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

When requesting a new timestamp, the ice_ptp_request_ts function does not
hold the Tx tracker lock while checking init and calibrating. This means
that we might issue a new timestamp request just after the Tx timestamp
tracker starts being deinitialized. This could lead to incorrect access of
the timestamp structures. Correct this by moving the init and calibrating
checks under the lock, and updating the flows which modify these fields to
use the lock.

Note that we do not need to hold the lock while checking for tx->init in
ice_ptp_tstamp_tx. This is because the teardown function will use
synchronize_irq after clearing the flag to ensure that the threaded
interrupt completes. Either a) the tx->init flag will be cleared before the
ice_ptp_tx_tstamp function starts, thus it will exit immediately, or b) the
threaded interrupt will be executing and the synchronize_irq will wait
until the threaded interrupt has completed at which point we know the init
field has definitely been set and new interrupts will not execute the Tx
timestamp thread function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 36 ++++++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 0282ccc55819..481492d84e0e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -599,6 +599,23 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 				     (in_tstamp >> 8) & mask);
 }
 
+/**
+ * ice_ptp_is_tx_tracker_up - Check if Tx tracker is ready for new timestamps
+ * @tx: the PTP Tx timestamp tracker to check
+ *
+ * Check that a given PTP Tx timestamp tracker is up, i.e. that it is ready
+ * to accept new timestamp requests.
+ *
+ * Assumes the tx->lock spinlock is already held.
+ */
+static bool
+ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
+{
+	lockdep_assert_held(&tx->lock);
+
+	return tx->init && !tx->calibrating;
+}
+
 /**
  * ice_ptp_tx_tstamp - Process Tx timestamps for a port
  * @tx: the PTP Tx timestamp tracker
@@ -788,10 +805,10 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 		return -ENOMEM;
 	}
 
-	spin_lock_init(&tx->lock);
-
 	tx->init = 1;
 
+	spin_lock_init(&tx->lock);
+
 	return 0;
 }
 
@@ -833,7 +850,9 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 static void
 ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
+	spin_lock(&tx->lock);
 	tx->init = 0;
+	spin_unlock(&tx->lock);
 
 	/* wait for potentially outstanding interrupt to complete */
 	synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
@@ -1327,7 +1346,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 	kthread_cancel_delayed_work_sync(&ptp_port->ov_work);
 
 	/* temporarily disable Tx timestamps while calibrating PHY offset */
+	spin_lock(&ptp_port->tx.lock);
 	ptp_port->tx.calibrating = true;
+	spin_unlock(&ptp_port->tx.lock);
 	ptp_port->tx_fifo_busy_cnt = 0;
 
 	/* Start the PHY timer in Vernier mode */
@@ -1336,7 +1357,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 		goto out_unlock;
 
 	/* Enable Tx timestamps right away */
+	spin_lock(&ptp_port->tx.lock);
 	ptp_port->tx.calibrating = false;
+	spin_unlock(&ptp_port->tx.lock);
 
 	kthread_queue_delayed_work(pf->ptp.kworker, &ptp_port->ov_work, 0);
 
@@ -2330,11 +2353,14 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 {
 	u8 idx;
 
-	/* Check if this tracker is initialized */
-	if (!tx->init || tx->calibrating)
+	spin_lock(&tx->lock);
+
+	/* Check that this tracker is accepting new timestamp requests */
+	if (!ice_ptp_is_tx_tracker_up(tx)) {
+		spin_unlock(&tx->lock);
 		return -1;
+	}
 
-	spin_lock(&tx->lock);
 	/* Find and set the first available index */
 	idx = find_first_zero_bit(tx->in_use, tx->len);
 	if (idx < tx->len) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 5052fc41bed3..0bfafaaab6c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -110,7 +110,7 @@ struct ice_tx_tstamp {
 
 /**
  * struct ice_ptp_tx - Tracking structure for all Tx timestamp requests on a port
- * @lock: lock to prevent concurrent write to in_use bitmap
+ * @lock: lock to prevent concurrent access to fields of this struct
  * @tstamps: array of len to store outstanding requests
  * @in_use: bitmap of len to indicate which slots are in use
  * @block: which memory block (quad or port) the timestamps are captured in
-- 
2.35.1

