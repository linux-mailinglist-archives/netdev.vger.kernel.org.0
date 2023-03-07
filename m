Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0706AF85B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCGWPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCGWPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:15:02 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F218580FD
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678227300; x=1709763300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UkCl5H9tKKbhPrhzKXd/Azgsc36jd6TVUziLbhwhJRc=;
  b=DBAhBqWeXvoGFlmc1d6wvVGaPXSWfdOKpQy0GFHAri+cXbHnNbVEVF86
   pDsR2/xKvgMOmI1d+vJ2wBYAc2Jj+WqFmBLRxBAM19lzJZ9sXXB+criuP
   cusxjC9WtVeHmdexmuZc3WN5JnVCSPyFXRQMXzv+71v/hLoPt6woFW5aP
   +pPYwUlPfu9PvKF0owDqwziz0X9VuYPN7VWxxUCLiq8Lb34hmjJUEfDDw
   rwXaR3Glt9MyUKWq+gId2FI6nlw0T1afHtpg9Cr0fzfbwifsbnvW95fSd
   rOhaApbsnkB3Pt5pZ6yutR+cQH39pelP5S0MkYy44uZ3yTwQuNoY2k/f1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338310815"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="338310815"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:14:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626701532"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="626701532"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 14:14:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next v2 3/3] igc: Clean up and optimize watchdog task
Date:   Tue,  7 Mar 2023 14:13:32 -0800
Message-Id: <20230307221332.3997881-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
References: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225/i226 parts used only one media type copper. The copper media type is
not replaceable. Clean up the code accordingly, and remove the obsolete
media replacement and reset options.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  2 --
 drivers/net/ethernet/intel/igc/igc_main.c | 17 -----------------
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index c0c00b8bd8d8..34aebf00a512 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -294,8 +294,6 @@ extern char igc_driver_name[];
 #define IGC_FLAG_PTP			BIT(8)
 #define IGC_FLAG_WOL_SUPPORTED		BIT(8)
 #define IGC_FLAG_NEED_LINK_UPDATE	BIT(9)
-#define IGC_FLAG_MEDIA_RESET		BIT(10)
-#define IGC_FLAG_MAS_ENABLE		BIT(12)
 #define IGC_FLAG_HAS_MSIX		BIT(13)
 #define IGC_FLAG_EEE			BIT(14)
 #define IGC_FLAG_VLAN_PROMISC		BIT(15)
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1e1245085a36..2c40796c151f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5578,25 +5578,8 @@ static void igc_watchdog_task(struct work_struct *work)
 				mod_timer(&adapter->phy_info_timer,
 					  round_jiffies(jiffies + 2 * HZ));
 
-			/* link is down, time to check for alternate media */
-			if (adapter->flags & IGC_FLAG_MAS_ENABLE) {
-				if (adapter->flags & IGC_FLAG_MEDIA_RESET) {
-					schedule_work(&adapter->reset_task);
-					/* return immediately */
-					return;
-				}
-			}
 			pm_schedule_suspend(netdev->dev.parent,
 					    MSEC_PER_SEC * 5);
-
-		/* also check for alternate media here */
-		} else if (!netif_carrier_ok(netdev) &&
-			   (adapter->flags & IGC_FLAG_MAS_ENABLE)) {
-			if (adapter->flags & IGC_FLAG_MEDIA_RESET) {
-				schedule_work(&adapter->reset_task);
-				/* return immediately */
-				return;
-			}
 		}
 	}
 
-- 
2.38.1

