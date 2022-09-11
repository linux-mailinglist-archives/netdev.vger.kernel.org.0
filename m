Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E975B510B
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIKUDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIKUD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB0627FF6;
        Sun, 11 Sep 2022 13:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnYOPUFighvhhn2vRXrcAC3XT/OArnfQtKQrT112DGjtoUSMN8r5UTTNvMgM+cXA1CvPfGDgPrI8fY0ZvNkCLiPyRql/OHaCJu/Rskv9gLI/k6udEeUE1P47re3vGeAmm8ULu3K3U6VzkA58JulELZMZ5+off7a5mKaTbFRWJHbij6zS6h81mrdZxyH1UfV0oQA3BU8NL3o2S9NFl2eFVtr612r0iC1N7HYybdBUmGPEoR7JbbR8/ArQAk+fQQ0Iit995LtZCMJebETSwBiIT7lAl6fZ/C5QevhDzwwWx5wYlFDyG5VzQ7n7sF2q/7BXLgwdwotyDWDlav39QbahAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1ejvkzCIE7FG4Jay3lKo7GnPZQe5dktKFz12kyRAPc=;
 b=c4q3F/T7PFsNJO1DuGwcwU9Zi5MnD1FEzqcl9OgiFcWpPaR/2iIwgY02hv7Yqm0w/9BukunpPkB6zzxgYX/SqO+T5MdjQomx3qZYXToXNxjv1pp7TdP6j1jgtLSPSBNZzhtPPFoDe7n+yw/wnrhmS5BRLhtkq7dVhACK01udfuYHyWemYkJIdfs9OGt64bl1LiSxtw6sH3Rl7opFYcXkkWsbG17rylgv1t80LqzR/NZA+tmpPJZtRNB614b8Ae8UrbqJ9WKMrNxts6QZGLu0m+60GuJBdupZ2lkOKGLD1NNeaNVHyG2IDttnFOjnc+nMsBcgrZwmPj97ahO9mrmiRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1ejvkzCIE7FG4Jay3lKo7GnPZQe5dktKFz12kyRAPc=;
 b=iN5Kas+JppsavaSPxp1MYLBbvK2OYV48IZ+X8zUfGToAt0vgLg60YZ1HxTWPI3fRMML88I5yBSW9ZOXloJnJIeqUZgRVY3gU0OFLq+r0qfo4vSrNeZgBetGLBG+FX6aHEZLbD6n/yweN2fOL/zCh4+zxgXX/xLELTypkt8MLA78=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:03:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:03:01 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
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
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot switch control
Date:   Sun, 11 Sep 2022 13:02:44 -0700
Message-Id: <20220911200244.549029-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 132b27d4-6048-4088-33c7-08da94309fa4
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4XtHKfdJexKCtb96tEuXMmON2cDAW3w30yNYAik1pRk5bxYss7STeG6ph1HtqulEz33K7TrdrYc282DAIMFvCn3t54Zf9Mrspt2FPasvaATMRHuH31bTkQvrdknXDYPFx0BNVB9c7xZQmWvIf2d5QaTOWBds4564ZM4bAYrCACy+NQ8sSeK4vseNCfbKiqJFY3vKo5u27RCaqiowQCqJ9JfdgIoVNWaqyqtp2SSqyXhKzKKZhvLLqMwl2LrBI5tArdXwpwQ/iiPjcdUIBe8ClkjHmOb22lDB/DHai4Hx4MgPcfYuNLZQhFwCxaPVbAQcyhYwAZzhhFjXb9BJZA0Np6y+T6VC+UcyN/LMEAkE+C2U2ZezKQv4judlKJMmJImF+f13ya91qLXw8FlQKI+kIDq7veKBkmRw99eijWMI5Jd0sLbYU1KfFFaPYPPRwQ+qatSHmN+OCXqU3UubU6rU7wU9kjE9AeRjOEalSohHFNEeE3oOmrR9SlNLBELGz2bpWrdv36K69MnjZ8g/OOe+ywLZJ+a1pNz8EdWJVBv+Ey2xHfhInXHuXlFr3628jTDFN1+QZQevnnNGVd2b0Nx2MWWryt+jYfCyFj1bbwMbhkN0wNnwFF4vfRBsMMTLyy8U9d1tlPCw1u8IMcW2bR+SX3O+SLg3QIzMXBV4jd1w96KtlMoPz7lr3bxZugGJB+IYGchpw+sBox2cWIlKD1/hywmtl1dTYnpo1Qpo6uQzKbTVf/u6XBjdG4uDRJhiElJ5p0cLyQkCLtgLzlR9T1ezQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BmmJHCkM4TqO6zmwhBEbqOHcZkeffczUAe5Gns3lXzLHkn3AvPmVSei03v0S?=
 =?us-ascii?Q?r0hEal3Ztg4TyHoMmcIOGIznAbe1ly7+atPNbMWKAevLpBNzuWHFvBiUCZB8?=
 =?us-ascii?Q?GEUEJMxhUxuAtBLLFvCPrp+PrVwejf5DRQHoj170gV19Jq6yNBf6tlvxkz6V?=
 =?us-ascii?Q?MRTUk3ahXle5XIb15TCDSarRwLmnWlo69VX/RCYpalQxs4glRRteuIAETc7t?=
 =?us-ascii?Q?wrxQ+G1PGROawsVv93+v+b0mZfQGBwH99Qi4t1YqGwrAd+yj+5Z4cxp4mK8O?=
 =?us-ascii?Q?Dk7sf2rAaF5xul/t8PRzWbrLtFZzlmlkKvsIrv+ZCLLA3aGofXD0NsE/lYa7?=
 =?us-ascii?Q?SKOX5yDVG0XhxGnpbBH/xQBSwhwitbyGJTEPih5sIGenOHN7n0NqtIyBHwXN?=
 =?us-ascii?Q?Qt36cpg4Qn3mES9lmevrVGnvSmsYgVq8N3EZH2BK8inoCLSFkzIYk5km1luv?=
 =?us-ascii?Q?E7o3fdv/Ihq/GpuKL3zqFfExD01r0koA5ulltXLQVKrXeBWQhSoTmbCxo7V5?=
 =?us-ascii?Q?R5OjYgctJOb+t+GXWhfBnmb2+ryb2qV5taFRH/oWUt71BEkk+CD07Nu/j0+g?=
 =?us-ascii?Q?wm4GpL6/nJdhNWmGmzxSn5HYKVpc3aEPZkktWTPaE6I3C9VEyCfJJHjGXtc3?=
 =?us-ascii?Q?+DBOvrfcmoILWzCfQ+aVCRsvy71dis56ZQ1oQ3u+QxEKQQvKnWq+XEM5hAhn?=
 =?us-ascii?Q?DlwpWvPRUWHv5HKuY3N2ayg5CMpETnyLMdaByy0ViGbajdqsoLNw8snWr5oK?=
 =?us-ascii?Q?ZQn8LBQtFYPVuEI5iA6pLjeMcFHEvvqCJQD7sLmC2ZU3WLONqpcIShs7rHCM?=
 =?us-ascii?Q?2VRx8CJ62dhHlIDynJU0mzWZ35HRcW0uetesQcC7az2y8ZzQFesMGPzrpOs0?=
 =?us-ascii?Q?8tpDvSgSOCbHyUJRhK52g8hR6UW+fEehIoAqf7cV0dpIo2EPscT6z7maOzHM?=
 =?us-ascii?Q?+AyxRhV6i7BhNZdg+MPjidhNLPQTeQ1+10iye4jdWtr40fvpSv/GaKN1ufSL?=
 =?us-ascii?Q?IK2ycp9LIqC0y4Ls+1KfY+rQzaOY7NLBryiSKvP8tXUNzMPrYu9ysqQJWYZ/?=
 =?us-ascii?Q?gqhiaJtoBgPwnWKdmhH3TvRXcwyhVGkvMKLBNJG/Uvvky6CZMv2VseM1u/rI?=
 =?us-ascii?Q?1KeJ0Bo5q7mUO+UVwBuwppERqNOl9E/3SZ52lER91cNwD01PtiqaRoO9avB1?=
 =?us-ascii?Q?JJeyXIjd+WS6I85lOoJID0zYnnQSV0MXSvbZIgsIwGLFwsgGiZT1DtpR9vpG?=
 =?us-ascii?Q?E+PN9YLj8ImGxClEDmg5K0owlMU+S1gh2yGqHb4EmQJUafKEsRHm5BmjF/Pi?=
 =?us-ascii?Q?ka1g1mwJj5gIIi4+dvOmQePeiRGR+1m+hBice4qWrBQXQEPY7SSmCtUw+Cxl?=
 =?us-ascii?Q?V7xk46LBfn/8WNWdWb3vz6vgJ6tfEi8w/H5n+5MyHIBdnCpyfnuBt3ElTKWN?=
 =?us-ascii?Q?cy7SXDVX9vC21bxcq8LwTZOIbWeenssE0uWepNMOeV+BQZw5+iZK14rkRkb5?=
 =?us-ascii?Q?NRMtn+qzhlAx5EnUHl57eb2M4gsdMStdjdjBnFZXh0Kw7YabXf/6l0Wt5u1o?=
 =?us-ascii?Q?XEhemBFoQW1caf4rtHhwQ/sRx2EASyxoKT8IQyGxmlOShiYpHSjCv5uveI5e?=
 =?us-ascii?Q?0A8KknT4m8OV0htwWZ4LOKg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132b27d4-6048-4088-33c7-08da94309fa4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:58.7463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0X2RyfCz7qvkYX7QpVGxdjhbk3VtBbohM9zrUf14CMOhVj3osD5GBXaYmyeVjL+9VQFrfaMIazVP93vVTzCULB9Bt5bhlbjHnYvGZ4vFEbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
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

v1 from previous RFC:
    * Remove unnecessary byteorder and kconfig header includes.
    * Create OCELOT_EXT_PORT_MODE_SERDES macro to match vsc9959.
    * Utilize readx_poll_timeout for SYS_RESET_CFG_MEM_INIT.
    * *_io_res struct arrays have been moved to the MFD files.
    * Changes to utilize phylink_generic_validate() have been squashed.
    * dev_err_probe() is used in the probe function.
    * Make ocelot_ext_switch_of_match static.
    * Relocate ocelot_ext_ops structure to be next to vsc7512_info, to
      match what was done in other felix drivers.
    * Utilize dev_get_regmap() instead of the obsolete
      ocelot_init_regmap_from_resource() routine.

---
 drivers/mfd/ocelot-core.c           |   3 +
 drivers/net/dsa/ocelot/Kconfig      |  14 ++
 drivers/net/dsa/ocelot/Makefile     |   5 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 254 ++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h           |   2 +
 5 files changed, 278 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index aa7fa21b354c..b7b9f6855f74 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -188,6 +188,9 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-ext-switch",
+		.of_compatible = "mscc,vsc7512-ext-switch",
 	},
 };
 
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 08db9cf76818..d8b224f8dc97 100644
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
index 000000000000..c821cc963787
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ */
+
+#include <linux/iopoll.h>
+#include <linux/mfd/ocelot.h>
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
+#define OCELOT_EXT_MEM_INIT_SLEEP_US	1000
+#define OCELOT_EXT_MEM_INIT_TIMEOUT_US	100000
+
+#define OCELOT_EXT_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
+					 OCELOT_PORT_MODE_QSGMII)
+
+static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_EXT_PORT_MODE_SERDES,
+	OCELOT_EXT_PORT_MODE_SERDES,
+	OCELOT_EXT_PORT_MODE_SERDES,
+	OCELOT_EXT_PORT_MODE_SERDES,
+	OCELOT_EXT_PORT_MODE_SERDES,
+	OCELOT_EXT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SGMII,
+	OCELOT_EXT_PORT_MODE_SERDES,
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
+static int ocelot_ext_mem_init_status(struct ocelot *ocelot)
+{
+	int val, err;
+
+	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], &val);
+
+	return err ?: val;
+}
+
+static int ocelot_ext_reset(struct ocelot *ocelot)
+{
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
+	err = readx_poll_timeout(ocelot_ext_mem_init_status, ocelot, val, !val,
+				 OCELOT_EXT_MEM_INIT_SLEEP_US,
+				 OCELOT_EXT_MEM_INIT_TIMEOUT_US);
+
+	if (IS_ERR_VALUE(err))
+		return err;
+
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+}
+
+static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
+					unsigned long *supported,
+					struct phylink_link_state *state)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	struct phylink_config *pl_config;
+	struct dsa_port *dp;
+
+	dp = dsa_to_port(ds, port);
+	pl_config = &dp->pl_config;
+
+	phylink_generic_validate(pl_config, supported, state);
+}
+
+static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
+					     struct resource *res)
+{
+	return dev_get_regmap(ocelot->dev->parent, res->name);
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
+	struct device *dev = &pdev->dev;
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	int err;
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
+		dev_err_probe(dev, err, "Failed to allocate DSA switch\n");
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
+		dev_err_probe(dev, err, "Failed to register DSA switch\n");
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
+static const struct of_device_id ocelot_ext_switch_of_match[] = {
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
index 17dd61f36563..2ed38110a6cc 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -460,6 +460,8 @@ enum ocelot_reg {
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

