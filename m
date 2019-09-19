Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E141B7B70
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbfISOCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:02:38 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:8786 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbfISOCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568901756; x=1600437756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=0J2I5KQb8/InE2yJepbLvJeIeWlUHnYRPpi43UUoJp8=;
  b=IkdXUWRvwEUNowCete7A/nuXXCMy6kGm09fujZjig53F/TgmjXxW/Xup
   2o9qNlj/lNXwaAQG9uhaaPy+gHDU89xrCarwyuWUBO66atfw2n2SO4t73
   I1o/YhiMe+I7vXHTVW7739mf8oLPh/zydrgHpYanmZZeVvxptCNwPCIiC
   o=;
X-IronPort-AV: E=Sophos;i="5.64,523,1559520000"; 
   d="scan'208";a="751613470"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Sep 2019 14:02:35 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 2A168A2755;
        Thu, 19 Sep 2019 14:02:34 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:02:34 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:02:34 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 19 Sep 2019 14:02:31 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 1/5] net: ena: change num_queues to num_io_queues for clarity and consistency
Date:   Thu, 19 Sep 2019 17:02:20 +0300
Message-ID: <20190919140224.9137-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190919140224.9137-1-sameehj@amazon.com>
References: <20190919140224.9137-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Most places in the code refer to the IO queues as io_queues and not
simply queues. Examples - max_io_queues_per_vf, ENA_MAX_NUM_IO_QUEUES,
ena_destroy_all_io_queues() etc..

We are also adding the new max_num_io_queues field to struct ena_adapter
in the following commit.

The changes included in this commit are:
struct ena_adapter->num_queues => struct ena_adapter->num_io_queues

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 20 +++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 66 +++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +-
 3 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 16553d92f..3ad661fd9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -133,7 +133,7 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 	u64 *ptr;
 	int i, j;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		/* Tx stats */
 		ring = &adapter->tx_ring[i];
 
@@ -205,7 +205,7 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
-	return  adapter->num_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+	return  adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
 		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
 }
 
@@ -214,7 +214,7 @@ static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 	const struct ena_stats *ena_stats;
 	int i, j;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		/* Tx stats */
 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
 			ena_stats = &ena_stats_tx_strings[j];
@@ -333,7 +333,7 @@ static void ena_update_tx_rings_intr_moderation(struct ena_adapter *adapter)
 
 	val = ena_com_get_nonadaptive_moderation_interval_tx(adapter->ena_dev);
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		adapter->tx_ring[i].smoothed_interval = val;
 }
 
@@ -344,7 +344,7 @@ static void ena_update_rx_rings_intr_moderation(struct ena_adapter *adapter)
 
 	val = ena_com_get_nonadaptive_moderation_interval_rx(adapter->ena_dev);
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		adapter->rx_ring[i].smoothed_interval = val;
 }
 
@@ -612,7 +612,7 @@ static int ena_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info,
 
 	switch (info->cmd) {
 	case ETHTOOL_GRXRINGS:
-		info->data = adapter->num_queues;
+		info->data = adapter->num_io_queues;
 		rc = 0;
 		break;
 	case ETHTOOL_GRXFH:
@@ -734,12 +734,12 @@ static void ena_get_channels(struct net_device *netdev,
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	channels->max_rx = adapter->num_queues;
-	channels->max_tx = adapter->num_queues;
+	channels->max_rx = adapter->num_io_queues;
+	channels->max_tx = adapter->num_io_queues;
 	channels->max_other = 0;
 	channels->max_combined = 0;
-	channels->rx_count = adapter->num_queues;
-	channels->tx_count = adapter->num_queues;
+	channels->rx_count = adapter->num_io_queues;
+	channels->tx_count = adapter->num_io_queues;
 	channels->other_count = 0;
 	channels->combined_count = 0;
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2b79fb5f7..d4d2639d2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -101,7 +101,7 @@ static void update_rx_ring_mtu(struct ena_adapter *adapter, int mtu)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		adapter->rx_ring[i].mtu = mtu;
 }
 
@@ -129,10 +129,10 @@ static int ena_init_rx_cpu_rmap(struct ena_adapter *adapter)
 	u32 i;
 	int rc;
 
-	adapter->netdev->rx_cpu_rmap = alloc_irq_cpu_rmap(adapter->num_queues);
+	adapter->netdev->rx_cpu_rmap = alloc_irq_cpu_rmap(adapter->num_io_queues);
 	if (!adapter->netdev->rx_cpu_rmap)
 		return -ENOMEM;
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		int irq_idx = ENA_IO_IRQ_IDX(i);
 
 		rc = irq_cpu_rmap_add(adapter->netdev->rx_cpu_rmap,
@@ -172,7 +172,7 @@ static void ena_init_io_rings(struct ena_adapter *adapter)
 
 	ena_dev = adapter->ena_dev;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		txr = &adapter->tx_ring[i];
 		rxr = &adapter->rx_ring[i];
 
@@ -294,7 +294,7 @@ static int ena_setup_all_tx_resources(struct ena_adapter *adapter)
 {
 	int i, rc = 0;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		rc = ena_setup_tx_resources(adapter, i);
 		if (rc)
 			goto err_setup_tx;
@@ -322,7 +322,7 @@ static void ena_free_all_io_tx_resources(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		ena_free_tx_resources(adapter, i);
 }
 
@@ -428,7 +428,7 @@ static int ena_setup_all_rx_resources(struct ena_adapter *adapter)
 {
 	int i, rc = 0;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		rc = ena_setup_rx_resources(adapter, i);
 		if (rc)
 			goto err_setup_rx;
@@ -456,7 +456,7 @@ static void ena_free_all_io_rx_resources(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		ena_free_rx_resources(adapter, i);
 }
 
@@ -600,7 +600,7 @@ static void ena_refill_all_rx_bufs(struct ena_adapter *adapter)
 	struct ena_ring *rx_ring;
 	int i, rc, bufs_num;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		rx_ring = &adapter->rx_ring[i];
 		bufs_num = rx_ring->ring_size - 1;
 		rc = ena_refill_rx_bufs(rx_ring, bufs_num);
@@ -616,7 +616,7 @@ static void ena_free_all_rx_bufs(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		ena_free_rx_bufs(adapter, i);
 }
 
@@ -688,7 +688,7 @@ static void ena_free_all_tx_bufs(struct ena_adapter *adapter)
 	struct ena_ring *tx_ring;
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		tx_ring = &adapter->tx_ring[i];
 		ena_free_tx_bufs(tx_ring);
 	}
@@ -699,7 +699,7 @@ static void ena_destroy_all_tx_queues(struct ena_adapter *adapter)
 	u16 ena_qid;
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		ena_qid = ENA_IO_TXQ_IDX(i);
 		ena_com_destroy_io_queue(adapter->ena_dev, ena_qid);
 	}
@@ -710,7 +710,7 @@ static void ena_destroy_all_rx_queues(struct ena_adapter *adapter)
 	u16 ena_qid;
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		ena_qid = ENA_IO_RXQ_IDX(i);
 		cancel_work_sync(&adapter->ena_napi[i].dim.work);
 		ena_com_destroy_io_queue(adapter->ena_dev, ena_qid);
@@ -1360,7 +1360,7 @@ static int ena_enable_msix(struct ena_adapter *adapter, int num_queues)
 		netif_notice(adapter, probe, adapter->netdev,
 			     "enable only %d MSI-X (out of %d), reduce the number of queues\n",
 			     irq_cnt, msix_vecs);
-		adapter->num_queues = irq_cnt - ENA_ADMIN_MSIX_VEC;
+		adapter->num_io_queues = irq_cnt - ENA_ADMIN_MSIX_VEC;
 	}
 
 	if (ena_init_rx_cpu_rmap(adapter))
@@ -1398,7 +1398,7 @@ static void ena_setup_io_intr(struct ena_adapter *adapter)
 
 	netdev = adapter->netdev;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		irq_idx = ENA_IO_IRQ_IDX(i);
 		cpu = i % num_online_cpus();
 
@@ -1530,7 +1530,7 @@ static void ena_del_napi(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		netif_napi_del(&adapter->ena_napi[i].napi);
 }
 
@@ -1539,7 +1539,7 @@ static void ena_init_napi(struct ena_adapter *adapter)
 	struct ena_napi *napi;
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		napi = &adapter->ena_napi[i];
 
 		netif_napi_add(adapter->netdev,
@@ -1556,7 +1556,7 @@ static void ena_napi_disable_all(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		napi_disable(&adapter->ena_napi[i].napi);
 }
 
@@ -1564,7 +1564,7 @@ static void ena_napi_enable_all(struct ena_adapter *adapter)
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		napi_enable(&adapter->ena_napi[i].napi);
 }
 
@@ -1674,7 +1674,7 @@ static int ena_create_all_io_tx_queues(struct ena_adapter *adapter)
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	int rc, i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		rc = ena_create_io_tx_queue(adapter, i);
 		if (rc)
 			goto create_err;
@@ -1742,7 +1742,7 @@ static int ena_create_all_io_rx_queues(struct ena_adapter *adapter)
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	int rc, i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		rc = ena_create_io_rx_queue(adapter, i);
 		if (rc)
 			goto create_err;
@@ -1765,7 +1765,7 @@ static void set_io_rings_size(struct ena_adapter *adapter,
 {
 	int i;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		adapter->tx_ring[i].ring_size = new_tx_size;
 		adapter->rx_ring[i].ring_size = new_rx_size;
 	}
@@ -1903,14 +1903,14 @@ static int ena_up(struct ena_adapter *adapter)
 	set_bit(ENA_FLAG_DEV_UP, &adapter->flags);
 
 	/* Enable completion queues interrupt */
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		ena_unmask_interrupt(&adapter->tx_ring[i],
 				     &adapter->rx_ring[i]);
 
 	/* schedule napi in case we had pending packets
 	 * from the last time we disable napi
 	 */
-	for (i = 0; i < adapter->num_queues; i++)
+	for (i = 0; i < adapter->num_io_queues; i++)
 		napi_schedule(&adapter->ena_napi[i].napi);
 
 	return rc;
@@ -1985,13 +1985,13 @@ static int ena_open(struct net_device *netdev)
 	int rc;
 
 	/* Notify the stack of the actual queue counts. */
-	rc = netif_set_real_num_tx_queues(netdev, adapter->num_queues);
+	rc = netif_set_real_num_tx_queues(netdev, adapter->num_io_queues);
 	if (rc) {
 		netif_err(adapter, ifup, netdev, "Can't set num tx queues\n");
 		return rc;
 	}
 
-	rc = netif_set_real_num_rx_queues(netdev, adapter->num_queues);
+	rc = netif_set_real_num_rx_queues(netdev, adapter->num_io_queues);
 	if (rc) {
 		netif_err(adapter, ifup, netdev, "Can't set num rx queues\n");
 		return rc;
@@ -2496,7 +2496,7 @@ static void ena_get_stats64(struct net_device *netdev,
 	if (!test_bit(ENA_FLAG_DEV_UP, &adapter->flags))
 		return;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		u64 bytes, packets;
 
 		tx_ring = &adapter->tx_ring[i];
@@ -2784,7 +2784,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
 	}
 
 	rc = ena_enable_msix_and_set_admin_interrupts(adapter,
-						      adapter->num_queues);
+						      adapter->num_io_queues);
 	if (rc) {
 		dev_err(&pdev->dev, "Enable MSI-X failed\n");
 		goto err_device_destroy;
@@ -2949,7 +2949,7 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 
 	budget = ENA_MONITORED_TX_QUEUES;
 
-	for (i = adapter->last_monitored_tx_qid; i < adapter->num_queues; i++) {
+	for (i = adapter->last_monitored_tx_qid; i < adapter->num_io_queues; i++) {
 		tx_ring = &adapter->tx_ring[i];
 		rx_ring = &adapter->rx_ring[i];
 
@@ -2966,7 +2966,7 @@ static void check_for_missing_completions(struct ena_adapter *adapter)
 			break;
 	}
 
-	adapter->last_monitored_tx_qid = i % adapter->num_queues;
+	adapter->last_monitored_tx_qid = i % adapter->num_io_queues;
 }
 
 /* trigger napi schedule after 2 consecutive detections */
@@ -2996,7 +2996,7 @@ static void check_for_empty_rx_ring(struct ena_adapter *adapter)
 	if (test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))
 		return;
 
-	for (i = 0; i < adapter->num_queues; i++) {
+	for (i = 0; i < adapter->num_io_queues; i++) {
 		rx_ring = &adapter->rx_ring[i];
 
 		refill_required =
@@ -3303,7 +3303,7 @@ static int ena_rss_init_default(struct ena_adapter *adapter)
 	}
 
 	for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
-		val = ethtool_rxfh_indir_default(i, adapter->num_queues);
+		val = ethtool_rxfh_indir_default(i, adapter->num_io_queues);
 		rc = ena_com_indirect_table_fill_entry(ena_dev, i,
 						       ENA_IO_RXQ_IDX(val));
 		if (unlikely(rc && (rc != -EOPNOTSUPP))) {
@@ -3546,7 +3546,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->max_tx_sgl_size = calc_queue_ctx.max_tx_sgl_size;
 	adapter->max_rx_sgl_size = calc_queue_ctx.max_rx_sgl_size;
 
-	adapter->num_queues = io_queue_num;
+	adapter->num_io_queues = io_queue_num;
 	adapter->last_monitored_tx_qid = 0;
 
 	adapter->rx_copybreak = ENA_DEFAULT_RX_COPYBREAK;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 72ee51a82..7e8e51e32 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -324,7 +324,7 @@ struct ena_adapter {
 	u32 rx_copybreak;
 	u32 max_mtu;
 
-	int num_queues;
+	int num_io_queues;
 
 	int msix_vecs;
 
-- 
2.17.1

