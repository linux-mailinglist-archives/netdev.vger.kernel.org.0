Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11FD602E29
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJROTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiJROTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:19:36 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFCB13CF3;
        Tue, 18 Oct 2022 07:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Typ9IyC6v//k897PcxbJTVGqBNZrnT83FRfj2LvENzzVQxACc/ZhCQ7o5ZN+qJEFgOOOrg0/hl7Ges6NSHTzvJE1c5tEg/7wxvArM+AmAOEPWBspImswhjZioE1IUt/5ugoZFpRgyJPnXKow/h0tDh/MwEdYI9o4q5N9KxLn8JQMnSC1tfZb0xeBFOjXRvLh0MfkVISWyeIlx0sPJoe0RkIR43b7Ql5hr8VViygwaRy0OKIOxMnm+yf2uTHtJKeyPfYF9bEfTXXN4XaPdyNc+Gc71aCwcJuiOsA964feW6pci7W4VFZGTeNGyluNSAFbeyP7OFu38jLyM2LBmaHSTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocy/Ft7iNPFYg8VGG/7ZlNOi2aSCrxRn06R8n/3tTds=;
 b=lF/GUwdF1MY97u9QFGmVNEbDWWePAmtqLoihIe+AH8PrhyGfO7RT5ibn36q+g4mfJiowif7hP5EFTJ/65c1JnisSNBc/oWBaecTTitfpgp/YWvP+5tFgY6b5r9Kp/POQuGxGQkkDPuS2G60JotgwHWL0ofiUfB/CoU7cyjTPosW4rGOSg8K/JqTRs9BG9ZcT2/BAOJ3NsxDaAzhAQrcYN+mWDFAGzFmyHcKYMXgDR9qkWb7/5FlNztNmF5A7rzZqkrpvttrzxqXgJJbLmbRvT1YaOR3FHB3ZKxdcVfoFtjPFybjdgf7FTOI8DZ+Z7VSSxY1EsToR4mUZUG65AKL6jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocy/Ft7iNPFYg8VGG/7ZlNOi2aSCrxRn06R8n/3tTds=;
 b=mlQZWItWnKNAL05vRvEMbnqASHJ0T+6cLjcBDSfm0rpvzq+36FokXXAuCY8IKs8XxrgMOrfkIhtcn3RTds8c7jsBmjbdUGqLHpCwOqRXDZxHDfT3+0Oe9FwPNXnSupw2nubkoEg74Ddk2331OM2WrrN1KZZxpPkWgg5bAEz9rjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:30 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:30 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 02/12] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
Date:   Tue, 18 Oct 2022 17:18:51 +0300
Message-Id: <20221018141901.147965-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: ca9ce347-bb56-431d-a64f-08dab113c539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ErBV7CiKZCsIS+6UEisqNxjGoPm8ISTR/WyKqjjYXRCzV5xjolam37CYV1wNggUJsH/YEMj3BUkouDNbdoCeTuqtwfBGI5BqOO3qp9Sos6lLgSRquh/JUBFlO4J/9AlewPfwqX1Yb8VoyWcR22mXeAP2Y6ad2v55KzVGZXSqxoYe0cAiWCwwke1fym5n4KB2waKxbAZz4zYOxT+Z5ceOpIAJDikLSL2199fY8o5//qZ7zoMsSi02H55Ph1OnS2EPeWYBziJgLk0nVFF/HEVeqRrDt1MEEsaf+i8/QwKi+NO6WOejTAmXvWcsbZJdXhg2uvIB29RQL64fK3lUbc4n3be/tSg+9FD/0jcjYxUWCEkYF/t54Ikz5aqXs+r3oPOZYo0721+d8RguhQv/ihjzidsxgNE04CInEt5QEJARMgXIzJlnW8G8s3IzWmGcS9RkALinnY8eiphTXiXJ9uyZVA2jPKoYLfgy+RmyQdmniB12x5wmXZ4GnTbGRfuiEDiRZZmwhYdDgKhw58QbL3NloEfZKv46oYJxShp0bDg15utP7rfBXED3CUM2xRhDFi08dsHkExDrU6+nTsKNKxMbHE7qHc+5c7pRMRRlx6DYTBjjTtxfcWL4QLBHa3ExGKJhPqJt2VJVQjMV2dYR0AhwfJKYLG+gEtyfVnqvRG3MjU0sgfJpIGbortvgkPVerDHlhwNWfqu8Kt7WZw5ZNnK0mOWShBQo9I8rWviXryttSMk+gibaA0Mo/C2F/2kiuwMspW0pqkfHFs7TsFZ3sAmqAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LdlBBr3KVAL2c1PCNQccy8t1n6OrtB7BCLV4MNfBquRDLTQonc8AE2A4yIIL?=
 =?us-ascii?Q?Rlpj+S9nP4hPDNy+rQW7yAF2nQj3sVBH4vIxL3BOgHI1usX0uPCMIpPCbxYM?=
 =?us-ascii?Q?E58s6HhZ/ebzolR2P7H8GAB+2W43p04WhJGKMb/az5SnQG6p+WsM0L1nbxcK?=
 =?us-ascii?Q?kPOG6zI1eZOH3fCvswJFAe8jsYpnuIPe3bU3dXzr9PpMYECw3rHpt2vaMkLo?=
 =?us-ascii?Q?Zbs2Tq+zowmbOEgnTpJpSK6QIMwsoNLLno66Jabyu+n/ZEUHSI1Brb/AbyMJ?=
 =?us-ascii?Q?TIosRPiuzy88ZgE8bFjENQkcv7FyuO1fgzluwf6x3t5FLUseKSswH28QgpDm?=
 =?us-ascii?Q?pWQVCfkqcglKIatm91t4R1c2nWEdydMBmWWbBOQVVXAzMLlHGyabHFCXruPx?=
 =?us-ascii?Q?HBZ5vhuHwe01N1ntK9wU3avYOCqI7qZcLYNbFq5/jKYnmc57yeTzNupRMDSj?=
 =?us-ascii?Q?ugyd2dva/t1iR01QvUwG1/G1TpsMW/iO33ocdmBKBzvZ0v4zZa90NGxu6/UA?=
 =?us-ascii?Q?//E2CEQXWrbriA9V5DpAd9zYN30GLjXaxbWPhDAkjj/n32wDO1Np5iaDD3sk?=
 =?us-ascii?Q?EWt2THk67fayx46EgMfbELbEwYcuB2aWCnYByc/Mv+mZ4Xg0+ni8fFntrWHh?=
 =?us-ascii?Q?ZfKWBHxQcGJXk/DLWaBZ4bmGj4Sk0tMj1t83CkegZjudjaqiJ1oUZ8Yn9qUK?=
 =?us-ascii?Q?d2JbW96IGqYdqMGfa5SajSD51tm+UuujflhLC6udB+FenzSwPX65ANHlwn48?=
 =?us-ascii?Q?Srzw3wHINUnhThtOzujjbNy3jfMNqc7jm3hNrblsrSSbZ/UzaXc67YQIPezN?=
 =?us-ascii?Q?BR/DhGl+yHbTYvXXHfVoftIg1bppA+zNhid1CaK/Neleo9bk9juggz+djQj0?=
 =?us-ascii?Q?+m4OnaSpReHPuj47Cbcdfqq74mT4a4dtj3L34dCMwunnsukOlbLRZoLuL9n3?=
 =?us-ascii?Q?tL75Ss6Z5b02nay+h33bE3smIfJgpgX2HSoG9k8FfysKgSd8pCE1gzfesviR?=
 =?us-ascii?Q?eW/QKKrIU8p8NvRijISLA7iVFh7jzAhrhXaTNovvYfLQahuCj2+omSpQe+C8?=
 =?us-ascii?Q?eKaCwnqqfvaQK+iTz3NZXk2leB1wduW2dBJEPvTdFhnY84UMKJNlPGemcA+E?=
 =?us-ascii?Q?ta30MhSTG4cp4IqBxTEiyY6dWrdbxq3wlu/wAX02VQQG/tUBPnT5wvbOkaDg?=
 =?us-ascii?Q?R0eQQTBejGZsP1peVzlSYnNj7hXbgqY+wG+9Q07AlJ7e8UgRItPNlr7wdrwb?=
 =?us-ascii?Q?7Z14C9mz+o1+AkQOVHdwJp7+CWYZOk3rwVso+SGVF76vOWtzpuGtb6nBHfEQ?=
 =?us-ascii?Q?HaqQ8ARGoNv1iWzYc0/AtwBu5Xw9lc4tXUlT3qGVWbgiKfq49ICT+GlQgWEf?=
 =?us-ascii?Q?65vvdE/G69L1JHung1ZzhtBeBY3C25ZzxhfGKNQv0ETSh2bSqphUx6Mquvgo?=
 =?us-ascii?Q?o+HB3Y+nDaxPfIgaY2yPxJY4Gx3vXeLZVT5t3DG/shKQcH72n3x0JSPG7F4d?=
 =?us-ascii?Q?7TkNBqYQzPCKgh/d+pp+DPS1FhzD1a+L3IqiczkyHC5ryAEtUaoZdubkx1O4?=
 =?us-ascii?Q?SXRBeL7NYQcuaaUA+VJS/M3kWJKpyBlfJeAtRg52Nt+u12AR/MX5iMSf87NY?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9ce347-bb56-431d-a64f-08dab113c539
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:29.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2C2BDGgliBBrCp1a1aNIk2ce08sbt51iwVnjxVG8XkumpQCvDhBN3dWSbmwecUEk/Mk6I0Pd0AoPy/+T5gkj7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
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
Changes in v3:
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

