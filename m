Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99392837BC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgJEO2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:28:41 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:62374
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726429AbgJEO2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7ZWHQe7ZgmXqm4lcVanywz+xtDeCDCs1M08J/QJEk51rjd0n+S8LQ0m4wfpmhfyNHRBtH4UH5flg8n9m/dzT1A55HiRyk19lNL03qNs+KVuNcqXidnzDEyQjjxP4GyUnFmeb4nFRmnjgcWe5mQdLHd0ZEoyz+0tvqsG86AJH3ANnad6+tSS1xbex1t5Nssqj6+ET+4nGZAfpl0CxiFEQRT9XRgm65WIiMEVWHScsFtlDDoBTVgMzVffgoqdd7zbdMNGEI7cq106eALLGdXQzeG3Sx0vtbxTSTJe02KBlQXU9VQgAUr9on/AeEFNTbGarXHW+C9a5X7d9eZiOzT1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uf+TN0d3gXlh6B9yDnPvKvjm7/HBFEZI5c8S2K67A7s=;
 b=cBycV3d13o+NbbGZQdSQ2YjlGRrwCMf9pun6ZxWqf7QLEl6xf2IpDltvPlTU3ms1FXXxVtIRK2n7KQam5AJZLo0626V7SYSdqW+pYGkuZHSVfUwav65QszOJRtrtXXrMJY3V/U0ILNhleMJtgmDzbon1vhFXnggNXquZHU9xaFukG0LZdZ0EhYV6yaye7533Jq44lD4Vhz3HG6ifoxrSnZzFjDsyl6PMP0f50g7sxUKUY+JaQedRnBAT3n3kxm+OdygCu9Q9Oc0XFhEKPeUb2y0eWTalFDfTvmnKHk5luyH6h0EHbxDRBXqaSOoMo4aciY8PEi5QL8P/9Wd802M9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uf+TN0d3gXlh6B9yDnPvKvjm7/HBFEZI5c8S2K67A7s=;
 b=sv04IrCl4LEXIn1DEO4M6zOVCMalL1rG7yk1z2JAVkTv2Ge17Sp10Mg1fpqlRBvc5ntLKFWZH9eA+1gB77pUuBWL2bhPgFjJweChcrBYrTUnfj5iOQLf4MDlFfffZlh2wmYoKTg5rLTtns1+Cw6wLXoZqtu9qUqGfRvvrA1XxD4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7171.eurprd04.prod.outlook.com (2603:10a6:208:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Mon, 5 Oct
 2020 14:28:32 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 14:28:32 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/4] enetc: Clean up MAC and link configuration
Date:   Mon,  5 Oct 2020 17:28:15 +0300
Message-Id: <20201005142818.15110-2-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005142818.15110-1-claudiu.manoil@nxp.com>
References: <20201005142818.15110-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR04CA0060.eurprd04.prod.outlook.com
 (2603:10a6:208:1::37) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0060.eurprd04.prod.outlook.com (2603:10a6:208:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Mon, 5 Oct 2020 14:28:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2a484404-a6a0-4551-8cf4-08d8693aefaf
X-MS-TrafficTypeDiagnostic: AM0PR04MB7171:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB7171014C99308BC4E90A6D2D960C0@AM0PR04MB7171.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rql8N4LuWlhP7xMs/sHQWBTKwaZTFen9pa+WKhrgFpXjaIi+pUkJ90IIKG/Zi9tftkVYzE8O84h9TYQMsDgl6LFCVsoWfnebEgD9vDMsyev/bugBPSwGs2ssuCvZlNm9TlINuk/7zthS65aAScX7cUbQnvlUPFHaoAyzo+6207sUNxNbtiBrYdINBe3pF8UQL2Yfy06ln0vUayI9DuHHuOH+lTzInP3MaDWg0jQQpGy16aQlUkHlrM4hZPNyEYjwElZvVwgectqAV1LylvLsZJalPxBLYmX3Eb7TssdQaBv7qqJaMRHp176yuCUGdp/xT0JQlAob0EVYUtqD/yt5CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(36756003)(6486002)(8676002)(2616005)(4326008)(956004)(6666004)(2906002)(7696005)(52116002)(6916009)(16526019)(26005)(8936002)(186003)(86362001)(54906003)(1076003)(478600001)(316002)(83380400001)(66476007)(44832011)(66946007)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +Gc4X4DT3LeYmqdOdcWFKNhvlD5nzVvBoKEAQLySWMo4pwYAqE/WQiDpHaveNQIySoO8xUT9CBiAcFvHXPBFItEqg8d2eHxGsByOMaqyu1RRfDE530hYeQvIbi4w3QK2jNjMNftO4rNrM9QXg54skr9TeENYCzUXHwINxnfWxAXPIleyrjudFzNJG8uwYB3Zy4u3fUzOARmawUe81uBZKNpq2O04HQ8zslyZ5hKrELG27Gg+ivNXX20iO0HC3NkxcKR/6rHQAAyzo5Swt0IisXPc6n8XYRMcryt7jhZi/Yj/3yKAUUB7CZeRIMaIK/v1e9oYUjd6Zir8NJRTp8gMtEMsAAzo3/xxC50u970pYsEvNHp0f2QwoztYVFBamidM4z0iUb3tKQBc1HsZ+msDxcFhRzOGf3cYNHvjcNC9ltJHTfK9U91RLy2cUjy0L37/HFCFzY2kKUV0eErrjA3yG1OZiWKal+J8DUgeHZ78h43c1r74np0ebF4FO2K9imVV6JhhZM4cLjaaJYl5hB+8oE31xxzSbmvRArRWWWrpv3t1G03Efv9w+I7GZa/rgkGtj6Ne3fYKgJxNtZFRPDCPaOmRucn8hfgHdOin2tu/0fPQOhvDDky9Fj/ILOzUoQ0oJK7Z6sJ3RZhI2SaXCcmT+Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a484404-a6a0-4551-8cf4-08d8693aefaf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 14:28:32.7661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCww81fsfaRqh8orv9As5Mdb/BTWpdy3TjvdGEo64Rd9u8P3YbgtNpkgFLtz4lieRztvwrEVhIa/mj7+/IvAiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7171
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Decouple level MAC configuration based on phy interface type
from general port configuration.
Group together MAC and link configuration code.
Decouple external mdio bus creation from interface type
parsing.  No longer return an (unhandled) error code when
phy_node not found, use phy_node to indicate whether the
port has a phy or not.  No longer fall-through when serdes
configuration fails for the link modes that require
internal link configuration.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 115 ++++++++++--------
 1 file changed, 67 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 177334f0adb1..64596731c1c9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -482,8 +482,7 @@ static void enetc_port_si_configure(struct enetc_si *si)
 	enetc_port_wr(hw, ENETC_PSIVLANFMR, ENETC_PSIVLANFMR_VS);
 }
 
-static void enetc_configure_port_mac(struct enetc_hw *hw,
-				     phy_interface_t phy_mode)
+static void enetc_configure_port_mac(struct enetc_hw *hw)
 {
 	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
 		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
@@ -492,12 +491,16 @@ static void enetc_configure_port_mac(struct enetc_hw *hw,
 	enetc_port_wr(hw, ENETC_PTXMBAR, 2 * ENETC_MAC_MAXFRM_SIZE);
 
 	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
-		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
-		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
+		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
 
 	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
-		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
-		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
+		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
+}
+
+static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
+{
+	u32 val;
+
 	/* set auto-speed for RGMII */
 	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
 	    phy_interface_mode_is_rgmii(phy_mode))
@@ -505,6 +508,14 @@ static void enetc_configure_port_mac(struct enetc_hw *hw,
 
 	if (phy_mode == PHY_INTERFACE_MODE_USXGMII)
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
+
+	/* enable Rx and Tx */
+	val = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
+	enetc_port_wr(hw, ENETC_PM0_CMD_CFG,
+		      val | ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
+
+	enetc_port_wr(hw, ENETC_PM1_CMD_CFG,
+		      val | ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
 }
 
 static void enetc_configure_port_pmac(struct enetc_hw *hw)
@@ -527,7 +538,7 @@ static void enetc_configure_port(struct enetc_pf *pf)
 
 	enetc_configure_port_pmac(hw);
 
-	enetc_configure_port_mac(hw, pf->if_mode);
+	enetc_configure_port_mac(hw);
 
 	enetc_port_si_configure(pf->si);
 
@@ -733,11 +744,10 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
 
-static int enetc_mdio_probe(struct enetc_pf *pf)
+static int enetc_mdio_probe(struct enetc_pf *pf, struct device_node *np)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
-	struct device_node *np;
 	struct mii_bus *bus;
 	int err;
 
@@ -754,26 +764,36 @@ static int enetc_mdio_probe(struct enetc_pf *pf)
 	mdio_priv->mdio_base = ENETC_EMDIO_BASE;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
-	np = of_get_child_by_name(dev->of_node, "mdio");
-	if (!np) {
-		dev_err(dev, "MDIO node missing\n");
-		return -EINVAL;
-	}
-
 	err = of_mdiobus_register(bus, np);
 	if (err) {
-		of_node_put(np);
 		dev_err(dev, "cannot register MDIO bus\n");
 		return err;
 	}
 
-	of_node_put(np);
 	pf->mdio = bus;
 
 	return 0;
 }
 
-static void enetc_mdio_remove(struct enetc_pf *pf)
+static int enetc_mdiobus_create(struct enetc_pf *pf)
+{
+	struct device *dev = &pf->si->pdev->dev;
+	struct device_node *mdio_np;
+	int err;
+
+	mdio_np = of_get_child_by_name(dev->of_node, "mdio");
+	if (mdio_np) {
+		err = enetc_mdio_probe(pf, mdio_np);
+
+		of_node_put(mdio_np);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void enetc_mdiobus_destroy(struct enetc_pf *pf)
 {
 	if (pf->mdio)
 		mdiobus_unregister(pf->mdio);
@@ -783,14 +803,13 @@ static int enetc_of_get_phy(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct device_node *np = dev->of_node;
-	struct device_node *mdio_np;
 	int err;
 
 	pf->phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!pf->phy_node) {
 		if (!of_phy_is_fixed_link(np)) {
-			dev_err(dev, "PHY not specified\n");
-			return -ENODEV;
+			dev_dbg(dev, "PHY not specified\n");
+			return 0;
 		}
 
 		err = of_phy_register_fixed_link(np);
@@ -802,24 +821,12 @@ static int enetc_of_get_phy(struct enetc_pf *pf)
 		pf->phy_node = of_node_get(np);
 	}
 
-	mdio_np = of_get_child_by_name(np, "mdio");
-	if (mdio_np) {
-		of_node_put(mdio_np);
-		err = enetc_mdio_probe(pf);
-		if (err) {
-			of_node_put(pf->phy_node);
-			return err;
-		}
-	}
-
 	err = of_get_phy_mode(np, &pf->if_mode);
 	if (err) {
 		dev_err(dev, "missing phy type\n");
 		of_node_put(pf->phy_node);
 		if (of_phy_is_fixed_link(np))
 			of_phy_deregister_fixed_link(np);
-		else
-			enetc_mdio_remove(pf);
 
 		return -EINVAL;
 	}
@@ -1004,10 +1011,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
 
-	err = enetc_of_get_phy(pf);
-	if (err)
-		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
-
 	enetc_configure_port(pf);
 
 	enetc_get_si_caps(si);
@@ -1022,8 +1025,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	enetc_pf_netdev_setup(si, ndev, &enetc_ndev_ops);
 
 	priv = netdev_priv(ndev);
-	priv->phy_node = pf->phy_node;
-	priv->if_mode = pf->if_mode;
 
 	enetc_init_si_rings_params(priv);
 
@@ -1039,9 +1040,24 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	err = enetc_configure_serdes(priv);
+	err = enetc_of_get_phy(pf);
 	if (err)
-		dev_warn(&pdev->dev, "Attempted SerDes config but failed\n");
+		goto err_of_get_phy;
+
+	if (pf->phy_node) {
+		priv->phy_node = pf->phy_node;
+		priv->if_mode = pf->if_mode;
+
+		err = enetc_mdiobus_create(pf);
+		if (err)
+			goto err_mdiobus_create;
+
+		err = enetc_configure_serdes(priv);
+		if (err)
+			goto err_configure_serdes;
+
+		enetc_mac_config(&pf->si->hw, pf->if_mode);
+	}
 
 	err = register_netdev(ndev);
 	if (err)
@@ -1053,6 +1069,11 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 
 err_reg_netdev:
 	enetc_teardown_serdes(priv);
+err_configure_serdes:
+	enetc_mdiobus_destroy(pf);
+err_mdiobus_create:
+	enetc_of_put_phy(pf);
+err_of_get_phy:
 	enetc_free_msix(priv);
 err_alloc_msix:
 	enetc_free_si_resources(priv);
@@ -1060,8 +1081,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
-	enetc_mdio_remove(pf);
-	enetc_of_put_phy(pf);
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 
@@ -1074,16 +1093,16 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	struct enetc_pf *pf = enetc_si_priv(si);
 	struct enetc_ndev_priv *priv;
 
+	priv = netdev_priv(si->ndev);
+	enetc_teardown_serdes(priv);
+	enetc_mdiobus_destroy(pf);
+	enetc_of_put_phy(pf);
+
 	if (pf->num_vfs)
 		enetc_sriov_configure(pdev, 0);
 
-	priv = netdev_priv(si->ndev);
 	unregister_netdev(si->ndev);
 
-	enetc_teardown_serdes(priv);
-	enetc_mdio_remove(pf);
-	enetc_of_put_phy(pf);
-
 	enetc_free_msix(priv);
 
 	enetc_free_si_resources(priv);
-- 
2.17.1

