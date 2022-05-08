Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D286451EF84
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiEHTGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382571AbiEHS5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2132.outbound.protection.outlook.com [40.107.220.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941F3A1B1;
        Sun,  8 May 2022 11:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1YQLJ6pZN35n7v2dgvWd65H51qqoncXvtoqO0umVf9d2vmwFfW9CJQt0n4rbgQn34/wob8fGYFNitJ/xZY02CEZ1FOyakf8x3/wQuQIzSL795VN9KJprMvqH61JqHp3cx8sUK8qAKzYGXL5ylIDwXqW4vd+joI9cnFGPQG2xPVUPSJepSzpAFctcDmzeQdLWZ0iu52azamzvbPUALtPh+agXWvWe8QE7JMWWKCoxgz2nmvjhA/gRmAC1VMChDxZzngX8lHhgeWpgJnVf479wMlaO3amuY5uLspYBqndq0mC0Y/yPAZ/4x0wyMzRRUo7dPVMafFqahS0I95zp9Agkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QHQXE590QbF1LQgAOB974GEW0mJwFR11naEZuEi/Ig=;
 b=XONguAdF4DNj10vHjlfA2ATuZkwHs1Jm0DNq9bTxwkaQj3WVtQ54Cch6I8jmZG6PgrKuDpyMB0sRtjtjjN1iWMf3NtCO/UIRxoIxMKRki4j29O6B/YVZuiJxzyvMMi6cxL6uKIlgpQR60BD8aXxDeN3US7qQl/v8+VthSXSH5ZrwDMwWIZkyl10wUlfQxkOUHopz0c/J1aRs2rxGOR/CcKor9ljdDghfEYKaaLVC5pqDZTjV+KAkWXo1Au7ND7OoGsZZIVSoBZlb3YRQN6O8r2msYTBkqBqy4oqYJSUAzJY1MDtH1Lv/lhSwjFci1OxKwg5yFITpfgPUjFCXo1/v1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QHQXE590QbF1LQgAOB974GEW0mJwFR11naEZuEi/Ig=;
 b=uVtP3nLtvtQeIi5CK1DXmj+I7wPXEkatEVM9Pme1/uCmkrgGtsHMfV/lWZa1DKx8gf49KiwlJAowwZL/A+4eTC5nIPRiUR8hbjqH9Gx4m61la9UOY/4eKOUkJmKhfi8yW0UKrZx0BF1fRN1AgAyYygXg28R75JadnoU4LzAhr1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:54:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:54:01 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 14/16] net: dsa: ocelot: add external ocelot switch control
Date:   Sun,  8 May 2022 11:53:11 -0700
Message-Id: <20220508185313.2222956-15-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ab2cb7-cbef-4f9c-0b9c-08da31241d6e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672D30B471D1D0D5DB93A69A4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hl1TvUioJCz9cZrEKb8joM/B2xNYEWf4pqH8pk77mk5jm9GAS2D/VYc631/J7nzqkXo1wFoSX/pvuvF0LU63GX+GprsAp1K/i0H5FmyY1JKa6ZqZZSolQJGfng4HqXr3aPwIgZJO2RAKFkFKJbpRLzcgUnELEn9NpGG0EKjB9FK4SNHLDHytvOHC28pVPi7h6yjm2SuZcH2e6Lsq+RvaQE2t1fCXUGI22TLeJwv3T9ub+xse2VPZYQrSZW8S3AYjJ4GEz5mIC2P/NwZIETSt5rZ/541duIS8PN668nMfkBOzPqIPkG28oeCPsP2vYNxnXGNm0DRfYiLz881zzAmP97SZkn+EMxljDxLZ5L5LxPS4v65/2AKOlIWnoQIrdr+FMusn4p4G18JTvpeorzHxYDm8aRdXw5mr3f6qD6FfFy3L/5BXMEbCzcnLoptTs6OkiiIfVOOjZo8p22jcULhmmre4vx7yGX94eZqr/ZwvR9OOH4Eb6OCYzXJZ9H72uG5Ew8nQALJmXGlKKzBFq4j2bSFjCBBdXmErttLUQE3wDvZiSgoufZseOw2p3IvGsE1hSwBsjtuDYw3KlaP/7wka98Y9GhhIxcqKM+k21QfwPEvq5SnNLwIEMl/nzJZ2iMfGC4y9LEZD3RJeka7hW9Pjrwr5uVjCLScpJH2DZEfIHuab7BxmQeJ47tz+IcdrQdOvC3HxD8cEwP4aL2907A7kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(30864003)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0D0Z79gvdlYPLu++e8Z2E3kfFLjbf0vajN5qz/zcIrjrWUWCFIvS8qKuvALJ?=
 =?us-ascii?Q?loHSTWuv2Hf6MPchH8/9BsivU7QhbouDTCw53RAbfqxyH3RppJrHHog6h7JQ?=
 =?us-ascii?Q?I6vMMeQevx1zxu7r+PBwwah9+joCp33s3EB0sEoxpGVcjO0RVDiIijwBRbi7?=
 =?us-ascii?Q?YHTDhXEkZ0L3AlswjdeQIFj/VfZLQcCFALqFuMkIOaIfEPRpI3N8SpjzQ5fg?=
 =?us-ascii?Q?JTHW5UOAn8504+aNvoFbs8WN34XMIwkQLxXYF2shBhYTf/y57tC3H77FWNiG?=
 =?us-ascii?Q?wOAmPnAyNM6uPu4wvVTT6/LP7z16ekZRFVJ25DiM3TdsP1V/JETBnao17KDq?=
 =?us-ascii?Q?ZBH+e7hHAlxcoIaC/lI1EWVXuTwO2P80Vdszeb5nXgEg6SXN/WkqIKWWjw+K?=
 =?us-ascii?Q?1O5uRzLRItfR0MEN22H1bWgakaOBs/g88uhHSnxqcaLUKuhjk1Sms3LLnfsz?=
 =?us-ascii?Q?95afUS74W/FnlvlIILKctahfPzuve5/mjDtbOF60WrnkIcWfqAC2vTUD6Yqm?=
 =?us-ascii?Q?skZs/hnP5uhyqnJagxcjevKHfsXI8lI3EtpEJyr3VOZKp3HlKUsBUk5unezM?=
 =?us-ascii?Q?uVXY8YXVW2vfPdtKF/bm4BZiPwjxQNIfyxXobEklE/Ql7l6fCji6MI6+3guo?=
 =?us-ascii?Q?pzxgqSV6QRZ1szo+thzCzQ/qUCEUxnwj0K+Qlv/fDKJEX69gpd5Jz2VultL6?=
 =?us-ascii?Q?KbvYcY2hu2k3/0sR+uD/1a8nCP5zAlRkRicQ5kBY2EuoaE/Ej/QfvlZdQhUg?=
 =?us-ascii?Q?Rvpp5SjEH2AsslQ67MarGqZXULn7JVG1hrDIUnS7isYeH7j1QS3irx0HdAA/?=
 =?us-ascii?Q?fhgAtfcaHmsOvRS3VwnWxV9NgfPmPooufbo1cWuZ48tP3HMY1NCY+XkUlmil?=
 =?us-ascii?Q?tarTYr8Jk4t3MouRf7vREQP6FbEuTrhJl7hv1cYjFEZ9sAViM2749yfnthdx?=
 =?us-ascii?Q?1+n0sqV48ct8tYhVUSK2XRkTy62bUY7L8OoMqkaI86MjsYgezkHd9MyFm1Lb?=
 =?us-ascii?Q?P2GABdM1DVbwQXSllsvcE+N1CZ2MdNq0L7HGiqL+7wLFaZUBqu0M3fqjSByp?=
 =?us-ascii?Q?ri0pqBFOdBP1gFpyP1jBYyfjWFLvRjtbSfVaHrssM6uAN+2abOFoEtI51eQa?=
 =?us-ascii?Q?r2pZeg5iyO7Ynkb0iUc2mJGL064A+xS/9Ab9wBnhX0W7Lb4G6Pip67UgaNvA?=
 =?us-ascii?Q?xY3HvR7lpLnQLWeE14E8KnISlcanm/ll7VtwoB4dz1RmQcw+rqssdAtQKPaz?=
 =?us-ascii?Q?3KMoN+BEDtJo7vUo2MtXqQ/pyAxV7oIMmFPeIWM85iF0TZLnU+Nv22a3OZ4f?=
 =?us-ascii?Q?VYERq2Jkr0OTqxNIevT8DbpGGE5LyYk52+uU4HdbG0FDBX5w4WyX/GZXC8QB?=
 =?us-ascii?Q?bN8q/HvmcPs9JFdRQsbwxAMV16KvS5KBfg3EMUPKxJ1FZ5SXYf+TwfCGT13j?=
 =?us-ascii?Q?s8HL6UHDQmaI9zrUeQJ+FekbxQZTAUJO9n3KxY77CmwZeI5QNNgcRMkIGCd3?=
 =?us-ascii?Q?mDMW7R+aYnOQ3I0M5wVppD9qJA6QZiTTiyLmaZ/25lNRArHwsOIaCu62PQAy?=
 =?us-ascii?Q?X0v/rcBOiNkWvCQk1SalXg+M391aOXOecNDyFEzsk02sG7g2DCUkBgrk4RW3?=
 =?us-ascii?Q?tY+GCi9rvKH0BTTtZanuWDa2sRJ17qLTZvILPYAqHZaggY+f8AQHP2x4HiU9?=
 =?us-ascii?Q?EWqIkhRqzFeKGAk6tALK1lcsvZMDcK7Abjn0CC3MM0mBj3uD634MBGb6JXtR?=
 =?us-ascii?Q?O2RwlXqb6DQ0O+1JwpfEx9mCvj9+T8M92rWw2Ko1vFFarbCXjT+X?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ab2cb7-cbef-4f9c-0b9c-08da31241d6e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:54:01.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zCUPp3zce6s/FYHwduet0RIBlJTDGCmeh3xlSyIdPFztmlYPd42r3U7PNaFbPoi3jErlEX582aBDMjpDgkItRpbTk4Q5jZw37AAiWy5Wvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control of an external VSC7512 chip by way of the ocelot-mfd interface.

Currently the four copper phy ports are fully functional. Communication to
external phys is also functional, but the SGMII / QSGMII interfaces are
currently non-functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c           |   3 +
 drivers/net/dsa/ocelot/Kconfig      |  14 ++
 drivers/net/dsa/ocelot/Makefile     |   5 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 368 ++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h           |   2 +
 5 files changed, 392 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 117028f7d845..c582b409a9f3 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -112,6 +112,9 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.of_compatible = "mscc,ocelot-miim",
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-ext-switch",
+		.of_compatible = "mscc,vsc7512-ext-switch",
 	},
 };
 
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..f40b2c7171ad 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,18 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config NET_DSA_MSCC_OCELOT_EXT
+	tristate "Ocelot External Ethernet switch support"
+	depends on NET_DSA && SPI
+	depends on NET_VENDOR_MICROSEMI
+	select MDIO_MSCC_MIIM
+	select MFD_OCELOT_CORE
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
+	  when controlled through SPI. It can be used with the Microsemi dev
+	  boards and an external CPU or custom hardware.
+
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..d7f3f5a4461c 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) += mscc_ocelot_ext.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
 	felix_vsc9959.o
 
+mscc_ocelot_ext-objs := \
+	felix.o \
+	ocelot_ext.o
+
 mscc_seville-objs := \
 	felix.o \
 	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
new file mode 100644
index 000000000000..ba924f6b8d12
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "felix.h"
+
+#define VSC7512_NUM_PORTS		11
+
+static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+	OCELOT_PORT_MODE_SGMII,
+	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
+};
+
+static const u32 vsc7512_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,			0x0008),
+	REG(GCB_MIIM_MII_STATUS,		0x009c),
+	REG(GCB_PHY_PHY_CFG,			0x00f0),
+	REG(GCB_PHY_PHY_STAT,			0x00f4),
+};
+
+static const u32 *vsc7512_regmap[TARGET_MAX] = {
+	[ANA] = vsc7514_ana_regmap,
+	[QS] = vsc7514_qs_regmap,
+	[QSYS] = vsc7514_qsys_regmap,
+	[REW] = vsc7514_rew_regmap,
+	[SYS] = vsc7514_sys_regmap,
+	[S0] = vsc7514_vcap_regmap,
+	[S1] = vsc7514_vcap_regmap,
+	[S2] = vsc7514_vcap_regmap,
+	[PTP] = vsc7514_ptp_regmap,
+	[GCB] = vsc7512_gcb_regmap,
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
+};
+
+static void ocelot_ext_reset_phys(struct ocelot *ocelot)
+{
+	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
+	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
+	mdelay(500);
+}
+
+static int ocelot_ext_reset(struct ocelot *ocelot)
+{
+	int retries = 100;
+	int err, val;
+
+	ocelot_ext_reset_phys(ocelot);
+
+	/* Initialize chip memories */
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	/* MEM_INIT is a self-clearing bit. Wait for it to be clear (should be
+	 * 100us) before enabling the switch core
+	 */
+	do {
+		msleep(1);
+		err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+					&val);
+		if (err)
+			return err;
+	} while (val && --retries);
+
+	if (!retries)
+		return -ETIMEDOUT;
+
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+}
+
+static const struct ocelot_ops ocelot_ext_ops = {
+	.reset		= ocelot_ext_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+static const struct resource vsc7512_target_io_res[TARGET_MAX] = {
+	[ANA] = {
+		.start	= 0x71880000,
+		.end	= 0x7188ffff,
+		.name	= "ana",
+	},
+	[QS] = {
+		.start	= 0x71080000,
+		.end	= 0x710800ff,
+		.name	= "qs",
+	},
+	[QSYS] = {
+		.start	= 0x71800000,
+		.end	= 0x719fffff,
+		.name	= "qsys",
+	},
+	[REW] = {
+		.start	= 0x71030000,
+		.end	= 0x7103ffff,
+		.name	= "rew",
+	},
+	[SYS] = {
+		.start	= 0x71010000,
+		.end	= 0x7101ffff,
+		.name	= "sys",
+	},
+	[S0] = {
+		.start	= 0x71040000,
+		.end	= 0x710403ff,
+		.name	= "s0",
+	},
+	[S1] = {
+		.start	= 0x71050000,
+		.end	= 0x710503ff,
+		.name	= "s1",
+	},
+	[S2] = {
+		.start	= 0x71060000,
+		.end	= 0x710603ff,
+		.name	= "s2",
+	},
+	[GCB] =	{
+		.start	= 0x71070000,
+		.end	= 0x7107022b,
+		.name	= "devcpu_gcb",
+	},
+};
+
+static const struct resource vsc7512_port_io_res[] = {
+	{
+		.start	= 0x711e0000,
+		.end	= 0x711effff,
+		.name	= "port0",
+	},
+	{
+		.start	= 0x711f0000,
+		.end	= 0x711fffff,
+		.name	= "port1",
+	},
+	{
+		.start	= 0x71200000,
+		.end	= 0x7120ffff,
+		.name	= "port2",
+	},
+	{
+		.start	= 0x71210000,
+		.end	= 0x7121ffff,
+		.name	= "port3",
+	},
+	{
+		.start	= 0x71220000,
+		.end	= 0x7122ffff,
+		.name	= "port4",
+	},
+	{
+		.start	= 0x71230000,
+		.end	= 0x7123ffff,
+		.name	= "port5",
+	},
+	{
+		.start	= 0x71240000,
+		.end	= 0x7124ffff,
+		.name	= "port6",
+	},
+	{
+		.start	= 0x71250000,
+		.end	= 0x7125ffff,
+		.name	= "port7",
+	},
+	{
+		.start	= 0x71260000,
+		.end	= 0x7126ffff,
+		.name	= "port8",
+	},
+	{
+		.start	= 0x71270000,
+		.end	= 0x7127ffff,
+		.name	= "port9",
+	},
+	{
+		.start	= 0x71280000,
+		.end	= 0x7128ffff,
+		.name	= "port10",
+	},
+};
+
+static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
+					unsigned long *supported,
+					struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
+					     struct resource *res)
+{
+	return ocelot_init_regmap_from_resource(ocelot->dev, res);
+}
+
+static const struct felix_info vsc7512_info = {
+	.target_io_res			= vsc7512_target_io_res,
+	.port_io_res			= vsc7512_port_io_res,
+	.regfields			= vsc7514_regfields,
+	.map				= vsc7512_regmap,
+	.ops				= &ocelot_ext_ops,
+	.stats_layout			= vsc7514_stats_layout,
+	.vcap				= vsc7514_vcap_props,
+	.num_mact_rows			= 1024,
+	.num_ports			= VSC7512_NUM_PORTS,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.phylink_validate		= ocelot_ext_phylink_validate,
+	.port_modes			= vsc7512_port_modes,
+	.init_regmap			= ocelot_ext_regmap_init,
+};
+
+static int ocelot_ext_probe(struct platform_device *pdev)
+{
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	struct device *dev;
+	int err;
+
+	dev = &pdev->dev;
+
+	felix = kzalloc(sizeof(*felix), GFP_KERNEL);
+	if (!felix)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, felix);
+
+	ocelot = &felix->ocelot;
+	ocelot->dev = dev;
+
+	ocelot->num_flooding_pgids = 1;
+
+	felix->info = &vsc7512_info;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(dev, "Failed to allocate DSA switch\n");
+		goto err_free_felix;
+	}
+
+	ds->dev = dev;
+	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
+
+	ds->ops = &felix_switch_ops;
+	ds->priv = ocelot;
+	felix->ds = ds;
+	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
+
+	err = dsa_register_switch(ds);
+	if (err) {
+		dev_err(dev, "Failed to register DSA switch: %d\n", err);
+		goto err_free_ds;
+	}
+
+	return 0;
+
+err_free_ds:
+	kfree(ds);
+err_free_felix:
+	kfree(felix);
+	return err;
+}
+
+static int ocelot_ext_remove(struct platform_device *pdev)
+{
+	struct felix *felix = dev_get_drvdata(&pdev->dev);
+
+	if (!felix)
+		return 0;
+
+	dsa_unregister_switch(felix->ds);
+
+	kfree(felix->ds);
+	kfree(felix);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+
+	return 0;
+}
+
+static void ocelot_ext_shutdown(struct platform_device *pdev)
+{
+	struct felix *felix = dev_get_drvdata(&pdev->dev);
+
+	if (!felix)
+		return;
+
+	dsa_switch_shutdown(felix->ds);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+}
+
+const struct of_device_id ocelot_ext_switch_of_match[] = {
+	{ .compatible = "mscc,vsc7512-ext-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
+
+static struct platform_driver ocelot_ext_switch_driver = {
+	.driver = {
+		.name = "ocelot-ext-switch",
+		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
+	},
+	.probe = ocelot_ext_probe,
+	.remove = ocelot_ext_remove,
+	.shutdown = ocelot_ext_shutdown,
+};
+module_platform_driver(ocelot_ext_switch_driver);
+
+MODULE_DESCRIPTION("External Ocelot Switch driver");
+MODULE_LICENSE("GPL");
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 61888453f913..ade84e86741e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -402,6 +402,8 @@ enum ocelot_reg {
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
+	GCB_PHY_PHY_STAT,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
-- 
2.25.1

