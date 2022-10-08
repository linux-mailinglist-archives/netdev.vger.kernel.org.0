Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4316B5F86F4
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJHSzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiJHSx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:53:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B04F422FD;
        Sat,  8 Oct 2022 11:52:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFx7nWZJwo3BzJEi6DJCdiLVw/itZWEEDZyrQ0yCJAmwmRgt0TRLO1ET22/d7PK0hVnvGHF6F5c6RyRcVomMHEzZPd7dYLpf1x+7Yx+klkACAN27oD5nxjF2ldreZsT/Dz62dyURt/yoVEvvaf6QhWSjAQrvdqn1lLNdea/SPGZSyXH07Bj2XhL9u02s6dzRJ6yTX+Yxq57CK7RLHyZfoOkDloa4JGaxkiSL4EvkTS4bbvaMu9aDJIe+BP7GehGrppWsMSsEjIuTdtySE8FlIoVLCWKAuD4r8Me/W35+nxpyRv8r4+YDZFFD4H0ysr0FtSPwPuAvZmheM61X+Tn7IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPXfZ6EcLhYgHEYlqt5FkHlGIt2b22r5aU0w6tD1g3s=;
 b=CJRbKkmbR1oQC/taHK17Q5GRVTv2O9Av1l0FCdfaO5/ZAnzcoYsHql8M0wZwXZLl+ngYnx94+RR3dVoQKysQAgsGRGz3Z4loT1FTPo0CYxPXHSODK7loghwjCNZBRKYNcWVsTyq+5fJ+vV8/LSXCw3qf7V592Z6/bPmwYIxnDZC0WFDwSXRc+mT5pgCsPMrLYWYx7mw4nCk0yQwyn5vlq+ETFnAu+VHpn3Wbi3mDBYwg8+bunwoJTa1OzNhm9FFFjEewxTKtJLcGGwtx7bBbFvETVmzM1An5uabPGfRYN3kJnLuN+5+LEFvl8eBhMI4DcSznUwTr141QIzOo9ZdpTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPXfZ6EcLhYgHEYlqt5FkHlGIt2b22r5aU0w6tD1g3s=;
 b=AlcIJoXFgIhn/S84APUU8aN+DehMe/kFBUCVuZD8VNMqQCvsE0CoGRbu/vlXDv9FCHzIw47UH3O2yUEqCouuPKObin3hnTPM6QvoM7GBFEbTAWEIDTwNBXDp/8LzWT/0AJTKpZrz/V/M0Png8qZNW8QJulkgUlFgklxp54qhgoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:13 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 16/17] net: dsa: ocelot: add external ocelot switch control
Date:   Sat,  8 Oct 2022 11:51:51 -0700
Message-Id: <20221008185152.2411007-17-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b2ca1b-20ca-48a7-f642-08daa95e35c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGEdreGmvOyci7Y8Vxtn+FuBmeCEVBZTe0viVhVwXuOnczHNVuXo59ND0kGa9yx7hd/Xkhb7rHqdvKQ6fclfQGc4BzuBa57Z0RKpyPpB/059A5KjEx2Tru29veATWUBIUNP809oSEi+uG8g16JOX5WTVT8PIz0wlPZKROeAwpsVPHZW1kvzDHnVgrBe9CDaIMZYbUDHI4utVMC/qx9bdEXLdLF6ps/cqVdVb3mj7CU9hK+T6ruFEJvHXLi28SJSWk31vR9BTZZDtKxwwRIf4wUThpoQKPvlJnYWFCJdqLzmXM0n21T7RceNPTpTHRRKEwYIdZdOe8VQHttduPCvclKKjxRY9/KjGpLvMRQvfS/e18WlOi6Yo1/UVCdO7LxeAzIo7B3FqdzoE2XF0AZfydwzro+HWrpCa+8A5+vf073L5cnsnTsvzRkRk2wUygDO3f/zJboMLAU2kbZUS9t3LOnIx9pYHLOAEdf1+NUmpRIeuYalO0Q9UZlQzaLYNZPTxvl8Igji+B0iC8EMy4jZzyflTXjJOl6NLlY2CTXY9Op6HqpFhsfBzTgzCg0mlkurDHnPF6bjE09ANHOngwlhQiZiaQMDEJn6tj6q9pxmQhYERX+xhx01pI2cKNM0DVMDB6lZw8faYYyumRBsdgLU0lSey6M3VmmBazwfb6M23nXTU4Gh3tPKjoQhF8aWIL3ZQgIWJbhudycHeppFfQOww0kSTQJzcz4wclZPlAXJj2AVSoN7tG8bWElss1bIZeqhppnEzAB4ZQGWCTI/cJokGvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+kzoSs6m9qHOktNvwjFYZhXirUpBwHg/rJ7erG3oRePW6EOwlvnNvRWTNh93?=
 =?us-ascii?Q?WGr94f8aJuuQxZnPsIKXYSGU9L9iB69QH2DToBgkoGlrwD09+Hgivo0PvI7F?=
 =?us-ascii?Q?SUx0++bWRW3viwxeVQLUbrf9cLEzpt0SrN5YVNIFM6H1pjsE4zU0GcXvWzZv?=
 =?us-ascii?Q?Ny8+Uu+ExAcJKvmhGo5ihBLA6WHs3rtZdO+qsg+Ct9DqJSjXtdcFiDJvcjlF?=
 =?us-ascii?Q?pTsjiUgDNWOeu6opR8R3LRmUTpvm6KZyRWb33mj4I9QfGySSPR/ljp1+eSOr?=
 =?us-ascii?Q?rjTOJLxKhJCU2U8R9aRs8mM+kONWAS0O0jH7t0sfpEE+keN21D4sl03GS/2f?=
 =?us-ascii?Q?+jrdE6xZYNGs4nWH9R8FDp++NW6HN2HxMeFCGXtzNdBZmZbbubTA3uqqL4oM?=
 =?us-ascii?Q?treHL/UZbZ/BGudACei1IppqZ3j5BTZedZGZ8rHxQ3pqQHiNrUPmXg5R4R2I?=
 =?us-ascii?Q?grz6SGxL7X3Cy/hQRmfowZqPnVMpBtJgqJ0YxEwzo4h8jXHRh03Sq+bkFA+X?=
 =?us-ascii?Q?cZqEeuxBQVB84QcGbJADQhbxIz0NZ3lnRNmvkvVPt1qd6gcGp2xOxFlXXMdf?=
 =?us-ascii?Q?KDPUscMa9n+QlP1Ed4h6e8EykJAiKFJl1h8Hal16/IAnCI22xbQ33YyyZp0X?=
 =?us-ascii?Q?G905vVWql/sgWKVdqRcAxIRCutK1gH6JYoZUvmpGr9QF6JMwiyT/cRilj6lr?=
 =?us-ascii?Q?2mvGw/P7lHHmokBO+E+nP7sw4JL3FQBEHTqGgkoHy6aH/5SVWqjgJLSPebvX?=
 =?us-ascii?Q?7+aRZmraGEgOFFuGIP+kGOv+zhmRNazvqbYkgt381piXDAA9nObsmj560qkZ?=
 =?us-ascii?Q?3qAe4Nfh8o9WD/au0IQQ4uVE3VR7GdBOZKyTuAq7zIA8BmXtsm+I9OT5LtHM?=
 =?us-ascii?Q?bITK58voGRGKM35Rrq+zutZvXCY8BvtLdC1MB9t8U2y0BApmoXtWsvxZvkuD?=
 =?us-ascii?Q?rlhNmrOW/Ir9/GThO04/PUd1F1YsqTZvDvqf7Bziel+IuqBKvza+YA1hFiSp?=
 =?us-ascii?Q?OJOpUBe9j7Kg0V+MXIvw+nWMgqv+WoHfXY7BHjwxhuFtXogsIO2XJ9vRa6CA?=
 =?us-ascii?Q?zTJNymeyQVJUNhr11oLoVeE++ZGjysReCF5jwyKmLdZq+JYyfDXfSnBaNKBp?=
 =?us-ascii?Q?Iz6N8ro6q0voIgVq/R5swyRNNsB8HvHEK0oWeViU713QQuoxl3MIby4oLKAB?=
 =?us-ascii?Q?JQwkBsKLZ2vzCLsX9qlRMbv8/WKP7IfOeWX8O7Aw+YxazkpJkwTCFxR3GDbh?=
 =?us-ascii?Q?AeVsAIODxm7kZ5X1u+OaEZWrCW2AHs/VjrZ5Ok5bKNGMFi2/fCpwu/nBJO/k?=
 =?us-ascii?Q?yQrjv/ppEYxIogl5uRQtrrVITHxXfapJTpnKsLi5lAK/a1GXp9XoGmVOhWWc?=
 =?us-ascii?Q?HL+4pu3sxxob3L65VrsypHcEtc2Hw7kxXNLVkYy6fu+9s9SbcAbJBF9ielaj?=
 =?us-ascii?Q?KvMdYAD9CGnV0QpehRPq/Kf4xsxE5qkDMcBDOHID8zQuAxeP+QRjROIp9bsP?=
 =?us-ascii?Q?AzXLL+08bKt5RCDyKOBQAg5o+7O7EBfMX+8R341ZNtO88FnPHb5yg+hW48Ft?=
 =?us-ascii?Q?rw2qReZok0mo6bxV2Y8rS4lss10LLySEhmPSaEXiNwSLxS/vulNLaGG5JsrI?=
 =?us-ascii?Q?6vKBRfK7w6YLetwcaCpGiVI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b2ca1b-20ca-48a7-f642-08daa95e35c5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:12.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vyQj0G7ErD2Qxs1VozuViR3vmYTwYkTHhdz3Y6HcaWTWGxDYMk2lJjhwbcljRulkROyVG+DztdTaFApLVhouMGlVi241VLFeuf76L6FriI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control of an external VSC7512 chip.

Currently the four copper phy ports are fully functional. Communication to
external phys is also functional, but the SGMII / QSGMII interfaces are
currently non-functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * Add forward-compatibility for device trees that have ports 4-7
      defined by saying they are OCELOT_PORT_MODE_NONE
    * Utilize new "resource_names" instead of "*_io_res". Many thanks
      to Vladimir for making this possible.
      - Also remove ocelot_ext_regmap_init() function
    * Remove dev_set_drvdata(dev, NULL) from remove() to match other
      drivers

v3
    * Remove additional entry in vsc7512_port_modes array
    * Add MFD_OCELOT namespace import, which is needed for
      vsc7512_*_io_res

v2
    * Add MAINTAINERS update
    * Remove phrase "by way of the ocelot-mfd interface" from the commit
      message
    * Move MFD resource addition to a separate patch
    * Update Kconfig help
    * Remove "ocelot_ext_reset()" - it is now shared with ocelot_lib
    * Remove unnecessary includes
    * Remove "_EXT" from OCELOT_EXT_PORT_MODE_SERDES
    * Remove _ext from the compatible string
    * Remove no-longer-necessary GCB register definitions

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
 MAINTAINERS                         |   1 +
 drivers/net/dsa/ocelot/Kconfig      |  19 +++
 drivers/net/dsa/ocelot/Makefile     |   5 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 178 ++++++++++++++++++++++++++++
 4 files changed, 203 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ca84cb5ab4a..15593f0dd128 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14751,6 +14751,7 @@ M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	drivers/mfd/ocelot*
+F:	drivers/net/dsa/ocelot/ocelot_ext.c
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 08db9cf76818..74a900e16d76 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,23 @@
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
+	  when controlled through SPI.
+
+	  The Ocelot switch family is a set of multi-port networking chips. All
+	  of these chips have the ability to be controlled externally through
+	  SPI or PCIe interfaces.
+
+	  Say "Y" here to enable external control to these chips.
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
index 000000000000..1340b017e37d
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ */
+
+#include <linux/mfd/ocelot.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "felix.h"
+
+#define VSC7514_NUM_PORTS		11
+
+#define OCELOT_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
+					 OCELOT_PORT_MODE_QSGMII)
+
+static const u32 vsc7512_port_modes[VSC7514_NUM_PORTS] = {
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_NONE,
+};
+
+static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
+					unsigned long *supported,
+					struct phylink_link_state *state)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	struct dsa_port *dp;
+
+	dp = dsa_to_port(ds, port);
+
+	phylink_generic_validate(&dp->pl_config, supported, state);
+}
+
+static const struct ocelot_ops ocelot_ext_ops = {
+	.reset		= ocelot_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+static const char * const vsc7512_resource_names[TARGET_MAX] = {
+	[SYS] = OCELOT_RES_NAME_SYS,
+	[REW] = OCELOT_RES_NAME_REW,
+	[S0] = OCELOT_RES_NAME_S0,
+	[S1] = OCELOT_RES_NAME_S1,
+	[S2] = OCELOT_RES_NAME_S2,
+	[QS] = OCELOT_RES_NAME_QS,
+	[QSYS] = OCELOT_RES_NAME_QSYS,
+	[ANA] = OCELOT_RES_NAME_ANA,
+};
+
+static const struct felix_info vsc7512_info = {
+	.resource_names			= vsc7512_resource_names,
+	.regfields			= vsc7514_regfields,
+	.map				= vsc7514_regmap,
+	.ops				= &ocelot_ext_ops,
+	.stats_layout			= vsc7514_stats_layout,
+	.vcap				= vsc7514_vcap_props,
+	.num_mact_rows			= 1024,
+	.num_ports			= VSC7514_NUM_PORTS,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.phylink_validate		= ocelot_ext_phylink_validate,
+	.port_modes			= vsc7512_port_modes,
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
+	{ .compatible = "mscc,vsc7512-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
+
+static struct platform_driver ocelot_ext_switch_driver = {
+	.driver = {
+		.name = "ocelot-switch",
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
+MODULE_IMPORT_NS(MFD_OCELOT);
-- 
2.25.1

