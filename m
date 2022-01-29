Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60FC4A2B29
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 03:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352133AbiA2CEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 21:04:44 -0500
Received: from mail-dm6nam12on2094.outbound.protection.outlook.com ([40.107.243.94]:28512
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352128AbiA2CEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 21:04:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1CZWV0HayDLxj89Hz+HYaDDDCI1o/o0UOL6zAay84g8OLs/Vo/Vn8crJcWwFz1E78yhx3RMcjXl4D2lHkHSk1HGwiZT4mvAUV+XMI2n8b9bEFKq1mlXcWuFwtptTGTDZ8F8B8jfDCU7qSM/e2VlQACo3PsmQNzHLf+N0W5I3t/bkrhsZKSK7bMJtdX38dIJPYX4efu4+DzkOKWgnfUNatCMgKJWeSjF1WeWZogFLfuK4OsUeJFnctBAYmvxfrsNjfwq8qAFOzN4d2HYc01ahaP4IIzIYJELX/fweebnIq29Ib4otao+9w3AYTQ+7fprgBHANwN7/fO6IF+UyQoyZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uif6Rm8ZeDHR0oJ0vqxYU3q+9KVJKZqYE8VZtII7lho=;
 b=LA1R2j5PshmS91SE8RURWPfOqXp69hTM17UwCohNwN6Snim+Bpb1eevMY6Zr1W5NRTEo++gGwOmQf8t2qqOs3k7GCc60SxMNs238fpWZqjUu+KS5+cXdIIDwqvDpfETU760TBC7Fwvh112hibeNo+V5ZK2djnB2aty8iRAzh9gsHWaw9lpgmTGKqO9rjVpmi714sZyt6pDE5X5nQU+MJz/0qE7/WM5u6jjozYB2vSVvUSIESBGnlRf3hD/sRuDzguFBGrEObMQ4LkVZ3Jz/QTCjwYbRZRFO3n5f2U7Qj2rVJyOfnyx1NqI/0/hAgNqbX7CIRmR4aLBVMZE30rn4yrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uif6Rm8ZeDHR0oJ0vqxYU3q+9KVJKZqYE8VZtII7lho=;
 b=R0e3VasVhk/Ja8uRfQH8+VQlHUXbg9bypMm9vWWzaR50WYxdEzjiw6oG1c4hTsq/ttK9UNrGr+En1IlfeQgwqWy2QocQmp261F4h/6qCPbdPK7c1cTccGgaX1/Pbsze3iHIoEOxEXGhpfwBXQ0tSfChC5CxrNew0cA2HWalPSRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by MWHPR21MB0191.namprd21.prod.outlook.com (2603:10b6:300:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.7; Sat, 29 Jan
 2022 02:04:33 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%6]) with mapi id 15.20.4951.007; Sat, 29 Jan 2022
 02:04:33 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 1/3] net: mana: Add counter for packet dropped by XDP
Date:   Fri, 28 Jan 2022 18:03:36 -0800
Message-Id: <1643421818-14259-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
References: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dca99126-e3e2-4655-23f8-08d9e2cbb1a0
X-MS-TrafficTypeDiagnostic: MWHPR21MB0191:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <MWHPR21MB01918C8DC8E2F5FF2C3C8A00AC239@MWHPR21MB0191.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3Zlofd5jddnT24udcIVbKM3dquxdTtYwS55Vsb2uPrtygOabJKS8I415FVFQyw6r6lH6H9u4Fx3gliQawfDBSwhDmOIsrB432SNMsisPwDGDEF8hUI4UdQArgbbf3ZEi4POSEMoWDyw2TU+Fht5dHXfjAKo4V+j/1nZ1hfmS5iJe6I84faJOVIoTSk7gp/pw3x2SSgCkef1LgaJ6X917+OdGhWINfuPBb4kB68IeIe1cq7+1beYOwCFbWYHf6+CBB6gvhVYVRd9XhLjGLDVm4Q9TLTymrsvn8Sn6WnDj7xIwINlO9ZAxqJHC+9q67MsZCwTb8NjRpOB12iiuBokDjg+6D+xTN88WaSHwJnmN3AdOc7/XQKirQJZ434FxRCHFyVOEDYLo969hS11cLiaSXiUGYhryepacK5sdrrx44z8fw63T6ICK/f3qDesA42YxUCC8857J/HCM/T6mKGsH1EnuRzPpx9RXJZDDG7xKjwY1I1WYu8w2qvlO8eX9IO36lOPIG1PIdKlanywFsLHCP4X8BVTbT5DOtnvKAqmEsK4yM7U7IbUx+qVQZLgOBDR1DIjkyMPJpRK2eEn1oAX8nd2tZzBYhIJtvojzcOe2MxXCm5vsE2Q/s+xKE2nm8ViN6bQzNRfgGJQS8iNFW0QNuWThNqSOD9qvD2Fw9jOeR/KzhCkze0skciumHTQSVaTDCFu+Kq8h1HHQtE/JOgi4LzsZBrVjSv7VxtIbm2Jr/5Dz0A1y6OgFLRX36cx8AFK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(4326008)(66476007)(8676002)(8936002)(5660300002)(38350700002)(38100700002)(82950400001)(316002)(82960400001)(186003)(6512007)(6506007)(26005)(2906002)(2616005)(508600001)(36756003)(7846003)(52116002)(83380400001)(6486002)(10290500003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oGSyA8aynNnfBL89n3TMJ5gh7Bo/yWLqtCWfLMkW1Kg+h8PUuDsQskQ0Go90?=
 =?us-ascii?Q?px0ZlCb//7vjInOBcnTMJelggXPAprU0Ue0xT/Ug4IoS8pO+UfHuNP3Pc9U0?=
 =?us-ascii?Q?frtZBt0dFhi/Mm7eyCtY48nz2SAH53POxWfF+m2LewtbvHpGmF0NkHL+145y?=
 =?us-ascii?Q?jJ/rG9o1+mp+nzYC0Wu3GWYREIDMFSVeGIymw0mnLCu0PoAcXetPNH8RTfkV?=
 =?us-ascii?Q?opvEBG/t+9Nt4tdzr+N5jl01EuXpPLNjqbOo5q4avQoaoPNfIandlHBYODGM?=
 =?us-ascii?Q?kKa5254hOux0ENv7QmXy4B/+3vkyCYDIp5srqZjXL3KU9i4T3I3PqmkV41j1?=
 =?us-ascii?Q?7c+i8mVr3irKQ0pDNvim+s1g7z1Ms0XqczgzHtVyCCXv3lys2yUaAZen6148?=
 =?us-ascii?Q?08c8/K0q3N9D2RuDw9eGruqwz4EG9NucMHGAFrGa75r7wixeJ1VgMORsu8Re?=
 =?us-ascii?Q?IV6pg82QprLPX8eoQHP9eFYRf1JKIctDf9rCNwSylAp7oewHt4wJAIto0Qp3?=
 =?us-ascii?Q?emNJcMIS7UhZJWQrVcy9zXqqU2Rzwac0t8e1UJKThiKDsB4qwtm++YEvOqXs?=
 =?us-ascii?Q?Yw+TkbpfxJxlA1oVzFNAsiwIWf1wmc+cOtVbDV75NevV2r5NQ/pMyEc1MADi?=
 =?us-ascii?Q?/1UYuTJ4AieSCTcUSgORGmL+pBLzWwJWI3Zhaqej3MSQwOh3ytOZJLRvTpoC?=
 =?us-ascii?Q?XoaO6AOOHueQnAG1PJ2qT+YAHCasI2Acwr7H8uHV9+2w8rWzGi299S1kXu6d?=
 =?us-ascii?Q?pFqj1uoo4ib8DvaJe6T53ApH2eyqMeVrDo5wtzZqG60CKhwVz0WTYxqrQa7a?=
 =?us-ascii?Q?mnQDEQmyhtk5lRSj8v1ZDwywqK+BSPnUAOYEHyiXsvdiBV/AkdvcRk1Iuvhr?=
 =?us-ascii?Q?CjhlKZMqzdol4vFAU4ajQyhYP69l8OQWhoatzeVe7e8Em5HPbfzqG+LAN4go?=
 =?us-ascii?Q?EiWaVjDoD09BqsKIHimlY89UuoVhmkJ168pI8Bp6jradyacavv9jmWubjJsr?=
 =?us-ascii?Q?AASxB5ddXhR5TC/lG+36Ac9ivjA4T1PUM2viOG+PwwwsdSw7CVwM2wziliqj?=
 =?us-ascii?Q?vswUQql4TtLrqRyi9ko7kbYsvfqm867abzUFYRhg1vUyN5ZLWQIg3Wp+jjBs?=
 =?us-ascii?Q?ICQFTDf9/rRpGwPOx2PH8efM3I0e13uP6iOvrSj2ts4/7omqqD5l/UMOt5Dn?=
 =?us-ascii?Q?GrJRJb3tv9HAwtWUWh5KeCzJGb2D0wpINY/aEU1Q5ChFrn/95wFwkNs5TLaT?=
 =?us-ascii?Q?OyShYBtPHHl6IP4tIVDSxyRrsXtJGii/vzXkwZtSfePLaAFvUW4CxdssyTU6?=
 =?us-ascii?Q?1sPhTRmUuJ0Zajd0EHFsbTQ0iEFlh2RhFk0wyOl+kmhsB7kRz7tibzc1tJf2?=
 =?us-ascii?Q?gpK1UnI5o692OyacQDu8wLMFlOJz51Ngd4B+3xzwWcI9MYfLhBVo9MkPCzNO?=
 =?us-ascii?Q?zRMvz17npLVKj3S38vzabRXHJli8XgQe89zBW7VBR5vsKDLCMNHDEu02dx3v?=
 =?us-ascii?Q?JN+WnQI9BrOqevn0fFcxLOKMBpOpY3nL6bat6S4Pq9eA+QM82IbvdTll+fmu?=
 =?us-ascii?Q?pfSjq8qP9//pKx0mrMvqKi0JXAsEude9xcdRi84nSPhzkX1wEQ9SK+1gjHSR?=
 =?us-ascii?Q?LwzoYfyw6reGnr/YeYNruaw=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca99126-e3e2-4655-23f8-08d9e2cbb1a0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 02:04:33.8285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geHeoVTSHmJ2C8rEAK6MLzvrs7BOG4Ua6VyjYl8SziTut3q2ZZt3Cnfa+kfIBcaS+zIi/p1DEN/I0cjVhg0sEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This counter will show up in ethtool stat data.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana.h    | 13 +++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c | 35 +++++++++++--------
 .../ethernet/microsoft/mana/mana_ethtool.c    | 30 +++++++++-------
 3 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 9a12607fb511..66fc98d7e1d6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -48,7 +48,14 @@ enum TRI_STATE {
 
 #define MAX_PORTS_IN_MANA_DEV 256
 
-struct mana_stats {
+struct mana_stats_rx {
+	u64 packets;
+	u64 bytes;
+	u64 xdp_drop;
+	struct u64_stats_sync syncp;
+};
+
+struct mana_stats_tx {
 	u64 packets;
 	u64 bytes;
 	struct u64_stats_sync syncp;
@@ -76,7 +83,7 @@ struct mana_txq {
 
 	atomic_t pending_sends;
 
-	struct mana_stats stats;
+	struct mana_stats_tx stats;
 };
 
 /* skb data and frags dma mappings */
@@ -298,7 +305,7 @@ struct mana_rxq {
 
 	u32 buf_index;
 
-	struct mana_stats stats;
+	struct mana_stats_rx stats;
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 498d0f999275..878c3d9bb39d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -136,7 +136,7 @@ int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	bool ipv4 = false, ipv6 = false;
 	struct mana_tx_package pkg = {};
 	struct netdev_queue *net_txq;
-	struct mana_stats *tx_stats;
+	struct mana_stats_tx *tx_stats;
 	struct gdma_queue *gdma_sq;
 	unsigned int csum_type;
 	struct mana_txq *txq;
@@ -299,7 +299,8 @@ static void mana_get_stats64(struct net_device *ndev,
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int num_queues = apc->num_queues;
-	struct mana_stats *stats;
+	struct mana_stats_rx *rx_stats;
+	struct mana_stats_tx *tx_stats;
 	unsigned int start;
 	u64 packets, bytes;
 	int q;
@@ -310,26 +311,26 @@ static void mana_get_stats64(struct net_device *ndev,
 	netdev_stats_to_stats64(st, &ndev->stats);
 
 	for (q = 0; q < num_queues; q++) {
-		stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxqs[q]->stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			packets = rx_stats->packets;
+			bytes = rx_stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		st->rx_packets += packets;
 		st->rx_bytes += bytes;
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		stats = &apc->tx_qp[q].txq.stats;
+		tx_stats = &apc->tx_qp[q].txq.stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			packets = tx_stats->packets;
+			bytes = tx_stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 
 		st->tx_packets += packets;
 		st->tx_bytes += bytes;
@@ -986,7 +987,7 @@ static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
 static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 			struct mana_rxq *rxq)
 {
-	struct mana_stats *rx_stats = &rxq->stats;
+	struct mana_stats_rx *rx_stats = &rxq->stats;
 	struct net_device *ndev = rxq->ndev;
 	uint pkt_len = cqe->ppi[0].pkt_len;
 	u16 rxq_idx = rxq->rxq_idx;
@@ -1007,7 +1008,7 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
 
 	if (act != XDP_PASS && act != XDP_TX)
-		goto drop;
+		goto drop_xdp;
 
 	skb = mana_build_skb(buf_va, pkt_len, &xdp);
 
@@ -1048,9 +1049,15 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	u64_stats_update_end(&rx_stats->syncp);
 	return;
 
+drop_xdp:
+	u64_stats_update_begin(&rx_stats->syncp);
+	rx_stats->xdp_drop++;
+	u64_stats_update_end(&rx_stats->syncp);
+
 drop:
 	free_page((unsigned long)buf_va);
 	++ndev->stats.rx_dropped;
+
 	return;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index c3c81ae3fafd..e1ccb9bf62de 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -23,7 +23,7 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 	if (stringset != ETH_SS_STATS)
 		return -EINVAL;
 
-	return ARRAY_SIZE(mana_eth_stats) + num_queues * 4;
+	return ARRAY_SIZE(mana_eth_stats) + num_queues * 5;
 }
 
 static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
@@ -46,6 +46,8 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "rx_%d_bytes", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "rx_%d_xdp_drop", i);
+		p += ETH_GSTRING_LEN;
 	}
 
 	for (i = 0; i < num_queues; i++) {
@@ -62,9 +64,11 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int num_queues = apc->num_queues;
 	void *eth_stats = &apc->eth_stats;
-	struct mana_stats *stats;
+	struct mana_stats_rx *rx_stats;
+	struct mana_stats_tx *tx_stats;
 	unsigned int start;
 	u64 packets, bytes;
+	u64 xdp_drop;
 	int q, i = 0;
 
 	if (!apc->port_is_up)
@@ -74,26 +78,28 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 		data[i++] = *(u64 *)(eth_stats + mana_eth_stats[q].offset);
 
 	for (q = 0; q < num_queues; q++) {
-		stats = &apc->rxqs[q]->stats;
+		rx_stats = &apc->rxqs[q]->stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			packets = rx_stats->packets;
+			bytes = rx_stats->bytes;
+			xdp_drop = rx_stats->xdp_drop;
+		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
+		data[i++] = xdp_drop;
 	}
 
 	for (q = 0; q < num_queues; q++) {
-		stats = &apc->tx_qp[q].txq.stats;
+		tx_stats = &apc->tx_qp[q].txq.stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			packets = tx_stats->packets;
+			bytes = tx_stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
-- 
2.25.1

