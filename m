Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0982942BF
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437982AbgJTTKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:10:06 -0400
Received: from mail-eopbgr660052.outbound.protection.outlook.com ([40.107.66.52]:42970
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437957AbgJTTKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 15:10:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngtLBnLWfA4QnDEfXWMqHmlaSsYO84CvuwMAxjc6Ev74uuxep4XamEw6b7AId1sjkJpp81LL+2K+Rty4keIN1Uz+TJkA8LMvatJxn4HQzwCvd3xpm0x5LoI6ee6LtXMJvUbDRyxfp6bQBiD5/nfP+OgHoaL3msKu6HN1qPT5fYsbtY8/2CvNrdUU/IUGOlGtA6Oc97xsJJHcpXDay1Lchq/GLX4aMhRLtZB2glXUE5y7oKVf3i072IoWA9eUTRTPtfETS51PgLSIJFjEoVUskTVnsrJ3SD62mE3nwWefZNdr2HqKSEq0FV4ZaJXHgI9nZVAL+qWVW8pECQx9flqs7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ5gQ4TREAu3vWAoEWHjbWPEDA61lmjQX7ItCANsKlM=;
 b=NKOXAOcAnSSQzE1L2IzeNgnFu8FT3lBCfAKDPsIVazOBE0Ob8DICqCRyL9hMsUSFLEsJgE412E+ZQG4omwkuMncS2cy6DaVIq9toY2mOQuXwV+Hb3/6WNliHwOtQb2L00X94H8i4JfjhbIXpcFCn1kSDAPxa3tpdh74N24OWR3qhSN0F6Sui2NB9zG8QdOO0UxlCttTPXcaD60EdZaEol0lTxCq//xpCuj4hCp0PconjDucq0CXBpvVySdX/2WghbkFXX7vGXhCbmLVEjZRswLGVa07as8vJYiixqHTvDj2HSQmAxZnYisRpBl4TJrdH5PN1Vt8f+hn/MmModLcyxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJ5gQ4TREAu3vWAoEWHjbWPEDA61lmjQX7ItCANsKlM=;
 b=iaYE67bDR3K+lxy1rssi5j/mzzXbKu3hRVNSMBPc2/0cfNPvvK7N8U233CXOikEQaBUD0jpvE6LZQA44mpdsve+TEXcaq9mUSOBbsgxi9z7YzkLG6wdvlZYB1kPT9bqBQtlzUeR2yQhuHggOHUopUJqJe4hKTZkCiKoiV49uXCw=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2926.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:15::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 19:10:01 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 19:10:01 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     michal.simek@xilinx.com, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH v2] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode
Date:   Tue, 20 Oct 2020 13:09:41 -0600
Message-Id: <20201020190941.756540-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::19) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0140.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 19:10:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dab21bf0-e574-423e-901f-08d8752bbe67
X-MS-TrafficTypeDiagnostic: YTBPR01MB2926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB29267CF919FBB0595C3618E6EC1F0@YTBPR01MB2926.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gVEfE/7sS91CHq2Ibd8GPmyit31W5eogBlBkNLgo1wZYwjz9jLvECZnR9c4PAw6HAtnJDt5EZIIkHFv8EAJK7yKYIUmtJISsvOVJnZC0MJL2NMVA7o6ytyivkzYZAObdQvL3e1rk7JDC3AL+7JTdcelrCWbarvrfMlmvLZlij1z5YM1+2uuR4DdmRErtHuYc3mSM+4XGrKbwdpThuIhtMz/OMYS8XscMWINLk21o4mKj/4qk4ftdVaISl3qHRuLwAWYZwZp/aHO+MAhJXr7VhaVHrx2tbV7FUm/MO5XPy6owX8jChmxU3WQyv7w4KF98tQ68UcNrinfknsBK0GnLERjI+WI9fe+7NOFi3SeNrkRnmQwGWx965+hqnkwtXUOS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(376002)(136003)(366004)(2906002)(8676002)(44832011)(86362001)(8936002)(69590400008)(6666004)(316002)(66556008)(66476007)(16526019)(52116002)(6512007)(2616005)(186003)(478600001)(6486002)(4326008)(956004)(36756003)(6506007)(66946007)(5660300002)(26005)(83380400001)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HIAnDFqR1U5ryhauNlz8pYa2MRkrskbybMcCudo1rv6Wpf+nCq3/SLaO9n1FdOQlGnrs1BQuKCpP6HUvuITsxs7luKyd0mVpGFfKjaJe4RzSgBcoYXoeCk8SRvFd5IDBsBLnnmvJnknm+sP80SXZirpHcY/bejxMWFn+AazJRcJbB2gJyEWVTdJLcJeV5WHVWiwFHGLgSC2vTIAM6KFVbL8ZcCkqlD5k1vqX461pBV0kKBdLeD29PJxpga+t4O9e8OcZ/seWltfXwjjyMEomhacTENtcAG6/fcAJq6MiQvtxxgPLgm7ABCAEy5XRP6BtgDIBJbgoNWo2UZxy+zKoJhwxSt1SlHFFp/tcWUE/pyYh0xI4EHVCDaBuc9dEPPDKetueVAv5jX/yhzLEBvUI+KK9RxB7WaMrh69DatLAIZdD9e74u+qYxjEs8HW8qDyma1Wodyox9YyjbBSkkRc2t2h8aGYCxO2C8shXcae32T5HBVFDMPk+8ZCtepnYpTq493zbNhTF3C4GcyqkzPuscoyszw4qv7aNtAfgRgKLjvEHzszqlnnD9Ol8wpZ9XBLiZoMLlLQg5Hn49u3/8LRFZQkKKTGxTiDeG4dQ4nWnhnCddbFpKFoG8untRFY/iVNT2uZQlihvFLcpBVQ59VN0eA==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab21bf0-e574-423e-901f-08d8752bbe67
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 19:10:01.3725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huQe/8WmRqQbidMfEWmF/Me8Mg/upGaUJxj4UUkRNrLdp0iGRMr8OLwX/MM+SHF9j6dVhYDrLN3deru6AL1K+XpwSM3siU+2Zl3SbS7Yq8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2926
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the axienet driver to properly support the Xilinx PCS/PMA PHY
component which is used for 1000BaseX and SGMII modes, including
properly configuring the auto-negotiation mode of the PHY and reading
the negotiated state from the PHY.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
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

