Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AC151AF02
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377972AbiEDU3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354822AbiEDU3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:29:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B696E4BFD0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651695955; x=1683231955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UchaR+pxr8aHHkiPopp6tyvswgeqe4MN/HrFHACDUk0=;
  b=JlOuIqMNyEw2gTeJlXYge3ORPb21ToW2aGzkrhZsUrEcy3oh4aZ8DuXc
   xZKOdXG2H1IX6osSZdi3OLsvGGYQTnqduXLF/KoGsua4fCumWsT6V25Yb
   LKAA7iQQsmPeSLCDZxRBnb2K4ZWaCcJoMfFEi/bEh1e3HZ9z2Ly6JCPFo
   Xm3uImqXnYqVP1loChxbB+sQ6mlLiSUauuX+4KO0MBwB2LVI18ZXyzgua
   akmTV8kgmfNNHze3ZuPvPmUM5oc0M8tHWRLl6g8e+oUTwb9RDDwvNSlNc
   YMzM58Q593cSQIQY1f+TOZB+E4tKktk4Vh3a28TcAw9nPbnRTE9YkpKor
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267774824"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="267774824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 13:25:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="620968708"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 May 2022 13:25:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Jacob Keller <jacob.e.keller@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 3/4] ice: fix PTP stale Tx timestamps cleanup
Date:   Wed,  4 May 2022 13:22:51 -0700
Message-Id: <20220504202252.2001471-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504202252.2001471-1-anthony.l.nguyen@intel.com>
References: <20220504202252.2001471-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Michalik <michal.michalik@intel.com>

Read stale PTP Tx timestamps from PHY on cleanup.

After running out of Tx timestamps request handlers, hardware (HW) stops
reporting finished requests. Function ice_ptp_tx_tstamp_cleanup() used
to only clean up stale handlers in driver and was leaving the hardware
registers not read. Not reading stale PTP Tx timestamps prevents next
interrupts from arriving and makes timestamping unusable.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index a1cd33273ca4..da025c204577 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2287,6 +2287,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 
 /**
  * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
+ * @hw: pointer to the hw struct
  * @tx: PTP Tx tracker to clean up
  *
  * Loop through the Tx timestamp requests and see if any of them have been
@@ -2295,7 +2296,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
  * timestamp will never be captured. This might happen if the packet gets
  * discarded before it reaches the PHY timestamping block.
  */
-static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
+static void ice_ptp_tx_tstamp_cleanup(struct ice_hw *hw, struct ice_ptp_tx *tx)
 {
 	u8 idx;
 
@@ -2304,11 +2305,16 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
 
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct sk_buff *skb;
+		u64 raw_tstamp;
 
 		/* Check if this SKB has been waiting for too long */
 		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
 			continue;
 
+		/* Read tstamp to be able to use this register again */
+		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
+				    &raw_tstamp);
+
 		spin_lock(&tx->lock);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
@@ -2330,7 +2336,7 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	ice_ptp_update_cached_phctime(pf);
 
-	ice_ptp_tx_tstamp_cleanup(&pf->ptp.port.tx);
+	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
 
 	/* Run twice a second */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
-- 
2.35.1

