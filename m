Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5360052216A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347520AbiEJQmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347508AbiEJQko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:40:44 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6135056769
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:36:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkhK5cfLLgJp7NvbMagQa6Y34YtbMka1mfWxSSIhVo3Vo+FJ9JogGV3yQiPpSsdfKoxx17I0c1cGp6v6Y8vcb8JvUBECGMbsWgqhPMeQOU5O/EH5V/TKEU2PncdcTkfpmGeA0Njz9Yy1A+s/rH4H2q4rqoxWH5za1G+psEDj0FoGwTBPKZY0PqF98CI4uJ99imJCpRojGAJ41oODBrGgkKAPWg+m9HFE6AqoW9368h8lv4LXFT4WV4C9qF01MN6TFdr6D88RcTse3W3EotGo/YSy3jxyGlTNZIPb0wrn/3v7acURW7kst2Cydgvu6pn1JIH/BoKzK5yLjx+uqSPBgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BqbvMgialmX7Ad7jh0iZMMu7j0FXpC9EbY16f82SCo=;
 b=k5hfK8bECiMa4nuxGCd5MBHjmZUw6bH5mEOsoqX0mrkXKdyGISFLX3uh1+EphWb+tQKp3PsxCyU347jLScdFt904wFXsuLv8chp27oTVSm5909FgowWewBnpftux5yusKhrSOJi9vVWrUuY78zPQ/p5EdzeIk12S5c7+zt6D6MBdKQ5ezshT7Lb2aKBWHKg0kbFYUENyNm+4rKg5LYbXFawe73hAiXzWhhsl3hJEVBvtpmOiHLRXoBbQtnNcJxBk+Eu1eF91Hg/4Zn+7Lnj0TrPaj2eZWo/YdN3QJFMfkIiuboV9q1mcYdFlKFs3/FbKLA4/CH2ffTSpvrm+iFZQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BqbvMgialmX7Ad7jh0iZMMu7j0FXpC9EbY16f82SCo=;
 b=EeM6noSU/o5J2rh/rXH6A/KumBTmHeSt2EQEandW3yBUc1VLjLQ2B6+nPNrgmIY5Oue1eF8gnfheYod53UWWAnzrD2b5WE6c9SjxFqnhWsFzAejn5nq0MgZpOCdGr4s8ukDnDFfG1AYg6e25wNOBfkVLNIKQpJlUdXNkEqqKaTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9461.eurprd04.prod.outlook.com (2603:10a6:102:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:36:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:36:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <Po.Liu@nxp.com>
Subject: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Date:   Tue, 10 May 2022 19:36:15 +0300
Message-Id: <20220510163615.6096-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220510163615.6096-1-vladimir.oltean@nxp.com>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0097.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::38) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a00d1206-4eb0-48eb-d3ad-08da32a33ae2
X-MS-TrafficTypeDiagnostic: PA4PR04MB9461:EE_
X-Microsoft-Antispam-PRVS: <PA4PR04MB94618A0BC40B8AA66C551236E0C99@PA4PR04MB9461.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YCi9NTgsh1nCh7E039xHTON0iUxutHPD/1IfoKBWHwPKV2tBLyJkiGo+Ruz+SVJ6hhRF84M8SCUP9BOO5JksaEs8IpdmJyZI9CoeXEO0HPOn2XWcRL85MUTXtQrsAsDFucSflSblJ4V+y1GEJ0lQ8Mq+tPxTiV2DMNQsR79AqQNUDT1rgxoSBNFeP/AGa+lka3Lj6OA0ZbRuhjlEjifBtu0rfYYcYlHMZSTK5k8iRWefCrfipyd0AXJrrJjF5JM4aVE8hKBd74fYquId/vp8uVwJFzM3gzWPpVQHBCxiKOOAzDllQWBxJLPpWupkLugleJ5HDNzyo5fHXExrDLbOcB6Q4RU1Zisjsj3wuyfYfcCEXyRpfJNg55ThhHSfsL2suIyN4PMfhHXCA7ImUZ9v8XGgLoH6vtppUsiSOZ9jhc4Z2P5K/LAA8NaLLNwSJPWSrGrJT3T76HTT4FKxIJS/kfHFZS6WWn7ksgPIsYrxP83BXjUGh4qwi0bWlOEjZo3oMCDFeulQywj98A+uANO6FmXrdfuz+MnUaVNXTqRG5gpoLybeDKMX0M1+6jrqFz3jT+I6zbjVGXKba8D2gzs/eOnjvfl4p/dCXnZAuMYO7q/XQsA0o25wCfxaNh1UsdqMmneeIjDSiFLfWYnZyIR3DuzBWBCCg6xL4S65R1fyt2GSwF5JvcPgpZeTIveEQMWboy3n2RXiVu8rCCDGyRsZ0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6666004)(6486002)(508600001)(66946007)(52116002)(8676002)(66556008)(8936002)(66476007)(6506007)(4326008)(44832011)(5660300002)(38100700002)(38350700002)(316002)(6916009)(36756003)(1076003)(2616005)(83380400001)(54906003)(186003)(6512007)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uhBacEQM20mLoM5Ggipn1sDlIOlTloQ4mTur3zxi/xXuX4tCJ08pY5VD3dAz?=
 =?us-ascii?Q?huG/i+/67HmcHRoN2YBoIcvPecFeHdwxFYiRkL5kugTXdvl8emQ7dCyOj9yd?=
 =?us-ascii?Q?WxRtaLSI74qQoqvWr8ssLdsnj2O+a7CU1oS10Juek9ksOqYcfpPgj06fvbb1?=
 =?us-ascii?Q?4bugRRRvtdAqiBNfJAYT11as71pTHXMXZSm4t/+GWFN3hCdS+HGXFU0pkcwc?=
 =?us-ascii?Q?5nBktMKHV7VdX3Apm5pNcpF80rktYW8JnOpmS/FtRd/7GokfGt9VS4RabFWq?=
 =?us-ascii?Q?KwBmUtMFK9OsyY+2e2Kz2HnuFLLaW+6HMhq0g/F68nApe7/WbIHqjJ0K60jU?=
 =?us-ascii?Q?IkCXFEQmZ91khwVDnMGEI6YxQn6sz9wimQYzy8kB16Amg1Wz3sy90k1JgRWd?=
 =?us-ascii?Q?EBQI6fMMz/RLjc+OJ+0gyD9UwWRQ4gilJtZR9cjWwnB/pOJ0USjCRbPEAn7i?=
 =?us-ascii?Q?eICnlQpgdojKPhuGrKpaazZ8yM2GiL5huEb0ci5DNvot+AV9flZhVbm2cUKw?=
 =?us-ascii?Q?JtF6RbMUWyRRms+pN3LE3YPchG3XJyv007wt4pPszVB478gmdcKCQ6dUOY7l?=
 =?us-ascii?Q?YY3eStwvtoRe5x9eoA+3hws+JDMtfUrOJhes+lJyEuUpnc9BrZdLZHgZEXqm?=
 =?us-ascii?Q?z/MoFtcbXkztpfQm65ygQtXgH1kj35C1Zfjw8XLUHbSP21bj26m3fFt2EkvJ?=
 =?us-ascii?Q?A3ZVI9fLj5u6ACeqy2nMlyidJ/HDyXTssOv3iGU6/3wRkLWYgl/auAEh1XX8?=
 =?us-ascii?Q?m9Ypc0/Jw+VRO4qku8hVWMY/Ja9f9/WlK6HJS+tFtcsEc9cJeN+TeGoZkGRo?=
 =?us-ascii?Q?j6DxWNReZQMrInf03P/XhDtMYh3TfEeUWpUaFyBaalhTF1tKMtqBDgyoq48t?=
 =?us-ascii?Q?GpzG1zMRSzvMotVWrptsNeXMkt+3zlHBB5M9Bu7Ec+TjYB51jsApR/5RwKfE?=
 =?us-ascii?Q?c7N0A69eOs/YpcSsQhW0i7DhLKx/FREoscXUlARrEYzd0QVQqcfSvTnou3lG?=
 =?us-ascii?Q?UnMFmxwswupZMbAcsEEWhkqGlcQk/kEo+qxvshn1EAtvWwOt/XYHt2tDsbYZ?=
 =?us-ascii?Q?zo9sNSCun1v8n2zJvmS7jVlG1dxmD2R6q8rURjUWeoQul40NAECHVjLxLkAw?=
 =?us-ascii?Q?IF7XOtb4GeKRgCsZUCvaOioGZbAalhcQvJQGG2ROoyCwXc8JUD8MflqQVRZa?=
 =?us-ascii?Q?qS+LS97bgM30YEli4FuBMC/njbfWeu8H5LYq/u/+BoUTQd4QTDgN8cj57Ho6?=
 =?us-ascii?Q?w0a7orIrE7ZX3eTfYWDqRYVSKbp4R5bJFUtagqb5emM7tZ67J7xHet0DeybI?=
 =?us-ascii?Q?+zocMzzJzzvEADXwCctfhQU3uUaLWu6V+u2WDZWxgdlSnv2pJfFHtP/gaF4/?=
 =?us-ascii?Q?1ZT7jdltTVHhHa0VBHGxiCs2JqtECQ3UvhdmEmOdhXdGMIyp4+23IcC4Yuzo?=
 =?us-ascii?Q?rl3vjUY4XGrEdQPWUf9f5eOdqLjvweFeZlIwM5H+/tcK2uAbheGOpGa4xLc1?=
 =?us-ascii?Q?yEa7crRGO3WDBLPW+BIsMrnwhLLShbm6y6hmXgFjqB041tAQOLYxRN6+0yIm?=
 =?us-ascii?Q?upKlca0SY/EcGX27w26axcWgZP4edIgM1uU5+uW6Vxxn07B4QCNpdV4BPKp8?=
 =?us-ascii?Q?aKuEMdYo3nnOLnb3FFevCD1yhvOhDJeEzmF6z3Qo6oilP9Kw3qmJenkktTIi?=
 =?us-ascii?Q?Cx1nMwzRhaS8KrASJO77rvgnR/bHNLgZos/4qjKSd+PZxBljfUXfj1sFvkJ+?=
 =?us-ascii?Q?HZCUBtsMGYlJ1ji9UUVYXBqApPK05/4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00d1206-4eb0-48eb-d3ad-08da32a33ae2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:36:27.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLaCwaLxAWt2A93HPd1jg3+bvnFUY34apVR3i097Wnu9zXayetNLQURoUREhy7+talvx+94e/CLPyVCNtSsWpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
which will never fit in its allotted time slot for its traffic class:
either block the entire port due to head-of-line blocking, or drop the
packet and set a bit in the writeback format of the transmit buffer
descriptor, allowing other packets to be sent.

We obviously choose the second option in the driver, but we do not
detect the drop condition, so from the perspective of the network stack,
the packet is sent and no error counter is incremented.

This change checks the writeback of the TX BD when tc-taprio is enabled,
and increments a specific ethtool statistics counter and a generic
"tx_dropped" counter in ndo_get_stats64.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c        | 13 +++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h        |  2 ++
 .../net/ethernet/freescale/enetc/enetc_ethtool.c    |  2 ++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h     |  1 +
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d6930a797c6c..4470a4a3e4c3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -172,7 +172,8 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 	}
 
 	tx_swbd->do_twostep_tstamp = do_twostep_tstamp;
-	tx_swbd->check_wb = tx_swbd->do_twostep_tstamp;
+	tx_swbd->qbv_en = !!(priv->active_offloads & ENETC_F_QBV);
+	tx_swbd->check_wb = tx_swbd->do_twostep_tstamp || tx_swbd->qbv_en;
 
 	if (do_vlan || do_onestep_tstamp || do_twostep_tstamp)
 		flags |= ENETC_TXBD_FLAGS_EX;
@@ -792,9 +793,9 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
 
 static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 {
+	int tx_frm_cnt = 0, tx_byte_cnt = 0, tx_win_drop = 0;
 	struct net_device *ndev = tx_ring->ndev;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int tx_frm_cnt = 0, tx_byte_cnt = 0;
 	struct enetc_tx_swbd *tx_swbd;
 	int i, bds_to_clean;
 	bool do_twostep_tstamp;
@@ -821,6 +822,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 						    &tstamp);
 				do_twostep_tstamp = true;
 			}
+
+			if (tx_swbd->qbv_en &&
+			    txbd->wb.status & ENETC_TXBD_STATS_WIN)
+				tx_win_drop++;
 		}
 
 		if (tx_swbd->is_xdp_tx)
@@ -873,6 +878,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	tx_ring->next_to_clean = i;
 	tx_ring->stats.packets += tx_frm_cnt;
 	tx_ring->stats.bytes += tx_byte_cnt;
+	tx_ring->stats.win_drop += tx_win_drop;
 
 	if (unlikely(tx_frm_cnt && netif_carrier_ok(ndev) &&
 		     __netif_subqueue_stopped(ndev, tx_ring->index) &&
@@ -2552,6 +2558,7 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &ndev->stats;
 	unsigned long packets = 0, bytes = 0;
+	unsigned long tx_dropped = 0;
 	int i;
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
@@ -2567,10 +2574,12 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 	for (i = 0; i < priv->num_tx_rings; i++) {
 		packets += priv->tx_ring[i]->stats.packets;
 		bytes	+= priv->tx_ring[i]->stats.bytes;
+		tx_dropped += priv->tx_ring[i]->stats.win_drop;
 	}
 
 	stats->tx_packets = packets;
 	stats->tx_bytes = bytes;
+	stats->tx_dropped = tx_dropped;
 
 	return stats;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 68d806dc3701..29922c20531f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -36,6 +36,7 @@ struct enetc_tx_swbd {
 	u8 is_eof:1;
 	u8 is_xdp_tx:1;
 	u8 is_xdp_redirect:1;
+	u8 qbv_en:1;
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
@@ -72,6 +73,7 @@ struct enetc_ring_stats {
 	unsigned int xdp_redirect_sg;
 	unsigned int recycles;
 	unsigned int recycle_failures;
+	unsigned int win_drop;
 };
 
 struct enetc_xdp_data {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 60ec64bfb3f0..ff872e40ce85 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -204,6 +204,7 @@ static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Tx ring %2d frames",
 	"Tx ring %2d XDP frames",
 	"Tx ring %2d XDP drops",
+	"Tx window drop %2d frames",
 };
 
 static int enetc_get_sset_count(struct net_device *ndev, int sset)
@@ -279,6 +280,7 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = priv->tx_ring[i]->stats.packets;
 		data[o++] = priv->tx_ring[i]->stats.xdp_tx;
 		data[o++] = priv->tx_ring[i]->stats.xdp_tx_drops;
+		data[o++] = priv->tx_ring[i]->stats.win_drop;
 	}
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index ce5b677e8c2f..647c87f73bf7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -543,6 +543,7 @@ enum enetc_txbd_flags {
 	ENETC_TXBD_FLAGS_EX = BIT(6),
 	ENETC_TXBD_FLAGS_F = BIT(7)
 };
+#define ENETC_TXBD_STATS_WIN	BIT(7)
 #define ENETC_TXBD_TXSTART_MASK GENMASK(24, 0)
 #define ENETC_TXBD_FLAGS_OFFSET 24
 
-- 
2.25.1

