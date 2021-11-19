Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89956457838
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 22:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhKSVmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 16:42:38 -0500
Received: from mail-sn1anam02on2114.outbound.protection.outlook.com ([40.107.96.114]:1767
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235655AbhKSVmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 16:42:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL/mHmbmMMb9OcMKJA12lPqrzU6VGds2nkEQwF0aweBkC8sQQRoRWhug4Os/l7pTspO+qS9TZNfDgtFqvsHRX6a0cZ0hEoFajarutV9s4tym8bFOEId9pMj4qlKp1y2t8wq+RodSNBGmg8aLx1v83vbRtVFqO9GMJs0krd4lPzkWYyQrSRo5g8ovfK26juFghXPy5c6DGk11M4q6wxRjaMYRVDy/wXe3MVvDetL/bRhhlX9zIw+EoO9EuYKrBBwlN5wKoB31LSF1+OYfl4ttumHZHuZqPxz2xaHguGpS1Rwt+lq2GBmr5hIwwv+/3NPseHBpmwu/GriLJ4uo59Pqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QxgCzLldC0Q5MQhnNS/IkIVLuCS+MwrDtaCIjnFtuo=;
 b=loeKiX4JXIXPSG18gtxPN3/UTPSj/zHguAJQR/Q3Z9sOsQRTUq8UX91whMWlP51VDbLzOJd4hiPwvDF519nP7+C4BKGJUfIYmduNyI1n9VmojRZR/dvSyyS+jXKzcV6Vfe6se2GIndJv7aguM59OumRFeqPC8qh0ueaowje5jjt23w0ogFnQHweSX7LsGKHc37ZR0OdPHe+7Hb07iJTVWbyaLm1D6Yxbl8b7N7622/E3u+SJv7oAPUUCXqjVvghuZxDlUgAixrpKRofN4nXQiDj+Jvfbfiq/DUtitTOCceCIlMT6M89BG6gin/Ye05uu2HmXGD7hBpcRXw5UfUSPnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QxgCzLldC0Q5MQhnNS/IkIVLuCS+MwrDtaCIjnFtuo=;
 b=VGrs9spvegS84UAoeL4AbWzLV6opW9ouCp/lQ7uwbkqthZfeG8kj1Mrm2u4GHLg60j0TBjJaGa50582z01Ftu9FG9hrkFIkDjtLFHIfba6JWpfJjBmpqsos6LZ0XE9Q4SNhbyvSsxMoBr20KvHhZsrgUmUSFZqZBK7itb+e2wLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2304.namprd10.prod.outlook.com
 (2603:10b6:301:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 21:39:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 21:39:30 +0000
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
Subject: [PATCH v1 net-next 3/3] net: dsa: ocelot: felix: switch to mdio-mscc-miim driver for indirect mdio access
Date:   Fri, 19 Nov 2021 13:39:18 -0800
Message-Id: <20211119213918.2707530-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119213918.2707530-1-colin.foster@in-advantage.com>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0376.namprd04.prod.outlook.com
 (2603:10b6:303:81::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0376.namprd04.prod.outlook.com (2603:10b6:303:81::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 21:39:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30b24986-4eec-48a4-7cfa-08d9aba51167
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2304:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB230430F99F3D359230FC2A20A49C9@MWHPR1001MB2304.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wmwkk2S2yAMUx29FET5GIbBg3wSBTYYlumz1t+88/ZSSnLJv6vwn/jBJffU35MU5wz7pDIjXZaft84ZwkLGBfuY38dNSMGEJbusXREL28zd1VBxHdV3M5IYDXUqCKs/tIIfmJuYhGIweWxIOH7nWw9pAkt3re/EOlVj8ivyziMr2WZivAEykZfm/SA420um9wDCUGAtvL1zmIUWLQ0AbdiZN473i87J+8WXNBerZqAoglMQSs0FooZMpR8y6iJG5KEflShKADd9rdmEZBN/kGc3wix57+gO8B4QaI3bfrbSYp3i2Ckk+II++NQVoFInit4m3MYq0UvOX/eL7VR+MzTJsVcy47uBUVWQx/W/eEudFBIxCWWU5JuY6j+u3J2wZ3egYElQ1//W1lxGOJqQEOISYnpMeCcfcOz/lfYkuXjoid9mN6KJvn3CtJbxBG22k2ze/uuzPALYA0/H75bX357UqNgkh2qZTTUWI3J3DpzufssDG4QcATaE7qXZgHU0B10I4FelBBzwETOtMHuqS1EQyoYEytEqCH1d5S0AgFftYHYI5i7v3+A1JngGFxgaPAIxUhkYvJSk5SvxIqzl07YBlBcKBVBnzZkSZnWzCmGizJ1GQDYlUH9bhGVDykK4657IChzHYVme3gB9jvzMz/kPx6tOxkE2S4KuEcJMGlGS2PbkM/GwemCLPhNEjGu/l5WtyuO5kHftaGwdO1SY4Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(366004)(346002)(136003)(376002)(6486002)(186003)(2616005)(956004)(26005)(38100700002)(7416002)(8676002)(6512007)(83380400001)(38350700002)(8936002)(54906003)(4326008)(6666004)(1076003)(6506007)(66946007)(66556008)(30864003)(66476007)(5660300002)(2906002)(36756003)(316002)(508600001)(86362001)(52116002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4BuWlC1hUtCnZD66RQLWvhvqaVgdytJwrMhgO8hMQPcMedEu4TsgRTEloxm7?=
 =?us-ascii?Q?CAB5rnDrtik575V1qNOSwYdd/bhGM4g3QSQj+qr57Ltc+djyFL0RQhGadwbR?=
 =?us-ascii?Q?nP1EVncvEOIEgPZf9lnFF6eIKn94pdjxuv2ZeRGFi6syl6/JQvycQWehtAdk?=
 =?us-ascii?Q?hv5KjfVu4oEw+2UKQNazKhp/U9KqVihoUckALEf9qStqOlhSRwKDGyXFaDDx?=
 =?us-ascii?Q?DVYBcI8IbouP/m0EW4tfpLPKkyjLrRwF8Yr/g0FeCB/TYlV45QTaGR9RR9Bh?=
 =?us-ascii?Q?q0wYAXUthgo11zZL5usXZMUYdYOU6mZmrqR7hC/g89WrDXJcCjTKnEZsJRcS?=
 =?us-ascii?Q?ju2sn0eKwSsBbwNDSZ6+hO4b16fc4fp3Z08mnSbR0/J3qKYM1yfqg3RcjcZ6?=
 =?us-ascii?Q?AtoJAjw5HjtznxstRzvc0q8jwo3A2xP9yOvAN3OsDIyRqgZRg5SQHzmlygkb?=
 =?us-ascii?Q?Oz3oP4trG+j4Xi9htIUNn9IMfHWJfGaRIi/covt1RyfG3XCgGc1bASjUUJO8?=
 =?us-ascii?Q?J76JoAPprOAJGNH+bW4hJXs7KXlYd+nEwL7JB7gVK692EtBPHJUWZiX0B4nT?=
 =?us-ascii?Q?QnXO3NxdYNd0tuZjFfYf7qzsUdX+rlof1uL/iFsgBRw1s3ExY0PLeH3n7/n/?=
 =?us-ascii?Q?WcjRQWn3YB9HawODPdCxD1yRATXNWa4CXp8Ig3KQSQ9s5aKJjuDxwz4i2gH+?=
 =?us-ascii?Q?Iw3ziIQ74tYC/APP04Ea9QVjNkVjEeXShgYQdNr9f3ycwdEX7UB1ON8djkU4?=
 =?us-ascii?Q?3apvQom/oI6Xtyu9RIbzycftzeB0iY/2o346cOjk0R2o5sHtdxrbxWNPehdw?=
 =?us-ascii?Q?SZJE+O8ZRP/QaKGQANuR1Cb+qk1T//GtgFGeQbEJ4GVLj5fzLAKB5o1wTwgo?=
 =?us-ascii?Q?EnFXaUzfcFCuQyJ0RlMROvlyFNZ6rPDxNNGDu5oWarWp35v7X2e2g3pxzesC?=
 =?us-ascii?Q?boblNI4BivAHQmWJcqC6j5nnHfOvN5DCa/6OT6BoIyD8pCtWIAkECTvi9B5C?=
 =?us-ascii?Q?03On8j8XbDqgzepm/N1/XuvjF3uaQo6sWeAgAxwKJS7g9rNd+2OfZ2KFYAtN?=
 =?us-ascii?Q?yZA/kCXRkpKBne4LYcA9XyFhUore5PQFBjvuJOGXDXwN5oFkKiKfpfMylP+7?=
 =?us-ascii?Q?TyMCZPb2svXwCd8LporvnW7vjFe49yzTerNQcxmBgnyoztcVGvLwLIn47W9u?=
 =?us-ascii?Q?UJF4OEv1zTco4UmS3zfP6kCLBMIGKMF58OeKcBMu9ESctIJG8GE5tY/DrZ9b?=
 =?us-ascii?Q?IbkLt2GvXHBlRUNCbKku3Gb28QRKo07j1yPw94MVvedKWtbq/YYCJIVRdmLE?=
 =?us-ascii?Q?b5222eEd0U1nH7y07p6/2j+Hmt8yN0hkVEYRFk1VHzHLASGuJlRyVK/ISbLi?=
 =?us-ascii?Q?h5Q4/xG9mDYIMfrTRdBiawxUR+1yimnFmkM4qTbAV1MEeU/SnHT9Kon7xpuR?=
 =?us-ascii?Q?MWN9MY2Hk3RHDsC1ltzlM7MnwkRWbzp4CHJoL4+/87owkKhzdUj+JVEheYjB?=
 =?us-ascii?Q?1TdSQ2Di+KxOXvQEO+8qilOjj4F9U5iurqoRmuhKjS+RqtYk+zJiwhsYsqww?=
 =?us-ascii?Q?q03P3QzNh1fOrM+RbnrvH2h+jyVbRfvJ6+vVcCr27uly1LlmGGreqVl49mcV?=
 =?us-ascii?Q?g0DIaPBSC549qgJZVuc9t0pCOJsekPGgLEKdcp0U2LkWR7niTIJhfvKc43eq?=
 =?us-ascii?Q?kqF5A3eU61w7RdRwQUaly+xRlSo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b24986-4eec-48a4-7cfa-08d9aba51167
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 21:39:30.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKFTgQz7bAOSVjMTCPMxvJZJnNabpz39u9pHPPgmbpkRWYgvj2RsWp4sUqxzom+EOCEZoBLTZdW4gSAXSxiMDK1zaJuz2zS7KsiU5PV+YWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2304
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
 drivers/net/mdio/mdio-mscc-miim.c        |  37 ++++++--
 include/linux/mdio/mdio-mscc-miim.h      |  19 ++++
 include/soc/mscc/ocelot.h                |   1 +
 8 files changed, 125 insertions(+), 109 deletions(-)
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
index db124922c374..dd7ae6a1d843 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -10,15 +10,9 @@
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
-#include <linux/of_mdio.h>
 #include "felix.h"
+#include "felix_mdio.h"
 
-#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
-#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
-#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
-#define MSCC_MIIM_CMD_REGAD_SHIFT		20
-#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
-#define MSCC_MIIM_CMD_VLD			BIT(31)
 #define VSC9953_VCAP_POLICER_BASE		11
 #define VSC9953_VCAP_POLICER_MAX		31
 #define VSC9953_VCAP_POLICER_BASE2		120
@@ -862,7 +856,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
 #define VSC9953_INIT_TIMEOUT			50000
 #define VSC9953_GCB_RST_SLEEP			100
 #define VSC9953_SYS_RAMINIT_SLEEP		80
-#define VCS9953_MII_TIMEOUT			10000
 
 static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
 {
@@ -882,82 +875,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot *ocelot)
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
@@ -1089,7 +1006,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct device *dev = ocelot->dev;
-	struct mii_bus *bus;
 	int port;
 	int rc;
 
@@ -1101,26 +1017,18 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
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
@@ -1165,7 +1073,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 		mdio_device_free(pcs->mdio);
 		lynx_pcs_destroy(pcs);
 	}
-	mdiobus_unregister(felix->imdio);
+	felix_mdio_bus_free(ocelot);
 }
 
 static const struct felix_info seville_info_vsc9953 = {
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index f55ad20c28d5..cf3fa7a4459c 100644
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
 
@@ -166,10 +178,12 @@ static const struct regmap_config mscc_miim_regmap_config = {
 	.reg_stride	= 4,
 };
 
-static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
-			   struct regmap *mii_regmap, struct regmap *phy_regmap)
+int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int reset_offset)
 {
 	struct mscc_miim_dev *miim;
+	struct mii_bus *bus;
 
 	bus = devm_mdiobus_alloc_size(dev, sizeof(*miim));
 	if (!bus)
@@ -185,10 +199,15 @@ static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
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
@@ -225,7 +244,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
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
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 89d17629efe5..9d6fe8ce9dd1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -398,6 +398,7 @@ enum ocelot_reg {
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
-- 
2.25.1

