Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A12668477
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbjALUxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbjALUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:52:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A9A11165
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:26:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgAshxNr8reX2XyE6rUAQ+PcfITiQvc+lvCQf9GdVKYGu6iPuCsSxrworfRFWd24xm5DPIy6vU0gf7JtkxTNHVabA1PE1Qi28blq2jbP/EyZvGt8BuVXtd+J25m7x9v0gJs5fIc/GtXNhCzAoBSQ9XnfUCAcYv9w1rZPjpvUtuV5PcWGCLQA8+o4hUZHrgcm+qM29Nrusp2wzxaolNRtcXj7zjMBE1/+9fQpSJ7G3cdnrI3laX5c5ePGsLb/YBdRfOJOstpfGR63Sz1NlVPTOI9dVG88IlKlfynQblwVE30bVsBgawsbgBXf5EhwM3x6D73wt0up0D9V0NpR99huaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgUpjAgjn4B5C0AFBDEHNeQkrRwTndCwDaieY7Y/+E0=;
 b=QYzfzaJZcrma3Bh6fqy81NEfIy8xBbNmG3ve5kkZI0ejcEClfVbl0IhzLokb2OXhiWpspxTqsG1sZZxNpzm0Y/v5OsoD5WVouvd3OTc8MEAQNtEgRAfZxr4D2u2J2lcHC3LjE10sjl6OLILsu8ADCOLOFN9R2UwoEqmgqngBhHoRMBAsiNTqSCelvCXFUYnyfmwON4hcbFcZDDSm2+AUaU8H/a/U+DjNIC2O/sEUGpvgYhTRQKtRr6prW/rx338c5be8cYEo9kcgFuBVeETnMlrj0yaYcAJYl926ymSxk+o25ItlxWwUTU/TSbupOqZldIThT1x2DaWzh17Varw9TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgUpjAgjn4B5C0AFBDEHNeQkrRwTndCwDaieY7Y/+E0=;
 b=fdYiNqB4EvPlA+wAFXhPnJJKqP1Y7ny4ChHL+lXbO202xAHdCPDb4wgUPPAgx3OMzQK355qxyCiJznwk47HpgLz9cJI/PS3uEHwoDA6y7lY40a8R9aBH7PbuQKCUK1RLqR/zRtUFzhWD3N5wrAWIi0c64RP1lQEE+FDXb3u+zn+vxhj0DQ8Ixvpl5PvFw+EjUEJXJPgIU5aGp0sDWkG2TQsipuplm2H9hHcIPiiQb8ov2NwUqLlsef+5H27QDXlngdsx0eucr50LqtTiBvxF4rA8GrvBguxP2i8/dXJnDuTTgUkhcuTivVb6VhrpzTXcaU3At4ptKii90OBsvnLMNA==
Received: from BN9P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::15)
 by DM6PR12MB4332.namprd12.prod.outlook.com (2603:10b6:5:21e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 20:26:34 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::2e) by BN9P221CA0021.outlook.office365.com
 (2603:10b6:408:10a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 20:26:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 20:26:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 12:26:25 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 12 Jan 2023 12:26:25 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 12 Jan 2023 12:26:23 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v3 2/4] mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
Date:   Thu, 12 Jan 2023 15:26:07 -0500
Message-ID: <20230112202609.21331-3-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112202609.21331-1-davthompson@nvidia.com>
References: <20230112202609.21331-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT031:EE_|DM6PR12MB4332:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b22508-264e-46ef-abe9-08daf4db4c52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Okm/b4BR4kKhms14H7PmZRSt18jaR5MgbgeSliWA7OX5xO50lsaS8IIhEuWwwXZCMZgUF8/y6zaZBypzAKS1YP7hCb5USuM4BOjEHKmirLLPhU3zF7suY7yBZhbQCzbR3/eal7o2NisHLay1l8MJF3S+EkSaVh72QOUmTdQfvc7Mdk7uoiQJjr/tEqefcI9QJ/D6abBfqZCB4cmYnu4WKNOoEhGA3MLNAwPY/OmVIHXzWhE+Z/I6QxTYBHYABadcfRHoeHvg7hD1Je6PYiFMd01d4qFd4Bykvem83gTMSMiOJSPvm2Dqd95m3gQWEaszoxNZY24gljI+JOpQclEjfU/VLA2EocLla46jj1eEtKh7kNw/KnFARSzzj6nYRDSArL/dcFbZRIlbRSmqeja5iwMoIGxCgc04+NxmVw2v7U+knbgcWzOUFnxzSHCb4AjXLIIjf0gOmD+u+tV0/NUHj80jw2gM8Q1Y6PgrwStGt6jM0kSUFUqkNlN8eJy1y3z5TA92qlPtJvdjJLYkYaEgCGN8A+FPBSYE6SksbKtphcp9aterPPbzaUGke5KTR7pqkMvIlVs7dGhfn3w/pp98UXXkUsLxT6XFfm2rIJmxRz2x5XH4IqzU2cn4XL+dwj41VM0W9/BW21GxWILgbgQNiuAFak651jWx/UBwa/feNFjxnnvNqAmwSTNT4w2/pP3aI7OoZi53Y+xC/cjiZ//2bw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(426003)(478600001)(82740400003)(7636003)(41300700001)(356005)(47076005)(1076003)(86362001)(316002)(54906003)(110136005)(2616005)(40460700003)(336012)(70586007)(40480700001)(26005)(186003)(7696005)(82310400005)(4326008)(36756003)(70206006)(5660300002)(107886003)(36860700001)(2906002)(6666004)(83380400001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 20:26:33.9973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b22508-264e-46ef-abe9-08daf4db4c52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4332
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

