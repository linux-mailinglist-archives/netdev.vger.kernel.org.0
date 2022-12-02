Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11619640F63
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiLBUrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbiLBUrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:47:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2091.outbound.protection.outlook.com [40.107.243.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAD8F4648;
        Fri,  2 Dec 2022 12:46:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akfZxxzaItfD77JbZDcwzgT5bAyEhAQbNwNc3MBTSjEVKMtRbZMDRE11S+j64cw5ZSf009kvb6cNYggdcKuszT6jQECCI6KJj6roXtsdbRWtHnAaDUSa8af/dbhpFJe6ciiub450hPh1dpKHV7GecG8h8z2yqwum7nIkPYP8pln6YuNlWlklssaZn+IFprAWYBR5FNrJvbl6hXa9xoN5IGLXUP9oiZFsnA2bQ92KPnZbtGtpAPHEv3tJcQqi6j5bJJ80JYloXjrBKrMt+F0wwY0rR8rkyugG4X/RekOcrZ9pW+xQJzo+d6QUcHh5qnlg7j17Qqsxsf3RhGef1itcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VO/XnZfLZNbKy648fqmUy3e/6vlO3qXM+7l91uNvhJY=;
 b=Ai9epFlOTFBNku3RRj8T6sqT5nChtUGzQDLw8H9UTymgh0njpFEQA6tAGdSfq9nW4ZftNoiZ6snSmqOn6G4NSQ1iEj5MtwAOTINhLU778M5+jEllhECZQqyO9hPKeQJZe5fyL+zUfqYt1Ge2O2VZDbm0RN66AQkZvnOkhn/Hbhbz3b6TE5NFbeAw/hJKvU0Bf6L7NXhM38kuka7YX65fO3FXc+eF0dpCaPmYP0JJJPuwHudUb4lVbKzECAnUfrvOVALxmXlauY4+jkM3L7ZmaA1Dv6EGvTioCMUTCytrvaUemGFnppYodKmMaVzOTp7+sENhSZwmzrR9lU+4Pvixyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VO/XnZfLZNbKy648fqmUy3e/6vlO3qXM+7l91uNvhJY=;
 b=M4GgROrXY9DeGH1w3Qv0L3orQxuIRztKdSoOYQtB4pgwSRqwGF9LDfacrmVSKjvZgJqgNyw6vEHd45BkuBUNQWgKQMudU2gxVh9284wkoCTOKiaxcghJdy1YKiXCTIYwS26gBru3lHqdQe/x7YOdUIx3SRKMto21bv5j+e1YXdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4944.namprd10.prod.outlook.com
 (2603:10b6:5:38d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:25 +0000
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
Subject: [PATCH v4 net-next 9/9] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
Date:   Fri,  2 Dec 2022 12:45:59 -0800
Message-Id: <20221202204559.162619-10-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9f1f5cb0-a5a4-4587-86a4-08dad4a64426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GeC/RXTPcYcMj1q8OMIoAMLH5BMuLjgeJCVKu+E6TxMkwYPx4IJPmj7WzfEbsNYZBV7ej1e9iXPN1Sy0gYSt8Nv4efaeNihfsVuqCjETOjlowQ4GVn5sgiwEjW1tYtAGR1i+Y2ok+KVfsoOYkAAKQGV/6YVca0UJdJAa+gbZ+CqUu/YIjV+FBa86hp2GTHL7dPphM593bVeHmEUosi7omoVTtRZl+xLoZ8Aeg2aiMvEKZmtJ8OeR5Ahlz0p2ke+9GHKqKOXiQofPT8HTZLEY/mwtZgaavdDvHLYEXyl0soqYCc6CBPv0DW/yF+APPWV6h3fLT8hWUkQ8rorbdtrcSHbXXzxRPcf0iBta6x8B39k+UKkwyf1Hf2tm/k4tytIJL6H9YFQ/UQhMStfH2wxBbnq4z/+4Dj3dtQ1bHhlj9kGmYW/bsHc2vIYOktmPFU5Trejuht0n2EA3wZYqJFGDqhcQbTAiWmtBtU+49HPv1tE6OkgXZdUhC+/0FOH7skCknsLA27RJiXwpYkYHIV1yzGzbVvH3SES1Lrzxe4Ix0GYplbhocgrwtTVKbhzTtbhZVLo1GX0wTJm6Eug+/n1W60fz3e/3uMf+vBMXyF9eBqagg6WsWhwa6GoEbdhS4G+gbU2kbOW0AxxZ/CPTdYPzuyRvnsRyBLHLereuHbOmC6PGs7ApY+LlH7Pzz5odGVRPr/fqUF6uZbgKYoyZEaVdkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(376002)(346002)(136003)(366004)(451199015)(38100700002)(38350700002)(8676002)(66476007)(66556008)(66946007)(186003)(26005)(6512007)(316002)(4326008)(54906003)(44832011)(5660300002)(7416002)(7406005)(83380400001)(2906002)(41300700001)(36756003)(2616005)(1076003)(8936002)(478600001)(6506007)(6666004)(6486002)(86362001)(52116002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3xPXRfOQ396/HteBWVq0m+Srfu4p9gvxn0uwRBF+5C8+eglPsL1fbkbPtlM8?=
 =?us-ascii?Q?XiYMdc0A7nBLHfGgWUJ4umfCfA+HQfDfcoOMbsocpgI7c0oPqgDwGuJkuMQv?=
 =?us-ascii?Q?rX1Qho1q0FXFWgT+7cjtfjohOAwB9+ZH/yhZFaQS1M4wsdxfkAcQEOznJQ0N?=
 =?us-ascii?Q?AjrZfkYSYDLKcxYgME6qOeGTUBLBGv9Cf8SMaYW/rJ6jg5T9VaX6iWiZ+D37?=
 =?us-ascii?Q?pyQzhtD63uMc7APtuxPyPcFietfzsyIhtC3UpiBS3W71W4NnYCCJFeWtVp1r?=
 =?us-ascii?Q?dvOWRz4LDGCTk5qUCiQN+lArHMFKqnqUkW0Qg4T1eVPw5qfRLD7xWqQXzbVF?=
 =?us-ascii?Q?+xgel7A+sxId74GMAkmQnvkAGnAWQH8KXcb2kAvRnviTQd2Cs1FBD94xPPtH?=
 =?us-ascii?Q?pbkaKQVT6itEn391LaqSEePsQqF92ou1X0JZEBnMG314sihzy3xYrXKiecph?=
 =?us-ascii?Q?5lTOCRgXJg2hoZTPkAqqrCvvhyoFiFM1rEcuwBm1uqehuuLgTUPoZIipxJOA?=
 =?us-ascii?Q?rQR7dUQx0JE7VFl7r06WaP/Fz5amZwbeWp2rYg9u229z71d9mavWZyak2i2e?=
 =?us-ascii?Q?skU4XhhtSTl026KfNMvRDtFy3ujz2YPL2mPsJ/yoKwVx/80zI3HF0Okkz8Av?=
 =?us-ascii?Q?IGRmkwF/0r4Qw9T/cZPXvOL+bn4ufeenpsBVt/RlDUifez6s00reVfNQhoI5?=
 =?us-ascii?Q?2L2KnQ6RwH3G/dhQkSYWS2YZNIsr6rYvUC897HKwa8A1abmXCxzidI5H4Pud?=
 =?us-ascii?Q?lYHHyjTkqS0LYE7AE98L+STq307ckSVz6FpiR3j6BtSHe9eVlELg09HyLPrB?=
 =?us-ascii?Q?T+W//GRS/w0plUkI0NTLpQlW/LbhO8rIRJIXGl/YL9qwhZ+hT+2ZxVaAYj7L?=
 =?us-ascii?Q?Hihyv8nU6UAP1zngp0QF05i3tRZE5nvffi3DGjn6y7FAF5s/kmoIHWDC0ErK?=
 =?us-ascii?Q?GTE7bRMoutqBdXGZFwPgeqp1UezM17ACFo44vgXB8B3dsEtZu5oruvisVwHk?=
 =?us-ascii?Q?bsp0iDlVins+MFfcfZS8XQAprYOUYUfsa6DRLZTcCzTI3xXG6PwCl5Tb2C0I?=
 =?us-ascii?Q?f7/5rTAyjTF03b78SCd33xmACH/1GaABalcFVC2cUuDx6wL+DwQcUC6AeBpG?=
 =?us-ascii?Q?kd0tUKji4r9q/YIopkUDn5MX0awYzW7KSv7muI5rCDiLx1xHbNOOZoXo8j6O?=
 =?us-ascii?Q?Y/1W3ILxD8XN1qA/VuztN2rqL54lhkZRbybz67xyNS9UZgdoZlOG50J4EH7v?=
 =?us-ascii?Q?vkS6VNL9IGiv+mGo7zGQoEmzm9Ci5yJm0h5nfGVM0nWQYItpJDrNBu68Zq3x?=
 =?us-ascii?Q?Skgkqewj8Ykodja0sMPei+WT/Y4zPOwgSappngd4NmkE+THAjnbxJLCNPCuN?=
 =?us-ascii?Q?iR+qus9tUlZucLBVubNnMzW0eGanOAfpbgNIHh46uXTHJwaUHkoVVG9J8BDH?=
 =?us-ascii?Q?Mo/ROg6swJ9TwG/qco/WuM5yWljiUMXLb1Kx9Vkmne8IlVk76Bv/OTdBzU3p?=
 =?us-ascii?Q?HwsuTUgGJE1H3PwNnF2iRk/SpQOJN1ncsB8zotBM+wRL3cTOx1uUlrz6ZtVE?=
 =?us-ascii?Q?USMX5Qyqd6QRQD73KzSE4LmAu0S1PAsiIbXMICZA+ueBVdasZGhbxziOzHzJ?=
 =?us-ascii?Q?tdgpV7TmoFJY22MUUtBjtEw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f1f5cb0-a5a4-4587-86a4-08dad4a64426
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:20.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpyacNXEjnsAmnr567+cFjoyBeaX1nGX3Ni9u5GN7QZ4DDY7GRZgJLih8tV/8jblUwC8oLMtVBeQu9O0P8ZhCMCFlhREDm8y6Eb1al0gCKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several bindings for ethernet switches are available for non-dsa switches
by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
the common bindings for the VSC7514.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v3 -> v4
  * Add Florian Reviewed tag

v2 -> v3:
  * Reference ethernet-switch-port.yaml# instead of ethernet-controller
  * Undo the addition of "unevaluatedProperties: true" from v2. Those
    were only added because of my misunderstandings.
  * Keep #address-cells and #size-cells in the ports node.

v1 -> v2:
  * Fix "$ref: ethernet-switch.yaml" placement. Oops.
  * Add "unevaluatedProperties: true" to ethernet-ports layer so it
    can correctly read into ethernet-switch.yaml
  * Add "unevaluatedProperties: true" to ethernet-port layer so it can
    correctly read into ethernet-controller.yaml

---
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 ++-----------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index ee0a504bdb24..5ffe831e59e4 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -18,10 +18,9 @@ description: |
   packets using CPU. Additionally, PTP is supported as well as FDMA for faster
   packet extraction/injection.
 
-properties:
-  $nodename:
-    pattern: "^switch@[0-9a-f]+$"
+$ref: ethernet-switch.yaml#
 
+properties:
   compatible:
     const: mscc,vsc7514-switch
 
@@ -100,35 +99,11 @@ properties:
 
     patternProperties:
       "^port@[0-9a-f]+$":
-        type: object
-        description: Ethernet ports handled by the switch
 
-        $ref: ethernet-controller.yaml#
+        $ref: ethernet-switch-port.yaml#
 
         unevaluatedProperties: false
 
-        properties:
-          reg:
-            description: Switch port number
-
-          phy-handle: true
-
-          phy-mode: true
-
-          fixed-link: true
-
-          mac-address: true
-
-        required:
-          - reg
-          - phy-mode
-
-        oneOf:
-          - required:
-              - phy-handle
-          - required:
-              - fixed-link
-
 required:
   - compatible
   - reg
-- 
2.25.1

