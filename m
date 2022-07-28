Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8F85845A7
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiG1SVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiG1SVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A756C5B048
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032504; x=1690568504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uejaYWCdzw8RAoho7ahGyWtukPMgEjBK83meTDE1X/s=;
  b=kzB7KfBaT/IfVDfdnzG0HIPL3Q+HkLip3xrLxhOAKw/XRMzEv6fZ2vZE
   xvPYWNGch/7uSxBqgcBiW1uBBJNWBKsJ3iQXbw4nyVeCYp3cMPx/h4mPH
   0lAfdee7jrPE4/HcEeaXNmNkeZ/EDBArihIYXW4TcvdZn7JdYSftp3W8C
   6l14dU4tU+mq/uENxeDdYfOJXdjolsdnd1i5i/8BoHmQ8xZ5yuHZGEf32
   dXXTOutQSm5Vs/ouMSwWGMFahzX69VNRnnXuhdfwn4D20b1ajPriJGdnm
   S5J85RtiIduv+9oSwY6I18iJyBDJxeNYwkld/0UGn7XUeDVMFEQBSkpEY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348904"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348904"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456614"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/7] ice: implement adjfine with mul_u64_u64_div_u64
Date:   Thu, 28 Jul 2022 11:18:30 -0700
Message-Id: <20220728181836.3387862-2-anthony.l.nguyen@intel.com>
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

The PTP frequency adjustment code needs to determine an appropriate
adjustment given an input scaled_ppm adjustment.

We calculate the adjustment to the register by multiplying the base
(nominal) increment value by the scaled_ppm and then dividing by the
scaled one million value.

For very large adjustments, this might overflow. To avoid this, both the
scaled_ppm and divisor values are downshifted.

We can avoid that on X86 architectures by using mul_u64_u64_div_u64. This
helper function will perform the multiplication and division with 128bit
intermediate values. We know that scaled_ppm is never larger than the
divisor so this operation will never result in an overflow.

This improves the accuracy of the calculations for large adjustment values
on X86. It is likely an improvement on other architectures as well because
the default implementation of mul_u64_u64_div_u64 is smarter than the
original approach taken in the ice code.

Additionally, this implementation is easier to read, using fewer local
variables and lines of code to implement.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 29c7a0ccb3c4..72b663108a4a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1102,9 +1102,8 @@ static void ice_ptp_reset_phy_timestamping(struct ice_pf *pf)
 static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct ice_pf *pf = ptp_info_to_pf(info);
-	u64 freq, divisor = 1000000ULL;
 	struct ice_hw *hw = &pf->hw;
-	s64 incval, diff;
+	u64 incval, diff;
 	int neg_adj = 0;
 	int err;
 
@@ -1115,17 +1114,8 @@ static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 		scaled_ppm = -scaled_ppm;
 	}
 
-	while ((u64)scaled_ppm > div64_u64(U64_MAX, incval)) {
-		/* handle overflow by scaling down the scaled_ppm and
-		 * the divisor, losing some precision
-		 */
-		scaled_ppm >>= 2;
-		divisor >>= 2;
-	}
-
-	freq = (incval * (u64)scaled_ppm) >> 16;
-	diff = div_u64(freq, divisor);
-
+	diff = mul_u64_u64_div_u64(incval, (u64)scaled_ppm,
+				   1000000ULL << 16);
 	if (neg_adj)
 		incval -= diff;
 	else
-- 
2.35.1

