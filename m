Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A5A62A364
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbiKOUu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiKOUua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:50:30 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60078.outbound.protection.outlook.com [40.107.6.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1DBA1B7;
        Tue, 15 Nov 2022 12:50:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or0yyZEwtbspAouyPZcb93uicXJRxrOlXSc8dPPXb93RN7VE0jJSIVEXaTv3UtG6hs7vnDBxjrZEWx/OD1m9J82Xh7ghSGq34M3eSuNfkrswhX6IqNWag//wsOfNUWDlPHxyNB0neCoQnnK7PkM6SaIbo51f9Fd8fgGTPIJ81Tt3eAnUWTKTneUrma0Vys8K2c0duFA3pLbTSiFqph5zC+Da/uNKGRbFIq9YiPcLudXNkMm6zqKfJ8ryqvk28aJmJx1tRhu5bwTS8Yc8u+gITH6qcX7i4w7kV7pu8GNksnYjaGeZXPAHCHvxv7NHSQ3e8s5wM7tg57bD+2y72Frpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPWHFB/asynaldEzOf4l+XeMdTB+9kDVQLjJFApCh0g=;
 b=AvCkPvMWE8HpmIBrFpsjOWs8PKIrK6iuNoEPBztaYuS0KOrLnhHRpBzrX1xOZEHR2VWs6AzotVr1Nrj+IitBiIg1gD5S1T6b074Kpn/RvnuB82Rsq6qoClgOFyGHXL7hOWb3cx2KBoLMjzBzXlBwSSAdSX8kfAoQePs+Ss0HMiRztoVs/ytkyRv2IlJwoQzj2PZlHuAgForU/eaWBxApWLfRcxbb1nW8wuUyQi7a8UTASut1RImKZ7sUdu/niH7cy0XpV8oRQXmwwfUS/cfkkOdV3138mXyINwWXaW5pOpG+8vyLUnQDLp8XM+RdGKq/KKrT2YeYqwod8MLoTV5HLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPWHFB/asynaldEzOf4l+XeMdTB+9kDVQLjJFApCh0g=;
 b=AzSawQIEPSOJV7KaaU5hUTaERmx7kvjyrAD6Yn5R4N527k9OmQoTLI5vrzbpM4WjQwT2RFH0WYEhmeyJ+o7igE1MB54IzSYw25eDXj9pBLVpSMjW9ZXsn7rrQnpnIDSkTSbmC/op2/oYqpLhORmjY68jdTgT32cDYg2T6N1XaUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 20:50:25 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 20:50:25 +0000
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
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v5 3/3] net: fec: add page pool statistics
Date:   Tue, 15 Nov 2022 14:49:51 -0600
Message-Id: <20221115204951.370217-4-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115204951.370217-1-shenwei.wang@nxp.com>
References: <20221115204951.370217-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::34) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 525f1f06-9446-408c-b0b0-08dac74b0515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVHZyPaPDd5dbBw5mQu14byiiAsSQX9ja8wcegj17IF+onqlu22gXfKYHPOmn+geROLBhMqYcPYnc5n32ACb5xTulfFbm8wwTwaDFSa/LitELxAeNbTSeagvz8y6IJ6lUn/W/0BqB8HoARAP99dOsmmE3p42Z3x1lB7cAbhYzkMzpF/Or2ub+FFIUKK/vJZHC5abDJJ/5A6xzOVyCOxhe2FgxYgavZBuoSGRbB/ohl0nQV2TB05o9F1Fb6jxAaw0gWCTfm7ulrVCNoCjalHGaKMB7EjSUet86bViTf+LHechdEPqkrgnbehnt6elJVmuq+c4xTOgOtDiwY9pyqHoCczF8KRC2NOhn3ryWUKxusiJzZjcWhbE6OrhTJszZ4l3A0e65dH8oABea/zHWKY5o9vLSQp5OUOQp8Kf0j5WV2n2N8vBz2tahjZPeSrftsnnNMl1Iw5JQcBMOG/Z9OBa5IWIONKPPaAy9bsiRxRXgGA/EgotIHfesYe/SZw300tzVoiekS8RM/vX6EyXBbz2mKO6Hsg+gxyuS572y83ph+07JM61gfCXxnHNHNYRXGUA/tFCfnCx/l7z/zU7i0LczoCsTyxFWroYuuCzSd3kaNrJst/GAyncO7XvxMpkMsz5eC+16EkwZ9Kj+El7WSJGygf2vJCgcdMzb4wzC4zl0op7YPhMOmHXnrZiSllnEln1J1x7TQptDTduyDNDhHEwmTHQbCcvE9cLGADwomMGYBi4Ng/OZGL36Au7L7T34bsDOmaS0BBWwIBzQ8BSPCqm0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(66556008)(5660300002)(2616005)(66946007)(66476007)(6486002)(478600001)(86362001)(44832011)(7416002)(186003)(110136005)(2906002)(36756003)(8936002)(1076003)(6512007)(6506007)(6666004)(54906003)(316002)(38100700002)(83380400001)(41300700001)(52116002)(55236004)(8676002)(4326008)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RLTqxAuWSJp9vO6Oi74sLEi99yZxm5PplD6jjxQz65nVZYYXIjaOxnkBXDIm?=
 =?us-ascii?Q?Uf9iFsFsuIp4/eAyB9TePjrg28vFzpoM3143L8ddIC7IfOpIhIrXkQgi/1XY?=
 =?us-ascii?Q?TGOiX2ky4xknwi8/E+Kq8J9R8rT9IDfP+2YSbBbW/jSFp+k6HsbDLWGBrXer?=
 =?us-ascii?Q?Ofc+d9Xw81onO3xoJnImwe3M231sjbvtZZFURmbLvqUTns5KI0dyk5yirSp5?=
 =?us-ascii?Q?W23eWYM/GG/RbyZqK7ThEZooFK8OKbMthRwFglQQ9O1ie2VC/3z+xYQQSx9u?=
 =?us-ascii?Q?4ZiXKCNeWDSKZ8Wgm+tTQFEBCGMKSkIbFYZQIm68eZIgGty0DHu9A40K2qLV?=
 =?us-ascii?Q?OsBqp3XHM9HBuiUmw1muPACoUxMjW0h2lw3Myiu2R/7LcWEcX0hI2U6gvUgq?=
 =?us-ascii?Q?TtVqclUx4N6quVrqJkRghU0RPPFq1+WQMcg9cNB/Lb2cP4O9kNdKaalyxl0W?=
 =?us-ascii?Q?rhbFSlIL1ZOZ2/PSF3ifz5s7hWXlowoHv2h67PR+AJCHKpw5XOoRqJ27B9Gr?=
 =?us-ascii?Q?4YB433wGvYeC7HGyZQPCG2cHQC/xCSzNLS1f414D2m34bvg5ayoL2Drs8dEc?=
 =?us-ascii?Q?nY3EO9BT5Mq9DIrjfpHYkTQSGFB5yk/9j0k+vzYSbztWiFIYbN34tAYXvy74?=
 =?us-ascii?Q?RbEm/2TB3hzK+vkdjCXvMOQ+oNOfRYIuCiH29tZdOkWmZZMAXOWnSm1dU85w?=
 =?us-ascii?Q?k5HDYIHhN5w+XaBUTU0qfyS0Zmbphkor5BFb4nH9Ps1AwoCdHPqj22zgUBOv?=
 =?us-ascii?Q?fmUH5a2a9speeTn8BiS+ki4i3D4Qc33/KRDgMgCypP1qwvcfRk7rHgPoGl9M?=
 =?us-ascii?Q?UPqH8whjswLd5PCNuKT11LR4598gOEVyr6xqfgUBTvN7K4sV+r87o9BfiWS8?=
 =?us-ascii?Q?e9a1Iywj3l8O85LqAYbjSTJV1ruhJv5RDjbKrZDMnDHLi2t9sSJqC64RSWEN?=
 =?us-ascii?Q?b1nFZGark8clu8RrVma8OoBujEN02P5mDrN/kANnY8WQPNTh5MkbKoy4obV0?=
 =?us-ascii?Q?hI0poaR0XL73VRhGKtAy8+9PUOj4YyMZ0EAJAiWqVZEVYQX+jraOdSpMtNXM?=
 =?us-ascii?Q?/b2u24K8fHph4U0I7XTcDzxBDwMDdA22X81Y2KTc7fYCyQxusCt5oUhzfxZO?=
 =?us-ascii?Q?4AO3ydcIcmYGWLT4NutDFUxQaxejsNAiir4JZWqebZh8fvrJr/mJIdp5C+nV?=
 =?us-ascii?Q?3Ctgb37pgi/EB1MNyiV9FrM+zM68t5wJMuaRldKD+Nv6l9Slolx3kBggYwcj?=
 =?us-ascii?Q?hcqDWZ3LYorBr/uJub6xlovCte9qWUHlJV1sjdWu2saUgrqob7tLV2KCEt8S?=
 =?us-ascii?Q?jkmNN53KwaPNTdudDpOr9U+hQewJhls6QGQ0UjcbPkNailh3Z7r9u6zSjHIn?=
 =?us-ascii?Q?VwnLfFYymtP0V6mlBulvCn3filobx51WXW4KBIPpG9cVV1mX4IQAvhPURp2B?=
 =?us-ascii?Q?VcvWP5L1dPPmwjpsSInNGsotnvytS+Y40KRXZJwGFugxYiZLQIhAwe63dJwi?=
 =?us-ascii?Q?aMpDr29ttE32oBQ2VTmKDaAk1wtkg9+r/0q+nY0fxf0jq3/tlmLLNGU4CS+z?=
 =?us-ascii?Q?4+z3OGSVuFJSIv4A1Nop0dxmawtG9Q2tOXc1cOzZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525f1f06-9446-408c-b0b0-08dac74b0515
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 20:50:25.0472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMwhrdbenGfTfKBkrOgKJ7Pbo1DZlwi9wVd/PiQZ874PrVpAt/+NV8AXuuX+lF5UbbLSBnBX6TAqcl3hAyfEkw==
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

add page pool statistics to ethtool stats.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 24 ++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bb2157022022..ae905ea1ab7d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2755,6 +2755,24 @@ static void fec_enet_get_xdp_stats(struct fec_enet_private *fep, u64 *data)
 	memcpy(data, xdp_stats, sizeof(xdp_stats));
 }
 
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
@@ -2768,6 +2786,8 @@ static void fec_enet_get_ethtool_stats(struct net_device *dev,
 
 	fec_enet_get_xdp_stats(fep, data);
 	data += XDP_STATS_TOTAL;
+
+	fec_enet_page_pool_stats(fep, data);
 }
 
 static void fec_enet_get_strings(struct net_device *netdev,
@@ -2784,6 +2804,7 @@ static void fec_enet_get_strings(struct net_device *netdev,
 			strscpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		}
+		page_pool_ethtool_stats_get_strings(data);
 		break;
 	case ETH_SS_TEST:
 		net_selftest_get_strings(data);
@@ -2795,7 +2816,8 @@ static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return (ARRAY_SIZE(fec_stats) + XDP_STATS_TOTAL);
+		return (ARRAY_SIZE(fec_stats) + XDP_STATS_TOTAL
+				+ page_pool_ethtool_stats_get_count());
 	case ETH_SS_TEST:
 		return net_selftest_get_count();
 	default:
-- 
2.34.1

