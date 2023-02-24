Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F66A1EF8
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBXPw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBXPwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:52:55 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F4283C5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:52:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOES+fu4DyGOa0XwxTavAi6pP1FIr3S/KZA7By/+aFfZeX6QEMAdkDBNZLJb8bhRpD6aV91QTFEtKRl+4MXWvuKggd1E0oRDc5R2qzLMven3Cf3ibcafymV0xAYSlDsq7hx9vvc/mh7/VnGKK3D6XTGyKQ3L7d5XF1ZlpvxTU71WoznlgwZ+o7A/vs6nYXF4l03haBn8bmL9X81w8FOOdV+7wQgU8BtYtttEwDbbLIzal0MPfy7RXULN4R+R68rWRswPMP27qiDG+kjfiBZ5JnmWMAOjJdeAB4dXIjFDWI+gfnYx7T8AERYZU3Vd4X6+0xpr78Vm2ZOZcv1VMM6X9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQjs8snk11H4Rou3AmRpHFdlvcUWh6WxRI2b+w6eHGI=;
 b=U/C0EnWBc1+Bz8E1PXY2b9sO8U7EraCfi6qVafb3sWG33CLd9R6HSXxpuJB9C+/eGP3z5DcKBFrBsGmSuC1zcBwPBW0gO7q6Bb3dUxm1pb5a247Lc/dCpPui8sDnPdASUqhyaFFFZCXBJC+opTnPCxjV1+549waQyCD9EqXQdLqK0+mJeGYRwpEXIlQ3m6bLydDkB0hZXQkzAdH493J2MLXk97/oE4lBPwfQTc+YmFIKQZpwN/BL75zBZmswbT0F+04VWXnzKXH41vgHqClL/lj8otVIfiwJ78fTxutUttF7sL0KbZAVeX5o7S4a8npKaznhIl19BfOe3nlc+AsIbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQjs8snk11H4Rou3AmRpHFdlvcUWh6WxRI2b+w6eHGI=;
 b=poZk3jgTktxJ/iNPdy0gKjyp1qi4UtqvpKPeQRwGrf/JAUmFdh6JdRirLw8K96o/0Obk1PPctYfjzhVVmOnjLioPw7Gw56UxTxxDmIzKAQKHSWi+jxvlbweQl6XdDks0EzLgt2ZwcHgKByBj62BH6sGKFSzmX80Wyjlq7G+wRyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 15:52:49 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:52:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net 0/3] Regressions in Ocelot switch drivers
Date:   Fri, 24 Feb 2023 17:52:32 +0200
Message-Id: <20230224155235.512695-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: bf8d6f65-2c06-4da7-4c4b-08db167f2e2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vkud2elVvIu1AgoS/fg0q1U6I1sCh8lk7TyJgcxaiaY5y0E8Vk3ET98r3Bji3oUFVrxrKDfHqr9sqYfOJOHogH+SoQ+6Y2CFa2vG3Gge6lnqRHhnHJvWaXc/va5rFt2G+RUEBqiS3+NqF0N0RPCwwhvAKcunoREWJKPo/h8M10hxTOsS2zw0Wukb+PHOccZRM1IYkKtJHhFVliTqn+NguMmyI47Jh0P2fsrsv7ZVWWb1TJv2v1R4oCiXGdE0gwemb8wcOlmEY9Wn97u69Y/ZGSRZNQynv6OrsDfIuTXLRfOOcwL8P0TCI2w1xnSsb+YkbX1S5nMB7AvJgvoKEIwdqQSPnsr/rt83PAEp/LvfQeXdRO21mBA8ahWo90gIGCuRzlPhhz3J2TWYcOzQLDHSs347+LTonsXcoeJcuAINoaR8kf1V9UxHq6dgTMxbUwXYTQvz/StdTlJcbrR2C/gi/G8l4TOqKK74qKLHpYJbcZ0FATnsejbMmmyWJBYht6BxVQnjQB/6Bu6C68P9ipvUg4Q+m1VzIUNtwOkjI4q6laj1s6UWitdxjzgRGDpxxgbeMVMJzzqwPqQQoWOZ+o2al9qEgKvRxJTD4FJa0/UCD+TRWDvq/yVMe7jmW8UymTIM6mpl8w7iH13Pu7C4jeJYelOrPDydN4xOzzKAL0cp6r0w16EZZwJJKEEFCTQezdM8ycZxp8oGG+UkL8D2nU6XPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199018)(8936002)(66946007)(6916009)(8676002)(4326008)(316002)(66476007)(54906003)(6486002)(7416002)(2906002)(478600001)(4744005)(52116002)(41300700001)(66556008)(1076003)(36756003)(26005)(186003)(6666004)(6506007)(6512007)(2616005)(38100700002)(83380400001)(5660300002)(38350700002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RlHf/svxQ0h/9mH5ESmoI5sp7WDINoHzhqGWiihmB/EhjXQeo04IUaDQc5WA?=
 =?us-ascii?Q?iWzOa6KPRyl6RC4ILDkWO27IltFidd+FxDMhpn4cKfgaDIf7v8HePhjGBQZC?=
 =?us-ascii?Q?rGYwcFhCy2Lsq7wVjVUdZxh1RMl+UmOl7EEoH9HFjHnX8olLa2lNG8fK19Mx?=
 =?us-ascii?Q?Y3qKc1RsczhS8+Izd23e8aht8tgE4PcTmPo/Mx0F+yAOJOBCze7QR51+uWmC?=
 =?us-ascii?Q?1Xxq4+wD1HCSa8y/TemDbDSrN+q3EiPcHOb31DSRaSjbCYBBWVge0nRhbE+a?=
 =?us-ascii?Q?vGWGuBOSPXVHzTD0BLgZA5vYavkGVrohYOjxu1SAVhTuZ+dicHWeWi0OGhX6?=
 =?us-ascii?Q?pKuFF+ta+GhSm4HpkuABz+jpSKJ17urejqdxHl2eWr+MuiGBxD+xAJO7vinK?=
 =?us-ascii?Q?rfRkBfCNgEmJHSaXCugfwVBJUgdZPwQVamChxF3ulBeOkP0KZ08lXCUOYjbt?=
 =?us-ascii?Q?Q9aAxTg2aYuC+q+VsdiJ8GK6GfBlKh8U/RzBOdjEydPcd7jo2fZhnMjNYmtw?=
 =?us-ascii?Q?mg268VSCI39LEIwpgOcE4Tb2nLbpnJbAAoSkXUkYox/qW4ruN1W8+Z5jPBOF?=
 =?us-ascii?Q?/Ko26rDlMYHlyQcpPyPTl1+ujsk0qVOcO7oC5DAF9LEBA41PLGE8xVg2rJho?=
 =?us-ascii?Q?qLPAlmU9H86+y0Vbqtn6ryToUNdUVzYXHjpb3n1gP52dhlfIPHNlBXPm7rZd?=
 =?us-ascii?Q?mNInYX4ylhsup4l+W5JCk98Xp4DSMlAFy/VujqsyWfydPX0uTzguJCvrjULP?=
 =?us-ascii?Q?Hmq2bwRM7gO+FtJAwEZZulTlyg0T1T5pbCDaWf6lv2jVrN4mgi1hjQl1CRMB?=
 =?us-ascii?Q?NXbNztCoWjWi2HN17Q3hTw1oPAHKn88pmcpZ9iHCMonCnoWiUPeNodwJaupI?=
 =?us-ascii?Q?UuvK7zVECCtnHaRA/fnsPrhdfzuRkSCmGjqM/waSjo1OvUXjbgBo5C4UaQZv?=
 =?us-ascii?Q?ysHi3qwUlsOc0FU0qffCtd2JmTpW435im1PQ92jmZgYRb7zV3B+e56yJxY1b?=
 =?us-ascii?Q?dIlZXORHwvE7I8Y9Pj6xOo3z+zWsULTcKtWZmlGmmbUoely68b2Rsq5YNa82?=
 =?us-ascii?Q?209cC+y7tQ131NxQXg4d6bEMPkqCDuTIe2N8JZQCQJHUs/XVaD2fGncbQQeG?=
 =?us-ascii?Q?O5khE8lVSFi17M0Kme6fL0sDh3yuHESqNV3bT7knkaqKjDAuG+EGzW2ZdoWD?=
 =?us-ascii?Q?wAVG7gOYuT9YqMdbvEokjT9VoY/4O+qvoklN3vp+gvz3t5EXXLQXZzfRSc1O?=
 =?us-ascii?Q?VrloEvMGcCMtarx6Q4GNe1Npmh48ulw1Vd5t4CjxzRVo81Hq/re5YGcPrrmw?=
 =?us-ascii?Q?BmEJIe5OsYLuKW2F4Z8msYl9HymXWn0K2fkMsdwjiS5RjEPgbRsDeYpVKMAQ?=
 =?us-ascii?Q?hzxt2w7Ge9zo6nQ/q83L12frEcfD7ByEU3Io46tjEokgQl2vdFiN5DsXjUHz?=
 =?us-ascii?Q?theNMxmr2odGVQRJdUvYv2T1yCi0Nv0xsAC1SQf1PITLs3m961O7nVJ7Lfke?=
 =?us-ascii?Q?0UpRTcm995winP7iRax3xZyJ0qmBazP5IIe+6VNR/rHu/cv7iwsTyGMPXSWn?=
 =?us-ascii?Q?7kUrsooc2opOQYGtImzFlaRnrpd86sR8+Jd7emOnvAif+njihDOmDr64j/uG?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8d6f65-2c06-4da7-4c4b-08db167f2e2c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:52:49.6401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGSWcwMR1YwJKmb+IUjVTD4Yn3yxnyYkDZld0Z4frmzEO7FRjnUnA2gph5/2KBOBaEkjzJ4naEIq+yx3iiEQew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are 3 patches which resolve a regression in the Seville driver,
one in the Felix driver and a generic one which affects any kernel
compiled with 2 Kconfig options enabled. All of them have in common my
lack of attention during review/testing. The patches touch the DSA, MFD
and MDIO drivers for Ocelot. I think it would be preferable if all
patches went through netdev (with Lee's Ack).

Vladimir Oltean (3):
  net: dsa: seville: ignore mscc-miim read errors from Lynx PCS
  net: dsa: felix: fix internal MDIO controller resource length
  net: mscc: ocelot: fix duplicate driver name error

 drivers/mfd/ocelot-core.c                | 2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 2 +-
 drivers/net/dsa/ocelot/ocelot_ext.c      | 2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c | 4 ++--
 drivers/net/mdio/mdio-mscc-miim.c        | 9 ++++++---
 include/linux/mdio/mdio-mscc-miim.h      | 2 +-
 6 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.34.1

