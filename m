Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA4C639DCA
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiK0Wtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiK0WtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:49:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB73A10B53;
        Sun, 27 Nov 2022 14:48:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpAOLCi2Ll9errsMzUA5v0N/ryCL26uJ3PDkSA+VciWDr65plwlHp6an1exHb2Hdwi/lxrQf2DcrweE4pZAVgWmcOIV9UuWp6cnSbYtdtynZtEyvl/ZYxoKLe2Bl8hVevuHcSVpcUq4LME0e1k/jPFFcoNP9I/YYKkVWKtgEQSP5sDNXzCMiASHaUj1BqVVNpUDzE12CNXwOqomTuvQD366GQe6+CnE8P7kaKLnXKv9wsprRK5qiA7ygWMDblHXuhvu2m4deZ6HrAeyfX+6rsWsI7f0PwRExZlcEtcUdKpcKxeHaUheeSlBwev/l6R3vBwjFAFTo+1t9IMRHxn48Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMf7QBd+X8dJtGT6Qj4r2JP9k1YDWoNGjjYMcR7Y4Ik=;
 b=Cjo+gtfhaZtY3+TS4iIRuviZkSkwOZmoj83PFMG0u+ku0mAAXZ1RdDmQuM2oU18cr1KS8qass9V5GCgZH3cOpfvDgalg69L/MSMmmG2NIfmdMEmSPGZESVX8G4vIHMaUlZjkCtKZaqcveWZmgPNURGOIbENdFskPHavocom+JIhtMArr5POxE9PI2DkGMZYmj7vXw79fH+/IIHjtOzoPEsQXi2MgmQNxEm30+Co03MakRavhQvaGdKYqDXfdjxYz5eRnbw0GouCLOv9ZYuP0ADzwzZ4kVaX9N0rQqkpTwBbLKf7stL2xnPTpCIsGgxrGIjmh1o4AuLENRzRLffU8Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMf7QBd+X8dJtGT6Qj4r2JP9k1YDWoNGjjYMcR7Y4Ik=;
 b=vi2FNgVIHEMXDdv56CqlhKat1QosoZZChyiHUotQI6yCgIbjEVsNaIGgFIaRietGAUBsx/sWcMTztjPejt6QRfZ47r5UOlPCAidtrkFIbl2kPFLqHCAimRo7a/j/Q+SsZN1IXmSts66NMus72tDb2I25ls/sfeIRkLAesIrdb/g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:48:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:48:05 +0000
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
Subject: [PATCH v3 net-next 09/10] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Sun, 27 Nov 2022 14:47:33 -0800
Message-Id: <20221127224734.885526-10-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 122e8ba1-722e-4bb5-36e7-08dad0c971de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nAPTf8/7vhPhHSyHpmU+xV7dV4yW6PVbhtrbSYY3G8+VTvGaujGM0/piygSVZ6Z4n3M3A9OzWCqRq2lhpNyKky8SOYuilYyghFR7WvkN9BTJr0jb7f3aMOfdNfo8LFpYKVvvdNgYb5WNayE2hG86ZPXfP4+47d8dgecF6OfwPmIEUu/ScN8RcZdeEj3S8D30DAQVQ8kC9gLLAzq/nOg0MLLhOGdWr2kuShmM9KmTAVtVgOOydo/MKVaWpY5aHfv44dz7xco5KfkG1y0gc0UP2wgiYBaIiNFHXuwMVL2fU9zQM2Gm330XYxmc6uV7Zff43Kh1hGSQpEw9m6KASj3mbHeB43zNVcOYkhBz9AilQK4/o1GFAzYfL4x70ViseWKJ07SWGb6Z28FSnragRJDrOMA4tt0VlDZK1FDxcc/kZpLjA5jNjtbGadMPaEgdCtedyHTL/2pfV776URd+9FEetPK27KgVomtUCjBdo8tDD8mYTpEhxUf6h3fyQNwY79az4GF62UYTqV5ylZBJB+ChG74BwN/0Vei25G/Of6FnQ7MwkRzquyNQMuAcq9RySXlZvOxiT7ygYQEuFiBi1xWt6ohzNPR6cejxIXfsUPcw1gePQpGBG+oELgrpjqtALURqrypKcxE8Wl53+R0/2f1RxWvvQ4G/Vyg+lNuCHgOxYmQzKYTMMKIftERE65QYOzy9G0irontRR3ErTDK0YFX32eEKDkegsY+AJ5e5dpKPDKCGTgKBZcQI1NVaBeGtNNcl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(39840400004)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(966005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4hY00u+Yd0/VZf2YiSeV7mCD+gVRyflB4wvcT3WFtjHo93rom6AtiWZwI/L?=
 =?us-ascii?Q?ugTgj/NiKfAUXiwHy0d+KwZ9HFAAItSpY2oaAPzxQl4W1DyFncO8KSDWPyTG?=
 =?us-ascii?Q?0SiHUIPPYg2u21oQMAQa8yvQ08NolN5URGzBaz6kk0QOCzQN1WBmeKtf3A5k?=
 =?us-ascii?Q?CKBIs5ZmrnvYpZRJ1aOuleW7iNjQUhBV894Hb6xRO6ZL+aluOitpB3kmvt2I?=
 =?us-ascii?Q?Qu9r5DP5+Ty0db7QmsfbJhaZ6EhafAPJ588hDuutjO3Y4NyggiNcxL/ZndeP?=
 =?us-ascii?Q?Q14pYfr3praqMpNtKa91hEVFM30cJP7eX/g3PTcYsMBZFOdtv9o+gstBQ4Md?=
 =?us-ascii?Q?QQf8VFBOXknaEpa9OzMqn+HufN1m/T5VKkWeLy9i3Dz6AyTx71C3rySn2qZ4?=
 =?us-ascii?Q?UHeQkjiKeE4zSACuAUU5srpDssUU0/sXFN2il8OgEb0dbMfP0Y/mcncGeHiH?=
 =?us-ascii?Q?KHgwKq5EbSuH8wBfstXtVLeQa5Y9jPB7vNk0Yr0ED+m8HR3e0WxsJWn5rsXp?=
 =?us-ascii?Q?lHJrwxQsY0J5jmRPOsh39wcN0l3zA1yBZY+3bxez6aQ/VxgP8stuKSOrvMf+?=
 =?us-ascii?Q?L1+jZ4wuKS9lFta9FV0Gl42WtvC0Ho3PKLJ3b1M0xLBJckGGpdsvETO0o0+m?=
 =?us-ascii?Q?Ah9ipXtHUxBE5kybg/Gp39vXoA6ZVYlS6qmiQm+NGPiMuO6o83a+3orNYGxD?=
 =?us-ascii?Q?CnolWR6FI+fBcs7AOB42fDoNlJjbN21WKwBDrGCAckYtBnzS8GjxZh5cIypK?=
 =?us-ascii?Q?c522TitVghBFMbUe/IWXuSJA9XULix+PRUmovbEfIv1AovU3THIQVFBZOZ57?=
 =?us-ascii?Q?FvJiq4mCpIPtqi0gZhdhmFxkCm4SFU5mkoxefW3VA++ct+rOYVIVIo6ZOt7h?=
 =?us-ascii?Q?FQYw1wTJy87AViEVv64xWhcYs2IJ9gTxNLJ5lS4i5O5yoyV5HqJD+Jv+nnad?=
 =?us-ascii?Q?MlnuhHje39RDrtcVr2n4E5T2brgchI2uXvCTfwg8UByO0c15WY3dHsYGvJ7h?=
 =?us-ascii?Q?qMVwXPip4ZbrDrK/dTGLwk07OwTva47kfPNnNwq+vPJnKqYJUhICbIBWmub9?=
 =?us-ascii?Q?lekm9iEf7CeBGnxM35pY9gX6XcIBPAEESta9CIZtDn8KEevAEs1A4y+aigEX?=
 =?us-ascii?Q?5Lz5wXUDwLms5u+bbLNgSapLYlIBbpV776VAJETAHvcdj4Id4hN0V1pLlw4I?=
 =?us-ascii?Q?C8Ja/5f7LElqSY+r8/EmzhJln6QhyO4pzRchXNAnk1niL07t4Sf/Y8s7h0dT?=
 =?us-ascii?Q?6JAhHwk6+ePxioaKnB7Pzw80YwR5sLriiPTt73gQwb3CkFDQTgZwIH8Klk2g?=
 =?us-ascii?Q?TRHqH8mVHcEtWWSfrZ3142AHuAVnFeNpjha4ITq+1F7n9ro0Xz8xwrK7jzvt?=
 =?us-ascii?Q?TQuxE/ge8oDqfqBD9loUMulyVexaM20k3HtdN8z6Eqa5y+eaSAQlmAioZD0N?=
 =?us-ascii?Q?ZpPpeClV4EbjaXg1Y9uyZK2ld/Oc9jxqQPoJVbSD13CoCNSs189mXKXUsPTD?=
 =?us-ascii?Q?AOtDteprcsDHtjSNlbjptVURui0t/DhLLt/D3WAC0npa/khsF5nUVlM6223W?=
 =?us-ascii?Q?gBGD0p1U2R0q1krYaIJLTypoudfvDMJ0v1NsPsK9QhRQbtEkfqnkQXaAe6/q?=
 =?us-ascii?Q?3IemrD2N9QKVuO3ZIgl8/l4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 122e8ba1-722e-4bb5-36e7-08dad0c971de
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:48:05.0300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWlQqF/dDNQcpQmDixqP38DnuHTUfPR2UcoXvKtK9dZbslqLB/xtzmv9iERzMYl/WfHALJhTPVXoiech308feUVtRONEU3wbcX3HDe2kEHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
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
---

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
 .../bindings/net/ethernet-switch.yaml         |  4 +--
 MAINTAINERS                                   |  1 +
 4 files changed, 29 insertions(+), 25 deletions(-)
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
index d5bf9a2d8083..ef7503eba95c 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -40,8 +40,6 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        $ref: ethernet-controller.yaml#
-
 oneOf:
   - required:
       - ports
@@ -58,7 +56,7 @@ $defs:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         description: Ethernet switch ports
-        $ref: ethernet-controller.yaml#
+        $ref: ethernet-switch-port.yaml#
         unevaluatedProperties: false
 
 ...
diff --git a/MAINTAINERS b/MAINTAINERS
index 3077c5af6072..59674eb07491 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14332,6 +14332,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
-- 
2.25.1

