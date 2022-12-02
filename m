Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0359F640F6B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiLBUrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiLBUrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:47:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2091.outbound.protection.outlook.com [40.107.243.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BF7F4660;
        Fri,  2 Dec 2022 12:46:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsrzRb/Vu9FuDAAApE61SZxjUKbX3UqOEgdE/jWHTwYLekXC3G24bDSqtymWcm8tvZPrCC6+qrx22By8DtaDSgCxllkXliLiFncGZN3hHNWYLOT4Iaj5cTatpaqNlzQ9ItBAq1j1qRJiU33sQpsjpvtHozNU7wLxgxn7MvR6UiSZnC0HkwH6Oxi15Ouu/UT98gtKH9QVio6mOt6uZKI0/zHhANeiAlQ3/Ad9Wq5gF9yB2P7PeicpnDiAhg9zb/04pUdIw3ARzLY58d6pX3Tx4Sp8sFzn6KMtBWyYgcG5YNW02C52S5vDIEQDRbAE3hp2mn3c1l7RXE1F+FycdbzBnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psN6fFa8QpKmg29sah/pAyvCcII6SzIWv+35ik34oF4=;
 b=n/eF+iObwasl7eC5ek3ouOD5321OdnFdB41Raz2ChLZmBHUCodvbDnydpgb154YhvISxwJVNIRfQ+cBubNecICht8h9Y6+DGa1bpTk3+4GWDkWi8jLsVozqsmY6d58yhobZFSZsFiUARaemJuLTbP17Eo4YNNx0gcCQjqrgdT/SNvPH5efreV8WBI8XBOsw8ueI9n4LGLYNHIqS+PEQU0h6qJJVWN2nz8J1r8xeYbhV00v7nGpWHuZNngvlSC97NdOrRmyaZdFxpbRYDPLjD2cH0JxiKv6Y8sjx9hJEELLqUrsGqsBRO2LueTKpstvRvLImmV9xnZjyId/QYWadC7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psN6fFa8QpKmg29sah/pAyvCcII6SzIWv+35ik34oF4=;
 b=i3fKAZxvAa41X2ZBv2zRraNJXfrNq2f3CFYWEpsEsFH3qv8SUAy2OdhgWVO7YBeB1vp96nZpp4NLa7mbXiwvtG7i5wSTDxwvfUecI7SwrbPU3VW3rb13ASp5CrCJ+JF5jKvIWfLiX9764iyCDpP6b+JQENmKPVzVohCswKVk9/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4944.namprd10.prod.outlook.com
 (2603:10b6:5:38d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:24 +0000
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
Subject: [PATCH v4 net-next 8/9] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Fri,  2 Dec 2022 12:45:58 -0800
Message-Id: <20221202204559.162619-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: d6901ae6-10c5-4daa-2c44-08dad4a643a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdPRFIe/4oxYxE5sCp+5DUFuyTSAWymiOJSb7s42Yok3skKmnvvIMiv2ngFL+DgyVw64sVmi8maoN17QvVoFV52ERbiq+zHfrl7QgyBmSublQZbjxk7nWbwOdLN2cyh162fW7AxT8xKumcP/Iae2knlJ8ShZ2d0S782saFserkQiorMdojBjX1fjjMXl8hvp5YN1xuSXOM742RouWgusO1oncrruPR5fdINiab91dBK1PoGbvQK9WmxIC+XTPmozQS8oY9EWS0JtFPjfwVJfSJ0gxTcMqxgD+bRhkP6gRmZWX2inbQZ5PXPJHSIgdLdanw6dDpHEvc44PsiIuSZyf6uvcm+HDN6yirA4pmMciudn02iFI5E5pbaw7JeJVdNGCsynhjpkjFdUX+EdGgNtGbVpEXprPB2YR4MJlaswRnbL/dui37cRjBiUrf159XgzNB0EwKVSpnOmPdkp0o515cRV3XMvCdezOXhg+iuMnGmIWBwP0JZJSoidk9e0R4JZOYQCnvYzdaBuMJfaMsFSdgRno3m2plfTxeoR29TH1vw2Ekh9zf1SMHKSi6snFarLvNcDRaLSq1GK0BupXHdOxMxa9XVaK+YVTNnrAX7QqhMkPv3b6v3Lr85MQQPB3RM2OcB/UE5HySZ5tCV33bkM6vgeeC6t5EAiWXIrQYbgh7rcGPis0FZ8ZIiiIywVRP3i4PemVtOISvB1oWEOfGWwSysckWX5SgbTwnILesXN98YeIm/CwnCWY/tfxOzN4dNJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(376002)(346002)(136003)(366004)(451199015)(38100700002)(38350700002)(8676002)(66476007)(66556008)(66946007)(186003)(26005)(6512007)(316002)(4326008)(54906003)(44832011)(5660300002)(7416002)(7406005)(83380400001)(2906002)(41300700001)(36756003)(2616005)(1076003)(8936002)(966005)(478600001)(6506007)(6666004)(6486002)(86362001)(52116002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Z4LPcbtpymuWVKb6YmIDwaSluJYoJs0AO8OpNbPAcTAYbU6xLIXKLuX3cPC?=
 =?us-ascii?Q?Cb6g2wv6Yx6DI84Bt+0LU2+NroSNIRgIabb00S70Y7Wiod1Rp7wG0L+q0Tny?=
 =?us-ascii?Q?AEBDT8/6YGgL0oBxyzF4AM6ap7YpMXIK+pLNfdcEwTSTYtrQ6C0SCSuutUgH?=
 =?us-ascii?Q?VPfkejvZS6ntEflzbF3pd9ubsZbW6gXypWwkiSGpw2QA2zmb8zjSBVTGF9TW?=
 =?us-ascii?Q?Hws0i+7WP69xwJLKqAEUgh7q/gh6XynWVlSdtQJyaAIg4gk9W6Ydb5wJlx/Q?=
 =?us-ascii?Q?OnA5wOzmZKGV2nSVbwuWe97WpyMmzFwuzU94L6EsCFiEUcyEULsaQNLGAjbC?=
 =?us-ascii?Q?2DuchxqrjXt5sgnBOQ9FlRe0uOZpEoiyZoEG0oN1hQmRbRNvo9lfrVm51W+r?=
 =?us-ascii?Q?jn+ySV560Hz+Ssl9YTc0HF6f5vbK5Zdzl4B9we/9Em6f2pUWbx3u8J9Al160?=
 =?us-ascii?Q?X8TRPvewncMAJI4uvyq+Q3mbpZ5mMQBvHDhbEw5AUuqBMzI4U9HFNSysyBcK?=
 =?us-ascii?Q?dEM4f/gGB/IaJG1hYZXmGJYqy+kEKqqEEn8Mu1Up8oghnw1bQ2AsPqDKkLpq?=
 =?us-ascii?Q?W73BIKe5Id4O+MAIw4lS4S/xcp7ysqekiURhsh6fmt2YbQhp/5bwcafUNE7k?=
 =?us-ascii?Q?+pxsGlnccXkEdlexbGzDcAxLHwJlEX8ZFjsIjEf+mSWnrEO8wMDwVP44kkF4?=
 =?us-ascii?Q?5tWlEP9a9A0g+ctfwhhfQq1XD7UBd0bR/PYUKObFxb8lMHIGYrnYbewNMqiz?=
 =?us-ascii?Q?+hNQpLBD821QwMPP+v8JJWy3PfdG0u1esLgzwHgequ9vU8hc4JwZv7ErZU9p?=
 =?us-ascii?Q?QtZ5+YkzCGcDH3jhRR7xGepZXSV8sroJlhSQ3fYciuUObi/zGgKC8H0wO+dF?=
 =?us-ascii?Q?3ozVjWNQJcdCrsw6gdMC5Ogu6JcEd7XokHfI7ZwykalGdMSqK76xdEVzqgEa?=
 =?us-ascii?Q?i69LS3S0tgFB8nnniecfyY4eGR5AM0bWX+I91xBK6J1f55TpCkHpwObr2MrP?=
 =?us-ascii?Q?xi8o3UYvjn6gnFLNFuCOc3mdt/0rA+m+Y9M24ilm8i8foSLidq7WAbqfiIah?=
 =?us-ascii?Q?AdZg+jDJ621ujQzNHk90SAr+SrF9Xvi6vHEm5IBW2etgfkgmCDacE1FqfjMz?=
 =?us-ascii?Q?HJ49QzQCFAaq+MY7zii37FTEZgbpz9MWFoozKXIA4J9Bv26O6QRRYC0C79xC?=
 =?us-ascii?Q?YRynyQQlaETFF4m0v5HFzGFmtL3nOC2SlOSx76/WIQOs16TUDcld7fbelDPD?=
 =?us-ascii?Q?izga80Tq5y8dSAFt3iC6Xc/WdjMCohP32p9PzB81b1Y2EZ5jos6A308VTmnn?=
 =?us-ascii?Q?G9QUamlo8OS7z4z2CTXKTzk2nKmtSDkf4X64KPOLm5Pv/wYrQgN23FmT8yyZ?=
 =?us-ascii?Q?M8WA7HGBWDrMVC1BHyrHF0zvv+g8c5l2w0M8Ih9gTqEIFrtz0dVnD7JDrQTV?=
 =?us-ascii?Q?xrquM9H7tjtWjgEdtkzA9B5lPmH8k9fdncuPIlXfHXWTf5yL0Urj/gjGTpMw?=
 =?us-ascii?Q?jf/FejXSB8ub9r5sA4rn0f/kCrzEod0dSVg2wdESU7nqmPHux7c2yL9REIx0?=
 =?us-ascii?Q?/5p2VgVDZk1OeFumkkJZHJsy5p0Hx7y007Bd73bmLdnr9PgDOFwB5owmvM7W?=
 =?us-ascii?Q?+ozxNg86CRlWi4GeCB7PZJ8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6901ae6-10c5-4daa-2c44-08dad4a643a8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:19.3132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8ojPipjvJR2ShRBGotNJptnSaGTdBBnxD36JpDXUVCaJWGOThlpt6Dy4JyGzjOo6V9t4bAGxR5RO5G21XVfWV3XmJ3VrR7F2GA+/9Sv3Wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
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
---

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
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 24 ++----------------
 .../bindings/net/ethernet-switch-port.yaml    | 25 +++++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         |  6 +----
 MAINTAINERS                                   |  1 +
 4 files changed, 29 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 9abb8eba5fad..5b457f41273a 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Switch port Device Tree Bindings
+title: Generic DSA Switch port
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
@@ -14,8 +14,7 @@ maintainers:
 description:
   Ethernet switch port Description
 
-allOf:
-  - $ref: /schemas/net/ethernet-controller.yaml#
+$ref: /schemas/net/ethernet-switch-port.yaml#
 
 properties:
   reg:
@@ -58,25 +57,6 @@ properties:
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
index 000000000000..3d7da6916fb8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Ethernet Switch port
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
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
index afeb9ffd84c8..1e8b7649a9b2 100644
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

