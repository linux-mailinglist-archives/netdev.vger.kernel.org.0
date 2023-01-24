Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C36A67A5B8
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjAXWa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAXWa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:30:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1851946726
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:30:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2sINsWxZFGGXC7LqpS/Y/vGpLxckJ3IPlStoFaVWWxlTqMYZIgJP+0hNGoo+pSjZIBeLc3FPnaxgYRRYXxOOmh478ioo0lAmWIy5KjLwvr81n9UNiF0FKLFQsnrln/FfR+YvSSX5GXbSdYvMokS0eGdZkKibziOu/VZZuHkduOpJadmuOdySfSPom6vsQKUtcqv0Rv3iHcM2x1etnFc0dBXBUeHPf+J415Sa1Qu7FE5bynYUkd3TwHXy60OS+yPJw59ZZ3ovTUmRw2Q3MRaOfozkMT64d1SFV0RiwqpfuXLHySLNzIECAgxZH9HK0UXZl6dP4z1LTYwhBPrhcyfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7PYs6KqkwS19lO4awDDcdnFVYtn6AhBR7gOSYW54Jg=;
 b=HQcYhusmNYcyZNvw/c9yY+jY/LWNcqtROf5afbp3U2WrfyQbINsXsyOOx9VCTvk5lF/F3b8Z+RkB2CUEY62DMXCwDA9PNzD2NcwHvW4+1xP0yKjo3C3aPjMLuidsVpvl/d/u1L9HQAI8CbpaQjKt+ilojPvJCjxhDTKfe+ELztSAYlxjhtqS+6YZ45mPJq9ux4ATqQRQotvtyWdmbVDQ2E/3l/sL3fMkGnEFjnMotxvZ9+AgV+1hQd0HZTp2tiYSzxTCroh6CjJOkOmXnQpGK4PCf3sAzmGnPYDXNNWBIdM18Tmxxiuo0xq41usy8ySJSCP0dug9IoIcGrE8197MLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7PYs6KqkwS19lO4awDDcdnFVYtn6AhBR7gOSYW54Jg=;
 b=mzEGCEl8F3d4+uzFd+3kF986C6WvrksXHQL3FgXjijV6gedbnfZTSzjVwKajh6hHLugrWQSG++5cn9gzUjRMO8DVLdW44lyblNN+f1RYjOBNt+GfAj52541CjQhm/6QaYl6oKRxMaw0AcrSdqx4YR1Xdk7QKCW8B9hXR2H/9uUI=
Received: from BN9PR03CA0717.namprd03.prod.outlook.com (2603:10b6:408:ef::32)
 by MW4PR12MB6921.namprd12.prod.outlook.com (2603:10b6:303:208::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 22:30:51 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::25) by BN9PR03CA0717.outlook.office365.com
 (2603:10b6:408:ef::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 22:30:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 22:30:51 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:30:50 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:30:49 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 24 Jan 2023 16:30:48 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
Date:   Tue, 24 Jan 2023 22:30:23 +0000
Message-ID: <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
References: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|MW4PR12MB6921:EE_
X-MS-Office365-Filtering-Correlation-Id: 1000fd59-ddf8-4955-15c9-08dafe5aa62d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cxh+FW3p7sB0v7DlXleq6G/+9DZIP8ps+e7tyHKa/7zdFaTsgNDjjhvXSuhNl/VNoYDZkH8eieuhn9yGB3V0ZOd/EmafloP9BWx48+2GA/mK18BglM5ymqR+t8LZiMOKEIepBRa4MN3IgVnvRU06QCkdy694Qf9kKzVHJ+PXh9gVfRoJcHswYtLMYsJS5Iqgr7O1iQhFEnXKuYRSfWXMrWnhRus/Gv9N3s7vtOOp8V3IHGpF5KFdcnlDroBDmaRYTzKPpKlYbf8NmJpR7KVmNiSL0e0JJqa/1HXxD1KNVLZ03M7xymbiucgiYqlkoHzh96r4nBF4aD8ItcIIgkuYa38tHcVcWuXtaN3x07+/jGbZ4bNHbKgyR7RJOIraLxZcDUNQHWnsnusw5+Rp9EnZAkIlHtN20jyW/3NBmI3STw+A5fio0bB7oDRl29VQv1U/xXf6D+W0d2TD3nc/WUphBu0a2xrLJ3jduHbWgCJagj50e4Vebq+NEa3Y4sybCLCkuVKq5gKl6XYyDulvpDPFMWZq4CR21B3gQtcVLzQAkVVWPjLAEwQpXZpHy9BArnFzFUAd//HHTdD3YOqxzbwJ9b06GnnPlLrS+DejJ6o1HJIT7numA1Qp4Db8sF9gieczxaXz54LORTXwiV8tcLGAuO8lVqMcFXwucQjCRB93+anVH09VB6d7a0THuv4LTcxW+YnjqIB+KmirTP1wupgSRKX0Rw1BryoV1KkL2QA985w=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199018)(36840700001)(46966006)(40470700004)(36860700001)(83380400001)(26005)(2876002)(81166007)(5660300002)(41300700001)(86362001)(356005)(82740400003)(30864003)(2906002)(4326008)(8936002)(82310400005)(40460700003)(6666004)(40480700001)(316002)(186003)(8676002)(47076005)(54906003)(336012)(426003)(2616005)(478600001)(6636002)(110136005)(36756003)(70586007)(1076003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:30:51.4362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1000fd59-ddf8-4955-15c9-08dafe5aa62d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6921
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Support for devlink info command.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 Documentation/networking/devlink/sfc.rst |  57 ++++
 drivers/net/ethernet/sfc/efx_devlink.c   | 404 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h   |  17 +
 drivers/net/ethernet/sfc/mcdi.c          |  72 ++++
 drivers/net/ethernet/sfc/mcdi.h          |   3 +
 5 files changed, 553 insertions(+)
 create mode 100644 Documentation/networking/devlink/sfc.rst

diff --git a/Documentation/networking/devlink/sfc.rst b/Documentation/networking/devlink/sfc.rst
new file mode 100644
index 000000000000..e2541a2f18ee
--- /dev/null
+++ b/Documentation/networking/devlink/sfc.rst
@@ -0,0 +1,57 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+sfc devlink support
+===================
+
+This document describes the devlink features implemented by the ``sfc``
+device driver for the ef100 device.
+
+Info versions
+=============
+
+The ``sfc`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+    :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw.mgmt.suc``
+     - running
+     - For boards where the management function is split between multiple
+       control units, this is the SUC control unit's firmware version.
+   * - ``fw.mgmt.cmc``
+     - running
+     - For boards where the management function is split between multiple
+       control units, this is the CMC control unit's firmware version.
+   * - ``fpga.rev``
+     - running
+     - FPGA design revision.
+   * - ``fpga.app``
+     - running
+     - Datapath programmable logic version.
+   * - ``fw.app``
+     - running
+     - Datapath software/microcode/firmware version.
+   * - ``coproc.boot``
+     - running
+     - SmartNIC application co-processor (APU) first stage boot loader version.
+   * - ``coproc.uboot``
+     - running
+     - SmartNIC application co-processor (APU) co-operating system loader version.
+   * - ``coproc.main``
+     - running
+     - SmartNIC application co-processor (APU) main operating system version.
+   * - ``coproc.recovery``
+     - running
+     - SmartNIC application co-processor (APU) recovery operating system version.
+   * - ``fw.exprom``
+     - running
+     - Expansion ROM version. For boards where the expansion ROM is split between
+       multiple images (e.g. PXE and UEFI), this is the specifically the PXE boot
+       ROM version.
+   * - ``fw.uefi``
+     - running
+     - UEFI driver version (No UNDI support).
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index fab06aaa4b8a..2593248928a6 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -21,7 +21,411 @@ struct efx_devlink {
 	struct efx_nic *efx;
 };
 
+static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
+					    struct devlink_info_req *req,
+					    unsigned int partition_type,
+					    const char *version_name)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	u16 version[4];
+	int rc;
+
+	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
+				     0);
+	if (rc)
+		return rc;
+
+	snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
+		 version[1], version[2], version[3]);
+	devlink_info_version_stored_put(req, version_name, buf);
+
+	return 0;
+}
+
+static void efx_devlink_info_stored_versions(struct efx_nic *efx,
+					     struct devlink_info_req *req)
+{
+	efx_devlink_info_nvram_partition(efx, req, NVRAM_PARTITION_TYPE_BUNDLE,
+					 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
+	efx_devlink_info_nvram_partition(efx, req,
+					 NVRAM_PARTITION_TYPE_MC_FIRMWARE,
+					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
+	efx_devlink_info_nvram_partition(efx, req,
+					 NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
+					 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
+	efx_devlink_info_nvram_partition(efx, req,
+					 NVRAM_PARTITION_TYPE_EXPANSION_ROM,
+					 EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
+	efx_devlink_info_nvram_partition(efx, req,
+					 NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
+					 EFX_DEVLINK_INFO_VERSION_FW_UEFI);
+}
+
+#define EFX_VER_FLAG(_f)	\
+	(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
+
+static void efx_devlink_info_running_v2(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+	struct rtc_time build_date;
+	unsigned int build_id;
+	size_t offset;
+	u64 tstamp;
+
+	if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
+			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
+		devlink_info_version_fixed_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+					       buf);
+
+		/* Favour full board version if present (in V5 or later) */
+		if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
+			snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
+				 MCDI_DWORD(outbuf,
+					    GET_VERSION_V2_OUT_BOARD_REVISION));
+			devlink_info_version_fixed_put(req,
+						       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+						       buf);
+		}
+
+		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
+		if (ver.str[0])
+			devlink_info_board_serial_number_put(req, ver.str);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V2_OUT_FPGA_VERSION);
+		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
+				  le32_to_cpu(ver.dwords[0]),
+				  'A' + le32_to_cpu(ver.dwords[1]),
+				  le32_to_cpu(ver.dwords[2]));
+
+		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
+		if (ver.str[0])
+			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
+				 " (%s)", ver.str);
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FPGA_REV,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V2_OUT_CMCFW_VERSION);
+		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+				  le32_to_cpu(ver.dwords[0]),
+				  le32_to_cpu(ver.dwords[1]),
+				  le32_to_cpu(ver.dwords[2]),
+				  le32_to_cpu(ver.dwords[3]));
+
+		tstamp = MCDI_QWORD(outbuf,
+				    GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
+		if (tstamp) {
+			rtc_time64_to_tm(tstamp, &build_date);
+			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
+				 " (%ptRd)", &build_date);
+		}
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
+						 buf);
+	}
+
+	ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
+	offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			  le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
+			  le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
+	if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
+		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
+		snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
+			 " (%x) %s", build_id,
+			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
+	}
+	devlink_info_version_running_put(req,
+					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
+					 buf);
+
+	if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V2_OUT_SUCFW_VERSION);
+		tstamp = MCDI_QWORD(outbuf,
+				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
+		rtc_time64_to_tm(tstamp, &build_date);
+		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
+			 "%u.%u.%u.%u type %x (%ptRd)",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
+			 build_id, &build_date);
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_v3(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+
+	if (flags & BIT(EFX_VER_FLAG(DATAPATH_HW_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V3_OUT_DATAPATH_HW_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_DATAPATH_HW,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(DATAPATH_FW_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V3_OUT_DATAPATH_FW_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_DATAPATH_FW,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_v4(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_BOOT_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SOC_BOOT_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_BOOT,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_UBOOT_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SOC_UBOOT_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_UBOOT,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+					GET_VERSION_V4_OUT_SOC_MAIN_ROOTFS_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_MAIN,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SUCFW_VERSION)) &&
+	    ~flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SUCFW_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_v5(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+
+	if (flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V5_OUT_BOARD_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(BUNDLE_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V5_OUT_BUNDLE_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_versions(struct efx_nic *efx,
+					      struct devlink_info_req *req)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+	size_t outlength, offset;
+	unsigned int flags;
+	int rc;
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlength);
+	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN)
+		return;
+
+	/* Handle previous output */
+	if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
+		ver.words = (__le16 *)MCDI_PTR(outbuf,
+					       GET_VERSION_EXT_OUT_VERSION);
+		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+				  le16_to_cpu(ver.words[0]),
+				  le16_to_cpu(ver.words[1]),
+				  le16_to_cpu(ver.words[2]),
+				  le16_to_cpu(ver.words[3]));
+
+		devlink_info_version_running_put(req,
+						 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
+						 buf);
+		return;
+	}
+
+	/* Handle V2 additions */
+	flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
+	efx_devlink_info_running_v2(efx, req, flags, outbuf);
+
+	if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
+		return;
+
+	/* Handle V3 additions */
+	efx_devlink_info_running_v3(efx, req, flags, outbuf);
+
+	if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
+		return;
+
+	/* Handle V4 additions */
+	efx_devlink_info_running_v4(efx, req, flags, outbuf);
+
+	if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
+		return;
+
+	/* Handle V5 additions */
+	efx_devlink_info_running_v5(efx, req, flags, outbuf);
+}
+
+#define EFX_MAX_SERIALNUM_LEN	(ETH_ALEN * 2 + 1)
+
+static void efx_devlink_info_board_cfg(struct efx_nic *efx,
+				       struct devlink_info_req *req)
+{
+	char sn[EFX_MAX_SERIALNUM_LEN];
+	u8 mac_address[ETH_ALEN];
+	int rc;
+
+	rc = efx_mcdi_get_board_cfg(efx, (u8 *)mac_address, NULL, NULL);
+	if (!rc) {
+		snprintf(sn, EFX_MAX_SERIALNUM_LEN, "%pm", mac_address);
+		devlink_info_serial_number_put(req, sn);
+	}
+}
+
+static int efx_devlink_info_get(struct devlink *devlink,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct efx_devlink *devlink_private = devlink_priv(devlink);
+	struct efx_nic *efx = devlink_private->efx;
+
+	efx_devlink_info_board_cfg(efx, req);
+	efx_devlink_info_stored_versions(efx, req);
+	efx_devlink_info_running_versions(efx, req);
+	return 0;
+}
+
 static const struct devlink_ops sfc_devlink_ops = {
+	.info_get			= efx_devlink_info_get,
 };
 
 void efx_fini_devlink_start(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
index 55d0d8aeca1e..8bcd077d8d8d 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -14,6 +14,23 @@
 #include "net_driver.h"
 #include <net/devlink.h>
 
+/* Custom devlink-info version object names for details that do not map to the
+ * generic standardized names.
+ */
+#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
+#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
+#define EFX_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
+#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
+#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
+#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
+#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
+#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
+#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
+#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
+#define EFX_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"
+
+#define EFX_MAX_VERSION_INFO_LEN	64
+
 int efx_probe_devlink(struct efx_nic *efx);
 void efx_probe_devlink_done(struct efx_nic *efx);
 void efx_fini_devlink_start(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index af338208eae9..328cae82a7d8 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -2308,6 +2308,78 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
 	return rc;
 }
 
+int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
+			    u32 *subtype, u16 version[4], char *desc,
+			    size_t descsize)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
+	efx_dword_t *outbuf;
+	size_t outlen;
+	u32 flags;
+	int rc;
+
+	outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
+	if (!outbuf)
+		return -ENOMEM;
+
+	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
+				sizeof(inbuf), outbuf,
+				MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
+				&outlen);
+	if (rc)
+		goto out_free;
+	if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
+		rc = -EIO;
+		goto out_free;
+	}
+
+	flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
+
+	if (desc && descsize > 0) {
+		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
+			if (descsize <=
+			    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
+				rc = -E2BIG;
+				goto out_free;
+			}
+
+			strncpy(desc,
+				MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
+				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
+			desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
+		} else {
+			desc[0] = '\0';
+		}
+	}
+
+	if (subtype) {
+		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
+			*subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
+		else
+			*subtype = 0;
+	}
+
+	if (version) {
+		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
+			version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
+			version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
+			version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
+			version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
+		} else {
+			version[0] = 0;
+			version[1] = 0;
+			version[2] = 0;
+			version[3] = 0;
+		}
+	}
+
+out_free:
+	kfree(outbuf);
+	return rc;
+}
+
 int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
 		      size_t len, size_t *retlen, u8 *buffer)
 {
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 7e35fec9da35..5cb202684858 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -378,6 +378,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
 			size_t *size_out, size_t *erase_size_out,
 			bool *protected_out);
 int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
+int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
+			    u32 *subtype, u16 version[4], char *desc,
+			    size_t descsize);
 int efx_mcdi_nvram_test_all(struct efx_nic *efx);
 int efx_mcdi_handle_assertion(struct efx_nic *efx);
 int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
-- 
2.17.1

