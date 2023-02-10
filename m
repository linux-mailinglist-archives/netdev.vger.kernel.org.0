Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F93B691F76
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjBJNEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjBJNEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:04:05 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422986952E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:04:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVhKWKBYpxSvB0fEs5d7kDnoAH3b1WN5Iyq/q4T+MaiAZ73Krr5VxVQLEnOslqCCUGvHzX3Cz3VSafb/RntodIZA4ec6j0j2yilAqCaOix0YDlLWs7sGwUuCHUnqdurcWkyA5GSOgM20SKzr2JGUtq2Hj+LFuaEyuUMwdXcw/Pc+54ROUX3egIENXAI+dvlg7IWQ2D5iYUDSPaeiFfg9SYr5t7tTyWmhKMKOyafUmIMVNUdLVFmKs/brlhTNzlJRhd4mNw2V0wUtvkIDaJsehP1yEDLVwHIndBlpExguRtUoS4uoPImCcKOd+DU5o39rPERGuLYixjmamoDkvyQ9qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjjm1oTkQwwibODWO1kXEpbKctlvivpEvkDUk5inW7w=;
 b=JubCwjrl/eRRdNZ/9EifiscJ02r39Hic7/6SaWoL813zhTWlJpfovP7d9FWaIoXqr7ZuUZSTonWAwfkGkd3mDhE0fAyH4/cimIDOjn0gzuANXEUAUh1aa+YPWdpI9j+/zK/D/5VoisWv1VqS/g8tskuHEO2Tkux+2/SZbulNTFYx4aEkPrWI8kZB/u9zbaleNhp/NBmT/YxPLVdY+G1YR0fco1pydIuwAXjmt//gfF7N+BS5bWW4L3ftaKFb4o7ndKwBaTvSKqatRZAHcjwZeU/n/bAKZVVSwErUdO47h/VWwGYKSvg5h9n21s/DNlpnyVHB7Aw8iu8qfZHAq617Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjjm1oTkQwwibODWO1kXEpbKctlvivpEvkDUk5inW7w=;
 b=JOygz8WT6oF+kXdk9Fe+ajG7HwaAdNtDEH578i75hhlEZORYm5eXlrGoUsA488OGK6eb2zLLsNlRIEkZrnv33IzsZIMgbwuDgO5Ell5MnGOqXsCuT6190m9/G12RAzFRenxvJ14nIqFQZKywwOwCyHpRXY2VzWJHdY+zMzG5Dis=
Received: from DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22)
 by SJ2PR12MB7848.namprd12.prod.outlook.com (2603:10b6:a03:4ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:03:41 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::7d) by DS7PR03CA0137.outlook.office365.com
 (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 13:03:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.35 via Frontend Transport; Fri, 10 Feb 2023 13:03:41 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:40 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 05:03:36 -0800
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:33 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  1/6] net: ethernet: efct: New X3 net driver
Date:   Fri, 10 Feb 2023 18:33:16 +0530
Message-ID: <20230210130321.2898-2-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT046:EE_|SJ2PR12MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 84fb6395-2c1a-4979-8d88-08db0b673bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4yU/G8m61zT9zRCXqXFMvLijJCE4BbT+Reg5aE2YSNbjF4nblz+HpodEgtwuwm3kO8Z0Eq8qIbafg6JlEsyl8pQ1G5/vJY3RO5II6fD/jbsnRJ8Yx2xM0vtiUNSYonA2I1WZ9VdsveA9MCLTn/ByLhxZerlS80BWnw6aeXwsZkg/pI4biw/ZFlcXTmiU6DwCrhBHPBl7IoUzgn4jL2Y0NNyR8q/OWqGv64TvBr08/qPFGh54M2QGXNZmWUrYDWnAhlJcFXu/VGJcs8oqmVSQd2yfE3jK5iMgYm5mEg9/i+yZoHZfe4MqUcSkqr+m24h7DmTZ9y+KriPwu3UHcKrrF3FTmTABtlVPhMuV6GWR8S6VNSt+97bz39VrD8U3SaS5Jc0xSZoJAoHoGAPZO+5iVn5z+45QP1wcd97r+jgMc11k3rf6rGra953k+hWP5iMJe/pIhs5zMcgM1UNgZVcFsetGH1VJy6B6ROZvHSrNsIR7td3smICxX3+FpjIorn9J7LCIvf8iNw00GS0EIxei+1Q3govHyHmXCSbOQ/IPavDbVcIcL3tvp3vDNIACcvAISxK94apgLW5cY5xrteMc8t/FyGipBqaNYFeqtvI7ZtmgN1ahQUNo4lHB3n8iqkSe/22W1tVeRe8LAHR3kMoA2Z9dGd8jx8PVaZccukZ6LIx/fhRWrAHogYUSYqGX7dG3jMUyovGRWEBVl8DvZaPuc1j1oqwY4w3R81Mr1eGXa93NSd95V5cfxsqBzetn5PWFQRbtEvy2fUdmzWibGtp0YQTWjA2OE8lDZ15uxyTRzy59zyynNN75eRL667iJy0kyJiBLWtOHt2X0SltRexeDaQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(36756003)(40480700001)(82310400005)(83380400001)(356005)(921005)(66899018)(186003)(40460700003)(81166007)(36860700001)(82740400003)(1076003)(26005)(2906002)(6666004)(110136005)(478600001)(966005)(316002)(45080400002)(41300700001)(5660300002)(8936002)(86362001)(2616005)(426003)(336012)(47076005)(30864003)(70586007)(8676002)(4326008)(70206006)(21314003)(36900700001)(579004)(559001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:41.3803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fb6395-2c1a-4979-8d88-08db0b673bbb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7848
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds new ethernet network driver for Alveo X3522[1].
is a low-latency NIC with an aim to deliver the lowest possible
latency. It accelerates a range of diverse trading strategies
and financial applications.

Device has 2 PCI functions and each function supports 2 port, currently
at 10GbE. This patch deals with PCI device probing and netdev creation.
It also adds support for Firmware communication APIs used in later patches.

[1] https://www.xilinx.com/x3

Signed-off-by: Abhijit Gangurde<abhijit.gangurde@amd.com>
Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nikhil Agarwal<nikhil.agarwal@amd.com>
Signed-off-by: Tarak Reddy<tarak.reddy@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/net/ethernet/amd/efct/efct_bitfield.h |  483 ++
 drivers/net/ethernet/amd/efct/efct_common.c   | 1154 ++++
 drivers/net/ethernet/amd/efct/efct_common.h   |  134 +
 drivers/net/ethernet/amd/efct/efct_driver.h   |  770 +++
 drivers/net/ethernet/amd/efct/efct_enum.h     |  130 +
 drivers/net/ethernet/amd/efct/efct_evq.c      |  185 +
 drivers/net/ethernet/amd/efct/efct_evq.h      |   21 +
 drivers/net/ethernet/amd/efct/efct_io.h       |   64 +
 drivers/net/ethernet/amd/efct/efct_netdev.c   |  459 ++
 drivers/net/ethernet/amd/efct/efct_netdev.h   |   19 +
 drivers/net/ethernet/amd/efct/efct_nic.c      | 1300 ++++
 drivers/net/ethernet/amd/efct/efct_nic.h      |  104 +
 drivers/net/ethernet/amd/efct/efct_pci.c      | 1077 +++
 drivers/net/ethernet/amd/efct/efct_reg.h      | 1060 +++
 drivers/net/ethernet/amd/efct/mcdi.c          | 1817 ++++++
 drivers/net/ethernet/amd/efct/mcdi.h          |  373 ++
 .../net/ethernet/amd/efct/mcdi_functions.c    |  642 ++
 .../net/ethernet/amd/efct/mcdi_functions.h    |   39 +
 drivers/net/ethernet/amd/efct/mcdi_pcol.h     | 5789 +++++++++++++++++
 .../net/ethernet/amd/efct/mcdi_port_common.c  |  949 +++
 .../net/ethernet/amd/efct/mcdi_port_common.h  |   98 +
 21 files changed, 16667 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/efct/efct_bitfield.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_common.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_common.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_driver.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_enum.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_evq.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_evq.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_io.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_netdev.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_netdev.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_nic.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_nic.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_pci.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_reg.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi.c
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_functions.c
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_functions.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_pcol.h
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_port_common.c
 create mode 100644 drivers/net/ethernet/amd/efct/mcdi_port_common.h

diff --git a/drivers/net/ethernet/amd/efct/efct_bitfield.h b/drivers/net/ethernet/amd/efct/efct_bitfield.h
new file mode 100644
index 000000000000..bd67e0fa08f9
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_bitfield.h
@@ -0,0 +1,483 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_BITFIELD_H
+#define EFCT_BITFIELD_H
+#include <linux/types.h>
+
+/* Efct bitfield access
+ * NIC uses bitfield of upto 128 bits wide.  Since there is no
+ * native 128-bit datatype on most systems, and 64-bit datatypes
+ * are inefficient on 32-bit systems and vice versa,
+ * we wrap accesses in a way that uses the most efficient
+ * datatype.
+ *
+ * The NICs are PCI devices and therefore little-endian.  Since most
+ * of the quantities that we deal with are DMAed to/from host memory,
+ * we define our datatypes (union efct_oword, union efct_dword and
+ * union efct_qword) to be little-endian.
+ */
+
+/* Lowest bit numbers and widths */
+#define EFCT_DUMMY_FIELD_LBN 0
+#define EFCT_DUMMY_FIELD_WIDTH 0
+#define EFCT_WORD_0_LBN 0
+#define EFCT_WORD_0_WIDTH 16
+#define EFCT_WORD_1_LBN 16
+#define EFCT_WORD_1_WIDTH 16
+#define EFCT_DWORD_0_LBN 0
+#define EFCT_DWORD_0_WIDTH 32
+#define EFCT_DWORD_1_LBN 32
+#define EFCT_DWORD_1_WIDTH 32
+#define EFCT_DWORD_2_LBN 64
+#define EFCT_DWORD_2_WIDTH 32
+#define EFCT_DWORD_3_LBN 96
+#define EFCT_DWORD_3_WIDTH 32
+#define EFCT_QWORD_0_LBN 0
+#define EFCT_QWORD_0_WIDTH 64
+/* Specified attribute (e.g. LBN) of the specified field */
+#define EFCT_VAL(field, attribute) field ## _ ## attribute
+/* Low bit number of the specified field */
+#define EFCT_LOW_BIT(field) EFCT_VAL(field, LBN)
+/* Bit width of the specified field */
+#define EFCT_WIDTH(field) EFCT_VAL(field, WIDTH)
+/* High bit number of the specified field */
+#define EFCT_HIGH_BIT(field) (EFCT_LOW_BIT(field) + EFCT_WIDTH(field) - 1)
+/* Mask equal in width to the specified field.
+ *
+ * For example, a field with width 5 would have a mask of 0x1f.
+ *
+ * The maximum width mask that can be generated is 64 bits.
+ */
+#define EFCT_MASK64(width)			\
+	((width) == 64 ? ~((u64)0) :		\
+	 (((((u64)1) << (width))) - 1))
+
+/* Mask equal in width to the specified field.
+ *
+ * For example, a field with width 5 would have a mask of 0x1f.
+ *
+ * The maximum width mask that can be generated is 32 bits.  Use
+ * EFCT_MASK64 for higher width fields.
+ */
+#define EFCT_MASK32(width)			\
+	((width) == 32 ? ~((u32)0) :		\
+	 (((((u32)1) << (width))) - 1))
+
+/* A doubleword (i.e. 4 byte) datatype - little-endian in HW */
+union efct_dword {
+	__le32 word32;
+};
+
+/* A quadword (i.e. 8 byte) datatype - little-endian in HW */
+union efct_qword {
+	__le64 u64[1];
+	__le32 u32[2];
+	union efct_dword dword[2];
+};
+
+/* An octword (eight-word, i.e. 16 byte) datatype - little-endian in HW */
+union efct_oword {
+	__le64 u64[2];
+	union efct_qword qword[2];
+	__le32 u32[4];
+	union efct_dword dword[4];
+};
+
+/* Format string and value expanders for printk */
+#define EFCT_DWORD_FMT "%08x"
+#define EFCT_OWORD_FMT "%08x:%08x:%08x:%08x"
+#define EFCT_DWORD_VAL(dword)				\
+	((u32)le32_to_cpu((dword).word32))
+
+/* Extract bit field portion [low,high) from the native-endian element
+ * which contains bits [min,max).
+ * For example, suppose "element" represents the high 32 bits of a
+ * 64-bit value, and we wish to extract the bits belonging to the bit
+ * field occupying bits 28-45 of this 64-bit value.
+ * Then EFCT_EXTRACT ( element, 32, 63, 28, 45 ) would give
+ *
+ *   ( element ) << 4
+ * The result will contain the relevant bits filled in the range
+ * [0,high-low), with garbage in bits [high-low+1,...).
+ */
+#define EFCT_EXTRACT_NATIVE(native_element, min, max, low, high)		\
+	((low) > (max) || (high) < (min) ? 0 :				\
+	 (low) > (min) ?						\
+	 (native_element) >> ((low) - (min)) :				\
+	 (native_element) << ((min) - (low)))
+
+/* Extract bit field portion [low,high) from the 64-bit little-endian
+ * element which contains bits [min,max)
+ */
+#define EFCT_EXTRACT64(element, min, max, low, high)			\
+	EFCT_EXTRACT_NATIVE(le64_to_cpu(element), min, max, low, high)
+
+/* Extract bit field portion [low,high) from the 32-bit little-endian
+ * element which contains bits [min,max)
+ */
+#define EFCT_EXTRACT32(element, min, max, low, high)			\
+	EFCT_EXTRACT_NATIVE(le32_to_cpu(element), min, max, low, high)
+
+#define EFCT_EXTRACT_OWORD64(oword, low, high)				\
+	((EFCT_EXTRACT64((oword).u64[0], 0, 63, low, high) |		\
+	  EFCT_EXTRACT64((oword).u64[1], 64, 127, low, high)) &		\
+	 EFCT_MASK64((high) + 1 - (low)))
+
+#define EFCT_EXTRACT_QWORD64(qword, low, high)				\
+	(EFCT_EXTRACT64((qword).u64[0], 0, 63, low, high) &		\
+	 EFCT_MASK64((high) + 1 - (low)))
+
+#define EFCT_EXTRACT_OWORD32(oword, low, high)				\
+	((EFCT_EXTRACT32((oword).u32[0], 0, 31, low, high) |		\
+	  EFCT_EXTRACT32((oword).u32[1], 32, 63, low, high) |		\
+	  EFCT_EXTRACT32((oword).u32[2], 64, 95, low, high) |		\
+	  EFCT_EXTRACT32((oword).u32[3], 96, 127, low, high)) &		\
+	 EFCT_MASK32((high) + 1 - (low)))
+
+#define EFCT_EXTRACT_QWORD32(qword, low, high)				\
+	((EFCT_EXTRACT32((qword).u32[0], 0, 31, low, high) |		\
+	  EFCT_EXTRACT32((qword).u32[1], 32, 63, low, high)) &		\
+	 EFCT_MASK32((high) + 1 - (low)))
+
+#define EFCT_EXTRACT_DWORD(dword, low, high)			\
+	(EFCT_EXTRACT32((dword).word32, 0, 31, low, high) &	\
+	 EFCT_MASK32((high) + 1 - (low)))
+
+#define EFCT_OWORD_FIELD64(oword, field)				\
+	EFCT_EXTRACT_OWORD64(oword, EFCT_LOW_BIT(field),		\
+			    EFCT_HIGH_BIT(field))
+
+#define EFCT_QWORD_FIELD64(qword, field)				\
+	EFCT_EXTRACT_QWORD64(qword, EFCT_LOW_BIT(field),		\
+			    EFCT_HIGH_BIT(field))
+
+#define EFCT_OWORD_FIELD32(oword, field)				\
+	EFCT_EXTRACT_OWORD32(oword, EFCT_LOW_BIT(field),		\
+			    EFCT_HIGH_BIT(field))
+
+#define EFCT_QWORD_FIELD32(qword, field)				\
+	EFCT_EXTRACT_QWORD32(qword, EFCT_LOW_BIT(field),		\
+			    EFCT_HIGH_BIT(field))
+
+#define EFCT_DWORD_FIELD(dword, field)				\
+	EFCT_EXTRACT_DWORD(dword, EFCT_LOW_BIT(field),		\
+			  EFCT_HIGH_BIT(field))
+
+#define EFCT_OWORD_IS_ZERO64(oword)					\
+	(((oword).u64[0] | (oword).u64[1]) == (__force __le64)0)
+
+#define EFCT_QWORD_IS_ZERO64(qword)					\
+	(((qword).u64[0]) == (__force __le64)0)
+
+#define EFCT_OWORD_IS_ZERO32(oword)					     \
+	(((oword).u32[0] | (oword).u32[1] | (oword).u32[2] | (oword).u32[3]) \
+	 == (__force __le32)0)
+
+#define EFCT_QWORD_IS_ZERO32(qword)					\
+	(((qword).u32[0] | (qword).u32[1]) == (__force __le32)0)
+
+#define EFCT_DWORD_IS_ZERO(dword)					\
+	(((dword).u32[0]) == (__force __le32)0)
+
+#define EFCT_OWORD_IS_ALL_ONES64(oword)					\
+	(((oword).u64[0] & (oword).u64[1]) == ~((__force __le64)0))
+
+#define EFCT_QWORD_IS_ALL_ONES64(qword)					\
+	((qword).u64[0] == ~((__force __le64)0))
+
+#define EFCT_OWORD_IS_ALL_ONES32(oword)					\
+	(((oword).u32[0] & (oword).u32[1] & (oword).u32[2] & (oword).u32[3]) \
+	 == ~((__force __le32)0))
+
+#define EFCT_QWORD_IS_ALL_ONES32(qword)					\
+	(((qword).u32[0] & (qword).u32[1]) == ~((__force __le32)0))
+
+#define EFCT_DWORD_IS_ALL_ONES(dword)					\
+	((dword).u32[0] == ~((__force __le32)0))
+
+#if BITS_PER_LONG == 64
+#define EFCT_OWORD_FIELD		EFCT_OWORD_FIELD64
+#define EFCT_QWORD_FIELD		EFCT_QWORD_FIELD64
+#define EFCT_OWORD_IS_ZERO	EFCT_OWORD_IS_ZERO64
+#define EFCT_QWORD_IS_ZERO	EFCT_QWORD_IS_ZERO64
+#define EFCT_OWORD_IS_ALL_ONES	EFCT_OWORD_IS_ALL_ONES64
+#define EFCT_QWORD_IS_ALL_ONES	EFCT_QWORD_IS_ALL_ONES64
+#else
+#define EFCT_OWORD_FIELD		EFCT_OWORD_FIELD32
+#define EFCT_QWORD_FIELD		EFCT_QWORD_FIELD32
+#define EFCT_OWORD_IS_ZERO	EFCT_OWORD_IS_ZERO32
+#define EFCT_QWORD_IS_ZERO	EFCT_QWORD_IS_ZERO32
+#define EFCT_OWORD_IS_ALL_ONES	EFCT_OWORD_IS_ALL_ONES32
+#define EFCT_QWORD_IS_ALL_ONES	EFCT_QWORD_IS_ALL_ONES32
+#endif
+
+/* Construct bit field portion
+ * Creates the portion of the bit field [low,high) that lies within
+ * the range [min,max).
+ */
+#define EFCT_INSERT_NATIVE64(min, max, low, high, value)		\
+	((((low) > (max)) || ((high) < (min))) ? 0 :			\
+	 (((low) > (min)) ?						\
+	  (((u64)(value)) << ((low) - (min))) :		\
+	  (((u64)(value)) >> ((min) - (low)))))
+
+#define EFCT_INSERT_NATIVE32(min, max, low, high, value)		\
+	((((low) > (max)) || ((high) < (min))) ? 0 :			\
+	 (((low) > (min)) ?						\
+	  (((u32)(value)) << ((low) - (min))) :		\
+	  (((u32)(value)) >> ((min) - (low)))))
+
+#define EFCT_INSERT_NATIVE(min, max, low, high, value)		\
+	(((((max) - (min)) >= 32) || (((high) - (low)) >= 32)) ?	\
+	 EFCT_INSERT_NATIVE64(min, max, low, high, value) :	\
+	 EFCT_INSERT_NATIVE32(min, max, low, high, value))
+
+/* Construct bit field portion
+ * Creates the portion of the named bit field that lies within the
+ * range [min,max).
+ */
+#define EFCT_INSERT_FIELD_NATIVE(min, max, field, value)		\
+	EFCT_INSERT_NATIVE(min, max, EFCT_LOW_BIT(field),		\
+			  EFCT_HIGH_BIT(field), value)
+
+/* Construct bit field
+ * Creates the portion of the named bit fields that lie within the
+ * range [min,max).
+ */
+#define EFCT_INSERT_FIELDS_NATIVE(_min, _max,				\
+				 field1, value1,			\
+				 field2, value2,			\
+				 field3, value3,			\
+				 field4, value4,			\
+				 field5, value5,			\
+				 field6, value6,			\
+				 field7, value7,			\
+				 field8, value8,			\
+				 field9, value9,			\
+				 field10, value10)			\
+	({typeof(_min) (min) = (_min);					\
+	  typeof(_max) (max) = (_max);			\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field1, (value1)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field2, (value2)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field3, (value3)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field4, (value4)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field5, (value5)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field6, (value6)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field7, (value7)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field8, (value8)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field9, (value9)) |	\
+	 EFCT_INSERT_FIELD_NATIVE((min), (max), field10, (value10)); })
+
+#define EFCT_INSERT_FIELDS64(...)				\
+	cpu_to_le64(EFCT_INSERT_FIELDS_NATIVE(__VA_ARGS__))
+
+#define EFCT_INSERT_FIELDS32(...)				\
+	cpu_to_le32(EFCT_INSERT_FIELDS_NATIVE(__VA_ARGS__))
+
+#define EFCT_POPULATE_OWORD64(oword, ...) do {				\
+	(oword).u64[0] = EFCT_INSERT_FIELDS64(0, 63, __VA_ARGS__);	\
+	(oword).u64[1] = EFCT_INSERT_FIELDS64(64, 127, __VA_ARGS__);	\
+	} while (0)
+
+#define EFCT_POPULATE_QWORD64(qword, ...) (qword).u64[0] = EFCT_INSERT_FIELDS64(0, 63, __VA_ARGS__)
+
+#define EFCT_POPULATE_OWORD32(oword, ...) do {				\
+	(oword).u32[0] = EFCT_INSERT_FIELDS32(0, 31, __VA_ARGS__);	\
+	(oword).u32[1] = EFCT_INSERT_FIELDS32(32, 63, __VA_ARGS__);	\
+	(oword).u32[2] = EFCT_INSERT_FIELDS32(64, 95, __VA_ARGS__);	\
+	(oword).u32[3] = EFCT_INSERT_FIELDS32(96, 127, __VA_ARGS__);	\
+	} while (0)
+
+#define EFCT_POPULATE_QWORD32(qword, ...) do {				\
+	(qword).u32[0] = EFCT_INSERT_FIELDS32(0, 31, __VA_ARGS__);	\
+	(qword).u32[1] = EFCT_INSERT_FIELDS32(32, 63, __VA_ARGS__);	\
+	} while (0)
+
+#define EFCT_POPULATE_DWORD(dword, ...) (dword).word32 = EFCT_INSERT_FIELDS32(0, 31, __VA_ARGS__)
+
+#if BITS_PER_LONG == 64
+#define EFCT_POPULATE_OWORD EFCT_POPULATE_OWORD64
+#define EFCT_POPULATE_QWORD EFCT_POPULATE_QWORD64
+#else
+#define EFCT_POPULATE_OWORD EFCT_POPULATE_OWORD32
+#define EFCT_POPULATE_QWORD EFCT_POPULATE_QWORD32
+#endif
+
+/* Populate an octword field with various numbers of arguments */
+#define EFCT_POPULATE_OWORD_10 EFCT_POPULATE_OWORD
+#define EFCT_POPULATE_OWORD_9(oword, ...) \
+	EFCT_POPULATE_OWORD_10(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_8(oword, ...) \
+	EFCT_POPULATE_OWORD_9(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_7(oword, ...) \
+	EFCT_POPULATE_OWORD_8(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_6(oword, ...) \
+	EFCT_POPULATE_OWORD_7(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_5(oword, ...) \
+	EFCT_POPULATE_OWORD_6(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_4(oword, ...) \
+	EFCT_POPULATE_OWORD_5(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_3(oword, ...) \
+	EFCT_POPULATE_OWORD_4(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_2(oword, ...) \
+	EFCT_POPULATE_OWORD_3(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_OWORD_1(oword, ...) \
+	EFCT_POPULATE_OWORD_2(oword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_ZERO_OWORD(oword) \
+	EFCT_POPULATE_OWORD_1(oword, EFCT_DUMMY_FIELD, 0)
+#define EFCT_SET_OWORD(oword) \
+	EFCT_POPULATE_OWORD_4(oword, \
+			     EFCT_DWORD_0, 0xffffffff, \
+			     EFCT_DWORD_1, 0xffffffff, \
+			     EFCT_DWORD_2, 0xffffffff, \
+			     EFCT_DWORD_3, 0xffffffff)
+
+/* Populate a quadword field with various numbers of arguments */
+#define EFCT_POPULATE_QWORD_10 EFCT_POPULATE_QWORD
+#define EFCT_POPULATE_QWORD_9(qword, ...) \
+	EFCT_POPULATE_QWORD_10(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_8(qword, ...) \
+	EFCT_POPULATE_QWORD_9(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_7(qword, ...) \
+	EFCT_POPULATE_QWORD_8(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_6(qword, ...) \
+	EFCT_POPULATE_QWORD_7(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_5(qword, ...) \
+	EFCT_POPULATE_QWORD_6(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_4(qword, ...) \
+	EFCT_POPULATE_QWORD_5(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_3(qword, ...) \
+	EFCT_POPULATE_QWORD_4(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_2(qword, ...) \
+	EFCT_POPULATE_QWORD_3(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_QWORD_1(qword, ...) \
+	EFCT_POPULATE_QWORD_2(qword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_ZERO_QWORD(qword) \
+	EFCT_POPULATE_QWORD_1(qword, EFCT_DUMMY_FIELD, 0)
+#define EFCT_SET_QWORD(qword) \
+	EFCT_POPULATE_QWORD_2(qword, \
+			     EFCT_DWORD_0, 0xffffffff, \
+			     EFCT_DWORD_1, 0xffffffff)
+/* Populate a dword field with various numbers of arguments */
+#define EFCT_POPULATE_DWORD_10 EFCT_POPULATE_DWORD
+#define EFCT_POPULATE_DWORD_9(dword, ...) \
+	EFCT_POPULATE_DWORD_10(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_8(dword, ...) \
+	EFCT_POPULATE_DWORD_9(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_7(dword, ...) \
+	EFCT_POPULATE_DWORD_8(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_6(dword, ...) \
+	EFCT_POPULATE_DWORD_7(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_5(dword, ...) \
+	EFCT_POPULATE_DWORD_6(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_4(dword, ...) \
+	EFCT_POPULATE_DWORD_5(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_3(dword, ...) \
+	EFCT_POPULATE_DWORD_4(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_2(dword, ...) \
+	EFCT_POPULATE_DWORD_3(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_POPULATE_DWORD_1(dword, ...) \
+	EFCT_POPULATE_DWORD_2(dword, EFCT_DUMMY_FIELD, 0, __VA_ARGS__)
+#define EFCT_ZERO_DWORD(dword) \
+	EFCT_POPULATE_DWORD_1(dword, EFCT_DUMMY_FIELD, 0)
+#define EFCT_SET_DWORD(dword) \
+	EFCT_POPULATE_DWORD_1(dword, EFCT_DWORD_0, 0xffffffff)
+
+/* Modify a named field within an already-populated structure.  Used
+ * for read-modify-write operations.
+ */
+
+#define EFCT_INSERT64(min, max, low, high, value)			\
+	cpu_to_le64(EFCT_INSERT_NATIVE(min, max, low, high, value))
+
+#define EFCT_INSERT32(min, max, low, high, value)			\
+	cpu_to_le32(EFCT_INSERT_NATIVE(min, max, low, high, value))
+
+#define EFCT_INPLACE_MASK64(min, max, low, high)				\
+	EFCT_INSERT64(min, max, low, high, EFCT_MASK64((high) + 1 - (low)))
+
+#define EFCT_INPLACE_MASK32(min, max, low, high)				\
+	EFCT_INSERT32(min, max, low, high, EFCT_MASK32((high) + 1 - (low)))
+
+#define EFCT_SET_OWORD64(oword, low, high, value) do {			\
+	(oword).u64[0] = (((oword).u64[0]				\
+			   & ~EFCT_INPLACE_MASK64(0,  63, low, high))	\
+			  | EFCT_INSERT64(0,  63, low, high, value));	\
+	(oword).u64[1] = (((oword).u64[1]				\
+			   & ~EFCT_INPLACE_MASK64(64, 127, low, high))	\
+			  | EFCT_INSERT64(64, 127, low, high, value));	\
+	} while (0)
+
+#define EFCT_SET_QWORD64(qword, low, high, value)			\
+	(qword).u64[0] = (((qword).u64[0]				\
+			   & ~EFCT_INPLACE_MASK64(0, 63, low, high))	\
+			  | EFCT_INSERT64(0, 63, low, high, value))	\
+
+#define EFCT_SET_OWORD32(oword, low, high, value) do {			\
+	(oword).u32[0] = (((oword).u32[0]				\
+			   & ~EFCT_INPLACE_MASK32(0, 31, low, high))	\
+			  | EFCT_INSERT32(0, 31, low, high, value));	\
+	(oword).u32[1] = (((oword).u32[1]				\
+			   & ~EFCT_INPLACE_MASK32(32, 63, low, high))	\
+			  | EFCT_INSERT32(32, 63, low, high, value));	\
+	(oword).u32[2] = (((oword).u32[2]				\
+			   & ~EFCT_INPLACE_MASK32(64, 95, low, high))	\
+			  | EFCT_INSERT32(64, 95, low, high, value));	\
+	(oword).u32[3] = (((oword).u32[3]				\
+			   & ~EFCT_INPLACE_MASK32(96, 127, low, high))	\
+			  | EFCT_INSERT32(96, 127, low, high, value));	\
+	} while (0)
+
+#define EFCT_SET_QWORD32(qword, low, high, value) do {			\
+	(qword).u32[0] = (((qword).u32[0]				\
+			   & ~EFCT_INPLACE_MASK32(0, 31, low, high))	\
+			  | EFCT_INSERT32(0, 31, low, high, value));	\
+	(qword).u32[1] = (((qword).u32[1]				\
+			   & ~EFCT_INPLACE_MASK32(32, 63, low, high))	\
+			  | EFCT_INSERT32(32, 63, low, high, value));	\
+	} while (0)
+
+#define EFCT_SET_DWORD32(dword, low, high, value)			\
+	  (dword).word32 = (((dword).word32				\
+			   & ~EFCT_INPLACE_MASK32(0, 31, low, high))	\
+			  | EFCT_INSERT32(0, 31, low, high, value))	\
+
+#define EFCT_SET_OWORD_FIELD64(oword, field, value)			\
+	EFCT_SET_OWORD64(oword, EFCT_LOW_BIT(field),			\
+			 EFCT_HIGH_BIT(field), value)
+
+#define EFCT_SET_QWORD_FIELD64(qword, field, value)			\
+	EFCT_SET_QWORD64(qword, EFCT_LOW_BIT(field),			\
+			 EFCT_HIGH_BIT(field), value)
+
+#define EFCT_SET_OWORD_FIELD32(oword, field, value)			\
+	EFCT_SET_OWORD32(oword, EFCT_LOW_BIT(field),			\
+			 EFCT_HIGH_BIT(field), value)
+
+#define EFCT_SET_QWORD_FIELD32(qword, field, value)			\
+	EFCT_SET_QWORD32(qword, EFCT_LOW_BIT(field),			\
+			 EFCT_HIGH_BIT(field), value)
+
+#define EFCT_SET_DWORD_FIELD(dword, field, value)			\
+	EFCT_SET_DWORD32(dword, EFCT_LOW_BIT(field),			\
+			 EFCT_HIGH_BIT(field), value)
+
+#if BITS_PER_LONG == 64
+#define EFCT_SET_OWORD_FIELD EFCT_SET_OWORD_FIELD64
+#define EFCT_SET_QWORD_FIELD EFCT_SET_QWORD_FIELD64
+#else
+#define EFCT_SET_OWORD_FIELD EFCT_SET_OWORD_FIELD32
+#define EFCT_SET_QWORD_FIELD EFCT_SET_QWORD_FIELD32
+#endif
+
+/* Static initialiser */
+#define EFCT_OWORD32(a, b, c, d)				\
+	{ .u32 = { cpu_to_le32(a), cpu_to_le32(b),	\
+		   cpu_to_le32(c), cpu_to_le32(d) } }
+
+#endif /* EFCT_BITFIELD_H */
diff --git a/drivers/net/ethernet/amd/efct/efct_common.c b/drivers/net/ethernet/amd/efct/efct_common.c
new file mode 100644
index 000000000000..a8e454d4e8a8
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_common.c
@@ -0,0 +1,1154 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include "efct_common.h"
+#include "mcdi.h"
+#include "mcdi_functions.h"
+#include "efct_io.h"
+#include "mcdi_pcol.h"
+#include "efct_reg.h"
+#include "efct_evq.h"
+
+static u32 debug = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
+		NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
+		NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
+		NETIF_MSG_TX_ERR | NETIF_MSG_HW);
+static int efct_probe_queues(struct efct_nic *efct);
+static void efct_remove_queues(struct efct_nic *efct);
+static void efct_reset_queue_work(struct work_struct *work);
+
+static const u32 efct_reset_type_max = RESET_TYPE_MAX;
+static const char *const efct_reset_type_names[] = {
+	[RESET_TYPE_ALL]                = "ALL",
+	[RESET_TYPE_WORLD]              = "WORLD",
+	[RESET_TYPE_DATAPATH]           = "DATAPATH",
+	[RESET_TYPE_MC_BIST]            = "MC_BIST",
+	[RESET_TYPE_DISABLE]            = "DISABLE",
+	[RESET_TYPE_TX_WATCHDOG]        = "TX_WATCHDOG",
+	[RESET_TYPE_MC_FAILURE]         = "MC_FAILURE",
+	[RESET_TYPE_MCDI_TIMEOUT]       = "MCDI_TIMEOUT (FLR)",
+};
+
+#define RESET_TYPE(type) STRING_TABLE_LOOKUP(type, efct_reset_type)
+
+/* How often and how many times to poll for a reset while waiting for a
+ * BIST that another function started to complete.
+ */
+#define BIST_WAIT_DELAY_MS  100
+#define BIST_WAIT_DELAY_COUNT   100
+
+static struct workqueue_struct *reset_workqueue;
+
+int efct_create_reset_workqueue(void)
+{
+	reset_workqueue = alloc_ordered_workqueue("efct_reset", 0);
+	if (!reset_workqueue) {
+		pr_err("Failed to create reset workqueue\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void efct_destroy_reset_workqueue(void)
+{
+	if (reset_workqueue) {
+		destroy_workqueue(reset_workqueue);
+		reset_workqueue = NULL;
+	}
+}
+
+void efct_flush_reset_workqueue(void)
+{
+	if (reset_workqueue)
+		flush_workqueue(reset_workqueue);
+}
+
+int efct_nic_alloc_buffer(struct efct_nic *efct, struct efct_buffer *buffer,
+			  u32 len, gfp_t gfp_flags)
+{
+	buffer->addr = dma_alloc_coherent(&efct->efct_dev->pci_dev->dev, len,
+					  &buffer->dma_addr, gfp_flags);
+	if (!buffer->addr)
+		return -ENOMEM;
+	buffer->len = len;
+	memset(buffer->addr, 0, len);
+	return 0;
+}
+
+void efct_nic_free_buffer(struct efct_nic *efct, struct efct_buffer *buffer)
+{
+	if (buffer->addr) {
+		dma_free_coherent(&efct->efct_dev->pci_dev->dev, buffer->len,
+				  buffer->addr, buffer->dma_addr);
+		buffer->addr = NULL;
+	}
+}
+
+static int evq_get_free_index(struct efct_nic *efct)
+{
+	unsigned long evq_active;
+	unsigned long mask;
+	int index = 0;
+
+	if (!efct)
+		return -EINVAL;
+
+	mask  = (1UL << efct->max_evq_count) - 1;
+
+	do {
+		evq_active = efct->evq_active_mask;
+		/*No free index present, all event queues are in use. ffz()
+		 *behavior is undefined if at least one zero is not present.
+		 * This check will make sure at least 1 zero bit is there in evq_active
+		 */
+		if ((evq_active & mask) == mask)
+			return -EAGAIN;
+		index = ffz(evq_active);
+		/* In case queue is already allocated because of contention. It will
+		 * retry for next available index
+		 */
+		if (test_and_set_bit(index, &efct->evq_active_mask)) {
+			netif_dbg(efct, drv, efct->net_dev,
+				  "Event queue index %d is already in use\n", index);
+			continue;
+		}
+
+		if (index < efct->max_evq_count)
+			return index;
+		else
+			return -ENOSPC;
+	} while (1);
+
+	return -ENOSPC;
+}
+
+void efct_schedule_reset(struct efct_nic *efct, enum reset_type type)
+{
+	unsigned long last_reset = READ_ONCE(efct->last_reset);
+	static const u32 RESETS_BEFORE_DISABLE = 5;
+	enum reset_type method;
+
+	method = efct->type->map_reset_reason(type);
+
+	/* check we're scheduling a new reset and if so check we're
+	 * not scheduling resets too often.
+	 * this part is not atomically safe, but is also ultimately a
+	 * heuristic; if we lose increments due to dirty writes
+	 * that's fine and if we falsely increment or reset due to an
+	 * inconsistent read of last_reset on 32-bit arch it's also ok.
+	 */
+	if (time_after(jiffies, last_reset + HZ))
+		efct->reset_count = 0;
+
+	if (!(efct->reset_pending & (1 << method)) && ++efct->reset_count > RESETS_BEFORE_DISABLE) {
+		method = RESET_TYPE_DISABLE;
+
+		netif_err(efct, drv, efct->net_dev,
+			  "too many resets, scheduling %s\n",
+			  RESET_TYPE(method));
+	}
+
+	netif_dbg(efct, drv, efct->net_dev, "scheduling %s reset for %s\n",
+		  RESET_TYPE(method), RESET_TYPE(type));
+
+	set_bit(method, &efct->reset_pending);
+	smp_mb(); /* ensure we change reset_pending before checking state */
+
+	queue_work(reset_workqueue, &efct->reset_work);
+}
+
+void efct_schedule_queue_reset(struct efct_nic *efct, bool is_txq, int qid)
+{
+	struct queue_reset_work *reset_work;
+
+	reset_work = kzalloc(sizeof(*reset_work), GFP_ATOMIC);
+	if (!reset_work)
+		return;
+
+	INIT_WORK(&reset_work->work, efct_reset_queue_work);
+	reset_work->efct = efct;
+	reset_work->is_txq = is_txq;
+	reset_work->qid = qid;
+
+	netif_dbg(efct, drv, efct->net_dev,
+		  "scheduling %s reset for queue %d\n", reset_work->is_txq ? "Txq" : "Rxq",
+		  reset_work->qid);
+
+	queue_work(reset_workqueue, &reset_work->work);
+}
+
+static void efct_wait_for_bist_end(struct efct_nic *efct)
+{
+	int i;
+
+	for (i = 0; i < BIST_WAIT_DELAY_COUNT; ++i) {
+		if (efct->type->mcdi_poll_bist_end(efct))
+			goto out;
+		msleep(BIST_WAIT_DELAY_MS);
+	}
+
+	netif_err(efct, drv, efct->net_dev, "Warning: No MC reboot after BIST mode\n");
+out:
+	/* Either way unset the BIST flag. If we found no reboot we probably
+	 * won't recover, but we should try.
+	 */
+	efct->mc_bist_for_other_fn = false;
+}
+
+/* The worker thread exists so that code that cannot sleep can
+ * schedule a reset for later.
+ */
+static void efct_reset_work(struct work_struct *data)
+{
+	struct efct_nic *efct = container_of(data, struct efct_nic, reset_work);
+	enum reset_type method;
+	unsigned long pending;
+
+	pending = READ_ONCE(efct->reset_pending);
+	method = fls(pending) - 1;
+
+	if (method == RESET_TYPE_MC_BIST)
+		/* TODO: Check MC config for BIST support. */
+		efct_wait_for_bist_end(efct);
+
+	rtnl_lock();
+	/* We checked the state in efct_schedule_reset() but it may
+	 * have changed by now.  Now that we have the RTNL lock,
+	 * it cannot change again.
+	 */
+	(void)efct_reset(efct, method);
+	rtnl_unlock();
+}
+
+static void efct_device_detach_sync(struct efct_nic *efct)
+{
+	struct net_device *dev = efct->net_dev;
+
+	/* Lock/freeze all TX queues so that we can be sure the
+	 * TX scheduler is stopped when we're done and before
+	 * netif_device_present() becomes false.
+	 */
+	netif_tx_lock_bh(dev);
+	netif_device_detach(dev);
+	netif_tx_stop_all_queues(dev);
+	netif_tx_unlock_bh(dev);
+}
+
+static void efct_device_attach_if_not_resetting(struct efct_nic *efct)
+{
+	if (efct->state != STATE_DISABLED && !efct->reset_pending) {
+		netif_tx_start_all_queues(efct->net_dev);
+		netif_device_attach(efct->net_dev);
+	}
+}
+
+/* Do post-processing after the reset.
+ * Returns whether the reset was completed and the device is back up.
+ */
+static int efct_reset_complete(struct efct_nic *efct, enum reset_type method,
+			       bool retry, bool disabled)
+{
+	if (disabled) {
+		netif_err(efct, drv, efct->net_dev, "has been disabled\n");
+		efct->state = STATE_DISABLED;
+		return false;
+	}
+
+	if (retry) {
+		netif_info(efct, drv, efct->net_dev, "scheduling retry of reset\n");
+		if (method == RESET_TYPE_MC_BIST)
+			method = RESET_TYPE_DATAPATH;
+		efct_schedule_reset(efct, method);
+		return false;
+	}
+
+	netif_dbg(efct, drv, efct->net_dev, "reset complete\n");
+	return true;
+}
+
+static int efct_do_reset(struct efct_nic *efct, enum reset_type method)
+{
+	int rc;
+
+	rc = efct->type->reset(efct, method);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev, "failed to reset hardware\n");
+		return rc;
+	}
+
+	/* Clear flags for the scopes we covered.  We assume the NIC and
+	 * driver are now quiescent so that there is no race here.
+	 */
+	if (method < RESET_TYPE_MAX_METHOD)
+		efct->reset_pending &= -(1 << (method + 1));
+	else /* it doesn't fit into the well-ordered scope hierarchy */
+		__clear_bit(method, &efct->reset_pending);
+
+	/* Reinitialise bus-mastering, which may have been turned off before
+	 * the reset was scheduled. This is still appropriate, even in the
+	 * RESET_TYPE_DISABLE since this driver generally assumes the hardware
+	 * can respond to requests.
+	 */
+	pci_set_master(efct->efct_dev->pci_dev);
+
+	return 0;
+}
+
+/* Reset the NIC using the specified method.  Note that the reset may
+ * fail, in which case the card will be left in an unusable state.
+ *
+ * Caller must hold the rtnl_lock.
+ */
+int efct_reset(struct efct_nic *efct, enum reset_type method)
+{
+	bool disabled, retry;
+	int rc;
+
+	ASSERT_RTNL();
+
+	netif_info(efct, drv, efct->net_dev, "resetting (%s)\n", RESET_TYPE(method));
+
+	efct_device_detach_sync(efct);
+
+	rc = efct_do_reset(efct, method);
+	retry = rc == -EAGAIN;
+
+	/* Leave device stopped if necessary */
+	disabled = (rc && !retry) || method == RESET_TYPE_DISABLE;
+
+	if (disabled)
+		dev_close(efct->net_dev);
+
+	if (efct_reset_complete(efct, method, retry, disabled))
+		efct_device_attach_if_not_resetting(efct);
+
+	return rc;
+}
+
+/* Reset the specific queue */
+static void efct_reset_queue_work(struct work_struct *work)
+{
+	struct queue_reset_work *reset_work = (struct queue_reset_work *)work;
+	struct efct_nic *efct = reset_work->efct;
+	int rc;
+
+	rtnl_lock();
+
+	if (reset_work->is_txq) {
+		struct efct_tx_queue *txq = &efct->txq[reset_work->qid];
+
+		efct_device_detach_sync(efct);
+
+		efct->type->tx_purge(txq);
+
+		rc = efct->type->tx_init(txq);
+		if (!rc)
+			efct_device_attach_if_not_resetting(efct);
+	} else {
+		struct efct_rx_queue *rxq = &efct->rxq[reset_work->qid];
+
+		efct->type->rx_purge(rxq);
+		efct_disable_napi(&efct->evq[rxq->evq_index]);
+		rc = efct->type->rx_init(rxq);
+		efct_enable_napi(&efct->evq[rxq->evq_index]);
+	}
+
+	rtnl_unlock();
+
+	if (rc)
+		netif_err(efct, drv, efct->net_dev, "Warning: %s:%d queue is disabled\n",
+			  reset_work->is_txq ? "Txq" : "Rxq", reset_work->qid);
+	else
+		netif_dbg(efct, drv, efct->net_dev, "%s:%d reset completed\n",
+			  reset_work->is_txq ? "Txq" : "Rxq", reset_work->qid);
+
+	kfree(reset_work);
+}
+
+/* Initializes the "struct efct_nic" structure
+ */
+/* Default stats update time */
+#define STAT_INTERVAL_MS 990
+
+void efct_set_evq_names(struct efct_nic *efct)
+{
+	struct efct_ev_queue *evq;
+	struct efct_rx_queue *rxq;
+	struct efct_tx_queue *txq;
+	char *type;
+	int i;
+
+	evq = efct->evq;
+	for (i = 0; i < efct->max_evq_count; i++) {
+		if (evq[i].type == EVQ_T_RX) {
+			type = "-rx";
+			rxq = (struct efct_rx_queue *)evq[i].queue;
+			snprintf(evq[i].msi.name, sizeof(evq[0].msi.name), "%s%s-%d", efct->name,
+				 type, rxq->index);
+		} else if (evq[i].type == EVQ_T_TX) {
+			type = "-tx";
+			txq = (struct efct_tx_queue *)evq[i].queue;
+			snprintf(evq[i].msi.name, sizeof(evq[0].msi.name), "%s%s-%d", efct->name,
+				 type, txq->txq_index);
+		} else {
+			continue;
+		}
+	}
+}
+
+int efct_init_struct(struct efct_nic *efct)
+{
+	int pkt_stride = 0;
+	int j = 0;
+
+	efct->state = STATE_UNINIT;
+	efct->mtu = EFCT_MAX_MTU;
+	efct->num_mac_stats = MC_CMD_MAC_NSTATS_V4;
+	efct->stats_period_ms = 0;
+	efct->stats_initialised = false;
+	spin_lock_init(&efct->stats_lock);
+
+	/* Update reset info */
+	INIT_WORK(&efct->reset_work, efct_reset_work);
+	efct->reset_pending = 0;
+	efct->stats_enabled = false;
+	/*Updating bitmap of active queue count*/
+	efct->evq_active_mask = 0;
+	efct->rxq_active_mask = 0;
+	efct->txq_active_mask = 0;
+	efct->msg_enable = debug;
+	efct->irq_rx_adaptive = true;
+
+	/*updating number of queues*/
+	efct->max_txq_count = efct->efct_dev->params.tx_apertures;
+	efct->rxq_count = min(efct->efct_dev->params.rx_queues, num_online_cpus());
+	efct->max_evq_count = efct->max_txq_count + efct->rxq_count;
+	if (efct->max_evq_count > efct->efct_dev->params.num_evq)
+		efct->max_evq_count = efct->efct_dev->params.num_evq;
+	/*Updating indexes and efct*/
+	for (j = 0; j < efct->max_evq_count; j++) {
+		efct->evq[j].index = j;
+		efct->evq[j].efct = efct;
+		efct->evq[j].unsol_credit = EFCT_EV_UNSOL_MAX;
+	}
+	for (j = 0; j < efct->max_txq_count; j++) {
+		efct->txq[j].txq_index = j;
+		efct->txq[j].efct = efct;
+	}
+	/*updating queue size*/
+	for (j = 0; j < EFCT_MAX_CORE_TX_QUEUES; j++)
+		efct->txq[j].num_entries =
+		roundup_pow_of_two(DIV_ROUND_UP(efct->efct_dev->params.tx_fifo_size, EFCT_MIN_MTU));
+
+	pkt_stride = roundup_pow_of_two(efct->mtu);
+
+	for (j = 0; j < efct->rxq_count; j++) {
+		efct->rxq[j].efct = efct;
+		efct->rxq[j].index = j;
+		efct->rxq[j].enable = false;
+		efct->rxq[j].num_rx_buffs = RX_BUFFS_PER_QUEUE;
+		efct->rxq[j].buffer_size =
+				efct->efct_dev->params.rx_buffer_len * EFCT_RX_BUF_SIZE_MULTIPLIER;
+		efct->rxq[j].pkt_stride = pkt_stride;
+		efct->rxq[j].num_entries =
+		roundup_pow_of_two(DIV_ROUND_UP(efct->rxq[j].buffer_size, pkt_stride)
+						* efct->rxq[j].num_rx_buffs);
+	}
+	efct->ct_thresh = CT_DEFAULT_THRESHOLD;
+	mutex_init(&efct->reflash_mutex);
+	mutex_init(&efct->mac_lock);
+
+	init_waitqueue_head(&efct->flush_wq);
+
+	return 0;
+}
+
+int efct_map_membase(struct efct_nic *efct, struct efct_func_ctl_window *fcw, u8 port_id)
+{
+	struct pci_dev *pci_dev = efct->efct_dev->pci_dev;
+	u32 uc_mem_map_size, wc_mem_map_size;
+	resource_size_t membase_phy;
+
+	if (port_id == 0) {
+		/* Unmap previous map */
+		if (efct->efct_dev->membase) {
+			iounmap(efct->efct_dev->membase);
+			efct->efct_dev->membase = NULL;
+		}
+		membase_phy = efct->efct_dev->membase_phys;
+		uc_mem_map_size = PAGE_ALIGN(fcw->offset + ER_HZ_PORT0_REG_HOST_CTPIO_REGION0);
+	} else {
+		membase_phy = efct->efct_dev->membase_phys + fcw->offset + EFCT_PORT_OFFSET;
+		uc_mem_map_size = PAGE_ALIGN(ER_HZ_PORT0_REG_HOST_CTPIO_REGION0);
+	}
+
+	wc_mem_map_size = PAGE_ALIGN(EFCT_PORT_LEN - ER_HZ_PORT0_REG_HOST_CTPIO_REGION0);
+
+	efct->membase = ioremap(membase_phy, uc_mem_map_size);
+	if (!efct->membase) {
+		pci_err(efct->efct_dev->pci_dev,
+			"could not map BAR at %llx+%x\n",
+			(unsigned long long)membase_phy, uc_mem_map_size);
+		return -ENOMEM;
+	}
+
+	efct->wc_membase = ioremap_wc(membase_phy + uc_mem_map_size, wc_mem_map_size);
+	if (!efct->wc_membase) {
+		pci_err(efct->efct_dev->pci_dev, "could not map wc to BAR at %llx+%x\n",
+			((unsigned long long)membase_phy + uc_mem_map_size), wc_mem_map_size);
+		iounmap(efct->membase);
+		efct->membase = NULL;
+		return -ENOMEM;
+	}
+
+	if (port_id == 0) {
+		efct->efct_dev->membase = efct->membase;
+		efct->membase += fcw->offset;
+	}
+
+	pci_dbg(pci_dev, "Port : %u, UC at %llx+%x (virtual %p), MC at %llx+%x (virtual %p)\n",
+		port_id, (unsigned long long)membase_phy, uc_mem_map_size,  efct->membase,
+		(unsigned long long)membase_phy + uc_mem_map_size, wc_mem_map_size,
+		efct->wc_membase);
+
+	return 0;
+}
+
+void efct_unmap_membase(struct efct_nic *efct)
+{
+	if (efct->wc_membase) {
+		iounmap(efct->wc_membase);
+		efct->wc_membase = NULL;
+	}
+
+	if (efct->membase) {
+		if (efct->port_base == 0u) {
+			iounmap(efct->efct_dev->membase);
+			efct->efct_dev->membase = NULL;
+		} else {
+			iounmap(efct->membase);
+		}
+
+		efct->membase = NULL;
+	}
+}
+
+/* This configures the PCI device to enable I/O and DMA. */
+int efct_init_io(struct efct_device *efct_dev,
+		 int bar, dma_addr_t dma_mask, u32 mem_map_size)
+{
+	struct pci_dev *pci_dev = efct_dev->pci_dev;
+	int rc;
+
+	efct_dev->mem_bar = UINT_MAX;
+	pci_dbg(pci_dev, "initialising I/O bar=%d\n", bar);
+
+	rc = pci_enable_device(pci_dev);
+	if (rc) {
+		pci_err(pci_dev, "failed to enable PCI device\n");
+		goto fail1;
+	}
+
+	pci_set_master(pci_dev);
+
+	/* Set the PCI DMA mask.  Try all possibilities from our
+	 * genuine mask down to 32 bits, because some architectures
+	 * (e.g. x86_64 with iommu_sac_force set) will allow 40 bit
+	 * masks event though they reject 46 bit masks.
+	 */
+	while (dma_mask > 0x7fffffffUL) {
+		rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
+		if (rc == 0)
+			break;
+		dma_mask >>= 1;
+	}
+	if (rc) {
+		pci_err(pci_dev, "could not find a suitable DMA mask\n");
+		goto fail2;
+	}
+	pci_dbg(pci_dev, "using DMA mask %llx\n", (unsigned long long)dma_mask);
+
+	efct_dev->membase_phys = pci_resource_start(efct_dev->pci_dev, bar);
+	if (!efct_dev->membase_phys) {
+		pci_err(pci_dev, "ERROR: No BAR%d mapping from the BIOS. Try pci=realloc on the kernel command line\n",
+			bar);
+		rc = -ENODEV;
+		goto fail3;
+	}
+	rc = pci_request_region(pci_dev, bar, "efct");
+	if (rc) {
+		pci_err(pci_dev, "request for memory BAR[%d] failed\n", bar);
+		goto fail3;
+	}
+	efct_dev->mem_bar = bar;
+	efct_dev->membase = ioremap(efct_dev->membase_phys, mem_map_size);
+	if (!efct_dev->membase) {
+		pci_err(pci_dev, "could not map memory BAR[%d] at %llx+%x\n",
+			bar, (unsigned long long)efct_dev->membase_phys, mem_map_size);
+		rc = -ENOMEM;
+		goto fail4;
+	}
+	pci_dbg(pci_dev, "memory BAR[%d] at %llx+%x (virtual %p)\n", bar,
+		(unsigned long long)efct_dev->membase_phys, mem_map_size,	efct_dev->membase);
+
+	return 0;
+
+fail4:
+	pci_release_region(efct_dev->pci_dev, bar);
+fail3:
+	efct_dev->membase_phys = 0;
+fail2:
+	pci_disable_device(efct_dev->pci_dev);
+fail1:
+	return rc;
+}
+
+void efct_fini_io(struct efct_device *efct_dev)
+{
+	pci_dbg(efct_dev->pci_dev, "shutting down I/O\n");
+
+	if (efct_dev->membase) {
+		iounmap(efct_dev->membase);
+		efct_dev->membase = NULL;
+	}
+
+	if (efct_dev->membase_phys) {
+		pci_release_region(efct_dev->pci_dev, efct_dev->mem_bar);
+		efct_dev->membase_phys = 0;
+		efct_dev->mem_bar = UINT_MAX;
+
+		/* Don't disable bus-mastering if VFs are assigned */
+		if (!pci_vfs_assigned(efct_dev->pci_dev))
+			pci_disable_device(efct_dev->pci_dev);
+	}
+}
+
+/* This ensures that the kernel is kept informed (via
+ * netif_carrier_on/off) of the link status.
+ */
+void efct_link_status_changed(struct efct_nic *efct)
+{
+	struct efct_link_state *link_state = &efct->link_state;
+	bool kernel_link_up;
+
+	if (!netif_running(efct->net_dev))
+		return;
+
+	kernel_link_up = netif_carrier_ok(efct->net_dev);
+	if (link_state->up != kernel_link_up) {
+		efct->n_link_state_changes++;
+
+		if (link_state->up)
+			netif_carrier_on(efct->net_dev);
+		else
+			netif_carrier_off(efct->net_dev);
+	}
+
+	/* Status message for kernel log */
+	if (!net_ratelimit())
+		return;
+
+	if (link_state->up) {
+		netif_info(efct, link, efct->net_dev,
+			   "link up at %uMbps %s-duplex (MTU %d)\n",
+			   link_state->speed, link_state->fd ? "full" : "half",
+			   efct->net_dev->mtu);
+
+	} else if (kernel_link_up) {
+		netif_info(efct, link, efct->net_dev, "link down\n");
+	}
+}
+
+int efct_probe_common(struct efct_nic *efct)
+{
+	int rc = efct_mcdi_init(efct);
+
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "MCDI initialization failed, rc=%d\n", rc);
+		goto fail;
+	}
+
+	/* Reset (most) configuration for this function */
+	rc = efct_mcdi_reset(efct, RESET_TYPE_ALL);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "MCDI reset failed, rc=%d\n", rc);
+		goto fail;
+	}
+
+	/* Enable event logging */
+	rc = efct_mcdi_log_ctrl(efct, true, false, 0);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "Enabling MCDI Log control failed, rc=%d\n", rc);
+		goto fail;
+	}
+
+	rc = efct_mcdi_filter_table_probe(efct);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "efct_mcdi_filter_table_probe failed, rc=%d\n",
+			rc);
+		goto fail;
+	}
+
+	/*Initialize structure for all the RXQs and TXQ#0*/
+	rc = efct_probe_queues(efct);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "Queues initialization(efct_probe_queues) failed\n");
+		goto free_filter;
+	}
+	return rc;
+free_filter:
+	efct_mcdi_filter_table_remove(efct);
+fail:
+	return rc;
+}
+
+void efct_remove_common(struct efct_nic *efct)
+{
+	efct_remove_queues(efct);
+	efct_mcdi_filter_table_remove(efct);
+	efct_mcdi_detach(efct);
+	efct_mcdi_fini(efct);
+}
+
+static int efct_probe_queues(struct efct_nic *efct)
+{
+	int txq_index[EFCT_MAX_CORE_TX_QUEUES];
+	int i = 0, j = 0, k = 0, rc;
+	int evq_index;
+
+	if (!efct)
+		return -EINVAL;
+	/*RXQ init*/
+	for (i = 0; i < efct->rxq_count; i++) {
+		evq_index = evq_get_free_index(efct);
+		if (evq_index < 0) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Got invalid evq_index for Rx, index %d\n", evq_index);
+			rc = evq_index;
+			goto fail;
+		}
+
+		rc = efct->type->ev_probe(efct, evq_index, efct->rxq[i].num_entries);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Event queue probe failed, index %d\n", evq_index);
+			if (!test_and_clear_bit(evq_index, &efct->evq_active_mask)) {
+				netif_err(efct, drv, efct->net_dev,
+					  "Event queue is already removed\n");
+			}
+			goto fail;
+		}
+		efct->evq[evq_index].msi.idx = i;
+		/*Borrowed from sfc ef10 need to modify*/
+		// request irq here.
+		efct->evq[evq_index].irq_moderation_ns = EFCT_IRQ_RX_MOD_DEFAULT_VAL;
+		efct->evq[evq_index].irq_adapt_low_thresh = EFCT_IRQ_ADAPT_LOW_THRESH_VAL;
+		efct->evq[evq_index].irq_adapt_high_thresh = EFCT_IRQ_ADAPT_HIGH_THRESH_VAL;
+		efct->evq[evq_index].irq_adapt_irqs = EFCT_IRQ_ADAPT_IRQS;
+		/* Setting rx_merge_timeout val as 0 to use the firmware's default value */
+		efct->evq[evq_index].rx_merge_timeout_ns = 0;
+
+		/* Add one rxq for an event queue */
+		efct->evq[evq_index].queue_count = 1;
+		efct->evq[evq_index].queue = (void *)&efct->rxq[i];
+
+		rc = efct->type->rx_probe(efct, i, evq_index);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev, "RX queue probe failed, index %d\n", i);
+			efct->type->ev_remove(&efct->evq[evq_index]);
+			goto fail;
+		}
+	}
+
+	/*TXQ init*/
+	for (j = 0; j < EFCT_MAX_CORE_TX_QUEUES; j++) {
+		evq_index = evq_get_free_index(efct);
+		if (evq_index < 0) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Got invalid evq_index for Tx, index %d\n", evq_index);
+			rc = evq_index;
+			goto fail;
+		}
+
+		rc = efct->type->ev_probe(efct, evq_index, efct->txq[j].num_entries);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Event queue probe failed, index %d\n", evq_index);
+			if (!test_and_clear_bit(evq_index, &efct->evq_active_mask)) {
+				netif_err(efct, drv, efct->net_dev,
+					  "Event queue is already removed\n");
+			}
+			goto fail;
+		}
+		efct->evq[evq_index].msi.idx = j;
+		efct->evq[evq_index].type = EVQ_T_TX;
+		efct->evq[evq_index].irq_moderation_ns = EFCT_IRQ_TX_MOD_DEFAULT_VAL;
+		/* Setting tx_merge_timeout val as 0 to use the firmware's default value */
+		efct->evq[evq_index].tx_merge_timeout_ns = 0;
+
+		/* Add one txq for an event queue */
+		efct->evq[evq_index].queue_count = 1;
+		efct->evq[evq_index].queue = (void *)&efct->txq[j];
+		txq_index[j] = efct->type->tx_probe(efct, evq_index, -1);
+		if (txq_index[j] < 0) {
+			netif_err(efct, drv, efct->net_dev,
+				  "TX queue probe failed, index %d\n", txq_index[j]);
+			efct->type->ev_remove(&efct->evq[evq_index]);
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	for (k = 0; k < i ; k++) {
+		efct->type->rx_remove(&efct->rxq[k]);
+		efct->type->ev_remove(&efct->evq[efct->rxq[k].evq_index]);
+	}
+
+	for (k = 0; k < j ; k++) {
+		efct->type->tx_remove(&efct->txq[txq_index[k]]);
+		efct->type->ev_remove(&efct->evq[efct->txq[txq_index[k]].evq_index]);
+	}
+
+	return rc;
+}
+
+static void efct_remove_queues(struct efct_nic *efct)
+{
+	int i;
+
+	for (i = 0; i < efct->rxq_count; i++) {
+		efct->type->rx_remove(&efct->rxq[i]);
+		efct->type->ev_remove(&efct->evq[efct->rxq[i].evq_index]);
+	}
+
+	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++) {
+		efct->type->tx_remove(&efct->txq[i]);
+		efct->type->ev_remove(&efct->evq[efct->txq[i].evq_index]);
+	}
+}
+
+void efct_reset_sw_stats(struct efct_nic *efct)
+{
+	struct efct_rx_queue *rxq;
+	int i;
+
+	/*Rx stats reset*/
+	for (i = 0; i < efct->rxq_count; i++) {
+		rxq = &efct->rxq[i];
+
+		rxq->n_rx_eth_crc_err = 0;
+		rxq->n_rx_ip_hdr_chksum_err = 0;
+		rxq->n_rx_tcp_udp_chksum_err = 0;
+		rxq->n_rx_sentinel_drop_count = 0;
+		rxq->n_rx_mcast_mismatch = 0;
+		rxq->n_rx_merge_events = 0;
+		rxq->n_rx_merge_packets = 0;
+		rxq->n_rx_alloc_skb_fail = 0;
+		rxq->n_rx_broadcast_drop = 0;
+		rxq->n_rx_other_host_drop = 0;
+		rxq->n_rx_nbl_empty = 0;
+		rxq->n_rx_buffers_posted = 0;
+		rxq->n_rx_rollover_events = 0;
+		rxq->n_rx_aux_pkts = 0;
+		rxq->rx_packets = 0;
+	}
+
+	/*Tx stats reset*/
+	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++) {
+		efct->txq[i].n_tx_stop_queue = 0;
+		efct->txq[i].tx_packets = 0;
+	}
+
+	/*EVQ stats reset*/
+	for (i = 0; i < (efct->rxq_count + EFCT_MAX_CORE_TX_QUEUES); i++) {
+		efct->evq[i].n_evq_time_sync_events = 0;
+		efct->evq[i].n_evq_error_events = 0;
+		efct->evq[i].n_evq_flush_events = 0;
+		efct->evq[i].n_evq_unsol_overflow = 0;
+		efct->evq[i].n_evq_unhandled_events = 0;
+	}
+	/*Resetting generic stats*/
+	atomic64_set(&efct->n_rx_sw_drops, 0);
+	atomic64_set(&efct->n_tx_sw_drops, 0);
+}
+
+int efct_mac_reconfigure(struct efct_nic *efct)
+{
+	int rc = 0;
+
+	if (efct->type->reconfigure_mac)
+		rc = efct->type->reconfigure_mac(efct);
+
+	return rc;
+}
+
+int efct_set_mac_address(struct net_device *net_dev, void *data)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	struct sockaddr *addr = data;
+	u8 *new_addr = addr->sa_data;
+	u8 old_addr[6];
+	int rc;
+
+	rc = eth_prepare_mac_addr_change(net_dev, data);
+	if (rc)
+		return rc;
+
+	ether_addr_copy(old_addr, net_dev->dev_addr); /* save old address */
+	eth_hw_addr_set(net_dev, new_addr);
+
+	/* Reconfigure the MAC */
+	mutex_lock(&efct->mac_lock);
+	rc = efct_mac_reconfigure(efct);
+	if (rc)
+		eth_hw_addr_set(net_dev, old_addr);
+	mutex_unlock(&efct->mac_lock);
+
+	return rc;
+}
+
+/* Push loopback/power/transmit disable settings to the PHY, and reconfigure
+ * the MAC appropriately. All other PHY configuration changes are pushed
+ * through efct_mcdi_phy_set_settings(), and pushed asynchronously to the MAC
+ * through efct_monitor().
+ *
+ * Callers must hold the mac_lock
+ */
+int __efct_reconfigure_port(struct efct_nic *efct)
+{
+	enum efct_phy_mode phy_mode;
+	int rc = 0;
+
+	WARN_ON(!mutex_is_locked(&efct->mac_lock));
+
+	/* Disable PHY transmit in mac level loopbacks */
+	phy_mode = efct->phy_mode;
+	if (LOOPBACK_INTERNAL(efct))
+		efct->phy_mode |= PHY_MODE_TX_DISABLED;
+	else
+		efct->phy_mode &= ~PHY_MODE_TX_DISABLED;
+
+	rc = efct_mcdi_port_reconfigure(efct);
+	if (rc)
+		efct->phy_mode = phy_mode;
+
+	return rc;
+}
+
+int efct_change_mtu(struct net_device *net_dev, int new_mtu)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int old_mtu;
+	int rc;
+
+	rc = efct_check_disabled(efct);
+	if (rc)
+		return rc;
+
+	netif_dbg(efct, drv, efct->net_dev, "changing MTU to %d\n", new_mtu);
+	//TODO is device reconfigure required?
+	mutex_lock(&efct->mac_lock);
+	old_mtu = net_dev->mtu;
+	net_dev->mtu = new_mtu;
+	rc = efct_mac_reconfigure(efct);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev, "efct_mac_reconfigure failed\n");
+		net_dev->mtu = old_mtu;
+	}
+	mutex_unlock(&efct->mac_lock);
+
+	return rc;
+}
+
+/* Hook interrupt handler(s)
+ */
+
+void efct_set_interrupt_affinity(struct efct_nic *efct)
+{
+	struct efct_device *efct_dev;
+	struct pci_dev *pci_dev;
+	u32 cpu;
+	int i;
+
+	efct_dev = efct->efct_dev;
+	pci_dev = efct->efct_dev->pci_dev;
+	for (i = 0; i < efct->max_evq_count; ++i) {
+		if (!efct->evq[i].msi.irq)
+			continue;
+		if (efct_dev->dist_layout == RX_LAYOUT_DISTRIBUTED)
+			cpu = cpumask_local_spread(efct->evq[i].msi.idx,
+						   pcibus_to_node(pci_dev->bus));
+		else
+			cpu = cpumask_local_spread(efct_dev->separated_rx_cpu,
+						   pcibus_to_node(pci_dev->bus));
+		irq_set_affinity_hint(efct->evq[i].msi.irq, cpumask_of(cpu));
+		netif_dbg(efct, ifup, efct->net_dev,
+			  "EVQ : %u IRQ : %u IDX : %u CPU : %u\n",
+			  i, efct->evq[i].msi.irq, efct->evq[i].msi.idx, cpu);
+	}
+}
+
+void efct_clear_interrupt_affinity(struct efct_nic *efct)
+{
+	int i;
+
+	for (i = 0; i < efct->max_evq_count; ++i) {
+		if (!efct->evq[i].msi.irq)
+			continue;
+		irq_set_affinity_hint(efct->evq[i].msi.irq, NULL);
+	}
+}
+
+int efct_get_phys_port_id(struct net_device *net_dev, struct netdev_phys_item_id *ppid)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	if (efct->type->get_phys_port_id)
+		return efct->type->get_phys_port_id(efct, ppid);
+	else
+		return -EOPNOTSUPP;
+}
+
+int efct_get_phys_port_name(struct net_device *net_dev, char *name, size_t len)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	if (snprintf(name, len, "p%u", efct->port_num) >= len)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void efct_stats_collector(struct work_struct *work)
+{
+	struct efct_device *efct_dev;
+	struct delayed_work *dwork;
+	struct efct_nic *efct;
+	int i;
+
+	dwork = to_delayed_work(work);
+	efct_dev = container_of(dwork, struct efct_device, stats_work);
+	for (i = 0; i < efct_dev->num_ports; i++) {
+		efct = efct_dev->efct[i];
+		efct->type->update_stats(efct, false);
+	}
+	queue_delayed_work(efct_dev->stats_wq, &efct_dev->stats_work,
+			   msecs_to_jiffies(STAT_INTERVAL_MS));
+}
+
+int efct_init_stats_wq(struct efct_device *efct_dev)
+{
+	struct pci_dev *pci_dev = efct_dev->pci_dev;
+	struct efct_nic *efct;
+	u8 bus, dev, fun;
+	int i;
+
+	bus = pci_dev->bus->number;
+	dev = PCI_SLOT(pci_dev->devfn);
+	fun = PCI_FUNC(pci_dev->devfn);
+
+	/* Create ktrhead for mac stat pulling */
+	INIT_DELAYED_WORK(&efct_dev->stats_work, efct_stats_collector);
+	efct_dev->stats_wq = alloc_ordered_workqueue("efctsc/%02hhx:%02hhx.%hhx", 0, bus, dev, fun);
+	if (!efct_dev->stats_wq) {
+		pci_err(pci_dev, "Failed to create stats workqueue\n");
+		return -EINVAL;
+	}
+
+	/* Pull initial stats */
+	for (i = 0; i < efct_dev->num_ports; i++) {
+		efct = efct_dev->efct[i];
+		efct->type->pull_stats(efct);
+		efct->type->update_stats(efct, true);
+	}
+
+	queue_delayed_work(efct_dev->stats_wq, &efct_dev->stats_work,
+			   msecs_to_jiffies(STAT_INTERVAL_MS));
+
+	return 0;
+}
+
+void efct_fini_stats_wq(struct efct_device *efct_dev)
+{
+	if (efct_dev->stats_wq) {
+		cancel_delayed_work_sync(&efct_dev->stats_work);
+		destroy_workqueue(efct_dev->stats_wq);
+		efct_dev->stats_wq = NULL;
+	}
+}
+
+int efct_filter_table_down(struct efct_nic *efct)
+{
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	struct efct_filter_spec *spec_in_table;
+	int index, rc;
+
+	if (!table)
+		return 0;
+
+	down_write(&table->lock);
+
+	for (index = 0; index < EFCT_MCDI_FILTER_TBL_ROWS; index++) {
+		spec_in_table = (struct efct_filter_spec *)table->entry[index].spec;
+		if (!spec_in_table) {
+			continue;
+		} else {
+			rc = efct_mcdi_filter_remove(efct, table->entry[index].handle);
+			if (rc) {
+				up_write(&table->lock);
+				netif_err(efct, drv, efct->net_dev,
+					  "efct_mcdi_filter_remove failed, rc: %d\n", rc);
+				return rc;
+			}
+			table->entry[index].handle = EFCT_HANDLE_INVALID;
+		}
+	}
+
+	up_write(&table->lock);
+
+	return 0;
+}
+
+int efct_filter_table_up(struct efct_nic *efct)
+{
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	struct efct_filter_spec *spec_in_table;
+	u64 handle = 0;
+	int index, rc;
+
+	if (!table)
+		return 0;
+
+	down_write(&table->lock);
+
+	for (index = 0; index < EFCT_MCDI_FILTER_TBL_ROWS; index++) {
+		spec_in_table = (struct efct_filter_spec *)table->entry[index].spec;
+		if (!spec_in_table) {
+			continue;
+		} else {
+			rc = efct_mcdi_filter_insert(efct, spec_in_table, &handle);
+			if (rc) {
+				up_write(&table->lock);
+				netif_err(efct, drv, efct->net_dev,
+					  "efct_mcdi_filter_remove failed, rc: %d\n", rc);
+				return rc;
+			}
+
+			table->entry[index].handle = handle;
+		}
+	}
+
+	up_write(&table->lock);
+
+	return 0;
+}
+
diff --git a/drivers/net/ethernet/amd/efct/efct_common.h b/drivers/net/ethernet/amd/efct/efct_common.h
new file mode 100644
index 000000000000..c85bc3a9693d
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_common.h
@@ -0,0 +1,134 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_COMMON_H
+#define EFCT_COMMON_H
+
+#include <linux/workqueue.h>
+#include <linux/rwsem.h>
+#include "efct_driver.h"
+
+struct efct_func_ctl_window {
+	bool valid;
+	u32 bar;
+	u64 offset;
+};
+
+struct queue_reset_work {
+	struct work_struct work;
+	struct efct_nic *efct;
+	bool is_txq;
+	int qid;
+};
+
+#define IP4_ADDR_MASK	((__force __be32)~0)
+#define PORT_MASK		((__force __be16)~0)
+#define MULTICAST_DST_MASK htonl(0xf0000000)
+#define MULTICAST_ADDR_START htonl(0xe0000000)
+#define EFCT_HANDLE_INVALID 0xFFFFFFFFFFFFFFFF
+
+struct efct_filter_spec {
+	u32 match_fields;
+	u64 queue_id;
+	__be16	ether_type;
+	__be32 dst_ip;
+	__be16	dst_port;
+	u8	ip_proto;
+};
+
+struct efct_mcdi_filter_table {
+	struct rw_semaphore lock; /* Protects entries */
+	struct {
+		unsigned long spec;     /* pointer to spec */
+		u64 handle;	     /* firmware handle */
+		u64 ref_cnt; /*ref count for clients*/
+	} *entry;
+};
+
+/* Global Resources */
+int efct_nic_alloc_buffer(struct efct_nic *efct, struct efct_buffer *buffer,
+			  u32 len, gfp_t gfp_flags);
+void efct_nic_free_buffer(struct efct_nic *efct, struct efct_buffer *buffer);
+
+static inline bool efct_nic_hw_unavailable(struct efct_nic *efct)
+{
+	if (efct->type->hw_unavailable)
+		return efct->type->hw_unavailable(efct);
+	return false;
+}
+
+static inline bool efct_nic_mcdi_ev_pending(struct efct_nic *efct, u16 index)
+{
+	return efct->type->ev_mcdi_pending(efct, index);
+}
+
+static inline bool efct_nic_has_dynamic_sensors(struct efct_nic *efct)
+{
+	if (efct->type->has_dynamic_sensors)
+		return efct->type->has_dynamic_sensors(efct);
+
+	return false;
+}
+
+int efct_init_io(struct efct_device *efct_dev,
+		 int bar, dma_addr_t dma_mask, u32 mem_map_size);
+void efct_fini_io(struct efct_device *efct_dev);
+int efct_init_struct(struct efct_nic *efct);
+int efct_map_membase(struct efct_nic *efct, struct efct_func_ctl_window *fcw, u8 port_id);
+void efct_unmap_membase(struct efct_nic *efct);
+int efct_probe_common(struct efct_nic *efct);
+void efct_remove_common(struct efct_nic *efct);
+void efct_schedule_reset(struct efct_nic *efct, enum reset_type type);
+int efct_create_reset_workqueue(void);
+void efct_destroy_reset_workqueue(void);
+void efct_flush_reset_workqueue(void);
+void efct_reset_sw_stats(struct efct_nic *efct);
+void efct_set_evq_names(struct efct_nic *efct);
+void efct_link_status_changed(struct efct_nic *efct);
+int efct_mac_reconfigure(struct efct_nic *efct);
+int efct_set_mac_address(struct net_device *net_dev, void *data);
+int __efct_reconfigure_port(struct efct_nic *efct);
+int efct_reset(struct efct_nic *efct, enum reset_type method);
+void efct_schedule_queue_reset(struct efct_nic *efct, bool is_txq, int qid);
+int efct_change_mtu(struct net_device *net_dev, int new_mtu);
+void efct_set_interrupt_affinity(struct efct_nic *efct);
+void efct_clear_interrupt_affinity(struct efct_nic *efct);
+int efct_fill_spec(struct efct_nic *efct, const struct ethtool_rx_flow_spec *rule,
+		   struct efct_filter_spec *spec);
+int efct_delete_rule(struct efct_nic *efct, u32 id);
+int efct_init_stats_wq(struct efct_device *efct_dev);
+void efct_fini_stats_wq(struct efct_device *efct_dev);
+int efct_get_phys_port_id(struct net_device *net_dev, struct netdev_phys_item_id *ppid);
+int efct_get_phys_port_name(struct net_device *net_dev, char *name, size_t len);
+int efct_filter_table_down(struct efct_nic *efct);
+int efct_filter_table_up(struct efct_nic *efct);
+static inline bool efct_filter_spec_equal(const struct efct_filter_spec *left,
+					  const struct efct_filter_spec *right)
+{
+	return memcmp(&left->dst_ip, &right->dst_ip,
+		      sizeof(struct efct_filter_spec) -
+		      offsetof(struct efct_filter_spec, dst_ip)) == 0;
+}
+
+static inline int efct_check_disabled(struct efct_nic *efct)
+{
+	if (efct->state == STATE_DISABLED) {
+		netif_err(efct, drv, efct->net_dev,
+			  "device is disabled due to earlier errors\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+#define EFCT_ASSERT_RESET_SERIALISED(efct) \
+	do {(typeof(_efct) (efct) = (_efct); \
+		if ((efct)->state != STATE_UNINIT && (efct)->state != STATE_PROBED) \
+			ASSERT_RTNL(); \
+	} while (0))
+
+#endif
+
diff --git a/drivers/net/ethernet/amd/efct/efct_driver.h b/drivers/net/ethernet/amd/efct/efct_driver.h
new file mode 100644
index 000000000000..a8d396ecee49
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_driver.h
@@ -0,0 +1,770 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_DRIVER_H
+#define EFCT_DRIVER_H
+
+/* Uncomment this to enable output from netif_vdbg
+ * #define VERBOSE_DEBUG 1
+ */
+
+#include <linux/device.h>
+#include <linux/ethtool.h>
+#include <linux/if_vlan.h>
+#include <linux/mii.h>
+#include <linux/net_tstamp.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+
+#include "efct_enum.h"
+#include "efct_bitfield.h"
+
+/**************************************************************************
+ *
+ * Build definitions
+ *
+ **************************************************************************/
+
+#define EFCT_DRIVER_VERSION	"1.2.5.0"
+
+/**************************************************************************
+ *
+ * Efx data structures
+ *
+ **************************************************************************/
+#define EFCT_MAX_RX_QUEUES 16
+#define EFCT_MAX_TX_QUEUES 32
+#define EFCT_MAX_EV_QUEUES 48
+#define EFCT_MAX_CORE_TX_QUEUES 1
+#define EFCT_EV_UNSOL_MAX 64
+#define EFCT_EV_CONSUMED_IN_OVERFLOW 1
+#define EFCT_EV_UNSOL_GRANT_UPDATE 16
+#define EFCT_EV_UNSOL_OVERFLOW_CLEAR 1
+#define EFCT_DEFAULT_QUEUE 0
+#define EFCT_MSIX_PER_PORT 32
+
+#define EFCT_IRQ_ADAPT_LOW_THRESH_VAL 8000
+#define EFCT_IRQ_ADAPT_HIGH_THRESH_VAL 16000
+#define EFCT_IRQ_ADAPT_IRQS 1000
+//TODO Setting the default moderation Rx/Tx to 0 for performance
+#define EFCT_IRQ_RX_MOD_DEFAULT_VAL 0
+#define EFCT_IRQ_TX_MOD_DEFAULT_VAL 0
+
+/* Flush event wait timeout */
+#define EFCT_MAX_FLUSH_TIME 5000
+
+/* Maximum possible MTU the driver supports */
+#define EFCT_MAX_MTU (1960)
+/* Minimum MTU */
+#define EFCT_MIN_MTU 64
+/* Default CPU ID for separated receive queue layout */
+#define DEFAULT_SEPARATED_RX_CPU 0
+
+#define MAX_TX_BUFFERS	256
+#define MAX_PORTS 2
+#define EFCT_RX_BUF_SIZE_MULTIPLIER 4096
+#define EFCT_PORT_LEN 0x62000
+#define EFCT_PORT_OFFSET 0x80000
+#define EFCT_MAX_VERSION_INFO_LEN 256
+#define EFCT_FAILURE	-1
+#define EFCT_MCDI_FILTER_TBL_ROWS 256
+
+#define STRING_TABLE_LOOKUP(val, member) \
+	((val) < member ## _max) && member ## _names[val] ? member ## _names[val] : "(invalid)"
+
+/**
+ * enum reset_type - reset types
+ *
+ * %RESET_TYPE_ALL, %RESET_TYPE_WORLD and
+ * %RESET_TYPE_DISABLE specify the method/scope of the reset.  The
+ * other valuesspecify reasons, which efct_schedule_reset() will choose
+ * a method for.
+ *
+ * Reset methods are numbered in order of increasing scope.
+ *
+ * @RESET_TYPE_ALL: Reset datapath, MAC and PHY
+ * @RESET_TYPE_WORLD: Reset as much as possible
+ * unsuccessful.
+ * @RESET_TYPE_DATAPATH: Reset datapath only.
+ * @RESET_TYPE_MC_BIST: MC entering BIST mode.
+ * @RESET_TYPE_DISABLE: Reset datapath, MAC and PHY; leave NIC disabled
+ * @RESET_TYPE_TX_WATCHDOG: reset due to TX watchdog
+ * @RESET_TYPE_MC_FAILURE: MC reboot/assertion
+ * @RESET_TYPE_MCDI_TIMEOUT: MCDI timeout.
+ */
+enum reset_type {
+	RESET_TYPE_ALL,
+	RESET_TYPE_WORLD,
+	RESET_TYPE_DATAPATH,
+	RESET_TYPE_MC_BIST,
+	RESET_TYPE_DISABLE,
+	RESET_TYPE_MAX_METHOD,
+	RESET_TYPE_TX_WATCHDOG,
+	RESET_TYPE_MC_FAILURE,
+	/* RESET_TYPE_MCDI_TIMEOUT is actually a method, not
+	 * a reason, but it doesn't fit the scope hierarchy (it's not well-
+	 * ordered by inclusion)
+	 * We encode this by having its enum values be greater than
+	 * RESET_TYPE_MAX_METHOD.  This also prevents issuing it with
+	 * efct_ioctl_reset
+	 */
+	RESET_TYPE_MCDI_TIMEOUT,
+	RESET_TYPE_MAX,
+};
+
+#define MIN_AUX_IRQ 0
+
+extern const struct ethtool_ops efct_ethtool_ops;
+
+/**
+ * struct efct_buffer - A general-purpose DMA buffer
+ * @addr: host base address of the buffer
+ * @dma_addr: DMA base address of the buffer
+ * @len: Buffer length, in bytes
+ * @sentinel: sentinel value
+ *
+ * The NIC uses these buffers for its interrupt status registers and
+ * MAC stats dumps.
+ */
+struct efct_buffer {
+	void *addr;
+	dma_addr_t dma_addr;
+	u32 len;
+	bool sentinel;
+};
+
+#define CT_DEFAULT_THRESHOLD    0xFF
+#define MAX_CT_THRESHOLD_VALUE  (CT_DEFAULT_THRESHOLD * 64)
+
+#define MAX_TX_MERGE_TIMEOUT_NS_VALUE 0x7e00
+#define MAX_RX_MERGE_TIMEOUT_NS_VALUE 0x7e00
+#define EV_TIMER_GRANULARITY_NS 0x200
+
+struct efct_tx_buffer {
+	struct sk_buff *skb;
+};
+
+struct efct_tx_queue {
+	/* TXQ Identifier */
+	u32 txq_index;
+	/* EVQ Index */
+	u32 evq_index;
+	/* Queue reset */
+	bool is_resetting;
+	/*DP_TX_PACKET_FIFO_SIZE Design param*/
+	u32 fifo_size;
+	/*DP_TX_CTPIO_APERTURE_SIZE Design param*/
+	u32 aperture_qword;
+	u8 label;
+	/*Number of entries*/
+	u32 num_entries;
+	/* efct_nic structure */
+	struct efct_nic *efct;
+	/* The networking core TX queue structure */
+	struct netdev_queue *core_txq;
+	/* Mapped address of CTPIO Windows base */
+	u64 __iomem *piobuf;
+	/* Current offset within CTPIO windows.
+	 * When new packet comes, driver starts writing
+	 * into piobuf + offset memory in 64 bits chunk.
+	 * New offset is modulo of CTPIO window size
+	 * If CTPIO is always going to be 4K stride then
+	 * How about bitfield entry of 12 bits?
+	 * This would automatically rollover?
+	 */
+	u32 piobuf_offset;
+	/* When packet is added, this sequence is incremented */
+	u8 added_sequence;
+	/* When packet transfer is completed, this sequence is incremented from ISR */
+	u8 completed_sequence;
+	/* Below parameters help to identify free space within CTPIO window */
+	/* Number of bytes in FIFO */
+	atomic_t inuse_fifo_bytes;
+	/* Number of packets in FIFO to track seq */
+	atomic_t inflight_pkts;
+	/* CT threshold */
+	u8 ct_thresh;
+	/* Transmit packet metadata */
+	struct efct_tx_buffer tx_buffer[MAX_TX_BUFFERS];
+	/* Number of packets completed to report to BQL */
+	u32 pkts;
+	/* Number of bytes completed to report to BQL */
+	u32 bytes;
+	/* Software stats */
+	u64 tx_packets;
+	u64 n_tx_stop_queue;
+};
+
+struct efct_driver_buffer {
+	/* Buffer info */
+	struct efct_buffer dma_buffer;
+	/* Next pointer */
+	struct efct_driver_buffer *next;
+};
+
+/* Default receivee buffers per queue */
+#define RX_BUFFS_PER_QUEUE	4
+/* Maximum driver buffers */
+#define RX_MAX_DRIVER_BUFFS	 12
+/* Lower water mark for NBL */
+#define RX_MIN_DRIVER_BUFFS 2
+/* Huge page size */
+#define HUGE_PAGE_SZ BIT(21)      /* 2M Huge Page Size */
+
+struct efct_driver_buffer_list {
+	/* Array of driver buffers */
+	struct efct_driver_buffer db[RX_MAX_DRIVER_BUFFS];
+	/* free list */
+	struct efct_driver_buffer *free_list;
+};
+
+struct efct_nic_buffer {
+	/* DMA buffer Info */
+	struct efct_buffer dma_buffer;
+	/* Parent pool */
+	unsigned char is_dbl;
+	/* Buffer ID */
+	int id;
+};
+
+/* NIC QUEUE LEN = RX_MAX_DRIVER_BUFFS + 1 space for rollover + 1 for queue ds */
+#define NIC_BUFFS_PER_QUEUE	 (RX_MAX_DRIVER_BUFFS + 2)
+
+struct efct_nic_buffer_list {
+	/* Array of receive buffers */
+	struct efct_nic_buffer nb[NIC_BUFFS_PER_QUEUE];
+	/* In flight buffer count */
+	u32 active_nic_buffs;
+	/* HW Index or consumer index.
+	 * This points to the current receive buffer where HW has posted packets
+	 */
+	unsigned char head_index;
+	/* SW Index or producer index.
+	 * Driver refills the queue from this index.
+	 */
+	unsigned char tail_index;
+	/* Metadata offset within buffer */
+	u32 meta_offset;
+	/* Prev metadata offset within buffer */
+	u32 prev_meta_offset;
+	/* Frame location bit from packet start */
+	u32 frame_offset_fixed;
+	/* Monotonic buffer sequence number, used to refer to packets over a longer
+	 * period than head_index
+	 */
+	u32 seq_no;
+};
+
+struct efct_rx_queue {
+	/* NUmber of filters added to this queue */
+	u32 filter_count;
+	/* Receive queue identifier */
+	u32 index;
+	/* EVQ Index */
+	u32 evq_index;
+	/* CPU mapping.
+	 * Is this needed. We can keep one to one mapping using index variable
+	 */
+	/* Queue reset */
+	bool is_resetting;
+	/* Queue enable */
+	bool enable;
+	/* Number of receive buffs */
+	u16 num_rx_buffs;
+	/* Number of entries */
+	u32 num_entries;
+	u16 pkt_stride;
+	u8 label;
+	u32 cpu;
+	/* efct_nic structure */
+	struct efct_nic *efct;
+	/* driver buffer size */
+	u32 buffer_size;
+	/* Receive queue base address within BAR */
+	void __iomem *receive_base;
+	/* NIC buffer list */
+	struct efct_nic_buffer_list nbl;
+	/* Driver buffer list */
+	struct efct_driver_buffer_list dbl;
+	/* Software stats */
+	u64 n_rx_eth_crc_err;
+	u64 n_rx_ip_hdr_chksum_err;
+	u64 n_rx_tcp_udp_chksum_err;
+	u64 n_rx_sentinel_drop_count;
+	u64 n_rx_mcast_mismatch;
+	u64 n_rx_merge_events;
+	u64 n_rx_merge_packets;
+	u64 n_rx_alloc_skb_fail;
+	u64 n_rx_broadcast_drop;
+	u64 n_rx_other_host_drop;
+	u64 n_rx_nbl_empty;
+	u64 n_rx_buffers_posted;
+	u64 n_rx_rollover_events;
+	u64 n_rx_aux_pkts;
+	u64 rx_packets;
+};
+
+enum nic_state {
+	STATE_UNINIT = 0,	/* device being probed/removed */
+	STATE_PROBED,		/* hardware probed */
+	STATE_NET_DOWN,		/* netdev registered */
+	STATE_NET_UP,		/* ready for traffic */
+	STATE_DISABLED,		/* device disabled due to hardware errors */
+
+	STATE_RECOVERY = 0x100,/* recovering from PCI error */
+	STATE_FROZEN = 0x200,	/* frozen by power management */
+};
+
+static inline bool efct_net_active(enum nic_state state)
+{
+	return ((state == STATE_NET_UP) || (state == STATE_NET_DOWN));
+}
+
+enum driver_dist_layout {
+	RX_LAYOUT_DISTRIBUTED = 0,
+	RX_LAYOUT_SEPARATED,
+};
+
+/**
+ * enum efct_phy_mode - PHY operating mode flags
+ * @PHY_MODE_NORMAL: on and should pass traffic
+ * @PHY_MODE_TX_DISABLED: on with TX disabled
+ * @PHY_MODE_LOW_POWER: set to low power through MDIO
+ * @PHY_MODE_OFF: switched off through external control
+ * @PHY_MODE_SPECIAL: on but will not pass traffic
+ */
+
+enum efct_phy_mode {
+	PHY_MODE_NORMAL		= 0, /*on and should pass traffic*/
+	PHY_MODE_TX_DISABLED	= 1, /* on with TX disabled*/
+	PHY_MODE_LOW_POWER	= 2, /* set to low power through MDIO */
+	PHY_MODE_OFF		= 4, /* switched off through external control */
+	PHY_MODE_SPECIAL	= 8, /* on but will not pass traffic*/
+};
+
+/* Forward declaration */
+struct efct_nic;
+
+/**
+ * struct efct_link_state - Current state of the link
+ * @up: Link is up
+ * @fd: Link is full-duplex
+ * @fc: Actual flow control flags
+ * @speed: Link speed (Mbps)
+ * @ld_caps: Local device capabilities
+ * @lp_caps: Link partner capabilities
+ */
+struct efct_link_state {
+	bool up;
+	bool fd;
+	u8 fc;
+	u32 speed;
+	u32 ld_caps;
+	u32 lp_caps;
+};
+
+static inline bool efct_link_state_equal(const struct efct_link_state *left,
+					 const struct efct_link_state *right)
+{
+	return left->up == right->up && left->fd == right->fd &&
+		left->fc == right->fc && left->speed == right->speed;
+}
+
+enum efct_led_mode {
+	EFCT_LED_OFF	= 0,
+	EFCT_LED_ON	= 1,
+	EFCT_LED_DEFAULT	= 2
+};
+
+static inline bool efct_phy_mode_disabled(enum efct_phy_mode mode)
+{
+	return !!(mode & ~PHY_MODE_TX_DISABLED);
+}
+
+/**
+ * struct efct_hw_stat_desc - Description of a hardware statistic
+ * @name: Name of the statistic as visible through ethtool, or %NULL if
+ *	it should not be exposed
+ * @dma_width: Width in bits (0 for non-DMA statistics)
+ * @offset: Offset within stats (ignored for non-DMA statistics)
+ */
+struct efct_hw_stat_desc {
+	const char *name;
+	u16 dma_width;
+	u16 offset;
+};
+
+/* Efx Error condition statistics */
+struct efct_nic_errors {
+	atomic_t missing_event;
+	atomic_t rx_reset;
+	atomic_t rx_desc_fetch;
+	atomic_t tx_desc_fetch;
+	atomic_t spurious_tx;
+};
+
+enum evq_type {
+	EVQ_T_NONE,
+	EVQ_T_RX,
+	EVQ_T_TX,
+	EVQ_T_AUX
+};
+
+struct msix_info {
+		unsigned short irq;
+		unsigned short idx;
+		char name[IFNAMSIZ + 6];
+};
+
+struct efct_ev_queue {
+	/* Event queue identifier */
+	u32 index;
+	/* Max entries */
+	u32 entries;
+	/* MSIx IRQ Number */
+	struct msix_info msi;
+	/* Event queue base address within BAR */
+	void __iomem *evq_base;
+	/* efct_nic structure */
+	struct efct_nic *efct;
+	/* Net device used with NAPI */
+	struct net_device *napi_dev;
+	/* NAPI control structure */
+	struct napi_struct napi;
+	/* phase bit */
+	bool evq_phase;
+	/* DMA ring */
+	struct efct_buffer buf;
+	/* Event unsolicated consumer index */
+	u32 unsol_consumer_index;
+	/* Event queue consumer index */
+	u32 consumer_index;
+	u32 irq_moderation_ns;
+	/* Eventy queue type Rx/Tx */
+	enum evq_type type;
+	/* Maximum number of queues associated for this evq */
+	unsigned char queue_count;
+	/* Associated queue */
+	void *queue;
+	/* Number of IRQs since last adaptive moderation decision */
+	u32 irq_count;
+	/* IRQ moderation score */
+	u32 irq_mod_score;
+	/* Threshold score for reducing IRQ moderation */
+	u32 irq_adapt_low_thresh;
+	/* Threshold score for increasing IRQ moderation */
+	u32 irq_adapt_high_thresh;
+	/* Number of IRQs per IRQ moderation adaptation */
+	u32 irq_adapt_irqs;
+	/* Transmit event merge timeout to configure, in nanoseconds */
+	u32 tx_merge_timeout_ns;
+	/* Receive event merge timeout to configure, in nanoseconds */
+	u32 rx_merge_timeout_ns;
+	/* Last CPU to handle interrupt or test event */
+	int event_test_cpu;
+	int event_test_napi;
+	/* Software stats */
+	u64 n_evq_time_sync_events;
+	u64 n_evq_error_events;
+	u64 n_evq_flush_events;
+	u64 n_evq_unsol_overflow;
+	u64 n_evq_unhandled_events;
+	/*unsolicited credit grant*/
+	u16 unsol_credit;
+};
+
+struct efct_nic {
+	/* The following fields should be written very rarely */
+	char name[IFNAMSIZ];
+	const struct efct_nic_type *type;
+	/* The Network device */
+	struct net_device *net_dev;
+	void *nic_data;
+	void  *phy_data;
+	enum efct_phy_mode phy_mode;
+	bool phy_power_force_off;
+	enum efct_loopback_mode loopback_mode;
+	u64 loopback_modes;
+	struct notifier_block netdev_notifier;
+	u32 datapath_caps;
+	u32 datapath_caps2;
+	/*used in MCDI code*/
+	unsigned long mcdi_buf_use;
+	bool mc_bist_for_other_fn;
+	enum nic_state state;
+	/* Nic State lock */
+	struct mutex state_lock;
+	struct rw_semaphore hpl_mutation_lock;
+	struct efct_mcdi_data *mcdi;
+	struct efct_buffer mcdi_buf;
+	struct efct_nic_errors errors;
+	u32 int_error_count;
+	unsigned long int_error_expire;
+	/* The efct physical function device data structure */
+	struct efct_device *efct_dev;
+	/* Port number or port identifier */
+	u8 port_num;
+	/*MTU size*/
+	u32 mtu;
+	/* link_advertising: Autonegotiation advertising flags */
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(link_advertising);
+	/* Scheduled reset workitem */
+	struct work_struct reset_work;
+	/* Bitmask for pending resets */
+	unsigned long reset_pending;
+	unsigned long last_reset;
+	u32 reset_count;
+	/* Last seen MC warm boot count */
+	int mc_warm_boot_count;
+
+	/**
+	 * mac_lock: MAC access lock. Protects @port_enabled, @link_up, @phy_mode,
+	 * efct_monitor() and efct_mac_work()
+	 */
+	struct mutex mac_lock;
+
+	/* Total active queues tx+rx */
+	atomic_t active_queues;
+	/* wait queue used to wait for flush completions */
+	wait_queue_head_t flush_wq;
+	/* Active event queue count */
+	u8 max_evq_count;
+	/* Active receive queue count */
+	u8 rxq_count;
+	/* Active transmit queue count */
+	u8 max_txq_count;
+	/* Tx ct_threshhold */
+	u8 ct_thresh;
+	u32 fc_disable;
+	int last_irq_cpu;
+	unsigned long evq_active_mask;
+	unsigned long rxq_active_mask;
+	unsigned long txq_active_mask;
+	struct efct_link_state link_state;
+	u32 n_link_state_changes;
+	/* Interrupt timer maximum value, in nanoseconds */
+	u32 timer_max_ns;
+	u32 timer_quantum_ns;
+	u32 msg_enable;
+	/* Array of event queue structure */
+	struct efct_ev_queue evq[EFCT_MAX_EV_QUEUES];
+	/* Array of receive queue structure */
+	struct efct_rx_queue rxq[EFCT_MAX_RX_QUEUES];
+	/* Array of transmit queue structure */
+	struct efct_tx_queue txq[EFCT_MAX_TX_QUEUES];
+	u32 port_base;
+	void __iomem *membase;
+	/* Base address of write-combining mapping of the memory BAR */
+	void __iomem *wc_membase;
+	netdev_features_t fixed_features;
+	netdev_features_t hw_features;
+	/* MC MAC stats buffer */
+	__le64 *mc_mac_stats;
+	__le64 *mc_initial_stats;
+	u16 num_mac_stats;
+	bool stats_enabled;
+	/* Software rx drop count */
+	atomic64_t n_rx_sw_drops;
+	/* Software tx drop count */
+	atomic64_t n_tx_sw_drops;
+
+	bool irq_rx_adaptive;
+	/* wanted_fc: Wanted flow control flags */
+	u8 wanted_fc;
+	u32 stats_period_ms;
+	/* Params required for IRQ Moderation */
+	u32 irq_mod_step_ns;
+	u32 irq_rx_moderation_ns;
+	// ethtool stats lock
+	spinlock_t stats_lock;
+	bool stats_initialised;
+	/* Mutex for serializing firmware reflash operations.*/
+	struct mutex reflash_mutex;
+	struct efct_mcdi_filter_table *filter_table;
+};
+
+struct design_params {
+	/* stride between entries in receive window */
+	u32 rx_stride;
+	/* stride between entries in event queue window */
+	u32 evq_stride;
+	/* stride between entries in CTPIO window */
+	u32 ctpio_stride;
+	/* Length of each receive buffer */
+	u32 rx_buffer_len;
+	/* Maximum Rx queues available */
+	u32 rx_queues;
+	/* Maximum Tx apertures available */
+	u32 tx_apertures;
+	/* Maximum number of receive buffers can be posted */
+	u32 rx_buf_fifo_size;
+	/* Fixed offset to the frame */
+	u32 frame_offset_fixed;
+	/* Receive metadata length */
+	u32 rx_metadata_len;
+	/* Largest window of reordered writes to the CTPIO */
+	u32 tx_max_reorder;
+	/* CTPIO aperture length */
+	u32 tx_aperture_size;
+	/* Size of packet FIFO per CTPIO aperture */
+	u32 tx_fifo_size;
+	/* partial time stamp in sub nano seconds */
+	u32 ts_subnano_bit;
+	/* Width of sequence number in EVQ_UNSOL_CREDIT_GRANT register */
+	u32 unsol_credit_seq_mask;
+	/* L4 csm feilds */
+	u32 l4_csum_proto;
+	/* MAx length of frame data when LEN_ERR indicates runt*/
+	u32 max_runt;
+	/* Event queue sizes */
+	u32 evq_sizes;
+	/* Number of event queues */
+	u32 num_evq;
+};
+
+struct efct_device {
+	struct design_params params;
+	unsigned char num_ports;
+	enum driver_dist_layout dist_layout;
+	u8 separated_rx_cpu;
+	struct pci_dev *pci_dev;
+	/*spin lock for biu*/
+	spinlock_t biu_lock;
+	u64 max_dma_mask;
+	u32 mem_bar;
+	u32 reg_base;
+	/* Memory BAR value as physical address */
+	resource_size_t membase_phys;
+	void __iomem *membase;
+	/* BAR length */
+	resource_size_t bar_len;
+	bool mcdi_logging;
+	struct efct_nic *efct[MAX_PORTS];
+	/*IRQ vectors per port*/
+	u16 vec_per_port;
+	struct msix_entry *xentries;
+	struct delayed_work stats_work;
+	struct workqueue_struct *stats_wq;
+};
+
+static inline int validate_evq_size(struct efct_nic *efct, int size)
+{
+	int evqsizes = 0;
+
+	if (!is_power_of_2(size))
+		return -EINVAL;
+	evqsizes = efct->efct_dev->params.evq_sizes << 7;
+	/*Since size is power of 2, Only 1 bit will be set in 'size'*/
+	return (evqsizes & size) == size;
+}
+
+static inline struct efct_device *efct_nic_to_device(struct efct_nic *efct)
+{
+	return efct->efct_dev;
+}
+
+static inline struct efct_nic *efct_netdev_priv(struct net_device *dev)
+{
+	return netdev_priv(dev);
+}
+
+static inline int efct_dev_registered(struct efct_nic *efct)
+{
+	return efct->net_dev->reg_state == NETREG_REGISTERED;
+}
+
+static inline u32 efct_port_num(struct efct_nic *efct)
+{
+	return efct->port_num;
+}
+
+static inline bool efct_xmit_with_hwtstamp(struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP;
+}
+
+struct efct_nic_type {
+	u32 (*mem_bar)(struct efct_nic *efct);
+	u32 (*mem_map_size)(struct efct_nic *efct);
+	int (*probe)(struct efct_nic *efct);
+	void (*remove)(struct efct_nic *efct);
+	int (*dimension_resources)(struct efct_nic *efct);
+	void (*free_resources)(struct efct_nic *efct);
+	int (*net_alloc)(struct efct_nic *efct);
+	void (*net_dealloc)(struct efct_nic *efct);
+	bool (*hw_unavailable)(struct efct_nic *efct);
+	enum reset_type (*map_reset_reason)(enum reset_type reason);
+	int (*map_reset_flags)(u32 *flags);
+	int (*reset)(struct efct_nic *efct, enum reset_type method);
+	int (*reconfigure_port)(struct efct_nic *efct);
+	int (*reconfigure_mac)(struct efct_nic *efct);
+	bool (*check_mac_fault)(struct efct_nic *efct);
+	void (*mcdi_request)(struct efct_nic *efct, u8 bufid,
+			     const union efct_dword *hdr, size_t hdr_len,
+			     const union efct_dword *sdu, size_t sdu_len);
+	bool (*mcdi_poll_response)(struct efct_nic *efct, u8 bufid);
+	void (*mcdi_read_response)(struct efct_nic *efct,
+				   u8 bufid,
+				   union efct_dword *pdu,
+				   size_t pdu_offset,
+				   size_t pdu_len);
+	int (*mcdi_poll_reboot)(struct efct_nic *efct);
+	void (*mcdi_record_bist_event)(struct efct_nic *efct);
+	int (*mcdi_poll_bist_end)(struct efct_nic *efct);
+	void (*mcdi_reboot_detected)(struct efct_nic *efct);
+	bool (*mcdi_get_buf)(struct efct_nic *efct, u8 *bufid);
+	void (*mcdi_put_buf)(struct efct_nic *efct, u8 bufid);
+	bool (*ev_mcdi_pending)(struct efct_nic *efct, u16 index);
+	int (*ev_probe)(struct efct_nic *efct, u32 index, u32 size);
+	int (*ev_init)(struct efct_ev_queue *eventq);
+	void (*ev_remove)(struct efct_ev_queue *eventq);
+	void (*ev_fini)(struct efct_ev_queue *eventq);
+	void (*ev_purge)(struct efct_ev_queue *eventq);
+	int (*ev_process)(struct efct_ev_queue *evq, int quota);
+	int (*tx_probe)(struct efct_nic *efct, u32 evq_index, int txq_index);
+	int (*tx_init)(struct efct_tx_queue *tx_queue);
+	void (*tx_remove)(struct efct_tx_queue *tx_queue);
+	void (*tx_fini)(struct efct_tx_queue *tx_queue);
+	void (*tx_purge)(struct efct_tx_queue *tx_queue);
+	int (*rx_probe)(struct efct_nic *efct, u16 index, u16 evq_index);
+	int (*rx_init)(struct efct_rx_queue *rx_queue);
+	void (*rx_remove)(struct efct_rx_queue *rx_queue);
+	void (*rx_fini)(struct efct_rx_queue *rx_queue);
+	void (*rx_purge)(struct efct_rx_queue *rx_queue);
+	u32 (*mcdi_rpc_timeout)(struct efct_nic *efct, u32 cmd);
+	size_t (*describe_stats)(struct efct_nic *efct, u8 *names);
+	void (*update_stats)(struct efct_nic *efct, bool force);
+	void (*pull_stats)(struct efct_nic *efct);
+	irqreturn_t (*irq_handle_msix)(int irq, void *dev_id);
+	u32 (*check_caps)(const struct efct_nic *efct, u8 flag, u32 offset);
+	bool (*has_dynamic_sensors)(struct efct_nic *efct);
+	int (*get_phys_port_id)(struct efct_nic *efct, struct netdev_phys_item_id *ppid);
+	int (*irq_test_generate)(struct efct_nic *efct);
+	void (*ev_test_generate)(struct efct_ev_queue *evq);
+	int mcdi_max_ver;
+	u64 max_dma_mask;
+};
+
+/* Pseudo bit-mask flow control field */
+#define EFCT_FC_RX   FLOW_CTRL_RX
+#define EFCT_FC_TX   FLOW_CTRL_TX
+#define EFCT_FC_AUTO 4
+#define EFCT_FC_OFF 0
+
+/**
+ * EFCT_MAX_FRAME_LEN - calculate maximum frame length
+ *
+ * This calculates the maximum frame length that will be used for a
+ * given MTU.  The frame length will be equal to the MTU plus a
+ * constant amount of header space. This is the quantity
+ * that the net driver will program into the MAC as the maximum frame
+ * length.
+ */
+#define EFCT_MAX_FRAME_LEN(mtu) \
+	((mtu) + ETH_HLEN + VLAN_HLEN + 4/* FCS */)
+
+#endif /* EFCT_DRIVER_H */
diff --git a/drivers/net/ethernet/amd/efct/efct_enum.h b/drivers/net/ethernet/amd/efct/efct_enum.h
new file mode 100644
index 000000000000..08c773b5c694
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_enum.h
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_ENUM_H
+#define EFCT_ENUM_H
+
+/**
+ * enum efct_loopback_mode - loopback modes
+ * @LOOPBACK_NONE: no loopback
+ * @LOOPBACK_DATA: data path loopback
+ * @LOOPBACK_GMAC: loopback within GMAC
+ * @LOOPBACK_XGMII: loopback after XMAC
+ * @LOOPBACK_XGXS: loopback within BPX after XGXS
+ * @LOOPBACK_XAUI: loopback within BPX before XAUI serdes
+ * @LOOPBACK_GMII: loopback within BPX after GMAC
+ * @LOOPBACK_SGMII: loopback within BPX within SGMII
+ * @LOOPBACK_XGBR: loopback within BPX within XGBR
+ * @LOOPBACK_XFI: loopback within BPX before XFI serdes
+ * @LOOPBACK_XAUI_FAR: loopback within BPX after XAUI serdes
+ * @LOOPBACK_GMII_FAR: loopback within BPX before SGMII
+ * @LOOPBACK_SGMII_FAR: loopback within BPX after SGMII
+ * @LOOPBACK_XFI_FAR: loopback after XFI serdes
+ * @LOOPBACK_GPHY: loopback within 1G PHY at unspecified level
+ * @LOOPBACK_PHYXS: loopback within 10G PHY at PHYXS level
+ * @LOOPBACK_PCS: loopback within 10G PHY at PCS level
+ * @LOOPBACK_PMAPMD: loopback within 10G PHY at PMAPMD level
+ * @LOOPBACK_XPORT: cross port loopback
+ * @LOOPBACK_XGMII_WS: wireside loopback excluding XMAC
+ * @LOOPBACK_XAUI_WS: wireside loopback within BPX within XAUI serdes
+ * @LOOPBACK_XAUI_WS_FAR: wireside loopback within BPX including XAUI serdes
+ * @LOOPBACK_XAUI_WS_NEAR: wireside loopback within BPX excluding XAUI serdes
+ * @LOOPBACK_GMII_WS: wireside loopback excluding GMAC
+ * @LOOPBACK_XFI_WS: wireside loopback excluding XFI serdes
+ * @LOOPBACK_XFI_WS_FAR: wireside loopback including XFI serdes
+ * @LOOPBACK_PHYXS_WS: wireside loopback within 10G PHY at PHYXS level
+ */
+/* Please keep up-to-date w.r.t the following two #defines */
+enum efct_loopback_mode {
+	LOOPBACK_NONE = 0,
+	LOOPBACK_DATA = 1,
+	LOOPBACK_GMAC = 2,
+	LOOPBACK_XGMII = 3,
+	LOOPBACK_XGXS = 4,
+	LOOPBACK_XAUI = 5,
+	LOOPBACK_GMII = 6,
+	LOOPBACK_SGMII = 7,
+	LOOPBACK_XGBR = 8,
+	LOOPBACK_XFI = 9,
+	LOOPBACK_XAUI_FAR = 10,
+	LOOPBACK_GMII_FAR = 11,
+	LOOPBACK_SGMII_FAR = 12,
+	LOOPBACK_XFI_FAR = 13,
+	LOOPBACK_GPHY = 14,
+	LOOPBACK_PHYXS = 15,
+	LOOPBACK_PCS = 16,
+	LOOPBACK_PMAPMD = 17,
+	LOOPBACK_XPORT = 18,
+	LOOPBACK_XGMII_WS = 19,
+	LOOPBACK_XAUI_WS = 20,
+	LOOPBACK_XAUI_WS_FAR = 21,
+	LOOPBACK_XAUI_WS_NEAR = 22,
+	LOOPBACK_GMII_WS = 23,
+	LOOPBACK_XFI_WS = 24,
+	LOOPBACK_XFI_WS_FAR = 25,
+	LOOPBACK_PHYXS_WS = 26,
+	LOOPBACK_PMA_INT = 27,
+	LOOPBACK_SD_NEAR = 28,
+	LOOPBACK_SD_FAR = 29,
+	LOOPBACK_PMA_INT_WS = 30,
+	LOOPBACK_SD_FEP2_WS = 31,
+	LOOPBACK_SD_FEP1_5_WS = 32,
+	LOOPBACK_SD_FEP_WS = 33,
+	LOOPBACK_SD_FES_WS = 34,
+	LOOPBACK_AOE_INT_NEAR = 35,
+	LOOPBACK_DATA_WS = 36,
+	LOOPBACK_FORCE_EXT_LINK = 37,
+	LOOPBACK_MAX
+};
+
+#define LOOPBACK_TEST_MAX LOOPBACK_PMAPMD
+
+enum efct_sync_events_state {
+	SYNC_EVENTS_DISABLED = 0,
+	SYNC_EVENTS_REQUESTED,
+	SYNC_EVENTS_VALID,
+};
+
+/* These loopbacks occur within the controller */
+#define LOOPBACKS_INTERNAL ((1 << LOOPBACK_DATA) |		\
+			    (1 << LOOPBACK_GMAC) |		\
+			    (1 << LOOPBACK_XGMII) |		\
+			    (1 << LOOPBACK_XGXS) |		\
+			    (1 << LOOPBACK_XAUI) |		\
+			    (1 << LOOPBACK_GMII) |		\
+			    (1 << LOOPBACK_SGMII) |		\
+			    (1 << LOOPBACK_SGMII) |		\
+			    (1 << LOOPBACK_XGBR) |		\
+			    (1 << LOOPBACK_XFI) |		\
+			    (1 << LOOPBACK_XAUI_FAR) |		\
+			    (1 << LOOPBACK_GMII_FAR) |		\
+			    (1 << LOOPBACK_SGMII_FAR) |		\
+			    (1 << LOOPBACK_XFI_FAR) |		\
+			    (1 << LOOPBACK_XGMII_WS) |		\
+			    (1 << LOOPBACK_XAUI_WS) |		\
+			    (1 << LOOPBACK_XAUI_WS_FAR) |	\
+			    (1 << LOOPBACK_XAUI_WS_NEAR) |	\
+			    (1 << LOOPBACK_GMII_WS) |		\
+			    (1 << LOOPBACK_XFI_WS) |		\
+			    (1 << LOOPBACK_XFI_WS_FAR))
+
+#define LOOPBACKS_WS ((1 << LOOPBACK_XGMII_WS) |		\
+		      (1 << LOOPBACK_XAUI_WS) |			\
+		      (1 << LOOPBACK_XAUI_WS_FAR) |		\
+		      (1 << LOOPBACK_XAUI_WS_NEAR) |		\
+		      (1 << LOOPBACK_GMII_WS) |			\
+		      (1 << LOOPBACK_XFI_WS) |			\
+		      (1 << LOOPBACK_XFI_WS_FAR) |		\
+		      (1 << LOOPBACK_PHYXS_WS))
+
+#define LOOPBACK_MASK(_efct) \
+	(1 << (_efct)->loopback_mode)
+
+#define LOOPBACK_INTERNAL(_efct) \
+	(!!(LOOPBACKS_INTERNAL & LOOPBACK_MASK(_efct)))
+
+#endif /* EFCT_ENUM_H */
diff --git a/drivers/net/ethernet/amd/efct/efct_evq.c b/drivers/net/ethernet/amd/efct/efct_evq.c
new file mode 100644
index 000000000000..4033af8de2cf
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_evq.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include "efct_evq.h"
+#include "efct_rx.h"
+#include "mcdi.h"
+#include "mcdi_functions.h"
+#include "efct_reg.h"
+#include "efct_bitfield.h"
+#include "efct_io.h"
+
+#define TX_NAPI_BUDGET  64
+#define RX_NAPI_BUDGET  64
+
+static void efct_update_irq_mod(struct efct_nic *efct, struct efct_ev_queue *evq)
+{
+	int step = efct->irq_mod_step_ns;
+
+	if (evq->irq_mod_score < evq->irq_adapt_low_thresh) {
+		if (evq->irq_moderation_ns > step) {
+			evq->irq_moderation_ns -= step;
+			efct_mcdi_ev_set_timer(evq, evq->irq_moderation_ns,
+					       MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_INT_HLDOFF, true);
+		}
+	} else if (evq->irq_mod_score > evq->irq_adapt_high_thresh) {
+		if (evq->irq_moderation_ns < efct->irq_rx_moderation_ns) {
+			evq->irq_moderation_ns += step;
+			efct_mcdi_ev_set_timer(evq, evq->irq_moderation_ns,
+					       MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_INT_HLDOFF, true);
+		}
+	}
+
+	evq->irq_count = 0;
+	evq->irq_mod_score = 0;
+}
+
+int efct_nic_event_test_irq_cpu(struct efct_ev_queue *evq)
+{
+	return READ_ONCE(evq->event_test_cpu);
+}
+
+static int efct_process_evq(struct efct_ev_queue *evq, int budget)
+{
+	struct efct_nic *efct = evq->efct;
+
+	return efct->type->ev_process(evq, budget);
+}
+
+void efct_write_evt_prime(struct efct_nic *efct, u32 id, u16 seq)
+{
+	union efct_dword hdr;
+
+	EFCT_POPULATE_DWORD_2(hdr, ERF_HZ_READ_IDX, seq,
+			      ERF_HZ_EVQ_ID, id);
+	efct_writed(&hdr, efct->membase + ER_HZ_PORT0_REG_HOST_EVQ_INT_PRIME);
+}
+
+static int efct_poll(struct napi_struct *napi, int budget)
+{
+	struct efct_ev_queue *evq = container_of(napi, struct efct_ev_queue, napi);
+	struct efct_nic *efct = evq->efct;
+	int spent;
+
+	if (!budget)
+		return 0;
+
+	spent = efct_process_evq(evq, budget);
+	if (spent < budget) {
+		if (evq->type == EVQ_T_RX && efct->irq_rx_adaptive &&
+		    unlikely(++evq->irq_count == evq->irq_adapt_irqs)) {
+			efct_update_irq_mod(efct, evq);
+		}
+
+		if (napi_complete_done(napi, spent))
+			// Host needs to Re-prime or enable the interrupt again
+			efct_write_evt_prime(evq->efct, evq->index, evq->consumer_index);
+	}
+	return spent;
+}
+
+int efct_realloc_rx_evqs(struct efct_nic *efct, u32 num_entries)
+{
+	int i, rc;
+
+	for (i = 0; i < efct->rxq_count; i++) {
+		int evq_index = efct->rxq[i].evq_index;
+
+		efct->type->ev_remove(&efct->evq[evq_index]);
+		dbl_fini(&efct->rxq[i]);
+
+		efct->rxq[i].num_entries = num_entries;
+		efct->rxq[i].num_rx_buffs = num_entries / (DIV_ROUND_UP(efct->rxq[i].buffer_size,
+							   efct->rxq[i].pkt_stride));
+
+		rc = dbl_init(&efct->rxq[i]);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Failed initialize driver buffer list for rxq %d\n", i);
+			goto fail;
+		}
+
+		rc = efct->type->ev_probe(efct, evq_index, efct->rxq[i].num_entries);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev,
+				  "Event queue probe failed, index %d\n", evq_index);
+			goto fail;
+		}
+
+		set_bit(evq_index, &efct->evq_active_mask);
+	}
+
+	return 0;
+
+fail:
+	efct->state = STATE_DISABLED;
+	return rc;
+}
+
+static void efct_init_evq_napi(struct efct_ev_queue *evq)
+{
+	struct efct_nic *efct = evq->efct;
+
+	evq->napi_dev = efct->net_dev;
+
+	if (evq->type == EVQ_T_RX)
+		netif_napi_add(evq->napi_dev, &evq->napi, efct_poll);
+	else if (evq->type == EVQ_T_TX)
+		netif_napi_add_tx(evq->napi_dev, &evq->napi, efct_poll);
+	else
+		evq->napi_dev = NULL;
+}
+
+int efct_init_napi(struct efct_nic *efct)
+{
+	u32 i;
+
+	for (i = 0; i < efct->max_evq_count; ++i)
+		efct_init_evq_napi(&efct->evq[i]);
+
+	return 0;
+}
+
+static void efct_finish_evq_napi(struct efct_ev_queue *evq)
+{
+	if (evq->napi_dev)
+		netif_napi_del(&evq->napi);
+}
+
+void efct_finish_napi(struct efct_nic *efct)
+{
+	u32 i;
+
+	for (i = 0; i < efct->max_evq_count; ++i)
+		efct_finish_evq_napi(&efct->evq[i]);
+}
+
+void efct_disable_napi(struct efct_ev_queue *evq)
+{
+	struct napi_struct *n = &evq->napi;
+
+	if (evq->efct->state == STATE_NET_UP)
+		napi_disable(n);
+}
+
+void efct_enable_napi(struct efct_ev_queue *evq)
+{
+	struct napi_struct *n = &evq->napi;
+
+	if (evq->efct->state == STATE_NET_UP) {
+		napi_enable(n);
+		local_bh_disable();
+		napi_schedule(&evq->napi);
+		local_bh_enable();
+	}
+}
+
+void efct_synchronize_napi(struct efct_ev_queue *evq)
+{
+	if (evq->efct->state == STATE_NET_UP)
+		napi_synchronize(&evq->napi);
+}
diff --git a/drivers/net/ethernet/amd/efct/efct_evq.h b/drivers/net/ethernet/amd/efct/efct_evq.h
new file mode 100644
index 000000000000..04636e71ea99
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_evq.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_EVQ_H
+#define EFCT_EVQ_H
+#include "efct_driver.h"
+
+int efct_init_napi(struct efct_nic *efct);
+void efct_finish_napi(struct efct_nic *efct);
+void efct_disable_napi(struct efct_ev_queue *evq);
+void efct_enable_napi(struct efct_ev_queue *evq);
+void efct_synchronize_napi(struct efct_ev_queue *evq);
+void  efct_write_evt_prime(struct efct_nic *efct, u32 id, u16 seq);
+int efct_realloc_rx_evqs(struct efct_nic *efct, u32 num_entries);
+bool efct_nic_event_present(struct efct_ev_queue *evq);
+int efct_nic_event_test_irq_cpu(struct efct_ev_queue *evq);
+#endif
diff --git a/drivers/net/ethernet/amd/efct/efct_io.h b/drivers/net/ethernet/amd/efct/efct_io.h
new file mode 100644
index 000000000000..f169643a920f
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_io.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_IO_H
+#define EFCT_IO_H
+
+#include <linux/io.h>
+#include <linux/spinlock.h>
+
+static inline u32 efct_reg(struct efct_device *efct_dev, u32 reg)
+{
+	return efct_dev->reg_base + reg;
+}
+
+static inline void _efct_writed(__le32 value, void __iomem *reg)
+{
+	__raw_writel((__force u32)value, reg);
+}
+
+static inline __le32 _efct_readd(void __iomem *reg)
+{
+	return (__force __le32)__raw_readl(reg);
+}
+
+/* Write a 32-bit CSR or the last dword of a special 128-bit CSR */
+static inline void efct_writed(const union efct_dword *value, void __iomem *reg)
+{
+	_efct_writed(value->word32, reg);
+}
+
+/* Read a 32-bit CSR or SRAM */
+static inline void efct_readd(union efct_dword *value, void __iomem *reg)
+{
+	value->word32 = _efct_readd(reg);
+}
+
+/* Read a 128-bit CSR, locking as appropriate. */
+static inline void efct_reado(struct efct_device *efct_dev,
+			      union efct_oword *value, void __iomem *reg)
+{
+	unsigned long flags __maybe_unused;
+
+	spin_lock_irqsave(&efct_dev->biu_lock, flags);
+	value->u32[0] = (__force __le32)__raw_readl((u8 *)reg + 0);
+	value->u32[1] = (__force __le32)__raw_readl((u8 *)reg + 4);
+	value->u32[2] = (__force __le32)__raw_readl((u8 *)reg + 8);
+	value->u32[3] = (__force __le32)__raw_readl((u8 *)reg + 12);
+	spin_unlock_irqrestore(&efct_dev->biu_lock, flags);
+}
+
+static inline void _efct_writeq(__le64 value, void __iomem *reg)
+{
+	__raw_writeq((__force u64)value, reg);
+}
+
+static inline __le64 _efct_readq(void __iomem *reg)
+{
+	return (__force __le64)__raw_readq(reg);
+}
+#endif /* EFCT_IO_H */
diff --git a/drivers/net/ethernet/amd/efct/efct_netdev.c b/drivers/net/ethernet/amd/efct/efct_netdev.c
new file mode 100644
index 000000000000..41aa4e28c676
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_netdev.c
@@ -0,0 +1,459 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+#include "efct_netdev.h"
+#include "efct_common.h"
+#include "efct_evq.h"
+#include "efct_tx.h"
+#include "efct_nic.h"
+#include "mcdi.h"
+#include "mcdi_port_common.h"
+
+static int efct_netdev_event(struct notifier_block *this,
+			     unsigned long event, void *ptr)
+{
+	struct efct_nic *efct = container_of(this, struct efct_nic, netdev_notifier);
+	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
+
+	if (efct->net_dev == net_dev &&
+	    (event == NETDEV_CHANGENAME || event == NETDEV_REGISTER)) {
+		netif_dbg(efct, drv, efct->net_dev,
+			  "Event %lu Interface name %s\n", event, efct->net_dev->name);
+		strcpy(efct->name, efct->net_dev->name);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int efct_start_all_queues(struct efct_nic *efct)
+{
+	int i, j, k, l, rc;
+
+	i = 0;
+	j = 0;
+	k = 0;
+	atomic_set(&efct->active_queues, 0);
+
+	for_each_set_bit(i, &efct->evq_active_mask, efct->max_evq_count) {
+		if (efct->evq[i].type == EVQ_T_AUX)
+			continue;
+
+		rc = efct->type->ev_init(&efct->evq[i]);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev, "EV queue init failed, index %d\n", i);
+			goto fail1;
+		}
+	}
+
+	for (j = 0; j < efct->rxq_count; j++) {
+		rc = efct->type->rx_init(&efct->rxq[j]);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev, "RX queue init failed, index %d\n", j);
+			goto fail2;
+		}
+		atomic_inc(&efct->active_queues);
+	}
+
+	for (k = 0; k < EFCT_MAX_CORE_TX_QUEUES; k++) {
+		rc = efct->type->tx_init(&efct->txq[k]);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev, "TX queue init failed, index %d\n", k);
+			goto fail3;
+		}
+	}
+
+	atomic_add(EFCT_MAX_CORE_TX_QUEUES, &efct->active_queues);
+
+	return 0;
+
+fail3:
+	for (l = 0; l < k; l++) {
+		efct->type->tx_fini(&efct->txq[l]);
+		efct->type->tx_purge(&efct->txq[l]);
+	}
+fail2:
+	for (l = 0; l < j ; l++) {
+		efct->type->rx_fini(&efct->rxq[l]);
+		efct->type->rx_purge(&efct->rxq[l]);
+	}
+fail1:
+	for (l = 0; l < i; ++l) {
+		if (!test_bit(l, &efct->evq_active_mask) || efct->evq[l].type == EVQ_T_AUX)
+			continue;
+
+		efct->type->ev_fini(&efct->evq[l]);
+		efct->type->ev_purge(&efct->evq[l]);
+	}
+
+	return rc;
+}
+
+static void efct_stop_all_queues(struct efct_nic *efct)
+{
+	int i, pending = 0;
+
+	if ((efct->reset_pending & (1 << RESET_TYPE_DATAPATH))) {
+		for (i = 0; i < efct->rxq_count; i++) {
+			efct->rxq[i].enable = false;
+			efct->type->rx_purge(&efct->rxq[i]);
+		}
+
+		for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++)
+			efct->type->tx_purge(&efct->txq[i]);
+
+		for_each_set_bit(i, &efct->evq_active_mask, efct->max_evq_count) {
+			if (efct->evq[i].type == EVQ_T_AUX)
+				continue;
+			efct->type->ev_purge(&efct->evq[i]);
+		}
+		return;
+	}
+
+	for (i = 0; i < efct->rxq_count; i++)
+		efct->type->rx_fini(&efct->rxq[i]);
+
+	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++)
+		efct->type->tx_fini(&efct->txq[i]);
+
+	wait_event_timeout(efct->flush_wq, atomic_read(&efct->active_queues) == 0,
+			   msecs_to_jiffies(EFCT_MAX_FLUSH_TIME));
+
+	pending = atomic_read(&efct->active_queues);
+	if (pending) {
+		netif_err(efct, hw, efct->net_dev, "failed to flush %d queues\n",
+			  pending);
+	}
+
+	for (i = 0; i < efct->rxq_count; i++)
+		efct->type->rx_purge(&efct->rxq[i]);
+
+	for (i = 0; i < EFCT_MAX_CORE_TX_QUEUES; i++)
+		efct->type->tx_purge(&efct->txq[i]);
+
+	for_each_set_bit(i, &efct->evq_active_mask, efct->max_evq_count) {
+		if (efct->evq[i].type == EVQ_T_AUX)
+			continue;
+		efct->type->ev_fini(&efct->evq[i]);
+		efct->type->ev_purge(&efct->evq[i]);
+	}
+}
+
+/* Context: process, rtnl_lock() held. */
+static int efct_net_open(struct net_device *net_dev)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	int rc;
+
+	mutex_lock(&efct->state_lock);
+
+	if (efct->state == STATE_DISABLED) {
+		rc = -EINVAL;
+		goto fail;
+	}
+
+	/* Always come out of low power unless we're forced off */
+	if (!efct->phy_power_force_off)
+		efct->phy_mode &= ~PHY_MODE_LOW_POWER;
+
+	mutex_lock(&efct->mac_lock);
+	rc = efct_mac_reconfigure(efct);
+	mutex_unlock(&efct->mac_lock);
+	if (rc)
+		goto fail;
+
+	rc = efct_start_all_queues(efct);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev, "efct_start_all_queues failed, index %d\n", rc);
+		goto fail;
+	}
+
+	rc = efct_init_napi(efct);
+	if (rc)
+		goto fail1;
+	/* Link state detection is event-driven; we have to poll the state before enabling
+	 * interrupt and after queue setup. It will avoid race, In case cable plugged after
+	 * phy_poll and before status change
+	 */
+	mutex_lock(&efct->mac_lock);
+	if (efct_mcdi_phy_poll(efct))
+		efct_link_status_changed(efct);
+	mutex_unlock(&efct->mac_lock);
+	rc = efct_start_evqs(efct);
+	if (rc)
+		goto fail2;
+	efct_set_interrupt_affinity(efct);
+	netif_start_queue(net_dev);
+	efct->state = STATE_NET_UP;
+	mutex_unlock(&efct->state_lock);
+
+	return 0;
+
+fail2:
+	efct_finish_napi(efct);
+fail1:
+	efct_stop_all_queues(efct);
+fail:
+	mutex_unlock(&efct->state_lock);
+
+	return rc;
+}
+
+static int efct_net_stop(struct net_device *net_dev)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	mutex_lock(&efct->state_lock);
+	efct->state = STATE_NET_DOWN;
+	netif_stop_queue(net_dev);
+	efct_clear_interrupt_affinity(efct);
+	efct_stop_all_queues(efct);
+
+	efct_stop_evqs(efct);
+	efct_finish_napi(efct);
+	mutex_unlock(&efct->state_lock);
+
+	/* Update stats to avoid last update delta */
+	efct->type->update_stats(efct, true);
+
+	return 0;
+}
+
+/* Context: netif_tx_lock held, BHs disabled. */
+static void efct_watchdog(struct net_device *net_dev, unsigned int txqueue)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	netif_err(efct, tx_err, efct->net_dev, "TX watchdog. Resetting the device\n");
+
+	efct_schedule_reset(efct, RESET_TYPE_TX_WATCHDOG);
+}
+
+static int efct_phy_probe(struct efct_nic *efct)
+{
+	struct efct_mcdi_phy_data *phy_data;
+	int rc;
+
+	/* Probe for the PHY */
+	efct->phy_data = kzalloc(sizeof(*phy_data), GFP_KERNEL);
+	if (!efct->phy_data)
+		return -ENOMEM;
+
+	rc = efct_mcdi_get_phy_cfg(efct, efct->phy_data);
+	if (rc)
+		goto fail;
+
+	/* Populate driver and ethtool settings */
+	phy_data = efct->phy_data;
+
+	mcdi_to_ethtool_linkset(efct, phy_data->media, phy_data->supported_cap,
+				efct->link_advertising);
+
+	/* Default to Autonegotiated flow control if the PHY supports it */
+	efct->wanted_fc = EFCT_FC_RX | EFCT_FC_TX;
+	if (phy_data->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
+		efct->wanted_fc |= EFCT_FC_AUTO;
+
+	efct_link_set_wanted_fc(efct, efct->wanted_fc);
+	/* Push settings to the PHY. Failure is not fatal, the user can try to
+	 * fix it using ethtool.
+	 */
+	rc = efct_mcdi_port_reconfigure(efct);
+	if (rc)
+		netif_warn(efct, drv, efct->net_dev,
+			   "could not initialise PHY settings\n");
+
+	rc = efct_mcdi_loopback_modes(efct, &efct->loopback_modes);
+	if (rc != 0)
+		goto fail;
+	/* The MC indicates that LOOPBACK_NONE is a valid loopback mode,
+	 * but by convention we don't
+	 */
+	efct->loopback_modes &= ~(1 << LOOPBACK_NONE);
+	return 0;
+fail:
+	kfree(efct->phy_data);
+	efct->phy_data = NULL;
+	return rc;
+}
+
+static int efct_eth_ioctl(struct net_device *net_dev, struct ifreq *ifr,
+			  int cmd)
+{
+	switch (cmd) {
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void efct_set_rx_mode(struct net_device *dev)
+{
+}
+
+static void efct_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+
+	spin_lock_bh(&efct->stats_lock);
+	efct_update_stats_common(efct, NULL, stats);
+	spin_unlock_bh(&efct->stats_lock);
+}
+
+static const struct net_device_ops efct_netdev_ops = {
+	.ndo_open               = efct_net_open,
+	.ndo_stop               = efct_net_stop,
+	.ndo_tx_timeout         = efct_watchdog,
+	.ndo_get_stats64        = efct_net_stats,
+	.ndo_eth_ioctl		= efct_eth_ioctl,
+	.ndo_set_mac_address    = efct_set_mac_address,
+	.ndo_set_rx_mode        = efct_set_rx_mode,
+	.ndo_change_mtu         = efct_change_mtu,
+	.ndo_get_phys_port_id   = efct_get_phys_port_id,
+};
+
+int efct_close_netdev(struct efct_nic *efct)
+{
+	rtnl_lock();
+	dev_close(efct->net_dev);
+	rtnl_unlock();
+
+	return 0;
+}
+
+int efct_remove_netdev(struct efct_nic *efct)
+{
+	efct_unregister_netdev(efct);
+	efct_mcdi_mac_fini_stats(efct);
+	kfree(efct->phy_data);
+	efct->phy_data = NULL;
+
+	return 0;
+}
+
+int efct_get_mac_address(struct efct_nic *efct, u8 *mac_address)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_MAC_ADDRESSES_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_MAC_ADDRESSES_IN_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_MAC_ADDRESSES, NULL,
+			   0, outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+
+	if (outlen < MC_CMD_GET_MAC_ADDRESSES_OUT_LEN)
+		return -EIO;
+
+	memcpy(mac_address, MCDI_PTR(outbuf, GET_MAC_ADDRESSES_OUT_MAC_ADDR_BASE), ETH_ALEN);
+
+	return 0;
+}
+
+int efct_probe_netdev(struct efct_nic *efct)
+{
+	struct net_device *net_dev = efct->net_dev;
+	u8 addr[ETH_ALEN];
+	int rc = 0;
+
+	/* Netdev Modifiable features */
+	net_dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_RXALL;
+	/* Netdev features */
+	net_dev->features |= (net_dev->hw_features | NETIF_F_HIGHDMA | NETIF_F_SG);
+
+	/* Disable receiving frames with bad FCS, by default. */
+	net_dev->features &= ~NETIF_F_RXALL;
+
+	SET_NETDEV_DEV(net_dev, &efct->efct_dev->pci_dev->dev);
+	rc = efct_get_mac_address(efct, addr);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "Failed to get MAC address, rc=%d", rc);
+		goto out;
+	}
+	/* Assign MAC address */
+	eth_hw_addr_set(net_dev, addr);
+
+	rc = efct_init_datapath_caps(efct);
+	if (rc < 0) {
+		pci_err(efct->efct_dev->pci_dev,
+			"Failed to get datapath capabilities from MC, rc=%d", rc);
+		goto out;
+	}
+	rc = efct_phy_probe(efct);
+	if (rc)
+		goto out;
+
+	rc = efct_mcdi_mac_init_stats(efct);
+	if (rc)
+		goto out;
+out:
+	return rc;
+}
+
+int efct_register_netdev(struct efct_nic *efct)
+{
+	struct net_device *net_dev = efct->net_dev;
+	int rc = 0;
+
+	/*registering netdev*/
+	net_dev->watchdog_timeo = 5 * HZ;
+	net_dev->netdev_ops = &efct_netdev_ops;
+	net_dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
+
+	net_dev->min_mtu = EFCT_MIN_MTU;
+	net_dev->max_mtu = EFCT_MAX_MTU;
+	efct->netdev_notifier.notifier_call = efct_netdev_event;
+	rc = register_netdevice_notifier(&efct->netdev_notifier);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "Error: netdev notifier register fail\n");
+		goto fail;
+	}
+
+	rtnl_lock();
+
+	rc = dev_alloc_name(net_dev, net_dev->name);
+	if (rc < 0) {
+		pci_err(efct->efct_dev->pci_dev, "dev_alloc_name failed, rc=%d", rc);
+		goto fail_locked;
+	}
+	strscpy(efct->name, efct->net_dev->name, sizeof(efct->name));
+
+	rc = register_netdevice(net_dev);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "register_netdevice failed, rc=%d", rc);
+		goto fail_locked;
+	}
+
+	/* Always start with carrier off; PHY events will detect the link */
+	netif_carrier_off(net_dev);
+
+	efct->state = STATE_NET_DOWN;
+
+	rtnl_unlock();
+
+	return 0;
+
+fail_locked:
+	rtnl_unlock();
+	unregister_netdevice_notifier(&efct->netdev_notifier);
+fail:
+	netif_err(efct, drv, efct->net_dev, "could not register net dev\n");
+	return rc;
+}
+
+void efct_unregister_netdev(struct efct_nic *efct)
+{
+	if (WARN_ON(efct_netdev_priv(efct->net_dev) != efct))
+		return;
+
+	if (efct_dev_registered(efct)) {
+		efct->state = STATE_UNINIT;
+		unregister_netdevice_notifier(&efct->netdev_notifier);
+		rtnl_lock();
+		unregister_netdevice(efct->net_dev);
+		rtnl_unlock();
+	}
+}
diff --git a/drivers/net/ethernet/amd/efct/efct_netdev.h b/drivers/net/ethernet/amd/efct/efct_netdev.h
new file mode 100644
index 000000000000..fefbdc38864a
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_netdev.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_NETDEV_H
+#define EFCT_NETDEV_H
+
+#include "efct_driver.h"
+
+int efct_probe_netdev(struct efct_nic *efct);
+int efct_remove_netdev(struct efct_nic *efct);
+int efct_close_netdev(struct efct_nic *efct);
+int efct_register_netdev(struct efct_nic *efct);
+void efct_unregister_netdev(struct efct_nic *efct);
+int efct_get_mac_address(struct efct_nic *efct, u8 *mac_address);
+#endif
diff --git a/drivers/net/ethernet/amd/efct/efct_nic.c b/drivers/net/ethernet/amd/efct/efct_nic.c
new file mode 100644
index 000000000000..0be2bea0c903
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_nic.c
@@ -0,0 +1,1300 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/module.h>
+#include "efct_reg.h"
+#include "efct_common.h"
+#include "efct_tx.h"
+#include "efct_rx.h"
+#include "mcdi.h"
+#include "mcdi_pcol.h"
+#include "efct_io.h"
+#include "mcdi_functions.h"
+#include "efct_nic.h"
+#include "mcdi_port_common.h"
+#include "efct_evq.h"
+
+#define EFCT_NUM_MCDI_BUFFERS	1
+
+static bool efct_has_dynamic_sensors(struct efct_nic *efct)
+{
+	return efct_has_cap(efct, DYNAMIC_SENSORS);
+}
+
+static int txq_get_free_index(struct efct_nic *efct)
+{
+	unsigned long mask = (1UL << efct->max_txq_count) - 1;
+	unsigned long txq_active;
+	int index;
+
+	do {
+		txq_active = efct->txq_active_mask;
+		/*No free index present, all event queues are in use. ffz()
+		 *behavior is undefined if at least one zero is not present.
+		 * This check will make sure at least 1 zero bit is there in evq_active
+		 */
+		if ((txq_active & mask) == mask)
+			return -EAGAIN;
+		index = ffz(txq_active);
+		/* In case queue is already allocated because of contention. It will
+		 * retry for next available index
+		 */
+		if (test_and_set_bit(index, &efct->txq_active_mask)) {
+			netif_dbg(efct, drv, efct->net_dev,
+				  "Tx queue index %d is already in use\n", index);
+			continue;
+		}
+
+		if (index < efct->max_txq_count)
+			return index;
+		else
+			return -ENOSPC;
+	} while (1);
+
+	return -ENOSPC;
+}
+
+int efct_start_evqs(struct efct_nic *efct)
+{
+	int rc;
+	int i;
+
+	efct_set_evq_names(efct);
+	for (i = 0; i < efct->max_evq_count; ++i) {
+		if (!efct->evq[i].napi_dev)
+			continue;
+		napi_enable(&efct->evq[i].napi);
+		rc = request_irq(efct->evq[i].msi.irq, efct->type->irq_handle_msix, 0,
+				 efct->evq[i].msi.name, &efct->evq[i]);
+		if (rc) {
+			netif_err(efct, drv, efct->net_dev, "failed to hook IRQ %d\n",
+				  efct->evq[i].msi.irq);
+			goto fail;
+		}
+		// Host needs to prime the interrupt initially
+		efct_write_evt_prime(efct, efct->evq[i].index, efct->evq[i].consumer_index);
+	}
+
+	return 0;
+fail:
+	napi_disable(&efct->evq[i].napi);
+	for (i = i - 1; i >= 0; i--) {
+		free_irq(efct->evq[i].msi.irq, &efct->evq[i]);
+		napi_disable(&efct->evq[i].napi);
+	}
+	return rc;
+}
+
+void efct_stop_evqs(struct efct_nic *efct)
+{
+	u32 i;
+
+	for (i = 0; i < efct->max_evq_count; ++i) {
+		if (!efct->evq[i].napi_dev)
+			continue;
+		napi_disable(&efct->evq[i].napi);
+		free_irq(efct->evq[i].msi.irq, &efct->evq[i]);
+	}
+}
+
+static void efct_process_timer_config(struct efct_nic *efct,
+				      const union efct_dword *data)
+{
+	efct->timer_max_ns = MCDI_DWORD(data, GET_EVQ_TMR_PROPERTIES_OUT_MCDI_TMR_MAX_NS);
+	efct->irq_mod_step_ns = MCDI_DWORD(data, GET_EVQ_TMR_PROPERTIES_OUT_MCDI_TMR_STEP_NS);
+
+	pci_dbg(efct->efct_dev->pci_dev,
+		"got timer properties from MC: max %u ns; step %u ns\n",
+		efct->timer_max_ns, efct->irq_mod_step_ns);
+}
+
+static int efct_get_timer_config(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_LEN);
+	int rc;
+
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_GET_EVQ_TMR_PROPERTIES, NULL, 0,
+				 outbuf, sizeof(outbuf), NULL);
+
+	if (rc == 0) {
+		efct_process_timer_config(efct, outbuf);
+	} else {
+		efct_mcdi_display_error(efct, MC_CMD_GET_EVQ_TMR_PROPERTIES,
+					MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_LEN,
+				       NULL, 0, rc);
+	}
+
+	return rc;
+}
+
+static int efct_get_warm_boot_count(struct efct_device *efct_dev)
+{
+	union efct_dword reg;
+
+	efct_readd(&reg, efct_dev->membase + efct_reg(efct_dev,
+						      ER_HZ_FUN_WIN_REG_HOST_MC_SFT_STATUS));
+	if (EFCT_DWORD_FIELD(reg, EFCT_DWORD_0) == 0xffffffff) {
+		pr_info("X3 Hardware unavailable\n");
+		return -ENETDOWN;
+	} else {
+		return EFCT_DWORD_FIELD(reg, EFCT_WORD_1) == 0xb007 ?
+			EFCT_DWORD_FIELD(reg, EFCT_WORD_0) : -EIO;
+	}
+}
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+static ssize_t mcdi_logging_show(struct device *dev, struct device_attribute *attr,
+				 char *buf)
+{
+	struct efct_device *efct_dev = pci_get_drvdata(to_pci_dev(dev));
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", efct_dev->mcdi_logging);
+}
+
+static ssize_t mcdi_logging_store(struct device *dev, struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct efct_device *efct_dev = pci_get_drvdata(to_pci_dev(dev));
+	bool enable = count > 0 && *buf != '0';
+	int i = 0;
+
+	efct_dev->mcdi_logging = enable;
+	for (i = 0; i < efct_dev->num_ports; i++) {
+		struct efct_nic *efct = efct_dev->efct[i];
+		struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+
+		if (mcdi)
+			mcdi->logging_enabled = enable;
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(mcdi_logging);
+
+void efct_init_mcdi_logging(struct efct_device *efct_dev)
+{
+	int rc = device_create_file(&efct_dev->pci_dev->dev,
+				    &dev_attr_mcdi_logging);
+	if (rc)
+		pr_warn("failed to init net dev attributes\n");
+}
+
+void efct_fini_mcdi_logging(struct efct_device *efct_dev)
+{
+	device_remove_file(&efct_dev->pci_dev->dev, &dev_attr_mcdi_logging);
+}
+#endif
+
+int efct_init_datapath_caps(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V10_OUT_LEN);
+	size_t outlen = 0;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_CAPABILITIES_IN_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_CAPABILITIES, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev,
+			  "MCDI command to read datapath firmware capabilities failed\n");
+		return rc;
+	}
+
+	if (outlen < MC_CMD_GET_CAPABILITIES_V10_OUT_LEN) {
+		netif_err(efct, drv, efct->net_dev,
+			  "unable to read datapath firmware capabilities\n");
+		return -EIO;
+	}
+
+	efct->datapath_caps = MCDI_DWORD(outbuf, GET_CAPABILITIES_V10_OUT_FLAGS1);
+	efct->datapath_caps2 = MCDI_DWORD(outbuf, GET_CAPABILITIES_V10_OUT_FLAGS2);
+	efct->num_mac_stats = MCDI_WORD(outbuf, GET_CAPABILITIES_V10_OUT_MAC_STATS_NUM_STATS);
+
+	return 0;
+}
+
+static int try_get_warm_boot_count(struct efct_nic *efct)
+{
+	int i, rc = -1;
+
+	for (i = 0; i < 5; ++i) {
+		rc = efct_get_warm_boot_count(efct->efct_dev);
+		if (rc >= 0)
+			break;
+		ssleep(1);
+	}
+
+	return rc;
+}
+
+static int efct_probe_main(struct efct_nic *efct)
+{
+	struct efct_nic_data *nic_data;
+	int rc;
+
+	rc = try_get_warm_boot_count(efct);
+	if (efct->mc_warm_boot_count < 0) {
+		pci_err(efct->efct_dev->pci_dev,
+			"Failed to get MC warm boot count, rc=%d\n", rc);
+		return rc;
+	}
+
+	efct->mc_warm_boot_count = rc;
+
+	nic_data = kzalloc(sizeof(*nic_data), GFP_KERNEL);
+	if (!nic_data)
+		return -ENOMEM;
+	efct->nic_data = nic_data;
+	nic_data->efct = efct;
+
+	/* MCDI buffers must be 256 byte aligned. */
+	rc = efct_nic_alloc_buffer(efct, &efct->mcdi_buf, MCDI_BUF_LEN, GFP_KERNEL);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev,
+			"Failed to allocate memory for MCDI buffers, rc=%d\n", rc);
+		goto fail1;
+	}
+	rc = efct_probe_common(efct);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "efct_probe_common function failed\n");
+		goto fail2;
+	}
+
+	rc = efct_mcdi_port_get_number(efct);
+	if (rc < 0) {
+		pci_err(efct->efct_dev->pci_dev,
+			"MCDI command to get port number failed, rc=%d\n", rc);
+		goto fail3;
+	}
+
+	efct->port_num = rc;
+	rc = efct_get_timer_config(efct);
+	if (rc) {
+		pci_err(efct->efct_dev->pci_dev, "failed to get timer details\n");
+		goto fail3;
+	}
+	return 0;
+fail3:
+	efct_remove_common(efct);
+fail2:
+	efct_nic_free_buffer(efct, &efct->mcdi_buf);
+fail1:
+	kfree(nic_data);
+	efct->nic_data = NULL;
+	return rc;
+}
+
+static void efct_remove_main(struct efct_nic *efct)
+{
+	efct_remove_common(efct);
+	efct_nic_free_buffer(efct, &efct->mcdi_buf);
+	kfree(efct->nic_data);
+	efct->nic_data = NULL;
+}
+
+static u32 efct_mcdi_rpc_timeout
+					(struct efct_nic *efct,
+					 u32 cmd)
+{
+	switch (cmd) {
+	case MC_CMD_NVRAM_ERASE:
+	case MC_CMD_NVRAM_UPDATE_FINISH:
+		return MCDI_RPC_LONG_TIMEOUT;
+	default:
+		return MCDI_RPC_TIMEOUT;
+	}
+}
+
+/*	MCDI
+ */
+static u8 *efct_mcdi_buf
+			(struct efct_nic *efct, u8 bufid,
+			 dma_addr_t *dma_addr)
+{
+	if (dma_addr)
+		*dma_addr = efct->mcdi_buf.dma_addr +
+			    bufid * ALIGN(MCDI_BUF_LEN, 256);
+	return (u8 *)efct->mcdi_buf.addr + bufid * ALIGN(MCDI_BUF_LEN, 256);
+}
+
+static void write_to_pio_region(struct efct_nic *efct, size_t offset,
+				const union efct_dword *req_data, size_t len)
+{
+	u32 pio_reg = offset + ER_HZ_PORT0_REG_HOST_MC_PIO;
+	int dwords = (len + 3) / 4;
+
+	while (dwords > 0) {
+		u64 val = (uint64_t)(le32_to_cpu(req_data[0].word32)) |
+				((dwords > 1) ?
+				((uint64_t)(le32_to_cpu(req_data[1].word32)) << 32) : 0);
+
+		_efct_writeq(cpu_to_le64((u64)val), efct->membase + pio_reg);
+		pio_reg += 8;
+		dwords -= 2;
+		req_data += 2;
+	}
+	/* Memory Barrier */
+	wmb();
+}
+
+static void efct_mcdi_request(struct efct_nic *efct, u8 bufid,
+			      const union efct_dword *hdr, size_t hdr_len,
+			      const union efct_dword *sdu, size_t sdu_len)
+{
+	u32 doorbell_reg_lwrd, doorbell_reg_hwrd;
+	dma_addr_t dma_addr;
+	u8 *pdu;
+
+	pdu = efct_mcdi_buf(efct, bufid, &dma_addr);
+	doorbell_reg_lwrd = ER_HZ_PORT0_REG_HOST_MC_DOORBELL;
+	doorbell_reg_hwrd = doorbell_reg_lwrd + 4;
+
+	if (!pdu)
+		return;
+
+	/* Set content of the host memory to 0 while sending the request */
+	memset(pdu, 0x0, MCDI_BUF_LEN);
+
+	/* Write out the hdr */
+	write_to_pio_region(efct, 0, hdr, hdr_len);
+
+	/* Write out the payload */
+	write_to_pio_region(efct, hdr_len, sdu, sdu_len);
+
+	/* The hardware provides 'low' and 'high' (doorbell) registers
+	 * for passing the 64-bit address of an MCDI request to
+	 * firmware.  However the dwords are swapped by firmware.  The
+	 * least significant bits of the doorbell are then 0 for all
+	 * MCDI requests due to alignment.
+	 */
+	_efct_writed(cpu_to_le32((u32)dma_addr),
+		     (efct->membase + doorbell_reg_lwrd));
+	_efct_writed(cpu_to_le32((u64)dma_addr >> 32),
+		     (efct->membase + doorbell_reg_hwrd));
+}
+
+static bool efct_mcdi_poll_response(struct efct_nic *efct, u8 bufid)
+{
+	const union efct_dword hdr =
+		*(const union efct_dword *)(efct_mcdi_buf(efct, bufid, NULL));
+
+	//memory barrier
+	rmb();
+	return EFCT_DWORD_FIELD(hdr, MCDI_HEADER_RESPONSE);
+}
+
+static void efct_mcdi_read_response(struct efct_nic *efct, u8 bufid,
+				    union efct_dword *outbuf, size_t offset,
+				    size_t outlen)
+{
+	const u8 *pdu = efct_mcdi_buf(efct, bufid, NULL);
+
+	memcpy(outbuf, pdu + offset, outlen);
+}
+
+static int mcdi_poll_reboot(struct efct_nic *efct)
+{
+	int rc;
+
+	rc = efct_get_warm_boot_count(efct->efct_dev);
+	if (rc < 0) {
+		/* The firmware is presumably in the process of
+		 * rebooting. However, we are supposed to report each
+		 * reboot just once, so we must only do that once we
+		 * can read and store the updated warm boot count.
+		 */
+		return 0;
+	}
+
+	if (rc == efct->mc_warm_boot_count)
+		return 0;
+
+	return -EIO;
+}
+
+/* Get an MCDI buffer
+ *
+ * The caller is responsible for preventing racing by holding the
+ * MCDI iface_lock.
+ */
+static bool efct_mcdi_get_buf(struct efct_nic *efct, u8 *bufid)
+{
+	if (!bufid)
+		return false;
+
+	*bufid = ffz(efct->mcdi_buf_use);
+
+	if (*bufid < EFCT_NUM_MCDI_BUFFERS) {
+		set_bit(*bufid, &efct->mcdi_buf_use);
+		return true;
+	}
+
+	return false;
+}
+
+/* Return an MCDI buffer */
+static void efct_mcdi_put_buf(struct efct_nic *efct, u8 bufid)
+{
+	if (bufid >= EFCT_NUM_MCDI_BUFFERS) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Invalid mcdi buffer index %d\n", bufid);
+		return;
+	}
+	if (!test_and_clear_bit(bufid, &efct->mcdi_buf_use))
+		netif_warn(efct, drv, efct->net_dev, "Buffer %u already freed\n", bufid);
+}
+
+/*	Event queue initialization
+ */
+static int efct_ev_probe(struct efct_nic *efct, u32 index, u32 size)
+{
+	int rc;
+
+	if (!efct)
+		return -EINVAL;
+	size = roundup_pow_of_two(size + EFCT_EV_UNSOL_MAX + EFCT_EV_CONSUMED_IN_OVERFLOW);
+	rc = validate_evq_size(efct, size);
+	if (rc < 1) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Invalid event queue size: %d\n",
+			  size);
+		return -EINVAL;
+	}
+
+	efct->evq[index].evq_base =
+			efct->membase + ER_HZ_PORT0_REG_HOST_EVQ_UNSOL_CREDIT_GRANT
+			+ (index * efct->efct_dev->params.evq_stride);
+	efct->evq[index].entries = size;
+	return efct_nic_alloc_buffer(efct, &efct->evq[index].buf,
+				(efct->evq[index].entries) *
+				sizeof(union efct_qword), GFP_KERNEL);
+}
+
+static void efct_ev_unsol_credit_grant(struct efct_ev_queue *eventq,
+				       bool overflow)
+{
+	union efct_qword qword;
+	u32 credit_mask;
+	u64 value;
+
+	if (!eventq->unsol_credit)
+		return;
+	credit_mask = eventq->efct->efct_dev->params.unsol_credit_seq_mask;
+	value = (eventq->unsol_consumer_index + eventq->unsol_credit) & credit_mask;
+	EFCT_POPULATE_QWORD_2(qword,
+			      ERF_HZ_GRANT_SEQ, value,
+			     ERF_HZ_CLEAR_OVERFLOW, overflow);
+	_efct_writeq(qword.u64[0], eventq->evq_base);
+}
+
+static int efct_ev_init(struct efct_ev_queue *eventq)
+{
+	int rc;
+
+	if (!eventq)
+		return -EINVAL;
+
+	/* Set initial phase to 0 */
+	eventq->evq_phase = false;
+	eventq->consumer_index = 0;
+	eventq->unsol_consumer_index = 0;
+	rc = efct_mcdi_ev_init(eventq);
+	if (rc) {
+		netif_err(eventq->efct, drv, eventq->efct->net_dev,
+			  "MCDI init failed for event queue index = %d\n", eventq->index);
+		return rc;
+	}
+	if (eventq->type != EVQ_T_AUX) {
+		efct_mcdi_ev_set_timer(eventq, eventq->irq_moderation_ns,
+				       MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_INT_HLDOFF, false);
+	}
+	efct_ev_unsol_credit_grant(eventq, EFCT_EV_UNSOL_OVERFLOW_CLEAR);
+	return 0;
+}
+
+static void efct_ev_fini(struct efct_ev_queue *ev_queue)
+{
+	if (!ev_queue || !ev_queue->efct) {
+		pr_err("Error:event queue or nic is NULL\n");
+		return;
+	}
+
+	if (!test_bit(ev_queue->index, &ev_queue->efct->evq_active_mask)) {
+		netif_err(ev_queue->efct, drv, ev_queue->efct->net_dev,
+			  "Event queue is already removed\n");
+		return;
+	}
+
+	efct_mcdi_ev_fini(ev_queue);
+}
+
+static void efct_ev_purge(struct efct_ev_queue *evq)
+{
+}
+
+static void efct_ev_remove(struct efct_ev_queue *ev_queue)
+{
+	struct efct_nic *efct = ev_queue->efct;
+
+	efct_nic_free_buffer(efct, &ev_queue->buf);
+	if (!test_and_clear_bit(ev_queue->index, &efct->evq_active_mask)) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Event queue is already removed\n");
+	}
+}
+
+/* Read the current event from the event queue */
+static union efct_qword *efct_event(struct efct_ev_queue *evq, u32 index)
+{
+	return ((union efct_qword *)(evq->buf.addr)) + index;
+}
+
+bool efct_nic_event_present(struct efct_ev_queue *evq)
+{
+	union efct_qword *p_event;
+	u32 consumer_index;
+	bool read_phase;
+	bool evq_phase;
+
+	consumer_index = evq->consumer_index;
+	evq_phase = evq->evq_phase;
+	p_event = efct_event(evq, consumer_index);
+
+	read_phase = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_PHASE);
+	if (read_phase != evq_phase)
+		return true;
+	return false;
+}
+
+static void efct_handle_flush_ev(struct efct_nic *efct, bool is_txq, int qid)
+{
+	if (is_txq) {
+		struct efct_tx_queue *txq = &efct->txq[qid];
+
+		if (txq->is_resetting) {
+			txq->is_resetting = false;
+			/* Reinit the Tx queue */
+			efct_schedule_queue_reset(efct, is_txq, qid);
+			return;
+		}
+	} else {
+		struct efct_rx_queue *rxq = &efct->rxq[qid];
+
+		if (rxq->is_resetting) {
+			rxq->is_resetting = false;
+			/* Reinit the Rx queue */
+			efct_schedule_queue_reset(efct, is_txq, qid);
+			return;
+		}
+	}
+
+	if (atomic_dec_and_test(&efct->active_queues))
+		wake_up(&efct->flush_wq);
+
+	WARN_ON(atomic_read(&efct->active_queues) < 0);
+}
+
+/* TODO : Remove this Macro and use from efct_reg.h after the hw yml file is
+ * updated with Error events change
+ */
+#define	ESE_HZ_X3_CTL_EVENT_SUBTYPE_ERROR 0x3
+static int
+efct_ev_control(struct efct_ev_queue *evq, union efct_qword *p_event, int quota)
+{
+	int subtype, spent = 1;
+	struct efct_nic *efct;
+
+	efct = evq->efct;
+	subtype = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_CTL_SUBTYPE);
+
+	evq->unsol_consumer_index++;
+
+	switch (subtype) {
+	case ESE_HZ_X3_CTL_EVENT_SUBTYPE_ERROR:
+		{
+			u8 qlabel, ftype, reason;
+
+			ftype = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_FLSH_FLUSH_TYPE);
+			qlabel = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_FLSH_LABEL);
+			reason = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_FLSH_REASON);
+
+			netif_err(efct, drv, efct->net_dev,
+				  "Error event received for %s %d reason code: %u\n",
+				  ftype ? "Rxq" : "Txq", qlabel, reason);
+
+			if (ftype)
+				efct->rxq[qlabel].is_resetting = true;
+			else
+				efct->txq[qlabel].is_resetting = true;
+		}
+		evq->n_evq_error_events++;
+		break;
+	case ESE_HZ_X3_CTL_EVENT_SUBTYPE_FLUSH:
+		{
+			u8 qlabel, ftype;
+
+			ftype = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_FLSH_FLUSH_TYPE);
+			qlabel = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_FLSH_LABEL);
+
+			netif_dbg(efct, drv, efct->net_dev,
+				  "Flush event received for %s %d\n",
+				  ftype ? "Rxq" : "Txq", qlabel);
+
+			efct_handle_flush_ev(efct, !ftype, qlabel);
+			evq->n_evq_flush_events++;
+		}
+		break;
+	case ESE_HZ_X3_CTL_EVENT_SUBTYPE_UNSOL_OVERFLOW:
+		/*TODO: Take action on overflow event, Reset unsol_consumer_index*/
+		evq->n_evq_unsol_overflow++;
+		efct_ev_unsol_credit_grant(evq, EFCT_EV_UNSOL_OVERFLOW_CLEAR);
+		break;
+	default:
+		evq->n_evq_unhandled_events++;
+		netif_info(efct, drv, efct->net_dev, "Unhandled control event %08x:%08x\n",
+			   le32_to_cpu(p_event->u32[1]), le32_to_cpu(p_event->u32[0]));
+		break;
+	}
+
+	if ((evq->unsol_consumer_index % EFCT_EV_UNSOL_GRANT_UPDATE == 0)) {
+		efct_ev_unsol_credit_grant(evq, 0);
+		evq->unsol_consumer_index &= evq->efct->efct_dev->params.unsol_credit_seq_mask;
+	}
+
+	return spent;
+}
+
+static void efct_ev_mcdi(struct efct_ev_queue *evq, union efct_qword *p_event)
+{
+	if (!efct_mcdi_process_event(evq->efct, p_event) &&
+	    !efct_mcdi_port_process_event_common(evq, p_event)) {
+		int code = EFCT_QWORD_FIELD(*p_event, MCDI_EVENT_CODE);
+		struct efct_nic *efct = evq->efct;
+
+		netif_info(efct, drv, efct->net_dev,
+			   "Unhandled MCDI event %08x:%08x code %d\n",
+			   le32_to_cpu(p_event->u32[1]), le32_to_cpu(p_event->u32[0]), code);
+	}
+
+	evq->unsol_consumer_index++;
+	if ((evq->unsol_consumer_index % EFCT_EV_UNSOL_GRANT_UPDATE == 0)) {
+		efct_ev_unsol_credit_grant(evq, 0);
+		evq->unsol_consumer_index &= evq->efct->efct_dev->params.unsol_credit_seq_mask;
+	}
+}
+
+static void efct_handle_driver_generated_event(struct efct_ev_queue *evq, union efct_qword *event)
+{
+	struct efct_nic *efct;
+	u32 subcode;
+
+	subcode = EFCT_QWORD_FIELD(*event, EFCT_DWORD_0);
+	efct = evq->efct;
+	switch (EFCT_DRVGEN_CODE(subcode)) {
+	case EFCT_TEST:
+		evq->event_test_napi = raw_smp_processor_id();
+		netif_dbg(efct, drv, efct->net_dev,
+			  "Driver initiated event %08x:%08x\n",
+			  le32_to_cpu(event->u32[1]), le32_to_cpu(event->u32[0]));
+		break;
+	default:
+		netif_err(efct, hw, efct->net_dev,
+			  "Event queue %d unknown driver event type %u data %08x:%08x\n",
+			  evq->index, (u32)subcode,
+			  le32_to_cpu(event->u32[1]),
+			  le32_to_cpu(event->u32[0]));
+	}
+}
+
+static int efct_ev_process(struct efct_ev_queue *evq, int quota)
+{
+	bool evq_phase, read_phase;
+	union efct_qword *p_event;
+	int i, spent, ev_type;
+	struct efct_nic *efct;
+	u32 consumer_index;
+	u8 qlabel = 0;
+
+	evq_phase = evq->evq_phase;
+	efct = evq->efct;
+
+	spent = 0;
+	consumer_index = evq->consumer_index;
+	p_event = efct_event(evq, consumer_index);
+	read_phase = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_PHASE);
+
+	if (read_phase != evq_phase)
+		goto end;
+
+	while (spent < quota) {
+		netif_vdbg(efct, drv, efct->net_dev, "processing event on %d %08x:%08x\n",
+			   evq->index, le32_to_cpu(p_event->u32[1]),
+			   le32_to_cpu(p_event->u32[0]));
+
+		ev_type = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TYPE);
+
+		switch (ev_type) {
+		case ESE_HZ_XN_EVENT_TYPE_CONTROL:
+			spent += efct_ev_control(evq, p_event, quota - spent);
+			break;
+		case ESE_HZ_XN_EVENT_TYPE_MCDI:
+			efct_ev_mcdi(evq, p_event);
+			++spent;
+			break;
+		case ESE_HZ_XN_EVENT_TYPE_DRIVER:
+			efct_handle_driver_generated_event(evq, p_event);
+			break;
+		default:
+			netif_warn(efct, drv, efct->net_dev, "Unhandled event %08x:%08x\n",
+				   le32_to_cpu(p_event->u32[1]), le32_to_cpu(p_event->u32[0]));
+		}
+
+		++consumer_index;
+		/*Entries */
+		if (consumer_index == evq->entries) {
+			evq_phase = !read_phase;
+			consumer_index = 0;
+		}
+		p_event = efct_event(evq, consumer_index);
+		read_phase = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_PHASE);
+		if (read_phase != evq_phase)
+			break;
+	}
+
+	if (evq->type == EVQ_T_TX) {
+		struct efct_tx_queue *txq = (struct efct_tx_queue *)evq->queue;
+
+		for (i = 0; i < evq->queue_count; ++i, ++txq) {
+			if (txq->bytes) {
+				netdev_tx_completed_queue(txq->core_txq, txq->pkts, txq->bytes);
+				txq->pkts = 0;
+				txq->bytes = 0;
+			}
+		}
+	}
+
+	evq->consumer_index = consumer_index;
+	evq->evq_phase = evq_phase;
+
+end:
+	return spent;
+}
+
+static irqreturn_t efct_msix_handler(int irq, void *dev_id)
+{
+	struct efct_ev_queue *evq = (struct efct_ev_queue *)dev_id;
+
+	netif_vdbg(evq->efct, intr, evq->efct->net_dev, "Evq %d scheduling NAPI poll on CPU%d\n",
+		   evq->index, raw_smp_processor_id());
+	evq->event_test_cpu = raw_smp_processor_id();
+	napi_schedule(&evq->napi);
+	if (evq->index == 0)
+		evq->efct->last_irq_cpu = raw_smp_processor_id();
+	return IRQ_HANDLED;
+}
+
+static void efct_common_stat_mask(unsigned long *mask)
+{
+	__set_bit(EFCT_STAT_port_rx_packets, mask);
+	__set_bit(EFCT_STAT_port_tx_packets, mask);
+	__set_bit(EFCT_STAT_port_rx_bytes, mask);
+	__set_bit(EFCT_STAT_port_tx_bytes, mask);
+	__set_bit(EFCT_STAT_port_rx_multicast, mask);
+	__set_bit(EFCT_STAT_port_rx_bad, mask);
+	__set_bit(EFCT_STAT_port_rx_align_error, mask);
+	__set_bit(EFCT_STAT_port_rx_overflow, mask);
+}
+
+static void efct_ethtool_stat_mask(unsigned long *mask)
+{
+	__set_bit(EFCT_STAT_port_tx_pause, mask);
+	__set_bit(EFCT_STAT_port_tx_unicast, mask);
+	__set_bit(EFCT_STAT_port_tx_multicast, mask);
+	__set_bit(EFCT_STAT_port_tx_broadcast, mask);
+	__set_bit(EFCT_STAT_port_tx_lt64, mask);
+	__set_bit(EFCT_STAT_port_tx_64, mask);
+	__set_bit(EFCT_STAT_port_tx_65_to_127, mask);
+	__set_bit(EFCT_STAT_port_tx_128_to_255, mask);
+	__set_bit(EFCT_STAT_port_tx_256_to_511, mask);
+	__set_bit(EFCT_STAT_port_tx_512_to_1023, mask);
+	__set_bit(EFCT_STAT_port_tx_1024_to_15xx, mask);
+	__set_bit(EFCT_STAT_port_tx_15xx_to_jumbo, mask);
+	__set_bit(EFCT_STAT_port_rx_good, mask);
+	__set_bit(EFCT_STAT_port_rx_bad_bytes, mask);
+	__set_bit(EFCT_STAT_port_rx_pause, mask);
+	__set_bit(EFCT_STAT_port_rx_unicast, mask);
+	__set_bit(EFCT_STAT_port_rx_broadcast, mask);
+	__set_bit(EFCT_STAT_port_rx_lt64, mask);
+	__set_bit(EFCT_STAT_port_rx_64, mask);
+	__set_bit(EFCT_STAT_port_rx_65_to_127, mask);
+	__set_bit(EFCT_STAT_port_rx_128_to_255, mask);
+	__set_bit(EFCT_STAT_port_rx_256_to_511, mask);
+	__set_bit(EFCT_STAT_port_rx_512_to_1023, mask);
+	__set_bit(EFCT_STAT_port_rx_1024_to_15xx, mask);
+	__set_bit(EFCT_STAT_port_rx_15xx_to_jumbo, mask);
+	__set_bit(EFCT_STAT_port_rx_gtjumbo, mask);
+	__set_bit(EFCT_STAT_port_rx_bad, mask);
+	__set_bit(EFCT_STAT_port_rx_align_error, mask);
+	__set_bit(EFCT_STAT_port_rx_bad_gtjumbo, mask);
+	__set_bit(EFCT_STAT_port_rx_length_error, mask);
+	__set_bit(EFCT_STAT_port_rx_nodesc_drops, mask);
+	__set_bit(EFCT_STAT_port_pm_discard_vfifo_full, mask);
+	__set_bit(EFCT_STAT_port_rxdp_q_disabled_pkts, mask);
+	__set_bit(EFCT_STAT_port_rxdp_di_dropped_pkts, mask);
+	__set_bit(EFCT_STAT_port_ctpio_underflow_fail, mask);
+	__set_bit(EFCT_STAT_port_ctpio_success, mask);
+	__set_bit(GENERIC_STAT_rx_drops, mask);
+	__set_bit(GENERIC_STAT_tx_drops, mask);
+}
+
+#define EFCT_DMA_STAT(ext_name, mcdi_name)			\
+	[EFCT_STAT_ ## ext_name] =				\
+	{ #ext_name, 64, 8 * MC_CMD_MAC_ ## mcdi_name }
+
+static const struct efct_hw_stat_desc efct_stat_desc[EFCT_STAT_COUNT] = {
+	EFCT_DMA_STAT(port_tx_bytes, TX_BYTES),
+	EFCT_DMA_STAT(port_tx_packets, TX_PKTS),
+	EFCT_DMA_STAT(port_tx_pause, TX_PAUSE_PKTS),
+	EFCT_DMA_STAT(port_tx_unicast, TX_UNICAST_PKTS),
+	EFCT_DMA_STAT(port_tx_multicast, TX_MULTICAST_PKTS),
+	EFCT_DMA_STAT(port_tx_broadcast, TX_BROADCAST_PKTS),
+	EFCT_DMA_STAT(port_tx_lt64, TX_LT64_PKTS),
+	EFCT_DMA_STAT(port_tx_64, TX_64_PKTS),
+	EFCT_DMA_STAT(port_tx_65_to_127, TX_65_TO_127_PKTS),
+	EFCT_DMA_STAT(port_tx_128_to_255, TX_128_TO_255_PKTS),
+	EFCT_DMA_STAT(port_tx_256_to_511, TX_256_TO_511_PKTS),
+	EFCT_DMA_STAT(port_tx_512_to_1023, TX_512_TO_1023_PKTS),
+	EFCT_DMA_STAT(port_tx_1024_to_15xx, TX_1024_TO_15XX_PKTS),
+	EFCT_DMA_STAT(port_tx_15xx_to_jumbo, TX_15XX_TO_JUMBO_PKTS),
+	EFCT_DMA_STAT(port_rx_bytes, RX_BYTES),
+	EFCT_DMA_STAT(port_rx_packets, RX_PKTS),
+	EFCT_DMA_STAT(port_rx_good, RX_GOOD_PKTS),
+	EFCT_DMA_STAT(port_rx_bad, RX_BAD_FCS_PKTS),
+	EFCT_DMA_STAT(port_rx_bad_bytes, RX_BAD_BYTES),
+	EFCT_DMA_STAT(port_rx_pause, RX_PAUSE_PKTS),
+	EFCT_DMA_STAT(port_rx_unicast, RX_UNICAST_PKTS),
+	EFCT_DMA_STAT(port_rx_multicast, RX_MULTICAST_PKTS),
+	EFCT_DMA_STAT(port_rx_broadcast, RX_BROADCAST_PKTS),
+	EFCT_DMA_STAT(port_rx_lt64, RX_UNDERSIZE_PKTS),
+	EFCT_DMA_STAT(port_rx_64, RX_64_PKTS),
+	EFCT_DMA_STAT(port_rx_65_to_127, RX_65_TO_127_PKTS),
+	EFCT_DMA_STAT(port_rx_128_to_255, RX_128_TO_255_PKTS),
+	EFCT_DMA_STAT(port_rx_256_to_511, RX_256_TO_511_PKTS),
+	EFCT_DMA_STAT(port_rx_512_to_1023, RX_512_TO_1023_PKTS),
+	EFCT_DMA_STAT(port_rx_1024_to_15xx, RX_1024_TO_15XX_PKTS),
+	EFCT_DMA_STAT(port_rx_15xx_to_jumbo, RX_15XX_TO_JUMBO_PKTS),
+	EFCT_DMA_STAT(port_rx_gtjumbo, RX_GTJUMBO_PKTS),
+	EFCT_DMA_STAT(port_rx_bad_gtjumbo, RX_JABBER_PKTS),
+	EFCT_DMA_STAT(port_rx_align_error, RX_ALIGN_ERROR_PKTS),
+	EFCT_DMA_STAT(port_rx_length_error, RX_LENGTH_ERROR_PKTS),
+	EFCT_DMA_STAT(port_rx_overflow, RX_OVERFLOW_PKTS),
+	EFCT_DMA_STAT(port_rx_nodesc_drops, RX_NODESC_DROPS),
+	EFCT_DMA_STAT(port_pm_discard_vfifo_full, PM_DISCARD_VFIFO_FULL),
+	EFCT_DMA_STAT(port_rxdp_q_disabled_pkts, RXDP_Q_DISABLED_PKTS),
+	EFCT_DMA_STAT(port_rxdp_di_dropped_pkts, RXDP_DI_DROPPED_PKTS),
+	EFCT_DMA_STAT(port_ctpio_underflow_fail, CTPIO_UNDERFLOW_FAIL),
+	EFCT_DMA_STAT(port_ctpio_success, CTPIO_SUCCESS),
+	EFCT_GENERIC_SW_STAT(rx_drops),
+	EFCT_GENERIC_SW_STAT(tx_drops),
+};
+
+static size_t efct_describe_stats(struct efct_nic *efct, u8 *names)
+{
+	DECLARE_BITMAP(mask, EFCT_STAT_COUNT) = {};
+
+	efct_ethtool_stat_mask(mask);
+	return efct_nic_describe_stats(efct_stat_desc, EFCT_STAT_COUNT, mask, names);
+}
+
+static void efct_update_sw_stats(struct efct_nic *efct, u64 *stats)
+{
+	stats[GENERIC_STAT_rx_drops] = atomic64_read(&efct->n_rx_sw_drops);
+	stats[GENERIC_STAT_tx_drops] = atomic64_read(&efct->n_tx_sw_drops);
+}
+
+size_t efct_update_stats_common(struct efct_nic *efct, u64 *full_stats,
+				struct rtnl_link_stats64 *core_stats)
+{
+	struct efct_nic_data *nic_data = efct->nic_data;
+	DECLARE_BITMAP(mask, EFCT_STAT_COUNT) = {};
+	u64 *stats = nic_data->stats;
+	int stats_count = 0, index;
+
+	efct_ethtool_stat_mask(mask);
+
+	if (full_stats) {
+		for_each_set_bit(index, mask, EFCT_STAT_COUNT) {
+			if (efct_stat_desc[index].name) {
+				*full_stats++ = stats[index];
+				++stats_count;
+			}
+		}
+	}
+	if (core_stats) {
+		core_stats->rx_packets = stats[EFCT_STAT_port_rx_packets];
+		core_stats->tx_packets = stats[EFCT_STAT_port_tx_packets];
+		core_stats->rx_bytes = stats[EFCT_STAT_port_rx_bytes];
+		core_stats->tx_bytes = stats[EFCT_STAT_port_tx_bytes];
+		core_stats->rx_dropped = stats[EFCT_STAT_port_rx_nodesc_drops] +
+				stats[GENERIC_STAT_rx_drops] +
+				stats[EFCT_STAT_port_pm_discard_vfifo_full] +
+				stats[EFCT_STAT_port_rxdp_q_disabled_pkts] +
+				stats[EFCT_STAT_port_rxdp_di_dropped_pkts];
+		core_stats->tx_dropped = stats[GENERIC_STAT_tx_drops];
+		core_stats->multicast = stats[EFCT_STAT_port_rx_multicast];
+		core_stats->rx_length_errors =
+				stats[EFCT_STAT_port_rx_gtjumbo] +
+				stats[EFCT_STAT_port_rx_length_error];
+		core_stats->rx_crc_errors = stats[EFCT_STAT_port_rx_bad];
+		core_stats->rx_frame_errors =
+				stats[EFCT_STAT_port_rx_align_error];
+		core_stats->rx_fifo_errors = stats[EFCT_STAT_port_rx_overflow];
+		core_stats->rx_errors = (core_stats->rx_length_errors +
+				core_stats->rx_crc_errors +
+				core_stats->rx_frame_errors);
+	}
+
+	return stats_count;
+}
+
+static void efct_update_stats(struct efct_nic *efct, bool force)
+{
+	struct efct_nic_data *nic_data = efct->nic_data;
+	DECLARE_BITMAP(mask, EFCT_STAT_COUNT) = {};
+	u64 *stats = nic_data->stats;
+	int rc = -1;
+
+	efct_common_stat_mask(mask);
+	efct_ethtool_stat_mask(mask);
+
+	mutex_lock(&efct->state_lock);
+	if (efct->state == STATE_NET_UP || force) {
+		rc = efct_mcdi_mac_stats(efct, EFCT_STATS_NODMA, 0,
+					 efct->mc_mac_stats, efct->num_mac_stats * sizeof(__le64));
+	}
+	mutex_unlock(&efct->state_lock);
+
+	if (rc)
+		return;
+
+	spin_lock_bh(&efct->stats_lock);
+	efct_nic_update_stats(efct_stat_desc, EFCT_STAT_COUNT, mask,
+			      stats, efct->mc_initial_stats, efct->mc_mac_stats);
+	efct_update_sw_stats(efct, stats);
+	spin_unlock_bh(&efct->stats_lock);
+}
+
+static int efct_nic_reset_stats(struct efct_nic *efct)
+{
+	return efct_mcdi_mac_stats(efct, EFCT_STATS_NODMA, 0, efct->mc_initial_stats,
+				  efct->num_mac_stats * sizeof(__le64));
+}
+
+static void efct_pull_stats(struct efct_nic *efct)
+{
+	if (!efct->stats_initialised) {
+		efct_reset_sw_stats(efct);
+		efct_nic_reset_stats(efct);
+		efct->stats_initialised = true;
+	}
+}
+
+/**
+ * efct_nic_describe_stats - Describe supported statistics for ethtool
+ * @desc: Array of &struct efct_hw_stat_desc describing the statistics
+ * @count: Length of the @desc array
+ * @mask: Bitmask of which elements of @desc are enabled
+ * @names: Buffer to copy names to, or %NULL.  The names are copied
+ *	starting at intervals of %ETH_GSTRING_LEN bytes.
+ *
+ * Returns the number of visible statistics, i.e. the number of set
+ * bits in the first @count bits of @mask for which a name is defined.
+ */
+int efct_nic_describe_stats(const struct efct_hw_stat_desc *desc, size_t count,
+			    const unsigned long *mask, u8 *names)
+{
+	int visible = 0;
+	int index;
+
+	for_each_set_bit(index, mask, count) {
+		if (desc[index].name) {
+			if (names) {
+				strscpy(names, desc[index].name, ETH_GSTRING_LEN);
+				names += ETH_GSTRING_LEN;
+			}
+			++visible;
+		}
+	}
+
+	return visible;
+}
+
+/**
+ * efct_nic_update_stats - Convert statistics DMA buffer to array of u64
+ * @desc: Array of &struct efct_hw_stat_desc describing the DMA buffer
+ *	layout.  DMA widths of 0, 16, 32 and 64 are supported; where
+ *	the width is specified as 0 the corresponding element of
+ *	@stats is not updated.
+ * @count: Length of the @desc array
+ * @mask: Bitmask of which elements of @desc are enabled
+ * @stats: Buffer to update with the converted statistics.  The length
+ *	of this array must be at least @count.
+ * @mc_initial_stats: Copy of DMA buffer containing initial stats. Subtracted
+ *	from the stats in mc_stats.
+ * @mc_stats: DMA buffer containing hardware statistics
+ */
+void efct_nic_update_stats(const struct efct_hw_stat_desc *desc, size_t count,
+			   const unsigned long *mask, u64 *stats,
+			  const void *mc_initial_stats, const void *mc_stats)
+{
+	__le64 zero = 0;
+	size_t index;
+
+	for_each_set_bit(index, mask, count) {
+		if (desc[index].dma_width) {
+			const void *addr = mc_stats ? mc_stats + desc[index].offset : &zero;
+			const void *init = mc_initial_stats && mc_stats ? mc_initial_stats +
+					   desc[index].offset : &zero;
+
+			switch (desc[index].dma_width) {
+			case 16:
+				stats[index] = le16_to_cpup((__le16 *)addr) -
+						le16_to_cpup((__le16 *)init);
+				break;
+			case 32:
+				stats[index] = le32_to_cpup((__le32 *)addr) -
+						le32_to_cpup((__le32 *)init);
+				break;
+			case 64:
+				stats[index] = le64_to_cpup((__le64 *)addr) -
+						le64_to_cpup((__le64 *)init);
+				break;
+			default:
+				WARN_ON_ONCE(1);
+				stats[index] = 0;
+				break;
+			}
+		}
+	}
+}
+
+static u32 efct_check_caps(const struct efct_nic *efct, u8 flag, u32 offset)
+{
+	switch (offset) {
+	case(MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS1_OFST):
+		return efct->datapath_caps & BIT_ULL(flag);
+	case(MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS2_OFST):
+		return efct->datapath_caps2 & BIT_ULL(flag);
+	default:
+		return 0;
+	}
+	return 0;
+}
+
+static int efct_reconfigure_mac(struct efct_nic *efct)
+{
+	int rc;
+
+	WARN_ON(!mutex_is_locked(&efct->mac_lock));
+
+	rc = efct_mcdi_set_mac(efct);
+	if (rc)
+		netif_err(efct, drv, efct->net_dev,
+			  "efct_mcdi_set_mac failed\n");
+
+	return rc;
+}
+
+static int efct_map_reset_flags(u32 *flags)
+{
+	enum {
+		EFCT_RESET_PORT = ((ETH_RESET_MAC | ETH_RESET_PHY) <<
+				ETH_RESET_SHARED_SHIFT),
+		EFCT_RESET_MC = ((ETH_RESET_DMA | ETH_RESET_FILTER |
+					ETH_RESET_MAC | ETH_RESET_PHY | ETH_RESET_MGMT) <<
+					ETH_RESET_SHARED_SHIFT)
+	};
+
+	if ((*flags & EFCT_RESET_MC) == EFCT_RESET_MC) {
+		*flags &= ~EFCT_RESET_MC;
+		return RESET_TYPE_WORLD;
+	}
+
+	if ((*flags & EFCT_RESET_PORT) == EFCT_RESET_PORT) {
+		*flags &= ~EFCT_RESET_PORT;
+		return RESET_TYPE_ALL;
+	}
+
+	/* no invisible reset implemented */
+	return -EINVAL;
+}
+
+static enum reset_type efct_map_reset_reason(enum reset_type reason)
+{
+	if (reason == RESET_TYPE_MC_FAILURE)
+		return RESET_TYPE_DATAPATH;
+	else if (reason == RESET_TYPE_MC_BIST)
+		return reason;
+	else if (reason == RESET_TYPE_MCDI_TIMEOUT)
+		return reason;
+	else
+		return RESET_TYPE_ALL;
+}
+
+static int efct_type_reset(struct efct_nic *efct, enum reset_type reset_type)
+{
+	u32 attach_flags;
+	bool was_up;
+	int rc = 0;
+
+	if (efct->net_dev)
+		was_up = netif_running(efct->net_dev);
+	else
+		return -EINVAL;
+
+	if (efct->reset_pending & (1 << RESET_TYPE_MCDI_TIMEOUT))
+		return efct_flr(efct);
+
+	if (was_up) {
+		netif_device_detach(efct->net_dev);
+		dev_close(efct->net_dev);
+	}
+
+	/* Bring down filter table */
+	if (reset_type != RESET_TYPE_DATAPATH) {
+		rc = efct_filter_table_down(efct);
+		if (rc)
+			goto err;
+	}
+	rc = efct_mcdi_reset(efct, reset_type);
+	if (rc)
+		goto err;
+
+	efct->last_reset = jiffies;
+
+	rc = efct_mcdi_drv_attach(efct, MC_CMD_FW_FULL_FEATURED, &attach_flags, true);
+	if (rc) {
+		/* This is not fatal as there are no fw variants */
+		netif_warn(efct, drv, efct->net_dev,
+			   "failed to re-attach driver after reset rc=%d\n", rc);
+	}
+	/* Bring up filter table */
+	rc = efct_filter_table_up(efct);
+	if (rc)
+		goto err;
+
+	/* Resetting statistics */
+	netif_info(efct, drv, efct->net_dev, "Resetting statistics.\n");
+	efct->stats_initialised = false;
+	efct->type->pull_stats(efct);
+	if (was_up) {
+		netif_device_attach(efct->net_dev);
+		return dev_open(efct->net_dev, NULL);
+	}
+
+	/* Update stats forcefully so stats are reset when interface was already down */
+	efct->type->update_stats(efct, true);
+err:
+	return rc;
+}
+
+static int efct_type_get_phys_port_id(struct efct_nic *efct, struct netdev_phys_item_id *ppid)
+{
+	if (!is_valid_ether_addr(efct->net_dev->dev_addr))
+		return -EOPNOTSUPP;
+
+	ppid->id_len = ETH_ALEN;
+	memcpy(ppid->id, efct->net_dev->dev_addr, ppid->id_len);
+
+	return 0;
+}
+
+static void efct_mcdi_reboot_detected(struct efct_nic *efct)
+{
+	/*dummy function*/
+}
+
+static int efct_type_irq_test_generate(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_TRIGGER_INTERRUPT_IN_LEN);
+	int index;
+
+	// 2nd port of PF
+	index = (efct->port_num == 2) || (efct->port_num == 3);
+	BUILD_BUG_ON(MC_CMD_TRIGGER_INTERRUPT_OUT_LEN != 0);
+
+	MCDI_SET_DWORD(inbuf, TRIGGER_INTERRUPT_IN_INTR_LEVEL, index * EFCT_MSIX_PER_PORT);
+
+	return efct_mcdi_rpc_quiet(efct, MC_CMD_TRIGGER_INTERRUPT, inbuf, sizeof(inbuf),
+				  NULL, 0, NULL);
+}
+
+static void efct_type_ev_test_generate(struct efct_ev_queue *evq)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_DRIVER_EVENT_IN_LEN);
+	struct efct_nic *efct = evq->efct;
+	union efct_qword event;
+	int rc;
+
+	EFCT_POPULATE_QWORD_2(event,
+			      ESF_HZ_EV_TYPE, ESE_HZ_XN_EVENT_TYPE_DRIVER,
+			      ESF_HZ_DRIVER_DATA, EFCT_TEST);
+
+	MCDI_SET_DWORD(inbuf, DRIVER_EVENT_IN_EVQ, evq->index);
+
+	/* MCDI_SET_QWORD is not appropriate here since EFCT_POPULATE_* has
+	 * already swapped the data to little-endian order.
+	 */
+	memcpy(MCDI_PTR(inbuf, DRIVER_EVENT_IN_DATA), &event.u64[0],
+	       sizeof(union efct_qword));
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_DRIVER_EVENT, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+	if (rc && (rc != -ENETDOWN))
+		goto fail;
+
+	return;
+
+fail:
+	netif_err(efct, hw, efct->net_dev, "%s: failed rc=%d\n", __func__, rc);
+}
+
+const struct efct_nic_type efct_nic_type = {
+	.probe = efct_probe_main,
+	.remove = efct_remove_main,
+	.mcdi_max_ver = 2,
+	.mcdi_rpc_timeout = efct_mcdi_rpc_timeout,
+	.mcdi_request = efct_mcdi_request,
+	.mcdi_poll_response = efct_mcdi_poll_response,
+	.mcdi_read_response = efct_mcdi_read_response,
+	.mcdi_poll_reboot = mcdi_poll_reboot,
+	.mcdi_get_buf = efct_mcdi_get_buf,
+	.mcdi_put_buf = efct_mcdi_put_buf,
+	.mem_bar = NULL,
+	.ev_probe = efct_ev_probe,
+	.ev_init = efct_ev_init,
+	.ev_remove = efct_ev_remove,
+	.ev_fini = efct_ev_fini,
+	.ev_purge = efct_ev_purge,
+	.ev_process = efct_ev_process,
+	.irq_handle_msix = efct_msix_handler,
+	.describe_stats = efct_describe_stats,
+	.update_stats = efct_update_stats,
+	.pull_stats = efct_pull_stats,
+	.check_caps = efct_check_caps,
+	.reconfigure_mac = efct_reconfigure_mac,
+	.map_reset_flags = efct_map_reset_flags,
+	.map_reset_reason = efct_map_reset_reason,
+	.reset = efct_type_reset,
+	.has_dynamic_sensors = efct_has_dynamic_sensors,
+	.get_phys_port_id = efct_type_get_phys_port_id,
+	.mcdi_reboot_detected = efct_mcdi_reboot_detected,
+	.irq_test_generate = efct_type_irq_test_generate,
+	.ev_test_generate = efct_type_ev_test_generate,
+};
diff --git a/drivers/net/ethernet/amd/efct/efct_nic.h b/drivers/net/ethernet/amd/efct/efct_nic.h
new file mode 100644
index 000000000000..7745d21e92bb
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_nic.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_NIC_H
+#define EFCT_NIC_H
+
+#include "efct_driver.h"
+
+/* NIC-generic software stats */
+enum {
+	GENERIC_STAT_rx_drops,
+	GENERIC_STAT_tx_drops,
+	GENERIC_STAT_COUNT
+};
+
+#define EFCT_GENERIC_SW_STAT(ext_name)                          \
+	[GENERIC_STAT_ ## ext_name] = { #ext_name, 0, 0 }
+
+enum {
+	EFCT_STAT_port_tx_bytes = GENERIC_STAT_COUNT,
+	EFCT_STAT_port_tx_packets,
+	EFCT_STAT_port_tx_pause,
+	EFCT_STAT_port_tx_unicast,
+	EFCT_STAT_port_tx_multicast,
+	EFCT_STAT_port_tx_broadcast,
+	EFCT_STAT_port_tx_lt64,
+	EFCT_STAT_port_tx_64,
+	EFCT_STAT_port_tx_65_to_127,
+	EFCT_STAT_port_tx_128_to_255,
+	EFCT_STAT_port_tx_256_to_511,
+	EFCT_STAT_port_tx_512_to_1023,
+	EFCT_STAT_port_tx_1024_to_15xx,
+	EFCT_STAT_port_tx_15xx_to_jumbo,
+	EFCT_STAT_port_rx_bytes,
+	EFCT_STAT_port_rx_packets,
+	EFCT_STAT_port_rx_good,
+	EFCT_STAT_port_rx_bad,
+	EFCT_STAT_port_rx_bad_bytes,
+	EFCT_STAT_port_rx_pause,
+	EFCT_STAT_port_rx_unicast,
+	EFCT_STAT_port_rx_multicast,
+	EFCT_STAT_port_rx_broadcast,
+	EFCT_STAT_port_rx_lt64,
+	EFCT_STAT_port_rx_64,
+	EFCT_STAT_port_rx_65_to_127,
+	EFCT_STAT_port_rx_128_to_255,
+	EFCT_STAT_port_rx_256_to_511,
+	EFCT_STAT_port_rx_512_to_1023,
+	EFCT_STAT_port_rx_1024_to_15xx,
+	EFCT_STAT_port_rx_15xx_to_jumbo,
+	EFCT_STAT_port_rx_gtjumbo,
+	EFCT_STAT_port_rx_bad_gtjumbo,
+	EFCT_STAT_port_rx_align_error,
+	EFCT_STAT_port_rx_length_error,
+	EFCT_STAT_port_rx_overflow,
+	EFCT_STAT_port_rx_nodesc_drops,
+	EFCT_STAT_port_pm_discard_vfifo_full,
+	EFCT_STAT_port_rxdp_q_disabled_pkts,
+	EFCT_STAT_port_rxdp_di_dropped_pkts,
+	EFCT_STAT_port_ctpio_underflow_fail,
+	EFCT_STAT_port_ctpio_success,
+	EFCT_STAT_COUNT
+};
+
+struct efct_nic_data {
+	struct efct_nic *efct;
+	u64 stats[EFCT_STAT_COUNT];
+};
+
+struct efct_self_tests {
+	/* online tests */
+	int phy_alive;
+	int interrupt;
+	int *eventq_dma;
+	int *eventq_int;
+};
+
+#define EFCT_TEST  1
+
+#define EFCT_DRVGEN_CODE(_magic)	((_magic) & 0xff)
+
+extern const struct efct_nic_type efct_nic_type;
+int efct_init_datapath_caps(struct efct_nic *efct);
+int efct_start_evqs(struct efct_nic *efct);
+void efct_stop_evqs(struct efct_nic *efct);
+size_t efct_update_stats_common(struct efct_nic *efct, u64 *full_stats,
+				struct rtnl_link_stats64 *core_stats);
+int efct_nic_describe_stats(const struct efct_hw_stat_desc *desc, size_t count,
+			    const unsigned long *mask, u8 *names);
+void efct_nic_update_stats(const struct efct_hw_stat_desc *desc, size_t count,
+			   const unsigned long *mask, u64 *stats,
+			   const void *mc_initial_stats, const void *mc_stats);
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+void efct_init_mcdi_logging(struct efct_device *efct_dev);
+void efct_fini_mcdi_logging(struct efct_device *efct_dev);
+#else
+static inline void efct_init_mcdi_logging(struct efct_device *efct_dev) {}
+static inline void efct_fini_mcdi_logging(struct efct_device *efct_dev) {}
+#endif
+#endif
diff --git a/drivers/net/ethernet/amd/efct/efct_pci.c b/drivers/net/ethernet/amd/efct/efct_pci.c
new file mode 100644
index 000000000000..af76ae37e040
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_pci.c
@@ -0,0 +1,1077 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include "efct_driver.h"
+#include "efct_io.h"
+#include "efct_reg.h"
+#include "efct_common.h"
+#include "efct_netdev.h"
+#include "efct_nic.h"
+
+/**************************************************************************
+ *
+ * Configurable values
+ *
+ *************************************************************************/
+
+#define EFCT_PCI_DEFAULT_BAR	0
+#define HOST_NIC_MAGIC_RESET 0xEFC7FA57 //TODO remove when HW reg file is updated
+/* Number of bytes at start of vendor specified extended capability that indicate
+ * that the capability is vendor specified. i.e. offset from value returned by
+ * pci_find_next_ext_capability() to beginning of vendor specified capability
+ * header.
+ */
+#define PCI_EXT_CAP_HDR_LENGTH  4
+
+/* Expected size of a Xilinx continuation
+ * address table entry.
+ */
+#define ESE_GZ_CFGBAR_CONT_CAP_MIN_LENGTH      16
+
+/* Total 19 parameters are there 0 - 18. PAD bit is not mandatory */
+#define EFCT_REQRD_DESIGN_PARAMS 0x7FFFE
+
+static int efct_pci_walk_xilinx_table
+			(struct efct_device *efct_dev,
+			 u64 offset,
+			 struct efct_func_ctl_window *result);
+
+/* Number of bytes to offset when reading bit position x with dword accessors. */
+#define ROUND_DOWN_TO_DWORD(x) (((x) & (~31)) >> 3)
+
+/* PCIe link bandwidth measure:
+ * bw = (width << (speed - 1))
+ */
+#define EFCT_BW_PCIE_GEN3_X8  (8  << (3 - 1))
+#define EFCT_BW_PCIE_GEN3_X16 (16 << (3 - 1))
+
+#define EXTRACT_BITS(x, lbn, width) \
+			(((x) >> ((lbn) & (31))) & (((1ull) << (width)) - 1))
+
+enum efct_tlv_state_machine {
+	EFCT_TLV_TYPE,
+	EFCT_TLV_TYPE_CONT,
+	EFCT_TLV_LENGTH,
+	EFCT_TLV_VALUE
+};
+
+struct efct_tlv_state {
+	enum efct_tlv_state_machine state;
+	u64 value;
+	u32 value_offset;
+	u16 type;
+	u8 len;
+};
+
+static u32 _efct_pci_get_bar_bits_with_width
+			(struct efct_device *efct_dev,
+			 int structure_start, int lbn, int width)
+{
+	union efct_dword dword;
+
+	efct_readd(&dword,  efct_dev->membase +
+			efct_reg(efct_dev, structure_start + ROUND_DOWN_TO_DWORD(lbn)));
+
+	return EXTRACT_BITS(le32_to_cpu(dword.word32), lbn, width);
+}
+
+static int efct_acquire_msix_vectors(struct efct_device *efct_dev, int nvec)
+{
+	int i, j, rc, index;
+
+	efct_dev->xentries = kmalloc_array(nvec, sizeof(*efct_dev->xentries), GFP_KERNEL);
+	if (!efct_dev->xentries)
+		return -ENOMEM;
+
+	for (j = 0; j < efct_dev->num_ports; j++) {
+		for (i = 0; i < (nvec / efct_dev->num_ports); i++) {
+			index = i + (j * nvec / efct_dev->num_ports);
+			efct_dev->xentries[index].entry = (EFCT_MSIX_PER_PORT * j) + i;
+		}
+	}
+	rc = pci_enable_msix_range(efct_dev->pci_dev, efct_dev->xentries, nvec, nvec);
+	if (rc < 0) {
+		pci_disable_msix(efct_dev->pci_dev);
+		kfree(efct_dev->xentries);
+	}
+
+	return rc;
+}
+
+static int efct_alloc_msix(struct efct_device *efct_dev)
+{
+	int num_vec, min_irq_per_port;
+	int nvec_allocated = 0;
+
+	/*Maximum event queues available*/
+	num_vec = efct_dev->params.num_evq * efct_dev->num_ports;
+	num_vec = min_t(u32, num_vec, pci_msix_vec_count(efct_dev->pci_dev));
+
+	nvec_allocated = efct_acquire_msix_vectors(efct_dev, num_vec);
+
+	if (nvec_allocated == -ENOSPC) {
+		/*Minimum irq needed, is the sum of RXQ,one TXQ for net driver and minimum
+		 * * of one irq for AUX clients
+		 */
+		min_irq_per_port = efct_dev->params.rx_queues
+				+ EFCT_MAX_CORE_TX_QUEUES + MIN_AUX_IRQ;
+		num_vec = efct_dev->num_ports * min_irq_per_port;
+		nvec_allocated = efct_acquire_msix_vectors(efct_dev, num_vec);
+	}
+
+	if (nvec_allocated < 0) {
+		pci_err(efct_dev->pci_dev, "could not enable %d MSI-X\n", num_vec);
+		return nvec_allocated;
+	}
+
+	/*Number of allocated vectors per port*/
+	efct_dev->vec_per_port = (nvec_allocated / efct_dev->num_ports);
+	return 0;
+}
+
+static void efct_assign_msix(struct efct_nic *efct, int index)
+{
+	int i, j;
+
+	for_each_set_bit(i, &efct->evq_active_mask, efct->max_evq_count) {
+		j = (index * efct->efct_dev->vec_per_port) + i;
+		efct->evq[i].msi.irq = efct->efct_dev->xentries[j].vector;
+	}
+}
+
+static void efct_free_msix(struct efct_device *efct_dev)
+{
+	kfree(efct_dev->xentries);
+	pci_disable_msix(efct_dev->pci_dev);
+}
+
+#define efct_pci_get_bar_bits(efct_dev, entry_location, bitdef) \
+	_efct_pci_get_bar_bits_with_width(efct_dev, entry_location, \
+		bitdef ## _LBN, bitdef ## _WIDTH)
+
+static int efct_pci_parse_efct_entry
+			(struct efct_device *efct_dev, int entry_location,
+			 struct efct_func_ctl_window *result)
+{
+	u16 project_id;
+	u8 table_type;
+	u8 type_rev;
+	u64 offset;
+	u32 bar;
+
+	bar = efct_pci_get_bar_bits(efct_dev, entry_location + EFCT_VSEC_TABLE_ENTRY_OFFSET,
+				    ERF_HZ_FUNC_CTL_WIN_BAR);
+	offset = efct_pci_get_bar_bits(efct_dev, entry_location + EFCT_VSEC_TABLE_ENTRY_OFFSET,
+				       ERF_HZ_FUNC_CTL_WIN_OFF_16B);
+	project_id = efct_pci_get_bar_bits(efct_dev, entry_location + EFCT_VSEC_TABLE_ENTRY_OFFSET,
+					   ERF_HZ_PROJECT_ID);
+	type_rev =  efct_pci_get_bar_bits(efct_dev, entry_location + EFCT_VSEC_TABLE_ENTRY_OFFSET,
+					  ERF_HZ_TYPE_REVISION);
+	table_type = efct_pci_get_bar_bits(efct_dev, entry_location + EFCT_VSEC_TABLE_ENTRY_OFFSET,
+					   ERF_HZ_TABLE_TYPE);
+	pci_dbg(efct_dev->pci_dev, "Found efct function control window bar=%d offset=0x%llx\n",
+		bar, offset);
+
+	if (result->valid) {
+		pci_err(efct_dev->pci_dev, "Duplicated efct table entry.\n");
+		return -EINVAL;
+	}
+
+	if (project_id != EFCT_VSEC_ENTRY_PROJECT_ID_VAL) {
+		pci_err(efct_dev->pci_dev, "Bad Project ID value of 0x%x in Xilinx capabilities efct entry.\n",
+			project_id);
+		return -EINVAL;
+	}
+
+	if (bar == ESE_GZ_CFGBAR_EFCT_BAR_NUM_EXPANSION_ROM ||
+	    bar == ESE_GZ_CFGBAR_EFCT_BAR_NUM_INVALID) {
+		pci_err(efct_dev->pci_dev, "Bad BAR value of %d in Xilinx capabilities efct entry.\n",
+			bar);
+		return -EINVAL;
+	}
+
+	if (type_rev != EFCT_VSEC_ENTRY_TYPE_REV_VAL) {
+		pci_err(efct_dev->pci_dev, "Bad Type revision value of 0x%x in Xilinx capabilities efct entry.\n",
+			type_rev);
+		return -EINVAL;
+	}
+
+	if (table_type != EFCT_VSEC_ENTRY_TABLE_TYPE_VAL) {
+		pci_err(efct_dev->pci_dev, "Bad Table type value of 0x%x in Xilinx capabilities efct entry.\n",
+			table_type);
+		return -EINVAL;
+	}
+
+	result->bar = bar;
+	result->offset = offset;
+	result->valid = true;
+	return 0;
+}
+
+static bool efct_pci_does_bar_overflow
+			(struct efct_device *efct_dev, int bar,
+			 u64 next_entry)
+{
+	return next_entry + ESE_GZ_CFGBAR_ENTRY_HEADER_SIZE >
+		pci_resource_len(efct_dev->pci_dev, bar);
+}
+
+/* Parse a Xilinx capabilities table entry describing a continuation to a new
+ * sub-table.
+ */
+static int efct_pci_parse_continue_entry
+			(struct efct_device *efct_dev, int entry_location,
+			 struct efct_func_ctl_window *result)
+{
+	union efct_oword entry;
+	u32 previous_bar;
+	u64 offset;
+	int rc = 0;
+	u32 bar;
+
+	efct_reado(efct_dev, &entry, efct_dev->membase + efct_reg(efct_dev, entry_location));
+
+	bar = EFCT_OWORD_FIELD32(entry, ESF_GZ_CFGBAR_CONT_CAP_BAR);
+
+	offset = EFCT_OWORD_FIELD64(entry, ESF_GZ_CFGBAR_CONT_CAP_OFFSET) <<
+		ESE_GZ_CONT_CAP_OFFSET_BYTES_SHIFT;
+
+	previous_bar = efct_dev->mem_bar;
+
+	if (bar == ESE_GZ_VSEC_BAR_NUM_EXPANSION_ROM ||
+	    bar == ESE_GZ_VSEC_BAR_NUM_INVALID) {
+		pci_err(efct_dev->pci_dev, "Bad BAR value of %d in Xilinx capabilities sub-table.\n",
+			bar);
+		return -EINVAL;
+	}
+
+	if (bar != previous_bar) {
+		efct_fini_io(efct_dev);
+
+		if (efct_pci_does_bar_overflow(efct_dev, bar, offset)) {
+			pci_err(efct_dev->pci_dev, "Xilinx table will overrun BAR[%d] offset=0x%llx\n",
+				bar, offset);
+			return -EINVAL;
+		}
+
+		/* Temporarily map new BAR. */
+		rc = efct_init_io(efct_dev, bar, efct_dev->max_dma_mask,
+				  pci_resource_len(efct_dev->pci_dev, bar));
+		if (rc) {
+			pci_err(efct_dev->pci_dev,
+				"Mapping new BAR for Xilinx table failed, rc=%d\n", rc);
+			return rc;
+		}
+	}
+
+	rc = efct_pci_walk_xilinx_table(efct_dev, offset, result);
+	if (rc) {
+		pci_err(efct_dev->pci_dev,
+			"Iteration on Xilinx capabilities table failed, rc=%d\n", rc);
+		return rc;
+	}
+
+	if (bar != previous_bar) {
+		efct_fini_io(efct_dev);
+
+		/* Put old BAR back. */
+		rc = efct_init_io(efct_dev, previous_bar, efct_dev->max_dma_mask,
+				  pci_resource_len(efct_dev->pci_dev, previous_bar));
+		if (rc) {
+			pci_err(efct_dev->pci_dev, "Putting old BAR back failed, rc=%d\n", rc);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+/* Iterate over the Xilinx capabilities table in the currently mapped BAR and
+ * call efct_pci_parse_efct_entry() on any efct entries and
+ * efct_pci_parse_continue_entry() on any table continuations.
+ */
+static int efct_pci_walk_xilinx_table
+			(struct efct_device *efct_dev, u64 offset,
+			 struct efct_func_ctl_window *result)
+{
+	u64 current_entry = offset;
+	int rc = 0;
+
+	while (true) {
+		u32 id = efct_pci_get_bar_bits(efct_dev, current_entry, ERF_HZ_FORMAT_ID);
+		u32 last = efct_pci_get_bar_bits(efct_dev, current_entry, ERF_HZ_LAST_CAPABILITY);
+		u32 rev = efct_pci_get_bar_bits(efct_dev, current_entry, ERF_HZ_FORMAT_REV_CODE);
+		u32 entry_size;
+
+		if (id == ESE_GZ_CFGBAR_ENTRY_LAST)
+			return 0;
+
+		entry_size =
+			efct_pci_get_bar_bits(efct_dev, current_entry, ERF_HZ_LENGTH);
+
+		pci_dbg(efct_dev->pci_dev,
+			"Seen Xilinx table entry 0x%x size 0x%x at 0x%llx in BAR[%d]\n",
+			id, entry_size, current_entry, efct_dev->mem_bar);
+
+		if (entry_size < sizeof(uint32_t) * 2) {
+			pci_err(efct_dev->pci_dev,
+				"Xilinx table entry too short len=0x%x\n", entry_size);
+			return -EINVAL;
+		}
+
+		switch (id) {
+		case ESE_GZ_CFGBAR_ENTRY_EFCT:
+			if (rev != ESE_GZ_CFGBAR_ENTRY_REV_EFCT ||
+			    entry_size < ESE_GZ_CFGBAR_ENTRY_SIZE_EFCT) {
+				pci_err(efct_dev->pci_dev, "Bad length or rev for efct entry in Xilinx capabilities table. entry_size=%d rev=%d.\n",
+					entry_size, rev);
+				break;
+			}
+
+			rc = efct_pci_parse_efct_entry(efct_dev, current_entry, result);
+			if (rc) {
+				pci_err(efct_dev->pci_dev,
+					"Parsing efct entry failed, rc=%d\n", rc);
+				return rc;
+			}
+			break;
+		case ESE_GZ_CFGBAR_ENTRY_CONT_CAP_ADDR:
+			if (rev != 0 || entry_size < ESE_GZ_CFGBAR_CONT_CAP_MIN_LENGTH) {
+				pci_err(efct_dev->pci_dev, "Bad length or rev for continue entry in Xilinx capabilities table. entry_size=%d rev=%d.\n",
+					entry_size, rev);
+				return -EINVAL;
+			}
+
+			rc = efct_pci_parse_continue_entry(efct_dev, current_entry, result);
+			if (rc)
+				return rc;
+			break;
+		default:
+			/* Ignore unknown table entries. */
+			break;
+		}
+
+		if (last)
+			return 0;
+
+		current_entry += entry_size;
+
+		if (efct_pci_does_bar_overflow(efct_dev, efct_dev->mem_bar, current_entry)) {
+			pci_err(efct_dev->pci_dev, "Xilinx table overrun at position=0x%llx.\n",
+				current_entry);
+			return -EINVAL;
+		}
+	}
+}
+
+static int _efct_pci_get_config_bits_with_width
+			(struct efct_device *efct_dev,
+			 int structure_start, int lbn,
+			 int width, u32 *result)
+{
+	int pos = structure_start + ROUND_DOWN_TO_DWORD(lbn);
+	u32 temp;
+	int rc;
+
+	rc = pci_read_config_dword(efct_dev->pci_dev, pos, &temp);
+	if (rc) {
+		pci_err(efct_dev->pci_dev, "Failed to read PCI config dword at %d\n",
+			pos);
+		return rc;
+	}
+
+	*result = EXTRACT_BITS(temp, lbn, width);
+
+	return 0;
+}
+
+#define efct_pci_get_config_bits(efct_dev, entry_location, bitdef, result) \
+	_efct_pci_get_config_bits_with_width(efct_dev, entry_location,  \
+		bitdef ## _LBN, bitdef ## _WIDTH, result)
+
+/* Call efct_pci_walk_xilinx_table() for the Xilinx capabilities table pointed
+ * to by this PCI_EXT_CAP_ID_VNDR.
+ */
+static int efct_pci_parse_xilinx_cap
+			(struct efct_device *efct_dev, int vndr_cap,
+			 bool has_offset_hi,
+			 struct efct_func_ctl_window *result)
+{
+	u32 offset_high = 0;
+	u32 offset_lo = 0;
+	u64 offset = 0;
+	u32 bar = 0;
+	int rc = 0;
+
+	rc = efct_pci_get_config_bits(efct_dev, vndr_cap, ESF_GZ_VSEC_TBL_BAR, &bar);
+	if (rc) {
+		pci_err(efct_dev->pci_dev, "Failed to read ESF_GZ_VSEC_TBL_BAR, rc=%d\n",
+			rc);
+		return rc;
+	}
+
+	if (bar == ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_EXPANSION_ROM ||
+	    bar == ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_INVALID) {
+		pci_err(efct_dev->pci_dev, "Bad BAR value of %d in Xilinx capabilities sub-table.\n",
+			bar);
+		return -EINVAL;
+	}
+
+	rc = efct_pci_get_config_bits(efct_dev, vndr_cap, ESF_GZ_VSEC_TBL_OFF_LO, &offset_lo);
+	if (rc) {
+		pci_err(efct_dev->pci_dev, "Failed to read ESF_GZ_VSEC_TBL_OFF_LO, rc=%d\n",
+			rc);
+		return rc;
+	}
+
+	/* Get optional extension to 64bit offset. */
+	if (has_offset_hi) {
+		rc = efct_pci_get_config_bits(efct_dev,
+					      vndr_cap, ESF_GZ_VSEC_TBL_OFF_HI, &offset_high);
+		if (rc) {
+			pci_err(efct_dev->pci_dev, "Failed to read ESF_GZ_VSEC_TBL_OFF_HI, rc=%d\n",
+				rc);
+			return rc;
+		}
+	}
+
+	offset = (((u64)offset_lo) << ESE_GZ_VSEC_TBL_OFF_LO_BYTES_SHIFT) |
+		 (((u64)offset_high) << ESE_GZ_VSEC_TBL_OFF_HI_BYTES_SHIFT);
+
+	if (offset > pci_resource_len(efct_dev->pci_dev, bar) - sizeof(uint32_t) * 2) {
+		pci_err(efct_dev->pci_dev, "Xilinx table will overrun BAR[%d] offset=0x%llx\n",
+			bar, offset);
+		return -EINVAL;
+	}
+
+	/* Temporarily map BAR. */
+	rc = efct_init_io(efct_dev, bar, efct_dev->max_dma_mask,
+			  pci_resource_len(efct_dev->pci_dev, bar));
+	if (rc) {
+		pci_err(efct_dev->pci_dev, "efct_init_io failed, rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = efct_pci_walk_xilinx_table(efct_dev, offset, result);
+
+	/* Unmap temporarily mapped BAR. */
+	efct_fini_io(efct_dev);
+	return rc;
+}
+
+/* Call efct_pci_parse_efct_entry() for each Xilinx PCI_EXT_CAP_ID_VNDR
+ * capability.
+ */
+static int efct_pci_find_func_ctrl_window
+			(struct efct_device *efct_dev,
+			 struct efct_func_ctl_window *result)
+{
+	int num_xilinx_caps = 0;
+	int cap = 0;
+
+	result->valid = false;
+
+	while ((cap = pci_find_next_ext_capability(efct_dev->pci_dev, cap,
+						   PCI_EXT_CAP_ID_VNDR)) != 0) {
+		int vndr_cap = cap + PCI_EXT_CAP_HDR_LENGTH;
+		u32 vsec_ver = 0;
+		u32 vsec_len = 0;
+		u32 vsec_id = 0;
+		int rc = 0;
+
+		num_xilinx_caps++;
+
+		rc = efct_pci_get_config_bits(efct_dev, vndr_cap,
+					      ESF_HZ_PCI_EXPRESS_XCAP_ID, &vsec_id);
+		if (rc) {
+			pci_err(efct_dev->pci_dev,
+				"Failed to read ESF_HZ_PCI_EXPRESS_XCAP_ID, rc=%d\n",
+				rc);
+			return rc;
+		}
+
+		rc = efct_pci_get_config_bits(efct_dev, vndr_cap,
+					      ESF_HZ_PCI_EXPRESS_XCAP_VER, &vsec_ver);
+		if (rc) {
+			pci_err(efct_dev->pci_dev,
+				"Failed to read ESF_HZ_PCI_EXPRESS_XCAP_VER, rc=%d\n",
+				rc);
+			return rc;
+		}
+
+		/* Get length of whole capability - i.e. starting at cap */
+		rc = efct_pci_get_config_bits(efct_dev, vndr_cap, ESF_HZ_PCI_EXPRESS_XCAP_NEXT,
+					      &vsec_len);
+		if (rc) {
+			pci_err(efct_dev->pci_dev,
+				"Failed to read ESF_HZ_PCI_EXPRESS_XCAP_NEXT, rc=%d\n",
+				rc);
+			return rc;
+		}
+
+		if (vsec_id == ESE_GZ_XLNX_VSEC_ID &&
+		    vsec_ver == ESE_GZ_VSEC_VER_XIL_CFGBAR &&
+		    vsec_len >= ESE_GZ_VSEC_LEN_MIN) {
+			bool has_offset_hi = (vsec_len >= ESE_GZ_VSEC_LEN_HIGH_OFFT);
+
+			rc = efct_pci_parse_xilinx_cap(efct_dev, vndr_cap, has_offset_hi, result);
+			if (rc) {
+				pci_err(efct_dev->pci_dev,
+					"Failed to parse xilinx capabilities table, rc=%d", rc);
+				return rc;
+			}
+		}
+	}
+
+	if (num_xilinx_caps && !result->valid) {
+		pci_err(efct_dev->pci_dev, "Seen %d Xilinx tables, but no efct entry.\n",
+			num_xilinx_caps);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static u32 efct_device_check_pcie_link(struct pci_dev *pdev, u32 *actual_width,
+				       u32 *max_width, u32 *actual_speed,
+				       u32 *nic_bandwidth)
+{
+	int cap = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	u32 nic_speed;
+	u16 lnksta;
+	u16 lnkcap;
+
+	*actual_speed = 0;
+	*actual_width = 0;
+	*max_width = 0;
+	*nic_bandwidth = 0;
+
+	if (!cap ||
+	    pci_read_config_word(pdev, cap + PCI_EXP_LNKSTA, &lnksta) ||
+	    pci_read_config_word(pdev, cap + PCI_EXP_LNKCAP, &lnkcap))
+		return 0;
+
+	*actual_width = (lnksta & PCI_EXP_LNKSTA_NLW) >>
+			__ffs(PCI_EXP_LNKSTA_NLW);
+
+	*max_width = (lnkcap & PCI_EXP_LNKCAP_MLW) >> __ffs(PCI_EXP_LNKCAP_MLW);
+	*actual_speed = (lnksta & PCI_EXP_LNKSTA_CLS);
+
+	nic_speed = 1;
+	if (lnkcap & PCI_EXP_LNKCAP_SLS_5_0GB)
+		nic_speed = 2;
+	/* PCIe Gen3 capabilities are in a different config word. */
+	if (!pci_read_config_word(pdev, cap + PCI_EXP_LNKCAP2, &lnkcap)) {
+		if (lnkcap & PCI_EXP_LNKCAP2_SLS_8_0GB)
+			nic_speed = 3;
+	}
+
+	*nic_bandwidth = *max_width << (nic_speed - 1);
+
+	return nic_speed;
+}
+
+static void efct_nic_check_pcie_link(struct efct_device *efct_dev, u32 desired_bandwidth,
+				     u32 *actual_width, u32 *actual_speed)
+{
+	struct pci_dev *pdev = efct_dev->pci_dev;
+	u32 nic_bandwidth;
+	u32 bandwidth = 0;
+	u32 nic_width = 0;
+	u32 nic_speed = 0;
+	u32 width = 0;
+	u32 speed = 0;
+
+	nic_speed = efct_device_check_pcie_link(pdev, &width, &nic_width, &speed,
+						&nic_bandwidth);
+
+	if (!nic_speed)
+		goto out;
+
+	if (width > nic_width)
+		pci_dbg(pdev, "PCI Express width is %d, with maximum expected %d. If running on a virtualized platform this is fine, otherwise it indicates a PCI problem.\n",
+			width, nic_width);
+
+	bandwidth = width << (speed - 1);
+
+	if (desired_bandwidth > nic_bandwidth)
+		/* You can desire all you want, it ain't gonna happen. */
+		desired_bandwidth = nic_bandwidth;
+
+	if (desired_bandwidth && bandwidth < desired_bandwidth) {
+		pci_warn(pdev,
+			 "This Network Adapter requires the equivalent of %d lanes at PCI Express %d speed for full throughput, but is currently limited to %d lanes at PCI Express %d speed.\n",
+			 desired_bandwidth > EFCT_BW_PCIE_GEN3_X8 ? 16 : 8,
+			 nic_speed, width, speed);
+		 pci_warn(pdev, "Consult your motherboard documentation to find a more suitable slot\n");
+	} else if (bandwidth < nic_bandwidth) {
+		pci_warn(pdev,
+			 "This Network Adapter requires a slot with %d lanes at PCI Express %d speed for optimal latency, but is currently limited to %d lanes at PCI Express %d speed\n",
+			 nic_width, nic_speed, width, speed);
+	}
+
+out:
+	if (actual_width)
+		*actual_width = width;
+
+	if (actual_speed)
+		*actual_speed = speed;
+}
+
+/**************************************************************************
+ *
+ * List of NICs supported
+ *
+ **************************************************************************/
+
+/* PCI device ID table */
+static const struct pci_device_id efct_pci_table[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x5074),
+	.driver_data = (unsigned long)&efct_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x5075),
+	.driver_data = (unsigned long)&efct_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x5084),
+	.driver_data = (unsigned long)&efct_nic_type},
+	{0}			/* end of list */
+};
+
+static int efct_check_func_ctl_magic(struct efct_device *efct_dev)
+{
+	union efct_dword reg;
+
+	efct_readd(&reg, efct_dev->membase + efct_reg(efct_dev, ER_HZ_FUN_WIN_REG_HOST_NIC_MAGIC));
+	if (EFCT_DWORD_FIELD(reg, EFCT_DWORD_0) != HOST_NIC_MAGIC_RESET)
+		return -EIO;
+
+	return 0;
+}
+
+static u32 efct_get_num_ports(struct efct_device *efct_dev)
+{
+	union efct_dword reg;
+
+	efct_readd(&reg, efct_dev->membase + efct_reg(efct_dev, ER_HZ_FUN_WIN_REG_HOST_NUM_PORTS));
+	return EFCT_DWORD_FIELD(reg, EFCT_DWORD_0);
+}
+
+static void efct_free_dev(struct efct_nic *efct)
+{
+	efct_unregister_netdev(efct);
+	efct->type->remove(efct);
+	efct_unmap_membase(efct);
+	free_netdev(efct->net_dev);
+}
+
+static int efct_tlv_feed(struct efct_tlv_state *state, u8 byte)
+{
+	switch (state->state) {
+	case EFCT_TLV_TYPE:
+		state->type = byte & 0x7f;
+		state->state = (byte & 0x80) ? EFCT_TLV_TYPE_CONT
+					     : EFCT_TLV_LENGTH;
+		/* Clear ready to read in a new entry */
+		state->value = 0;
+		state->value_offset = 0;
+		return 0;
+	case EFCT_TLV_TYPE_CONT:
+		state->type |= byte << 7;
+		state->state = EFCT_TLV_LENGTH;
+		return 0;
+	case EFCT_TLV_LENGTH:
+		state->len = byte;
+		/* We only handle TLVs that fit in a u64 */
+		if (state->len > sizeof(state->value))
+			return -EOPNOTSUPP;
+		/* len may be zero, implying a value of zero */
+		state->state = state->len ? EFCT_TLV_VALUE : EFCT_TLV_TYPE;
+		return 0;
+	case EFCT_TLV_VALUE:
+		state->value |= ((u64)byte) << (state->value_offset * 8);
+		state->value_offset++;
+		if (state->value_offset >= state->len)
+			state->state = EFCT_TLV_TYPE;
+		return 0;
+	default: /* state machine error, can't happen */
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+}
+
+static int efct_process_design_param
+			(struct efct_device *efct_dev,
+			 const struct efct_tlv_state *reader)
+{
+	switch (reader->type) {
+	case ESE_EFCT_DP_GZ_PAD: /* padding, skip it */
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_STRIDE:
+		efct_dev->params.rx_stride = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_EVQ_STRIDE:
+		efct_dev->params.evq_stride = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_CTPIO_STRIDE:
+		efct_dev->params.ctpio_stride = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_BUFFER_SIZE:
+		/*This value shall be multiplied by 4096 to get exact buffer size*/
+		efct_dev->params.rx_buffer_len = min_t(u16, reader->value, 0x100);
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_QUEUES:
+		efct_dev->params.rx_queues = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_TX_CTPIO_APERTURES:
+		efct_dev->params.tx_apertures = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_BUFFER_FIFO_SIZE:
+		/*Number of RX buffer that can be posted at any time*/
+		efct_dev->params.rx_buf_fifo_size = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_FRAME_OFFSET_FIXED:
+		efct_dev->params.frame_offset_fixed = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_METADATA_LENGTH:
+		efct_dev->params.rx_metadata_len = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_TX_MAXIMUM_REORDER:
+		efct_dev->params.tx_max_reorder = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_TX_CTPIO_APERTURE_SIZE:
+		efct_dev->params.tx_aperture_size = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_TX_PACKET_FIFO_SIZE:
+		efct_dev->params.tx_fifo_size = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_PARTIAL_TSTAMP_SUB_NANO_BITS:
+		efct_dev->params.ts_subnano_bit = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_EVQ_UNSOL_CREDIT_SEQ_BITS:
+		 efct_dev->params.unsol_credit_seq_mask = (1 << reader->value) - 1;
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_L4_CSUM_PROTOCOLS:
+		efct_dev->params.l4_csum_proto = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_RX_MAX_RUNT:
+		efct_dev->params.max_runt = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_EVQ_SIZES:
+		efct_dev->params.evq_sizes = reader->value;
+		return 0;
+	case ESE_EFCT_DP_GZ_EV_QUEUES:
+		efct_dev->params.num_evq = reader->value;
+		return 0;
+	default:
+		/* Host interface says "Drivers should ignore design parameters
+		 * that they do not recognise."
+		 */
+		pr_info("Ignoring unrecognised design parameter %u\n", reader->type);
+		return 0;
+	}
+}
+
+static int efct_check_design_params(struct efct_device *efct_dev)
+{
+	u32 data, design_params_present_bitmask = 0x0;
+	struct efct_tlv_state reader = {};
+	u32 total_len, offset = 0;
+	union efct_dword reg;
+	int rc = 0, i;
+
+	efct_readd(&reg, efct_dev->membase +
+		  efct_reg(efct_dev, ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV_LEN));
+	total_len = EFCT_DWORD_FIELD(reg, EFCT_DWORD_0);
+	pci_dbg(efct_dev->pci_dev, "%u bytes of design parameters\n", total_len);
+	while (offset < total_len) {
+		efct_readd(&reg, efct_dev->membase +
+			  efct_reg(efct_dev, ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV + offset));
+		data = EFCT_DWORD_FIELD(reg, EFCT_DWORD_0);
+		for (i = 0; i < sizeof(data); i++) {
+			rc = efct_tlv_feed(&reader, data);
+			/* Got a complete value? */
+			if (!rc && reader.state == EFCT_TLV_TYPE) {
+				rc = efct_process_design_param(efct_dev, &reader);
+				if (rc) {
+					pci_err(efct_dev->pci_dev, "Processing Design Parameter for type %d failed\n",
+						reader.type);
+					goto out;
+				}
+				design_params_present_bitmask |= (1 << reader.type);
+			}
+
+			if (rc) {
+				pci_err(efct_dev->pci_dev,
+					"Unable to read design parameters, rc=%d", rc);
+				goto out;
+			}
+			data >>= 8;
+			offset++;
+		}
+	}
+
+	if ((design_params_present_bitmask & EFCT_REQRD_DESIGN_PARAMS) !=
+			EFCT_REQRD_DESIGN_PARAMS) {
+		pr_err("Design parameters are missing in the hardware\n");
+		rc = -EINVAL;
+	}
+out:
+	return rc;
+}
+
+/* NIC initialisation
+ *
+ * This is called at module load (or hotplug insertion,
+ * theoretically).  It sets up PCI mappings, resets the NIC,
+ * sets up and registers the network devices with the kernel and hooks
+ * the interrupt service routine.  It does not prepare the device for
+ * transmission; this is left to the first time one of the network
+ * interfaces is brought up (i.e. efct_net_open).
+ */
+static int efct_pci_probe
+			(struct pci_dev *pci_dev,
+			 const struct pci_device_id *entry)
+{
+	struct efct_func_ctl_window fcw = { 0 };
+	int rc = 0, i = 0, j = 0, port_base = 0;
+	struct efct_device *efct_dev;
+	struct net_device *net_dev;
+	struct efct_nic *efct;
+
+	efct_dev = kzalloc(sizeof(*efct_dev), GFP_KERNEL);
+	if (!efct_dev)
+		return -ENOMEM;
+	efct_dev->xentries = NULL;
+	efct_dev->pci_dev = pci_dev;
+	pci_set_drvdata(pci_dev, efct_dev);
+	efct_dev->max_dma_mask = DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH);
+
+	/*Finding function control window*/
+	rc = efct_pci_find_func_ctrl_window(efct_dev, &fcw);
+	if (rc) {
+		pci_err(pci_dev,
+			"Error looking for efct function control window, rc=%d\n", rc);
+		goto fail;
+	}
+
+	if (!fcw.valid) {
+		/* Extended capability not found - use defaults. */
+		fcw.bar = EFCT_PCI_DEFAULT_BAR;
+		fcw.offset = 0;
+	}
+
+	/* Set up basic I/O (BAR mappings etc) */
+	rc = efct_init_io(efct_dev, fcw.bar, efct_dev->max_dma_mask,
+			  pci_resource_len(efct_dev->pci_dev, fcw.bar));
+	if (rc) {
+		pci_err(pci_dev,
+			"Basic I/O initialization of efct_dev failed, rc=%d\n", rc);
+		goto fail;
+	}
+
+	/* Set default layout to distributed */
+	efct_dev->dist_layout = RX_LAYOUT_DISTRIBUTED;
+	efct_dev->separated_rx_cpu = DEFAULT_SEPARATED_RX_CPU;
+
+	efct_dev->reg_base = fcw.offset;
+	efct_dev->num_ports = efct_get_num_ports(efct_dev);
+	if (fcw.offset > pci_resource_len(efct_dev->pci_dev, fcw.bar)
+		- (((efct_dev->num_ports - 1) * EFCT_PORT_OFFSET) + EFCT_PORT_LEN)) {
+		pci_err(pci_dev, "Func control window overruns BAR\n");
+		goto fail1;
+	}
+
+	rc = efct_check_func_ctl_magic(efct_dev);
+	if (rc) {
+		pci_err(pci_dev, "Func control window magic is wrong, rc=%d\n", rc);
+		goto fail1;
+	}
+
+	/* Read design parameters */
+	rc = efct_check_design_params(efct_dev);
+	if (rc) {
+		pci_err(efct_dev->pci_dev, "Unsupported design parameters, rc=%d\n", rc);
+		goto fail1;
+	}
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	efct_init_mcdi_logging(efct_dev);
+#endif
+	/*Initialize the BIU lock*/
+	spin_lock_init(&efct_dev->biu_lock);
+	rc = efct_alloc_msix(efct_dev);
+	if (rc)
+		goto fail2;
+	efct_nic_check_pcie_link(efct_dev, EFCT_BW_PCIE_GEN3_X8, NULL, NULL);
+
+	for (i = 0; i < efct_dev->num_ports; i++) {
+		/* Allocate and initialise a struct net_device and struct efct_nic */
+		net_dev = alloc_etherdev_mq(sizeof(*efct), EFCT_MAX_CORE_TX_QUEUES);
+		if (!net_dev) {
+			pci_err(pci_dev, "Unable to allocate net device\n");
+			rc = -ENOMEM;
+			goto freep0;
+		}
+		efct = netdev_priv(net_dev);
+		efct_dev->efct[i] = efct;
+		efct->efct_dev = efct_dev;
+		efct->type = (const struct efct_nic_type *)entry->driver_data;
+		efct->net_dev = net_dev;
+		/*initializing window offsets*/
+		port_base = (i * EFCT_PORT_OFFSET);
+
+		efct_dev->efct[i]->port_base = port_base;
+
+		/* Map uc and mc regions */
+		rc = efct_map_membase(efct, &fcw, i);
+		if (rc) {
+			pci_err(pci_dev, "efct_map_membase failed, rc=%d\n", rc);
+			goto fail3;
+		}
+
+		rc = efct_init_struct(efct);
+		if (rc) {
+			pci_err(pci_dev, "efct_init_struct failed, rc=%d\n", rc);
+			goto fail4;
+		}
+		rc = efct->type->probe(efct);
+		if (rc) {
+			pci_err(pci_dev, "HW Probe failed, rc=%d\n", rc);
+			goto fail5;
+		}
+		/* Helps biosdevname tool to differentiate ports attached to same PF */
+		efct->net_dev->dev_port = efct->port_num;
+		snprintf(efct->name, sizeof(efct->name), "%s#%d",
+			 pci_name(efct->efct_dev->pci_dev), efct->port_num);
+		efct->state = STATE_PROBED;
+		mutex_init(&efct->state_lock);
+		init_rwsem(&efct->hpl_mutation_lock);
+
+		rc = efct_probe_netdev(efct);
+		if (rc) {
+			pci_err(pci_dev, "Unable to probe net device, rc=%d\n", rc);
+			goto fail6;
+		}
+		rc = efct_register_netdev(efct);
+		if (rc) {
+			pci_err(pci_dev, "Unable to register net device, rc=%d\n", rc);
+			goto fail7;
+		}
+		/*Populating IRQ numbers in aux resources*/
+		efct_assign_msix(efct, i);
+	}
+	rc = efct_init_stats_wq(efct_dev);
+	if (rc)
+		goto freep0;
+
+	pr_info("EFCT X3 NIC detected: device %04x:%04x subsys %04x:%04x\n",
+		pci_dev->vendor, pci_dev->device,
+		pci_dev->subsystem_vendor,
+		pci_dev->subsystem_device);
+	return 0;
+
+fail7:
+fail6:
+	efct->type->remove(efct);
+fail5:
+	efct_flush_reset_workqueue();
+fail4:
+	efct_unmap_membase(efct_dev->efct[i]);
+fail3:
+	free_netdev(efct_dev->efct[i]->net_dev);
+freep0:
+	for (j = 0; j < i ; j++)
+		efct_free_dev(efct_dev->efct[j]);
+	efct_free_msix(efct_dev);
+fail2:
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	efct_fini_mcdi_logging(efct_dev);
+#endif
+fail1:
+	efct_fini_io(efct_dev);
+fail:
+	kfree(efct_dev);
+	pci_set_drvdata(pci_dev, NULL);
+	pr_err("Driver Probe failed. rc=%d\n", rc);
+
+	return rc;
+}
+
+/* Final NIC shutdown
+ * This is called only at module unload (or hotplug removal).
+ */
+static void efct_pci_remove(struct pci_dev *pci_dev)
+{
+	struct efct_device *efct_dev;
+	int i = 0;
+
+	efct_dev = pci_get_drvdata(pci_dev);
+	if (!efct_dev)
+		return;
+
+	efct_fini_stats_wq(efct_dev);
+	for (i = 0; i < efct_dev->num_ports; i++) {
+		efct_close_netdev(efct_dev->efct[i]);
+		efct_remove_netdev(efct_dev->efct[i]);
+		efct_dev->efct[i]->type->remove(efct_dev->efct[i]);
+		efct_flush_reset_workqueue();
+		efct_unmap_membase(efct_dev->efct[i]);
+		free_netdev(efct_dev->efct[i]->net_dev);
+	}
+	efct_free_msix(efct_dev);
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	efct_fini_mcdi_logging(efct_dev);
+#endif
+	efct_fini_io(efct_dev);
+
+	pci_set_drvdata(pci_dev, NULL);
+	kfree(efct_dev);
+	pr_info("EFCT X3 NIC removed successfully\n");
+}
+
+static struct pci_driver efct_pci_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= efct_pci_table,
+	.probe		= efct_pci_probe,
+	.remove		= efct_pci_remove,
+};
+
+static int __init efct_init_module(void)
+{
+	int rc;
+
+	pr_info("EFCT Net driver v" EFCT_DRIVER_VERSION "\n");
+
+	rc = efct_create_reset_workqueue();
+	if (rc)
+		return rc;
+
+	rc = pci_register_driver(&efct_pci_driver);
+	if (rc < 0) {
+		pr_err("pci_register_driver failed, rc=%d\n", rc);
+		efct_destroy_reset_workqueue();
+		return rc;
+	}
+
+	return 0;
+}
+
+static void __exit efct_exit_module(void)
+{
+	pr_info("EFCT Net driver unloading\n");
+	pci_unregister_driver(&efct_pci_driver);
+	efct_destroy_reset_workqueue();
+}
+
+module_init(efct_init_module);
+module_exit(efct_exit_module);
+
+MODULE_AUTHOR(" Advanced Micro Devices Inc.");
+MODULE_DESCRIPTION("AMD EFCT Network driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, efct_pci_table);
diff --git a/drivers/net/ethernet/amd/efct/efct_reg.h b/drivers/net/ethernet/amd/efct/efct_reg.h
new file mode 100644
index 000000000000..6291607dbf37
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_reg.h
@@ -0,0 +1,1060 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef	EFCT_REG_H
+#define	EFCT_REG_H
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_HW_REV_ID(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_HW_REV_ID 0x00000000
+#define	ER_HZ_REG_HOST_HW_REV_ID_RESET 0x0
+
+#define	ERF_HZ_MAJOR_LBN 24
+#define	ERF_HZ_MAJOR_WIDTH 8
+#define	ERF_HZ_MINOR_LBN 12
+#define	ERF_HZ_MINOR_WIDTH 12
+#define	ERF_HZ_PATCH_LBN 0
+#define	ERF_HZ_PATCH_WIDTH 12
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_NIC_REV_ID(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_NIC_REV_ID 0x00000004
+#define	ER_HZ_REG_HOST_NIC_REV_ID_RESET 0x0
+
+/* defined as ERF_HZ_MAJOR_LBN 24; access=RO reset=0 */
+/* defined as ERF_HZ_MAJOR_WIDTH 8 */
+/* defined as ERF_HZ_MINOR_LBN 12; access=RO reset=0 */
+/* defined as ERF_HZ_MINOR_WIDTH 12 */
+/* defined as ERF_HZ_PATCH_LBN 0; access=RO reset=0 */
+/* defined as ERF_HZ_PATCH_WIDTH 12 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_NIC_MAGIC(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_NIC_MAGIC 0x00000008
+#define	ER_HZ_REG_HOST_NIC_MAGIC_RESET 0x0
+
+#define	ERF_HZ_NIC_MAGIC_LBN 0
+#define	ERF_HZ_NIC_MAGIC_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_NUM_PORTS(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_NUM_PORTS 0x0000000c
+#define	ER_HZ_REG_HOST_NUM_PORTS_RESET 0x0
+
+#define	ERF_HZ_NUM_PORTS_LBN 0
+#define	ERF_HZ_NUM_PORTS_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_MC_SFT_STATUS(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_MC_SFT_STATUS 0x00000010
+#define	ER_HZ_FUN_WIN_REG_HOST_MC_SFT_STATUS_STEP 4
+#define	ER_HZ_FUN_WIN_REG_HOST_MC_SFT_STATUS_ROWS 2
+#define	ER_HZ_REG_HOST_MC_SFT_STATUS_RESET 0x0
+
+#define	ERF_HZ_MC_SFT_STATUS_LBN 0
+#define	ERF_HZ_MC_SFT_STATUS_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV_LEN(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV_LEN 0x00000020
+#define	ER_HZ_REG_HOST_PARAMS_TLV_LEN_RESET 0x0
+
+#define	ERF_HZ_PARAMS_TLV_LEN_LBN 0
+#define	ERF_HZ_PARAMS_TLV_LEN_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV(32bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV 0x00000024
+#define	ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV_STEP 4
+#define	ER_HZ_FUN_WIN_REG_HOST_PARAMS_TLV_ROWS 247
+#define	ER_HZ_REG_HOST_PARAMS_TLV_RESET 0x0
+
+#define	ERF_HZ_PARAMS_TLV_LBN 0
+#define	ERF_HZ_PARAMS_TLV_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_VSEC_HDR(64bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_VSEC_HDR 0x00000400
+#define	ER_HZ_REG_HOST_VSEC_HDR_RESET 0x1810000001
+
+#define	ERF_HZ_LENGTH_LBN 32
+#define	ERF_HZ_LENGTH_WIDTH 32
+#define	ERF_HZ_LAST_CAPABILITY_LBN 28
+#define	ERF_HZ_LAST_CAPABILITY_WIDTH 1
+#define	ERF_HZ_FORMAT_REV_CODE_LBN 20
+#define	ERF_HZ_FORMAT_REV_CODE_WIDTH 8
+#define	ERF_HZ_FORMAT_ID_LBN 0
+#define	ERF_HZ_FORMAT_ID_WIDTH 20
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_VSEC_TBL_FRMT(64bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_VSEC_TBL_FRMT 0x00000408
+#define	ER_HZ_REG_HOST_VSEC_TBL_FRMT_RESET 0x8
+
+#define	ERF_HZ_ENTRY_SIZE_LBN 0
+#define	ERF_HZ_ENTRY_SIZE_WIDTH 8
+
+/*------------------------------------------------------------*/
+/* ER_HZ_FUN_WIN_REG_HOST_VSEC_TBL_ENTRY(64bit):
+ *
+ */
+#define	ER_HZ_FUN_WIN_REG_HOST_VSEC_TBL_ENTRY 0x00000410
+#define	ER_HZ_REG_HOST_VSEC_TBL_ENTRY_RESET 0x58330020
+
+#define	ERF_HZ_FUNC_CTL_WIN_OFF_16B_LBN 35
+#define	ERF_HZ_FUNC_CTL_WIN_OFF_16B_WIDTH 29
+#define	ERF_HZ_FUNC_CTL_WIN_BAR_LBN 32
+#define	ERF_HZ_FUNC_CTL_WIN_BAR_WIDTH 3
+#define	ERF_HZ_PROJECT_ID_LBN 16
+#define	ERF_HZ_PROJECT_ID_WIDTH 16
+#define	ERF_HZ_TYPE_REVISION_LBN 8
+#define	ERF_HZ_TYPE_REVISION_WIDTH 5
+#define	ERF_HZ_TABLE_TYPE_LBN 0
+#define	ERF_HZ_TABLE_TYPE_WIDTH 8
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_MC_DOORBELL(64bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_MC_DOORBELL 0x00000800
+/* ER_HZ_PORT1_REG_HOST_MC_DOORBELL(64bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_MC_DOORBELL 0x00080800
+#define	ER_HZ_REG_HOST_MC_DOORBELL_RESET 0x0
+
+#define	ERF_HZ_MC_DOORBELL_LBN 0
+#define	ERF_HZ_MC_DOORBELL_WIDTH 64
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_EVQ_INT_PRIME(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_EVQ_INT_PRIME 0x00000808
+/* ER_HZ_PORT1_REG_HOST_EVQ_INT_PRIME(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_EVQ_INT_PRIME 0x00080808
+#define	ER_HZ_REG_HOST_EVQ_INT_PRIME_RESET 0x0
+
+#define	ERF_HZ_READ_IDX_LBN 16
+#define	ERF_HZ_READ_IDX_WIDTH 16
+#define	ERF_HZ_EVQ_ID_LBN 0
+#define	ERF_HZ_EVQ_ID_WIDTH 16
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_MC_DB_OWNER(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_MC_DB_OWNER 0x0000080c
+/* ER_HZ_PORT1_REG_HOST_MC_DB_OWNER(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_MC_DB_OWNER 0x0008080c
+#define	ER_HZ_REG_HOST_MC_DB_OWNER_RESET 0x0
+
+#define	ERF_HZ_OWNERSHIP_LBN 0
+#define	ERF_HZ_OWNERSHIP_WIDTH 1
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_MC_PIO(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_MC_PIO 0x00001000
+#define	ER_HZ_PORT0_REG_HOST_MC_PIO_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_MC_PIO_ROWS 272
+/* ER_HZ_PORT1_REG_HOST_MC_PIO(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_MC_PIO 0x00081000
+#define	ER_HZ_PORT1_REG_HOST_MC_PIO_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_MC_PIO_ROWS 272
+#define	ER_HZ_REG_HOST_MC_PIO_RESET 0x0
+
+#define	ERF_HZ_MC_PIO_LBN 0
+#define	ERF_HZ_MC_PIO_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_RX_BUFFER_POST(64bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_RX_BUFFER_POST 0x00002000
+#define	ER_HZ_PORT0_REG_HOST_RX_BUFFER_POST_STEP 4096
+#define	ER_HZ_PORT0_REG_HOST_RX_BUFFER_POST_ROWS 16
+/* ER_HZ_PORT1_REG_HOST_RX_BUFFER_POST(64bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_RX_BUFFER_POST 0x00082000
+#define	ER_HZ_PORT1_REG_HOST_RX_BUFFER_POST_STEP 4096
+#define	ER_HZ_PORT1_REG_HOST_RX_BUFFER_POST_ROWS 16
+#define	ER_HZ_REG_HOST_RX_BUFFER_POST_RESET 0x0
+
+#define	ERF_HZ_ROLLOVER_LBN 53
+#define	ERF_HZ_ROLLOVER_WIDTH 1
+#define	ERF_HZ_SENTINEL_VALUE_LBN 52
+#define	ERF_HZ_SENTINEL_VALUE_WIDTH 1
+#define	ERF_HZ_PAGE_ADDRESS_LBN 0
+#define	ERF_HZ_PAGE_ADDRESS_WIDTH 52
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_THE_TIME(64bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_THE_TIME 0x00002008
+#define	ER_HZ_PORT0_REG_HOST_THE_TIME_STEP 4096
+#define	ER_HZ_PORT0_REG_HOST_THE_TIME_ROWS 16
+/* ER_HZ_PORT1_REG_HOST_THE_TIME(64bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_THE_TIME 0x00082008
+#define	ER_HZ_PORT1_REG_HOST_THE_TIME_STEP 4096
+#define	ER_HZ_PORT1_REG_HOST_THE_TIME_ROWS 16
+#define	ER_HZ_REG_HOST_THE_TIME_RESET 0x0
+
+#define	ERF_HZ_THE_TIME_LBN 0
+#define	ERF_HZ_THE_TIME_WIDTH 64
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_EVQ_UNSOL_CREDIT_GRANT(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_EVQ_UNSOL_CREDIT_GRANT 0x00012000
+#define	ER_HZ_PORT0_REG_HOST_EVQ_UNSOL_CREDIT_GRANT_STEP 4096
+#define	ER_HZ_PORT0_REG_HOST_EVQ_UNSOL_CREDIT_GRANT_ROWS 32
+/* ER_HZ_PORT1_REG_HOST_EVQ_UNSOL_CREDIT_GRANT(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_EVQ_UNSOL_CREDIT_GRANT 0x00092000
+#define	ER_HZ_PORT1_REG_HOST_EVQ_UNSOL_CREDIT_GRANT_STEP 4096
+#define	ER_HZ_PORT1_REG_HOST_EVQ_UNSOL_CREDIT_GRANT_ROWS 32
+#define	ER_HZ_REG_HOST_EVQ_UNSOL_CREDIT_GRANT_RESET 0x0
+
+#define	ERF_HZ_CLEAR_OVERFLOW_LBN 16
+#define	ERF_HZ_CLEAR_OVERFLOW_WIDTH 1
+#define	ERF_HZ_GRANT_SEQ_LBN 0
+#define	ERF_HZ_GRANT_SEQ_WIDTH 16
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION0(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION0 0x00042000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION0_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION0_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION0(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION0 0x000c2000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION0_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION0_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION0_RESET 0x0
+
+#define	ERF_HZ_CTPIO_LBN 0
+#define	ERF_HZ_CTPIO_WIDTH 32
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION1(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION1 0x00043000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION1_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION1_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION1(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION1 0x000c3000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION1_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION1_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION1_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION2(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION2 0x00044000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION2_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION2_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION2(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION2 0x000c4000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION2_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION2_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION2_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION3(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION3 0x00045000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION3_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION3_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION3(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION3 0x000c5000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION3_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION3_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION3_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION4(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION4 0x00046000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION4_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION4_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION4(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION4 0x000c6000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION4_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION4_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION4_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION5(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION5 0x00047000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION5_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION5_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION5(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION5 0x000c7000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION5_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION5_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION5_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION6(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION6 0x00048000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION6_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION6_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION6(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION6 0x000c8000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION6_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION6_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION6_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION7(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION7 0x00049000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION7_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION7_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION7(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION7 0x000c9000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION7_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION7_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION7_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION8(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION8 0x0004a000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION8_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION8_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION8(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION8 0x000ca000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION8_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION8_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION8_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION9(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION9 0x0004b000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION9_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION9_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION9(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION9 0x000cb000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION9_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION9_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION9_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION10(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION10 0x0004c000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION10_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION10_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION10(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION10 0x000cc000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION10_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION10_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION10_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION11(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION11 0x0004d000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION11_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION11_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION11(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION11 0x000cd000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION11_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION11_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION11_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION12(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION12 0x0004e000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION12_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION12_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION12(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION12 0x000ce000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION12_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION12_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION12_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION13(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION13 0x0004f000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION13_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION13_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION13(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION13 0x000cf000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION13_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION13_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION13_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION14(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION14 0x00050000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION14_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION14_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION14(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION14 0x000d0000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION14_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION14_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION14_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ER_HZ_PORT0_REG_HOST_CTPIO_REGION15(32bit):
+ *
+ */
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION15 0x00051000
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION15_STEP 4
+#define	ER_HZ_PORT0_REG_HOST_CTPIO_REGION15_ROWS 1024
+/* ER_HZ_PORT1_REG_HOST_CTPIO_REGION15(32bit):
+ *
+ */
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION15 0x000d1000
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION15_STEP 4
+#define	ER_HZ_PORT1_REG_HOST_CTPIO_REGION15_ROWS 1024
+#define	ER_HZ_REG_HOST_CTPIO_REGION15_RESET 0x0
+
+/* defined as ERF_HZ_CTPIO_LBN 0; access=WO reset=0 */
+/* defined as ERF_HZ_CTPIO_WIDTH 32 */
+
+/*------------------------------------------------------------*/
+/* ES_PCI_EXPRESS_XCAP_HDR */
+#define	ESF_HZ_PCI_EXPRESS_XCAP_NEXT_LBN 20
+#define	ESF_HZ_PCI_EXPRESS_XCAP_NEXT_WIDTH 12
+#define	ESF_HZ_PCI_EXPRESS_XCAP_VER_LBN 16
+#define	ESF_HZ_PCI_EXPRESS_XCAP_VER_WIDTH 4
+#define	ESE_HZ_PCI_EXPRESS_XCAP_VER_PCI_EXPRESS_XCAP_VER_VSEC 1
+#define	ESF_HZ_PCI_EXPRESS_XCAP_ID_LBN 0
+#define	ESF_HZ_PCI_EXPRESS_XCAP_ID_WIDTH 16
+#define	ESE_HZ_PCI_EXPRESS_XCAP_ID_PCI_EXPRESS_XCAP_ID_VNDR 0xb
+#define	ESE_HZ_PCI_EXPRESS_XCAP_HDR_STRUCT_SIZE 32
+
+/*------------------------------------------------------------*/
+/* ES_VIRTIO_DESC */
+#define	ESF_HZ_NEXT_LBN 112
+#define	ESF_HZ_NEXT_WIDTH 16
+#define	ESF_HZ_FLAGS_LBN 96
+#define	ESF_HZ_FLAGS_WIDTH 16
+#define	ESF_HZ_FLAG_IND_LBN 98
+#define	ESF_HZ_FLAG_IND_WIDTH 1
+#define	ESF_HZ_FLAG_WRITE_LBN 97
+#define	ESF_HZ_FLAG_WRITE_WIDTH 1
+#define	ESF_HZ_FLAG_NEXT_LBN 96
+#define	ESF_HZ_FLAG_NEXT_WIDTH 1
+#define	ESF_HZ_LEN_LBN 64
+#define	ESF_HZ_LEN_WIDTH 32
+#define	ESF_HZ_ADDR_LBN 0
+#define	ESF_HZ_ADDR_WIDTH 64
+#define	ESE_HZ_VIRTIO_DESC_STRUCT_SIZE 128
+
+/*------------------------------------------------------------*/
+/* ES_VIRTIO_NET_HDR */
+#define	ESF_HZ_NUM_BUFS_LBN 80
+#define	ESF_HZ_NUM_BUFS_WIDTH 16
+#define	ESF_HZ_CSUM_OFFST_LBN 64
+#define	ESF_HZ_CSUM_OFFST_WIDTH 16
+#define	ESF_HZ_CSUM_START_LBN 48
+#define	ESF_HZ_CSUM_START_WIDTH 16
+#define	ESF_HZ_GSO_SZ_LBN 32
+#define	ESF_HZ_GSO_SZ_WIDTH 16
+#define	ESF_HZ_HDR_LEN_LBN 16
+#define	ESF_HZ_HDR_LEN_WIDTH 16
+#define	ESF_HZ_GSO_TYPE_LBN 8
+#define	ESF_HZ_GSO_TYPE_WIDTH 8
+#define	ESE_HZ_GSO_TYPE_GSO_ECN 128
+#define	ESE_HZ_GSO_TYPE_GSO_TCPV6 4
+#define	ESE_HZ_GSO_TYPE_GSO_UDP 3
+#define	ESE_HZ_GSO_TYPE_GSO_TCPV4 1
+#define	ESE_HZ_GSO_TYPE_GSO_NONE 0
+#define	ESF_HZ_FLAGS_2_LBN 0
+#define	ESF_HZ_FLAGS_2_WIDTH 8
+#define	ESF_HZ_RSC_INFO_LBN 2
+#define	ESF_HZ_RSC_INFO_WIDTH 1
+#define	ESF_HZ_DATA_VALID_LBN 1
+#define	ESF_HZ_DATA_VALID_WIDTH 1
+#define	ESF_HZ_NEEDS_CSUM_LBN 0
+#define	ESF_HZ_NEEDS_CSUM_WIDTH 1
+#define	ESE_HZ_VIRTIO_NET_HDR_STRUCT_SIZE 96
+
+/*------------------------------------------------------------*/
+/* ES_VIRTIO_PCI_COMMON_CFG */
+#define	ESF_HZ_QUEUE_DEVICE_LBN 384
+#define	ESF_HZ_QUEUE_DEVICE_WIDTH 64
+#define	ESF_HZ_QUEUE_DRIVER_LBN 320
+#define	ESF_HZ_QUEUE_DRIVER_WIDTH 64
+#define	ESF_HZ_QUEUE_DESC_LBN 256
+#define	ESF_HZ_QUEUE_DESC_WIDTH 64
+#define	ESF_HZ_QUEUE_NOTIFY_OFF_LBN 240
+#define	ESF_HZ_QUEUE_NOTIFY_OFF_WIDTH 16
+#define	ESF_HZ_QUEUE_ENABLE_LBN 224
+#define	ESF_HZ_QUEUE_ENABLE_WIDTH 16
+#define	ESF_HZ_QUEUE_MSIX_VECTOR_LBN 208
+#define	ESF_HZ_QUEUE_MSIX_VECTOR_WIDTH 16
+#define	ESF_HZ_QUEUE_SIZE_LBN 192
+#define	ESF_HZ_QUEUE_SIZE_WIDTH 16
+#define	ESF_HZ_QUEUE_SELECT_LBN 176
+#define	ESF_HZ_QUEUE_SELECT_WIDTH 16
+#define	ESF_HZ_CONFIG_GENERATION_LBN 168
+#define	ESF_HZ_CONFIG_GENERATION_WIDTH 8
+#define	ESF_HZ_DEVICE_STATUS_LBN 160
+#define	ESF_HZ_DEVICE_STATUS_WIDTH 8
+#define	ESF_HZ_NUM_QUEUES_LBN 144
+#define	ESF_HZ_NUM_QUEUES_WIDTH 16
+#define	ESF_HZ_MSIX_CONFIG_LBN 128
+#define	ESF_HZ_MSIX_CONFIG_WIDTH 16
+#define	ESF_HZ_DRIVER_FEATURE_LBN 96
+#define	ESF_HZ_DRIVER_FEATURE_WIDTH 32
+#define	ESF_HZ_DRIVER_FEATURE_SELECT_LBN 64
+#define	ESF_HZ_DRIVER_FEATURE_SELECT_WIDTH 32
+#define	ESF_HZ_DEVICE_FEATURE_LBN 32
+#define	ESF_HZ_DEVICE_FEATURE_WIDTH 32
+#define	ESF_HZ_DEVICE_FEATURE_SELECT_LBN 0
+#define	ESF_HZ_DEVICE_FEATURE_SELECT_WIDTH 32
+#define	ESE_HZ_VIRTIO_PCI_COMMON_CFG_STRUCT_SIZE 448
+
+/*------------------------------------------------------------*/
+/* ES_VIRTIO_PCI_VCAP */
+#define	ESF_HZ_LENGTH_2_LBN 96
+#define	ESF_HZ_LENGTH_2_WIDTH 32
+#define	ESF_HZ_OFFSET_LBN 64
+#define	ESF_HZ_OFFSET_WIDTH 32
+#define	ESF_HZ_PADDING_LBN 40
+#define	ESF_HZ_PADDING_WIDTH 24
+#define	ESF_HZ_BAR_LBN 32
+#define	ESF_HZ_BAR_WIDTH 8
+#define	ESF_HZ_CFG_TYPE_LBN 24
+#define	ESF_HZ_CFG_TYPE_WIDTH 8
+#define	ESE_HZ_CFG_TYPE_VIRTIO_PCI_CFG 5
+#define	ESE_HZ_CFG_TYPE_VIRTIO_DEVICE_CFG 4
+#define	ESE_HZ_CFG_TYPE_VIRTIO_ISR_CFG 3
+#define	ESE_HZ_CFG_TYPE_VIRTIO_NOTIFY_CFG 2
+#define	ESE_HZ_CFG_TYPE_VIRTIO_COMMON_CFG 1
+#define	ESF_HZ_CAP_LEN_LBN 16
+#define	ESF_HZ_CAP_LEN_WIDTH 8
+#define	ESF_HZ_CAP_NEXT_LBN 8
+#define	ESF_HZ_CAP_NEXT_WIDTH 8
+#define	ESF_HZ_CAP_ID_LBN 0
+#define	ESF_HZ_CAP_ID_WIDTH 8
+#define	ESE_HZ_VIRTIO_PCI_VCAP_STRUCT_SIZE 128
+
+/*------------------------------------------------------------*/
+/* ES_VIRTQ_AVAIL_RING */
+#define	ESF_HZ_USED_EVENT_LBN 48
+#define	ESF_HZ_USED_EVENT_WIDTH 16
+#define	ESF_HZ_AVAIL_RING_LBN 32
+#define	ESF_HZ_AVAIL_RING_WIDTH 16
+#define	ESE_HZ_AVAIL_RING_LENMIN 16
+#define	ESE_HZ_AVAIL_RING_LENMAX 524288
+#define	ESF_HZ_IDX_LBN 16
+#define	ESF_HZ_IDX_WIDTH 16
+#define	ESF_HZ_FLAGS_3_LBN 0
+#define	ESF_HZ_FLAGS_3_WIDTH 16
+#define	ESF_HZ_FLAG_NO_INT_LBN 0
+#define	ESF_HZ_FLAG_NO_INT_WIDTH 1
+#define	ESE_HZ_VIRTQ_AVAIL_RING_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_VIRTQ_USED_ELEM */
+#define	ESF_HZ_LEN_2_LBN 32
+#define	ESF_HZ_LEN_2_WIDTH 32
+#define	ESF_HZ_ID_LBN 0
+#define	ESF_HZ_ID_WIDTH 32
+#define	ESE_HZ_VIRTQ_USED_ELEM_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_VIRTQ_USED_RING */
+#define	ESF_HZ_AVAIL_EVENT_LBN 96
+#define	ESF_HZ_AVAIL_EVENT_WIDTH 16
+#define	ESF_HZ_USED_RING_LBN 32
+#define	ESF_HZ_USED_RING_WIDTH 64
+#define	ESE_HZ_USED_RING_LENMIN 64
+#define	ESE_HZ_USED_RING_LENMAX 2097152
+#define	ESF_HZ_IDX_LBN 16
+#define	ESF_HZ_IDX_WIDTH 16
+#define	ESF_HZ_FLAGS_4_LBN 0
+#define	ESF_HZ_FLAGS_4_WIDTH 16
+#define	ESE_HZ_VIRTQ_USED_RING_STRUCT_SIZE 112
+
+/*------------------------------------------------------------*/
+/* ES_xn_base_event */
+#define	ESF_HZ_EV_TYPE_LBN 60
+#define	ESF_HZ_EV_TYPE_WIDTH 4
+#define	ESF_HZ_EV_PHASE_LBN 59
+#define	ESF_HZ_EV_PHASE_WIDTH 1
+#define	ESE_HZ_XN_BASE_EVENT_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_ctl_event */
+#define	ESF_HZ_EV_CTL_TYPE_LBN 60
+#define	ESF_HZ_EV_CTL_TYPE_WIDTH 4
+#define	ESF_HZ_EV_CTL_PHASE_LBN 59
+#define	ESF_HZ_EV_CTL_PHASE_WIDTH 1
+#define	ESF_HZ_EV_CTL_SUBTYPE_LBN 53
+#define	ESF_HZ_EV_CTL_SUBTYPE_WIDTH 6
+#define	ESE_HZ_XN_CTL_EVENT_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_ctpio_hdr */
+#define	ESF_HZ_CTPIO_HDR_RSVD_LBN 27
+#define	ESF_HZ_CTPIO_HDR_RSVD_WIDTH 37
+#define	ESF_HZ_CTPIO_HDR_ACTION_LBN 24
+#define	ESF_HZ_CTPIO_HDR_ACTION_WIDTH 3
+#define	ESF_HZ_CTPIO_HDR_WARM_FLAG_LBN 23
+#define	ESF_HZ_CTPIO_HDR_WARM_FLAG_WIDTH 1
+#define	ESF_HZ_CTPIO_HDR_TIMESTAMP_FLAG_LBN 22
+#define	ESF_HZ_CTPIO_HDR_TIMESTAMP_FLAG_WIDTH 1
+#define	ESF_HZ_CTPIO_HDR_CT_THRESH_LBN 14
+#define	ESF_HZ_CTPIO_HDR_CT_THRESH_WIDTH 8
+#define	ESF_HZ_CTPIO_HDR_PACKET_LENGTH_LBN 0
+#define	ESF_HZ_CTPIO_HDR_PACKET_LENGTH_WIDTH 14
+#define	ESE_HZ_XN_CTPIO_HDR_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_flush_evnt */
+#define	ESF_HZ_EV_FLSH_TYPE_LBN 60
+#define	ESF_HZ_EV_FLSH_TYPE_WIDTH 4
+#define	ESF_HZ_EV_FLSH_PHASE_LBN 59
+#define	ESF_HZ_EV_FLSH_PHASE_WIDTH 1
+#define	ESF_HZ_EV_FLSH_SUBTYPE_LBN 53
+#define	ESF_HZ_EV_FLSH_SUBTYPE_WIDTH 6
+#define	ESF_HZ_EV_FLSH_RSVD_LBN 24
+#define	ESF_HZ_EV_FLSH_RSVD_WIDTH 29
+#define	ESF_HZ_EV_FLSH_QUEUE_ID_LBN 16
+#define	ESF_HZ_EV_FLSH_QUEUE_ID_WIDTH 8
+#define	ESF_HZ_EV_FLSH_REASON_LBN 10
+#define	ESF_HZ_EV_FLSH_REASON_WIDTH 6
+#define	ESF_HZ_EV_FLSH_LABEL_LBN 4
+#define	ESF_HZ_EV_FLSH_LABEL_WIDTH 6
+#define	ESF_HZ_EV_FLSH_FLUSH_TYPE_LBN 0
+#define	ESF_HZ_EV_FLSH_FLUSH_TYPE_WIDTH 4
+#define	ESE_HZ_XN_FLUSH_EVNT_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_mcdi_evnt */
+#define	ESF_HZ_EV_MCDI_TYPE_LBN 60
+#define	ESF_HZ_EV_MCDI_TYPE_WIDTH 4
+#define	ESF_HZ_EV_MCDI_PHASE_LBN 59
+#define	ESF_HZ_EV_MCDI_PHASE_WIDTH 1
+#define	ESF_HZ_EV_MCDI_RSVD_LBN 52
+#define	ESF_HZ_EV_MCDI_RSVD_WIDTH 7
+#define	ESF_HZ_EV_MCDI_CODE_LBN 44
+#define	ESF_HZ_EV_MCDI_CODE_WIDTH 8
+#define	ESF_HZ_EV_MCDI_SRC_LBN 36
+#define	ESF_HZ_EV_MCDI_SRC_WIDTH 8
+#define	ESF_HZ_EV_MCDI_LEVEL_LBN 33
+#define	ESF_HZ_EV_MCDI_LEVEL_WIDTH 3
+#define	ESF_HZ_EV_MCDI_CONT_LBN 32
+#define	ESF_HZ_EV_MCDI_CONT_WIDTH 1
+#define	ESF_HZ_EV_MCDI_DATA_LBN 0
+#define	ESF_HZ_EV_MCDI_DATA_WIDTH 32
+#define	ESE_HZ_XN_MCDI_EVNT_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_rx_pkts */
+#define	ESF_HZ_EV_RXPKTS_TYPE_LBN 60
+#define	ESF_HZ_EV_RXPKTS_TYPE_WIDTH 4
+#define	ESF_HZ_EV_RXPKTS_PHASE_LBN 59
+#define	ESF_HZ_EV_RXPKTS_PHASE_WIDTH 1
+#define	ESF_HZ_EV_RXPKTS_FLOW_LOOKUP_LBN 58
+#define	ESF_HZ_EV_RXPKTS_FLOW_LOOKUP_WIDTH 1
+#define	ESF_HZ_EV_RXPKTS_ROLLOVER_LBN 57
+#define	ESF_HZ_EV_RXPKTS_ROLLOVER_WIDTH 1
+#define	ESF_HZ_EV_RXPKTS_RSVD_LBN 22
+#define	ESF_HZ_EV_RXPKTS_RSVD_WIDTH 35
+#define	ESF_HZ_EV_RXPKTS_LABEL_LBN 16
+#define	ESF_HZ_EV_RXPKTS_LABEL_WIDTH 6
+#define	ESF_HZ_EV_RXPKTS_NUM_PACKETS_LBN 0
+#define	ESF_HZ_EV_RXPKTS_NUM_PACKETS_WIDTH 16
+#define	ESE_HZ_XN_RX_PKTS_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_rx_prefix */
+#define	ESF_HZ_RX_PREFIX_TIMESTAMP_LBN 64
+#define	ESF_HZ_RX_PREFIX_TIMESTAMP_WIDTH 64
+#define	ESF_HZ_RX_PREFIX_USER_LBN 56
+#define	ESF_HZ_RX_PREFIX_USER_WIDTH 8
+#define	ESF_HZ_RX_PREFIX_FILTER_ID_LBN 46
+#define	ESF_HZ_RX_PREFIX_FILTER_ID_WIDTH 10
+#define	ESF_HZ_RX_PREFIX_TIMESTAMP_STATUS_LBN 44
+#define	ESF_HZ_RX_PREFIX_TIMESTAMP_STATUS_WIDTH 2
+#define	ESF_HZ_RX_PREFIX_SENTINEL_LBN 43
+#define	ESF_HZ_RX_PREFIX_SENTINEL_WIDTH 1
+#define	ESF_HZ_RX_PREFIX_ROLLOVER_LBN 42
+#define	ESF_HZ_RX_PREFIX_ROLLOVER_WIDTH 1
+#define	ESF_HZ_RX_PREFIX_L4_STATUS_LBN 41
+#define	ESF_HZ_RX_PREFIX_L4_STATUS_WIDTH 1
+#define	ESF_HZ_RX_PREFIX_L3_STATUS_LBN 40
+#define	ESF_HZ_RX_PREFIX_L3_STATUS_WIDTH 1
+#define	ESF_HZ_RX_PREFIX_L2_STATUS_LBN 38
+#define	ESF_HZ_RX_PREFIX_L2_STATUS_WIDTH 2
+#define	ESF_HZ_RX_PREFIX_L4_CLASS_LBN 36
+#define	ESF_HZ_RX_PREFIX_L4_CLASS_WIDTH 2
+#define	ESF_HZ_RX_PREFIX_L3_CLASS_LBN 34
+#define	ESF_HZ_RX_PREFIX_L3_CLASS_WIDTH 2
+#define	ESF_HZ_RX_PREFIX_L2_CLASS_LBN 32
+#define	ESF_HZ_RX_PREFIX_L2_CLASS_WIDTH 2
+#define	ESF_HZ_RX_PREFIX_CSUM_FRAME_LBN 16
+#define	ESF_HZ_RX_PREFIX_CSUM_FRAME_WIDTH 16
+#define	ESF_HZ_RX_PREFIX_NEXT_FRAME_LOC_LBN 14
+#define	ESF_HZ_RX_PREFIX_NEXT_FRAME_LOC_WIDTH 2
+#define	ESF_HZ_RX_PREFIX_LENGTH_LBN 0
+#define	ESF_HZ_RX_PREFIX_LENGTH_WIDTH 14
+#define	ESE_HZ_XN_RX_PREFIX_STRUCT_SIZE 128
+
+/*------------------------------------------------------------*/
+/* ES_xn_time_sync_evnt */
+#define	ESF_HZ_EV_TSYNC_TYPE_LBN 60
+#define	ESF_HZ_EV_TSYNC_TYPE_WIDTH 4
+#define	ESF_HZ_EV_TSYNC_PHASE_LBN 59
+#define	ESF_HZ_EV_TSYNC_PHASE_WIDTH 1
+#define	ESF_HZ_EV_TSYNC_SUBTYPE_LBN 53
+#define	ESF_HZ_EV_TSYNC_SUBTYPE_WIDTH 6
+#define	ESF_HZ_EV_TSYNC_RSVD_LBN 50
+#define	ESF_HZ_EV_TSYNC_RSVD_WIDTH 3
+#define	ESF_HZ_EV_TSYNC_CLOCK_IS_SET_LBN 49
+#define	ESF_HZ_EV_TSYNC_CLOCK_IS_SET_WIDTH 1
+#define	ESF_HZ_EV_TSYNC_CLOCK_IN_SYNC_LBN 48
+#define	ESF_HZ_EV_TSYNC_CLOCK_IN_SYNC_WIDTH 1
+#define	ESF_HZ_EV_TSYNC_TIME_HIGH_48_LBN 0
+#define	ESF_HZ_EV_TSYNC_TIME_HIGH_48_WIDTH 48
+#define	ESE_HZ_XN_TIME_SYNC_EVNT_STRUCT_SIZE 64
+
+/*------------------------------------------------------------*/
+/* ES_xn_tx_cmplt */
+#define	ESF_HZ_EV_TXCMPL_TYPE_LBN 60
+#define	ESF_HZ_EV_TXCMPL_TYPE_WIDTH 4
+#define	ESF_HZ_EV_TXCMPL_PHASE_LBN 59
+#define	ESF_HZ_EV_TXCMPL_PHASE_WIDTH 1
+#define	ESF_HZ_EV_TXCMPL_RSVD_LBN 56
+#define	ESF_HZ_EV_TXCMPL_RSVD_WIDTH 3
+#define	ESF_HZ_EV_TXCMPL_LABEL_LBN 50
+#define	ESF_HZ_EV_TXCMPL_LABEL_WIDTH 6
+#define	ESF_HZ_EV_TXCMPL_TIMESTAMP_STATUS_LBN 48
+#define	ESF_HZ_EV_TXCMPL_TIMESTAMP_STATUS_WIDTH 2
+#define	ESF_HZ_EV_TXCMPL_SEQUENCE_LBN 40
+#define	ESF_HZ_EV_TXCMPL_SEQUENCE_WIDTH 8
+#define	ESF_HZ_EV_TXCMPL_PARTIAL_TSTAMP_LBN 0
+#define	ESF_HZ_EV_TXCMPL_PARTIAL_TSTAMP_WIDTH 40
+#define	ESE_HZ_XN_TX_CMPLT_STRUCT_SIZE 64
+
+/* Enum PCI_CONSTANTS */
+#define	ESE_HZ_PCI_CONSTANTS_PCI_BASE_CONFIG_SPACE_SIZE 256
+#define	ESE_HZ_PCI_CONSTANTS_PCI_EXPRESS_XCAP_HDR_SIZE 4
+
+/* Enum VIRTIO_BLOCK_FEATURES */
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_WRITE_ZEROES 14
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_DISCARD 13
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_CONFIG_WCE 11
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_TOPOLOGY 10
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_FLUSH 9
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_BLK_SIZE 6
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_RO 5
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_GEOMETRY 4
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_SEG_MAX 2
+#define	ESE_HZ_VIRTIO_BLOCK_FEATURES_VIRTIO_BLK_F_SIZE_MAX 1
+
+/* Enum VIRTIO_COMMON_FEATURES */
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_NOTIFICATION_DATA 38
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_SR_IOV 37
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_ORDER_PLATFORM 36
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_IN_ORDER 35
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_RING_PACKED 34
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_ACCESS_PLATFORM 33
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_VERSION_1 32
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_RING_EVENT_IDX 29
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_RING_INDIRECT_DESC 28
+#define	ESE_HZ_VIRTIO_COMMON_FEATURES_VIRTIO_CMN_F_ANY_LAYOUT 27
+
+/* Enum VIRTIO_NET_FEATURES */
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_SPEED_DUPLEX 63
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_CTRL_MAC_ADDR 23
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_MQ 22
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_GUEST_ANNOUNCE 21
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_CTRL_VLAN 19
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_CTRL_RX 18
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_CTRL_VQ 17
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_STATUS 16
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_MRG_RXBUF 15
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_HOST_UFO 14
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_HOST_ECN 13
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_HOST_TSO6 12
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_HOST_TSO4 11
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_GUEST_UFO 10
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_GUEST_ECN 9
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_GUEST_TSO6 8
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_GUEST_TSO4 7
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_MAC 5
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_MTU 3
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_CTRL_GUEST_OFFLOADS 2
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_GUEST_CSUM 1
+#define	ESE_HZ_VIRTIO_NET_FEATURES_VIRTIO_NET_F_CSUM 0
+
+/* Enum X3_CTL_EVENT_REASON */
+#define	ESE_HZ_X3_CTL_EVENT_REASON_HW_INTERNAL_PORTWIDE 0xA
+#define	ESE_HZ_X3_CTL_EVENT_REASON_HW_INTERNAL 0x9
+#define	ESE_HZ_X3_CTL_EVENT_REASON_CTPIO_BAD_FLAGS 0x8
+#define	ESE_HZ_X3_CTL_EVENT_REASON_CTPIO_BAD_REORDERING 0x7
+#define	ESE_HZ_X3_CTL_EVENT_REASON_CTPIO_FIFO_OVERFLOW 0x6
+#define	ESE_HZ_X3_CTL_EVENT_REASON_CTPIO_ALIGN 0x5
+#define	ESE_HZ_X3_CTL_EVENT_REASON_CTPIO_LEN 0x4
+#define	ESE_HZ_X3_CTL_EVENT_REASON_RX_BAD_BUF_ADDR 0x3
+#define	ESE_HZ_X3_CTL_EVENT_REASON_RX_FIFO_OVERFLOW 0x2
+#define	ESE_HZ_X3_CTL_EVENT_REASON_RX_BAD_DISC 0x1
+#define	ESE_HZ_X3_CTL_EVENT_REASON_MCDI 0x0
+
+/* Enum X3_CTL_EVENT_SUBTYPE */
+#define	ESE_HZ_X3_CTL_EVENT_SUBTYPE_FLUSH 0x2
+#define	ESE_HZ_X3_CTL_EVENT_SUBTYPE_TIME_SYNC 0x1
+#define	ESE_HZ_X3_CTL_EVENT_SUBTYPE_UNSOL_OVERFLOW 0x0
+
+/* Enum X3_FILTER_ID */
+#define	ESE_HZ_X3_FILTER_ID_NO_FILTER_MATCHED 0x3ff
+
+/* Enum X3_L2_CLASS */
+#define	ESE_HZ_X3_L2_CLASS_ETH_01VLAN 1
+#define	ESE_HZ_X3_L2_CLASS_OTHER 0
+
+/* Enum X3_L2_STATUS */
+#define	ESE_HZ_X3_L2_STATUS_RESERVED 3
+#define	ESE_HZ_X3_L2_STATUS_FCS_ERR 2
+#define	ESE_HZ_X3_L2_STATUS_LEN_ERR 1
+#define	ESE_HZ_X3_L2_STATUS_GOOD 0
+
+/* Enum X3_L3_CLASS */
+#define	ESE_HZ_X3_L3_CLASS_RESERVED 3
+#define	ESE_HZ_X3_L3_CLASS_OTHER 2
+#define	ESE_HZ_X3_L3_CLASS_IP6 1
+#define	ESE_HZ_X3_L3_CLASS_IP4 0
+
+/* Enum X3_L3_STATUS */
+#define	ESE_HZ_X3_L3_STATUS_BAD_OR_UNKNOWN 1
+#define	ESE_HZ_X3_L3_STATUS_GOOD 0
+
+/* Enum X3_L4_CLASS */
+#define	ESE_HZ_X3_L4_CLASS_OTHER 3
+#define	ESE_HZ_X3_L4_CLASS_FRAGMENT 2
+#define	ESE_HZ_X3_L4_CLASS_UDP 1
+#define	ESE_HZ_X3_L4_CLASS_TCP 0
+
+/* Enum X3_L4_STATUS */
+#define	ESE_HZ_X3_L4_STATUS_BAD_OR_UNKNOWN 1
+#define	ESE_HZ_X3_L4_STATUS_GOOD 0
+
+/* Enum X3_TX_EVENT_TIMESTAMP_STATUS */
+#define	ESE_HZ_X3_TX_EVENT_TIMESTAMP_STATUS_VALID 0x1
+#define	ESE_HZ_X3_TX_EVENT_TIMESTAMP_STATUS_NOT_TAKEN 0x0
+
+/* Enum XN_CT_THRESH */
+#define	ESE_HZ_XN_CT_THRESH_CTPIO_DIS 0xff
+
+/* Enum XN_EVENT_TYPE */
+#define	ESE_HZ_XN_EVENT_TYPE_MCDI 0x4
+#define	ESE_HZ_XN_EVENT_TYPE_CONTROL 0x3
+#define	ESE_HZ_XN_EVENT_TYPE_TX_COMPLETION 0x1
+#define	ESE_HZ_XN_EVENT_TYPE_RX_PKTS 0x0
+
+/* Enum XN_NEXT_FRAME_LOC */
+#define	ESE_HZ_XN_NEXT_FRAME_LOC_SEPARATELY 0x1
+#define	ESE_HZ_XN_NEXT_FRAME_LOC_TOGETHER 0x0
+
+/* XIL_CFGBAR_TBL_ENTRY */
+#define	ESF_GZ_CFGBAR_CONT_CAP_OFF_HI_LBN 96
+#define	ESF_GZ_CFGBAR_CONT_CAP_OFF_HI_WIDTH 32
+#define	ESF_GZ_CFGBAR_CONT_CAP_OFFSET_LBN 68
+#define	ESF_GZ_CFGBAR_CONT_CAP_OFFSET_WIDTH 60
+#define	ESE_GZ_CONT_CAP_OFFSET_BYTES_SHIFT 4
+#define	ESF_GZ_CFGBAR_CONT_CAP_OFF_LO_LBN 68
+#define	ESF_GZ_CFGBAR_CONT_CAP_OFF_LO_WIDTH 28
+#define	ESF_GZ_CFGBAR_CONT_CAP_RSV_LBN 67
+#define	ESF_GZ_CFGBAR_CONT_CAP_RSV_WIDTH 1
+#define	ESE_GZ_CFGBAR_EFCT_BAR_NUM_INVALID 7
+#define	ESE_GZ_CFGBAR_EFCT_BAR_NUM_EXPANSION_ROM 6
+#define	ESF_GZ_CFGBAR_CONT_CAP_BAR_LBN 64
+#define	ESF_GZ_CFGBAR_CONT_CAP_BAR_WIDTH 3
+#define	ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_INVALID 7
+#define	ESE_GZ_CFGBAR_CONT_CAP_BAR_NUM_EXPANSION_ROM 6
+#define	ESE_GZ_CFGBAR_ENTRY_SIZE_EFCT 24
+#define	ESE_GZ_CFGBAR_ENTRY_HEADER_SIZE 8
+#define	ESE_GZ_CFGBAR_ENTRY_REV_EFCT 0
+#define	ESE_GZ_CFGBAR_ENTRY_LAST 0xfffff
+#define	ESE_GZ_CFGBAR_ENTRY_CONT_CAP_ADDR 0xffffe
+#define	ESE_GZ_CFGBAR_ENTRY_EFCT 0x1
+#define	ESE_GZ_XIL_CFGBAR_TBL_ENTRY_STRUCT_SIZE 128
+
+#define EFCT_VSEC_TABLE_ENTRY_OFFSET 0x10
+#define EFCT_VSEC_ENTRY_PROJECT_ID_VAL 0x5833
+#define EFCT_VSEC_ENTRY_TYPE_REV_VAL 0
+#define EFCT_VSEC_ENTRY_TABLE_TYPE_VAL 0x20
+/* XIL_CFGBAR_VSEC */
+#define	ESF_GZ_VSEC_TBL_OFF_HI_LBN 64
+#define	ESF_GZ_VSEC_TBL_OFF_HI_WIDTH 32
+#define	ESE_GZ_VSEC_TBL_OFF_HI_BYTES_SHIFT 32
+#define	ESF_GZ_VSEC_TBL_OFF_LO_LBN 36
+#define	ESF_GZ_VSEC_TBL_OFF_LO_WIDTH 28
+#define	ESE_GZ_VSEC_TBL_OFF_LO_BYTES_SHIFT 4
+#define	ESF_GZ_VSEC_TBL_BAR_LBN 32
+#define	ESF_GZ_VSEC_TBL_BAR_WIDTH 4
+#define	ESE_GZ_VSEC_BAR_NUM_INVALID 7
+#define	ESE_GZ_VSEC_BAR_NUM_EXPANSION_ROM 6
+#define	ESE_GZ_VSEC_LEN_HIGH_OFFT 16
+#define	ESE_GZ_VSEC_LEN_MIN 12
+#define	ESE_GZ_VSEC_VER_XIL_CFGBAR 0
+#define	ESE_GZ_XLNX_VSEC_ID 0x20
+#define	ESE_GZ_XIL_CFGBAR_VSEC_STRUCT_SIZE 96
+
+/* Enum DESIGN_PARAMS */
+#define	ESE_EFCT_DP_GZ_EV_QUEUES 18
+#define	ESE_EFCT_DP_GZ_EVQ_SIZES 17
+#define	ESE_EFCT_DP_GZ_RX_MAX_RUNT 16
+#define	ESE_EFCT_DP_GZ_RX_L4_CSUM_PROTOCOLS 15
+#define	ESE_EFCT_DP_GZ_EVQ_UNSOL_CREDIT_SEQ_BITS 14
+#define	ESE_EFCT_DP_GZ_PARTIAL_TSTAMP_SUB_NANO_BITS 13
+#define	ESE_EFCT_DP_GZ_TX_PACKET_FIFO_SIZE 12
+#define	ESE_EFCT_DP_GZ_TX_CTPIO_APERTURE_SIZE 11
+#define	ESE_EFCT_DP_GZ_TX_MAXIMUM_REORDER 10
+#define	ESE_EFCT_DP_GZ_RX_METADATA_LENGTH 9
+#define	ESE_EFCT_DP_GZ_FRAME_OFFSET_FIXED 8
+#define	ESE_EFCT_DP_GZ_RX_BUFFER_FIFO_SIZE 7
+#define	ESE_EFCT_DP_GZ_TX_CTPIO_APERTURES 6
+#define	ESE_EFCT_DP_GZ_RX_QUEUES 5
+#define	ESE_EFCT_DP_GZ_RX_BUFFER_SIZE 4
+#define	ESE_EFCT_DP_GZ_CTPIO_STRIDE 3
+#define	ESE_EFCT_DP_GZ_EVQ_STRIDE 2
+#define	ESE_EFCT_DP_GZ_RX_STRIDE 1
+#define	ESE_EFCT_DP_GZ_PAD 0
+
+#define	ESF_GZ_TX_SEND_ADDR_WIDTH 64
+
+/* Enum XN_EVENT_TYPE */
+#define	ESE_HZ_XN_EVENT_TYPE_DRIVER 0x5
+#define	ESF_HZ_DRIVER_DATA_LBN 0
+#define	ESF_HZ_DRIVER_DATA_WIDTH 59
+
+#endif /* EFCT_REG_H */
diff --git a/drivers/net/ethernet/amd/efct/mcdi.c b/drivers/net/ethernet/amd/efct/mcdi.c
new file mode 100644
index 000000000000..80e9fc928eb5
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi.c
@@ -0,0 +1,1817 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/delay.h>
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include "efct_common.h"
+#include "efct_io.h"
+#include "mcdi.h"
+#include "mcdi_pcol.h"
+struct efct_mcdi_copy_buffer {
+	union efct_dword buffer[DIV_ROUND_UP(MCDI_CTL_SDU_LEN_MAX, 4)];
+};
+
+/**************************************************************************
+ *
+ * Management-Controller-to-Driver Interface
+ *
+ **************************************************************************
+ */
+
+/* Default RPC timeout for NIC types that don't specify. */
+#define MCDI_RPC_TIMEOUT	(10 * HZ)
+/* Timeout for acquiring the bus; there may be multiple outstanding requests. */
+#define MCDI_ACQUIRE_TIMEOUT	(MCDI_RPC_TIMEOUT * 5)
+/* Timeout waiting for a command to be authorised */
+#define MCDI_PROXY_TIMEOUT	(10 * HZ)
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+/* printk has this internal limit. Taken from printk.c. */
+#define LOG_LINE_MAX		(1024 - 32)
+#endif
+
+/* A reboot/assertion causes the MCDI status word to be set after the
+ * command word is set or a REBOOT event is sent. If we notice a reboot
+ * via these mechanisms then wait 250ms for the status word to be set.
+ */
+#define MCDI_STATUS_DELAY_US		100
+#define MCDI_STATUS_DELAY_COUNT		2500
+#define MCDI_STATUS_SLEEP_MS						\
+	(MCDI_STATUS_DELAY_US * MCDI_STATUS_DELAY_COUNT / 1000)
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+static bool mcdi_logging_default = true;
+#endif
+
+static int efct_mcdi_rpc_async_internal(struct efct_nic *efct,
+					struct efct_mcdi_cmd *cmd,
+				       u32 *handle,
+				       bool immediate_poll,
+				       bool immediate_only);
+static void efct_mcdi_start_or_queue(struct efct_mcdi_iface *mcdi,
+				     bool allow_retry,
+				    struct efct_mcdi_copy_buffer *copybuf,
+				    struct list_head *cleanup_list);
+static void efct_mcdi_cmd_start_or_queue(struct efct_mcdi_iface *mcdi,
+					 struct efct_mcdi_cmd *cmd,
+					struct efct_mcdi_copy_buffer *copybuf,
+					struct list_head *cleanup_list);
+static int efct_mcdi_cmd_start_or_queue_ext(struct efct_mcdi_iface *mcdi,
+					    struct efct_mcdi_cmd *cmd,
+					   struct efct_mcdi_copy_buffer *copybuf,
+					   bool immediate_only,
+					   struct list_head *cleanup_list);
+static void efct_mcdi_poll_start(struct efct_mcdi_iface *mcdi,
+				 struct efct_mcdi_cmd *cmd,
+				struct efct_mcdi_copy_buffer *copybuf,
+				struct list_head *cleanup_list);
+static bool efct_mcdi_poll_once(struct efct_mcdi_iface *mcdi,
+				struct efct_mcdi_cmd *cmd);
+static bool efct_mcdi_complete_cmd(struct efct_mcdi_iface *mcdi,
+				   struct efct_mcdi_cmd *cmd,
+				  struct efct_mcdi_copy_buffer *copybuf,
+				  struct list_head *cleanup_list);
+static void efct_mcdi_timeout_cmd(struct efct_mcdi_iface *mcdi,
+				  struct efct_mcdi_cmd *cmd,
+				 struct list_head *cleanup_list);
+static void efct_mcdi_reset_during_cmd(struct efct_mcdi_iface *mcdi,
+				       struct efct_mcdi_cmd *cmd);
+static void efct_mcdi_cmd_work(struct work_struct *work);
+static void _efct_mcdi_mode_poll(struct efct_mcdi_iface *mcdi);
+static void efct_mcdi_mode_fail(struct efct_nic *efct, struct list_head *cleanup_list);
+static void _efct_mcdi_display_error(struct efct_nic *efct, u32 cmd,
+				     size_t inlen, int raw, int arg, int rc);
+
+static bool efct_cmd_running(struct efct_mcdi_cmd *cmd)
+{
+	return cmd->state == MCDI_STATE_RUNNING ||
+	       cmd->state == MCDI_STATE_RUNNING_CANCELLED;
+}
+
+static bool efct_cmd_cancelled(struct efct_mcdi_cmd *cmd)
+{
+	return cmd->state == MCDI_STATE_RUNNING_CANCELLED ||
+	       cmd->state == MCDI_STATE_PROXY_CANCELLED;
+}
+
+static void efct_mcdi_cmd_release(struct kref *ref)
+{
+	kfree(container_of(ref, struct efct_mcdi_cmd, ref));
+}
+
+static u32 efct_mcdi_cmd_handle(struct efct_mcdi_cmd *cmd)
+{
+	return cmd->handle;
+}
+
+static void _efct_mcdi_remove_cmd(struct efct_mcdi_iface *mcdi,
+				  struct efct_mcdi_cmd *cmd,
+				 struct list_head *cleanup_list)
+{
+	/* if cancelled, the completers have already been called */
+	if (efct_cmd_cancelled(cmd))
+		return;
+
+	if (cmd->atomic_completer)
+		cmd->atomic_completer(mcdi->efct, cmd->cookie, cmd->rc,
+				      cmd->outbuf, cmd->outlen);
+	if (cmd->completer) {
+		list_add_tail(&cmd->cleanup_list, cleanup_list);
+		++mcdi->outstanding_cleanups;
+		kref_get(&cmd->ref);
+	}
+}
+
+static void efct_mcdi_remove_cmd(struct efct_mcdi_iface *mcdi,
+				 struct efct_mcdi_cmd *cmd,
+				struct list_head *cleanup_list)
+{
+	list_del(&cmd->list);
+	_efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+	cmd->state = MCDI_STATE_FINISHED;
+	kref_put(&cmd->ref, efct_mcdi_cmd_release);
+	if (list_empty(&mcdi->cmd_list))
+		wake_up(&mcdi->cmd_complete_wq);
+}
+
+static unsigned long efct_mcdi_rpc_timeout(struct efct_nic *efct, u32 cmd)
+{
+	if (!efct->type->mcdi_rpc_timeout)
+		return MCDI_RPC_TIMEOUT;
+	else
+		return efct->type->mcdi_rpc_timeout(efct, cmd);
+}
+
+int efct_mcdi_init(struct efct_nic *efct)
+{
+	struct efct_mcdi_iface *mcdi;
+	int rc = -ENOMEM;
+
+	efct->mcdi = kzalloc(sizeof(*efct->mcdi), GFP_KERNEL);
+	if (!efct->mcdi)
+		goto fail;
+
+	mcdi = efct_mcdi(efct);
+	mcdi->efct = efct;
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	mcdi->logging_buffer = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
+	if (!mcdi->logging_buffer)
+		goto fail2;
+	mcdi->logging_enabled = mcdi_logging_default;
+	efct->efct_dev->mcdi_logging = mcdi->logging_enabled;
+#endif
+	mcdi->workqueue = alloc_ordered_workqueue("mcdi_wq", WQ_MEM_RECLAIM);
+	if (!mcdi->workqueue)
+		goto fail3;
+	spin_lock_init(&mcdi->iface_lock);
+	mcdi->mode = MCDI_MODE_POLL;
+	INIT_LIST_HEAD(&mcdi->cmd_list);
+	init_waitqueue_head(&mcdi->cmd_complete_wq);
+
+	(void)efct_mcdi_poll_reboot(efct);
+	mcdi->new_epoch = true;
+
+	/* Recover from a failed assertion before probing */
+	rc = efct_mcdi_handle_assertion(efct);
+	if (rc) {
+		netif_err(efct, probe, efct->net_dev,
+			  "Unable to handle assertion\n");
+		goto fail4;
+	}
+
+	/* Let the MC (and BMC, if this is a LOM) know that the driver
+	 * is loaded. We should do this before we reset the NIC.
+	 * This operation can specify the required firmware variant.
+	 * For X3, the firmware Variant is 0
+	 */
+	rc = efct_mcdi_drv_attach(efct, MC_CMD_FW_FULL_FEATURED, &efct->mcdi->fn_flags, false);
+	if (rc) {
+		netif_err(efct, probe, efct->net_dev,
+			  "Unable to register driver with MCPU\n");
+		goto fail4;
+	}
+
+	return 0;
+fail4:
+	destroy_workqueue(mcdi->workqueue);
+fail3:
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	kfree(mcdi->logging_buffer);
+fail2:
+#endif
+	kfree(efct->mcdi);
+	efct->mcdi = NULL;
+fail:
+	return rc;
+}
+
+void efct_mcdi_detach(struct efct_nic *efct)
+{
+	if (!efct->mcdi)
+		return;
+
+	if (!efct_nic_hw_unavailable(efct))
+		/* Relinquish the device (back to the BMC, if this is a LOM) */
+		efct_mcdi_drv_detach(efct);
+}
+
+void efct_mcdi_fini(struct efct_nic *efct)
+{
+	struct efct_mcdi_iface *iface;
+
+	if (!efct->mcdi)
+		return;
+
+	efct_mcdi_wait_for_cleanup(efct);
+
+	iface = efct_mcdi(efct);
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	kfree(iface->logging_buffer);
+#endif
+
+	destroy_workqueue(iface->workqueue);
+	kfree(efct->mcdi);
+	efct->mcdi = NULL;
+}
+
+static bool efct_mcdi_reset_cmd_running(struct efct_mcdi_iface *mcdi)
+{
+	struct efct_mcdi_cmd *cmd;
+
+	list_for_each_entry(cmd, &mcdi->cmd_list, list)
+		if (cmd->cmd == MC_CMD_REBOOT &&
+		    efct_cmd_running(cmd))
+			return true;
+	return false;
+}
+
+static void efct_mcdi_reboot_detected(struct efct_nic *efct)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	struct efct_mcdi_cmd *cmd;
+
+	if (!mcdi)
+		return;
+
+	_efct_mcdi_mode_poll(mcdi);
+	list_for_each_entry(cmd, &mcdi->cmd_list, list)
+		if (efct_cmd_running(cmd))
+			cmd->reboot_seen = true;
+
+	if (efct->type->mcdi_reboot_detected)
+		efct->type->mcdi_reboot_detected(efct);
+}
+
+static bool efct_mcdi_wait_for_reboot(struct efct_nic *efct)
+{
+	size_t count;
+
+	for (count = 0; count < MCDI_STATUS_DELAY_COUNT; ++count) {
+		if (efct_mcdi_poll_reboot(efct)) {
+			efct_mcdi_reboot_detected(efct);
+			return true;
+		}
+		udelay(MCDI_STATUS_DELAY_US);
+	}
+
+	return false;
+}
+
+static bool efct_mcdi_flushed(struct efct_mcdi_iface *mcdi, bool ignore_cleanups)
+{
+	bool flushed;
+
+	spin_lock_bh(&mcdi->iface_lock);
+	flushed = list_empty(&mcdi->cmd_list) &&
+		  (ignore_cleanups || !mcdi->outstanding_cleanups);
+	spin_unlock_bh(&mcdi->iface_lock);
+	return flushed;
+}
+
+/* Wait for outstanding MCDI commands to complete. */
+void efct_mcdi_wait_for_cleanup(struct efct_nic *efct)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+
+	if (!mcdi)
+		return;
+
+	wait_event(mcdi->cmd_complete_wq,
+		   efct_mcdi_flushed(mcdi, false));
+}
+
+static void efct_mcdi_send_request(struct efct_nic *efct,
+				   struct efct_mcdi_cmd *cmd)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	const union efct_dword *inbuf = cmd->inbuf;
+	size_t inlen = cmd->inlen;
+	union efct_dword hdr[2];
+	size_t hdr_len;
+	u32 xflags;
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	char *buf;
+#endif
+
+	if (!mcdi) {
+		netif_err(efct, drv, efct->net_dev, "Cuaght null pointer for mcdi\n");
+		return;
+	}
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	buf = mcdi->logging_buffer; /* page-sized */
+#endif
+
+	mcdi->prev_seq = cmd->seq;
+	mcdi->seq_held_by[cmd->seq] = cmd;
+	mcdi->db_held_by = cmd;
+	cmd->started = jiffies;
+
+	xflags = 0;
+	if (mcdi->mode == MCDI_MODE_EVENTS)
+		xflags |= MCDI_HEADER_XFLAGS_EVREQ;
+
+	if (efct->type->mcdi_max_ver == 1) {
+		/* MCDI v1 */
+		EFCT_POPULATE_DWORD_7(hdr[0],
+				      MCDI_HEADER_RESPONSE, 0,
+				     MCDI_HEADER_RESYNC, 1,
+				     MCDI_HEADER_CODE, cmd->cmd,
+				     MCDI_HEADER_DATALEN, inlen,
+				     MCDI_HEADER_SEQ, cmd->seq,
+				     MCDI_HEADER_XFLAGS, xflags,
+				     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
+		hdr_len = 4;
+	} else {
+		/* MCDI v2 */
+		WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
+		EFCT_POPULATE_DWORD_7(hdr[0],
+				      MCDI_HEADER_RESPONSE, 0,
+				     MCDI_HEADER_RESYNC, 1,
+				     MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
+				     MCDI_HEADER_DATALEN, 0,
+				     MCDI_HEADER_SEQ, cmd->seq,
+				     MCDI_HEADER_XFLAGS, xflags,
+				     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
+		EFCT_POPULATE_DWORD_2(hdr[1],
+				      MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd->cmd,
+				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
+		hdr_len = 8;
+	}
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	if (mcdi->logging_enabled && !WARN_ON_ONCE(!buf)) {
+		const union efct_dword *frags[] = { hdr, inbuf };
+		size_t frag_len[] = { hdr_len, round_up(inlen, 4) };
+		const union efct_dword *frag;
+		int bytes = 0;
+		int i, j;
+		u32 dcount = 0;
+		/* Header length should always be a whole number of dwords,
+		 * so scream if it's not.
+		 */
+		WARN_ON_ONCE(hdr_len % 4);
+
+		for (j = 0; j < ARRAY_SIZE(frags); j++) {
+			frag = frags[j];
+			for (i = 0;
+			     i < frag_len[j] / 4;
+			     i++) {
+				/* Do not exceed the internal printk limit.
+				 * The string before that is just over 70 bytes.
+				 */
+				if ((bytes + 75) > LOG_LINE_MAX) {
+					netif_info(efct, hw, efct->net_dev,
+						   "MCDI RPC REQ:%s \\\n", buf);
+					dcount = 0;
+					bytes = 0;
+				}
+				bytes += snprintf(buf + bytes,
+						  LOG_LINE_MAX - bytes, " %08x",
+						  le32_to_cpu(frag[i].word32));
+				dcount++;
+			}
+		}
+
+		netif_info(efct, hw, efct->net_dev, "MCDI RPC REQ:%s\n", buf);
+	}
+#endif
+
+	efct->type->mcdi_request(efct, cmd->bufid, hdr, hdr_len, inbuf, inlen);
+
+	mcdi->new_epoch = false;
+}
+
+static int efct_mcdi_errno(struct efct_nic *efct, u32 mcdi_err)
+{
+	switch (mcdi_err) {
+	case 0:
+	case MC_CMD_ERR_PROXY_PENDING:
+	case MC_CMD_ERR_QUEUE_FULL:
+		return mcdi_err;
+	case MC_CMD_ERR_EPERM:
+		return -EPERM;
+	case MC_CMD_ERR_ENOENT:
+		return -ENOENT;
+	case MC_CMD_ERR_EINTR:
+		return -EINTR;
+	case MC_CMD_ERR_EAGAIN:
+		return -EAGAIN;
+	case MC_CMD_ERR_EACCES:
+		return -EACCES;
+	case MC_CMD_ERR_EBUSY:
+		return -EBUSY;
+	case MC_CMD_ERR_EINVAL:
+		return -EINVAL;
+	case MC_CMD_ERR_ERANGE:
+		return -ERANGE;
+	case MC_CMD_ERR_EDEADLK:
+		return -EDEADLK;
+	case MC_CMD_ERR_ENOSYS:
+		return -EOPNOTSUPP;
+	case MC_CMD_ERR_ETIME:
+		return -ETIME;
+	case MC_CMD_ERR_EALREADY:
+		return -EALREADY;
+	case MC_CMD_ERR_ENOSPC:
+		return -ENOSPC;
+	case MC_CMD_ERR_ENOMEM:
+		return -ENOMEM;
+	case MC_CMD_ERR_ENOTSUP:
+		return -EOPNOTSUPP;
+	case MC_CMD_ERR_ALLOC_FAIL:
+		return -ENOBUFS;
+	case MC_CMD_ERR_MAC_EXIST:
+		return -EADDRINUSE;
+	case MC_CMD_ERR_NO_EVB_PORT:
+		return -EAGAIN;
+	default:
+		return -EPROTO;
+	}
+}
+
+/* Test and clear MC-rebooted flag for this port/function; reset
+ * software state as necessary.
+ */
+int efct_mcdi_poll_reboot(struct efct_nic *efct)
+{
+	if (!efct->mcdi)
+		return 0;
+
+	return efct->type->mcdi_poll_reboot(efct);
+}
+
+static void efct_mcdi_process_cleanup_list(struct efct_nic *efct,
+					   struct list_head *cleanup_list)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	u32 cleanups = 0;
+
+	while (!list_empty(cleanup_list)) {
+		struct efct_mcdi_cmd *cmd =
+			list_first_entry(cleanup_list,
+					 struct efct_mcdi_cmd, cleanup_list);
+		cmd->completer(efct, cmd->cookie, cmd->rc,
+			       cmd->outbuf, cmd->outlen);
+		list_del(&cmd->cleanup_list);
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		++cleanups;
+	}
+
+	if (cleanups) {
+		bool all_done;
+
+		spin_lock_bh(&mcdi->iface_lock);
+		WARN_ON_ONCE(cleanups > mcdi->outstanding_cleanups);
+		all_done = (mcdi->outstanding_cleanups -= cleanups) == 0;
+		spin_unlock_bh(&mcdi->iface_lock);
+		if (all_done)
+			wake_up(&mcdi->cmd_complete_wq);
+	}
+}
+
+static void _efct_mcdi_cancel_cmd(struct efct_mcdi_iface *mcdi,
+				  u32 handle,
+				  struct list_head *cleanup_list)
+{
+	struct efct_nic *efct = mcdi->efct;
+	struct efct_mcdi_cmd *cmd;
+
+	list_for_each_entry(cmd, &mcdi->cmd_list, list)
+		if (efct_mcdi_cmd_handle(cmd) == handle) {
+			switch (cmd->state) {
+			case MCDI_STATE_QUEUED:
+			case MCDI_STATE_RETRY:
+				netif_dbg(efct, drv, efct->net_dev,
+					  "command %#x inlen %zu cancelled in queue\n",
+					  cmd->cmd, cmd->inlen);
+				/* if not yet running, properly cancel it */
+				cmd->rc = -EPIPE;
+				efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+				break;
+			case MCDI_STATE_RUNNING:
+			case MCDI_STATE_PROXY:
+				netif_dbg(efct, drv, efct->net_dev,
+					  "command %#x inlen %zu cancelled after sending\n",
+					  cmd->cmd, cmd->inlen);
+				/* It's running. We can't cancel it on the MC,
+				 * so we need to keep track of it so we can
+				 * handle the response. We *also* need to call
+				 * the command's completion function, and make
+				 * sure it's not called again later, by
+				 * marking it as cancelled.
+				 */
+				cmd->rc = -EPIPE;
+				_efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+				cmd->state = cmd->state == MCDI_STATE_RUNNING ?
+					     MCDI_STATE_RUNNING_CANCELLED :
+					     MCDI_STATE_PROXY_CANCELLED;
+				break;
+			case MCDI_STATE_RUNNING_CANCELLED:
+			case MCDI_STATE_PROXY_CANCELLED:
+				netif_warn(efct, drv, efct->net_dev,
+					   "command %#x inlen %zu double cancelled\n",
+					   cmd->cmd, cmd->inlen);
+				break;
+			case MCDI_STATE_FINISHED:
+			default:
+				/* invalid state? */
+				WARN_ON(1);
+			}
+			break;
+		}
+}
+
+void efct_mcdi_cancel_cmd(struct efct_nic *efct, u32 handle)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	LIST_HEAD(cleanup_list);
+
+	if (!mcdi)
+		return;
+
+	spin_lock_bh(&mcdi->iface_lock);
+	_efct_mcdi_cancel_cmd(mcdi, handle, &cleanup_list);
+	spin_unlock_bh(&mcdi->iface_lock);
+	efct_mcdi_process_cleanup_list(efct, &cleanup_list);
+}
+
+static void efct_mcdi_proxy_response(struct efct_mcdi_iface *mcdi,
+				     struct efct_mcdi_cmd *cmd,
+				    int status,
+				    struct list_head *cleanup_list)
+{
+	mcdi->db_held_by = NULL;
+
+	if (status) {
+		/* status != 0 means don't retry */
+		if (status == -EIO || status == -EINTR)
+			efct_mcdi_reset_during_cmd(mcdi, cmd);
+		kref_get(&cmd->ref);
+		cmd->rc = status;
+		efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+		if (cancel_delayed_work(&cmd->work))
+			kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+	} else {
+		/* status = 0 means ok to retry */
+		efct_mcdi_cmd_start_or_queue(mcdi, cmd, NULL, cleanup_list);
+	}
+}
+
+static void efct_mcdi_ev_proxy_response(struct efct_nic *efct,
+					u32 handle, int status)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	struct efct_mcdi_cmd *cmd;
+	LIST_HEAD(cleanup_list);
+	bool found = false;
+
+	spin_lock_bh(&mcdi->iface_lock);
+	list_for_each_entry(cmd, &mcdi->cmd_list, list)
+		if (cmd->state == MCDI_STATE_PROXY &&
+		    cmd->proxy_handle == handle) {
+			efct_mcdi_proxy_response(mcdi, cmd, status, &cleanup_list);
+			found = true;
+			break;
+		}
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	efct_mcdi_process_cleanup_list(efct, &cleanup_list);
+
+	if (!found) {
+		netif_err(efct, drv, efct->net_dev,
+			  "MCDI proxy unexpected handle %#x\n",
+			  handle);
+		efct_schedule_reset(efct, RESET_TYPE_WORLD);
+	}
+}
+
+static void efct_mcdi_ev_cpl(struct efct_nic *efct, u32 seqno,
+			     u32 datalen, u32 mcdi_err)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	struct efct_mcdi_cmd *cmd;
+	LIST_HEAD(cleanup_list);
+	struct efct_mcdi_copy_buffer *copybuf;
+
+	copybuf = kmalloc(sizeof(*copybuf), GFP_ATOMIC);
+	if (!mcdi) {
+		kfree(copybuf);
+		return;
+	}
+
+	spin_lock(&mcdi->iface_lock);
+	cmd = mcdi->seq_held_by[seqno];
+	if (cmd) {
+		kref_get(&cmd->ref);
+		if (efct_mcdi_complete_cmd(mcdi, cmd, copybuf, &cleanup_list))
+			if (cancel_delayed_work(&cmd->work))
+				kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+	} else {
+		netif_err(efct, hw, efct->net_dev,
+			  "MC response unexpected tx seq 0x%x\n",
+			  seqno);
+		/* this could theoretically just be a race between command
+		 * time out and processing the completion event,  so while not
+		 * a good sign, it'd be premature to attempt any recovery.
+		 */
+	}
+	spin_unlock(&mcdi->iface_lock);
+
+	efct_mcdi_process_cleanup_list(efct, &cleanup_list);
+
+	kfree(copybuf);
+}
+
+static int
+efct_mcdi_check_supported(struct efct_nic *efct, u32 cmd, size_t inlen)
+{
+	if (efct->type->mcdi_max_ver < 0 ||
+	    (efct->type->mcdi_max_ver < 2 &&
+	     cmd > MC_CMD_CMD_SPACE_ESCAPE_7)) {
+		netif_err(efct, hw, efct->net_dev, "Invalid MCDI version\n");
+		return -EINVAL;
+	}
+
+	if (inlen > MCDI_CTL_SDU_LEN_MAX_V2 ||
+	    (efct->type->mcdi_max_ver < 2 &&
+	     inlen > MCDI_CTL_SDU_LEN_MAX_V1)) {
+		netif_err(efct, hw, efct->net_dev, "Invalid MCDI inlen\n");
+		return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+struct efct_mcdi_blocking_data {
+	struct kref ref;
+	bool done;
+	wait_queue_head_t wq;
+	int rc;
+	union efct_dword *outbuf;
+	size_t outlen;
+	size_t outlen_actual;
+};
+
+static void efct_mcdi_blocking_data_release(struct kref *ref)
+{
+	kfree(container_of(ref, struct efct_mcdi_blocking_data, ref));
+}
+
+static void efct_mcdi_rpc_completer(struct efct_nic *efct, unsigned long cookie,
+				    int rc, union efct_dword *outbuf,
+				   size_t outlen_actual)
+{
+	struct efct_mcdi_blocking_data *wait_data =
+		(struct efct_mcdi_blocking_data *)cookie;
+
+	wait_data->rc = rc;
+	memcpy(wait_data->outbuf, outbuf,
+	       min(outlen_actual, wait_data->outlen));
+	wait_data->outlen_actual = outlen_actual;
+	/*memory barrier*/
+	smp_wmb();
+	wait_data->done = true;
+	wake_up(&wait_data->wq);
+	kref_put(&wait_data->ref, efct_mcdi_blocking_data_release);
+}
+
+static int efct_mcdi_rpc_sync(struct efct_nic *efct, u32 cmd,
+			      const union efct_dword *inbuf, size_t inlen,
+			      union efct_dword *outbuf, size_t outlen,
+			      size_t *outlen_actual, bool quiet)
+{
+	struct efct_mcdi_blocking_data *wait_data;
+	struct efct_mcdi_cmd *cmd_item;
+	u32 handle;
+	int rc;
+
+	if (outlen_actual)
+		*outlen_actual = 0;
+
+	wait_data = kmalloc(sizeof(*wait_data), GFP_KERNEL);
+	if (!wait_data)
+		return -ENOMEM;
+
+	cmd_item = kmalloc(sizeof(*cmd_item), GFP_KERNEL);
+	if (!cmd_item) {
+		kfree(wait_data);
+		return -ENOMEM;
+	}
+
+	kref_init(&wait_data->ref);
+	wait_data->done = false;
+	init_waitqueue_head(&wait_data->wq);
+	wait_data->outbuf = outbuf;
+	wait_data->outlen = outlen;
+
+	kref_init(&cmd_item->ref);
+	cmd_item->quiet = quiet;
+	cmd_item->cookie = (unsigned long)wait_data;
+	cmd_item->atomic_completer = NULL;
+	cmd_item->completer = &efct_mcdi_rpc_completer;
+	cmd_item->cmd = cmd;
+	cmd_item->inlen = inlen;
+	cmd_item->inbuf = inbuf;
+
+	/* Claim an extra reference for the completer to put. */
+	kref_get(&wait_data->ref);
+	rc = efct_mcdi_rpc_async_internal(efct, cmd_item, &handle, true, false);
+	if (rc) {
+		kref_put(&wait_data->ref, efct_mcdi_blocking_data_release);
+		goto out;
+	}
+
+	if (!wait_event_timeout(wait_data->wq, wait_data->done,
+				MCDI_ACQUIRE_TIMEOUT +
+				efct_mcdi_rpc_timeout(efct, cmd)) &&
+	    !wait_data->done) {
+		netif_err(efct, drv, efct->net_dev,
+			  "MC command 0x%x inlen %zu timed out (sync)\n",
+			  cmd, inlen);
+
+		efct_mcdi_cancel_cmd(efct, handle);
+
+		wait_data->rc = -ETIMEDOUT;
+		wait_data->outlen_actual = 0;
+	}
+
+	if (outlen_actual)
+		*outlen_actual = wait_data->outlen_actual;
+	rc = wait_data->rc;
+
+out:
+	kref_put(&wait_data->ref, efct_mcdi_blocking_data_release);
+
+	return rc;
+}
+
+int efct_mcdi_rpc_async_ext(struct efct_nic *efct, u32 cmd,
+			    const union efct_dword *inbuf, size_t inlen,
+			   efct_mcdi_async_completer *atomic_completer,
+			   efct_mcdi_async_completer *completer,
+			   unsigned long cookie, bool quiet,
+			   bool immediate_only, u32 *handle)
+{
+	struct efct_mcdi_cmd *cmd_item =
+		kmalloc(sizeof(struct efct_mcdi_cmd) + inlen, GFP_ATOMIC);
+
+	if (!cmd_item)
+		return -ENOMEM;
+
+	kref_init(&cmd_item->ref);
+	cmd_item->quiet = quiet;
+	cmd_item->cookie = cookie;
+	cmd_item->completer = completer;
+	cmd_item->atomic_completer = atomic_completer;
+	cmd_item->cmd = cmd;
+	cmd_item->inlen = inlen;
+	/* inbuf is probably not valid after return, so take a copy */
+	cmd_item->inbuf = (union efct_dword *)(cmd_item + 1);
+	memcpy(cmd_item + 1, inbuf, inlen);
+
+	return efct_mcdi_rpc_async_internal(efct, cmd_item, handle, false,
+					   immediate_only);
+}
+
+static bool efct_mcdi_get_seq(struct efct_mcdi_iface *mcdi, unsigned char *seq)
+{
+	*seq = mcdi->prev_seq;
+	do {
+		*seq = (*seq + 1) % ARRAY_SIZE(mcdi->seq_held_by);
+	} while (mcdi->seq_held_by[*seq] && *seq != mcdi->prev_seq);
+	return !mcdi->seq_held_by[*seq];
+}
+
+static int efct_mcdi_rpc_async_internal(struct efct_nic *efct,
+					struct efct_mcdi_cmd *cmd,
+				       u32 *handle,
+				       bool immediate_poll, bool immediate_only)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	struct efct_mcdi_copy_buffer *copybuf;
+	LIST_HEAD(cleanup_list);
+	int rc;
+
+	rc = efct_mcdi_check_supported(efct, cmd->cmd, cmd->inlen);
+	if (rc) {
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		return rc;
+	}
+	if (!mcdi || efct->mc_bist_for_other_fn) {
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		return -ENETDOWN;
+	}
+
+	copybuf = immediate_poll ?
+		  kmalloc(sizeof(struct efct_mcdi_copy_buffer), GFP_KERNEL) :
+		  NULL;
+
+	cmd->mcdi = mcdi;
+	INIT_DELAYED_WORK(&cmd->work, efct_mcdi_cmd_work);
+	INIT_LIST_HEAD(&cmd->list);
+	INIT_LIST_HEAD(&cmd->cleanup_list);
+	cmd->proxy_handle = 0;
+	cmd->rc = 0;
+	cmd->outbuf = NULL;
+	cmd->outlen = 0;
+
+	spin_lock_bh(&mcdi->iface_lock);
+
+	if (mcdi->mode == MCDI_MODE_FAIL) {
+		spin_unlock_bh(&mcdi->iface_lock);
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		kfree(copybuf);
+		return -ENETDOWN;
+	}
+
+	cmd->handle = mcdi->prev_handle++;
+	if (handle)
+		*handle = efct_mcdi_cmd_handle(cmd);
+
+	list_add_tail(&cmd->list, &mcdi->cmd_list);
+	rc = efct_mcdi_cmd_start_or_queue_ext(mcdi, cmd, copybuf, immediate_only,
+					      &cleanup_list);
+	if (rc) {
+		list_del(&cmd->list);
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+	}
+
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	efct_mcdi_process_cleanup_list(efct, &cleanup_list);
+
+	kfree(copybuf);
+
+	return rc;
+}
+
+static int efct_mcdi_cmd_start_or_queue_ext(struct efct_mcdi_iface *mcdi,
+					    struct efct_mcdi_cmd *cmd,
+					   struct efct_mcdi_copy_buffer *copybuf,
+					   bool immediate_only,
+					   struct list_head *cleanup_list)
+{
+	struct efct_nic *efct = mcdi->efct;
+	u8 seq, bufid;
+	int rc = 0;
+
+	if (!mcdi->db_held_by &&
+	    efct_mcdi_get_seq(mcdi, &seq) &&
+	    efct->type->mcdi_get_buf(efct, &bufid)) {
+		cmd->seq = seq;
+		cmd->bufid = bufid;
+		cmd->polled = mcdi->mode == MCDI_MODE_POLL;
+		cmd->reboot_seen = false;
+		efct_mcdi_send_request(efct, cmd);
+		cmd->state = MCDI_STATE_RUNNING;
+
+		if (cmd->polled) {
+			efct_mcdi_poll_start(mcdi, cmd, copybuf, cleanup_list);
+		} else {
+			kref_get(&cmd->ref);
+			queue_delayed_work(mcdi->workqueue, &cmd->work,
+					   efct_mcdi_rpc_timeout(efct, cmd->cmd));
+		}
+	} else if (immediate_only) {
+		rc = -EAGAIN;
+	} else {
+		cmd->state = MCDI_STATE_QUEUED;
+	}
+
+	return rc;
+}
+
+static void efct_mcdi_cmd_start_or_queue(struct efct_mcdi_iface *mcdi,
+					 struct efct_mcdi_cmd *cmd,
+					struct efct_mcdi_copy_buffer *copybuf,
+					struct list_head *cleanup_list)
+{
+	/* when immediate_only=false this can only return success */
+	(void)efct_mcdi_cmd_start_or_queue_ext(mcdi, cmd, copybuf, false,
+					       cleanup_list);
+}
+
+/* try to advance other commands */
+static void efct_mcdi_start_or_queue(struct efct_mcdi_iface *mcdi,
+				     bool allow_retry,
+				    struct efct_mcdi_copy_buffer *copybuf,
+				    struct list_head *cleanup_list)
+{
+	struct efct_mcdi_cmd *cmd, *tmp;
+
+	list_for_each_entry_safe(cmd, tmp, &mcdi->cmd_list, list)
+		if (cmd->state == MCDI_STATE_QUEUED ||
+		    (cmd->state == MCDI_STATE_RETRY && allow_retry))
+			efct_mcdi_cmd_start_or_queue(mcdi, cmd, copybuf,
+						     cleanup_list);
+}
+
+static void efct_mcdi_poll_start(struct efct_mcdi_iface *mcdi,
+				 struct efct_mcdi_cmd *cmd,
+				struct efct_mcdi_copy_buffer *copybuf,
+				struct list_head *cleanup_list)
+{
+	/* Poll for completion. Poll quickly (once a us) for the 1st jiffy,
+	 * because generally mcdi responses are fast. After that, back off
+	 * and poll once a jiffy (approximately)
+	 */
+	int spins = copybuf ? USER_TICK_USEC : 0;
+
+	while (spins) {
+		if (efct_mcdi_poll_once(mcdi, cmd)) {
+			efct_mcdi_complete_cmd(mcdi, cmd, copybuf, cleanup_list);
+			return;
+		}
+
+		--spins;
+		udelay(1);
+	}
+
+	/* didn't get a response in the first jiffy;
+	 * schedule poll after another jiffy
+	 */
+	kref_get(&cmd->ref);
+	queue_delayed_work(mcdi->workqueue, &cmd->work, 1);
+}
+
+static bool efct_mcdi_poll_once(struct efct_mcdi_iface *mcdi,
+				struct efct_mcdi_cmd *cmd)
+{
+	struct efct_nic *efct = mcdi->efct;
+
+	/* complete or error, either way return true */
+	return efct_nic_hw_unavailable(efct) ||
+	       efct->type->mcdi_poll_response(efct, cmd->bufid);
+}
+
+static unsigned long efct_mcdi_poll_interval(struct efct_mcdi_iface *mcdi,
+					     struct efct_mcdi_cmd *cmd)
+{
+	if (time_before(jiffies, cmd->started + msecs_to_jiffies(10)))
+		return msecs_to_jiffies(1);
+	else if (time_before(jiffies, cmd->started + msecs_to_jiffies(100)))
+		return msecs_to_jiffies(10);
+	else if (time_before(jiffies, cmd->started + msecs_to_jiffies(1000)))
+		return msecs_to_jiffies(100);
+	else
+		return msecs_to_jiffies(1000);
+}
+
+static bool efct_mcdi_check_timeout(struct efct_mcdi_iface *mcdi,
+				    struct efct_mcdi_cmd *cmd)
+{
+	return time_after(jiffies, cmd->started +
+				   efct_mcdi_rpc_timeout(mcdi->efct, cmd->cmd));
+}
+
+static void efct_mcdi_proxy_timeout_cmd(struct efct_mcdi_iface *mcdi,
+					struct efct_mcdi_cmd *cmd,
+				       struct list_head *cleanup_list)
+{
+	struct efct_nic *efct = mcdi->efct;
+
+	netif_err(efct, drv, efct->net_dev, "MCDI proxy timeout (handle %#x)\n",
+		  cmd->proxy_handle);
+
+	cmd->rc = -ETIMEDOUT;
+	efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+
+	efct_mcdi_mode_fail(efct, cleanup_list);
+	efct_schedule_reset(efct, RESET_TYPE_MCDI_TIMEOUT);
+}
+
+static void efct_mcdi_cmd_work(struct work_struct *context)
+{
+	struct efct_mcdi_cmd *cmd =
+		container_of(context, struct efct_mcdi_cmd, work.work);
+	struct efct_mcdi_iface *mcdi = cmd->mcdi;
+	struct efct_mcdi_copy_buffer *copybuf =
+		kmalloc(sizeof(struct efct_mcdi_copy_buffer), GFP_KERNEL);
+	LIST_HEAD(cleanup_list);
+
+	spin_lock_bh(&mcdi->iface_lock);
+
+	if (cmd->state == MCDI_STATE_FINISHED) {
+		/* The command is done and this is a race between the
+		 * completion in another thread and the work item running.
+		 * All processing been done, so just release it.
+		 */
+		spin_unlock_bh(&mcdi->iface_lock);
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+		kfree(copybuf);
+		return;
+	}
+
+	if (cmd->state == MCDI_STATE_QUEUED || cmd->state == MCDI_STATE_RETRY)
+		netif_err(mcdi->efct, drv, mcdi->efct->net_dev,
+			  "MC state %d is wrong. It can be a bug in driver\n", cmd->state);
+
+	/* if state PROXY, then proxy time out */
+	if (cmd->state == MCDI_STATE_PROXY) {
+		efct_mcdi_proxy_timeout_cmd(mcdi, cmd, &cleanup_list);
+	/* else running, check for completion */
+	} else if (efct_mcdi_poll_once(mcdi, cmd)) {
+		if (!cmd->polled) {
+			/* check whether the event is pending on EVQ0 */
+			if (efct_nic_mcdi_ev_pending(mcdi->efct, 0))
+				netif_err(mcdi->efct, drv, mcdi->efct->net_dev,
+					  "MC command 0x%x inlen %zu mode %d completed without an interrupt after %u ms\n",
+					  cmd->cmd, cmd->inlen,
+					  cmd->polled ? MCDI_MODE_POLL : MCDI_MODE_EVENTS,
+					  jiffies_to_msecs(jiffies - cmd->started));
+			else
+				netif_err(mcdi->efct, drv, mcdi->efct->net_dev,
+					  "MC command 0x%x inlen %zu mode %d completed without an event after %u ms\n",
+					  cmd->cmd, cmd->inlen,
+					  cmd->polled ? MCDI_MODE_POLL : MCDI_MODE_EVENTS,
+					  jiffies_to_msecs(jiffies - cmd->started));
+		}
+		efct_mcdi_complete_cmd(mcdi, cmd, copybuf, &cleanup_list);
+	/* then check for timeout. If evented, it must have timed out */
+	} else if (!cmd->polled || efct_mcdi_check_timeout(mcdi, cmd)) {
+		if (efct_mcdi_wait_for_reboot(mcdi->efct)) {
+			netif_err(mcdi->efct, drv, mcdi->efct->net_dev,
+				  "MC command 0x%x inlen %zu state %d mode %d timed out after %u ms during mc reboot\n",
+				cmd->cmd, cmd->inlen, cmd->state,
+				cmd->polled ? MCDI_MODE_POLL : MCDI_MODE_EVENTS,
+				jiffies_to_msecs(jiffies - cmd->started));
+			efct_mcdi_complete_cmd(mcdi, cmd, copybuf, &cleanup_list);
+		} else {
+			efct_mcdi_timeout_cmd(mcdi, cmd, &cleanup_list);
+		}
+
+	/* else reschedule for another poll */
+	} else {
+		kref_get(&cmd->ref);
+		queue_delayed_work(mcdi->workqueue, &cmd->work,
+				   efct_mcdi_poll_interval(mcdi, cmd));
+	}
+
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	kref_put(&cmd->ref, efct_mcdi_cmd_release);
+
+	efct_mcdi_process_cleanup_list(mcdi->efct, &cleanup_list);
+
+	kfree(copybuf);
+}
+
+static void efct_mcdi_reset_during_cmd(struct efct_mcdi_iface *mcdi,
+				       struct efct_mcdi_cmd *cmd)
+{
+	bool reset_running = efct_mcdi_reset_cmd_running(mcdi);
+	struct efct_nic *efct = mcdi->efct;
+	int rc;
+
+	if (!reset_running)
+		netif_err(efct, hw, efct->net_dev,
+			  "Command %#x inlen %zu cancelled by MC reboot\n",
+			  cmd->cmd, cmd->inlen);
+	rc = efct_mcdi_wait_for_reboot(efct);
+	/* consume the reset notification if we haven't already */
+	if (!cmd->reboot_seen && rc)
+		if (!reset_running)
+			efct_schedule_reset(efct, RESET_TYPE_MC_FAILURE);
+}
+
+/* Returns true if the MCDI module is finished with the command.
+ * (examples of false would be if the command was proxied, or it was
+ * rejected by the MC due to lack of resources and requeued).
+ */
+static bool efct_mcdi_complete_cmd(struct efct_mcdi_iface *mcdi,
+				   struct efct_mcdi_cmd *cmd,
+				  struct efct_mcdi_copy_buffer *copybuf,
+				  struct list_head *cleanup_list)
+{
+	struct efct_nic *efct = mcdi->efct;
+	size_t resp_hdr_len, resp_data_len;
+	union efct_dword *outbuf;
+	bool completed = false;
+	u8 bufid = cmd->bufid;
+	union efct_dword hdr;
+	u32 respcmd, error;
+	int rc;
+
+	outbuf = copybuf ? copybuf->buffer : NULL;
+	/* ensure the command can't go away before this function returns */
+	kref_get(&cmd->ref);
+
+	efct->type->mcdi_read_response(efct, bufid, &hdr, 0, 4);
+	respcmd = EFCT_DWORD_FIELD(hdr, MCDI_HEADER_CODE);
+	error = EFCT_DWORD_FIELD(hdr, MCDI_HEADER_ERROR);
+
+	if (respcmd != MC_CMD_V2_EXTN) {
+		resp_hdr_len = 4;
+		resp_data_len = EFCT_DWORD_FIELD(hdr, MCDI_HEADER_DATALEN);
+	} else {
+		efct->type->mcdi_read_response(efct, bufid, &hdr, 4, 4);
+		respcmd = EFCT_DWORD_FIELD(hdr, MC_CMD_V2_EXTN_IN_EXTENDED_CMD);
+		resp_hdr_len = 8;
+		resp_data_len =
+			EFCT_DWORD_FIELD(hdr, MC_CMD_V2_EXTN_IN_ACTUAL_LEN);
+	}
+
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	if (mcdi->logging_enabled && !WARN_ON_ONCE(!mcdi->logging_buffer)) {
+		size_t len;
+		int bytes = 0;
+		int i;
+		u32 dcount = 0;
+		char *log = mcdi->logging_buffer;
+
+		WARN_ON_ONCE(resp_hdr_len % 4);
+		/* MCDI_DECLARE_BUF ensures that underlying buffer is padded
+		 * to dword size, and the MCDI buffer is always dword size
+		 */
+		len = resp_hdr_len / 4 + DIV_ROUND_UP(resp_data_len, 4);
+
+		for (i = 0; i < len; i++) {
+			if ((bytes + 75) > LOG_LINE_MAX) {
+				netif_info(efct, hw, efct->net_dev,
+					   "MCDI RPC RESP:%s \\\n", log);
+				dcount = 0;
+				bytes = 0;
+			}
+			efct->type->mcdi_read_response(efct, bufid,
+						      &hdr, (i * 4), 4);
+			bytes += snprintf(log + bytes, LOG_LINE_MAX - bytes,
+					" %08x", le32_to_cpu(hdr.word32));
+			dcount++;
+		}
+
+		netif_info(efct, hw, efct->net_dev, "MCDI RPC RESP:%s\n", log);
+	}
+#endif
+
+	if (error && resp_data_len == 0) {
+		/* MC rebooted during command */
+		efct_mcdi_reset_during_cmd(mcdi, cmd);
+		rc = -EIO;
+	} else if (!outbuf) {
+		rc = -ENOMEM;
+	} else {
+		if (WARN_ON_ONCE(error && resp_data_len < 4))
+			resp_data_len = 4;
+
+		efct->type->mcdi_read_response(efct, bufid, outbuf,
+					      resp_hdr_len, resp_data_len);
+
+		if (error) {
+			rc = EFCT_DWORD_FIELD(outbuf[0], EFCT_DWORD_0);
+			if (!cmd->quiet) {
+				int err_arg = 0;
+
+				if (resp_data_len >= MC_CMD_ERR_ARG_OFST + 4) {
+					efct->type->mcdi_read_response(efct, bufid, &hdr,
+								      resp_hdr_len +
+								      MC_CMD_ERR_ARG_OFST, 4);
+					err_arg = EFCT_DWORD_VAL(hdr);
+				}
+				_efct_mcdi_display_error(efct, cmd->cmd,
+							 cmd->inlen, rc, err_arg,
+							efct_mcdi_errno(efct, rc));
+			}
+			rc = efct_mcdi_errno(efct, rc);
+		} else {
+			rc = 0;
+		}
+	}
+
+	if (rc == MC_CMD_ERR_PROXY_PENDING) {
+		if (mcdi->db_held_by != cmd || cmd->proxy_handle ||
+		    resp_data_len < MC_CMD_ERR_PROXY_PENDING_HANDLE_OFST + 4) {
+			/* The MC shouldn't return the doorbell early and then
+			 * proxy. It also shouldn't return PROXY_PENDING with
+			 * no handle or proxy a command that's already been
+			 * proxied. Schedule an flr to reset the state.
+			 */
+			if (mcdi->db_held_by != cmd)
+				netif_err(efct, drv, efct->net_dev,
+					  "MCDI proxy pending with early db return\n");
+			if (cmd->proxy_handle)
+				netif_err(efct, drv, efct->net_dev,
+					  "MCDI proxy pending twice\n");
+			if (resp_data_len <
+			    MC_CMD_ERR_PROXY_PENDING_HANDLE_OFST + 4)
+				netif_err(efct, drv, efct->net_dev,
+					  "MCDI proxy pending with no handle\n");
+			cmd->rc = -EIO;
+			efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+			completed = true;
+
+			efct_mcdi_mode_fail(efct, cleanup_list);
+			efct_schedule_reset(efct, RESET_TYPE_MCDI_TIMEOUT);
+		} else {
+			/* keep the doorbell. no commands
+			 * can be issued until the proxy response.
+			 */
+			cmd->state = MCDI_STATE_PROXY;
+			efct->type->mcdi_read_response(efct, bufid, &hdr,
+				resp_hdr_len +
+					MC_CMD_ERR_PROXY_PENDING_HANDLE_OFST,
+				4);
+			cmd->proxy_handle = EFCT_DWORD_FIELD(hdr, EFCT_DWORD_0);
+			kref_get(&cmd->ref);
+			queue_delayed_work(mcdi->workqueue, &cmd->work,
+					   MCDI_PROXY_TIMEOUT);
+		}
+	} else {
+		/* free doorbell */
+		if (mcdi->db_held_by == cmd)
+			mcdi->db_held_by = NULL;
+
+		if (efct_cmd_cancelled(cmd)) {
+			list_del(&cmd->list);
+			kref_put(&cmd->ref, efct_mcdi_cmd_release);
+			completed = true;
+		} else if (rc == MC_CMD_ERR_QUEUE_FULL) {
+			cmd->state = MCDI_STATE_RETRY;
+		} else {
+			cmd->rc = rc;
+			cmd->outbuf = outbuf;
+			cmd->outlen = outbuf ? resp_data_len : 0;
+			efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+			completed = true;
+		}
+	}
+
+	/* free sequence number and buffer */
+	mcdi->seq_held_by[cmd->seq] = NULL;
+	efct->type->mcdi_put_buf(efct, bufid);
+
+	efct_mcdi_start_or_queue(mcdi, rc != MC_CMD_ERR_QUEUE_FULL,
+				 NULL, cleanup_list);
+
+	/* wake up anyone waiting for flush */
+	wake_up(&mcdi->cmd_complete_wq);
+
+	kref_put(&cmd->ref, efct_mcdi_cmd_release);
+
+	return completed;
+}
+
+static void efct_mcdi_timeout_cmd(struct efct_mcdi_iface *mcdi,
+				  struct efct_mcdi_cmd *cmd,
+				 struct list_head *cleanup_list)
+{
+	struct efct_nic *efct = mcdi->efct;
+
+	netif_err(efct, drv, efct->net_dev,
+		  "MC command 0x%x inlen %zu state %d mode %d timed out after %u ms\n",
+		  cmd->cmd, cmd->inlen, cmd->state,
+		  cmd->polled ? MCDI_MODE_POLL : MCDI_MODE_EVENTS,
+		  jiffies_to_msecs(jiffies - cmd->started));
+
+	efct->type->mcdi_put_buf(efct, cmd->bufid);
+
+	cmd->rc = -ETIMEDOUT;
+	efct_mcdi_remove_cmd(mcdi, cmd, cleanup_list);
+
+	efct_mcdi_mode_fail(efct, cleanup_list);
+	efct_schedule_reset(efct, RESET_TYPE_MCDI_TIMEOUT);
+}
+
+/**
+ * efct_mcdi_rpc - Issue an MCDI command and wait for completion
+ * @efct: NIC through which to issue the command
+ * @cmd: Command type number
+ * @inbuf: Command parameters
+ * @inlen: Length of command parameters, in bytes.  Must be a multiple
+ *	of 4 and no greater than %MCDI_CTL_SDU_LEN_MAX_V1.
+ * @outbuf: Response buffer.  May be %NULL if @outlen is 0.
+ * @outlen: Length of response buffer, in bytes.  If the actual
+ *	response is longer than @outlen & ~3, it will be truncated
+ *	to that length.
+ * @outlen_actual: Pointer through which to return the actual response
+ *	length.  May be %NULL if this is not needed.
+ *
+ * This function may sleep and therefore must be called in process
+ * context.
+ *
+ * Return: A negative error code, or zero if successful.  The error
+ *	code may come from the MCDI response or may indicate a failure
+ *	to communicate with the MC.  In the former case, the response
+ *	will still be copied to @outbuf and *@outlen_actual will be
+ *	set accordingly.  In the latter case, *@outlen_actual will be
+ *	set to zero.
+ */
+int efct_mcdi_rpc(struct efct_nic *efct, u32 cmd,
+		  const union efct_dword *inbuf, size_t inlen,
+		 union efct_dword *outbuf, size_t outlen,
+		 size_t *outlen_actual)
+{
+	return efct_mcdi_rpc_sync(efct, cmd, inbuf, inlen, outbuf, outlen,
+				 outlen_actual, false);
+}
+
+/* Normally, on receiving an error code in the MCDI response,
+ * efct_mcdi_rpc will log an error message containing (among other
+ * things) the raw error code, by means of efct_mcdi_display_error.
+ * This _quiet version suppresses that; if the caller wishes to log
+ * the error conditionally on the return code, it should call this
+ * function and is then responsible for calling efct_mcdi_display_error
+ * as needed.
+ */
+int efct_mcdi_rpc_quiet(struct efct_nic *efct, u32 cmd,
+			const union efct_dword *inbuf, size_t inlen,
+		       union efct_dword *outbuf, size_t outlen,
+		       size_t *outlen_actual)
+{
+	return efct_mcdi_rpc_sync(efct, cmd, inbuf, inlen, outbuf, outlen,
+				 outlen_actual, true);
+}
+
+/**
+ * efct_mcdi_rpc_async - Schedule an MCDI command to run asynchronously
+ * @efct: NIC through which to issue the command
+ * @cmd: Command type number
+ * @inbuf: Command parameters
+ * @inlen: Length of command parameters, in bytes
+ * @complete: Function to be called on completion or cancellation.
+ * @cookie: Arbitrary value to be passed to @complete.
+ *
+ * This function does not sleep and therefore may be called in atomic
+ * context.  It will fail if event queues are disabled or if MCDI
+ * event completions have been disabled due to an error.
+ *
+ * If it succeeds, the @complete function will be called exactly once
+ * in atomic context, when one of the following occurs:
+ * (a) the completion event is received (in NAPI context)
+ * (b) event queues are disabled (in the process that disables them)
+ * (c) the request times-out (in timer context)
+ */
+int
+efct_mcdi_rpc_async(struct efct_nic *efct, u32 cmd,
+		    const union efct_dword *inbuf, size_t inlen,
+		   efct_mcdi_async_completer *complete, unsigned long cookie)
+{
+	return efct_mcdi_rpc_async_ext(efct, cmd, inbuf, inlen, NULL,
+				      complete, cookie, false, false, NULL);
+}
+
+static void _efct_mcdi_display_error(struct efct_nic *efct, u32 cmd,
+				     size_t inlen, int raw, int arg, int rc)
+{
+	if (efct->net_dev)
+		netif_cond_dbg(efct, hw, efct->net_dev,
+			       rc == -EPERM || efct_nic_hw_unavailable(efct), err,
+			       "MC command 0x%x inlen %d failed rc=%d (raw=%d) arg=%d\n",
+			       cmd, (int)inlen, rc, raw, arg);
+	else
+		pci_err(efct->efct_dev->pci_dev,
+			"MC command 0x%x inlen %d failed rc=%d (raw=%d) arg=%d\n",
+			cmd, (int)inlen, rc, raw, arg);
+}
+
+void efct_mcdi_display_error(struct efct_nic *efct, u32 cmd,
+			     size_t inlen, union efct_dword *outbuf,
+			    size_t outlen, int rc)
+{
+	int code = 0, arg = 0;
+
+	if (outlen >= MC_CMD_ERR_CODE_OFST + 4)
+		code = MCDI_DWORD(outbuf, ERR_CODE);
+	if (outlen >= MC_CMD_ERR_ARG_OFST + 4)
+		arg = MCDI_DWORD(outbuf, ERR_ARG);
+
+	_efct_mcdi_display_error(efct, cmd, inlen, code, arg, rc);
+}
+
+/* Switch to polled MCDI completions. */
+static void _efct_mcdi_mode_poll(struct efct_mcdi_iface *mcdi)
+{
+	/* If already in polling mode, nothing to do.
+	 * If in fail-fast state, don't switch to polled completion, FLR
+	 * recovery will do that later.
+	 */
+	if (mcdi->mode == MCDI_MODE_EVENTS) {
+		struct efct_mcdi_cmd *cmd;
+
+		mcdi->mode = MCDI_MODE_POLL;
+
+		list_for_each_entry(cmd, &mcdi->cmd_list, list)
+			if (efct_cmd_running(cmd) && !cmd->polled) {
+				netif_dbg(mcdi->efct, drv, mcdi->efct->net_dev,
+					  "converting command %#x inlen %zu to polled mode\n",
+					  cmd->cmd, cmd->inlen);
+				cmd->polled = true;
+				if (cancel_delayed_work(&cmd->work))
+					queue_delayed_work(mcdi->workqueue,
+							   &cmd->work, 0);
+			}
+	}
+}
+
+/* Set MCDI mode to fail to prevent any new commands, then cancel any
+ * outstanding commands.
+ * Caller must hold the mcdi iface_lock.
+ */
+static void efct_mcdi_mode_fail(struct efct_nic *efct, struct list_head *cleanup_list)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	struct efct_mcdi_cmd *cmd;
+
+	if (!mcdi)
+		return;
+
+	mcdi->mode = MCDI_MODE_FAIL;
+
+	while (!list_empty(&mcdi->cmd_list)) {
+		cmd = list_first_entry(&mcdi->cmd_list, struct efct_mcdi_cmd,
+				       list);
+		_efct_mcdi_cancel_cmd(mcdi, efct_mcdi_cmd_handle(cmd), cleanup_list);
+	}
+}
+
+static void efct_mcdi_ev_death(struct efct_nic *efct, bool bist)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+
+	if (bist) {
+		efct->mc_bist_for_other_fn = true;
+		efct->type->mcdi_record_bist_event(efct);
+	}
+	spin_lock(&mcdi->iface_lock);
+	efct_mcdi_reboot_detected(efct);
+	/* if this is the result of a MC_CMD_REBOOT then don't schedule reset */
+	if (bist || !efct_mcdi_reset_cmd_running(mcdi))
+		efct_schedule_reset(efct, bist ? RESET_TYPE_MC_BIST :
+					       RESET_TYPE_MC_FAILURE);
+	spin_unlock(&mcdi->iface_lock);
+}
+
+bool efct_mcdi_process_event(struct efct_nic *efct,
+			     union efct_qword *event)
+{
+	int code = EFCT_QWORD_FIELD(*event, MCDI_EVENT_CODE);
+	u32 data = EFCT_QWORD_FIELD(*event, MCDI_EVENT_DATA);
+
+	switch (code) {
+	case MCDI_EVENT_CODE_BADSSERT:
+		netif_err(efct, hw, efct->net_dev,
+			  "MC watchdog or assertion failure at 0x%x\n", data);
+		efct_mcdi_ev_death(efct, false);
+		return true;
+
+	case MCDI_EVENT_CODE_PMNOTICE:
+		netif_info(efct, wol, efct->net_dev, "MCDI PM event.\n");
+		return true;
+
+	case MCDI_EVENT_CODE_CMDDONE:
+		efct_mcdi_ev_cpl(efct,
+				 MCDI_EVENT_FIELD(*event, CMDDONE_SEQ),
+				MCDI_EVENT_FIELD(*event, CMDDONE_DATALEN),
+				MCDI_EVENT_FIELD(*event, CMDDONE_ERRNO));
+		return true;
+	case MCDI_EVENT_CODE_PROXY_RESPONSE:
+		efct_mcdi_ev_proxy_response(efct,
+					    MCDI_EVENT_FIELD(*event, PROXY_RESPONSE_HANDLE),
+					   MCDI_EVENT_FIELD(*event, PROXY_RESPONSE_RC));
+		return true;
+	case MCDI_EVENT_CODE_SCHEDERR:
+		netif_dbg(efct, hw, efct->net_dev,
+			  "MC Scheduler alert (0x%x)\n", data);
+		return true;
+	case MCDI_EVENT_CODE_REBOOT:
+	case MCDI_EVENT_CODE_MC_REBOOT: /* XXX should handle this differently? */
+		efct_mcdi_ev_death(efct, false);
+		return true;
+	case MCDI_EVENT_CODE_MC_BIST:
+		netif_info(efct, hw, efct->net_dev, "MC entered BIST mode\n");
+		efct_mcdi_ev_death(efct, true);
+		return true;
+	}
+
+	return false;
+}
+
+/**************************************************************************
+ *
+ * Specific request functions
+ *
+ **************************************************************************
+ */
+
+static int efct_mcdi_drv_attach_attempt(struct efct_nic *efct,
+					u32 fw_variant, u32 new_state,
+				       u32 *flags, bool reattach)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_DRV_ATTACH_IN_V2_LEN);
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_DRV_ATTACH_EXT_OUT_LEN);
+	size_t outlen = 0;
+	int state, rc;
+
+	MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_V2_NEW_STATE, new_state);
+	MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_V2_UPDATE, 1);
+	MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_V2_FIRMWARE_ID, fw_variant);
+
+	strscpy(MCDI_PTR(inbuf, DRV_ATTACH_IN_V2_DRIVER_VERSION),
+		EFCT_DRIVER_VERSION, MC_CMD_DRV_ATTACH_IN_V2_DRIVER_VERSION_LEN);
+
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_DRV_ATTACH, inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf), &outlen);
+
+	if (!reattach && (rc || outlen < MC_CMD_DRV_ATTACH_OUT_LEN)) {
+		efct_mcdi_display_error(efct, MC_CMD_DRV_ATTACH, sizeof(inbuf),
+					outbuf, outlen, rc);
+		if (outlen < MC_CMD_DRV_ATTACH_OUT_LEN)
+			rc = -EIO;
+		return rc;
+	}
+
+	state = MCDI_DWORD(outbuf, DRV_ATTACH_OUT_OLD_STATE);
+	if (state != new_state)
+		netif_warn(efct, probe, efct->net_dev,
+			   "State set by firmware doesn't match the expected state.\n");
+
+	if (flags && outlen >= MC_CMD_DRV_ATTACH_EXT_OUT_LEN)
+		*flags = MCDI_DWORD(outbuf, DRV_ATTACH_EXT_OUT_FUNC_FLAGS);
+
+	return rc;
+}
+
+int efct_mcdi_drv_detach(struct efct_nic *efct)
+{
+	return efct_mcdi_drv_attach_attempt(efct, 0, 0, NULL, false);
+}
+
+int efct_mcdi_drv_attach(struct efct_nic *efct, u32 fw_variant, u32 *out_flags,
+			 bool reattach)
+{
+	u32 flags;
+	u32 in;
+	int rc;
+
+	in = (1 << MC_CMD_DRV_ATTACH_IN_V2_ATTACH_LBN) |
+	     (1 << MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_LBN);
+
+	rc = efct_mcdi_drv_attach_attempt(efct, fw_variant, in, &flags, reattach);
+	if (rc == 0) {
+		pci_dbg(efct->efct_dev->pci_dev,
+			"%s attached with flags %#x\n", __func__, flags);
+		if (out_flags)
+			*out_flags = flags;
+	}
+
+	return rc;
+}
+
+int efct_mcdi_log_ctrl(struct efct_nic *efct, bool evq, bool uart, u32 dest_evq)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_LOG_CTRL_IN_LEN);
+	u32 dest = 0;
+	int rc;
+
+	if (uart)
+		dest |= MC_CMD_LOG_CTRL_IN_LOG_DEST_UART;
+	if (evq)
+		dest |= MC_CMD_LOG_CTRL_IN_LOG_DEST_EVQ;
+
+	MCDI_SET_DWORD(inbuf, LOG_CTRL_IN_LOG_DEST, dest);
+	MCDI_SET_DWORD(inbuf, LOG_CTRL_IN_LOG_DEST_EVQ, dest_evq);
+
+	BUILD_BUG_ON(MC_CMD_LOG_CTRL_OUT_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_LOG_CTRL, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+	return rc;
+}
+
+/* Returns 1 if an assertion was read, 0 if no assertion had fired,
+ * negative on error.
+ */
+static int efct_mcdi_read_assertion(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_ASSERTS_OUT_V3_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_ASSERTS_IN_LEN);
+	const char *reason;
+	size_t outlen = 0;
+	u32 flags, index;
+	int retry;
+	int rc;
+
+	/* Attempt to read any stored assertion state before we reboot
+	 * the mcfw out of the assertion handler. Retry twice, once
+	 * because a boot-time assertion might cause this command to fail
+	 * with EINTR. And once again because GET_ASSERTS can race with
+	 * MC_CMD_REBOOT running on the other port.
+	 */
+	retry = 2;
+	do {
+		MCDI_SET_DWORD(inbuf, GET_ASSERTS_IN_CLEAR, 1);
+		rc = efct_mcdi_rpc_quiet(efct, MC_CMD_GET_ASSERTS,
+					 inbuf, MC_CMD_GET_ASSERTS_IN_LEN,
+					outbuf, sizeof(outbuf), &outlen);
+		if (rc == -EPERM)
+			return 0;
+	} while ((rc == -EINTR || rc == -EIO) && retry-- > 0);
+
+	if (rc) {
+		efct_mcdi_display_error(efct, MC_CMD_GET_ASSERTS,
+					MC_CMD_GET_ASSERTS_IN_LEN, outbuf,
+				       outlen, rc);
+		return rc;
+	}
+	if (outlen < MC_CMD_GET_ASSERTS_OUT_V3_LEN)
+		return -EIO;
+
+	/* Print out any recorded assertion state */
+	flags = MCDI_DWORD(outbuf, GET_ASSERTS_OUT_V3_GLOBAL_FLAGS);
+	if (flags == MC_CMD_GET_ASSERTS_FLAGS_NO_FAILS)
+		return 0;
+
+	reason = (flags == MC_CMD_GET_ASSERTS_FLAGS_SYS_FAIL)
+		? "system-level assertion"
+		: (flags == MC_CMD_GET_ASSERTS_FLAGS_THR_FAIL)
+		? "thread-level assertion"
+		: (flags == MC_CMD_GET_ASSERTS_FLAGS_WDOG_FIRED)
+		? "watchdog reset"
+		: "unknown assertion";
+	netif_err(efct, hw, efct->net_dev,
+		  "MCPU %s at PC = 0x%.8x in thread 0x%.8x\n", reason,
+		  MCDI_DWORD(outbuf, GET_ASSERTS_OUT_V3_SAVED_PC_OFFS),
+		  MCDI_DWORD(outbuf, GET_ASSERTS_OUT_V3_THREAD_OFFS));
+
+	/* Print out the registers */
+	for (index = 0;
+	     index < MC_CMD_GET_ASSERTS_OUT_GP_REGS_OFFS_NUM;
+	     index++)
+		netif_err(efct, hw, efct->net_dev, "R%.2d (?): 0x%.8x\n",
+			  1 + index,
+			  MCDI_ARRAY_DWORD(outbuf, GET_ASSERTS_OUT_V3_GP_REGS_OFFS,
+					   index));
+
+	return 1;
+}
+
+static int efct_mcdi_exit_assertion(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_REBOOT_IN_LEN);
+	int rc;
+
+	/* If the MC is running debug firmware, it might now be
+	 * waiting for a debugger to attach, but we just want it to
+	 * reboot.  We set a flag that makes the command a no-op if it
+	 * has already done so.
+	 * The MCDI will thus return either 0 or -EIO.
+	 */
+	BUILD_BUG_ON(MC_CMD_REBOOT_OUT_LEN != 0);
+	MCDI_SET_DWORD(inbuf, REBOOT_IN_FLAGS,
+		       MC_CMD_REBOOT_FLAGS_AFTER_ASSERTION);
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_REBOOT, inbuf, MC_CMD_REBOOT_IN_LEN,
+				 NULL, 0, NULL);
+	if (rc == -EIO)
+		rc = 0;
+	if (rc)
+		efct_mcdi_display_error(efct, MC_CMD_REBOOT, MC_CMD_REBOOT_IN_LEN,
+					NULL, 0, rc);
+	return rc;
+}
+
+int efct_mcdi_handle_assertion(struct efct_nic *efct)
+{
+	int rc;
+
+	rc = efct_mcdi_read_assertion(efct);
+	if (rc <= 0)
+		return rc;
+
+	return efct_mcdi_exit_assertion(efct);
+}
+
+static int efct_mcdi_reset_func(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_ENTITY_RESET_IN_LEN);
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_ENTITY_RESET_OUT_LEN != 0);
+	MCDI_POPULATE_DWORD_1(inbuf, ENTITY_RESET_IN_FLAG,
+			      ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET, 1);
+	rc = efct_mcdi_rpc(efct, MC_CMD_ENTITY_RESET, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+	return rc;
+}
+
+static int efct_mcdi_reset_mc(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_REBOOT_IN_LEN);
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_REBOOT_OUT_LEN != 0);
+	MCDI_SET_DWORD(inbuf, REBOOT_IN_FLAGS, 0);
+	rc = efct_mcdi_rpc(efct, MC_CMD_REBOOT, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+	/* White is black, and up is down */
+	if (rc == -EIO)
+		return 0;
+	if (rc == 0)
+		rc = -EIO;
+	return rc;
+}
+
+int efct_flr(struct efct_nic *efct)
+{
+	struct efct_mcdi_iface *mcdi = efct_mcdi(efct);
+	LIST_HEAD(cleanup_list);
+	u16 seq;
+	int rc;
+
+	netif_dbg(efct, drv, efct->net_dev, "Beginning FLR\n");
+
+	rc = pci_reset_function(efct->efct_dev->pci_dev);
+	if (rc)
+		return rc;
+
+	if (!mcdi)
+		return 0;
+
+	spin_lock_bh(&mcdi->iface_lock);
+	while (!list_empty(&mcdi->cmd_list)) {
+		struct efct_mcdi_cmd *cmd =
+			list_first_entry(&mcdi->cmd_list,
+					 struct efct_mcdi_cmd, list);
+
+		netif_dbg(efct, drv, efct->net_dev,
+			  "aborting command %#x inlen %zu due to FLR\n",
+			  cmd->cmd, cmd->inlen);
+
+		kref_get(&cmd->ref);
+
+		cmd->rc = -EIO;
+
+		if (efct_cmd_running(cmd))
+			efct->type->mcdi_put_buf(efct, cmd->bufid);
+
+		efct_mcdi_remove_cmd(mcdi, cmd, &cleanup_list);
+
+		if (cancel_delayed_work(&cmd->work))
+			kref_put(&cmd->ref, efct_mcdi_cmd_release);
+
+		kref_put(&cmd->ref, efct_mcdi_cmd_release);
+	}
+
+	mcdi->db_held_by = NULL;
+	for (seq = 0; seq < ARRAY_SIZE(mcdi->seq_held_by); ++seq)
+		mcdi->seq_held_by[seq] = NULL;
+	mcdi->mode = MCDI_MODE_POLL;
+
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	netif_dbg(efct, drv, efct->net_dev, "Cleaning up for FLR\n");
+
+	efct_mcdi_process_cleanup_list(efct, &cleanup_list);
+
+	netif_dbg(efct, drv, efct->net_dev, "FLR complete\n");
+
+	return 0;
+}
+
+int efct_mcdi_reset(struct efct_nic *efct, enum reset_type method)
+{
+	int rc;
+
+	/* Recover from a failed assertion pre-reset */
+	rc = efct_mcdi_handle_assertion(efct);
+	if (rc) {
+		netif_err(efct, probe, efct->net_dev,
+			  "Unable to handle assertion\n");
+		return rc;
+	}
+
+	if (method == RESET_TYPE_DATAPATH || method == RESET_TYPE_MC_BIST)
+		rc = 0;
+	else if (method == RESET_TYPE_WORLD)
+		rc = efct_mcdi_reset_mc(efct);
+	else
+		rc = efct_mcdi_reset_func(efct);
+
+	return rc;
+}
diff --git a/drivers/net/ethernet/amd/efct/mcdi.h b/drivers/net/ethernet/amd/efct/mcdi.h
new file mode 100644
index 000000000000..7d32bb6538ca
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi.h
@@ -0,0 +1,373 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_MCDI_H
+#define EFCT_MCDI_H
+
+#include "efct_driver.h"
+#include <linux/hwmon.h>
+#include <linux/rhashtable.h>
+#include "mcdi_pcol.h"
+/**
+ * enum efct_mcdi_mode - MCDI transaction mode
+ * @MCDI_MODE_POLL: poll for MCDI completion, until timeout
+ * @MCDI_MODE_EVENTS: wait for an mcdi_event.  On timeout, poll once
+ * @MCDI_MODE_FAIL: we think MCDI is dead, so fail-fast all calls
+ */
+enum efct_mcdi_mode {
+	MCDI_MODE_POLL,
+	MCDI_MODE_EVENTS,
+	MCDI_MODE_FAIL,
+};
+
+/* On older firmwares there is only a single thread on the MC, so even
+ * the shortest operation can be blocked for some time by an operation
+ * requested by a different function.
+ * See bug61269 for further discussion.
+ *
+ * On newer firmwares that support multithreaded MCDI commands we extend
+ * the timeout for commands we know can run longer.
+ */
+#define MCDI_RPC_TIMEOUT       (10 * HZ)
+#define MCDI_RPC_LONG_TIMEOUT  (60 * HZ)
+#define MCDI_RPC_POST_RST_TIME (10 * HZ)
+
+#define MC_OWNERSHIP_STATUS_DELAY_MS      1
+#define MC_OWNERSHIP_STATUS_DELAY_COUNT   1000
+
+/**
+ * enum efct_mcdi_cmd_state - State for an individual MCDI command
+ * @MCDI_STATE_QUEUED: Command not started
+ * @MCDI_STATE_RETRY: Command was submitted and MC rejected with no resources.
+ *                    Command will be retried once another command returns.
+ * @MCDI_STATE_PROXY: Command needs authenticating with proxy auth. Will be sent
+ *                    again after a PROXY_COMPLETE event.
+ * @MCDI_STATE_RUNNING: Command was accepted and is running.
+ * @MCDI_STATE_ABORT: Command has been completed or aborted. Used to resolve
+ *		      race between completion in another threads and the worker.
+ */
+
+#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
+
+enum efct_mcdi_cmd_state {
+	/* waiting to run */
+	MCDI_STATE_QUEUED,
+	/* we tried to run, but the MC said we have too many outstanding
+	 * commands
+	 */
+	MCDI_STATE_RETRY,
+	/* we sent the command and the MC is waiting for proxy auth */
+	MCDI_STATE_PROXY,
+	/* the command is running */
+	MCDI_STATE_RUNNING,
+	/* state was PROXY but the issuer cancelled the command */
+	MCDI_STATE_PROXY_CANCELLED,
+	/* the command is running but the issuer cancelled the command */
+	MCDI_STATE_RUNNING_CANCELLED,
+	/* processing of this command has completed.
+	 * used to break races between contexts.
+	 */
+	MCDI_STATE_FINISHED,
+};
+
+typedef void efct_mcdi_async_completer(struct efct_nic *efct,
+				      unsigned long cookie, int rc,
+				      union efct_dword *outbuf,
+				      size_t outlen_actual);
+
+/**
+ * struct efct_mcdi_cmd - An outstanding MCDI command
+ * @ref: Reference count. There will be one reference if the command is
+ *	in the mcdi_iface cmd_list, another if it's on a cleanup list,
+ *	and a third if it's queued in the work queue.
+ * @list: The data for this entry in mcdi->cmd_list
+ * @cleanup_list: The data for this entry in a cleanup list
+ * @work: The work item for this command, queued in mcdi->workqueue
+ * @mcdi: The mcdi_iface for this command
+ * @state: The state of this command
+ * @inlen: inbuf length
+ * @inbuf: Input buffer
+ * @quiet: Whether to silence errors
+ * @polled: Whether this command is polled or evented
+ * @reboot_seen: Whether a reboot has been seen during this command,
+ *	to prevent duplicates
+ * @seq: Sequence number
+ * @bufid: Buffer ID from the NIC implementation
+ * @started: Jiffies this command was started at
+ * @cookie: Context for completion function
+ * @completer: Completion function
+ * @cmd: Command number
+ * @proxy_handle: Handle if this command was proxied
+ */
+struct efct_mcdi_cmd {
+	struct kref ref;
+	struct list_head list;
+	struct list_head cleanup_list;
+	struct delayed_work work;
+	struct efct_mcdi_iface *mcdi;
+	enum efct_mcdi_cmd_state state;
+	size_t inlen;
+	const union efct_dword *inbuf;
+	bool quiet;
+	bool polled;
+	bool reboot_seen;
+	u8 seq;
+	u8 bufid;
+	unsigned long started;
+	unsigned long cookie;
+	efct_mcdi_async_completer *atomic_completer;
+	efct_mcdi_async_completer *completer;
+	u32 handle;
+	u32 cmd;
+	int rc;
+	size_t outlen;
+	union efct_dword *outbuf;
+	u32 proxy_handle;
+	/* followed by inbuf data if necessary */
+};
+
+/**
+ * struct efct_mcdi_iface - MCDI protocol context
+ * @efct: The associated NIC
+ * @iface_lock: Serialise access to this structure
+ * @cmd_list: List of outstanding and running commands
+ * @workqueue: Workqueue used for delayed processing
+ * @outstanding_cleanups: Count of cleanups
+ * @cmd_complete_wq: Waitqueue for command completion
+ * @db_held_by: Command the MC doorbell is in use by
+ * @seq_held_by: Command each sequence number is in use by
+ * @prev_seq: The last used sequence number
+ * @prev_handle: The last used command handle
+ * @mode: Poll for mcdi completion, or wait for an mcdi_event
+ * @new_epoch: Indicates start of day or start of MC reboot recovery
+ * @logging_buffer: Buffer that may be used to build MCDI tracing messages
+ * @logging_enabled: Whether to trace MCDI
+ */
+struct efct_mcdi_iface {
+	struct efct_nic *efct;
+	/* Serialise access*/
+	spinlock_t iface_lock;
+	u32 outstanding_cleanups;
+	struct list_head cmd_list;
+	struct workqueue_struct *workqueue;
+	wait_queue_head_t cmd_complete_wq;
+	struct efct_mcdi_cmd *db_held_by;
+	struct efct_mcdi_cmd *seq_held_by[16];
+	u32 prev_handle;
+	enum efct_mcdi_mode mode;
+	u8 prev_seq;
+	bool new_epoch;
+#ifdef CONFIG_EFCT_MCDI_LOGGING
+	bool logging_enabled;
+	char *logging_buffer;
+#endif
+};
+
+/**
+ * struct efct_mcdi_data - extra state for NICs that implement MCDI
+ * @iface: Interface/protocol state
+ * @hwmon: Hardware monitor state
+ * @fn_flags: Flags for this function, as returned by %MC_CMD_DRV_ATTACH.
+ */
+struct efct_mcdi_data {
+	struct efct_mcdi_iface iface;
+	u32 fn_flags;
+};
+
+static inline struct efct_mcdi_iface *efct_mcdi(struct efct_nic *efct)
+{
+	return efct->mcdi ? &efct->mcdi->iface : NULL;
+}
+
+int efct_mcdi_init(struct efct_nic *efct);
+void efct_mcdi_detach(struct efct_nic *efct);
+void efct_mcdi_fini(struct efct_nic *efct);
+
+int efct_mcdi_rpc(struct efct_nic *efct, u32 cmd,
+		  const union efct_dword *inbuf, size_t inlen,
+		  union efct_dword *outbuf, size_t outlen, size_t *outlen_actual);
+int efct_mcdi_rpc_quiet(struct efct_nic *efct, u32 cmd,
+			const union efct_dword *inbuf, size_t inlen,
+			union efct_dword *outbuf, size_t outlen,
+			size_t *outlen_actual);
+
+int efct_mcdi_rpc_async(struct efct_nic *efct, u32 cmd,
+			const union efct_dword *inbuf, size_t inlen,
+			efct_mcdi_async_completer *complete,
+			unsigned long cookie);
+int efct_mcdi_rpc_async_ext(struct efct_nic *efct, u32 cmd,
+			    const union efct_dword *inbuf, size_t inlen,
+			    efct_mcdi_async_completer *atomic_completer,
+			    efct_mcdi_async_completer *completer,
+			    unsigned long cookie, bool quiet,
+			    bool immediate_only, u32 *handle);
+/* Attempt to cancel an outstanding command.
+ * This function guarantees that the completion function will never be called
+ * after it returns. The command may or may not actually be cancelled.
+ */
+void efct_mcdi_cancel_cmd(struct efct_nic *efct, u32 handle);
+
+void efct_mcdi_display_error(struct efct_nic *efct, u32 cmd,
+			     size_t inlen, union efct_dword *outbuf,
+			     size_t outlen, int rc);
+
+int efct_mcdi_poll_reboot(struct efct_nic *efct);
+/* Wait for all commands and all cleanup for them to be complete */
+void efct_mcdi_wait_for_cleanup(struct efct_nic *efct);
+bool efct_mcdi_process_event(struct efct_nic *efct, union efct_qword *event);
+static inline void efct_mcdi_sensor_event(struct efct_nic *efct, union efct_qword *ev)
+{
+}
+
+static inline void efct_mcdi_dynamic_sensor_event(struct efct_nic *efct, union efct_qword *ev)
+{
+}
+
+/* We expect that 16- and 32-bit fields in MCDI requests and responses
+ * are appropriately aligned, but 64-bit fields are only
+ * 32-bit-aligned.  Also, on Siena we must copy to the MC shared
+ * memory strictly 32 bits at a time, so add any necessary padding.
+ */
+#define MCDI_DECLARE_BUF(_name, _len) union efct_dword _name[DIV_ROUND_UP(_len, 4)] = {{0}}
+#define MCDI_DECLARE_BUF_ERR(_name)					\
+	MCDI_DECLARE_BUF(_name, 8)
+#define _MCDI_PTR(_buf, _offset)					\
+	((u8 *)(_buf) + (_offset))
+#define MCDI_PTR(_buf, _field)						\
+	_MCDI_PTR(_buf, MC_CMD_ ## _field ## _OFST)
+#define _MCDI_CHECK_ALIGN(_ofst, _align)				\
+	((void)BUILD_BUG_ON_ZERO((_ofst) & ((_align) - 1)), (_ofst))
+#define _MCDI_DWORD(_buf, _field)					\
+	((_buf) + (_MCDI_CHECK_ALIGN(MC_CMD_ ## _field ## _OFST, 4) >> 2))
+#define MCDI_WORD(_buf, _field)						\
+	((void)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 2),	\
+	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
+#define MCDI_SET_DWORD(_buf, _field, _value)				\
+	EFCT_POPULATE_DWORD_1(*_MCDI_DWORD(_buf, _field), EFCT_DWORD_0, _value)
+#define MCDI_DWORD(_buf, _field)					\
+	EFCT_DWORD_FIELD(*_MCDI_DWORD(_buf, _field), EFCT_DWORD_0)
+#define MCDI_POPULATE_DWORD_1(_buf, _field, _name1, _value1)		\
+	EFCT_POPULATE_DWORD_1(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1)
+#define MCDI_POPULATE_DWORD_2(_buf, _field, _name1, _value1,		\
+			      _name2, _value2)				\
+	EFCT_POPULATE_DWORD_2(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2)
+#define MCDI_POPULATE_DWORD_3(_buf, _field, _name1, _value1,		\
+			      _name2, _value2, _name3, _value3)		\
+	EFCT_POPULATE_DWORD_3(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2,		\
+			     MC_CMD_ ## _name3, _value3)
+#define MCDI_POPULATE_DWORD_4(_buf, _field, _name1, _value1,		\
+			      _name2, _value2, _name3, _value3,		\
+			      _name4, _value4)				\
+	EFCT_POPULATE_DWORD_4(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2,		\
+			     MC_CMD_ ## _name3, _value3,		\
+			     MC_CMD_ ## _name4, _value4)
+#define MCDI_POPULATE_DWORD_5(_buf, _field, _name1, _value1,		\
+			      _name2, _value2, _name3, _value3,		\
+			      _name4, _value4, _name5, _value5)		\
+	EFCT_POPULATE_DWORD_5(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2,		\
+			     MC_CMD_ ## _name3, _value3,		\
+			     MC_CMD_ ## _name4, _value4,		\
+			     MC_CMD_ ## _name5, _value5)
+#define MCDI_POPULATE_DWORD_6(_buf, _field, _name1, _value1,		\
+			      _name2, _value2, _name3, _value3,		\
+			      _name4, _value4, _name5, _value5,		\
+			      _name6, _value6)				\
+	EFCT_POPULATE_DWORD_6(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2,		\
+			     MC_CMD_ ## _name3, _value3,		\
+			     MC_CMD_ ## _name4, _value4,		\
+			     MC_CMD_ ## _name5, _value5,		\
+			     MC_CMD_ ## _name6, _value6)
+#define MCDI_POPULATE_DWORD_7(_buf, _field, _name1, _value1,		\
+			      _name2, _value2, _name3, _value3,		\
+			      _name4, _value4, _name5, _value5,		\
+			      _name6, _value6, _name7, _value7)		\
+	EFCT_POPULATE_DWORD_7(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2,		\
+			     MC_CMD_ ## _name3, _value3,		\
+			     MC_CMD_ ## _name4, _value4,		\
+			     MC_CMD_ ## _name5, _value5,		\
+			     MC_CMD_ ## _name6, _value6,		\
+			     MC_CMD_ ## _name7, _value7)
+#define MCDI_POPULATE_DWORD_8(_buf, _field, _name1, _value1,		\
+			      _name2, _value2, _name3, _value3,		\
+			      _name4, _value4, _name5, _value5,		\
+			      _name6, _value6, _name7, _value7,		\
+			      _name8, _value8)		\
+	EFCT_POPULATE_DWORD_8(*_MCDI_DWORD(_buf, _field),		\
+			     MC_CMD_ ## _name1, _value1,		\
+			     MC_CMD_ ## _name2, _value2,		\
+			     MC_CMD_ ## _name3, _value3,		\
+			     MC_CMD_ ## _name4, _value4,		\
+			     MC_CMD_ ## _name5, _value5,		\
+			     MC_CMD_ ## _name6, _value6,		\
+			     MC_CMD_ ## _name7, _value7,		\
+			     MC_CMD_ ## _name8, _value8)
+#define MCDI_SET_QWORD(_buf, _field, _value)				\
+	do {								\
+		EFCT_POPULATE_DWORD_1(_MCDI_DWORD(_buf, _field)[0],	\
+				     EFCT_DWORD_0, (u32)(_value));	\
+		EFCT_POPULATE_DWORD_1(_MCDI_DWORD(_buf, _field)[1],	\
+				     EFCT_DWORD_0, (u64)(_value) >> 32);	\
+	} while (0)
+#define MCDI_QWORD(_buf, _field)					\
+	(EFCT_DWORD_FIELD(_MCDI_DWORD(_buf, _field)[0], EFCT_DWORD_0) |	\
+	(u64)EFCT_DWORD_FIELD(_MCDI_DWORD(_buf, _field)[1], EFCT_DWORD_0) << 32)
+#define _MCDI_ARRAY_PTR(_buf, _field, _index, _align)			\
+	(_MCDI_PTR(_buf, _MCDI_CHECK_ALIGN(MC_CMD_ ## _field ## _OFST, _align))\
+	 + (_index) * _MCDI_CHECK_ALIGN(MC_CMD_ ## _field ## _LEN, _align))
+#define MCDI_ARRAY_STRUCT_PTR(_buf, _field, _index)			\
+	((union efct_dword *)_MCDI_ARRAY_PTR(_buf, _field, _index, 4))
+#define _MCDI_ARRAY_DWORD(_buf, _field, _index)				\
+	(BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 4) +		\
+	 (union efct_dword *)_MCDI_ARRAY_PTR(_buf, _field, _index, 4))
+#define MCDI_SET_ARRAY_DWORD(_buf, _field, _index, _value)		\
+	EFCT_SET_DWORD_FIELD(*_MCDI_ARRAY_DWORD(_buf, _field, _index),	\
+			    EFCT_DWORD_0, _value)
+#define MCDI_ARRAY_DWORD(_buf, _field, _index)				\
+	EFCT_DWORD_FIELD(*_MCDI_ARRAY_DWORD(_buf, _field, _index), EFCT_DWORD_0)
+#define MCDI_EVENT_FIELD(_ev, _field)			\
+	EFCT_QWORD_FIELD(_ev, MCDI_EVENT_ ## _field)
+#define MCDI_CAPABILITY(field)						\
+	MC_CMD_GET_CAPABILITIES_V10_OUT_ ## field ## _LBN
+#define MCDI_CAPABILITY_OFST(field) \
+	MC_CMD_GET_CAPABILITIES_V10_OUT_ ## field ## _OFST
+#define efct_has_cap(efct, field) \
+	((efct)->type->check_caps((efct), \
+			      MCDI_CAPABILITY(field), \
+			      MCDI_CAPABILITY_OFST(field)))
+
+int efct_flr(struct efct_nic *efct);
+int efct_mcdi_drv_attach(struct efct_nic *efct, u32 fw_variant, u32 *out_flags,
+			 bool reattach);
+int efct_mcdi_drv_detach(struct efct_nic *efct);
+int efct_mcdi_log_ctrl(struct efct_nic *efct, bool evq, bool uart, u32 dest_evq);
+int efct_mcdi_nvram_info(struct efct_nic *efct, u32 type,
+			 size_t *size_out, size_t *erase_size_out,
+			 size_t *write_size_out, bool *protected_out);
+int efct_mcdi_handle_assertion(struct efct_nic *efct);
+int efct_mcdi_port_reconfigure(struct efct_nic *efct);
+int efct_mcdi_reset(struct efct_nic *efct, enum reset_type method);
+enum efct_update_finish_mode {
+	EFCT_UPDATE_FINISH_WAIT,
+	EFCT_UPDATE_FINISH_BACKGROUND,
+	EFCT_UPDATE_FINISH_POLL,
+	EFCT_UPDATE_FINISH_ABORT,
+};
+
+#endif /* EFCT_MCDI_H */
diff --git a/drivers/net/ethernet/amd/efct/mcdi_functions.c b/drivers/net/ethernet/amd/efct/mcdi_functions.c
new file mode 100644
index 000000000000..886b0f78bb5b
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi_functions.c
@@ -0,0 +1,642 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include "efct_driver.h"
+#include "mcdi.h"
+#include "mcdi_functions.h"
+#include "efct_nic.h"
+
+int efct_mcdi_ev_init(struct efct_ev_queue *eventq)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_INIT_EVQ_V3_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_EVQ_V3_IN_LEN);
+	struct efct_nic *efct = eventq->efct;
+	dma_addr_t dma_addr;
+	size_t outlen;
+	int rc;
+
+	/* Fill event queue with all ones (i.e. empty events) */
+	memset(eventq->buf.addr, 0xff, eventq->buf.len);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_SIZE, eventq->entries);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_INSTANCE, eventq->index);
+	/* INIT_EVQ expects index in vector table, not absolute */
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_IRQ_NUM, eventq->index);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_TMR_MODE, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_TMR_LOAD, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_TMR_RELOAD, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_COUNT_MODE, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_COUNT_THRSHLD, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_FLAG_INT_ARMD, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_FLAG_RPTR_DOS, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_RX_MERGE_TIMEOUT_NS, eventq->rx_merge_timeout_ns);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_V3_IN_TX_MERGE_TIMEOUT_NS, eventq->tx_merge_timeout_ns);
+
+	MCDI_POPULATE_DWORD_6(inbuf, INIT_EVQ_V3_IN_FLAGS,
+			      INIT_EVQ_V3_IN_FLAG_INTERRUPTING, 1,
+			      INIT_EVQ_V3_IN_FLAG_RX_MERGE, 1,
+			      INIT_EVQ_V3_IN_FLAG_TX_MERGE, 1,
+			      INIT_EVQ_V3_IN_FLAG_TYPE, 0,
+			      INIT_EVQ_V3_IN_FLAG_USE_TIMER, 1,
+			      INIT_EVQ_V3_IN_FLAG_CUT_THRU, 0);
+
+	dma_addr = eventq->buf.dma_addr;
+	MCDI_SET_QWORD(inbuf, INIT_EVQ_V3_IN_DMA_ADDR, dma_addr);
+	rc = efct_mcdi_rpc(efct, MC_CMD_INIT_EVQ, inbuf, MC_CMD_INIT_EVQ_V3_IN_LEN,
+			   outbuf, sizeof(outbuf), &outlen);
+
+	if (outlen >= MC_CMD_INIT_EVQ_V3_OUT_LEN)
+		netif_dbg(efct, drv, efct->net_dev,
+			  "Index %d using event queue flags %08x\n",
+			  eventq->index,
+			  MCDI_DWORD(outbuf, INIT_EVQ_V3_OUT_FLAGS));
+
+	return rc;
+}
+
+int efct_mcdi_ev_set_timer(struct efct_ev_queue *eventq, u32 ns, u32 mode, bool async)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_SET_EVQ_TMR_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_EVQ_TMR_IN_LEN);
+	struct efct_nic *efct = eventq->efct;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, SET_EVQ_TMR_IN_INSTANCE, eventq->index);
+	MCDI_SET_DWORD(inbuf, SET_EVQ_TMR_IN_TMR_LOAD_REQ_NS, ns);
+	MCDI_SET_DWORD(inbuf, SET_EVQ_TMR_IN_TMR_RELOAD_REQ_NS, ns);
+	MCDI_SET_DWORD(inbuf, SET_EVQ_TMR_IN_TMR_MODE, mode);
+
+	if (async) {
+		rc = efct_mcdi_rpc_async(efct, MC_CMD_SET_EVQ_TMR, inbuf, sizeof(inbuf), NULL, 0);
+	} else {
+		rc = efct_mcdi_rpc(efct, MC_CMD_SET_EVQ_TMR, inbuf, sizeof(inbuf),
+				   outbuf, sizeof(outbuf), &outlen);
+		if (rc)
+			efct_mcdi_display_error(efct, MC_CMD_SET_EVQ_TMR,
+						MC_CMD_SET_EVQ_TMR_IN_LEN, NULL, 0, rc);
+		else
+			/* Saving the actual value set */
+			eventq->irq_moderation_ns = MCDI_DWORD(outbuf,
+							       SET_EVQ_TMR_OUT_TMR_RELOAD_ACT_NS);
+	}
+
+	return rc;
+}
+
+int efct_mcdi_ev_fini(struct efct_ev_queue *eventq)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_EVQ_IN_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	struct efct_nic *efct;
+	size_t outlen;
+	int rc;
+
+	if (!eventq || !eventq->efct)
+		return -EINVAL;
+
+	efct = eventq->efct;
+	MCDI_SET_DWORD(inbuf, FINI_EVQ_IN_INSTANCE, eventq->index);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_FINI_EVQ, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc && rc != -EALREADY)
+		efct_mcdi_display_error(efct, MC_CMD_FINI_EVQ, MC_CMD_FINI_EVQ_IN_LEN, NULL, 0, rc);
+
+	return rc;
+}
+
+int efct_mcdi_rx_init(struct efct_rx_queue *rx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_RXQ_V5_IN_LEN);
+	struct efct_nic *efct = rx_queue->efct;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_INIT_RXQ_V5_OUT_LEN != 0);
+	/*set the inbuf memory to zero*/
+	memset(inbuf, 0, MC_CMD_INIT_RXQ_V5_IN_LEN);
+
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_SIZE, rx_queue->num_entries);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_TARGET_EVQ, rx_queue->evq_index);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_LABEL, rx_queue->label);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_INSTANCE, rx_queue->index);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_PORT_ID, EVB_PORT_ID_ASSIGNED);
+	MCDI_POPULATE_DWORD_4(inbuf, INIT_RXQ_V5_IN_FLAGS,
+			      INIT_RXQ_V5_IN_DMA_MODE,
+			      MC_CMD_INIT_RXQ_V5_IN_EQUAL_STRIDE_SUPER_BUFFER,
+			      INIT_RXQ_V5_IN_FLAG_TIMESTAMP, 1,
+			      INIT_RXQ_V5_IN_FLAG_PREFIX, 1,
+			      INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER, 1);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_ES_PACKET_STRIDE, roundup_pow_of_two(efct->mtu));
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_ES_MAX_DMA_LEN, efct->mtu);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V5_IN_ES_PACKET_BUFFERS_PER_BUCKET,
+		       DIV_ROUND_UP(rx_queue->buffer_size, rx_queue->pkt_stride));
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_INIT_RXQ, inbuf,
+			   MC_CMD_INIT_RXQ_V5_IN_LEN, NULL, 0, NULL);
+	if (rc && rc != -ENETDOWN && rc != -EAGAIN)
+		netif_err(efct, ifup, efct->net_dev,
+			  "failed to initialise RXQ %d, error %d\n", rx_queue->index, rc);
+
+	return rc;
+}
+
+int efct_mcdi_rx_fini(struct efct_rx_queue *rx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_RXQ_IN_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	struct efct_nic *efct = rx_queue->efct;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, FINI_RXQ_IN_INSTANCE, rx_queue->index);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_FINI_RXQ, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc && rc != -EALREADY)
+		efct_mcdi_display_error(efct, MC_CMD_FINI_RXQ, MC_CMD_FINI_RXQ_IN_LEN,
+					outbuf, outlen, rc);
+
+	return rc;
+}
+
+int efct_mcdi_tx_init(struct efct_tx_queue *tx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_EXT_IN_LEN);
+	struct efct_nic *efct = tx_queue->efct;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_INIT_TXQ_OUT_LEN != 0);
+	/*set the inbuf memory to zero*/
+	memset(inbuf, 0, MC_CMD_INIT_TXQ_EXT_IN_LEN);
+
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_EXT_IN_TARGET_EVQ, tx_queue->evq_index);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_EXT_IN_LABEL, tx_queue->label);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_EXT_IN_INSTANCE, tx_queue->txq_index);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_EXT_IN_PORT_ID, EVB_PORT_ID_ASSIGNED);
+	//TBD crc mode
+	MCDI_POPULATE_DWORD_4(inbuf, INIT_TXQ_EXT_IN_FLAGS,
+			      INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS, 1,
+			      INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS, 1,
+			      INIT_TXQ_EXT_IN_FLAG_CTPIO, 1,
+			      INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH, 1);
+
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_INIT_TXQ,
+				 inbuf, sizeof(inbuf),
+				NULL, 0, NULL);
+	if (rc) {
+		efct_mcdi_display_error(efct, MC_CMD_INIT_TXQ,
+					MC_CMD_INIT_TXQ_EXT_IN_LEN,
+				       NULL, 0, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+int efct_mcdi_tx_fini(struct efct_tx_queue *tx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_TXQ_IN_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	struct efct_nic *efct;
+	size_t outlen;
+	int rc;
+
+	efct = tx_queue->efct;
+	MCDI_SET_DWORD(inbuf, FINI_TXQ_IN_INSTANCE, tx_queue->txq_index);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_FINI_TXQ, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc && rc != -EALREADY)
+		efct_mcdi_display_error(efct, MC_CMD_FINI_TXQ, MC_CMD_FINI_TXQ_IN_LEN,
+					outbuf, outlen, rc);
+
+	return rc;
+}
+
+int efct_mcdi_filter_insert(struct efct_nic *efct, struct efct_filter_spec *rule, u64 *handle)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_FILTER_OP_EXT_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_V3_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	memset(inbuf, 0, MC_CMD_FILTER_OP_V3_IN_LEN);
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_OP, MC_CMD_FILTER_OP_IN_OP_INSERT);
+
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_RX_MODE, MC_CMD_FILTER_OP_V3_IN_RX_MODE_SIMPLE);
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_RX_DEST,
+		       (rule->queue_id == RX_CLS_FLOW_DISC ?
+		       MC_CMD_FILTER_OP_V3_IN_RX_DEST_DROP :
+		       MC_CMD_FILTER_OP_V3_IN_RX_DEST_HOST));
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_TX_DEST, MC_CMD_FILTER_OP_V3_IN_TX_DEST_DEFAULT);
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_PORT_ID, EVB_PORT_ID_ASSIGNED);
+
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_MATCH_FIELDS, rule->match_fields);
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_RX_QUEUE,
+		       (rule->queue_id == RX_CLS_FLOW_DISC ?
+		       0 : rule->queue_id));
+	memcpy(MCDI_PTR(inbuf, FILTER_OP_V3_IN_DST_IP), &rule->dst_ip, sizeof(rule->dst_ip));
+	memcpy(MCDI_PTR(inbuf, FILTER_OP_V3_IN_DST_PORT), &rule->dst_port, sizeof(rule->dst_port));
+	memcpy(MCDI_PTR(inbuf, FILTER_OP_V3_IN_IP_PROTO), &rule->ip_proto, sizeof(rule->ip_proto));
+	memcpy(MCDI_PTR(inbuf, FILTER_OP_V3_IN_ETHER_TYPE), &rule->ether_type,
+	       sizeof(rule->ether_type));
+
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_FILTER_OP, inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf), &outlen);
+	if (rc == 0)
+		*handle = MCDI_QWORD(outbuf, FILTER_OP_EXT_OUT_HANDLE);
+
+	return rc;
+}
+
+int efct_mcdi_filter_remove(struct efct_nic *efct, u64 handle)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_V3_IN_LEN);
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, FILTER_OP_V3_IN_OP, MC_CMD_FILTER_OP_IN_OP_REMOVE);
+	MCDI_SET_QWORD(inbuf, FILTER_OP_V3_IN_HANDLE, handle);
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_FILTER_OP, inbuf,
+				 sizeof(inbuf), NULL, 0, NULL);
+	return rc;
+}
+
+int efct_mcdi_filter_table_probe(struct efct_nic *efct)
+{
+	struct efct_mcdi_filter_table *table;
+	int rc = 0, i;
+
+	if (efct->filter_table) /* already probed */
+		return rc;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	efct->filter_table = table;
+
+	init_rwsem(&table->lock);
+	table->entry = vzalloc(EFCT_MCDI_FILTER_TBL_ROWS *
+			       sizeof(*table->entry));
+	if (!table->entry) {
+		rc = -ENOMEM;
+		return rc;
+	}
+
+	for (i = 0; i < EFCT_MCDI_FILTER_TBL_ROWS; i++) {
+		table->entry[i].handle = EFCT_HANDLE_INVALID;
+		table->entry[i].ref_cnt = 0;
+	}
+
+	return rc;
+}
+
+void efct_mcdi_filter_table_remove(struct efct_nic *efct)
+{
+	struct efct_mcdi_filter_table *table = efct->filter_table;
+	int i;
+
+	if (!table)
+		return;
+	for (i = 0; i < EFCT_MCDI_FILTER_TBL_ROWS; i++) {
+		if (table->entry[i].spec)
+			kfree((struct efct_filter_spec *)table->entry[i].spec);
+	}
+	vfree(table->entry);
+	table->entry = NULL;
+	efct->filter_table = NULL;
+	kfree(table);
+}
+
+#define EFCT_MCDI_NVRAM_LEN_MAX 128
+
+int efct_mcdi_nvram_update_start(struct efct_nic *efct, u32 type)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_UPDATE_START_V2_IN_LEN);
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, NVRAM_UPDATE_START_IN_TYPE, type);
+	MCDI_POPULATE_DWORD_1(inbuf, NVRAM_UPDATE_START_V2_IN_FLAGS,
+			      NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT, 1);
+
+	BUILD_BUG_ON(MC_CMD_NVRAM_UPDATE_START_OUT_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_NVRAM_UPDATE_START, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+
+	return rc;
+}
+
+int efct_mcdi_nvram_write(struct efct_nic *efct, u32 type,
+			  loff_t offset, const u8 *buffer, size_t length)
+{
+	union efct_dword *inbuf;
+	size_t inlen;
+	int rc;
+
+	inlen = ALIGN(MC_CMD_NVRAM_WRITE_IN_LEN(length), 4);
+	inbuf = kzalloc(inlen, GFP_KERNEL);
+	if (!inbuf)
+		return -ENOMEM;
+
+	MCDI_SET_DWORD(inbuf, NVRAM_WRITE_IN_TYPE, type);
+	MCDI_SET_DWORD(inbuf, NVRAM_WRITE_IN_OFFSET, offset);
+	MCDI_SET_DWORD(inbuf, NVRAM_WRITE_IN_LENGTH, length);
+	memcpy(MCDI_PTR(inbuf, NVRAM_WRITE_IN_WRITE_BUFFER), buffer, length);
+
+	BUILD_BUG_ON(MC_CMD_NVRAM_WRITE_OUT_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_NVRAM_WRITE, inbuf, inlen, NULL, 0, NULL);
+	kfree(inbuf);
+
+	return rc;
+}
+
+int efct_mcdi_nvram_erase(struct efct_nic *efct, u32 type,
+			  loff_t offset, size_t length)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_ERASE_IN_LEN);
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, NVRAM_ERASE_IN_TYPE, type);
+	MCDI_SET_DWORD(inbuf, NVRAM_ERASE_IN_OFFSET, offset);
+	MCDI_SET_DWORD(inbuf, NVRAM_ERASE_IN_LENGTH, length);
+
+	BUILD_BUG_ON(MC_CMD_NVRAM_ERASE_OUT_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_NVRAM_ERASE, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+	return rc;
+}
+
+int efct_mcdi_nvram_update_finish(struct efct_nic *efct, u32 type,
+				  enum efct_update_finish_mode mode)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_LEN);
+	size_t outlen;
+	int rc, rc2;
+	u32 reboot;
+
+	/* Reboot PHY's into the new firmware. mcfw reboot is handled
+	 * explicitly via ethtool.
+	 */
+	reboot = (type == MC_CMD_NVRAM_TYPE_PHY_PORT0 ||
+		  type == MC_CMD_NVRAM_TYPE_PHY_PORT1 ||
+		  type == MC_CMD_NVRAM_TYPE_DISABLED_CALLISTO);
+	MCDI_SET_DWORD(inbuf, NVRAM_UPDATE_FINISH_IN_TYPE, type);
+	MCDI_SET_DWORD(inbuf, NVRAM_UPDATE_FINISH_IN_REBOOT, reboot);
+
+	/* Old firmware doesn't support background update finish and abort
+	 * operations. Fallback to waiting if the requested mode is not
+	 * supported.
+	 */
+	if (!efct_has_cap(efct, NVRAM_UPDATE_POLL_VERIFY_RESULT) ||
+	    (!efct_has_cap(efct, NVRAM_UPDATE_ABORT_SUPPORTED) &&
+	     mode == EFCT_UPDATE_FINISH_ABORT))
+		mode = EFCT_UPDATE_FINISH_WAIT;
+
+	MCDI_POPULATE_DWORD_4(inbuf, NVRAM_UPDATE_FINISH_V2_IN_FLAGS,
+			      NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT,
+			      (mode != EFCT_UPDATE_FINISH_ABORT),
+			      NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND,
+			      (mode == EFCT_UPDATE_FINISH_BACKGROUND),
+			      NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT,
+			      (mode == EFCT_UPDATE_FINISH_POLL),
+			      NVRAM_UPDATE_FINISH_V2_IN_FLAG_ABORT,
+			      (mode == EFCT_UPDATE_FINISH_ABORT));
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_NVRAM_UPDATE_FINISH, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (!rc && outlen >= MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_LEN) {
+		rc2 = MCDI_DWORD(outbuf, NVRAM_UPDATE_FINISH_V2_OUT_RESULT_CODE);
+		if (rc2 != MC_CMD_NVRAM_VERIFY_RC_SUCCESS &&
+		    rc2 != MC_CMD_NVRAM_VERIFY_RC_PENDING)
+			netif_err(efct, drv, efct->net_dev,
+				  "NVRAM update failed verification with code 0x%x\n",
+				  rc2);
+		switch (rc2) {
+		case MC_CMD_NVRAM_VERIFY_RC_SUCCESS:
+			break;
+		case MC_CMD_NVRAM_VERIFY_RC_PENDING:
+			rc = -EAGAIN;
+			break;
+		case MC_CMD_NVRAM_VERIFY_RC_CMS_CHECK_FAILED:
+		case MC_CMD_NVRAM_VERIFY_RC_MESSAGE_DIGEST_CHECK_FAILED:
+		case MC_CMD_NVRAM_VERIFY_RC_SIGNATURE_CHECK_FAILED:
+		case MC_CMD_NVRAM_VERIFY_RC_TRUSTED_APPROVERS_CHECK_FAILED:
+		case MC_CMD_NVRAM_VERIFY_RC_SIGNATURE_CHAIN_CHECK_FAILED:
+			rc = -EIO;
+			break;
+		case MC_CMD_NVRAM_VERIFY_RC_INVALID_CMS_FORMAT:
+		case MC_CMD_NVRAM_VERIFY_RC_BAD_MESSAGE_DIGEST:
+			rc = -EINVAL;
+			break;
+		case MC_CMD_NVRAM_VERIFY_RC_NO_VALID_SIGNATURES:
+		case MC_CMD_NVRAM_VERIFY_RC_NO_TRUSTED_APPROVERS:
+		case MC_CMD_NVRAM_VERIFY_RC_NO_SIGNATURE_MATCH:
+		case MC_CMD_NVRAM_VERIFY_RC_REJECT_TEST_SIGNED:
+		case MC_CMD_NVRAM_VERIFY_RC_SECURITY_LEVEL_DOWNGRADE:
+			rc = -EPERM;
+			break;
+		default:
+			netif_err(efct, drv, efct->net_dev,
+				  "Unknown response to NVRAM_UPDATE_FINISH\n");
+			rc = -EIO;
+		}
+	}
+	return rc;
+}
+
+#define	EFCT_MCDI_NVRAM_UPDATE_FINISH_INITIAL_POLL_DELAY_MS 5
+#define	EFCT_MCDI_NVRAM_UPDATE_FINISH_MAX_POLL_DELAY_MS 5000
+#define	EFCT_MCDI_NVRAM_UPDATE_FINISH_RETRIES 185
+
+int efct_mcdi_nvram_update_finish_polled(struct efct_nic *efct, u32 type)
+{
+	u32 delay = EFCT_MCDI_NVRAM_UPDATE_FINISH_INITIAL_POLL_DELAY_MS;
+	u32 retry = 0;
+	int rc;
+
+	/* NVRAM updates can take a long time (e.g. up to 1 minute for bundle
+	 * images). Polling for NVRAM update completion ensures that other MCDI
+	 * commands can be issued before the background NVRAM update completes.
+	 *
+	 * The initial call either completes the update synchronously, or
+	 * returns -EAGAIN to indicate processing is continuing. In the latter
+	 * case, we poll for at least 900 seconds, at increasing intervals
+	 * (5ms, 50ms, 500ms, 5s).
+	 */
+	rc = efct_mcdi_nvram_update_finish(efct, type, EFCT_UPDATE_FINISH_BACKGROUND);
+	while (rc == -EAGAIN) {
+		if (retry > EFCT_MCDI_NVRAM_UPDATE_FINISH_RETRIES)
+			return -ETIMEDOUT;
+		retry++;
+
+		msleep(delay);
+		if (delay < EFCT_MCDI_NVRAM_UPDATE_FINISH_MAX_POLL_DELAY_MS)
+			delay *= 10;
+
+		rc = efct_mcdi_nvram_update_finish(efct, type, EFCT_UPDATE_FINISH_POLL);
+	}
+	return rc;
+}
+
+int efct_mcdi_nvram_metadata(struct efct_nic *efct, u32 type,
+			     u32 *subtype, u16 version[4], char *desc,
+			    size_t descsize)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
+	union efct_dword *outbuf;
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
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_NVRAM_METADATA, inbuf,
+				 sizeof(inbuf), outbuf,
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
+#define EFCT_MCDI_NVRAM_DEFAULT_WRITE_LEN 128
+
+int efct_mcdi_nvram_info(struct efct_nic *efct, u32 type,
+			 size_t *size_out, size_t *erase_size_out,
+			size_t *write_size_out, bool *protected_out)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_INFO_V2_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_INFO_IN_LEN);
+	size_t write_size = 0;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, NVRAM_INFO_IN_TYPE, type);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_NVRAM_INFO, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		goto fail;
+	if (outlen < MC_CMD_NVRAM_INFO_OUT_LEN) {
+		rc = -EIO;
+		goto fail;
+	}
+
+	if (outlen >= MC_CMD_NVRAM_INFO_V2_OUT_LEN)
+		write_size = MCDI_DWORD(outbuf, NVRAM_INFO_V2_OUT_WRITESIZE);
+	else
+		write_size = EFCT_MCDI_NVRAM_DEFAULT_WRITE_LEN;
+
+	*write_size_out = write_size;
+	*size_out = MCDI_DWORD(outbuf, NVRAM_INFO_V2_OUT_SIZE);
+	*erase_size_out = MCDI_DWORD(outbuf, NVRAM_INFO_V2_OUT_ERASESIZE);
+	*protected_out = !!(MCDI_DWORD(outbuf, NVRAM_INFO_V2_OUT_FLAGS) &
+				(1 << MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_LBN));
+	return 0;
+
+fail:
+	netif_err(efct, hw, efct->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	return rc;
+}
+
+void efct_mcdi_erom_ver(struct efct_nic *efct,
+			char *buf,
+			size_t len)
+{
+	u16 version[4];
+	int rc;
+
+	rc = efct_mcdi_nvram_metadata(efct, NVRAM_PARTITION_TYPE_EXPANSION_ROM,
+				      NULL, version, NULL, 0);
+	if (rc)
+		return;
+	len = min_t(size_t, EFCT_MAX_VERSION_INFO_LEN, len);
+	snprintf(buf, len, "%u.%u.%u.%u", version[0],
+		 version[1], version[2], version[3]);
+}
+
+void efct_mcdi_print_fwver(struct efct_nic *efct, char *buf, size_t len)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
+	const __le16 *ver_words;
+	size_t outlength;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_VERSION_IN_LEN != 0);
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf), outbuf,
+			   sizeof(outbuf), &outlength);
+	if (rc)
+		goto fail;
+	if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
+		goto fail;
+
+	ver_words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_VERSION);
+	snprintf(buf, len, "%u.%u.%u.%u",
+		 le16_to_cpu(ver_words[0]), le16_to_cpu(ver_words[1]),
+		 le16_to_cpu(ver_words[2]), le16_to_cpu(ver_words[3]));
+
+	return;
+
+fail:
+	buf[0] = 0;
+}
diff --git a/drivers/net/ethernet/amd/efct/mcdi_functions.h b/drivers/net/ethernet/amd/efct/mcdi_functions.h
new file mode 100644
index 000000000000..64d90ef23c2e
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi_functions.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_MCDI_FUNCTIONS_H
+#define EFCT_MCDI_FUNCTIONS_H
+
+#include "efct_driver.h"
+#include "efct_common.h"
+
+int efct_mcdi_ev_init(struct efct_ev_queue *eventq);
+int efct_mcdi_rx_init(struct efct_rx_queue *rx_queue);
+int efct_mcdi_tx_init(struct efct_tx_queue *tx_queue);
+int efct_mcdi_ev_fini(struct efct_ev_queue *eventq);
+int efct_mcdi_ev_set_timer(struct efct_ev_queue *eventq, u32 ns, u32 mode, bool async);
+int efct_mcdi_rx_fini(struct efct_rx_queue *rx_queue);
+int efct_mcdi_tx_fini(struct efct_tx_queue *tx_queue);
+int efct_mcdi_filter_insert(struct efct_nic *efct, struct efct_filter_spec *rule, u64 *handle);
+int efct_mcdi_filter_remove(struct efct_nic *efct, u64 handle);
+int efct_mcdi_filter_table_probe(struct efct_nic *efct);
+void efct_mcdi_filter_table_remove(struct efct_nic *efct);
+int efct_mcdi_nvram_update_start(struct efct_nic *efct, u32 type);
+int efct_mcdi_nvram_write(struct efct_nic *efct, u32 type,
+			  loff_t offset, const u8 *buffer, size_t length);
+int efct_mcdi_nvram_erase(struct efct_nic *efct, u32 type,
+			  loff_t offset, size_t length);
+int efct_mcdi_nvram_metadata(struct efct_nic *efct, u32 type,
+			     u32 *subtype, u16 version[4], char *desc,
+			     size_t descsize);
+
+int efct_mcdi_nvram_update_finish(struct efct_nic *efct, u32 type,
+				  enum efct_update_finish_mode mode);
+int efct_mcdi_nvram_update_finish_polled(struct efct_nic *efct, u32 type);
+void efct_mcdi_print_fwver(struct efct_nic *efct, char *buf, size_t len);
+void efct_mcdi_erom_ver(struct efct_nic *efct, char *buf, size_t len);
+#endif
diff --git a/drivers/net/ethernet/amd/efct/mcdi_pcol.h b/drivers/net/ethernet/amd/efct/mcdi_pcol.h
new file mode 100644
index 000000000000..ef8299e90cbb
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi_pcol.h
@@ -0,0 +1,5789 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef MCDI_PCOL_H
+#define MCDI_PCOL_H
+
+/* Values to be written into FMCR_CZ_RESET_STATE_REG to control boot. */
+/* Power-on reset state */
+#define MC_FW_STATE_POR (1)
+/* If this is set in MC_RESET_STATE_REG then it should be
+ * possible to jump into IMEM without loading code from flash.
+ */
+#define MC_FW_WARM_BOOT_OK (2)
+/* The MC main image has started to boot. */
+#define MC_FW_STATE_BOOTING (4)
+/* The Scheduler has started. */
+#define MC_FW_STATE_SCHED (8)
+/* If this is set in MC_RESET_STATE_REG then it should be
+ * possible to jump into IMEM without loading code from flash.
+ * Unlike a warm boot, assume DMEM has been reloaded, so that
+ * the MC persistent data must be reinitialised.
+ */
+#define MC_FW_TEPID_BOOT_OK (16)
+/* We have entered the main firmware via recovery mode. This
+ * means that MC persistent data must be reinitialised, but that
+ * we shouldn't touch PCIe config.
+ */
+#define MC_FW_RECOVERY_MODE_PCIE_INIT_OK (32)
+/* BIST state has been initialized */
+#define MC_FW_BIST_INIT_OK (128)
+
+/* Siena MC shared memory offsets */
+/* The 'doorbell' addresses are hard-wired to alert the MC when written */
+#define	MC_SMEM_P0_DOORBELL_OFST	0x000
+#define	MC_SMEM_P1_DOORBELL_OFST	0x004
+/* The rest of these are firmware-defined */
+#define	MC_SMEM_P0_PDU_OFST		0x008
+#define	MC_SMEM_P1_PDU_OFST		0x108
+#define	MC_SMEM_PDU_LEN			0x100
+#define	MC_SMEM_P0_PTP_TIME_OFST	0x7f0
+#define	MC_SMEM_P0_STATUS_OFST		0x7f8
+#define	MC_SMEM_P1_STATUS_OFST		0x7fc
+
+/* Values to be written to the per-port status dword in shared
+ * memory on reboot and assert
+ */
+#define MC_STATUS_DWORD_REBOOT (0xb007b007)
+#define MC_STATUS_DWORD_ASSERT (0xdeaddead)
+
+/* Check whether an mcfw version (in host order) belongs to a bootloader */
+#define MC_FW_VERSION_IS_BOOTLOADER(_v) (((_v) >> 16) == 0xb007)
+
+/* The current version of the MCDI protocol.
+ *
+ * Note that the ROM burnt into the card only talks V0, so at the very
+ * least every driver must support version 0 and MCDI_PCOL_VERSION
+ */
+#define MCDI_PCOL_VERSION 2
+
+/* Unused commands: 0x23, 0x27, 0x30, 0x31 */
+
+/* MCDI version 1
+ *
+ * Each MCDI request starts with an MCDI_HEADER, which is a 32bit
+ * structure, filled in by the client.
+ *
+ * 0 7 8 16 20 22 23 24 31
+ * | CODE | R | LEN | SEQ | Rsvd | E | R | XFLAGS |
+ * | | |
+ * | | \--- Response
+ * | \------- Error
+ * \------------------------------ Resync (always set)
+ *
+ * The client writes it's request into MC shared memory, and rings the
+ * doorbell. Each request is completed by either by the MC writing
+ * back into shared memory, or by writing out an event.
+ *
+ * All MCDI commands support completion by shared memory response. Each
+ * request may also contain additional data (accounted for by HEADER.LEN),
+ * and some response's may also contain additional data (again, accounted
+ * for by HEADER.LEN).
+ *
+ * Some MCDI commands support completion by event, in which any associated
+ * response data is included in the event.
+ *
+ * The protocol requires one response to be delivered for every request, a
+ * request should not be sent unless the response for the previous request
+ * has been received (either by polling shared memory, or by receiving
+ * an event).
+ */
+
+/** Request/Response structure */
+#define MCDI_HEADER_OFST 0
+#define MCDI_HEADER_CODE_LBN 0
+#define MCDI_HEADER_CODE_WIDTH 7
+#define MCDI_HEADER_RESYNC_LBN 7
+#define MCDI_HEADER_RESYNC_WIDTH 1
+#define MCDI_HEADER_DATALEN_LBN 8
+#define MCDI_HEADER_DATALEN_WIDTH 8
+#define MCDI_HEADER_SEQ_LBN 16
+#define MCDI_HEADER_SEQ_WIDTH 4
+#define MCDI_HEADER_RSVD_LBN 20
+#define MCDI_HEADER_RSVD_WIDTH 1
+#define MCDI_HEADER_NOT_EPOCH_LBN 21
+#define MCDI_HEADER_NOT_EPOCH_WIDTH 1
+#define MCDI_HEADER_ERROR_LBN 22
+#define MCDI_HEADER_ERROR_WIDTH 1
+#define MCDI_HEADER_RESPONSE_LBN 23
+#define MCDI_HEADER_RESPONSE_WIDTH 1
+#define MCDI_HEADER_XFLAGS_LBN 24
+#define MCDI_HEADER_XFLAGS_WIDTH 8
+/* Request response using event */
+#define MCDI_HEADER_XFLAGS_EVREQ 0x01
+/* Request (and signal) early doorbell return */
+#define MCDI_HEADER_XFLAGS_DBRET 0x02
+
+/* Maximum number of payload bytes */
+#define MCDI_CTL_SDU_LEN_MAX_V1 0xfc
+#define MCDI_CTL_SDU_LEN_MAX_V2 0x400
+
+#define MCDI_CTL_SDU_LEN_MAX MCDI_CTL_SDU_LEN_MAX_V2
+
+/* The MC can generate events for two reasons:
+ * - To advance a shared memory request if XFLAGS_EVREQ was set
+ * - As a notification (link state, i2c event), controlled
+ * via MC_CMD_LOG_CTRL
+ *
+ * Both events share a common structure:
+ *
+ * 0 32 33 36 44 52 60
+ * | Data | Cont | Level | Src | Code | Rsvd |
+ * |
+ * \ There is another event pending in this notification
+ *
+ * If Code==CMDDONE, then the fields are further interpreted as:
+ *
+ * - LEVEL==INFO Command succeeded
+ * - LEVEL==ERR Command failed
+ *
+ * 0 8 16 24 32
+ * | Seq | Datalen | Errno | Rsvd |
+ *
+ * These fields are taken directly out of the standard MCDI header, i.e.,
+ * LEVEL==ERR, Datalen == 0 => Reboot
+ *
+ * Events can be squirted out of the UART (using LOG_CTRL) without a
+ * MCDI header. An event can be distinguished from a MCDI response by
+ * examining the first byte which is 0xc0. This corresponds to the
+ * non-existent MCDI command MC_CMD_DEBUG_LOG.
+ *
+ * 0 7 8
+ * | command | Resync | = 0xc0
+ *
+ * Since the event is written in big-endian byte order, this works
+ * providing bits 56-63 of the event are 0xc0.
+ *
+ * 56 60 63
+ * | Rsvd | Code | = 0xc0
+ *
+ * Which means for convenience the event code is 0xc for all MC
+ * generated events.
+ */
+#define FSE_AZ_EV_CODE_MCDI_EVRESPONSE 0xc
+
+#define MC_CMD_ERR_CODE_OFST 0
+#define MC_CMD_ERR_PROXY_PENDING_HANDLE_OFST 4
+
+/* We define 8 "escape" commands to allow
+ * for command number space extension
+ */
+
+#define MC_CMD_CMD_SPACE_ESCAPE_0	 0x78
+#define MC_CMD_CMD_SPACE_ESCAPE_1	 0x79
+#define MC_CMD_CMD_SPACE_ESCAPE_2	 0x7A
+#define MC_CMD_CMD_SPACE_ESCAPE_3	 0x7B
+#define MC_CMD_CMD_SPACE_ESCAPE_4	 0x7C
+#define MC_CMD_CMD_SPACE_ESCAPE_5	 0x7D
+#define MC_CMD_CMD_SPACE_ESCAPE_6	 0x7E
+#define MC_CMD_CMD_SPACE_ESCAPE_7	 0x7F
+
+/* Vectors in the boot ROM */
+/* Point to the copycode entry point. */
+#define SIENA_MC_BOOTROM_COPYCODE_VEC (0x800 - 3 * 0x4)
+#define HUNT_MC_BOOTROM_COPYCODE_VEC (0x8000 - 3 * 0x4)
+#define MEDFORD_MC_BOOTROM_COPYCODE_VEC (0x10000 - 3 * 0x4)
+/* Points to the recovery mode entry point. Misnamed but kept for compatibility. */
+#define SIENA_MC_BOOTROM_NOFLASH_VEC (0x800 - 2 * 0x4)
+#define HUNT_MC_BOOTROM_NOFLASH_VEC (0x8000 - 2 * 0x4)
+#define MEDFORD_MC_BOOTROM_NOFLASH_VEC (0x10000 - 2 * 0x4)
+/* Points to the recovery mode entry point. Same as above, but the right name. */
+#define SIENA_MC_BOOTROM_RECOVERY_VEC (0x800 - 2 * 0x4)
+#define HUNT_MC_BOOTROM_RECOVERY_VEC (0x8000 - 2 * 0x4)
+#define MEDFORD_MC_BOOTROM_RECOVERY_VEC (0x10000 - 2 * 0x4)
+
+/* Points to noflash mode entry point. */
+#define MEDFORD_MC_BOOTROM_REAL_NOFLASH_VEC (0x10000 - 4 * 0x4)
+
+/* The command set exported by the boot ROM (MCDI v0) */
+#define MC_CMD_GET_VERSION_V0_SUPPORTED_FUNCS {		\
+	(1 << MC_CMD_READ32)	|			\
+	(1 << MC_CMD_WRITE32)	|			\
+	(1 << MC_CMD_COPYCODE)	|			\
+	(1 << MC_CMD_GET_VERSION),			\
+	0, 0, 0 }
+
+#define MC_CMD_SENSOR_INFO_OUT_OFFSET_OFST(_x)		\
+	(MC_CMD_SENSOR_ENTRY_OFST + (_x))
+
+#define MC_CMD_DBI_WRITE_IN_ADDRESS_OFST(n)		\
+	(MC_CMD_DBI_WRITE_IN_DBIWROP_OFST +		\
+	 MC_CMD_DBIWROP_TYPEDEF_ADDRESS_OFST +		\
+	 (n) * MC_CMD_DBIWROP_TYPEDEF_LEN)
+
+#define MC_CMD_DBI_WRITE_IN_BYTE_MASK_OFST(n)		\
+	(MC_CMD_DBI_WRITE_IN_DBIWROP_OFST +		\
+	 MC_CMD_DBIWROP_TYPEDEF_BYTE_MASK_OFST +	\
+	 (n) * MC_CMD_DBIWROP_TYPEDEF_LEN)
+
+#define MC_CMD_DBI_WRITE_IN_VALUE_OFST(n)		\
+	(MC_CMD_DBI_WRITE_IN_DBIWROP_OFST +		\
+	 MC_CMD_DBIWROP_TYPEDEF_VALUE_OFST +		\
+	 (n) * MC_CMD_DBIWROP_TYPEDEF_LEN)
+
+/* This may be ORed with an EVB_PORT_ID_xxx constant to pass a non-default
+ * stack ID (which must be in the range 1-255) along with an EVB port ID.
+ */
+#define EVB_STACK_ID(n) (((n) & 0xff) << 16)
+
+/* Version 2 adds an optional argument to error returns: the errno value
+ * may be followed by the (0-based) number of the first argument that
+ * could not be processed.
+ */
+#define MC_CMD_ERR_ARG_OFST 4
+
+/* MC_CMD_ERR enum: Public MCDI error codes. Error codes that correspond to
+ * POSIX errnos should use the same numeric values that linux does. Error codes
+ * specific to Solarflare firmware should use values in the range 0x1000 -
+ * 0x10ff. The range 0x2000 - 0x20ff is reserved for private error codes (see
+ * MC_CMD_ERR_PRIV below).
+ */
+/* enum: Operation not permitted. */
+#define MC_CMD_ERR_EPERM 0x1
+/* enum: Non-existent command target */
+#define MC_CMD_ERR_ENOENT 0x2
+/* enum: assert() has killed the MC */
+#define MC_CMD_ERR_EINTR 0x4
+/* enum: I/O failure */
+#define MC_CMD_ERR_EIO 0x5
+/* enum: Already exists */
+#define MC_CMD_ERR_EEXIST 0x6
+/* enum: Try again */
+#define MC_CMD_ERR_EAGAIN 0xb
+/* enum: Out of memory */
+#define MC_CMD_ERR_ENOMEM 0xc
+/* enum: Caller does not hold required locks */
+#define MC_CMD_ERR_EACCES 0xd
+/* enum: Resource is currently unavailable (e.g. lock contention) */
+#define MC_CMD_ERR_EBUSY 0x10
+/* enum: No such device */
+#define MC_CMD_ERR_ENODEV 0x13
+/* enum: Invalid argument to target */
+#define MC_CMD_ERR_EINVAL 0x16
+/* enum: No space */
+#define MC_CMD_ERR_ENOSPC 0x1c
+/* enum: Read-only */
+#define MC_CMD_ERR_EROFS 0x1e
+/* enum: Broken pipe */
+#define MC_CMD_ERR_EPIPE 0x20
+/* enum: Out of range */
+#define MC_CMD_ERR_ERANGE 0x22
+/* enum: Non-recursive resource is already acquired */
+#define MC_CMD_ERR_EDEADLK 0x23
+/* enum: Operation not implemented */
+#define MC_CMD_ERR_ENOSYS 0x26
+/* enum: Operation timed out */
+#define MC_CMD_ERR_ETIME 0x3e
+/* enum: Link has been severed */
+#define MC_CMD_ERR_ENOLINK 0x43
+/* enum: Protocol error */
+#define MC_CMD_ERR_EPROTO 0x47
+/* enum: Bad message */
+#define MC_CMD_ERR_EBADMSG 0x4a
+/* enum: Operation not supported */
+#define MC_CMD_ERR_ENOTSUP 0x5f
+/* enum: Address not available */
+#define MC_CMD_ERR_EADDRNOTAVAIL 0x63
+/* enum: Not connected */
+#define MC_CMD_ERR_ENOTCONN 0x6b
+/* enum: Operation already in progress */
+#define MC_CMD_ERR_EALREADY 0x72
+/* enum: Stale handle. The handle references a resource that no longer exists.
+ */
+#define MC_CMD_ERR_ESTALE 0x74
+/* enum: Resource allocation failed. */
+#define MC_CMD_ERR_ALLOC_FAIL 0x1000
+/* enum: V-adaptor not found. */
+#define MC_CMD_ERR_NO_VADAPTOR 0x1001
+/* enum: EVB port not found. */
+#define MC_CMD_ERR_NO_EVB_PORT 0x1002
+/* enum: V-switch not found. */
+#define MC_CMD_ERR_NO_VSWITCH 0x1003
+/* enum: Too many VLAN tags. */
+#define MC_CMD_ERR_VLAN_LIMIT 0x1004
+/* enum: Bad PCI function number. */
+#define MC_CMD_ERR_BAD_PCI_FUNC 0x1005
+/* enum: Invalid VLAN mode. */
+#define MC_CMD_ERR_BAD_VLAN_MODE 0x1006
+/* enum: Invalid v-switch type. */
+#define MC_CMD_ERR_BAD_VSWITCH_TYPE 0x1007
+/* enum: Invalid v-port type. */
+#define MC_CMD_ERR_BAD_VPORT_TYPE 0x1008
+/* enum: MAC address exists. */
+#define MC_CMD_ERR_MAC_EXIST 0x1009
+/* enum: Slave core not present */
+#define MC_CMD_ERR_SLAVE_NOT_PRESENT 0x100a
+/* enum: The datapath is disabled. */
+#define MC_CMD_ERR_DATAPATH_DISABLED 0x100b
+/* enum: The requesting client is not a function */
+#define MC_CMD_ERR_CLIENT_NOT_FN 0x100c
+/* enum: The requested operation might require the command to be passed between
+ * MCs, and thetransport doesn't support that. Should only ever been seen over
+ * the UART.
+ */
+#define MC_CMD_ERR_TRANSPORT_NOPROXY 0x100d
+/* enum: VLAN tag(s) exists */
+#define MC_CMD_ERR_VLAN_EXIST 0x100e
+/* enum: No MAC address assigned to an EVB port */
+#define MC_CMD_ERR_NO_MAC_ADDR 0x100f
+/* enum: Notifies the driver that the request has been relayed to an admin
+ * function for authorization. The driver should wait for a PROXY_RESPONSE
+ * event and then resend its request. This error code is followed by a 32-bit
+ * handle that helps matching it with the respective PROXY_RESPONSE event.
+ */
+#define MC_CMD_ERR_PROXY_PENDING 0x1010
+/* enum: The request cannot be passed for authorization because another request
+ * from the same function is currently being authorized. The driver should try
+ * again later.
+ */
+#define MC_CMD_ERR_PROXY_INPROGRESS 0x1011
+/* enum: Returned by MC_CMD_PROXY_COMPLETE if the caller is not the function
+ * that has enabled proxying or BLOCK_INDEX points to a function that doesn't
+ * await an authorization.
+ */
+#define MC_CMD_ERR_PROXY_UNEXPECTED 0x1012
+/* enum: This code is currently only used internally in FW. Its meaning is that
+ * an operation failed due to lack of SR-IOV privilege. Normally it is
+ * translated to EPERM by send_cmd_err(), but it may also be used to trigger
+ * some special mechanism for handling such case, e.g. to relay the failed
+ * request to a designated admin function for authorization.
+ */
+#define MC_CMD_ERR_NO_PRIVILEGE 0x1013
+/* enum: Workaround 26807 could not be turned on/off because some functions
+ * have already installed filters. See the comment at
+ * MC_CMD_WORKAROUND_BUG26807. May also returned for other operations such as
+ * sub-variant switching.
+ */
+#define MC_CMD_ERR_FILTERS_PRESENT 0x1014
+/* enum: The clock whose frequency you've attempted to set doesn't exist on
+ * this NIC
+ */
+#define MC_CMD_ERR_NO_CLOCK 0x1015
+/* enum: Returned by MC_CMD_TESTASSERT if the action that should have caused an
+ * assertion failed to do so.
+ */
+#define MC_CMD_ERR_UNREACHABLE 0x1016
+/* enum: This command needs to be processed in the background but there were no
+ * resources to do so. Send it again after a command has completed.
+ */
+#define MC_CMD_ERR_QUEUE_FULL 0x1017
+/* enum: The operation could not be completed because the PCIe link has gone
+ * away. This error code is never expected to be returned over the TLP
+ * transport.
+ */
+#define MC_CMD_ERR_NO_PCIE 0x1018
+/* enum: The operation could not be completed because the datapath has gone
+ * away. This is distinct from MC_CMD_ERR_DATAPATH_DISABLED in that the
+ * datapath absence may be temporary
+ */
+#define MC_CMD_ERR_NO_DATAPATH 0x1019
+/* enum: The operation could not complete because some VIs are allocated */
+#define MC_CMD_ERR_VIS_PRESENT 0x101a
+/* enum: The operation could not complete because some PIO buffers are
+ * allocated
+ */
+#define MC_CMD_ERR_PIOBUFS_PRESENT 0x101b
+
+/* MC_CMD_RESOURCE_SPECIFIER enum */
+/* enum: Any */
+#define MC_CMD_RESOURCE_INSTANCE_ANY 0xffffffff
+#define MC_CMD_RESOURCE_INSTANCE_NONE 0xfffffffe /* enum */
+
+/* MC_CMD_FPGA_FLASH_INDEX enum */
+#define MC_CMD_FPGA_FLASH_PRIMARY 0x0 /* enum */
+#define MC_CMD_FPGA_FLASH_SECONDARY 0x1 /* enum */
+
+/* MC_CMD_EXTERNAL_MAE_LINK_MODE enum */
+/* enum: Legacy mode as described in XN-200039-TC. */
+#define MC_CMD_EXTERNAL_MAE_LINK_MODE_LEGACY 0x0
+/* enum: Switchdev mode as described in XN-200039-TC. */
+#define MC_CMD_EXTERNAL_MAE_LINK_MODE_SWITCHDEV 0x1
+/* enum: Bootstrap mode as described in XN-200039-TC. */
+#define MC_CMD_EXTERNAL_MAE_LINK_MODE_BOOTSTRAP 0x2
+/* enum: Link-mode change is in-progress as described in XN-200039-TC. */
+#define MC_CMD_EXTERNAL_MAE_LINK_MODE_PENDING 0xf
+
+/* PCIE_INTERFACE enum: From EF100 onwards, SFC products can have multiple PCIe
+ * interfaces. There is a need to refer to interfaces explicitly from drivers
+ * (for example, a management driver on one interface administering a function
+ * on another interface). This enumeration provides stable identifiers to all
+ * interfaces present on a product. Product documentation will specify which
+ * interfaces exist and their associated identifier. In general, drivers,
+ * should not assign special meanings to specific values. Instead, behaviour
+ * should be determined by NIC configuration, which will identify interfaces
+ * where appropriate.
+ */
+/* enum: Primary host interfaces. Typically (i.e. for all known SFC products)
+ * the interface exposed on the edge connector (or form factor equivalent).
+ */
+#define PCIE_INTERFACE_HOST_PRIMARY 0x0
+/* enum: Riverhead and keystone products have a second PCIe interface to which
+ * an on-NIC ARM module is expected to be connected.
+ */
+#define PCIE_INTERFACE_NIC_EMBEDDED 0x1
+/* enum: For MCDI commands issued over a PCIe interface, this value is
+ * translated into the interface over which the command was issued. Not
+ * meaningful for other MCDI transports.
+ */
+#define PCIE_INTERFACE_CALLER 0xffffffff
+
+/* MC_CLIENT_ID_SPECIFIER enum */
+/* enum: Equivalent to the caller's client ID */
+#define MC_CMD_CLIENT_ID_SELF 0xffffffff
+
+/* MCDI_EVENT structuredef: The structure of an MCDI_EVENT on Siena/EF10/EF100
+ * platforms
+ */
+#define MCDI_EVENT_LEN 8
+#define MCDI_EVENT_CONT_LBN 32
+#define MCDI_EVENT_CONT_WIDTH 1
+#define MCDI_EVENT_LEVEL_LBN 33
+#define MCDI_EVENT_LEVEL_WIDTH 3
+/* enum: Info. */
+#define MCDI_EVENT_LEVEL_INFO 0x0
+/* enum: Warning. */
+#define MCDI_EVENT_LEVEL_WARN 0x1
+/* enum: Error. */
+#define MCDI_EVENT_LEVEL_ERR 0x2
+/* enum: Fatal. */
+#define MCDI_EVENT_LEVEL_FATAL 0x3
+#define MCDI_EVENT_DATA_OFST 0
+#define MCDI_EVENT_DATA_LEN 4
+#define MCDI_EVENT_CMDDONE_SEQ_OFST 0
+#define MCDI_EVENT_CMDDONE_SEQ_LBN 0
+#define MCDI_EVENT_CMDDONE_SEQ_WIDTH 8
+#define MCDI_EVENT_CMDDONE_DATALEN_OFST 0
+#define MCDI_EVENT_CMDDONE_DATALEN_LBN 8
+#define MCDI_EVENT_CMDDONE_DATALEN_WIDTH 8
+#define MCDI_EVENT_CMDDONE_ERRNO_OFST 0
+#define MCDI_EVENT_CMDDONE_ERRNO_LBN 16
+#define MCDI_EVENT_CMDDONE_ERRNO_WIDTH 8
+#define MCDI_EVENT_LINKCHANGE_LP_CAP_OFST 0
+#define MCDI_EVENT_LINKCHANGE_LP_CAP_LBN 0
+#define MCDI_EVENT_LINKCHANGE_LP_CAP_WIDTH 16
+#define MCDI_EVENT_LINKCHANGE_SPEED_OFST 0
+#define MCDI_EVENT_LINKCHANGE_SPEED_LBN 16
+#define MCDI_EVENT_LINKCHANGE_SPEED_WIDTH 4
+/* enum: Link is down or link speed could not be determined */
+#define MCDI_EVENT_LINKCHANGE_SPEED_UNKNOWN 0x0
+/* enum: 100Mbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_100M 0x1
+/* enum: 1Gbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_1G 0x2
+/* enum: 10Gbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_10G 0x3
+/* enum: 40Gbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_40G 0x4
+/* enum: 25Gbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_25G 0x5
+/* enum: 50Gbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_50G 0x6
+/* enum: 100Gbs */
+#define MCDI_EVENT_LINKCHANGE_SPEED_100G 0x7
+#define MCDI_EVENT_LINKCHANGE_FCNTL_OFST 0
+#define MCDI_EVENT_LINKCHANGE_FCNTL_LBN 20
+#define MCDI_EVENT_LINKCHANGE_FCNTL_WIDTH 4
+#define MCDI_EVENT_LINKCHANGE_LINK_FLAGS_OFST 0
+#define MCDI_EVENT_LINKCHANGE_LINK_FLAGS_LBN 24
+#define MCDI_EVENT_LINKCHANGE_LINK_FLAGS_WIDTH 8
+#define MCDI_EVENT_LINKCHANGE_V2_LP_CAP_OFST 0
+#define MCDI_EVENT_LINKCHANGE_V2_LP_CAP_LBN 0
+#define MCDI_EVENT_LINKCHANGE_V2_LP_CAP_WIDTH 24
+#define MCDI_EVENT_LINKCHANGE_V2_SPEED_OFST 0
+#define MCDI_EVENT_LINKCHANGE_V2_SPEED_LBN 24
+#define MCDI_EVENT_LINKCHANGE_V2_SPEED_WIDTH 4
+/* Enum values, see field(s): */
+/* MCDI_EVENT/LINKCHANGE_SPEED */
+#define MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP_OFST 0
+#define MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP_LBN 28
+#define MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP_WIDTH 1
+#define MCDI_EVENT_LINKCHANGE_V2_FCNTL_OFST 0
+#define MCDI_EVENT_LINKCHANGE_V2_FCNTL_LBN 29
+#define MCDI_EVENT_LINKCHANGE_V2_FCNTL_WIDTH 3
+/* Enum values, see field(s): */
+/* MC_CMD_SET_MAC/MC_CMD_SET_MAC_IN/FCNTL */
+#define MCDI_EVENT_MODULECHANGE_LD_CAP_OFST 0
+#define MCDI_EVENT_MODULECHANGE_LD_CAP_LBN 0
+#define MCDI_EVENT_MODULECHANGE_LD_CAP_WIDTH 30
+#define MCDI_EVENT_MODULECHANGE_SEQ_OFST 0
+#define MCDI_EVENT_MODULECHANGE_SEQ_LBN 30
+#define MCDI_EVENT_MODULECHANGE_SEQ_WIDTH 2
+#define MCDI_EVENT_DATA_LBN 0
+#define MCDI_EVENT_DATA_WIDTH 32
+/* Alias for PTP_DATA. */
+#define MCDI_EVENT_SRC_LBN 36
+#define MCDI_EVENT_SRC_WIDTH 8
+/* Data associated with PTP events which doesn't fit into the main DATA field
+ */
+#define MCDI_EVENT_PTP_DATA_LBN 36
+#define MCDI_EVENT_PTP_DATA_WIDTH 8
+/* EF100 specific. Defined by QDMA. The phase bit, changes each time round the
+ * event ring
+ */
+#define MCDI_EVENT_EV_EVQ_PHASE_LBN 59
+#define MCDI_EVENT_EV_EVQ_PHASE_WIDTH 1
+#define MCDI_EVENT_EV_CODE_LBN 60
+#define MCDI_EVENT_EV_CODE_WIDTH 4
+#define MCDI_EVENT_CODE_LBN 44
+#define MCDI_EVENT_CODE_WIDTH 8
+/* enum: Event generated by host software */
+#define MCDI_EVENT_SW_EVENT 0x0
+/* enum: Bad assert. */
+#define MCDI_EVENT_CODE_BADSSERT 0x1
+/* enum: PM Notice. */
+#define MCDI_EVENT_CODE_PMNOTICE 0x2
+/* enum: Command done. */
+#define MCDI_EVENT_CODE_CMDDONE 0x3
+/* enum: Link change. */
+#define MCDI_EVENT_CODE_LINKCHANGE 0x4
+/* enum: Sensor Event. */
+#define MCDI_EVENT_CODE_SENSOREVT 0x5
+/* enum: Schedule error. */
+#define MCDI_EVENT_CODE_SCHEDERR 0x6
+/* enum: Reboot. */
+#define MCDI_EVENT_CODE_REBOOT 0x7
+/* enum: Mac stats DMA. */
+#define MCDI_EVENT_CODE_MAC_STATS_DMA 0x8
+/* enum: Firmware alert. */
+#define MCDI_EVENT_CODE_FWALERT 0x9
+/* enum: Function level reset. */
+#define MCDI_EVENT_CODE_FLR 0xa
+/* enum: Transmit error */
+#define MCDI_EVENT_CODE_TX_ERR 0xb
+/* enum: Tx flush has completed */
+#define MCDI_EVENT_CODE_TX_FLUSH 0xc
+/* enum: PTP packet received timestamp */
+#define MCDI_EVENT_CODE_PTP_RX 0xd
+/* enum: PTP NIC failure */
+#define MCDI_EVENT_CODE_PTP_FAULT 0xe
+/* enum: PTP PPS event */
+#define MCDI_EVENT_CODE_PTP_PPS 0xf
+/* enum: Rx flush has completed */
+#define MCDI_EVENT_CODE_RX_FLUSH 0x10
+/* enum: Receive error */
+#define MCDI_EVENT_CODE_RX_ERR 0x11
+/* enum: AOE fault */
+#define MCDI_EVENT_CODE_AOE 0x12
+/* enum: Network port calibration failed (VCAL). */
+#define MCDI_EVENT_CODE_VCAL_FAIL 0x13
+/* enum: HW PPS event */
+#define MCDI_EVENT_CODE_HW_PPS 0x14
+/* enum: The MC has rebooted (huntington and later, siena uses CODE_REBOOT and
+ * a different format)
+ */
+#define MCDI_EVENT_CODE_MC_REBOOT 0x15
+
+/* enum: The MC has entered offline BIST mode */
+#define MCDI_EVENT_CODE_MC_BIST 0x19
+
+#define MCDI_EVENT_CODE_PROXY_REQUEST 0x1c
+/* enum: notify a function that awaits an authorization that its request has
+ * been processed and it may now resend the command
+ */
+#define MCDI_EVENT_CODE_PROXY_RESPONSE 0x1d
+
+/* enum: Link change. This event is sent instead of LINKCHANGE if
+ * WANT_V2_LINKCHANGES was set on driver attach.
+ */
+#define MCDI_EVENT_CODE_LINKCHANGE_V2 0x20
+/* enum: This event is sent if WANT_V2_LINKCHANGES was set on driver attach
+ * when the local device capabilities changes. This will usually correspond to
+ * a module change.
+ */
+#define MCDI_EVENT_CODE_MODULECHANGE 0x21
+/* enum: Notification that the sensors have been added and/or removed from the
+ * sensor table. This event includes the new sensor table generation count, if
+ * this does not match the driver's local copy it is expected to call
+ * DYNAMIC_SENSORS_LIST to refresh it.
+ */
+#define MCDI_EVENT_CODE_DYNAMIC_SENSORS_CHANGE 0x22
+/* enum: Notification that a sensor has changed state as a result of a reading
+ * crossing a threshold. This is sent as two events, the first event contains
+ * the handle and the sensor's state (in the SRC field), and the second
+ * contains the value.
+ */
+#define MCDI_EVENT_CODE_DYNAMIC_SENSORS_STATE_CHANGE 0x23
+
+/* For CODE_PTP_RX, CODE_PTP_PPS and CODE_HW_PPS events the major field of
+ * timestamp
+ */
+#define MCDI_EVENT_PTP_MAJOR_OFST 0
+#define MCDI_EVENT_PTP_MAJOR_LEN 4
+#define MCDI_EVENT_PTP_MAJOR_LBN 0
+#define MCDI_EVENT_PTP_MAJOR_WIDTH 32
+/* For CODE_PTP_RX, CODE_PTP_PPS and CODE_HW_PPS events the nanoseconds field
+ * of timestamp
+ */
+#define MCDI_EVENT_PTP_NANOSECONDS_OFST 0
+#define MCDI_EVENT_PTP_NANOSECONDS_LEN 4
+#define MCDI_EVENT_PTP_NANOSECONDS_LBN 0
+#define MCDI_EVENT_PTP_NANOSECONDS_WIDTH 32
+/* For CODE_PTP_RX, CODE_PTP_PPS and CODE_HW_PPS events the minor field of
+ * timestamp
+ */
+#define MCDI_EVENT_PTP_MINOR_OFST 0
+#define MCDI_EVENT_PTP_MINOR_LEN 4
+#define MCDI_EVENT_PTP_MINOR_LBN 0
+#define MCDI_EVENT_PTP_MINOR_WIDTH 32
+#define MCDI_EVENT_PROXY_RESPONSE_HANDLE_OFST 0
+#define MCDI_EVENT_PROXY_RESPONSE_HANDLE_LEN 4
+#define MCDI_EVENT_PROXY_RESPONSE_HANDLE_LBN 0
+#define MCDI_EVENT_PROXY_RESPONSE_HANDLE_WIDTH 32
+/* Zero means that the request has been completed or authorized, and the driver
+ * should resend it. A non-zero value means that the authorization has been
+ * denied, and gives the reason. Typically it will be EPERM.
+ */
+#define MCDI_EVENT_PROXY_RESPONSE_RC_LBN 36
+#define MCDI_EVENT_PROXY_RESPONSE_RC_WIDTH 8
+#define MCDI_EVENT_LINKCHANGE_V2_DATA_OFST 0
+#define MCDI_EVENT_LINKCHANGE_V2_DATA_LEN 4
+#define MCDI_EVENT_LINKCHANGE_V2_DATA_LBN 0
+#define MCDI_EVENT_LINKCHANGE_V2_DATA_WIDTH 32
+#define MCDI_EVENT_MODULECHANGE_DATA_OFST 0
+#define MCDI_EVENT_MODULECHANGE_DATA_LEN 4
+#define MCDI_EVENT_MODULECHANGE_DATA_LBN 0
+#define MCDI_EVENT_MODULECHANGE_DATA_WIDTH 32
+/* The new generation count after a sensor has been added or deleted. */
+#define MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_OFST 0
+#define MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_LEN 4
+#define MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_LBN 0
+#define MCDI_EVENT_DYNAMIC_SENSORS_GENERATION_WIDTH 32
+/* The handle of a dynamic sensor. */
+#define MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_OFST 0
+#define MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_LEN 4
+#define MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_LBN 0
+#define MCDI_EVENT_DYNAMIC_SENSORS_HANDLE_WIDTH 32
+/* The current values of a sensor. */
+#define MCDI_EVENT_DYNAMIC_SENSORS_VALUE_OFST 0
+#define MCDI_EVENT_DYNAMIC_SENSORS_VALUE_LEN 4
+#define MCDI_EVENT_DYNAMIC_SENSORS_VALUE_LBN 0
+#define MCDI_EVENT_DYNAMIC_SENSORS_VALUE_WIDTH 32
+/* The current state of a sensor. */
+#define MCDI_EVENT_DYNAMIC_SENSORS_STATE_LBN 36
+#define MCDI_EVENT_DYNAMIC_SENSORS_STATE_WIDTH 8
+/***********************************/
+/* MC_CMD_GET_ASSERTS
+ * Get (and optionally clear) the current assertion status. Only
+ * OUT.GLOBAL_FLAGS is guaranteed to exist in the completion payload. The other
+ * fields will only be present if OUT.GLOBAL_FLAGS != NO_FAILS
+ */
+#define MC_CMD_GET_ASSERTS 0x6
+#define MC_CMD_GET_ASSERTS_MSGSET 0x6
+
+/* MC_CMD_GET_ASSERTS_IN msgrequest */
+#define MC_CMD_GET_ASSERTS_IN_LEN 4
+/* Set to clear assertion */
+#define MC_CMD_GET_ASSERTS_IN_CLEAR_OFST 0
+#define MC_CMD_GET_ASSERTS_IN_CLEAR_LEN 4
+/* MC_CMD_GET_ASSERTS_OUT msgresponse */
+#define MC_CMD_GET_ASSERTS_OUT_LEN 140
+/* Assertion status flag. */
+#define MC_CMD_GET_ASSERTS_OUT_GLOBAL_FLAGS_OFST 0
+#define MC_CMD_GET_ASSERTS_OUT_GLOBAL_FLAGS_LEN 4
+/* enum: No assertions have failed. */
+#define MC_CMD_GET_ASSERTS_FLAGS_NO_FAILS 0x1
+/* enum: A system-level assertion has failed. */
+#define MC_CMD_GET_ASSERTS_FLAGS_SYS_FAIL 0x2
+/* enum: A thread-level assertion has failed. */
+#define MC_CMD_GET_ASSERTS_FLAGS_THR_FAIL 0x3
+/* enum: The system was reset by the watchdog. */
+#define MC_CMD_GET_ASSERTS_FLAGS_WDOG_FIRED 0x4
+/* enum: An illegal address trap stopped the system (huntington and later) */
+#define MC_CMD_GET_ASSERTS_FLAGS_ADDR_TRAP 0x5
+#define MC_CMD_GET_ASSERTS_OUT_GP_REGS_OFFS_NUM 31
+/* enum: A magic value hinting that the value in this register at the time of
+ * the failure has likely been lost.
+ */
+#define MC_CMD_GET_ASSERTS_REG_NO_DATA 0xda7a1057
+/* Failing thread address */
+#define MC_CMD_GET_ASSERTS_OUT_THREAD_OFFS_OFST 132
+#define MC_CMD_GET_ASSERTS_OUT_THREAD_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_RESERVED_OFST 136
+#define MC_CMD_GET_ASSERTS_OUT_RESERVED_LEN 4
+
+/* MC_CMD_GET_ASSERTS_OUT_V2 msgresponse: Extended response for MicroBlaze CPUs
+ * found on Riverhead designs
+ */
+#define MC_CMD_GET_ASSERTS_OUT_V2_LEN 240
+/* Assertion status flag. */
+#define MC_CMD_GET_ASSERTS_OUT_V2_GLOBAL_FLAGS_OFST 0
+#define MC_CMD_GET_ASSERTS_OUT_V2_GLOBAL_FLAGS_LEN 4
+/* enum: No assertions have failed. */
+/* MC_CMD_GET_ASSERTS_FLAGS_NO_FAILS 0x1 */
+/* enum: A system-level assertion has failed. */
+/* MC_CMD_GET_ASSERTS_FLAGS_SYS_FAIL 0x2 */
+/* enum: A thread-level assertion has failed. */
+/* MC_CMD_GET_ASSERTS_FLAGS_THR_FAIL 0x3 */
+/* enum: The system was reset by the watchdog. */
+/* MC_CMD_GET_ASSERTS_FLAGS_WDOG_FIRED 0x4 */
+/* enum: An illegal address trap stopped the system (huntington and later) */
+/* MC_CMD_GET_ASSERTS_FLAGS_ADDR_TRAP 0x5 */
+/* Failing PC value */
+#define MC_CMD_GET_ASSERTS_OUT_V2_SAVED_PC_OFFS_OFST 4
+#define MC_CMD_GET_ASSERTS_OUT_V2_SAVED_PC_OFFS_LEN 4
+/* Saved GP regs */
+#define MC_CMD_GET_ASSERTS_OUT_V2_GP_REGS_OFFS_OFST 8
+#define MC_CMD_GET_ASSERTS_OUT_V2_GP_REGS_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V2_GP_REGS_OFFS_NUM 31
+/* enum: A magic value hinting that the value in this register at the time of
+ * the failure has likely been lost.
+ */
+/* MC_CMD_GET_ASSERTS_REG_NO_DATA 0xda7a1057 */
+/* Failing thread address */
+#define MC_CMD_GET_ASSERTS_OUT_V2_THREAD_OFFS_OFST 132
+#define MC_CMD_GET_ASSERTS_OUT_V2_THREAD_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V2_RESERVED_OFST 136
+#define MC_CMD_GET_ASSERTS_OUT_V2_RESERVED_LEN 4
+/* Saved Special Function Registers */
+#define MC_CMD_GET_ASSERTS_OUT_V2_SF_REGS_OFFS_OFST 136
+#define MC_CMD_GET_ASSERTS_OUT_V2_SF_REGS_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V2_SF_REGS_OFFS_NUM 26
+
+/* MC_CMD_GET_ASSERTS_OUT_V3 msgresponse: Extended response with asserted
+ * firmware version information
+ */
+#define MC_CMD_GET_ASSERTS_OUT_V3_LEN 360
+/* Assertion status flag. */
+#define MC_CMD_GET_ASSERTS_OUT_V3_GLOBAL_FLAGS_OFST 0
+#define MC_CMD_GET_ASSERTS_OUT_V3_GLOBAL_FLAGS_LEN 4
+/* enum: No assertions have failed. */
+/* MC_CMD_GET_ASSERTS_FLAGS_NO_FAILS 0x1 */
+/* enum: A system-level assertion has failed. */
+/* MC_CMD_GET_ASSERTS_FLAGS_SYS_FAIL 0x2 */
+/* enum: A thread-level assertion has failed. */
+/* MC_CMD_GET_ASSERTS_FLAGS_THR_FAIL 0x3 */
+/* enum: The system was reset by the watchdog. */
+/* MC_CMD_GET_ASSERTS_FLAGS_WDOG_FIRED 0x4 */
+/* enum: An illegal address trap stopped the system (huntington and later) */
+/* MC_CMD_GET_ASSERTS_FLAGS_ADDR_TRAP 0x5 */
+/* Failing PC value */
+#define MC_CMD_GET_ASSERTS_OUT_V3_SAVED_PC_OFFS_OFST 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_SAVED_PC_OFFS_LEN 4
+/* Saved GP regs */
+#define MC_CMD_GET_ASSERTS_OUT_V3_GP_REGS_OFFS_OFST 8
+#define MC_CMD_GET_ASSERTS_OUT_V3_GP_REGS_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_GP_REGS_OFFS_NUM 31
+/* enum: A magic value hinting that the value in this register at the time of
+ * the failure has likely been lost.
+ */
+/* MC_CMD_GET_ASSERTS_REG_NO_DATA 0xda7a1057 */
+/* Failing thread address */
+#define MC_CMD_GET_ASSERTS_OUT_V3_THREAD_OFFS_OFST 132
+#define MC_CMD_GET_ASSERTS_OUT_V3_THREAD_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_RESERVED_OFST 136
+#define MC_CMD_GET_ASSERTS_OUT_V3_RESERVED_LEN 4
+/* Saved Special Function Registers */
+#define MC_CMD_GET_ASSERTS_OUT_V3_SF_REGS_OFFS_OFST 136
+#define MC_CMD_GET_ASSERTS_OUT_V3_SF_REGS_OFFS_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_SF_REGS_OFFS_NUM 26
+/* MC firmware unique build ID (as binary SHA-1 value) */
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_ID_OFST 240
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_ID_LEN 20
+/* MC firmware build date (as Unix timestamp) */
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_OFST 260
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LEN 8
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LO_OFST 260
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LO_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LO_LBN 2080
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_LO_WIDTH 32
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_HI_OFST 264
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_HI_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_HI_LBN 2112
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_TIMESTAMP_HI_WIDTH 32
+/* MC firmware version number */
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_OFST 268
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LEN 8
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LO_OFST 268
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LO_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LO_LBN 2144
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_LO_WIDTH 32
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_HI_OFST 272
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_HI_LEN 4
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_HI_LBN 2176
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_VERSION_HI_WIDTH 32
+/* MC firmware security level */
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_SECURITY_LEVEL_OFST 276
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_SECURITY_LEVEL_LEN 4
+/* MC firmware extra version info (as null-terminated US-ASCII string) */
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_EXTRA_INFO_OFST 280
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_EXTRA_INFO_LEN 16
+/* MC firmware build name (as null-terminated US-ASCII string) */
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_NAME_OFST 296
+#define MC_CMD_GET_ASSERTS_OUT_V3_MC_FW_BUILD_NAME_LEN 64
+
+/***********************************/
+/* MC_CMD_LOG_CTRL
+ * Configure the output stream for log events such as link state changes,
+ * sensor notifications and MCDI completions
+ */
+#define MC_CMD_LOG_CTRL 0x7
+#define MC_CMD_LOG_CTRL_MSGSET 0x7
+
+/* MC_CMD_LOG_CTRL_IN msgrequest */
+#define MC_CMD_LOG_CTRL_IN_LEN 8
+/* Log destination */
+#define MC_CMD_LOG_CTRL_IN_LOG_DEST_OFST 0
+#define MC_CMD_LOG_CTRL_IN_LOG_DEST_LEN 4
+/* enum: UART. */
+#define MC_CMD_LOG_CTRL_IN_LOG_DEST_UART 0x1
+/* enum: Event queue. */
+#define MC_CMD_LOG_CTRL_IN_LOG_DEST_EVQ 0x2
+/* Legacy argument. Must be zero. */
+#define MC_CMD_LOG_CTRL_IN_LOG_DEST_EVQ_OFST 4
+#define MC_CMD_LOG_CTRL_IN_LOG_DEST_EVQ_LEN 4
+
+/* MC_CMD_LOG_CTRL_OUT msgresponse */
+#define MC_CMD_LOG_CTRL_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_GET_VERSION
+ * Get version information about adapter components.
+ */
+#define MC_CMD_GET_VERSION 0x8
+#define MC_CMD_GET_VERSION_MSGSET 0x8
+
+/* MC_CMD_GET_VERSION_IN msgrequest */
+#define MC_CMD_GET_VERSION_IN_LEN 0
+
+/* MC_CMD_GET_VERSION_EXT_IN msgrequest: Asks for the extended version */
+#define MC_CMD_GET_VERSION_EXT_IN_LEN 4
+/* placeholder, set to 0 */
+#define MC_CMD_GET_VERSION_EXT_IN_EXT_FLAGS_OFST 0
+#define MC_CMD_GET_VERSION_EXT_IN_EXT_FLAGS_LEN 4
+/* MC_CMD_GET_VERSION_V5_OUT msgresponse: Extended response providing bundle
+ * and board version information
+ */
+#define MC_CMD_GET_VERSION_V5_OUT_LEN 424
+/* MC_CMD_GET_VERSION_OUT_FIRMWARE_OFST 0 */
+/* MC_CMD_GET_VERSION_OUT_FIRMWARE_LEN 4 */
+/* Enum values, see field(s): */
+/* MC_CMD_GET_VERSION_V0_OUT/MC_CMD_GET_VERSION_OUT_FIRMWARE */
+#define MC_CMD_GET_VERSION_V5_OUT_PCOL_OFST 4
+#define MC_CMD_GET_VERSION_V5_OUT_PCOL_LEN 4
+/* 128bit mask of functions supported by the current firmware */
+#define MC_CMD_GET_VERSION_V5_OUT_SUPPORTED_FUNCS_OFST 8
+#define MC_CMD_GET_VERSION_V5_OUT_SUPPORTED_FUNCS_LEN 16
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_OFST 24
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_LEN 8
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_LO_OFST 24
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_LO_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_LO_LBN 192
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_LO_WIDTH 32
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_HI_OFST 28
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_HI_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_HI_LBN 224
+#define MC_CMD_GET_VERSION_V5_OUT_VERSION_HI_WIDTH 32
+/* extra info */
+#define MC_CMD_GET_VERSION_V5_OUT_EXTRA_OFST 32
+#define MC_CMD_GET_VERSION_V5_OUT_EXTRA_LEN 16
+/* Flags indicating which extended fields are valid */
+#define MC_CMD_GET_VERSION_V5_OUT_FLAGS_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_FLAGS_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_EXT_INFO_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_EXT_INFO_PRESENT_LBN 0
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_EXT_INFO_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_EXT_INFO_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_EXT_INFO_PRESENT_LBN 1
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_EXT_INFO_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_CMC_EXT_INFO_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_CMC_EXT_INFO_PRESENT_LBN 2
+#define MC_CMD_GET_VERSION_V5_OUT_CMC_EXT_INFO_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_EXT_INFO_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_EXT_INFO_PRESENT_LBN 3
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_EXT_INFO_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_EXT_INFO_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_EXT_INFO_PRESENT_LBN 4
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_EXT_INFO_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_HW_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_HW_VERSION_PRESENT_LBN 5
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_HW_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_FW_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_FW_VERSION_PRESENT_LBN 6
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_FW_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_BOOT_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_BOOT_VERSION_PRESENT_LBN 7
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_BOOT_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_UBOOT_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_UBOOT_VERSION_PRESENT_LBN 8
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_UBOOT_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION_PRESENT_LBN 9
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION_PRESENT_LBN 10
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_VERSION_PRESENT_LBN 11
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_VERSION_PRESENT_LBN 12
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_VERSION_PRESENT_WIDTH 1
+#define MC_CMD_GET_VERSION_V5_OUT_BUNDLE_VERSION_PRESENT_OFST 48
+#define MC_CMD_GET_VERSION_V5_OUT_BUNDLE_VERSION_PRESENT_LBN 13
+#define MC_CMD_GET_VERSION_V5_OUT_BUNDLE_VERSION_PRESENT_WIDTH 1
+/* MC firmware unique build ID (as binary SHA-1 value) */
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_BUILD_ID_OFST 52
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_BUILD_ID_LEN 20
+/* MC firmware security level */
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_SECURITY_LEVEL_OFST 72
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_SECURITY_LEVEL_LEN 4
+/* MC firmware build name (as null-terminated US-ASCII string) */
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_BUILD_NAME_OFST 76
+#define MC_CMD_GET_VERSION_V5_OUT_MCFW_BUILD_NAME_LEN 64
+/* The SUC firmware version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_VERSION_OFST 140
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_VERSION_NUM 4
+/* SUC firmware build date (as 64-bit Unix timestamp) */
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_OFST 156
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_LEN 8
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_LO_OFST 156
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_LO_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_LO_LBN 1248
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_LO_WIDTH 32
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_HI_OFST 160
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_HI_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_HI_LBN 1280
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_BUILD_DATE_HI_WIDTH 32
+/* The ID of the SUC chip. This is specific to the platform but typically
+ * indicates family, memory sizes etc. See SF-116728-SW for further details.
+ */
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_CHIP_ID_OFST 164
+#define MC_CMD_GET_VERSION_V5_OUT_SUCFW_CHIP_ID_LEN 4
+/* The CMC firmware version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_VERSION_OFST 168
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_VERSION_NUM 4
+/* CMC firmware build date (as 64-bit Unix timestamp) */
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_OFST 184
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_LEN 8
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_LO_OFST 184
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_LO_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_LO_LBN 1472
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_LO_WIDTH 32
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_HI_OFST 188
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_HI_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_HI_LBN 1504
+#define MC_CMD_GET_VERSION_V5_OUT_CMCFW_BUILD_DATE_HI_WIDTH 32
+/* FPGA version as three numbers. On Riverhead based systems this field uses
+ * the same encoding as hardware version ID registers (MC_FPGA_BUILD_HWRD_REG):
+ * FPGA_VERSION[0]: x => Image H{x} FPGA_VERSION[1]: Revision letter (0 => A, 1
+ * => B, ...) FPGA_VERSION[2]: Sub-revision number
+ */
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_VERSION_OFST 192
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_VERSION_NUM 3
+/* Extra FPGA revision information (as null-terminated US-ASCII string) */
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_EXTRA_OFST 204
+#define MC_CMD_GET_VERSION_V5_OUT_FPGA_EXTRA_LEN 16
+/* Board name / adapter model (as null-terminated US-ASCII string) */
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_NAME_OFST 220
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_NAME_LEN 16
+/* Board revision number */
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_REVISION_OFST 236
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_REVISION_LEN 4
+/* Board serial number (as null-terminated US-ASCII string) */
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_SERIAL_OFST 240
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_SERIAL_LEN 64
+/* The version of the datapath hardware design as three number - a.b.c */
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_HW_VERSION_OFST 304
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_HW_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_HW_VERSION_NUM 3
+/* The version of the firmware library used to control the datapath as three
+ * number - a.b.c
+ */
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_FW_VERSION_OFST 316
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_FW_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_DATAPATH_FW_VERSION_NUM 3
+/* The SOC boot version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_BOOT_VERSION_OFST 328
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_BOOT_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_BOOT_VERSION_NUM 4
+/* The SOC uboot version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_UBOOT_VERSION_OFST 344
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_UBOOT_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_UBOOT_VERSION_NUM 4
+/* The SOC main rootfs version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION_OFST 360
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION_NUM 4
+/* The SOC recovery buildroot version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION_OFST 376
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION_NUM 4
+/* Board version as four numbers - a.b.c.d. BOARD_VERSION[0] duplicates the
+ * BOARD_REVISION field
+ */
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_VERSION_OFST 392
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_BOARD_VERSION_NUM 4
+/* Bundle version as four numbers - a.b.c.d */
+#define MC_CMD_GET_VERSION_V5_OUT_BUNDLE_VERSION_OFST 408
+#define MC_CMD_GET_VERSION_V5_OUT_BUNDLE_VERSION_LEN 4
+#define MC_CMD_GET_VERSION_V5_OUT_BUNDLE_VERSION_NUM 4
+
+/***********************************/
+/* MC_CMD_PTP
+ * Perform PTP operation
+ */
+#define MC_CMD_PTP 0xb
+#define MC_CMD_PTP_MSGSET 0xb
+
+/* MC_CMD_PTP_IN msgrequest */
+#define MC_CMD_PTP_IN_LEN 1
+/* PTP operation code */
+#define MC_CMD_PTP_IN_OP_OFST 0
+#define MC_CMD_PTP_IN_OP_LEN 1
+/* enum: Enable PTP packet timestamping operation. */
+#define MC_CMD_PTP_OP_ENABLE 0x1
+/* enum: Disable PTP packet timestamping operation. */
+#define MC_CMD_PTP_OP_DISABLE 0x2
+/* enum: Read the current NIC time. */
+#define MC_CMD_PTP_OP_READ_NIC_TIME 0x4
+/* enum: Get the current PTP status. Note that the clock frequency returned (in
+ * Hz) is rounded to the nearest MHz (e.g. 666000000 for 666666666).
+ */
+#define MC_CMD_PTP_OP_STATUS 0x5
+/* enum: Adjust the PTP NIC's time. */
+#define MC_CMD_PTP_OP_ADJUST 0x6
+/* enum: Reset some of the PTP related statistics */
+#define MC_CMD_PTP_OP_RESET_STATS 0xa
+/* enum: Debug operations to MC. */
+/* enum: Apply an offset to the NIC clock */
+#define MC_CMD_PTP_OP_CLOCK_OFFSET_ADJUST 0xe
+/* enum: Change the frequency correction applied to the NIC clock */
+#define MC_CMD_PTP_OP_CLOCK_FREQ_ADJUST 0xf
+/* enum: Enable the forwarding of PPS events to the host */
+#define MC_CMD_PTP_OP_PPS_ENABLE 0x15
+/* enum: Get the time format used by this NIC for PTP operations */
+#define MC_CMD_PTP_OP_GET_TIME_FORMAT 0x16
+/* enum: Get the clock attributes. NOTE- extended version of
+ * MC_CMD_PTP_OP_GET_TIME_FORMAT
+ */
+#define MC_CMD_PTP_OP_GET_ATTRIBUTES 0x16
+/* enum: Get corrections that should be applied to the various different
+ * timestamps
+ */
+#define MC_CMD_PTP_OP_GET_TIMESTAMP_CORRECTIONS 0x17
+/* enum: Subscribe to receive periodic time events indicating the current NIC
+ * time
+ */
+#define MC_CMD_PTP_OP_TIME_EVENT_SUBSCRIBE 0x18
+/* enum: Unsubscribe to stop receiving time events */
+#define MC_CMD_PTP_OP_TIME_EVENT_UNSUBSCRIBE 0x19
+/* enum: PPS based manfacturing tests. Requires PPS output to be looped to PPS
+ * input on the same NIC. Siena PTP adapters only.
+ */
+#define MC_CMD_PTP_OP_MANFTEST_PPS 0x1a
+/* enum: Set the PTP sync status. Status is used by firmware to report to event
+ * subscribers.
+ */
+#define MC_CMD_PTP_OP_SET_SYNC_STATUS 0x1b
+/* enum: Above this for future use. */
+#define MC_CMD_PTP_OP_MAX 0x1c
+
+/* MC_CMD_PTP_IN_ENABLE msgrequest */
+#define MC_CMD_PTP_IN_ENABLE_LEN 16
+#define MC_CMD_PTP_IN_CMD_OFST 0
+#define MC_CMD_PTP_IN_CMD_LEN 4
+#define MC_CMD_PTP_IN_PERIPH_ID_OFST 4
+#define MC_CMD_PTP_IN_PERIPH_ID_LEN 4
+/* Not used, initialize to 0. Events are always sent to function relative queue
+ * 0.
+ */
+#define MC_CMD_PTP_IN_ENABLE_QUEUE_OFST 8
+#define MC_CMD_PTP_IN_ENABLE_QUEUE_LEN 4
+/* PTP timestamping mode. Not used from Huntington onwards. */
+#define MC_CMD_PTP_IN_ENABLE_MODE_OFST 12
+#define MC_CMD_PTP_IN_ENABLE_MODE_LEN 4
+/* MC_CMD_PTP_IN_DISABLE msgrequest */
+#define MC_CMD_PTP_IN_DISABLE_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* MC_CMD_PTP_IN_READ_NIC_TIME msgrequest */
+#define MC_CMD_PTP_IN_READ_NIC_TIME_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+
+/* MC_CMD_PTP_IN_READ_NIC_TIME_V2 msgrequest */
+#define MC_CMD_PTP_IN_READ_NIC_TIME_V2_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+
+/* MC_CMD_PTP_IN_STATUS msgrequest */
+#define MC_CMD_PTP_IN_STATUS_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* MC_CMD_PTP_IN_ADJUST_V2 msgrequest */
+#define MC_CMD_PTP_IN_ADJUST_V2_LEN 28
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* Frequency adjustment 40 bit fixed point ns */
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_OFST 8
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_LEN 8
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_LO_OFST 8
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_LO_LEN 4
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_LO_LBN 64
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_LO_WIDTH 32
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_HI_OFST 12
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_HI_LEN 4
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_HI_LBN 96
+#define MC_CMD_PTP_IN_ADJUST_V2_FREQ_HI_WIDTH 32
+/* enum: Number of fractional bits in frequency adjustment */
+/* MC_CMD_PTP_IN_ADJUST_BITS 0x28 */
+/* enum: Number of fractional bits in frequency adjustment when FP44_FREQ_ADJ
+ * is indicated in the MC_CMD_PTP_OUT_GET_ATTRIBUTES command CAPABILITIES
+ * field.
+ */
+/* MC_CMD_PTP_IN_ADJUST_BITS_FP44 0x2c */
+/* Time adjustment in seconds */
+#define MC_CMD_PTP_IN_ADJUST_V2_SECONDS_OFST 16
+#define MC_CMD_PTP_IN_ADJUST_V2_SECONDS_LEN 4
+/* Time adjustment major value */
+#define MC_CMD_PTP_IN_ADJUST_V2_MAJOR_OFST 16
+#define MC_CMD_PTP_IN_ADJUST_V2_MAJOR_LEN 4
+/* Time adjustment in nanoseconds */
+#define MC_CMD_PTP_IN_ADJUST_V2_NANOSECONDS_OFST 20
+#define MC_CMD_PTP_IN_ADJUST_V2_NANOSECONDS_LEN 4
+/* Time adjustment minor value */
+#define MC_CMD_PTP_IN_ADJUST_V2_MINOR_OFST 20
+#define MC_CMD_PTP_IN_ADJUST_V2_MINOR_LEN 4
+/* Upper 32bits of major time offset adjustment */
+#define MC_CMD_PTP_IN_ADJUST_V2_MAJOR_HI_OFST 24
+#define MC_CMD_PTP_IN_ADJUST_V2_MAJOR_HI_LEN 4
+/* MC_CMD_PTP_IN_RESET_STATS msgrequest: Reset PTP statistics */
+#define MC_CMD_PTP_IN_RESET_STATS_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* MC_CMD_PTP_IN_PPS_ENABLE msgrequest */
+#define MC_CMD_PTP_IN_PPS_ENABLE_LEN 12
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* Enable or disable */
+#define MC_CMD_PTP_IN_PPS_ENABLE_OP_OFST 4
+#define MC_CMD_PTP_IN_PPS_ENABLE_OP_LEN 4
+/* enum: Enable */
+#define MC_CMD_PTP_ENABLE_PPS 0x0
+/* enum: Disable */
+#define MC_CMD_PTP_DISABLE_PPS 0x1
+/* Not used, initialize to 0. Events are always sent to function relative queue
+ * 0.
+ */
+#define MC_CMD_PTP_IN_PPS_ENABLE_QUEUE_ID_OFST 8
+#define MC_CMD_PTP_IN_PPS_ENABLE_QUEUE_ID_LEN 4
+
+/* MC_CMD_PTP_IN_GET_TIME_FORMAT msgrequest */
+#define MC_CMD_PTP_IN_GET_TIME_FORMAT_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+
+/* MC_CMD_PTP_IN_GET_ATTRIBUTES msgrequest */
+#define MC_CMD_PTP_IN_GET_ATTRIBUTES_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+
+/* MC_CMD_PTP_IN_GET_TIMESTAMP_CORRECTIONS msgrequest */
+#define MC_CMD_PTP_IN_GET_TIMESTAMP_CORRECTIONS_LEN 8
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+
+/* MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE msgrequest */
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_LEN 12
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* Original field containing queue ID. Now extended to include flags. */
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_OFST 8
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_LEN 4
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID_OFST 8
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID_LBN 0
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_QUEUE_ID_WIDTH 16
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS_OFST 8
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS_LBN 31
+#define MC_CMD_PTP_IN_TIME_EVENT_SUBSCRIBE_REPORT_SYNC_STATUS_WIDTH 1
+
+/* MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE msgrequest */
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_LEN 16
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* Unsubscribe options */
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_CONTROL_OFST 8
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_CONTROL_LEN 4
+/* enum: Unsubscribe a single queue */
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_SINGLE 0x0
+/* enum: Unsubscribe all queues */
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_ALL 0x1
+/* Event queue ID */
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_QUEUE_OFST 12
+#define MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_QUEUE_LEN 4
+/* MC_CMD_PTP_IN_SET_SYNC_STATUS msgrequest */
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_LEN 24
+/* MC_CMD_PTP_IN_CMD_OFST 0 */
+/* MC_CMD_PTP_IN_CMD_LEN 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_OFST 4 */
+/* MC_CMD_PTP_IN_PERIPH_ID_LEN 4 */
+/* NIC - Host System Clock Synchronization status */
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_STATUS_OFST 8
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_STATUS_LEN 4
+/* enum: Host System clock and NIC clock are not in sync */
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_NOT_IN_SYNC 0x0
+/* enum: Host System clock and NIC clock are synchronized */
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_IN_SYNC 0x1
+/* If synchronized, number of seconds until clocks should be considered to be
+ * no longer in sync.
+ */
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_TIMEOUT_OFST 12
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_TIMEOUT_LEN 4
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_RESERVED0_OFST 16
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_RESERVED0_LEN 4
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_RESERVED1_OFST 20
+#define MC_CMD_PTP_IN_SET_SYNC_STATUS_RESERVED1_LEN 4
+
+/* MC_CMD_PTP_OUT msgresponse */
+#define MC_CMD_PTP_OUT_LEN 0
+/* MC_CMD_PTP_OUT_TIME_EVENT_SUBSCRIBE msgresponse */
+#define MC_CMD_PTP_OUT_TIME_EVENT_SUBSCRIBE_LEN 0
+
+/* MC_CMD_PTP_OUT_TIME_EVENT_UNSUBSCRIBE msgresponse */
+#define MC_CMD_PTP_OUT_TIME_EVENT_UNSUBSCRIBE_LEN 0
+
+/* MC_CMD_PTP_OUT_READ_NIC_TIME msgresponse */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_LEN 8
+/* MC_CMD_PTP_OUT_READ_NIC_TIME_V2 msgresponse */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_LEN 12
+/* Value of seconds timestamp */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_SECONDS_OFST 0
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_SECONDS_LEN 4
+/* Timestamp major value */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_MAJOR_OFST 0
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_MAJOR_LEN 4
+/* Value of nanoseconds timestamp */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_NANOSECONDS_OFST 4
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_NANOSECONDS_LEN 4
+/* Timestamp minor value */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_MINOR_OFST 4
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_MINOR_LEN 4
+/* Upper 32bits of major timestamp value */
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_MAJOR_HI_OFST 8
+#define MC_CMD_PTP_OUT_READ_NIC_TIME_V2_MAJOR_HI_LEN 4
+
+/* MC_CMD_PTP_OUT_STATUS msgresponse */
+#define MC_CMD_PTP_OUT_STATUS_LEN 64
+/* Frequency of NIC's hardware clock */
+#define MC_CMD_PTP_OUT_STATUS_CLOCK_FREQ_OFST 0
+#define MC_CMD_PTP_OUT_STATUS_CLOCK_FREQ_LEN 4
+/* Number of packets transmitted and timestamped */
+#define MC_CMD_PTP_OUT_STATUS_STATS_TX_OFST 4
+#define MC_CMD_PTP_OUT_STATUS_STATS_TX_LEN 4
+/* Number of packets received and timestamped */
+#define MC_CMD_PTP_OUT_STATUS_STATS_RX_OFST 8
+#define MC_CMD_PTP_OUT_STATUS_STATS_RX_LEN 4
+/* Number of packets timestamped by the FPGA */
+#define MC_CMD_PTP_OUT_STATUS_STATS_TS_OFST 12
+#define MC_CMD_PTP_OUT_STATUS_STATS_TS_LEN 4
+/* Number of packets filter matched */
+#define MC_CMD_PTP_OUT_STATUS_STATS_FM_OFST 16
+#define MC_CMD_PTP_OUT_STATUS_STATS_FM_LEN 4
+/* Number of packets not filter matched */
+#define MC_CMD_PTP_OUT_STATUS_STATS_NFM_OFST 20
+#define MC_CMD_PTP_OUT_STATUS_STATS_NFM_LEN 4
+/* Number of PPS overflows (noise on input?) */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFLOW_OFST 24
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFLOW_LEN 4
+/* Number of PPS bad periods */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_BAD_OFST 28
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_BAD_LEN 4
+/* Minimum period of PPS pulse in nanoseconds */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_MIN_OFST 32
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_MIN_LEN 4
+/* Maximum period of PPS pulse in nanoseconds */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_MAX_OFST 36
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_MAX_LEN 4
+/* Last period of PPS pulse in nanoseconds */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_LAST_OFST 40
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_LAST_LEN 4
+/* Mean period of PPS pulse in nanoseconds */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_MEAN_OFST 44
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_PER_MEAN_LEN 4
+/* Minimum offset of PPS pulse in nanoseconds (signed) */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_MIN_OFST 48
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_MIN_LEN 4
+/* Maximum offset of PPS pulse in nanoseconds (signed) */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_MAX_OFST 52
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_MAX_LEN 4
+/* Last offset of PPS pulse in nanoseconds (signed) */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_LAST_OFST 56
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_LAST_LEN 4
+/* Mean offset of PPS pulse in nanoseconds (signed) */
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_MEAN_OFST 60
+#define MC_CMD_PTP_OUT_STATUS_STATS_PPS_OFF_MEAN_LEN 4
+/* MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2 msgresponse */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_LEN 40
+/* Time format required/used by for this NIC. Applies to all PTP MCDI
+ * operations that pass times between the host and firmware. If this operation
+ * is not supported (older firmware) a format of seconds and nanoseconds should
+ * be assumed.
+ */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_TIME_FORMAT_OFST 0
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_TIME_FORMAT_LEN 4
+/* enum: Times are in seconds and nanoseconds */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_SECONDS_NANOSECONDS 0x0
+/* enum: Major register has units of 16 second per tick, minor 8 ns per tick */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_16SECONDS_8NANOSECONDS 0x1
+/* enum: Major register has units of seconds, minor 2^-27s per tick */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_SECONDS_27FRACTION 0x2
+/* enum: Major register units are seconds, minor units are quarter nanoseconds
+ */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_SECONDS_QTR_NANOSECONDS 0x3
+/* Minimum acceptable value for a corrected synchronization timeset. When
+ * comparing host and NIC clock times, the MC returns a set of samples that
+ * contain the host start and end time, the MC time when the host start was
+ * detected and the time the MC waited between reading the time and detecting
+ * the host end. The corrected sync window is the difference between the host
+ * end and start times minus the time that the MC waited for host end.
+ */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_SYNC_WINDOW_MIN_OFST 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_SYNC_WINDOW_MIN_LEN 4
+/* Various PTP capabilities */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_CAPABILITIES_OFST 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_CAPABILITIES_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_REPORT_SYNC_STATUS_OFST 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_REPORT_SYNC_STATUS_LBN 0
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_REPORT_SYNC_STATUS_WIDTH 1
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RX_TSTAMP_OOB_OFST 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RX_TSTAMP_OOB_LBN 1
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RX_TSTAMP_OOB_WIDTH 1
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_64BIT_SECONDS_OFST 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_64BIT_SECONDS_LBN 2
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_64BIT_SECONDS_WIDTH 1
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FP44_FREQ_ADJ_OFST 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FP44_FREQ_ADJ_LBN 3
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FP44_FREQ_ADJ_WIDTH 1
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RESERVED0_OFST 12
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RESERVED0_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RESERVED1_OFST 16
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RESERVED1_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RESERVED2_OFST 20
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_RESERVED2_LEN 4
+/* Minimum supported value for the FREQ field in
+ * MC_CMD_PTP/MC_CMD_PTP_IN_ADJUST and
+ * MC_CMD_PTP/MC_CMD_PTP_IN_CLOCK_FREQ_ADJUST message requests. If this message
+ * response is not supported a value of -0.1 ns should be assumed, which is
+ * equivalent to a -10% adjustment.
+ */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_OFST 24
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_LEN 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_LO_OFST 24
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_LO_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_LO_LBN 192
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_LO_WIDTH 32
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_HI_OFST 28
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_HI_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_HI_LBN 224
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MIN_HI_WIDTH 32
+/* Maximum supported value for the FREQ field in
+ * MC_CMD_PTP/MC_CMD_PTP_IN_ADJUST and
+ * MC_CMD_PTP/MC_CMD_PTP_IN_CLOCK_FREQ_ADJUST message requests. If this message
+ * response is not supported a value of 0.1 ns should be assumed, which is
+ * equivalent to a +10% adjustment.
+ */
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_OFST 32
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_LEN 8
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_LO_OFST 32
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_LO_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_LO_LBN 256
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_LO_WIDTH 32
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_HI_OFST 36
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_HI_LEN 4
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_HI_LBN 288
+#define MC_CMD_PTP_OUT_GET_ATTRIBUTES_V2_FREQ_ADJ_MAX_HI_WIDTH 32
+/* MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2 msgresponse */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_LEN 24
+/* Uncorrected error on PTP transmit timestamps in NIC clock format */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PTP_TX_OFST 0
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PTP_TX_LEN 4
+/* Uncorrected error on PTP receive timestamps in NIC clock format */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PTP_RX_OFST 4
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PTP_RX_LEN 4
+/* Uncorrected error on PPS output in NIC clock format */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PPS_OUT_OFST 8
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PPS_OUT_LEN 4
+/* Uncorrected error on PPS input in NIC clock format */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PPS_IN_OFST 12
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_PPS_IN_LEN 4
+/* Uncorrected error on non-PTP transmit timestamps in NIC clock format */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_GENERAL_TX_OFST 16
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_GENERAL_TX_LEN 4
+/* Uncorrected error on non-PTP receive timestamps in NIC clock format */
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_GENERAL_RX_OFST 20
+#define MC_CMD_PTP_OUT_GET_TIMESTAMP_CORRECTIONS_V2_GENERAL_RX_LEN 4
+/* MC_CMD_PTP_OUT_SET_SYNC_STATUS msgresponse */
+#define MC_CMD_PTP_OUT_SET_SYNC_STATUS_LEN 0
+/***********************************/
+/* MC_CMD_GET_BOARD_CFG
+ * Returns the MC firmware configuration structure.
+ */
+#define MC_CMD_GET_BOARD_CFG 0x18
+#define MC_CMD_GET_BOARD_CFG_MSGSET 0x18
+
+/* MC_CMD_GET_BOARD_CFG_IN msgrequest */
+#define MC_CMD_GET_BOARD_CFG_IN_LEN 0
+
+/* MC_CMD_GET_BOARD_CFG_OUT msgresponse */
+#define MC_CMD_GET_BOARD_CFG_OUT_LENMIN 96
+#define MC_CMD_GET_BOARD_CFG_OUT_LENMAX 136
+#define MC_CMD_GET_BOARD_CFG_OUT_LENMAX_MCDI2 136
+#define MC_CMD_GET_BOARD_CFG_OUT_LEN(num) (72 + 2 * (num))
+#define MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_NUM(len) (((len) - 72) / 2)
+#define MC_CMD_GET_BOARD_CFG_OUT_BOARD_TYPE_OFST 0
+#define MC_CMD_GET_BOARD_CFG_OUT_BOARD_TYPE_LEN 4
+#define MC_CMD_GET_BOARD_CFG_OUT_BOARD_NAME_OFST 4
+#define MC_CMD_GET_BOARD_CFG_OUT_BOARD_NAME_LEN 32
+/* Capabilities for Siena Port0 (see struct MC_CMD_CAPABILITIES). Unused on
+ * EF10 and later (use MC_CMD_GET_CAPABILITIES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_CAPABILITIES_PORT0_OFST 36
+#define MC_CMD_GET_BOARD_CFG_OUT_CAPABILITIES_PORT0_LEN 4
+/* Capabilities for Siena Port1 (see struct MC_CMD_CAPABILITIES). Unused on
+ * EF10 and later (use MC_CMD_GET_CAPABILITIES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_CAPABILITIES_PORT1_OFST 40
+#define MC_CMD_GET_BOARD_CFG_OUT_CAPABILITIES_PORT1_LEN 4
+/* Base MAC address for Siena Port0. Unused on EF10 and later (use
+ * MC_CMD_GET_MAC_ADDRESSES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT0_OFST 44
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT0_LEN 6
+/* Base MAC address for Siena Port1. Unused on EF10 and later (use
+ * MC_CMD_GET_MAC_ADDRESSES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT1_OFST 50
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT1_LEN 6
+/* Size of MAC address pool for Siena Port0. Unused on EF10 and later (use
+ * MC_CMD_GET_MAC_ADDRESSES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_COUNT_PORT0_OFST 56
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_COUNT_PORT0_LEN 4
+/* Size of MAC address pool for Siena Port1. Unused on EF10 and later (use
+ * MC_CMD_GET_MAC_ADDRESSES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_COUNT_PORT1_OFST 60
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_COUNT_PORT1_LEN 4
+/* Increment between addresses in MAC address pool for Siena Port0. Unused on
+ * EF10 and later (use MC_CMD_GET_MAC_ADDRESSES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_STRIDE_PORT0_OFST 64
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_STRIDE_PORT0_LEN 4
+/* Increment between addresses in MAC address pool for Siena Port1. Unused on
+ * EF10 and later (use MC_CMD_GET_MAC_ADDRESSES).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_STRIDE_PORT1_OFST 68
+#define MC_CMD_GET_BOARD_CFG_OUT_MAC_STRIDE_PORT1_LEN 4
+/* Siena only. This field contains a 16-bit value for each of the types of
+ * NVRAM area. The values are defined in the firmware/mc/platform/.c file for a
+ * specific board type, but otherwise have no meaning to the MC; they are used
+ * by the driver to manage selection of appropriate firmware updates. Unused on
+ * EF10 and later (use MC_CMD_NVRAM_METADATA).
+ */
+#define MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_OFST 72
+#define MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_LEN 2
+#define MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MINNUM 12
+#define MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MAXNUM 32
+#define MC_CMD_GET_BOARD_CFG_OUT_FW_SUBTYPE_LIST_MAXNUM_MCDI2 32
+/***********************************/
+/* MC_CMD_DRV_ATTACH
+ * Inform MCPU that this port is managed on the host (i.e. driver active). For
+ * Huntington, also request the preferred datapath firmware to use if possible
+ * (it may not be possible for this request to be fulfilled; the driver must
+ * issue a subsequent MC_CMD_GET_CAPABILITIES command to determine which
+ * features are actually available). The FIRMWARE_ID field is ignored by older
+ * platforms.
+ */
+#define MC_CMD_DRV_ATTACH 0x1c
+#define MC_CMD_DRV_ATTACH_MSGSET 0x1c
+
+/* MC_CMD_DRV_ATTACH_IN msgrequest */
+#define MC_CMD_DRV_ATTACH_IN_LEN 12
+/* new state to set if UPDATE=1 */
+#define MC_CMD_DRV_ATTACH_IN_NEW_STATE_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_NEW_STATE_LEN 4
+#define MC_CMD_DRV_ATTACH_OFST 0
+#define MC_CMD_DRV_ATTACH_LBN 0
+#define MC_CMD_DRV_ATTACH_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_ATTACH_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_ATTACH_LBN 0
+#define MC_CMD_DRV_ATTACH_IN_ATTACH_WIDTH 1
+#define MC_CMD_DRV_PREBOOT_OFST 0
+#define MC_CMD_DRV_PREBOOT_LBN 1
+#define MC_CMD_DRV_PREBOOT_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_PREBOOT_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_PREBOOT_LBN 1
+#define MC_CMD_DRV_ATTACH_IN_PREBOOT_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_SUBVARIANT_AWARE_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_SUBVARIANT_AWARE_LBN 2
+#define MC_CMD_DRV_ATTACH_IN_SUBVARIANT_AWARE_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_WANT_VI_SPREADING_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_WANT_VI_SPREADING_LBN 3
+#define MC_CMD_DRV_ATTACH_IN_WANT_VI_SPREADING_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_WANT_V2_LINKCHANGES_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_WANT_V2_LINKCHANGES_LBN 4
+#define MC_CMD_DRV_ATTACH_IN_WANT_V2_LINKCHANGES_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_WANT_RX_VI_SPREADING_INHIBIT_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_WANT_RX_VI_SPREADING_INHIBIT_LBN 5
+#define MC_CMD_DRV_ATTACH_IN_WANT_RX_VI_SPREADING_INHIBIT_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_WANT_TX_ONLY_SPREADING_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_WANT_TX_ONLY_SPREADING_LBN 5
+#define MC_CMD_DRV_ATTACH_IN_WANT_TX_ONLY_SPREADING_WIDTH 1
+/* 1 to set new state, or 0 to just report the existing state */
+#define MC_CMD_DRV_ATTACH_IN_UPDATE_OFST 4
+#define MC_CMD_DRV_ATTACH_IN_UPDATE_LEN 4
+/* preferred datapath firmware (for Huntington; ignored for Siena) */
+#define MC_CMD_DRV_ATTACH_IN_FIRMWARE_ID_OFST 8
+#define MC_CMD_DRV_ATTACH_IN_FIRMWARE_ID_LEN 4
+/* enum: Prefer to use full featured firmware */
+#define MC_CMD_FW_FULL_FEATURED 0x0
+/* enum: Prefer to use firmware with fewer features but lower latency */
+#define MC_CMD_FW_LOW_LATENCY 0x1
+/* enum: Prefer to use firmware for SolarCapture packed stream mode */
+#define MC_CMD_FW_PACKED_STREAM 0x2
+/* enum: Prefer to use firmware with fewer features and simpler TX event
+ * batching but higher TX packet rate
+ */
+#define MC_CMD_FW_HIGH_TX_RATE 0x3
+/* enum: Reserved value */
+#define MC_CMD_FW_PACKED_STREAM_HASH_MODE_1 0x4
+/* enum: Prefer to use firmware with additional "rules engine" filtering
+ * support
+ */
+#define MC_CMD_FW_RULES_ENGINE 0x5
+/* enum: Prefer to use firmware with additional DPDK support */
+#define MC_CMD_FW_DPDK 0x6
+/* enum: Prefer to use "l3xudp" custom datapath firmware (see SF-119495-PD and
+ * bug69716)
+ */
+#define MC_CMD_FW_L3XUDP 0x7
+/* enum: Requests that the MC keep whatever datapath firmware is currently
+ * running. It's used for test purposes, where we want to be able to shmboot
+ * special test firmware variants. This option is only recognised in eftest
+ * (i.e. non-production) builds.
+ */
+#define MC_CMD_FW_KEEP_CURRENT_EFTEST_ONLY 0xfffffffe
+/* enum: Only this option is allowed for non-admin functions */
+#define MC_CMD_FW_DONT_CARE 0xffffffff
+
+/* MC_CMD_DRV_ATTACH_IN_V2 msgrequest: Updated DRV_ATTACH to include driver
+ * version
+ */
+#define MC_CMD_DRV_ATTACH_IN_V2_LEN 32
+/* new state to set if UPDATE=1 */
+#define MC_CMD_DRV_ATTACH_IN_V2_NEW_STATE_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_NEW_STATE_LEN 4
+/* MC_CMD_DRV_ATTACH_OFST 0 */
+/* MC_CMD_DRV_ATTACH_LBN 0 */
+/* MC_CMD_DRV_ATTACH_WIDTH 1 */
+#define MC_CMD_DRV_ATTACH_IN_V2_ATTACH_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_ATTACH_LBN 0
+#define MC_CMD_DRV_ATTACH_IN_V2_ATTACH_WIDTH 1
+/* MC_CMD_DRV_PREBOOT_OFST 0 */
+/* MC_CMD_DRV_PREBOOT_LBN 1 */
+/* MC_CMD_DRV_PREBOOT_WIDTH 1 */
+#define MC_CMD_DRV_ATTACH_IN_V2_PREBOOT_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_PREBOOT_LBN 1
+#define MC_CMD_DRV_ATTACH_IN_V2_PREBOOT_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_V2_SUBVARIANT_AWARE_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_SUBVARIANT_AWARE_LBN 2
+#define MC_CMD_DRV_ATTACH_IN_V2_SUBVARIANT_AWARE_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_VI_SPREADING_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_VI_SPREADING_LBN 3
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_VI_SPREADING_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_LBN 4
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_V2_LINKCHANGES_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_RX_VI_SPREADING_INHIBIT_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_RX_VI_SPREADING_INHIBIT_LBN 5
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_RX_VI_SPREADING_INHIBIT_WIDTH 1
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_TX_ONLY_SPREADING_OFST 0
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_TX_ONLY_SPREADING_LBN 5
+#define MC_CMD_DRV_ATTACH_IN_V2_WANT_TX_ONLY_SPREADING_WIDTH 1
+/* 1 to set new state, or 0 to just report the existing state */
+#define MC_CMD_DRV_ATTACH_IN_V2_UPDATE_OFST 4
+#define MC_CMD_DRV_ATTACH_IN_V2_UPDATE_LEN 4
+/* preferred datapath firmware (for Huntington; ignored for Siena) */
+#define MC_CMD_DRV_ATTACH_IN_V2_FIRMWARE_ID_OFST 8
+#define MC_CMD_DRV_ATTACH_IN_V2_FIRMWARE_ID_LEN 4
+/* enum: Prefer to use full featured firmware */
+/* MC_CMD_FW_FULL_FEATURED 0x0 */
+/* enum: Prefer to use firmware with fewer features but lower latency */
+/* MC_CMD_FW_LOW_LATENCY 0x1 */
+/* enum: Prefer to use firmware for SolarCapture packed stream mode */
+/* MC_CMD_FW_PACKED_STREAM 0x2 */
+/* enum: Prefer to use firmware with fewer features and simpler TX event
+ * batching but higher TX packet rate
+ */
+/* MC_CMD_FW_HIGH_TX_RATE 0x3 */
+/* enum: Reserved value */
+/* MC_CMD_FW_PACKED_STREAM_HASH_MODE_1 0x4 */
+/* enum: Prefer to use firmware with additional "rules engine" filtering
+ * support
+ */
+/* MC_CMD_FW_RULES_ENGINE 0x5 */
+/* enum: Prefer to use firmware with additional DPDK support */
+/* MC_CMD_FW_DPDK 0x6 */
+/* enum: Prefer to use "l3xudp" custom datapath firmware (see SF-119495-PD and
+ * bug69716)
+ */
+/* MC_CMD_FW_L3XUDP 0x7 */
+/* enum: Requests that the MC keep whatever datapath firmware is currently
+ * running. It's used for test purposes, where we want to be able to shmboot
+ * special test firmware variants. This option is only recognised in eftest
+ * (i.e. non-production) builds.
+ */
+/* MC_CMD_FW_KEEP_CURRENT_EFTEST_ONLY 0xfffffffe */
+/* enum: Only this option is allowed for non-admin functions */
+/* MC_CMD_FW_DONT_CARE 0xffffffff */
+/* Version of the driver to be reported by management protocols (e.g. NC-SI)
+ * handled by the NIC. This is a zero-terminated ASCII string.
+ */
+#define MC_CMD_DRV_ATTACH_IN_V2_DRIVER_VERSION_OFST 12
+#define MC_CMD_DRV_ATTACH_IN_V2_DRIVER_VERSION_LEN 20
+
+/* MC_CMD_DRV_ATTACH_OUT msgresponse */
+#define MC_CMD_DRV_ATTACH_OUT_LEN 4
+/* previous or existing state, see the bitmask at NEW_STATE */
+#define MC_CMD_DRV_ATTACH_OUT_OLD_STATE_OFST 0
+#define MC_CMD_DRV_ATTACH_OUT_OLD_STATE_LEN 4
+
+/* MC_CMD_DRV_ATTACH_EXT_OUT msgresponse */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_LEN 8
+/* previous or existing state, see the bitmask at NEW_STATE */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_OLD_STATE_OFST 0
+#define MC_CMD_DRV_ATTACH_EXT_OUT_OLD_STATE_LEN 4
+/* Flags associated with this function */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FUNC_FLAGS_OFST 4
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FUNC_FLAGS_LEN 4
+/* enum: Labels the lowest-numbered function visible to the OS */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_PRIMARY 0x0
+/* enum: The function can control the link state of the physical port it is
+ * bound to.
+ */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_LINKCTRL 0x1
+/* enum: The function can perform privileged operations */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED 0x2
+/* enum: The function does not have an active port associated with it. The port
+ * refers to the Sorrento external FPGA port.
+ */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_NO_ACTIVE_PORT 0x3
+/* enum: If set, indicates that VI spreading is currently enabled. Will always
+ * indicate the current state, regardless of the value in the WANT_VI_SPREADING
+ * input.
+ */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_VI_SPREADING_ENABLED 0x4
+/* enum: Used during development only. Should no longer be used. */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_RX_VI_SPREADING_INHIBITED 0x5
+/* enum: If set, indicates that TX only spreading is enabled. Even-numbered
+ * TXQs will use one engine, and odd-numbered TXQs will use the other. This
+ * also has the effect that only even-numbered RXQs will receive traffic.
+ */
+#define MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TX_ONLY_VI_SPREADING_ENABLED 0x5
+/***********************************/
+/* MC_CMD_PORT_RESET
+ * Generic per-port reset. There is no equivalent for per-board reset. Locks
+ * required: None; Return code: 0, ETIME. NOTE: This command is deprecated -
+ * use MC_CMD_ENTITY_RESET instead.
+ */
+#define MC_CMD_PORT_RESET 0x20
+#define MC_CMD_PORT_RESET_MSGSET 0x20
+
+/* MC_CMD_PORT_RESET_IN msgrequest */
+#define MC_CMD_PORT_RESET_IN_LEN 0
+
+/* MC_CMD_PORT_RESET_OUT msgresponse */
+#define MC_CMD_PORT_RESET_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_ENTITY_RESET
+ * Generic per-resource reset. There is no equivalent for per-board reset.
+ * Locks required: None; Return code: 0, ETIME. NOTE: This command is an
+ * extended version of the deprecated MC_CMD_PORT_RESET with added fields.
+ */
+#define MC_CMD_ENTITY_RESET 0x20
+#define MC_CMD_ENTITY_RESET_MSGSET 0x20
+
+/* MC_CMD_ENTITY_RESET_IN msgrequest */
+#define MC_CMD_ENTITY_RESET_IN_LEN 4
+/* Optional flags field. Omitting this will perform a "legacy" reset action
+ * (TBD).
+ */
+#define MC_CMD_ENTITY_RESET_IN_FLAG_OFST 0
+#define MC_CMD_ENTITY_RESET_IN_FLAG_LEN 4
+#define MC_CMD_ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET_OFST 0
+#define MC_CMD_ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET_LBN 0
+#define MC_CMD_ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET_WIDTH 1
+
+/* MC_CMD_ENTITY_RESET_OUT msgresponse */
+#define MC_CMD_ENTITY_RESET_OUT_LEN 0
+/***********************************/
+/* MC_CMD_PUTS
+ * Copy the given ASCII string out onto UART and/or out of the network port.
+ */
+#define MC_CMD_PUTS 0x23
+#define MC_CMD_PUTS_MSGSET 0x23
+
+/* MC_CMD_PUTS_IN msgrequest */
+#define MC_CMD_PUTS_IN_LENMIN 13
+#define MC_CMD_PUTS_IN_LENMAX 252
+#define MC_CMD_PUTS_IN_LENMAX_MCDI2 1020
+#define MC_CMD_PUTS_IN_LEN(num) (12 + 1 * (num))
+#define MC_CMD_PUTS_IN_STRING_NUM(len) (((len) - 12) / 1)
+#define MC_CMD_PUTS_IN_DEST_OFST 0
+#define MC_CMD_PUTS_IN_DEST_LEN 4
+#define MC_CMD_PUTS_IN_UART_OFST 0
+#define MC_CMD_PUTS_IN_UART_LBN 0
+#define MC_CMD_PUTS_IN_UART_WIDTH 1
+#define MC_CMD_PUTS_IN_PORT_OFST 0
+#define MC_CMD_PUTS_IN_PORT_LBN 1
+#define MC_CMD_PUTS_IN_PORT_WIDTH 1
+#define MC_CMD_PUTS_IN_DHOST_OFST 4
+#define MC_CMD_PUTS_IN_DHOST_LEN 6
+#define MC_CMD_PUTS_IN_STRING_OFST 12
+#define MC_CMD_PUTS_IN_STRING_LEN 1
+#define MC_CMD_PUTS_IN_STRING_MINNUM 1
+#define MC_CMD_PUTS_IN_STRING_MAXNUM 240
+#define MC_CMD_PUTS_IN_STRING_MAXNUM_MCDI2 1008
+
+/* MC_CMD_PUTS_OUT msgresponse */
+#define MC_CMD_PUTS_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_GET_PHY_CFG
+ * Report PHY configuration. This guarantees to succeed even if the PHY is in a
+ * 'zombie' state. Locks required: None
+ */
+#define MC_CMD_GET_PHY_CFG 0x24
+#define MC_CMD_GET_PHY_CFG_MSGSET 0x24
+
+/* MC_CMD_GET_PHY_CFG_IN msgrequest */
+#define MC_CMD_GET_PHY_CFG_IN_LEN 0
+
+/* MC_CMD_GET_PHY_CFG_OUT msgresponse */
+#define MC_CMD_GET_PHY_CFG_OUT_LEN 72
+/* flags */
+#define MC_CMD_GET_PHY_CFG_OUT_FLAGS_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_FLAGS_LEN 4
+#define MC_CMD_GET_PHY_CFG_OUT_PRESENT_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_PRESENT_LBN 0
+#define MC_CMD_GET_PHY_CFG_OUT_PRESENT_WIDTH 1
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN 1
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_WIDTH 1
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_LBN 2
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_LONG_WIDTH 1
+#define MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_LBN 3
+#define MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_WIDTH 1
+#define MC_CMD_GET_PHY_CFG_OUT_POWEROFF_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_POWEROFF_LBN 4
+#define MC_CMD_GET_PHY_CFG_OUT_POWEROFF_WIDTH 1
+#define MC_CMD_GET_PHY_CFG_OUT_TXDIS_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_TXDIS_LBN 5
+#define MC_CMD_GET_PHY_CFG_OUT_TXDIS_WIDTH 1
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_OFST 0
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_LBN 6
+#define MC_CMD_GET_PHY_CFG_OUT_BIST_WIDTH 1
+/* ?? */
+#define MC_CMD_GET_PHY_CFG_OUT_TYPE_OFST 4
+#define MC_CMD_GET_PHY_CFG_OUT_TYPE_LEN 4
+/* Bitmask of supported capabilities */
+#define MC_CMD_GET_PHY_CFG_OUT_SUPPORTED_CAP_OFST 8
+#define MC_CMD_GET_PHY_CFG_OUT_SUPPORTED_CAP_LEN 4
+#define MC_CMD_PHY_CAP_10HDX_OFST 8
+#define MC_CMD_PHY_CAP_10HDX_LBN 1
+#define MC_CMD_PHY_CAP_10HDX_WIDTH 1
+#define MC_CMD_PHY_CAP_10FDX_OFST 8
+#define MC_CMD_PHY_CAP_10FDX_LBN 2
+#define MC_CMD_PHY_CAP_10FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_100HDX_OFST 8
+#define MC_CMD_PHY_CAP_100HDX_LBN 3
+#define MC_CMD_PHY_CAP_100HDX_WIDTH 1
+#define MC_CMD_PHY_CAP_100FDX_OFST 8
+#define MC_CMD_PHY_CAP_100FDX_LBN 4
+#define MC_CMD_PHY_CAP_100FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_1000HDX_OFST 8
+#define MC_CMD_PHY_CAP_1000HDX_LBN 5
+#define MC_CMD_PHY_CAP_1000HDX_WIDTH 1
+#define MC_CMD_PHY_CAP_1000FDX_OFST 8
+#define MC_CMD_PHY_CAP_1000FDX_LBN 6
+#define MC_CMD_PHY_CAP_1000FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_10000FDX_OFST 8
+#define MC_CMD_PHY_CAP_10000FDX_LBN 7
+#define MC_CMD_PHY_CAP_10000FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_PAUSE_OFST 8
+#define MC_CMD_PHY_CAP_PAUSE_LBN 8
+#define MC_CMD_PHY_CAP_PAUSE_WIDTH 1
+#define MC_CMD_PHY_CAP_ASYM_OFST 8
+#define MC_CMD_PHY_CAP_ASYM_LBN 9
+#define MC_CMD_PHY_CAP_ASYM_WIDTH 1
+#define MC_CMD_PHY_CAP_AN_OFST 8
+#define MC_CMD_PHY_CAP_AN_LBN 10
+#define MC_CMD_PHY_CAP_AN_WIDTH 1
+#define MC_CMD_PHY_CAP_40000FDX_OFST 8
+#define MC_CMD_PHY_CAP_40000FDX_LBN 11
+#define MC_CMD_PHY_CAP_40000FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_DDM_OFST 8
+#define MC_CMD_PHY_CAP_DDM_LBN 12
+#define MC_CMD_PHY_CAP_DDM_WIDTH 1
+#define MC_CMD_PHY_CAP_100000FDX_OFST 8
+#define MC_CMD_PHY_CAP_100000FDX_LBN 13
+#define MC_CMD_PHY_CAP_100000FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_25000FDX_OFST 8
+#define MC_CMD_PHY_CAP_25000FDX_LBN 14
+#define MC_CMD_PHY_CAP_25000FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_50000FDX_OFST 8
+#define MC_CMD_PHY_CAP_50000FDX_LBN 15
+#define MC_CMD_PHY_CAP_50000FDX_WIDTH 1
+#define MC_CMD_PHY_CAP_BASER_FEC_OFST 8
+#define MC_CMD_PHY_CAP_BASER_FEC_LBN 16
+#define MC_CMD_PHY_CAP_BASER_FEC_WIDTH 1
+#define MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_OFST 8
+#define MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN 17
+#define MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_WIDTH 1
+#define MC_CMD_PHY_CAP_RS_FEC_OFST 8
+#define MC_CMD_PHY_CAP_RS_FEC_LBN 18
+#define MC_CMD_PHY_CAP_RS_FEC_WIDTH 1
+#define MC_CMD_PHY_CAP_RS_FEC_REQUESTED_OFST 8
+#define MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN 19
+#define MC_CMD_PHY_CAP_RS_FEC_REQUESTED_WIDTH 1
+#define MC_CMD_PHY_CAP_25G_BASER_FEC_OFST 8
+#define MC_CMD_PHY_CAP_25G_BASER_FEC_LBN 20
+#define MC_CMD_PHY_CAP_25G_BASER_FEC_WIDTH 1
+#define MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_OFST 8
+#define MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN 21
+#define MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_WIDTH 1
+/* ?? */
+#define MC_CMD_GET_PHY_CFG_OUT_CHANNEL_OFST 12
+#define MC_CMD_GET_PHY_CFG_OUT_CHANNEL_LEN 4
+/* ?? */
+#define MC_CMD_GET_PHY_CFG_OUT_PRT_OFST 16
+#define MC_CMD_GET_PHY_CFG_OUT_PRT_LEN 4
+/* ?? */
+#define MC_CMD_GET_PHY_CFG_OUT_STATS_MASK_OFST 20
+#define MC_CMD_GET_PHY_CFG_OUT_STATS_MASK_LEN 4
+/* ?? */
+#define MC_CMD_GET_PHY_CFG_OUT_NAME_OFST 24
+#define MC_CMD_GET_PHY_CFG_OUT_NAME_LEN 20
+/* ?? */
+#define MC_CMD_GET_PHY_CFG_OUT_MEDIA_TYPE_OFST 44
+#define MC_CMD_GET_PHY_CFG_OUT_MEDIA_TYPE_LEN 4
+/* enum: Xaui. */
+#define MC_CMD_MEDIA_XAUI 0x1
+/* enum: CX4. */
+#define MC_CMD_MEDIA_CX4 0x2
+/* enum: KX4. */
+#define MC_CMD_MEDIA_KX4 0x3
+/* enum: XFP Far. */
+#define MC_CMD_MEDIA_XFP 0x4
+/* enum: SFP+. */
+#define MC_CMD_MEDIA_SFP_PLUS 0x5
+/* enum: 10GBaseT. */
+#define MC_CMD_MEDIA_BASE_T 0x6
+/* enum: QSFP+. */
+#define MC_CMD_MEDIA_QSFP_PLUS 0x7
+/* enum: DSFP. */
+#define MC_CMD_MEDIA_DSFP 0x8
+#define MC_CMD_GET_PHY_CFG_OUT_MMD_MASK_OFST 48
+#define MC_CMD_GET_PHY_CFG_OUT_MMD_MASK_LEN 4
+/* enum: Native clause 22 */
+#define MC_CMD_MMD_CLAUSE22 0x0
+#define MC_CMD_MMD_CLAUSE45_PMAPMD 0x1 /* enum */
+#define MC_CMD_MMD_CLAUSE45_WIS 0x2 /* enum */
+#define MC_CMD_MMD_CLAUSE45_PCS 0x3 /* enum */
+#define MC_CMD_MMD_CLAUSE45_PHYXS 0x4 /* enum */
+#define MC_CMD_MMD_CLAUSE45_DTEXS 0x5 /* enum */
+#define MC_CMD_MMD_CLAUSE45_TC 0x6 /* enum */
+#define MC_CMD_MMD_CLAUSE45_AN 0x7 /* enum */
+/* enum: Clause22 proxied over clause45 by PHY. */
+#define MC_CMD_MMD_CLAUSE45_C22EXT 0x1d
+#define MC_CMD_MMD_CLAUSE45_VEND1 0x1e /* enum */
+#define MC_CMD_MMD_CLAUSE45_VEND2 0x1f /* enum */
+#define MC_CMD_GET_PHY_CFG_OUT_REVISION_OFST 52
+#define MC_CMD_GET_PHY_CFG_OUT_REVISION_LEN 20
+/***********************************/
+/* MC_CMD_GET_LOOPBACK_MODES
+ * Returns a bitmask of loopback modes available at each speed.
+ */
+#define MC_CMD_GET_LOOPBACK_MODES 0x28
+#define MC_CMD_GET_LOOPBACK_MODES_MSGSET 0x28
+
+/* MC_CMD_GET_LOOPBACK_MODES_IN msgrequest */
+#define MC_CMD_GET_LOOPBACK_MODES_IN_LEN 0
+
+/* MC_CMD_GET_LOOPBACK_MODES_OUT msgresponse */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_LEN 40
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_OFST 0
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_LO_OFST 0
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_LO_LBN 0
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_HI_OFST 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_HI_LBN 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_100M_HI_WIDTH 32
+/* enum: None. */
+#define MC_CMD_LOOPBACK_NONE 0x0
+/* enum: Data. */
+#define MC_CMD_LOOPBACK_DATA 0x1
+/* enum: GMAC. */
+#define MC_CMD_LOOPBACK_GMAC 0x2
+/* enum: XGMII. */
+#define MC_CMD_LOOPBACK_XGMII 0x3
+/* enum: XGXS. */
+#define MC_CMD_LOOPBACK_XGXS 0x4
+/* enum: XAUI. */
+#define MC_CMD_LOOPBACK_XAUI 0x5
+/* enum: GMII. */
+#define MC_CMD_LOOPBACK_GMII 0x6
+/* enum: SGMII. */
+#define MC_CMD_LOOPBACK_SGMII 0x7
+/* enum: XGBR. */
+#define MC_CMD_LOOPBACK_XGBR 0x8
+/* enum: XFI. */
+#define MC_CMD_LOOPBACK_XFI 0x9
+/* enum: XAUI Far. */
+#define MC_CMD_LOOPBACK_XAUI_FAR 0xa
+/* enum: GMII Far. */
+#define MC_CMD_LOOPBACK_GMII_FAR 0xb
+/* enum: SGMII Far. */
+#define MC_CMD_LOOPBACK_SGMII_FAR 0xc
+/* enum: XFI Far. */
+#define MC_CMD_LOOPBACK_XFI_FAR 0xd
+/* enum: GPhy. */
+#define MC_CMD_LOOPBACK_GPHY 0xe
+/* enum: PhyXS. */
+#define MC_CMD_LOOPBACK_PHYXS 0xf
+/* enum: PCS. */
+#define MC_CMD_LOOPBACK_PCS 0x10
+/* enum: PMA-PMD. */
+#define MC_CMD_LOOPBACK_PMAPMD 0x11
+/* enum: Cross-Port. */
+#define MC_CMD_LOOPBACK_XPORT 0x12
+/* enum: XGMII-Wireside. */
+#define MC_CMD_LOOPBACK_XGMII_WS 0x13
+/* enum: XAUI Wireside. */
+#define MC_CMD_LOOPBACK_XAUI_WS 0x14
+/* enum: XAUI Wireside Far. */
+#define MC_CMD_LOOPBACK_XAUI_WS_FAR 0x15
+/* enum: XAUI Wireside near. */
+#define MC_CMD_LOOPBACK_XAUI_WS_NEAR 0x16
+/* enum: GMII Wireside. */
+#define MC_CMD_LOOPBACK_GMII_WS 0x17
+/* enum: XFI Wireside. */
+#define MC_CMD_LOOPBACK_XFI_WS 0x18
+/* enum: XFI Wireside Far. */
+#define MC_CMD_LOOPBACK_XFI_WS_FAR 0x19
+/* enum: PhyXS Wireside. */
+#define MC_CMD_LOOPBACK_PHYXS_WS 0x1a
+/* enum: PMA lanes MAC-Serdes. */
+#define MC_CMD_LOOPBACK_PMA_INT 0x1b
+/* enum: KR Serdes Parallel (Encoder). */
+#define MC_CMD_LOOPBACK_SD_NEAR 0x1c
+/* enum: KR Serdes Serial. */
+#define MC_CMD_LOOPBACK_SD_FAR 0x1d
+/* enum: PMA lanes MAC-Serdes Wireside. */
+#define MC_CMD_LOOPBACK_PMA_INT_WS 0x1e
+/* enum: KR Serdes Parallel Wireside (Full PCS). */
+#define MC_CMD_LOOPBACK_SD_FEP2_WS 0x1f
+/* enum: KR Serdes Parallel Wireside (Sym Aligner to TX). */
+#define MC_CMD_LOOPBACK_SD_FEP1_5_WS 0x20
+/* enum: KR Serdes Parallel Wireside (Deserializer to Serializer). */
+#define MC_CMD_LOOPBACK_SD_FEP_WS 0x21
+/* enum: KR Serdes Serial Wireside. */
+#define MC_CMD_LOOPBACK_SD_FES_WS 0x22
+/* enum: Near side of AOE Siena side port */
+#define MC_CMD_LOOPBACK_AOE_INT_NEAR 0x23
+/* enum: Medford Wireside datapath loopback */
+#define MC_CMD_LOOPBACK_DATA_WS 0x24
+/* enum: Force link up without setting up any physical loopback (snapper use
+ * only)
+ */
+#define MC_CMD_LOOPBACK_FORCE_EXT_LINK 0x25
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_OFST 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_LO_OFST 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_LO_LBN 64
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_HI_OFST 12
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_HI_LBN 96
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_1G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_OFST 16
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_LO_OFST 16
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_LO_LBN 128
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_HI_OFST 20
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_HI_LBN 160
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_10G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_OFST 24
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LO_OFST 24
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LO_LBN 192
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_HI_OFST 28
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_HI_LBN 224
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_OFST 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_LO_OFST 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_LO_LBN 256
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_HI_OFST 36
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_HI_LBN 288
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_40G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+
+/* MC_CMD_GET_LOOPBACK_MODES_OUT_V2 msgresponse: Supported loopback modes for
+ * newer NICs with 25G/50G/100G support
+ */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_LEN 64
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_OFST 0
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_LO_OFST 0
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_LO_LBN 0
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_HI_OFST 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_HI_LBN 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100M_HI_WIDTH 32
+/* enum: None. */
+/* MC_CMD_LOOPBACK_NONE 0x0 */
+/* enum: Data. */
+/* MC_CMD_LOOPBACK_DATA 0x1 */
+/* enum: GMAC. */
+/* MC_CMD_LOOPBACK_GMAC 0x2 */
+/* enum: XGMII. */
+/* MC_CMD_LOOPBACK_XGMII 0x3 */
+/* enum: XGXS. */
+/* MC_CMD_LOOPBACK_XGXS 0x4 */
+/* enum: XAUI. */
+/* MC_CMD_LOOPBACK_XAUI 0x5 */
+/* enum: GMII. */
+/* MC_CMD_LOOPBACK_GMII 0x6 */
+/* enum: SGMII. */
+/* MC_CMD_LOOPBACK_SGMII 0x7 */
+/* enum: XGBR. */
+/* MC_CMD_LOOPBACK_XGBR 0x8 */
+/* enum: XFI. */
+/* MC_CMD_LOOPBACK_XFI 0x9 */
+/* enum: XAUI Far. */
+/* MC_CMD_LOOPBACK_XAUI_FAR 0xa */
+/* enum: GMII Far. */
+/* MC_CMD_LOOPBACK_GMII_FAR 0xb */
+/* enum: SGMII Far. */
+/* MC_CMD_LOOPBACK_SGMII_FAR 0xc */
+/* enum: XFI Far. */
+/* MC_CMD_LOOPBACK_XFI_FAR 0xd */
+/* enum: GPhy. */
+/* MC_CMD_LOOPBACK_GPHY 0xe */
+/* enum: PhyXS. */
+/* MC_CMD_LOOPBACK_PHYXS 0xf */
+/* enum: PCS. */
+/* MC_CMD_LOOPBACK_PCS 0x10 */
+/* enum: PMA-PMD. */
+/* MC_CMD_LOOPBACK_PMAPMD 0x11 */
+/* enum: Cross-Port. */
+/* MC_CMD_LOOPBACK_XPORT 0x12 */
+/* enum: XGMII-Wireside. */
+/* MC_CMD_LOOPBACK_XGMII_WS 0x13 */
+/* enum: XAUI Wireside. */
+/* MC_CMD_LOOPBACK_XAUI_WS 0x14 */
+/* enum: XAUI Wireside Far. */
+/* MC_CMD_LOOPBACK_XAUI_WS_FAR 0x15 */
+/* enum: XAUI Wireside near. */
+/* MC_CMD_LOOPBACK_XAUI_WS_NEAR 0x16 */
+/* enum: GMII Wireside. */
+/* MC_CMD_LOOPBACK_GMII_WS 0x17 */
+/* enum: XFI Wireside. */
+/* MC_CMD_LOOPBACK_XFI_WS 0x18 */
+/* enum: XFI Wireside Far. */
+/* MC_CMD_LOOPBACK_XFI_WS_FAR 0x19 */
+/* enum: PhyXS Wireside. */
+/* MC_CMD_LOOPBACK_PHYXS_WS 0x1a */
+/* enum: PMA lanes MAC-Serdes. */
+/* MC_CMD_LOOPBACK_PMA_INT 0x1b */
+/* enum: KR Serdes Parallel (Encoder). */
+/* MC_CMD_LOOPBACK_SD_NEAR 0x1c */
+/* enum: KR Serdes Serial. */
+/* MC_CMD_LOOPBACK_SD_FAR 0x1d */
+/* enum: PMA lanes MAC-Serdes Wireside. */
+/* MC_CMD_LOOPBACK_PMA_INT_WS 0x1e */
+/* enum: KR Serdes Parallel Wireside (Full PCS). */
+/* MC_CMD_LOOPBACK_SD_FEP2_WS 0x1f */
+/* enum: KR Serdes Parallel Wireside (Sym Aligner to TX). */
+/* MC_CMD_LOOPBACK_SD_FEP1_5_WS 0x20 */
+/* enum: KR Serdes Parallel Wireside (Deserializer to Serializer). */
+/* MC_CMD_LOOPBACK_SD_FEP_WS 0x21 */
+/* enum: KR Serdes Serial Wireside. */
+/* MC_CMD_LOOPBACK_SD_FES_WS 0x22 */
+/* enum: Near side of AOE Siena side port */
+/* MC_CMD_LOOPBACK_AOE_INT_NEAR 0x23 */
+/* enum: Medford Wireside datapath loopback */
+/* MC_CMD_LOOPBACK_DATA_WS 0x24 */
+/* enum: Force link up without setting up any physical loopback (snapper use
+ * only)
+ */
+/* MC_CMD_LOOPBACK_FORCE_EXT_LINK 0x25 */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_OFST 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_LO_OFST 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_LO_LBN 64
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_HI_OFST 12
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_HI_LBN 96
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_1G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_OFST 16
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_LO_OFST 16
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_LO_LBN 128
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_HI_OFST 20
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_HI_LBN 160
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_10G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_OFST 24
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_LO_OFST 24
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_LO_LBN 192
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_HI_OFST 28
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_HI_LBN 224
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_SUGGESTED_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_OFST 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_LO_OFST 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_LO_LBN 256
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_HI_OFST 36
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_HI_LBN 288
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_40G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported 25G loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_OFST 40
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_LO_OFST 40
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_LO_LBN 320
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_HI_OFST 44
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_HI_LBN 352
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_25G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported 50 loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_OFST 48
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_LO_OFST 48
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_LO_LBN 384
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_HI_OFST 52
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_HI_LBN 416
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_50G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* Supported 100G loopbacks. */
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_OFST 56
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_LEN 8
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_LO_OFST 56
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_LO_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_LO_LBN 448
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_LO_WIDTH 32
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_HI_OFST 60
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_HI_LEN 4
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_HI_LBN 480
+#define MC_CMD_GET_LOOPBACK_MODES_OUT_V2_100G_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* 100M */
+/* FEC_TYPE structuredef: Forward error correction types defined in IEEE802.3
+ */
+#define FEC_TYPE_LEN 4
+#define FEC_TYPE_TYPE_OFST 0
+#define FEC_TYPE_TYPE_LEN 4
+/* enum: No FEC */
+#define MC_CMD_FEC_NONE 0x0
+/* enum: Clause 74 BASE-R FEC (a.k.a Firecode) */
+#define MC_CMD_FEC_BASER 0x1
+/* enum: Clause 91/Clause 108 Reed-Solomon FEC */
+#define MC_CMD_FEC_RS 0x2
+#define FEC_TYPE_TYPE_LBN 0
+#define FEC_TYPE_TYPE_WIDTH 32
+
+/***********************************/
+/* MC_CMD_GET_LINK
+ * Read the unified MAC/PHY link state. Locks required: None Return code: 0,
+ * ETIME.
+ */
+#define MC_CMD_GET_LINK 0x29
+#define MC_CMD_GET_LINK_MSGSET 0x29
+
+/* MC_CMD_GET_LINK_IN msgrequest */
+#define MC_CMD_GET_LINK_IN_LEN 0
+/* MC_CMD_GET_LINK_OUT_V2 msgresponse: Extended link state information */
+#define MC_CMD_GET_LINK_OUT_V2_LEN 44
+/* Near-side advertised capabilities. Refer to
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP for bit definitions.
+ */
+#define MC_CMD_GET_LINK_OUT_V2_CAP_OFST 0
+#define MC_CMD_GET_LINK_OUT_V2_CAP_LEN 4
+/* Link-partner advertised capabilities. Refer to
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP for bit definitions.
+ */
+#define MC_CMD_GET_LINK_OUT_V2_LP_CAP_OFST 4
+#define MC_CMD_GET_LINK_OUT_V2_LP_CAP_LEN 4
+/* Autonegotiated speed in mbit/s. The link may still be down even if this
+ * reads non-zero.
+ */
+#define MC_CMD_GET_LINK_OUT_V2_LINK_SPEED_OFST 8
+#define MC_CMD_GET_LINK_OUT_V2_LINK_SPEED_LEN 4
+/* Current loopback setting. */
+#define MC_CMD_GET_LINK_OUT_V2_LOOPBACK_MODE_OFST 12
+#define MC_CMD_GET_LINK_OUT_V2_LOOPBACK_MODE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_GET_LOOPBACK_MODES/MC_CMD_GET_LOOPBACK_MODES_OUT/100M */
+#define MC_CMD_GET_LINK_OUT_V2_FLAGS_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_FLAGS_LEN 4
+#define MC_CMD_GET_LINK_OUT_V2_LINK_UP_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_LINK_UP_LBN 0
+#define MC_CMD_GET_LINK_OUT_V2_LINK_UP_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_LBN 1
+#define MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_BPX_LINK_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_BPX_LINK_LBN 2
+#define MC_CMD_GET_LINK_OUT_V2_BPX_LINK_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_PHY_LINK_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_PHY_LINK_LBN 3
+#define MC_CMD_GET_LINK_OUT_V2_PHY_LINK_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_RX_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_RX_LBN 6
+#define MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_RX_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_TX_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_TX_LBN 7
+#define MC_CMD_GET_LINK_OUT_V2_LINK_FAULT_TX_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_MODULE_UP_VALID_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_MODULE_UP_VALID_LBN 8
+#define MC_CMD_GET_LINK_OUT_V2_MODULE_UP_VALID_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_MODULE_UP_OFST 16
+#define MC_CMD_GET_LINK_OUT_V2_MODULE_UP_LBN 9
+#define MC_CMD_GET_LINK_OUT_V2_MODULE_UP_WIDTH 1
+/* This returns the negotiated flow control value. */
+#define MC_CMD_GET_LINK_OUT_V2_FCNTL_OFST 20
+#define MC_CMD_GET_LINK_OUT_V2_FCNTL_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_SET_MAC/MC_CMD_SET_MAC_IN/FCNTL */
+#define MC_CMD_GET_LINK_OUT_V2_MAC_FAULT_OFST 24
+#define MC_CMD_GET_LINK_OUT_V2_MAC_FAULT_LEN 4
+/* MC_CMD_MAC_FAULT_XGMII_LOCAL_OFST 24 */
+/* MC_CMD_MAC_FAULT_XGMII_LOCAL_LBN 0 */
+/* MC_CMD_MAC_FAULT_XGMII_LOCAL_WIDTH 1 */
+/* MC_CMD_MAC_FAULT_XGMII_REMOTE_OFST 24 */
+/* MC_CMD_MAC_FAULT_XGMII_REMOTE_LBN 1 */
+/* MC_CMD_MAC_FAULT_XGMII_REMOTE_WIDTH 1 */
+/* MC_CMD_MAC_FAULT_SGMII_REMOTE_OFST 24 */
+/* MC_CMD_MAC_FAULT_SGMII_REMOTE_LBN 2 */
+/* MC_CMD_MAC_FAULT_SGMII_REMOTE_WIDTH 1 */
+/* MC_CMD_MAC_FAULT_PENDING_RECONFIG_OFST 24 */
+/* MC_CMD_MAC_FAULT_PENDING_RECONFIG_LBN 3 */
+/* MC_CMD_MAC_FAULT_PENDING_RECONFIG_WIDTH 1 */
+/* True local device capabilities (taking into account currently used PMD/MDI,
+ * e.g. plugged-in module). In general, subset of
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP, but may include extra _FEC_REQUEST
+ * bits, if the PMD requires FEC. 0 if unknown (e.g. module unplugged). Equal
+ * to SUPPORTED_CAP for non-pluggable PMDs. Refer to
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP for bit definitions.
+ */
+#define MC_CMD_GET_LINK_OUT_V2_LD_CAP_OFST 28
+#define MC_CMD_GET_LINK_OUT_V2_LD_CAP_LEN 4
+/* Auto-negotiation type used on the link */
+#define MC_CMD_GET_LINK_OUT_V2_AN_TYPE_OFST 32
+#define MC_CMD_GET_LINK_OUT_V2_AN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* AN_TYPE/TYPE */
+/* Forward error correction used on the link */
+#define MC_CMD_GET_LINK_OUT_V2_FEC_TYPE_OFST 36
+#define MC_CMD_GET_LINK_OUT_V2_FEC_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* FEC_TYPE/TYPE */
+#define MC_CMD_GET_LINK_OUT_V2_EXT_FLAGS_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_EXT_FLAGS_LEN 4
+#define MC_CMD_GET_LINK_OUT_V2_PMD_MDI_CONNECTED_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_PMD_MDI_CONNECTED_LBN 0
+#define MC_CMD_GET_LINK_OUT_V2_PMD_MDI_CONNECTED_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_PMD_READY_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_PMD_READY_LBN 1
+#define MC_CMD_GET_LINK_OUT_V2_PMD_READY_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_PMD_LINK_UP_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_PMD_LINK_UP_LBN 2
+#define MC_CMD_GET_LINK_OUT_V2_PMD_LINK_UP_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_PMA_LINK_UP_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_PMA_LINK_UP_LBN 3
+#define MC_CMD_GET_LINK_OUT_V2_PMA_LINK_UP_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_PCS_LOCK_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_PCS_LOCK_LBN 4
+#define MC_CMD_GET_LINK_OUT_V2_PCS_LOCK_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_ALIGN_LOCK_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_ALIGN_LOCK_LBN 5
+#define MC_CMD_GET_LINK_OUT_V2_ALIGN_LOCK_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_HI_BER_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_HI_BER_LBN 6
+#define MC_CMD_GET_LINK_OUT_V2_HI_BER_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_FEC_LOCK_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_FEC_LOCK_LBN 7
+#define MC_CMD_GET_LINK_OUT_V2_FEC_LOCK_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_AN_DONE_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_AN_DONE_LBN 8
+#define MC_CMD_GET_LINK_OUT_V2_AN_DONE_WIDTH 1
+#define MC_CMD_GET_LINK_OUT_V2_PORT_SHUTDOWN_OFST 40
+#define MC_CMD_GET_LINK_OUT_V2_PORT_SHUTDOWN_LBN 9
+#define MC_CMD_GET_LINK_OUT_V2_PORT_SHUTDOWN_WIDTH 1
+
+/***********************************/
+/* MC_CMD_SET_LINK
+ * Write the unified MAC/PHY link configuration. Locks required: None. Return
+ * code: 0, EINVAL, ETIME, EAGAIN
+ */
+#define MC_CMD_SET_LINK 0x2a
+#define MC_CMD_SET_LINK_MSGSET 0x2a
+
+/* MC_CMD_SET_LINK_IN_V2 msgrequest: Updated SET_LINK to include sequence
+ * number to ensure this SET_LINK command corresponds to the latest
+ * MODULECHANGE event.
+ */
+#define MC_CMD_SET_LINK_IN_V2_LEN 17
+/* Near-side advertised capabilities. Refer to
+ * MC_CMD_GET_PHY_CFG_OUT/SUPPORTED_CAP for bit definitions.
+ */
+#define MC_CMD_SET_LINK_IN_V2_CAP_OFST 0
+#define MC_CMD_SET_LINK_IN_V2_CAP_LEN 4
+/* Flags */
+#define MC_CMD_SET_LINK_IN_V2_FLAGS_OFST 4
+#define MC_CMD_SET_LINK_IN_V2_FLAGS_LEN 4
+#define MC_CMD_SET_LINK_IN_V2_LOWPOWER_OFST 4
+#define MC_CMD_SET_LINK_IN_V2_LOWPOWER_LBN 0
+#define MC_CMD_SET_LINK_IN_V2_LOWPOWER_WIDTH 1
+#define MC_CMD_SET_LINK_IN_V2_POWEROFF_OFST 4
+#define MC_CMD_SET_LINK_IN_V2_POWEROFF_LBN 1
+#define MC_CMD_SET_LINK_IN_V2_POWEROFF_WIDTH 1
+#define MC_CMD_SET_LINK_IN_V2_TXDIS_OFST 4
+#define MC_CMD_SET_LINK_IN_V2_TXDIS_LBN 2
+#define MC_CMD_SET_LINK_IN_V2_TXDIS_WIDTH 1
+#define MC_CMD_SET_LINK_IN_V2_LINKDOWN_OFST 4
+#define MC_CMD_SET_LINK_IN_V2_LINKDOWN_LBN 3
+#define MC_CMD_SET_LINK_IN_V2_LINKDOWN_WIDTH 1
+/* Loopback mode. */
+#define MC_CMD_SET_LINK_IN_V2_LOOPBACK_MODE_OFST 8
+#define MC_CMD_SET_LINK_IN_V2_LOOPBACK_MODE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_GET_LOOPBACK_MODES/MC_CMD_GET_LOOPBACK_MODES_OUT/100M */
+/* A loopback speed of "0" is supported, and means (choose any available
+ * speed).
+ */
+#define MC_CMD_SET_LINK_IN_V2_LOOPBACK_SPEED_OFST 12
+#define MC_CMD_SET_LINK_IN_V2_LOOPBACK_SPEED_LEN 4
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_OFST 16
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_LEN 1
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_NUMBER_OFST 16
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_NUMBER_LBN 0
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_NUMBER_WIDTH 7
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_OFST 16
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_LBN 7
+#define MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_WIDTH 1
+
+/* MC_CMD_SET_LINK_OUT msgresponse */
+#define MC_CMD_SET_LINK_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_SET_ID_LED
+ * Set identification LED state. Locks required: None. Return code: 0, EINVAL
+ */
+#define MC_CMD_SET_ID_LED 0x2b
+#define MC_CMD_SET_ID_LED_MSGSET 0x2b
+
+/* MC_CMD_SET_ID_LED_IN msgrequest */
+#define MC_CMD_SET_ID_LED_IN_LEN 4
+/* Set LED state. */
+#define MC_CMD_SET_ID_LED_IN_STATE_OFST 0
+#define MC_CMD_SET_ID_LED_IN_STATE_LEN 4
+#define MC_CMD_LED_OFF 0x0 /* enum */
+#define MC_CMD_LED_ON 0x1 /* enum */
+#define MC_CMD_LED_DEFAULT 0x2 /* enum */
+
+/* MC_CMD_SET_ID_LED_OUT msgresponse */
+#define MC_CMD_SET_ID_LED_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_SET_MAC
+ * Set MAC configuration. Locks required: None. Return code: 0, EINVAL
+ */
+#define MC_CMD_SET_MAC 0x2c
+#define MC_CMD_SET_MAC_MSGSET 0x2c
+
+/* enum: Flow control is off. */
+#define MC_CMD_FCNTL_OFF 0x0
+/* enum: Respond to flow control. */
+#define MC_CMD_FCNTL_RESPOND 0x1
+/* enum: Respond to and Issue flow control. */
+#define MC_CMD_FCNTL_BIDIR 0x2
+/* enum: Auto neg flow control. */
+#define MC_CMD_FCNTL_AUTO 0x3
+/* enum: Priority flow control (eftest builds only). */
+#define MC_CMD_FCNTL_QBB 0x4
+/* enum: Issue flow control. */
+#define MC_CMD_FCNTL_GENERATE 0x5
+/* MC_CMD_SET_MAC_V3_IN msgrequest */
+#define MC_CMD_SET_MAC_V3_IN_LEN 40
+/* The MTU is the MTU programmed directly into the XMAC/GMAC (inclusive of
+ * EtherII, VLAN, bug16011 padding).
+ */
+#define MC_CMD_SET_MAC_V3_IN_MTU_OFST 0
+#define MC_CMD_SET_MAC_V3_IN_MTU_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_DRAIN_OFST 4
+#define MC_CMD_SET_MAC_V3_IN_DRAIN_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_ADDR_OFST 8
+#define MC_CMD_SET_MAC_V3_IN_ADDR_LEN 8
+#define MC_CMD_SET_MAC_V3_IN_ADDR_LO_OFST 8
+#define MC_CMD_SET_MAC_V3_IN_ADDR_LO_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_ADDR_LO_LBN 64
+#define MC_CMD_SET_MAC_V3_IN_ADDR_LO_WIDTH 32
+#define MC_CMD_SET_MAC_V3_IN_ADDR_HI_OFST 12
+#define MC_CMD_SET_MAC_V3_IN_ADDR_HI_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_ADDR_HI_LBN 96
+#define MC_CMD_SET_MAC_V3_IN_ADDR_HI_WIDTH 32
+#define MC_CMD_SET_MAC_V3_IN_REJECT_OFST 16
+#define MC_CMD_SET_MAC_V3_IN_REJECT_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_REJECT_UNCST_OFST 16
+#define MC_CMD_SET_MAC_V3_IN_REJECT_UNCST_LBN 0
+#define MC_CMD_SET_MAC_V3_IN_REJECT_UNCST_WIDTH 1
+#define MC_CMD_SET_MAC_V3_IN_REJECT_BRDCST_OFST 16
+#define MC_CMD_SET_MAC_V3_IN_REJECT_BRDCST_LBN 1
+#define MC_CMD_SET_MAC_V3_IN_REJECT_BRDCST_WIDTH 1
+#define MC_CMD_SET_MAC_V3_IN_FCNTL_OFST 20
+#define MC_CMD_SET_MAC_V3_IN_FCNTL_LEN 4
+/* enum: Flow control is off. */
+/* MC_CMD_FCNTL_OFF 0x0 */
+/* enum: Respond to flow control. */
+/* MC_CMD_FCNTL_RESPOND 0x1 */
+/* enum: Respond to and Issue flow control. */
+/* MC_CMD_FCNTL_BIDIR 0x2 */
+/* enum: Auto neg flow control. */
+/* MC_CMD_FCNTL_AUTO 0x3 */
+/* enum: Priority flow control (eftest builds only). */
+/* MC_CMD_FCNTL_QBB 0x4 */
+/* enum: Issue flow control. */
+/* MC_CMD_FCNTL_GENERATE 0x5 */
+#define MC_CMD_SET_MAC_V3_IN_FLAGS_OFST 24
+#define MC_CMD_SET_MAC_V3_IN_FLAGS_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_FLAG_INCLUDE_FCS_OFST 24
+#define MC_CMD_SET_MAC_V3_IN_FLAG_INCLUDE_FCS_LBN 0
+#define MC_CMD_SET_MAC_V3_IN_FLAG_INCLUDE_FCS_WIDTH 1
+/* Select which parameters to configure. A parameter will only be modified if
+ * the corresponding control flag is set. If SET_MAC_ENHANCED is not set in
+ * capabilities then this field is ignored (and all flags are assumed to be
+ * set).
+ */
+#define MC_CMD_SET_MAC_V3_IN_CONTROL_OFST 28
+#define MC_CMD_SET_MAC_V3_IN_CONTROL_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_CFG_MTU_OFST 28
+#define MC_CMD_SET_MAC_V3_IN_CFG_MTU_LBN 0
+#define MC_CMD_SET_MAC_V3_IN_CFG_MTU_WIDTH 1
+#define MC_CMD_SET_MAC_V3_IN_CFG_DRAIN_OFST 28
+#define MC_CMD_SET_MAC_V3_IN_CFG_DRAIN_LBN 1
+#define MC_CMD_SET_MAC_V3_IN_CFG_DRAIN_WIDTH 1
+#define MC_CMD_SET_MAC_V3_IN_CFG_REJECT_OFST 28
+#define MC_CMD_SET_MAC_V3_IN_CFG_REJECT_LBN 2
+#define MC_CMD_SET_MAC_V3_IN_CFG_REJECT_WIDTH 1
+#define MC_CMD_SET_MAC_V3_IN_CFG_FCNTL_OFST 28
+#define MC_CMD_SET_MAC_V3_IN_CFG_FCNTL_LBN 3
+#define MC_CMD_SET_MAC_V3_IN_CFG_FCNTL_WIDTH 1
+#define MC_CMD_SET_MAC_V3_IN_CFG_FCS_OFST 28
+#define MC_CMD_SET_MAC_V3_IN_CFG_FCS_LBN 4
+#define MC_CMD_SET_MAC_V3_IN_CFG_FCS_WIDTH 1
+/* Identifies the MAC to update by the specifying the end of a logical MAE
+ * link. Setting TARGET to MAE_LINK_ENDPOINT_COMPAT is equivalent to using the
+ * previous version of the command (MC_CMD_SET_MAC_EXT). Not all possible
+ * combinations of MPORT_END and MPORT_SELECTOR in TARGET will work in all
+ * circumstances. 1. Some will always work (e.g. a VF can always address its
+ * logical MAC using MPORT_SELECTOR=ASSIGNED,LINK_END=VNIC), 2. Some are not
+ * meaningful and will always fail with EINVAL (e.g. attempting to address the
+ * VNIC end of a link to a physical port), 3. Some are meaningful but require
+ * the MCDI client to have the required permission and fail with EPERM
+ * otherwise (e.g. trying to set the MAC on a VF the caller cannot administer),
+ * and 4. Some could be implementation-specific and fail with ENOTSUP if not
+ * available (no examples exist right now). See SF-123581-TC section 4.3 for
+ * more details.
+ */
+#define MC_CMD_SET_MAC_V3_IN_TARGET_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LEN 8
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LO_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LO_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LO_LBN 256
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LO_WIDTH 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_HI_OFST 36
+#define MC_CMD_SET_MAC_V3_IN_TARGET_HI_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_HI_LBN 288
+#define MC_CMD_SET_MAC_V3_IN_TARGET_HI_WIDTH 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FLAT_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FLAT_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_TYPE_OFST 35
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_TYPE_LEN 1
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_MPORT_ID_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_MPORT_ID_LEN 3
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_PPORT_ID_LBN 256
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_PPORT_ID_WIDTH 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_LBN 276
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_INTF_ID_WIDTH 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_LBN 272
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_MH_PF_ID_WIDTH 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_PF_ID_OFST 34
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_PF_ID_LEN 1
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_VF_ID_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_MPORT_SELECTOR_FUNC_VF_ID_LEN 2
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LINK_END_OFST 36
+#define MC_CMD_SET_MAC_V3_IN_TARGET_LINK_END_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_LEN 8
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_LO_OFST 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_LO_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_LO_LBN 256
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_LO_WIDTH 32
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_HI_OFST 36
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_HI_LEN 4
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_HI_LBN 288
+#define MC_CMD_SET_MAC_V3_IN_TARGET_FLAT_HI_WIDTH 32
+
+/* MC_CMD_SET_MAC_OUT msgresponse */
+#define MC_CMD_SET_MAC_OUT_LEN 0
+
+/* MC_CMD_SET_MAC_V2_OUT msgresponse */
+#define MC_CMD_SET_MAC_V2_OUT_LEN 4
+/* MTU as configured after processing the request. See comment at
+ * MC_CMD_SET_MAC_IN/MTU. To query MTU without doing any changes, set CONTROL
+ * to 0.
+ */
+#define MC_CMD_SET_MAC_V2_OUT_MTU_OFST 0
+#define MC_CMD_SET_MAC_V2_OUT_MTU_LEN 4
+/***********************************/
+/* MC_CMD_MAC_STATS
+ * Get generic MAC statistics. This call returns unified statistics maintained
+ * by the MC as it switches between the GMAC and XMAC. The MC will write out
+ * all supported stats. The driver should zero initialise the buffer to
+ * guarantee consistent results. If the DMA_ADDR is 0, then no DMA is
+ * performed, and the statistics may be read from the message response. If
+ * DMA_ADDR != 0, then the statistics are dmad to that (page-aligned location).
+ * Locks required: None. The PERIODIC_CLEAR option is not used and now has no
+ * effect. Returns: 0, ETIME
+ */
+#define MC_CMD_MAC_STATS 0x2e
+#define MC_CMD_MAC_STATS_MSGSET 0x2e
+
+/* MC_CMD_MAC_STATS_IN msgrequest */
+#define MC_CMD_MAC_STATS_IN_LEN 20
+/* ??? */
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_OFST 0
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_LEN 8
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_LO_OFST 0
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_LO_LEN 4
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_LO_LBN 0
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_LO_WIDTH 32
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_HI_OFST 4
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_HI_LEN 4
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_HI_LBN 32
+#define MC_CMD_MAC_STATS_IN_DMA_ADDR_HI_WIDTH 32
+#define MC_CMD_MAC_STATS_IN_CMD_OFST 8
+#define MC_CMD_MAC_STATS_IN_CMD_LEN 4
+#define MC_CMD_MAC_STATS_IN_DMA_OFST 8
+#define MC_CMD_MAC_STATS_IN_DMA_LBN 0
+#define MC_CMD_MAC_STATS_IN_DMA_WIDTH 1
+#define MC_CMD_MAC_STATS_IN_CLEAR_OFST 8
+#define MC_CMD_MAC_STATS_IN_CLEAR_LBN 1
+#define MC_CMD_MAC_STATS_IN_CLEAR_WIDTH 1
+#define MC_CMD_MAC_STATS_IN_PERIODIC_CHANGE_OFST 8
+#define MC_CMD_MAC_STATS_IN_PERIODIC_CHANGE_LBN 2
+#define MC_CMD_MAC_STATS_IN_PERIODIC_CHANGE_WIDTH 1
+#define MC_CMD_MAC_STATS_IN_PERIODIC_ENABLE_OFST 8
+#define MC_CMD_MAC_STATS_IN_PERIODIC_ENABLE_LBN 3
+#define MC_CMD_MAC_STATS_IN_PERIODIC_ENABLE_WIDTH 1
+#define MC_CMD_MAC_STATS_IN_PERIODIC_CLEAR_OFST 8
+#define MC_CMD_MAC_STATS_IN_PERIODIC_CLEAR_LBN 4
+#define MC_CMD_MAC_STATS_IN_PERIODIC_CLEAR_WIDTH 1
+#define MC_CMD_MAC_STATS_IN_PERIODIC_NOEVENT_OFST 8
+#define MC_CMD_MAC_STATS_IN_PERIODIC_NOEVENT_LBN 5
+#define MC_CMD_MAC_STATS_IN_PERIODIC_NOEVENT_WIDTH 1
+#define MC_CMD_MAC_STATS_IN_PERIOD_MS_OFST 8
+#define MC_CMD_MAC_STATS_IN_PERIOD_MS_LBN 16
+#define MC_CMD_MAC_STATS_IN_PERIOD_MS_WIDTH 16
+/* DMA length. Should be set to MAC_STATS_NUM_STATS * sizeof(uint64_t), as
+ * returned by MC_CMD_GET_CAPABILITIES_V4_OUT. For legacy firmware not
+ * supporting MC_CMD_GET_CAPABILITIES_V4_OUT, DMA_LEN should be set to
+ * MC_CMD_MAC_NSTATS * sizeof(uint64_t)
+ */
+#define MC_CMD_MAC_STATS_IN_DMA_LEN_OFST 12
+#define MC_CMD_MAC_STATS_IN_DMA_LEN_LEN 4
+/* port id so vadapter stats can be provided */
+#define MC_CMD_MAC_STATS_IN_PORT_ID_OFST 16
+#define MC_CMD_MAC_STATS_IN_PORT_ID_LEN 4
+
+/* MC_CMD_MAC_STATS_OUT_DMA msgresponse */
+#define MC_CMD_MAC_STATS_OUT_DMA_LEN 0
+
+/* MC_CMD_MAC_STATS_OUT_NO_DMA msgresponse */
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_LEN (((MC_CMD_MAC_NSTATS * 64)) >> 3)
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_OFST 0
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_LEN 8
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_LO_OFST 0
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_LO_LEN 4
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_LO_LBN 0
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_LO_WIDTH 32
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_HI_OFST 4
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_HI_LEN 4
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_HI_LBN 32
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_HI_WIDTH 32
+#define MC_CMD_MAC_STATS_OUT_NO_DMA_STATISTICS_NUM MC_CMD_MAC_NSTATS
+#define MC_CMD_MAC_GENERATION_START 0x0 /* enum */
+#define MC_CMD_MAC_DMABUF_START 0x1 /* enum */
+#define MC_CMD_MAC_TX_PKTS 0x1 /* enum */
+#define MC_CMD_MAC_TX_PAUSE_PKTS 0x2 /* enum */
+#define MC_CMD_MAC_TX_CONTROL_PKTS 0x3 /* enum */
+#define MC_CMD_MAC_TX_UNICAST_PKTS 0x4 /* enum */
+#define MC_CMD_MAC_TX_MULTICAST_PKTS 0x5 /* enum */
+#define MC_CMD_MAC_TX_BROADCAST_PKTS 0x6 /* enum */
+#define MC_CMD_MAC_TX_BYTES 0x7 /* enum */
+#define MC_CMD_MAC_TX_BAD_BYTES 0x8 /* enum */
+#define MC_CMD_MAC_TX_LT64_PKTS 0x9 /* enum */
+#define MC_CMD_MAC_TX_64_PKTS 0xa /* enum */
+#define MC_CMD_MAC_TX_65_TO_127_PKTS 0xb /* enum */
+#define MC_CMD_MAC_TX_128_TO_255_PKTS 0xc /* enum */
+#define MC_CMD_MAC_TX_256_TO_511_PKTS 0xd /* enum */
+#define MC_CMD_MAC_TX_512_TO_1023_PKTS 0xe /* enum */
+#define MC_CMD_MAC_TX_1024_TO_15XX_PKTS 0xf /* enum */
+#define MC_CMD_MAC_TX_15XX_TO_JUMBO_PKTS 0x10 /* enum */
+#define MC_CMD_MAC_TX_GTJUMBO_PKTS 0x11 /* enum */
+#define MC_CMD_MAC_TX_BAD_FCS_PKTS 0x12 /* enum */
+#define MC_CMD_MAC_TX_SINGLE_COLLISION_PKTS 0x13 /* enum */
+#define MC_CMD_MAC_TX_MULTIPLE_COLLISION_PKTS 0x14 /* enum */
+#define MC_CMD_MAC_TX_EXCESSIVE_COLLISION_PKTS 0x15 /* enum */
+#define MC_CMD_MAC_TX_LATE_COLLISION_PKTS 0x16 /* enum */
+#define MC_CMD_MAC_TX_DEFERRED_PKTS 0x17 /* enum */
+#define MC_CMD_MAC_TX_EXCESSIVE_DEFERRED_PKTS 0x18 /* enum */
+#define MC_CMD_MAC_TX_NON_TCPUDP_PKTS 0x19 /* enum */
+#define MC_CMD_MAC_TX_MAC_SRC_ERR_PKTS 0x1a /* enum */
+#define MC_CMD_MAC_TX_IP_SRC_ERR_PKTS 0x1b /* enum */
+#define MC_CMD_MAC_RX_PKTS 0x1c /* enum */
+#define MC_CMD_MAC_RX_PAUSE_PKTS 0x1d /* enum */
+#define MC_CMD_MAC_RX_GOOD_PKTS 0x1e /* enum */
+#define MC_CMD_MAC_RX_CONTROL_PKTS 0x1f /* enum */
+#define MC_CMD_MAC_RX_UNICAST_PKTS 0x20 /* enum */
+#define MC_CMD_MAC_RX_MULTICAST_PKTS 0x21 /* enum */
+#define MC_CMD_MAC_RX_BROADCAST_PKTS 0x22 /* enum */
+#define MC_CMD_MAC_RX_BYTES 0x23 /* enum */
+#define MC_CMD_MAC_RX_BAD_BYTES 0x24 /* enum */
+#define MC_CMD_MAC_RX_64_PKTS 0x25 /* enum */
+#define MC_CMD_MAC_RX_65_TO_127_PKTS 0x26 /* enum */
+#define MC_CMD_MAC_RX_128_TO_255_PKTS 0x27 /* enum */
+#define MC_CMD_MAC_RX_256_TO_511_PKTS 0x28 /* enum */
+#define MC_CMD_MAC_RX_512_TO_1023_PKTS 0x29 /* enum */
+#define MC_CMD_MAC_RX_1024_TO_15XX_PKTS 0x2a /* enum */
+#define MC_CMD_MAC_RX_15XX_TO_JUMBO_PKTS 0x2b /* enum */
+#define MC_CMD_MAC_RX_GTJUMBO_PKTS 0x2c /* enum */
+#define MC_CMD_MAC_RX_UNDERSIZE_PKTS 0x2d /* enum */
+#define MC_CMD_MAC_RX_BAD_FCS_PKTS 0x2e /* enum */
+#define MC_CMD_MAC_RX_OVERFLOW_PKTS 0x2f /* enum */
+#define MC_CMD_MAC_RX_FALSE_CARRIER_PKTS 0x30 /* enum */
+#define MC_CMD_MAC_RX_SYMBOL_ERROR_PKTS 0x31 /* enum */
+#define MC_CMD_MAC_RX_ALIGN_ERROR_PKTS 0x32 /* enum */
+#define MC_CMD_MAC_RX_LENGTH_ERROR_PKTS 0x33 /* enum */
+#define MC_CMD_MAC_RX_INTERNAL_ERROR_PKTS 0x34 /* enum */
+#define MC_CMD_MAC_RX_JABBER_PKTS 0x35 /* enum */
+#define MC_CMD_MAC_RX_NODESC_DROPS 0x36 /* enum */
+#define MC_CMD_MAC_RX_LANES01_CHAR_ERR 0x37 /* enum */
+#define MC_CMD_MAC_RX_LANES23_CHAR_ERR 0x38 /* enum */
+#define MC_CMD_MAC_RX_LANES01_DISP_ERR 0x39 /* enum */
+#define MC_CMD_MAC_RX_LANES23_DISP_ERR 0x3a /* enum */
+#define MC_CMD_MAC_RX_MATCH_FAULT 0x3b /* enum */
+/* enum: PM trunc_bb_overflow counter. Valid for EF10 with PM_AND_RXDP_COUNTERS
+ * capability only.
+ */
+#define MC_CMD_MAC_PM_TRUNC_BB_OVERFLOW 0x3c
+/* enum: PM discard_bb_overflow counter. Valid for EF10 with
+ * PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_PM_DISCARD_BB_OVERFLOW 0x3d
+/* enum: PM trunc_vfifo_full counter. Valid for EF10 with PM_AND_RXDP_COUNTERS
+ * capability only.
+ */
+#define MC_CMD_MAC_PM_TRUNC_VFIFO_FULL 0x3e
+/* enum: PM discard_vfifo_full counter. Valid for EF10 with
+ * PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_PM_DISCARD_VFIFO_FULL 0x3f
+/* enum: PM trunc_qbb counter. Valid for EF10 with PM_AND_RXDP_COUNTERS
+ * capability only.
+ */
+#define MC_CMD_MAC_PM_TRUNC_QBB 0x40
+/* enum: PM discard_qbb counter. Valid for EF10 with PM_AND_RXDP_COUNTERS
+ * capability only.
+ */
+#define MC_CMD_MAC_PM_DISCARD_QBB 0x41
+/* enum: PM discard_mapping counter. Valid for EF10 with PM_AND_RXDP_COUNTERS
+ * capability only.
+ */
+#define MC_CMD_MAC_PM_DISCARD_MAPPING 0x42
+/* enum: RXDP counter: Number of packets dropped due to the queue being
+ * disabled. Valid for EF10 with PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_RXDP_Q_DISABLED_PKTS 0x43
+/* enum: RXDP counter: Number of packets dropped by the DICPU. Valid for EF10
+ * with PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_RXDP_DI_DROPPED_PKTS 0x45
+/* enum: RXDP counter: Number of non-host packets. Valid for EF10 with
+ * PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_RXDP_STREAMING_PKTS 0x46
+/* enum: RXDP counter: Number of times an hlb descriptor fetch was performed.
+ * Valid for EF10 with PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_RXDP_HLB_FETCH_CONDITIONS 0x47
+/* enum: RXDP counter: Number of times the DPCPU waited for an existing
+ * descriptor fetch. Valid for EF10 with PM_AND_RXDP_COUNTERS capability only.
+ */
+#define MC_CMD_MAC_RXDP_HLB_WAIT_CONDITIONS 0x48
+#define MC_CMD_MAC_VADAPTER_RX_DMABUF_START 0x4c /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_UNICAST_PACKETS 0x4c /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_UNICAST_BYTES 0x4d /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_MULTICAST_PACKETS 0x4e /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_MULTICAST_BYTES 0x4f /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_BROADCAST_PACKETS 0x50 /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_BROADCAST_BYTES 0x51 /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_BAD_PACKETS 0x52 /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_BAD_BYTES 0x53 /* enum */
+#define MC_CMD_MAC_VADAPTER_RX_OVERFLOW 0x54 /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_DMABUF_START 0x57 /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_UNICAST_PACKETS 0x57 /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_UNICAST_BYTES 0x58 /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_MULTICAST_PACKETS 0x59 /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_MULTICAST_BYTES 0x5a /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_BROADCAST_PACKETS 0x5b /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_BROADCAST_BYTES 0x5c /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_BAD_PACKETS 0x5d /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_BAD_BYTES 0x5e /* enum */
+#define MC_CMD_MAC_VADAPTER_TX_OVERFLOW 0x5f /* enum */
+/* enum: Start of GMAC stats buffer space, for Siena only. */
+#define MC_CMD_GMAC_DMABUF_START 0x40
+/* enum: End of GMAC stats buffer space, for Siena only. */
+#define MC_CMD_GMAC_DMABUF_END 0x5f
+/* enum: GENERATION_END value, used together with GENERATION_START to verify
+ * consistency of DMAd data. For legacy firmware / drivers without extended
+ * stats (more precisely, when DMA_LEN == MC_CMD_MAC_NSTATS *
+ * sizeof(uint64_t)), this entry holds the GENERATION_END value. Otherwise,
+ * this value is invalid/ reserved and GENERATION_END is written as the last
+ * 64-bit word of the DMA buffer (at DMA_LEN - sizeof(uint64_t)). Note that
+ * this is consistent with the legacy behaviour, in the sense that entry 96 is
+ * the last 64-bit word in the buffer when DMA_LEN == MC_CMD_MAC_NSTATS *
+ * sizeof(uint64_t). See SF-109306-TC, Section 9.2 for details.
+ */
+#define MC_CMD_MAC_GENERATION_END 0x60
+#define MC_CMD_MAC_NSTATS 0x61 /* enum */
+
+/* MC_CMD_MAC_STATS_V2_OUT_DMA msgresponse */
+#define MC_CMD_MAC_STATS_V2_OUT_DMA_LEN 0
+
+/* MC_CMD_MAC_STATS_V2_OUT_NO_DMA msgresponse */
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_LEN (((MC_CMD_MAC_NSTATS_V2 * 64)) >> 3)
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_OFST 0
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_LEN 8
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_LO_OFST 0
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_LO_LEN 4
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_LO_LBN 0
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_LO_WIDTH 32
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_HI_OFST 4
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_HI_LEN 4
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_HI_LBN 32
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_HI_WIDTH 32
+#define MC_CMD_MAC_STATS_V2_OUT_NO_DMA_STATISTICS_NUM MC_CMD_MAC_NSTATS_V2
+/* enum: Start of FEC stats buffer space, Medford2 and up */
+#define MC_CMD_MAC_FEC_DMABUF_START 0x61
+/* enum: Number of uncorrected FEC codewords on link (RS-FEC only for Medford2)
+ */
+#define MC_CMD_MAC_FEC_UNCORRECTED_ERRORS 0x61
+/* enum: Number of corrected FEC codewords on link (RS-FEC only for Medford2)
+ */
+#define MC_CMD_MAC_FEC_CORRECTED_ERRORS 0x62
+/* enum: Number of corrected 10-bit symbol errors, lane 0 (RS-FEC only) */
+#define MC_CMD_MAC_FEC_CORRECTED_SYMBOLS_LANE0 0x63
+/* enum: Number of corrected 10-bit symbol errors, lane 1 (RS-FEC only) */
+#define MC_CMD_MAC_FEC_CORRECTED_SYMBOLS_LANE1 0x64
+/* enum: Number of corrected 10-bit symbol errors, lane 2 (RS-FEC only) */
+#define MC_CMD_MAC_FEC_CORRECTED_SYMBOLS_LANE2 0x65
+/* enum: Number of corrected 10-bit symbol errors, lane 3 (RS-FEC only) */
+#define MC_CMD_MAC_FEC_CORRECTED_SYMBOLS_LANE3 0x66
+/* enum: This includes the space at offset 103 which is the final
+ * GENERATION_END in a MAC_STATS_V2 response and otherwise unused.
+ */
+#define MC_CMD_MAC_NSTATS_V2 0x68
+/* Other enum values, see field(s): */
+/* MC_CMD_MAC_STATS_OUT_NO_DMA/STATISTICS */
+
+/* MC_CMD_MAC_STATS_V3_OUT_DMA msgresponse */
+#define MC_CMD_MAC_STATS_V3_OUT_DMA_LEN 0
+
+/* MC_CMD_MAC_STATS_V3_OUT_NO_DMA msgresponse */
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_LEN (((MC_CMD_MAC_NSTATS_V3 * 64)) >> 3)
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_OFST 0
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_LEN 8
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_LO_OFST 0
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_LO_LEN 4
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_LO_LBN 0
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_LO_WIDTH 32
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_HI_OFST 4
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_HI_LEN 4
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_HI_LBN 32
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_HI_WIDTH 32
+#define MC_CMD_MAC_STATS_V3_OUT_NO_DMA_STATISTICS_NUM MC_CMD_MAC_NSTATS_V3
+/* enum: Start of CTPIO stats buffer space, Medford2 and up */
+#define MC_CMD_MAC_CTPIO_DMABUF_START 0x68
+/* enum: Number of CTPIO fallbacks because a DMA packet was in progress on the
+ * target VI
+ */
+#define MC_CMD_MAC_CTPIO_VI_BUSY_FALLBACK 0x68
+/* enum: Number of times a CTPIO send wrote beyond frame end (informational
+ * only)
+ */
+#define MC_CMD_MAC_CTPIO_LONG_WRITE_SUCCESS 0x69
+/* enum: Number of CTPIO failures because the TX doorbell was written before
+ * the end of the frame data
+ */
+#define MC_CMD_MAC_CTPIO_MISSING_DBELL_FAIL 0x6a
+/* enum: Number of CTPIO failures because the internal FIFO overflowed */
+#define MC_CMD_MAC_CTPIO_OVERFLOW_FAIL 0x6b
+/* enum: Number of CTPIO failures because the host did not deliver data fast
+ * enough to avoid MAC underflow
+ */
+#define MC_CMD_MAC_CTPIO_UNDERFLOW_FAIL 0x6c
+/* enum: Number of CTPIO failures because the host did not deliver all the
+ * frame data within the timeout
+ */
+#define MC_CMD_MAC_CTPIO_TIMEOUT_FAIL 0x6d
+/* enum: Number of CTPIO failures because the frame data arrived out of order
+ * or with gaps
+ */
+#define MC_CMD_MAC_CTPIO_NONCONTIG_WR_FAIL 0x6e
+/* enum: Number of CTPIO failures because the host started a new frame before
+ * completing the previous one
+ */
+#define MC_CMD_MAC_CTPIO_FRM_CLOBBER_FAIL 0x6f
+/* enum: Number of CTPIO failures because a write was not a multiple of 32 bits
+ * or not 32-bit aligned
+ */
+#define MC_CMD_MAC_CTPIO_INVALID_WR_FAIL 0x70
+/* enum: Number of CTPIO fallbacks because another VI on the same port was
+ * sending a CTPIO frame
+ */
+#define MC_CMD_MAC_CTPIO_VI_CLOBBER_FALLBACK 0x71
+/* enum: Number of CTPIO fallbacks because target VI did not have CTPIO enabled
+ */
+#define MC_CMD_MAC_CTPIO_UNQUALIFIED_FALLBACK 0x72
+/* enum: Number of CTPIO fallbacks because length in header was less than 29
+ * bytes
+ */
+#define MC_CMD_MAC_CTPIO_RUNT_FALLBACK 0x73
+/* enum: Total number of successful CTPIO sends on this port */
+#define MC_CMD_MAC_CTPIO_SUCCESS 0x74
+/* enum: Total number of CTPIO fallbacks on this port */
+#define MC_CMD_MAC_CTPIO_FALLBACK 0x75
+/* enum: Total number of CTPIO poisoned frames on this port, whether erased or
+ * not
+ */
+#define MC_CMD_MAC_CTPIO_POISON 0x76
+/* enum: Total number of CTPIO erased frames on this port */
+#define MC_CMD_MAC_CTPIO_ERASE 0x77
+/* enum: This includes the space at offset 120 which is the final
+ * GENERATION_END in a MAC_STATS_V3 response and otherwise unused.
+ */
+#define MC_CMD_MAC_NSTATS_V3 0x79
+/* Other enum values, see field(s): */
+/* MC_CMD_MAC_STATS_V2_OUT_NO_DMA/STATISTICS */
+
+/* MC_CMD_MAC_STATS_V4_OUT_DMA msgresponse */
+#define MC_CMD_MAC_STATS_V4_OUT_DMA_LEN 0
+
+/* MC_CMD_MAC_STATS_V4_OUT_NO_DMA msgresponse */
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_LEN (((MC_CMD_MAC_NSTATS_V4 * 64)) >> 3)
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_OFST 0
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LEN 8
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LO_OFST 0
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LO_LEN 4
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LO_LBN 0
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_LO_WIDTH 32
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_HI_OFST 4
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_HI_LEN 4
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_HI_LBN 32
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_HI_WIDTH 32
+#define MC_CMD_MAC_STATS_V4_OUT_NO_DMA_STATISTICS_NUM MC_CMD_MAC_NSTATS_V4
+/* enum: Start of V4 stats buffer space */
+#define MC_CMD_MAC_V4_DMABUF_START 0x79
+/* enum: RXDP counter: Number of packets truncated because scattering was
+ * disabled.
+ */
+#define MC_CMD_MAC_RXDP_SCATTER_DISABLED_TRUNC 0x79
+/* enum: RXDP counter: Number of times the RXDP head of line blocked waiting
+ * for descriptors. Will be zero unless RXDP_HLB_IDLE capability is set.
+ */
+#define MC_CMD_MAC_RXDP_HLB_IDLE 0x7a
+/* enum: RXDP counter: Number of times the RXDP timed out while head of line
+ * blocking. Will be zero unless RXDP_HLB_IDLE capability is set.
+ */
+#define MC_CMD_MAC_RXDP_HLB_TIMEOUT 0x7b
+/* enum: This includes the space at offset 124 which is the final
+ * GENERATION_END in a MAC_STATS_V4 response and otherwise unused.
+ */
+#define MC_CMD_MAC_NSTATS_V4 0x7d
+/* Other enum values, see field(s): */
+/* MC_CMD_MAC_STATS_V3_OUT_NO_DMA/STATISTICS */
+/***********************************/
+/* MC_CMD_NVRAM_TYPES
+ * Return bitfield indicating available types of virtual NVRAM partitions.
+ * Locks required: none. Returns: 0
+ */
+#define MC_CMD_NVRAM_TYPES 0x36
+#define MC_CMD_NVRAM_TYPES_MSGSET 0x36
+
+/* MC_CMD_NVRAM_TYPES_IN msgrequest */
+#define MC_CMD_NVRAM_TYPES_IN_LEN 0
+
+/* MC_CMD_NVRAM_TYPES_OUT msgresponse */
+#define MC_CMD_NVRAM_TYPES_OUT_LEN 4
+/* Bit mask of supported types. */
+#define MC_CMD_NVRAM_TYPES_OUT_TYPES_OFST 0
+#define MC_CMD_NVRAM_TYPES_OUT_TYPES_LEN 4
+/* enum: Disabled callisto. */
+#define MC_CMD_NVRAM_TYPE_DISABLED_CALLISTO 0x0
+/* enum: MC firmware. */
+#define MC_CMD_NVRAM_TYPE_MC_FW 0x1
+/* enum: MC backup firmware. */
+#define MC_CMD_NVRAM_TYPE_MC_FW_BACKUP 0x2
+/* enum: Static configuration Port0. */
+#define MC_CMD_NVRAM_TYPE_STATIC_CFG_PORT0 0x3
+/* enum: Static configuration Port1. */
+#define MC_CMD_NVRAM_TYPE_STATIC_CFG_PORT1 0x4
+/* enum: Dynamic configuration Port0. */
+#define MC_CMD_NVRAM_TYPE_DYNAMIC_CFG_PORT0 0x5
+/* enum: Dynamic configuration Port1. */
+#define MC_CMD_NVRAM_TYPE_DYNAMIC_CFG_PORT1 0x6
+/* enum: Expansion Rom. */
+#define MC_CMD_NVRAM_TYPE_EXP_ROM 0x7
+/* enum: Expansion Rom Configuration Port0. */
+#define MC_CMD_NVRAM_TYPE_EXP_ROM_CFG_PORT0 0x8
+/* enum: Expansion Rom Configuration Port1. */
+#define MC_CMD_NVRAM_TYPE_EXP_ROM_CFG_PORT1 0x9
+/* enum: Phy Configuration Port0. */
+#define MC_CMD_NVRAM_TYPE_PHY_PORT0 0xa
+/* enum: Phy Configuration Port1. */
+#define MC_CMD_NVRAM_TYPE_PHY_PORT1 0xb
+/* enum: Log. */
+#define MC_CMD_NVRAM_TYPE_LOG 0xc
+/* enum: FPGA image. */
+#define MC_CMD_NVRAM_TYPE_FPGA 0xd
+/* enum: FPGA backup image */
+#define MC_CMD_NVRAM_TYPE_FPGA_BACKUP 0xe
+/* enum: FC firmware. */
+#define MC_CMD_NVRAM_TYPE_FC_FW 0xf
+/* enum: FC backup firmware. */
+#define MC_CMD_NVRAM_TYPE_FC_FW_BACKUP 0x10
+/* enum: CPLD image. */
+#define MC_CMD_NVRAM_TYPE_CPLD 0x11
+/* enum: Licensing information. */
+#define MC_CMD_NVRAM_TYPE_LICENSE 0x12
+/* enum: FC Log. */
+#define MC_CMD_NVRAM_TYPE_FC_LOG 0x13
+/* enum: Additional flash on FPGA. */
+#define MC_CMD_NVRAM_TYPE_FC_EXTRA 0x14
+
+/***********************************/
+/* MC_CMD_NVRAM_INFO
+ * Read info about a virtual NVRAM partition. Locks required: none. Returns: 0,
+ * EINVAL (bad type).
+ */
+#define MC_CMD_NVRAM_INFO 0x37
+#define MC_CMD_NVRAM_INFO_MSGSET 0x37
+
+/* MC_CMD_NVRAM_INFO_IN msgrequest */
+#define MC_CMD_NVRAM_INFO_IN_LEN 4
+#define MC_CMD_NVRAM_INFO_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_INFO_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+
+/* MC_CMD_NVRAM_INFO_OUT msgresponse */
+#define MC_CMD_NVRAM_INFO_OUT_LEN 24
+/* MC_CMD_NVRAM_INFO_V2_OUT msgresponse */
+#define MC_CMD_NVRAM_INFO_V2_OUT_LEN 28
+#define MC_CMD_NVRAM_INFO_V2_OUT_TYPE_OFST 0
+#define MC_CMD_NVRAM_INFO_V2_OUT_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+#define MC_CMD_NVRAM_INFO_V2_OUT_SIZE_OFST 4
+#define MC_CMD_NVRAM_INFO_V2_OUT_SIZE_LEN 4
+#define MC_CMD_NVRAM_INFO_V2_OUT_ERASESIZE_OFST 8
+#define MC_CMD_NVRAM_INFO_V2_OUT_ERASESIZE_LEN 4
+#define MC_CMD_NVRAM_INFO_V2_OUT_FLAGS_OFST 12
+#define MC_CMD_NVRAM_INFO_V2_OUT_FLAGS_LEN 4
+#define MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_OFST 12
+#define MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_LBN 0
+#define MC_CMD_NVRAM_INFO_V2_OUT_PROTECTED_WIDTH 1
+#define MC_CMD_NVRAM_INFO_V2_OUT_TLV_OFST 12
+#define MC_CMD_NVRAM_INFO_V2_OUT_TLV_LBN 1
+#define MC_CMD_NVRAM_INFO_V2_OUT_TLV_WIDTH 1
+#define MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_IF_TSA_BOUND_OFST 12
+#define MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_IF_TSA_BOUND_LBN 2
+#define MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_IF_TSA_BOUND_WIDTH 1
+#define MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_OFST 12
+#define MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_LBN 5
+#define MC_CMD_NVRAM_INFO_V2_OUT_READ_ONLY_WIDTH 1
+#define MC_CMD_NVRAM_INFO_V2_OUT_A_B_OFST 12
+#define MC_CMD_NVRAM_INFO_V2_OUT_A_B_LBN 7
+#define MC_CMD_NVRAM_INFO_V2_OUT_A_B_WIDTH 1
+#define MC_CMD_NVRAM_INFO_V2_OUT_PHYSDEV_OFST 16
+#define MC_CMD_NVRAM_INFO_V2_OUT_PHYSDEV_LEN 4
+#define MC_CMD_NVRAM_INFO_V2_OUT_PHYSADDR_OFST 20
+#define MC_CMD_NVRAM_INFO_V2_OUT_PHYSADDR_LEN 4
+/* Writes must be multiples of this size. Added to support the MUM on Sorrento.
+ */
+#define MC_CMD_NVRAM_INFO_V2_OUT_WRITESIZE_OFST 24
+#define MC_CMD_NVRAM_INFO_V2_OUT_WRITESIZE_LEN 4
+
+/***********************************/
+/* MC_CMD_NVRAM_UPDATE_START
+ * Start a group of update operations on a virtual NVRAM partition. Locks
+ * required: PHY_LOCK if type==*PHY*. Returns: 0, EINVAL (bad type), EACCES (if
+ * PHY_LOCK required and not held). In an adapter bound to a TSA controller,
+ * MC_CMD_NVRAM_UPDATE_START can only be used on a subset of partition types
+ * i.e. static config, dynamic config and expansion ROM config. Attempting to
+ * perform this operation on a restricted partition will return the error
+ * EPERM.
+ */
+#define MC_CMD_NVRAM_UPDATE_START 0x38
+#define MC_CMD_NVRAM_UPDATE_START_MSGSET 0x38
+
+/* MC_CMD_NVRAM_UPDATE_START_IN msgrequest: Legacy NVRAM_UPDATE_START request.
+ * Use NVRAM_UPDATE_START_V2_IN in new code
+ */
+#define MC_CMD_NVRAM_UPDATE_START_IN_LEN 4
+#define MC_CMD_NVRAM_UPDATE_START_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_UPDATE_START_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+
+/* MC_CMD_NVRAM_UPDATE_START_V2_IN msgrequest: Extended NVRAM_UPDATE_START
+ * request with additional flags indicating version of command in use. See
+ * MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT for details of extended functionality. Use
+ * paired up with NVRAM_UPDATE_FINISH_V2_IN.
+ */
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_LEN 8
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAGS_OFST 4
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAGS_LEN 4
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT_OFST 4
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT_LBN 0
+#define MC_CMD_NVRAM_UPDATE_START_V2_IN_FLAG_REPORT_VERIFY_RESULT_WIDTH 1
+
+/* MC_CMD_NVRAM_UPDATE_START_OUT msgresponse */
+#define MC_CMD_NVRAM_UPDATE_START_OUT_LEN 0
+/***********************************/
+/* MC_CMD_NVRAM_WRITE
+ * Write data to a virtual NVRAM partition. Locks required: PHY_LOCK if
+ * type==*PHY*. Returns: 0, EINVAL (bad type/offset/length), EACCES (if
+ * PHY_LOCK required and not held)
+ */
+#define MC_CMD_NVRAM_WRITE 0x3a
+#define MC_CMD_NVRAM_WRITE_MSGSET 0x3a
+
+/* MC_CMD_NVRAM_WRITE_IN msgrequest */
+#define MC_CMD_NVRAM_WRITE_IN_LENMIN 13
+#define MC_CMD_NVRAM_WRITE_IN_LENMAX 252
+#define MC_CMD_NVRAM_WRITE_IN_LENMAX_MCDI2 1020
+#define MC_CMD_NVRAM_WRITE_IN_LEN(num) (12 + 1 * (num))
+#define MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_NUM(len) (((len) - 12) / 1)
+#define MC_CMD_NVRAM_WRITE_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_WRITE_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+#define MC_CMD_NVRAM_WRITE_IN_OFFSET_OFST 4
+#define MC_CMD_NVRAM_WRITE_IN_OFFSET_LEN 4
+#define MC_CMD_NVRAM_WRITE_IN_LENGTH_OFST 8
+#define MC_CMD_NVRAM_WRITE_IN_LENGTH_LEN 4
+#define MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_OFST 12
+#define MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_LEN 1
+#define MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MINNUM 1
+#define MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MAXNUM 240
+#define MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MAXNUM_MCDI2 1008
+
+/* MC_CMD_NVRAM_WRITE_OUT msgresponse */
+#define MC_CMD_NVRAM_WRITE_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_NVRAM_ERASE
+ * Erase sector(s) from a virtual NVRAM partition. Locks required: PHY_LOCK if
+ * type==*PHY*. Returns: 0, EINVAL (bad type/offset/length), EACCES (if
+ * PHY_LOCK required and not held)
+ */
+#define MC_CMD_NVRAM_ERASE 0x3b
+#define MC_CMD_NVRAM_ERASE_MSGSET 0x3b
+
+/* MC_CMD_NVRAM_ERASE_IN msgrequest */
+#define MC_CMD_NVRAM_ERASE_IN_LEN 12
+#define MC_CMD_NVRAM_ERASE_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_ERASE_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+#define MC_CMD_NVRAM_ERASE_IN_OFFSET_OFST 4
+#define MC_CMD_NVRAM_ERASE_IN_OFFSET_LEN 4
+#define MC_CMD_NVRAM_ERASE_IN_LENGTH_OFST 8
+#define MC_CMD_NVRAM_ERASE_IN_LENGTH_LEN 4
+
+/* MC_CMD_NVRAM_ERASE_OUT msgresponse */
+#define MC_CMD_NVRAM_ERASE_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_NVRAM_UPDATE_FINISH
+ * Finish a group of update operations on a virtual NVRAM partition. Locks
+ * required: PHY_LOCK if type==*PHY*. Returns: 0, EINVAL (bad type/offset/
+ * length), EACCES (if PHY_LOCK required and not held). In an adapter bound to
+ * a TSA controller, MC_CMD_NVRAM_UPDATE_FINISH can only be used on a subset of
+ * partition types i.e. static config, dynamic config and expansion ROM config.
+ * Attempting to perform this operation on a restricted partition will return
+ * the error EPERM.
+ */
+#define MC_CMD_NVRAM_UPDATE_FINISH 0x3c
+#define MC_CMD_NVRAM_UPDATE_FINISH_MSGSET 0x3c
+
+/* MC_CMD_NVRAM_UPDATE_FINISH_IN msgrequest: Legacy NVRAM_UPDATE_FINISH
+ * request. Use NVRAM_UPDATE_FINISH_V2_IN in new code
+ */
+#define MC_CMD_NVRAM_UPDATE_FINISH_IN_LEN 8
+#define MC_CMD_NVRAM_UPDATE_FINISH_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_UPDATE_FINISH_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+#define MC_CMD_NVRAM_UPDATE_FINISH_IN_REBOOT_OFST 4
+#define MC_CMD_NVRAM_UPDATE_FINISH_IN_REBOOT_LEN 4
+
+/* MC_CMD_NVRAM_UPDATE_FINISH_V2_IN msgrequest: Extended NVRAM_UPDATE_FINISH
+ * request with additional flags indicating version of NVRAM_UPDATE commands in
+ * use. See MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT for details of extended
+ * functionality. Use paired up with NVRAM_UPDATE_START_V2_IN.
+ */
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_LEN 12
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_TYPE_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_NVRAM_TYPES/MC_CMD_NVRAM_TYPES_OUT/TYPES */
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_REBOOT_OFST 4
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_REBOOT_LEN 4
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAGS_OFST 8
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAGS_LEN 4
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT_OFST 8
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT_LBN 0
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT_WIDTH 1
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND_OFST 8
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND_LBN 1
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_RUN_IN_BACKGROUND_WIDTH 1
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT_OFST 8
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT_LBN 2
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_POLL_VERIFY_RESULT_WIDTH 1
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_ABORT_OFST 8
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_ABORT_LBN 3
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_IN_FLAG_ABORT_WIDTH 1
+
+/* MC_CMD_NVRAM_UPDATE_FINISH_OUT msgresponse: Legacy NVRAM_UPDATE_FINISH
+ * response. Use NVRAM_UPDATE_FINISH_V2_OUT in new code
+ */
+#define MC_CMD_NVRAM_UPDATE_FINISH_OUT_LEN 0
+
+/* MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT msgresponse:
+ *
+ * Extended NVRAM_UPDATE_FINISH response that communicates the result of secure
+ * firmware validation where applicable back to the host.
+ *
+ * Medford only: For signed firmware images, such as those for medford, the MC
+ * firmware verifies the signature before marking the firmware image as valid.
+ * This process takes a few seconds to complete. So is likely to take more than
+ * the MCDI timeout. Hence signature verification is initiated when
+ * MC_CMD_NVRAM_UPDATE_FINISH_V2_IN is received by the firmware, however, the
+ * MCDI command is run in a background MCDI processing thread. This response
+ * payload includes the results of the signature verification. Note that the
+ * per-partition nvram lock in firmware is only released after the verification
+ * has completed.
+ */
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_LEN 4
+/* Result of nvram update completion processing. Result codes that indicate an
+ * internal build failure and therefore not expected to be seen by customers in
+ * the field are marked with a prefix 'Internal-error'.
+ */
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_RESULT_CODE_OFST 0
+#define MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_RESULT_CODE_LEN 4
+/* enum: Invalid return code; only non-zero values are defined. Defined as
+ * unknown for backwards compatibility with NVRAM_UPDATE_FINISH_OUT.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_UNKNOWN 0x0
+/* enum: Verify succeeded without any errors. */
+#define MC_CMD_NVRAM_VERIFY_RC_SUCCESS 0x1
+/* enum: CMS format verification failed due to an internal error. */
+#define MC_CMD_NVRAM_VERIFY_RC_CMS_CHECK_FAILED 0x2
+/* enum: Invalid CMS format in image metadata. */
+#define MC_CMD_NVRAM_VERIFY_RC_INVALID_CMS_FORMAT 0x3
+/* enum: Message digest verification failed due to an internal error. */
+#define MC_CMD_NVRAM_VERIFY_RC_MESSAGE_DIGEST_CHECK_FAILED 0x4
+/* enum: Error in message digest calculated over the reflash-header, payload
+ * and reflash-trailer.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BAD_MESSAGE_DIGEST 0x5
+/* enum: Signature verification failed due to an internal error. */
+#define MC_CMD_NVRAM_VERIFY_RC_SIGNATURE_CHECK_FAILED 0x6
+/* enum: There are no valid signatures in the image. */
+#define MC_CMD_NVRAM_VERIFY_RC_NO_VALID_SIGNATURES 0x7
+/* enum: Trusted approvers verification failed due to an internal error. */
+#define MC_CMD_NVRAM_VERIFY_RC_TRUSTED_APPROVERS_CHECK_FAILED 0x8
+/* enum: The Trusted approver's list is empty. */
+#define MC_CMD_NVRAM_VERIFY_RC_NO_TRUSTED_APPROVERS 0x9
+/* enum: Signature chain verification failed due to an internal error. */
+#define MC_CMD_NVRAM_VERIFY_RC_SIGNATURE_CHAIN_CHECK_FAILED 0xa
+/* enum: The signers of the signatures in the image are not listed in the
+ * Trusted approver's list.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_NO_SIGNATURE_MATCH 0xb
+/* enum: The image contains a test-signed certificate, but the adapter accepts
+ * only production signed images.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_REJECT_TEST_SIGNED 0xc
+/* enum: The image has a lower security level than the current firmware. */
+#define MC_CMD_NVRAM_VERIFY_RC_SECURITY_LEVEL_DOWNGRADE 0xd
+/* enum: Internal-error. The signed image is missing the 'contents' section,
+ * where the 'contents' section holds the actual image payload to be applied.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_CONTENT_NOT_FOUND 0xe
+/* enum: Internal-error. The bundle header is invalid. */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_CONTENT_HEADER_INVALID 0xf
+/* enum: Internal-error. The bundle does not have a valid reflash image layout.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_REFLASH_IMAGE_INVALID 0x10
+/* enum: Internal-error. The bundle has an inconsistent layout of components or
+ * incorrect checksum.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_IMAGE_LAYOUT_INVALID 0x11
+/* enum: Internal-error. The bundle manifest is inconsistent with components in
+ * the bundle.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_INVALID 0x12
+/* enum: Internal-error. The number of components in a bundle do not match the
+ * number of components advertised by the bundle manifest.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_NUM_COMPONENTS_MISMATCH 0x13
+/* enum: Internal-error. The bundle contains too many components for the MC
+ * firmware to process
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_TOO_MANY_COMPONENTS 0x14
+/* enum: Internal-error. The bundle manifest has an invalid/inconsistent
+ * component.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_COMPONENT_INVALID 0x15
+/* enum: Internal-error. The hash of a component does not match the hash stored
+ * in the bundle manifest.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_COMPONENT_HASH_MISMATCH 0x16
+/* enum: Internal-error. Component hash calculation failed. */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_MANIFEST_COMPONENT_HASH_FAILED 0x17
+/* enum: Internal-error. The component does not have a valid reflash image
+ * layout.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_COMPONENT_REFLASH_IMAGE_INVALID 0x18
+/* enum: The bundle processing code failed to copy a component to its target
+ * partition.
+ */
+#define MC_CMD_NVRAM_VERIFY_RC_BUNDLE_COMPONENT_COPY_FAILED 0x19
+/* enum: The update operation is in-progress. */
+#define MC_CMD_NVRAM_VERIFY_RC_PENDING 0x1a
+
+/***********************************/
+/* MC_CMD_REBOOT
+ * Reboot the MC.
+ *
+ * The AFTER_ASSERTION flag is intended to be used when the driver notices an
+ * assertion failure (at which point it is expected to perform a complete tear
+ * down and reinitialise), to allow both ports to reset the MC once in an
+ * atomic fashion.
+ *
+ * Production mc firmwares are generally compiled with REBOOT_ON_ASSERT=1,
+ * which means that they will automatically reboot out of the assertion
+ * handler, so this is in practise an optional operation. It is still
+ * recommended that drivers execute this to support custom firmwares with
+ * REBOOT_ON_ASSERT=0.
+ *
+ * Locks required: NONE Returns: Nothing. You get back a response with ERR=1,
+ * DATALEN=0
+ */
+#define MC_CMD_REBOOT 0x3d
+#define MC_CMD_REBOOT_MSGSET 0x3d
+
+/* MC_CMD_REBOOT_IN msgrequest */
+#define MC_CMD_REBOOT_IN_LEN 4
+#define MC_CMD_REBOOT_IN_FLAGS_OFST 0
+#define MC_CMD_REBOOT_IN_FLAGS_LEN 4
+#define MC_CMD_REBOOT_FLAGS_AFTER_ASSERTION 0x1 /* enum */
+
+/* MC_CMD_REBOOT_OUT msgresponse */
+#define MC_CMD_REBOOT_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_SCHEDINFO
+ * Request scheduler info. Locks required: NONE. Returns: An array of
+ * (timeslice,maximum overrun), one for each thread, in ascending order of
+ * thread address.
+ */
+#define MC_CMD_SCHEDINFO 0x3e
+#define MC_CMD_SCHEDINFO_MSGSET 0x3e
+
+/* MC_CMD_SCHEDINFO_IN msgrequest */
+#define MC_CMD_SCHEDINFO_IN_LEN 0
+
+/* MC_CMD_SCHEDINFO_OUT msgresponse */
+#define MC_CMD_SCHEDINFO_OUT_LENMIN 4
+#define MC_CMD_SCHEDINFO_OUT_LENMAX 252
+#define MC_CMD_SCHEDINFO_OUT_LENMAX_MCDI2 1020
+#define MC_CMD_SCHEDINFO_OUT_LEN(num) (0 + 4 * (num))
+#define MC_CMD_SCHEDINFO_OUT_DATA_NUM(len) (((len) - 0) / 4)
+#define MC_CMD_SCHEDINFO_OUT_DATA_OFST 0
+#define MC_CMD_SCHEDINFO_OUT_DATA_LEN 4
+#define MC_CMD_SCHEDINFO_OUT_DATA_MINNUM 1
+#define MC_CMD_SCHEDINFO_OUT_DATA_MAXNUM 63
+#define MC_CMD_SCHEDINFO_OUT_DATA_MAXNUM_MCDI2 255
+
+/***********************************/
+/* MC_CMD_REBOOT_MODE
+ * Set the mode for the next MC reboot. Locks required: NONE. Sets the reboot
+ * mode to the specified value. Returns the old mode.
+ */
+#define MC_CMD_REBOOT_MODE 0x3f
+#define MC_CMD_REBOOT_MODE_MSGSET 0x3f
+
+/* MC_CMD_REBOOT_MODE_IN msgrequest */
+#define MC_CMD_REBOOT_MODE_IN_LEN 4
+#define MC_CMD_REBOOT_MODE_IN_VALUE_OFST 0
+#define MC_CMD_REBOOT_MODE_IN_VALUE_LEN 4
+/* enum: Normal. */
+#define MC_CMD_REBOOT_MODE_NORMAL 0x0
+/* enum: Power-on Reset. */
+#define MC_CMD_REBOOT_MODE_POR 0x2
+/* enum: Snapper. */
+#define MC_CMD_REBOOT_MODE_SNAPPER 0x3
+/* enum: snapper fake POR */
+#define MC_CMD_REBOOT_MODE_SNAPPER_POR 0x4
+#define MC_CMD_REBOOT_MODE_IN_FAKE_OFST 0
+#define MC_CMD_REBOOT_MODE_IN_FAKE_LBN 7
+#define MC_CMD_REBOOT_MODE_IN_FAKE_WIDTH 1
+
+/* MC_CMD_REBOOT_MODE_OUT msgresponse */
+#define MC_CMD_REBOOT_MODE_OUT_LEN 4
+#define MC_CMD_REBOOT_MODE_OUT_VALUE_OFST 0
+#define MC_CMD_REBOOT_MODE_OUT_VALUE_LEN 4
+/* MC_CMD_READ_SENSORS_OUT msgresponse */
+#define MC_CMD_READ_SENSORS_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_GET_PHY_STATE
+ * Report current state of PHY. A 'zombie' PHY is a PHY that has failed to boot
+ * (e.g. due to missing or corrupted firmware). Locks required: None. Return
+ * code: 0
+ */
+#define MC_CMD_GET_PHY_STATE 0x43
+#define MC_CMD_GET_PHY_STATE_MSGSET 0x43
+
+/* MC_CMD_GET_PHY_STATE_IN msgrequest */
+#define MC_CMD_GET_PHY_STATE_IN_LEN 0
+
+/* MC_CMD_GET_PHY_STATE_OUT msgresponse */
+#define MC_CMD_GET_PHY_STATE_OUT_LEN 4
+#define MC_CMD_GET_PHY_STATE_OUT_STATE_OFST 0
+#define MC_CMD_GET_PHY_STATE_OUT_STATE_LEN 4
+/* enum: Ok. */
+#define MC_CMD_PHY_STATE_OK 0x1
+/* enum: Faulty. */
+#define MC_CMD_PHY_STATE_ZOMBIE 0x2
+/***********************************/
+/* MC_CMD_GET_PHY_MEDIA_INFO
+ * Read media-specific data from PHY (e.g. SFP/SFP+ module ID information for
+ * SFP+ PHYs). The "media type" can be found via GET_PHY_CFG
+ * (GET_PHY_CFG_OUT_MEDIA_TYPE); the valid "page number" input values, and the
+ * output data, are interpreted on a per-type basis. For SFP+, PAGE=0 or 1
+ * returns a 128-byte block read from module I2C address 0xA0 offset 0 or 0x80.
+ * For QSFP, PAGE=-1 is the lower (unbanked) page. PAGE=2 is the EEPROM and
+ * PAGE=3 is the module limits. For DSFP, module addressing requires a
+ * "BANK:PAGE". Not every bank has the same number of pages. See the Common
+ * Management Interface Specification (CMIS) for further details. A BANK:PAGE
+ * of "0xffff:0xffff" retrieves the lower (unbanked) page. Locks required -
+ * None. Return code - 0.
+ */
+#define MC_CMD_GET_PHY_MEDIA_INFO 0x4b
+#define MC_CMD_GET_PHY_MEDIA_INFO_MSGSET 0x4b
+
+/* MC_CMD_GET_PHY_MEDIA_INFO_IN msgrequest */
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_LEN 4
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_PAGE_OFST 0
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_PAGE_LEN 4
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_PAGE_OFST 0
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_PAGE_LBN 0
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_PAGE_WIDTH 16
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_BANK_OFST 0
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_BANK_LBN 16
+#define MC_CMD_GET_PHY_MEDIA_INFO_IN_DSFP_BANK_WIDTH 16
+
+/* MC_CMD_GET_PHY_MEDIA_INFO_OUT msgresponse */
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMIN 5
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX 252
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX_MCDI2 1020
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_LEN(num) (4 + 1 * (num))
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_NUM(len) (((len) - 4) / 1)
+/* in bytes */
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATALEN_OFST 0
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATALEN_LEN 4
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_OFST 4
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_LEN 1
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_MINNUM 1
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_MAXNUM 248
+#define MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_MAXNUM_MCDI2 1016
+/***********************************/
+/* MC_CMD_NVRAM_METADATA
+ * Reads soft metadata for a virtual NVRAM partition type. Locks required:
+ * none. Returns: 0, EINVAL (bad type).
+ */
+#define MC_CMD_NVRAM_METADATA 0x52
+#define MC_CMD_NVRAM_METADATA_MSGSET 0x52
+
+/* MC_CMD_NVRAM_METADATA_IN msgrequest */
+#define MC_CMD_NVRAM_METADATA_IN_LEN 4
+/* Partition type ID code */
+#define MC_CMD_NVRAM_METADATA_IN_TYPE_OFST 0
+#define MC_CMD_NVRAM_METADATA_IN_TYPE_LEN 4
+
+/* MC_CMD_NVRAM_METADATA_OUT msgresponse */
+#define MC_CMD_NVRAM_METADATA_OUT_LENMIN 20
+#define MC_CMD_NVRAM_METADATA_OUT_LENMAX 252
+#define MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2 1020
+#define MC_CMD_NVRAM_METADATA_OUT_LEN(num) (20 + 1 * (num))
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(len) (((len) - 20) / 1)
+/* Partition type ID code */
+#define MC_CMD_NVRAM_METADATA_OUT_TYPE_OFST 0
+#define MC_CMD_NVRAM_METADATA_OUT_TYPE_LEN 4
+#define MC_CMD_NVRAM_METADATA_OUT_FLAGS_OFST 4
+#define MC_CMD_NVRAM_METADATA_OUT_FLAGS_LEN 4
+#define MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_OFST 4
+#define MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN 0
+#define MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_WIDTH 1
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_OFST 4
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN 1
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_WIDTH 1
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_OFST 4
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN 2
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_WIDTH 1
+/* Subtype ID code for content of this partition */
+#define MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_OFST 8
+#define MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_LEN 4
+/* 1st component of W.X.Y.Z version number for content of this partition */
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_W_OFST 12
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_W_LEN 2
+/* 2nd component of W.X.Y.Z version number for content of this partition */
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_X_OFST 14
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_X_LEN 2
+/* 3rd component of W.X.Y.Z version number for content of this partition */
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_Y_OFST 16
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_Y_LEN 2
+/* 4th component of W.X.Y.Z version number for content of this partition */
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_Z_OFST 18
+#define MC_CMD_NVRAM_METADATA_OUT_VERSION_Z_LEN 2
+/* Zero-terminated string describing the content of this partition */
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_OFST 20
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_LEN 1
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MINNUM 0
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM 232
+#define MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2 1000
+
+/***********************************/
+/* MC_CMD_GET_MAC_ADDRESSES
+ * Returns the base MAC, count and stride for the requesting function
+ */
+#define MC_CMD_GET_MAC_ADDRESSES 0x55
+#define MC_CMD_GET_MAC_ADDRESSES_MSGSET 0x55
+
+/* MC_CMD_GET_MAC_ADDRESSES_IN msgrequest */
+#define MC_CMD_GET_MAC_ADDRESSES_IN_LEN 0
+
+/* MC_CMD_GET_MAC_ADDRESSES_OUT msgresponse */
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_LEN 16
+/* Base MAC address */
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_MAC_ADDR_BASE_OFST 0
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_MAC_ADDR_BASE_LEN 6
+/* Padding */
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_RESERVED_OFST 6
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_RESERVED_LEN 2
+/* Number of allocated MAC addresses */
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_MAC_COUNT_OFST 8
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_MAC_COUNT_LEN 4
+/* Spacing of allocated MAC addresses */
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_MAC_STRIDE_OFST 12
+#define MC_CMD_GET_MAC_ADDRESSES_OUT_MAC_STRIDE_LEN 4
+/* MC_CMD_DYNAMIC_SENSORS_LIMITS structuredef: Set of sensor limits. This
+ * should match the equivalent structure in the sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LEN 24
+/* A value below this will trigger a warning event. */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_LBN 0
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_WARNING_WIDTH 32
+/* A value below this will trigger a critical event. */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_OFST 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_LBN 32
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_CRITICAL_WIDTH 32
+/* A value below this will shut down the card. */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_OFST 8
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_LBN 64
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_LO_FATAL_WIDTH 32
+/* A value above this will trigger a warning event. */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_OFST 12
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_LBN 96
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_WARNING_WIDTH 32
+/* A value above this will trigger a critical event. */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_OFST 16
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_LBN 128
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_CRITICAL_WIDTH 32
+/* A value above this will shut down the card. */
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_OFST 20
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_LBN 160
+#define MC_CMD_DYNAMIC_SENSORS_LIMITS_HI_FATAL_WIDTH 32
+
+/* MC_CMD_DYNAMIC_SENSORS_DESCRIPTION structuredef: Description of a sensor.
+ * This should match the equivalent structure in the sensor_query SPHINX
+ * service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LEN 64
+/* The handle used to identify the sensor in calls to
+ * MC_CMD_DYNAMIC_SENSORS_GET_VALUES
+ */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_LBN 0
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_HANDLE_WIDTH 32
+/* A human-readable name for the sensor (zero terminated string, max 32 bytes)
+ */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_OFST 4
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_LEN 32
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_LBN 32
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_NAME_WIDTH 256
+/* The type of the sensor device, and by implication the unit of that the
+ * values will be reported in
+ */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_OFST 36
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_LEN 4
+/* enum: A voltage sensor. Unit is mV */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_VOLTAGE 0x0
+/* enum: A current sensor. Unit is mA */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_CURRENT 0x1
+/* enum: A power sensor. Unit is mW */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_POWER 0x2
+/* enum: A temperature sensor. Unit is Celsius */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TEMPERATURE 0x3
+/* enum: A cooling fan sensor. Unit is RPM */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_FAN 0x4
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_LBN 288
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_TYPE_WIDTH 32
+/* A single MC_CMD_DYNAMIC_SENSORS_LIMITS structure */
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_OFST 40
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_LEN 24
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_LBN 320
+#define MC_CMD_DYNAMIC_SENSORS_DESCRIPTION_LIMITS_WIDTH 192
+
+/* MC_CMD_DYNAMIC_SENSORS_READING structuredef: State and value of a sensor.
+ * This should match the equivalent structure in the sensor_query SPHINX
+ * service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_READING_LEN 12
+/* The handle used to identify the sensor */
+#define MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_LBN 0
+#define MC_CMD_DYNAMIC_SENSORS_READING_HANDLE_WIDTH 32
+/* The current value of the sensor */
+#define MC_CMD_DYNAMIC_SENSORS_READING_VALUE_OFST 4
+#define MC_CMD_DYNAMIC_SENSORS_READING_VALUE_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_READING_VALUE_LBN 32
+#define MC_CMD_DYNAMIC_SENSORS_READING_VALUE_WIDTH 32
+/* The sensor's condition, e.g. good, broken or removed */
+#define MC_CMD_DYNAMIC_SENSORS_READING_STATE_OFST 8
+#define MC_CMD_DYNAMIC_SENSORS_READING_STATE_LEN 4
+/* enum: Sensor working normally within limits */
+#define MC_CMD_DYNAMIC_SENSORS_READING_OK 0x0
+/* enum: Warning threshold breached */
+#define MC_CMD_DYNAMIC_SENSORS_READING_WARNING 0x1
+/* enum: Critical threshold breached */
+#define MC_CMD_DYNAMIC_SENSORS_READING_CRITICAL 0x2
+/* enum: Fatal threshold breached */
+#define MC_CMD_DYNAMIC_SENSORS_READING_FATAL 0x3
+/* enum: Sensor not working */
+#define MC_CMD_DYNAMIC_SENSORS_READING_BROKEN 0x4
+/* enum: Sensor working but no reading available */
+#define MC_CMD_DYNAMIC_SENSORS_READING_NO_READING 0x5
+/* enum: Sensor initialization failed */
+#define MC_CMD_DYNAMIC_SENSORS_READING_INIT_FAILED 0x6
+#define MC_CMD_DYNAMIC_SENSORS_READING_STATE_LBN 64
+#define MC_CMD_DYNAMIC_SENSORS_READING_STATE_WIDTH 32
+
+/***********************************/
+/* MC_CMD_DYNAMIC_SENSORS_LIST
+ * Return a complete list of handles for sensors currently managed by the MC,
+ * and a generation count for this version of the sensor table. On systems
+ * advertising the DYNAMIC_SENSORS capability bit, this replaces the
+ * MC_CMD_READ_SENSORS command. On multi-MC systems this may include sensors
+ * added by the NMC.
+ *
+ * Sensor handles are persistent for the lifetime of the sensor and are used to
+ * identify sensors in MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS and
+ * MC_CMD_DYNAMIC_SENSORS_GET_VALUES.
+ *
+ * The generation count is maintained by the MC, is persistent across reboots
+ * and will be incremented each time the sensor table is modified. When the
+ * table is modified, a CODE_DYNAMIC_SENSORS_CHANGE event will be generated
+ * containing the new generation count. The driver should compare this against
+ * the current generation count, and if it is different, call
+ * MC_CMD_DYNAMIC_SENSORS_LIST again to update it's copy of the sensor table.
+ *
+ * The sensor count is provided to allow a future path to supporting more than
+ * MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM_MCDI2 sensors, i.e.
+ * the maximum number that will fit in a single response. As this is a fairly
+ * large number (253) it is not anticipated that this will be needed in the
+ * near future, so can currently be ignored.
+ *
+ * On Riverhead this command is implemented as a a wrapper for `list` in the
+ * sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_LIST 0x66
+#define MC_CMD_DYNAMIC_SENSORS_LIST_MSGSET 0x66
+
+/* MC_CMD_DYNAMIC_SENSORS_LIST_IN msgrequest */
+#define MC_CMD_DYNAMIC_SENSORS_LIST_IN_LEN 0
+
+/* MC_CMD_DYNAMIC_SENSORS_LIST_OUT msgresponse */
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LENMIN 8
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LENMAX 252
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LENMAX_MCDI2 1020
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_LEN(num) (8 + 4 * (num))
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_NUM(len) (((len) - 8) / 4)
+/* Generation count, which will be updated each time a sensor is added to or
+ * removed from the MC sensor table.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_GENERATION_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_GENERATION_LEN 4
+/* Number of sensors managed by the MC. Note that in principle, this can be
+ * larger than the size of the HANDLES array.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_COUNT_OFST 4
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_COUNT_LEN 4
+/* Array of sensor handles */
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_OFST 8
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_MINNUM 0
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_MAXNUM 61
+#define MC_CMD_DYNAMIC_SENSORS_LIST_OUT_HANDLES_MAXNUM_MCDI2 253
+
+/***********************************/
+/* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS
+ * Get descriptions for a set of sensors, specified as an array of sensor
+ * handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST
+ *
+ * Any handles which do not correspond to a sensor currently managed by the MC
+ * will be dropped from the response. This may happen when a sensor table
+ * update is in progress, and effectively means the set of usable sensors is
+ * the intersection between the sets of sensors known to the driver and the MC.
+ *
+ * On Riverhead this command is implemented as a a wrapper for
+ * `get_descriptions` in the sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS 0x67
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_MSGSET 0x67
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN msgrequest */
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LENMIN 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LENMAX 252
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LENMAX_MCDI2 1020
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_LEN(num) (0 + 4 * (num))
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_NUM(len) (((len) - 0) / 4)
+/* Array of sensor handles */
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_MINNUM 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_MAXNUM 63
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_IN_HANDLES_MAXNUM_MCDI2 255
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT msgresponse */
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LENMIN 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LENMAX 192
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LENMAX_MCDI2 960
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_LEN(num) (0 + 64 * (num))
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_NUM(len) (((len) - 0) / 64)
+/* Array of MC_CMD_DYNAMIC_SENSORS_DESCRIPTION structures */
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_LEN 64
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_MINNUM 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_MAXNUM 3
+#define MC_CMD_DYNAMIC_SENSORS_GET_DESCRIPTIONS_OUT_SENSORS_MAXNUM_MCDI2 15
+
+/***********************************/
+/* MC_CMD_DYNAMIC_SENSORS_GET_READINGS
+ * Read the state and value for a set of sensors, specified as an array of
+ * sensor handles as returned by MC_CMD_DYNAMIC_SENSORS_LIST.
+ *
+ * In the case of a broken sensor, then the state of the response's
+ * MC_CMD_DYNAMIC_SENSORS_VALUE entry will be set to BROKEN, and any value
+ * provided should be treated as erroneous.
+ *
+ * Any handles which do not correspond to a sensor currently managed by the MC
+ * will be dropped from the response. This may happen when a sensor table
+ * update is in progress, and effectively means the set of usable sensors is
+ * the intersection between the sets of sensors known to the driver and the MC.
+ *
+ * On Riverhead this command is implemented as a a wrapper for `get_readings`
+ * in the sensor_query SPHINX service.
+ */
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS 0x68
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_MSGSET 0x68
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN msgrequest */
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LENMIN 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LENMAX 252
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LENMAX_MCDI2 1020
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_LEN(num) (0 + 4 * (num))
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_NUM(len) (((len) - 0) / 4)
+/* Array of sensor handles */
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_LEN 4
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MINNUM 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM 63
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_IN_HANDLES_MAXNUM_MCDI2 255
+
+/* MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT msgresponse */
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LENMIN 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LENMAX 252
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LENMAX_MCDI2 1020
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_LEN(num) (0 + 12 * (num))
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_NUM(len) (((len) - 0) / 12)
+/* Array of MC_CMD_DYNAMIC_SENSORS_READING structures */
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_OFST 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_LEN 12
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_MINNUM 0
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_MAXNUM 21
+#define MC_CMD_DYNAMIC_SENSORS_GET_READINGS_OUT_VALUES_MAXNUM_MCDI2 85
+/* EVB_PORT_ID structuredef */
+#define EVB_PORT_ID_LEN 4
+#define EVB_PORT_ID_PORT_ID_OFST 0
+#define EVB_PORT_ID_PORT_ID_LEN 4
+/* enum: An invalid port handle. */
+#define EVB_PORT_ID_NULL 0x0
+/* enum: The port assigned to this function.. */
+#define EVB_PORT_ID_ASSIGNED 0x1000000
+/* enum: External network port 0 */
+#define EVB_PORT_ID_MAC0 0x2000000
+/* enum: External network port 1 */
+#define EVB_PORT_ID_MAC1 0x2000001
+/* enum: External network port 2 */
+#define EVB_PORT_ID_MAC2 0x2000002
+/* enum: External network port 3 */
+#define EVB_PORT_ID_MAC3 0x2000003
+#define EVB_PORT_ID_PORT_ID_LBN 0
+#define EVB_PORT_ID_PORT_ID_WIDTH 32
+/* NVRAM_PARTITION_TYPE structuredef */
+#define NVRAM_PARTITION_TYPE_LEN 2
+#define NVRAM_PARTITION_TYPE_ID_OFST 0
+#define NVRAM_PARTITION_TYPE_ID_LEN 2
+/* enum: Primary MC firmware partition */
+#define NVRAM_PARTITION_TYPE_MC_FIRMWARE 0x100
+/* enum: NMC firmware partition (this is intentionally an alias of MC_FIRMWARE)
+ */
+#define NVRAM_PARTITION_TYPE_NMC_FIRMWARE 0x100
+/* enum: Secondary MC firmware partition */
+#define NVRAM_PARTITION_TYPE_MC_FIRMWARE_BACKUP 0x200
+/* enum: Expansion ROM partition */
+#define NVRAM_PARTITION_TYPE_EXPANSION_ROM 0x300
+/* enum: Static configuration TLV partition */
+#define NVRAM_PARTITION_TYPE_STATIC_CONFIG 0x400
+/* enum: Factory configuration TLV partition (this is intentionally an alias of
+ * STATIC_CONFIG)
+ */
+#define NVRAM_PARTITION_TYPE_FACTORY_CONFIG 0x400
+/* enum: Dynamic configuration TLV partition */
+#define NVRAM_PARTITION_TYPE_DYNAMIC_CONFIG 0x500
+/* enum: User configuration TLV partition (this is intentionally an alias of
+ * DYNAMIC_CONFIG)
+ */
+#define NVRAM_PARTITION_TYPE_USER_CONFIG 0x500
+/* enum: Expansion ROM configuration data for port 0 */
+#define NVRAM_PARTITION_TYPE_EXPROM_CONFIG_PORT0 0x600
+/* enum: Synonym for EXPROM_CONFIG_PORT0 as used in pmap files */
+#define NVRAM_PARTITION_TYPE_EXPROM_CONFIG 0x600
+/* enum: Expansion ROM configuration data for port 1 */
+#define NVRAM_PARTITION_TYPE_EXPROM_CONFIG_PORT1 0x601
+/* enum: Expansion ROM configuration data for port 2 */
+#define NVRAM_PARTITION_TYPE_EXPROM_CONFIG_PORT2 0x602
+/* enum: Expansion ROM configuration data for port 3 */
+#define NVRAM_PARTITION_TYPE_EXPROM_CONFIG_PORT3 0x603
+/* enum: Non-volatile log output partition */
+#define NVRAM_PARTITION_TYPE_LOG 0x700
+/* enum: Non-volatile log output partition for NMC firmware (this is
+ * intentionally an alias of LOG)
+ */
+#define NVRAM_PARTITION_TYPE_NMC_LOG 0x700
+/* enum: Non-volatile log output of second core on dual-core device */
+#define NVRAM_PARTITION_TYPE_LOG_SLAVE 0x701
+/* enum: Device state dump output partition */
+#define NVRAM_PARTITION_TYPE_DUMP 0x800
+/* enum: Crash log partition for NMC firmware */
+#define NVRAM_PARTITION_TYPE_NMC_CRASH_LOG 0x801
+/* enum: Application license key storage partition */
+#define NVRAM_PARTITION_TYPE_LICENSE 0x900
+/* enum: Start of range used for PHY partitions (low 8 bits are the PHY ID) */
+#define NVRAM_PARTITION_TYPE_PHY_MIN 0xa00
+/* enum: End of range used for PHY partitions (low 8 bits are the PHY ID) */
+#define NVRAM_PARTITION_TYPE_PHY_MAX 0xaff
+/* enum: Primary FPGA partition */
+#define NVRAM_PARTITION_TYPE_FPGA 0xb00
+/* enum: Secondary FPGA partition */
+#define NVRAM_PARTITION_TYPE_FPGA_BACKUP 0xb01
+/* enum: FC firmware partition */
+#define NVRAM_PARTITION_TYPE_FC_FIRMWARE 0xb02
+/* enum: FC License partition */
+#define NVRAM_PARTITION_TYPE_FC_LICENSE 0xb03
+/* enum: Non-volatile log output partition for FC */
+#define NVRAM_PARTITION_TYPE_FC_LOG 0xb04
+/* enum: FPGA Stage 1 bitstream */
+#define NVRAM_PARTITION_TYPE_FPGA_STAGE1 0xb05
+/* enum: FPGA Stage 2 bitstream */
+#define NVRAM_PARTITION_TYPE_FPGA_STAGE2 0xb06
+/* enum: FPGA User XCLBIN / Programmable Region 0 bitstream */
+#define NVRAM_PARTITION_TYPE_FPGA_REGION0 0xb07
+/* enum: FPGA User XCLBIN (this is intentionally an alias of FPGA_REGION0) */
+#define NVRAM_PARTITION_TYPE_FPGA_XCLBIN_USER 0xb07
+/* enum: FPGA jump instruction (a.k.a. boot) partition to select Stage1
+ * bitstream
+ */
+#define NVRAM_PARTITION_TYPE_FPGA_JUMP 0xb08
+/* enum: FPGA Validate XCLBIN */
+#define NVRAM_PARTITION_TYPE_FPGA_XCLBIN_VALIDATE 0xb09
+/* enum: FPGA XOCL Configuration information */
+#define NVRAM_PARTITION_TYPE_FPGA_XOCL_CONFIG 0xb0a
+/* enum: MUM firmware partition */
+#define NVRAM_PARTITION_TYPE_MUM_FIRMWARE 0xc00
+/* enum: SUC firmware partition (this is intentionally an alias of
+ * MUM_FIRMWARE)
+ */
+#define NVRAM_PARTITION_TYPE_SUC_FIRMWARE 0xc00
+/* enum: MUM Non-volatile log output partition. */
+#define NVRAM_PARTITION_TYPE_MUM_LOG 0xc01
+/* enum: SUC Non-volatile log output partition (this is intentionally an alias
+ * of MUM_LOG).
+ */
+#define NVRAM_PARTITION_TYPE_SUC_LOG 0xc01
+/* enum: MUM Application table partition. */
+#define NVRAM_PARTITION_TYPE_MUM_APPTABLE 0xc02
+/* enum: MUM boot rom partition. */
+#define NVRAM_PARTITION_TYPE_MUM_BOOT_ROM 0xc03
+/* enum: MUM production signatures & calibration rom partition. */
+#define NVRAM_PARTITION_TYPE_MUM_PROD_ROM 0xc04
+/* enum: MUM user signatures & calibration rom partition. */
+#define NVRAM_PARTITION_TYPE_MUM_USER_ROM 0xc05
+/* enum: MUM fuses and lockbits partition. */
+#define NVRAM_PARTITION_TYPE_MUM_FUSELOCK 0xc06
+/* enum: UEFI expansion ROM if separate from PXE */
+#define NVRAM_PARTITION_TYPE_EXPANSION_UEFI 0xd00
+/* enum: Used by the expansion ROM for logging */
+#define NVRAM_PARTITION_TYPE_PXE_LOG 0x1000
+/* enum: Non-volatile log output partition for Expansion ROM (this is
+ * intentionally an alias of PXE_LOG).
+ */
+#define NVRAM_PARTITION_TYPE_EXPROM_LOG 0x1000
+/* enum: Used for XIP code of shmbooted images */
+#define NVRAM_PARTITION_TYPE_XIP_SCRATCH 0x1100
+/* enum: Spare partition 2 */
+#define NVRAM_PARTITION_TYPE_SPARE_2 0x1200
+/* enum: Manufacturing partition. Used during manufacture to pass information
+ * between XJTAG and Manftest.
+ */
+#define NVRAM_PARTITION_TYPE_MANUFACTURING 0x1300
+/* enum: Deployment configuration TLV partition (this is intentionally an alias
+ * of MANUFACTURING)
+ */
+#define NVRAM_PARTITION_TYPE_DEPLOYMENT_CONFIG 0x1300
+/* enum: Spare partition 4 */
+#define NVRAM_PARTITION_TYPE_SPARE_4 0x1400
+/* enum: Spare partition 5 */
+#define NVRAM_PARTITION_TYPE_SPARE_5 0x1500
+/* enum: Partition for reporting MC status. See mc_flash_layout.h
+ * medford_mc_status_hdr_t for layout on Medford.
+ */
+#define NVRAM_PARTITION_TYPE_STATUS 0x1600
+/* enum: Spare partition 13 */
+#define NVRAM_PARTITION_TYPE_SPARE_13 0x1700
+/* enum: Spare partition 14 */
+#define NVRAM_PARTITION_TYPE_SPARE_14 0x1800
+/* enum: Spare partition 15 */
+#define NVRAM_PARTITION_TYPE_SPARE_15 0x1900
+/* enum: Spare partition 16 */
+#define NVRAM_PARTITION_TYPE_SPARE_16 0x1a00
+/* enum: Factory defaults for dynamic configuration */
+#define NVRAM_PARTITION_TYPE_DYNCONFIG_DEFAULTS 0x1b00
+/* enum: Factory defaults for expansion ROM configuration */
+#define NVRAM_PARTITION_TYPE_ROMCONFIG_DEFAULTS 0x1c00
+/* enum: Field Replaceable Unit inventory information for use on IPMI
+ * platforms. See SF-119124-PS. The STATIC_CONFIG partition may contain a
+ * subset of the information stored in this partition.
+ */
+#define NVRAM_PARTITION_TYPE_FRU_INFORMATION 0x1d00
+/* enum: Bundle image partition */
+#define NVRAM_PARTITION_TYPE_BUNDLE 0x1e00
+/* enum: Bundle metadata partition that holds additional information related to
+ * a bundle update in TLV format
+ */
+#define NVRAM_PARTITION_TYPE_BUNDLE_METADATA 0x1e01
+/* enum: Bundle update non-volatile log output partition */
+#define NVRAM_PARTITION_TYPE_BUNDLE_LOG 0x1e02
+/* enum: Partition for Solarflare gPXE bootrom installed via Bundle update. */
+#define NVRAM_PARTITION_TYPE_EXPANSION_ROM_INTERNAL 0x1e03
+/* enum: Partition to store ASN.1 format Bundle Signature for checking. */
+#define NVRAM_PARTITION_TYPE_BUNDLE_SIGNATURE 0x1e04
+/* enum: Test partition on SmartNIC system microcontroller (SUC) */
+#define NVRAM_PARTITION_TYPE_SUC_TEST 0x1f00
+/* enum: System microcontroller access to primary FPGA flash. */
+#define NVRAM_PARTITION_TYPE_SUC_FPGA_PRIMARY 0x1f01
+/* enum: System microcontroller access to secondary FPGA flash (if present) */
+#define NVRAM_PARTITION_TYPE_SUC_FPGA_SECONDARY 0x1f02
+/* enum: System microcontroller access to primary System-on-Chip flash */
+#define NVRAM_PARTITION_TYPE_SUC_SOC_PRIMARY 0x1f03
+/* enum: System microcontroller access to secondary System-on-Chip flash (if
+ * present)
+ */
+#define NVRAM_PARTITION_TYPE_SUC_SOC_SECONDARY 0x1f04
+/* enum: System microcontroller critical failure logs. Contains structured
+ * details of sensors leading up to a critical failure (where the board is shut
+ * down).
+ */
+#define NVRAM_PARTITION_TYPE_SUC_FAILURE_LOG 0x1f05
+/* enum: System-on-Chip configuration information (see XN-200467-PS). */
+#define NVRAM_PARTITION_TYPE_SUC_SOC_CONFIG 0x1f07
+/* enum: System-on-Chip update information. */
+#define NVRAM_PARTITION_TYPE_SOC_UPDATE 0x2003
+/* enum: Start of reserved value range (firmware may use for any purpose) */
+#define NVRAM_PARTITION_TYPE_RESERVED_VALUES_MIN 0xff00
+/* enum: End of reserved value range (firmware may use for any purpose) */
+#define NVRAM_PARTITION_TYPE_RESERVED_VALUES_MAX 0xfffd
+/* enum: Recovery partition map (provided if real map is missing or corrupt) */
+#define NVRAM_PARTITION_TYPE_RECOVERY_MAP 0xfffe
+/* enum: Recovery Flash Partition Table, see SF-122606-TC. (this is
+ * intentionally an alias of RECOVERY_MAP)
+ */
+#define NVRAM_PARTITION_TYPE_RECOVERY_FPT 0xfffe
+/* enum: Partition map (real map as stored in flash) */
+#define NVRAM_PARTITION_TYPE_PARTITION_MAP 0xffff
+/* enum: Flash Partition Table, see SF-122606-TC. (this is intentionally an
+ * alias of PARTITION_MAP)
+ */
+#define NVRAM_PARTITION_TYPE_FPT 0xffff
+#define NVRAM_PARTITION_TYPE_ID_LBN 0
+#define NVRAM_PARTITION_TYPE_ID_WIDTH 16
+/* TX_TIMESTAMP_EVENT structuredef */
+#define TX_TIMESTAMP_EVENT_LEN 6
+/* lower 16 bits of timestamp data */
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_LO_OFST 0
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_LO_LEN 2
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_LO_LBN 0
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_LO_WIDTH 16
+/* Type of TX event, ordinary TX completion, low or high part of TX timestamp
+ */
+#define TX_TIMESTAMP_EVENT_TX_EV_TYPE_OFST 3
+#define TX_TIMESTAMP_EVENT_TX_EV_TYPE_LEN 1
+/* enum: This is a TX completion event, not a timestamp */
+#define TX_TIMESTAMP_EVENT_TX_EV_COMPLETION 0x0
+/* enum: This is a TX completion event for a CTPIO transmit. The event format
+ * is the same as for TX_EV_COMPLETION.
+ */
+#define TX_TIMESTAMP_EVENT_TX_EV_CTPIO_COMPLETION 0x11
+/* enum: This is the low part of a TX timestamp for a CTPIO transmission. The
+ * event format is the same as for TX_EV_TSTAMP_LO
+ */
+#define TX_TIMESTAMP_EVENT_TX_EV_CTPIO_TS_LO 0x12
+/* enum: This is the high part of a TX timestamp for a CTPIO transmission. The
+ * event format is the same as for TX_EV_TSTAMP_HI
+ */
+#define TX_TIMESTAMP_EVENT_TX_EV_CTPIO_TS_HI 0x13
+/* enum: This is the low part of a TX timestamp event */
+#define TX_TIMESTAMP_EVENT_TX_EV_TSTAMP_LO 0x51
+/* enum: This is the high part of a TX timestamp event */
+#define TX_TIMESTAMP_EVENT_TX_EV_TSTAMP_HI 0x52
+#define TX_TIMESTAMP_EVENT_TX_EV_TYPE_LBN 24
+#define TX_TIMESTAMP_EVENT_TX_EV_TYPE_WIDTH 8
+/* upper 16 bits of timestamp data */
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_HI_OFST 4
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_HI_LEN 2
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_HI_LBN 32
+#define TX_TIMESTAMP_EVENT_TSTAMP_DATA_HI_WIDTH 16
+/***********************************/
+/* MC_CMD_INIT_EVQ
+ * Set up an event queue according to the supplied parameters. The IN arguments
+ * end with an address for each 4k of host memory required to back the EVQ.
+ */
+#define MC_CMD_INIT_EVQ 0x80
+#define MC_CMD_INIT_EVQ_MSGSET 0x80
+
+/* MC_CMD_INIT_EVQ_V3_IN msgrequest: Extended request to specify per-queue
+ * event merge timeouts.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_LEN 556
+/* Size, in entries */
+#define MC_CMD_INIT_EVQ_V3_IN_SIZE_OFST 0
+#define MC_CMD_INIT_EVQ_V3_IN_SIZE_LEN 4
+/* Desired instance. Must be set to a specific instance, which is a function
+ * local queue index. The calling client must be the currently-assigned user of
+ * this VI (see MC_CMD_SET_VI_USER).
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_INSTANCE_OFST 4
+#define MC_CMD_INIT_EVQ_V3_IN_INSTANCE_LEN 4
+/* The initial timer value. The load value is ignored if the timer mode is DIS.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_LOAD_OFST 8
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_LOAD_LEN 4
+/* The reload value is ignored in one-shot modes */
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_RELOAD_OFST 12
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_RELOAD_LEN 4
+/* tbd */
+#define MC_CMD_INIT_EVQ_V3_IN_FLAGS_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAGS_LEN 4
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_INTERRUPTING_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_INTERRUPTING_LBN 0
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_INTERRUPTING_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_RPTR_DOS_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_RPTR_DOS_LBN 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_RPTR_DOS_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_INT_ARMD_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_INT_ARMD_LBN 2
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_INT_ARMD_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_CUT_THRU_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_CUT_THRU_LBN 3
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_CUT_THRU_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_RX_MERGE_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_RX_MERGE_LBN 4
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_RX_MERGE_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TX_MERGE_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TX_MERGE_LBN 5
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TX_MERGE_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_USE_TIMER_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_USE_TIMER_LBN 6
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_USE_TIMER_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_LBN 7
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_WIDTH 4
+/* enum: All initialisation flags specified by host. */
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_MANUAL 0x0
+/* enum: MEDFORD only. Certain initialisation flags specified by host may be
+ * over-ridden by firmware based on licenses and firmware variant in order to
+ * provide the lowest latency achievable. See
+ * MC_CMD_INIT_EVQ_V2/MC_CMD_INIT_EVQ_V2_OUT/FLAGS for list of affected flags.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_LOW_LATENCY 0x1
+/* enum: MEDFORD only. Certain initialisation flags specified by host may be
+ * over-ridden by firmware based on licenses and firmware variant in order to
+ * provide the best throughput achievable. See
+ * MC_CMD_INIT_EVQ_V2/MC_CMD_INIT_EVQ_V2_OUT/FLAGS for list of affected flags.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_THROUGHPUT 0x2
+/* enum: MEDFORD only. Certain initialisation flags may be over-ridden by
+ * firmware based on licenses and firmware variant. See
+ * MC_CMD_INIT_EVQ_V2/MC_CMD_INIT_EVQ_V2_OUT/FLAGS for list of affected flags.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_TYPE_AUTO 0x3
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_EXT_WIDTH_OFST 16
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_EXT_WIDTH_LBN 11
+#define MC_CMD_INIT_EVQ_V3_IN_FLAG_EXT_WIDTH_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_MODE_OFST 20
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_MODE_LEN 4
+/* enum: Disabled */
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_MODE_DIS 0x0
+/* enum: Immediate */
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_IMMED_START 0x1
+/* enum: Triggered */
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_TRIG_START 0x2
+/* enum: Hold-off */
+#define MC_CMD_INIT_EVQ_V3_IN_TMR_INT_HLDOFF 0x3
+/* Target EVQ for wakeups if in wakeup mode. */
+#define MC_CMD_INIT_EVQ_V3_IN_TARGET_EVQ_OFST 24
+#define MC_CMD_INIT_EVQ_V3_IN_TARGET_EVQ_LEN 4
+/* Target interrupt if in interrupting mode (note union with target EVQ). Use
+ * MC_CMD_RESOURCE_INSTANCE_ANY unless a specific one required for test
+ * purposes.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_IRQ_NUM_OFST 24
+#define MC_CMD_INIT_EVQ_V3_IN_IRQ_NUM_LEN 4
+/* Event Counter Mode. */
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_MODE_OFST 28
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_MODE_LEN 4
+/* enum: Disabled */
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_MODE_DIS 0x0
+/* enum: Disabled */
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_MODE_RX 0x1
+/* enum: Disabled */
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_MODE_TX 0x2
+/* enum: Disabled */
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_MODE_RXTX 0x3
+/* Event queue packet count threshold. */
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_THRSHLD_OFST 32
+#define MC_CMD_INIT_EVQ_V3_IN_COUNT_THRSHLD_LEN 4
+/* 64-bit address of 4k of 4k-aligned host memory buffer */
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_OFST 36
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_LEN 8
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_LO_OFST 36
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_LO_LEN 4
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_LO_LBN 288
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_LO_WIDTH 32
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_HI_OFST 40
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_HI_LEN 4
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_HI_LBN 320
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_HI_WIDTH 32
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_MINNUM 1
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_MAXNUM 64
+#define MC_CMD_INIT_EVQ_V3_IN_DMA_ADDR_MAXNUM_MCDI2 64
+/* Receive event merge timeout to configure, in nanoseconds. The valid range
+ * and granularity are device specific. Specify 0 to use the firmware's default
+ * value. This field is ignored and per-queue merging is disabled if
+ * MC_CMD_INIT_EVQ/MC_CMD_INIT_EVQ_IN/FLAG_RX_MERGE is not set.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_RX_MERGE_TIMEOUT_NS_OFST 548
+#define MC_CMD_INIT_EVQ_V3_IN_RX_MERGE_TIMEOUT_NS_LEN 4
+/* Transmit event merge timeout to configure, in nanoseconds. The valid range
+ * and granularity are device specific. Specify 0 to use the firmware's default
+ * value. This field is ignored and per-queue merging is disabled if
+ * MC_CMD_INIT_EVQ/MC_CMD_INIT_EVQ_IN/FLAG_TX_MERGE is not set.
+ */
+#define MC_CMD_INIT_EVQ_V3_IN_TX_MERGE_TIMEOUT_NS_OFST 552
+#define MC_CMD_INIT_EVQ_V3_IN_TX_MERGE_TIMEOUT_NS_LEN 4
+
+/* MC_CMD_INIT_EVQ_V3_OUT msgresponse */
+#define MC_CMD_INIT_EVQ_V3_OUT_LEN 8
+/* Only valid if INTRFLAG was true */
+#define MC_CMD_INIT_EVQ_V3_OUT_IRQ_OFST 0
+#define MC_CMD_INIT_EVQ_V3_OUT_IRQ_LEN 4
+/* Actual configuration applied on the card */
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAGS_OFST 4
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAGS_LEN 4
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_CUT_THRU_OFST 4
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_CUT_THRU_LBN 0
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_CUT_THRU_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_RX_MERGE_OFST 4
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_RX_MERGE_LBN 1
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_RX_MERGE_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_TX_MERGE_OFST 4
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_TX_MERGE_LBN 2
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_TX_MERGE_WIDTH 1
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_RXQ_FORCE_EV_MERGING_OFST 4
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_RXQ_FORCE_EV_MERGING_LBN 3
+#define MC_CMD_INIT_EVQ_V3_OUT_FLAG_RXQ_FORCE_EV_MERGING_WIDTH 1
+/***********************************/
+/* MC_CMD_INIT_RXQ
+ * set up a receive queue according to the supplied parameters. The IN
+ * arguments end with an address for each 4k of host memory required to back
+ * the RXQ.
+ */
+#define MC_CMD_INIT_RXQ 0x81
+#define MC_CMD_INIT_RXQ_MSGSET 0x81
+
+/* MC_CMD_INIT_RXQ_V5_IN msgrequest: INIT_RXQ request with ability to request a
+ * different RX packet prefix
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_LEN 568
+/* Size, in entries */
+#define MC_CMD_INIT_RXQ_V5_IN_SIZE_OFST 0
+#define MC_CMD_INIT_RXQ_V5_IN_SIZE_LEN 4
+/* The EVQ to send events to. This is an index originally specified to
+ * INIT_EVQ. If DMA_MODE == PACKED_STREAM this must be equal to INSTANCE.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_TARGET_EVQ_OFST 4
+#define MC_CMD_INIT_RXQ_V5_IN_TARGET_EVQ_LEN 4
+/* The value to put in the event data. Check hardware spec. for valid range.
+ * This field is ignored if DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER or DMA_MODE
+ * == PACKED_STREAM.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_LABEL_OFST 8
+#define MC_CMD_INIT_RXQ_V5_IN_LABEL_LEN 4
+/* Desired instance. Must be set to a specific instance, which is a function
+ * local queue index. The calling client must be the currently-assigned user of
+ * this VI (see MC_CMD_SET_VI_USER).
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_INSTANCE_OFST 12
+#define MC_CMD_INIT_RXQ_V5_IN_INSTANCE_LEN 4
+/* There will be more flags here. */
+#define MC_CMD_INIT_RXQ_V5_IN_FLAGS_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAGS_LEN 4
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_BUFF_MODE_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_BUFF_MODE_LBN 0
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_BUFF_MODE_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_HDR_SPLIT_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_HDR_SPLIT_LBN 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_HDR_SPLIT_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_TIMESTAMP_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_TIMESTAMP_LBN 2
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_TIMESTAMP_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_CRC_MODE_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_CRC_MODE_LBN 3
+#define MC_CMD_INIT_RXQ_V5_IN_CRC_MODE_WIDTH 4
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_CHAIN_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_CHAIN_LBN 7
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_CHAIN_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_PREFIX_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_PREFIX_LBN 8
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_PREFIX_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER_LBN 9
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_DISABLE_SCATTER_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_MODE_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_MODE_LBN 10
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_MODE_WIDTH 4
+/* enum: One packet per descriptor (for normal networking) */
+#define MC_CMD_INIT_RXQ_V5_IN_SINGLE_PACKET 0x0
+/* enum: Pack multiple packets into large descriptors (for SolarCapture) */
+#define MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM 0x1
+/* enum: Pack multiple packets into large descriptors using the format designed
+ * to maximise packet rate. This mode uses 1 "bucket" per descriptor with
+ * multiple fixed-size packet buffers within each bucket. For a full
+ * description see SF-119419-TC. This mode is only supported by "dpdk" datapath
+ * firmware.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_EQUAL_STRIDE_SUPER_BUFFER 0x2
+/* enum: Deprecated name for EQUAL_STRIDE_SUPER_BUFFER. */
+#define MC_CMD_INIT_RXQ_V5_IN_EQUAL_STRIDE_PACKED_STREAM 0x2
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_SNAPSHOT_MODE_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_SNAPSHOT_MODE_LBN 14
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_SNAPSHOT_MODE_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM_BUFF_SIZE_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM_BUFF_SIZE_LBN 15
+#define MC_CMD_INIT_RXQ_V5_IN_PACKED_STREAM_BUFF_SIZE_WIDTH 3
+#define MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_1M 0x0 /* enum */
+#define MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_512K 0x1 /* enum */
+#define MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_256K 0x2 /* enum */
+#define MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_128K 0x3 /* enum */
+#define MC_CMD_INIT_RXQ_V5_IN_PS_BUFF_64K 0x4 /* enum */
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_WANT_OUTER_CLASSES_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_WANT_OUTER_CLASSES_LBN 18
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_WANT_OUTER_CLASSES_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_FORCE_EV_MERGING_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_FORCE_EV_MERGING_LBN 19
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_FORCE_EV_MERGING_WIDTH 1
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_NO_CONT_EV_OFST 16
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_NO_CONT_EV_LBN 20
+#define MC_CMD_INIT_RXQ_V5_IN_FLAG_NO_CONT_EV_WIDTH 1
+/* Owner ID to use if in buffer mode (zero if physical) */
+#define MC_CMD_INIT_RXQ_V5_IN_OWNER_ID_OFST 20
+#define MC_CMD_INIT_RXQ_V5_IN_OWNER_ID_LEN 4
+/* The port ID associated with the v-adaptor which should contain this DMAQ. */
+#define MC_CMD_INIT_RXQ_V5_IN_PORT_ID_OFST 24
+#define MC_CMD_INIT_RXQ_V5_IN_PORT_ID_LEN 4
+/* 64-bit address of 4k of 4k-aligned host memory buffer */
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_OFST 28
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LEN 8
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LO_OFST 28
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LO_LEN 4
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LO_LBN 224
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_LO_WIDTH 32
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_HI_OFST 32
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_HI_LEN 4
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_HI_LBN 256
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_HI_WIDTH 32
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_MINNUM 0
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_MAXNUM 64
+#define MC_CMD_INIT_RXQ_V5_IN_DMA_ADDR_MAXNUM_MCDI2 64
+/* Maximum length of packet to receive, if SNAPSHOT_MODE flag is set */
+#define MC_CMD_INIT_RXQ_V5_IN_SNAPSHOT_LENGTH_OFST 540
+#define MC_CMD_INIT_RXQ_V5_IN_SNAPSHOT_LENGTH_LEN 4
+/* The number of packet buffers that will be contained within each
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket supplied by the driver. This field
+ * is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_BUFFERS_PER_BUCKET_OFST 544
+#define MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_BUFFERS_PER_BUCKET_LEN 4
+/* The length in bytes of the area in each packet buffer that can be written to
+ * by the adapter. This is used to store the packet prefix and the packet
+ * payload. This length does not include any end padding added by the driver.
+ * This field is ignored unless DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_ES_MAX_DMA_LEN_OFST 548
+#define MC_CMD_INIT_RXQ_V5_IN_ES_MAX_DMA_LEN_LEN 4
+/* The length in bytes of a single packet buffer within a
+ * EQUAL_STRIDE_SUPER_BUFFER format bucket. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_STRIDE_OFST 552
+#define MC_CMD_INIT_RXQ_V5_IN_ES_PACKET_STRIDE_LEN 4
+/* The maximum time in nanoseconds that the datapath will be backpressured if
+ * there are no RX descriptors available. If the timeout is reached and there
+ * are still no descriptors then the packet will be dropped. A timeout of 0
+ * means the datapath will never be blocked. This field is ignored unless
+ * DMA_MODE == EQUAL_STRIDE_SUPER_BUFFER.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_OFST 556
+#define MC_CMD_INIT_RXQ_V5_IN_ES_HEAD_OF_LINE_BLOCK_TIMEOUT_LEN 4
+/* V4 message data */
+#define MC_CMD_INIT_RXQ_V5_IN_V4_DATA_OFST 560
+#define MC_CMD_INIT_RXQ_V5_IN_V4_DATA_LEN 4
+/* Size in bytes of buffers attached to descriptors posted to this queue. Set
+ * to zero if using this message on non-QDMA based platforms. Currently in
+ * Riverhead there is a global limit of eight different buffer sizes across all
+ * active queues. A 2KB and 4KB buffer is guaranteed to be available, but a
+ * request for a different buffer size will fail if there are already eight
+ * other buffer sizes in use. In future Riverhead this limit will go away and
+ * any size will be accepted.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_BUFFER_SIZE_BYTES_OFST 560
+#define MC_CMD_INIT_RXQ_V5_IN_BUFFER_SIZE_BYTES_LEN 4
+/* Prefix id for the RX prefix format to use on packets delivered this queue.
+ * Zero is always a valid prefix id and means the default prefix format
+ * documented for the platform. Other prefix ids can be obtained by calling
+ * MC_CMD_GET_RX_PREFIX_ID with a requested set of prefix fields.
+ */
+#define MC_CMD_INIT_RXQ_V5_IN_RX_PREFIX_ID_OFST 564
+#define MC_CMD_INIT_RXQ_V5_IN_RX_PREFIX_ID_LEN 4
+
+/* MC_CMD_INIT_RXQ_OUT msgresponse */
+#define MC_CMD_INIT_RXQ_OUT_LEN 0
+
+/* MC_CMD_INIT_RXQ_EXT_OUT msgresponse */
+#define MC_CMD_INIT_RXQ_EXT_OUT_LEN 0
+
+/* MC_CMD_INIT_RXQ_V3_OUT msgresponse */
+#define MC_CMD_INIT_RXQ_V3_OUT_LEN 0
+
+/* MC_CMD_INIT_RXQ_V4_OUT msgresponse */
+#define MC_CMD_INIT_RXQ_V4_OUT_LEN 0
+
+/* MC_CMD_INIT_RXQ_V5_OUT msgresponse */
+#define MC_CMD_INIT_RXQ_V5_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_INIT_TXQ
+ */
+#define MC_CMD_INIT_TXQ 0x82
+#define MC_CMD_INIT_TXQ_MSGSET 0x82
+
+/* MC_CMD_INIT_TXQ_EXT_IN msgrequest: Extended INIT_TXQ with additional mode
+ * flags
+ */
+#define MC_CMD_INIT_TXQ_EXT_IN_LEN 544
+/* Size, in entries */
+#define MC_CMD_INIT_TXQ_EXT_IN_SIZE_OFST 0
+#define MC_CMD_INIT_TXQ_EXT_IN_SIZE_LEN 4
+/* The EVQ to send events to. This is an index originally specified to
+ * INIT_EVQ.
+ */
+#define MC_CMD_INIT_TXQ_EXT_IN_TARGET_EVQ_OFST 4
+#define MC_CMD_INIT_TXQ_EXT_IN_TARGET_EVQ_LEN 4
+/* The value to put in the event data. Check hardware spec. for valid range. */
+#define MC_CMD_INIT_TXQ_EXT_IN_LABEL_OFST 8
+#define MC_CMD_INIT_TXQ_EXT_IN_LABEL_LEN 4
+/* Desired instance. Must be set to a specific instance, which is a function
+ * local queue index. The calling client must be the currently-assigned user of
+ * this VI (see MC_CMD_SET_VI_USER).
+ */
+#define MC_CMD_INIT_TXQ_EXT_IN_INSTANCE_OFST 12
+#define MC_CMD_INIT_TXQ_EXT_IN_INSTANCE_LEN 4
+/* There will be more flags here. */
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAGS_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAGS_LEN 4
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_BUFF_MODE_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_BUFF_MODE_LBN 0
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_BUFF_MODE_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS_LBN 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_IP_CSUM_DIS_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS_LBN 2
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_CSUM_DIS_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_UDP_ONLY_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_UDP_ONLY_LBN 3
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TCP_UDP_ONLY_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_CRC_MODE_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_CRC_MODE_LBN 4
+#define MC_CMD_INIT_TXQ_EXT_IN_CRC_MODE_WIDTH 4
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TIMESTAMP_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TIMESTAMP_LBN 8
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TIMESTAMP_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_PACER_BYPASS_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_PACER_BYPASS_LBN 9
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_PACER_BYPASS_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_IP_CSUM_EN_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_IP_CSUM_EN_LBN 10
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_IP_CSUM_EN_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_TCP_CSUM_EN_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_TCP_CSUM_EN_LBN 11
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_INNER_TCP_CSUM_EN_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TSOV2_EN_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TSOV2_EN_LBN 12
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_TSOV2_EN_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_LBN 13
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH_LBN 14
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_CTPIO_UTHRESH_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_M2M_D2C_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_M2M_D2C_LBN 15
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_M2M_D2C_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_DESC_PROXY_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_DESC_PROXY_LBN 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_DESC_PROXY_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_ABS_TARGET_EVQ_OFST 16
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_ABS_TARGET_EVQ_LBN 17
+#define MC_CMD_INIT_TXQ_EXT_IN_FLAG_ABS_TARGET_EVQ_WIDTH 1
+/* Owner ID to use if in buffer mode (zero if physical) */
+#define MC_CMD_INIT_TXQ_EXT_IN_OWNER_ID_OFST 20
+#define MC_CMD_INIT_TXQ_EXT_IN_OWNER_ID_LEN 4
+/* The port ID associated with the v-adaptor which should contain this DMAQ. */
+#define MC_CMD_INIT_TXQ_EXT_IN_PORT_ID_OFST 24
+#define MC_CMD_INIT_TXQ_EXT_IN_PORT_ID_LEN 4
+/* 64-bit address of 4k of 4k-aligned host memory buffer */
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_OFST 28
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_LEN 8
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_LO_OFST 28
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_LO_LEN 4
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_LO_LBN 224
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_LO_WIDTH 32
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_HI_OFST 32
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_HI_LEN 4
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_HI_LBN 256
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_HI_WIDTH 32
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_MINNUM 0
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_MAXNUM 64
+#define MC_CMD_INIT_TXQ_EXT_IN_DMA_ADDR_MAXNUM_MCDI2 64
+/* Flags related to Qbb flow control mode. */
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_FLAGS_OFST 540
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_FLAGS_LEN 4
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_ENABLE_OFST 540
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_ENABLE_LBN 0
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_ENABLE_WIDTH 1
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_PRIORITY_OFST 540
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_PRIORITY_LBN 1
+#define MC_CMD_INIT_TXQ_EXT_IN_QBB_PRIORITY_WIDTH 3
+
+/* MC_CMD_INIT_TXQ_OUT msgresponse */
+#define MC_CMD_INIT_TXQ_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_FINI_EVQ
+ * Teardown an EVQ.
+ *
+ * All DMAQs or EVQs that point to the EVQ to tear down must be torn down first
+ * or the operation will fail with EBUSY
+ */
+#define MC_CMD_FINI_EVQ 0x83
+#define MC_CMD_FINI_EVQ_MSGSET 0x83
+
+/* MC_CMD_FINI_EVQ_IN msgrequest */
+#define MC_CMD_FINI_EVQ_IN_LEN 4
+/* Instance of EVQ to destroy. Should be the same instance as that previously
+ * passed to INIT_EVQ
+ */
+#define MC_CMD_FINI_EVQ_IN_INSTANCE_OFST 0
+#define MC_CMD_FINI_EVQ_IN_INSTANCE_LEN 4
+
+/* MC_CMD_FINI_EVQ_OUT msgresponse */
+#define MC_CMD_FINI_EVQ_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_FINI_RXQ
+ * Teardown a RXQ.
+ */
+#define MC_CMD_FINI_RXQ 0x84
+#define MC_CMD_FINI_RXQ_MSGSET 0x84
+
+/* MC_CMD_FINI_RXQ_IN msgrequest */
+#define MC_CMD_FINI_RXQ_IN_LEN 4
+/* Instance of RXQ to destroy */
+#define MC_CMD_FINI_RXQ_IN_INSTANCE_OFST 0
+#define MC_CMD_FINI_RXQ_IN_INSTANCE_LEN 4
+
+/* MC_CMD_FINI_RXQ_OUT msgresponse */
+#define MC_CMD_FINI_RXQ_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_FINI_TXQ
+ * Teardown a TXQ.
+ */
+#define MC_CMD_FINI_TXQ 0x85
+#define MC_CMD_FINI_TXQ_MSGSET 0x85
+
+/* MC_CMD_FINI_TXQ_IN msgrequest */
+#define MC_CMD_FINI_TXQ_IN_LEN 4
+/* Instance of TXQ to destroy */
+#define MC_CMD_FINI_TXQ_IN_INSTANCE_OFST 0
+#define MC_CMD_FINI_TXQ_IN_INSTANCE_LEN 4
+
+/* MC_CMD_FINI_TXQ_OUT msgresponse */
+#define MC_CMD_FINI_TXQ_OUT_LEN 0
+
+/***********************************/
+/* MC_CMD_DRIVER_EVENT
+ * Generate an event on an EVQ belonging to the function issuing the command.
+ */
+#define MC_CMD_DRIVER_EVENT 0x86
+#define MC_CMD_DRIVER_EVENT_MSGSET 0x86
+
+/* MC_CMD_DRIVER_EVENT_IN msgrequest */
+#define MC_CMD_DRIVER_EVENT_IN_LEN 12
+/* Handle of target EVQ */
+#define MC_CMD_DRIVER_EVENT_IN_EVQ_OFST 0
+#define MC_CMD_DRIVER_EVENT_IN_EVQ_LEN 4
+/* Bits 0 - 63 of event */
+#define MC_CMD_DRIVER_EVENT_IN_DATA_OFST 4
+#define MC_CMD_DRIVER_EVENT_IN_DATA_LEN 8
+#define MC_CMD_DRIVER_EVENT_IN_DATA_LO_OFST 4
+#define MC_CMD_DRIVER_EVENT_IN_DATA_LO_LEN 4
+#define MC_CMD_DRIVER_EVENT_IN_DATA_LO_LBN 32
+#define MC_CMD_DRIVER_EVENT_IN_DATA_LO_WIDTH 32
+#define MC_CMD_DRIVER_EVENT_IN_DATA_HI_OFST 8
+#define MC_CMD_DRIVER_EVENT_IN_DATA_HI_LEN 4
+#define MC_CMD_DRIVER_EVENT_IN_DATA_HI_LBN 64
+#define MC_CMD_DRIVER_EVENT_IN_DATA_HI_WIDTH 32
+
+/* MC_CMD_DRIVER_EVENT_OUT msgresponse */
+#define MC_CMD_DRIVER_EVENT_OUT_LEN 0
+/***********************************/
+/* MC_CMD_FILTER_OP
+ * Multiplexed MCDI call for filter operations
+ */
+#define MC_CMD_FILTER_OP 0x8a
+#define MC_CMD_FILTER_OP_MSGSET 0x8a
+
+/* enum: single-recipient filter insert */
+#define MC_CMD_FILTER_OP_IN_OP_INSERT 0x0
+/* enum: single-recipient filter remove */
+#define MC_CMD_FILTER_OP_IN_OP_REMOVE 0x1
+/* enum: multi-recipient filter subscribe */
+#define MC_CMD_FILTER_OP_IN_OP_SUBSCRIBE 0x2
+/* enum: multi-recipient filter unsubscribe */
+#define MC_CMD_FILTER_OP_IN_OP_UNSUBSCRIBE 0x3
+/* enum: replace one recipient with another (warning - the filter handle may
+ * change)
+ */
+#define MC_CMD_FILTER_OP_IN_OP_REPLACE 0x4
+/* filter handle (for remove / unsubscribe operations) */
+/* MC_CMD_FILTER_OP_V3_IN msgrequest: FILTER_OP extension to support additional
+ * filter actions for EF100. Some of these actions are also supported on EF10,
+ * for Intel's DPDK (Data Plane Development Kit, dpdk.org) via its rte_flow
+ * API. In the latter case, this extension is only useful with the sfc_efx
+ * driver included as part of DPDK, used in conjunction with the dpdk datapath
+ * firmware variant.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_LEN 180
+/* identifies the type of operation requested */
+#define MC_CMD_FILTER_OP_V3_IN_OP_OFST 0
+#define MC_CMD_FILTER_OP_V3_IN_OP_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_FILTER_OP_IN/OP */
+/* filter handle (for remove / unsubscribe operations) */
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_OFST 4
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_LEN 8
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_LO_OFST 4
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_LO_LEN 4
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_LO_LBN 32
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_LO_WIDTH 32
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_HI_OFST 8
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_HI_LEN 4
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_HI_LBN 64
+#define MC_CMD_FILTER_OP_V3_IN_HANDLE_HI_WIDTH 32
+/* The port ID associated with the v-adaptor which should contain this filter.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_PORT_ID_OFST 12
+#define MC_CMD_FILTER_OP_V3_IN_PORT_ID_LEN 4
+/* fields to include in match criteria */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_FIELDS_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_FIELDS_LEN 4
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_IP_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_IP_LBN 0
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_IP_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_LBN 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_IP_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_MAC_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_MAC_LBN 2
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_MAC_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_PORT_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_PORT_LBN 3
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SRC_PORT_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_MAC_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_MAC_LBN 4
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_MAC_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_LBN 5
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_DST_PORT_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_LBN 6
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ETHER_TYPE_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_INNER_VLAN_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_INNER_VLAN_LBN 7
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_INNER_VLAN_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_OUTER_VLAN_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_OUTER_VLAN_LBN 8
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_OUTER_VLAN_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_LBN 9
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IP_PROTO_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_FWDEF0_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_FWDEF0_LBN 10
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_FWDEF0_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_VNI_OR_VSID_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_VNI_OR_VSID_LBN 11
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_VNI_OR_VSID_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_IP_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_IP_LBN 12
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_IP_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_IP_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_IP_LBN 13
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_IP_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_MAC_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_MAC_LBN 14
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_MAC_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_PORT_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_PORT_LBN 15
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_SRC_PORT_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_MAC_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_MAC_LBN 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_MAC_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_PORT_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_PORT_LBN 17
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_DST_PORT_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_ETHER_TYPE_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_ETHER_TYPE_LBN 18
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_ETHER_TYPE_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_INNER_VLAN_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_INNER_VLAN_LBN 19
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_INNER_VLAN_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_OUTER_VLAN_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_OUTER_VLAN_LBN 20
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_OUTER_VLAN_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_IP_PROTO_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_IP_PROTO_LBN 21
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_IP_PROTO_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF0_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF0_LBN 22
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF0_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF1_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF1_LBN 23
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_FWDEF1_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_LBN 24
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_MCAST_DST_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_LBN 25
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_IFRM_UNKNOWN_UCAST_DST_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_IPV4_MCAST_DST_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_IPV4_MCAST_DST_LBN 29
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_IPV4_MCAST_DST_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_MCAST_DST_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_MCAST_DST_LBN 30
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_MCAST_DST_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_UCAST_DST_OFST 16
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_UCAST_DST_LBN 31
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_UNKNOWN_UCAST_DST_WIDTH 1
+/* receive destination */
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_OFST 20
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_LEN 4
+/* enum: drop packets */
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_DROP 0x0
+/* enum: receive to host */
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_HOST 0x1
+/* enum: receive to MC */
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_MC 0x2
+/* enum: loop back to TXDP 0 */
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_TX0 0x3
+/* enum: loop back to TXDP 1 */
+#define MC_CMD_FILTER_OP_V3_IN_RX_DEST_TX1 0x4
+/* receive queue handle (for multiple queue modes, this is the base queue) */
+#define MC_CMD_FILTER_OP_V3_IN_RX_QUEUE_OFST 24
+#define MC_CMD_FILTER_OP_V3_IN_RX_QUEUE_LEN 4
+/* receive mode */
+#define MC_CMD_FILTER_OP_V3_IN_RX_MODE_OFST 28
+#define MC_CMD_FILTER_OP_V3_IN_RX_MODE_LEN 4
+/* enum: receive to just the specified queue */
+#define MC_CMD_FILTER_OP_V3_IN_RX_MODE_SIMPLE 0x0
+/* enum: receive to multiple queues using RSS context */
+#define MC_CMD_FILTER_OP_V3_IN_RX_MODE_RSS 0x1
+/* enum: receive to multiple queues using .1p mapping */
+#define MC_CMD_FILTER_OP_V3_IN_RX_MODE_DOT1P_MAPPING 0x2
+/* enum: install a filter entry that will never match; for test purposes only
+ */
+#define MC_CMD_FILTER_OP_V3_IN_RX_MODE_TEST_NEVER_MATCH 0x80000000
+/* RSS context (for RX_MODE_RSS) or .1p mapping handle (for
+ * RX_MODE_DOT1P_MAPPING), as returned by MC_CMD_RSS_CONTEXT_ALLOC or
+ * MC_CMD_DOT1P_MAPPING_ALLOC.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_RX_CONTEXT_OFST 32
+#define MC_CMD_FILTER_OP_V3_IN_RX_CONTEXT_LEN 4
+/* transmit domain (reserved; set to 0) */
+#define MC_CMD_FILTER_OP_V3_IN_TX_DOMAIN_OFST 36
+#define MC_CMD_FILTER_OP_V3_IN_TX_DOMAIN_LEN 4
+/* transmit destination (either set the MAC and/or PM bits for explicit
+ * control, or set this field to TX_DEST_DEFAULT for sensible default
+ * behaviour)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_OFST 40
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_LEN 4
+/* enum: request default behaviour (based on filter type) */
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_DEFAULT 0xffffffff
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_MAC_OFST 40
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_MAC_LBN 0
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_MAC_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_PM_OFST 40
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_PM_LBN 1
+#define MC_CMD_FILTER_OP_V3_IN_TX_DEST_PM_WIDTH 1
+/* source MAC address to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_SRC_MAC_OFST 44
+#define MC_CMD_FILTER_OP_V3_IN_SRC_MAC_LEN 6
+/* source port to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_SRC_PORT_OFST 50
+#define MC_CMD_FILTER_OP_V3_IN_SRC_PORT_LEN 2
+/* destination MAC address to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_DST_MAC_OFST 52
+#define MC_CMD_FILTER_OP_V3_IN_DST_MAC_LEN 6
+/* destination port to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_DST_PORT_OFST 58
+#define MC_CMD_FILTER_OP_V3_IN_DST_PORT_LEN 2
+/* Ethernet type to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_ETHER_TYPE_OFST 60
+#define MC_CMD_FILTER_OP_V3_IN_ETHER_TYPE_LEN 2
+/* Inner VLAN tag to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_INNER_VLAN_OFST 62
+#define MC_CMD_FILTER_OP_V3_IN_INNER_VLAN_LEN 2
+/* Outer VLAN tag to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_OUTER_VLAN_OFST 64
+#define MC_CMD_FILTER_OP_V3_IN_OUTER_VLAN_LEN 2
+/* IP protocol to match (in low byte; set high byte to 0) */
+#define MC_CMD_FILTER_OP_V3_IN_IP_PROTO_OFST 66
+#define MC_CMD_FILTER_OP_V3_IN_IP_PROTO_LEN 2
+/* Firmware defined register 0 to match (reserved; set to 0) */
+#define MC_CMD_FILTER_OP_V3_IN_FWDEF0_OFST 68
+#define MC_CMD_FILTER_OP_V3_IN_FWDEF0_LEN 4
+/* VNI (for VXLAN/Geneve, when IP protocol is UDP) or VSID (for NVGRE, when IP
+ * protocol is GRE) to match (as bytes in network order; set last byte to 0 for
+ * VXLAN/NVGRE, or 1 for Geneve)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_VNI_OR_VSID_OFST 72
+#define MC_CMD_FILTER_OP_V3_IN_VNI_OR_VSID_LEN 4
+#define MC_CMD_FILTER_OP_V3_IN_VNI_VALUE_OFST 72
+#define MC_CMD_FILTER_OP_V3_IN_VNI_VALUE_LBN 0
+#define MC_CMD_FILTER_OP_V3_IN_VNI_VALUE_WIDTH 24
+#define MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_OFST 72
+#define MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_LBN 24
+#define MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_WIDTH 8
+/* enum: Match VXLAN traffic with this VNI */
+#define MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_VXLAN 0x0
+/* enum: Match Geneve traffic with this VNI */
+#define MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_GENEVE 0x1
+/* enum: Reserved for experimental development use */
+#define MC_CMD_FILTER_OP_V3_IN_VNI_TYPE_EXPERIMENTAL 0xfe
+#define MC_CMD_FILTER_OP_V3_IN_VSID_VALUE_OFST 72
+#define MC_CMD_FILTER_OP_V3_IN_VSID_VALUE_LBN 0
+#define MC_CMD_FILTER_OP_V3_IN_VSID_VALUE_WIDTH 24
+#define MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_OFST 72
+#define MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_LBN 24
+#define MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_WIDTH 8
+/* enum: Match NVGRE traffic with this VSID */
+#define MC_CMD_FILTER_OP_V3_IN_VSID_TYPE_NVGRE 0x0
+/* source IP address to match (as bytes in network order; set last 12 bytes to
+ * 0 for IPv4 address)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_SRC_IP_OFST 76
+#define MC_CMD_FILTER_OP_V3_IN_SRC_IP_LEN 16
+/* destination IP address to match (as bytes in network order; set last 12
+ * bytes to 0 for IPv4 address)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_DST_IP_OFST 92
+#define MC_CMD_FILTER_OP_V3_IN_DST_IP_LEN 16
+/* VXLAN/NVGRE inner frame source MAC address to match (as bytes in network
+ * order)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_SRC_MAC_OFST 108
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_SRC_MAC_LEN 6
+/* VXLAN/NVGRE inner frame source port to match (as bytes in network order) */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_SRC_PORT_OFST 114
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_SRC_PORT_LEN 2
+/* VXLAN/NVGRE inner frame destination MAC address to match (as bytes in
+ * network order)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_DST_MAC_OFST 116
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_DST_MAC_LEN 6
+/* VXLAN/NVGRE inner frame destination port to match (as bytes in network
+ * order)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_DST_PORT_OFST 122
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_DST_PORT_LEN 2
+/* VXLAN/NVGRE inner frame Ethernet type to match (as bytes in network order)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_ETHER_TYPE_OFST 124
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_ETHER_TYPE_LEN 2
+/* VXLAN/NVGRE inner frame Inner VLAN tag to match (as bytes in network order)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_INNER_VLAN_OFST 126
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_INNER_VLAN_LEN 2
+/* VXLAN/NVGRE inner frame Outer VLAN tag to match (as bytes in network order)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_OUTER_VLAN_OFST 128
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_OUTER_VLAN_LEN 2
+/* VXLAN/NVGRE inner frame IP protocol to match (in low byte; set high byte to
+ * 0)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_IP_PROTO_OFST 130
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_IP_PROTO_LEN 2
+/* VXLAN/NVGRE inner frame Firmware defined register 0 to match (reserved; set
+ * to 0)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_FWDEF0_OFST 132
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_FWDEF0_LEN 4
+/* VXLAN/NVGRE inner frame Firmware defined register 1 to match (reserved; set
+ * to 0)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_FWDEF1_OFST 136
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_FWDEF1_LEN 4
+/* VXLAN/NVGRE inner frame source IP address to match (as bytes in network
+ * order; set last 12 bytes to 0 for IPv4 address)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_SRC_IP_OFST 140
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_SRC_IP_LEN 16
+/* VXLAN/NVGRE inner frame destination IP address to match (as bytes in network
+ * order; set last 12 bytes to 0 for IPv4 address)
+ */
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_DST_IP_OFST 156
+#define MC_CMD_FILTER_OP_V3_IN_IFRM_DST_IP_LEN 16
+/* Flags controlling mutations of the packet and/or metadata when the filter is
+ * matched. The user_mark and user_flag fields' logic is as follows: if
+ * (req.MATCH_BITOR_FLAG == 1) user_flag = req.MATCH_SET_FLAG bit_or user_flag;
+ * else user_flag = req.MATCH_SET_FLAG; if (req.MATCH_SET_MARK == 0) user_mark
+ * = 0; else if (req.MATCH_BITOR_MARK == 1) user_mark = req.MATCH_SET_MARK
+ * bit_or user_mark; else user_mark = req.MATCH_SET_MARK; N.B. These flags
+ * overlap with the MATCH_ACTION field, which is deprecated in favour of this
+ * field. For the cases where these flags induce a valid encoding of the
+ * MATCH_ACTION field, the semantics agree.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_FLAGS_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_FLAGS_LEN 4
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SET_FLAG_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SET_FLAG_LBN 0
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SET_FLAG_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SET_MARK_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SET_MARK_LBN 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_SET_MARK_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_BITOR_FLAG_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_BITOR_FLAG_LBN 2
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_BITOR_FLAG_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_BITOR_MARK_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_BITOR_MARK_LBN 3
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_BITOR_MARK_WIDTH 1
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_STRIP_VLAN_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_STRIP_VLAN_LBN 4
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_STRIP_VLAN_WIDTH 1
+/* Deprecated: the overlapping MATCH_ACTION_FLAGS field exposes all of the
+ * functionality of this field in an ABI-backwards-compatible manner, and
+ * should be used instead. Any future extensions should be made to the
+ * MATCH_ACTION_FLAGS field, and not to this field. Set an action for all
+ * packets matching this filter. The DPDK driver and (on EF10) dpdk f/w variant
+ * use their own specific delivery structures, which are documented in the DPDK
+ * Firmware Driver Interface (SF-119419-TC). Requesting anything other than
+ * MATCH_ACTION_NONE on an EF10 NIC running another f/w variant will cause the
+ * filter insertion to fail with ENOTSUP.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_OFST 172
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_LEN 4
+/* enum: do nothing extra */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_NONE 0x0
+/* enum: Set the match flag in the packet prefix for packets matching the
+ * filter (only with dpdk firmware, otherwise fails with ENOTSUP). Used to
+ * support the DPDK rte_flow "FLAG" action.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_FLAG 0x1
+/* enum: Insert MATCH_MARK_VALUE into the packet prefix for packets matching
+ * the filter (only with dpdk firmware, otherwise fails with ENOTSUP). Used to
+ * support the DPDK rte_flow "MARK" action.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_ACTION_MARK 0x2
+/* the mark value for MATCH_ACTION_MARK. Requesting a value larger than the
+ * maximum (obtained from MC_CMD_GET_CAPABILITIES_V5/FILTER_ACTION_MARK_MAX)
+ * will cause the filter insertion to fail with EINVAL.
+ */
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_MARK_VALUE_OFST 176
+#define MC_CMD_FILTER_OP_V3_IN_MATCH_MARK_VALUE_LEN 4
+
+/* MC_CMD_FILTER_OP_OUT msgresponse */
+#define MC_CMD_FILTER_OP_OUT_LEN 12
+/* identifies the type of operation requested */
+#define MC_CMD_FILTER_OP_OUT_OP_OFST 0
+#define MC_CMD_FILTER_OP_OUT_OP_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_FILTER_OP_IN/OP */
+/* Returned filter handle (for insert / subscribe operations). Note that these
+ * handles should be considered opaque to the host, although a value of
+ * 0xFFFFFFFF_FFFFFFFF is guaranteed never to be a valid handle.
+ */
+#define MC_CMD_FILTER_OP_OUT_HANDLE_OFST 4
+#define MC_CMD_FILTER_OP_OUT_HANDLE_LEN 8
+#define MC_CMD_FILTER_OP_OUT_HANDLE_LO_OFST 4
+#define MC_CMD_FILTER_OP_OUT_HANDLE_LO_LEN 4
+#define MC_CMD_FILTER_OP_OUT_HANDLE_LO_LBN 32
+#define MC_CMD_FILTER_OP_OUT_HANDLE_LO_WIDTH 32
+#define MC_CMD_FILTER_OP_OUT_HANDLE_HI_OFST 8
+#define MC_CMD_FILTER_OP_OUT_HANDLE_HI_LEN 4
+#define MC_CMD_FILTER_OP_OUT_HANDLE_HI_LBN 64
+#define MC_CMD_FILTER_OP_OUT_HANDLE_HI_WIDTH 32
+/* enum: guaranteed invalid filter handle (low 32 bits) */
+#define MC_CMD_FILTER_OP_OUT_HANDLE_LO_INVALID 0xffffffff
+/* enum: guaranteed invalid filter handle (high 32 bits) */
+#define MC_CMD_FILTER_OP_OUT_HANDLE_HI_INVALID 0xffffffff
+
+/* MC_CMD_FILTER_OP_EXT_OUT msgresponse */
+#define MC_CMD_FILTER_OP_EXT_OUT_LEN 12
+/* identifies the type of operation requested */
+#define MC_CMD_FILTER_OP_EXT_OUT_OP_OFST 0
+#define MC_CMD_FILTER_OP_EXT_OUT_OP_LEN 4
+/* Enum values, see field(s): */
+/* MC_CMD_FILTER_OP_EXT_IN/OP */
+/* Returned filter handle (for insert / subscribe operations). Note that these
+ * handles should be considered opaque to the host, although a value of
+ * 0xFFFFFFFF_FFFFFFFF is guaranteed never to be a valid handle.
+ */
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_OFST 4
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_LEN 8
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_LO_OFST 4
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_LO_LEN 4
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_LO_LBN 32
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_LO_WIDTH 32
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_HI_OFST 8
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_HI_LEN 4
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_HI_LBN 64
+#define MC_CMD_FILTER_OP_EXT_OUT_HANDLE_HI_WIDTH 32
+/* Enum values, see field(s): */
+/* MC_CMD_FILTER_OP_OUT/HANDLE */
+/***********************************/
+/* MC_CMD_GET_PORT_ASSIGNMENT
+ * Get port assignment for current PCI function.
+ */
+#define MC_CMD_GET_PORT_ASSIGNMENT 0xb8
+#define MC_CMD_GET_PORT_ASSIGNMENT_MSGSET 0xb8
+
+/* MC_CMD_GET_PORT_ASSIGNMENT_IN msgrequest */
+#define MC_CMD_GET_PORT_ASSIGNMENT_IN_LEN 0
+
+/* MC_CMD_GET_PORT_ASSIGNMENT_OUT msgresponse */
+#define MC_CMD_GET_PORT_ASSIGNMENT_OUT_LEN 4
+/* Identifies the port assignment for this function. On EF100, it is possible
+ * for the function to have no network port assigned (either because it is not
+ * yet configured, or assigning a port to a given function personality makes no
+ * sense - e.g. virtio-blk), in which case the return value is NULL_PORT.
+ */
+#define MC_CMD_GET_PORT_ASSIGNMENT_OUT_PORT_OFST 0
+#define MC_CMD_GET_PORT_ASSIGNMENT_OUT_PORT_LEN 4
+/* enum: Special value to indicate no port is assigned to a function. */
+#define MC_CMD_GET_PORT_ASSIGNMENT_OUT_NULL_PORT 0xffffffff
+/***********************************/
+/* MC_CMD_GET_CAPABILITIES
+ * Get device capabilities.
+ *
+ * This is supplementary to the MC_CMD_GET_BOARD_CFG command, and intended to
+ * reference inherent device capabilities as opposed to current NVRAM config.
+ */
+#define MC_CMD_GET_CAPABILITIES 0xbe
+#define MC_CMD_GET_CAPABILITIES_MSGSET 0xbe
+
+/* MC_CMD_GET_CAPABILITIES_IN msgrequest */
+#define MC_CMD_GET_CAPABILITIES_IN_LEN 0
+/* MC_CMD_GET_CAPABILITIES_V10_OUT msgresponse */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_LEN 192
+/* First word of flags. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS1_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS1_LEN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VPORT_RECONFIGURE_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VPORT_RECONFIGURE_LBN 3
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VPORT_RECONFIGURE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_STRIPING_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_STRIPING_LBN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_STRIPING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VADAPTOR_QUERY_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VADAPTOR_QUERY_LBN 5
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VADAPTOR_QUERY_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVB_PORT_VLAN_RESTRICT_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVB_PORT_VLAN_RESTRICT_LBN 6
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVB_PORT_VLAN_RESTRICT_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DRV_ATTACH_PREBOOT_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DRV_ATTACH_PREBOOT_LBN 7
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DRV_ATTACH_PREBOOT_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_FORCE_EVENT_MERGING_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_FORCE_EVENT_MERGING_LBN 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_FORCE_EVENT_MERGING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SET_MAC_ENHANCED_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SET_MAC_ENHANCED_LBN 9
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SET_MAC_ENHANCED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_LBN 10
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_UNKNOWN_UCAST_DST_FILTER_ALWAYS_MULTI_RECIPIENT_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_LBN 11
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VADAPTOR_PERMIT_SET_MAC_WHEN_FILTERS_INSTALLED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MAC_SECURITY_FILTERING_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MAC_SECURITY_FILTERING_LBN 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MAC_SECURITY_FILTERING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ADDITIONAL_RSS_MODES_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ADDITIONAL_RSS_MODES_LBN 13
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ADDITIONAL_RSS_MODES_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_QBB_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_QBB_LBN 14
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_QBB_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PACKED_STREAM_VAR_BUFFERS_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PACKED_STREAM_VAR_BUFFERS_LBN 15
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PACKED_STREAM_VAR_BUFFERS_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_RSS_LIMITED_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_RSS_LIMITED_LBN 16
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_RSS_LIMITED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PACKED_STREAM_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PACKED_STREAM_LBN 17
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PACKED_STREAM_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_INCLUDE_FCS_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_INCLUDE_FCS_LBN 18
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_INCLUDE_FCS_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_VLAN_INSERTION_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_VLAN_INSERTION_LBN 19
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_VLAN_INSERTION_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_VLAN_STRIPPING_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_VLAN_STRIPPING_LBN 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_VLAN_STRIPPING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_LBN 21
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PREFIX_LEN_0_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PREFIX_LEN_0_LBN 22
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PREFIX_LEN_0_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PREFIX_LEN_14_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PREFIX_LEN_14_LBN 23
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_PREFIX_LEN_14_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_TIMESTAMP_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_TIMESTAMP_LBN 24
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_TIMESTAMP_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_BATCHING_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_BATCHING_LBN 25
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_BATCHING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCAST_FILTER_CHAINING_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCAST_FILTER_CHAINING_LBN 26
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCAST_FILTER_CHAINING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PM_AND_RXDP_COUNTERS_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PM_AND_RXDP_COUNTERS_LBN 27
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PM_AND_RXDP_COUNTERS_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DISABLE_SCATTER_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DISABLE_SCATTER_LBN 28
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DISABLE_SCATTER_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MCAST_UDP_LOOPBACK_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MCAST_UDP_LOOPBACK_LBN 29
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MCAST_UDP_LOOPBACK_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVB_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVB_LBN 30
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVB_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VXLAN_NVGRE_OFST 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VXLAN_NVGRE_LBN 31
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VXLAN_NVGRE_WIDTH 1
+/* RxDPCPU firmware id. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DPCPU_FW_ID_OFST 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DPCPU_FW_ID_LEN 2
+/* enum: Standard RXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP 0x0
+/* enum: Low latency RXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_LOW_LATENCY 0x1
+/* enum: Packed stream RXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_PACKED_STREAM 0x2
+/* enum: Rules engine RXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_RULES_ENGINE 0x5
+/* enum: DPDK RXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_DPDK 0x6
+/* enum: BIST RXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_BIST 0x10a
+/* enum: RXDP Test firmware image 1 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_TO_MC_CUT_THROUGH 0x101
+/* enum: RXDP Test firmware image 2 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD 0x102
+/* enum: RXDP Test firmware image 3 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_TO_MC_STORE_FORWARD_FIRST 0x103
+/* enum: RXDP Test firmware image 4 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_EVERY_EVENT_BATCHABLE 0x104
+/* enum: RXDP Test firmware image 5 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_BACKPRESSURE 0x105
+/* enum: RXDP Test firmware image 6 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_PACKET_EDITS 0x106
+/* enum: RXDP Test firmware image 7 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_RX_HDR_SPLIT 0x107
+/* enum: RXDP Test firmware image 8 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_DISABLE_DL 0x108
+/* enum: RXDP Test firmware image 9 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_DOORBELL_DELAY 0x10b
+/* enum: RXDP Test firmware image 10 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_TEST_FW_SLOW 0x10c
+/* TxDPCPU firmware id. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_DPCPU_FW_ID_OFST 6
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_DPCPU_FW_ID_LEN 2
+/* enum: Standard TXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP 0x0
+/* enum: Low latency TXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_LOW_LATENCY 0x1
+/* enum: High packet rate TXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_HIGH_PACKET_RATE 0x3
+/* enum: Rules engine TXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_RULES_ENGINE 0x5
+/* enum: DPDK TXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_DPDK 0x6
+/* enum: BIST TXDP firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_BIST 0x12d
+/* enum: TXDP Test firmware image 1 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_TEST_FW_TSO_EDIT 0x101
+/* enum: TXDP Test firmware image 2 */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_TEST_FW_PACKET_EDITS 0x102
+/* enum: TXDP CSR bus test firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXDP_TEST_FW_CSR 0x103
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_OFST 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_LEN 2
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_REV_OFST 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_REV_LBN 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_REV_WIDTH 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_TYPE_OFST 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_TYPE_LBN 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial RX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: RX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: RX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured RX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant RX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+/* enum: Low latency RX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_LOW_LATENCY 0x5
+/* enum: Packed stream RX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_PACKED_STREAM 0x6
+/* enum: RX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine RX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK RX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* enum: RX PD firmware parsing but not filtering network overlay tunnel
+ * encapsulations (Medford development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXPD_FW_TYPE_TESTFW_ENCAP_PARSING_ONLY 0xf
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_OFST 10
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_LEN 2
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_REV_OFST 10
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_REV_LBN 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_REV_WIDTH 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_TYPE_OFST 10
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_TYPE_LBN 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_VERSION_TYPE_WIDTH 4
+/* enum: reserved value - do not use (may indicate alternative interpretation
+ * of REV field in future)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_RESERVED 0x0
+/* enum: Trivial TX PD firmware for early Huntington development (Huntington
+ * development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_FIRST_PKT 0x1
+/* enum: TX PD firmware for telemetry prototyping (Medford2 development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_TESTFW_TELEMETRY 0x1
+/* enum: TX PD firmware with approximately Siena-compatible behaviour
+ * (Huntington development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_SIENA_COMPAT 0x2
+/* enum: Full featured TX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_FULL_FEATURED 0x3
+/* enum: (deprecated original name for the FULL_FEATURED variant) */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_VSWITCH 0x3
+/* enum: siena_compat variant TX PD firmware using PM rather than MAC
+ * (Huntington development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_SIENA_COMPAT_PM 0x4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_LOW_LATENCY 0x5 /* enum */
+/* enum: TX PD firmware handling layer 2 only for high packet rate performance
+ * tests (Medford development only)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_LAYER2_PERF 0x7
+/* enum: Rules engine TX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_RULES_ENGINE 0x8
+/* enum: Custom firmware variant (see SF-119495-PD and bug69716) */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_L3XUDP 0x9
+/* enum: DPDK TX PD production firmware */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_DPDK 0xa
+/* enum: RX PD firmware for GUE parsing prototype (Medford development only) */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TXPD_FW_TYPE_TESTFW_GUE_PROTOTYPE 0xe
+/* Hardware capabilities of NIC */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_HW_CAPABILITIES_OFST 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_HW_CAPABILITIES_LEN 4
+/* Licensed capabilities */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_LICENSE_CAPABILITIES_OFST 16
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_LICENSE_CAPABILITIES_LEN 4
+/* Second word of flags. Not present on older firmware (check the length). */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS2_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS2_LEN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_LBN 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_ENCAP_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_ENCAP_LBN 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_ENCAP_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVQ_TIMER_CTRL_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVQ_TIMER_CTRL_LBN 2
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVQ_TIMER_CTRL_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVENT_CUT_THROUGH_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVENT_CUT_THROUGH_LBN 3
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EVENT_CUT_THROUGH_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_CUT_THROUGH_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_CUT_THROUGH_LBN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_CUT_THROUGH_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_VFIFO_ULL_MODE_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_VFIFO_ULL_MODE_LBN 5
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_VFIFO_ULL_MODE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAC_STATS_40G_TX_SIZE_BINS_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAC_STATS_40G_TX_SIZE_BINS_LBN 6
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAC_STATS_40G_TX_SIZE_BINS_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_EVQ_TYPE_SUPPORTED_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_EVQ_TYPE_SUPPORTED_LBN 7
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_EVQ_TYPE_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_EVQ_V2_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_EVQ_V2_LBN 7
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_EVQ_V2_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MAC_TIMESTAMPING_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MAC_TIMESTAMPING_LBN 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_MAC_TIMESTAMPING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TIMESTAMP_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TIMESTAMP_LBN 9
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TIMESTAMP_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_SNIFF_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_SNIFF_LBN 10
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_SNIFF_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_SNIFF_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_SNIFF_LBN 11
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_SNIFF_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_LBN 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_REPORT_VERIFY_RESULT_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCDI_BACKGROUND_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCDI_BACKGROUND_LBN 13
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCDI_BACKGROUND_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCDI_DB_RETURN_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCDI_DB_RETURN_LBN 14
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MCDI_DB_RETURN_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_CTPIO_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_CTPIO_LBN 15
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_CTPIO_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TSA_SUPPORT_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TSA_SUPPORT_LBN 16
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TSA_SUPPORT_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TSA_BOUND_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TSA_BOUND_LBN 17
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TSA_BOUND_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SF_ADAPTER_AUTHENTICATION_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SF_ADAPTER_AUTHENTICATION_LBN 18
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SF_ADAPTER_AUTHENTICATION_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_FLAG_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_FLAG_LBN 19
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_FLAG_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_MARK_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_MARK_LBN 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_MARK_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EQUAL_STRIDE_SUPER_BUFFER_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EQUAL_STRIDE_SUPER_BUFFER_LBN 21
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EQUAL_STRIDE_SUPER_BUFFER_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EQUAL_STRIDE_PACKED_STREAM_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EQUAL_STRIDE_PACKED_STREAM_LBN 21
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EQUAL_STRIDE_PACKED_STREAM_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_L3XUDP_SUPPORT_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_L3XUDP_SUPPORT_LBN 22
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_L3XUDP_SUPPORT_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FW_SUBVARIANT_NO_TX_CSUM_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FW_SUBVARIANT_NO_TX_CSUM_LBN 23
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FW_SUBVARIANT_NO_TX_CSUM_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_SPREADING_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_SPREADING_LBN 24
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_SPREADING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_HLB_IDLE_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_HLB_IDLE_LBN 25
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RXDP_HLB_IDLE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_RXQ_NO_CONT_EV_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_RXQ_NO_CONT_EV_LBN 26
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_RXQ_NO_CONT_EV_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_RXQ_WITH_BUFFER_SIZE_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_RXQ_WITH_BUFFER_SIZE_LBN 27
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INIT_RXQ_WITH_BUFFER_SIZE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_BUNDLE_UPDATE_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_BUNDLE_UPDATE_LBN 28
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_BUNDLE_UPDATE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V3_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V3_LBN 29
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V3_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_SENSORS_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_SENSORS_LBN 30
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_SENSORS_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_OFST 20
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_LBN 31
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_POLL_VERIFY_RESULT_WIDTH 1
+/* Number of FATSOv2 contexts per datapath supported by this NIC (when
+ * TX_TSO_V2 == 1). Not present on older firmware (check the length).
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_N_CONTEXTS_OFST 24
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_TSO_V2_N_CONTEXTS_LEN 2
+/* One byte per PF containing the number of the external port assigned to this
+ * PF, indexed by PF number. Special values indicate that a PF is either not
+ * present or not assigned.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PFS_TO_PORTS_ASSIGNMENT_OFST 26
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PFS_TO_PORTS_ASSIGNMENT_LEN 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PFS_TO_PORTS_ASSIGNMENT_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ACCESS_NOT_PERMITTED 0xff
+/* enum: PF does not exist. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PF_NOT_PRESENT 0xfe
+/* enum: PF does exist but is not assigned to any external port. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_PF_NOT_ASSIGNED 0xfd
+/* enum: This value indicates that PF is assigned, but it cannot be expressed
+ * in this field. It is intended for a possible future situation where a more
+ * complex scheme of PFs to ports mapping is being used. The future driver
+ * should look for a new field supporting the new scheme. The current/old
+ * driver should treat this value as PF_NOT_ASSIGNED.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_INCOMPATIBLE_ASSIGNMENT 0xfc
+/* One byte per PF containing the number of its VFs, indexed by PF number. A
+ * special value indicates that a PF is not present.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_VFS_PER_PF_OFST 42
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_VFS_PER_PF_LEN 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_VFS_PER_PF_NUM 16
+/* enum: The caller is not permitted to access information on this PF. */
+/* MC_CMD_GET_CAPABILITIES_V10_OUT_ACCESS_NOT_PERMITTED 0xff */
+/* enum: PF does not exist. */
+/* MC_CMD_GET_CAPABILITIES_V10_OUT_PF_NOT_PRESENT 0xfe */
+/* Number of VIs available for each external port */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_VIS_PER_PORT_OFST 58
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_VIS_PER_PORT_LEN 2
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_VIS_PER_PORT_NUM 4
+/* Size of RX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ RX_DESC_CACHE_SIZE)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DESC_CACHE_SIZE_OFST 66
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_DESC_CACHE_SIZE_LEN 1
+/* Size of TX descriptor cache expressed as binary logarithm The actual size
+ * equals (2 ^ TX_DESC_CACHE_SIZE)
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_DESC_CACHE_SIZE_OFST 67
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TX_DESC_CACHE_SIZE_LEN 1
+/* Total number of available PIO buffers */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_PIO_BUFFS_OFST 68
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NUM_PIO_BUFFS_LEN 2
+/* Size of a single PIO buffer */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SIZE_PIO_BUFF_OFST 70
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SIZE_PIO_BUFF_LEN 2
+/* On chips later than Medford the amount of address space assigned to each VI
+ * is configurable. This is a global setting that the driver must query to
+ * discover the VI to address mapping. Cut-through PIO (CTPIO) is not available
+ * with 8k VI windows.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_WINDOW_MODE_OFST 72
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_WINDOW_MODE_LEN 1
+/* enum: Each VI occupies 8k as on Huntington and Medford. PIO is at offset 4k.
+ * CTPIO is not mapped.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_WINDOW_MODE_8K 0x0
+/* enum: Each VI occupies 16k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_WINDOW_MODE_16K 0x1
+/* enum: Each VI occupies 64k. PIO is at offset 4k. CTPIO is at offset 12k. */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VI_WINDOW_MODE_64K 0x2
+/* Number of vFIFOs per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VFIFO_STUFFING_NUM_VFIFOS_OFST 73
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VFIFO_STUFFING_NUM_VFIFOS_LEN 1
+/* Number of buffers per adapter that can be used for VFIFO Stuffing
+ * (SF-115995-SW) in the present configuration of firmware and port mode.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_OFST 74
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VFIFO_STUFFING_NUM_CP_BUFFERS_LEN 2
+/* Entry count in the MAC stats array, including the final GENERATION_END
+ * entry. For MAC stats DMA, drivers should allocate a buffer large enough to
+ * hold at least this many 64-bit stats values, if they wish to receive all
+ * available stats. If the buffer is shorter than MAC_STATS_NUM_STATS * 8, the
+ * stats array returned will be truncated.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAC_STATS_NUM_STATS_OFST 76
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAC_STATS_NUM_STATS_LEN 2
+/* Maximum supported value for MC_CMD_FILTER_OP_V3/MATCH_MARK_VALUE. This field
+ * will only be non-zero if MC_CMD_GET_CAPABILITIES/FILTER_ACTION_MARK is set.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_MARK_MAX_OFST 80
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FILTER_ACTION_MARK_MAX_LEN 4
+/* On devices where the INIT_RXQ_WITH_BUFFER_SIZE flag (in
+ * GET_CAPABILITIES_OUT_V2) is set, drivers have to specify a buffer size when
+ * they create an RX queue. Due to hardware limitations, only a small number of
+ * different buffer sizes may be available concurrently. Nonzero entries in
+ * this array are the sizes of buffers which the system guarantees will be
+ * available for use. If the list is empty, there are no limitations on
+ * concurrent buffer sizes.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_GUARANTEED_RX_BUFFER_SIZES_OFST 84
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_GUARANTEED_RX_BUFFER_SIZES_LEN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_GUARANTEED_RX_BUFFER_SIZES_NUM 16
+/* Third word of flags. Not present on older firmware (check the length). */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS3_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_FLAGS3_LEN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_WOL_ETHERWAKE_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_WOL_ETHERWAKE_LBN 0
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_WOL_ETHERWAKE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_EVEN_SPREADING_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_EVEN_SPREADING_LBN 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_EVEN_SPREADING_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_SELECTABLE_TABLE_SIZE_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_SELECTABLE_TABLE_SIZE_LBN 2
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_SELECTABLE_TABLE_SIZE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_SUPPORTED_LBN 3
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VDPA_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VDPA_SUPPORTED_LBN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_VDPA_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_LBN 5
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RX_VLAN_STRIPPING_PER_ENCAP_RULE_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_LBN 6
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EXTENDED_WIDTH_EVQS_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_UNSOL_EV_CREDIT_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_UNSOL_EV_CREDIT_SUPPORTED_LBN 7
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_UNSOL_EV_CREDIT_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ENCAPSULATED_MCDI_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ENCAPSULATED_MCDI_SUPPORTED_LBN 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_ENCAPSULATED_MCDI_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EXTERNAL_MAE_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EXTERNAL_MAE_SUPPORTED_LBN 9
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_EXTERNAL_MAE_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_ABORT_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_ABORT_SUPPORTED_LBN 10
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_NVRAM_UPDATE_ABORT_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_ACTION_SET_ALLOC_V2_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_ACTION_SET_ALLOC_V2_SUPPORTED_LBN 11
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_MAE_ACTION_SET_ALLOC_V2_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_STEER_ON_OUTER_SUPPORTED_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_STEER_ON_OUTER_SUPPORTED_LBN 12
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_STEER_ON_OUTER_SUPPORTED_WIDTH 1
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_MPORT_JOURNAL_OFST 148
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_MPORT_JOURNAL_LBN 14
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_DYNAMIC_MPORT_JOURNAL_WIDTH 1
+/* These bits are reserved for communicating test-specific capabilities to
+ * host-side test software. All production drivers should treat this field as
+ * opaque.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_OFST 152
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_LEN 8
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_LO_OFST 152
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_LO_LEN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_LO_LBN 1216
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_LO_WIDTH 32
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_HI_OFST 156
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_HI_LEN 4
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_HI_LBN 1248
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_TEST_RESERVED_HI_WIDTH 32
+/* The minimum size (in table entries) of indirection table to be allocated
+ * from the pool for an RSS context. Note that the table size used must be a
+ * power of 2.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MIN_INDIRECTION_TABLE_SIZE_OFST 160
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MIN_INDIRECTION_TABLE_SIZE_LEN 4
+/* The maximum size (in table entries) of indirection table to be allocated
+ * from the pool for an RSS context. Note that the table size used must be a
+ * power of 2.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MAX_INDIRECTION_TABLE_SIZE_OFST 164
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MAX_INDIRECTION_TABLE_SIZE_LEN 4
+/* The maximum number of queues that can be used by an RSS context in exclusive
+ * mode. In exclusive mode the context has a configurable indirection table and
+ * a configurable RSS key.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MAX_INDIRECTION_QUEUES_OFST 168
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MAX_INDIRECTION_QUEUES_LEN 4
+/* The maximum number of queues that can be used by an RSS context in even-
+ * spreading mode. In even-spreading mode the context has no indirection table
+ * but it does have a configurable RSS key.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MAX_EVEN_SPREADING_QUEUES_OFST 172
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_MAX_EVEN_SPREADING_QUEUES_LEN 4
+/* The total number of RSS contexts supported. Note that the number of
+ * available contexts using indirection tables is also limited by the
+ * availability of indirection table space allocated from a common pool.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_NUM_CONTEXTS_OFST 176
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_NUM_CONTEXTS_LEN 4
+/* The total amount of indirection table space that can be shared between RSS
+ * contexts.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_TABLE_POOL_SIZE_OFST 180
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_RSS_TABLE_POOL_SIZE_LEN 4
+/* A bitmap of the queue sizes the device can provide, where bit N being set
+ * indicates that 2**N is a valid size. The device may be limited in the number
+ * of different queue sizes that can exist simultaneously, so a bit being set
+ * here does not guarantee that an attempt to create a queue of that size will
+ * succeed.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SUPPORTED_QUEUE_SIZES_OFST 184
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_SUPPORTED_QUEUE_SIZES_LEN 4
+/* A bitmap of queue sizes that are always available, in the same format as
+ * SUPPORTED_QUEUE_SIZES. Attempting to create a queue with one of these sizes
+ * will never fail due to unavailability of the requested size.
+ */
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_GUARANTEED_QUEUE_SIZES_OFST 188
+#define MC_CMD_GET_CAPABILITIES_V10_OUT_GUARANTEED_QUEUE_SIZES_LEN 4
+
+/***********************************/
+/* MC_CMD_V2_EXTN
+ * Encapsulation for a v2 extended command
+ */
+#define MC_CMD_V2_EXTN 0x7f
+#define MC_CMD_V2_EXTN_MSGSET 0x7f
+
+/* MC_CMD_V2_EXTN_IN msgrequest */
+#define MC_CMD_V2_EXTN_IN_LEN 4
+/* the extended command number */
+#define MC_CMD_V2_EXTN_IN_EXTENDED_CMD_LBN 0
+#define MC_CMD_V2_EXTN_IN_EXTENDED_CMD_WIDTH 15
+#define MC_CMD_V2_EXTN_IN_UNUSED_LBN 15
+#define MC_CMD_V2_EXTN_IN_UNUSED_WIDTH 1
+/* the actual length of the encapsulated command (which is not in the v1
+ * header)
+ */
+#define MC_CMD_V2_EXTN_IN_ACTUAL_LEN_LBN 16
+#define MC_CMD_V2_EXTN_IN_ACTUAL_LEN_WIDTH 10
+#define MC_CMD_V2_EXTN_IN_UNUSED2_LBN 26
+#define MC_CMD_V2_EXTN_IN_UNUSED2_WIDTH 2
+/* Type of command/response */
+#define MC_CMD_V2_EXTN_IN_MESSAGE_TYPE_LBN 28
+#define MC_CMD_V2_EXTN_IN_MESSAGE_TYPE_WIDTH 4
+/* enum: MCDI command directed to or response originating from the MC. */
+#define MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_MC 0x0
+/* enum: MCDI command directed to a TSA controller. MCDI responses of this type
+ * are not defined.
+ */
+#define MC_CMD_V2_EXTN_IN_MCDI_MESSAGE_TYPE_TSA 0x1
+/***********************************/
+/* MC_CMD_TRIGGER_INTERRUPT
+ * Trigger an interrupt by prodding the BIU.
+ */
+#define MC_CMD_TRIGGER_INTERRUPT 0xe3
+#define MC_CMD_TRIGGER_INTERRUPT_MSGSET 0xe3
+
+/* MC_CMD_TRIGGER_INTERRUPT_IN msgrequest */
+#define MC_CMD_TRIGGER_INTERRUPT_IN_LEN 4
+/* Interrupt level relative to base for function. */
+#define MC_CMD_TRIGGER_INTERRUPT_IN_INTR_LEVEL_OFST 0
+#define MC_CMD_TRIGGER_INTERRUPT_IN_INTR_LEVEL_LEN 4
+
+/* MC_CMD_TRIGGER_INTERRUPT_OUT msgresponse */
+#define MC_CMD_TRIGGER_INTERRUPT_OUT_LEN 0
+/***********************************/
+/* MC_CMD_SET_EVQ_TMR
+ * Update the timer load, timer reload and timer mode values for a given EVQ.
+ * The requested timer values (in TMR_LOAD_REQ_NS and TMR_RELOAD_REQ_NS) will
+ * be rounded up to the granularity supported by the hardware, then truncated
+ * to the range supported by the hardware. The resulting value after the
+ * rounding and truncation will be returned to the caller (in TMR_LOAD_ACT_NS
+ * and TMR_RELOAD_ACT_NS).
+ */
+#define MC_CMD_SET_EVQ_TMR 0x120
+#define MC_CMD_SET_EVQ_TMR_MSGSET 0x120
+
+/* MC_CMD_SET_EVQ_TMR_IN msgrequest */
+#define MC_CMD_SET_EVQ_TMR_IN_LEN 16
+/* Function-relative queue instance */
+#define MC_CMD_SET_EVQ_TMR_IN_INSTANCE_OFST 0
+#define MC_CMD_SET_EVQ_TMR_IN_INSTANCE_LEN 4
+/* Requested value for timer load (in nanoseconds) */
+#define MC_CMD_SET_EVQ_TMR_IN_TMR_LOAD_REQ_NS_OFST 4
+#define MC_CMD_SET_EVQ_TMR_IN_TMR_LOAD_REQ_NS_LEN 4
+/* Requested value for timer reload (in nanoseconds) */
+#define MC_CMD_SET_EVQ_TMR_IN_TMR_RELOAD_REQ_NS_OFST 8
+#define MC_CMD_SET_EVQ_TMR_IN_TMR_RELOAD_REQ_NS_LEN 4
+/* Timer mode. Meanings as per EVQ_TMR_REG.TC_TIMER_VAL */
+#define MC_CMD_SET_EVQ_TMR_IN_TMR_MODE_OFST 12
+#define MC_CMD_SET_EVQ_TMR_IN_TMR_MODE_LEN 4
+#define MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_DIS 0x0 /* enum */
+#define MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_IMMED_START 0x1 /* enum */
+#define MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_TRIG_START 0x2 /* enum */
+#define MC_CMD_SET_EVQ_TMR_IN_TIMER_MODE_INT_HLDOFF 0x3 /* enum */
+
+/* MC_CMD_SET_EVQ_TMR_OUT msgresponse */
+#define MC_CMD_SET_EVQ_TMR_OUT_LEN 8
+/* Actual value for timer load (in nanoseconds) */
+#define MC_CMD_SET_EVQ_TMR_OUT_TMR_LOAD_ACT_NS_OFST 0
+#define MC_CMD_SET_EVQ_TMR_OUT_TMR_LOAD_ACT_NS_LEN 4
+/* Actual value for timer reload (in nanoseconds) */
+#define MC_CMD_SET_EVQ_TMR_OUT_TMR_RELOAD_ACT_NS_OFST 4
+#define MC_CMD_SET_EVQ_TMR_OUT_TMR_RELOAD_ACT_NS_LEN 4
+
+/***********************************/
+/* MC_CMD_GET_EVQ_TMR_PROPERTIES
+ * Query properties about the event queue timers.
+ */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES 0x122
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_MSGSET 0x122
+
+/* MC_CMD_GET_EVQ_TMR_PROPERTIES_IN msgrequest */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_IN_LEN 0
+
+/* MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT msgresponse */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_LEN 36
+/* Reserved for future use. */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_FLAGS_OFST 0
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_FLAGS_LEN 4
+/* For timers updated via writes to EVQ_TMR_REG, this is the time interval (in
+ * nanoseconds) for each increment of the timer load/reload count. The
+ * requested duration of a timer is this value multiplied by the timer
+ * load/reload count.
+ */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_TMR_REG_NS_PER_COUNT_OFST 4
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_TMR_REG_NS_PER_COUNT_LEN 4
+/* For timers updated via writes to EVQ_TMR_REG, this is the maximum value
+ * allowed for timer load/reload counts.
+ */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_TMR_REG_MAX_COUNT_OFST 8
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_TMR_REG_MAX_COUNT_LEN 4
+/* For timers updated via writes to EVQ_TMR_REG, timer load/reload counts not a
+ * multiple of this step size will be rounded in an implementation defined
+ * manner.
+ */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_TMR_REG_STEP_OFST 12
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_TMR_REG_STEP_LEN 4
+/* Maximum timer duration (in nanoseconds) for timers updated via MCDI. Only
+ * meaningful if MC_CMD_SET_EVQ_TMR is implemented.
+ */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_MCDI_TMR_MAX_NS_OFST 16
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_MCDI_TMR_MAX_NS_LEN 4
+/* Timer durations requested via MCDI that are not a multiple of this step size
+ * will be rounded up. Only meaningful if MC_CMD_SET_EVQ_TMR is implemented.
+ */
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_MCDI_TMR_STEP_NS_OFST 20
+#define MC_CMD_GET_EVQ_TMR_PROPERTIES_OUT_MCDI_TMR_STEP_NS_LEN 4
+#endif /* MCDI_PCOL_H */
diff --git a/drivers/net/ethernet/amd/efct/mcdi_port_common.c b/drivers/net/ethernet/amd/efct/mcdi_port_common.c
new file mode 100644
index 000000000000..a243251ceebd
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi_port_common.c
@@ -0,0 +1,949 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include "efct_common.h"
+#include "mcdi.h"
+#include "mcdi_port_common.h"
+#include "efct_bitfield.h"
+
+/*	MAC statistics
+ */
+
+int efct_mcdi_mac_stats(struct efct_nic *efct,
+			enum efct_stats_action action, int clear,
+		       void *outbuf, size_t buflen)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAC_STATS_IN_LEN);
+	int dma, change;
+	size_t outlen;
+	u32 dma_len;
+	int rc = 0;
+
+	change = 0;
+	if (action == EFCT_STATS_ENABLE)
+		efct->stats_enabled = true;
+	else if (action == EFCT_STATS_DISABLE)
+		efct->stats_enabled = false;
+
+	dma = (action == EFCT_STATS_PULL) || efct->stats_enabled;
+	if (action == EFCT_STATS_NODMA)
+		change = 0;
+	else if (action != EFCT_STATS_PULL)
+		change = 1;
+
+	dma_len = dma ? efct->num_mac_stats * sizeof(u64) : 0;
+
+	BUILD_BUG_ON(MC_CMD_MAC_STATS_OUT_DMA_LEN != 0);
+
+	MCDI_SET_QWORD(inbuf, MAC_STATS_IN_DMA_ADDR, 0ul);
+	MCDI_POPULATE_DWORD_7(inbuf, MAC_STATS_IN_CMD,
+			      MAC_STATS_IN_DMA, dma,
+			      MAC_STATS_IN_CLEAR, clear,
+			      MAC_STATS_IN_PERIODIC_CHANGE, change,
+			      MAC_STATS_IN_PERIODIC_ENABLE, efct->stats_enabled,
+			      MAC_STATS_IN_PERIODIC_CLEAR, 0,
+			      MAC_STATS_IN_PERIODIC_NOEVENT, 1,
+			      MAC_STATS_IN_PERIOD_MS, efct->stats_period_ms);
+	MCDI_SET_DWORD(inbuf, MAC_STATS_IN_DMA_LEN, dma_len);
+	MCDI_SET_DWORD(inbuf, MAC_STATS_IN_PORT_ID, EVB_PORT_ID_ASSIGNED);
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_MAC_STATS, inbuf, sizeof(inbuf),
+				 outbuf, buflen, &outlen);
+	if (rc)
+		efct_mcdi_display_error(efct, MC_CMD_MAC_STATS, sizeof(inbuf),
+					NULL, 0, rc);
+
+	return rc;
+}
+
+void efct_mcdi_mac_fini_stats(struct efct_nic *efct)
+{
+	kfree(efct->mc_initial_stats);
+	efct->mc_initial_stats = NULL;
+
+	kfree(efct->mc_mac_stats);
+	efct->mc_mac_stats = NULL;
+}
+
+int efct_mcdi_mac_init_stats(struct efct_nic *efct)
+{
+	if (!efct->num_mac_stats)
+		return 0;
+
+	efct->mc_initial_stats =
+		kcalloc(efct->num_mac_stats, sizeof(u64), GFP_KERNEL);
+	if (!efct->mc_initial_stats) {
+		netif_warn(efct, probe, efct->net_dev,
+			   "failed to allocate initial MC stats buffer\n");
+		return -ENOMEM;
+	}
+
+	efct->mc_mac_stats =
+		kcalloc(efct->num_mac_stats, sizeof(u64), GFP_KERNEL);
+	if (!efct->mc_mac_stats) {
+		netif_warn(efct, probe, efct->net_dev,
+			   "failed to allocate MC stats buffer\n");
+		efct_mcdi_mac_fini_stats(efct);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int efct_mcdi_port_get_number(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PORT_ASSIGNMENT_OUT_LEN);
+	size_t outlen = 0;
+	int rc;
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_PORT_ASSIGNMENT, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+
+	if (outlen < MC_CMD_GET_PORT_ASSIGNMENT_OUT_LEN)
+		return -EIO;
+
+	return MCDI_DWORD(outbuf, GET_PORT_ASSIGNMENT_OUT_PORT);
+}
+
+/*	Event processing
+ */
+static u32 efct_mcdi_event_link_speed[] = {
+	[MCDI_EVENT_LINKCHANGE_SPEED_100M] = 100,
+	[MCDI_EVENT_LINKCHANGE_SPEED_1G] = 1000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_10G] = 10000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_40G] = 40000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_25G] = 25000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_50G] = 50000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_100G] = 100000,
+};
+
+static u8 efct_mcdi_link_state_flags(struct efct_link_state *link_state)
+{
+	return (link_state->up ? (1 << MC_CMD_GET_LINK_OUT_V2_LINK_UP_LBN) : 0) |
+		(link_state->fd ? (1 << MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_LBN) : 0);
+}
+
+static u8 efct_mcdi_link_state_fcntl(struct efct_link_state *link_state)
+{
+	switch (link_state->fc) {
+	case EFCT_FC_AUTO | EFCT_FC_TX | EFCT_FC_RX:
+		return MC_CMD_FCNTL_AUTO;
+	case EFCT_FC_TX | EFCT_FC_RX:
+		return MC_CMD_FCNTL_BIDIR;
+	case EFCT_FC_RX:
+		return MC_CMD_FCNTL_RESPOND;
+	case EFCT_FC_OFF:
+		return MC_CMD_FCNTL_OFF;
+	default:
+		WARN_ON_ONCE(1);
+		return MC_CMD_FCNTL_OFF;
+	}
+}
+
+bool efct_mcdi_phy_poll(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
+	struct efct_link_state old_state = efct->link_state;
+	int rc;
+
+	WARN_ON(!mutex_is_locked(&efct->mac_lock));
+
+	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_LINK, NULL, 0,
+			   outbuf, sizeof(outbuf), NULL);
+	if (rc) {
+		efct->link_state.up = false;
+	} else {
+		u32 lp_caps = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_LP_CAP);
+		u32 ld_caps = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_CAP);
+
+		efct_mcdi_phy_decode_link(efct, &efct->link_state,
+					  MCDI_DWORD(outbuf, GET_LINK_OUT_V2_LINK_SPEED),
+					 MCDI_DWORD(outbuf, GET_LINK_OUT_V2_FLAGS),
+					 MCDI_DWORD(outbuf, GET_LINK_OUT_V2_FCNTL),
+					 ld_caps, lp_caps);
+	}
+
+	return !efct_link_state_equal(&efct->link_state, &old_state);
+}
+
+void efct_mcdi_phy_decode_link(struct efct_nic *efct,
+			       struct efct_link_state *link_state,
+			      u32 speed, u32 flags, u32 fcntl,
+			      u32 ld_caps, u32 lp_caps)
+{
+	switch (fcntl) {
+	case MC_CMD_FCNTL_AUTO:
+		WARN_ON(1); /* This is not a link mode */
+		link_state->fc = EFCT_FC_AUTO | EFCT_FC_TX | EFCT_FC_RX;
+		break;
+	case MC_CMD_FCNTL_BIDIR:
+		link_state->fc = EFCT_FC_TX | EFCT_FC_RX;
+		break;
+	case MC_CMD_FCNTL_RESPOND:
+		link_state->fc = EFCT_FC_RX;
+		break;
+	case MC_CMD_FCNTL_OFF:
+		link_state->fc = 0;
+		break;
+	default:
+		WARN_ON(1);
+		link_state->fc = 0;
+	}
+
+	link_state->up = !!(flags & (1 << MC_CMD_GET_LINK_OUT_V2_LINK_UP_LBN));
+	link_state->fd = !!(flags & (1 << MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_LBN));
+	link_state->speed = speed;
+	link_state->ld_caps = ld_caps;
+	link_state->lp_caps = lp_caps;
+}
+
+void efct_mcdi_process_link_change_v2(struct efct_nic *efct, union efct_qword *ev)
+{
+	u32 link_up, flags, fcntl, speed, lpa;
+
+	speed = EFCT_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_V2_SPEED);
+	if (speed >= ARRAY_SIZE(efct_mcdi_event_link_speed)) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Link speed %u received in FW response is not supported\n", speed);
+		return;
+	}
+	speed = efct_mcdi_event_link_speed[speed];
+
+	link_up = EFCT_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_V2_FLAGS_LINK_UP);
+	fcntl = EFCT_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_V2_FCNTL);
+	lpa = EFCT_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_V2_LP_CAP);
+	flags = efct_mcdi_link_state_flags(&efct->link_state) &
+		~(1 << MC_CMD_GET_LINK_OUT_V2_LINK_UP_LBN);
+	flags |= !!link_up << MC_CMD_GET_LINK_OUT_V2_LINK_UP_LBN;
+	flags |= 1 << MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_LBN;
+
+	efct_mcdi_phy_decode_link(efct, &efct->link_state, speed, flags, fcntl,
+				  efct->link_state.ld_caps, lpa);
+
+	efct_link_status_changed(efct);
+
+	// efct_mcdi_phy_check_fcntl(efct, lpa); //TODO
+}
+
+void efct_mcdi_process_module_change(struct efct_nic *efct, union efct_qword *ev)
+{
+	u8 flags = efct_mcdi_link_state_flags(&efct->link_state);
+	u32 ld_caps;
+
+	ld_caps = EFCT_QWORD_FIELD(*ev, MCDI_EVENT_MODULECHANGE_LD_CAP);
+
+	flags |= 1 << MC_CMD_GET_LINK_OUT_V2_FULL_DUPLEX_LBN;
+
+	/* efct->link_state is only modified by efct_mcdi_phy_get_link().
+	 * Therefore, it is safe to modify the link state outside of the mac_lock here.
+	 */
+	efct_mcdi_phy_decode_link(efct, &efct->link_state, efct->link_state.speed,
+				  flags,
+				 efct_mcdi_link_state_fcntl(&efct->link_state),
+				 ld_caps, 0);
+
+	efct_link_status_changed(efct);
+}
+
+bool efct_mcdi_port_process_event_common(struct efct_ev_queue *evq, union efct_qword *event)
+{
+	int code = EFCT_QWORD_FIELD(*event, MCDI_EVENT_CODE);
+	struct efct_nic *efct = evq->efct;
+
+	switch (code) {
+	case MCDI_EVENT_CODE_LINKCHANGE_V2:
+		efct_mcdi_process_link_change_v2(efct, event);
+		return true;
+	case MCDI_EVENT_CODE_MODULECHANGE:
+		efct_mcdi_process_module_change(efct, event);
+		return true;
+	case MCDI_EVENT_CODE_DYNAMIC_SENSORS_STATE_CHANGE:
+	case MCDI_EVENT_CODE_DYNAMIC_SENSORS_CHANGE:
+		efct_mcdi_dynamic_sensor_event(efct, event);
+		return true;
+	}
+
+	return false;
+}
+
+u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
+{
+	u32 result = 0;
+
+	if (test_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_10HDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_10FDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_100HDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, linkset) ||
+	    test_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT, linkset) ||
+	    test_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT, linkset) ||
+	    test_bit(ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_PAUSE_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_ASYM_LBN);
+	if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, linkset))
+		result |= (1 << MC_CMD_PHY_CAP_AN_LBN);
+
+	return result;
+}
+
+u32 efct_get_mcdi_caps(struct efct_nic *efct)
+{
+	return ethtool_linkset_to_mcdi_cap(efct->link_advertising);
+}
+
+void efct_link_set_wanted_fc(struct efct_nic *efct, u8 wanted_fc)
+{
+	efct->wanted_fc = wanted_fc;
+	if (efct->link_advertising[0] & ADVERTISED_Autoneg) {
+		if (wanted_fc & EFCT_FC_RX)
+			efct->link_advertising[0] |= (ADVERTISED_Pause |
+						     ADVERTISED_Asym_Pause);
+		else
+			efct->link_advertising[0] &= ~(ADVERTISED_Pause |
+						      ADVERTISED_Asym_Pause);
+		if (wanted_fc & EFCT_FC_TX)
+			efct->link_advertising[0] ^= ADVERTISED_Asym_Pause;
+	}
+}
+
+u32 efct_get_mcdi_phy_flags(struct efct_nic *efct)
+{
+	struct efct_mcdi_phy_data *phy_cfg = efct->phy_data;
+	enum efct_phy_mode mode, supported;
+	u32 flags;
+
+	/* TODO: Advertise the capabilities supported by this PHY */
+	supported = 0;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_TXDIS_LBN))
+		supported |= PHY_MODE_TX_DISABLED;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_LBN))
+		supported |= PHY_MODE_LOW_POWER;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_POWEROFF_LBN))
+		supported |= PHY_MODE_OFF;
+
+	mode = efct->phy_mode & supported;
+	flags = 0;
+	if (mode & PHY_MODE_TX_DISABLED)
+		flags |= (1 << MC_CMD_SET_LINK_IN_V2_TXDIS_LBN);
+	if (mode & PHY_MODE_LOW_POWER)
+		flags |= (1 << MC_CMD_SET_LINK_IN_V2_LOWPOWER_LBN);
+	if (mode & PHY_MODE_OFF)
+		flags |= (1 << MC_CMD_SET_LINK_IN_V2_POWEROFF_LBN);
+
+	if (efct->state != STATE_UNINIT && !netif_running(efct->net_dev))
+		flags |= (1 << MC_CMD_SET_LINK_IN_V2_LINKDOWN_LBN);
+
+	return flags;
+}
+
+int efct_mcdi_port_reconfigure(struct efct_nic *efct)
+{
+	return efct_mcdi_set_link(efct, efct_get_mcdi_caps(efct),
+				 efct_get_mcdi_phy_flags(efct),
+				 efct->loopback_mode, SET_LINK_SEQ_IGNORE);
+}
+
+int efct_mcdi_get_phy_cfg(struct efct_nic *efct, struct efct_mcdi_phy_data *cfg)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_CFG_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_IN_LEN != 0);
+	BUILD_BUG_ON(sizeof(cfg->name) != MC_CMD_GET_PHY_CFG_OUT_NAME_LEN);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_PHY_CFG, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		goto fail;
+
+	if (outlen < MC_CMD_GET_PHY_CFG_OUT_LEN) {
+		rc = -EIO;
+		goto fail;
+	}
+
+	cfg->flags = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_FLAGS);
+	cfg->type = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_TYPE);
+	cfg->supported_cap =
+		MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_SUPPORTED_CAP);
+	cfg->channel = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_CHANNEL);
+	cfg->port = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_PRT);
+	cfg->stats_mask = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_STATS_MASK);
+	memcpy(cfg->name, MCDI_PTR(outbuf, GET_PHY_CFG_OUT_NAME),
+	       sizeof(cfg->name));
+	cfg->media = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_MEDIA_TYPE);
+	cfg->mmd_mask = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_MMD_MASK);
+	memcpy(cfg->revision, MCDI_PTR(outbuf, GET_PHY_CFG_OUT_REVISION),
+	       sizeof(cfg->revision));
+
+	return 0;
+
+fail:
+	netif_err(efct, hw, efct->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	return rc;
+}
+
+static u32 efct_calc_mac_mtu(struct efct_nic *efct)
+{
+	return EFCT_MAX_FRAME_LEN(efct->net_dev->mtu);
+}
+
+int efct_mcdi_set_mac(struct efct_nic *efct)
+{
+	bool forward_fcs = !!(efct->net_dev->features & NETIF_F_RXFCS);
+	MCDI_DECLARE_BUF(cmdbytes, MC_CMD_SET_MAC_V3_IN_LEN);
+	u32 fcntl;
+
+	ether_addr_copy(MCDI_PTR(cmdbytes, SET_MAC_V3_IN_ADDR),
+			efct->net_dev->dev_addr);
+
+	MCDI_POPULATE_DWORD_3(cmdbytes, SET_MAC_V3_IN_CONTROL,
+			      SET_MAC_V3_IN_CFG_MTU, 1,
+			      SET_MAC_V3_IN_CFG_FCNTL, 1,
+			      SET_MAC_V3_IN_CFG_FCS, 1);
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_V3_IN_MTU, efct_calc_mac_mtu(efct));
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_V3_IN_DRAIN, 0);
+
+	switch (efct->wanted_fc) {
+	case EFCT_FC_RX | EFCT_FC_TX:
+		fcntl = MC_CMD_FCNTL_BIDIR;
+		break;
+	case EFCT_FC_RX:
+		fcntl = MC_CMD_FCNTL_RESPOND;
+		break;
+	default:
+		fcntl = MC_CMD_FCNTL_OFF;
+		break;
+	}
+
+	if (efct->wanted_fc & EFCT_FC_AUTO)
+		fcntl = MC_CMD_FCNTL_AUTO;
+	if (efct->fc_disable)
+		fcntl = MC_CMD_FCNTL_OFF;
+
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_V3_IN_FCNTL, fcntl);
+	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_V3_IN_FLAGS,
+			      SET_MAC_V3_IN_FLAG_INCLUDE_FCS, forward_fcs);
+
+	return efct_mcdi_rpc(efct, MC_CMD_SET_MAC, cmdbytes, sizeof(cmdbytes),
+			    NULL, 0, NULL);
+}
+
+int efct_mcdi_set_link(struct efct_nic *efct, u32 capabilities,
+		       u32 flags, u32 loopback_mode,  u8 seq)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_LINK_IN_V2_LEN);
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_SET_LINK_OUT_LEN != 0);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_V2_CAP, capabilities);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_V2_FLAGS, flags);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_V2_LOOPBACK_MODE, loopback_mode);
+	/*TODO revisit SPEED settings once autoneg is supported */
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_V2_LOOPBACK_SPEED, 10000 /* 10 Gbps */);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_V2_MODULE_SEQ, seq);
+	rc = efct_mcdi_rpc(efct, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+	return rc;
+}
+
+int efct_mcdi_loopback_modes(struct efct_nic *efct, u64 *loopback_modes)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LOOPBACK_MODES_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_LOOPBACK_MODES, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		goto fail;
+
+	if (outlen < (MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_OFST +
+		MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LEN)) {
+		rc = -EIO;
+		goto fail;
+	}
+
+	*loopback_modes = MCDI_QWORD(outbuf, GET_LOOPBACK_MODES_OUT_SUGGESTED);
+	return 0;
+
+fail:
+	netif_err(efct, hw, efct->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	return rc;
+}
+
+#define MAP_CAP(mcdi_cap, ethtool_cap) do { \
+	if (cap & (1 << MC_CMD_PHY_CAP_##mcdi_cap##_LBN)) \
+		SET_CAP(ethtool_cap); \
+	cap &= ~(1 << MC_CMD_PHY_CAP_##mcdi_cap##_LBN); \
+} while (0)
+#define SET_CAP(name)  __set_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
+				 linkset)
+void mcdi_to_ethtool_linkset(struct efct_nic *efct, u32 media, u32 cap,
+			     unsigned long *linkset)
+{
+	bitmap_zero(linkset, __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	switch (media) {
+	case MC_CMD_MEDIA_XFP:
+	case MC_CMD_MEDIA_SFP_PLUS:
+	case MC_CMD_MEDIA_QSFP_PLUS:
+	case MC_CMD_MEDIA_DSFP:
+		SET_CAP(FIBRE);
+		MAP_CAP(1000FDX, 1000baseT_Full);
+		MAP_CAP(10000FDX, 10000baseT_Full);
+		MAP_CAP(40000FDX, 40000baseCR4_Full);
+		break;
+	}
+
+	MAP_CAP(PAUSE, Pause);
+	MAP_CAP(ASYM, Asym_Pause);
+	MAP_CAP(AN, Autoneg);
+}
+
+#undef SET_CAP
+#undef MAP_CAP
+
+static u8 mcdi_to_ethtool_media(struct efct_nic *efct)
+{
+	struct efct_mcdi_phy_data *phy_data = efct->phy_data;
+
+	switch (phy_data->media) {
+	case MC_CMD_MEDIA_XAUI:
+	case MC_CMD_MEDIA_CX4:
+	case MC_CMD_MEDIA_KX4:
+		return PORT_OTHER;
+
+	case MC_CMD_MEDIA_XFP:
+	case MC_CMD_MEDIA_SFP_PLUS:
+	case MC_CMD_MEDIA_QSFP_PLUS:
+	case MC_CMD_MEDIA_DSFP:
+		return PORT_FIBRE;
+
+	case MC_CMD_MEDIA_BASE_T:
+		return PORT_TP;
+
+	default:
+		return PORT_OTHER;
+	}
+}
+
+void efct_link_set_advertising(struct efct_nic *efct,
+			       const unsigned long *advertising)
+{
+	memcpy(efct->link_advertising, advertising,
+	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
+	if (advertising[0] & ADVERTISED_Autoneg) {
+		if (advertising[0] & ADVERTISED_Pause)
+			efct->wanted_fc |= (EFCT_FC_TX | EFCT_FC_RX);
+		else
+			efct->wanted_fc &= ~(EFCT_FC_TX | EFCT_FC_RX);
+		if (advertising[0] & ADVERTISED_Asym_Pause)
+			efct->wanted_fc ^= EFCT_FC_TX;
+	}
+}
+
+void efct_mcdi_phy_get_ksettings(struct efct_nic *efct,
+				 struct ethtool_link_ksettings *out)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
+	struct efct_mcdi_phy_data *phy_cfg = efct->phy_data;
+	struct ethtool_link_settings *base = &out->base;
+	size_t outlen;
+	int rc;
+
+	if (netif_carrier_ok(efct->net_dev)) {
+		base->speed = efct->link_state.speed;
+		base->duplex = efct->link_state.fd ? DUPLEX_FULL : DUPLEX_HALF;
+	} else {
+		base->speed = 0;
+		base->duplex = DUPLEX_UNKNOWN;
+	}
+	base->port = mcdi_to_ethtool_media(efct);
+	base->phy_address = phy_cfg->port;
+	base->autoneg = efct->link_advertising[0] & ADVERTISED_Autoneg ?
+			AUTONEG_ENABLE :
+			AUTONEG_DISABLE;
+	mcdi_to_ethtool_linkset(efct, phy_cfg->media, phy_cfg->supported_cap,
+				out->link_modes.supported);
+	memcpy(out->link_modes.advertising, efct->link_advertising,
+	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_LINK, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return;
+	if (outlen < MC_CMD_GET_LINK_OUT_V2_LEN)
+		return;
+	mcdi_to_ethtool_linkset(efct, phy_cfg->media,
+				MCDI_DWORD(outbuf, GET_LINK_OUT_V2_LP_CAP),
+				out->link_modes.lp_advertising);
+}
+
+#define FEC_BIT(x) (1 << MC_CMD_PHY_CAP_##x##_LBN)
+/* Invert ethtool_fec_caps_to_mcdi. */
+static u32 mcdi_fec_caps_to_ethtool(u32 caps)
+{
+	bool rs = caps & FEC_BIT(RS_FEC),
+	     rs_req = caps & FEC_BIT(RS_FEC_REQUESTED),
+	     baser = caps & FEC_BIT(BASER_FEC),
+	     baser_req = caps & FEC_BIT(BASER_FEC_REQUESTED);
+
+	if (!baser && !rs)
+		return ETHTOOL_FEC_OFF;
+	return (rs_req ? ETHTOOL_FEC_RS : 0) |
+	       (baser_req ? ETHTOOL_FEC_BASER : 0) |
+	       (baser == baser_req && rs == rs_req ? 0 : ETHTOOL_FEC_AUTO);
+}
+
+#undef FEC_BIT
+
+int efct_mcdi_phy_get_fecparam(struct efct_nic *efct, struct ethtool_fecparam *fec)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
+	u32 caps, active; /* MCDI format */
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_LINK, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < MC_CMD_GET_LINK_OUT_V2_LEN)
+		return -EOPNOTSUPP;
+
+	caps = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_CAP);
+	fec->fec = mcdi_fec_caps_to_ethtool(caps);
+
+	active = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_FEC_TYPE);
+	switch (active) {
+	case MC_CMD_FEC_NONE:
+		fec->active_fec = ETHTOOL_FEC_OFF;
+		break;
+	case MC_CMD_FEC_BASER:
+		fec->active_fec = ETHTOOL_FEC_BASER;
+		break;
+	case MC_CMD_FEC_RS:
+		fec->active_fec = ETHTOOL_FEC_RS;
+		break;
+	default:
+		netif_warn(efct, hw, efct->net_dev,
+			   "Firmware reports unrecognised FEC_TYPE %u\n",
+			   active);
+		/* We don't know what firmware has picked.  AUTO is as good a
+		 * "can't happen" value as any other.
+		 */
+		fec->active_fec = ETHTOOL_FEC_AUTO;
+		break;
+	}
+
+	return 0;
+}
+
+int efct_mcdi_set_id_led(struct efct_nic *efct, enum efct_led_mode mode)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_ID_LED_IN_LEN);
+	int rc;
+
+	BUILD_BUG_ON(EFCT_LED_OFF != MC_CMD_LED_OFF);
+	BUILD_BUG_ON(EFCT_LED_ON != MC_CMD_LED_ON);
+	BUILD_BUG_ON(EFCT_LED_DEFAULT != MC_CMD_LED_DEFAULT);
+
+	BUILD_BUG_ON(MC_CMD_SET_ID_LED_OUT_LEN != 0);
+
+	MCDI_SET_DWORD(inbuf, SET_ID_LED_IN_STATE, mode);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_SET_ID_LED, inbuf, sizeof(inbuf),
+			   NULL, 0, NULL);
+
+	return rc;
+}
+
+static int efct_mcdi_phy_get_module_eeprom_page(struct efct_nic *efct,
+						u16 bank,
+						u16 page,
+						u16 offset,
+						u8 *data,
+						u16 space);
+
+static int efct_mcdi_phy_get_module_eeprom_byte(struct efct_nic *efct,
+						int page,
+						u8 byte)
+{
+	u8 data;
+	int rc;
+
+	rc = efct_mcdi_phy_get_module_eeprom_page(efct, 0, page, byte, &data, 1);
+	if (rc == 1)
+		return data;
+
+	return rc;
+}
+
+static int efct_mcdi_phy_diag_type(struct efct_nic *efct)
+{
+	/* Page zero of the EEPROM includes the diagnostic type at byte 92. */
+	return efct_mcdi_phy_get_module_eeprom_byte(efct, 0, SFF_DIAG_TYPE_OFFSET);
+}
+
+static int efct_mcdi_phy_sff_8472_level(struct efct_nic *efct)
+{
+	/* Page zero of the EEPROM includes the DMT level at byte 94. */
+	return efct_mcdi_phy_get_module_eeprom_byte(efct, 0, SFF_DMT_LEVEL_OFFSET);
+}
+
+static u32 efct_mcdi_phy_module_type(struct efct_nic *efct)
+{
+	switch (efct_mcdi_phy_get_module_eeprom_byte(efct, 0, 0)) {
+	case SFF8024_ID_SFP:
+		return MC_CMD_MEDIA_SFP_PLUS;
+	case SFF8024_ID_DSFP:
+		return MC_CMD_MEDIA_DSFP;
+	default:
+		return 0;
+	}
+}
+
+static int efct_mcdi_phy_get_module_eeprom_page(struct efct_nic *efct,
+						u16 bank,
+						u16 page,
+						u16 offset,
+						u8 *data,
+						u16 space)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_PHY_MEDIA_INFO_IN_LEN);
+	u32 payload_len;
+	size_t outlen;
+	u32 to_copy;
+	int rc;
+
+	if (offset > ETH_MODULE_EEPROM_PAGE_LEN)
+		return -EINVAL;
+	to_copy = min_t(u16, space, ETH_MODULE_EEPROM_PAGE_LEN - offset);
+	MCDI_POPULATE_DWORD_2(inbuf, GET_PHY_MEDIA_INFO_IN_PAGE,
+			      GET_PHY_MEDIA_INFO_IN_DSFP_BANK, bank,
+			      GET_PHY_MEDIA_INFO_IN_DSFP_PAGE, page);
+	rc = efct_mcdi_rpc_quiet(efct, MC_CMD_GET_PHY_MEDIA_INFO,
+				 inbuf, sizeof(inbuf),
+				 outbuf, sizeof(outbuf),
+			&outlen);
+	if (rc)
+		return rc;
+
+	if (outlen < (MC_CMD_GET_PHY_MEDIA_INFO_OUT_DATA_OFST +
+			ETH_MODULE_EEPROM_PAGE_LEN)) {
+		/* There are SFP+ modules that claim to be SFF-8472 compliant
+		 * and do not provide diagnostic information, but they don't
+		 * return all bits 0 as the spec says they should...
+		 */
+		if (page >= 2 && page < 4 &&
+		    efct_mcdi_phy_module_type(efct) == MC_CMD_MEDIA_SFP_PLUS &&
+		    efct_mcdi_phy_sff_8472_level(efct) > 0 &&
+		    (efct_mcdi_phy_diag_type(efct) & SFF_DIAG_IMPLEMENTED) == 0) {
+			memset(data, 0, to_copy);
+			return to_copy;
+		}
+
+		return -EIO;
+	}
+	payload_len = MCDI_DWORD(outbuf, GET_PHY_MEDIA_INFO_OUT_DATALEN);
+	if (payload_len != ETH_MODULE_EEPROM_PAGE_LEN)
+		return -EIO;
+
+	memcpy(data, MCDI_PTR(outbuf, GET_PHY_MEDIA_INFO_OUT_DATA) + offset, to_copy);
+
+	return to_copy;
+}
+
+int efct_mcdi_phy_get_module_eeprom_locked(struct efct_nic *efct,
+					   struct ethtool_eeprom *ee,
+					   u8 *data)
+{
+	ssize_t space_remaining = ee->len;
+	bool ignore_missing;
+	int num_pages;
+	u32 page_off;
+	int  page;
+	int bank;
+	int rc;
+
+	switch (efct_mcdi_phy_module_type(efct)) {
+	case MC_CMD_MEDIA_SFP_PLUS:
+		num_pages = efct_mcdi_phy_sff_8472_level(efct) > 0 ?
+				SFF_8472_NUM_PAGES : SFF_8079_NUM_PAGES;
+		page = 0;
+		bank = 0;
+		ignore_missing = false;
+		break;
+	case MC_CMD_MEDIA_DSFP:
+		num_pages = SFF_8436_NUM_PAGES;
+		/* We obtain the lower page by asking for bank:page -1:-1. */
+		page = -1;
+		bank = -1;
+		ignore_missing = true; /* Ignore missing pages after page 0. */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	page_off = ee->offset % ETH_MODULE_EEPROM_PAGE_LEN;
+	page += ee->offset / ETH_MODULE_EEPROM_PAGE_LEN;
+	while (space_remaining && (page < num_pages)) {
+		if (page != -1)
+			bank = 0;
+		rc = efct_mcdi_phy_get_module_eeprom_page(efct, bank, page,
+							  page_off, data, space_remaining);
+
+		if (rc > 0) {
+			space_remaining -= rc;
+			data += rc;
+			page_off = 0;
+			page++;
+		} else if (rc == 0) {
+			space_remaining = 0;
+		} else if (ignore_missing && (page > 0)) {
+			int intended_size = ETH_MODULE_EEPROM_PAGE_LEN - page_off;
+
+			space_remaining -= intended_size;
+			if (space_remaining < 0) {
+				space_remaining = 0;
+			} else {
+				memset(data, 0, intended_size);
+				data += intended_size;
+				page_off = 0;
+				page++;
+				rc = 0;
+			}
+		} else {
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+int efct_mcdi_get_eeprom_page_locked(struct efct_nic *efct,
+				     const struct ethtool_module_eeprom *page_data,
+				     struct netlink_ext_ack *extack)
+{
+	int rc = -EIO;
+	int pagemc;
+	int bankmc;
+	int offset;
+
+	if (page_data->bank) {
+		NL_SET_ERR_MSG_MOD(extack, "EEPROM bank read not supported");
+		return rc;
+	}
+	/*Upper page memory starts from 128th byte, FW expects 0*/
+	offset = page_data->offset % ETH_MODULE_EEPROM_PAGE_LEN;
+	pagemc = page_data->page;
+	bankmc = page_data->bank;
+	switch (efct_mcdi_phy_module_type(efct)) {
+	case MC_CMD_MEDIA_SFP_PLUS:
+		break;
+	case MC_CMD_MEDIA_DSFP:
+		/* We obtain the lower page by asking for FFFF:FFFF. */
+		if (!page_data->page && page_data->offset < ETH_MODULE_EEPROM_PAGE_LEN) {
+			pagemc = -1;
+			bankmc = -1;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	rc = efct_mcdi_phy_get_module_eeprom_page(efct, bankmc,
+						  pagemc,
+						  offset,
+						  page_data->data,
+						  page_data->length);
+	if (rc < 0)
+		NL_SET_ERR_MSG_MOD(extack, "Failed to access module's EEPROM.");
+	return rc;
+}
+
+int efct_mcdi_phy_get_module_info_locked(struct efct_nic *efct,
+					 struct ethtool_modinfo *modinfo)
+{
+	int sff_8472_level;
+	int diag_type;
+
+	switch (efct_mcdi_phy_module_type(efct)) {
+	case MC_CMD_MEDIA_SFP_PLUS:
+		sff_8472_level = efct_mcdi_phy_sff_8472_level(efct);
+
+		/* If we can't read the diagnostics level we have none. */
+		if (sff_8472_level < 0)
+			return -EOPNOTSUPP;
+
+		/* Check if this module requires the (unsupported) address
+		 * change operation
+		 */
+		diag_type = efct_mcdi_phy_diag_type(efct);
+		if (diag_type < 0)
+			return -EOPNOTSUPP;
+		if (sff_8472_level == 0 ||
+		    (diag_type & SFF_DIAG_ADDR_CHANGE)) {
+			modinfo->type = ETH_MODULE_SFF_8079;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
+		} else {
+			modinfo->type = ETH_MODULE_SFF_8472;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		}
+		break;
+	case MC_CMD_MEDIA_DSFP:
+		modinfo->type = ETH_MODULE_SFF_8436;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+		break;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int efct_mcdi_phy_test_alive(struct efct_nic *efct)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_STATE_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_PHY_STATE_IN_LEN != 0);
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_PHY_STATE, NULL, 0,
+			   outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+
+	if (outlen < MC_CMD_GET_PHY_STATE_OUT_LEN)
+		return -EIO;
+	if (MCDI_DWORD(outbuf, GET_PHY_STATE_OUT_STATE) != MC_CMD_PHY_STATE_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
diff --git a/drivers/net/ethernet/amd/efct/mcdi_port_common.h b/drivers/net/ethernet/amd/efct/mcdi_port_common.h
new file mode 100644
index 000000000000..8f16f0c1db18
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/mcdi_port_common.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+ #ifndef EFCT_MCDI_PORT_COMMON_H
+#define EFCT_MCDI_PORT_COMMON_H
+
+enum efct_stats_action {
+	EFCT_STATS_ENABLE,
+	EFCT_STATS_DISABLE,
+	EFCT_STATS_PULL,
+	EFCT_STATS_PERIOD,
+	EFCT_STATS_NODMA,
+};
+
+#define MCDI_PORT_SPEED_CAPS   ((1 << MC_CMD_PHY_CAP_10HDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_10FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_100HDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_100FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_1000HDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_1000FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_10000FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_40000FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_100000FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_25000FDX_LBN) | \
+				(1 << MC_CMD_PHY_CAP_50000FDX_LBN))
+
+#define SET_LINK_SEQ_IGNORE BIT(MC_CMD_SET_LINK_IN_V2_MODULE_SEQ_IGNORE_LBN)
+
+#define SFF8024_ID_SFP		0x03
+#define SFF8024_ID_DSFP		0x1B
+#define SFF_DIAG_TYPE_OFFSET	92
+#define SFF_DIAG_ADDR_CHANGE	BIT(2)
+#define SFF_DIAG_IMPLEMENTED	BIT(6)
+#define SFF_8079_NUM_PAGES	2
+#define SFF_8472_NUM_PAGES	4
+#define SFF_8436_NUM_PAGES	5
+#define SFF_DMT_LEVEL_OFFSET	94
+
+struct efct_mcdi_phy_data {
+	u32 flags;
+	u32 type;
+	u32 supported_cap;
+	u32 channel;
+	u32 port;
+	u32 stats_mask;
+	u8 name[20];
+	u32 media;
+	u32 mmd_mask;
+	u8 revision[20];
+};
+
+int efct_mcdi_port_get_number(struct efct_nic *efct);
+int efct_mcdi_mac_init_stats(struct efct_nic *efct);
+void efct_mcdi_mac_fini_stats(struct efct_nic *efct);
+int efct_mcdi_mac_stats(struct efct_nic *efct,
+			enum efct_stats_action action, int clear,
+			void *outbuf, size_t buflen);
+int efct_mcdi_set_mac(struct efct_nic *efct);
+int efct_mcdi_get_phy_cfg(struct efct_nic *efct, struct efct_mcdi_phy_data *cfg);
+void mcdi_to_ethtool_linkset(struct efct_nic *efct, u32 media, u32 cap,
+			     unsigned long *linkset);
+u32 efct_get_mcdi_phy_flags(struct efct_nic *efct);
+
+int efct_mcdi_set_link(struct efct_nic *efct, u32 capabilities,
+		       u32 flags, u32 loopback_mode, u8 seq);
+void efct_link_set_advertising(struct efct_nic *efct, const unsigned long *advertising);
+void efct_link_set_wanted_fc(struct efct_nic *efct, u8 wanted_fc);
+u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset);
+int efct_mcdi_phy_set_ksettings(struct efct_nic *efct,
+				const struct ethtool_link_ksettings *settings,
+				unsigned long *advertising);
+void efct_mcdi_phy_get_ksettings(struct efct_nic *efct,
+				 struct ethtool_link_ksettings *out);
+void efct_mcdi_phy_decode_link(struct efct_nic *efct,
+			       struct efct_link_state *link_state,
+			       u32 speed, u32 flags, u32 fcntl,
+			       u32 ld_caps, u32 lp_caps);
+bool efct_mcdi_port_process_event_common(struct efct_ev_queue *evq, union efct_qword *event);
+void efct_mcdi_process_link_change_v2(struct efct_nic *efct, union efct_qword *ev);
+bool efct_mcdi_phy_poll(struct efct_nic *efct);
+int efct_mcdi_set_mac(struct efct_nic *efct);
+int efct_mcdi_loopback_modes(struct efct_nic *efct, u64 *loopback_modes);
+int efct_mcdi_phy_get_fecparam(struct efct_nic *efct, struct ethtool_fecparam *fec);
+u32 efct_get_mcdi_caps(struct efct_nic *efct);
+void efct_mcdi_process_module_change(struct efct_nic *efct, union efct_qword *ev);
+int efct_mcdi_set_id_led(struct efct_nic *efct, enum efct_led_mode mode);
+int efct_mcdi_phy_get_module_info_locked(struct efct_nic *efct,
+					 struct ethtool_modinfo *modinfo);
+int efct_mcdi_phy_get_module_eeprom_locked(struct efct_nic *efct,
+					   struct ethtool_eeprom *ee, u8 *data);
+int efct_mcdi_get_eeprom_page_locked(struct efct_nic *efct,
+				     const struct ethtool_module_eeprom *page_data,
+				     struct netlink_ext_ack *extack);
+int efct_mcdi_phy_test_alive(struct efct_nic *efct);
+#endif
-- 
2.25.1

