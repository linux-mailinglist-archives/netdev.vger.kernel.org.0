Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC7128CF7A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387967AbgJMNtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:33 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:3086
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387906AbgJMNtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzS/rEsaN4KBgd965Lwyf4IY+0SXNy6rup1JVKTC0l62QoYhegpyMLTfDYe0wGlzF/OTu4yKaye7ss9RWkQpn+/CsfVLp4eMEFVLqzkIn+c2lm9tk//rOBXjoqa2PbztgUjtJ4S7V+GQEyKnhC1jos9ZIMLtCoPJyeqx7GG/weI+VthL7o3f3nyl5XtkmSJCM8aL+mRnesY3xo66g/sz3n2YBhDpKDdP7PN1Y1FK/wQ9l4BmV+0E/ayIx9SvtqbzNTbD7Tx+WojCTUo+gWGOBm+GwnzQr9yRloSBT2MfhAelz73ninak7ou9MCoi3Y+PEohdoYlIqRkBP+L63sQOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Szu1i6HFMlwPanglwSgM/I2ciG7lnJGuZnSmO0C6GA0=;
 b=J04rSUKHzolgOesQKLwFAkVFtuU3pL1nZHp2Y3E/sEuHOWFFIAPotLY0CuITKSnoEycv4HLhyw0aMiCrr/dMDkaIcO6ezKB9ofe6Z2FOEJDKmcu/cNWXwhn4oqhx6p3F0YVT7BKpj7pBj2H8aXHOTVl8dnz2DUHvUzFgxeDu8RhaOTf4Bir2wdaQAXYhylSVwIviivfou+qr1JtopQe3BAQt/fF4ZnC1t2YqFoj8MfuE+yw8n3U+IYY0JGZDeX+ZPz2SmYBTpdWcv5owcEm8RuVjoty2gSgOR6MJfDjzgWxTU9l0wd0eF5JM+Ew3cxIH4Ac9nWaGt3hGlJ+aFo2OOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Szu1i6HFMlwPanglwSgM/I2ciG7lnJGuZnSmO0C6GA0=;
 b=R8TdYshlRiplHvxQrtQgQFaq+SkHG3BL3kMSmvjCULddcQyDPiT5PHx3kQZN+DGgud3FYdV9t9sIP8bdge14B0QneDf76vtJrIHqPN6L8+HcK8nFLFTTS66BsDuo68p4druld12wQIMkF2SrFAXSIJFWVJiyak8uTEO02boCBLQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Tue, 13 Oct
 2020 13:49:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 09/10] net: mscc: ocelot: initialize watermarks to sane defaults
Date:   Tue, 13 Oct 2020 16:48:48 +0300
Message-Id: <20201013134849.395986-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8bf30e2-689e-445b-1d8d-08d86f7eca89
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863AAD19112F16A798AE728E0040@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2te3obUEgoVeDLiNZ+60tsJMHJLsArmnXhUkoPz3DlEGp1XPJATmRKjEfh0ppVma5rTs9nqrw6t9YNaYQlnQH54BdM5grrkFrMynp/sWV4jbF8mofYkn6C0J2O6KVRZrWY2rR9k5Ik6ii0aRLDF6B4VqZWRcbDdvpWaUlGu6MCA8P9PyMjthRAJd0URzLtdbFZqDGnrzamW06fovlO/kcynlQvVZKidKiDcB7mySK89WDdXSwhUuf8m37PIW+/ngpdRUUqAUdhXVQp5EbEjeaj9fSNVHu4hYBRtBEWxYzSaMTo7ErL141gdqfYbJs5eBJzGRxWl8wwjZSRwM1CwANNbLKhBEzGllxrcYf/7wPyzY65NVW3nj5vCoy7KWozjOtbUUEQz/B4GhhWiUtmYA9LlqmwOEtYJi2dj7Vv6QGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(5660300002)(30864003)(86362001)(186003)(4326008)(8676002)(16526019)(66556008)(36756003)(6506007)(8936002)(66946007)(66476007)(478600001)(1076003)(44832011)(956004)(69590400008)(2616005)(6916009)(6512007)(6486002)(2906002)(83380400001)(316002)(26005)(52116002)(6666004)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iiTtwN6whDL2wu3VZRxXTDGCagYkUgSO3GdAveFzVmdnC62uE4StDGAM2XLRDr7LEWuzeT4FJ2g6BLh0zp1sClG8Y5Q48HLcdAGqIvh30sJ8EG1t+AhT0B+YXE+BPuYyNIXnfAQqVxpdMQ6YhWHCQf4f8q8kgJKlj832C9w6FrVM3KnJ6Ew/Fupt5lPniGqD/JSl0wUoMFjoJySnYXRZ8Ka+d7LNU0PLmLvnYEZhsngz9oL0R0igUCTp3HPgzgVk/cnAe1q7JHxOGGCy0XrB0/TTOKAGTvtcVHvFAc3jAAko48aDLpgrX5VuNqdZpNZFffq2aiU5IP8xd9RihRmr3YDiMnye6xBaDOLgGOCEAbeG+ztFmkIlEc2kr+e0nL3/nb9Mava0q5yy0u0/TJrGVUq5oIBYNAEtykCgWidKGwa4mjoHrmHikIZwrvs2pv/onwOPl4haEbgqIDAPijTQTRcpOfnigQA5g/NoFBkghdzwfR8QN3UJAqg2/N0+VpvJUgbbD/ARTMRaHjOooNHZ6wc+V8LTMWZICh4N7pkxPLx5k3J72s3DPVzvvMEU5/lIMWuPehJxTMZGdn1FZxWmtwvZrDOGz1rHL7RGz7zeYXV6VnjNLp9J+5BGNO7qygqi3yMUT7l8E+WhizbDSdpb7w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bf30e2-689e-445b-1d8d-08d86f7eca89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:23.1618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yq1ifOSBkC63uZM2IqHbWfZhEbLVXGBAWVHw+awFIxzVHee2/vlquZ4A8nLcLwX4vznB/rSLyktijaD9HuAtAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is meant to be a gentle introduction into the world of watermarks
on ocelot. The code is placed in ocelot_devlink.c because it will be
integrated with devlink, even if it isn't right now.

My first step was intended to be to replicate the default configuration
of the congestion watermarks programatically, since they are now going
to be tuned by the user.

But after studying and understanding through trial and error how they
work, I now believe that the configuration used out of reset does not do
justice to the word "reservation", since the sum of all reservations
exceeds the total amount of resources (otherwise said, all reservations
cannot be fulfilled at the same time, which means that, contrary to the
reference manual, they don't guarantee anything).

As an example, here's a dump of the reservation watermarks for frame
buffers, for port 0 (for brevity, the ports 1-6 were omitted, but they
have the same configuration):

BUF_Q_RSRV_I(port 0, prio 0) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 1) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 2) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 3) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 4) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 5) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 6) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 7) = max 3000 bytes

Otherwise said, every port-tc has an ingress reservation of 3000 bytes,
and there are 7 ports in VSC9959 Felix (6 user ports and 1 CPU port).
Concentrating only on the ingress reservations, there are, in total,
8 [traffic classes] x 7 [ports] x 3000 [bytes] = 168,000 bytes of memory
reserved on ingress.
But, surprise, Felix only has 128 KB of packet buffer in total...
A similar thing happens with Seville, which has a larger packet buffer,
but also more ports, and the default configuration is also overcommitted.

This patch disables the (apparently) bogus reservations and moves all
resources to the shared area. This way, real reservations can be set up
by the user, using devlink-sb.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |   1 +
 drivers/net/ethernet/mscc/ocelot.h         |   1 +
 drivers/net/ethernet/mscc/ocelot_devlink.c | 442 +++++++++++++++++++++
 4 files changed, 446 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 58f94c3d80f9..346bba2730ad 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -6,7 +6,8 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_police.o \
 	ocelot_vcap.o \
 	ocelot_flower.o \
-	ocelot_ptp.o
+	ocelot_ptp.o \
+	ocelot_devlink.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
 mscc_ocelot-y := \
 	ocelot_vsc7514.o \
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index fc6fe5022719..3dbcf165f506 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1567,6 +1567,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
+	ocelot_watermark_init(ocelot);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 3fee5f565920..963e218ffcef 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -110,6 +110,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
 int ocelot_devlink_init(struct ocelot *ocelot);
 void ocelot_devlink_teardown(struct ocelot *ocelot);
+void ocelot_watermark_init(struct ocelot *ocelot);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
new file mode 100644
index 000000000000..c96309cde82d
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Copyright 2020 NXP Semiconductors
+ */
+#include <net/devlink.h>
+#include "ocelot.h"
+
+/* The queue system tracks four resource consumptions:
+ * Resource 0: Memory tracked per source port
+ * Resource 1: Frame references tracked per source port
+ * Resource 2: Memory tracked per destination port
+ * Resource 3: Frame references tracked per destination port
+ */
+#define OCELOT_RESOURCE_SZ		256
+#define OCELOT_NUM_RESOURCES		4
+
+#define BUF_xxxx_I			(0 * OCELOT_RESOURCE_SZ)
+#define REF_xxxx_I			(1 * OCELOT_RESOURCE_SZ)
+#define BUF_xxxx_E			(2 * OCELOT_RESOURCE_SZ)
+#define REF_xxxx_E			(3 * OCELOT_RESOURCE_SZ)
+
+/* For each resource type there are 4 types of watermarks:
+ * Q_RSRV: reservation per QoS class per port
+ * PRIO_SHR: sharing watermark per QoS class across all ports
+ * P_RSRV: reservation per port
+ * COL_SHR: sharing watermark per color (drop precedence) across all ports
+ */
+#define xxx_Q_RSRV_x			0
+#define xxx_PRIO_SHR_x			216
+#define xxx_P_RSRV_x			224
+#define xxx_COL_SHR_x			254
+
+/* Reservation Watermarks
+ * ----------------------
+ *
+ * For setting up the reserved areas, egress watermarks exist per port and per
+ * QoS class for both ingress and egress.
+ */
+
+/*  Amount of packet buffer
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_Q_RSRV_E
+ */
+#define BUF_Q_RSRV_E(port, prio) \
+	(BUF_xxxx_E + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of packet buffer
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_P_RSRV_E
+ */
+#define BUF_P_RSRV_E(port) \
+	(BUF_xxxx_E + xxx_P_RSRV_x + (port))
+
+/*  Amount of packet buffer
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_Q_RSRV_I
+ */
+#define BUF_Q_RSRV_I(port, prio) \
+	(BUF_xxxx_I + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of packet buffer
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_P_RSRV_I
+ */
+#define BUF_P_RSRV_I(port) \
+	(BUF_xxxx_I + xxx_P_RSRV_x + (port))
+
+/*  Amount of frame references
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_Q_RSRV_E
+ */
+#define REF_Q_RSRV_E(port, prio) \
+	(REF_xxxx_E + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of frame references
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_P_RSRV_E
+ */
+#define REF_P_RSRV_E(port) \
+	(REF_xxxx_E + xxx_P_RSRV_x + (port))
+
+/*  Amount of frame references
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_Q_RSRV_I
+ */
+#define REF_Q_RSRV_I(port, prio) \
+	(REF_xxxx_I + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of frame references
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_P_RSRV_I
+ */
+#define REF_P_RSRV_I(port) \
+	(REF_xxxx_I + xxx_P_RSRV_x + (port))
+
+/* Sharing Watermarks
+ * ------------------
+ *
+ * The shared memory area is shared between all ports.
+ */
+
+/* Amount of buffer
+ *  |   per QoS class
+ *  |   |    from the shared memory area
+ *  |   |    |  for egress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * BUF_PRIO_SHR_E
+ */
+#define BUF_PRIO_SHR_E(prio) \
+	(BUF_xxxx_E + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of buffer
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared memory area
+ *  |   |   |  for egress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * BUF_COL_SHR_E
+ */
+#define BUF_COL_SHR_E(dp) \
+	(BUF_xxxx_E + xxx_COL_SHR_x + (1 - (dp)))
+
+/* Amount of buffer
+ *  |   per QoS class
+ *  |   |    from the shared memory area
+ *  |   |    |  for ingress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * BUF_PRIO_SHR_I
+ */
+#define BUF_PRIO_SHR_I(prio) \
+	(BUF_xxxx_I + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of buffer
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared memory area
+ *  |   |   |  for ingress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * BUF_COL_SHR_I
+ */
+#define BUF_COL_SHR_I(dp) \
+	(BUF_xxxx_I + xxx_COL_SHR_x + (1 - (dp)))
+
+/* Amount of frame references
+ *  |   per QoS class
+ *  |   |    from the shared area
+ *  |   |    |  for egress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * REF_PRIO_SHR_E
+ */
+#define REF_PRIO_SHR_E(prio) \
+	(REF_xxxx_E + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of frame references
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared area
+ *  |   |   |  for egress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * REF_COL_SHR_E
+ */
+#define REF_COL_SHR_E(dp) \
+	(REF_xxxx_E + xxx_COL_SHR_x + (1 - (dp)))
+
+/* Amount of frame references
+ *  |   per QoS class
+ *  |   |    from the shared area
+ *  |   |    |  for ingress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * REF_PRIO_SHR_I
+ */
+#define REF_PRIO_SHR_I(prio) \
+	(REF_xxxx_I + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of frame references
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared area
+ *  |   |   |  for ingress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * REF_COL_SHR_I
+ */
+#define REF_COL_SHR_I(dp) \
+	(REF_xxxx_I + xxx_COL_SHR_x + (1 - (dp)))
+
+static u32 ocelot_wm_read(struct ocelot *ocelot, int index)
+{
+	int wm = ocelot_read_gix(ocelot, QSYS_RES_CFG, index);
+
+	return ocelot->ops->wm_dec(wm);
+}
+
+static void ocelot_wm_write(struct ocelot *ocelot, int index, u32 val)
+{
+	u32 wm = ocelot->ops->wm_enc(val);
+
+	ocelot_write_gix(ocelot, wm, QSYS_RES_CFG, index);
+}
+
+/* The hardware comes out of reset with strange defaults: the sum of all
+ * reservations for frame memory is larger than the total buffer size.
+ * One has to wonder how can the reservation watermarks still guarantee
+ * anything under congestion.
+ * Bring some sense into the hardware by changing the defaults to disable all
+ * reservations and rely only on the sharing watermark for frames with drop
+ * precedence 0. The user can still explicitly request reservations per port
+ * and per port-tc through devlink-sb.
+ */
+static void ocelot_disable_reservation_watermarks(struct ocelot *ocelot,
+						  int port)
+{
+	int prio;
+
+	for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+		ocelot_wm_write(ocelot, BUF_Q_RSRV_I(port, prio), 0);
+		ocelot_wm_write(ocelot, BUF_Q_RSRV_E(port, prio), 0);
+		ocelot_wm_write(ocelot, REF_Q_RSRV_I(port, prio), 0);
+		ocelot_wm_write(ocelot, REF_Q_RSRV_E(port, prio), 0);
+	}
+
+	ocelot_wm_write(ocelot, BUF_P_RSRV_I(port), 0);
+	ocelot_wm_write(ocelot, BUF_P_RSRV_E(port), 0);
+	ocelot_wm_write(ocelot, REF_P_RSRV_I(port), 0);
+	ocelot_wm_write(ocelot, REF_P_RSRV_E(port), 0);
+}
+
+/* We want the sharing watermarks to consume all nonreserved resources, for
+ * efficient resource utilization (a single traffic flow should be able to use
+ * up the entire buffer space and frame resources as long as there's no
+ * interference).
+ * The switch has 10 sharing watermarks per lookup: 8 per traffic class and 2
+ * per color (drop precedence).
+ * The trouble with configuring these sharing watermarks is that:
+ * (1) There's a risk that we overcommit the resources if we configure
+ *     (a) all 8 per-TC sharing watermarks to the max
+ *     (b) all 2 per-color sharing watermarks to the max
+ * (2) There's a risk that we undercommit the resources if we configure
+ *     (a) all 8 per-TC sharing watermarks to "max / 8"
+ *     (b) all 2 per-color sharing watermarks to "max / 2"
+ * So for Linux, let's just disable the sharing watermarks per traffic class
+ * (setting them to 0 will make them always exceeded), and rely only on the
+ * sharing watermark for drop priority 0. So frames with drop priority set to 1
+ * by QoS classification or policing will still be allowed, but only as long as
+ * the port and port-TC reservations are not exceeded.
+ */
+static void ocelot_disable_tc_sharing_watermarks(struct ocelot *ocelot)
+{
+	int prio;
+
+	for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+		ocelot_wm_write(ocelot, BUF_PRIO_SHR_I(prio), 0);
+		ocelot_wm_write(ocelot, BUF_PRIO_SHR_E(prio), 0);
+		ocelot_wm_write(ocelot, REF_PRIO_SHR_I(prio), 0);
+		ocelot_wm_write(ocelot, REF_PRIO_SHR_E(prio), 0);
+	}
+}
+
+static void ocelot_get_buf_rsrv(struct ocelot *ocelot, u32 *buf_rsrv_i,
+				u32 *buf_rsrv_e)
+{
+	int port, prio;
+
+	*buf_rsrv_i = 0;
+	*buf_rsrv_e = 0;
+
+	for (port = 0; port <= ocelot->num_phys_ports; port++) {
+		for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+			*buf_rsrv_i += ocelot_wm_read(ocelot,
+						      BUF_Q_RSRV_I(port, prio));
+			*buf_rsrv_e += ocelot_wm_read(ocelot,
+						      BUF_Q_RSRV_E(port, prio));
+		}
+
+		*buf_rsrv_i += ocelot_wm_read(ocelot, BUF_P_RSRV_I(port));
+		*buf_rsrv_e += ocelot_wm_read(ocelot, BUF_P_RSRV_E(port));
+	}
+
+	*buf_rsrv_i *= OCELOT_BUFFER_CELL_SZ;
+	*buf_rsrv_e *= OCELOT_BUFFER_CELL_SZ;
+}
+
+static void ocelot_get_ref_rsrv(struct ocelot *ocelot, u32 *ref_rsrv_i,
+				u32 *ref_rsrv_e)
+{
+	int port, prio;
+
+	*ref_rsrv_i = 0;
+	*ref_rsrv_e = 0;
+
+	for (port = 0; port <= ocelot->num_phys_ports; port++) {
+		for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+			*ref_rsrv_i += ocelot_wm_read(ocelot,
+						      REF_Q_RSRV_I(port, prio));
+			*ref_rsrv_e += ocelot_wm_read(ocelot,
+						      REF_Q_RSRV_E(port, prio));
+		}
+
+		*ref_rsrv_i += ocelot_wm_read(ocelot, REF_P_RSRV_I(port));
+		*ref_rsrv_e += ocelot_wm_read(ocelot, REF_P_RSRV_E(port));
+	}
+}
+
+/* Calculate all reservations, then set up the sharing watermark for DP=0 to
+ * consume the remaining resources up to the pool's configured size.
+ */
+static void ocelot_setup_sharing_watermarks(struct ocelot *ocelot)
+{
+	u32 buf_rsrv_i, buf_rsrv_e;
+	u32 ref_rsrv_i, ref_rsrv_e;
+	u32 buf_shr_i, buf_shr_e;
+	u32 ref_shr_i, ref_shr_e;
+
+	ocelot_get_buf_rsrv(ocelot, &buf_rsrv_i, &buf_rsrv_e);
+	ocelot_get_ref_rsrv(ocelot, &ref_rsrv_i, &ref_rsrv_e);
+
+	buf_shr_i = ocelot->packet_buffer_size - buf_rsrv_i;
+	buf_shr_e = ocelot->packet_buffer_size - buf_rsrv_e;
+	ref_shr_i = ocelot->num_frame_refs - ref_rsrv_i;
+	ref_shr_e = ocelot->num_frame_refs - ref_rsrv_e;
+
+	buf_shr_i /= OCELOT_BUFFER_CELL_SZ;
+	buf_shr_e /= OCELOT_BUFFER_CELL_SZ;
+
+	ocelot_wm_write(ocelot, BUF_COL_SHR_I(0), buf_shr_i);
+	ocelot_wm_write(ocelot, BUF_COL_SHR_E(0), buf_shr_e);
+	ocelot_wm_write(ocelot, REF_COL_SHR_E(0), ref_shr_e);
+	ocelot_wm_write(ocelot, REF_COL_SHR_I(0), ref_shr_i);
+	ocelot_wm_write(ocelot, BUF_COL_SHR_I(1), 0);
+	ocelot_wm_write(ocelot, BUF_COL_SHR_E(1), 0);
+	ocelot_wm_write(ocelot, REF_COL_SHR_E(1), 0);
+	ocelot_wm_write(ocelot, REF_COL_SHR_I(1), 0);
+}
+
+/* The hardware works like this:
+ *
+ *                         Frame forwarding decision taken
+ *                                       |
+ *                                       v
+ *       +--------------------+--------------------+--------------------+
+ *       |                    |                    |                    |
+ *       v                    v                    v                    v
+ * Ingress memory       Egress memory        Ingress frame        Egress frame
+ *     check                check           reference check      reference check
+ *       |                    |                    |                    |
+ *       v                    v                    v                    v
+ *  BUF_Q_RSRV_I   ok    BUF_Q_RSRV_E   ok    REF_Q_RSRV_I   ok     REF_Q_RSRV_E   ok
+ *(src port, prio) -+  (dst port, prio) -+  (src port, prio) -+   (dst port, prio) -+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          |         v          |         v          |         v           |
+ *  BUF_P_RSRV_I  ok|    BUF_P_RSRV_E  ok|    REF_P_RSRV_I  ok|    REF_P_RSRV_E   ok|
+ *   (src port) ----+     (dst port) ----+     (src port) ----+     (dst port) -----+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          |         v          |         v          |         v           |
+ * BUF_PRIO_SHR_I ok|   BUF_PRIO_SHR_E ok|   REF_PRIO_SHR_I ok|   REF_PRIO_SHR_E  ok|
+ *     (prio) ------+       (prio) ------+       (prio) ------+       (prio) -------+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          |         v          |         v          |         v           |
+ * BUF_COL_SHR_I  ok|   BUF_COL_SHR_E  ok|   REF_COL_SHR_I  ok|   REF_COL_SHR_E   ok|
+ *      (dp) -------+        (dp) -------+        (dp) -------+        (dp) --------+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          v         v          v         v          v         v           v
+ *      fail     success     fail     success     fail     success     fail      success
+ *       |          |         |          |         |          |         |           |
+ *       v          v         v          v         v          v         v           v
+ *       +-----+----+         +-----+----+         +-----+----+         +-----+-----+
+ *             |                    |                    |                    |
+ *             +-------> OR <-------+                    +-------> OR <-------+
+ *                        |                                        |
+ *                        v                                        v
+ *                        +----------------> AND <-----------------+
+ *                                            |
+ *                                            v
+ *                                    FIFO drop / accept
+ *
+ * We are modeling each of the 4 parallel lookups as a devlink-sb pool.
+ * At least one (ingress or egress) memory pool and one (ingress or egress)
+ * frame reference pool need to have resources for frame acceptance to succeed.
+ *
+ * The following watermarks are controlled explicitly through devlink-sb:
+ * BUF_Q_RSRV_I, BUF_Q_RSRV_E, REF_Q_RSRV_I, REF_Q_RSRV_E
+ * BUF_P_RSRV_I, BUF_P_RSRV_E, REF_P_RSRV_I, REF_P_RSRV_E
+ * The following watermarks are controlled implicitly through devlink-sb:
+ * BUF_COL_SHR_I, BUF_COL_SHR_E, REF_COL_SHR_I, REF_COL_SHR_E
+ * The following watermarks are unused and disabled:
+ * BUF_PRIO_SHR_I, BUF_PRIO_SHR_E, REF_PRIO_SHR_I, REF_PRIO_SHR_E
+ *
+ * This function overrides the hardware defaults with more sane ones (no
+ * reservations by default, let sharing use all resources) and disables the
+ * unused watermarks.
+ */
+void ocelot_watermark_init(struct ocelot *ocelot)
+{
+	int all_tcs = GENMASK(OCELOT_NUM_TC - 1, 0);
+	int port;
+
+	ocelot_write(ocelot, all_tcs, QSYS_RES_QOS_MODE);
+
+	for (port = 0; port <= ocelot->num_phys_ports; port++)
+		ocelot_disable_reservation_watermarks(ocelot, port);
+
+	ocelot_disable_tc_sharing_watermarks(ocelot);
+	ocelot_setup_sharing_watermarks(ocelot);
+}
-- 
2.25.1

