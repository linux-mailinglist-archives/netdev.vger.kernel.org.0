Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B7D29947F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788781AbgJZRzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:55:51 -0400
Received: from mail-eopbgr660057.outbound.protection.outlook.com ([40.107.66.57]:56048
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1788762AbgJZRzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 13:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXQ+W5m7LfHmLZK73w7SgEszRDbQsS6QjJWeDpIWJQSgzaBCNMH6fMCdkAzNZP0zMK/R8USkLYlmeH6a/B2kxj4XcBo8j9NrhmiNf+8ffQWcjc9iKh3BP+6gl1u93ViNJXzQL+pRtXeutXH2UypvXK+hblzqCNH2+Rpt98ATA3KeJmQbPP6pEXI+jHxgCyaL0/oF2wY4Db6l/qwJfBmKTBiznlS82WuPLYIvLferk9kBwXn2Uv3SSUZybCsiLPLCVSZExfPuL6BGFhx5zOTH9x+q901GS8aYqmA1MkaMHcHkFGSmSNeOJDnGlXI+NZ9+Uo1D+tIw9VC96LiiP2B9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oJnT/CzpLA5/WFyuHueXnRO1QI14L30waSPlG10T70=;
 b=EU0llndvaQJPyuz4X5IJZHU6svLiApa7+ifwr1cnC6dsc/2uOr5z4bS7h+FO2VStdHMCNbePj/qshi81AC5zZ0EabhdgIf7RU2zN+jjpXO+f2nWhLKPGuZaV3EliL9xYiH+f5qntAfeGq6EZQ5l6FdBtmXf7Q/dCCD6qh4zl59zv4BOi6EpC5/3B5AqYVxI00Mc3wEF1FfULC6GkHGdcQBeU3a4+tJSgMx5RLaCbJlutP9Awgr46KQU9Fn/4KQCgt9sq7KUCqcNvxfjYa5Q5FYwLWrD3/F2nSZwxtDxFN48DILXdBdIjsWOVtta5eb14AnbMmEGTTiQ/T1ScgUYnHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oJnT/CzpLA5/WFyuHueXnRO1QI14L30waSPlG10T70=;
 b=OdUa9c8JdIplz7kx9Q6WiiD2qCG5jSzG1bCsfilQxXdujnbeibysKMYZBrLkd5hBMW7nKpuz/k+LIPvVwTYbKWxbSlCy9/s3mk0+405luQ2dmL1VgcKStnnzDaCjvuIPenoVH3TwcFDwDp8bCnnTmQxJd5jQfIFQ7BFHLRfN0Z8=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB2619.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Mon, 26 Oct
 2020 17:55:46 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 17:55:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     michal.simek@xilinx.com, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode
Date:   Mon, 26 Oct 2020 11:55:35 -0600
Message-Id: <20201026175535.1332222-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YTOPR0101CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::37) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YTOPR0101CA0060.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 17:55:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f116e8-f100-4fc8-e08c-08d879d85da8
X-MS-TrafficTypeDiagnostic: YT1PR01MB2619:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB2619D0F65F5DB881932B5529EC190@YT1PR01MB2619.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhDEIVvKyCmp5GOBl2uMamMliyDiXx9LLNDs9Rrdb0rWkWixtWCJ5Clu4ZQzOiAIImi5Qz03dWO8tJm3vQAYLdOBNCGMUUBsMJBAa7x8ALREr/SFLtyJZSfxmnKheMBwkrVCPCeELVuRvaCvw6SkgrqPr2/i16CYszrrvPvJnesu4l+6ykIjkxsh9mv3KkRYXgOHXWDKBAfoTawqS6LFnWIev+kz5mgZbc6d1HFhzH96kT8SMM6gEleQWZIK4cHp5XDvI1eI+lpNgXRyZ9QCD+z5W3TVSn+Wr/uh46r4Ra/HJo4m/1t5U4ms/ry+HEhXmA0q7pOrlyQMdT2M7qzy3Gis2iM98sAAbbe2yyTnNikfbAXKapwgxU089WH5KH8S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(346002)(366004)(376002)(1076003)(36756003)(8936002)(6512007)(8676002)(2906002)(4326008)(2616005)(6506007)(478600001)(16526019)(52116002)(6486002)(107886003)(956004)(26005)(44832011)(66476007)(5660300002)(186003)(66946007)(316002)(86362001)(83380400001)(6666004)(66556008)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +PlQIpByhNmaU8UUiPZFgy8EQZkxv4H7DGzMrAjBv5IOIxUxfMw2IwvV49IfJUM5DqUwHzhapGSZ2Y8EZyPn3ODzmfyjFk+upzochJL4SsBhwkLK1STR5GCDSJzZaVE2amK1Gb+DBnfbWhuLjXiQkO30nrMBiZsoCtKVsqEgyjCB564dJYq0EQ++DEpa5+fWNkam/fRgWgNy779Exc+H4nud1P50DJE7tjzqqGNv4yP2j27AA57u0XjWiJPBHjUWqXezyKA4pLPnLH9FsiFLwUbcG/XJ3D4RA8tfKz4BHaLcVRErD7bXz1DNtTKuSvGP/9/8/gfYPmW+Wi/hkpoOBf3jdH0zQJDV0PVw1hjV05OG8TDKyWZRaWZnUA+lae26eEMa9CD7VZeKAfrEQGs0gz6ICg+QHF8MHl7a4V3M395Em8jR8qMGM3ryq5KG2JtOFfLQmzF6dXLRiLy6o/Qm5DfOhcDtcptT+fZ9/cSlP78taQi6pILzNfNfqejpF0poMIBMxYrObLN6l130I2cqaCUGowVilZCArAQOFVDCtT7tcYq0ZPpPPro16NBP8pTRvSX6OML1pquAJOUdSo3NJ5QdjCGTCx+8D0LRtDkc/fcRxgsU9qWw0QdwjqfJbzTLw3D3GeHC/ztly8HtIzCxhw==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f116e8-f100-4fc8-e08c-08d879d85da8
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 17:55:46.6279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egkTeOnoNbJwZrxQbS8rc5sgeBMuXK9+U3g6/p+sUza4cHMVop96DRkz1Lfv5imoxSu1AaEml65l0NiGWHH/BNYyVu3QJMrqERpZHKDn8hE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2619
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the axienet driver to properly support the Xilinx PCS/PMA PHY
component which is used for 1000BaseX and SGMII modes, including
properly configuring the auto-negotiation mode of the PHY and reading
the negotiated state from the PHY.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Resubmit of v2 tagged for net-next.

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  3 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 96 ++++++++++++++-----
 2 files changed, 73 insertions(+), 26 deletions(-)

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
index 9aafd3ecdaa4..f46595ef2822 100644
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
@@ -1533,38 +1552,46 @@ static void axienet_mac_pcs_get_state(struct phylink_config *config,
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
+		break;
+
+	default:
+		break;
+	}
 }
 
 static void axienet_mac_link_down(struct phylink_config *config,
@@ -1999,6 +2026,20 @@ static int axienet_probe(struct platform_device *pdev)
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
@@ -2036,6 +2077,9 @@ static int axienet_remove(struct platform_device *pdev)
 	if (lp->phylink)
 		phylink_destroy(lp->phylink);
 
+	if (lp->pcs_phy)
+		put_device(&lp->pcs_phy->dev);
+
 	axienet_mdio_teardown(lp);
 
 	clk_disable_unprepare(lp->clk);
-- 
2.18.4

