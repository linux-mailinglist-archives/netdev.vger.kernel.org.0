Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C004D148418
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404858AbgAXLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:40:40 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45553 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392069AbgAXLkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:40:39 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so885068lfa.12
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 03:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sXZbiWZwK/PW+HaqInfWmH16W0zqj9PYmL2goM/GWEc=;
        b=Q0UyyTTsSSCWgjgMHkCScVy1GX45ju/hyuyFl0ilm+l4SRNp9DY4iLiKjIll22tNL8
         GbS0iZz4jg+w6Mcw90BSi+bfrDFm2waebbgqVWmzTiqWj2igGfPJna3hywXoC4CckHVU
         LGAyZf779Z79VLhddmF7kF6XO/agRrmtJzNDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sXZbiWZwK/PW+HaqInfWmH16W0zqj9PYmL2goM/GWEc=;
        b=daB9TAz4z9R5vvZrkZLIEtUjS0FIYAZ2vbnp/FhvbaREMMxr9ZXDBPc8Cg22hMSWKd
         Ujd2QK8prnC+DRAUBTR66/ODjooGBD3G5rOtGeyU5irahv/gc26Kt1AzvxJv5mEaGb8f
         FM7yvPN8ZAdivvhQGWMAKXaS78gG4zZbWv9qyVMrP3KA+la3F+ukqb9v/8wP2L9g/pXC
         DsViFQ98Efml81ho0aQa4hcHZTsDH10cVr930YcQrHHRoglDlntf7mczu/H/9H3Z5HMI
         nHYxO1IettmKTdAX4PtFlk1ZTQK3lS7PoFNR/wELY6UCSlxUIK4DhVR+WIh+YuWxdN1t
         50yA==
X-Gm-Message-State: APjAAAXUSKSKbtCZZIfomCiSQZs10ptnByhqPYlmVcD8s+y5tPCFnZKB
        oIxzhRphKWwyW3SL+tUOskxKupJ3zpE=
X-Google-Smtp-Source: APXvYqyOIYHic5n35SdLKBiYIi+TfzLhu0x91FXscKgP6cEv9xEcgNcxY1b1naCDKG3hS4FbHhd3wA==
X-Received: by 2002:ac2:4909:: with SMTP id n9mr1174495lfi.21.1579866035104;
        Fri, 24 Jan 2020 03:40:35 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s22sm2996185ljm.41.2020.01.24.03.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 03:40:34 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 4/4] net: bridge: vlan: add per-vlan state
Date:   Fri, 24 Jan 2020 13:40:22 +0200
Message-Id: <20200124114022.10883-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
References: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first per-vlan option added is state, it is needed for EVPN and for
per-vlan STP. The state allows to control the forwarding on per-vlan
basis. The vlan state is considered only if the port state is forwarding
in order to avoid conflicts and be consistent. br_allowed_egress is
called only when the state is forwarding, but the ingress case is a bit
more complicated due to the fact that we may have the transition between
port:BR_STATE_FORWARDING -> vlan:BR_STATE_LEARNING which should still
allow the bridge to learn from the packet after vlan filtering and it will
be dropped after that. Also to optimize the pvid state check we keep a
copy in the vlan group to avoid one lookup. The state members are
modified with *_ONCE() to annotate the lockless access.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_device.c         |  3 +-
 net/bridge/br_input.c          |  7 +++--
 net/bridge/br_private.h        | 43 ++++++++++++++++++++++++++--
 net/bridge/br_vlan.c           | 47 ++++++++++++++++++++++--------
 net/bridge/br_vlan_options.c   | 52 ++++++++++++++++++++++++++++++++--
 6 files changed, 134 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 06bbfefa2141..e07d082d8a79 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -191,6 +191,7 @@ enum {
 	BRIDGE_VLANDB_ENTRY_UNSPEC,
 	BRIDGE_VLANDB_ENTRY_INFO,
 	BRIDGE_VLANDB_ENTRY_RANGE,
+	BRIDGE_VLANDB_ENTRY_STATE,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index fb38add21b37..dc3d2c1dd9d5 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -32,6 +32,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct net_bridge_mdb_entry *mdst;
 	struct pcpu_sw_netstats *brstats = this_cpu_ptr(br->stats);
 	const struct nf_br_ops *nf_ops;
+	u8 state = BR_STATE_FORWARDING;
 	const unsigned char *dest;
 	struct ethhdr *eth;
 	u16 vid = 0;
@@ -56,7 +57,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	eth = eth_hdr(skb);
 	skb_pull(skb, ETH_HLEN);
 
-	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid))
+	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid, &state))
 		goto out;
 
 	if (IS_ENABLED(CONFIG_INET) &&
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8944ceb47fe9..fcc260840028 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -76,11 +76,14 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	bool local_rcv, mcast_hit = false;
 	struct net_bridge *br;
 	u16 vid = 0;
+	u8 state;
 
 	if (!p || p->state == BR_STATE_DISABLED)
 		goto drop;
 
-	if (!br_allowed_ingress(p->br, nbp_vlan_group_rcu(p), skb, &vid))
+	state = p->state;
+	if (!br_allowed_ingress(p->br, nbp_vlan_group_rcu(p), skb, &vid,
+				&state))
 		goto out;
 
 	nbp_switchdev_frame_mark(p, skb);
@@ -103,7 +106,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		}
 	}
 
-	if (p->state == BR_STATE_LEARNING)
+	if (state == BR_STATE_LEARNING)
 		goto drop;
 
 	BR_INPUT_SKB_CB(skb)->brdev = br->dev;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 084904ee22a8..5153ffe79a01 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -113,6 +113,7 @@ enum {
  * @vid: VLAN id
  * @flags: bridge vlan flags
  * @priv_flags: private (in-kernel) bridge vlan flags
+ * @state: STP state (e.g. blocking, learning, forwarding)
  * @stats: per-cpu VLAN statistics
  * @br: if MASTER flag set, this points to a bridge struct
  * @port: if MASTER flag unset, this points to a port struct
@@ -133,6 +134,7 @@ struct net_bridge_vlan {
 	u16				vid;
 	u16				flags;
 	u16				priv_flags;
+	u8				state;
 	struct br_vlan_stats __percpu	*stats;
 	union {
 		struct net_bridge	*br;
@@ -157,6 +159,7 @@ struct net_bridge_vlan {
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
+ * @pvid_state: PVID's STP state (e.g. forwarding, learning, blocking)
  *
  * IMPORTANT: Be careful when checking if there're VLAN entries using list
  *            primitives because the bridge can have entries in its list which
@@ -170,6 +173,7 @@ struct net_bridge_vlan_group {
 	struct list_head		vlan_list;
 	u16				num_vlans;
 	u16				pvid;
+	u8				pvid_state;
 };
 
 /* bridge fdb flags */
@@ -935,7 +939,7 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 bool br_allowed_ingress(const struct net_bridge *br,
 			struct net_bridge_vlan_group *vg, struct sk_buff *skb,
-			u16 *vid);
+			u16 *vid, u8 *state);
 bool br_allowed_egress(struct net_bridge_vlan_group *vg,
 		       const struct sk_buff *skb);
 bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid);
@@ -1037,7 +1041,7 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
 static inline bool br_allowed_ingress(const struct net_bridge *br,
 				      struct net_bridge_vlan_group *vg,
 				      struct sk_buff *skb,
-				      u16 *vid)
+				      u16 *vid, u8 *state)
 {
 	return true;
 }
@@ -1205,6 +1209,41 @@ int br_vlan_process_options(const struct net_bridge *br,
 			    struct net_bridge_vlan *range_end,
 			    struct nlattr **tb,
 			    struct netlink_ext_ack *extack);
+
+/* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
+static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
+{
+	return READ_ONCE(v->state);
+}
+
+static inline void br_vlan_set_state(struct net_bridge_vlan *v, u8 state)
+{
+	WRITE_ONCE(v->state, state);
+}
+
+static inline u8 br_vlan_get_pvid_state(const struct net_bridge_vlan_group *vg)
+{
+	return READ_ONCE(vg->pvid_state);
+}
+
+static inline void br_vlan_set_pvid_state(struct net_bridge_vlan_group *vg,
+					  u8 state)
+{
+	WRITE_ONCE(vg->pvid_state, state);
+}
+
+/* learn_allow is true at ingress and false at egress */
+static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
+{
+	switch (state) {
+	case BR_STATE_LEARNING:
+		return learn_allow;
+	case BR_STATE_FORWARDING:
+		return true;
+	default:
+		return false;
+	}
+}
 #endif
 
 struct nf_br_ops {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index d747756eac63..6b5deca08b89 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -34,13 +34,15 @@ static struct net_bridge_vlan *br_vlan_lookup(struct rhashtable *tbl, u16 vid)
 	return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
 }
 
-static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg, u16 vid)
+static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
+			    const struct net_bridge_vlan *v)
 {
-	if (vg->pvid == vid)
+	if (vg->pvid == v->vid)
 		return false;
 
 	smp_wmb();
-	vg->pvid = vid;
+	br_vlan_set_pvid_state(vg, v->state);
+	vg->pvid = v->vid;
 
 	return true;
 }
@@ -69,7 +71,7 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
 		vg = nbp_vlan_group(v->port);
 
 	if (flags & BRIDGE_VLAN_INFO_PVID)
-		ret = __vlan_add_pvid(vg, v->vid);
+		ret = __vlan_add_pvid(vg, v);
 	else
 		ret = __vlan_delete_pvid(vg, v->vid);
 
@@ -293,6 +295,9 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 		vg->num_vlans++;
 	}
 
+	/* set the state before publishing */
+	v->state = BR_STATE_FORWARDING;
+
 	err = rhashtable_lookup_insert_fast(&vg->vlan_hash, &v->vnode,
 					    br_vlan_rht_params);
 	if (err)
@@ -466,7 +471,8 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 /* Called under RCU */
 static bool __allowed_ingress(const struct net_bridge *br,
 			      struct net_bridge_vlan_group *vg,
-			      struct sk_buff *skb, u16 *vid)
+			      struct sk_buff *skb, u16 *vid,
+			      u8 *state)
 {
 	struct br_vlan_stats *stats;
 	struct net_bridge_vlan *v;
@@ -532,13 +538,25 @@ static bool __allowed_ingress(const struct net_bridge *br,
 			skb->vlan_tci |= pvid;
 
 		/* if stats are disabled we can avoid the lookup */
-		if (!br_opt_get(br, BROPT_VLAN_STATS_ENABLED))
-			return true;
+		if (!br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
+			if (*state == BR_STATE_FORWARDING) {
+				*state = br_vlan_get_pvid_state(vg);
+				return br_vlan_state_allowed(*state, true);
+			} else {
+				return true;
+			}
+		}
 	}
 	v = br_vlan_find(vg, *vid);
 	if (!v || !br_vlan_should_use(v))
 		goto drop;
 
+	if (*state == BR_STATE_FORWARDING) {
+		*state = br_vlan_get_state(v);
+		if (!br_vlan_state_allowed(*state, true))
+			goto drop;
+	}
+
 	if (br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 		stats = this_cpu_ptr(v->stats);
 		u64_stats_update_begin(&stats->syncp);
@@ -556,7 +574,7 @@ static bool __allowed_ingress(const struct net_bridge *br,
 
 bool br_allowed_ingress(const struct net_bridge *br,
 			struct net_bridge_vlan_group *vg, struct sk_buff *skb,
-			u16 *vid)
+			u16 *vid, u8 *state)
 {
 	/* If VLAN filtering is disabled on the bridge, all packets are
 	 * permitted.
@@ -566,7 +584,7 @@ bool br_allowed_ingress(const struct net_bridge *br,
 		return true;
 	}
 
-	return __allowed_ingress(br, vg, skb, vid);
+	return __allowed_ingress(br, vg, skb, vid, state);
 }
 
 /* Called under RCU. */
@@ -582,7 +600,8 @@ bool br_allowed_egress(struct net_bridge_vlan_group *vg,
 
 	br_vlan_get_tag(skb, &vid);
 	v = br_vlan_find(vg, vid);
-	if (v && br_vlan_should_use(v))
+	if (v && br_vlan_should_use(v) &&
+	    br_vlan_state_allowed(br_vlan_get_state(v), false))
 		return true;
 
 	return false;
@@ -593,6 +612,7 @@ bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge *br = p->br;
+	struct net_bridge_vlan *v;
 
 	/* If filtering was disabled at input, let it pass. */
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
@@ -607,13 +627,15 @@ bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid)
 
 	if (!*vid) {
 		*vid = br_get_pvid(vg);
-		if (!*vid)
+		if (!*vid ||
+		    !br_vlan_state_allowed(br_vlan_get_pvid_state(vg), true))
 			return false;
 
 		return true;
 	}
 
-	if (br_vlan_find(vg, *vid))
+	v = br_vlan_find(vg, *vid);
+	if (v && br_vlan_state_allowed(br_vlan_get_state(v), true))
 		return true;
 
 	return false;
@@ -1816,6 +1838,7 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 	[BRIDGE_VLANDB_ENTRY_INFO]	= { .type = NLA_EXACT_LEN,
 					    .len = sizeof(struct bridge_vlan_info) },
 	[BRIDGE_VLANDB_ENTRY_RANGE]	= { .type = NLA_U16 },
+	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 27275ac3e42e..cd2eb194eb98 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -11,16 +11,54 @@
 bool br_vlan_opts_eq(const struct net_bridge_vlan *v1,
 		     const struct net_bridge_vlan *v2)
 {
-	return true;
+	return v1->state == v2->state;
 }
 
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
 {
-	return true;
+	return !nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE,
+			   br_vlan_get_state(v));
 }
 
 size_t br_vlan_opts_nl_size(void)
 {
+	return nla_total_size(sizeof(u8)); /* BRIDGE_VLANDB_ENTRY_STATE */
+}
+
+static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
+				struct net_bridge_vlan *v,
+				u8 state,
+				bool *changed,
+				struct netlink_ext_ack *extack)
+{
+	struct net_bridge *br;
+
+	ASSERT_RTNL();
+
+	if (state > BR_STATE_BLOCKING) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid vlan state");
+		return -EINVAL;
+	}
+
+	if (br_vlan_is_brentry(v))
+		br = v->br;
+	else
+		br = v->port->br;
+
+	if (br->stp_enabled == BR_KERNEL_STP) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't modify vlan state when using kernel STP");
+		return -EBUSY;
+	}
+
+	if (v->state == state)
+		return 0;
+
+	if (v->vid == br_get_pvid(vg))
+		br_vlan_set_pvid_state(vg, state);
+
+	br_vlan_set_state(v, state);
+	*changed = true;
+
 	return 0;
 }
 
@@ -32,7 +70,17 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 				    bool *changed,
 				    struct netlink_ext_ack *extack)
 {
+	int err;
+
 	*changed = false;
+	if (tb[BRIDGE_VLANDB_ENTRY_STATE]) {
+		u8 state = nla_get_u8(tb[BRIDGE_VLANDB_ENTRY_STATE]);
+
+		err = br_vlan_modify_state(vg, v, state, changed, extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.21.0

