Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE045E175
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 21:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357098AbhKYUS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 15:18:58 -0500
Received: from mail-dm6nam11on2116.outbound.protection.outlook.com ([40.107.223.116]:64547
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356927AbhKYUQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 15:16:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0SggzUKZP8LNDhqPf/88AYVf79w1r0PpRcDSQrPA5GllGXE1g6xWmwiN0tnge+QXkyMI1w8NPb41V6vQ8ZJEyQy8bmiTDoKCYYA1AcI2Ro7DDkyWmVbRakOnFruptTYZiM/DArV+HV7Qcek9DXWoETZShkANgetxdVRaC5lX2l4vzGXZ3pgho90M12x3bSAjx985hm6wX17JSQWiNipRWIGeZbhra3AIGHXZF04xlfZs8zaeV83CfBYnX+XtDcqcGYZDxr3mliRcfwEngcuIx+mfDV2ZJ+dKCliS3Rjs1F9qKCfzkzbF8EueUe0hW68e5MMmm9xhgOLeznhshdNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1L1M4G5nIPqHbUlMt9hZ1Wilw+g3XFxZTPwKZcgebI8=;
 b=ge0TMWmJ+JFrHTVFRNJPbpFovZ6qia4y6zXUlKy+NRIyBkegSrGio8RGLn0O1tSQZytcj7Cw7STVvO2j7BNwA1CM3pJhp/CDZdqLo7dHHJTtIxoiQY3urGNm5r/RbWv7nWY4GSluHpRWOceLERu1G+P0lBxlkt/JIq6rie+a1Ahcg50jfgFx0ebsygYLp9Ep30ERtCEwSWq2vkVUX5XZ8cs4dTwzGUid9qcyvv3aS66BvAdz3x/aAOmeSlKOQm1NlFNKAlZnGktoIWsI9oTO4cMCfGcLD4/EdrdNzx4VWP2ZGh05kpGbwEWVzwtLt1w8AqEUojeyANWbChOsX7h/4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1L1M4G5nIPqHbUlMt9hZ1Wilw+g3XFxZTPwKZcgebI8=;
 b=mIuXQ6VtnuYLtwach+wIGAx7or61N+ashMHAIAkS2g14aoSRap3yhIA+rFeJjrpmLOApcv/5Al8EcHkmYdrHVkygWoN85PZZ8FYmkPy259DLx8sX0mtYzCQo2x+RqSWEm56lZHWeeReXh7GRAnzb5r90eVdrJQE2QCcDS9MQ180=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 25 Nov
 2021 20:13:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 20:13:13 +0000
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
Subject: [PATCH v2 net-next 1/3] net: mdio: mscc-miim: convert to a regmap implementation
Date:   Thu, 25 Nov 2021 12:12:59 -0800
Message-Id: <20211125201301.3748513-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125201301.3748513-1-colin.foster@in-advantage.com>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR18CA0071.namprd18.prod.outlook.com
 (2603:10b6:300:39::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR18CA0071.namprd18.prod.outlook.com (2603:10b6:300:39::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 20:13:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e048c854-454a-4037-893d-08d9b05001e4
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:
X-Microsoft-Antispam-PRVS: <CO1PR10MB5521E0B1F6014F91016CB455A4629@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYtYzRcgBspooTkAZxrcql/bxcZ518PC8OeiN+GbSMb39YdGM6Nk6G2CnUbjRRIsO1vXpd/7SpFBp/n12zDP/hNqeRHg0YpGVmtXPzeOHLbe3dmuyfe3bEF7DnRZ/b9g2Hsxd5YZ+N+gs7IFL2FztE9ZZOhOcUMyeL+zdj5X9pPFAOAYTSWzIpTgVD9QOJrmqrXOcRjYUIqJaQAwNMKC2rsylaPVSy8Qzy0cBOqGnTIDuXz0JE9qimYq9unPCBGZy6QVEDQp49T3ex55QUsVM3M8XbYkPSe8oXJq4fPSF7GdrmXEnHjxEdA9vxK1Q+dEXGABJBPcScdJQzNJWpPDQPaIJGIcBTG1lTrIhs0QKJXis7IOTkCly/i+eRLk8xyd/BmWOz8Xg+3oDg3kPflWjN1K1egQNv6ksGCAHK8dKjr4pxf/kw6s14++r4VJhoe5lxG1EXz9aKPDvUZl9xPvM8bt3CXl5hToSJNFfTnu9O6UW3IKybp3Q7BMHSbjNVdocarf9FtoHiXpGcab4+AeY6DUU5PSaTIASx20BDnD517O0dSBvEpvDkZWETel+RpWDsjqQyO6k4zjjtYHWJXYz3Z0yTkwWW/Gg1UeBnvRtUxC6A6ih+kcsctp3oJbx5aYXOJQ/rxZ5pGvLZd0hn8kv1q6JUTNdx6xKNhNR+Z2lYU5NzaLGX8hU/rNo2kXRva+bgSNzNHI768Ri72jPnfvdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(376002)(346002)(8936002)(44832011)(5660300002)(6512007)(38100700002)(8676002)(508600001)(86362001)(6666004)(6486002)(7416002)(186003)(26005)(38350700002)(2906002)(36756003)(316002)(66946007)(6506007)(54906003)(4326008)(2616005)(1076003)(956004)(52116002)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bqj1ohqGGQzhKoWzGYcOfX9l2lS06RYsfQvVuxzTBQU4WNKtRS7qYRAv6A54?=
 =?us-ascii?Q?YyXno5dQ/2y+M1omLXWUv5J22mAzibeJpSLYFw9VcTlqcGgdoo7MBx8EaMbC?=
 =?us-ascii?Q?2tS+1ijgo7AzQ7jSL8fWiJUiiw51+gKDaj3Mg5zpsSNm5xRDEGwATmPIb/dV?=
 =?us-ascii?Q?daU9WDTl//xJEG8PQmojyev530ctuKL7TCFUqLvc475IPeVb68ctxKZXJ2P6?=
 =?us-ascii?Q?APx+qOGrY4jR7W7rV6UVbR+rEdz+T51jpXx5pfTpXKZTXg/E4HowHQ1I4H+8?=
 =?us-ascii?Q?6b9BVfbaJs8GzaFfEUHV3wxg3mRwsaKrzEs/cFZF8JkVDlcHNmuD6rOTIWYn?=
 =?us-ascii?Q?+LpTg0GCxGmh7ngtJRCXgLoDCHfJQuQqwHcVVNs+Y0zsUByK2JyolYZ4ZxLK?=
 =?us-ascii?Q?xoYZj3c2zT8PS0lJrlEH1k9TFlGMo+pnGo6+BRDIDDl5jcfY/mabnwHKre84?=
 =?us-ascii?Q?IXeutUSB4wwXskX0qrNSCZtEjUFFFfpWwfAs3T/erBIonGxcfsK4revesqqh?=
 =?us-ascii?Q?rXQPkWKUgQyvqp2wUCyYU3aTqINv5mCSkTtDDUMVTYsm+dgTj4raFZfNFbgI?=
 =?us-ascii?Q?/ZFL9yP6M1mT/1LKNmWz41ci8Qjry5fBrseAJowjNHNrl9/v3r6vZR3YpePv?=
 =?us-ascii?Q?R6S05DLWvz7e69XZj9zheqrO6WhB09qAqoQA99ZMlJ1EHCd+NXXeqUjO4KCa?=
 =?us-ascii?Q?ckdpSIEn0B3Kt2720hl//bB83VOs3yx2wNwTwONdQ+bpnaVMy+o9ULegHHtM?=
 =?us-ascii?Q?BaAkK4EQYyLj15TunjT+zhegFrcWN8qTDZHMDQw+i9zIIulI2KnDiDTSgFP6?=
 =?us-ascii?Q?fhFshwPXqHhUj/tBahOFqLeGRj1mzRWwPqRgob1lL9vrfSe5S0m1kKI6ena8?=
 =?us-ascii?Q?Tk/269/AEgAOR2y6VKd4E2fzi0lbi6BQRAb5gaEtYFdfg3JuCQjf9RpJuZhJ?=
 =?us-ascii?Q?Gn4wAmP0uiuzht7qzpzweAg7/UNMKdd3Yk3EMdy0zF2HlybOHSdg5uQO53dt?=
 =?us-ascii?Q?nptXcotmp4QBaIWQpWO1niE3KZIfi+2rebwwud8QjQ58P1C9RZ7mvgZ+v0ZQ?=
 =?us-ascii?Q?tsN11udv8ew6I3b78J5lh0H4p24UmXvWwrT90iHahmCVCxx1Awka2A6PuftF?=
 =?us-ascii?Q?HOFYQKYxL7JQ81jXjXo60CQ0EQ5tpaWYJFleqn0kWmBfys3LPuLPi/g3m3a0?=
 =?us-ascii?Q?oPrFBVT6wxWWrL0ovXR0g5gS0xdklTrqe1w4GHdtqr9TTTTE0n7ZrsT+MPU4?=
 =?us-ascii?Q?5FjRfTIea1IAkfVT6vaRUBdfYj8FxJyLRdy0stWmexhjGjLhowPSAy5UoYdc?=
 =?us-ascii?Q?viGDYnRj1CXwhJu4WV38HbA8qpwBQq8SS584mHdAz6YVUt0ITUDziBG7IQk6?=
 =?us-ascii?Q?3Xhwk6kdvCOwjHGuN8DQpBeWyfjUQHJQ93gdVFcSEGWJviV5UT/JZOLioSAm?=
 =?us-ascii?Q?LMjKg/SVJVbPGYyMMCg7Nb+mb7ToIGWH4QAB6YUvKQ3e+QDrOUL4e7dR21EX?=
 =?us-ascii?Q?VhoY7Zp4J01Sh9qhX/ApCbMj0araSz6pZd9gwYz1DOKsWynbpOOjhxwDxMbp?=
 =?us-ascii?Q?ELUu801VaZLyK6Q92YOZGDUIQtG2byocy3gGbRG7LXNM79sZGRPyLXn31W0R?=
 =?us-ascii?Q?vfLib0vS5UyRchWcDDbb00V0D+IDzGTag2y/RMXPUGoqSwQbTFL+VdNxxMC8?=
 =?us-ascii?Q?HyLRGQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e048c854-454a-4037-893d-08d9b05001e4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 20:13:13.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeUoUZ79LmqMLV3+JiE3ehM8OqMpxofr9zl+truFS7H2/UM8HlC0E1DuH6/YH6w1ynmaoo9MXv2aIduG0MFDRQZi2HrQZBLwDkzmuyJjXEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize regmap instead of __iomem to perform indirect mdio access. This
will allow for custom regmaps to be used by way of the mscc_miim_setup
function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 161 ++++++++++++++++++++++--------
 1 file changed, 119 insertions(+), 42 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 17f98f609ec8..5a9c0b311bdb 100644
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
+			   struct regmap *mii_regmap, struct regmap *phy_regmap)
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
 
@@ -147,24 +190,58 @@ static int mscc_miim_probe(struct platform_device *pdev)
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
+	}
+
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
+	ret = mscc_miim_setup(&pdev->dev, &bus, mii_regmap, phy_regmap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
+		return ret;
 	}
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
-- 
2.25.1

