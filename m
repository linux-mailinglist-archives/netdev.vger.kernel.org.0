Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EFA29DAEB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390627AbgJ1Xis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:38:48 -0400
Received: from mail-eopbgr130050.outbound.protection.outlook.com ([40.107.13.50]:19086
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390546AbgJ1Xip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:38:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ku967qhQ0MkgLKAEx6iMezXhNChBvi9c2SUnQbUxMZLLUyF5N+dnV2kw/mK41sWdrg40q5jbRyUR7Jjc5sApcD044VerIrAcCWwG50+nDH5gPHWQMQY+ehY6YS2AhoDoQdfbIkiM2QlNMBcRFWjMEo5yneuh6CQnPGRbbKId27JLy6BTrSP9P01DXuwEkT8aSKvcPyMILdEanvVATw89a8OGikdFyF+gGOflZFZnBqeBacLPag74Y5rpOhqGiXCrf1qykEVPRd09Cr5D7FgcnsuKqZZLlO+O/vUFwJZ7o/s5mlXiqDaTGbp7FXAAA3hlYJO3vunzp03DKHaLQ7uJbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKGQFYZllVtUsjzobfDfxKQ/cJPEzGTq+Bz9BnAlFQE=;
 b=g4KVmp6hWgLt+qb6n+KIIol+/d1uZeHFvbEWAjBgy0MTzVwIsSMrkY+d3j5WQNPqXBxO083SahuVDYTtDBCYomqFcYmqZmfBYBlXzFO62KvKD1AFmItKGliiJiL8l+wAnpAKdyg3ZAFwvx7rOGXx3ulICX8zyNeyYimz1cgLrC//FLYUs42Ko/MOdxx9iso6v4t6oKFG55KTm4hZBf+gZnomRYIeEcPwW/Y6IU2a7gxF0ldJ89U9OrHOvIvqdEkECpxV3es7TwA3Vls2P9YfER0Xmew/TN6QQzVQ9J/2WcGoYYlnddJ7IrG3feBeLqRCQxcXzvPkK4UHFLw6ThYwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKGQFYZllVtUsjzobfDfxKQ/cJPEzGTq+Bz9BnAlFQE=;
 b=QtJ5c+3mk9YHEp03rb5t8zxiYkcJe8wB7K1GQ0WVLXAvfdqLv1MZcaa4yLaU/uAZkOTjj/KXv0TLT1B5dll93T7Zh5a2zRYz+8QC0OW6wtrXSIaWXLxOke5LLWv9Vf1N/FNry5D0BxVtF4A1JCcm4gkiqMl1CQ6HmZ8owZe7KgI=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4687.eurprd04.prod.outlook.com (2603:10a6:803:72::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Wed, 28 Oct
 2020 23:38:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Wed, 28 Oct 2020
 23:38:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, idosch@idosch.org
Subject: [PATCH v4 net-next] net: bridge: mcast: add support for raw L2 multicast groups
Date:   Thu, 29 Oct 2020 01:38:31 +0200
Message-Id: <20201028233831.610076-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1P194CA0056.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::45) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1P194CA0056.EURP194.PROD.OUTLOOK.COM (2603:10a6:803:3c::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 23:38:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1bc4da0c-b83d-4e16-38f9-08d87b9a9964
X-MS-TrafficTypeDiagnostic: VI1PR04MB4687:
X-Microsoft-Antispam-PRVS: <VI1PR04MB46874F03670A3688F3E5D475E0170@VI1PR04MB4687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WswSaFm8Cp3GjpBWJ7M02Y//IGaIflHfFOmoKLPvPpRcu2Tw0dqW+Wf5YG4DxF2RNQsfWywZAvWdGw/U8aU5fzzeLRwJJwAlA7b7607ZTST4+5rYHH4dggqlE+/hjEOpoxn+3yJ/n0jhM4eONRhUtzKphWtGz36Pn2yLxuxI3A0AetM3ZnF3iOwBO9M2eBJyFTR3uz6fZX4wfsMY2zgvn5t9HUCsDaCLuVkyvJW00Q+fUnFHPVL9VtdpgsZUzOz+2pyw9M0FrDNc5P/9Odsig+jcI8NEoBaqCaTfundtacLdsMmLPsFmqCBOi/ruZrrb4LuaPWUy5HHtkeI0x/LeJTAd3KIc3J0UTzzm5mA7t2+qUY/bTwXyaxJrlU7/DO3x4zDiVLHnahhVG1AgZ3joFaCfqYEoO2r6as/k1d4hUeE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(83380400001)(44832011)(186003)(2616005)(86362001)(316002)(1076003)(956004)(110136005)(6486002)(66556008)(52116002)(6512007)(69590400008)(36756003)(7416002)(6666004)(5660300002)(8676002)(26005)(478600001)(2906002)(66574015)(6506007)(8936002)(66946007)(4326008)(66476007)(16526019)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lnIkDf3Kc0VlPNgsagUmDglCn0r9LrUqk0G9XmGSAB2oHSTc7/gMuoqqYhPhj1bLd47wLu+++sfBimGkrp+hvvgj0skszunFjEwGlPMD7+5c568ibl9LCfw4WjOkUU1QVtRVuhtSWIRUOSFh6weEsxza1bsnuHvrF8oHaAy5lFxy4LEw2X7RfEEioUyLiwxMHBc8FvDiWcdbwbKuJqpHdlAlqCMYSdFqcqweHgqoa92sT5eM9XQDXP+auo/+/l+LffLKzkh+B0tVW2H4DaWPb9tViRpwtFksKaT0AVTkAt8/KXg/mkoNeiYHelfFTC2kFydmf+muWYLYsCG5mx35XbTtbtAWm84HMAkmX9/ARfpiBNM50nwo4JsxlwZMx2VNPlkEeBGDLYwKSe8XLCTeypQICtc+DyL6ZeKQbl8kzKrNygeQj6X9/1mCillUNkZiA/eWEp9DwAt7lXyfkewOC7gVUqh0tImX4WRyCraS+HwnyKtNLXaLS+krlWVxAuPfsRDe2dOh1Vq2CVOEddBDvKiUdqfcRNcxDpC6Wust9v23TLzanKKp0gvrOgXu7BjZubgeykVH8pvI22KtFi30XTL6G1ihasD4llLO6cmfPUTsIgkB1EvVa2j2JuqzXwl5SGGTISQWmGnJ+QNBg33vKA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc4da0c-b83d-4e16-38f9-08d87b9a9964
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 23:38:40.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcY8BRQBQ1EzdGGS/WZU0tIVKY01zi/s7mpOUwBnFxZrIuxPv+R2BPWjnLRb5pn/+tBbyeSIvnhrBSzX5FVuZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Extend the bridge multicast control and data path to configure routes
for L2 (non-IP) multicast groups.

The uapi struct br_mdb_entry union u is extended with another variant,
mac_addr, which does not change the structure size, and which is valid
when the proto field is zero.

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
Changes in v4:
- Check for MDB group being permanent before calling br_multicast_new_group,
  to avoid having empty groups that can't be deleted due to errors.

Changes in v3:
- Removed some noise in the diff.

Changes in v2:
- Removed redundant MDB_FLAGS_L2 (we are simply signalling an L2 entry
  through proto == 0)
- Moved mac_addr inside union dst of struct br_ip.
- Validation that L2 multicast address is indeed multicast

 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_device.c         |  2 +-
 net/bridge/br_input.c          |  2 +-
 net/bridge/br_mdb.c            | 24 ++++++++++++++++++++++--
 net/bridge/br_multicast.c      | 13 +++++++++----
 net/bridge/br_private.h        | 10 ++++++++--
 7 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 556caed00258..b979005ea39c 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -25,6 +25,7 @@ struct br_ip {
 #if IS_ENABLED(CONFIG_IPV6)
 		struct in6_addr ip6;
 #endif
+		unsigned char	mac_addr[ETH_ALEN];
 	} dst;
 	__be16		proto;
 	__u16           vid;
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4c687686aa8f..281777477616 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -526,6 +526,7 @@ struct br_mdb_entry {
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
index e15bab19a012..3c8863418d0b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -87,6 +87,8 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip,
 			ip->src.ip6 = nla_get_in6_addr(mdb_attrs[MDBE_ATTR_SOURCE]);
 		break;
 #endif
+	default:
+		ether_addr_copy(ip->dst.mac_addr, entry->addr.u.mac_addr);
 	}
 
 }
@@ -174,9 +176,11 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	if (mp->addr.proto == htons(ETH_P_IP))
 		e.addr.u.ip4 = mp->addr.dst.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (mp->addr.proto == htons(ETH_P_IPV6))
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
 		e.addr.u.ip6 = mp->addr.dst.ip6;
 #endif
+	else
+		ether_addr_copy(e.addr.u.mac_addr, mp->addr.dst.mac_addr);
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
 					 MDBA_MDB_ENTRY_INFO);
@@ -210,6 +214,8 @@ static int __mdb_fill_info(struct sk_buff *skb,
 		}
 		break;
 #endif
+	default:
+		ether_addr_copy(e.addr.u.mac_addr, mp->addr.dst.mac_addr);
 	}
 	if (p) {
 		if (nla_put_u8(skb, MDBA_MDB_EATTR_RTPROT, p->rt_protocol))
@@ -562,9 +568,12 @@ void br_mdb_notify(struct net_device *dev,
 		if (mp->addr.proto == htons(ETH_P_IP))
 			ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
 #if IS_ENABLED(CONFIG_IPV6)
-		else
+		else if (mp->addr.proto == htons(ETH_P_IPV6))
 			ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
 #endif
+		else
+			ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);
+
 		mdb.obj.orig_dev = pg->key.port->dev;
 		switch (type) {
 		case RTM_NEWMDB:
@@ -693,6 +702,12 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
 			return false;
 		}
 #endif
+	} else if (entry->addr.proto == 0) {
+		/* L2 mdb */
+		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
+			NL_SET_ERR_MSG_MOD(extack, "L2 entry group is not multicast");
+			return false;
+		}
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
 		return false;
@@ -849,6 +864,11 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 		}
 	}
 
+	if (br_group_is_l2(&group) && entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		return -EINVAL;
+	}
+
 	mp = br_mdb_ip_get(br, &group);
 	if (!mp) {
 		mp = br_multicast_new_group(br, &group);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index eae898c3cff7..484820c223a3 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -179,7 +179,8 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 		break;
 #endif
 	default:
-		return NULL;
+		ip.proto = 0;
+		ether_addr_copy(ip.dst.mac_addr, eth_hdr(skb)->h_dest);
 	}
 
 	return br_mdb_ip_get_rcu(br, &ip);
@@ -1203,6 +1204,10 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 		if (notify)
 			br_mdb_notify(mp->br->dev, mp, NULL, RTM_NEWMDB);
 	}
+
+	if (br_group_is_l2(&mp->addr))
+		return;
+
 	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
 }
 
@@ -1254,8 +1259,8 @@ __br_multicast_add_group(struct net_bridge *br,
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, 0, src, filter_mode,
-					RTPROT_KERNEL);
+	p = br_multicast_new_port_group(port, group, *pp, 0, src,
+					filter_mode, RTPROT_KERNEL);
 	if (unlikely(!p)) {
 		p = ERR_PTR(-ENOMEM);
 		goto out;
@@ -3690,7 +3695,7 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
 	memset(&eth, 0, sizeof(eth));
 	eth.h_proto = htons(proto);
 
-	ret = br_multicast_querier_exists(br, &eth);
+	ret = br_multicast_querier_exists(br, &eth, NULL);
 
 unlock:
 	rcu_read_unlock();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 345118e35c42..ea06e0d74815 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -840,6 +840,11 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 				       struct net_bridge_port_group *sg);
 
+static inline bool br_group_is_l2(const struct br_ip *group)
+{
+	return group->proto == 0;
+}
+
 #define mlock_dereference(X, br) \
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
 
@@ -871,7 +876,8 @@ __br_multicast_querier_exists(struct net_bridge *br,
 }
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
-					       struct ethhdr *eth)
+					       struct ethhdr *eth,
+					       const struct net_bridge_mdb_entry *mdb)
 {
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
@@ -883,7 +889,7 @@ static inline bool br_multicast_querier_exists(struct net_bridge *br,
 			&br->ip6_other_query, true);
 #endif
 	default:
-		return false;
+		return !!mdb && br_group_is_l2(&mdb->addr);
 	}
 }
 
-- 
2.25.1

