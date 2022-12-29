Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA4D6589F3
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiL2HbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiL2Haw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:30:52 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49F6FD2A
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 23:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672299047; x=1703835047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QITZkjtjBa9GkmQVofQ+NVoavPkng4mtPj0d2c0PUOM=;
  b=aVKvyR5B+T/2oU3GQACm2gvzSgN8cZrkq03Ox3WG4riyuIX9w4KZ5sZR
   1pFOQQchj9EFtzaAmp2fRrHioZR8aNzUcULHW+KhPtg4B2gxZDb65TaT/
   WBA8czFTrkKaeslOTYJ+cuLjeiZmdYiS+rYZ8uc63BIR98d/CKJKid9YM
   k=;
X-IronPort-AV: E=Sophos;i="5.96,283,1665446400"; 
   d="scan'208";a="295143373"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 07:30:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 185944326B;
        Thu, 29 Dec 2022 07:30:45 +0000 (UTC)
Received: from EX19D002UWA001.ant.amazon.com (10.13.138.247) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 29 Dec 2022 07:30:44 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA001.ant.amazon.com (10.13.138.247) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 29 Dec 2022 07:30:44 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 29 Dec 2022 07:30:42
 +0000
From:   <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net 7/7] net: ena: Update NUMA TPH hint register upon NUMA node update
Date:   Thu, 29 Dec 2022 07:30:11 +0000
Message-ID: <20221229073011.19687-8-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221229073011.19687-1-darinzon@amazon.com>
References: <20221229073011.19687-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

The device supports a PCIe optimization hint, which indicates on
which NUMA the queue is currently processed. This hint is utilized
by PCIe in order to reduce its access time by accessing the
correct NUMA resources and maintaining cache coherence.

The driver calls the register update for the hint (called TPH -
TLP Processing Hint) during the NAPI loop.

Though the update is expected upon a NUMA change (when a queue
is moved from one NUMA to the other), the current logic performs
a register update when the queue is moved to a different CPU,
but the CPU is not necessarily in a different NUMA.

The changes include:
1. Performing the TPH update only when the queue has switched
a NUMA node.
2. Moving the TPH update call to be triggered only when NAPI was
scheduled from interrupt context, as opposed to a busy-polling loop.
This is due to the fact that during busy-polling, the frequency
of CPU switches for a particular queue is significantly higher,
thus, the likelihood to switch NUMA is much higher. Therefore,
providing the frequent updates to the device upon a NUMA update
are unlikely to be beneficial.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 27 +++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  6 +++--
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 99f80c2d560a..e8ad5ea31aff 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -680,6 +680,7 @@ static void ena_init_io_rings_common(struct ena_adapter *adapter,
 	ring->ena_dev = adapter->ena_dev;
 	ring->per_napi_packets = 0;
 	ring->cpu = 0;
+	ring->numa_node = 0;
 	ring->no_interrupt_event_cnt = 0;
 	u64_stats_init(&ring->syncp);
 }
@@ -783,6 +784,7 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
 	tx_ring->cpu = ena_irq->cpu;
+	tx_ring->numa_node = node;
 	return 0;
 
 err_push_buf_intermediate_buf:
@@ -915,6 +917,7 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 	rx_ring->cpu = ena_irq->cpu;
+	rx_ring->numa_node = node;
 
 	return 0;
 }
@@ -1863,20 +1866,27 @@ static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
 	if (likely(tx_ring->cpu == cpu))
 		goto out;
 
+	tx_ring->cpu = cpu;
+	if (rx_ring)
+		rx_ring->cpu = cpu;
+
 	numa_node = cpu_to_node(cpu);
+
+	if (likely(tx_ring->numa_node == numa_node))
+		goto out;
+
 	put_cpu();
 
 	if (numa_node != NUMA_NO_NODE) {
 		ena_com_update_numa_node(tx_ring->ena_com_io_cq, numa_node);
-		if (rx_ring)
+		tx_ring->numa_node = numa_node;
+		if (rx_ring) {
+			rx_ring->numa_node = numa_node;
 			ena_com_update_numa_node(rx_ring->ena_com_io_cq,
 						 numa_node);
+		}
 	}
 
-	tx_ring->cpu = cpu;
-	if (rx_ring)
-		rx_ring->cpu = cpu;
-
 	return;
 out:
 	put_cpu();
@@ -1997,11 +2007,10 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 			if (ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev))
 				ena_adjust_adaptive_rx_intr_moderation(ena_napi);
 
+			ena_update_ring_numa_node(tx_ring, rx_ring);
 			ena_unmask_interrupt(tx_ring, rx_ring);
 		}
 
-		ena_update_ring_numa_node(tx_ring, rx_ring);
-
 		ret = rx_work_done;
 	} else {
 		ret = budget;
@@ -2386,7 +2395,7 @@ static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid)
 	ctx.mem_queue_type = ena_dev->tx_mem_queue_type;
 	ctx.msix_vector = msix_vector;
 	ctx.queue_size = tx_ring->ring_size;
-	ctx.numa_node = cpu_to_node(tx_ring->cpu);
+	ctx.numa_node = tx_ring->numa_node;
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
 	if (rc) {
@@ -2454,7 +2463,7 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
 	ctx.mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
 	ctx.msix_vector = msix_vector;
 	ctx.queue_size = rx_ring->ring_size;
-	ctx.numa_node = cpu_to_node(rx_ring->cpu);
+	ctx.numa_node = rx_ring->numa_node;
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
 	if (rc) {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index f9d862b630fa..2cb141079474 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -262,9 +262,11 @@ struct ena_ring {
 	bool disable_meta_caching;
 	u16 no_interrupt_event_cnt;
 
-	/* cpu for TPH */
+	/* cpu and NUMA for TPH */
 	int cpu;
-	 /* number of tx/rx_buffer_info's entries */
+	int numa_node;
+
+	/* number of tx/rx_buffer_info's entries */
 	int ring_size;
 
 	enum ena_admin_placement_policy_type tx_mem_queue_type;
-- 
2.38.1

