Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1D925E667
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgIEIYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgIEIYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:51 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254ABC061249
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e11so8932577wme.0
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yDM53P+IbxEmEjPDFZAbEFCJJYWGTHL9V6aVvjS7PkA=;
        b=Wf8PRGKkq/yyuwFj400qawp+QnDQaJSAZ2GbyuiK8qHQBbPB0XlC1zGii26IkFbY8S
         T5WMnNSpmKCVdd7KsDlotYLPkYftFzjZyQlZkxdUzzjXSr3oEkICL/T6LnyRRoxdOPvH
         bu5ZMlPQt0YVxLC0cZ1iZAocla5NZ9ICHutCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDM53P+IbxEmEjPDFZAbEFCJJYWGTHL9V6aVvjS7PkA=;
        b=tPqNmNtinBMTbN9hTKQFMUsre9sTJoms5e1o9wCmxttX8SXUE2aHepf2cZZqeni7yt
         0kcllfR1616js0VVymJ135/OexGTaB9OGNow90f30DisBsyv7vNp6WEnBNurhUlhQQ6e
         nlTunvZ9UC0FALdW7haKSf8dbbTtX7WjA/Hzhg8+vKOPD9uP25K+j3zq7djszfELD9yW
         l5QCp/2lDThwqAdR6EXkBTPxk3VzqnClcJOnoWMJklI54wtW59McoDtLGUvyFo2Oum+d
         ei5Lx18jyWCWpjMbuMlFJRTMahB22rq/JZpYRJ8y86wdmw9CBWLvqSZDkd3LPXNUwazJ
         zK+A==
X-Gm-Message-State: AOAM5338Orn9HpclFdGk2IbH/6QxOGZL5kqYh15B/BgtCAGjklh+N5OT
        jxAg8CSuJttHh/9dpCuzsskHq1/NAU8+9cGF
X-Google-Smtp-Source: ABdhPJxgW0+DefeCwWvaBxBjd6gWskxTuyltXUtZxCvnt+zCqJQ8t0Qa+BgTzDOI1Ej5dwCY+EJzkg==
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr5478296wmj.26.1599294289290;
        Sat, 05 Sep 2020 01:24:49 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:48 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 06/15] net: bridge: mcast: add support for group query retransmit
Date:   Sat,  5 Sep 2020 11:24:01 +0300
Message-Id: <20200905082410.2230253-7-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to be able to retransmit group-specific and group-and-source
specific queries. The new timer takes care of those.

v3: add IPv6 support

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 73 +++++++++++++++++++++++++++++++++------
 net/bridge/br_private.h   |  8 +++++
 2 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 72b32398e279..2f77be9fce9b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -50,6 +50,7 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 					 __be32 group,
 					 __u16 vid,
 					 const unsigned char *src);
+static void br_multicast_port_group_rexmit(struct timer_list *t);
 
 static void __del_port_router(struct net_bridge_port *p);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -184,6 +185,7 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	rcu_assign_pointer(*pp, pg->next);
 	hlist_del_init(&pg->mglist);
 	del_timer(&pg->timer);
+	del_timer(&pg->rexmit_timer);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent);
 	br_mdb_notify(br->dev, pg->port, &pg->addr, RTM_DELMDB, pg->flags);
@@ -237,7 +239,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 						    struct net_bridge_port_group *pg,
 						    __be32 ip_dst, __be32 group,
 						    bool with_srcs, bool over_lmqt,
-						    u8 sflag, u8 *igmp_type)
+						    u8 sflag, u8 *igmp_type,
+						    bool *need_rexmit)
 {
 	struct net_bridge_port *p = pg ? pg->port : NULL;
 	struct net_bridge_group_src *ent;
@@ -352,6 +355,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 			    ent->src_query_rexmit_cnt > 0) {
 				ihv3->srcs[lmqt_srcs++] = ent->addr.u.ip4;
 				ent->src_query_rexmit_cnt--;
+				if (need_rexmit && ent->src_query_rexmit_cnt)
+					*need_rexmit = true;
 			}
 		}
 		if (WARN_ON(lmqt_srcs != ntohs(ihv3->nsrcs))) {
@@ -380,7 +385,8 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 						    const struct in6_addr *ip6_dst,
 						    const struct in6_addr *group,
 						    bool with_srcs, bool over_llqt,
-						    u8 sflag, u8 *igmp_type)
+						    u8 sflag, u8 *igmp_type,
+						    bool *need_rexmit)
 {
 	struct net_bridge_port *p = pg ? pg->port : NULL;
 	struct net_bridge_group_src *ent;
@@ -510,6 +516,8 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 			    ent->src_query_rexmit_cnt > 0) {
 				mld2q->mld2q_srcs[llqt_srcs++] = ent->addr.u.ip6;
 				ent->src_query_rexmit_cnt--;
+				if (need_rexmit && ent->src_query_rexmit_cnt)
+					*need_rexmit = true;
 			}
 		}
 		if (WARN_ON(llqt_srcs != ntohs(mld2q->mld2q_nsrcs))) {
@@ -540,7 +548,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 						struct br_ip *ip_dst,
 						struct br_ip *group,
 						bool with_srcs, bool over_lmqt,
-						u8 sflag, u8 *igmp_type)
+						u8 sflag, u8 *igmp_type,
+						bool *need_rexmit)
 {
 	__be32 ip4_dst;
 
@@ -550,7 +559,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 		return br_ip4_multicast_alloc_query(br, pg,
 						    ip4_dst, group->u.ip4,
 						    with_srcs, over_lmqt,
-						    sflag, igmp_type);
+						    sflag, igmp_type,
+						    need_rexmit);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6): {
 		struct in6_addr ip6_dst;
@@ -564,7 +574,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 		return br_ip6_multicast_alloc_query(br, pg,
 						    &ip6_dst, &group->u.ip6,
 						    with_srcs, over_lmqt,
-						    sflag, igmp_type);
+						    sflag, igmp_type,
+						    need_rexmit);
 	}
 #endif
 	}
@@ -708,8 +719,9 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->filter_mode = filter_mode;
 	INIT_HLIST_HEAD(&p->src_list);
 	rcu_assign_pointer(p->next, next);
-	hlist_add_head(&p->mglist, &port->mglist);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
+	timer_setup(&p->rexmit_timer, br_multicast_port_group_rexmit, 0);
+	hlist_add_head(&p->mglist, &port->mglist);
 
 	if (src)
 		memcpy(p->eth_addr, src, ETH_ALEN);
@@ -943,7 +955,8 @@ static void __br_multicast_send_query(struct net_bridge *br,
 				      struct br_ip *ip_dst,
 				      struct br_ip *group,
 				      bool with_srcs,
-				      u8 sflag)
+				      u8 sflag,
+				      bool *need_rexmit)
 {
 	bool over_lmqt = !!sflag;
 	struct sk_buff *skb;
@@ -951,7 +964,8 @@ static void __br_multicast_send_query(struct net_bridge *br,
 
 again_under_lmqt:
 	skb = br_multicast_alloc_query(br, pg, ip_dst, group, with_srcs,
-				       over_lmqt, sflag, &igmp_type);
+				       over_lmqt, sflag, &igmp_type,
+				       need_rexmit);
 	if (!skb)
 		return;
 
@@ -1004,7 +1018,8 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0);
+	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0,
+				  NULL);
 
 	time = jiffies;
 	time += own_query->startup_sent < br->multicast_startup_query_count ?
@@ -1049,6 +1064,44 @@ static void br_ip6_multicast_port_query_expired(struct timer_list *t)
 }
 #endif
 
+static void br_multicast_port_group_rexmit(struct timer_list *t)
+{
+	struct net_bridge_port_group *pg = from_timer(pg, t, rexmit_timer);
+	struct bridge_mcast_other_query *other_query = NULL;
+	struct net_bridge *br = pg->port->br;
+	bool need_rexmit = false;
+
+	spin_lock(&br->multicast_lock);
+	if (!netif_running(br->dev) || hlist_unhashed(&pg->mglist) ||
+	    !br_opt_get(br, BROPT_MULTICAST_ENABLED) ||
+	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
+		goto out;
+
+	if (pg->addr.proto == htons(ETH_P_IP))
+		other_query = &br->ip4_other_query;
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		other_query = &br->ip6_other_query;
+#endif
+
+	if (!other_query || timer_pending(&other_query->timer))
+		goto out;
+
+	if (pg->grp_query_rexmit_cnt) {
+		pg->grp_query_rexmit_cnt--;
+		__br_multicast_send_query(br, pg->port, pg, &pg->addr,
+					  &pg->addr, false, 1, NULL);
+	}
+	__br_multicast_send_query(br, pg->port, pg, &pg->addr,
+				  &pg->addr, true, 0, &need_rexmit);
+
+	if (pg->grp_query_rexmit_cnt || need_rexmit)
+		mod_timer(&pg->rexmit_timer, jiffies +
+					     br->multicast_last_member_interval);
+out:
+	spin_unlock(&br->multicast_lock);
+}
+
 static void br_mc_disabled_update(struct net_device *dev, bool value)
 {
 	struct switchdev_attr attr = {
@@ -1657,7 +1710,7 @@ br_multicast_leave_group(struct net_bridge *br,
 
 	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
 		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
-					  false, 0);
+					  false, 0, NULL);
 
 		time = jiffies + br->multicast_last_member_count *
 				 br->multicast_last_member_interval;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e0632721b1ef..da8df273dd4a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -240,10 +240,12 @@ struct net_bridge_port_group {
 	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
 	unsigned char			flags;
 	unsigned char			filter_mode;
+	unsigned char			grp_query_rexmit_cnt;
 
 	struct hlist_head		src_list;
 	unsigned int			src_ents;
 	struct timer_list		timer;
+	struct timer_list		rexmit_timer;
 	struct hlist_node		mglist;
 
 	struct rcu_head			rcu;
@@ -868,6 +870,12 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 {
 	return BR_INPUT_SKB_CB(skb)->igmp;
 }
+
+static inline unsigned long br_multicast_lmqt(const struct net_bridge *br)
+{
+	return br->multicast_last_member_interval *
+	       br->multicast_last_member_count;
+}
 #else
 static inline int br_multicast_rcv(struct net_bridge *br,
 				   struct net_bridge_port *port,
-- 
2.25.4

