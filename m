Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0820292F94
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 22:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgJSUjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 16:39:52 -0400
Received: from mail-eopbgr670041.outbound.protection.outlook.com ([40.107.67.41]:19264
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731055AbgJSUjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 16:39:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmd3BpXUKV2J0c9rv2QRbKq0JFrcLOWT/U6uy1s7CAztttkw6J3kC6J8asYR2P4VTLQsgGRMiTn8d30XiZELOvgXDKSgFzGV9jlcWCLcQpXAy6hvSalxNAEKoEgfXnRLf8V67LREb+eThMFJlmNuoSHZ5YSfW/3tdYt0YVEVL28WpaIpM/iWjIu9/H81eMC0d9hhOCKUniz1MBDaPODfqyNsKczRt3Iei8mhXfN9tx+TYzJtX/qV4581EmKu5CCJhWQk31EoMY+Tisa0YD49IlXlqslz68mJ+bS1AWc7iA5MbyAsXC8vyZ/U34yxcKDcJdzsbmW7uagBz7vwQ5cNtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IsRQBD6VGeD0ZrtHxe0awjRCOvGQUXMGXzEOYIsGBI=;
 b=jkg1PrbCe4t662SOa70GCyJICc7cDYs6S/A6W2ZXmxzZKcKgLiKit+8NQFyp/V7bKbzExrDZl+z7C/W2XMkb/NhjIEdC6YtbvLBwTrZ4T03Q9DKuOWWT0W/DP51FD/mKk6mWs4XncthjFMafgHG6SvBV+wAOqQQFPfB2Lx7PaVSSia7oKrY+Gk9M427eX9dibeJdp7e5HbTpxpB0XxMXn115iJIz1gMMkSzvAwuNdljoIzJvv/liy0eFkOJ/6c8mO/1OmGaSUg5HK4tBcLJmT5P2TgJ8bhehaGm9iDhi31Nup+IzpJoCgf+h2taEmYKGvINCeIGOj2d33wVu8i71mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IsRQBD6VGeD0ZrtHxe0awjRCOvGQUXMGXzEOYIsGBI=;
 b=knotoU4iE8Bo2M5M6/UBBeWOFiiG3ebEU0in8v2M6EJ3kPAJasgTQw/8dLQVM5W07ql06LYvpWeAfxCf05x2GPQ+f1ujq/PNQ00p+TJATfoS8SgvqTQ7mYpdnKBAUB4NI15C4XXpVG5mosF3tRGn962hlDyyIcp6EzpqCwEXeJs=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB1117.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 20:39:48 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 20:39:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     michal.simek@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode
Date:   Mon, 19 Oct 2020 14:39:23 -0600
Message-Id: <20201019203923.467065-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YTOPR0101CA0053.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::30) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YTOPR0101CA0053.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Mon, 19 Oct 2020 20:39:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b2cf26-2d23-4565-7955-08d8746f1ea1
X-MS-TrafficTypeDiagnostic: YTXPR0101MB1117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB11177BC3D2D30AEA3997A6EEEC1E0@YTXPR0101MB1117.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ng4wcIQH23ieYid7Dv1sGbMhVF1mhh70QpuEnBQNPV3dazewKQKu3aE/18uhjETvEXAF3k24ogUgHV1Zqh/KarRo1wrJ8nRQeZZebHGgHEIsBq+lCdf5W2mstthd0JmUwuzOEcEQZNgF1H/nA/m+NVBkPVGQtcZgXSvchF+tn/RdODjn3BuHgdCd7doA5Gp7ulHul+lMAB75AUlhtL4L5bArJo7gtWosmNcer+I43ee1XXBJ9BcjftnDFoeJ3VFuIhxtAA3x7AHVnw8Xd/DjSTEQQhBO8KuqQCtZwEzGN45T/lzGc7VWnCdnLNQTjh8ShYgZhaicRSNvxXwfOzlupMCKcUmUQbkfof2HplSbheJInZyZYRr35GqtWqJVhNPT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39850400004)(376002)(366004)(186003)(2906002)(316002)(478600001)(2616005)(52116002)(6506007)(956004)(26005)(6666004)(16526019)(66556008)(83380400001)(8676002)(1076003)(8936002)(69590400008)(44832011)(6486002)(36756003)(4326008)(5660300002)(107886003)(6512007)(86362001)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MYYBvQ2C0goZEALMrecl4xQjUCrJToKsT2vAaZrs7JPJe+4aPq04aeBQT/tZQDkChGj/kCNWTRcsZ9auRndx1vTA4+tmK326+Glmk/m6FfP/bU8xwONSsGL3D1/11hP3yiC7uVoM+feZHlrwskm/dsXZ4CUiVHlLSoncImhLDtL8L4FRr0fINLBvOolUZnow5UrjYGUOPeRrLEP/v91eGoIYvVYF8nzvoCxysX67uyuVTKf4D8DZhHmPZyaCR0nleqgGw86UZtwwudJqSq3PE+5clqrXt64RCeFQxfMPdoPTOxQNt3N5nmanA1oB8iI1g8L76jvHicl6NL6ROWXvGjVtCl83rU1m424haUVCqVrrgnBpmQL0WzrUeKuvpe5/Dff8OYrNGeyGR9UVx1P05vcnjEE6VqtUoKOYqrm5n2/CmaZM1OBKzn2pBFPl8QE1ajZg6ECXw6kqirxBMTTxtjwkim1plFBCEhs3uTtxUo91CvQ3M0umfwNW/cDVJHRifwUN+x5yL7rAzttfVfHdiTCryxknW54gdkrOJFFcRW1hOpnk1Q5puOMlKGkpiW+PZFFB4howa9wjFVwZyuHB4MBzhJ9EoMg/XSmUOlq9bjgLDfbj8xJvyo0pCSyq1JJylzx32Imv15NGTIng1sCLxw==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b2cf26-2d23-4565-7955-08d8746f1ea1
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 20:39:47.8974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLu3kSHbSRCZ03zfbcY3hnlW7odwhpm60HxU5EGgqIyRU48Bd+KX9kqDkF06F0zO4fv/3hUD4SbPMc4YnFHgG3xqT11XJb7Cohi7kSebsgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the axienet driver to properly support the Xilinx PCS/PMA PHY
component which is used for 1000BaseX and SGMII modes, including
properly configuring the auto-negotiation mode of the PHY and reading
the negotiated state from the PHY.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   3 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 104 +++++++++++++-----
 2 files changed, 81 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f34c7903ff52..7326ad4d5e1c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -419,6 +419,9 @@ struct axienet_local {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
+	/* Reference to PCS/PMA PHY if used */
+	struct mdio_device *pcs_phy;
+
 	/* Clock for AXI bus */
 	struct clk *clk;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9aafd3ecdaa4..895c2c7a7f03 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1517,10 +1517,29 @@ static void axienet_validate(struct phylink_config *config,
 
 	phylink_set(mask, Asym_Pause);
 	phylink_set(mask, Pause);
-	phylink_set(mask, 1000baseX_Full);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Full);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		phylink_set(mask, 1000baseX_Full);
+		phylink_set(mask, 1000baseT_Full);
+		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+			break;
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 10baseT_Full);
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 10baseT_Full);
+	default:
+		break;
+	}
 
 	bitmap_and(supported, supported, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -1533,38 +1552,54 @@ static void axienet_mac_pcs_get_state(struct phylink_config *config,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
-	u32 emmc_reg, fcc_reg;
-
-	state->interface = lp->phy_mode;
 
-	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
-	if (emmc_reg & XAE_EMMC_LINKSPD_1000)
-		state->speed = SPEED_1000;
-	else if (emmc_reg & XAE_EMMC_LINKSPD_100)
-		state->speed = SPEED_100;
-	else
-		state->speed = SPEED_10;
-
-	state->pause = 0;
-	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
-	if (fcc_reg & XAE_FCC_FCTX_MASK)
-		state->pause |= MLO_PAUSE_TX;
-	if (fcc_reg & XAE_FCC_FCRX_MASK)
-		state->pause |= MLO_PAUSE_RX;
-
-	state->an_complete = 0;
-	state->duplex = 1;
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_mii_c22_pcs_get_state(lp->pcs_phy, state);
+		break;
+	default:
+		break;
+	}
 }
 
 static void axienet_mac_an_restart(struct phylink_config *config)
 {
-	/* Unsupported, do nothing */
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	phylink_mii_c22_pcs_an_restart(lp->pcs_phy);
 }
 
 static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 			       const struct phylink_link_state *state)
 {
-	/* nothing meaningful to do */
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+	int ret;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		ret = phylink_mii_c22_pcs_config(lp->pcs_phy, mode,
+						 state->interface,
+						 state->advertising);
+		if (ret < 0)
+			netdev_warn(ndev, "Failed to configure PCS: %d\n",
+				    ret);
+
+		/* Ensure isolate bit is cleared */
+		ret = mdiobus_modify(lp->pcs_phy->bus, lp->pcs_phy->addr,
+				     MII_BMCR, BMCR_ISOLATE, 0);
+		if (ret < 0)
+			netdev_warn(ndev, "Failed to disable ISOLATE: %d\n",
+				    ret);
+
+		break;
+
+	default:
+		break;
+	}
 }
 
 static void axienet_mac_link_down(struct phylink_config *config,
@@ -1999,6 +2034,20 @@ static int axienet_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev,
 				 "error registering MDIO bus: %d\n", ret);
 	}
+	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
+	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
+		if (!lp->phy_node) {
+			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
+			ret = -EINVAL;
+			goto free_netdev;
+		}
+		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		if (!lp->pcs_phy) {
+			ret = -EPROBE_DEFER;
+			goto free_netdev;
+		}
+		lp->phylink_config.pcs_poll = true;
+	}
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
@@ -2036,6 +2085,9 @@ static int axienet_remove(struct platform_device *pdev)
 	if (lp->phylink)
 		phylink_destroy(lp->phylink);
 
+	if (lp->pcs_phy)
+		put_device(&lp->pcs_phy->dev);
+
 	axienet_mdio_teardown(lp);
 
 	clk_disable_unprepare(lp->clk);
-- 
2.18.4

