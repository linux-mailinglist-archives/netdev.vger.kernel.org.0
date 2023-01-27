Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3050067EE3E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjA0Tg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjA0Tgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66CA80151;
        Fri, 27 Jan 2023 11:36:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3gkT0DPvYouwmUTzVqmsQDzT2rIkvlA3hqbtT5aMmP0qZoReWwkO73Oyy9f9+r+gJAKsoO77fG9L7OJImttqWoK2SDH9/aIY1xZwMsIhpYEdlDeFSPJsSBnqkpsNmQhKW5PtJcWysNlbNoXFagXe6E4BY/YoBAJSAJlFJi0b2//4cE/2h48UZ+nVuD300TOV7ZtwILyBB67lXg4DKl53iUWVFJ0RX+ueiFWNSrl3Yh4LbFvaLRt5mHl8QsFwUn1CsmMN3MNMvR76AQzlAcg/LAPFILWJ6bWbzHoNyYf8hZBRXf7ctOECRMqrUcRCFZHkYzjHTZ/lS/CAIWmN3lTLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vGvhCW4A931dX/uJVIfNuklqP0RF3G8Gc+B9ahiDAc=;
 b=BjzkDwtwuK9MYaFpdYNlT7r15Yg4NHoa8L4IUBt2hLS635zKr78ADprK8CZagw3doFSE/cW4hes6h90/IaFUUtLEAFDLQR6maMubMxfaVZHGlAbvbx/28q2yJcsMjBLHKmcX7HU6low8u3JmmXWrSOTNec+JaWP3ymEte2IiKeFMFuMo0f/DHFbIqZC53Z0kKptToLgj4vX902UE2awgn590zfffmhQ0deuZr1K2nS70/kuX+zLWPFe0O7ETh2lw9KExsJtZmjE3yftwpbuvqW7DDK/+EMCvTWe3RIixqsjxkqxep2UBNd7diODpiaMd4CSAci0vQkbdr00KSn2M6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vGvhCW4A931dX/uJVIfNuklqP0RF3G8Gc+B9ahiDAc=;
 b=qOTKw2yYS4fxYaAXCHJbngN6za1Q0U0KIEd6IiiUqtEQ5VandFTK6J+9y2F6VxLYwogddiADxn/HUVF8eD7jSrXoPSkZCbX546l5SVW2DwVdPIySNPFwKAF5+/z9qq9NU3/XkXQvMPlHeSP6iX3hwCzaQWqpRsrkhakGgghrpRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:18 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:18 +0000
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
Subject: [PATCH v5 net-next 04/13] net: mscc: ocelot: expose ocelot_reset routine
Date:   Fri, 27 Jan 2023 11:35:50 -0800
Message-Id: <20230127193559.1001051-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8b2cd2ca-6be0-456e-fc5f-08db009dc284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSNmA0dH//7+az+WHZCf6Kc6+ZEEVa+73a+Jeh8C3D44ZVvXnBXn1+V8JrIu9MofpsVa4h6gWd+mIwhmk6EyrfAGSSneQxTkfP+xS4BkcHsxB6HZzutTwQX93+nS7GlyFPx9gZcn85x4We9e3TO2jv9TSyGYYQF9NZIns2cp6F3z3tBB4uDgvfS4yheX1v/YtT244gBdhTf7I9SAIPKeD5MTwo7lJDc+VACzVN4Snn42HQmCxNe0AapeWWe7l0BWM7TPcl2/dNbH3CBPzsJ8+2sQW6j6r4StX4d4LSU5tm4KpkH5WKb3RGJhhO4I3H4TE6brB3HwLqHDZYzDKYHLJdiFJ0efPQGkarC1LsSKrZMNP//n17dBy7PIq6TsB9HDwkY98rOpmX4zJqhS2D/6wrofs/rNrtLyktVHv+1iU+TbIOvKGzzVTdMNFLVtrUNrLRM48LaDrlh+sIvD1azbAt+GDUG7wdDP1xqtaSOxSe1b4hXzcoeLXOJjQOc6pRrvBqRmiX6gOs54XSeUFPNDtPzjPHuXtUW74wYFHf78mJltkvhewjhKIu91+ulGn30nz+4JsCIZnEXojEPhMeJ2jTT2Sdl4G5snH0NbXKBuU+Ijg7ltH+OUUzPfo68Kja9k6QkkargxY801l2jKurP2i+b2H3gIfkqsyz7G08VMo06YOhu0p5nPAxm9jMWP2Dh74GFa7v+78xoC0hHSZeHeIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Olb6F3O+BSvATyshj+z38pSn2/0C+cFW9SM1D6fNTLSi0Qv24KcD7kodi/xc?=
 =?us-ascii?Q?QrMXTZ9rMuDUkZ4Pk940zzy39H28xYGjbYcutwCUDSclL2hPmL2V6ES7sbnJ?=
 =?us-ascii?Q?UtGX8hF7f9d6aRMd444uR0/g68e6DcdpjX0LSjwsVqKxtFCJEnmKMRN+19Bk?=
 =?us-ascii?Q?AFI+PCUNWJJPKP+eJN25A3+XSrmg7YD2m3PIdexYAwdrZF9jCzUp+7EST2/9?=
 =?us-ascii?Q?KEAiStiNrEAiNad3JEZnQbtA1pbM67UtBkN/85l4uLRjnI0BFoqMImhw0ph/?=
 =?us-ascii?Q?xDo5gmej81WsPQREbHR7hAtM+LukE8+P2O2LMT8BDIiw1Vg+6VmcXzk2xVv8?=
 =?us-ascii?Q?sTHvsq7T50DDm9hmnXm+S/WvmC2xQMaGe9c+97DahsvX19gKyUYSrl6yFeYc?=
 =?us-ascii?Q?JelY8dLauVdvWlXg6uxwcqXeA8MkbFrft3MnpbVaNLet/WuBcCmvVIU4qvRx?=
 =?us-ascii?Q?RO0cDvboc8AALvrH4zIUxHd+OVCaFGAYKt9rVleL5e9NIv6rrvETkXzJAkpe?=
 =?us-ascii?Q?fuS0BjTvWkxK2C0dhIL5clGmHN8iqzG4GcfZpJvywSOIaazSUVoL8UXwajtL?=
 =?us-ascii?Q?d5ORE3FUUk58MsDxA1C1dXoHuxR40187RDP/VQXs3xYwvotmD7lJPMI4I5Ap?=
 =?us-ascii?Q?GxSUf62+OeYJxkirpl8DBtdCLv6R4+0gqWosb/2WMwg17v7GCyvM5SWqLC/G?=
 =?us-ascii?Q?FyjYkAHanqTj43kFFFWUdsoTtaphKupUKm0YGfbEXgYQvvRlsyOojH8i45lG?=
 =?us-ascii?Q?m4bwfOuubqLFLeASxg5UQ5lGBGMXmlVY/m0CDsBqNiYFjKZ32rZSBrEYuVco?=
 =?us-ascii?Q?CDEl4PXMtk0zWKoCv+MRP9tn8dGOFubdJLn8maD/Wa1qG88m78GT8wLdZgP2?=
 =?us-ascii?Q?jJM6oN5Pt5NZDpUMNB2USBWDATm3rZTL8hmEbex+0TB5Lx4jEPfDHhtWPc72?=
 =?us-ascii?Q?nYDQeD322lvgzXHipfLEBlcG9BG/tnXOZ6xXPFR/YP1XLLumbKSG0I+0xw+7?=
 =?us-ascii?Q?p14FQM6+Jbq3ig0Y4BsL7tVOQdQjf2e4CTAjrA8kkpiVoSXpE6CJ1jHArDL0?=
 =?us-ascii?Q?OD//i0P/Jil3JCeW0QIf2bhCcnm/Q7PyB9uB/akYoF8A4tDw0e7lnrW5WamM?=
 =?us-ascii?Q?0vE5rdFQfh/B6ANoYq8equfRHEx1MBObkivu+BXa03Dy+tAlUlnx7H4yiKe3?=
 =?us-ascii?Q?MA0P+VunIY1C4jk+/PyWN2YGCzRsq+00ub02nKpPk9uzCdzHjj9EQm1Ssazo?=
 =?us-ascii?Q?pK5CPmqv2q72S1lYkpvQxGBJr+HvAbx8Ja7ASE4IV+XA4BxFFPUMImsTPdca?=
 =?us-ascii?Q?AmoSp/MVsvNahlL7i7NkxI61ejI+03An/N8YSPJDWQU49EXhAMcMrk+jrGT9?=
 =?us-ascii?Q?06UKtud45/rtHE7aRAGd6t6HUW8I2P4FiqMAWVzVdhAH+ySp1O2/z4jZEUSc?=
 =?us-ascii?Q?66SRiWyfFofAkLCGTyoQ/7AjjDS1IsllRPf+7FQKQljImcKljTw3eaTmmYQJ?=
 =?us-ascii?Q?Ty4+usMwNx2hgJ5bDmdWq1rW1swPArAYh/ik1gWKiI2TMwSxyuvXM3FdVkFj?=
 =?us-ascii?Q?MlP1j4QxRmgJJjT7xgO4Lo9wi0LuBozqgL5tQzs15OjZRs+C7Dq+Ts6In7BF?=
 =?us-ascii?Q?Ww5ed20LNIMACiPXm+ATAB4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2cd2ca-6be0-456e-fc5f-08db009dc284
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:17.9073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6IMZrU+r9uBADvA+DDi5Sui45mPcg27UEQa8Lc22Ovp27PBNzMvZMbzphETrA+JXLhub0uKyVpcObaZe1V7tZTDr5lugVyKgymcbxlq7ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resetting the switch core is the same whether it is done internally or
externally. Move this routine to the ocelot library so it can be used by
other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3-v5
    * No changes

v2
    * New patch

---
 drivers/net/ethernet/mscc/ocelot.c         | 48 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 44 +-------------------
 include/soc/mscc/ocelot.h                  |  1 +
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c060b03f7e27..08acb7b89086 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -6,12 +6,16 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
+#include <linux/iopoll.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
-#define TABLE_UPDATE_SLEEP_US 10
-#define TABLE_UPDATE_TIMEOUT_US 100000
+#define TABLE_UPDATE_SLEEP_US	10
+#define TABLE_UPDATE_TIMEOUT_US	100000
+#define MEM_INIT_SLEEP_US	1000
+#define MEM_INIT_TIMEOUT_US	100000
+
 #define OCELOT_RSV_VLAN_RANGE_START 4000
 
 struct ocelot_mact_entry {
@@ -2713,6 +2717,46 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 	ocelot->num_frame_refs = QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(eq_ctrl);
 }
 
+static int ocelot_mem_init_status(struct ocelot *ocelot)
+{
+	unsigned int val;
+	int err;
+
+	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				&val);
+
+	return err ?: val;
+}
+
+int ocelot_reset(struct ocelot *ocelot)
+{
+	int err;
+	u32 val;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
+	 * 100us) before enabling the switch core.
+	 */
+	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
+				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+}
+EXPORT_SYMBOL(ocelot_reset);
+
 int ocelot_init(struct ocelot *ocelot)
 {
 	int i, ret;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 381d099f41b1..1e94108ab8bc 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -6,7 +6,6 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/interrupt.h>
-#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/netdevice.h>
@@ -17,6 +16,7 @@
 #include <linux/skbuff.h>
 #include <net/switchdev.h>
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/vsc7514_regs.h>
@@ -26,9 +26,6 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
-#define MEM_INIT_SLEEP_US				1000
-#define MEM_INIT_TIMEOUT_US				100000
-
 static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
 	[QS] = vsc7514_qs_regmap,
@@ -132,45 +129,6 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
-static int ocelot_mem_init_status(struct ocelot *ocelot)
-{
-	unsigned int val;
-	int err;
-
-	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
-				&val);
-
-	return err ?: val;
-}
-
-static int ocelot_reset(struct ocelot *ocelot)
-{
-	int err;
-	u32 val;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
-	if (err)
-		return err;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	if (err)
-		return err;
-
-	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
-	 * 100us) before enabling the switch core.
-	 */
-	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
-				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
-	if (err)
-		return err;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	if (err)
-		return err;
-
-	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0edb16b6087f..2080879e4134 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -967,6 +967,7 @@ void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
 struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
+int ocelot_reset(struct ocelot *ocelot);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
-- 
2.25.1

