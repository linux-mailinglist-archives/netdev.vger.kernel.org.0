Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371C86BF132
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCQSz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCQSzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:55:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16283CE14;
        Fri, 17 Mar 2023 11:54:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jok9LRFX+imZnyBgiR6YlJyAlLVPgzVBWsIWVmVa+b2bhbW0n5OsYTxW1fCtG/CpAU2cmf1HjwpwtKYcDsIzwTAMK/568ljOfc1s9X44ZRnREZwKIw7RH7h27NqDYi37FGhghMl5spu9qGsLFuJZeGwv9ytg2CeFusQqA9dsVSJhs1wuBp+7i2YAHU5HHic5xzmHchuRtvnkpzHvbi3V47PHzh6DVHIny+WIHjs+XfmggN3MVDtu/2pZQi7OciBOahiKy8fCZIuLOLcpF+qvH/L5DiAustVMPLsr7tzj5vvBi+nLg9su2auVnGf826wfay9qwfjMLrOOAoWAS/l3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKdPx6upBumRJjgzgp7KlHeXQjQnTGcwoz0pWCK/fpg=;
 b=IEPYcHGIGmGxsjdaUt0Udv4fonygoFeDtMKkxJqenxI27y/3U973ry2NYRD5lYJd8UzIcY0i1kv1PW1CRa+m3jQzM5CGQpk5Pr4WfSPXfNmU35Huu1MtU/BaQVWoPFGTcwqP1w4PD1tfeg1hbuWZC2NlRTSRPOh4HWz96VM265JjNmkOzAFUDes5hlYjPPC3/fCh+Mwku4gSlCvW+4Z7F25fQyIF60Wkv+JDzQOo6xBLhgw0DejBtvGXjCeQuQwHD40A8JtyfJQYEEgmwI86tzDrxXFOKk5Ch4cbL4uYzbQNyCbaoXxqwUnHePOafgoX8vjyeL54SNBI59/lD2kEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKdPx6upBumRJjgzgp7KlHeXQjQnTGcwoz0pWCK/fpg=;
 b=yRNIYnG2R57x5mik0gnjkk7lyoz7KJl0XvBpsuvGvgXF2bTfLC8TeTdOupPusWZtlO6zPOG1uqTZkf1gFdZIEbRKIr23XZ9a+WtKCwGJKLm6APKkzVNzZ88Hddla9y/X7Og1d1eYOKybtRUyiqkNKd0pdTPZfXqc1na1ztt5qLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN0PR10MB5959.namprd10.prod.outlook.com
 (2603:10b6:208:3cd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 18:54:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:32 +0000
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
Subject: [PATCH v2 net-next 3/9] net: mscc: ocelot: expose ocelot_pll5_init routine
Date:   Fri, 17 Mar 2023 11:54:09 -0700
Message-Id: <20230317185415.2000564-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN0PR10MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1bf46f-04ba-489e-6216-08db27190bb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPIGR7sGnv4hu8P7DX4E0Rizxj2zA8nMIYyOVdVC1W8I645IW20qSvu/yep6f8+YtQqJX3YcdAuxdkctRFJXe45O9wvI3f4YQ84vYd6R6DTbGWAgRhyd1A7D1Wfpag0K8IqZfIy93YSk7s6QSQWdmsCK3p0JHboh8bTB0dPTGDKn4msvH5DH8yoquouqo1iOKfnbRjlRb6kn+7HguUlJwKBkUwdG7lu+iuHSCl4kwxkrDOQBXc01fP2riSL3UGjJkx/F0LNhqCjgLHNm20ST8/pZVAdFtp0xhNlK1GT6m7fUl68KJkl/uvsuod+c0mWHyEq66zfBzgjaY86Qvt0LQQSg5vLT20t8CSwmqqoAwa+oitAe2M7YD021LyxUAUPcJRHdZwh+PWHpwmLqqJLblscvPdPwmgkV17/P7/8w/y/kv12JxsVZner5kd+l6dPf9IAQzzCilXI3cpZQdhUdTldEsAmsz6U34Ega/ligfhpoDlCWoemi0q0jnfUjzFRTjDbzQAiaVe4sxfSYq2X/6Mu6KJ+E4FRXxQ4a4LNuXD+s5Ef0zB8kVawyuruj2QleVQu8COSEEu4JqJRsMHYCD6rZ/yEPwXOMUS49E6vzo9okrrqslEqCF8/IdvCe2UCb68ZhkK6AvHFJ3WYmRfacRYqd+TuC4KhzR4HxSGaJtW8frrovo70PsLs53eucxaztxiqX/xJsKvAbCV/TFCc6Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39830400003)(136003)(366004)(451199018)(8676002)(86362001)(5660300002)(44832011)(7416002)(478600001)(66946007)(66556008)(2616005)(52116002)(186003)(38350700002)(6486002)(6666004)(2906002)(6512007)(1076003)(6506007)(26005)(36756003)(66476007)(38100700002)(316002)(41300700001)(54906003)(8936002)(83380400001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xIdDDfeuHyMQIH9BXjCrnAirGmjeErLZ8rv9h4WFDqhzDcbCs6NEqhF2xscF?=
 =?us-ascii?Q?l80SifhJ0FggGn9joKsJbXFL4fse0kUCRGi4pwFTYr3pGCBcE3SoXuONMsZB?=
 =?us-ascii?Q?5E4TLZwrWVWao7p/Ixl71VZ8QEw4Ks97Fktse/FI1CRKJ6NQg4Nziq2TwDze?=
 =?us-ascii?Q?eAApniCYg4PFNeo8Yu7yQP34xD5l7aK9sG1oymnS9TLTVfLXHDpfqXKp10Bk?=
 =?us-ascii?Q?syJVoP/f42JJSAB5QNu2dnAEmXA22Sgg5gOnC10fU5OPLDgyhfasUH1hDS9n?=
 =?us-ascii?Q?uDwSnS3O+HFiO/uqMNiADrFMGCdyOMDUQFbntwPv6cxmyCQaJ1Brzoyo7vbW?=
 =?us-ascii?Q?3eU4fSYILdEkSevnu9z6IIQX+94Kxb8y+OqORHgr8+nbwdN0fXYm9L2vDQtR?=
 =?us-ascii?Q?YuZ98HpMYfLkpuNU+KAilyHOv7g+enL442q5o5/ZzpHgGNA6y6zm/SVxKt6+?=
 =?us-ascii?Q?MeU87q4MD0ZwpFdYqXQaWi5QGmgX6qUL7MEz2rc0iDBqlLrQZg1+MOQIocSp?=
 =?us-ascii?Q?Em3pU5IOMiYpPZMtRaqT1zvsTBP+ykU0WYK2YlyHwUPYJwanlOJllAtBbHkQ?=
 =?us-ascii?Q?21hRfcrhQ4pbOUKpUbxp4f7eoCanE+nls79T36A94zbDuuU4ZmcAGjqe80L4?=
 =?us-ascii?Q?8vMKgDrv62FZ6e9/SOyCVOXmwXz0UPup0O8moil1tOoc5yHGAAMs7uATZB/r?=
 =?us-ascii?Q?eA0rwwTxhfn4Eh2GDEeWKOhQp1sHTQuNSZravPA+Ny7/zxF3P5M4NkcSy6sh?=
 =?us-ascii?Q?wJ5RwXq4NZpXZYyw4PGsaXTYCcXdhgPjXg6nNu7/58ZALVs6bEl3rLnfkvwN?=
 =?us-ascii?Q?EDOxf5GP+gsOTyIgVYfvN+AkMYgjWNFqM21UVcFKb6NaOM+Frg275jbDyF87?=
 =?us-ascii?Q?Pp6gndOKheWBFhnONMK9KgWg2kLpXkuUAcq4cmGTcIUyNGbhPmeFM+zoMSPe?=
 =?us-ascii?Q?q/5mdBaUqy8Q2mvuZ1PM1t3YtNv2+Z0xyd1oxUlNgM8nueS7T3UE5zpr31m2?=
 =?us-ascii?Q?q4H4PIuFFAY5cHo7cbzl74P23neDAZH630hfh3L5DXka1t+cEHq9MPPzummc?=
 =?us-ascii?Q?7R5PMIbmRDJxPDm7yw56ZCj8OrK/ICnRBHlpem44CgWvtILxqpVffKoH1WAG?=
 =?us-ascii?Q?VEb2tAwj2hWwfu9RIAEVrreiLn79ZunfACtXKGyADsvMRX0KBfJ5e+vCnGa8?=
 =?us-ascii?Q?gG+Wf0ESxs8aQQ11aKoCWJMTBvld12s+Jnd1MBNow02wNaX+oTV7c9IpxRK4?=
 =?us-ascii?Q?lVr6eAKSJIcGrK0tKd1D9roPqhcZyzRbHwg7eofBJhcyWFYJi+yQltBT3Z/D?=
 =?us-ascii?Q?XQMzTT/GZDAQuD/3Lk6TWO+jsnG+0CBsAFpOwI6FBON4/GwZzmRxNyLuD1R+?=
 =?us-ascii?Q?rUnjx71VcUZJCodnKtMP8aywGOGjOoVeLcPq3+LcjEp3zItLboa0++Ly3+YR?=
 =?us-ascii?Q?fQsUhhxCkborWQmTwWGW03Ocuxyg0u2A9TVkX8nGIlB0dnlSfQFt2I4C9/9Z?=
 =?us-ascii?Q?C4gzZunEXK+5MXqEBiRguP1vbR4TDwzt/oFUcbTM6x5ScwmrD9RGd4j75Dlu?=
 =?us-ascii?Q?0rmsfeAtccJipV437eviAs/HXM4Xq4hikFII+l8KW6U72h0ZB9EsmQy/ukNd?=
 =?us-ascii?Q?FgPeACAXRI2wfslr2HMm9Xs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1bf46f-04ba-489e-6216-08db27190bb4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:32.8968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gj6GtdgsWJHWuCw3i5zL9BwhG/a2IL/yK5UH/O7cx9R2X2Z4hTcxxlLFEq1tXnLMPAzlijZkDGO73AQLz5uQ9/yl4b6LFQUMKu5v7q3WAek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5959
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

v1 -> v2
    * No change

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

