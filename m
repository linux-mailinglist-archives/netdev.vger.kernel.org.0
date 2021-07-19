Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF58E3CE83A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353337AbhGSQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355613AbhGSQg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29483C04F966
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ec55so24997471edb.1
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1gS+FOa179JN+HZznGsv5629EP8DgmKrhT0+XPnWss=;
        b=crWpvbO3blsvd/xWNfu2RHUEMHcT1W/5K4ZQHpGKNT/Dl2Q2JLuDweaDmYnzgomBiv
         KwtVP5D/fgYCcWYpeMiFXrBcBz6WX5AzdDdGg2urdpZD9p5rVcXaF3bAqglw5ndnR9fO
         sagv4a5kSxzvWB06KG1AX/H62X5mFRC05PCVbdV+KxOtwOcwB+rOB6uY59h4SRdPIcMo
         a9dQzFDKLSF3byzABxMNVty6gXA/hrJFgIKqClzyHa4EUqlGIzW1vEe7vW+/3/j3YVOx
         f6k9sSwMb3CPzza/14zilhsbMM/BAU/+sT9wNxLkc1W11ud1fW1R1P3397oP6rm5mxzU
         YyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1gS+FOa179JN+HZznGsv5629EP8DgmKrhT0+XPnWss=;
        b=No4ZBUbVgi+L9fp7w7M+huUELXh1X/KDbwpDNe7F/f7V6diVXrG3WJWbH9OCR/pTtf
         aYhRPRDMmQmbknrRIc6Dn5ZOnqnAiUDjFIphtTUn735EZ9tORSLlYRSd1aRSsmainuZE
         rLIQgbSycMce7CM63RnG7aE0mMCw3eQiJAsJuoQ4tUanHcbX22CZYgpizoa1Y7D29RFe
         RE4Mfn8dFUUWfsfRbtNt0aJ6UV7T1I+f/Kp0+v69C3YVoY+ikKigEMaNXIvHJBThr3qk
         5srfQ2NNSsjh1nK4Loy1a/fRsUuW5ARGtgKCUuw1qId+DZ7GVqsPBGhnZDKCu/m5+pWa
         +LQg==
X-Gm-Message-State: AOAM5320uzDpr3JN93a/gZpg3F2Syn7lXCXaE5ARXBqHTCu2jEzApMfG
        l2ZeP79+Lv8b6RPgihxflhZx9irbx8/pNiNz/0g=
X-Google-Smtp-Source: ABdhPJzyUdM0WB621QkCHvEsDAunbjvlw/qcB7oRh3Ef2avNE+9jyUhlu7zHTLECZDxdttWxWrCiYg==
X-Received: by 2002:aa7:d746:: with SMTP id a6mr35387137eds.296.1626714598361;
        Mon, 19 Jul 2021 10:09:58 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:09:57 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 02/15] net: bridge: multicast: factor out bridge multicast context
Date:   Mon, 19 Jul 2021 20:06:24 +0300
Message-Id: <20210719170637.435541-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out the bridge's global multicast context into a separate
structure which will later be used for per-vlan global context.
No functional changes intended.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c       |  23 +--
 net/bridge/br_multicast.c | 398 +++++++++++++++++++++-----------------
 net/bridge/br_netlink.c   |  39 ++--
 net/bridge/br_private.h   | 112 ++++++-----
 net/bridge/br_sysfs_br.c  |  38 ++--
 5 files changed, 335 insertions(+), 275 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 64619dc65bc8..effe03c08038 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -16,13 +16,13 @@
 
 #include "br_private.h"
 
-static bool br_rports_have_mc_router(struct net_bridge *br)
+static bool br_rports_have_mc_router(struct net_bridge_mcast *brmctx)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return !hlist_empty(&br->ip4_mc_router_list) ||
-	       !hlist_empty(&br->ip6_mc_router_list);
+	return !hlist_empty(&brmctx->ip4_mc_router_list) ||
+	       !hlist_empty(&brmctx->ip6_mc_router_list);
 #else
-	return !hlist_empty(&br->ip4_mc_router_list);
+	return !hlist_empty(&brmctx->ip4_mc_router_list);
 #endif
 }
 
@@ -54,10 +54,10 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	struct nlattr *nest, *port_nest;
 	struct net_bridge_port *p;
 
-	if (!br->multicast_router)
+	if (!br->multicast_ctx.multicast_router)
 		return 0;
 
-	if (!br_rports_have_mc_router(br))
+	if (!br_rports_have_mc_router(&br->multicast_ctx))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
@@ -240,7 +240,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 
 	switch (mp->addr.proto) {
 	case htons(ETH_P_IP):
-		dump_srcs_mode = !!(mp->br->multicast_igmp_version == 3);
+		dump_srcs_mode = !!(mp->br->multicast_ctx.multicast_igmp_version == 3);
 		if (mp->addr.src.ip4) {
 			if (nla_put_in_addr(skb, MDBA_MDB_EATTR_SOURCE,
 					    mp->addr.src.ip4))
@@ -250,7 +250,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		dump_srcs_mode = !!(mp->br->multicast_mld_version == 2);
+		dump_srcs_mode = !!(mp->br->multicast_ctx.multicast_mld_version == 2);
 		if (!ipv6_addr_any(&mp->addr.src.ip6)) {
 			if (nla_put_in6_addr(skb, MDBA_MDB_EATTR_SOURCE,
 					     &mp->addr.src.ip6))
@@ -483,7 +483,7 @@ static size_t rtnl_mdb_nlmsg_size(struct net_bridge_port_group *pg)
 		/* MDBA_MDB_EATTR_SOURCE */
 		if (pg->key.addr.src.ip4)
 			nlmsg_size += nla_total_size(sizeof(__be32));
-		if (pg->key.port->br->multicast_igmp_version == 2)
+		if (pg->key.port->br->multicast_ctx.multicast_igmp_version == 2)
 			goto out;
 		addr_size = sizeof(__be32);
 		break;
@@ -492,7 +492,7 @@ static size_t rtnl_mdb_nlmsg_size(struct net_bridge_port_group *pg)
 		/* MDBA_MDB_EATTR_SOURCE */
 		if (!ipv6_addr_any(&pg->key.addr.src.ip6))
 			nlmsg_size += nla_total_size(sizeof(struct in6_addr));
-		if (pg->key.port->br->multicast_mld_version == 1)
+		if (pg->key.port->br->multicast_ctx.multicast_mld_version == 1)
 			goto out;
 		addr_size = sizeof(struct in6_addr);
 		break;
@@ -1084,7 +1084,8 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	}
 	rcu_assign_pointer(*pp, p);
 	if (entry->state == MDB_TEMPORARY)
-		mod_timer(&p->timer, now + br->multicast_membership_interval);
+		mod_timer(&p->timer,
+			  now + br->multicast_ctx.multicast_membership_interval);
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
 	 * added to all S,G entries for proper replication, if we are adding
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3abb673ee4ee..92bfc1d95cd5 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -158,7 +158,7 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		ip.dst.ip4 = ip_hdr(skb)->daddr;
-		if (br->multicast_igmp_version == 3) {
+		if (br->multicast_ctx.multicast_igmp_version == 3) {
 			struct net_bridge_mdb_entry *mdb;
 
 			ip.src.ip4 = ip_hdr(skb)->saddr;
@@ -171,7 +171,7 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		ip.dst.ip6 = ipv6_hdr(skb)->daddr;
-		if (br->multicast_mld_version == 2) {
+		if (br->multicast_ctx.multicast_mld_version == 2) {
 			struct net_bridge_mdb_entry *mdb;
 
 			ip.src.ip6 = ipv6_hdr(skb)->saddr;
@@ -699,6 +699,7 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 						    u8 sflag, u8 *igmp_type,
 						    bool *need_rexmit)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
 	size_t pkt_size, igmp_hdr_size;
@@ -714,11 +715,11 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	u16 lmqt_srcs = 0;
 
 	igmp_hdr_size = sizeof(*ih);
-	if (br->multicast_igmp_version == 3) {
+	if (brmctx->multicast_igmp_version == 3) {
 		igmp_hdr_size = sizeof(*ihv3);
 		if (pg && with_srcs) {
-			lmqt = now + (br->multicast_last_member_interval *
-				      br->multicast_last_member_count);
+			lmqt = now + (brmctx->multicast_last_member_interval *
+				      brmctx->multicast_last_member_count);
 			hlist_for_each_entry(ent, &pg->src_list, node) {
 				if (over_lmqt == time_after(ent->timer.expires,
 							    lmqt) &&
@@ -775,12 +776,12 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	skb_set_transport_header(skb, skb->len);
 	*igmp_type = IGMP_HOST_MEMBERSHIP_QUERY;
 
-	switch (br->multicast_igmp_version) {
+	switch (brmctx->multicast_igmp_version) {
 	case 2:
 		ih = igmp_hdr(skb);
 		ih->type = IGMP_HOST_MEMBERSHIP_QUERY;
-		ih->code = (group ? br->multicast_last_member_interval :
-				    br->multicast_query_response_interval) /
+		ih->code = (group ? brmctx->multicast_last_member_interval :
+				    brmctx->multicast_query_response_interval) /
 			   (HZ / IGMP_TIMER_SCALE);
 		ih->group = group;
 		ih->csum = 0;
@@ -790,11 +791,11 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	case 3:
 		ihv3 = igmpv3_query_hdr(skb);
 		ihv3->type = IGMP_HOST_MEMBERSHIP_QUERY;
-		ihv3->code = (group ? br->multicast_last_member_interval :
-				      br->multicast_query_response_interval) /
+		ihv3->code = (group ? brmctx->multicast_last_member_interval :
+				      brmctx->multicast_query_response_interval) /
 			     (HZ / IGMP_TIMER_SCALE);
 		ihv3->group = group;
-		ihv3->qqic = br->multicast_query_interval / HZ;
+		ihv3->qqic = brmctx->multicast_query_interval / HZ;
 		ihv3->nsrcs = htons(lmqt_srcs);
 		ihv3->resv = 0;
 		ihv3->suppress = sflag;
@@ -845,6 +846,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 						    u8 sflag, u8 *igmp_type,
 						    bool *need_rexmit)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_port *p = pg ? pg->key.port : NULL;
 	struct net_bridge_group_src *ent;
 	size_t pkt_size, mld_hdr_size;
@@ -862,11 +864,11 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	u8 *hopopt;
 
 	mld_hdr_size = sizeof(*mldq);
-	if (br->multicast_mld_version == 2) {
+	if (brmctx->multicast_mld_version == 2) {
 		mld_hdr_size = sizeof(*mld2q);
 		if (pg && with_srcs) {
-			llqt = now + (br->multicast_last_member_interval *
-				      br->multicast_last_member_count);
+			llqt = now + (brmctx->multicast_last_member_interval *
+				      brmctx->multicast_last_member_count);
 			hlist_for_each_entry(ent, &pg->src_list, node) {
 				if (over_llqt == time_after(ent->timer.expires,
 							    llqt) &&
@@ -933,10 +935,10 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	/* ICMPv6 */
 	skb_set_transport_header(skb, skb->len);
 	interval = ipv6_addr_any(group) ?
-			br->multicast_query_response_interval :
-			br->multicast_last_member_interval;
+			brmctx->multicast_query_response_interval :
+			brmctx->multicast_last_member_interval;
 	*igmp_type = ICMPV6_MGM_QUERY;
-	switch (br->multicast_mld_version) {
+	switch (brmctx->multicast_mld_version) {
 	case 1:
 		mldq = (struct mld_msg *)icmp6_hdr(skb);
 		mldq->mld_type = ICMPV6_MGM_QUERY;
@@ -959,7 +961,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 		mld2q->mld2q_suppress = sflag;
 		mld2q->mld2q_qrv = 2;
 		mld2q->mld2q_nsrcs = htons(llqt_srcs);
-		mld2q->mld2q_qqic = br->multicast_query_interval / HZ;
+		mld2q->mld2q_qqic = brmctx->multicast_query_interval / HZ;
 		mld2q->mld2q_mca = *group;
 		csum = &mld2q->mld2q_cksum;
 		csum_start = (void *)mld2q;
@@ -1219,7 +1221,8 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 	if (br_group_is_l2(&mp->addr))
 		return;
 
-	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
+	mod_timer(&mp->timer,
+		  jiffies + mp->br->multicast_ctx.multicast_membership_interval);
 }
 
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
@@ -1283,7 +1286,8 @@ __br_multicast_add_group(struct net_bridge *br,
 
 found:
 	if (igmpv2_mldv1)
-		mod_timer(&p->timer, now + br->multicast_membership_interval);
+		mod_timer(&p->timer,
+			  now + br->multicast_ctx.multicast_membership_interval);
 
 out:
 	return p;
@@ -1430,63 +1434,68 @@ static void br_mc_router_state_change(struct net_bridge *p,
 	switchdev_port_attr_set(p->dev, &attr, NULL);
 }
 
-static void br_multicast_local_router_expired(struct net_bridge *br,
+static void br_multicast_local_router_expired(struct net_bridge_mcast *brmctx,
 					      struct timer_list *timer)
 {
-	spin_lock(&br->multicast_lock);
-	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
-	    br->multicast_router == MDB_RTR_TYPE_PERM ||
-	    br_ip4_multicast_is_router(br) ||
-	    br_ip6_multicast_is_router(br))
+	spin_lock(&brmctx->br->multicast_lock);
+	if (brmctx->multicast_router == MDB_RTR_TYPE_DISABLED ||
+	    brmctx->multicast_router == MDB_RTR_TYPE_PERM ||
+	    br_ip4_multicast_is_router(brmctx) ||
+	    br_ip6_multicast_is_router(brmctx))
 		goto out;
 
-	br_mc_router_state_change(br, false);
+	br_mc_router_state_change(brmctx->br, false);
 out:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
 static void br_ip4_multicast_local_router_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
+	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
+						     ip4_mc_router_timer);
 
-	br_multicast_local_router_expired(br, t);
+	br_multicast_local_router_expired(brmctx, t);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_local_router_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip6_mc_router_timer);
+	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
+						     ip6_mc_router_timer);
 
-	br_multicast_local_router_expired(br, t);
+	br_multicast_local_router_expired(brmctx, t);
 }
 #endif
 
-static void br_multicast_querier_expired(struct net_bridge *br,
+static void br_multicast_querier_expired(struct net_bridge_mcast *brmctx,
 					 struct bridge_mcast_own_query *query)
 {
-	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+	spin_lock(&brmctx->br->multicast_lock);
+	if (!netif_running(brmctx->br->dev) ||
+	    !br_opt_get(brmctx->br, BROPT_MULTICAST_ENABLED))
 		goto out;
 
-	br_multicast_start_querier(br, query);
+	br_multicast_start_querier(brmctx->br, query);
 
 out:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 }
 
 static void br_ip4_multicast_querier_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip4_other_query.timer);
+	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
+						     ip4_other_query.timer);
 
-	br_multicast_querier_expired(br, &br->ip4_own_query);
+	br_multicast_querier_expired(brmctx, &brmctx->ip4_own_query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_querier_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip6_other_query.timer);
+	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
+						     ip6_other_query.timer);
 
-	br_multicast_querier_expired(br, &br->ip6_own_query);
+	br_multicast_querier_expired(brmctx, &brmctx->ip6_own_query);
 }
 #endif
 
@@ -1494,11 +1503,13 @@ static void br_multicast_select_own_querier(struct net_bridge *br,
 					    struct br_ip *ip,
 					    struct sk_buff *skb)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+
 	if (ip->proto == htons(ETH_P_IP))
-		br->ip4_querier.addr.src.ip4 = ip_hdr(skb)->saddr;
+		brmctx->ip4_querier.addr.src.ip4 = ip_hdr(skb)->saddr;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		br->ip6_querier.addr.src.ip6 = ipv6_hdr(skb)->saddr;
+		brmctx->ip6_querier.addr.src.ip6 = ipv6_hdr(skb)->saddr;
 #endif
 }
 
@@ -1546,6 +1557,7 @@ static void br_multicast_send_query(struct net_bridge *br,
 				    struct net_bridge_port *port,
 				    struct bridge_mcast_own_query *own_query)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct bridge_mcast_other_query *other_query = NULL;
 	struct br_ip br_group;
 	unsigned long time;
@@ -1558,12 +1570,12 @@ static void br_multicast_send_query(struct net_bridge *br,
 	memset(&br_group.dst, 0, sizeof(br_group.dst));
 
 	if (port ? (own_query == &port->multicast_ctx.ip4_own_query) :
-		   (own_query == &br->ip4_own_query)) {
-		other_query = &br->ip4_other_query;
+		   (own_query == &brmctx->ip4_own_query)) {
+		other_query = &brmctx->ip4_other_query;
 		br_group.proto = htons(ETH_P_IP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		other_query = &br->ip6_other_query;
+		other_query = &brmctx->ip6_other_query;
 		br_group.proto = htons(ETH_P_IPV6);
 #endif
 	}
@@ -1575,9 +1587,9 @@ static void br_multicast_send_query(struct net_bridge *br,
 				  NULL);
 
 	time = jiffies;
-	time += own_query->startup_sent < br->multicast_startup_query_count ?
-		br->multicast_startup_query_interval :
-		br->multicast_query_interval;
+	time += own_query->startup_sent < brmctx->multicast_startup_query_count ?
+		brmctx->multicast_startup_query_interval :
+		brmctx->multicast_query_interval;
 	mod_timer(&own_query->timer, time);
 }
 
@@ -1592,7 +1604,7 @@ br_multicast_port_query_expired(struct net_bridge_mcast_port *pmctx,
 	    pmctx->port->state == BR_STATE_BLOCKING)
 		goto out;
 
-	if (query->startup_sent < br->multicast_startup_query_count)
+	if (query->startup_sent < br->multicast_ctx.multicast_startup_query_count)
 		query->startup_sent++;
 
 	br_multicast_send_query(pmctx->port->br, pmctx->port, query);
@@ -1624,6 +1636,7 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 	struct net_bridge_port_group *pg = from_timer(pg, t, rexmit_timer);
 	struct bridge_mcast_other_query *other_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	bool need_rexmit = false;
 
 	spin_lock(&br->multicast_lock);
@@ -1633,10 +1646,10 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 		goto out;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
-		other_query = &br->ip4_other_query;
+		other_query = &brmctx->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		other_query = &br->ip6_other_query;
+		other_query = &brmctx->ip6_other_query;
 #endif
 
 	if (!other_query || timer_pending(&other_query->timer))
@@ -1652,7 +1665,7 @@ static void br_multicast_port_group_rexmit(struct timer_list *t)
 
 	if (pg->grp_query_rexmit_cnt || need_rexmit)
 		mod_timer(&pg->rexmit_timer, jiffies +
-					     br->multicast_last_member_interval);
+					     brmctx->multicast_last_member_interval);
 out:
 	spin_unlock(&br->multicast_lock);
 }
@@ -1819,7 +1832,8 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
-	u32 lmqc = br->multicast_last_member_count;
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+	u32 lmqc = brmctx->multicast_last_member_count;
 	unsigned long lmqt, lmi, now = jiffies;
 	struct net_bridge_group_src *ent;
 
@@ -1828,10 +1842,10 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 		return;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
-		other_query = &br->ip4_other_query;
+		other_query = &brmctx->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		other_query = &br->ip6_other_query;
+		other_query = &brmctx->ip6_other_query;
 #endif
 
 	lmqt = now + br_multicast_lmqt(br);
@@ -1855,7 +1869,7 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 	__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
 				  &pg->key.addr, true, 1, NULL);
 
-	lmi = now + br->multicast_last_member_interval;
+	lmi = now + brmctx->multicast_last_member_interval;
 	if (!timer_pending(&pg->rexmit_timer) ||
 	    time_after(pg->rexmit_timer.expires, lmi))
 		mod_timer(&pg->rexmit_timer, lmi);
@@ -1865,6 +1879,7 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
 	struct net_bridge *br = pg->key.port->br;
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned long now = jiffies, lmi;
 
 	if (!netif_running(br->dev) ||
@@ -1872,16 +1887,16 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
 		return;
 
 	if (pg->key.addr.proto == htons(ETH_P_IP))
-		other_query = &br->ip4_other_query;
+		other_query = &brmctx->ip4_other_query;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		other_query = &br->ip6_other_query;
+		other_query = &brmctx->ip6_other_query;
 #endif
 
 	if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
 	    other_query && !timer_pending(&other_query->timer)) {
-		lmi = now + br->multicast_last_member_interval;
-		pg->grp_query_rexmit_cnt = br->multicast_last_member_count - 1;
+		lmi = now + brmctx->multicast_last_member_interval;
+		pg->grp_query_rexmit_cnt = brmctx->multicast_last_member_count - 1;
 		__br_multicast_send_query(br, pg->key.port, pg, &pg->key.addr,
 					  &pg->key.addr, false, 0, NULL);
 		if (!timer_pending(&pg->rexmit_timer) ||
@@ -2405,7 +2420,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 					 struct sk_buff *skb,
 					 u16 vid)
 {
-	bool igmpv2 = br->multicast_igmp_version == 2;
+	bool igmpv2 = br->multicast_ctx.multicast_igmp_version == 2;
 	struct net_bridge_mdb_entry *mdst;
 	struct net_bridge_port_group *pg;
 	const unsigned char *src;
@@ -2517,7 +2532,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 					struct sk_buff *skb,
 					u16 vid)
 {
-	bool mldv1 = br->multicast_mld_version == 1;
+	bool mldv1 = br->multicast_ctx.multicast_mld_version == 1;
 	struct net_bridge_mdb_entry *mdst;
 	struct net_bridge_port_group *pg;
 	unsigned int nsrcs_offset;
@@ -2655,23 +2670,25 @@ static bool br_ip4_multicast_select_querier(struct net_bridge *br,
 					    struct net_bridge_port *port,
 					    __be32 saddr)
 {
-	if (!timer_pending(&br->ip4_own_query.timer) &&
-	    !timer_pending(&br->ip4_other_query.timer))
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+
+	if (!timer_pending(&brmctx->ip4_own_query.timer) &&
+	    !timer_pending(&brmctx->ip4_other_query.timer))
 		goto update;
 
-	if (!br->ip4_querier.addr.src.ip4)
+	if (!brmctx->ip4_querier.addr.src.ip4)
 		goto update;
 
-	if (ntohl(saddr) <= ntohl(br->ip4_querier.addr.src.ip4))
+	if (ntohl(saddr) <= ntohl(brmctx->ip4_querier.addr.src.ip4))
 		goto update;
 
 	return false;
 
 update:
-	br->ip4_querier.addr.src.ip4 = saddr;
+	brmctx->ip4_querier.addr.src.ip4 = saddr;
 
 	/* update protected by general multicast_lock by caller */
-	rcu_assign_pointer(br->ip4_querier.port, port);
+	rcu_assign_pointer(brmctx->ip4_querier.port, port);
 
 	return true;
 }
@@ -2681,20 +2698,22 @@ static bool br_ip6_multicast_select_querier(struct net_bridge *br,
 					    struct net_bridge_port *port,
 					    struct in6_addr *saddr)
 {
-	if (!timer_pending(&br->ip6_own_query.timer) &&
-	    !timer_pending(&br->ip6_other_query.timer))
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+
+	if (!timer_pending(&brmctx->ip6_own_query.timer) &&
+	    !timer_pending(&brmctx->ip6_other_query.timer))
 		goto update;
 
-	if (ipv6_addr_cmp(saddr, &br->ip6_querier.addr.src.ip6) <= 0)
+	if (ipv6_addr_cmp(saddr, &brmctx->ip6_querier.addr.src.ip6) <= 0)
 		goto update;
 
 	return false;
 
 update:
-	br->ip6_querier.addr.src.ip6 = *saddr;
+	brmctx->ip6_querier.addr.src.ip6 = *saddr;
 
 	/* update protected by general multicast_lock by caller */
-	rcu_assign_pointer(br->ip6_querier.port, port);
+	rcu_assign_pointer(brmctx->ip6_querier.port, port);
 
 	return true;
 }
@@ -2708,7 +2727,8 @@ br_multicast_update_query_timer(struct net_bridge *br,
 	if (!timer_pending(&query->timer))
 		query->delay_time = jiffies + max_delay;
 
-	mod_timer(&query->timer, jiffies + br->multicast_querier_interval);
+	mod_timer(&query->timer, jiffies +
+				 br->multicast_ctx.multicast_querier_interval);
 }
 
 static void br_port_mc_router_state_change(struct net_bridge_port *p,
@@ -2725,14 +2745,14 @@ static void br_port_mc_router_state_change(struct net_bridge_port *p,
 }
 
 static struct net_bridge_port *
-br_multicast_rport_from_node(struct net_bridge *br,
+br_multicast_rport_from_node(struct net_bridge_mcast *brmctx,
 			     struct hlist_head *mc_router_list,
 			     struct hlist_node *rlist)
 {
 	struct net_bridge_mcast_port *pmctx;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (mc_router_list == &br->ip6_mc_router_list)
+	if (mc_router_list == &brmctx->ip6_mc_router_list)
 		pmctx = hlist_entry(rlist, struct net_bridge_mcast_port,
 				    ip6_rlist);
 	else
@@ -2744,7 +2764,7 @@ br_multicast_rport_from_node(struct net_bridge *br,
 }
 
 static struct hlist_node *
-br_multicast_get_rport_slot(struct net_bridge *br,
+br_multicast_get_rport_slot(struct net_bridge_mcast *brmctx,
 			    struct net_bridge_port *port,
 			    struct hlist_head *mc_router_list)
 
@@ -2754,7 +2774,7 @@ br_multicast_get_rport_slot(struct net_bridge *br,
 	struct hlist_node *rlist;
 
 	hlist_for_each(rlist, mc_router_list) {
-		p = br_multicast_rport_from_node(br, mc_router_list, rlist);
+		p = br_multicast_rport_from_node(brmctx, mc_router_list, rlist);
 
 		if ((unsigned long)port >= (unsigned long)p)
 			break;
@@ -2782,7 +2802,7 @@ static bool br_multicast_no_router_otherpf(struct net_bridge_port *port,
  *  list is maintained ordered by pointer value
  *  and locked by br->multicast_lock and RCU
  */
-static void br_multicast_add_router(struct net_bridge *br,
+static void br_multicast_add_router(struct net_bridge_mcast *brmctx,
 				    struct net_bridge_port *port,
 				    struct hlist_node *rlist,
 				    struct hlist_head *mc_router_list)
@@ -2792,7 +2812,7 @@ static void br_multicast_add_router(struct net_bridge *br,
 	if (!hlist_unhashed(rlist))
 		return;
 
-	slot = br_multicast_get_rport_slot(br, port, mc_router_list);
+	slot = br_multicast_get_rport_slot(brmctx, port, mc_router_list);
 
 	if (slot)
 		hlist_add_behind_rcu(rlist, slot);
@@ -2804,7 +2824,7 @@ static void br_multicast_add_router(struct net_bridge *br,
 	 * IPv4 or IPv6 multicast router.
 	 */
 	if (br_multicast_no_router_otherpf(port, rlist)) {
-		br_rtr_notify(br->dev, port, RTM_NEWMDB);
+		br_rtr_notify(port->br->dev, port, RTM_NEWMDB);
 		br_port_mc_router_state_change(port, true);
 	}
 }
@@ -2816,8 +2836,9 @@ static void br_multicast_add_router(struct net_bridge *br,
 static void br_ip4_multicast_add_router(struct net_bridge *br,
 					struct net_bridge_port *port)
 {
-	br_multicast_add_router(br, port, &port->multicast_ctx.ip4_rlist,
-				&br->ip4_mc_router_list);
+	br_multicast_add_router(&br->multicast_ctx, port,
+				&port->multicast_ctx.ip4_rlist,
+				&br->multicast_ctx.ip4_mc_router_list);
 }
 
 /* Add port to router_list
@@ -2828,8 +2849,9 @@ static void br_ip6_multicast_add_router(struct net_bridge *br,
 					struct net_bridge_port *port)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_add_router(br, port, &port->multicast_ctx.ip6_rlist,
-				&br->ip6_mc_router_list);
+	br_multicast_add_router(&br->multicast_ctx, port,
+				&port->multicast_ctx.ip6_rlist,
+				&br->multicast_ctx.ip6_mc_router_list);
 #endif
 }
 
@@ -2839,14 +2861,15 @@ static void br_multicast_mark_router(struct net_bridge *br,
 				     struct hlist_node *rlist,
 				     struct hlist_head *mc_router_list)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned long now = jiffies;
 
 	if (!port) {
-		if (br->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
-			if (!br_ip4_multicast_is_router(br) &&
-			    !br_ip6_multicast_is_router(br))
+		if (brmctx->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
+			if (!br_ip4_multicast_is_router(brmctx) &&
+			    !br_ip6_multicast_is_router(brmctx))
 				br_mc_router_state_change(br, true);
-			mod_timer(timer, now + br->multicast_querier_interval);
+			mod_timer(timer, now + brmctx->multicast_querier_interval);
 		}
 		return;
 	}
@@ -2855,14 +2878,14 @@ static void br_multicast_mark_router(struct net_bridge *br,
 	    port->multicast_ctx.multicast_router == MDB_RTR_TYPE_PERM)
 		return;
 
-	br_multicast_add_router(br, port, rlist, mc_router_list);
-	mod_timer(timer, now + br->multicast_querier_interval);
+	br_multicast_add_router(brmctx, port, rlist, mc_router_list);
+	mod_timer(timer, now + brmctx->multicast_querier_interval);
 }
 
 static void br_ip4_multicast_mark_router(struct net_bridge *br,
 					 struct net_bridge_port *port)
 {
-	struct timer_list *timer = &br->ip4_mc_router_timer;
+	struct timer_list *timer = &br->multicast_ctx.ip4_mc_router_timer;
 	struct hlist_node *rlist = NULL;
 
 	if (port) {
@@ -2871,14 +2894,14 @@ static void br_ip4_multicast_mark_router(struct net_bridge *br,
 	}
 
 	br_multicast_mark_router(br, port, timer, rlist,
-				 &br->ip4_mc_router_list);
+				 &br->multicast_ctx.ip4_mc_router_list);
 }
 
 static void br_ip6_multicast_mark_router(struct net_bridge *br,
 					 struct net_bridge_port *port)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct timer_list *timer = &br->ip6_mc_router_timer;
+	struct timer_list *timer = &br->multicast_ctx.ip6_mc_router_timer;
 	struct hlist_node *rlist = NULL;
 
 	if (port) {
@@ -2887,7 +2910,7 @@ static void br_ip6_multicast_mark_router(struct net_bridge *br,
 	}
 
 	br_multicast_mark_router(br, port, timer, rlist,
-				 &br->ip6_mc_router_list);
+				 &br->multicast_ctx.ip6_mc_router_list);
 #endif
 }
 
@@ -2926,6 +2949,7 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 				   struct sk_buff *skb,
 				   u16 vid)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned int transport_len = ip_transport_len(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	struct igmphdr *ih = igmp_hdr(skb);
@@ -2955,7 +2979,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	} else if (transport_len >= sizeof(*ih3)) {
 		ih3 = igmpv3_query_hdr(skb);
 		if (ih3->nsrcs ||
-		    (br->multicast_igmp_version == 3 && group && ih3->suppress))
+		    (brmctx->multicast_igmp_version == 3 && group &&
+		     ih3->suppress))
 			goto out;
 
 		max_delay = ih3->code ?
@@ -2968,7 +2993,8 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IP);
 		saddr.src.ip4 = iph->saddr;
 
-		br_ip4_multicast_query_received(br, port, &br->ip4_other_query,
+		br_ip4_multicast_query_received(br, port,
+						&brmctx->ip4_other_query,
 						&saddr, max_delay);
 		goto out;
 	}
@@ -2977,7 +3003,7 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 	if (!mp)
 		goto out;
 
-	max_delay *= br->multicast_last_member_count;
+	max_delay *= brmctx->multicast_last_member_count;
 
 	if (mp->host_joined &&
 	    (timer_pending(&mp->timer) ?
@@ -2991,7 +3017,7 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
 		    try_to_del_timer_sync(&p->timer) >= 0 &&
-		    (br->multicast_igmp_version == 2 ||
+		    (brmctx->multicast_igmp_version == 2 ||
 		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
@@ -3006,6 +3032,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 				  struct sk_buff *skb,
 				  u16 vid)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned int transport_len = ipv6_transport_len(skb);
 	struct mld_msg *mld;
 	struct net_bridge_mdb_entry *mp;
@@ -3042,7 +3069,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
-		if (br->multicast_mld_version == 2 &&
+		if (brmctx->multicast_mld_version == 2 &&
 		    !ipv6_addr_any(&mld2q->mld2q_mca) &&
 		    mld2q->mld2q_suppress)
 			goto out;
@@ -3056,7 +3083,8 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		saddr.proto = htons(ETH_P_IPV6);
 		saddr.src.ip6 = ipv6_hdr(skb)->saddr;
 
-		br_ip6_multicast_query_received(br, port, &br->ip6_other_query,
+		br_ip6_multicast_query_received(br, port,
+						&brmctx->ip6_other_query,
 						&saddr, max_delay);
 		goto out;
 	} else if (!group) {
@@ -3067,7 +3095,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	if (!mp)
 		goto out;
 
-	max_delay *= br->multicast_last_member_count;
+	max_delay *= brmctx->multicast_last_member_count;
 	if (mp->host_joined &&
 	    (timer_pending(&mp->timer) ?
 	     time_after(mp->timer.expires, now + max_delay) :
@@ -3080,7 +3108,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		if (timer_pending(&p->timer) ?
 		    time_after(p->timer.expires, now + max_delay) :
 		    try_to_del_timer_sync(&p->timer) >= 0 &&
-		    (br->multicast_mld_version == 1 ||
+		    (brmctx->multicast_mld_version == 1 ||
 		     p->filter_mode == MCAST_EXCLUDE))
 			mod_timer(&p->timer, now + max_delay);
 	}
@@ -3099,6 +3127,7 @@ br_multicast_leave_group(struct net_bridge *br,
 			 struct bridge_mcast_own_query *own_query,
 			 const unsigned char *src)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	unsigned long now;
@@ -3138,8 +3167,8 @@ br_multicast_leave_group(struct net_bridge *br,
 		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
 					  false, 0, NULL);
 
-		time = jiffies + br->multicast_last_member_count *
-				 br->multicast_last_member_interval;
+		time = jiffies + brmctx->multicast_last_member_count *
+				 brmctx->multicast_last_member_interval;
 
 		mod_timer(&own_query->timer, time);
 
@@ -3161,8 +3190,8 @@ br_multicast_leave_group(struct net_bridge *br,
 	}
 
 	now = jiffies;
-	time = now + br->multicast_last_member_count *
-		     br->multicast_last_member_interval;
+	time = now + brmctx->multicast_last_member_count *
+		     brmctx->multicast_last_member_interval;
 
 	if (!port) {
 		if (mp->host_joined &&
@@ -3207,14 +3236,15 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 		return;
 
 	own_query = port ? &port->multicast_ctx.ip4_own_query :
-			   &br->ip4_own_query;
+			   &br->multicast_ctx.ip4_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group, &br->ip4_other_query,
+	br_multicast_leave_group(br, port, &br_group,
+				 &br->multicast_ctx.ip4_other_query,
 				 own_query, src);
 }
 
@@ -3232,14 +3262,15 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 		return;
 
 	own_query = port ? &port->multicast_ctx.ip6_own_query :
-			   &br->ip6_own_query;
+			   &br->multicast_ctx.ip6_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip6 = *group;
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group, &br->ip6_other_query,
+	br_multicast_leave_group(br, port, &br_group,
+				 &br->multicast_ctx.ip6_other_query,
 				 own_query, src);
 }
 #endif
@@ -3460,7 +3491,7 @@ static void br_multicast_query_expired(struct net_bridge *br,
 				       struct bridge_mcast_querier *querier)
 {
 	spin_lock(&br->multicast_lock);
-	if (query->startup_sent < br->multicast_startup_query_count)
+	if (query->startup_sent < br->multicast_ctx.multicast_startup_query_count)
 		query->startup_sent++;
 
 	RCU_INIT_POINTER(querier->port, NULL);
@@ -3470,17 +3501,21 @@ static void br_multicast_query_expired(struct net_bridge *br,
 
 static void br_ip4_multicast_query_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip4_own_query.timer);
+	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
+						     ip4_own_query.timer);
 
-	br_multicast_query_expired(br, &br->ip4_own_query, &br->ip4_querier);
+	br_multicast_query_expired(brmctx->br, &brmctx->ip4_own_query,
+				   &brmctx->ip4_querier);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_query_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, ip6_own_query.timer);
+	struct net_bridge_mcast *brmctx = from_timer(brmctx, t,
+						     ip6_own_query.timer);
 
-	br_multicast_query_expired(br, &br->ip6_own_query, &br->ip6_querier);
+	br_multicast_query_expired(brmctx->br, &brmctx->ip6_own_query,
+				   &brmctx->ip6_querier);
 }
 #endif
 
@@ -3501,41 +3536,42 @@ void br_multicast_init(struct net_bridge *br)
 {
 	br->hash_max = BR_MULTICAST_DEFAULT_HASH_MAX;
 
-	br->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
-	br->multicast_last_member_count = 2;
-	br->multicast_startup_query_count = 2;
-
-	br->multicast_last_member_interval = HZ;
-	br->multicast_query_response_interval = 10 * HZ;
-	br->multicast_startup_query_interval = 125 * HZ / 4;
-	br->multicast_query_interval = 125 * HZ;
-	br->multicast_querier_interval = 255 * HZ;
-	br->multicast_membership_interval = 260 * HZ;
-
-	br->ip4_other_query.delay_time = 0;
-	br->ip4_querier.port = NULL;
-	br->multicast_igmp_version = 2;
+	br->multicast_ctx.br = br;
+	br->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
+	br->multicast_ctx.multicast_last_member_count = 2;
+	br->multicast_ctx.multicast_startup_query_count = 2;
+
+	br->multicast_ctx.multicast_last_member_interval = HZ;
+	br->multicast_ctx.multicast_query_response_interval = 10 * HZ;
+	br->multicast_ctx.multicast_startup_query_interval = 125 * HZ / 4;
+	br->multicast_ctx.multicast_query_interval = 125 * HZ;
+	br->multicast_ctx.multicast_querier_interval = 255 * HZ;
+	br->multicast_ctx.multicast_membership_interval = 260 * HZ;
+
+	br->multicast_ctx.ip4_other_query.delay_time = 0;
+	br->multicast_ctx.ip4_querier.port = NULL;
+	br->multicast_ctx.multicast_igmp_version = 2;
 #if IS_ENABLED(CONFIG_IPV6)
-	br->multicast_mld_version = 1;
-	br->ip6_other_query.delay_time = 0;
-	br->ip6_querier.port = NULL;
+	br->multicast_ctx.multicast_mld_version = 1;
+	br->multicast_ctx.ip6_other_query.delay_time = 0;
+	br->multicast_ctx.ip6_querier.port = NULL;
 #endif
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, true);
 	br_opt_toggle(br, BROPT_HAS_IPV6_ADDR, true);
 
 	spin_lock_init(&br->multicast_lock);
-	timer_setup(&br->ip4_mc_router_timer,
+	timer_setup(&br->multicast_ctx.ip4_mc_router_timer,
 		    br_ip4_multicast_local_router_expired, 0);
-	timer_setup(&br->ip4_other_query.timer,
+	timer_setup(&br->multicast_ctx.ip4_other_query.timer,
 		    br_ip4_multicast_querier_expired, 0);
-	timer_setup(&br->ip4_own_query.timer,
+	timer_setup(&br->multicast_ctx.ip4_own_query.timer,
 		    br_ip4_multicast_query_expired, 0);
 #if IS_ENABLED(CONFIG_IPV6)
-	timer_setup(&br->ip6_mc_router_timer,
+	timer_setup(&br->multicast_ctx.ip6_mc_router_timer,
 		    br_ip6_multicast_local_router_expired, 0);
-	timer_setup(&br->ip6_other_query.timer,
+	timer_setup(&br->multicast_ctx.ip6_other_query.timer,
 		    br_ip6_multicast_querier_expired, 0);
-	timer_setup(&br->ip6_own_query.timer,
+	timer_setup(&br->multicast_ctx.ip6_own_query.timer,
 		    br_ip6_multicast_query_expired, 0);
 #endif
 	INIT_HLIST_HEAD(&br->mdb_list);
@@ -3618,21 +3654,21 @@ static void __br_multicast_open(struct net_bridge *br,
 
 void br_multicast_open(struct net_bridge *br)
 {
-	__br_multicast_open(br, &br->ip4_own_query);
+	__br_multicast_open(br, &br->multicast_ctx.ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	__br_multicast_open(br, &br->ip6_own_query);
+	__br_multicast_open(br, &br->multicast_ctx.ip6_own_query);
 #endif
 }
 
 void br_multicast_stop(struct net_bridge *br)
 {
-	del_timer_sync(&br->ip4_mc_router_timer);
-	del_timer_sync(&br->ip4_other_query.timer);
-	del_timer_sync(&br->ip4_own_query.timer);
+	del_timer_sync(&br->multicast_ctx.ip4_mc_router_timer);
+	del_timer_sync(&br->multicast_ctx.ip4_other_query.timer);
+	del_timer_sync(&br->multicast_ctx.ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
-	del_timer_sync(&br->ip6_mc_router_timer);
-	del_timer_sync(&br->ip6_other_query.timer);
-	del_timer_sync(&br->ip6_own_query.timer);
+	del_timer_sync(&br->multicast_ctx.ip6_mc_router_timer);
+	del_timer_sync(&br->multicast_ctx.ip6_other_query.timer);
+	del_timer_sync(&br->multicast_ctx.ip6_own_query.timer);
 #endif
 }
 
@@ -3656,6 +3692,7 @@ void br_multicast_dev_del(struct net_bridge *br)
 
 int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	int err = -EINVAL;
 
 	spin_lock_bh(&br->multicast_lock);
@@ -3664,17 +3701,17 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 	case MDB_RTR_TYPE_DISABLED:
 	case MDB_RTR_TYPE_PERM:
 		br_mc_router_state_change(br, val == MDB_RTR_TYPE_PERM);
-		del_timer(&br->ip4_mc_router_timer);
+		del_timer(&brmctx->ip4_mc_router_timer);
 #if IS_ENABLED(CONFIG_IPV6)
-		del_timer(&br->ip6_mc_router_timer);
+		del_timer(&brmctx->ip6_mc_router_timer);
 #endif
-		br->multicast_router = val;
+		brmctx->multicast_router = val;
 		err = 0;
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
-		if (br->multicast_router != MDB_RTR_TYPE_TEMP_QUERY)
+		if (brmctx->multicast_router != MDB_RTR_TYPE_TEMP_QUERY)
 			br_mc_router_state_change(br, false);
-		br->multicast_router = val;
+		brmctx->multicast_router = val;
 		err = 0;
 		break;
 	}
@@ -3710,20 +3747,20 @@ br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
 
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 {
-	struct net_bridge *br = p->br;
+	struct net_bridge_mcast *brmctx = &p->br->multicast_ctx;
 	unsigned long now = jiffies;
 	int err = -EINVAL;
 	bool del = false;
 
-	spin_lock(&br->multicast_lock);
+	spin_lock(&p->br->multicast_lock);
 	if (p->multicast_ctx.multicast_router == val) {
 		/* Refresh the temp router port timer */
 		if (p->multicast_ctx.multicast_router == MDB_RTR_TYPE_TEMP) {
 			mod_timer(&p->multicast_ctx.ip4_mc_router_timer,
-				  now + br->multicast_querier_interval);
+				  now + brmctx->multicast_querier_interval);
 #if IS_ENABLED(CONFIG_IPV6)
 			mod_timer(&p->multicast_ctx.ip6_mc_router_timer,
-				  now + br->multicast_querier_interval);
+				  now + brmctx->multicast_querier_interval);
 #endif
 		}
 		err = 0;
@@ -3749,23 +3786,23 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	case MDB_RTR_TYPE_PERM:
 		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_PERM;
 		del_timer(&p->multicast_ctx.ip4_mc_router_timer);
-		br_ip4_multicast_add_router(br, p);
+		br_ip4_multicast_add_router(p->br, p);
 #if IS_ENABLED(CONFIG_IPV6)
 		del_timer(&p->multicast_ctx.ip6_mc_router_timer);
 #endif
-		br_ip6_multicast_add_router(br, p);
+		br_ip6_multicast_add_router(p->br, p);
 		break;
 	case MDB_RTR_TYPE_TEMP:
 		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP;
-		br_ip4_multicast_mark_router(br, p);
-		br_ip6_multicast_mark_router(br, p);
+		br_ip4_multicast_mark_router(p->br, p);
+		br_ip6_multicast_mark_router(p->br, p);
 		break;
 	default:
 		goto unlock;
 	}
 	err = 0;
 unlock:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock(&p->br->multicast_lock);
 
 	return err;
 }
@@ -3783,7 +3820,7 @@ static void br_multicast_start_querier(struct net_bridge *br,
 		    port->state == BR_STATE_BLOCKING)
 			continue;
 
-		if (query == &br->ip4_own_query)
+		if (query == &br->multicast_ctx.ip4_own_query)
 			br_multicast_enable(&port->multicast_ctx.ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 		else
@@ -3872,6 +3909,7 @@ EXPORT_SYMBOL_GPL(br_multicast_router);
 
 int br_multicast_set_querier(struct net_bridge *br, unsigned long val)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
 	unsigned long max_delay;
 
 	val = !!val;
@@ -3884,18 +3922,18 @@ int br_multicast_set_querier(struct net_bridge *br, unsigned long val)
 	if (!val)
 		goto unlock;
 
-	max_delay = br->multicast_query_response_interval;
+	max_delay = brmctx->multicast_query_response_interval;
 
-	if (!timer_pending(&br->ip4_other_query.timer))
-		br->ip4_other_query.delay_time = jiffies + max_delay;
+	if (!timer_pending(&brmctx->ip4_other_query.timer))
+		brmctx->ip4_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &br->ip4_own_query);
+	br_multicast_start_querier(br, &brmctx->ip4_own_query);
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (!timer_pending(&br->ip6_other_query.timer))
-		br->ip6_other_query.delay_time = jiffies + max_delay;
+	if (!timer_pending(&brmctx->ip6_other_query.timer))
+		brmctx->ip6_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &br->ip6_own_query);
+	br_multicast_start_querier(br, &brmctx->ip6_own_query);
 #endif
 
 unlock:
@@ -3916,7 +3954,7 @@ int br_multicast_set_igmp_version(struct net_bridge *br, unsigned long val)
 	}
 
 	spin_lock_bh(&br->multicast_lock);
-	br->multicast_igmp_version = val;
+	br->multicast_ctx.multicast_igmp_version = val;
 	spin_unlock_bh(&br->multicast_lock);
 
 	return 0;
@@ -3935,7 +3973,7 @@ int br_multicast_set_mld_version(struct net_bridge *br, unsigned long val)
 	}
 
 	spin_lock_bh(&br->multicast_lock);
-	br->multicast_mld_version = val;
+	br->multicast_ctx.multicast_mld_version = val;
 	spin_unlock_bh(&br->multicast_lock);
 
 	return 0;
@@ -4047,6 +4085,7 @@ EXPORT_SYMBOL_GPL(br_multicast_has_querier_anywhere);
  */
 bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto)
 {
+	struct net_bridge_mcast *brmctx;
 	struct net_bridge *br;
 	struct net_bridge_port *port;
 	bool ret = false;
@@ -4060,17 +4099,18 @@ bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto)
 		goto unlock;
 
 	br = port->br;
+	brmctx = &br->multicast_ctx;
 
 	switch (proto) {
 	case ETH_P_IP:
-		if (!timer_pending(&br->ip4_other_query.timer) ||
-		    rcu_dereference(br->ip4_querier.port) == port)
+		if (!timer_pending(&brmctx->ip4_other_query.timer) ||
+		    rcu_dereference(brmctx->ip4_querier.port) == port)
 			goto unlock;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case ETH_P_IPV6:
-		if (!timer_pending(&br->ip6_other_query.timer) ||
-		    rcu_dereference(br->ip6_querier.port) == port)
+		if (!timer_pending(&brmctx->ip6_other_query.timer) ||
+		    rcu_dereference(brmctx->ip6_querier.port) == port)
 			goto unlock;
 		break;
 #endif
@@ -4097,6 +4137,7 @@ EXPORT_SYMBOL_GPL(br_multicast_has_querier_adjacent);
 bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
 {
 	struct net_bridge_mcast_port *pmctx;
+	struct net_bridge_mcast *brmctx;
 	struct net_bridge_port *port;
 	bool ret = false;
 
@@ -4105,9 +4146,10 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
 	if (!port)
 		goto unlock;
 
+	brmctx = &port->br->multicast_ctx;
 	switch (proto) {
 	case ETH_P_IP:
-		hlist_for_each_entry_rcu(pmctx, &port->br->ip4_mc_router_list,
+		hlist_for_each_entry_rcu(pmctx, &brmctx->ip4_mc_router_list,
 					 ip4_rlist) {
 			if (pmctx->port == port)
 				continue;
@@ -4118,7 +4160,7 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case ETH_P_IPV6:
-		hlist_for_each_entry_rcu(pmctx, &port->br->ip6_mc_router_list,
+		hlist_for_each_entry_rcu(pmctx, &brmctx->ip6_mc_router_list,
 					 ip6_rlist) {
 			if (pmctx->port == port)
 				continue;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 0cbe5826cfe8..3d5860e41084 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1387,49 +1387,49 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_LAST_MEMBER_CNT]) {
 		u32 val = nla_get_u32(data[IFLA_BR_MCAST_LAST_MEMBER_CNT]);
 
-		br->multicast_last_member_count = val;
+		br->multicast_ctx.multicast_last_member_count = val;
 	}
 
 	if (data[IFLA_BR_MCAST_STARTUP_QUERY_CNT]) {
 		u32 val = nla_get_u32(data[IFLA_BR_MCAST_STARTUP_QUERY_CNT]);
 
-		br->multicast_startup_query_count = val;
+		br->multicast_ctx.multicast_startup_query_count = val;
 	}
 
 	if (data[IFLA_BR_MCAST_LAST_MEMBER_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_LAST_MEMBER_INTVL]);
 
-		br->multicast_last_member_interval = clock_t_to_jiffies(val);
+		br->multicast_ctx.multicast_last_member_interval = clock_t_to_jiffies(val);
 	}
 
 	if (data[IFLA_BR_MCAST_MEMBERSHIP_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_MEMBERSHIP_INTVL]);
 
-		br->multicast_membership_interval = clock_t_to_jiffies(val);
+		br->multicast_ctx.multicast_membership_interval = clock_t_to_jiffies(val);
 	}
 
 	if (data[IFLA_BR_MCAST_QUERIER_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_QUERIER_INTVL]);
 
-		br->multicast_querier_interval = clock_t_to_jiffies(val);
+		br->multicast_ctx.multicast_querier_interval = clock_t_to_jiffies(val);
 	}
 
 	if (data[IFLA_BR_MCAST_QUERY_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_QUERY_INTVL]);
 
-		br->multicast_query_interval = clock_t_to_jiffies(val);
+		br->multicast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
 	}
 
 	if (data[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]);
 
-		br->multicast_query_response_interval = clock_t_to_jiffies(val);
+		br->multicast_ctx.multicast_query_response_interval = clock_t_to_jiffies(val);
 	}
 
 	if (data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]);
 
-		br->multicast_startup_query_interval = clock_t_to_jiffies(val);
+		br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
 	}
 
 	if (data[IFLA_BR_MCAST_STATS_ENABLED]) {
@@ -1636,7 +1636,8 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 		return -EMSGSIZE;
 #endif
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-	if (nla_put_u8(skb, IFLA_BR_MCAST_ROUTER, br->multicast_router) ||
+	if (nla_put_u8(skb, IFLA_BR_MCAST_ROUTER,
+		       br->multicast_ctx.multicast_router) ||
 	    nla_put_u8(skb, IFLA_BR_MCAST_SNOOPING,
 		       br_opt_get(br, BROPT_MULTICAST_ENABLED)) ||
 	    nla_put_u8(skb, IFLA_BR_MCAST_QUERY_USE_IFADDR,
@@ -1648,38 +1649,38 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	    nla_put_u32(skb, IFLA_BR_MCAST_HASH_ELASTICITY, RHT_ELASTICITY) ||
 	    nla_put_u32(skb, IFLA_BR_MCAST_HASH_MAX, br->hash_max) ||
 	    nla_put_u32(skb, IFLA_BR_MCAST_LAST_MEMBER_CNT,
-			br->multicast_last_member_count) ||
+			br->multicast_ctx.multicast_last_member_count) ||
 	    nla_put_u32(skb, IFLA_BR_MCAST_STARTUP_QUERY_CNT,
-			br->multicast_startup_query_count) ||
+			br->multicast_ctx.multicast_startup_query_count) ||
 	    nla_put_u8(skb, IFLA_BR_MCAST_IGMP_VERSION,
-		       br->multicast_igmp_version))
+		       br->multicast_ctx.multicast_igmp_version))
 		return -EMSGSIZE;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, IFLA_BR_MCAST_MLD_VERSION,
-		       br->multicast_mld_version))
+		       br->multicast_ctx.multicast_mld_version))
 		return -EMSGSIZE;
 #endif
-	clockval = jiffies_to_clock_t(br->multicast_last_member_interval);
+	clockval = jiffies_to_clock_t(br->multicast_ctx.multicast_last_member_interval);
 	if (nla_put_u64_64bit(skb, IFLA_BR_MCAST_LAST_MEMBER_INTVL, clockval,
 			      IFLA_BR_PAD))
 		return -EMSGSIZE;
-	clockval = jiffies_to_clock_t(br->multicast_membership_interval);
+	clockval = jiffies_to_clock_t(br->multicast_ctx.multicast_membership_interval);
 	if (nla_put_u64_64bit(skb, IFLA_BR_MCAST_MEMBERSHIP_INTVL, clockval,
 			      IFLA_BR_PAD))
 		return -EMSGSIZE;
-	clockval = jiffies_to_clock_t(br->multicast_querier_interval);
+	clockval = jiffies_to_clock_t(br->multicast_ctx.multicast_querier_interval);
 	if (nla_put_u64_64bit(skb, IFLA_BR_MCAST_QUERIER_INTVL, clockval,
 			      IFLA_BR_PAD))
 		return -EMSGSIZE;
-	clockval = jiffies_to_clock_t(br->multicast_query_interval);
+	clockval = jiffies_to_clock_t(br->multicast_ctx.multicast_query_interval);
 	if (nla_put_u64_64bit(skb, IFLA_BR_MCAST_QUERY_INTVL, clockval,
 			      IFLA_BR_PAD))
 		return -EMSGSIZE;
-	clockval = jiffies_to_clock_t(br->multicast_query_response_interval);
+	clockval = jiffies_to_clock_t(br->multicast_ctx.multicast_query_response_interval);
 	if (nla_put_u64_64bit(skb, IFLA_BR_MCAST_QUERY_RESPONSE_INTVL, clockval,
 			      IFLA_BR_PAD))
 		return -EMSGSIZE;
-	clockval = jiffies_to_clock_t(br->multicast_startup_query_interval);
+	clockval = jiffies_to_clock_t(br->multicast_ctx.multicast_startup_query_interval);
 	if (nla_put_u64_64bit(skb, IFLA_BR_MCAST_STARTUP_QUERY_INTVL, clockval,
 			      IFLA_BR_PAD))
 		return -EMSGSIZE;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 61034fd8a3bd..badd490fce7a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -106,6 +106,40 @@ struct net_bridge_mcast_port {
 #endif /* CONFIG_BRIDGE_IGMP_SNOOPING */
 };
 
+/* net_bridge_mcast must be always defined due to forwarding stubs */
+struct net_bridge_mcast {
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	struct net_bridge		*br;
+
+	u32				multicast_last_member_count;
+	u32				multicast_startup_query_count;
+
+	u8				multicast_igmp_version;
+	u8				multicast_router;
+#if IS_ENABLED(CONFIG_IPV6)
+	u8				multicast_mld_version;
+#endif
+	unsigned long			multicast_last_member_interval;
+	unsigned long			multicast_membership_interval;
+	unsigned long			multicast_querier_interval;
+	unsigned long			multicast_query_interval;
+	unsigned long			multicast_query_response_interval;
+	unsigned long			multicast_startup_query_interval;
+	struct hlist_head		ip4_mc_router_list;
+	struct timer_list		ip4_mc_router_timer;
+	struct bridge_mcast_other_query	ip4_other_query;
+	struct bridge_mcast_own_query	ip4_own_query;
+	struct bridge_mcast_querier	ip4_querier;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct hlist_head		ip6_mc_router_list;
+	struct timer_list		ip6_mc_router_timer;
+	struct bridge_mcast_other_query	ip6_other_query;
+	struct bridge_mcast_own_query	ip6_own_query;
+	struct bridge_mcast_querier	ip6_querier;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+#endif /* CONFIG_BRIDGE_IGMP_SNOOPING */
+};
+
 struct br_tunnel_info {
 	__be64				tunnel_id;
 	struct metadata_dst __rcu	*tunnel_dst;
@@ -445,25 +479,14 @@ struct net_bridge {
 		BR_USER_STP,		/* new RSTP in userspace */
 	} stp_enabled;
 
+	struct net_bridge_mcast		multicast_ctx;
+
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	struct bridge_mcast_stats	__percpu *mcast_stats;
 
 	u32				hash_max;
 
-	u32				multicast_last_member_count;
-	u32				multicast_startup_query_count;
-
-	u8				multicast_igmp_version;
-	u8				multicast_router;
-#if IS_ENABLED(CONFIG_IPV6)
-	u8				multicast_mld_version;
-#endif
 	spinlock_t			multicast_lock;
-	unsigned long			multicast_last_member_interval;
-	unsigned long			multicast_membership_interval;
-	unsigned long			multicast_querier_interval;
-	unsigned long			multicast_query_interval;
-	unsigned long			multicast_query_response_interval;
-	unsigned long			multicast_startup_query_interval;
 
 	struct rhashtable		mdb_hash_tbl;
 	struct rhashtable		sg_port_tbl;
@@ -471,19 +494,6 @@ struct net_bridge {
 	struct hlist_head		mcast_gc_list;
 	struct hlist_head		mdb_list;
 
-	struct hlist_head		ip4_mc_router_list;
-	struct timer_list		ip4_mc_router_timer;
-	struct bridge_mcast_other_query	ip4_other_query;
-	struct bridge_mcast_own_query	ip4_own_query;
-	struct bridge_mcast_querier	ip4_querier;
-	struct bridge_mcast_stats	__percpu *mcast_stats;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct hlist_head		ip6_mc_router_list;
-	struct timer_list		ip6_mc_router_timer;
-	struct bridge_mcast_other_query	ip6_other_query;
-	struct bridge_mcast_own_query	ip6_own_query;
-	struct bridge_mcast_querier	ip6_querier;
-#endif /* IS_ENABLED(CONFIG_IPV6) */
 	struct work_struct		mcast_gc_work;
 #endif
 
@@ -893,16 +903,20 @@ static inline bool br_group_is_l2(const struct br_ip *group)
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
 
 static inline struct hlist_node *
-br_multicast_get_first_rport_node(struct net_bridge *b, struct sk_buff *skb) {
+br_multicast_get_first_rport_node(struct net_bridge *br, struct sk_buff *skb)
+{
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (skb->protocol == htons(ETH_P_IPV6))
-		return rcu_dereference(hlist_first_rcu(&b->ip6_mc_router_list));
+		return rcu_dereference(hlist_first_rcu(&brmctx->ip6_mc_router_list));
 #endif
-	return rcu_dereference(hlist_first_rcu(&b->ip4_mc_router_list));
+	return rcu_dereference(hlist_first_rcu(&brmctx->ip4_mc_router_list));
 }
 
 static inline struct net_bridge_port *
-br_multicast_rport_from_node_skb(struct hlist_node *rp, struct sk_buff *skb) {
+br_multicast_rport_from_node_skb(struct hlist_node *rp, struct sk_buff *skb)
+{
 	struct net_bridge_mcast_port *mctx;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -920,15 +934,15 @@ br_multicast_rport_from_node_skb(struct hlist_node *rp, struct sk_buff *skb) {
 		return NULL;
 }
 
-static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
+static inline bool br_ip4_multicast_is_router(struct net_bridge_mcast *brmctx)
 {
-	return timer_pending(&br->ip4_mc_router_timer);
+	return timer_pending(&brmctx->ip4_mc_router_timer);
 }
 
-static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
+static inline bool br_ip6_multicast_is_router(struct net_bridge_mcast *brmctx)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return timer_pending(&br->ip6_mc_router_timer);
+	return timer_pending(&brmctx->ip6_mc_router_timer);
 #else
 	return false;
 #endif
@@ -937,18 +951,20 @@ static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
 static inline bool
 br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
 {
-	switch (br->multicast_router) {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+
+	switch (brmctx->multicast_router) {
 	case MDB_RTR_TYPE_PERM:
 		return true;
 	case MDB_RTR_TYPE_TEMP_QUERY:
 		if (skb) {
 			if (skb->protocol == htons(ETH_P_IP))
-				return br_ip4_multicast_is_router(br);
+				return br_ip4_multicast_is_router(brmctx);
 			else if (skb->protocol == htons(ETH_P_IPV6))
-				return br_ip6_multicast_is_router(br);
+				return br_ip6_multicast_is_router(brmctx);
 		} else {
-			return br_ip4_multicast_is_router(br) ||
-			       br_ip6_multicast_is_router(br);
+			return br_ip4_multicast_is_router(brmctx) ||
+			       br_ip6_multicast_is_router(brmctx);
 		}
 		fallthrough;
 	default:
@@ -983,11 +999,11 @@ static inline bool br_multicast_querier_exists(struct net_bridge *br,
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
 		return __br_multicast_querier_exists(br,
-			&br->ip4_other_query, false);
+			&br->multicast_ctx.ip4_other_query, false);
 #if IS_ENABLED(CONFIG_IPV6)
 	case (htons(ETH_P_IPV6)):
 		return __br_multicast_querier_exists(br,
-			&br->ip6_other_query, true);
+			&br->multicast_ctx.ip6_other_query, true);
 #endif
 	default:
 		return !!mdb && br_group_is_l2(&mdb->addr);
@@ -1013,10 +1029,10 @@ static inline bool br_multicast_should_handle_mode(const struct net_bridge *br,
 {
 	switch (proto) {
 	case htons(ETH_P_IP):
-		return !!(br->multicast_igmp_version == 3);
+		return !!(br->multicast_ctx.multicast_igmp_version == 3);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		return !!(br->multicast_mld_version == 2);
+		return !!(br->multicast_ctx.multicast_mld_version == 2);
 #endif
 	default:
 		return false;
@@ -1030,15 +1046,15 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 
 static inline unsigned long br_multicast_lmqt(const struct net_bridge *br)
 {
-	return br->multicast_last_member_interval *
-	       br->multicast_last_member_count;
+	return br->multicast_ctx.multicast_last_member_interval *
+	       br->multicast_ctx.multicast_last_member_count;
 }
 
 static inline unsigned long br_multicast_gmi(const struct net_bridge *br)
 {
 	/* use the RFC default of 2 for QRV */
-	return 2 * br->multicast_query_interval +
-	       br->multicast_query_response_interval;
+	return 2 * br->multicast_ctx.multicast_query_interval +
+	       br->multicast_ctx.multicast_query_response_interval;
 }
 #else
 static inline int br_multicast_rcv(struct net_bridge *br,
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 381467b691d5..953d544663d5 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -384,7 +384,7 @@ static ssize_t multicast_router_show(struct device *d,
 				     struct device_attribute *attr, char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%d\n", br->multicast_router);
+	return sprintf(buf, "%d\n", br->multicast_ctx.multicast_router);
 }
 
 static int set_multicast_router(struct net_bridge *br, unsigned long val,
@@ -514,7 +514,7 @@ static ssize_t multicast_igmp_version_show(struct device *d,
 {
 	struct net_bridge *br = to_bridge(d);
 
-	return sprintf(buf, "%u\n", br->multicast_igmp_version);
+	return sprintf(buf, "%u\n", br->multicast_ctx.multicast_igmp_version);
 }
 
 static int set_multicast_igmp_version(struct net_bridge *br, unsigned long val,
@@ -536,13 +536,13 @@ static ssize_t multicast_last_member_count_show(struct device *d,
 						char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%u\n", br->multicast_last_member_count);
+	return sprintf(buf, "%u\n", br->multicast_ctx.multicast_last_member_count);
 }
 
 static int set_last_member_count(struct net_bridge *br, unsigned long val,
 				 struct netlink_ext_ack *extack)
 {
-	br->multicast_last_member_count = val;
+	br->multicast_ctx.multicast_last_member_count = val;
 	return 0;
 }
 
@@ -558,13 +558,13 @@ static ssize_t multicast_startup_query_count_show(
 	struct device *d, struct device_attribute *attr, char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%u\n", br->multicast_startup_query_count);
+	return sprintf(buf, "%u\n", br->multicast_ctx.multicast_startup_query_count);
 }
 
 static int set_startup_query_count(struct net_bridge *br, unsigned long val,
 				   struct netlink_ext_ack *extack)
 {
-	br->multicast_startup_query_count = val;
+	br->multicast_ctx.multicast_startup_query_count = val;
 	return 0;
 }
 
@@ -581,13 +581,13 @@ static ssize_t multicast_last_member_interval_show(
 {
 	struct net_bridge *br = to_bridge(d);
 	return sprintf(buf, "%lu\n",
-		       jiffies_to_clock_t(br->multicast_last_member_interval));
+		       jiffies_to_clock_t(br->multicast_ctx.multicast_last_member_interval));
 }
 
 static int set_last_member_interval(struct net_bridge *br, unsigned long val,
 				    struct netlink_ext_ack *extack)
 {
-	br->multicast_last_member_interval = clock_t_to_jiffies(val);
+	br->multicast_ctx.multicast_last_member_interval = clock_t_to_jiffies(val);
 	return 0;
 }
 
@@ -604,13 +604,13 @@ static ssize_t multicast_membership_interval_show(
 {
 	struct net_bridge *br = to_bridge(d);
 	return sprintf(buf, "%lu\n",
-		       jiffies_to_clock_t(br->multicast_membership_interval));
+		       jiffies_to_clock_t(br->multicast_ctx.multicast_membership_interval));
 }
 
 static int set_membership_interval(struct net_bridge *br, unsigned long val,
 				   struct netlink_ext_ack *extack)
 {
-	br->multicast_membership_interval = clock_t_to_jiffies(val);
+	br->multicast_ctx.multicast_membership_interval = clock_t_to_jiffies(val);
 	return 0;
 }
 
@@ -628,13 +628,13 @@ static ssize_t multicast_querier_interval_show(struct device *d,
 {
 	struct net_bridge *br = to_bridge(d);
 	return sprintf(buf, "%lu\n",
-		       jiffies_to_clock_t(br->multicast_querier_interval));
+		       jiffies_to_clock_t(br->multicast_ctx.multicast_querier_interval));
 }
 
 static int set_querier_interval(struct net_bridge *br, unsigned long val,
 				struct netlink_ext_ack *extack)
 {
-	br->multicast_querier_interval = clock_t_to_jiffies(val);
+	br->multicast_ctx.multicast_querier_interval = clock_t_to_jiffies(val);
 	return 0;
 }
 
@@ -652,13 +652,13 @@ static ssize_t multicast_query_interval_show(struct device *d,
 {
 	struct net_bridge *br = to_bridge(d);
 	return sprintf(buf, "%lu\n",
-		       jiffies_to_clock_t(br->multicast_query_interval));
+		       jiffies_to_clock_t(br->multicast_ctx.multicast_query_interval));
 }
 
 static int set_query_interval(struct net_bridge *br, unsigned long val,
 			      struct netlink_ext_ack *extack)
 {
-	br->multicast_query_interval = clock_t_to_jiffies(val);
+	br->multicast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
 	return 0;
 }
 
@@ -676,13 +676,13 @@ static ssize_t multicast_query_response_interval_show(
 	struct net_bridge *br = to_bridge(d);
 	return sprintf(
 		buf, "%lu\n",
-		jiffies_to_clock_t(br->multicast_query_response_interval));
+		jiffies_to_clock_t(br->multicast_ctx.multicast_query_response_interval));
 }
 
 static int set_query_response_interval(struct net_bridge *br, unsigned long val,
 				       struct netlink_ext_ack *extack)
 {
-	br->multicast_query_response_interval = clock_t_to_jiffies(val);
+	br->multicast_ctx.multicast_query_response_interval = clock_t_to_jiffies(val);
 	return 0;
 }
 
@@ -700,13 +700,13 @@ static ssize_t multicast_startup_query_interval_show(
 	struct net_bridge *br = to_bridge(d);
 	return sprintf(
 		buf, "%lu\n",
-		jiffies_to_clock_t(br->multicast_startup_query_interval));
+		jiffies_to_clock_t(br->multicast_ctx.multicast_startup_query_interval));
 }
 
 static int set_startup_query_interval(struct net_bridge *br, unsigned long val,
 				      struct netlink_ext_ack *extack)
 {
-	br->multicast_startup_query_interval = clock_t_to_jiffies(val);
+	br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
 	return 0;
 }
 
@@ -751,7 +751,7 @@ static ssize_t multicast_mld_version_show(struct device *d,
 {
 	struct net_bridge *br = to_bridge(d);
 
-	return sprintf(buf, "%u\n", br->multicast_mld_version);
+	return sprintf(buf, "%u\n", br->multicast_ctx.multicast_mld_version);
 }
 
 static int set_multicast_mld_version(struct net_bridge *br, unsigned long val,
-- 
2.31.1

