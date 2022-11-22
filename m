Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC39F633A19
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiKVKap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiKVKaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:30:06 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05E82735;
        Tue, 22 Nov 2022 02:25:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pn50trEsbStVSQSrzMEAvsuoG7QO8u1O74/Ltk9fR1MTQUqLD1AO0fQX9HI1Rbph7enRZFELdV4Pe3R55e/Jc40qsFBzTnnGGKgTzoDk0DjfIfoSVcR8iiN9/8eKWVTaX4MGQmzHikCeKIv83TquKxQkju45LIF4vwp4aXQLUIaXco9iVnmD++wA/mB4YE+wIF6gSXi9hChJ7FiepIhE2YNVcmregAUfeQvCUUxkNKf0gaJafAa8eOQatov3abGTF64QWhaqld8eMMMcAMYsjgW/vH1updu5MSsnTwINiX6ejtEF4KGxew9qwtArb/FkSemMYR71uU7iYIoSCV9l1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/YNnvnyP+Yor8LwnrYqTCqvuU5HZgNQ56dpTP4nFQg=;
 b=kDKkOigq8p/x2ka4O53N3UJRT+0sI48oJ/16jK8WsevwDSUWLaPPtT6ZZy0oWxR9IUm/a6ChT8v6/275e11OTLu2hq03eliGZ0ShfoR8DU+G+alDD+4a1X19ZH02GGPZEJmxid53Os40BDu9XZGraTlyzQdn2urBl2Me9lIAxVC1dybNKAF6YOemgTb3GLz07BaR2jgIXlgMqXWNQrTxheQKav4Rt7rKD7jKHl3f9w6uqgM40SK0E6S5l3b/QlQ2Vc9PdBNTCQKn7NGv5ZJeIUa+7AxLbubm3Z1t1Wlv6+0DILEHKUk4bKp7nvUPvV1WYBF/Ev59WWNQd9VNMx93Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/YNnvnyP+Yor8LwnrYqTCqvuU5HZgNQ56dpTP4nFQg=;
 b=RMl6BN8IpRJ6MpqdT27+PcpnQSv9a6QtMkZ+lTKMFeluGIqlfzKKzekyVOGd34Wesysxj2EKSidQ4oss5wTy92EDcdOpAvmdMdxmtuMkDXon+cU58ymv51XxzJbHKPe/GAErbPoUL19hdG7xqiGO17On7JZMaqC8jAzAax0qZmE=
Received: from BL1PR13CA0381.namprd13.prod.outlook.com (2603:10b6:208:2c0::26)
 by SN7PR12MB6959.namprd12.prod.outlook.com (2603:10b6:806:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:25:00 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:208:2c0:cafe::27) by BL1PR13CA0381.outlook.office365.com
 (2603:10b6:208:2c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17 via Frontend
 Transport; Tue, 22 Nov 2022 10:25:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Tue, 22 Nov 2022 10:25:00 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 22 Nov
 2022 04:24:58 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 22 Nov
 2022 04:24:42 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 22 Nov 2022 04:24:38 -0600
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
Subject: [PATCH net-next V3] dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml
Date:   Tue, 22 Nov 2022 15:54:37 +0530
Message-ID: <20221122102437.1702630-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|SN7PR12MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 08346b7d-451a-4b2c-5915-08dacc73cf85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KIdxJK5O5/kuRI8FdXp3MoP7yDtJ1LFtGYNatsHWe8LfM8n8qev0uPf7tkwbzqLSrx8/YdBCjJZppPhf/vl8xtgPwv6LcEi/G2PJhZlmcW6BFvrXDDsmUOZyBFO4FgKs472J8/aXgK4Fq2xqd5vdsM7jVp7bd71vTvVN8vPfSlrlrIRnH3Wh8ztB1u7wnx9ktsvWsyi7SfHDhT96Jn42lOXk3JLRNdxzRVI1rhJpnzO5uLgENCpVxYcMlPkz8maye3KiQTgkCCDbcjhYpGRJtbhnNg8sL+mztVQfbE5LBzhZwx/lnReoquIYQXCmdpEg6rDL+7z5tvUns8UDWtwvC3hR187yprr7sFUtg/aebPi6eOs/mkwg26e3cIRSczkRkM1MCvsD4vXVnDrFoa8w+PeyBd4rWS8CIjvA4bfEbRC+StAfhyDuUjTbcaEKCFkIUO3GjwlhdjpEp6sHLW8YEKr4i4rUCLvHDS4W5SZRiBoy7XxCOOjUMoLwJmxoYSfcGHaZWtR3NuDolBAnlfUelT9jFX/F2m8AA1/+ME70pYRpDRhVCxdyY/KeRJ4tBOTEk362XpeROnXgm6qwr+PH/XAjicEY0GPcCKfb2thL0IylcdJMUXpX2EG+/g3RaM33x9AHHoeqffJbE9K2mhYdDOWk0NvoWGRLA9TyngUpk5LjPvM0V1jj+K9TEZUoj4KuEO/Qit35JrcLHNNZG+0GK5HTzRqRsBZ8wD9k53W4iDCqPyUK8ovi2ruav0aJL8tqcxu7AzrQ9L77vyEXqhyil97kOlXK7wNP/Xgtuo8y3HRqyNyQz44DIypOVlvcB/Af
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(36756003)(70206006)(86362001)(82310400005)(40460700003)(1076003)(82740400003)(2616005)(103116003)(40480700001)(70586007)(41300700001)(8676002)(7416002)(336012)(8936002)(426003)(966005)(478600001)(316002)(26005)(186003)(5660300002)(47076005)(30864003)(81166007)(4326008)(54906003)(110136005)(83380400001)(356005)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:25:00.0806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08346b7d-451a-4b2c-5915-08dacc73cf85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6959
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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
 .../bindings/net/xilinx_axienet.txt           |  99 ------------
 .../bindings/net/xlnx,axi-ethernet.yaml       | 150 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 151 insertions(+), 99 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
deleted file mode 100644
index 1aa4c6006cd0..000000000000
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ /dev/null
@@ -1,99 +0,0 @@
-XILINX AXI ETHERNET Device Tree Bindings
---------------------------------------------------------
-
-Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
-provides connectivity to an external ethernet PHY supporting different
-interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
-segments of memory for buffering TX and RX, as well as the capability of
-offloading TX/RX checksum calculation off the processor.
-
-Management configuration is done through the AXI interface, while payload is
-sent and received through means of an AXI DMA controller. This driver
-includes the DMA driver code, so this driver is incompatible with AXI DMA
-driver.
-
-For more details about mdio please refer phy.txt file in the same directory.
-
-Required properties:
-- compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
-		  "xlnx,axi-ethernet-1.01.a", "xlnx,axi-ethernet-2.01.a"
-- reg		: Address and length of the IO space, as well as the address
-                  and length of the AXI DMA controller IO space, unless
-                  axistream-connected is specified, in which case the reg
-                  attribute of the node referenced by it is used.
-- interrupts	: Should be a list of 2 or 3 interrupts: TX DMA, RX DMA,
-		  and optionally Ethernet core. If axistream-connected is
-		  specified, the TX/RX DMA interrupts should be on that node
-		  instead, and only the Ethernet core interrupt is optionally
-		  specified here.
-- phy-handle	: Should point to the external phy device if exists. Pointing
-		  this to the PCS/PMA PHY is deprecated and should be avoided.
-		  See ethernet.txt file in the same directory.
-- xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
-
-Optional properties:
-- phy-mode	: See ethernet.txt
-- xlnx,phy-type	: Deprecated, do not use, but still accepted in preference
-		  to phy-mode.
-- xlnx,txcsum	: 0 or empty for disabling TX checksum offload,
-		  1 to enable partial TX checksum offload,
-		  2 to enable full TX checksum offload
-- xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
-- xlnx,switch-x-sgmii : Boolean to indicate the Ethernet core is configured to
-		  support both 1000BaseX and SGMII modes. If set, the phy-mode
-		  should be set to match the mode selected on core reset (i.e.
-		  by the basex_or_sgmii core input line).
-- clock-names: 	  Tuple listing input clock names. Possible clocks:
-		  s_axi_lite_clk: Clock for AXI register slave interface
-		  axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces
-		  ref_clk: Ethernet reference clock, used by signal delay
-			   primitives and transceivers
-		  mgt_clk: MGT reference clock (used by optional internal
-			   PCS/PMA PHY)
-
-		  Note that if s_axi_lite_clk is not specified by name, the
-		  first clock of any name is used for this. If that is also not
-		  specified, the clock rate is auto-detected from the CPU clock
-		  (but only on platforms where this is possible). New device
-		  trees should specify all applicable clocks by name - the
-		  fallbacks to an unnamed clock or to CPU clock are only for
-		  backward compatibility.
-- clocks: 	  Phandles to input clocks matching clock-names. Refer to common
-		  clock bindings.
-- axistream-connected: Reference to another node which contains the resources
-		       for the AXI DMA controller used by this device.
-		       If this is specified, the DMA-related resources from that
-		       device (DMA registers and DMA TX/RX interrupts) rather
-		       than this one will be used.
- - mdio		: Child node for MDIO bus. Must be defined if PHY access is
-		  required through the core's MDIO interface (i.e. always,
-		  unless the PHY is accessed through a different bus).
-
- - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
-		  modes, where "pcs-handle" should be used to point
-		  to the PCS/PMA PHY, and "phy-handle" should point to an
-		  external PHY if exists.
-
-Example:
-	axi_ethernet_eth: ethernet@40c00000 {
-		compatible = "xlnx,axi-ethernet-1.00.a";
-		device_type = "network";
-		interrupt-parent = <&microblaze_0_axi_intc>;
-		interrupts = <2 0 1>;
-		clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
-		clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
-		phy-mode = "mii";
-		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
-		xlnx,rxcsum = <0x2>;
-		xlnx,rxmem = <0x800>;
-		xlnx,txcsum = <0x2>;
-		phy-handle = <&phy0>;
-		axi_ethernetlite_0_mdio: mdio {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			phy0: phy@0 {
-				device_type = "ethernet-phy";
-				reg = <1>;
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
new file mode 100644
index 000000000000..5dc41ab7584b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -0,0 +1,150 @@
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
+
+allOf:
+  - $ref: ethernet-controller.yaml#
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
+    description:
+      Ethernet core interrupt is optional. If axistream-connected property is
+      present DMA node should contains TX/RX DMA interrupts else DMA interrupt
+      resources are mentioned on ethernet node.
+    maxItems: 3
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
+additionalProperties: false
+
+examples:
+  - |
+    axi_ethernet_eth: ethernet@40c00000 {
+        compatible = "xlnx,axi-ethernet-1.00.a";
+        interrupt-parent = <&microblaze_0_axi_intc>;
+        interrupts = <2>, <0>, <1>;
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
index 5c6ce094e55e..f9e748afba45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22556,6 +22556,7 @@ F:	drivers/iio/adc/xilinx-ams.c
 XILINX AXI ETHERNET DRIVER
 M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX CAN DRIVER
-- 
2.25.1

