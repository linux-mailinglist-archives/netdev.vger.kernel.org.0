Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52676EF273
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbjDZKoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240545AbjDZKnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:43:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEB54206;
        Wed, 26 Apr 2023 03:43:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzikHipTjmcq98vngdbxrRIE09I10/WLCnJCyIq0WCEN0LdY1AbkMNqZdlyshpIAcbz+rnViinP/KtLMWhn7FQ6PfqCaV4HZYj2Pv8wl1INvt51ZhlDZ6spB9PAMfE/NRtOTvJNWkMK4NiLe+CB4RV2WoxlwIqIY3UfVNngyqo5vwq/5tm9eusdXvCm/MIKj8+FRgaTtK7ZPS9So88FTDiCagGe2g5NT6Ex4Lw5Rtawa3jdYHxm9g1MU7APKCMmH9lag+bO9MSFtL4X2FZyDHwk+70tBQ0u1TLrna5c4btuJjgkloseq4r+Ue2gDy7D7zTmHZthjxvSOlmY1AGcwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyuNeOLwppd5nT2AJUzdSQ3CApNXJ/zLRwIoTahw6eM=;
 b=lb8t6vp6D5NGisHilvgzvFaCUAcGuKhsPRmlId0fcoBZiRbt4ikWmVIsVAZt7svmwH6D8UygegiYPbh7OhNznJ3uXcj95pGiTKJQBkCgiM5mdBg7Zh4vGLxg3jrk49y4gsZ9lcEmM7RxYNldgipzCFE5XJ7IzuhVnzwO8HtU3VKndKVWQh3Sh7CRNhNaJJty982ZgkE7J/Gab/Z3RXh9YizeNX1zDDzEvSsB5z7wFLBE9VpdlkgRKy9xe1E7IM64sh2hxR6mFAJnkNPRyoyoxjkE4fOmFbRnrvUPzbEXCu1t2I+3KJ/sk9Rc/vlJVw72/+j6XE2RiONebUHAl3V77Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyuNeOLwppd5nT2AJUzdSQ3CApNXJ/zLRwIoTahw6eM=;
 b=ljPmumThE9guTo59oBbDk/4cmUev7aY2iZB1qEAumct/ytpiaQsY9NaBsAM/n9tL3xfYRSK5JoYzQj43UStThk1Vt7QgLse/UiSlQDwFQFQReaU7RnRKRubL435Jx619qg+YWE1ipLe1zbXT2Y+fGuiDI0Nz+UtzGpZbuV7TZb8=
Received: from MW3PR05CA0007.namprd05.prod.outlook.com (2603:10b6:303:2b::12)
 by MN2PR12MB4207.namprd12.prod.outlook.com (2603:10b6:208:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 10:43:35 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::69) by MW3PR05CA0007.outlook.office365.com
 (2603:10b6:303:2b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.5 via Frontend
 Transport; Wed, 26 Apr 2023 10:43:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.22 via Frontend Transport; Wed, 26 Apr 2023 10:43:35 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 05:43:34 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 05:43:34 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 26 Apr 2023 05:43:29 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>, <wsa+renesas@sang-engineering.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
        <michal.simek@amd.com>, <harini.katakam@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02 with RGMII tuning
Date:   Wed, 26 Apr 2023 16:13:13 +0530
Message-ID: <20230426104313.28950-4-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426104313.28950-1-harini.katakam@amd.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|MN2PR12MB4207:EE_
X-MS-Office365-Filtering-Correlation-Id: 392f4ec5-f7c0-4799-dc3e-08db46431630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZGRPs2GhVZmY3XbY+1QYoO7xusvkkp3I9nXWXt96gtcJCyOExcMSm1LBMnAjXvMm0RU2K4pxukDrIE6vm7MRk7eIHrWlkaNGKhXz3WbBImju/+kC1NteF8jHcu8goinyvDnpN8+8E9HFVrs6BT1q2bUQPn2OnBOmjHMvmb1YSaVLgjpksGc+IyMm0SiCKyojsKyKDBFCnluhaoj6nQJkPS/LHLpR4vdk/pKLUmCspitJGBorQxc4h0VZl4CiDRBkrhdcdOqAITWa/XPPmNhZCfluBIZ2Cn5LEONC1upWtcHIKu0JdHQG3PONIlO5gZpZ3miDS7fBeIWxDIHJDqMXhJrh5kWw6h67b39QRF0qukq9pzX+8bg/wBxlw9pt0eEJzVObH4LYaqQqvIeXEdgBlmFjTmemgCXCKuTYBDBffT7SQISLo/3rxTnF4k3f31JkWRFGLmhle9yhUYplPzS1wrD0GoF/Uo0Zy2pg3Bg6H0DBBOshnDyOWoaDfzG8sxQWN14b38ot2lNPuDPT3uXe6t0ReX2hhbgB2NcLa+BNjKQNkHUWhFkdq13J1v7sotVyXk+mgIdsbSacMQZJAX3x4zzkt8NOr1QNJqbcGJMuTp6pa7iFMMIpWmkUaZZXxt1U0K7kGBzdLjshpG+io7n1W1FN5KxLBHchSD/lfCDNDugoKIHAzuL30kkqAsFDyuEIdrZhs1B2Vrac68YKnFjFy+EGtmXGE3AvXXR4TXblqkuyQocUJ+L25LGLtOICxv1y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(82310400005)(36756003)(86362001)(40480700001)(40460700003)(54906003)(478600001)(6666004)(110136005)(8936002)(356005)(8676002)(81166007)(921005)(41300700001)(70586007)(70206006)(316002)(82740400003)(2616005)(4326008)(36860700001)(83380400001)(47076005)(186003)(336012)(426003)(26005)(1076003)(2906002)(7416002)(44832011)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:43:35.0548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 392f4ec5-f7c0-4799-dc3e-08db46431630
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4207
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

Add support for VSC8531_02 (Rev 2) device.
Add support for optional RGMII RX and TX delay tuning via devicetree.
The hierarchy is:
- Retain the defaul 0.2ns delay when RGMII tuning is not set.
- Retain the default 2ns delay when RGMII tuning is set and DT delay
property is NOT specified.
- Use the DT delay value when RGMII tuning is set and a DT delay
property is specified.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
v2:
- Switch both VSC8531 and VSC8531-02 to use exact phy id match as they
share the same model number
- Ensure RCT
- Improve optional property read

 drivers/net/phy/mscc/mscc.h      |  3 +++
 drivers/net/phy/mscc/mscc_main.c | 40 ++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..5a26eba0ace0 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -281,6 +281,7 @@ enum rgmii_clock_delay {
 #define PHY_ID_VSC8514			  0x00070670
 #define PHY_ID_VSC8530			  0x00070560
 #define PHY_ID_VSC8531			  0x00070570
+#define PHY_ID_VSC8531_02		  0x00070572
 #define PHY_ID_VSC8540			  0x00070760
 #define PHY_ID_VSC8541			  0x00070770
 #define PHY_ID_VSC8552			  0x000704e0
@@ -373,6 +374,8 @@ struct vsc8531_private {
 	 * package.
 	 */
 	unsigned int base_addr;
+	u32 rx_delay;
+	u32 tx_delay;
 
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec fields:
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 75d9582e5784..80cc90a23d57 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -525,6 +525,7 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
 {
 	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
 	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
+	struct vsc8531_private *vsc8531 = phydev->priv;
 	u16 reg_val = 0;
 	int rc;
 
@@ -532,10 +533,10 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
 
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
+		reg_val |= vsc8531->rx_delay << rgmii_rx_delay_pos;
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
+		reg_val |= vsc8531->tx_delay << rgmii_tx_delay_pos;
 
 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
 			      rgmii_cntl,
@@ -1812,6 +1813,15 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 {
 	int rc, i, phy_id;
 	struct vsc8531_private *vsc8531 = phydev->priv;
+	struct device_node *of_node = phydev->mdio.dev.of_node;
+
+	vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
+	rc = of_property_read_u32(of_node, "mscc,rx-delay",
+				  &vsc8531->rx_delay);
+
+	vsc8531->tx_delay = RGMII_CLK_DELAY_2_0_NS;
+	rc = of_property_read_u32(of_node, "mscc,tx-delay",
+				  &vsc8531->tx_delay);
 
 	rc = vsc85xx_default_config(phydev);
 	if (rc)
@@ -2413,9 +2423,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
-	.phy_id		= PHY_ID_VSC8531,
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8531),
 	.name		= "Microsemi VSC8531",
-	.phy_id_mask    = 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc85xx_config_init,
@@ -2436,6 +2445,29 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
 },
+{
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8531_02),
+	.name		= "Microsemi VSC8531-02",
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init	= &vsc85xx_config_init,
+	.config_aneg	= &vsc85xx_config_aneg,
+	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt	= vsc85xx_handle_interrupt,
+	.config_intr	= &vsc85xx_config_intr,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc85xx_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings	= &vsc85xx_get_strings,
+	.get_stats	= &vsc85xx_get_stats,
+},
 {
 	.phy_id		= PHY_ID_VSC8540,
 	.name		= "Microsemi FE VSC8540 SyncE",
-- 
2.17.1

