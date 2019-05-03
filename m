Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0013171
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfECPua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:50:30 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51974 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728130AbfECPu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:50:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hMaSB-0004WE-0Y; Fri, 03 May 2019 17:50:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 1/6] xfrm: remove init_tempsel indirection from xfrm_state_afinfo
Date:   Fri,  3 May 2019 17:46:14 +0200
Message-Id: <20190503154619.32352-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190503154619.32352-1-fw@strlen.de>
References: <20190503154619.32352-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple initialization, handle it in the caller.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  2 --
 net/ipv4/xfrm4_state.c | 19 --------------
 net/ipv6/xfrm6_state.c | 21 ----------------
 net/xfrm/xfrm_state.c  | 56 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index eb5018b1cf9c..9f97e6c1f3ee 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -353,8 +353,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
 	int			(*init_flags)(struct xfrm_state *x);
-	void			(*init_tempsel)(struct xfrm_selector *sel,
-						const struct flowi *fl);
 	void			(*init_temprop)(struct xfrm_state *x,
 						const struct xfrm_tmpl *tmpl,
 						const xfrm_address_t *daddr,
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index 80c40b4981bb..da0fd9556d57 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -22,24 +22,6 @@ static int xfrm4_init_flags(struct xfrm_state *x)
 	return 0;
 }
 
-static void
-__xfrm4_init_tempsel(struct xfrm_selector *sel, const struct flowi *fl)
-{
-	const struct flowi4 *fl4 = &fl->u.ip4;
-
-	sel->daddr.a4 = fl4->daddr;
-	sel->saddr.a4 = fl4->saddr;
-	sel->dport = xfrm_flowi_dport(fl, &fl4->uli);
-	sel->dport_mask = htons(0xffff);
-	sel->sport = xfrm_flowi_sport(fl, &fl4->uli);
-	sel->sport_mask = htons(0xffff);
-	sel->family = AF_INET;
-	sel->prefixlen_d = 32;
-	sel->prefixlen_s = 32;
-	sel->proto = fl4->flowi4_proto;
-	sel->ifindex = fl4->flowi4_oif;
-}
-
 static void
 xfrm4_init_temprop(struct xfrm_state *x, const struct xfrm_tmpl *tmpl,
 		   const xfrm_address_t *daddr, const xfrm_address_t *saddr)
@@ -77,7 +59,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.eth_proto		= htons(ETH_P_IP),
 	.owner			= THIS_MODULE,
 	.init_flags		= xfrm4_init_flags,
-	.init_tempsel		= __xfrm4_init_tempsel,
 	.init_temprop		= xfrm4_init_temprop,
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 5bdca3d5d6b7..0e19ded3e33b 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -21,26 +21,6 @@
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 
-static void
-__xfrm6_init_tempsel(struct xfrm_selector *sel, const struct flowi *fl)
-{
-	const struct flowi6 *fl6 = &fl->u.ip6;
-
-	/* Initialize temporary selector matching only
-	 * to current session. */
-	*(struct in6_addr *)&sel->daddr = fl6->daddr;
-	*(struct in6_addr *)&sel->saddr = fl6->saddr;
-	sel->dport = xfrm_flowi_dport(fl, &fl6->uli);
-	sel->dport_mask = htons(0xffff);
-	sel->sport = xfrm_flowi_sport(fl, &fl6->uli);
-	sel->sport_mask = htons(0xffff);
-	sel->family = AF_INET6;
-	sel->prefixlen_d = 128;
-	sel->prefixlen_s = 128;
-	sel->proto = fl6->flowi6_proto;
-	sel->ifindex = fl6->flowi6_oif;
-}
-
 static void
 xfrm6_init_temprop(struct xfrm_state *x, const struct xfrm_tmpl *tmpl,
 		   const xfrm_address_t *daddr, const xfrm_address_t *saddr)
@@ -173,7 +153,6 @@ static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.proto			= IPPROTO_IPV6,
 	.eth_proto		= htons(ETH_P_IPV6),
 	.owner			= THIS_MODULE,
-	.init_tempsel		= __xfrm6_init_tempsel,
 	.init_temprop		= xfrm6_init_temprop,
 	.tmpl_sort		= __xfrm6_tmpl_sort,
 	.state_sort		= __xfrm6_state_sort,
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ed25eb81aabe..f93c6dc57754 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -767,6 +767,43 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si)
 }
 EXPORT_SYMBOL(xfrm_sad_getinfo);
 
+static void
+__xfrm4_init_tempsel(struct xfrm_selector *sel, const struct flowi *fl)
+{
+	const struct flowi4 *fl4 = &fl->u.ip4;
+
+	sel->daddr.a4 = fl4->daddr;
+	sel->saddr.a4 = fl4->saddr;
+	sel->dport = xfrm_flowi_dport(fl, &fl4->uli);
+	sel->dport_mask = htons(0xffff);
+	sel->sport = xfrm_flowi_sport(fl, &fl4->uli);
+	sel->sport_mask = htons(0xffff);
+	sel->family = AF_INET;
+	sel->prefixlen_d = 32;
+	sel->prefixlen_s = 32;
+	sel->proto = fl4->flowi4_proto;
+	sel->ifindex = fl4->flowi4_oif;
+}
+
+static void
+__xfrm6_init_tempsel(struct xfrm_selector *sel, const struct flowi *fl)
+{
+	const struct flowi6 *fl6 = &fl->u.ip6;
+
+	/* Initialize temporary selector matching only to current session. */
+	*(struct in6_addr *)&sel->daddr = fl6->daddr;
+	*(struct in6_addr *)&sel->saddr = fl6->saddr;
+	sel->dport = xfrm_flowi_dport(fl, &fl6->uli);
+	sel->dport_mask = htons(0xffff);
+	sel->sport = xfrm_flowi_sport(fl, &fl6->uli);
+	sel->sport_mask = htons(0xffff);
+	sel->family = AF_INET6;
+	sel->prefixlen_d = 128;
+	sel->prefixlen_s = 128;
+	sel->proto = fl6->flowi6_proto;
+	sel->ifindex = fl6->flowi6_oif;
+}
+
 static void
 xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 		    const struct xfrm_tmpl *tmpl,
@@ -775,16 +812,21 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 {
 	struct xfrm_state_afinfo *afinfo = xfrm_state_afinfo_get_rcu(family);
 
+	switch (family) {
+	case AF_INET:
+		__xfrm4_init_tempsel(&x->sel, fl);
+		break;
+	case AF_INET6:
+		__xfrm6_init_tempsel(&x->sel, fl);
+		break;
+	}
+
+	if (family != tmpl->encap_family)
+		afinfo = xfrm_state_afinfo_get_rcu(tmpl->encap_family);
+
 	if (!afinfo)
 		return;
 
-	afinfo->init_tempsel(&x->sel, fl);
-
-	if (family != tmpl->encap_family) {
-		afinfo = xfrm_state_afinfo_get_rcu(tmpl->encap_family);
-		if (!afinfo)
-			return;
-	}
 	afinfo->init_temprop(x, tmpl, daddr, saddr);
 }
 
-- 
2.21.0

