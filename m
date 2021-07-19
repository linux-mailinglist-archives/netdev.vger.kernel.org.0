Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02193CE845
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355749AbhGSQju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355659AbhGSQgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:33 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36161C04F978
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id nd37so29931962ejc.3
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=78cdZKUIevFFmT6hNFCn9jC96St+3byWaSdnZ2rlJ0Q=;
        b=Wwtgf5YrZngX+cYE/39tApzMnkm/fmn+PUUrwuFphgi2Dwm0ceTmDHzi2bh3bv6GNF
         zYi14GE3rY0aW8+j+Q+jBP69putzhjfospK409JZaI3Uopwk53mTQnE4wmiwDCEN+CtM
         gL151tFATrTvP3JQzU6CsxJWTDyuoon5MX/QkHwIqIt5W8dVYpHBXkdJkKHw7b4vBlJn
         ridfKlou+Gcil5MR37R1PqrkQHSb7fdlS8mtzc+nnuG9RBaMnJV/iTQT/7nykPZg+M3A
         59Z+iB99pO1Q/9wIeCoT5vmWOIBuSbPcP8H2/97CRf4ga1b6TAeHSZqRzrBlbmgnADLt
         QNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=78cdZKUIevFFmT6hNFCn9jC96St+3byWaSdnZ2rlJ0Q=;
        b=N4tnfnugmvZKjok4/0LaDftCSCKTlmGii6kVNnLk7696K5uTUVMN1B8m1G/eBUSHaE
         DHmYuL7izSRJje5S2a1DglXL0hYkJ5W4dT5sO08fD7y3FzTgvRUhxfNxWmE2OX8McCJw
         U0XFh0MBTxWj/NCHhsPAXJaujA5zGhkkh8dbK2gOToMKXHuL+ItWzG6KZakVHZRpYpsy
         mI6pne7YpOeEf34uy7QNxvsDR3QjDKEJh++7yfhH8cWi7kuJa2IZALBZOvuQdgScdfuN
         GI6foaj97OpyNf7mSymRRfPmnIurmiRLnNA2gAnxgTsOAYIRzSeWgBMAzAez6QZnR+Af
         pZ/w==
X-Gm-Message-State: AOAM5320DWA0JlKEiQjk0PvbJoCCA/3iITNi9lou1SY0pJRovYDtXc8T
        GU3kzn09Mav0DWj4foaKvSzT2nxwgoHSgNEZWT0=
X-Google-Smtp-Source: ABdhPJyoz6qaD0KPLLh8/keYaihuJoGaXPntpMN+BQbQ7esXGtkliPM0CBRKs4g1VDNL2WjWRM7fQQ==
X-Received: by 2002:a17:906:6050:: with SMTP id p16mr18811152ejj.43.1626714602410;
        Mon, 19 Jul 2021 10:10:02 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:01 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 06/15] net: bridge: add vlan mcast snooping knob
Date:   Mon, 19 Jul 2021 20:06:28 +0300
Message-Id: <20210719170637.435541-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a global knob that controls if vlan multicast snooping is enabled.
The proper contexts (vlan or bridge-wide) will be chosen based on the knob
when processing packets and changing bridge device state. Note that
vlans have their individual mcast snooping enabled by default, but this
knob is needed to turn on bridge vlan snooping. It is disabled by
default. To enable the knob vlan filtering must also be enabled, it
doesn't make sense to have vlan mcast snooping without vlan filtering
since that would lead to inconsistencies. Disabling vlan filtering will
also automatically disable vlan mcast snooping.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |   2 +
 net/bridge/br.c                |   9 ++-
 net/bridge/br_device.c         |   7 +-
 net/bridge/br_input.c          |   5 +-
 net/bridge/br_multicast.c      | 143 ++++++++++++++++++++++++++-------
 net/bridge/br_private.h        |  37 +++++++--
 net/bridge/br_vlan.c           |  20 +++--
 7 files changed, 175 insertions(+), 48 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index d8156d1526ae..57a63a1572e0 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -720,12 +720,14 @@ struct br_mcast_stats {
 
 /* bridge boolean options
  * BR_BOOLOPT_NO_LL_LEARN - disable learning from link-local packets
+ * BR_BOOLOPT_MCAST_VLAN_SNOOPING - control vlan multicast snooping
  *
  * IMPORTANT: if adding a new option do not forget to handle
  *            it in br_boolopt_toggle/get and bridge sysfs
  */
 enum br_boolopt_id {
 	BR_BOOLOPT_NO_LL_LEARN,
+	BR_BOOLOPT_MCAST_VLAN_SNOOPING,
 	BR_BOOLOPT_MAX
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index ef743f94254d..51f2e25c4cd6 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -214,17 +214,22 @@ static struct notifier_block br_switchdev_notifier = {
 int br_boolopt_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on,
 		      struct netlink_ext_ack *extack)
 {
+	int err = 0;
+
 	switch (opt) {
 	case BR_BOOLOPT_NO_LL_LEARN:
 		br_opt_toggle(br, BROPT_NO_LL_LEARN, on);
 		break;
+	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
+		err = br_multicast_toggle_vlan_snooping(br, on, extack);
+		break;
 	default:
 		/* shouldn't be called with unsupported options */
 		WARN_ON(1);
 		break;
 	}
 
-	return 0;
+	return err;
 }
 
 int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
@@ -232,6 +237,8 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
 	switch (opt) {
 	case BR_BOOLOPT_NO_LL_LEARN:
 		return br_opt_get(br, BROPT_NO_LL_LEARN);
+	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
+		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
 	default:
 		/* shouldn't be called with unsupported options */
 		WARN_ON(1);
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index e815bf4f9f24..00daf35f54d5 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -27,12 +27,14 @@ EXPORT_SYMBOL_GPL(nf_br_ops);
 /* net device transmit always called with BH disabled */
 netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	struct net_bridge_mcast_port *pmctx_null = NULL;
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_fdb_entry *dst;
 	struct net_bridge_mdb_entry *mdst;
 	const struct nf_br_ops *nf_ops;
 	u8 state = BR_STATE_FORWARDING;
+	struct net_bridge_vlan *vlan;
 	const unsigned char *dest;
 	u16 vid = 0;
 
@@ -54,7 +56,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, ETH_HLEN);
 
-	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid, &state))
+	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid,
+				&state, &vlan))
 		goto out;
 
 	if (IS_ENABLED(CONFIG_INET) &&
@@ -83,7 +86,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
 			goto out;
 		}
-		if (br_multicast_rcv(brmctx, NULL, skb, vid)) {
+		if (br_multicast_rcv(&brmctx, &pmctx_null, vlan, skb, vid)) {
 			kfree_skb(skb);
 			goto out;
 		}
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index bb2036dd4934..8a0c0cc55cb4 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -73,6 +73,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	struct net_bridge_mdb_entry *mdst;
 	bool local_rcv, mcast_hit = false;
 	struct net_bridge_mcast *brmctx;
+	struct net_bridge_vlan *vlan;
 	struct net_bridge *br;
 	u16 vid = 0;
 	u8 state;
@@ -84,7 +85,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	pmctx = &p->multicast_ctx;
 	state = p->state;
 	if (!br_allowed_ingress(p->br, nbp_vlan_group_rcu(p), skb, &vid,
-				&state))
+				&state, &vlan))
 		goto out;
 
 	nbp_switchdev_frame_mark(p, skb);
@@ -102,7 +103,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			local_rcv = true;
 		} else {
 			pkt_type = BR_PKT_MULTICAST;
-			if (br_multicast_rcv(brmctx, pmctx, skb, vid))
+			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
 				goto drop;
 		}
 	}
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ef4e7de3f18d..b71772828b23 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1797,9 +1797,9 @@ void br_multicast_enable_port(struct net_bridge_port *port)
 {
 	struct net_bridge *br = port->br;
 
-	spin_lock(&br->multicast_lock);
+	spin_lock_bh(&br->multicast_lock);
 	__br_multicast_enable_port_ctx(&port->multicast_ctx);
-	spin_unlock(&br->multicast_lock);
+	spin_unlock_bh(&br->multicast_lock);
 }
 
 static void __br_multicast_disable_port_ctx(struct net_bridge_mcast_port *pmctx)
@@ -1827,9 +1827,9 @@ static void __br_multicast_disable_port_ctx(struct net_bridge_mcast_port *pmctx)
 
 void br_multicast_disable_port(struct net_bridge_port *port)
 {
-	spin_lock(&port->br->multicast_lock);
+	spin_lock_bh(&port->br->multicast_lock);
 	__br_multicast_disable_port_ctx(&port->multicast_ctx);
-	spin_unlock(&port->br->multicast_lock);
+	spin_unlock_bh(&port->br->multicast_lock);
 }
 
 static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
@@ -3510,8 +3510,9 @@ static int br_multicast_ipv6_rcv(struct net_bridge_mcast *brmctx,
 }
 #endif
 
-int br_multicast_rcv(struct net_bridge_mcast *brmctx,
-		     struct net_bridge_mcast_port *pmctx,
+int br_multicast_rcv(struct net_bridge_mcast **brmctx,
+		     struct net_bridge_mcast_port **pmctx,
+		     struct net_bridge_vlan *vlan,
 		     struct sk_buff *skb, u16 vid)
 {
 	int ret = 0;
@@ -3519,16 +3520,36 @@ int br_multicast_rcv(struct net_bridge_mcast *brmctx,
 	BR_INPUT_SKB_CB(skb)->igmp = 0;
 	BR_INPUT_SKB_CB(skb)->mrouters_only = 0;
 
-	if (!br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED))
+	if (!br_opt_get((*brmctx)->br, BROPT_MULTICAST_ENABLED))
 		return 0;
 
+	if (br_opt_get((*brmctx)->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) && vlan) {
+		const struct net_bridge_vlan *masterv;
+
+		/* the vlan has the master flag set only when transmitting
+		 * through the bridge device
+		 */
+		if (br_vlan_is_master(vlan)) {
+			masterv = vlan;
+			*brmctx = &vlan->br_mcast_ctx;
+			*pmctx = NULL;
+		} else {
+			masterv = vlan->brvlan;
+			*brmctx = &vlan->brvlan->br_mcast_ctx;
+			*pmctx = &vlan->port_mcast_ctx;
+		}
+
+		if (!(masterv->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED))
+			return 0;
+	}
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		ret = br_multicast_ipv4_rcv(brmctx, pmctx, skb, vid);
+		ret = br_multicast_ipv4_rcv(*brmctx, *pmctx, skb, vid);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		ret = br_multicast_ipv6_rcv(brmctx, pmctx, skb, vid);
+		ret = br_multicast_ipv6_rcv(*brmctx, *pmctx, skb, vid);
 		break;
 #endif
 	}
@@ -3727,20 +3748,22 @@ static void __br_multicast_open(struct net_bridge_mcast *brmctx)
 
 void br_multicast_open(struct net_bridge *br)
 {
-	struct net_bridge_vlan_group *vg;
-	struct net_bridge_vlan *vlan;
-
 	ASSERT_RTNL();
 
-	vg = br_vlan_group(br);
-	if (vg) {
-		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
-			struct net_bridge_mcast *brmctx;
-
-			brmctx = &vlan->br_mcast_ctx;
-			if (br_vlan_is_brentry(vlan) &&
-			    !br_multicast_ctx_vlan_disabled(brmctx))
-				__br_multicast_open(&vlan->br_mcast_ctx);
+	if (br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED)) {
+		struct net_bridge_vlan_group *vg;
+		struct net_bridge_vlan *vlan;
+
+		vg = br_vlan_group(br);
+		if (vg) {
+			list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+				struct net_bridge_mcast *brmctx;
+
+				brmctx = &vlan->br_mcast_ctx;
+				if (br_vlan_is_brentry(vlan) &&
+				    !br_multicast_ctx_vlan_disabled(brmctx))
+					__br_multicast_open(&vlan->br_mcast_ctx);
+			}
 		}
 	}
 
@@ -3804,22 +3827,80 @@ void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on)
 	}
 }
 
-void br_multicast_stop(struct net_bridge *br)
+void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on)
+{
+	struct net_bridge_port *p;
+
+	if (WARN_ON_ONCE(!br_vlan_is_master(vlan)))
+		return;
+
+	list_for_each_entry(p, &vlan->br->port_list, list) {
+		struct net_bridge_vlan *vport;
+
+		vport = br_vlan_find(nbp_vlan_group(p), vlan->vid);
+		if (!vport)
+			continue;
+		br_multicast_toggle_one_vlan(vport, on);
+	}
+}
+
+int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
+				      struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *vlan;
+	struct net_bridge_port *p;
 
-	ASSERT_RTNL();
+	if (br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) == on)
+		return 0;
+
+	if (on && !br_opt_get(br, BROPT_VLAN_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot enable multicast vlan snooping with vlan filtering disabled");
+		return -EINVAL;
+	}
 
 	vg = br_vlan_group(br);
-	if (vg) {
-		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
-			struct net_bridge_mcast *brmctx;
-
-			brmctx = &vlan->br_mcast_ctx;
-			if (br_vlan_is_brentry(vlan) &&
-			    !br_multicast_ctx_vlan_disabled(brmctx))
-				__br_multicast_stop(&vlan->br_mcast_ctx);
+	if (!vg)
+		return 0;
+
+	br_opt_toggle(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED, on);
+
+	/* disable/enable non-vlan mcast contexts based on vlan snooping */
+	if (on)
+		__br_multicast_stop(&br->multicast_ctx);
+	else
+		__br_multicast_open(&br->multicast_ctx);
+	list_for_each_entry(p, &br->port_list, list) {
+		if (on)
+			br_multicast_disable_port(p);
+		else
+			br_multicast_enable_port(p);
+	}
+
+	list_for_each_entry(vlan, &vg->vlan_list, vlist)
+		br_multicast_toggle_vlan(vlan, on);
+
+	return 0;
+}
+
+void br_multicast_stop(struct net_bridge *br)
+{
+	ASSERT_RTNL();
+
+	if (br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED)) {
+		struct net_bridge_vlan_group *vg;
+		struct net_bridge_vlan *vlan;
+
+		vg = br_vlan_group(br);
+		if (vg) {
+			list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+				struct net_bridge_mcast *brmctx;
+
+				brmctx = &vlan->br_mcast_ctx;
+				if (br_vlan_is_brentry(vlan) &&
+				    !br_multicast_ctx_vlan_disabled(brmctx))
+					__br_multicast_stop(&vlan->br_mcast_ctx);
+			}
 		}
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a27c8b8f6efd..a643f6bf759f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -441,6 +441,7 @@ enum net_bridge_opts {
 	BROPT_VLAN_STATS_PER_PORT,
 	BROPT_NO_LL_LEARN,
 	BROPT_VLAN_BRIDGE_BINDING,
+	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
 };
 
 struct net_bridge {
@@ -842,8 +843,9 @@ int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd,
 
 /* br_multicast.c */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-int br_multicast_rcv(struct net_bridge_mcast *brmctx,
-		     struct net_bridge_mcast_port *pmctx,
+int br_multicast_rcv(struct net_bridge_mcast **brmctx,
+		     struct net_bridge_mcast_port **pmctx,
+		     struct net_bridge_vlan *vlan,
 		     struct sk_buff *skb, u16 vid);
 struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge_mcast *brmctx,
 					struct sk_buff *skb, u16 vid);
@@ -917,6 +919,9 @@ void br_multicast_port_ctx_init(struct net_bridge_port *port,
 				struct net_bridge_mcast_port *pmctx);
 void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx);
 void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on);
+void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan, bool on);
+int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
+				      struct netlink_ext_ack *extack);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
@@ -1103,7 +1108,8 @@ br_multicast_port_ctx_get_global(const struct net_bridge_mcast_port *pmctx)
 static inline bool
 br_multicast_ctx_vlan_global_disabled(const struct net_bridge_mcast *brmctx)
 {
-	return br_multicast_ctx_is_vlan(brmctx) &&
+	return br_opt_get(brmctx->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) &&
+	       br_multicast_ctx_is_vlan(brmctx) &&
 	       !(brmctx->vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED);
 }
 
@@ -1121,8 +1127,9 @@ br_multicast_port_ctx_vlan_disabled(const struct net_bridge_mcast_port *pmctx)
 	       !(pmctx->vlan->priv_flags & BR_VLFLAG_MCAST_ENABLED);
 }
 #else
-static inline int br_multicast_rcv(struct net_bridge_mcast *brmctx,
-				   struct net_bridge_mcast_port *pmctx,
+static inline int br_multicast_rcv(struct net_bridge_mcast **brmctx,
+				   struct net_bridge_mcast_port **pmctx,
+				   struct net_bridge_vlan *vlan,
 				   struct sk_buff *skb,
 				   u16 vid)
 {
@@ -1258,13 +1265,26 @@ static inline void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan,
 						bool on)
 {
 }
+
+static inline void br_multicast_toggle_vlan(struct net_bridge_vlan *vlan,
+					    bool on)
+{
+}
+
+static inline int br_multicast_toggle_vlan_snooping(struct net_bridge *br,
+						    bool on,
+						    struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_vlan.c */
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 bool br_allowed_ingress(const struct net_bridge *br,
 			struct net_bridge_vlan_group *vg, struct sk_buff *skb,
-			u16 *vid, u8 *state);
+			u16 *vid, u8 *state,
+			struct net_bridge_vlan **vlan);
 bool br_allowed_egress(struct net_bridge_vlan_group *vg,
 		       const struct sk_buff *skb);
 bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid);
@@ -1376,8 +1396,11 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
 static inline bool br_allowed_ingress(const struct net_bridge *br,
 				      struct net_bridge_vlan_group *vg,
 				      struct sk_buff *skb,
-				      u16 *vid, u8 *state)
+				      u16 *vid, u8 *state,
+				      struct net_bridge_vlan **vlan)
+
 {
+	*vlan = NULL;
 	return true;
 }
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1a8cb2b1b762..ab4969a4a380 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -481,7 +481,8 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 static bool __allowed_ingress(const struct net_bridge *br,
 			      struct net_bridge_vlan_group *vg,
 			      struct sk_buff *skb, u16 *vid,
-			      u8 *state)
+			      u8 *state,
+			      struct net_bridge_vlan **vlan)
 {
 	struct pcpu_sw_netstats *stats;
 	struct net_bridge_vlan *v;
@@ -546,8 +547,9 @@ static bool __allowed_ingress(const struct net_bridge *br,
 			 */
 			skb->vlan_tci |= pvid;
 
-		/* if stats are disabled we can avoid the lookup */
-		if (!br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
+		/* if snooping and stats are disabled we can avoid the lookup */
+		if (!br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) &&
+		    !br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 			if (*state == BR_STATE_FORWARDING) {
 				*state = br_vlan_get_pvid_state(vg);
 				return br_vlan_state_allowed(*state, true);
@@ -574,6 +576,8 @@ static bool __allowed_ingress(const struct net_bridge *br,
 		u64_stats_update_end(&stats->syncp);
 	}
 
+	*vlan = v;
+
 	return true;
 
 drop:
@@ -583,17 +587,19 @@ static bool __allowed_ingress(const struct net_bridge *br,
 
 bool br_allowed_ingress(const struct net_bridge *br,
 			struct net_bridge_vlan_group *vg, struct sk_buff *skb,
-			u16 *vid, u8 *state)
+			u16 *vid, u8 *state,
+			struct net_bridge_vlan **vlan)
 {
 	/* If VLAN filtering is disabled on the bridge, all packets are
 	 * permitted.
 	 */
+	*vlan = NULL;
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED)) {
 		BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
 		return true;
 	}
 
-	return __allowed_ingress(br, vg, skb, vid, state);
+	return __allowed_ingress(br, vg, skb, vid, state, vlan);
 }
 
 /* Called under RCU. */
@@ -834,6 +840,10 @@ int br_vlan_filter_toggle(struct net_bridge *br, unsigned long val,
 	br_manage_promisc(br);
 	recalculate_group_addr(br);
 	br_recalculate_fwd_mask(br);
+	if (!val && br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED)) {
+		br_info(br, "vlan filtering disabled, automatically disabling multicast vlan snooping\n");
+		br_multicast_toggle_vlan_snooping(br, false, NULL);
+	}
 
 	return 0;
 }
-- 
2.31.1

