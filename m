Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FED4DA460
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346765AbiCOVNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351869AbiCOVNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:13:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29B5574A5
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647378722; x=1678914722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hexcrjPy0P4KcMWDHKaBYnhIFz5iTyp1BwWvGr/ug58=;
  b=UciD9VyX5jt9kuvcrlqwwGkaVOw4i+nFLUVmFa2BIiyVr/OHsIjQjEbD
   qvi+S01OJA1NAN3gQB+vrZimxy6HU/zxqVljVCQlI9lDi+7CUaQYzIRcv
   gOVJr/ahngM227QjwWeOcT8xuOkm91rZIR9OV11uQzMLakCM3YOFP2+7c
   2B6UoAb5FV/AXG5L5IbFdBV44Mm6t44RMJWhv4SRPLuRShvbbVLZOJGTX
   E9dCx85WbsuOv7FoQho1auDZyktPTda3jg/cJCpgO/+ufTWSyHhzV3W3E
   4DfsHzYA8YWuTPi+hV7vdzFBM5HY8SmHXnzAX6T3Tt/tHsM6wOxNqQmVS
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236370472"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="236370472"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 14:12:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="820113217"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2022 14:12:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Dan Carpenter <dan.carpenter@oracle.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/3] iavf: Fix double free in iavf_reset_task
Date:   Tue, 15 Mar 2022 14:12:25 -0700
Message-Id: <20220315211225.2923496-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix double free possibility in iavf_disable_vf, as crit_lock is
freed in caller, iavf_reset_task. Add kernel-doc for iavf_disable_vf.
Remove mutex_unlock in iavf_disable_vf.
Without this patch there is double free scenario, when calling
iavf_reset_task.

Fixes: e85ff9c631e1 ("iavf: Fix deadlock in iavf_reset_task")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 8e644e9ed8da..45570e3f782e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2541,6 +2541,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
 }
 
+/**
+ * iavf_disable_vf - disable VF
+ * @adapter: board private structure
+ *
+ * Set communication failed flag and free all resources.
+ * NOTE: This function is expected to be called with crit_lock being held.
+ **/
 static void iavf_disable_vf(struct iavf_adapter *adapter)
 {
 	struct iavf_mac_filter *f, *ftmp;
@@ -2595,7 +2602,6 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &= ~IFF_UP;
-	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 	iavf_change_state(adapter, __IAVF_DOWN);
 	wake_up(&adapter->down_waitqueue);
-- 
2.31.1

