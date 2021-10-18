Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B037A4327AA
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhJRTdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:33:06 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:13540
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233772AbhJRTcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:32:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBXsba7FM538bZ5TGiLjLpmRwlKI8vhirs7nYqsckCySWJ4TzY5VuCxPK8o+Q72Z6/hrLrxDWONjAKk2kjmaGJGjolQKHDn7p6Vd+L/9RklKgJgVPiUsZHtn5dkg242JuOmiQrE3S0HBdLx/VPEWYN/1vW4DilFULdrurfl33BmS/4wHT5GMaoBKBgKC2KMjxxSR59Vh8vDPK64LZwKKWFVNRW2VzM71dXPBUZVD5ZFKB/1HGRvGVZWRDMtiKgjFtn0r4KNM+pARgMgpsVyb9PY4uEQeiWkQUSx2gGFdzVMvPuIigRofbtTYnf37r2hsuCiMaM8sjlG/MHvszQ58YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8org8jPdbKdvr8dPnDLUDpuF+bSkAfx9fKcYhKmokc=;
 b=PmYon+lMy4aLskAtusH+ki6NeGO5vLVMJjuRYUB7IMT+IlS88C3bgwOuMpG2QMjyO1MhkOoisEE7IU/RTsN6Hi0nPoXcquzehr7aTgN0ADBBCvqCay/YERii5gTMhLCEPbH5NBh98RWRmT5/6Dz6hwKTtlZppMzRIV6Kw9zU2PgVTIVb0RXM98LNO98YatiDvSFeIS1GjZu2EDc6XCwhwIhxecGgVMp/2VWwhHX7mdVVW/pYxwXPlFwxZmwqeAJXr+/FmWDxvBal8ogznFK5DA/Ym72quTf9P7m0CftyWMq6ILoQ5K+vG20z1X4BodnVBeN5t0pDFIV71BLATC5vaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8org8jPdbKdvr8dPnDLUDpuF+bSkAfx9fKcYhKmokc=;
 b=HjEBAmwbLxoJCDNO/Y0Y207Ffrh8AjzVa0SpghVigj4y009LbbUzhm52z7YJCFB0ZvR8koZRX3MzN8NlTBzfNuVMQK8APsOToBWuSqZ4lTk/ubRPyYVo4a/OpNKFU9nud7ch/tSMt5yDsSO1x58LCJbiEBtkg5fvaG+6x3XpjBM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3711.eurprd04.prod.outlook.com (2603:10a6:803:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 19:30:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 19:30:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 3/4] dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
Date:   Mon, 18 Oct 2021 22:29:51 +0300
Message-Id: <20211018192952.2736913-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
References: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0160.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AS8PR04CA0160.eurprd04.prod.outlook.com (2603:10a6:20b:331::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 19:30:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d513f2e8-ca06-4832-8ec9-08d9926dbf92
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3711:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37116EFB9A3C21E24C839835E0BC9@VI1PR0402MB3711.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4BJsAoo9yFNbyFCru7yQdFD0GUj4Iv08swWYWNtZG2IAj1Ub53utfb6K5T606rj6qPHhJ3QSnKUfDUvIz9eHpUFCRFmDOmUPbBgPS2T9WFQ7JUCJUUlVebaZ982RSHgpWrTYsMiyuk/6P80BfhbXS0O8102sJ7C180Jc6VSfvG41X3TXo7khxCPnbI7eMeTExMt5qoDOKXufvG2XbntWg4GlkcW2FxdY62VDwNtmq0JBZ3iPa7NF9nn11ta8ocTlNK07JBXxDb83FUz04hkWjAzRgTattAAfyAD1WgFaOKnWGL9BvM97/T0SQGIXhhqgc2sfuF1jR5NKVaD2uuWcwzOVKnEK59OX/20rWcX+1nm6PROxKGgJj8lCf05mKl3dp4Wg7DP3KofxHzFu9fHgzB7gPBrdys8+ZrtgxHoyUjIG7/ddkbyXJk38e6WAPbadPvVblx4ZC8VrHojYEiFfeHTCMxYr1UsnpWxEO9DZgsp/23/aKCGaDrLh4P+0/abwWkGDuD0yHy1JPyuDACTzQtFfo6gFg2eH/Zr+kh1zM0RDn9c6357pSJ4toFBt2+d87WODa4EeHMJIKw6da3J+KuMP6n4G0D5OHAUVFHUaduqnbAE7yHxA7wA6SgLzb/O+AK9ltl9WCbG74SA1Od9o8E5a6/AO3h0sXCbUrrAIbwPbrg/6nRojDnFTMpFxxzx8q3Nr3xkfahz3JvVc2ANFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(186003)(6506007)(26005)(66476007)(44832011)(2906002)(66946007)(956004)(1076003)(6512007)(8936002)(66556008)(54906003)(86362001)(6486002)(508600001)(4326008)(2616005)(7416002)(8676002)(316002)(36756003)(6666004)(38350700002)(110136005)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LViGqdMegh7pOomW8B9kq8xtW7bXNhNVDDI4Z7h6ARUpUT1NaSkrYphw56Pe?=
 =?us-ascii?Q?YsybpJx4vQ/PwAPxAkvEkfPcNnfrYLkGqJy4YnXVK0rqD+5eDQpJhiTrwD7o?=
 =?us-ascii?Q?yM1KQ5+boj4dXesr49Nny5U8P4xEkLqB1M+r67LTWJYLB+I3ZYCH3L+j0F2j?=
 =?us-ascii?Q?yw1Uv1gvcK2oQ9awSc2YRvqoGs8036/m/3ZHQLew4vepSAyu3PXeSQrhOZyB?=
 =?us-ascii?Q?ErLP0Cnk/vZtWCMfyuQyskNRRkZ7RWPRXAhlHeh+Fu5ckOXw7fj6ma+c4VXO?=
 =?us-ascii?Q?Q158J9KHSumzsBbZ1RJhwJlXCy/g1YOEq4LIEvaHFuDRHwcoVJNdBP16LX0s?=
 =?us-ascii?Q?G9Vr3ehwqQuouC4yGGvxQhXOrM6iRvGn5GVrT0RU3+JfB8dRvm5zO52DKWE8?=
 =?us-ascii?Q?KMJy0+Su8UFJh43tuEaV0bVQyLQ4VpEZkcyhxyJsBadZdvDYN8tmI9b113RM?=
 =?us-ascii?Q?MHavWuPs1EYOKXX2By3BgtWdmtOk0Vy8yTqxBwZe18cilqbcSJ2zi1uPMUpM?=
 =?us-ascii?Q?7AyZARa4p8Vp0OBpvahxLqQXesAuhan0lAuKC0/O1aviwnLa/AaPoItvGB+0?=
 =?us-ascii?Q?iJjBUitybt9IpzxIxE/nBkJj7pCgu92zwG2qKWTrm6yefg1V1kw9J3R7Q+hd?=
 =?us-ascii?Q?9BI3lQw3yYI6fvTWM9sGb+91Xfr4oD/UTeL/ryIlPC0YM/xY65VOiZT2xapG?=
 =?us-ascii?Q?plPJoImPEMDGRZZqp18AWxNzMyrCaRUxEx9+PAuC9JyEJZQyE4vCe/Ay8wbz?=
 =?us-ascii?Q?SC6UylqBWGocoX215WwfYOjJuj/jk5FbN4HJkoIMcY+qpI1E/Xfej48P/iZw?=
 =?us-ascii?Q?2idmiPRvqtCCLNqEQjMYZOPGrux1DI66Fmw3C8GikByxRu6G6l/yFP3MOeUx?=
 =?us-ascii?Q?MiAHJcCdTugi0WLhS0TnxarzLcNJIHBYNihlqTA2bga0mG18UtyBUb1rLEfj?=
 =?us-ascii?Q?jwNYNewYjQPjtcV9gLc+N407FDUf+o0eM9PgL48ta2tgFhT257RT7GfTEtL0?=
 =?us-ascii?Q?XTHPR5Qk8+hwjQTc3m8nK/6dAs9u8pM9J4SFTOmAZ/DG4n/fZLFEnvsxB46R?=
 =?us-ascii?Q?ViVpYhbMFfRCRiYRFsYJ21A3S9lFeXeXNugOQYi3pD0gwCPugDv8jLA215HN?=
 =?us-ascii?Q?zzATeCRjFeL9T/t+zbghMgE3dIxsvqqvU2/1P7H/115J0mhBpMXn9TkAbegT?=
 =?us-ascii?Q?FKZ85JeihkpQaSYbs3ZH/YNNG184wBDOQbxePlB5T1gB9gC/ZrhY92kmn1un?=
 =?us-ascii?Q?g1zb4pd2SvChDfeXFGAiXqY0tQQpvb/mI0agIZIpXtXDRhlRyuRIrICquu47?=
 =?us-ascii?Q?5ty4v0vUa70X/Xm3ykLLOU5c?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d513f2e8-ca06-4832-8ec9-08d9926dbf92
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 19:30:31.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6asXhOhho8yGVMOqVcMTLDNm8QvpTasjQbtBBhaA+8Jz/gS9EpSgdGpGEv6Rq2SzCkWhcbYUzOYKVEOfyYd/VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explicit
MAC-level RGMII delays. These properties must be per port and must be
present only for a phy-mode that represents RGMII.

We tell dsa.yaml that these port properties might be present, we also
define their valid values for SJA1105. We create a common definition for
the RX and TX valid range, since it's quite a mouthful.

We also modify the example to include the explicit RGMII delay properties.
On the fixed-link ports (in the example, port 4), having these explicit
delays is actually mandatory, since with the new behavior, the driver
shouts that it is interpreting what delays to apply based on phy-mode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/dsa/dsa.yaml      |  4 ++
 .../bindings/net/dsa/nxp,sja1105.yaml         | 42 +++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 9cfd08cd31da..2ad7f79ad371 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -97,6 +97,10 @@ patternProperties:
 
           managed: true
 
+          rx-internal-delay-ps: true
+
+          tx-internal-delay-ps: true
+
         required:
           - reg
 
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index f97a22772e6f..24cd733c11d1 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -74,10 +74,42 @@ properties:
           - compatible
           - reg
 
+patternProperties:
+  "^(ethernet-)?ports$":
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        allOf:
+          - if:
+              properties:
+                phy-mode:
+                  contains:
+                    enum:
+                      - rgmii
+                      - rgmii-rxid
+                      - rgmii-txid
+                      - rgmii-id
+            then:
+              properties:
+                rx-internal-delay-ps:
+                  $ref: "#/$defs/internal-delay-ps"
+                tx-internal-delay-ps:
+                  $ref: "#/$defs/internal-delay-ps"
+
 required:
   - compatible
   - reg
 
+$defs:
+  internal-delay-ps:
+    description:
+      Disable tunable delay lines using 0 ps, or enable them and select
+      the phase between 1640 ps (73.8 degree shift at 1Gbps) and 2260 ps
+      (101.7 degree shift) in increments of 0.9 degrees (20 ps).
+    enum:
+      [0, 1640, 1660, 1680, 1700, 1720, 1740, 1760, 1780, 1800, 1820, 1840,
+       1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020, 2040, 2060, 2080,
+       2100, 2120, 2140, 2160, 2180, 2200, 2220, 2240, 2260]
+
 unevaluatedProperties: false
 
 examples:
@@ -97,30 +129,40 @@ examples:
                             port@0 {
                                     phy-handle = <&rgmii_phy6>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <0>;
                             };
 
                             port@1 {
                                     phy-handle = <&rgmii_phy3>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <1>;
                             };
 
                             port@2 {
                                     phy-handle = <&rgmii_phy4>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <2>;
                             };
 
                             port@3 {
                                     phy-handle = <&rgmii_phy4>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <3>;
                             };
 
                             port@4 {
                                     ethernet = <&enet2>;
                                     phy-mode = "rgmii";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <4>;
 
                                     fixed-link {
-- 
2.25.1

