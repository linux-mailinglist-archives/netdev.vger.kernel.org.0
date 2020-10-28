Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE1A29D3E2
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgJ1Vrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:47:32 -0400
Received: from mail-eopbgr660056.outbound.protection.outlook.com ([40.107.66.56]:48700
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727715AbgJ1Vra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:47:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEybP6vus8T14gQPgWQe2Awt1G+nttDYS/ohYhH1hYQqtB3naMzrH5cljeUqWcwz7NfGHSdSeQIxOs1d5wfhu/BAD03Kq+jBhDLf/ZSAKj7YHTl9OrC67qkjyqKjb8Q7hTvpTvh/rl5ZwsmwSM8sutD7dpTqwJ2xLrlK5W3HlLqcF+rPa8/7/5Vt4IdulrGZzshWO4sIV9Ra7I3kbB9MLO8mxcR7Ei4PbqT2G0Sp64RgFqInHvDzo9A5MY4UKAkKHc+F3vMHPUfw4dkOmSV1tvlzfPDSZXQWc9GQqv9ffr3lvEj7yVRUmEkE01E8oR2uWzcFaZt8g88kO15o2j4mRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apZC3R9x24oMJ50OEi0ZA8n6MBBJ4L1Fg5Uau3de4VI=;
 b=hnn9FPf9BdS7tZsbRdSY9nM7O2WlzGDcdeSXc0MnnGOwhwu1MT8r8Zi4s2SefZZvGO24TKGo66+9Lg0l4gChF+x6UzAWezUlYdphtssoU44Y9XCANdEeqq6R1GkUjlxsOW2skPEMTeDzpfDqP/ejdeS0JNsuDpq1kqLWbC59AIGnY1iCEqUgMsz1X1/KU+wPzCV6UdgkdcUSmNK/OJ16b1HLOYYbAp8V6/q5nDo+Bcn08qjAhpMD/Lyc/dXQN134MKw2PL8CJsLn8LS/mSbIwKWbbxsSBfiENrikyoDBvnOU0WJooRrznj9Daam09gQiBXh3Rk8NU2AypMVgy+4dGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apZC3R9x24oMJ50OEi0ZA8n6MBBJ4L1Fg5Uau3de4VI=;
 b=IvnThX/kSj0TXC2BlPNkTbWyUm8sv2/uXSRQY7Y5PET8XCHAxs+U45oyWTba44fWZzlfXUUKISxDoX2rxl/1xBGW9sVTQAB+FN1MWaZ+NXjkNvRFFLnQY3LLP6fDokMn3PMHZA8hiXBk4eLV32uthqqq+NaAAQFhsSQ8Af8Vrz0=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0958.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 17:14:50 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 17:14:50 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     michal.simek@xilinx.com, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode
Date:   Wed, 28 Oct 2020 11:14:29 -0600
Message-Id: <20201028171429.1699922-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YTOPR0101CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::39) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YTOPR0101CA0062.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 17:14:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f811b332-03de-4b45-f271-08d87b64fa41
X-MS-TrafficTypeDiagnostic: YTXPR0101MB0958:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB0958B6CF787033869F96B8C8EC170@YTXPR0101MB0958.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X66do0TRG42VM/0CAtXv3XPdYVoDrNZ1qglfDlWY74VXZbjrw7wV4yhDPd3kgaKo3qmohEES/HiQuxiEJAGcFzUO5C67yYlOCt4cIPniFEpfwrn0v0aWJcaVuvedoUncigNyG7v2D1WzOfGhyERtAHyfmQFzqyGag6NqwK2phT0QadfWnCtvKH48kD5z7gIoni2bBf0Am4q2fG3qyUqe0ZVoh3eKqWe1zQZT8CkMaI1TFXZmtUM59dr4uYvgXnA/9bZi8Q6+TMkt6iDmPNJ7fWcktNCt0dymPLlFQcee4hmQ+3oCEGo5IT5IkIWgyQCxNskmSJdIT3IurfkTPiMaux+ytSFEXjIf+mfE7YnxqJzaCnpbLj8TQ7NxZnJ3fAFI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39850400004)(44832011)(1076003)(83380400001)(5660300002)(6506007)(66556008)(6666004)(2906002)(956004)(2616005)(69590400008)(26005)(36756003)(6512007)(6486002)(66476007)(8936002)(86362001)(16526019)(107886003)(8676002)(66946007)(52116002)(316002)(4326008)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1ItqaZ9cacbbNVfRN1ahYpYbT6n1IR+yF5p68Mlj8pwTAymPzW/qvSRwBVQZUER0rq5ILT+MrRGzh4fsvEM0rgluPJM2BHyEB+cjqTH6wGalDa/rtOBBJSYhWOh0CEDrYbJJd83Cg2xDPKdgqDUHM4KblIAq8wNBsrw4cFAgyG0Ubsc0td1Ma7R2aIjqpvESHPP9S8xl5K6Xu7VofEhnuURIrgccjGGxgQE5OKEhnmL8wJR9aNUguzbFeMRjxl9aDfm2rn+zysCjUepGy59jLn69jhbGqmT+Iu2wjHFjVb86063pygb67nHSHoNdGGGgKwXUlG2VFrwxhSVTUSzrgw5/HFKA1zoD3YFRJU9D7nVDrQ9KmJVm2uOQdOIdprA8R0hN1l1dcShIrvnChzIekUXYgLiV8vpUYhLFn0K5Z1nTqgcSykyaHOAVEKWyIyO3dUyO5TAw562vf3iG9dw2CmgBHBwtktttEZKlgh2Aqx8UlvESijerQJxjMuAYGl9iujj0mEqMepnt8oC7x5a9EisBVquyVNdl7w4UgIlKLdxuCmk74JCmUCaEvg1ZRlCLA5OGezG/KDzAklfN3EHeAtkvUwMI+8torOF9w6J3N40Q3s4Id6/+nq22xVwSRr4zmu4kMgNrx1SWKJp14Qxvdg==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f811b332-03de-4b45-f271-08d87b64fa41
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 17:14:50.0026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRmhMMmdoVaV39HNK6FWNu6fffafaxdhJSXUAuSxiE9LMsirAnW52Aehu05QuIk309qL83S1Zhb1glhYcem5dckKc+oVi7S0HeI4xNxeZY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0958
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the axienet driver to properly support the Xilinx PCS/PMA PHY
component which is used for 1000BaseX and SGMII modes, including
properly configuring the auto-negotiation mode of the PHY and reading
the negotiated state from the PHY.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Changed since v2: Removed some duplicate code in axienet_validate using
fallthrough.

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  3 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 94 ++++++++++++++-----
 2 files changed, 71 insertions(+), 26 deletions(-)

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
index 9aafd3ecdaa4..529c167cd5a6 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1517,10 +1517,27 @@ static void axienet_validate(struct phylink_config *config,
 
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
+		fallthrough;
+	case PHY_INTERFACE_MODE_MII:
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 10baseT_Full);
+	default:
+		break;
+	}
 
 	bitmap_and(supported, supported, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -1533,38 +1550,46 @@ static void axienet_mac_pcs_get_state(struct phylink_config *config,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
-	u32 emmc_reg, fcc_reg;
-
-	state->interface = lp->phy_mode;
-
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
@@ -1999,6 +2024,20 @@ static int axienet_probe(struct platform_device *pdev)
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
@@ -2036,6 +2075,9 @@ static int axienet_remove(struct platform_device *pdev)
 	if (lp->phylink)
 		phylink_destroy(lp->phylink);
 
+	if (lp->pcs_phy)
+		put_device(&lp->pcs_phy->dev);
+
 	axienet_mdio_teardown(lp);
 
 	clk_disable_unprepare(lp->clk);
-- 
2.18.4

