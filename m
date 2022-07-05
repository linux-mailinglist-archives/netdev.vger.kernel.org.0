Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00CE5678B9
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiGEUs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiGEUse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:34 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2094.outbound.protection.outlook.com [40.107.95.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E514D3B;
        Tue,  5 Jul 2022 13:48:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFjgJ1ep3j6sDYAD7kmTJrxDYUkbEBFs7tjXXGUwJLVj4h2Xv++bhrnfOg4VJ03kpszhpW8hvUYTNFu9UBHAj2Yagfu0EcHCh2vnx4SbDZz660JQr4JP9UhJW2qZD9j16sTSO0Io38k9efc1pMmSlapBN2YocqKBlatN/KARzbk4cAmCLXpKbheNjJehBVwB9o99v6c73jg2F20tcVx3Wbyhvqd7z15n4NzC6ILvsgvWBWOosYScHv4JgXtkMuG/3UqOvofWvKU8AF3pF+2469K8SP+yR3Dl9z1SCSkyn4/50+BqBZ9+u6cB1x74ikP3L+JtR/xFHU1s1S7P81KXWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZHL6iJmY3di3RNu580HuHRNkigMf7jQgUt49fR79jI=;
 b=Xz7AlSDEHygt7NE87MK4OnfzMN9f/a0lGUy1EdRjkIdD22Dcwwl/UcVGwMEwDPb/sU4DpUKVHZUktbkDKT3UGEBlpNz3LM58jre+OKohSZt4qD5eHimgLPPQN8CuoQnqrl9SlN0fNXrom3RYYLgMPBSw6BJC6tRYg8dSMttnRsyeAgOTN7p6HzDZq/3iO9peC4bEa8JuuYbqbxdWIk8M2vZkv90EdNqUhZFA+5WqHDOf5s3ByDzSIBYOYH2IohNgu364m6TQLrD7G4zQutWp/4zojs5k7vvGCCTBwjGq/IoRiKfoFeeoQ8jljcbzeaozlWS63dSBEjnZ3nUCC/YVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZHL6iJmY3di3RNu580HuHRNkigMf7jQgUt49fR79jI=;
 b=cu/2xeMJMVsBn00gt13RbMNs0uegclq/jDLrt8prb23NxPR3/lq7GCOBKcJnHyIobrif3FesDsmRRtbZRPKahLsEQ+uL1yh7BwJeF1BzxtrNOSxBca0EXyMyAFABiaOjM7PimJVKJN4zg6QSPs27NxETK7XxtzPSVhZTqakV0MI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1934.namprd10.prod.outlook.com
 (2603:10b6:300:113::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v13 net-next 8/9] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Tue,  5 Jul 2022 13:47:42 -0700
Message-Id: <20220705204743.3224692-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705204743.3224692-1-colin.foster@in-advantage.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:302:1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6e0d10e-4fd5-4670-cd45-08da5ec7aee3
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EvqYlzVikWcQQTVRV8y0E+onXiEhIsY70fpZxkDmPfoQGc/4B/TFIdaDKI4p0rQEMWBjBKvDmCwqry5nmUCUqpcXvaWQJBHdddNdfWr9ewOOLRF3D3wv7x2Bb7wMCg/CdzL5ZqNrIWKA6MMu4eC+ZjPQoEB6VPvbB4VK4dpxWDTPgiYk6PHqzzJicg+ipnCtnyT04V8r/9m0Wk1lac1n4AeVcwn3jf0HLAHFftwDMHffFhiDQpViDjJGddz4XTs6tke2tc8lG4yJQcR+cebwxF/ODXWNoDYGQrn8dxeseMtSiJl80lMlO4Esxk3aIL4SF601TV0Wbvv8PqgLeBF3wb8IkPUIln62Fj2y4s2W/CAMMg2FEtZUJr8rHu0ga9ZiM8NXNk7PqMbzt/3P771lKbOIdv+1LlrWib2OydUcmjtdbN+FOSlv1QV6L9dHZkdJpma6CeLw3uJrYnJrgT4RV+FHMDFh+6yoWz8hjj29XGJafXpFBcuYAocralxw3dfQOOhIvu5XMAzUmNzwFbaaYI3Kccs4aC9GbHV6AJeU7isSQABX4b/81PdrDvPfRCU0lbhV6CuQAWUOEZwRvvsXjccMu7sXN3mEdx3tqIQRPCUkJl/Pehot8y2/WB7WiUj9SZN8ndeoj9z5RLk7+XyRICDcixGcpH2hTplPI9RyvU1MnZsvdHeh123w2je/XisP2Waq2WgCdNrTeNIBM1OQweTvS+nvzzoo68YWHk3JR/ZBGTxTaKL5qq8j10Jef9KTXiGgE3+RhWiYVaJcSTCi06rZv4n03T3fM/XktyrOqgk4ClHLKCvdLRZPdt50btKa0h9dI8Ute5vw2SVpTfJSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(136003)(39830400003)(366004)(7416002)(44832011)(478600001)(966005)(5660300002)(8936002)(6486002)(52116002)(6506007)(86362001)(26005)(6512007)(41300700001)(2906002)(6666004)(38100700002)(38350700002)(2616005)(186003)(1076003)(83380400001)(66946007)(66556008)(66476007)(54906003)(36756003)(316002)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zxDF+myjxd9/SqYc7mV+pP++qXFajIH8R0kHbxlwHwNFo8RfKzzbRIh2cDM9?=
 =?us-ascii?Q?wjVsJixhzjmrCIOFoOp7Q+NYJOLuP15Di62ajtnEse2yHALowbOeTp3AGGF6?=
 =?us-ascii?Q?4zz7CC98bgxK0M39ROR0gAo+pB/VF53LNywMo+t/leVlnarj2aHPpT6LyRMn?=
 =?us-ascii?Q?Wt6hhD3gWqmRqYY8z44AMsweXXoWQWbtuVAGSqeBcmNs8oJ4fGIJTOGXSMZ4?=
 =?us-ascii?Q?4fYPa2GBpzKpFimIr0958lnP/Pa2J1PRF+x+x5xO3d8H0NsMTB31g7MCs2ig?=
 =?us-ascii?Q?x1VC5l7bXwW79GG/cUSZUzJRQh0qqn/dIskzlz1UPK4EVMC2xs4BSrRv/OqE?=
 =?us-ascii?Q?90GPFavb3G7L5wyD9jqs7Fl57t4/RHhda3IQuHMtS4dAdLsCS82jCDNaejzE?=
 =?us-ascii?Q?Adi4VCALNM5z+5n0hHzv/9e5ud/QmRUX4yWd4XmAI+MvPvJ9WLl5UxNO+F5E?=
 =?us-ascii?Q?4XZqPp9WuBW9vc/XP7ICNtTsjGXBmdil/dA7s0lRBFrZq0UrkhzSLhqIXiMA?=
 =?us-ascii?Q?8OR6zLdMYBqrsW8Tj0HuL+D6fTRPFI3ixkT92k8hS6mNBvLd+zfdw9JPsm0d?=
 =?us-ascii?Q?hvdDav6P9Yr0mA2GdLRxsMm4r/uXxFq6EXs5IM3RRgO7j/0JH7uSqmXCCV+n?=
 =?us-ascii?Q?JDMTwOFJt7IXY0IQkJJnbOavUBlG27QR3Vov24KjfJFoqxkRoKEqcbxGNIyY?=
 =?us-ascii?Q?QctDnGjbsx6rW1w3WdFNba4Xj/v+UiOn15QCawScvD/RzKLhIizMv/v92qLs?=
 =?us-ascii?Q?6rfrY8eLZCX9v3DIJP/eIBOF/dskpc6f65tBtKa8hHnR6mYELtd1xP6wD26M?=
 =?us-ascii?Q?mBhFJrnmlBMlFu5ih9aW9y601jQxGV6qxGGewjL6pK796vEJNjx03zByr5uV?=
 =?us-ascii?Q?1UvFLoASJv6rQPLHl88t4VerRY1Qg2PtKxzysf+1S2pMTl786AiEdPUzabo9?=
 =?us-ascii?Q?3hoeWN+DFuYHfpwYYLGCZpi7GYrsIBomYlLecEqXKUNy3ZH0ALQjaUnwbrFR?=
 =?us-ascii?Q?BPzVkyM7h3/p15CL4e2ysiQ8l+1D51xR+LBC0ufMdLjKjKJfKPxw73YWaL56?=
 =?us-ascii?Q?eud2YlMPn0HPwk75ctWq8gnJryQCer5+b8jD0LHnURHtuV/Bt6BtgSZ0obdF?=
 =?us-ascii?Q?wmz5HYtDBJWavcuFoZondCb08lHLZ3RT3QtDd6llBSNgFYh5jN9w/9kyi0g/?=
 =?us-ascii?Q?yI7lwC5+7/e1QxFUaJDo+9qZ4GjA1KGZ+pZxUo3OvsRF7ZfQCnac+jpJsgLW?=
 =?us-ascii?Q?4yo3u04gNsLrAb6dbJMyUfHkvADxRN3ihdJIXprRnNC/xKo2L8lucFqKOd6y?=
 =?us-ascii?Q?i0CqLXPOhW9C4tMUfEVzACBT3dkZrltW/VOhv80dg15eAnaDu/fQ1F1lyZf7?=
 =?us-ascii?Q?tleGUlPbfZuN/lEaaF3SuHVujxjA6XDhn4P8aWn2llTfe42tg+a8Prr1ANL4?=
 =?us-ascii?Q?XO7I0jZ1/bZFqsdN738Mn7c6gAQPOX3JBagaTMroGGgo4QkQusH2IF2UKEOQ?=
 =?us-ascii?Q?UqEi9kNthjjHokAT/npmYaQwrm5ZRjIPU0hXRBvh3B7GyVChLPleRp4iOjmK?=
 =?us-ascii?Q?dFwqLbyWAJZeCjoIr5T8C3Ozw6GEzOFberrXtQZbBRpxYSJjxfIXUm4G8g1v?=
 =?us-ascii?Q?XQ+kKSY7ZkfN6U4/7g4aRj0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e0d10e-4fd5-4670-cd45-08da5ec7aee3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:15.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: navRAkSWcIWgfI3W7sr+EDh+gr1AbDD6VpJbzWxYVGDEb2XEGeiv1kAdJZDDaLaPDCC8cqm/0NQkZmkCP0xN76AxQEfBIAzLsmz+Im27wzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
VSC7512.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Rob Herring <robh@kernel.org>
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

