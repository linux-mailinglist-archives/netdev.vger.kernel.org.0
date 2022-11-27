Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B8639DB0
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiK0WsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiK0Wr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:47:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2096.outbound.protection.outlook.com [40.107.94.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1751DEB7;
        Sun, 27 Nov 2022 14:47:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUc8p8GwBpElLlP680hME0j8IFpwN+wlXXBEXWl7BO6tUQQGJ8SOf8kNzVi6zWkkGWR/ZBQFFPLfVH4FSQJ+2/w2N33HAgLzR/mUi1LBPaZLsVPrYnX9QuMAuFIX678VxWEDa9sQtEnbwV8s6Slt18yN3HItuRuE/bOXl7itfFBcQc+ZDhP7xvnY06StyOOidB6FRhfXuq/Ih20FqHeFJ2QeFGS+GhonyRKdQI79FKEZERfL93+qEOgyhmElNcCEz+bH4HjgXKjItbHGHU7HygUuCd0+Eq2sCWjN/DovwjWd3+ndEN18EaWOZ2JtoUkUKpARrMo6zvT6sgMuGN0CBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQOwm8LtB2CCN3S0j4Cg04vj8QERsGwW5b9kr5bjG5g=;
 b=QOAEyYch/oNRJEZ8DN0y5w5jQfQS4EFmK3DuPyDbY4pdQ2JHgBdaRjqepyb643VC4lN04E4zKvynsgPLm1ZV5m0rBKEuxQyWgWWqeZHHMaHgocWLrzRaKl+3NFyqHmKCmqFRTDYzY4GCDry7+VCK22WBH2lmkINbapwV6EUUyswzvfgdR9oeE0kg7Mgygs5SUCadkjU7AUy/tUY3O6wEBlYaUomiPRvtawrRBPL3qxcFKPYJwO59SVrDmejuZpmJVXjB9JAGreeipI9n6EQaYFDCyrWnReZWcantI5R5nt85pWrunaMLsqVWdDwsZ+9SWUJEliHD+A73SrnDYsJwLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQOwm8LtB2CCN3S0j4Cg04vj8QERsGwW5b9kr5bjG5g=;
 b=U3J809MgDSSXcoF5Ywzq3yy9QznuElp8uzhvDw5rclY9m8aPA+2DG1Jy4UpR204c6maW1qLQtOrSQTVys44L+fz4EysetNLYcDEC9L5guuSlKklLW5LcooZX6NG7YGDrfHl38vJsZVN5riwimP9vqujbb3650558hGghgLOUTdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:52 +0000
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
Subject: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base definitions for standard dsa switches
Date:   Sun, 27 Nov 2022 14:47:27 -0800
Message-Id: <20221127224734.885526-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: ded39562-5e16-49fa-3665-08dad0c96aa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3AaR80JcraJQlQKi/33rb3osalJrFG4ZrAeIo6SJR0xokP4um+0XhRswQgpigARDINOVQzXC7opRPNMsfPuO/m4vX3fcgrbnl5sx8BJkQAWbgF71sNf2kPASoJk/aWIQHN0oFdeog2HCOTDHQhfHlgpMgoh3OaRrPV7n4dvNFB12GWx3FdfTlmZOnYmOYHPHwYPwjqSVSYmjWEwJd6Lx5fLg1rPok+OWcB/MgaFawu98JxSZPRJFQYPXJG41AyyDvndQdEcqgKTIQMlXy0Dpv9bks9SJ7rKWVZ+pKfTm8iiQwmS0j0/A6llTwwfDHRMDoSBFYw5Jxxpe5apNNHW202RaMLfkXA8wQso7xMxouAp5UVVTkxlSLa4BMI+w1L3lnbejZ79CJ+k03eb7ydOiskTJfJ2f6vE5gnihTtI9zoCw9aWDzijc5MRbrOzEz1/m/Ve1NHIV8HXIi0MGoYSI46f6LKwPaHyO/o2bMO8fsH6As9i1PufAa2msuYtpH1KbRtPYoTUn5gjDmJcwZq+Edahs6PXvq06ufwzDApig5Pirdi/cJYKM4At0aSH5I5Cs8OioLPPkSFPkide/NLbaZekhgWNPCIgdOH4CZRmcW87OW7iG+ud6ik/7bIb7UEXVUaOSlD3iPJu2z4x+edwFE3qXCmyCCvmsFCSP6OM5X/TLQ6ERiY2JrIWfQEYXePyAMYDgsNWWnm0RXglu1iAhwaScUbjSrv+NPJYFKVkpdmA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(966005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?daTP6JgKsccq4dkFCOvORl+NgqRqnl+uKyJtcWwIgzlQGhVdS59K6lXqsuw1?=
 =?us-ascii?Q?hdC8HmgJXJOdLFj30C3zPx+Znx8+cwtdBsF2mD2tAF1yGuGz40caWpDsYwpJ?=
 =?us-ascii?Q?y7S1k811tehA70sHiHEWZ0WEB/ZL2nAt/SkOR+MGKPIHzutKzDhA6WtVsxDm?=
 =?us-ascii?Q?PbVxtD1tWbHDOpLVpti+gZ2Ovrx17zp3IlHjgiuL++MNLcio49viEx7w5+Ln?=
 =?us-ascii?Q?Aiko+KTYYJF2r7fGFvmIH2c+APlhrG6EAFSYD3K7UbJ+HPwFctvs/dRQybLR?=
 =?us-ascii?Q?Sq3U3x3NsDtdR8TxbZiat0jiTtGQGspON/s7O3Gi72FsIg6F/oL4XTmwiRYe?=
 =?us-ascii?Q?XVF1oFyk4eVqOowDtm0imcPXRk3aGVrni7TedFActIdXRmywkJSDEdhHtwv0?=
 =?us-ascii?Q?oNb0WFc3U+Y4ZlY0tZ3fSPvEyvEw8J7Crm3/TK5/+BDkf7KMhUeI8caweO5C?=
 =?us-ascii?Q?6SkdaeJWheXQg0uWp515EIfeuDULWXCNnaCnYHvLuXPLWeQPTLLH669n9Y54?=
 =?us-ascii?Q?9oyXmWj7eABWtB/auGG4YSiJDEAe+RteBA13guZfZvc+I+0BSvjlSsfrI9dB?=
 =?us-ascii?Q?dWYVGwT/t392LDxXYy+5WzEAxH/AwyDKBApzE2614bjkVFty4qK2/MxW7CIF?=
 =?us-ascii?Q?C3dWS+Q0gkH1zLAT19Tnyp+LomavqlBJfp7K+XRQ/uGUuACwmn75IbPaPOki?=
 =?us-ascii?Q?jaaMdL97yqzVKJmsjMp0oZdMzK6ZO8Kqxxdy6gKW7mW8FAnjUC0DL39Utx/L?=
 =?us-ascii?Q?FnMs4PVzFI8io7grUFoaAKNwyofnhMoXF+BU6vsvFPtz4X9ad0jcqy8+JUKF?=
 =?us-ascii?Q?6nNg4rQX4Qay+TWy+YtkbDsH7QOq2bPRq6/OBq1boaHfrsscg8FpnUxVjwIV?=
 =?us-ascii?Q?Auu+jdag0Gm1uyEQTmRunigPTkyCbRbeIBGsGOw4zCA0YCxoYPQwlzgtmUkZ?=
 =?us-ascii?Q?HPwQRLQCg9YzRVTLFNRqMKqEqimBV/PYgOW+RuZbg/RXlyOFOXnGZlSC5Il5?=
 =?us-ascii?Q?A/MKuTwMJaJUhnzW9b8MazsSeNm/7HtpJ11HWmZmRB36pQo3SmrmbTEj/pG9?=
 =?us-ascii?Q?Bk27Gx9iukHZY6oIHZjbhQPKv8HI+izNWR7JJj5hEouii0uVepQxsZwZ33Qf?=
 =?us-ascii?Q?TvlzCTScmfOEXv9+Qz8a8MW6akPtxjNqCbd9z1ljb6F8rYbZM7cIg7QAeqo6?=
 =?us-ascii?Q?3eva1eh2cdiDB1enxqh6U3AmYB/jFE3Fl/+uWYFQJ9ORQ/guxAkEgGK4SRPf?=
 =?us-ascii?Q?XsCy5EbgJ8ULHGzY58lH2QmRKNB+Qi4IWZzLhDgphXU49snQTXARbe21xvrN?=
 =?us-ascii?Q?d8LqUgiCHQk2WDj2D9o5ebXUcNV6fied/x1c5xtx3PwkBcwPQg7rBWEiLqG6?=
 =?us-ascii?Q?9AoAOj/UOYqPVF2X+EfbyAaEbSlHP3c4gfh+i7AwlttGblPNBh1c9fvdGKlr?=
 =?us-ascii?Q?XpSTVRW1K5Jey5uAJyxg/zD2gGU5ZMu/5Pvtyb2g+msPEXSQqmf/b48echM1?=
 =?us-ascii?Q?U5LTAPuYQIDBpWy/9C5gKdWqWDg4JnKMtd5ju/D+VTwNuKxKubgEhoIpr03+?=
 =?us-ascii?Q?Q++qzvC9UMiGfwzuIWPDyAccgSn+6zvOmJxeUorTiRwJ7yscBrl33C0R1H9X?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded39562-5e16-49fa-3665-08dad0c96aa4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:52.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PXAEQS7cWGvSdXWuY0AvQTA9cCLtl4/ye2oUZi06SKHVFnX4//nHZsn13dV4O5Pktu99YlDvtDi9GQlb+2AjJfrMoLIPJ6R6YBjk1HVId0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA switches can fall into one of two categories: switches where all ports
follow standard '(ethernet-)?port' properties, and switches that have
additional properties for the ports.

The scenario where DSA ports are all standardized can be handled by
swtiches with a reference to 'dsa.yaml#'.

The scenario where DSA ports require additional properties can reference
the new '$dsa.yaml#/$defs/base'. This will allow switches to reference
these base defitions of the DSA switch, but add additional properties under
the port nodes.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
  * New patch

---
 .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
 .../devicetree/bindings/net/dsa/dsa.yaml      | 19 ++++++++++++++++---
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  2 +-
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 11 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index 259a0c6547f3..8d5abb05abdf 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 maintainers:
   - George McCollister <george.mccollister@gmail.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 1219b830b1a4..f323fc01b224 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -66,7 +66,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..bd1f0f7c14a8 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -19,9 +19,6 @@ description:
 select: false
 
 properties:
-  $nodename:
-    pattern: "^(ethernet-)?switch(@.*)?$"
-
   dsa,member:
     minItems: 2
     maxItems: 2
@@ -58,4 +55,20 @@ oneOf:
 
 additionalProperties: true
 
+$defs:
+  base:
+    description: A DSA switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?ports$":
+        type: object
+
+        patternProperties:
+          "^(ethernet-)?ports@[0-9]+$":
+            description: Ethernet switch ports
+            $ref: dsa-port.yaml#
+            unevaluatedProperties: false
+
+
 ...
diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 73b774eadd0b..e27b1619066f 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f2e9ff3f580b..7df4ea1901ce 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -238,7 +238,7 @@ $defs:
                       - sgmii
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - if:
       required:
         - mediatek,mcm
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 4da75b1f9533..bfa2b76659c9 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Woojung Huh <Woojung.Huh@microchip.com>
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
index 630bf0f8294b..f4f9798addae 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -10,7 +10,7 @@ maintainers:
   - UNGLinuxDriver@microchip.com
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..a7041ae4d811 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -78,7 +78,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..13a835af9468 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -13,7 +13,7 @@ description:
   depends on the SPI bus master driver.
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#/$defs/base
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 1a7d45a8ad66..ad1793eba31a 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Realtek switches for unmanaged switches
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 0a0d62b6c00e..9621f751a9dd 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -14,7 +14,7 @@ description: |
   handles 4 ports + 1 CPU management port.
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 properties:
   compatible:
-- 
2.25.1

