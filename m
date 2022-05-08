Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A378A51EF97
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiEHTF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346948AbiEHS53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB840BC08;
        Sun,  8 May 2022 11:53:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsCrc7atXfXe3UZollBWUE9ZUsbNivGESZlrOYrtYke6jeEub8xR/Zum2HhjN6kLnh1z3/5+FIpDuaWsFjsQtldfVCVvGpLpnQmFgXKLhjr11G0PNOzmXp0kwH6zupxJeWQ2/o3xjQKX9brVVheu4KzZcm0v6TfYcuaAH2OK1TifxWMcsl0bL/tFHPoIpunAFQnORWnPXXBY+hCLRyFhISzWzcBAwZKw+igFbrCk9NW3cPKrcJnaf1kocO0fJmLuRFzbX/ten+bmrFdulcayBZ5AcZ11I+hByz4hU1NJBTufdMhnM6UAnFNCbKveggUwBET9KjyCwdPnbp6H2f+Jeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCB4Vx2TDjKwAlu4m1e0KeGA5ZfMHTw0YwLUoW/ut2U=;
 b=WBrd46BW89+A5nK+af3Mi3o8nMVW8g4XmIzgYKfcF+t3oUm/S58vq3eiPRA84OXA6YNH7L2oDM3rX/69PwJf5JJrCjxiO3jC6PkIH29G37JrGcIvjbkqOVHL1GdPVBkJsNZO2Uo8iq7aQS2WnF1iXBRhCw7+1eLcPdoBN/Y1MjA+rSPSMbWHA2qdr2FDdtpq9kY8I78faOL4+zCjtgRQEOrPjo4P0S5TOMCJPXSQKecd+Z65i8/TmtTvmGTfwnoyCSEd2C4nFb1VyUyKg7sv3DIacLcr4c/qLexTPL21X0JUQcm3/BH/XSaQmbSARKbSpI+6B4p4iXXaaqBfEM4zgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCB4Vx2TDjKwAlu4m1e0KeGA5ZfMHTw0YwLUoW/ut2U=;
 b=r7mAguzE/t4eNj/9BGFPy0qvIgSd8f+/9ApIWv/zTm+k+W2oadwFHEAhSQzn8ZarcPBrxx0JEQEWw6WsQo/o8ZKebxp8Dd2CdIdEX/ILtMecnQt5kKgjCKBULTEVal3ptZ0AnVMVkghxzQVvAC9xj6VIvgRZ/+KzunELiuo4kAw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:35 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 04/16] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Sun,  8 May 2022 11:53:01 -0700
Message-Id: <20220508185313.2222956-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75cd4e50-4190-4921-a52e-08da31240e0b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5533C6AC02504CD66FB04F1DA4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rWHQI43jWJ7ErQ8JymDd45aBlMLGf6xwCwS4/HpvHw59+1iTVSxBrSfO9V1f82s3jO9VuSANr29OBQvOVZK3FpIEJMn7q2eQyBCKCnksSmKtK4Ha+293XSosFvev+PeOTTrrzeH6gA6dWCfAS9uJPJURkxg/i/oFHlvlD0ENnj1Owbj807vDadDJc2FJ46aPj/BrMOwUVnkyMxQhlPBYJmOFpZpYMduW0lVR/10VEEmzwUsim2SRMC0KY+1bE4G3H2xqheC5VdXBHEPNXj080Ts/4T8Wv9fwp2Qins0mD2KnM3P8TNmpc5VSRMfJzrmSZIH8hZD/zo3q4NxYmPDV/61mvYQwl1dS3Hkdxer+2WRfT+JJcWFhrf//if5r28OEivYmuu69jfnnkSr09E+hplUnhAFtnxbEZAaZkRKp9mShg6xsq0IBY0iXJAMX/0/NMpFNNPFmxftDiG6X1hDsYJji+oIXigqm8RqpQRLM3b4/Y6xtoruVRgEZUu78KxPD80lfHL5WzxvWbCQWnFdpcNfbe4o7RU1sfYCL0gwlEsaaUgj6g5XpWbCTaB+tGQzbxowq6WXF+zPNF7KYts4GO/QV7rjLzEpFNy14URophMEn0vx7otwV+rNvPDu11Js2+KS1K+YF4CVcExATEpWzzztDEoV81CWqTCa9nd1c9Cl9Ev4lEIIvWAUzXNFUxfqr0NSKdQwgXw2XniQpHtf3Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yo4JxViMSgo5EQQMFI6tymmdV8iRKxOXNjRMO6K5r6dskhEQLtAOT5ckuKxu?=
 =?us-ascii?Q?6oOZ+A/qvzVVYLprU5HBiAGvqr+KsPv5E2zlIrIp3cbQOCU87FFWnnQQr4PF?=
 =?us-ascii?Q?P2QsaO/dLHAzdGtPOii1/dhc4/Lq1qaNyzoFraLVF5eaJpn+ODzl7xq43y3W?=
 =?us-ascii?Q?0eDrhudHvsRupMz+UKOFnbDnpy19FRyRkZhJOpe6ejAw+p2DKDqfKX+fv89+?=
 =?us-ascii?Q?fsq9pNH0tALx+aLTBxp5C1KIGxft1hLhGVHUFc8OBMpq62ydSpErBhlDCTcU?=
 =?us-ascii?Q?96t7VGAoB3LzUk8rEp3Qp+f9/AbhC4XacprmFLoLjPsqcOBGiUIdCCc6qmXq?=
 =?us-ascii?Q?s9N0j5UuMp2cPEjsJDRcwIdRV+i9kj3pippT7I4l+aW+CcLpK2HUdd1WkKJD?=
 =?us-ascii?Q?x1OvFcXsxShPA4g85MbbXk8BDBx4eN+ol6fq4mVbzSDpygoVcGewEkpqhkfF?=
 =?us-ascii?Q?EL/DEbt6s1GbsKn6SXXUAdhnobpBNl0Oe6ag+BkxNUU/zjz0YpgRxSvqyo0+?=
 =?us-ascii?Q?WOZyq7Rc4Am83CzqFErSfGu0YLHTvDiZKO86z70gpvo4PG/u8H7hCMqyUrLJ?=
 =?us-ascii?Q?k12FgWPLFbnncdwEAEsQqWZvyHuz09YJ9UApR+RasdtBwsnr4FTgwWFGqIbr?=
 =?us-ascii?Q?5ekgZ1p+57XJZ+iUWX0S5TDVnR4EcmLTkpYJW2sjd1kfKO5HBJoALG7tsbtv?=
 =?us-ascii?Q?prWIQMtovfXT3O+fbWJFofR8uk/EeuxChGuegWvOrAhnErU6Xhb1r8i/PKLz?=
 =?us-ascii?Q?YrwB3esZ1V895JfVbB7/b2W+rotOmQaxNL74JQI2sZbkWDYKRxKv7nDvvv1D?=
 =?us-ascii?Q?7XnzI8rQxUyyek19XwR+GcTLpS0dMJWVORye4eFLMSe4UwRabaeaD55LyZEf?=
 =?us-ascii?Q?cNIVlMIjYNNSw2Q6Z8b7pNdJBRlcgWVItQAhrjNv6ei9CWw3/+flQG4sp0cR?=
 =?us-ascii?Q?mUuuJgZ/E7aGl7tXQerXEHnt5c/m71n8MsZO4uH9ZUkXIPD1vIng1anJ59wc?=
 =?us-ascii?Q?779nrXgH8vsGmfGOFuGKxz/3JxcuHrB83CI79hYVv9++bxx/6wz2w9oWwwm0?=
 =?us-ascii?Q?MHmZRsukmJiNjzwHt3oKd6ianyWTgYKMMgJ0SfILKvwHB+RWrxyrpnjIkC0I?=
 =?us-ascii?Q?zvI0dyJFStTWG5Ccv/Nm3oOHF+5fUzEXsYLHENL5judS51u22TejI4FtV/Xi?=
 =?us-ascii?Q?0HjUociQ7WDAsCqhTV28KxksA7O6N2exQIzmZZm35gLlGd5n5+Cwd+o0pB1v?=
 =?us-ascii?Q?bUDRkVZ7a9MwB3ndaBnYPX4ZQHTNa28WKPQM3smGs+1iY1qax3z7aKHyCKdY?=
 =?us-ascii?Q?XipO9fEpYBfhusZxcCM9r8mQRhDTAzwe4StNRZkzMztPVCsWjEqQCkElogLH?=
 =?us-ascii?Q?OAiu4iXq4gVyL0Vex6sw1tkpPMBOvSNIfePZQCkb82437UU6jXmA9kpWy/3c?=
 =?us-ascii?Q?v5Z8bJlZsNOcbb9eNmnIJ0U0q+EcoxVfzC81GhOG0bDUb4leBhMt9H/PnHh6?=
 =?us-ascii?Q?o0oA7hPEFtVoyCjIdVur+XE6zTq/JWkP9eKCYUIDxiIv9mck/HrqDO+Ll3iA?=
 =?us-ascii?Q?1HKff6qutNH5lflLgP9tP+C7h3xyxRj8/90ruayOF2qzotbKDgo8OksDOYXc?=
 =?us-ascii?Q?zLqa7Mw+smfQr4jzOP6Bwl+Kh5+z9feMrfPbUG6j9D7nktcX51XP95hCFAKE?=
 =?us-ascii?Q?vJ90Ut126VXu0IWc64aAw5HaNwUXn3GBLWn+lTeVlt6gGBYplnonf926zHrN?=
 =?us-ascii?Q?85WhRFQZMIb7+6uxkEwekcTtcv1KPI5KjI+Z6ws+LaDJeBf1Y3mT?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75cd4e50-4190-4921-a52e-08da31240e0b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:35.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9P5RyhQC6ACxXwG6SDpFH48fJc+clrYkopjITy1arYx8i95lPeDU+ojEVu/0rPVwBDac2LushWu4uAVz9R71einb2YvGk+THtmvd5cHR1AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain the logic for this bus, but are
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 08541007b18a..728883f95edf 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -281,11 +282,20 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(regs)) {
-		dev_err(dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(regs);
-	}
+		/* Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res) {
+			dev_err(dev, "Unable to get MIIM resource\n");
+			return -ENODEV;
+		}
 
-	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
+		mii_regmap = ocelot_init_regmap_from_resource(dev, res);
+	} else {
+		mii_regmap = devm_regmap_init_mmio(dev, regs,
+						   &mscc_miim_regmap_config);
+	}
 
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
@@ -303,10 +313,15 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
 						   &mscc_miim_phy_regmap_config);
-		if (IS_ERR(phy_regmap)) {
-			dev_err(dev, "Unable to create phy register regmap\n");
-			return PTR_ERR(phy_regmap);
-		}
+	} else {
+		res = platform_get_resource(pdev, IORESOURCE_REG, 1);
+		if (res)
+			phy_regmap = ocelot_init_regmap_from_resource(dev, res);
+	}
+
+	if (IS_ERR(phy_regmap)) {
+		dev_err(dev, "Unable to create phy register regmap\n");
+		return PTR_ERR(phy_regmap);
 	}
 
 	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
-- 
2.25.1

