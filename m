Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E361F6C3B2F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCUUCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCUUCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:02:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA02559D0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 13:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679428923; x=1710964923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jsnLEyX+bLsn414l0H4sjcaYG7AJ/lUv6HIzTmPOvvw=;
  b=J2W99rsHsm6thhQ2HGbAQTyjHdtOKUKsHliux+92Zqe9a3e4bWvFshl2
   57VR1DEghICROlFOAKcHCecLBE9mj8qa6uFs+sPDjRwwDWmrhItD1sszm
   utNLX27ZLWj2hxo5h1zdRR/kutV094Icd0VCNv0heTYEfvWy2/SNdRnoc
   cPBWARcSjXBEvIo2m9shG8OBXprO5PFSd3Yqf5KNd1ky7DC4R6k/AX2fP
   tavUei91TytCMzlLhVudiu3sOmA0B5xU1qKKi5hcnUU7ytE462JH/S6gJ
   7jpTilmW/+LOPheXzbXLrLbGw1rPABtgm02BJ2fFUBcwIej3Orm3cIYtq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403934789"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403934789"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 13:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="658911188"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="658911188"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2023 13:01:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Andrii Staikov <andrii.staikov@intel.com>,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 1/3] igb: refactor igb_ptp_adjfine_82580 to use diff_by_scaled_ppm
Date:   Tue, 21 Mar 2023 13:00:11 -0700
Message-Id: <20230321200013.2866582-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
References: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Staikov <andrii.staikov@intel.com>

Driver's .adjfine interface functions use adjust_by_scaled_ppm and
diff_by_scaled_ppm introduced in commit 1060707e3809
("ptp: introduce helpers to adjust by scaled parts per million")
to calculate the required adjustment in a concise manner,
but not igb_ptp_adjfine_82580.
Fix it by introducing IGB_82580_BASE_PERIOD and changing function logic
to use diff_by_scaled_ppm.

Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 6f471b91f562..405886ee5261 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -67,6 +67,7 @@
 #define INCVALUE_82576_MASK		GENMASK(E1000_TIMINCA_16NS_SHIFT - 1, 0)
 #define INCVALUE_82576			(16u << IGB_82576_TSYNC_SHIFT)
 #define IGB_NBITS_82580			40
+#define IGB_82580_BASE_PERIOD		0x800000000
 
 static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter);
 static void igb_ptp_sdp_init(struct igb_adapter *adapter);
@@ -209,17 +210,11 @@ static int igb_ptp_adjfine_82580(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct igb_adapter *igb = container_of(ptp, struct igb_adapter,
 					       ptp_caps);
 	struct e1000_hw *hw = &igb->hw;
-	int neg_adj = 0;
+	bool neg_adj;
 	u64 rate;
 	u32 inca;
 
-	if (scaled_ppm < 0) {
-		neg_adj = 1;
-		scaled_ppm = -scaled_ppm;
-	}
-	rate = scaled_ppm;
-	rate <<= 13;
-	rate = div_u64(rate, 15625);
+	neg_adj = diff_by_scaled_ppm(IGB_82580_BASE_PERIOD, scaled_ppm, &rate);
 
 	inca = rate & INCVALUE_MASK;
 	if (neg_adj)
-- 
2.38.1

