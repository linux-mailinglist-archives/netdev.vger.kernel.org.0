Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D041C2913B5
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438583AbgJQSmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:42:11 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:60386
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438553AbgJQSmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:42:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6O51pbq6Ol7++u7oUnLNn7XEVmUrS9aC7mSgh+oULITAnYY5V2fijN63Cl3MJ2aC6xGzRJ7a6EF8T+NVm9S5fVP5kjvzFZizJxew2rKHd0KLEalcRV5Wmo3uL5BRdHaAV1jKRP40YKxNOSM9LZQdQByDIkIjdE1FOJDwlrfugk3o+AHTEvsuTfidfSyZVCetwKF3riVz7U51gQd5CeSwrk0FNESYSbS+XsCm2eLzE/0LATrtu48RU6eeGcPV9FB6RlksbhjgghoYpzHCJBiQf47653raNP+QoDtaMuwhO5xcx1ny6lqwC5y/e33hC5JB8airnJNT35EhljJ4fJYyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwZoEInqaj7hUfpb9/oN8vOZeuVLbXVRSBpcrEuxdyY=;
 b=gFNg9gl8LSrJbd5ae2eo431lz70t6SrRKj4ljFquU9obpwAgJNOqUSTbTjtq9df2hVWhUmV/+WuKH0mYdGXygqY80LY5SnKKnyt9xd3p5eRbw4cMjqx/wfXA7YUw7UZdF1QVyQBK+WegF874xENYnFtKVkSogTtYPpJ00KvgQDGtCr39ffLmKhaqyqABkV+JUqsiHvcfKOYunZaP6HzCdWUKH83T1SkejFvdJmfZR/CmcUZtazZXNwUdeNS1HBfn4Qm9sotkIkP5xyqH2HOasq6z1uS+gktkdn/vfoh6Q0XNVV1b8+syKLdpMMPGY1mu/4o6yvObu7qo+QkYD88wNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwZoEInqaj7hUfpb9/oN8vOZeuVLbXVRSBpcrEuxdyY=;
 b=fj/cjKhuRCi7NvhfUKjGDh+bYHldDvvwMpJFbaWR9q5jnZv11GmPDc7LriXZioPW4McGezMC6CQzu5R21fvHMDGanNBy41qDxboRO30fpVVG0Jn0hoVQmD1s0yG1omilCj8gmk7hoF4QesEQT/UjoJhGc/845pmBMhO8L3PgX0g=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Sat, 17 Oct
 2020 18:41:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 18:41:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, idosch@idosch.org
Subject: [RFC PATCH] net: bridge: multicast: add support for L2 entries
Date:   Sat, 17 Oct 2020 21:41:39 +0300
Message-Id: <20201017184139.2331792-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM3PR07CA0103.eurprd07.prod.outlook.com
 (2603:10a6:207:7::13) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM3PR07CA0103.eurprd07.prod.outlook.com (2603:10a6:207:7::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.4 via Frontend Transport; Sat, 17 Oct 2020 18:41:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f351a8d-b8e5-4fca-b606-08d872cc5010
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471BECDFD86D46FE812864AE0000@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EE3D2NY6bw9WNqhyLMkSIBvcUSnE4lkmYczPk6O0KY1bSlU3uRdnCFUp4FTU6W5v98AboBjif6pPOCJ2fV2S/Bu2uG2gAByiB5khJcN1RCGMIviuj8v9JjL+6qLJSCJYSSOmEbBT0J7jRNtcBY9n93O0aEvK2IqXvZDAmBpq/MoqvYazbY5ezOZ7jNYKIMDVgtiA8jjhIRTX7rdIdS4JDLroXj86zc7aDECO0R93U3ZolG+fkYDXJIUx5Ut13QkSCfpiX/Ot/VydzEO/95IJx+uh+TDNq70gvYMEBeFL+tHZsnmMYQ/1ClqTW/QqHTUmVcQvnSt8BRHnCs2Esj4+TKka9h8El+XEUIQ5RvWf9RLkNwNy0z6K9U+rrSGBhLX3vGR5ITrxVmZTdKjLRxgv6/5J1S+x8Jl6HKMzce0H7e8YXe7YKuX2j75ybH8bJerHVIClTja/hs8Oc2xj5nBBMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(52116002)(26005)(66574015)(6506007)(966005)(956004)(44832011)(83380400001)(6486002)(69590400008)(36756003)(7416002)(2616005)(4326008)(316002)(110136005)(86362001)(16526019)(1076003)(8676002)(66476007)(66556008)(6512007)(66946007)(6666004)(186003)(478600001)(5660300002)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7U6YBHhQAnIWObhpc7ykZ6SxiFpw/6sSwCeokVG39reE+NTligotRO301R0Kc4ScX0ekEJ++YyyZSXRS9treNryOzUe07H4R1onldMly2IDHjvP+isXuUVf+JIWkjXm/rcURQltjgfuTa+RtNdgvwsBiuWSsO2Lw21wIHRV5BhkXcnSx/6TSFrHz5QmZ1fsX9BikWgKN6KgBT6ou5h72WomaU+1iJpdRzizpq66T1puzS/Ib2mnuk/0LEgCB9lJNDHkuJhxROx8okX+L1IXAKWlsX6onURTiJLmPERtMeeXdfTikWcBByFAamGpiQcpsfpxkiUlEYacwuelNKKZYNQO1wPe3BICLtsqlugUTSuMt3jdDRHp7G1w6e1l4zq7J6upTOaKE0x6c0Ne4KnW66C1Hj6B2gmSHbFXOsMDysHe9uVEwJxBi7XducaaZCwnrfCP83dQwTZk5hPbRfkdABk9IeU8evjkgTp/Qp+3+1YOgj2IXAjhqySXMlfqyp3oiyPyo2dJ8bMxRA6QMV7dnG02FN1wiEhpKGuZo/hYt/xAbPyp635nRuQdLz1Wr4yV3qyZ7UKTXr+5p0YM0M6zHnfdw1pkCD5rztKa2ErpCmRNYzIeyXmgy0SpklfHRydVMKfUVp4qu0ar7KiYyMBLYgA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f351a8d-b8e5-4fca-b606-08d872cc5010
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 18:41:51.9710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIoyrwXsmLQxaa6yd35pWUlXZHxgO1SrXhEJQGDcAtg2GIpKtAAQ8vLNhrUaRbzfq2livp8WAlS8mc6R1M8m8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Extend the bridge multicast control and data path to configure routes
for L2 (non-IP) multicast groups.

The uapi struct br_mdb_entry union u is extended with another variant,
interpretation, mac_addr, which does not change the structure size, and
which is valid when the MDB_FLAGS_L2 flag is found set.

To be compatible with the forwarding code that is already in place,
which acts as an IGMP/MLD snooping bridge with querier capabilities, we
need to declare that for L2 MDB entries (for which there exists no such
thing as IGMP/MLD snooping/querying), that there is always a querier.
Otherwise, these entries would be flooded to all bridge ports and not
just to those that are members of the L2 multicast group.

Needless to say, only permanent L2 multicast groups can be installed on
a bridge port.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This patch is adapted from the version that Nikolay posted here:
https://lore.kernel.org/netdev/20200708090454.zvb6o7jr2woirw3i@skbuf/

There, he marked the patch as "unfinished". I haven't made any major
modifications to it, but I've tested it and it appears to work ok,
including with offloading. Hence, I would appreciate some tips regarding
things that might be missing.

 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_bridge.h |  2 ++
 net/bridge/br_device.c         |  2 +-
 net/bridge/br_input.c          |  2 +-
 net/bridge/br_mdb.c            | 24 ++++++++++++++++++++----
 net/bridge/br_multicast.c      | 12 ++++++++++--
 net/bridge/br_private.h        |  7 +++++--
 7 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 556caed00258..b135ad714383 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -26,6 +26,7 @@ struct br_ip {
 		struct in6_addr ip6;
 #endif
 	} dst;
+	unsigned char	mac_addr[ETH_ALEN];
 	__be16		proto;
 	__u16           vid;
 };
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4c687686aa8f..a25f6f9aa8c3 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -520,12 +520,14 @@ struct br_mdb_entry {
 #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
 #define MDB_FLAGS_STAR_EXCL	(1 << 2)
 #define MDB_FLAGS_BLOCKED	(1 << 3)
+#define MDB_FLAGS_L2		(1 << 5)
 	__u8 flags;
 	__u16 vid;
 	struct {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			unsigned char mac_addr[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 6f742fee874a..06c28753b911 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -93,7 +93,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb)))
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst))
 			br_multicast_flood(mdst, skb, false, true);
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 59a318b9f646..d31b5c18c6a1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -134,7 +134,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	case BR_PKT_MULTICAST:
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb))) {
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
 			if ((mdst && mdst->host_joined) ||
 			    br_multicast_is_router(br)) {
 				local_rcv = true;
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index e15bab19a012..4decf3eb7001 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -66,6 +66,8 @@ static void __mdb_entry_fill_flags(struct br_mdb_entry *e, unsigned char flags)
 		e->flags |= MDB_FLAGS_STAR_EXCL;
 	if (flags & MDB_PG_FLAGS_BLOCKED)
 		e->flags |= MDB_FLAGS_BLOCKED;
+	if (flags & MDB_PG_FLAGS_L2)
+		e->flags |= MDB_FLAGS_L2;
 }
 
 static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip,
@@ -87,6 +89,8 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip,
 			ip->src.ip6 = nla_get_in6_addr(mdb_attrs[MDBE_ATTR_SOURCE]);
 		break;
 #endif
+	default:
+		ether_addr_copy(ip->mac_addr, entry->addr.u.mac_addr);
 	}
 
 }
@@ -174,9 +178,11 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	if (mp->addr.proto == htons(ETH_P_IP))
 		e.addr.u.ip4 = mp->addr.dst.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (mp->addr.proto == htons(ETH_P_IPV6))
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
 		e.addr.u.ip6 = mp->addr.dst.ip6;
 #endif
+	else
+		ether_addr_copy(e.addr.u.mac_addr, mp->addr.mac_addr);
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
 					 MDBA_MDB_ENTRY_INFO);
@@ -210,6 +216,8 @@ static int __mdb_fill_info(struct sk_buff *skb,
 		}
 		break;
 #endif
+	default:
+		ether_addr_copy(e.addr.u.mac_addr, mp->addr.mac_addr);
 	}
 	if (p) {
 		if (nla_put_u8(skb, MDBA_MDB_EATTR_RTPROT, p->rt_protocol))
@@ -562,9 +570,12 @@ void br_mdb_notify(struct net_device *dev,
 		if (mp->addr.proto == htons(ETH_P_IP))
 			ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
-		else
+		else if (mp->addr.proto == htons(ETH_P_IPV6))
 			ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
 #endif
+		else
+			ether_addr_copy(mdb.addr, mp->addr.mac_addr);
+
 		mdb.obj.orig_dev = pg->key.port->dev;
 		switch (type) {
 		case RTM_NEWMDB:
@@ -693,7 +704,7 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
 			return false;
 		}
 #endif
-	} else {
+	} else if (entry->addr.proto != 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
 		return false;
 	}
@@ -857,6 +868,11 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			return err;
 	}
 
+	if (entry->state != MDB_PERMANENT && mp->l2) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		return -EINVAL;
+	}
+
 	/* host join */
 	if (!port) {
 		if (mp->host_joined) {
@@ -891,7 +907,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 		return -ENOMEM;
 	}
 	rcu_assign_pointer(*pp, p);
-	if (entry->state == MDB_TEMPORARY)
+	if (entry->state == MDB_TEMPORARY && !mp->l2)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index eae898c3cff7..bc03057e7caf 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -179,7 +179,8 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 		break;
 #endif
 	default:
-		return NULL;
+		ip.proto = 0;
+		ether_addr_copy(ip.mac_addr, eth_hdr(skb)->h_dest);
 	}
 
 	return br_mdb_ip_get_rcu(br, &ip);
@@ -1050,6 +1051,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 
 	mp->br = br;
 	mp->addr = *group;
+	mp->l2 = !!(group->proto == 0);
 	mp->mcast_gc.destroy = br_multicast_destroy_mdb_entry;
 	timer_setup(&mp->timer, br_multicast_group_expired, 0);
 	err = rhashtable_lookup_insert_fast(&br->mdb_hash_tbl, &mp->rhnode,
@@ -1169,6 +1171,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->key.addr = *group;
 	p->key.port = port;
 	p->flags = flags;
+	if (group->proto == htons(0))
+		p->flags |= MDB_PG_FLAGS_L2;
 	p->filter_mode = filter_mode;
 	p->rt_protocol = rt_protocol;
 	p->mcast_gc.destroy = br_multicast_destroy_port_group;
@@ -1203,6 +1207,10 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 		if (notify)
 			br_mdb_notify(mp->br->dev, mp, NULL, RTM_NEWMDB);
 	}
+
+	if (mp->l2)
+		return;
+
 	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
 }
 
@@ -3690,7 +3698,7 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
 	memset(&eth, 0, sizeof(eth));
 	eth.h_proto = htons(proto);
 
-	ret = br_multicast_querier_exists(br, &eth);
+	ret = br_multicast_querier_exists(br, &eth, NULL);
 
 unlock:
 	rcu_read_unlock();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 345118e35c42..63a98c1af351 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -215,6 +215,7 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
 #define MDB_PG_FLAGS_STAR_EXCL	BIT(3)
 #define MDB_PG_FLAGS_BLOCKED	BIT(4)
+#define MDB_PG_FLAGS_L2		BIT(5)
 
 #define PG_SRC_ENT_LIMIT	32
 
@@ -272,6 +273,7 @@ struct net_bridge_mdb_entry {
 	struct net_bridge_port_group __rcu *ports;
 	struct br_ip			addr;
 	bool				host_joined;
+	bool				l2;
 
 	struct timer_list		timer;
 	struct hlist_node		mdb_node;
@@ -871,7 +873,8 @@ __br_multicast_querier_exists(struct net_bridge *br,
 }
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
-					       struct ethhdr *eth)
+					       struct ethhdr *eth,
+					       const struct net_bridge_mdb_entry *mdb)
 {
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
@@ -883,7 +886,7 @@ static inline bool br_multicast_querier_exists(struct net_bridge *br,
 			&br->ip6_other_query, true);
 #endif
 	default:
-		return false;
+		return !!(mdb && mdb->l2);
 	}
 }
 
-- 
2.25.1

