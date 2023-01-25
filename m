Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0867BE8D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbjAYVaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbjAYV34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:29:56 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9C261D71
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674682162; x=1706218162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ddJoTVPJOXlWzIxWCTzDCdfiRXKiRIrlXCFfHfEjYC0=;
  b=eyDloLDarT3IvpSK7vqzEbrZsimAMs3ka20ZQdnT9mz8miab8zH0tMOp
   0ng7iCefQoW1tOjZKEL90To4kDGZm86SKbB7OqCB9C+G0z5rJ8PZcfrUJ
   dSnhcSXzEY5lVClAv0SdjwgS09lP/1gewGwaYeo9FV0sZrhk8JfuzB7ot
   xqrV5aJXWszZd4Xkit1It9y6bDoG/eqLjASrSbPLGxo5eBfyK1Hz+PWvu
   7Z7tjq1/FTovDv/0Dz9L2LthpHVpVvmQNtHxdEOSIvpX3x8BTKnXF5Yen
   gW4EpDJSnlMrsWGpzDwZqCzfJtwDRoRpGPL5GESE+jrBh3arWYQ6DPtE6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="310261544"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="310261544"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:26:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="731189741"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="731189741"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2023 13:26:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 3/3] igc: Clean up and optimize watchdog task
Date:   Wed, 25 Jan 2023 13:27:02 -0800
Message-Id: <20230125212702.4030240-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
References: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 811f842a20a4..13088b5bcf5b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5561,25 +5561,8 @@ static void igc_watchdog_task(struct work_struct *work)
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

