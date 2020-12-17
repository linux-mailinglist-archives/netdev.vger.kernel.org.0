Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5301E2DDB85
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgLQWfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:35:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:25112 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732093AbgLQWfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 17:35:02 -0500
IronPort-SDR: uPkKWzOBNkKqXU7Q6YfmcOOSKsqYulFoD9BIDgfrzWqFn2UCxt+/0xtbjvbBF/Z4vyMV/XkueR
 9j3I4LGSVtMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="175444100"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="175444100"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:34:21 -0800
IronPort-SDR: sxFwv9nF/bHbn2VxP+tv+tBqc4R2qDQGqlD32istnV7sAm0m7fUk/snSfU9XfpVx4W64HW+qnq
 4P5ZR0wWj6CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="370133355"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2020 14:34:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [net 2/2] iavf: fix double-release of rtnl_lock
Date:   Thu, 17 Dec 2020 14:34:18 -0800
Message-Id: <20201217223418.3134992-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
References: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

This code does not jump to exit on an error in iavf_lan_add_device(),
so the rtnl_unlock() from the normal path will follow.

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95543dfd4fe7..0a867d64d467 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1834,11 +1834,9 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	netif_tx_stop_all_queues(netdev);
 	if (CLIENT_ALLOWED(adapter)) {
 		err = iavf_lan_add_device(adapter);
-		if (err) {
-			rtnl_unlock();
+		if (err)
 			dev_info(&pdev->dev, "Failed to add VF to client API service list: %d\n",
 				 err);
-		}
 	}
 	dev_info(&pdev->dev, "MAC address: %pM\n", adapter->hw.mac.addr);
 	if (netdev->features & NETIF_F_GRO)
-- 
2.26.2

