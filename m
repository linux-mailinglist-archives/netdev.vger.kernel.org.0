Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3216A1EF9
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBXPw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBXPw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:52:56 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3FD1FF6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:52:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXO57+wGkshYX8YKFNOO3Akv/iqcTa/lxZ19+YxHh1rm2j/N/9yAl+CEYk8AsuUGt5TXF0yfx7Jyy0nxNiN2CN8v4yOciIoccsoxt/hNCg+8/ba3uP/7jtIHfLb8KpTrPCRY5ZmlOUWtJNpVuoq9vdz298ZjUIWByhk95uu0CqDXI+StgD8Sp9KZORikdk9cEyiyzxRwXgL7Fdg5Aa5QIcvbadTVEJgvzvVRJuG3xHolDUcaRGyhbl4X0KZdrdEvSmVjdUmAFgJ9753CD+oNAHvyEcokrmnCY9MLyw5xR3mm/iZKVLaO/R+9L4ZrhpHxc7s5sgZj6IcRenb0FPQEEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3br7F5F2wQioFC1L6+3l1HhZ2OfUbTAnDD2oBCfSqA=;
 b=fz1qglUZjRkhBd55LcA4Uk6Na2NK+qM3RqDiT3xQsCQ93TVuaS0sH9EsSmBMIMRh4rGH7poCHc6oAW+0vzMk1cg8TM1qA6cRi3IXGS8FTA49gXpTVPP+RIcB9HJIbJ65gIXDuYYpjPYRJ/aFvSXGVxsBJqu/gr2U64uk1velSMZ2DEE3Wj+0FYudOmnIxxefbxwjmM8a5u8dtPptG+tkg1eHThHv9qJ5UVoN/8wi1ftuLKV5RYZgJTK5ExOj+5CgWNx9KREab6dGS31aqXAcGmxD+06/E+tJstBh6kuxq3Vc+Sk5TJNSarcRZ6kjMev6HBbPWdVH0R8FGQ+dEPf39A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3br7F5F2wQioFC1L6+3l1HhZ2OfUbTAnDD2oBCfSqA=;
 b=GjG5RBEV38ArRxbHABtqjCC8rlzcP1f3UIC+pcOHMNR7KamarAfImbkadKrybV3WdBufowm0JQIRs7y6nBVDPc0zTUbK4hM/4Iptmofl7rDpv8+dALSbq8hXAAa6rDaRHpuuezCyxuht9TNJhT29YIWxFrgvy0Fos+Gnii0qttc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 15:52:51 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:52:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net 1/3] net: dsa: seville: ignore mscc-miim read errors from Lynx PCS
Date:   Fri, 24 Feb 2023 17:52:33 +0200
Message-Id: <20230224155235.512695-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224155235.512695-1-vladimir.oltean@nxp.com>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 26443266-ab32-444b-684b-08db167f2eed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wf/plYm/Wr0YlUtpZmguLVXFlx1lrHEFn/1v7d5srfEFcA26AuL4hrLdmJWn9lQvvrmxK+QCdTMl4SHiLJ0yDMn55d6wmD4ahvhBY2GxqVwt9/lwRNuk/fl2wS7Cu46al8kjcrBMdCMpxcOetKvHYzhXF+wGokTNP9zHtJ77iTRGD7uBG0G+U4KySpt9SboW/jrg2c5QopCNmBwz60zR+YmAGjyIijIjnJTsMsA6p1jEzH5ZKRymkBMS3ZbCtNc94lPFEh0MgC9pY7Z6XntJhN6n/HDcxx9AM9nfrK3XWq+w0gSfAw9p8pugQO5zQe/A3XEeAvb5unlCRgDZte8Ajc9LVsFVsB8zrHQ2oLPWqUUmTxFXWFiaVYWQpr8qntBRwZYtRjcMXVzQKsvMEPTh5VAolT+ELYX52hmhcL2x2OMuaSm+kB9R3Jm1EnhX8EBr7UpHldX/LdXlLC0YuvhAEW9ITc+q4J3nxInqqm3Kh6Qzn+3FA5YUKaznhkpqGB5lBtlHz3wJZ7R3ZcTENMAT7QXgma8RxMSQWVBEcolrvuWp9gFdOExFpe7KngnSseGUldddF87bLLDhiWJxsdMSPI0Uz/ITU30zARxUIWTKLQ+J2rhVj0OuBUQ1x5MGgKLQj9oYNrr5w2oZ1PB2uTZkUNi6iFFisJ7sYMfhmbSG3SdNkGN5IKM3UFcK0j82XQ7k2TvfziEUPshCEsFvCAgjcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199018)(8936002)(66946007)(6916009)(8676002)(4326008)(316002)(66476007)(54906003)(6486002)(7416002)(2906002)(478600001)(52116002)(41300700001)(66556008)(1076003)(36756003)(26005)(186003)(6666004)(6506007)(6512007)(2616005)(38100700002)(83380400001)(5660300002)(38350700002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZEaZ3deqx+W0bsrHUDN2lIJ2/qqcpqCCcqXgwG8TaiC93zNGuCJCZi9sP84K?=
 =?us-ascii?Q?/Bt/RoFsvhn4GY5aESgHp3D0YDDWr+4xO+c/1pBcuCSRF+FAaTiWdVZvw40X?=
 =?us-ascii?Q?pRdOPFXnp6r5kTneFgzqHkwvDQd/vEzh0/lhFWrI9a+JBYTRrOdR+EfOMKun?=
 =?us-ascii?Q?FVydVH4oxWW3SmwY9yoLi1uH7mz2C3+KjYjBF0eCmP0TVTIHVvBjGrplDfGl?=
 =?us-ascii?Q?7lcQ4MRxcWKwRmrzEL7FkPRi8Z4vm00iSFX8otCo1HgjLooqXDophH9copho?=
 =?us-ascii?Q?jysVU3KL6Unxp/PPXH89rUk1BOlATnxzqX9dLTxgXjBaHtm+hrA5y5BKfYFa?=
 =?us-ascii?Q?j5L+pif0rhRpNSn8ZKmYcwg6H033qNX9DGzH/5M8bM9eCGK6W5zasRvyggg1?=
 =?us-ascii?Q?enOC+lbWCz4DOThNmlLZljsOzFHe0/JuLPrJRQ4lpKhCljCtcveU1ZP8k/x5?=
 =?us-ascii?Q?6EuX9jtUpWEm0gtHYdaW5/3bO0zKqi/DYYFUAvy88AjPoHDr+LqkJt31JDec?=
 =?us-ascii?Q?yPNyxD7j/+9DbE6RZ7k4xp3tJy6et3Jtt5H6IDpUNbJFX+yxGN2BzYpa5j/W?=
 =?us-ascii?Q?Wc683IllIzlasxD/RWjnvh1H5Fu6XGW8Zbl1x6hhaqfLYIf9cWHoyZJdWuRg?=
 =?us-ascii?Q?LqYm+q1//bYCBDPbP73tTTFcuZWNHUiPNIfOoHlyKcQgatX/lC67Ki3aD86k?=
 =?us-ascii?Q?Kmbq6s1Sv6K3dNIOR3u0qEpJyeWkwBFUs1E8zQUCV93QNEGUWO2NqVxrGhmq?=
 =?us-ascii?Q?GEYt+r5tkIVvJ246FORbL7Q5mW1xB73cXmv4RUdsrwuFFeiwGQs8KdK9TzLl?=
 =?us-ascii?Q?+VPh9e+V4dSj7DsnrXQ9qS2J1yIkUMYlCaNFhOAykXumyg0sJ1gN82VaIpnm?=
 =?us-ascii?Q?WET5jWlNP53DRPYodaksF1ShDZFVybCJYz1g2FVMI+CfewfqY/Hf3MDIdkwL?=
 =?us-ascii?Q?9c3Wsv1iFh+jNUg87hoSROToHruyy14CWTis7LDTNHQV7eYK/NjcizDUhhsW?=
 =?us-ascii?Q?+XtpwOE2G+cGp8XM/n0atNP/524SfjOHyY/GbErJL1rfXoFz6yRsjZlBfcle?=
 =?us-ascii?Q?SMTLIezl31kOUeTyG3I87i6PHo3G2qMAPeA2ejn+0OMFcxqkgBwtXiuyljs5?=
 =?us-ascii?Q?ihSmFdLUy/fJFuAuwLdAvqXJ/EtXMnU3zM9d0L58DqHWhnPjTP7LpG40mhiW?=
 =?us-ascii?Q?oTavvifU3B8t0aZo11bxNiSMx4MU9Ad6Lsl8mZjqqfnLV8toFn1Uj4u2gwKy?=
 =?us-ascii?Q?CmBM2TZZRuP9qgJ9O7c4de1iGAj0LHhOEcgzTNUbrKztbewahL8m+CEFa11e?=
 =?us-ascii?Q?a7x9nqN8s0hdymdq3jpQAb6UzcRoFDcwUulGiSalm/ilyC5LpIOL/svQAfCK?=
 =?us-ascii?Q?zvTiFy4KHRjm6OtdHrPF1cdTt5tkHdTBhxKqtO8hzhcHZstrG+C6A+Q3MWgB?=
 =?us-ascii?Q?Iq8Udc1lAF5e9UGyEwrWbzP8yg5Di8g3vOrxUdC+bMCnsCMLkgLEieUrrFEd?=
 =?us-ascii?Q?eQsL8F4/7NpVuVvHKk997gOK9D7JcU3tfc+Bs7UOeUsqC5xcS5OQQF9Le9xy?=
 =?us-ascii?Q?C73OpScpCXR2wcqNzCH2XbX8YX6kWpowG0G6+0H4Z22+W+0xb9ixKLT3NieL?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26443266-ab32-444b-684b-08db167f2eed
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:52:50.9837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEaE/k4z0aw5k3LVr2BcefEOizn+cFgv3jpAo/tpHUrSZGAKjjvsbLGSXdkCPdnJ/ALmz1L4D1wyGCnHxZUGrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the refactoring in the commit below, vsc9953_mdio_read() was
replaced with mscc_miim_read(), which has one extra step: it checks for
the MSCC_MIIM_DATA_ERROR bits before returning the result.

On T1040RDB, there are 8 QSGMII PCSes belonging to the switch, and they
are organized in 2 groups. First group responds to MDIO addresses 4-7
because QSGMIIACR1[MDEV_PORT] is 1, and the second group responds to
MDIO addresses 8-11 because QSGMIIBCR1[MDEV_PORT] is 2. I have double
checked that these values are correctly set in the SERDES, as well as
PCCR1[QSGMA_CFG] and PCCR1[QSGMB_CFG] are both 0b01.

mscc_miim_read: phyad 8 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 8 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 8 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 8 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 9 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 9 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 9 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 9 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 10 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 10 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 10 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 10 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 11 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 11 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 11 reg 0x1 MIIM_DATA 0x2d
mscc_miim_read: phyad 11 reg 0x5 MIIM_DATA 0x5801
mscc_miim_read: phyad 4 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 4 reg 0x5 MIIM_DATA 0x3da01, ERROR
mscc_miim_read: phyad 5 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 5 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 5 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 5 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 6 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 6 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 6 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 6 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 7 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 7 reg 0x5 MIIM_DATA 0x35801, ERROR
mscc_miim_read: phyad 7 reg 0x1 MIIM_DATA 0x3002d, ERROR
mscc_miim_read: phyad 7 reg 0x5 MIIM_DATA 0x35801, ERROR

As can be seen, the data in MIIM_DATA is still valid despite having the
MSCC_MIIM_DATA_ERROR bits set. The driver as introduced in commit
84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953
switch") was ignoring these bits, perhaps deliberately (although
unbeknownst to me).

This is an old IP and the hardware team cannot seem to be able to help
me track down a plausible reason for these failures. I'll keep
investigating, but in the meantime, this is a direct regression which
must be restored to a working state.

The only thing I can do is keep ignoring the errors as before.

Fixes: b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 4 ++--
 drivers/net/mdio/mdio-mscc-miim.c        | 9 ++++++---
 include/linux/mdio/mdio-mscc-miim.h      | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 287b64b788db..563ad338da25 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -893,8 +893,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
-			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
-
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			     true);
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
 		return rc;
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index c87e991d1a17..1a1b95ae95fa 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -52,6 +52,7 @@ struct mscc_miim_info {
 struct mscc_miim_dev {
 	struct regmap *regs;
 	int mii_status_offset;
+	bool ignore_read_errors;
 	struct regmap *phy_regs;
 	const struct mscc_miim_info *info;
 	struct clk *clk;
@@ -135,7 +136,7 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 		goto out;
 	}
 
-	if (val & MSCC_MIIM_DATA_ERROR) {
+	if (!miim->ignore_read_errors && !!(val & MSCC_MIIM_DATA_ERROR)) {
 		ret = -EIO;
 		goto out;
 	}
@@ -212,7 +213,8 @@ static const struct regmap_config mscc_miim_phy_regmap_config = {
 };
 
 int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
-		    struct regmap *mii_regmap, int status_offset)
+		    struct regmap *mii_regmap, int status_offset,
+		    bool ignore_read_errors)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -234,6 +236,7 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 
 	miim->regs = mii_regmap;
 	miim->mii_status_offset = status_offset;
+	miim->ignore_read_errors = ignore_read_errors;
 
 	*pbus = bus;
 
@@ -285,7 +288,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(phy_regmap),
 				     "Unable to create phy register regmap\n");
 
-	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0, false);
 	if (ret < 0) {
 		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
index 5b4ed2c3cbb9..1ce699740af6 100644
--- a/include/linux/mdio/mdio-mscc-miim.h
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -14,6 +14,6 @@
 
 int mscc_miim_setup(struct device *device, struct mii_bus **bus,
 		    const char *name, struct regmap *mii_regmap,
-		    int status_offset);
+		    int status_offset, bool ignore_read_errors);
 
 #endif
-- 
2.34.1

