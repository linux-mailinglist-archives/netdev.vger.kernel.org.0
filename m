Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B43337BC5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCKSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:08:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:47785 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhCKSH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:07:59 -0500
IronPort-SDR: AlGc3xUEnn63CO/Ms21Z3+VNbRR0e4MRLJI8jl9xHc58X5BAOeM+DGGS13/FFYsU2Z9udg+yL7
 IxTVeifvNA3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188809481"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188809481"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:07:58 -0800
IronPort-SDR: Sa4ovxHUg+cKVHc7C+ae5MQmJE+Llwg5aW9zH/TavSm1V/N0GTpVmcV9D8ASrMFELBJWE5fbzo
 +CvFtlZTSXKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="409570554"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 10:07:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com,
        Malli C <mallikarjuna.chilakala@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 2/6] igc: Fix Pause Frame Advertising
Date:   Thu, 11 Mar 2021 10:09:11 -0800
Message-Id: <20210311180915.1489936-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
References: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

Fix Pause Frame Advertising when getting the advertisement via ethtool.
Remove setting the "advertising" bit in link_ksettings during default
case when Tx and Rx are in off state with Auto Negotiate off.

Below is the original output of advertisement link during Tx and Rx off:
Advertised pause frame use: Symmetric Receive-only

Expected output:
Advertised pause frame use: No

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reviewed-by: Malli C <mallikarjuna.chilakala@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 824a6c454bca..67a4aed45fc2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1725,9 +1725,7 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 						     Asym_Pause);
 		break;
 	default:
-		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     Asym_Pause);
+		break;
 	}
 
 	status = pm_runtime_suspended(&adapter->pdev->dev) ?
-- 
2.26.2

