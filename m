Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C10CD1EF
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 14:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfJFMfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 08:35:53 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:34570 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfJFMfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 08:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570365351; x=1601901351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=S7jIii0iVx2XaG9ZLvJsBZKraVVTqEbbhDLoJcElpwQ=;
  b=HwpkcghLAPDFO3iUVdmB4q0o+5Fi32OFtF0NRFlBEBNgVLm+W2vKnx78
   g6EN2Ao4pDPVVIVbFtU+LudxFaaHnxzEEMGuwMRvApXWRg71wqvHYpZvF
   N3irItDN48CVn4YaesqSqfE5bywoiM+kE1KCDo1uLmQ3GZmiO3apOdoTH
   Q=;
X-IronPort-AV: E=Sophos;i="5.67,263,1566864000"; 
   d="scan'208";a="707044398"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Oct 2019 12:34:29 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 71DADA26FD;
        Sun,  6 Oct 2019 12:33:58 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 6 Oct 2019 12:33:45 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 6 Oct 2019 12:33:45 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 6 Oct 2019 12:33:42 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next 4/6] net: ena: make ethtool -l show correct max number of queues
Date:   Sun, 6 Oct 2019 15:33:26 +0300
Message-ID: <20191006123328.24210-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191006123328.24210-1-sameehj@amazon.com>
References: <20191006123328.24210-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

- Update ena_ethtool:ena_get_channels() to return adapter->max_io_queues
  so that ethtool -l returns the correct maximum queue number.

- Change the name of ena_calc_io_queue_num() to
  ena_calc_max_io_queue_num() as it returns the maximum number of io
  queues and actual number of queues can be smaller if changed
  by ethtool -L which is implemented in a later commit.

- Change variable name from io_queue_num to max_num_io_queues in
  ena_calc_max_io_queue_num() and ena_probe().

- Make all types of variables that convey the number and sizeof queues
  to be u32, for consistency with the API between the driver and the
  device.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 41 ++++++++++---------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 11 ++---
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 03b4ae7ba..b75dafb79 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -734,7 +734,7 @@ static void ena_get_channels(struct net_device *netdev,
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	channels->max_combined = adapter->num_io_queues;
+	channels->max_combined = adapter->max_num_io_queues;
 	channels->combined_count = adapter->num_io_queues;
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a4e95fe2b..e71568159 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3135,16 +3135,16 @@ static void ena_timer_service(struct timer_list *t)
 	mod_timer(&adapter->timer_service, jiffies + HZ);
 }
 
-static int ena_calc_io_queue_num(struct pci_dev *pdev,
-				 struct ena_com_dev *ena_dev,
-				 struct ena_com_dev_get_features_ctx *get_feat_ctx)
+static int ena_calc_max_io_queue_num(struct pci_dev *pdev,
+				     struct ena_com_dev *ena_dev,
+				     struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
-	int io_tx_sq_num, io_tx_cq_num, io_rx_num, io_queue_num;
+	int io_tx_sq_num, io_tx_cq_num, io_rx_num, max_num_io_queues;
 
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
 			&get_feat_ctx->max_queue_ext.max_queue_ext;
-		io_rx_num = min_t(int, max_queue_ext->max_rx_sq_num,
+		io_rx_num = min_t(u32, max_queue_ext->max_rx_sq_num,
 				  max_queue_ext->max_rx_cq_num);
 
 		io_tx_sq_num = max_queue_ext->max_tx_sq_num;
@@ -3154,25 +3154,25 @@ static int ena_calc_io_queue_num(struct pci_dev *pdev,
 			&get_feat_ctx->max_queues;
 		io_tx_sq_num = max_queues->max_sq_num;
 		io_tx_cq_num = max_queues->max_cq_num;
-		io_rx_num = min_t(int, io_tx_sq_num, io_tx_cq_num);
+		io_rx_num = min_t(u32, io_tx_sq_num, io_tx_cq_num);
 	}
 
 	/* In case of LLQ use the llq fields for the tx SQ/CQ */
 	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
 		io_tx_sq_num = get_feat_ctx->llq.max_llq_num;
 
-	io_queue_num = min_t(int, num_online_cpus(), ENA_MAX_NUM_IO_QUEUES);
-	io_queue_num = min_t(int, io_queue_num, io_rx_num);
-	io_queue_num = min_t(int, io_queue_num, io_tx_sq_num);
-	io_queue_num = min_t(int, io_queue_num, io_tx_cq_num);
+	max_num_io_queues = min_t(u32, num_online_cpus(), ENA_MAX_NUM_IO_QUEUES);
+	max_num_io_queues = min_t(u32, max_num_io_queues, io_rx_num);
+	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_sq_num);
+	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_cq_num);
 	/* 1 IRQ for for mgmnt and 1 IRQs for each IO direction */
-	io_queue_num = min_t(int, io_queue_num, pci_msix_vec_count(pdev) - 1);
-	if (unlikely(!io_queue_num)) {
+	max_num_io_queues = min_t(u32, max_num_io_queues, pci_msix_vec_count(pdev) - 1);
+	if (unlikely(!max_num_io_queues)) {
 		dev_err(&pdev->dev, "The device doesn't have io queues\n");
 		return -EFAULT;
 	}
 
-	return io_queue_num;
+	return max_num_io_queues;
 }
 
 static int ena_set_queues_placement_policy(struct pci_dev *pdev,
@@ -3430,11 +3430,12 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
-	int io_queue_num, bars, rc;
 	struct net_device *netdev;
 	static int adapters_found;
+	u32 max_num_io_queues;
 	char *queue_type_str;
 	bool wd_state;
+	int bars, rc;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
@@ -3500,15 +3501,15 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ena_dev->intr_moder_tx_interval = ENA_INTR_INITIAL_TX_INTERVAL_USECS;
 	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
 	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
-	io_queue_num = ena_calc_io_queue_num(pdev, ena_dev, &get_feat_ctx);
+	max_num_io_queues = ena_calc_max_io_queue_num(pdev, ena_dev, &get_feat_ctx);
 	rc = ena_calc_io_queue_size(&calc_queue_ctx);
-	if (rc || io_queue_num <= 0) {
+	if (rc || !max_num_io_queues) {
 		rc = -EFAULT;
 		goto err_device_destroy;
 	}
 
 	/* dev zeroed in init_etherdev */
-	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), io_queue_num);
+	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), max_num_io_queues);
 	if (!netdev) {
 		dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
 		rc = -ENOMEM;
@@ -3536,7 +3537,9 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->max_tx_sgl_size = calc_queue_ctx.max_tx_sgl_size;
 	adapter->max_rx_sgl_size = calc_queue_ctx.max_rx_sgl_size;
 
-	adapter->num_io_queues = io_queue_num;
+	adapter->num_io_queues = max_num_io_queues;
+	adapter->max_num_io_queues = max_num_io_queues;
+
 	adapter->last_monitored_tx_qid = 0;
 
 	adapter->rx_copybreak = ENA_DEFAULT_RX_COPYBREAK;
@@ -3604,7 +3607,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev_info(&pdev->dev,
 		 "%s found at mem %lx, mac addr %pM Queues %d, Placement policy: %s\n",
 		 DEVICE_NAME, (long)pci_resource_start(pdev, 0),
-		 netdev->dev_addr, io_queue_num, queue_type_str);
+		 netdev->dev_addr, max_num_io_queues, queue_type_str);
 
 	set_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 7e8e51e32..7499afb58 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -161,10 +161,10 @@ struct ena_calc_queue_size_ctx {
 	struct ena_com_dev_get_features_ctx *get_feat_ctx;
 	struct ena_com_dev *ena_dev;
 	struct pci_dev *pdev;
-	u16 tx_queue_size;
-	u16 rx_queue_size;
-	u16 max_tx_queue_size;
-	u16 max_rx_queue_size;
+	u32 tx_queue_size;
+	u32 rx_queue_size;
+	u32 max_tx_queue_size;
+	u32 max_rx_queue_size;
 	u16 max_tx_sgl_size;
 	u16 max_rx_sgl_size;
 };
@@ -324,7 +324,8 @@ struct ena_adapter {
 	u32 rx_copybreak;
 	u32 max_mtu;
 
-	int num_io_queues;
+	u32 num_io_queues;
+	u32 max_num_io_queues;
 
 	int msix_vecs;
 
-- 
2.17.1

