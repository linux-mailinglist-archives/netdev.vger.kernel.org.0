Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA06596107
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiHPRYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiHPRYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:24:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FD7550A0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660670641; x=1692206641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lYWMd0jV+6BukAK7SDbtnrIVYJwbKlpM1kc8nZZfOWQ=;
  b=JlqRwj13N8sIOffcyPIBCzt3KjnFI0t+eTxzqQV6E6xiSwtCwaVTwBr6
   ClxnB4OpZut3UJ/EkJtujqdSMprbPiIjp20XIhN0HV08kkjGjz+j3ZeGO
   4qvMta6FDMmIHPUOpMH5U/fIVPN0ysEw0Ss7Kj3m0sToStSG36gkqO4nx
   Yp+mlLZWcDxyHOSjoP2B8mj9UscAD7fJghPfHd6u2PdhcW8F0tJIvcFPb
   XkmLAYOz9Crdk+dcVMsTPGI2ZS1XgHPOOu/43fNDUuHx9WfMnGeSgeK2c
   WreLsi/A8zYujJvg3J8OeY18Ku4dGIe/+rIybXF1Gv0S937SA/7AewIeP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="318281040"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="318281040"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:24:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="610340371"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2022 10:23:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/6] ice: track and warn when PHC update is late
Date:   Tue, 16 Aug 2022 10:23:50 -0700
Message-Id: <20220816172352.2532304-5-anthony.l.nguyen@intel.com>
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

The ice driver requires a cached copy of the PHC time in order to perform
timestamp extension on Tx and Rx hardware timestamp values. This cached PHC
time must always be updated at least once every 2 seconds. Otherwise, the
math used to perform the extension would produce invalid results.

The updates are supposed to occur periodically in the PTP kthread work
item, which is scheduled to run every half second. Thus, we do not expect
an update to be delayed for so long. However, there are error conditions
which can cause the update to be delayed.

Track this situation by using jiffies to determine approximately how long
ago the last update occurred. Add a new statistic and a dev_warn when we
have failed to update the cached PHC time. This makes the error case more
obvious.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  2 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 28 +++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_ptp.h     |  7 +++++
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 94498457cb2e..0f0faa8dc7fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -139,6 +139,8 @@ static const struct ice_stats ice_gstrings_pf_stats[] = {
 	ICE_PF_STAT("tx_hwtstamp_skipped", ptp.tx_hwtstamp_skipped),
 	ICE_PF_STAT("tx_hwtstamp_timeouts", ptp.tx_hwtstamp_timeouts),
 	ICE_PF_STAT("tx_hwtstamp_flushed", ptp.tx_hwtstamp_flushed),
+	ICE_PF_STAT("tx_hwtstamp_discarded", ptp.tx_hwtstamp_discarded),
+	ICE_PF_STAT("late_cached_phc_updates", ptp.late_cached_phc_updates),
 };
 
 static const u32 ice_regs_dump_list[] = {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index c1758f7bd091..10352eca2ecd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -507,17 +507,30 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
  */
 static int ice_ptp_update_cached_phctime(struct ice_pf *pf)
 {
+	struct device *dev = ice_pf_to_dev(pf);
+	unsigned long update_before;
 	u64 systime;
 	int i;
 
 	if (test_and_set_bit(ICE_CFG_BUSY, pf->state))
 		return -EAGAIN;
 
+	update_before = pf->ptp.cached_phc_jiffies + msecs_to_jiffies(2000);
+	if (pf->ptp.cached_phc_time &&
+	    time_is_before_jiffies(update_before)) {
+		unsigned long time_taken = jiffies - pf->ptp.cached_phc_jiffies;
+
+		dev_warn(dev, "%u msecs passed between update to cached PHC time\n",
+			 jiffies_to_msecs(time_taken));
+		pf->ptp.late_cached_phc_updates++;
+	}
+
 	/* Read the current PHC time */
 	systime = ice_ptp_read_src_clk_reg(pf, NULL);
 
 	/* Update the cached PHC time stored in the PF structure */
 	WRITE_ONCE(pf->ptp.cached_phc_time, systime);
+	WRITE_ONCE(pf->ptp.cached_phc_jiffies, jiffies);
 
 	ice_for_each_vsi(pf, i) {
 		struct ice_vsi *vsi = pf->vsi[i];
@@ -636,6 +649,14 @@ static u64 ice_ptp_extend_32b_ts(u64 cached_phc_time, u32 in_tstamp)
 static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 {
 	const u64 mask = GENMASK_ULL(31, 0);
+	unsigned long discard_time;
+
+	/* Discard the hardware timestamp if the cached PHC time is too old */
+	discard_time = pf->ptp.cached_phc_jiffies + msecs_to_jiffies(2000);
+	if (time_is_before_jiffies(discard_time)) {
+		pf->ptp.tx_hwtstamp_discarded++;
+		return 0;
+	}
 
 	return ice_ptp_extend_32b_ts(pf->ptp.cached_phc_time,
 				     (in_tstamp >> 8) & mask);
@@ -2104,9 +2125,10 @@ static void ice_ptp_tx_tstamp_work(struct kthread_work *work)
 
 		/* Extend the timestamp using cached PHC time */
 		tstamp = ice_ptp_extend_40b_ts(pf, raw_tstamp);
-		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
-
-		ice_trace(tx_tstamp_complete, skb, idx);
+		if (tstamp) {
+			shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
+			ice_trace(tx_tstamp_complete, skb, idx);
+		}
 
 		skb_tstamp_tx(skb, &shhwtstamps);
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 2e2245f5c690..d53dcd03e36b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -163,6 +163,7 @@ struct ice_ptp_port {
  * @work: delayed work function for periodic tasks
  * @extts_work: work function for handling external Tx timestamps
  * @cached_phc_time: a cached copy of the PHC time for timestamp extension
+ * @cached_phc_jiffies: jiffies when cached_phc_time was last updated
  * @ext_ts_chan: the external timestamp channel in use
  * @ext_ts_irq: the external timestamp IRQ in use
  * @kworker: kwork thread for handling periodic work
@@ -174,12 +175,16 @@ struct ice_ptp_port {
  * @tx_hwtstamp_skipped: number of Tx time stamp requests skipped
  * @tx_hwtstamp_timeouts: number of Tx skbs discarded with no time stamp
  * @tx_hwtstamp_flushed: number of Tx skbs flushed due to interface closed
+ * @tx_hwtstamp_discarded: number of Tx skbs discarded due to cached PHC time
+ *                         being too old to correctly extend timestamp
+ * @late_cached_phc_updates: number of times cached PHC update is late
  */
 struct ice_ptp {
 	struct ice_ptp_port port;
 	struct kthread_delayed_work work;
 	struct kthread_work extts_work;
 	u64 cached_phc_time;
+	unsigned long cached_phc_jiffies;
 	u8 ext_ts_chan;
 	u8 ext_ts_irq;
 	struct kthread_worker *kworker;
@@ -191,6 +196,8 @@ struct ice_ptp {
 	u32 tx_hwtstamp_skipped;
 	u32 tx_hwtstamp_timeouts;
 	u32 tx_hwtstamp_flushed;
+	u32 tx_hwtstamp_discarded;
+	u32 late_cached_phc_updates;
 };
 
 #define __ptp_port_to_ptp(p) \
-- 
2.35.1

