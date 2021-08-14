Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762D23EBFDD
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhHNCu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:50:56 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:10517
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236545AbhHNCuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REpfD92vThcrmiuA3qoBkxIDfsbS26vjpR7YeOWws48+FcxJw6c1BEk2gO43vwDk0HIFglPnzIPYoCJ1qkJYB0rzr2gHb5CHokO8scRz+khcNbx3ZBO9UK44pFRJtf5ZYboiZDL8PqnFUV3xSQoxbs28VMfSEkeAOSobpVOau8k/ZKQDOWb7UpbONgzH0de7vAwSq+TpSKGl76jcSrmL+iWDokyj9lAaeO42Z8rs4frvHZT/QvSio5qQx0v6WUa5L+CNXfiGEMsliOGjEKH6HMMb5cmE4MXSMtVJnTm9KiH2vcrESZ4Ra0o5W1yEk1EajUTPVDfQubHS9ycV3yKogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwrVD5l3MIbmee81TfSNDFFAxl987qZvlXI4QdmHAug=;
 b=J5IsfoxtmbyChOeCxkacwy8eYc55FNINWLT5gv/Ma9l4nyMgH/0gK2M4AbM/YTfUzHHpS2Fsiov48gQT/b6RqmjyE9elNtdEar+e0FAqh/kkYa/w6WxdMuCHmQGgl5LS3esGizsDdBxjQIXdNQwjdOp+OE9H98lOc8xxpzpxg20kA1UdRTfE5DcgV+ITpmoqErXPfjQpnHhT1PIuPgJlUYg4of01OTANrFN0NIXVjX5XTykb8I4bX0HfFAD9HyXZq59kElRKSyKbdbdoeLttWgESpr1u0BRmqxPJwYJ7GQeOjFXthCbpewdg+TfKiffjP2b1zuC7GzKO5rdWIypo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwrVD5l3MIbmee81TfSNDFFAxl987qZvlXI4QdmHAug=;
 b=feQK5+ceqzy+ldo80a9rLaikQVa/41ccZYPiuIRokCzOC7lpmzbrVio0E2zHj3MwXurNfuUA4aimY+Hy5ytJYVEbOQVEG9LOYhJZPH+Ovff6D5122/anzTzQ6KVODPV4fXUMMmHiBQ/d5v67Fb9JrOe0eQyo2lVFHnMEE7pTxfw=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 02/10] net: mdio: mscc-miim: convert to a regmap implementation
Date:   Fri, 13 Aug 2021 19:49:55 -0700
Message-Id: <20210814025003.2449143-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 186c438f-cbcb-403d-067a-08d95ece3f1f
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB2030B0CBD2A76D60726783F4A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glJRPls/hdSIRgEPrLjD9SaKL+vp9ZZtq9Go1IVhnYyfikPssp533ExgiXoJciplKCkJQ1cK1P+ERWRczmfouDsyYxslXghMozxcnyWT0DpDMlBsP0HcYAPiT8SVSCGdG+wOuedbsmKr34frt0/jkooghCR33kAjbB07IVCsWFbB3Zn+WfYQL/IefFkLMZvDBVBIvApJBkGfzi4zNLeNVQD9c21n2Ihifv99cR084nrinWGY23a6kehOlhG4VB09C8URBFWtGYCWMusR3SXZ5AyafxV069H1byLvCNeDyU4ZjmMpkfsex+/JQU1ce2v4e7AD2IZa5vdRZRU0BUfGmKbpxOLfje6T3etxzNG6wzWRTQIZdA3eImHFG9jg2nxo09EQXsbiiSLVwz6BJnYVsXxyFYrfZKtJpgOuBHLhi1w6I3zLHG6zqV2UVyEtgq6tAEVwudYTGglckDrBCvpABq+AD7fNbhaVJZJ2ct/43fBTbdtWM2q57h6Q7SEqB6wHCxMA3+kJ4MLgZ5VWw7kwcmQ9C66UeZdAXe17HDUJYWqhO17oLDY6CiS1O/9IikxCYQTLIj0GVTzv0RIA8ndUPa3AO3DcZYlwpkB/XENWwDXqmE6ghIH7lnDql/h7JWOIBuqgIr5gLQUBKTIk8Yg7Ve8gmXBcYpZNYQBrjW4PlZ6pmFtNC2e4DNte4iIs8iGr9LwzGODwKK4Qea0YuWaAh/6xwDL0XiTNesT/3Xszsrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cbjsVW/8XJB4FCAay7DGVKs+fmyMTOmVnGkI+WGnBEeJm4uoSeAOsm8D+hu9?=
 =?us-ascii?Q?HDbYKYXpQLUXeTQ1Sb6qfjLy+0qnleq0JZKjPIYlkBc23NEG91EGTvSGjPFD?=
 =?us-ascii?Q?h/Tp1X/9+TbV/wKEkFqY16o9kajgwznisMIioIkkHLRqXbgLrzb89+XEfYqB?=
 =?us-ascii?Q?M2UU7N7JCBkAE5oKlNUwKAI9xjMlyzYa0VwjJJHsCnybiKPJ3NRBYNHsJxcy?=
 =?us-ascii?Q?2GBlE7hLtShwV3n7Lgy8GGqrM760ED6aN3XrA1eVSSBTG4QH7h9zxhyFXsPf?=
 =?us-ascii?Q?Nz7G672ojZG8PGt5zh6Cs/PB7zXk66KAQ9lDCJYKlr/KV4REZlOcNShy5eQf?=
 =?us-ascii?Q?PU9yAYvXdFBE4Q63Qy8UCNn4yLedBvuFCx63xiqA5hhFUqIbye5ymV9drUV6?=
 =?us-ascii?Q?crQMoKHf0BppwxNouWD8OLdly9CKS3eaYEpA1K1+Cm3UQQNpAQyuYArtiZMX?=
 =?us-ascii?Q?bHIrszcixtqOZeRKqtRkZXRG7aN0rpj6jFjKJkHJXLEeBwaBoWoqBXPfWhyE?=
 =?us-ascii?Q?7QneDITgms/PupH2jm7BTII7AhkO8bDuQZrlEm9+foJkP47z7z6oS7xaO5jG?=
 =?us-ascii?Q?vESRvXgh4ebCnAHku4dcevc/tC2XD+uQyyczxnM9oMxD24Dicug2Vzik0jZv?=
 =?us-ascii?Q?r6n8C0RIRPGLUa1Etpobpod3hvvV4zdqmKQD18yqelUzVbzA2BfSJoFWxh0P?=
 =?us-ascii?Q?iCUi4fojY0VfmzcEY5ZBYio/Nf3FS0HE+tLqBGfr4Uqd9ONagOclEafmQFAw?=
 =?us-ascii?Q?tVL3dn9IYSg3y6TGeznXrZT1Dvteig84YxRZO6XQtcdU+jCcpyEf51y9zTXh?=
 =?us-ascii?Q?K6tpjbBGQZW9F20REDSa8aWa97UhY3a26O6fZF1oUuVdJr6fA2/NANXl/Q3g?=
 =?us-ascii?Q?zBqU3UaeW4XA6REDYbMENyhRic0xWT0Dx5t9pfzDbG2ZdLOaSPHufEPXhoww?=
 =?us-ascii?Q?OkJqN8FTtuDsYMe2BwXHSE5mQDpQjn5edWNvDyAw+fbGic5wqe9XiNdVAG+9?=
 =?us-ascii?Q?hje+Q/sP/ZugzuaeuSiWWdkSgodlXw0cXDTkI0CJzGyiXQ1P7/hzR15ztVsq?=
 =?us-ascii?Q?0AvMVCAo3enCre8ENeW+6gAfdmDw4IwKeAMikXK+yIzluIwneZ1sfJtlttAu?=
 =?us-ascii?Q?Mz1xLXu8slGXoyMkJ+8tTbHQzL4D10+AHgJ5hw3wi26nAlPXnaoF2DyOAg9P?=
 =?us-ascii?Q?IqAcOBVkJWelMGY4O3NedJNdMYvOHLQgKKztlzw+RYBg0CJ5+GXGDPNiQmoK?=
 =?us-ascii?Q?1nDvG2fQpz5duDCnC19nfGvPpCiLlIgszpOVNG7LEyY3gCtu9dffRhVQAs+Y?=
 =?us-ascii?Q?85fvQ8Vt1x+e6W4OlTHQhdLt?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 186c438f-cbcb-403d-067a-08d95ece3f1f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:16.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtJuLtY/qJVvPDhaqwJAAnLHF2jSSLfzuQ9B4c5AnilCfb2klf7Uo19P2hbVYEjQCFT0IvLnE8aqS/ii+u/240/i57YPttlTZUHR2R2XVKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize regmap instead of __iomem to perform indirect mdio access. This
will allow for custom regmaps to be used by way of the mscc_miim_setup
function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 124 +++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 37 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index b36e5ea04ddf..e1849e25c9ca 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -14,6 +14,7 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -35,37 +36,45 @@
 #define MSCC_PHY_REG_PHY_STATUS	0x4
 
 struct mscc_miim_dev {
-	void __iomem *regs;
-	void __iomem *phy_regs;
+	struct regmap *regs;
+	struct regmap *phy_regs;
 };
 
 /* When high resolution timers aren't built-in: we can't use usleep_range() as
  * we would sleep way too long. Use udelay() instead.
  */
-#define mscc_readl_poll_timeout(addr, val, cond, delay_us, timeout_us)	\
+#define mscc_readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us)	\
 ({									\
 	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
-		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
+		readx_poll_timeout_atomic(op, addr, val, cond, delay_us,	\
 					  timeout_us);			\
-	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
+	readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us);	\
 })
 
-static int mscc_miim_wait_ready(struct mii_bus *bus)
+static int mscc_miim_status(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int val;
+
+	regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
+
+	return val;
+}
+
+static int mscc_miim_wait_ready(struct mii_bus *bus)
+{
 	u32 val;
 
-	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
+	return mscc_readx_poll_timeout(mscc_miim_status, bus, val,
 				       !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50,
 				       10000);
 }
 
 static int mscc_miim_wait_pending(struct mii_bus *bus)
 {
-	struct mscc_miim_dev *miim = bus->priv;
 	u32 val;
 
-	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
+	return mscc_readx_poll_timeout(mscc_miim_status, bus, val,
 				       !(val & MSCC_MIIM_STATUS_STAT_PENDING),
 				       50, 10000);
 }
@@ -80,15 +89,16 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
-	       miim->regs + MSCC_MIIM_REG_CMD);
+	regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+		     (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+		     (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+		     MSCC_MIIM_CMD_OPR_READ);
 
 	ret = mscc_miim_wait_ready(bus);
 	if (ret)
 		goto out;
 
-	val = readl(miim->regs + MSCC_MIIM_REG_DATA);
+	regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
 	if (val & MSCC_MIIM_DATA_ERROR) {
 		ret = -EIO;
 		goto out;
@@ -109,11 +119,11 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	if (ret < 0)
 		goto out;
 
-	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
-	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
-	       MSCC_MIIM_CMD_OPR_WRITE,
-	       miim->regs + MSCC_MIIM_REG_CMD);
+	regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+		     (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+		     (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+		     (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
+		     MSCC_MIIM_CMD_OPR_WRITE);
 
 out:
 	return ret;
@@ -124,26 +134,26 @@ static int mscc_miim_reset(struct mii_bus *bus)
 	struct mscc_miim_dev *miim = bus->priv;
 
 	if (miim->phy_regs) {
-		writel(0, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
-		writel(0x1ff, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
+		regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
+		regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
 		mdelay(500);
 	}
 
 	return 0;
 }
 
-static int mscc_miim_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	struct mii_bus *bus;
-	struct mscc_miim_dev *dev;
-	int ret;
+static const struct regmap_config mscc_miim_regmap_config = {
+	.reg_bits	= 32,
+	.val_bits	= 32,
+	.reg_stride	= 4,
+};
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
+static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
+			   struct regmap *mii_regmap, struct regmap *phy_regmap)
+{
+	struct mscc_miim_dev *miim;
 
-	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
 		return -ENOMEM;
 
@@ -151,25 +161,65 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	bus->read = mscc_miim_read;
 	bus->write = mscc_miim_write;
 	bus->reset = mscc_miim_reset;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
-	bus->parent = &pdev->dev;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(dev));
+	bus->parent = dev;
+
+	miim = bus->priv;
+
+	miim->regs = mii_regmap;
+	miim->phy_regs = phy_regmap;
+
+	return 0;
+}
+
+static int mscc_miim_probe(struct platform_device *pdev)
+{
+	struct regmap *mii_regmap, *phy_regmap;
+	void __iomem *regs, *phy_regs;
+	struct mscc_miim_dev *dev;
+	struct resource *res;
+	struct mii_bus *bus;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 
 	dev = bus->priv;
-	dev->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dev->regs)) {
+
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(dev->regs);
+		return PTR_ERR(regs);
+	}
+
+	mii_regmap = devm_regmap_init_mmio(&pdev->dev, regs,
+					   &mscc_miim_regmap_config);
+
+	if (IS_ERR(mii_regmap)) {
+		dev_err(&pdev->dev, "Unable to create MIIM regmap\n");
+		return PTR_ERR(mii_regmap);
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
-		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(dev->phy_regs)) {
+		phy_regs = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(phy_regs)) {
 			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+			return PTR_ERR(phy_regs);
+		}
+
+		phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
+						   &mscc_miim_regmap_config);
+
+		if (IS_ERR(phy_regmap)) {
+			dev_err(&pdev->dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(dev->phy_regs);
 		}
 	}
 
+	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
+
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
-- 
2.25.1

