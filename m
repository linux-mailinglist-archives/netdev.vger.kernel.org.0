Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AF7610F4B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJ1LEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJ1LEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E0913D45
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955075; x=1698491075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OoJj0IapoUkC0OfsVwbo1fL3Q6sC129WZpW1fVGQIQU=;
  b=TNcUJwoTCVVsCC5zc1DS8UovYO27/PhE1Yd/F4bwvNK4+I8U/oJF2bCC
   ORxVanh4+HHPR2cR8dvK+9LMly7dAfjSp837pXRG/zEuczk1OCMBHFZWz
   y17ZheQUxC52SwToXtEYq7Gr1FLpBK0qS/0zFMrTqrcDKVRij3jWlxvVm
   4gAnLstaNZZA9W//58yKiVX6VDyv9rm7LugsE8tCejYFgSk8bM6ZLVxbJ
   pdKgxvVJ3JmZ/VCD02hrieA5v+3Q10HAYeQ6E6AHhhNW/9nSSylYyTcD0
   0wpaqrnbmZzwIwVtlBw4RZgXMhf//S+uj+EE7V31/JxLNiZMlL6v6TcH1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766537"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766537"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698085"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698085"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:33 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v3 2/9] ptp: introduce helpers to adjust by scaled parts per million
Date:   Fri, 28 Oct 2022 04:04:13 -0700
Message-Id: <20221028110420.3451088-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221028110420.3451088-1-jacob.e.keller@intel.com>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many drivers implement the .adjfreq or .adjfine PTP op function with the
same basic logic:

  1. Determine a base frequency value
  2. Multiply this by the abs() of the requested adjustment, then divide by
     the appropriate divisor (1 billion, or 65,536 billion).
  3. Add or subtract this difference from the base frequency to calculate a
     new adjustment.

A few drivers need the difference and direction rather than the combined
new increment value.

I recently converted the Intel drivers to .adjfine and the scaled parts per
million (65.536 parts per billion) logic. To avoid overflow with minimal
loss of precision, mul_u64_u64_div_u64 was used.

The basic logic used by all of these drivers is very similar, and leads to
a lot of duplicate code to perform the same task.

Rather than keep this duplicate code, introduce diff_by_scaled_ppm and
adjust_by_scaled_ppm. These helper functions calculate the difference or
adjustment necessary based on the scaled parts per million input.

The diff_by_scaled_ppm function returns true if the difference should be
subtracted, and false otherwise.

Update the Intel drivers to use the new helper functions. Other vendor
drivers will be converted to .adjfine and this helper function in the
following changes.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/ptp.c      | 16 ++-----
 drivers/net/ethernet/intel/i40e/i40e_ptp.c   | 17 ++------
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 18 +-------
 drivers/net/ethernet/intel/igb/igb_ptp.c     | 18 +-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 24 ++--------
 include/linux/ptp_clock_kernel.h             | 46 ++++++++++++++++++++
 6 files changed, 60 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 0e488e4fa5c1..6e5a1720e6cd 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -29,17 +29,11 @@ static int e1000e_phc_adjfine(struct ptp_clock_info *ptp, long delta)
 	struct e1000_adapter *adapter = container_of(ptp, struct e1000_adapter,
 						     ptp_clock_info);
 	struct e1000_hw *hw = &adapter->hw;
-	bool neg_adj = false;
 	unsigned long flags;
-	u64 adjustment;
-	u32 timinca, incvalue;
+	u64 incvalue;
+	u32 timinca;
 	s32 ret_val;
 
-	if (delta < 0) {
-		neg_adj = true;
-		delta = -delta;
-	}
-
 	/* Get the System Time Register SYSTIM base frequency */
 	ret_val = e1000e_get_base_timinca(adapter, &timinca);
 	if (ret_val)
@@ -48,11 +42,7 @@ static int e1000e_phc_adjfine(struct ptp_clock_info *ptp, long delta)
 	spin_lock_irqsave(&adapter->systim_lock, flags);
 
 	incvalue = timinca & E1000_TIMINCA_INCVALUE_MASK;
-
-	adjustment = mul_u64_u64_div_u64(incvalue, (u64)delta,
-					 1000000ULL << 16);
-
-	incvalue = neg_adj ? (incvalue - adjustment) : (incvalue + adjustment);
+	incvalue = adjust_by_scaled_ppm(incvalue, delta);
 
 	timinca &= ~E1000_TIMINCA_INCVALUE_MASK;
 	timinca |= incvalue;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index ffea0c9c82f1..c37abbb3cd06 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -347,23 +347,12 @@ static int i40e_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct i40e_pf *pf = container_of(ptp, struct i40e_pf, ptp_caps);
 	struct i40e_hw *hw = &pf->hw;
-	u64 adj, freq, diff;
-	int neg_adj = 0;
-
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
+	u64 adj, base_adj;
 
 	smp_mb(); /* Force any pending update before accessing. */
-	freq = I40E_PTP_40GB_INCVAL * READ_ONCE(pf->ptp_adj_mult);
-	diff = mul_u64_u64_div_u64(freq, (u64)scaled_ppm,
-				   1000000ULL << 16);
+	base_adj = I40E_PTP_40GB_INCVAL * READ_ONCE(pf->ptp_adj_mult);
 
-	if (neg_adj)
-		adj = I40E_PTP_40GB_INCVAL - diff;
-	else
-		adj = I40E_PTP_40GB_INCVAL + diff;
+	adj = adjust_by_scaled_ppm(base_adj, scaled_ppm);
 
 	wr32(hw, I40E_PRTTSYN_INC_L, adj & 0xFFFFFFFF);
 	wr32(hw, I40E_PRTTSYN_INC_H, adj >> 32);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 011b727ab190..5cf198a33e26 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1444,24 +1444,10 @@ static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct ice_pf *pf = ptp_info_to_pf(info);
 	struct ice_hw *hw = &pf->hw;
-	u64 incval, diff;
-	int neg_adj = 0;
+	u64 incval;
 	int err;
 
-	incval = ice_base_incval(pf);
-
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
-
-	diff = mul_u64_u64_div_u64(incval, (u64)scaled_ppm,
-				   1000000ULL << 16);
-	if (neg_adj)
-		incval -= diff;
-	else
-		incval += diff;
-
+	incval = adjust_by_scaled_ppm(ice_base_incval(pf), scaled_ppm);
 	err = ice_ptp_write_incval_locked(hw, incval);
 	if (err) {
 		dev_err(ice_pf_to_dev(pf), "PTP failed to set incval, err %d\n",
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 15e57460e19e..6f471b91f562 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -195,23 +195,9 @@ static int igb_ptp_adjfine_82576(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct igb_adapter *igb = container_of(ptp, struct igb_adapter,
 					       ptp_caps);
 	struct e1000_hw *hw = &igb->hw;
-	int neg_adj = 0;
-	u64 rate;
-	u32 incvalue;
+	u64 incvalue;
 
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
-
-	incvalue = INCVALUE_82576;
-	rate = mul_u64_u64_div_u64(incvalue, (u64)scaled_ppm,
-				   1000000ULL << 16);
-
-	if (neg_adj)
-		incvalue -= rate;
-	else
-		incvalue += rate;
+	incvalue = adjust_by_scaled_ppm(INCVALUE_82576, scaled_ppm);
 
 	wr32(E1000_TIMINCA, INCPERIOD_82576 | (incvalue & INCVALUE_82576_MASK));
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index f8605f57bd06..fd3f77a9e28d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -451,21 +451,11 @@ static int ixgbe_ptp_adjfine_82599(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct ixgbe_adapter *adapter =
 		container_of(ptp, struct ixgbe_adapter, ptp_caps);
 	struct ixgbe_hw *hw = &adapter->hw;
-	u64 incval, diff;
-	int neg_adj = 0;
-
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
+	u64 incval;
 
 	smp_mb();
 	incval = READ_ONCE(adapter->base_incval);
-
-	diff = mul_u64_u64_div_u64(incval, scaled_ppm,
-				   1000000ULL << 16);
-
-	incval = neg_adj ? (incval - diff) : (incval + diff);
+	incval = adjust_by_scaled_ppm(incval, scaled_ppm);
 
 	switch (hw->mac.type) {
 	case ixgbe_mac_X540:
@@ -502,17 +492,11 @@ static int ixgbe_ptp_adjfine_X550(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct ixgbe_adapter *adapter =
 			container_of(ptp, struct ixgbe_adapter, ptp_caps);
 	struct ixgbe_hw *hw = &adapter->hw;
-	int neg_adj = 0;
+	bool neg_adj;
 	u64 rate;
 	u32 inca;
 
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
-
-	rate = mul_u64_u64_div_u64(IXGBE_X550_BASE_PERIOD, scaled_ppm,
-				   1000000ULL << 16);
+	neg_adj = diff_by_scaled_ppm(IXGBE_X550_BASE_PERIOD, scaled_ppm, &rate);
 
 	/* warn if rate is too large */
 	if (rate >= INCVALUE_MASK)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index ad4aaadc2f7a..f4781c5766d6 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -248,6 +248,52 @@ static inline long scaled_ppm_to_ppb(long ppm)
 	return (long)ppb;
 }
 
+/**
+ * diff_by_scaled_ppm - Calculate difference using scaled ppm
+ * @base: the base increment value to adjust
+ * @scaled_ppm: scaled parts per million to adjust by
+ * @diff: on return, the absolute value of calculated diff
+ *
+ * Calculate the difference to adjust the base increment using scaled parts
+ * per million.
+ *
+ * Use mul_u64_u64_div_u64 to perform the difference calculation in avoid
+ * possible overflow.
+ *
+ * Returns: true if scaled_ppm is negative, false otherwise
+ */
+static inline bool diff_by_scaled_ppm(u64 base, long scaled_ppm, u64 *diff)
+{
+	bool negative = false;
+
+	if (scaled_ppm < 0) {
+		negative = true;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	*diff = mul_u64_u64_div_u64(base, (u64)scaled_ppm, 1000000ULL << 16);
+
+	return negative;
+}
+
+/**
+ * adjust_by_scaled_ppm - Adjust a base increment by scaled parts per million
+ * @base: the base increment value to adjust
+ * @scaled_ppm: scaled parts per million frequency adjustment
+ *
+ * Helper function which calculates a new increment value based on the
+ * requested scaled parts per million adjustment.
+ */
+static inline u64 adjust_by_scaled_ppm(u64 base, long scaled_ppm)
+{
+	u64 diff;
+
+	if (diff_by_scaled_ppm(base, scaled_ppm, &diff))
+		return base - diff;
+
+	return base + diff;
+}
+
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 
 /**
-- 
2.38.0.83.gd420dda05763

