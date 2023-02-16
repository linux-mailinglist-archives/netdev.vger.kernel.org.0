Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860D5698E19
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBPHxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBPHxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E184D3C784;
        Wed, 15 Feb 2023 23:53:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0h8btI/g63+OG1zXzJJqnODhc81SK+7ZBgsXVU0DCEDJpV/u9wOyfHH7On0+1vZvSCGm75R5uX1/hH3CFNsGhdfw5Ozmc4hwU4i3sEQbQjPzd1onEPKXuQWApLYWruyxGQSOxxnJeCG+cQ0SBybsH54OMoX06u409dQ4aMdJjPIg4XUkrQNpcWBcTNz+23qvRF14l2D/M74IEigjyu3wTrw4yQ9ZjLI4109O0lIcTazTCJJATNkQYLRPCdDPKAXKHMvafw+e/torUCf0sIT7qrIvuMbFIDiLEoKKcf+gcEHjh71/ZENy1RWIRS9X9AphPKghRBnYAh+NrCyXEhIjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMLD/PzDylzSIrdMqGzF4H89qoPeodCMrtFeUUb1ymY=;
 b=ke7ey4TAPOHVYvNCL4gQQ6ODjD5tZ71v7FE7T4SvFcx5qHFgFlBkE0HqI5iuKpKLZ4Fmlpjr0xX09wtydUDQav2bt5hHaWCcjjl8krXTaHKsWETpQiR0L0e7Vq890U8MWC5lWVYGMKeIu7Y0K5Skz65hM1YBoZvfUlL/rm5A5n4zKUd3RsuVug2ImDbmEnSYIS7tljNmKenIP6ynKuNAYqnSxOtlU5S18e90DHVA/oUl6b/j8TPLydSetkYpvn94KSnEPZY5GZh+kdn0yP24kNnLGysM31546lQI1HmNgHMNSBgR1/R1PyUKA2TXvw62cfJT1BHjxzyMF+inmR+9oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMLD/PzDylzSIrdMqGzF4H89qoPeodCMrtFeUUb1ymY=;
 b=CBWDgRQUfZ7IlPTiU8cvY3aoBVOT2Xx468wPK7B3QFIMPvE0VFnUy0PjmBojDiwT3clPfXPkqrUGEnMwb1uGsK0Ffukm7IWZ8HBhppI1b2nkv1bEVpGJQSCp3udAAkOXC92cJNayh/pXYb6CzkYrLVP20jc5Lavhg8bCJmwf+gw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:39 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:39 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 3/7] net: mscc: ocelot: expose ocelot_pll5_init routine
Date:   Wed, 15 Feb 2023 23:53:17 -0800
Message-Id: <20230216075321.2898003-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216075321.2898003-1-colin.foster@in-advantage.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e1b277-ffd3-4b79-99e6-08db0ff2ea20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHMAkuAuUFmRZ5IOSNlGlZqidXCpIJ7SpvQEUP9emxW0PMyfAXuVaPYcJvh2ptjPWIqMTNYZgFjobRMeo8nUxwAq368YcveJbJaryrddX3uNPtT8u2xVKCsevXt5USXZ8wS8Sg5Sp4tRc1Ha7QGYFC0j5Yqb3GaAvmfdDJCcM89ENNOYN0IGJH/NOCKoviwfM7cxC73emjQRzqH4gYKGhoWv25PGUy9Dg/OcKiDxY4nmU8BEoEKHZtAcrr+TKVzjP6Jn0CI3123H7reqfrJifU6woYh7pfFRBPn2+TGuhD+6jEji4LEWhjFVElFvz1SRbkoHJTCffkpVOV1qtSWqDGHlt8bB0grb7QE4VOS63uU4MluX9Hwn/sQ3QlKsdC2X++13H5fC0lW8PkVpx/clMfnCaiR+H4CadrNW81UmYrz2fKe2CEzX2ldjmFUkR/CyU808CL2vIzPVncVeUrxrIzSBZjCjlZ/R+49WqhvoyCZasfBGEXvPzuvikKB6FPjTx0Nc4BcYb0y2Lc1dcG56a4OTYSVXkm6yLrxJAk38Zjc459lecb+kHc5vNhB7fPLI7kZcMllk5LpYZemEc54y6RolnNQcBu30KxVlQlRJHnkFCDFLZsW4PGx9w5usU97qQlpkhWcwDSIu7FsHhA+2jrx0rY6pDSV6nRmZ38Qki/gwzYi4K9YsDw4hqUnyC8hKrkOYUdyGYTaiFtrO5WI/vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(83380400001)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(52116002)(6486002)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+WEVOQDyQ4t00rnmhW8bslH1TBlBZDsvupAF9+zeMEoKQ8nsZFuvUTy164NZ?=
 =?us-ascii?Q?qXGPAo4fN3xUcEAq5n9TSHkAUEAHHMOPb63SH8vSjzjdegznstOuSi+m7E0I?=
 =?us-ascii?Q?3c8HSKB2VtDrVl/D+sy9oH06o8akQftP1m48ureMJAIB9NoS1ZiMzgyd1Fwr?=
 =?us-ascii?Q?WLasiotskmKu6kfxQdk7AyMG9hhiXonZnwSLWHTEmD5y4OxQ0jXVMyu7bfHH?=
 =?us-ascii?Q?FnRNiSetY68yDL3bBQ4xCyBz2mM67p5iWbb6EnegQq9yxGIGxzVi00OaWVbe?=
 =?us-ascii?Q?k6w84IvkG1V9m9wYlfrjl0J9TDUIRXzpmHRqV7Yn3br1rJDHVsgRsJFsbx4w?=
 =?us-ascii?Q?Ncxo5viwSNCPFnv9ZSXgGSe8yoltt10BOo0MpmfPLYw47MzQmEEjUp648wUG?=
 =?us-ascii?Q?Mkd6/k12qseQzrWZlXaDR8pqjoCq3TXUYLpZRM2jupQQvPnuYJe7ijYPb1H7?=
 =?us-ascii?Q?wcEA+Wf62yeefQkGI83VpdzBEBrjl6Oa3Wbi55PXvzvgenL/X0eDIBFFUzul?=
 =?us-ascii?Q?v0Dpd4N54ueKkoHsz4qgBDrPRJqEX67r3/XwrHQMsC0L5pokmZfnaZpquYso?=
 =?us-ascii?Q?5Fmmcbjn/va9yFhziwO6dy7iNNa1XaQ9QvvG6kum+Eulzymrit/pcDIS8EKU?=
 =?us-ascii?Q?4k7Ys8etL69RXabLvAv2ezQ3ZXLarJv9aGjHVrt3jt79hoCKux79yP5W5Rg5?=
 =?us-ascii?Q?ITQACKgBIAETgh+Uc2vTSZ1/THAe6EsIctI57+dCIrUOfETEL2is8oQf83+C?=
 =?us-ascii?Q?tL7TtJxe2uC1mH4JF4i9xQYmTuH2oSNyL7SPiT6X/bXNyl6ACXiuijpL6uh6?=
 =?us-ascii?Q?8cRcbMwA6LlgHndMQLiODUkz97NpuCiqtjPF1YK23faxtnNZcH2s8N0AewkF?=
 =?us-ascii?Q?QUo5SHqS/aXaU6Un+9BMiH+imp1NkIF155wPZ/+WAj9r+DeGQNs0r0Y91eH/?=
 =?us-ascii?Q?RCel5swgAu5SIv0vgeSMg5HYzNAqACPI9bWuWuHKDUiM9p8wu+4NZ0z9T3s6?=
 =?us-ascii?Q?Q/xLTjoeau1C3EBWty8Q2EMYmHwIKRDy684Y8iJEe8Rc36JVwErzUHPyhjRe?=
 =?us-ascii?Q?WRexxyrFV/GhrZPxzc8BYJHNQI4naYmLqBLcZFt5xb2/VMcZZiVOajmxTg/q?=
 =?us-ascii?Q?hAU7EwNQSgOGjaDs1q5sdhgHLx5O0MfYmKUPJcCBKveW6y7588G6Zf+6OSGH?=
 =?us-ascii?Q?vl6R88sI1cy1G7NJ8hQaA2qH8Dpg4YKRxCOdYb1gjJ7nv//S/6DfGmsVyD+f?=
 =?us-ascii?Q?bzseaCmKnP41hKNLRDIPGAEnjXWKzUgF4cM89hTpEvWA7+bj2w+ax2ImI5UC?=
 =?us-ascii?Q?arXCX9Q2bjLKkFt6tIaE9YQLIovQtm0qlVTPzHL5cmyZT0MYMROhPZOkicTR?=
 =?us-ascii?Q?/FufvXdkWnrp8Z+rRkOWzGEotNz6f04KEt0I+P1TOHxbbDbSmEZ0Vo4ZeXH5?=
 =?us-ascii?Q?k0xsIlmSdWXOP6cJxp7ym9XSavXy5hwj2rcSC6rokikRM6ryRncWarrKr/Ua?=
 =?us-ascii?Q?HcK9mohAn0ferbzPcKSmc1awg2D0c4/MuhtK5yte8ZiW1ijt1QVVC1xd7nxJ?=
 =?us-ascii?Q?TCyl50MyJtjbQMy3yBWRiRSrYrcwotPWsrDwdUXT+ooJ7gAfXkoSQbCetcuz?=
 =?us-ascii?Q?FmZE7az3qn+2xXUyt3bikHU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e1b277-ffd3-4b79-99e6-08db0ff2ea20
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:38.9908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5CX7C2kuTcwRJ7sChFFRTmPDhqJpO9fBLCXJ/AZQH0C+RbPv6hAUWlAF/TpUlaM1oIX922a3Hh5ObPcN8aklpFq3rDJ9fo/VPaYs0OmqbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot chips have an internal PLL that must be used when communicating
through external phys. Expose the init routine, so it can be used by other
drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c         | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 30 ---------------------
 include/soc/mscc/ocelot.h                  |  2 ++
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 08acb7b89086..9b8403e29445 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <linux/iopoll.h>
+#include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
@@ -211,6 +212,36 @@ static void ocelot_mact_init(struct ocelot *ocelot)
 	ocelot_write(ocelot, MACACCESS_CMD_INIT, ANA_TABLES_MACACCESS);
 }
 
+void ocelot_pll5_init(struct ocelot *ocelot)
+{
+	/* Configure PLL5. This will need a proper CCF driver
+	 * The values are coming from the VTSS API for Ocelot
+	 */
+	regmap_write(ocelot->targets[HSIO], HSIO_PLL5G_CFG4,
+		     HSIO_PLL5G_CFG4_IB_CTRL(0x7600) |
+		     HSIO_PLL5G_CFG4_IB_BIAS_CTRL(0x8));
+	regmap_write(ocelot->targets[HSIO], HSIO_PLL5G_CFG0,
+		     HSIO_PLL5G_CFG0_CORE_CLK_DIV(0x11) |
+		     HSIO_PLL5G_CFG0_CPU_CLK_DIV(2) |
+		     HSIO_PLL5G_CFG0_ENA_BIAS |
+		     HSIO_PLL5G_CFG0_ENA_VCO_BUF |
+		     HSIO_PLL5G_CFG0_ENA_CP1 |
+		     HSIO_PLL5G_CFG0_SELCPI(2) |
+		     HSIO_PLL5G_CFG0_LOOP_BW_RES(0xe) |
+		     HSIO_PLL5G_CFG0_SELBGV820(4) |
+		     HSIO_PLL5G_CFG0_DIV4 |
+		     HSIO_PLL5G_CFG0_ENA_CLKTREE |
+		     HSIO_PLL5G_CFG0_ENA_LANE);
+	regmap_write(ocelot->targets[HSIO], HSIO_PLL5G_CFG2,
+		     HSIO_PLL5G_CFG2_EN_RESET_FRQ_DET |
+		     HSIO_PLL5G_CFG2_EN_RESET_OVERRUN |
+		     HSIO_PLL5G_CFG2_GAIN_TEST(0x8) |
+		     HSIO_PLL5G_CFG2_ENA_AMPCTRL |
+		     HSIO_PLL5G_CFG2_PWD_AMPCTRL_N |
+		     HSIO_PLL5G_CFG2_AMPC_SEL(0x10));
+}
+EXPORT_SYMBOL(ocelot_pll5_init);
+
 static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 {
 	ocelot_write_gix(ocelot, ANA_PORT_VCAP_S2_CFG_S2_ENA |
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 7388c3b0535c..97e90e2869d4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,7 +18,6 @@
 
 #include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
-#include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot_fdma.h"
 #include "ocelot.h"
@@ -26,35 +25,6 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
-static void ocelot_pll5_init(struct ocelot *ocelot)
-{
-	/* Configure PLL5. This will need a proper CCF driver
-	 * The values are coming from the VTSS API for Ocelot
-	 */
-	regmap_write(ocelot->targets[HSIO], HSIO_PLL5G_CFG4,
-		     HSIO_PLL5G_CFG4_IB_CTRL(0x7600) |
-		     HSIO_PLL5G_CFG4_IB_BIAS_CTRL(0x8));
-	regmap_write(ocelot->targets[HSIO], HSIO_PLL5G_CFG0,
-		     HSIO_PLL5G_CFG0_CORE_CLK_DIV(0x11) |
-		     HSIO_PLL5G_CFG0_CPU_CLK_DIV(2) |
-		     HSIO_PLL5G_CFG0_ENA_BIAS |
-		     HSIO_PLL5G_CFG0_ENA_VCO_BUF |
-		     HSIO_PLL5G_CFG0_ENA_CP1 |
-		     HSIO_PLL5G_CFG0_SELCPI(2) |
-		     HSIO_PLL5G_CFG0_LOOP_BW_RES(0xe) |
-		     HSIO_PLL5G_CFG0_SELBGV820(4) |
-		     HSIO_PLL5G_CFG0_DIV4 |
-		     HSIO_PLL5G_CFG0_ENA_CLKTREE |
-		     HSIO_PLL5G_CFG0_ENA_LANE);
-	regmap_write(ocelot->targets[HSIO], HSIO_PLL5G_CFG2,
-		     HSIO_PLL5G_CFG2_EN_RESET_FRQ_DET |
-		     HSIO_PLL5G_CFG2_EN_RESET_OVERRUN |
-		     HSIO_PLL5G_CFG2_GAIN_TEST(0x8) |
-		     HSIO_PLL5G_CFG2_ENA_AMPCTRL |
-		     HSIO_PLL5G_CFG2_PWD_AMPCTRL_N |
-		     HSIO_PLL5G_CFG2_AMPC_SEL(0x10));
-}
-
 static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 {
 	int ret;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2080879e4134..751d9b250615 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1183,4 +1183,6 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+void ocelot_pll5_init(struct ocelot *ocelot);
+
 #endif
-- 
2.25.1

