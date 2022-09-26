Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B75E9760
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiIZAcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiIZAcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:32:17 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D87E2CDC6;
        Sun, 25 Sep 2022 17:30:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rg8EeUhOpvEE0ZTO/vPSXiJEthMff+7h7/D7Njcr18DqleZ+ApH82dofMCa/XvFCQnM5DXIZX0B6CdyDJKHmsJ92rbIRiAvCrbI1M1EWV4CqP+C4fNFXtjHcBRj+dHIKRVYHzhN4CaeOBxCcJVmRrijhDR+7gMhOkDvZNoxy7AsKa1K9zTMNC6JD3uFlUtfa9VyQkGS6SrGflGnTyOo5I+AlEdCT/jB9PNsYdxqePqR4djPf/Uu5Ehjhtein4RUeBJXqCxty9FMy21h0/wbvh21iymxDFFrh7qn3vbS3jztB4fPZPGsx8HldD+S7qsNYZZdKMozzIWHRHMofKDvrsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOgtO4olfoQJMgTD5BdxeRZ7GlcqXt0TvHTnnPb1w7A=;
 b=h1bYyipCO8wKL69MokMo9DllxDuXCyh1gk9Na1L/k2y7h1Nv8+WZhMvKwTkpGknhTr13fq0/OUwonFB38cInsyW+omq0KMzYUjzviJRe573Ani67ksDa44bbezAxwue0FtVWaEQUjrQMnr+4hmOLbF2Vf15YN4r1+/dt4WpZ6WvMV1y9b9wTFW9ZpOjGX2MICHM//fzfS8I8n83odQYwB7K8Yh3BeUSicS9RgWiLuYIgyU6qZsz6bkaOR9VXqGi/OOLlEVq9Gv+RclOX5h+Q4evzrssy/GkLAkuaCjnwVijbnVgSCK87hntfFrLxugK9iH64JywzH1dLKkdF9C1xyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOgtO4olfoQJMgTD5BdxeRZ7GlcqXt0TvHTnnPb1w7A=;
 b=tzL9aoPJTmxYZpHKWwAJQ06u/CL/Os2z0OsfQZcmbbiP7i+zYWZw4Bn6TE51a8I0t/be47+GWVc1Vkoyqgj0qsDL6OGrBKQDhFAa6MPILzOTwFJz11iSG2SJ+HmwU6Xz/UB0AbW7kdzZQ8Q5kj+M2naLXE46QL0IHMmII6CMNTU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:26 +0000
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
Subject: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add ocelot-ext documentation
Date:   Sun, 25 Sep 2022 17:29:26 -0700
Message-Id: <20220926002928.2744638-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d281862-959b-4bef-d8ad-08da9f564e94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GyC47QH2TjggQhh0wU9tKzBVT6QxoLx9UlFu07tEmdzxb3zj28vkSmlzerERCY31NyXAZUPPI0noV6sRq4J7C4prgyCnYMhPh2Uz7s8nvjRiQ3/EAuwkHtL4ysQa4zDqXqHdTBI6X0aR/s8QrW8Lv6/vYIhyZEIFcGbyx2a3gI79f5rwhNIbrtYYTLcF/YNJUJ7CTouDi0vju+3iCTwweSEAjXYI9jrwooPe2oVqQVUHxx3g0VQ/Mb7mHD/ccicba7CL3gxo8hELcMvKm08x4Kpv29l/4K+f6vy317F2HyTj1tqNT+Z2mtdlqESuk6Zvd9s+gpa/lI0ChhvPs2VK2ybjNGjgGqORPgTuo+EPc+pYvHJCUOelATJ/Vtf0KbUxr2gJ9re+iLqNdQkDtWvEUTLPT6YKHw5MeG1zhBQJ+kDXN5AGrvj+7ciBZKkIc1xw4QafazmPrxftUVrMesoT3GVysNcMEC5aKXenwpeCBOacFkPtT/aHO/2GscDSVJYDCglU5xPXxWhxJGTaY8MTdN3sNxI7rI56V9zU7HPfw6nO+8cucqNh0xM6ymETxxNssI1IJ4NixDJ/GBvat/CPLb4ikFzK65vjY8aXr85k1BeHPWNzx936R9zeRXyUJQMQEhvMqigbVrSB4wl9MdqbhFecgQwNadbD0YDsSngMCSei/2Ps1hI4YnAsJGXEur8n3xMwcP+sNEHTyKiZoFddIzwvU2fjv+0HNrO8flJIsJdW1kmjQ5Fcmqq5n8x1EFnZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XxjcFSVxfhPaG450/mQHGrhG3E5V41j4yqmp9cNhHXQDmn9IqUSfq52L5VK/?=
 =?us-ascii?Q?MKSgxKMzRB8Fj7krGOUApEJb4XD3kSbUKw7mzXSPC3Agyii+L69BKsvuLJNP?=
 =?us-ascii?Q?0viLvUokvww82OQbnsgH/GoGbKLpiRVg3jEbJtzR+1iCfywzAHnJimkuzMCo?=
 =?us-ascii?Q?5jFAvkt1VyJm1DF37uNg0Axe3lNfFeYLoIPYDaGFMcVcb8zu4BBFDg3wwwTk?=
 =?us-ascii?Q?HUgP1iikhzDY5KmWLIubeiyRSUITJ7okWlK/1eEEsB0kIoTOwRZ84sf+CzTF?=
 =?us-ascii?Q?bBPdYLhvfApOe9IHnkvO2hu0JC1zhMTFNT7LyOuasehKbhg37NZIpCiK76LP?=
 =?us-ascii?Q?SF94U9vvvaD/Gjgc6CySuz3cFGRC3/HgU+ZJFsd7d/PP7D72N6pc3vpVhDer?=
 =?us-ascii?Q?NJrXpE4LWn51R9lbpw6935GzbAyVrua4Qg+ogR/6WFMicjNpo9n03F3TMI0Y?=
 =?us-ascii?Q?Bd3PyivCYFBYl3fVP1xnehuU3LsTWKaKwzPK94YzxUar8OjV96YlOrqOeNSZ?=
 =?us-ascii?Q?VOzRP+9TlSmFp5nd8eam7cQQIL6U0Vszkod1mQmvxLTBoh2V8UYxsI1HM7OX?=
 =?us-ascii?Q?I8g3cgRFyPpomPDz+/Mc7QTipxmGNhR1wnkvEDKSoaljkPhKXTwqnwRZA8e6?=
 =?us-ascii?Q?YWcjIxDXWOUKW2qK+0U4rVcoyEif7Cwyp9cLq8eL/EiyOIi5rlAkChWP9kjx?=
 =?us-ascii?Q?al0lWPYD4K9YzCQGLxYLh9nC8cWosWF6L335UCH8BkwEC/0qwF6u9WIA9hKZ?=
 =?us-ascii?Q?IPdWP4fGNpeK7H1E+PbNAtTIyrepz2zIItGiVBCm2tPzW0L1Gy/YjjKIj2Ku?=
 =?us-ascii?Q?TfjNL0+te2Tawhx9HGYv51kgsFxEjKtvxGRaUO4zFGoPc1xQ191THfwTZl+s?=
 =?us-ascii?Q?42maHqMdnjjcFfnZTbdiF782mHXTwh+tpISKD0y567/wm0bYV9keLx/gR3jZ?=
 =?us-ascii?Q?sggLG8u2BUklcS71M/7HAjQoBdTsQjXDXH9PHfgLZmzQ116bfkVqVrEUej71?=
 =?us-ascii?Q?3DqFVCncI4yHApyZvsqVYxkoRpwxLPoJgU8ThCunqp0S1sxqJXtY7CbFLUy2?=
 =?us-ascii?Q?QmV7e7g0KHpF1Ju/xjNsTA0u13kvmrTBEm7eS0c3ETEvIX7EHLMfIYMmKWEY?=
 =?us-ascii?Q?M80T1NnbcDGkgj0PYrirJpWZAxrt/NU/q/YHoTCuMuc/nSiRIX8QhPxtkQ3B?=
 =?us-ascii?Q?9QXjUNIuIX+tyWfrJHM+Evq1gNHRXv/mYaHsdC8AFxwQTukcA8eyy1gDifWO?=
 =?us-ascii?Q?R4tonA089GtsRp8Yw1gHWcUKnRGMRDLK7poYvcXAnf7LHBoLCVwbP41NPb3a?=
 =?us-ascii?Q?OvEvBU8e2khvgqC1RBxGS9M7sQGas23h+ynKA0sjXfdnmVdd6X1KxlZ6655H?=
 =?us-ascii?Q?is9EWFSTzozG4JneoV9vQRne5kStLI+0rSiLmMmjdKsxtC1lVlHGNBiIAXoO?=
 =?us-ascii?Q?MfbELctiwSiEIoDcIuVZiJC34P3rTLb7pngz99uB4h0WLldbdr9bqu3HF9LX?=
 =?us-ascii?Q?9m3374USQhBxZK2G88xt8YoQsD1HUYw06uJMlJm1v7VFL2jJ6PZ2CZpCRwHN?=
 =?us-ascii?Q?MjTJVWeETXbnKLwblIi+T56h/rSXtLnn7TNnRxJdQ2aoH0Y8Ok8E8Zpfj89m?=
 =?us-ascii?Q?CXMculRVnS8Etvq0UdqLaZs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d281862-959b-4bef-d8ad-08da9f564e94
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:26.2602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nP18DnPNR2sr3MILuGtIMSGGoecgH0m+Puqh0pyq06lbjS4+K7z8UIVHBzpwksDdkVQvXPL3MQi7YrQVcmJ6P0vI5EF+UNSc4kASaH+Yfzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
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

v3
    * Remove "currently supported" verbage
        The Seville and Felix 9959 all list their supported modes following
        the sentence "The following PHY interface types are supported".
        During V2, I had used "currently supported" to suggest more interface
        modes are around the corner, though this had raised questions.

        The suggestion was to drop the entire sentence. I did leave the
        modified sentence there because it exactly matches the other two
        supported products.

v2
    * New patch

---
 .../bindings/net/dsa/mscc,ocelot.yaml         | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..49450a04e589 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -54,9 +54,22 @@ description: |
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
+    The following PHY interface types are supported:
+
+      - phy-mode = "internal": on ports 0, 1, 2, 3
+
 properties:
   compatible:
     enum:
+      - mscc,vsc7512-switch
       - mscc,vsc9953-switch
       - pci1957,eef0
 
@@ -258,3 +271,49 @@ examples:
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

