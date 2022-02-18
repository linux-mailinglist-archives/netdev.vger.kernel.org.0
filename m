Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE8C4BC261
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbiBRV4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:56:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiBRV4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:56:12 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE85A53B64
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645221355; x=1676757355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lqw9UWdAPJx7izE/0kEVjk1G67T/XMKRpEmOsTcc5+o=;
  b=jubGFByP+siRPkBh4upCMES9IPLBuD3aLJWLkvaZrEaQ1xd4T1d6UcVx
   ZG4Zolc0irzJBCkUfpxvn4PDUOljWXxYOuBnAh2YkAit/Y0gdE53y7g8F
   bRm/ZIrKWmMStxcIkUYGbjiIlZG+jYYPK+0rBw4UfRUMcgU3av3sYbDwc
   cqCTuuHlLU72Wa1BzOEA7Mnjlmay3tJaaxGHXPgMlEbm7S/9APkyqf3Ac
   I8osiUQO5/wARXeEjVH8sinp/cP5ltKRDV4OZe64YgLAQucTW9f3BsyAw
   JnwIPj8pvBzWTZyGt91jcWQ97r/vMum1k3m4lRQoshurSkjE16lscoJrc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251179163"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251179163"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:55:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="626757375"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2022 13:55:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 4/5] ice: check the return of ice_ptp_gettimex64
Date:   Fri, 18 Feb 2022 13:55:53 -0800
Message-Id: <20220218215554.415323-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
References: <20220218215554.415323-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issue
time64.h:69:50: warning: The left operand of '+'
  is a garbage value
  set_normalized_timespec64(&ts_delta, lhs.tv_sec + rhs.tv_sec,
                                       ~~~~~~~~~~ ^
In ice_ptp_adjtime_nonatomic(), the timespec64 variable 'now'
is set by ice_ptp_gettimex64().  This function can fail
with -EBUSY, so 'now' can have a gargbage value.
So check the return.

Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ae291d442539..000c39d163a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1533,9 +1533,12 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 static int ice_ptp_adjtime_nonatomic(struct ptp_clock_info *info, s64 delta)
 {
 	struct timespec64 now, then;
+	int ret;
 
 	then = ns_to_timespec64(delta);
-	ice_ptp_gettimex64(info, &now, NULL);
+	ret = ice_ptp_gettimex64(info, &now, NULL);
+	if (ret)
+		return ret;
 	now = timespec64_add(now, then);
 
 	return ice_ptp_settime64(info, (const struct timespec64 *)&now);
-- 
2.31.1

