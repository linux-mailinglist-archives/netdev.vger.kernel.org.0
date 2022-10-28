Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F49610F4E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiJ1LEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJ1LEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86617167F1
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955077; x=1698491077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l3EBoGq79+SgOS8eaxcLWh6/oUSiV/JnxBBWej8kVBE=;
  b=mDRI8MDNuw1A0tnMS3+G01QyxrcRKxPNp9uFGC7Z29QnwRHw3+sDFOVi
   5FB/+QDADYgiIfycRjtf/caUQu9EDL/CnMgktw3gWtSkEmTj4CZGnnUm+
   ULW/zSJTHSnMOemG273vv0dR/I7QmScQaA3DDdYTWVuS+C3gbafSiDjJs
   fip7wP90EuCiSizqGLoduOeUNhqRZYWf/ypg5Bhv8/kQVenFA9q/hKGMi
   gyhJu5MRlcF/B+rqNsqPSMKOuKf2Czx2O3cxFAzUAclAy/CEqNFv/aYa/
   OUnm7yXi4b6ZtyutSzaEMBFLlzVghmACrAuHsu7JIlg2xFMmF4r9eAGG9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766546"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766546"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698100"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698100"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:34 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Shirly Ohnona <shirlyo@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH net-next v3 5/9] ptp: mlx5: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 28 Oct 2022 04:04:16 -0700
Message-Id: <20221028110420.3451088-6-jacob.e.keller@intel.com>
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

The mlx5 implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the .adjfine interface and use adjust_by_scaled_ppm for the
calculation  of the new mult value.

Note that the mlx5_ptp_adjfreq_real_time function expects input in terms of
ppb, so use the scaled_ppm_to_ppb to convert before passing to this
function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Shirly Ohnona <shirlyo@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Gal Pressman <gal@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Aya Levin <ayal@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 22 +++++--------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index d3a9ae80fd30..69cfe60c558a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -339,35 +339,25 @@ static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
 	return mlx5_set_mtutc(mdev, in, sizeof(in));
 }
 
-static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int mlx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_timer *timer = &clock->timer;
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
-	int neg_adj = 0;
-	u32 diff;
-	u64 adj;
+	u32 mult;
 	int err;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
-	err = mlx5_ptp_adjfreq_real_time(mdev, delta);
+	err = mlx5_ptp_adjfreq_real_time(mdev, scaled_ppm_to_ppb(scaled_ppm));
 	if (err)
 		return err;
 
-	if (delta < 0) {
-		neg_adj = 1;
-		delta = -delta;
-	}
-
-	adj = timer->nominal_c_mult;
-	adj *= delta;
-	diff = div_u64(adj, 1000000000ULL);
+	mult = (u32)adjust_by_scaled_ppm(timer->nominal_c_mult, scaled_ppm);
 
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&timer->tc);
-	timer->cycles.mult = neg_adj ? timer->nominal_c_mult - diff :
-				       timer->nominal_c_mult + diff;
+	timer->cycles.mult = mult;
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
@@ -697,7 +687,7 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= mlx5_ptp_adjfreq,
+	.adjfine	= mlx5_ptp_adjfine,
 	.adjtime	= mlx5_ptp_adjtime,
 	.gettimex64	= mlx5_ptp_gettimex,
 	.settime64	= mlx5_ptp_settime,
-- 
2.38.0.83.gd420dda05763

