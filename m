Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28956EA04E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjDTXyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjDTXxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8370561BD
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034822; x=1713570822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aoXjpjGI2ZFNjd0/NuuXG0cmiFPWWMM4bY1+igD4tVI=;
  b=TUS/6195Rbf6NnexfFn99VvKmNYy15bhcxO5KjhO+ESaJdB1XPIJtW5Z
   aWvlevYEfn+tNf0x6ZqJxTLbC/ivxdCDWGW90vwvea75lPjtd1q5M5kZL
   BG6Xy7fvvP4NK4bH6hhxFvC/ieF+Lutem3HWlcm7YfoXbau7v14P1Odl5
   OwNz37alK2f0bYzfWOBltNL4q8xjKHV6jS3zINZdUwATd1c+1h2/++/BJ
   QeeCtoqYExYkFvYFxXy5iTReVcLdgadfior9+3LFm5ZHsfZJqGpTWJLYr
   C9UZ5F4QlVbceFBjx8eG3y5cze4veSdVJtdLmG0GMbHaRIss8JAMklGdX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368459"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368459"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714254"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714254"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Schmidt <mschmidt@redhat.com>, anthony.l.nguyen@intel.com,
        johan@kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 6/6] ice: sleep, don't busy-wait, in the SQ send retry loop
Date:   Thu, 20 Apr 2023 16:50:33 -0700
Message-Id: <20230420235033.2971567-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

10 ms is a lot of time to spend busy-waiting. Sleeping is clearly
allowed here, because we have just returned from ice_sq_send_cmd(),
which takes a mutex.

On kernels with HZ=100, this msleep may be twice as long, but I don't
think it matters.
I did not actually observe any retries happening here.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c6200564304e..0157f6e98d3e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1643,7 +1643,7 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
 
-		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
+		msleep(ICE_SQ_SEND_DELAY_TIME_MS);
 
 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
 
-- 
2.38.1

