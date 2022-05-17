Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BBE52A9EC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351838AbiEQSFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346329AbiEQSE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:04:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C4A50E35
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652810650; x=1684346650;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yEV/jBrERDbWGmme4F5AqIz41A0GrBJ4z3YCxeW54og=;
  b=mWZ2AfPuIKtMepuRObELSCav/oh8nbsL8Zi4B7rv9qEPdvVKTF1/OLHZ
   Fh5srm5zH5ZlYyVaxMeqwNLBFia7oWaifMDg0hBKFf0esQZviG/+zcMkJ
   lSSusJwJVDHUCIZhCMciQ2cdp5o0IdYyinWHD921F5FHmYIfqYjN2rN3j
   NJdecs7OoHcDSjBetcTEu9vxN98zgRq5Fffw+Lbh4qjNH+csMT5Xh3nrQ
   Na1yvGUcVvDTV7d4I2WXxT5hOlEwJ9KnfNmoCLRzvUnw5ZJwM3M+uEZ6R
   KLwW4kDqrqAEGsqX3BngEELOrqAj83odsdyqIMKzqqVg1UD/6HojbV3nH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="258835689"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="258835689"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 11:04:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="672973339"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 17 May 2022 11:04:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Kevin Mitchell <kevmitch@arista.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/1] igb: skip phy status check where unavailable
Date:   Tue, 17 May 2022 11:01:05 -0700
Message-Id: <20220517180105.1758335-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Mitchell <kevmitch@arista.com>

igb_read_phy_reg() will silently return, leaving phy_data untouched, if
hw->ops.read_reg isn't set. Depending on the uninitialized value of
phy_data, this led to the phy status check either succeeding immediately
or looping continuously for 2 seconds before emitting a noisy err-level
timeout. This message went out to the console even though there was no
actual problem.

Instead, first check if there is read_reg function pointer. If not,
proceed without trying to check the phy status register.

Fixes: b72f3f72005d ("igb: When GbE link up, wait for Remote receiver status condition")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dc..68be2976f539 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5505,7 +5505,8 @@ static void igb_watchdog_task(struct work_struct *work)
 				break;
 			}
 
-			if (adapter->link_speed != SPEED_1000)
+			if (adapter->link_speed != SPEED_1000 ||
+			    !hw->phy.ops.read_reg)
 				goto no_wait;
 
 			/* wait for Remote receiver status OK */
-- 
2.35.1

