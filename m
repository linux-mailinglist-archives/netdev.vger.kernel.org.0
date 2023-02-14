Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0669A6960E2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjBNKgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjBNKgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:36:23 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51135222F7;
        Tue, 14 Feb 2023 02:36:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cM/PYjsHLwkxAGqtlj2WD68zXuUVFz55XDl0Vls9E0KL/lcv13EJiMgq3RHPs2bjJljHJmAQN7rRhybNOZ/WkdNeBcbT+jQypd/ifuG8IqNEvPgoNXs3K1D9FJ4EOspy3qVI4AP7Wsls4K29xUfgTe0Us5Ctkrwa6nHBvH9XGv4EZhbfGSvjDI09SCchTDZzw9qXLL2Iq7+KfZI+k+h9K4HVrGxeNriGXjcruSJOxmVPKwBlYW9Tkpah325WLWYHuo1NhLutiE25KnGLZmZc5QGBKN7oCmgOI2CeURPXfisl+7NbLQu6glv1hbpzmZxavPxbCV4O+0KVLkCPz1pRnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w924jj/BV0/jVSohmhQeHYqktZzdHqMn9RuDuRzGYo0=;
 b=DKvCbQjqeHLHm1N+LlX2+xBlonqocv0OfIio2SJrQi76aSCm5d7sVMriFTa4VzM9yV7wwj4jytD+dBHJ/aHLeQUSBChsSg/+451OK5d7XgBx1DpdmdQ+RS/jC7QDc3OCo+424SS5rVk6JxLBiJr1bqpvfpcPmtCeA2/YaBv/xTbsH7EaCElfUddqyCUkOCYsZRDFdkq2QF6Czrr87FxqXA+GJMF8XJN+JlX9aBcP0XJgPvKt4E9Us5WjPQr17YcWE21Wr8pufbHrm4YwWaLphpINmv3TpXsdYI8hxSYuOCGtpnxsxil/gxkd8NCRgxSUQ3nTaHW3sWkQfQampP4l8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w924jj/BV0/jVSohmhQeHYqktZzdHqMn9RuDuRzGYo0=;
 b=36lrO8R9NDSbEw7I9phYvvVD1rrrZGTKvNVC2WvEOBUFQrGFpcUsvOkc6EgSX6fZQbc/O+rJ5omEyVS46f47gjQ3ZqfAjg/ea27mhvdZwMz6KEyNP+1+qLcFimp8qPdYwSI1l/QQzua77KXbUEtEMsXvJi3DGuWbdnASyd7A6eQ=
Received: from MW4PR02CA0007.namprd02.prod.outlook.com (2603:10b6:303:16d::33)
 by BL3PR12MB6620.namprd12.prod.outlook.com (2603:10b6:208:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 10:36:18 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::c1) by MW4PR02CA0007.outlook.office365.com
 (2603:10b6:303:16d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 10:36:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 10:36:18 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Feb
 2023 04:36:17 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Feb
 2023 02:36:16 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Feb 2023 04:36:12 -0600
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>,
        <git@amd.com>
Subject: [PATCH net-next V4] dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml
Date:   Tue, 14 Feb 2023 16:06:11 +0530
Message-ID: <20230214103611.3599624-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT004:EE_|BL3PR12MB6620:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c64a26-16be-4583-f047-08db0e774e5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eedg3/qeYljbP+TQfCsjP3Dngi/63aibwBtWW+xDNZulak+5BmiRwaaGJUy+9TR1mA01jKcE8CnsJ2VViuGe0LBDNySlIPLTLgJBI8qvTol7BJQHZJ2R7SSglh4zulWAmxyRzBSUHQc/DJsspNYcAgQWI7S9sl6chHvcPNXLHGKTi8nKRTcNrMRndTAQToeu+R99VGKOJYIS/rxr3RLUNooUzi4dFSIzH7lTKSTTHu7uVkn+8G8HaA5do1tU1P0DIHwEaHOdZWADaFb1tHdscXXr509nQj4S5rAKpo1/0+OonA6NDoWKjTvmf/imO7vXQVqd1GX7+s3mLqTxcNIvkwNpj3+gHUxy3yjoFbL8s1cPqSAUtevUTNtYNBuevyZbCIbzc57EV+VL51gNG+xd+21JEHvm/HgLJw6guDG6uNYG8RKsHcAwSDhbA7DwG4AA6hE9ZFCz60N10n+368QcwX6HETCS+BY7OtFw/UB5loLM3QmDzPzSiufX7Suk5o0g3VQyiTdS4WEO++Zr2YG5i1zKp861Ctx95q8RM7SLBe0R8fAdmXFmLdX1SC4BCpHCx7JCJfFlJvwzzdPMOwTjsnA3hS4u3G2a6KOdDmXbtnDdJLFOw8DE394xFvCW/0s6sHmJKIxsIO9K26YLlkEmGhF3XrFNaG0hzyNKePPC/m7e7JJd6EnCaWC373p0p+iXSX5yItHAumongxkR7z/BZFzd0XZCBNcPd8wAwaKjq+RddzKCBpjwhgrUOTrr2XS1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(82740400003)(81166007)(7416002)(5660300002)(966005)(8936002)(478600001)(41300700001)(103116003)(36756003)(356005)(2616005)(2906002)(186003)(26005)(40480700001)(1076003)(316002)(86362001)(4326008)(8676002)(70586007)(70206006)(82310400005)(54906003)(40460700003)(110136005)(83380400001)(47076005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 10:36:18.0302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c64a26-16be-4583-f047-08db0e774e5f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6620
X-Spam-Status: No, score=1.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Convert the bindings document for Xilinx AXI Ethernet Subsystem
from txt to yaml. No changes to existing binding description.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
Changes in V4:
1)Changed the interrupts property and add allOf:if:then for it.

Changes in V3:
1) Moved RFC to PATCH.
2) Addressed below review comments
	a) Indentation.
	b) maxItems:3 does not match your description.
	c) Filename matching compatibles.

Changes in V2:
1) remove .txt and change the name of file to xlnx,axiethernet.yaml.
2) Fix DT check warning('device_type' does not match any of the regexes:
   'pinctrl-[0-9]+' From schema: Documentation/devicetree/bindings/net
    /xilinx_axienet.yaml).
---
 .../bindings/net/xlnx,axi-ethernet.yaml       | 166 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 167 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
new file mode 100644
index 000000000000..d2d276d4858f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -0,0 +1,166 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xlnx,axi-ethernet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: AXI 1G/2.5G Ethernet Subsystem
+
+description: |
+  Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
+  provides connectivity to an external ethernet PHY supporting different
+  interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
+  segments of memory for buffering TX and RX, as well as the capability of
+  offloading TX/RX checksum calculation off the processor.
+
+  Management configuration is done through the AXI interface, while payload is
+  sent and received through means of an AXI DMA controller. This driver
+  includes the DMA driver code, so this driver is incompatible with AXI DMA
+  driver.
+
+maintainers:
+  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
+
+properties:
+  compatible:
+    enum:
+      - xlnx,axi-ethernet-1.00.a
+      - xlnx,axi-ethernet-1.01.a
+      - xlnx,axi-ethernet-2.01.a
+
+  reg:
+    description:
+      Address and length of the IO space, as well as the address
+      and length of the AXI DMA controller IO space, unless
+      axistream-connected is specified, in which case the reg
+      attribute of the node referenced by it is used.
+    maxItems: 2
+
+  interrupts:
+    items:
+      - description: Ethernet core interrupt
+      - description: Tx DMA interrupt
+      - description: Rx DMA interrupt
+    description:
+      Ethernet core interrupt is optional. If axistream-connected property is
+      present DMA node should contains TX/RX DMA interrupts else DMA interrupt
+      resources are mentioned on ethernet node.
+    minItems: 1
+
+  phy-handle: true
+
+  xlnx,rxmem:
+    description:
+      Set to allocated memory buffer for Rx/Tx in the hardware.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  phy-mode: true
+
+  xlnx,phy-type:
+    description:
+      Do not use, but still accepted in preference to phy-mode.
+    deprecated: true
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  xlnx,txcsum:
+    description:
+      TX checksum offload. 0 or empty for disabling TX checksum offload,
+      1 to enable partial TX checksum offload and 2 to enable full TX
+      checksum offload.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2]
+
+  xlnx,rxcsum:
+    description:
+      RX checksum offload. 0 or empty for disabling RX checksum offload,
+      1 to enable partial RX checksum offload and 2 to enable full RX
+      checksum offload.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2]
+
+  xlnx,switch-x-sgmii:
+    type: boolean
+    description:
+      Indicate the Ethernet core is configured to support both 1000BaseX and
+      SGMII modes. If set, the phy-mode should be set to match the mode
+      selected on core reset (i.e. by the basex_or_sgmii core input line).
+
+  clocks:
+    items:
+      - description: Clock for AXI register slave interface.
+      - description: AXI4-Stream clock for TXD RXD TXC and RXS interfaces.
+      - description: Ethernet reference clock, used by signal delay primitives
+                     and transceivers.
+      - description: MGT reference clock (used by optional internal PCS/PMA PHY)
+
+  clock-names:
+    items:
+      - const: s_axi_lite_clk
+      - const: axis_clk
+      - const: ref_clk
+      - const: mgt_clk
+
+  axistream-connected:
+    type: object
+    description: Reference to another node which contains the resources
+      for the AXI DMA controller used by this device. If this is specified,
+      the DMA-related resources from that device (DMA registers and DMA
+      TX/RX interrupts) rather than this one will be used.
+
+  mdio: true
+
+  pcs-handle:
+    description: Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
+      modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
+      and "phy-handle" should point to an external PHY if exists.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+required:
+  - compatible
+  - interrupts
+  - reg
+  - xlnx,rxmem
+  - phy-handle
+
+allOf:
+  - if:
+      required:
+        - axistream-connected
+
+    then:
+      properties:
+        interrupts:
+          minItems: 2
+          maxItems: 3
+
+    else:
+      properties:
+        interrupts:
+          maxItems: 1
+
+additionalProperties: false
+
+examples:
+  - |
+    axi_ethernet_eth: ethernet@40c00000 {
+        compatible = "xlnx,axi-ethernet-1.00.a";
+        interrupt-parent = <&microblaze_0_axi_intc>;
+        interrupts = <2 0 1>;
+        clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
+        clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
+        phy-mode = "mii";
+        reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
+        xlnx,rxcsum = <0x2>;
+        xlnx,rxmem = <0x800>;
+        xlnx,txcsum = <0x2>;
+        phy-handle = <&phy0>;
+
+        axi_ethernetlite_0_mdio: mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            phy0: ethernet-phy@1 {
+                device_type = "ethernet-phy";
+                reg = <1>;
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 2cf9eb43ed8f..0bf527552dc9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22895,6 +22895,7 @@ F:	drivers/iio/adc/xilinx-ams.c
 XILINX AXI ETHERNET DRIVER
 M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX CAN DRIVER
-- 
2.25.1

