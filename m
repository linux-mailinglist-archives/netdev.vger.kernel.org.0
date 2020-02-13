Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A458E15C953
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgBMRTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:19:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33013 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgBMRTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:19:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id m10so204320wmc.0
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 09:19:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7UuiQ4EXxTUtgvkjYHkhsdAOZrJSM0pJwSGAT7bMBA=;
        b=szTw2sA0+Ch8dtHEZnri7acSFJi+FbzHE6pECpJ+cVFgmG31BMjdio5rKRN4h/hdpK
         4SseCuaZpqZke/02hG0UbBYktXwxoyEubtczflzwjikneGeNwXqk4Tirgm9JNeBX88dl
         rZopfZEvDsZFJDWOzwWoy2tVLFyUHhEv56iewIvJyu9DF89QlSwTYS5k2vLXOKxG2GKl
         a5BujaUEYrDEn+c9xfFScNksCw+1iNqLHhMXPu6585NQCSTRNP9C8zDPYctAA6FS/XfT
         1zTpRV21Uwvh8zCGZEfd8lotkzqXm9MVyQ6CrrUl69SpKwfscdJgVnhEdhOMZsr4pOKt
         +MyA==
X-Gm-Message-State: APjAAAVetiIkriydne5tDOlhTtL/knygPrzgSkRp3HKt46IIzTevCpB9
        ZbXWU+XO7NkmRgcMSH+E6nyT6m1FOdI=
X-Google-Smtp-Source: APXvYqy8o8dMuve2NlC8i7sqY5CdbyafFyi+sjHmOcHzEBUNcxT+iA4C0YIdQQsjs9IrH2SwS5NRtA==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr6896528wmi.35.1581614380291;
        Thu, 13 Feb 2020 09:19:40 -0800 (PST)
Received: from dontpanic.criteo.prod ([91.199.242.231])
        by smtp.gmail.com with ESMTPSA id t81sm3847221wmg.6.2020.02.13.09.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 09:19:39 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v5 net] net, ip6_tunnel: enhance tunnel locate with link check
Date:   Thu, 13 Feb 2020 18:19:22 +0100
Message-Id: <20200213171922.510172-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cf5ef569-1742-a22f-ec7d-f987287e12fb@6wind.com>
References: <cf5ef569-1742-a22f-ec7d-f987287e12fb@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With ipip, it is possible to create an extra interface explicitly
attached to a given physical interface:

  # ip link show tunl0
  4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
  # ip link add tunl1 type ipip dev eth0
  # ip link show tunl1
  6: tunl1@eth0: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0

But it is not possible with ip6tnl:

  # ip link show ip6tnl0
  5: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/tunnel6 :: brd ::
  # ip link add ip6tnl1 type ip6tnl dev eth0
  RTNETLINK answers: File exists

This patch aims to make it possible by adding link comparaison in both
tunnel locate and lookup functions; we also modify mtu calculation when
attached to an interface with a lower mtu.

This permits to make use of x-netns communication by moving the newly
created tunnel in a given netns.

Signed-off-by: William Dauchy <w.dauchy@criteo.com>
---
changes in v2:
- splitted code to differenciate link/type check
changes in v3:
- abadon 2/2 with type check as we do not have any real use case as of
  today
- fix lookup function and mtu calculation
changes in v4:
- fix and move mtu calculation in ip6_tnl_link_config
changes in v5:
- mtu fixes: rt->dst.dev check + IP6_MAX_MTU
---
 net/ipv6/ip6_tunnel.c | 68 ++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b5dd20c4599b..5d65436ad5ad 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -121,6 +121,7 @@ static struct net_device_stats *ip6_get_stats(struct net_device *dev)
 
 /**
  * ip6_tnl_lookup - fetch tunnel matching the end-point addresses
+ *   @link: ifindex of underlying interface
  *   @remote: the address of the tunnel exit-point
  *   @local: the address of the tunnel entry-point
  *
@@ -134,37 +135,56 @@ static struct net_device_stats *ip6_get_stats(struct net_device *dev)
 	for (t = rcu_dereference(start); t; t = rcu_dereference(t->next))
 
 static struct ip6_tnl *
-ip6_tnl_lookup(struct net *net, const struct in6_addr *remote, const struct in6_addr *local)
+ip6_tnl_lookup(struct net *net, int link,
+	       const struct in6_addr *remote, const struct in6_addr *local)
 {
 	unsigned int hash = HASH(remote, local);
-	struct ip6_tnl *t;
+	struct ip6_tnl *t, *cand = NULL;
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	struct in6_addr any;
 
 	for_each_ip6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
-		if (ipv6_addr_equal(local, &t->parms.laddr) &&
-		    ipv6_addr_equal(remote, &t->parms.raddr) &&
-		    (t->dev->flags & IFF_UP))
+		if (!ipv6_addr_equal(local, &t->parms.laddr) ||
+		    !ipv6_addr_equal(remote, &t->parms.raddr) ||
+		    !(t->dev->flags & IFF_UP))
+			continue;
+
+		if (link == t->parms.link)
 			return t;
+		else
+			cand = t;
 	}
 
 	memset(&any, 0, sizeof(any));
 	hash = HASH(&any, local);
 	for_each_ip6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
-		if (ipv6_addr_equal(local, &t->parms.laddr) &&
-		    ipv6_addr_any(&t->parms.raddr) &&
-		    (t->dev->flags & IFF_UP))
+		if (!ipv6_addr_equal(local, &t->parms.laddr) ||
+		    !ipv6_addr_any(&t->parms.raddr) ||
+		    !(t->dev->flags & IFF_UP))
+			continue;
+
+		if (link == t->parms.link)
 			return t;
+		else if (!cand)
+			cand = t;
 	}
 
 	hash = HASH(remote, &any);
 	for_each_ip6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
-		if (ipv6_addr_equal(remote, &t->parms.raddr) &&
-		    ipv6_addr_any(&t->parms.laddr) &&
-		    (t->dev->flags & IFF_UP))
+		if (!ipv6_addr_equal(remote, &t->parms.raddr) ||
+		    !ipv6_addr_any(&t->parms.laddr) ||
+		    !(t->dev->flags & IFF_UP))
+			continue;
+
+		if (link == t->parms.link)
 			return t;
+		else if (!cand)
+			cand = t;
 	}
 
+	if (cand)
+		return cand;
+
 	t = rcu_dereference(ip6n->collect_md_tun);
 	if (t && t->dev->flags & IFF_UP)
 		return t;
@@ -351,7 +371,8 @@ static struct ip6_tnl *ip6_tnl_locate(struct net *net,
 	     (t = rtnl_dereference(*tp)) != NULL;
 	     tp = &t->next) {
 		if (ipv6_addr_equal(local, &t->parms.laddr) &&
-		    ipv6_addr_equal(remote, &t->parms.raddr)) {
+		    ipv6_addr_equal(remote, &t->parms.raddr) &&
+		    p->link == t->parms.link) {
 			if (create)
 				return ERR_PTR(-EEXIST);
 
@@ -485,7 +506,7 @@ ip6_tnl_err(struct sk_buff *skb, __u8 ipproto, struct inet6_skb_parm *opt,
 	   processing of the error. */
 
 	rcu_read_lock();
-	t = ip6_tnl_lookup(dev_net(skb->dev), &ipv6h->daddr, &ipv6h->saddr);
+	t = ip6_tnl_lookup(dev_net(skb->dev), skb->dev->ifindex, &ipv6h->daddr, &ipv6h->saddr);
 	if (!t)
 		goto out;
 
@@ -887,7 +908,7 @@ static int ipxip6_rcv(struct sk_buff *skb, u8 ipproto,
 	int ret = -1;
 
 	rcu_read_lock();
-	t = ip6_tnl_lookup(dev_net(skb->dev), &ipv6h->saddr, &ipv6h->daddr);
+	t = ip6_tnl_lookup(dev_net(skb->dev), skb->dev->ifindex, &ipv6h->saddr, &ipv6h->daddr);
 
 	if (t) {
 		u8 tproto = READ_ONCE(t->parms.proto);
@@ -1420,8 +1441,10 @@ ip6_tnl_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static void ip6_tnl_link_config(struct ip6_tnl *t)
 {
 	struct net_device *dev = t->dev;
+	struct net_device *tdev = NULL;
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
+	unsigned int mtu;
 	int t_hlen;
 
 	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
@@ -1457,22 +1480,25 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 		struct rt6_info *rt = rt6_lookup(t->net,
 						 &p->raddr, &p->laddr,
 						 p->link, NULL, strict);
+		if (rt) {
+			tdev = rt->dst.dev;
+			ip6_rt_put(rt);
+		}
 
-		if (!rt)
-			return;
+		if (!tdev && p->link)
+			tdev = __dev_get_by_index(t->net, p->link);
 
-		if (rt->dst.dev) {
-			dev->hard_header_len = rt->dst.dev->hard_header_len +
-				t_hlen;
+		if (tdev) {
+			dev->hard_header_len = tdev->hard_header_len + t_hlen;
+			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
-			dev->mtu = rt->dst.dev->mtu - t_hlen;
+			dev->mtu = mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 				dev->mtu -= 8;
 
 			if (dev->mtu < IPV6_MIN_MTU)
 				dev->mtu = IPV6_MIN_MTU;
 		}
-		ip6_rt_put(rt);
 	}
 }
 
-- 
2.25.0

