Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564D95845AB
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiG1SVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiG1SVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:21:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9361C10C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659032505; x=1690568505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VjRUrWD3hb298b4VeGsQkEJZQ4h467xlMyFQgIWcBDY=;
  b=SlLDc7H4HFOVNBfmbXcGi3mFRow6nNn5o+Bsujy88bxln+YQkaRbqKac
   atVgpAXffvGLYI1jnmULY3whQStV+AHkDIRpSSDjO4gVOkgz4+ELx/BfN
   7KJdBdQqSdtrEyS46lNZF7Q9TFVPWF7VeI4lgnXK5QDzeWsI/3GC6vY4m
   vCEiO59tejJZi2dl33z7QsjAZVmN3HVI2on3m6W8USqdvXOZwmlkgbj8E
   /EV4o6ZQX+AaykZuYFoyB9avltnEm+TxD6ElnC1H3Y1zgCaVW5slLqb4/
   wL0H/hXdS0DfxJ+frU8snGXt1kAW26o5lws8AX6xHlTfrtz35FWUlVGZw
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268348906"
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="268348906"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,198,1654585200"; 
   d="scan'208";a="727456617"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2022 11:21:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/7] e1000e: remove unnecessary range check in e1000e_phc_adjfreq
Date:   Thu, 28 Jul 2022 11:18:31 -0700
Message-Id: <20220728181836.3387862-3-anthony.l.nguyen@intel.com>
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

The e1000e_phc_adjfreq function validates that the input delta is within
the maximum range. This is already handled by the core PTP code and this is
a duplicate and thus unnecessary check. It also complicates refactoring to
use the newer .adjfine implementation, where the input is no longer
specified in parts per billion. Remove the range validation check.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ptp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index eb5c014c02fb..432e04ce8c4e 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -33,9 +33,6 @@ static int e1000e_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	u32 timinca, incvalue;
 	s32 ret_val;
 
-	if ((delta > ptp->max_adj) || (delta <= -1000000000))
-		return -EINVAL;
-
 	if (delta < 0) {
 		neg_adj = true;
 		delta = -delta;
-- 
2.35.1

