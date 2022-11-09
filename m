Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3E62374A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiKIXKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiKIXJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:57 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7845F28715
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035396; x=1699571396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UvbZ6Ud4/jSwcvvgrDh9d8fdbVqGk9hFGK/aAcZ2qY4=;
  b=BgeEZ8988hR5u6nOX0+OKkp4SKoMSF2OgmCQtlHih4JqxFuGo3KgCaxB
   DBbhEyc+emUrrcQlk7HbPIMOuyklxaW6avPns+jwQfQb2f4PXfyLfgwJb
   +vlfAeJeFBBP9hkWfbTQsHH9Ep5P0n0Pc+pmeB2fi84H/PZK2WjGfYJtz
   GeLoVIWiv7DPM4V/7/WudKHJ8trtT0DDujhnz7YqxzXk0+ebnoeTuCYyy
   fby1+FZRAOdoxscRyMcnPhnz+jA8St/mJk1GLgSOttZkK9kAh5alUcQ10
   yazlHOG1qtSqoqiTS5V6s1i7eIa6kcRi9NJ6gvLGRzg/PHjoVP8SDU08m
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860531"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860531"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930557"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930557"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 6/9] ptp: cpts: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:42 -0800
Message-Id: <20221109230945.545440-7-jacob.e.keller@intel.com>
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

The cpts implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the newer .adjfine, using the recently added
adjust_by_scaled_ppm helper function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 92ca739fac01..bcccf43d368b 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -213,25 +213,13 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 
 /* PTP clock operations */
 
-static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
-	int neg_adj = 0;
-	u32 diff, mult;
-	u64 adj;
-
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-	mult = cpts->cc_mult;
-	adj = mult;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
 
 	mutex_lock(&cpts->ptp_clk_mutex);
 
-	cpts->mult_new = neg_adj ? mult - diff : mult + diff;
+	cpts->mult_new = adjust_by_scaled_ppm(cpts->cc_mult, scaled_ppm);
 
 	cpts_update_cur_time(cpts, CPTS_EV_PUSH, NULL);
 
@@ -435,7 +423,7 @@ static const struct ptp_clock_info cpts_info = {
 	.n_ext_ts	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= cpts_ptp_adjfreq,
+	.adjfine	= cpts_ptp_adjfine,
 	.adjtime	= cpts_ptp_adjtime,
 	.gettimex64	= cpts_ptp_gettimeex,
 	.settime64	= cpts_ptp_settime,
@@ -794,7 +782,7 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified
-	 * by cpts_ptp_adjfreq().
+	 * by cpts_ptp_adjfine().
 	 */
 	cpts->cc_mult = cpts->cc.mult;
 
-- 
2.38.0.83.gd420dda05763

