Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2776E6C91
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjDRTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjDRTCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:02:07 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9529EC64B
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 12:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMb/Be1weMl9c0CVqt7/+/Bq3vTvSWdJ7wKe1pF4jcV8K7PZT3vpyeItTiPhaXf1gDNVudKwYWkyBUNZMLRIrjpKK/MKWdPDP0XNzENCzUI4+EW6sM9UZT7qRTiFgfG+zc4rso5QdwnrcYfRLHRTH41GU2RCqdbB3c1Qo/AHoCEOEuAKOxWtd89HadgyJm0UWQUiBDnbwmDIfAZDEJSkI96cqhE7qXNB75PzlIyzGQV0jJpJeOjGf8itXyfUO9i/cn8Guz9qSeJtB/SOaCZY175ZZWistTpqt72LZ9WiIUynpb3pd3o4gyB7HG2rIVtSRNm2eg85H1gn0S/vAE8YZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3UcGgePMuHsLH2+4PTjcqCKCn+PXDezZZDjCHMbNXA=;
 b=ZeZiX6tSgFjFrPVw1KEcizDrjA2pIAwXfgPvr6hHkoN3Ke7qCkO2wkbFMu5wwTd0U1Q+LVDgCDaHMfMwsQq12dGEsr1eCYtiL1mbEH6rkVHdMXZzryUaHzrcTefrtB8v0Z5y8hJrvrQCireMmcY1rNg2vHLPHs0TQLHOj9EIy87j5KG37CA/BCrT/FCOOYJdWNQtKe32XPwXfi8Uwz0drueiJEbOSTX9CiLPBM2Clxd1DYHl7KWnCAn3O8iBMPwZXdiMx3EzbVEhkVw4ZxrAAgHrmMGLj1Rwp+dVFrJbOldt1LZnMD6jpsfqr9EtD5nL02Fdupx1YzSxmZ0nYtPe2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3UcGgePMuHsLH2+4PTjcqCKCn+PXDezZZDjCHMbNXA=;
 b=Pex9NxKHog48SnTGLvX6YbuSECKYq3hJ2C5mSKqtX1V6uji3jMKzdPO5dSkhquDM5/Lc0ezyioCVgrZrFHe/F/YsoB0jQNmtUKRGuyM59/6/v/7Oxi6DO62lw7G2549QEQ7Pu1AndiOsV3zcA9EdBCxhKHiPMXYcQj3H2Xp56S0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9075.eurprd04.prod.outlook.com (2603:10a6:102:229::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 19:01:55 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 19:01:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 net-next] net: phy: add basic driver for NXP CBTX PHY
Date:   Tue, 18 Apr 2023 22:01:41 +0300
Message-Id: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0010.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9075:EE_
X-MS-Office365-Filtering-Correlation-Id: 906599e4-9549-46bd-d7f0-08db403f60cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RBSYFR/0mGP9Nl4cBrmBqf3unvxGynNR59uaBXpEsM4pBHc9hUvH7y2L5IDbuJFTXFYF+t1NWCOX0XV3xaxA1/6BeESINAtTy3cm/YhxFuCMZQY+4gR8wa0A8rmS/eqmx2PE9hM4EcRtUl1fGgWGYv+GaSF9tPQaeeGgC7QWriSHn+ntc68aDtaekm61LsCa9o29DKs3D7AVA+0QUgWRsmHWJfTivKOeg8es1ayCG7iZukqXzCf3uUzvz3ciKUIp7AeQ9s+vfcC6bjGljDCB5H9MXwqKqHH9DGDc2j6/34Ugmxe+9Qy1W6Zs+q1pbWgp2FEEXmL2LsU2cmnyztPikAomdrb+XwA6j4/c1422n+6brHPfEGRvbl3WcB7fsf4XZzE9hLhcQJ6G9DjqYsi31uOzr6BSjC68AkUyeV8r0MO3MNcL0fHl0DP9rfUR/DrF797V5jAzZG2bveb/72MGqJ7ccW/s6+ii8R2+HFJ6awQma5LoFTgYO2ZXifcjMlzjGiEK6PGxddx3pC/zqXdmdlWyBn/f15mEGNftiSw6y6jj1OsIyKwf2bUlwNy8HGdN+aoj2x2cIkFAaOoPbsqJNMdv4KjaMEYRvRHHI89ZGjbkzLe0K0eymFFq8KXWXi7Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(36756003)(38100700002)(6916009)(38350700002)(5660300002)(44832011)(2906002)(8936002)(66946007)(86362001)(4326008)(66556008)(66476007)(41300700001)(8676002)(6486002)(83380400001)(186003)(6512007)(6666004)(6506007)(316002)(26005)(1076003)(54906003)(52116002)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eUKPjAmxodG//oFRyR+V5XcyilhCpGFsI6Oz48VhORe1fcigyd9vi/CUYPmn?=
 =?us-ascii?Q?TbgJvvf/g9huttoUXMnexzCiJWez28dtSbfs4J3OZI3Jcm4dXAnGEtaHDYZG?=
 =?us-ascii?Q?PdsQ+zdpzhW3Edkd4B9DD9uCIYVpjbbJRHm7CTTvaXtd2hvHjACj5II3ss+/?=
 =?us-ascii?Q?AepGNdEsvb1W+cb/A0Ik0kls879dTp7UTZAPsESQOFrh6n/9G+8Uljm7SOyT?=
 =?us-ascii?Q?NGC/mmF2jzeZP64Smka2MoNNMjSeg+BVYQjbq0XMhuSWAXn+2+j1LEJ8UufL?=
 =?us-ascii?Q?CNmrvEIPYeZs03Dy8G7KuJQ+86x1QRE+uWIt7huPWcQRkHVR5xaYKwjn5yoW?=
 =?us-ascii?Q?ju4is7/TzEgJoDkmtYjhFF6CXRnGNTvepVJijt2RZsBuNdxlDenpAmQDduOf?=
 =?us-ascii?Q?sERVu7xUbiYfP3r+GSN7CU+4KAb6wNemJ8RvIyER1k1uShQpAv3Rq3MFwYnG?=
 =?us-ascii?Q?3aLl7dE15xugECG/CrVFRuJANlzJK623+9ffK6qN7ezEHIeEbtEQKrcL2TRp?=
 =?us-ascii?Q?Myox5junNo9sn7WKOMWDLxtvlFRqdm31Hd8OQ/X7wDJcU43eIqdnTVjTvpc5?=
 =?us-ascii?Q?5uA+TEKilbEuC8AbAe2747NBD8jU/pX0vF1ERQeBnpT4OC2IjmwfIx5ePl0f?=
 =?us-ascii?Q?z6YBsLN3sZ4tuTgl3OnS1ZDgKiksl9Xcfei46Qj//fgLe5CnMo6nRMLoxIJY?=
 =?us-ascii?Q?Opy93iQ+cl0Iyy7etlRwZCipNTd0qP2C+9jKSPpJjfMx1ygNHg1d2Wwp0hd3?=
 =?us-ascii?Q?TAMWCBbukvtwY+W/8Tc+AB5EIe7xECEoGLDt5JkfM7ZwoK6YCoqee73l3R0Q?=
 =?us-ascii?Q?ZdT2KkB1uR8cc+snVx6IbWp6adML26f6WbZcX+Dq4Q0yQAhvIociVZSIAU2A?=
 =?us-ascii?Q?b8gRW/XUK2Yt/KahjkdNpPUCGF9bZjTpnDEbpcP+hvCogJq82htBA7g9yGZt?=
 =?us-ascii?Q?yNZ9QVOT8v1QU2NZUg2C4R1eLEsRqplvFYhLCuCk/T1Wk6cJOwZ6BbgWP6SF?=
 =?us-ascii?Q?Mocphe0OT7Mwq1amv7MD2J1mi7PM53rMCWO66nlXLdi99KVP+j+4qWeLAlOl?=
 =?us-ascii?Q?uuZYL8/UfNJPT9VMjqGNn0ySc68A04kdmWu9memP88sH9zgcH6Ff8IW7xJfA?=
 =?us-ascii?Q?rPcSLIUHulleVXSxpERhSjOAU1JMQgUG8YndOS4WdWTiMk3zxcqe/tY9aZu1?=
 =?us-ascii?Q?7r+YMhHUF1WD0CYmVcQdsJ3Jq2Sq7jJDwN02f6HXnfNS/LyCfGHA98W22IIH?=
 =?us-ascii?Q?WSXyGXYfPZagx7wV2x9hQFkQFZOrODHl/dmz6UFpejDfJtxlGdAzmO4VyUSW?=
 =?us-ascii?Q?nvQRqTfiveCgyIU8a2QBNaRfh8bJyCXiR141LAc/dBfEZuW9hIpb2Ok4BDZk?=
 =?us-ascii?Q?XuehEQG9aE9ORRZbvXO+lxsd76kTdW6GbX+oQ3v5kNoVZvfMQyPalDr4P96X?=
 =?us-ascii?Q?G088FGpDWg+dVnWkqWoe9PYtEN/76JFmL8OrCysg9lmF9oaYoi8Jvl4URDkr?=
 =?us-ascii?Q?Pyj+JLds5O7zluWSh4iuVmyrsHPFYUog4veU4zwQqd0xjyXCQHs1c19Srqec?=
 =?us-ascii?Q?pmrs+01ypdG1Jyqowmngnb0sn1YhjLoKUHxYcnnvr+gM/QSre2BEYFbpGBor?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906599e4-9549-46bd-d7f0-08db403f60cf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 19:01:55.6284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EY0q7xRpweg8M77Z2lDcJtvYJL33pDrmzfEyE98ObJMr/+ZDkU0pGW5Neu5Djf7VgPJqt42i+X2y3HG2/glYSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CBTX PHY is a Fast Ethernet PHY integrated into the SJA1110 A/B/C
automotive Ethernet switches.

It was hoped it would work with the Generic PHY driver, but alas, it
doesn't. The most important reason why is that the PHY is powered down
by default, and it needs a vendor register to power it on.

It has a linear memory map that is accessed over SPI by the SJA1110
switch driver, which exposes a fake MDIO controller. It has the
following (and only the following) standard clause 22 registers:

0x0: MII_BMCR
0x1: MII_BMSR
0x2: MII_PHYSID1
0x3: MII_PHYSID2
0x4: MII_ADVERTISE
0x5: MII_LPA
0x6: MII_EXPANSION
0x7: the missing MII_NPAGE for Next Page Transmit Register

Every other register is vendor-defined.

The register map expands the standard clause 22 5-bit address space of
0x20 registers, however the driver does not need to access the extra
registers for now (and hopefully never). If it ever needs to do that, it
is possible to implement a fake (software) page switching mechanism
between the PHY driver and the SJA1110 MDIO controller driver.

Also, Auto-MDIX is turned off by default in hardware, the driver turns
it on by default and reports the current status. I've tested this with a
VSC8514 link partner and a crossover cable, by forcing the mode on the
link partner, and seeing that the CBTX PHY always sees the reverse of
the mode forced on the VSC8514 (and that traffic works). The link
doesn't come up (as expected) if MDI modes are forced on both ends in
the same way (with the cross-over cable, that is).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- use standard genphy_suspend() and genphy_resume() - I really don't
  know what the True Power Down mode does better
- fix forced mode (autoneg off) link status not coming up with interrupts

 drivers/net/phy/Kconfig    |   6 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/nxp-cbtx.c | 227 +++++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+)
 create mode 100644 drivers/net/phy/nxp-cbtx.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 6b9525def973..eae6fc697ba3 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -265,6 +265,12 @@ config NATIONAL_PHY
 	help
 	  Currently supports the DP83865 PHY.
 
+config NXP_CBTX_PHY
+	tristate "NXP 100BASE-TX PHYs"
+	help
+	  Support the 100BASE-TX PHY integrated on the SJA1110 automotive
+	  switch family.
+
 config NXP_C45_TJA11XX_PHY
 	tristate "NXP C45 TJA11XX PHYs"
 	depends on PTP_1588_CLOCK_OPTIONAL
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b5138066ba04..ae11bf20b46e 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
 obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
+obj-$(CONFIG_NXP_CBTX_PHY)	+= nxp-cbtx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
diff --git a/drivers/net/phy/nxp-cbtx.c b/drivers/net/phy/nxp-cbtx.c
new file mode 100644
index 000000000000..145703f0a406
--- /dev/null
+++ b/drivers/net/phy/nxp-cbtx.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for 100BASE-TX PHY embedded into NXP SJA1110 switch
+ *
+ * Copyright 2022-2023 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define PHY_ID_CBTX_SJA1110			0x001bb020
+
+/* Registers */
+#define  CBTX_MODE_CTRL_STAT			0x11
+#define  CBTX_PDOWN_CTRL			0x18
+#define  CBTX_RX_ERR_COUNTER			0x1a
+#define  CBTX_IRQ_STAT				0x1d
+#define  CBTX_IRQ_ENABLE			0x1e
+
+/* Fields */
+#define CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN	BIT(7)
+#define CBTX_MODE_CTRL_STAT_MDIX_MODE		BIT(6)
+
+#define CBTX_PDOWN_CTL_TRUE_PDOWN		BIT(0)
+
+#define CBTX_IRQ_ENERGYON			BIT(7)
+#define CBTX_IRQ_AN_COMPLETE			BIT(6)
+#define CBTX_IRQ_REM_FAULT			BIT(5)
+#define CBTX_IRQ_LINK_DOWN			BIT(4)
+#define CBTX_IRQ_AN_LP_ACK			BIT(3)
+#define CBTX_IRQ_PARALLEL_DETECT_FAULT		BIT(2)
+#define CBTX_IRQ_AN_PAGE_RECV			BIT(1)
+
+static int cbtx_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Can't soft reset unless we remove PHY from true power down mode */
+	ret = phy_clear_bits(phydev, CBTX_PDOWN_CTRL,
+			     CBTX_PDOWN_CTL_TRUE_PDOWN);
+	if (ret)
+		return ret;
+
+	return genphy_soft_reset(phydev);
+}
+
+static int cbtx_config_init(struct phy_device *phydev)
+{
+	/* Wait for cbtx_config_aneg() to kick in and apply this */
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
+	return 0;
+}
+
+static int cbtx_mdix_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, CBTX_MODE_CTRL_STAT);
+	if (ret < 0)
+		return ret;
+
+	if (ret & CBTX_MODE_CTRL_STAT_MDIX_MODE)
+		phydev->mdix = ETH_TP_MDI_X;
+	else
+		phydev->mdix = ETH_TP_MDI;
+
+	return 0;
+}
+
+static int cbtx_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = cbtx_mdix_status(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_read_status(phydev);
+}
+
+static int cbtx_mdix_config(struct phy_device *phydev)
+{
+	int ret;
+
+	switch (phydev->mdix_ctrl) {
+	case ETH_TP_MDI_AUTO:
+		return phy_set_bits(phydev, CBTX_MODE_CTRL_STAT,
+				    CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN);
+	case ETH_TP_MDI:
+		ret = phy_clear_bits(phydev, CBTX_MODE_CTRL_STAT,
+				     CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN);
+		if (ret)
+			return ret;
+
+		return phy_clear_bits(phydev, CBTX_MODE_CTRL_STAT,
+				      CBTX_MODE_CTRL_STAT_MDIX_MODE);
+	case ETH_TP_MDI_X:
+		ret = phy_clear_bits(phydev, CBTX_MODE_CTRL_STAT,
+				     CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN);
+		if (ret)
+			return ret;
+
+		return phy_set_bits(phydev, CBTX_MODE_CTRL_STAT,
+				    CBTX_MODE_CTRL_STAT_MDIX_MODE);
+	}
+
+	return 0;
+}
+
+static int cbtx_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = cbtx_mdix_config(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_config_aneg(phydev);
+}
+
+static int cbtx_ack_interrupts(struct phy_device *phydev)
+{
+	return phy_read(phydev, CBTX_IRQ_STAT);
+}
+
+static int cbtx_config_intr(struct phy_device *phydev)
+{
+	int ret;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		ret = cbtx_ack_interrupts(phydev);
+		if (ret < 0)
+			return ret;
+
+		ret = phy_write(phydev, CBTX_IRQ_ENABLE, CBTX_IRQ_LINK_DOWN |
+				CBTX_IRQ_AN_COMPLETE | CBTX_IRQ_ENERGYON);
+		if (ret)
+			return ret;
+	} else {
+		ret = phy_write(phydev, CBTX_IRQ_ENABLE, 0);
+		if (ret)
+			return ret;
+
+		ret = cbtx_ack_interrupts(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static irqreturn_t cbtx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_stat, irq_enabled;
+
+	irq_stat = cbtx_ack_interrupts(phydev);
+	if (irq_stat < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_enabled = phy_read(phydev, CBTX_IRQ_ENABLE);
+	if (irq_enabled < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_enabled & irq_stat))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static int cbtx_get_sset_count(struct phy_device *phydev)
+{
+	return 1;
+}
+
+static void cbtx_get_strings(struct phy_device *phydev, u8 *data)
+{
+	strncpy(data, "100btx_rx_err", ETH_GSTRING_LEN);
+}
+
+static void cbtx_get_stats(struct phy_device *phydev,
+			   struct ethtool_stats *stats, u64 *data)
+{
+	int ret;
+
+	ret = phy_read(phydev, CBTX_RX_ERR_COUNTER);
+	data[0] = (ret < 0) ? U64_MAX : ret;
+}
+
+static struct phy_driver cbtx_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_CBTX_SJA1110),
+		.name			= "NXP CBTX (SJA1110)",
+		/* PHY_BASIC_FEATURES */
+		.soft_reset		= cbtx_soft_reset,
+		.config_init		= cbtx_config_init,
+		.suspend		= genphy_suspend,
+		.resume			= genphy_resume,
+		.config_intr		= cbtx_config_intr,
+		.handle_interrupt	= cbtx_handle_interrupt,
+		.read_status		= cbtx_read_status,
+		.config_aneg		= cbtx_config_aneg,
+		.get_sset_count		= cbtx_get_sset_count,
+		.get_strings		= cbtx_get_strings,
+		.get_stats		= cbtx_get_stats,
+	},
+};
+
+module_phy_driver(cbtx_driver);
+
+static struct mdio_device_id __maybe_unused cbtx_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_CBTX_SJA1110) },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(mdio, cbtx_tbl);
+
+MODULE_AUTHOR("Vladimir Oltean <vladimir.oltean@nxp.com>");
+MODULE_DESCRIPTION("NXP CBTX PHY driver");
+MODULE_LICENSE("GPL");
-- 
2.34.1

