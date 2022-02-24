Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191134C3488
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiBXSVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiBXSVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:21:33 -0500
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (mail-lo2gbr01on2103.outbound.protection.outlook.com [40.107.10.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764D42556E6;
        Thu, 24 Feb 2022 10:21:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwWDqenR9oGI1ddNqxzUqqeutcHHqpLq47Iy7JSmDtCccsdH4i50pzMC9fMsNhHpwzj+/T4GBIx534gsSgWgtVXlkPMjDR07JXCBMEmfu/KAUZ+Q4AWwEgKpTtUnc88UHQqifnUSSWSXHBSjtgOQGMoF70Ksn0smVMb5mlPRXzx9bWpkqL7/mudqE6/CY7YX0tqHO9pxMFn9aguo9jarJ3F+M41hgDDuiMdheDdggCrLdcJqF3DwneOpIQ6yHY9gzowAyvruJd6oYyn4ZTSpJ4qj6RykApJK4qiZO1mMxRUwmgW5c4ub16Wyu41gDhfsvZIh9g/KOiafdiEs7IbriQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvJL/Rl5a4/8xX594oIZyo0VOSWR4h4mBtXQILsDmNY=;
 b=My7doVdpvn0IOy4tEc0H8+4FjWf16SefnprB2WprLevE+5RyVVjxgNJhPt+b5n5AeZMg7EexFwIbp0/glvVlQpCsfEuhWAXwNl1qSGM+KnPk4JeOjepPMbLL6nmmLKcPO99QL+6jKoZXOC6JQuJ9oRclPQ8NTd+hTy5qh6uy8Blckl3Mu5rvm8RYd0TuFjY8Fz3R1Ao0CeFT/us4BKVIeVKd58D51LvbMsYB6aDvRJ3MNQJWJx2u5fkmw7yDZHO++EV0yRYXrY19zM5SvW6v407Z1j69hxsODFuGuw4YaroAmPqZVoUnvYH2QK9/ACCYDqI/a4xAHbYe93sRMuWG2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvJL/Rl5a4/8xX594oIZyo0VOSWR4h4mBtXQILsDmNY=;
 b=nGtG5bZQPY/65KUl1/TrykhKB7zPxvuwMWUOVCT6ckVyqkYTzzRHvcROi4ccfxDTbeAqRQ59elcu7NR+v0QMA2dXTZrHV4IZdteOvFlgBf8pJN3YYXMeSENsPiSbiWRQ4f174BNWnDwqz9A4ID3UspV0e9+xHxohnTBeDcs8smc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
Received: from LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:15b::5)
 by LO2P265MB4631.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 18:21:00 +0000
Received: from LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f9ee:fbdb:b1e3:1a75]) by LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f9ee:fbdb:b1e3:1a75%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 18:21:00 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH v22 0/2] wireless: New Driver submission for pureLiFi STA devices
Date:   Thu, 24 Feb 2022 18:20:05 +0000
Message-Id: <20220224182042.132466-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0229.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::18) To LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:15b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ff28ad1-e2d6-45ba-0449-08d9f7c2689f
X-MS-TrafficTypeDiagnostic: LO2P265MB4631:EE_
X-Microsoft-Antispam-PRVS: <LO2P265MB46315688D71D90072C8F2111E03D9@LO2P265MB4631.GBRP265.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EluTHZhlsP+Gn7AyPlRg5aTS60D0mi5G+cEdsFnwmf9z66/ICEtzX6KksQ+1598XAic5CF6aDekBr+0JrV0jQEFp97A25fF3/5PqiJPKdN8i4OC4dq1DnyFy6FI5wy7IE4pR0QqES8zRveYs5/br9lii3fxTtGiIxJu5NziINF+9tDUDz27odJJbL/UrgZeOp2dXdBF4/JZ7j1zXJ8xlypeyx4u2n+BPt46aspM7MfThjmV9rXoEWxSGOqZSDlqGnmvcaWNb1L0Tu7/a0Rpq1EQ4Rgqx72/+6qDqEhNRTI6Dg7i8DhcOkhyzJuOdM/wZt3gBSDRHwzEAj50tAfMKyfobKGlITprCFfnoCK6IR3b0XEiNieylDlkvsVPNC6oRGso1r23ND9qD17TasRbMcW+umP2jB7CGBdbcBSpHgJUCLDhfd8Y9mEwJGZ6PHGrdAYcLmKQImZebXmd27exkobSLw8404U3PEiMdyTDALFwUYR4Fr3dKGbMAaA1MJhOB7QsWrfpTG1RxbbZgtFZfqH+MQT+N7VKoVj0JeMD85FI8YxUJ68DBVzgm1oEW5gEmNGYoBdO4oICnAEd5k8c2ZI4QsSR9mkEdT8Pr3bIpxXVA+oDb3PFN4H3A9Fvn1cqSjk+dB6XUTi5GLoJw9RGBJFqnwuSRjVmo86bcElomiabgJ1Cgj4LMRqOYhkQoGi+nbeaSKt52FEuR20Tdy6M69tVYduLC4v+BYN+7LhXnMsU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(66946007)(36756003)(5660300002)(66556008)(8936002)(86362001)(52116002)(2616005)(54906003)(66476007)(4326008)(6506007)(8676002)(316002)(6512007)(1076003)(2906002)(186003)(83380400001)(508600001)(109986005)(26005)(38100700002)(38350700002)(6486002)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwWmgVAjaSuihBAbbz3ppeweCNCvQpk7L4DPs90ldGuHNKk7LaytCGR7uR3o?=
 =?us-ascii?Q?xSv04OPpXPNx3wHxtkZfV6B/FIXz9p9/ATUHOrm/aPe5l25bL8n6DKJyZFsh?=
 =?us-ascii?Q?gKGj5/q046/uewP0cQeWg74Uebf9WgcjqdQHCHXVu8jpcFpIFMqX31aljqBn?=
 =?us-ascii?Q?tly0DOHffFVN2m1XBDg7DTQfzFnkfojYh54vCVSEreskCLWDCBBTVnSwfrwV?=
 =?us-ascii?Q?1+lldhTXuJiRk9J+RG7W0WaRJ4Drx3RAZ67QTmyqzCVnTEbMCVu1CztxNGVs?=
 =?us-ascii?Q?t5pKu1BIUSU8+nc+HyOasKqh5BF0iOb0f6RL0YDzl9RvcZlNrcj/L8tPPh+C?=
 =?us-ascii?Q?ibZ4SEVtvnt++vFHBwxYlE/Y+5Ed+zmGLFOUFtHtRzJavH4lTMGVuiaqflD8?=
 =?us-ascii?Q?zzSzWG6CydPX/xQvWTTiczObKoB2RLe/p6753HMh19oXgaOSo5qCL/lA9fBq?=
 =?us-ascii?Q?6Q4nWkHTrUsn9FvblZaAhW6o7BsPPl/k4F1m27WxHEy0hg4g5XFK2HeT378b?=
 =?us-ascii?Q?OHhh2Sh0yeux4U6XfDhDYc+Rfzz0XkXS94/IaxnJWD4yWuWsIr1NZPSZWMa9?=
 =?us-ascii?Q?UmekJmSNdmmhBvve7D8s4L61nwmhE9f/S8Oa6hWqiYl5YNsg1xP3xnE7QRHA?=
 =?us-ascii?Q?M6MbFCsoRRUWweMf6TEpsth/QlRSMXcvY8nP6V9uB4v6XvY0rkd8dmRxxdfy?=
 =?us-ascii?Q?nY0MOe5mzyqAplsdekC01AYPmVtphSTJou5mKZq12JAG6tFCj7MPwu6neYF4?=
 =?us-ascii?Q?MqLCHOz1uhXMryRFBN1JlLbCFV6Hse3vnsE6mtJCc7sucddlTnXYuDpK8u+L?=
 =?us-ascii?Q?cdUSx7lPFC5U0EwtRBU9AtpJB+FPBu60GpMH5US1j8xydoOFYESoZM3H1Ftn?=
 =?us-ascii?Q?hSLkyfkDyyeDQWZ264cg8N2TW0kekw3JLybFts3cZetzSzyTKzWn06WrwoIe?=
 =?us-ascii?Q?B6KxJ6OIUF+TggK1Y6oIDbqXjQR2YhZUo7KjNNZjUDOEOjnqTWUQtQToBYzW?=
 =?us-ascii?Q?+3pFIl6KGAReGKO/6+EHprClfin9hCtxBPFBX3I1LF3AJ6aXGUvYjUQ4BXsD?=
 =?us-ascii?Q?qN1XuGse5+YfUDN+UDhuMTPcXpiARQTnRTIXlcYCvdtoUH7Za71Thduwv202?=
 =?us-ascii?Q?+btNpmFGyza0FgfaqsXbyHDGDOvbivBYn5ZDnmjygfYZf/PML/Vw15lKnpSC?=
 =?us-ascii?Q?U1IXVIZ/tIZo3hBD4m3oahAo764QuUgpkhqXy/fY2xDciUlr4hvzQ1gVHt7T?=
 =?us-ascii?Q?3tUPjAzhBPjfFyU9qDj9LDOhmUQTYRPaNp2LWFUkIKjYl7EScoqpiVer3StJ?=
 =?us-ascii?Q?ZuwqnEtK2aH0wWdu503Mmw2Sw01JQt5hFoaSdpeZSF3NMxa8Ad5q4UMkGupi?=
 =?us-ascii?Q?5UeVZfoWsh7a02Q0UQF0buYYgh+oDygEfCSnvAwtaEqYFrR3o2M0WGiHXJMd?=
 =?us-ascii?Q?SsYFMHNj7Vsh07YDDMxD843DsFBotEu15onvpr2ipf+aq8LGiDkc9WAyYFZI?=
 =?us-ascii?Q?RBYegx+6yrZsDYR3QhjTMkFvQSCnQ72HLFgqDkwXBLxCyYNcFwlETNFD8CCP?=
 =?us-ascii?Q?Nd89xjpQ6inJ4a0Sccl98wTdVy386R0PbSQY4gJ3H4DV3EFWjjVLIH4aVOiI?=
 =?us-ascii?Q?M1EDdN/ghZWY4H7JU1QJUos=3D?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff28ad1-e2d6-45ba-0449-08d9f7c2689f
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 18:21:00.2635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QU3FttJ3SpMJatsQR/bzWmDS46SDApxPZHKB4fOl4wgRgiPCzmi3PwQgfPMf8my43Xreet5nZ6S2jlbhTAUesQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB4631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
and LiFi-XL USB devices.

LiFi is a mobile wireless technology that uses light 
rather than radio frequencies to transmit data.

802.11 bb is focused on introducing necessary changes to 
IEEE 802.11 Stds to enable communications in the light medium

---
v22:
 - Fix function names to match driver
 - Change non constant global to per device
 - Remove unused workqueue
v21:
 - Address style related comments
 - Fix static analysis warnings
v20:
 - Remove unused static variable
v19:
 - Fix kmemdup null case
v18:
 - Use light communication band 
v16:
 - Fixed atomic variable misuses
 - Fixed comments spacing
 - Removed static variables used
 - Moved #defines to header file
 - Removed doxygen style comments
 - Removed magic numbers and cleanup code
v15:
 - resubmit v14 of the patch
v14:
 - Endianess comments addressed
 - Sparse checked and fixed warnings
 - Firmware files renamed to lowercase
 - All other review comments in v13 addressed
v13:
- Removed unused #defines
v12:
- Removed sysfs, procfs related code
- Addressed race condition bug
- Used macros instead of magic numbers in firmware.c
- Added copyright in all files
v11, v10:
- Addressed review comment on readability
- Changed firmware names to match products
v9:
- Addressed review comments on style and content defects
- Used kmemdup instead of alloc and memcpy
v7 , v8:
- Magic numbers removed and used IEEE80211 macors
- Other code style and timer function fixes (mod_timer)
v6:
- Code style fix patch from Joe Perches
v5:
- Code refactoring for clarity and redundnacy removal
- Fix warnings from kernel test robot
v4:
- Code refactoring based on kernel code guidelines
- Remove multi level macors and use kernel debug macros
v3:
- Code style fixes kconfig fix
v2:
- Driver submitted to wireless-next
- Code style fixes and copyright statement fix
v1:
- Driver submitted to staging

Srinivasan Raju (2):
  [v21 1/2] nl80211: Add LC placeholder band definition to nl80211_band
  [v21 2/2] wireless: Initial driver submission for pureLiFi STA devices

 MAINTAINERS                                   |   6 +
 drivers/net/wireless/Kconfig                  |   1 +
 drivers/net/wireless/Makefile                 |   1 +
 drivers/net/wireless/purelifi/Kconfig         |  17 +
 drivers/net/wireless/purelifi/Makefile        |   2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig  |  14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile |   3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c   |  95 ++
 drivers/net/wireless/purelifi/plfxlc/chip.h   |  70 ++
 .../net/wireless/purelifi/plfxlc/firmware.c   | 276 ++++++
 drivers/net/wireless/purelifi/plfxlc/intf.h   |  52 +
 drivers/net/wireless/purelifi/plfxlc/mac.c    | 764 +++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/mac.h    | 184 ++++
 drivers/net/wireless/purelifi/plfxlc/usb.c    | 908 ++++++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/usb.h    | 197 ++++
 include/uapi/linux/nl80211.h                  |   2 +
 net/mac80211/mlme.c                           |   1 +
 net/mac80211/sta_info.c                       |   1 +
 net/mac80211/tx.c                             |   3 +-
 net/wireless/nl80211.c                        |   1 +
 net/wireless/util.c                           |   2 +
 21 files changed, 2599 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h

-- 
2.25.1

