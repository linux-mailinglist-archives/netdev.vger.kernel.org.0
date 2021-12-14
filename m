Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04125474230
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhLNMQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:16:58 -0500
Received: from mail-zr0che01on2122.outbound.protection.outlook.com ([40.107.24.122]:35264
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231834AbhLNMQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:16:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzbkLhtGVF//vHytvSRDV1HiKDenWq9TNomLaiHtdFx6NoPt1VMIDXXNKbx/UdK09rlELqMHufnz7D+2fqLc/5FeMcSUShOM+IJALg7LmBQ/C7zFeoDDanwXmJJYqNxKydbQihaUow2rwIqJwjAcvqru5P/hqlLxHwjEJRELTAYc5WeGI5j0h1gIByg3x6x5eYpPiNbUuo/cD0itCGDDBSPQ0H7Jk5Qko3cyCf1sZ5YIEROi5nYqJkaVaJjzdR5d0qXIDdBXYiFy1PcyB+6yloT2lWjybr2k/pSrHyzBsrG4axHg7E+3vn1DKlvKcQ8KekXJf2q+/LRfEWRWp9Soxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCYBeG0n+h7qLcL13dQBpWTCEfcOAvbSoAZ6ijoSe/Q=;
 b=BAIJnuO87O05GY72lgILGQlBJusijO8E29hPtMwu0Iqk3EXsrnV/PDYUd+Jm4K7GkEkx5XtdHbinJ2jJbrD5bviP0zvys56ApoWuXBN46B602BCI/BvYIru9AQhw2yK+6I7nANTE7DgpQa6Iw7v9uHwsUus1aK+g03GUDtiuGguup7/7mBL0Qxu6Bwol+5JPfbS0GuWRlRm0M0YVXlaNg2nzHpIsiWZZfczzvAMWFB3XwIp0jX5Zcwad1ieB5ItuLwE6ypPIfQu3gdFwOoCBeIJozCjEGgNEsDs3T6qqyjr1/OMPDCLlpjQqWF//AloJouiQyI7+lveqmZ/zFd46Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCYBeG0n+h7qLcL13dQBpWTCEfcOAvbSoAZ6ijoSe/Q=;
 b=bwRjEOj4aeVu3KgEJfiO0jaK/G+UAz68FBb9TXTYlzSRZ4AqPV3Ibj71HzEM/ekx1ZMp55flUYyfMaZCLXQ/aVMN9YMxIQnHCUo9loFMMvpLoKIFuano45o8038tgFmXaAmPDYjO96j28zgVoRRLNzYOqq1e9SnZdBu8/tgYi4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:36::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 12:16:52 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 12:16:52 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: phy: micrel: add reset-after-power-on flag to ksz9x31 phys
Date:   Tue, 14 Dec 2021 13:16:37 +0100
Message-Id: <20211214121638.138784-3-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214121638.138784-1-philippe.schenker@toradex.com>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::15) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cebbdfe-2173-453c-0a5b-08d9befb9c9c
X-MS-TrafficTypeDiagnostic: ZR0P278MB0234:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0234E252EBA37DB413F9873FF4759@ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fx5q2z+cybPtxlilCuxz2CjKdPiHacPYWxjlJ0iFJCS4i2mKQXc5s0EC4oYf/8yQN9sprc3DpSYoRYWHzda5TiY1/iiTIZRaWco9YYvnangy8yRNVLp0+A9tmaC6zT4xiZM+Gj1LBuq6c1hTJWpvpbBY9DOtZq3Y3IOCpF0gcJGJ7jfiSflnv1ggMRoyqSS9e4UQLviTF/CqL9vbrJdgs/3atoh7/XbAvX4os38v0bNNcACdiC5SpxIXw1vt/lJ11YEfRx8E9v9QpXKbMc+8i1BhRQJaBfUzHSt410P7x45tDGryuLNQZaCZ81DQDrwzOH3UY9+1emriTqz1ZoZhp9uG8ETZI1cWTafRTzkf2xVD7pVxquuq/i10Xyg1UjhbIL2LUPuMl9w92CiCANxBZKV+KO82m2kiIYexUNzWzvGzUdcaEhPoaS4ntyd5mNaEi72s3hR/62uQRvzuod1POuAjonkZomqwHySBUl2if/NXcKIWD6pRZ/lW5wlj2yMorhEBwDbegpuDf36nKgowaCb/5r/OO/hCKHI7FX5ZC2QfG7PG7CsMICLYr2cyvKIxGwYTqYOyblzE1cUEsW2G0qljwKi4touEUu6Hy8QHnU9HXtNAnUW0Ex70oXBmluyiNUK79thUaBsH7j04R9YHSsytibqPgevelml+u1z8fE+H1z7LCUkVvMrpLUzV62MKBlF0sO8vxedusyPbMJwvpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(366004)(8936002)(86362001)(6506007)(66946007)(52116002)(316002)(6486002)(54906003)(5660300002)(2616005)(1076003)(508600001)(38350700002)(38100700002)(4326008)(8676002)(186003)(6666004)(26005)(36756003)(6512007)(44832011)(66476007)(66556008)(7416002)(110136005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OeTf2UJmvHYFJikXWV+xFcELr+TG0WvJ1IDOsAob51utbCV2i5ysGpzYlUWk?=
 =?us-ascii?Q?NxYgaAAOKzHQhpZNOIKhjtxUaDYNuKBg5avjtnV7j4zS4hR/zE2WFN8CA0y5?=
 =?us-ascii?Q?7fTzqL/A18wR5wQFAQvLjGCeQvrKqRqse2PWCY1ySzWXx6DOUsk33LY4uIeO?=
 =?us-ascii?Q?CDVUjVeCNFDUb3Y67Risb1itkAJJMe3NRce0bz6O3PTI8XsiB8R5UARslEoU?=
 =?us-ascii?Q?kZugXKWX/M0WZ35enTWhX+IkbW0tjeddy4zzRa0Q586kfHE7DajcVkO+AIqD?=
 =?us-ascii?Q?oqpLW2IaZpH986NdzERSoJ0ggZWHRYl7Ag5kmaWkaXGSmL5eeSYR6CNZmViY?=
 =?us-ascii?Q?snkV9yObtbqSrnwFG5nOiNmSN3oY+0fPhMeVIZNy2CZ9Ke4koPaGEhfm9/XT?=
 =?us-ascii?Q?ZcXP64PY6iKbGbqXLgoK89UG2n4NAT+xmLsNXqd4Lf44S0pDpEkfNVfR/euN?=
 =?us-ascii?Q?cNmM/fOV4rKf1IFloCd0vplCfkLAw6FcG2dDinVwdnj/fwDk7bb+GBqLVT8O?=
 =?us-ascii?Q?IHJFWGwnSzrZhXxXozfjKvZSKaC9bfKVg1Ae/NfHd7GqI8uupOrqUoct0iw2?=
 =?us-ascii?Q?VU6djUuvClhUCyDlFpJRIGg4PCvDoDpqAZxxOzoi72SQI6lvVDD16pLOHdh+?=
 =?us-ascii?Q?qstuuNjWTh4H0FhNUSbyUbG2cBUB84yDr8kzgjMHB38ss1qAMpwktbgnsYCw?=
 =?us-ascii?Q?P9hylEV3cXkjTtwy07Pqbh1IVzPiMuoQyblPW6M9LHGYwqwkzhcO0mDLptzY?=
 =?us-ascii?Q?tBs+jefWPEqZ1ikAaqwVGEadsc0K8u0/X+2k4BA8hxCeSgRJ0ByxAzCIntub?=
 =?us-ascii?Q?OE2JrnuvnJRQYQEdBzhuTCBxU8T1SK6F87iG/2N7pfgjx83FFjcwgSLvJ6kY?=
 =?us-ascii?Q?ur+7g1PnvQD8HrhTI8PrJveqlg/lDeF6Yt+CeWjQW57umZSbw4OEiJZ3Bm0e?=
 =?us-ascii?Q?/xP5TBqMx8Wt3hK5LLGlH+chzxKcEYS48xkUZ1yQM8dHHn+jGljG99xfwol8?=
 =?us-ascii?Q?Prs84Bw1LpxZXMUzwUKJ4ikEAwfBOywbnLHBOTyU0HkkdZvvWASiLywxD/Vt?=
 =?us-ascii?Q?mfYgdMlUp8mcA0Wnx2UIrmv8Fz4y2L+5jHO3tbBmPJu4GezmAnvZXA0qa+Zr?=
 =?us-ascii?Q?aaL/QlGt3UiusYy5bV8QfEPJh8jndz4fhr1AYMB6f/odMv8ORfQV1EXozqf+?=
 =?us-ascii?Q?n1Owcjp6mBo9XDvCjA+2J8GgavlVOT0E/9J4h2M9A1VeEf28gE+GG/laezOm?=
 =?us-ascii?Q?n0Rzx17JKQsSM/mYP1/Ba/cMlJBzOv6kGbb3WqOIx0+qHdi7fUGpti1VmY0w?=
 =?us-ascii?Q?1DQ7ItAQsBWK9JyayEn68aJ5hprm3ZVQo+zD4V0zFriXPF1HPSgq+nnQEOFJ?=
 =?us-ascii?Q?JyQyzJFdiH5x1d7mN7FlMGj5EduzLdza2O3SRVjtoZiAMjXYlCU/Im0xTRdi?=
 =?us-ascii?Q?M3UH8YnbmXXkuF7f7Hvk7uWWGBQ/q2dHVpIPYutH9jvjMxaPoxWsi4KAt2eS?=
 =?us-ascii?Q?fs/p5Tp6l2GeYREeTpIu4u0pc5shkhfDwlkE0khcAKY3qF47gEdEJtW7Omkk?=
 =?us-ascii?Q?tKzvPr8wCWZEYDB1a9vC0mHWTIZgRZ5V63Xbp5krIjfd89aaoL2SHGuqFLlE?=
 =?us-ascii?Q?xIJLVELTo22dkQiU4m/Ay5/kVsTq1LnmR/qbDBiyfZTGo3vn5jrK4YQmd9C0?=
 =?us-ascii?Q?bwi36A=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cebbdfe-2173-453c-0a5b-08d9befb9c9c
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 12:16:52.4152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTjuvjsN7bl4Z7Xrr9WTxLBIOkqMPrn0yM9mP7pq3MjwqDWZIwhU1Cy5wTM9d86W6zOqn6LJrMXUYbAhfVlntAQHQSn+S7JQ870lwE4t8HM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ9031 and KSZ9131 do need a reset after power-on, set the
PHY_RST_AFTER_POWER_ON flag to enable the phylib to do it in case the
reset signal is controlled by software.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
---

 drivers/net/phy/micrel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 44a24b99c894..85ee3a61017b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1777,6 +1777,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ9031 Gigabit PHY",
 	.driver_data	= &ksz9021_type,
+	.flags		= PHY_RST_AFTER_POWER_ON,
 	.probe		= kszphy_probe,
 	.get_features	= ksz9031_get_features,
 	.config_init	= ksz9031_config_init,
@@ -1822,6 +1823,7 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Microchip KSZ9131 Gigabit PHY",
 	/* PHY_GBIT_FEATURES */
 	.driver_data	= &ksz9021_type,
+	.flags		= PHY_RST_AFTER_POWER_ON,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
 	.config_intr	= kszphy_config_intr,
-- 
2.34.1

