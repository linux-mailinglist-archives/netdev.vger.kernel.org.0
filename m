Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3497333285
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCJAi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:38:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:43780 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhCJAia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:38:30 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJmrs-0008uS-SK; Wed, 10 Mar 2021 01:38:28 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        willemb@google.com, edumazet@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net 1/2] net: Consolidate common blackhole dst ops
Date:   Wed, 10 Mar 2021 01:38:09 +0100
Message-Id: <998c4303ed4da1f140ec6d321656f610ecd9cae4.1615331093.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1615331093.git.daniel@iogearbox.net>
References: <cover.1615331093.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26103/Tue Mar  9 13:03:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move generic blackhole dst ops to the core and use them from both
ipv4_dst_blackhole_ops and ip6_dst_blackhole_ops where possible. No
functional change otherwise. We need these also in other locations
and having to define them over and over again is not great.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/net/dst.h | 11 +++++++++++
 net/core/dst.c    | 38 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/route.c  | 45 ++++++++-------------------------------------
 net/ipv6/route.c  | 36 +++++++++---------------------------
 4 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 26f134ad3a25..75b1e734e9c2 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -550,4 +550,15 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 }
 
+struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
+void dst_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
+			       struct sk_buff *skb, u32 mtu, bool confirm_neigh);
+void dst_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
+			    struct sk_buff *skb);
+u32 *dst_blackhole_cow_metrics(struct dst_entry *dst, unsigned long old);
+struct neighbour *dst_blackhole_neigh_lookup(const struct dst_entry *dst,
+					     struct sk_buff *skb,
+					     const void *daddr);
+unsigned int dst_blackhole_mtu(const struct dst_entry *dst);
+
 #endif /* _NET_DST_H */
diff --git a/net/core/dst.c b/net/core/dst.c
index 0c01bd8d9d81..5f6315601776 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -237,6 +237,44 @@ void __dst_destroy_metrics_generic(struct dst_entry *dst, unsigned long old)
 }
 EXPORT_SYMBOL(__dst_destroy_metrics_generic);
 
+struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie)
+{
+	return NULL;
+}
+
+u32 *dst_blackhole_cow_metrics(struct dst_entry *dst, unsigned long old)
+{
+	return NULL;
+}
+
+struct neighbour *dst_blackhole_neigh_lookup(const struct dst_entry *dst,
+					     struct sk_buff *skb,
+					     const void *daddr)
+{
+	return NULL;
+}
+
+void dst_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
+			       struct sk_buff *skb, u32 mtu,
+			       bool confirm_neigh)
+{
+}
+EXPORT_SYMBOL_GPL(dst_blackhole_update_pmtu);
+
+void dst_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
+			    struct sk_buff *skb)
+{
+}
+EXPORT_SYMBOL_GPL(dst_blackhole_redirect);
+
+unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
+{
+	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
+
+	return mtu ? : dst->dev->mtu;
+}
+EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
+
 static struct dst_ops md_dst_ops = {
 	.family =		AF_UNSPEC,
 };
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 02d81d79deeb..bba150fdd265 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2687,44 +2687,15 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 	return rth;
 }
 
-static struct dst_entry *ipv4_blackhole_dst_check(struct dst_entry *dst, u32 cookie)
-{
-	return NULL;
-}
-
-static unsigned int ipv4_blackhole_mtu(const struct dst_entry *dst)
-{
-	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
-
-	return mtu ? : dst->dev->mtu;
-}
-
-static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					  struct sk_buff *skb, u32 mtu,
-					  bool confirm_neigh)
-{
-}
-
-static void ipv4_rt_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
-				       struct sk_buff *skb)
-{
-}
-
-static u32 *ipv4_rt_blackhole_cow_metrics(struct dst_entry *dst,
-					  unsigned long old)
-{
-	return NULL;
-}
-
 static struct dst_ops ipv4_dst_blackhole_ops = {
-	.family			=	AF_INET,
-	.check			=	ipv4_blackhole_dst_check,
-	.mtu			=	ipv4_blackhole_mtu,
-	.default_advmss		=	ipv4_default_advmss,
-	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
-	.redirect		=	ipv4_rt_blackhole_redirect,
-	.cow_metrics		=	ipv4_rt_blackhole_cow_metrics,
-	.neigh_lookup		=	ipv4_neigh_lookup,
+	.family			= AF_INET,
+	.default_advmss		= ipv4_default_advmss,
+	.neigh_lookup		= ipv4_neigh_lookup,
+	.check			= dst_blackhole_check,
+	.cow_metrics		= dst_blackhole_cow_metrics,
+	.update_pmtu		= dst_blackhole_update_pmtu,
+	.redirect		= dst_blackhole_redirect,
+	.mtu			= dst_blackhole_mtu,
 };
 
 struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_orig)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1536f4948e86..1056b0229ffd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -260,34 +260,16 @@ static struct dst_ops ip6_dst_ops_template = {
 	.confirm_neigh		=	ip6_confirm_neigh,
 };
 
-static unsigned int ip6_blackhole_mtu(const struct dst_entry *dst)
-{
-	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
-
-	return mtu ? : dst->dev->mtu;
-}
-
-static void ip6_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					 struct sk_buff *skb, u32 mtu,
-					 bool confirm_neigh)
-{
-}
-
-static void ip6_rt_blackhole_redirect(struct dst_entry *dst, struct sock *sk,
-				      struct sk_buff *skb)
-{
-}
-
 static struct dst_ops ip6_dst_blackhole_ops = {
-	.family			=	AF_INET6,
-	.destroy		=	ip6_dst_destroy,
-	.check			=	ip6_dst_check,
-	.mtu			=	ip6_blackhole_mtu,
-	.default_advmss		=	ip6_default_advmss,
-	.update_pmtu		=	ip6_rt_blackhole_update_pmtu,
-	.redirect		=	ip6_rt_blackhole_redirect,
-	.cow_metrics		=	dst_cow_metrics_generic,
-	.neigh_lookup		=	ip6_dst_neigh_lookup,
+	.family			= AF_INET6,
+	.default_advmss		= ip6_default_advmss,
+	.neigh_lookup		= ip6_dst_neigh_lookup,
+	.check			= ip6_dst_check,
+	.destroy		= ip6_dst_destroy,
+	.cow_metrics		= dst_cow_metrics_generic,
+	.update_pmtu		= dst_blackhole_update_pmtu,
+	.redirect		= dst_blackhole_redirect,
+	.mtu			= dst_blackhole_mtu,
 };
 
 static const u32 ip6_template_metrics[RTAX_MAX] = {
-- 
2.21.0

