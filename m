Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407F859966B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347220AbiHSHrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347212AbiHSHrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:47:46 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB53D75A0;
        Fri, 19 Aug 2022 00:47:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUXLkwEW2jTZTU9wXjHney2C+TAvDxU33FckRlBBIDovbZkC1zlocKGKu7bW0BYmRKA9u1sbmHSRNRLqOMRE33shbMdvpobPDNz8kI6hfp6KdTJDGCQXKWnYX8aKwXOWp8KkcuFgIGwasfgxxmnKGUXbjYFyrKczDNNMsok/DdD2EAg6Yp62VMKH6ILXo0B0lgyABKIYG6rPbF/d3ivamqNb1xNNtFvx96WXuI6eIQ+lNIUD3ChV+xMiCT02cE+YzM3julP/WJuSvv4gRAVwiYjX64195wkkIHcIFhFy050j5uHoUCxoxFkxTkzOpsEAgZuptD4nS3bWGGU0SiduxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27LUs87wSzc/M55s9vml2okbnUuf2hV9xrAjyl8g8d0=;
 b=d9sMA+laYSy2AkPRrJVP6BIBJ0hUO+M0CuM+ac6sWn8roF1Z1zahLeSUGOyy6XMxRjDW8zK5EfpAVzS57fW2e0f7ZnvzH/vNqhKPXpkDO2duiczpMqSoWdMUsz4F+WiUOS5ZWFz2SkSJaYPDx9ZZwOpsGwi0rD6ee00BNe8rGk6D71Nyj75horhBVGptbdLrQVS1XIttb5K+/fuzR/3lBZBxWkBBsPsEyWI6feyMCdIWojiQZjJbhNwaFz79EsADJJ2EeXEmkBRc4wvNlAD3Auf5GAzqoqxca/rOU3/7iUJmsit9jt0BvTZFgOthjtfYxKk0xqc0ti4u5j8FpIXkcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27LUs87wSzc/M55s9vml2okbnUuf2hV9xrAjyl8g8d0=;
 b=K57OFRYuKf+lcj9KBmFThT86PJ2UxNdLvPYAaNiEBURa1a3RxVcCa5uydspG6ypW3/yaZNn9XaGpWEw3W5aFJYcwz/Q7s9HRKO/PdtAdHoJ/0YlCf9SnzsBKjC+EPvXojeBel9eaGi4RBzNam+4mUb+jPQ+dOkbFb+Fa7eihaA0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB7199.eurprd04.prod.outlook.com (2603:10a6:800:11d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 07:47:43 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 07:47:43 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] dt-bindings: net: tja11xx: add nxp,refclk_in property
Date:   Fri, 19 Aug 2022 15:47:27 +0800
Message-Id: <20220819074729.1496088-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819074729.1496088-1-wei.fang@nxp.com>
References: <20220819074729.1496088-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0122.apcprd03.prod.outlook.com
 (2603:1096:4:91::26) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec6961f1-3478-477b-ac13-08da81b71972
X-MS-TrafficTypeDiagnostic: VI1PR04MB7199:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 212qt7JGSdx395G4llH70eIRaXtsM5FXCWFyeVHKtZnlJiTMe31j4+iiXtJbslrun2oa+fetPB02z4D0e5DOcF/dsXDTo0w5TCYR+5p97bfhSefJWfI4ACvtbG4ljDvCrGoWjerlI/RryLFlZytXzZGLgs5c2GaZspvG2UdCPjunHtP1kF7GSYiL9tjjvh0sPilKIjb65ybkQIRsqU52njX2XAifrtc9B+EnqxziO2TWd7MCZErvKBplfOD2nyawKt1DLwv1fsOjPhAyfIKYlBUdw/xS1UnQg9rPJOs9ql5fyvsKgH8VGUm1jUdP/E/m7IkxTkC7wVk2B2vocIBrGabKuG2J8/J8xf/wY4I2gqZHDj8DzWuFy+tWQicHiCeuyBhoaGGVbmgThbVr8y4E2utGEjFmglmD1fAmklxlZh7XOeR3M9VnlENY2l+A61cPOCdRgHGaMmityX1PKuVjLs9FU9N9OTcWSH3kdTJETZC+ENKuAi/oMhdkmZkldwMchFsNeUxDtopmJrKQ57q3GPIJy+hVyVtp1HqwDewgAwW/M6XWRYfm7nzFpW1D1lgI0yuLt1vqGjtLzMaRtsDSqtsfscjKAkifJJE+kW8b2Tno2V6VpiPjv/imHMDozaS65sAVJgWF96ZtgqZCfwr1tU++l+ce3WAnMDf/ADapJI5nrvoUV4D+hSHZ41KeW19A7fsfeXqRj4BUxUsPqtXxSvSrPYridCIxfna95ve2siEuc/05/N93LxTkHs6JyM4I0QzjJKcdMDk0bSoneVzF/nDtc7ZTNWWupbJV04sqO4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(9686003)(6512007)(26005)(6506007)(86362001)(52116002)(921005)(6486002)(478600001)(2906002)(7416002)(6666004)(41300700001)(4326008)(83380400001)(186003)(1076003)(2616005)(38100700002)(5660300002)(38350700002)(8936002)(36756003)(8676002)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6AWOr1+CfKUI0px+UWc1ybG6lPpjrNpscbVjuluBVYvFeZ+a6LVxEFNhnDQ?=
 =?us-ascii?Q?jXlnGFD7cc/k8s3S0vTiLOdcwx9htlN7JpWbsLPpN3W8q+zVTsso2AlPHdld?=
 =?us-ascii?Q?ILSUZaxWVYPAOx2ST6CI3g7Qk/meqT43n15WfGSbyXivBqVTCbPwNGrB1TOw?=
 =?us-ascii?Q?gAEEVLzXThOEHlVNPhtvi/6Dbsowh/JRSyzUZRAZ/7qaYrUc4BbOZKYQcbFL?=
 =?us-ascii?Q?5QZbwm+dlcg0ClisTp20OGfTkioOlKifIJskn+12qKy1C8I/EbeZEx1hRnNI?=
 =?us-ascii?Q?K0LivFWd8FjxFKxQIjdpbEXWG6jNA0nzVAe1vFLX5nl66kCviPDoG0T50p2F?=
 =?us-ascii?Q?1OmTxIwDC+R2DZ6slDQ3b2ib/tOAl2zFmreafktaeSc/sa2m20uvma+yPT5i?=
 =?us-ascii?Q?2wysGHvz8Ydy/wmJXAub9mizXUeUJPJMhxcmPx2mBFk+/4RbxojuP5CkVbcj?=
 =?us-ascii?Q?KZ3YG+cvffdvcpOlucwwvtR6wfRF6si6MszskobLOboPEMdiuyLr5vZemG3v?=
 =?us-ascii?Q?ZZ6xt1lY4MjZ42OLudre1NG030O183KX2b7pOzVeywbr+1gtRO4ZM0Ll8s8U?=
 =?us-ascii?Q?KPTZW8qzRNgGMgawZUp8xvXN06nGa4XSq+P0XXXBm3Hpw7mnsEfKvt97cs11?=
 =?us-ascii?Q?MQHUYoIbCmiicOYUv85sfVRuo41Krl5Za+pTxdprDUpSU8wzbIEjIn4f9NP9?=
 =?us-ascii?Q?AHQYPj3iNbKyqcu6ljfKjfYxIq3AoQG9AkQBV/hzedLi5ko0IKz7pf1VSPij?=
 =?us-ascii?Q?4Sv+6pvYJDUwsOFLUsSmTLg0NTq83fVtoHGlxt/sev4Bo564WFdMvg9xAMZd?=
 =?us-ascii?Q?NYUJ/S7+TbAdAGBNyj9bSmawz2gmBTNTKTbRBl+71h+D3mZeN4+y4aYGtvXk?=
 =?us-ascii?Q?4lslWJNihVHLOyTah2tqcT4IrQEXJqjGf7ov53htbL3rAi5CMO5ENT0SG2dE?=
 =?us-ascii?Q?YiqQxNkgt4cInnBnLC3bWyGOa/uYmMlP3VoLN0lUQEwkxx02iuE4xVUXfH+r?=
 =?us-ascii?Q?DhvK+G5ySbyXQ7lc6EY4buZVLS8OiS2UGfG9oB+T/RLuAMtcujEv2YDacSim?=
 =?us-ascii?Q?bqiWrHEiXfJVWwf284rfB/NSTJnZDLcDoYFap3xph+TxXoYXJd2mUxDMEglj?=
 =?us-ascii?Q?PqLTVf6ToSGNYi0PIncsjRVaqHRGFCJPTotycMoCYJhi9AiXtehF1sUPbCfe?=
 =?us-ascii?Q?jHicnbZcSxbkCmb+ZUVdNixdBz9pGUYUGGFxaKyz9ckVeOHSx65rOAtV0mHb?=
 =?us-ascii?Q?FYZPR8vNPxIERp5B+b9zSZlolhBAtMq4+YVC5q95J6qZkILNmgNKktk9BeOk?=
 =?us-ascii?Q?3IBPb96J8UiW05XGcIkS8eVjBHoKu7uLGB0cEJdeyZB1NF5kiYX+kOCSMHTc?=
 =?us-ascii?Q?Y5nVG47qdGwFBOE1vIhLRw0CUT+M68VXsfkR1nS93p40uHo3SxQ2t22zlhLP?=
 =?us-ascii?Q?BrxaBKETE92CILEl0EEOWpIcQfCUAt/kJTWEcEYWF79imoogEml8Co0/tMpS?=
 =?us-ascii?Q?jZFIWaF2IY4LILQK4UUJjy1bglXM32rBDe6GGhnkdIg+2Cw3QzT1unCTxLTh?=
 =?us-ascii?Q?EWeSTYdNs9qiYrsILdngeXrZVeAEEFFc/JD1P5eQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6961f1-3478-477b-ac13-08da81b71972
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 07:47:43.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2HwqCVIg1aNdzxkY+dZdOHSjE8hMtJOeiBUDxu9ezBcVoOEmYybwlKFSMiZIK3NdCWjVMV7CgMb5JedoOmUNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

TJA110x REF_CLK can be configured as interface reference clock
intput or output when the RMII mode enabled. This patch add the
property to make the REF_CLK can be configurable.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 .../devicetree/bindings/net/nxp,tja11xx.yaml    | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
index d51da24f3505..c51ee52033e8 100644
--- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
@@ -31,6 +31,22 @@ patternProperties:
         description:
           The ID number for the child PHY. Should be +1 of parent PHY.
 
+      nxp,rmii_refclk_in:
+        type: boolean
+        description: |
+          The REF_CLK is provided for both transmitted and receivced data
+          in RMII mode. This clock signal is provided by the PHY and is
+          typically derived from an external 25MHz crystal. Alternatively,
+          a 50MHz clock signal generated by an external oscillator can be
+          connected to pin REF_CLK. A third option is to connect a 25MHz
+          clock to pin CLK_IN_OUT. So, the REF_CLK should be configured
+          as input or output according to the actual circuit connection.
+          If present, indicates that the REF_CLK will be configured as
+          interface reference clock input when RMII mode enabled.
+          If not present, the REF_CLK will be configured as interface
+          reference clock output when RMII mode enabled.
+          Only supported on TJA1100 and TJA1101.
+
     required:
       - reg
 
@@ -44,6 +60,7 @@ examples:
 
         tja1101_phy0: ethernet-phy@4 {
             reg = <0x4>;
+            nxp,rmii_refclk_in;
         };
     };
   - |
-- 
2.25.1

