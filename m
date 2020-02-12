Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE115A35A
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgBLIbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:31:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53400 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgBLIbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:31:11 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so1063123wmh.3
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 00:31:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8j7fiO0KMPUPBU/lKJcUZimCs21h8mk5hayYLRUChLQ=;
        b=rIk1NDtCSUKi/gU61dC1azCXc4LwU1M2lZWPOlo9MntLf6BsDb2o8R99hJTXSDmgHC
         aYardjTJIWGYysrUEDfBA/mVcubpWWibzZsrQenqdyJlan1vYNNg80pICV0a4EjzsAvG
         EfgfnmFO+BJFPc6r3wFoXXXENZQ10okHG7IV5XYNsQtI8E6suUFTMTZp/SoozadegBUZ
         ZBaGDu/GXxwtbNgymqUs+eoyll1ajiuO/W5RL0rLSMoBItwJdxhfT04PONV1bVyTFk38
         yFd2zJ7iQUpshKg4pGev5u3KJcQZyb+jAI/ptcX38Iip4nKhlrnvSMTRwv9XzaHXSgfp
         tLQQ==
X-Gm-Message-State: APjAAAVitGcUP7hqflc0gB7Vjmsdir2IGoJ3KWd7aIW/ma7YNwnRDl83
        1AS3paqp/SxEpgru+9CRuHedh1TQPu0=
X-Google-Smtp-Source: APXvYqxUNFdbkqrl+IAlY4JHKPjQ//LEscxhyJw022m1zkWWkMaeADyQh46SH7OmecYxd4sEQMJ0RQ==
X-Received: by 2002:a1c:960c:: with SMTP id y12mr11260128wmd.9.1581496268266;
        Wed, 12 Feb 2020 00:31:08 -0800 (PST)
Received: from dontpanic.criteo.prod ([91.199.242.231])
        by smtp.gmail.com with ESMTPSA id a13sm9025428wrp.93.2020.02.12.00.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 00:31:07 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.dichtel@6wind.com, William Dauchy <w.dauchy@criteo.com>
Subject: [PATCH v3 net] net, ip6_tunnel: enhance tunnel locate with link check
Date:   Wed, 12 Feb 2020 09:30:36 +0100
Message-Id: <20200212083036.134761-1-w.dauchy@criteo.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
References: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
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
 net/ipv6/ip6_tunnel.c | 55 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b5dd20c4599b..e57802f100fd 100644
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
@@ -1823,6 +1844,7 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 static inline int
 ip6_tnl_dev_init_gen(struct net_device *dev)
 {
+	struct net_device *tdev = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	int ret;
 	int t_hlen;
@@ -1848,6 +1870,11 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	dev->type = ARPHRD_TUNNEL6;
 	dev->hard_header_len = LL_MAX_HEADER + t_hlen;
 	dev->mtu = ETH_DATA_LEN - t_hlen;
+	if (t->parms.link) {
+		tdev = __dev_get_by_index(t->net, t->parms.link);
+		if (tdev && tdev->mtu < dev->mtu)
+			dev->mtu = tdev->mtu;
+	}
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		dev->mtu -= 8;
 	dev->min_mtu = ETH_MIN_MTU;
-- 
2.25.0

