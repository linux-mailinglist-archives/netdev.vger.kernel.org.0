Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA767EE55
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjA0Tiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA0Ti0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:38:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1178E83043;
        Fri, 27 Jan 2023 11:37:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SChus37wt3S3OUhrVAsYkkntgiyPxoGqoZCAcxQv6tsIfXLH/BN+BNq6wV+yVy1oMuz6PpNQSaS1uOfPPQ7+JcWKeOF8JUEDVbl9djcSSHRUX/UbdLzH0skI1qIi/zGz79wX0Ap84V3qCCUtMFIWBJ6xo5dJejxEeuWcAan6qTwHSy0aMErujo+e9ZxENS5NHmToenfWRFXmXmYN+tVqPrOTH9Eak19e3tA/RRPTU5BbYeuMEDRy3HiVvMNhoKEFMzXuwtxTeOTnsqpcZ7ZEGUq5KJLB1Br0zSWTRZrzGP0E6IyOi6ynYuGoGJtlyZZz64ESZqGojDExildHRjip0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSo1894uCctiM+9QIhhTWhfsqGu/wViz5Ii3s7C61XI=;
 b=XAPWpUQnPSBtZmePy7TBYA/Fnj73U0c3CV7l9+WCWq09FIJbKCkR+yRZ7ywDBYkTkVuTnIAl7TiM4ciyqoVjoJmccS9Hit3DfkbXQWYxxmMC7b8KYlPUf0N5GE5dTn5j+UaERK1pQo9NDlSMMixK7hZxVof0vmb8a1HbadtWFUhwOC0Ry2C51qwfHz5juhLv5mg29Qpz2vJ2gSHQQLzjavFPDlRhhEtC12kOMUOnfgRgtJYJta9HwXjGVt26NCu3aPcDtG1fRBHGLMSRW5qR/mnubpEQfFzWgthRLU36RN8dcTRuOVEL7ZzlY/9Vj262jrUJhHQGfZN4gZKEcuX7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSo1894uCctiM+9QIhhTWhfsqGu/wViz5Ii3s7C61XI=;
 b=wQaO4nSj29ogbG1mFHSdbFfbuT2YKjNmH2te3McvdGjF5ycY/sG8JnIQchwFtuCUB0Bb2H5eRpjVXYy9e1jjRAy2EzlvxETtjt+9dUsfofzKTQUGOr16boGZ+/Hzr/GfaHENg9Sye+1wfxv/NY1MeomgTJm9JgYdvgmda0mxbuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:28 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:28 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 10/13] dt-bindings: net: mscc,vsc7514-switch: add dsa binding for the vsc7512
Date:   Fri, 27 Jan 2023 11:35:56 -0800
Message-Id: <20230127193559.1001051-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: f9bb4e86-2fc0-4630-32d4-08db009dc8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNXWJxebKRUeRb2+kuKDTOheUZ2jeUzfHN7fFsYRbKQyjr8oMlNvjJ4sZN4cQ3CNpxZS/ELRECsnWnfXr94Fu+yDPg47JqGNXcHU+LrJrykYA0/ZKCWj4+GMNDk/n2h07E+OjIS2p5+YHHrAMWp+SoEcfoO3siWfDban6hsr0L6dYv6ympUdu1t62wp4R17Jnbj+XwsE8I74/S5VPS5Yp8expEStFo0l+tcZMj15TaARi4nfd5LMXmEotaYLWi89RodOtRitintYTE0gcg4kXRfCOvX4B+FqSdgF6I/3cTWuv2NX7H03CZOkGQitjay+8L0trwIgObVf9fMSumrLFWXNoso3Vo8UZOH9WFb+/kmll7LGgveqsO71SnpV/r10E1sT53bRkunGPXsAX7dAoZRbZqUjG/7lH5nnK42vCIg2ZrofzNpsMILuwHO9PNubvNvLHJWGmF4h/sVJwQ5pGcHu29VTyZ+L1Va4PABrNOJI7ZUu4qpUZydOtLyAzPNAYxD/Q7QJZVPCE+cn4/KcBfq62FdJOvU5KPydCFf0v02aMnF7wPY3QbjstnbKZHL4mJ3GWUQMEk4UCdyv5A8dl88RKUpmq1dlg6NUQrnAaMi4W4lhA6lZ6YckGGhetKbU21yceor5FjwzAb2umYJdBYR34vuk6/IexnIDtIH7wpo8JKAc9poZQpUFHlLMZnyQ1kMFXPzpLTA6pgvbjehmTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5fdmlUz3MnLqyvQ9gbY+GAFWzIOxYLIAtXvc7SeuQV18vXzuhhscpoOZdYya?=
 =?us-ascii?Q?++6cmvIOLLiWqtgf25W4xO27AtvIGrIMWFAYC6mqXAYGQ4iX7dpMpnJXq2eH?=
 =?us-ascii?Q?hu5/a+NTe4NwDukPp/8HK0yoTC3+kOF6DYftKz021WOIsY4L+ckDgzvsk9VY?=
 =?us-ascii?Q?UoSdl2+LKTybHGrHtsWZnbWl0F/bncBIzTvFtalg8kxTIv3ocwXP4LbfaQvA?=
 =?us-ascii?Q?FNBgpzVHJfr4TkMeMuRWs0HFMMFdBHfiNhKnhM2Fil7PJnBsfgXpWxqqXxod?=
 =?us-ascii?Q?H+FqAoZsjq9kc5yRiHAjtlYXuSBlDqAQqUwaDEFZl79NjUC//baK2ZxwSXZO?=
 =?us-ascii?Q?7hj/ye54IPDoZpGw65Nv/T2PVD2MphAinFk/DrmTH7gpvbnMErHMzwaazC/Y?=
 =?us-ascii?Q?bISkqYGZTs6G2Dkp/yzDyHTuFJZlhSmftVUPrqaFFhJpf40C+4JzcSfWieK+?=
 =?us-ascii?Q?rO0lKo7XOAE5IVDH2mu24b4q4guSnWSSyTpSTAw3syyYwIJHbckxiPsNQOei?=
 =?us-ascii?Q?5NjtOcp1MSIyXtYBKEAJ0+fZzTdQfZVC6215KWcmx6KiBw+z9QaIw6Ri83/K?=
 =?us-ascii?Q?L89n20wZ9qT5DGf1gKJyfpdvTTPb6mAiX576ZRa4zViE86PJ8Nw1SZUE2ORc?=
 =?us-ascii?Q?/nfNeB6holGXBNsovz8Zs8pbOBvienWEeRMYUr7IpvDnRtx3mN1NXuMmRVml?=
 =?us-ascii?Q?C27E8VjDqE+2kb3YtC6qP7rgb2RbaQCAobLV6zT17uarV0CTrFa3hwNrErrS?=
 =?us-ascii?Q?7hT2G9gFN7u0h+3cVfqaWp90Lk22aabPumm1hTurtNMOGdDOtYnL10SHLw1d?=
 =?us-ascii?Q?SVWY993EI9EHxli2DpleNm1UL7eiy7E6NH14dZeV6buf7d37+d3oPaOxjj22?=
 =?us-ascii?Q?R3clqoPFFYgc5vmT4n6E1Dq4gGjjusgB4Hpy1ZuT+9XmdWPfyI1YmC5XGf2A?=
 =?us-ascii?Q?86VgSvPkkhmgI3MkFABmd/mO4rODQ7RjFm+kq89fKzhge9hWrIHkHHzxblAX?=
 =?us-ascii?Q?Fd/aH8j6jhA8MyhsdMM2IrrQkpetxL0g60Se/Ov4x5OJNYa/QQWwI+fznAZ9?=
 =?us-ascii?Q?2wdUVOMf2FPHi85wq7kPHpV5OoB7Ju35gawEAyHcWnetMjcpltMDnLMxQz2k?=
 =?us-ascii?Q?2bTPEsGHT2LIlmWx88INNIED3eiwWbBhLNDhfp6fgDNJm9yl5wL0rLCsTdqY?=
 =?us-ascii?Q?zEFABR9oaTlPV0T0L0bNtrQBa7L8Aa7+y6AAS0cq1pKq+41R3nJb1n4u9Sz3?=
 =?us-ascii?Q?REQiCPEp2I5cHBiTYcFOVvPwc4GHBVNJmoX++r4Weni1zzcRII3/38ZKIsOB?=
 =?us-ascii?Q?hc3S9xDzYOfCxBaA7HLPBSV6150IpGo2ziH0+0gGxKHbCcWxjQ/vqUKbtbBD?=
 =?us-ascii?Q?AIEOc0MxEb6UfNRzoaF4sSc7m33w6qSOeXADergEaeiSxyK4DiXKX75e68yL?=
 =?us-ascii?Q?9Edt7BHmmVQpBMVrEj91hRlqX8b1FGIXPtSUQJsEnQ5PcF5M3MCO+a/wbcVd?=
 =?us-ascii?Q?Ok/SoBGbVs4BvBVzvVTP4hSSN7Cdlhaub3gkgP6pRBBVgcfz4uJE+fAoZvqJ?=
 =?us-ascii?Q?jVtLH11EM2kfZBhO5SZ8Nu8qRw3q9HIH+FOL4MeKinRuO6ybLsIU8lbnUq3y?=
 =?us-ascii?Q?iJi1OkpL+O9rukw9GE36L5M=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9bb4e86-2fc0-4630-32d4-08db009dc8ce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:28.5941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5k/GgYaa4QH9kQAho1+YK1aKV5eV2ejYkYE4ciGpLRqcChW8ngLyCVcmBSgpxyscCCAnvdPPcaV1GNeAZT7hd/BfQtkjJXlH2EIxzYUh4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7511, VSC7512, VSC7513 and VSC7514 all have the ability to be
controlled either internally by a memory-mapped CPU, or externally via
interfaces like SPI and PCIe. The internal CPU of the VSC7511 and 7512
don't have the resources to run Linux, so must be controlled via these
external interfaces in a DSA configuration.

Add mscc,vsc7512-switch compatible string to indicate that the chips are
being controlled externally in a DSA configuration.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5
    * New patch after a documentation overhaul series

---
 .../bindings/net/mscc,vsc7514-switch.yaml     | 113 ++++++++++++++----
 1 file changed, 90 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index 5ffe831e59e4..8ee2c7d7ff42 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -18,13 +18,52 @@ description: |
   packets using CPU. Additionally, PTP is supported as well as FDMA for faster
   packet extraction/injection.
 
-$ref: ethernet-switch.yaml#
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: mscc,vsc7514-switch
+    then:
+      $ref: ethernet-switch.yaml#
+      required:
+        - interrupts
+        - interrupt-names
+      properties:
+        reg:
+          minItems: 21
+        reg-names:
+          minItems: 21
+        ethernet-ports:
+          patternProperties:
+            "^port@[0-9a-f]+$":
+              $ref: ethernet-switch-port.yaml#
+              unevaluatedProperties: false
+
+  - if:
+      properties:
+        compatible:
+          const: mscc,vsc7512-switch
+    then:
+      $ref: /schemas/net/dsa/dsa.yaml#
+      properties:
+        reg:
+          maxItems: 20
+        reg-names:
+          maxItems: 20
+        ethernet-ports:
+          patternProperties:
+            "^port@[0-9a-f]+$":
+              $ref: /schemas/net/dsa/dsa-port.yaml#
+              unevaluatedProperties: false
 
 properties:
   compatible:
-    const: mscc,vsc7514-switch
+    enum:
+      - mscc,vsc7512-switch
+      - mscc,vsc7514-switch
 
   reg:
+    minItems: 20
     items:
       - description: system target
       - description: rewriter target
@@ -49,6 +88,7 @@ properties:
       - description: fdma target
 
   reg-names:
+    minItems: 20
     items:
       - const: sys
       - const: rew
@@ -86,35 +126,16 @@ properties:
       - const: xtr
       - const: fdma
 
-  ethernet-ports:
-    type: object
-
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
-    additionalProperties: false
-
-    patternProperties:
-      "^port@[0-9a-f]+$":
-
-        $ref: ethernet-switch-port.yaml#
-
-        unevaluatedProperties: false
-
 required:
   - compatible
   - reg
   - reg-names
-  - interrupts
-  - interrupt-names
   - ethernet-ports
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
+  # VSC7514 (Switchdev)
   - |
     switch@1010000 {
       compatible = "mscc,vsc7514-switch";
@@ -162,5 +183,51 @@ examples:
         };
       };
     };
+  # VSC7512 (DSA)
+  - |
+    ethernet-switch@1{
+      compatible = "mscc,vsc7512-switch";
+      reg = <0x71010000 0x10000>,
+            <0x71030000 0x10000>,
+            <0x71080000 0x100>,
+            <0x710e0000 0x10000>,
+            <0x711e0000 0x100>,
+            <0x711f0000 0x100>,
+            <0x71200000 0x100>,
+            <0x71210000 0x100>,
+            <0x71220000 0x100>,
+            <0x71230000 0x100>,
+            <0x71240000 0x100>,
+            <0x71250000 0x100>,
+            <0x71260000 0x100>,
+            <0x71270000 0x100>,
+            <0x71280000 0x100>,
+            <0x71800000 0x80000>,
+            <0x71880000 0x10000>,
+            <0x71040000 0x10000>,
+            <0x71050000 0x10000>,
+            <0x71060000 0x10000>;
+            reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
+            "port2", "port3", "port4", "port5", "port6",
+            "port7", "port8", "port9", "port10", "qsys",
+            "ana", "s0", "s1", "s2";
+
+            ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+           port@0 {
+            reg = <0>;
+            ethernet = <&mac_sw>;
+            phy-handle = <&phy0>;
+            phy-mode = "internal";
+          };
+          port@1 {
+            reg = <1>;
+            phy-handle = <&phy1>;
+            phy-mode = "internal";
+          };
+        };
+      };
 
 ...
-- 
2.25.1

