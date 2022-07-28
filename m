Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1090C5845CB
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiG1SVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiG1SVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69985B04A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032504; x=1690568504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VU6yJzAMwkE8cLBH0Kte88iVbDqy0D3QzOowswpXrl8=;
  b=Zc29CtS+i3Ig79A1thLBwHbojbTvGgGBSeiQBQc6QDZgiWqeX2aYgVI5
   pvKNhr8LVHdnmU3uiXafkZD96C64EssGlR6BMlgrI+HEgBKbVu6LBu1wi
   zPys1XaBqm8nHNbvj6PBDdtEzRiKLZmEjkxe/pKZ8a/jaToxojBSR/adk
   kFBXu2M8OxR6vCQBny6qs4+f5pdkUz5Ihx2Q8RTJeHPBG2ilkttFaXfiw
   XMIiM17lLU6bltevcClSt1fhfAf5Bx/Rk24lMuHhDKELfIyl/UUvSyLx2
   7Q/6WGlDhDxpIjdnPrUV7ILIUT0J2uBj2exiyjvcRtAwXPjD+P40/j2ro
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348908"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348908"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456621"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 3/7] e1000e: convert .adjfreq to .adjfine
Date:   Thu, 28 Jul 2022 11:18:32 -0700
Message-Id: <20220728181836.3387862-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
References: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The PTP implementation for the e1000e driver uses the older .adjfreq
method. This method takes an adjustment in parts per billion. The newer
.adjfine implementation uses scaled_ppm. The use of scaled_ppm allows for
finer grained adjustments and is preferred over using the older
implementation.

Make use of mul_u64_u64_div_u64 in order to handle possible overflow of the
multiplication used to calculate the desired adjustment to the hardware
increment value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h  |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c |  4 ++--
 drivers/net/ethernet/intel/e1000e/ptp.c    | 15 ++++++++-------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 8d06c9d8ff8b..e8a9a9610ac6 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -329,7 +329,7 @@ struct e1000_adapter {
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_clock_info;
 	struct pm_qos_request pm_qos_req;
-	s32 ptp_delta;
+	long ptp_delta;
 
 	u16 eee_advert;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 70d933f52e93..321f2a95ae3a 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3922,9 +3922,9 @@ static void e1000e_systim_reset(struct e1000_adapter *adapter)
 	if (!(adapter->flags & FLAG_HAS_HW_TIMESTAMP))
 		return;
 
-	if (info->adjfreq) {
+	if (info->adjfine) {
 		/* restore the previous ptp frequency delta */
-		ret_val = info->adjfreq(info, adapter->ptp_delta);
+		ret_val = info->adjfine(info, adapter->ptp_delta);
 	} else {
 		/* set the default base frequency if no adjustment possible */
 		ret_val = e1000e_get_base_timinca(adapter, &timinca);
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 432e04ce8c4e..0e488e4fa5c1 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -15,14 +15,16 @@
 #endif
 
 /**
- * e1000e_phc_adjfreq - adjust the frequency of the hardware clock
+ * e1000e_phc_adjfine - adjust the frequency of the hardware clock
  * @ptp: ptp clock structure
- * @delta: Desired frequency change in parts per billion
+ * @delta: Desired frequency chance in scaled parts per million
  *
  * Adjust the frequency of the PHC cycle counter by the indicated delta from
  * the base frequency.
+ *
+ * Scaled parts per million is ppm but with a 16 bit binary fractional field.
  **/
-static int e1000e_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int e1000e_phc_adjfine(struct ptp_clock_info *ptp, long delta)
 {
 	struct e1000_adapter *adapter = container_of(ptp, struct e1000_adapter,
 						     ptp_clock_info);
@@ -47,9 +49,8 @@ static int e1000e_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 
 	incvalue = timinca & E1000_TIMINCA_INCVALUE_MASK;
 
-	adjustment = incvalue;
-	adjustment *= delta;
-	adjustment = div_u64(adjustment, 1000000000);
+	adjustment = mul_u64_u64_div_u64(incvalue, (u64)delta,
+					 1000000ULL << 16);
 
 	incvalue = neg_adj ? (incvalue - adjustment) : (incvalue + adjustment);
 
@@ -257,7 +258,7 @@ static const struct ptp_clock_info e1000e_ptp_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= e1000e_phc_adjfreq,
+	.adjfine	= e1000e_phc_adjfine,
 	.adjtime	= e1000e_phc_adjtime,
 	.gettimex64	= e1000e_phc_gettimex,
 	.settime64	= e1000e_phc_settime,
-- 
2.35.1

