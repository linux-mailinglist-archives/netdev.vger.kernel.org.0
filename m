Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA53621A53
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiKHRWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiKHRVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:21:45 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60080.outbound.protection.outlook.com [40.107.6.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02D913D23;
        Tue,  8 Nov 2022 09:21:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jv+kQOGf9CXGk1XA1hHiWhkoKJ1jUPknQKQJ2lgHS07GMocf3U1K8RLrX9+VpXIcvNNOmNC/gpCzHw+M7kgyrmqTEqldp5m6MAK6OOlmNg1ClCN7OjFRSgeZRtMB7eXg6YoxrVbtNm66CjGUCd2nB2Bqy5GhLd3M+f0Fn1i6gL7LwHYD3XZtVq24Gym25v0FsjJ2Sx0r+VTDix86x4e0AdQ7VQI/29m3kafrhd0RGHWhVvYN7brJr4dyYmGZ9yTBTUVcid7/kP9U2CNPlyO0hhOhEnyMKFcqdMYBlmqhX4jCzYxkA/gMgh+RW5d8v7ctoPHq2AUrE8Md9NEbL58rYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9//TgYILKel0y17twoDMCX3QDNE0lNU0+i0mk0SG5c0=;
 b=KwkBYaPKsPm4Gb6LEO+0luWpknvpM4fbOPSPDnzh7Zn8oMpj8nDSkECo8WKhhRVYeunGV9lEcZ+kgfdI6bCTaK7WCGNv88bGyTCAhKHw5epzFBJtGagqokUWZFUtFZ71e9Pb6FJ/HJeQXZIdo+f3UOybiSGHR7e7latNUnzpIpt52Hd3+hBryLlK12l9pfPuis3fEgAH4aLBYlRXKx8lpXd8rrpVeqEXB6HYoVj7vfeRnp/yREtNyonuPoq7FirLpmOgTWgAeP8XoA2zQbI6i7jlroV4ZdxVTBmUHYaanoVAJOSdkAAbyUxdHar2rQO+QuaPx1mTjHL5APR5G9y9cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9//TgYILKel0y17twoDMCX3QDNE0lNU0+i0mk0SG5c0=;
 b=DCSFz0TuM/WvnRuE5+w+GRpY9/CT9LYL0IDdc2tHvaYXgmNjtcE7LraS2lgG/jaXdiXODiCQqv2s6hRXO3XiSCG40jjdEPm+H3m0U5AsqNAMTS4TftSZr+6qSo4JijP9C1GLIxmbCZ4s2Xy+yZNssMzQsPGBw5YS99uS2eD4sO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM7PR04MB7045.eurprd04.prod.outlook.com (2603:10a6:20b:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 17:21:40 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 17:21:39 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v2 2/2] net: fec: add xdp and page pool statistics
Date:   Tue,  8 Nov 2022 11:21:05 -0600
Message-Id: <20221108172105.3760656-3-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108172105.3760656-1-shenwei.wang@nxp.com>
References: <20221108172105.3760656-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:a03:333::7) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM7PR04MB7045:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a1e725-23d9-45d8-9498-08dac1adb28d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYNjwqt2iYZw5svH80rWGdXX66i6cpNKYYx5Bk9mR4tt8s5hp5b+IzvFBzAR7CDw05RmR03HdAFAMkhkohzqT9koyMiHPkaEymPtM+5laQDVdOUvEacU7qfvMZcVbQQqL7m0XV96OYDlf42Vib6fWHBY79mFNAeMgDZCzRsxxlaNgswyWJuKFD5mVuQv/AvnxRgBmbBi/deww1KA64VIOKHFInE/YAfN+8xszlilkKx2QtFSFkz3pgN4Eazju4SANHMPboHd2zdzi/cHQhkmkkmqgKrGt0/+/i1Y4Zkey1X29bc3Y59k9mChUcuZYA5UOTbnSwwqM15ZiR7GZuZpHBnjXvn6Ss1378AWxcMiK2lmeLBqqvjewzkNvD0OWxBtEVJXs3MMsc5QEXdK4e58aA2499PIV2MZW9k+UGGDPrjjHqcgx/dKpFzPUYUhW6Acbvv/dXEwa9x8KpIpbqJ6UvsMN74ytph4awRrvmOK6F/FWcdntEpqiZGBrl5jDvktn/GKUMsSrnxg9qZuXajzKETaPCrrCg/MCWplVta28IGxgRW+ykq9VRqG+JtI6/lM3O2lgc6V0J1Ki4WQ2fn5yA0eHD9pd2Lh4c7eOCe2btp8txRJYzhDbEKzDsK8/wRjKB1FxOUEuXPenSaIfbjcUzSbQFl/1r4gOXITZahtDTURDqanENno5p2yjj2M75OOhQdrIi8VyzJ75K4XP5ucGVpFzzrJ6u6o37bDqB/BLcQ7goqmriFlEU8Pnv7jkjmK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(478600001)(6486002)(38350700002)(38100700002)(44832011)(54906003)(5660300002)(2616005)(186003)(110136005)(6666004)(1076003)(2906002)(7416002)(55236004)(52116002)(83380400001)(26005)(6506007)(41300700001)(4326008)(8676002)(66946007)(36756003)(86362001)(66556008)(8936002)(6512007)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GC0+LZDQ8NPtCP9HsOtwCr+duvTCOI9SZU+k0QxOtSQ9L1tuamsi993BJs4i?=
 =?us-ascii?Q?3oWeAbNCnd+oR7sY5uEjrsx4Pr2UuhsFNLLca7pLB69ztz+6k4mm8Q6Hr2NL?=
 =?us-ascii?Q?LKEsg5X+EIfEYX5nbOVa6WuNNJwWVpbqgvGKUQyBT5VYZCLNE4GcIHO7Frvj?=
 =?us-ascii?Q?VLMUHSsZ0NjcGzp/7J1O9QUGxu9G4xaFqUip2IlwNAACWSsVn0W7FQ8dskLp?=
 =?us-ascii?Q?zb4piamxifo+hdW2QuQDeGSQMniIRRhBqUnf5VEnLLx0hdADV8XCoXaTv0FQ?=
 =?us-ascii?Q?L7Eh1XlR0Ess3QdHw+10wphF309AC/9vqvcW/oDtIjtHpQNdJ7lacZ8rDnNw?=
 =?us-ascii?Q?ajhsbdEFz6qg6l7eYusO398BWB0mi/Ye29NrePn/ZV9sWC7IsMHWgqPbyJ+u?=
 =?us-ascii?Q?GXEN+8SaGIigkXyglnxyfdgUs41Nb6Yncqh/A9mhtlLJV4I4ifi0S67xqTeh?=
 =?us-ascii?Q?jeI4KdxDHqq4cB2bj6nWHKyjCi8wg85yL8hIL+uzKlq6lmqbgNpvPxr97cOq?=
 =?us-ascii?Q?wx1Mqsq+IJPBNgRYRhTtEBFd4R0gJEO4r6IQljOmfepcd7LtHaTdd2fM/J0d?=
 =?us-ascii?Q?IzMnAxDH6tx1p6VmJVf4SwvLFF37o09s+5gCzUpDgNrT+L+JwDgTFDqhRBPn?=
 =?us-ascii?Q?vFzN62P3LgLRhvobJ92iWc5MYChvA+3RB5BT5KktSAkcC71xbSHmU25Y5doD?=
 =?us-ascii?Q?Gr/1O/S3TaS+c2PBR1pQ4sBJzagpk8U2Q/CnDTK/1SCNjiTogxq5WR+bMunn?=
 =?us-ascii?Q?OascdPgKIFxvbZ2q6h0BqRP5Z28WeKSUGwS1RhsHjFHDE0T1qpGVpOzRvAsH?=
 =?us-ascii?Q?xm3xG3ux7/aO7XWbdR24rcP15EgyJ0it8hC6qRiUxrTWeiqtXTmvIMuOIIg0?=
 =?us-ascii?Q?tI5d5cAiDHYvR7WpqMLdgY3lW17FCEhLZwtwrJ4bFiQWESXYNMIV9KT5+2rz?=
 =?us-ascii?Q?oA9ijumuxhAnIfeXj2mZq/kFTo9QlQkuP5y2UtJDMbvaM5TWHO2Z7xFh5O2P?=
 =?us-ascii?Q?JlCsJtTYb8Hd24AFDeZN2sLorwPU5r4U0AKlPQ48sdEchQegornl/eWUqYWH?=
 =?us-ascii?Q?8DhKPQUQzAFCyLdm6qoQPSrXJhpgH5Is/CCazNX+pPMK5o4UJ3PAPsrGnHkD?=
 =?us-ascii?Q?kWGefN7+Z1sjQbMNQTbV+3lZy3d38tbjYXNaV6QlqQX3lGpEqfqBLcv+1Ekc?=
 =?us-ascii?Q?X2+lT3FEK8RupOCLyyouuCdtRCj7IJYYzFilgy1/n4+TLXbbWIcHdNIX5f8G?=
 =?us-ascii?Q?OzFh+kUgrY7vlGo7iQQiZ6rHK7wDcqrKJSLeXyTqqOEoh8hQszFszTbdIX/4?=
 =?us-ascii?Q?DU3ORPqdiLdom5VPJNNOw6uSBwsBWyfQWY3kO5eT3bbLgBm6zHs+8E69q3y9?=
 =?us-ascii?Q?8kRd/zSB0yd9MBQqcop3GtsKnFIEVYUVPRG83iWsq7BMPWbzUF5uQDxCnLb3?=
 =?us-ascii?Q?31cHzzhBclxMbj/lRap1ORKWULPAC1Vovml08CzDTqWqeGC3WKKRnD+CAC9/?=
 =?us-ascii?Q?RbXGUneVNy6loj+d99a9MGAIgTAR4vBpCudUxyY9tuTV2+XDWJB3vNEETnLL?=
 =?us-ascii?Q?sEotMXi7JFjXI/SQOKPF69WkHct/2OfYaRmUI5n7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a1e725-23d9-45d8-9498-08dac1adb28d
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:21:39.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0SJgYRiNGVWrIlR+j2Flr6Vk4TL95tJZO4SVFB12/RxENqxk85h1tOYzA46ZZHs7SeElvyR+IxPmIKAPx/L7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7045
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added xdp and page pool statistics.
In order to make the implementation simple and compatible, the patch
uses the 32bit integer to record the XDP statistics.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      | 14 ++++
 drivers/net/ethernet/freescale/fec_main.c | 85 +++++++++++++++++++++--
 2 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 61e847b18343..5ba1e0d71c68 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -526,6 +526,19 @@ struct fec_enet_priv_txrx_info {
 	struct  sk_buff *skb;
 };
 
+enum {
+	RX_XDP_REDIRECT = 0,
+	RX_XDP_PASS,
+	RX_XDP_DROP,
+	RX_XDP_TX,
+	RX_XDP_TX_ERRORS,
+	TX_XDP_XMIT,
+	TX_XDP_XMIT_ERRORS,
+
+	/* The following must be the last one */
+	XDP_STATS_TOTAL,
+};
+
 struct fec_enet_priv_tx_q {
 	struct bufdesc_prop bd;
 	unsigned char *tx_bounce[TX_RING_SIZE];
@@ -546,6 +559,7 @@ struct fec_enet_priv_rx_q {
 	/* page_pool */
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+	u32 stats[XDP_STATS_TOTAL];
 
 	/* rx queue number, in the range 0-7 */
 	u8 id;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3fb870340c22..d18e50871c42 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1523,10 +1523,12 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 
 	switch (act) {
 	case XDP_PASS:
+		rxq->stats[RX_XDP_PASS]++;
 		ret = FEC_ENET_XDP_PASS;
 		break;
 
 	case XDP_REDIRECT:
+		rxq->stats[RX_XDP_REDIRECT]++;
 		err = xdp_do_redirect(fep->netdev, xdp, prog);
 		if (!err) {
 			ret = FEC_ENET_XDP_REDIR;
@@ -1549,6 +1551,7 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 		fallthrough;    /* handle aborts by dropping packet */
 
 	case XDP_DROP:
+		rxq->stats[RX_XDP_DROP]++;
 		ret = FEC_ENET_XDP_CONSUMED;
 		page = virt_to_head_page(xdp->data);
 		page_pool_put_page(rxq->page_pool, page, sync, true);
@@ -2659,6 +2662,16 @@ static const struct fec_stat {
 
 #define FEC_STATS_SIZE		(ARRAY_SIZE(fec_stats) * sizeof(u64))
 
+static const char *fec_xdp_stat_strs[XDP_STATS_TOTAL] = {
+	"rx_xdp_redirect",           /* RX_XDP_REDIRECT = 0, */
+	"rx_xdp_pass",               /* RX_XDP_PASS, */
+	"rx_xdp_drop",               /* RX_XDP_DROP, */
+	"rx_xdp_tx",                 /* RX_XDP_TX, */
+	"rx_xdp_tx_errors",          /* RX_XDP_TX_ERRORS, */
+	"tx_xdp_xmit",               /* TX_XDP_XMIT, */
+	"tx_xdp_xmit_errors",        /* TX_XDP_XMIT_ERRORS, */
+};
+
 static void fec_enet_update_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
@@ -2668,6 +2681,40 @@ static void fec_enet_update_ethtool_stats(struct net_device *dev)
 		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
 }
 
+static void fec_enet_get_xdp_stats(struct fec_enet_private *fep, u64 *data)
+{
+	u64 xdp_stats[XDP_STATS_TOTAL] = { 0 };
+	struct fec_enet_priv_rx_q *rxq;
+	int i, j;
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+
+		for (j = 0; j < XDP_STATS_TOTAL; j++)
+			xdp_stats[j] += rxq->stats[j];
+	}
+
+	memcpy(data, xdp_stats, sizeof(xdp_stats));
+}
+
+static void fec_enet_page_pool_stats(struct fec_enet_private *fep, u64 *data)
+{
+	struct page_pool_stats stats = {};
+	struct fec_enet_priv_rx_q *rxq;
+	int i;
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+
+		if (!rxq->page_pool)
+			continue;
+
+		page_pool_get_stats(rxq->page_pool, &stats);
+	}
+
+	page_pool_ethtool_stats_get(data, &stats);
+}
+
 static void fec_enet_get_ethtool_stats(struct net_device *dev,
 				       struct ethtool_stats *stats, u64 *data)
 {
@@ -2677,6 +2724,12 @@ static void fec_enet_get_ethtool_stats(struct net_device *dev,
 		fec_enet_update_ethtool_stats(dev);
 
 	memcpy(data, fep->ethtool_stats, FEC_STATS_SIZE);
+	data += FEC_STATS_SIZE / sizeof(u64);
+
+	fec_enet_get_xdp_stats(fep, data);
+	data += XDP_STATS_TOTAL;
+
+	fec_enet_page_pool_stats(fep, data);
 }
 
 static void fec_enet_get_strings(struct net_device *netdev,
@@ -2685,9 +2738,16 @@ static void fec_enet_get_strings(struct net_device *netdev,
 	int i;
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
-			memcpy(data + i * ETH_GSTRING_LEN,
-				fec_stats[i].name, ETH_GSTRING_LEN);
+		for (i = 0; i < ARRAY_SIZE(fec_stats); i++) {
+			memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+		for (i = 0; i < ARRAY_SIZE(fec_xdp_stat_strs); i++) {
+			memcpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+		page_pool_ethtool_stats_get_strings(data);
+
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2697,9 +2757,14 @@ static void fec_enet_get_strings(struct net_device *netdev,
 
 static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
+	int count;
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return ARRAY_SIZE(fec_stats);
+		count = ARRAY_SIZE(fec_stats) + XDP_STATS_TOTAL;
+		count += page_pool_ethtool_stats_get_count();
+		return count;
+
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
@@ -2710,7 +2775,8 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
-	int i;
+	struct fec_enet_priv_rx_q *rxq;
+	int i, j;
 
 	/* Disable MIB statistics counters */
 	writel(FEC_MIB_CTRLSTAT_DISABLE, fep->hwp + FEC_MIB_CTRLSTAT);
@@ -2718,6 +2784,12 @@ static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		writel(0, fep->hwp + fec_stats[i].offset);
 
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+		for (j = 0; j < XDP_STATS_TOTAL; j++)
+			rxq->stats[j] = 0;
+	}
+
 	/* Don't disable MIB statistics counters */
 	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
 }
@@ -3084,6 +3156,9 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 		for (i = 0; i < rxq->bd.ring_size; i++)
 			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
 
+		for (i = 0; i < XDP_STATS_TOTAL; i++)
+			rxq->stats[i] = 0;
+
 		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 			xdp_rxq_info_unreg(&rxq->xdp_rxq);
 		page_pool_destroy(rxq->page_pool);
-- 
2.34.1

