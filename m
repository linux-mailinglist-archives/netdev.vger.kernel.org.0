Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A79B53FD5D
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242884AbiFGLTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242852AbiFGLRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:51 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3AEBE22;
        Tue,  7 Jun 2022 04:17:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GT4NHGMjCH23QqWAGBI5DJId9xpox12CjOWH/I33U8iqHprD1RdM2LZy8Oz+TiKUiaHedvUHRk80cf2FyXxQKazLI7xm2xjCTKN6jrrZ11M0KsjatBUPwBmHwFvaj52197IhTToMKEeka1mDqKb7YoqhxYYbCQDzUHHr8vcEk6Tqn2IX86t7VdlRVawO/txmlodSHzRMcetAdUL2/yVNdsQaqy0diyfAVfZwbFZP7bU/A8jCBc4euQ+OIIkuRemI7WaRa+OfGpBh1SL7LrL+fZFZmWTt2ozSaQ+G1u1HLcwo5L0RKVWhTtCdg4x4HWtM2ZyKGqV8sBT/A+ojqerD9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhKNhkCb9qQ95QDC23Qlp02a3IwlKT22tceJI52w1Dc=;
 b=YHCBMMg1pQ7FaThrIU0XG/BbuibroNtvlHsM/om7xSEu09SnYo1R2wpYyYWY1JzRdMuW6YKGR1OD/EK9NeNea+J2UJcbVTeiBSf+wER8T0Y+6AJLY+aNIMMBSx0392tbt24988KKAJkfnfT7psgkWmIF+Gc3D/vJlLBFJg4EuwRTHQt/RgQhYCVsFH3OMx5+0ieMzfxXJSPIqY1KaK9X5xfl0pZWB0uBEozQz/fFjuvhX9/RocEB2E2ymf0RYR3kKYQilwn6tZ1n4nh3w5XCI7a/JLweFpNw+ozcJgupHyFdJG6LCv+zZDqLZewU57L+/xtr7RBrpmYhwTIQAbexBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhKNhkCb9qQ95QDC23Qlp02a3IwlKT22tceJI52w1Dc=;
 b=jkRTk+S54arjlkd+YLpWXLhtMLQZeAdzJxwIhLAsx0jsQmdqohpIGElzSEulv+Ae/eObi+WuwBzACYzgxaEp9ovLEuZGel5Wm3M8p/M7APCvPxnBe/Bb1qQneTJMzD48Z+Lsl19XC4A/UeXOh/K73qwy+CWhqZfA/pP07UX77Iw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:20 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:19 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v9 11/12] dt-bindings: arm: freescale: scu-ocotp: Add i.MX8DXL compatible string
Date:   Tue,  7 Jun 2022 14:16:24 +0300
Message-Id: <20220607111625.1845393-12-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06d57f32-03c4-4678-3302-08da4877496a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB48901B6A01FACA87EFB64144F6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWJvSO2+lCz4YKS7UUkbg01Tx2YwQiszKs4X1+JpTHdVrS3jakgFqY7/ro+ZmXN+eO7o2tDA0Kz0DTRqZ5om5UQjkCerefg7kHHiWPjTQOP/hHS2dvlwSnubKmj9zzxgW8ah8gCrsGvMAaTPwkCvUfOO1sZYI6oLCmLqQPIUJB2M6rmF7lX90MtRQs9oLhVgkzYW8SS1r1B/soXXhWitWqxHK5fal/FvXfv/POjOIJ1iI+57kTa0dPiid8deZjPPMTmPrB/4jUvKGu054uX03DJNCe0nUGvdrDaa1aOyIonjV0vU6k7nuMAP2/JMsBktTHYnpIpsXl5oolCgl/a7rqQFYBs7YsHAEuMZF2rEdlPoanYczN+tUKbKvQWq93/knM++7++5VlFi7HM1efUOvFlA7AbWqcZCJfAyP/aQ+wLomxAMBRBZYvs56u/7SOctctV85hcKzGkQ7m6vMr0xxUfaJ2eK8T0L6KCcWYkcPYIOx9WXxH8K/HHbKRp8ILjMSAoFCwCkkIzMEPFssRBG3rKsggPJFab4eb9zO+ezPDpUWmMJ5MN19PT5Rqbte93kMgRoBvgRRY/FF42iH71hxp9xdAjvV9z1TAKbIN7IIZzJXmnJP5BTLSzURhNwXbALGTl1plpWeqXumJmZb01hrPvlXabR1QCWMuXNEPYbM+/O0ok3O0pklgr+riuC9scg+Td/1mQ3dZHQ3V75H4pCcJEUjsnqG/5kpo4H9BbmmTo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NX2sW6ZZHj8QMl3fAY4hvDAP4oTyafjrZHajdMXzNVzpFW30IHN3ur3D6Tbp?=
 =?us-ascii?Q?yKqejTntZc42jr+/B2xMwsqQL+vmmO8EAr6VpP/4+7WJYSi82z6jcb2zbzvI?=
 =?us-ascii?Q?FH2uO6sYSuFHnZhIF+ul+lMOJavAXhfSxVicN7ncG+PaX6UgGywnZPazfqrZ?=
 =?us-ascii?Q?rSWJ1znvzNS8XU8b0D6Ga5hMxi8ljDzukkf+auk5suHSfANzbOYurEKgu9Bd?=
 =?us-ascii?Q?S18xsUvXOf6HLMmtbUsUxcjgEEAqvPPMA3cueSBl6RCCEtBHVrj0YHe/Hlbt?=
 =?us-ascii?Q?mpqU6gpUILz8KqPGuq5R1ibjLi7TkTgXVWcIilQmqcQ2bbf2yf44j5XjA36A?=
 =?us-ascii?Q?XofSszAEcHaKulyH50bKNCSwfqah7qaYxtjJV4GlN0+Ktp30TP3c4BHGDmKe?=
 =?us-ascii?Q?Ugs/ZbxAq17xFSzcY2shhzrQF7ovCYuEMMs0eDG0YBGL2OmUL4RQMS8Wqal+?=
 =?us-ascii?Q?o2DbuNQxHQITRrLt7OT/7gwf+bPQolfNqDDnZ43BY9ffuJXU1Eo5Qf9XWmDN?=
 =?us-ascii?Q?CRALTWAzV6GtFBEuJFwg34JeRaaw0MxC6qecP/46AdYc/ULRyf/cbqmlmkM4?=
 =?us-ascii?Q?X00KZnp/87BFsvMPRonrtuszop25LEgDMWsrnwy0fnYa78Uk072Q7DvRNC6s?=
 =?us-ascii?Q?R+Ls5Kc9p19XDGihMgooayhoaVSKh+5E1QNtPoGyB2cLD9m5rkP4Wv/0HuFp?=
 =?us-ascii?Q?JyripVe55cFtJpGm6I+5EWbdX/yS0gyj7RlJA8l9d3rGxpZ+lgDUOS61HmYn?=
 =?us-ascii?Q?k+5GOoUVGU0L1HdFVSazLtzBA0NxJJMmb2OgzN51qCR1WSQVNtA8H/2NXeI8?=
 =?us-ascii?Q?aXBEJFTgsVSCCpuasZ2t5D1BWap5zUvlGceBB/S6kQoOU4Lm470jAUhzZP+z?=
 =?us-ascii?Q?yWaGKF9m4/2Y29aUz+v77I979R2+pERTv50HSQGz9ke4XlAU6b4zvEUIHg8O?=
 =?us-ascii?Q?+kRKDD1o9zjNuNi3zQkPUqOTSFC1H3gZOxcmCnEnAYcoTWY3oVnc1l/6bFSV?=
 =?us-ascii?Q?5A5d7zpdnOZuZsTcUKOrIEJbBa5FiCt6m2/6gTVJrK01zUPCPJSD6HYZhNJb?=
 =?us-ascii?Q?iOjCRO2Oo4XfgIQYfLY+20z3Q80yi34a4tOO583fl5iP+92aU2y/UO7BY99n?=
 =?us-ascii?Q?+taq18PInnQJiwkhWHXc0u2js9nc3wmiVXrIgp7/4B1HtQ4yPW5F93RCnOBJ?=
 =?us-ascii?Q?U1AD+Z5kpF0nydzNcKloE2MmliHA30VwOeccLqgtX7dDMFUIFq6Q8eGxj5Wc?=
 =?us-ascii?Q?kohBryvJP+tOeP4wo7wSHIlcQujw5ZRK3dz744J4QG+5R6ov/CpHsin9VF/w?=
 =?us-ascii?Q?3yDNhlOkiTfbwQ+8tCvsUNVvAKrh4vSTKOSnw7IG9viQ6XI3CYiC5+PacNHL?=
 =?us-ascii?Q?2E1nLqQRLNypXjBwl/U4py7A13DTusuuLZP5LsyE1hS5g412k108oPef47BV?=
 =?us-ascii?Q?lTLGeE0EBMWgI8of+cWz2CQnMolOBbEf9usqwFdWTjwVRDBPCruaBwNLQ61E?=
 =?us-ascii?Q?zf2HNkGWPJCTG9OlVyTh2EtzmE84d9AbONzJ2O2jY8tG7hmW6cpPDEM1nEsB?=
 =?us-ascii?Q?QLdp2nvNchtabG+qlhqB1CUcoZMWyZQNTw4Vf0RMOtqEbIxKqfTR9UN3hnpg?=
 =?us-ascii?Q?gS12hpKd3BnmGdsMMTeRvYZEo5vmifdxZ+xBPZ58uMTSjHwdOYixFqMr3XhF?=
 =?us-ascii?Q?52ErAXtqpYeSLp600Rq704dNDEgZGcxhfJIpxjlpq7qN+gDP4gEpsSJgon66?=
 =?us-ascii?Q?Olh/y4WvuQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d57f32-03c4-4678-3302-08da4877496a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:19.8226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Y6hEMXKuZTdwcEaWaw8poxPBZg6Z6v5UCLLPb3a650F3EegPQ5Iodt87AQR3sm2+bYkFf5YTKmMQwDCPMpIaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to the scu-ocotp bindings.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml        | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml b/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml
index 1c2d2486f366..73c9bd16ec35 100644
--- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml
@@ -20,7 +20,9 @@ properties:
           - enum:
               - fsl,imx8qm-scu-ocotp
               - fsl,imx8qxp-scu-ocotp
+              - fsl,imx8dxl-scu-ocotp
       - items:
+          - const: fsl,imx8dxl-scu-ocotp
           - const: fsl,imx8qxp-scu-ocotp
 
   '#address-cells':
-- 
2.34.3

