Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC0D4E5DAF
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348135AbiCXDmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346350AbiCXDmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:42:15 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487D09681B;
        Wed, 23 Mar 2022 20:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiSjzG2aAWLFhTxxiOZNbWbe70lX3iiEwssq64m0kRcYHw3kGxTF7KEZ3lHSKK3PRdCo9+Asc6QmaICrWCrEdtGYuPFCdZdsQ07OH2Yd7IUzQtRHBY31JgwQFo49MVJi2kxLgk8ahYHHBq3iYOnOi84MiCVMeGkHZ2O+cw32uQDW2xz53qddj401UcBByahsdIM7Wn3F6klyvpV4HdQROOdmDOouemI+ba0SC20hdTdQa2NMsW99N0OjMyM1Xk6HeBD2IAug8KbbHzw1oFRqzDzVGuPhszqeSftZFIdOM3YrtBNt/7EpSJqrj1CtOdWXWP9uR7hsTmW2LGgzqfautw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txssf5WBWQAUvbrHdcME+qenEx8vebQQQgbVSjhS8ks=;
 b=emKHGLLqZ3tWdEU8Kq2E2wplVHVXAeWgLHr9qTtbGRQ3PFyvyvrbsyNbueDpTSb0hC5Nzpqb++45juC6W4Avnw9L/a1JaEQylHVr0HoFPJLsXMZSVuF6r4Z+ONt+CbA0D6pRfJpocPqbHkgj0N8wRDSX8LJrEOCP14qizWvMRxjs2/8YwT7c8IwM+3LR2PNGcy4oRjChIIL2ndTqWnNzLkprZKqS7xq8vJDSJ05gIthJjkMN3LIBOv7J1f8x0mfyy75Nkk0TqChecJDS0FBBODhy5fbhKho7d+3OSJOxuoKdJ/tFJLPQrHMasxu7AtAM4CiFo8/k2WDK9BsK1GVZKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txssf5WBWQAUvbrHdcME+qenEx8vebQQQgbVSjhS8ks=;
 b=IFgAKTSpcXcJM7F64sJTmc7x9n9x+zlMmJrWMxniExfr0Vrasv5CnhhFtz5NRmpLRGO0N6icJxS+yPt6IFgQ5lci/WZWR2nnj4Z77gSxBPlZegVSpAHsLfM06kcfRAZTV07Gceu8Eb+7X7B7uJR3uozg/Rv2TAVuHevvGdKjX2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBAPR04MB7223.eurprd04.prod.outlook.com (2603:10a6:10:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 03:40:38 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff%3]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 03:40:38 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     ulf.hansson@linaro.org, robh+dt@kernel.org, krzk+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, qiangqing.zhang@nxp.com
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 4/4] dt-bindings: net: imx-dwmac: introduce nvmem property
Date:   Thu, 24 Mar 2022 12:20:24 +0800
Message-Id: <20220324042024.26813-5-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324042024.26813-1-peng.fan@oss.nxp.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0172.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::28) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37063a00-d1d9-465e-3a77-08da0d480ff1
X-MS-TrafficTypeDiagnostic: DBAPR04MB7223:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB722368650DFCF0AAD8FE5D17C9199@DBAPR04MB7223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mxxd1289k4autllXNAa5xKZhSHub8AWCJB2SIDeGvAMldjiQ4RItMvvESKZXhNBkub1FljysvN1fn5uf2B0ok26o8F9sz5Peh/u41TRebN+NK1F5jkmqwspx/U/8HoPzM50NyzTdpm50S/ljJuA2yzh6ybIUdF518jshZvB1oPrggeEdyrXgpNhFcEFjiMZZFMvuwxi7xW5emFVpbHdMlMPHjfvpkSJRhU1y79YA+j1BazPhCIDtgiGhv9R4LA+L141ezNtYCC3M+xUEWh2upg7pxxCZ3BTAS2XzhmIOj3m31y99/Y2UYM64KK8xK+2s3esz5TZDPL7NSWrEmFRkTMRB0wJ+ogswtHYNEpa7FTtcYqDZWPNvc/sGnPWJT/LdukSsCzPA3XVE+r6kySgrShhj6bc7JyublsscZesXSzb+4FD+QzKt0a4Sl9lmcc9EqkRUM+YpgV96bvpVljcUUA/+cCHhNLSLJKn5dR/BwQMOzYzrBrxsviOsacq8+QeAgsLnZirxvCSqSeldMRW4pGdcSgXJblf9EFaMowV/+pN6mMNTPBpiuVMlkkiidK6CIZIsJvpiYAT+t5JksY0PsKmVG1o3RXlInieTRs7ve14uXPApNUbx8XKiw1BrZGmkFyjemZl3L47WX6xfXT9Evm/sUUfLgqy1sMATl5KpJU7hBWXqGLFJWVbZ7qG91q2uVxus8F+U5l9kZ2ocpCw9Asdl6eIZOx1WXbDjYWWOTAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(1076003)(52116002)(6506007)(6512007)(26005)(2616005)(186003)(316002)(8676002)(4326008)(66946007)(6666004)(66556008)(66476007)(921005)(38350700002)(8936002)(2906002)(7416002)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Njz5U1A5065KlSrBcGF9Uzs0N4k/uBaa2a43XT4zemnGRWbDywiBNrK1BAKG?=
 =?us-ascii?Q?718QLslPDxCx+ARrVIjZBobc1LwDNndrdZRIidU4WMff0UOYr4BrSPxtUzQX?=
 =?us-ascii?Q?BKNMYGFXjOx3iwnXD/bRg/G9d4I3CL8zLHp3+ahvVzqroO17/yEbYeol2Qbm?=
 =?us-ascii?Q?PMWawlD/FBliHbicTZug2/Tw8MP2CNIa7/o0UsoLNfUuPFHiHyXiyPQVoBg4?=
 =?us-ascii?Q?M2u6zPZ4xft42mpD5zErkkINOY8FKdhmUVnBnxGE1hVxXpDZIW7OtYT1GIq0?=
 =?us-ascii?Q?UKmlP/dFHGwnHxipNPeV0oNEkKI+t5GMPuxpycwZwtdiSGJYPUdXH5QrP7e2?=
 =?us-ascii?Q?jhhrCdImleIz4g4qoZY0+pe5iovyegTPXJt+2oC2le99AfL2wDuCmLBH/mLT?=
 =?us-ascii?Q?MAFHyNhRUawzzWGRq0xxz2kEUZl/2+mthK9IP/UkEhEegQ8te4SEpNgd/cFb?=
 =?us-ascii?Q?Ad54UQwy/sHLSL7FuS7q4dIEgso/urhsmsfk5hAfB1oEq9xx76f24GgFfEpF?=
 =?us-ascii?Q?zIfNNNtQ8zn151bOhGT3h+p5TipQ4yKpjS/zlBSs+OzwQeJOTElDgchL6iTo?=
 =?us-ascii?Q?5f26Eor3V7FKPwqlU5oQ5XtkDRrv5U7Xu6JQYg627C+eZMEC/l/K7ng5oU9s?=
 =?us-ascii?Q?gfVF4ymstjwWJmgYRolT+lKP2A6JyCRCvOYzukbyWsTC7Vo9dqXni2zlhypa?=
 =?us-ascii?Q?6gE0qFlYTGp46Yu5aW9ksdcTWTmwbohHzV+9blXYYSdHfKmfzkvkIW4mlPEF?=
 =?us-ascii?Q?aPGDcPtGxfSMdo5QSXQnkcbmZAN8r68+1EWvTcORMX1nRY6ONbGnqrN76tdA?=
 =?us-ascii?Q?V3leLhAxer7gXPk/9JIL+qZWtXH92/kDvPOzSjDcgdYnziOH7hOrC4yFKInk?=
 =?us-ascii?Q?sRMfIEHv4/lFNfaij3cdtZtmvnwhItlVINuYVkdK9oi1tscK1uzs/0lzsFkw?=
 =?us-ascii?Q?MQC3ahb7q4sedaYfFJIidYxqjCVn16LApjpKxqq7RUsmbCYUoqht7JyTVTKS?=
 =?us-ascii?Q?Tm1R7sEwYl1mFaAJSH23iBI+0nC9wYrx4DQQtRlBbE/fTIwQo+r3WreFPfli?=
 =?us-ascii?Q?8Xc3yj+yc1ZXxpt11WKzS8t+XKQvKbeCetpasBALlZrJtlyGo1nEnf2ekBNT?=
 =?us-ascii?Q?hULf/o03X6Y7WYI4fkjjktVXfGebVJ32DOOEvxsdeBPmZQDAJueTlXA9plx6?=
 =?us-ascii?Q?lXvSQdrtz41irKJf/DQQgaxZL0C2jSzneoIqtxbYhMLtr5lV5T80+sjLoTjg?=
 =?us-ascii?Q?CXsAMMb9strGvlsVF044MT+IIE6LWH+xuNYxMujY6G0HLceCDOss3zT31ect?=
 =?us-ascii?Q?bSweqQGuwDAHVC0GqTDS9E5YnptWEmqgLVUKQ5XwDkPyMPSBFvKCNM9EtJ6k?=
 =?us-ascii?Q?ov9R7Z5L/6y8jKU2dsD+7eqfTtl+qY2vWy4ubZtTD2e+Wf/4T2B4ZitWio66?=
 =?us-ascii?Q?g6hmchD7nOX3vTj5qNHJz+tMnXJ6sd/zIi/ICc95V3RcfyaKRnqN3yMNWEwp?=
 =?us-ascii?Q?4bCV5dbJsrwwHRW7dCVw7GnukPKi5rIvNS1bsvw+/bYZBnHXAC3s1O1HoJcw?=
 =?us-ascii?Q?0VqMLqHFJiL8Ssj995NgzseF1H5WGIWuJEaSNubXcYjNS5pwi9niZ0hXuptL?=
 =?us-ascii?Q?++ttvzeXkvLl6WC6ZZ2pKk3gLR9jB/4DPAExOt+ZEGCSRvK42QFkxuOjcmgZ?=
 =?us-ascii?Q?BdnZwVRZsBv5nPvESnTVblyqww8M4U87FyLl/Q2VpC5eEj157E+gsDy0EcM1?=
 =?us-ascii?Q?AP3WOloALQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37063a00-d1d9-465e-3a77-08da0d480ff1
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 03:40:38.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9J3QwtTFYlv+bwwrjbPCfs6bDOIIgZSAOX0C4A3GbQdEyi2qk0MwX9djrh8yU1EFardnGNBpNKl4DkI7+06dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7223
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

To i.MX8M Family variants, dwmac maybe fused out. Bootloader could use
this property to read out the fuse value and mark the node status
at runtime.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 011363166789..911e510d14c6 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -62,6 +62,15 @@ properties:
       Should be phandle/offset pair. The phandle to the syscon node which
       encompases the GPR register, and the offset of the GPR register.
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that indicate whether this IP is fused or not.
+
+  nvmem-cell-names:
+    items:
+      - const: fused
+
   snps,rmii_refclk_ext:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
-- 
2.35.1

