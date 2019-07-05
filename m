Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A009760290
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfGEIqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:17 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37452 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfGEIqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8279120255;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8yXUZRYK-2iK; Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 85CBA201F9;
        Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4438A3180684;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/9] xfrm: remove init_temprop indirection from xfrm_state_afinfo
Date:   Fri, 5 Jul 2019 10:46:03 +0200
Message-ID: <20190705084610.3646-3-steffen.klassert@secunet.com>
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

same as previous patch: just place this in the caller, no need to
have an indirection for a structure initialization.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  4 ----
 net/ipv4/xfrm4_state.c | 16 ----------------
 net/ipv6/xfrm6_state.c | 16 ----------------
 net/xfrm/xfrm_state.c  | 27 ++++++++++++++++++++-------
 4 files changed, 20 insertions(+), 43 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index ba65434b5293..e8f676ce27be 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -354,10 +354,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
 	int			(*init_flags)(struct xfrm_state *x);
-	void			(*init_temprop)(struct xfrm_state *x,
-						const struct xfrm_tmpl *tmpl,
-						const xfrm_address_t *daddr,
-						const xfrm_address_t *saddr);
 	int			(*tmpl_sort)(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n);
 	int			(*state_sort)(struct xfrm_state **dst, struct xfrm_state **src, int n);
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index da0fd9556d57..018448e222af 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -22,21 +22,6 @@ static int xfrm4_init_flags(struct xfrm_state *x)
 	return 0;
 }
 
-static void
-xfrm4_init_temprop(struct xfrm_state *x, const struct xfrm_tmpl *tmpl,
-		   const xfrm_address_t *daddr, const xfrm_address_t *saddr)
-{
-	x->id = tmpl->id;
-	if (x->id.daddr.a4 == 0)
-		x->id.daddr.a4 = daddr->a4;
-	x->props.saddr = tmpl->saddr;
-	if (x->props.saddr.a4 == 0)
-		x->props.saddr.a4 = saddr->a4;
-	x->props.mode = tmpl->mode;
-	x->props.reqid = tmpl->reqid;
-	x->props.family = AF_INET;
-}
-
 int xfrm4_extract_header(struct sk_buff *skb)
 {
 	const struct iphdr *iph = ip_hdr(skb);
@@ -59,7 +44,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.eth_proto		= htons(ETH_P_IP),
 	.owner			= THIS_MODULE,
 	.init_flags		= xfrm4_init_flags,
-	.init_temprop		= xfrm4_init_temprop,
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
 	.extract_input		= xfrm4_extract_input,
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 0e19ded3e33b..aa5d2c52cc31 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -21,21 +21,6 @@
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 
-static void
-xfrm6_init_temprop(struct xfrm_state *x, const struct xfrm_tmpl *tmpl,
-		   const xfrm_address_t *daddr, const xfrm_address_t *saddr)
-{
-	x->id = tmpl->id;
-	if (ipv6_addr_any((struct in6_addr *)&x->id.daddr))
-		memcpy(&x->id.daddr, daddr, sizeof(x->sel.daddr));
-	memcpy(&x->props.saddr, &tmpl->saddr, sizeof(x->props.saddr));
-	if (ipv6_addr_any((struct in6_addr *)&x->props.saddr))
-		memcpy(&x->props.saddr, saddr, sizeof(x->props.saddr));
-	x->props.mode = tmpl->mode;
-	x->props.reqid = tmpl->reqid;
-	x->props.family = AF_INET6;
-}
-
 /* distribution counting sort function for xfrm_state and xfrm_tmpl */
 static int
 __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
@@ -153,7 +138,6 @@ static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.proto			= IPPROTO_IPV6,
 	.eth_proto		= htons(ETH_P_IPV6),
 	.owner			= THIS_MODULE,
-	.init_temprop		= xfrm6_init_temprop,
 	.tmpl_sort		= __xfrm6_tmpl_sort,
 	.state_sort		= __xfrm6_state_sort,
 	.output			= xfrm6_output,
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 66d9009fe9b5..336d3f6a1a51 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -812,8 +812,6 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 		    const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    unsigned short family)
 {
-	struct xfrm_state_afinfo *afinfo = xfrm_state_afinfo_get_rcu(family);
-
 	switch (family) {
 	case AF_INET:
 		__xfrm4_init_tempsel(&x->sel, fl);
@@ -823,13 +821,28 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 		break;
 	}
 
-	if (family != tmpl->encap_family)
-		afinfo = xfrm_state_afinfo_get_rcu(tmpl->encap_family);
+	x->id = tmpl->id;
 
-	if (!afinfo)
-		return;
+	switch (tmpl->encap_family) {
+	case AF_INET:
+		if (x->id.daddr.a4 == 0)
+			x->id.daddr.a4 = daddr->a4;
+		x->props.saddr = tmpl->saddr;
+		if (x->props.saddr.a4 == 0)
+			x->props.saddr.a4 = saddr->a4;
+		break;
+	case AF_INET6:
+		if (ipv6_addr_any((struct in6_addr *)&x->id.daddr))
+			memcpy(&x->id.daddr, daddr, sizeof(x->sel.daddr));
+		memcpy(&x->props.saddr, &tmpl->saddr, sizeof(x->props.saddr));
+		if (ipv6_addr_any((struct in6_addr *)&x->props.saddr))
+			memcpy(&x->props.saddr, saddr, sizeof(x->props.saddr));
+		break;
+	}
 
-	afinfo->init_temprop(x, tmpl, daddr, saddr);
+	x->props.mode = tmpl->mode;
+	x->props.reqid = tmpl->reqid;
+	x->props.family = tmpl->encap_family;
 }
 
 static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
-- 
2.17.1

