Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99A4396FDD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhFAJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:06:42 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:53574
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233695AbhFAJGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:06:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSzE3UlrmUmeKCz75q+XSCJzwxOTsFbClPYESbA1J8NGzjn8YGCJvoqsqBY++P5/RW+A5UCuJwHGfcCpN7/ObtlZFvVv89CqPJEWTbKrh5tolT5SApuz/2RWc+RWRIvimAZ1Lk3+TA8N+UoklW8t2/U7GwwbSVLtjVBG5Si7rRywXOLXRAec47i+RfmVMFN1DaF/LNgqFGHdiK6Uip4+wytlN9PWH6TaO103SBX9Np3QxWCpTFege93MpUp6aNshq/Dd8+O4/oF+N/i8Sluuvbp+PkrqEOp3x2V2/mn+OGBECXUGaw/nVFc1MtvXcVJKtBfx3skvxI4yr6p1MDtmoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F7ufxJnJ8DPxvPb82YiFMpTAc6K7x2DaBemyF8ifug=;
 b=M2UqCRlpu9zc5PK23sv9SxVpwV7z/80FvWo+GLBgSS7s6ILGSv30FHaMJMoXqiuRLItNDdw56+a7Bu7SzltYDKLgWA9HeK6EPZ9c32UqyEgZL3JcDbxR/F6piIUgOzLE5XhjB44onmUwQghMestbgGcLvEMYzczcYV/K78H+U/robk5szv64kSgPu4nCHJ4qWcLKCZbebrYf729hICQpZQDwB1r942EJi6G2SXArlo/Bkppzw2TpQrBXUMq/V9dYy9+g0KJJyUcgRrptICRzWFzYwxnj1cafDqND9LEaTpOwBds67ct1ZxLlSdHwEmp2V5eQ6aYRhv6SB29uN6ncPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F7ufxJnJ8DPxvPb82YiFMpTAc6K7x2DaBemyF8ifug=;
 b=Ennbrenj9u4UoIpAtkBL8Qi4lnizbKHPe8utv10wvdArbD4fbbA87AAHQ+M+YuTqOhGAQL7mXwN2R4ankwVhphfUsyUJ0rr+BbHKsclpStJKvCCyOgEJCE/LHVxNVP6LD3GySdV+3TMPBpNnIg5dSnx/6ztG/1TZyB7P1SWfcgY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 09:04:54 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 09:04:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: phy: realtek: add delay to fix RXC generation issue
Date:   Tue,  1 Jun 2021 17:04:08 +0800
Message-Id: <20210601090408.22025-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 09:04:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a12a892-203b-4c32-55db-08d924dc526a
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6795DA108E14EBB6EB9A87C0E63E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9w+wA6tg+TNBjs6MlLs7idNOcARgWtKzYeWxsj3F8BmS26Km2h6Gjcw51dVC/NJEc7BX4XpkkD6uCcjzcLD5GifPHtmBJl+BlhETgF/mNiitQpFXZ2QwhTF/bANtdoRWRcfW9JheyyaBK/TVrdmXMHL3v+TTS8s3nB/BDLLAwGNyjuIkyCNdZl+3CTuDD8ofA9zlMCBOA1/0nnvIpFbs4WKtRP98CZAa8F6EQ8GglxpCpR82l1HWeWjm/D/VbEZR8nfieY75Ek9gYZHbM5l0ZyUACBzdXMNInLTdf6mHycSM8ImMU2AjhQZ8cpSVNxSsn7LUPHnXR+CjA60xDB4a/adb+IgexmT5BdrqEojhQRATx7T8zSDM4lnQzoOclfNS/qcgkHalh0tIqhV+X1V6shIHvks4y8kfBSXmTFtAy+xxiDOj2zsJOsKEzz255kzKfNc62gS/IJra+/CuVGV4pUzJQCMVQ5Sp8KqE5nIjQEJBFamCdputiEm6SwIkCbhnXxEDRSS1YFJPL0q4ZFQc61/a2fUFSUUxLgYQwfE18qXvyqRcIhqXPbBf6kCd+pM+jJ4NXihC/R/pVk4d52oMk3Iyek2JgxJzNUFe3+LWhKqJVdN8ve5cCpvt5qXZnYUcWWsiuM9qWuy4HmKmab68RSjA5AEqQwEugYZ35A2LC+6LvfBkBKvzH5PEXP3lsCtC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(66946007)(38350700002)(8936002)(478600001)(6666004)(36756003)(2616005)(52116002)(6506007)(2906002)(316002)(86362001)(16526019)(6486002)(186003)(956004)(38100700002)(5660300002)(6512007)(83380400001)(26005)(1076003)(66556008)(7416002)(8676002)(4326008)(66476007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ExuKfqHABjUrJhrTw6d6yDL01kp/4FK6uEn59k1yz390vS5O1zHfX6aT8tAr?=
 =?us-ascii?Q?gXbn9HO7xP8D4fTlrl9sdv3PGbLDF8fZ+MzQIxhWYyBXSww2gyCRa9a/SGYS?=
 =?us-ascii?Q?hggc2FiMT84QOEiJxAmKEv87mv8MKWYj5RWxWtulZpy38/nMFPRIz2J4v3X1?=
 =?us-ascii?Q?Je0HawT38p7dX8wEYWXO04qEKRFmlQee3NXJNdldH3drIJFXs1KEgyYAFdk7?=
 =?us-ascii?Q?9uxYe+ACWiyh01rslVZ6xLQXrngLmB9oJkbV/UgMimE+ae7vaPqEH4+62vY5?=
 =?us-ascii?Q?RPnkI92daWl/AlaaGxyG4GHS+RMsWC3P3OWNQDMONrPYWvFAu7aKYPxCMNXf?=
 =?us-ascii?Q?jZJPO+jLuL6hyupTjL93ilYtNo3TaZatoQQu5TS9nSoQLeBpqm8y23nzgrtb?=
 =?us-ascii?Q?mlV4R9AhRlxsTKOIatqHHuA3m5+2U7hNN3Bo3WWxRxCRKQu3cdQWC1DQc1Hc?=
 =?us-ascii?Q?UnsjyB2yUhCbwYcN0Y+rC4a7KCx97z14B5SbS0P2Yo8J2ZcA0pJ5RD6ZQkUY?=
 =?us-ascii?Q?fVe60EPUjx92GwT/BTeRn+km1fLOFgiZ1Rdhm6Ionks5HBfW96lseRziRuik?=
 =?us-ascii?Q?gDV+Ip71qQ5bAHL0Aufe+ZdArvYFc7e/TVQ9NSv2cz34I+J4Y84VwcFOXkST?=
 =?us-ascii?Q?mAMoSlaK0I7v+fBfqPQnNuLyHSF1rsevhqb6LXQAkJPTf8y7+Zv2akDLtrMr?=
 =?us-ascii?Q?KuZFjOYGJgtmDhVdg/vC/AN0APewc7PwB3M+EtCaLneX8ffG42FUSQNSD8T9?=
 =?us-ascii?Q?CvAasr+Q5aylqXFRxpjINqjZeR1fTmB+RixL25xDex5W+fe1IxQzSZ17OVJq?=
 =?us-ascii?Q?ypL6XBzpMOru8xNaDapvtrcEccGIkujKmK5oHc9dCgHiaFc1FMjMsSN55QR0?=
 =?us-ascii?Q?ZMSQ8w68c0eqtScRjfSrFZZT+Ip7H3FGzFBoLW+qp1DoNab7yFozjJ8F7Lrd?=
 =?us-ascii?Q?shOZmYU/zt/XGIVKEu+/uJJDFvLoTSflrkso51H14PTIThlV4q34wdsOmDqG?=
 =?us-ascii?Q?HbAj0yZqLHtjAUvr56Aa6Ra4EG/ZiFZRLMHN5HJxNp5JDvx3w6nPd+9lg6Ob?=
 =?us-ascii?Q?dByOFOsleTeymTQUJLcYa9h/fk5Ak5Do/ZbfBlgFdOGNs31c3HgE8p67mdF5?=
 =?us-ascii?Q?1mBKo6pJf/MhzIoQkMoqrpxTaTlqomfsrXZvjTsm1ckgWGi6/C3QENKg0TCV?=
 =?us-ascii?Q?YXNNxM95/HIpOqM1RX0EQ3/BTKPitksFObsGIPvWLQv7KZ5/pOsz1CCDTPkR?=
 =?us-ascii?Q?lSCAc8GTJfRKPWPBKQbG8PIJjkgR2O6Hs6UTBkKTVdY3Me/aNmol+vDeuDiv?=
 =?us-ascii?Q?6766qS5ssmJCn92POGwoDZYV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a12a892-203b-4c32-55db-08d924dc526a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 09:04:54.5593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+UA7WGKqW2TkIMekn7TEw3SDMD7uJWpM8okCJJBxK3isUVH+0kcGHG7AlZsrXXZ43ngiNz4cWGDisg9fKwsfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY will delay about 11.5ms to generate RXC clock when switching from
power down to normal operation. Read/write registers would also cause RXC
become unstable and stop for a while during this process. Realtek engineer
suggests 15ms or more delay can workaround this issue. All these
statistics are collected with ALDPS mode disabled, so use RTL821X_ALDPS_DISABLE
quirk check.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 90e3a8cbfc2f..b45deda839f8 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -408,6 +408,22 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int rtl821x_resume(struct phy_device *phydev)
+{
+	struct rtl821x_priv *priv = phydev->priv;
+	int ret;
+
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	/* delay time is collected with ALDPS mode disabled. */
+	if (priv->quirks & RTL821X_ALDPS_DISABLE_FEATURE)
+		msleep(20);
+
+	return 0;
+}
+
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	int ret = 0, oldpage;
@@ -904,7 +920,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-- 
2.17.1

