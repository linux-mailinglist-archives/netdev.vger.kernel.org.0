Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9024C56D06B
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiGJRWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGJRWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:22:37 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60113.outbound.protection.outlook.com [40.107.6.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CA6BF63;
        Sun, 10 Jul 2022 10:22:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGRGLWJdN91eAoCZYiw1kPQfc++GxmtELqW84kcXiv4HfxQyOxz2tux3/6xJyB3AuXWz9zxlN+xzUnsT5Ky23qM3ezsNCM0Oed/6tgqwkNXjaUMKLhS3DluQjeGiCRoC2wP95mmoud87hNwF/uUhESINzZeOf7g2wyWLG3XxzBeQAw2ZO13aBZd5yOlqlXTliMj696ydwjo6s2qSqy0drbl9p7di5Pp3FhKfa6ShNg03fq7ZW9iVi9oc5PlG+h6sKzGgBiQQOgOHkoeCtM5voHDqDmHr/zeO5iMDD5UOveipEb3FxkiCuCCiskE1Ituz5I00XNjoSEQPHazGFw8z0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzCyhfYaeB2Ek6YtCtB5Nv65Lr51KT4NBGbnV7kG3bk=;
 b=P8G97mAeQz0YefBxdMSng+23Augq92TyXrwOGSK+TNf2QpdbHqen1g7EA9eWdBcxBuPNx81uwvJKP3gsO8fRv+L7H8IiApp7PgDNbL9hdNUy77FVTD6o1pz3GlsjMp8QIzsQttuhGEK5jfbBS3P1561VKBzKaqktJrzbmPfVs8345eSMndmk2oio5Gd+grZ96o3pRK8Gm3JOjtXIsKbY+/Hc62798w96I+Qcnfk3/9HS8XJYyzNiv5X37Nk6DGdLTx/Qoxm+almWhaWCfLLfbVzzyp5NZNLj35hUzP4BLg0pScCOac/p5PlvOThREu3zBv5gqjW91S20ez/IOdTzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzCyhfYaeB2Ek6YtCtB5Nv65Lr51KT4NBGbnV7kG3bk=;
 b=s76KtEPtmW/iAOZw68lFdSnqn36Iifo5ogkxul1HQR3eectWu7IkRvGkPYP5X7YiAEyqyENP2gWGna5+0EOP8BkID2PQvxpLwWyNHnILfsmqUjhEBWm/makfkvgK66jVXdEIQS+FZYrAdKEsy7mCuiit49+s8LHVVDqgpjixkEg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:31 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:31 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Sun, 10 Jul 2022 20:21:58 +0300
Message-Id: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d52f856a-d153-4b7f-a4c7-08da6298c52d
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYz6fYfRx08nxUGdxKzRnacFORG2dZZfgnQhZ80rlkh/qXDuGALmBpa2iHJK+6+6JAhvBp8SHuUypPic/Et6lEyZCB8pwsjM97tqwgThEw9VAkCjB5xWyZJ7HXcuHSwCYY5HG8Cw4rzKx8w7JhZl/oII+Ya1MRal0n7AVdX5p04XMZbKc5y3nIpNzY8Q0KwQqsMTcns+02ly2H+6ZU0+kwQohYEGxt2Te7CrLFKtPynKji/DAWqhj6BafGRvMY/LC+wOb3gHmPot0ubvD/QS3yelvKAIfqekldKJte0zWImmdgWKkgerZc3vGJpfWlmklUd6HF54xmieaE8RZX2XPq+SkF+RdF+LbmnwZnrqhwe7oUu80N7mjgYRq4DJUh0vmFU0/RqRmFmFUKThcWfxqFSHRzJIWmiKWBBb8e8YgP9kUcVyoL8n8Y/Y7tTutVz6BPX1y0a74Avknf6jRght/hWqmhoVObrLhoUjkQ+mt6cgaoP9F1JrcNZscnElYuwBzTyiKmj4oVjL7fTOxsS4YF2PgDXjw0pTN/wmalN1AP25x/4xuAJKBToEneWSzozJSv0ASpV20zBXVslKWF1DNZBndBcVO7IjNEdI+lSvc40vsZqYw70Xml1apwzg4h+vNtlFk7ZFel5Wld1AehmL1bJtTw40WQn8znhOGjl9JOpgitd7Yv9FQq38GBdnKMe90hAfl1h6a+HZaPRwh/lESJRnKBvtJsvVmQVeP8LXth60KSPhkX3b/jI++RonFeqBt+mXDFQqCGsgBDGveEA8y55TItcmk+PODXszkZyBWaZ3NU9/520RtrGPzX11ZbC+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LsWcQa4aAbT1+60jZsOu75mGDPPP8OquFtY4A1UJ3ctUPdMsKCXp7uYYEqTi?=
 =?us-ascii?Q?lm3O/Pj82rYPi3Yyh6B2D7AQIO49AZHuMvWiVYyCqGVc/7U2GYcx4SLAQJ4h?=
 =?us-ascii?Q?73P/bPTKT2IBxbNnjEgpIYNxVBaR+/oXaSv8PG896mE1sKZ+N5OYiY1ypVGd?=
 =?us-ascii?Q?tLV7uAZdJ6DPcb7/mlf6LnwEM5eOxjkLWSQ96r+HHOkdsg+BIQaA5VIXjnkL?=
 =?us-ascii?Q?RZ7zqIIa88PsqGC36nwE+8VEe1dkOQ9gl6Thfb078AhNdQizW2a9Bk9YJ+PT?=
 =?us-ascii?Q?/9bq6zCDaNYp1u8pIWiUtNg02Sm66SoRnOz1S+GEj3B12j3ab8/6tOldDpsg?=
 =?us-ascii?Q?yo7NOEjHBearnsOUTY++LGYcIxxaqusY7ujX+AcuL3q1DEI8scAcOBppoSme?=
 =?us-ascii?Q?FE93/D0pQDp4XMyu8Z1hRiCApshDBkQne5MnT3DEIIvYjNSBz7mKBpv7XYJ9?=
 =?us-ascii?Q?EjRipS9OSWSJPkKJrYq2ER4PnDi/s5U+mX3IWqlqMgvSguxfOEP4KBvXwMoa?=
 =?us-ascii?Q?eIPEV+rLw8LmhfynBM+i1CsHYpuWlCRw+tfu2yz19E/Pysd+xqUzoTOK+yDh?=
 =?us-ascii?Q?sU7qHd9o89Q6aIBu1rMWdD+aItkIABcXLB+pfSFBEg685nQSSmIMZuPiSAyW?=
 =?us-ascii?Q?sWXQKcpYHoV0uQyauRVpb84R5y+FY3JbyfKWb8jIKyWzBu4gmDX39U8VeDlT?=
 =?us-ascii?Q?Wg4DuooOcCZUzIUctkZDazgaENRQyjNTohwc2FpD4cFc6uXqpIvwup6zJu56?=
 =?us-ascii?Q?C2gpzZv0vgNA70Pwdcq8RpIuXbQ7u3gQM/aT53opKCZiVEW+OoscA3zWteG9?=
 =?us-ascii?Q?j3CnJ6DbTDx9bIj4F7LUozOJ3pVTU0SFWXYG3hJT7LW/H4m8JvtjIejO68zW?=
 =?us-ascii?Q?tmgaf3M9Cf8Zxns44RlaUny3ckzW0Ekom6tosTVVv46iVPzhItUyihaHRFGH?=
 =?us-ascii?Q?cYffwm3OuIGJ+Q3i/wwOXG+0PEh3HkNb7zkWYRnN5/S9v5tvbWn6PPGgY4y2?=
 =?us-ascii?Q?Y7y7W7YfgwURkH/JHQzVmPu32r81NW0VqBKTRtf5XnP7rGVgODme7kzDzDme?=
 =?us-ascii?Q?PF5h7FuH5qhXFBh+GOdWjOWgRH/4UB9g2WjOyF7n0Zgs0PGmlA6BPygJAGFP?=
 =?us-ascii?Q?/Rb3FgL8FU3q5PW2HC0Sfv7ZPPfoQyUJkIHyZRkSGqJn3CSEeauuoDIntgM7?=
 =?us-ascii?Q?JtUnmvtEol9UxKd4twbmUy9kgZxyMfLVBhPTn8rB+hzh8/zMh3JxGp/E05Cd?=
 =?us-ascii?Q?XvPlA69ixeeJSDJE3J3p1lVJ6hH+uB7ARvahWjTNBQjIqdW7kDvfCjBVuEpe?=
 =?us-ascii?Q?o7Ch4E856e0LXHZLFgj6fFPDYvQ2xuOt+kEUB1DMvM7cKnoermHIqKKY0mxu?=
 =?us-ascii?Q?+p32afXpmCjFlJs0RjhtZ+m8WVP8xBzfgmNWWVtFp8g5JGUTZMqi74wnKI4m?=
 =?us-ascii?Q?8GeqqhlA1B9ulJvmVSoXXnxL8WDNy/QfucRkl8ZVPYXweLzGkmpC+P+16HQb?=
 =?us-ascii?Q?5YKXst4ICl8EiKhmh/1ak9fbO7+EDaz9fJ1NOaDGxOLniQLaK5iFeKNtwbm+?=
 =?us-ascii?Q?dRJz7xK0wKOSw6+sQub0l/gYMfd8MebgTYLRVwuvPIipEuGX6p/uTZcaDGj8?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d52f856a-d153-4b7f-a4c7-08da6298c52d
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:31.0093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQGiUVVGqE8NlRazH/SwVI4xg0ZjxlrE49LGLwpqCl1iT41Ku/dIQ/7pXZIEDAGNh17D0C04Fetl0rDAyuz4MlbpAs70VPuiizdC+eazLWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Yevhen Orlov (9):
  net: marvell: prestera: Add router nexthops ABI
  net: marvell: prestera: Add cleanup of allocated fib_nodes
  net: marvell: prestera: Add strict cleanup of fib arbiter
  net: marvell: prestera: add delayed wq and flush wq on deinit
  net: marvell: prestera: Add length macros for prestera_ip_addr
  net: marvell: prestera: Add heplers to interact with fib_notifier_info
  net: marvell: prestera: add stub handler neighbour events
  net: marvell: prestera: Add neighbour cache accounting
  net: marvell: prestera: Propogate nh state from hw to kernel

 .../net/ethernet/marvell/prestera/prestera.h  |   12 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  124 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |   11 +
 .../ethernet/marvell/prestera/prestera_main.c |   11 +
 .../marvell/prestera/prestera_router.c        | 1141 ++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.c     |  379 +++++-
 .../marvell/prestera/prestera_router_hw.h     |   76 +-
 7 files changed, 1712 insertions(+), 42 deletions(-)

-- 
2.17.1

