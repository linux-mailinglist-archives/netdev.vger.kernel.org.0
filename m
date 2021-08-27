Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6CB3F9DD7
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245542AbhH0RWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:22:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:32992 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240433AbhH0RW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 13:22:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="214870013"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="214870013"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 10:21:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="427178967"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2021 10:21:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
        Mallikarjuna Chilakala <mallikarjuna.chilakala@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 1/3] igc: Use default cycle 'start' and 'end' values for queues
Date:   Fri, 27 Aug 2021 10:25:11 -0700
Message-Id: <20210827172513.224045-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210827172513.224045-1-anthony.l.nguyen@intel.com>
References: <20210827172513.224045-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Sets default values for each queue cycle start and cycle end.
This allows some simplification in the handling of these
configurations as most TSN features in i225 require a cycle
to be configured.

In i225, cycle start and end time is required to be programmed
for CBS to work properly.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>
Signed-off-by: Mallikarjuna Chilakala <mallikarjuna.chilakala@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 37 +++++++++++++----------
 drivers/net/ethernet/intel/igc/igc_tsn.c  |  6 ----
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c6c075a637ea..411d6caa27b5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5749,7 +5749,6 @@ static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
 				      bool enable)
 {
 	struct igc_ring *ring;
-	int i;
 
 	if (queue < 0 || queue >= adapter->num_tx_queues)
 		return -EINVAL;
@@ -5757,17 +5756,6 @@ static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
 	ring = adapter->tx_ring[queue];
 	ring->launchtime_enable = enable;
 
-	if (adapter->base_time)
-		return 0;
-
-	adapter->cycle_time = NSEC_PER_SEC;
-
-	for (i = 0; i < adapter->num_tx_queues; i++) {
-		ring = adapter->tx_ring[i];
-		ring->start_time = 0;
-		ring->end_time = NSEC_PER_SEC;
-	}
-
 	return 0;
 }
 
@@ -5840,16 +5828,31 @@ static int igc_tsn_enable_launchtime(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
+{
+	int i;
+
+	adapter->base_time = 0;
+	adapter->cycle_time = NSEC_PER_SEC;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		ring->start_time = 0;
+		ring->end_time = NSEC_PER_SEC;
+	}
+
+	return 0;
+}
+
 static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 				 struct tc_taprio_qopt_offload *qopt)
 {
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
-	if (!qopt->enable) {
-		adapter->base_time = 0;
-		return 0;
-	}
+	if (!qopt->enable)
+		return igc_tsn_clear_schedule(adapter);
 
 	if (adapter->base_time)
 		return -EALREADY;
@@ -6339,6 +6342,8 @@ static int igc_probe(struct pci_dev *pdev,
 
 	igc_ptp_init(adapter);
 
+	igc_tsn_clear_schedule(adapter);
+
 	/* reset the hardware with the new settings */
 	igc_reset(adapter);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 4dbbb8a32ce9..5bcdf7583505 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -41,12 +41,6 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
-		struct igc_ring *ring = adapter->tx_ring[i];
-
-		ring->start_time = 0;
-		ring->end_time = 0;
-		ring->launchtime_enable = false;
-
 		wr32(IGC_TXQCTL(i), 0);
 		wr32(IGC_STQT(i), 0);
 		wr32(IGC_ENDQT(i), NSEC_PER_SEC);
-- 
2.26.2

