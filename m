Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697384DE1A
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfFUAhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:37:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41351 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFUAhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:37:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id m7so2085166pls.8
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6K7yZXHFPP2wKshtf+TUy7FQS3tnc0HHzK+82UP50PA=;
        b=jO7g/qIeQKgcHMguGL7wze8XyjfVwYcuchrgBNxwqIqgCVZXdcctvmOl0zK+x4Vt4S
         VIMCF2v45Led4WPDGmdLQkHxCOqqtUXYxaMMGVBRB9pQwnIEGQm2ogjcxqBM7NsiH5VP
         P9Ypfm7Hh3f+STmr8mxyBv2kpekhY3Hq27xY30aZxRVkgta84m1C00/COwXx/oeKnG0I
         /+I4LyC76gOIergOmu+3TSIYt7eTWKRA6aW47gmqm4iTfb7uTOvPbaaFE8MMilAzZA8U
         kzJwzafvJ4V5y/J/418OVu4KPwih3jE8LM9HmHxmWKW0PECW1ql5EiJHFPxL7AyFv+43
         2soA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6K7yZXHFPP2wKshtf+TUy7FQS3tnc0HHzK+82UP50PA=;
        b=mDz9bGXcOe2cCsbCBWfmComuaBan53gBAcuAHRyw2xn37AMp70xQsL/GypSA9t7xor
         e9ORvrA5eFpsca6zbhTcoP93c0GeM8a8S9Zb2u9XB8IFMogTe4Z2rHi6SBTlAirmcIOQ
         8OMClyFXq/INiJGmd/3sSjlUYs9PXJasla3GDlOg+h/ucc1LYhVp2ntAla8Q6KZT/qBW
         yvfdAYvwu7O3NBPe0xkJZULkchoTVQtgMPCPM2vLwE9fS3xBF03td2QcFHpefH7At9qr
         q7blXQwukPTXt9OEiWrlGFzqJMDJ4A1uCrKFGJz7ZYgykVeWhTPHM1szYnd6MYEw4X7d
         GzLQ==
X-Gm-Message-State: APjAAAU7H7DYOcS5dtC3JVBFyqyRD0TPDMd/lKR8v5VDuQXwpFRMswoo
        MmPLy2bbwMrjK2OmIecEbpQ=
X-Google-Smtp-Source: APXvYqzRK373TtnUVWmCWzxXE9e0HXd4rNwzMi/sLZpM7KJsHkschpnrslAorC/pY47WL5O1XklW1A==
X-Received: by 2002:a17:902:aa03:: with SMTP id be3mr50033363plb.240.1561077422372;
        Thu, 20 Jun 2019 17:37:02 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id 2sm588206pff.174.2019.06.20.17.37.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:37:01 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH v3 net-next 1/5] ipv6: introduce RT6_LOOKUP_F_DST_NOREF flag in ip6_pol_route()
Date:   Thu, 20 Jun 2019 17:36:37 -0700
Message-Id: <20190621003641.168591-2-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
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

