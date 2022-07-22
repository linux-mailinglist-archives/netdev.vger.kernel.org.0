Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA01E57D947
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiGVEHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiGVEGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:38 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1636089AB7;
        Thu, 21 Jul 2022 21:06:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+3CR78DYz0pHFkEOX+/7DLo6nWg2ZO/YP2YTeBA7GPSCCVm0h/SI9H0c4KbWr6ZiK71XQGQboGtcfblwLVWLwOLsUanh/51IDLt/HnBA+wmYFnv8oPTGMZc4LVJg634pJ2E//trP20W13MJi285CuLKKtUpe3ItJ6BS60OquUMufV7IfXXTNPMCHee+gnEBbLyxSO69zWPVwv7xx4e67HOUWPt2ndzm9/9milB9ASU10bB41mHW6T+wNhyOapjtFKzIN/nYBMzdpUZV5yI2b+FxTHRPcYguspx8tmBWMteqVhcsxuImVZW4YT4mfgVBtUV1AFCi1ZqcJ5igoZOEUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHFrdn/M+g08yWr8+/MCy+3wU6jJGI82IlpyxopJ+sM=;
 b=YlGgmJsLkper2DKW57UsrcQVb4lOKS40xsSb13bBWopXqYXWX85fAerG/7qjuUvu6CoRXEHkALEAZwiINtbcG6WyFeEgVN6lAlmxJsF5OOBTPHee6loYvEFGaVk+ysnFNOjFYGgodzxaVjyEAtmX2GXygALjffvC/UdGuaxJuGVjJtXwK7v2sTUXT0AfL6bo+/3hDdxD4Fmu7qZ+Q4x5Hbb337AgNt3y7gjoIYcvnO7LHRdIr3awRn2XbT/TAeAYgOnwKDUe7A0e8yvX6M+ekYJqCFZdtRHZoqBS6LDUfB9FznkeYKvxFT2cJT1lTUqWA8zXPtF6f1XAkDcxaeXVpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHFrdn/M+g08yWr8+/MCy+3wU6jJGI82IlpyxopJ+sM=;
 b=pWLsjVzjUFSAFTgBTG2M2HVtB3Rp/S580kUswVftm0RogykQiICO7X5JcFiGmAsFTGihvfsBQObX5hRzHOksLNuYtPyqueGft+wCYTR1ANEhosiusj4hXhmwpp/PWyfXHrTlrhHNoZM7XIoIdCbNfHeZRqFWwF1DDQ5MFvhNi7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:32 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v14 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Thu, 21 Jul 2022 21:06:09 -0700
Message-Id: <20220722040609.91703-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722040609.91703-1-colin.foster@in-advantage.com>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e2c11b3-876f-466a-d5c3-08da6b978f31
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5jrsmK5jK3SM2jPK6IduOZZe/3JkNoemOV3mbF5HvUVMcWp46G5aY4gxUjtKU5zzTLlxKMjIbagUEhi5C/RvF38PuWdBtk0i4nCL+a8gm5Kxl/Cn6T/dlNcSauMPiKgT5mQBEK/0t4Yvs6B2UJdVwfOluThA+VIoU0RFBc7lPv5TL7EClmHsfTPgg7u+0YbaVueWO1M+DaUW+lOJob2Qa7MnHa84LOOm1mJvUhCkfa6w6HrNFhgrs1G523WnVgTX8Y3hLocbL+i3zz3TTE/vRdgA0g9k+1DqQZNb3mbkHhvl97Rx/Yi8IBAEJWx6WBMVi9FxwsKh086UXYpUD7BJPDJhP3SKoVsmeSpCHHtIPr+/NERrSGOvJnzg6AmV3tECHE1CWyJcHjAFQlmk9WUz4c2ZIJU83AubAAm2VpngirqIfMDEz2x3YG07XiTsJvkV4cWhPQZcD2g7dsllHb+3gwV1uno/5zYEcBvFCg81+T4eoDuMYQhfNybqqR6ACLeiy5VJaJHTYlGg2x1+eUYcUkm+5hilsN6haWAZ2BjC2zEsmJOmuwglrmoTr/MglNspBd2ZhF3IJCeFzw+19RzRvm3lNP/Gj3TUJ0t5sGtUHeNYZl8H8gRdWRbrpHt9UOR38EojunB7zBaJR/GHlPedng8wH9TOD1hfIEhcOdmL9/DLNa/vnG4/m2ueO3gZyJdFi1J34mJUIarw9rBu1zFt8w6cALOASnKIVG8l3oWk4BwvOj2SQ4nIuEEzoucoivk/GPS/FNkXgKw6XldMkv9qLHTr3HBmqkiFBTZRvgi6H8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(30864003)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?as7BbMdUYqKjIrFxWjK9W+qq0GoiRgtrgiG/3c81FElu/miDoiFFtf0tDY0U?=
 =?us-ascii?Q?VhurT0cQX8vx5E+r4a6HsNvi7CcunZXvuaoJbJCZVoC7nGuhsyF1DZ/one+j?=
 =?us-ascii?Q?P+iN8+HKlI0Zqyuokhu189CcSq7UONNfCiJNnxiNSoLvMpNOnBturZ18e40U?=
 =?us-ascii?Q?hwXeOtcfAWesBBiV4m/hiQP10CsMEwy0mtPaImp71vhONbuuCEEII/gRDWNi?=
 =?us-ascii?Q?A0uF6SnknLzAmvXlyIW3TGDivt9Z7bZFn28i6EAV7KJ9rCFkI8C4fbFCeA7k?=
 =?us-ascii?Q?7npiRTarsRu3Dtu1fAHNlTc62qoOzWbuNdnafL3VmO4GZ2jJPg2SCLz0YjVe?=
 =?us-ascii?Q?4D49Ze99g+Pw/qTeBbIPll3+uHxtldA9YD9Ejy8ybgZ8cwrh/UrMeoay2xU7?=
 =?us-ascii?Q?2ziQOz9OS5VViSmadxhB8jx7woj6NL1RzDp3a82flxFj6d3kHEl6PgGg3jnS?=
 =?us-ascii?Q?s4fRaZWXZjZKDbxBgmX0p5TRQASTLsKdRT2gBtXkIVr+0VhkeMaFY5a4OTI9?=
 =?us-ascii?Q?2Z6UZvUH78gD9FJOBdX3Fo+3WwbEFzoRTr760TrQ+324svn9UVxdHtcfDeFH?=
 =?us-ascii?Q?CSxj9/aCmTyyChPoro1TKTvemlqMGbyKuxHO7PEOZZJl+6A938aeKLTRwAg2?=
 =?us-ascii?Q?wIdGEKLOxoafnj/UMXiX42R5zcKfxSYUoUhFu9tKrDY4ilKXFmfVR8L/5P7O?=
 =?us-ascii?Q?HDl1ZpcuH8Z8l3QF3WAPXRIARtJGDwucjKEqN15XbXAoUu3icowl5ypkqs/Q?=
 =?us-ascii?Q?tD7H+lW0xXbllVVeurth8uWvtxGzSl+kUi/PXTe0qHkV3QHvMeaJGGlEL+gx?=
 =?us-ascii?Q?oKgz2OyJOPY44zaeMdZbZCAMq4zZNv3acy7aHnGpF8KYgefzBA/zpcFaSoFY?=
 =?us-ascii?Q?GijuDzqm2F2sOpzYfLjd0OJ4W0rEMmOgqn4zzh3MtUKRZ16YETXaDGgGYr8p?=
 =?us-ascii?Q?j4Gzw27omxyThpu2N7+nrditukL96Ai6QtYaX5uuYjPoEdfcnJc3pG522to6?=
 =?us-ascii?Q?W4GBYLOtAixouICsP9F2oazBnGXPKCqLgRN4n2f04s6uzayZ6Mqv0rgAWsCR?=
 =?us-ascii?Q?F9dZX9LgyVb+GV6kYXnsavx5eFLVuEWMBbXsM7E41ukPWWHaGZBt0TZokr+5?=
 =?us-ascii?Q?MqBo2YZc0hcLrXGFZOZeVjBIMak2c3DDmWi/Kqf6tIFWVytVTyLzGqsqcAKs?=
 =?us-ascii?Q?hSk23B631Q9hZL1es6FyfCRCbZz5BXSeCs/RX+cR/wHODf+FpTyD33OMge3W?=
 =?us-ascii?Q?KquuTgGywF80APii/FjNxXBu8ciJ28AmFwR5fwdODPBc6vEoANN5RaCzCneR?=
 =?us-ascii?Q?f279cLlL88WXWE4iu9jqRXLWJcFXgFXLon9q4etaxSl/gJiJV1eGxnXLvJFF?=
 =?us-ascii?Q?irXYW00J0Lr1aWy+Ic0v5u8+vBHZjKJI628E89eUaISE8yNd5fHBXEzkA/dA?=
 =?us-ascii?Q?ii6MOkpajQ476seeBZ6h5NZKxQc1ZpNAmUC7m3GoC/eZU0ujq463J7dyGz+6?=
 =?us-ascii?Q?izICE564TVCu4Wnt0ghVlANJMnCy9CvN9CLinG3csMl5DOT7uhqb3pMfiC62?=
 =?us-ascii?Q?oUVZpdieELka8MxAu5zRLNmpcDb2nFlQ5WBKZk0/Rhi6XV/rulzFGdJsSpHM?=
 =?us-ascii?Q?in5dLK/NoIsRCKvpm5q6UpU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2c11b3-876f-466a-d5c3-08da6b978f31
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:31.5019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeQ+i4Grr9fNAu+b2VYq+OaCw8kVExRashd+3a0smeH3EDUzlvwgTKIb3g60D+I3GTP1oSBFOKs6lv/3bGp7KfCUfjetOW61E32u6z3RwpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7512 is a networking chip that contains several peripherals. Many of
these peripherals are currently supported by the VSC7513 and VSC7514 chips,
but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
controlled externally.

Utilize the existing drivers by referencing the chip as an MFD. Add support
for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v14
    * Add Reviewed tag
    * Copyright ranges are now "2021-2022"
    * 100-char width applied instead of 80
    * Remove invalid dev_err_probe return
    * Remove "spi" and "dev" elements from ocelot_ddata struct.
    Since "dev" is available throughout, determine "ddata" and "spi" from
    there instead of keeping separate references.
    * Add header guard in drivers/mfd/ocelot.h
    * Document ocelot_ddata struct

---
 MAINTAINERS               |   1 +
 drivers/mfd/Kconfig       |  21 +++
 drivers/mfd/Makefile      |   3 +
 drivers/mfd/ocelot-core.c | 157 ++++++++++++++++++++
 drivers/mfd/ocelot-spi.c  | 304 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h      |  53 +++++++
 6 files changed, 539 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e798c42fa08..e3299677cd4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14471,6 +14471,7 @@ OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+F:	drivers/mfd/ocelot*
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59456f5545..0ef433d170dc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -962,6 +962,27 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	tristate "Microsemi Ocelot External Control Support"
+	depends on SPI_MASTER
+	select MFD_CORE
+	select REGMAP_SPI
+	help
+	  Ocelot is a family of networking chips that support multiple ethernet
+	  and fibre interfaces. In addition to networking, they contain several
+	  other functions, including pinctrl, MDIO, and communication with
+	  external chips. While some chips have an internal processor capable of
+	  running an OS, others don't. All chips can be controlled externally
+	  through different interfaces, including SPI, I2C, and PCIe.
+
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called ocelot-soc.
+
+	  If unsure, say N.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 858cacf659d6..0004b7e86220 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+ocelot-soc-objs			:= ocelot-core.o ocelot-spi.o
+obj-$(CONFIG_MFD_OCELOT)	+= ocelot-soc.o
+
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
 obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
 
diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
new file mode 100644
index 000000000000..579dcd590d9a
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Core driver for the Ocelot chip family.
+ *
+ * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
+ * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
+ * intended to be the bus-agnostic glue between, for example, the SPI bus and
+ * the child devices.
+ *
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ocelot.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+#include <soc/mscc/ocelot.h>
+
+#include "ocelot.h"
+
+#define REG_GCB_SOFT_RST		0x0008
+
+#define BIT_SOFT_CHIP_RST		BIT(0)
+
+#define VSC7512_MIIM0_RES_START		0x7107009c
+#define VSC7512_MIIM1_RES_START		0x710700c0
+#define VSC7512_MIIM_RES_SIZE		0x24
+
+#define VSC7512_PHY_RES_START		0x710700f0
+#define VSC7512_PHY_RES_SIZE		0x4
+
+#define VSC7512_GPIO_RES_START		0x71070034
+#define VSC7512_GPIO_RES_SIZE		0x6c
+
+#define VSC7512_SIO_CTRL_RES_START	0x710700f8
+#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+
+#define VSC7512_GCB_RST_SLEEP_US	100
+#define VSC7512_GCB_RST_TIMEOUT_US	100000
+
+static int ocelot_gcb_chip_rst_status(struct ocelot_ddata *ddata)
+{
+	int val, err;
+
+	err = regmap_read(ddata->gcb_regmap, REG_GCB_SOFT_RST, &val);
+	if (err)
+		return err;
+
+	return val;
+}
+
+int ocelot_chip_reset(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	int ret, val;
+
+	/*
+	 * Reset the entire chip here to put it into a completely known state.
+	 * Other drivers may want to reset their own subsystems. The register
+	 * self-clears, so one write is all that is needed and wait for it to
+	 * clear.
+	 */
+	ret = regmap_write(ddata->gcb_regmap, REG_GCB_SOFT_RST, BIT_SOFT_CHIP_RST);
+	if (ret)
+		return ret;
+
+	ret = readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
+				 VSC7512_GCB_RST_SLEEP_US, VSC7512_GCB_RST_TIMEOUT_US);
+	return ret;
+}
+EXPORT_SYMBOL_NS(ocelot_chip_reset, MFD_OCELOT);
+
+static const struct resource vsc7512_miim0_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM_RES_SIZE, "gcb_miim0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE, "gcb_phy"),
+};
+
+static const struct resource vsc7512_miim1_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM_RES_SIZE, "gcb_miim1"),
+};
+
+static const struct resource vsc7512_pinctrl_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE, "gcb_gpio"),
+};
+
+static const struct resource vsc7512_sgpio_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
+};
+
+static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "ocelot-pinctrl",
+		.of_compatible = "mscc,ocelot-pinctrl",
+		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
+		.resources = vsc7512_pinctrl_resources,
+	}, {
+		.name = "ocelot-sgpio",
+		.of_compatible = "mscc,ocelot-sgpio",
+		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
+		.resources = vsc7512_sgpio_resources,
+	}, {
+		.name = "ocelot-miim0",
+		.of_compatible = "mscc,ocelot-miim",
+		.of_reg = VSC7512_MIIM0_RES_START,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
+		.resources = vsc7512_miim0_resources,
+	}, {
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.of_reg = VSC7512_MIIM1_RES_START,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.resources = vsc7512_miim1_resources,
+	},
+};
+
+static void ocelot_core_try_add_regmap(struct device *dev,
+				       const struct resource *res)
+{
+	if (dev_get_regmap(dev, res->name))
+		return;
+
+	ocelot_spi_init_regmap(dev, res);
+}
+
+static void ocelot_core_try_add_regmaps(struct device *dev,
+					const struct mfd_cell *cell)
+{
+	int i;
+
+	for (i = 0; i < cell->num_resources; i++)
+		ocelot_core_try_add_regmap(dev, &cell->resources[i]);
+}
+
+int ocelot_core_init(struct device *dev)
+{
+	int i, ndevs;
+
+	ndevs = ARRAY_SIZE(vsc7512_devs);
+
+	for (i = 0; i < ndevs; i++)
+		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
+
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, ndevs, NULL, 0, NULL);
+}
+EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
+
+MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(MFD_OCELOT_SPI);
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..a08e596d1fa9
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * SPI core driver for the Ocelot chip family.
+ *
+ * This driver will handle everything necessary to allow for communication over
+ * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
+ * are to prepare the chip's SPI interface for a specific bus speed, and a host
+ * processor's endianness. This will create and distribute regmaps for any
+ * children.
+ *
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/ioport.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define REG_DEV_CPUORG_IF_CTRL		0x0000
+#define REG_DEV_CPUORG_IF_CFGSTAT	0x0004
+
+#define CFGSTAT_IF_NUM_VCORE		(0 << 24)
+#define CFGSTAT_IF_NUM_VRAP		(1 << 24)
+#define CFGSTAT_IF_NUM_SI		(2 << 24)
+#define CFGSTAT_IF_NUM_MIIM		(3 << 24)
+
+#define VSC7512_DEVCPU_ORG_RES_START	0x71000000
+#define VSC7512_DEVCPU_ORG_RES_SIZE	0x38
+
+#define VSC7512_CHIP_REGS_RES_START	0x71070000
+#define VSC7512_CHIP_REGS_RES_SIZE	0x14
+
+static const struct resource vsc7512_dev_cpuorg_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_DEVCPU_ORG_RES_START,
+			     VSC7512_DEVCPU_ORG_RES_SIZE,
+			     "devcpu_org");
+
+static const struct resource vsc7512_gcb_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_CHIP_REGS_RES_START,
+			     VSC7512_CHIP_REGS_RES_SIZE,
+			     "devcpu_gcb_chip_regs");
+
+static int ocelot_spi_initialize(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	u32 val, check;
+	int err;
+
+	val = OCELOT_SPI_BYTE_ORDER;
+
+	/*
+	 * The SPI address must be big-endian, but we want the payload to match
+	 * our CPU. These are two bits (0 and 1) but they're repeated such that
+	 * the write from any configuration will be valid. The four
+	 * configurations are:
+	 *
+	 * 0b00: little-endian, MSB first
+	 * |            111111   | 22221111 | 33222222 |
+	 * | 76543210 | 54321098 | 32109876 | 10987654 |
+	 *
+	 * 0b01: big-endian, MSB first
+	 * | 33222222 | 22221111 | 111111   |          |
+	 * | 10987654 | 32109876 | 54321098 | 76543210 |
+	 *
+	 * 0b10: little-endian, LSB first
+	 * |              111111 | 11112222 | 22222233 |
+	 * | 01234567 | 89012345 | 67890123 | 45678901 |
+	 *
+	 * 0b11: big-endian, LSB first
+	 * | 22222233 | 11112222 |   111111 |          |
+	 * | 45678901 | 67890123 | 89012345 | 01234567 |
+	 */
+	err = regmap_write(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CTRL, val);
+	if (err)
+		return err;
+
+	/*
+	 * Apply the number of padding bytes between a read request and the data
+	 * payload. Some registers have access times of up to 1us, so if the
+	 * first payload bit is shifted out too quickly, the read will fail.
+	 */
+	val = ddata->spi_padding_bytes;
+	err = regmap_write(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CFGSTAT, val);
+	if (err)
+		return err;
+
+	/*
+	 * After we write the interface configuration, read it back here. This
+	 * will verify several different things. The first is that the number of
+	 * padding bytes actually got written correctly. These are found in bits
+	 * 0:3.
+	 *
+	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
+	 * and will be set if the register access is too fast. This would be in
+	 * the condition that the number of padding bytes is insufficient for
+	 * the SPI bus frequency.
+	 *
+	 * The last check is for bits 31:24, which define the interface by which
+	 * the registers are being accessed. Since we're accessing them via the
+	 * serial interface, it must return IF_NUM_SI.
+	 */
+	check = val | CFGSTAT_IF_NUM_SI;
+
+	err = regmap_read(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CFGSTAT, &val);
+	if (err)
+		return err;
+
+	if (check != val)
+		return -ENODEV;
+
+	return 0;
+}
+
+static const struct regmap_config ocelot_spi_regmap_config = {
+	.reg_bits = 24,
+	.reg_stride = 4,
+	.reg_downshift = 2,
+	.val_bits = 32,
+
+	.write_flag_mask = 0x80,
+
+	.use_single_write = true,
+	.can_multi_write = false,
+
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
+static int ocelot_spi_regmap_bus_read(void *context, const void *reg, size_t reg_size,
+				      void *val, size_t val_size)
+{
+	struct spi_transfer tx, padding, rx;
+	struct device *dev = context;
+	struct ocelot_ddata *ddata;
+	struct spi_device *spi;
+	struct spi_message msg;
+
+	ddata = dev_get_drvdata(dev);
+	spi = to_spi_device(dev);
+
+	spi_message_init(&msg);
+
+	memset(&tx, 0, sizeof(tx));
+
+	tx.tx_buf = reg;
+	tx.len = reg_size;
+
+	spi_message_add_tail(&tx, &msg);
+
+	if (ddata->spi_padding_bytes) {
+		memset(&padding, 0, sizeof(padding));
+
+		padding.len = ddata->spi_padding_bytes;
+		padding.tx_buf = ddata->dummy_buf;
+		padding.dummy_data = 1;
+
+		spi_message_add_tail(&padding, &msg);
+	}
+
+	memset(&rx, 0, sizeof(rx));
+	rx.rx_buf = val;
+	rx.len = val_size;
+
+	spi_message_add_tail(&rx, &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ocelot_spi_regmap_bus_write(void *context, const void *data, size_t count)
+{
+	struct device *dev = context;
+	struct spi_device *spi;
+
+	spi = to_spi_device(dev);
+
+	return spi_write(spi, data, count);
+}
+
+static const struct regmap_bus ocelot_spi_regmap_bus = {
+	.write = ocelot_spi_regmap_bus_write,
+	.read = ocelot_spi_regmap_bus_read,
+};
+
+struct regmap *ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
+{
+	struct regmap_config regmap_config;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config, sizeof(regmap_config));
+
+	regmap_config.name = res->name;
+	regmap_config.max_register = res->end - res->start;
+	regmap_config.reg_base = res->start;
+
+	return devm_regmap_init(dev, &ocelot_spi_regmap_bus, dev, &regmap_config);
+}
+EXPORT_SYMBOL_NS(ocelot_spi_init_regmap, MFD_OCELOT_SPI);
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ocelot_ddata *ddata;
+	struct regmap *r;
+	int err;
+
+	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return -ENOMEM;
+
+	spi_set_drvdata(spi, ddata);
+
+	if (spi->max_speed_hz <= 500000) {
+		ddata->spi_padding_bytes = 0;
+	} else {
+		/*
+		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
+		 * Register access time is 1us, so we need to configure and send
+		 * out enough padding bytes between the read request and data
+		 * transmission that lasts at least 1 microsecond.
+		 */
+		ddata->spi_padding_bytes = 1 + (spi->max_speed_hz / 1000000 + 2) / 8;
+
+		ddata->dummy_buf = devm_kzalloc(dev, ddata->spi_padding_bytes, GFP_KERNEL);
+		if (!ddata->dummy_buf)
+			return -ENOMEM;
+	}
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0)
+		return dev_err_probe(&spi->dev, err, "Error performing SPI setup\n");
+
+	r = ocelot_spi_init_regmap(dev, &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->cpuorg_regmap = r;
+
+	r = ocelot_spi_init_regmap(dev, &vsc7512_gcb_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->gcb_regmap = r;
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * This must be done before calling init, and after a chip reset is
+	 * performed.
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error initializing SPI bus\n");
+
+	err = ocelot_chip_reset(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error resetting device\n");
+
+	/*
+	 * A chip reset will clear the SPI configuration, so it needs to be done
+	 * again before we can access any registers
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error initializing SPI bus after reset\n");
+
+	err = ocelot_core_init(dev);
+	if (err < 0)
+		return dev_err_probe(dev, err, "Error initializing Ocelot core\n");
+
+	return 0;
+}
+
+static const struct spi_device_id ocelot_spi_ids[] = {
+	{ "vsc7512", 0 },
+	{ }
+};
+
+static const struct of_device_id ocelot_spi_of_match[] = {
+	{ .compatible = "mscc,vsc7512" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
+
+static struct spi_driver ocelot_spi_driver = {
+	.driver = {
+		.name = "ocelot-soc",
+		.of_match_table = ocelot_spi_of_match,
+	},
+	.id_table = ocelot_spi_ids,
+	.probe = ocelot_spi_probe,
+};
+module_spi_driver(ocelot_spi_driver);
+
+MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_IMPORT_NS(MFD_OCELOT);
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
new file mode 100644
index 000000000000..71eb61dd91e2
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2021, 2022 Innovative Advantage Inc. */
+
+#ifndef _MFD_OCELOT_H
+#define _MFD_OCELOT_H
+
+#include <asm/byteorder.h>
+
+struct device;
+struct regmap;
+struct resource;
+
+/**
+ * struct ocelot_ddata - Private data for an external Ocelot chip
+ *
+ * @gcb_regmap:		General Configuration Block regmap. Used for
+ *			operations like chip reset.
+ *
+ * @cpuorg_regmap:	CPU Device Origin Block regmap. Used for operations
+ *			like SPI bus configuration.
+ *
+ * @spi_padding_bytes:	Number of padding bytes that must be thrown out before
+ *			read data gets returned. This is calculated during
+ *			initialization based on bus speed.
+ *
+ * @dummy_buf:		Zero-filled buffer of spi_padding_bytes size. The dummy
+ *			bytes that will be sent out between the address and
+ *			data of a SPI read operation.
+ */
+struct ocelot_ddata {
+	struct regmap *gcb_regmap;
+	struct regmap *cpuorg_regmap;
+	int spi_padding_bytes;
+	void *dummy_buf;
+};
+
+int ocelot_chip_reset(struct device *dev);
+int ocelot_core_init(struct device *dev);
+
+/* SPI-specific routines that won't be necessary for other interfaces */
+struct regmap *ocelot_spi_init_regmap(struct device *dev,
+				      const struct resource *res);
+
+#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
+#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
+
+#ifdef __LITTLE_ENDIAN
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
+#else
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
+#endif
+
+#endif
-- 
2.25.1

