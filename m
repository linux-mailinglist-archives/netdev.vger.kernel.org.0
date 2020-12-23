Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C1C2E22CE
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgLWXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:37:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:27359 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727160AbgLWXhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 18:37:51 -0500
IronPort-SDR: zyQnZJYITRPV+LV7f4351+BD1Mh0jnM3k2IvGo5ib6aHEmsNVG+namWMeyqD+QfFw8kV1fENJg
 47OVoSQbemHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="176184741"
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="176184741"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 15:36:29 -0800
IronPort-SDR: pMa5xEuQFnKr0H4wa4P4RXmOHEwPzSVG2fQEaBlJ84U9iHCEEvwNQHFji0GcxJKU41sRwM14Mv
 F05/0Or6/O0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="345253128"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Dec 2020 15:36:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mario Limonciello <mario.limonciello@dell.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, alexander.duyck@gmail.com,
        sasha.neftin@intel.com, darcari@redhat.com, Yijun.Shen@dell.com,
        Perry.Yuan@dell.com, anthony.wong@canonical.com,
        hdegoede@redhat.com, Yijun Shen <Yijun.shen@dell.com>
Subject: [net 1/4] e1000e: Only run S0ix flows if shutdown succeeded
Date:   Wed, 23 Dec 2020 15:36:22 -0800
Message-Id: <20201223233625.92519-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
References: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

If the shutdown failed, the part will be thawed and running
S0ix flows will put it into an undefined state.

Reported-by: Alexander Duyck <alexander.duyck@gmail.com>
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 128ab6898070..6588f5d4a2be 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6970,13 +6970,14 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	e1000e_pm_freeze(dev);
 
 	rc = __e1000_shutdown(pdev, false);
-	if (rc)
+	if (rc) {
 		e1000e_pm_thaw(dev);
-
-	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
-		e1000e_s0ix_entry_flow(adapter);
+	} else {
+		/* Introduce S0ix implementation */
+		if (hw->mac.type >= e1000_pch_cnp &&
+		    !e1000e_check_me(hw->adapter->pdev->device))
+			e1000e_s0ix_entry_flow(adapter);
+	}
 
 	return rc;
 }
-- 
2.26.2

