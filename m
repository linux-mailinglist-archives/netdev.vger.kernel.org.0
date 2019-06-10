Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C41B3B3EC
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389338AbfFJLTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:19:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:43642 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388839AbfFJLTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560165581; x=1591701581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=QRa5OAsY6ZjfppGDtj4unz3qJIFYm48iU6nqWkZHvYE=;
  b=upNuXqALuhbWt3Aj6yy+0O1Y/LrmeDmPSSGhC/A9B4Uj55Znr7GS8ZL/
   TLvrt6/ZKRNCvStuGSU+YwzH3KvlnFl4pBIPAOvlFfGeuJhrghp2LSPTr
   qmBHbLVf41UExtqdwQWDG/Kg/DILff5ttnYKx/td3NIYAMBb6T+hu5Ub+
   w=;
X-IronPort-AV: E=Sophos;i="5.60,575,1549929600"; 
   d="scan'208";a="769677467"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Jun 2019 11:19:40 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id A9C27A190B;
        Mon, 10 Jun 2019 11:19:39 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:29 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:29 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 10 Jun 2019 11:19:27 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 2/6] net: ena: enable negotiating larger Rx ring size
Date:   Mon, 10 Jun 2019 14:19:14 +0300
Message-ID: <20190610111918.21397-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610111918.21397-1-sameehj@amazon.com>
References: <20190610111918.21397-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Use MAX_QUEUES_EXT get feature capability to query the device.

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 144 ++++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  15 ++
 2 files changed, 110 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 68bed2417..ba5d580e5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2465,13 +2465,6 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
 		return -EINVAL;
 	}
 
-	if ((get_feat_ctx->max_queues.max_cq_num < adapter->num_queues) ||
-	    (get_feat_ctx->max_queues.max_sq_num < adapter->num_queues)) {
-		netif_err(adapter, drv, netdev,
-			  "Error, device doesn't support enough queues\n");
-		return -EINVAL;
-	}
-
 	if (get_feat_ctx->dev_attr.max_mtu < netdev->mtu) {
 		netif_err(adapter, drv, netdev,
 			  "Error, device max mtu is smaller than netdev MTU\n");
@@ -3045,18 +3038,32 @@ static int ena_calc_io_queue_num(struct pci_dev *pdev,
 				 struct ena_com_dev *ena_dev,
 				 struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
-	int io_sq_num, io_queue_num;
+	int io_tx_sq_num, io_tx_cq_num, io_rx_num, io_queue_num;
+
+	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
+		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
+			&get_feat_ctx->max_queue_ext.max_queue_ext;
+		io_rx_num = min_t(int, max_queue_ext->max_rx_sq_num,
+				  max_queue_ext->max_rx_cq_num);
 
-	/* In case of LLQ use the llq number in the get feature cmd */
+		io_tx_sq_num = max_queue_ext->max_tx_sq_num;
+		io_tx_cq_num = max_queue_ext->max_tx_cq_num;
+	} else {
+		struct ena_admin_queue_feature_desc *max_queues =
+			&get_feat_ctx->max_queues;
+		io_tx_sq_num = max_queues->max_sq_num;
+		io_tx_cq_num = max_queues->max_cq_num;
+		io_rx_num = min_t(int, io_tx_sq_num, io_tx_cq_num);
+	}
+
+	/* In case of LLQ use the llq fields for the tx SQ/CQ */
 	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
-		io_sq_num = get_feat_ctx->llq.max_llq_num;
-	else
-		io_sq_num = get_feat_ctx->max_queues.max_sq_num;
+		io_tx_sq_num = get_feat_ctx->llq.max_llq_num;
 
 	io_queue_num = min_t(int, num_online_cpus(), ENA_MAX_NUM_IO_QUEUES);
-	io_queue_num = min_t(int, io_queue_num, io_sq_num);
-	io_queue_num = min_t(int, io_queue_num,
-			     get_feat_ctx->max_queues.max_cq_num);
+	io_queue_num = min_t(int, io_queue_num, io_rx_num);
+	io_queue_num = min_t(int, io_queue_num, io_tx_sq_num);
+	io_queue_num = min_t(int, io_queue_num, io_tx_cq_num);
 	/* 1 IRQ for for mgmnt and 1 IRQs for each IO direction */
 	io_queue_num = min_t(int, io_queue_num, pci_msix_vec_count(pdev) - 1);
 	if (unlikely(!io_queue_num)) {
@@ -3239,36 +3246,73 @@ static inline void set_default_llq_configurations(struct ena_llq_configurations
 	llq_config->llq_ring_entry_size_value = 128;
 }
 
-static int ena_calc_queue_size(struct pci_dev *pdev,
-			       struct ena_com_dev *ena_dev,
-			       u16 *max_tx_sgl_size,
-			       u16 *max_rx_sgl_size,
-			       struct ena_com_dev_get_features_ctx *get_feat_ctx)
+static int ena_calc_queue_size(struct ena_calc_queue_size_ctx *ctx)
 {
-	u32 queue_size = ENA_DEFAULT_RING_SIZE;
+	struct ena_admin_feature_llq_desc *llq = &ctx->get_feat_ctx->llq;
+	struct ena_com_dev *ena_dev = ctx->ena_dev;
+	u32 tx_queue_size = ENA_DEFAULT_RING_SIZE;
+	u32 rx_queue_size = ENA_DEFAULT_RING_SIZE;
+	u32 max_tx_queue_size;
+	u32 max_rx_queue_size;
 
-	queue_size = min_t(u32, queue_size,
-			   get_feat_ctx->max_queues.max_cq_depth);
-	queue_size = min_t(u32, queue_size,
-			   get_feat_ctx->max_queues.max_sq_depth);
+	if (ctx->ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
+		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
+			&ctx->get_feat_ctx->max_queue_ext.max_queue_ext;
+		max_rx_queue_size = min_t(u32, max_queue_ext->max_rx_cq_depth,
+					  max_queue_ext->max_rx_sq_depth);
+		max_tx_queue_size = max_queue_ext->max_tx_cq_depth;
 
-	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
-		queue_size = min_t(u32, queue_size,
-				   get_feat_ctx->llq.max_llq_depth);
+		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  llq->max_llq_depth);
+		else
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  max_queue_ext->max_tx_sq_depth);
 
-	queue_size = rounddown_pow_of_two(queue_size);
+		ctx->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+					     max_queue_ext->max_per_packet_tx_descs);
+		ctx->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+					     max_queue_ext->max_per_packet_rx_descs);
+	} else {
+		struct ena_admin_queue_feature_desc *max_queues =
+			&ctx->get_feat_ctx->max_queues;
+		max_rx_queue_size = min_t(u32, max_queues->max_cq_depth,
+					  max_queues->max_sq_depth);
+		max_tx_queue_size = max_queues->max_cq_depth;
+
+		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  llq->max_llq_depth);
+		else
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  max_queues->max_sq_depth);
+
+		ctx->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+					     max_queues->max_packet_tx_descs);
+		ctx->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+					     max_queues->max_packet_rx_descs);
+	}
+
+	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
+	max_rx_queue_size = rounddown_pow_of_two(max_rx_queue_size);
 
-	if (unlikely(!queue_size)) {
-		dev_err(&pdev->dev, "Invalid queue size\n");
+	tx_queue_size = min_t(u32, tx_queue_size, max_tx_queue_size);
+	rx_queue_size = min_t(u32, rx_queue_size, max_rx_queue_size);
+
+	tx_queue_size = rounddown_pow_of_two(tx_queue_size);
+	rx_queue_size = rounddown_pow_of_two(rx_queue_size);
+
+	if (unlikely(!rx_queue_size || !tx_queue_size)) {
+		dev_err(&ctx->pdev->dev, "Invalid queue size\n");
 		return -EFAULT;
 	}
 
-	*max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-				 get_feat_ctx->max_queues.max_packet_tx_descs);
-	*max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-				 get_feat_ctx->max_queues.max_packet_rx_descs);
+	ctx->max_tx_queue_size = max_tx_queue_size;
+	ctx->max_rx_queue_size = max_rx_queue_size;
+	ctx->tx_queue_size = tx_queue_size;
+	ctx->rx_queue_size = rx_queue_size;
 
-	return queue_size;
+	return 0;
 }
 
 /* ena_probe - Device Initialization Routine
@@ -3284,6 +3328,7 @@ static int ena_calc_queue_size(struct pci_dev *pdev,
 static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
+	struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };
 	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
@@ -3291,9 +3336,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev;
 	static int adapters_found;
 	char *queue_type_str;
-	u16 tx_sgl_size = 0;
-	u16 rx_sgl_size = 0;
-	int queue_size;
 	bool wd_state;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
@@ -3350,20 +3392,25 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_device_destroy;
 	}
 
+	calc_queue_ctx.ena_dev = ena_dev;
+	calc_queue_ctx.get_feat_ctx = &get_feat_ctx;
+	calc_queue_ctx.pdev = pdev;
+
 	/* initial Tx interrupt delay, Assumes 1 usec granularity.
 	* Updated during device initialization with the real granularity
 	*/
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
 	io_queue_num = ena_calc_io_queue_num(pdev, ena_dev, &get_feat_ctx);
-	queue_size = ena_calc_queue_size(pdev, ena_dev, &tx_sgl_size,
-					 &rx_sgl_size, &get_feat_ctx);
-	if ((queue_size <= 0) || (io_queue_num <= 0)) {
+	rc = ena_calc_queue_size(&calc_queue_ctx);
+	if (rc || io_queue_num <= 0) {
 		rc = -EFAULT;
 		goto err_device_destroy;
 	}
 
-	dev_info(&pdev->dev, "creating %d io queues. queue size: %d. LLQ is %s\n",
-		 io_queue_num, queue_size,
+	dev_info(&pdev->dev, "creating %d io queues. rx queue size: %d tx queue size. %d LLQ is %s\n",
+		 io_queue_num,
+		 calc_queue_ctx.rx_queue_size,
+		 calc_queue_ctx.tx_queue_size,
 		 (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) ?
 		 "ENABLED" : "DISABLED");
 
@@ -3389,11 +3436,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
 	adapter->reset_reason = ENA_REGS_RESET_NORMAL;
 
-	adapter->tx_ring_size = queue_size;
-	adapter->rx_ring_size = queue_size;
-
-	adapter->max_tx_sgl_size = tx_sgl_size;
-	adapter->max_rx_sgl_size = rx_sgl_size;
+	adapter->tx_ring_size = calc_queue_ctx.tx_queue_size;
+	adapter->rx_ring_size = calc_queue_ctx.rx_queue_size;
+	adapter->max_tx_sgl_size = calc_queue_ctx.max_tx_sgl_size;
+	adapter->max_rx_sgl_size = calc_queue_ctx.max_rx_sgl_size;
 
 	adapter->num_queues = io_queue_num;
 	adapter->last_monitored_tx_qid = 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index ec111cfc5..afd2769f1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -154,6 +154,18 @@ struct ena_napi {
 	u32 qid;
 };
 
+struct ena_calc_queue_size_ctx {
+	struct ena_com_dev_get_features_ctx *get_feat_ctx;
+	struct ena_com_dev *ena_dev;
+	struct pci_dev *pdev;
+	u16 tx_queue_size;
+	u16 rx_queue_size;
+	u16 max_tx_queue_size;
+	u16 max_rx_queue_size;
+	u16 max_tx_sgl_size;
+	u16 max_rx_sgl_size;
+};
+
 struct ena_tx_buffer {
 	struct sk_buff *skb;
 	/* num of ena desc for this specific skb
@@ -322,6 +334,9 @@ struct ena_adapter {
 	u32 tx_ring_size;
 	u32 rx_ring_size;
 
+	u32 max_tx_ring_size;
+	u32 max_rx_ring_size;
+
 	u32 msg_enable;
 
 	u16 max_tx_sgl_size;
-- 
2.17.1

