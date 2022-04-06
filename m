Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4B44F65D1
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbiDFQeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237894AbiDFQdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:33:35 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2135.outbound.protection.outlook.com [40.107.215.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15938BF51C;
        Tue,  5 Apr 2022 18:20:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrG7oOIICXRUDqHoeKEf73TgMGWo0NkRfSP1x8krrCLZZol5sj6wqeeJjNueEW7Fimv0+d5bB3igx6bETy8u5szzf/TMMgIXSqXBQEITQCaWCQq9DOsUt6y769MH1gbnSIc3ICMnqAN1Z1aTUyQ1PwA7QnZulBL+CTK5bniGxC3Howe3Cx4YkFq/lGFu/dTExSmZgarJUWx7ijAiWjW+8ycy6WYXXxQs7ZAX4ms41JbVweG27fO7LrSgyJ/5+wwm98diZFSDqtAhpnt8JpR77Gsh5gVep+Q9b9pfMNvKHYNv5If1Q2GDwZOJ9o5AVf1ySiVimBULteerNhbZXNdlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYzr40+X2aVF3Ayj/CulXGvHvmrjzqpfdwE9vWNRAhw=;
 b=cQgye6poErAu6oGgPYMPZVnbIa9fJWezwNTDhtinupQX0izNWqGDuDCywPyfvRxSdPHCulEfWm8TdHvhBCu47fS5ebajMiKgJDfAE3CZN37kuh9Sz9QPB7xOLhACShO0JiGyfZoNwsxG7uoFTt3BhrBS4B6MZnRZX15zWOPZEbfqLBqrXtACLzPIfew4GTdYBZq1xH62oXDRYPqdwUTV4D92Em0VgSZfRcaYX3e54Ujn9LZ8aqqsOa+aLSe5muZxRG345TSlvRrlbrkfej+ETnjAm8aV68TjsIMBX5fft542UHmUY5HK39EDu9+eE6kUfr+GmUSrkK3SfIsxBtxQMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYzr40+X2aVF3Ayj/CulXGvHvmrjzqpfdwE9vWNRAhw=;
 b=WK4nBNTagsSvlXsjMhKPUl9i6ONiWh+HVP2H98UYIER8Xcb2U2HWnPGzV/9E5UkYVDMJpyOsy4UNPWmmUaUS5Rw8MshEaO/Iox6P4jvDpsc8bLorMSv9JP2EMdF8RoZvZcVfmkmPMMx+U5BwyDqd5rjnAvoeDPKvodfHco+XYtw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by TYZPR04MB4446.apcprd04.prod.outlook.com (2603:1096:400:4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 01:20:24 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 01:20:23 +0000
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
Subject: [PATCH v2 1/3] net: mdio: aspeed: move reg accessing part into separate functions
Date:   Wed,  6 Apr 2022 09:20:00 +0800
Message-Id: <20220406012002.15128-2-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406012002.15128-1-potin.lai@quantatw.com>
References: <20220406012002.15128-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:202:16::13) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b16e4695-8367-4e77-493d-08da176b9f7f
X-MS-TrafficTypeDiagnostic: TYZPR04MB4446:EE_
X-Microsoft-Antispam-PRVS: <TYZPR04MB4446AF013EA56DFF051310BD8EE79@TYZPR04MB4446.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHzOp0P9RHuHV9k3wf2tYklHanpK2NU4cQ7ESFPuejSS6IQT3naUzOG983XBcvxuMEtejZYIBqV25rIfbSZdLGh1Nj6XssBXiOsqSbtmZE0kT3MapJ0vhmheM0L9peArl1P6NFaqfozuTbUavRxcIDrmDQe2UqtYbsg4B6is4HkhWScognVGLVYwabkNxn9TcR0LZpPdS3Q6hp432g1BQiglRzphC2vZITopYEse/NT+OHJUeNhKEydRjYFBnjw9zqnM2Y0yRZYR1A+fPNHXUw9/e1E2G+CBWoRHTVVeJZSTLgtK64khkw/VSqHccHWIZlicuvBpt2D/FJM1njZdFI25Z+bUnLbIoPx35tVydBLhuOqhUGndqXE4gXQuPrIqxS7e7yl41vMNc2NEovFczDxPzssfDw38waufjP8jQcCtqCQy71MyeJdML8lB6A287o695jwTbbzLlIlpg84j4g1GcSewA2nWnREDt4nh1CScaNcoZU9d95vtf7DKNZPqE+FM2hPBYAAKN8eSYj/5U8vb/RpnL6eiQuqoTeD/qE4Sci5/nBRrOzkpxNarh9Cb+4C1lpvDSlDkno4fyIeOCMIeshx4kztH2ZRRyCncja9GO7rFqgxLh6axcgMGfOaCkG1gRHTSCd/WBbQhu7WKQoPocQ3FOtwHA1kk12VzuO1aDsNB+zy0yxx/1dqypqAh18hOUQ2/7rR49AWS1eEcqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(5660300002)(52116002)(38350700002)(38100700002)(6506007)(6666004)(8676002)(6512007)(66476007)(66556008)(2616005)(4326008)(110136005)(86362001)(8936002)(186003)(6486002)(26005)(7416002)(36756003)(44832011)(316002)(1076003)(2906002)(54906003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfXRvjpue6bVxxRjf3acT7EcfIL3cwzBRSdn42difrDFjdRKcz1sxvMN6q7F?=
 =?us-ascii?Q?slBaPaZ0QM/qJ1Cb5ER8IygO2Z8aV1sXjwp+DNObETZIOuFO/eSwJnb1GFLh?=
 =?us-ascii?Q?zNrDjl64REiSO5BQEJU+HVCzrzlpwKu0IQlB7TA76d8+uHR9z3XU1rJEePop?=
 =?us-ascii?Q?y1VHbz/KEG/EsYNTZSkJxvOhjb5xDKSGQPSkrGDRRxvrNAMrWhua0HakShko?=
 =?us-ascii?Q?WMfLg/+RJyevBgda9OPRqMLBjvyltPVUDPDPp5XIy79ND8Kwg4YZzJMw4qL0?=
 =?us-ascii?Q?XpPgEhgQNaUfZy4sNOBLAwlOQA3jB6FIpv/KuLHdkH3DRfO6vAGyDta0hQpg?=
 =?us-ascii?Q?XHbTz+8ExXWy2z7SAXZIt70gWmPvfJ4MqxTg8FRDTUvLaVn6lflZNbP8IpBu?=
 =?us-ascii?Q?jc7h2vV0tV1flZIMUKq+FV6Rxk3en8bjsvKs85WbWrbMVPo1WKFliMHE6Gw1?=
 =?us-ascii?Q?tt/XnyF9q0gDt4e9n8a6Cx7mAL/QlJVwTkQika6kU9mEXAMEqrg9UQgPKxEp?=
 =?us-ascii?Q?yq+600eZfQKiQ3W0cpG/8YxDL4UnPaA6Ppc40tvq8IklX4vDkcAdmkf+NsiW?=
 =?us-ascii?Q?o5zNMQxmNIEwnpbjCUHyyKNqUrqSD0jaButfQpA2KVYFJuwUsblEpgTe8HC5?=
 =?us-ascii?Q?NrikT5IyXaND0Mrwk7pCrt4OLRj/ABvcxL5cXui5HsqmoYqLXa95S0HkFiPj?=
 =?us-ascii?Q?QYt6AL62qv73mlnq4WaqeisTJRoMs2kl4viMZ4UGa802JN8kHBmu89H2MGEl?=
 =?us-ascii?Q?A6HoJEsNbuuBE26+hZtgb+zfynzjmnwuQIP4Fv2P7YvMuTf8KdVsjtyZwYEs?=
 =?us-ascii?Q?DZAUTGCl4JsM2ZgGf/R6M7kgoyZSgVYuO04lycQtiz8mWQSJl98SlJLMtxpG?=
 =?us-ascii?Q?lUBj31finNBY1zgmaPjWAqFrEotj9Ai9btVGKVnw4flggSjXpLYi+kCgcsIk?=
 =?us-ascii?Q?YK5OuBrZcYVkBVOs606coQy/OmOs/e/haEeAro23rNQtm7UvbTnUS0RRm8ML?=
 =?us-ascii?Q?FFg03u2MX1PL1Z2nCbcRhTNgjApwvUgcJJ0a9CUt9EsNHF0gXOC6TdQwt9HC?=
 =?us-ascii?Q?KJV9nSUCnuZwe91Z2nn2uNtSZrOsLbyEm0x+Q+cGnhfdUomvTyqZkq9ev10N?=
 =?us-ascii?Q?mJrlM8dao3dp+ebYMJ3MWTMhAduSHUZHTRifiY7exDLqaJKmynEIACG22KEj?=
 =?us-ascii?Q?sFr+FiMIvBCKCxMaquhtnhLKAvqvPe1iuoozwO7Qe2TCwkeHkpzcPaieLxvf?=
 =?us-ascii?Q?n15Bj/5ZsT9+Oehb7k/uA6NtAJCON37hea2/igsshlg++MFwMGMU4ps0ccKG?=
 =?us-ascii?Q?WyfDyZQLEwzf2yEyuSBt+6wNywZks6/UDMeS2pPkHhX+jeaPE0/f1HtsYjZt?=
 =?us-ascii?Q?XNB9c4b2lkUQnvSmhdpTN+rg8CB125udcYRGmrBINgA0q5c0ABYEOoalaZyZ?=
 =?us-ascii?Q?psUvbyA7uP7jK+ERGG5RwOsnPiy1pcjvoTAI9I8E2GemZFUPNND79XxBIkGM?=
 =?us-ascii?Q?hMsZkLxlxoaLMsrWn8EDC+cHUUHW7j0p8SYukTsVPiL5gPE1DHke4JG1ld0L?=
 =?us-ascii?Q?UwvwFHckGokLfJ1OQdYUmRz8DiA2oHWBrcaQehfMgmaEzAt1yqzwRJM3LOtH?=
 =?us-ascii?Q?Q+VTioRNx1qTuXJA3Y6z0WyJrXqOL88qKWzJjSJmE1I6+UkXMqnaTXniqqI8?=
 =?us-ascii?Q?9FPAHnw2+iug2rRbxnMw4NUL+zGWROTbmEpxpBTNC7MPaa4BPl026c7xbZup?=
 =?us-ascii?Q?ynvayVfyCxyHvgg+24lo3ATWP2NWySU=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16e4695-8367-4e77-493d-08da176b9f7f
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 01:20:23.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIbPlE6gPCBbyYTFnHcF8VBfOgMhNPdpkFaUQmFoV07uH4Ixk5ZmSMPXpey7k+q01JsB8w5mXLcOeBjXxzEELg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB4446
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add aspeed_mdio_op() and aseed_mdio_get_data() for register accessing.

aspeed_mdio_op() handles operations, write command to control register,
then check and wait operations is finished (bit 31 is cleared).

aseed_mdio_get_data() fetchs the result value of operation from data
register.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 70 ++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index e2273588c75b..f22be2f069e9 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -39,34 +39,35 @@ struct aspeed_mdio {
 	void __iomem *base;
 };
 
-static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+static int aspeed_mdio_op(struct mii_bus *bus, u8 st, u8 op, u8 phyad, u8 regad,
+			  u16 data)
 {
 	struct aspeed_mdio *ctx = bus->priv;
 	u32 ctrl;
-	u32 data;
-	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
-		regnum);
-
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
+static int aspeed_mdio_get_data(struct mii_bus *bus)
+{
+	struct aspeed_mdio *ctx = bus->priv;
+	int rc;
+	u32 data;
 
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
@@ -78,31 +79,36 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
 }
 
-static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 {
-	struct aspeed_mdio *ctx = bus->priv;
-	u32 ctrl;
+	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
-		__func__, addr, regnum, val);
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
 
 	/* Just clause 22 for the moment */
 	if (regnum & MII_ADDR_C45)
 		return -EOPNOTSUPP;
 
-	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_WRITE)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_MIIWDATA, val);
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_READ,
+			    addr, regnum, 0);
+	if (rc < 0)
+		return rc;
 
-	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
+	return aspeed_mdio_get_data(bus);
+}
 
-	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
-				  !(ctrl & ASPEED_MDIO_CTRL_FIRE),
-				  ASPEED_MDIO_INTERVAL_US,
-				  ASPEED_MDIO_TIMEOUT_US);
+static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
+		__func__, addr, regnum, val);
+
+	/* Just clause 22 for the moment */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
+			      addr, regnum, val);
 }
 
 static int aspeed_mdio_probe(struct platform_device *pdev)
-- 
2.17.1

