Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F6745783B
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhKSVmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 16:42:45 -0500
Received: from mail-sn1anam02on2114.outbound.protection.outlook.com ([40.107.96.114]:1767
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235704AbhKSVmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 16:42:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amjPuKd/2a3J/ywiwQ+vN095JUJfdnVL4f7q7TaZm/QIb2qdQY6b0F2CFco6oZ50/9jxIMlefd3a/a31x+vbk1UBQ4IeEAYXPtlwO16Q4JWQ/24yWiu0EqfLjWsjUL4hn1JwK2+5h17PRGxCE7Wvb+A3iLJa78DVgADwf0Gr87vE/xdnSlyrntcSJ1ymW+jOWulRKHs2hj6KMnQRFfi9ASKWNMlUG6zDexjKSJPhGMctQpX2BVpbNXICPxvClWJFIh0ZRJ5zwXFm9XXsM3ps70wQkkFAymecY3IGCzZXCcJt9+LXUOJuEpKA1zCRiQMsmPuzTMB3P4asC++r059YlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aX7gbRtxBLNM9u11Bjd9HdnZaWnRPhEQYcUB9i37Zig=;
 b=GSvn+RfH800xTC/aeOyiMj+/Xa46fIDn7Cwi9/dPojg+Q0USub9FIAUfu9nWwY6jtf7OFZh32FGtmZr/NMjsI+rXCnsrh1zytWZ/h6s8fpNN0t/MBYDWEWXdZRH07pqKl5YV4sx5A8hipApYQlJTT4bUONhXYiuJ1l2tgnktPQJGkUzYKp5VrVOQN5BGsBrcFbkdocmkq+yTA8vu/HGFhBn39QrEZaO1zGowb30gkOhkXCZYYm16jyIPYrCQZozszxqI3ATUWDa4EruFNRECFxtbhaoX6m7aTo3qqkzgcH8ZXDXPivYzoX6N13tFVXf/J5XH/1oQdCusMfXklprztA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aX7gbRtxBLNM9u11Bjd9HdnZaWnRPhEQYcUB9i37Zig=;
 b=SockgAYtwz+Oe8HzldD9yNVAfWSCrNjRIUOUACNT9HGJuSSoUMs6Jvhn9MhEXSMY18ul8pfchZAqDbfvwnqZW2+BChvotn/3P7s/qXrvuaDHJ0TWpkcY0dMPCHlv2vCQeoCdjBpXrus3fWWedcbHH7WF+fT/7puYulNNYwcrVnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2304.namprd10.prod.outlook.com
 (2603:10b6:301:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 21:39:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 21:39:29 +0000
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
Subject: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a regmap implementation
Date:   Fri, 19 Nov 2021 13:39:16 -0800
Message-Id: <20211119213918.2707530-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119213918.2707530-1-colin.foster@in-advantage.com>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0376.namprd04.prod.outlook.com
 (2603:10b6:303:81::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0376.namprd04.prod.outlook.com (2603:10b6:303:81::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 21:39:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbce439f-6e9d-4c06-2d59-08d9aba51085
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2304:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2304BD9D8D64A4EF7494C43AA49C9@MWHPR1001MB2304.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUY/MU9XK8+r41W5vj5JUyYt+qIHvoVIlyTrr68oqEcFocpw7sq1yXJAqED0rsL4xHpWVbT2uwkbIC2fPjWpIHe90xYqkbB17sfViOve+WyoLnmYi4fJpL2a8hGdgQvxe3gbN5b1XbgLqqwpA7IfJs3xBodS8iN1CQ5kYCkmV8Hx85Yrax6sFx4P20Ajwb+YB+51t5AMww0EWgZgXBNQSxjMkJ/4ABeegVJXJNMSkBvADddNwC2P9HgBWLXjCNbFRgHfHS/mo4KkN57HxhaLn1KV6Dl5VGfBUAbS7MMuCvD4d3+V+w1Vesz5bqJ5a/YViC9fJh05z9R2RUx5Swj1Xu5KT45LUwx4a8loo0HbTBfHHPX4lRTFYIGpUtVDIcpitA+SQ5HKKWbeFKDGw1LbP3u+lDRzsX6ZgMTDZp1Jm5ScH7nsc0BsjS3XSA7eTx4jPONSNynpK+GSpS9W6Q0C/0QV5nf9jIx530MPnOm13vtqzWy+uCK0xdUxJ7+tkIijDtFHbnGYslGtS4LMfjaA0kePr0dWeOhf2uhnOTlzuRoNUxtwA/uApOSOaf7I53lua/oKbS1tHgZwN5gwrWu9vFyktZsU7Ek2x+SzlCporqgLUiIs9tX6PU3lwpp3t2EaSFDIz8PwGbUJgToqhLq98WyjM7h1QjrOWZLFLFUjlJQdKyi5RfgPAM3lZb1DZgjp6s+sAZ4IlTpExnScZBYCFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(366004)(346002)(136003)(376002)(6486002)(186003)(2616005)(956004)(26005)(38100700002)(7416002)(8676002)(6512007)(83380400001)(38350700002)(8936002)(54906003)(4326008)(6666004)(1076003)(6506007)(66946007)(66556008)(66476007)(5660300002)(2906002)(36756003)(316002)(508600001)(86362001)(52116002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iGHrWRu7p8Cy88S8gI8YlZCg9nPgi2YRhbYDiwEWoIsWNU1y35jVT10ugCSX?=
 =?us-ascii?Q?tpruKp1TCZxVYWRRZxi/TBCobVtyQ2wwDvWP6E3ujrD09oCGnns0AY4ze5do?=
 =?us-ascii?Q?bcTyclI9a9ZtyqihPVy6mfZDGVPQuvaB1ybrTtvVgDQPSzY76wWmf8ph0Pen?=
 =?us-ascii?Q?+htEQ9mMP/9oolGkjvIPFrTnL9Nx14a1ya3hNxmQYxQzMqb+PAAdefWUV1tY?=
 =?us-ascii?Q?ByUcN72nW9tDOqIL5lD/gWkfTR61uY6XtAv9/9i64LLkCGGxxG7nwTtUQczL?=
 =?us-ascii?Q?0Mb57rjOXCX1F4TSENpOJZr+6+oOFN5UhFgXThkT0V710eOPovUAEtHvWavi?=
 =?us-ascii?Q?nAx2aJZHRH9kUgSIAqdK7ofc+CAJVme6Hf7VzVZEluR4gj79m6YDlqbq4WTe?=
 =?us-ascii?Q?3XMdVm0YYrGdwRrgFuhTIufWa/jgFIrnl5WC8a5XsnIiE1xLMvkN+kjymlH6?=
 =?us-ascii?Q?jbOBrQ8VNmy7byh7JMh/YgUd4JX1wSfKvRCGkwd8XQxzt35zYFPH0XJft+/x?=
 =?us-ascii?Q?Qh5VlHDZWEAsHu7DLiYgY5VHJou3M6UukBDsls+0qDcmTW6SKzXrOAeUPhJW?=
 =?us-ascii?Q?r+eiPisTY9P8TkQAxbXfR7usGklwFeu5uThagzUFOHYi95BQQLyRSbz5WP0a?=
 =?us-ascii?Q?NtSPvggh23BnaWks8fx8REGJg9LZrlzxY+/+NFQS0moe3sQ3JeRs8rtcs/cI?=
 =?us-ascii?Q?HpPkKaSRWe51wPcJbwlCHQz66g6fAtTjbpzPXVT+EZXx1ZIwCCqorWamWUOx?=
 =?us-ascii?Q?pvfhQOw0QdocSw7CEPI339emAInGZNyFJnIXUEw5IKl35n2dV+o82EUWYSyt?=
 =?us-ascii?Q?Wkgc/1EzJfnzOKc+8SOoTceB0IKNPfTwwlydWkc+agiRvsxZn89S11ZLDXiQ?=
 =?us-ascii?Q?TDWz4U4iVXnuXm4voYzLx9aqbDVWsz2XAhz6nuR3bbexVfyVe2Vz6HwfkSk8?=
 =?us-ascii?Q?ZmLRn6XT5qGRFO0rKvzqt58qSE7Vc2IoP8Cc0707IYuqqito8BasFRHVBMSa?=
 =?us-ascii?Q?K0TbJlXTnpeAGaEMAIe3SejKM6Gox2jK8ZQpyOoeqqgh6TJQAvCvVqGUEc9b?=
 =?us-ascii?Q?OZH/Ti8qHm330wf76EMJHUt7dD8Ga0Ryifyt34Ji1B+49z1CJTFyVIq7DW28?=
 =?us-ascii?Q?Vt2DDGl0vzG52KiWIdEO3INkhqIqnsgaIOn90vxQZ+1x5+5Jrbo9IUYJkYnA?=
 =?us-ascii?Q?u5Kd8fMtNeUJ5JFDE409/pmp55XUXrJgAdTWjWEbSOgjYaJJTO1mm6g80pTJ?=
 =?us-ascii?Q?Q4LB1HSzuL0R6Zx2x7q5cAuhqlA6Bq7Fd70t8t96GkuvqnnsTcyqm1T+lmU3?=
 =?us-ascii?Q?jP1oc3x4ezc7yyKz9YmUndbWYkWZAs0f0+QmfvhnoMJx1DO0WFKOY6TvstR1?=
 =?us-ascii?Q?eJnyLtoZ6b29Bbj2nOyjTIs9I6yj6zCWQfXlp00PR9f5aytQxy134L/PmEQF?=
 =?us-ascii?Q?lRL5GiI6mwPI107S1uE8enHi3oZnqq3P+xpAbjytrDMUgGPe2kw8s5AJZRQd?=
 =?us-ascii?Q?uaCsoBP2NjZfsF+5fmtjHbqqap9tTljIlu94Ipqb9d09WqwaR8ncPeuArDjq?=
 =?us-ascii?Q?sv2FKCOtk+KwVcVkSdf3zwXTLZre/TquOfUQ+6qCqq4aJn1/heg92qHvvAVS?=
 =?us-ascii?Q?fvfRaBVgWLY+Bzq9nMtsseXJO0AHTY+2Xxsz6Sh0qbq+I3bqKrZbzABAY2tl?=
 =?us-ascii?Q?l4Y4SA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbce439f-6e9d-4c06-2d59-08d9aba51085
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 21:39:28.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+LXypIO/rCDP2RW7hASXDYe2wJg0LOuXmQSaIuaUEq4Zww5NNggwEXi9CP4DDPcyairg3yP3YLoF1+1zau63cSAh6cY309IzPJort37Ysc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize regmap instead of __iomem to perform indirect mdio access. This
will allow for custom regmaps to be used by way of the mscc_miim_setup
function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 150 +++++++++++++++++++++---------
 1 file changed, 105 insertions(+), 45 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 17f98f609ec8..f55ad20c28d5 100644
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
@@ -122,24 +143,35 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
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
-	struct mii_bus *bus;
-	int ret;
+	struct mscc_miim_dev *miim;
 
-	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
 		return -ENOMEM;
 
@@ -147,26 +179,54 @@ static int mscc_miim_probe(struct platform_device *pdev)
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
 
-	dev = bus->priv;
-	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(dev->regs)) {
+static int mscc_miim_probe(struct platform_device *pdev)
+{
+	struct regmap *mii_regmap, *phy_regmap;
+	void __iomem *regs, *phy_regs;
+	struct mscc_miim_dev *dev;
+	struct mii_bus *bus;
+	int ret;
+
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

