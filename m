Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62955623748
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiKIXKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiKIXJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:57 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5409127DC5
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035396; x=1699571396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TvYOrX5BR9uxLa7XLgkQZK+kzapPn5V5RZeEjslel8U=;
  b=l9xKcEgzmMkGUF3qT4qB641sys9+BZOYFtopZHkmKXaOAxk0LxQ4cm7F
   O/0XI/9cSrP4VcCPEW5cGQpXMGWXG5MXCEDILBGBjwGghRP/n4JqPgAF9
   9h1sogwLFRIR52whRw7v7/5A2MNuLWQXySkTh9B7turwTL/0U3sKY1RMC
   45UZ7xuj7VBiegeSH+W6aeh16fngPuXllhe5MuLHNDf/NrvYeGErMGz2g
   Sx6a46H6ufensorlzV5/3f6LT9LdNLiIVu51w8bkxXf9Xref2CnV2M+Nc
   qJSvbO3k1iL6FJ+bsiu/9YwDwB66cWdseAJ1q4npYefN5YbnaNt37aCGN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860528"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860528"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930554"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930554"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH net-next 5/9] ptp: stmac: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:41 -0800
Message-Id: <20221109230945.545440-6-jacob.e.keller@intel.com>
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

The stmac implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the newer .adjfine, using the recently added
adjust_by_scaled_ppm helper function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 23 ++++++-------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 4d11980dcd64..fc06ddeac0d5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -15,29 +15,20 @@
  * stmmac_adjust_freq
  *
  * @ptp: pointer to ptp_clock_info structure
- * @ppb: desired period change in parts ber billion
+ * @scaled_ppm: desired period change in scaled parts per million
  *
  * Description: this function will adjust the frequency of hardware clock.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
+static int stmmac_adjust_freq(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
-	u32 diff, addend;
-	int neg_adj = 0;
-	u64 adj;
+	u32 addend;
 
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-
-	addend = priv->default_addend;
-	adj = addend;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
-	addend = neg_adj ? (addend - diff) : (addend + diff);
+	addend = adjust_by_scaled_ppm(priv->default_addend, scaled_ppm);
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_config_addend(priv, priv->ptpaddr, addend);
@@ -269,7 +260,7 @@ static struct ptp_clock_info stmmac_ptp_clock_ops = {
 	.n_per_out = 0, /* will be overwritten in stmmac_ptp_register */
 	.n_pins = 0,
 	.pps = 0,
-	.adjfreq = stmmac_adjust_freq,
+	.adjfine = stmmac_adjust_freq,
 	.adjtime = stmmac_adjust_time,
 	.gettime64 = stmmac_get_time,
 	.settime64 = stmmac_set_time,
-- 
2.38.0.83.gd420dda05763

