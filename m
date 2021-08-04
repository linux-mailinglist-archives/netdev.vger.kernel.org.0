Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880CF3E01CA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhHDNRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:47 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238395AbhHDNRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZ631Hx+ocN/MJL376Ym3LXaN9XUq4FV/aOyqVIB8JhGq2NcZopDCuDmVFogtfnu/H5DXyMsQUmQP/PPzN5JMfu5x9qmRSBumXKpqQ29Wrhn32f0Ul5LlhHvj0g6Sz0JUJTjzags9EGO2PttLX5diVrjPPjSyeEDVGSnkAFj8buW2efU4fvPpheksw1FFcddHqHmVW0sp1VAx1tIG5VF63c68u2+SI6/UghOrJ0EUY6w89ED94l+YqmVos9p4tYbWOgS5D/BENDcbdZMARf/K8zbP9S9t6QeXYiK+g1V+1wTj01EMqvoskd5p4LCKm7zlvZuVbekcqDd/vMRjYckzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TuMvmJH7L+Vlds5rFAsFSG1+pHMWI8Fb91zoNxYNiQ=;
 b=kmk/XZpQaglGOkG7G/3ZeFP2trAvE+SdcNX1RP/ySg/0wpyt4/ZKYZA7X2qHHYe5czueVjTlIKCttny7zhHIkdONQe0raayOvV17+gf9gPlNlhKdUY/aV/Ed+g445qYxrI8JyYwVCVfqhKSBmHtJa7Fda9yKUxRriMeCbAiq5VtDfolRlrUnFJuKIfTRRVbBev/OmVlzCx/BgZlRj9h4FvxzkNpyCXVJyIgP+tw8CGf01g75PwXInHBUOJismZz616IDcl4i0g3pNp5yIWKgdzm1OW3UcXy+oEo9kpneUnMtnpWVmxpQp3SNa9ou3zG7q63cI7AifAs/nzJgXweNDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TuMvmJH7L+Vlds5rFAsFSG1+pHMWI8Fb91zoNxYNiQ=;
 b=BAqS764intfuNEkFW7u9aJMo3TU5BhdJN3eKvqidXxEOrPshh9ou3YoioEDPz/uC5Y2L78jKAPsU1Iw72G0aFKg8j2zOEPTEnXwn9RGOurDYF/VPwGxtIApN4gdyqnVYiNBK0Z0C58MtY8SK1QnNdJCgklc0RzVtPzadOLQ/Il8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 7/8] net: dsa: sja1105: suppress TX packets from looping back in "H" topologies
Date:   Wed,  4 Aug 2021 16:16:21 +0300
Message-Id: <20210804131622.1695024-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: baad7471-94f1-4d7d-52f1-08d9574a1d68
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39672530463999378AEC193AE0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6LBIrtcVkrOX97CMzTB+Tb70cJWSk3PqR7Sia0N87/l8M18vEkKuMLgO+JlaL92beMPglafB9QwxWEvuL0tjHxZYV/lVJARpZX5L+IbhhKtyjcsT9WbPVgS9o6LdC6UZMXp6ehvNfrCoS7hMQUJzyB8KvC0qPxuZtCL1Z+DyK/bZ7NVZTxdRSLxNhrmw2ukBadww59GlY8FkWMTYb/wBNGueQ8XRcyLRX8+zD6nlRvhQqnKn2wrJlFKqzPvg6biC8sgILoXDgOv8IdUTkVlNRDS7TMmkcBuVE7JhZsUWtI/dyqRY9fMdIpWwZt99d8yEeZ6r6coDugB7UFQnXcwFRkNNNX+o9G9cSeenK+GDa/QDkcdfcPmIce1kz0ByxdTKFIHuI5IrVDjx5tM5iI9IT08dloUaIO14cCinCGvJzchLHLIz2UwepifuYBOW1GnjCUs7n+zJhTF++CzFpATeJnQtUpZOAkz9ds4tuIq2gs1Yh8/vphUGBQv5bbcn45N/qLMI+mjhlj5U4zadNHzSwrhtpA48dzXmg9t0wRcSGkxYYl81utPD30l4T13UwkaYSugILJDd3tHoImtlXsYNSsYsNBHo8SwTpNczMx/j5gKnGwsUsG+KBZZxY0bogwfc4eMNUXvI/yv//xKJnxL/n2vaKjLWvQ73dtB0Nh7V+YPOOx2a8lSR4mO+m06+o21RfV3GStFmWdfa3EY67RZpZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGG1JQTZNuf7Uteb23V+kW0mLsxk0ETgp7afwwLVmkkuEv/K4AwKPME1UiG8?=
 =?us-ascii?Q?7jJoa+0312YCrvDk+u+hyuwTqCKAYzB3HnuC7ci/Z55zUk/tWdwsF5X9psGb?=
 =?us-ascii?Q?bN9r/3SoEf/pPwH9GjYj2d4JnXUSXjQwuY3MJRGX6ZRSFLlHAqRcpnz+6RRM?=
 =?us-ascii?Q?+PzWU4Rm4hazz/1CN9abKmiM+dK4PStd3dAL24owCw54tVnqS54axcf9YtF2?=
 =?us-ascii?Q?fQwnHFZtV//xjUbagS2eIFAbR9fjX2yR2LOml/DMnlN9G7KBWpUfvtU/4DiE?=
 =?us-ascii?Q?YoP3lQ7pObt89eDmKHnVuaZgJrsoLNU5Io/F0w5HKBXDQODi6ru/nQLs5rzG?=
 =?us-ascii?Q?Qdh2WNNkPnTAHApPhDzDFql0WDgkKwo97PltYEndR99ikmpS1ey5Ad3ZllCc?=
 =?us-ascii?Q?EB9803PIUH3upGw7JZ9qG1qWkQEoaHewLbxhodxGn/oqMcp0DcsJgXJteOFW?=
 =?us-ascii?Q?wUCTf7HgYF+vQR6UwLSkzERawppljezfqPycMEJ63qcupzKifc3bOqpSi8OK?=
 =?us-ascii?Q?gyL3gGZi8ljf2DyWeVeezl+K9ojr8Kid5YS5zxF5DC6MijdlS2qnfkA75BYU?=
 =?us-ascii?Q?efmclxYmxGQAQ7W7E9hZ52cc6yA2j8DF9HS5KbiSeufZvgGib5RNTK54DrVd?=
 =?us-ascii?Q?qbn7CKSrWHjNGxM4i0/Hwi6styOLsSitDdw0u3NYlr5AycoaujXI9An7eOnR?=
 =?us-ascii?Q?+STm1ttENknV3uVbKJFuzVFCxZ5FHT+p4YLm4O1scYBmM76sGmvwOLyqCDuo?=
 =?us-ascii?Q?inxbAXpnIgzdaVA+V6AKPHFXymfh61sxHEMy7YabTMasvABqvPKmGeBBM3cY?=
 =?us-ascii?Q?k3MPYEOcJ5oQyilxC+EHuqWrMzfaon0wLbWx3QSdnfFlUcQ1oQnZrYWRl2Yt?=
 =?us-ascii?Q?8k8ztvK+T6Gndyfk+t6J4IZYn80Wlh8jbzd65dj5BWhTBAkZGlsW+UPqQFkc?=
 =?us-ascii?Q?Sp5uqjYel1rdP+NKyo2U/R+jXgoeai5Ge9sAUvMLF8ubjo8UPsXJD3yl1wXp?=
 =?us-ascii?Q?iLgZNPOVCTDeyGjJvz/aEo23A+kAwVsAOwyEI5beWljkIUyEYYu0KWcQF6rl?=
 =?us-ascii?Q?DCPdJ8CtLJR/9GW8zvQQ4lybWW9e/uaRINmINijEVDa0LvgjWXopCM5dzFEB?=
 =?us-ascii?Q?h3ejBftUAoMN1sDsc4tHQjk6l8ONEc83mHsTdRQv/U4xNCSkC/Akd8ptlFBe?=
 =?us-ascii?Q?zcHbxhSTJIAx6eHkOKWXlR99mpAKx+OsNu2f1t03y4HkeGue3tbAbFFeoAQh?=
 =?us-ascii?Q?X+7w1CQB6ueherkOMo+dko0KcS17JAdpA8hOdMm9xWlUaHiufA5D8buxq3F8?=
 =?us-ascii?Q?2oxs2HalwyB6PUd3qUsmHcpl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baad7471-94f1-4d7d-52f1-08d9574a1d68
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:48.3877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgG5REWdjGTRJbav1qqGR30R/ANeatY06FLuiZe+uSBpNIopM08wfGlwfCwADKw2nJPv2MCxxuSKCWGB79hZSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

H topologies like this one have a problem:

         eth0                                                     eth1
          |                                                        |
       CPU port                                                CPU port
          |                        DSA link                        |
 sw0p0  sw0p1  sw0p2  sw0p3  sw0p4 -------- sw1p4  sw1p3  sw1p2  sw1p1  sw1p0
   |             |      |                            |      |             |
 user          user   user                         user   user          user
 port          port   port                         port   port          port

Basically any packet sent by the eth0 DSA master can be flooded on the
interconnecting DSA link sw0p4 <-> sw1p4 and it will be received by the
eth1 DSA master too. Basically we are talking to ourselves.

In VLAN-unaware mode, these packets are encoded using a tag_8021q TX
VLAN, which dsa_8021q_rcv() rightfully cannot decode and complains.
Whereas in VLAN-aware mode, the packets are encoded with a bridge VLAN
which _can_ be decoded by the tagger running on eth1, so it will attempt
to reinject that packet into the network stack (the bridge, if there is
any port under eth1 that is under a bridge). In the case where the ports
under eth1 are under the same cross-chip bridge as the ports under eth0,
the TX packets will even be learned as RX packets. The only thing that
will prevent loops with the software bridging path, and therefore
disaster, is that the source port and the destination port are in the
same hardware domain, and the bridge will receive packets from the
driver with skb->offload_fwd_mark = true and will not forward between
the two.

The proper solution to this problem is to detect H topologies and
enforce that all packets are received through the local switch and we do
not attempt to receive packets on our CPU port from switches that have
their own. This is a viable solution which works thanks to the fact that
MAC addresses which should be filtered towards the host are installed by
DSA as static MAC addresses towards the CPU port of each switch.

TX from a CPU port towards the DSA port continues to be allowed, this is
because sja1105 supports bridge TX forwarding offload, and the skb->dev
used initially for xmit does not have any direct correlation with where
the station that will respond to that packet is connected. It may very
well happen that when we send a ping through a br0 interface that spans
all switch ports, the xmit packet will exit the system through a DSA
switch interface under eth1 (say sw1p2), but the destination station is
connected to a switch port under eth0, like sw0p0. So the switch under
eth1 needs to communicate on TX with the switch under eth0. The
response, however, will not follow the same path, but instead, this
patch enforces that the response is sent by the first switch directly to
its DSA master which is eth0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index fffcaef6b148..b3b5ae3ef408 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -474,7 +474,9 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_entry *l2fwd;
 	struct dsa_switch *ds = priv->ds;
+	struct dsa_switch_tree *dst;
 	struct sja1105_table *table;
+	struct dsa_link *dl;
 	int port, tc;
 	int from, to;
 
@@ -547,6 +549,33 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 		}
 	}
 
+	/* In odd topologies ("H" connections where there is a DSA link to
+	 * another switch which also has its own CPU port), TX packets can loop
+	 * back into the system (they are flooded from CPU port 1 to the DSA
+	 * link, and from there to CPU port 2). Prevent this from happening by
+	 * cutting RX from DSA links towards our CPU port, if the remote switch
+	 * has its own CPU port and therefore doesn't need ours for network
+	 * stack termination.
+	 */
+	dst = ds->dst;
+
+	list_for_each_entry(dl, &dst->rtable, list) {
+		if (dl->dp->ds != ds || dl->link_dp->cpu_dp == dl->dp->cpu_dp)
+			continue;
+
+		from = dl->dp->index;
+		to = dsa_upstream_port(ds, from);
+
+		dev_warn(ds->dev,
+			 "H topology detected, cutting RX from DSA link %d to CPU port %d to prevent TX packet loops\n",
+			 from, to);
+
+		sja1105_port_allow_traffic(l2fwd, from, to, false);
+
+		l2fwd[from].bc_domain &= ~BIT(to);
+		l2fwd[from].fl_domain &= ~BIT(to);
+	}
+
 	/* Finally, manage the egress flooding domain. All ports start up with
 	 * flooding enabled, including the CPU port and DSA links.
 	 */
-- 
2.25.1

