Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C13452ABD
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhKPG3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:29:30 -0500
Received: from mail-bn8nam12on2139.outbound.protection.outlook.com ([40.107.237.139]:56205
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230494AbhKPG1X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYT6WS4YEjVq96tuPGaopmojoS/57L1zWFz580BhayDnBRl07ur1vw+09ySv1PXJMB0wmECs0whQAkDHGu7MLs76kNFEKpykQ3wWupZ8yWFEBTXXMVIfdqWAkES8Epv1TIGejfUOAQS8K429fu6w2QJbl6HIETKfn2NNIcKfPEq73g+5Cf5KSc9yyc+Sfz9aKx/33PG3yYkzwlr4yvD/elKVDlSukYj6HajFCeofvCAP7/qT221FSiUUPgOqVV6JJWJTpL0co++rl7WZZ382b5/5dGnlhJ6p7A8S6qbU7LVN0U+VnBOAxyKXCgDDblhp6xZHrKnRFql/r6poc2W3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7kVV2LG/xneCByGCObMQud37SonZcka1fqbBAvx1zA=;
 b=OXv8gz7el/umvEAdXeezDpJd/4e/bNMY9C2Z4y5ak8Fq3RSdTJg3nGXdyBJ2uGzpgRgicHYIBoDQnJXV0OkWy7VFniyzgq7I6L5exmapSoglI+Ccc4lCwgxqh2gfe2ADeX1c/Wfwgam5LG5aUSFMtsTPVUpkL417KjmypPeRRc7gch+NpQHDxn9unCgUQ2WFurhrEvty/1Ik6A3mwFBe6Z2pKX6E11NZ9cYixpuVE01jUCktOVUxvUFfuaC8odbVJ0nBajRwCe/uiC3uM7srJDjR6nr5pitnW22fTeJTAnHlGFmLHsyh9bWR/qT6Dx9ijL9LET1diYlAI6PitSUAZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7kVV2LG/xneCByGCObMQud37SonZcka1fqbBAvx1zA=;
 b=AxOe7ghplT3n3syZFecafcwCqyUaDnF6+/F5XF60iAAL438G0UK9MabveNxGgnvFN/ucu0pcFig1I6ySNucy6uUqpeKYq6EdtO9Nf4J/2H8MyBfAw5JMWUcNAX3hodLM0zjLxDQom6ZIVoufqZlleLM7GTYsAifKSly18m6MSc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:45 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:45 +0000
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
Subject: [RFC PATCH v4 net-next 04/23] net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect mdio access
Date:   Mon, 15 Nov 2021 22:23:09 -0800
Message-Id: <20211116062328.1949151-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76ed7102-07af-4390-f90f-08d9a8c9a47b
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23836B06EBE8844582A8D6BFA4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BoyrbIRaEFF7RDIsaqWGdcyOpp0y+E9jxuF7ZLJMrD9GW3qGMc+Ib6gICnvr9a9Tr7FdihnAI1hv8ZbWv+8WZ2Gg9JNC8Ku3+kuJqXJabZWEkhhV0Knnn9rASPb1V+F+ncU/ksw2JneCiKmJj+lxD2l/h0d05YBJGs8e8BVg3eA5gYzqzVYBFOzhYsPh1MBF8SqjoQN7X+xuGu9juvDc/hUJAhgazAVZ6h2PFtP8t2nuZgKDYSmdJxpQ1R0IvBIHtWGsVwMfWv8zMqxMpEeT9U02ub+s4wjWhtEMzZU5L0ek66AsMXBHdBeyKsYbJ0xzrj/9ZR+1Kkjqx/tRFed+P9QbZTqiuBI6yaRYbwFUbjtYpAIPigqag1/izlvF1jCtaNzpPNoOaALIJAlZExM5rC54SIczU5v6wqiNoN2tJPQzAX5UmitvNpr1/aAQm+2V7TlFnHAPyTjNOq0VgtWaJO9jjYlmYbkGs0cW1c4WNiK73IUcGPTBqDPxXsWTcKQfmOLpS0LOlDZg7yltcCRWy+mx1Pqetne89wy4BRunfPXJd2u5DQGfoDPs29KV3pSb/JqZf2SPRI2GTAi5rb/quUT0JkLceCuB9Q428l0E5bpX9NpAuuB8yoE93QwRxvy27c2IlRDriqdmGKF6mh/w1vXV+zcYWASPAQiZ8bnK2qnAtHj3JqpRqlsBKyuoEjHDydrQdQwFlNUJW5Do1wzfcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(30864003)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3W1DliZ6TOpeIWxCvMd+RX3n8BqoGjYuTxK1oT0qRf+xjec6xIfuwp+lTMQa?=
 =?us-ascii?Q?NmIf7QcgPBi42Xw47PJxCslbZiV9/oP9vGhlgSYMfSX3NTQkd9VKZPq9XsNp?=
 =?us-ascii?Q?7/qaGZfUjUhPhqHREUTLPIhc8C37yASo2O1nFQpGS52ZvCo5G5KLmEknzvTV?=
 =?us-ascii?Q?0hx+PTrXP2jijxGNXVp+4PcfXm4g1Cn/17sL2Olk7BxGRNAMMH5Xu4w67J3A?=
 =?us-ascii?Q?3Nw3SPI2gqrUU4byKF65XjJ8kmzer2KfAFEIcIdnfNZVnqLlkKtwgaEE/SDm?=
 =?us-ascii?Q?hgIgBPmV2zpnjWIpilW1dRnydw7CZ57CnGCjaoqnxBs+ZG15KnmaHmwodQRI?=
 =?us-ascii?Q?/PYYPdK0YcX72tHfNY9hYWbTVWQaZ9Ve+orqtvApAm1MQwTPWlcvfSFMCrB2?=
 =?us-ascii?Q?lBZgYk0EKYmeeBisJxyK6DtMZxBwO23v8VOd7TlCGUL0jvx2tqm0LKUkRulX?=
 =?us-ascii?Q?zk4tBPttxzlzAlpotuQ0fpczFxwJdShRr5ncSrfM07CP152552jB+t3DC4op?=
 =?us-ascii?Q?Dh55YAz6XRR5yKttAA3R7I7Qj0DX/v6OcilMuYE3Kmp2VkUYA4os5FF8F3dH?=
 =?us-ascii?Q?jkacXDNHJrP5qtAlRVNnllH+Xu9yU75EkzjwgWO2voPpaCBImW+SOQQErj5x?=
 =?us-ascii?Q?eGRm74XwbGkWWABRgZT4/Xm7OXVCnkOv6euFtSHC2sFdtESNVKh5lMCYm3Be?=
 =?us-ascii?Q?S3TKnGtjdYmD0Kyh2vicTk2CR+hr/XChDZ+WemDrFik1rOYzLVefLaZCDwSJ?=
 =?us-ascii?Q?gv1Okrr3Lt5MZWONXcvNnwVnb9lJcim0euC76miMKkVzzCEFUmKbtgmGH9bd?=
 =?us-ascii?Q?0LzWrq83kakEzxyEFPtODUGuawhBg9bh2BCRyFpTevqP2NO1eHqjw9AZ+tMB?=
 =?us-ascii?Q?o3oSjSC7WmXNE/9/fUdw02IvccztEkRH2Yonkk4D7+NKWE3cxGF36e+Oecwp?=
 =?us-ascii?Q?sB7sEpMMAwmvBztwhmXyKkzPLbbSzJl5nyKR43DyeUSrJiFbgcbrStdomMvG?=
 =?us-ascii?Q?ZvwzYeUw86d0y6gwyyu5o2Cj/IzvxujStVmlQBTHXEPQbImQUt7Yzp1dLEVs?=
 =?us-ascii?Q?HQXt1YnBc7MatQEUTNZf2s6Ne1+XiMEApSwe4FXmXEEsXf6cUWkTUviIAyVg?=
 =?us-ascii?Q?dzqWIrDTQFPhZxfGNrL0ondO10kww/PE2mU1OlPkjYjOmD/fqiQM/bJmDjlL?=
 =?us-ascii?Q?f5hQm2ZCYwPLAekF8O2GceoZupAxepoQssnk/Opc1wpfNYAo4ymBpMMiujNt?=
 =?us-ascii?Q?s/x9WzCN9vVs+4e/HCQ46ebE6AM9LHbwYD32YFrp0Ecb8+yNFMzvHcQLW7HB?=
 =?us-ascii?Q?UyHKU4QebioviqTO595hcS7XlSi2TF4SRbw2AFuNuhpvB8ynMSVy3GNMKIvl?=
 =?us-ascii?Q?1n3AZiFtGjH3LZFnUPz3gx4YSlPJJwWew4nQWt1HNGyWfo78sTJP2LGrb6d2?=
 =?us-ascii?Q?yxggx4TC7QplpJdU1UBLsmVT9funP2iZ6qrLYiS4vcB++FgXi0p0XPp0d+YP?=
 =?us-ascii?Q?MrqVhUr1OZxX+ndJXnbi+veaJ1XKlrhp3UYcRj2OEX9Hv0+tZbxV6/ay2lm/?=
 =?us-ascii?Q?0J4u27+ghTGj974lWn+wdcu73YQdoZ19YGCo3VIlgJGR5qyLk6LmdM7GaHza?=
 =?us-ascii?Q?XBG50NH/whQfWp5ERgiHzhpuUHJ7YgcxhcbPTLnru8vpUjixcj/mAx5V09kE?=
 =?us-ascii?Q?+g5h+xyR+RPteb50qeZg23pFsB8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ed7102-07af-4390-f90f-08d9a8c9a47b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:45.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcgQXgMjf36UofqQT6qtSNNl9K03cu1LqBKUNEfGZ0PeoFyEedqDcUXAA2kKdr7qlP18g5nazsNHa49Lja8hVoO5Tn93ZZavuyA9T9BD+tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to a shared MDIO access implementation now provided by
drivers/net/mdio/mdio-mscc-miim.c

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/Makefile          |   1 +
 drivers/net/dsa/ocelot/felix_mdio.c      |  54 ++++++++++++
 drivers/net/dsa/ocelot/felix_mdio.h      |  13 +++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 108 ++---------------------
 drivers/net/mdio/mdio-mscc-miim.c        |  37 +++++---
 include/linux/mdio/mdio-mscc-miim.h      |  19 ++++
 7 files changed, 123 insertions(+), 110 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 9948544ba1c4..220b0b027b55 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -21,6 +21,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	depends on PTP_1588_CLOCK_OPTIONAL
+	select MDIO_MSCC_MIIM
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..34b9b128efb8 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -8,4 +8,5 @@ mscc_felix-objs := \
 
 mscc_seville-objs := \
 	felix.o \
+	felix_mdio.o \
 	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/felix_mdio.c b/drivers/net/dsa/ocelot/felix_mdio.c
new file mode 100644
index 000000000000..34375285756b
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_mdio.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ * Copyright (C) 2021 Innovative Advantage
+ */
+#include <linux/of_mdio.h>
+#include <linux/types.h>
+#include <soc/mscc/ocelot.h>
+#include <linux/dsa/ocelot.h>
+#include <linux/mdio/mdio-mscc-miim.h>
+#include "felix.h"
+#include "felix_mdio.h"
+
+int felix_of_mdio_register(struct ocelot *ocelot, struct device_node *np)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	int rc;
+
+	/* Needed in order to initialize the bus mutex lock */
+	rc = of_mdiobus_register(felix->imdio, np);
+	if (rc < 0) {
+		dev_err(dev, "failed to register MDIO bus\n");
+		felix->imdio = NULL;
+	}
+
+	return rc;
+}
+
+int felix_mdio_bus_alloc(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	struct mii_bus *bus;
+	int err;
+
+	err = mscc_miim_setup(dev, &bus, ocelot->targets[GCB],
+			      ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			      ocelot->targets[GCB],
+			      ocelot->map[GCB][GCB_PHY_PHY_CFG & REG_MASK]);
+
+	if (!err)
+		felix->imdio = bus;
+
+	return err;
+}
+
+void felix_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->imdio)
+		mdiobus_unregister(felix->imdio);
+}
diff --git a/drivers/net/dsa/ocelot/felix_mdio.h b/drivers/net/dsa/ocelot/felix_mdio.h
new file mode 100644
index 000000000000..93286f598c3b
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_mdio.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Shared code for indirect MDIO access for Felix drivers
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ * Copyright (C) 2021 Innovative Advantage
+ */
+#include <linux/of.h>
+#include <linux/types.h>
+#include <soc/mscc/ocelot.h>
+
+int felix_mdio_bus_alloc(struct ocelot *ocelot);
+int felix_of_mdio_register(struct ocelot *ocelot, struct device_node *np);
+void felix_mdio_bus_free(struct ocelot *ocelot);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 84681642d237..610bdfd31903 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -11,13 +11,7 @@
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
 #include "felix.h"
-
-#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
-#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
-#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
-#define MSCC_MIIM_CMD_REGAD_SHIFT		20
-#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
-#define MSCC_MIIM_CMD_VLD			BIT(31)
+#include "felix_mdio.h"
 
 static const u32 vsc9953_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x00b500),
@@ -857,7 +851,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
 #define VSC9953_INIT_TIMEOUT			50000
 #define VSC9953_GCB_RST_SLEEP			100
 #define VSC9953_SYS_RAMINIT_SLEEP		80
-#define VCS9953_MII_TIMEOUT			10000
 
 static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
 {
@@ -877,82 +870,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot *ocelot)
 	return val;
 }
 
-static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
-{
-	int val;
-
-	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
-
-	return val;
-}
-
-static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
-{
-	int val;
-
-	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
-
-	return val;
-}
-
-static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
-			      u16 value)
-{
-	struct ocelot *ocelot = bus->priv;
-	int err, cmd, val;
-
-	/* Wait while MIIM controller becomes idle */
-	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
-		goto out;
-	}
-
-	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
-	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
-	      MSCC_MIIM_CMD_OPR_WRITE;
-
-	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
-
-out:
-	return err;
-}
-
-static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
-{
-	struct ocelot *ocelot = bus->priv;
-	int err, cmd, val;
-
-	/* Wait until MIIM controller becomes idle */
-	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
-		goto out;
-	}
-
-	/* Write the MIIM COMMAND register */
-	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
-	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
-
-	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
-
-	/* Wait while read operation via the MIIM controller is in progress */
-	err = readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
-				 val, !val, 10, VCS9953_MII_TIMEOUT);
-	if (err) {
-		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
-		goto out;
-	}
-
-	val = ocelot_read(ocelot, GCB_MIIM_MII_DATA);
-
-	err = val & 0xFFFF;
-out:
-	return err;
-}
 
 /* CORE_ENA is in SYS:SYSTEM:RESET_CFG
  * MEM_INIT is in SYS:SYSTEM:RESET_CFG
@@ -1084,7 +1001,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct device *dev = ocelot->dev;
-	struct mii_bus *bus;
 	int port;
 	int rc;
 
@@ -1096,26 +1012,18 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
-	bus = devm_mdiobus_alloc(dev);
-	if (!bus)
-		return -ENOMEM;
-
-	bus->name = "VSC9953 internal MDIO bus";
-	bus->read = vsc9953_mdio_read;
-	bus->write = vsc9953_mdio_write;
-	bus->parent = dev;
-	bus->priv = ocelot;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+	rc = felix_mdio_bus_alloc(ocelot);
+	if (rc < 0) {
+		dev_err(dev, "failed to allocate MDIO bus\n");
+		return rc;
+	}
 
-	/* Needed in order to initialize the bus mutex lock */
-	rc = of_mdiobus_register(bus, NULL);
+	rc = felix_of_mdio_register(ocelot, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
 	}
 
-	felix->imdio = bus;
-
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		int addr = port + 4;
@@ -1160,7 +1068,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 		mdio_device_free(pcs->mdio);
 		lynx_pcs_destroy(pcs);
 	}
-	mdiobus_unregister(felix->imdio);
+	felix_mdio_bus_free(ocelot);
 }
 
 static const struct felix_info seville_info_vsc9953 = {
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index ea599b980bbf..cf3fa7a4459c 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -10,6 +10,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/mdio/mdio-mscc-miim.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
@@ -37,7 +38,9 @@
 
 struct mscc_miim_dev {
 	struct regmap *regs;
+	int mii_status_offset;
 	struct regmap *phy_regs;
+	int phy_reset_offset;
 };
 
 /* When high resolution timers aren't built-in: we can't use usleep_range() as
@@ -56,7 +59,8 @@ static int mscc_miim_status(struct mii_bus *bus)
 	struct mscc_miim_dev *miim = bus->priv;
 	int val, err;
 
-	err = regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
+	err = regmap_read(miim->regs,
+			  MSCC_MIIM_REG_STATUS + miim->mii_status_offset, &val);
 	if (err < 0)
 		WARN_ONCE(1, "mscc miim status read error %d\n", err);
 
@@ -91,7 +95,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+	err = regmap_write(miim->regs,
+			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
+			   MSCC_MIIM_CMD_VLD |
 			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
 			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
 			   MSCC_MIIM_CMD_OPR_READ);
@@ -103,7 +109,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret)
 		goto out;
 
-	err = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
+	err = regmap_read(miim->regs,
+			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);
 
 	if (err < 0)
 		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);
@@ -128,7 +135,9 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	if (ret < 0)
 		goto out;
 
-	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
+	err = regmap_write(miim->regs,
+			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
+			   MSCC_MIIM_CMD_VLD |
 			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
 			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
 			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
@@ -143,14 +152,17 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
+	int offset = miim->phy_reset_offset;
 	int err;
 
 	if (miim->phy_regs) {
-		err = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
+		err = regmap_write(miim->phy_regs,
+				   MSCC_PHY_REG_PHY_CFG + offset, 0);
 		if (err < 0)
 			WARN_ONCE(1, "mscc reset set error %d\n", err);
 
-		err = regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
+		err = regmap_write(miim->phy_regs,
+				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
 		if (err < 0)
 			WARN_ONCE(1, "mscc reset clear error %d\n", err);
 
@@ -166,12 +178,12 @@ static const struct regmap_config mscc_miim_regmap_config = {
 	.reg_stride	= 4,
 };
 
-static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
-			   struct regmap *mii_regmap, struct regmap *phy_regmap)
+int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int reset_offset)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
-	int ret;
 
 	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
@@ -187,10 +199,15 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
 	miim = bus->priv;
 
 	miim->regs = mii_regmap;
+	miim->mii_status_offset = status_offset;
 	miim->phy_regs = phy_regmap;
+	miim->phy_reset_offset = reset_offset;
+
+	*pbus = bus;
 
 	return 0;
 }
+EXPORT_SYMBOL(mscc_miim_setup);
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
@@ -227,7 +244,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->phy_regs);
 	}
 
-	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
+	mscc_miim_setup(&pdev->dev, &bus, mii_regmap, 0, phy_regmap, 0);
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
new file mode 100644
index 000000000000..3ceab7b6ffc1
--- /dev/null
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Driver for the MDIO interface of Microsemi network switches.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ * Copyright (C) 2021 Innovative Advantage
+ */
+#ifndef MDIO_MSCC_MIIM_H
+#define MDIO_MSCC_MIIM_H
+
+#include <linux/device.h>
+#include <linux/phy.h>
+#include <linux/regmap.h>
+
+int mscc_miim_setup(struct device *device, struct mii_bus **bus,
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int reset_offset);
+
+#endif
-- 
2.25.1

