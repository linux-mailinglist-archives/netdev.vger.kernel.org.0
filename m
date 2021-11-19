Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E26457629
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhKSSRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:52700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhKSSRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:17:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="221683611"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="221683611"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 10:14:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="508004007"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 19 Nov 2021 10:14:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net 1/4] iavf: Prevent changing static ITR values if adaptive moderation is on
Date:   Fri, 19 Nov 2021 10:12:40 -0800
Message-Id: <20211119181243.1839441-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
References: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>

Resolve being able to change static values on VF when adaptive interrupt
moderation is enabled.

This problem is fixed by checking the interrupt settings is not
a combination of change of static value while adaptive interrupt
moderation is turned on.

Without this fix, the user would be able to change static values
on VF with adaptive moderation enabled.

Fixes: 65e87c0398f5 ("i40evf: support queue-specific settings for interrupt moderation")
Signed-off-by: Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 144a77679359..71b23922089f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -723,12 +723,31 @@ static int iavf_get_per_queue_coalesce(struct net_device *netdev, u32 queue,
  *
  * Change the ITR settings for a specific queue.
  **/
-static void iavf_set_itr_per_queue(struct iavf_adapter *adapter,
-				   struct ethtool_coalesce *ec, int queue)
+static int iavf_set_itr_per_queue(struct iavf_adapter *adapter,
+				  struct ethtool_coalesce *ec, int queue)
 {
 	struct iavf_ring *rx_ring = &adapter->rx_rings[queue];
 	struct iavf_ring *tx_ring = &adapter->tx_rings[queue];
 	struct iavf_q_vector *q_vector;
+	u16 itr_setting;
+
+	itr_setting = rx_ring->itr_setting & ~IAVF_ITR_DYNAMIC;
+
+	if (ec->rx_coalesce_usecs != itr_setting &&
+	    ec->use_adaptive_rx_coalesce) {
+		netif_info(adapter, drv, adapter->netdev,
+			   "Rx interrupt throttling cannot be changed if adaptive-rx is enabled\n");
+		return -EINVAL;
+	}
+
+	itr_setting = tx_ring->itr_setting & ~IAVF_ITR_DYNAMIC;
+
+	if (ec->tx_coalesce_usecs != itr_setting &&
+	    ec->use_adaptive_tx_coalesce) {
+		netif_info(adapter, drv, adapter->netdev,
+			   "Tx interrupt throttling cannot be changed if adaptive-tx is enabled\n");
+		return -EINVAL;
+	}
 
 	rx_ring->itr_setting = ITR_REG_ALIGN(ec->rx_coalesce_usecs);
 	tx_ring->itr_setting = ITR_REG_ALIGN(ec->tx_coalesce_usecs);
@@ -751,6 +770,7 @@ static void iavf_set_itr_per_queue(struct iavf_adapter *adapter,
 	 * the Tx and Rx ITR values based on the values we have entered
 	 * into the q_vector, no need to write the values now.
 	 */
+	return 0;
 }
 
 /**
@@ -792,9 +812,11 @@ static int __iavf_set_coalesce(struct net_device *netdev,
 	 */
 	if (queue < 0) {
 		for (i = 0; i < adapter->num_active_queues; i++)
-			iavf_set_itr_per_queue(adapter, ec, i);
+			if (iavf_set_itr_per_queue(adapter, ec, i))
+				return -EINVAL;
 	} else if (queue < adapter->num_active_queues) {
-		iavf_set_itr_per_queue(adapter, ec, queue);
+		if (iavf_set_itr_per_queue(adapter, ec, queue))
+			return -EINVAL;
 	} else {
 		netif_info(adapter, drv, netdev, "Invalid queue value, queue range is 0 - %d\n",
 			   adapter->num_active_queues - 1);
-- 
2.31.1

