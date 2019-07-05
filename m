Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE06A60293
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfGEIqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37474 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbfGEIqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1776C20250;
        Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QywbDqBsNcjQ; Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8962A20251;
        Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3DD13318061C;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/9] xfrm: remove init_tempsel indirection from xfrm_state_afinfo
Date:   Fri, 5 Jul 2019 10:46:02 +0200
Message-ID: <20190705084610.3646-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Simple initialization, handle it in the caller.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  2 --
 net/ipv4/xfrm4_state.c | 19 --------------
 net/ipv6/xfrm6_state.c | 21 ----------------
 net/xfrm/xfrm_state.c  | 56 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index a2907873ed56..ba65434b5293 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -354,8 +354,6 @@ struct xfrm_state_afinfo {
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
index 50621d982970..66d9009fe9b5 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -769,6 +769,43 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si)
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
@@ -777,16 +814,21 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
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
2.17.1

