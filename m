Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00814F6578
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbiDFQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbiDFQdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:33:35 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2135.outbound.protection.outlook.com [40.107.215.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A51152806;
        Tue,  5 Apr 2022 18:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7ZNi4j45yFW5d0AAVI4/9khcQiCmyIur4VHnHsMHHT6pLwmAmToFmQQsq2/sUaLcrCYv9KIj+3FrBW3RXO84qBWkRbgWMYJjbsJCTopfpFRFo/u4yxfSGH8kaf8Yfuq6QMZEYQs46P9917bgi8Z6KCHtw59v4FztYS576GeUjy0DPxbIrOR4cgUhJPffs7031bI6QTd+XtZRIpE6C8Hg8K5VGC/xHeYsgqMvA0NisIh/MgcOx3nzFj03bwu03FmNQHd6gIKUNw4IlsWKZCyTCN0aaoWEkE2N86h3l/pOjlLy5T0HEoUjx3Ti/Umm/QZvdB41Thnrj12Q/BpC014Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edq+ryQ73PscVubk4QO6nQR8gN/3+Nc3wCNr3YSWrhI=;
 b=fNM4PAxkL4fK9DxhGasgL+RfUj+xySXSED5eBsLi9Euy58w5x473m/QYLVoqENB1TiqtZ7bu44USYv8SfKGayUWrqnJ55z1HwDuSlLPDnwzAVLIbckHIK4w0CBcp1YScE3ltaVBe2cPbIb9hTNajnRdIrmQr6uptC9iIVovqHNnt0N5DpibC2PZCR7XlMTjqJaLYJn0o00Fo4/k+mIlEYg/hZXHa54LQ7Gk2DVaMOFLyJjoGgSusMsYbLoLamfXIoxQci6ACeBmu+BXtdqSbuQqPs7p5SiBjuUbjcrMpqdS/jZhjho0WG0TUMR8MnoUGnhjXdzW0Suf5cGvEl5tybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edq+ryQ73PscVubk4QO6nQR8gN/3+Nc3wCNr3YSWrhI=;
 b=B7Dcns8vhx8is3wsZxycpvT9pYkNwPVJT82DIl+VDGwOcOJr1AeshSU9my/0cRKz8Ij6pC/p4dmf01v2vKh0iL4T1bMHSycGs7aTazxcy5BI2Bs8ky4hbd8FCXloShh41Fz2UivTGYyEc6Vqu8gv2RC3pTThzj+TjadFKQ8xjkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by TYZPR04MB4446.apcprd04.prod.outlook.com (2603:1096:400:4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 01:20:25 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 01:20:25 +0000
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
Subject: [PATCH v2 3/3] net: mdio: aspeed: Add c45 support
Date:   Wed,  6 Apr 2022 09:20:02 +0800
Message-Id: <20220406012002.15128-4-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406012002.15128-1-potin.lai@quantatw.com>
References: <20220406012002.15128-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:202:16::13) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bc4b837-685e-4cdc-e62e-08da176ba0c5
X-MS-TrafficTypeDiagnostic: TYZPR04MB4446:EE_
X-Microsoft-Antispam-PRVS: <TYZPR04MB4446FE8ACBB8FCC5C4C4E0008EE79@TYZPR04MB4446.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l27w00vS6yVVZ/7ijS5nikPbPHClKQaubFN7CcwTPWyy8ChGtCcsrYbUsSx4N1ILXUv9bL2Xv+66esAO2eo27frahEKTtbLUk9hl5AZXMFzTYW6SL/1z3j35dsMyxnBhvKJyE/4nvvUmYRxqpcSWe38CkLNuW4fwWIVenfZa64Mi0kgRfUqv37OLutFf02EDFJasayXmd08PKyPTpJkz379wmAPSJBV67igRzkvCdqZIU26hQz69OJmWq1SKD4OAODWXSanJrFr4LJPTo6Q1xstfKxiAkZJ9fa06YfykPFZxfY9zUViFpi9YPDPFxvDW+pasQfQk+U4Xt9IrWjaCSVIR3a8tD4X+Tm8To+NLScy/rDS8iWrWls4XtIOquk6pWE0FV5moc5u3al0zwdYjWF2qGPGCQn/sz12BMF6kNOpVUO1AaKjFfA1qjmDZS42rf+EQo/B1frc8Q/JYmgGJyJdGvif3osSvFPLGhiB6eZvX6HaksSGE21wJ5RAGtqrRV07/Io/R24MlI34mKPPowbpOOEZcTKX57ch+s5B7a3n8RoSpjxIVoHYfjuA186FsnHPHoOKzY9q1hflb9/9OJHdzwpLcXzt2XgvoThFOO8sVOTBWPrvRGxKGnMi92mIDBaLOLFDfCDViWJPHrFEbco+bEveRVpb9BQY4BZKMQYBwgwsE0WWNfn19AgMMgiM9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(5660300002)(52116002)(38350700002)(38100700002)(6506007)(6666004)(8676002)(6512007)(66476007)(66556008)(2616005)(4326008)(110136005)(86362001)(8936002)(186003)(6486002)(26005)(7416002)(36756003)(44832011)(316002)(1076003)(2906002)(54906003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vvGKYz9qgUU98IUqKKLiwoxDkta7GjuTCCWYXR1vS8MbwOdT3bpCk4d3/S/3?=
 =?us-ascii?Q?/6uTmwV6QCzqAeXZ0mSUC6wQctAZhzvxR0zgOO3RuPiPvJCio2MX9CtcsIX7?=
 =?us-ascii?Q?3BFHWRzH0JGM4Xcm/vKEjC14yR/riu7rJic15S9yRt14AvrekdQOixVLHCIX?=
 =?us-ascii?Q?sOMm2OM/VOabnfyGrv9aF/y8m8wktxJ1L93bA3QBcK78gUt/n8tcwcD7jdpj?=
 =?us-ascii?Q?rfWg18HETFHPK2UvfqfAV5JiTQsCgG1vXglBaJdcPt2eLypbtBDiCda/jb35?=
 =?us-ascii?Q?jilGDMJ+e2vUz4HPchCns98VCEquXuzrttlPJC1hycmV4p4/yjRmJhYhUs8G?=
 =?us-ascii?Q?85v4PV9nFGbZtRhWlaDRi9WEhA+QDkJQKSUg+D6alu9Zbu1zO7dyKg4uwsvS?=
 =?us-ascii?Q?TZsXqsTG4d70E0/p+cCPnPVSTbVTWlSJ2ptAF490hYaD/yusjEx3w6YWI62T?=
 =?us-ascii?Q?3+3ooZmDz69ELSWgB48mdJIuEbaUvbcu574qydoiS+CneIKf/PB0G1yV38/U?=
 =?us-ascii?Q?tNnwA2uO7KZSmoQGjuahUygKVM32edPgjmOnLOakqLi+/38lmiQxWk2eR5zK?=
 =?us-ascii?Q?JPitvy5nYeJILhz4med1y8+vZBZiDKnLA15bDhEEo4KnskBMmDh7cwAJJqMY?=
 =?us-ascii?Q?8hHh2NYJEJ4243qnN7Tim+FKeZzUXrjg4ZGDfQPP2SWPUpoGC5DFS62X9LLs?=
 =?us-ascii?Q?9SdUm7w9mWkSEltmOt6Paf1kO7NHysmCwgWqrXzflEaSKWEbu9eRxRhxiT2/?=
 =?us-ascii?Q?RHxfR8uWIu2Gji9bDcJpdJJK97xCIzXVdbrTwMYqBnti6QULZWUxDz4rSoUG?=
 =?us-ascii?Q?MUxVBhwNpcxDDqZCJVX1YRtiUfurpzosmOOVphSXQlnhoDrCg74JIS5BmiyU?=
 =?us-ascii?Q?sUd6dcsRb0A2EFKH0z1Ew34QIWVJ9gjJ2+ubUfPCxoqd6XYcghxz/jenyr3d?=
 =?us-ascii?Q?pj9gFWR84ywHoKSS4MuaY8/W4kAg4vG+6Xto0LjeBTnu53KGeVq4fCq0zUWX?=
 =?us-ascii?Q?xX72Sn21abInXseEPkAt9cgiCNQRY0/T+qtY+D7VRQcC3BODy5g+iB/TWTE9?=
 =?us-ascii?Q?s5Gk3SqyD+wLXwcjYXqY/W/rLGEFnBeTg4HU1hNkf71gIHUxcfptFS6t+tKd?=
 =?us-ascii?Q?W3t29PmSeZrhIYQBA9jFfn8NSEw6dUREQF4X00jlHYYqrHYmfqNqT576U7Mz?=
 =?us-ascii?Q?FINBTVRtT4YTyBBpE03E7wn9UrCnygTlE0/9Rib5HLeiSD+xD9+gVDfyJlXR?=
 =?us-ascii?Q?jY5IT1P3yGJ83tQAvz7B/SXSYGFHHeGhetNZn5dq3wya0qKsoMroy1qstsZS?=
 =?us-ascii?Q?2xxPBNzy3KtgKmst9kOqYi++Py2o2C1u0h/hMVtsh2VPfGh/t3pyYmBLhksw?=
 =?us-ascii?Q?w2P6lrNxJ9a2v6JmXl3szbf0sTj8sH5fxmqH3AAT4XeNSudHMq15XwWWFb5w?=
 =?us-ascii?Q?Ey5B17QAsnl+PwIlNo5tMTKW22dvqXMVnbWKiiBWJv8k68+AyGWdVbGglMe7?=
 =?us-ascii?Q?/i7+/B0I/bi2Jy7BZlnzeH83P6TLgt02O+wNiIB0MKlPI2lDhy1FMStyYRHz?=
 =?us-ascii?Q?c48aSQsELJXQthmF2A4wz82Vnd5tdi9uEKZZXNhZCofLfpMeoptIOXqSGdTZ?=
 =?us-ascii?Q?iezhiCDbzuGK+9z0mtSoiet4M0Ecpw7uRhMIJN4MWtp83FwW9+CtLNx4p567?=
 =?us-ascii?Q?g0RQNeSiWQyFaHoaOQQh1ilen0LwBd5Sev7homJ6Kk+lb/uBUhG1Hs+F62Jm?=
 =?us-ascii?Q?evmxdzbze3mmSznvZn446FzWNySp2No=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc4b837-685e-4cdc-e62e-08da176ba0c5
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 01:20:25.3703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPVieK2LhWptcX7nE3+/iKTY5pvANhWuh+VdJ2zfU+208XVIH7Hvya9+aiTQVEfkdJfpklLE7YUTK2FeGO8Beg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB4446
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Clause 45 support for Aspeed mdio driver.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 35 ++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 5becddb56117..4236ba78aa65 100644
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
@@ -100,15 +104,37 @@ static int aspeed_mdio_write_c22(struct mii_bus *bus, int addr, int regnum,
 
 static int aspeed_mdio_read_c45(struct mii_bus *bus, int addr, int regnum)
 {
-	/* TODO: add c45 support */
-	return -EOPNOTSUPP;
+	int rc;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
+
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_ADDR,
+			    addr, c45_dev, c45_addr);
+	if (rc < 0)
+		return rc;
+
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_READ,
+			    addr, c45_dev, 0);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_get_data(bus);
 }
 
 static int aspeed_mdio_write_c45(struct mii_bus *bus, int addr, int regnum,
 				 u16 val)
 {
-	/* TODO: add c45 support */
-	return -EOPNOTSUPP;
+	int rc;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
+
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_ADDR,
+			    addr, c45_dev, c45_addr);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_WRITE,
+			      addr, c45_dev, val);
 }
 
 static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
@@ -153,6 +179,7 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 	bus->read = aspeed_mdio_read;
 	bus->write = aspeed_mdio_write;
+	bus->probe_capabilities = MDIOBUS_C22_C45;
 
 	rc = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (rc) {
-- 
2.17.1

