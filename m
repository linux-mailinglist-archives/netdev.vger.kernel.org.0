Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBF2610F4F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJ1LEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiJ1LEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341F6193DC
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955079; x=1698491079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P75f6iHmM+s2pZ3ALUXn652BWYV3cE0QMRbsojBY5zQ=;
  b=VpAwRvQZyhT9WGfeiDy0yHvbHVVLzu/Fu3AMDUXo+1uwgJV4PJumDgxO
   xxYC5LokWDjBnsAYsAU8Ry8L3kKX2FetpG1YI75IizC3UADERclHzXHbF
   pxkveSBXFiuLiydXW4whlmReqE7k39FyS5TGflbuLuzGdFj7y+ONQPP4G
   0kokJu7EnoQ54eyYA2bKUD5E5+UBIw2NlTNFNNcQT5lLttINrR4OxCQ1O
   /HJIOD7y/RI2VNRDkyuvHw1JubX8efq1GK3cjUZ0oub7uoFVZOtSSde0t
   KYs80hyNhg8BjxMh4H+Kn5jDbZSZ9Cw+fjLkAM1fLwLYsjduC0qWS5O5k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766547"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766547"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698105"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698105"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:34 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v3 6/9] ptp: lan743x: remove .adjfreq implementation
Date:   Fri, 28 Oct 2022 04:04:17 -0700
Message-Id: <20221028110420.3451088-7-jacob.e.keller@intel.com>
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

The lan743x driver implements both .adjfreq and .adjfine, but the core PTP
subsystem prefers .adjfine if implemented. There is no reason to carry a
.adjfreq implementation, so we can remove it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: UNGLinuxDriver@microchip.com
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 35 --------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index da3ea905adbb..28930f3c52c2 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -365,40 +365,6 @@ static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
 	return 0;
 }
 
-static int lan743x_ptpci_adjfreq(struct ptp_clock_info *ptpci, s32 delta_ppb)
-{
-	struct lan743x_ptp *ptp =
-		container_of(ptpci, struct lan743x_ptp, ptp_clock_info);
-	struct lan743x_adapter *adapter =
-		container_of(ptp, struct lan743x_adapter, ptp);
-	u32 lan743x_rate_adj = 0;
-	bool positive = true;
-	u32 u32_delta = 0;
-	u64 u64_delta = 0;
-
-	if ((delta_ppb < (-LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB)) ||
-	    delta_ppb > LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB) {
-		return -EINVAL;
-	}
-	if (delta_ppb > 0) {
-		u32_delta = (u32)delta_ppb;
-		positive = true;
-	} else {
-		u32_delta = (u32)(-delta_ppb);
-		positive = false;
-	}
-	u64_delta = (((u64)u32_delta) << 35);
-	lan743x_rate_adj = div_u64(u64_delta, 1000000000);
-
-	if (positive)
-		lan743x_rate_adj |= PTP_CLOCK_RATE_ADJ_DIR_;
-
-	lan743x_csr_write(adapter, PTP_CLOCK_RATE_ADJ,
-			  lan743x_rate_adj);
-
-	return 0;
-}
-
 static int lan743x_ptpci_adjtime(struct ptp_clock_info *ptpci, s64 delta)
 {
 	struct lan743x_ptp *ptp =
@@ -1583,7 +1549,6 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	ptp->ptp_clock_info.pps = LAN743X_PTP_N_PPS;
 	ptp->ptp_clock_info.pin_config = ptp->pin_config;
 	ptp->ptp_clock_info.adjfine = lan743x_ptpci_adjfine;
-	ptp->ptp_clock_info.adjfreq = lan743x_ptpci_adjfreq;
 	ptp->ptp_clock_info.adjtime = lan743x_ptpci_adjtime;
 	ptp->ptp_clock_info.gettime64 = lan743x_ptpci_gettime64;
 	ptp->ptp_clock_info.getcrosststamp = NULL;
-- 
2.38.0.83.gd420dda05763

