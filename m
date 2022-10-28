Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64F0610F53
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJ1LEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJ1LEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380F71EC4E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955083; x=1698491083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zd0XMfwALLZy/m6uE7w3n2+n3u+A+u5GHXEllL2PJyc=;
  b=fmunYJ9SEUHP5MR6jG8Ei/++uyhBDP/+mKXzj25G7XeCZrHQyrKHZwjH
   2s4GL2JiU7+vtwSIQWX7nO/UgmyaMheMmWrDDtOth8wIQdiJ0J8Tfmr3Z
   vi9+Gpuu65rRC+nv99MKL4bNoSp7NlEC06twGajqZENEX1PXOW+GFIs+i
   aucqNvcy2so6XwdPb/SXRF9S1tW0GZe1wujQZN31w7ubinTdSUsIfrFH5
   qf4vUmKZ74ZSQdwwcAikaKqgThln5E12eM2MfMSRf7SBnfp4nsiFZ/PLd
   jh237fBOsEuWhT/EJoWF3m40IxKuREIaUIOj4c44ZFFggfHoTlOyur0pz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766557"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766557"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698122"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698122"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:36 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net-next v3 9/9] ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 28 Oct 2022 04:04:20 -0700
Message-Id: <20221028110420.3451088-10-jacob.e.keller@intel.com>
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

The xgbe implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use adjust_by_scaled_ppm to calculate
the new addend value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
index d06d260cf1e2..7051bd7cf6dc 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
@@ -134,27 +134,15 @@ static u64 xgbe_cc_read(const struct cyclecounter *cc)
 	return nsec;
 }
 
-static int xgbe_adjfreq(struct ptp_clock_info *info, s32 delta)
+static int xgbe_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct xgbe_prv_data *pdata = container_of(info,
 						   struct xgbe_prv_data,
 						   ptp_clock_info);
 	unsigned long flags;
-	u64 adjust;
-	u32 addend, diff;
-	unsigned int neg_adjust = 0;
+	u64 addend;
 
-	if (delta < 0) {
-		neg_adjust = 1;
-		delta = -delta;
-	}
-
-	adjust = pdata->tstamp_addend;
-	adjust *= delta;
-	diff = div_u64(adjust, 1000000000UL);
-
-	addend = (neg_adjust) ? pdata->tstamp_addend - diff :
-				pdata->tstamp_addend + diff;
+	addend = adjust_by_scaled_ppm(pdata->tstamp_addend, scaled_ppm);
 
 	spin_lock_irqsave(&pdata->tstamp_lock, flags);
 
@@ -235,7 +223,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
 		 netdev_name(pdata->netdev));
 	info->owner = THIS_MODULE;
 	info->max_adj = pdata->ptpclk_rate;
-	info->adjfreq = xgbe_adjfreq;
+	info->adjfine = xgbe_adjfine;
 	info->adjtime = xgbe_adjtime;
 	info->gettime64 = xgbe_gettime;
 	info->settime64 = xgbe_settime;
-- 
2.38.0.83.gd420dda05763

