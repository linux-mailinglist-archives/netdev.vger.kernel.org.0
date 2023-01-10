Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA624664ED9
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbjAJWh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAJWhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:37:53 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22335585D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673390272; x=1704926272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+CnWg/5pMwQGcGgekucN6i4z7N4oWyr0u+8KY1rKuX4=;
  b=IPV3XK4mHWHVb3aBySmVYytS8jSJ/O1+3mG5f3LyAmjExRPp3HsYaynF
   xZlWHa9m2BsHl+hXWrgYj0rql+6/Wy514QLOic63Zh6h2AXUcaysuC5So
   Y/vQXQ4uGn7vq/4riDgLC4qrZwTRWkW+rSd0xbeMFQ+kRWj5DXfIGOHQE
   ZwvKAxETNTa1uhkfLNwm1BExW27AIdrLnVhdfJ0EIZYVxu1WgRRVHkBbw
   ZmnYkPFQ4HKyEFRx8KBoe7yD2gMRSCDCqmGiJ6ylGG/2Qn8/y/yUhquQN
   pV0FiFFtOqTxBydc93HkesKNk490TFW7RV9hOPoYtlBdoon9Wp6i13O/B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="320962805"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="320962805"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 14:37:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="650512952"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="650512952"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2023 14:37:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 2/3] igc: Fix PPS delta between two synchronized end-points
Date:   Tue, 10 Jan 2023 14:38:24 -0800
Message-Id: <20230110223825.648544-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
References: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christopher S Hall <christopher.s.hall@intel.com>

This patch fix the pulse per second output delta between
two synchronized end-points.

Based on Intel Discrete I225 Software User Manual Section
4.2.15 TimeSync Auxiliary Control Register, ST0[Bit 4] and
ST1[Bit 7] must be set to ensure that clock output will be
toggles based on frequency value defined. This is to ensure
that output of the PPS is aligned with the clock.

How to test:

1) Running time synchronization on both end points.
Ex: ptp4l --step_threshold=1 -m -f gPTP.cfg -i <interface name>

2) Configure PPS output using below command for both end-points
Ex: SDP0 on I225 REV4 SKU variant

./testptp -d /dev/ptp0 -L 0,2
./testptp -d /dev/ptp0 -p 1000000000

3) Measure the output using analyzer for both end-points

Fixes: 87938851b6ef ("igc: enable auxiliary PHC functions for the i225")
Signed-off-by: Christopher S Hall <christopher.s.hall@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 ++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index a7b22639cfcd..e9747ec5ac0b 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -475,7 +475,9 @@
 #define IGC_TSAUXC_EN_TT0	BIT(0)  /* Enable target time 0. */
 #define IGC_TSAUXC_EN_TT1	BIT(1)  /* Enable target time 1. */
 #define IGC_TSAUXC_EN_CLK0	BIT(2)  /* Enable Configurable Frequency Clock 0. */
+#define IGC_TSAUXC_ST0		BIT(4)  /* Start Clock 0 Toggle on Target Time 0. */
 #define IGC_TSAUXC_EN_CLK1	BIT(5)  /* Enable Configurable Frequency Clock 1. */
+#define IGC_TSAUXC_ST1		BIT(7)  /* Start Clock 1 Toggle on Target Time 1. */
 #define IGC_TSAUXC_EN_TS0	BIT(8)  /* Enable hardware timestamp 0. */
 #define IGC_TSAUXC_AUTT0	BIT(9)  /* Auxiliary Timestamp Taken. */
 #define IGC_TSAUXC_EN_TS1	BIT(10) /* Enable hardware timestamp 0. */
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 8dbb9f903ca7..c34734d432e0 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -322,7 +322,7 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 		ts = ns_to_timespec64(ns);
 		if (rq->perout.index == 1) {
 			if (use_freq) {
-				tsauxc_mask = IGC_TSAUXC_EN_CLK1;
+				tsauxc_mask = IGC_TSAUXC_EN_CLK1 | IGC_TSAUXC_ST1;
 				tsim_mask = 0;
 			} else {
 				tsauxc_mask = IGC_TSAUXC_EN_TT1;
@@ -333,7 +333,7 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 			freqout = IGC_FREQOUT1;
 		} else {
 			if (use_freq) {
-				tsauxc_mask = IGC_TSAUXC_EN_CLK0;
+				tsauxc_mask = IGC_TSAUXC_EN_CLK0 | IGC_TSAUXC_ST0;
 				tsim_mask = 0;
 			} else {
 				tsauxc_mask = IGC_TSAUXC_EN_TT0;
@@ -347,10 +347,12 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 		tsauxc = rd32(IGC_TSAUXC);
 		tsim = rd32(IGC_TSIM);
 		if (rq->perout.index == 1) {
-			tsauxc &= ~(IGC_TSAUXC_EN_TT1 | IGC_TSAUXC_EN_CLK1);
+			tsauxc &= ~(IGC_TSAUXC_EN_TT1 | IGC_TSAUXC_EN_CLK1 |
+				    IGC_TSAUXC_ST1);
 			tsim &= ~IGC_TSICR_TT1;
 		} else {
-			tsauxc &= ~(IGC_TSAUXC_EN_TT0 | IGC_TSAUXC_EN_CLK0);
+			tsauxc &= ~(IGC_TSAUXC_EN_TT0 | IGC_TSAUXC_EN_CLK0 |
+				    IGC_TSAUXC_ST0);
 			tsim &= ~IGC_TSICR_TT0;
 		}
 		if (on) {
-- 
2.38.1

