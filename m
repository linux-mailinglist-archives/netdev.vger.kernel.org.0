Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA2E6A1F28
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBXQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBXQAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:00:08 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0C043469;
        Fri, 24 Feb 2023 08:00:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShaTZAf3MIDkS3nPBkDD8moPNMhJ4CmhdgIuMDm/erH0F5F/XourBqxi1QkGm6S+TScfg5piJd6dW4Oyfns+ltWTSebj7DP4wDq5KQLaC0aBcK7I+uJkCbcWE88S+a7eCEvsZ07m2QeWHX0jIZSogOj+O50LlUSNXa9TzsfB00j7cOKFxtEC9iwlZ1YjI1/+d/YIFZGKx0ACco5PBTmc1tyzHUPE0N/GXjbvkTLRu5TTbxIoY2xSTY9nlo0fG+q/N9+TLl+wbD1eAqd5Jx6PVk2gbn8n2ZFIPRB9DxQXLSV8n4uai+Je3Y+8d9Mxd0BKb9kcBOkUP5lwUFFVpMzTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09jkolWQ8SFF6/hh0kr7jckKXkRPDS38kWB46HQzURY=;
 b=PR4iEsjPN9+MgGnYCov/ZZSglZeiYPSPuIL5p8W+QPLuG77qRnZMbQoQKmoO2m/tCCoevcmG/JlyZ90ZhRE6MCiyQE9hlc1RhzP9pGcAwZU6VfFKgvt0B6/IFSQVjWc79YntdUNOJQzDCmmh5A8DEtYkd93TlDm/imGu7d9ox0o/lYSFtM7u5Y7ycU8yd/QsrkcNvP4z73VNgIpdT1TycD1sdzMqKgX9dAp0FNfG4OqLuWR9oxLzjEe3sIsjPBAlbo1nb8J1simvRxFbwvGYP4W8GRvsyS5jLij4HA9vaUPBTW4e9ceKVJnWyLimzox+TKG3QCbtbQ2/1m0AEIhRyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09jkolWQ8SFF6/hh0kr7jckKXkRPDS38kWB46HQzURY=;
 b=dgegog5KPUhDtXG+DBfV02UKRriMchh8eDMqkYyiEbe59wG4hDXMfTSt4NDz+rpnwncYEg2H3NDK58RolZvSwsxKXUQGjofgqYYr3UuwsNh+0/d9tRP4DYXzJ+SF3EV7YE4Hp/0CKf25m+ZZ26Gukn5FPstsHQawh0HX9/yUu7s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB8003.eurprd04.prod.outlook.com (2603:10a6:20b:240::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 15:59:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:59:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Maxim Kiselev <bigunclemax@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/2] Freescale T1040RDB DTS updates
Date:   Fri, 24 Feb 2023 17:59:38 +0200
Message-Id: <20230224155941.514638-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB8003:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f119b3e-7e41-4875-34ab-08db16802d6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0zSFCdKvpd53Ou+KRi4NHQE+2chhbTOClXFFz8rpzHeeSuPdcWb8FzSJevN7okQ4UVxyLXwn+BHJ5f5bSplRzH+Nf9XfOC97EivnOJCZMyugWKwikTog8KlzRkmPD0HnVNKeadtxHqNkDcl9KiM1tLlU4RYPwpLXuPYkKFBLVAfEM2WwH027788/EQ9eIn4Xj+QTGAWvp7Nk5dlMzpLIJ0+gnlF1Dpf+Qfs7YTtPmMLO0Mo3Pwii9sp+3NTPvOolwOyoKzcEXE3YnBpf1Tzwe2AeCJYxMNVG/pSTriwkKUyzpS6eNKx2D5vTongABtnMyriB57lM4m+NktXFTkpmAOuwRLicfTwZUmWhOdoZXdp+d9WjUiSOhnj5s9nN0SK7k4h1quk1l7SMsinlt7Xp+eG3HUvmFS+3ceDxW4oVdcaybQoL10MIU2UjgPQr1wG+z5Ms94cFstGl09iMeSIxgQJEA6PchyLR7+dePZaBLvN6XDELH1vedC1IBitfjMfS0P2OgXGM52pskrL6u6LFEQDneWUvImvAbTAs+aVvJCi8uxO2GoARDhzkP960/7hOxpzvRzvN2TfypeJ+8Ii9E165Nk2mcVfrk/KUcQ7eOrQ/w/JjKKQjxoEnz5lqtgIW0aVB3NLCyJE+uW8D7Lr2KCxLvmTg/Ko2Y75GknoTPiUEgFHji0cV+y6biEBhoud9C1Xl6UkjukyZOamcy9E6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199018)(66476007)(6666004)(36756003)(8676002)(54906003)(478600001)(316002)(38100700002)(38350700002)(4744005)(86362001)(7416002)(2906002)(15650500001)(44832011)(66946007)(4326008)(66556008)(5660300002)(83380400001)(2616005)(52116002)(6486002)(8936002)(1076003)(41300700001)(26005)(6512007)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eScluuPykiNDi0X8WNgxWYGwMlozdQGnTFPsIRkbiiOP61R0F7gepnLCFsKs?=
 =?us-ascii?Q?NR2Xjn7F980QSqU7B0Rd6mNu2Le91b04h4I36EV6EE46+jx2X0Vh2MIrK7By?=
 =?us-ascii?Q?WENvgFnm1N5U6VQMdlMY0rMfpiLFePseUIPO16PdDa0rhRiRwKRX3dpoOk9X?=
 =?us-ascii?Q?q2kcMAyt9gXpZjukQJtjIwPP9w6DKsatwqA1fEDmb/X7LOY+LqG6EFyvpRjB?=
 =?us-ascii?Q?EhBiEPxvtwRFW7obKJQI1VyuOVrVuyy4svV3xZHuEIvfqnEp5FZ3J6RIOQ8l?=
 =?us-ascii?Q?TzhPWiCkZbmw6PncSwATNTGAfrJTRl0KzseTezZ0U9kwkte4k9AvrWoQKySx?=
 =?us-ascii?Q?MOWw2BXoNjtiyddXvV7aglHjNpDdR0KQK7eOkEN1YxzYwVhadb7oUBj7Rs/U?=
 =?us-ascii?Q?SbHhW/8hC2JjMlkF2Hb9zZJZb9nE+haXGCgA9fYOYV4tdDH5tc6vrmba5yzX?=
 =?us-ascii?Q?zsKgvKlh9fO6cbyU+A/TD6EkBNpP6lbfC1jVzn0qqmOuS+7EAe11LZxZP2pt?=
 =?us-ascii?Q?cESz38j/7yImsGIx7Ur2Echg+ASbr1F64hVYIpOpgyHpkvQgiD/N8Z4i0S4K?=
 =?us-ascii?Q?5+NrQkfYL4gplU7yGrDl67wrdbJGsd4skvQS4/Qn/tTx5q9dmWw/9ynLGddi?=
 =?us-ascii?Q?3AWxySRym2XR1Wt6sSxkh7jZ2ky6067bz2ob7IO00LZxGKMX+LFRFyhfH50S?=
 =?us-ascii?Q?j1w7K8OSRjS5Wc8V2pwv543BLI0BifPvCPKyIN1dc+rKMmrNesm7npIj9JlO?=
 =?us-ascii?Q?9KIxRl8qETooC8QnvazPAs5SgGvBHAGnCrdYOG6+6inHA+mHBroKxUDnnDOy?=
 =?us-ascii?Q?btjpVmPTUjy/iJDRt7GR70f7igQRlbEO1dTfa6RI7w/3RQiZGtVA94n5pVaQ?=
 =?us-ascii?Q?15wvJ2/ZE8lBTRameHvMnuKu+cRPqswzYrEzDKmClJf9VrI5q9QXlQfxerNX?=
 =?us-ascii?Q?zI4tOr+kmXoeh8TXBkyTvS/lUUYk/XMlOUBy6Is40YAsE4izRDzJQMoVNkux?=
 =?us-ascii?Q?B8TKd3WzBu4F5aOrJW93hozwWcL3MoikWsfIlht05YbpKa3HL076yR1H+KVK?=
 =?us-ascii?Q?871hs+tTj2y2SCqt8rY+WdPpFE9REecAi+fnzzTvORLfLj5CpUL22zCpUcgo?=
 =?us-ascii?Q?pyk3wweWpsGiEOac6ooli0p7VHBwWjMIMCv0hvF39U11BYHVg/EHWw+rQi9k?=
 =?us-ascii?Q?TJeyVjflMhOw1Kc1SXB0GumycB95XPMSBYI5/iBtXlnPRpLwrZkX8AxIOit+?=
 =?us-ascii?Q?FJgFahmQsF89dSGGULrq4xN57VmbXsQ7NC8mHr2ZoaJFWd8Itu3DK7Y4MkAt?=
 =?us-ascii?Q?nlx5nC/SGcW2G+GjPd+TaqGhIUvh9FqJxqVwZeOIGdm7esFwMO1VI1sklMaf?=
 =?us-ascii?Q?SmXRTBLgORrkG5O/I7U9Bn87c+wlmwJFNAvu0a7fxi/ym1Xga3UdBqreLuZq?=
 =?us-ascii?Q?M87hhRe3UtfMhuTEBaVqGW7FaCgt10MVSwDJqkUzYjnE+gz/Z9GuVqYrBT+T?=
 =?us-ascii?Q?V7WlUrioeBsngB7L8tfNJ5x3ZILQJbRLuIPos2JBFeUoq3mq/xeiVg7RDPyh?=
 =?us-ascii?Q?C6pSg61IykGG63mwEZRolckf+XnnvZz4DZYJ2l2HUrbEEsG1TP9Tehpm/1Ss?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f119b3e-7e41-4875-34ab-08db16802d6d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:59:57.8688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twEOLj33Yx+6I05m2O6UkKfxwspSEaHAySlCPO5WPkj4nvj+t13nRCMsmdnRdoSydE3bbgDoHJuZasZvBjEIew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8003
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This contains a fix for the new device tree for the T1040RDB rev A
board, which never worked, and an update to enable multiple CPU port
support for all revisions of the T1040RDB.

Vladimir Oltean (2):
  powerpc: dts: t1040rdb: fix compatible string for Rev A boards
  powerpc: dts: t1040rdb: enable both CPU ports

 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts | 1 -
 arch/powerpc/boot/dts/fsl/t1040rdb.dts       | 5 ++++-
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi  | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.34.1

