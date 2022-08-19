Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C2C599683
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347230AbiHSHsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347244AbiHSHsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:48:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27635D86C7;
        Fri, 19 Aug 2022 00:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV7Wg3pVKqGqeBhPbwZJp7MMNhriBOc6nTKtLZ06cZkNPtyRcv4Q3aJIXYejOu7A0SPcKaiVF0u0mJI5nvKOdq6pn4lgN6mDKNlqLBjATWbLgbsM1n5LloE6i/UQ9fDtO8S0Cm71URFrIGiSNzDNaUBcptEgaKiZwE80m8VBaFpaebH1YXJStmHRfTWnTQ9FpooGB73RZUpW2gr4AplRTGjYav5iAm1lRi1BKNowdvNyVQ4q6nB+FTVE0NOMgOJ5/IrkYCa1i1g4bJiBRCquiO/SdKMjn3D+6JzQ4Ra2A9hXEJN0ycRWrnpmrao40PAgq1zUSNz7jb8ycZ22c0ZtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQayuQqcYOLEuaoJ0aqC1ijQ2YOcy94he8XSRttfRVI=;
 b=fI1g0N4Cs9flkUGsc+zyvVNecit9GfAItn4B48hhSiUoD+JpH45PtleRb7VV9NPBooD7mVdabYjpH0VTaUtg6aKeOWL7Sn2nz5dhOPlLhNl6gg6l3NEN0mpMtEb2ZhIwyYQwFK6UpcAKEhFSFRkzi6wUn9yky9uVgGwlkgRDvQ0GGACS/rKiKiokJ2uUGvNuBsQQm/PfWxPXdCPhR70akfjQ8siQ3thIRZ8hqrZoX1m+fiBS8ztZ6WbNthTIMfPeOmOglZbNbe0tGlQtbGRd9/qzIsoRt+R4bLyqr4sOZKErfVZ7DtS6m4hRfP8u23vs1oqgrgwqOQpsJW0ZkPHmfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQayuQqcYOLEuaoJ0aqC1ijQ2YOcy94he8XSRttfRVI=;
 b=W88WqY0QSt+4p0543HB7oeDLPHR9QsvSar0zMEat7BMNtkz80MTM/Fi1mMncdb6mJJ7ai6FMpXlSX5MW6NjXaEmk5o0jaF+i7KAhbG1KiIxpaSgXnOnItS69kU72sdE687HEGZtLu1+qWi4IxvM09LThWcmTEQQNAiGmuyv3V0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB6238.eurprd04.prod.outlook.com (2603:10a6:803:f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 07:47:50 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 07:47:50 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phy: tja11xx: add interface mode and RMII REF_CLK support
Date:   Fri, 19 Aug 2022 15:47:28 +0800
Message-Id: <20220819074729.1496088-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819074729.1496088-1-wei.fang@nxp.com>
References: <20220819074729.1496088-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0122.apcprd03.prod.outlook.com
 (2603:1096:4:91::26) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6f4c99c-0bed-443f-7dfe-08da81b71d68
X-MS-TrafficTypeDiagnostic: VI1PR04MB6238:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmL4sF0oVQtrEgd5kNkr709diP4CFZgHevzHv+mOBgWNR7Y8jybltnsC7/sb9kTnCZCoqY399V+rqxA5DQAdVeoPLRo/Puj6tmq3kaPah+Z6Dq1H77gfjEGDpKtWU+unmpE6lR7ETCqDMWgwdDKHgpS2ra1kMCsyu1akAgEWacEcEkH0aB3h2z8qQv6n/uJ1E6M9idOZlRtg6SnBpOL9bng627iUdiYDYuEKrx67DIU2547KOzwwR5noXKzY3ZIKiPlPwQMww1MHgTbmZahE7a09HVflkrhzeAuRTlXWK3su0BE9A/i9djIv/mMobofUtUdudaD1hceuEP7qfy75NHY4CjWhxZGcu+HJ5YJrNs7CIq4Fi7ZNoOznaf5ihqP7+F48z1Th580hF21oWRPDz1GCsn57njgOGsMPaQdBHuSeLBTgOC5de3ufYi5Hwp1Ggc//SfwGbsVcCs5hDDlv8fcMltpJ39nFVOb/7w7a+XmW/0Md2UWqM/DjsrxULanp4SHcZcavfifRcNa5Intu9nqGHRu8fPojSGz962tDcgwABMQ4c385kJ6kV/hcuSFlZzWlVmycrjZuNgSWPSarAZ+4vuaKyN04z3hVwInpCj42CUG6GDEgAwsgE9wiVWQjErXEYWihrrHWuZ7q9TnlfAjLxrB2iV1vB6ih7soKZGnQBDENy4eiYG7c4XQ6ZU90mFLfjddQd9g7MUlmydDf2+I9JNpemH+5cYay0rhwohl6HwbLssHbMZ3bE8wlMdXicSIhAD8TxzNNcwNwRyM/EH0sjqk1C4c3bxd9TyIyV/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(921005)(66556008)(66476007)(478600001)(6486002)(8676002)(66946007)(2906002)(41300700001)(86362001)(6512007)(52116002)(6666004)(9686003)(2616005)(1076003)(186003)(26005)(7416002)(4326008)(5660300002)(8936002)(36756003)(6506007)(38350700002)(316002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PC2+My2SEif23aULljofHCvPz2ihaAU84qF0f8oEaCUuDlLH6EUGyRfHyGnM?=
 =?us-ascii?Q?dw6elgbDG9DusNY+6HIV+RBDWA6m66wBR0GjqlV50Gyy4kCgAl0h421Lzory?=
 =?us-ascii?Q?tcO4F9FKMNRXt0EwFfphd/AtO8N0XnbgqhsV5psOcEZxj4yp5mtGB5IWbdek?=
 =?us-ascii?Q?YT4Jg+PbGNef8C6j50Z5pahsjaMBRYWqrpGfjCBOcFEmnW4KBPu6yYgGM7Sj?=
 =?us-ascii?Q?/osOQOgVIz6ohj9tVQvzq2Hh6Me1goY7E6CIBQ0vrtiNtj9RR/nvFPAl1B1Q?=
 =?us-ascii?Q?OvADJ1Tz4xTLDvmr7PRVm3WvHLLMIm7/5OkX1/MkGZrfDNQvUk24hX4BM500?=
 =?us-ascii?Q?ZBknNQ2Hyfq9q4QqgW2TQ5HdJwdPi4rU4mLrtahdhfNe9HQsRk33GLwFkNcr?=
 =?us-ascii?Q?Gq5mXL8lJZy5o0vhOyYg5qQfNSdx3bCMWx+kV9WTJ9KwyVZjrGfmwhoAqyb4?=
 =?us-ascii?Q?llCA0bR213MpvgKC8Amd2x06kI+ccwlCHxriUdqsoBV9hUSliZgbtBQPyWrK?=
 =?us-ascii?Q?US8IQC0B5N8ZOs3OKVUk4fZNNXbGu6UPRpBxDZGHb6PzAvcIcXb57WaPL1fM?=
 =?us-ascii?Q?3YSMxq2To7GMresOCwHIFU712ziRh0ZYwwxVEdNOScTRWGmtSMRpqtWF7QYd?=
 =?us-ascii?Q?s3bRFIvTXIHPk2tj7UvjdYhVdp6zykyZ/GNGltOacWp0o6haCq62ATg167PG?=
 =?us-ascii?Q?Wgh1sTeuvmVQ4ADcFemLOAJasIQeiU1ISFvUDJzIBWg+rxljvA4xr/I5v/A2?=
 =?us-ascii?Q?sNxxK/V1AOLGuXpmgOVzqR9BrN04T277WwH7S1qunshkD+AbK7EISG0o4wgm?=
 =?us-ascii?Q?Kh6QqSP8n3CuNxK2ox81TUASQEMWTTOr0yW6cAhVmPWYMyXjj+ndjOwHZCHS?=
 =?us-ascii?Q?PipAmSsigliBgWrwCgBVZg340279ffN0OK5IwOr2pBPSTw7c1HxfVk4Iupy/?=
 =?us-ascii?Q?ljpCi6TtrT/tt1T2jvVGGzDo77VtCxrkgGEphpPWBgGtwkYMIZDDGZfNBg2C?=
 =?us-ascii?Q?3juRQX8OukHqIxJ9H9FDWpipsLbBE8Vt9hKj6ojHIFyICtvpuA8SBaPTKPOx?=
 =?us-ascii?Q?NGWu2nonCzwDWZFGh6K4eG4dl9Rj1OxGew1/hNcCnMPM5pmiPUqmNvTa3/Gj?=
 =?us-ascii?Q?Sj58ggpjz2EPJOarjMnw0yf8Ur/BDLQAa47dxGepdLHqsKAxoNgMDJVk1Asr?=
 =?us-ascii?Q?RKggiMKtZoBBUEvTgqv7muOIv3Qt/b2b0aoJ2GWTgOTykLrSAvZ5KZYVC9vv?=
 =?us-ascii?Q?qbQt7EnWKfvqrE5oLyNb3VOf0Y/h9nLpnpB3dv6YnzAoOjyVn9PPr6T5gJ90?=
 =?us-ascii?Q?SMcT+f7JnbClIXVZYXcK5bjs05tzRhkAZZmRdI1lWjRzwWo0B/NIresGRY23?=
 =?us-ascii?Q?wg1Iv+uWtbBIko//OdRoUjVznSe189Vu3MXuDLEQ/CRMDNyjOA/XthOheEDg?=
 =?us-ascii?Q?loqYzAMpHuOG+JPjWs+DXAURPzh6ICYQ4VOjzM807j8RoFYN+LuI5Pt7cxfC?=
 =?us-ascii?Q?pi3NYo0UUxQHawu5Pz35SzdTGSob9GO5ujaM4pFkbQFaJl56ubGYL8eFTKtx?=
 =?us-ascii?Q?65uQXUC1sNZAuOFhBXDjJk595KAQq9zQrZIRp7jk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f4c99c-0bed-443f-7dfe-08da81b71d68
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 07:47:50.0606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: deTyQeDxLyPaXpmKZocoXAM/gFgMoOHC4ZRaCITALrHIVOg2zNOfplVYvkYXFdWiUQK/JwSEtdCIEl/WYQjN6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add below features support for both TJA1100 and TJA1101 cards:
- Add MII and RMII mode support.
- Add REF_CLK input/output support for RMII mode.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/phy/nxp-tja11xx.c | 83 ++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 2a8195c50d14..487c881d20b1 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -10,6 +10,7 @@
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/hwmon.h>
 #include <linux/bitfield.h>
@@ -34,6 +35,11 @@
 #define MII_CFG1			18
 #define MII_CFG1_MASTER_SLAVE		BIT(15)
 #define MII_CFG1_AUTO_OP		BIT(14)
+#define MII_CFG1_INTERFACE_MODE_MASK	GENMASK(9, 8)
+#define MII_CFG1_MII_MODE				(0x0 << 8)
+#define MII_CFG1_RMII_MODE_REFCLK_IN	BIT(8)
+#define MII_CFG1_RMII_MODE_REFCLK_OUT	BIT(9)
+#define MII_CFG1_REVMII_MODE			GENMASK(9, 8)
 #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
 #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
 #define MII_CFG1_LED_MODE_LINKUP	0
@@ -72,11 +78,15 @@
 #define MII_COMMCFG			27
 #define MII_COMMCFG_AUTO_OP		BIT(15)
 
+/* Configure REF_CLK as input in RMII mode */
+#define TJA110X_RMII_MODE_REFCLK_IN       BIT(0)
+
 struct tja11xx_priv {
 	char		*hwmon_name;
 	struct device	*hwmon_dev;
 	struct phy_device *phydev;
 	struct work_struct phy_register_work;
+	u32 quirks;
 };
 
 struct tja11xx_phy_stats {
@@ -251,8 +261,34 @@ static int tja11xx_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, changed);
 }
 
+static int tja11xx_get_interface_mode(struct phy_device *phydev)
+{
+	struct tja11xx_priv *priv = phydev->priv;
+	int mii_mode;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		mii_mode = MII_CFG1_MII_MODE;
+		break;
+	case PHY_INTERFACE_MODE_REVMII:
+		mii_mode = MII_CFG1_REVMII_MODE;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (priv->quirks & TJA110X_RMII_MODE_REFCLK_IN)
+			mii_mode = MII_CFG1_RMII_MODE_REFCLK_IN;
+		else
+			mii_mode = MII_CFG1_RMII_MODE_REFCLK_OUT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return mii_mode;
+}
+
 static int tja11xx_config_init(struct phy_device *phydev)
 {
+	u16 reg_mask, reg_val;
 	int ret;
 
 	ret = tja11xx_enable_reg_write(phydev);
@@ -265,15 +301,32 @@ static int tja11xx_config_init(struct phy_device *phydev)
 
 	switch (phydev->phy_id & PHY_ID_MASK) {
 	case PHY_ID_TJA1100:
-		ret = phy_modify(phydev, MII_CFG1,
-				 MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_MASK |
-				 MII_CFG1_LED_ENABLE,
-				 MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_LINKUP |
-				 MII_CFG1_LED_ENABLE);
+		reg_mask = MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_MASK |
+			   MII_CFG1_LED_ENABLE;
+		reg_val = MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_LINKUP |
+			  MII_CFG1_LED_ENABLE;
+
+		reg_mask |= MII_CFG1_INTERFACE_MODE_MASK;
+		ret = tja11xx_get_interface_mode(phydev);
+		if (ret < 0)
+			return ret;
+
+		reg_val |= (ret & 0xffff);
+		ret = phy_modify(phydev, MII_CFG1, reg_mask, reg_val);
 		if (ret)
 			return ret;
 		break;
 	case PHY_ID_TJA1101:
+		reg_mask = MII_CFG1_INTERFACE_MODE_MASK;
+		ret = tja11xx_get_interface_mode(phydev);
+		if (ret < 0)
+			return ret;
+
+		reg_val = ret & 0xffff;
+		ret = phy_modify(phydev, MII_CFG1, reg_mask, reg_val);
+		if (ret)
+			return ret;
+		fallthrough;
 	case PHY_ID_TJA1102:
 		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
 		if (ret)
@@ -458,16 +511,36 @@ static int tja11xx_hwmon_register(struct phy_device *phydev,
 	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
 }
 
+static int tja11xx_parse_dt(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct tja11xx_priv *priv = phydev->priv;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (of_property_read_bool(node, "nxp,rmii_refclk_in"))
+		priv->quirks |= TJA110X_RMII_MODE_REFCLK_IN;
+
+	return 0;
+}
+
 static int tja11xx_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct tja11xx_priv *priv;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->phydev = phydev;
+	phydev->priv = priv;
+
+	ret = tja11xx_parse_dt(phydev);
+	if (ret)
+		return ret;
 
 	return tja11xx_hwmon_register(phydev, priv);
 }
-- 
2.25.1

