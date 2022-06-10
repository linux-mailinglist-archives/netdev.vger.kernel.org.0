Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF0545F7B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348035AbiFJIlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348005AbiFJIlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:41:10 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D154623BE4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:41:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuXkjsyJbgO3J+g6ryO5gI2fFIQGAHX1yRga8dRUv0jl+LuGOYE5MEIQKrQ2GKDxkVwd4WwhPDLHMhm7L5Fk8YjsUaJ2GNjczjHbRY6T2NKR1t84C3nJrebajRGzSnK/RjmWdx5AVvppCKBb9pz/D85F0HFZDnsmeYvyg/+FSl1Kg6zbA0+2DBCKnHRYNdljGRcb1tWCt0iqsksygxTAnsywMfNb56NLyz/0GMqNXoeCOKtGrXdxbn2BgijvqCB16EpCmfNsK55OmCkl6QUMRwbTGMpojksy6grv3F2ECDmIco/m1w3iB538A/B0Z194Qcy/DYvInjvomXqPoaa8kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rjf9+LN6j/t0XKJ6KOTZV15ocyB0FD2UnYFugjffi4=;
 b=LKLJBKVRGzPkWMcLTvBif7lDUgxTVwh8EvMjopSYBhfQBJY0G0dfBlxeJw3pPMEALP3J4PVB3/PmeW8pI5q/j9J7IvJ388VQd2gBe/YWEdAcaREBxh5fCMR4RTLDRCq1VSDsSwsQB29A+nFxBmCBGJcgg7haDFLseCgHdL9yV7mfyRuhG0G1qVi6oSNt0+hIL4Orxqpc7xkpGm6lmS7EtdAgQQNJU2S1kGREJWqzI1gEbUxlsU7RKW1ib8D3288Y7zJUQreq3GThtpKMpgbqOrNiPwlLj06NoCpX8vZdX1pTe/gLPljmqdtMngRH+1K0VClJlFOJpMPNYNtnXPsgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rjf9+LN6j/t0XKJ6KOTZV15ocyB0FD2UnYFugjffi4=;
 b=rKejB/tEn8nqzug3vJ7i9NPXPC39lPNzPZEWxXV6QAc9UTrrUgfCH6Ozn8tepdBBwqM9pbvoV2Ur06Q2jlEet5GVlddy/wF42CZR3gUWB63uK6JRgbPoCsukLHdKnF6/By1sG/pzoWUfrnektiNFsmI94KeMGDv0ptDnpWg/mAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by VI1PR0402MB3421.eurprd04.prod.outlook.com (2603:10a6:803:5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 08:41:05 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1%6]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:41:05 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Ondrej Spacek <ondrej.spacek@nxp.com>
Subject: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G are not advertised
Date:   Fri, 10 Jun 2022 11:40:37 +0300
Message-Id: <20220610084037.7625-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0075.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::15) To AM9PR04MB8397.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b5::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e20e5f-8c80-4538-380b-08da4abcf503
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3421:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34215C1F8C9342B1902D714796A69@VI1PR0402MB3421.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FSOzFVk9flYT1vYD69FmiWvRg5j+x+WFQNVXmjz5sIrS2eUK9NZQkR+HZS9LOjP202NYkmcVsK8NBlni/M9ru9AUV91iY4C19Tz6rjgDJjfZWlV+QKRYBIF99qp8N2/YSnt3qco/ERz2Q9sqh9DjUkfavCX9AOdQoAQbJuGo45gnC+3gOMflCQ321GtY9PZuBHBmPWnSZJlWXdVuiNeL8Edb8LFknLRk6mAfVc5EMlkI2xw1U98DJ4Mqn4CJnXn3MvDvwtkuzfbM8fpMfe2Uk0IstLUWFQjcVyqz9OwF5uzVxi8/sO6mAYliQmuV4/dmfD9GGnR8w+/+S+F1vfnS1VjF5G2AYIdA8ia2N9l7cT1hEmsJmVMBEfFTSeTSY5mLcJKDyQ8U7bJ0f5hVg78eEsrmThwBBVa8nGCGt1PeKpRVKwqb8J1mV+k5MD8acTCQMfGHdb4JyYoUtpUseaQxhgJgAUkvQVrABvk9ABnUIqVvMghsCcJ3cuFeKU+yuV6FV3wLpcVfNo7GxxI5eBo1ycANpIYl5wVAmERraU7LpkwHA3eE2bEKrn5GjNlM9oGSx++DZUVsMP9eYXC1uKAp2sQOTAy7kAM+2/Q6S6RU7jLwmlfR91atkX+2Af3WuGkm7zPfYR1mOVpQB9uhIDp4tiyzkPgcPWZB3DL/yk7x+EcHnhbZzN9aqksc7aSrNOwQIEQbye2CFvo28u4Iu3gXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(2616005)(186003)(508600001)(8936002)(110136005)(38350700002)(38100700002)(66946007)(66556008)(66476007)(6486002)(8676002)(4326008)(5660300002)(2906002)(316002)(83380400001)(6666004)(26005)(52116002)(6512007)(86362001)(6506007)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gbDvlV8lT71eo3YG1enJtb+oV34i3TkOVc8mOdm9vOz3CqIJGxmNsELQ+XAs?=
 =?us-ascii?Q?5J/5nRfN7i9sGLM+ZoUIQQ1fmlhScT7RSCSCUXROJRXnzItvAQaTlHvNO8rO?=
 =?us-ascii?Q?di3juegFlx1vSN4Cj1UMGrKuztcNW2gN+6skfyJsxG763R+W9aYZqIdFjdDG?=
 =?us-ascii?Q?KV+VdnVPO4nWz2pN+82f4RCPQ8v+V8QBf0Jm4mcgSesQxp/Z9eYnqXwRvrbo?=
 =?us-ascii?Q?CbuxLKTvWY5hV9zRXjdoXTSiNVw/yJueVNPeHhCCglaQdsxTUeWXSEkmK3xN?=
 =?us-ascii?Q?BTccbNmkIZdMq9sBnj83u0eKyODmhQQoEjoBHVNfIiVkW7pJdvv/jk1+f9Wc?=
 =?us-ascii?Q?Pu29hEMizaiiIPacg2xKER50PpElUdC0arJXkZ1t13drSdQuGEV2zagYML1B?=
 =?us-ascii?Q?iMsRV1Y+2PGoyhP58uu9dmfLhFn2OecitAXINCYF466JlcOBh2Q9OVvZc3E2?=
 =?us-ascii?Q?qjGTC8e9w+s4psNI1dAE0gF2vTeVx4ykGkLacO6EyNUAg1DWgKDJ/IDT+WKI?=
 =?us-ascii?Q?Xog3D3goJL6XeDmhe7lS9P7WiXoF65hDUlee1WAOGC900Zoe7kuhB2U0A/qd?=
 =?us-ascii?Q?oV/TI5ObWMotleuSkH7eNzDITzwheGTPUB86tT9Ev6wDWNl5XOU4tWmzVVJo?=
 =?us-ascii?Q?+8fXICLi4KuZlPXZR+MIvU37YieN+rwEuGoFOcB53oe6/qjJlbIYe0upk5W+?=
 =?us-ascii?Q?79M7lUJ//u8ODkNfcoHa19C40KNHW8MBcFx4yL5WTFuNu9GTTAVBMOavusFf?=
 =?us-ascii?Q?dLzcdC4kI5bM+1ep5avTvay0FcqS9uaA8535YrcoQyoeErlxwT9ysHZrjryX?=
 =?us-ascii?Q?yJtFpAStK/kf7S0N16P6Rw61Ctnm873ieSbYDOgFjP7DMvgB+MZzQDRarx6T?=
 =?us-ascii?Q?4aZ3knf1hw2d3vL06y250LiiKNz18F3eNkjHVF/l3Ck67HWOn2P6w5XLiTdk?=
 =?us-ascii?Q?IxVkNvxYaj2gCnxgUwA/4+4H/gWOYd6A5flohQS+BepWEdU7mfeblMrV2IH+?=
 =?us-ascii?Q?c83hlyG45f7Fc1ZYA/YfYicmqowcEGmBhaQTO+mp+SQaXx5qqyi4Whvllmca?=
 =?us-ascii?Q?9X801BmPq3J4csXTqmqbkUWGOBYUYBMyqoPTdCK233D0NyXzCIh4RPnAHuzi?=
 =?us-ascii?Q?O4OqtohQzUlH839YQBJKIxFjXHGMQZiwwwYwEzL2Kh8nyZC96qxohvML3N/n?=
 =?us-ascii?Q?m8P/AMklEYmNDQuw008TdM2YQHZ9FzJFCI9wzqHeKobhiLS/cxM3tw/AmFvX?=
 =?us-ascii?Q?mlYIeSsM6I+UVoj4uCL1YocrjzNZUJZpGTVdIDqTBmbJydvr+6xfywSw4eit?=
 =?us-ascii?Q?OmkmmvGM8H9yuoEbIw6xr41mJ2Mt5bVc/e7yCDlmHWtKlshRmf53HP2ZKnEb?=
 =?us-ascii?Q?IvfhXebVqyccM5g0PiXPjdQnOL+VQalEyEWmmgG0aiRJ+tugJyphjTsScGUZ?=
 =?us-ascii?Q?8gfD/6jy+uiDwUnxF3KRN4PeqXv0dO0yFB8ejJUGqT2lQEzkvVd4tXnpgSf7?=
 =?us-ascii?Q?q9Zn6d1Wb5wwr5voCVby8V53W+uT49WQnHT5wMxeIjKr5SYKofABPEw24pWy?=
 =?us-ascii?Q?xiveIknpVlx9Ax4zccm1AVPTD10M7dNc6FwkapCuSi91Lh1QYyt/hNlw5ZS6?=
 =?us-ascii?Q?L/CYNWzNbOsg/K8QPysYYD/DCAMJ4ew1wHvIDXtU+UNu1j8iDBiOB8AtqwYf?=
 =?us-ascii?Q?Yz9w8UyAvihVKFeXYHPh13sSZgIpA5goHmARIsxGerWmhdwBuTkBqlZLjVOD?=
 =?us-ascii?Q?QTetUw98mQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e20e5f-8c80-4538-380b-08da4abcf503
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:41:05.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYJXOSKKVkAvF14sWK9Hp6paI18uXxV7ijHXAq73bsuf1jgPtb/CjjRfYtDuN52zkD2V5AgP0gAZ5Z7yPLxZZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3421
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even when the eth port is resticted to work with speeds not higher than 1G,
and so the eth driver is requesting the phy (via phylink) to advertise up
to 1000BASET support, the aquantia phy device is still advertising for 2.5G
and 5G speeds.
Clear these advertising defaults when requested.

Cc: Ondrej Spacek <ondrej.spacek@nxp.com>
Fixes: 09c4c57f7bc41 ("net: phy: aquantia: add support for auto-negotiation configuration")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/phy/aquantia_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index a8db1a19011b..c7047f5d7a9b 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -34,6 +34,8 @@
 #define MDIO_AN_VEND_PROV			0xc400
 #define MDIO_AN_VEND_PROV_1000BASET_FULL	BIT(15)
 #define MDIO_AN_VEND_PROV_1000BASET_HALF	BIT(14)
+#define MDIO_AN_VEND_PROV_5000BASET_FULL	BIT(11)
+#define MDIO_AN_VEND_PROV_2500BASET_FULL	BIT(10)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_EN		BIT(4)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_MASK	GENMASK(3, 0)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT	4
@@ -231,9 +233,20 @@ static int aqr_config_aneg(struct phy_device *phydev)
 			      phydev->advertising))
 		reg |= MDIO_AN_VEND_PROV_1000BASET_HALF;
 
+	/* Handle the case when the 2.5G and 5G speeds are not advertised */
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_2500BASET_FULL;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_5000BASET_FULL;
+
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_VEND_PROV,
 				     MDIO_AN_VEND_PROV_1000BASET_HALF |
-				     MDIO_AN_VEND_PROV_1000BASET_FULL, reg);
+				     MDIO_AN_VEND_PROV_1000BASET_FULL |
+				     MDIO_AN_VEND_PROV_2500BASET_FULL |
+				     MDIO_AN_VEND_PROV_5000BASET_FULL, reg);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
-- 
2.25.1

