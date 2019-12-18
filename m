Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6DF124631
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfLRLxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:53:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44344 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLRLxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:53:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so1143509pgl.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aSkX+kyTacK1dK8GKcHA4Bn8Iz1IW3Ns88K8QsJLJws=;
        b=p273UOlTXrj2MQQ2Dgw4+CWuIBUDqdiHqcH1glX79G5/tpj4mL4wrcM7sCgAOF8wN3
         Yoe6WkslkHPLGaLXuE4GTI0sUOnD06dmu1TXXlPollt8VrpxNcYPoUIYMYnoV3/6WmcD
         IkkTF+199ktOLPLn3vvu7w/oTHq+AGC5QoaZoOqSoYx2WpGao499KjcSKnVBvbaxntgl
         ZdG3aD7zWRbRFN6PaMIsXdSenLrAmpaI43kwma6YixpVwffXBK8lvmWoOV+1KfDmsuN7
         TP2Tmqg6ehsjoQr7bjE8ulGjOCSmOVNcQ/V+vAKCz9rREJMzHWJ/DEhhLfRKonUyO1o6
         dt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aSkX+kyTacK1dK8GKcHA4Bn8Iz1IW3Ns88K8QsJLJws=;
        b=Obk43amgdZQ5hJPj09ucWiGUrDrK/aC4naB+T6fQqdNacFl/2ICTYCzoxCFuwhl7nm
         n8q5GQbmUa8Zjxgp1Eadm9LyFfCgvWw99sy2payOB43AV/83M3H3P+mPbxNNFqRwULIR
         BMpM/AuTF9p+17d/bAQ8jJra2spnrh+2YyNKNaeACJqUd5Ae9hX9p+ebTAfPQfJx4kyp
         W8o5ROwL+s4O/W5HjpPzL3FG+3sZawX9Wk/m1D97dVYVw/dM12JRGpOAjZ+6ub/WOGnl
         0syf4ja191Nz6AkMZK0UIz7bnGGob/W4HodUifGnmOPkr9ZaYM+1AAq7kHcnenWyZznY
         NGpA==
X-Gm-Message-State: APjAAAXkUbvfJ5r7IGzfoRz2Aeyr2qB53o0oeWFrGwtuK6PQIMSA00aw
        8/PihURCfDhBiz9+v/hZMmCREP2H/TyEAw==
X-Google-Smtp-Source: APXvYqxJwEbCLyVnowlIwW6c8TcrE7B/D679jsXEL3D+icBp9fiaWp/RaDgqcXNZxjI5quWCDMmhtA==
X-Received: by 2002:a62:e30f:: with SMTP id g15mr2547582pfh.124.1576670025781;
        Wed, 18 Dec 2019 03:53:45 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:53:45 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 1/8] net: add bool confirm_neigh parameter for dst_ops.update_pmtu
Date:   Wed, 18 Dec 2019 19:53:06 +0800
Message-Id: <20191218115313.19352-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MTU update code is supposed to be invoked in response to real
networking events that update the PMTU. In IPv6 PMTU update function
__ip6_rt_update_pmtu() we called dst_confirm_neigh() to update neighbor
confirmed time.

But for tunnel code, it will call pmtu before xmit, like:
  - tnl_update_pmtu()
    - skb_dst_update_pmtu()
      - ip6_rt_update_pmtu()
        - __ip6_rt_update_pmtu()
          - dst_confirm_neigh()

If the tunnel remote dst mac address changed and we still do the neigh
confirm, we will not be able to update neigh cache and ping6 remote
will failed.

So for this ip_tunnel_xmit() case, _EVEN_ if the MTU is changed, we
should not be invoking dst_confirm_neigh() as we have no evidence
of successful two-way communication at this point.

On the other hand it is also important to keep the neigh reachability fresh
for TCP flows, so we cannot remove this dst_confirm_neigh() call.

To fix the issue, we have to add a new bool parameter for dst_ops.update_pmtu
to choose whether we should do neigh update or not. I will add the parameter
in this patch and set all the callers to true to comply with the previous
way, and fix the tunnel code one by one on later patches.

v2: remove dst_confirm_neigh directly
v3: add bool confirm_neigh parameter for all dst_ops.update_pmtu

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/gtp.c                |  2 +-
 include/net/dst.h                |  2 +-
 include/net/dst_ops.h            |  3 ++-
 net/bridge/br_nf_core.c          |  3 ++-
 net/decnet/dn_route.c            |  6 ++++--
 net/ipv4/inet_connection_sock.c  |  2 +-
 net/ipv4/route.c                 |  9 ++++++---
 net/ipv4/xfrm4_policy.c          |  5 +++--
 net/ipv6/inet6_connection_sock.c |  2 +-
 net/ipv6/ip6_gre.c               |  2 +-
 net/ipv6/route.c                 | 22 +++++++++++++++-------
 net/ipv6/xfrm6_policy.c          |  5 +++--
 net/netfilter/ipvs/ip_vs_xmit.c  |  2 +-
 net/sctp/transport.c             |  2 +-
 14 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index ecfe26215935..9cac0accba7a 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -541,7 +541,7 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 		mtu = dst_mtu(&rt->dst);
 	}
 
-	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu);
+	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, true);
 
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
diff --git a/include/net/dst.h b/include/net/dst.h
index fe62fe2eb781..0739e84152e4 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -516,7 +516,7 @@ static inline void skb_dst_update_pmtu(struct sk_buff *skb, u32 mtu)
 	struct dst_entry *dst = skb_dst(skb);
 
 	if (dst && dst->ops->update_pmtu)
-		dst->ops->update_pmtu(dst, NULL, skb, mtu);
+		dst->ops->update_pmtu(dst, NULL, skb, mtu, true);
 }
 
 static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
index 5ec645f27ee3..443863c7b8da 100644
--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -27,7 +27,8 @@ struct dst_ops {
 	struct dst_entry *	(*negative_advice)(struct dst_entry *);
 	void			(*link_failure)(struct sk_buff *);
 	void			(*update_pmtu)(struct dst_entry *dst, struct sock *sk,
-					       struct sk_buff *skb, u32 mtu);
+					       struct sk_buff *skb, u32 mtu,
+					       bool confirm_neigh);
 	void			(*redirect)(struct dst_entry *dst, struct sock *sk,
 					    struct sk_buff *skb);
 	int			(*local_out)(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/bridge/br_nf_core.c b/net/bridge/br_nf_core.c
index 2cdfc5d6c25d..8c69f0c95a8e 100644
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -22,7 +22,8 @@
 #endif
 
 static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			     struct sk_buff *skb, u32 mtu)
+			     struct sk_buff *skb, u32 mtu,
+			     bool confirm_neigh)
 {
 }
 
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index aea918135ec3..08c3dc45f1a4 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -110,7 +110,8 @@ static void dn_dst_ifdown(struct dst_entry *, struct net_device *dev, int how);
 static struct dst_entry *dn_dst_negative_advice(struct dst_entry *);
 static void dn_dst_link_failure(struct sk_buff *);
 static void dn_dst_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			       struct sk_buff *skb , u32 mtu);
+			       struct sk_buff *skb , u32 mtu,
+			       bool confirm_neigh);
 static void dn_dst_redirect(struct dst_entry *dst, struct sock *sk,
 			    struct sk_buff *skb);
 static struct neighbour *dn_dst_neigh_lookup(const struct dst_entry *dst,
@@ -251,7 +252,8 @@ static int dn_dst_gc(struct dst_ops *ops)
  * advertise to the other end).
  */
 static void dn_dst_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			       struct sk_buff *skb, u32 mtu)
+			       struct sk_buff *skb, u32 mtu,
+			       bool confirm_neigh)
 {
 	struct dn_route *rt = (struct dn_route *) dst;
 	struct neighbour *n = rt->n;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index e4c6e8b40490..18c0d5bffe12 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1086,7 +1086,7 @@ struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu)
 		if (!dst)
 			goto out;
 	}
-	dst->ops->update_pmtu(dst, sk, NULL, mtu);
+	dst->ops->update_pmtu(dst, sk, NULL, mtu, true);
 
 	dst = __sk_dst_check(sk, 0);
 	if (!dst)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f88c93c38f11..87e979f2b74a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -139,7 +139,8 @@ static unsigned int	 ipv4_mtu(const struct dst_entry *dst);
 static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst);
 static void		 ipv4_link_failure(struct sk_buff *skb);
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					   struct sk_buff *skb, u32 mtu);
+					   struct sk_buff *skb, u32 mtu,
+					   bool confirm_neigh);
 static void		 ip_do_redirect(struct dst_entry *dst, struct sock *sk,
 					struct sk_buff *skb);
 static void		ipv4_dst_destroy(struct dst_entry *dst);
@@ -1043,7 +1044,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 }
 
 static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			      struct sk_buff *skb, u32 mtu)
+			      struct sk_buff *skb, u32 mtu,
+			      bool confirm_neigh)
 {
 	struct rtable *rt = (struct rtable *) dst;
 	struct flowi4 fl4;
@@ -2687,7 +2689,8 @@ static unsigned int ipv4_blackhole_mtu(const struct dst_entry *dst)
 }
 
 static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					  struct sk_buff *skb, u32 mtu)
+					  struct sk_buff *skb, u32 mtu,
+					  bool confirm_neigh)
 {
 }
 
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 35b84b52b702..9ebd54752e03 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -100,12 +100,13 @@ static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 }
 
 static void xfrm4_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			      struct sk_buff *skb, u32 mtu)
+			      struct sk_buff *skb, u32 mtu,
+			      bool confirm_neigh)
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 	struct dst_entry *path = xdst->route;
 
-	path->ops->update_pmtu(path, sk, skb, mtu);
+	path->ops->update_pmtu(path, sk, skb, mtu, confirm_neigh);
 }
 
 static void xfrm4_redirect(struct dst_entry *dst, struct sock *sk,
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index fe9cb8d1adca..e315526fa244 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -146,7 +146,7 @@ struct dst_entry *inet6_csk_update_pmtu(struct sock *sk, u32 mtu)
 
 	if (IS_ERR(dst))
 		return NULL;
-	dst->ops->update_pmtu(dst, sk, NULL, mtu);
+	dst->ops->update_pmtu(dst, sk, NULL, mtu, true);
 
 	dst = inet6_csk_route_socket(sk, &fl6);
 	return IS_ERR(dst) ? NULL : dst;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 923034c52ce4..071cb237f00b 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1040,7 +1040,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu);
+		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, true);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   NEXTHDR_GRE);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b59940416cb5..affb51c11a25 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -95,7 +95,8 @@ static int		ip6_pkt_prohibit(struct sk_buff *skb);
 static int		ip6_pkt_prohibit_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 static void		ip6_link_failure(struct sk_buff *skb);
 static void		ip6_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					   struct sk_buff *skb, u32 mtu);
+					   struct sk_buff *skb, u32 mtu,
+					   bool confirm_neigh);
 static void		rt6_do_redirect(struct dst_entry *dst, struct sock *sk,
 					struct sk_buff *skb);
 static int rt6_score_route(const struct fib6_nh *nh, u32 fib6_flags, int oif,
@@ -264,7 +265,8 @@ static unsigned int ip6_blackhole_mtu(const struct dst_entry *dst)
 }
 
 static void ip6_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					 struct sk_buff *skb, u32 mtu)
+					 struct sk_buff *skb, u32 mtu,
+					 bool confirm_neigh)
 {
 }
 
@@ -2692,7 +2694,8 @@ static bool rt6_cache_allowed_for_pmtu(const struct rt6_info *rt)
 }
 
 static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
-				 const struct ipv6hdr *iph, u32 mtu)
+				 const struct ipv6hdr *iph, u32 mtu,
+				 bool confirm_neigh)
 {
 	const struct in6_addr *daddr, *saddr;
 	struct rt6_info *rt6 = (struct rt6_info *)dst;
@@ -2710,7 +2713,10 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 		daddr = NULL;
 		saddr = NULL;
 	}
-	dst_confirm_neigh(dst, daddr);
+
+	if (confirm_neigh)
+		dst_confirm_neigh(dst, daddr);
+
 	mtu = max_t(u32, mtu, IPV6_MIN_MTU);
 	if (mtu >= dst_mtu(dst))
 		return;
@@ -2764,9 +2770,11 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 }
 
 static void ip6_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			       struct sk_buff *skb, u32 mtu)
+			       struct sk_buff *skb, u32 mtu,
+			       bool confirm_neigh)
 {
-	__ip6_rt_update_pmtu(dst, sk, skb ? ipv6_hdr(skb) : NULL, mtu);
+	__ip6_rt_update_pmtu(dst, sk, skb ? ipv6_hdr(skb) : NULL, mtu,
+			     confirm_neigh);
 }
 
 void ip6_update_pmtu(struct sk_buff *skb, struct net *net, __be32 mtu,
@@ -2785,7 +2793,7 @@ void ip6_update_pmtu(struct sk_buff *skb, struct net *net, __be32 mtu,
 
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (!dst->error)
-		__ip6_rt_update_pmtu(dst, NULL, iph, ntohl(mtu));
+		__ip6_rt_update_pmtu(dst, NULL, iph, ntohl(mtu), true);
 	dst_release(dst);
 }
 EXPORT_SYMBOL_GPL(ip6_update_pmtu);
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 699e0730ce8e..af7a4b8b1e9c 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -98,12 +98,13 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 }
 
 static void xfrm6_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			      struct sk_buff *skb, u32 mtu)
+			      struct sk_buff *skb, u32 mtu,
+			      bool confirm_neigh)
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 	struct dst_entry *path = xdst->route;
 
-	path->ops->update_pmtu(path, sk, skb, mtu);
+	path->ops->update_pmtu(path, sk, skb, mtu, confirm_neigh);
 }
 
 static void xfrm6_redirect(struct dst_entry *dst, struct sock *sk,
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index b1e300f8881b..b00866d777fe 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -208,7 +208,7 @@ static inline void maybe_update_pmtu(int skb_af, struct sk_buff *skb, int mtu)
 	struct rtable *ort = skb_rtable(skb);
 
 	if (!skb->dev && sk && sk_fullsock(sk))
-		ort->dst.ops->update_pmtu(&ort->dst, sk, NULL, mtu);
+		ort->dst.ops->update_pmtu(&ort->dst, sk, NULL, mtu, true);
 }
 
 static inline bool ensure_mtu_is_adequate(struct netns_ipvs *ipvs, int skb_af,
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index f4de064598f8..806af58f4375 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -263,7 +263,7 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 
 		pf->af->from_sk(&addr, sk);
 		pf->to_sk_daddr(&t->ipaddr, sk);
-		dst->ops->update_pmtu(dst, sk, NULL, pmtu);
+		dst->ops->update_pmtu(dst, sk, NULL, pmtu, true);
 		pf->to_sk_daddr(&addr, sk);
 
 		dst = sctp_transport_dst_check(t);
-- 
2.19.2

