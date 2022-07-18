Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F181577AEC
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiGRG2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiGRG2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:28:14 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80077.outbound.protection.outlook.com [40.107.8.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F37111C29;
        Sun, 17 Jul 2022 23:28:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emXLUzMMQuyxEj7Mg4H8k9ui2KvBjW9zNCAba1VyYg1CXQV1aylIY3C9QQjgW0W8LZDJhIY0p6gUiRX+3Sl8j3TQLlVcY6vdYvSQoZZdyII49qPLD78l1Qo30Brs18YhBK+7Dnhc4Xz0IYKAvCBXZET7PQDDnSJ00fwSaT61zX3iNg2x2/uQMLc2SSc5X16AW+q+HDovl2nz9a/41/zdvBXh8G5lvVxgJf+5acZ7pRpW9SrnoipftZ0LXQGC2edaAlIB2nN5BcLpXTIJTNgu+V7Tx6QgkskxGpe5MSSA3AlV/egghBoHi1iVp0BkrFHm7juvXPJN9KnDVUlvujaw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCxQA+CugozcN7CeARfSMZtKEfCuo5uByE+83uPujJ0=;
 b=bt1EP7PBf/R5q8nQ5weNkiqvYqhk7lp1oKyEoFg2Tq2U3nCHFgwN45Rvsyt6N7vrg7x6UBIxyl2dNeEh1J74QWbbP/7wqHWEtBskR9YMtEEgpoh1kMBidxO3NbzNbgb9hixbt720PpC5OBMLF56w/msCSql+43dv6Bh2KHGSF/a+BvC6PelYjw20EREkWpxSUXInpFtO+Bw1RbcgoTZvixOHBGbESAa47FJeSSpzdC1n0aSzp6QhCo1jls7A3o2IXIQrWLsdyxYYq1CCVRvwTci5WaQtD7v8Vm/zG7xbyMOVhEyX3iHXz3+dwyCeQsCyHBZnZ7rsq4HLfq+VOUdZjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCxQA+CugozcN7CeARfSMZtKEfCuo5uByE+83uPujJ0=;
 b=StvUtU+btXAiqO5sMz1n6ngHGU1kWBJxKsnqWGktvdDr+DvhWA9scI0IokrVPNo9+7t52GIOH6gQ7ccnD8QirTr+6EE488jmCCvJoVKFYU95KmZwHo905xRDQKWsNR3FAFMTnkMc5EGtAt73gMWAgG6Q75az1kXae4jlUcnr4WQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AS8PR04MB7704.eurprd04.prod.outlook.com (2603:10a6:20b:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 06:28:08 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 06:28:08 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V3 0/3] Add the fec node on i.MX8ULP platform
Date:   Tue, 19 Jul 2022 00:22:54 +1000
Message-Id: <20220718142257.556248-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KL1PR01CA0118.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::34) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11f7a16d-3c68-4f34-200e-08da6886ade9
X-MS-TrafficTypeDiagnostic: AS8PR04MB7704:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEZYr+gtQbF/bUa5GByTw9tfuCCeTqKRu+wzTYZuzsBz4Tbje855vDA98WPg2SBW7t1ZA+n4DiFeh73orBkpv3DYay3bwTmBPh37rRqxxpwIEDAFiu+j1BiwAConvWr83hbtisRvKRxZVvhhtpGYT9pNUG6loGi4JhO18sf2a8h9QkMGMoy59rIjhxOSBeE8fxREcdaUZYqHPUBKFmCVRCjn5auItCFzlj86EEzt/db3l4HTAkXbgKmZrlBhiDRKTD8Gxm6a4cwhsKkf9OuS8YEBy5mg6ZcospUp8UXwU5gguX+mb4we4R142X2iSfRwddLZWgQDtKAOyNS4b714JgfwNH9CLPWPdtfI8ORTxo4azIwThUIx/ca5d3kFucoAu9CNB0rxmGAlnaFTI0UVV/tKqnN0XKJjxtz2TrRPxIEAKeYDpLdmmGESbeia0NZZVVZqK3MutL1USy2jPLgwde0xY0LHCKkMc3pnVFE5WQi1IbePwfZfPFmP7rusK6lQV3oQ+aC+fNkOYbc9D/LdBNOKzBdugpvt69t2ZaG3h9DNYPadZaUfdK6WhXJ1/TLKq979NCWHQne4j03flLwnYcz+1u3/U1ShxCXw3qRKvlzyvvb9LVGVLdv+K+Um0ZWcbWokpHCQJMVF9GL35TodYrsAReJlz3ZIJ2IkMu0bHaOmzXzgIX2XMJpbnF3gIc2gOx3f4G+daohFY6vBaIFuMeCx1+Ae623TTaFfZobWWRcD7FvUKYZ/4F3dDykNion/ja3zAfaeR6f4i2ncrAs6REYmp9pKuQBKDqX6AN2vUioBTT8MnxRDKWod4lMQ7r80
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(6512007)(4744005)(9686003)(186003)(26005)(41300700001)(6666004)(2906002)(86362001)(52116002)(6506007)(478600001)(1076003)(6486002)(7416002)(2616005)(5660300002)(8936002)(38100700002)(38350700002)(316002)(36756003)(66476007)(66556008)(66946007)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EO2B7yUppQgqqP7H2IQs6DQuxoQDRohjN4ktOOSv7O5kBx6o6Kk7I1q4vD4o?=
 =?us-ascii?Q?s/l8TyFPWG+OCxUlVq1Edty0EZsfRoraj+3s4ALcAjl+3E3mRUfoWNlJvVuA?=
 =?us-ascii?Q?/WUBJMaVE+WwZLqxB7CYsgP9jhRq4ZXHHI/PrvPdyoxL1bSpPqqHD1QyCGrq?=
 =?us-ascii?Q?WNn5vi8aTtT9YWp7Y1+GFvfDndhf1GOtsjiFtpcT4SYucq6959FR8YKgc7AO?=
 =?us-ascii?Q?SYPUp6AD4ldR8uEUm+9hUkX2J2rDpUsBShcF5065ZzkvacENtSQ2PD4mbG4t?=
 =?us-ascii?Q?YKXwJk42DDvXICeIhxWF8/+V2dB5Tf1hgS6103jHZ/fQL/N2PbfeZTRIPGI6?=
 =?us-ascii?Q?C9749h1VpwCe99vyJOaXfoXZ23IcjmW0rMzyKhFnUgtbTNJO77LOJmKnT4sk?=
 =?us-ascii?Q?uWqNWnhtqQz/M2plJvyfKAWfrOgHRHNtz98wbOb1HsX5Sdc///Vh9/W+bD4x?=
 =?us-ascii?Q?oRE52Brm+D89SxCWPWT1JMhLPCJyH8up8EZwhq0rxAHYh6CX96vo5lz0RM83?=
 =?us-ascii?Q?z+YPCRLSO9O3W9KBwaUM8fNLLrP6RVvD9JLwYFnE6VLGLppPylFFvpTYJbMV?=
 =?us-ascii?Q?kk/H5HoRkq0EBZrDMcmvaLFaZ/7HFJjyiRvTMoiiZ+Huwr63qT3XXaxqN4Xs?=
 =?us-ascii?Q?nub1Dj5OiIKvNRMBbd/tR4g1p79Smrwu9PjK5P6/iz4fe+fIOJ/+/7Xu+lpr?=
 =?us-ascii?Q?aQYUmpkPypJZQ0LSShkcY81+zWT/9E06xZbAzZTzzuK1uWqNMYhuQ8ofW6+A?=
 =?us-ascii?Q?DvyT0VPhNI/JLYKD6TQ+jG3oCSTEIY0birr6cloFJhEYk3WQIriKerQeBWvI?=
 =?us-ascii?Q?OQj3cq4ut50xACAIWQy4SkSBtVGvoGrH9g9ireTkkb4AolxcJzVgy6RLoMUl?=
 =?us-ascii?Q?2t+hbeWE1cczYt1SrcRaqhOny63VF2K8andJt0pEL0AMUwhsA2lLLVEmFDjz?=
 =?us-ascii?Q?isvOIsVP2e4qC4CiZRBF3CSdRQYyl+syB+1MTlx3JlF/cPPyxqjwA32/TDwL?=
 =?us-ascii?Q?lqri4maunttz5QYqOD0JfbRC2ukgypbB7OXQJ1obUE+wRtem4PNqDVEp884u?=
 =?us-ascii?Q?qfq623Ktu8A6qPA9x2hXw4+EFEzEBvDTsfZxE7WWquKAPDQDsWCr2GH+lG/t?=
 =?us-ascii?Q?BZm0h9SoVtweEkGX/M9s9XnGor1i9euu45SkHn6b0JSm3sPyPNEe2cJK6ofk?=
 =?us-ascii?Q?lpqHAiOVg4tx3kgqBByQsJpzBKTstGypPfGljMvuNsNG+CaEaLE/aX3XTJDc?=
 =?us-ascii?Q?YoD0MRbKOlekbjqnj/Sabz2Fg87OEBazeY3RnflKLVxF24HHC+rbKFLd3RYS?=
 =?us-ascii?Q?nMot3Fia9YhfKEopMZa31qh0Ty7Z19I/aNir6EOOTETfL4ay5V0jfvhgbsAp?=
 =?us-ascii?Q?wJPr31bqv9FHJy639pFJJAI/sSR6rHU8MP7YQsi4TuV569xbdAOxjbCK1Y8P?=
 =?us-ascii?Q?0Ho81uiyEPPkWyM68btSB79z//wuXdUnqUcAFHxOuy2JmC9VpS0TeXscBVgh?=
 =?us-ascii?Q?zcNqRbup8Xi46/bjgi5W7vJ+Oe/mxq3ZXNTmm/CbN+ND1yiwV/KTFYuEf3+1?=
 =?us-ascii?Q?BBedPfcoaXdqPKo+qAI7164E8w/0dS/Ey4DXu7D7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f7a16d-3c68-4f34-200e-08da6886ade9
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 06:28:08.2582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXRTDU4hD+hxKeK9iXmvt44QzWM96J97/yyRY/yfdYyOe1BLeNuaT2k4tI/1mAmtgzcPmW2FJ5o8/gBfEveOrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7704
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add the fec node on i.MX8ULP platfroms.
And enable the fec support on i.MX8ULP EVK boards.

Wei Fang (3):
  dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
  arm64: dts: imx8ulp: Add the fec support
  arm64: dts: imx8ulp-evk: Add the fec support

 .../devicetree/bindings/net/fsl,fec.yaml      |  5 ++
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi    | 11 ++++
 3 files changed, 73 insertions(+)

-- 
2.25.1

