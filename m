Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D215E59F3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiIVEDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiIVEC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:02:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EFFAF0D2;
        Wed, 21 Sep 2022 21:02:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guYnVkGtxHCdr3mkmNv4sfqMaZ3zoASOcqLG0fe4A++lTG/jRiDKhksAl5HZlerrnWZlWQsuBnll8unhFObcp9j2qwwU3f20IIlntALO9cEUuGG8v4ZveV4JkE63QI6glOqpQBZCcK11LyG1w6kw7Ga16958ZK+/HI6+JkYWwu62v3yC6c2XxSiNVynwnePbBLQqmv0SUQnozld3xhKwE7PHK7FB6dyJGw601njGrZw2cAa39FbBfHSdMSJ16WpQ8/sPSxNlO2+WEyF4XenypnrBNvbOlFfhWW5TYyBe8o5EWayOMpYV8xQ8vYLjS51+R13StrN4MZ9qKbdSTdF2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyFOEQrVbuTW9yv5arpehu6Lgsn+VHs1TRSEjnm167w=;
 b=JQgKnNr6B/ofYgEtQK1+hUEPfVPLUlvXkAjmKhVW1zRWWDVhVXJpByLRTzxbiXBwvSGNlTEAtCo6G/UhcJmt2OPQMBdDgxwMbx7QRhQWl4SczRYxiULclM7CgRI0btvNgPCw5bYPo008wP3axoWGnZli4CJZR4dZ4Oe2tYbq1Z3IKD/xlYpYZacMbuLAJWqo0/IAiN4RAzJI74jhAZZ6x7uUlegwtbtbEkpBZZzafQE1d9Qzrvs5zJUdtsF0Za3ROa115XCPSAdjU1v85BMxDrqmXDcROf+VNiws3N27Uc9pQeVzVJwgld7QrOM5jXX+hQ93ma5bO/kPywJySnZ8HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyFOEQrVbuTW9yv5arpehu6Lgsn+VHs1TRSEjnm167w=;
 b=zQmMbbbuz7FIMQVW7BO83bOgFSkuApy1c0Xv3CEOU6njSO80aHnjjWvFYz2Otf20MFAf+HrLZfk3JHfrqOkcEpCUJU4jytj4At6QfHy9ohtMHZ3zFBFwx5F7pojsMtKF+nUTDI6HWYtD1y5nBEQjZRyo3HYnqGlaGHMQtggwYJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 04:01:38 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:38 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 12/14] dt-bindings: net: dsa: ocelot: add ocelot-ext documentation
Date:   Wed, 21 Sep 2022 21:01:00 -0700
Message-Id: <20220922040102.1554459-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 199c23bc-46c4-4d36-e878-08da9c4f25fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBSt81BzwFVRksNqzkIGcDgEV+BTsSuNo2JqsfXgIpORRWg5kvY2C6cnXB5C9kthclyzWog83mhsDonqu8h5V0Ywl+WaWbJPt8RQ6wIUX+ZRltzbe7oMGYgdSQVBEfXtf2c6OSw4rSPQs+Tp4OfAnCOMnv5LXyhNctoDo5iEaDL9iJgDTiKbkiP/iSPiTbNPaGsvl0Zbygxzp5u6AuUQXF3sN7c1dL2YLz1PrRwy1gdxBa4D3QQOI5yfwm9JCUL3QNaN5Hnk4EqoLq2+nE0uwbQFVlKTj11fdrQdNNKrn8Exs08BVCvOrsaYB9V2bn7tBUxD4r+GueI9s0p0503jbalFQpDOcHnBYpswbOTa6plykJ5MvBA8MesQ7c8Uz50CX1vT7H+pKZZnWNM6286oZuC6sIjbkzCUxdmb7/LK8NXrf9lNS/KfESx3oa/kuOJjH+o7pUV2dyA+MfUmohBOm+2VGdRWEjLWaecoZrG1Rdf6dzVp7zy+XR6D07+pgJsvx/IpASENxPtDVTwuH/qw2sJfE00UfV72t8dpdUqxd7w3W9ai6gmwjDClADXqn6SNp+j0lakmoxAWYkLT1ZJ10P23QAMpwKP7/b0a2NhpKnPDluIc8MNvqYUnaiP3ev+kb/FREleHoF8HNRv+a1Xt5K68zkZj1lx30lvUaoYTKJVpXdEKDv3Pxx48fukhj8kJ93+8T12Rlr3GN01yKCEoOpPDQCkjxG0847Z2seaVBzEZD3TmjNHmaEgudl07q+PgC3Q+bpphjIHi3Kn/FwVwmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39830400003)(451199015)(36756003)(6506007)(6666004)(52116002)(6512007)(26005)(86362001)(66476007)(66556008)(54906003)(4326008)(66946007)(41300700001)(8676002)(6486002)(38350700002)(38100700002)(2616005)(186003)(478600001)(1076003)(2906002)(316002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t4xjSUvgcBmDEXvRzzp1D1VIbNrJPbwioz74TXYBNcNaKKLLMjpFRcn9sj+b?=
 =?us-ascii?Q?O4kCpfarE5nt2VxaLxRquwomuogu9X96vs9k6q8aZyaruTEbMvlNhtYiBL5E?=
 =?us-ascii?Q?HJ6xCOR92ecQpjjxM3xdyrrssstWIMXzZSMwVYQ6U0ZucAKrU9wb9l/6N5ZP?=
 =?us-ascii?Q?GVexwjPTqXGuAdLQwV6MeIKJ+NmBE2zhJ3/e7YVIG+si+GG9tNn7OnSAH3PJ?=
 =?us-ascii?Q?vVHvNwLgdgKAYEpww5RIULWbYv0ePXObB393Fo4LZDPrG+qzSKiBANQ3a2jS?=
 =?us-ascii?Q?nnqjJVrgBQfO0VKWRc5uu5W6dQCmEKumWga18guZ07rG9LWKL+6o9KSLqQSc?=
 =?us-ascii?Q?x0olzxt9OXoXM76/FV22W8BrpB8xspIKVjSvNbDAl7tYrUOPkgnEhKhU63qo?=
 =?us-ascii?Q?hzsbn5F+JHPvCNyeiOBP44n7giMBBbja/rgQGiz8YNJ8SmeXpMbfFOUc+5wr?=
 =?us-ascii?Q?uixIJL1UDRP4piS+WAgSGiRImFUVNWJetuEGfgcs6h+xmzZGJIhgqIliIVyO?=
 =?us-ascii?Q?YNgebExDFNHjaE/o/KBL0C6umaTTqihmyQXft65vHGaAltwlXOD3ge3C6K56?=
 =?us-ascii?Q?lnAd1rrOr6Bs/aRm6m4mTfyFAQj3QwQ2Lqi0Nd4yzCHy/CTeJ22oNWHrtaDA?=
 =?us-ascii?Q?ubhvnOAtiJ/8jyW+bgajVdN24B4b7/h5quOGxARtSLQzxb73Ydx8NKfvn2TR?=
 =?us-ascii?Q?q9UaAk1ikugAoL9PBiGljDCYh3zign5F/p/DOUiUYFaPfK3/NkoKpJRdRio2?=
 =?us-ascii?Q?WcQxcXwb68s/hqHbPNSoixaS8dkQE5N2Arf/Y500XemnUkb10H4XeBHcdjth?=
 =?us-ascii?Q?k1Q9lspeFu52ZFmJNyLPByaabuU96Z6O18ljUtj1M8LMu8U+OhPpmO6wtMv0?=
 =?us-ascii?Q?6TxixeH5/Fr+TrGD+tgoWK2t9NfOWVbEp/JLsQPT5zguiHiyfLMo2bXCk0/l?=
 =?us-ascii?Q?rs2dSr6xWHW1p8EKu97r2/l7cf+2noetgAgHISFV8f7y6Vramu2ItFimquQT?=
 =?us-ascii?Q?sA+cf/yWtuC3n5qhn7hvRub1K14UXOtN435gMbHCw+julP1lsxJmpxXvtqAX?=
 =?us-ascii?Q?Zml2EuCZrrQiDMrop9QcGkjEIq4schJGQUM0AqwAh2QE+iEiE4UkS5//VgVL?=
 =?us-ascii?Q?P2pdRdE1PRMw7he6pcwljqlgxrq3wGf7jyQTWbT80shZldbsYuvF+CTfbzRl?=
 =?us-ascii?Q?vvyV6Jpqd4Ig8/Kuw74Igfb7SrnbmDoiqMU95RcaBg25WpqcGZgNn+OjRadL?=
 =?us-ascii?Q?C3Wlb9/2QQhiFkmgnU4VxP6CmI5wkxLgcRQhT5Jecwgg1ca8U8b+BP0ogScF?=
 =?us-ascii?Q?gd8+yjqbBPR+bc/pLuYvFrYs4ktGbZZGlT9eXN7/7nze3FvsoaGeTh43Z5KP?=
 =?us-ascii?Q?0+yFIuTR+FqrNpqdIO0FpXF+FilIyDv9C0D4XC9um7NTJFFmRZDomdfQI7rq?=
 =?us-ascii?Q?TLOONywqTQpTSF7r7KKxeDisHgaprC1Sunf+HMJMweO0PwQeSczUwmO6oO5i?=
 =?us-ascii?Q?BjaKGplWKp/4gK7pBax+6YNQ3W78Owd+R2r4B+OjqcA6WmCvZT+UBw+HSwbQ?=
 =?us-ascii?Q?O8ad7MVFXDVYCkf2DwO1qYsy+2MwAtZtKDklZYXGzeZUr7hLrr1N7qlVtmIQ?=
 =?us-ascii?Q?BY9y7mXTi0AO/rRSEsU+qf8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199c23bc-46c4-4d36-e878-08da9c4f25fb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:38.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z47gHS5tsYqFmq6udqSxwbF6HzYS/qEyhP/wwhd5SpogasOSQczeunTnZxrnFudjsOqLchWMZAbjCAyReyn2b37lVAU2g2aMFoQNeiLvXRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
system, which currently supports the four internal copper phys.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 .../bindings/net/dsa/mscc,ocelot.yaml         | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..bed575236261 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -54,9 +54,21 @@ description: |
       - phy-mode = "1000base-x": on ports 0, 1, 2, 3
       - phy-mode = "2500base-x": on ports 0, 1, 2, 3
 
+  VSC7412 (Ocelot-Ext):
+
+    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
+    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
+    processor that natively support Linux. Additionally, all four devices
+    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
+    driver is for the external control portion.
+
+    The following PHY interface type are currently supported:
+      - phy-mode = "internal": on ports 0, 1, 2, 3
+
 properties:
   compatible:
     enum:
+      - mscc,vsc7512-switch
       - mscc,vsc9953-switch
       - pci1957,eef0
 
@@ -258,3 +270,49 @@ examples:
             };
         };
     };
+  # Ocelot-ext VSC7512
+  - |
+    spi {
+        soc@0 {
+            compatible = "mscc,vsc7512";
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            ethernet-switch@0 {
+                compatible = "mscc,vsc7512-switch";
+                reg = <0 0>;
+
+                ethernet-ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    port@0 {
+                        reg = <0>;
+                        label = "cpu";
+                        ethernet = <&mac_sw>;
+                        phy-handle = <&phy0>;
+                        phy-mode = "internal";
+                    };
+
+                    port@1 {
+                        reg = <1>;
+                        label = "swp1";
+                        phy-mode = "internal";
+                        phy-handle = <&phy1>;
+                    };
+
+                    port@2 {
+                        reg = <2>;
+                        phy-mode = "internal";
+                        phy-handle = <&phy2>;
+                    };
+
+                    port@3 {
+                        reg = <3>;
+                        phy-mode = "internal";
+                        phy-handle = <&phy3>;
+                    };
+                };
+            };
+        };
+    };
-- 
2.25.1

