Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C250B357EE4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhDHJQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:16:23 -0400
Received: from mail-bn7nam10on2120.outbound.protection.outlook.com ([40.107.92.120]:43329
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229600AbhDHJQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xbi6g6+puedtFOdDsShUn+hsb7XcXSu7BWgGc/iP1htgtT03+QDxuloyMgYwtE19zt3aUOXJTZjdf47vxP30BMxHnbQXiKtg2dmH6vfWq1kcm9H4PS+jQiJk7D9Cos4Byumq8C5h1ViFugCUlaZ3DsK4WkfTOHDviMvHeznUggP423ud2u8jefKfku65YQj/SD0V8dNsHlMVFi7vvX+XMotfiS679SAo59MoJE9kcoD7Y1wvqYgD0ShllzotLOpO7Q8/+pCovVpuQ4H+AuuC/oYPipFCGz0mtnxjqEM+NMD41z1qb5Jj5PAqklTiD8EiG3PUFGzPccwSPoIhhUPagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIErfeQS0ZuL9CiAOTJze02x9o+sUx4mPm6dg8R8u+M=;
 b=gl0cS6A/1a2dOxXv5fqUivlfrN8cqZi7Cxwcmb1+7ZLKMxy2jlfo0TBy8kGUZo5rjda4DwHTBsUVFbmykKpjnVQKfmc0Ds/l4m1bxKFUz6DoB6PM9hrUHhUNoDjy3nYSHgoTqY7zSuemUCkiT4mvFtv+K3+WiDggXWHeZHQK9OSjpBPIg8eUr4hW2gr/tE+ttP9ps0xQ7DhOxhdMVe2NboxUVfEz6OrOw+cmJ9KZu6Xu0D/ARB+LMgSD39zNJ22cYbKKpPgFmHPEZBCcCkbwEQSPdM9e37kLrMmwxpHhLf68Rd2bG9n/W3e8Nswlup12Ian2M+Ntobmu2g6GBEjsDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIErfeQS0ZuL9CiAOTJze02x9o+sUx4mPm6dg8R8u+M=;
 b=EZiJIUKio7xt3EYm7YsLjDojSySqJv7c2KxnwJZ00iXR8BzfGiMVm/mEhC0aR3eTLohS5Cj5+5gNLWcJECGY0wO6DrNQrAPJ9F+I6/wMqkrM9eJfVaCm+zMP6fTjH5g0KxjhsodrnUkokzDcNDrzx3ewNQV//XnPpSeSckWEx9o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1042.namprd21.prod.outlook.com
 (2603:10b6:207:37::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Thu, 8 Apr
 2021 09:16:00 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962%3]) with mapi id 15.20.4042.004; Thu, 8 Apr 2021
 09:15:59 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org, leon@kernel.org,
        andrew@lunn.ch, bernd@petrovitsch.priv.at
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)
Date:   Thu,  8 Apr 2021 02:15:43 -0700
Message-Id: <20210408091543.22369-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:2:4908:1d3:af41:2b67]
X-ClientProxiedBy: CO2PR18CA0047.namprd18.prod.outlook.com
 (2603:10b6:104:2::15) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:2:4908:1d3:af41:2b67) by CO2PR18CA0047.namprd18.prod.outlook.com (2603:10b6:104:2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 09:15:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 087d6336-4caf-43b2-3e1c-08d8fa6eebb4
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1042:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB104219DAF3241BF8C3428092BF749@BL0PR2101MB1042.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnYvAwsQWmqcBvfvx7Fk6Q2mHscSl4oW6m9FAo/Npr0YUXgBzAK0ZJrGvnWmTdV8c2PGzLAeq8SbuJTmoPjZg9izKFsxNVlrOMKVs8SmnFl6RW+6gPYS4TECsHJwsx/sx/WCADQ9c5Rb0R124Pw+3s4/1EP3JaPqWkpMn7Q1tvtbcXzQt8YXF49Jex0XXONOw+g3NLylp1+xtgRR1wRBvv3UdxLwqZl5Xo6HdcsvKFXlNrjB5QwSUFR2Op1lxzHYEdpikls6mDtr0X4cFWSErUtik6dc4bXT89OxjSzlhFHyNp2WhE+WDEgNF+GqSmNhEZDJhwKtuAeZhhGyqixia1f43rsrWCu6nXfLw5rUIR4iydG5lvSicjJo+Lq/qigt9VJdytOpN5y7ocnbQmC+rS0wZ874iu5aj/vTb+WY6otP8/qvX2c7GKEparn+5l1kjfzSVwz5vTqLDBjvcox8vQFY0hRKjuh37jogGAdpI0B6SXnfCdI66rLeeM6sQKNDVXYxMs34DMxTeBTNvJUbto973XkYaSQNmhr4REQjI3DXPYRULh6uMh/AfgpZHCPCUKnArlMCk24zNtDsYlpjdZDmvhxc5Fvky1+qAMtoxFXB8hPY0nUiMLGlMUMyjOD0nRzGFwUmQE0xj0WlvvW2oNrXEioOJYvRE66KASrztmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(47530400004)(2906002)(66476007)(316002)(82960400001)(82950400001)(30864003)(52116002)(3450700001)(478600001)(4326008)(6666004)(66556008)(86362001)(6486002)(36756003)(8936002)(1076003)(921005)(10290500003)(8676002)(2616005)(5660300002)(107886003)(83380400001)(16526019)(38100700001)(7696005)(186003)(66946007)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Wa+WGKOmBieYguC/cNCSB7d1G/vjqefA15nuevN84FJeR6oAvwq6+lilR8FR?=
 =?us-ascii?Q?A52jq9EjgQBprF2viiUHn74X5V6A2CI5RCQ6z3l9B1u+HTh0ned8oxxbZr0V?=
 =?us-ascii?Q?IWHFJVRgfjutgBrIT2OH6o/5wonzoJzXilEPTtEF8I5rPs30ywk54rdW9Abj?=
 =?us-ascii?Q?VIJUtnqHNmpol8MtCmQ7ntOD0zfpk5lOyQSx2lm8Ev00yCIoBa4CVp6DH5lE?=
 =?us-ascii?Q?at50HIaA5EWPOYdqP9AbD5MCV0vjZ6MxOGphzZTHygeE4wo2i0l1Cs3tiYD8?=
 =?us-ascii?Q?rdUP5H1i7WhxTitHyEINkSEm3EETbJ52eUOzWekWPIv4VFwmAmpbVc7xn8Cu?=
 =?us-ascii?Q?BY8Drt/B3mHMXxWowfrwooms7/n6cbe4fByq5h+KKZwXnxOO0LwWAhfFEY02?=
 =?us-ascii?Q?/+vIGUfP6WzlynhzF9BZwhhasFy/e43RCjjqkzjBqV87G2xRJtEkLXruoHAy?=
 =?us-ascii?Q?3JSFhlT3kVT0HBEhFx+hIwbTT8/FaA+sIxGNsTMg0zqFKGGP9GYIqkQE5Ynr?=
 =?us-ascii?Q?jH4qQaVvb+ttp0VDm/w5sXY/EZhN+OsU04iTcajXq9Ye3t2oEZsc239yDsX4?=
 =?us-ascii?Q?32y8o8uvmY/nSoAZznNqeRtcM8HYEhKHQHF3KBfam6gbhtfNSXfJ9HQhCAd0?=
 =?us-ascii?Q?1Ik9ZbaA+dzFc4UZVj1sihX7ohqtbv7BSuqUTi/2dXOjq9i3ZKfGPKfJ6V6I?=
 =?us-ascii?Q?KL65Au9GqbP8NGUg7haaLhteBEriyexhGXYNhCho7nE7XyLy1TmDUGuNdWQu?=
 =?us-ascii?Q?g+CKIW1ku2altpLeBZA3G7RAhCsMeyFzqf2nHjCHIACdDuyDJOyeKBDxadJr?=
 =?us-ascii?Q?lC3cF0WcJ9uKfW4Sqd6kmhWXZ+cymgh6r3DqBMDnegAyDXq3M2Nt5TalvDA9?=
 =?us-ascii?Q?0Jp7pLA8IU+qwkSWwgvzsdmGpI8buGwAVPhlJCjYn07YnSHKtCHsEyyn9/j3?=
 =?us-ascii?Q?z8MRpSGHnBavADeS+RcKB6f9FtQLK/OugsaIvq96tWCzpTfGQYpHc5a2/Y+t?=
 =?us-ascii?Q?/YfeZWrkyMAj1Vv5KeBYSfpWU7vg9YPREeCaUGLeA8WIeMXxQNrMSq4Ndspi?=
 =?us-ascii?Q?EUE+GS6OeunfU1igLXVCKc/yKh4q8Np7vG0/Hke2mfwZeEzq6+dgLjG0tuL2?=
 =?us-ascii?Q?M75qkcz6p6HnZPPmoYMW0QHjREa3H3ydfIokrZtlRR1cMTZ3SEnVV4B+Ufvi?=
 =?us-ascii?Q?4FXGYIRDopV1NUa91uaIedPxZahXqp0Imve4sh3riXmIRy1ivtWL/LMpXsfg?=
 =?us-ascii?Q?XeaWIv3Sz9znafcbqKbEaDPzGMd+GBWc8NZs8SeFT5DSfNOSprAQDcm/xJyc?=
 =?us-ascii?Q?5ecrhDWwWsC9HTFfc9uAT3+5OP7IFzIUXxSXmnWC6gISB28SpTb+EPpVxjs6?=
 =?us-ascii?Q?vrXMA+jwR+G/YB4o4qNXQ0JlBqGg?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087d6336-4caf-43b2-3e1c-08d8fa6eebb4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:15:59.3022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdslgWBAkK2xJgpH58HG/HpwSj0j140GRuBGeso6C7pXMr1vPZtDqvjY4Xo4498K5kn8tDnGp2n4yV4l+kNWTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a VF driver for Microsoft Azure Network Adapter (MANA) that will be
available in the future.

Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 MAINTAINERS                                   |    4 +-
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/microsoft/Kconfig        |   30 +
 drivers/net/ethernet/microsoft/Makefile       |    5 +
 drivers/net/ethernet/microsoft/mana/Makefile  |    6 +
 drivers/net/ethernet/microsoft/mana/gdma.h    |  728 +++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   | 1515 ++++++++++++++
 .../net/ethernet/microsoft/mana/hw_channel.c  |  859 ++++++++
 .../net/ethernet/microsoft/mana/hw_channel.h  |  186 ++
 drivers/net/ethernet/microsoft/mana/mana.h    |  531 +++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1833 +++++++++++++++++
 .../ethernet/microsoft/mana/mana_ethtool.c    |  278 +++
 .../net/ethernet/microsoft/mana/shm_channel.c |  292 +++
 .../net/ethernet/microsoft/mana/shm_channel.h |   21 +
 15 files changed, 6289 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microsoft/Kconfig
 create mode 100644 drivers/net/ethernet/microsoft/Makefile
 create mode 100644 drivers/net/ethernet/microsoft/mana/Makefile
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_main.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_en.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_ethtool.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.h


Changes in v2:

    Removed the module_param(num_queues,...).           [Andrew Lunn]
    Changed pr_err() to netdev_err() and dev_err().     [Andrew Lunn]
    Used reverse X-mas tree style in all the functions. [Andrew Lunn]

    Changed "= { 0 };" to "= {};" for struct variables. [Leon Romanovsky]

    Addressed 3 build failures on i386, arc and powerpc by making the
    the driver dependent on X86_64 in Kconfig: so far, the driver is
    only validated on X86_64 (in the future, we may enable the driver
    for ARM64).

    Also made some cosmetic changes.

    Rebased the patch to the latest net-next.

    BTW, the support of XDP and BQL haven't been implemented. They are on
    our TO-DO list.

diff --git a/MAINTAINERS b/MAINTAINERS
index 217c7470bfa9..6ab1f9ac8c54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8261,11 +8261,12 @@ S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/i2c/hi556.c
 
-Hyper-V CORE AND DRIVERS
+Hyper-V/Azure CORE AND DRIVERS
 M:	"K. Y. Srinivasan" <kys@microsoft.com>
 M:	Haiyang Zhang <haiyangz@microsoft.com>
 M:	Stephen Hemminger <sthemmin@microsoft.com>
 M:	Wei Liu <wei.liu@kernel.org>
+M:	Dexuan Cui <decui@microsoft.com>
 L:	linux-hyperv@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git
@@ -8282,6 +8283,7 @@ F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
 F:	drivers/input/serio/hyperv-keyboard.c
 F:	drivers/iommu/hyperv-iommu.c
+F:	drivers/net/ethernet/microsoft/
 F:	drivers/net/hyperv/
 F:	drivers/pci/controller/pci-hyperv-intf.c
 F:	drivers/pci/controller/pci-hyperv.c
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 4b85f2b74872..d46460c5b44d 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -82,6 +82,7 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
+source "drivers/net/ethernet/microsoft/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 9394493e8187..cb3f9084a21b 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_NET_VENDOR_HUAWEI) += huawei/
 obj-$(CONFIG_NET_VENDOR_IBM) += ibm/
 obj-$(CONFIG_NET_VENDOR_INTEL) += intel/
 obj-$(CONFIG_NET_VENDOR_I825XX) += i825xx/
+obj-$(CONFIG_NET_VENDOR_MICROSOFT) += microsoft/
 obj-$(CONFIG_NET_VENDOR_XSCALE) += xscale/
 obj-$(CONFIG_JME) += jme.o
 obj-$(CONFIG_KORINA) += korina.o
diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
new file mode 100644
index 000000000000..12ef6b581566
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -0,0 +1,30 @@
+#
+# Microsoft Azure network device configuration
+#
+
+config NET_VENDOR_MICROSOFT
+	bool "Microsoft Azure Network Device"
+	default y
+	help
+	  If you have a network (Ethernet) device belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip the
+	  question about Microsoft Azure network device. If you say Y, you
+	  will be asked for your specific device in the following question.
+
+if NET_VENDOR_MICROSOFT
+
+config MICROSOFT_MANA
+	tristate "Microsoft Azure Network Adapter (MANA) support"
+	default m
+	depends on PCI_MSI && X86_64
+	select PCI_HYPERV
+	help
+	  This driver supports Microsoft Azure Network Adapter (MANA).
+	  So far, the driver is only validated on X86_64.
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called mana.
+
+endif #NET_VENDOR_MICROSOFT
diff --git a/drivers/net/ethernet/microsoft/Makefile b/drivers/net/ethernet/microsoft/Makefile
new file mode 100644
index 000000000000..d2ddc218135f
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the Microsoft Azure network device driver.
+#
+
+obj-$(CONFIG_MICROSOFT_MANA) += mana/
diff --git a/drivers/net/ethernet/microsoft/mana/Makefile b/drivers/net/ethernet/microsoft/mana/Makefile
new file mode 100644
index 000000000000..0edd5bb685f3
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#
+# Makefile for the Microsoft Azure Network Adapter driver
+
+obj-$(CONFIG_MICROSOFT_MANA) += mana.o
+mana-objs := gdma_main.o shm_channel.o hw_channel.o mana_en.o mana_ethtool.o
diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
new file mode 100644
index 000000000000..432229d8e827
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -0,0 +1,728 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#ifndef _GDMA_H
+#define _GDMA_H
+
+#include <linux/dma-mapping.h>
+#include <linux/netdevice.h>
+
+#include "shm_channel.h"
+
+enum gdma_request_type {
+	GDMA_VERIFY_VF_DRIVER_VERSION	= 1,
+	GDMA_QUERY_MAX_RESOURCES	= 2,
+	GDMA_LIST_DEVICES		= 3,
+	GDMA_REGISTER_DEVICE		= 4,
+	GDMA_DEREGISTER_DEVICE		= 5,
+	GDMA_GENERATE_TEST_EQE		= 10,
+	GDMA_CREATE_QUEUE		= 12,
+	GDMA_DISABLE_QUEUE		= 13,
+	GDMA_CREATE_DMA_REGION		= 25,
+	GDMA_DMA_REGION_ADD_PAGES	= 26,
+	GDMA_DESTROY_DMA_REGION		= 27,
+};
+
+enum gdma_queue_type {
+	GDMA_INVALID_QUEUE,
+	GDMA_SQ,
+	GDMA_RQ,
+	GDMA_CQ,
+	GDMA_EQ,
+};
+
+enum gdma_work_request_flags {
+	GDMA_WR_NONE			= 0,
+	GDMA_WR_OOB_IN_SGL		= BIT(0),
+	GDMA_WR_SGL_DIRECT		= BIT(1),
+	GDMA_WR_CONSUME_CREDIT		= BIT(2),
+	GDMA_WR_FENCE			= BIT(3),
+	GDMA_WR_CHECK_SN		= BIT(4),
+	GDMA_WR_PAD_DATA_BY_FIRST_SGE	= BIT(5),
+};
+
+enum gdma_eqe_type {
+	GDMA_EQE_COMPLETION		= 3,
+	GDMA_EQE_TEST_EVENT		= 64,
+	GDMA_EQE_SOC_TO_VF_EVENT	= 128,
+	GDMA_EQE_HWC_INIT_EQ_ID_DB	= 129,
+	GDMA_EQE_HWC_INIT_DATA		= 130,
+	GDMA_EQE_HWC_INIT_DONE		= 131,
+	GDMA_EQE_APP_START		= 132,
+	GDMA_EQE_APP_END		= 255,
+};
+
+enum {
+	GDMA_DEVICE_NONE = 0,
+	GDMA_DEVICE_HWC = 1,
+	GDMA_DEVICE_ANA = 2,
+};
+
+struct gdma_resource {
+	/* Protect the bitmap */
+	spinlock_t lock;
+
+	/* The bitmap size in bits. */
+	u32 size;
+
+	/* The bitmap tracks the resources. */
+	unsigned long *map;
+};
+
+union gdma_doorbell_entry {
+	u64	as_uint64;
+
+	struct {
+		u64 id		: 24;
+		u64 reserved	: 8;
+		u64 tail_ptr	: 31;
+		u64 arm		: 1;
+	} cq;
+
+	struct {
+		u64 id		: 24;
+		u64 wqe_cnt	: 8;
+		u64 tail_ptr	: 32;
+	} rq;
+
+	struct {
+		u64 id		: 24;
+		u64 reserved	: 8;
+		u64 tail_ptr	: 32;
+	} sq;
+
+	struct {
+		u64 id		: 16;
+		u64 reserved	: 16;
+		u64 tail_ptr	: 31;
+		u64 arm		: 1;
+	} eq;
+} __packed;
+
+struct gdma_msg_hdr {
+	u32 hdr_type;
+	u32 msg_type;
+	u16 msg_version;
+	u16 hwc_msg_id;
+	u32 msg_size;
+} __packed;
+
+struct gdma_dev_id {
+	union {
+		struct {
+			u16 type;
+			u16 instance;
+		};
+
+		u32 as_uint32;
+	};
+} __packed;
+
+struct gdma_req_hdr {
+	struct gdma_msg_hdr req;
+	struct gdma_msg_hdr resp; /* The expected response */
+	struct gdma_dev_id dev_id;
+	u32 activity_id;
+} __packed;
+
+struct gdma_resp_hdr {
+	struct gdma_msg_hdr response;
+	struct gdma_dev_id dev_id;
+	u32 activity_id;
+	u32 status;
+	u32 reserved;
+} __packed;
+
+struct gdma_general_req {
+	struct gdma_req_hdr hdr;
+} __packed;
+
+#define GDMA_MESSAGE_V1 1
+
+struct gdma_general_resp {
+	struct gdma_resp_hdr hdr;
+} __packed;
+
+#define GDMA_STANDARD_HEADER_TYPE 0
+
+static inline void gdma_init_req_hdr(struct gdma_req_hdr *hdr, u32 code,
+				     u32 req_size, u32 resp_size)
+{
+	hdr->req.hdr_type = GDMA_STANDARD_HEADER_TYPE;
+	hdr->req.msg_type = code;
+	hdr->req.msg_version = GDMA_MESSAGE_V1;
+	hdr->req.msg_size = req_size;
+
+	hdr->resp.hdr_type = GDMA_STANDARD_HEADER_TYPE;
+	hdr->resp.msg_type = code;
+	hdr->resp.msg_version = GDMA_MESSAGE_V1;
+	hdr->resp.msg_size = resp_size;
+}
+
+static inline bool is_gdma_msg(const void *req)
+{
+	struct gdma_req_hdr *hdr = (struct gdma_req_hdr *)req;
+
+	if (hdr->req.hdr_type == GDMA_STANDARD_HEADER_TYPE &&
+	    hdr->resp.hdr_type == GDMA_STANDARD_HEADER_TYPE &&
+	    hdr->req.msg_size >= sizeof(struct gdma_req_hdr) &&
+	    hdr->resp.msg_size >= sizeof(struct gdma_resp_hdr) &&
+	    hdr->req.msg_type != 0 && hdr->resp.msg_type != 0)
+		return true;
+
+	return false;
+}
+
+static inline bool is_gdma_msg_len(const u32 req_len, const u32 resp_len,
+				   const void *req)
+{
+	struct gdma_req_hdr *hdr = (struct gdma_req_hdr *)req;
+
+	if (req_len >= sizeof(struct gdma_req_hdr) &&
+	    resp_len >= sizeof(struct gdma_resp_hdr) &&
+	    req_len >= hdr->req.msg_size && resp_len >= hdr->resp.msg_size &&
+	    is_gdma_msg(req)) {
+		return true;
+	}
+
+	return false;
+}
+
+/* The 16-byte struct is part of the GDMA work queue entry (WQE). */
+struct gdma_sge {
+	u64 address;
+	u32 mem_key;
+	u32 size;
+} __packed;
+
+struct gdma_wqe_request {
+	struct gdma_sge *sgl;
+	u32 num_sge;
+
+	u32 inline_oob_size;
+	const void *inline_oob_data;
+
+	u32 flags;
+	u32 client_data_unit;
+};
+
+enum GDMA_PAGE_TYPE {
+	GDMA_PAGE_TYPE_4K,
+	GDMA_PAGE_TYPE_8K,
+	GDMA_PAGE_TYPE_16K,
+	GDMA_PAGE_TYPE_32K,
+	GDMA_PAGE_TYPE_64K,
+	GDMA_PAGE_TYPE_128K,
+	GDMA_PAGE_TYPE_256K,
+	GDMA_PAGE_TYPE_512K,
+	GDMA_PAGE_TYPE_1M,
+	GDMA_PAGE_TYPE_2M,
+};
+
+#define GDMA_INVALID_DMA_REGION 0
+
+struct gdma_mem_info {
+	struct device *dev;
+
+	dma_addr_t dma_handle;
+	void *virt_addr;
+	u64 length;
+
+	/* Allocated from the PF driver */
+	u64 gdma_region;
+};
+
+#define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8
+
+struct gdma_dev {
+	struct gdma_dev_id dev_id;
+
+	u32 pdid;
+	u32 doorbell;
+	u32 gpa_mkey;
+
+	/* GDMA driver specific pointer */
+	void *driver_data;
+};
+
+#define MINIMUM_SUPPORTED_PAGE_SIZE PAGE_SIZE
+
+#define GDMA_CQE_SIZE 64
+#define GDMA_EQE_SIZE 16
+#define GDMA_MAX_SQE_SIZE 512
+#define GDMA_MAX_RQE_SIZE 256
+
+#define GDMA_COMP_DATA_SIZE 0x3C
+
+#define GDMA_EVENT_DATA_SIZE 0xC
+
+/* The WQE size must be a multiple of the Basic Unit, which is 32 bytes. */
+#define GDMA_WQE_BU_SIZE 32
+
+#define INVALID_PDID		UINT_MAX
+#define INVALID_DOORBELL	UINT_MAX
+#define INVALID_MEM_KEY		UINT_MAX
+#define INVALID_QUEUE_ID	UINT_MAX
+#define INVALID_PCI_MSIX_INDEX  UINT_MAX
+
+struct gdma_comp {
+	u32 cqe_data[GDMA_COMP_DATA_SIZE / 4];
+	u32 wq_num;
+	bool is_sq;
+};
+
+struct gdma_event {
+	u32 details[GDMA_EVENT_DATA_SIZE / 4];
+	u8  type;
+};
+
+struct gdma_queue;
+
+#define CQE_POLLING_BUFFER 512
+struct ana_eq {
+	struct gdma_queue *eq;
+	struct gdma_comp cqe_poll[CQE_POLLING_BUFFER];
+};
+
+typedef void gdma_eq_callback(void *context, struct gdma_queue *q,
+			      struct gdma_event *e);
+
+typedef void gdma_cq_callback(void *context, struct gdma_queue *q);
+
+/* The 'head' is the producer index. For SQ/RQ, when the driver posts a WQE
+ * (Note: the WQE size must be a multiple of the 32-byte Basic Unit), the
+ * driver increases the 'head' in BUs rather than in bytes, and notifies
+ * the HW of the updated head. For EQ/CQ, the driver uses the 'head' to track
+ * the HW head, and increases the 'head' by 1 for every processed EQE/CQE.
+ *
+ * The 'tail' is the consumer index for SQ/RQ. After the CQE of the SQ/RQ is
+ * processed, the driver increases the 'tail' to indicate that WQEs have
+ * been consumed by the HW, so the driver can post new WQEs into the SQ/RQ.
+ *
+ * The driver doesn't use the 'tail' for EQ/CQ, because the driver ensures
+ * that the EQ/CQ is big enough so they can't overflow, and the driver uses
+ * the owner bits mechanism to detect if the queue has become empty.
+ */
+struct gdma_queue {
+	struct gdma_dev *gdma_dev;
+
+	enum gdma_queue_type type;
+	u32 id;
+
+	struct gdma_mem_info mem_info;
+
+	void *queue_mem_ptr;
+	u32 queue_size;
+
+	bool monitor_avl_buf;
+
+	u32 head;
+	u32 tail;
+
+	/* Extra fields specific to EQ/CQ. */
+	union {
+		struct {
+			bool disable_needed;
+
+			gdma_eq_callback *callback;
+			void *context;
+
+			unsigned int msix_index;
+
+			u32 log2_throttle_limit;
+
+			/* NAPI data */
+			struct napi_struct napi;
+			int work_done;
+			int budget;
+		} eq;
+
+		struct {
+			gdma_cq_callback *callback;
+			void *context;
+
+			struct gdma_queue *parent; /* For CQ/EQ relationship */
+		} cq;
+	};
+};
+
+struct gdma_queue_spec {
+	enum gdma_queue_type type;
+	bool monitor_avl_buf;
+	unsigned int queue_size;
+
+	/* Extra fields specific to EQ/CQ. */
+	union {
+		struct {
+			gdma_eq_callback *callback;
+			void *context;
+
+			unsigned long log2_throttle_limit;
+		} eq;
+
+		struct {
+			gdma_cq_callback *callback;
+			void *context;
+
+			struct gdma_queue *parent_eq;
+
+		} cq;
+	};
+};
+
+struct gdma_irq_context {
+	void (*handler)(void *arg);
+	void *arg;
+};
+
+struct gdma_context {
+	struct device		*dev;
+
+	unsigned int		max_num_queue;
+	unsigned int		max_num_msix;
+	unsigned int		num_msix_usable;
+	struct gdma_resource	msix_resource;
+	struct gdma_irq_context	*irq_contexts;
+
+	/* This maps a CQ index to the queue structure. */
+	unsigned int		max_num_cq;
+	struct gdma_queue	**cq_table;
+
+	/* Protect eq_test_event and test_event_eq_id  */
+	struct mutex		eq_test_event_mutex;
+	struct completion	eq_test_event;
+	u32			test_event_eq_id;
+
+	void __iomem		*bar0_va;
+	void __iomem		*shm_base;
+	void __iomem		*db_page_base;
+	u32 db_page_size;
+
+	/* Shared memory chanenl (used to bootstrap HWC) */
+	struct shm_channel	shm_channel;
+
+	/* Hardware communication channel (HWC) */
+	struct gdma_dev		hwc;
+
+	/* Azure network adapter */
+	struct gdma_dev		ana;
+};
+
+#define MAX_NUM_GDMA_DEVICES	4
+
+#define ana_to_gdma_context(d) container_of(d, struct gdma_context, ana)
+#define hwc_to_gdma_context(d) container_of(d, struct gdma_context, hwc)
+
+static inline bool gdma_is_ana(struct gdma_dev *gd)
+{
+	return gd->dev_id.type == GDMA_DEVICE_ANA;
+}
+
+static inline bool gdma_is_hwc(struct gdma_dev *gd)
+{
+	return gd->dev_id.type == GDMA_DEVICE_HWC;
+}
+
+static inline struct gdma_context *gdma_dev_to_context(struct gdma_dev *gd)
+{
+	if (gdma_is_hwc(gd))
+		return hwc_to_gdma_context(gd);
+
+	if (gdma_is_ana(gd))
+		return ana_to_gdma_context(gd);
+
+	return NULL;
+}
+
+u8 *gdma_get_wqe_ptr(const struct gdma_queue *wq, u32 wqe_offset);
+u32 gdma_wq_avail_space(struct gdma_queue *wq);
+
+int gdma_test_eq(struct gdma_context *gc, struct gdma_queue *eq);
+
+int gdma_create_hwc_queue(struct gdma_dev *gd,
+			  const struct gdma_queue_spec *spec,
+			  struct gdma_queue **queue_ptr);
+
+int gdma_create_ana_eq(struct gdma_dev *gd, const struct gdma_queue_spec *spec,
+		       struct gdma_queue **queue_ptr);
+
+int gdma_create_ana_wq_cq(struct gdma_dev *gd,
+			  const struct gdma_queue_spec *spec,
+			  struct gdma_queue **queue_ptr);
+
+void gdma_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
+
+int gdma_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
+
+void gdma_arm_cq(struct gdma_queue *cq);
+
+struct gdma_wqe {
+	u32 reserved	:24;
+	u32 last_vbytes	:8;
+
+	union {
+		u32 flags;
+
+		struct {
+			u32 num_sge		:8;
+			u32 inline_oob_size_div4:3;
+			u32 client_oob_in_sgl	:1;
+			u32 consume_credit	:1;
+			u32 fence		:1;
+			u32 reserved_1		:2;
+			u32 client_data_unit	:14;
+			u32 check_sn		:1;
+			u32 sgl_direct		:1;
+		};
+	};
+} __packed;
+
+#define INLINE_OOB_SMALL_SIZE 8
+#define INLINE_OOB_LARGE_SIZE 24
+
+static inline u32 gdma_align_inline_oobsize(u32 oob_size)
+{
+	if (oob_size > INLINE_OOB_SMALL_SIZE)
+		return INLINE_OOB_LARGE_SIZE;
+	else
+		return INLINE_OOB_SMALL_SIZE;
+}
+
+#define MAX_TX_WQE_SIZE 512
+#define MAX_RX_WQE_SIZE 256
+
+struct gdma_cqe {
+	u32 cqe_data[GDMA_COMP_DATA_SIZE / 4];
+
+	union {
+		u32 as_uint32;
+
+		struct {
+			u32 wq_num	: 24;
+			u32 is_sq	: 1;
+			u32 reserved	: 4;
+			u32 owner_bits	: 3;
+		};
+	} cqe_info;
+} __packed;
+
+#define GDMA_CQE_OWNER_BITS 3
+
+#define GDMA_CQE_OWNER_MASK ((1 << GDMA_CQE_OWNER_BITS) - 1)
+
+#define SET_ARM_BIT 1
+
+#define GDMA_EQE_OWNER_BITS 3
+
+union gdma_eqe_info {
+	u32 as_uint32;
+
+	struct {
+		u32 type	: 8;
+		u32 reserved_1	: 8;
+		u32 client_id	: 2;
+		u32 reserved_2	: 11;
+		u32 owner_bits	: 3;
+	};
+} __packed;
+
+#define GDMA_EQE_OWNER_MASK ((1 << GDMA_EQE_OWNER_BITS) - 1)
+#define INITIALIZED_OWNER_BIT(log2_num_entries) (1UL << (log2_num_entries))
+
+struct gdma_eqe {
+	u32 details[GDMA_EVENT_DATA_SIZE / 4];
+	u32 eqe_info;
+} __packed;
+
+#define GDMA_REG_DB_PAGE_OFFSET	8
+#define GDMA_REG_DB_PAGE_SIZE	0x10
+#define GDMA_REG_SHM_OFFSET	0x18
+
+struct gdma_posted_wqe_info {
+	u32 wqe_size_in_bu;
+};
+
+/* GDMA_GENERATE_TEST_EQE */
+struct gdma_generate_test_event_req {
+	struct gdma_req_hdr hdr;
+	u32 queue_index;
+} __packed;
+
+/* GDMA_VERIFY_VF_DRIVER_VERSION */
+enum {
+	GDMA_PROTOCOL_V1	= 1,
+	GDMA_PROTOCOL_FIRST	= GDMA_PROTOCOL_V1,
+	GDMA_PROTOCOL_LAST	= GDMA_PROTOCOL_V1,
+};
+
+struct gdma_verify_ver_req {
+	struct gdma_req_hdr hdr;
+
+	/* Mandatory fields required for protocol establishment */
+	u64 protocol_ver_min;
+	u64 protocol_ver_max;
+	u64 drv_cap_flags1;
+	u64 drv_cap_flags2;
+	u64 drv_cap_flags3;
+	u64 drv_cap_flags4;
+
+	/* Advisory fields */
+	u64 drv_ver;
+	u32 os_type; /* Linux = 0x10; Windows = 0x20; Other = 0x30 */
+	u32 reserved;
+	u32 os_ver_major;
+	u32 os_ver_minor;
+	u32 os_ver_build;
+	u32 os_ver_platform;
+	u64 reserved_2;
+	u8 os_ver_str1[128];
+	u8 os_ver_str2[128];
+	u8 os_ver_str3[128];
+	u8 os_ver_str4[128];
+} __packed;
+
+struct gdma_verify_ver_resp {
+	struct gdma_resp_hdr hdr;
+	u64 gdma_protocol_ver;
+	u64 pf_cap_flags1;
+	u64 pf_cap_flags2;
+	u64 pf_cap_flags3;
+	u64 pf_cap_flags4;
+} __packed;
+
+/* GDMA_QUERY_MAX_RESOURCES */
+struct gdma_query_max_resources_resp {
+	struct gdma_resp_hdr hdr;
+	u32 status;
+	u32 max_sq;
+	u32 max_rq;
+	u32 max_cq;
+	u32 max_eq;
+	u32 max_db;
+	u32 max_mst;
+	u32 max_cq_mod_ctx;
+	u32 max_mod_cq;
+	u32 max_msix;
+} __packed;
+
+/* GDMA_LIST_DEVICES */
+struct gdma_list_devices_resp {
+	struct gdma_resp_hdr hdr;
+	u32 num_of_clients;
+	u32 reserved;
+	struct gdma_dev_id clients[64];
+} __packed;
+
+/* GDMA_REGISTER_DEVICE */
+struct gdma_register_device_resp {
+	struct gdma_resp_hdr hdr;
+	u32 pdid;
+	u32 gpa_mkey;
+	u32 db_id;
+} __packed;
+
+/* GDMA_CREATE_QUEUE */
+struct gdma_create_queue_req {
+	struct gdma_req_hdr hdr;
+	u32 type;
+	u32 reserved1;
+	u32 pdid;
+	u32 doolbell_id;
+	u64 gdma_region;
+	u32 reserved2;
+	u32 queue_size;
+	u32 log2_throttle_limit;
+	u32 eq_pci_msix_index;
+	u32 cq_mod_ctx_id;
+	u32 cq_parent_eq_id;
+	u8  rq_drop_on_overrun;
+	u8  rq_err_on_wqe_overflow;
+	u8  rq_chain_rec_wqes;
+	u8  sq_hw_db;
+} __packed;
+
+struct gdma_create_queue_resp {
+	struct gdma_resp_hdr hdr;
+	u32 queue_index;
+} __packed;
+
+/* GDMA_DISABLE_QUEUE */
+struct gdma_disable_queue_req {
+	struct gdma_req_hdr hdr;
+	u32 type;
+	u32 queue_index;
+	u32 alloc_res_id_on_creation;
+} __packed;
+
+/* GDMA_CREATE_DMA_REGION */
+struct gdma_create_dma_region_req {
+	struct gdma_req_hdr hdr;
+
+	/* The total size of the DMA region */
+	u64 length;
+
+	/* The offset in the first page */
+	u32 offset_in_page;
+
+	/* enum GDMA_PAGE_TYPE */
+	u32 gdma_page_type;
+
+	/* The total number of pages */
+	u32 page_count;
+
+	/* If page_addr_list_len is smaller than page_count,
+	 * the remaining page addresses will be added via the
+	 * message GDMA_DMA_REGION_ADD_PAGES.
+	 */
+	u32 page_addr_list_len;
+	u64 page_addr_list[];
+} __packed;
+
+struct gdma_create_dma_region_resp {
+	struct gdma_resp_hdr hdr;
+	u64 gdma_region;
+} __packed;
+
+/* GDMA_DMA_REGION_ADD_PAGES */
+struct gdma_dma_region_add_pages_req {
+	struct gdma_req_hdr hdr;
+
+	u64 gdma_region;
+
+	u32 page_addr_list_len;
+	u64 page_addr_list[];
+} __packed;
+
+/* GDMA_DESTROY_DMA_REGION */
+struct gdma_destroy_dma_region_req {
+	struct gdma_req_hdr hdr;
+
+	u64 gdma_region;
+} __packed;
+
+int gdma_verify_vf_version(struct pci_dev *pdev);
+
+int gdma_register_device(struct gdma_dev *gd);
+int gdma_deregister_device(struct gdma_dev *gd);
+
+int gdma_post_work_request(struct gdma_queue *wq,
+			   const struct gdma_wqe_request *wqe_req,
+			   struct gdma_posted_wqe_info *wqe_info);
+
+int gdma_post_and_ring(struct gdma_queue *queue,
+		       const struct gdma_wqe_request *wqe,
+		       struct gdma_posted_wqe_info *wqe_info);
+
+int gdma_alloc_res_map(u32 res_avail, struct gdma_resource *r);
+void gdma_free_res_map(struct gdma_resource *r);
+
+void gdma_wq_ring_doorbell(struct gdma_context *gc, struct gdma_queue *queue);
+
+int gdma_alloc_memory(struct gdma_context *gc, unsigned int length,
+		      struct gdma_mem_info *gmi);
+
+void gdma_free_memory(struct gdma_mem_info *gmi);
+
+int gdma_send_request(struct gdma_context *gc, u32 req_len, const void *req,
+		      u32 resp_len, void *resp);
+#endif /* _GDMA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
new file mode 100644
index 000000000000..76496ee68d01
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -0,0 +1,1515 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mana.h"
+
+static u32 gdma_r32(struct gdma_context *g, u64 offset)
+{
+	return readl(g->bar0_va + offset);
+}
+
+static u64 gdma_r64(struct gdma_context *g, u64 offset)
+{
+	return readq(g->bar0_va + offset);
+}
+
+static void gdma_init_registers(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+
+	gc->db_page_size = gdma_r32(gc, GDMA_REG_DB_PAGE_SIZE) & 0xFFFF;
+
+	gc->db_page_base = gc->bar0_va + gdma_r64(gc, GDMA_REG_DB_PAGE_OFFSET);
+
+	gc->shm_base = gc->bar0_va + gdma_r64(gc, GDMA_REG_SHM_OFFSET);
+}
+
+static int gdma_query_max_resources(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	struct gdma_query_max_resources_resp resp = {};
+	struct gdma_general_req req = {};
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_QUERY_MAX_RESOURCES,
+			  sizeof(req), sizeof(resp));
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "Failed to query resource info: %d, 0x%x\n",
+			err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	if (gc->num_msix_usable > resp.max_msix)
+		gc->num_msix_usable = resp.max_msix;
+
+	if (gc->num_msix_usable <= 1)
+		return -ENOSPC;
+
+	/* HWC consumes 1 MSI-X interrupt. */
+	gc->max_num_queue = gc->num_msix_usable - 1;
+
+	if (gc->max_num_queue > resp.max_eq)
+		gc->max_num_queue = resp.max_eq;
+
+	if (gc->max_num_queue > resp.max_cq)
+		gc->max_num_queue = resp.max_cq;
+
+	if (gc->max_num_queue > resp.max_sq)
+		gc->max_num_queue = resp.max_sq;
+
+	if (gc->max_num_queue > resp.max_rq)
+		gc->max_num_queue = resp.max_rq;
+
+	return 0;
+}
+
+static int gdma_detect_devices(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	struct gdma_list_devices_resp resp = {};
+	struct gdma_general_req req = {};
+	struct gdma_dev_id dev;
+	u32 i, max_num_devs;
+	u16 dev_type;
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_LIST_DEVICES, sizeof(req),
+			  sizeof(resp));
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "Failed to detect devices: %d, 0x%x\n", err,
+			resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	max_num_devs = min_t(u32, MAX_NUM_GDMA_DEVICES, resp.num_of_clients);
+
+	for (i = 0; i < max_num_devs; i++) {
+		dev = resp.clients[i];
+		dev_type = dev.type;
+
+		/* HWC is already detected in hwc_create_channel(). */
+		if (dev_type == GDMA_DEVICE_HWC)
+			continue;
+
+		if (dev_type == GDMA_DEVICE_ANA)
+			gc->ana.dev_id = dev;
+	}
+
+	return gc->ana.dev_id.type == 0 ? -ENODEV : 0;
+}
+
+int gdma_send_request(struct gdma_context *gc, u32 req_len, const void *req,
+		      u32 resp_len, void *resp)
+{
+	struct hw_channel_context *hwc = gc->hwc.driver_data;
+
+	return hwc_send_request(hwc, req_len, req, resp_len, resp);
+}
+
+int gdma_alloc_memory(struct gdma_context *gc, unsigned int length,
+		      struct gdma_mem_info *gmi)
+{
+	dma_addr_t dma_handle;
+	void *buf;
+
+	if (length < PAGE_SIZE || !is_power_of_2(length))
+		return -EINVAL;
+
+	gmi->dev = gc->dev;
+	buf = dma_alloc_coherent(gmi->dev, length, &dma_handle,
+				 GFP_KERNEL | __GFP_ZERO);
+	if (!buf)
+		return -ENOMEM;
+
+	gmi->dma_handle = dma_handle;
+	gmi->virt_addr = buf;
+	gmi->length = length;
+
+	return 0;
+}
+
+void gdma_free_memory(struct gdma_mem_info *gmi)
+{
+	dma_free_coherent(gmi->dev, gmi->length, gmi->virt_addr,
+			  gmi->dma_handle);
+}
+
+static int gdma_create_hw_eq(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	struct gdma_create_queue_resp resp = {};
+	struct gdma_create_queue_req req = {};
+	int err;
+
+	if (queue->type != GDMA_EQ)
+		return -EINVAL;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_CREATE_QUEUE,
+			  sizeof(req), sizeof(resp));
+
+	req.hdr.dev_id = queue->gdma_dev->dev_id;
+	req.type = queue->type;
+	req.pdid = queue->gdma_dev->pdid;
+	req.doolbell_id = queue->gdma_dev->doorbell;
+	req.gdma_region = queue->mem_info.gdma_region;
+	req.queue_size = queue->queue_size;
+	req.log2_throttle_limit = queue->eq.log2_throttle_limit;
+	req.eq_pci_msix_index = queue->eq.msix_index;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "Failed to create queue: %d, 0x%x\n", err,
+			resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	queue->id = resp.queue_index;
+	queue->eq.disable_needed = true;
+	queue->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+	return 0;
+}
+
+static int gdma_disable_queue(struct gdma_queue *queue)
+{
+	struct gdma_context *gc = gdma_dev_to_context(queue->gdma_dev);
+	struct gdma_disable_queue_req req = {};
+	struct gdma_general_resp resp = {};
+	int err;
+
+	WARN_ON(queue->type != GDMA_EQ);
+
+	gdma_init_req_hdr(&req.hdr, GDMA_DISABLE_QUEUE,
+			  sizeof(req), sizeof(resp));
+
+	req.hdr.dev_id = queue->gdma_dev->dev_id;
+	req.type = queue->type;
+	req.queue_index =  queue->id;
+	req.alloc_res_id_on_creation = 1;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "Failed to disable queue: %d, 0x%x\n", err,
+			resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	return 0;
+}
+
+#define DOORBELL_OFFSET_SQ	0x0
+#define DOORBELL_OFFSET_RQ	0x400
+#define DOORBELL_OFFSET_CQ	0x800
+#define DOORBELL_OFFSET_EQ	0xFF8
+
+static void gdma_ring_doorbell(struct gdma_context *gc, u32 db_index,
+			       enum gdma_queue_type q_type, u32 qid,
+			       u32 tail_ptr, u8 num_req)
+{
+	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
+	union gdma_doorbell_entry e = {};
+
+	switch (q_type) {
+	case GDMA_EQ:
+		e.eq.id = qid;
+		e.eq.tail_ptr = tail_ptr;
+		e.eq.arm = num_req;
+
+		addr += DOORBELL_OFFSET_EQ;
+		break;
+
+	case GDMA_CQ:
+		e.cq.id = qid;
+		e.cq.tail_ptr = tail_ptr;
+		e.cq.arm = num_req;
+
+		addr += DOORBELL_OFFSET_CQ;
+		break;
+
+	case GDMA_RQ:
+		e.rq.id = qid;
+		e.rq.tail_ptr = tail_ptr;
+		e.rq.wqe_cnt = num_req;
+
+		addr += DOORBELL_OFFSET_RQ;
+		break;
+
+	case GDMA_SQ:
+		e.sq.id = qid;
+		e.sq.tail_ptr = tail_ptr;
+
+		addr += DOORBELL_OFFSET_SQ;
+		break;
+
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	/* Ensure all writes are done before ring doorbell */
+	wmb();
+
+	writeq(e.as_uint64, addr);
+}
+
+void gdma_wq_ring_doorbell(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	gdma_ring_doorbell(gc, queue->gdma_dev->doorbell, queue->type,
+			   queue->id, queue->head * GDMA_WQE_BU_SIZE, 1);
+}
+
+void gdma_arm_cq(struct gdma_queue *cq)
+{
+	struct gdma_context *gc = gdma_dev_to_context(cq->gdma_dev);
+
+	u32 num_cqe = cq->queue_size / GDMA_CQE_SIZE;
+
+	u32 head = cq->head % (num_cqe << GDMA_CQE_OWNER_BITS);
+
+	gdma_ring_doorbell(gc, cq->gdma_dev->doorbell, cq->type, cq->id, head,
+			   SET_ARM_BIT);
+}
+
+static void gdma_process_eqe(struct gdma_queue *eq)
+{
+	struct gdma_context *gc = gdma_dev_to_context(eq->gdma_dev);
+	u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
+	struct gdma_eqe *eq_eqe_ptr = eq->queue_mem_ptr;
+	union gdma_eqe_info eqe_info;
+	enum gdma_eqe_type type;
+	struct gdma_event event;
+	struct gdma_queue *cq;
+	struct gdma_eqe *eqe;
+	u32 cq_id;
+
+	eqe = &eq_eqe_ptr[head];
+	eqe_info.as_uint32 = eqe->eqe_info;
+	type = eqe_info.type;
+
+	if ((type >= GDMA_EQE_APP_START && type <= GDMA_EQE_APP_END) ||
+	    type == GDMA_EQE_SOC_TO_VF_EVENT ||
+	    type == GDMA_EQE_HWC_INIT_EQ_ID_DB ||
+	    type == GDMA_EQE_HWC_INIT_DATA || type == GDMA_EQE_HWC_INIT_DONE) {
+		if (eq->eq.callback) {
+			event.type = type;
+			memcpy(&event.details, &eqe->details,
+			       GDMA_EVENT_DATA_SIZE);
+
+			eq->eq.callback(eq->eq.context, eq, &event);
+		}
+
+		return;
+	}
+
+	switch (type) {
+	case GDMA_EQE_COMPLETION:
+		cq_id = eqe->details[0] & 0xFFFFFF;
+		if (WARN_ON(cq_id >= gc->max_num_cq))
+			break;
+
+		cq = gc->cq_table[cq_id];
+		if (WARN_ON(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
+			break;
+
+		if (cq->cq.callback)
+			cq->cq.callback(cq->cq.context, cq);
+
+		break;
+
+	case GDMA_EQE_TEST_EVENT:
+		gc->test_event_eq_id = eq->id;
+		complete(&gc->eq_test_event);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static void gdma_process_eq_events(void *arg)
+{
+	u32 owner_bits, new_bits, old_bits;
+	union gdma_eqe_info eqe_info;
+	struct gdma_eqe *eq_eqe_ptr;
+	struct gdma_queue *eq = arg;
+	struct gdma_context *gc;
+	struct gdma_eqe *eqe;
+	unsigned int arm_bit;
+	u32 head, num_eqe;
+	int i;
+
+	num_eqe = eq->queue_size / GDMA_EQE_SIZE;
+	eq_eqe_ptr = eq->queue_mem_ptr;
+
+	/* Process up to 5 EQEs at a time, and update the HW head. */
+	for (i = 0; i < 5; i++) {
+		eqe = &eq_eqe_ptr[eq->head % num_eqe];
+		eqe_info.as_uint32 = eqe->eqe_info;
+
+		new_bits = (eq->head / num_eqe) & GDMA_EQE_OWNER_MASK;
+		old_bits = (eq->head / num_eqe - 1) & GDMA_EQE_OWNER_MASK;
+
+		owner_bits = eqe_info.owner_bits;
+
+		if (owner_bits == old_bits)
+			break;
+
+		if (owner_bits != new_bits) {
+			dev_err(gc->dev, "EQ %d: overflow detected\n", eq->id);
+			break;
+		}
+
+		gdma_process_eqe(eq);
+
+		eq->head++;
+	}
+
+	/* Always rearm the EQ for HWC. For ANA, rearm it when NAPI is done. */
+	if (gdma_is_hwc(eq->gdma_dev)) {
+		arm_bit = SET_ARM_BIT;
+	} else if (eq->eq.work_done < eq->eq.budget &&
+		   napi_complete_done(&eq->eq.napi, eq->eq.work_done)) {
+		arm_bit = SET_ARM_BIT;
+	} else {
+		arm_bit = 0;
+	}
+
+	head = eq->head % (num_eqe << GDMA_EQE_OWNER_BITS);
+
+	gc = gdma_dev_to_context(eq->gdma_dev);
+
+	gdma_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id, head,
+			   arm_bit);
+}
+
+static int ana_poll(struct napi_struct *napi, int budget)
+{
+	struct gdma_queue *eq = container_of(napi, struct gdma_queue, eq.napi);
+
+	eq->eq.work_done = 0;
+	eq->eq.budget = budget;
+
+	gdma_process_eq_events(eq);
+
+	return min(eq->eq.work_done, budget);
+}
+
+static void gdma_schedule_napi(void *arg)
+{
+	struct gdma_queue *eq = arg;
+	struct napi_struct *napi;
+
+	napi = &eq->eq.napi;
+	napi_schedule_irqoff(napi);
+}
+
+static int gdma_register_irq(struct gdma_queue *queue)
+{
+	struct gdma_dev *gd = queue->gdma_dev;
+	bool is_ana = gdma_is_ana(gd);
+	struct gdma_irq_context *gic;
+
+	struct gdma_context *gc;
+	struct gdma_resource *r;
+	unsigned int msi_index;
+	unsigned long flags;
+	int err;
+
+	gc = gdma_dev_to_context(gd);
+	r = &gc->msix_resource;
+
+	spin_lock_irqsave(&r->lock, flags);
+
+	msi_index = find_first_zero_bit(r->map, r->size);
+	if (msi_index >= r->size) {
+		err = -ENOSPC;
+	} else {
+		bitmap_set(r->map, msi_index, 1);
+		queue->eq.msix_index = msi_index;
+		err = 0;
+	}
+
+	spin_unlock_irqrestore(&r->lock, flags);
+
+	if (err)
+		return err;
+
+	WARN_ON(msi_index >= gc->num_msix_usable);
+
+	gic = &gc->irq_contexts[msi_index];
+
+	if (is_ana) {
+		netif_napi_add(gd->driver_data, &queue->eq.napi, ana_poll,
+			       NAPI_POLL_WEIGHT);
+
+		napi_enable(&queue->eq.napi);
+	}
+
+	WARN_ON(gic->handler || gic->arg);
+
+	gic->arg = queue;
+	gic->handler = is_ana ? gdma_schedule_napi : gdma_process_eq_events;
+
+	return 0;
+}
+
+static void gdma_deregiser_irq(struct gdma_queue *queue)
+{
+	struct gdma_dev *gd = queue->gdma_dev;
+	struct gdma_irq_context *gic;
+	struct gdma_context *gc;
+	struct gdma_resource *r;
+	unsigned int msix_index;
+	unsigned long flags;
+
+	/* At most num_online_cpus() + 1 interrupts are used. */
+	msix_index = queue->eq.msix_index;
+	if (WARN_ON(msix_index > num_online_cpus()))
+		return;
+
+	gc = gdma_dev_to_context(gd);
+	r = &gc->msix_resource;
+
+	gic = &gc->irq_contexts[msix_index];
+
+	WARN_ON(!gic->handler || !gic->arg);
+	gic->handler = NULL;
+	gic->arg = NULL;
+
+	spin_lock_irqsave(&r->lock, flags);
+	bitmap_clear(r->map, msix_index, 1);
+	spin_unlock_irqrestore(&r->lock, flags);
+
+	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
+}
+
+int gdma_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
+{
+	struct gdma_generate_test_event_req req = {};
+	struct gdma_general_resp resp = {};
+	struct device *dev = gc->dev;
+	int err;
+
+	mutex_lock(&gc->eq_test_event_mutex);
+
+	init_completion(&gc->eq_test_event);
+	gc->test_event_eq_id = INVALID_QUEUE_ID;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_GENERATE_TEST_EQE,
+			  sizeof(req), sizeof(resp));
+
+	req.hdr.dev_id = eq->gdma_dev->dev_id;
+	req.queue_index = eq->id;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err) {
+		dev_err(dev, "test_eq failed: %d\n", err);
+		goto out;
+	}
+
+	err = -EPROTO;
+
+	if (resp.hdr.status) {
+		dev_err(dev, "test_eq failed: 0x%x\n", resp.hdr.status);
+		goto out;
+	}
+
+	if (!wait_for_completion_timeout(&gc->eq_test_event, 30 * HZ)) {
+		dev_err(dev, "test_eq timed out on queue %d\n", eq->id);
+		goto out;
+	}
+
+	if (eq->id != gc->test_event_eq_id) {
+		dev_err(dev, "test_eq got an event on wrong queue %d (%d)\n",
+			gc->test_event_eq_id, eq->id);
+		goto out;
+	}
+
+	err = 0;
+out:
+	mutex_unlock(&gc->eq_test_event_mutex);
+	return err;
+}
+
+static void gdma_destroy_eq(struct gdma_context *gc, bool flush_evenets,
+			    struct gdma_queue *queue)
+{
+	int err;
+
+	if (flush_evenets) {
+		err = gdma_test_eq(gc, queue);
+		if (err)
+			dev_warn(gc->dev, "Failed to flush EQ: %d\n", err);
+	}
+
+	gdma_deregiser_irq(queue);
+
+	if (gdma_is_ana(queue->gdma_dev)) {
+		napi_disable(&queue->eq.napi);
+		netif_napi_del(&queue->eq.napi);
+	}
+
+	if (queue->eq.disable_needed)
+		gdma_disable_queue(queue);
+}
+
+static int gdma_create_eq(struct gdma_dev *gd,
+			  const struct gdma_queue_spec *spec, bool create_hwq,
+			  struct gdma_queue *queue)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	struct device *dev = gc->dev;
+	u32 log2_num_entries;
+	int err;
+
+	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
+
+	log2_num_entries = ilog2(queue->queue_size / GDMA_EQE_SIZE);
+
+	if (spec->eq.log2_throttle_limit > log2_num_entries) {
+		dev_err(dev, "EQ throttling limit (%lu) > maximum EQE (%u)\n",
+			spec->eq.log2_throttle_limit, log2_num_entries);
+		return -EINVAL;
+	}
+
+	err = gdma_register_irq(queue);
+	if (err) {
+		dev_err(dev, "Failed to register irq: %d\n", err);
+		return err;
+	}
+
+	queue->eq.callback = spec->eq.callback;
+	queue->eq.context = spec->eq.context;
+	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
+
+	queue->eq.log2_throttle_limit = spec->eq.log2_throttle_limit ?: 1;
+
+	if (create_hwq) {
+		err = gdma_create_hw_eq(gc, queue);
+		if (err)
+			goto out;
+
+		err = gdma_test_eq(gc, queue);
+		if (err)
+			goto out;
+	}
+
+	return 0;
+out:
+	dev_err(dev, "Failed to create EQ: %d\n", err);
+	gdma_destroy_eq(gc, false, queue);
+	return err;
+}
+
+static void gdma_create_cq(const struct gdma_queue_spec *spec,
+			   struct gdma_queue *queue)
+{
+	u32 log2_num_entries = ilog2(spec->queue_size / GDMA_CQE_SIZE);
+
+	queue->head = queue->head | INITIALIZED_OWNER_BIT(log2_num_entries);
+	queue->cq.parent = spec->cq.parent_eq;
+	queue->cq.context = spec->cq.context;
+	queue->cq.callback = spec->cq.callback;
+}
+
+static void gdma_destroy_cq(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	u32 id = queue->id;
+
+	if (id >= gc->max_num_cq)
+		return;
+
+	if (!gc->cq_table[id])
+		return;
+
+	gc->cq_table[id] = NULL;
+}
+
+int gdma_create_hwc_queue(struct gdma_dev *gd,
+			  const struct gdma_queue_spec *spec,
+			  struct gdma_queue **queue_ptr)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	struct gdma_mem_info *gmi;
+	struct gdma_queue *queue;
+	int err;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+	if (!queue)
+		return -ENOMEM;
+
+	gmi = &queue->mem_info;
+	err = gdma_alloc_memory(gc, spec->queue_size, gmi);
+	if (err)
+		return err;
+
+	queue->head = 0;
+	queue->tail = 0;
+	queue->queue_mem_ptr = gmi->virt_addr;
+	queue->queue_size = spec->queue_size;
+	queue->monitor_avl_buf = spec->monitor_avl_buf;
+
+	queue->type = spec->type;
+	queue->gdma_dev = gd;
+
+	if (spec->type == GDMA_EQ)
+		err = gdma_create_eq(gd, spec, false, queue);
+	else if (spec->type == GDMA_CQ)
+		gdma_create_cq(spec, queue);
+
+	if (err)
+		goto out;
+
+	*queue_ptr = queue;
+	return 0;
+
+out:
+	gdma_free_memory(gmi);
+	kfree(queue);
+	return err;
+}
+
+static void gdma_destroy_dma_region(struct gdma_context *gc, u64 gdma_region)
+{
+	struct gdma_destroy_dma_region_req req = {};
+	struct gdma_general_resp resp = {};
+	int err;
+
+	if (gdma_region == GDMA_INVALID_DMA_REGION)
+		return;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_DESTROY_DMA_REGION, sizeof(req),
+			  sizeof(resp));
+	req.gdma_region = gdma_region;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status)
+		dev_err(gc->dev, "Failed to destroy DMA region: %d, 0x%x\n",
+			err, resp.hdr.status);
+}
+
+static int gdma_create_dma_region(struct gdma_dev *gd,
+				  struct gdma_mem_info *gmi)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	unsigned int num_page = gmi->length / PAGE_SIZE;
+	struct gdma_create_dma_region_req *req = NULL;
+	struct gdma_create_dma_region_resp resp = {};
+	struct hw_channel_context *hwc;
+	u32 length = gmi->length;
+	u32 req_msg_size;
+	int err;
+	int i;
+
+	if (length < PAGE_SIZE || !is_power_of_2(length))
+		return -EINVAL;
+
+	if (offset_in_page(gmi->virt_addr) != 0)
+		return -EINVAL;
+
+	hwc = gc->hwc.driver_data;
+	req_msg_size = sizeof(*req) + num_page * sizeof(u64);
+	if (req_msg_size > hwc->max_req_msg_size)
+		return -EINVAL;
+
+	req = kzalloc(req_msg_size, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	gdma_init_req_hdr(&req->hdr, GDMA_CREATE_DMA_REGION,
+			  req_msg_size, sizeof(resp));
+	req->length = length;
+	req->offset_in_page = 0;
+	req->gdma_page_type = GDMA_PAGE_TYPE_4K;
+	req->page_count = num_page;
+	req->page_addr_list_len = num_page;
+
+	for (i = 0; i < num_page; i++)
+		req->page_addr_list[i] = gmi->dma_handle +  i * PAGE_SIZE;
+
+	err = gdma_send_request(gc, req_msg_size, req, sizeof(resp), &resp);
+	if (err)
+		goto out;
+
+	if (resp.hdr.status || resp.gdma_region == GDMA_INVALID_DMA_REGION) {
+		dev_err(gc->dev, "Failed to create DMA region: 0x%x\n",
+			resp.hdr.status);
+		err = -EPROTO;
+		goto out;
+	}
+
+	gmi->gdma_region = resp.gdma_region;
+
+out:
+	kfree(req);
+	return err;
+}
+
+int gdma_create_ana_eq(struct gdma_dev *gd, const struct gdma_queue_spec *spec,
+		       struct gdma_queue **queue_ptr)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	struct gdma_mem_info *gmi;
+	struct gdma_queue *queue;
+	int err;
+
+	if (spec->type != GDMA_EQ)
+		return -EINVAL;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+	if (!queue)
+		return -ENOMEM;
+
+	gmi = &queue->mem_info;
+	err = gdma_alloc_memory(gc, spec->queue_size, gmi);
+	if (err)
+		return err;
+
+	err = gdma_create_dma_region(gd, gmi);
+	if (err)
+		goto out;
+
+	queue->head = 0;
+	queue->tail = 0;
+	queue->queue_mem_ptr = gmi->virt_addr;
+	queue->queue_size = spec->queue_size;
+	queue->monitor_avl_buf = spec->monitor_avl_buf;
+
+	queue->type = spec->type;
+	queue->gdma_dev = gd;
+
+	err = gdma_create_eq(gd, spec, true, queue);
+	if (err)
+		goto out;
+
+	*queue_ptr = queue;
+	return 0;
+out:
+	gdma_free_memory(gmi);
+	kfree(queue);
+	return err;
+}
+
+int gdma_create_ana_wq_cq(struct gdma_dev *gd,
+			  const struct gdma_queue_spec *spec,
+			  struct gdma_queue **queue_ptr)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	struct gdma_mem_info *gmi;
+	struct gdma_queue *queue;
+	int err;
+
+	if (spec->type != GDMA_CQ && spec->type != GDMA_SQ &&
+	    spec->type != GDMA_RQ)
+		return -EINVAL;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+	if (!queue)
+		return -ENOMEM;
+
+	gmi = &queue->mem_info;
+	err = gdma_alloc_memory(gc, spec->queue_size, gmi);
+	if (err)
+		return err;
+
+	err = gdma_create_dma_region(gd, gmi);
+	if (err)
+		goto out;
+
+	queue->head = 0;
+	queue->tail = 0;
+	queue->queue_mem_ptr = gmi->virt_addr;
+	queue->queue_size = spec->queue_size;
+	queue->monitor_avl_buf = spec->monitor_avl_buf;
+
+	queue->type = spec->type;
+	queue->gdma_dev = gd;
+
+	if (spec->type == GDMA_CQ)
+		gdma_create_cq(spec, queue);
+
+	*queue_ptr = queue;
+	return 0;
+
+out:
+	gdma_free_memory(gmi);
+	kfree(queue);
+	return err;
+}
+
+void gdma_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	struct gdma_mem_info *gmi = &queue->mem_info;
+
+	switch (queue->type) {
+	case GDMA_EQ:
+		gdma_destroy_eq(gc, queue->eq.disable_needed, queue);
+		break;
+
+	case GDMA_CQ:
+		gdma_destroy_cq(gc, queue);
+		break;
+
+	case GDMA_RQ:
+		break;
+
+	case GDMA_SQ:
+		break;
+
+	default:
+		dev_err(gc->dev, "Can't destroy unknown queue: type=%d\n",
+			queue->type);
+		return;
+	}
+
+	gdma_destroy_dma_region(gc, gmi->gdma_region);
+
+	gdma_free_memory(gmi);
+
+	kfree(queue);
+}
+
+int gdma_verify_vf_version(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	struct gdma_verify_ver_resp resp = {};
+	struct gdma_verify_ver_req req = {};
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
+			  sizeof(req), sizeof(resp));
+
+	req.protocol_ver_min = GDMA_PROTOCOL_FIRST;
+	req.protocol_ver_max = GDMA_PROTOCOL_LAST;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "VfVerifyVersionOutput: %d, status=0x%x\n",
+			err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	return 0;
+}
+
+int gdma_register_device(struct gdma_dev *gd)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	struct gdma_register_device_resp resp = {};
+	struct gdma_general_req req = {};
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_REGISTER_DEVICE, sizeof(req),
+			  sizeof(resp));
+
+	req.hdr.dev_id = gd->dev_id;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "gdma_register_device_resp failed: %d, 0x%x\n",
+			err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	gd->pdid = resp.pdid;
+	gd->gpa_mkey = resp.gpa_mkey;
+	gd->doorbell = resp.db_id;
+
+	return 0;
+}
+
+int gdma_deregister_device(struct gdma_dev *gd)
+{
+	struct gdma_context *gc = gdma_dev_to_context(gd);
+	struct gdma_general_resp resp = {};
+	struct gdma_general_req req = {};
+	int err;
+
+	if (WARN_ON(gd->pdid == INVALID_PDID))
+		return -EINVAL;
+
+	gdma_init_req_hdr(&req.hdr, GDMA_DEREGISTER_DEVICE, sizeof(req),
+			  sizeof(resp));
+
+	req.hdr.dev_id = gd->dev_id;
+
+	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev, "Failed to deregister device: %d, 0x%x\n",
+			err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	gd->pdid = INVALID_PDID;
+	gd->doorbell = INVALID_DOORBELL;
+	gd->gpa_mkey = INVALID_MEM_KEY;
+
+	return 0;
+}
+
+static u32 gdma_calc_sgl_size(const struct gdma_wqe_request *wqe_req)
+{
+	u32 sgl_data_size = 0;
+	int i;
+
+	if (wqe_req->flags & GDMA_WR_SGL_DIRECT) {
+		for (i = 0; i < wqe_req->num_sge; i++)
+			sgl_data_size += wqe_req->sgl[i].size;
+	} else {
+		sgl_data_size += sizeof(struct gdma_sge) *
+				 max_t(u32, 1, wqe_req->num_sge);
+	}
+
+	return sgl_data_size;
+}
+
+u32 gdma_wq_avail_space(struct gdma_queue *wq)
+{
+	u32 used_space = (wq->head - wq->tail) * GDMA_WQE_BU_SIZE;
+	u32 wq_size = wq->queue_size;
+
+	WARN_ON(used_space > wq_size);
+
+	return wq_size - used_space;
+}
+
+u8 *gdma_get_wqe_ptr(const struct gdma_queue *wq, u32 wqe_offset)
+{
+	u32 offset = (wqe_offset * GDMA_WQE_BU_SIZE) & (wq->queue_size - 1);
+
+	WARN_ON((offset + GDMA_WQE_BU_SIZE) > wq->queue_size);
+
+	return wq->queue_mem_ptr + offset;
+}
+
+static u32 gdma_write_client_oob(u8 *wqe_ptr,
+				 const struct gdma_wqe_request *wqe_req,
+				 enum gdma_queue_type q_type,
+				 u32 client_oob_size, u32 sgl_data_size)
+{
+	bool pad_data = !!(wqe_req->flags & GDMA_WR_PAD_DATA_BY_FIRST_SGE);
+	bool sgl_direct = !!(wqe_req->flags & GDMA_WR_SGL_DIRECT);
+	bool oob_in_sgl = !!(wqe_req->flags & GDMA_WR_OOB_IN_SGL);
+	struct gdma_wqe *header = (struct gdma_wqe *)wqe_ptr;
+	u8 *ptr;
+
+	memset(header, 0, sizeof(struct gdma_wqe));
+
+	WARN_ON(client_oob_size != INLINE_OOB_SMALL_SIZE &&
+		client_oob_size != INLINE_OOB_LARGE_SIZE);
+
+	if (sgl_direct) {
+		header->num_sge = sgl_data_size / sizeof(struct gdma_sge);
+		header->last_vbytes = sgl_data_size % sizeof(struct gdma_sge);
+
+		if (header->last_vbytes)
+			header->num_sge++;
+	} else {
+		header->num_sge = wqe_req->num_sge;
+	}
+
+	/* Support for empty SGL: account for the dummy SGE to be written. */
+	if (wqe_req->num_sge == 0)
+		header->num_sge = 1;
+
+	header->inline_oob_size_div4 = client_oob_size / sizeof(u32);
+
+	if (oob_in_sgl) {
+		WARN_ON(!pad_data || wqe_req->num_sge <= 0);
+
+		header->client_oob_in_sgl = 1;
+
+		if (wqe_req->num_sge == 1) {
+			/* Support for empty SGL with oob_in_sgl */
+			header->num_sge = 2;
+		}
+
+		if (pad_data)
+			header->last_vbytes = wqe_req->sgl[0].size;
+	}
+
+	if (q_type == GDMA_SQ)
+		header->client_data_unit = wqe_req->client_data_unit;
+
+	header->consume_credit = !!(wqe_req->flags & GDMA_WR_CONSUME_CREDIT);
+	header->fence = !!(wqe_req->flags & GDMA_WR_FENCE);
+	header->check_sn = !!(wqe_req->flags & GDMA_WR_CHECK_SN);
+	header->sgl_direct = sgl_direct;
+
+	/* The size of gdma_wqe + client_oob_size must be less than or equal
+	 * to the basic unit, so the pointer here won't be beyond the queue
+	 * buffer boundary.
+	 */
+	ptr = wqe_ptr + sizeof(header);
+
+	if (wqe_req->inline_oob_data && wqe_req->inline_oob_size > 0) {
+		memcpy(ptr, wqe_req->inline_oob_data, wqe_req->inline_oob_size);
+
+		if (client_oob_size > wqe_req->inline_oob_size)
+			memset(ptr + wqe_req->inline_oob_size, 0,
+			       client_oob_size - wqe_req->inline_oob_size);
+	}
+
+	return sizeof(header) + client_oob_size;
+}
+
+static u32 gdma_write_sgl(struct gdma_queue *wq, u8 *wqe_ptr,
+			  const struct gdma_wqe_request *wqe_req)
+{
+	bool sgl_direct = !!(wqe_req->flags & GDMA_WR_SGL_DIRECT);
+	bool oob_in_sgl = !!(wqe_req->flags & GDMA_WR_OOB_IN_SGL);
+	const struct gdma_sge *sgl = wqe_req->sgl;
+	u32 queue_size = wq->queue_size;
+	u32 num_sge = wqe_req->num_sge;
+	struct gdma_sge dummy_sgl[2];
+	u8 *wq_base_ptr, *wq_end_ptr;
+	u32 size_to_queue_end;
+	const u8 *address;
+	u32 sgl_size;
+	u32 size;
+	int i;
+
+	if (num_sge == 0 || (oob_in_sgl && num_sge == 1)) {
+		/* Per spec, the case of an empty SGL should be handled as
+		 * follows to avoid corrupted WQE errors:
+		 * Write one dummy SGL entry;
+		 * Set the address to 1, leave the rest as 0.
+		 */
+		dummy_sgl[num_sge].address = 1;
+		dummy_sgl[num_sge].size = 0;
+		dummy_sgl[num_sge].mem_key = 0;
+		if (num_sge == 1)
+			memcpy(dummy_sgl, wqe_req->sgl,
+			       sizeof(struct gdma_sge));
+
+		num_sge++;
+		sgl = dummy_sgl;
+		sgl_direct = false;
+	}
+
+	sgl_size = 0;
+	wq_base_ptr = wq->queue_mem_ptr;
+	wq_end_ptr = wq_base_ptr + queue_size;
+	size_to_queue_end = (u32)(wq_end_ptr - wqe_ptr);
+
+	if (sgl_direct) {
+		for (i = 0; i < num_sge; i++) {
+			address = (u8 *)wqe_req->sgl[i].address;
+			size = wqe_req->sgl[i].size;
+
+			if (size_to_queue_end < size) {
+				memcpy(wqe_ptr, address, size_to_queue_end);
+				wqe_ptr = wq_base_ptr;
+				address += size_to_queue_end;
+				size -= size_to_queue_end;
+			}
+
+			memcpy(wqe_ptr, address, size);
+
+			wqe_ptr += size;
+
+			if (wqe_ptr >= wq_end_ptr)
+				wqe_ptr -= queue_size;
+
+			size_to_queue_end = (u32)(wq_end_ptr - wqe_ptr);
+
+			sgl_size += size;
+		}
+	} else {
+		address = (u8 *)sgl;
+
+		size = sizeof(struct gdma_sge) * num_sge;
+
+		if (size_to_queue_end < size) {
+			memcpy(wqe_ptr, address, size_to_queue_end);
+
+			wqe_ptr = wq_base_ptr;
+			address += size_to_queue_end;
+			size -= size_to_queue_end;
+		}
+
+		memcpy(wqe_ptr, address, size);
+
+		sgl_size = size;
+	}
+
+	return sgl_size;
+}
+
+int gdma_post_work_request(struct gdma_queue *wq,
+			   const struct gdma_wqe_request *wqe_req,
+			   struct gdma_posted_wqe_info *wqe_info)
+{
+	bool sgl_direct = !!(wqe_req->flags & GDMA_WR_SGL_DIRECT);
+	bool oob_in_sgl = !!(wqe_req->flags & GDMA_WR_OOB_IN_SGL);
+	struct gdma_context *gc;
+	u32 client_oob_size;
+	u32 sgl_data_size;
+	u32 max_wqe_size;
+	u32 wqe_size;
+	u8 *wqe_ptr;
+
+	if (sgl_direct && (wq->type != GDMA_SQ || oob_in_sgl))
+		return -EINVAL;
+
+	if (wqe_req->inline_oob_size > INLINE_OOB_LARGE_SIZE)
+		return -EINVAL;
+
+	if (oob_in_sgl && wqe_req->num_sge == 0)
+		return -EINVAL;
+
+	client_oob_size = gdma_align_inline_oobsize(wqe_req->inline_oob_size);
+
+	sgl_data_size = gdma_calc_sgl_size(wqe_req);
+
+	wqe_size = ALIGN(sizeof(struct gdma_wqe) + client_oob_size +
+			 sgl_data_size, GDMA_WQE_BU_SIZE);
+
+	if (wq->type == GDMA_RQ)
+		max_wqe_size = GDMA_MAX_RQE_SIZE;
+	else
+		max_wqe_size = GDMA_MAX_SQE_SIZE;
+
+	if (wqe_size > max_wqe_size)
+		return -EINVAL;
+
+	if (wq->monitor_avl_buf && wqe_size > gdma_wq_avail_space(wq)) {
+		gc = gdma_dev_to_context(wq->gdma_dev);
+		dev_err(gc->dev, "unsuccessful flow control!\n");
+		return -ENOSPC;
+	}
+
+	if (wqe_info)
+		wqe_info->wqe_size_in_bu = wqe_size / GDMA_WQE_BU_SIZE;
+
+	wqe_ptr = gdma_get_wqe_ptr(wq, wq->head);
+
+	wqe_ptr += gdma_write_client_oob(wqe_ptr, wqe_req, wq->type,
+					 client_oob_size, sgl_data_size);
+
+	if (wqe_ptr >= (u8 *)wq->queue_mem_ptr + wq->queue_size)
+		wqe_ptr -= wq->queue_size;
+
+	gdma_write_sgl(wq, wqe_ptr, wqe_req);
+
+	wq->head += wqe_size / GDMA_WQE_BU_SIZE;
+
+	return 0;
+}
+
+int gdma_post_and_ring(struct gdma_queue *queue,
+		       const struct gdma_wqe_request *wqe,
+		       struct gdma_posted_wqe_info *wqe_info)
+{
+	struct gdma_context *gc = gdma_dev_to_context(queue->gdma_dev);
+
+	int err = gdma_post_work_request(queue, wqe, wqe_info);
+
+	if (err)
+		return err;
+
+	gdma_wq_ring_doorbell(gc, queue);
+
+	return 0;
+}
+
+static int gdma_read_cqe(struct gdma_queue *cq, struct gdma_comp *comp)
+{
+	unsigned int cq_num_cqe = cq->queue_size / sizeof(struct gdma_cqe);
+	struct gdma_cqe *cq_cqe = cq->queue_mem_ptr;
+	u32 owner_bits, new_bits, old_bits;
+	struct gdma_cqe *cqe;
+
+	new_bits = (cq->head / cq_num_cqe) & GDMA_CQE_OWNER_MASK;
+	old_bits = (cq->head / cq_num_cqe - 1) & GDMA_CQE_OWNER_MASK;
+
+	cqe = &cq_cqe[cq->head % cq_num_cqe];
+	owner_bits = cqe->cqe_info.owner_bits;
+
+	/* Return 0 if no new entry. */
+	if (owner_bits == old_bits)
+		return 0;
+
+	/* Return -1 if overflow detected. */
+	if (owner_bits != new_bits)
+		return -1;
+
+	comp->wq_num = cqe->cqe_info.wq_num;
+	comp->is_sq = cqe->cqe_info.is_sq;
+	memcpy(comp->cqe_data, cqe->cqe_data, GDMA_COMP_DATA_SIZE);
+
+	return 1;
+}
+
+int gdma_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe)
+{
+	int cqe_idx;
+	int ret;
+
+	for (cqe_idx = 0; cqe_idx < num_cqe; cqe_idx++) {
+		ret = gdma_read_cqe(cq, &comp[cqe_idx]);
+
+		if (ret < 0) {
+			cq->head -= cqe_idx;
+			return ret;
+		}
+
+		if (ret == 0)
+			break;
+
+		cq->head++;
+	}
+
+	return cqe_idx;
+}
+
+static irqreturn_t gdma_intr(int irq, void *arg)
+{
+	struct gdma_irq_context *gic = arg;
+
+	if (gic->handler)
+		gic->handler(gic->arg);
+
+	return IRQ_HANDLED;
+}
+
+int gdma_alloc_res_map(u32 res_avail, struct gdma_resource *r)
+{
+	r->map = bitmap_zalloc(res_avail, GFP_KERNEL);
+	if (!r->map)
+		return -ENOMEM;
+
+	r->size = res_avail;
+	spin_lock_init(&r->lock);
+
+	return 0;
+}
+
+void gdma_free_res_map(struct gdma_resource *r)
+{
+	bitmap_free(r->map);
+	r->map = NULL;
+	r->size = 0;
+}
+
+static int gdma_setup_irqs(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	struct gdma_irq_context *gic;
+	unsigned int max_irqs;
+	int nvec, irq;
+	int err, i, j;
+
+	max_irqs = min_t(uint, ANA_MAX_NUM_QUEUE + 1, num_online_cpus() + 1);
+	nvec = pci_alloc_irq_vectors(pdev, 2, max_irqs, PCI_IRQ_MSIX);
+	if (nvec < 0)
+		return nvec;
+
+	gc->irq_contexts = kcalloc(nvec, sizeof(struct gdma_irq_context),
+				   GFP_KERNEL);
+	if (!gc->irq_contexts) {
+		err = -ENOMEM;
+		goto free_irq_vector;
+	}
+
+	for (i = 0; i < nvec; i++) {
+		gic = &gc->irq_contexts[i];
+		gic->handler = NULL;
+		gic->arg = NULL;
+
+		irq = pci_irq_vector(pdev, i);
+		if (irq < 0) {
+			err = irq;
+			goto free_irq;
+		}
+
+		err = request_irq(irq, gdma_intr, 0, "gdma_intr", gic);
+		if (err)
+			goto free_irq;
+	}
+
+	err = gdma_alloc_res_map(nvec, &gc->msix_resource);
+	if (err)
+		goto free_irq;
+
+	gc->max_num_msix = nvec;
+	gc->num_msix_usable = nvec;
+
+	return 0;
+
+free_irq:
+	for (j = i - 1; j >= 0; j--) {
+		irq = pci_irq_vector(pdev, j);
+		gic = &gc->irq_contexts[j];
+		free_irq(irq, gic);
+	}
+
+	kfree(gc->irq_contexts);
+	gc->irq_contexts = NULL;
+free_irq_vector:
+	pci_free_irq_vectors(pdev);
+	return err;
+}
+
+static void gdma_remove_irqs(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	struct gdma_irq_context *gic;
+	int irq, i;
+
+	if (gc->max_num_msix < 1)
+		return;
+
+	gdma_free_res_map(&gc->msix_resource);
+
+	for (i = 0; i < gc->max_num_msix; i++) {
+		irq = pci_irq_vector(pdev, i);
+		if (WARN_ON(irq < 0))
+			continue;
+
+		gic = &gc->irq_contexts[i];
+		free_irq(irq, gic);
+	}
+
+	pci_free_irq_vectors(pdev);
+
+	gc->max_num_msix = 0;
+	gc->num_msix_usable = 0;
+	kfree(gc->irq_contexts);
+	gc->irq_contexts = NULL;
+}
+
+static int gdma_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct gdma_context *gc;
+	void __iomem *bar0_va;
+	int bar = 0;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		return -ENXIO;
+
+	pci_set_master(pdev);
+
+	err = pci_request_regions(pdev, "gdma");
+	if (err)
+		goto disable_dev;
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err)
+		goto release_region;
+
+	err = -ENOMEM;
+	gc = vzalloc(sizeof(*gc));
+	if (!gc)
+		goto release_region;
+
+	bar0_va = pci_iomap(pdev, bar, 0);
+	if (!bar0_va)
+		goto free_gc;
+
+	gc->bar0_va = bar0_va;
+	gc->dev = &pdev->dev;
+
+	pci_set_drvdata(pdev, gc);
+
+	gdma_init_registers(pdev);
+
+	shm_channel_init(&gc->shm_channel, gc->dev, gc->shm_base);
+
+	err = gdma_setup_irqs(pdev);
+	if (err)
+		goto unmap_bar;
+
+	mutex_init(&gc->eq_test_event_mutex);
+
+	err = hwc_create_channel(gc);
+	if (err)
+		goto remove_irq;
+
+	err = gdma_verify_vf_version(pdev);
+	if (err)
+		goto remove_irq;
+
+	err = gdma_query_max_resources(pdev);
+	if (err)
+		goto remove_irq;
+
+	err = gdma_detect_devices(pdev);
+	if (err)
+		goto remove_irq;
+
+	err = ana_probe(&gc->ana);
+	if (err)
+		goto clean_up_gdma;
+
+	return 0;
+
+clean_up_gdma:
+	hwc_destroy_channel(gc);
+	vfree(gc->cq_table);
+	gc->cq_table = NULL;
+remove_irq:
+	gdma_remove_irqs(pdev);
+unmap_bar:
+	pci_iounmap(pdev, bar0_va);
+free_gc:
+	vfree(gc);
+release_region:
+	pci_release_regions(pdev);
+disable_dev:
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+	dev_err(gc->dev, "gdma probe failed: err = %d\n", err);
+	return err;
+}
+
+static void gdma_remove(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+
+	ana_remove(&gc->ana);
+
+	hwc_destroy_channel(gc);
+	vfree(gc->cq_table);
+	gc->cq_table = NULL;
+
+	gdma_remove_irqs(pdev);
+
+	pci_iounmap(pdev, gc->bar0_va);
+
+	vfree(gc);
+
+	pci_release_regions(pdev);
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+}
+
+#ifndef PCI_VENDOR_ID_MICROSOFT
+#define PCI_VENDOR_ID_MICROSOFT 0x1414
+#endif
+
+static const struct pci_device_id mana_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, 0x00ba) },
+	{ }
+};
+
+static struct pci_driver mana_driver = {
+	.name		= "mana",
+	.id_table	= mana_id_table,
+	.probe		= gdma_probe,
+	.remove		= gdma_remove,
+};
+
+module_pci_driver(mana_driver);
+
+MODULE_DEVICE_TABLE(pci, mana_id_table);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Microsoft Azure Network Adapter driver");
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
new file mode 100644
index 000000000000..f070688ec55a
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -0,0 +1,859 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#include "gdma.h"
+#include "hw_channel.h"
+
+static int hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_idx)
+{
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long flags;
+	u32 index;
+
+	down(&hwc->sema);
+
+	spin_lock_irqsave(&r->lock, flags);
+
+	index = find_first_zero_bit(hwc->inflight_msg_res.map,
+				    hwc->inflight_msg_res.size);
+
+	bitmap_set(hwc->inflight_msg_res.map, index, 1);
+
+	spin_unlock_irqrestore(&r->lock, flags);
+
+	*msg_idx = index;
+
+	return 0;
+}
+
+static void hwc_put_msg_index(struct hw_channel_context *hwc, u16 msg_idx)
+{
+	struct gdma_resource *r = &hwc->inflight_msg_res;
+	unsigned long flags;
+
+	spin_lock_irqsave(&r->lock, flags);
+	bitmap_clear(hwc->inflight_msg_res.map, msg_idx, 1);
+	spin_unlock_irqrestore(&r->lock, flags);
+
+	up(&hwc->sema);
+}
+
+static int hwc_verify_resp_msg(const struct hwc_caller_ctx *caller_ctx,
+			       u32 resp_msglen,
+			       const struct gdma_resp_hdr *resp_msg)
+{
+	if (resp_msglen < sizeof(*resp_msg))
+		return -EPROTO;
+
+	if (resp_msglen > caller_ctx->output_buflen)
+		return -EPROTO;
+
+	return 0;
+}
+
+static void hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_msglen,
+			    const struct gdma_resp_hdr *resp_msg)
+{
+	struct hwc_caller_ctx *ctx;
+	int err = -EPROTO;
+
+	if (!test_bit(resp_msg->response.hwc_msg_id,
+		      hwc->inflight_msg_res.map)) {
+		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n",
+			resp_msg->response.hwc_msg_id);
+		goto out;
+	}
+
+	ctx = hwc->caller_ctx + resp_msg->response.hwc_msg_id;
+	err = hwc_verify_resp_msg(ctx, resp_msglen, resp_msg);
+	if (err)
+		goto out;
+
+	ctx->status_code = resp_msg->status;
+
+	memcpy(ctx->output_buf, resp_msg, resp_msglen);
+
+out:
+	ctx->error = err;
+	complete(&ctx->comp_event);
+}
+
+static int hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,
+			   struct hwc_work_request *req)
+{
+	struct device *dev = hwc_rxq->hwc->dev;
+	struct gdma_sge *sge;
+	int err;
+
+	sge = &req->sge;
+	sge->address = (u64)req->buf_sge_addr;
+	sge->mem_key = hwc_rxq->msg_buf->gpa_mkey;
+	sge->size = req->buf_len;
+
+	memset(&req->wqe_req, 0, sizeof(struct gdma_wqe_request));
+	req->wqe_req.sgl = sge;
+	req->wqe_req.num_sge = 1;
+	req->wqe_req.client_data_unit = 0;
+
+	err = gdma_post_and_ring(hwc_rxq->gdma_wq, &req->wqe_req, NULL);
+	if (err)
+		dev_err(dev, "Failed to post WQE on HWC RQ: %d\n", err);
+
+	return err;
+}
+
+static void hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
+				   struct gdma_event *event)
+{
+	struct hw_channel_context *hwc = ctx;
+	struct gdma_dev *gd = hwc->gdma_dev;
+	union hwc_init_type_data type_data;
+	union hwc_init_eq_id_db eq_db;
+	struct gdma_context *gc;
+	u32 type, val;
+
+	switch (event->type) {
+	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
+		eq_db.as_uint32 = event->details[0];
+		hwc->cq->gdma_eq->id = eq_db.eq_id;
+		gd->doorbell = eq_db.doorbell;
+		break;
+
+	case GDMA_EQE_HWC_INIT_DATA:
+
+		type_data.as_uint32 = event->details[0];
+		type = type_data.type;
+		val = type_data.value;
+
+		switch (type) {
+		case HWC_INIT_DATA_CQID:
+			hwc->cq->gdma_cq->id = val;
+			break;
+
+		case HWC_INIT_DATA_RQID:
+			hwc->rxq->gdma_wq->id = val;
+			break;
+
+		case HWC_INIT_DATA_SQID:
+			hwc->txq->gdma_wq->id = val;
+			break;
+
+		case HWC_INIT_DATA_QUEUE_DEPTH:
+			hwc->hwc_init_q_depth_max = (u16)val;
+			break;
+
+		case HWC_INIT_DATA_MAX_REQUEST:
+			hwc->hwc_init_max_req_msg_size = val;
+			break;
+
+		case HWC_INIT_DATA_MAX_RESPONSE:
+			hwc->hwc_init_max_resp_msg_size = val;
+			break;
+
+		case HWC_INIT_DATA_MAX_NUM_CQS:
+			gc = hwc_to_gdma_context(gd);
+			gc->max_num_cq = val;
+			break;
+
+		case HWC_INIT_DATA_PDID:
+			hwc->gdma_dev->pdid = val;
+			break;
+
+		case HWC_INIT_DATA_GPA_MKEY:
+			hwc->rxq->msg_buf->gpa_mkey = val;
+			hwc->txq->msg_buf->gpa_mkey = val;
+			break;
+		}
+
+		break;
+
+	case GDMA_EQE_HWC_INIT_DONE:
+		complete(&hwc->hwc_init_eqe_comp);
+		break;
+
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+
+static void hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
+				 const struct hwc_rx_oob *rx_oob)
+{
+	struct hw_channel_context *hwc = ctx;
+	struct hwc_wq *hwc_rxq = hwc->rxq;
+	struct hwc_work_request *rx_req;
+	struct gdma_resp_hdr *resp;
+	struct gdma_wqe *dma_oob;
+	struct gdma_queue *rq;
+	struct gdma_sge *sge;
+	u64 rq_base_addr;
+	u64 rx_req_idx;
+	u16 msg_id;
+	u8 *wqe;
+
+	if (WARN_ON(hwc_rxq->gdma_wq->id != gdma_rxq_id))
+		return;
+
+	rq = hwc_rxq->gdma_wq;
+	wqe = gdma_get_wqe_ptr(rq, rx_oob->wqe_offset / GDMA_WQE_BU_SIZE);
+	dma_oob = (struct gdma_wqe *)wqe;
+
+	sge = (struct gdma_sge *)(wqe + 8 + dma_oob->inline_oob_size_div4 * 4);
+	WARN_ON(dma_oob->inline_oob_size_div4 != 2 &&
+		dma_oob->inline_oob_size_div4 != 6);
+
+	/* Select the rx WorkRequest for access to virtual address if not in SGE
+	 * and for reposting.  The receive reqs index may not match
+	 * channel msg_id if sender posted send WQE's out of order. The rx WR
+	 * that should be recycled here is the one we're currently using. Its
+	 * index can be calculated based on the current address's location in
+	 * the memory region.
+	 */
+	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
+	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;
+
+	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
+	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
+
+	if (resp->response.hwc_msg_id >= hwc->num_inflight_msg) {
+		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n",
+			resp->response.hwc_msg_id);
+		return;
+	}
+
+	hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, resp);
+
+	msg_id = resp->response.hwc_msg_id;
+	resp = NULL;
+
+	hwc_post_rx_wqe(hwc_rxq, rx_req);
+
+	hwc_put_msg_index(hwc, msg_id);
+}
+
+static void hwc_tx_event_handler(void *ctx, u32 gdma_txq_id,
+				 const struct hwc_rx_oob *rx_oob)
+{
+	struct hw_channel_context *hwc = ctx;
+	struct hwc_wq *hwc_txq = hwc->txq;
+
+	WARN_ON(!hwc_txq || hwc_txq->gdma_wq->id != gdma_txq_id);
+}
+
+static int hwc_create_gdma_wq(struct hw_channel_context *hwc,
+			      enum gdma_queue_type type, u64 queue_size,
+			      struct gdma_queue **queue)
+{
+	struct gdma_queue_spec spec = {};
+
+	if (type != GDMA_SQ && type != GDMA_RQ)
+		return -EINVAL;
+
+	spec.type = type;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = queue_size;
+
+	return gdma_create_hwc_queue(hwc->gdma_dev, &spec, queue);
+}
+
+static int hwc_create_gdma_cq(struct hw_channel_context *hwc, u64 queue_size,
+			      void *ctx, gdma_cq_callback *cb,
+			      struct gdma_queue *parent_eq,
+			      struct gdma_queue **queue)
+{
+	struct gdma_queue_spec spec = {};
+
+	spec.type = GDMA_CQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = queue_size;
+	spec.cq.context = ctx;
+	spec.cq.callback = cb;
+	spec.cq.parent_eq = parent_eq;
+
+	return gdma_create_hwc_queue(hwc->gdma_dev, &spec, queue);
+}
+
+static int hwc_create_gdma_eq(struct hw_channel_context *hwc, u64 queue_size,
+			      void *ctx, gdma_eq_callback *cb,
+			      struct gdma_queue **queue)
+{
+	struct gdma_queue_spec spec = {};
+
+	spec.type = GDMA_EQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = queue_size;
+	spec.eq.context = ctx;
+	spec.eq.callback = cb;
+	spec.eq.log2_throttle_limit = DEFAULT_LOG2_THROTTLING_FOR_ERROR_EQ;
+
+	return gdma_create_hwc_queue(hwc->gdma_dev, &spec, queue);
+}
+
+static void hwc_comp_event(void *ctx, struct gdma_queue *q_self)
+{
+	struct hwc_rx_oob comp_data = {};
+	struct gdma_comp *completions;
+	struct hwc_cq *hwc_cq = ctx;
+	u32 comp_read, i;
+
+	WARN_ON(hwc_cq->gdma_cq != q_self);
+
+	completions = hwc_cq->comp_buf;
+	comp_read = gdma_poll_cq(q_self, completions, hwc_cq->queue_depth);
+	WARN_ON(comp_read <= 0 || comp_read > hwc_cq->queue_depth);
+
+	for (i = 0; i < comp_read; ++i) {
+		comp_data = *(struct hwc_rx_oob *)completions[i].cqe_data;
+
+		if (completions[i].is_sq)
+			hwc_cq->tx_event_handler(hwc_cq->tx_event_ctx,
+						completions[i].wq_num,
+						&comp_data);
+		else
+			hwc_cq->rx_event_handler(hwc_cq->rx_event_ctx,
+						completions[i].wq_num,
+						&comp_data);
+	}
+
+	gdma_arm_cq(q_self);
+}
+
+static void hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
+{
+	if (!hwc_cq)
+		return;
+
+	kfree(hwc_cq->comp_buf);
+
+	if (hwc_cq->gdma_cq)
+		gdma_destroy_queue(gc, hwc_cq->gdma_cq);
+
+	if (hwc_cq->gdma_eq)
+		gdma_destroy_queue(gc, hwc_cq->gdma_eq);
+
+	kfree(hwc_cq);
+}
+
+static int hwc_create_cq(struct hw_channel_context *hwc, u16 q_depth,
+			 gdma_eq_callback *callback, void *ctx,
+			 hwc_rx_event_handler_t *rx_ev_hdlr, void *rx_ev_ctx,
+			 hwc_tx_event_handler_t *tx_ev_hdlr, void *tx_ev_ctx,
+			 struct hwc_cq **hwc_cq_p)
+{
+	struct gdma_queue *eq, *cq;
+	struct gdma_comp *comp_buf;
+	struct hwc_cq *hwc_cq;
+	u32 eq_size, cq_size;
+	int err;
+
+	eq_size = roundup_pow_of_two(GDMA_EQE_SIZE * q_depth);
+	WARN_ON(eq_size != 16 * 2 * HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH);
+	if (eq_size < MINIMUM_SUPPORTED_PAGE_SIZE)
+		eq_size = MINIMUM_SUPPORTED_PAGE_SIZE;
+
+	cq_size = roundup_pow_of_two(GDMA_CQE_SIZE * q_depth);
+	WARN_ON(cq_size != 64 * 2 * HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH);
+	if (cq_size < MINIMUM_SUPPORTED_PAGE_SIZE)
+		cq_size = MINIMUM_SUPPORTED_PAGE_SIZE;
+
+	hwc_cq = kzalloc(sizeof(*hwc_cq), GFP_KERNEL);
+	if (!hwc_cq)
+		return -ENOMEM;
+
+	err = hwc_create_gdma_eq(hwc, eq_size, ctx, callback, &eq);
+	if (err) {
+		dev_err(hwc->dev, "Failed to create HWC EQ for RQ: %d\n", err);
+		goto out;
+	}
+	hwc_cq->gdma_eq = eq;
+
+	err = hwc_create_gdma_cq(hwc, cq_size, hwc_cq, hwc_comp_event, eq, &cq);
+	if (err) {
+		dev_err(hwc->dev, "Failed to create HWC CQ for RQ: %d\n", err);
+		goto out;
+	}
+	hwc_cq->gdma_cq = cq;
+
+	comp_buf = kcalloc(q_depth, sizeof(struct gdma_comp), GFP_KERNEL);
+	if (!comp_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hwc_cq->hwc = hwc;
+	hwc_cq->comp_buf = comp_buf;
+	hwc_cq->queue_depth = q_depth;
+	hwc_cq->rx_event_handler = rx_ev_hdlr;
+	hwc_cq->rx_event_ctx = rx_ev_ctx;
+	hwc_cq->tx_event_handler = tx_ev_hdlr;
+	hwc_cq->tx_event_ctx = tx_ev_ctx;
+
+	*hwc_cq_p = hwc_cq;
+	return 0;
+
+out:
+	hwc_destroy_cq(hwc_to_gdma_context(hwc->gdma_dev), hwc_cq);
+	return err;
+}
+
+static int hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
+			     u32 max_msg_size, struct hwc_dma_buf **dma_buf_p)
+{
+	struct gdma_context *gc = hwc_to_gdma_context(hwc->gdma_dev);
+	struct hwc_work_request *hwc_wr;
+	struct hwc_dma_buf *dma_buf;
+	struct gdma_mem_info *gmi;
+	void *virt_addr;
+	u32 buf_size;
+	u8 *base_pa;
+	int err;
+	u16 i;
+
+	dma_buf = kzalloc(sizeof(*dma_buf) +
+			  q_depth * sizeof(struct hwc_work_request),
+			  GFP_KERNEL);
+	if (!dma_buf)
+		return -ENOMEM;
+
+	dma_buf->num_reqs = q_depth;
+
+	buf_size = ALIGN(q_depth * max_msg_size, PAGE_SIZE);
+
+	gmi = &dma_buf->mem_info;
+	err = gdma_alloc_memory(gc, buf_size, gmi);
+	if (err) {
+		dev_err(hwc->dev, "Failed to allocate DMA buffer: %d\n", err);
+		goto out;
+	}
+
+	virt_addr = dma_buf->mem_info.virt_addr;
+	base_pa = (u8 *)dma_buf->mem_info.dma_handle;
+
+	for (i = 0; i < q_depth; i++) {
+		hwc_wr = &dma_buf->reqs[i];
+
+		hwc_wr->buf_va = virt_addr + i * max_msg_size;
+		hwc_wr->buf_sge_addr = base_pa + i * max_msg_size;
+
+		hwc_wr->buf_len = max_msg_size;
+	}
+
+	*dma_buf_p = dma_buf;
+	return 0;
+out:
+	kfree(dma_buf);
+	return err;
+}
+
+static void hwc_dealloc_dma_buf(struct hw_channel_context *hwc,
+				struct hwc_dma_buf *dma_buf)
+{
+	if (!dma_buf)
+		return;
+
+	gdma_free_memory(&dma_buf->mem_info);
+
+	kfree(dma_buf);
+}
+
+static void hwc_destroy_wq(struct hw_channel_context *hwc,
+			   struct hwc_wq *hwc_wq)
+{
+	if (!hwc_wq)
+		return;
+
+	hwc_dealloc_dma_buf(hwc, hwc_wq->msg_buf);
+
+	if (hwc_wq->gdma_wq)
+		gdma_destroy_queue(hwc_to_gdma_context(hwc->gdma_dev),
+				   hwc_wq->gdma_wq);
+
+	kfree(hwc_wq);
+}
+
+static int hwc_create_wq(struct hw_channel_context *hwc,
+			 enum gdma_queue_type q_type, u16 q_depth,
+			 u32 max_msg_size, struct hwc_cq *hwc_cq,
+			 struct hwc_wq **hwc_wq_p)
+{
+	struct gdma_queue *queue;
+	struct hwc_wq *hwc_wq;
+	u32 queue_size;
+	int err;
+
+	WARN_ON(q_type != GDMA_SQ && q_type != GDMA_RQ);
+
+	if (q_type == GDMA_RQ)
+		queue_size = roundup_pow_of_two(GDMA_MAX_RQE_SIZE * q_depth);
+	else
+		queue_size = roundup_pow_of_two(GDMA_MAX_SQE_SIZE * q_depth);
+
+	if (queue_size < MINIMUM_SUPPORTED_PAGE_SIZE)
+		queue_size = MINIMUM_SUPPORTED_PAGE_SIZE;
+
+	hwc_wq = kzalloc(sizeof(*hwc_wq), GFP_KERNEL);
+	if (!hwc_wq)
+		return -ENOMEM;
+
+	err = hwc_create_gdma_wq(hwc, q_type, queue_size, &queue);
+	if (err)
+		goto out;
+
+	err = hwc_alloc_dma_buf(hwc, q_depth, max_msg_size, &hwc_wq->msg_buf);
+	if (err)
+		goto out;
+
+	hwc_wq->hwc = hwc;
+	hwc_wq->gdma_wq = queue;
+	hwc_wq->queue_depth = q_depth;
+	hwc_wq->hwc_cq = hwc_cq;
+
+	*hwc_wq_p = hwc_wq;
+	return 0;
+
+out:
+	if (err)
+		hwc_destroy_wq(hwc, hwc_wq);
+	return err;
+}
+
+static int hwc_post_tx_wqe(const struct hwc_wq *hwc_txq,
+			   struct hwc_work_request *req,
+			   u32 dest_virt_rq_id, u32 dest_virt_rcq_id,
+			   bool dest_pf)
+{
+	struct device *dev = hwc_txq->hwc->dev;
+	struct hwc_tx_oob *tx_oob;
+	struct gdma_sge *sge;
+	int err;
+
+	if (req->msg_size == 0 || req->msg_size > req->buf_len) {
+		dev_err(dev, "wrong msg_size: %u, buf_len: %u\n",
+			req->msg_size, req->buf_len);
+		return -EINVAL;
+	}
+
+	tx_oob = &req->tx_oob;
+
+	tx_oob->vrq_id = dest_virt_rq_id;
+	tx_oob->dest_vfid = 0;
+	tx_oob->vrcq_id = dest_virt_rcq_id;
+	tx_oob->vscq_id = hwc_txq->hwc_cq->gdma_cq->id;
+	tx_oob->loopback = false;
+	tx_oob->lso_override = false;
+	tx_oob->dest_pf = dest_pf;
+	tx_oob->vsq_id = hwc_txq->gdma_wq->id;
+
+	sge = &req->sge;
+	sge->address = (u64)req->buf_sge_addr;
+	sge->mem_key = hwc_txq->msg_buf->gpa_mkey;
+	sge->size = req->msg_size;
+
+	memset(&req->wqe_req, 0, sizeof(struct gdma_wqe_request));
+	req->wqe_req.sgl = sge;
+	req->wqe_req.num_sge = 1;
+	req->wqe_req.inline_oob_size = sizeof(struct hwc_tx_oob);
+	req->wqe_req.inline_oob_data = tx_oob;
+	req->wqe_req.client_data_unit = 0;
+
+	err = gdma_post_and_ring(hwc_txq->gdma_wq, &req->wqe_req, NULL);
+	if (err)
+		dev_err(dev, "Failed to post WQE on HWC RQ: %d\n", err);
+
+	return err;
+}
+
+static int hwc_init_inflight_msg(struct hw_channel_context *hwc, u16 num_msg)
+{
+	int err;
+
+	sema_init(&hwc->sema, num_msg);
+
+	WARN_ON(num_msg != HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH);
+
+	err = gdma_alloc_res_map(num_msg, &hwc->inflight_msg_res);
+	if (err)
+		dev_err(hwc->dev, "Failed to init inflight_msg_res: %d\n", err);
+
+	return err;
+}
+
+static int hwc_test_channel(struct hw_channel_context *hwc, u16 q_depth,
+			    u32 max_req_msg_size, u32 max_resp_msg_size)
+{
+	struct gdma_context *gc = hwc_to_gdma_context(hwc->gdma_dev);
+	struct hwc_wq *hwc_rxq = hwc->rxq;
+	struct hwc_work_request *req;
+	struct hwc_caller_ctx *ctx;
+	int err;
+	int i;
+
+	/* Post all WQEs on the RQ */
+	for (i = 0; i < q_depth; i++) {
+		req = &hwc_rxq->msg_buf->reqs[i];
+		err = hwc_post_rx_wqe(hwc_rxq, req);
+		if (err)
+			return err;
+	}
+
+	ctx = kzalloc(q_depth * sizeof(struct hwc_caller_ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	for (i = 0; i < q_depth; ++i)
+		init_completion(&ctx[i].comp_event);
+
+	hwc->caller_ctx = ctx;
+
+	err = gdma_test_eq(gc, hwc->cq->gdma_eq);
+	return err;
+}
+
+void hwc_destroy_channel(struct gdma_context *gc)
+{
+	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct hwc_caller_ctx *ctx;
+
+	shm_channel_teardown_hwc(&gc->shm_channel, false);
+
+	ctx = hwc->caller_ctx;
+	kfree(ctx);
+	hwc->caller_ctx = NULL;
+
+	hwc_destroy_wq(hwc, hwc->txq);
+	hwc->txq = NULL;
+
+	hwc_destroy_wq(hwc, hwc->rxq);
+	hwc->rxq = NULL;
+
+	hwc_destroy_cq(hwc_to_gdma_context(hwc->gdma_dev), hwc->cq);
+	hwc->cq = NULL;
+
+	gdma_free_res_map(&hwc->inflight_msg_res);
+
+	hwc->num_inflight_msg = 0;
+
+	if (hwc->gdma_dev->pdid != INVALID_PDID) {
+		hwc->gdma_dev->doorbell = INVALID_DOORBELL;
+		hwc->gdma_dev->pdid = INVALID_PDID;
+	}
+
+	kfree(hwc);
+	gc->hwc.driver_data = NULL;
+}
+
+static int hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
+				 u32 *max_req_msg_size, u32 *max_resp_msg_size)
+{
+	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	struct gdma_queue *rq = hwc->rxq->gdma_wq;
+	struct gdma_queue *sq = hwc->txq->gdma_wq;
+	struct gdma_queue *eq = hwc->cq->gdma_eq;
+	struct gdma_queue *cq = hwc->cq->gdma_cq;
+	int err;
+
+	init_completion(&hwc->hwc_init_eqe_comp);
+
+	err = shm_channel_setup_hwc(&gc->shm_channel, false,
+				    eq->mem_info.dma_handle,
+				    cq->mem_info.dma_handle,
+				    rq->mem_info.dma_handle,
+				    sq->mem_info.dma_handle,
+				    eq->eq.msix_index);
+	if (err)
+		return err;
+
+	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
+		return -ETIMEDOUT;
+
+	*q_depth = hwc->hwc_init_q_depth_max;
+	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
+	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
+
+	WARN_ON(*q_depth < HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH);
+	WARN_ON(*max_req_msg_size != HW_CHANNEL_MAX_REQUEST_SIZE);
+	WARN_ON(*max_resp_msg_size != HW_CHANNEL_MAX_RESPONSE_SIZE);
+
+	WARN_ON(gc->max_num_cq == 0);
+	if (WARN_ON(cq->id >= gc->max_num_cq))
+		return -EPROTO;
+
+	gc->cq_table = vzalloc(gc->max_num_cq * sizeof(struct gdma_queue *));
+	if (!gc->cq_table)
+		return -ENOMEM;
+
+	gc->cq_table[cq->id] = cq;
+
+	return 0;
+}
+
+static int hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
+			   u32 max_req_msg_size, u32 max_resp_msg_size)
+{
+	struct hwc_wq *hwc_rxq = NULL;
+	struct hwc_wq *hwc_txq = NULL;
+	struct hwc_cq *hwc_cq = NULL;
+	int err;
+
+	err = hwc_init_inflight_msg(hwc, q_depth);
+	if (err)
+		return err;
+
+	/* CQ is shared by SQ and RQ, so CQ's queue depth is the sum of SQ
+	 * queue depth and RQ queue depth.
+	 */
+	err = hwc_create_cq(hwc, q_depth * 2, hwc_init_event_handler, hwc,
+			    hwc_rx_event_handler, hwc, hwc_tx_event_handler,
+			    hwc, &hwc_cq);
+	if (err) {
+		WARN(1, "Failed to create HWC CQ: %d\n", err);
+		goto out;
+	}
+	hwc->cq = hwc_cq;
+
+	err = hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
+			    hwc_cq, &hwc_rxq);
+	if (err) {
+		WARN(1, "Failed to create HWC RQ: %d\n", err);
+		goto out;
+	}
+	hwc->rxq = hwc_rxq;
+
+	err = hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
+			    hwc_cq, &hwc_txq);
+	if (err) {
+		WARN(1, "Failed to create HWC SQ: %d\n", err);
+		goto out;
+	}
+	hwc->txq = hwc_txq;
+
+	hwc->num_inflight_msg = q_depth;
+	hwc->max_req_msg_size = max_req_msg_size;
+
+	return 0;
+out:
+	if (hwc_txq)
+		hwc_destroy_wq(hwc, hwc_txq);
+
+	if (hwc_rxq)
+		hwc_destroy_wq(hwc, hwc_rxq);
+
+	if (hwc_cq)
+		hwc_destroy_cq(hwc_to_gdma_context(hwc->gdma_dev),
+			       hwc_cq);
+
+	gdma_free_res_map(&hwc->inflight_msg_res);
+	return err;
+}
+
+int hwc_create_channel(struct gdma_context *gc)
+{
+	u32 max_req_msg_size, max_resp_msg_size;
+	struct gdma_dev *gd = &gc->hwc;
+	struct hw_channel_context *hwc;
+	u16 q_depth_max;
+	int err;
+
+	hwc = kzalloc(sizeof(*hwc), GFP_KERNEL);
+	if (!hwc)
+		return -ENOMEM;
+
+	gd->driver_data = hwc;
+	hwc->gdma_dev = gd;
+	hwc->dev = gc->dev;
+
+	/* HWC's instance number is always 0. */
+	gd->dev_id.as_uint32 = 0;
+	gd->dev_id.type = GDMA_DEVICE_HWC;
+
+	gd->pdid = INVALID_PDID;
+	gd->doorbell = INVALID_DOORBELL;
+
+	err = hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+			      HW_CHANNEL_MAX_REQUEST_SIZE,
+			      HW_CHANNEL_MAX_RESPONSE_SIZE);
+	if (err) {
+		dev_err(hwc->dev, "Failed to initialize HWC: %d\n", err);
+		goto out;
+	}
+
+	err = hwc_establish_channel(gc, &q_depth_max, &max_req_msg_size,
+				    &max_resp_msg_size);
+	if (err) {
+		dev_err(hwc->dev, "Failed to establish HWC: %d\n", err);
+		goto out;
+	}
+
+	WARN_ON(q_depth_max < HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH);
+	WARN_ON(max_req_msg_size < HW_CHANNEL_MAX_REQUEST_SIZE);
+	WARN_ON(max_resp_msg_size > HW_CHANNEL_MAX_RESPONSE_SIZE);
+
+	err = hwc_test_channel(gc->hwc.driver_data,
+			       HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
+			       max_req_msg_size, max_resp_msg_size);
+	if (err) {
+		dev_err(hwc->dev, "Failed to establish HWC: %d\n", err);
+		goto out;
+	}
+
+	return 0;
+out:
+	kfree(hwc);
+	return err;
+}
+
+int hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
+		     const void *req, u32 resp_len, void *resp)
+{
+	struct hwc_work_request *tx_wr;
+	struct hwc_wq *txq = hwc->txq;
+	struct gdma_req_hdr *req_msg;
+	struct hwc_caller_ctx *ctx;
+	u16 msg_idx;
+	int err;
+
+	hwc_get_msg_index(hwc, &msg_idx);
+
+	tx_wr = &txq->msg_buf->reqs[msg_idx];
+
+	if (req_len > tx_wr->buf_len) {
+		dev_err(hwc->dev, "HWC: req msg size: %d > %d\n", req_len,
+			tx_wr->buf_len);
+		return -EINVAL;
+	}
+
+	ctx = hwc->caller_ctx + msg_idx;
+	ctx->output_buf = resp;
+	ctx->output_buflen = resp_len;
+
+	req_msg = (struct gdma_req_hdr *)tx_wr->buf_va;
+	if (req)
+		memcpy(req_msg, req, req_len);
+
+	req_msg->req.hwc_msg_id = msg_idx;
+
+	tx_wr->msg_size = req_len;
+
+	err = hwc_post_tx_wqe(txq, tx_wr, 0, 0, false);
+	if (err) {
+		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
+		return err;
+	}
+
+	if (!wait_for_completion_timeout(&ctx->comp_event, 30 * HZ)) {
+		dev_err(hwc->dev, "HWC: Request timed out!\n");
+		return -ETIMEDOUT;
+	}
+
+	if (ctx->error)
+		return ctx->error;
+
+	if (ctx->status_code) {
+		dev_err(hwc->dev, "HWC: Failed hw_channel req: 0x%x\n",
+			ctx->status_code);
+		return -EPROTO;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.h b/drivers/net/ethernet/microsoft/mana/hw_channel.h
new file mode 100644
index 000000000000..54c07c1ad551
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#ifndef _HW_CHANNEL_H
+#define _HW_CHANNEL_H
+
+#define DEFAULT_LOG2_THROTTLING_FOR_ERROR_EQ  4
+
+#define HW_CHANNEL_MAX_REQUEST_SIZE  0x1000
+#define HW_CHANNEL_MAX_RESPONSE_SIZE 0x1000
+
+#define HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH 1
+
+#define HWC_INIT_DATA_CQID		1
+#define HWC_INIT_DATA_RQID		2
+#define HWC_INIT_DATA_SQID		3
+#define HWC_INIT_DATA_QUEUE_DEPTH	4
+#define HWC_INIT_DATA_MAX_REQUEST	5
+#define HWC_INIT_DATA_MAX_RESPONSE	6
+#define HWC_INIT_DATA_MAX_NUM_CQS	7
+#define HWC_INIT_DATA_PDID		8
+#define HWC_INIT_DATA_GPA_MKEY		9
+
+union hwc_init_eq_id_db {
+	u32 as_uint32;
+
+	struct {
+		u32 eq_id	: 16;
+		u32 doorbell	: 16;
+	};
+} __packed;
+
+union hwc_init_type_data {
+	u32 as_uint32;
+
+	struct {
+		u32 value	: 24;
+		u32 type	:  8;
+	};
+} __packed;
+
+struct hwc_rx_oob {
+	u32 type	: 6;
+	u32 eom		: 1;
+	u32 som		: 1;
+	u32 vendor_err	: 8;
+	u32 reserved1	: 16;
+
+	u32 src_virt_wq	: 24;
+	u32 src_vfid	: 8;
+
+	u32 reserved2;
+
+	union {
+		u32 wqe_addr_low;
+		u32 wqe_offset;
+	};
+
+	u32 wqe_addr_high;
+
+	u32 client_data_unit	: 14;
+	u32 reserved3		: 18;
+
+	u32 tx_oob_data_size;
+
+	u32 chunk_offset	: 21;
+	u32 reserved4		: 11;
+} __packed;
+
+struct hwc_tx_oob {
+	u32 reserved1;
+
+	u32 reserved2;
+
+	u32 vrq_id	: 24;
+	u32 dest_vfid	: 8;
+
+	u32 vrcq_id	: 24;
+	u32 reserved3	: 8;
+
+	u32 vscq_id	: 24;
+	u32 loopback	: 1;
+	u32 lso_override: 1;
+	u32 dest_pf	: 1;
+	u32 reserved4	: 5;
+
+	u32 vsq_id	: 24;
+	u32 reserved5	: 8;
+} __packed;
+
+struct hwc_work_request {
+	void *buf_va;
+	void *buf_sge_addr;
+	u32 buf_len;
+	u32 msg_size;
+
+	struct gdma_wqe_request wqe_req;
+	struct hwc_tx_oob tx_oob;
+
+	struct gdma_sge sge;
+};
+
+/* hwc_dma_buf represents the array of in-flight WQEs.
+ * mem_info as know as the GDMA mapped memory is partitioned and used by
+ * in-flight WQEs.
+ * The number of WQEs is determined by the number of in-flight messages.
+ */
+struct hwc_dma_buf {
+	struct gdma_mem_info mem_info;
+
+	u32 gpa_mkey;
+
+	u32 num_reqs;
+	struct hwc_work_request reqs[];
+};
+
+typedef void hwc_rx_event_handler_t(void *ctx, u32 gdma_rxq_id,
+				    const struct hwc_rx_oob *rx_oob);
+
+typedef void hwc_tx_event_handler_t(void *ctx, u32 gdma_txq_id,
+				    const struct hwc_rx_oob *rx_oob);
+
+struct hwc_cq {
+	struct hw_channel_context *hwc;
+
+	struct gdma_queue *gdma_cq;
+	struct gdma_queue *gdma_eq;
+	struct gdma_comp *comp_buf;
+	u16 queue_depth;
+
+	hwc_rx_event_handler_t *rx_event_handler;
+	void *rx_event_ctx;
+
+	hwc_tx_event_handler_t *tx_event_handler;
+	void *tx_event_ctx;
+};
+
+struct hwc_wq {
+	struct hw_channel_context *hwc;
+
+	struct gdma_queue *gdma_wq;
+	struct hwc_dma_buf *msg_buf;
+	u16 queue_depth;
+
+	struct hwc_cq *hwc_cq;
+};
+
+struct hwc_caller_ctx {
+	struct completion comp_event;
+	void *output_buf;
+	u32 output_buflen;
+
+	u32 error; /* Linux error code */
+	u32 status_code;
+};
+
+struct hw_channel_context {
+	struct gdma_dev *gdma_dev;
+	struct device *dev;
+
+	u16 num_inflight_msg;
+	u32 max_req_msg_size;
+
+	u16 hwc_init_q_depth_max;
+	u32 hwc_init_max_req_msg_size;
+	u32 hwc_init_max_resp_msg_size;
+
+	struct completion hwc_init_eqe_comp;
+
+	struct hwc_wq *rxq;
+	struct hwc_wq *txq;
+	struct hwc_cq *cq;
+
+	struct semaphore sema;
+	struct gdma_resource inflight_msg_res;
+
+	struct hwc_caller_ctx *caller_ctx;
+};
+
+int hwc_create_channel(struct gdma_context *gc);
+void hwc_destroy_channel(struct gdma_context *gc);
+
+int hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
+		     const void *req, u32 resp_len, void *resp);
+
+#endif /* _HW_CHANNEL_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
new file mode 100644
index 000000000000..71173553ae6d
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -0,0 +1,531 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#ifndef _MANA_H
+#define _MANA_H
+
+#include "gdma.h"
+#include "hw_channel.h"
+
+/* Microsoft Azure Network Adapter (ANA)'s definitions */
+
+#define ANA_MAJOR_VERSION	0
+#define ANA_MINOR_VERSION	1
+#define ANA_MICRO_VERSION	1
+
+typedef u64 ana_handle_t;
+#define INVALID_ANA_HANDLE ((ana_handle_t)-1)
+
+enum TRI_STATE {
+	TRI_STATE_UNKNOWN = -1,
+	TRI_STATE_FALSE = 0,
+	TRI_STATE_TRUE = 1
+};
+
+/* Number of entries for hardware indirection table must be in power of 2 */
+#define ANA_INDIRECT_TABLE_SIZE 64
+
+/* The Toeplitz hash key's length in bytes: should be multiple of 8 */
+#define ANA_HASH_KEY_SIZE 40
+
+#define INVALID_GDMA_DEVICE_ID (~((u32)0))
+
+#define COMP_ENTRY_SIZE 64
+
+#define ADAPTER_MTU_SIZE 1500
+#define MAX_FRAME_SIZE (ADAPTER_MTU_SIZE + 14)
+
+#define RX_BUFFERS_PER_QUEUE 512
+
+#define MAX_SEND_BUFFERS_PER_QUEUE 256
+
+#define EQ_SIZE (8 * PAGE_SIZE)
+#define LOG2_EQ_THROTTLE 3
+
+struct ana_stats {
+	u64 packets;
+	u64 bytes;
+	struct u64_stats_sync syncp;
+};
+
+struct ana_txq {
+	struct gdma_queue *gdma_sq;
+
+	union {
+		u32 gdma_txq_id;
+		struct {
+			u32 reserved1	: 10;
+			u32 vsq_frame	: 14;
+			u32 reserved2	: 8;
+		};
+	};
+
+	u16 vp_offset;
+
+	/* The SKBs are sent to the HW and we are waiting for the CQEs. */
+	struct sk_buff_head pending_skbs;
+	struct netdev_queue *net_txq;
+
+	atomic_t pending_sends;
+
+	struct ana_stats stats;
+};
+
+/* skb data and frags dma mappings */
+struct ana_skb_head {
+	dma_addr_t dma_handle[MAX_SKB_FRAGS + 1];
+	u32 size[MAX_SKB_FRAGS + 1];
+};
+
+#define ANA_HEADROOM sizeof(struct ana_skb_head)
+
+enum ana_tx_pkt_format { ANA_SHORT_PKT_FMT = 0, ANA_LONG_PKT_FMT = 1 };
+
+struct ana_tx_short_oob {
+	u32 pkt_fmt		: 2;
+	u32 is_outer_ipv4	: 1;
+	u32 is_outer_ipv6	: 1;
+	u32 comp_iphdr_csum	: 1;
+	u32 comp_tcp_csum	: 1;
+	u32 comp_udp_csum	: 1;
+	u32 supress_txcqe_gen	: 1;
+	u32 vcq_num		: 24;
+
+	u32 trans_off		: 10; /* Transport header offset */
+	u32 vsq_frame		: 14;
+	u32 short_vp_offset	: 8;
+} __packed;
+
+struct ana_tx_long_oob {
+	u32 is_encap		: 1;
+	u32 inner_is_ipv6	: 1;
+	u32 inner_tcp_opt	: 1;
+	u32 inject_vlan_pri_tag : 1;
+	u32 reserved1		: 12;
+	u32 pcp			: 3;  /* 802.1Q */
+	u32 dei			: 1;  /* 802.1Q */
+	u32 vlan_id		: 12; /* 802.1Q */
+
+	u32 inner_frame_offset	: 10;
+	u32 inner_ip_rel_offset : 6;
+	u32 long_vp_offset	: 12;
+	u32 reserved2		: 4;
+
+	u32 reserved3;
+	u32 reserved4;
+} __packed;
+
+struct ana_tx_oob {
+	struct ana_tx_short_oob s_oob;
+	struct ana_tx_long_oob l_oob;
+} __packed;
+
+enum ana_cq_type {
+	ANA_CQ_TYPE_RX,
+	ANA_CQ_TYPE_TX
+};
+
+enum ana_cqe_type {
+	CQE_INVALID = 0,
+	CQE_RX_OKAY = 1,
+	CQE_RX_COALESCED_4 = 2,
+	CQE_RX_OBJECT_FENCE = 3,
+	CQE_RX_TRUNCATED = 4,
+
+	CQE_TX_OKAY = 32,
+	CQE_TX_SA_DROP = 33,
+	CQE_TX_MTU_DROP = 34,
+	CQE_TX_INVALID_OOB = 35,
+	CQE_TX_INVALID_ETH_TYPE = 36,
+	CQE_TX_HDR_PROCESSING_ERROR = 37,
+	CQE_TX_VF_DISABLED = 38,
+	CQE_TX_VPORT_IDX_OUT_OF_RANGE = 39,
+	CQE_TX_VPORT_DISABLED = 40,
+	CQE_TX_VLAN_TAGGING_VIOLATION = 41,
+
+	CQE_INVALID_CQ_PDID = 60,
+	CQE_INVALID_SQ_PDID = 61,
+	CQE_LINK_DOWN = 62,
+	CQE_LINK_UP = 63
+};
+
+#define ANA_CQE_COMPLETION 1
+
+struct ana_cqe_header {
+	u32 cqe_type	: 6;
+	u32 client_type	: 2;
+	u32 vendor_err	: 24;
+} __packed;
+
+/* NDIS HASH Types */
+#define NDIS_HASH_IPV4		BIT(0)
+#define NDIS_HASH_TCP_IPV4	BIT(1)
+#define NDIS_HASH_UDP_IPV4	BIT(2)
+#define NDIS_HASH_IPV6		BIT(3)
+#define NDIS_HASH_TCP_IPV6	BIT(4)
+#define NDIS_HASH_UDP_IPV6	BIT(5)
+#define NDIS_HASH_IPV6_EX	BIT(6)
+#define NDIS_HASH_TCP_IPV6_EX	BIT(7)
+#define NDIS_HASH_UDP_IPV6_EX	BIT(8)
+
+#define ANA_HASH_L3 (NDIS_HASH_IPV4 | NDIS_HASH_IPV6 | NDIS_HASH_IPV6_EX)
+#define ANA_HASH_L4                                                          \
+	(NDIS_HASH_TCP_IPV4 | NDIS_HASH_UDP_IPV4 | NDIS_HASH_TCP_IPV6 |      \
+	 NDIS_HASH_UDP_IPV6 | NDIS_HASH_TCP_IPV6_EX | NDIS_HASH_UDP_IPV6_EX)
+
+struct ana_rxcomp_perpkt_info {
+	u32 pkt_len	: 16;
+	u32 reserved1	: 16;
+	u32 reserved2;
+	u32 pkt_hash;
+} __packed;
+
+#define ANA_RXCOMP_OOB_NUM_PPI 4
+
+/* Receive completion OOB */
+struct ana_rxcomp_oob {
+	struct ana_cqe_header cqe_hdr;
+
+	u32 rx_vlan_id			: 12;
+	u32 rx_vlantag_present		: 1;
+	u32 rx_outer_iphdr_csum_succeed	: 1;
+	u32 rx_outer_iphdr_csum_fail	: 1;
+	u32 reserved1			: 1;
+	u32 rx_hashtype			: 9;
+	u32 rx_iphdr_csum_succeed	: 1;
+	u32 rx_iphdr_csum_fail		: 1;
+	u32 rx_tcp_csum_succeed		: 1;
+	u32 rx_tcp_csum_fail		: 1;
+	u32 rx_udp_csum_succeed		: 1;
+	u32 rx_udp_csum_fail		: 1;
+	u32 reserved2			: 1;
+
+	struct ana_rxcomp_perpkt_info ppi[ANA_RXCOMP_OOB_NUM_PPI];
+
+	u32 rx_wqe_offset;
+} __packed;
+
+struct ana_tx_comp_oob {
+	struct ana_cqe_header cqe_hdr;
+
+	u32 tx_data_offset;
+
+	u32 tx_sgl_offset	: 5;
+	u32 tx_wqe_offset	: 27;
+
+	u32 reserved[12];
+} __packed;
+
+struct ana_rxq;
+
+struct ana_cq {
+	struct gdma_queue *gdma_cq;
+
+	/* Cache the CQ id (used to verify if each CQE comes to the right CQ. */
+	u32 gdma_id;
+
+	/* Type of the CQ: TX or RX */
+	enum ana_cq_type type;
+
+	/* Pointer to the ana_rxq that is pushing RX CQEs to the queue.
+	 * Only and must be non-NULL if type is ANA_CQ_TYPE_RX.
+	 */
+	struct ana_rxq *rxq;
+
+	/* Pointer to the ana_txq that is pushing TX CQEs to the queue.
+	 * Only and must be non-NULL if type is ANA_CQ_TYPE_TX.
+	 */
+	struct ana_txq *txq;
+
+	/* Pointer to a buffer which the CQ handler can copy the CQE's into. */
+	struct gdma_comp *gdma_comp_buf;
+};
+
+#define GDMA_MAX_RQE_SGES 15
+
+struct ana_recv_buf_oob {
+	/* A valid GDMA work request representing the data buffer. */
+	struct gdma_wqe_request wqe_req;
+
+	void *buf_va;
+	dma_addr_t buf_dma_addr;
+
+	/* SGL of the buffer going to be sent has part of the work request. */
+	u32 num_sge;
+	struct gdma_sge sgl[GDMA_MAX_RQE_SGES];
+
+	/* Required to store the result of gdma_post_work_request.
+	 * gdma_posted_wqe_info.wqe_size_in_bu is required for progressing the
+	 * work queue when the WQE is consumed.
+	 */
+	struct gdma_posted_wqe_info wqe_inf;
+};
+
+struct ana_rxq {
+	struct {
+		struct gdma_queue *gdma_rq;
+
+		/* Total number of receive buffers to be allocated */
+		u32 num_rx_buf;
+
+		/* Index of RQ in the vPort, not gdma receive queue id */
+		u32 rxq_idx;
+
+		/* Cache the gdma receive queue id */
+		u32 gdma_id;
+		u32 datasize;
+		ana_handle_t rxobj;
+	};
+
+	struct ana_cq rx_cq;
+
+	struct net_device *ndev;
+	struct completion fencing_done;
+
+	u32 buf_index;
+
+	struct ana_stats stats;
+
+	/* MUST BE THE LAST MEMBER:
+	 * Each receive buffer has an associated ana_recv_buf_oob.
+	 */
+	struct ana_recv_buf_oob rx_oobs[];
+};
+
+struct ana_tx_qp {
+	struct ana_txq txq;
+	struct ana_cq tx_cq;
+	ana_handle_t tx_object;
+};
+
+struct ana_ethtool_stats {
+	u64 stop_queue;
+	u64 wake_queue;
+};
+
+struct ana_context {
+	struct gdma_dev *gdma_dev;
+	struct net_device *ndev;
+
+	u8 mac_addr[ETH_ALEN];
+
+	struct ana_eq *eqs;
+
+	enum TRI_STATE rss_state;
+
+	ana_handle_t default_rxobj;
+	bool tx_shortform_allowed;
+	u16 tx_vp_offset;
+
+	struct ana_tx_qp *tx_qp;
+
+	/* Indirection Table for RX & TX. The values are queue indexes */
+	u32 ind_table[ANA_INDIRECT_TABLE_SIZE];
+
+	/* Indirection table containing RxObject Handles */
+	ana_handle_t rxobj_table[ANA_INDIRECT_TABLE_SIZE];
+
+	/*  Hash key used by the NIC */
+	u8 hashkey[ANA_HASH_KEY_SIZE];
+
+	/* This points to an array of num_queues of RQ pointers. */
+	struct ana_rxq **rxqs;
+
+	/* Create num_queues EQs, SQs, SQ-CQs, RQs and RQ-CQs, respectively. */
+	unsigned int max_queues;
+	unsigned int num_queues;
+
+	ana_handle_t default_vport;
+
+	bool port_is_up;
+	bool port_st_save; /* Saved port state */
+	bool start_remove;
+
+	struct ana_ethtool_stats eth_stats;
+};
+
+int ana_config_rss(struct ana_context *ac, enum TRI_STATE rx,
+		   bool update_hash, bool update_tab);
+
+int ana_do_attach(struct net_device *ndev, bool reset_hash);
+int ana_detach(struct net_device *ndev);
+
+int ana_probe(struct gdma_dev *gd);
+void ana_remove(struct gdma_dev *gd);
+
+extern const struct ethtool_ops ana_ethtool_ops;
+
+struct ana_obj_spec {
+	u32 queue_index;
+	u64 gdma_region;
+	u32 queue_size;
+	u32 attached_eq;
+	u32 modr_ctx_id;
+};
+
+struct gdma_send_ana_message_req {
+	struct gdma_req_hdr hdr;
+	u32 msg_size;
+	u32 response_size;
+	u8 message[];
+} __packed;
+
+struct gdma_send_ana_message_resp {
+	struct gdma_resp_hdr hdr;
+	u8 response[];
+} __packed;
+
+enum ana_command_code {
+	ANA_QUERY_CLIENT_CONFIG	= 0x20001,
+	ANA_QUERY_GF_STAT	= 0x20002,
+	ANA_CONFIG_VPORT_TX	= 0x20003,
+	ANA_CREATE_WQ_OBJ	= 0x20004,
+	ANA_DESTROY_WQ_OBJ	= 0x20005,
+	ANA_FENCE_RQ		= 0x20006,
+	ANA_CONFIG_VPORT_RX	= 0x20007,
+	ANA_QUERY_VPORT_CONFIG	= 0x20008,
+};
+
+/* Query Client Configuration */
+struct ana_query_client_cfg_req {
+	struct gdma_req_hdr hdr;
+
+	/* Driver Capability flags */
+	u64 drv_cap_flags1;
+	u64 drv_cap_flags2;
+	u64 drv_cap_flags3;
+	u64 drv_cap_flags4;
+
+	/* Driver versions */
+	u32 drv_major_ver;
+	u32 drv_minor_ver;
+	u32 drv_micro_ver;
+} __packed;
+
+struct ana_query_client_cfg_resp {
+	struct gdma_resp_hdr hdr;
+
+	u64 pf_cap_flags1;
+	u64 pf_cap_flags2;
+	u64 pf_cap_flags3;
+	u64 pf_cap_flags4;
+
+	u16 max_num_vports;
+	u16 reserved;
+	u32 max_num_eqs;
+} __packed;
+
+/* Query Vport Configuration */
+struct ana_query_vport_cfg_req {
+	struct gdma_req_hdr hdr;
+	u32 vport_index;
+} __packed;
+
+struct ana_query_vport_cfg_resp {
+	struct gdma_resp_hdr hdr;
+	u32 max_num_sq;
+	u32 max_num_rq;
+	u32 num_indirection_ent;
+	u32 reserved1;
+	u8 mac_addr[6];
+	u8 reserved2[2];
+	ana_handle_t vport;
+} __packed;
+
+/* Configure Vport */
+struct ana_config_vport_req {
+	struct gdma_req_hdr hdr;
+	ana_handle_t vport;
+	u32 pdid;
+	u32 doorbell_pageid;
+} __packed;
+
+struct ana_config_vport_resp {
+	struct gdma_resp_hdr hdr;
+	u16 tx_vport_offset;
+	u8 short_form_allowed;
+	u8 reserved;
+} __packed;
+
+/* Create WQ Object */
+struct ana_create_wqobj_req {
+	struct gdma_req_hdr hdr;
+	ana_handle_t vport;
+	u32 wq_type;
+	u32 reserved;
+	u64 wq_gdma_region;
+	u64 cq_gdma_region;
+	u32 wq_size;
+	u32 cq_size;
+	u32 cq_moderation_ctx_id;
+	u32 cq_parent_qid;
+} __packed;
+
+struct ana_create_wqobj_resp {
+	struct gdma_resp_hdr hdr;
+	u32 wq_id;
+	u32 cq_id;
+	ana_handle_t wq_obj;
+} __packed;
+
+/* Destroy WQ Object */
+struct ana_destroy_wqobj_req {
+	struct gdma_req_hdr hdr;
+	u32 wq_type;
+	u32 reserved;
+	ana_handle_t wqobj_handle;
+} __packed;
+
+struct ana_destroy_wqobj_resp {
+	struct gdma_resp_hdr hdr;
+} __packed;
+
+/* Fence RQ */
+struct ana_fence_rq_req {
+	struct gdma_req_hdr hdr;
+	ana_handle_t wqobj_handle;
+} __packed;
+
+struct ana_fence_rq_resp {
+	struct gdma_resp_hdr hdr;
+} __packed;
+
+/* Configure Vport Rx Steering */
+struct ana_cfg_rx_steer_req {
+	struct gdma_req_hdr hdr;
+	ana_handle_t vport;
+	u16 num_indir_entries;
+	u16 indir_tab_offset;
+	u32 rx_enable;
+	u32 rss_enable;
+	u8 update_default_rxobj;
+	u8 update_hashkey;
+	u8 update_indir_tab;
+	u8 reserved;
+	ana_handle_t default_rxobj;
+	u8 hashkey[ANA_HASH_KEY_SIZE];
+} __packed;
+
+struct ana_cfg_rx_steer_resp {
+	struct gdma_resp_hdr hdr;
+} __packed;
+
+/* The max number of queues that are potentially supported. */
+#define ANA_MAX_NUM_QUEUE 64
+
+/* ANA uses 1 SQ and 1 RQ for every cpu, but up to 16 by default. */
+#define ANA_DEFAULT_NUM_QUEUE 16
+
+#define ANA_SHORT_VPORT_OFFSET_MAX ((1U << 8) - 1)
+
+struct ana_tx_package {
+	struct gdma_wqe_request wqe_req;
+	struct gdma_sge sgl_array[5];
+	struct gdma_sge *sgl_ptr;
+
+	struct ana_tx_oob tx_oob;
+
+	struct gdma_posted_wqe_info wqe_info;
+};
+
+#endif /* _MANA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
new file mode 100644
index 000000000000..8d2ecabf9413
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -0,0 +1,1833 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#include <linux/inetdevice.h>
+#include <linux/etherdevice.h>
+
+#include <net/checksum.h>
+#include <net/ip6_checksum.h>
+
+#include "mana.h"
+
+/* Microsoft Azure Network Adapter (ANA) functions */
+
+static int ana_open(struct net_device *ndev)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+
+	ac->port_is_up = true;
+
+	/* Ensure port state updated before txq state */
+	smp_wmb();
+
+	netif_carrier_on(ndev);
+	netif_tx_wake_all_queues(ndev);
+
+	return 0;
+}
+
+static int ana_close(struct net_device *ndev)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+
+	ac->port_is_up = false;
+
+	/* Ensure port state updated before txq state */
+	smp_wmb();
+
+	netif_tx_disable(ndev);
+	netif_carrier_off(ndev);
+
+	return 0;
+}
+
+static bool gdma_can_tx(struct gdma_queue *wq)
+{
+	return gdma_wq_avail_space(wq) >= MAX_TX_WQE_SIZE;
+}
+
+static unsigned int  ana_checksum_info(struct sk_buff *skb)
+{
+	if (skb->protocol == htons(ETH_P_IP)) {
+		struct iphdr *ip = ip_hdr(skb);
+
+		if (ip->protocol == IPPROTO_TCP)
+			return IPPROTO_TCP;
+
+		if (ip->protocol == IPPROTO_UDP)
+			return IPPROTO_UDP;
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		struct ipv6hdr *ip6 = ipv6_hdr(skb);
+
+		if (ip6->nexthdr == IPPROTO_TCP)
+			return IPPROTO_TCP;
+
+		if (ip6->nexthdr == IPPROTO_UDP)
+			return IPPROTO_UDP;
+	}
+
+	/* No csum offloading */
+	return 0;
+}
+
+static int ana_map_skb(struct sk_buff *skb, struct ana_context *ac,
+		       struct ana_tx_package *tp)
+{
+	struct ana_skb_head *ash = (struct ana_skb_head *)skb->head;
+	struct gdma_dev *gd = ac->gdma_dev;
+	struct gdma_context *gc;
+	struct device *dev;
+	skb_frag_t *frag;
+	dma_addr_t da;
+	int i;
+
+	gc = ana_to_gdma_context(gd);
+	dev = gc->dev;
+	da = dma_map_single(dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
+
+	if (dma_mapping_error(dev, da))
+		return -ENOMEM;
+
+	ash->dma_handle[0] = da;
+	ash->size[0] = skb_headlen(skb);
+
+	tp->wqe_req.sgl[0].address = ash->dma_handle[0];
+	tp->wqe_req.sgl[0].mem_key = gd->gpa_mkey;
+	tp->wqe_req.sgl[0].size = ash->size[0];
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		frag = &skb_shinfo(skb)->frags[i];
+		da = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
+				      DMA_TO_DEVICE);
+
+		if (dma_mapping_error(dev, da))
+			goto frag_err;
+
+		ash->dma_handle[i + 1] = da;
+		ash->size[i + 1] = skb_frag_size(frag);
+
+		tp->wqe_req.sgl[i + 1].address = ash->dma_handle[i + 1];
+		tp->wqe_req.sgl[i + 1].mem_key = gd->gpa_mkey;
+		tp->wqe_req.sgl[i + 1].size = ash->size[i + 1];
+	}
+
+	return 0;
+
+frag_err:
+	for (i = i - 1; i >= 0; i--)
+		dma_unmap_page(dev, ash->dma_handle[i + 1], ash->size[i + 1],
+			       DMA_TO_DEVICE);
+
+	dma_unmap_single(dev, ash->dma_handle[0], ash->size[0], DMA_TO_DEVICE);
+
+	return -ENOMEM;
+}
+
+static int ana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	enum ana_tx_pkt_format pkt_fmt = ANA_SHORT_PKT_FMT;
+	struct ana_context *ac = netdev_priv(ndev);
+	u16 txq_idx = skb_get_queue_mapping(skb);
+	bool ipv4 = false, ipv6 = false;
+	struct ana_tx_package pkg = {};
+	struct netdev_queue *net_txq;
+	struct ana_stats *tx_stats;
+	struct gdma_queue *gdma_sq;
+	unsigned int csum_type;
+	struct ana_txq *txq;
+	struct ana_cq *cq;
+	int err, len;
+
+	if (unlikely(!ac->port_is_up))
+		goto tx_drop;
+
+	if (skb_cow_head(skb, ANA_HEADROOM))
+		goto tx_drop_count;
+
+	txq = &ac->tx_qp[txq_idx].txq;
+	gdma_sq = txq->gdma_sq;
+	cq = &ac->tx_qp[txq_idx].tx_cq;
+
+	pkg.tx_oob.s_oob.vcq_num = cq->gdma_id;
+	pkg.tx_oob.s_oob.vsq_frame = txq->vsq_frame;
+
+	if (txq->vp_offset > ANA_SHORT_VPORT_OFFSET_MAX) {
+		pkg.tx_oob.l_oob.long_vp_offset = txq->vp_offset;
+		pkt_fmt = ANA_LONG_PKT_FMT;
+	} else {
+		pkg.tx_oob.s_oob.short_vp_offset = txq->vp_offset;
+	}
+
+	pkg.tx_oob.s_oob.pkt_fmt = pkt_fmt;
+
+	if (pkt_fmt == ANA_SHORT_PKT_FMT)
+		pkg.wqe_req.inline_oob_size = sizeof(struct ana_tx_short_oob);
+	else
+		pkg.wqe_req.inline_oob_size = sizeof(struct ana_tx_oob);
+
+	pkg.wqe_req.inline_oob_data = &pkg.tx_oob;
+	pkg.wqe_req.flags = 0;
+	pkg.wqe_req.client_data_unit = 0;
+
+	pkg.wqe_req.num_sge = 1 + skb_shinfo(skb)->nr_frags;
+	WARN_ON(pkg.wqe_req.num_sge > 30);
+
+	if (pkg.wqe_req.num_sge <= ARRAY_SIZE(pkg.sgl_array)) {
+		pkg.wqe_req.sgl = pkg.sgl_array;
+	} else {
+		pkg.sgl_ptr = kmalloc_array(pkg.wqe_req.num_sge,
+					    sizeof(struct gdma_sge),
+					    GFP_ATOMIC);
+		if (!pkg.sgl_ptr)
+			goto tx_drop_count;
+
+		pkg.wqe_req.sgl = pkg.sgl_ptr;
+	}
+
+	if (skb->protocol == htons(ETH_P_IP))
+		ipv4 = true;
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		ipv6 = true;
+
+	if (skb_is_gso(skb)) {
+		pkg.tx_oob.s_oob.is_outer_ipv4 = ipv4;
+		pkg.tx_oob.s_oob.is_outer_ipv6 = ipv6;
+
+		pkg.tx_oob.s_oob.comp_iphdr_csum = 1;
+		pkg.tx_oob.s_oob.comp_tcp_csum = 1;
+		pkg.tx_oob.s_oob.trans_off = skb_transport_offset(skb);
+
+		pkg.wqe_req.client_data_unit = skb_shinfo(skb)->gso_size;
+		pkg.wqe_req.flags = GDMA_WR_OOB_IN_SGL |
+				    GDMA_WR_PAD_DATA_BY_FIRST_SGE;
+		if (ipv4) {
+			ip_hdr(skb)->tot_len = 0;
+			ip_hdr(skb)->check = 0;
+			tcp_hdr(skb)->check =
+				~csum_tcpudp_magic(ip_hdr(skb)->saddr,
+						   ip_hdr(skb)->daddr, 0,
+						   IPPROTO_TCP, 0);
+		} else {
+			ipv6_hdr(skb)->payload_len = 0;
+			tcp_hdr(skb)->check =
+				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+						 &ipv6_hdr(skb)->daddr, 0,
+						 IPPROTO_TCP, 0);
+		}
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		csum_type = ana_checksum_info(skb);
+
+		if (csum_type == IPPROTO_TCP) {
+			pkg.tx_oob.s_oob.is_outer_ipv4 = ipv4;
+			pkg.tx_oob.s_oob.is_outer_ipv6 = ipv6;
+
+			pkg.tx_oob.s_oob.comp_tcp_csum = 1;
+			pkg.tx_oob.s_oob.trans_off = skb_transport_offset(skb);
+
+		} else if (csum_type == IPPROTO_UDP) {
+			pkg.tx_oob.s_oob.is_outer_ipv4 = ipv4;
+			pkg.tx_oob.s_oob.is_outer_ipv6 = ipv6;
+
+			pkg.tx_oob.s_oob.comp_udp_csum = 1;
+		} else {
+			/* Can't do offload of this type of checksum */
+			if (skb_checksum_help(skb))
+				goto free_sgl_ptr;
+		}
+	}
+
+	if (ana_map_skb(skb, ac, &pkg))
+		goto free_sgl_ptr;
+
+	skb_queue_tail(&txq->pending_skbs, skb);
+
+	len = skb->len;
+	net_txq = netdev_get_tx_queue(ndev, txq_idx);
+
+	err = gdma_post_work_request(gdma_sq, &pkg.wqe_req,
+				     (struct gdma_posted_wqe_info *)skb->cb);
+	if (!gdma_can_tx(gdma_sq)) {
+		netif_tx_stop_queue(net_txq);
+		ac->eth_stats.stop_queue++;
+	}
+
+	if (err) {
+		(void)skb_dequeue_tail(&txq->pending_skbs);
+		netdev_warn(ndev, "Failed to post TX OOB: %d\n", err);
+		err = NETDEV_TX_BUSY;
+		goto tx_busy;
+	}
+
+	err = NETDEV_TX_OK;
+	atomic_inc(&txq->pending_sends);
+
+	gdma_wq_ring_doorbell(ana_to_gdma_context(gdma_sq->gdma_dev), gdma_sq);
+
+	/* skb may be freed after gdma_post_work_request. Do not use it. */
+	skb = NULL;
+
+	tx_stats = &txq->stats;
+	u64_stats_update_begin(&tx_stats->syncp);
+	tx_stats->packets++;
+	tx_stats->bytes += len;
+	u64_stats_update_end(&tx_stats->syncp);
+
+tx_busy:
+	if (netif_tx_queue_stopped(net_txq) && gdma_can_tx(gdma_sq)) {
+		netif_tx_wake_queue(net_txq);
+		ac->eth_stats.wake_queue++;
+	}
+
+	kfree(pkg.sgl_ptr);
+	return err;
+
+free_sgl_ptr:
+	kfree(pkg.sgl_ptr);
+tx_drop_count:
+	ndev->stats.tx_dropped++;
+tx_drop:
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
+static void ana_get_stats64(struct net_device *ndev,
+			    struct rtnl_link_stats64 *st)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	unsigned int num_queues = ac->num_queues;
+	struct ana_stats *stats;
+	unsigned int start;
+	u64 packets, bytes;
+	int q;
+
+	if (ac->start_remove)
+		return;
+
+	netdev_stats_to_stats64(st, &ndev->stats);
+
+	for (q = 0; q < num_queues; q++) {
+		stats = &ac->rxqs[q]->stats;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			packets = stats->packets;
+			bytes = stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		st->rx_packets += packets;
+		st->rx_bytes += bytes;
+	}
+
+	for (q = 0; q < num_queues; q++) {
+		stats = &ac->tx_qp[q].txq.stats;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			packets = stats->packets;
+			bytes = stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		st->tx_packets += packets;
+		st->tx_bytes += bytes;
+	}
+}
+
+static int ana_get_tx_queue(struct net_device *ndev, struct sk_buff *skb,
+			    int old_q)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	struct sock *sk = skb->sk;
+	int txq;
+
+	txq = ac->ind_table[skb_get_hash(skb) & (ANA_INDIRECT_TABLE_SIZE - 1)];
+
+	if (txq != old_q && sk && sk_fullsock(sk) &&
+	    rcu_access_pointer(sk->sk_dst_cache))
+		sk_tx_queue_set(sk, txq);
+
+	return txq;
+}
+
+static u16 ana_select_queue(struct net_device *ndev, struct sk_buff *skb,
+			    struct net_device *sb_dev)
+{
+	int txq;
+
+	if (ndev->real_num_tx_queues == 1)
+		return 0;
+
+	txq = sk_tx_queue_get(skb->sk);
+
+	if (txq < 0 || skb->ooo_okay || txq >= ndev->real_num_tx_queues) {
+		if (skb_rx_queue_recorded(skb))
+			txq = skb_get_rx_queue(skb);
+		else
+			txq = ana_get_tx_queue(ndev, skb, txq);
+	}
+
+	return txq;
+}
+
+static const struct net_device_ops ana_devops = {
+	.ndo_open = ana_open,
+	.ndo_stop = ana_close,
+	.ndo_select_queue = ana_select_queue,
+	.ndo_start_xmit = ana_start_xmit,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_get_stats64 = ana_get_stats64,
+};
+
+static void ana_cleanup_context(struct ana_context *ac)
+{
+	struct gdma_dev *gd = ac->gdma_dev;
+
+	gdma_deregister_device(gd);
+
+	kfree(ac->rxqs);
+	ac->rxqs = NULL;
+}
+
+static int ana_init_context(struct ana_context *ac)
+{
+	struct gdma_dev *gd = ac->gdma_dev;
+	int err;
+
+	gd->pdid = INVALID_PDID;
+	gd->doorbell = INVALID_DOORBELL;
+
+	ac->rxqs = kcalloc(ac->num_queues, sizeof(struct ana_rxq *),
+			   GFP_KERNEL);
+	if (!ac->rxqs)
+		return -ENOMEM;
+
+	err = gdma_register_device(gd);
+	if (err) {
+		kfree(ac->rxqs);
+		ac->rxqs = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+static int ana_send_request(struct ana_context *ac, void *in_buf,
+			    u32 in_buf_len, void *out_buf, u32 out_buf_len)
+{
+	struct gdma_context *gc = ana_to_gdma_context(ac->gdma_dev);
+	struct gdma_send_ana_message_resp *resp = NULL;
+	struct gdma_send_ana_message_req *req = NULL;
+	struct net_device *ndev = ac->ndev;
+	int err;
+
+	if (is_gdma_msg_len(in_buf_len, out_buf_len, in_buf)) {
+		struct gdma_req_hdr *g_req = in_buf;
+		struct gdma_resp_hdr *g_resp = out_buf;
+
+		static atomic_t act_id;
+
+		g_req->dev_id = gc->ana.dev_id;
+		g_req->activity_id = atomic_inc_return(&act_id);
+
+		err = gdma_send_request(gc, in_buf_len, in_buf, out_buf_len,
+					out_buf);
+		if (err || g_resp->status) {
+			netdev_err(ndev, "Send GDMA message failed: %d, 0x%x\n",
+				   err, g_resp->status);
+			return -EPROTO;
+		}
+
+		if (g_req->dev_id.as_uint32 != g_resp->dev_id.as_uint32 ||
+		    g_req->activity_id != g_resp->activity_id) {
+			netdev_err(ndev, "Wrong GDMA response: %x,%x,%x,%x\n",
+				   g_req->dev_id.as_uint32,
+				   g_resp->dev_id.as_uint32, g_req->activity_id,
+				   g_resp->activity_id);
+			return -EPROTO;
+		}
+
+		return 0;
+
+	} else {
+		u32 req_size = sizeof(*req) + in_buf_len;
+		u32 resp_size = sizeof(*resp) + out_buf_len;
+
+		req = kzalloc(req_size, GFP_KERNEL);
+		if (!req) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		resp = kzalloc(resp_size, GFP_KERNEL);
+		if (!resp) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		req->hdr.dev_id = gc->ana.dev_id;
+		req->msg_size = in_buf_len;
+		req->response_size = out_buf_len;
+		memcpy(req->message, in_buf, in_buf_len);
+
+		err = gdma_send_request(gc, req_size, req, resp_size, resp);
+		if (err || resp->hdr.status) {
+			netdev_err(ndev, "Send ANA message failed: %d, 0x%x\n",
+				   err, resp->hdr.status);
+			if (!err)
+				err = -EPROTO;
+			goto out;
+		}
+
+		memcpy(out_buf, resp->response, out_buf_len);
+	}
+
+out:
+	kfree(resp);
+	kfree(req);
+	return err;
+}
+
+static int ana_verify_gdma_resp_hdr(const struct gdma_resp_hdr *resp_hdr,
+				    const enum ana_command_code expected_code,
+				    const u32 min_size)
+{
+	if (resp_hdr->response.msg_type != expected_code)
+		return -EPROTO;
+
+	if (resp_hdr->response.msg_version < GDMA_MESSAGE_V1)
+		return -EPROTO;
+
+	if (resp_hdr->response.msg_size < min_size)
+		return -EPROTO;
+
+	return 0;
+}
+
+static int ana_query_client_cfg(struct ana_context *ac, u32 drv_major_ver,
+				u32 drv_minor_ver, u32 drv_micro_ver,
+				u16 *max_num_vports)
+{
+	struct ana_query_client_cfg_resp resp = {};
+	struct ana_query_client_cfg_req req = {};
+	int err = 0;
+
+	gdma_init_req_hdr(&req.hdr, ANA_QUERY_CLIENT_CONFIG,
+			  sizeof(req), sizeof(resp));
+	req.drv_major_ver = drv_major_ver;
+	req.drv_minor_ver = drv_minor_ver;
+	req.drv_micro_ver = drv_micro_ver;
+
+	err = ana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp));
+	if (err) {
+		netdev_err(ac->ndev, "Failed to query config: %d", err);
+		return err;
+	}
+
+	err = ana_verify_gdma_resp_hdr(&resp.hdr, ANA_QUERY_CLIENT_CONFIG,
+				       sizeof(resp));
+	if (err || resp.hdr.status) {
+		netdev_err(ac->ndev, "Invalid query result: %d, 0x%x\n", err,
+			   resp.hdr.status);
+		if (!err)
+			err = -EPROTO;
+		return err;
+	}
+
+	*max_num_vports = resp.max_num_vports;
+
+	return 0;
+}
+
+static int ana_query_vport_cfg(struct ana_context *ac, u32 vport_index,
+			       u32 *max_sq, u32 *max_rq, u32 *num_indir_entry)
+{
+	struct ana_query_vport_cfg_resp resp = {};
+	struct ana_query_vport_cfg_req req = {};
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, ANA_QUERY_VPORT_CONFIG,
+			  sizeof(req), sizeof(resp));
+
+	req.vport_index = vport_index;
+
+	err = ana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp));
+	if (err)
+		return err;
+
+	err = ana_verify_gdma_resp_hdr(&resp.hdr, ANA_QUERY_VPORT_CONFIG,
+				       sizeof(resp));
+	if (err)
+		return err;
+
+	if (resp.hdr.status)
+		return -EPROTO;
+
+	*max_sq = resp.max_num_sq;
+	*max_rq = resp.max_num_rq;
+	*num_indir_entry = resp.num_indirection_ent;
+
+	ac->default_vport = resp.vport;
+	memcpy(ac->mac_addr, resp.mac_addr, ETH_ALEN);
+
+	return 0;
+}
+
+static int ana_cfg_vport(struct ana_context *ac, u32 protection_dom_id,
+			 u32 doorbell_pg_id)
+{
+	struct ana_config_vport_resp resp = {};
+	struct ana_config_vport_req req = {};
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, ANA_CONFIG_VPORT_TX,
+			  sizeof(req), sizeof(resp));
+	req.vport = ac->default_vport;
+	req.pdid = protection_dom_id;
+	req.doorbell_pageid = doorbell_pg_id;
+
+	err = ana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp));
+	if (err) {
+		netdev_err(ac->ndev, "Failed to configure vPort TX: %d\n", err);
+		goto out;
+	}
+
+	err = ana_verify_gdma_resp_hdr(&resp.hdr, ANA_CONFIG_VPORT_TX,
+				       sizeof(resp));
+	if (err || resp.hdr.status) {
+		netdev_err(ac->ndev, "Failed to configure vPort TX: %d, 0x%x\n",
+			   err, resp.hdr.status);
+		if (!err)
+			err = -EPROTO;
+
+		goto out;
+	}
+
+	ac->tx_shortform_allowed = resp.short_form_allowed;
+	ac->tx_vp_offset = resp.tx_vport_offset;
+out:
+	return err;
+}
+
+static int ana_cfg_vport_steering(struct ana_context *ac, enum TRI_STATE rx,
+				  bool update_default_rxobj, bool update_key,
+				  bool update_tab)
+{
+	u16 num_entries = ANA_INDIRECT_TABLE_SIZE;
+	struct ana_cfg_rx_steer_req *req = NULL;
+	struct ana_cfg_rx_steer_resp resp = {};
+	struct net_device *ndev = ac->ndev;
+	ana_handle_t *req_indir_tab;
+	u32 req_buf_size;
+	int err;
+
+	if (update_key && !ac->hashkey)
+		return -EINVAL;
+
+	if (update_tab && !ac->rxobj_table)
+		return -EINVAL;
+
+	req_buf_size = sizeof(*req) + sizeof(ana_handle_t) * num_entries;
+	req = kzalloc(req_buf_size, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	gdma_init_req_hdr(&req->hdr, ANA_CONFIG_VPORT_RX, req_buf_size,
+			  sizeof(resp));
+
+	req->vport = ac->default_vport;
+	req->num_indir_entries = num_entries;
+	req->indir_tab_offset = sizeof(*req);
+	req->rx_enable = rx;
+	req->rss_enable = ac->rss_state;
+	req->update_default_rxobj = update_default_rxobj;
+	req->update_hashkey = update_key;
+	req->update_indir_tab = update_tab;
+	req->default_rxobj = ac->default_rxobj;
+
+	if (update_key)
+		memcpy(&req->hashkey, ac->hashkey, ANA_HASH_KEY_SIZE);
+
+	if (update_tab) {
+		req_indir_tab = (ana_handle_t *)(req + 1);
+		memcpy(req_indir_tab, ac->rxobj_table,
+		       req->num_indir_entries * sizeof(ana_handle_t));
+	}
+
+	err = ana_send_request(ac, req, req_buf_size, &resp, sizeof(resp));
+	if (err) {
+		netdev_err(ndev, "Failed to configure vPort RX: %d\n", err);
+		goto out;
+	}
+
+	err = ana_verify_gdma_resp_hdr(&resp.hdr, ANA_CONFIG_VPORT_RX,
+				       sizeof(resp));
+	if (err) {
+		netdev_err(ndev, "vPort RX configuration failed: %d\n", err);
+		goto out;
+	}
+
+	if (resp.hdr.status) {
+		netdev_err(ndev, "vPort RX configuration failed: 0x%x\n",
+			   resp.hdr.status);
+		err = -EPROTO;
+	}
+out:
+	kfree(req);
+	return err;
+}
+
+static int ana_create_wq_obj(struct ana_context *ac, ana_handle_t vport,
+			     u32 wq_type, struct ana_obj_spec *wq_spec,
+			     struct ana_obj_spec *cq_spec, ana_handle_t *wq_obj)
+{
+	struct ana_create_wqobj_resp resp = {};
+	struct ana_create_wqobj_req req = {};
+	struct net_device *ndev = ac->ndev;
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, ANA_CREATE_WQ_OBJ,
+			  sizeof(req), sizeof(resp));
+	req.vport = vport;
+	req.wq_type = wq_type;
+	req.wq_gdma_region = wq_spec->gdma_region;
+	req.cq_gdma_region = cq_spec->gdma_region;
+	req.wq_size = wq_spec->queue_size;
+	req.cq_size = cq_spec->queue_size;
+	req.cq_moderation_ctx_id = cq_spec->modr_ctx_id;
+	req.cq_parent_qid = cq_spec->attached_eq;
+
+	err = ana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp));
+	if (err) {
+		netdev_err(ndev, "Failed to create WQ object: %d\n", err);
+		goto out;
+	}
+
+	err = ana_verify_gdma_resp_hdr(&resp.hdr, ANA_CREATE_WQ_OBJ,
+				       sizeof(resp));
+	if (err || resp.hdr.status) {
+		netdev_err(ndev, "Failed to create WQ object: %d, 0x%x\n", err,
+			   resp.hdr.status);
+		if (!err)
+			err = -EPROTO;
+		goto out;
+	}
+
+	if (resp.wq_obj == INVALID_ANA_HANDLE) {
+		netdev_err(ndev, "Failed to create WQ object: invalid handle\n");
+		err = -EPROTO;
+		goto out;
+	}
+
+	*wq_obj = resp.wq_obj;
+	wq_spec->queue_index = resp.wq_id;
+	cq_spec->queue_index = resp.cq_id;
+
+	return 0;
+
+out:
+	return err;
+}
+
+static void ana_destroy_wq_obj(struct ana_context *ac, u32 wq_type,
+			       ana_handle_t wq_obj)
+{
+	struct ana_destroy_wqobj_resp resp = {};
+	struct ana_destroy_wqobj_req req = {};
+	struct net_device *ndev = ac->ndev;
+	int err;
+
+	gdma_init_req_hdr(&req.hdr, ANA_DESTROY_WQ_OBJ,
+			  sizeof(req), sizeof(resp));
+	req.wq_type = wq_type;
+	req.wqobj_handle = wq_obj;
+
+	err = ana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp));
+	if (err) {
+		netdev_err(ndev, "Failed to destroy WQ object: %d\n", err);
+		return;
+	}
+
+	err = ana_verify_gdma_resp_hdr(&resp.hdr, ANA_DESTROY_WQ_OBJ,
+				       sizeof(resp));
+	if (err || resp.hdr.status)
+		netdev_err(ndev, "Failed to destroy WQ object: %d, 0x%x\n", err,
+			   resp.hdr.status);
+}
+
+static void ana_init_cqe_pollbuf(struct gdma_comp *cqe_poll_buf)
+{
+	int i;
+
+	for (i = 0; i < CQE_POLLING_BUFFER; i++)
+		memset(&cqe_poll_buf[i], 0, sizeof(struct gdma_comp));
+}
+
+static void ana_destroy_eq(struct gdma_context *gc, struct ana_context *ac)
+{
+	struct gdma_queue *eq;
+	int i;
+
+	if (!ac->eqs)
+		return;
+
+	for (i = 0; i < ac->num_queues; i++) {
+		eq = ac->eqs[i].eq;
+		if (!eq)
+			continue;
+
+		gdma_destroy_queue(gc, eq);
+	}
+
+	kfree(ac->eqs);
+	ac->eqs = NULL;
+}
+
+static int ana_create_eq(struct ana_context *ac)
+{
+	struct gdma_dev *gd = ac->gdma_dev;
+	struct gdma_queue_spec spec = {};
+	int err;
+	int i;
+
+	ac->eqs = kcalloc(ac->num_queues, sizeof(struct ana_eq),
+			  GFP_KERNEL);
+	if (!ac->eqs)
+		return -ENOMEM;
+
+	spec.type = GDMA_EQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = EQ_SIZE;
+	spec.eq.callback = NULL;
+	spec.eq.context = ac->eqs;
+	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
+
+	for (i = 0; i < ac->num_queues; i++) {
+		ana_init_cqe_pollbuf(ac->eqs[i].cqe_poll);
+
+		err = gdma_create_ana_eq(gd, &spec, &ac->eqs[i].eq);
+		if (err)
+			goto out;
+	}
+
+	return 0;
+out:
+	ana_destroy_eq(ana_to_gdma_context(gd), ac);
+	return err;
+}
+
+static int gdma_move_wq_tail(struct gdma_queue *wq, u32 num_units)
+{
+	u32 used_space_old;
+	u32 used_space_new;
+
+	used_space_old = wq->head - wq->tail;
+	used_space_new = wq->head - (wq->tail + num_units);
+
+	if (used_space_new > used_space_old) {
+		WARN_ON(1);
+		return -ERANGE;
+	}
+
+	wq->tail += num_units;
+	return 0;
+}
+
+static void ana_unmap_skb(struct sk_buff *skb, struct ana_context *ac)
+{
+	struct gdma_context *gc = ana_to_gdma_context(ac->gdma_dev);
+	struct ana_skb_head *ash = (struct ana_skb_head *)skb->head;
+	struct device *dev = gc->dev;
+	int i;
+
+	dma_unmap_single(dev, ash->dma_handle[0], ash->size[0], DMA_TO_DEVICE);
+
+	for (i = 1; i < skb_shinfo(skb)->nr_frags + 1; i++)
+		dma_unmap_page(dev, ash->dma_handle[i], ash->size[i],
+			       DMA_TO_DEVICE);
+}
+
+static void ana_poll_tx_cq(struct ana_cq *cq)
+{
+	struct net_device *ndev = cq->gdma_cq->gdma_dev->driver_data;
+	struct gdma_comp *completions = cq->gdma_comp_buf;
+	struct gdma_queue *eqkb = cq->gdma_cq->cq.parent;
+	struct ana_context *ac = netdev_priv(ndev);
+	struct gdma_posted_wqe_info *wqe_info;
+	unsigned int pkt_transmitted = 0;
+	unsigned int wqe_unit_cnt = 0;
+	struct ana_txq *txq = cq->txq;
+	struct netdev_queue *net_txq;
+	unsigned int avail_space;
+	struct gdma_queue *wq;
+	struct sk_buff *skb;
+	bool txq_stopped;
+	int comp_read;
+	int i;
+
+	comp_read = gdma_poll_cq(cq->gdma_cq, completions, CQE_POLLING_BUFFER);
+
+	for (i = 0; i < comp_read; i++) {
+		struct ana_tx_comp_oob *cqe_oob;
+
+		if (WARN_ON(!completions[i].is_sq))
+			return;
+
+		cqe_oob = (struct ana_tx_comp_oob *)completions[i].cqe_data;
+		if (WARN_ON(cqe_oob->cqe_hdr.client_type != ANA_CQE_COMPLETION))
+			return;
+
+		switch (cqe_oob->cqe_hdr.cqe_type) {
+		case CQE_TX_OKAY:
+			break;
+
+		case CQE_TX_SA_DROP:
+		case CQE_TX_MTU_DROP:
+		case CQE_TX_INVALID_OOB:
+		case CQE_TX_INVALID_ETH_TYPE:
+		case CQE_TX_HDR_PROCESSING_ERROR:
+		case CQE_TX_VF_DISABLED:
+		case CQE_TX_VPORT_IDX_OUT_OF_RANGE:
+		case CQE_TX_VPORT_DISABLED:
+		case CQE_TX_VLAN_TAGGING_VIOLATION:
+			WARN(1, "TX: CQE error %d: ignored.\n",
+			     cqe_oob->cqe_hdr.cqe_type);
+			break;
+
+		default:
+			/* If the CQE type is unexpected, log an error, assert,
+			 * and go through the error path.
+			 */
+			WARN(1, "TX: Unexpected CQE type %d: HW BUG?\n",
+			     cqe_oob->cqe_hdr.cqe_type);
+			return;
+		}
+
+		if (WARN_ON(txq->gdma_txq_id != completions[i].wq_num))
+			return;
+
+		skb = skb_dequeue(&txq->pending_skbs);
+		if (WARN_ON(!skb))
+			return;
+
+		wqe_info = (struct gdma_posted_wqe_info *)skb->cb;
+		wqe_unit_cnt += wqe_info->wqe_size_in_bu;
+
+		ana_unmap_skb(skb, ac);
+
+		napi_consume_skb(skb, eqkb->eq.budget);
+
+		pkt_transmitted++;
+	}
+
+	if (WARN_ON(wqe_unit_cnt == 0))
+		return;
+
+	gdma_move_wq_tail(txq->gdma_sq, wqe_unit_cnt);
+
+	wq = txq->gdma_sq;
+	avail_space = gdma_wq_avail_space(wq);
+
+	/* Ensure tail updated before checking q stop */
+	smp_mb();
+
+	net_txq = txq->net_txq;
+	txq_stopped = netif_tx_queue_stopped(net_txq);
+
+	if (txq_stopped && ac->port_is_up && avail_space >= MAX_TX_WQE_SIZE) {
+		netif_tx_wake_queue(net_txq);
+		ac->eth_stats.wake_queue++;
+	}
+
+	if (atomic_sub_return(pkt_transmitted, &txq->pending_sends) < 0)
+		WARN_ON(1);
+}
+
+static void ana_post_pkt_rxq(struct ana_rxq *rxq)
+{
+	struct ana_recv_buf_oob *recv_buf_oob;
+	u32 curr_index;
+	int err;
+
+	curr_index = rxq->buf_index++;
+	if (rxq->buf_index == rxq->num_rx_buf)
+		rxq->buf_index = 0;
+
+	recv_buf_oob = &rxq->rx_oobs[curr_index];
+
+	err = gdma_post_and_ring(rxq->gdma_rq, &recv_buf_oob->wqe_req,
+				 &recv_buf_oob->wqe_inf);
+	if (WARN_ON(err))
+		return;
+
+	WARN_ON(recv_buf_oob->wqe_inf.wqe_size_in_bu != 1);
+}
+
+static void ana_rx_skb(void *buf_va, struct ana_rxcomp_oob *cqe,
+		       struct ana_rxq *rxq)
+{
+	struct ana_stats *rx_stats = &rxq->stats;
+	struct net_device *ndev = rxq->ndev;
+	uint pkt_len = cqe->ppi[0].pkt_len;
+	u16 rxq_idx = rxq->rxq_idx;
+	struct napi_struct *napi;
+	struct ana_context *ac;
+	struct gdma_queue *eq;
+	struct sk_buff *skb;
+	u32 hash_value;
+
+	ac = netdev_priv(ndev);
+	eq = ac->eqs[rxq_idx].eq;
+	eq->eq.work_done++;
+	napi = &eq->eq.napi;
+
+	if (!buf_va) {
+		++ndev->stats.rx_dropped;
+		return;
+	}
+
+	skb = build_skb(buf_va, PAGE_SIZE);
+
+	if (!skb) {
+		free_page((unsigned long)buf_va);
+		++ndev->stats.rx_dropped;
+		return;
+	}
+
+	skb_put(skb, pkt_len);
+	skb->dev = napi->dev;
+
+	skb->protocol = eth_type_trans(skb, ndev);
+	skb_checksum_none_assert(skb);
+	skb_record_rx_queue(skb, rxq_idx);
+
+	if ((ndev->features & NETIF_F_RXCSUM) && cqe->rx_iphdr_csum_succeed) {
+		if (cqe->rx_tcp_csum_succeed || cqe->rx_udp_csum_succeed)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+
+	if (cqe->rx_hashtype != 0 && (ndev->features & NETIF_F_RXHASH)) {
+		hash_value = cqe->ppi[0].pkt_hash;
+
+		if (cqe->rx_hashtype & ANA_HASH_L4)
+			skb_set_hash(skb, hash_value, PKT_HASH_TYPE_L4);
+		else
+			skb_set_hash(skb, hash_value, PKT_HASH_TYPE_L3);
+	}
+
+	napi_gro_receive(napi, skb);
+
+	u64_stats_update_begin(&rx_stats->syncp);
+	rx_stats->packets++;
+	rx_stats->bytes += pkt_len;
+	u64_stats_update_end(&rx_stats->syncp);
+}
+
+static void ana_process_rx_cqe(struct ana_rxq *rxq, struct ana_cq *cq,
+			       struct gdma_comp *cqe)
+{
+	struct gdma_context *gc = ana_to_gdma_context(rxq->gdma_rq->gdma_dev);
+	struct ana_rxcomp_oob *oob = (struct ana_rxcomp_oob *)cqe->cqe_data;
+	struct net_device *ndev = rxq->ndev;
+	struct ana_recv_buf_oob *rxbuf_oob;
+	struct device *dev = gc->dev;
+	void *new_buf, *old_buf;
+	struct page *new_page;
+	u32 curr, pktlen;
+	dma_addr_t da;
+
+	switch (oob->cqe_hdr.cqe_type) {
+	case CQE_RX_OKAY:
+		break;
+
+	case CQE_RX_TRUNCATED:
+		netdev_err(ndev, "Dropped a truncated packet\n");
+		return;
+
+	case CQE_RX_COALESCED_4:
+		netdev_err(ndev, "RX coalescing is unsupported\n");
+		return;
+
+	case CQE_RX_OBJECT_FENCE:
+		netdev_err(ndev, "RX Fencing is unsupported\n");
+		return;
+
+	default:
+		netdev_err(ndev, "Unknown RX CQE type = %d\n",
+			   oob->cqe_hdr.cqe_type);
+		return;
+	}
+
+	if (oob->cqe_hdr.cqe_type != CQE_RX_OKAY)
+		return;
+
+	pktlen = oob->ppi[0].pkt_len;
+
+	if (pktlen == 0) {
+		/* data packets should never have packetlength of zero */
+		netdev_err(ndev, "RX pkt len=0, rq=%u, cq=%u, rxobj=0x%llx\n",
+			   rxq->gdma_id, cq->gdma_id, rxq->rxobj);
+		return;
+	}
+
+	curr = rxq->buf_index;
+	rxbuf_oob = &rxq->rx_oobs[curr];
+	WARN_ON(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
+
+	new_page = alloc_page(GFP_ATOMIC);
+
+	if (new_page) {
+		da = dma_map_page(dev, new_page, 0, rxq->datasize,
+				  DMA_FROM_DEVICE);
+
+		if (dma_mapping_error(dev, da)) {
+			__free_page(new_page);
+			new_page = NULL;
+		}
+	}
+
+	new_buf = new_page ? page_to_virt(new_page) : NULL;
+
+	if (new_buf) {
+		dma_unmap_page(dev, rxbuf_oob->buf_dma_addr, rxq->datasize,
+			       DMA_FROM_DEVICE);
+
+		old_buf = rxbuf_oob->buf_va;
+
+		/* refresh the rxbuf_oob with the new page */
+		rxbuf_oob->buf_va = new_buf;
+		rxbuf_oob->buf_dma_addr = da;
+		rxbuf_oob->sgl[0].address = rxbuf_oob->buf_dma_addr;
+	} else {
+		old_buf = NULL; /* drop the packet if no memory */
+	}
+
+	ana_rx_skb(old_buf, oob, rxq);
+
+	gdma_move_wq_tail(rxq->gdma_rq, rxbuf_oob->wqe_inf.wqe_size_in_bu);
+
+	ana_post_pkt_rxq(rxq);
+}
+
+static void ana_poll_rx_cq(struct ana_cq *cq)
+{
+	struct gdma_comp *comp = cq->gdma_comp_buf;
+	u32 comp_read, i;
+
+	comp_read = gdma_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
+	WARN_ON(comp_read > CQE_POLLING_BUFFER);
+
+	for (i = 0; i < comp_read; i++) {
+		if (WARN_ON(comp[i].is_sq))
+			return;
+
+		/* verify recv cqe references the right rxq */
+		if (WARN_ON(comp[i].wq_num != cq->rxq->gdma_id))
+			return;
+
+		ana_process_rx_cqe(cq->rxq, cq, &comp[i]);
+	}
+}
+
+static void ana_cq_handler(void *context, struct gdma_queue *gdma_queue)
+{
+	struct ana_cq *cq = context;
+
+	WARN_ON(cq->gdma_cq != gdma_queue);
+
+	if (cq->type == ANA_CQ_TYPE_RX)
+		ana_poll_rx_cq(cq);
+	else
+		ana_poll_tx_cq(cq);
+
+	gdma_arm_cq(gdma_queue);
+}
+
+static void ana_deinit_cq(struct ana_context *ac, struct ana_cq *cq)
+{
+	if (!cq->gdma_cq)
+		return;
+
+	gdma_destroy_queue(ana_to_gdma_context(ac->gdma_dev), cq->gdma_cq);
+}
+
+static void ana_deinit_txq(struct ana_context *ac, struct ana_txq *txq)
+{
+	if (!txq->gdma_sq)
+		return;
+
+	gdma_destroy_queue(ana_to_gdma_context(ac->gdma_dev), txq->gdma_sq);
+}
+
+static void ana_destroy_txq(struct ana_context *ac)
+{
+	int i;
+
+	if (!ac->tx_qp)
+		return;
+
+	for (i = 0; i < ac->num_queues; i++) {
+		ana_destroy_wq_obj(ac, GDMA_SQ, ac->tx_qp[i].tx_object);
+
+		ana_deinit_cq(ac, &ac->tx_qp[i].tx_cq);
+
+		ana_deinit_txq(ac, &ac->tx_qp[i].txq);
+	}
+
+	kfree(ac->tx_qp);
+	ac->tx_qp = NULL;
+}
+
+static int ana_create_txq(struct ana_context *ac, struct net_device *net)
+{
+	struct gdma_dev *gd = ac->gdma_dev;
+	struct ana_obj_spec wq_spec;
+	struct ana_obj_spec cq_spec;
+	struct gdma_queue_spec spec;
+	struct gdma_context *gc;
+	struct ana_txq *txq;
+	struct ana_cq *cq;
+	u32 txq_size;
+	u32 cq_size;
+	int err;
+	int i;
+
+	ac->tx_qp = kcalloc(ac->num_queues, sizeof(struct ana_tx_qp),
+			    GFP_KERNEL);
+	if (!ac->tx_qp)
+		return -ENOMEM;
+
+	/*  The minimum size of the WQE is 32 bytes, hence
+	 *  MAX_SEND_BUFFERS_PER_QUEUE represents the maximum number of WQEs
+	 *  the send queue can store. This value is then used to size other
+	 *  queues in the driver to prevent overflow.
+	 *  SQ size must be divisible by PAGE_SIZE.
+	 */
+	txq_size = MAX_SEND_BUFFERS_PER_QUEUE * 32;
+	BUILD_BUG_ON(txq_size % PAGE_SIZE != 0);
+
+	cq_size = MAX_SEND_BUFFERS_PER_QUEUE * COMP_ENTRY_SIZE;
+	cq_size = ALIGN(cq_size, PAGE_SIZE);
+
+	gc = ana_to_gdma_context(gd);
+
+	for (i = 0; i < ac->num_queues; i++) {
+		ac->tx_qp[i].tx_object = INVALID_ANA_HANDLE;
+
+		/* create SQ */
+		txq = &ac->tx_qp[i].txq;
+
+		u64_stats_init(&txq->stats.syncp);
+		txq->net_txq = netdev_get_tx_queue(net, i);
+		txq->vp_offset = ac->tx_vp_offset;
+		skb_queue_head_init(&txq->pending_skbs);
+
+		memset(&spec, 0, sizeof(spec));
+		spec.type = GDMA_SQ;
+		spec.monitor_avl_buf = true;
+		spec.queue_size = txq_size;
+		err = gdma_create_ana_wq_cq(gd, &spec, &txq->gdma_sq);
+		if (err)
+			goto out;
+
+		/* create SQ's CQ */
+		cq = &ac->tx_qp[i].tx_cq;
+		cq->gdma_comp_buf = ac->eqs[i].cqe_poll;
+		cq->type = ANA_CQ_TYPE_TX;
+
+		cq->txq = txq;
+
+		memset(&spec, 0, sizeof(spec));
+		spec.type = GDMA_CQ;
+		spec.monitor_avl_buf = false;
+		spec.queue_size = cq_size;
+		spec.cq.callback = ana_cq_handler;
+		spec.cq.parent_eq = ac->eqs[i].eq;
+		spec.cq.context = cq;
+		err = gdma_create_ana_wq_cq(gd, &spec, &cq->gdma_cq);
+		if (err)
+			goto out;
+
+		memset(&wq_spec, 0, sizeof(wq_spec));
+		memset(&cq_spec, 0, sizeof(cq_spec));
+
+		wq_spec.gdma_region = txq->gdma_sq->mem_info.gdma_region;
+		wq_spec.queue_size = txq->gdma_sq->queue_size;
+
+		cq_spec.gdma_region = cq->gdma_cq->mem_info.gdma_region;
+		cq_spec.queue_size = cq->gdma_cq->queue_size;
+		cq_spec.modr_ctx_id = 0;
+		cq_spec.attached_eq = cq->gdma_cq->cq.parent->id;
+
+		err = ana_create_wq_obj(ac, ac->default_vport, GDMA_SQ,
+					&wq_spec, &cq_spec,
+					&ac->tx_qp[i].tx_object);
+
+		if (err)
+			goto out;
+
+		txq->gdma_sq->id = wq_spec.queue_index;
+		cq->gdma_cq->id = cq_spec.queue_index;
+
+		txq->gdma_sq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+		cq->gdma_cq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+
+		txq->gdma_txq_id = txq->gdma_sq->id;
+
+		cq->gdma_id = cq->gdma_cq->id;
+
+		if (cq->gdma_id >= gc->max_num_cq) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
+		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
+
+		gdma_arm_cq(cq->gdma_cq);
+	}
+
+	return 0;
+
+out:
+	ana_destroy_txq(ac);
+	return err;
+}
+
+static void gdma_napi_sync_for_rx(struct ana_rxq *rxq)
+{
+	struct net_device *ndev = rxq->ndev;
+	u16 rxq_idx = rxq->rxq_idx;
+	struct napi_struct *napi;
+	struct ana_context *ac;
+	struct gdma_queue *eq;
+
+	ac = netdev_priv(ndev);
+	eq = ac->eqs[rxq_idx].eq;
+	napi = &eq->eq.napi;
+
+	napi_synchronize(napi);
+}
+
+static void ana_destroy_rxq(struct ana_context *ac, struct ana_rxq *rxq,
+			    bool validate_state)
+
+{
+	struct gdma_context *gc = ana_to_gdma_context(ac->gdma_dev);
+	struct ana_recv_buf_oob *rx_oob;
+	struct device *dev = gc->dev;
+	int i;
+
+	if (!rxq)
+		return;
+
+	if (validate_state)
+		gdma_napi_sync_for_rx(rxq);
+
+	ana_destroy_wq_obj(ac, GDMA_RQ, rxq->rxobj);
+
+	ana_deinit_cq(ac, &rxq->rx_cq);
+
+	for (i = 0; i < rxq->num_rx_buf; i++) {
+		rx_oob = &rxq->rx_oobs[i];
+
+		if (!rx_oob->buf_va)
+			continue;
+
+		dma_unmap_page(dev, rx_oob->buf_dma_addr, rxq->datasize,
+			       DMA_FROM_DEVICE);
+
+		free_page((unsigned long)rx_oob->buf_va);
+		rx_oob->buf_va = NULL;
+	}
+
+	if (rxq->gdma_rq)
+		gdma_destroy_queue(ana_to_gdma_context(ac->gdma_dev),
+				   rxq->gdma_rq);
+
+	kfree(rxq);
+}
+
+#define ANA_WQE_HEADER_SIZE 16
+#define ANA_WQE_SGE_SIZE 16
+
+static int ana_alloc_rx_wqe(struct ana_context *ac, struct ana_rxq *rxq,
+			    u32 *rxq_size, u32 *cq_size)
+{
+	struct gdma_context *gc = ana_to_gdma_context(ac->gdma_dev);
+	struct ana_recv_buf_oob *rx_oob;
+	struct device *dev = gc->dev;
+	struct page *page;
+	dma_addr_t da;
+	u32 buf_idx;
+
+	WARN_ON(rxq->datasize == 0 || rxq->datasize > PAGE_SIZE);
+
+	*rxq_size = 0;
+	*cq_size = 0;
+
+	for (buf_idx = 0; buf_idx < rxq->num_rx_buf; buf_idx++) {
+		rx_oob = &rxq->rx_oobs[buf_idx];
+		memset(rx_oob, 0, sizeof(*rx_oob));
+
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			return -ENOMEM;
+
+		da = dma_map_page(dev, page, 0, rxq->datasize, DMA_FROM_DEVICE);
+
+		if (dma_mapping_error(dev, da)) {
+			__free_page(page);
+			return -ENOMEM;
+		}
+
+		rx_oob->buf_va = page_to_virt(page);
+		rx_oob->buf_dma_addr = da;
+
+		rx_oob->num_sge = 1;
+		rx_oob->sgl[0].address = rx_oob->buf_dma_addr;
+		rx_oob->sgl[0].size = rxq->datasize;
+		rx_oob->sgl[0].mem_key = ac->gdma_dev->gpa_mkey;
+
+		rx_oob->wqe_req.sgl = rx_oob->sgl;
+		rx_oob->wqe_req.num_sge = rx_oob->num_sge;
+		rx_oob->wqe_req.inline_oob_size = 0;
+		rx_oob->wqe_req.inline_oob_data = NULL;
+		rx_oob->wqe_req.flags = 0;
+		rx_oob->wqe_req.client_data_unit = 0;
+
+		*rxq_size += ALIGN(ANA_WQE_HEADER_SIZE +
+				   ANA_WQE_SGE_SIZE * rx_oob->num_sge, 32);
+		*cq_size += COMP_ENTRY_SIZE;
+	}
+
+	return 0;
+}
+
+static int ana_push_wqe(struct ana_rxq *rxq)
+{
+	struct ana_recv_buf_oob *rx_oob;
+	u32 buf_idx;
+	int err;
+
+	for (buf_idx = 0; buf_idx < rxq->num_rx_buf; buf_idx++) {
+		rx_oob = &rxq->rx_oobs[buf_idx];
+
+		err = gdma_post_and_ring(rxq->gdma_rq, &rx_oob->wqe_req,
+					 &rx_oob->wqe_inf);
+		if (err)
+			return -ENOSPC;
+	}
+
+	return 0;
+}
+
+static struct ana_rxq *ana_create_rxq(struct ana_context *ac, u32 rxq_idx,
+				      struct ana_eq *eq,
+				      struct net_device *ndev)
+{
+	struct gdma_dev *gd = ac->gdma_dev;
+	struct ana_obj_spec wq_spec;
+	struct ana_obj_spec cq_spec;
+	struct gdma_queue_spec spec;
+	struct ana_cq *cq = NULL;
+	struct gdma_context *gc;
+	u32 cq_size, rq_size;
+	struct ana_rxq *rxq;
+	int err;
+
+	gc = ana_to_gdma_context(gd);
+
+	rxq = kzalloc(sizeof(*rxq) +
+		      RX_BUFFERS_PER_QUEUE * sizeof(struct ana_recv_buf_oob),
+		      GFP_KERNEL);
+	if (!rxq)
+		return NULL;
+
+	rxq->ndev = ndev;
+	rxq->num_rx_buf = RX_BUFFERS_PER_QUEUE;
+	rxq->rxq_idx = rxq_idx;
+	rxq->datasize = ALIGN(MAX_FRAME_SIZE, 64);
+	rxq->rxobj = INVALID_ANA_HANDLE;
+
+	err = ana_alloc_rx_wqe(ac, rxq, &rq_size, &cq_size);
+	if (err)
+		goto out;
+
+	rq_size = ALIGN(rq_size, PAGE_SIZE);
+	cq_size = ALIGN(cq_size, PAGE_SIZE);
+
+	/* Create RQ */
+	memset(&spec, 0, sizeof(spec));
+	spec.type = GDMA_RQ;
+	spec.monitor_avl_buf = true;
+	spec.queue_size = rq_size;
+	err = gdma_create_ana_wq_cq(gd, &spec, &rxq->gdma_rq);
+	if (err)
+		goto out;
+
+	/* Create RQ's CQ */
+	cq = &rxq->rx_cq;
+	cq->gdma_comp_buf = eq->cqe_poll;
+	cq->type = ANA_CQ_TYPE_RX;
+	cq->rxq = rxq;
+
+	memset(&spec, 0, sizeof(spec));
+	spec.type = GDMA_CQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = cq_size;
+	spec.cq.callback = ana_cq_handler;
+	spec.cq.parent_eq = eq->eq;
+	spec.cq.context = cq;
+	err = gdma_create_ana_wq_cq(gd, &spec, &cq->gdma_cq);
+	if (err)
+		goto out;
+
+	memset(&wq_spec, 0, sizeof(wq_spec));
+	memset(&cq_spec, 0, sizeof(cq_spec));
+	wq_spec.gdma_region = rxq->gdma_rq->mem_info.gdma_region;
+	wq_spec.queue_size = rxq->gdma_rq->queue_size;
+
+	cq_spec.gdma_region = cq->gdma_cq->mem_info.gdma_region;
+	cq_spec.queue_size = cq->gdma_cq->queue_size;
+	cq_spec.modr_ctx_id = 0;
+	cq_spec.attached_eq = cq->gdma_cq->cq.parent->id;
+
+	err = ana_create_wq_obj(ac, ac->default_vport, GDMA_RQ,
+				&wq_spec, &cq_spec, &rxq->rxobj);
+	if (err)
+		goto out;
+
+	rxq->gdma_rq->id = wq_spec.queue_index;
+	cq->gdma_cq->id = cq_spec.queue_index;
+
+	rxq->gdma_rq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+	cq->gdma_cq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+
+	rxq->gdma_id = rxq->gdma_rq->id;
+	cq->gdma_id = cq->gdma_cq->id;
+
+	err = ana_push_wqe(rxq);
+	if (err)
+		goto out;
+
+	if (cq->gdma_id >= gc->max_num_cq)
+		goto out;
+
+	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
+
+	gdma_arm_cq(cq->gdma_cq);
+
+out:
+	if (!err)
+		return rxq;
+
+	netdev_err(ndev, "Failed to create RXQ: err = %d\n", err);
+
+	ana_destroy_rxq(ac, rxq, false);
+
+	if (cq)
+		ana_deinit_cq(ac, cq);
+
+	return NULL;
+}
+
+static int ana_add_rx_queues(struct ana_context *ac, struct net_device *ndev)
+{
+	struct ana_rxq *rxq;
+	int err = 0;
+	int i;
+
+	for (i = 0; i < ac->num_queues; i++) {
+		rxq = ana_create_rxq(ac, i, &ac->eqs[i], ndev);
+		if (!rxq) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		u64_stats_init(&rxq->stats.syncp);
+
+		ac->rxqs[i] = rxq;
+	}
+
+	ac->default_rxobj = ac->rxqs[0]->rxobj;
+out:
+	return err;
+}
+
+static void ana_destroy_vport(struct ana_context *ac)
+{
+	struct ana_rxq *rxq;
+	u32 rxq_idx;
+
+	for (rxq_idx = 0; rxq_idx < ac->num_queues; rxq_idx++) {
+		rxq = ac->rxqs[rxq_idx];
+		if (!rxq)
+			continue;
+
+		ana_destroy_rxq(ac, rxq, true);
+		ac->rxqs[rxq_idx] = NULL;
+	}
+
+	ana_destroy_txq(ac);
+}
+
+static int ana_create_vport(struct ana_context *ac, struct net_device *net)
+{
+	struct gdma_dev *gd = ac->gdma_dev;
+	int err;
+
+	ac->default_rxobj = INVALID_ANA_HANDLE;
+
+	err = ana_cfg_vport(ac, gd->pdid, gd->doorbell);
+	if (err)
+		return err;
+
+	err = ana_create_txq(ac, net);
+	return err;
+}
+
+static void ana_key_table_init(struct ana_context *ac, bool reset_hash)
+{
+	int i;
+
+	if (reset_hash)
+		get_random_bytes(ac->hashkey, ANA_HASH_KEY_SIZE);
+
+	for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
+		ac->ind_table[i] = i % ac->num_queues;
+}
+
+int ana_config_rss(struct ana_context *ac, enum TRI_STATE rx,
+		   bool update_hash, bool update_tab)
+{
+	int err;
+	int i;
+
+	if (update_tab) {
+		for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
+			ac->rxobj_table[i] = ac->rxqs[ac->ind_table[i]]->rxobj;
+	}
+
+	err = ana_cfg_vport_steering(ac, rx, true, update_hash, update_tab);
+	return err;
+}
+
+int ana_detach(struct net_device *ndev)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	struct ana_txq *txq;
+	int i, err;
+
+	ASSERT_RTNL();
+
+	ac->port_st_save = ac->port_is_up;
+	ac->port_is_up = false;
+	ac->start_remove = true;
+
+	/* Ensure port state updated before txq state */
+	smp_wmb();
+
+	netif_tx_disable(ndev);
+	netif_carrier_off(ndev);
+
+	/* No packet can be transmitted now since ac->port_is_up is false.
+	 * There is still a tiny chance that ana_poll_tx_cq() can re-enable
+	 * a txq because it may not timely see ac->port_is_up being cleared
+	 * to false, but it doesn't matter since ana_start_xmit() drops any
+	 * new packets due to ac->port_is_up being false.
+	 *
+	 * Drain all the in-flight TX packets
+	 */
+	for (i = 0; i < ac->num_queues; i++) {
+		txq = &ac->tx_qp[i].txq;
+
+		while (atomic_read(&txq->pending_sends) > 0)
+			usleep_range(1000, 2000);
+	}
+
+	/* We're 100% sure the queues can no longer be woken up, because
+	 * we're sure now ana_poll_tx_cq() can't be running.
+	 */
+	netif_device_detach(ndev);
+
+	ac->rss_state = TRI_STATE_FALSE;
+	err = ana_config_rss(ac, TRI_STATE_FALSE, false, false);
+	if (err)
+		netdev_err(ndev, "Failed to disable vPort: %d\n", err);
+
+	ana_destroy_vport(ac);
+
+	ana_destroy_eq(ana_to_gdma_context(ac->gdma_dev), ac);
+
+	ana_cleanup_context(ac);
+
+	/* TODO: Implement RX fencing */
+	ssleep(1);
+
+	return 0;
+}
+
+int ana_do_attach(struct net_device *ndev, bool reset_hash)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	struct gdma_dev *gd = ac->gdma_dev;
+	u32 max_txq, max_rxq, max_queues;
+	u32 num_indirect_entries;
+	u16 max_vports = 1;
+	int err;
+
+	err = ana_init_context(ac);
+	if (err)
+		return err;
+
+	err = ana_query_client_cfg(ac, ANA_MAJOR_VERSION, ANA_MINOR_VERSION,
+				   ANA_MICRO_VERSION, &max_vports);
+	if (err)
+		goto reset_ac;
+
+	err = ana_query_vport_cfg(ac, 0, &max_txq, &max_rxq,
+				  &num_indirect_entries);
+	if (err) {
+		netdev_err(ndev, "Failed to query info for vPort 0\n");
+		goto reset_ac;
+	}
+
+	max_queues = min_t(u32, max_txq, max_rxq);
+	if (ac->max_queues > max_queues)
+		ac->max_queues = max_queues;
+
+	if (ac->num_queues > ac->max_queues)
+		ac->num_queues = ac->max_queues;
+
+	memcpy(ndev->dev_addr, ac->mac_addr, ETH_ALEN);
+
+	err = ana_create_eq(ac);
+	if (err)
+		goto reset_ac;
+
+	err = ana_create_vport(ac, ndev);
+	if (err)
+		goto destroy_eq;
+
+	netif_set_real_num_tx_queues(ndev, ac->num_queues);
+
+	err = ana_add_rx_queues(ac, ndev);
+	if (err)
+		goto destroy_vport;
+
+	ac->rss_state = ac->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	netif_set_real_num_rx_queues(ndev, ac->num_queues);
+
+	ana_key_table_init(ac, reset_hash);
+
+	err = ana_config_rss(ac, TRI_STATE_TRUE, true, true);
+	if (err)
+		goto destroy_vport;
+
+	return 0;
+
+destroy_vport:
+	ana_destroy_vport(ac);
+destroy_eq:
+	ana_destroy_eq(ana_to_gdma_context(gd), ac);
+reset_ac:
+	gdma_deregister_device(gd);
+	kfree(ac->rxqs);
+	ac->rxqs = NULL;
+	return err;
+}
+
+int ana_probe(struct gdma_dev *gd)
+{
+	struct gdma_context *gc = ana_to_gdma_context(gd);
+	struct device *dev = gc->dev;
+	struct net_device *ndev;
+	struct ana_context *ac;
+	int err;
+
+	dev_info(dev, "Azure Network Adapter (ANA) Driver version: %d.%d.%d\n",
+		 ANA_MAJOR_VERSION, ANA_MINOR_VERSION, ANA_MICRO_VERSION);
+
+	ndev = alloc_etherdev_mq(sizeof(struct ana_context), gc->max_num_queue);
+	if (!ndev)
+		return -ENOMEM;
+
+	gd->driver_data = ndev;
+
+	ac = netdev_priv(ndev);
+	ac->gdma_dev = gd;
+	ac->ndev = ndev;
+	ac->max_queues = gc->max_num_queue;
+	ac->num_queues = min_t(uint, gc->max_num_queue, ANA_DEFAULT_NUM_QUEUE);
+	ac->default_vport = INVALID_ANA_HANDLE;
+
+	ndev->netdev_ops = &ana_devops;
+	ndev->ethtool_ops = &ana_ethtool_ops;
+	ndev->mtu = ETH_DATA_LEN;
+	ndev->max_mtu = ndev->mtu;
+	ndev->min_mtu = ndev->mtu;
+	ndev->needed_headroom = ANA_HEADROOM;
+	SET_NETDEV_DEV(ndev, gc->dev);
+
+	netif_carrier_off(ndev);
+	err = ana_do_attach(ndev, true);
+	if (err)
+		goto free_net;
+
+	rtnl_lock();
+
+	netdev_lockdep_set_classes(ndev);
+
+	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	ndev->hw_features |= NETIF_F_RXCSUM;
+	ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+	ndev->hw_features |= NETIF_F_RXHASH;
+	ndev->features = ndev->hw_features;
+	ndev->vlan_features = 0;
+
+	err = register_netdevice(ndev);
+	if (err) {
+		netdev_err(ndev, "Unable to register netdev.\n");
+		goto destroy_vport;
+	}
+
+	rtnl_unlock();
+
+	return 0;
+destroy_vport:
+	rtnl_unlock();
+
+	ana_destroy_vport(ac);
+	ana_destroy_eq(gc, ac);
+free_net:
+	gd->driver_data = NULL;
+	netdev_err(ndev, "Failed to probe net device:  %d\n", err);
+	free_netdev(ndev);
+	return err;
+}
+
+void ana_remove(struct gdma_dev *gd)
+{
+	struct gdma_context *gc = ana_to_gdma_context(gd);
+	struct net_device *ndev = gd->driver_data;
+	struct device *dev = gc->dev;
+
+	if (!ndev) {
+		dev_err(dev, "Failed to find a net device to remove\n");
+		return;
+	}
+
+	/* All cleanup actions should stay after rtnl_lock(), otherwise
+	 * other functions may access partially cleaned up data.
+	 */
+	rtnl_lock();
+
+	ana_detach(ndev);
+
+	unregister_netdevice(ndev);
+
+	rtnl_unlock();
+
+	free_netdev(ndev);
+
+	gd->driver_data = NULL;
+}
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
new file mode 100644
index 000000000000..8e438fe96eab
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#include <linux/inetdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+
+#include "mana.h"
+
+static const struct {
+	char name[ETH_GSTRING_LEN];
+	u16 offset;
+} ana_eth_stats[] = {
+	{"stop_queue", offsetof(struct ana_ethtool_stats, stop_queue)},
+	{"wake_queue", offsetof(struct ana_ethtool_stats, wake_queue)},
+};
+
+static int ana_get_sset_count(struct net_device *ndev, int stringset)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	unsigned int num_queues = ac->num_queues;
+
+	if (stringset != ETH_SS_STATS)
+		return -EINVAL;
+
+	return ARRAY_SIZE(ana_eth_stats) + num_queues * 4;
+}
+
+static void ana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	unsigned int num_queues = ac->num_queues;
+	u8 *p = data;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ana_eth_stats); i++) {
+		memcpy(p, ana_eth_stats[i].name, ETH_GSTRING_LEN);
+		p += ETH_GSTRING_LEN;
+	}
+
+	for (i = 0; i < num_queues; i++) {
+		sprintf(p, "rx_%d_packets", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "rx_%d_bytes", i);
+		p += ETH_GSTRING_LEN;
+	}
+
+	for (i = 0; i < num_queues; i++) {
+		sprintf(p, "tx_%d_packets", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_bytes", i);
+		p += ETH_GSTRING_LEN;
+	}
+}
+
+static void ana_get_ethtool_stats(struct net_device *ndev,
+				  struct ethtool_stats *e_stats, u64 *data)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	unsigned int num_queues = ac->num_queues;
+	void *eth_stats = &ac->eth_stats;
+	struct ana_stats *stats;
+	unsigned int start;
+	u64 packets, bytes;
+	int q, i = 0;
+
+	for (q = 0; q < ARRAY_SIZE(ana_eth_stats); q++)
+		data[i++] = *(u64 *)(eth_stats + ana_eth_stats[q].offset);
+
+	for (q = 0; q < num_queues; q++) {
+		stats = &ac->rxqs[q]->stats;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			packets = stats->packets;
+			bytes = stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		data[i++] = packets;
+		data[i++] = bytes;
+	}
+
+	for (q = 0; q < num_queues; q++) {
+		stats = &ac->tx_qp[q].txq.stats;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			packets = stats->packets;
+			bytes = stats->bytes;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		data[i++] = packets;
+		data[i++] = bytes;
+	}
+}
+
+static int ana_get_rxnfc(struct net_device *ndev, struct ethtool_rxnfc *cmd,
+			 u32 *rules)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = ac->num_queues;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static u32 ana_get_rxfh_key_size(struct net_device *ndev)
+{
+	return ANA_HASH_KEY_SIZE;
+}
+
+static u32 ana_rss_indir_size(struct net_device *ndev)
+{
+	return ANA_INDIRECT_TABLE_SIZE;
+}
+
+static int ana_get_rxfh(struct net_device *ndev, u32 *indir, u8 *key, u8 *hfunc)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	int i;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP; /* Toeplitz */
+
+	if (indir) {
+		for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
+			indir[i] = ac->ind_table[i];
+	}
+
+	if (key)
+		memcpy(key, ac->hashkey, ANA_HASH_KEY_SIZE);
+
+	return 0;
+}
+
+static int ana_set_rxfh(struct net_device *ndev, const u32 *indir,
+			const u8 *key, const u8 hfunc)
+{
+	bool update_hash = false, update_table = false;
+	struct ana_context *ac = netdev_priv(ndev);
+	u32 save_table[ANA_INDIRECT_TABLE_SIZE];
+	u8 save_key[ANA_HASH_KEY_SIZE];
+	int i, err;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (indir) {
+		for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
+			if (indir[i] >= ac->num_queues)
+				return -EINVAL;
+
+		update_table = true;
+		for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++) {
+			save_table[i] = ac->ind_table[i];
+			ac->ind_table[i] = indir[i];
+		}
+	}
+
+	if (key) {
+		update_hash = true;
+		memcpy(save_key, ac->hashkey, ANA_HASH_KEY_SIZE);
+		memcpy(ac->hashkey, key, ANA_HASH_KEY_SIZE);
+	}
+
+	err = ana_config_rss(ac, TRI_STATE_TRUE, update_hash, update_table);
+
+	if (err) { /* recover to original values */
+		if (update_table) {
+			for (i = 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
+				ac->ind_table[i] = save_table[i];
+		}
+
+		if (update_hash)
+			memcpy(ac->hashkey, save_key, ANA_HASH_KEY_SIZE);
+
+		ana_config_rss(ac, TRI_STATE_TRUE, update_hash, update_table);
+	}
+
+	return err;
+}
+
+static int ana_attach(struct net_device *ndev)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	int err;
+
+	ASSERT_RTNL();
+
+	err = ana_do_attach(ndev, false);
+	if (err)
+		return err;
+
+	netif_device_attach(ndev);
+
+	ac->port_is_up = ac->port_st_save;
+	ac->start_remove = false;
+
+	/* Ensure port state updated before txq state */
+	smp_wmb();
+
+	if (ac->port_is_up) {
+		netif_carrier_on(ndev);
+		netif_tx_wake_all_queues(ndev);
+	}
+
+	return 0;
+}
+
+static void ana_get_channels(struct net_device *ndev,
+			     struct ethtool_channels *channel)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+
+	channel->max_combined = ac->max_queues;
+	channel->combined_count = ac->num_queues;
+}
+
+static int ana_set_channels(struct net_device *ndev,
+			    struct ethtool_channels *channels)
+{
+	struct ana_context *ac = netdev_priv(ndev);
+	unsigned int new_count;
+	unsigned int old_count;
+	int err, err2;
+
+	new_count = channels->combined_count;
+	old_count = ac->num_queues;
+
+	if (new_count < 1 || new_count > ac->max_queues ||
+	    channels->rx_count || channels->tx_count || channels->other_count)
+		return -EINVAL;
+
+	if (new_count == old_count)
+		return 0;
+
+	err = ana_detach(ndev);
+	if (err) {
+		netdev_err(ndev, "ana_detach failed: %d\n", err);
+		return err;
+	}
+
+	ac->num_queues = new_count;
+
+	err = ana_attach(ndev);
+	if (!err)
+		return 0;
+
+	netdev_err(ndev, "ana_attach failed: %d\n", err);
+
+	/* Try to roll it back to the old configuration. */
+	ac->num_queues = old_count;
+	err2 = ana_attach(ndev);
+	if (err2)
+		netdev_err(ndev, "ana re-attach failed: %d\n", err2);
+
+	return err;
+}
+
+const struct ethtool_ops ana_ethtool_ops = {
+	.get_ethtool_stats = ana_get_ethtool_stats,
+	.get_sset_count = ana_get_sset_count,
+	.get_strings = ana_get_strings,
+	.get_rxnfc = ana_get_rxnfc,
+	.get_rxfh_key_size = ana_get_rxfh_key_size,
+	.get_rxfh_indir_size = ana_rss_indir_size,
+	.get_rxfh = ana_get_rxfh,
+	.set_rxfh = ana_set_rxfh,
+	.get_channels = ana_get_channels,
+	.set_channels = ana_set_channels,
+};
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
new file mode 100644
index 000000000000..128bd02ebd99
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/io.h>
+
+#include "shm_channel.h"
+
+#define PAGE_FRAME_L48_WIDTH_BYTES 6
+#define PAGE_FRAME_L48_WIDTH_BITS (PAGE_FRAME_L48_WIDTH_BYTES * 8)
+#define PAGE_FRAME_L48_MASK 0x0000FFFFFFFFFFFF
+#define PAGE_FRAME_H4_WIDTH_BITS 4
+#define VECTOR_MASK 0xFFFF
+#define SHMEM_VF_RESET_STATE ((u32)-1)
+
+#define SMC_MSG_TYPE_ESTABLISH_HWC 1
+#define SMC_MSG_TYPE_ESTABLISH_HWC_VERSION 0
+
+#define SMC_MSG_TYPE_DESTROY_HWC 2
+#define SMC_MSG_TYPE_DESTROY_HWC_VERSION 0
+
+#define SMC_MSG_DIRECTION_REQUEST 0
+#define SMC_MSG_DIRECTION_RESPONSE 1
+
+/* Shared memory channel protocol header
+ * 4 bytes
+ *
+ * msg_type: set on request and response; response matches request.
+ * msg_version: newer PF writes back older response (matching request)
+ *  older PF acts on latest version known and sets that version in result
+ *  (less than request).
+ * direction: 0 for request, VF->PF; 1 for response, PF->VF.
+ * status: 0 on request,
+ *   operation result on response (success = 0, failure = 1 or greater).
+ * reset_vf: If set on either establish or destroy request, indicates perform
+ *  FLR before/after the operation.
+ * owner_is_pf: 1 indicates PF owned, 0 indicates VF owned.
+ */
+union shm_channel_proto_hdr {
+	u32 as_uint32;
+
+	struct {
+		u8 msg_type	: 3;
+		u8 msg_version	: 3;
+		u8 reserved_1	: 1;
+		u8 direction	: 1;
+
+		u8 status;
+
+		u8 reserved_2;
+
+		u8 reset_vf	: 1;
+		u8 reserved_3	: 6;
+		u8 owner_is_pf	: 1;
+	};
+} __packed;
+
+#define SMC_APERTURE_BITS 256
+#define SMC_BASIC_UNIT (sizeof(u32))
+#define SMC_APERTURE_DWORDS (SMC_APERTURE_BITS / (SMC_BASIC_UNIT * 8))
+#define SMC_LAST_DWORD (SMC_APERTURE_DWORDS - 1)
+
+static int shm_channel_poll_register(void __iomem *base, bool reset)
+{
+	void __iomem *ptr = base + SMC_LAST_DWORD * SMC_BASIC_UNIT;
+	u32 last_dword;
+	int i;
+
+	/* wait up to 20 seconds */
+	for (i = 0; i < 20 * 100; i++)  {
+		last_dword = readl(ptr);
+
+		/* shmem reads as 0xFFFFFFFF in the reset case */
+		if (reset && last_dword == SHMEM_VF_RESET_STATE)
+			return 0;
+
+		/* If bit_31 is set, the PF currently owns the SMC. */
+		if (!(last_dword & BIT(31)))
+			return 0;
+
+		usleep_range(1000, 2000);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int shm_channel_read_response(struct shm_channel *sc, u32 msg_type,
+				     u32 msg_version, bool reset_vf)
+{
+	union shm_channel_proto_hdr hdr;
+	void __iomem *base = sc->base;
+	int err;
+
+	/* Wait for PF to respond. */
+	err = shm_channel_poll_register(base, reset_vf);
+	if (err)
+		return err;
+
+	hdr.as_uint32 = readl(base + SMC_LAST_DWORD * SMC_BASIC_UNIT);
+
+	if (reset_vf && hdr.as_uint32 == SHMEM_VF_RESET_STATE)
+		return 0;
+
+	/* Validate protocol fields from the PF driver */
+	if (hdr.msg_type != msg_type || hdr.msg_version > msg_version ||
+	    hdr.direction != SMC_MSG_DIRECTION_RESPONSE) {
+		dev_err(sc->dev, "Wrong SMC response 0x%x, type=%d, ver=%d\n",
+			hdr.as_uint32, msg_type, msg_version);
+		return -EPROTO;
+	}
+
+	/* Validate the operation result */
+	if (hdr.status != 0) {
+		dev_err(sc->dev, "SMC operation failed: 0x%x\n", hdr.status);
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
+void shm_channel_init(struct shm_channel *sc, struct device *dev,
+		      void __iomem *base)
+{
+	sc->dev = dev;
+	sc->base = base;
+}
+
+int shm_channel_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
+			  u64 cq_addr, u64 rq_addr, u64 sq_addr,
+			  u32 eq_msix_index)
+{
+	union shm_channel_proto_hdr *hdr;
+	u16 all_addr_h4bits = 0;
+	u16 frame_addr_seq = 0;
+	u64 frame_addr = 0;
+	u8 shm_buf[32];
+	u64 *shmem;
+	u32 *dword;
+	u8 *ptr;
+	int err;
+	int i;
+
+	/* Ensure VF already has possession of shared memory */
+	err = shm_channel_poll_register(sc->base, false);
+	if (err) {
+		dev_err(sc->dev, "Timeout when setting up HWC: %d\n", err);
+		return err;
+	}
+
+	if ((eq_addr & PAGE_MASK) != eq_addr)
+		return -EINVAL;
+
+	if ((cq_addr & PAGE_MASK) != cq_addr)
+		return -EINVAL;
+
+	if ((rq_addr & PAGE_MASK) != rq_addr)
+		return -EINVAL;
+
+	if ((sq_addr & PAGE_MASK) != sq_addr)
+		return -EINVAL;
+
+	if ((eq_msix_index & VECTOR_MASK) != eq_msix_index)
+		return -EINVAL;
+
+	/* Scheme for packing four addresses and extra info into 256 bits.
+	 *
+	 * Addresses must be page frame aligned, so only frame address bits
+	 * are transferred.
+	 *
+	 * 52-bit frame addresses are split into the lower 48 bits and upper
+	 * 4 bits. Lower 48 bits of 4 address are written sequentially from
+	 * the start of the 256-bit shared memory region followed by 16 bits
+	 * containing the upper 4 bits of the 4 addresses in sequence.
+	 *
+	 * A 16 bit EQ vector number fills out the next-to-last 32-bit dword.
+	 *
+	 * The final 32-bit dword is used for protocol control information as
+	 * defined in shm_channel_proto_hdr.
+	 */
+
+	memset(shm_buf, 0, sizeof(shm_buf));
+	ptr = shm_buf;
+
+	/* EQ addr: low 48 bits of frame address */
+	shmem = (u64 *)ptr;
+	frame_addr = (eq_addr >> PAGE_SHIFT);
+	*shmem = (frame_addr & PAGE_FRAME_L48_MASK);
+	all_addr_h4bits |= (frame_addr >> PAGE_FRAME_L48_WIDTH_BITS) <<
+		(frame_addr_seq++ * PAGE_FRAME_H4_WIDTH_BITS);
+	ptr += PAGE_FRAME_L48_WIDTH_BYTES;
+
+	/* CQ addr: low 48 bits of frame address */
+	shmem = (u64 *)ptr;
+	frame_addr = (cq_addr >> PAGE_SHIFT);
+	*shmem = (frame_addr & PAGE_FRAME_L48_MASK);
+	all_addr_h4bits |= (frame_addr >> PAGE_FRAME_L48_WIDTH_BITS) <<
+		(frame_addr_seq++ * PAGE_FRAME_H4_WIDTH_BITS);
+	ptr += PAGE_FRAME_L48_WIDTH_BYTES;
+
+	/* RQ addr: low 48 bits of frame address */
+	shmem = (u64 *)ptr;
+	frame_addr = (rq_addr >> PAGE_SHIFT);
+	*shmem = (frame_addr & PAGE_FRAME_L48_MASK);
+	all_addr_h4bits |= (frame_addr >> PAGE_FRAME_L48_WIDTH_BITS) <<
+		(frame_addr_seq++ * PAGE_FRAME_H4_WIDTH_BITS);
+	ptr += PAGE_FRAME_L48_WIDTH_BYTES;
+
+	/* SQ addr: low 48 bits of frame address */
+	shmem = (u64 *)ptr;
+	frame_addr = (sq_addr >> PAGE_SHIFT);
+	*shmem = (frame_addr & PAGE_FRAME_L48_MASK);
+	all_addr_h4bits |= (frame_addr >> PAGE_FRAME_L48_WIDTH_BITS) <<
+		(frame_addr_seq++ * PAGE_FRAME_H4_WIDTH_BITS);
+	ptr += PAGE_FRAME_L48_WIDTH_BYTES;
+
+	/* High 4 bits of the four frame addresses */
+	*((u16 *)ptr) = all_addr_h4bits;
+	ptr += sizeof(u16);
+
+	/* EQ MSIX vector number */
+	*((u16 *)ptr) = (u16)eq_msix_index;
+	ptr += sizeof(u16);
+
+	/* 32-bit protocol header in final dword */
+	*((u32 *)ptr) = 0;
+
+	hdr = (union shm_channel_proto_hdr *)ptr;
+	hdr->msg_type = SMC_MSG_TYPE_ESTABLISH_HWC;
+	hdr->msg_version = SMC_MSG_TYPE_ESTABLISH_HWC_VERSION;
+	hdr->direction = SMC_MSG_DIRECTION_REQUEST;
+	hdr->reset_vf = reset_vf;
+
+	/* Write 256-message buffer to shared memory (final 32-bit write
+	 * triggers HW to set possession bit to PF).
+	 */
+	dword = (u32 *)shm_buf;
+	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
+		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);
+
+	/* Read shmem response (polling for VF possession) and validate.
+	 * For setup, waiting for response on shared memory is not strictly
+	 * necessary, since wait occurs later for results to appear in EQE's.
+	 */
+	err = shm_channel_read_response(sc, SMC_MSG_TYPE_ESTABLISH_HWC,
+					SMC_MSG_TYPE_ESTABLISH_HWC_VERSION,
+					reset_vf);
+	if (err) {
+		dev_err(sc->dev, "Error when setting up HWC: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+int shm_channel_teardown_hwc(struct shm_channel *sc, bool reset_vf)
+{
+	union shm_channel_proto_hdr hdr = {};
+	int err;
+
+	/* Ensure already has possession of shared memory */
+	err = shm_channel_poll_register(sc->base, false);
+	if (err) {
+		dev_err(sc->dev, "Timeout when tearing down HWC\n");
+		return err;
+	}
+
+	/* Set up protocol header for HWC destroy message */
+	hdr.msg_type = SMC_MSG_TYPE_DESTROY_HWC;
+	hdr.msg_version = SMC_MSG_TYPE_DESTROY_HWC_VERSION;
+	hdr.direction = SMC_MSG_DIRECTION_REQUEST;
+	hdr.reset_vf = reset_vf;
+
+	/* Write message in high 32 bits of 256-bit shared memory, causing HW
+	 * to set possession bit to PF.
+	 */
+	writel(hdr.as_uint32, sc->base + SMC_LAST_DWORD * SMC_BASIC_UNIT);
+
+	/* Read shmem response (polling for VF possession) and validate.
+	 * For teardown, waiting for response is required to ensure hardware
+	 * invalidates MST entries before software frees memory.
+	 */
+	err = shm_channel_read_response(sc, SMC_MSG_TYPE_DESTROY_HWC,
+					SMC_MSG_TYPE_DESTROY_HWC_VERSION,
+					reset_vf);
+	if (err) {
+		dev_err(sc->dev, "Error when tearing down HWC: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.h b/drivers/net/ethernet/microsoft/mana/shm_channel.h
new file mode 100644
index 000000000000..aa55837239d7
--- /dev/null
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright (c) 2021, Microsoft Corporation. */
+
+#ifndef _SHM_CHANNEL_H
+#define _SHM_CHANNEL_H
+
+struct shm_channel {
+	struct device *dev;
+	void __iomem *base;
+};
+
+void shm_channel_init(struct shm_channel *sc, struct device *dev,
+		      void __iomem *base);
+
+int shm_channel_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
+			  u64 cq_addr, u64 rq_addr, u64 sq_addr,
+			  u32 eq_msix_index);
+
+int shm_channel_teardown_hwc(struct shm_channel *sc, bool reset_vf);
+
+#endif /* _SHM_CHANNEL_H */
-- 
2.20.1

