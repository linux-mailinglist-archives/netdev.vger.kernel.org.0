Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929075E7EDB
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiIWPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiIWPqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:46 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBDFCC8D8;
        Fri, 23 Sep 2022 08:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4bneLF4s2WBtPC9rtRau8+BRhB6pFujaFmNedNiZUmXPNzLHUDiDJpR9s4ru/tviKntDU7gD1sfMYRAiIxG1pAwZoCm/e+oqUXvEYYpA+mXS6SlYrFc0peccvJKTVC0B3k7Ibt1mfXyR9qtKw/L6cGTVYm8nutv0RRL0mEA/HptMP1uSIaAbJKrcHNEU93CWTlvCAD8xwPT1D9DvQSl+aW/D9HEYSaZ1LQlNqbS7gmEDqlTZY804BNFiVoosFuyVT3GpQ2BPIRm/HliQ/obW8HX3pZPBS2nd+q5ba/j1ZnfVJKiRP0EvqB5ZgPAIdszM30FWR99yvfmv9VYF4dNPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgBWrXqvHUGsSPocnDI192UWSZ4tP2omJgi1606C6Fw=;
 b=CMUueeSh8vkfVv6+CkQIvqtW8ZLI/UksW8iYdMGA52z7mT+x+Y0hd98APEAF9RZtq0BNGlNogOiXrUABr69lZgLynWUNGG3zLX47/KLIfjBHpUrK3ts9xfPXRVaR+uDQxDlYLxgG4k4mI5I+quDhVOUcNzTTzbFgWJNoFYklf9lhQ1LggzKgKVtGo/+Iu4J1NWxvjmEwilia7MTDGYj83X2a2Ntm613nUJPXYOXg0ueEExfNnDCuLEXq55jcmdEDaJzDB3Jkyr9PylmqPmMy4XW1yWibQlKUkLIV8BwCyjTwpiPx8t9JKALOPVB74+LE07vK+/9o0yOR6IhcTYDXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgBWrXqvHUGsSPocnDI192UWSZ4tP2omJgi1606C6Fw=;
 b=LZlLRqL5jjQN4W+Aee8CDgQTSIXTcPEjZzBM3t1IqTqQvt4UGtVMbKj6T9/5rh+E6VCDQkFdwDVK84qSlmb/V6LMxsEof6r4hGhuDWumIpY9ZI83Kt7LRjyJjBNmv/Cp2rdoiwav/jVWD1CHXKMsqlQCuT4iOBkOjZ+XIgfHwbE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:41 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 02/12] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
Date:   Fri, 23 Sep 2022 18:45:46 +0300
Message-Id: <20220923154556.721511-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: 9193d902-01d2-4eee-bff1-08da9d7acede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ioh/v504VbsGRFGbiW/uQqgkXiz2jdLDPNt/rwkCwRTjKCQbbsfNt/4QfP9tF7TEUwTP6QGqiJSq0s2YwAMbGcpCEWduPmtJ2NOIH+42vKBS9ixzc8q4/Mm/oTUM4eVYP1olnyUliei+rgmb7uRgtb1f8OIf7DOckGvJzOOyPZ5MsRet24URGBNoGRMySI4x6rLX3OHwSFI5GBAb6SIFELl1M/HLzkjTMRdf9ZcD/7amCnTfqwjqK0Wf8bHoVntjwIorE/FJvWCQkQBFs/RKlyAcpu86GTK9WKbU4wrp9dJAWQQNTq8pFjUprlZ5eOMk+kRT9xekeK7QlkNjoZI7S8uLHaKyRrnTf/5WaQiK+Qo8oTfOl3+NLNW/lH/o4xhuURzFrN5XqPsBIl+HCRGAK/KXbgJLpGPKAD8/8aKuUu+8aXV3tzNHperL9ddROierNzGpfFlCnS06xser1kEbKDIfpnfie3YK50p9Yw3+Vhe1TAf5me2t7PaAHZ9PS4v0zkbywMTop+ZaBXbqVgDnHnOa0HiveQ2GtKsB5m5nZiYHU8J2DjR5aDsTy5PUZ8QIqUD8h0nzZgdlHQ9WdBqOhVoywT2BWowCRJYSIa49Rv7N1D6nMIhcfEMREie6mwDh8XYe24YWio/4z6odVDP2mOs6ZWPV3d+RprzQEb4qD0WRH4VllXrn1JyhRZjyFVSgq3UonF/Mq48dpPTWWFF0VBOScBJGdnriGLsp9B8J3HMeFXY5v9Z6K1qY6x50waIHDNcPSCgP0xKMSKWI63lloA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(83380400001)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jxkF8Z1B/sRyUQ4eByX09aKRcSSh04k+Sv3Gyey2K+6J7C0VBz6NADx1Bsg6?=
 =?us-ascii?Q?jGiiYaikoytMf5BgHSDdD11x2/RMvI3rdXnTaT5U4qjgj6tLmHaPIMp6Fi4E?=
 =?us-ascii?Q?AwDT4q8Nz4y2SXRR85tZNAHIjlZ+qDhfeUfTeGKX/a0p7qHDTZEnEdQRNf0o?=
 =?us-ascii?Q?D8e8wG0XFRs5SmkehV+c26sz+UhofZIKCl+n1W37gKTWUnlQAyV0b24ogTm2?=
 =?us-ascii?Q?qXd/8yRPFWDK65E20v0vQs3yaebXWga+N3XXHgit1WxpGgS4R8pJl5RX8r0x?=
 =?us-ascii?Q?khyZA+Cb844GNTRQy8pwFahyvsRoTwq25XpQkDrihSB2lFcuOJYfOCx4Wsh9?=
 =?us-ascii?Q?Y38MKLtINNwvjT7ekw7Fidy8OhYrTqZK0fCqT5OE4k/X+FpHnJtLvjS+KZpp?=
 =?us-ascii?Q?OZmHbLWU9DY9vqvo5Uv9EMjXEv37dcQL+WDIJ3RB0/GWQ06aMPe6xWNKAAJ3?=
 =?us-ascii?Q?bZuJ0V2GOzOB3qA40vYRZ5Af8I2Eo2fKLnyKN4jl2l932M934Pp6Z62ftvAx?=
 =?us-ascii?Q?7ScFHUY/L1F+4JgxMaCN/aKEFoCMNt4Ce6b57BRhY/GI0yJZTEeGvOsjePHH?=
 =?us-ascii?Q?S5PNjol7IMxWd7TRP0o87M69ajvl68ift92OWNOSEh5pdEjeWW0gxSyEtuNg?=
 =?us-ascii?Q?P3xNlM9wTWFxAq9zN2iJZPxw/dh3K/6DjqlgKIvBr5SEUJet30YengKEo4eX?=
 =?us-ascii?Q?SL7QPHVh9KlIcWEOWTisq3AitSmlJc9s/iWuLWo+L5zjkvLy2cDMGK/a85gL?=
 =?us-ascii?Q?xbENBpvdYaUmygav8CWkqazRc835pouriB761feB0R0WN3xSpf6Qb1bJleu5?=
 =?us-ascii?Q?QlSTxc1mgEJdepUcSF/6GqLi9z2KsGqBY+k2E6f6Tc3Wk9PdztPOBNxCH3f1?=
 =?us-ascii?Q?dW6Av+d9ETPtAD1chA4JBZOioCWBHAo92QAZJwJOGhhTgma/qtb5EE9lbR5/?=
 =?us-ascii?Q?5Dg1uzHvlZKfjB7EF0TWnfCdmHgCobB/bO6yYurBx0dDrXG3KpGfVNAWu1e/?=
 =?us-ascii?Q?p9tMgkEi5ZaZTzKV2Y4NZobGBdTyqX+JfUT4rVzUJFXG5qv1tn5ysDFjTOV7?=
 =?us-ascii?Q?46GG+RwY/CyeZCx/XtEyM8+n4ain5n3M62YuvAo9svagy2+lud/dEmHl2ZmH?=
 =?us-ascii?Q?vHf8MVz/RQXFeInTcrzOc3vJzR6POaibqiuvv/hRlX/tfM7CyBNjdEtDOai8?=
 =?us-ascii?Q?tyGXxaVG7S39fiJ/UvLOfvZea7bzDsOCszy6h+W9JKgyvW1Eqe0rwAbJnep8?=
 =?us-ascii?Q?2ry/c9c8zkY5alqHIG00vpbsLWan/jAw+/N40ii6/cfTgiFaSHfFn0VYvG4C?=
 =?us-ascii?Q?fbS80ijVnchQCggCSLzrUCXhdsZpN7cxwDomHq1Ti+AlbfemPi3ekGlohuRc?=
 =?us-ascii?Q?3X/NLMx9qSYmLCd7KREt7WlSZNYAbfN2NKsXgUtI+wmW5TMrkU+JI+GuSWfI?=
 =?us-ascii?Q?QWDgpSfXdzJW6gOzC9IBavcH0yzIKwBCVErEBDDyibXWsSQapwzFIPlptrnb?=
 =?us-ascii?Q?Y30DeKqSHlaysAyMCVw02J22O2lb47gc4mkC74U00ZPv1ZcQOhpBcA8+jpnM?=
 =?us-ascii?Q?ksLyzyQGwvQ6teOccJ0nvcAyU/DdGshWNzr+NkjH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9193d902-01d2-4eee-bff1-08da9d7acede
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:41.0211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDjtDVFuEz09vXMRizqSeV9+PGw9T8Z5QisqERLiZQeos+JD8wTXpB26Elng6lRjeXC2u6U835oZJP7sLXDTZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the variables in the dpaa2_eth_get_ethtool_stats() function so
that we adhere to the reverse Christmas tree rule.
Also, in the next patch we are adding more variables and I didn't know
where to place them with the current ordering.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 97ec2adf5dc5..46b493892f3b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -226,17 +226,8 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 					struct ethtool_stats *stats,
 					u64 *data)
 {
-	int i = 0;
-	int j, k, err;
-	int num_cnt;
-	union dpni_statistics dpni_stats;
-	u32 fcnt, bcnt;
-	u32 fcnt_rx_total = 0, fcnt_tx_total = 0;
-	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
-	u32 buf_cnt;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	struct dpaa2_eth_drv_stats *extras;
-	struct dpaa2_eth_ch_stats *ch_stats;
+	union dpni_statistics dpni_stats;
 	int dpni_stats_page_size[DPNI_STATISTICS_CNT] = {
 		sizeof(dpni_stats.page_0),
 		sizeof(dpni_stats.page_1),
@@ -246,6 +237,13 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		sizeof(dpni_stats.page_5),
 		sizeof(dpni_stats.page_6),
 	};
+	u32 fcnt_rx_total = 0, fcnt_tx_total = 0;
+	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
+	struct dpaa2_eth_ch_stats *ch_stats;
+	struct dpaa2_eth_drv_stats *extras;
+	int j, k, err, num_cnt, i = 0;
+	u32 fcnt, bcnt;
+	u32 buf_cnt;
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
-- 
2.25.1

