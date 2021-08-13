Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED353EB738
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbhHMPAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240971AbhHMPAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:37 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FF2C0617AD
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id bo19so15823086edb.9
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FN9bsA+Eg2ECxJL1uXwylxno30lT93fyRwIY5gAdjeo=;
        b=gOOI83f3wWleiK+0iaUFh5UiS3UqKZmdVqcCgZKcsoKcD/50xx9YfF5ObxJQbvDZ71
         qiEXTCYQg+sBRxvvqHK/JBGIWa0JcYNVOYrOdbYMYNgngmft/RcjG5LcZsfm1o+1Dna5
         UlyS8gmYq+8KTipY0rkPZr1gIWd4+bP5YYIQQPf4rJVqhcS0Kt56qUROKshwLaVht88A
         z9Zr6G4Z4pTxKFaq+gjl1bg02H3BMk4V0n4O4qMqwMFa3+7D9jurp/EX998HkIm9ycKt
         CO7wD9SqGdqIU/LAfJNSth2Bw6JtEieJUw8KZhdjyJiHTGGm7hchEdaKxgIFQpD/MTtS
         WVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FN9bsA+Eg2ECxJL1uXwylxno30lT93fyRwIY5gAdjeo=;
        b=detO/GWDXEA31Q44Iz2lVuCbVF5C5YyEmreRqHdV+swv3LgZLICiBjPWk96xgEK9ug
         f709ZBhMVWLo+6HvZCkvoxN98DpIJqMOznJ5yfu5JTnpDM8TYQ5Q5Dzv/kBWcf8/8KyR
         /TldCj2CtfHZehhQ7eeuixqDvwQh8vZvqi5cBd79EWI8Dig1uNsZA+LYTRW3cH/yb38S
         z8qZUlb6dKU8oLDZeejgXZ6Fz86z8ayiKFVIALSjlWmgY71GjighMbKm5Bzc+E3tQcIH
         l+IuFMGoZAHKzDxBGMKAhFArVliykJCWDFyL9zcgZyGbSHwTBwKarmFiY75yScqJZ5v2
         VYLA==
X-Gm-Message-State: AOAM530HDqSHzHyi1u7lIxOA9HbAj+GgJYWQ8Nfn2N2Z+l6I1wviTH/A
        IRtldytEo1vXD7Y1qyyxESTgTGBsLKp7E5Io
X-Google-Smtp-Source: ABdhPJx7zqIK4BTXy/Er8+AIhsoyk8koZFQICVrtB53UpwKoJKZEyOa+QgqWNLTG+7DjZtcIkPcqbg==
X-Received: by 2002:aa7:d815:: with SMTP id v21mr3611094edq.262.1628866809305;
        Fri, 13 Aug 2021 08:00:09 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:08 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/6] net: bridge: mcast: record querier port device ifindex instead of pointer
Date:   Fri, 13 Aug 2021 17:59:57 +0300
Message-Id: <20210813150002.673579-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
References: <20210813150002.673579-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Currently when a querier port is detected its net_bridge_port pointer is
recorded, but it's used only for comparisons so it's fine to have stale
pointer, in order to dereference and use the port pointer a proper
accounting of its usage must be implemented adding unnecessary
complexity. To solve the problem we can just store the netdevice ifindex
instead of the port pointer and retrieve the bridge port. It is a best
effort and the device needs to be validated that is still part of that
bridge before use, but that is small price to pay for avoiding querier
reference counting for each port/vlan.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 19 ++++++++++++-------
 net/bridge/br_private.h   |  2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index df6bf6a237aa..853b947edf87 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2850,7 +2850,8 @@ static bool br_ip4_multicast_select_querier(struct net_bridge_mcast *brmctx,
 	brmctx->ip4_querier.addr.src.ip4 = saddr;
 
 	/* update protected by general multicast_lock by caller */
-	rcu_assign_pointer(brmctx->ip4_querier.port, port);
+	if (port)
+		brmctx->ip4_querier.port_ifidx = port->dev->ifindex;
 
 	return true;
 }
@@ -2875,7 +2876,8 @@ static bool br_ip6_multicast_select_querier(struct net_bridge_mcast *brmctx,
 	brmctx->ip6_querier.addr.src.ip6 = *saddr;
 
 	/* update protected by general multicast_lock by caller */
-	rcu_assign_pointer(brmctx->ip6_querier.port, port);
+	if (port)
+		brmctx->ip6_querier.port_ifidx = port->dev->ifindex;
 
 	return true;
 }
@@ -3675,7 +3677,7 @@ static void br_multicast_query_expired(struct net_bridge_mcast *brmctx,
 	if (query->startup_sent < brmctx->multicast_startup_query_count)
 		query->startup_sent++;
 
-	RCU_INIT_POINTER(querier->port, NULL);
+	querier->port_ifidx = 0;
 	br_multicast_send_query(brmctx, NULL, query);
 out:
 	spin_unlock(&brmctx->br->multicast_lock);
@@ -3732,12 +3734,12 @@ void br_multicast_ctx_init(struct net_bridge *br,
 	brmctx->multicast_membership_interval = 260 * HZ;
 
 	brmctx->ip4_other_query.delay_time = 0;
-	brmctx->ip4_querier.port = NULL;
+	brmctx->ip4_querier.port_ifidx = 0;
 	brmctx->multicast_igmp_version = 2;
 #if IS_ENABLED(CONFIG_IPV6)
 	brmctx->multicast_mld_version = 1;
 	brmctx->ip6_other_query.delay_time = 0;
-	brmctx->ip6_querier.port = NULL;
+	brmctx->ip6_querier.port_ifidx = 0;
 #endif
 
 	timer_setup(&brmctx->ip4_mc_router_timer,
@@ -4479,6 +4481,7 @@ bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto)
 	struct net_bridge *br;
 	struct net_bridge_port *port;
 	bool ret = false;
+	int port_ifidx;
 
 	rcu_read_lock();
 	if (!netif_is_bridge_port(dev))
@@ -4493,14 +4496,16 @@ bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto)
 
 	switch (proto) {
 	case ETH_P_IP:
+		port_ifidx = brmctx->ip4_querier.port_ifidx;
 		if (!timer_pending(&brmctx->ip4_other_query.timer) ||
-		    rcu_dereference(brmctx->ip4_querier.port) == port)
+		    port_ifidx == port->dev->ifindex)
 			goto unlock;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case ETH_P_IPV6:
+		port_ifidx = brmctx->ip6_querier.port_ifidx;
 		if (!timer_pending(&brmctx->ip6_other_query.timer) ||
-		    rcu_dereference(brmctx->ip6_querier.port) == port)
+		    port_ifidx == port->dev->ifindex)
 			goto unlock;
 		break;
 #endif
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 32c218aa3f36..b92fab5ae0fb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -81,7 +81,7 @@ struct bridge_mcast_other_query {
 /* selected querier */
 struct bridge_mcast_querier {
 	struct br_ip addr;
-	struct net_bridge_port __rcu	*port;
+	int port_ifidx;
 };
 
 /* IGMP/MLD statistics */
-- 
2.31.1

