Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433DA42A917
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhJLQIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhJLQIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D726C6113E;
        Tue, 12 Oct 2021 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054800;
        bh=xGg0+jOuBUx3j05MGjreBsDJGylx8vrwBb7rJ5ro46Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0wcP9x+3cA1RHsRs2FKhCno9OU+YkbGIdiGrgFO9VqVvtS9EXsYOz6qJVOnSFRzm
         PkVL1VdZKbX5vhqMm70mKBN/UjMeq3eDyn8DWZL76ZVp5uKZxNOAuziZ6cC4l+pZ5w
         keleXdXbyF/HYON+YT44HT3AO0gxk1CfjQUWZ/Tr7VsK3lgFgr91yaubBPHgiHK3iy
         yl3J/J81Ovvusrrdk7AYJ0/c7MmpLo7nqX1oPPSyncuSEsqo139dLHTa1l31zkmKDs
         uFeyG3JGJpvWxhPt+RLtpn3G4BmcVKMlFs3+BOcBKRuGk4P085MHp55Rq7N2nVbKFp
         DLE1Hyj8BMp3w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Subject: [PATCH net-next 3/3] ip: use dev_addr_set() in tunnels
Date:   Tue, 12 Oct 2021 09:06:34 -0700
Message-Id: <20211012160634.4152690-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012160634.4152690-1-kuba@kernel.org>
References: <20211012160634.4152690-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_addr_set() instead of writing to netdev->dev_addr
directly in ip tunnels drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: yoshfuji@linux-ipv6.org
CC: dsahern@kernel.org
CC: steffen.klassert@secunet.com
CC: herbert@gondor.apana.org.au
---
 net/ipv4/ip_gre.c     | 2 +-
 net/ipv4/ip_tunnel.c  | 2 +-
 net/ipv4/ip_vti.c     | 2 +-
 net/ipv4/ipip.c       | 2 +-
 net/ipv6/ip6_gre.c    | 4 ++--
 net/ipv6/ip6_tunnel.c | 2 +-
 net/ipv6/ip6_vti.c    | 2 +-
 net/ipv6/sit.c        | 4 ++--
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 0fe6c936dc54..2ac2b95c5694 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -986,7 +986,7 @@ static int ipgre_tunnel_init(struct net_device *dev)
 
 	__gre_tunnel_init(dev);
 
-	memcpy(dev->dev_addr, &iph->saddr, 4);
+	__dev_addr_set(dev, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
 	dev->flags		= IFF_NOARP;
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index fe9101d3d69e..5a473319d3a5 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -834,7 +834,7 @@ static void ip_tunnel_update(struct ip_tunnel_net *itn,
 	t->parms.i_key = p->i_key;
 	t->parms.o_key = p->o_key;
 	if (dev->type != ARPHRD_ETHER) {
-		memcpy(dev->dev_addr, &p->iph.saddr, 4);
+		__dev_addr_set(dev, &p->iph.saddr, 4);
 		memcpy(dev->broadcast, &p->iph.daddr, 4);
 	}
 	ip_tunnel_add(itn, t);
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index efe25a0172e6..8c2bd1d9ddce 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -425,7 +425,7 @@ static int vti_tunnel_init(struct net_device *dev)
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	struct iphdr *iph = &tunnel->parms.iph;
 
-	memcpy(dev->dev_addr, &iph->saddr, 4);
+	__dev_addr_set(dev, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
 	dev->flags		= IFF_NOARP;
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 3aa78ccbec3e..123ea63a04cb 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -380,7 +380,7 @@ static int ipip_tunnel_init(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 
-	memcpy(dev->dev_addr, &tunnel->parms.iph.saddr, 4);
+	__dev_addr_set(dev, &tunnel->parms.iph.saddr, 4);
 	memcpy(dev->broadcast, &tunnel->parms.iph.daddr, 4);
 
 	tunnel->tun_hlen = 0;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 3ad201d372d8..d831d2439693 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1088,7 +1088,7 @@ static void ip6gre_tnl_link_config_common(struct ip6_tnl *t)
 	struct flowi6 *fl6 = &t->fl.u.ip6;
 
 	if (dev->type != ARPHRD_ETHER) {
-		memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
+		__dev_addr_set(dev, &p->laddr, sizeof(struct in6_addr));
 		memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
 	}
 
@@ -1521,7 +1521,7 @@ static int ip6gre_tunnel_init(struct net_device *dev)
 	if (tunnel->parms.collect_md)
 		return 0;
 
-	memcpy(dev->dev_addr, &tunnel->parms.laddr, sizeof(struct in6_addr));
+	__dev_addr_set(dev, &tunnel->parms.laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &tunnel->parms.raddr, sizeof(struct in6_addr));
 
 	if (ipv6_addr_any(&tunnel->parms.raddr))
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 20a67efda47f..484aca492cc0 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1449,7 +1449,7 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	unsigned int mtu;
 	int t_hlen;
 
-	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
+	__dev_addr_set(dev, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
 
 	/* Set up flowi template */
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 1d8e3ffa225d..527e9ead7449 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -660,7 +660,7 @@ static void vti6_link_config(struct ip6_tnl *t, bool keep_mtu)
 	struct net_device *tdev = NULL;
 	int mtu;
 
-	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
+	__dev_addr_set(dev, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
 
 	p->flags &= ~(IP6_TNL_F_CAP_XMIT | IP6_TNL_F_CAP_RCV |
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index ef0c7a7c18e2..1b57ee36d668 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -204,7 +204,7 @@ static int ipip6_tunnel_create(struct net_device *dev)
 	struct sit_net *sitn = net_generic(net, sit_net_id);
 	int err;
 
-	memcpy(dev->dev_addr, &t->parms.iph.saddr, 4);
+	__dev_addr_set(dev, &t->parms.iph.saddr, 4);
 	memcpy(dev->broadcast, &t->parms.iph.daddr, 4);
 
 	if ((__force u16)t->parms.i_flags & SIT_ISATAP)
@@ -1149,7 +1149,7 @@ static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
 	synchronize_net();
 	t->parms.iph.saddr = p->iph.saddr;
 	t->parms.iph.daddr = p->iph.daddr;
-	memcpy(t->dev->dev_addr, &p->iph.saddr, 4);
+	__dev_addr_set(t->dev, &p->iph.saddr, 4);
 	memcpy(t->dev->broadcast, &p->iph.daddr, 4);
 	ipip6_tunnel_link(sitn, t);
 	t->parms.iph.ttl = p->iph.ttl;
-- 
2.31.1

