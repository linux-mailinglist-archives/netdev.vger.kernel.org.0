Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D105845BE
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiG1SV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiG1SVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842AC5B04A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032506; x=1690568506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aPygiN/ynTeH9RKFMfk0NTGLVRG2NKRJlxbUQ2bA+pk=;
  b=XwyunQaGm17uBAWr7xox2q3gHi4FI94iqr45QjApyEoPU6BjCT/X56V+
   tldYTfrWSWbQIQdauW80+G47A8yPhgwBYzWCa6dMBDcwETxA5RV7yoH3j
   2VoQzpaRgs8nAC1Dz4c2ap1pemYKq+hEZWgweWKWLnbiODENNrzuEd0e8
   ef2wTgHyMSUgZXwdAf+9B2T65H3zOD6XrXzVWmIbJHOerPrRjgWSFSar6
   z4/4l8AXuY+ZcPrCaUcOnkGAhs3aRswIAH6rReOgA79zXkuPzMGzBY7yO
   Affp6fJu37z1/SooVpFeqv7Ezd7VfnJ4llJvfwkQLs2VSQK3Ur4H83Kic
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348915"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348915"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456630"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 6/7] ixgbe: convert .adjfreq to .adjfine
Date:   Thu, 28 Jul 2022 11:18:35 -0700
Message-Id: <20220728181836.3387862-7-anthony.l.nguyen@intel.com>
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

Convert the ixgbe PTP frequency adjustment implementations from .adjfreq to
.adjfine. This allows using the scaled parts per million adjustment from
the PTP core and results in a more precise adjustment for small
corrections.

To avoid overflow, use mul_u64_u64_div_u64 to perform the calculation. On
X86 platforms, this will use instructions that perform the operations with
128bit intermediate values. For other architectures, the implementation
will limit the loss of precision as much as possible.

This change slightly improves the precision of frequency adjustments for
all ixgbe based devices, and gets us one driver closer to being able to
remove the older .adjfreq implementation from the kernel.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 73 +++++++++++---------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 27a71fa26d3c..9f06896a049b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -113,12 +113,16 @@
  * the sign bit. This register enables software to calculate frequency
  * adjustments and apply them directly to the clock rate.
  *
- * The math for converting ppb into TIMINCA values is fairly straightforward.
- *   TIMINCA value = ( Base_Frequency * ppb ) / 1000000000ULL
+ * The math for converting scaled_ppm into TIMINCA values is fairly
+ * straightforward.
  *
- * This assumes that ppb is never high enough to create a value bigger than
- * TIMINCA's 31 bits can store. This is ensured by the stack. Calculating this
- * value is also simple.
+ *   TIMINCA value = ( Base_Frequency * scaled_ppm ) / 1000000ULL << 16
+ *
+ * To avoid overflow, we simply use mul_u64_u64_div_u64.
+ *
+ * This assumes that scaled_ppm is never high enough to create a value bigger
+ * than TIMINCA's 31 bits can store. This is ensured by the stack, and is
+ * measured in parts per billion. Calculating this value is also simple.
  *   Max ppb = ( Max Adjustment / Base Frequency ) / 1000000000ULL
  *
  * For the X550, the Max adjustment is +/- 0.5 ns, and the base frequency is
@@ -433,45 +437,45 @@ static void ixgbe_ptp_convert_to_hwtstamp(struct ixgbe_adapter *adapter,
 }
 
 /**
- * ixgbe_ptp_adjfreq_82599
+ * ixgbe_ptp_adjfine_82599
  * @ptp: the ptp clock structure
- * @ppb: parts per billion adjustment from base
+ * @scaled_ppm: scaled parts per million adjustment from base
+ *
+ * Adjust the frequency of the ptp cycle counter by the
+ * indicated scaled_ppm from the base frequency.
  *
- * adjust the frequency of the ptp cycle counter by the
- * indicated ppb from the base frequency.
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int ixgbe_ptp_adjfreq_82599(struct ptp_clock_info *ptp, s32 ppb)
+static int ixgbe_ptp_adjfine_82599(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ixgbe_adapter *adapter =
 		container_of(ptp, struct ixgbe_adapter, ptp_caps);
 	struct ixgbe_hw *hw = &adapter->hw;
-	u64 freq, incval;
-	u32 diff;
+	u64 incval, diff;
 	int neg_adj = 0;
 
-	if (ppb < 0) {
+	if (scaled_ppm < 0) {
 		neg_adj = 1;
-		ppb = -ppb;
+		scaled_ppm = -scaled_ppm;
 	}
 
 	smp_mb();
 	incval = READ_ONCE(adapter->base_incval);
 
-	freq = incval;
-	freq *= ppb;
-	diff = div_u64(freq, 1000000000ULL);
+	diff = mul_u64_u64_div_u64(incval, scaled_ppm,
+				   1000000ULL << 16);
 
 	incval = neg_adj ? (incval - diff) : (incval + diff);
 
 	switch (hw->mac.type) {
 	case ixgbe_mac_X540:
 		if (incval > 0xFFFFFFFFULL)
-			e_dev_warn("PTP ppb adjusted SYSTIME rate overflowed!\n");
+			e_dev_warn("PTP scaled_ppm adjusted SYSTIME rate overflowed!\n");
 		IXGBE_WRITE_REG(hw, IXGBE_TIMINCA, (u32)incval);
 		break;
 	case ixgbe_mac_82599EB:
 		if (incval > 0x00FFFFFFULL)
-			e_dev_warn("PTP ppb adjusted SYSTIME rate overflowed!\n");
+			e_dev_warn("PTP scaled_ppm adjusted SYSTIME rate overflowed!\n");
 		IXGBE_WRITE_REG(hw, IXGBE_TIMINCA,
 				BIT(IXGBE_INCPER_SHIFT_82599) |
 				((u32)incval & 0x00FFFFFFUL));
@@ -484,32 +488,35 @@ static int ixgbe_ptp_adjfreq_82599(struct ptp_clock_info *ptp, s32 ppb)
 }
 
 /**
- * ixgbe_ptp_adjfreq_X550
+ * ixgbe_ptp_adjfine_X550
  * @ptp: the ptp clock structure
- * @ppb: parts per billion adjustment from base
+ * @scaled_ppm: scaled parts per million adjustment from base
  *
- * adjust the frequency of the SYSTIME registers by the indicated ppb from base
- * frequency
+ * Adjust the frequency of the SYSTIME registers by the indicated scaled_ppm
+ * from base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int ixgbe_ptp_adjfreq_X550(struct ptp_clock_info *ptp, s32 ppb)
+static int ixgbe_ptp_adjfine_X550(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ixgbe_adapter *adapter =
 			container_of(ptp, struct ixgbe_adapter, ptp_caps);
 	struct ixgbe_hw *hw = &adapter->hw;
 	int neg_adj = 0;
-	u64 rate = IXGBE_X550_BASE_PERIOD;
+	u64 rate;
 	u32 inca;
 
-	if (ppb < 0) {
+	if (scaled_ppm < 0) {
 		neg_adj = 1;
-		ppb = -ppb;
+		scaled_ppm = -scaled_ppm;
 	}
-	rate *= ppb;
-	rate = div_u64(rate, 1000000000ULL);
+
+	rate = mul_u64_u64_div_u64(IXGBE_X550_BASE_PERIOD, scaled_ppm,
+				   1000000ULL << 16);
 
 	/* warn if rate is too large */
 	if (rate >= INCVALUE_MASK)
-		e_dev_warn("PTP ppb adjusted SYSTIME rate overflowed!\n");
+		e_dev_warn("PTP scaled_ppm adjusted SYSTIME rate overflowed!\n");
 
 	inca = rate & INCVALUE_MASK;
 	if (neg_adj)
@@ -1355,7 +1362,7 @@ static long ixgbe_ptp_create_clock(struct ixgbe_adapter *adapter)
 		adapter->ptp_caps.n_ext_ts = 0;
 		adapter->ptp_caps.n_per_out = 0;
 		adapter->ptp_caps.pps = 1;
-		adapter->ptp_caps.adjfreq = ixgbe_ptp_adjfreq_82599;
+		adapter->ptp_caps.adjfine = ixgbe_ptp_adjfine_82599;
 		adapter->ptp_caps.adjtime = ixgbe_ptp_adjtime;
 		adapter->ptp_caps.gettimex64 = ixgbe_ptp_gettimex;
 		adapter->ptp_caps.settime64 = ixgbe_ptp_settime;
@@ -1372,7 +1379,7 @@ static long ixgbe_ptp_create_clock(struct ixgbe_adapter *adapter)
 		adapter->ptp_caps.n_ext_ts = 0;
 		adapter->ptp_caps.n_per_out = 0;
 		adapter->ptp_caps.pps = 0;
-		adapter->ptp_caps.adjfreq = ixgbe_ptp_adjfreq_82599;
+		adapter->ptp_caps.adjfine = ixgbe_ptp_adjfine_82599;
 		adapter->ptp_caps.adjtime = ixgbe_ptp_adjtime;
 		adapter->ptp_caps.gettimex64 = ixgbe_ptp_gettimex;
 		adapter->ptp_caps.settime64 = ixgbe_ptp_settime;
@@ -1388,7 +1395,7 @@ static long ixgbe_ptp_create_clock(struct ixgbe_adapter *adapter)
 		adapter->ptp_caps.n_ext_ts = 0;
 		adapter->ptp_caps.n_per_out = 0;
 		adapter->ptp_caps.pps = 1;
-		adapter->ptp_caps.adjfreq = ixgbe_ptp_adjfreq_X550;
+		adapter->ptp_caps.adjfine = ixgbe_ptp_adjfine_X550;
 		adapter->ptp_caps.adjtime = ixgbe_ptp_adjtime;
 		adapter->ptp_caps.gettimex64 = ixgbe_ptp_gettimex;
 		adapter->ptp_caps.settime64 = ixgbe_ptp_settime;
-- 
2.35.1

