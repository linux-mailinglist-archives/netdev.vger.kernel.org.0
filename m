Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23236DE01F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjDKP5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjDKP5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:57:25 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2047.outbound.protection.outlook.com [40.107.13.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66985E76
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:57:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUKnylMUHTYdRfU4X8fc3N4st6tFE88Pr00ZG2kVqfcIN4BaIsOWyZItBy4e34UZAwHDo9Zx/rdLW4bOoGgwnHnszd1W2G6imUB4SODepm2OKf7Dlk7gewwj2Ztc4VGV7N1Zj5nnxZEHevv72LhgZJlQPLSsde7NmyLpx6fbfQM95iOa8U7Aeweay2zM8tY86BlBeLYBXgPLu0NQdB08FQ+PXwfyNq1UA7Pt59wrKhSjn38dvZ72hINz2vbTFyF3GO4uet/MjLBfri06nwHiYDt4eEM9jqu33itjAfbLa5Fl2OASvAvPIV8X48LX+MFKdTMi5rkdnTh/j+0eUNeHMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMW+1VhxYppkwpJooa9RBTPXJdO1aw+ZZMjkWmb4Zk4=;
 b=fKaa2sxvEBgtOq392lnnw207bpgw/Zg4nO/avy1tdwlClJJUJua2PnnMEmE/iu+Ujrj0PZJeNYQ+SIMB27P7hTlfVOFRkO/p/kFKfYvJls64MegtW08TL8Sjo7AOhrAitObfFQnGA1yr4sSjTs5UwcYMVqLU/HmGqhDtOURpjZQBcDh9xewWdIKr9E+1c3e4zKfhITokKW6IaiQNVTh2ahTtgABT10HjLMlRcuTJoWo8525o6UUWVm0TWYwUwSNyjiHZB1dnZI8i/aIviNaPoY1VHoOHUBbeorUaOVWPT+/F0S9ytXLhFTnpkSyBMO097foF1eSEfRSU7IBbar+JDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMW+1VhxYppkwpJooa9RBTPXJdO1aw+ZZMjkWmb4Zk4=;
 b=qG5lHgVwLieI3XcDIEzVPOm3NAmJ9IhEH8iaHxv7s7z8iQvLmY1eF4yV438/5B7gwx/Emyq6wdTkWDLKb3aA4gn+GvYD6Y9XdPsFzLI7hl3bcuSDnxaSqiBWpqJVegdGM2iW3mujsVqIMbwHwpunHjUww/G5BY0dGcJ/DD2sqt8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB9189.eurprd04.prod.outlook.com (2603:10a6:20b:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 15:57:16 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Tue, 11 Apr 2023
 15:57:16 +0000
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
Subject: [PATCH net-next] net: phy: add basic driver for NXP CBTX PHY
Date:   Tue, 11 Apr 2023 18:57:06 +0300
Message-Id: <20230411155706.1713311-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB9189:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b84e2e-c133-4d58-0ec1-08db3aa56c32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EN2YNcEhyHWCLhvdmLj28jKpk/XDfHz2Gz6KVj1CNgEIzmgZona8zag9WYGNyXQkE0lkWD69H7Ahr9ORmlEXAUYWmf5OJkqwCaVSe8ipDsMpdYaLjgm0J3XGfUWF5z8kgBLLIPyMeakwqlEZvmn0SZ4n/J7TYKaMiQrP7n7nCe+W2NqZ6vjdtqiqsYw6LXJ6kJtQEB2xAv06qHC8wLoyzlMnskT6l9G/qRmGQH+B6AbnGnuM7uDSGo8huARzCsCfWG0TPOl4n85FyhqKet+/4gyW3YSDVVfOisyGRwRHdaEVKB3dVhhPvgrSKFTpS334NPyC+kzvHPL+OAlMn/kjHo64taUkRSz3V3hMDdUkgfYimJqobM/RqTWQJuixj0wKDFOfFa43aXc/bclCecII9BiAfgkxkOHQRg1B/ZPj7qq1ugQE+Px5RFwdWtEQeM/gUujE7C7keFQYYH4uIkTyQm+QdmypD/U8hlF6dao7pJVjPj5gwrgo2L2m1refq+rtDxSwemMYcXsk7a7Z5/NdhnEmuro6Lo9YAxTsKF0aFxnmNDRSeKHyOkJR+NCKu8hsD27/NXz+4UJww/LDbsOgGq6up3+ZnI/GQNvVrvfjrpugPp/hKI3ZNRl4brgaD3q0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(478600001)(52116002)(6512007)(1076003)(26005)(316002)(6506007)(44832011)(186003)(54906003)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6666004)(6916009)(66476007)(6486002)(8936002)(66556008)(38350700002)(86362001)(83380400001)(36756003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3hi7ZQWO6EuB68+EziZaUNzbf1brn5kwdPkIE3nF6SONtKI7UWF2Iz7yqjn5?=
 =?us-ascii?Q?+oz3SPnIgdfYeunj7w4qxOCttrks9EUAVv4PQ5/AysIwcmPHste0rZ3A4DDR?=
 =?us-ascii?Q?l+YczzsFRFA/8S6Ts5A1tjK5ZZ+2A72cXyutq7sJsbkDojDk3KuceEThlFag?=
 =?us-ascii?Q?0oEm/mz0huEOZ/YERiWaRfIcroGCb2Nzsyhj0K9sa3iQXmh528st2P7/DBNr?=
 =?us-ascii?Q?bzc/i9OeTvZeCvmlhDxTvgKo0WvFl7T9c7WaNGebfJ3NdIKHrl/d8SUgUkss?=
 =?us-ascii?Q?5RNJmeOFnNFKX8Yoc6Wxf1tPYvsTGDAIu36DYxySQB3bwmPHOJo0E/OXchoj?=
 =?us-ascii?Q?311gEJB7Lkmd7HdH5weGQW88xvl/JZ7JqcvwbScQLAWf0n9B0KUmvMoh4ZvC?=
 =?us-ascii?Q?tBnJWIpOBVRNrWx2XiKRZerleb4L3nRwtdgSyzlC1IuAgaANbZu/OlfT4tHw?=
 =?us-ascii?Q?YoeRXykqLnM04jMYzbK76gY1MDCRa2KSQ2oGiuPyDCBtj9XcGLe1qxPrsPAI?=
 =?us-ascii?Q?CpPgLwwxGBCSgJDJ46AJCph0tslZ2Ii4Q5QEu1uBD3aaPkwAh0FzCObHOdgd?=
 =?us-ascii?Q?gVBz8wgrHm7ft9XA/xs9Ohz5IkroIG9f3ex0LSSKIKJfkI5HituO1ULlp7VF?=
 =?us-ascii?Q?nacxx2zjs/uRL3sUdf9hE3XG7MDbT5KBUvGtYkHD7V+klyQo23/jQ6pbcyeS?=
 =?us-ascii?Q?N7hYp9pkaW3lpEF8FNDr76Pt9lYFpu+uEJmeKCJn7FJiephTlC9I6Q+AwhOo?=
 =?us-ascii?Q?gQzKzP+ZOMEWrjbC8buD1dZr6pKRNg+xLuyGRHAk/sLTn1R+MVsxgcrdr8yn?=
 =?us-ascii?Q?lq1ncuCVXGKytAN8SAogZ76ixE43fAmNKy3aw+wxAFd+R+j3zIygG4hpspIl?=
 =?us-ascii?Q?DZnUTJfqzPfZyAjwn/MJ4srzS4HzrQ2belCrmhAXOBFauhBVd5ovlhmaJq55?=
 =?us-ascii?Q?VpKVJDcUZJaxRLhF/uAsnTqWPMSk/nmS1OQTpQx6YpjwM53eSw7xrfwAQmtD?=
 =?us-ascii?Q?ntY0r7ZWuZ+zb80LVqtDLbpdyG/UAjo14NIF47FvQYqmMD62G0KBn3G2Buwx?=
 =?us-ascii?Q?esNUuJ/HUTKM4rJl4BnQE55iGs3ezpb2ya0mQfouqZlPPZ6vJXex1nHAVAuT?=
 =?us-ascii?Q?puHpQUyUejofHtsknFMKzu9IoYgSR3qi2WzPkhnBdGfWh9dPMw69ipbgwd9P?=
 =?us-ascii?Q?lkfEh7laPchuZeAq7cjzamF00ttct3OIBcjhFhyB0DnLZIZVmx7NmM/x0luY?=
 =?us-ascii?Q?fO9aiJjVA+cpUqWgCP+j7vxCu1npBQq745ozE6/4LoJTQh7VnmUjcesyFVns?=
 =?us-ascii?Q?Gue0Erawpd4RFzkvQNei8i/TZkM8ts/39YBAUcEVBgQB2KUuieAK5YRYMwIP?=
 =?us-ascii?Q?tE/4hEG/GybYtNV2djg1x8/ccaIWUfDVgygJEq2MZNQ+PFNkOA0/NXfUkolg?=
 =?us-ascii?Q?WS4EioY0EazbU8+FCLX8cKQviyb6QuUoNrMvPlodedsiubQJ0ZofIqwcs32v?=
 =?us-ascii?Q?NFoWkttJ3x/+ZSGNZDwYhNEUrgWCgvMhMoZgQ2OEsAmNSNXFh19qJtbWMelH?=
 =?us-ascii?Q?eou18d4kTfjyHAQqeAd+s/WqK8rkad6OHDhrCdlu9fnOy3gSFScfU3U5VUwi?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b84e2e-c133-4d58-0ec1-08db3aa56c32
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:57:16.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4WVq6kn7UA7Xmn0OWXrBL4YRMQNQ3Cb0m6gAHsCHxl8EKjCTzHXL2k1GKImXSI6ViHMJRhR4qgFnIkmeoLnKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9189
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 drivers/net/phy/Kconfig    |   6 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/nxp-cbtx.c | 251 +++++++++++++++++++++++++++++++++++++
 3 files changed, 258 insertions(+)
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
index 000000000000..936761ec516e
--- /dev/null
+++ b/drivers/net/phy/nxp-cbtx.c
@@ -0,0 +1,251 @@
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
+static int cbtx_suspend(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_suspend(phydev);
+	if (ret)
+		return ret;
+
+	return phy_set_bits(phydev, CBTX_PDOWN_CTRL,
+			    CBTX_PDOWN_CTL_TRUE_PDOWN);
+}
+
+static int cbtx_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_clear_bits(phydev, CBTX_PDOWN_CTRL,
+			     CBTX_PDOWN_CTL_TRUE_PDOWN);
+	if (ret)
+		return ret;
+
+	return genphy_resume(phydev);
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
+		ret = phy_write(phydev, CBTX_IRQ_ENABLE,
+				CBTX_IRQ_AN_COMPLETE | CBTX_IRQ_LINK_DOWN);
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
+		.suspend		= cbtx_suspend,
+		.resume			= cbtx_resume,
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

