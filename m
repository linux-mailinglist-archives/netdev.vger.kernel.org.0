Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C41956690D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiGELWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiGELWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:22:40 -0400
Received: from out199-9.us.a.mail.aliyun.com (out199-9.us.a.mail.aliyun.com [47.90.199.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121E315A0D;
        Tue,  5 Jul 2022 04:22:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VISAW3U_1657020154;
Received: from localhost(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VISAW3U_1657020154)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 19:22:35 +0800
From:   Qiao Ma <mqaio@linux.alibaba.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, gustavoars@kernel.org, cai.huoqing@linux.dev
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 1/2] net: hinic: fix bug that ethtool get wrong stats
Date:   Tue,  5 Jul 2022 19:22:22 +0800
Message-Id: <223457a56893fb39648ab51b9c4ed4369b415f72.1657019476.git.mqaio@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1657019475.git.mqaio@linux.alibaba.com>
References: <cover.1657019475.git.mqaio@linux.alibaba.com>
In-Reply-To: <cover.1657019475.git.mqaio@linux.alibaba.com>
References: <cover.1657019475.git.mqaio@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function hinic_get_stats64() will do two operations:
1. reads stats from every hinic_rxq/txq and accumulates them
2. calls hinic_rxq/txq_clean_stats() to clean every rxq/txq's stats

For hinic_get_stats64(), it could get right data, because it sums all
data to nic_dev->rx_stats/tx_stats.
But it is wrong for get_drv_queue_stats(), this function will read
hinic_rxq's stats, which have been cleared to zero by hinic_get_stats64().

I have observed hinic's cleanup operation by using such command:
> watch -n 1 "cat ethtool -S eth4 | tail -40"

Result before:
     ...
     rxq7_pkts: 1
     rxq7_bytes: 90
     rxq7_errors: 0
     rxq7_csum_errors: 0
     rxq7_other_errors: 0
     ...
     rxq9_pkts: 11
     rxq9_bytes: 726
     rxq9_errors: 0
     rxq9_csum_errors: 0
     rxq9_other_errors: 0
     ...
     rxq11_pkts: 0
     rxq11_bytes: 0
     rxq11_errors: 0
     rxq11_csum_errors: 0
     rxq11_other_errors: 0

Result after a few seconds:
     ...
     rxq7_pkts: 0
     rxq7_bytes: 0
     rxq7_errors: 0
     rxq7_csum_errors: 0
     rxq7_other_errors: 0
     ...
     rxq9_pkts: 2
     rxq9_bytes: 132
     rxq9_errors: 0
     rxq9_csum_errors: 0
     rxq9_other_errors: 0
     ...
     rxq11_pkts: 1
     rxq11_bytes: 170
     rxq11_errors: 0
     rxq11_csum_errors: 0
     rxq11_other_errors: 0

To solve this problem, we just keep every queue's total stats in their own
queue (aka hinic_{rxq|txq}), and simply sum all per-queue stats every time
calling hinic_get_stats64().
With that solution, there is no need to clean per-queue stats now,
and there is no need to maintain global hinic_dev.{tx|rx}_stats, too.

Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h  |  3 --
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 57 ++++++++------------------
 drivers/net/ethernet/huawei/hinic/hinic_rx.c   |  2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c   |  2 -
 4 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index fb3e89141a0d..a4fbf44f944c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -95,9 +95,6 @@ struct hinic_dev {
 	u16				sq_depth;
 	u16				rq_depth;
 
-	struct hinic_txq_stats          tx_stats;
-	struct hinic_rxq_stats          rx_stats;
-
 	u8				rss_tmpl_idx;
 	u8				rss_hash_engine;
 	u16				num_rss;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 56a89793f47d..89dc52510fdc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -80,56 +80,44 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change);
 
-static void update_rx_stats(struct hinic_dev *nic_dev, struct hinic_rxq *rxq)
+static void gather_rx_stats(struct hinic_rxq_stats *nic_rx_stats, struct hinic_rxq *rxq)
 {
-	struct hinic_rxq_stats *nic_rx_stats = &nic_dev->rx_stats;
 	struct hinic_rxq_stats rx_stats;
 
-	u64_stats_init(&rx_stats.syncp);
-
 	hinic_rxq_get_stats(rxq, &rx_stats);
 
-	u64_stats_update_begin(&nic_rx_stats->syncp);
 	nic_rx_stats->bytes += rx_stats.bytes;
 	nic_rx_stats->pkts  += rx_stats.pkts;
 	nic_rx_stats->errors += rx_stats.errors;
 	nic_rx_stats->csum_errors += rx_stats.csum_errors;
 	nic_rx_stats->other_errors += rx_stats.other_errors;
-	u64_stats_update_end(&nic_rx_stats->syncp);
-
-	hinic_rxq_clean_stats(rxq);
 }
 
-static void update_tx_stats(struct hinic_dev *nic_dev, struct hinic_txq *txq)
+static void gather_tx_stats(struct hinic_txq_stats *nic_tx_stats, struct hinic_txq *txq)
 {
-	struct hinic_txq_stats *nic_tx_stats = &nic_dev->tx_stats;
 	struct hinic_txq_stats tx_stats;
 
-	u64_stats_init(&tx_stats.syncp);
-
 	hinic_txq_get_stats(txq, &tx_stats);
 
-	u64_stats_update_begin(&nic_tx_stats->syncp);
 	nic_tx_stats->bytes += tx_stats.bytes;
 	nic_tx_stats->pkts += tx_stats.pkts;
 	nic_tx_stats->tx_busy += tx_stats.tx_busy;
 	nic_tx_stats->tx_wake += tx_stats.tx_wake;
 	nic_tx_stats->tx_dropped += tx_stats.tx_dropped;
 	nic_tx_stats->big_frags_pkts += tx_stats.big_frags_pkts;
-	u64_stats_update_end(&nic_tx_stats->syncp);
-
-	hinic_txq_clean_stats(txq);
 }
 
-static void update_nic_stats(struct hinic_dev *nic_dev)
+static void gather_nic_stats(struct hinic_dev *nic_dev,
+			     struct hinic_rxq_stats *nic_rx_stats,
+			     struct hinic_txq_stats *nic_tx_stats)
 {
 	int i, num_qps = hinic_hwdev_num_qps(nic_dev->hwdev);
 
 	for (i = 0; i < num_qps; i++)
-		update_rx_stats(nic_dev, &nic_dev->rxqs[i]);
+		gather_rx_stats(nic_rx_stats, &nic_dev->rxqs[i]);
 
 	for (i = 0; i < num_qps; i++)
-		update_tx_stats(nic_dev, &nic_dev->txqs[i]);
+		gather_tx_stats(nic_tx_stats, &nic_dev->txqs[i]);
 }
 
 /**
@@ -558,8 +546,6 @@ int hinic_close(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
-	update_nic_stats(nic_dev);
-
 	up(&nic_dev->mgmt_lock);
 
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
@@ -853,26 +839,23 @@ static void hinic_get_stats64(struct net_device *netdev,
 			      struct rtnl_link_stats64 *stats)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
-	struct hinic_rxq_stats *nic_rx_stats;
-	struct hinic_txq_stats *nic_tx_stats;
-
-	nic_rx_stats = &nic_dev->rx_stats;
-	nic_tx_stats = &nic_dev->tx_stats;
+	struct hinic_rxq_stats nic_rx_stats = {};
+	struct hinic_txq_stats nic_tx_stats = {};
 
 	down(&nic_dev->mgmt_lock);
 
 	if (nic_dev->flags & HINIC_INTF_UP)
-		update_nic_stats(nic_dev);
+		gather_nic_stats(nic_dev, &nic_rx_stats, &nic_tx_stats);
 
 	up(&nic_dev->mgmt_lock);
 
-	stats->rx_bytes   = nic_rx_stats->bytes;
-	stats->rx_packets = nic_rx_stats->pkts;
-	stats->rx_errors  = nic_rx_stats->errors;
+	stats->rx_bytes   = nic_rx_stats.bytes;
+	stats->rx_packets = nic_rx_stats.pkts;
+	stats->rx_errors  = nic_rx_stats.errors;
 
-	stats->tx_bytes   = nic_tx_stats->bytes;
-	stats->tx_packets = nic_tx_stats->pkts;
-	stats->tx_errors  = nic_tx_stats->tx_dropped;
+	stats->tx_bytes   = nic_tx_stats.bytes;
+	stats->tx_packets = nic_tx_stats.pkts;
+	stats->tx_errors  = nic_tx_stats.tx_dropped;
 }
 
 static int hinic_set_features(struct net_device *netdev,
@@ -1171,8 +1154,6 @@ static void hinic_free_intr_coalesce(struct hinic_dev *nic_dev)
 static int nic_dev_init(struct pci_dev *pdev)
 {
 	struct hinic_rx_mode_work *rx_mode_work;
-	struct hinic_txq_stats *tx_stats;
-	struct hinic_rxq_stats *rx_stats;
 	struct hinic_dev *nic_dev;
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
@@ -1234,12 +1215,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	sema_init(&nic_dev->mgmt_lock, 1);
 
-	tx_stats = &nic_dev->tx_stats;
-	rx_stats = &nic_dev->rx_stats;
-
-	u64_stats_init(&tx_stats->syncp);
-	u64_stats_init(&rx_stats->syncp);
-
 	nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
 						  GFP_KERNEL);
 	if (!nic_dev->vlan_bitmap) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 24b7b819dbfb..a866bea65110 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -73,7 +73,6 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
 	struct hinic_rxq_stats *rxq_stats = &rxq->rxq_stats;
 	unsigned int start;
 
-	u64_stats_update_begin(&stats->syncp);
 	do {
 		start = u64_stats_fetch_begin(&rxq_stats->syncp);
 		stats->pkts = rxq_stats->pkts;
@@ -83,7 +82,6 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
 		stats->csum_errors = rxq_stats->csum_errors;
 		stats->other_errors = rxq_stats->other_errors;
 	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
-	u64_stats_update_end(&stats->syncp);
 }
 
 /**
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 87408e7bb809..5051cdff2384 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -98,7 +98,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 	struct hinic_txq_stats *txq_stats = &txq->txq_stats;
 	unsigned int start;
 
-	u64_stats_update_begin(&stats->syncp);
 	do {
 		start = u64_stats_fetch_begin(&txq_stats->syncp);
 		stats->pkts    = txq_stats->pkts;
@@ -108,7 +107,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 		stats->tx_dropped = txq_stats->tx_dropped;
 		stats->big_frags_pkts = txq_stats->big_frags_pkts;
 	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
-	u64_stats_update_end(&stats->syncp);
 }
 
 /**
-- 
1.8.3.1

