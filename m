Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A06B5A27D4
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbiHZM1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343947AbiHZM1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:27:14 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F53297B0D;
        Fri, 26 Aug 2022 05:27:12 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D0FDE188F34A;
        Fri, 26 Aug 2022 12:27:09 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 349A925032D2;
        Fri, 26 Aug 2022 12:27:09 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 0103C9EC004B; Fri, 26 Aug 2022 11:45:55 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.beijerelectronics.com (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 1B7DB9EC0003;
        Fri, 26 Aug 2022 11:45:53 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag to extend locked port feature
Date:   Fri, 26 Aug 2022 13:45:33 +0200
Message-Id: <20220826114538.705433-2-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826114538.705433-1-netdev@kapio-technology.com>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an intermediate state for clients behind a locked port to allow for
possible opening of the port for said clients. The clients mac address
will be added with the locked flag set, denying access through the port
for the mac address, but also creating a new FDB add event giving
userspace daemons the ability to unlock the mac address. This feature
corresponds to the Mac-Auth and MAC Authentication Bypass (MAB) named
features. The latter defined by Cisco.

As locked FDB entries are a security measure to deny access for
unauthorized hosts on specific ports, they will deny forwarding from
any port to the (MAC, vlan) pair involved and locked entries will not
be able by learning or otherwise to change the associated port.

Only the kernel can set this FDB entry flag, while userspace can read
the flag and remove it by replacing or deleting the FDB entry.

Locked entries will age out with the set bridge ageing time.

Also add a 'blackhole' fdb flag, ensuring that no forwarding from any
port to a destination MAC that has a FDB entry with this flag on will
occur. The packets will thus be dropped.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/neighbour.h |  4 +++-
 net/bridge/br_fdb.c            | 29 +++++++++++++++++++++++++++++
 net/bridge/br_input.c          | 16 +++++++++++++++-
 net/bridge/br_netlink.c        |  9 ++++++++-
 net/bridge/br_private.h        |  4 +++-
 7 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index d62ef428e3aa..1668ac4d7adc 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -59,6 +59,7 @@ struct br_ip_list {
 #define BR_MRP_LOST_IN_CONT	BIT(19)
 #define BR_TX_FWD_OFFLOAD	BIT(20)
 #define BR_PORT_LOCKED		BIT(21)
+#define BR_PORT_MAB		BIT(22)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..fcbd0b85ad53 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -560,6 +560,7 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
+	IFLA_BRPORT_MAB,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index a998bf761635..bc1440a56b70 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -52,7 +52,9 @@ enum {
 #define NTF_STICKY	(1 << 6)
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
-#define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_MANAGED		(1 << 0)
+#define NTF_EXT_LOCKED		(1 << 1)
+#define NTF_EXT_BLACKHOLE	(1 << 2)
 
 /*
  *	Neighbor Cache Entry States.
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..1962d9594a48 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
+	u32 ext_flags = 0;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -125,11 +126,18 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
+		ext_flags |= NTF_EXT_LOCKED;
+	if (test_bit(BR_FDB_BLACKHOLE, &fdb->flags))
+		ext_flags |= NTF_EXT_BLACKHOLE;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, NDA_FLAGS_EXT, ext_flags))
+		goto nla_put_failure;
+
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
 	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
@@ -171,6 +179,7 @@ static inline size_t fdb_nlmsg_size(void)
 	return NLMSG_ALIGN(sizeof(struct ndmsg))
 		+ nla_total_size(ETH_ALEN) /* NDA_LLADDR */
 		+ nla_total_size(sizeof(u32)) /* NDA_MASTER */
+		+ nla_total_size(sizeof(u32)) /* NDA_FLAGS_EXT */
 		+ nla_total_size(sizeof(u16)) /* NDA_VLAN */
 		+ nla_total_size(sizeof(struct nda_cacheinfo))
 		+ nla_total_size(0) /* NDA_FDB_EXT_ATTRS */
@@ -879,6 +888,10 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 						      &fdb->flags)))
 					clear_bit(BR_FDB_ADDED_BY_EXT_LEARN,
 						  &fdb->flags);
+				if (source->flags & BR_PORT_MAB)
+					set_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
+				else
+					clear_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
 			}
 
 			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
@@ -1082,6 +1095,16 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags)) {
+		clear_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
+		modified = true;
+	}
+
+	if (test_bit(BR_FDB_BLACKHOLE, &fdb->flags)) {
+		clear_bit(BR_FDB_BLACKHOLE, &fdb->flags);
+		modified = true;
+	}
+
 	if (fdb_handle_notify(fdb, notify))
 		modified = true;
 
@@ -1178,6 +1201,12 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		vg = nbp_vlan_group(p);
 	}
 
+	if (tb[NDA_FLAGS_EXT] &&
+	    (nla_get_u32(tb[NDA_FLAGS_EXT]) & (NTF_EXT_LOCKED | NTF_EXT_BLACKHOLE))) {
+		pr_info("bridge: RTM_NEWNEIGH has invalid extended flags\n");
+		return -EINVAL;
+	}
+
 	if (tb[NDA_FDB_EXT_ATTRS]) {
 		attr = tb[NDA_FDB_EXT_ATTRS];
 		err = nla_parse_nested(nfea_tb, NFEA_MAX, attr,
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 68b3e850bcb9..3d48aa7fa778 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -110,8 +110,19 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
 		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
+		    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
+			if (!fdb_src || (READ_ONCE(fdb_src->dst) != p &&
+					 (p->flags & BR_LEARNING))) {
+				unsigned long flags = 0;
+
+				if (p->flags & BR_PORT_MAB) {
+					__set_bit(BR_FDB_ENTRY_LOCKED, &flags);
+					br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
+				}
+			}
 			goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
@@ -185,6 +196,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		if (test_bit(BR_FDB_LOCAL, &dst->flags))
 			return br_pass_frame_up(skb);
 
+		if (test_bit(BR_FDB_BLACKHOLE, &dst->flags))
+			goto drop;
+
 		if (now != dst->used)
 			dst->used = now;
 		br_forward(dst->dst, skb, local_rcv, false);
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5aeb3646e74c..34483420c9e4 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -188,6 +188,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(1)	/* IFLA_BRPORT_NEIGH_SUPPRESS */
 		+ nla_total_size(1)	/* IFLA_BRPORT_ISOLATED */
 		+ nla_total_size(1)	/* IFLA_BRPORT_LOCKED */
+		+ nla_total_size(1)	/* IFLA_BRPORT_MAB */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_ROOT_ID */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_BRIDGE_ID */
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_DESIGNATED_PORT */
@@ -274,7 +275,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
 		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)) ||
-	    nla_put_u8(skb, IFLA_BRPORT_LOCKED, !!(p->flags & BR_PORT_LOCKED)))
+	    nla_put_u8(skb, IFLA_BRPORT_LOCKED, !!(p->flags & BR_PORT_LOCKED)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_MAB, !!(p->flags & BR_PORT_MAB)))
 		return -EMSGSIZE;
 
 	timerval = br_timer_value(&p->message_age_timer);
@@ -876,6 +878,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_NEIGH_SUPPRESS] = { .type = NLA_U8 },
 	[IFLA_BRPORT_ISOLATED]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_LOCKED] = { .type = NLA_U8 },
+	[IFLA_BRPORT_MAB] = { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
 };
@@ -943,6 +946,10 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
+	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
+
+	if (!(p->flags & BR_PORT_LOCKED))
+		p->flags &= ~BR_PORT_MAB;
 
 	changed_mask = old_flags ^ p->flags;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..048e4afbc5a0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -251,7 +251,9 @@ enum {
 	BR_FDB_ADDED_BY_EXT_LEARN,
 	BR_FDB_OFFLOADED,
 	BR_FDB_NOTIFY,
-	BR_FDB_NOTIFY_INACTIVE
+	BR_FDB_NOTIFY_INACTIVE,
+	BR_FDB_ENTRY_LOCKED,
+	BR_FDB_BLACKHOLE,
 };
 
 struct net_bridge_fdb_key {
-- 
2.30.2

