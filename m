Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104CF29D826
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgJ1W37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:29:59 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:17540
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733219AbgJ1W36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:29:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuacI10grVfPzLWd7COS0DWeJ53Lkr4jD+MBzMYc6bg85TeK9lEUATAsUROxBQlvuWuEOkwTqf7wP9IfLzs3lnfGMO/jRRZGP8kMXsiqvrvacHDBtOxL5Z+bx1d/opTmnwhLwkV0Tx++5rFcPSnm4BDYnjAp5vSld/xLtXVG8IBwDbEgpwPbxNMFPZJPAxrofJcgoGv9V+72GXYGC/wEujSZRH35jSZU86MbSnE0b2jsz3Z2WLdN8MBPlu2dDqPguGq5E+6qS22QIsKfmxDI2DjCvDHMYJBFU6zz8e+RRf4beMNXHE/mb0xls/VAHkv/LTbEM8ZP/8hZtESw2m3oEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRi8k4m0A0qOj3eJWE1FHQ1hJgeYRPaXC6NVGmuucgw=;
 b=luc8PN1aPA3nnSCs16vNo0HT3dsUH+lXxWWkF1V3B3HX88BRHdFCO7cZv4pqan4B29o/zpVVOx7+YWw35NDVDnlxJFV0NjjuZQtDP32dpbizqf1PtYna0v/UstLRRWW8Jj0frlMlMliMHEFiDuecBsvhMcqsT1/adxFddRiA6gAn9nh+Or2zOdtfq0/OMKqpTyy5dQtwV6Pifrf0d3jYz71ZG3+7yKv3hU3qq91cgTKRjNLvsN7lBoUQVIk2asM1XtAzPOyD3nVeasC3yIKKBJ286wbPOSkW99ES9sRhB0VKXPVMY2xa80T/N7RdVf+8LDGLYSxVDRHLS3TQ1L+WMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRi8k4m0A0qOj3eJWE1FHQ1hJgeYRPaXC6NVGmuucgw=;
 b=JvlZQvE34P23XBckPoY2YiCHnb5Ao76bQP819q8rG52WO9RWSAyMTlviLvkIr90EdtZ6MIneO4qY41X+Muw6cHlEui2OrvYHqG85PVDgLPxD/PK+05HiaX//ZyICc/86Gt4FEuZEqd79Kuv96eNmtXyiN1DkylMBQ5y7RYAzD0A=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 10:54:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.019; Wed, 28 Oct 2020
 10:54:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@mellanox.com, idosch@idosch.org
Subject: [PATCH v3 net-next] net: bridge: mcast: add support for raw L2 multicast groups
Date:   Wed, 28 Oct 2020 12:54:12 +0200
Message-Id: <20201028105412.371741-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0106.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::32) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0106.eurprd08.prod.outlook.com (2603:10a6:800:d3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22 via Frontend Transport; Wed, 28 Oct 2020 10:54:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f1d5bbe-3510-44b7-4d3e-08d87b2fd429
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:
X-Microsoft-Antispam-PRVS: <VE1PR04MB72168BE0274BB263FF78DBB0E0170@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLKr1grWTAZkCbCrYvt55bql7pq2qB2dRYxtCds7/xIgQsGKDCHzGjkzdPiJJuXbF65exgL6qKJaxnqjiSpthE3UKGAL4XwfGqop3r+UUu9ZSEwdzr6FyTsOqxnTHKCApSAE2M1t1dHi8vhrzcMFerpb8+fn5yPNRWq+NoraFqNt0urzPm4KWbO+UFEOZemxsBlFK0q0p6Sq+8TFl0zubMBKzIw+ZSQyNNfg02iVYnYrBCKimN0gX/dMU2m46RHbn59H8IVjuSNI90xl9b29jCdMHyEzzK0hDPAz8nkulqN0NoQy/UK4jg+4oohjOcgAlppWGvG86NIIu77UaKPVzXhQhrZvwmq6dbXHGmoka88TD9/G3G4m1L1kSP7BmOGNcmeMGpEu7+v3TFUlamXSW08SvaiaIm6jG+VADwwNDw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(66946007)(66476007)(66556008)(36756003)(6486002)(6512007)(1076003)(5660300002)(316002)(110136005)(44832011)(2616005)(956004)(16526019)(478600001)(6506007)(26005)(186003)(8676002)(69590400008)(6666004)(66574015)(4326008)(83380400001)(52116002)(8936002)(86362001)(2906002)(7416002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FZLxE8IQfOhlCswdZrIBEZpy6N383JzsEvPWeD/JiR6qKmMroxVI/z6RvaSCEiH1SZnfCAnKK4n6xvWtyhSVn6+njesmbxctiRBJiWumeeo59fpoYv+IDJfUvFCsRr9ht0XmdXHa657lWvhhP53x63pQc8axsGgF17tlnpqOQqAUuIKFJddP6Ba8aEcBrbxVmaYwermCxT0nqBmiJJO+XvZL8zEZSiIkgNKilKJRkYll1D2zx2MHRWJMf8n3f4q0zS4j7zoNXY38hAH1dzVnJhM17zJ2gcXp399qbWZws5pnXqxTFh1JKyyhK0Z/RMl0V/OiZeQRXqQf1GBa+XaqOmTzNIYyYvMEpQH+VomJZ6tMxTrVpK/el8OEBU8wsmi23nsQJn1IRlYgFgo/MZvfsOZ/frXalUeqATXNEFYYF7DICD6kbSfrGjhslOyoqPrLmR1sc1IC1JuviZmsbmMLApXGiJa6kWS9wypjLQ+AvOsPbF/xLzcUmjj0VbaIN5yS9tEe3bTIbUj+WiuQD8MRaLDkoLo5derpCKd9ez2+M9xkSQ33hXX8RDXqkm9L7052HQB29RdcPfJiNZipdeKszx1gEHNR8rayLzVDBZQ7YohmLp+t84orqT2It05HZbkzTfaTWiEA52aiplzLAPzS1A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1d5bbe-3510-44b7-4d3e-08d87b2fd429
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 10:54:22.7530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiY2YmlDh3B4hMKuhNGjh2eLOCk4z81HURdHQXX0CAVFzcnni6z724fw8GE2JNGroG6g7vHHDDH6EWAlfvgaCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
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
 net/bridge/br_multicast.c      |  9 +++++++--
 net/bridge/br_private.h        | 10 ++++++++--
 7 files changed, 41 insertions(+), 8 deletions(-)

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
index eae898c3cff7..98de0acb0307 100644
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

