Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82742390A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhJFHkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:40:10 -0400
Received: from mail-db8eur05on2121.outbound.protection.outlook.com ([40.107.20.121]:24129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230013AbhJFHkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 03:40:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7GH5Uk4GblCl2xUmHNIondn1OOdHWbvRbEXab06pmnT5HP/5EsKIzsLYfmnwfXZ9GnNkCHlYJaJATGjQ+Q7CVdfkDMFkw+1UrbPi3Xba0X7ubOCNvkZQ1ML1fBVMrjs0jcm+4CoXhVM8sqb4270t68tM/HH75MIqAs5w+P+Pfd+m3h1QlrHbaX4VCa2hvulxhNr7Gxp+MQRiKwktIDAEPZivK1TRtYrx6OcueSpkyIyvA/BD7IMdintCIeqEcdqFh5XuqjBAAfCSroCxTLFc5MlXc82btPAoQx0mIZgPkzUpPQzYASjUDEkqOrnkTZyIL01qlsGMiLoyaYEbJZUBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5S/LeTBIp2yYbv8ap2BikebDAicfMK7xTCzzyKOqXs0=;
 b=IMqQUqLT4PHhRx7AzvxWwfbulrG+AbLoVtAaKQzs6dmFq0j2/+X9ILytfVXFKnQX3ImIbiOb1tn8Fwcn31yFHPxsdXS5IOkuF5PgoMwysEv14OLaEbb2SS7HaxRDg91DZW9ZMb/BOvOs6xHJpeasjP/D+3V8lt7RcOnqFMUYX1XhjlAQQG1lJeisfhWq20je4ZdROZtketV9ClloJr3MiE8TTMaMPTrhk/u1vBpVdV0UOPBcHiyPi1uwdAYyVAZdeeEo0u9F2JsFRCI3SuWEW23w+iNkAiPRQ16GLGq4qoWnWnSCdRhaFXbkeGzZxIgzWEuNwouvtBueP5WhKqGL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5S/LeTBIp2yYbv8ap2BikebDAicfMK7xTCzzyKOqXs0=;
 b=Zj70nJhsH2z6j9iue8AK8Rq5QI6S48G5AbrELK3CB3QRjbbmKFcaTrsmPUK2+VrOKKRWwKSDB0RDi2jhvbqdNUnyoD8XqAB2IJ4n+PAwJ4f4KA3loxOXRk7N2kIVSqOXb9OC2XP5tbpgLNQbruBX7hD/D0AYNnFo2lfKZjTXI8k=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=toradex.com;
Received: from HE1PR0501MB2602.eurprd05.prod.outlook.com (2603:10a6:3:6d::13)
 by HE1PR05MB3468.eurprd05.prod.outlook.com (2603:10a6:7:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 6 Oct
 2021 07:38:12 +0000
Received: from HE1PR0501MB2602.eurprd05.prod.outlook.com
 ([fe80::8463:d3:5cb2:152c]) by HE1PR0501MB2602.eurprd05.prod.outlook.com
 ([fe80::8463:d3:5cb2:152c%4]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 07:38:12 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     philippe.schenker@toradex.com,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: micrel: ksz9131 led errata workaround
Date:   Wed,  6 Oct 2021 09:37:55 +0200
Message-Id: <20211006073755.429469-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV0P278CA0045.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:29::14) To HE1PR0501MB2602.eurprd05.prod.outlook.com
 (2603:10a6:3:6d::13)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GV0P278CA0045.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:29::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Wed, 6 Oct 2021 07:38:12 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id 4BF6F10A3887; Wed,  6 Oct 2021 09:38:11 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 319a607c-73e0-41bb-52db-08d9889c4055
X-MS-TrafficTypeDiagnostic: HE1PR05MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3468BFB9A80413B8F102E509E2B09@HE1PR05MB3468.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /f2qMj52GlzCCvVNlgJkH5Yr5KhI521HVKiiB1Ks0BL+ZxQjBJ3wuy0tNU3vzZk0ku1TKA+L/z88YcNVSDEeoQlNtcXfe5lDw8dPz++uOU0h17pGHSd+lWuRX45GjWeocjcf5wkGsLgcn4GH6Sgft2O9NZgLp8BENi9SyzVKZqpMyZYG3J5XXX7SAotuR249HsoP/gVJbOcHslE4UjsNv12RDf5NdbiD9ACXorvMc4VhR/5zOSpkZ0nrduMDzls0NKsAgfnLkWUEoHqDgLGRCvKR9AIkF+cYeEvBex3+pRKBvtZc0gDbkkdOfVKEZ+Ln3SqQTcJJq9JOPT70griTyj/qgXIT9pAs8UrT1WBwB3zDtygSrvzrDhkI3vJzOjHDC8nOMrgUpbC5eOTWRKHhic5pYP60sWOzRf03ipFp0+uKYAHG+C3yFcZBlwcjgjQHntR3fBIGBBFV45uJuh2nx19Q7RdvuQEmf87dpeJ3XmCUoBXKj22WlbOGGaumvhA+thFB2smXBUqSyavxbAyB+N5WEM2BfJ/XYTkbrZQuUigarorxLcgp48/SB00jbxaiPlXlJ02CjqUP2X+WL+zkZt7J+bTjeOpvZMwj2mnn9/nQZXNxI/Jc5JH1b5AY7X7Thw1IqxamMhHrOClsKRofihGJlBH7lMIh/MerGtJE3SUjSEdWO3pp1VpfL3hcnO0uETaXjSJ8labWO8BUi0h6FT6o+R4bL/eA1XIV90ErL4SlVlvs3vpD958lfpqfWFkDzv4mR4MVUZ5I4Y/bp378hh4afOGxIrOfe+O3QavLduk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2602.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39840400004)(8936002)(110136005)(2906002)(6666004)(4326008)(66946007)(508600001)(42186006)(66556008)(38100700002)(36756003)(66476007)(38350700002)(26005)(186003)(6266002)(2616005)(44832011)(52116002)(5660300002)(86362001)(1076003)(316002)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WpQ0u2Sjxd5JAFhUlfC28GdSjcm0UL1DGaarIZRzhNofDHYn1bkr4kuMgIy9?=
 =?us-ascii?Q?FZ1ZGF3dbSxwGt7/B3lBuz3pylUFSfrEq0HlH0hlyqIlJL3pHsq2E60gpNP2?=
 =?us-ascii?Q?0Y/m7aSkBJyrfnM+Rt5WADIszW6EqlraEGnFb+HZh3UiXsoV5pfujJYxtZPX?=
 =?us-ascii?Q?3ssShAt3d/W6AsXbKNo7HuzDYO3XHfRdCsRae/oh1BRqjN7MZCDSV0FuidO9?=
 =?us-ascii?Q?dVcYsBmDLpbqQ4o/IHVOIGWxH4PON4CjgqoTrCFhE17ZsH2x+B/QSw4EGm66?=
 =?us-ascii?Q?B9xzXoK6rvN9KpbkyJx3VbWTYtrW92AgzbhXQc3Z+WkK+XQXzJU0OiK4yeOH?=
 =?us-ascii?Q?leLXPx9nvjP9FF34+fj3wGzKvLvwroRE7MaNH6xeV87wAGZKSIOZ+x8S4jkw?=
 =?us-ascii?Q?KSUPJQoovItVyeoQh+6AtOddWg84OQVGMT+vrxA14j1W1lSD0TPRcSb4DOJh?=
 =?us-ascii?Q?2t2QsuZvNrmrv55wWiemg0Pjm+D9aqX87RpQ/WjE8JiQEx15mqjrgi9gGM+V?=
 =?us-ascii?Q?IDGntDqaDP3dpE0M9XCOvQVzJCTCrjCA/2HIr8pI4j80ma7+XPRxwhwM0lYj?=
 =?us-ascii?Q?bcNqWiuDZwBeJ66oZmU2ttJiUdzNqq67nQbJGx+aNn5O64kW/ZPheCeyQcLg?=
 =?us-ascii?Q?7MVBWaXl0OtwYLImtmwymSjgOnYdAw4Yfj6Q2Ub8AYFMHRIde/1bDkXOeHVS?=
 =?us-ascii?Q?AN04vgXz2adzpTiMANnW0ooJlQOY+JU5xDLFmlQgX6m0EPLyzMAwjU2ePQEo?=
 =?us-ascii?Q?zdkCawWZ7DW6Hb+MxsF14t2K8K7hSRxYOXA0299pwvDgkwKVOI3yjNNJkw99?=
 =?us-ascii?Q?Y7JJBPrPeuzpzPRnXJVyCSiYmV/6pZeiFrlYuqLA0EZenm4J+8UJuuQXjcSX?=
 =?us-ascii?Q?1R6OuB5IQctKcWPsXghM+UsG4yOs0/UgeHPUNR1wCnx9AuAvFlY0Er8e0uvg?=
 =?us-ascii?Q?Rvl7OCHO7Znk6419hVzeXEuYVfKHazu8MVmPwZgBHiard8JjKivrk9Td34oj?=
 =?us-ascii?Q?iICUyLjjRCtg4e6a6Lc3Ey/7qhcDfZ3dzmpTvZmEspTVM9wvl4PuGZnMSSiQ?=
 =?us-ascii?Q?XqMWnmlF8r5/DRGpYR/3zXWDllTCOZOxWfoHOIfUSGfsoLaw3BRZLoW9u+Fi?=
 =?us-ascii?Q?4jscA2iOuMKhKo5MHBv7ZSQw44tAsB9COd22rqPzuHeFptGQWfm0wFTqxl9w?=
 =?us-ascii?Q?v5mUtq7vDCJDdk0r5TM2sSJRA2Dp18DNbMuxqhN4fkgcbUi1mQ2Q4+D3WT8G?=
 =?us-ascii?Q?iH4tZ+/aNWWstkORLQNIa6TObCDr+RRSmGqQgJK/mKHXt2rPxGoHFUKq7laJ?=
 =?us-ascii?Q?ipudCdPWfAon+5fEqWyrXd2l?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319a607c-73e0-41bb-52db-08d9889c4055
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0501MB2602.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 07:38:12.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUBCnxdUDDUKfm6hxGcrYr4gQ1eUrwn8wN4WOAE3C7H+5whOnnOAtcRm3LHXapYiZl07/fo5HsMMxAUmpVLa1H+xIJ7d6sIcrr7MP3UYyNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Micrel KSZ9131 PHY LED behavior is not correct when configured in
Individual Mode, LED1 (Activity LED) is in the ON state when there is
no-link.

Workaround this by setting bit 9 of register 0x1e after verifying that
the LED configuration is Individual Mode.

This issue is described in KSZ9131RNX Silicon Errata DS80000693B
(http://ww1.microchip.com/downloads/en/DeviceDoc/80000863A.pdf) and
according to that it will not be corrected in a future silicon revision.

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/net/phy/micrel.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c330a5a9f665..661dedec84c4 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1003,6 +1003,23 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
 			      txcdll_val);
 }
 
+/* Silicon Errata DS80000693B
+ *
+ * When LEDs are configured in Individual Mode, LED1 is ON in a no-link
+ * condition. Workaround is to set register 0x1e, bit 9, this way LED1 behaves
+ * according to the datasheet (off if there is no link).
+ */
+
+static int ksz9131_led_errata(struct phy_device *phydev)
+{
+	int ret = 0;
+
+	if (phy_read_mmd(phydev, 2, 0) & BIT(4))
+		ret = phy_set_bits(phydev, 0x1e, BIT(9));
+
+	return ret;
+}
+
 static int ksz9131_config_init(struct phy_device *phydev)
 {
 	struct device_node *of_node;
@@ -1058,6 +1075,10 @@ static int ksz9131_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = ksz9131_led_errata(phydev);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
-- 
2.25.1

