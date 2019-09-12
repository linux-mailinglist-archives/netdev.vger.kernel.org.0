Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0AB161D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfILWJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:09:46 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:21573 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326184; x=1599862184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=UIFGRo6UbXK2irOu22R7dJM3Jx2M033dUnGRO2OWRGg=;
  b=V5YzeDBX9AJCz2qxitdaCsns3HNjAo4SmA2GF62TcSkd/gIFJF/KjQfi
   P93oRNYa+dHtWNo/dJKV10lyARdpO4Hg7dt7SltAM8Up4hgOlN6twwROp
   2iyd57KZyzusO15QxpVYHaW3Ut7JjU1K+BidXXo2CLYu59bzQdQk+H9QF
   g=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="415006066"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Sep 2019 22:09:42 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id D40FEA22CC;
        Thu, 12 Sep 2019 22:09:42 +0000 (UTC)
Received: from EX13D10UWA001.ant.amazon.com (10.43.160.216) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:23 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA001.ant.amazon.com (10.43.160.216) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:09:23 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:09:15 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 02/11] net: ena: switch to dim algorithm for rx adaptive interrupt moderation
Date:   Fri, 13 Sep 2019 01:08:39 +0300
Message-ID: <1568326128-4057-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Use the dim library for the rx adaptive interrupt moderation implementation

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    |  4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 55 +++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  3 ++
 3 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index af85fd831ea4..c9440abf6b95 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2840,9 +2840,7 @@ int ena_com_init_interrupt_moderation(struct ena_com_dev *ena_dev)
 	delay_resolution = get_resp.u.intr_moderation.intr_delay_resolution;
 	ena_com_update_intr_delay_resolution(ena_dev, delay_resolution);
 
-	/* Disable adaptive moderation by default - can be enabled from
-	 * ethtool
-	 */
+	/* Disable adaptive moderation by default - can be enabled later */
 	ena_com_disable_adaptive_moderation(ena_dev);
 
 	return 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 233b252ceb9e..cdcc169b87fa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -196,6 +196,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter)
 		rxr->smoothed_interval =
 			ena_com_get_nonadaptive_moderation_interval_rx(ena_dev);
 		rxr->empty_rx_queue = 0;
+		adapter->ena_napi[i].dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	}
 }
 
@@ -712,6 +713,7 @@ static void ena_destroy_all_rx_queues(struct ena_adapter *adapter)
 
 	for (i = 0; i < adapter->num_queues; i++) {
 		ena_qid = ENA_IO_RXQ_IDX(i);
+		cancel_work_sync(&adapter->ena_napi[i].dim.work);
 		ena_com_destroy_io_queue(adapter->ena_dev, ena_qid);
 	}
 }
@@ -1155,23 +1157,35 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	return 0;
 }
 
-void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
-				       struct ena_ring *tx_ring)
+static void ena_dim_work(struct work_struct *w)
 {
-	/* We apply adaptive moderation on Rx path only.
-	 * Tx uses static interrupt moderation.
-	 */
-	ena_com_calculate_interrupt_delay(rx_ring->ena_dev,
-					  rx_ring->per_napi_packets,
-					  rx_ring->per_napi_bytes,
-					  &rx_ring->smoothed_interval,
-					  &rx_ring->moder_tbl_idx);
-
-	/* Reset per napi packets/bytes */
-	tx_ring->per_napi_packets = 0;
-	tx_ring->per_napi_bytes = 0;
+	struct dim *dim = container_of(w, struct dim, work);
+	struct dim_cq_moder cur_moder =
+		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	struct ena_napi *ena_napi = container_of(dim, struct ena_napi, dim);
+
+	ena_napi->rx_ring->smoothed_interval = cur_moder.usec;
+	dim->state = DIM_START_MEASURE;
+}
+
+static void ena_adjust_adaptive_rx_intr_moderation(struct ena_napi *ena_napi)
+{
+	struct dim_sample dim_sample;
+	struct ena_ring *rx_ring = ena_napi->rx_ring;
+
+	if (!rx_ring->per_napi_packets)
+		return;
+
+	rx_ring->non_empty_napi_events++;
+
+	dim_update_sample(rx_ring->non_empty_napi_events,
+			  rx_ring->rx_stats.cnt,
+			  rx_ring->rx_stats.bytes,
+			  &dim_sample);
+
+	net_dim(&ena_napi->dim, dim_sample);
+
 	rx_ring->per_napi_packets = 0;
-	rx_ring->per_napi_bytes = 0;
 }
 
 static void ena_unmask_interrupt(struct ena_ring *tx_ring,
@@ -1260,9 +1274,11 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 		 * from the interrupt context (vs from sk_busy_loop)
 		 */
 		if (napi_complete_done(napi, rx_work_done)) {
-			/* Tx and Rx share the same interrupt vector */
+			/* We apply adaptive moderation on Rx path only.
+			 * Tx uses static interrupt moderation.
+			 */
 			if (ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev))
-				ena_adjust_intr_moderation(rx_ring, tx_ring);
+				ena_adjust_adaptive_rx_intr_moderation(ena_napi);
 
 			ena_unmask_interrupt(tx_ring, rx_ring);
 		}
@@ -1740,13 +1756,16 @@ static int ena_create_all_io_rx_queues(struct ena_adapter *adapter)
 		rc = ena_create_io_rx_queue(adapter, i);
 		if (rc)
 			goto create_err;
+		INIT_WORK(&adapter->ena_napi[i].dim.work, ena_dim_work);
 	}
 
 	return 0;
 
 create_err:
-	while (i--)
+	while (i--) {
+		cancel_work_sync(&adapter->ena_napi[i].dim.work);
 		ena_com_destroy_io_queue(ena_dev, ENA_IO_RXQ_IDX(i));
+	}
 
 	return rc;
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index efbcffd22215..f67ecab3389a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -34,6 +34,7 @@
 #define ENA_H
 
 #include <linux/bitops.h>
+#include <linux/dim.h>
 #include <linux/etherdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/interrupt.h>
@@ -153,6 +154,7 @@ struct ena_napi {
 	struct ena_ring *tx_ring;
 	struct ena_ring *rx_ring;
 	u32 qid;
+	struct dim dim;
 };
 
 struct ena_calc_queue_size_ctx {
@@ -280,6 +282,7 @@ struct ena_ring {
 	u32  per_napi_packets;
 	u32  per_napi_bytes;
 	enum ena_intr_moder_level moder_tbl_idx;
+	u16 non_empty_napi_events;
 	struct u64_stats_sync syncp;
 	union {
 		struct ena_stats_tx tx_stats;
-- 
2.17.2

