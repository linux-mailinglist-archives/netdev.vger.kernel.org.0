Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4F5984F0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245355AbiHRNyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245405AbiHRNxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:53:41 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D7D13DCA
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amXTO3huU/XjrtcoiLRstfCrIFktQHsiyuLkaItzxHRLejux9BcRBG1dylBR+nbGJxKVuuD6Ebkm4amIK+9/Is9R2D48VRLuUnuQpxzS5sTscuQxY6n66FG3M/etinKPV1JqoKxQSPlbO/JTbAFalW18YiTrtZfFgQ7jufUE4O8HQonYbESwi+HiE7wtl8XN79yMp0Z/aZjCqpeGScpQnqSPIjVFckMb51DfdT4A3YCO9sk0xvUBVmtpWo4LtRZzRjhogdBm2+agsnJjAoqqQluuAt3NC5eWurmIZScXyGmcvj3KF8CUpjvVnOToGUBreK57yTft4fgCjvbidFHEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzxmIQqhQhcMe+IIxK4DWEFx+7IEK7eFFZVWsYG0DUI=;
 b=faASmRlWkAR2kJxtwldfD0yninXn4KOn9xyq5p4OwmxyB2XR9lliVjc4uGgU+iQ7419CgNWPGyOjd5QnmZAOkKZ0EqGl5e7ZIeT1qfK+b6OyGPuECNkPmKiLs5xZr46Tyt/J21PLYDC5GkuIT78HGh/ZUTbzTb4u6a5OhpkKpv9Mo0MvzGjCiH+ervkC0UvVO0R1CAJyNNxdYieGDQqK809rveNGRFV3EI+Q1VIZIZn5UUAf1cpeyhvCcSixvqKvXuDgoQNwOW+ANF8y9HxjqTr8MGjfIgTVpYdkAcceyn3sZcwq5+2qep6mBjZl+Jp/zsrekJWeRIJI57dJ9SZqzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzxmIQqhQhcMe+IIxK4DWEFx+7IEK7eFFZVWsYG0DUI=;
 b=QUdDwajH9UJc5I5jjtewn80bG8MsEaGsBQxKa9cvc1RnnfIBUYP4xS31pFWeHr+wplJg14ZdfjjmzBkcekZekeK4JAQwa+7sbbfE1wPv6lUcbaOXBYqCDwhk37gqDq26JVrOLhAokCV64KzIVnOx4SL+dB4zRv/0Q5esosctPi4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 0/9] DSA changes for multiple CPU ports (part 3)
Date:   Thu, 18 Aug 2022 16:52:47 +0300
Message-Id: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1e2cf17-097a-4947-b940-08da8120fbc0
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtiLjIPP1UQmEfnEvfgj2KY9J6twt/64ZAsOk3yoRZGaB9Zr610H7wkKLVG00FY7neiAmbVkHp32xSfglGVy/M5tPTcucqANDPRYTmpIk4AiqHHYIXwOUGgp1J/xGQ77jL+BYNPTTUuqHYDBYk/8TtIei3RUZRNiNKSl8jYMkxxGWVdLkBGNmpluelyL8CAVPY26YUjpndEeLaffjpUvBR3faYSTzuTxssQhVNl/jhOLrnPrj7EzV0JjyqSxf9ni6i0bvc983v5SWNwXoEiA/iDwbmny/RE1W5/CyfIToxO3go8HmIuZc8up7lT1zLRQAiO4zKwEWrKlDT8RWZAyNxdZ7eqUUPhyoGF4DTMdX66eDkyoCsot8j8xK3KDPlL0YbRi/46uPwMmuV/etnzv0b79y4iTKAF6XkuyypFuJ6avNwPFOGmzACHEkuWsdFtVtZUBDkTUoex3K3xEUeUYq3KiiK2O3JghWiC7oQnPlTzVQEIjTLt2FSOFxPUP4Oq1hy7QBmY2bcnS9T56mtjaX1Zh3pcu5tLGJaZ8ML+gMIKPeSw5Mo7zKfiT+rQWJG0ptw1n/zdF8u60UwcOTijieK6Get7S4y3wJS/xe7Q64EvQNbJUM07TqwOIGZ4sgrxJBqjHZq2sbpf9HbuukNRY4iyQ4f7EMQLO0MTNInQDwqxrv187XtJU+GI7HDNDwxbJhi0jZlafveUn3ozD1tV+1uIWQrIzioPijlxKhUdL/uA2ZLol7B9KM69JalIng8k2eduUSUTzjjyaeU5llpqkXVtI9HMRqUsPyBDrnqooNzVaMzhiOT40kvqdcbFjlVNJAPqIg5Vyh33qIFCLO/ylrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(966005)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rNnsAoTJowa0UhCWqP2hi+mLVTWzWZbgxX0JDk0E07aFaxM72HY7lQvJ6sPa?=
 =?us-ascii?Q?ASFr1/7XzUmLezyWuXHnfjDzMAGlO7ti8MfcMnOld4lcLHIzm+vWQaDG+SSG?=
 =?us-ascii?Q?O13sWepxYL/H4Hste8pU4GdrV9gws+bfdgBFsJE5ZCqGrCmL2OT83NdyAqev?=
 =?us-ascii?Q?NnD/F/b3uWGMVWCgUDLSwRF1zM5QOmq6J3rG3ryaDcSTFPrF5oFjBEm+LlYd?=
 =?us-ascii?Q?G09Wf1FpB8KaS7YAGsqlY8xnyVZ2WyFzr2dl9q3u52n+6issVgiClY+O3eUg?=
 =?us-ascii?Q?uMHDhYJlqQIK9mu0VIbq9xBZ9ySzqqwCspLtYulZm9L6lRCgLpJWMAqAI2Mk?=
 =?us-ascii?Q?ND0EofT4axMiBqojbeKDX9jFXX2blNc0vntNx8qKtBFQl13GEHAIhNlS0hSL?=
 =?us-ascii?Q?8By1RcZLDXhOIQHfZVEw5MyLOvmcF5pl/U5uxbL3IyxP6V231dS8wkUxruQg?=
 =?us-ascii?Q?ezS89QA8kgw3KZLExun0I6IqveL+vBII5oHxsllZdasD5/ql39mJj7s2y7r2?=
 =?us-ascii?Q?A9ZJtbGjQlYEDPqf+Xn/kbZTKWOQqUG9oRH31N3OqkqQrj3iC5OVmP/Q+5cg?=
 =?us-ascii?Q?auJD/U/C3wrF5dXA2XMc7JRYrd8bMnC8CeFILI8Xd7aTUV3Lq1u1goouqgaI?=
 =?us-ascii?Q?Nb3cdiZJueOX+olt+bYkSnCUQK/spt6QdP7CY5/tfdjtwtb1CfoAkK7tIvdA?=
 =?us-ascii?Q?MvSJLXVE78FIbg/O3lEwtb2Qt7y3DVuSG+rfPEUNGDnq5UZkLPaZVpAJdTBf?=
 =?us-ascii?Q?mkXcTYqniUhD0+/D4fs1N+rLexvP6GPVSumuF6xMcohsMdsaZeHTz2klfY8A?=
 =?us-ascii?Q?9BBEymgUzVqqBTxBgQ6gcRwIhIvUU+/klghE/WCiGd4uKBdaUZqvYNi0rHt7?=
 =?us-ascii?Q?r/Ik+1O5PZdkwKYZy3T2pmbqjcQwC+zXe1J3FWYnMR4cBvzzjmkNClH3CZsY?=
 =?us-ascii?Q?buQEOt4bYGLh32k4Uaq3/zfAcRTaDHdm5k6QRlB0UWMmafS1cKObKtiS2Y3U?=
 =?us-ascii?Q?7rA+sTHIAXkUtlieigiccLaHJaswh0lh2PBf0yx0pSsXgCiMTa8U77ozZVdp?=
 =?us-ascii?Q?MBB+I71JKSUShYI6NXTiJYSYB5Iuyr7wqlGQzTF422VNTQqMWwWlKLQMUTWB?=
 =?us-ascii?Q?Iyf+q0LXXLIXbjrDq2Ggk2uyjUjA9pP7yAifZa4+nMICpkE7RnaOAF64yhA8?=
 =?us-ascii?Q?aQ2RuvPUbG0Z0IqblsqaR9szGPgrUeZ1wTwAFhN713zZooJVJZRj0eRKN+LG?=
 =?us-ascii?Q?hkkLuGMMzD73/Tt6qsbvQsPIUCaERzxkxlXoDHVR6MMDHREgAjstzEXx/yWN?=
 =?us-ascii?Q?1fgSmtLHZhquKMmir3bP5+4cOY/yRrjbMbZlKS9//qyW+sSv6x6o/3iidEwq?=
 =?us-ascii?Q?IFcKF5QnMTDiNErBF+0z0ABHiBhwaoMWXZm63sUzA8GCs0wqYeQ4msMeYiqX?=
 =?us-ascii?Q?PMt4F2DnHf7cYD6kAuy3qq79z1mqOYifcxEnYyCghiYPRFZIfJfdkvpcJrxn?=
 =?us-ascii?Q?Ie3VN+hiEP8whtR+guHY5RKPJHWnBGmYVUstACjCThcz9jmr90Ocu83hnA6j?=
 =?us-ascii?Q?TgBAMmUBGv4rqltI4ahF74CqbDAtBsyV4nn/LxLqoiKEovL8HF0AyA2UqzqK?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e2cf17-097a-4947-b940-08da8120fbc0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:09.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ne3eIqH7gMBtfCFg2iHoyOm6GZgS04ZsAByqJK19Ydgm9wpGV5OjI1GcHRP98iOYWpRaiUDfmJA9+CsfGfkEVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those who have been following part 1:
https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
and part 2:
https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
will know that I am trying to enable the second internal port pair from
the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
This series represents part 3 of that effort.

Covered here are some preparations in DSA for handling multiple DSA
masters:
- when changing the tagging protocol via sysfs
- when the masters go down
as well as preparation for monitoring the upper devices of a DSA master
(to support DSA masters under a LAG).

There are also 2 small preparations for the ocelot driver, for the case
where multiple tag_8021q CPU ports are used in a LAG. Both those changes
have to do with PGID forwarding domains.

Compared to v1, the patches were trimmed down to just another
preparation stage, and the UAPI changes were pushed further out to part 4.
https://patchwork.kernel.org/project/netdevbpf/cover/20220523104256.3556016-1-olteanv@gmail.com/

Vladimir Oltean (9):
  net: dsa: walk through all changeupper notifier functions
  net: dsa: don't stop at NOTIFY_OK when calling
    ds->ops->port_prechangeupper
  net: bridge: move DSA master bridging restriction to DSA
  net: dsa: existing DSA masters cannot join upper interfaces
  net: dsa: only bring down user ports assigned to a given DSA master
  net: dsa: all DSA masters must be down when changing the tagging
    protocol
  net: dsa: use dsa_tree_for_each_cpu_port in
    dsa_tree_{setup,teardown}_master
  net: mscc: ocelot: set up tag_8021q CPU ports independent of user port
    affinity
  net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG

 drivers/net/dsa/ocelot/felix.c     |   6 ++
 drivers/net/ethernet/mscc/ocelot.c |  82 ++++++++++++--------
 include/net/dsa.h                  |   4 +
 include/soc/mscc/ocelot.h          |   2 +
 net/bridge/br_if.c                 |  20 -----
 net/dsa/dsa2.c                     |  56 ++++++--------
 net/dsa/dsa_priv.h                 |   1 -
 net/dsa/master.c                   |   2 +-
 net/dsa/slave.c                    | 119 ++++++++++++++++++++++++++---
 9 files changed, 196 insertions(+), 96 deletions(-)

-- 
2.34.1

