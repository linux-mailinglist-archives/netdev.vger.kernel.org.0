Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C11460C84
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 03:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbhK2CDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 21:03:41 -0500
Received: from mail-bn8nam12on2099.outbound.protection.outlook.com ([40.107.237.99]:52576
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231578AbhK2CBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 21:01:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRGLc8mD2x0yiiV1mcX1eW3YLHtP0guY/4Nt11yr+8+03TAgag6UVZNuYf4XH9BooLeYjyZim5pLoOkkBHvUIfpaxi5ZJsaItDy530LQT2YGKhkueR4tcrXFxLsfNeweWWf52C9eyTo3R8Jya3EWe2CdX9dzffGTnY2Vi8g1GcyQXdSUtR+oKzbAR8z4/JpSrnfg/Edm4UcyYiAibyie8CKV5NhyXNxeBjGt6scAsiTqIBgvpUI95+2SfIJYEpg3KAkHRNj3o8MzkjSu+ri9GhmcapFh4QFZlUVpuF/8da1eL7E9Nj9CrfHWf31p/fjapoDNyJWoXpXjfLdGrG01Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3lKtXASmqFGMg7xuzV0I0WpD4SBZ2FZiF9Gqqe9yiI=;
 b=IRUJle273W46uvdbFPhitUiGlsu5tmXMynOMsTFMTFHiDi68Pdrfru6pd6NwkOzIA7/YjTiTQAJ7xVGWaIXhJk0C5zmWyYQGth9fDgn0Y0xtvRQHNsAciI3jfUSxo9n/BeLMrXHnLYfxJ0l+UbKiaNsaLBtVbwzSTsqq8s81vigX4arO0KCQPeFLEjHVojUshvKsj3qmpBWS+8KMbJVve4JxkUP+nOK+UGZLOsuk54DaIo8OaHeX3DwfeMT6kbVxmox59gSZDKs0syD7d+q2cwE9jW0JwBtMPmbuRtLKXOayqyHGzpqb+8HQ+3rmCi8Uh2S+C9TMUtZZc4nSKgi2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3lKtXASmqFGMg7xuzV0I0WpD4SBZ2FZiF9Gqqe9yiI=;
 b=eFLJaq5xEB5D/GweSBrwrMzWpHJvSpigcNNFg0XCp5z7zsgyOrC5piZEP65aoZBJvtHECJsPWF9rIfhn6xh4MLyjCgUwBrMcSDaJDs75TqGAgt4zr0BeTKwc5ktvHJvX7xmHFHFj3FAKIHkCjnYidUvEgFzNCgPE/TYkI/2zdNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1341.namprd10.prod.outlook.com
 (2603:10b6:300:20::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 01:57:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 01:57:48 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 net-next 1/3] net: mdio: mscc-miim: convert to a regmap implementation
Date:   Sun, 28 Nov 2021 17:57:35 -0800
Message-Id: <20211129015737.132054-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211129015737.132054-1-colin.foster@in-advantage.com>
References: <20211129015737.132054-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:303:6a::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0050.namprd04.prod.outlook.com (2603:10b6:303:6a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 01:57:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bf049fd-f75a-4425-01a9-08d9b2dba4a1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1341:
X-Microsoft-Antispam-PRVS: <MWHPR10MB134153797236B3C6823B0729A4669@MWHPR10MB1341.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: az8jSekGbqESnzYAUIBYu1rv+AstonqhT18W45em3dgih4Lxk3FZk8u6avMc2TblaxkvucAv9SXr30AgkmcrmWS+I8xu5T/AiNr1LPz7YPgT+50+gAKtLmqsaR0xF9GZk6qoukDOt6j5CQEIr0LA67Eyf38NRpvwRRiIgPMC7RmMbA3LpIZ0x3JY8J3wtm2OyO/1uIsduNOv9pJLfg7RC04F2BVLOzPXedLmEzedSknqoU1224/PXKv/gYb9WHoARbVqssvS9mUpaZB62gnmcfiPkWh109yD1Vn8ql/6UvrDSVnoF1Nr5RHUZfwJEJKj5SyydWvT44XwOiLrs0T5ORE1GAyB1E0W/CsrpSVk0bF+lp9veG089HYyst4qLsqdseKjrxum1rxS21nh+A63aUwyWg667/7wL4H9wlDtpAJdm90hGlbuLdgO0lBaEOpPMH+wERG+PE76bhIOe1HKkpG3xa0hmI7ieL52lYVgXJ3xuaI+jL7B2DecNZO8775lWV3vgrzcFRGtnzp3XdZ7rvEcoUjBtmreEnGuyET+bI6t/dQGq9yCuKITTH/Pb/b9zYZ1C2LNi27SwJSt8gYsEvGEtXWd73i8pV4HNsqqbd90ryp5P29pOfM3L/P0GfzljbR8lw5XfZhleNkV3BQkEa1B9jfQVlgO/ZQw91hlplRuRmMQ+j8l3RrzPuLDRnezbIzmu2YIdKp8Jnrkvo07bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(396003)(136003)(376002)(366004)(26005)(66556008)(66476007)(66946007)(38100700002)(38350700002)(186003)(8676002)(316002)(83380400001)(6506007)(8936002)(2906002)(508600001)(36756003)(6486002)(54906003)(4326008)(5660300002)(52116002)(6512007)(44832011)(7416002)(6666004)(956004)(2616005)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sk38gO0wlbgJtSq4UckL6HJt60/TrjKp8ROv+ejXd3V+wVbNMtVepMRtYj0/?=
 =?us-ascii?Q?ceErxn4x+ndqL4UciEuIYDUOBM9DuKEDdw0kQCJI7YIg7J+vjFtLUYmomRVU?=
 =?us-ascii?Q?cMUomfQ14uIaS4qeeW7rEA30zMGAc/z//WJI8B3bfqb21+uqKVB7hYArsrwz?=
 =?us-ascii?Q?Xpny27aos3CQihZdUwV/J1bmSLGOPgE+9dQMEb7h50tOnEf2uXtu0bnXVCAS?=
 =?us-ascii?Q?VsTQAvLGBSvydwPdO5iSXcupLFH9vefTWsSKSzfRts9E44ztWmutSBoXuKvM?=
 =?us-ascii?Q?WchL7rATN601VyfUyqrD0ab8aznrBPWdWIF+C7e0JFNJIwOIahNOXgZj4zf5?=
 =?us-ascii?Q?9Ncps6cOWuqSNMGULxKDHoTni3oSFaL8npy6Si8n5UPcsBLnv65UIufzL4NX?=
 =?us-ascii?Q?xB29Qj9I+J6VqQ8b1IMhfdbCrJRbQSs6cAONX/W6xj4PBTcG0yEwI1XkewTt?=
 =?us-ascii?Q?d4tOl2zXPHnCB+nJRgFYtNQM3md5MOEK3KsTHyr6/YRY5jDb/tnjiZOo9qet?=
 =?us-ascii?Q?BhVN/hsTmtAYntwFZtvvP9Jqs4b5p9iGM9z4b/lTLefPrQqSnJKTwWGNaEEg?=
 =?us-ascii?Q?osPFv87DFb+zz2WAqXfBgo9eipZnLW1aUmhrxplYY1mv8rE4+nj2eGqB3ko8?=
 =?us-ascii?Q?n/d2oB4oDFdGJu/TqfvKHbxuV7zh6YNtr9bAE+JARkS0B3ggCV86YUZSKgWR?=
 =?us-ascii?Q?jdzEg0AXfL6rH4fsltdbORgRpCS0/9OSlKUP18DqUml//mvPnj6ii12LKDOB?=
 =?us-ascii?Q?lpMU/sk5aJLI9q3EPuUi5FpmL8l+FEbijgt//M72/Y5dUNIDVfCb20tD/YRi?=
 =?us-ascii?Q?XXzaq1zxf+ufxuSUMlR7zh55kFA8CanMQ8vpEchXWFljXtuLsMb/jfVs2ppb?=
 =?us-ascii?Q?BURSJoLZdvsQTYxM0mf7vKhq3U3hN30beleqrPyGwhytHvb682Uc45ciGuBF?=
 =?us-ascii?Q?k3rg8Vk7bxZJM9yMCtsSLZSYlIP4HFiTeY1plX9PblbdhQlGw+KuUpo5f3Ba?=
 =?us-ascii?Q?brf9jMDomODsTV1W2cQcB9Yq/6dX2ls7bjS21zg67T49qF0w2CWbGlNBS0Ts?=
 =?us-ascii?Q?zGKhe6/tpATEVqQ/pQ8/1IyQCV3sdx+LjuKhgaM9bWekVSTrBe0qwQM9MR3R?=
 =?us-ascii?Q?WJQkLjWZfISoo5by+8C9VOs3nDIr+Y99KrWRAaB4qUnZscbB+rKhO2W0l980?=
 =?us-ascii?Q?SAlkjDXojGZn1kvVDOsP5Qo4xw/Uoy2JBeOdS4HYc64S7T5kYiUOimWVCQfA?=
 =?us-ascii?Q?Fkph2cgUE9U3JItoyOPOZRQPazqfxFGg26pPJXCc3TxZrzb6eSutRVXX98gb?=
 =?us-ascii?Q?+n6dYQr8+qm8jUPBWIMXigiQBXIbakLhesj4bEFhkd8ir1XBBS5epES1kqIq?=
 =?us-ascii?Q?G2tYTyuD9UDBmGe2n48pdRF9XhvOJZbMMgNYgoUvmYzVmYmbLbNuJ6va3dSP?=
 =?us-ascii?Q?VQkDDWQutfpCPe/qf9h7rd0FvXig3XuoH4oejFYg1Wg2H9JXMvIgYq6Rm8Fo?=
 =?us-ascii?Q?Yz/xLl5CPLnRGJle0AurdpjJ9NMdYQIpAMWXFypImYj+qZBU4T/pQn0DuQIc?=
 =?us-ascii?Q?bzpRO/ai1TnGwE4v3fYjD3CeS4OlgA+rKJFqg2wFN4YHbdDRDp69N/rja9NG?=
 =?us-ascii?Q?ZkXxv5HetkFwnWQE+pTrlCA+jB58PBtUdNHJLl86bQ0dqJdwhqTyH5kIEuoz?=
 =?us-ascii?Q?zVBXFw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf049fd-f75a-4425-01a9-08d9b2dba4a1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 01:57:48.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXLUpPk65hJY8kOc0qUBjwDJrW2tr2tT43zDKOjdShJHo+ojiPxUijuk0AthzmkxucI4TJICPdCNB2V9w8sZJcKueNSQqq9fX+W4ueifHoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize regmap instead of __iomem to perform indirect mdio access. This
will allow for custom regmaps to be used by way of the mscc_miim_setup
function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 163 ++++++++++++++++++++++--------
 1 file changed, 121 insertions(+), 42 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 17f98f609ec8..e016b32ad208 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -14,6 +14,7 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -35,37 +36,49 @@
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
+	int val, ret;
+
+	ret = regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
+	if (ret < 0) {
+		WARN_ONCE(1, "mscc miim status read error %d\n", ret);
+		return ret;
+	}
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
@@ -80,15 +93,27 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
-	       miim->regs + MSCC_MIIM_REG_CMD);
+	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+			   MSCC_MIIM_CMD_OPR_READ);
+
+	if (ret < 0) {
+		WARN_ONCE(1, "mscc miim write cmd reg error %d\n", ret);
+		goto out;
+	}
 
 	ret = mscc_miim_wait_ready(bus);
 	if (ret)
 		goto out;
 
-	val = readl(miim->regs + MSCC_MIIM_REG_DATA);
+	ret = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
+
+	if (ret < 0) {
+		WARN_ONCE(1, "mscc miim read data reg error %d\n", ret);
+		goto out;
+	}
+
 	if (val & MSCC_MIIM_DATA_ERROR) {
 		ret = -EIO;
 		goto out;
@@ -109,12 +134,14 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	if (ret < 0)
 		goto out;
 
-	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
-	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
-	       MSCC_MIIM_CMD_OPR_WRITE,
-	       miim->regs + MSCC_MIIM_REG_CMD);
+	ret = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
+			   MSCC_MIIM_CMD_OPR_WRITE);
 
+	if (ret < 0)
+		WARN_ONCE(1, "mscc miim write error %d\n", ret);
 out:
 	return ret;
 }
@@ -122,24 +149,40 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int ret;
 
 	if (miim->phy_regs) {
-		writel(0, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
-		writel(0x1ff, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
+		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
+		if (ret < 0) {
+			WARN_ONCE(1, "mscc reset set error %d\n", ret);
+			return ret;
+		}
+
+		ret = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
+		if (ret < 0) {
+			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
+			return ret;
+		}
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
+static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
+			   struct regmap *mii_regmap)
 {
-	struct mscc_miim_dev *dev;
-	struct resource *res;
+	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
-	int ret;
 
-	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
 		return -ENOMEM;
 
@@ -147,26 +190,62 @@ static int mscc_miim_probe(struct platform_device *pdev)
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
+	*pbus = bus;
+
+	miim->regs = mii_regmap;
+
+	return 0;
+}
+
+static int mscc_miim_probe(struct platform_device *pdev)
+{
+	struct regmap *mii_regmap, *phy_regmap;
+	void __iomem *regs, *phy_regs;
+	struct mscc_miim_dev *miim;
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
+	if (IS_ERR(phy_regs)) {
+		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+		return PTR_ERR(phy_regs);
+	}
+
+	phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
+					   &mscc_miim_regmap_config);
+	if (IS_ERR(phy_regmap)) {
+		dev_err(&pdev->dev, "Unable to create phy register regmap\n");
+		return PTR_ERR(phy_regmap);
+	}
+
+	ret = mscc_miim_setup(&pdev->dev, &bus, mii_regmap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
+		return ret;
+	}
+
+	miim = bus->priv;
+	miim->phy_regs = phy_regmap;
+
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
-- 
2.25.1

