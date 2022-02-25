Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7304A4C4F17
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiBYTqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbiBYTqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0401210462
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818375; x=1677354375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j7htRT69ylaeA+02bptqMSiDvci8XyyfmDTFRpx/ZiM=;
  b=jjIMCAG5M9Pkzqf18w/qG0wW0Ttpu6mcHaSo3aKzAGaL4sxjxd6aaQrD
   OU7CEAXDuSY2OfJhCJblSRykdCul+4c1TWcNulsFAo9eyox9BeA4lOWRk
   0PvYrh8ZpU6NQnOwYWxKDsI45rK2VTEVsvFM+s5za7Rx4/Hj80vIC1qPl
   iQ61PMYndvHNkHOgQFPVfCEC/HHU2fEyd6ywEtL3PBrEQ7zA1zxXrUIib
   GxwmBEpE1eYQyZ3VKMU3nhy7sj/gr2HMuWf1sjNk9PvDPODaYI76ekOax
   /o2rPpfJKMPurfQXBSoxX1/hvEHztpupy0wyegTiYZoKJA6TA2YKUwc6x
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004864"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004864"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972182"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 5/8] iavf: Fix race in init state
Date:   Fri, 25 Feb 2022 11:46:11 -0800
Message-Id: <20220225194614.136571-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
References: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

When iavf_init_version_check sends VIRTCHNL_OP_GET_VF_RESOURCES
message, the driver will wait for the response after requeueing
the watchdog task in iavf_init_get_resources call stack. The
logic is implemented this way that iavf_init_get_resources has
to be called in order to allocate adapter->vf_res. It is polling
for the AQ response in iavf_get_vf_config function. Expect a
call trace from kernel when adminq_task worker handles this
message first. adapter->vf_res will be NULL in
iavf_virtchnl_completion.

Make the watchdog task not queue the adminq_task if the init
process is not finished yet.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 67349d24dc90..36433d6504b7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2532,7 +2532,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
-	queue_work(iavf_wq, &adapter->adminq_task);
+	if (adapter->state >= __IAVF_DOWN)
+		queue_work(iavf_wq, &adapter->adminq_task);
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
-- 
2.31.1

