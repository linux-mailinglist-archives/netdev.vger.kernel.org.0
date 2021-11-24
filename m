Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECD45CAF7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbhKXR2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:28:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:35653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243330AbhKXR2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298734837"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="298734837"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 09:18:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="597738923"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2021 09:18:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Witold Fijalkowski <witoldx.fijalkowski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 12/12] iavf: Fix displaying queue statistics shown by ethtool
Date:   Wed, 24 Nov 2021 09:16:52 -0800
Message-Id: <20211124171652.831184-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Driver provided too many lines as an output to ethtool -S command.
Return actual length of string set of ethtool stats. Instead of predefined
maximal value use the actual value on netdev, iterate over active queues.
Without this patch, ethtool -S report would produce additional
erroneous lines of queues that are not configured.

Signed-off-by: Witold Fijalkowski <witoldx.fijalkowski@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 30 ++++++++++++-------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index ddb3f9f1c58e..8db3e8b68bf1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -331,9 +331,16 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
  **/
 static int iavf_get_sset_count(struct net_device *netdev, int sset)
 {
+	/* Report the maximum number queues, even if not every queue is
+	 * currently configured. Since allocation of queues is in pairs,
+	 * use netdev->real_num_tx_queues * 2. The real_num_tx_queues is set
+	 * at device creation and never changes.
+	 */
+
 	if (sset == ETH_SS_STATS)
 		return IAVF_STATS_LEN +
-			(IAVF_QUEUE_STATS_LEN * 2 * IAVF_MAX_REQ_QUEUES);
+			(IAVF_QUEUE_STATS_LEN * 2 *
+			 netdev->real_num_tx_queues);
 	else if (sset == ETH_SS_PRIV_FLAGS)
 		return IAVF_PRIV_FLAGS_STR_LEN;
 	else
@@ -357,17 +364,18 @@ static void iavf_get_ethtool_stats(struct net_device *netdev,
 	iavf_add_ethtool_stats(&data, adapter, iavf_gstrings_stats);
 
 	rcu_read_lock();
-	for (i = 0; i < IAVF_MAX_REQ_QUEUES; i++) {
+	/* As num_active_queues describe both tx and rx queues, we can use
+	 * it to iterate over rings' stats.
+	 */
+	for (i = 0; i < adapter->num_active_queues; i++) {
 		struct iavf_ring *ring;
 
-		/* Avoid accessing un-allocated queues */
-		ring = (i < adapter->num_active_queues ?
-			&adapter->tx_rings[i] : NULL);
+		/* Tx rings stats */
+		ring = &adapter->tx_rings[i];
 		iavf_add_queue_stats(&data, ring);
 
-		/* Avoid accessing un-allocated queues */
-		ring = (i < adapter->num_active_queues ?
-			&adapter->rx_rings[i] : NULL);
+		/* Rx rings stats */
+		ring = &adapter->rx_rings[i];
 		iavf_add_queue_stats(&data, ring);
 	}
 	rcu_read_unlock();
@@ -404,10 +412,10 @@ static void iavf_get_stat_strings(struct net_device *netdev, u8 *data)
 
 	iavf_add_stat_strings(&data, iavf_gstrings_stats);
 
-	/* Queues are always allocated in pairs, so we just use num_tx_queues
-	 * for both Tx and Rx queues.
+	/* Queues are always allocated in pairs, so we just use
+	 * real_num_tx_queues for both Tx and Rx queues.
 	 */
-	for (i = 0; i < netdev->num_tx_queues; i++) {
+	for (i = 0; i < netdev->real_num_tx_queues; i++) {
 		iavf_add_stat_strings(&data, iavf_gstrings_queue_stats,
 				      "tx", i);
 		iavf_add_stat_strings(&data, iavf_gstrings_queue_stats,
-- 
2.31.1

