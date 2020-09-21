Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865C3272198
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIUK4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgIUK4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCECC0613D5
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z9so12131299wmk.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzyAv1ylBdJBBskA/FLRvBG2U6MttLS1nRYeB0zExYs=;
        b=y0MtF8NPxq4fMKCK+Z2ZEVcmXA7pDLDSkxUNin+3zhWAlAjHwadaeFe/Mzqz/t1q7h
         NxeHR1u5x/f82gd6DSentMpHztZvMeKdgVueI7Ie23ZJtFFREpHV5D5sGD58wu/1loN3
         Cq9DmU0nWjFy/Q6vc1nK73RCBH17EyaZ2yWis+fdHWAWBIYiGzuNBa58T78+Bbg4WEEJ
         T01Qpy2GTF6H4f9S80RqvyBTMm3Qh6P8528R//7rqhmGPat9+I2a81mN4PgxgCbJgCuD
         IJohwHC3jf8KRdLBMz76sRUQmltEC8Q0K2mTgjHMa1t8w276crzILE+MxM1EY7V5gNWh
         jfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzyAv1ylBdJBBskA/FLRvBG2U6MttLS1nRYeB0zExYs=;
        b=p2A5EMVb92XmMjUQ+VcG0teT38uU9DPScIVCyJJguKkfFTKgAiU1H4zle2RXdloukd
         6A7bL1T9T7xZWSFXU7hIEC3/3D1jwDsZQEPkg1aeg8vkBJRJrH9jY8iO20W3s9+/Ohk0
         Ro7PBswoCqcIhMxZWwQ6brWUmV2g1kKn9J34dm0rGYKn5zoiay5VLqjokzVZkeUFMZ2e
         E8UmOoRK7ZsR9WqRu9v/IFbhasYE9hp1YfQ+KmUCUfPkh2sOhi+kD2fMT9+IL0e6gttS
         7eljlum5ReSQiMqE3z32aBNRu7mKkkFPvyoxyU3JogQFbtf2EQZJtsL0cip6SkuMnKkO
         /c4w==
X-Gm-Message-State: AOAM533e0i6OVS35JACvDVDvLPo3x+8A24lmfaL5XOnwtqNCmXtqKGiP
        8KqBUerPr9rqTN+f1qcExOGsSNlQg91ZWiyfFSyRGQ==
X-Google-Smtp-Source: ABdhPJywTWL4dKgsdN9HHmYAbDJSynpJNOn4NnWsNN3uODhpkPUHcOZqm7mVPMe0X4ytVn87qGkcbw==
X-Received: by 2002:a1c:cc0a:: with SMTP id h10mr28079410wmb.80.1600685780413;
        Mon, 21 Sep 2020 03:56:20 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:19 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 10/16] net: bridge: mcast: add rt_protocol field to the port group struct
Date:   Mon, 21 Sep 2020 13:55:20 +0300
Message-Id: <20200921105526.1056983-11-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to be able to differentiate between pg entries created by
user-space and the kernel when we start generating S,G entries for
IGMPv3/MLDv2's fast path. User-space entries are created by default as
RTPROT_STATIC and the kernel entries are RTPROT_KERNEL. Later we can
allow user-space to provide the entry rt_protocol so we can
differentiate between who added the entries specifically (e.g. clag,
admin, frr etc).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            | 42 +++++++++++++++++++++-------------
 net/bridge/br_multicast.c      |  7 ++++--
 net/bridge/br_private.h        |  3 ++-
 4 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 3e6377c865eb..1054f151078d 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -458,6 +458,7 @@ enum {
 	MDBA_MDB_EATTR_SRC_LIST,
 	MDBA_MDB_EATTR_GROUP_MODE,
 	MDBA_MDB_EATTR_SOURCE,
+	MDBA_MDB_EATTR_RTPROT,
 	__MDBA_MDB_EATTR_MAX
 };
 #define MDBA_MDB_EATTR_MAX (__MDBA_MDB_EATTR_MAX - 1)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7f9ca5c20120..b386a5e07698 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -184,6 +184,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 			MDBA_MDB_EATTR_TIMER,
 			br_timer_value(mtimer)))
 		goto nest_err;
+
 	switch (mp->addr.proto) {
 	case htons(ETH_P_IP):
 		dump_srcs_mode = !!(mp->br->multicast_igmp_version == 3);
@@ -206,10 +207,15 @@ static int __mdb_fill_info(struct sk_buff *skb,
 		break;
 #endif
 	}
-	if (p && dump_srcs_mode &&
-	    (__mdb_fill_srcs(skb, p) ||
-	     nla_put_u8(skb, MDBA_MDB_EATTR_GROUP_MODE, p->filter_mode)))
-		goto nest_err;
+	if (p) {
+		if (nla_put_u8(skb, MDBA_MDB_EATTR_RTPROT, p->rt_protocol))
+			goto nest_err;
+		if (dump_srcs_mode &&
+		    (__mdb_fill_srcs(skb, p) ||
+		     nla_put_u8(skb, MDBA_MDB_EATTR_GROUP_MODE,
+				p->filter_mode)))
+			goto nest_err;
+	}
 	nla_nest_end(skb, nest_ent);
 
 	return 0;
@@ -414,6 +420,9 @@ static size_t rtnl_mdb_nlmsg_size(struct net_bridge_port_group *pg)
 	if (!pg)
 		goto out;
 
+	/* MDBA_MDB_EATTR_RTPROT */
+	nlmsg_size += nla_total_size(sizeof(u8));
+
 	switch (pg->addr.proto) {
 	case htons(ETH_P_IP):
 		/* MDBA_MDB_EATTR_SOURCE */
@@ -809,16 +818,20 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_ip *group, struct br_mdb_entry *entry,
+			    struct br_mdb_entry *entry,
+			    struct nlattr **mdb_attrs,
 			    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
 	unsigned long now = jiffies;
+	struct br_ip group;
 	u8 filter_mode;
 	int err;
 
+	__mdb_entry_to_br_ip(entry, &group, mdb_attrs);
+
 	/* host join errors which can happen before creating the group */
 	if (!port) {
 		/* don't allow any flags for host-joined groups */
@@ -826,15 +839,15 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
 			return -EINVAL;
 		}
-		if (!br_multicast_is_star_g(group)) {
+		if (!br_multicast_is_star_g(&group)) {
 			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
 			return -EINVAL;
 		}
 	}
 
-	mp = br_mdb_ip_get(br, group);
+	mp = br_mdb_ip_get(br, &group);
 	if (!mp) {
-		mp = br_multicast_new_group(br, group);
+		mp = br_multicast_new_group(br, &group);
 		err = PTR_ERR_OR_ZERO(mp);
 		if (err)
 			return err;
@@ -864,11 +877,11 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			break;
 	}
 
-	filter_mode = br_multicast_is_star_g(group) ? MCAST_EXCLUDE :
-						      MCAST_INCLUDE;
+	filter_mode = br_multicast_is_star_g(&group) ? MCAST_EXCLUDE :
+						       MCAST_INCLUDE;
 
-	p = br_multicast_new_port_group(port, group, *pp, entry->state, NULL,
-					filter_mode);
+	p = br_multicast_new_port_group(port, &group, *pp, entry->state, NULL,
+					filter_mode, RTPROT_STATIC);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
 		return -ENOMEM;
@@ -887,13 +900,10 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 			struct nlattr **mdb_attrs,
 			struct netlink_ext_ack *extack)
 {
-	struct br_ip ip;
 	int ret;
 
-	__mdb_entry_to_br_ip(entry, &ip, mdb_attrs);
-
 	spin_lock_bh(&br->multicast_lock);
-	ret = br_mdb_add_group(br, p, &ip, entry, extack);
+	ret = br_mdb_add_group(br, p, entry, mdb_attrs, extack);
 	spin_unlock_bh(&br->multicast_lock);
 
 	return ret;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4fd690bc848f..b6e7b0ece422 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -795,7 +795,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 			struct net_bridge_port_group __rcu *next,
 			unsigned char flags,
 			const unsigned char *src,
-			u8 filter_mode)
+			u8 filter_mode,
+			u8 rt_protocol)
 {
 	struct net_bridge_port_group *p;
 
@@ -807,6 +808,7 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->port = port;
 	p->flags = flags;
 	p->filter_mode = filter_mode;
+	p->rt_protocol = rt_protocol;
 	p->mcast_gc.destroy = br_multicast_destroy_port_group;
 	INIT_HLIST_HEAD(&p->src_list);
 	rcu_assign_pointer(p->next, next);
@@ -892,7 +894,8 @@ static int br_multicast_add_group(struct net_bridge *br,
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, 0, src, filter_mode);
+	p = br_multicast_new_port_group(port, group, *pp, 0, src, filter_mode,
+					RTPROT_KERNEL);
 	if (unlikely(!p))
 		goto err;
 	rcu_assign_pointer(*pp, p);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 0f54a7a7c186..dae7e3526fc7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -246,6 +246,7 @@ struct net_bridge_port_group {
 	unsigned char			flags;
 	unsigned char			filter_mode;
 	unsigned char			grp_query_rexmit_cnt;
+	unsigned char			rt_protocol;
 
 	struct hlist_head		src_list;
 	unsigned int			src_ents;
@@ -804,7 +805,7 @@ struct net_bridge_port_group *
 br_multicast_new_port_group(struct net_bridge_port *port, struct br_ip *group,
 			    struct net_bridge_port_group __rcu *next,
 			    unsigned char flags, const unsigned char *src,
-			    u8 filter_mode);
+			    u8 filter_mode, u8 rt_protocol);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
-- 
2.25.4

