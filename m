Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C927748CABF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356112AbiALSNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:13:24 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:23755 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356096AbiALSNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:13:09 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGTfGU011851;
        Wed, 12 Jan 2022 13:12:57 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g20s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:12:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwtS2MBZajQHN/xyDMDoAWNYhwd5nZP1LWnjeinod9FcWI87LZMq5U+NvPPmNbxlXdvWDb9mGcL//FwnysQtj+oOoQHBIX/pBkSHwm9ntlo5cDfO642Jq3g1Zw1oGGh9yu1TDy9xGrp9VYSaG4QFALBnn2ho6iWZrp1h0zL2MXXJrXcV8mlEn0iLwXh78WPQsCJj3GRUYICAO37541Q6s9EUjEKGVap7tRoF7QNVpxiboBVC5zIoORf3aB5ZXv/+RTbDUXuyFvXb7x/P1k9qCOHnQ5eHpDHStUU99rLLugd++jH9xQeoSnr07p/9oS6yXtZj2t9unhbwr2e/D5JLeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuEthdUlRQIB9bEXTOR2G0wPnncECoBzlJhvByVWU5E=;
 b=YCtwCc8sy+2ZDf1OqJksyv+pwp4jBnwyuRDajzv7GMJRuylUuDXHpGgzxDHzMZ8YtC+Tb4EWEIY3R7BIFNtjvzdCR1Lp9m6vWOLXT48KW/l2AAtm/bJkEKyLfNiThBn963+L+Zq5dY3eZ0NerqBHThHruQIQGYkwt0H3zYyuUDgtf5bR5ey6b6JdYu2lIJc70quJdzJV61lw8XZKCP/2pLjHQhFw6x9DBDBUYmbmVF0ASpCoSfMAfcYJr2ofXpR5uGC6l92y9pxLjC2SzoKVgBZqXZQAvk8mhZfUkNi/8NG+eZP4O3RYu5CI4E4nPGnQP+SS7CZBLsxye94qeLCBUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuEthdUlRQIB9bEXTOR2G0wPnncECoBzlJhvByVWU5E=;
 b=jj9Kf2KFkxUD8/GhozAQtc8vwuivNpl+EjJKGkJ3Exi6bUtk2kMwGH9E7NhkCeBJnfC3F2+q0w0/bGcvrCiAMzAyDhP3xTEwuACbUIlJHyQwSwR2qM9NY7CjzW1MUC9w5XekNNHb+LJaozo1ia5BPh9maQhlcX6Eit4kDT02EIY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 18:12:56 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:12:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and reset mappings for ZynqMP
Date:   Wed, 12 Jan 2022 12:11:11 -0600
Message-Id: <20220112181113.875567-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112181113.875567-1-robert.hancock@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:104:1::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7363a039-8fe2-40b8-f317-08d9d5f7283b
X-MS-TrafficTypeDiagnostic: YT1PR01MB3516:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB3516DB82A54201F4693FD36CEC529@YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rD6nd6SVF+bhcpvSb8G2wCKF0QpFaUHvEwOVs7FpjMkRsnrMBBdn0HDOGIYa9ye8zvSIhgXW0hhbL/5myFYScFiR3LhWIXo5ZQAoNC9lPwpMOOpsoWId0d8bevnMFHOA+fCfnaxP8Z9jwjjjejVNpEdVQxrbjHkKqt7dnx2lxP1mEOV8E/+BQj0N9TbRG2hQSXfRdJ4AB8xHe85AhjPUF2YTts3rr3n9K3m6zOtLM09ntmbVA6T5Jrr0PTlWammfPah522WZ11jqfLY5lTQ0YAaDoF8iz9E6WOQblk7acYDq56r7comLOMXQM+uSSYowmVoERQb22/eLRq/YlzfqQvNix7Fj5FidMdjitFJThwFQveTUZ5zQO5Qa2h7bF1x8IfJDE0X5CoFrhBxFFD4C95fSA1pRYns33Ip2MzBWFTbcOCxT4XEVx2RTMgrqGlXkhjZzZy3ZHeoA7q2L8KRx5RvhbBGgvLRt5R8ixR9Yrglvy6S8fVMdszkPEcHjyIb5jLaOkYIRGzZrLsxlOHutrmOkFP8ljIYUM6gQtgpRTVXu2DNNOq3PDaRqj6kq0TbGi3Wzv19WWCCKOPHnqTdazl6NXgp9Pjwo5LHS02HUBDeAg2Rr6+fqqgrkO/yU78CcNYFrkf6QWqgQpKHa4nY1FY335z/rORimvuK00bdJuCJz8SC130LLxEX7nhrshEpwWhVQCYOEYUq/zUBFhImfAhwTKt07bGsugw3E1Dh1gjI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(186003)(8936002)(38350700002)(6512007)(38100700002)(8676002)(66946007)(4326008)(2906002)(2616005)(107886003)(26005)(6916009)(83380400001)(508600001)(1076003)(86362001)(5660300002)(66556008)(66476007)(52116002)(36756003)(6506007)(6486002)(316002)(6666004)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P3S+rpRxqlYPbX8zrA4T7wAKpL6xRKoL8JDWPi1sU8OuyZ1O4VIaQ58lnFCF?=
 =?us-ascii?Q?tUlDPU+skE3vQJSra5w9uY/67DcTdj2gqWt7vRKGGNFKrCpJNbOXWAvoNyO8?=
 =?us-ascii?Q?iMJJ50Y7S8mCkN3X+IgJbckdcgD+0bTVJP8dK0GHOqn4PvXMIxsT9gO6Xs99?=
 =?us-ascii?Q?tavL1aVAmVQ3zJq4RGbv1lo/61/tLWJTU3rpVqFAy3xyqoTelHb3OdHidA56?=
 =?us-ascii?Q?pzQIWBVDSvXZ9f8LO6fxV/4pQ1rRY2tWBLtOncOhX7cKWAf2TVeR6FmhOvwD?=
 =?us-ascii?Q?x7gygPBcIzRw/troX5JKY7Bi9wHKEy4MpRb+du8mjfpPoWLM+yWEKgDoCwqG?=
 =?us-ascii?Q?VzpmMr+iorkVv0lEZVbntFYsbcwhgz/q64S1oTzPPo1M1WKyp2BWbI7cdJTf?=
 =?us-ascii?Q?glPZjrxcTLTij2w/f8GgQWcC5LSztm7JNKd3JRbUPvylQlUDaVQMEIrLNWu4?=
 =?us-ascii?Q?on+nviuFlZH8H04ixIMSyLSPhtwrW4LfDL0v4l6lSHYaf6bDGEBxu7PDg5G5?=
 =?us-ascii?Q?OK/J0+R6TN2RXO/K1OG2HsmmB8vxO+GSMR3R8e4MhQoJNe7zI01lMMhXnDXo?=
 =?us-ascii?Q?M8oSm/bcvk4l8lilXYkvQNgcuOkl8I/pwBx5q063QanAVBz7k4m1a12ugSeG?=
 =?us-ascii?Q?9bMVD9E8wbBoJE7k4m4WByjUN6wPSZAY055wgNWLutNQYDXuf7sZyeIINkFE?=
 =?us-ascii?Q?YyPaGmFKTDZ6B75Q/slf6Qf6ol6wnhE26QKdaebNv1ZTYyH/9gXsCdwmeOS2?=
 =?us-ascii?Q?ZCKBSwHhNrsA0svhNju8HO5UvrkfkpxlFTaV6E0Ijlvui2ovQPsLrs5LRevb?=
 =?us-ascii?Q?wJv9VlSsdhawQny4e+UHbLnylYCc4T+OvatzCopEQLrBqDgPhejVNYMUiOOn?=
 =?us-ascii?Q?Tg/vjvqWF2PkIWxNfhpk08/GMnaIN+9S1ofGMP6hU8P/wU03GvzkyHzfV6l0?=
 =?us-ascii?Q?Q8cU2ZkHoqGaIH326n5iNoiqxr3y9LLpjjfmDZwZU5rA8o++ZYFdeXb4eFac?=
 =?us-ascii?Q?5IH/symnBO71obtQdGrJKAbwhPLSSIAADOBCwPmUrHRU08iKDBGDNLgXn5qI?=
 =?us-ascii?Q?O2UFDZliFFgV/HwHUNnSo05ONXBSxqnFhSDrMDmfhci2wLPKrgF6NZ1cojQE?=
 =?us-ascii?Q?OP2WZcKMfVnuMK7Jiig78xVtu9U2sZ4mjfD8cq9V0mw5ohC7kLNMe4YOAC4n?=
 =?us-ascii?Q?5nNaMydGYFj7uYGi0xlt6ab++nRXthUJmnCWl1sv1CiFkPPww04KfOi8FpCM?=
 =?us-ascii?Q?GZ1VLxGKimgzYU5bWVySOYMrh5EKVegklbtTT2AUZqns7mtDB2poLMK2Zk7v?=
 =?us-ascii?Q?e1dSWwlj3/qh3Crd0DonsZDnwkhaRkcCn0KJ/Lz0tliD+tWdN2axfIOZy6ay?=
 =?us-ascii?Q?IWLrh65p2E+isBjARd+4kA9YmthB1/70vbTQpkg2Nq9y2dQ9vZ6TaDTMxwRg?=
 =?us-ascii?Q?fVBNvPouPqGTyZC62SBsUcIMEXLMKnRxg7rMrDyoXz/Pi59LBwMp97hZf9jU?=
 =?us-ascii?Q?Ozo6Jtwy+2HQpI2dFm6XPKVDHOZlYK4sEw7BhNQC3EkEB9Qzi6x9bEnftWQj?=
 =?us-ascii?Q?7Z9l7Xs37Ff9K8lOq5CtqbXGLCNKPWqu5DSPm1fI3TR0zLE35tgZttVYpRWn?=
 =?us-ascii?Q?FvhaeBpWgy6+QLVufUkZew2Vqad/wCJKJekxBzz7CKOQ1oTRpCmqtMm+QCdd?=
 =?us-ascii?Q?0rAAP0c1P9LHtAOzMxK32U3BVf4=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7363a039-8fe2-40b8-f317-08d9d5f7283b
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:12:55.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPy+o9/ApJgi+5HL2z0SB68qnv7kO36edwrZMDUaMi6NxFcJ1dE1zTtMjwiJzdHN5l8R1ad6v+9yMvx0y7WfxYKbF7JdwjMhb90mkgVeLsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3516
X-Proofpoint-GUID: wwKaYt2rJhgk-bF3Iw9_TNKsiqrVuqOE
X-Proofpoint-ORIG-GUID: wwKaYt2rJhgk-bF3Iw9_TNKsiqrVuqOE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated macb DT binding documentation to reflect the phy-names, phys,
resets, reset-names properties which are now used with ZynqMP GEM
devices, and added a ZynqMP-specific DT example.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../devicetree/bindings/net/macb.txt          | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index a1b06fd1962e..e526952145b8 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -29,6 +29,12 @@ Required properties:
 	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
+- phy_names, phys: Required with ZynqMP SoC when in SGMII mode.
+                   phy_names should be "sgmii-phy" and phys should
+                   reference PS-GTR generic PHY device for this controller
+                   instance. See ZynqMP example below.
+- resets, reset-names: Recommended with ZynqMP, specify reset control for this
+		       controller instance with zynqmp-reset driver.
 
 Optional properties:
 - mdio: node containing PHY children. If this node is not present, then PHYs
@@ -58,3 +64,30 @@ Examples:
 			reset-gpios = <&pioE 6 1>;
 		};
 	};
+
+	gem1: ethernet@ff0c0000 {
+		compatible = "cdns,zynqmp-gem", "cdns,gem";
+		interrupt-parent = <&gic>;
+		interrupts = <0 59 4>, <0 59 4>;
+		reg = <0x0 0xff0c0000 0x0 0x1000>;
+		clocks = <&zynqmp_clk LPD_LSBUS>, <&zynqmp_clk GEM1_REF>,
+			 <&zynqmp_clk GEM1_TX>, <&zynqmp_clk GEM1_RX>,
+			 <&zynqmp_clk GEM_TSU>;
+		clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		#stream-id-cells = <1>;
+		iommus = <&smmu 0x875>;
+		power-domains = <&zynqmp_firmware PD_ETH_1>;
+		resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
+		reset-names = "gem1_rst";
+		status = "okay";
+		phy-mode = "sgmii";
+		phy-names = "sgmii-phy";
+		phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
+		fixed-link {
+			speed = <1000>;
+			full-duplex;
+			pause;
+		};
+	};
-- 
2.31.1

