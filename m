Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A434551B8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbhKRAgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:36:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:3450 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241957AbhKRAgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 19:36:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="234324577"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="234324577"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 16:33:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="736448014"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2021 16:33:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 7/7] i40e: Fix display error code in dmesg
Date:   Wed, 17 Nov 2021 16:31:59 -0800
Message-Id: <20211118003159.245561-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
References: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

Fix misleading display error in dmesg if tc filter return fail.
Only i40e status error code should be converted to string, not linux
error code. Otherwise, we return false information about the error.

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 0a98fab6d019..e118cf9265c7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8531,9 +8531,8 @@ static int i40e_configure_clsflower(struct i40e_vsi *vsi,
 		err = i40e_add_del_cloud_filter(vsi, filter, true);
 
 	if (err) {
-		dev_err(&pf->pdev->dev,
-			"Failed to add cloud filter, err %s\n",
-			i40e_stat_str(&pf->hw, err));
+		dev_err(&pf->pdev->dev, "Failed to add cloud filter, err %d\n",
+			err);
 		goto err;
 	}
 
-- 
2.31.1

