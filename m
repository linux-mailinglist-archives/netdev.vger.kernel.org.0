Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1A52982BC
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 18:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417607AbgJYRVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 13:21:37 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:33377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1417594AbgJYRVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 13:21:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1fZC3qAk2js7p9jrvbQvGoAhdoiK9dX1P/z7FYGPxhb5GKZtAxLHAlzTlJVYI+IeJrAfmmndXSYzVPx9L33UuK/5efYWownXaakvg8XGjZhN6Q/ocXhAI/ExgQdyFNhalhUWh1Kh7Mn0brnetcLridu1o8qv6Gf4GvQwnJvk5oVpXhVdkLaGk+TPEP37U8TJYr5J7xnunQn5wJEjJh3YOhotaGawSYh7NI+QafrHhuj3mEfM73qa5fqbZSar/O9vofN1dFz0I1tZZTA5ZdgHLrwGZVRs6bGxpixCPdmV8wzSCQZjquCzO+rgSIiicEjthGO0qrsX5AurUa1AhvVpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+fC4edRLLRbIiNwYjowNEAn+8A0dpMTRAxaGo9UI+A=;
 b=XiDKrxsyRE2cnastvlsFB8DT377TGZ4hbSKGJZqKh792zmty2LOxWA1Ck7bpvPikiHUh7zy5kn0KC6fMKmVZIkUWkDuK33K8NpZdkcdvt3OjUHnBDZ4mxn/lmLL6ZCkAQ31IL/7SUl3EgYX+1vysbqiGhX3wuu4wHqcF/N1ht3eSoe11ojgo/u+ZnAq8tAoRV0kQGyecJOXbxc5GJuY16ILwxTHXIuF5qFNH0k9fZdPg8pXgoNTutKKz8BoyJrSaHSPIEdu6Jlz/dOYZAhaCT6e3PKcjfBuMekB+rarLJai4rL3L3VqEwtqytPoQOtY9P923CJZxfeWp3GdxE6IWKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+fC4edRLLRbIiNwYjowNEAn+8A0dpMTRAxaGo9UI+A=;
 b=dJearkqrv1aSg9qf7KOOjUN3tMmp8vqnyDo5Fcwgh/TWoGW84FeATxXnjF414XMSuwIueTWhTiTa7+NxZK3v4i5fzeuVjXtGjxZGwXEpjWomswHDt5KnqBjmcUhRheWpuPOmRiG1fZH6akA1Dseh2OrlQo+/rWAIOBc4uzJeK/U=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Sun, 25 Oct
 2020 17:21:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.018; Sun, 25 Oct 2020
 17:21:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, idosch@idosch.org
Subject: [RFC PATCH v2] net: bridge: mcast: add support for raw L2 multicast groups
Date:   Sun, 25 Oct 2020 19:20:54 +0200
Message-Id: <20201025172054.1158018-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1P189CA0033.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::46) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1P189CA0033.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 25 Oct 2020 17:21:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 672e6bee-8d26-460e-8b9d-08d8790a6900
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863EF273854F55B9A858718E0180@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kr8Q7CLO53Ua+R/Yd/q3DGPLD6F5C/WE9d73Ko1T9Zf9OZKTV9/dgT1jZdb+dt3E6VAqOhK6zaEfTsCudQas27d+F1nI4/x7m6IF37jG/wWAG59wziaMMpEIzt9Ltrea0CiNncahOIpmNS2Fvf+Q7Cw1/Qz4zHOLQt1CRY26z92eFiCeJ0/gE5QHLNbXjwrL4H4UN10xU3q/iwSY4EZ5mPjRAPlY2cV9/68nVwgBmYDYOLeSOpgYlCPmz8A6wwd0v8Q99LW3SxXvgGe5aKJrZr1dAgCgbo24nHFOK9gE/nOy4nk1OSOPkirXRD2K8/fsJJ4Cprm1C2LntiGHlkez7/EGECKcPLlfkFzBaCFfJ1clupwOktxlmOoedwFRC3nvAEysv1Rom+GbwkHfmtSCgZ6rHHXH6T6ENUE2c4bvIN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(376002)(396003)(366004)(1076003)(8676002)(316002)(26005)(66574015)(52116002)(66556008)(956004)(8936002)(66476007)(6486002)(16526019)(186003)(2616005)(66946007)(4326008)(6506007)(7416002)(5660300002)(44832011)(36756003)(478600001)(6666004)(2906002)(6512007)(83380400001)(86362001)(69590400008)(110136005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nJJClQxTmqvgTJ5jIaRc2BJ1it/7X3NsrFYJwDi9rkBteT5QQbfR/QCS/x84CKBQGwKn6EjzHQB7eJO4JNFYVfVYsrvzk06CIiei9HXavqb4G5LKQXuJns1PnWZKdrXUVgXSBLR6UdorvgPqg9IRs06f7otGTyZESaFViV16mh4pn4m0FGLVVgzDdhuJEWOxz6WhyVNRf35zrJzxQnd/3pct5An5HmRZ7CJ0fGPYlRrE+3TbHEJX/vphPsRM9WKBG6ZWcJmMapc9DMEL18e5JNEEpt/EBZP1B8u1Th8KKBQhaPn9vG8+i+78Edrj6NEahr9ZTngQQ5NfDSAqkgg6MO9rJ238UT8JXF2FHIhTYas0dPG9WPDpnf1I65GTdMMCzhFKsOR2aXINcXF8+TmAR8iJsHn2n8on+bMuQxKvfYcXodKm2rxjqu4JvK87S3lMzOet6hsKZI6rzIy5OFaXVkxWAxmkaO+NrbnguImkt6kcsF7XcvQCjILR67FqpF5ZcfI1fvNa3fUCC4IIc4I71w8guiSz6+F44izOiAcONaY2MevNURFPdYwPqIjHaYqlBODVVHD1T98VTa80vt9xapjK9bbUjzPXj7weGb2fwmutlHpYEfbssvYSukdaHInGrVD3gSNiUXLYbaE5Yq2kxQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 672e6bee-8d26-460e-8b9d-08d8790a6900
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2020 17:21:29.4430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4U+JbfKPeK4LViwPafLbcopf5zRZAjcIxvVhTnm5jVADJASiApHeu53u3JTEHGBvbfyBLXSP1Kp9onvxlO8b8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
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
index e15bab19a012..f4fe0d96769d 100644
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
@@ -857,6 +872,11 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			return err;
 	}
 
+	if (entry->state != MDB_PERMANENT && br_group_is_l2(&mp->addr)) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		return -EINVAL;
+	}
+
 	/* host join */
 	if (!port) {
 		if (mp->host_joined) {
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

