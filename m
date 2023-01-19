Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E820674523
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjASVnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2D99B100
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163685; x=1705699685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B+FSZEzilh7VQsVo/lMZBEFLwyXrJwYIodfqIjoUlN0=;
  b=hwWN6WTtJrBv192X0ZostybWXpwwjf6BEO+9SRrsjJs/nwpjUA9phnH7
   t5vIly7aq4e+wMS5l77QgnlX83cLUq/H7iyikdz2+rfXS6lFn/oUEo7mL
   hx1h0d6QdowsZbsIETbZ4PdtoDWcZq0dRqu14z0zYKbvLkF8zdwDnzQip
   sAlw/cEolRDCeKqOj0kYIwaJQWI59VD+MNkEl411cnALmE+Gni6IZa7Tf
   Es2ImiB/vZBPKf/L1vgucBISiHkJrPd/1+n6Atc4CNodPn2lPqsPLlNBN
   YotUva+m6p5M18yn4Mq0ZmdxKf7HE+6UQY5/hN7gssDmiOguM5L/G09Ll
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120610"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120610"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589877"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589877"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Siddaraju DH <siddaraju.dh@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 04/15] ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB
Date:   Thu, 19 Jan 2023 13:27:31 -0800
Message-Id: <20230119212742.2106833-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Siddaraju DH <siddaraju.dh@intel.com>

The PHY provides only 39b timestamp. With current timing
implementation, we discard lower 7b, leaving 32b timestamp.
The driver reconstructs the full 64b timestamp by correlating the
32b timestamp with cached_time for performance. The reconstruction
algorithm does both forward & backward interpolation.

The 32b timeval has overflow duration of 2^32 counts ~= 4.23 second.
Due to interpolation in both direction, its now ~= 2.125 second
IIRC, going with at least half a duration, the cached_time is updated
with periodic thread of 1 second (worst-case) periodicity.

But the 1 second periodicity is based on System-timer.
With PPB adjustments, if the 1588 timers increments at say
double the rate, (2s in-place of 1s), the Nyquist rate/half duration
sampling/update of cached_time with 1 second periodic thread will
lead to incorrect interpolations.

Hence we should restrict the PPB adjustments to at least half duration
of cached_time update which translates to 500,000,000 PPB.

Since the periodicity of the cached-time system thread can vary,
it is good to have some buffer time and considering practicality of
PPB adjustments, limiting the max_adj to 100,000,000.

Signed-off-by: Siddaraju DH <siddaraju.dh@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index d63161d73eb1..3abc8db1d065 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2269,7 +2269,7 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 	snprintf(info->name, sizeof(info->name) - 1, "%s-%s-clk",
 		 dev_driver_string(dev), dev_name(dev));
 	info->owner = THIS_MODULE;
-	info->max_adj = 999999999;
+	info->max_adj = 100000000;
 	info->adjtime = ice_ptp_adjtime;
 	info->adjfine = ice_ptp_adjfine;
 	info->gettimex64 = ice_ptp_gettimex64;
-- 
2.38.1

