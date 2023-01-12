Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87AC667E08
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbjALSWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjALSV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2125.outbound.protection.outlook.com [40.107.244.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575582DEF;
        Thu, 12 Jan 2023 09:57:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZY0X5tJABavNVf+9qMmRzH8/FwucwtzZ/W0w6vG20Lrx4i5UmBzCK0eGpjGx+EcRDFyclUPCONAbjK8SHK+OWW+yl2A3PxtZ1uMsy8Tmqot77App6i0pPD7SJIiw1JY4IjAlCHe8XodGU9+th5FLzTe4RWY2UdZaMB9+0ltfej43BtLqlS/rryA4cskW0nhAFkRHohFknLYZ70zB4dlIZmnN9gtxo3OSVWhbRdD3zVWgwJl/Dn3Q2vsOBwj6NrP7fxIC7NyKwQRXkHNqMqp2oRjfeCIT6qzzf0gc7eXWSs9GmO3iHnfd2e69+bul/S38Br4lT0lermDj1tf/DSIaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69eMPfidzev6Um9LSbcuvBPHT58d7MYfZSoLgGh4J8I=;
 b=PnEE3xzJHkceyW8m2EWmAV79HUBK6RdIKDT3mVM07JFRZUVJ0UOi2KCAL7wHzdiHeYuvbYpxchSP8aaWzxp0jytQ1rqZcWuJrH0UPvOSqNKq440s++WmbIW7qSEzS7GvHJt7fC3Dvr8B/HGC0FvDyRw1WoHjFz8fgqFygkEHdUI0nYrvcs02C+aRVsZozxSmFILg526PmXRrh9nLtKlXkJ+iBuMv1TlWzZHfLqXTDBl1ktzIguW7m7cHvpn9/S0fRuaZqUa5PTCL9W+OO1qa72rts0RBD+OwHIdlj/Oqf2S2oBefJhax8ono1RSI2El6jM6qq+/65HUgnMd4NKujtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69eMPfidzev6Um9LSbcuvBPHT58d7MYfZSoLgGh4J8I=;
 b=qx20A2YUl0/MaHnnm4neelZ72a1P4VKagX0cegP7kS/zVAq7RoNpIoyYOH9Du4V/oZyK03sb4iZGYoEvzCZJoYuXaOqLnsyjCqwb3im73c9tfbkfXTqQomYUYf2YpzMvn2gyZwJ/FhjDRSJ49XsVruKkRDrm0JOwH/6pGgTuaDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4520.namprd10.prod.outlook.com
 (2603:10b6:510:43::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:57:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:57:05 +0000
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
Subject: [PATCH v7 net-next 10/10] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
Date:   Thu, 12 Jan 2023 07:56:13 -1000
Message-Id: <20230112175613.18211-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a1d0c5-7494-4beb-22cb-08daf4c66a3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+8FvYlXOuqrHNC4fYXRQwZIa+9a1GC7HleBj804X7afLMuQQowTlcUdZonr6JBLCJeMfMnC5OcGWhrHKuI6RQTgSEh7OwfPBnZgv48SwG363rrvGKkK+1Q83g1edbYpTENrChG9ILXBlNQjOKXnCJFpYxOu9aPYP1ZVuZUKw3oAM1sbHuWEFD1HEmSPaZ1WdFHlVzGfZyMtGrNUiNwsHc06Wcv8R5mVk+m6va2PxN8TNEZj1zITBipH/MQsYlhMD5R34djgE4kiNoCmQSNb62ohQpgQ5yVW+5XggyvnW/uXYJcSb9++n0oeahyoEonQcjD0GmIuCe7TpHzsCQEFg6O8J/1wRCfJKD8pDm4XVJ9rcLFVFOAgREWGJ4XSXCcB7P2+O2WuH0zNGF5QDGSg/7Xac4IFPofEfuzd61wmLrWceyn6FVijiacqYaqGlGC61DDjNYrMO8pRoZ+G31e6IRcv7GnSoDOe929tzol6pesgEl3HLPCksWxCrA0+XOYDiGtZNhPTpmlcsd9hCi8BJw2KTaFNuVfg3nafVP4z9l/N0qS1roQIM9URxy+wVam/C6MdkO6GyHpjU9wdTntB0doGSE2zWXXsMU5NPHqr9j/zA0eS/G/KXy6pcxOjcJDITIUJ1jXCXNKMkBYBGtDnb9GWPpYSiTjnoF1TvkK8+dMJPdjxHjMeG9MJI7JLJpsQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(376002)(366004)(136003)(396003)(346002)(451199015)(6486002)(478600001)(52116002)(86362001)(38100700002)(36756003)(186003)(83380400001)(2616005)(1076003)(6512007)(6506007)(6666004)(2906002)(7406005)(66476007)(7416002)(5660300002)(66946007)(8936002)(8676002)(41300700001)(66556008)(4326008)(316002)(54906003)(44832011)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5k1A67H8jltvnwQ8P6td/+f1IFyB3LHtp+298tt02MPQuygj5Qwz9EppAuA?=
 =?us-ascii?Q?GReeC9r9WxrKG7GHCkPCfg0Rr/OJx4HdJeXQo8CqGXClgUEGZYbqF9IDQIOd?=
 =?us-ascii?Q?3zlsn8JeMWNEqEVvZqM7GStUWBalwpJWvu9INaVorvqAkIe3xcgE57icReDv?=
 =?us-ascii?Q?14gU3uw7sdUtU60vd3jNueuQHaaud2awnj0C6Nm6kqt7aBwAftU6i3aIrP+e?=
 =?us-ascii?Q?NEbyrIW//2ctZZS1yuviHeaGtaJS1pdEYuqid0zRbKV0jjPiAaSN2pVFeKyS?=
 =?us-ascii?Q?CXG1swdSVfus5da6Q7m9Fq3qJrMmrNfieukXbtYPXMz7sJqg8T1IVFRMnnPd?=
 =?us-ascii?Q?qHDv0ExrktAwk5ZFLT9YaHo0Tl4a+JwHHSkrR6KMzzvn+NY48c+EFtCYg18m?=
 =?us-ascii?Q?Zh6mre5oQJpK3lilRrilZ6OtqUH1MjOXITHtqfqgCbrAmw0YCpee/oqivH4+?=
 =?us-ascii?Q?ONbUuG74g/ay3vCTnEhzuyjWVjc0fN/0EIBePE0B24EdkfZhBL3dIwnuuSrT?=
 =?us-ascii?Q?Vguz2AD+Lva7m0sjB3mmyGAEdDkAUyC1Rt6Te/wGXqtDbT8bKgi06EbvdeW9?=
 =?us-ascii?Q?VOzjESDmZPjaQP9VDcsRBVnCNH0m+YV6aTTiZREAbhm6ZvY4P01AWEx++5YQ?=
 =?us-ascii?Q?j6AjEV9YHWuzBwJrPfK1/y96fgI/Ubu7/4MKit4gBs9YKcATCpvOv4HXBsxn?=
 =?us-ascii?Q?4AYfVijBZaO7thAginec2KrcmW7ze/JIGb3HeC/OSCE/Px5cLMKLvFitDvX5?=
 =?us-ascii?Q?y6Y64mKMphzb5eoDDshBETYgunabM6sxxlPQhAaBQrar/F7Wrid5dAa6kyE/?=
 =?us-ascii?Q?Xb/Og3u7j7/uWCYi/ISSNEG1T74aJDBdJ7sM6yOI81j/Uq7mjjF3gO53agFH?=
 =?us-ascii?Q?TjTPU1bqMiFQ4xGaLfEAxSZJwrGE8xLwCYI8BSKCMPOUqj0Yan5XSQBeeo45?=
 =?us-ascii?Q?HcHiRm03zfl1DtTGQBaEMu/WCgsH/wMFMfCsGlRgnv7CeXab5UcctV8hAKiu?=
 =?us-ascii?Q?4bkscdPZhKHrDQH9qiiLG3M+j/z4JPA1OrRfkHebheMQ214xhnV16wJKTrpC?=
 =?us-ascii?Q?Z5v5BYPHIQbT6ACHKKsYk4L+npMh6l9Y6uDy4HZyNVlk/HtDRO2jkMk1CT4T?=
 =?us-ascii?Q?M/+hkAq6V8e3w32ZZskqxc1x9LFU5Znho+aC4KHrug3WPvFQ5XSfIr3zDe4c?=
 =?us-ascii?Q?qOHh205EKIhSXpdAvL4SfHZbW8W87ne4gb3EpCBdAa64KyPhYWw8jmS2sdMH?=
 =?us-ascii?Q?hRRF25ucaIc+tCUBjIGiRKYq2CHFTKrDtBXHgpLBqV7EIpPdyUpigU+ERarr?=
 =?us-ascii?Q?hpxevasv4fqsezAAksTqqg9iPopdfK7FseZlHW5U4fy7m4NsI8p9Et/efRPK?=
 =?us-ascii?Q?UaoaUiIL4CiyykD/rfz3hURlL6WRoQ9BLNnEekoB/D6ETdNFlK6ZcCZN9xYj?=
 =?us-ascii?Q?nOJMOVEKEPxCO5lMgcEHY+X67NkkDV7xVyUdV1rx3ZDqXrCHzLBk2O1XJUUS?=
 =?us-ascii?Q?DdhnSPPD1UverCrruErfNTOiU+a5QW4VfubO02+GGwl7A4fb2Kf21cG6kkkD?=
 =?us-ascii?Q?agxUa9wsmF653jPV2hGdxFtRRzW26fwu+LJ9oYpoGoIBwuI6lb0FhL20wG5J?=
 =?us-ascii?Q?TDE2+MyOTYs9B7ukPJ7LvjymkjheJziuF0Yk/ndhKIkv9gEBtV0kSzqKCFgr?=
 =?us-ascii?Q?QiWkBsGn4o+4kp0/ASGD+DW95FI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a1d0c5-7494-4beb-22cb-08daf4c66a3c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:57:05.2342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ya5OrdHEqLo+If57HpV8ABqV08tjMuHqclOPeFTft6fbJ16t3T8N5Igg3+aJfvw7QC1dvwu5FxgeAj2x4z3dWk2gvP/Yj0pm9t2zZ+sdWus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
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
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v7
  * No change

v4 -> v5
  * Add Rob Reviewed tag

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

