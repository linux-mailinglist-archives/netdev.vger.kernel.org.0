Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A2C4E5DAB
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348014AbiCXDmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348018AbiCXDl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:41:58 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE4095A19;
        Wed, 23 Mar 2022 20:40:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKqFFaAAuBGfXVHwHuK13RT/ezyx2vNF2wqxVCuMS392NCSUBrn2x8ngpWJvof7E7/vAAb81T0U5JTVVjfp0U48WHLvYaNCfL6M6kuJbcdEL2slamKRJibOSzexc9Szs7Z4QttlYEZZpXamwrHQByggcQJxfnxlvPBgEb0f6sIeRpODdMPXMym4uYr1OJ0kG9b0jhuKQVF0dy0YI2L5xAnakYy9qqjQKHkwjEwXqp/+ISWbUitwEpvYzOfk+32VQDp4MVYvaSERytZESJa2mQUj3QE9SIQM4rG1V5TKQKnnNl7hOVAffLndIRT9AOJ3r6+Fe8pm5y0JfYrU1o4AT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qA1H6p5SilyU3ejwgRRkxmL9TN8F6SPRsr56LVXuiyM=;
 b=W5uJx7rAOMz6FdREYHJcA/95oteuvoJSbPq7uXTfFc3XbPKIHOkLtoTLuGfRIU+hTnwX8QmSDPYhn8S4NIOBGjvt9b/VJrbuPFfa/LJ0A2eyIKKSLkgoMZDS2L4z54wHdxcDd4kJzpMp+6T2MZn/m5mL35tAR6rfgGrvYyxZglPaPj6p/mx9hYS7G8l+jJmwT508z9vpxopT/HlQpIQL1ZLZ0Ijj1c8xvqyzjwMLp2nj+kyGRRBUQPBzO/v6x2EqbhICUMwN5JF+tD1gjqh6TqI2cy5eypn/PxoT+KBpRsoZoJ8HLuIiWdHF2fPrSUra2nL/u0KmHJzxcXsT8jr8HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qA1H6p5SilyU3ejwgRRkxmL9TN8F6SPRsr56LVXuiyM=;
 b=mtiJ6NPpg7M/VpeBUrTXejq69/I4LxqkUPh3/GJWM0RNtec/TL3p6RnIsjiqYaswcZGDXf5wRYJsqs0GEvh7HxhreDOUaNiNBm89OesTYw+uWTrS9zmPUQql+mAVJNPBRLmInHuini6sOyNekGR92DjvEDUg65MKy1uqsha3XNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBAPR04MB7223.eurprd04.prod.outlook.com (2603:10a6:10:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 03:40:19 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff%3]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 03:40:19 +0000
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
Subject: [PATCH 1/4] dt-bindings: can: fsl,flexcan: introduce nvmem property
Date:   Thu, 24 Mar 2022 12:20:21 +0800
Message-Id: <20220324042024.26813-2-peng.fan@oss.nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e7fc779-1cf0-4a3f-f508-08da0d48049e
X-MS-TrafficTypeDiagnostic: DBAPR04MB7223:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7223EE40118ADA17E03DD70EC9199@DBAPR04MB7223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1iODdnEoqgbSKkR7tu9C6Yw7osJ9nGHRaKMKWJAJv/Otl1K5Sa3fspvPmrJ0tYrmWzSRnecbEfLi52ILEo7KJYCoQKVpNqkd1HuT5fOqpDUcakDS/b4A84REUuy1nbBAgpzorSOh8fBPD6tfn3PXX9kBRh1auHnM4r8aK3QLo2433ZDTb2CGRSWYLZ1fxWcrmHY2wm1fARbNv/aqQCfuqHv86IA3LnwqK56ltNKO4FnJixQ1Tn6YjCBKaK/Xq2kaPFxCymxJovEFKGexI7KlmFeza9S7LBXrrwM28QlX48XJlRJa3EfIzj2gT8vXV+Vt0wraZ3yE7EmzPMhhlFnIPi0+/kKba2Zjx3m5DCoA/UK6IzkjMvHkWC6f9OfL6GEs1ndRYpgxLa/fCHNucxcLKCvYNU+ihMPT300uaVtNp27/aQ5l8itJ6TsIqKg1ty8YCTEQrxMOeAEgouq51Xi5qV09tOhFncbQS2js5N0GwYP/36iYPX9OPzGEGfjc5kZ+gUIMQO5P2+2FBk/rEXl/CFEL8XEA/qYs3Q64v1bKLMcHF0gtMr5q6eoTs88YRmZA4a02UPBdZuKNMATtBX5O6t8Wcl3ruHCXSO76YFmeGBjm32szk5UaGFTHhBWC1su+X55K2twa34vJELmg6n1WnUx5tPyBAP5pja+961x33MaDH/m9me1CvRiFh5MZ1pdsYlAmEtpgc4BK3BqYjAHgyc8TgKIH0YMa0MRoaoXKv2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(1076003)(52116002)(6506007)(6512007)(26005)(2616005)(186003)(316002)(8676002)(4326008)(66946007)(6666004)(66556008)(66476007)(921005)(38350700002)(8936002)(2906002)(7416002)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQGBbRXXb6cEBJ8N9e/Wc3UHUAEBfDKrqWk3rDeIvbyv/swrEAWyh1lGNFX+?=
 =?us-ascii?Q?7Xf3TsnSdJ5LvKkEmtqJdpHtNKuBR0ZPqQcenD66wiQGkVr4QRMjngUqCGVt?=
 =?us-ascii?Q?9WUk5Lrq4bPvbdegnBBtEaZiRowQKtayi3fM2Z93k9/8x6Alo29HRyoSi8EZ?=
 =?us-ascii?Q?R1YFC8fGJJrPXgOtMvYYgsy2qsUfo0QewawsSoUPPNHXtptEBNxeDaqKT3oL?=
 =?us-ascii?Q?tqjkgexcMPxCDACWbw6ki5AdjowuJhgR34B8al3d4DiojGaW5+nOW1TO62e0?=
 =?us-ascii?Q?XEr2W8Yrir7R6fAr3L/C8Sy97xux1fc+jxrqNFo8VBlbcH2ldSA7UENL5jCo?=
 =?us-ascii?Q?ZDdU7oiKqItcizNuFLFn4ei0pJkxPZDPNWK8wqgbCUkq2DkEmUiGnBm6XNdi?=
 =?us-ascii?Q?/6gCI95/EJiRmB+w3D1st74vCvn0P5VFgeG5LsTUyGafdA4VE9hwwsqgUAjm?=
 =?us-ascii?Q?xOfo5ZKdHhHZeX2h7DudBGOm2AN2Sc+VnzQh9AMF2EAqJv11PXYh5LclaL8U?=
 =?us-ascii?Q?85gX+JFmoB2wxtreHJ5qhR0uRoS4xHuPAOP2REDB0oLpfUWoau1e9nq0pQ7J?=
 =?us-ascii?Q?lfBEH/o8h3HVbEKp85mv0dPKsBR3rJqfCqiSs2ue9O9TOng/FWEJGfoyr+jo?=
 =?us-ascii?Q?CpCCm/2Ra53HxsSL1rmLp5Ed6twABgrjYRshJl0SOSKTdIA7dqNI8qz/aXI4?=
 =?us-ascii?Q?LESMvzWcUDfFjz1ThJ03FuuxRTxswuwKus7jqKQiYpK6tRXll34jFbqLEwsb?=
 =?us-ascii?Q?cXm9aQwTdbGGhDw88hQ+zESDQGAY4oRa5GNCb2edpvKy5y3xFc3dVQEeA+XV?=
 =?us-ascii?Q?XWpSdgT/h8t7oEZejz6MoDnXchLcw5TEBN5mbDqPn/aefv34YXwr9ELVdzh4?=
 =?us-ascii?Q?Y4i2V6Mn21m5d4h6JQnpBX7bopeqHT5pIZGNSz1t9Nazq5LVDlGrQFLprfl7?=
 =?us-ascii?Q?n6Ykpull9sYavpBoGDDYWuMqmu2bgd7bVFII/b3lrexBOK+AfFwQYFJQz7oE?=
 =?us-ascii?Q?uU/2zGzxklmXKVjegFmTkChs/IPfFIHhORoXWMqNMLD7CkBbHee44WWkbM9G?=
 =?us-ascii?Q?ORcVqElf/Tl49yxyDhKqaKbgW/wRhTgs0dVaBhDRoXuzX0gAZ+SpHXlqpBkp?=
 =?us-ascii?Q?j+yKOyz4sLsdi/ppipjOLWrILbm+gWCBzqfDEGpyr5i1mIIgu4xwn3BGxBLt?=
 =?us-ascii?Q?98mXeuhNdu+YexWT3VOBiNSLNnGTvgcCWqKvH/lsx+o2De5FOPohkopNSc74?=
 =?us-ascii?Q?yLnd7EAofCXVzT3llkb1r68m6IiVtSdeYuKqjbht+IuiJJ7DTBG27Thktvmg?=
 =?us-ascii?Q?tScYUAmCu6TOLnRhcn/Tpf5eIURLvWq7SG7Oaw4+UM8QNSEAhFfOMTHWI62N?=
 =?us-ascii?Q?61eWZPwK9N6vvtlkxsoUiAlCblnEsVLC4bjpPSd4uRSjzZ390bdqS/ZDKiUs?=
 =?us-ascii?Q?MUEVlnNTDhFxxBdnRcRmQ+5eEU6xtxfWoCGBIqjLmsq6RHQGdvXEvU6Ji3Ze?=
 =?us-ascii?Q?X3rVGYNoEudBM6Ii1GLE4xk1qPLPRHnMCgofCaeP9EqZFGRoevLwDUR3yKJ5?=
 =?us-ascii?Q?hCzBvuaxKLxl+ITbBYBCVSvVkenhK3gjwP7Qx9U/mQN+u6rteEvENI1d9PAz?=
 =?us-ascii?Q?6WcDZKlwJEX/i+l1K92rz+7Lfkesf+TLRU6CUXOEtkv/xYBBwZ3cI7JY1mqk?=
 =?us-ascii?Q?o6tZotFbKZl03X0qMKo4Oaw2cg9fJ9INPOY0L/RbVxylbzFi2QpH6uBTFCiA?=
 =?us-ascii?Q?YS6FJOvtFw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7fc779-1cf0-4a3f-f508-08da0d48049e
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 03:40:19.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+vyiiZVgru7YCqgCIDUV1LPlUWocTtzbIxE6+BtAlk8Su+h6Qe3U4OQaMFXEhhRfryUxsqvXCCqVIW3DsHSuQ==
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

To i.MX8MP variants, flexcan maybe fused out. Bootloader could use
this property to read out the fuse value and mark the node status
at runtime.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 .../devicetree/bindings/net/can/fsl,flexcan.yaml         | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index e52db841bb8c..0f553fdf8cb2 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -73,6 +73,15 @@ properties:
       node then controller is assumed to be little endian. If this property is
       present then controller is assumed to be big endian.
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that indicate whether this IP is fused or not.
+
+  nvmem-cell-names:
+    items:
+      - const: fused
+
   fsl,stop-mode:
     description: |
       Register bits of stop mode control.
-- 
2.35.1

