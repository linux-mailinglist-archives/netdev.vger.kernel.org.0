Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2E5845CA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiG1SV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiG1SVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9485B048
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032506; x=1690568506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r5S+J4sMKKLYfq/oImHWuvRZnW3GIjL27JN4el4wh7o=;
  b=O0gPK3qlcens5vJ5P9PmxJzftiB5PouocbcmpGht5enS7832g7l0yFSL
   GGhPPrjGc2Z9Ldr3RIIGXjSQk2YdtCJuten9K1Ue+676CNhaQI3nE3yyo
   HmmZoZ2K7/2tOY6wvzGQU2mlLeaWMd1im9VFHyTu6Jgq5FZLylYhntsnj
   /Rrd6DuUz51fb3HLVt9/iSJEDAneXTzbbxls5uLW+mL9340Bn7LgE5R43
   0rEr0oGIQf+Z8JRchdI3k9xm6gQEkR7qJtlpBLloevwYAHu4eYPuO2ok4
   Y3aid2nIsEAuooL/iHkzO3E55OD2jhmhqo2YbMJsG0Buoz3cjS3qqRB9r
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348917"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348917"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456635"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 7/7] igb: convert .adjfreq to .adjfine
Date:   Thu, 28 Jul 2022 11:18:36 -0700
Message-Id: <20220728181836.3387862-8-anthony.l.nguyen@intel.com>
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

The 82576 PTP implementation still uses .adjfreq instead of using the newer
.adjfine.

This implementation uses a pre-simplified calculation since the base
increment value for the 82576 is just 16 * 2^19. Converting this into
scaled_ppm is tricky, and makes the intent a bit less clear.

Simply convert to the normal flow of multiplying the base increment value
by the scaled_ppm and then dividing by 1000000ULL << 16. This can be
implemented using mul_u64_u64_div_u64 which can avoid the possible overflow
that might occur for large adjustments.

Use of .adjfine can improve the precision of small adjustments and gets us
one driver closer to removing the old implementation from the kernel
entirely.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 02fec948ce64..15e57460e19e 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -190,7 +190,7 @@ static void igb_ptp_systim_to_hwtstamp(struct igb_adapter *adapter,
 }
 
 /* PTP clock operations */
-static int igb_ptp_adjfreq_82576(struct ptp_clock_info *ptp, s32 ppb)
+static int igb_ptp_adjfine_82576(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct igb_adapter *igb = container_of(ptp, struct igb_adapter,
 					       ptp_caps);
@@ -199,15 +199,14 @@ static int igb_ptp_adjfreq_82576(struct ptp_clock_info *ptp, s32 ppb)
 	u64 rate;
 	u32 incvalue;
 
-	if (ppb < 0) {
+	if (scaled_ppm < 0) {
 		neg_adj = 1;
-		ppb = -ppb;
+		scaled_ppm = -scaled_ppm;
 	}
-	rate = ppb;
-	rate <<= 14;
-	rate = div_u64(rate, 1953125);
 
-	incvalue = 16 << IGB_82576_TSYNC_SHIFT;
+	incvalue = INCVALUE_82576;
+	rate = mul_u64_u64_div_u64(incvalue, (u64)scaled_ppm,
+				   1000000ULL << 16);
 
 	if (neg_adj)
 		incvalue -= rate;
@@ -1347,7 +1346,7 @@ void igb_ptp_init(struct igb_adapter *adapter)
 		adapter->ptp_caps.max_adj = 999999881;
 		adapter->ptp_caps.n_ext_ts = 0;
 		adapter->ptp_caps.pps = 0;
-		adapter->ptp_caps.adjfreq = igb_ptp_adjfreq_82576;
+		adapter->ptp_caps.adjfine = igb_ptp_adjfine_82576;
 		adapter->ptp_caps.adjtime = igb_ptp_adjtime_82576;
 		adapter->ptp_caps.gettimex64 = igb_ptp_gettimex_82576;
 		adapter->ptp_caps.settime64 = igb_ptp_settime_82576;
-- 
2.35.1

