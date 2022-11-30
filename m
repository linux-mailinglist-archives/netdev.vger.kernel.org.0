Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7949F63E0EC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiK3ToC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiK3Tnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:45 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79A494909
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837424; x=1701373424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7WfjUAYlxVuj/oimYQ5PQ6wzzmUD7sPlYnhf7UNdZ+k=;
  b=BUJg8FWA1VlOVnEtug3G0mdU9hXaWlJ+aqXOzKHqAlkCT6ovbp9az8hg
   LyuFSBGeO/4L9RtgG7CCwzoD7koWw8eK5+EkcyAsUkAeN4DivM0dQr+jp
   o5MX9Iw+PDoWJiibgSow+n9Kc1v79XC0fCemnlTI9PKDi+saOZU+cXtN1
   7xse2zmq78l0HfPZn2zrc7e2znepVsRAjxpSro9aEMlO7atKsT/QgGiZM
   krQOYp0RE+qbJk6cqWu3PDdTSgzm1VSLCo/WVNKMGOc2cMwhrDIDx1Y/q
   X1g9D1bx39zdAVmO/GuZ5+uyXNvlwXQy/5wVXZR+x3jOYh55VDY+VLzmf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098400"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098400"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752296"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752296"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 08/14] ice: protect init and calibrating fields with spinlock
Date:   Wed, 30 Nov 2022 11:43:24 -0800
Message-Id: <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
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

Ensure that the init and calibrating fields of the PTP Tx timestamp tracker
structure are only modified under the spin lock. This ensures that the
accesses are consistent and that new timestamp requests will either begin
completely or get ignored.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 55 ++++++++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index a7d950dd1264..0e39fed7cfca 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -599,6 +599,42 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 				     (in_tstamp >> 8) & mask);
 }
 
+/**
+ * ice_ptp_is_tx_tracker_init - Check if the Tx tracker is initialized
+ * @tx: the PTP Tx timestamp tracker to check
+ *
+ * Check that a given PTP Tx timestamp tracker is initialized. Acquires the
+ * tx->lock spinlock.
+ */
+static bool
+ice_ptp_is_tx_tracker_init(struct ice_ptp_tx *tx)
+{
+	bool init;
+
+	spin_lock(&tx->lock);
+	init = tx->init;
+	spin_unlock(&tx->lock);
+
+	return init;
+}
+
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
@@ -663,7 +699,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	int err;
 	u8 idx;
 
-	if (!tx->init)
+	if (!ice_ptp_is_tx_tracker_init(tx))
 		return true;
 
 	ptp_port = container_of(tx, struct ice_ptp_port, tx);
@@ -791,7 +827,9 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 
 	spin_lock_init(&tx->lock);
 
+	spin_lock(&tx->lock);
 	tx->init = 1;
+	spin_unlock(&tx->lock);
 
 	return 0;
 }
@@ -834,7 +872,9 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 static void
 ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
+	spin_lock(&tx->lock);
 	tx->init = 0;
+	spin_unlock(&tx->lock);
 
 	ice_ptp_flush_tx_tracker(pf, tx);
 
@@ -1325,7 +1365,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 	kthread_cancel_delayed_work_sync(&ptp_port->ov_work);
 
 	/* temporarily disable Tx timestamps while calibrating PHY offset */
+	spin_lock(&ptp_port->tx.lock);
 	ptp_port->tx.calibrating = true;
+	spin_unlock(&ptp_port->tx.lock);
 	ptp_port->tx_fifo_busy_cnt = 0;
 
 	/* Start the PHY timer in Vernier mode */
@@ -1334,7 +1376,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 		goto out_unlock;
 
 	/* Enable Tx timestamps right away */
+	spin_lock(&ptp_port->tx.lock);
 	ptp_port->tx.calibrating = false;
+	spin_unlock(&ptp_port->tx.lock);
 
 	kthread_queue_delayed_work(pf->ptp.kworker, &ptp_port->ov_work, 0);
 
@@ -2328,11 +2372,14 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
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

