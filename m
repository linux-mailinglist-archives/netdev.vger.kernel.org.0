Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FEE42584D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhJGQtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:49:24 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:18693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242836AbhJGQtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:49:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArYSnhMQu80wFil64XYFEdKrHkeQ5lZem4LByERvUYJy3o18PXtDvSQpJ6TZRYC+UZUPjdcydarDSlwvqS7XSINet9mNhIQinwSJNv4S7pawWtxWVUxbWw0JIJy7q0EtZkviwbuX9UCeo+rniWwDJlix/C/RM8UUOHLmrvX26dWzSGEOXPGH/V6OwD/4qWUHRu8P8ODC/DLfYBEJd+Qm/Fs3f1NzVK0POsmcT/8R6k/9vydGhe8a/+UGC4E1Z4V908bJViRvoq5k6Dqz3ibzWOzGrEVytK5PvBEwQOGs3bHgbscblX/AvxUSl3KoI8mhd/kpM9O6k87h8XiKH12MUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5nE59ema+AnTApdrHh76/zOLmgpmKAgldVMFoUKmBI=;
 b=QgqU7sz72ei5MyEcjkBkOwPpwzAFbberLBSgvCrp4RIxMEzAIIWQvksS4frwE56ZFMlv2l1JpkvlwOJok072f3fdkWnTU8o7NxcE7mhUSZmWF4o/x/8MYRyWxx/6xuyMUOmpdHFNA238mEMisIY3PhwQ/PoWW9vbin7vNJqxgz20qttJvZmWwertuWno2ASovAD+JPDuKztVqYDDbBBCU6VAIRvJLRf2DPRlFbRatNa6cgCiqblrn8yynPBzPi9YvbMLEL0Q/rWsqorhSryNbPv8uT0njX7sDci+nRW4jW4nQnh0ynim2sAX7A+UwNAL7WTzaY+k0ZyHYaUdxedqcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5nE59ema+AnTApdrHh76/zOLmgpmKAgldVMFoUKmBI=;
 b=FELM48UbdqASpexGEH5Q50xQbQtvp7QkMuPtkxNwVITifqVfL6ftYIGfnN1cszrKnoB2p0zwmH95zgmnz2409+aGEAZ44Dlt6SPeGpr0pP1LKJV/bNTa0YEtp8ouiEmKXSpAAou3/4Wrzd7K7kZAbTIqQXVZgUEHPjEw+RuSY18=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 16:47:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 16:47:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v3 net 1/4] net: dsa: fix bridge_num not getting cleared after ports leaving the bridge
Date:   Thu,  7 Oct 2021 19:47:08 +0300
Message-Id: <20211007164711.2897238-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
References: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0105.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR08CA0105.eurprd08.prod.outlook.com (2603:10a6:800:d3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 16:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d90bbd-4184-45cc-24b2-08d989b224a9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549EEACE12CD2458A7DD376E0B19@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtMNhlULj5qoZCUmTNCJsKn2wczSXg9IAfDP266MvOvYFvF4yUDEhUUJKeRtr8+fRPdFg0BOLTr6XeX7unbTXkjwGuCGrCqpAEemY1t3devOzNlf5/Zcfeg+BnR0tDmpaHRI4tv3yfBvzmFd8dNPMm30a4F4aBPdNcvTavR2Ckc7wi8Zhr4TQpRmAbJf/XA4gylE0gWdPTZwoEMrNKNLLjEGDsMP9jPpkRbfQ7aHdG2OW6OjZ25XqB8lqhsyJyn9Q0d1/I8GNt12KjLtupgOnVnjtsjRdFga3FREm4+bHE/aGrn83dV8JQOOljU1KCPz2ZQUVqVwNu4Cgip0ImwAn2c/6P2rmNaKHK47Utam5O6FVMDJrOK1SXd9ttL5c4bNuPp8ZX1M7M4bhKYH5wffJDtLn0vbJbsEmgcZoNRrfNFhIY0wNGLxm9RW9Rvznqoqfh0HnqGlkLmyzUXRrbdeeEmD59HrMKtGZEDK3TVEKWCiahJU4bPmGRKsbR9vgyg56IaZX8mQbGbTpphS5qVZaIsMLvndmAWUOJLy/FxrR+knm47apOJY8lqpt3kaJ7jF7mZpxw5/gJZCdMM/ei7tR12WCjKlobdn9LA3s14+vYf0kJXpc9ku/F+tEj/HDvk5WvVwyC3jFWNA0/Tzb/q+uXTWSrt6WTXqN0wBLvqjKP6S/nA4VDRI1pSkvaKL55nmjrS545ZuDMSHHcw23g3EMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(83380400001)(38350700002)(5660300002)(316002)(2906002)(110136005)(66946007)(1076003)(54906003)(6512007)(66556008)(66476007)(38100700002)(2616005)(6486002)(956004)(8676002)(52116002)(4326008)(6506007)(508600001)(26005)(44832011)(186003)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jcs1ygJLrb+OF80K2S0wSfKBSwfPTC1Y+wMvJYV3jiUtmTytInkmXaBm35xK?=
 =?us-ascii?Q?lFIDs2SB7GsIoWnqTj76vn29x4gxQ55a/2SzNQ7eJXhwHpctk/xNqYhtjJXW?=
 =?us-ascii?Q?EdjsZlGXZT9wi3o9hYhB1t24/GUbd9+2aX8UQ74Ejlwcf8jXtRyBa40azOjD?=
 =?us-ascii?Q?7/qPxJMcMM78lEo8EZ8M2M8ybRmSjSt4G7peFNwyoYpJ21LVAeHi4Idn3BXP?=
 =?us-ascii?Q?qH46PG1ttHZkdVx8N5CEUEjpni87BS7spF/YTh9fUcaILm5F+PrWgb6VICSo?=
 =?us-ascii?Q?/6+6nHs2s4mrBai9mPhwoNVIScwDxjhYEEaiD0E6ajd7rFlp8cadw5xpVvBg?=
 =?us-ascii?Q?GbBYaERm67eunoJH/EwOgVYSHTUvaiiUC3V5TqKZHT5a+UzvcGphuRKf1R95?=
 =?us-ascii?Q?NKgr3x4vi9Petzj+4SXF/pVfTziYZTptQyVH/pL4dsrj92PJkuZdzVRJ5ifE?=
 =?us-ascii?Q?PGGOeeGyMviFMZtbwLamp8WCO6IDOsns92siRWaxP9M6OsujyOWEwMDJbSxE?=
 =?us-ascii?Q?c5kNiGFSYJPtx8tBF6/4aJXfgf29zMgS224xNq8qSpuua9REPfiiUzb5hMGO?=
 =?us-ascii?Q?0kMKn/rb4a0FLU7rgiBeaiEfupxJLhnWWYuVjBUt3nNoHEjHGAScc4ltcSlL?=
 =?us-ascii?Q?DQWOr1nTBKvhQj7st6HZu9xnWmfthv+E7q8docAwPYWJOXwzdZEVkEaYyb7t?=
 =?us-ascii?Q?Q7WC/1mHCblafTDIM7+ef3JdDZaKfo4cmJxPKfbKywIYfbTu9nBJKc/ffVsG?=
 =?us-ascii?Q?E3drl8q19ix+NT5mzQGB9ORqbQGynI73K+fo1B/dw3MhGQ02YP9CxDCc03L6?=
 =?us-ascii?Q?dztmHsbChS2cNTPbBf3SYFL9NuEASFWgE3kBwqHQ3OC2JUyRP+23JYOoDI30?=
 =?us-ascii?Q?s13wIafcXpJwoILeLUJBmbvX6CLcCwEDCUQgHR9npEzkC1FUNEd6rV9cIduP?=
 =?us-ascii?Q?BRarRQz+/uXRn4jOpUG+375EziRaa4Z0KYbSWG9AV65OcYh1KV5Xsy5uOhBe?=
 =?us-ascii?Q?KOiOtlHxIVc5oZxluA7HOCDLUV/Oi9jX9MRV9Cn909hZ8wvYFFb3UqC2WwnS?=
 =?us-ascii?Q?Q4gHA+Vw2y7OWUpefar/dnCR7UYhwmDVxFcN24dsQ0cXOuyFDJfi2MgyvizG?=
 =?us-ascii?Q?OIdK8LRdnktkSiSJkijieX6fBRhHOZ2sDg/dlHhBavZa5RILK0rQwa9FBdDs?=
 =?us-ascii?Q?tC6VNHHtwTaAOf6nfjwMeP+XvCRQ0efQ0ivKD+ugLUCgeE9FmD/NZnjDEZdS?=
 =?us-ascii?Q?D8IJjlQVBoIIHtieEu5NZ4jVkKKEJxhdQDIwItNqDGxFyMkX6Vh2QvnWAa+r?=
 =?us-ascii?Q?kBnz0YQNyL9mSmEa4Y5rrFam?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d90bbd-4184-45cc-24b2-08d989b224a9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 16:47:26.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kF72L90sBplxgyoJkdtXd04JO+Akq7rO9Z3EGAn5czG85HYVuvrHCHZNtrN4T/TTy9Wn1gnFHPzjH01XbF/j8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dp->bridge_num is zero-based, with -1 being the encoding for an
invalid value. But dsa_bridge_num_put used to check for an invalid value
by comparing bridge_num with 0, which is of course incorrect.

The result is that the bridge_num will never get cleared by
dsa_bridge_num_put, and further port joins to other bridges will get a
bridge_num larger than the previous one, and once all the available
bridges with TX forwarding offload supported by the hardware get
exhausted, the TX forwarding offload feature is simply disabled.

In the case of sja1105, 7 iterations of the loop below are enough to
exhaust the TX forwarding offload bits, and further bridge joins operate
without that feature.

ip link add br0 type bridge vlan_filtering 1

while :; do
        ip link set sw0p2 master br0 && sleep 1
        ip link set sw0p2 nomaster && sleep 1
done

This issue is enough of an indication that having the dp->bridge_num
invalid encoding be a negative number is prone to bugs, so this will be
changed to a one-based value, with the dp->bridge_num of zero being the
indication of no bridge. However, that is material for net-next.

Fixes: f5e165e72b29 ("net: dsa: track unique bridge numbers across all DSA switch trees")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: none

 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b29262eee00b..6d5cc0217133 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -170,7 +170,7 @@ void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
 	/* Check if the bridge is still in use, otherwise it is time
 	 * to clean it up so we can reuse this bridge_num later.
 	 */
-	if (!dsa_bridge_num_find(bridge_dev))
+	if (dsa_bridge_num_find(bridge_dev) < 0)
 		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
 }
 
-- 
2.25.1

