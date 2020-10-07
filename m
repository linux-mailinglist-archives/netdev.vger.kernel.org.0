Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C19285C0F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgJGJsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:48:55 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:16619
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbgJGJsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 05:48:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLiHczVvKxf9IJC8sKnQmRI4rBU8DMGS8hMDn6BpqbJicKxR57foFI2zCWQvwkWMOw6Chg2pFC6UYo4S2EOLL3fZN2QjcoA7W+I5fG46xA0TzM/LvGuswSpgax52Frl4U97ZJMBNe6lRza6eYjfXBU084axqaWGSjSEKzBqwqXYN19o7UHIhWbFBRyAczVVdNq97pSOUOwyHytSJo2ARRuCOD5Y5YKfqONV5gNii9qiPlU5Jk6RkIHbxX/vICmJZ1pWpMaRBTmYz99cJAbkCnIneM9/Uy4pJGuHE7pliTCKeOTgSwpITVgySVNNuYGNZcZJEVpcIomgL6kMZ4bqT3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0O0BsR5M8hJV6uAgU0gRGDblTNe3QVIcTiirTwbSdjE=;
 b=MkmpgI+l9MxoxHI7tqVaPVpyeVAIcxrTfLmYdip/TT/y/rtVX9Yq2MsXfIwv00pywRqpIVPBgwSclj4iOBq+dF9ObcUddrNPhRXbISpPYYPKV7jntWoadMw3A2ilgOC7yRUGu+zn/qjTDgOjTV38djitK2Oyrv6Gm9r2BpK9OZMk2bSQJfiACwF0TMrh7hb5gniOqGBEYJw96ivriNBKKWctXDBjSf2EJbqp+nsfEjcVuzSmpNumHC9D+FRdP5hmDi9y/1ljSdGqRMvU9mFYwQdBGu13UMaDn4KR6ccl+xQBXcd3XcYZh8T04fLAKM+vE+gNkQkxlG5swCW4d6dzTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0O0BsR5M8hJV6uAgU0gRGDblTNe3QVIcTiirTwbSdjE=;
 b=YUcAtvotxF/GNZmYC9hFRCJ86RT8Xhe8n8Krwoml4cTLSY7f48lBasPVJcB4URKaX+X/vVse2qq86Vz7U6nthB6otn5tjV5gYxcGf83kN5twPfIQpHGXW48eSYVCwXPEeAvh+XUWHV/D5QVgMzMzDpOXtUfb5qDKacMqCWdobdQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7169.eurprd04.prod.outlook.com (2603:10a6:208:19a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 7 Oct
 2020 09:48:39 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3455.022; Wed, 7 Oct 2020
 09:48:39 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Date:   Wed,  7 Oct 2020 12:48:23 +0300
Message-Id: <20201007094823.6960-5-claudiu.manoil@nxp.com>
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
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 09:48:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6963367e-2ec4-4f90-21a0-08d86aa62b24
X-MS-TrafficTypeDiagnostic: AM0PR04MB7169:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71697127918E9505FCAED1D5960A0@AM0PR04MB7169.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yvmpaEKCSZDlFwLcppHaIOvzalmJUgD3yrfzGR+rf6ehNNThPRRmOaGZZ2vRHaYCCXgFWQpptkKsQAFuox9f1WAr851/PniLfxcOTAPyWpUEvTeUE5KAjXRLukB7yJzKyNAqPdCkpLfV4f9tdOkXGuoZVNgi2nFTMWRtO9NoHqp9CwTDXw5BKSSTW33R1G7/aAno/OagqLbXAIXosko5UvdQqngOQ4q8Y72SHI8KSJO5q6ybTKZ3yqahEND8vBbEh5s0L1oB987WM6HBXnMdSOzqKTzp8QDeEpCVD0TpdaV0UEP62y7jQpb6huW7UfDQAupvGJFNao72ahi/40U6Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(478600001)(186003)(83380400001)(8936002)(26005)(6486002)(16526019)(6916009)(44832011)(36756003)(8676002)(86362001)(2906002)(316002)(1076003)(5660300002)(6666004)(4326008)(54906003)(30864003)(66556008)(66476007)(66946007)(52116002)(2616005)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /HCQhvxTGYsEdX8w4cyWE6IZMa8vyvQ6njy2Bf5EbtJebSeOMw2CVu2u/AVAqKz24ttaiZi8YSRbCEhinkhPx+zrR2FlT+bUJWqb/5JO1sf6qlwXLPixFmhFQvNqZZptKOzNq7DFZiaa4Rrg7QvJY5ilCkft5y0DWIMoX/Hh86bQPqu+R9yCDLZXB689MGODQOllSwRliK9W5idizx5rU8z4UjQpNprM0rnK322cvyf3h8zHvw/80Vg4B2oFTZhScVLEaFEaOt5S4SoHS3y9Kly3bbzZU7s5TqFUIuxNp02k9nONUrjqcDOMHNaZ9pTHI7MkKT+9cXsEGzhkhExjNUJmoT4tEQ7bNpwnLb/zhkoPcOY4DdqSqXDQ9DGLPxBu+4VfGyNpuvnRQb5dy+xIezM/Gzn4zBmUXF7E6WnEztKj2IIAzdSNhapo/TaADhcxCw+wEaU1Wxm+wzEgWFT5K8aNKqSlJXVm+9iXVQmZ7Mzw/xMRdL+KGRremK0wdE6z2ZIS2Aq8UTiJvg80cny8oBUwwO7Kwa7Bqjd5kJcjCoHnE1oQAkmVobQC+9BDIeIUse3id6l6KhQvvIIdDSq/UIQKjUn9ks4SlO3YfrxR3qXRPjB5guBYjG+qkSJLAieXjmhIfXaoYQzkJFeP6y9ZhA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6963367e-2ec4-4f90-21a0-08d86aa62b24
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 09:48:39.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4sVI4gIU5GePOnLm4hjJ/aXISHqtKU8l89jSiD1jDKJCdQ7EPeF6c43rz0d+OsSr4BHFeD4vis9zHgQF4735A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a methodical transition of the driver from phylib
to phylink, following the guidelines from sfp-phylink.rst.
The MAC register configurations based on interface mode
were moved from the probing path to the mac_config() hook.
MAC enable and disable commands (enabling Rx and Tx paths
at MAC level) were also extracted and assigned to their
corresponding phylink hooks.
As part of the migration to phylink, the serdes configuration
from the driver was offloaded to the PCS_LYNX module,
introduced in commit 0da4c3d393e4 ("net: phy: add Lynx PCS module"),
the PCS_LYNX module being a mandatory component required to
make the enetc driver work with phylink.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: validate() explicitly rejects now all interface modes not
supported by the driver instead of relying on the device tree
to provide only supported interfaces, and dropped redundant
activation of pcs_poll (addressing Ioana's findings)

 drivers/net/ethernet/freescale/enetc/Kconfig  |   5 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  53 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |   9 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  26 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 247 ++++++++++--------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   8 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   9 +-
 7 files changed, 191 insertions(+), 166 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 37b804f8bd76..0fa18b00c49b 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -3,7 +3,8 @@ config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI
 	select FSL_ENETC_MDIO
-	select PHYLIB
+	select PHYLINK
+	select PCS_LYNX
 	select DIMLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
@@ -15,7 +16,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI
-	select PHYLIB
+	select PHYLINK
 	select DIMLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f78ca7b343d2..52be6e315752 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -4,7 +4,6 @@
 #include "enetc.h"
 #include <linux/tcp.h>
 #include <linux/udp.h>
-#include <linux/of_mdio.h>
 #include <linux/vmalloc.h>
 
 /* ENETC overhead: optional extension BD + 1 BD gap */
@@ -1392,38 +1391,24 @@ static void enetc_clear_interrupts(struct enetc_ndev_priv *priv)
 		enetc_rxbdr_wr(&priv->si->hw, i, ENETC_RBIER, 0);
 }
 
-static void adjust_link(struct net_device *ndev)
+static int enetc_phylink_connect(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct phy_device *phydev = ndev->phydev;
-
-	if (priv->active_offloads & ENETC_F_QBV)
-		enetc_sched_speed_set(ndev);
-
-	phy_print_status(phydev);
-}
-
-static int enetc_phy_connect(struct net_device *ndev)
-{
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct phy_device *phydev;
 	struct ethtool_eee edata;
+	int err;
 
-	if (!priv->phy_node)
+	if (!priv->phylink)
 		return 0; /* phy-less mode */
 
-	phydev = of_phy_connect(ndev, priv->phy_node, &adjust_link,
-				0, priv->if_mode);
-	if (!phydev) {
+	err = phylink_of_phy_connect(priv->phylink, priv->dev->of_node, 0);
+	if (err) {
 		dev_err(&ndev->dev, "could not attach to PHY\n");
-		return -ENODEV;
+		return err;
 	}
 
-	phy_attached_info(phydev);
-
 	/* disable EEE autoneg, until ENETC driver supports it */
 	memset(&edata, 0, sizeof(struct ethtool_eee));
-	phy_ethtool_set_eee(phydev, &edata);
+	phylink_ethtool_set_eee(priv->phylink, &edata);
 
 	return 0;
 }
@@ -1443,8 +1428,8 @@ void enetc_start(struct net_device *ndev)
 		enable_irq(irq);
 	}
 
-	if (ndev->phydev)
-		phy_start(ndev->phydev);
+	if (priv->phylink)
+		phylink_start(priv->phylink);
 	else
 		netif_carrier_on(ndev);
 
@@ -1460,7 +1445,7 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		return err;
 
-	err = enetc_phy_connect(ndev);
+	err = enetc_phylink_connect(ndev);
 	if (err)
 		goto err_phy_connect;
 
@@ -1490,8 +1475,8 @@ int enetc_open(struct net_device *ndev)
 err_alloc_rx:
 	enetc_free_tx_resources(priv);
 err_alloc_tx:
-	if (ndev->phydev)
-		phy_disconnect(ndev->phydev);
+	if (priv->phylink)
+		phylink_disconnect_phy(priv->phylink);
 err_phy_connect:
 	enetc_free_irqs(priv);
 
@@ -1514,8 +1499,8 @@ void enetc_stop(struct net_device *ndev)
 		napi_disable(&priv->int_vector[i]->napi);
 	}
 
-	if (ndev->phydev)
-		phy_stop(ndev->phydev);
+	if (priv->phylink)
+		phylink_stop(priv->phylink);
 	else
 		netif_carrier_off(ndev);
 
@@ -1529,8 +1514,8 @@ int enetc_close(struct net_device *ndev)
 	enetc_stop(ndev);
 	enetc_clear_bdrs(priv);
 
-	if (ndev->phydev)
-		phy_disconnect(ndev->phydev);
+	if (priv->phylink)
+		phylink_disconnect_phy(priv->phylink);
 	enetc_free_rxtx_rings(priv);
 	enetc_free_rx_resources(priv);
 	enetc_free_tx_resources(priv);
@@ -1780,6 +1765,7 @@ static int enetc_hwtstamp_get(struct net_device *ndev, struct ifreq *ifr)
 
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 {
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (cmd == SIOCSHWTSTAMP)
 		return enetc_hwtstamp_set(ndev, rq);
@@ -1787,9 +1773,10 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 		return enetc_hwtstamp_get(ndev, rq);
 #endif
 
-	if (!ndev->phydev)
+	if (!priv->phylink)
 		return -EOPNOTSUPP;
-	return phy_mii_ioctl(ndev->phydev, rq, cmd);
+
+	return phylink_mii_ioctl(priv->phylink, rq, cmd);
 }
 
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index d309803cfeb6..dd0fb0c066d7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -9,7 +9,7 @@
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/dim.h>
 
 #include "enetc_hw.h"
@@ -264,8 +264,7 @@ struct enetc_ndev_priv {
 
 	struct psfp_cap psfp_cap;
 
-	struct device_node *phy_node;
-	phy_interface_t if_mode;
+	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
 };
@@ -323,7 +322,7 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
 
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
-void enetc_sched_speed_set(struct net_device *ndev);
+void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
@@ -388,7 +387,7 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
-#define enetc_sched_speed_set(ndev) (void)0
+#define enetc_sched_speed_set(priv, speed) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_psfp(ndev, type_data) -EOPNOTSUPP
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 1dab83fbca77..8ed1ebd5a183 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -686,6 +686,28 @@ static int enetc_set_wol(struct net_device *dev,
 	return ret;
 }
 
+static int enetc_get_link_ksettings(struct net_device *dev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(dev);
+
+	if (!priv->phylink)
+		return -EOPNOTSUPP;
+
+	return phylink_ethtool_ksettings_get(priv->phylink, cmd);
+}
+
+static int enetc_set_link_ksettings(struct net_device *dev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(dev);
+
+	if (!priv->phylink)
+		return -EOPNOTSUPP;
+
+	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
+}
+
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -704,8 +726,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_ringparam = enetc_get_ringparam,
 	.get_coalesce = enetc_get_coalesce,
 	.set_coalesce = enetc_set_coalesce,
-	.get_link_ksettings = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_link_ksettings = enetc_get_link_ksettings,
+	.set_link_ksettings = enetc_set_link_ksettings,
 	.get_link = ethtool_op_get_link,
 	.get_ts_info = enetc_get_ts_info,
 	.get_wol = enetc_get_wol,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 6c533bf9e615..419306342ac5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -499,8 +499,6 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 
 static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 {
-	u32 val;
-
 	/* set auto-speed for RGMII */
 	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
 	    phy_interface_mode_is_rgmii(phy_mode))
@@ -508,14 +506,17 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 
 	if (phy_mode == PHY_INTERFACE_MODE_USXGMII)
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
+}
+
+static void enetc_mac_enable(struct enetc_hw *hw, bool en)
+{
+	u32 val = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
 
-	/* enable Rx and Tx */
-	val = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
-	enetc_port_wr(hw, ENETC_PM0_CMD_CFG,
-		      val | ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
+	val &= ~(ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
+	val |= en ? (ENETC_PM0_TX_EN | ENETC_PM0_RX_EN) : 0;
 
-	enetc_port_wr(hw, ENETC_PM1_CMD_CFG,
-		      val | ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
+	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, val);
+	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, val);
 }
 
 static void enetc_configure_port_pmac(struct enetc_hw *hw)
@@ -781,56 +782,12 @@ static void enetc_mdio_remove(struct enetc_pf *pf)
 		mdiobus_unregister(pf->mdio);
 }
 
-static int enetc_of_get_phy(struct enetc_pf *pf)
-{
-	struct device *dev = &pf->si->pdev->dev;
-	struct device_node *np = dev->of_node;
-	int err;
-
-	pf->phy_node = of_parse_phandle(np, "phy-handle", 0);
-	if (!pf->phy_node) {
-		if (!of_phy_is_fixed_link(np)) {
-			dev_dbg(dev, "PHY not specified\n");
-			return 0;
-		}
-
-		err = of_phy_register_fixed_link(np);
-		if (err < 0) {
-			dev_err(dev, "fixed link registration failed\n");
-			return err;
-		}
-
-		pf->phy_node = of_node_get(np);
-	}
-
-	err = of_get_phy_mode(np, &pf->if_mode);
-	if (err) {
-		dev_err(dev, "missing phy type\n");
-		of_node_put(pf->phy_node);
-		if (of_phy_is_fixed_link(np))
-			of_phy_deregister_fixed_link(np);
-
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static void enetc_of_put_phy(struct enetc_pf *pf)
-{
-	struct device_node *np = pf->si->pdev->dev.of_node;
-
-	if (np && of_phy_is_fixed_link(np))
-		of_phy_deregister_fixed_link(np);
-	if (pf->phy_node)
-		of_node_put(pf->phy_node);
-}
-
 static int enetc_imdio_create(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
-	struct phy_device *pcs;
+	struct lynx_pcs *pcs_lynx;
+	struct mdio_device *pcs;
 	struct mii_bus *bus;
 	int err;
 
@@ -854,15 +811,23 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	pcs = get_phy_device(bus, 0, pf->if_mode == PHY_INTERFACE_MODE_USXGMII);
+	pcs = mdio_device_create(bus, 0);
 	if (IS_ERR(pcs)) {
 		err = PTR_ERR(pcs);
-		dev_err(dev, "cannot get internal PCS PHY (%d)\n", err);
+		dev_err(dev, "cannot create pcs (%d)\n", err);
+		goto unregister_mdiobus;
+	}
+
+	pcs_lynx = lynx_pcs_create(pcs);
+	if (!pcs_lynx) {
+		mdio_device_free(pcs);
+		err = -ENOMEM;
+		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
 	}
 
 	pf->imdio = bus;
-	pf->pcs = pcs;
+	pf->pcs = pcs_lynx;
 
 	return 0;
 
@@ -875,8 +840,10 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
-	if (pf->pcs)
-		put_device(&pf->pcs->mdio.dev);
+	if (pf->pcs) {
+		mdio_device_free(pf->pcs->mdio);
+		lynx_pcs_destroy(pf->pcs);
+	}
 	if (pf->imdio) {
 		mdiobus_unregister(pf->imdio);
 		mdiobus_free(pf->imdio);
@@ -922,61 +889,119 @@ static void enetc_mdiobus_destroy(struct enetc_pf *pf)
 	enetc_imdio_remove(pf);
 }
 
-static void enetc_configure_sgmii(struct phy_device *pcs)
+static void enetc_pl_mac_validate(struct phylink_config *config,
+				  unsigned long *supported,
+				  struct phylink_link_state *state)
 {
-	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
-	 * for the MAC PCS in order to acknowledge the AN.
-	 */
-	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII | ADVERTISE_LPACK);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
+	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    state->interface != PHY_INTERFACE_MODE_2500BASEX &&
+	    state->interface != PHY_INTERFACE_MODE_USXGMII &&
+	    !phy_interface_mode_is_rgmii(state->interface)) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
 
-	phy_write(pcs, ENETC_PCS_IF_MODE,
-		  ENETC_PCS_IF_MODE_SGMII_EN |
-		  ENETC_PCS_IF_MODE_USE_SGMII_AN);
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 1000baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+
+	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
+	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
+	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
 
-	/* Adjust link timer for SGMII */
-	phy_write(pcs, ENETC_PCS_LINK_TIMER1, ENETC_PCS_LINK_TIMER1_VAL);
-	phy_write(pcs, ENETC_PCS_LINK_TIMER2, ENETC_PCS_LINK_TIMER2_VAL);
+static void enetc_pl_mac_config(struct phylink_config *config,
+				unsigned int mode,
+				const struct phylink_link_state *state)
+{
+	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+	struct enetc_ndev_priv *priv;
 
-	phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
+	enetc_mac_config(&pf->si->hw, state->interface);
+
+	priv = netdev_priv(pf->si->ndev);
+	if (pf->pcs)
+		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
 }
 
-static void enetc_configure_2500basex(struct phy_device *pcs)
+static void enetc_pl_mac_link_up(struct phylink_config *config,
+				 struct phy_device *phy, unsigned int mode,
+				 phy_interface_t interface, int speed,
+				 int duplex, bool tx_pause, bool rx_pause)
 {
-	phy_write(pcs, ENETC_PCS_IF_MODE,
-		  ENETC_PCS_IF_MODE_SGMII_EN |
-		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
+	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+	struct enetc_ndev_priv *priv;
+
+	priv = netdev_priv(pf->si->ndev);
+	if (priv->active_offloads & ENETC_F_QBV)
+		enetc_sched_speed_set(priv, speed);
 
-	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_RESET);
+	enetc_mac_enable(&pf->si->hw, true);
 }
 
-static void enetc_configure_usxgmii(struct phy_device *pcs)
+static void enetc_pl_mac_link_down(struct phylink_config *config,
+				   unsigned int mode,
+				   phy_interface_t interface)
 {
-	/* Configure device ability for the USXGMII Replicator */
-	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
-		      ADVERTISE_SGMII | ADVERTISE_LPACK |
-		      MDIO_USXGMII_FULL_DUPLEX);
-
-	/* Restart PCS AN */
-	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_BMCR,
-		      BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
+	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+
+	enetc_mac_enable(&pf->si->hw, false);
 }
 
-static void enetc_configure_serdes(struct enetc_pf *pf)
+static const struct phylink_mac_ops enetc_mac_phylink_ops = {
+	.validate = enetc_pl_mac_validate,
+	.mac_config = enetc_pl_mac_config,
+	.mac_link_up = enetc_pl_mac_link_up,
+	.mac_link_down = enetc_pl_mac_link_down,
+};
+
+static int enetc_phylink_create(struct enetc_ndev_priv *priv)
 {
-	switch (pf->if_mode) {
-	case PHY_INTERFACE_MODE_SGMII:
-		enetc_configure_sgmii(pf->pcs);
-		break;
-	case PHY_INTERFACE_MODE_2500BASEX:
-		enetc_configure_2500basex(pf->pcs);
-		break;
-	case PHY_INTERFACE_MODE_USXGMII:
-		enetc_configure_usxgmii(pf->pcs);
-		break;
-	default:
-		dev_dbg(&pf->si->pdev->dev, "Unsupported link mode %s\n",
-			phy_modes(pf->if_mode));
+	struct enetc_pf *pf = enetc_si_priv(priv->si);
+	struct device *dev = &pf->si->pdev->dev;
+	struct phylink *phylink;
+	int err;
+
+	pf->phylink_config.dev = &priv->ndev->dev;
+	pf->phylink_config.type = PHYLINK_NETDEV;
+
+	phylink = phylink_create(&pf->phylink_config,
+				 of_fwnode_handle(dev->of_node),
+				 pf->if_mode, &enetc_mac_phylink_ops);
+	if (IS_ERR(phylink)) {
+		err = PTR_ERR(phylink);
+		return err;
 	}
+
+	priv->phylink = phylink;
+
+	return 0;
+}
+
+static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
+{
+	if (priv->phylink)
+		phylink_destroy(priv->phylink);
 }
 
 static int enetc_pf_probe(struct pci_dev *pdev,
@@ -1039,37 +1064,27 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	err = enetc_of_get_phy(pf);
-	if (err)
-		goto err_of_get_phy;
-
-	if (pf->phy_node) {
-		priv->phy_node = pf->phy_node;
-		priv->if_mode = pf->if_mode;
-
+	if (!of_get_phy_mode(pdev->dev.of_node, &pf->if_mode)) {
 		err = enetc_mdiobus_create(pf);
 		if (err)
 			goto err_mdiobus_create;
 
-		if (enetc_port_has_pcs(pf))
-			enetc_configure_serdes(pf);
-
-		enetc_mac_config(&pf->si->hw, pf->if_mode);
+		err = enetc_phylink_create(priv);
+		if (err)
+			goto err_phylink_create;
 	}
 
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
 
-	netif_carrier_off(ndev);
-
 	return 0;
 
 err_reg_netdev:
+	enetc_phylink_destroy(priv);
+err_phylink_create:
 	enetc_mdiobus_destroy(pf);
 err_mdiobus_create:
-	enetc_of_put_phy(pf);
-err_of_get_phy:
 	enetc_free_msix(priv);
 err_alloc_msix:
 	enetc_free_si_resources(priv);
@@ -1090,8 +1105,8 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(si->ndev);
+	enetc_phylink_destroy(priv);
 	enetc_mdiobus_destroy(pf);
-	enetc_of_put_phy(pf);
 
 	if (pf->num_vfs)
 		enetc_sriov_configure(pdev, 0);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 0d0ee91282a5..263946c51e37 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -2,6 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include "enetc.h"
+#include <linux/pcs-lynx.h>
 
 #define ENETC_PF_NUM_RINGS	8
 
@@ -45,12 +46,15 @@ struct enetc_pf {
 
 	struct mii_bus *mdio; /* saved for cleanup */
 	struct mii_bus *imdio;
-	struct phy_device *pcs;
+	struct lynx_pcs *pcs;
 
-	struct device_node *phy_node;
 	phy_interface_t if_mode;
+	struct phylink_config phylink_config;
 };
 
+#define phylink_to_enetc_pf(config) \
+	container_of((config), struct enetc_pf, phylink_config)
+
 int enetc_msg_psi_init(struct enetc_pf *pf);
 void enetc_msg_psi_free(struct enetc_pf *pf);
 void enetc_msg_handle_rxmsg(struct enetc_pf *pf, int mbox_id, u16 *status);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 1c4a535890da..c81be32bcedf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -15,17 +15,14 @@ static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 		& ENETC_QBV_MAX_GCL_LEN_MASK;
 }
 
-void enetc_sched_speed_set(struct net_device *ndev)
+void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 {
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct phy_device *phydev = ndev->phydev;
 	u32 old_speed = priv->speed;
-	u32 speed, pspeed;
+	u32 pspeed;
 
-	if (phydev->speed == old_speed)
+	if (speed == old_speed)
 		return;
 
-	speed = phydev->speed;
 	switch (speed) {
 	case SPEED_1000:
 		pspeed = ENETC_PMR_PSPEED_1000M;
-- 
2.17.1

