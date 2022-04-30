Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B60516101
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350072AbiD3X1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 19:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiD3X1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 19:27:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9E75A5AB;
        Sat, 30 Apr 2022 16:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIf5tU1QMKsYF6+l+53dkBG8Z5pQ9ZpyumVUDggr7UcA4rQPl7BLAg9OBYZ3WbBwZRJZ2x2rF+ikM2CuUlFSi2ecg84EKXQwOlamOozfLddnmCD0EQcZbh8uuqjWVfmqoxBCu4vqffX9QfckHpMYbS1EzPrql0Nmm+P3QsUQB9P11/Kz9mgb2rVcuJafEhn8Re75wtZFK0MVvArIxTIZJWYJVYQROH4G8MGpkRr3qcEgfqLRISdfCK5uj1T63bnmc8ZUZNSDBfSsh5zWvCIbn76MuDV0yS4X6+jWREyRP37PUS2Fwi5q0AaW3PspL9ftxTcCdB+/VqSxVqkDVMKh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNE20eo539DYAwdI+jGz8HOacVv8mcmkq+YxnzzvE/g=;
 b=J5jzvnOG94jHYgrqKJu+Y4VUnlFap/l1GRlgmNvYIGCEGptHB2WkeXbTYfGny72D3C28vzZvsjp91HKoQBVhk6vbu7A30ECgxgkHTqf4tyjYla6qIwZ/sMbUyofYxraEeIzvj2Z8bPZB/huDpu3gwSMb45jsk6r2wUOVX27p6VvJwTpBhQA66SKlhBQb2E9Z4IN8/c49Tos2VH0Lkep1qEeRyvDImVahfWmVlDbn3ER8AKZK1zxSunjiw+cSrl3l7odj+74iMe0co24xDFbkhIBF0j9kesGD0oPOcg0B8/TYho7wRzw8hpUDZdz8e6JDKNcxfTgYTjx3356MYthLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNE20eo539DYAwdI+jGz8HOacVv8mcmkq+YxnzzvE/g=;
 b=UvP9AF72H1ml83RGNYtsT9wHYcGEoLoVFb9KcRL8ZNCaZtBFxGsfaitIQekGwRtiQLoRXvPf4/v4gnKIwMoyy5aBp/pLoe/PkeTzr7BxF2xU0Tiw3IzwjJ0hcnsMKBEfRlYbzeA3UjomLkYwQx2EQB1jO9hixkuB57ZdljX1mAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4802.namprd10.prod.outlook.com
 (2603:10b6:303:94::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 30 Apr
 2022 23:23:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 23:23:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 2/2] net: mscc: ocelot: add missed parentheses around macro argument
Date:   Sat, 30 Apr 2022 16:23:27 -0700
Message-Id: <20220430232327.4091825-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220430232327.4091825-1-colin.foster@in-advantage.com>
References: <20220430232327.4091825-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0199.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ace24e92-be1c-42f0-16c5-08da2b007790
X-MS-TrafficTypeDiagnostic: CO1PR10MB4802:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4802CF6330D311E0CD547F3DA4FF9@CO1PR10MB4802.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngUJpYFAqf2vj96+p9zShV5upzWGFBtdyvSq5xxIBWR76sF/hYG3KHLf4BBwjY4nK+2/Neqg+/jvNpoixrlsDDQLTTGv1pfSmKeguVA5vgrXTWpqjV/pHL7s/lheAmGbhhv/4Ae6iRDuxkRM0qotZfuuWLx8GBwXOo4xbs3991BHSaqzRuhQ0QafnpOC6hcmxZdAZUe9rguq7Hf2a3lK8T98zfl0lFrEylDuSWnE4CJ4qoYygZRDvvJPYGSUnbcFuX1oJdIS+Qx8dMC0JUBaksu0fcSCOUe6bD8/baOcPLW6pRI1+iz9CbrawHOiH1RY+lbYMYsBRTL3dEt/tb1Dr+K5EskFx0hs/gz42TjGHcpUn99KplGObDA8b6mCPk/lvLjKzZuogX6o3BGvEhA8GTaBjmS7pytcaYGIOZ/RbLa2qGhtKhaLFEjiU0jxTAeq9Pk16I/bGUXk43CTVENE1IWNLxqWRjm4724DXiUil9Gf48tBiyZJ84mERztOO/d39UKSrIRIegch9m55ugAIY3+eNtOj7HWKgu3bkVPT0pB0pd6OiJClqc8LZ6QZUWOIezs/0DVnir2N9MZeYXwuI7ojKGtMZnPgYClprhDm4FqeHkvb7JX9AW6PV6wjkZF+XO6BrHSKw0hA5N1X9b+yAw9bH7C599Qf9D/IG1/Ww1zKl8IanECSjFQTLYV3ERJeiLkB3D/toP55eEA9qDNOLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(366004)(39830400003)(136003)(396003)(346002)(52116002)(6506007)(186003)(6512007)(6666004)(26005)(1076003)(2616005)(2906002)(83380400001)(5660300002)(44832011)(4744005)(8936002)(54906003)(508600001)(6486002)(66946007)(316002)(66476007)(66556008)(8676002)(4326008)(38100700002)(38350700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b6G99KI1Y0JCSAxS5tvowpwZOrrKI0fUt+WtsE04znjGBadCaqKVmzKOXSq+?=
 =?us-ascii?Q?xPaJ54j12OEqJhKQ40mHJwNyc4P0ZvkatJlZiiOAzjAw1GJrRQPclC65SJRn?=
 =?us-ascii?Q?joFQ+xSzYTQHQBtnarsXUOAwGCClTsRm3LjFrmK14yCVthWcYjHFDKzSYVoF?=
 =?us-ascii?Q?lmblHikW/7SEjg7r8UwlriC+xg6z0nF2d7UDrYJCofmukUP/1dfr5D3nTR7h?=
 =?us-ascii?Q?2A1n8xnd2EUdv6lL9H1mjvw4tl/DuKy1g0YLNoDV08QV9vM842A42PxvN5KC?=
 =?us-ascii?Q?EpCLcfVLqEBWoQuOnOqEybZzsabhFzU0MnC0lVV8A3iowmSH6RzdtzDkWofp?=
 =?us-ascii?Q?e3GBFUleb19Vz7cMEFhIcWzUUpfDVZKSozHsJbupUkmj+SWJu0kR1/SpNjvW?=
 =?us-ascii?Q?TSErUNO4D1KHoZbVNu75sXWm7XE+cJQzdLD/Xz+sNZ70zV6Y4GXSqj/YUItt?=
 =?us-ascii?Q?OACJg4vLMy9moQwsFXPGnjktZDS/HkmlNskFb0IZ7FLIcUm9W8ez2nNekTLP?=
 =?us-ascii?Q?gpMctW2YGOC7yVltvmN5b3ovGQGhNnCfAuAsdYM1VwVYk522GyEE99zVOhNw?=
 =?us-ascii?Q?hNwx1KV0C8MZs5SCFcpqAy1rTvtuS6hu4eU4BgoClAqALXr5Qmxa/irhYefE?=
 =?us-ascii?Q?mlzSuCPU80Y2DJ154xqorhQwwMobGFHZvwdSX/R6tG5LaC5gt/YRtFRrrwgF?=
 =?us-ascii?Q?Fx3RVncYvDCKF2koPeejBASmtMSK8mJjuhFHjzeQ2Q12y3LRKSDgJ80SZqXZ?=
 =?us-ascii?Q?aFdZvlxIMxJpH33PYwE1EzKll5ttrwZ0tIzXOfPLhOABY8peY2K9XHofKWmS?=
 =?us-ascii?Q?bGmDKzZBMNizuVdanGiAnDG2LXLavs001wL8gTmDyhfT9S62kRCYWrQpZyLk?=
 =?us-ascii?Q?/Y2mQgdtkcqKwIJJoqlTqLQxu3NfsaON6xwUeECeMg9NMuauIdFYowpKhuNY?=
 =?us-ascii?Q?pUdREEECv3e3ybzuNdFbvNkcP52UH/Me7qHoKAfFr58vmeok+BhGWctv20Kw?=
 =?us-ascii?Q?ZXIvxdXSMgCg3/BAAkW7sZChSW1H5Y0y3qkSM2yc4E8IaW4JUroYRDYkqUCi?=
 =?us-ascii?Q?rgO+nIG1A3QOZgtdqhkB6kbCNP9W1HL6zaN0zJWjyEZB0P5ZVA2dD/OgyVhm?=
 =?us-ascii?Q?RFmxKzkicItNERz2gspg4brNRPR1Zj7hgtmeAtCLGnD0H3RJmgR7rBRtfqeS?=
 =?us-ascii?Q?6YqGfq13Fch2/xnOkJKydFxJbUKVVCDrVWng9SUEDR0u0/axVBtfeBszc5au?=
 =?us-ascii?Q?QpIl4/nQUAWHdqVqSA0sOYoMLaubLlPwQVnA1ePoiqA4gn1gPmWj95BbcOX6?=
 =?us-ascii?Q?DEJa/5DNB8vi4dTcupZ+PwhjdaZ1Z5qD9KRIcmXX5QsQqTxpqgXFKirlPUZ/?=
 =?us-ascii?Q?5aYsijo7Af1/zl3qZo1crknNzGMF51MO9kahTChdgXhlPRNJl6ZQiWtJ9GAt?=
 =?us-ascii?Q?dvyOnl0qkrEJhdk39BXDzlTDEbo81CjRPSYFREsFgT5SQza5jACR11fvPq2H?=
 =?us-ascii?Q?xeI2DoNF03w3IrGU3YGd9NvgC3IhXrX/mmZ+GoPkxm/4kTN+XpxjWyAIHN50?=
 =?us-ascii?Q?LuLkV6Qcsrt1fEH/wWOy6cZQOAZKLAdfQd55HkAsXONwWgrwVsmbYJt6vNdv?=
 =?us-ascii?Q?NbqrW/vo8oJXSE8uLz4Vb+4lJVdsVGhsJZ/mXAydvaDHs2otaidu6bpuiHas?=
 =?us-ascii?Q?Kw+SiJXerbDF+qnzZYi57bY/7ePvvcMC9VxyIQlb18wh6Pqk44mKzWHcz8DD?=
 =?us-ascii?Q?RXjT2nrmnpkPr0rVOWUcucZ0t2Z2RCg2vRtqb67QIpZKHb9jfm+q?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace24e92-be1c-42f0-16c5-08da2b007790
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 23:23:43.4459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFEsW/Ulj6vMkzWf9tKDHwPTMKXz1S5VS3cx9HAYIm2OT3qCaIoH9pjeMfC94U1tZ9g6gkKJmoGDJnmxnsyN/2jUt9tfp/FddxOvucQaqsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2f187bfa6f35 ("net: ethernet: ocelot: remove the need for num_stats
initializer") added a macro that patchwork warned it lacked parentheses
around an argument. Correct this mistake.

Fixes: 2f187bfa6f35 ("net: ethernet: ocelot: remove the need for num_stats initializer")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/ocelot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 75739766244b..8d8d46778f7e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -106,7 +106,7 @@
 #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
 
 #define for_each_stat(ocelot, stat)				\
-	for ((stat) = ocelot->stats_layout;			\
+	for ((stat) = (ocelot)->stats_layout;			\
 	     ((stat)->name[0] != '\0');				\
 	     (stat)++)
 
-- 
2.25.1

