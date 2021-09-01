Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EDA3FD620
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbhIAJDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:03:30 -0400
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:24299
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242790AbhIAJD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 05:03:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QN9rkAs4O2pbAj+d02dufU6wBZ7I7RwE4FzXEcKh6sDpdmFKB0juHLyeFRsB7XDsrE8zbCjyzbVnENMlTyQczHmbKcaotvIobY2fiJdGohaLz4kz6YWv+wgI1AUXjw+xahY8G432sBBNRSdvHX4E8Y+ykudSxhA9JtrgXV4DJRVc11oltXRYVVjSYh+nMppP/iYD5vITq2+EEnglDcUuLSbLxo3skopza+sGz/lBmZ4L+ZBL2pWDFwdB2RY5o3QBliPdasg++LHSZ2BHf26arz/yvLc1bVFbd82P0kpfxD4jidzvQdi0E0DHOqayucrc1p4mWe/VWdyI2jKcd9GbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=R2x/8DZO5ChhqJ4d9gxPx4XhstIAUKppFz63go4jvfc=;
 b=KQIy4DpdxoMDJ5B+1weoUhSXOH8MW5HPvfAXs2Up/7e84FfrVwrScn7a0EDm0UPT+mNfzzutZ+kNVZ5ohCZlqgCykMzaSkwnmoZ8RQTH8y7VFEYF5MiS8SoOwX0/P3ivrxnInNMCTSzqEtOWOlpViACRshjZJ40R0dFj3BJW9wo//F7hQi3rMLl7LAfrPgzPwJvDQ5yE6gBxC3EQBwcHjwt/AAQVlhISeNJKSEIqru2eK+bP552TeStHRZDRY6tMxIExy/TGlWCTgKTYK0/9aPbOjRAGsWKXIcraeoJPssCkNUqb43EqRckMtEbxFBmkMDOh9cLJGwTpHdAIzioVHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2x/8DZO5ChhqJ4d9gxPx4XhstIAUKppFz63go4jvfc=;
 b=f/ngLCAoPpqX2Ji11frtuTVib5stvD9Bo+NPHT4lffZ52/ZqPUpwIMUB3zMsTMTc1Eo2WBsA51Fvh3FrnlXQF+Qa6DtEX3ZhxN7yM263Ck0y0xXmoFEzHgnxVc5S0FQKtDBhhRuCfAO94gSFYAemlxay+AzZlFDYYIKtiUqB6jc=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8430.eurprd04.prod.outlook.com (2603:10a6:10:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 09:02:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4457.024; Wed, 1 Sep 2021
 09:02:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-imx@nxp.com
Subject: [PATCH] net: stmmac: fix MAC not working when system resume back with WoL enabled
Date:   Wed,  1 Sep 2021 17:02:28 +0800
Message-Id: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0197.apcprd04.prod.outlook.com
 (2603:1096:4:14::35) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0197.apcprd04.prod.outlook.com (2603:1096:4:14::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 09:02:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf975c2c-fbde-471a-6bc4-08d96d273a53
X-MS-TrafficTypeDiagnostic: DB9PR04MB8430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB84302939B7D1A6C43E94559FE6CD9@DB9PR04MB8430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KV+oStJChWBmlqb2M9U1VwbZZW+ll+3RGDJTcTx25LdfH9wQC9GrGJ/w1MiEWtKIs0n5zW0m1V7J0SrQ0e/50ttLfEE0wsE/tJc+iTm6qDS9AihRr0vkUQjDX7fqiyjl3fAQ3ITkS8DYRrD+LzkxBg1G7NGWvL87vyDpJMRV/28pIGbSl7nqHIBchJsh6fYgX8wZMPfkGMkuO3PUUMNCgwG4zWWV4TXkzCgcvhxUOBwNdvxEQw77zOShHMD2yGIzUCl21a6kF+ty2RBjwYVwToJn0TOMW2+9C4s5PZQb8JuoT5aubtdvPhXqiq+f0Yr/3gjxHYGeHrW5pudJU3PQoYTL/yS4FDOYS/mZQaXgazgT3jcVhpWT1S1431wIbU8hDizHs9amFukEThQpSc4Dhoc7oBGy3ru1QCtc4KixlqOoyGAr8u/7jdivDzpjSJv3IR6ZlUMvc12g+JX0sjcThHxOQNWpt7Ds/oETUm7ZRn7d1sKNHP3RR3Gndha2vgNEbGL/+Hiw4QYlvF4SsxutR6gIGKYsI4ih894ldx3oQ5noZ+pAP7y1aFDoT3Ym8FeD9HKVYsydXNgLxSuCL1ETGKGkFUnLFtLFAPvvHFxyV/3Jz+PJHONfCkMiGGxH4el5rac/x83Yo4WwVQU6C0JWpfPJLl/84cN0XotZz9V8s+Q+jPqU0hT5ffFfacEofUYYGgMMvcipApSoKnM3YdlI6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(38100700002)(4326008)(38350700002)(8936002)(8676002)(2616005)(66946007)(5660300002)(36756003)(6486002)(7416002)(316002)(66556008)(66476007)(86362001)(1076003)(6506007)(2906002)(508600001)(26005)(186003)(6512007)(956004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YYhb7l/RiEf0/CgOQrubNnN8shaAHnwpdyEwka5Yp59XcKr6ng04LLAxxWam?=
 =?us-ascii?Q?bj294d9Cnu5mV++bG1yPbvvyr0xo+XExmh8MS/RNDz52Dw/vLDq0zzVEb0/l?=
 =?us-ascii?Q?wjzXRl4HvuieGIWXZX5LapJc6sxehvh1tmVmJQUUpxVOUUC5i1ta0a7UAPcD?=
 =?us-ascii?Q?gP9xvgt0OuEpWgLmMEiGkxuofeBX5Sw8laHy/4nu8Zr9m5Ecfy7QRDUh0k3a?=
 =?us-ascii?Q?vsrbJYyYKICIfV1PGKG3qzIMiUcEYAJfWKP5PnDzuRC7GOZIOztpcqGBzAFF?=
 =?us-ascii?Q?AlgWb0WVbxW8NLekZMWFGtIGHQnvZRe2UBuhLBv9vOvVdYywesLL+hSoWC2v?=
 =?us-ascii?Q?ATgQHieI44AAyVeN8sIVUZRzRF7wiycEnmGvMDp/r9C7gMMvxNQO7H/PjdwL?=
 =?us-ascii?Q?GSxa9Wb8hgbQ2wo0ZoQbQXFqoNj+qVR8r2CtDTB8ssKuvCe8Pfg/KqfkAy2D?=
 =?us-ascii?Q?Y07w9MBbwJKRBbkt/Us4ZsYNZ9CUhzLOE5i0SZT6ZodbmP5w5MhDvymYypJq?=
 =?us-ascii?Q?SZO9yOVoQHOKkGJB+4iAZcB0etFRKjS3GVVnLYlrFL9nn7Js9yoy77zK7QCC?=
 =?us-ascii?Q?sGKByVGGSUfQHeL2ncTshLuoAqmXt/OUfWOn9ZWAeKvBMRO3CjAR7pvG4SWP?=
 =?us-ascii?Q?JYRtqf8yyApa1KkcQmCQbm5q6eUscnC+MQnH/hXkqhPfDOVUCCKY3wZ3azmV?=
 =?us-ascii?Q?UgFY5VjpRl05PQjGXKem/Rg62K7DAuqiBlXMJvc3v8i3RTViyIr+QbBSMVCs?=
 =?us-ascii?Q?Ubw1299TIWZLsFqd6ON9KfQzOsTfHCFuczQyQI1PJn5mC6o8mruBTVXV8uJr?=
 =?us-ascii?Q?oUdFw9l/gMyQDkga/J0eA85xACEXvYCPO10GDc76kdMNWX6Nf4hRKDnHpyJs?=
 =?us-ascii?Q?bXLB4/ZRJq9Xq8f1XlAfxKyw08dg+hR3T2d+Lqil25OqYA70dUGo8lQIxVUT?=
 =?us-ascii?Q?Cc5pv2iSFfEWtmzJJ3nd6tIytQgXlSzAaquo6A6qOJ7drgAmNLS38Q7PjrFV?=
 =?us-ascii?Q?IlwulJuj2NnbFMiolvuN+gxNx2JgW3ul8L8n4M++YMaMPca9yABzK+bfUhEI?=
 =?us-ascii?Q?SSw7f4oVZzm22QW05OD13groXpSwa3JkA360lOLK+Bky0VpMC41jlmZsnLF9?=
 =?us-ascii?Q?6Pmg8jyuDGhb+0FvEhcOveJfl24rWzhlMPSvzpHBD63DJIJzz9EwrohEjtE3?=
 =?us-ascii?Q?alHmYhGHg2/Z418jqoLS3FpIOnCuM8aOXpW0UGuaggy+bDS8nuYMyvswwa7B?=
 =?us-ascii?Q?pXzfsVePAvvn5izLm6PjTkUEpw3c92mpEPdl4pQ6q3ywpIPtHJfAhuIQUf/b?=
 =?us-ascii?Q?+LKTmBxFYjjIXAO9WMxklV4y?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf975c2c-fbde-471a-6bc4-08d96d273a53
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 09:02:30.1195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYELMACoI+dnFA5jaVk9vQ1SfmAHmuiPFaDCNKdOqVa5aaeJTZO3ZYUGQoi4rqm9u7pl0yYyZpO4n9g2xKRLvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can reproduce this issue with below steps:
1) enable WoL on the host
2) host system suspended
3) remote client send out wakeup packets
We can see that host system resume back, but can't work, such as ping failed.

After a bit digging, this issue is introduced by the commit 46f69ded988d
("net: stmmac: Use resolved link config in mac_link_up()"), which use
the finalised link parameters in mac_link_up() rather than the
parameters in mac_config().

There are two scenarios for MAC suspend/resume:

1) MAC suspend with WoL disabled, stmmac_suspend() call
phylink_mac_change() to notify phylink machine that a change in MAC
state, then .mac_link_down callback would be invoked. Further, it will
call phylink_stop() to stop the phylink instance. When MAC resume back,
firstly phylink_start() is called to start the phylink instance, then
call phylink_mac_change() which will finally trigger phylink machine to
invoke .mac_config and .mac_link_up callback. All is fine since
configuration in these two callbacks will be initialized.

2) MAC suspend with WoL enabled, phylink_mac_change() will put link
down, but there is no phylink_stop() to stop the phylink instance, so it
will link up again, that means .mac_config and .mac_link_up would be
invoked before system suspended. After system resume back, it will do
DMA initialization and SW reset which let MAC lost the hardware setting
(i.e MAC_Configuration register(offset 0x0) is reset). Since link is up
before system suspended, so .mac_link_up would not be invoked after
system resume back, lead to there is no chance to initialize the
configuration in .mac_link_up callback, as a result, MAC can't work any
longer.

Above description is what I found when debug this issue, this patch is
just revert broken patch to workaround it, at least make MAC work when
system resume back with WoL enabled.

Said this is a workaround, since it has not resolve the issue completely.
I just move the speed/duplex/pause etc into .mac_config callback, there are
other configurations in .mac_link_up callback which also need to be
initialized to work for specific functions.

Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---

Broken patch cannot be reverted directly, so manually modified it.

I also tried to fix in other ways, but failed to find a better solution,
any suggestions would be appreciated. Thanks.

Joakim
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 98 +++++++++----------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ed0cd3920171..c0ed4b07d24a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1007,45 +1007,6 @@ static void stmmac_validate(struct phylink_config *config,
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 			      const struct phylink_link_state *state)
-{
-	/* Nothing to do, xpcs_config() handles everything */
-}
-
-static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
-{
-	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
-	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
-	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
-	bool *hs_enable = &fpe_cfg->hs_enable;
-
-	if (is_up && *hs_enable) {
-		stmmac_fpe_send_mpacket(priv, priv->ioaddr, MPACKET_VERIFY);
-	} else {
-		*lo_state = FPE_STATE_OFF;
-		*lp_state = FPE_STATE_OFF;
-	}
-}
-
-static void stmmac_mac_link_down(struct phylink_config *config,
-				 unsigned int mode, phy_interface_t interface)
-{
-	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-
-	stmmac_mac_set(priv, priv->ioaddr, false);
-	priv->eee_active = false;
-	priv->tx_lpi_enabled = false;
-	stmmac_eee_init(priv);
-	stmmac_set_eee_pls(priv, priv->hw, false);
-
-	if (priv->dma_cap.fpesel)
-		stmmac_fpe_link_state_handle(priv, false);
-}
-
-static void stmmac_mac_link_up(struct phylink_config *config,
-			       struct phy_device *phy,
-			       unsigned int mode, phy_interface_t interface,
-			       int speed, int duplex,
-			       bool tx_pause, bool rx_pause)
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 ctrl;
@@ -1053,8 +1014,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
 
-	if (interface == PHY_INTERFACE_MODE_USXGMII) {
-		switch (speed) {
+	if (state->interface == PHY_INTERFACE_MODE_USXGMII) {
+		switch (state->speed) {
 		case SPEED_10000:
 			ctrl |= priv->hw->link.xgmii.speed10000;
 			break;
@@ -1067,8 +1028,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		default:
 			return;
 		}
-	} else if (interface == PHY_INTERFACE_MODE_XLGMII) {
-		switch (speed) {
+	} else if (state->interface == PHY_INTERFACE_MODE_XLGMII) {
+		switch (state->speed) {
 		case SPEED_100000:
 			ctrl |= priv->hw->link.xlgmii.speed100000;
 			break;
@@ -1094,7 +1055,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 			return;
 		}
 	} else {
-		switch (speed) {
+		switch (state->speed) {
 		case SPEED_2500:
 			ctrl |= priv->hw->link.speed2500;
 			break;
@@ -1112,21 +1073,60 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		}
 	}
 
-	priv->speed = speed;
+	priv->speed = state->speed;
 
 	if (priv->plat->fix_mac_speed)
-		priv->plat->fix_mac_speed(priv->plat->bsp_priv, speed);
+		priv->plat->fix_mac_speed(priv->plat->bsp_priv, state->speed);
 
-	if (!duplex)
+	if (!state->duplex)
 		ctrl &= ~priv->hw->link.duplex;
 	else
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (tx_pause && rx_pause)
-		stmmac_mac_flow_ctrl(priv, duplex);
+	if (state->pause)
+		stmmac_mac_flow_ctrl(priv, state->duplex);
 
 	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+}
+
+static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
+{
+	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
+	enum stmmac_fpe_state *lo_state = &fpe_cfg->lo_fpe_state;
+	enum stmmac_fpe_state *lp_state = &fpe_cfg->lp_fpe_state;
+	bool *hs_enable = &fpe_cfg->hs_enable;
+
+	if (is_up && *hs_enable) {
+		stmmac_fpe_send_mpacket(priv, priv->ioaddr, MPACKET_VERIFY);
+	} else {
+		*lo_state = FPE_STATE_OFF;
+		*lp_state = FPE_STATE_OFF;
+	}
+}
+
+static void stmmac_mac_link_down(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface)
+{
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
+
+	stmmac_mac_set(priv, priv->ioaddr, false);
+	priv->eee_active = false;
+	priv->tx_lpi_enabled = false;
+	stmmac_eee_init(priv);
+	stmmac_set_eee_pls(priv, priv->hw, false);
+
+	if (priv->dma_cap.fpesel)
+		stmmac_fpe_link_state_handle(priv, false);
+}
+
+static void stmmac_mac_link_up(struct phylink_config *config,
+			       struct phy_device *phy,
+			       unsigned int mode, phy_interface_t interface,
+			       int speed, int duplex,
+			       bool tx_pause, bool rx_pause)
+{
+	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-- 
2.17.1

