Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F386DF61A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDLMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDLMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:50:16 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47017DAF;
        Wed, 12 Apr 2023 05:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwUjx2YpoqH8cbcPD8uK83WF/Vfax87KZgVS0NgoWY9Xow34GREJvt4C9RcvsQ45eGbrXMYiuMcstNMu/+i+O4MKrzBNL1zU4KW7EnODEy7mlxUdQbEfZ7nNzhQGny6u/n20roJff/WbUkuj3+sERouTpTEUGQoLGTYxZNZFVpMkq028BGVr9TkVFmeKz0dNTzkypH9FcBSagweuELXpZ1p5I3tzKjWLQjFZYeSsXGW1TT8e1PTaIv7QyDrbwJH5bh+vF0T/2eQGmJitilB2qRWIgiKf4adW6G8bKU5qZn5FssF8LI3wloRj1dXHPzUl4dUpI/MulSqaKE9XrAvV/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Edo4YSD6AKS3MQf0k+r4USSRl1cHKHtSqXCo8dExYJ4=;
 b=oZKwASxVjWHXfHrB1NCEulHPdUPRS0KYOHx9zOHO7w2z4m2KLCBuvL8STWahsfgFofXv0vg4RMK1AB/RVv/WznRjAbbzxwCr60kpKD2Hdfh8+GDz8QED0OvuHjPMPg34J/Mduf904qzicW2+BVxt23fvCkz7MWP9AZqZNycHsNnOMBkr5TIw+Gj5QQh5w6C2HGP7gBriV34ch9mUtg7pZssKZgbJn5gukusMyxV+5DgXh6hYD7AJ8Msy2Eg5Fp66acyEzo3of4v4fuhOvVqCqr/A8FDQ4yJcoSyvvvDJEKvLdQW89zZrtne3Rj0baWxzGbzTjFvPYyZ+OtMfO8WZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Edo4YSD6AKS3MQf0k+r4USSRl1cHKHtSqXCo8dExYJ4=;
 b=f2lfyvmSwPJBfGzqDdV/0lDpULST+TtD2KXZqQPXyERoHIXWvN5pamJJNBNhoaHseEiGwy2x0EMkEAxPEAP2LFFuHJJdBTAVyxM7g14zD9RrPtcxb/hMa6Duz8Qc+uyK6Id/K14wuGGYfTtcbnd9mFwmXkTPJAp5r9cRBtJCR3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:58 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] net: mscc: ocelot: strengthen type of "u32 reg" and "u32 base" in ocelot_stats.c
Date:   Wed, 12 Apr 2023 15:47:35 +0300
Message-Id: <20230412124737.2243527-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b0e9fa4-cd98-4880-5061-08db3b54249d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGcd8HlKG3sK3iBapxtUFrzYkVDaBK8fZhrr+eLVfl+dOEjDx4cj3mA5SMuGEWMSgmMD2ypoaFYqEvSK6l8UP4P4l43jjuKqEsKNzIP/c7yv0LObKv/Sf/09u9SAcd7We2xmL9V/x4x2pPEmY31zH2yAKfREn8xivGD+pSJ8CdoA6DRbtSntw1YSCkGSrQ+W+9GcSJUhRVrlEb/5HqY5IRoAMXWCBEwaEpufDpe0RGeIBR+DipaPdVyXDuRe1jm8jutXkJfL+QwOszLCgHNbbJtas1IVYllpECd9vgb71Bxl31AJ8ZxFbecKwKSZsk+GqcKfFSSIIovR/7+ee7iyWamgBak2Jkzs0k6ReFpDPdvmIJMW04uaqODTKqKtXZHERVkI1MV6sW1t/4kWnvgonmD+Uqo3cxwS6UnAttIOtcHBL4I2oSm6DBcub+BnRngbwl0V0O9atgQnx9A66mTe7yTymVZoHxw3N1f9i5qQwRJM3eZmsjq/706fnMqUtClDLOohnG4SMG+nxENBisppHkXshX92uj+NG6zGPCItWbe0x2Ajwy58Ah5MfqeN2z/YJKnJ2YxlVVIHNil8tIEFaUwHKdPZmKKSeT+2yrTnybXtLNtTWxPWF+QJlge2SdEG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8dhO3YkryxswivNc4FA0Y4SYjkuME6L0u8nqFiV4jFgsAxZ+39Hyj5CnrHph?=
 =?us-ascii?Q?gImHouXsZrKkMAWQx9Wvn0eWxlYVrQ3gpC/0eRtdIUQC5ucy0Ko71AynVffQ?=
 =?us-ascii?Q?G88L88vAaJpCVQnqdSbbxAQMGEtiXB+dJ//DHKaej7OFkiZ7oK+LffFHv399?=
 =?us-ascii?Q?zScNhMLLlO3Aul8+SZJvCmmJJbjMcqM/g49SXejrBeYe1/sxtc/zj6Ap+ZPZ?=
 =?us-ascii?Q?SSpm/G3EQPgIUAu4QttqnzBM0rnIsVAEWY6slvt6qDls+jxnX0u0utUh8mPq?=
 =?us-ascii?Q?UceYIQzG2yePGjmrdECibiBchQ7lYV6L0qQR+b2vdO95o0nor/sDkMLQ8LW5?=
 =?us-ascii?Q?dwNR/EsOSQtkMg8Cxje7NrRuh62Ne3ii6+fN3nAHldnlezcgVl1NwXfXQ+Te?=
 =?us-ascii?Q?tlgJREKgbovGMoYwDNZA1MotE02aHjwvxP6TIjJe6ZyXiutYfdiRq3PedSGs?=
 =?us-ascii?Q?H6g3mQ5gBnYTwQn1b62372Mkj7oMJ/Uvj9uppjWogvuYA7Whx2ZdvlR98SZr?=
 =?us-ascii?Q?xvijWL1KzSgXs3wAyoXK4b8LuZmsLFA9Kf8irzgD17vg5y7wMRkEBKp8lwzk?=
 =?us-ascii?Q?zPjdHf7tVfeGduTL4PUNSJ7tqHncd8l4JgCVBOoKWGPTR3u1XJeXUTerKXMQ?=
 =?us-ascii?Q?6VNhdhblxgHN2Y13mVD5q/G2THC8/cOJ4ENjLIf4ACiMW3EIIwmwiNQAtBkh?=
 =?us-ascii?Q?BmKdOq3dnazLamjQM85/cQimhOu9Bm48XMbNaelaJg4Mr4hDu/yAa79bxscm?=
 =?us-ascii?Q?EdmUIZzJEhNjmVHnyiteTKG1M5hXz02AAPc+lPNbgSHyM9cc93YyqUVBQcWb?=
 =?us-ascii?Q?XwgKaIQhsfJvBfW0hSIKL9diqPm1aaL36d+dpjzzJMeFLJPNaieeUc06I4Ep?=
 =?us-ascii?Q?Ai+hir7VPOilU9sa5deVhZAwagH6nwioSxDDVG5clRsQf2jeulH6YRyZRN8s?=
 =?us-ascii?Q?OgRHtdMdH4S5KNjaLyjCVT6HtOQ88+5lNLRv+kN1f0o/KsezlUi1GyOqqs5G?=
 =?us-ascii?Q?F2y7JJVlf3I3IeUDum/tE3TvhTxvUWLomELXStjgWraiXS75A02eFm00YMGd?=
 =?us-ascii?Q?iorJ3kfiyyrDlyHgcHkSSoar4u1ocRr4BfcA0/axd7Cmt/aVDZneGWw1d5IF?=
 =?us-ascii?Q?O0Ly+pC6qiLiBzmCIa29gTAdCNK9uvt6rp0Ag9FxImw7pSev28gQVR2LL4Jl?=
 =?us-ascii?Q?Gta/jzhSvKKRUReNXMucwhyouKAV1YKI4eLJtnMKqaoh+8LOne7NgXNpEhTz?=
 =?us-ascii?Q?4vfAvV3+5mOIMu1kVCWvDA26g3bvGh0QQwFODcspGbkVXwyl4GfjH9g3oL76?=
 =?us-ascii?Q?JmGaa+9PbC7PHL8W1/VsYq/ZJSeQznYvUNJhP86oFfrbuqfVLcMhwI6BFMKQ?=
 =?us-ascii?Q?ibntvzQWyxbG0277sKh2l2ZI7RbML2KU37owOu5rFZ7CCuqnHIgLSHjNS+cu?=
 =?us-ascii?Q?2A1c43fNsXbCqgKeuYEFSp2tnjolQe7BVC3lKGUxFjnr8BlNxHYuNt7ulsZB?=
 =?us-ascii?Q?XmPAyoN6iZkfzo8pNR8sf4R2lSDOpC03OYejnCD8afxYXMyuuOXBaQ8sPd5N?=
 =?us-ascii?Q?L1CNWiVCjqU2wRkcFclb/07V66ecdHWmROXlqGo4CiMF9aQY1F95l6ESjF64?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0e9fa4-cd98-4880-5061-08db3b54249d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:58.2457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsT6Mb40c5sQltI1xQ/VkBzIgtH40Ys4XmXmCDhRrbzBs5i6tRTEoZqKMXNGEzOe5OPb/klT0G6dSm2z7YQt/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the specific enum ocelot_reg to make it clear that the region
registers are encoded and not plain addresses.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 99a14a942600..a381e326cb2b 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -145,7 +145,7 @@ enum ocelot_stat {
 };
 
 struct ocelot_stat_layout {
-	u32 reg;
+	enum ocelot_reg reg;
 	char name[ETH_GSTRING_LEN];
 };
 
@@ -257,7 +257,7 @@ struct ocelot_stat_layout {
 
 struct ocelot_stats_region {
 	struct list_head node;
-	u32 base;
+	enum ocelot_reg base;
 	enum ocelot_stat first_stat;
 	int count;
 	u32 *buf;
@@ -889,7 +889,7 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 {
 	struct ocelot_stats_region *region = NULL;
 	const struct ocelot_stat_layout *layout;
-	unsigned int last = 0;
+	enum ocelot_reg last = 0;
 	int i;
 
 	INIT_LIST_HEAD(&ocelot->stats_regions);
-- 
2.34.1

