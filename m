Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EA849D6B7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiA0A16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:27:58 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:61077 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230248AbiA0A1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:27:55 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QK9ps6002638;
        Wed, 26 Jan 2022 19:27:47 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dud3cr3qe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:27:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVyS/HNwnab1KzYoUqbc/h3DZ/QmQ3R1FdfxMj9QTntlHMbbiNnJ25eqn0J/YtVkXW5cbjaYNXYc7t+dLW2sXHUKJcpGEPANFEHol2stMLaCH7y0ynaEnM/1lHXiI1y8OhR4JArbDqRaZN0e58NC7+W2QmIuwmE+br0vfv8e+eVkWP9XGehLuOdFBIRfgNszmHNW9g4oTLB1A6LkWWVmyo0vDZmO1VzyXwnd0KHN+UjClOlMuncjFnpr29LXOygI+XB6eowjRh6Y0VL3PhQuZslegNLh4VB9m1uGYgFzJak1tj6N2SzoFhv1bkfwAFHTDzIndSJBONLRyvTzBBpc4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+snoWjnx+U3hHP+/XXE8GSQF4ZEMPsCCc9+FgISqRk=;
 b=LjM8BEPy6QbKbPZXwfPEGb5cQjVSdmcdP461jnL3Y4lWgn1669Qb1I6xLoRJE9gypzBf/Stp6ydy8Qoa7uVFeBh9YIUM8RgQC0bpISjbDlwQDRBZck7bnfDOJzhYEPpM5vA1/atPrG/7u/aj5n0k8QDvr4wX+AHluFi04VoegfT1Ua4pngPeplE7r97Vz+VzU/3Pd0E4XHD4MuDhUzRBOSJPZcBQ2wXOiP90KB7jwzCAWMexsoJRIdu1AQEiuIhiHoULQRdnN7lWCtJD7nsp9VcZlWu5ulVuv9IBy0vn1VfjfHrLDKznjZqLjh9/MmiRnjJEoaJzLmMgDKLDJQ/PIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+snoWjnx+U3hHP+/XXE8GSQF4ZEMPsCCc9+FgISqRk=;
 b=R+xj1xYBORoNFlqYZ9AqA7bm3/fhAt7VhkSnncSgnpmq5IbwCQEOXmBiJP6I4rcX0141iLmRfOyepNakogu86zgSzziDIVaeNEVvjshp4ZeSzoKbkCxtIrMd7lEZ7KxR1+2hF7G6lrJfBlxHaQkQy/bt8MnZ/BdlN/V1FIXnFIs=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Thu, 27 Jan
 2022 00:27:45 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:27:45 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 1/3] dt-bindings: net: cdns,macb: added generic PHY and reset mappings for ZynqMP
Date:   Wed, 26 Jan 2022 18:27:09 -0600
Message-Id: <20220127002711.3632101-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127002711.3632101-1-robert.hancock@calian.com>
References: <20220127002711.3632101-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7889435-00c9-478f-0c25-08d9e12bd6b6
X-MS-TrafficTypeDiagnostic: YQXPR01MB5578:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB5578458C2F86A37FA07C04A6EC219@YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3hlGFQFk0clBJXB2VP/doF69ngiXdGyf3yf13NlU5FgFmocAX+fICxHctSdf8LebGNj9hY306DR+vAccn09eArTR3uJNg9nl4H3unMjy8BSn8rPH7tPNdoTIZfNEM29KH94bO8mWd7Fu3Sy+O/i7vBoeGwKCiT6p1t+k0Ao7Ys9od+EjPwfHuTpdaionZtRLo2I6uLzmNKr0Te+DtzY5pz6eI0pzL1WfYJ4uTqre5VdeqpY3k53IHGyxBWStGtV/uQdPWBwRYDzssjl44yhAnTlS63Kqusx33Mcw7rka/nRdTij5xHWEcaCnJFIEc3xJs9rBg8B5pumGL6XoK+XQ8UvM828PqFnQ3OG3Q8mXRxt+9pOlhG1fdXfNkFBh4ZNGoI0XU7oHXc06o9dh62pIB4nnwSH0sEvh7E13n8X3E/xUwK4eT532DKSX9ILQ1bNkmZ8Qlt8IWtrgulYGEMoNWVh32whireGLDxaCnF2JK+84w94+OOvDOiSbANzdngxUV9pHSEoOY1jO+JdDIahNITedG58IIuC+lGD2hyZu4owk0y9dj7R7Q9dJT0hu6yFYD0uljl1nk/DfFo6tK0zSC/2N88x9+sZr32UjafyeuAdiQ4C8+xNWacVbH7pTKSo/HG/BGfYmLxOPLhe2etlE5dBqu1IRfXM1NX1stYk6wl7ZJnMJUSHlM35fnviOzTjQG/6HbtuFllRmMB310jhxn4856Qe+w5B7WLaoW5igZhE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38350700002)(107886003)(66556008)(8676002)(66476007)(38100700002)(66946007)(4326008)(508600001)(6506007)(44832011)(83380400001)(2616005)(52116002)(26005)(186003)(86362001)(2906002)(8936002)(6512007)(36756003)(1076003)(6486002)(6916009)(316002)(6666004)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9GbEFQ2tkXPne6G3dO/WEyh8Vk5AUJlNQ7In6bGKWG/VJRdnsAsb1idNK4m?=
 =?us-ascii?Q?6ZD83auJNFZChbG3hupbP4B2255ojTGkAMuhCnKtfoG5rxibJw3954ld8JA8?=
 =?us-ascii?Q?fVzU0ecqnFQf1RSB2c6WZBMUu8wsgEZPbB/ObId/5Bm9HkF1mRIjlv3bvlDb?=
 =?us-ascii?Q?tA3hPB4eZoEySmOh9UBq9qu2dEX+NLn/LhC9VTaSF8H72fzWq0TyHWaa77Zt?=
 =?us-ascii?Q?m70UkkUXlGzYIH6y+WUCRmOyG5zt0gJAVUGt6em9loY/q8nB+VbHwyc+FrT6?=
 =?us-ascii?Q?9G8uUZIYkhrNHzDE9shtlpueZCWkjHVN0VI0AlOLiQRhrhZgzrSn0fJ6vELo?=
 =?us-ascii?Q?li+x7bcojm64DHtobjxXhjuMT2HO4YIJtpvpd6MP/sUam7t5qzmx+2/6+LBi?=
 =?us-ascii?Q?iJNrhSFVHVYJ/ZlaYDYsMwIA6gccnXD3h2WodaU+otA6Ff/GHew04n4zC0JO?=
 =?us-ascii?Q?N2w7TCH1WaBqrYJGmj3R+D9GPqdVhxAHNAyy0bKc0eOtNWNZnFt6hz25XMuB?=
 =?us-ascii?Q?YseUqbj0D65Eet2xO244qODgGdyKAGH7TixVRz2+gz+gX2FO7Nwe5NVOYBzt?=
 =?us-ascii?Q?dqEpyM6TQJ/fPNq8l5+ZZkboNtbb+kftQgCpR/Wyjq6u8TrF1KErdp5oAwiB?=
 =?us-ascii?Q?83kTcZU9EvraZrOFvVweS1zTX1MtBc6v4nxAD/nFIe3QISr1+BivwLVPQ31o?=
 =?us-ascii?Q?dl7+5Kl9GZbp9Oief8YAKMt2rxVLHu0UCe33vOjWwBrTn0dTbyaXkGxVChkl?=
 =?us-ascii?Q?SnIA+dR16m31/noiNDa+lsUZW4+CWhmhsk2ck+Zw+AcKUHba9myWhA8BoPau?=
 =?us-ascii?Q?lPdZcbkE1CMnCd0qbfumc31NwFH2boqAEeGGyBZCSpTEq97LI23mN6K0b8jZ?=
 =?us-ascii?Q?ukQHUqAflUSkHI3VYmN/+ztmYBhcuECQ1Z9RGIvm+jcNmdtxiHNXpSrbhgLn?=
 =?us-ascii?Q?u9qmkgWryvcNVEKEPp+Oe3x27MV3vyMes2zfUs5moO3pWFrxQiOxjI4TIqeO?=
 =?us-ascii?Q?LsOrabCTZ/HmS2Y4TVMftD3TYE+Dw4MbQ/+jiahVuL2pOjHt13BR9mAwd6Z0?=
 =?us-ascii?Q?gI6iXe6pkbLmuQK8qHsTbPaieXq4kp69aC63B7hsT2fUIKvlU2bCopmTk4VJ?=
 =?us-ascii?Q?WLXGV2YCgCI2XckVkDDWxjJn0SR+lnFz8doW3VD18me4tyIDDLM+3b/DOl4l?=
 =?us-ascii?Q?6vHHWJsD+vpyJtZPQwKgwbHH3IDkrZ5iQ4NF6998iJigAbRovPyf93y6ERmB?=
 =?us-ascii?Q?JeVjl/4eOxYpWZ0oCA4IUfzE274wdurAEVI0PDq8X1Ir2GIw1XCysNMnvLQp?=
 =?us-ascii?Q?2lpXd5UKJCPrmqqOTbpR274rRoYxxLnowIpOQaJ87k1OOWMQksj2ESIJ6wn/?=
 =?us-ascii?Q?HJp3RhcNnhnd+5gDjc04pDWDA/0Shyv9gBYftD/XDt5wHAE/WMtfvI2Z9lrB?=
 =?us-ascii?Q?omsZWs3CyfEOHbm3JWsNvFuNmDmCQj2eFTDo2rCw0gvgB0KuFHcin/xNGd6l?=
 =?us-ascii?Q?0NhGfgZjsFk4MkkwKavvZ7vuuYQRj7cZU8VB5bJPcEQCVM1VCI/HsTk055kB?=
 =?us-ascii?Q?88SzcSs3/APfXzXm69t+PUNvi4LeQNeGp4OScU6AVY1QOO+M33lw2liBbsWa?=
 =?us-ascii?Q?zTAS45qoXFf5wGiWkbDNzaxWHqa99RSTPZBtF/ggD9+4/NVwe/SIQQWYxKPf?=
 =?us-ascii?Q?VkSvqTDarecRLEQB3B8KmNnvCqk=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7889435-00c9-478f-0c25-08d9e12bd6b6
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:27:45.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0EQLSnETJ4JjRj2Jw0GOFkEs7VwpdkSLz9vS6FdA75Ai4QMwbWedCuKJh7rm394xXgloqb0xSEP/wqDCPWy3yEPYqMZi50ZI7tS0tQKX3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5578
X-Proofpoint-ORIG-GUID: 8vfTS92hsp7aqFTduvZffB1lzWC47Hir
X-Proofpoint-GUID: 8vfTS92hsp7aqFTduvZffB1lzWC47Hir
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated macb DT binding documentation to reflect the phy-names, phys,
resets, reset-names properties which are now used with ZynqMP GEM
devices, and added a ZynqMP-specific DT example.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../devicetree/bindings/net/cdns,macb.yaml    | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 8dd06db34169..6cd3d853dcba 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -81,6 +81,25 @@ properties:
 
   phy-handle: true
 
+  phys:
+    maxItems: 1
+
+  phy-names:
+    const: sgmii-phy
+    description:
+      Required with ZynqMP SoC when in SGMII mode.
+      Should reference PS-GTR generic PHY device for this controller
+      instance. See ZynqMP example.
+
+  resets:
+    maxItems: 1
+    description:
+      Recommended with ZynqMP, specify reset control for this
+      controller instance with zynqmp-reset driver.
+
+  reset-names:
+    maxItems: 1
+
   fixed-link: true
 
   iommus:
@@ -157,3 +176,40 @@ examples:
                     reset-gpios = <&pioE 6 1>;
             };
     };
+
+  - |
+    #include <dt-bindings/clock/xlnx-zynqmp-clk.h>
+    #include <dt-bindings/power/xlnx-zynqmp-power.h>
+    #include <dt-bindings/reset/xlnx-zynqmp-resets.h>
+    #include <dt-bindings/phy/phy.h>
+
+    bus {
+            #address-cells = <2>;
+            #size-cells = <2>;
+            gem1: ethernet@ff0c0000 {
+                    compatible = "cdns,zynqmp-gem", "cdns,gem";
+                    interrupt-parent = <&gic>;
+                    interrupts = <0 59 4>, <0 59 4>;
+                    reg = <0x0 0xff0c0000 0x0 0x1000>;
+                    clocks = <&zynqmp_clk LPD_LSBUS>, <&zynqmp_clk GEM1_REF>,
+                             <&zynqmp_clk GEM1_TX>, <&zynqmp_clk GEM1_RX>,
+                             <&zynqmp_clk GEM_TSU>;
+                    clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                    #stream-id-cells = <1>;
+                    iommus = <&smmu 0x875>;
+                    power-domains = <&zynqmp_firmware PD_ETH_1>;
+                    resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
+                    reset-names = "gem1_rst";
+                    status = "okay";
+                    phy-mode = "sgmii";
+                    phy-names = "sgmii-phy";
+                    phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
+                    fixed-link {
+                            speed = <1000>;
+                            full-duplex;
+                            pause;
+                    };
+            };
+    };
-- 
2.31.1

