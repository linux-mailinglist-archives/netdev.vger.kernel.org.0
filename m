Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76913172
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfECPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:50:34 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51980 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728130AbfECPue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:50:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hMaSF-0004WW-H9; Fri, 03 May 2019 17:50:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 2/6] xfrm: remove init_temprop indirection from xfrm_state_afinfo
Date:   Fri,  3 May 2019 17:46:15 +0200
Message-Id: <20190503154619.32352-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190503154619.32352-1-fw@strlen.de>
References: <20190503154619.32352-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

same as previous patch: just place this in the caller, no need to
have an indirection for a structure initialization.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  4 ----
 net/ipv4/xfrm4_state.c | 16 ----------------
 net/ipv6/xfrm6_state.c | 16 ----------------
 net/xfrm/xfrm_state.c  | 27 ++++++++++++++++++++-------
 4 files changed, 20 insertions(+), 43 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9f97e6c1f3ee..8ac6d4d617cc 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -353,10 +353,6 @@ struct xfrm_state_afinfo {
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
index f93c6dc57754..42662d9e8b5e 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -810,8 +810,6 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 		    const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    unsigned short family)
 {
-	struct xfrm_state_afinfo *afinfo = xfrm_state_afinfo_get_rcu(family);
-
 	switch (family) {
 	case AF_INET:
 		__xfrm4_init_tempsel(&x->sel, fl);
@@ -821,13 +819,28 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
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
2.21.0

