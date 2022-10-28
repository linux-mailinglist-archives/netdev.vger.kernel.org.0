Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5990610F50
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiJ1LEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJ1LEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34267193DE
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955079; x=1698491079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6pkb5nyEv33QuUKJW9wFp1bArP9cT4PEsTOAq9b81nQ=;
  b=oDG4LtnITnCqZ6ckGNv2ZTCR894pwPq7SeAhbXEyn6mHB1YsZLNv+CWK
   qPdYmrNq32WJCCKI2+TMjG0IRS/3RHeySAYUZuTL+Ur4G4yh3VNvgVcld
   3N0sU+oZVjygYYYNsCpdb5Wba1xAYQMSiAxpNhyH+QobYw6ENqNEq/YhV
   zeAZN8vs0xXdIZdtrMI2yOf6LSE7rSRjHFDn2A1eWbIwUCForJ6gEiMxg
   8Uh1wb9iHbkwvex9jj07b3/49t1Rt1xtRF9FzaKXEyAnao7W9zPtQvxP0
   1Wf+YTUZRDUUk2yUoFNIpEHcwa5g4L/Oeruq/6SloJQ+SYmzBsCAqWofG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766549"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766549"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698113"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698113"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:35 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v3 7/9] ptp: lan743x: use diff_by_scaled_ppm in .adjfine implementation
Date:   Fri, 28 Oct 2022 04:04:18 -0700
Message-Id: <20221028110420.3451088-8-jacob.e.keller@intel.com>
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

Update the lan743x driver to use the recently added diff_by_scaled_ppm
helper function. This reduces the amount of code required in lan743x_ptp.c
driver file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: UNGLinuxDriver@microchip.com
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 28930f3c52c2..39e1066ecd5f 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -339,25 +339,18 @@ static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
 	struct lan743x_adapter *adapter =
 		container_of(ptp, struct lan743x_adapter, ptp);
 	u32 lan743x_rate_adj = 0;
-	bool positive = true;
-	u64 u64_delta = 0;
+	u64 u64_delta;
 
 	if ((scaled_ppm < (-LAN743X_PTP_MAX_FINE_ADJ_IN_SCALED_PPM)) ||
 	    scaled_ppm > LAN743X_PTP_MAX_FINE_ADJ_IN_SCALED_PPM) {
 		return -EINVAL;
 	}
-	if (scaled_ppm > 0) {
-		u64_delta = (u64)scaled_ppm;
-		positive = true;
-	} else {
-		u64_delta = (u64)(-scaled_ppm);
-		positive = false;
-	}
-	u64_delta = (u64_delta << 19);
-	lan743x_rate_adj = div_u64(u64_delta, 1000000);
 
-	if (positive)
-		lan743x_rate_adj |= PTP_CLOCK_RATE_ADJ_DIR_;
+	/* diff_by_scaled_ppm returns true if the difference is negative */
+	if (diff_by_scaled_ppm(1ULL << 35, scaled_ppm, &u64_delta))
+		lan743x_rate_adj = (u32)u64_delta;
+	else
+		lan743x_rate_adj = (u32)u64_delta | PTP_CLOCK_RATE_ADJ_DIR_;
 
 	lan743x_csr_write(adapter, PTP_CLOCK_RATE_ADJ,
 			  lan743x_rate_adj);
-- 
2.38.0.83.gd420dda05763

