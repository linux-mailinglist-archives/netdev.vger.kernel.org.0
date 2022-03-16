Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB4E4DB445
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357039AbiCPPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357017AbiCPPKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:25 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BCC5C644
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:09 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id s29so4202458lfb.13
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=UdFJuJ8lBIX0CrkQ4VQajo5NfHcs3rs2jPv0ih+uvZ8=;
        b=sGNyDO97UdqNiFg+fU1MI/trBDdPQ5gQY6dxVRk512mxMu5g2cR/tsLFBARk6+Fv4q
         fRMah+jLPPt6pDUOB8XLnKd5ltJimewKREEPAWaSKKyOUKbDLbzUAJS8TDBXn0eoGRHB
         IXKzHI488VQlGULnP633akd6fkE5mkGBzFHUApc+quLHJtFxsC62DG2llTNZG7UJc/cT
         JiYbefpBi6ypJkIsmE6nWCyRQdUd5I3iER/2bethWH+Ano80AUblp0uZZFv1+W99lPrs
         j100SNMKB+zO/xzgtUo+NADN4IzK63XJ4AvHxRsNXs7nAJNsjCebYDqkPD26cTJEs08C
         5TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=UdFJuJ8lBIX0CrkQ4VQajo5NfHcs3rs2jPv0ih+uvZ8=;
        b=Mx8wLv/vr6vY03EsZvYQyPs9Htg5KjQT0YVNUUrc7F6JU5h7d1WVMvvAX7fd9fpi6C
         De748iyOY61ZlrTssPyGob4sRW+pNrbzy+1YiqUh7eHRK0M6WaOYJYL+ofK8Cd+hXJsu
         wZdrPkIfXr4ZRoE6JmLEBA+8OJ9ypOxVhqwaHxkpCcIENMb8iZrzswxdEfJCKHsbsdrN
         GfUQFTZxnIf4TjxDII2zGTIGOpA12xqV1HguDcuyY3VB125GNH7v781lB6Eedo9P5sRN
         18lPccFj43ZUlrZ7GvLTrM04RLvra9UqvujwKWcBd4T76Bm65Qt/XGwtTnjYY5afbuMO
         9C/w==
X-Gm-Message-State: AOAM532Rz4+Gu9Ev7qNjfWR0szihsXyy/EmiMnlJK7s2bXoGKs7VNPX9
        Y+D1dBpvDuUSy3K0RBnw/z7flQ==
X-Google-Smtp-Source: ABdhPJzMM1jm2jZr6jrZ12OpTFTL/MtM7pCuhAjVfLW7VvYMh7/8UFwSKd7ZNDPMLUyFkR7HxiTykA==
X-Received: by 2002:a19:f00f:0:b0:443:ae5c:47d0 with SMTP id p15-20020a19f00f000000b00443ae5c47d0mr93439lfc.332.1647443347654;
        Wed, 16 Mar 2022 08:09:07 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:07 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v5 net-next 01/15] net: bridge: mst: Multiple Spanning Tree (MST) mode
Date:   Wed, 16 Mar 2022 16:08:43 +0100
Message-Id: <20220316150857.2442916-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the user to switch from the current per-VLAN STP mode to an MST
mode.

Up to this point, per-VLAN STP states where always isolated from each
other. This is in contrast to the MSTP standard (802.1Q-2018, Clause
13.5), where VLANs are grouped into MST instances (MSTIs), and the
state is managed on a per-MSTI level, rather that at the per-VLAN
level.

Perhaps due to the prevalence of the standard, many switching ASICs
are built after the same model. Therefore, add a corresponding MST
mode to the bridge, which we can later add offloading support for in a
straight-forward way.

For now, all VLANs are fixed to MSTI 0, also called the Common
Spanning Tree (CST). That is, all VLANs will follow the port-global
state.

Upcoming changes will make this actually useful by allowing VLANs to
be mapped to arbitrary MSTIs and allow individual MSTI states to be
changed.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/Makefile            |  2 +-
 net/bridge/br.c                |  5 ++
 net/bridge/br_input.c          | 17 ++++++-
 net/bridge/br_mst.c            | 87 ++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h        | 37 +++++++++++++++
 net/bridge/br_stp.c            |  6 +++
 net/bridge/br_vlan.c           | 20 +++++++-
 net/bridge/br_vlan_options.c   |  5 ++
 9 files changed, 176 insertions(+), 4 deletions(-)
 create mode 100644 net/bridge/br_mst.c

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2711c3522010..30a242195ced 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -759,6 +759,7 @@ struct br_mcast_stats {
 enum br_boolopt_id {
 	BR_BOOLOPT_NO_LL_LEARN,
 	BR_BOOLOPT_MCAST_VLAN_SNOOPING,
+	BR_BOOLOPT_MST_ENABLE,
 	BR_BOOLOPT_MAX
 };
 
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 7fb9a021873b..24bd1c0a9a5a 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
 
 bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o br_multicast_eht.o
 
-bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_options.o
+bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_options.o br_mst.o
 
 bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index b1dea3febeea..96e91d69a9a8 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -265,6 +265,9 @@ int br_boolopt_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on,
 	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
 		err = br_multicast_toggle_vlan_snooping(br, on, extack);
 		break;
+	case BR_BOOLOPT_MST_ENABLE:
+		err = br_mst_set_enabled(br, on, extack);
+		break;
 	default:
 		/* shouldn't be called with unsupported options */
 		WARN_ON(1);
@@ -281,6 +284,8 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
 		return br_opt_get(br, BROPT_NO_LL_LEARN);
 	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
 		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
+	case BR_BOOLOPT_MST_ENABLE:
+		return br_opt_get(br, BROPT_MST_ENABLED);
 	default:
 		/* shouldn't be called with unsupported options */
 		WARN_ON(1);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0c13fcc50ed..196417859c4a 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -78,13 +78,22 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	u16 vid = 0;
 	u8 state;
 
-	if (!p || p->state == BR_STATE_DISABLED)
+	if (!p)
 		goto drop;
 
 	br = p->br;
+
+	if (br_mst_is_enabled(br)) {
+		state = BR_STATE_FORWARDING;
+	} else {
+		if (p->state == BR_STATE_DISABLED)
+			goto drop;
+
+		state = p->state;
+	}
+
 	brmctx = &p->br->multicast_ctx;
 	pmctx = &p->multicast_ctx;
-	state = p->state;
 	if (!br_allowed_ingress(p->br, nbp_vlan_group_rcu(p), skb, &vid,
 				&state, &vlan))
 		goto out;
@@ -370,9 +379,13 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 
 forward:
+	if (br_mst_is_enabled(p->br))
+		goto defer_stp_filtering;
+
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
 	case BR_STATE_LEARNING:
+defer_stp_filtering:
 		if (ether_addr_equal(p->br->dev->dev_addr, dest))
 			skb->pkt_type = PACKET_HOST;
 
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
new file mode 100644
index 000000000000..0f9f596f86bc
--- /dev/null
+++ b/net/bridge/br_mst.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *	Bridge Multiple Spanning Tree Support
+ *
+ *	Authors:
+ *	Tobias Waldekranz		<tobias@waldekranz.com>
+ */
+
+#include <linux/kernel.h>
+
+#include "br_private.h"
+
+DEFINE_STATIC_KEY_FALSE(br_mst_used);
+
+static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
+				  u8 state)
+{
+	struct net_bridge_vlan_group *vg = nbp_vlan_group(p);
+
+	if (v->state == state)
+		return;
+
+	br_vlan_set_state(v, state);
+
+	if (v->vid == vg->pvid)
+		br_vlan_set_pvid_state(vg, state);
+}
+
+int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
+		     struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+
+	vg = nbp_vlan_group(p);
+	if (!vg)
+		return 0;
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->brvlan->msti != msti)
+			continue;
+
+		br_mst_vlan_set_state(p, v, state);
+	}
+
+	return 0;
+}
+
+void br_mst_vlan_init_state(struct net_bridge_vlan *v)
+{
+	/* VLANs always start out in MSTI 0 (CST) */
+	v->msti = 0;
+
+	if (br_vlan_is_master(v))
+		v->state = BR_STATE_FORWARDING;
+	else
+		v->state = v->port->state;
+}
+
+int br_mst_set_enabled(struct net_bridge *br, bool on,
+		       struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p;
+
+	list_for_each_entry(p, &br->port_list, list) {
+		vg = nbp_vlan_group(p);
+
+		if (!vg->num_vlans)
+			continue;
+
+		NL_SET_ERR_MSG(extack,
+			       "MST mode can't be changed while VLANs exist");
+		return -EBUSY;
+	}
+
+	if (br_opt_get(br, BROPT_MST_ENABLED) == on)
+		return 0;
+
+	if (on)
+		static_branch_enable(&br_mst_used);
+	else
+		static_branch_disable(&br_mst_used);
+
+	br_opt_toggle(br, BROPT_MST_ENABLED, on);
+	return 0;
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 48bc61ebc211..c2190c8841fb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -178,6 +178,7 @@ enum {
  * @br_mcast_ctx: if MASTER flag set, this is the global vlan multicast context
  * @port_mcast_ctx: if MASTER flag unset, this is the per-port/vlan multicast
  *                  context
+ * @msti: if MASTER flag set, this holds the VLANs MST instance
  * @vlist: sorted list of VLAN entries
  * @rcu: used for entry destruction
  *
@@ -210,6 +211,8 @@ struct net_bridge_vlan {
 		struct net_bridge_mcast_port	port_mcast_ctx;
 	};
 
+	u16				msti;
+
 	struct list_head		vlist;
 
 	struct rcu_head			rcu;
@@ -445,6 +448,7 @@ enum net_bridge_opts {
 	BROPT_NO_LL_LEARN,
 	BROPT_VLAN_BRIDGE_BINDING,
 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
+	BROPT_MST_ENABLED,
 };
 
 struct net_bridge {
@@ -1765,6 +1769,39 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
 }
 #endif
 
+/* br_mst.c */
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+DECLARE_STATIC_KEY_FALSE(br_mst_used);
+static inline bool br_mst_is_enabled(struct net_bridge *br)
+{
+	return static_branch_unlikely(&br_mst_used) &&
+		br_opt_get(br, BROPT_MST_ENABLED);
+}
+
+int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
+		     struct netlink_ext_ack *extack);
+void br_mst_vlan_init_state(struct net_bridge_vlan *v);
+int br_mst_set_enabled(struct net_bridge *br, bool on,
+		       struct netlink_ext_ack *extack);
+#else
+static inline bool br_mst_is_enabled(struct net_bridge *br)
+{
+	return false;
+}
+
+static inline int br_mst_set_state(struct net_bridge_port *p, u16 msti,
+				   u8 state, struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mst_set_enabled(struct net_bridge *br, bool on,
+				     struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 struct nf_br_ops {
 	int (*br_dev_xmit_hook)(struct sk_buff *skb);
 };
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1d80f34a139c..7d27b2e6038f 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -43,6 +43,12 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 		return;
 
 	p->state = state;
+	if (br_opt_get(p->br, BROPT_MST_ENABLED)) {
+		err = br_mst_set_state(p, 0, state, NULL);
+		if (err)
+			br_warn(p->br, "error setting MST state on port %u(%s)\n",
+				p->port_no, netdev_name(p->dev));
+	}
 	err = switchdev_port_attr_set(p->dev, &attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		br_warn(p->br, "error setting offload STP state on port %u(%s)\n",
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 7557e90b60e1..0f5e75ccac79 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -226,6 +226,24 @@ static void nbp_vlan_rcu_free(struct rcu_head *rcu)
 	kfree(v);
 }
 
+static void br_vlan_init_state(struct net_bridge_vlan *v)
+{
+	struct net_bridge *br;
+
+	if (br_vlan_is_master(v))
+		br = v->br;
+	else
+		br = v->port->br;
+
+	if (br_opt_get(br, BROPT_MST_ENABLED)) {
+		br_mst_vlan_init_state(v);
+		return;
+	}
+
+	v->state = BR_STATE_FORWARDING;
+	v->msti = 0;
+}
+
 /* This is the shared VLAN add function which works for both ports and bridge
  * devices. There are four possible calls to this function in terms of the
  * vlan entry type:
@@ -322,7 +340,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 	}
 
 	/* set the state before publishing */
-	v->state = BR_STATE_FORWARDING;
+	br_vlan_init_state(v);
 
 	err = rhashtable_lookup_insert_fast(&vg->vlan_hash, &v->vnode,
 					    br_vlan_rht_params);
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a6382973b3e7..09112b56e79c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -99,6 +99,11 @@ static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
 		return -EBUSY;
 	}
 
+	if (br_opt_get(br, BROPT_MST_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't modify vlan state directly when MST is enabled");
+		return -EBUSY;
+	}
+
 	if (v->state == state)
 		return 0;
 
-- 
2.25.1

