Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3099F1866BF
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgCPIlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:41:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60380 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730085AbgCPIlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 04:41:15 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4012E7D1E366B462072D;
        Mon, 16 Mar 2020 16:40:29 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Mar 2020 16:40:20 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aviad.krawczyk@huawei.com>, <luoxianjun@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <yin.yinshi@huawei.com>
Subject: [PATCH net 1/6] hinic: fix process of long length skb without frags
Date:   Mon, 16 Mar 2020 00:56:25 +0000
Message-ID: <20200316005630.9817-2-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316005630.9817-1-luobin9@huawei.com>
References: <20200316005630.9817-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

some tool such as pktgen can build an illegal skb with long
length but no fragments, which is unsupported for hw, so
drop it

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c    |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 13 +++++++++----
 drivers/net/ethernet/huawei/hinic/hinic_tx.h      |  2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 966aea949c0b..dac157bc06a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -582,6 +582,7 @@ static struct hinic_stats hinic_tx_queue_stats[] = {
 	HINIC_TXQ_STAT(tx_wake),
 	HINIC_TXQ_STAT(tx_dropped),
 	HINIC_TXQ_STAT(big_frags_pkts),
+	HINIC_TXQ_STAT(frag_len_overflow),
 };
 
 #define HINIC_RXQ_STAT(_stat_item) { \
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 13560975c103..a9bee70bd6c7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -107,6 +107,7 @@ static void update_tx_stats(struct hinic_dev *nic_dev, struct hinic_txq *txq)
 	nic_tx_stats->tx_wake += tx_stats.tx_wake;
 	nic_tx_stats->tx_dropped += tx_stats.tx_dropped;
 	nic_tx_stats->big_frags_pkts += tx_stats.big_frags_pkts;
+	nic_tx_stats->frag_len_overflow += tx_stats.frag_len_overflow;
 	u64_stats_update_end(&nic_tx_stats->syncp);
 
 	hinic_txq_clean_stats(txq);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 0e13d1c7e474..3c6762086fff 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -45,9 +45,10 @@
 
 #define HW_CONS_IDX(sq)                 be16_to_cpu(*(u16 *)((sq)->hw_ci_addr))
 
-#define MIN_SKB_LEN                     17
+#define MIN_SKB_LEN			17
+#define HINIC_GSO_MAX_SIZE		65536
 
-#define	MAX_PAYLOAD_OFFSET	        221
+#define	MAX_PAYLOAD_OFFSET		221
 #define TRANSPORT_OFFSET(l4_hdr, skb)	((u32)((l4_hdr) - (skb)->data))
 
 union hinic_l3 {
@@ -84,6 +85,7 @@ void hinic_txq_clean_stats(struct hinic_txq *txq)
 	txq_stats->tx_wake = 0;
 	txq_stats->tx_dropped = 0;
 	txq_stats->big_frags_pkts = 0;
+	txq_stats->frag_len_overflow = 0;
 	u64_stats_update_end(&txq_stats->syncp);
 }
 
@@ -106,6 +108,7 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 		stats->tx_wake = txq_stats->tx_wake;
 		stats->tx_dropped = txq_stats->tx_dropped;
 		stats->big_frags_pkts = txq_stats->big_frags_pkts;
+		stats->frag_len_overflow = txq_stats->frag_len_overflow;
 	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
 	u64_stats_update_end(&stats->syncp);
 }
@@ -440,7 +443,6 @@ static int hinic_tx_offload(struct sk_buff *skb, struct hinic_sq_task *task,
 			     vlan_tag >> VLAN_PRIO_SHIFT);
 		offload |= TX_OFFLOAD_VLAN;
 	}
-
 	if (offload)
 		hinic_task_set_l2hdr(task, skb_network_offset(skb));
 
@@ -488,11 +490,14 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		txq->txq_stats.big_frags_pkts++;
 		u64_stats_update_end(&txq->txq_stats.syncp);
 	}
-
 	if (nr_sges > txq->max_sges) {
 		netdev_err(netdev, "Too many Tx sges\n");
 		goto skb_error;
 	}
+	if (unlikely(skb->len > HINIC_GSO_MAX_SIZE && nr_sges == 1)) {
+		txq->txq_stats.frag_len_overflow++;
+		goto skb_error;
+	}
 
 	err = tx_map_skb(nic_dev, skb, txq->sges);
 	if (err)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.h b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
index f158b7db7fb8..ac65b4301c09 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.h
@@ -22,7 +22,7 @@ struct hinic_txq_stats {
 	u64     tx_wake;
 	u64     tx_dropped;
 	u64	big_frags_pkts;
-
+	u64     frag_len_overflow;
 	struct u64_stats_sync   syncp;
 };
 
-- 
2.17.1

