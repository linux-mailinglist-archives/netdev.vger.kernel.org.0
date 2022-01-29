Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9C34A2B26
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 03:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbiA2CEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 21:04:10 -0500
Received: from mail-centralusazon11021014.outbound.protection.outlook.com ([52.101.62.14]:63231
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344799AbiA2CEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 21:04:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoMmkLRxXaPhbIE9QmP95YFy/ZZeTxAXK43lD9DI69z6+PkjLYE6J5iiH4V4iP+7qal5kbbL+tjOQRgiJqc88Q38JNfib4XPqM6De8JTcmfMkye7AZ9i0TESD2GnrUj/85Lu+f5BKQ+8G+3v5Zg3Cp6sf6/VyWiME1MVJsvXsW9NVknhbUcP13f7z9YOHy/a9W1EmLiOkwrLfZByb638/SvlwRKdch2iOpMT9JAMslORxTDuMV1TAl80q+ED+6k7WkUIU8VD2zy09mMxiAbrjP178VGfHYhalDH4K7R3MxpYnWANyMtj9p62MbnsLO1AZx6fHRHRL4lr2W7BYMjLzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnjyBs0C4RI1dofwA9LNy1BmRfmuu/5yqyRRqe26n7o=;
 b=FAhUO7ljZ3XI7IQe8xFsQVUlk2pJa3X904B8BJkAN5BTBZbsQjiYyg7A+Ge9LCb1jFJ0seGeNnPfzVZXW2J+dLP/trhljgeEuRo4UuzQks+VyrCcTpWuE0jeskY+iz7H78ce5n3y2gUPjD/uqyfH4ll+LZvEXq9GbT5a2winb8CyqvfCgRTCNTh1yo0qQURXJoUeU/MriSChTm5w/NJJ0Hss2R0hzjD1fAFNdI84z1HCm7tJxUeUoW4EA6rVrvLKyq09099ThnCRQz+HCEdfq/PnfDxYDtNCThS6rdU6CpH/Y3CE03V5XZyOmixRnAFxAxTFPl0nVF/VN9EPHOERzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnjyBs0C4RI1dofwA9LNy1BmRfmuu/5yqyRRqe26n7o=;
 b=Kd5EonKito9KoABibXZkcjjZcIiVoMPDd0y432LHQb2S5k/5hJgxnZ49Bd3T7nIeVUVzI0UE43RQ2XbE8my5WSbgzaYWWhKKPONr30L9BDIXBgfyRnp3c0q20vn/Oy/35fi1H3YS3jaSatAUUX+ZP2QhPFvfxhFK7KXAvTP64WY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by MWHPR21MB0191.namprd21.prod.outlook.com (2603:10b6:300:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.7; Sat, 29 Jan
 2022 02:04:04 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%6]) with mapi id 15.20.4951.007; Sat, 29 Jan 2022
 02:04:04 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 0/3] net: mana: Add XDP counters, reuse dropped pages
Date:   Fri, 28 Jan 2022 18:03:35 -0800
Message-Id: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b329db8b-796d-4d4b-2ad3-08d9e2cb9fee
X-MS-TrafficTypeDiagnostic: MWHPR21MB0191:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <MWHPR21MB019191F983F9C1013864B0FEAC239@MWHPR21MB0191.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRy+YYjFwQWFxpgvlKXp4QmdrZ5HqsraL69OsY3gzask8uvCsTpG7gx9Wbk0QJxplvp76erl1onCnfQfCkfYMi3DInXGLoKi5W69hNz5op+12ywSboQNGGEc8yYnzp82XB28vsRzKfWTyNet8jeksJflrVHjsf6NucOfV44D+A1z47raOlu1ZUdfGVUwG/HV4s95ZvKlAW8ZDaaS2JEhjMpUyoqslvrmje94HWa619xUWCa6GnHdNHl2YT7cCfAQsFkepr3JpnjgpoA5v1eD7+weAKcfK5hEfJSE7Kyi2Qq4nNwWdhOeRiR0P5MnXZ9KwRmC9mMldJw2a6ZUMR0uQuRmDN+mdSoJimqyPpjNLGbtv3rpK6RMf0cU+ORLB6LZG52hD/mxGywSLmp9FqyWwT8LsHj8wLetLTj2XcjLkuvw7Ff57NhUU9XTgaKsK0qxqCp/j0Je5LH6WUfkJd6oyBtNe+oUubBx5fYlDO34EgeXRzEy8a3plX5TOXU1wd8xHkp4mveUAVz8bn3EVsfsW9u+qh6zaD0WEvTsqhJLcc0L1MYmtZYh9gl+IOEQX2zGXwm1dfBVggst7ofNIDj5KlyO96APQ0t3KUNuxRhBYo8s8zdrrqFivi9Xpm7XgBv8vKJnqu6cXA84TEjODG0V3KqSx8Gk+BWppJt+eEC3qPYYx6Yg9L/egXPVxMeVIcbkKOsdbeaTwm1Yq3k37LxE2IBojwa98FdgLBj0Va4hn4QrwDhM1dHNTqw2vz5O3aov
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(4326008)(66476007)(8676002)(8936002)(4744005)(5660300002)(38350700002)(38100700002)(82950400001)(316002)(82960400001)(186003)(6512007)(6506007)(26005)(2906002)(2616005)(508600001)(6666004)(36756003)(7846003)(52116002)(83380400001)(6486002)(10290500003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yxqu5K4orWhl14Lro/Vfh6jprkYWjff1bgQvmQp822PLoUCvr3mnMyeBy4Jd?=
 =?us-ascii?Q?SEf2ZN5gkRXU0ipG5MA9iGMehoumGdWGjR1i13ThI1n9BlO61gZKRN28/Dsu?=
 =?us-ascii?Q?q25xMvh0cEzeK5tlX0KwjrUA61OUfmB2JTNj1sgLSkDLExu89iUOtKuuL42a?=
 =?us-ascii?Q?dkQAh6XhEUQy8MlltFG49wj5kz85pRfhBVfAeS3nNChWxTH4zWbC/3jP1oYy?=
 =?us-ascii?Q?YhJRjhGxs73Myv0hPQ5YcLIHr1tWbOIDFRckMdIgLDWXNydA/fFHRlAKmnpn?=
 =?us-ascii?Q?UTAiCxL0kbMj+ccz+5GLwQMHhKl7lWfDTQIBQZuguXM17/79ozpzAqSvxTQa?=
 =?us-ascii?Q?imA+4jvBJ7eA0O1TieMAvj53K5O5K4YykD/AnnlqLZp31RDflCF9FgVA50U6?=
 =?us-ascii?Q?ntj+Kvui6YTcLfcKaCMn0JI6knuyXFXYbd7wNR98Ld4GHXrN9Kni8+2H/zIG?=
 =?us-ascii?Q?C8/zs9lnSVzOCNKqg399fgKtFYSgLPcArGz3R64FneItXm0hiAQLE7+ogX9v?=
 =?us-ascii?Q?BGotv/Xwe0I6L/blqtQvQxRuSYTj3C/Ha2tlt5TdD94bSJig0kCWXOzGO05T?=
 =?us-ascii?Q?bj6w+hgi63HzgTeFHdYI8Kl7WPLHX0RJBgxWe/5X/CKAoWFFWXVudJFsJDUe?=
 =?us-ascii?Q?0g5cMdYhomRqzVPm+DQOqn8lzA6k+46XmHQwSlub3krTVfqrUlU4OEVlAMPd?=
 =?us-ascii?Q?fgiDM824znOCc7mpjqc7e1hEh2O4Nh+2kYgrCKSXF9hQsvAstbfNLeijqXI+?=
 =?us-ascii?Q?oh3XMQkssiRILsEPs63X12wP6SL+Uidp3v/iF19klPx6axXCrUu7kFfClUHP?=
 =?us-ascii?Q?4Cz/KYkNh2eD7P3D4hnJz+KMOza+OOzLtEjuoOgvwR/uDyrXToHnkhc2jpf4?=
 =?us-ascii?Q?Q817JuXq6sZSKqjSQrCG1xH++xywzSgEq9HFPHVR+WPllWZWuzqQs5+QIa78?=
 =?us-ascii?Q?5wzXAeq3RyFA1dAZMjvB6FkB0ARBYi7+EZlVUtdAROiUIThmIQtDZZJStShP?=
 =?us-ascii?Q?3A9mdWm7qH7DzmydmMx7Q2QmTuBbX1ZDU/iIB/FkI0+65gm29pOcIjMdQYcl?=
 =?us-ascii?Q?qggoxJaykXFhnot6+ZLmQ/jx8U8f577l2ApO0TCA3t2opHfpNNDtBuuCtNuq?=
 =?us-ascii?Q?ZAOyXWhGa1VjQ2kqNsjvRbVIlYkC6OlrHGQ5bxO7nioeBOmuHbK5ubj6Rbp7?=
 =?us-ascii?Q?I1yhDUPdioHXFRryP6Y6T7PWXV3CvhdByuCzxtQ+S0IunSDsyu+HxotWc8xc?=
 =?us-ascii?Q?f95QkOvV4duPjcRood/yD7Ji6CGIp6qf8TF12u2bs+yyJ/AFtvxJTYiTiRui?=
 =?us-ascii?Q?TKVFaV3k50/GrVo8BjH/XXE4KOQ1eW1TILHBu695ngaYqbbofdiSu5WgJ11o?=
 =?us-ascii?Q?eB/7VKDyL8Cm5SR/nT5gmPonB1uLfz1v+5mhIr0rOhQm0pXw+qaoVrFgCfdi?=
 =?us-ascii?Q?46H0ZY+msWhdQKOx++/y8u4kzY1DjJG12o2BHLcGqIO5kBh+Sgf0Pft3CNCN?=
 =?us-ascii?Q?ZQMfRI+KWjRGTJ/dg+DHFo084ThExniwlvl41OwAi1Gv3MXShkF/VUwtbL1L?=
 =?us-ascii?Q?c2mGCm1KPs6zWbcjTwQgHrCBmqUTLjdX4hyiQwZxjg6eJzjga8LpxQdvbi4r?=
 =?us-ascii?Q?DTaV+zvNE6/HPNyuXOe4YBI=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b329db8b-796d-4d4b-2ad3-08d9e2cb9fee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 02:04:04.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctOuc+kZ8HPiWxb0nwhURYU/8yaV7qleN0twBJNCBM2gTqOmXE212AtESWyvluJDmsSCW0FU463acLe7D6AuLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add drop, tx counters for XDP.
Reuse dropped pages

Haiyang Zhang (3):
  net: mana: Add counter for packet dropped by XDP
  net: mana: Add counter for XDP_TX
  net: mana: Reuse XDP dropped page

 drivers/net/ethernet/microsoft/mana/mana.h    | 15 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 60 +++++++++++++------
 .../ethernet/microsoft/mana/mana_ethtool.c    | 35 +++++++----
 3 files changed, 76 insertions(+), 34 deletions(-)

-- 
2.25.1

