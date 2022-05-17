Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09872529771
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiEQCk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQCkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:40:24 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2121.outbound.protection.outlook.com [40.107.255.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E74D45517;
        Mon, 16 May 2022 19:40:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSzWlWD5+5i0RETjYQKQctEjqYtL1tTDvrE3gho6iRktJhGP9R6JFJId/HAHWGV25jcRyCW8hGzxYWWHrgZW7NMIDT3kMv6g/AIae2tVxkAx8HFDQ4RtRV81VJ3VNiwIScx8oKXJu+FhR1dfGMGP0z8ce9l2Uss9WolB2/LKxOY+5Mow554pWugvRehzw+XheMekfXrqFjDTeoESclZCeDOosq81Uk9rjtHPMplGdh761GALGitoC9RmUaSwniTUeiLs9PJsoJU0nR55U27/x5Yx0E/5U4/fDm6SQS0K2OIuD/HNYUh8LKas/OWzwn8pzRfRBQD0DwQX/7IUrJltXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qVwKmwNY4bKcAWsYLJ6LnG+JVIF5w0DXdJOL+7QP3E=;
 b=VIR0C+f4n2Gi+viflFDM2nVexA0Ks7F6VguCaZ09cThpiRPD9KjmRQ5J4p1T7JRFLp2oJmkZij223AAsBJMICd5QQchaTvl1oTtVZeY7rxPP/zLYyvnIWQc64xZleATL2L9Pw5/X6BcpSakgaoOdImfQmAQ1yaIf4vGsYByY3JeZDRWkNPCo1Vpx/H1akahIWjN/gti7K7e4HepOR1mbM/eTHRqXgx+9sDMf/aLNb55+hXzHfFhI7xCU+JYL7iG2kWMdhr6Ll2kPieJI11h66/9lQju/hezCLP5qC4lWjqx+F2m1dcogggCuXIOEFrb04edsrraqtL81IFL/rcnSPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qVwKmwNY4bKcAWsYLJ6LnG+JVIF5w0DXdJOL+7QP3E=;
 b=lXKl/xfZQQfSeWz5af6zVbJpH7ObGlZ1YD18VFAMRKiJnVjoxiAeLY29NoS7YXjrybV9/0htqSYf6SkIZu7JKdWVNHV4Yyyw2aOFbfVauj5S5hnyChID80aMoyIK4ROfY/O5HD2b2IUmFbpfgadxN/2Yg8/BWpvHdO6pyagp7+k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by PS2PR06MB2534.apcprd06.prod.outlook.com (2603:1096:300:53::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 02:40:16 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:40:16 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:ATHEROS ATH5K WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH linux-next v2] net: ath5k: replace ternary operator with min()
Date:   Tue, 17 May 2022 10:39:23 +0800
Message-Id: <20220517023923.76989-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <874k1pxvca.fsf@kernel.org>
References: <874k1pxvca.fsf@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0047.apcprd04.prod.outlook.com
 (2603:1096:202:14::15) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bde38e6-06dc-4db5-875c-08da37ae926a
X-MS-TrafficTypeDiagnostic: PS2PR06MB2534:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB2534696711F016EE9079F385C7CE9@PS2PR06MB2534.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aC1+VIHeLHuTA8ikXvfVNYj3WvpDC8CICPR7lcBjMMP3kGzVCNiICsfkX+mJch7UPgj/nkzC8FUBqOXtLlXo7qPSilnwRZ9A0p/qYsDW8tbaoWBTdkQRqijW5D9mp1oJXq+APe6F/fWS5q+2i5frO7+6CHkrwsssO8bWtUBnpSYhValGCQuc4u8ilSqKkQ0gZXziOcLe53rBgoZZmlOT7/kT0ccfVHeBjzUMNCGW6/iq7BVw4rloNHqAuWYpJtZuciDqBwxMHSql8WaKK5Mw4z9kaQFhT7kS78u73b/fpj8dYRxx04vGMsT2tBg4ZtpF/xDvyCHTvtggE7x/aQGD40u64Gs3/5m1JvNPQPz3cE8ZC5w3porWMGKxug7KtVoj0Wdst+K86vYW7TTRTLM2/s41KAmiv2hhPgOET//aUoigr3WaWYDrKGXJcZIc7FPtGCGQjGeZBvkb+FC9+Hj5gggZ9sXiKHtUggGtfJEtvpQCpbv1EB0CPrK12DJgacEzyC2pK3cB3kMzKwXfSLGFvswD2JOAPWFPk3hbF2u6EccVa9920DOZBP9Lbhu6QmQjNR2cm4ww7n4xArSH5UciXRZ1ma5vSvLP42XslxMrLU+p0scGZbDl/ArquvtZanllZ7FswpiQbTXzcfcD+x60v9PrIyLsq76NJ9p4tPqMG4cqD8u2EJUCRmV+W0Pu267XyCedA1Y01VgiCWUPv+KDBOzvmNGHYZOH1J5NZn6chmleSjj8lbAr15+M71YV7jCj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(86362001)(5660300002)(52116002)(6666004)(36756003)(83380400001)(4326008)(7416002)(66476007)(66556008)(8676002)(66946007)(6506007)(4744005)(186003)(6512007)(26005)(38100700002)(38350700002)(921005)(6486002)(316002)(107886003)(508600001)(2616005)(110136005)(1076003)(8936002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2dTNPb/iAAzYh9FkPtVkCP2uJv02MrLMHTw2XHbnt1epG5h6c5PkVnJ1jj/l?=
 =?us-ascii?Q?ZKT2tqf5uMJDikluy+Ugn9PRlbz8KItyRwtBJbcslRVibynHPiL/hvV+wIL/?=
 =?us-ascii?Q?dbdUcEs/SSSow60H2X2WMB8DkHrSYnRQ3xIkRCf6odGxSIGtIEJqjSDEUJlr?=
 =?us-ascii?Q?UugZb/20jv2bbUMiOJec9tt8YvvWllAuXftvE0pKM7l7pGhWhfe7VzpTrzO/?=
 =?us-ascii?Q?kAdsxJD1Ykd7gomnFTCpKtexUp39dT9L/88m7Ij72+XdT1EnIUFQeDZUxmYz?=
 =?us-ascii?Q?SycAbjtANHDaPiMGOFY7RW8DlxRlrqeiWncaSJd8iCGfpp7mxZqrW7MUlsXw?=
 =?us-ascii?Q?oC5vJTzOgqGifwGgyYs7T70dNq5D3bmSmtdJi62x48rdVnZ0Ovqvztv4c89i?=
 =?us-ascii?Q?FoHzpRM5zJOJfdZM5xrUkKLrbw/xkZguf5Iz3RcB3mJTLT+1JQTmoGr+Q8sW?=
 =?us-ascii?Q?VtAFLmUF0f76IQ0ewDAFA/XAppFhhK2egbk8U11/iBAjZvRmj8QcPdlt2aBg?=
 =?us-ascii?Q?5XwJhEdj+6BV43j1jvQaNkR3FCfUGa4kRNF7zoaRki2yv9Yggt864dvgdx+4?=
 =?us-ascii?Q?Ad5zPGOQ/xgJAZffF2HoETUDqqmWHFX1xUJvreiTDW3TjoyiQJujPD3TatU1?=
 =?us-ascii?Q?56rBCNt02KzyUIXyryNkiObvDdtjRETuolOlHaW2kRggxkpqV4lgrbchvT6U?=
 =?us-ascii?Q?HYdWiOC/KvOPhIyxay3ki4a5+VVKLAy86VjAOXo5NFL78rJqTs4cSr9LkA5R?=
 =?us-ascii?Q?kmZjkrvH7EwA1iHhv0hQ6+3uteoxLhDDW2yWQARNsk8p60tnt81ttd4yDq3a?=
 =?us-ascii?Q?vFMlvWrl587n2T3U36LQSmQHxp65llmhbr9DxgnX2522gFeDk8DF/ekSSsfO?=
 =?us-ascii?Q?lg6iSMVnINE6xxt0T6jItIMVaD2CvauTTLOiC+90cVLMMtL8ao1i0JhpJchz?=
 =?us-ascii?Q?vYbkerPBYtGjQRH8+oOuiRZ6rNnFGqnphMJdNZnbrytyoAWLuZBHd17RfdMF?=
 =?us-ascii?Q?3JC7QF6tz4ATfyYWNsMZ5S70ufpcY+zW3b9tVJNFUe2B7JhUyAZ81BB/M/RD?=
 =?us-ascii?Q?7AVdVjOI7WX5g4m+Cmq7DB2I/oDMiid/oPZIrqitqvU6l3FQGpt5OQeo8IkJ?=
 =?us-ascii?Q?l7af52IM7Mh/AsHiSoUEW+grQX8WX0pmnOmdCOiWiZx8tyA056FsGGfcwEQt?=
 =?us-ascii?Q?aIXmVmHTsNwhYsS1FN5eKylpK2QXyscS/ORenPnFO4Yi1IAj5X4xJnVnSZMz?=
 =?us-ascii?Q?iqIB54Gp/yLvAYUHFak7q/6Oxd2RIPojMmLKbX43CR5KW70bj+o3HVWj15M7?=
 =?us-ascii?Q?w/TucSmWbBWKv0mTup+XdOZdPdH0XspPauj8fySs2Uz6Fuil+lMRUOh7l1lB?=
 =?us-ascii?Q?qlrNGqGndq3vcFJzuqLsrsZF7MQ7lJAxdRTSWYHnPA8G+GNtk9fDyr3pZabp?=
 =?us-ascii?Q?UBKv/yWSPpQo20o8FkobYVDPbaFldIm9HxM48EgqwHbPebcSKYgUKYrgl47d?=
 =?us-ascii?Q?1nTJek4lrOaKs7k2nVCkSsLniIF5ZBy7FFl4QsqsAYhyukzC1PqBntgz2Rxx?=
 =?us-ascii?Q?xeGqEKX4hLaFZWHZ7R6Ts0OqcofLK0yHgh6CF9lDvWM4X2Rnq25zsuLl6XL4?=
 =?us-ascii?Q?Bj+ZONkZFySzKoNKI9fznVakgviqaDbmlzvIsMHJ8ws/iteiWF1wF5zQ7bwr?=
 =?us-ascii?Q?0TrqwOPB3vckwiJXc1cCFa5MHQO9YvbLa52Twt9xdDDJLxC+mfwfo8dAEkpI?=
 =?us-ascii?Q?kHzshu2VgA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bde38e6-06dc-4db5-875c-08da37ae926a
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:40:15.9450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFiod0LI9SITK4WrR0Trz8VDoONwXXzLEU7vYVQJlCfDJ4yMpV8R3tDjIWzYFYSp45gNMnmszC6MPMmNz3SiiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2534
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/ath/ath5k/phy.c:3139:62-63: WARNING
opportunity for min()

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/wireless/ath/ath5k/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 00f9e347d414..5797ef9c73d7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3136,7 +3136,7 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw *ah,
 		pdadc_n = gain_boundaries[pdg] + pd_gain_overlap - pwr_min[pdg];
 		/* Limit it to be inside pwr range */
 		table_size = pwr_max[pdg] - pwr_min[pdg];
-		max_idx = (pdadc_n < table_size) ? pdadc_n : table_size;
+		max_idx = min(pdadc_n, table_size);
 
 		/* Fill pdadc_out table */
 		while (pdadc_0 < max_idx && pdadc_i < 128)
-- 
2.20.1

