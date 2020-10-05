Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5102837C0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgJEO2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:28:50 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:62374
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbgJEO2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:28:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cp2RRcFX4hNsT6pLXntRM3ffupy467nPVVkPUSQZq4KI2Q013weMtdvi+3RjY3Gm7i3nuMbecpmJhHGpS+UfTeP5VowNeLubTZ7UdHnF4rjknYkfNBZlV53lTcfP6Er7vU9RfISaPm1go8ttkL4RQqf1ZD9go9cyHkEogyj7WLcJASsicbeUKVy1FrtU9Eex4ZujZD/VdraTHzc9xFcIrcO+2+f+g3axG/hTGuSX2CPNX/hMyeB6wDY6/wlDn8rEqq+K6fz4adExwnDd+pSFTGLHoAK2cM1gHfzUNkpy8N+1ufdjU3+xxuBSYn3LhT4o9UN0+qCb8mp+ghHJsCV3PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjFtVGgpSKwjz/Jlkofgjdz2QAxhTKoZEbi/XG1ZVSI=;
 b=aon1vs3+MFM+SOI7VsDqcRLQbY0jJcjjQnBkeseDnK1MP25FSQXsIqWhF6WBJmnP63PQWXf75c4t3yxgdQetBf0/OLIOSfEF4YPhqjHBWoszzeGFeSN8nFNwhSc2Lbc4LYO10yCplbwFfPpvLE95n3D0iYdVSRnKoilPdJ6ui+U7rtuW13DnlNrFT19v+gSxV4JAk+8SBQvlR2E0+5jf41LTAKArJdaAYj6FnmikEHAuVq8yVj9wwsHFoLnCAfQFZdrjoSWxiT0kpLujMFFQPmDWAmppUgGDUSJFHJ4yiqjX6XPwbylmt3Faj6CBnbxVgYJiwYSywe7G3VIBNJqNaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjFtVGgpSKwjz/Jlkofgjdz2QAxhTKoZEbi/XG1ZVSI=;
 b=OpAKL+r1olu5EHoqpCqhsnDGsQNgbtNK2r3cypJJf9M+27dplEX9lpFTKo5HsDgudQuqXOsiGoMvKCyJFNakVtRJCFDAu2XIbaTfas7eAJgE3IbhBhXIBVV/JUBveYpU3d6hrPt76569gfC/ypc33tFDRnrXjd3omdAkOcnyZGg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7171.eurprd04.prod.outlook.com (2603:10a6:208:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Mon, 5 Oct
 2020 14:28:33 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 14:28:33 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/4] enetc: Clean up serdes configuration
Date:   Mon,  5 Oct 2020 17:28:16 +0300
Message-Id: <20201005142818.15110-3-claudiu.manoil@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 67f11cf0-bb19-4b1c-8873-08d8693af034
X-MS-TrafficTypeDiagnostic: AM0PR04MB7171:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71714C3A059DD0EEA7FC764A960C0@AM0PR04MB7171.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:24;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xn6GThffUYmsB1RAn0QSPUcDtXtWUJFL74egih20aH06JoTc+tepeb75gtPK7zeSnkZde+LreWwhL/16lepmJRdeqVndhUn1AhTbfl6X8v+HWxzXWSvNS53CFcxdTMf3Pi/mXuhNegB1qz85h4AIWOX/Qw4j3xACAove3EiY0a8sg7TEHEL/j/Gy8AjB4QjDtqoTo51b/nFGPHHow4PESUNE9cz9pH8gLUuuW5EPpdjk9QMWQ0lOzSt8gE4fRXaepsocUCMGIpr7w8hrcS1Ngik571h8aZlJdk/4+rG79PGjGVTpOaYq4rnIwfmEZVzWiNNrv9kDLt7xiQki3oDvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(36756003)(6486002)(8676002)(2616005)(4326008)(956004)(6666004)(2906002)(7696005)(52116002)(6916009)(16526019)(26005)(8936002)(186003)(86362001)(54906003)(1076003)(478600001)(316002)(83380400001)(66476007)(44832011)(66946007)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DovgA9BDJ2UuJoF1TNTva8uR8H/ZsPwZEyfOoXuNbUtundQZdmUj3iUt3czPzvtKHiQPVmqlDDYnQilc7zxO0EgEOqVWxne0T1IwMF/eSjhdf4TCmzTQ2a5riWWfpdLMqMgEnLHV/n+dDiEaUZ1Z7tHNwkoRG7rVJv1/Qo0iMZxBsqhVu6y7shwVPtSh3lOapbcbXMhhS61JtHkoCPKZjqJVni3FbjO1W0xVg9SC5YK3kryFlxKjs6fqONCGxZ8CKNbnQZGqA6GXyWDvnIrjJUGCvV840bbOQQzwsoSg+ko5Wy/ZvPVYY4+klSf3ObN/sWS6UPIezI5evL9UOyBjWi2bsUzPavWtKiu82qMZhaCaziNV40w9vHCQnkAlY0LBm3sICRMP0OAdd/2VQ7HPFRZCdds7ZYH/vIfJVjglAdVkF1Vy5m2mYD0oCJi8GOqiYV4X20ZPz3sJXL2LZwVOAUtSMEFa0TiZUY9jZNo7Zfz4G7SRsf+8XVim5H2x4jqjjnCjXsN7W0RoqYe/5VBPi5zAMdR+tdGMm7LLRXH3dW7Zl8D5omu6M0mKB5woUgrvd1DkN/L/ocDAr1AtRThaiaR97jXZIdwtzA97GC2Mzincw6f3tvmdCjiGlJDVH6WMD6L2VCbE2vecU8zjAgZ0RQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f11cf0-bb19-4b1c-8873-08d8693af034
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 14:28:33.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwZIpQngQmLmhGwEdvySHxTD6a/aSgS0sQ8uWyZvvOlVbhBARU7o3Be7jSa8TDNqzmNJqEwDWWztXtlgleTsvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7171
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Decouple internal mdio bus creation from serdes
configuration, as a prerequisite to offloading
serdes configuration to a different module.
Group together mdio bus creation routines, cleanup.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
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

