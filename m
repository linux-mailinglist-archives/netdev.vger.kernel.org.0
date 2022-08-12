Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C7E590C2C
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 08:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiHLG43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 02:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbiHLG4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 02:56:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C2B9D8D1;
        Thu, 11 Aug 2022 23:56:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oehBpTA5UVNyt3WFXnPN/6Lm+rBknHFZ4JH5HTo8UNTUmTxPWrFdnYttLl5X6p+BfJFZuYQsoLSm80THZKLeM+xozZivgFc6k2KVoiro+Pi69Cz71ooq7I47YsqGeSoMk3gTsWdkYIGaSOVx2ZTD8pq4Dudotv4yjiJ611/QsLphbB/63uVWFC6vCkCsocRbOkvXOVgTOqOWerUHL2rCg8UfbgXm04VuHDhlmVZbX62xplaWy6rr9UK2BdTP0j8kU8Qin1bEKLbmtlv9vv7nFuSR/dMVDPnqgfSmuh8OYSC1T5SgYjKEFXe267KiD5qQgmSynnYLH1mKzskEq5nRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uC7iu7FPx/ZH8Msf4oV764D0qMS6eYVE4N/6eFB2Po=;
 b=QzOM+NYAZdNZO0B20o5lvaXd5Z0AHUVcQ53uGiZuBoj146qCQ8Q2F5yNynJ/+m8BpbjEuBwf7RUSMrJfgHVq6YukK4sygaOaiyoJQv6rdy2odC8oNXHWG5yIKGzY47J3g9Qz/l3o+CO/nwhwA0MthfFsMvIJBszy27zcpUk9Whm0GF659rgZ+nb5eNxcpncMxcjzGMUl3shDfjqT1jOWyMDYE2J/LPiaVZb8HtzIasg3c9boGkFuz6PXtYPkmB1lWmb7TQ3PLVBxEOpvbt3voEkt4SzfkejUnVmt8nsFzmw7e6zVNwb+w4xyI0WtqpTqb5FHpb6xLxsx//MrDMiDHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uC7iu7FPx/ZH8Msf4oV764D0qMS6eYVE4N/6eFB2Po=;
 b=OdO0ChFHsCbTKRE+rLwf5WPtBvIQjvblGzv1JFzU3NGcPixfxvbrDPZclZtOOnUTuIQQTMEibJFzIWB7uRMhoY/XOVuMdCU/wLkjmJueerHRu9jDf0GA6ILE02GpAWgXwYRkBxSOtNPrFEJVzY/Zctr+3r8K6ZWm/kRiM/dvQRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DU2PR04MB8616.eurprd04.prod.outlook.com (2603:10a6:10:2db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 12 Aug
 2022 06:56:15 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 06:56:15 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: phy: at803x: Add disable hibernation mode support
Date:   Sat, 13 Aug 2022 00:50:09 +1000
Message-Id: <20220812145009.1229094-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812145009.1229094-1-wei.fang@nxp.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d906f43-d122-456c-5d68-08da7c2fbff7
X-MS-TrafficTypeDiagnostic: DU2PR04MB8616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKB9iL1rS6PDOkqL+b2uaLxCOiwqYB3mLeF0htny43ZdrOHhp7knkPZxGrgujGdOHNDkG1alsTsWTbhP4L4hXdpWIX9RgT/cRjl21FsXwbkZUM+k6mxXpK//zmCycXs2EnbECjGrqSVE7cLagQ+nZEATLaGETiTtBUQewIwcqRFwdi63nihP4N2L8/0P16xte1C0XL7c/GXAulZgLY80JtUY8E+GSEvPsiu9QJE+WNgF4KZLJkNpw/FfMooLrRq3XTA+0mgQW8NEYjHxmbMcK5FxSXOb4LWlQ0+I5Sv9SvSg0EUzGnKPXAZfZvRPmownXcUQ9sgw8/C23QhmX1+CG7JrYQFuiPiqpWIYhYcriNyAX54wrSOPR+uIH6kiS5wHjzDC1KRRq1RtOCeB2FGlDUTAYfz1tZI8vuefvZWFEGEi706lDxb2l7xd9KfaB4HV/pG+lOfm6b3++B5FR+f9EuUk5yTPGYje7bwmTvo2Eblw4EDi9baApXljiYOm8oMcuHs/sCRqkemFhJPdwvSTBpagsKSe9+I2MqY0MdMv9wJkna624l4S14bZBQmkg6uSVYa3bjkp0BeEELwNJnaGUL0y8KIu0SXPS1we8sBSwmFbqwNKDkQcJwGWFFIyMOqfBFqSpL7wsXGAr9r0UefK7ZNB96AURmPCNxQq7/Hzhq/vk/zm87PipUC0doVzA9nqJoygdUa6CV3I3CGcEWIEo/hQjeNzYFR4I/ox0Hpb7hfNtcHTZjvpj0ZuP6V4mDKHqOvSolHPDbh1IO8n7Yswt6cpD3I9538HaVNDxCFMBSWMlQvs7KBCXCYg4T8fqPwj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(8676002)(66476007)(66556008)(66946007)(5660300002)(316002)(7416002)(2906002)(8936002)(38100700002)(38350700002)(921005)(26005)(36756003)(6506007)(6512007)(86362001)(6666004)(478600001)(9686003)(41300700001)(83380400001)(6486002)(52116002)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EHAx+yaqtIP7xTDCz5fv+jU7znh+KVSYm3hRucKXdUZwMpo8lGPw445VnnPK?=
 =?us-ascii?Q?zVziFmKbUKlrnlN+vujlrU2JZKsTQHcxZ8zExnBY4ahFc0reirLsa72307Qc?=
 =?us-ascii?Q?vEiviWQTPB3pWFb5ZrSgwRvui7/nLAIPqiNs6kbx0tt8WtSyfNfEJ7M3+pJw?=
 =?us-ascii?Q?BaA7Ny3MljN5Z3vHR+4KZRsvXijze6WQSLlNnUELCzgBFsR9CtFtgITaKnuQ?=
 =?us-ascii?Q?LNo4kX9JVu0bQUBgcVKFXNhvDXqOh84keWQUiIf/hwsrJBribsoE4Gbr3/dE?=
 =?us-ascii?Q?acvdju2ZGJQ9mMqgVLbO4WDVfcNsRatg0VeLlTEzRtjB3GxgbvebRLWUBgf/?=
 =?us-ascii?Q?SZMRv93pWMh1SFjiSzpmbHHWTR8yRd8qF5F0LNkcby7o9BntndwrETm9WY73?=
 =?us-ascii?Q?8oyMWkymHcw3jwCHy11buBRT00k58B+Qt/HRVGknXQgY6dekCNKsTvnTLoQM?=
 =?us-ascii?Q?EFyjQjNhdvLt4g+a7/srkxbuAxgP26ieyqzn0Ob7cKgQdk66XDxtknCKpOzf?=
 =?us-ascii?Q?bRihv2Dax/d7Y91xMcAJDg2nLShriDRG4QVm4SjB0W1SFyVr0zBxbAjlJqkd?=
 =?us-ascii?Q?IIwVCw9bDfEXWfhkq3gTB1hFpIZeuN2qz0trrcHH7lngDOKDdsj54o4XMmXd?=
 =?us-ascii?Q?5zuU+sJbmhRbSYtkw5bDrJRsYNUtc8I354wSB1vINMQAIOyXBvdzDfNWOCHU?=
 =?us-ascii?Q?eGKZDPIOhfTQvK/kd6H1/dWkVwdonXj8HPhrznZiKic1TI9UbLs8IHm+hAKn?=
 =?us-ascii?Q?aZKknb4ioO6TA4FRKm7vQ4th2UQTS6USjDFDsoZxnhjrp6H+IG3qZyO0+9ac?=
 =?us-ascii?Q?Mz6V7/YaUTnLjMM4JlIDmbLCNlD74elVds2No/a/bNzEeRUwPqxf1S5SFIP1?=
 =?us-ascii?Q?dpcn+GvHGzSKWX8Z7Tj/waTLgeaDg8mTUzz5rDWBQbZOMfJlxkboSnjSyzsO?=
 =?us-ascii?Q?jjd17xfxTup0ktsLCV+ubLYI2TkHxByEvYoZmVR/L34ZnCCZo7B++G87ftKo?=
 =?us-ascii?Q?AVw9a3ElnwOClgv1HvNJqk86w47pfm9MgBuyu6qOn8KNh7G3viUp4Csf1WZp?=
 =?us-ascii?Q?Zqy6CsbdPrGBLsehKYYYdhDKnmky3vv/fuPR/YJc0wcP5EUVcjzI4U9slPet?=
 =?us-ascii?Q?2PKdWnMaop2rPSv8YPiKX0M0dh5c4TwzWOO/Z2krprgxgJ/TlQHpQmvT8hjn?=
 =?us-ascii?Q?yvEvy8gZxzx/TrNRMHO3rgngYmHcXwQATfYTdvIhPRlFlkrR5oaptmZqQYAG?=
 =?us-ascii?Q?6b4Iw/x9acbBACJ6ZyB3IsJdEiUu3s6bDf6h6iOhxfYBXLOn4fjmwfV2NPXi?=
 =?us-ascii?Q?ayKRKUDzPjazjw6GfBiP9X4lyWhgu5U9bHq2O/lObsGfWqsXLlpXu/LbxvDv?=
 =?us-ascii?Q?/n+mjBjJvId/zfLha2BFLzHidp3TuoXGrJalTjnH3SCnN2MJ45cDtjo1Ud02?=
 =?us-ascii?Q?UMlQCNCodDnRkrg4G/ep7yXgjbRV1Ekub3s7QGcJSZPA/i4YE1ThNUSrSCf3?=
 =?us-ascii?Q?DOW92pbEny70ru6qsJFTyOkfPoJYdTKE6cfUqYrHOYD0Amm4Jx+8DCAGOEId?=
 =?us-ascii?Q?Cx40/Fwdty7gbaixT3Q88cW9XuCAstqkDkEG6yOq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d906f43-d122-456c-5d68-08da7c2fbff7
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 06:56:15.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEkGcvLcXm/nMA9VZzeqYS1eXuzF1lLhut1ZAcRPtIi6GkpgTwXPitJ+rHmI6NLj9uf7QSbHD10BLbR8O+uFww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8616
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

When the cable is unplugged, the Atheros AR803x PHYs will enter
hibernation mode after about 10 seconds if the hibernation mode
is enabled and will not provide any clock to the MAC. But for
some MACs, this feature might cause unexpected issues due to the
logic of MACs.
Taking SYNP MAC (stmmac) as an example, if the cable is unplugged
and the "eth0" interface is down, the AR803x PHY will enter
hibernation mode. Then perform the "ifconfig eth0 up" operation,
the stmmac can't able to complete the software reset operation
and fail to init it's own DMA. Therefore, the "eth0" interface is
failed to ifconfig up. Why does it cause this issue? The truth is
that the software reset operation of the stmmac is designed to
depend on the input clock of PHY.
So, this patch offers an option for the user to determine whether
to disable the hibernation mode of AR803x PHYs.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/phy/at803x.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 59fe356942b5..3efc6df4eb97 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -115,6 +115,7 @@
 #define AT803X_DEBUG_REG_HIB_CTRL		0x0b
 #define   AT803X_DEBUG_HIB_CTRL_SEL_RST_80U	BIT(10)
 #define   AT803X_DEBUG_HIB_CTRL_EN_ANY_CHANGE	BIT(13)
+#define   AT803X_DEBUG_HIB_CTRL_PS_HIB_EN	BIT(15)
 
 #define AT803X_DEBUG_REG_3C			0x3C
 
@@ -192,6 +193,9 @@
 #define AT803X_KEEP_PLL_ENABLED			BIT(0)
 #define AT803X_DISABLE_SMARTEEE			BIT(1)
 
+/* disable hibernation mode */
+#define AT803X_DISABLE_HIBERNATION		BIT(2)
+
 /* ADC threshold */
 #define QCA808X_PHY_DEBUG_ADC_THRESHOLD		0x2c80
 #define QCA808X_ADC_THRESHOLD_MASK		GENMASK(7, 0)
@@ -730,6 +734,9 @@ static int at803x_parse_dt(struct phy_device *phydev)
 	if (of_property_read_bool(node, "qca,disable-smarteee"))
 		priv->flags |= AT803X_DISABLE_SMARTEEE;
 
+	if (of_property_read_bool(node, "qca,disable-hibernation"))
+		priv->flags |= AT803X_DISABLE_HIBERNATION;
+
 	if (!of_property_read_u32(node, "qca,smarteee-tw-us-1g", &tw)) {
 		if (!tw || tw > 255) {
 			phydev_err(phydev, "invalid qca,smarteee-tw-us-1g\n");
@@ -999,6 +1006,20 @@ static int at8031_pll_config(struct phy_device *phydev)
 					     AT803X_DEBUG_PLL_ON, 0);
 }
 
+static int at803x_hibernation_config(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	/* The default after hardware reset is hibernation mode enabled. After
+	 * software reset, the value is retained.
+	 */
+	if (!(priv->flags & AT803X_DISABLE_HIBERNATION))
+		return 0;
+
+	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_HIB_CTRL,
+					 AT803X_DEBUG_HIB_CTRL_PS_HIB_EN, 0);
+}
+
 static int at803x_config_init(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
@@ -1051,6 +1072,10 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = at803x_hibernation_config(phydev);
+	if (ret < 0)
+		return ret;
+
 	/* Ar803x extended next page bit is enabled by default. Cisco
 	 * multigig switches read this bit and attempt to negotiate 10Gbps
 	 * rates even if the next page bit is disabled. This is incorrect
-- 
2.25.1

