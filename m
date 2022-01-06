Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8B486A81
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbiAFT3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:29:50 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:48967 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243327AbiAFT3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497386; x=1673033386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QIBVSB/LA85uuc/Qa6djuR/kvCvMs8vhO7ag6lYZA4s=;
  b=hzcDhc/h4ZZEK5FstI1dNbJ140RYXfDnALuqWwKiBWroA1lX1mAwbc8F
   ROOwFb1oXu+09c1qwej45KCTaItMxU+8n2Q07u71Co5e/LNdUxowVsa12
   gCIioCV/SbWTLCVaaeEmCtfRNpTzBxVM4x5+ZO10AtDRLoU5qhiPIabCG
   Y=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="168455554"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Jan 2022 19:29:45 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com (Postfix) with ESMTPS id 16E66430E4;
        Thu,  6 Jan 2022 19:29:45 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:44 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:43 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:41 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V1 net-next 07/10] net: ena: Remove ena_calc_queue_size_ctx struct
Date:   Thu, 6 Jan 2022 19:29:12 +0000
Message-ID: <20220106192915.22616-8-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106192915.22616-1-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This struct was used to pass data from callee function to its caller.
Its usage can be avoided.

Removing it results in less code without any damage to code readability.
Also it allows to consolidate ring size calculation into a single
function (ena_calc_io_queue_size()).

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 49 ++++++++------------
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 12 -----
 2 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b4e10f7082e2..4ad0c602d76c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4146,10 +4146,11 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 }
 
 
-static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
+static void ena_calc_io_queue_size(struct ena_adapter *adapter,
+				   struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
-	struct ena_admin_feature_llq_desc *llq = &ctx->get_feat_ctx->llq;
-	struct ena_com_dev *ena_dev = ctx->ena_dev;
+	struct ena_admin_feature_llq_desc *llq = &get_feat_ctx->llq;
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	u32 tx_queue_size = ENA_DEFAULT_RING_SIZE;
 	u32 rx_queue_size = ENA_DEFAULT_RING_SIZE;
 	u32 max_tx_queue_size;
@@ -4157,7 +4158,7 @@ static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
-			&ctx->get_feat_ctx->max_queue_ext.max_queue_ext;
+			&get_feat_ctx->max_queue_ext.max_queue_ext;
 		max_rx_queue_size = min_t(u32, max_queue_ext->max_rx_cq_depth,
 					  max_queue_ext->max_rx_sq_depth);
 		max_tx_queue_size = max_queue_ext->max_tx_cq_depth;
@@ -4169,13 +4170,13 @@ static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 			max_tx_queue_size = min_t(u32, max_tx_queue_size,
 						  max_queue_ext->max_tx_sq_depth);
 
-		ctx->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-					     max_queue_ext->max_per_packet_tx_descs);
-		ctx->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-					     max_queue_ext->max_per_packet_rx_descs);
+		adapter->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queue_ext->max_per_packet_tx_descs);
+		adapter->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queue_ext->max_per_packet_rx_descs);
 	} else {
 		struct ena_admin_queue_feature_desc *max_queues =
-			&ctx->get_feat_ctx->max_queues;
+			&get_feat_ctx->max_queues;
 		max_rx_queue_size = min_t(u32, max_queues->max_cq_depth,
 					  max_queues->max_sq_depth);
 		max_tx_queue_size = max_queues->max_cq_depth;
@@ -4187,10 +4188,10 @@ static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 			max_tx_queue_size = min_t(u32, max_tx_queue_size,
 						  max_queues->max_sq_depth);
 
-		ctx->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-					     max_queues->max_packet_tx_descs);
-		ctx->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-					     max_queues->max_packet_rx_descs);
+		adapter->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queues->max_packet_tx_descs);
+		adapter->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queues->max_packet_rx_descs);
 	}
 
 	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
@@ -4204,10 +4205,10 @@ static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
 	tx_queue_size = rounddown_pow_of_two(tx_queue_size);
 	rx_queue_size = rounddown_pow_of_two(rx_queue_size);
 
-	ctx->max_tx_queue_size = max_tx_queue_size;
-	ctx->max_rx_queue_size = max_rx_queue_size;
-	ctx->tx_queue_size = tx_queue_size;
-	ctx->rx_queue_size = rx_queue_size;
+	adapter->max_tx_ring_size  = max_tx_queue_size;
+	adapter->max_rx_ring_size = max_rx_queue_size;
+	adapter->requested_tx_ring_size = tx_queue_size;
+	adapter->requested_rx_ring_size = rx_queue_size;
 }
 
 /* ena_probe - Device Initialization Routine
@@ -4222,7 +4223,6 @@ static void ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
  */
 static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct ena_calc_queue_size_ctx calc_queue_ctx = {};
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
@@ -4307,10 +4307,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_device_destroy;
 	}
 
-	calc_queue_ctx.ena_dev = ena_dev;
-	calc_queue_ctx.get_feat_ctx = &get_feat_ctx;
-	calc_queue_ctx.pdev = pdev;
-
 	/* Initial TX and RX interrupt delay. Assumes 1 usec granularity.
 	 * Updated during device initialization with the real granularity
 	 */
@@ -4318,7 +4314,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
 	max_num_io_queues = ena_calc_max_io_queue_num(pdev, ena_dev, &get_feat_ctx);
-	ena_calc_io_queue_size(&calc_queue_ctx);
+	ena_calc_io_queue_size(adapter, &get_feat_ctx);
 	if (unlikely(!max_num_io_queues)) {
 		rc = -EFAULT;
 		goto err_device_destroy;
@@ -4328,13 +4324,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapter->reset_reason = ENA_REGS_RESET_NORMAL;
 
-	adapter->requested_tx_ring_size = calc_queue_ctx.tx_queue_size;
-	adapter->requested_rx_ring_size = calc_queue_ctx.rx_queue_size;
-	adapter->max_tx_ring_size = calc_queue_ctx.max_tx_queue_size;
-	adapter->max_rx_ring_size = calc_queue_ctx.max_rx_queue_size;
-	adapter->max_tx_sgl_size = calc_queue_ctx.max_tx_sgl_size;
-	adapter->max_rx_sgl_size = calc_queue_ctx.max_rx_sgl_size;
-
 	adapter->num_io_queues = max_num_io_queues;
 	adapter->max_num_io_queues = max_num_io_queues;
 	adapter->last_monitored_tx_qid = 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index f70f1242e5b5..25b9d4dd0535 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -140,18 +140,6 @@ struct ena_napi {
 	struct dim dim;
 };
 
-struct ena_calc_queue_size_ctx {
-	struct ena_com_dev_get_features_ctx *get_feat_ctx;
-	struct ena_com_dev *ena_dev;
-	struct pci_dev *pdev;
-	u32 tx_queue_size;
-	u32 rx_queue_size;
-	u32 max_tx_queue_size;
-	u32 max_rx_queue_size;
-	u16 max_tx_sgl_size;
-	u16 max_rx_sgl_size;
-};
-
 struct ena_tx_buffer {
 	struct sk_buff *skb;
 	/* num of ena desc for this specific skb
-- 
2.32.0

