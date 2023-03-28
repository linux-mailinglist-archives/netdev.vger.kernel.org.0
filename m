Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448C86CB628
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 07:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjC1FlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 01:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjC1FlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 01:41:01 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2074.outbound.protection.outlook.com [40.107.21.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69621BF6;
        Mon, 27 Mar 2023 22:41:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BblbytIBVAEutAQzN8heGkL1S1j+MIIExGgfz+HLtRIltCr4mWMaIfeP0qUEQylwRZqSVAcSFiPFiEUqpuAhiBiixybacn2i/yuB5rj1PTPFTOlK82zWV4mDjsy5p92OfbLTmj6WuGYcrB34phzYlf4GuEkQEZNJPXnRyR73hAXtAEWM03ANTEUUKbkttuM9yNeVb5ZIiYwAo27YtLtFnjCBI+hLAwRPJnWi6W0ZklN98PqcNJ0QOPa6WTNrY/P5lE8lzH9XkXLlPrGu6XdAJRpEZu66fLN7nEb2lSpTVQQkPthK/lHYvBJAJrWje6Ar7kd1Tm57Py7wGfgzbPxwhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYN+BQU2SUzrECrd2GVWR2wol9+ysoSoHXQ5zlNqhI8=;
 b=bTAtIH3R0Zhk73twbwYxmfA61nDiCs2P5PuOMKkPIzKVuDVkS7em2AHQus28ZduA+zlqNN8Ojf7Z57fLtr42FGMYiyHMYFec/QJWZgLVdefge+SfiD9QJfaPXeFgG3qEzmu4VIvcJ++ME2NS1HR6J0XGdIlZi9a6njTgfzuYasvsr8b75VqR7RbhJZNZ4uAtxud/oqwVqstrDfsz/UIUuuAmsyAbjEUtIMkCopcu53FMWZ1m+6MkW/CpcE/XXq925SXBDVli+tan5TwDQe0SDPd7LhDJbkmj7oBQCeRWfbfweBTtKJCPzpPLjjyplVgJ9DOj0xzlU1z5sP6618XsKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYN+BQU2SUzrECrd2GVWR2wol9+ysoSoHXQ5zlNqhI8=;
 b=L8N6CRS6+tTiGPW9Br0lvxF5VKO1a3zAO3/R9GXBkwNQ+SM2j1KZmj92p+18wI1QgNnZEy28WsJQoVHsncI3waA0WiWNwu7SvRkQed8uoLmHSRerleF3E4+Jj03gQvmnkAcS30R8sfVWKIqUZNXN9LqoMLl4REBTfX58xwNUdhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM9PR04MB8164.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 05:40:57 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::778e:19d0:cba0:5cc0]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::778e:19d0:cba0:5cc0%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 05:40:57 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH] dt-bindings: can: fsl,flexcan: add optional power-domains property
Date:   Tue, 28 Mar 2023 13:46:02 +0800
Message-Id: <20230328054602.1974255-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM9PR04MB8164:EE_
X-MS-Office365-Filtering-Correlation-Id: e96e10c9-e421-498a-041e-08db2f4f00db
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09D256v/JyJk+l74R7pxNAN0wVaX8dgHDKZRb/WpPfkhwsu5ZxpcGYhSqqIFz+MoKe1z+yu111ZDin2FiRa12MZH7zoZpBF2Cmg4JKtJB8IikKjNVrtdcJZpwwTnWE0j3K6j5nWX2tuEk4KyIym/YpW43Kel3pXgnB3hO75+NaF2qfjFsKjyFdgTdOPjuoWOMq5eo59W04Xq6U6lJR7Hg2ukPHD7IByS1pCdH3ZNAVVlTnuCGlG4P84Zoy00vZkIQ4slDI6vq7JI49KYXJjNZ94c/dNEVtHCv2d8ZV8bGsfOs7MkV8LDFSGx7WhwEXBZ/enobxy0mRLxYW92bjyns2VLyxD32GOs6dmrdNAwARplkhsc9XzIadD5Lxsl4vYLanCR5wLZAFaQQlUpEMkGpt2SxDc5I4uApAW4WtoHe4Du1LZ/PPB1LUYYo56X4wjwCtB7snesU6FNW2Xj7eqU5CLYrI4hYbg3UT4katw1h8JFlCEpSHyvf22sxKGd78YKn4+dDzy2YEFOgG7ZPdCFYtOM/hCeQwZS2FERqeoy76wiRyUruygfHStCtMudMdxiSBHk2eSQFCAReqOmFeL5ng58ds1j133QvGnkX27i7ILvEr1WV4yMQkULQZ6R6ypK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199021)(5660300002)(8936002)(4326008)(8676002)(66946007)(66556008)(66476007)(41300700001)(38100700002)(38350700002)(7416002)(4744005)(2906002)(6666004)(1076003)(26005)(6512007)(6506007)(52116002)(6486002)(186003)(2616005)(83380400001)(316002)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hoU0XZPu/JmM24nSOwljDt55KjKtntHwUkTCXveTDOt7CSGH+04ri2qQtD8r?=
 =?us-ascii?Q?g2EzSTADi2YSHJsQpNf3UhhYX9f8hPXbsdisGuwYZXWjJmakiWdW6PVgKQwv?=
 =?us-ascii?Q?D55DkOUKgkuicnexRDeNZwzYGo274GtUdWN/TIhLWGGEExn39pZpm5hfSDDN?=
 =?us-ascii?Q?TZuS1x7XKOACD3DpR+ZHfx5l5STi7AUOeE3VewN2Bcj+6mcRkea0k2xo8kuI?=
 =?us-ascii?Q?F2JzXr21LtoZjfzbaL227jB930wWXTGVYXfySHYNb/w8Mt08doY/U9ovS4Rk?=
 =?us-ascii?Q?4syl7Aov0rGRNIUwP5CHezphV+GsJUbdBXp5GS8uyB+xH6JFY278bYX0Dbzp?=
 =?us-ascii?Q?5wnXj7ij5ZspOQa3dB/sw2X0zPmm52ltC5bTPT2lfd/y72qLY+C+y6F5BKWQ?=
 =?us-ascii?Q?CcHcuY6ZGVVAYbIjB6YugZ+CVxSaU4g0KnNnEeTgRmIPuAt1ZIrTo4jQe93q?=
 =?us-ascii?Q?JkQITNE2Ii0D84d2TrTZImTvhsVIqwDsZDXsPWMCHsZYO2Yo2aer9t6Q9p/c?=
 =?us-ascii?Q?tnuLTJHgsjdLAvsRPQOZ9mn4k0cJotB3AMTu5RRSMkW6tC4V00b84cfxPENF?=
 =?us-ascii?Q?mY/qgAhbAZbzbSxLCjI6e3rMbL/0HKmKNvb8cm158otNsv0EIgBllnFNTYee?=
 =?us-ascii?Q?1tuRfR2/IjRQREfGm9MQVBgUeSE+ZlA55Uy9j/s/GfJrlYUtdVZ1HYgV5okE?=
 =?us-ascii?Q?FMnPA7UHO8xrNXZlBCX19v8rjNUddBnWpdLN85ikFUIuRDvc9tV3otygh0Ck?=
 =?us-ascii?Q?7nPdiJolMwMUMR3EsYC2/nJZktgtHZbAOc7WcQBnavNNh50gHRuGtf5AQ9z9?=
 =?us-ascii?Q?TD6g2XhsgZyX9P/rzIJpMxrUI4DI5W8z13WjG/99oPUavO0hUGm42NnZfhC1?=
 =?us-ascii?Q?IDP0snpov+iq6GWzzErXSN0b/YVg11yCk+CBXn3WRYDm7Xru/OoCm30OkGkc?=
 =?us-ascii?Q?x6rTQjqNMR3m+xU4ZCEAb/542K9vIZ4DprMa7wVcEJ8EBtIP9939t8OfTkj3?=
 =?us-ascii?Q?RRCEW8fQfZacZfIWkkxGjgvK8lKYLJ1yhyYawOdREhb8JsrJwrzrqttXNo1h?=
 =?us-ascii?Q?e1IbEIQxvknZFeSS0+B+WLfSkfRejGCqkghPtdfgLy4ylvgSBzHGAZW4HXJq?=
 =?us-ascii?Q?oq1n70plfrsh5jq8bIv5KTRs30xgWCqU3iJTZMTseLkO7NVsj4RL6sbYoXoj?=
 =?us-ascii?Q?bLP44tPd7bD53r4GdKBSL0a82EdLyRYgs6aWYlc+zGI4hNXK11oog4VxJWz2?=
 =?us-ascii?Q?7JJ9nWTvt69Zeq2HIB9aE/5pmSmi6qiOhlwZrIiICczwt5xY9zEZzDm/hFC6?=
 =?us-ascii?Q?yezcPAXrMg59ME7ZDJaURMAMet13pJLY9qTPolPjM3SGvnhqbJTnyAxaqYxJ?=
 =?us-ascii?Q?nn2yyt1pjbn+O6vPml2vZ6670w7nqFeCIAjoWavWtw91YDUfECnWat6Zlu9O?=
 =?us-ascii?Q?JrbEcdNf1VRPZBxqw5cqVvmZlDwloW17MDWVihYubNhOPTze+9+WoBx+291B?=
 =?us-ascii?Q?6xl5ic/Fi5qtBiy9Ulhw6wMQlJpybvbYA5HCksdGOaBJLVe4LZOiKz00xN3E?=
 =?us-ascii?Q?fT8vA83NXceXy3jLLfNt7HGZcEUogjB6pWQdoEQ4?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e96e10c9-e421-498a-041e-08db2f4f00db
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 05:40:57.0110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YTVaitQ7/88MqTTCmyZTzslyvFfm/pqdS4nYCXDaWz2wNNKNGVs/4u5+t0YOpamVVAUsEYoTPbV0CnqpZ4jCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8164
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

Add optional power-domains property for i.MX8 usage.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 6e59bd2a6094..4162469c3c08 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -63,6 +63,9 @@ properties:
       boot loader. This property should only be used the used operating system
       doesn't support the clocks and clock-names property.
 
+  power-domains:
+    maxItems: 1
+
   xceiver-supply:
     description: Regulator that powers the CAN transceiver.
 
-- 
2.37.1

