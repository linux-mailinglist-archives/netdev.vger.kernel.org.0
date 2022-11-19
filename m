Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3746311E8
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiKSXOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiKSXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:14:40 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D8F13F64;
        Sat, 19 Nov 2022 15:14:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEWzC1hlotSY1fSGESn6Ba+21/GedYxWcDrfEqYACfPBWixwqa4G0WWSK6dO8te/PSWj9AQ+c5g9IKrava0g9k/qcuaJ8oWKwQ8zg7G0+c4dfJymtpDx5wDLQ2Yfnyw2ebUizcLua8oHfelIPD841lcrGjxwV5kkO3n+O8f4OkRReJ/wJXl49Dh40NUoTlzJKKmSI4BkZbF5EOz8UvyeqnDBTK742wpulLOTI9rHjS+ZJuQS9V5MfeGzAc9ciGFRfrShSRYvC1DBncAFsuUEZk0fuRBE1teYnuoXPpkwMDF54AW1ta4FFJUcbikhuFGPSkJPL6SsrjpjsVhHQcyfLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oU84Rbt19vAc/NrOPCabhl5B1B9LG6TK1vJ2rFw/GfA=;
 b=Zqy5B42zIxs0WHh8STVbeX6x9FPJy+jO2yesfThFjYnMXYUFkYqBnKOHmvzdGuXmvlYpBP8ZjKSk6+/qTe3m/3F4LpETq7tK1euzvthJ+p83+wyRpVw45LuNNxf52GOkaSy3FbbNBAjJDom0cg9ZhUQmHV/OUMq3CsEs94Y+iXr5uGOxbR5lp9v5LZvlv9KF+j3xnfHPlXi8SVmWexzPqeuNXIXWphYuGzR9mbgE1/LSb8e6Py+9Hnt36lfzypxxXU4Rnr8/vgPVA0Vo+1GGK6iHOEAN6nASC1g8iRXPI6fY/FJEytI/Hd5sdDqAL9aBpx0JaNVHHmh6lmtKfDc08g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU84Rbt19vAc/NrOPCabhl5B1B9LG6TK1vJ2rFw/GfA=;
 b=jAVmZoQgV+YhAbCkpEJPIQU9yVRucqSbEcKArjUYz/nRMO6LFj+ksuGrxdUhrIT+9A43udtjPRc2FhD58XmE0UoK1xqAdy1HNedvPqeNFUlTLxccGgSsrPrad+g+f29RricPWnlkLw4NaUEPqqvclMHrp4c3KS1mgd1i1ZEXPkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4293.namprd10.prod.outlook.com
 (2603:10b6:610:7f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Sat, 19 Nov
 2022 23:14:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 23:14:25 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 3/3] net: mscc: ocelot: issue a warning if stats are incorrectly ordered
Date:   Sat, 19 Nov 2022 15:14:06 -0800
Message-Id: <20221119231406.3167852-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221119231406.3167852-1-colin.foster@in-advantage.com>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH2PR10MB4293:EE_
X-MS-Office365-Filtering-Correlation-Id: 46ff3f0f-2b85-44a2-8cc1-08daca83ccf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SifbMxJUBkfSE4zg7CVDsJiyybzAaoT/Ezzk2wxVJ6zjMss3BOmchq76sFdnUQl+b9NyWWDhkQTrtxDyISEvBjPoFZGbwRi79BU2Vor++8X3EsYEDs9Fv8o+CKUWVRQBE8BTwKEKDwKxpjhAti9HvJg8ynn/GkzhAHvOJZD1U6zFGHUF2UHbksE8dBSHSU0uZX2i7eaLg9+5EtcjMqYsp4FHa5pPDCfKF75QJJjUU6gkwtVm34OT9eyDlP/TthZNt2cfDdgx3Gcdhsvx2hdDJUcsQY1Wh5CqQ1+mgLzF2wO/wZvRbxpTjT9WJR6m+EnqyXeWFpzVV8qgeCh6fmTHpY1TchoW7rzIPAOrVI/F7AvAjxcd1xvCGhBw68adyCwUbD++dt93wEY+WQCr/TyyMD27PrCpw6UZt9DnXQHcIyfYBMOTTu7ki42Wmp6LGrHvLROK3gf94Vn7Ft94elZ/y0HJ5AZLgxnj36jE5c0d5/6VVup8lZxxd4G9qtJdha17uFVGjbvoVn1ND68AgWaSTVT/eiPh9dEsgXSRNXqwVG7jFdftR+2vte9dgGIl1d1njFi9LV7D9ucCRHyj9fzxvbnlq97xR5OfczNSs9aFNpdxKBnZ31Xags0BNpAFneMTjX7wvDXGEWEtM/Cn/8EwG4IgG6a8SG+8s6Vmb4TIX9/IHYeQDJHVRI0VJEnjNCTe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39830400003)(346002)(451199015)(2906002)(26005)(86362001)(83380400001)(6512007)(4326008)(8676002)(66476007)(66556008)(66946007)(38350700002)(38100700002)(36756003)(41300700001)(44832011)(54906003)(8936002)(5660300002)(316002)(186003)(7416002)(52116002)(478600001)(1076003)(6666004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NhZIhcUBScE55+0J1kzJPiQW+dxjv4QrxZpCRi7KTxjclYStk7+BYFWiSwmx?=
 =?us-ascii?Q?B2pvRJnj/e09zTmGDHQfQw29T+RYM49Gi413AGenQrGiMR2rfEoblicwGOBX?=
 =?us-ascii?Q?Xk9JBmI4Cl3CGjsA1n69/eQCluGKe5YfUqfCu91rxY5aWzWN37raWGxQeX3i?=
 =?us-ascii?Q?iR6fm4Cy+k/CePTuN5o7JRMncNxpwSC6Bp8sMba+sYElSehXh2gxeqoL5I2+?=
 =?us-ascii?Q?WzenY82fOFl709jy4LdhoKKUBzoBnleR6+cqYqsxlecZZrn1NF3LJbZechjO?=
 =?us-ascii?Q?u4F/j3505ZJ/Jq6xnAcvyygTdk7gtC3fmlkA7Gkq7CfWNw07aY7o1QXM6H1O?=
 =?us-ascii?Q?0wpK/ozN3wU3M9Cq3/dQAK41y7wowhM3hzJJEZ5zHz/UIYyPmUVuf/Eu7/5N?=
 =?us-ascii?Q?+w+mpSNIaQXnqrPiJboJXqU1ayknO0DnoMhwZa6HKOxrHAZuh57se9CqrYjp?=
 =?us-ascii?Q?+7tU5qMwZQPvL1QeIOHzIGtUSN5wn/903iHEimXGdU5MF0c9fz9Miv2tqMEc?=
 =?us-ascii?Q?tJTAe0qy3Lubye8tUzVcCOg3jsbnnZbsAb6YBBV5lXwT/jMCMLDWr+oSWBBh?=
 =?us-ascii?Q?NcoimTkDzX30VZrwMXYIwPz65LtptX2g66XtATOzu5XosXCwe9QG7igi9wvE?=
 =?us-ascii?Q?cn5zfIWxqzbN6H6hWhsAP0b7PLHwd5YxVEHvj5gUOQsV7AdHybQbXVPmaWOc?=
 =?us-ascii?Q?X46KyrzTWX67fC7g7xP0rds/SHGmBX0o4YtjLuS+fciP9/CE7UUHnJJjKhc6?=
 =?us-ascii?Q?Dy5/pyuiUm9Ej2LfHLVfBhAQfKWIXeOaFNLtAB+q45doY4yJ+8lzdzOMNimN?=
 =?us-ascii?Q?cRK9Xkz5zjxbf50ttWEfdbH+mCvmzZ1Jm0JlX/y/d0wqbtjzywiSyPRmIwz4?=
 =?us-ascii?Q?icCXANv2L7kvCt3ZY0LX9jufrDsr7yn7lMEbR6AksvhsNFwLAEX5GZewVHOX?=
 =?us-ascii?Q?unCVNi4eDoXJlnALNCgQqpoqA+Mvh7cl9iNz4JmbyjGfbVlUbcTNE+5CyvVw?=
 =?us-ascii?Q?kJPQJKaRe379JjiinhaFHslbVVgHaLrZiildKE1JTR1OHc9dJ2/zUdyCfF7J?=
 =?us-ascii?Q?0Wa9O9cMPKzFiE5w26l1Dd28aZkRYRRSqVuVddhKhw1XU1QJivreVIU27Z8a?=
 =?us-ascii?Q?YzSiU0tPsI7GlYSObRqpCOFVEdyZCXWjg1KmzNkRv5T4rWEVcrQZNf//D8Ww?=
 =?us-ascii?Q?79lj1MTwpvRaQojp+Ht6RkBReddw20r6pxZiKEUA1Pvsz4Jwt1M2+PrXVTAD?=
 =?us-ascii?Q?xH7tF1Wr2EgS+QTbrMPhtj3f/z4n1GPOr4yARFyFDPG5WLByGvh48jx0UAem?=
 =?us-ascii?Q?TlbiLqTPpodWZBUS1uIDW7DoJMbpcBSKhr11pO3rryjPGj7ZW0JQynt9CW4V?=
 =?us-ascii?Q?cyFFAxihsJVH9GBs+D0KRIZP03qH7PibgkjwH8J1OUeygtDufEHsVVEVHwzt?=
 =?us-ascii?Q?p3EpWFLD/SAV17VApsYyzVZ1fQm1C0hlWQq09PVU4FbwE3iLNLqcbC6fM6Bh?=
 =?us-ascii?Q?GK+ji69bpHcuNGbuQvrAeLoLXGEUc0tpjylF4B0AKjNfrEPTpkbPcvnCLuDg?=
 =?us-ascii?Q?ffzXOpHn+Ehj5JKdl1vyqDV0/1es50BVJvPn9Qo3tV2N/TXSpYsS6ZGxGPOv?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ff3f0f-2b85-44a2-8cc1-08daca83ccf6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 23:14:25.5832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGOfZ7RphEJ/Nf11de9NuL0STvy54DJeHWTCIUMFAPxtIcDxWFL/mXgleDytiwjEeNJ1e4ffmsPIMlgvnK73ZS6PWP6fxy3Hkr3uFZHEM2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4293
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot uses regmap_bulk_read() operations to efficiently read stats
registers. Currently the implementation relies on the stats layout to be
ordered to be most efficient.

Issue a warning if any future implementations happen to break this pattern.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1->v2
    * New patch, picked up from previous mailings

---
 drivers/net/ethernet/mscc/ocelot_stats.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 68e9f450c468..1478c3b21af1 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -602,7 +602,7 @@ EXPORT_SYMBOL(ocelot_port_get_stats64);
 static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 {
 	struct ocelot_stats_region *region = NULL;
-	unsigned int last;
+	unsigned int last = 0;
 	int i;
 
 	INIT_LIST_HEAD(&ocelot->stats_regions);
@@ -619,6 +619,12 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 			if (!region)
 				return -ENOMEM;
 
+			/* enum ocelot_stat must be kept sorted in the same
+			 * order as ocelot_stats_layout[i].reg in order to have
+			 * efficient bulking
+			 */
+			WARN_ON(last >= ocelot_stats_layout[i].reg);
+
 			region->base = ocelot_stats_layout[i].reg;
 			region->count = 1;
 			list_add_tail(&region->node, &ocelot->stats_regions);
-- 
2.25.1

