Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D928374EC6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 07:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhEFFHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 01:07:48 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:58678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229562AbhEFFHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 01:07:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BR0WqujsLoRN7RkiLGtaU5VOhYLR1Yk2M1y8Nt3cnKJQygpTdU5laMe732UEYkk3HHEncq0MbYEETXiJgqps9aqmGWw0hOhA/mnvej11eIbi/k3DfHWtUBJ2m8yuDeh4MPJPswvOCkjE2eb8LebVyHxmyHBKGYWDmddcfg5XjNbETyuhxh3G6hAmcCDLIyxP8l7aC3kyVfuE1lvq7+nKyDSNyVSguN7VpYF6P8tb7pIk0rxDvy9X2bnuC6CpDRiC0zFRGPhrrPLfsaHezZ4fBe3cC9WQbwf4FmeGOKqWPLvgZkgRGcHZzFV7tpnvXgMA+0uYmc2uFQI9+mvRE8wdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLL1z06Fsdjj21dhD1TXEFI2ldYzFLSzFCYLpLWe2dw=;
 b=gq/rFOZ8oRxfK/aLFhHriJJ1Ig8dGo1D+2PRYNZMnSxAuqfPepji45zEnHm74aTK9EJIrCZSQSk16QdR0X5OYvv0DvNSQe5dCNqvt2t80PUN1Rbdh0kiKUzHzoFYra7u8rfqkcnorE4PV2vXeyZPtJ5lRN+S9R2EC9psF6pAq2PJn6QdWQKJipJsHEtjKAmR6ewx7SHR7pooRoNG6sZ5Hopn3A+X41k0NOfibNk8JbGkri2hoJt/2OY5PUryfXd3dDarHTU9ouCK+ujallLIItZ42QrpB/3wodr2DwpP/B4YvwfBbpTVS/cAU2PYLpRSdYak5ZC22Qd5xnn2swB6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLL1z06Fsdjj21dhD1TXEFI2ldYzFLSzFCYLpLWe2dw=;
 b=nX3qGvI1MWXNPzrJLzw/Io9EEUlIQFWHKcuev+WT5segPnf5AHeAp77Gz/LfqvVog2Z15XSWnNiaqU6fmAQh9hWpWfNLZ3niAWyhS/wbWvlvmxJbMmfQT+bV0wTBGkL7Lb5TyAmp0HmDOQ5GPRcvsperFcquv68eN5uoCwEfMLQ=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3706.eurprd04.prod.outlook.com (2603:10a6:8:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.44; Thu, 6 May
 2021 05:06:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4108.025; Thu, 6 May 2021
 05:06:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     Jisheng.Zhang@synaptics.com, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V4 net] net: stmmac: Fix MAC WoL not working if PHY does not support WoL
Date:   Thu,  6 May 2021 13:06:58 +0800
Message-Id: <20210506050658.9624-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGXP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGXP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 05:06:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e21fd0b-f2a9-4ac4-4a07-08d9104cbf31
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3706DC7744778643C52FB21AE6589@DB3PR0402MB3706.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrsERhQ0p8dxqfPsLHJpyk733NuRC5mlWa2JPqYvW4vQzPBKAjdh0Hb9CiDGaJBT5K71JdeDjDcrDxl5ifK+h2GxQuS/k+sL1WQJfte+DqOrk/c+EAnIrBMV5TmEq3bfdWpQ/NY8XRpIPcennA++UidGHVAMvmTdnWQPCVD9lRAzmJFHF1/wwK9F85StR2cM7+PCcGlW9Sg76zdRJKhTm76EeSCNnmRe2BIdCyWpyiw3kjZ1y5vaDsiqZ3UWUlu/AifVW/UNI4ztdRPoU7IDAhHEogC0znxwoNWLh30o3jm5F42LePW2HJwXzaTtqLjdI3A/yzKna913UxMtYBSdgPJFYlgAugSvw8j8m0JcPrdY7pYrZRx0gcoIcrCPd2/vnEStO2GRq0iNVBn6u/ESZLFsdicY0F4WSECMcKyypAjIiV7IEmdJnCTbuwxB7qfSnETUP6zZHbzv1zkJ6BPFPj7vLzEyicbaXx3/SyfkK938s2g3XLDPrwjbv70qkeSj4nbDGjdWH0al6i5acmuYdwDZb9//FZ1H4LMo3obPT3wdlNQ+CBOcBvpS2b++9HraYzBchf3t1iyAWwu0rtuhkSc1bPMBiQyoF9fvWyH7SpuO5z7McMYTC/EBYS3O1pzrulDq+KwsfnuMl3ny/Se9Kee6AoD0KsU+iBn93HsOpC9DUkB7lKBcOrkyxg28ZNBLhz+ZLnMPKljorFrBVZwXXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(36756003)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(8676002)(4326008)(16526019)(2616005)(186003)(956004)(1076003)(6512007)(6506007)(83380400001)(316002)(478600001)(66946007)(66476007)(2906002)(26005)(6486002)(8936002)(66556008)(69590400013)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oFFTnw3QVlXh3geqyhslaUhTRNy9C8b7GZpDXQIrXo94q4BepXPNZ5I+LBmg?=
 =?us-ascii?Q?dW8pprO5zMNVD1Vo5ANwYXUgwVtB7PPPWAV3uKbjwoC3hdQSP7k8+8QDky4Z?=
 =?us-ascii?Q?1180iODxdV6u0qq8E/kaO2WspFO/aivzi9CIaXTelJgfDCkupDTGAl5LMkAZ?=
 =?us-ascii?Q?hm/sRtp2kXes15sfzXWMO22/RIF2HTyQT2oYeH6Va7x+d/NRLTjmFJjLwh7D?=
 =?us-ascii?Q?8/hw+uNprB9x9bqizxB2yIGGwmn7XHkcpKcQIff1lIgrUMzrps7ez/FXUwsE?=
 =?us-ascii?Q?6k3N4CtPVt3LfqkzSZr/rOx0i2y8SidfCia760l5vx4ioYspn4m1eWsnIg5I?=
 =?us-ascii?Q?cUkxXYLwBnD2pU+0c+7ie+n1zo1KQp4jNjyYLyXkZSc4f9u8mdCJPVbklQjY?=
 =?us-ascii?Q?KrVYIzNjSQykqXLm8Nv2fQx6M5vvv+TymWbDTO9ZJ1BwSU2Ikz941MUU3/Gk?=
 =?us-ascii?Q?pfo6Tj87p9s1wqSfjKdi+s/K7hQYWDkeZs1sgvsevOwYHFcdyxH+uODv46W4?=
 =?us-ascii?Q?1iT2fRvefCKp5lkzA62WA5HBVV9b6HoRUIZcVp8wg0x9reIGhbp3ulPcTKEY?=
 =?us-ascii?Q?PepYR917fo6K5ir6w3El1ajrognHPdMALAdqFejkG0pxwyrf7tAA9H4CvOK4?=
 =?us-ascii?Q?64md7U1OXpegXSaCmxQ9BqjsZDjPzeSAZGVYhhTRmQ0M6BsgtjK9LY8SBgBu?=
 =?us-ascii?Q?lyQXRljTVemG8OgxpqdbXc3RBP/PkdH2ZCTv/I7m0cm1clVbns/metEGXfGD?=
 =?us-ascii?Q?qgFiY73sj9kSnmVBW/bEtJD3hZv68Nl3YmGtpjZTxhzaw8eMH79hAmYwr/dN?=
 =?us-ascii?Q?A+QjhzP7NBAof4T019lC4/z3wl6VsJSR3lPCucDcFvAHJydGKh+oz34jldgt?=
 =?us-ascii?Q?Hh9FLmj5nG1oDqI5nOz/Slhy5Tm8ZANmNuX0yVF1a/YYbobMDon7jMs4vUSN?=
 =?us-ascii?Q?pokhght1VXPGilg47qYy7SLd0ftk0L2tIjlbZ8GbdOnXrzQ6i2KjJVon042C?=
 =?us-ascii?Q?5gkn9cS3dLeBJ+qvGzXK4wC0wjJIk7q1/BvwDPrX9h1rMK+qGFQMJTfA9OlE?=
 =?us-ascii?Q?cVkPLOWD9Ron0pUM73quK1ki6ZzckTT9fQxWtqbzi8vbgkGbQ5y/ptcPhCNw?=
 =?us-ascii?Q?cNMLwgFWRm/1oMA3h+vgpo9DaJXH+CJ2+cDQCkU60k6oGHd5T6iVEtMDwXh2?=
 =?us-ascii?Q?cdH7wjlPu/iwJRnVgsFES15aIH8AzS7Wn+Ri0+FeXW7nBXKC7NSyF8NtHnsr?=
 =?us-ascii?Q?rYZMNZ94a1V7b0GqIThtvXC8FkJg21LqbHDq96unp6+gB5kqZn1Vv7niK7hL?=
 =?us-ascii?Q?f3f5XOys34sap+dnfyt/TCLk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e21fd0b-f2a9-4ac4-4a07-08d9104cbf31
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 05:06:46.2904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCMolOvA2tknKAIMf2FULHUHRI1Ap3o13oJrAKD6CM4DGzOJiajuhHHwR0niGFnyfCO8jUjcpSGyX/1HnYM6fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both get and set WoL will check device_can_wakeup(), if MAC supports PMT,
it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
stmmac: Support WOL with phy"), device wakeup capability will be overwrite
in stmmac_init_phy() according to phy's Wol feature. If phy doesn't support
WoL, then MAC will lose wakeup capability.

This patch combines WoL capabilities both MAC and PHY from stmmac_get_wol(),
set wakeup capability and give WoL priority to the PHY in stmmac_set_wol()
when enable WoL. What PHYs do implement is WAKE_MAGIC, WAKE_UCAST, WAKE_MAGICSECURE
and WAKE_BCAST.

Fixes: commit 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* combine WoL capabilities both MAC and PHY.
V2->V3:
	* give WoL priority to the PHY.
V3->V4:
	* improve patch subject, unwork->not working
	* Reverse christmas tree for variable definition
	* return -EOPNOTSUPP not -EINVAL when pass wolopts
	* enable wol sources the PHY actually supports, and let the MAC
	implement the rest.
---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 55 ++++++++++++-------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 +--
 2 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index c5642985ef95..6d09908dec1f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -629,35 +629,49 @@ static void stmmac_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 /* Currently only support WOL through Magic packet. */
 static void stmmac_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
+	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (!priv->plat->pmt)
-		return phylink_ethtool_get_wol(priv->phylink, wol);
-
 	mutex_lock(&priv->lock);
-	if (device_can_wakeup(priv->device)) {
+	if (priv->plat->pmt) {
 		wol->supported = WAKE_MAGIC | WAKE_UCAST;
 		if (priv->hw_cap_support && !priv->dma_cap.pmt_magic_frame)
 			wol->supported &= ~WAKE_MAGIC;
-		wol->wolopts = priv->wolopts;
 	}
+
+	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
+
+	/* Combine WoL capabilities both PHY and MAC */
+	wol->supported |= wol_phy.supported;
+	wol->wolopts = priv->wolopts;
+
 	mutex_unlock(&priv->lock);
 }
 
 static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
+	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE | WAKE_BCAST;
+	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 support = WAKE_MAGIC | WAKE_UCAST;
+	int ret;
 
-	if (!device_can_wakeup(priv->device))
+	if (wol->wolopts & ~support)
 		return -EOPNOTSUPP;
 
-	if (!priv->plat->pmt) {
-		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
-
-		if (!ret)
-			device_set_wakeup_enable(priv->device, !!wol->wolopts);
-		return ret;
+	/* First check if can WoL from PHY */
+	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
+	if (wol->wolopts & wol_phy.supported) {
+		wol->wolopts &= wol_phy.supported;
+		ret = phylink_ethtool_set_wol(priv->phylink, wol);
+
+		if (!ret) {
+			pr_info("stmmac: phy wakeup enable\n");
+			device_set_wakeup_capable(priv->device, 1);
+			device_set_wakeup_enable(priv->device, 1);
+			goto wolopts_update;
+		} else {
+			return ret;
+		}
 	}
 
 	/* By default almost all GMAC devices support the WoL via
@@ -666,18 +680,21 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if ((priv->hw_cap_support) && (!priv->dma_cap.pmt_magic_frame))
 		wol->wolopts &= ~WAKE_MAGIC;
 
-	if (wol->wolopts & ~support)
-		return -EINVAL;
-
-	if (wol->wolopts) {
-		pr_info("stmmac: wakeup enable\n");
+	if (priv->plat->pmt && wol->wolopts) {
+		pr_info("stmmac: mac wakeup enable\n");
+		device_set_wakeup_capable(priv->device, 1);
 		device_set_wakeup_enable(priv->device, 1);
 		enable_irq_wake(priv->wol_irq);
-	} else {
+		goto wolopts_update;
+	}
+
+	if (!wol->wolopts) {
+		device_set_wakeup_capable(priv->device, 0);
 		device_set_wakeup_enable(priv->device, 0);
 		disable_irq_wake(priv->wol_irq);
 	}
 
+wolopts_update:
 	mutex_lock(&priv->lock);
 	priv->wolopts = wol->wolopts;
 	mutex_unlock(&priv->lock);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6f24abf6432..d62d8c28463d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1076,7 +1076,6 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct device_node *node;
 	int ret;
@@ -1102,9 +1101,6 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-	phylink_ethtool_get_wol(priv->phylink, &wol);
-	device_set_wakeup_capable(priv->device, !!wol.supported);
-
 	return ret;
 }
 
@@ -4787,10 +4783,8 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->plat->tx_coe)
 		dev_info(priv->device, "TX Checksum insertion supported\n");
 
-	if (priv->plat->pmt) {
+	if (priv->plat->pmt)
 		dev_info(priv->device, "Wake-Up On Lan supported\n");
-		device_set_wakeup_capable(priv->device, 1);
-	}
 
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
-- 
2.17.1

