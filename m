Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99024596733
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiHQCDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238472AbiHQCDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:03:31 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150081.outbound.protection.outlook.com [40.107.15.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F58A78599;
        Tue, 16 Aug 2022 19:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIc4VYYpGqWbZ6I+XYES+NeUbyRhw2DqzcPjZ4xizL4ER9jBRJbKRPvP1FQ4S8oRbHVzmgDIjRzeKz0AUb+cgNUKjN8I8OGiVQ4VZ1zXCL9auBVwTpPsQywsVT4O/GYB4M2jC4lfsU74+3JVJfn8SOL4+dD3SNALlSFdeaRl2eFfbyd8pX9cM3SDoeFMvnT2lIPtGLS4H2xI8/yMw4oyXafN3M2/nEyydQSdUr61IOBpXRaazCJXSbQPWGdpziWgVJ7hONLnb/+ErQiCyeIxV1ny4RTjdre386xvx09oSIFbLFhoXjnX1iez/+dGSujVqndBCAvv0Q96bipZ2ZQjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YZIuVkZGce465cXus7FRbaMECuNDtV4hEHy5h0mu+s=;
 b=RQmRlSLaJSVihmZv3L9a/Z3neANcYI3MnZaUWeVKHJc3S52Ta2P7ox3cdu/haQy+McegAzwiqpN10RDRaVps2z/7lUof1/5rpnr/JJH9TulItYXUQp6H6COsREiLoVUqO+mcV3kjy1FBrHG5aNHlda3ajiC4ReIx9l900buufIA3LXn9yPAhMwtPX50O4i9h8+3oIbGrxcriGpbC6W2gAd2CXtIueH1uMhVbAElXtlV0fBqrCMujdILiKQ5IIgjU7H0qrN4gqkv6gP1o3ZLJtkl3T136YCMMnaIK5CRoBmfS1EebCIwEiHZQM162lXUUGP/V3BjEtnzX8SDsqcd1VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YZIuVkZGce465cXus7FRbaMECuNDtV4hEHy5h0mu+s=;
 b=oILiBG4s/tXszG5KHnntGRA3P+3J+YI9hyewrUhFJC6TjmDaB6kNvdnDOl9bL5gR2J4fRqtkxk7mSFG8JRUAgDNdSvze/2FkmCQMq7f9/68yP95tmc2khxajWlviQ0qfps3sUyEg3RJpquGM/s6dwjdIWdZpbV3P49CKrp+Fl8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR0401MB2350.eurprd04.prod.outlook.com (2603:10a6:800:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 02:03:21 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 02:03:20 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net 2/2] net: phy: at803x: add disable hibernation mode support
Date:   Wed, 17 Aug 2022 10:03:22 +0800
Message-Id: <20220817020322.454369-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817020322.454369-1-wei.fang@nxp.com>
References: <20220817020322.454369-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0191.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::6) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89f6274b-a9ca-4424-69e0-08da7ff4a8ca
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2350:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bh9kEhQ8G8P+zQ233oqT8C1pDhYuoU60kOT8CkAs5LA4cWGAg3gZRAJFrD/xNHqeuHZncHdcy3zJw859JGpjvNyk1YdQG+5n/hSLeyUOWKd0lZFaTG2fqWU7zeabbJS+q2CGviftlxLhJnTsLb5UsvZaSZuAHgIsWCwPb41WyqVBao+5Cw6mVh3HUxWq5sXgUhlPtYv+sDfTLbvUxmniQnoVL2RznYQTC+E5zEoA9wVo7HImiKtDM+V02h83cLG56orTQZB9TxNv0uaglRMF4dEig334rsdwohQECWd6PeZBkalfpb55elF5/aCbgmj+G7lqo4mSURZdzaPTd2N1Zzt1QEqBD0GcPOENiB57O8Sm+XbBlOgqg8xS2Zm/WaV+0tIFg2uIm+j1u3CnkquSWs/iDy57X4HJndsNNFDsRnna7th34IMEOFNjxgSGhiUo+NrZV6nF+aBpdWtnP7+LYulJVuRUFIvACsB/oRZOHx86DuLCgyGuGHVol4J+hU914NA4o/eFJlBmH5Yo1FBWfrK8jbrNyrgbQ7STvsg7rkxGfuBqNULsuTnksg+dqVPjS4fEhhZY0jNlahbL/hu5AqOVUvXJbnqK6r7qvecxzFPAmL6eGPGdjtN8MH1DUvZXmIsCPQLrThwIph3BSG+MsOoCD9sbRiC+GKIqlWa2oq5GD/evzqL/rcLlgWImFspTdgvcmeiU9/Ek/AlqVauuszhJRs6fi5dLK4lBzHqIjIv5FtlE8BN5ao6l6zLbaOPerreyRTDnT98D/TajBGFaGNvEHr+Wqy2zy5c4GoS6vD3mEDqalS2KATQCMa620ATL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(316002)(83380400001)(6506007)(186003)(5660300002)(2616005)(41300700001)(7416002)(921005)(1076003)(38350700002)(52116002)(38100700002)(9686003)(6512007)(26005)(2906002)(36756003)(478600001)(8936002)(86362001)(8676002)(66556008)(66476007)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kXtZuUuIkT4iVdxCNAJ71WxPiwm8tyAHMHqQWKMQ8WRknxmmt47OvaQV402f?=
 =?us-ascii?Q?VXBs6mi1k2PetZ2S5SIBVQzNh1KhtZ9UWSh2S1UnhYcWJAnuhKnaOSxZ0qiv?=
 =?us-ascii?Q?UwHR4kstim4p8shrqV+qV53kye8l6/AvH2RM8v8aIu9nte73okLs/M2JEK9L?=
 =?us-ascii?Q?9v8QWzgL8qRTgftSBpBnoqrgH3ZZRxHRI0fMSzW+EjHnN9NGzylDQNN5gGs0?=
 =?us-ascii?Q?aMUrHMPtzRyK8V+KbnRslGGdL2y+5dM90eBZkwTAXXcAnE10T5GLMG8QBoTJ?=
 =?us-ascii?Q?IokI0228z8OkX6Eg2QEcPBwZr4RYJksJe4yHcJwkvcRNeuz6LUfVTElVzzp1?=
 =?us-ascii?Q?OtYx7WSOYab4y32eeyW9yVEQszL4xZESTEsFT3zzxwYJnmX4FiI1v+RFz01g?=
 =?us-ascii?Q?/rVh8en5l0MDh7aTFhn3qJGukaKisxitbr8902P9onI4LWz4IBVXHuT3W53B?=
 =?us-ascii?Q?nOtPhTb9tohCVUTISvoD7UMlgQMb0HBIYOLCczpRXBHUGOSDDQfXxsrgqr2p?=
 =?us-ascii?Q?Q9QcYsXJMcUDUJMX9k/DzVmE/vLZXEs5QyrUTXQizEbJjDvKhNlgHA+8gdac?=
 =?us-ascii?Q?cdOM9XYPAcIQt8y6lXqmXKN+5cIY3TFJ7/xkmIlFMUK5eCFJU1PMlzhU2sCu?=
 =?us-ascii?Q?KwjY4Bx8FlMvk3XO7CcBBCvfbM8V1OgMjkM4u0Dg9PsVnxfrSLfaSeJpto6T?=
 =?us-ascii?Q?Hqf8ia0UF72ggb5tTHKHf/68HbeNle75rle+S9yJZs0AUNBqsaHH4FDSwUzw?=
 =?us-ascii?Q?L7dgfIhuUYoKlJsq277JvBHzumJyi5LVq6DCaMGv0xnruIm6Y6rpanTMwQI3?=
 =?us-ascii?Q?w/3tw8BDegZJTyqr9SjF7HNeO6qPYSXW8lIFbElPy6VdJmkEztGY+9A50kx1?=
 =?us-ascii?Q?hLY5Y3JiDiaBolICeX8DyqbS5Wkyg/tfyLXUAcrYJjhxQudiMl+lsquALAq7?=
 =?us-ascii?Q?cK/t5cIS1dU/m1wgckYVSQA0AD7CPjA70P+gF+JEzZpYGoqlMWqOyoUr75fG?=
 =?us-ascii?Q?4juJ6iX9dkHfQAm1OPyLpBmeQX+Fnhnw0ER3QRq23pGyRI5H/QM3PKLxs3mX?=
 =?us-ascii?Q?+Vtef3KhbbeMb8YM7vF5pD6yLlOiUKgHu2ujhDiL0en+UBsRX3lC7JRWxhLQ?=
 =?us-ascii?Q?sOxOeawp4PuNGwLIh21T6tpL9KURx4eatcGKJIOVp7WxiSfsIEpn7vJ7opDc?=
 =?us-ascii?Q?qkGz/vknV4vj3KR4lpYL7Al0t8SzGcbOOGHnIf3SSbwKfR78I3vCqBwo6qX0?=
 =?us-ascii?Q?+3N23GGlhl3plBgQBC0E3imalRKq7ZES7s/QIyTaSJR0XFrM6wr3tNKcC2xR?=
 =?us-ascii?Q?3ONlZ4FP+ylRfvkkJ1HMYlD7JjeCnfiETUUtjBi4E5IUqSUORrQZbbL+hg5l?=
 =?us-ascii?Q?/lLvZApfF3uURdozbK39DQ9AAn36LkOR1UOLAzdukZ0ZyNGsN6WOFqziqYzB?=
 =?us-ascii?Q?ZZ/3Jc8qgy/KxJLdXGe04jHz2UauarUKTs/a2E3GVLmLozcsonrkP4t44F1u?=
 =?us-ascii?Q?h4CWH2nUUIf7NduRuIqS3+7zAaS17jINrAzBrsm8eE+oMTv3x3F9uhRAn/RK?=
 =?us-ascii?Q?mDBE3a+nKshefC8sSkTW7Pd55eQY+AzjDWlQbTDO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f6274b-a9ca-4424-69e0-08da7ff4a8ca
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 02:03:20.8806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bf7/GD2Y6R5WrSptU1HJ3bUID1qYPmaLTHq8fu9LEGoesD6fRVQTyKUDwVTqYMUKy0B5OHYiLixZHHzYtatEoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2350
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
the stmmac can't be able to complete the software reset operation
and fail to init it's own DMA. Therefore, the "eth0" interface is
failed to ifconfig up. Why does it cause this issue? The truth is
that the software reset operation of the stmmac is designed to
depend on the RX_CLK of PHY.
So, this patch offers an option for the user to determine whether
to disable the hibernation mode of AR803x PHYs.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Modify the property name and the function name to make them
more clear.
---
 drivers/net/phy/at803x.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 59fe356942b5..11ebd59bf2eb 100644
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
+#define AT803X_DISABLE_HIBERNATION_MODE		BIT(2)
+
 /* ADC threshold */
 #define QCA808X_PHY_DEBUG_ADC_THRESHOLD		0x2c80
 #define QCA808X_ADC_THRESHOLD_MASK		GENMASK(7, 0)
@@ -730,6 +734,9 @@ static int at803x_parse_dt(struct phy_device *phydev)
 	if (of_property_read_bool(node, "qca,disable-smarteee"))
 		priv->flags |= AT803X_DISABLE_SMARTEEE;
 
+	if (of_property_read_bool(node, "qca,disable-hibernation-mode"))
+		priv->flags |= AT803X_DISABLE_HIBERNATION_MODE;
+
 	if (!of_property_read_u32(node, "qca,smarteee-tw-us-1g", &tw)) {
 		if (!tw || tw > 255) {
 			phydev_err(phydev, "invalid qca,smarteee-tw-us-1g\n");
@@ -999,6 +1006,20 @@ static int at8031_pll_config(struct phy_device *phydev)
 					     AT803X_DEBUG_PLL_ON, 0);
 }
 
+static int at803x_hibernation_mode_config(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+
+	/* The default after hardware reset is hibernation mode enabled. After
+	 * software reset, the value is retained.
+	 */
+	if (!(priv->flags & AT803X_DISABLE_HIBERNATION_MODE))
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
 
+	ret = at803x_hibernation_mode_config(phydev);
+	if (ret < 0)
+		return ret;
+
 	/* Ar803x extended next page bit is enabled by default. Cisco
 	 * multigig switches read this bit and attempt to negotiate 10Gbps
 	 * rates even if the next page bit is disabled. This is incorrect
-- 
2.25.1

