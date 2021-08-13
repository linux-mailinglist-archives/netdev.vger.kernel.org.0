Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8F43EB739
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbhHMPAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbhHMPAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:39 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E188C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:12 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w5so18819347ejq.2
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7QgAKJYUvxoxYg9mJpeQeVQQ5R7yHrstaDnglDk7EvQ=;
        b=nI6qDDjVSKbywAXtOttTJ9/5E9FIKjKwR66PBvnyddknXQ/Tjfagl/aPVgKei1Upzh
         knv89ZAOgCHPc/xZqoVj62Qavl+bmQPFP0iETanAPaKXwtG/ImVNAeuhwoHxb4So+sH4
         rkWTK/t+tYqhq1I11pc25h6+1TNBxfdDt2e/++tOJUXd1IMdPiHnzZXNfurvXOyrS9N3
         DAp/JYzIl9ALqNMC02amVqZetrjmaRet/gkltIL1rOWIaLgtdeNdflD/766Kj7HOPmP8
         iObLHm5hD3pbuQY7FziYnTC8RH4Cktk8VJTiqaBxEmyn5FWUC4yGtxiLh8qXVmZ+Wo+l
         JytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7QgAKJYUvxoxYg9mJpeQeVQQ5R7yHrstaDnglDk7EvQ=;
        b=YDUd8g+LSABuIQyzFvRoPyvS3PAE+ErnDqONAuj1gxdJbxMM6JxzdjoAK2UGdrgDfu
         AZXjp72kSyAUiNtTQpxXBDQMRKODDUjYrHBHlaO1u2IiXGaYlsziEFp2+e/ofsamXTxo
         RZ0Ei6Upv5NtscUte1iAQCwZ0iqKDaeYU9/c4kPSvNzan33nQLW/pxjVbOHikcHzi8Ai
         vDtKBqzbIFhJsCNjmrzI0n4hUSe4D86xkEPUBo7Ly6N+seBMugmy5tkXkhSoVDPzj20+
         Ah6jQtVfj5dyq28JPc5ShwithgD6cMMcIQqAU4FKKfZCnMCA6dJbKsZRxxKJRnXCy09e
         oBGA==
X-Gm-Message-State: AOAM5331bwSPJzttGUA5Hmz8pFZfqHICu17MBA6YPtkx+RDphqqjMCzT
        XVzv5mwcMpIuNuuSEdQwZ3MaM+vpHu4ORk4/
X-Google-Smtp-Source: ABdhPJzS4mvyq6sU+Fm45DG8GsS6FAfaavm+HlVGIexLxp9UtLpCYkIVSUKjRmZD2Z43r/xEZFtSUg==
X-Received: by 2002:a17:906:ed1:: with SMTP id u17mr2869259eji.304.1628866810296;
        Fri, 13 Aug 2021 08:00:10 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:09 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/6] net: bridge: mcast: make sure querier port/address updates are consistent
Date:   Fri, 13 Aug 2021 17:59:58 +0300
Message-Id: <20210813150002.673579-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
References: <20210813150002.673579-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Use a sequence counter to make sure port/address updates can be read
consistently without requiring the bridge multicast_lock. We need to
zero out the port and address when the other querier has expired and
we're about to select ourselves as querier. br_multicast_read_querier
will be used later when dumping querier state. Updates are done only
with the multicast spinlock and softirqs disabled, while reads are done
from process context and from softirqs (due to notifications).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 74 ++++++++++++++++++++++++++++-----------
 net/bridge/br_private.h   |  1 +
 2 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 853b947edf87..701cf46b89de 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1659,11 +1659,38 @@ static void __br_multicast_send_query(struct net_bridge_mcast *brmctx,
 	}
 }
 
+static void br_multicast_read_querier(const struct bridge_mcast_querier *querier,
+				      struct bridge_mcast_querier *dest)
+{
+	unsigned int seq;
+
+	memset(dest, 0, sizeof(*dest));
+	do {
+		seq = read_seqcount_begin(&querier->seq);
+		dest->port_ifidx = querier->port_ifidx;
+		memcpy(&dest->addr, &querier->addr, sizeof(struct br_ip));
+	} while (read_seqcount_retry(&querier->seq, seq));
+}
+
+static void br_multicast_update_querier(struct net_bridge_mcast *brmctx,
+					struct bridge_mcast_querier *querier,
+					int ifindex,
+					struct br_ip *saddr)
+{
+	lockdep_assert_held_once(&brmctx->br->multicast_lock);
+
+	write_seqcount_begin(&querier->seq);
+	querier->port_ifidx = ifindex;
+	memcpy(&querier->addr, saddr, sizeof(*saddr));
+	write_seqcount_end(&querier->seq);
+}
+
 static void br_multicast_send_query(struct net_bridge_mcast *brmctx,
 				    struct net_bridge_mcast_port *pmctx,
 				    struct bridge_mcast_own_query *own_query)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
+	struct bridge_mcast_querier *querier;
 	struct br_ip br_group;
 	unsigned long time;
 
@@ -1676,10 +1703,12 @@ static void br_multicast_send_query(struct net_bridge_mcast *brmctx,
 
 	if (pmctx ? (own_query == &pmctx->ip4_own_query) :
 		    (own_query == &brmctx->ip4_own_query)) {
+		querier = &brmctx->ip4_querier;
 		other_query = &brmctx->ip4_other_query;
 		br_group.proto = htons(ETH_P_IP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
+		querier = &brmctx->ip6_querier;
 		other_query = &brmctx->ip6_other_query;
 		br_group.proto = htons(ETH_P_IPV6);
 #endif
@@ -1688,6 +1717,13 @@ static void br_multicast_send_query(struct net_bridge_mcast *brmctx,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
+	/* we're about to select ourselves as querier */
+	if (!pmctx && querier->port_ifidx) {
+		struct br_ip zeroip = {};
+
+		br_multicast_update_querier(brmctx, querier, 0, &zeroip);
+	}
+
 	__br_multicast_send_query(brmctx, pmctx, NULL, NULL, &br_group, false,
 				  0, NULL);
 
@@ -2830,9 +2866,9 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 
 static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
 					    struct net_bridge_mcast_port *pmctx,
-					    __be32 saddr)
+					    struct br_ip *saddr)
 {
-	struct net_bridge_port *port = pmctx ? pmctx->port : NULL;
+	int port_ifidx = pmctx ? pmctx->port->dev->ifindex : 0;
 
 	if (!timer_pending(&brmctx->ip4_own_query.timer) &&
 	    !timer_pending(&brmctx->ip4_other_query.timer))
@@ -2841,17 +2877,14 @@ static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
 	if (!brmctx->ip4_querier.addr.src.ip4)
 		goto update;
 
-	if (ntohl(saddr) <= ntohl(brmctx->ip4_querier.addr.src.ip4))
+	if (ntohl(saddr->src.ip4) <= ntohl(brmctx->ip4_querier.addr.src.ip4))
 		goto update;
 
 	return false;
 
 update:
-	brmctx->ip4_querier.addr.src.ip4 = saddr;
-
-	/* update protected by general multicast_lock by caller */
-	if (port)
-		brmctx->ip4_querier.port_ifidx = port->dev->ifindex;
+	br_multicast_update_querier(brmctx, &brmctx->ip4_querier, port_ifidx,
+				    saddr);
 
 	return true;
 }
@@ -2859,25 +2892,23 @@ static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
 #if IS_ENABLED(CONFIG_IPV6)
 static bool br_ip6_multicast_select_querier(struct net_bridge_mcast *brmctx,
 					    struct net_bridge_mcast_port *pmctx,
-					    struct in6_addr *saddr)
+					    struct br_ip *saddr)
 {
-	struct net_bridge_port *port = pmctx ? pmctx->port : NULL;
+	int port_ifidx = pmctx ? pmctx->port->dev->ifindex : 0;
 
 	if (!timer_pending(&brmctx->ip6_own_query.timer) &&
 	    !timer_pending(&brmctx->ip6_other_query.timer))
 		goto update;
 
-	if (ipv6_addr_cmp(saddr, &brmctx->ip6_querier.addr.src.ip6) <= 0)
+	if (ipv6_addr_cmp(&saddr->src.ip6,
+			  &brmctx->ip6_querier.addr.src.ip6) <= 0)
 		goto update;
 
 	return false;
 
 update:
-	brmctx->ip6_querier.addr.src.ip6 = *saddr;
-
-	/* update protected by general multicast_lock by caller */
-	if (port)
-		brmctx->ip6_querier.port_ifidx = port->dev->ifindex;
+	br_multicast_update_querier(brmctx, &brmctx->ip6_querier, port_ifidx,
+				    saddr);
 
 	return true;
 }
@@ -3084,7 +3115,7 @@ br_ip4_multicast_query_received(struct net_bridge_mcast *brmctx,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip4_multicast_select_querier(brmctx, pmctx, saddr->src.ip4))
+	if (!br_ip4_multicast_select_querier(brmctx, pmctx, saddr))
 		return;
 
 	br_multicast_update_query_timer(brmctx, query, max_delay);
@@ -3099,7 +3130,7 @@ br_ip6_multicast_query_received(struct net_bridge_mcast *brmctx,
 				struct br_ip *saddr,
 				unsigned long max_delay)
 {
-	if (!br_ip6_multicast_select_querier(brmctx, pmctx, &saddr->src.ip6))
+	if (!br_ip6_multicast_select_querier(brmctx, pmctx, saddr))
 		return;
 
 	br_multicast_update_query_timer(brmctx, query, max_delay);
@@ -3119,7 +3150,7 @@ static void br_ip4_multicast_query(struct net_bridge_mcast *brmctx,
 	struct igmpv3_query *ih3;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
-	struct br_ip saddr;
+	struct br_ip saddr = {};
 	unsigned long max_delay;
 	unsigned long now = jiffies;
 	__be32 group;
@@ -3199,7 +3230,7 @@ static int br_ip6_multicast_query(struct net_bridge_mcast *brmctx,
 	struct mld2_query *mld2q;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
-	struct br_ip saddr;
+	struct br_ip saddr = {};
 	unsigned long max_delay;
 	unsigned long now = jiffies;
 	unsigned int offset = skb_transport_offset(skb);
@@ -3677,7 +3708,6 @@ static void br_multicast_query_expired(struct net_bridge_mcast *brmctx,
 	if (query->startup_sent < brmctx->multicast_startup_query_count)
 		query->startup_sent++;
 
-	querier->port_ifidx = 0;
 	br_multicast_send_query(brmctx, NULL, query);
 out:
 	spin_unlock(&brmctx->br->multicast_lock);
@@ -3735,11 +3765,13 @@ void br_multicast_ctx_init(struct net_bridge *br,
 
 	brmctx->ip4_other_query.delay_time = 0;
 	brmctx->ip4_querier.port_ifidx = 0;
+	seqcount_init(&brmctx->ip4_querier.seq);
 	brmctx->multicast_igmp_version = 2;
 #if IS_ENABLED(CONFIG_IPV6)
 	brmctx->multicast_mld_version = 1;
 	brmctx->ip6_other_query.delay_time = 0;
 	brmctx->ip6_querier.port_ifidx = 0;
+	seqcount_init(&brmctx->ip6_querier.seq);
 #endif
 
 	timer_setup(&brmctx->ip4_mc_router_timer,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b92fab5ae0fb..6ca9519f18a3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -82,6 +82,7 @@ struct bridge_mcast_other_query {
 struct bridge_mcast_querier {
 	struct br_ip addr;
 	int port_ifidx;
+	seqcount_t seq;
 };
 
 /* IGMP/MLD statistics */
-- 
2.31.1

