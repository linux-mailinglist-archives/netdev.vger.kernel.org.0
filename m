Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9553020576C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbgFWQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732174AbgFWQmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:42:42 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83B1C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:42:42 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w27so2114941qkw.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EYMTqcYPNSd1+dm5Nyu6dJjrXx/FGaIaL0ZjwplPIjQ=;
        b=DyxplA2Cgjtr45kDeFCptHg1Qf0Sg76CvzdvQ6KAbg5YBNa4V11HEgZDqgW0Ppv6Yb
         zzU1cxMT/3p2Dn3R3zPMWpYBDF3zzPRyQOz7f78kzeuUwnZrdD7yYXfw1WRjWVhBcPD6
         s+L5Pk/e+tj/QBXqqMlM2LUGnrliz0WDjlUOhJeVtfMkVgy+t4j6u7KpoipSxQzOAqKM
         SCdnP40EoROcurdIVdqQHArMDKvuQJ/D27gVglHgMmJISWlSPsAI1U3dJm0yT5Fd5h+t
         3tp51cA8P4EGnlOpsf6ZY0niMuWVbmNLjHoEI39Bol5lvK8nD4TKblIHTW081ifgMWcm
         2jvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EYMTqcYPNSd1+dm5Nyu6dJjrXx/FGaIaL0ZjwplPIjQ=;
        b=Vrvfj3AHY+nsW3YBkiszQ7wH/E1VSRLTJDxwmsrDvcCt6rVq7X7wGqRW0kIQ+Sl9iy
         wWP5cfSJzm+J/wMSMGNS0iznRnUC651/WGAg0hJl+hTblM/xK5qeBbUVyyHEV2eRLhL2
         eKnfIWSoX9jrRbEyHHs0l2dMH9s7i2pWVVDcv8VPEWdbIe/PKBFz3Z0tkiftXLYg/Ngr
         mkvK3pmbPSP9rz5Opd39q7UNfBoKNwzs1/eaH0pQe+ri4Rs/B0Vpsz6jCYD7FSQ319KG
         od2hPNolpkZNNNvtRDGQd/4uoj20PbCgE3qyDNtdPcaDEL/Jvl/EDv5Q4y4Hk75HujxZ
         0tIQ==
X-Gm-Message-State: AOAM533k+q+aqhSvYrdmPFXzQPubUZGkf8QW4rRR3XeaSyC/TWN3/SpK
        O3JuW9JgyAw+IF+CPJCdWVdfg/zFCEFB
X-Google-Smtp-Source: ABdhPJwI0rz7XctpWpoJomIHLMbmlSHtKgRHge1DQRZjTH9SqlsVyP/eofzBm03RD4CgVx0ozYRERDM6Kl/W
X-Received: by 2002:ad4:56ac:: with SMTP id bd12mr27566713qvb.139.1592930561924;
 Tue, 23 Jun 2020 09:42:41 -0700 (PDT)
Date:   Tue, 23 Jun 2020 09:42:32 -0700
In-Reply-To: <20200623164232.175846-1-brianvv@google.com>
Message-Id: <20200623164232.175846-2-brianvv@google.com>
Mime-Version: 1.0
References: <20200623164232.175846-1-brianvv@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH v2 net-next 2/2] ipv6: fib6: avoid indirect calls from fib6_rule_lookup
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luigi Rizzo <lrizzo@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported that a considerable amount of cycles were spent on the
expensive indirect calls on fib6_rule_lookup. This patch introduces an
inline helper called pol_route_func that uses the indirect_call_wrappers
to avoid the indirect calls.

This patch saves around 50ns per call.

Performance was measured on the receiver by checking the amount of
syncookies that server was able to generate under a synflood load.

Traffic was generated using trafgen[1] which was pushing around 1Mpps on
a single queue. Receiver was using only one rx queue which help to
create a bottle neck and make the experiment rx-bounded.

These are the syncookies generated over 10s from the different runs:

Whithout the patch:
TcpExtSyncookiesSent            3553749            0.0
TcpExtSyncookiesSent            3550895            0.0
TcpExtSyncookiesSent            3553845            0.0
TcpExtSyncookiesSent            3541050            0.0
TcpExtSyncookiesSent            3539921            0.0
TcpExtSyncookiesSent            3557659            0.0
TcpExtSyncookiesSent            3526812            0.0
TcpExtSyncookiesSent            3536121            0.0
TcpExtSyncookiesSent            3529963            0.0
TcpExtSyncookiesSent            3536319            0.0

With the patch:
TcpExtSyncookiesSent            3611786            0.0
TcpExtSyncookiesSent            3596682            0.0
TcpExtSyncookiesSent            3606878            0.0
TcpExtSyncookiesSent            3599564            0.0
TcpExtSyncookiesSent            3601304            0.0
TcpExtSyncookiesSent            3609249            0.0
TcpExtSyncookiesSent            3617437            0.0
TcpExtSyncookiesSent            3608765            0.0
TcpExtSyncookiesSent            3620205            0.0
TcpExtSyncookiesSent            3601895            0.0

Without the patch the average is 354263 pkt/s or 2822 ns/pkt and with
the patch the average is 360738 pkt/s or 2772 ns/pkt which gives an
estimate of 50 ns per packet.

[1] http://netsniff-ng.org/

Changelog since v1:
 - Change ordering in the ICW (Paolo Abeni)

Cc: Luigi Rizzo <lrizzo@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/net/ip6_fib.h | 36 ++++++++++++++++++++++++++++++++++++
 net/ipv6/fib6_rules.c |  9 ++++++---
 net/ipv6/ip6_fib.c    |  3 ++-
 net/ipv6/route.c      |  8 ++++----
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 3f615a29766e..cc8356fd927f 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -19,6 +19,7 @@
 #include <net/netlink.h>
 #include <net/inetpeer.h>
 #include <net/fib_notifier.h>
+#include <linux/indirect_call_wrapper.h>
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 #define FIB6_TABLE_HASHSZ 256
@@ -552,6 +553,41 @@ struct bpf_iter__ipv6_route {
 };
 #endif
 
+INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_output(struct net *net,
+					     struct fib6_table *table,
+					     struct flowi6 *fl6,
+					     const struct sk_buff *skb,
+					     int flags));
+INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_input(struct net *net,
+					     struct fib6_table *table,
+					     struct flowi6 *fl6,
+					     const struct sk_buff *skb,
+					     int flags));
+INDIRECT_CALLABLE_DECLARE(struct rt6_info *__ip6_route_redirect(struct net *net,
+					     struct fib6_table *table,
+					     struct flowi6 *fl6,
+					     const struct sk_buff *skb,
+					     int flags));
+INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_lookup(struct net *net,
+					     struct fib6_table *table,
+					     struct flowi6 *fl6,
+					     const struct sk_buff *skb,
+					     int flags));
+static inline struct rt6_info *pol_lookup_func(pol_lookup_t lookup,
+						struct net *net,
+						struct fib6_table *table,
+						struct flowi6 *fl6,
+						const struct sk_buff *skb,
+						int flags)
+{
+	return INDIRECT_CALL_4(lookup,
+			       ip6_pol_route_output,
+			       ip6_pol_route_input,
+			       ip6_pol_route_lookup,
+			       __ip6_route_redirect,
+			       net, table, fl6, skb, flags);
+}
+
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 static inline bool fib6_has_custom_rules(const struct net *net)
 {
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index fafe556d21e0..6053ef851555 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -111,11 +111,13 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 	} else {
 		struct rt6_info *rt;
 
-		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
+		rt = pol_lookup_func(lookup,
+			     net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
 		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
 			return &rt->dst;
 		ip6_rt_put_flags(rt, flags);
-		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
+		rt = pol_lookup_func(lookup,
+			     net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
 		if (rt->dst.error != -EAGAIN)
 			return &rt->dst;
 		ip6_rt_put_flags(rt, flags);
@@ -226,7 +228,8 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 		goto out;
 	}
 
-	rt = lookup(net, table, flp6, arg->lookup_data, flags);
+	rt = pol_lookup_func(lookup,
+			     net, table, flp6, arg->lookup_data, flags);
 	if (rt != net->ipv6.ip6_null_entry) {
 		err = fib6_rule_saddr(net, rule, flags, flp6,
 				      ip6_dst_idev(&rt->dst)->dev);
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 49ee89bbcba0..25a90f3f705c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -314,7 +314,8 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 {
 	struct rt6_info *rt;
 
-	rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
+	rt = pol_lookup_func(lookup,
+			net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
 	if (rt->dst.error == -EAGAIN) {
 		ip6_rt_put_flags(rt, flags);
 		rt = net->ipv6.ip6_null_entry;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..5852039ca9cf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1207,7 +1207,7 @@ static struct rt6_info *ip6_create_rt_rcu(const struct fib6_result *res)
 	return nrt;
 }
 
-static struct rt6_info *ip6_pol_route_lookup(struct net *net,
+INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_lookup(struct net *net,
 					     struct fib6_table *table,
 					     struct flowi6 *fl6,
 					     const struct sk_buff *skb,
@@ -2274,7 +2274,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 }
 EXPORT_SYMBOL_GPL(ip6_pol_route);
 
-static struct rt6_info *ip6_pol_route_input(struct net *net,
+INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_input(struct net *net,
 					    struct fib6_table *table,
 					    struct flowi6 *fl6,
 					    const struct sk_buff *skb,
@@ -2465,7 +2465,7 @@ void ip6_route_input(struct sk_buff *skb)
 						      &fl6, skb, flags));
 }
 
-static struct rt6_info *ip6_pol_route_output(struct net *net,
+INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_output(struct net *net,
 					     struct fib6_table *table,
 					     struct flowi6 *fl6,
 					     const struct sk_buff *skb,
@@ -2912,7 +2912,7 @@ struct ip6rd_flowi {
 	struct in6_addr gateway;
 };
 
-static struct rt6_info *__ip6_route_redirect(struct net *net,
+INDIRECT_CALLABLE_SCOPE struct rt6_info *__ip6_route_redirect(struct net *net,
 					     struct fib6_table *table,
 					     struct flowi6 *fl6,
 					     const struct sk_buff *skb,
-- 
2.27.0.111.gc72c7da667-goog

