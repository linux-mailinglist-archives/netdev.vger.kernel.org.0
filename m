Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9994067EE4E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjA0TiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjA0Thl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:37:41 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F386621;
        Fri, 27 Jan 2023 11:36:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbKRq5SQhYeW3uD5SzgCpZgSSzPT+hCV5pJWUpyfzGr27gLBELFFy9X4kF1qzLU4YVi7Qvun6YfsXCydngnMSIFYSZXBTFcku4JemaHLYNQIgD1OW/1a6SDA6l6w+m9Rg8Rv/dtHRL8vXLNilVorr8Ziw1J+5O+n+jKRoSZBwG2Th/QQkMp0Ae2zwyio4/Va9bASfCqtcYcl0IQNU0ESMb30O0j6YYADpFLdrwGgQPwmnHjICgrn1VsMZfxvZBtaLHum+v88UDnpdI9MPyfDuQHActIbKWe+QCj3YCNLpVUw1oF8QrUhXIMqFhJhJSGA38wl7DARSvJTC41QXpBTTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9R2qCwkAvCkHMATQRZ0qgLrZkyYVSVzoDygrgX9ZDWw=;
 b=RCETiVwYWTUWS4ohRJ1IDmzopzfbkNJQSxzzxDdIvFS2ZejMwCP/FkAWCbDzrnGkic7eLxgaOej6iR9H7l/ZWsoXwWX2LRsq5JGVALVaSoxFhpgY3j1BlOYLrY/OLX8p4nLibKjhX6C0CauOHaisQ0645/7jxQZK1rbF1+XoipSFU9VsDXc5v9BJptIci6uzBzWGi9i2fF3DXcrrPh1h052C40ysRALyuqFdzSAHirs8ne87tZ7FZ34NavgpIdLWiLz3dxPAohzyvUQNL3T+gO1XHse0IPS/DDEbO/UgdU0uWO+H4L3Z2lUg3VqAEXgfafD+pH2SEckaLFWJuDR4Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9R2qCwkAvCkHMATQRZ0qgLrZkyYVSVzoDygrgX9ZDWw=;
 b=PqqkiHoqd7TaWXPXk9+D2hL9GHjx9NpmFlV2v2kIVuQLoQuP6xtRyAsS1B3cI6D17SU+XzEjCVy79m2aLkTkv92FKwFBfddR6xhLA3uo3cuP5FXyRi6VQ0ZAu+GQRw4a7i4/9qR3MDwKxRrGg5U8h+bPdu21jCZNxVWcHNCg7YI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:26 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:26 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 09/13] mfd: ocelot: prepend resource size macros to be 32-bit
Date:   Fri, 27 Jan 2023 11:35:55 -0800
Message-Id: <20230127193559.1001051-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cf63c3b-812e-4936-1b54-08db009dc7cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UxHNWR4oxz+FPmplmWN710D1Z9waVf3p+hZakcq1fCNDoLkLogdzSITKrRYthMiMLSX8wUnA+Lx6Wyj5TI9YJwTWsMkjNMixvRhGroqxGXAo+8e2SdytODHUvRh6H68jJm2yw9wCtA/6YtzpyH3VDVL4bO08UxwD4jIFdcpQHW0HafO4a6rhKG0lDBoV359YgDC1Jwi4+8jA7rkQBj58YKSuEzfu06jdX6YrlfcEiZW5LoO0djhPlA+KDCElWz1p5TGo0Ot9HC0+1V50z7q6dbRtsQwKbvP7BpWOggRZ0wH90bOKPqNVY/1KtZF8plnVU/nznDBaf03OdnGNxp/2QVCHQNEc0PhGgdzCsXH2C94TpKT7PbPF7EqJdPeYkcBZIMeWDyKbdgAUUzRJWWFDLTzpyk1JuOshfBMbnB7MQYUIcQ0THLjJLsoC+yJYMoyiE2rJkI10gMm6ZQJYvJa9FFhVKlgXziRXYN1dR1TEFPigFczKMYupt4iOJXoZePjZ81XjKjxsVIetCaAwhWoW531U6/XPckg7P8gBrPaxbfBHPadRAsYtXfyhnwsnQrBE/M/zOkGwy2Fc1iE0RloGwnqC27dhBeOzZHQl3JDSMMTA/AGQKoo0NsZ0rtP6gTWHjbBBsgW/7XOixDsmQa+O6NT2wVZvQuWeMzlKC5+eih3RvilRoZ67uiLg/XAFq9iNuZSOeqJ/cIiyzYCkkUgeog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wxA/LVZUV7gX/sRmzJmBLFYFV4dpwR4sGtEtpaHNLFHAvHCQlehqBEwaEi98?=
 =?us-ascii?Q?23jA5r+g2/7q/47qNGN3FDg9GGzfNtjlSgxdE7q4rlT7wejCitlp4yL0Y764?=
 =?us-ascii?Q?sBFJbvL0BXvSLYXgnlJp3V/ODeriugsEXBcUjH1b9cVdai0bl5xAAN++t3Wv?=
 =?us-ascii?Q?G4UsDwtkQGCaJcQUmtXLohAKN57G4DZB8zOsI5zxYeKutPLW0xAExJjEVY1b?=
 =?us-ascii?Q?cPFg2mgclNALaqsg6sGkSqSGdlbmq71qUTeXBTlYQzh7JOVIcO2NWxCNFLu0?=
 =?us-ascii?Q?5u4lFrbVOo9SMTlIftJ5ce2zABNgUZj6kOj1QbLhDPyP5y0CsttG2yHRRk8c?=
 =?us-ascii?Q?mTMTauRICMOV/3PlkXqIQ6/ewnIAww5MFpy5+mBheJ76vh9dPIX8SfgbssKe?=
 =?us-ascii?Q?tlG5l3mAd86XGFknWkuH4kK+nJ8pLO0AyIMBm0uNB6yiaQ+j6GcHgjGOrP/H?=
 =?us-ascii?Q?svQeRhoaz8Ps+vncRovhAOpgNuhfhJ+V3TCp6K0JjbaIZSM/CtvJY1kNLlvW?=
 =?us-ascii?Q?4YDTuIjfzuUNOakCqwLFt/G8HoJesVhEjAs1cJYSF4FCmqQrBXii5b3e5MtS?=
 =?us-ascii?Q?8O0lBylnuA384vFA9+H2C+Zru4a326CBXtELILxhjfe2U4h1YRmx+C+dBA3x?=
 =?us-ascii?Q?91zF5KnaiYFjJI0tXdjmUiOKQaG67Yz+owHmGqumvu/bO2Y2EQqpBOn1OY8i?=
 =?us-ascii?Q?pfJXdxHXNmqbYVrY5vKiofEU3vvHC4bjzFV/oCFUlJC4j4UruWzsKiBAxL8S?=
 =?us-ascii?Q?ibZYTPatRXRrb4KNYhORyYx2XPTzPws2IcpfrhejhhRAFu0GGlC1CLpS9rrb?=
 =?us-ascii?Q?KKlBtvgs5mM8zTwIbaHeDLR7Dy251Wc5dhQ/jRSWZF1AQlnZ+0I/mEOFw7UP?=
 =?us-ascii?Q?UADZfWQ8+6m/aqAyt/f2Cxh4xjQPhHuCoVuhhx/zetNrh4PDMb1dtYFZgdeQ?=
 =?us-ascii?Q?gHs6VA4OQOKoaq3jDY/Z1WiLvDBLYIe38YWkrJlUeEDWVreB1nC+7bPwz6Om?=
 =?us-ascii?Q?qbW5mVUYL+JeXJHDPPuDBles6L2Nxxiwv5qzpAvmuux+15hB6SkZVELyKnTz?=
 =?us-ascii?Q?irjgi6pKVV49ZpdoTkaGtt2uqsJbY7M7eISNtQ/s49lydsWHKlFs8+RygtqJ?=
 =?us-ascii?Q?yt/T7uUZUnIphVzR4fFPllgB7wWExWgH64NDpu66fV4RM7mFDjVffdO5AYqZ?=
 =?us-ascii?Q?rQC5n4+xW5ZzVUjL5T5j724xvqpWyRzko1GhRUieR0mRSwq2h5YG6NsO3awA?=
 =?us-ascii?Q?KU8of0vhihWaLH0ltuG5rQ679g57GWW4Wa8+qwR5SXQrY0wmqA9ouw0flRD7?=
 =?us-ascii?Q?yKboVSBTkZ2LSVsrbrCx7dXmhJhMtLjMc5HQksE7mGQLMf1KEvhbn2EsL8J8?=
 =?us-ascii?Q?UO4dZuDsHQ70NakAFSFM1ia2Xv0OptcNukxmr7f6BmHJqVypCBjaER8c1D5/?=
 =?us-ascii?Q?YcA0mIfhdvCTdwWHKFUTsnRyu+50/D7HLxGzEc7Q4AagLbHZ0jwO9pS7ASaW?=
 =?us-ascii?Q?kVDF2hOnq9DQWPwgRbutm1QPbiV0kQecsfnUyAkyW8PeOxnc7Ip1ULqfFXY8?=
 =?us-ascii?Q?M49J9kQORALnJ/XWGMCwMpyoG3lYC7Zgms8xsDULKbXUbqr3K11cBApCNbuz?=
 =?us-ascii?Q?l5ZvPrOyaYvRqCebsIq+sSA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf63c3b-812e-4936-1b54-08db009dc7cf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:26.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TX7Zo/hnhxp2QXPGYhPzLlWqJ7Qh0GwAQBSK9iwyuuNPR9K0MxKJyfg52/j/jMb9ByUolhK7fJ0xzpjdoFwUUv6po2uBi7+HH7/4H5sr9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The *_RES_SIZE macros are initally <= 0x100. Future resource sizes will be
upwards of 0x200000 in size.

To keep things clean, fully align the RES_SIZE macros to 32-bit to do
nothing more than make the code more consistent.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Acked-for-MFD-by: Lee Jones <lee@kernel.org>
---

v5
    * Add Lee's Acked-for-MFD tag

v3-v4
    * No change

v2
    * New patch - broken out from a different one

---
 drivers/mfd/ocelot-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 1816d52c65c5..013e83173062 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -34,16 +34,16 @@
 
 #define VSC7512_MIIM0_RES_START		0x7107009c
 #define VSC7512_MIIM1_RES_START		0x710700c0
-#define VSC7512_MIIM_RES_SIZE		0x024
+#define VSC7512_MIIM_RES_SIZE		0x00000024
 
 #define VSC7512_PHY_RES_START		0x710700f0
-#define VSC7512_PHY_RES_SIZE		0x004
+#define VSC7512_PHY_RES_SIZE		0x00000004
 
 #define VSC7512_GPIO_RES_START		0x71070034
-#define VSC7512_GPIO_RES_SIZE		0x06c
+#define VSC7512_GPIO_RES_SIZE		0x0000006c
 
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
-#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+#define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
-- 
2.25.1

