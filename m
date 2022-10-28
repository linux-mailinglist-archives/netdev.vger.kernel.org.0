Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F3C610F4D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJ1LEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiJ1LEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD3A13DF5
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955076; x=1698491076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DOvzKUEzTvvetgIygo4tsvS+2zu/7Xi7qffgg1o/AfM=;
  b=ADpDsWNRTKuPdHXAm6CoUeuDfbtBjcJeJVJvUHoupQfaOq4xHC16EHtG
   9mdqCZ9hLMz4WGiBAOBUJOQZhOaqYObcYG/92c85/EllHmaKx6JklFi8F
   7IoEdzvE7adf1QsFAxhbjYppsh5mqSCgoLW6e/4vtgZ3cC/MuXSm79Cv8
   GNNSERY6TDm2/Q8mJCixcqE6+E+w5AzK/uB1dCvVkFPqXL1BCrJ2pgXsh
   /RagznJEVEVnsvHlrHQYDbDTLE4QU0/pLWFWXevxUUkqIGOSyb6b+Ly5q
   RgqIDk5Ru5Jl4XjW/hynPsOEjn/XbpXvXDYhxaFcqGIQHwMJqoSW39oHq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766541"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766541"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:34 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698092"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698092"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:34 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next v3 4/9] ptp: mlx4: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 28 Oct 2022 04:04:15 -0700
Message-Id: <20221028110420.3451088-5-jacob.e.keller@intel.com>
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

The mlx4 implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use adjust_by_scaled_ppm to perform the
calculation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 29 +++++++------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 024788549c25..98b5ffb4d729 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -111,34 +111,27 @@ void mlx4_en_ptp_overflow_check(struct mlx4_en_dev *mdev)
 }
 
 /**
- * mlx4_en_phc_adjfreq - adjust the frequency of the hardware clock
+ * mlx4_en_phc_adjfine - adjust the frequency of the hardware clock
  * @ptp: ptp clock structure
- * @delta: Desired frequency change in parts per billion
+ * @scaled_ppm: Desired frequency change in scaled parts per million
  *
- * Adjust the frequency of the PHC cycle counter by the indicated delta from
- * the base frequency.
+ * Adjust the frequency of the PHC cycle counter by the indicated scaled_ppm
+ * from the base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  **/
-static int mlx4_en_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int mlx4_en_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	u64 adj;
-	u32 diff, mult;
-	int neg_adj = 0;
+	u32 mult;
 	unsigned long flags;
 	struct mlx4_en_dev *mdev = container_of(ptp, struct mlx4_en_dev,
 						ptp_clock_info);
 
-	if (delta < 0) {
-		neg_adj = 1;
-		delta = -delta;
-	}
-	mult = mdev->nominal_c_mult;
-	adj = mult;
-	adj *= delta;
-	diff = div_u64(adj, 1000000000ULL);
+	mult = (u32)adjust_by_scaled_ppm(mdev->nominal_c_mult, scaled_ppm);
 
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
 	timecounter_read(&mdev->clock);
-	mdev->cycles.mult = neg_adj ? mult - diff : mult + diff;
+	mdev->cycles.mult = mult;
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	return 0;
@@ -237,7 +230,7 @@ static const struct ptp_clock_info mlx4_en_ptp_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= mlx4_en_phc_adjfreq,
+	.adjfine	= mlx4_en_phc_adjfine,
 	.adjtime	= mlx4_en_phc_adjtime,
 	.gettime64	= mlx4_en_phc_gettime,
 	.settime64	= mlx4_en_phc_settime,
-- 
2.38.0.83.gd420dda05763

