Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDF45762A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhKSSRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:52700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231685AbhKSSRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:17:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="221683612"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="221683612"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 10:14:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="508004012"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 19 Nov 2021 10:14:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/4] iavf: Fix deadlock occurrence during resetting VF interface
Date:   Fri, 19 Nov 2021 10:12:41 -0800
Message-Id: <20211119181243.1839441-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
References: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

System hangs if close the interface is called from the kernel during
the interface is in resetting state.
During resetting operation the link is closing but kernel didn't
know it and it tried to close this interface again what sometimes
led to deadlock.
Inform kernel about current state of interface
and turn off the flag IFF_UP when interface is closing until reset
is finished.
Previously it was most likely to hang the system when kernel
(network manager) tried to close the interface in the same time
when interface was in resetting state because of deadlock.

Fixes: 3c8e0b989aa1 ("i40vf: don't stop me now")
Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 336e6bf95e48..84680777ac12 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2254,6 +2254,7 @@ static void iavf_reset_task(struct work_struct *work)
 		   (adapter->state == __IAVF_RESETTING));
 
 	if (running) {
+		netdev->flags &= ~IFF_UP;
 		netif_carrier_off(netdev);
 		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
@@ -2365,7 +2366,7 @@ static void iavf_reset_task(struct work_struct *work)
 		 * to __IAVF_RUNNING
 		 */
 		iavf_up_complete(adapter);
-
+		netdev->flags |= IFF_UP;
 		iavf_irq_enable(adapter, true);
 	} else {
 		iavf_change_state(adapter, __IAVF_DOWN);
@@ -2378,8 +2379,10 @@ static void iavf_reset_task(struct work_struct *work)
 reset_err:
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
-	if (running)
+	if (running) {
 		iavf_change_state(adapter, __IAVF_RUNNING);
+		netdev->flags |= IFF_UP;
+	}
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }
-- 
2.31.1

