Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE865BA4F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbjACFQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbjACFPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:15:05 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44366D100;
        Mon,  2 Jan 2023 21:14:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwU19cjeJYnwzdt1iUHny5QmSVoyZkdsEELoNg4ti6/Sp8TKOL9njBIDN5YiGRPFs8RF5FrLEuYWFjuUHx7YsZc0ZBHmoOIchnU5+noWmn+dP32/eOS/1uRTKCfOV97V9X6YRFz6LRp0Tf4pa/vmiac5bLvDcdW5azq5iN8775/ToYmB6CZ1S1sHKFueAQmwslJsMEorR+qNeEfCPgSdoW7UPVH21Yv6uv0ipx20p7FX0uvVyFyWXLV1i7IOsyLRr+cXFh2AZcOZFDf7iuuQrxyAMG4Hh1HvdEevjuVMVW8ng9iKE2V/aIj/FkwQ8Ra0ugyYp6RYtqIMXtW7x6AUQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msTyZ26OO8FIh9DAT1I1jVSc15sC4sth8EyC5PF7Oms=;
 b=lBIFywG4sjXjPk2xqeslObFiXUsfBM694Nd5Qyty9bq7lLAJ0K5vTzOtmusv5/+LWw8R8Q3WEvOMNvtdoD6J44Jd5J6JERLjSOZ9wPY3ROAB9UpmsiM0zOD8XeVUou8qEeWMUZJBbMmzSEu0gk3EZH+8eQbAwOI0gi6rMYATXq0yiJOJJqQqy6pH0KmvXeYuYZOeVicrG6doFB/8nWw4k6qo8BY37GWknBs2WQnb3MUXgmK7s0OibBhuQMJEmd0hxYq0baQfCgCh9o4RlnWOeTZe1txaclOrkm6R5kfggEHvT8XAuLE5NSrASqUEkyPaCJn8yaH87mLAH9A9wNzDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msTyZ26OO8FIh9DAT1I1jVSc15sC4sth8EyC5PF7Oms=;
 b=dFW4+x9491JCOXjDIW6nr8Fjqo5WSLCndZVXqV66Eedd/LuDUApI7uDB8LvAgvm67Bice0p51suSBXU8RxzPeHL/aI3mr5pl/nI8ely+ZWSWFMl6kiodsk2SEAMZpF5dQqK1IzQGcQu/yVXqQ5YqbS0sWTEVlO5QtDQF+UueGu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6252.namprd10.prod.outlook.com
 (2603:10b6:510:210::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:31 +0000
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
Subject: [PATCH v6 net-next 08/10] dt-bindings: net: add generic ethernet-switch
Date:   Mon,  2 Jan 2023 21:13:59 -0800
Message-Id: <20230103051401.2265961-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 952965f0-5a8e-4021-0f90-08daed496517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBZ7Wi1R/0pd2xtmrILrSeBfTq4L0qZAKyO/FTGgaZiCfFUtQGmGdjduhJ6tCr8gBAt3v5nFIz+8ZSvtSf7WS5+4wqIx/3+dF1NRkl5r2XdxXXlXC7x8lWyWhdOt3uGLsmMhwk/B71U4VbSro2hkWmo8op2G8wxTggHh8YDcs888mA3b8kytpgxs/jStGQ9Pxb7YeS/p+0N8pofSibLQ6kmXlHqrJuNKldv7gAmj72LDuIjzALq0DkCEnKOXEW11F1itmdJHNtgugGlMva6y08EbJHH6tsqXNf+TQdQip37EOpk0f20+J73sjd2KR94HHfvENyJQxKNBqHaaGC+cWbJASzsBSP70f+jlJaW4o1pz+K7nDFDyDDY7Z0KE/9TIx1sydLMDMhhyUTKdnjvWTCb2DHTpkfJy/TIIR9PSTV/HLEvFxVI+dR1iJNHtZdCwidCZrmYhf4Al7FUxaQl+a41L0yWcBbdS1ZHiSPJy6ChM38MIsqWAWWhiqMCaNsWriA/Y0nSlVk4v39WPzo0nuI6OjNOX5vqJGYd9CiQtq4ds4OWQzLyJb8Z/6tffrrW8M5XctvLiV0+aQtwE8H56gqz7OVYBliOZeLGVH6dsU9zYMz+qqzqw87hpYBjcxIQsA8B9EAi3onLWCRTmuOrsdSFO4nzFlTrVchlt5Nu16iEl0skkCeva+RD1nU2pIokvgCwowEC0EpQXN8CY5cnDeo7dL1o4oyIAyTeo54SYhOqy6+OyGqtAeyth9UBVZbgvPWh+vVm0F19xZqhdZ+w9TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39830400003)(451199015)(41300700001)(4326008)(8936002)(66946007)(7406005)(8676002)(7416002)(5660300002)(316002)(54906003)(2906002)(6486002)(52116002)(966005)(6506007)(478600001)(6666004)(66556008)(66476007)(1076003)(2616005)(186003)(86362001)(26005)(6512007)(83380400001)(38350700002)(38100700002)(36756003)(44832011)(22166006)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mgKmZEZcDV5Igf6qdLKJEcTDb52ed9MNLTbz/a0voM2gjW0bPBOe6qjSnNHM?=
 =?us-ascii?Q?Bxc/bmR4xv3w8iIm5mBCoDM6y+QM4fwLkKfXS2N0TFu3wPH1GfU9zrzZjBdA?=
 =?us-ascii?Q?JvOcAEE1+vmtvnRRVkGHEYM3J5vlYRwMWaqAyB5P+vUCtMvzOUXOcnd8+KF7?=
 =?us-ascii?Q?WQ1zbvLajf85yjbE/ec0L8T1u3qYWuFtVvWsf9kHcOrjLg5JJ9hpFRSx2Shc?=
 =?us-ascii?Q?4JIhnfLbUIWgQHvgJm4vLicNIyQHH/yfA4DOaxQJ5REHwWGHllzHTGpBXjwk?=
 =?us-ascii?Q?pjnRBkfn025L99MxrCa4oTjDWTzapK8PGmevoZSqPRsQi7V4FKbcFE5ddgZo?=
 =?us-ascii?Q?pY4o7HCPI1jEeH4RIK1zL+vFRDybGeaPRYcfmWOUc/J96WV3l7mFXUMHygUB?=
 =?us-ascii?Q?C8BmUZZcw2OyvOTesBprl3RoBB8H/6TVUhNQciEx/UeB8/7xsaioyBsDY2Ya?=
 =?us-ascii?Q?gBGWjLooBnRC8eHslTnpy4F3bRfxxvVgXdEJGP6rWNi7C9cRdAXyginjg2q2?=
 =?us-ascii?Q?QzjAjMJmpj75WWywSht+A8ADv3tpGPqV6xNGpkO9EdAMWEFqShEhTjeSQK4W?=
 =?us-ascii?Q?MeYdNPIBvVcOvT1XwHlYaTMFgchKrcS06eMPP65gpUmxtT2cPwXKX0byWk8O?=
 =?us-ascii?Q?zJDseo38/rygHLRWsYoc/GV/jZtIfxFS/WLt8V0EP9EyMBuUy7js/W/rUwJm?=
 =?us-ascii?Q?EEOdxKKcZ+gqA4IBXnhhnIC4NACiKybHxdrNc/JTOo9uhkbxt67OLJ2etOxQ?=
 =?us-ascii?Q?6yMVnTu7872TXOSECTOgbNpFpc5w/zHBk5rJ0SnU0n2D//KmVrzY+i7y3IKs?=
 =?us-ascii?Q?6Fo1u3IUpSD0ban0PAaHsg3IdsXS17U3aq8yjBZBMKyDeBv8+4Gyr6bB5uXi?=
 =?us-ascii?Q?B/DqRxLzztODOVTwF4+uffsSPaCzfsKK/d/OZtHxe1kkguytv9XAEB5FRttJ?=
 =?us-ascii?Q?qhk50J8fuHNfi5AJfvuvFkf4NwlU75V6Y4A4PBseDlxw6/jd8o8dN7eY+IG6?=
 =?us-ascii?Q?Z6DmYfLs9F3MQs0bS8eYgnynbbUKHct1jDqjiLsnSrhoIEg7bX9SplMtILOy?=
 =?us-ascii?Q?l5MLLWstnAY7Emsdi18TK2h5BfmGjB4vTkWziCruN1/6jBytfGo3Tx/JK1NZ?=
 =?us-ascii?Q?qWvwKNyVO73BOXcJaCl+CNzA843h1Dg2+t6yG6jhAF3qiD92MkDO4yXKMza2?=
 =?us-ascii?Q?kjHZsYFz3CCawBtmewBERDqJX87spbUDjP3vAvg+DlMYiPekj5Z+Y9half/D?=
 =?us-ascii?Q?dlTP0NCaDtAeak60MJqGmoBi+vxKOh0KU4hi3cjdNW52jx58UxuFbKIdpKYt?=
 =?us-ascii?Q?27lwvsuDjixzBERaSpbwbBnzdExDK590hxB8ksgeC9/st7Ft0VNyy5bNpI53?=
 =?us-ascii?Q?wl2FbO3taFeDRb0kVBDvbIblGUlMHsAecCA1Eu+/TmNLZ6VBbz5Bh6fNApF5?=
 =?us-ascii?Q?ZpJoj+lpw34RXKl8LUs0zoPBip5Dfi76DbfkUMrm4TsfRNrurV3WvqFPXOti?=
 =?us-ascii?Q?7EHxXJ5oyTKijfyfxUvNvZw4qE1Fci34CabCASmeSeYyUpW3wrE5UXLgQlDV?=
 =?us-ascii?Q?xvpkcHcNPSjS0OqtmGWr5NROIDiD7vzkJNpoa1HDiprhzdU+N919vWe+t0JO?=
 =?us-ascii?Q?TzZegvgmunwTpZVe40V60nE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 952965f0-5a8e-4021-0f90-08daed496517
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:31.3251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lafdqi3e+4wtI7YA2kxHqYVr97saLLv02Esu+i+E+H0DE3YZLwKoJqP2xnrobkxsArD8YjfX8FlCsOdqsVMAWmuDuypFjMqlDMgif2Jl/mU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa.yaml bindings had references that can apply to non-dsa switches. To
prevent duplication of this information, keep the dsa-specific information
inside dsa.yaml and move the remaining generic information to the newly
created ethernet-switch.yaml.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v6
  * No change

v4 -> v5
  * Add Rob Reviewed tag
  * Remove "^(ethernet-)?switch(@.*)?$" from dsa.yaml in this patch, instead
    of dt-bindings: net: dsa: allow additional ethernet-port properties
  * Change Vivien to Vladimir to sync with MAINTAINERS
  * Remove quotes around ref: /schemas/net/ethernet-switch.yaml#

v3 -> v4
  * Update ethernet-ports and ethernet-port nodes to match what the new
    dsa.yaml has. Namely:
      "unevaluatedProperties: false" instead of "additionalProperties: true"
      "additionalProperties: true" instead of "unevaluatedProperties: true"
    for ethernet-ports and ethernet-port, respectively.
  * Add Florian Reviewed tag

v2 -> v3
  * Change ethernet-switch.yaml title from "Ethernet Switch Device
    Tree Bindings" to "Generic Ethernet Switch"
  * Rework ethernet-switch.yaml description
  * Add base defs structure for switches that don't have any additional
    properties.
  * Add "additionalProperties: true" under "^(ethernet-)?ports$" node
  * Correct port reference from /schemas/net/dsa/dsa-port.yaml# to
    ethernet-controller.yaml#

v1 -> v2
  * No net change, but deletions from dsa.yaml included the changes for
    "addionalProperties: true" under ports and "unevaluatedProperties:
    true" under port.

---
 .../devicetree/bindings/net/dsa/dsa.yaml      | 31 +--------
 .../bindings/net/ethernet-switch.yaml         | 66 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 69 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 7487ac0d6bb9..8d971813bab6 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -18,10 +18,9 @@ description:
 
 select: false
 
-properties:
-  $nodename:
-    pattern: "^(ethernet-)?switch(@.*)?$"
+$ref: /schemas/net/ethernet-switch.yaml#
 
+properties:
   dsa,member:
     minItems: 2
     maxItems: 2
@@ -32,32 +31,6 @@ properties:
       (single device hanging off a CPU port) must not specify this property
     $ref: /schemas/types.yaml#/definitions/uint32-array
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
-    unevaluatedProperties: false
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        $ref: dsa-port.yaml#
-
-        additionalProperties: true
-
-oneOf:
-  - required:
-      - ports
-  - required:
-      - ethernet-ports
-
 additionalProperties: true
 
 $defs:
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
new file mode 100644
index 000000000000..2466d05f9a6f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Ethernet Switch
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
+
+description:
+  Ethernet switches are multi-port Ethernet controllers. Each port has
+  its own number and is represented as its own Ethernet controller.
+  The minimum required functionality is to pass packets to software.
+  They may or may not be able to forward packets automonously between
+  ports.
+
+select: false
+
+properties:
+  $nodename:
+    pattern: "^(ethernet-)?switch(@.*)?$"
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+    unevaluatedProperties: false
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        type: object
+        description: Ethernet switch ports
+
+        $ref: ethernet-controller.yaml#
+
+        additionalProperties: true
+
+oneOf:
+  - required:
+      - ports
+  - required:
+      - ethernet-ports
+
+additionalProperties: true
+
+$defs:
+  base:
+    description: An ethernet switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        description: Ethernet switch ports
+        $ref: ethernet-controller.yaml#
+        unevaluatedProperties: false
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index 14f061bc6428..b2c8cb05bdc5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14541,6 +14541,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
-- 
2.25.1

