Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660F3623743
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiKIXJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiKIXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:55 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30252124F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035394; x=1699571394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D1OeIv0Ww5+t7YO4CAwE81SDUaeH1KtUvCAK7bPB/I8=;
  b=OPrfpfMW45g0KXQP09Lev82o8dtn7+WO5tApcvjrDvUYYj3tif1jUItN
   r1TNvfg/JDmUnaHfDiZ1Ejs3k1uOZQBp3fx3mxuWP47H0q/NM7GB0Mh72
   HgbQ+Z2y9iybqrhyIUyTw+BTkto7fhahZrvSWkSGiWlFDfZbKgwX2xsr6
   +8L1LdfTwJKK0gkApo8ZRjp8shZ9U6onk3AfQDGKT0opm98AXxh8us832
   YJB1Gw1zjuOCCffrs25wiCWJtosknWyJgrgxZIxx2KYbYDcGdNSrB5oOe
   qCOojOOhB/cCde76691bebL148WixzswRiHoqOVDrq1e9kbbN6jTlgLP1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="290867573"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="290867573"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930560"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930560"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 7/9] ptp: bnxt: convert .adjfreq to .adjfine
Date:   Wed,  9 Nov 2022 15:09:43 -0800
Message-Id: <20221109230945.545440-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221109230945.545440-1-jacob.e.keller@intel.com>
References: <20221109230945.545440-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the BNXT_FW_CAP_PTP_RTC flag is not set, the bnxt driver implements
.adjfreq on a cyclecounter in terms of the straightforward "base * ppb / 1
billion" calculation. When BNXT_FW_CAP_PTP_RTC is set, the driver forwards
the ppb value to firmware for configuration.

Convert the driver to the newer .adjfine interface, updating the
cyclecounter calculation to use adjust_by_scaled_ppm to perform the
calculation. Use scaled_ppm_to_ppb when forwarding the correction to
firmware.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 22 +++++--------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 460cb20599f6..4ec8bba18cdd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -205,7 +205,7 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 	return 0;
 }
 
-static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
+static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 {
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
@@ -214,23 +214,13 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
 	int rc = 0;
 
 	if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
-		int neg_adj = 0;
-		u32 diff;
-		u64 adj;
-
-		if (ppb < 0) {
-			neg_adj = 1;
-			ppb = -ppb;
-		}
-		adj = ptp->cmult;
-		adj *= ppb;
-		diff = div_u64(adj, 1000000000ULL);
-
 		spin_lock_bh(&ptp->ptp_lock);
 		timecounter_read(&ptp->tc);
-		ptp->cc.mult = neg_adj ? ptp->cmult - diff : ptp->cmult + diff;
+		ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
 		spin_unlock_bh(&ptp->ptp_lock);
 	} else {
+		s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+
 		rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
 		if (rc)
 			return rc;
@@ -240,7 +230,7 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
 		rc = hwrm_req_send(ptp->bp, req);
 		if (rc)
 			netdev_err(ptp->bp->dev,
-				   "ptp adjfreq failed. rc = %d\n", rc);
+				   "ptp adjfine failed. rc = %d\n", rc);
 	}
 	return rc;
 }
@@ -769,7 +759,7 @@ static const struct ptp_clock_info bnxt_ptp_caps = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= bnxt_ptp_adjfreq,
+	.adjfine	= bnxt_ptp_adjfine,
 	.adjtime	= bnxt_ptp_adjtime,
 	.do_aux_work	= bnxt_ptp_ts_aux_work,
 	.gettimex64	= bnxt_ptp_gettimex,
-- 
2.38.0.83.gd420dda05763

