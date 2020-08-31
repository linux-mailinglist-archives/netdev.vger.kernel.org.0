Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B7257BCA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgHaPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgHaPKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:09 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CDBC0619C2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:01 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id m6so4100301wrn.0
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MDO+Yqa9RKjI5KhYhFk8z38TVcFDWxcJklAwlggn+X0=;
        b=PUBLhlBho/8ZQUVe3ytUg5QfH1H+J/q9lopcEm/+lf40VXKZkoP1GHDj7IwP14KaMk
         t21pMK1+ZRmQA5FXutvFvwYaWTIyoFggWN0kCThxDuTyi6Hdkx/3MjLZ4bRU/jy2Cskd
         oUr3cBpgwm4M2r0YJJ6MJNyNlz+6wYEGPup6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MDO+Yqa9RKjI5KhYhFk8z38TVcFDWxcJklAwlggn+X0=;
        b=AJEV7SoSyBcrtDOZcGy8e/P2IacLtfhB4O5QW4Fl5OlBmotOdIaqFxjqYh69qdLsZA
         BVtfQy9DGiOi46t/uEoG8pUijRI3FQaAcv8OriR48G3qzjeE2OO8NBm6xKNAL08mYRlz
         263sFe6aXogUo0NxhHHtMN71FZ8mjzmicIASpqcrL4B95xkd+RYlTN/6iRso7IEmHV9A
         Brv7nUyTZ3KboJbvyL3dwulshBnDXavqZQvDg8CRHNUZXtNoz0fOBAittjx+gvkrww9P
         j5ZlsXLQ0WCz41yQhk7swroF/UeWnrJUESW8cKDAZMqA2UzoOBS1Z/PYBd+c8JCRaPJp
         da1w==
X-Gm-Message-State: AOAM5324j3JU/PGiQErN45k9WzMNCNn4YMg+VvLgGqwRxIh1lcChv5LS
        U1QKyVdZ3pAI7GKbQiVIuMoluo4jHbCFZ/Ss
X-Google-Smtp-Source: ABdhPJwnXyvV3qy0OZk9Isd3beHzktIFw6YXVmZsOtIdDO8FKnlGPvGXCMtxMbk6cojdc9U8gTKaBw==
X-Received: by 2002:adf:c552:: with SMTP id s18mr1994091wrf.209.1598886599584;
        Mon, 31 Aug 2020 08:09:59 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:09:58 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 06/15] net: bridge: mcast: add support for group query retransmit
Date:   Mon, 31 Aug 2020 18:08:36 +0300
Message-Id: <20200831150845.1062447-7-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to be able to retransmit group-specific and group-and-source
specific queries. The new timer takes care of those.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 65 ++++++++++++++++++++++++++++++++++-----
 net/bridge/br_private.h   |  8 +++++
 2 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index fc9f0584edf2..0f47882efdef 100644
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
@@ -493,7 +498,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 						struct br_ip *ip_dst,
 						struct br_ip *group,
 						bool with_srcs, bool over_lmqt,
-						u8 sflag, u8 *igmp_type)
+						u8 sflag, u8 *igmp_type,
+						bool *need_rexmit)
 {
 	__be32 ip4_dst;
 
@@ -503,7 +509,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 		return br_ip4_multicast_alloc_query(br, pg,
 						    ip4_dst, group->u.ip4,
 						    with_srcs, over_lmqt,
-						    sflag, igmp_type);
+						    sflag, igmp_type,
+						    need_rexmit);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		return br_ip6_multicast_alloc_query(br, &group->u.ip6,
@@ -647,8 +654,9 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 		p->filter_mode = MCAST_EXCLUDE;
 	INIT_HLIST_HEAD(&p->src_list);
 	rcu_assign_pointer(p->next, next);
-	hlist_add_head(&p->mglist, &port->mglist);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
+	timer_setup(&p->rexmit_timer, br_multicast_port_group_rexmit, 0);
+	hlist_add_head(&p->mglist, &port->mglist);
 
 	if (src)
 		memcpy(p->eth_addr, src, ETH_ALEN);
@@ -875,7 +883,8 @@ static void __br_multicast_send_query(struct net_bridge *br,
 				      struct br_ip *ip_dst,
 				      struct br_ip *group,
 				      bool with_srcs,
-				      u8 sflag)
+				      u8 sflag,
+				      bool *need_rexmit)
 {
 	bool over_lmqt = !!sflag;
 	struct sk_buff *skb;
@@ -883,7 +892,8 @@ static void __br_multicast_send_query(struct net_bridge *br,
 
 again_under_lmqt:
 	skb = br_multicast_alloc_query(br, pg, ip_dst, group, with_srcs,
-				       over_lmqt, sflag, &igmp_type);
+				       over_lmqt, sflag, &igmp_type,
+				       need_rexmit);
 	if (!skb)
 		return;
 
@@ -936,7 +946,8 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0);
+	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0,
+				  NULL);
 
 	time = jiffies;
 	time += own_query->startup_sent < br->multicast_startup_query_count ?
@@ -981,6 +992,44 @@ static void br_ip6_multicast_port_query_expired(struct timer_list *t)
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
@@ -1589,7 +1638,7 @@ br_multicast_leave_group(struct net_bridge *br,
 
 	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
 		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
-					  false, 0);
+					  false, 0, NULL);
 
 		time = jiffies + br->multicast_last_member_count *
 				 br->multicast_last_member_interval;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a82d0230f552..86fe45146a44 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -239,10 +239,12 @@ struct net_bridge_port_group {
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
@@ -866,6 +868,12 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
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

