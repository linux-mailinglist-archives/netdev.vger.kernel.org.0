Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD8623741
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiKIXJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiKIXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AEB20998
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035394; x=1699571394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bEfO6W0k1pOqr2DtdVzP6JGSnzhsSppcSCRhqDDTqdk=;
  b=aiig2M/l7M7S5VNB24pBVqdj2mfIhO8AEJqI1sbE8ApDdEvnUXeFQYNi
   L+pZNYL9sUlzmI1kvU1Nd+b/Yd/0woQpqcDHYh1KNnGWzBiQqg6Ago3QV
   Uod2XHDeaEFNcQ3XmCfBNveQF93nZYmoj5TdDQdRa43EKGO/1WP697zJP
   WBAz1PqpHwlTHhsXtWZdaPmBUJORNQYTcgHanaYlqgTf1/jFxog75Fddc
   XQxOi2/HG56ue/lRYigIvuKMDmnR7kPRh4DLCk6v02ursP67wuutT1NW6
   WJrsmGJ7MB4i/UEmjmf6Ih6INm8ELW2INGR8CB3OoRx3+9++aXriZIICE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860520"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860520"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930542"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930542"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 1/9] ptp_phc: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:37 -0800
Message-Id: <20221109230945.545440-2-jacob.e.keller@intel.com>
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

The ptp_phc implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the newer .adjfine, updating the driver to use the recently
introduced adjust_by_scaled_ppm helper function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_pch.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 7d4da9e605ef..33355d5eb033 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -336,24 +336,13 @@ static irqreturn_t isr(int irq, void *priv)
  * PTP clock operations
  */
 
-static int ptp_pch_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_pch_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	u64 adj;
-	u32 diff, addend;
-	int neg_adj = 0;
+	u32 addend;
 	struct pch_dev *pch_dev = container_of(ptp, struct pch_dev, caps);
 	struct pch_ts_regs __iomem *regs = pch_dev->regs;
 
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-	addend = DEFAULT_ADDEND;
-	adj = addend;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
-
-	addend = neg_adj ? addend - diff : addend + diff;
+	addend = adjust_by_scaled_ppm(DEFAULT_ADDEND, scaled_ppm);
 
 	iowrite32(addend, &regs->addend);
 
@@ -440,7 +429,7 @@ static const struct ptp_clock_info ptp_pch_caps = {
 	.n_ext_ts	= N_EXT_TS,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_pch_adjfreq,
+	.adjfine	= ptp_pch_adjfine,
 	.adjtime	= ptp_pch_adjtime,
 	.gettime64	= ptp_pch_gettime,
 	.settime64	= ptp_pch_settime,
-- 
2.38.0.83.gd420dda05763

