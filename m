Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0C5AB868
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiIBSjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiIBSjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:39:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE8788DD0
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 11:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662143942; x=1693679942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B8ZVWZOjwt2fOVDnzm5YZ89zmhfVCkqhsno6JjREpCA=;
  b=SCXRfUhawFVFaO0cQr19gC36K5SHtcAkxi02b9NhHaTEAHzQPbf3ca6x
   FTC+IPM2IW+4sLsMjv+gKxF+2IPhX3nTYBKOXxfnCReFJr3O8VUcHxd9H
   i+tSVQzVgFY8pP5nEWC0/K8RJHyUlJAe4tmR3mQf5Gj861JXsa/tBbdM1
   Dr4TkNWhoFg3ndVKtQNIRKn2kaNx/O3Px5i6g2F4cIWAw1NXilp/Y57nO
   CsdINzO7ybJR1+mEtIrdbj62pSY4kZ7CyDMoUFynojujY49AgPdmoN1Ta
   +SMbsSJWvMW3btSHkkDMPqNILsaEmg6z1/zCPDbENRI90H0Lc8Eyt7WDC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357768802"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="357768802"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 11:39:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="590170962"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 11:39:01 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/3] iavf: Detach device during reset task
Date:   Fri,  2 Sep 2022 11:38:57 -0700
Message-Id: <20220902183857.1252065-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
References: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
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

From: Ivan Vecera <ivecera@redhat.com>

iavf_reset_task() takes crit_lock at the beginning and holds
it during whole call. The function subsequently calls
iavf_init_interrupt_scheme() that grabs RTNL. Problem occurs
when userspace initiates during the reset task any ndo callback
that runs under RTNL like iavf_open() because some of that
functions tries to take crit_lock. This leads to classic A-B B-A
deadlock scenario.

To resolve this situation the device should be detached in
iavf_reset_task() prior taking crit_lock to avoid subsequent
ndos running under RTNL and reattach the device at the end.

Fixes: 62fe2a865e6d ("i40evf: add missing rtnl_lock() around i40evf_set_interrupt_capability")
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
Cc: SlawomirX Laba <slawomirx.laba@intel.com>
Tested-by: Vitaly Grinberg <vgrinber@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f39440ad5c50..10aa99dfdcdb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2877,6 +2877,11 @@ static void iavf_reset_task(struct work_struct *work)
 	int i = 0, err;
 	bool running;
 
+	/* Detach interface to avoid subsequent NDO callbacks */
+	rtnl_lock();
+	netif_device_detach(netdev);
+	rtnl_unlock();
+
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
@@ -2884,7 +2889,7 @@ static void iavf_reset_task(struct work_struct *work)
 		if (adapter->state != __IAVF_REMOVE)
 			queue_work(iavf_wq, &adapter->reset_task);
 
-		return;
+		goto reset_finish;
 	}
 
 	while (!mutex_trylock(&adapter->client_lock))
@@ -2954,7 +2959,6 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
-		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
@@ -3084,7 +3088,7 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 
-	return;
+	goto reset_finish;
 reset_err:
 	if (running) {
 		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -3095,6 +3099,10 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
+reset_finish:
+	rtnl_lock();
+	netif_device_attach(netdev);
+	rtnl_unlock();
 }
 
 /**
-- 
2.35.1

