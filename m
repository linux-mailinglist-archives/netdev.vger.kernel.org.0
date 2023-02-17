Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2E69B5C5
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBQW5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjBQW5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:41 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD8561859
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3rzBT4aR2ZCCKzTi9dZEEUTi/aF0ZyEvpgX4h1k7ugwZwc6lUq+ppyXdIcSeHXgmMUfdPIX4DbyKiCpZk1Au5/RVuTyKyNNKTrOZhVKxIyOb5QsLq12z64cFoeKO/C83XDtZYM5zg9INuvn5ihsnRSoAPZyhRVPci/gLGaSlSB/ue82O8H8O9SJ7l7qZ9TDNioyHdJRaqG6OXo8wnVOvxysqtIC2A65dTEBnWyxWC1T+95fsqDalvA2nVBNk9aGPAQVBV7E6sHTIJZUIevvnFq6m89fetYYzR3fevzNowkrEkSuh76HlXLJBroh96Uukn3kgZiR1oOm7wc4kkmGww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXOVKCi3kKIV1D+MC0TV230yPbekGtB+p73Lgwt/s/Q=;
 b=bpk1qOolmOIJu1b0APRPNTpTjTAf0dt2mtYWFF2uqg4CWzxKFJKhWK9e7SjDQuSSMb2uQiuRXhb4yH14Tu/c9ohHWc+n9qLRtR13t7jDfxAHQEt06cvrtmtbdylauumdrIzCXOGc1JL5RgtkG4K0gkrwfHXl0ers+eA0FhP70OnkCA+OjaLCwf3ihPtvt4xED6Ki0SG1g9VgpFRjUSOzrBKcF0sGytGwvtwNErcZ7AbztLy2lOj5OurgooVmWoE3Ue1H73AJ268I8thAkykoNCYY27/BYVGJZfF5eYllNTGlFrErepC8Z3JIh9Nca4Dp/DrsKA2J0SkTBRLdDFUqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXOVKCi3kKIV1D+MC0TV230yPbekGtB+p73Lgwt/s/Q=;
 b=HtJDuXGO6RyZDt1Q4fsrjIKfwcmaxDRaKZkWXHP6VUyhlfvT3Led3TUYSbS4iUPI9jX14KCtzYxEfxrgd4kyZ7IWfO/8Dc3zVW8vnw8tcCJVfPgD+NmO3xaTtnIgSohuQ+Tus5e6Fan/HKpHVmgVg5krrQo8NlqORqLNc3k1AnE=
Received: from DS7PR05CA0008.namprd05.prod.outlook.com (2603:10b6:5:3b9::13)
 by IA1PR12MB6234.namprd12.prod.outlook.com (2603:10b6:208:3e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 22:56:50 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::87) by DS7PR05CA0008.outlook.office365.com
 (2603:10b6:5:3b9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.8 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:50 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:48 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Fri, 17 Feb 2023 14:55:58 -0800
Message-ID: <20230217225558.19837-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|IA1PR12MB6234:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f4618e-6c91-4b45-3fee-08db113a4145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7p7DEkfvwNIMnzb1P5dWS8x/Ay4a43KptMo0LnODeTfXGXm/ab94jt66+k2aHvcOYSw8LDXUlusAilulnEKPYo0TfN+LXUqNnZyhr1IeKuPJHD3xTG9oTpXhHpgdHcPZ7hozYYmDFbZTOPngn8IQFjZ4jVkmnSOhNUsUOEf1/EXxKIB81phFLm+R4Lo6yDK6rWFEe+oPG91u2SqjNAT1nwzw1zZyPygK3IkwtDbbK2ZN4JoSCgpAYBf/OW/9wDxRRRwwHqj1M51R/54uI0Vt41GKPoixD71W5UQ5FYTku0MCKKe6VrT3iOz30aixHbcT7PsRdiRSEHv6iGA229j7haMMmXvhaKazIxBGFqLvssJzCee6qyw5p1KzEewnZB0imQ9mbE1/Kk1ScdbLuOr+R8Fg9dJkG/x7sDVtAi3iMXH02QnCIV9cjbySsO4G6deZvShDEJQ7T+EFvRfpWWpin3k2C1Bttq9lr+18wQThMIG7X+nkyoosEsZLqgfyOPozwSyluAhkKoqPuyK29ZnVNGacXmZZFyTqeyPXBJlZjO1ktw0oG2ARDftzBoImOe3f0VNiN3vsCiNTE6LIVvXxl17DAJJubu2BsvHyFscytkESJkGDIn+motc3E+pPU9kjp8xkWXi1VsIrv9JnO6RmEMU8ibm75IghcGOpWWu7oFW3pFXATp7ytS5oIsmDu26ZzlMKSNPXSEcls5wP5Pj+5PFc7qHXoxl/8WSRmanHipsb95RBI5wngCM7BqCNtaVHF0wuEeIJdMnhkgs4qTJ/jQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(36860700001)(82740400003)(86362001)(44832011)(2906002)(81166007)(40460700003)(110136005)(426003)(336012)(186003)(54906003)(43170500006)(26005)(40480700001)(36756003)(82310400005)(356005)(16526019)(47076005)(70206006)(83380400001)(8676002)(316002)(70586007)(478600001)(6666004)(41300700001)(1076003)(2616005)(8936002)(5660300002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:50.2171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f4618e-6c91-4b45-3fee-08db113a4145
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6234
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation and Kconfig hook for building the driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_core.rst  | 150 ++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |   1 +
 drivers/net/ethernet/amd/Kconfig              |  12 ++
 drivers/net/ethernet/amd/Makefile             |   1 +
 4 files changed, 164 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
new file mode 100644
index 000000000000..defa2f9463f5
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -0,0 +1,150 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+========================================================
+Linux Driver for the AMD/Pensando(R) DSC adapter family
+========================================================
+
+AMD/Pensando Linux Core driver
+Copyright(c) 2023 Advanced Micro Devices, Inc
+
+Identifying the Adapter
+=======================
+
+To find if one or more AMD/Pensando PCI Core devices are installed on the
+host, check for the PCI devices::
+
+  # lspci -d 1dd8:100c
+  39:00.0 Processing accelerators: Pensando Systems Device 100c
+  3a:00.0 Processing accelerators: Pensando Systems Device 100c
+
+If such devices are listed as above, then the pds_core.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep pds_core
+  pds_core 0000:b5:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.51.0-73
+  pds_core 0000:b6:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.51.0-73
+
+Driver and firmware version information can be gathered with devlink::
+
+  $ devlink dev info pci/0000:b5:00.0
+  pci/0000:b5:00.0:
+    driver pds_core
+    serial_number FLM18420073
+    versions:
+        fixed:
+          asic.id 0x0
+          asic.rev 0x0
+        running:
+          fw 1.51.0-73
+        stored:
+          fw.goldfw 1.15.9-C-22
+          fw.mainfwa 1.51.0-73
+          fw.mainfwb 1.51.0-57
+
+
+Info versions
+=============
+
+The ``pds_core`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Version of firmware running on the device
+   * - ``fw.goldfw``
+     - stored
+     - Version of firmware stored in the goldfw slot
+   * - ``fw.mainfwa``
+     - stored
+     - Version of firmware stored in the mainfwa slot
+   * - ``fw.mainfwb``
+     - stored
+     - Version of firmware stored in the mainfwb slot
+   * - ``asic.id``
+     - fixed
+     - The ASIC type for this device
+   * - ``asic.rev``
+     - fixed
+     - The revision of the ASIC for this device
+
+
+Parameters
+==========
+
+The ``pds_core`` driver implements the following generic
+parameters for controlling the functionality to be made available
+as auxiliary_bus devices.
+
+.. list-table:: Generic parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_vnet``
+     - runtime
+     - Boolean
+     - Enables vDPA functionality through an auxiliary_bus device
+
+
+The ``pds_core`` driver also implements the following driver-specific
+parameters for similar uses, as well as for selecting the next boot firmware:
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_migration``
+     - runtime
+     - Boolean
+     - Enables Live Migration functionality through an auxiliary_bus device
+
+
+Firmware Management
+===================
+
+The ``flash`` command can update a the DSC firmware.  The downloaded firmware
+will be saved into either of firmware bank 1 or bank 2, whichever is not
+currrently in use, and that bank will be then selected for the next boot.
+The ``fw_bank`` parameter will be updated to reflect this.
+
+Enabling the driver
+===================
+
+The driver is enabled via the standard kernel configuration system,
+using the make command::
+
+  make oldconfig/menuconfig/etc.
+
+The driver is located in the menu structure at:
+
+  -> Device Drivers
+    -> Network device support (NETDEVICES [=y])
+      -> Ethernet driver support
+        -> AMD devices
+          -> AMD/Pensando Ethernet PDS_CORE Support
+
+Support
+=======
+
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by AMD/Pensando personnel::
+
+  netdev@vger.kernel.org
+
+For more specific support needs, please use the AMD/Pensando driver support
+email::
+
+  drivers@pensando.io
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 392969ac88ad..aae0955eb26b 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -13,6 +13,7 @@ Contents:
    3com/3c509
    3com/vortex
    amazon/ena
+   amd/pds_core
    altera/altera_tse
    aquantia/atlantic
    chelsio/cxgb
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index ab42f75b9413..235fcacef5c5 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -186,4 +186,16 @@ config AMD_XGBE_HAVE_ECC
 	bool
 	default n
 
+config PDS_CORE
+	tristate "AMD/Pensando Data Systems Core Device Support"
+	depends on 64BIT && PCI
+	help
+	  This enables the support for the AMD/Pensando Core device family of
+	  adapters.  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/ethernet/amd/pds_core.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds_core.
+
 endif # NET_VENDOR_AMD
diff --git a/drivers/net/ethernet/amd/Makefile b/drivers/net/ethernet/amd/Makefile
index 42742afe9115..2dcfb84731e1 100644
--- a/drivers/net/ethernet/amd/Makefile
+++ b/drivers/net/ethernet/amd/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_PCNET32) += pcnet32.o
 obj-$(CONFIG_SUN3LANCE) += sun3lance.o
 obj-$(CONFIG_SUNLANCE) += sunlance.o
 obj-$(CONFIG_AMD_XGBE) += xgbe/
+obj-$(CONFIG_PDS_CORE) += pds_core/
-- 
2.17.1

