Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C897358B6E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhDHReW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:34:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:25284 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232406AbhDHReK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 13:34:10 -0400
IronPort-SDR: 94jqeAmVGILwuL/n7LTt4CfB2gyvp7gzigrNJ/YZV0WD1VLVt45erOMQH5THOwdb5HhE2QdARp
 L1+hWFoklaaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="181132910"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="181132910"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 10:33:58 -0700
IronPort-SDR: mACmU2Wobo2yKZIsYRHaRAcK8gKqtpYEHftWRhIVWdo3xqqGVkdeYlYCjLy/KJ+3kVHN31xZMs
 stQe6cv+BWVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="422343455"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2021 10:33:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 4/6] i40e: Fix sparse error: 'vsi->netdev' could be null
Date:   Thu,  8 Apr 2021 10:35:35 -0700
Message-Id: <20210408173537.3519606-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
References: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Remove vsi->netdev->name from the trace.
This is redundant information. With the devinfo trace, the adapter
is already identifiable.

Previously following error was produced when compiling against sparse.
i40e_main.c:2571 i40e_sync_vsi_filters() error:
	we previously assumed 'vsi->netdev' could be null (see line 2323)

Fixes: b603f9dc20af ("i40e: Log info when PF is entering and leaving Allmulti mode.")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index af6c25fa493c..c0a4bc2caae9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2560,8 +2560,7 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 				 i40e_stat_str(hw, aq_ret),
 				 i40e_aq_str(hw, hw->aq.asq_last_status));
 		} else {
-			dev_info(&pf->pdev->dev, "%s is %s allmulti mode.\n",
-				 vsi->netdev->name,
+			dev_info(&pf->pdev->dev, "%s allmulti mode.\n",
 				 cur_multipromisc ? "entering" : "leaving");
 		}
 	}
-- 
2.26.2

