Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F65E5F1B60
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiJAJel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJAJeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:34:37 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60119.outbound.protection.outlook.com [40.107.6.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893F261D94;
        Sat,  1 Oct 2022 02:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHnHX9n8Wx40Q4Potn1nxvELh5cUwK4n2POrYZasxgkXPejfGYvvq88TAOANJhvSalUNQAnpYyEogkWeE5a9oU+NArQvbhL/b9mZRIsfT83yf/XDB/E8TekgG58cDsoJChkVghYRzOB+dOeoBFKbKB2WOag3elnHC1zRiA6DYm2Oy985qYgud+QX1wTWKyiAizP5BWfz6dBL5R0VetZ4MnSZvnjjeDZOtWwRpJ8FEpRWw+VV5Qdt4bDDRytkxHCah8XZJg5NutgM6Ne1T7OYAgAyiSms8IMKumHz4gnPIRU+RMEv832zVIsT1jxnNrIo3PNisu4xMmJ9s4LccA7IrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoXyDz4+9qRZwezaTzBlCw1QlFxooxmj2VWxTxgsI3w=;
 b=lUPAIRB5GyamxQQvVvs9Y/taDe/sEUEHC8crWmAE3PORvHuvyBBOkHHwpR2O1nZq8XrSJ1wYmUGqtbRcv+Ks2ygQ0Sr7R0JtH30tQB3sAnWjz1Cb0hDcD7cfwjDL944dmOZZ25mAOm6ZkKeHgxnw5k45Crg+EAwvevzsmrgkVSDPQWJoC1ME6+CE7Nls4DGnqgFcEO2ujuK48TCYvDo9Eue51hbC3K50lN22jiet15494+LukZGz9RatJldYh4IU/HJKPcb/MXOiKKmaxZceKroSDiXjrSTXIadwThvYPA+b49ifJhZQfIW4GWeLwDtJlWo7vHjLR3W9XwzuY2CGcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoXyDz4+9qRZwezaTzBlCw1QlFxooxmj2VWxTxgsI3w=;
 b=Jff8BXWo6C7Cdzk6zhJL7+w4bsjzbWBI8E51HuxQWfNCp3sKSvwgO8VP/lkSyi7/S2AYvsUruFb7LT4T2hVNYy8Gx6m6Xxk8fiaV5u5aNhvwD7C9Bt+FVWLCZEOPhisusBp1KfiV8uf/PYEisMDAMLHfPky3WRxNYe+ZnUq0j4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:28 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:27 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v7 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Sat,  1 Oct 2022 12:34:08 +0300
Message-Id: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: f93afe28-0beb-42d4-36d5-08daa3902243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOWGXUApc4K2R8BDw8XVTUScT3rutXoWoVMBs1sXbkeTTTtpVWZCqXb7F0ffANtlP4hIu1QCW9Ws9tTka+ZbIstie9MaqmAW5CtHMOy/pxttAej9DMpHE8Rl05klsbYbmkJzsWa0izhEeSP1GxrQeOCi06ZQUWFmzq2tHjA+Pp6P4lMpNNi5KBcosWro8pcENuVGythsCBAveKp2iQR588AOUnXKdKqVJ4K52VXTS5WCTdyFTmGP7PErnIpByvM/UPWLEd/fBCG1vzj2frzKyMnIWnCvS2MB+/ZLgmsWX1LvHDm8Wgj31Xqp/SVIzEILBYbY7+MBlQtc5Q0iCf1WLf5JRQODnIXlHTTB2SvrJanqzOHgU3pplLzQoMuVEl+KoaX1YGzmFxEqSNQnhsWYekoDxRnJn6wj/MrhPvrPwzkqRNKqo33ZRPY7gPMKlIO/UxS91qEk2H10tBl4xd7zcU0cS5d+DZZdd5RgjuhXbq48r10c70S7HOwmTSisuaICXHnk8tmCeAPlQgrbCBHoKA2WNAqXCURDLUbSnJMbImgHl5cRvunhElhiV3pWnTKArg3Yx3HdlQ/FNwLgtHyffMagZ2AfZDEcqOT7S6WbpZX72LIidl0o3J8MWmRt7F5BmdaKGth9HL5ZnnwWV6jt2woIKkhflycITFTzhTHajAhKdF2xHN70fODeLiCV2x3aKCk0Vm5KAKdspxMLgXn4I8tGXJYy0z4/5oWqlaUHVZqSZNuIy+WOnf1ad7eeI7vHs6iuywHGmkEC0Kz4jLoqAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(83380400001)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GXm/Qs2piqAGrt1TJK+ZG0HKFL74LeRQ6HPahp9Zko/ck0xkQm8sh9z/oakn?=
 =?us-ascii?Q?YshGRI7UJFQuflS3NYhrSIyt/40eMA2zwt+fYpgxAh0m6jLUPM7+wSF1caMl?=
 =?us-ascii?Q?jzJ5Vys+5DTZ3B7rs7Wj1yCp7ur3dq2Vs9v7DCPxrIQN4kYAYLgeqgetEwzo?=
 =?us-ascii?Q?tTkdiOAHK191GVSpz2CNeZSzJJh92Xvw/IbFt6BhMN0K0bcX+CdGWARFeZgV?=
 =?us-ascii?Q?kKNdhNJnXqSEaPxF6gkHbcAXFrcKhP+J6y8DrARdvHnQXmEJuCJOyLNzOcp/?=
 =?us-ascii?Q?mswf91hZMQJyYeg72dKetMloE8+erz0/+/cQ4w5CP3ycMAy8SBhB74wZsHA5?=
 =?us-ascii?Q?fc/8vmlVm+hNG9CdUDyS/ORNB7nMQTAn7S2bMwdlxEZp/MsVJRFD2d+97NQd?=
 =?us-ascii?Q?OowjUhKnLL6B9Jk2X91tRG5gj1DCpwUWnTmLpcs4zbtwlpUR6H1NbUL02SEz?=
 =?us-ascii?Q?vqr1zRlAPrJyiwnDQtdydPfi3HLVJz5J9eOmVY8SqePxuU+j/nUR+X2oDiaQ?=
 =?us-ascii?Q?KDzXAFc5SiIoT3LZCs2+3j6nH+d29jLVoVowyqWuMNCRoXI+H8Oc0nxy9nGt?=
 =?us-ascii?Q?lT1IaKB60xmsLpVYb2XQugpdpLMKm9CJe29JsQLW732yRr8DKBc9ncFhn+s4?=
 =?us-ascii?Q?2Gbrw7llDqoCnaLRXITn2fEiEWiEg48tnQ7ufZfgck8btV/heLuGCCL1L3qI?=
 =?us-ascii?Q?FhF9IqGm+2vxkRdQIrC3CE/ujcbCvWQsp5xKu+JXHOaIUxgZ2Imv/KPZz1PM?=
 =?us-ascii?Q?b6a9yh7LcgwzYkrU19d50KY6YFnEk2OsSdqNQj+WTCZ06nSROTt5gsiiAIFn?=
 =?us-ascii?Q?ydsO7CEr0PAmlE8qF53eW612WdTjQjAVg8znlyltSBFxIZGmi+PyeRnAnCoV?=
 =?us-ascii?Q?pqKXNkqkuaokK7CrPPv67w3ZSuqrn2wnX//4PlOXXJIDa9xCuZaIyjz4lJJa?=
 =?us-ascii?Q?Wl/uKW8dbR7a+4hbgCx6sHY08pcv8fUh34AW/eoZlrwvlXYtRYy1mmhCQvGN?=
 =?us-ascii?Q?npXVoJ1j51ifIePC3AR/DeQ6xS+taVKTrm9JRjPUY2NZHmHc6/sLFYPHjgo0?=
 =?us-ascii?Q?Rg1BBRgvElOKd7H4fuipqLBJwz1DWYkV+7TVRm1eh+n1zxyNtXJgD6rG+g40?=
 =?us-ascii?Q?zpxxZkNBgjt4Zra8JIUkILQ7xAaR1/0xvNIty3o1redMFnagsAVqq228lQk1?=
 =?us-ascii?Q?4fimLYVzYqIM6/2B9nu7uJaq2MD4sExJqIZ84iv4A7qkIBSA+JAO8KIaysyT?=
 =?us-ascii?Q?VIUZZJqDRjCLntSmLW3wXCdu6pkZJIJEZmjBPhPM+oALBP3Hx6aLZkuHywKK?=
 =?us-ascii?Q?5LJu+ieRK9f63rgnu4nj+8srTk8XCKVE5ftRY2pOXRxb0ANFdZjhBPVvWs+R?=
 =?us-ascii?Q?FrleDOEcXyL1A7Uqx6d66upHMCqlIGl6aaZyd9KXi2iqLprk14RdX1F0yYRb?=
 =?us-ascii?Q?IpEKbZksvQjElBdCoCyVhVIMIs9vjpw6BTfhYndRiTQRGBic8RfoFXkQq4kx?=
 =?us-ascii?Q?2KGbPilIwpgPiEW9UIhZiIC7OfgOI1zM9RX28b+YuA0eCOLKn7RJAQo/xJM+?=
 =?us-ascii?Q?4N+Kxd02SZRQ4D073jYTmI/sbq9eCaqqa3cZDQmhEdPU+xLBbk7Jmuu+N14z?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f93afe28-0beb-42d4-36d5-08daa3902243
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:27.3837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mgzMdTynL0+pzuq8gmroIIWhA0TLxpzouW4F8nmrimAFvlSIt1IMqkNuwGUT+n6o5e66U46JovaeRswhlQFHNtnCPONYj4hW0Q1I2fAdAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for nexthop routes for Marvell Prestera driver.
Subscribe on NEIGH_UPDATE events.

Add features:
 - Support connected route adding
   e.g.: "ip address add 1.1.1.1/24 dev sw1p1"
   e.g.: "ip route add 6.6.6/24 dev sw1p1"
 - Support nexthop route adding
   e.g.: "ip route add 5.5.5/24 via 1.1.1.2"
 - Support ECMP route adding
   e.g.: "ip route add 5.5.5/24 nexthop via 1.1.1.2 nexthop via 1.1.1.3"
 - Support "offload" and "trap" flags per each nexthop
 - Support "offload" flag for neighbours

Limitations:
 - Only "local" and "main" tables supported
 - Only generic interfaces supported for router (no bridges or vlans)

Flags meaning:
  ip route add 5.5.5/24 nexthop via 2.2.2.2 nexthop via 2.2.2.3
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 trap
        nexthop via 2.2.2.3 dev sw1p31 weight 1 trap
  ...
  # When you just add route - lpm entry became occupied
  # in HW ("rt_offload" flag), but related to nexthops neighbours
  # still not resolved ("trap" flag).
  #
  # After some time...
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 offload
        nexthop via 2.2.2.3 dev sw1p31 weight 1 offload
  ...
  # You will see, that appropriate neighbours was resolved and nexthop
  # entries occupied in HW too ("offload" flag)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Changes for v2:
* Add more reviewers in CC
* Check if route nexthop or direct with fib_nh_gw_family instead of fib_nh_scope
  This is needed after,
  747c14307214 ("ip: fix dflt addr selection for connected nexthop"),
  because direct route is now with the same scope as nexthop (RT_SCOPE_LINK)

Changes for v3:
* Resolve "unused functions" warnings, after
  patch ("net: marvell: prestera: Add heplers to interact ... "), and before
  patch ("net: marvell: prestera: Add neighbour cache accounting")

Changes for v4:
* Rebase to the latest master to resolve patch applying issues

Changes for v5:
* Repack structures to prevent holes
* Remove unused variables
* Fix misspeling issues

Changes for v6:
* Rebase on top of master
* Fix smatch warnings

Changes for v7:
* Rebase on top of master
* Refactor: use "fib_lookup" instead of "fib_new_table"+"fib_table_lookup",
  according to Paolo Abeni suggestion
* Refactor: use "rhashtable_free_and_destroy" instead of rhashtable
  walk, according to Paolo Abeni suggestion

Yevhen Orlov (9):
  net: marvell: prestera: Add router nexthops ABI
  net: marvell: prestera: Add cleanup of allocated fib_nodes
  net: marvell: prestera: Add strict cleanup of fib arbiter
  net: marvell: prestera: add delayed wq and flush wq on deinit
  net: marvell: prestera: Add length macros for prestera_ip_addr
  net: marvell: prestera: Add heplers to interact with fib_notifier_info
  net: marvell: prestera: add stub handler neighbour events
  net: marvell: prestera: Add neighbour cache accounting
  net: marvell: prestera: Propagate nh state from hw to kernel

 .../net/ethernet/marvell/prestera/prestera.h  |   12 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  130 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |   11 +
 .../ethernet/marvell/prestera/prestera_main.c |   11 +
 .../marvell/prestera/prestera_router.c        | 1119 ++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.c     |  366 +++++-
 .../marvell/prestera/prestera_router_hw.h     |   76 +-
 7 files changed, 1683 insertions(+), 42 deletions(-)

-- 
2.17.1

