Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9924D452AB8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhKPG3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:29:09 -0500
Received: from mail-bn8nam12on2108.outbound.protection.outlook.com ([40.107.237.108]:61728
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229945AbhKPG1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrWgF+wyaW/tK7LM1TE9u9X+pgRCo7xhGXrxfBrCQEqIjT1oI1GpdD3zoxZZktqfTLVWAOdru4EofYzOUWWl4tPZfHo3NpgL3wlh60hF03L0YNxDM1cPOpe2kI9CHUh4xrsny60v3XXf00QMeGWy5yttkJpC2/8s79Wdb0EOcIeGcs5AWbWusW9dlvdSSsKqwSHPO3CmPLjY8ug38vM6oNk8gg7S84hzMn9Blc5z8oIy+mGHrBtuP69ihbWdx6f4lXbNRhNFWIfXV0GITxlMMPvBzMy9i/cKRWjlc8s5673fhJIJYDrsJ7NQo3tQlcFO7yZm6tYvop2Kre0KCyNSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLZm14PaoFv/fWWguHry8auKUDqPRVRARNbV1Owv7hA=;
 b=CzSMn3zCGlhVJlcThsiSUMRUarPmkkfI6kdz4x3gkdxIbpOuc12arVcek5/kwEXhwl4Xs83tfAZrntp/+pYHY6zApO8HiBBl+p99UBjIlAGVupRaPiJce82OnTjwVAoAXk/GzIwYjBim2XCyV0i/voKR2ndBVVMMwLAmAC6OWYWwQfg4g+k/qBOUXwcEVN1xk0LUlQUK1jVhzE9izrfxbf6gY0k7bJ4jNb1uvhV153fUqfuHcDxLnd90+hyKwqU0Ng4z7wKyTEyNxbonxvB5mCs+LrRK/UB/JwOVolhsL76nxT8KcXxM2ubTMJB8PhMIh0QASNvsFTIcUaQfppoXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLZm14PaoFv/fWWguHry8auKUDqPRVRARNbV1Owv7hA=;
 b=s2RW6pWIIpaHpp/3u1oLFB1xw60akPLZKEB8gJmhseSPymWCYNmy55BmRxC4yo0fYe/5FHPrOP7WQB7+CYCpG4RbqWG/5ZrnEr7+rwlSvOPE3Qa4CTr8By2GOkfYh6VaWIwEbUlIhA9TlE+ZynILRomVrNIU9n5IoIoe5HUxde8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:44 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 02/23] net: mdio: mscc-miim: convert to a regmap implementation
Date:   Mon, 15 Nov 2021 22:23:07 -0800
Message-Id: <20211116062328.1949151-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c9536c5-fb5c-4f91-23af-08d9a8c9a38f
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2383EA3A03B71EFA297BA5B5A4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29nSh9+IdhNi598BX5yn4bPiFzmniyrsrLV4DT65N0z1Z03uKnPbvWLJPMx7SgyRpG67WaC6HCiv9/jgW9keVRaltHGjO511ajbSsm9OI6t6tYkDXUoGKyWj+EcEmWbBKM+uuuXpN1friS+0Ign8R2muj93RuKcqMKgYVGCnuHjqzEVElmxf5wca5c7k8AKdZkHSaDWnHZ1IC20sMRVgZcD+rZwoLznZhoPhBxT67RWi5m600z4xIZ2ALhaXjg4ukP0tRgA4b5Vu1lLAeZSkeIX3hzF7sXYlJr8ZQ9xsNr5rssTfmVMeo1+g7xbE4TyGhhDJP9cFL+43hWBw5Lqr+rmSc1HehzmO7AA1aTSHpcw/UZeYX7cGZqmLNejZf9xI6LTg3OZ8sAkGNK5yFeUl5lNQWrDSF/MqrdnZ2ZYtlmXETr8Yxkme+GzBk6adOixWcpGrNGenSs0dGwkmxurbbWJT6qlMzCpL8/ssDDmECit4/qzwwgxJEY6Bzr3O3faYaSz6DIbfOeXy8YPuZVLfa60SRMAzaAvM4B7Qr1+EWsSAIWhtdHnVjh/aAODb6pkzMayb7Bbonaqgo6U5Fsy37wR4in3v7o17XRfrbH4RhXGk4YRJlEuzdr8hy0IVgc10X43ckYm2v0AQ7TONPVXiYBORbvO7zdIebszT56NvNm4kgWn7v9U15h+Lnlet4ftBr4t433ZOBTVJ1prHzXEXIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wOYyiHBg4OpsD+5Tc04k/cQnCf8x3X7oc8yLQeOPFy8lyoQz2vd7/XBsqjUC?=
 =?us-ascii?Q?QZ2rJq0wIJhIEB1GIS8s2931gkvrdwVU9hJqOCBJvpAGcSeL8m2hF+ytcpnl?=
 =?us-ascii?Q?Fxk7bDN2rTI5wMnQqW+I5EP6ivA17j5cc5W0FwKyWNZ50y+mBh2QhxEKDMFE?=
 =?us-ascii?Q?J3bO0r5ACP/J2NlvHXaILE8mr974X/weYmxyQUUeF1cNMgaADKW34u2SMwrP?=
 =?us-ascii?Q?n54xS8Xnfixzu6ML/TCmpsjW/ZHqlfLZqDiPzK7Wz6r2ErSglR0uCXtW+/SK?=
 =?us-ascii?Q?UWOEJ/qEKrdhIdv532jNt6QVuFm777nN21eBPdlTD1AUDhrelNvuQYd/ae0H?=
 =?us-ascii?Q?ISv1GtOIMNEC71QXBT2+zT6xmOACPb7f5jzRN9vHI9oW/kutAfssIwgRZVGp?=
 =?us-ascii?Q?f+H5es6CYlm18Ky21g36b3xwtyrAFHZqPWr/HMRzKeJDPM8wrqq70tDfeGFx?=
 =?us-ascii?Q?7i6CfvPYLzA06En74mhV4t+ljSA/XcOx3FxfjJFKOFPKUD/RhHwAjWCbZJOj?=
 =?us-ascii?Q?ukT12xeLtx/GS6nVOUgLim5FsgIDUwLMwsa25Qjvs6N9E0G+cFbXOR3SiZcK?=
 =?us-ascii?Q?q38ubjJZq3twztRlIZD0XFS2vm+qjPVFowZVDGfyxRYZFaZI3DnqB//lievx?=
 =?us-ascii?Q?b+gTlJoW5TabDWl3Wa7CxpS+RQRRUNP/wze+vqipK/ovxqYcv9NQ2HzjYP0q?=
 =?us-ascii?Q?2xtmuFQ04JaXoFaHcEFYNHINMtAiv0YJY10mk9GJY3HXfIwSSvninCHE0kpN?=
 =?us-ascii?Q?60JsNXhItpunQP3QSKhWUBzkpkQj++lhhGjPrx92hdK+rnmshFbsXTrRg0ZT?=
 =?us-ascii?Q?6ljkOadQcDCu9K0fIhIA4KQlA8Qy1SGiWXnykJD84FVuPrKsPJ5BRq87gMqK?=
 =?us-ascii?Q?ojhlUxRpMkiSK8f6wsSL9eoDIfobPNx0aa+yrGbhN5t4RDxXcr6DlBn92n1t?=
 =?us-ascii?Q?m6TGzplQ0Ty2BB3s3mwZY+vb8vsXcTPBJk0nYqqPSgSIBwEJ9B1sedETzHww?=
 =?us-ascii?Q?LYirUOlou99ONwnA9hsPvbcQdpJIkpQ6PBsLOo/c0/jTUKH9wuihWlAREJdy?=
 =?us-ascii?Q?L+CSG098HpD8NOkHkrQAz2ax9XIbyc/XW2nf02OT6H8BZqkYHJpARQJCfUMZ?=
 =?us-ascii?Q?CZwg3HOLFtX7PLAP60Za/MfrTgaWcDzdKAgJtm3cNXltmt8jKySx7M+qgXof?=
 =?us-ascii?Q?NZ9J6CyFdSt9QDc0co2uOaBbFwUglfQEcEBPLjRpNIdWCyrgzm304YWs9qw3?=
 =?us-ascii?Q?oo5yfzCBVYU4/CqvbWVLs0iTlwFlB6fw/Y8QvPMqtUta6Iyr0HxHi/rk2oVG?=
 =?us-ascii?Q?Z29jTolqybr0JTFccMK7a970K1MNSv2rX2hEKQu1J9jB7QPkAiS0k5lerKO9?=
 =?us-ascii?Q?3PjJ7Ss19za23lT6VT6dMGt30avo51bAjuceJQpKhb7mZg2fsl9HhjflJkDh?=
 =?us-ascii?Q?BhCp6S5jwwasWl3dAxmbugQPI8BFErPntzZSeOg4/UTbB+tdOfSYjtpw5pqb?=
 =?us-ascii?Q?dAamCWL06F+fLW4RsVE2h3va6UmrTPtEK2QkFwTtZdWu5tbbVU4C3hBm/Ukx?=
 =?us-ascii?Q?FbsmH9qYXMKDjXPfIeiUyJKnLgEIbKkGRE/BvQKjnI5diHb4fxLUfja+BBVw?=
 =?us-ascii?Q?6Og8Zb/G088xWkFIfWy9e4dxlw8tVaC3mrplIyC6Tu4AbNoIsavZaK0KrOCO?=
 =?us-ascii?Q?xwiUyY1FDuPwbabQydRMhTCkMcw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9536c5-fb5c-4f91-23af-08d9a8c9a38f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:43.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAI4vqOp7L33bZD3jCoXNJKdM5CAcoK8PARKnoMX1hfb45/itZH+75lYrHO6jLhkVz6fdTQxGb8XLmhFrAWKISnqyUKzaMhjDm1WHzAexGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize regmap instead of __iomem to perform indirect mdio access. This
will allow for custom regmaps to be used by way of the mscc_miim_setup
function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 148 +++++++++++++++++++++---------
 1 file changed, 105 insertions(+), 43 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 17f98f609ec8..ea599b980bbf 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -14,6 +14,7 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -35,37 +36,47 @@
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
-({									\
-	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
-		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
-					  timeout_us);			\
-	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
+#define mscc_readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us)\
+({									  \
+	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			  \
+		readx_poll_timeout_atomic(op, addr, val, cond, delay_us,  \
+					  timeout_us);			  \
+	readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us);	  \
 })
 
-static int mscc_miim_wait_ready(struct mii_bus *bus)
+static int mscc_miim_status(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int val, err;
+
+	err = regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
+	if (err < 0)
+		WARN_ONCE(1, "mscc miim status read error %d\n", err);
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
@@ -73,22 +84,30 @@ static int mscc_miim_wait_pending(struct mii_bus *bus)
 static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int ret, err;
 	u32 val;
-	int ret;
 
 	ret = mscc_miim_wait_pending(bus);
 	if (ret)
 		goto out;
 
-	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
-	       miim->regs + MSCC_MIIM_REG_CMD);
+	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+			   MSCC_MIIM_CMD_OPR_READ);
+
+	if (err < 0)
+		WARN_ONCE(1, "mscc miim write cmd reg error %d\n", err);
 
 	ret = mscc_miim_wait_ready(bus);
 	if (ret)
 		goto out;
 
-	val = readl(miim->regs + MSCC_MIIM_REG_DATA);
+	err = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
+
+	if (err < 0)
+		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);
+
 	if (val & MSCC_MIIM_DATA_ERROR) {
 		ret = -EIO;
 		goto out;
@@ -103,18 +122,20 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 			   int regnum, u16 value)
 {
 	struct mscc_miim_dev *miim = bus->priv;
-	int ret;
+	int err, ret;
 
 	ret = mscc_miim_wait_pending(bus);
 	if (ret < 0)
 		goto out;
 
-	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
-	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
-	       MSCC_MIIM_CMD_OPR_WRITE,
-	       miim->regs + MSCC_MIIM_REG_CMD);
+	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
+			   MSCC_MIIM_CMD_OPR_WRITE);
 
+	if (err < 0)
+		WARN_ONCE(1, "mscc miim write error %d\n", err);
 out:
 	return ret;
 }
@@ -122,24 +143,37 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int err;
 
 	if (miim->phy_regs) {
-		writel(0, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
-		writel(0x1ff, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
+		err = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
+		if (err < 0)
+			WARN_ONCE(1, "mscc reset set error %d\n", err);
+
+		err = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
+		if (err < 0)
+			WARN_ONCE(1, "mscc reset clear error %d\n", err);
+
 		mdelay(500);
 	}
 
 	return 0;
 }
 
-static int mscc_miim_probe(struct platform_device *pdev)
+static const struct regmap_config mscc_miim_regmap_config = {
+	.reg_bits	= 32,
+	.val_bits	= 32,
+	.reg_stride	= 4,
+};
+
+static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
+			   struct regmap *mii_regmap, struct regmap *phy_regmap)
 {
-	struct mscc_miim_dev *dev;
-	struct resource *res;
+	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
 	int ret;
 
-	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
 		return -ENOMEM;
 
@@ -147,26 +181,54 @@ static int mscc_miim_probe(struct platform_device *pdev)
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
+	struct mii_bus *bus;
+	int ret;
 
-	dev = bus->priv;
-	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(dev->regs)) {
+	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(dev->regs);
+		return PTR_ERR(regs);
 	}
 
-	/* This resource is optional */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(dev->phy_regs)) {
-			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(dev->phy_regs);
-		}
+	mii_regmap = devm_regmap_init_mmio(&pdev->dev, regs,
+					   &mscc_miim_regmap_config);
+
+	if (IS_ERR(mii_regmap)) {
+		dev_err(&pdev->dev, "Unable to create MIIM regmap\n");
+		return PTR_ERR(mii_regmap);
 	}
 
+	phy_regs = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(dev->phy_regs)) {
+		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+		return PTR_ERR(dev->phy_regs);
+	}
+
+	phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
+					   &mscc_miim_regmap_config);
+	if (IS_ERR(phy_regmap)) {
+		dev_err(&pdev->dev, "Unable to create phy register regmap\n");
+		return PTR_ERR(dev->phy_regs);
+	}
+
+	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
+
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
-- 
2.25.1

