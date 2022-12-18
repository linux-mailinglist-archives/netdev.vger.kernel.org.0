Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9706465050E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 23:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiLRWQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 17:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLRWP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 17:15:59 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2103.outbound.protection.outlook.com [40.107.241.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02EE38B2;
        Sun, 18 Dec 2022 14:15:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqUNypdlwZ9N/s4CAIptMlqBh7TGkXBb4akbg0xdma5ONWk0EKG7KY73S2iybAwC/1U/dJv069uUYP+pnI5aDZpBqyTrUNUCcIinp9sctXrxy8zA3th5L/2QLqb7g+QZVyJhCuTpPLSh1c4E9UKIy5gyWJ0GV9gOsekqUOp4CaPnlEqFbWHxA0Wc1pPte4Lad7h1T1SBVJZTJ/jGeDoJ1omaea5F+j62DvBxnUmKyC9S83CIKkRK0IRHzMciUEiDUmDPe91wpS6hZ8o+lKt86SBlbmlr17Fuhhz0f57OC+ebjkdQ+NWV1j8itEwa9HCUtF/WaDYB+a0N6/Xxpa7bkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfpEXMTtmZoS3D3KGNVaCl6nzvrWtbvDnoPGUo7z1ms=;
 b=mvrMWXsmNq2apVE/AnsSLGR7gbMgD53W3mnjzFTg65TKiWGnIdFeubZNPmDx9sGLqo6EvfwA0kqwTfbAEPLlMoX0pZTMaFyCXmj42iQo41xqIlAnDyRQf5PCzrrMgYNZX2zCtUqunIryL3GWqQdsLsyeVP/CkuXHCHs3SzAUW/8p0GE0oJ1uyflpAmOys2crg0Z9oEnBwLyn39yS1MG7fy6G+l9NBVbF9KCvlqxqfoICCvOwGBAc4tpg4Jaj9KbXC9a8FTJ9lIIWB10Ww8dQ94G/GQ9EmlWNIupd2WlXR8bZacGA54E5uu5Yk4APUy6NPPktn7cv6A8SeGmgtF3+RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfpEXMTtmZoS3D3KGNVaCl6nzvrWtbvDnoPGUo7z1ms=;
 b=IkulgLI19TrJfkOH6DTGqXil8ZzHpedNx9vKJTyPHdcE+7bQrFHyMsny/klmBqmaBUOQvzx4a7SoKRfizaGEM6ZRmqGsIMpQocbmnaAd3PRmZl2XAUucm8HljIuoWsnN2zY+Waawgec3E5CgoGN9TBVjmLvHgcf5QjgRX2GsAbQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by GV1P190MB1874.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 22:15:55 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::16a:8656:2013:736f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::16a:8656:2013:736f%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 22:15:54 +0000
Date:   Mon, 19 Dec 2022 00:15:40 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 0/2] net: marvell: prestera: add ipv6 routes
 offloading
Message-ID: <Y5+RDIIGWGeKGUAo@yorlov.ow.s>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::20) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|GV1P190MB1874:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d05fad-4b4b-400a-2082-08dae1456e57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hicOBbjkEK1cJnMLUQ3x4Z+xRCua2Ygw8wkgrAA7vVs+Zi4/pja+ic9MbyDf1PlIWxyPcTMzcMyx4x6q2EsIB9Pj6wvPJ8bRqji2DtpEo9/j0qsl8FphDZk0LQxjfYSt8xTiQUHkAXsmrwr4nRV4MSJPArkQeRx9Lmkq4RAtHO+fVgLorzT8BkNIqQ6yxEAb9fM1krWik/sDMRtn6mm5lHRzGwC33zr3DIPVwhT2fsZfwthkfZrpEp5Y3pjqfze+j4ybEOYfMEzltiMb4qCxwIId/nJAksxWCe72u0m1ejN8mfOPlO/PWLeZc/ikR5EAhKdLsRVDFQZhENMt0NP+oSNc120qRdIxkE0t/EQyf294TW7K0tHcYe5pF0TkzZtQeT6Cv54b6k1GCLbgVoCGzXRvdVFgGWCLJgn11Y0gitoTaV3xGsWSlJ37Zap8GA/XqGvPRKS0/xw9L7TJh3ffKnZ7iydQ/kaa5Ve0ghtYPl9uLngCV27OJiy/YGu3ZNRqSyySw4M4FeWjevEtyNp/R53VvC9/11joQ/5DOCV+7dE0Gc2EbkpGq4FbpFKeFzYSm+kikqWEuOltdaZ8BeWHKFajfzmq7rd9/t75LmNFrIo6/oMwWQJ/HwAr6I2TS5VjgOZDFwGyirp/2OKcweSzqZ7Jkpn/z0qhDj3lH3MB/CzkN09PrAG013udJbJIdAGO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(396003)(39830400003)(451199015)(6666004)(478600001)(6506007)(6486002)(38100700002)(6512007)(186003)(9686003)(26005)(41300700001)(44832011)(4744005)(54906003)(6916009)(316002)(2906002)(66476007)(8676002)(66946007)(66556008)(4326008)(8936002)(83380400001)(5660300002)(86362001)(66574015)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/TQUbvUvq5YO4XuqsVSqBjGi8PI4rBRH/z6PvDsVgfgQluMAjbX/JlWKFgKf?=
 =?us-ascii?Q?425krzR3oF8jvM5hOe5C/JrpRb+WrIVB89ljj9e+SjSvX/pKoRK0a91NeWAB?=
 =?us-ascii?Q?dSQ5ZEqS0WAdAbLc6eHQx/EFkctTwkBFy5x6mPqSEAy7F+fxjklCaELY8QyF?=
 =?us-ascii?Q?A16xV6VFgyC2SGErSTuzm5cw0yWMhZSHyr5OEe1mmqvev4gekFFpdgE+7Gun?=
 =?us-ascii?Q?v2HdWnhOrvUuV/Slon6S23lfWoEj9L356BzqT8au9BpAvK/gdQlJjfwtkToV?=
 =?us-ascii?Q?sGYxSNpff2Ix8qoHmt6tSqw8zKg47wIbUs6Xxmk+yjusK4AgvvO1Jp/JF8fu?=
 =?us-ascii?Q?y6O2HSrKie7yI9vVo+kIw9PHLDfZsve2F2zkr7Wbc0AKEZDN2hcSjXIjFZJM?=
 =?us-ascii?Q?x5ZAg/tS1aUGHGP9ZG7+SXZ6FAkW5cKcmWFbSWsESeexx/WT0cTeUM/xgrSK?=
 =?us-ascii?Q?fJdklX5KIsESJBnER39jRbB55BgO+RzIIOhfgu2ptdU9RCrniOPxuxLYvuwT?=
 =?us-ascii?Q?sqwq1MfDBnATHZOCV4lMVbcroqlc5IwFk2S+sKd8B+J81i8fSua2KyZdRs7J?=
 =?us-ascii?Q?NNE/SxjINuiHcl8aXKKb1aNfMIpyJxNdFM2NIwD3YdhHnEMLzqoRqY5rHumY?=
 =?us-ascii?Q?TDC9REDwKzGwBARHob5GnA7hjxi4nCfWm+z+LZ9nc0lWljTGDgQgjQQXa7yy?=
 =?us-ascii?Q?k5tAi+aW1Bx4uGCmIztZZFOkj9Zvb19Uk71pgFkvVrcv3vup6sPkC/iiPJAM?=
 =?us-ascii?Q?KPSaEX7ikQGoRPygp5z5FN9IkrzduATCKrlGa3Xh7+B+zNwRaEtJVZF0Pz58?=
 =?us-ascii?Q?mkUw3SxbUWhr8JX14yzHDPh8oAy76VyQ3RLUISzQ2G+5y5lGV3qglg34qy4/?=
 =?us-ascii?Q?DO/+0zGUHXeL2BpfILbDB65v0QtXqLLr7TFaabSSh2qqBJgcgqoAe7n6NKgD?=
 =?us-ascii?Q?sXaBJ24pnW/8JqNJbcch3Du4zIZbWQunvfmaGXTSWair5Qmbz1G34IVOmoT1?=
 =?us-ascii?Q?/lWYPJLNRyiZ1kvLX6He1EUIMyXf4SPzleBtnnRLHWHclHqSnEaN1THFGbx9?=
 =?us-ascii?Q?XP1skqYrfsrw5zxxWBk1Z6Q0sY15FH25Nc5m2ooNyHwTGPvLK8LjDIZ1iN1Z?=
 =?us-ascii?Q?KNBT/69dvlGEJDdHkPjd/DwK88RACMggenOYMIBhU08yAVld4C1/hJcaGJ7Z?=
 =?us-ascii?Q?/qvPyYigPrJCODoVQEue5N0VxE1sYghh+IRZyorqmyEUVfPw3I36KbBrcG1g?=
 =?us-ascii?Q?UmNf01cy4B0rPM22GI6i+cZQqxRu156hHmbf0NcPc/TOjCh6TXi196ngFVWU?=
 =?us-ascii?Q?zghbRZCme/A5UCoTQK85koeweeCg6o1QK5Iliur3eSFMhTAd43fLZepXOcmd?=
 =?us-ascii?Q?fvqhU1vf5Iqfpst4mTxaxkoCLH5PQm24XUD2mUalWgaQdT5P2woe19WKUhsT?=
 =?us-ascii?Q?ByQkhL6iHAM3z7WFMm0oCEFl27mx5HF5tkW6yPzF/pAtTNuXD0idObTsnQg8?=
 =?us-ascii?Q?2ovbJtrV7oYV1qz6h4q1ZLA6tbcCQdMbNCqa2pxVgVGsnR/06VFUGWfbazZN?=
 =?us-ascii?Q?vD77Gzw0o9tgjFqvvPvuIP7uxv5/LVtWclSHzv2irP6ymHKtdW6dTkNj74gu?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d05fad-4b4b-400a-2082-08dae1456e57
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 22:15:54.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q92Bi91DF9LAhjDy7GWYazw6qgU8NDYNwe7DT92xfB34qjfL9vvQWeMUkdzmdMTOtybeUd0U+nAgSZoArfiFV65PpomOgsVnnnTg66xHRkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P190MB1874
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for IPv6 nexthop/blackhole/connected routes for Marvell Prestera driver.
Handle AF_INET6 neigbours, fib entries.

Add features:
 - IPv6:
   - Support "offload", "offload_failed", "trap" flags
   - Support blackhole, nexthop, local/connected/unreachable/etc (trap)
     e.g.: "ip addr add 2001:1::1/64 dev sw1p2"
     e.g.: "ip route add 2002:2::/64 via 2001:2::2"
     e.g.: "ip route add blachole 2003:2::/64 dev lo"

Limitations:
 - ipv6 ECMP is not supported
 - Only "local" and "main" tables supported
 - Only generic interfaces supported for router (no bridges or vlans)

Yevhen Orlov (2):
  net: marvell: prestera: Add router ipv6 ABI
  net: marvell: prestera: Handle ipv6 lpm/neigh events

 .../ethernet/marvell/prestera/prestera_hw.c   |  34 +++++
 .../ethernet/marvell/prestera/prestera_hw.h   |   4 +
 .../marvell/prestera/prestera_router.c        | 138 +++++++++++++-----
 .../marvell/prestera/prestera_router_hw.c     |  33 ++++-
 4 files changed, 166 insertions(+), 43 deletions(-)

-- 
2.17.1
