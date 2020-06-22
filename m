Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485BD203E99
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgFVSAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:00:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730046AbgFVSAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592848811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6McDk01oCNNfzZVburqPaTogDAqMR5gAhl+0aYITZY=;
        b=iXTfj+lZ6b5Z42bbplotXm2aA6c0VzjxlTx5bMel8QK3DTYH61SZCCzxsNjFdPe/0RaeSf
        FmkKOTAwAW/GzDmeFUUGcoqbjxXS2N/KJTQz9yS0IIoxy/HAwQVBVk8hLZqFIPY0Y9+sVa
        hN/AV8Kw56JrloCXkIuRoidDPkHEmBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-UHgQIe01NiyM9FToTz6dAw-1; Mon, 22 Jun 2020 14:00:07 -0400
X-MC-Unique: UHgQIe01NiyM9FToTz6dAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C41D18A8221;
        Mon, 22 Jun 2020 18:00:05 +0000 (UTC)
Received: from ovpn-113-146.ams2.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C99071687;
        Mon, 22 Jun 2020 18:00:02 +0000 (UTC)
Message-ID: <8427633745b43a1bbd9a0b288ceb2bb6f9e977aa.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] ipv6: fib6: avoid indirect calls from
 fib6_rule_lookup
From:   Paolo Abeni <pabeni@redhat.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Luigi Rizzo <lrizzo@google.com>
Date:   Mon, 22 Jun 2020 20:00:01 +0200
In-Reply-To: <CAMzD94QUSR8T3vMAfjVf_MxCPrj_gtPYhEqNCyPqsJ1rdA=G9g@mail.gmail.com>
References: <20200620031419.219106-1-brianvv@google.com>
         <20200620031419.219106-2-brianvv@google.com>
         <daac77afd98bd9c10c4c52309067b8dfbba3fad0.camel@redhat.com>
         <CAMzD94QUSR8T3vMAfjVf_MxCPrj_gtPYhEqNCyPqsJ1rdA=G9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-22 at 09:25 -0700, Brian Vazquez wrote:
> 
> Hi Paolo
> On Mon, Jun 22, 2020 at 3:13 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > Hi,
> > 
> > On Fri, 2020-06-19 at 20:14 -0700, Brian Vazquez wrote:
> > > @@ -111,11 +111,13 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
> > >       } else {
> > >               struct rt6_info *rt;
> > >  
> > > -             rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> > > +             rt = pol_lookup_func(lookup,
> > > +                          net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> > >               if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
> > >                       return &rt->dst;
> > >               ip6_rt_put_flags(rt, flags);
> > > -             rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> > > +             rt = pol_lookup_func(lookup,
> > > +                          net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> > >               if (rt->dst.error != -EAGAIN)
> > >                       return &rt->dst;
> > >               ip6_rt_put_flags(rt, flags);
> > 
> > Have you considered instead factoring out the slice of
> > fib6_rule_lookup() using indirect calls to an header file? it looks
> > like here (gcc 10.1.1) it sufficent let the compiler use direct calls
> > and will avoid the additional branches.
> > 
> 
> Sorry I couldn't get your point. Could you elaborate more, please? Or provide an example?

I mean: I think we can avoid the indirect calls even without using the
ICW, just moving the relevant code around - in a inline function in the
header files.

e.g. with the following code - rough, build-tested only experiment -
the gcc 10.1.1 is able to use direct calls
for ip6_pol_route_lookup(), ip6_pol_route_output(), etc.

Cheers,

Paolo
---
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 3f615a29766e..c1b5ac890cd2 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -430,9 +430,6 @@ struct fib6_entry_notifier_info {
 
 struct fib6_table *fib6_get_table(struct net *net, u32 id);
 struct fib6_table *fib6_new_table(struct net *net, u32 id);
-struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
-				   const struct sk_buff *skb,
-				   int flags, pol_lookup_t lookup);
 
 /* called with rcu lock held; can return error pointer
  * caller needs to select path
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2a5277758379..fe1c2102ffe8 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -336,4 +336,50 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
 struct neighbour *ip6_neigh_lookup(const struct in6_addr *gw,
 				   struct net_device *dev, struct sk_buff *skb,
 				   const void *daddr);
+
+#ifdef CONFIG_IPV6_MULTIPLE_TABLES
+struct rt6_info *__fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
+				    const struct sk_buff *skb,
+				    int flags, pol_lookup_t lookup);
+static inline struct dst_entry *
+fib6_rule_lookup(struct net *net, struct flowi6 *fl6, const struct sk_buff *skb,
+		 int flags, pol_lookup_t lookup)
+{
+	struct rt6_info *rt;
+
+	if (!net->ipv6.fib6_has_custom_rules) {
+		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
+		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
+			return &rt->dst;
+		ip6_rt_put_flags(rt, flags);
+		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
+		if (rt->dst.error != -EAGAIN)
+			return &rt->dst;
+		ip6_rt_put_flags(rt, flags);
+	} else {
+		rt = __fib6_rule_lookup(net, fl6, skb, flags, lookup);
+	}
+
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		dst_hold(&net->ipv6.ip6_null_entry->dst);
+	return &net->ipv6.ip6_null_entry->dst;
+}
+#else
+static inline struct dst_entry *
+fib6_rule_lookup(struct net *net, struct flowi6 *fl6, const struct sk_buff *skb,
+		 int flags, pol_lookup_t lookup)
+{
+	struct rt6_info *rt;
+
+	rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
+	if (rt->dst.error == -EAGAIN) {
+		ip6_rt_put_flags(rt, flags);
+		rt = net->ipv6.ip6_null_entry;
+		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+			dst_hold(&rt->dst);
+	}
+
+	return &rt->dst;
+}
+#endif
 #endif
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index fafe556d21e0..4672cb04c562 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -87,43 +87,27 @@ int fib6_lookup(struct net *net, int oif, struct flowi6 *fl6,
 	return err;
 }
 
-struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
-				   const struct sk_buff *skb,
-				   int flags, pol_lookup_t lookup)
+struct rt6_info *__fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
+				  const struct sk_buff *skb,
+				  int flags, pol_lookup_t lookup)
 {
-	if (net->ipv6.fib6_has_custom_rules) {
-		struct fib6_result res = {};
-		struct fib_lookup_arg arg = {
-			.lookup_ptr = lookup,
-			.lookup_data = skb,
-			.result = &res,
-			.flags = FIB_LOOKUP_NOREF,
-		};
-
-		/* update flow if oif or iif point to device enslaved to l3mdev */
-		l3mdev_update_flow(net, flowi6_to_flowi(fl6));
-
-		fib_rules_lookup(net->ipv6.fib6_rules_ops,
-				 flowi6_to_flowi(fl6), flags, &arg);
-
-		if (res.rt6)
-			return &res.rt6->dst;
-	} else {
-		struct rt6_info *rt;
-
-		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
-		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
-			return &rt->dst;
-		ip6_rt_put_flags(rt, flags);
-		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
-		if (rt->dst.error != -EAGAIN)
-			return &rt->dst;
-		ip6_rt_put_flags(rt, flags);
-	}
-
-	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
-		dst_hold(&net->ipv6.ip6_null_entry->dst);
-	return &net->ipv6.ip6_null_entry->dst;
+	struct fib6_result res = {};
+	struct fib_lookup_arg arg = {
+		.lookup_ptr = lookup,
+		.lookup_data = skb,
+		.result = &res,
+		.flags = FIB_LOOKUP_NOREF,
+	};
+
+	/* update flow if oif or iif point to device enslaved to l3mdev */
+	l3mdev_update_flow(net, flowi6_to_flowi(fl6));
+
+	fib_rules_lookup(net->ipv6.fib6_rules_ops,
+			 flowi6_to_flowi(fl6), flags, &arg);
+
+	if (res.rt6)
+		return res.rt6;
+	return NULL;
 }
 
 static int fib6_rule_saddr(struct net *net, struct fib_rule *rule, int flags,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 49ee89bbcba0..242d4cdd2666 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -308,23 +308,6 @@ struct fib6_table *fib6_get_table(struct net *net, u32 id)
 	  return net->ipv6.fib6_main_tbl;
 }
 
-struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
-				   const struct sk_buff *skb,
-				   int flags, pol_lookup_t lookup)
-{
-	struct rt6_info *rt;
-
-	rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
-	if (rt->dst.error == -EAGAIN) {
-		ip6_rt_put_flags(rt, flags);
-		rt = net->ipv6.ip6_null_entry;
-		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
-			dst_hold(&rt->dst);
-	}
-
-	return &rt->dst;
-}
-
 /* called with rcu lock held; no reference taken on fib6_info */
 int fib6_lookup(struct net *net, int oif, struct flowi6 *fl6,
 		struct fib6_result *res, int flags)

