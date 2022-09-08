Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C720B5B29A0
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIHWxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIHWxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:35 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2121.outbound.protection.outlook.com [40.107.20.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9C11228FB;
        Thu,  8 Sep 2022 15:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoYxImvtVyNqxTugzCLNkfotofoR5qDbkWZlcQR9s69VqvcmKtb+56dW0HFr5Sk/ZHcovqks1lkulQZbZG6+Q3551U7WKK8o7UMxC/18bgLwpuoxvBeam/yueUU9cXacjd1AhIw/a9BGI6iGa7TTdJKHtv4qaPUTinsI+bBCOCqei+wOb1U7/6X2NTKqrnaTsb4TbQr1Fw9iqH2Oi9QMKIQIoeulCmc5Cp3f1vwpdCSHzIV9IHj/5UWV52mfkVqjg7DLB/g9fMxevHhe8BNc3SNH4R5cwODkVP1y04zITgbyulmnl5xE1RZzPEz6wcEn1P5GFdmCL2obVr50lzievg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViGWiJgKBCJo2OaPCFNFrusGO+K2n1EOuFTj1dXWosg=;
 b=TB26dOh5FVmzj3ZULRQe+e3xv3iJiNhDHBxRda0JDu47jZij3ldiCUN+LCpoRYmGYFXq58670cJVNF3p3fCiHnoSbJ0dF/eAyzKevhYlcBttN3njScBYeVlB3yorvIVr/YHpFXyuUGOyzdZRuiqYotzay5xDyJyRb9gUAW88XWVAAAlDyAERf9YbEM7XTLHY5hj/8Hrxex2q0LqSpufEFUCxjCuzNjFmufM9L3fgePioBx3ISsZEG2i5k51mCGT8mjScsCV/eva1nnhw0GTJjRB5XiZ6YCzPWPb2Voij6y0ww1WW1kZ5+anzNG9LQXtHJPt7xG8TBNu6xvVTqWqceQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViGWiJgKBCJo2OaPCFNFrusGO+K2n1EOuFTj1dXWosg=;
 b=gExm2HSeU5i4AKFIR/vHsvguU8qg12SsybBERveq6zgJbl9YoD/Y1FBA12+xePF1WjVh8dxVN/Z8VZviOyIDHSKHDWnmBAx0ZBP2N07Msv0YqkRM5BuuzbmbNAKYwkrZcreFkhruBvSODAr05Kh4Oy7oQGijxrSenUzIJVQsih8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:30 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:29 +0000
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
Subject: [PATCH net-next v5 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Fri,  9 Sep 2022 01:52:02 +0300
Message-Id: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76f2e629-733c-401f-5ad1-08da91ecf2b9
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0M5936uYcqEz25bbrxnTGVHk9F0NoNxcq72GZOaJb2rXJ4p3Lyo9/9XCqeKxQhPXZqykiybJeh98jXSk8OF1PBlly5nkcDtlUdL7iDSwqEeMD3rOKvtczO6ji8/Fd3kCAUhiaiUcox5BiW9A+xjo3fMSUN8pQXj0lqQoewCOhysEOi4OawVkfDZLmUov9X/9cGJONeJJapSnW4Kp8xt40mw9FnSxWNkXJfbYtsoJyYFkEvMgfULwkablbVbIqn1esUnNjMe3FAPy2GHMYRIf4/yfRAvK8Iq41tyVwlA8NGuu3n4xmWXSdas4R+4UtnMzhmLuZjgQQCJazbSIjF0CxDvMx93vw80vmw26P6zvxkM1n4Fa2DfMpAg1EhXP50L4XVr87dtb2WSAMOU1LYCgS3XXsxbuF5oNfgVP5Zyr7AjVJZOpOI4zlmWcIbrETgftKBjoh0qWnEY4MONZ8x0fjOCXU5hTyEX7HpIQng8IZTGkDvGMWuzx23Vxuk3+NPupNGjPyeuo3NT1N6vBkgwIkQXE+rZr2Qg+iMwFp/Xa0g0Avod+3rvzYETxwTAHDQhewYg1/uc2GVeCFiKwXGUq/bxEIZcL4IOAx4ImPKyCQ9/S8I32DOMPf1cjOrvCQqvd8dKUwC1BrMWGpNFtYR4X1NdFwMnQ+NS10K+BZPXqqGSZwl0Wo/Pn31OUqd/8oNRsdiuLwJkgECgbu8BI82DzWtZHvq6EawNfOoStrKYe2ebAf+oP7WFL1plTK2HmrSYeyQ1NC8JNVBYKfVQYgY1zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(83380400001)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tbmCGuePufBtq0UsOrvrLp2QG2lBc51L1o5eqwljsbfooCLPa8y+94DRFd6c?=
 =?us-ascii?Q?2Bi9a2PsFMnew/lod7D89zRyf+DiQpkJMjXIMJUQVLxIRdvtc0klKRYxDx8f?=
 =?us-ascii?Q?CVUXECorUUHW/EOWlJadcM/B0TzQCXMpYojqOlTY353C9Y8SYaDFWiON2Q4q?=
 =?us-ascii?Q?eOfVt9l/+wML7BlAVTDPPiO7DjDwEiAO3ETOMSQjyTAid9u+YxPg/ahsIj2Q?=
 =?us-ascii?Q?ayCRansOYighhqRqWDFQkeaSVSDmNK/gAXLb/BJxZtAmymWalF9O0QI6RdlO?=
 =?us-ascii?Q?ZRX4cAYZ3RaoYdDQP66f8SvD5TlvoTWAHkmaAO2v9cX2/sIonrxDrXsZ8HUi?=
 =?us-ascii?Q?4peTmUMQgJiXebHNiaHV+FX5gGtAKXfflRXUbcrQ/rehnVT/bzGFT6UxUgn7?=
 =?us-ascii?Q?zbD/V458d4OIEOoqtuKIhKhWpZMY5cc6Q8KAtKlmJEYAujA4mgP4MlOujrdm?=
 =?us-ascii?Q?VjiPv46BxcHRTTcd41fCSJ8RTOvaUBn5G1Kyn/XfY9GE9gpSPJ4/Ia7NWmE7?=
 =?us-ascii?Q?whpXd2bFhIDEAHcia4fR6SYDUeJUWCPQ+doHAknUxfELyb/SX/99OwVs3Woh?=
 =?us-ascii?Q?A/MQc2M89QBp0rwAG9oyGrP1bEwQw4soG1FtkjBWYhSetDg19P/2NQVDanTk?=
 =?us-ascii?Q?uhpmTmuYDob3EgICFhDnIq1c2rlLvDxy0DO3yOHAhVsHtVNZDuntMSEm68q9?=
 =?us-ascii?Q?fK69kORMvEGz31o9+7hTCwCoL4uIWAsRmF0/kWHK+viUwQFYm+6gctsPaK/9?=
 =?us-ascii?Q?k3f2/EQxSnVER0Uy6H/S69fCtkfBZr3VUBSmr5z8dF0q3FhvhHKfUayGn2hk?=
 =?us-ascii?Q?zRCHKyBvaQNQu2FkvJ2Z2UlUSRQMHJr+ZUwfitntvo22G8w8FZwM4Uytjo/w?=
 =?us-ascii?Q?+4F1q1FcmP4EjIqvm+EnDjrLJGzGC0TbshwebllkxjyQLfScG9TTF5lIrEqO?=
 =?us-ascii?Q?BHybmuy8d2nV+9Sa1hl65UdMK3iwM0I3hg/rr/hronUA44POdvXsJb7mmp9w?=
 =?us-ascii?Q?i3DQHMUfZmjj0c9LGVUPC/quLACO6MRAPVXkQY0mX4gZ/+1X3pd0x0RpJpbr?=
 =?us-ascii?Q?7yLI6H1mPst38K4qMhD3JjMjZp9Uxfl4IH48c/K9E7wVdYqyNULU+A6XbvH9?=
 =?us-ascii?Q?KKKNpbuL7xLhS9fsrB+DzJc+/l1FuQkEaHCM+qSTqmK2uXP+g53z+sStojn/?=
 =?us-ascii?Q?oR+7jpnzhqp6UzGA8oE7nWuvtn+RXkfHwX/YoO+a6i6qHQwLBTR+XL3uzM+E?=
 =?us-ascii?Q?OfJRiq/yG0tnZ5qrRapssojj3sxFzAzm2WwnbL+HZaPtkws75pGyNPkY59f0?=
 =?us-ascii?Q?yi6OySFQqE4xBwR6FIkkoSQYlwFux+x+ud8enz2RFPv3bpUvtmHhZfqeHrfu?=
 =?us-ascii?Q?kH3UKB6QJsGm/6IyCHRAsnsekJDBhyt7plMWIRKgg0Y+cNTn3erPoemCDGj2?=
 =?us-ascii?Q?nXgj8XA/eEnTVhiGwUYcHJJqwZzvlO/d56HaaguEr1+qRnzdrbVKWQ35MHa3?=
 =?us-ascii?Q?HxRqtIukbch1sgyEk9bJgJLVTd/MDYGumxJ3LEeOgtKxcdVVODp2BCiPXAQz?=
 =?us-ascii?Q?89NNkFjpQWAqCcC/T/O7hCa8yglN1W1rmGsDqeZSknAHMoZ/PhMBVF1kAM+y?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f2e629-733c-401f-5ad1-08da91ecf2b9
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:29.8607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BW8Qnxjdo5gnVNKwVqtyCjasFCexL03hx1axG8vMilKQsyKH0FeHeyhHlJIQ0Sg1IBqxA2r/Ng3jmxMfZA6cAYVG5Oc8PRi87vkhveG5dA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
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
 .../marvell/prestera/prestera_router.c        | 1141 ++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.c     |  377 +++++-
 .../marvell/prestera/prestera_router_hw.h     |   76 +-
 7 files changed, 1716 insertions(+), 42 deletions(-)

-- 
2.17.1

