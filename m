Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9F056631E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 08:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGEG03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 02:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiGEG0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 02:26:25 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD74610579;
        Mon,  4 Jul 2022 23:26:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VIQodX9_1657002375;
Received: from localhost(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VIQodX9_1657002375)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 14:26:15 +0800
From:   Qiao Ma <mqaio@linux.alibaba.com>
To:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, gustavoars@kernel.org, cai.huoqing@linux.dev,
        aviad.krawczyk@huawei.com, zhaochen6@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/3] net: hinic: fix bug that ethtool get wrong stats
Date:   Tue,  5 Jul 2022 14:25:59 +0800
Message-Id: <8cadab244a67bac6b69324de9264f4db61680896.1657001998.git.mqaio@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1657001998.git.mqaio@linux.alibaba.com>
References: <cover.1657001998.git.mqaio@linux.alibaba.com>
In-Reply-To: <cover.1657001998.git.mqaio@linux.alibaba.com>
References: <cover.1657001998.git.mqaio@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 56 +++++++++-----------------
 2 files changed, 18 insertions(+), 41 deletions(-)

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
index 56a89793f47d..0fc048a7b244 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -80,56 +80,48 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change);
 
-static void update_rx_stats(struct hinic_dev *nic_dev, struct hinic_rxq *rxq)
+static void gather_rx_stats(struct hinic_rxq_stats *nic_rx_stats, struct hinic_rxq *rxq)
 {
-	struct hinic_rxq_stats *nic_rx_stats = &nic_dev->rx_stats;
 	struct hinic_rxq_stats rx_stats;
 
 	u64_stats_init(&rx_stats.syncp);
 
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
 
 	u64_stats_init(&tx_stats.syncp);
 
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
+			   struct hinic_rxq_stats *nic_rx_stats,
+			   struct hinic_txq_stats *nic_tx_stats)
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
@@ -558,8 +550,6 @@ int hinic_close(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
-	update_nic_stats(nic_dev);
-
 	up(&nic_dev->mgmt_lock);
 
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
@@ -853,26 +843,24 @@ static void hinic_get_stats64(struct net_device *netdev,
 			      struct rtnl_link_stats64 *stats)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
-	struct hinic_rxq_stats *nic_rx_stats;
-	struct hinic_txq_stats *nic_tx_stats;
+	struct hinic_rxq_stats nic_rx_stats = {};
+	struct hinic_txq_stats nic_tx_stats = {};
 
-	nic_rx_stats = &nic_dev->rx_stats;
-	nic_tx_stats = &nic_dev->tx_stats;
+	u64_stats_init(&nic_rx_stats.syncp);
+	u64_stats_init(&nic_tx_stats.syncp);
 
 	down(&nic_dev->mgmt_lock);
-
 	if (nic_dev->flags & HINIC_INTF_UP)
-		update_nic_stats(nic_dev);
-
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
@@ -1171,8 +1159,6 @@ static void hinic_free_intr_coalesce(struct hinic_dev *nic_dev)
 static int nic_dev_init(struct pci_dev *pdev)
 {
 	struct hinic_rx_mode_work *rx_mode_work;
-	struct hinic_txq_stats *tx_stats;
-	struct hinic_rxq_stats *rx_stats;
 	struct hinic_dev *nic_dev;
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
@@ -1234,12 +1220,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 
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
-- 
1.8.3.1

