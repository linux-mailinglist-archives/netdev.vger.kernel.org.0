Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5334A5700CE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiGKLjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiGKLjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:39:32 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150111.outbound.protection.outlook.com [40.107.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8423A62E7;
        Mon, 11 Jul 2022 04:28:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h41suEN4FSo3stNYpmyxS26ZyXyBei8fIL92CAzqfgOjxqLIKEIWM/mF0xgAPdaweoX8QRSpxmTGNmFYsmGQi2iuArTm2QjA9AAQiYoRib3h+5aHzQGczM8KgyrL71BIRUACUEt8o6d8YCRsiKiL00I/XOhs00q70fMixGvAAoYQoS+wYduAi5lMd7gz9xdnzBQL4NepS3dNHy9QiC4CWS+9RuN6rxv7FgvXYi73x4J2N40dSSiLGI04auGOiXHk0pTcfw45g9yoiX0BAkXf2NC1GtRHjYxKXA0wbudfk6oDuHpFEJTvXQ9SV9TP2S6Rzl/Dubh2paHw8tqej4iOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18jxGMtO9gxbIUDZL9rgyQWLD0H9RMTifpbitWrd/Ks=;
 b=FJ68udOYETNWc88WEyMagpG4KhrabDSviQMpb5re4XLCJQ2k2qMelfSJLSUWKk3Bnb2aOSRJjnBfJEM5LLmoF3+DEUO+j560R+2ox3XZ9e8xdgW4kalEqsnPerl7bSBXq47vX3Pw1RvOTEceWc4L5Tt7a+Y8H1BoHSbjf1AZOp5PntfdKrjnqmzyizzgTcmTX/kwbdgyVZiX6LXyTmOA8sYDcaGqOtwNZJMrPIzdGH3CVLjW3hKbvqqT4zKbtaMeoaJk2j/z+DXLdNJhMJltjjU0jab/DtnFU87VRJpnXTeXzdDMWFNP6GzpXhQYgsSBHJnvM7A0Ruktju2qpeGpPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18jxGMtO9gxbIUDZL9rgyQWLD0H9RMTifpbitWrd/Ks=;
 b=WAizbxRMdCwmogLybCAWdmTw68fHsHei2TROc9J4BhibCyT5uXQDs8Rfa36nNFmtU0H4hz9FGnK0MJF5iUDnXeAWdfP1hPSS/2Kkmoh/XgViq5fASWamvfIf0JOQxN5H3rRPyef0E+HRHUACZjh4Da3MsnAi3T0ShUfDxhLH75E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by HE1P190MB0331.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.25; Mon, 11 Jul 2022 11:28:38 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 11:28:37 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V5 net-next 0/4] net: marvell: prestera: add MDB offloading support
Date:   Mon, 11 Jul 2022 14:28:18 +0300
Message-Id: <20220711112822.13725-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 258df90a-f1bb-4106-be72-08da63307f9c
X-MS-TrafficTypeDiagnostic: HE1P190MB0331:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nb9iKLuvNBmzDNEYKgyrvr7rPr/VN92cBndb0WVk/HlfhFF3WyGwohm3wj+NwE7RmxxVJmaBtAM1eilHC/NItLJ3VwGTcrJvFbPAKUk3KDh4MV1srPVuI1HBllJu8L5BMjgKIApsKfDlHgdQ+pKaIkY2pJbkaHCSWYTMXGWg16duMMmSoU/gxU0ICGQasurFTC5PwwmxwK87kiGFO+27JXdYTGbN14nQX/Kcn9SJFZLwIkHQ+uw9RkEE9gccbWHMMuP9agICC+5n2zJ2RB4PNtsvmlVMHK3r6/9ENAvVuIZieOHv0xRZ7whGuOw0Pkl/fuiXrNispQDu6pTiOmrlhxmuw4TGWAWVzN+gkfn3T0X17qFkmUm3w3cxXuPnyfEdteiLmBg7T9mo/4Bj+XAOxAswPsmonco8YsqUyxcA4Utdx2xOS/ZAfaDqIZB4Z/Ky4VMedtOjlJ8t7ycLfezRyrEqDCVX1uQAgVulm+BwLu/BhLdtTjp/yCs8EHIUGNR5vh2e1zbIsfSqe956ElNXBwUL7IOuTxUHUdFEUtjU5mruq3WX9/yh7A/+noC97eRnxPUQlzpEjkKewqXhaBHq0ijjenkdCnRLV89FcKZZI6jLP13cphzTIblEPKg1uT5r25+cwsfXKIKkiSkO9rszsFlP1mBoGt6G2jcY8B4rjj4sd1Pojr2zwNFG/yNhRAHhJse5dZ/9Je4CItZELbEwN3NW9nXqQ8vj7mP3wEWS+me2DpJFhNNQIPSjJKOM4VttQjNhyTf9HnCxB4TYOsk+p7C/xsTX6mL+aejt8I2HtvAY+SevYiVEbf6CDczXFpjA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39840400004)(346002)(376002)(366004)(136003)(41300700001)(6486002)(52116002)(6916009)(6666004)(6506007)(107886003)(316002)(186003)(478600001)(26005)(1076003)(66574015)(2616005)(83380400001)(38350700002)(4326008)(6512007)(66476007)(5660300002)(8936002)(66556008)(2906002)(66946007)(8676002)(38100700002)(86362001)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uw622oOATClccA/xwq5ZbWmy90mPy/B16Lvt3o1q2FS2/240AkgiEYLyOolE?=
 =?us-ascii?Q?YGECsypuZJ8JWIX9Gr7xajd6OqNOE4YVeDZWjbZw1xZX3qJ3A8UAisyPBdzA?=
 =?us-ascii?Q?iYANs1d9/SREzvBp5ltqioYjxQGy6CNvUlsjERdL/razXSfpHIzbQrrMBeLI?=
 =?us-ascii?Q?tj5p6AAq11wEF8lYjLffSivy8IVqHTyVCCjyrjiGtIAjA3kDZXS47vFvkR+W?=
 =?us-ascii?Q?xtugNx7iqFoN9drmhnz2e3WfHWuPwqyxoDEkRqpfNZoP39D+J8nAvN9REBJz?=
 =?us-ascii?Q?+94I7XV64vcJCe/famGUHwdWxh5CnI6W0LE0Bp8Hfvx1WyJVqydfMzJMBOxe?=
 =?us-ascii?Q?ZMB3IxGxegCuKa7j9OVdBzh27IT4M0eX/ThiUwLHm8H34MaKDX07I/3wGtPa?=
 =?us-ascii?Q?amOWhLHtp0am8ZNWItSIIuQWOgQm/uCH4lxiZydnWuM0jlCmusNBQwN7fVbD?=
 =?us-ascii?Q?76U+J0uhcZEiknOSo820+kDj/EMjV/MxteteixYUJtJMpe95UTbtKAVdbMUI?=
 =?us-ascii?Q?zE0FYcvHnILYubLS6if2pKxEauCJkPkfuGMVdwMjKpVNO3PUFOZjlOBAoyLJ?=
 =?us-ascii?Q?wA4Ty7sD4tCyhyMg7MfVUsqUd2RIZDld4K9Rtd8El3KVm8spVfM66TFNeCVr?=
 =?us-ascii?Q?3ZETnyje/YjaTmKHuDs3XUQ8FgVEZ8zhf1KNG9AcPWWsQ4Saap5H1zKBT/8K?=
 =?us-ascii?Q?zukbht2Wcxy7pQK/rG+ofjosejbjWKOkMpelkJ+LYY5ySVhgeDN5Pen/GdEJ?=
 =?us-ascii?Q?733bLpCdlEth9XO2esibrDOPI4NE0P9hqDk0v/krk3n+Kglfd6aLLYKbdmXj?=
 =?us-ascii?Q?kRrdv5f20NOTbfVt3Vu7FpWWZDa0DHK9f2RuvJPjBmtBYt8UENJyJC+rx7jR?=
 =?us-ascii?Q?uVNC4EgOr9l6N6n9vGwaF0Wkf/UVP0PEGw++njp5JzN+zbxRFvSUKomZDq7e?=
 =?us-ascii?Q?x1zdbhD4kp3ncH63teGsCdEY2bDPxcsKivzKSz7fk8wqbD/T7SZNLxcPBukf?=
 =?us-ascii?Q?QLe3wAQmQ/zHPBdPMjAjbEfoMC7hP5bjY8W5zoH1YQdgOptzDiHM86Au+XuQ?=
 =?us-ascii?Q?u5a12bwxe9qEiGGK8sDS1sc6v9hSWGY25q/ruik/cgE4j/ysW4WbPILQdD9w?=
 =?us-ascii?Q?Zh2El7Eb88vl9oPOAp/qoEfNGARB42gfmjJhtuLVJhoA9QupFk5ibG4/d82U?=
 =?us-ascii?Q?ML7pnvZtmG5Hbp90HEJIVDqAxevrMzRhrpv7WRKzAxaovrvWK5SMHO2rb4A7?=
 =?us-ascii?Q?+zlBvPr4NW8LjI2mxDDNe/Erscm3QhUsNmFoJUZU8wsRBCTTc9In4q/l4F+7?=
 =?us-ascii?Q?l3eOUZNur1gaKraUu9mWQOcGNEAggS5YyAY7Kot6z9qvysvpXIFiui2Cts/P?=
 =?us-ascii?Q?+7LX/lS76SDIIThZ93gu6U/C7VzQBfTBqrArxF9jascELGz+A2GW6fwV6GbR?=
 =?us-ascii?Q?PQCKZBrwfHDNdstQI5Wxb4y28sXYsZs7XqzusByQ1BbWOvastfANMTOUBi1f?=
 =?us-ascii?Q?Sn3JOWERWuGV5RJfQTQxDoQK7YfSM4ZGaUN8c7a2QLWBzGAbFSICORc5xLko?=
 =?us-ascii?Q?JnkPf5owxW+lt0LfwDKmTRoNHUrnABNSS/H5MF5eM+eUDsj4R6WBZSNEZomM?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 258df90a-f1bb-4106-be72-08da63307f9c
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 11:28:37.8311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvOtL8qe3fWfuDOs/cKBsJlFCmAToQCDEzRRejKnI/b6xBsoDL7xsXaazbdPI277Nf+4kcY9qUbfGWsVOqm/xcwr76/Ps4NTKup6wS5hkrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0331
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the MDB handling for the marvell
Prestera Driver. It's used to propagate IGMP groups registered within
the Kernel to the underlying HW (offload registered groups).

Features:
 - define (and implement) main internal MDB-related objects;
 - define (and implement) main HW APIs for MDB handling;
 - add MDB handling support for both regular ports as well as Bond
   interfaces;
 - Mirrored behavior of Bridge driver upon multicast router appearance
   (all traffic flooded when there's no mcast router; mcast router
    receives all mcast traffic, and only group-specific registered mcast
    traffic is being received by ports who've explicitly joined any group
    when there's a registered mcast router);
 - Reworked prestera driver bridge flags (especially multicast)
   setting - thus making it possible to react over mcast disabled messages
   properly by offloading this state to the underlying HW
   (disabling multicast flooding);

Limitations:
 - Not full (partial) IGMPv3 support (due to limited switchdev
   notification capabilities:
     MDB events are being propagated only with a single MAC entry,
     while IGMPv3 has Group-Specific requests and responses);
 - It's possible that multiple IP groups would receive traffic from
   other groups, as MDB events are being propagated with a single MAC
   entry, which makes it possible to map a few IPs over same MAC;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

PATCH V5:
 - fix checkpatch errors (4/4).
 - remove function forward declarations, and move
   function implementations to match the removed
   forward declarations (4/4).
 - rebased changes on top of latest master.
PATCH V4:
 - fix clang warning - var uninitialized when used.
PATCH V3:
 - add missing function implementations to 2/4 (HW API implementation),
   only definitions were added int V1, V2, and implementation waas missed
   by mistake.

Reported-by: kernel test robot <lkp@intel.com>
 - fix compiletime warning (unused variable)

PATCH V2:
 - include all the patches of patch series (V1's been sent to
   closed net-next, also had not all patches included);

Oleksandr Mazur (4):
  net: marvell: prestera: rework bridge flags setting
  net: marvell: prestera: define MDB/flood domain entries and HW API to
    offload them to the HW
  net: marvell: prestera: define and implement MDB / flood domain API
    for entries creation and deletion
  net: marvell: prestera: implement software MDB entries allocation

 .../net/ethernet/marvell/prestera/prestera.h  |  47 ++
 .../ethernet/marvell/prestera/prestera_hw.c   | 256 +++++--
 .../ethernet/marvell/prestera/prestera_hw.h   |  15 +-
 .../ethernet/marvell/prestera/prestera_main.c | 191 +++++
 .../marvell/prestera/prestera_switchdev.c     | 706 +++++++++++++++++-
 5 files changed, 1124 insertions(+), 91 deletions(-)

-- 
2.17.1

