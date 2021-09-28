Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FBE41BB13
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbhI1XjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:39:20 -0400
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:11841
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243302AbhI1XjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 19:39:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2VaHtzpoXxUSB/+HILsrxtPcczPEb3UWu+3ZlB3XBE/M8lzxuz6+4pw0M1ESjgF0fHKAHpRUbixAN9vlgVJw4F2/7GGcuz1buqh7dnwGWLAPvDRWjGALm9kX+KrTug1F8iRtgK3d2CtEdoPWYMt31Zh+lZ2dLpcQC9tHduDjYXa8qxhjS/3EitYmLkccDwMVCIMQj68BE2d88PbUkI5OqlOTnEWBh6yIRHl12aKjOXj70afR0tOIVm73wsDJQwZ3nM5VUh1pNtXHyOqQLIV3fyyCCLNrB/RMURs6B9kqJlhQRgi4Jfjsz/lOsoqsh9Aqw2N7YY63fD1yGwKQvBRBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UnGG/TMEjaOQLvhnxZZkFYFMJwVKcuPMCHSvRQojnJs=;
 b=no2j2TJWO463EuC97n1i19znagsh/QujeE72WNfqGazdJH/6lRA2LGqSPQMbpopG0b4IMOAfF8ARZFDqg1+ZEIO8i08c9ioPtWUbArLuK0ycvw5EVxLfbpSYQHwC9qx9WHTgijLpWj5iZzGydP1i2EU3bGFr7iDaoIZck2I9uPCYNPOQsHLv59Bt8IethZv3fZbMZygZCHRnVMwLATFK7V5Aouc03ZFEhYAUJKA8Sutd+OYCwcj88rMDOKGT4eq605kooUFvBRW2yo1XFXMY65/WHPyzYd6Oju2IU5moyUyXojchG7P2WuLqwmdD5RvFIiEr7V3IxmY8S96Q7qQ4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnGG/TMEjaOQLvhnxZZkFYFMJwVKcuPMCHSvRQojnJs=;
 b=kB3mouKL8bADPEUILaddrTreSB6HC9oMWJ6WsDcJUzZjG4xRDxaxTvVsAH+jff8Cz0Dyc5vBUokVoBvPKFW5eDMJ+WcqewHTr6yA+9Bhb9aWqX1MX+YDkXszZIo8gloE/RBpufhM2K69HROnj1ijS7ijVqCqo20iMXG/TkpWjbE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6272.eurprd04.prod.outlook.com (2603:10a6:803:fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 23:37:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 23:37:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        rcu <rcu@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net] net: dsa: tag_dsa: fix suspicious rcu_dereference_check() with br_vlan_get_pvid_rcu
Date:   Wed, 29 Sep 2021 02:37:08 +0300
Message-Id: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0091.eurprd05.prod.outlook.com
 (2603:10a6:207:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0091.eurprd05.prod.outlook.com (2603:10a6:207:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 23:37:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3a8cf1b-a785-4c1d-dcde-08d982d8f3ef
X-MS-TrafficTypeDiagnostic: VI1PR04MB6272:
X-Microsoft-Antispam-PRVS: <VI1PR04MB627266631EFF23834095EAF8E0A89@VI1PR04MB6272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iYePN0jPeCf0yiPEbbUxFYvYo92hn/1mQ+zu8/CVohezzsnE9F6iV9E980PqXknN5r/Rc2MLMyw/lN4Xxg0ttsvmt9JELdkvQEUHavGArsZQh32BeXJDWUbpHWZxntayw6MJLsdwNpd8Dty+N18SIQlFPFIvI7ROn27ZQZs1Q3yHerN69Hs/ABy8Dpqj1H7m+jiVJfEkMl7/RZjrU89RYff5IpllvYwEWNicGGQ2XAjN2Yvv0p/VGSGdrgUKNCyy/vWgl+GsbFZSKuKbPerdf75rDq3EBrsviMnP7VQnqaqHSpkMgeJU5QzyTlQ+KMRS9fZG5PSwdcRDSCvurWwXI0dIcKC/CvvT3Wp/kbsGhISqchj/5b2QTgm8UwKZFj3YyRx4PjRl2mhaNjAUZdA2/eJd4KXhyqb0b+JZi7/Dr0pTb6eI1V/cv+KiLHKMfNh6C2bDIBzQqybd0mabu7OwnWnMAAK/DDXPAPppLpXSreU618N+rv2ZYoju9paSphg9GoA4+ou3CAjRjWQ0abU+Patf7zf4jyr0/z7ZJsNIOx0jcRGnYiooaN06LF+ia2cE1k5wF82WIrwa9Ghvx5mXHzKNQ6a+JlO+YRBG0z87G3QGHHMVVWDVFtD5POMSTKgrEG0MzkvQoj9cY43SQVYykx6eFoDeovbQyjAsj0XNh1TyDoFAfMfdwP/jV9CSXRpi36ABdkUglxdVTO8F+epRXZIfz0uHptDwxWEyl6QYXW+7vuvU6Bfau6NeWhGiinnmq0s9ls7DrCN0CMdvy9Oiqz3V2xKUlTO2JmXXvyQbyLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6916009)(316002)(44832011)(6486002)(86362001)(7416002)(66556008)(5660300002)(66946007)(66476007)(54906003)(2906002)(8936002)(6506007)(508600001)(186003)(38350700002)(38100700002)(36756003)(6512007)(4326008)(1076003)(966005)(956004)(2616005)(26005)(52116002)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wSl1kTzpVjJmrVg65IRAZ+XgEuAWz9JnjOLRQD3bAaOLNWLP/uXkt6v7/nZX?=
 =?us-ascii?Q?2kVfODwm/s5dtuht6DqLi+SXGowvMxedJ5EsaGJoQ99UIc+HCmmFK2rmrA3X?=
 =?us-ascii?Q?IM3LM856ASteLMnF+s0y/zw7mQ4xUuVJ0etmQiHP6HGwjt98HFTgANZLwl6z?=
 =?us-ascii?Q?vGdBwCAhJtI7Jh51gr3HIW2zAYoZU3yUwTzclnDcBOud2ILEnms963sOgBEO?=
 =?us-ascii?Q?5z9PLgQc8mMfFJLktxCIUSd36NO5uT6bdeuadaprjWma8cbVJZR7EZlBFKy9?=
 =?us-ascii?Q?PAplHA+HVMEKa0F/gajWKLVEonbIe9OXlCO6qFoXVf+m32QEg1wHfheHx0we?=
 =?us-ascii?Q?mguPoqw57cK2aUKO6e1T2CM18RUekjOqKpuD/kdE/YHVtEaLQyglrxj+mWad?=
 =?us-ascii?Q?UIf+brm8C3f8e0koVOswqW3P7giuL3nKxpUIjIXLQyvzzGbrEHRsyjnBqn8L?=
 =?us-ascii?Q?oUz1heQ91fU2BFLar6aUTShqMmWZEfBimayTlCGv/1Z8IOLidk02he6IFbrz?=
 =?us-ascii?Q?lny65R0b5VU4vQrobNJaBsHqUGCKr69SJa1cauAWAIYPQ84155jjGGZircVc?=
 =?us-ascii?Q?dAv5oEhsyhNT+24VH8CWpiHjv/TK58jxwFj27J/L7on4CTsAFEjd19U9va5K?=
 =?us-ascii?Q?cLuYYkquV04zosaPSldiAJ1MVdY5BdqqKPbicLt2BsY9MJ6HnIuFcWaQPmn0?=
 =?us-ascii?Q?/KjN2Yz83hIoc5OovoB4WGZd2fcDIuOreEtdJGrGSm9pvaLu++oiWmC3ox//?=
 =?us-ascii?Q?m+OApSPqoxpFJhKG396O/EA2vUXdZ5tlWXHvzi0v57oDT/kB4LJ7Q0LzPYBq?=
 =?us-ascii?Q?TjAlNvQhqFLT9OiwkJP1WmDWmpLG/GIQx/5RftrH7pzisLLkQMi5QK2ahhFM?=
 =?us-ascii?Q?JmZYq6e6t3b1VUVgn5FJdVrLt/4sHogQ2e2+aUwJ7AoOAU7mb+E6dKUzGD+P?=
 =?us-ascii?Q?NghfF7+nRVs8XmHrLuhDTuBoQkW4y21rcry/XxvNYiFUzXRIpkonJGjF82w8?=
 =?us-ascii?Q?Ute4NcgAxcubIowWMrWl8nrbO2fPkw03FxPXRVmycbd6k7BdDNgOQySe5b4l?=
 =?us-ascii?Q?DRydNO+6IvEq/+4/ZAGj8MKZgWIYnOXYxu8mECArEXYlGz6y+HCbMyENdR9Q?=
 =?us-ascii?Q?zvIjhD3vkKhwyfuKMmLZ0+N3vGmw/fIjedJJ9BWhiu9y+ulWI4/jRMPIoDg1?=
 =?us-ascii?Q?hy/ODEbPnVi5rCGbVJ/4eBmEjjnMEQU8YmHEf9+pm/nCiAcWzKsiDxC3lQLU?=
 =?us-ascii?Q?4JC6zKvQcMLk9Qid6scjNaNEq0TfAdKDgV02xZx14DhdPibqEnNTSrn4gP7s?=
 =?us-ascii?Q?9a6YqH3tOq0rD+ZdvNz4mJGQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a8cf1b-a785-4c1d-dcde-08d982d8f3ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 23:37:36.8344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuLRibFRYBk62CaxrHjFWt16kOhGXkbJz4o9ffa3g4iQ8CS+zPrMzcoTG9QNbU0STUFENfWoLF4D4rfGQFAhHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6272
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__dev_queue_xmit(), which is our caller, does run under rcu_read_lock_bh(),
but in my foolishness I had thought this would be enough to make the
access, lockdep complains that rcu_read_lock() is not held.

Which it isn't - as it turns out, RCU preempt and RCU-bh are two
different flavors, and although Paul McKenney has consolidated
synchronize_rcu() to wait for both preempt as well as bh read-side
critical sections [1], the reader-side API is different, the lockdep
maps and keys are different.

The bridge calls synchronize_rcu() in br_vlan_flush(), and this does
wait for our TX fastpath reader of the br_vlan_group_rcu to complete
even though it is in an rcu-bh read side section. So even though this is
in premise safe, to lockdep this is a case of "who are you? I don't know
you, you're suspicious".

Side note, I still don't really understand the different RCU flavors.
For example, as far as I can see, the core network stack has never
directly called synchronize_rcu_bh, not even once. Just the initial
synchronize_kernel(), replaced later with the RCU preempt variant -
synchronize_rcu(). Very very long story short, dev_queue_xmit has
started calling this exact variant - rcu_read_lock_bh() - since [2], to
make dev_deactivate properly wait for network interfaces with
NETIF_F_LLTX to finish their dev_queue_xmit(). But that relied on an
existing synchronize_rcu(), not synchronize_rcu_bh(). So does this mean
that synchronize_net() never really waited for the rcu-bh critical
section in dev_queue_xmit to finish? I've no idea.

So basically there are multiple options.

First would be to duplicate br_vlan_get_pvid_rcu() into a new
br_vlan_get_pvid_rcu_bh() to appease lockdep for the TX path case. But
this function already has another brother, br_vlan_get_pvid(), which is
protected by the update-side rtnl_mutex. We don't want to grow the
family too big too, especially since br_vlan_get_pvid_rcu_bh() would not
be a function used by the bridge at all, just exported by it and used by
the DSA layer.

The option of getting to the bottom of why does __dev_queue_xmit use
rcu-bh, and splitting that into local_bh_disable + rcu_read_lock, as it
was before [3], might be impractical. There have been 15 years of
development since then, and there are lots of code paths that use
rcu_dereference_bh() in the TX path. Plus, with the consolidation work
done in [1], I'm not even sure what are the practical benefits of rcu-bh
any longer, if the whole point was for synchronize_rcu() to wait for
everything in sight - how can spammy softirqs like networking paint
themselves red any longer, and how can certain RCU updaters not wait for
them now, in order to avoid denial of service? It doesn't appear
possible from the distance from which I'm looking at the problem.
So the effort of converting __dev_queue_xmit from rcu-bh to rcu-preempt
would only appear justified if it went together with the complete
elimination of rcu-bh. Also, it would appear to be quite a strange and
roundabout way to fix a "suspicious RCU usage" lockdep message.

Last, it appears possible to just give lockdep what it wants, and hold
an rcu-preempt read-side critical section when calling br_vlan_get_pvid_rcu
from the TX path. In terms of lines of code and amount of thought needed
it is certainly the easiest path forward, even though it incurs a small
(negligible) performance overhead (and avoidable, at that). This is what
this patch does, in lack of a deeper understanding of lockdep, RCU or
the network transmission process.

[1] https://lwn.net/Articles/777036/
[2] commit d4828d85d188 ("[NET]: Prevent transmission after dev_deactivate")
[3] commit 43da55cbd54e ("[NET]: Do less atomic count changes in dev_queue_xmit.")

Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_dsa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 77d0ce89ab77..178464cd2bdb 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -150,10 +150,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 * that's where the packets ingressed from.
 		 */
 		if (!br_vlan_enabled(br)) {
-			/* Safe because __dev_queue_xmit() runs under
-			 * rcu_read_lock_bh()
-			 */
+			rcu_read_lock();
 			err = br_vlan_get_pvid_rcu(br, &pvid);
+			rcu_read_unlock();
 			if (err)
 				return NULL;
 		}
-- 
2.25.1

