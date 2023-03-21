Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15F06C2732
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCUBR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCUBRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:17:23 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe16::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538C6113E5;
        Mon, 20 Mar 2023 18:17:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Em05vLqZpr2uU1DotQHSzQZTyVik+H8oDLHmoKroGEWW+UY6YkK0bv4ieh1vqK6czsZSXjsFk/XQ0CZMR3N46Uq9qRYp5Ma8Bvk5jDHjIT+45cY9YBUDKgbGYbFOy3HwOiiKc/+2owG8I1I/79SxBCaII6IGjYGMkl6c0GP3PU0mvxTMs4w9J92r4SJJFt8qx4CGlk3DfBuUNCpweIF8O2G2SRfdWseSlBAqPBwedcANlbAwRe7wrphoqncKMV8w6pqg3WhSwhKDjoZY6Nc7DvHirYGOZcjadhqb7lwtkJdTXB4bzQUg8xGEXGzSQG1lk+WMqk0u+phVnVNLC/Mtyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0ovCoF8GnWd6FeefwDQqmhcz12BzUVp4Af+yCCFLZw=;
 b=QKv/ch7dU2vFepUg4Oj7IT5erY6DxWGQuUNR/LNmOmAqIAexSjd6fdY/xXRKsUsl8GpRPwUsNVTf1yZJMvxsp8uhscjX4xDNt7nOOKC/aB/j0pxr1k184uZw0v3ROPPtXQkwEuWEabBoVSzoSdJkIcrngYzgl2lFIULPsDKANf8fRwxGFdYyWiu6SXHqO9js3+jqv5b90jb+AvNtCFRwO94ZPTIhcKRdZmKTpcYtzQ0OOoV5q6JWIOn4IUuy/OVlGaJ/iphmsD2IboZpuOW9g2XHqM4cFtzqvn2I7Eq3+ctyKaoKgsVh7Lze3Id2Qco4mH0zQ0uLC9c74TKqPX20bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0ovCoF8GnWd6FeefwDQqmhcz12BzUVp4Af+yCCFLZw=;
 b=krjPlWhntx0FXkvURQr3aLQCod+uIJ7PHAeg4JE5SBsVvoVtk+Y9FHZu6v+tc5PKl7WFuMe7JJxNRhiIyD3W4YwsXWvpJ70xMERhyZ+UyWQiMDC0SqClcEslfPrQT/KPnPkUlx/Zup/B7wFWo+9pb33w0kglHf58LMjQ6tP/ldE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7911.eurprd04.prod.outlook.com (2603:10a6:20b:28b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 01:03:39 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 01:03:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] Fix trainwreck with Ocelot switch statistics counters
Date:   Tue, 21 Mar 2023 03:03:22 +0200
Message-Id: <20230321010325.897817-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0046.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e4ff0f1-2d7e-4b0a-89f0-08db29a81a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PN14YBlj+AZ13e/fkSEiu789+cy5Jbyzx/DOWnohdFtUUu1jvEVbi0EFKh979LNp1onze66a/lMD7FlKmIjhD0MF0wF1Chu4R4yFRBLFmOGu+QZl+ZhiZ20bZLVChkVUg1WxtkiYiYz6DfUrsM8HfLo0i0Y1Lt9sDIX/PbRZWD3z0W/0zF51bxS7M5txJzd1yrQFTo315m2NU/Ui/cuGWDfd6AOV0ExTERQ5nTHXqQEeJyK+gIrt1V3gjvgVbOu2cC6YnVJKoR34qiq0bzFU6RaY8safDxFsAQ2cqaaf8fbi/GVHpGfXw+9BtNj2lqp9CKPePUecqHx+EB7xA8lhgGSRJL8DpPFYnD/xYXnxBUZiCBWY18JAzQATRDJD7IHuES5V4gCBxXZuI46NLilnENbCcvGZQCXeGI7xIXtRaqyTsqmP0APuDWycwkj6y2lPzVtq+UAKyN91lUSJHJhzxn/uAPC25umoDvXnmC5qI2+arMj19JYa30Rw9sRzlFlHI+O6PGojwdERnClJ0SrbSO3V984SrMe6//wuo8sUTrgYsx5fqOCpS79b1Ia5uGAKzjFIJxFN19R0MolhWXIm7kBJ6+pPa8OjieWskA3fFgx0b/RkrXEDMrcLLg6+jPo5FRXh4pQ6uGZ5MkuygLi1//rVsSh6WMIQ5vWNuOqcPfw5/Qpgsgaiq8C/Ytwwphk7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199018)(2616005)(83380400001)(54906003)(86362001)(38100700002)(38350700002)(8936002)(4326008)(8676002)(66476007)(66556008)(36756003)(6916009)(66946007)(2906002)(44832011)(41300700001)(5660300002)(186003)(1076003)(26005)(52116002)(6486002)(6506007)(478600001)(6512007)(316002)(966005)(19627235002)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yrOPAYcFxY8i2mAP+UnczqG1lFQgbmU3Bq7rqEgs3U4CUK4+gyv5teIIwlN+?=
 =?us-ascii?Q?gF759eKx6yaCGGEfJU28+2VXiyqsybCWPaSz3s5EPr0dOuuzlhSZDnMDLsuz?=
 =?us-ascii?Q?SvqBrFV4ntd37eC0Y5xMXkj2uPafCnbTi7QFIjdW3I+5pfozlx5ZKcRI027e?=
 =?us-ascii?Q?fgH3X+/XcdVCIRoO6EuAxZOD/LXYayIsKaDI5vDrM0iccISREPo86UN5eShz?=
 =?us-ascii?Q?5hfjYrGSYnLFgwYRInXMX3xVSIEEaiaAvhpAN6f+nznbonaGAV44DyZCmBUK?=
 =?us-ascii?Q?YRBHEwjD8R3HhU76z3FC2ORwRl0x8cR6T4h/0Qqzbwkl/E8RUWJf7Fl5+W25?=
 =?us-ascii?Q?kEhtyByPcfudAxrtmZqaNcauhL0+SwdFV5RjPgqYPt/69b57jdddkjbZVMlA?=
 =?us-ascii?Q?y94c3dyPyQ3cn6709hjXVoMe7aYmKC7ACUubr8S+7OBKxmh6GlBtQrydc+ma?=
 =?us-ascii?Q?It7Zx32tQnixDW3J0RxtLa6/007/StEDPEXrHipHtvKydI3tm4KI/2GnGm7K?=
 =?us-ascii?Q?Tm5kMk3wrw7R9rJs9Fn0mtBtOa8TuLRE74mNEViSFEJ2OPMCMozanmXk/5vr?=
 =?us-ascii?Q?bUKwCji7qcsHhfAvd3Qk0S3GJgxHgnCAdehfRS4R7NJaxECQ1K6eARTqfWCH?=
 =?us-ascii?Q?+/AMndRwxzCr5cPJnAweXV342E06AYnke8jOl4MulI8yM0m9Yqq4B3u/yEEO?=
 =?us-ascii?Q?FR0DEqwHfhL15laARxpe1Y6G7t7rjkinaCyqEaXJabdpyVdPDA+FMTn4DoyP?=
 =?us-ascii?Q?3i76Bq3ueD3+sCRPqbAUaf7dol/iIv8c2l5Z5b8QFFUCL8026yZLnNnvyBGJ?=
 =?us-ascii?Q?XEeeivZmE3yMwu+O7+6PuvfAFirSDg/5ydK822pKX/wAC0ykq8atLjhwuYqF?=
 =?us-ascii?Q?gNRpwWxsMBdJ1/0dHG8EiJLA9VFA4gWYIXp3oL/PvG1gbO0OVrSaO3gbuJZM?=
 =?us-ascii?Q?zEdcUe5h4m7H3nBi7k28KOEKF52OsVo5YIaGX569mKQp6K3+pN8IKXZsPkC9?=
 =?us-ascii?Q?qu4PllX76w0mDU34yOrKXr9PHCbQwZ7MVioUEjQqHkqXTl4Y1GWeqcsSoISI?=
 =?us-ascii?Q?Mvbq5lB/k3LroG2sjJvm7BQChx8EgY6eY8sUUhqxsvOOqhkMurjmA9kjhKom?=
 =?us-ascii?Q?keotQB3mwtMkTYwssYKjvFzLPXgiE3yxbS5w7tKrFjtSGKwvPEw1p9Za6P7B?=
 =?us-ascii?Q?n1esba5zD3EYcghlXN7sT9XDvGVUmvsO8kQuPNGH0tQHphKyQy1yorUKSUrS?=
 =?us-ascii?Q?XUyo74rdY/Q0GdCsb+QWtiL4yfwrpUzM/RgNNR/yHW0ThWsX+0WR9P2Pc8LP?=
 =?us-ascii?Q?D2K9qxsJAI831Ht1irZEVrrXBO+bZnZ0V3cekweUM/BUrXepCcDG8JUMaCio?=
 =?us-ascii?Q?Oop9USfY0UvtETjIea+ITwuuYAt6bJpRm1LejCMW9P7v1chGESAIavZzccO/?=
 =?us-ascii?Q?m603BMqIOHETsGfbwgWlAg3VOMeW4m0YVcd/ra8SE6R8TsHhYRCHNW6UT+Di?=
 =?us-ascii?Q?h+eFT4MRflKQFb3gKegQXfergw4PiZpaHBUobNhztKXPJVq22lRwZgMCqy7C?=
 =?us-ascii?Q?OeZF3dNtEB6naKElLta9v04a+/ZBnpV2nA49TADHNy1op7UK9wfiiMoqGhd6?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4ff0f1-2d7e-4b0a-89f0-08db29a81a72
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 01:03:38.6140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MvWFjXzBWpwGpHUn+ds0u3yiyFKcgGlN+5/c6YoihLX3AGtyEDxnkm3UeQc0sDNjXCn7abCPxIoH+q8I4ZP/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing the patch set for preemptible traffic classes with some
controlled traffic and measuring counter deltas:
https://lore.kernel.org/netdev/20230220122343.1156614-1-vladimir.oltean@nxp.com/

I noticed that in the output of "ethtool -S swp0 --groups eth-mac
eth-phy eth-ctrl rmon -- --src emac | grep -v ': 0'", the TX counters
were off. Quickly I realized that their values were permutated by 1
compared to their names, and that for example
tx-rmon-etherStatsPkts64to64Octets was incrementing when
tx-rmon-etherStatsPkts65to127Octets should have.

Initially I suspected something having to do with the bulk reading
logic, and indeed I found a bug there (fixed as 1/3), but that was not
the source of the problems. Instead it revealed other problems.

While dumping the regions created by the driver on my switch, I figured
out that it sees a discontinuity which shouldn't have existed between
reg 0x278 and reg 0x280.

Discontinuity between last reg 0x0 and new reg 0x0, creating new region
Discontinuity between last reg 0x108 and new reg 0x200, creating new region
Discontinuity between last reg 0x278 and new reg 0x280, creating new region
Discontinuity between last reg 0x2b0 and new reg 0x400, creating new region
region of 67 contiguous counters starting with SYS:STAT:CNT[0x000]
region of 31 contiguous counters starting with SYS:STAT:CNT[0x080]
region of 13 contiguous counters starting with SYS:STAT:CNT[0x0a0]
region of 18 contiguous counters starting with SYS:STAT:CNT[0x100]

That is where TX_MM_HOLD should have been, and that was the bug, since
it was missing. After adding it, the regions look like this and the
off-by-one issue is resolved:

Discontinuity between last reg 0x000000 and new reg 0x000000, creating new region
Discontinuity between last reg 0x000108 and new reg 0x000200, creating new region
Discontinuity between last reg 0x0002b0 and new reg 0x000400, creating new region
region of 67 contiguous counters starting with SYS:STAT:CNT[0x000]
region of 45 contiguous counters starting with SYS:STAT:CNT[0x080]
region of 18 contiguous counters starting with SYS:STAT:CNT[0x100]

However, as I am thinking out loud, it should have not reported the
other counters as off by one even when skipping TX_MM_HOLD... after all,
on Ocelot/Seville, there are more counters which need to be skipped.

Which is when I investigated and noticed the bug solved in 2/3.
I've validated that both on native VSC9959 (which uses
ocelot_mm_stats_layout) as well as by faking the other switches by
making VSC9959 use the plain ocelot_stats_layout.

To summarize: on all Ocelot switches, the TX counters and drop counters
are completely broken. The RX counters are mostly fine.

With this occasion, I have collected more cleanup patches in this area,
which I'm going to submit after the net -> net-next merge.

Vladimir Oltean (3):
  net: mscc: ocelot: fix stats region batching
  net: mscc: ocelot: fix transfer from region->buf to ocelot->stats
  net: mscc: ocelot: add TX_MM_HOLD to ocelot_mm_stats_layout

 drivers/net/ethernet/mscc/ocelot_stats.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.34.1

