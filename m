Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C66349C41
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 23:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCYWaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:30:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:49802 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhCYW3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 18:29:53 -0400
IronPort-SDR: VJwyLRu8z9MQE34h2M+Bl3tg/4kpOmWk3Mdfb1zBEhmIE0MbqEnR00xei5XxnL/3cKLLqvR73v
 5RU53rtTY26Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191063404"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191063404"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 15:29:52 -0700
IronPort-SDR: 1Xd1IpSJ9G5/voQL0nvCHuJgkiFyelzZmJ0weD2ZCyAbLYdBkDgmYijeTw2vQIZ7d3RtNCPQQS
 q7lQJ1hoA12Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375246728"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 15:29:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 4/4] i40e: Fix oops at i40e_rebuild()
Date:   Thu, 25 Mar 2021 15:31:19 -0700
Message-Id: <20210325223119.3991796-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Setup TC before the i40e_setup_pf_switch() call.
Memory must be initialized for all the queues
before using its resources.

Previously it could be possible that a call:
xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
rx_ring->queue_index, rx_ring->q_vector->napi.napi_id);
was made with q_vector being null.

Oops could show up with the following sequence:
- no driver loaded
- FW LLDP agent is on (flag disable-fw-lldp:off)
- link is up
- DCB configured with number of Traffic Classes that will not divide
  completely the default number of queues (usually cpu cores)
- driver load
- set private flag: disable-fw-lldp:on

Fixes: 4b208eaa8078 ("i40e: Add init and default config of software based DCB")
Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 17f3b800640e..f67f0cc9dadf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10573,12 +10573,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 		goto end_core_reset;
 	}
 
-	if (!lock_acquired)
-		rtnl_lock();
-	ret = i40e_setup_pf_switch(pf, reinit);
-	if (ret)
-		goto end_unlock;
-
 #ifdef CONFIG_I40E_DCB
 	/* Enable FW to write a default DCB config on link-up
 	 * unless I40E_FLAG_TC_MQPRIO was enabled or DCB
@@ -10607,6 +10601,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 
 #endif /* CONFIG_I40E_DCB */
+	if (!lock_acquired)
+		rtnl_lock();
+	ret = i40e_setup_pf_switch(pf, reinit);
+	if (ret)
+		goto end_unlock;
 
 	/* The driver only wants link up/down and module qualification
 	 * reports from firmware.  Note the negative logic.
-- 
2.26.2

