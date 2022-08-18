Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F55597BDF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbiHRDAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbiHRDAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:00:49 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2088.outbound.protection.outlook.com [40.107.21.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52817A74FE;
        Wed, 17 Aug 2022 20:00:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3z9TMlpIfrvBjf9/j90gP+c2KOXOFCUQPL4rdQrap0wZkC2YBx46AzMUiZWfEYw002k+J5OsggmY3Nh2QrABja0PB3v1Jg/rEOjr4LfGRodK4IlrHW4iQ5pnicno1iNgrHZnMusED33v1UWuo1anyv2ZNu+4lPpXNET4OZW3i4/gS2q7j56Gw0ugY+ZbEU4vNiyubVm39s9GgYwXsmGvcJQ17qdOULUPBk9YsNwaerC3qeWwapttbGCCFGDTxTnPw0tmS0LoKKHxQhZ1ndiXP7RetRzKdQR7HHZru9Wl/7sHqnXyqRkr0T12rXYqFbV62+r1eOxV6MWpn/BkONFaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQJvEY3bt9+aw4nsVKUHsr6cme+ErA1LwktdqnEcYK4=;
 b=PU+P/t6h1y2DK09sJgWK9kv6WQ6/xWBSEPAve5OY09kjRtqevDshTCbr0Yj1wp74YUuaGXP5FhyU5+/cHHFu5eJXBoKB62V3tsh/N48WjZfyDmU9aAKY5oIr4k3y4zG6xZb64yWgGuPPn4doms7LehIzpHtYTp/q9MuYVa1C7UK7/Nz57BhFeVJtsuZuzFHGGp923x5488DpXwS79hP0aqMzXAQ0pF+trcQXp0BSm/0VMlAZGjMPEu+Dy/PcyvUcdkjkHr5Z4BD0RdBNM+EWzhYmBwnQy0WM8fZxTFDEIAQ1onThY8U5jQ7xbjfbXWkw2loSwKl6lGpNI89D3oxcUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQJvEY3bt9+aw4nsVKUHsr6cme+ErA1LwktdqnEcYK4=;
 b=JxIbsvesu88OmpN/cTMow1BybRVxfQZdCSa8vaiSTT9VVxI/NaSaxGe5XhBax0yvyZSI+A1dsMWO54ntBR6KHXJcEjQYZsOtyhTqv1h9n78rlqHL8q85GJB3mo2fE0XLahW/ER6P+HR0THCpp4LTK2V8RYu0rjHiC1N8gGsuzL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB4637.eurprd04.prod.outlook.com (2603:10a6:803:70::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 03:00:45 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 03:00:45 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 net 0/2] Add DT property to disable hibernation mode
Date:   Thu, 18 Aug 2022 11:00:52 +0800
Message-Id: <20220818030054.1010660-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52966e01-0e2f-4da0-0ecb-08da80c5d86e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4637:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mAyJ5GjsS/yn9FuMxCmz2LbaC9NEfMdssIo09SDfmKhyqQj6rGPm33EpUsLqjCCfPPXyfKCLtGNdsHuWUsBkoimQM3YhZ9/fzGftwN/7es5psoBF7vKC8H93HGNg2+RHTUnCp1AAEIOxQHax1LY7VO/tX5FySCU4LVl7B63+U2UGyhYwf7oiO6gU54UXADzY++mr61PAb1KmfL/Tb4wMONtRo7J9RSqHHaBRRkt67dBJdK3ZW/WujCx2r8YROxEb+i5aJlIOGHrVBHvb/ynyJeffkti4Y2CJGIEYVOzkER0MgeYUQhyNwacvo22BOW+sG9WMa6RpzNq4//72oK3eYMFmZvuf+RJDhTP85MdZH9CxsCBWsLLZaQrCRH4kF/QUCbb5JqPp/iHIvZsWt+0QTvyTy/TldNGT+Y7EUDu66TzX4ku7l1avpJwYNIwIMPRmoXEkt5yg7C/ENKkCWzhhlrJ8ZDNCLau5nj4MvHHr4ykHKOC4ay/uILal7D3bZ2AqJjTy4FqOCD67ZaKXzWgnZHx8ALTBOlvGcIOWVjJqvOU353smKLmsfIHtK7ZlD/LYuzR+XwIaD/kECkT43LhDu16bvG8JsDqc4wiqXkFuhweWBfWisVHAIrGcoQIDspZrpKixzTZ83KaGwPZ+oEsS2036J2PiNVAhkb9egpLr5WRigDx1RS0ptHZiXFv8cMJRwC+7qsrblT23jd9QRr07i50nU0Yzv/jpH46+GKsE23QuPl0AFzVEcg0bed06TjwkI+4MeClmNM2A+ZleGe+8N9GRXDDzooi+jMVaXT6z+nM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(83380400001)(52116002)(6512007)(6506007)(26005)(2616005)(1076003)(9686003)(186003)(38350700002)(38100700002)(66556008)(7416002)(8936002)(5660300002)(4744005)(8676002)(66946007)(66476007)(2906002)(6666004)(478600001)(6486002)(41300700001)(316002)(921005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBWXcn9lrM39EslcNHUaZtGqWuIzdC11guqfEKi6XGbZdK+5++t9vGs4GDiI?=
 =?us-ascii?Q?no2INTIHskb4Cm8xU/c8aSAiIrWT1U34hABBE7kaayI7mhIOIQvI5KMDcDzh?=
 =?us-ascii?Q?2kOIXaxRR2ZXJMMcZuQnmbjViqbFNQYR0vxvPB6+61Jx3gYsWo6/uyW3IMHz?=
 =?us-ascii?Q?ngdEnvPhXsd0aDGecnBVLQJPKeUka3x9wsrkJ+mOxsdxWn8qglfurWJuz2X5?=
 =?us-ascii?Q?VmRWRe2k2KYQDs1QE0hRg5JsOHorPktWiX9ObwbSN8n9xV9XOv9incw/hjRT?=
 =?us-ascii?Q?yI7bAe9ShIHi++ve0YtxXDSfe4RLmIoK6FCF3QEJ1Xp6X2IKZMS1OHLA10HZ?=
 =?us-ascii?Q?qCmjhyMhGY/B+RcVRg/2gZgjj80RHK1UsstmJvb+68VNOnqVftMdEvLMxcFO?=
 =?us-ascii?Q?z+J0Ts8kq7usmHZegd9XlVfyG83uOHha+H4vHgvWQItyjzt+o92XMZhzqK70?=
 =?us-ascii?Q?36EpgZX3HK9tUSBCmjLTzozYqtKe6DOxBFw+Wvlbw4Y0Y4d/7AbGacaaI0en?=
 =?us-ascii?Q?iCjgb8thNQv3PzWiHVyoD1Jiqc1lkOd8NCjXbQg0IqJG9c+7DNxEl2u1qQNb?=
 =?us-ascii?Q?PeEkx6cI3khl+Cr40jag8716gjCG5tqaxIXDvIpEKKYlug3OI/KTec5vUZeO?=
 =?us-ascii?Q?nTopAq37DsvFKNE2w9g4DWeu7kO601YTGnbzJ7fsCA2UaIPnucaNPPer7ni6?=
 =?us-ascii?Q?wa0aFm6khNrdnV/8JXn+fjCZnHjuPNIzRBuylHtfediVo4eQhPtiEnCM7ac4?=
 =?us-ascii?Q?mX531DOvGbPqCxUIwAblFdasP6uwS2z6OJ0JbC3k0Ll+v7U2acMsnn0o8Pxp?=
 =?us-ascii?Q?FQ2Zw8ycknjHf/EgLuVMzz/x35/mvVuldkpAtkqlBLNfjamAzZ5aTXV2epqA?=
 =?us-ascii?Q?OdPBPjPglX1PYxkWstHR0AS9YAAV7MPbpjNUmEfkCK8gdN9ki9jgryja/7+3?=
 =?us-ascii?Q?cDko9w0D0hWJObBwkNJiHDSY+5+5RQHtWmnu1OWa8lfkz8QCY8ujRixQ5h8B?=
 =?us-ascii?Q?Xiz0xlp1pHAyM2d4Bsf7opCbDFt1CQsFuBNIr+SdxZfJcPUJkcKo8EOufkHf?=
 =?us-ascii?Q?N34s9SMEjp0XydrG+3k5jcGmiP/4RYfErJ8kD4GKLntaqD4gXrELFkWlvVm/?=
 =?us-ascii?Q?yVWggBu+AdwyqZRhzN2wdN6ZkWyCn8YpI632/RG8QRrk8s5mTY5lVJnKlTim?=
 =?us-ascii?Q?lfA9Ml7LZDI3uyemrspgGBt3B8n3RAaLgE6RnK1RRO2wTq3rBn7nA17J/t4D?=
 =?us-ascii?Q?r3+kAaOazHK96znuyPq6y2yeLEWDJq4wf/gRM7ZXFJ2+hLo6kFVsfKvUibHg?=
 =?us-ascii?Q?vlg7IGh0Xa9MPNhTUyw9d6+vSGjDkj48Pu45vOdkrVvBIsKH0LcNEL0wz/Xr?=
 =?us-ascii?Q?CUFB6emhsEkyko99bJF6w/nPJWFhMGhKVbW1xr9aD9jzW81tM6x8eGtNEP+T?=
 =?us-ascii?Q?S5uwynKBS+7QnCtFu9fi0JbTvc42ilRnW7HGcBU8Z67ZPTFFQsCwernKkXPR?=
 =?us-ascii?Q?12C3YiQDtM5DAeLHajpR0dnxE+3Qnagjza8Y25aGkvdezH6ZKGUuY9VDzm03?=
 =?us-ascii?Q?b2bGDcuK0AB4E3Jh0oVHVhnKE1gIgF3whDRSiter?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52966e01-0e2f-4da0-0ecb-08da80c5d86e
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 03:00:45.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Az1ZHSYRUgFR0k0fiTmNfp3UCXpUxflVY4y5dm+DNJXuOokSzy140BQkImvl10PmsAJ6hwb0kuXhNjscOOM8UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4637
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The patches add the ability to disable the hibernation mode of AR803x
PHYs. Hibernation mode defaults to enabled after hardware reset on
these PHYs. If the AR803x PHYs enter hibernation mode, they will not
provide any clock. For some MACs, they might need the clocks which
provided by the PHYs to support their own hardware logic.
So, the patches add the support to disable hibernation mode by adding
a boolean:
        qca,disable-hibernation-mode
If one wished to disable hibernation mode to better match with the
specifical MAC, just add this property in the phy node of DT.

Wei Fang (2):
  dt-bindings: net: ar803x: add disable-hibernation-mode propetry
  net: phy: at803x: add disable hibernation mode support

 .../devicetree/bindings/net/qca,ar803x.yaml   |  8 ++++++
 drivers/net/phy/at803x.c                      | 25 +++++++++++++++++++
 2 files changed, 33 insertions(+)

-- 
2.25.1

