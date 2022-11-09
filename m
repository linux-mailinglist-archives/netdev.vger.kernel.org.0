Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91E1623744
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiKIXKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiKIXJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:56 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05420998
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035395; x=1699571395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HhyuWp1djKhF0l+MG8SdU38rTCjQAo5qeR0UCV5QgQM=;
  b=dVW2g496DQCP7YGuCE8HYp2bxYVhy1OV+Wij5mcIGU3T/NH+Sl+MD5Di
   y2BUgBdehVbRZrhRGWzQ3qdDSd6zr5RngYe5XOeYKtq6Y/8fawSIpp+Mo
   vUzpcEV0LGqvar1fbCBNZyy04tAyeNw7RB7P7cBawG+oIlwe/0oyv2etv
   F3aFSvY6WZ2XM7EqetHdI1tyUoGMW/KV/uQBBob6KKDAY5NQFL8BrZ+gI
   EnTTjj7CUFFtVZns6w9jgvY7z6Op8RMltNuptpnTJoNURbJSvy8jK3zlG
   mrbllRS8qH0pcCGlZ9QuTwxaLf1jtJzeMpUQ+9bnSpFPKBKjl2Rt4JhdO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860526"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860526"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930551"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930551"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH net-next 4/9] ptp: hclge: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:40 -0800
Message-Id: <20221109230945.545440-5-jacob.e.keller@intel.com>
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

The hclge implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the newer .adjfine, using the recently added
adjust_by_scaled_ppm helper function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         | 22 +++++--------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index a40b1583f114..80a2a0073d97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -22,28 +22,16 @@ static int hclge_ptp_get_cycle(struct hclge_dev *hdev)
 	return 0;
 }
 
-static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int hclge_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
 	struct hclge_ptp_cycle *cycle = &hdev->ptp->cycle;
-	u64 adj_val, adj_base, diff;
+	u64 adj_val, adj_base;
 	unsigned long flags;
-	bool is_neg = false;
 	u32 quo, numerator;
 
-	if (ppb < 0) {
-		ppb = -ppb;
-		is_neg = true;
-	}
-
 	adj_base = (u64)cycle->quo * (u64)cycle->den + (u64)cycle->numer;
-	adj_val = adj_base * ppb;
-	diff = div_u64(adj_val, 1000000000ULL);
-
-	if (is_neg)
-		adj_val = adj_base - diff;
-	else
-		adj_val = adj_base + diff;
+	adj_val = adjust_by_scaled_ppm(adj_base, scaled_ppm);
 
 	/* This clock cycle is defined by three part: quotient, numerator
 	 * and denominator. For example, 2.5ns, the quotient is 2,
@@ -446,7 +434,7 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
 	ptp->info.max_adj = HCLGE_PTP_CYCLE_ADJ_MAX;
 	ptp->info.n_ext_ts = 0;
 	ptp->info.pps = 0;
-	ptp->info.adjfreq = hclge_ptp_adjfreq;
+	ptp->info.adjfine = hclge_ptp_adjfine;
 	ptp->info.adjtime = hclge_ptp_adjtime;
 	ptp->info.gettimex64 = hclge_ptp_gettimex;
 	ptp->info.settime64 = hclge_ptp_settime;
@@ -504,7 +492,7 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 		goto out;
 
 	set_bit(HCLGE_PTP_FLAG_EN, &hdev->ptp->flags);
-	ret = hclge_ptp_adjfreq(&hdev->ptp->info, 0);
+	ret = hclge_ptp_adjfine(&hdev->ptp->info, 0);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init freq, ret = %d\n", ret);
-- 
2.38.0.83.gd420dda05763

