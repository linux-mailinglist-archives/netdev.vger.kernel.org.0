Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2092A4551B7
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241973AbhKRAga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:36:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:3450 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241949AbhKRAgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 19:36:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="234324575"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="234324575"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 16:33:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="736448008"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2021 16:33:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 6/7] i40e: Fix creation of first queue by omitting it if is not power of two
Date:   Wed, 17 Nov 2021 16:31:58 -0800
Message-Id: <20211118003159.245561-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
References: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Reject TCs creation with proper message if the first queue
assignment is not equal to the power of two.
The first queue number was checked too late in the second queue
iteration, if second queue was configured at all. Now if first queue value
is not a power of two, then trying to create qdisc will be rejected.

Fixes: 8f88b3034db3 ("i40e: Add infrastructure for queue channel support")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 59 +++++++--------------
 1 file changed, 19 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 37386a270db5..0a98fab6d019 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5786,24 +5786,6 @@ static void i40e_remove_queue_channels(struct i40e_vsi *vsi)
 	INIT_LIST_HEAD(&vsi->ch_list);
 }
 
-/**
- * i40e_is_any_channel - channel exist or not
- * @vsi: ptr to VSI to which channels are associated with
- *
- * Returns true or false if channel(s) exist for associated VSI or not
- **/
-static bool i40e_is_any_channel(struct i40e_vsi *vsi)
-{
-	struct i40e_channel *ch, *ch_tmp;
-
-	list_for_each_entry_safe(ch, ch_tmp, &vsi->ch_list, list) {
-		if (ch->initialized)
-			return true;
-	}
-
-	return false;
-}
-
 /**
  * i40e_get_max_queues_for_channel
  * @vsi: ptr to VSI to which channels are associated with
@@ -6310,26 +6292,15 @@ int i40e_create_queue_channel(struct i40e_vsi *vsi,
 	/* By default we are in VEPA mode, if this is the first VF/VMDq
 	 * VSI to be added switch to VEB mode.
 	 */
-	if ((!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) ||
-	    (!i40e_is_any_channel(vsi))) {
-		if (!is_power_of_2(vsi->tc_config.tc_info[0].qcount)) {
-			dev_dbg(&pf->pdev->dev,
-				"Failed to create channel. Override queues (%u) not power of 2\n",
-				vsi->tc_config.tc_info[0].qcount);
-			return -EINVAL;
-		}
 
-		if (!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) {
-			pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
+	if (!(pf->flags & I40E_FLAG_VEB_MODE_ENABLED)) {
+		pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 
-			if (vsi->type == I40E_VSI_MAIN) {
-				if (pf->flags & I40E_FLAG_TC_MQPRIO)
-					i40e_do_reset(pf, I40E_PF_RESET_FLAG,
-						      true);
-				else
-					i40e_do_reset_safe(pf,
-							   I40E_PF_RESET_FLAG);
-			}
+		if (vsi->type == I40E_VSI_MAIN) {
+			if (pf->flags & I40E_FLAG_TC_MQPRIO)
+				i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
+			else
+				i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
 		}
 		/* now onwards for main VSI, number of queues will be value
 		 * of TC0's queue count
@@ -7982,12 +7953,20 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 			    vsi->seid);
 		need_reset = true;
 		goto exit;
-	} else {
-		dev_info(&vsi->back->pdev->dev,
-			 "Setup channel (id:%u) utilizing num_queues %d\n",
-			 vsi->seid, vsi->tc_config.tc_info[0].qcount);
+	} else if (enabled_tc &&
+		   (!is_power_of_2(vsi->tc_config.tc_info[0].qcount))) {
+		netdev_info(netdev,
+			    "Failed to create channel. Override queues (%u) not power of 2\n",
+			    vsi->tc_config.tc_info[0].qcount);
+		ret = -EINVAL;
+		need_reset = true;
+		goto exit;
 	}
 
+	dev_info(&vsi->back->pdev->dev,
+		 "Setup channel (id:%u) utilizing num_queues %d\n",
+		 vsi->seid, vsi->tc_config.tc_info[0].qcount);
+
 	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
 			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
-- 
2.31.1

