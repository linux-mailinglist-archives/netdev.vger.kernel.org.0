Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6AC623745
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiKIXKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiKIXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5A8647D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035395; x=1699571395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z78p2vv+3X5SoWl+Nu5vNhZJ4qt7rft+H5qonFEKf/k=;
  b=WLkZnmsL1cBfJGgQOPO4THw5g3a22LtGR8+8T3kVza5ZgRtcAChFxTR1
   IG7vPm3triH6NzjbjIw/GdHalGiwxrqB3CwkLgEaRvOa5fWevB82irqJn
   rmc631drctiag/u5AOn/ik0FYGFpwjHd+D3Esl76gXcmG5gKvFtbom/1u
   P+6kgMTRROTh3XrWVymdP3PnhY5ojjjkv59kUQ6/mQuMxgni/22XW+UQX
   e/9z1MQ1jISSs7C7DfXASntq0B96CC0R3Wowue+NKqgC35ZWOE11w9X8x
   TprSW9O30B5mUYn0ad3x62kLvXwcVUinDNzPJkbZJEmCoBJ89AVSMDjqk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860525"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860525"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930548"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930548"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Subject: [PATCH net-next 3/9] ptp: tg3: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:39 -0800
Message-Id: <20221109230945.545440-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221109230945.545440-1-jacob.e.keller@intel.com>
References: <20221109230945.545440-1-jacob.e.keller@intel.com>
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

The tg3 implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the newer .adjfine, using the recently added
diff_by_scaled_ppm helper function to calculate the difference and
direction of the adjustment.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 4179a12fc881..59debdc344a5 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6179,34 +6179,26 @@ static int tg3_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	return 0;
 }
 
-static int tg3_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int tg3_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct tg3 *tp = container_of(ptp, struct tg3, ptp_info);
-	bool neg_adj = false;
-	u32 correction = 0;
-
-	if (ppb < 0) {
-		neg_adj = true;
-		ppb = -ppb;
-	}
+	u64 correction;
+	bool neg_adj;
 
 	/* Frequency adjustment is performed using hardware with a 24 bit
 	 * accumulator and a programmable correction value. On each clk, the
 	 * correction value gets added to the accumulator and when it
 	 * overflows, the time counter is incremented/decremented.
-	 *
-	 * So conversion from ppb to correction value is
-	 *		ppb * (1 << 24) / 1000000000
 	 */
-	correction = div_u64((u64)ppb * (1 << 24), 1000000000ULL) &
-		     TG3_EAV_REF_CLK_CORRECT_MASK;
+	neg_adj = diff_by_scaled_ppm(1 << 24, scaled_ppm, &correction);
 
 	tg3_full_lock(tp, 0);
 
 	if (correction)
 		tw32(TG3_EAV_REF_CLK_CORRECT_CTL,
 		     TG3_EAV_REF_CLK_CORRECT_EN |
-		     (neg_adj ? TG3_EAV_REF_CLK_CORRECT_NEG : 0) | correction);
+		     (neg_adj ? TG3_EAV_REF_CLK_CORRECT_NEG : 0) |
+		     ((u32)correction & TG3_EAV_REF_CLK_CORRECT_MASK));
 	else
 		tw32(TG3_EAV_REF_CLK_CORRECT_CTL, 0);
 
@@ -6330,7 +6322,7 @@ static const struct ptp_clock_info tg3_ptp_caps = {
 	.n_per_out	= 1,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= tg3_ptp_adjfreq,
+	.adjfine	= tg3_ptp_adjfine,
 	.adjtime	= tg3_ptp_adjtime,
 	.gettimex64	= tg3_ptp_gettimex,
 	.settime64	= tg3_ptp_settime,
-- 
2.38.0.83.gd420dda05763

