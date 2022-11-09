Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0016236C6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiKIWsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKIWsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:48:12 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A392C10A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 14:48:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/Dw5rUQF1QQbvvMCewsCRyqx/vImKNb6rnEtC91K0j0S9VCMbAuSAZcfepemAd50OIyzym5RRTR2+kVoilmQNh0ECzrGV4TyHbsdnx8NW6DWEYhXDD1XYRQNQgRbRHKT0uH8C+79EGHbARJZwFtVhOXwZNUl38ocnWj8M5QeW0nN7PM4Dq4famiqkMaS2bn9tjMG01XEtF3nT3CusDKMGPIUHC1w93wIItNVOHXA54JCP9/fuh7ViszX2p3nYHBK8xVYaOQl9CTW2h2YICF9pVgsoowe5ukLr1pF2t+yfK/YlKL50bJxmBzNMm16rm/6NB0NotYrKf8wmnJ/JucrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgUpjAgjn4B5C0AFBDEHNeQkrRwTndCwDaieY7Y/+E0=;
 b=VG4nEotsQQbt12Dv+xsPSYEDhJ0OkNYwmUMgqXpThWhDL/Zu7PUhUwtHVXJZroKJ+Zj/3d1fwNKepJmXYNf3lqOyJeuAZiqZcluonpvodGoG5GhtcdIgEo34aZkYgrY5tzm17YOcvxqE3JyQAey9ppPXsPX0isE2bR2+E336sxqjyQpW43CERQuhWsqJHRkn3SAjmWZytKjT6okeRAVGZfir4V5LjEJL3dK7GGQJ96ZmyEhA35ixkZM3cLleXD+1shLUDNvq4Dg1+sVj2kfGvdGThLNlqoCPCdPquWlll82abqeRoj/sAvDPKHcDytU1F3YKfAnUdTvr/u30A27k+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgUpjAgjn4B5C0AFBDEHNeQkrRwTndCwDaieY7Y/+E0=;
 b=GbuxnGL9Pa0n3/w8zCGY8nIsxS1Y0uUa8MiTQ4Pxg1gIolsAqyQT5/1uB0n7CRqTp7UoHEQe8A8r2khlqE3iqHOlNohATe6rSP9CybNlOdCtP5NzvhDnmSKZ+bjCYTjnnle4DZoxOkShRdjl9/CGj0LpTRtGt2xjhq5ZZX6Z7E5NsSLJwiqZyycmBqYcDrxLVlUZsTLGWs5T1En3baObPqUu6522XjEQbz3Bnrf6/YQvZ93lK0uivfIgbM4WXpH5Mk1yli1BYB3RLbXhfFf+Jd0KN1F9cIQx/UQN8FIAEaRgT7s9K/2COpaiG+oEHKKi+pDfcZ+EVtu5KFHG+dRFWA==
Received: from DM6PR02CA0148.namprd02.prod.outlook.com (2603:10b6:5:332::15)
 by SJ0PR12MB7033.namprd12.prod.outlook.com (2603:10b6:a03:448::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 22:48:10 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::24) by DM6PR02CA0148.outlook.office365.com
 (2603:10b6:5:332::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12 via Frontend
 Transport; Wed, 9 Nov 2022 22:48:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Wed, 9 Nov 2022 22:48:09 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 9 Nov 2022
 14:48:03 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 9 Nov 2022 14:48:02 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 9 Nov 2022 14:48:01 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v2 2/4] mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
Date:   Wed, 9 Nov 2022 17:47:50 -0500
Message-ID: <20221109224752.17664-3-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221109224752.17664-1-davthompson@nvidia.com>
References: <20221109224752.17664-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|SJ0PR12MB7033:EE_
X-MS-Office365-Filtering-Correlation-Id: ad29e622-2e4e-467b-c57a-08dac2a479d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wDEoAxX05cwzl2GHsnLUaBSqAY4xW9B2vPypTv+HAEpYD8cavhCiBdZipIoSK/YRdmITaM331buRTyPVbDSps/U/52r+D6yEvdZFZKk7hKG1BWEe2N06o/Zlu3iQmNvumbq2QyvssmNukFt0PB+WQGfa0swbYwY6FjT/9cL/SAWCQcLdxkRudyUDwH7CEyNqksCAE/11zvJvtwETBqIevf+FQzLQ3/9J34tA4d+xq8wqwZpvNJUrF0tw56TCdZYgb15Z90VqhIJIDa+s5vgQAwoYaGY+cIvOeMKXCjVMwpgy7jSsGG6T/6H7sazldmLY1Iu6vD+GPZ0YY3RU34qidHMtUnvRtRBkT6LO1FMNKdFCHZnN2oWMBcFLMY6+XwjlOjtRiw3yva/a6Wewdzgk4f2yvLtSf5gp6rLY1oNhL9wIBIt4FAoalkJ2PAFas7eV/qtvUV8zmh9duxodq6+UeuwhU9a/WdXxaDTEcInWcy0ruZyp0mhAT+rXvwVLx1Vcl1TSeY7j8X4vwM6rTowMY00gBjLmX0JCtDAVr+qphGSCds1VoCd3nAlJj3JeMMSol/Aez+MGTE+wGKruadVldAd5NWprwgjqZUJ3GDnu3XkTm+nnNPQHlg+nxM09QvmI9wi1g0jDmWDxVDsKDCnFkt7kovpkcCP2do31pUCuawnsEr5QpWZW/nRBfPaResAC+JrO0ULgPYxAlM+ct+/wITyl/e011sThmUpVUsCQ9ak6nIqq6le7AfOOiTQL3Ej2ES375tkPCnZDDyehlzIDTQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(107886003)(82310400005)(5660300002)(8936002)(70586007)(70206006)(4326008)(8676002)(110136005)(54906003)(316002)(478600001)(36756003)(40480700001)(7696005)(186003)(426003)(1076003)(2616005)(41300700001)(47076005)(40460700003)(336012)(83380400001)(2906002)(36860700001)(6666004)(26005)(86362001)(7636003)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:48:09.9418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad29e622-2e4e-467b-c57a-08dac2a479d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7033
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BlueField-3 OOB interface supports 10Mbps, 100Mbps, and 1Gbps speeds.
The external PHY is responsible for autonegotiating the speed with the
link partner. Once the autonegotiation is done, the BlueField PLU needs
to be configured accordingly.

This patch does two things:
1) Initialize the advertised control flow/duplex/speed in the probe
   based on the BlueField SoC generation (2 or 3)
2) Adjust the PLU speed config in the PHY interrupt handler

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |   8 ++
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     | 105 +++++++++++++++---
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |  21 ++++
 3 files changed, 119 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index 421a0b1b766c..a453b9cd9033 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -14,6 +14,7 @@
 #include <linux/irqreturn.h>
 #include <linux/netdevice.h>
 #include <linux/irq.h>
+#include <linux/phy.h>
 
 /* The silicon design supports a maximum RX ring size of
  * 32K entries. Based on current testing this maximum size
@@ -84,6 +85,12 @@ struct mlxbf_gige_mdio_gw {
 	struct mlxbf_gige_reg_param st1;
 };
 
+struct mlxbf_gige_link_cfg {
+	void (*set_phy_link_mode)(struct phy_device *phydev);
+	void (*adjust_link)(struct net_device *netdev);
+	phy_interface_t phy_mode;
+};
+
 struct mlxbf_gige {
 	void __iomem *base;
 	void __iomem *llu_base;
@@ -121,6 +128,7 @@ struct mlxbf_gige {
 	struct mlxbf_gige_stats stats;
 	u8 hw_version;
 	struct mlxbf_gige_mdio_gw *mdio_gw;
+	int prev_speed;
 };
 
 /* Rx Work Queue Element definitions */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index e08c07e914c1..32d7030eb2cf 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -263,13 +263,99 @@ static const struct net_device_ops mlxbf_gige_netdev_ops = {
 	.ndo_get_stats64        = mlxbf_gige_get_stats64,
 };
 
-static void mlxbf_gige_adjust_link(struct net_device *netdev)
+static void mlxbf_gige_bf2_adjust_link(struct net_device *netdev)
 {
 	struct phy_device *phydev = netdev->phydev;
 
 	phy_print_status(phydev);
 }
 
+static void mlxbf_gige_bf3_adjust_link(struct net_device *netdev)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	u8 sgmii_mode;
+	u16 ipg_size;
+	u32 val;
+
+	if (phydev->link && phydev->speed != priv->prev_speed) {
+		switch (phydev->speed) {
+		case 1000:
+			ipg_size = MLXBF_GIGE_1G_IPG_SIZE;
+			sgmii_mode = MLXBF_GIGE_1G_SGMII_MODE;
+			break;
+		case 100:
+			ipg_size = MLXBF_GIGE_100M_IPG_SIZE;
+			sgmii_mode = MLXBF_GIGE_100M_SGMII_MODE;
+			break;
+		case 10:
+			ipg_size = MLXBF_GIGE_10M_IPG_SIZE;
+			sgmii_mode = MLXBF_GIGE_10M_SGMII_MODE;
+			break;
+		default:
+			return;
+		}
+
+		val = readl(priv->plu_base + MLXBF_GIGE_PLU_TX_REG0);
+		val &= ~(MLXBF_GIGE_PLU_TX_IPG_SIZE_MASK | MLXBF_GIGE_PLU_TX_SGMII_MODE_MASK);
+		val |= FIELD_PREP(MLXBF_GIGE_PLU_TX_IPG_SIZE_MASK, ipg_size);
+		val |= FIELD_PREP(MLXBF_GIGE_PLU_TX_SGMII_MODE_MASK, sgmii_mode);
+		writel(val, priv->plu_base + MLXBF_GIGE_PLU_TX_REG0);
+
+		val = readl(priv->plu_base + MLXBF_GIGE_PLU_RX_REG0);
+		val &= ~MLXBF_GIGE_PLU_RX_SGMII_MODE_MASK;
+		val |= FIELD_PREP(MLXBF_GIGE_PLU_RX_SGMII_MODE_MASK, sgmii_mode);
+		writel(val, priv->plu_base + MLXBF_GIGE_PLU_RX_REG0);
+
+		priv->prev_speed = phydev->speed;
+	}
+
+	phy_print_status(phydev);
+}
+
+static void mlxbf_gige_bf2_set_phy_link_mode(struct phy_device *phydev)
+{
+	/* MAC only supports 1000T full duplex mode */
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+
+	/* Only symmetric pause with flow control enabled is supported so no
+	 * need to negotiate pause.
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising);
+}
+
+static void mlxbf_gige_bf3_set_phy_link_mode(struct phy_device *phydev)
+{
+	/* MAC only supports full duplex mode */
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+
+	/* Only symmetric pause with flow control enabled is supported so no
+	 * need to negotiate pause.
+	 */
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising);
+}
+
+static struct mlxbf_gige_link_cfg mlxbf_gige_link_cfgs[] = {
+	[MLXBF_GIGE_VERSION_BF2] = {
+		.set_phy_link_mode = mlxbf_gige_bf2_set_phy_link_mode,
+		.adjust_link = mlxbf_gige_bf2_adjust_link,
+		.phy_mode = PHY_INTERFACE_MODE_GMII
+	},
+	[MLXBF_GIGE_VERSION_BF3] = {
+		.set_phy_link_mode = mlxbf_gige_bf3_set_phy_link_mode,
+		.adjust_link = mlxbf_gige_bf3_adjust_link,
+		.phy_mode = PHY_INTERFACE_MODE_SGMII
+	}
+};
+
 static int mlxbf_gige_probe(struct platform_device *pdev)
 {
 	struct phy_device *phydev;
@@ -359,25 +445,14 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	phydev->irq = phy_irq;
 
 	err = phy_connect_direct(netdev, phydev,
-				 mlxbf_gige_adjust_link,
-				 PHY_INTERFACE_MODE_GMII);
+				 mlxbf_gige_link_cfgs[priv->hw_version].adjust_link,
+				 mlxbf_gige_link_cfgs[priv->hw_version].phy_mode);
 	if (err) {
 		dev_err(&pdev->dev, "Could not attach to PHY\n");
 		goto out;
 	}
 
-	/* MAC only supports 1000T full duplex mode */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-
-	/* Only symmetric pause with flow control enabled is supported so no
-	 * need to negotiate pause.
-	 */
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising);
+	mlxbf_gige_link_cfgs[priv->hw_version].set_phy_link_mode(phydev);
 
 	/* Display information about attached PHY device */
 	phy_attached_info(phydev);
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index 8d52dbef4adf..cd0973229c9b 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -8,6 +8,8 @@
 #ifndef __MLXBF_GIGE_REGS_H__
 #define __MLXBF_GIGE_REGS_H__
 
+#include <linux/bitfield.h>
+
 #define MLXBF_GIGE_VERSION                            0x0000
 #define MLXBF_GIGE_VERSION_BF2                        0x0
 #define MLXBF_GIGE_VERSION_BF3                        0x1
@@ -78,4 +80,23 @@
  */
 #define MLXBF_GIGE_MMIO_REG_SZ                        (MLXBF_GIGE_MAC_CFG + 8)
 
+#define MLXBF_GIGE_PLU_TX_REG0                        0x80
+#define MLXBF_GIGE_PLU_TX_IPG_SIZE_MASK               GENMASK(11, 0)
+#define MLXBF_GIGE_PLU_TX_SGMII_MODE_MASK             GENMASK(15, 14)
+
+#define MLXBF_GIGE_PLU_RX_REG0                        0x10
+#define MLXBF_GIGE_PLU_RX_SGMII_MODE_MASK             GENMASK(25, 24)
+
+#define MLXBF_GIGE_1G_SGMII_MODE                      0x0
+#define MLXBF_GIGE_10M_SGMII_MODE                     0x1
+#define MLXBF_GIGE_100M_SGMII_MODE                    0x2
+
+/* ipg_size default value for 1G is fixed by HW to 11 + End = 12.
+ * So for 100M it is 12 * 10 - 1 = 119
+ * For 10M, it is 12 * 100 - 1 = 1199
+ */
+#define MLXBF_GIGE_1G_IPG_SIZE                        11
+#define MLXBF_GIGE_100M_IPG_SIZE                      119
+#define MLXBF_GIGE_10M_IPG_SIZE                       1199
+
 #endif /* !defined(__MLXBF_GIGE_REGS_H__) */
-- 
2.30.1

