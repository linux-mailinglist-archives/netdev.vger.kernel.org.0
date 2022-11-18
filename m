Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC463000E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiKRW1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKRW1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:27:39 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9465D286C9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668810458; x=1700346458;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s0YjJahI5Z7E1nr0J6I986pek41Y0Dixt9s8S/I2bm8=;
  b=GbUUPo2xq7ddw8ljrGWqu03W4o0ZKugmNB59Oh8568108iAeq6Qeq7mF
   Kab/MR5rir/iixZKNrXqQnSHnGuMErslXYgD/VIQqYBBZMkZMr6SVtVWH
   z+nalDFz892yvSrzBHkZPGqJdiheAsODA+vHPcPd2J8/JPgeN8onNqEvT
   fFE5eiqoBxTx9ja+VTZPWiTNs9hFJpAUVr9nq6GIfpo35YmH07xgFhnTg
   yu+djy11U+cfWCXlpSN/ee1mGgpNYm4JdesJsb5Ziz8aI2gJa6YZCn1UV
   OrLsae9/+27K7Jbz2rEQYD4KlFQm5Dlg4cOaHzCGArxz4OOsaesQVRZVE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="310881537"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="310881537"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:27:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="703905839"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="703905839"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 18 Nov 2022 14:27:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Siddaraju DH <siddaraju.dh@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/1] ice: fix handling of burst Tx timestamps
Date:   Fri, 18 Nov 2022 14:27:29 -0800
Message-Id: <20221118222729.1565317-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Commit 1229b33973c7 ("ice: Add low latency Tx timestamp read") refactored
PTP timestamping logic to use a threaded IRQ instead of a separate kthread.

This implementation introduced ice_misc_intr_thread_fn and redefined the
ice_ptp_process_ts function interface to return a value of whether or not
the timestamp processing was complete.

ice_misc_intr_thread_fn would take the return value from ice_ptp_process_ts
and convert it into either IRQ_HANDLED if there were no more timestamps to
be processed, or IRQ_WAKE_THREAD if the thread should continue processing.

This is not correct, as the kernel does not re-schedule threaded IRQ
functions automatically. IRQ_WAKE_THREAD can only be used by the main IRQ
function.

This results in the ice_ptp_process_ts function (and in turn the
ice_ptp_tx_tstamp function) from only being called exactly once per
interrupt.

If an application sends a burst of Tx timestamps without waiting for a
response, the interrupt will trigger for the first timestamp. However,
later timestamps may not have arrived yet. This can result in dropped or
discarded timestamps. Worse, on E822 hardware this results in the interrupt
logic getting stuck such that no future interrupts will be triggered. The
result is complete loss of Tx timestamp functionality.

Fix this by modifying the ice_misc_intr_thread_fn to perform its own
polling of the ice_ptp_process_ts function. We sleep for a few microseconds
between attempts to avoid wasting significant CPU time. The value was
chosen to allow time for the Tx timestamps to complete without wasting so
much time that we overrun application wait budgets in the worst case.

The ice_ptp_process_ts function also currently returns false in the event
that the Tx tracker is not initialized. This would result in the threaded
IRQ handler never exiting if it gets started while the tracker is not
initialized.

Fix the function to appropriately return true when the tracker is not
initialized.

Note that this will not reproduce with default ptp4l behavior, as the
program always synchronously waits for a timestamp response before sending
another timestamp request.

Reported-by: Siddaraju DH <siddaraju.dh@intel.com>
Fixes: 1229b33973c7 ("ice: Add low latency Tx timestamp read")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 20 ++++++++++----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0f6718719453..ca2898467dcb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3145,15 +3145,15 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
  */
 static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 {
-	irqreturn_t ret = IRQ_HANDLED;
 	struct ice_pf *pf = data;
-	bool irq_handled;
 
-	irq_handled = ice_ptp_process_ts(pf);
-	if (!irq_handled)
-		ret = IRQ_WAKE_THREAD;
+	if (ice_is_reset_in_progress(pf->state))
+		return IRQ_HANDLED;
 
-	return ret;
+	while (!ice_ptp_process_ts(pf))
+		usleep_range(50, 100);
+
+	return IRQ_HANDLED;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 011b727ab190..0f668468d141 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -614,11 +614,14 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
  * 2) extend the 40b timestamp value to get a 64bit timestamp
  * 3) send that timestamp to the stack
  *
- * After looping, if we still have waiting SKBs, return true. This may cause us
- * effectively poll even when not strictly necessary. We do this because it's
- * possible a new timestamp was requested around the same time as the interrupt.
- * In some cases hardware might not interrupt us again when the timestamp is
- * captured.
+ * Returns true if all timestamps were handled, and false if any slots remain
+ * without a timestamp.
+ *
+ * After looping, if we still have waiting SKBs, return false. This may cause
+ * us effectively poll even when not strictly necessary. We do this because
+ * it's possible a new timestamp was requested around the same time as the
+ * interrupt. In some cases hardware might not interrupt us again when the
+ * timestamp is captured.
  *
  * Note that we only take the tracking lock when clearing the bit and when
  * checking if we need to re-queue this task. The only place where bits can be
@@ -641,7 +644,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	u8 idx;
 
 	if (!tx->init)
-		return false;
+		return true;
 
 	ptp_port = container_of(tx, struct ice_ptp_port, tx);
 	pf = ptp_port_to_pf(ptp_port);
@@ -2381,10 +2384,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
  */
 bool ice_ptp_process_ts(struct ice_pf *pf)
 {
-	if (pf->ptp.port.tx.init)
-		return ice_ptp_tx_tstamp(&pf->ptp.port.tx);
-
-	return false;
+	return ice_ptp_tx_tstamp(&pf->ptp.port.tx);
 }
 
 static void ice_ptp_periodic_work(struct kthread_work *work)
-- 
2.35.1

