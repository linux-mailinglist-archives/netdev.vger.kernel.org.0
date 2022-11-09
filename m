Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596E0623742
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiKIXJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKIXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2106A27DC5
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035395; x=1699571395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9r9FjA5Ub+cE4J7eTCanTKKrZF/QPKEs9ZaBi/BDjRw=;
  b=XfRCET+QIXruJyx9tu7FlTHndOrgHGt2unj3P5kXBy4gL7xmUkxH/Yxp
   IbKBHb0ueCPxMP0OtiYmI/YZ/fxgQU8/c6T6JCB6mlcED+GBGRf9ulo3a
   AE6dU72GhWfvykQgLmRlTUBWpLsOheE8GRmkrB+yL6eKd7qcT+/TikOji
   SH9MpTH3aiE5unlLrsmydfg9CotmfpieOhPdmYpQh3pMb08wVLM8sCaq7
   6ThPhRRkrImQR5BS3DkOWAw1ZVVIfOMY6Snxvn/2bYIO7f9c6LnKOyOIb
   YowwRV++x1MgpLvZtsILPogo0Hjm5rQvUG3gGojHv4/bx5ByW2EmtagME
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860522"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860522"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930545"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930545"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/9] ptp_ixp46x: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:38 -0800
Message-Id: <20221109230945.545440-3-jacob.e.keller@intel.com>
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

The ptp_ixp46x implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the newer .adjfine, using the recently added
adjust_by_scaled_ppm helper function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 9abbdb71e629..94203eb46e6b 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -120,24 +120,13 @@ static irqreturn_t isr(int irq, void *priv)
  * PTP clock operations
  */
 
-static int ptp_ixp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_ixp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	u64 adj;
-	u32 diff, addend;
-	int neg_adj = 0;
+	u32 addend;
 	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
 	struct ixp46x_ts_regs *regs = ixp_clock->regs;
 
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
 
 	__raw_writel(addend, &regs->addend);
 
@@ -230,7 +219,7 @@ static const struct ptp_clock_info ptp_ixp_caps = {
 	.n_ext_ts	= N_EXT_TS,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_ixp_adjfreq,
+	.adjfine	= ptp_ixp_adjfine,
 	.adjtime	= ptp_ixp_adjtime,
 	.gettime64	= ptp_ixp_gettime,
 	.settime64	= ptp_ixp_settime,
-- 
2.38.0.83.gd420dda05763

