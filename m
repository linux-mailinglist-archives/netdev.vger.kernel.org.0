Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033A739ECE3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFHDSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:18:05 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:29766
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231283AbhFHDSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:18:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxJkXzHoYC4qpH9nN7MCfMiqubJI1uDBLtOmx/fAdEo/D1EE33lcg9Q4JfJi9hR0zKtbvRi8aLqDHEao9tJyxY16xCKZjYTkTfRq6KE1IWrMjfzFwmJAUg1fMK4PE28blmD7YLbf3H3xLhlYXgfRGm9x4XCGFeai5wBZ+n0pjfvphtLGG6B1YhcLcXAHvVBvzQAigPhOKI/wAfTF4kyvcLumu3PNZ/uCcNV6DDI4mOOGEozoLCAevKa/kI+AR32gPmgpVSYruCvPJGr7y3C5D9d39jAtFHtRY8kl6T5qMAeGL6VHNDbnhLKKEmC7aZkOVJmhm7sHnzab6KwNeQrxGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQD6uwjhDZwgtIf8ViKL5Xn5IM2rv51pT4Rx55UiOvU=;
 b=gFek4c0P0F8Zg+lpHcxHvsxHjPht1wy0DpG28+nbOHuDDWLbrEIhumk0L6gpf/m0ormGjcBLjTC8ZuDnL/evapme+Gx+beScRf83U4IZhrZqdCFU2fIBJnubfvkL+XVR1oG706ShGLX9aGS9ue1VpbEQfoAnXw3HpyARvuAOEs8SGHPAlpleoUlCNvnZad00VEsgZvK5e7ucTwyv0wEX9W7G1zgY5r/nHnEWwbjMCM4R6o7NfZgARhfxFAXI5d+zRsy4M4gAqh2v2L3Y8jJMlqtbNOMIPod8glCUpbtHEcRq9ndeHQ9FU7eLcro1KbJ15F+g61NDSLpC6ccqXxgBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQD6uwjhDZwgtIf8ViKL5Xn5IM2rv51pT4Rx55UiOvU=;
 b=QTZ8EmhzlX0RUPhdSg6orwd1EVCGkjzbtWSqaum+ef+OO03IhT54Np1tpIJxClwJYUblBsDHWZ/DMXrPtGRzRmIphUe2hZgMPbJX93nlFVx1HB0NUHOFqdQtmUwe+8QzLS8Xo4ks3fnnRqblKAekLR98l7HlX8/M2JX24A4qkB0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:16:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:16:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 net-next 2/4] net: phy: realtek: add dt property to disable CLKOUT clock
Date:   Tue,  8 Jun 2021 11:15:33 +0800
Message-Id: <20210608031535.3651-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24 via Frontend Transport; Tue, 8 Jun 2021 03:16:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a53d8600-13d1-4ec5-8e57-08d92a2bc1eb
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB61398B2B8B563CF7C753913EE6379@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fba4BY67o4kgUEjzgcNZlNDDTAoRKB+MMmn2li4MDtojtfU3vVszmh0MVtysXK9ozFGKEo9nBbUedUGo4c2RpP6ovrl7c+8PXhde+cDbJ4MFu9IbCP4TqzNPoobQMQk925tF+V2Ay3oqwU1njJ6fNrQL4K5diK/Lanw+DYQwOj8MBWDYJhc0GgnvpbKUgXqTBYzO32nVs16RBvYMYRGcRCJ+pwbk0DN8j4F6OWUqDHv9cK/dwAdMw5jOKor6NnTOJw/UWRah5TUlicEE2OifYsAwYIdfCeA6rb/V1b+p9xNRvu8s29tNMehvYUrdZbC9fFAf45smhlgkQpB2fp4C3HOjVbftpWvzHJGj5cJanCweoiCaZzHMjT1FhSljUe14MeKwkNV0qO2uodWiO/lofRSQ/r7eWtWLf2H/RnEHIeYiOfwVnao/4CLADUD0igKWxXFkYvnrlyxoiyfhOg+lvqSvnTlIomigZtBmkUWim6iFY/0y6y5CM6Y5d9fUj8vsuOfsaCE3B6Io2OSjGVetItB0t0+P88q1/rfdUBmITUj7SFo92zsANAPK9dYMbbzLB8Nt3JY5lotVpI22vCLtkGO6yu8eaiGrytkw2nCEr3qsl4BXHi16p3/yPD9gbdMu67xBzPz69lCFHwPw+6A+Kebc9Qfj0UeAs5wHQO/aSVOGpxHUNgZa4issXsaImJux
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(66476007)(66556008)(8676002)(5660300002)(66946007)(38100700002)(83380400001)(38350700002)(36756003)(6666004)(1076003)(8936002)(6506007)(6512007)(86362001)(52116002)(16526019)(6486002)(26005)(7416002)(186003)(956004)(4326008)(2906002)(478600001)(316002)(2616005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Sxzkbp8OY9Lhb3RHIMj7WjJrZk+HPulQRFOYSYhS4QU5pGHVcy64voha5DIC?=
 =?us-ascii?Q?88wUTwL6ijHd2lpi8cJEJkcXEutRmsCEsIdEZjWCc5w7bKbDtjCXWn2crMfU?=
 =?us-ascii?Q?dEu6ARppKNHaR6SEDQ5+T+FjjJmCrBMDZA1cmexvPvgWt1YuuPrSdCIQyfSK?=
 =?us-ascii?Q?5g8E+cNi806e9GROMvy7HNPBNnJQ1hIWUVdINiFB3A9+UeMb4oojiRVN8kaq?=
 =?us-ascii?Q?Yeq4K8vVoCzw1nDh5J6WFMOqjQoTVlJmFXLe2NZ/prMm0GEfJw9llPiggynQ?=
 =?us-ascii?Q?YPEZ5n+G1sGSn6K0KJZvEDujoxEnhP1tBahSQKqYZ0vEqkpt7mUmGUu878fh?=
 =?us-ascii?Q?gqZ6afQaKdHk5BJMVya0N0p22RTIfAnohFocOtPFQM0MWE5gD3wuk7XBfkW9?=
 =?us-ascii?Q?oGZLus66TZJQt6ssKkt5Ecq4RSYbMr19fhfzay0bPRvSytT3W/yUJX7CzviH?=
 =?us-ascii?Q?rzEV1TS0MQIwQ0pMAN1+TZbOZtu1L57hMl5B1+/F2qNWIrjL2aTOF7jpe7XO?=
 =?us-ascii?Q?kzm+cUkJRPuy2nXhLPgMj/Gs74aGKlTw925k2oOh396RJVvBwXlIPOxWst7t?=
 =?us-ascii?Q?iZuokZhByQK0f/pp5F8dmdhdR5NnWnQ/Bmyy++ak5LQJa9J99aGfpCj68hgP?=
 =?us-ascii?Q?2V+BepW5I6+1klhsrHjg3JTPJ5hoIvDCyLi65MrEkFtueWP1XOhn3X2LAbJ9?=
 =?us-ascii?Q?mNCjDI5LSlnsBVHo5+E+RyfSeB33kH8RR7cT0dcTmxSsC9nRy5bCQqr4UxyD?=
 =?us-ascii?Q?CpxA55lFmpWCj/IHP+E08EAx68IRxA9ZA6ec3W/OF2rI5NMxFThBgVV2rEZX?=
 =?us-ascii?Q?O3sgDhUhfStm5pspRpCEen8GtDBmCerVdbj6Il+lEX2dlwi9YdRXeaOIc647?=
 =?us-ascii?Q?dmrmt5PE16OVsSG8y8CBWnJGekqnfX1O2Y0jxuDejYP8MvrkcPq+xw1VLlQR?=
 =?us-ascii?Q?Y/3BqKHWJguW8I/PnIF+2RVHbl5YWe6F3U2E/8MOfTuJqC/OGlFamxU3iuGN?=
 =?us-ascii?Q?RdyZ0dnQiN0TaNFm0LxFThH2zUJyt3MNvjX32F3Hv6YkaJVPwBSAG50zyTld?=
 =?us-ascii?Q?HtQadMvgZr26JRAbSAf/t4+HsonwO5FSI9vRxKVJcSsJBUg3vVk9idaF6ZDf?=
 =?us-ascii?Q?1iMoXRFqQV2szPy0z0C/EIRV9b3rGya3GKEMQ6ronw4HcFEImoJfqQYLPxP9?=
 =?us-ascii?Q?yKl7Yi/CTip/45yIjptrnhTQ09U2VZzXPCXm6cicysfXPQZ8UfN/a0OA3uNt?=
 =?us-ascii?Q?0wJ60DCVYyKoIfpkHXXhMBHejz22nmSMATOCeYa+RCxR1ys7fyEfseugo7S2?=
 =?us-ascii?Q?iDrEKlgvPWYPAOpuDEj7xLPk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a53d8600-13d1-4ec5-8e57-08d92a2bc1eb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:16:07.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgmaJs1HAKaLDYRTBRuyjedQq3+svqYeDQSArxYmj0UbYLMVFOxSzjfkn2vg1rqYruDoZWfQH27GVmysWvDuWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CLKOUT is enabled by default after PHY hardware reset, this patch adds
"realtek,clkout-disable" property for user to disable CLKOUT clock
to save PHY power.

Per RTL8211F guide, a PHY reset should be issued after setting these
bits in PHYCR2 register. After this patch, CLKOUT clock output to be
disabled.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 42 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 821e85a97367..ca258f2a9613 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -27,6 +28,7 @@
 #define RTL821x_PAGE_SELECT			0x1f
 
 #define RTL8211F_PHYCR1				0x18
+#define RTL8211F_PHYCR2				0x19
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -40,6 +42,8 @@
 #define RTL8211E_TX_DELAY			BIT(12)
 #define RTL8211E_RX_DELAY			BIT(11)
 
+#define RTL8211F_CLKOUT_EN			BIT(0)
+
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_ISR_ANERR			BIT(15)
 #define RTL8201F_ISR_DUPLEX			BIT(13)
@@ -71,6 +75,10 @@ MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
 
+struct rtl821x_priv {
+	u16 phycr2;
+};
+
 static int rtl821x_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, RTL821x_PAGE_SELECT);
@@ -81,6 +89,28 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+static int rtl821x_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct rtl821x_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->phycr2 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
+	if (priv->phycr2 < 0)
+		return priv->phycr2;
+
+	priv->phycr2 &= RTL8211F_CLKOUT_EN;
+	if (of_property_read_bool(dev->of_node, "realtek,clkout-disable"))
+		priv->phycr2 &= ~RTL8211F_CLKOUT_EN;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -291,6 +321,7 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
+	struct rtl821x_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
 	u16 val;
@@ -354,7 +385,15 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			val_rxdly ? "enabled" : "disabled");
 	}
 
-	return 0;
+	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+			       RTL8211F_CLKOUT_EN, priv->phycr2);
+	if (ret < 0) {
+		dev_err(dev, "clkout configuration failed: %pe\n",
+			ERR_PTR(ret));
+		return ret;
+	}
+
+	return genphy_soft_reset(phydev);
 }
 
 static int rtl8211e_config_init(struct phy_device *phydev)
@@ -847,6 +886,7 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc916),
 		.name		= "RTL8211F Gigabit Ethernet",
+		.probe		= rtl821x_probe,
 		.config_init	= &rtl8211f_config_init,
 		.read_status	= rtlgen_read_status,
 		.config_intr	= &rtl8211f_config_intr,
-- 
2.17.1

