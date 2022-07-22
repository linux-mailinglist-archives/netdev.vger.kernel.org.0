Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342C357D946
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiGVEHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiGVEGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2112.outbound.protection.outlook.com [40.107.237.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE64189AAE;
        Thu, 21 Jul 2022 21:06:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yuc8GK7omvCMzJunvK4+yCe6+OR8GhxVgC1hShvtGGLAsKHjLliYHGDnecLS/sh5xuWImIJgnm1E5s9EM9/4FpyR0v2wLbPkYpPev83dqCwV7uV949dRXYktEgEK2Yu5XkkL6gaeV+m+tayTNM8QcMt0PnChhyr5wNb66OHm/SSIqyKUW3rBNi2Z62By5q0j5BAtkE/xAzWjJPqdwr2UtrfUp5bJs629t+YR1Qm2+IumaZJ2HfV50cM8b/KO8BR3sMJgDe51RKmZujYTxBE5DZ8APc1ulpFUOkfmjn1LEkSnwF0FmdeuCvD8QMVGOglh7oXBXVrOIcYCRsashtm6MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=beoq/GP8KB6nG6SPJLuj6c3ukjQD3qlQL3Gw7qKxLGk=;
 b=RYAF0dksjNAQOhBYO6+AQq/vRowcCmPgefI1ksf0aiCQx2rGCVZOl9QEPOrJYoNC9cXuF2foIG+TgngwY/S5gaE4bttkGFznzaFKaUvvFgwIel+VLSPGZpxhzJerMfgMHIPwS9TRUyrUEbwHKYfWnhC49AdZIBFCbouM4q+91g0aNjK8Nim++VKhtPdDlLugd4nJA7JumEVm6vDNCHfSjSdS3RSM4VXjAbm7KQh6qR67cU8pbrt9iyguQV0FF77dWU+sTDk3E+1AIjwZNayC003I/WJeznjunM8kuCxbvv8McbwEgDYXNx7PbGPM3/MmeOpTyFCV2kaLZKzND1wJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=beoq/GP8KB6nG6SPJLuj6c3ukjQD3qlQL3Gw7qKxLGk=;
 b=jS7pc4UUQYqWiszPOBGsSsXeGP+O2X6H4AnCCUmlEfiamIu49E8Z01yJDl1vsmKbqAQUoX8TUGupdxz/GH+WRdBIYRHjLbnCQiyvlEyOKusNs6KVXxA7xECGXjSwyZryIzqF+upQ8E3UQHTzPx3Gk8Jf61UHDx7YrGIcbl9s8zk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:31 +0000
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
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v14 mfd 8/9] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Thu, 21 Jul 2022 21:06:08 -0700
Message-Id: <20220722040609.91703-9-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5e40fadb-17ac-478c-dbbc-08da6b978ed4
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AM/UiqnCEJjCN/y5F4iLUsvD5uykBnloCVBdrJ63vUrJQ/ZyHi6DOzmdj7T4wdxFfKZtxbGv5ekrGQhzUIZIx5YYJDnJ9KidbidGa5UGx14dH4p25sy6h6AU417G/hCamVvNkoyV5Z/xICzQCnA6OpJsWmH2URX1l7dHuUpA9/yaJ+hXhtuxO8IlyIGwUAKqGd1+2dsvC/VeebEmeXeq2Il/AnSHOrfHozMDaPzEeRjP/sic/lN+W91mDlu3bB/F6e3oI73mKPdxTgHZJx7wuK5pJ46JsKHc9m39boynAyuKgh9W658B/vVxjAuqRsYjgl1NYRZ2Eevu+dZjNDBj3lcdJceHEatS6XDa83b3y9w+wbEuJ6sVG6+SRw4QflE5+fJmrt1fzQCuj0CdunwtdLN3LuK8f1piefKFmkam8sOoLFkx1tUEmDm/E8rA66r2kwb10DXISGai19+bezuSwhY+pWBm28NLeYtM7g5mgKfpOloJDEs4bu+Jjtpx4lLp6ngymW6iy+dBUWQFu6XXdfGDLrutppdPOZPn8OLnj5v8o325M35IPq804rFOXhXOPDcL93qInWrnJ4AcAaL8h8aEqoAiRN7zL6Rg+zJkiAx251nwA/0qN5quKVMcof7pAuLz/6IplYsMNfVNxI2j3dv3qPQSfhuIxb9Yte8GkhpN2DczcZ0uStND9e2vIPNUlZska0+mamk6IiGg/LyL+RAPX07/AKjz/q2nCTE1fQRbbMphY9huXof1gEq2iyDQk1J6cABkdKOMYZBI2CQrR5o12HhS4Q8N9nXlcU6GnzGeQN334+fJEI1nzGj6OYpj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(966005)(86362001)(38100700002)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/0OoZmXQfMhTVhnikpm2tzJncqkiSiUv/sCX/2InJ7HvGV1Z6zMpALPaJn/x?=
 =?us-ascii?Q?wob3bLKX+3eU0qIUlHmoEGGfTlNblTPwRLJCFhSokPl9lr94RkkFxVCZLo6O?=
 =?us-ascii?Q?Err3N6dHLQcCtoRzv4NVxbJfByjLXhX0XlVnsdNjUO/mBU1KYIEoibAwhspL?=
 =?us-ascii?Q?bz2mEUW+lPEwALWWqm1m0WuRswx4rKvsT1SiSj0nUP77qRT4+HeGHpujQBTM?=
 =?us-ascii?Q?OmnoH0HVpEZ73nZfQtQwqgOrwvJW3/gfDuupj2W9XWvrcILQcrTGDxHsMMa8?=
 =?us-ascii?Q?fN59eJxpTqWMDvAaGL6XRK6teTMcLjPNKwwv1d7UmsF3KMFsPLSlReNzazd3?=
 =?us-ascii?Q?Pq6loU8/CNGwnFca+gFIWi4naUs4GXQlZw7iWBozwYcBNkDomLnmGQiTsfSG?=
 =?us-ascii?Q?69B9UYkqu8RoW5ndhsb2od3/GsM5+4OncnbpQ9oXibqQCgfiHKVal6J/ptdD?=
 =?us-ascii?Q?YtnOLuxdNRUAGwMCa34BcvjKIenDye3fpZJr7Jj0rPOzKiSKoaXhMtf9OAJi?=
 =?us-ascii?Q?V2vkd2eZjgSRceP+Ti7BXbIHET1nhbyAZ6k4wanZ7zwzhGvFCixExIc2R4nD?=
 =?us-ascii?Q?QtmkPMVk4ZqTnDz9rJb7Lzqrg6tnk5nMK/WtvZyqrGd4ARTbUtIAhTrHYnIH?=
 =?us-ascii?Q?vajAEBKidURoh2M8pHXALh6ODR0YVTfxyIRr7rUpWGzq2JSl9ZT1KLxA92BJ?=
 =?us-ascii?Q?q+FxDtc0Q+Fmh8REKauZuJvsqnpfXbXVQXme1xBPybs5tENyje45EZyStR1m?=
 =?us-ascii?Q?PU1+3ijy5YdF03pM6TeWdWAqHmBAMmYkPswsjWoPADa1w2ZZ7jG9yc7qqi6a?=
 =?us-ascii?Q?szQuIOMUYTGM0KjbPUrhJ+k9GpTBfqIAsBMDy3LuJxdmxUS1OQ6xFBN+2vhK?=
 =?us-ascii?Q?slmqyvY44JVZXtLMtUCqTAROID4eUc875yE3Okz3niGvErqON/0ZrNtEgZmh?=
 =?us-ascii?Q?n8aL4NEahi0s88NhjXYKYdVZCK8u6f1qggFurp+OZW/irTwyNEWx8ehsxcVU?=
 =?us-ascii?Q?KUih7COTx5rsCjPQcQj6/YQsX0dA5t7vPw3A83e5qhh09udyHRrhiezPP3Oy?=
 =?us-ascii?Q?M6t0kSpyIUgXWrxWdHbDpqW4Wh0VMNrZMt4HZ0id76BOF9FDzrs2wFl2jNCq?=
 =?us-ascii?Q?GASfxsr5UC7hCEWJBMIqvdzOcNfFQCuAGZSaLl/2mgmYdlTu6gYTqTSHeSGA?=
 =?us-ascii?Q?tDIR3j/f1lrAEGIKgXLVxZMD29zCzLqeAUPL2iABzid6uST57ScJRTA7UpRw?=
 =?us-ascii?Q?lvxGPpYyRVnWfspRTvdmXM/XycHEmdKfdDj+rb27GifPfQjZUNCCs10PPQPA?=
 =?us-ascii?Q?/4XV0ivfsg13u3nrKRbrU3+YO6buBj6rd5zJnhNzNsHa9NSBowjxfCv1eyNE?=
 =?us-ascii?Q?Mu5uVGivuvAYjCWdAVwircfg4iwAXsWiBE96U+E0XKIKA3oqbzQ19Y+YWrm2?=
 =?us-ascii?Q?XMa0xIAPVXMVLgYJvaSx26cCa21qyO4Eov3FmG/98HX1J0sMnQV5uElBWIS4?=
 =?us-ascii?Q?5uXjSeoWz9RBBt8v4LhaEYQkqBlQIxmmIKQgx2FEzOE/CPYXbgcC+nZ8Hxnn?=
 =?us-ascii?Q?8XDVz9WluHoaLSD0kJuQ5nw4AXi//926KbqNSMYy1reSAe7MFx73YlD/xOlV?=
 =?us-ascii?Q?YNN8CUVpbS0/PH0PL+nz7NI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e40fadb-17ac-478c-dbbc-08da6b978ed4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:30.8769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9x6x9JrRUcnGBRX7VkbBK/no5T6yQMBkjz5wUI8BHsxDfGweiXgNZVKt+oFJsm/bPfKIRf5Pkatu8tdexYBBRqVCF1oLQCFlyi1nxsIqdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
VSC7512.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v14
    * Add Vladimir Reviewed tag

---
 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
new file mode 100644
index 000000000000..8bf45a5673a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -0,0 +1,160 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/mfd/mscc,ocelot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ocelot Externally-Controlled Ethernet Switch
+
+maintainers:
+  - Colin Foster <colin.foster@in-advantage.com>
+
+description: |
+  The Ocelot ethernet switch family contains chips that have an internal CPU
+  (VSC7513, VSC7514) and chips that don't (VSC7511, VSC7512). All switches have
+  the option to be controlled externally, which is the purpose of this driver.
+
+  The switch family is a multi-port networking switch that supports many
+  interfaces. Additionally, the device can perform pin control, MDIO buses, and
+  external GPIO expanders.
+
+properties:
+  compatible:
+    enum:
+      - mscc,vsc7512
+
+  reg:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 1
+
+  spi-max-frequency:
+    maxItems: 1
+
+patternProperties:
+  "^pinctrl@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/pinctrl/mscc,ocelot-pinctrl.yaml
+
+  "^gpio@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/pinctrl/microchip,sparx5-sgpio.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,ocelot-sgpio
+
+  "^mdio@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/net/mscc,miim.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,ocelot-miim
+
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
+  - spi-max-frequency
+
+additionalProperties: false
+
+examples:
+  - |
+    ocelot_clock: ocelot-clock {
+          compatible = "fixed-clock";
+          #clock-cells = <0>;
+          clock-frequency = <125000000>;
+      };
+
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        soc@0 {
+            compatible = "mscc,vsc7512";
+            spi-max-frequency = <2500000>;
+            reg = <0>;
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            mdio@7107009c {
+                compatible = "mscc,ocelot-miim";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x7107009c 0x24>;
+
+                sw_phy0: ethernet-phy@0 {
+                    reg = <0x0>;
+                };
+            };
+
+            mdio@710700c0 {
+                compatible = "mscc,ocelot-miim";
+                pinctrl-names = "default";
+                pinctrl-0 = <&miim1_pins>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x710700c0 0x24>;
+
+                sw_phy4: ethernet-phy@4 {
+                    reg = <0x4>;
+                };
+            };
+
+            gpio: pinctrl@71070034 {
+                compatible = "mscc,ocelot-pinctrl";
+                gpio-controller;
+                #gpio-cells = <2>;
+                gpio-ranges = <&gpio 0 0 22>;
+                reg = <0x71070034 0x6c>;
+
+                sgpio_pins: sgpio-pins {
+                    pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
+                    function = "sg0";
+                };
+
+                miim1_pins: miim1-pins {
+                    pins = "GPIO_14", "GPIO_15";
+                    function = "miim";
+                };
+            };
+
+            gpio@710700f8 {
+                compatible = "mscc,ocelot-sgpio";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                bus-frequency = <12500000>;
+                clocks = <&ocelot_clock>;
+                microchip,sgpio-port-ranges = <0 15>;
+                pinctrl-names = "default";
+                pinctrl-0 = <&sgpio_pins>;
+                reg = <0x710700f8 0x100>;
+
+                sgpio_in0: gpio@0 {
+                    compatible = "microchip,sparx5-sgpio-bank";
+                    reg = <0>;
+                    gpio-controller;
+                    #gpio-cells = <3>;
+                    ngpios = <64>;
+                };
+
+                sgpio_out1: gpio@1 {
+                    compatible = "microchip,sparx5-sgpio-bank";
+                    reg = <1>;
+                    gpio-controller;
+                    #gpio-cells = <3>;
+                    ngpios = <64>;
+                };
+            };
+        };
+    };
+
+...
+
diff --git a/MAINTAINERS b/MAINTAINERS
index f781caceeb38..5e798c42fa08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14470,6 +14470,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
 OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
+F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
-- 
2.25.1

