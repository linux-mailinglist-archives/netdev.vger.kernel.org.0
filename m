Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917764A9C5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfFRS0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:26:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45336 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRS0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:26:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so8117641pga.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6K7yZXHFPP2wKshtf+TUy7FQS3tnc0HHzK+82UP50PA=;
        b=lqXtaVqskpXJrCMMHLnWkZUbZYWXxP/ZEpyJye3+ZWyEXBNxtYuS33hfcfXv/srit0
         gc0SGMRR4YGUVUWjtYm+Mz/ITnaT1Rwz1nHzJaMsBAADHLHv44cIeXkfgmfPG+Rx7y0K
         WMr42NYOAt59OjtezAFzbq1gRHczcgMh0QgiKwiQXcUVQV8BxhRLGlYcYRjo0fHoJM85
         8aQs3NyfvzNBS82J3TQ5o9vbytZpuC1ceFPPx4jbRz+EMo5xnAG7yy5eHnxQNHm/ODJp
         bZLKF2u7w5avMYrh0uqlteEv2kn9soEXcGYW6A2Rmwm/hBSa7ogJ6Q6e4y2oQKJwpqvs
         +YsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6K7yZXHFPP2wKshtf+TUy7FQS3tnc0HHzK+82UP50PA=;
        b=kel/dNE1MW/nihByJ+HAMRtCrP9FxCxIQE6HTS2Q4Ti0YMMm/pqTMs4OqcsjGoLpWV
         50tanSf4wV54ggLJry7y8H5b6nE4V4h0/ZeN8xTusuoCmxewauSMalwdbHKwx/AyC7KU
         HORFWtlaArR4BG4S9C38hsatGnC923e/CSLvBWOv4NZJakkPLTnn1SfB7VIY3P0GooSu
         DYRzb8jiVvw5goLUdWBOw9RAvkJ9gtybLbriFuXvSyXrk+lK4BaIwA17JwvC7J8Br1hD
         7K7oFjF8sQzbstnAy3JsEbo48kRXuywoiDrtvw5zSf4Y/cKZeRp0d7ppdRH7RAiJtjss
         C82w==
X-Gm-Message-State: APjAAAWh7k6yyztoJZC7e0tY5SPBk7qLs+LRK0koQkpcxXANo9CKwV4j
        DQRQAImRtmcaqc6qM4i7uYg=
X-Google-Smtp-Source: APXvYqy1io5jxM08SceGiB7bjhfzxw68/F708FZr9qQWj47fSLXarv0JIBeakOfoyQOjEbPMtNMjzg==
X-Received: by 2002:a63:2a0f:: with SMTP id q15mr3979356pgq.163.1560882379120;
        Tue, 18 Jun 2019 11:26:19 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id h6sm2845859pjs.2.2019.06.18.11.26.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:26:18 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 1/5] ipv6: introduce RT6_LOOKUP_F_DST_NOREF flag in ip6_pol_route()
Date:   Tue, 18 Jun 2019 11:25:39 -0700
Message-Id: <20190618182543.65477-2-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190618182543.65477-1-tracywwnj@gmail.com>
References: <20190618182543.65477-1-tracywwnj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

This new flag is to instruct the route lookup function to not take
refcnt on the dst entry. The user which does route lookup with this flag
must properly use rcu protection.
ip6_pol_route() is the major route lookup function for both tx and rx
path.
In this function:
Do not take refcnt on dst if RT6_LOOKUP_F_DST_NOREF flag is set, and
directly return the route entry. The caller should be holding rcu lock
when using this flag, and decide whether to take refcnt or not.

One note on the dst cache in the uncached_list:
As uncached_list does not consume refcnt, one refcnt is always returned
back to the caller even if RT6_LOOKUP_F_DST_NOREF flag is set.
Uncached dst is only possible in the output path. So in such call path,
caller MUST check if the dst is in the uncached_list before assuming
that there is no refcnt taken on the returned dst.

Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 include/net/ip6_route.h |  1 +
 net/ipv6/route.c        | 73 +++++++++++++++++------------------------
 2 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 7375a165fd98..82bced2fc1e3 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -36,6 +36,7 @@ struct route_info {
 #define RT6_LOOKUP_F_SRCPREF_PUBLIC	0x00000010
 #define RT6_LOOKUP_F_SRCPREF_COA	0x00000020
 #define RT6_LOOKUP_F_IGNORE_LINKSTATE	0x00000040
+#define RT6_LOOKUP_F_DST_NOREF		0x00000080
 
 /* We do not (yet ?) support IPv6 jumbograms (RFC 2675)
  * Unlike IPv4, hdr->seg_len doesn't include the IPv6 header
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c4d285fe0adc..9dcbc56e4151 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1391,9 +1391,6 @@ static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 
 	pcpu_rt = this_cpu_read(*res->nh->rt6i_pcpu);
 
-	if (pcpu_rt)
-		ip6_hold_safe(NULL, &pcpu_rt);
-
 	return pcpu_rt;
 }
 
@@ -1403,12 +1400,9 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
 	struct rt6_info *pcpu_rt, *prev, **p;
 
 	pcpu_rt = ip6_rt_pcpu_alloc(res);
-	if (!pcpu_rt) {
-		dst_hold(&net->ipv6.ip6_null_entry->dst);
-		return net->ipv6.ip6_null_entry;
-	}
+	if (!pcpu_rt)
+		return NULL;
 
-	dst_hold(&pcpu_rt->dst);
 	p = this_cpu_ptr(res->nh->rt6i_pcpu);
 	prev = cmpxchg(p, NULL, pcpu_rt);
 	BUG_ON(prev);
@@ -2189,9 +2183,12 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 			       const struct sk_buff *skb, int flags)
 {
 	struct fib6_result res = {};
-	struct rt6_info *rt;
+	struct rt6_info *rt = NULL;
 	int strict = 0;
 
+	WARN_ON_ONCE((flags & RT6_LOOKUP_F_DST_NOREF) &&
+		     !rcu_read_lock_held());
+
 	strict |= flags & RT6_LOOKUP_F_IFACE;
 	strict |= flags & RT6_LOOKUP_F_IGNORE_LINKSTATE;
 	if (net->ipv6.devconf_all->forwarding == 0)
@@ -2200,23 +2197,15 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 	rcu_read_lock();
 
 	fib6_table_lookup(net, table, oif, fl6, &res, strict);
-	if (res.f6i == net->ipv6.fib6_null_entry) {
-		rt = net->ipv6.ip6_null_entry;
-		rcu_read_unlock();
-		dst_hold(&rt->dst);
-		return rt;
-	}
+	if (res.f6i == net->ipv6.fib6_null_entry)
+		goto out;
 
 	fib6_select_path(net, &res, fl6, oif, false, skb, strict);
 
 	/*Search through exception table */
 	rt = rt6_find_cached_rt(&res, &fl6->daddr, &fl6->saddr);
 	if (rt) {
-		if (ip6_hold_safe(net, &rt))
-			dst_use_noref(&rt->dst, jiffies);
-
-		rcu_read_unlock();
-		return rt;
+		goto out;
 	} else if (unlikely((fl6->flowi6_flags & FLOWI_FLAG_KNOWN_NH) &&
 			    !res.nh->fib_nh_gw_family)) {
 		/* Create a RTF_CACHE clone which will not be
@@ -2224,40 +2213,38 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 		 * the daddr in the skb during the neighbor look-up is different
 		 * from the fl6->daddr used to look-up route here.
 		 */
-		struct rt6_info *uncached_rt;
+		rt = ip6_rt_cache_alloc(&res, &fl6->daddr, NULL);
 
-		uncached_rt = ip6_rt_cache_alloc(&res, &fl6->daddr, NULL);
-
-		rcu_read_unlock();
-
-		if (uncached_rt) {
-			/* Uncached_rt's refcnt is taken during ip6_rt_cache_alloc()
-			 * No need for another dst_hold()
+		if (rt) {
+			/* 1 refcnt is taken during ip6_rt_cache_alloc().
+			 * As rt6_uncached_list_add() does not consume refcnt,
+			 * this refcnt is always returned to the caller even
+			 * if caller sets RT6_LOOKUP_F_DST_NOREF flag.
 			 */
-			rt6_uncached_list_add(uncached_rt);
+			rt6_uncached_list_add(rt);
 			atomic_inc(&net->ipv6.rt6_stats->fib_rt_uncache);
-		} else {
-			uncached_rt = net->ipv6.ip6_null_entry;
-			dst_hold(&uncached_rt->dst);
-		}
+			rcu_read_unlock();
 
-		return uncached_rt;
+			return rt;
+		}
 	} else {
 		/* Get a percpu copy */
-
-		struct rt6_info *pcpu_rt;
-
 		local_bh_disable();
-		pcpu_rt = rt6_get_pcpu_route(&res);
+		rt = rt6_get_pcpu_route(&res);
 
-		if (!pcpu_rt)
-			pcpu_rt = rt6_make_pcpu_route(net, &res);
+		if (!rt)
+			rt = rt6_make_pcpu_route(net, &res);
 
 		local_bh_enable();
-		rcu_read_unlock();
-
-		return pcpu_rt;
 	}
+out:
+	if (!rt)
+		rt = net->ipv6.ip6_null_entry;
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		ip6_hold_safe(net, &rt);
+	rcu_read_unlock();
+
+	return rt;
 }
 EXPORT_SYMBOL_GPL(ip6_pol_route);
 
-- 
2.22.0.410.gd8fdbe21b5-goog

