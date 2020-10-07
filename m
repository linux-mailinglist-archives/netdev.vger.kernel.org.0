Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CB4285C0D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgJGJsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:48:47 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:16619
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbgJGJso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 05:48:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnIqCHpwctLHawQwmz7lgk14WuN1TdBPiZAWNHuZwCHCEy9lp1x1zEM/TTt/Sk3ebEFCwDfLZ3MmUfy30PUM2EMDDYY+j4LsPSERvy3i0MnGZQV0pOZ8qqpdUMeE16X4PQSq92h46AQ0B7rukPvG/s6ZR6RjXEaU2oHH4sJWstnFMWUAC28EC3zQj9wCFhG0jB6D4Y/67/9Wv5KMjzZSDwoZ3dR9JwBFFSAOzcZ8Wy0TjjQyFL+ph4Izdn2SgxXq2mmDBkCve/LzWM41iR4ljTj29NUfXUiuN6+1GtrTfUwuDp5Bm8RGyirXW4CwTMTASxpT/hQT8kiM3Tx76f8K7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0iXKVcbn5Zwrv3+0zgjnxnXCTw1UjTDMhh9g0Nw5Xk=;
 b=EZu4CemJBU5+GreHlGJhOA8Bx3hdCJhHCM3qFJFHMAkAklCJTI0Cn74sB8k1TohXMEE2TL4sxjK4eEyoMm/XOa5Pocd4veMqj9nX/Z5Cedb85xhoFZzwLKxIrK5u8GL3dVG+DfsZvKO1E3cKR9P+XeveRFLYli51uO1XLbXQ6F8c0jlqmUCV04w411xqLLIzreruosfAZX3EO4/DjCCmQ0gt3nC6jzF5MW/G0JbOFNC+0JeWXoKLMDp5QklutVYdG0ED+nySHoTeX4yu5f8JLrKHy1mnk+tqq5i2tI4dBccHNXg3Ubd1IyeSKddS0tp2ny/d+Rbe17tqUNh4O00zIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0iXKVcbn5Zwrv3+0zgjnxnXCTw1UjTDMhh9g0Nw5Xk=;
 b=TFlhu3XDaXPKJXwhktG1hV3fus+eNF87ifod94CPL9/7+74pxsDJViLSmZVf2xlQXrNXjzttpZ5fhYnoxhds3uXf0PAXG52FlLavFZJD/Y1KS1h0kLUE03f/NeyadhPtLNE0X/ciceeoYPniCVl0XcypXRHaJ/oyHKDSAb/DeGM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7169.eurprd04.prod.outlook.com (2603:10a6:208:19a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 7 Oct
 2020 09:48:38 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3455.022; Wed, 7 Oct 2020
 09:48:38 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/4] enetc: Clean up serdes configuration
Date:   Wed,  7 Oct 2020 12:48:21 +0300
Message-Id: <20201007094823.6960-3-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201007094823.6960-1-claudiu.manoil@nxp.com>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:208:14::26) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 09:48:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 327aab63-0b3b-415b-3c2c-08d86aa62a58
X-MS-TrafficTypeDiagnostic: AM0PR04MB7169:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71690295126F15D29CD79B89960A0@AM0PR04MB7169.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:24;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k8Prq7AUdCyx2/Y7p/Qqd9kn2JPERJrO4Y8Hyvj4pOVJz9h9qkP5IDj5PqcW2Gp9hrss9+9SX+2oWphHycLq2/JTTMK7GF57NRPlLZ8Qj73sV2hI8paPNw5OPUTv9MuzyEn0DZcShHaANL65RPuXonFLaDhxZ6NB0iGp2sA8P70rmEPTd4LiTSG0Dz2WNurSTfBq89Bz1bE3TiJ3lgfjeQfdo/kZi8yLlFzTB2ICoZ1R+7L4uvwAg9INsZvI4Bl1cMANK6fBSjAVgsFjGsBBs811tGItiJSzxi0NzmPCLryKd6lHtClV8fk6Xm6OUalKCW4+/e3IFKRjVih/7OzU+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(478600001)(186003)(83380400001)(8936002)(26005)(6486002)(16526019)(6916009)(44832011)(36756003)(8676002)(86362001)(2906002)(316002)(1076003)(5660300002)(6666004)(4326008)(54906003)(66556008)(66476007)(66946007)(52116002)(2616005)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hfAlpT7K7c/K3PjIAxH9AqR86YE5gnJAe9ZsFaM5Z6odGMnywbFFMKgOwkH0/0h+haaZ2+92skHFwtR0auxAJprMyr9NuktOPy8pas08UWUzMkgTDQIg0I8UvPLCjc+TBuOU2nIWDgBoH73i18Wp272Fq/3/aGwQ+o1iM9Gh0mO9nDQ8qU8m2+iblHsi4QWePMiCra5i3jDxWnBKehMAVsCpvq9wbCKaJzDhbuzQ82K9zMm0VfA4fjc1FhJWj4kGV7ImEQHLNP+0xxgxvJf8hgsPrSLinDp54FOM/5pyLpxDB8bQ85KiiBISkps6szr/ehx3x/jbKTJjSl7h/lTOvArpYJ0fTczpFfE0+o6HJPaJFTxDajuCSnHcvX52KOQeTXslokcWPbE+cEX4w+MiCrr1ZHmmDmU/8xcrAMQ+CofOaBTAhCOnw2EToEQim2azJpDNnzgI0IUMAEGL4LBs+t1Gp7d/Y4UXbe8dHJICdBSMiRy+wqSoGPhLsPZDjLX5HTrDRZMTI/cKLzgIWnN8UtSBSGE1/VXBDA3uSLh1SH5o/OtL3zUseENkkcmepACLeBn2scGjI5bjn317iAp8ED12D+3DwDG0r1R+nntW53DrUb/DxP1D7DLBGVo/uwqfsjEkoCB7sgI+ETqMd53ykg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327aab63-0b3b-415b-3c2c-08d86aa62a58
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 09:48:38.2355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7pearCwPM6eptGYRcbhyu/cpWVE3VMVofoIS2bry1DtgV9P1TSxxX0lf8+CRz1yp3XQ4k586MGVBp983BZTSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Decouple internal mdio bus creation from serdes
configuration, as a prerequisite to offloading
serdes configuration to a different module.
Group together mdio bus creation routines, cleanup.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: none

 .../net/ethernet/freescale/enetc/enetc_pf.c   | 101 +++++++++---------
 1 file changed, 48 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 64596731c1c9..6c533bf9e615 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -775,25 +775,7 @@ static int enetc_mdio_probe(struct enetc_pf *pf, struct device_node *np)
 	return 0;
 }
 
-static int enetc_mdiobus_create(struct enetc_pf *pf)
-{
-	struct device *dev = &pf->si->pdev->dev;
-	struct device_node *mdio_np;
-	int err;
-
-	mdio_np = of_get_child_by_name(dev->of_node, "mdio");
-	if (mdio_np) {
-		err = enetc_mdio_probe(pf, mdio_np);
-
-		of_node_put(mdio_np);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static void enetc_mdiobus_destroy(struct enetc_pf *pf)
+static void enetc_mdio_remove(struct enetc_pf *pf)
 {
 	if (pf->mdio)
 		mdiobus_unregister(pf->mdio);
@@ -844,7 +826,7 @@ static void enetc_of_put_phy(struct enetc_pf *pf)
 		of_node_put(pf->phy_node);
 }
 
-static int enetc_imdio_init(struct enetc_pf *pf, bool is_c45)
+static int enetc_imdio_create(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
@@ -872,7 +854,7 @@ static int enetc_imdio_init(struct enetc_pf *pf, bool is_c45)
 		goto free_mdio_bus;
 	}
 
-	pcs = get_phy_device(bus, 0, is_c45);
+	pcs = get_phy_device(bus, 0, pf->if_mode == PHY_INTERFACE_MODE_USXGMII);
 	if (IS_ERR(pcs)) {
 		err = PTR_ERR(pcs);
 		dev_err(dev, "cannot get internal PCS PHY (%d)\n", err);
@@ -901,6 +883,45 @@ static void enetc_imdio_remove(struct enetc_pf *pf)
 	}
 }
 
+static bool enetc_port_has_pcs(struct enetc_pf *pf)
+{
+	return (pf->if_mode == PHY_INTERFACE_MODE_SGMII ||
+		pf->if_mode == PHY_INTERFACE_MODE_2500BASEX ||
+		pf->if_mode == PHY_INTERFACE_MODE_USXGMII);
+}
+
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
+	if (enetc_port_has_pcs(pf)) {
+		err = enetc_imdio_create(pf);
+		if (err) {
+			enetc_mdio_remove(pf);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static void enetc_mdiobus_destroy(struct enetc_pf *pf)
+{
+	enetc_mdio_remove(pf);
+	enetc_imdio_remove(pf);
+}
+
 static void enetc_configure_sgmii(struct phy_device *pcs)
 {
 	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
@@ -940,22 +961,9 @@ static void enetc_configure_usxgmii(struct phy_device *pcs)
 		      BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
 }
 
-static int enetc_configure_serdes(struct enetc_ndev_priv *priv)
+static void enetc_configure_serdes(struct enetc_pf *pf)
 {
-	bool is_c45 = priv->if_mode == PHY_INTERFACE_MODE_USXGMII;
-	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	int err;
-
-	if (priv->if_mode != PHY_INTERFACE_MODE_SGMII &&
-	    priv->if_mode != PHY_INTERFACE_MODE_2500BASEX &&
-	    priv->if_mode != PHY_INTERFACE_MODE_USXGMII)
-		return 0;
-
-	err = enetc_imdio_init(pf, is_c45);
-	if (err)
-		return err;
-
-	switch (priv->if_mode) {
+	switch (pf->if_mode) {
 	case PHY_INTERFACE_MODE_SGMII:
 		enetc_configure_sgmii(pf->pcs);
 		break;
@@ -966,18 +974,9 @@ static int enetc_configure_serdes(struct enetc_ndev_priv *priv)
 		enetc_configure_usxgmii(pf->pcs);
 		break;
 	default:
-		dev_err(&pf->si->pdev->dev, "Unsupported link mode %s\n",
-			phy_modes(priv->if_mode));
+		dev_dbg(&pf->si->pdev->dev, "Unsupported link mode %s\n",
+			phy_modes(pf->if_mode));
 	}
-
-	return 0;
-}
-
-static void enetc_teardown_serdes(struct enetc_ndev_priv *priv)
-{
-	struct enetc_pf *pf = enetc_si_priv(priv->si);
-
-	enetc_imdio_remove(pf);
 }
 
 static int enetc_pf_probe(struct pci_dev *pdev,
@@ -1052,9 +1051,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		if (err)
 			goto err_mdiobus_create;
 
-		err = enetc_configure_serdes(priv);
-		if (err)
-			goto err_configure_serdes;
+		if (enetc_port_has_pcs(pf))
+			enetc_configure_serdes(pf);
 
 		enetc_mac_config(&pf->si->hw, pf->if_mode);
 	}
@@ -1068,8 +1066,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
-	enetc_teardown_serdes(priv);
-err_configure_serdes:
 	enetc_mdiobus_destroy(pf);
 err_mdiobus_create:
 	enetc_of_put_phy(pf);
@@ -1094,7 +1090,6 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(si->ndev);
-	enetc_teardown_serdes(priv);
 	enetc_mdiobus_destroy(pf);
 	enetc_of_put_phy(pf);
 
-- 
2.17.1

