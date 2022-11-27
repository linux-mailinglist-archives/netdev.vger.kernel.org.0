Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF6639DC6
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiK0WtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiK0WtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:49:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3CB101F5;
        Sun, 27 Nov 2022 14:48:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3tE2TGNLjJGV5OJBUi4xAuP69c48VXBSAE3qjesRGjXecz6JRhRPw+lFQj4tyW/bC0EJYKx4RmPy/EXCHGCjS7Bt25NaCENB5d0A1LGZkaxs7G+h0VNPZ0p1eEVafA/usrhFgrsH0dR5x3ziL0DYA8TakVnYgqyBmNfvOSHAmloCS+QqX2aJmTJfjdTDooZrGce9KZl5bXA1ofuLRIL5pZIAqIzpqMauJB+rHHwsgc4umnK/T2YU/8Bh52CKmwbcJpP4U1Xmhvj8rVq1oQ4mOnKnxpUSnTWipqeuLYi3dXu8HQBqNXAN+IGVbEsQYbuuPkVnshFJdm0KSaqSklb1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TV4JJ7A6nmPl6nnIoTAsEhnmsaWZnDYlIDIlg2n+GKI=;
 b=aBtmPNJSdG9ML3ou9H9Dahwt8/WFFkryY+RsqBSjaByaf/lh8xXeYOabS7AlDRbWqJ8eKDGG6TL/hihwmk3BV2GX/ol8y/uzC66TyrZVmdo5XCowC1QI2AkZ2372tZnHWGlEpWAAub4KzjRleceyWnpjDue4MLzUdK6dQl2QqnoqgEJsMpk3Ox13j0gERKYFzIFAi6kERvDjMVGMIiPji+hPTWz08TTIdrSWdRj1S/PGSM9mrKj8SltJVx7IgRpNph6NGfa1pqvyyQdiXIW+H33V4oIGtN2QqOxs0ICjajFAJmCeZLtX+xPfIdwve6FBip/3kJLaL61hwkzNw5YAcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TV4JJ7A6nmPl6nnIoTAsEhnmsaWZnDYlIDIlg2n+GKI=;
 b=OSJrDbI/NfkraUQf9bW37MfvPXoiMwhuXjAOT5wv7ba6lgEqZR0TuqIxxsS+RH7L+PhhDJPf+WU0z30AWvfzEZuO2vSlxX13fkcnHZrw8aKk594qV2MRHfmSqjohj4DfxmT3A94YRSx55PMcr3dqFw+LqdmMM1b3KB85clwqri0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:48:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:48:02 +0000
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
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 08/10] dt-bindings: net: add generic ethernet-switch
Date:   Sun, 27 Nov 2022 14:47:32 -0800
Message-Id: <20221127224734.885526-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221127224734.885526-1-colin.foster@in-advantage.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c9402d-8206-4673-4a8b-08dad0c970a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ws/G5JIFrFIjzO6FEqEEJocgFvPn3XFdMFs+Gi7IGiHJ8QIMBHG0urNkwXUgr76ReAfDXICyz1Ot20ZttHeesUXPwsZBntFTEUxK3dsK7M2SwUnl50rP7QBiXUuMiuQjC5KOxuYV6w3oVXk3krEQ5xK0JILT8RGOc1Zv9NksLVWENRkmni9kJImlLXoZwadgojIv9nM0c/2tF7KY7cvuWdWSu8uIuiAYVUbMlS5j1SFFsa77HHetp3gH8QVUHgGLU87epLNMHYEkRJZZR5tTIDVTqwAsu4WwTNA+ogoYoIzk8aCOlPLKL6NbpVMJQmyt9+S45z9ciY7tK4UyY7O3CIdtfVhktgXLhC36V7sIvvGCAl+UtEgY600jEEx6QzoVfmXMWCQM1RZ4NHVU02k3Xs8+yDjcq7CoV5Z7dCNAh94rp2sTboCqH+B2tw5IM/OeKFerRTuRNxxirxtshQ6AQBtcXpiYoCfnvJBzEqscmXBjZ30cXx6BSub1ZSN8nJRvyLGuurixTtgt/mb7S9adh/B0tEER1IuG1DfQb+D+k7A9AQ/Qrl5abEHh7JcHLHmE6BCmsWn9f/WdjVL0cRhNAK+ZtwNNpAqMgZaRiF1botA+LsAQXaDPaTuhYQnqAqh4vfpayrg781xdcCKrCwywjhRD84WnUAwyOsHGQ97SuXBCR4TOgft2Yeva/6XEaBSVvrXYBGGSpodh2j4Jzl4NNUzXnquhEPJXTImfSA266l7wWJJWBtoARnyOOMRjKqwd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(39840400004)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(966005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2HEXGNlTgJd1QuSyqWsJzVoxNsVJjz1cAEMaVhxqwiHN3oZsUC8eIgLyb3/?=
 =?us-ascii?Q?EGNNG0NoaFAWbsWBtkz9ADXIo6T1l1kKjfXc0/hvNJjAVMeD2UPUL4fPSUyb?=
 =?us-ascii?Q?X64aV1JqU3LxgOIkNXUhYtY1ZQdvOXwNEWLd+/AUBDapvrLmV9n4kRiqK6J3?=
 =?us-ascii?Q?l1KAkNuRfty0BFNJr6iuVdo0Kq1R5H2JW1I5hUaWjt+OeSah+RPOZD6/lD1I?=
 =?us-ascii?Q?ETEAnmLjN/ajjYGnntKVWzP1DG/3ViMZMHwggiA65eeAis9Ir7za0Jo6PzYh?=
 =?us-ascii?Q?AsNx+gowv3dcBbPDtmiDXG82OuHp67tfqGXZOPzlxuYxWZs09oEHrrUcOuXi?=
 =?us-ascii?Q?mTbeup2RGYGuyEGLed9SQ7+WxyNoWl7J2DSqhzLeNw2vZacNI2PVFngjUQdy?=
 =?us-ascii?Q?qsCnxbRNnkC7yRDUJ7UK9GZfxzfD47h9zme5kz0uHEmVHrZVkwQeqe8Le2rk?=
 =?us-ascii?Q?mNtIt74HXfs0aMX7xwEBC2kwUNZ/MFyCFlDAve4/lB1zW7GFzNsuTHxH9Ti3?=
 =?us-ascii?Q?6gD7xz3EbXrIga9Pei6pFW20FNV8Tym/2A2fOusOUS4ysKP+tfYpvEWaE/RG?=
 =?us-ascii?Q?daRSK6KU/HHTxaeDco+on9q13KT9ARiITa3R9eArM6rEUdRF2UT8q0sqMp7b?=
 =?us-ascii?Q?FAFqSv3JSxgdxCxn71mZmqBwFz2VUoBcw92gEixdIcaPKjzVHfvqqkZ5WYm+?=
 =?us-ascii?Q?hSGrmLdhtNlPZZanGhWnrnMi9nHXN72VDdHVBucj3X0y9C17HmXvQvLROIeh?=
 =?us-ascii?Q?D0J+1j5xNOEYhk8+7Km5oke4Cf1oel5Ea1MDZILDlH+Y2H3To6i+YXO7dQoR?=
 =?us-ascii?Q?2YZXO4GjiN2JWYWtKY/uHrHXFjXe6FXhMZylDIkMf2uJPupU3m/i5Y0XpF4T?=
 =?us-ascii?Q?pvz9bubDlBYU2VzRuZ3o9BXEatv9xr9vneEiB2RVCuKXVMr6htIc8jXvvtn1?=
 =?us-ascii?Q?kFestVGC6sK6qPsnz7mMl/wtrg96/KXuvGnq1USImIvQ6wxIsOw4St1+mKnc?=
 =?us-ascii?Q?r/E8sA2sq0hSlTdOZDmyY1+H/AMyKYK2j/DkCWixxJFfZzqYckfyBCgVZ+n3?=
 =?us-ascii?Q?FWxEyynMGCzzxWsiajbxTIFsDjaSJv1hK5V+48Hv/MYrUPwAaZM+aR3p+IpV?=
 =?us-ascii?Q?2p2pRxxzUzREElro0VmZvGnGkxtW2TmnZixm2yTtWTJ5YQf8FRC78DluSqMN?=
 =?us-ascii?Q?bGNPfdEEJtTCO6L6Gp86WzXNg5oB6ANnJR19aLhuVE4EAmbjA5eMoSq2aJjM?=
 =?us-ascii?Q?m4r6ztjz1ke6pvVk0JietmEUpOsuvn1rfsVkzM/jsiMzPOLwbNYEfGVovrsS?=
 =?us-ascii?Q?0pZDiu9s5phqfgTvNsQEfdoNE+kw5SrR+Vj6IdeKWs/6wGoGmCIr/khfaUUt?=
 =?us-ascii?Q?olGZFCpQwPq24Jd0GsxjyIcH40PCX0iCUeBLLBWwt4HA77DbAWwRWkhT8RKV?=
 =?us-ascii?Q?e9mAj4InLaKBZADW5FlY5zS1oUxY3YcwIt0VMMX1uBVkfd12HOQx07O3ssaJ?=
 =?us-ascii?Q?vdWTgYzVfuUHoRTtqChSUA1t4YSU/lyNyhLZX27xUdk8Rj4sSQS7sOLKG3i4?=
 =?us-ascii?Q?ACi1eyUSeb1++DsIohbrLmICh3JdjABsmS5cRkHU246TG4fYlLtBl2J62T+I?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c9402d-8206-4673-4a8b-08dad0c970a8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:48:02.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sQs8GTWZsiYoupvdHx8AWMwSXx3cKTtOjrqGkpfEaiKpkLqnN9hfi/ThyYZ+9eMjLyARwXtD+62PWRMSipS55ZVA1KMk0kf3rXrpn70c5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
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
---

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
 .../devicetree/bindings/net/dsa/dsa.yaml      | 28 +-------
 .../bindings/net/ethernet-switch.yaml         | 64 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 67 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 87475c2ab092..616753ba85a2 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -18,6 +18,8 @@ description:
 
 select: false
 
+$ref: "/schemas/net/ethernet-switch.yaml#"
+
 properties:
   dsa,member:
     minItems: 2
@@ -29,32 +31,6 @@ properties:
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
-    additionalProperties: true
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        $ref: dsa-port.yaml#
-
-        unevaluatedProperties: true
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
index 000000000000..d5bf9a2d8083
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -0,0 +1,64 @@
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
+  - Vivien Didelot <vivien.didelot@gmail.com>
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
+    additionalProperties: false
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
index 9b12d715fc66..3077c5af6072 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14332,6 +14332,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
-- 
2.25.1

