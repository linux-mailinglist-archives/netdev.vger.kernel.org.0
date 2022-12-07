Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF18646307
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiLGVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLGVJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:09:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D8973F54
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447385; x=1701983385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4q5j8gIF9wXs3ok5imLOPNsghPLKRo5/pmExA4r/1p8=;
  b=PAjE5epzX3i2dRTrcWj0vZw3XhjzEedgn5Z2CaeKXAtWGmuNdcMU1mKz
   TUCs09UpaohPfj5KplpPI7IQvSqSzOaVe+IvvOeXRjW4Z2tMxwxNE9XE8
   53P762szgn9enO8oLXSztcFX3lqPSZGr05I564xqj8fE/sAWkNuLuqKYT
   Qhj7xZsDJ99YlzM6YsjZeDvRwYRLiR1ckLbAWHtjzmVK2Nlk+XCv30C7T
   yDJsFjef7XepmZTzWB1gXAafmayTdvbl3MDGXdG2c/ExEwi5onDJaElev
   GFJxl7TBFUY/6LQbfdeV8wN/a3KyiP6UIvlN5tp+vBBfJCf+g2jhNPhn8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="296697063"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="296697063"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:09:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677508831"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677508831"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2022 13:09:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 07/15] ice: check Tx timestamp memory register for ready timestamps
Date:   Wed,  7 Dec 2022 13:09:29 -0800
Message-Id: <20221207210937.1099650-8-anthony.l.nguyen@intel.com>
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

The PHY for E822 based hardware has a register which indicates which
timestamps are valid in the PHY timestamp memory block. Each bit in the
register indicates whether the associated index in the timestamp memory is
valid.

Hardware sets this bit when the timestamp is captured, and clears the bit
when the timestamp is read. Use of this register is important as reading
timestamp registers can impact the way that hardware generates timestamp
interrupts.

This occurs because the PHY has an internal value which is incremented
when hardware captures a timestamp and decremented when software reads a
timestamp. Reading timestamps which are not marked as valid still decrement
the internal value and can result in the Tx timestamp interrupt not
triggering in the future.

To prevent this, use the timestamp memory value to determine which
timestamps are ready to be read. The ice_get_phy_tx_tstamp_ready function
reads this value. For E810 devices, this just always returns with all bits
set.

Skip any timestamp which is not set in this bitmap, avoiding reading extra
timestamps on E822 devices.

The stale check against a cached timestamp value is no longer necessary for
PHYs which support the timestamp ready bitmap properly. E810 devices still
need this. Introduce a new verify_cached flag to the ice_ptp_tx structure.
Use this to determine if we need to perform the verification against the
cached timestamp value. Set this to 1 for the E810 Tx tracker init
function. Notice that many of the fields in ice_ptp_tx are simple 1 bit
flags. Save some structure space by using bitfields of length 1 for these
values.

Modify the ICE_PTP_TS_VALID check to simply drop the timestamp immediately
so that in an event of getting such an invalid timestamp the driver does
not attempt to re-read the timestamp again in a future poll of the
register.

With these changes, the driver now reads each timestamp register exactly
once, and does not attempt any re-reads. This ensures the interrupt
tracking logic in the PHY will not get stuck.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 48 ++++++++++++--
 drivers/net/ethernet/intel/ice/ice_ptp.h    | 17 +++--
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 72 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |  1 +
 4 files changed, 126 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 726579c0098c..30061598912b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -658,6 +658,9 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	struct ice_ptp_port *ptp_port;
 	bool ts_handled = true;
 	struct ice_pf *pf;
+	struct ice_hw *hw;
+	u64 tstamp_ready;
+	int err;
 	u8 idx;
 
 	if (!tx->init)
@@ -665,6 +668,12 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 
 	ptp_port = container_of(tx, struct ice_ptp_port, tx);
 	pf = ptp_port_to_pf(ptp_port);
+	hw = &pf->hw;
+
+	/* Read the Tx ready status first */
+	err = ice_get_phy_tx_tstamp_ready(hw, tx->block, &tstamp_ready);
+	if (err)
+		return false;
 
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct skb_shared_hwtstamps shhwtstamps = {};
@@ -672,7 +681,6 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		u64 raw_tstamp = 0, tstamp;
 		bool drop_ts = false;
 		struct sk_buff *skb;
-		int err;
 
 		/* Drop packets which have waited for more than 2 seconds */
 		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
@@ -680,27 +688,47 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 
 			/* Count the number of Tx timestamps that timed out */
 			pf->ptp.tx_hwtstamp_timeouts++;
+		}
 
-			goto skip_ts_read;
+		/* Only read a timestamp from the PHY if its marked as ready
+		 * by the tstamp_ready register. This avoids unnecessary
+		 * reading of timestamps which are not yet valid. This is
+		 * important as we must read all timestamps which are valid
+		 * and only timestamps which are valid during each interrupt.
+		 * If we do not, the hardware logic for generating a new
+		 * interrupt can get stuck on some devices.
+		 */
+		if (!(tstamp_ready & BIT_ULL(phy_idx))) {
+			if (drop_ts)
+				goto skip_ts_read;
+
+			continue;
 		}
 
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
-		err = ice_read_phy_tstamp(&pf->hw, tx->block, phy_idx,
-					  &raw_tstamp);
+		err = ice_read_phy_tstamp(hw, tx->block, phy_idx, &raw_tstamp);
 		if (err)
 			continue;
 
 		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
 
-		/* Check if the timestamp is invalid or stale */
-		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
+		/* For PHYs which don't implement a proper timestamp ready
+		 * bitmap, verify that the timestamp value is different
+		 * from the last cached timestamp. If it is not, skip this for
+		 * now assuming it hasn't yet been captured by hardware.
+		 */
+		if (!drop_ts && tx->verify_cached &&
 		    raw_tstamp == tx->tstamps[idx].cached_tstamp)
 			continue;
 
+		/* Discard any timestamp value without the valid bit set */
+		if (!(raw_tstamp & ICE_PTP_TS_VALID))
+			drop_ts = true;
+
 skip_ts_read:
 		spin_lock(&tx->lock);
-		if (raw_tstamp)
+		if (tx->verify_cached && raw_tstamp)
 			tx->tstamps[idx].cached_tstamp = raw_tstamp;
 		clear_bit(idx, tx->in_use);
 		skb = tx->tstamps[idx].skb;
@@ -836,6 +864,7 @@ ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 	tx->block = port / ICE_PORTS_PER_QUAD;
 	tx->offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT_E822;
 	tx->len = INDEX_PER_PORT_E822;
+	tx->verify_cached = 0;
 
 	return ice_ptp_alloc_tx_tracker(tx);
 }
@@ -854,6 +883,11 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	tx->block = pf->hw.port_info->lport;
 	tx->offset = 0;
 	tx->len = INDEX_PER_PORT_E810;
+	/* The E810 PHY does not provide a timestamp ready bitmap. Instead,
+	 * verify new timestamps against cached copy of the last read
+	 * timestamp.
+	 */
+	tx->verify_cached = 1;
 
 	return ice_ptp_alloc_tx_tracker(tx);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 39cab020f1af..5052fc41bed3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -93,9 +93,14 @@ struct ice_perout_channel {
  * we discard old requests that were not fulfilled within a 2 second time
  * window.
  * Timestamp values in the PHY are read only and do not get cleared except at
- * hardware reset or when a new timestamp value is captured. The cached_tstamp
- * field is used to detect the case where a new timestamp has not yet been
- * captured, ensuring that we avoid sending stale timestamp data to the stack.
+ * hardware reset or when a new timestamp value is captured.
+ *
+ * Some PHY types do not provide a "ready" bitmap indicating which timestamp
+ * indexes are valid. In these cases, we use a cached_tstamp to keep track of
+ * the last timestamp we read for a given index. If the current timestamp
+ * value is the same as the cached value, we assume a new timestamp hasn't
+ * been captured. This avoids reporting stale timestamps to the stack. This is
+ * only done if the verify_cached flag is set in ice_ptp_tx structure.
  */
 struct ice_tx_tstamp {
 	struct sk_buff *skb;
@@ -114,6 +119,7 @@ struct ice_tx_tstamp {
  * @init: if true, the tracker is initialized;
  * @calibrating: if true, the PHY is calibrating the Tx offset. During this
  *               window, timestamps are temporarily disabled.
+ * @verify_cached: if true, verify new timestamp differs from last read value
  */
 struct ice_ptp_tx {
 	spinlock_t lock; /* lock protecting in_use bitmap */
@@ -122,8 +128,9 @@ struct ice_ptp_tx {
 	u8 block;
 	u8 offset;
 	u8 len;
-	u8 init;
-	u8 calibrating;
+	u8 init : 1;
+	u8 calibrating : 1;
+	u8 verify_cached : 1;
 };
 
 /* Quad and port information for initializing timestamp blocks */
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 6c149b88c235..d5d51427580a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -2417,6 +2417,41 @@ int ice_phy_calc_vernier_e822(struct ice_hw *hw, u8 port)
 	return 0;
 }
 
+/**
+ * ice_get_phy_tx_tstamp_ready_e822 - Read Tx memory status register
+ * @hw: pointer to the HW struct
+ * @quad: the timestamp quad to read from
+ * @tstamp_ready: contents of the Tx memory status register
+ *
+ * Read the Q_REG_TX_MEMORY_STATUS register indicating which timestamps in
+ * the PHY are ready. A set bit means the corresponding timestamp is valid and
+ * ready to be captured from the PHY timestamp block.
+ */
+static int
+ice_get_phy_tx_tstamp_ready_e822(struct ice_hw *hw, u8 quad, u64 *tstamp_ready)
+{
+	u32 hi, lo;
+	int err;
+
+	err = ice_read_quad_reg_e822(hw, quad, Q_REG_TX_MEMORY_STATUS_U, &hi);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read TX_MEMORY_STATUS_U for quad %u, err %d\n",
+			  quad, err);
+		return err;
+	}
+
+	err = ice_read_quad_reg_e822(hw, quad, Q_REG_TX_MEMORY_STATUS_L, &lo);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read TX_MEMORY_STATUS_L for quad %u, err %d\n",
+			  quad, err);
+		return err;
+	}
+
+	*tstamp_ready = (u64)hi << 32 | (u64)lo;
+
+	return 0;
+}
+
 /* E810 functions
  *
  * The following functions operate on the E810 series devices which use
@@ -3091,6 +3126,22 @@ int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx)
 		return ice_clear_phy_tstamp_e822(hw, block, idx);
 }
 
+/**
+ * ice_get_phy_tx_tstamp_ready_e810 - Read Tx memory status register
+ * @hw: pointer to the HW struct
+ * @port: the PHY port to read
+ * @tstamp_ready: contents of the Tx memory status register
+ *
+ * E810 devices do not use a Tx memory status register. Instead simply
+ * indicate that all timestamps are currently ready.
+ */
+static int
+ice_get_phy_tx_tstamp_ready_e810(struct ice_hw *hw, u8 port, u64 *tstamp_ready)
+{
+	*tstamp_ready = 0xFFFFFFFFFFFFFFFF;
+	return 0;
+}
+
 /* E810T SMA functions
  *
  * The following functions operate specifically on E810T hardware and are used
@@ -3306,3 +3357,24 @@ int ice_ptp_init_phc(struct ice_hw *hw)
 	else
 		return ice_ptp_init_phc_e822(hw);
 }
+
+/**
+ * ice_get_phy_tx_tstamp_ready - Read PHY Tx memory status indication
+ * @hw: pointer to the HW struct
+ * @block: the timestamp block to check
+ * @tstamp_ready: storage for the PHY Tx memory status information
+ *
+ * Check the PHY for Tx timestamp memory status. This reports a 64 bit value
+ * which indicates which timestamps in the block may be captured. A set bit
+ * means the timestamp can be read. An unset bit means the timestamp is not
+ * ready and software should avoid reading the register.
+ */
+int ice_get_phy_tx_tstamp_ready(struct ice_hw *hw, u8 block, u64 *tstamp_ready)
+{
+	if (ice_is_e810(hw))
+		return ice_get_phy_tx_tstamp_ready_e810(hw, block,
+							tstamp_ready);
+	else
+		return ice_get_phy_tx_tstamp_ready_e822(hw, block,
+							tstamp_ready);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index b0cd73aaac6b..b781dadf5a39 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -135,6 +135,7 @@ int ice_read_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx, u64 *tstamp);
 int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx);
 void ice_ptp_reset_ts_memory(struct ice_hw *hw);
 int ice_ptp_init_phc(struct ice_hw *hw);
+int ice_get_phy_tx_tstamp_ready(struct ice_hw *hw, u8 block, u64 *tstamp_ready);
 
 /* E822 family functions */
 int ice_read_phy_reg_e822(struct ice_hw *hw, u8 port, u16 offset, u32 *val);
-- 
2.35.1

