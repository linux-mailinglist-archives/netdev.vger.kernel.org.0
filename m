Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA34EB1B8
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239588AbiC2QWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239575AbiC2QWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:22:20 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2110.outbound.protection.outlook.com [40.107.117.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3681BBF63;
        Tue, 29 Mar 2022 09:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fue/ito4ymRUFFrLRL3GXT7xZq8ovDZqzZmx1HBEzin/7uCvfBm27BGRAjbkJxaOzRJHskcDgwskFWOA+nSMi8Jnf1upDTRMT332tG1v3oLetgsBECekPecQldMF64IGmV2wA5W79RF7C2Q9KGgarM741YT03nbIDpxoZd40581AP718A4JpK7td3v0gYmrOgxSu+YHNx4RQmZ8xunqXusuJnm4DUcFf8Dx6fYb1yw2PrsTilp/a4zm633zBLFS3MkiuraM+EQX1iNV377nk4KO10URCrcYXYl8/hgnyZ859V6DX/zzQ3qgCtveVS/spWmkQJ9wPeRWs73gQwDzQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdRZRgizcwLn6m54tfhVmIvy4sGnNqKpUf4+iu9qIX4=;
 b=RoiH8OraXztmbU4+8zMCsL5e2RnqKiwLgFJwNvxRe5/UxN8JYC4XfomyIA96f2SU6V5GBSsBbclY02uzIDbpoWdNi2m30Q7sHg2CE8VCfy4lRlLM8GQBvK7puWT9bb4NvgnOx8i6+5pc9dv7avYMTVyi1Fmjt37aI8hOTsFdYCT5LkuqC2CKgYOsd1iUcTUnp6RpHCm1T4+h7Z05lwfQY+IjK1nqspzU+OnHu6SaNxfHF7rNQeDl7B9d3YTsUlmtNcqEPeJsIeMsmEsNiM86pRDMuAsxBqrotdoUzrNksG9WGPkXuQxdQ5S0y9byTTG+17iPNCAvTpTFg/xPXj56lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdRZRgizcwLn6m54tfhVmIvy4sGnNqKpUf4+iu9qIX4=;
 b=pUHB3xzdS1GT5xD2ej+pUhPz3M4LMMeO2z+KuwJcRBY6NMP+qtQWnDRXXFZeMRo7FSFDTs6ZIuVzDL0uFxVgT2GGQFq3j7hrNnlElzXNQpBn4rmp8cl7iueH4cINn2j8iMmbatu8m3JbDuwUv5xzmukQGBq1+lq5HA0lSB0HDKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by SI2PR04MB5295.apcprd04.prod.outlook.com (2603:1096:4:16f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 16:20:32 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::7cfe:c9ba:7793:f42]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::7cfe:c9ba:7793:f42%7]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 16:20:32 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     Patrick Williams <patrick@stwcx.xyz>,
        Potin Lai <potin.lai@quantatw.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] net: mdio: aspeed: Add Clause 45 support
Date:   Wed, 30 Mar 2022 00:19:49 +0800
Message-Id: <20220329161949.19762-1-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:202:16::19) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7c23046-7f26-46e3-fe14-08da11a00bdf
X-MS-TrafficTypeDiagnostic: SI2PR04MB5295:EE_
X-Microsoft-Antispam-PRVS: <SI2PR04MB5295758778E3A7CBFC347D9D8E1E9@SI2PR04MB5295.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MfNo42yyMrBkMmnOXXanRol9JKioZm4P0Cv4O26zyqFLKKgzWt0l1Pp7Fd1bDdYP45+GRpImcd8EYlWdifiAzNPYWLOHa4VpIoJGS6u2PdORNRE3q3ARaVIkTUU/2RVCSFHQaWP5wrH0t7+gSWxBWhDbGFDiVzWWoo+FB937lcMM2cxIZ/bhSPuSeAlojqm89rQDaRW6cSOOImc8YLenZNdYIYyNyhAoeL3P1qKJ81I8SxHPG+9RlDb6j5v5kFGTts7TUX6jAONwiYevyCMyoX1HqH+8jHt1eha5BszbYkgtE362+ydJ61IyTh1D2zaF4+QdNnYj3fdjkTkPEmhW/H6tIXjuNWqE726t8fsm4B13Izafxx+Chs5QhDMiCHfJvBVl6ZUC4S71kuxW7Yc95p01PWzsIAPsvisWH0VLkqzfWvTjkw5+qpMXQ27nILjTBUAqthIRZaUEA0uLahYtoCUHNAjG5qYvVILi2VgPFLBZRhkmkmaUuidbiu3VVVqxkI6jF4F1QYhz4kFLwSKAxD6c3rJQzogN7GN2xPq8eFmeZZ/ZcACk3A89bPdqWA3TFMSppEvj7ZxDOuoDoNI1jjSS3m4ISynkpNqFmzO9Ca0V0hEHytETXM0GEtmjb5HLfnvdJupy8RT0pmiEW52w00fVVdeWe0g2cZmPsrFAcxGrbZNjuHNppqR8Udd6EVLTlfs0hSWPux2rIYWcXZwJqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(1076003)(26005)(186003)(36756003)(2616005)(38350700002)(38100700002)(8676002)(508600001)(66476007)(4326008)(6512007)(110136005)(52116002)(8936002)(6486002)(44832011)(54906003)(7416002)(66556008)(2906002)(6506007)(86362001)(316002)(5660300002)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBIb4Xky+rBrxFQCMclcZiDS1NFCgkyoLJ8EZRqxI3aKR1Rg4gVARyZTljme?=
 =?us-ascii?Q?noEyKczSGfRrhKTvbxlU9g+gXxgwCFMCqnRVRGKKycvMv2fIdiAN6At9Z/8G?=
 =?us-ascii?Q?iU2PISWatixGpC0xM76/tYUhzu/e4lNgDbXb+YWK71J8KHNP4C6x3YdURUZz?=
 =?us-ascii?Q?XErQ+vqOIttiqtBSJTgMoOkU9cj8bmLCe7RG7914VJr1P6A2KZqEvwJQEGHu?=
 =?us-ascii?Q?AUnJxTPwGOlBvE5IYgHsovKIqerXMTra4Rn4aXHi5R5jBjF8VNuvfL/QIPI2?=
 =?us-ascii?Q?+2GGODO6LKsoMIsGtJyJXC7RMQ/1Pa1OE0a2sBps2cZjxH/hsbzcadsinUhM?=
 =?us-ascii?Q?afx+OgFti78+PnWmog6lH/HZ0gZxzRXGHHTFYj2/kqsAgUvowZWrG7Gb0pWv?=
 =?us-ascii?Q?nxHrLlSo21MrWG2CWdIoQ4IpI6nj3e0EydVKPW6vHKRBczJVSO+iEuLtaGwJ?=
 =?us-ascii?Q?XKveklcaZk8WhzkuNJuu0EXMmhPT3JOeJpfGKL4Nw5Y2hSsjutZT3mOs4LLf?=
 =?us-ascii?Q?W+p0VEs7MdCA72J2Wlqgmz2869moHtL0iNTBF9cPcegsFzZKeCjn9DMtWWA5?=
 =?us-ascii?Q?DhkPMXblonIwO3bM/NlFm6tb2XmjaVuchyxNNoiJ2zCLFRPXzhNtWdNskfiB?=
 =?us-ascii?Q?RrKvqLdsd3J+aJlvvXH5KbRgpSILd1Mf2Q7IRc6dY0A51S7rFb5qmcDARabG?=
 =?us-ascii?Q?vBCK54ZNa2AkGaOFE9ox9XYsATbxw8Bh1hf0JDfocgKnf1O8Bf6sOWWo7Jup?=
 =?us-ascii?Q?T9yMGtc4cV7jMZhwhdzny1CFXS510Sd2pqPWk1lYwqMBxFYdCXSXbG5kBDaI?=
 =?us-ascii?Q?o6UixVOgOLhjykYpPdh0me1OK7v1Xq9BC4WPJgOVBlxlfWIWsnS4M3BUujjo?=
 =?us-ascii?Q?xCzUl61AmwtfKjGInYflyNC8chjY8i251T8+0irkiUR0cDDKkXwC5vNsWoaR?=
 =?us-ascii?Q?iGko6MTH7TIIUsQd+91eNlmRktuz/YkmwRAS+GDJR7zigsPu5fn/9/PahHVv?=
 =?us-ascii?Q?ws4OqEh7mNTunF9ymDckcJZd6f4Roh0uALRcYf0lzgpmfyZNyymPmIVeQ+8P?=
 =?us-ascii?Q?pnQdUk364LU3a/otLhAKdySvwcNqDOVFT7SE0YrUOMuIz9RTdvl1nn/xKjl6?=
 =?us-ascii?Q?Eo5W1ST5HBGmpfvoPR8QY+g2OakHcxHMPQtwTtMq691YpykfjsjDB/00IZ+0?=
 =?us-ascii?Q?DKWfzF06ZBWdtgtkPXVG/ks8eH86vqcQRBJLtmgGAs0zA1OhrgyYHiWwwISi?=
 =?us-ascii?Q?YE2y4CcvjLtMedbYsJ3IXCM+QjHp4bryXm978krDHpt9Su9aznE2euS+FVwk?=
 =?us-ascii?Q?ZyR7QmwnbMZEh3dZNZ+CK9bD8p5XtqXCQ84cz12DUANXAfRPWfuaNqImMMtP?=
 =?us-ascii?Q?C49gjdGXHMnCllLoodV+DH1aobfwoC9+2gyPrPHbsyzN4Qf5Q/SESU+7g8Rl?=
 =?us-ascii?Q?ngPjA2OiPkpuQMweELzmZ/E5MfcY1fPiRmP3Zuk5geb3BD8AjslUtKcyoSx5?=
 =?us-ascii?Q?k9iwLlbHRx/3AJRU6LNiujoIBAkpF4e71PfwDf+4EYuM0UtQnA5JiOjaLZFo?=
 =?us-ascii?Q?/WnPXZbVXOYDqNtkxqXMcM/Dr2IXFbAFwj10tC2Cft7l5N4u/ebBv6WZmiZz?=
 =?us-ascii?Q?u0BMjxpcwTS1tFAat8WhjNVm2DHzaDmxSKrfN7nyxAzjJJnJHnoSgriOwGDg?=
 =?us-ascii?Q?K3PhDP4RaRiwZwptH8DmpSTspjfa+DuZQhJEN0vr0GsP9EdCSPIs+YrpgpnC?=
 =?us-ascii?Q?fPF7qpNwP9PzUBWC6IAiZISLPM5HWv0=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c23046-7f26-46e3-fe14-08da11a00bdf
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 16:20:32.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AWv6XDHEZB998oAIUnfe6lhVTkY+OrGJ6sbO0i7CMTauN112tOnknV5ifLtZBJu6vr/HD2e21zfbkk/b/j70g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR04MB5295
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Clause 45 support for Aspeed mdio driver.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 122 ++++++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 34 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index e2273588c75b..aa2b678b2381 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -21,6 +21,10 @@
 #define   ASPEED_MDIO_CTRL_OP		GENMASK(27, 26)
 #define     MDIO_C22_OP_WRITE		0b01
 #define     MDIO_C22_OP_READ		0b10
+#define     MDIO_C45_OP_ADDR		0b00
+#define     MDIO_C45_OP_WRITE		0b01
+#define     MDIO_C45_OP_PREAD		0b10
+#define     MDIO_C45_OP_READ		0b11
 #define   ASPEED_MDIO_CTRL_PHYAD	GENMASK(25, 21)
 #define   ASPEED_MDIO_CTRL_REGAD	GENMASK(20, 16)
 #define   ASPEED_MDIO_CTRL_MIIWDATA	GENMASK(15, 0)
@@ -39,34 +43,35 @@ struct aspeed_mdio {
 	void __iomem *base;
 };
 
-static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+static int aspeed_mdio_ctrl_reg(struct mii_bus *bus, u8 st, u8 op, u8 phyad,
+				u8 regad, u16 data)
 {
 	struct aspeed_mdio *ctx = bus->priv;
 	u32 ctrl;
-	u32 data;
-	int rc;
-
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
-		regnum);
 
-	/* Just clause 22 for the moment */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
+	dev_dbg(&bus->dev, "%s: st: %u op: %u, phyad: %u, regad: %u, data: %u\n",
+		__func__, st, op, phyad, regad, data);
 
 	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_READ)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum);
+		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, st)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, op)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, phyad)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regad)
+		| FIELD_PREP(ASPEED_MDIO_DATA_MIIRDATA, data);
 
 	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
 
-	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
+	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
 				!(ctrl & ASPEED_MDIO_CTRL_FIRE),
 				ASPEED_MDIO_INTERVAL_US,
 				ASPEED_MDIO_TIMEOUT_US);
-	if (rc < 0)
-		return rc;
+}
+
+static int aspeed_mdio_read_data_reg(struct mii_bus *bus)
+{
+	struct aspeed_mdio *ctx = bus->priv;
+	int rc;
+	u32 data;
 
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
@@ -78,31 +83,80 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
 }
 
-static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+static int aspeed_mdio_c45_read(struct mii_bus *bus, int addr, int regnum)
 {
-	struct aspeed_mdio *ctx = bus->priv;
-	u32 ctrl;
+	int rc;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
-		__func__, addr, regnum, val);
+	rc = aspeed_mdio_ctrl_reg(bus, ASPEED_MDIO_CTRL_ST_C45,
+				  MDIO_C45_OP_ADDR, addr, c45_dev, c45_addr);
+	if (rc < 0)
+		return rc;
+
+	rc = aspeed_mdio_ctrl_reg(bus, ASPEED_MDIO_CTRL_ST_C45,
+				  MDIO_C45_OP_READ, addr, c45_dev, 0);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_read_data_reg(bus);
+}
+
+static int aspeed_mdio_c22_read(struct mii_bus *bus, int addr, int regnum)
+{
+	int rc;
+
+	rc = aspeed_mdio_ctrl_reg(bus, ASPEED_MDIO_CTRL_ST_C22,
+				  MDIO_C22_OP_READ, addr, regnum, 0);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_read_data_reg(bus);
+}
+
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
 
-	/* Just clause 22 for the moment */
 	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
+		return aspeed_mdio_c45_read(bus, addr, regnum);
 
-	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_WRITE)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_MIIWDATA, val);
+	return aspeed_mdio_c22_read(bus, addr, regnum);
+}
 
-	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
+static int aspeed_mdio_c45_write(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	int rc;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
 
-	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
-				  !(ctrl & ASPEED_MDIO_CTRL_FIRE),
-				  ASPEED_MDIO_INTERVAL_US,
-				  ASPEED_MDIO_TIMEOUT_US);
+	rc = aspeed_mdio_ctrl_reg(bus, ASPEED_MDIO_CTRL_ST_C45,
+				  MDIO_C45_OP_ADDR, addr, c45_dev, c45_addr);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_ctrl_reg(bus, ASPEED_MDIO_CTRL_ST_C45,
+				    MDIO_C45_OP_WRITE, addr, c45_dev, val);
+}
+
+static int aspeed_mdio_c22_write(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	return aspeed_mdio_ctrl_reg(bus, ASPEED_MDIO_CTRL_ST_C22,
+				    MDIO_C22_OP_WRITE, addr, regnum, val);
+}
+
+static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
+		__func__, addr, regnum, val);
+
+	if (regnum & MII_ADDR_C45)
+		return aspeed_mdio_c45_write(bus, addr, regnum, val);
+
+	return aspeed_mdio_c22_write(bus, addr, regnum, val);
 }
 
 static int aspeed_mdio_probe(struct platform_device *pdev)
-- 
2.17.1

