Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933E156D2BA
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGKBtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiGKBtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:49:45 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE8B175B9;
        Sun, 10 Jul 2022 18:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7zAsvtj3w5F//UNH2fR6y22HEpHTRGdC6tzVigyT9ibEt1LD+8crhHEx9TwhWnbGT9l5w8WqZ9CCQ0WluU4jjGTxhRMaSp+TnUOxWzVAKX1vPTe2HKsY5rUkSDu6yVf/0Rvx9LwmHcFhQ7nqSCEN0NU3ef0mNrYIutVuqtWi31lkqdTUIOcVhosr0m9LoY3fk82MjMElhOvsTfQOhi4IMQ5IC1bhAUDZSB3BOAWbMoAcNdOOdJutIl/yZBh0Id0aczb2s1LIWe3ktAfSZHB5rxLwKO1x/PC4gCHP2B+HqAIfV7t+8uQD/s/r/zWu0qYT5YLoF12yBqSgpC0lRnaRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgKlF6G8z+V+Pu2PgETKtXu0crrck6/9/jSV7dpvQKA=;
 b=Vard7RZWaYcyYw8QrgoJMCEBKqnODlxuekFU1Q8n7pkdGdiROIvNcutrOPkzzIc2Ms58E6tHD6w4eEu5V17UX/bGovoLx+UkmBojmxRFpRJxukEpzp5gaB3JB0/255vlPaY+FlKHK6mC+PlNJBZ5Sq4dYUCT2JrcUUZAVJjs/3/79FVjSAK+nhGMmaHeyG0nmHGNRSyvRcR19wTuJwoewWF3eRjfBjrS9hqDwFSHFS9pxIxXFTFvar43gP+fm4rxa5xoyvUnj7iOaUF0n/lJqmD/PJQf2anVinR7ZPP5VDh49KAyX4eO+LusocP+FwRVYiVmOF5LHiBBxlz4DOANaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgKlF6G8z+V+Pu2PgETKtXu0crrck6/9/jSV7dpvQKA=;
 b=jeb74qeJSoFv0JP2bqrO03dh7nNbJ6TEgK5CDp1R52DFy9tQmPvzI2Gfj8bc/Gp8V2IgYIjczrLyvS/0Z7IOxHoViy6bR3sD9U+TEtTDmbu1LIAH1UrFpL6QFJqcFLVKt5eq8jhSAUjdxQ8zvt96vkzchreQkPo1Hi6hq8gb50w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6673.eurprd04.prod.outlook.com (2603:10a6:208:16a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 01:49:41 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 01:49:41 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V2 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Date:   Mon, 11 Jul 2022 19:44:32 +1000
Message-Id: <20220711094434.369377-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711094434.369377-1-wei.fang@nxp.com>
References: <20220711094434.369377-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 962011f8-658c-4231-8cac-08da62df9f1d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6673:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WoETVQVHpfu7hC5ynmtf086rpe8+LrKDMZ43aM88toovs/LpsfMAOpGKwp1bF9OTWYy/h6UKUN+mH/m20nsxHy9g+8sqoRtXMGF7B80acqUy4uJZKihE3vHRArdFTPFdgwhm7utZaWzyOzml113dALvVfg1JoCoN5z7qNjWcnJ3FX6DME7eUbbFh5sY/MHRQkrDcZsKaQ6A/DMVc5H4ooAa55U9dDuadiz1Te2f6LYPy58fxlZDiK4MP0ZYbv727g/EgLiEAmpA0WKnghCFEFKf+N2fIhjLGdSy+mnjLpwdpqWR5Ko7NunltGEQRQ3gSe0c1GUnjL9HIcQtLNjLXjdD8ECwEvAtU0/VpiTfbFBeHI5jOu/QifWar3wc6N7tBr72QUFnV3nL+CjEUfuFTSsyhKZz6MY6X3rX77Vz3p4/vt4U2gznOnpE5+Gvjt+I8Dn6dkOzn0a/1DQLQbddEVLCfIAAPTQaAQH8048fyaeG4vhmGFkQyGWAo8Em96Fq3jOMOB+CWQ6mn0CDdF75Okf7bK4KFYj77j0ClzRqHenBX0Zfl7iptJvdXca5npNg/0VJijbNzRqCkODufzh7Jz+lkKtrNsX7RMfOvhTxnIg3dKJ/C+ZdXaoWtKlPaCqwaw9mqqjQDvp3ymyFNeGWbfk54p6W1URH3liVRIelPeaT41F4+XMxvRpnauWU2UHaKAIEO7Sbi/1ggIJjBNv6iS354nkc90fVqAoN/ON2b/tMExLWWF74kJPzjHqy45uqdA/6kBCx7Z2sOSOk8FO0DJMukxOxSKyKio/o8SMFAqdhQwI4Y8eczr5TZJbUthpT1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(66946007)(66476007)(66556008)(6512007)(86362001)(8936002)(186003)(6666004)(8676002)(1076003)(4326008)(52116002)(6506007)(41300700001)(26005)(478600001)(6486002)(2616005)(38350700002)(316002)(38100700002)(2906002)(36756003)(44832011)(5660300002)(4744005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37a6S6rbFYHSJvbK47v2jJq1HC/hjkrpcRXYXc2hBDHo22ukXjBQG590SDDr?=
 =?us-ascii?Q?jJbn7ki63d3uNm6EuXnLUGdCBPBfe/wJxw8fkDARlX6ti8ax1BPWbN1SaTBY?=
 =?us-ascii?Q?0NPTBfM88EOAckrSFdBgOXx5G2GnODOScZeOObt6sPNkN5nHdhJYgUmbQ8Zn?=
 =?us-ascii?Q?W1jNYO2WJiezLxQJB5We6s4tuq5q1WeUIljwi4JdlpD11hwqfsFa6Wr2RkB0?=
 =?us-ascii?Q?zXlj0H3T3lXkXBTdM9gOKHIpOgnJ0WAiMPBSLbr9N9/VhFR3HXfpBX0ToQ13?=
 =?us-ascii?Q?w4Y7N1/7uUuIErhrCg3ow6NJMRiC6u2uoyF4sosOWyNt09uSdJytXaoNi0IR?=
 =?us-ascii?Q?h/kZkLkI5jfAPhyM9CBokcCSguFjwMU/pi/g8tNBSf3kjIqhMFmoROrjKE/p?=
 =?us-ascii?Q?AbNblfNfO7Z/+v4Q+8UAn9B59usKuonEuj2bSccW/fkF29KnkHy5xqNcsqmC?=
 =?us-ascii?Q?K6IM5W4v9KyhsH8kt7o7JqZ13788UvVvGO8C5RC58CnRdJy1e+BujjLGCJGS?=
 =?us-ascii?Q?L8sCmbRkLdRtWXLvVIzL1JtJfHlpQWYWCRCCEHxgeijohiOfHkSMOonmrfQV?=
 =?us-ascii?Q?nxXzGj/2Gk15JTrN7eWnqA3a+J2c0c9590xqC+G8l41b0/++peQmogzTFEnj?=
 =?us-ascii?Q?X6n/QkNWTTCewC6QUIqxKpvGABBxJ4OxkqA9X+HSCRadn3dPxkaPhgRQeFOM?=
 =?us-ascii?Q?h7cHcID12IGIBmR98TtyCrvZvzUUg5h3+4hr0k6fT22Bx8XFMoP7Co03du9Z?=
 =?us-ascii?Q?qPALjjOn+XrqSyzgdwX+UQ+h7gBdv2yXv3RLv1AocO6+M/S7M4me7zBmdATG?=
 =?us-ascii?Q?rsXwItJsFQjinfQ2aGbe5w+5ZxEa87cR94cCsWKnQXzwX0gwd++BCWhu9d3y?=
 =?us-ascii?Q?sjrtIWaStK34qdLO9jrMzzXboCYfnqEVmEZx8+gH3zqwoCiFvvkY7CC/d1ei?=
 =?us-ascii?Q?Fxa5py/pTj2XPR7BRqoV3P75Xm8vPVOp2DdJnHWxRuguoGGawAXlVNZ+5+ly?=
 =?us-ascii?Q?EuP+Gkbf65QWAU0lqkBxY733skvr+JzesMbzDpUyLxfD21ZqEFIEKK/XoVR0?=
 =?us-ascii?Q?+tcW6Xg/uSgvG7TfU35bvq51d4AEN0cfFdEd5gdLHuvy1hwuesQyxnibM34m?=
 =?us-ascii?Q?bJ5Unz4UqqyCTN+KHuVlBnM2+BDpQkSrqLGXTFjzRjaMk4fFPiFn74uyl9ye?=
 =?us-ascii?Q?vbKH9SGc0bcrjnFXy7xApgCkmud5+ow6QnrXptfwbXkrbNYj6xzZG4wgblAQ?=
 =?us-ascii?Q?s0lq4oGpoo9AH2fl4H/p+1/ouVcxWVkFF+Mtayrnc5hLN+V4AB0eTEFkw3Bk?=
 =?us-ascii?Q?9Svzx6p520GaKGhwXS5vedPZrD8DrJD3wy68iWfSX1JoFqf27hxUITx21GlG?=
 =?us-ascii?Q?8ZjOBIgrlXL8q4zLiE5RetUA9fAp+LHML3Q1kgYc8mwaIMHgWzU4B52xRB6Q?=
 =?us-ascii?Q?MZiCVXkNQi3j1GmhnF8an7Fmq08YHAJ4mZi60j1AAd9xOc4rbnwBrK2e88g6?=
 =?us-ascii?Q?zRkZAk2z8gwJfacJHZgTnTKWBL4xnBwUAb4fKMHkycGNm31MSnQhOYnbhlwV?=
 =?us-ascii?Q?NvNTU6x/1BKkzRtKoHVtDT64OuUC38Y67vDIFBS6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962011f8-658c-4231-8cac-08da62df9f1d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 01:49:41.5745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKLCN9ENnlMNaQZjyLy2X6NXRRJZ0QjgR9TnIoIA6spwEWz+wZutycxt4snsI6ALJuoiX9dcA13lWGRXB0HrIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6673
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fsl,imx8ulp-fec for i.MX8ULP platform.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Add fsl,imx6q-fec
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..4d2454ade3b6 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,11 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8ulp-fec
+          - const: fsl,imx6ul-fec
+          - const: fsl,imx6q-fec
 
   reg:
     maxItems: 1
-- 
2.25.1

