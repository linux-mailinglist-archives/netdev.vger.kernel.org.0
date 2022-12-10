Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4AB648CEA
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLJDcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiLJDbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:36 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121A48F711;
        Fri,  9 Dec 2022 19:31:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYY05e+LgWPvEqDUa34nzTalOkl7BxiLns8F6jhRJZdKxSV0JhtlQ+VoZge8aecOQo9PWA7gR+/6eMlFCKLqAZ1MteqwwAN9fSUaOhXc66Td1Ee+vts+TpmTVl/2v1cwFdr8s+8Z3Jojl8wlN5ikJe2aU7cBmwkk5q1L581kPMailMsU6CsbcSsrOy7wMZqtfed5XcV5Bc4tb85HR5d0iUGd3tp24JGfw7cQ0b3XYPrWPlsqaE+z/DRTIWbtVMDJA8hhtG6MveahjTxsdq4iiPyOkv34d0GqfWesHOPMbaa1tqgH5IpQx8+Lg85vEjyptzpLEzsNKtN83DMIZ03tbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAirJbDJr7zZ8tDqd4iQ9SQesEA26DHxqg9/Gsefstk=;
 b=jpIm6/bEarG4BjY5AfJ+snCfu7Pi6PN8IdeO/+j7S/1bMPPWtSsHunJ40jYwPp7OFxBkJpVyso92jHIvnOCYXm7Q6aAKUeS3wr10MnhlERYLckEnJNjmzFgHKMj2fdjMxPrwNAeY7lfQhrSRcvkBqnool7jyK73n0+Ctqm5PZgcEoEHOlo4QBB+H83X8uRyGJ94dDPA2DJkr/G1NwcncKf+mwcGKUQqJA+SVTmw2bCGTcq2bB8bCxLZnJ6xTGgLqlCif52LdbTrw3eXkhcjf50V9dFrn4miC/+eH/SM7NRX5ClEJMewjwSoVxs0In3SUb9JhDAQ/4eW/myCRMg86jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAirJbDJr7zZ8tDqd4iQ9SQesEA26DHxqg9/Gsefstk=;
 b=WjmLWGdwc5GMv1pnd9qmeQi6fKXOEwHwL/fpqAi2qUISZrrdlDiRMWMInrwGV1TltGmtUm78KjroAiCQSrC0v6hRpb+o5OYqO4JXQD5tZRzhMmPEP4TEMLRqdG7Hf5RHNNebT7ffoJN0r7STslleTmztFn0RHzkQX6qpbrSEojo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:31:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:31:09 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 net-next 09/10] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Fri,  9 Dec 2022 19:30:32 -0800
Message-Id: <20221210033033.662553-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f1d31f-b964-40fe-f629-08dada5efa5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LGoZKSJaoYMkQkGgVU/IoKSvX+7WEFRLo3XOY0AX7F55xK2OQ0JaivNKo6Vie7n/mWub9a+40TRF/1i3kemq3uDNDmSTJk5zMvMjv+NEqh38j/1YZhIfSd0r5ha1qMHQPb2AueRFahws6aAIEOomHMpuHGbZylpEHtFBpKvsy1ZEhmo/9+b1Gx8+G9ju93xsNsZjR1Fnr7FlWNsPAAdJHVKXlPSRctHw6zLe2qgY2Q+rXTvgr/HvqhTxJixuhiIpGlSdq/0Wuv/4IkIH0uEkUOtcFXdHz3oWHplAcJ2+KX3qMFpvFXKjzDL5UG6wuaLN6X2+MEBKE5K4UI10/q6wf9LZh7I4LFknWve3Z5qZmYE5OBogHdObYycGYADoG3vEyM5qlmRzPFmvF2e5IWaEtD+0on8yQe8vdJbBkr3ZjGgCNG2ZSPZZ4+2oACoXZWlkw/Q5KFHoli7Nki2TvMybOl47BwEEpwAUQG0ZukfJTMlPw87Qmcm2JKYwcGhC4JhW3UeK9Fi6RcZnTKvggH1o9muPqjqD4k0F6f0A0zQV0lcuX91p2yalUVtw9KWMlwM/eODg0eBqEvyB6n6oXawFTbv1zBdwSsUdD+OERbEfF5ErgPKLp+/Uercfp/xq9rhHmRH2M4/Ptwjhk74xvFlOo1ViBnJdnlkZAQ/2mZOOhP8yOxjj+jv4AdV3FHPhyBuPE22phBn2KHtpLVinT/MyrlnmApW05mNhOVdoRvh4zQNHvqW+exnaF7V5t3bbJbIJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199015)(6486002)(966005)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jaf9WXF/vU+ZWoQnidbKnuuYGJsxGZ7auFNWItwTu8ugKA3e2cP3w3wHJke0?=
 =?us-ascii?Q?tYbTRt3GWdu+H4j53NUT/OFvEtNSYKEYvogt/hz0lNsCwDxbDcyGB9CyMd6T?=
 =?us-ascii?Q?eLa7uVX3yttzPmEGnGE8H3SErgsPofXnWgBEUhFVEGRrDNp/loEckOsAdWL9?=
 =?us-ascii?Q?RhhgJ8VT61tBY4h6VzZSHtlSgkmMKDkAMIyuu73zYL6W47bXkeeLFBjFzg08?=
 =?us-ascii?Q?bp5x4wrqVgT07FKZZGRrYaH1CSEI7bMs9pF/LmCnH1C5tzQHcfvSPsNvnf5e?=
 =?us-ascii?Q?TGc8lHSQWflh806ATYUm/25qNz8BvlDJ8myiE6OoGcnm8g0kR9p2kRUZgMJS?=
 =?us-ascii?Q?rCQmu0gbT9llj+ot/8W/r/DtxMqwb/ltLi0Yfzw5XK67u+8Rc1rMLM8IM1cP?=
 =?us-ascii?Q?smc6sOD2qUC7hCQjHrkxOfJTO1PcnNbmMlQrrh74NiEcx5pCFZ1suirA+Nzu?=
 =?us-ascii?Q?+srSNzCayRg2XjfjNmz9M5NFfiPaZubEQoxOqU686xQjZI5/ELmKAHbIGbew?=
 =?us-ascii?Q?Xq8AAhtoEq2yUDTb1fW0RlacXgvbiv8A7DlgnhebDZ9of6P3ECzFl/F8FT0F?=
 =?us-ascii?Q?5w9R8gwnam+393xKUlBGMzs2s6G60tl6NOt7QoLeL1sO9cd8cUQFHyO0FzFU?=
 =?us-ascii?Q?kI5aLeu2Cdww111aK+SVCfdBeeGLVJ1MC7MpsN9r+H2UFk6LAjnGyXM3rr+t?=
 =?us-ascii?Q?QGSe2dFgCauMmJuAW1Bs+7ey33yII8i85jalXIeZyUhcdDkvTuw3K/aboUek?=
 =?us-ascii?Q?jgZkmiqZCkDP9vugUupOtwdMjBPqN0aqAiWg/inorSLBDAWu8I9+eePZ/C1m?=
 =?us-ascii?Q?7oPr3/Yw5kJ9E52LaNpTOPQLsN/Dcn0OjeMJc3bRYksuTcBqsrAVe7xwdnQ8?=
 =?us-ascii?Q?Rm7ou5E+5ATRa4KMogrQk3mMQvmr32qsAifSfbr3qgsCF7c4vjVCIZwhnsgQ?=
 =?us-ascii?Q?rH34ERVLuWCs+9qXjjpC7OHa6TeDEh7YTpz5Mh3LAE7p5DzpADiwNnDLz+lv?=
 =?us-ascii?Q?J4baWwrSAvkrDKxSpXn5gUBIaFGEW575Jm/2NQUz6uf/9wkgWuu/fbPC56MR?=
 =?us-ascii?Q?oqoe1G6HZ18F7X/Y7ScfH0px7vWyWHRvDaZDJPxyeINhkqUajVm1uw2lkfr7?=
 =?us-ascii?Q?lwmMVqfkV1lYhY3AW1GV82eA0DPNLYWYMV8XqNEbr4ZfzNRSzhGV/AAkhKci?=
 =?us-ascii?Q?B3nMSV4SwYnXThU3yIf7+MYCy5CQPBE9FPWjuF7ZYcSyJzKGhQzp8Hn0k4pl?=
 =?us-ascii?Q?064qPNZ6rWkyoV1CBJKS8No5LEWb43CAA4YgkUdz59+UkI8binI1xuZyMoUQ?=
 =?us-ascii?Q?bFAglQZb/M+Hx4Q+T5GbEsFM0cOJlv40EvV/8wZPJy0Wi9wQgRQyj4LMYfaK?=
 =?us-ascii?Q?sZyURSN6NKXACnJPUeZ3jCz7KlwDC9nR4dXXDbS352qYIe02+M8xdyhyJ7v7?=
 =?us-ascii?Q?c3OsjaMO9ScOgDeS5vEFGjqVSxWAJ/q3HQMOWvg92UlhUXZy/aOAXFbQg0mY?=
 =?us-ascii?Q?nSQw85co3lQ6kikURGNf0GuQ0stTzlka0fyLLNaG+LcVHm4BBB9QGlpjaJIc?=
 =?us-ascii?Q?GhOTMl0p5I6zBe6IYSxIy6MDU8NV26lUaBGV/ETsvktZttpsGdmfNDtzFza4?=
 =?us-ascii?Q?QKJeqbd/gKoQCQUSoA5SRBA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f1d31f-b964-40fe-f629-08dada5efa5f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:31:09.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sn5r5POVYsYb8Gg5TtpNLFSI1tbNPs1ro7kxiktYzgdJrJ5yHdn/wmCDSZTaCaUyqXXER1Sn2wtFxL3mvcCl8WAq/CFlv1Vv7sWAExGSnFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa-port.yaml binding had several references that can be common to all
ethernet ports, not just dsa-specific ones. Break out the generic bindings
to ethernet-switch-port.yaml they can be used by non-dsa drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v4 -> v5
  * Add Rob Reviewed tag
  * Change Vivien to Vladimir to match MAINTAINERS
  * Capitalize all words in title line (Generic DSA Switch Port)
  * Add better description of an Ethernet switch port

v3 -> v4
  * Add Florian Reviewed tag

v2 -> v3
  * Change dsa-port title from "DSA Switch port Device Tree Bindings"
    to "Generic DSA Switch port"
  * Add reference to ethernet-switch-port.yaml# in dsa-port.yaml
  * Change title of ethernet-switch-port.yaml from "Ethernet Switch
    port Device Tree Bindings" to "Generic Ethernet Switch port"
  * Remove most properties from ethernet-switch-port.yaml. They're
    all in ethernet-controller, and are all allowed.
  * ethernet-switch.yaml now only references ethernet-switch-port.yaml#
    under the port node.

v1 -> v2
  * Remove accidental addition of
    "$ref: /schemas/net/ethernet-switch-port.yaml" which should be kept
    out of dsa-port so that it doesn't get referenced multiple times
    through both ethernet-switch and dsa-port.

---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 27 +++----------------
 .../bindings/net/ethernet-switch-port.yaml    | 25 +++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         |  6 +----
 MAINTAINERS                                   |  1 +
 4 files changed, 31 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 2b8317911bef..8a29b4c140fb 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Switch port Device Tree Bindings
+title: Generic DSA Switch Port
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
@@ -12,10 +12,10 @@ maintainers:
   - Vladimir Oltean <olteanv@gmail.com>
 
 description:
-  Ethernet switch port Description
+  An Ethernet switch port is a component of a switch that manages one MAC, and
+  can pass Ethernet frames.
 
-allOf:
-  - $ref: /schemas/net/ethernet-controller.yaml#
+$ref: /schemas/net/ethernet-switch-port.yaml#
 
 properties:
   reg:
@@ -58,25 +58,6 @@ properties:
       - rtl8_4t
       - seville
 
-  phy-handle: true
-
-  phy-mode: true
-
-  fixed-link: true
-
-  mac-address: true
-
-  sfp: true
-
-  managed: true
-
-  rx-internal-delay-ps: true
-
-  tx-internal-delay-ps: true
-
-required:
-  - reg
-
 # CPU and DSA ports must have phylink-compatible link descriptions
 if:
   oneOf:
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
new file mode 100644
index 000000000000..126bc0c12cb8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Ethernet Switch Port
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
+
+description:
+  Ethernet switch port Description
+
+$ref: ethernet-controller.yaml#
+
+properties:
+  reg:
+    description: Port number
+
+additionalProperties: true
+
+...
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
index 2466d05f9a6f..a04f8ef744aa 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -40,10 +40,6 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        $ref: ethernet-controller.yaml#
-
-        additionalProperties: true
-
 oneOf:
   - required:
       - ports
@@ -60,7 +56,7 @@ $defs:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         description: Ethernet switch ports
-        $ref: ethernet-controller.yaml#
+        $ref: ethernet-switch-port.yaml#
         unevaluatedProperties: false
 
 ...
diff --git a/MAINTAINERS b/MAINTAINERS
index d574cae901b3..fe5f52c9864a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14337,6 +14337,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
-- 
2.25.1

