Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812E659610D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiHPRYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbiHPRYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:24:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7135B54CA9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660670641; x=1692206641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Lm5ravMp9WWD4FLItt085ctcUySWmVCbtjsd8sSgAY=;
  b=UgHUj29A55816BH4VfnQUwpx0mg89NGt0igPjNEsWQZnuBkv1vWPFB6m
   pHYba7W/PRwOhpf8CI6WyEuRFj6GX/xs0wN/G3Kg81siZlPAsv32ARGmF
   FOoBTStlPeuGJ8Bgoxkd99XLSFGHb3t94vHtKM9v0cKbsosZuXv8gPRSV
   A5cppNLrvUoiE1PFdqf6fE9JASfLOcF6ASM13uMK7fnd+OuflRsNRptgl
   rSXaTf364MEUNw+Z2I968akWdsKVxbdfCfMyRvjVaFcMT3OZmBsXOfCem
   p4r0XwiRUjvKHrg9D06z+Ex+SNQpwpEW6zA0LvQ76+sM3xCpzb8EYSkir
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="318281038"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="318281038"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:23:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="610340367"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2022 10:23:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/6] ice: track Tx timestamp stats similar to other Intel drivers
Date:   Tue, 16 Aug 2022 10:23:49 -0700
Message-Id: <20220816172352.2532304-4-anthony.l.nguyen@intel.com>
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

Several Intel networking drivers which support PTP track when Tx timestamps
are skipped or when they timeout without a timestamp from hardware. The
conditions which could cause these events are rare, but it can be useful to
know when and how often they occur.

Implement similar statistics for the ice driver, tx_hwtstamp_skipped,
tx_hwtstamp_timeouts, and tx_hwtstamp_flushed.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  3 +++
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 11 ++++++++---
 drivers/net/ethernet/intel/ice/ice_ptp.h     |  6 ++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c    |  4 +++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 3a18762cc38f..94498457cb2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -136,6 +136,9 @@ static const struct ice_stats ice_gstrings_pf_stats[] = {
 	ICE_PF_STAT("mac_remote_faults.nic", stats.mac_remote_faults),
 	ICE_PF_STAT("fdir_sb_match.nic", stats.fd_sb_match),
 	ICE_PF_STAT("fdir_sb_status.nic", stats.fd_sb_status),
+	ICE_PF_STAT("tx_hwtstamp_skipped", ptp.tx_hwtstamp_skipped),
+	ICE_PF_STAT("tx_hwtstamp_timeouts", ptp.tx_hwtstamp_timeouts),
+	ICE_PF_STAT("tx_hwtstamp_flushed", ptp.tx_hwtstamp_flushed),
 };
 
 static const u32 ice_regs_dump_list[] = {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 72b663108a4a..c1758f7bd091 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2219,6 +2219,7 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 		if (tx->tstamps[idx].skb) {
 			dev_kfree_skb_any(tx->tstamps[idx].skb);
 			tx->tstamps[idx].skb = NULL;
+			pf->ptp.tx_hwtstamp_flushed++;
 		}
 		clear_bit(idx, tx->in_use);
 		spin_unlock(&tx->lock);
@@ -2295,7 +2296,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 
 /**
  * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
- * @hw: pointer to the hw struct
+ * @pf: pointer to the PF struct
  * @tx: PTP Tx tracker to clean up
  *
  * Loop through the Tx timestamp requests and see if any of them have been
@@ -2304,8 +2305,9 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
  * timestamp will never be captured. This might happen if the packet gets
  * discarded before it reaches the PHY timestamping block.
  */
-static void ice_ptp_tx_tstamp_cleanup(struct ice_hw *hw, struct ice_ptp_tx *tx)
+static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
+	struct ice_hw *hw = &pf->hw;
 	u8 idx;
 
 	if (!tx->init)
@@ -2329,6 +2331,9 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_hw *hw, struct ice_ptp_tx *tx)
 		clear_bit(idx, tx->in_use);
 		spin_unlock(&tx->lock);
 
+		/* Count the number of Tx timestamps which have timed out */
+		pf->ptp.tx_hwtstamp_timeouts++;
+
 		/* Free the SKB after we've cleared the bit */
 		dev_kfree_skb_any(skb);
 	}
@@ -2345,7 +2350,7 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	err = ice_ptp_update_cached_phctime(pf);
 
-	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
+	ice_ptp_tx_tstamp_cleanup(pf, &pf->ptp.port.tx);
 
 	/* Run twice a second or reschedule if phc update failed */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 10e396abf130..2e2245f5c690 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -171,6 +171,9 @@ struct ice_ptp_port {
  * @clock: pointer to registered PTP clock device
  * @tstamp_config: hardware timestamping configuration
  * @reset_time: kernel time after clock stop on reset
+ * @tx_hwtstamp_skipped: number of Tx time stamp requests skipped
+ * @tx_hwtstamp_timeouts: number of Tx skbs discarded with no time stamp
+ * @tx_hwtstamp_flushed: number of Tx skbs flushed due to interface closed
  */
 struct ice_ptp {
 	struct ice_ptp_port port;
@@ -185,6 +188,9 @@ struct ice_ptp {
 	struct ptp_clock *clock;
 	struct hwtstamp_config tstamp_config;
 	u64 reset_time;
+	u32 tx_hwtstamp_skipped;
+	u32 tx_hwtstamp_timeouts;
+	u32 tx_hwtstamp_flushed;
 };
 
 #define __ptp_port_to_ptp(p) \
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 836dce840712..42b42f4b21ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2255,8 +2255,10 @@ ice_tstamp(struct ice_tx_ring *tx_ring, struct sk_buff *skb,
 
 	/* Grab an open timestamp slot */
 	idx = ice_ptp_request_ts(tx_ring->tx_tstamps, skb);
-	if (idx < 0)
+	if (idx < 0) {
+		tx_ring->vsi->back->ptp.tx_hwtstamp_skipped++;
 		return;
+	}
 
 	off->cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
 			     (ICE_TX_CTX_DESC_TSYN << ICE_TXD_CTX_QW1_CMD_S) |
-- 
2.35.1

