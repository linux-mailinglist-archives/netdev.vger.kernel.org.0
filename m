Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02639EC94
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhFHDDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:03:32 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:52448
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231322AbhFHDDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hu3jKKIsW9N/x1GUophz53o1DZobIw7l04Ga2YMG3V+BYGaWKapTqUhAhyKpHzXlV2c/0RSCiVM8/dFTJYPyK6dl9aP4eel+S3QHM5YqxcNSFnXGiwWhUDRmkrELOFJG2T/ELfPzZ3/XqRP0fQfLSCrqIkIfO44VAu2D0/7j6Jw2ctjFD9utJqeVHPdwD9lOGXkE5IYTcKK5YEpfnebkD8aqrHrlPQ0+tABHmjHHQ552hiI1ng5VRENrCZ9y7+kqIXUeFqp/cMhnEaI8w/CibfuwITrXtiB4AR46AGLjunWtddnJMtQtIKI1rqEdg5Fc/bxZp+gudkg0Eale4h0oJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQD6uwjhDZwgtIf8ViKL5Xn5IM2rv51pT4Rx55UiOvU=;
 b=a2FuStf5Y8bbsA5ZvtFzBiv6i2ILa65fVu+12NnT1AAtbg7IAfg1KvpjwFAn5WHlrU3+esJbptO6OietQgVjKYmBnGIyffCgHPRk46ikrHLKmtHUYIQCx+Gp8vM8zqWwoQhsRM1Ak76X/7SKbPEgrv9pdGJLhh2KHVIbHdtMx4dbFzVAHtPpj6CtblZY9Lt11U+1rCZuxJpbMY8eNlDhjPguVjBGmPWvXq3G8QxSefInk3hvIWD/7eIiN29KkhozRmUNB5H109Z5SaMBf/4p/kCMxKyxWPb6AHcaUZqRJYruGgD68G5+aZrnFL6kzY7c4LwLhKkeTxsFivbF3cT94w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQD6uwjhDZwgtIf8ViKL5Xn5IM2rv51pT4Rx55UiOvU=;
 b=XhOBYfenilIrIkvtjr0DRQSpn7gRZRWhdQEW7QHVnfJcqkThZy0UwrFrJRSpLxd2AVqwNAIZZdmWe2GqXgeWrKtFCLfKbbqRlt3Q6uWJYz229b3bFU2DXMz9Dek0MhPXarte8EEkZh9RNb4NBNTXtmVZsJn70GLLbuR/XBb5mKE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Tue, 8 Jun
 2021 03:01:36 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:01:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 2/4] net: phy: realtek: add dt property to disable CLKOUT clock
Date:   Tue,  8 Jun 2021 11:00:32 +0800
Message-Id: <20210608030034.3113-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
References: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0151.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:01:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9c4deff-ab08-4cef-7d49-08d92a29ba6b
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB29043C8EBDE761FD76642265E6379@DB6PR0402MB2904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qqkuj6ticOXQ9UqcXNre5WHAWY1n9NwfYzFHytqHwlpshamvQ4vNJg8RRf22IqlvIgcO0UzwjInmWJ77n+HXQ+vvwyXPFfXxoeEMjtg0a9XaP7PFS017/2JeJhzURKv6NXoCQjoGcW0tHEH0sVTnQDbDjF+MvuF/TmGKSmuT+tA7bscKq+hvpLHN9l42D2Q8so4Vzii2UTshAMmfQeoevKVC8pYi4JjE94RaFtcOdDD1WY/Uc4Sjif+4YLTlR806eMFd6oH9dqoRHiwpt7rtJRHoJwnZ440qEuTzxVINhcMOqU+4MKXWDV58wKQyJXWjZtRe3hj+wxirDU1ZWrowh0zuuii+ZQmHAzZBFCIKDtKA9yK8Yioz5bkf8fppnVelzyuJSyxvz5/TjFM+7mKH7Xgq/jfxJ5Ktlzrhani7SfWkSYHswhNJ0HuHJLq8QqylAJWWF7Qt7xYOVahyBKE1rSVuHSxBj3pNGMS6VA1cpH/LRRS6dgt2PwLSBfLlQA/j7VHTaPBmOGlkvTtFqQP17Xt6TZd2MlYyeBVLjntOdk5pr2dHCbH4+WvsQ0O+O/o/SJM15VnDOXIrRm4zIIDwddAXbHXwbCo4EL7SHqjA4+8FjrNLS3EMdVh2P29gpwdkbYYbHzlFMu54Kr+164/QSihS39Qrcvi1BvjvNxN/5ISzSWvOPZEZ53P8zC8YYcD0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(83380400001)(38350700002)(86362001)(7416002)(6486002)(52116002)(16526019)(6512007)(6506007)(38100700002)(4326008)(2906002)(66476007)(66556008)(8936002)(956004)(316002)(66946007)(5660300002)(8676002)(186003)(26005)(2616005)(1076003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kAhPZejmQbNj7sFREgFfz2YEp6phOcN7YoPYO1LB1D2+P1ZBCXn7j2uFh3aM?=
 =?us-ascii?Q?MkIyuj1VKH6giPgwuXXRvfHgRWQLGUKIO95JO/lW8+axgw8gUdHiD/GmSklp?=
 =?us-ascii?Q?QPN8IStJ21iLwWMZUPTJnm0D+WxmYbZeaFSMU4pi3ENL6axn7NSTkFb66F2/?=
 =?us-ascii?Q?FtmkM/mrH9p+g3bIye0I2O/O+61+Oq2Lou9TPs6AL9VQ4SG4vsj7o/MU7mKq?=
 =?us-ascii?Q?e9KhlARoqhYIrvgXpcnGNg7xDUPwNbagu+vgD1xie1OMeYDrKLsWDXbrAs5R?=
 =?us-ascii?Q?4lagqDFFQL/J9kFn40div7OUGT1sN/K1UcU0jP035Jp3qUQIjiab4iKp4aq9?=
 =?us-ascii?Q?uor++BBubTSzn7FUtfyJWzyJEL5sPmh9t2lkkuwVXP03U0NyLFIBhPlnFVqS?=
 =?us-ascii?Q?HQZ2gd6XTWM4v8XarUVHdXE38MtU+nQSkBMlKjI3fx4pOtFS87CkDqI7Yovz?=
 =?us-ascii?Q?OpaFBVdgITw2ez0JjJmFqIfW1wOTe0m/X+R24WPhe4HE6kteVSY4ZMQBD3Uz?=
 =?us-ascii?Q?rAw4qEoJtfW/sj+jzXZlk+DCmPdiNo+3M4wMLgeZdq0RugnCoXTd/qWMR1en?=
 =?us-ascii?Q?VbUzeIB4WxEdjhQkxsW0/2I1wrzI/oyjYtPFYTOeliG1JF2km0AQlYIWS2bK?=
 =?us-ascii?Q?JZt7A5Yh1ZDfo6tiorSMpkhtoskWXtV4Snx9PKNgZXJqI62VlZ64fjVT5Ayq?=
 =?us-ascii?Q?G05vA1EGsJpQpm9iJoHR0gQChTHJrEWw5H9xcmm/bZqLQkz3591J1PPh572A?=
 =?us-ascii?Q?dcK92KGqsjgx+aP3AcSY/ordel7Om1ME3Zpw2ccSs1JxTL/vnMcz+iPMJ6xV?=
 =?us-ascii?Q?K9iSGPRMSxB6b9fATy708IHNTomADEBLycCaJZsHQh8MLW9iVpiDfxfHELSO?=
 =?us-ascii?Q?v20IjTa/NMdOpnsDc5wfoCeDFNICc7X/XeoCP8ubUITnqeN7s9kD3/+WJylb?=
 =?us-ascii?Q?ceUoT7S+fYNiDEBScj9+aA1no9oDtjN8mWrs6LcPI8rrmTTQdkpkuJldOm+f?=
 =?us-ascii?Q?TnqA/p73My7erJ0yF3EAnfS3CqHzKaKifeUrP+QgCBGZ5AAsre2rR2WmnOFD?=
 =?us-ascii?Q?T82B2Pfe6khoSGecy/gO1oZ6atcD7unPRsB16K4WyPizJa8/5/6v4ugkZGC0?=
 =?us-ascii?Q?bGgOk9fBPIaDyVS9Y3OpqKxXNmhOYWhZ8uFmxAM7+Ud4PCWSdDRuuYkPFd/G?=
 =?us-ascii?Q?q+o+Gq3bQVsGZb1UIdoZv/mUhhgXzXsLPKnGk6apas/E2m4g+VScuIf9ilbD?=
 =?us-ascii?Q?5cyEfIPQlLbWpIlM+li30wQ7vX6Ch8bQbtRpXTXeK90UKsQ6oA12tKUSes/J?=
 =?us-ascii?Q?pkmWLZpFipSdVVNp5kAlQ0tR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c4deff-ab08-4cef-7d49-08d92a29ba6b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:01:36.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ap+XcG+VcdjNPC4Ek8odIo27fbVwzIb98u5Z0A/XcEZIvcO1QV/wi1H8d5PDkdZNwOjyMVbfnHIoZCbvJgEXaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
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

