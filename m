Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C0162A362
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiKOUue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbiKOUuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:50:22 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60056.outbound.protection.outlook.com [40.107.6.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3537C2B624;
        Tue, 15 Nov 2022 12:50:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNWbGwP3+yf6jIAe+/8UUQddunsMB4XLN6pIFMu++sZfao06JqjFqgiKIrbj+AVf7aON2XUSw3AmidyxtC/mhetNhR14zzKs61QwSnvQtnGUD3cOwXev87bLYouAZWIp/iC1z85dQbDF1/NQqvsARScAEpqhvuCHLWxyB+7NNlx8LFL4A3ysNAAeXDFVEEL/eGa0NA3/PNLGNZf7NM5K0Z768vqqnalFFpXXcawJeVdKFb0f9ucVf3IRnTPZLJuj1EbLlas8tBnWyqhY10O/IZDlnZ2T0eEymxBvd3leFBInCi83Sc9Xny4piR+ah5N0Ns5VIAYWF3eCI6uvlzk0Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7e79ZCi6sldLaP/g97KBdZsh7fxEkaC+az8n7t1EzQ=;
 b=VoIEWVlBEHap5IfTopLaQNMg9IP9xDACuWqUioJmPoRHklZUjk/0p2jVMBDBnZBhO1CV9Vmt6i5f5OvKnMpnYr/mSgSfWOGq+9MeZkUPTkgqtobgC0tN6X7XmoJzqkxXBO3mWFv94893sMeJUFelD196wKfqpkgrFhAbuNMRoFvyURY/Mc+iPSDBxIlCJXlPbildIpG5hKuBDEu4a0izZn8jTGkJnlxq4K1ow3oGSPcquGEBgk+eZtucB9dtrg5GmWuOXSXzlmpfko8byBFsaMnjhuRW7ejI7HqVuDgmpLXujEnz31CyN8pR9zyQPBudRx7Dl409Pm7fudvlPg49QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7e79ZCi6sldLaP/g97KBdZsh7fxEkaC+az8n7t1EzQ=;
 b=Coyl4mFf46WSJ7Nrdd80v0yKvEUm0lIOm+0bS8Q1npWQsSOPQvvnhM6g6h5SIOwN33Rzt2440ZAYWuGeb0D3rnBwY2c0V8KhyHniv+hlvikdBA5LSpVlMlcCHHsFpR8xYVWAXY+2onPvZk0/FRpxZ9eB8oqxbdSrthdn9vruGvM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 20:50:18 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 20:50:18 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 2/3] net: fec: add xdp statistics
Date:   Tue, 15 Nov 2022 14:49:50 -0600
Message-Id: <20221115204951.370217-3-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115204951.370217-1-shenwei.wang@nxp.com>
References: <20221115204951.370217-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::11) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c502b7-4591-43cb-161c-08dac74b00de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 751gqxc5mXkrQNcgrvDJBPhxCLTSZK32oqyzj1Cin5RGcRfvo2d/a//fUfO+ySTwv07uhkB9u9kPs0OAvTPNbf/GO9Ma/psIjd3W1BGFZJjxVhqELAaEW+EDs7adxsdxanK1iw8aokZpcXQGnap8CV+NpTi2syX+vJGlQqIPMAcva1yULTgL3teuiHvF5I31Z4IyiNxVmf6LvOugULGcyxzU0gM/+2RpWZaWosf+gQ1PONZlC2Bc+ZCCaoWmkSrg0KahlYbZGfcvV3wUUKJpvoZpmuHqmMOFZTdTpS2DNr7284c1wu+l/4xdIh8XhTpdk1Szps9/0mCNjSg4ErjyXU/3snkZcgOY1jh6Mf5/nV00wyDLKvWh4ad1BBA361KAVQBuYsZVC1gtBpBxeqdEpqHyUIJ4XTiUHuNNitgZsptSoDSGrsl/EzQ3JxNj8sejDM2DqxCvdYqhgr1sjSg84iH9CbPCLg74CF6J4h+PiEuTAy6yLWte6p9a7kPC8n9JD9O+Z8gpnL27fEXSzgWh6a4UArh+xz6JZcJlwB6g1+IcInrIYbcWUJjunUper7T+/zuubCGe0PbMMJI7+S9FzAhrz8vqkrAkT7zkRHI07jjhS43ANiQil60hk2WQ/x4coXjdmAjeFXdKheq22vc2pPU4xBj8wCmoF7jBuCs83D3465BUHNG7dSN7/TtQZcQKZjU/2g3se/0oR2RwYvBaiYMOb6FFtN67xgQkpqVD6Z8T+gExfxbYxSKDND4p4TVm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(66556008)(5660300002)(2616005)(66946007)(66476007)(6486002)(478600001)(86362001)(44832011)(7416002)(186003)(110136005)(2906002)(36756003)(8936002)(1076003)(6512007)(6506007)(6666004)(54906003)(316002)(38100700002)(83380400001)(41300700001)(52116002)(55236004)(8676002)(4326008)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AoEOoRJnwQGf6xEfQKggcyyGl4DdAL11Mghn+zCZKP3uuO/7zpm4GNR61hO7?=
 =?us-ascii?Q?3+Mw/KWji5yJU46M277fdCCtEnnWirr0NOze2sL3FnQKnxgPDV6AERHek5dR?=
 =?us-ascii?Q?q+0ZsRuFPPAmfaLcR4C/PFM0f4nYnV4pBKM4pZEazkAtfnRihsYKvBSjk0e9?=
 =?us-ascii?Q?Kwx5LZuQR/V8zngku2dCBd6bP2qhFtTErnLfJJRKjXM0qHp/ZS5LFJCXECps?=
 =?us-ascii?Q?hXIxQnBEZFk7QGTDcI6+884Bt9RoRkVaGpAm2nQUlBwENx8zIpGW2m+i1dDZ?=
 =?us-ascii?Q?DLHtoiiiL4bzm+KmWhvd3LmASmGpHLUcKtrGbkWzxE7pmxju+x1eCmsA0I6I?=
 =?us-ascii?Q?jrOM+z5JPIZ59YF+pCaqyy+cBwSf0ccz/0dEO4beLqCr3xh5XoBsOXYgRcmN?=
 =?us-ascii?Q?Ef5nsQeB8Bfmm47G52qoLGrFYzi+3ILzpV9TCLMijbXhOL+QmSicUfSjWJja?=
 =?us-ascii?Q?TjvyKepZtgWAwNbN7H0R/jhK+nNa34cZQJPhU+YBM1hB52UtH/RxuDfRijyh?=
 =?us-ascii?Q?RTHG+KuCTXtzuUHXx75m/M505CXyIsD/q4IAfnvx44eTtUWHRNw/YTpiaHPD?=
 =?us-ascii?Q?4h20ENIWjOmcAvMzgeFfAIT+f9B+Ehz6Dhyk/v5xO59fj/Vu33h0SAvFtZLC?=
 =?us-ascii?Q?FqleGfRddiOTrFYCSkZ/HsdisisR0afj8aVd4nc7vwd01h0RRIo454NNssJy?=
 =?us-ascii?Q?lhET2yZquaRTtFLZJEgsUC712mD1bI9z96mdY1p39QxUaCxDeicQwSKH9hab?=
 =?us-ascii?Q?msPUtYdSb0Hbisg2vQS60AvpNdY1n51OUtvdPGN7pLUzOwZVuM7VMtsiPyeJ?=
 =?us-ascii?Q?YsI8KsZ4pMMPvrb00djDpAEGxpgQpT5oCqgiU5OW9e+GpEbsTZdpaH75OQgC?=
 =?us-ascii?Q?yCN3e871uC6/TYGElyTDV0kdvaALoqpV9oegWWiWon111Lyg+8c1QaP5KQ50?=
 =?us-ascii?Q?uaqrGW8G4rPPttgN7zq+tV4J11lgg8hVzkI7T2gYO2s75MhRz+Sx8dsOk1XD?=
 =?us-ascii?Q?tymrHUpQ30DKPKZrCcJOkhZnRGKPcq1Cha07lLuqthms2WIo3erUHrnJLt/w?=
 =?us-ascii?Q?243DUPN4EbZu8HefilyJOexszMX7Of/hyqXjE95Sce5tvzDEOzzOHhaTcTsc?=
 =?us-ascii?Q?xRAdn6mpiPxeG8mx96TrmDHDgj9/KR0xl4Rv9h1cicqFC1hV/B1ck3iCM541?=
 =?us-ascii?Q?SNCtCCwJVFSeXZNfHDcwnVtMVE9RbBquYrNG3GPPhbepoMJbG26Y8E3zANK0?=
 =?us-ascii?Q?+SLIArFvQXB7loo4WKMylCUvxru2XZyrCJKw2IyFy/9A5QlIX1N8yri20dt2?=
 =?us-ascii?Q?8YMt1ewhEygnhEPsAfLGs8RhYNMSCkW38LJhGBDCdXBVDa9aTnUZolrlf9D9?=
 =?us-ascii?Q?Lt1t/xl8ns0f0O0N3fJpGMVmbE9b+QRb1tOsWBPi39zvkzMrb7WAf96Vya8X?=
 =?us-ascii?Q?wE6Jahafay5y0ORKWcuvvvR6r2BrlnEjaGzn3P3nxAG+6qc9/8Tf+aWqG55K?=
 =?us-ascii?Q?7hutiK8p/1JVLRs/VAurrQRBL1b4zMi3oafnl+bfThVdBhnRxJ7CRYU8e5d5?=
 =?us-ascii?Q?nWfgGToJW9BdFrBytTfCPjaa4c9fMT57VKOFOSGB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c502b7-4591-43cb-161c-08dac74b00de
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 20:50:17.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JlFBFtnndvPfzUJx3Bx2hnIfCNaQE9DxvB862/izcYmhk0YxKNNE7fNhKwvgfl1AVtuo5uouHMwKA4c6Wgq+Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add xdp statistics for ethtool stats and using u64 to record the xdp counters.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/ethernet/freescale/fec.h      | 15 +++++
 drivers/net/ethernet/freescale/fec_main.c | 74 +++++++++++++++++++++--
 2 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 61e847b18343..adbe661552be 100644
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
@@ -546,6 +559,8 @@ struct fec_enet_priv_rx_q {
 	/* page_pool */
 	struct page_pool *page_pool;
 	struct xdp_rxq_info xdp_rxq;
+	struct u64_stats_sync syncp;
+	u64 stats[XDP_STATS_TOTAL];
 
 	/* rx queue number, in the range 0-7 */
 	u8 id;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 616eea712ca8..bb2157022022 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1507,7 +1507,8 @@ static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 
 static u32
 fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
-		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq, int index)
+		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq,
+		 u32 stats[], int index)
 {
 	unsigned int sync, len = xdp->data_end - xdp->data;
 	u32 ret = FEC_ENET_XDP_PASS;
@@ -1523,10 +1524,12 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 
 	switch (act) {
 	case XDP_PASS:
+		stats[RX_XDP_PASS]++;
 		ret = FEC_ENET_XDP_PASS;
 		break;
 
 	case XDP_REDIRECT:
+		stats[RX_XDP_REDIRECT]++;
 		err = xdp_do_redirect(fep->netdev, xdp, prog);
 		if (!err) {
 			ret = FEC_ENET_XDP_REDIR;
@@ -1549,6 +1552,7 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 		fallthrough;    /* handle aborts by dropping packet */
 
 	case XDP_DROP:
+		stats[RX_XDP_DROP]++;
 		ret = FEC_ENET_XDP_CONSUMED;
 		page = virt_to_head_page(xdp->data);
 		page_pool_put_page(rxq->page_pool, page, sync, true);
@@ -1582,6 +1586,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
 	u32 data_start = FEC_ENET_XDP_HEADROOM;
+	u32 xdp_stats[XDP_STATS_TOTAL] = { 0 };
 	struct xdp_buff xdp;
 	struct page *page;
 	u32 sub_len = 4;
@@ -1660,7 +1665,8 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 			/* subtract 16bit shift and FCS */
 			xdp_prepare_buff(&xdp, page_address(page),
 					 data_start, pkt_len - sub_len, false);
-			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
+			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq,
+					       xdp_stats, index);
 			xdp_result |= ret;
 			if (ret != FEC_ENET_XDP_PASS)
 				goto rx_processing_done;
@@ -1762,6 +1768,15 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	if (xdp_result & FEC_ENET_XDP_REDIR)
 		xdp_do_flush_map();
 
+	if (xdp_prog) {
+		int i;
+
+		u64_stats_update_begin(&rxq->syncp);
+		for (i = 0; i < XDP_STATS_TOTAL; i++)
+			rxq->stats[i] += xdp_stats[i];
+		u64_stats_update_end(&rxq->syncp);
+	}
+
 	return pkt_received;
 }
 
@@ -2701,6 +2716,16 @@ static const struct fec_stat {
 
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
@@ -2710,6 +2735,26 @@ static void fec_enet_update_ethtool_stats(struct net_device *dev)
 		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
 }
 
+static void fec_enet_get_xdp_stats(struct fec_enet_private *fep, u64 *data)
+{
+	u64 xdp_stats[XDP_STATS_TOTAL] = { 0 };
+	struct fec_enet_priv_rx_q *rxq;
+	unsigned int start;
+	int i, j;
+
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+
+		do {
+			start = u64_stats_fetch_begin(&rxq->syncp);
+			for (j = 0; j < XDP_STATS_TOTAL; j++)
+				xdp_stats[j] += rxq->stats[j];
+		} while (u64_stats_fetch_retry(&rxq->syncp, start));
+	}
+
+	memcpy(data, xdp_stats, sizeof(xdp_stats));
+}
+
 static void fec_enet_get_ethtool_stats(struct net_device *dev,
 				       struct ethtool_stats *stats, u64 *data)
 {
@@ -2719,6 +2764,10 @@ static void fec_enet_get_ethtool_stats(struct net_device *dev,
 		fec_enet_update_ethtool_stats(dev);
 
 	memcpy(data, fep->ethtool_stats, FEC_STATS_SIZE);
+	data += FEC_STATS_SIZE / sizeof(u64);
+
+	fec_enet_get_xdp_stats(fep, data);
+	data += XDP_STATS_TOTAL;
 }
 
 static void fec_enet_get_strings(struct net_device *netdev,
@@ -2727,9 +2776,14 @@ static void fec_enet_get_strings(struct net_device *netdev,
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
+			strscpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2741,7 +2795,7 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return ARRAY_SIZE(fec_stats);
+		return (ARRAY_SIZE(fec_stats) + XDP_STATS_TOTAL);
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
@@ -2752,6 +2806,7 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_priv_rx_q *rxq;
 	int i;
 
 	/* Disable MIB statistics counters */
@@ -2760,6 +2815,11 @@ static void fec_enet_clear_ethtool_stats(struct net_device *dev)
 	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 		writel(0, fep->hwp + fec_stats[i].offset);
 
+	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
+		rxq = fep->rx_queue[i];
+		memset(rxq->stats, 0, sizeof(rxq->stats));
+	}
+
 	/* Don't disable MIB statistics counters */
 	writel(0, fep->hwp + FEC_MIB_CTRLSTAT);
 }
@@ -3126,6 +3186,8 @@ static void fec_enet_free_buffers(struct net_device *ndev)
 		for (i = 0; i < rxq->bd.ring_size; i++)
 			page_pool_release_page(rxq->page_pool, rxq->rx_skb_info[i].page);
 
+		memset(rxq->stats, 0, sizeof(rxq->stats));
+
 		if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 			xdp_rxq_info_unreg(&rxq->xdp_rxq);
 		page_pool_destroy(rxq->page_pool);
-- 
2.34.1

