Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2584667DF1
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbjALSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240629AbjALSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100D84BD7D;
        Thu, 12 Jan 2023 09:57:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjtM0w/4naWGQv2kmsS4GCJYhxujK9cJ7dm2kBqTBPvdKtYLGf0c2lBKT6VG7+w3NeArqweGCDhLoeFoaj621b1QqLfXv77xNm6Ov1i7XZ65r6Syc4plctLBlTm57Q9S7eX0dHBdIm29qAjcVvDHBnXwNOnAerdCZ8SSON/E25SNrYuTyWPbT6VvwiNKtxafs+wPSmTiEPkUgaix9zbJ8c5v1uycP2CxnQWcZondNxBXf+vyCivemLxwptQ8khxUEVPU4jWUvaxF836HD8htF4bcww5CVwbciaxeVD/fCjUIowZfkV9JG+mgYAvz8v+gCJPaCbpZ3eBB8RqvoPtCOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smVkzXd6Pb0z6MNIA+H3Xf290Nr8rrN6ktW0kG03mDQ=;
 b=I8SVkHbyly6oaJDMarBSAcWlg1ZQdu5rOCUW5zekdSzDHeO2XDuu5j2Syh9zpTP9rAMsSIa9nCQbr0xWqFCBQWLhuwUD2JHxQBlrkbSua3nZScEp/NmEDzN4hqj+Ps4UG9W2a6SbF/qp6auqufdZIwjHnoUQBSgy4c5O/nvfWMf1Trj49xHSmxzdMsh9rc9LeTlt46IO7uEndtU6KDZJZy4g3ds8/Y+i8YRR/g59cKRsIL3XvUQR0RPZCPdYhIzpd4reaXGIfY2giMUHp14mZU59n7dtF5NWW+nj3T7U/NclOJjamU8E4gi0DKXSHC0ycSp+e+za9pdxzH9WNYb9+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smVkzXd6Pb0z6MNIA+H3Xf290Nr8rrN6ktW0kG03mDQ=;
 b=ccNITSwdVbQ/osBIiJqnI/zYQ+CchJ7fN2oxOHVeUKh3cs6HpSpTf7kUVfgS33E//sw9m2u+tx8DhJDjij+lxN6WpaeA89aBqb72NAURWAJsqwfwlG5jBDp+LTolIN3XBNoMr0GWPcY6rTbbxv8fKcEp/ZbSZ1DvesOePEyVFfU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4520.namprd10.prod.outlook.com
 (2603:10b6:510:43::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:57:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:57:01 +0000
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
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
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
Subject: [PATCH v7 net-next 09/10] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Thu, 12 Jan 2023 07:56:12 -1000
Message-Id: <20230112175613.18211-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: 40475020-3c2e-4db6-bb3b-08daf4c66823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0KXPkvR5C7m6KGh8pEsdIp2sYFWjyH9SE/CCb/R+rwKpOUzEL9BmnOhrjDG/bpjekqEsNVTOigcAb7n+KQFy35AljDzlfqy1h95XHYFY3ji88DMI8P82vdXZac1WSh0NZLqJ9t0YpP1UqWOFXCr7fKxclZGBSZpb6OB4YzeRkLWt3tQ26EFMsi4ntqexy5FzAwzAYNLaz+32PpcryXbjsg+XyA4Ks4bx2x7+1GJiCWXCgaBngEwhhYLku0ST/qny6TB6zhqZYBSvljNszKdGYhx3WZyZ0HuL0/+6zDBtwK/+wffv1LFCnA1pcBkPihf8ECUqSLOuTKhke1cUwaRHfjV2CV7j7Aqv0OkUo3qB7nAM8oeYAlwRAz+/Ess7z2jhNCIgHfL00CWNn3gBYmwHRSwxnmOJ69yCkBF/dj0w6Ty++jli204/DnchPT6bYP7AMwGOgd/O3FYroRn2qY7Tx28Tn4gFeyw/z/QLy2hHXq4n3CJNZjeBgpvEEOCqWW+7yTujXE6+pm4KReJ+1/u1vvX5XRywcogdqZ4Y9YYshxk0Tm7aq9G0tgDD0ir7aaTc/fvcLZRgpCZaXu40/OAhHjLm7Bqt4M5L7FVJcJMeuiwCGgCsrGNewilPlE3B5RdQ3pxhpUpREGQVupUbqxXM//nkp77PbBGN7knKalTU34dEE2jRal1Fv03Rm2XHGyIO738rDkRijRAugbU5nhhKEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39830400003)(346002)(451199015)(966005)(6486002)(478600001)(52116002)(86362001)(38100700002)(36756003)(186003)(83380400001)(2616005)(1076003)(6512007)(6506007)(6666004)(2906002)(7406005)(66476007)(7416002)(5660300002)(66946007)(8936002)(8676002)(41300700001)(66556008)(4326008)(316002)(54906003)(44832011)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eFtuuFCB5kJJlET23XeHM91yvnPfrUsJ0sfiUy2XNq7e+LXZ18uGqNP0D8PD?=
 =?us-ascii?Q?6h9J+W31gT0xaK47Yk8tO4lzhjn05M8f0RiflouRUnhwocxhPcBC6s2Se3zv?=
 =?us-ascii?Q?JuR/KExNZDOicZ19bVGcvnPtwoJtSkX6Su7EMUDJlO7nU3RqQuy4h3CDLCrk?=
 =?us-ascii?Q?21x+/COQXJDz8xeHkwfAheFe6nLrP2FP66f9TpKp/aYNrMUOPHCdcgx1ZiYl?=
 =?us-ascii?Q?/SbU77xlLqCWBTmCqBGOKo4pt3BjOmnK2JNJ5SCx3KFx1hIJrdnXpdGGGndz?=
 =?us-ascii?Q?Ulyx8H7oa83vCezljIx73nqYvUlqHrLUWdLn0wgq29ncGwjA0czpuNYkNMsA?=
 =?us-ascii?Q?dT7hAVGtGT18wSYXYDGitgE6Er9SID03EYuNVrhjyXRO9BiY6z3e77YQMXvc?=
 =?us-ascii?Q?Cissv0sTOc8JNC5I9L49E0L8UV2hJUGlIiqyp21xDOHyT30G9WOzAGw8MW2c?=
 =?us-ascii?Q?mPLd5MmzrxrIqXAnA/rcDuGDG/NtSCEVU1FT95L7enMbpkLLKCXEzfPW6JtK?=
 =?us-ascii?Q?3qXddL3WNhrZBvP2g/lR4EhgrTGyu1H1oqBC+p6C97n8CHNXJTLghv/toVvr?=
 =?us-ascii?Q?tfe9cNVPcaAUJ2jONowidqVLSDW2YtN3YviAhTIrpXTnqDld4GFQRYJOQAr8?=
 =?us-ascii?Q?fddQl5U2X8WdGf2pRTWz+/7lTXWM5DK7H59zxurJxgkkk3gua/wTiBl12TZq?=
 =?us-ascii?Q?Lit/JX6fbxDUMdkFhe5km42d0BPk15o+M/7m6zBm7Dz5Al5RFv9lVZh4zyP3?=
 =?us-ascii?Q?UBs8jP9jRsCjQxBtPdryCKaOzftPQvREyuIT9mH9ASbLA3asBxiwT1xB2Szs?=
 =?us-ascii?Q?UfYj34+DNB8ZaPwYBPLirnmFkZx6fuUOb0bYnUUi9WaoBHqHPg1SacaY0t9K?=
 =?us-ascii?Q?V7UNs0NCHstQaYB5VGboiPsOZyJLo2AojKFz8TWr4PO7LyZWDtIiNLhr+7xD?=
 =?us-ascii?Q?Rtrj+uIa12vNk951mZoS7hFM6EnodDrAqETCzMNzTL412wUX8MyNExtCyQrd?=
 =?us-ascii?Q?tbDudZNPCLezZLBdzZs8HlCHVI22bLCpEJFYQvxk1COPLI4Et/N14cTMeYvY?=
 =?us-ascii?Q?37mKIktHS/21j7g6Kw5cLE/VUbJXZwXylTC12XHC3eEnkwPqcsvC+TW13JZe?=
 =?us-ascii?Q?Al+zaFuujnw+xkSMMfCCVeFWLAwDC5GlIlW1mseOvD50rE9jdyq7TCwggtdb?=
 =?us-ascii?Q?Ghfz24fOyUWwCzycdt5SRSNk+0VARZ10DSRji3doxOQQgg2lxu2Mkqa/VIgy?=
 =?us-ascii?Q?4Vp+mIlF4O3aWPhDGdQu6FxftB+ROkG/Q3Maa70+m3HDnEfopZhkTfmFpReA?=
 =?us-ascii?Q?La36gzbaX24atm2BA+6vlKX+PG87NmCsJrdBHR8p9IcdM+FP/cYjA36JEhxl?=
 =?us-ascii?Q?Epd5uQpw5cLdwMhpo0CD05KOX+vDS6emZUp+jlEn8N8QvGiXfakxkHCPk3aQ?=
 =?us-ascii?Q?KR+426olk3lb+dQwravubT16Z9jiSBXEo7SOE7biMkZ6qAoVpXRtflTfoUvY?=
 =?us-ascii?Q?je6S8rqrumylDRbKhqxC9lgcdf9JeZ866H4qRihxNKmb8AKTT+hLcphr7b6t?=
 =?us-ascii?Q?qkzNk4cc2xVsnSrnINrE7R7DxxApvdzF7HnaIPyN5c+5ES9LV1FdMQ1vxI0n?=
 =?us-ascii?Q?fPsUZ1eEySvhLs/6y1IjNBTq5mz4ZJ7mlmFPgNpIYseuVyCrLVfTbd+dZQ70?=
 =?us-ascii?Q?mgXBE6sahQ4xMHouGuw2J6sIFvo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40475020-3c2e-4db6-bb3b-08daf4c66823
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:57:01.7345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1jhG9weTynoRqqrwAxUAy5fyCkc6Vw4mw1BrKaUJMtlNvPjG7f+qfOVEvPzHrv61YYQCxijGM06NaOWBrwMwDC/xeb54JIdtI5PwiBL+oA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
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

v6 -> v7
  * Update Ethernet switch port description to have meaning
  * Update DSA switch port description to suggest it has additional
    features

v5 -> v6
  * Minor change to fix conflict with the removal of "Device Tree
    Binding" in the title line

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
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 28 ++++---------------
 .../bindings/net/ethernet-switch-port.yaml    | 26 +++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         |  6 +---
 MAINTAINERS                                   |  1 +
 4 files changed, 33 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index fb338486ce85..480120469953 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Switch port
+title: Generic DSA Switch Port
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
@@ -12,10 +12,11 @@ maintainers:
   - Vladimir Oltean <olteanv@gmail.com>
 
 description:
-  Ethernet switch port Description
+  A DSA switch port is a component of a switch that manages one MAC, and can
+  pass Ethernet frames. It can act as a stanadard Ethernet switch port, or have
+  DSA-specific functionality.
 
-allOf:
-  - $ref: /schemas/net/ethernet-controller.yaml#
+$ref: /schemas/net/ethernet-switch-port.yaml#
 
 properties:
   reg:
@@ -58,25 +59,6 @@ properties:
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
index 000000000000..d5cf7e40e3c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
@@ -0,0 +1,26 @@
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
+  An Ethernet switch port is a component of a switch that manages one MAC, and
+  can pass Ethernet frames.
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
index b582e0835b46..efc9a12b6230 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14542,6 +14542,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
-- 
2.25.1

