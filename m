Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E71647825
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLHVkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLHVjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:39:55 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D5F2FBC2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670535584; x=1702071584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6nKLprQhzumKlHPNa+WqIPtAM0bk4GilgzQCCHqGsHI=;
  b=QmSupX/bfHzQnDYi8z8O8QluLKQhG5W2dOMqzECyhGNN8JVQzKaH8RRZ
   OhImr40FHJ/tslWe8lo9FpS8g3lIrFyG9XoFfVWGJl/bk3J7M5n4iVRgX
   ZJUOiguRNVAHnAfVGEZvUEEHCrdjwwY7zXq/cFyxgtCNadZH3IZ4gEioB
   xrEXWuVpLbYdNKs1jPPWreQhGNKiaV6YHOw6ZjIjM2xKv5tFvmqDHXtpO
   zID8cEb+uRmMTJK7MK9NhW10v28jR6FUHpT+2Bt/ZwCXtCydbR6lc2d1+
   LGjWdbfgDh/sLuqtE5HOFyi3w9FSs+3jLtjUNsZDDZmySXR8x2inaHF35
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317328227"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317328227"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:39:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="624874003"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="624874003"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 08 Dec 2022 13:39:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, saeed@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 12/14] ice: only check set bits in ice_ptp_flush_tx_tracker
Date:   Thu,  8 Dec 2022 13:39:30 -0800
Message-Id: <20221208213932.1274143-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
References: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
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

The ice_ptp_flush_tx_tracker function is called to clear all outstanding Tx
timestamp requests when the port is being brought down. This function
iterates over the entire list, but this is unnecessary. We only need to
check the bits which are actually set in the ready bitmap.

Replace this logic with for_each_set_bit, and follow a similar flow as in
ice_ptp_tx_tstamp_cleanup. Note that it is safe to call dev_kfree_skb_any
on a NULL pointer as it will perform a no-op so we do not need to verify
that the skb is actually NULL.

The new implementation also avoids clearing (and thus reading!) the PHY
timestamp unless the index is marked as having a valid timestamp in the
timestamp status bitmap. This ensures that we properly clear the status
registers as appropriate.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 38 ++++++++++++++++++------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f9cf9df334e8..c5de14abe7f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -828,28 +828,48 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
  * ice_ptp_flush_tx_tracker - Flush any remaining timestamps from the tracker
  * @pf: Board private structure
  * @tx: the tracker to flush
+ *
+ * Called during teardown when a Tx tracker is being removed.
  */
 static void
 ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
+	struct ice_hw *hw = &pf->hw;
+	u64 tstamp_ready;
+	int err;
 	u8 idx;
 
-	for (idx = 0; idx < tx->len; idx++) {
+	err = ice_get_phy_tx_tstamp_ready(hw, tx->block, &tstamp_ready);
+	if (err) {
+		dev_dbg(ice_pf_to_dev(pf), "Failed to get the Tx tstamp ready bitmap for block %u, err %d\n",
+			tx->block, err);
+
+		/* If we fail to read the Tx timestamp ready bitmap just
+		 * skip clearing the PHY timestamps.
+		 */
+		tstamp_ready = 0;
+	}
+
+	for_each_set_bit(idx, tx->in_use, tx->len) {
 		u8 phy_idx = idx + tx->offset;
+		struct sk_buff *skb;
+
+		/* In case this timestamp is ready, we need to clear it. */
+		if (!hw->reset_ongoing && (tstamp_ready & BIT_ULL(phy_idx)))
+			ice_clear_phy_tstamp(hw, tx->block, phy_idx);
 
 		spin_lock(&tx->lock);
-		if (tx->tstamps[idx].skb) {
-			dev_kfree_skb_any(tx->tstamps[idx].skb);
-			tx->tstamps[idx].skb = NULL;
-			pf->ptp.tx_hwtstamp_flushed++;
-		}
+		skb = tx->tstamps[idx].skb;
+		tx->tstamps[idx].skb = NULL;
 		clear_bit(idx, tx->in_use);
 		clear_bit(idx, tx->stale);
 		spin_unlock(&tx->lock);
 
-		/* Clear any potential residual timestamp in the PHY block */
-		if (!pf->hw.reset_ongoing)
-			ice_clear_phy_tstamp(&pf->hw, tx->block, phy_idx);
+		/* Count the number of Tx timestamps flushed */
+		pf->ptp.tx_hwtstamp_flushed++;
+
+		/* Free the SKB after we've cleared the bit */
+		dev_kfree_skb_any(skb);
 	}
 }
 
-- 
2.35.1

