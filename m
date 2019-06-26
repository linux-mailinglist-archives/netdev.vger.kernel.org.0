Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1856243
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 08:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfFZGVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 02:21:31 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39244 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZGVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 02:21:30 -0400
Received: by mail-yb1-f195.google.com with SMTP id k4so732547ybo.6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 23:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MBAwMNirrDHkfAl3HPnHqf7OZ2vRa+JZotW6QoWQ1KI=;
        b=TLT4rmc/lFr+5L3BCjxGpBuy7Onj/H2A17dMpnx9sxZpnUvqxfyo0ftfReOXeYBcTK
         n/97tO0RmRizZOaCTFKM+fyz4PY771yhhYSkVTFOUsV7Oh4vfT6Yp5PDrWPxD9TTnuL1
         u8GezGkPp+kuo8y+CibeLHdlYO7J2Y3yQ20LzKaxUTezqjihxWv0sa0lhLWDnge2Uto9
         CmsHfAyog7hJqM0vJLf4sn6jI8VpiWuvhp7zPB65iyglSY9hfOb83XX+frYmpeGiliaA
         j3blM4vvNJHnjlD+xYO50KpyXrGG2hauRmmUOKofFcoY7fKqu+fDGDb/SCv1zL2imKmI
         pYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MBAwMNirrDHkfAl3HPnHqf7OZ2vRa+JZotW6QoWQ1KI=;
        b=tTxaTu2id7PQ5477rJ5YVNuLZIYvLG44VEdiNwYMGrXZUM1p2blcD7j7OxLtwcV49R
         JYTbiKwZhQppmJXV9QcHNopKNtqLldrQ75XlhIypCSC4s4btQ2/oywOnkukcFtshgTXF
         0C5B0LWzXHpRf0djWvgzLED9G52IPR050XgJrc8AnwFRjp0jtuaCOtybV6JuK/u6WHr5
         9+m6OCWKbto3kFyRsAAIkgxM60OTC5V0VY5rv5BscV8MV133dfRbM88xiWZ8t4OKryaw
         vfOmiWd2z+6ACXieWThm2g+cTf/8Fv7U6HtW2RnRvr0eLce00xISZGCtlMfPBjkRMR60
         44gw==
X-Gm-Message-State: APjAAAUWz78LfEOGUM8FK7wK/qE5gSKqG/FQhFwZJg3/pXKad4vHbzR0
        EDXWY4tfyzD34PzAKqwU+qqJdhCcJA==
X-Google-Smtp-Source: APXvYqx6R5IHel1tkKdDKxsozalCm0eqaps4zhoqltUIcrNWnXeD/f9GvKTzsGvKAqCNJLJu2XaH6w==
X-Received: by 2002:a25:5f10:: with SMTP id t16mr1511633ybb.5.1561530089718;
        Tue, 25 Jun 2019 23:21:29 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id b6sm4905349ywh.36.2019.06.25.23.21.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 23:21:29 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net v2] ipv4: reset rt_iif for recirculated mcast/bcast out pkts
Date:   Wed, 26 Jun 2019 02:21:16 -0400
Message-Id: <20190626062116.4319-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast or broadcast egress packets have rt_iif set to the oif. These
packets might be recirculated back as input and lookup to the raw
sockets may fail because they are bound to the incoming interface
(skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
returns rt_iif instead of skb_iif. Hence, the lookup fails.

v2: Make it non vrf specific (David Ahern). Reword the changelog to
    reflect it.
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/net/route.h  |  1 +
 net/ipv4/ip_output.c | 12 ++++++++++++
 net/ipv4/route.c     | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/net/route.h b/include/net/route.h
index 065b47754f05..55ff71ffb796 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -221,6 +221,7 @@ void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
 struct rtable *rt_dst_alloc(struct net_device *dev,
 			     unsigned int flags, u16 type,
 			     bool nopolicy, bool noxfrm, bool will_cache);
+struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt);
 
 struct in_ifaddr;
 void fib_add_ifaddr(struct in_ifaddr *);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 16f9159234a2..8c2ec35b6512 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -318,6 +318,7 @@ static int ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *sk
 static int ip_mc_finish_output(struct net *net, struct sock *sk,
 			       struct sk_buff *skb)
 {
+	struct rtable *new_rt;
 	int ret;
 
 	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
@@ -326,6 +327,17 @@ static int ip_mc_finish_output(struct net *net, struct sock *sk,
 		return ret;
 	}
 
+	/* Reset rt_iif so that inet_iif() will return skb->skb_iif. Setting
+	 * this to non-zero causes ipi_ifindex in in_pktinfo to be overwritten,
+	 * see ipv4_pktinfo_prepare().
+	 */
+	new_rt = rt_dst_clone(net->loopback_dev, skb_rtable(skb));
+	if (new_rt) {
+		new_rt->rt_iif = 0;
+		skb_dst_drop(skb);
+		skb_dst_set(skb, &new_rt->dst);
+	}
+
 	return dev_loopback_xmit(net, sk, skb);
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6cb7cff22db9..8ea0735a6754 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1647,6 +1647,39 @@ struct rtable *rt_dst_alloc(struct net_device *dev,
 }
 EXPORT_SYMBOL(rt_dst_alloc);
 
+struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
+{
+	struct rtable *new_rt;
+
+	new_rt = dst_alloc(&ipv4_dst_ops, dev, 1, DST_OBSOLETE_FORCE_CHK,
+			   rt->dst.flags);
+
+	if (new_rt) {
+		new_rt->rt_genid = rt_genid_ipv4(dev_net(dev));
+		new_rt->rt_flags = rt->rt_flags;
+		new_rt->rt_type = rt->rt_type;
+		new_rt->rt_is_input = rt->rt_is_input;
+		new_rt->rt_iif = rt->rt_iif;
+		new_rt->rt_pmtu = rt->rt_pmtu;
+		new_rt->rt_mtu_locked = rt->rt_mtu_locked;
+		new_rt->rt_gw_family = rt->rt_gw_family;
+		if (rt->rt_gw_family == AF_INET)
+			new_rt->rt_gw4 = rt->rt_gw4;
+		else if (rt->rt_gw_family == AF_INET6)
+			new_rt->rt_gw6 = rt->rt_gw6;
+		INIT_LIST_HEAD(&new_rt->rt_uncached);
+
+		new_rt->dst.flags |= DST_HOST;
+		new_rt->dst.input = rt->dst.input;
+		new_rt->dst.output = rt->dst.output;
+		new_rt->dst.error = rt->dst.error;
+		new_rt->dst.lastuse = jiffies;
+		new_rt->dst.lwtstate = lwtstate_get(rt->dst.lwtstate);
+	}
+	return new_rt;
+}
+EXPORT_SYMBOL(rt_dst_clone);
+
 /* called in rcu_read_lock() section */
 int ip_mc_validate_source(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 			  u8 tos, struct net_device *dev,
-- 
2.17.1

