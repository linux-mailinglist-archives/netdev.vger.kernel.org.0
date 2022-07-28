Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE375584594
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiG1SVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiG1SVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908445A89B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032505; x=1690568505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WYpmmMghzvDOuF6rDJHcJjeU0PAsC5W+aVKvcxOmf0Y=;
  b=TgOFNbmPoh98TZ5niF+lYoUqE4dv2DAb3NlMG+ouVwyxZrM+bYWhBTpl
   0EAQwXXzACmN5LQ/Li3xJuElELiIMgc1+RuNdXIUy4xpcxJDOCxkeIf7Y
   6ViXVuC9v7C+xrVGYpBQrARnBHMvhYCjJep+ZPGTF+pcs+GiOgQZ1+nZn
   z5XPXPfr1hqdWC/ylTwtIbm+iW4b2t7vNZZu1P5TnVtrLBEVJbgupvgNw
   pQBZGh5VTnNkYyi4ZECgDdme1jChJTC/5m4StskDqyKb9BTg4tNyhvait
   TYo9kvMtyDhVFy4sF7YGYVS37WtkmlJj+Q+1vKHoH2oXZvIe8e8HYQ/OX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348910"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348910"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456624"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/7] i40e: use mul_u64_u64_div_u64 for PTP frequency calculation
Date:   Thu, 28 Jul 2022 11:18:33 -0700
Message-Id: <20220728181836.3387862-5-anthony.l.nguyen@intel.com>
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

The i40e device has a different clock rate depending on the current link
speed. This requires using a different increment rate for the PTP clock
registers. For slower link speeds, the base increment value is larger.
Directly multiplying the larger increment value by the parts per billion
adjustment might overflow.

To avoid this, the i40e implementation defaults to using the lower
increment value and then multiplying the adjustment afterwards. This causes
a loss of precision for lower link speeds.

We can fix this by using mul_u64_u64_div_u64 instead of performing the
multiplications using standard C operations. On X86, this will use special
instructions that perform the multiplication and division with 128bit
intermediate values. For other architectures, the fallback implementation
will limit the loss of precision for large values. Small adjustments don't
overflow anyways and won't lose precision at all.

This allows first multiplying the base increment value and then performing
the adjustment calculation, since we no longer fear overflowing. It also
makes it easier to convert to the even more precise .adjfine implementation
in a following change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 57a71fa17ed5..15de918abc41 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -353,25 +353,16 @@ static int i40e_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 		ppb = -ppb;
 	}
 
-	freq = I40E_PTP_40GB_INCVAL;
-	freq *= ppb;
-	diff = div_u64(freq, 1000000000ULL);
+	smp_mb(); /* Force any pending update before accessing. */
+	freq = I40E_PTP_40GB_INCVAL * READ_ONCE(pf->ptp_adj_mult);
+	diff = mul_u64_u64_div_u64(freq, (u64)ppb,
+				   1000000000ULL);
 
 	if (neg_adj)
 		adj = I40E_PTP_40GB_INCVAL - diff;
 	else
 		adj = I40E_PTP_40GB_INCVAL + diff;
 
-	/* At some link speeds, the base incval is so large that directly
-	 * multiplying by ppb would result in arithmetic overflow even when
-	 * using a u64. Avoid this by instead calculating the new incval
-	 * always in terms of the 40GbE clock rate and then multiplying by the
-	 * link speed factor afterwards. This does result in slightly lower
-	 * precision at lower link speeds, but it is fairly minor.
-	 */
-	smp_mb(); /* Force any pending update before accessing. */
-	adj *= READ_ONCE(pf->ptp_adj_mult);
-
 	wr32(hw, I40E_PRTTSYN_INC_L, adj & 0xFFFFFFFF);
 	wr32(hw, I40E_PRTTSYN_INC_H, adj >> 32);
 
-- 
2.35.1

