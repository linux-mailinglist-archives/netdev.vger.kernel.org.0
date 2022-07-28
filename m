Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9DC584590
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiG1SV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiG1SVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272B05A8B3
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032506; x=1690568506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EC1vBxIw1aMgBKjNtWeZVrvt937ohUlA5kpQBOchppA=;
  b=W3inHWSLnQCdkkB1OGpZ1eSZAmoO0R7VlijRBo9ob2YnjfRvpJfNeUAv
   Qxqt5nICTZ9IHDm5wtA9sqlSO+xuyxTh121OaeLchHLq5ZGUbPBbnQAi9
   dcfOgfKcfEoQ56i/tCHJiigHcVk8m+ojmmdMC1PsAE3Xi8Wxisvt193QL
   CFOfxipvUGPx20x6Q/Mz9/uVqzcTimk58zMclhnnbCOogT1iWk+grvxsI
   BY/G84j77p8aqADGD0WGJHzewoAHkZ435C+E1hvi9udKgIIyP7ne62Ms7
   578Ak/U57a68HElquLdIW/GhIP3WKsZVS0VmeoomV8Tw+no4rnuS6PTBV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348913"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348913"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456627"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/7] i40e: convert .adjfreq to .adjfine
Date:   Thu, 28 Jul 2022 11:18:34 -0700
Message-Id: <20220728181836.3387862-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
References: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The i40e driver currently implements the .adjfreq handler for frequency
adjustments. This takes the adjustment parameter in parts per billion. The
PTP core supports .adjfine which provides an adjustment in scaled parts per
million. This has a higher resolution and can result in more precise
adjustments for small corrections.

Convert the existing .adjfreq implementation to the newer .adjfine
implementation. This is trivial since it just requires changing the divisor
from 1000000000ULL to (1000000ULL << 16) in the mul_u64_u64_div_u64 call.

This improves the precision of the adjustments and gets us one driver
closer to removing the old .adjfreq support from the kernel.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 15de918abc41..2d3533f38d7b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -334,29 +334,31 @@ static void i40e_ptp_convert_to_hwtstamp(struct skb_shared_hwtstamps *hwtstamps,
 }
 
 /**
- * i40e_ptp_adjfreq - Adjust the PHC frequency
+ * i40e_ptp_adjfine - Adjust the PHC frequency
  * @ptp: The PTP clock structure
- * @ppb: Parts per billion adjustment from the base
+ * @scaled_ppm: Scaled parts per million adjustment from base
  *
- * Adjust the frequency of the PHC by the indicated parts per billion from the
- * base frequency.
+ * Adjust the frequency of the PHC by the indicated delta from the base
+ * frequency.
+ *
+ * Scaled parts per million is ppm with a 16 bit binary fractional field.
  **/
-static int i40e_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int i40e_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct i40e_pf *pf = container_of(ptp, struct i40e_pf, ptp_caps);
 	struct i40e_hw *hw = &pf->hw;
 	u64 adj, freq, diff;
 	int neg_adj = 0;
 
-	if (ppb < 0) {
+	if (scaled_ppm < 0) {
 		neg_adj = 1;
-		ppb = -ppb;
+		scaled_ppm = -scaled_ppm;
 	}
 
 	smp_mb(); /* Force any pending update before accessing. */
 	freq = I40E_PTP_40GB_INCVAL * READ_ONCE(pf->ptp_adj_mult);
-	diff = mul_u64_u64_div_u64(freq, (u64)ppb,
-				   1000000000ULL);
+	diff = mul_u64_u64_div_u64(freq, (u64)scaled_ppm,
+				   1000000ULL << 16);
 
 	if (neg_adj)
 		adj = I40E_PTP_40GB_INCVAL - diff;
@@ -1392,7 +1394,7 @@ static long i40e_ptp_create_clock(struct i40e_pf *pf)
 		sizeof(pf->ptp_caps.name) - 1);
 	pf->ptp_caps.owner = THIS_MODULE;
 	pf->ptp_caps.max_adj = 999999999;
-	pf->ptp_caps.adjfreq = i40e_ptp_adjfreq;
+	pf->ptp_caps.adjfine = i40e_ptp_adjfine;
 	pf->ptp_caps.adjtime = i40e_ptp_adjtime;
 	pf->ptp_caps.gettimex64 = i40e_ptp_gettimex;
 	pf->ptp_caps.settime64 = i40e_ptp_settime;
-- 
2.35.1

