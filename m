Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1744D258E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiCIBKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiCIBJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:09:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E8A14CD82
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 16:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646787143; x=1678323143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yHxyNsXh0EAxkZhCGJk7xmUm3wFeWDr3ZLvt6tLEtdo=;
  b=ORB8ay1ri0jWKq48p0xz4wiWCj1Ja1kD9hRGNLILQkODumPa3oe3fE1+
   CLvrU8boX5XpVMqeL1NJLlVtecDWguyCNVCVZkgodX43i+8SE9NaKkDPa
   Kyt6H/zkJ0dpFFpdWlqPkBRCAC7/H524cVCCfRMS6l02R1ZMM39bMcRKz
   01RF74MdcXqV+d7eyKofSODGci7sTM+XVihzq3+0Idwt58xzCMWGLs6EB
   VcDmP7+BX1+jcGoSete0Fcfh24kBSHmB6GJGRERj/2ZKE8erpJRCJV0K3
   kRqagPPOTnZHPcTgDM4KM1jUQf84fVRee6m3mp5fR7rTywvsb82Osbeud
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341273487"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="341273487"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 15:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="537778705"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2022 15:44:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Maloszewski <michal.maloszewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net v2 2/7] iavf: Fix adopting new combined setting
Date:   Tue,  8 Mar 2022 15:45:08 -0800
Message-Id: <20220308234513.1089152-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308234513.1089152-1-anthony.l.nguyen@intel.com>
References: <20220308234513.1089152-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Maloszewski <michal.maloszewski@intel.com>

In some cases overloaded flag IAVF_FLAG_REINIT_ITR_NEEDED
which should indicate that interrupts need to be completely
reinitialized during reset leads to RTNL deadlocks using ethtool -C
while a reset is in progress.
To fix, it was added a new flag IAVF_FLAG_REINIT_MSIX_NEEDED
used to trigger MSI-X reinit.
New combined setting is fixed adopt after VF reset.
This has been implemented by call reinit interrupt scheme
during VF reset.
Without this fix new combined setting has never been adopted.

Fixes: 209f2f9c7181 ("iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 negotiation")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 89423947ee65..4babe4705a55 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -288,6 +288,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_REINIT_ITR_NEEDED		BIT(16)
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
 #define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
+#define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index dcf24264c7ea..8e644e9ed8da 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2120,7 +2120,7 @@ int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter)
 			"Requested %d queues, but PF only gave us %d.\n",
 			num_req_queues,
 			adapter->vsi_res->num_queue_pairs);
-		adapter->flags |= IAVF_FLAG_REINIT_ITR_NEEDED;
+		adapter->flags |= IAVF_FLAG_REINIT_MSIX_NEEDED;
 		adapter->num_req_queues = adapter->vsi_res->num_queue_pairs;
 		iavf_schedule_reset(adapter);
 
@@ -2727,7 +2727,8 @@ static void iavf_reset_task(struct work_struct *work)
 			 err);
 	adapter->aq_required = 0;
 
-	if (adapter->flags & IAVF_FLAG_REINIT_ITR_NEEDED) {
+	if ((adapter->flags & IAVF_FLAG_REINIT_MSIX_NEEDED) ||
+	    (adapter->flags & IAVF_FLAG_REINIT_ITR_NEEDED)) {
 		err = iavf_reinit_interrupt_scheme(adapter);
 		if (err)
 			goto reset_err;
@@ -2799,12 +2800,13 @@ static void iavf_reset_task(struct work_struct *work)
 		if (err)
 			goto reset_err;
 
-		if (adapter->flags & IAVF_FLAG_REINIT_ITR_NEEDED) {
+		if ((adapter->flags & IAVF_FLAG_REINIT_MSIX_NEEDED) ||
+		    (adapter->flags & IAVF_FLAG_REINIT_ITR_NEEDED)) {
 			err = iavf_request_traffic_irqs(adapter, netdev->name);
 			if (err)
 				goto reset_err;
 
-			adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
+			adapter->flags &= ~IAVF_FLAG_REINIT_MSIX_NEEDED;
 		}
 
 		iavf_configure(adapter);
@@ -2819,6 +2821,9 @@ static void iavf_reset_task(struct work_struct *work)
 		iavf_change_state(adapter, __IAVF_DOWN);
 		wake_up(&adapter->down_waitqueue);
 	}
+
+	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
+
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 
-- 
2.31.1

