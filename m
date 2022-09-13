Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6996C5B6DD0
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiIMM6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiIMM6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:58:30 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2047.outbound.protection.outlook.com [40.107.22.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE0C25F3;
        Tue, 13 Sep 2022 05:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcemmmWZPO14duZzY6lDZ86n0XlJA+G0PQ7E/mLKVaD9W7Bb1lq+GQgiAB6RCkvaHvx9Xi5kS/FPnWpZSHcyMCU3i0nrbz074tkbtWbktURfE/1sFBtvrb+3Oa9woQDOqQXN3ChFQnoEF0yDA+OabLatBkdcwZX8m4aKQumpHOUfi9FfM3lM2HsSaO3FkKsZWWQ9yZfv2gAuVqfSgDqvC8M3spUtaSiWYufxkhYJQ11M3BOdqp9NtKS756z883F4FBHL0l3btF/j9hAqbB1PuGvQRfwGJxFvrJWTDyY5KIdFl/MDMH9dPekKhVfuZ/Q962PdDcYvgnIhyQSN8sc+ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yX/29nZ9QfnL9ND1Bfe/T+EaXmdAFv/x61nIu90z58U=;
 b=dwxwvV3l95SHn6wBNX3xon4boaIVtfF6gjr7MseHm1Saq/gH9ln9FH5VzfF5y5e5bmvYcIjbW4kW6SsTkn8Xw5SI95OGaep7rPsySH1P/ZsE+EKT/ev/niMSA//R4q4+CUt0s2iPg6Mg7eEbcFdAAxND3al+bGOy2BVUo+9fa1yeYhae8GtFhQ7e6vaPymrZ5Zvw3hmfI/A3MOeVLivGFyaShCFQAgfItTYLzzgtqVl45wXkI8HcbR/CDnRbYRAkL0SxycwchkzrNWCHWD2bDmX4Vxhvss+x/CRdAjlDf56V1TBP33wcnDNqwGHODPGOrPhtpas9p4dr3A2TtfyV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX/29nZ9QfnL9ND1Bfe/T+EaXmdAFv/x61nIu90z58U=;
 b=JNMpM+xI8iYcdYX2F0PXK9p08fRU+ik+pTAp+20k1ioHSkDPeKDSQ6DIYgZR650bFXEvethUBKqlhAHQB3AdUsl65LC4Bt+bdC97ETDe/JGmXlyH3Ime8pGohCdDgR1e01mPsZuuisSlAl/V5bjd7ZuzLSQUyfTrW4yjUWOWO4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9451.eurprd04.prod.outlook.com (2603:10a6:10:368::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 12:58:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 12:58:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] dt-bindings: net: dsa: convert ocelot.txt to dt-schema
Date:   Tue, 13 Sep 2022 15:58:06 +0300
Message-Id: <20220913125806.524314-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0001.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB9451:EE_
X-MS-Office365-Filtering-Correlation-Id: 56e1436c-abc2-4fa3-d910-08da9587a17d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIr7h3/Gn2Taclm4gGSlxzhG0R6U8wyK1FRzDpnFA/bqifGpp1jsEoBuEOfun/Qu4FqWer97OKoJzM6U4s8OMjj4rpGWTUASQb7EI6CbSFxEni5iLljqUGrvuM9t+fS30ZZmU3HDEsuLu3EtgGsxOLJ7RF4NbavFVQuQNyhlFfrJH/vh4GZP01vGLD+ldmayRGmMWqUq9pDHBV6J6mhqY8XWQy2bHEYUbUSY6mXlupQMZxk2WFdz84FexZHYAQtqIA7/lGAN8tjRnpIhvQsAg7LrFM7jToJP55cVhVfhuybuX6kb1Sp3E+qwteoj5OjPojsQIDTbJ+9tBbOmT7YACWoNsMW1hoPVctMkJpCFJjkfLQQHV2dh0F8hRQM4u49oMqKKmWjcs0rK4ztQDD9v3gT9d6qdruzOAOkkLJosAG1qKkwbSTKgMdUbfEkwjXH+EY/kap1j3yeuxvaSygB+uvMDWT/tIhjpXREj0c/PjI7R2F1U5mmOMVmxJzUR6z1t7wvp6srhTWs0GW8zFktLPRA8KtfMavCZOt0j1YMAPNNvkjVxiDiBv9Fy1ooXOmXbtS2+H0/g+/wc18Wxb38RaRf90v2u3PQnelmbQInS5N4Nsu6am78BlmkHyLqKKzMS3G88RQrxEPVjXn6NPiIY3Fxq0E1msoTjHPZ56XcpCfBxE622SlcNzGhZ6Q0Hd85GDv1lz9viQ/ID5vzRKPzUN7DGWMsNR+Hwg3PHOu/+0qFZd97WDLrb2nSpuCOlDKRABCK+2tS7qnqCKD9EFPotxBqG0XqyLC8vYbhbwRU41Wov59SfNEqtRfp/LFbCaUi2XVE0WtfKhPKvwCZyoNRhvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199015)(54906003)(44832011)(66556008)(38100700002)(38350700002)(7416002)(66476007)(5660300002)(478600001)(186003)(8676002)(1076003)(2616005)(2906002)(316002)(4326008)(83380400001)(36756003)(6666004)(26005)(41300700001)(6916009)(6512007)(8936002)(86362001)(6506007)(30864003)(6486002)(66946007)(52116002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PsMjF6CTLo7MVAW3wRXBo5f/NYOAbbto535DWUWiz1uz74qrzZHPAjddIUfX?=
 =?us-ascii?Q?eWDy5ryPsiNw8EyJgMJFea435An49UChDk9XKdo4F3DYCsy2tDQMqnAYLtbx?=
 =?us-ascii?Q?q0iUwjhSwoNJWINjfRF8alL4IzRLDxh9ddUC0QmA1PLwhN2ez0pilW+Kv2ry?=
 =?us-ascii?Q?SIl1xgB0IiR+/QbcJZPOOuvHUWhCQla99nqRY5yY+xiX0C8PWFVVoIGJCcgR?=
 =?us-ascii?Q?cr19wmy8d9lk+Bg/WewQFuolRC1589g76bOL3RRtaLkNwgZWGS6/im/U6K3F?=
 =?us-ascii?Q?G8Qpn21ox3p1kS24I7U1tWZ6gSTleeLVN6TOATDjCnEfUioXHdYcTbzr4Pem?=
 =?us-ascii?Q?di3EmODS0G1u7N4Abme59grPK1WMq7NPNbZpk4Kh5jjdjU7lGJDD+AbZAgQU?=
 =?us-ascii?Q?uus5VNFEjdWaulZbOeP/HjY3eVrOTBJnj9MbQNyGzUI7PVMJBf4QRTzrESkm?=
 =?us-ascii?Q?uagk7Wg/7sl6njNjvgViFOL5oLfbCNyqamNu+1jHLth45K7cPmTHQ5RRgOLQ?=
 =?us-ascii?Q?6O0+Ep0LDzsPWNhAU0S784lpDIzhW9dgWBjPoFSRUvjJyR1fRByzOPjxMYWU?=
 =?us-ascii?Q?/Xa/20qElSRPnwbT/6vhqOq6xv/PSwouiFhFYdgOJmC6AEsx5ytPGXd1M6l+?=
 =?us-ascii?Q?hEN4dvS/WospLcQVUA372JeXX3HqVyY/0cnUPYss5WcDJrSGXhN8W5EHlNLH?=
 =?us-ascii?Q?UPlc+GswakOQw//D1D6IwuNuMUGOsHu8QzM4S5ZbKvWLwGdoSpjc5BjxUaTN?=
 =?us-ascii?Q?56jlDGrl1F9d+h9cGB/QEelbG6nj65MfbDFibw0DxKzWh0NVjA/NojtZGXhP?=
 =?us-ascii?Q?zkda+MyoR82OvqPqJRt1mAj5upP3c6ygm9TJwy0EUtRPmYOuLGrcsX7HAuz3?=
 =?us-ascii?Q?3nWbCxn+FexV/1Jmz7GHFjAgVjESZ+ZtBQp+bYJEAsnNCZFbNdqxqhVaXJLb?=
 =?us-ascii?Q?OtdIUuNv+SLbOW63A5P+a14iznLtfYPIoX/1F6W1kfDZoBPnV9b/brXq352T?=
 =?us-ascii?Q?Vf8Z+uTdf+nJ+vNCpqyVr8um8bjOFMsQbT7uyskpDmj0pIyY0rG21HKJMc36?=
 =?us-ascii?Q?M+IC1q5hgkR6Ppeiog5Sjttp6HweQOt4Cxf+B47s1HYm4/jxVP+MWtA+qifp?=
 =?us-ascii?Q?pxEgIWqcHe19/LSJFCfUKZzLsgeIjXuR+1cU04SJMqvdaui7ffwAI6S5zlsM?=
 =?us-ascii?Q?/YOZDbTqcgx4W/H6h5fnTyS0zjSpRD4Zp+K/R3/6mYnQB9+5PQksULuG6OFA?=
 =?us-ascii?Q?90MVQn7d/hHKqR68Ih/6MWGQuRqmaI7BKW/WaOaV6gQlcFAc3oBManD4eFbR?=
 =?us-ascii?Q?MyIQUiVFTTqisOi8dCg31q/OoiFNjGO3gZw2FY1B1n5Zad7m4brHuGeNbRNq?=
 =?us-ascii?Q?h6vX70IUNQ9qMgtVMIJ8MmhxfmK3plAvE4TUhq6bzS+Ga2Y6XA4+ZjjCSAzs?=
 =?us-ascii?Q?5CdJQrA/0Xd9TQlckurKirAJsypPwQsRqQ44NvJhqXcwz8PS0vzvK9qDVkYM?=
 =?us-ascii?Q?CeHXDDOrW0W2YZUQr3pPqo0AqEQUdHOUzcshcA6rHM9FNHy+SVxhp7WdMMMh?=
 =?us-ascii?Q?/fnHaDQnZ7qyrz5p4qSKxmuiltWA21SCBodJU8UH0pZeeCJ+thBD9xVVk0ed?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e1436c-abc2-4fa3-d910-08da9587a17d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 12:58:19.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGf2TSrO+OtnRwjhvx0GV3R6HcNbwQeDWXMIWR/spJK/+fMj96PBCEmTiqYewvLti6ZayIneetAhWSCfJaM0IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9451
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the free-form description of device tree bindings for VSC9959
and VSC9953 with a YAML formatted dt-schema description. This contains
more or less the same information, but reworded to be a bit more
succint.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
---
v1->v2:
- provide a more detailed description of the DT binding
- allow little-endian and big-endian properties
- allow interrupts property and make it required for vsc9959
- describe the meaning of the interrupts property
- reduce indentation in examples from 8 spaces to 4
- change license so it matches the driver

 .../bindings/net/dsa/mscc,ocelot.yaml         | 260 ++++++++++++++++++
 .../devicetree/bindings/net/dsa/ocelot.txt    | 213 --------------
 2 files changed, 260 insertions(+), 213 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
new file mode 100644
index 000000000000..8d93ed9c172c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -0,0 +1,260 @@
+# SPDX-License-Identifier: (GPL-2.0 OR MIT)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/mscc,ocelot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Ocelot Switch Family Device Tree Bindings
+
+maintainers:
+  - Vladimir Oltean <vladimir.oltean@nxp.com>
+  - Claudiu Manoil <claudiu.manoil@nxp.com>
+  - Alexandre Belloni <alexandre.belloni@bootlin.com>
+  - UNGLinuxDriver@microchip.com
+
+description: |
+  There are multiple switches which are either part of the Ocelot-1 family, or
+  derivatives of this architecture. These switches can be found embedded in
+  various SoCs and accessed using MMIO, or as discrete chips and accessed over
+  SPI or PCIe. The present DSA binding shall be used when the host controlling
+  them performs packet I/O primarily through an Ethernet port of the switch
+  (which is attached to an Ethernet port of the host), rather than through
+  Frame DMA or register-based I/O.
+
+  VSC9953 (Seville):
+
+    This is found in the NXP T1040, where it is a memory-mapped platform
+    device.
+
+    The following PHY interface types are supported:
+
+      - phy-mode = "internal": on ports 8 and 9
+      - phy-mode = "sgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
+      - phy-mode = "qsgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
+      - phy-mode = "1000base-x": on ports 0, 1, 2, 3, 4, 5, 6, 7
+
+  VSC9959 (Felix):
+
+    This is found in the NXP LS1028A. It is a PCI device, part of the larger
+    enetc root complex. As a result, the ethernet-switch node is a sub-node of
+    the PCIe root complex node and its "reg" property conforms to the parent
+    node bindings, describing it as PF 5 of device 0, bus 0.
+
+    If any external switch port is enabled, the enetc PF2 (enetc_port2) should
+    be enabled as well. This is because the internal MDIO bus (exposed through
+    EA BAR 0) used to access the MAC PCS registers truly belongs to the enetc
+    port 2 and not to Felix.
+
+    The following PHY interface types are supported:
+
+      - phy-mode = "internal": on ports 4 and 5
+      - phy-mode = "sgmii": on ports 0, 1, 2, 3
+      - phy-mode = "qsgmii": on ports 0, 1, 2, 3
+      - phy-mode = "usxgmii": on ports 0, 1, 2, 3
+      - phy-mode = "1000base-x": on ports 0, 1, 2, 3
+      - phy-mode = "2500base-x": on ports 0, 1, 2, 3
+
+properties:
+  compatible:
+    enum:
+      - mscc,vsc9953-switch
+      - pci1957,eef0
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+    description:
+      Used to signal availability of PTP TX timestamps, and state changes of
+      the MAC merge layer of ports that support Frame Preemption.
+
+  little-endian: true
+  big-endian: true
+
+required:
+  - compatible
+  - reg
+
+allOf:
+  - $ref: dsa.yaml#
+  - if:
+      properties:
+        compatible:
+          const: pci1957,eef0
+    then:
+      required:
+        - interrupts
+
+unevaluatedProperties: false
+
+examples:
+  # Felix VSC9959 (NXP LS1028A)
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    pcie { /* Integrated Endpoint Root Complex */
+        #address-cells = <3>;
+        #size-cells = <2>;
+
+        ethernet-switch@0,5 {
+            compatible = "pci1957,eef0";
+            reg = <0x000500 0 0 0 0>;
+            interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy0>;
+                    managed = "in-band-status";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy1>;
+                    managed = "in-band-status";
+                };
+
+                port@2 {
+                    reg = <2>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy2>;
+                    managed = "in-band-status";
+                };
+
+                port@3 {
+                    reg = <3>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy3>;
+                    managed = "in-band-status";
+                };
+
+                port@4 {
+                    reg = <4>;
+                    ethernet = <&enetc_port2>;
+                    phy-mode = "internal";
+
+                    fixed-link {
+                        speed = <2500>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+
+                port@5 {
+                    reg = <5>;
+                    ethernet = <&enetc_port3>;
+                    phy-mode = "internal";
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+            };
+        };
+    };
+  # Seville VSC9953 (NXP T1040)
+  - |
+    soc {
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        ethernet-switch@800000 {
+            compatible = "mscc,vsc9953-switch";
+            reg = <0x800000 0x290000>;
+            little-endian;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy0>;
+                    managed = "in-band-status";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy1>;
+                    managed = "in-band-status";
+                };
+
+                port@2 {
+                    reg = <2>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy2>;
+                    managed = "in-band-status";
+                };
+
+                port@3 {
+                    reg = <3>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy3>;
+                    managed = "in-band-status";
+                };
+
+                port@4 {
+                    reg = <4>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy4>;
+                    managed = "in-band-status";
+                };
+
+                port@5 {
+                    reg = <5>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy5>;
+                    managed = "in-band-status";
+                };
+
+                port@6 {
+                    reg = <6>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy6>;
+                    managed = "in-band-status";
+                };
+
+                port@7 {
+                    reg = <7>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy7>;
+                    managed = "in-band-status";
+                };
+
+                port@8 {
+                    reg = <8>;
+                    phy-mode = "internal";
+                    ethernet = <&enet0>;
+
+                    fixed-link {
+                        speed = <2500>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+
+                port@9 {
+                    reg = <9>;
+                    phy-mode = "internal";
+                    ethernet = <&enet1>;
+
+                    fixed-link {
+                        speed = <2500>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
deleted file mode 100644
index 7a271d070b72..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
+++ /dev/null
@@ -1,213 +0,0 @@
-Microchip Ocelot switch driver family
-=====================================
-
-Felix
------
-
-Currently the switches supported by the felix driver are:
-
-- VSC9959 (Felix)
-- VSC9953 (Seville)
-
-The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
-larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
-of the PCIe root complex node and its "reg" property conforms to the parent
-node bindings:
-
-* reg: Specifies PCIe Device Number and Function Number of the endpoint device,
-  in this case for the Ethernet L2Switch it is PF5 (of device 0, bus 0).
-
-It does not require a "compatible" string.
-
-The interrupt line is used to signal availability of PTP TX timestamps and for
-TSN frame preemption.
-
-For the external switch ports, depending on board configuration, "phy-mode" and
-"phy-handle" are populated by board specific device tree instances. Ports 4 and
-5 are fixed as internal ports in the NXP LS1028A instantiation.
-
-The CPU port property ("ethernet") configures the feature called "NPI port" in
-the Ocelot hardware core. The CPU port in Ocelot is a set of queues, which are
-connected, in the Node Processor Interface (NPI) mode, to an Ethernet port.
-By default, in fsl-ls1028a.dtsi, the NPI port is assigned to the internal
-2.5Gbps port@4, but can be moved to the 1Gbps port@5, depending on the specific
-use case.  Moving the NPI port to an external switch port is hardware possible,
-but there is no platform support for the Linux system on the LS1028A chip to
-operate as an entire slave DSA chip.  NPI functionality (and therefore DSA
-tagging) is supported on a single port at a time.
-
-Any port can be disabled (and in fsl-ls1028a.dtsi, they are indeed all disabled
-by default, and should be enabled on a per-board basis). But if any external
-switch port is enabled at all, the ENETC PF2 (enetc_port2) should be enabled as
-well, regardless of whether it is configured as the DSA master or not. This is
-because the Felix PHYLINK implementation accesses the MAC PCS registers, which
-in hardware truly belong to the ENETC port #2 and not to Felix.
-
-Supported PHY interface types (appropriate SerDes protocol setting changes are
-needed in the RCW binary):
-
-* phy_mode = "internal": on ports 4 and 5
-* phy_mode = "sgmii": on ports 0, 1, 2, 3
-* phy_mode = "qsgmii": on ports 0, 1, 2, 3
-* phy_mode = "usxgmii": on ports 0, 1, 2, 3
-* phy_mode = "2500base-x": on ports 0, 1, 2, 3
-
-For the rest of the device tree binding definitions, which are standard DSA and
-PCI, refer to the following documents:
-
-Documentation/devicetree/bindings/net/dsa/dsa.txt
-Documentation/devicetree/bindings/pci/pci.txt
-
-Example:
-
-&soc {
-	pcie@1f0000000 { /* Integrated Endpoint Root Complex */
-		ethernet-switch@0,5 {
-			reg = <0x000500 0 0 0 0>;
-			/* IEP INT_B */
-			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				/* External ports */
-				port@0 {
-					reg = <0>;
-					label = "swp0";
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "swp1";
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "swp2";
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "swp3";
-				};
-
-				/* Tagging CPU port */
-				port@4 {
-					reg = <4>;
-					ethernet = <&enetc_port2>;
-					phy-mode = "internal";
-
-					fixed-link {
-						speed = <2500>;
-						full-duplex;
-					};
-				};
-
-				/* Non-tagging CPU port */
-				port@5 {
-					reg = <5>;
-					phy-mode = "internal";
-					status = "disabled";
-
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-				};
-			};
-		};
-	};
-};
-
-The VSC9953 switch is found inside NXP T1040. It is a platform device with the
-following required properties:
-
-- compatible:
-	Must be "mscc,vsc9953-switch".
-
-Supported PHY interface types (appropriate SerDes protocol setting changes are
-needed in the RCW binary):
-
-* phy_mode = "internal": on ports 8 and 9
-* phy_mode = "sgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
-* phy_mode = "qsgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
-
-Example:
-
-&soc {
-	ethernet-switch@800000 {
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		compatible = "mscc,vsc9953-switch";
-		little-endian;
-		reg = <0x800000 0x290000>;
-
-		ports {
-			#address-cells = <0x1>;
-			#size-cells = <0x0>;
-
-			port@0 {
-				reg = <0x0>;
-				label = "swp0";
-			};
-
-			port@1 {
-				reg = <0x1>;
-				label = "swp1";
-			};
-
-			port@2 {
-				reg = <0x2>;
-				label = "swp2";
-			};
-
-			port@3 {
-				reg = <0x3>;
-				label = "swp3";
-			};
-
-			port@4 {
-				reg = <0x4>;
-				label = "swp4";
-			};
-
-			port@5 {
-				reg = <0x5>;
-				label = "swp5";
-			};
-
-			port@6 {
-				reg = <0x6>;
-				label = "swp6";
-			};
-
-			port@7 {
-				reg = <0x7>;
-				label = "swp7";
-			};
-
-			port@8 {
-				reg = <0x8>;
-				phy-mode = "internal";
-				ethernet = <&enet0>;
-
-				fixed-link {
-					speed = <2500>;
-					full-duplex;
-				};
-			};
-
-			port@9 {
-				reg = <0x9>;
-				phy-mode = "internal";
-				status = "disabled";
-
-				fixed-link {
-					speed = <2500>;
-					full-duplex;
-				};
-			};
-		};
-	};
-};
-- 
2.34.1

