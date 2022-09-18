Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145395BBF8E
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiIRTrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIRTrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:47:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80102.outbound.protection.outlook.com [40.107.8.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA408175B9;
        Sun, 18 Sep 2022 12:47:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXm2cN6Pq31R0reLNZM/Bbf/yFvbkbB7fgEJipVoASRSOh5rGK+8C4eoL5ZJtFPEUOfOW3jsDrU+B82mpN+rptcYkkvQc1rmcLLUNCaD8rh1SXatJ/Oe5hxqYQHtxuPWEpWqvB05e5D8ucg3dZbHqVp7nGzO+xWA6gT+Lf5uW203ckHfUuAgUuKKJmcYCR9LIOvXAbxBM8xqY5JY2uvFP+GlTgbPQYZm6YFn9dUHq9M4JiI911AfOctbmqC3FBXpr3bCrZec5DLZCjKyWdutqbxg0KdrrrO8WUDuRvdoWT5Y3ZmhM3fMUd6fbKg9B4mUZMD8JfxpXKFgOe3PKi8INQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LY7sfS7/QRqv8+Bzg3sr5Q/IipeEdXwuMzS1cGH5Jr8=;
 b=fYju0NGBV5FyDRka9DV3AfTnsm/dJxPLruq/HQ5j4rQ7xB7QMlegC8eWqTwzmzJqlgflpUzblLghxq0KV9Pf2XIkf4qSKHl0DqgN45rVSoRYzbypnraX407lDKhNx36kC5TG0r2sukq1Bs6oUKlqmTIqR5X08cKVvKMfeGmTSy7Da/xM6TrbdsI0pnLJUdCj38k2VaCUUF2wScPj70ZyU0lQ7aQq8C/ohySzSz/AtbhOdhOq40WWkxVsz4r+3il7H1nrJ2Gi4ggh1YeW8ChQ0Fa6EKF6SQGD7FKCH4XqbW1H/3BlUCcMO38v1ddkOjOAThsn/F39TaiJveNgXdhI/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LY7sfS7/QRqv8+Bzg3sr5Q/IipeEdXwuMzS1cGH5Jr8=;
 b=SVibbQVmvQRryBmT2fc81R4FvqdY66YVxBe2O+c3iK1emKJrybXmdaCZ6ep7vFIm9ygM69vVOtmLC9DQurXzFgF1DHCYtuCsQndDkW13pNx3FUzLdLTpiFVIKapsAMvchZ7KYBZ0X59RAFHePOqM25m5D2cfpLPbL5f/B+aXok8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS4P190MB1927.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:513::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Sun, 18 Sep
 2022 19:47:15 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:15 +0000
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
Subject: [PATCH net-next v6 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Sun, 18 Sep 2022 22:46:51 +0300
Message-Id: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|AS4P190MB1927:EE_
X-MS-Office365-Filtering-Correlation-Id: 8def508f-8566-4f06-b54e-08da99ae9652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sxJumNqI9E9L4HwjOCrT075hfmcSnLfqy+ubVaGk1/pSHWWCOO4D5Sn79jJKvoFYaE7Cdphat1AHOY8yeN4PYlnWR2xqiq0sKyhhe2wbuSHyFiPG1NPfW9ObRNwLm3OSTDPzcWLTmWd5CjLCeOSyx6awUKLe6ojPn5n5yuBEyoEEl1lbEqGrUGbOSWq78kGmY9jiqN4JljagaEiUV0SipuBjjjGngrcCwf3/4Ydh77jO2LJOjnRFa3a92P+HE9re7jH2SCH5qEKOqCt7l5+RZ+S+nUWTcxoV60K2y8HCGm2EfBNT/zfn/laeFkEct0laKwU9G89lrqpUwwOll2Lui5MS1b/XxfSDiMQUHd4/tyn1J44lV9TFwr1sA7JQuSS6ImZ5X/lt04UBogtYs7OAB1yfoGdZ04imA/mZKAMXRcRwdp5YokUkJl7QcTKDdPFpz7/qY076iW7BuKss1f9WHoyuMX9jcov2wx+3NhjoBTGqcIuiOF5S0ZzFxeXuXo1vFBOUXq4mATWGzx+1gsyBOJaAnGMFE/0UysfWmFq9ZT1b6KI1EcVMT6nXsqst+/9WyBUpW7CRUYPiH1jAcORAAN9zxk+28+5vAlQHL0E88I2ULDm4W895U54JAJiRSxP4CNmOiLgvYHo3s+OCxB+6SLRaVtjrfiJD+3fQvN0Hf/d4t1tAOXSMNBioeaqYYoHnMiTO9ucbyrI9k9lrqZx746PCIQFscAeKoAj39DsboTVlhfaF2tP8LSVl1wLnfmysV8Rp3Tl0kAgCn4mNyysag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(39830400003)(396003)(136003)(451199015)(478600001)(6486002)(316002)(36756003)(83380400001)(66574015)(186003)(1076003)(2616005)(86362001)(38100700002)(38350700002)(26005)(6916009)(54906003)(52116002)(6512007)(6506007)(6666004)(107886003)(66946007)(66556008)(41300700001)(44832011)(5660300002)(8936002)(7416002)(66476007)(2906002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pMC/4dKfE4k8ff/1QJKGsud/gQ9hILctTCOBubc01bz/rdPT6JAo5EpgngPi?=
 =?us-ascii?Q?I048CVqz69d5cGK1IYa9qbo0+2SB+v55XEMzEf6Ph5T1K+9xctmKHUxKZeov?=
 =?us-ascii?Q?WmjuDENlH14iJvtQ0m6vX9kbjZ0Fx0aODmukGOBonr8r3Crovc47HlWyrrA4?=
 =?us-ascii?Q?mJ+S07HmqA+s+lsBOxZqyaD6BTU4KIVm9fOsFdN046ZNn3t0EucYCDeenkLt?=
 =?us-ascii?Q?hSk/KRZxxpOnCMYD/7Gbjf5VQpGD0W8b5DYSitBRCmI5W6m6bsu9s9MNV35v?=
 =?us-ascii?Q?kdqbSoWynmJGzoeND+TtVtAg7YQ2HU5QotQUHeTKMnakpPyyI+s1Fm/4pe0u?=
 =?us-ascii?Q?1owVARNqphW7KbzzMz8pmrJZhl4gULalscEYsGdPUio62EQe2j9lcOdhxmBH?=
 =?us-ascii?Q?41FU9h+P7Kt0g+G/ID7nWiuWwKdxO9lYGyvYoMx3uDFm+oaoBdRsMGMc2x68?=
 =?us-ascii?Q?OU0bZ7mPC9fhGB967b70FiG2gh4yNPwo2DmmUYmaybTuOi7SxPhX1T4bgZQ1?=
 =?us-ascii?Q?4sSA1R3mdWquUBgtHvQkM9vIJ9fWpNQwi84zPRc6pU+GedBEyBH3Np55ltDm?=
 =?us-ascii?Q?Ujn/ogkrgISlqF0v5MSYHbxi5cQFml/w+6M58lhLQTUDccxTzo9M5Jjh/6EB?=
 =?us-ascii?Q?lkTQI6YKt03qTwwZXTJuX+v+CcnjI+cWedrm20FjOYTTEm8FB5aYJUsYxZx8?=
 =?us-ascii?Q?qMOgeDHOwXAZvDI9D6rCHUzCKwq7hu13IouXlMU9COt/quv4u/u6LVC91ECz?=
 =?us-ascii?Q?JF0+sf+AjVUAfDNMAvGTMjuRYqKUaQagE6imiaRuic9SKyYvq5VLC2+8ZdIh?=
 =?us-ascii?Q?XtAaa7xhc9Ywd9cEwW27Y8eLtDvbdZX++wDlktOHVRXal2BIzBLIVhkQqFVS?=
 =?us-ascii?Q?ECUxrdl0IfnjD0dUaU4p8L88wvmlQyWlVLEpzY141X5sswd8v9XajasjF8Lt?=
 =?us-ascii?Q?23wSryYIh8p64w5IJVcUSRHX8Lp3NJh2nzADWOLe7cw4VdIYbjAXxFYgUktF?=
 =?us-ascii?Q?gOYA94a9tEyuYt/J6VJB4rw6gifd0mmn/Zs9NArY++QBK2briUT2/QW2Rm48?=
 =?us-ascii?Q?fjM3Qek8PgGR0ej3tNvzyBpk8BNVSHjaVdSQJc3j27k8lN8hjPuD6cIiu30G?=
 =?us-ascii?Q?i9lWIpWbWQFsg+vCNEPZF28JT5tX8WCrcqZMBmxEEqhxmcEnQJ+GpbImTtSi?=
 =?us-ascii?Q?Pz2fOrFDN9xN7Lj0SN9elEeTZs8mgHk3o8JMZWbpU6hZgHvlGtZiEPEUVnsU?=
 =?us-ascii?Q?sc76ulJu/n5+tRizNg2sP3FuQuaccJ7sH79FmWgkvLIdll/38crvFjhjRjxP?=
 =?us-ascii?Q?n/sZxIl7unoLH+FJXyBOFJLKNbEG1nl0Sl/Pp7GgPCcPkVrU22Zz9zR8f5cR?=
 =?us-ascii?Q?j0T5yNPRXQ59z3i8LFTI8IxPLUyh8CATvRNeLB2JXsKAgMDkAX4FQjbYif1X?=
 =?us-ascii?Q?srMt1Pgmq5vhnPANZI93HcN1RjfGyztbCJvQ4WByYOA6Y7Edn8d4unzInewC?=
 =?us-ascii?Q?7g6AApO7Xj6vNltopF4Y6WS5t/eV05ZVQxAEIBQQ5c1TTl2lBhAnEmXO2bHS?=
 =?us-ascii?Q?eU/87Y5RqPayYGrDX+8fPzccpsqulle8+oL+CsOX+SdzPcWYuOEAFzgK3GxM?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8def508f-8566-4f06-b54e-08da99ae9652
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:15.3426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XJS/OpfvS95kw2iwVNdgFJnOs2mTrFgLv6ofxLs7LLdOMGcfnTukDEP8gGUt+C9I5udTm+djwbr2lh2zQ1VcNpL/CNiiRHkqo4fi2w3pRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1927
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

