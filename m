Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6666CF093
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfD3GiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:38:01 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48830 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfD3Ghh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B7BD520278;
        Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id we39oN1GUuvU; Tue, 30 Apr 2019 08:37:34 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3A5EC20268;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2F0803180613;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/18] xfrm: remove output2 indirection from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:19 +0200
Message-ID: <20190430063727.10908-11-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 18B5A096-01A9-4DD2-BE57-7C3F7250B5D7
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

similar to previous patch: no external module dependencies,
so we can avoid the indirection by placing this in the core.

This change removes the last indirection from xfrm_mode and the
xfrm4|6_mode_{beet,tunnel}.c modules contain (almost) no code anymore.

Before:
   text    data     bss     dec     hex filename
   3957     136       0    4093     ffd net/xfrm/xfrm_output.o
    587      44       0     631     277 net/ipv4/xfrm4_mode_beet.o
    649      32       0     681     2a9 net/ipv4/xfrm4_mode_tunnel.o
    625      44       0     669     29d net/ipv6/xfrm6_mode_beet.o
    599      32       0     631     277 net/ipv6/xfrm6_mode_tunnel.o
After:
   text    data     bss     dec     hex filename
   5359     184       0    5543    15a7 net/xfrm/xfrm_output.o
    171      24       0     195      c3 net/ipv4/xfrm4_mode_beet.o
    171      24       0     195      c3 net/ipv4/xfrm4_mode_tunnel.o
    172      24       0     196      c4 net/ipv6/xfrm6_mode_beet.o
    172      24       0     196      c4 net/ipv6/xfrm6_mode_tunnel.o

v2: fold the *encap_add functions into xfrm*_prepare_output
    preserve (move) output2 comment (Sabrina)
    use x->outer_mode->encap, not inner
    fix a build breakage on ppc (kbuild robot)

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h           |  13 ---
 net/ipv4/xfrm4_mode_beet.c   |  63 -----------
 net/ipv4/xfrm4_mode_tunnel.c |  49 --------
 net/ipv6/xfrm6_mode_beet.c   |  58 ----------
 net/ipv6/xfrm6_mode_tunnel.c |  36 ------
 net/xfrm/xfrm_output.c       | 212 ++++++++++++++++++++++++++++++++++-
 6 files changed, 207 insertions(+), 224 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index bdda545cf740..4351444c10fc 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -423,19 +423,6 @@ int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned sh
 int xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 
 struct xfrm_mode {
-	/*
-	 * Add encapsulation header.
-	 *
-	 * On exit, the transport header will be set to the start of the
-	 * encapsulation header to be filled in by x->type->output and
-	 * the mac header will be set to the nextheader (protocol for
-	 * IPv4) field of the extension header directly preceding the
-	 * encapsulation header, or in its absence, that of the top IP
-	 * header.  The value of the network header will always point
-	 * to the top IP header while skb->data will point to the payload.
-	 */
-	int (*output2)(struct xfrm_state *x,struct sk_buff *skb);
-
 	struct xfrm_state_afinfo *afinfo;
 	struct module *owner;
 	u8 encap;
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
index 500960172933..ba84b278e627 100644
--- a/net/ipv4/xfrm4_mode_beet.c
+++ b/net/ipv4/xfrm4_mode_beet.c
@@ -17,71 +17,8 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 
-static void xfrm4_beet_make_header(struct sk_buff *skb)
-{
-	struct iphdr *iph = ip_hdr(skb);
-
-	iph->ihl = 5;
-	iph->version = 4;
-
-	iph->protocol = XFRM_MODE_SKB_CB(skb)->protocol;
-	iph->tos = XFRM_MODE_SKB_CB(skb)->tos;
-
-	iph->id = XFRM_MODE_SKB_CB(skb)->id;
-	iph->frag_off = XFRM_MODE_SKB_CB(skb)->frag_off;
-	iph->ttl = XFRM_MODE_SKB_CB(skb)->ttl;
-}
-
-/* Add encapsulation header.
- *
- * The top IP header will be constructed per draft-nikander-esp-beet-mode-06.txt.
- */
-static int xfrm4_beet_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct ip_beet_phdr *ph;
-	struct iphdr *top_iph;
-	int hdrlen, optlen;
-
-	hdrlen = 0;
-	optlen = XFRM_MODE_SKB_CB(skb)->optlen;
-	if (unlikely(optlen))
-		hdrlen += IPV4_BEET_PHMAXLEN - (optlen & 4);
-
-	skb_set_network_header(skb, -x->props.header_len -
-				    hdrlen + (XFRM_MODE_SKB_CB(skb)->ihl - sizeof(*top_iph)));
-	if (x->sel.family != AF_INET6)
-		skb->network_header += IPV4_BEET_PHMAXLEN;
-	skb->mac_header = skb->network_header +
-			  offsetof(struct iphdr, protocol);
-	skb->transport_header = skb->network_header + sizeof(*top_iph);
-
-	xfrm4_beet_make_header(skb);
-
-	ph = __skb_pull(skb, XFRM_MODE_SKB_CB(skb)->ihl - hdrlen);
-
-	top_iph = ip_hdr(skb);
-
-	if (unlikely(optlen)) {
-		BUG_ON(optlen < 0);
-
-		ph->padlen = 4 - (optlen & 4);
-		ph->hdrlen = optlen / 8;
-		ph->nexthdr = top_iph->protocol;
-		if (ph->padlen)
-			memset(ph + 1, IPOPT_NOP, ph->padlen);
-
-		top_iph->protocol = IPPROTO_BEETPH;
-		top_iph->ihl = sizeof(struct iphdr) / 4;
-	}
-
-	top_iph->saddr = x->props.saddr.a4;
-	top_iph->daddr = x->id.daddr.a4;
-
-	return 0;
-}
 
 static struct xfrm_mode xfrm4_beet_mode = {
-	.output2 = xfrm4_beet_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 31645319aaeb..b2b132c800fc 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -15,56 +15,7 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 
-/* Add encapsulation header.
- *
- * The top IP header will be constructed per RFC 2401.
- */
-static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct dst_entry *dst = skb_dst(skb);
-	struct iphdr *top_iph;
-	int flags;
-
-	skb_set_inner_network_header(skb, skb_network_offset(skb));
-	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
-
-	skb_set_network_header(skb, -x->props.header_len);
-	skb->mac_header = skb->network_header +
-			  offsetof(struct iphdr, protocol);
-	skb->transport_header = skb->network_header + sizeof(*top_iph);
-	top_iph = ip_hdr(skb);
-
-	top_iph->ihl = 5;
-	top_iph->version = 4;
-
-	top_iph->protocol = xfrm_af2proto(skb_dst(skb)->ops->family);
-
-	/* DS disclosing depends on XFRM_SA_XFLAG_DONT_ENCAP_DSCP */
-	if (x->props.extra_flags & XFRM_SA_XFLAG_DONT_ENCAP_DSCP)
-		top_iph->tos = 0;
-	else
-		top_iph->tos = XFRM_MODE_SKB_CB(skb)->tos;
-	top_iph->tos = INET_ECN_encapsulate(top_iph->tos,
-					    XFRM_MODE_SKB_CB(skb)->tos);
-
-	flags = x->props.flags;
-	if (flags & XFRM_STATE_NOECN)
-		IP_ECN_clear(top_iph);
-
-	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
-		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
-
-	top_iph->ttl = ip4_dst_hoplimit(xfrm_dst_child(dst));
-
-	top_iph->saddr = x->props.saddr.a4;
-	top_iph->daddr = x->id.daddr.a4;
-	ip_select_ident(dev_net(dst->dev), skb, NULL);
-
-	return 0;
-}
-
 static struct xfrm_mode xfrm4_tunnel_mode = {
-	.output2 = xfrm4_mode_tunnel_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
index a0537b4f62f8..1c4a76bdd889 100644
--- a/net/ipv6/xfrm6_mode_beet.c
+++ b/net/ipv6/xfrm6_mode_beet.c
@@ -19,65 +19,7 @@
 #include <net/ipv6.h>
 #include <net/xfrm.h>
 
-static void xfrm6_beet_make_header(struct sk_buff *skb)
-{
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-
-	iph->version = 6;
-
-	memcpy(iph->flow_lbl, XFRM_MODE_SKB_CB(skb)->flow_lbl,
-	       sizeof(iph->flow_lbl));
-	iph->nexthdr = XFRM_MODE_SKB_CB(skb)->protocol;
-
-	ipv6_change_dsfield(iph, 0, XFRM_MODE_SKB_CB(skb)->tos);
-	iph->hop_limit = XFRM_MODE_SKB_CB(skb)->ttl;
-}
-
-/* Add encapsulation header.
- *
- * The top IP header will be constructed per draft-nikander-esp-beet-mode-06.txt.
- */
-static int xfrm6_beet_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct ipv6hdr *top_iph;
-	struct ip_beet_phdr *ph;
-	int optlen, hdr_len;
-
-	hdr_len = 0;
-	optlen = XFRM_MODE_SKB_CB(skb)->optlen;
-	if (unlikely(optlen))
-		hdr_len += IPV4_BEET_PHMAXLEN - (optlen & 4);
-
-	skb_set_network_header(skb, -x->props.header_len - hdr_len);
-	if (x->sel.family != AF_INET6)
-		skb->network_header += IPV4_BEET_PHMAXLEN;
-	skb->mac_header = skb->network_header +
-			  offsetof(struct ipv6hdr, nexthdr);
-	skb->transport_header = skb->network_header + sizeof(*top_iph);
-	ph = __skb_pull(skb, XFRM_MODE_SKB_CB(skb)->ihl - hdr_len);
-
-	xfrm6_beet_make_header(skb);
-
-	top_iph = ipv6_hdr(skb);
-	if (unlikely(optlen)) {
-
-		BUG_ON(optlen < 0);
-
-		ph->padlen = 4 - (optlen & 4);
-		ph->hdrlen = optlen / 8;
-		ph->nexthdr = top_iph->nexthdr;
-		if (ph->padlen)
-			memset(ph + 1, IPOPT_NOP, ph->padlen);
-
-		top_iph->nexthdr = IPPROTO_BEETPH;
-	}
-
-	top_iph->saddr = *(struct in6_addr *)&x->props.saddr;
-	top_iph->daddr = *(struct in6_addr *)&x->id.daddr;
-	return 0;
-}
 static struct xfrm_mode xfrm6_beet_mode = {
-	.output2 = xfrm6_beet_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 79c57decb472..e5c928dd70e3 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -22,43 +22,7 @@
  *
  * The top IP header will be constructed per RFC 2401.
  */
-static int xfrm6_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct dst_entry *dst = skb_dst(skb);
-	struct ipv6hdr *top_iph;
-	int dsfield;
-
-	skb_set_inner_network_header(skb, skb_network_offset(skb));
-	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
-
-	skb_set_network_header(skb, -x->props.header_len);
-	skb->mac_header = skb->network_header +
-			  offsetof(struct ipv6hdr, nexthdr);
-	skb->transport_header = skb->network_header + sizeof(*top_iph);
-	top_iph = ipv6_hdr(skb);
-
-	top_iph->version = 6;
-
-	memcpy(top_iph->flow_lbl, XFRM_MODE_SKB_CB(skb)->flow_lbl,
-	       sizeof(top_iph->flow_lbl));
-	top_iph->nexthdr = xfrm_af2proto(skb_dst(skb)->ops->family);
-
-	if (x->props.extra_flags & XFRM_SA_XFLAG_DONT_ENCAP_DSCP)
-		dsfield = 0;
-	else
-		dsfield = XFRM_MODE_SKB_CB(skb)->tos;
-	dsfield = INET_ECN_encapsulate(dsfield, XFRM_MODE_SKB_CB(skb)->tos);
-	if (x->props.flags & XFRM_STATE_NOECN)
-		dsfield &= ~INET_ECN_MASK;
-	ipv6_change_dsfield(top_iph, 0, dsfield);
-	top_iph->hop_limit = ip6_dst_hoplimit(xfrm_dst_child(dst));
-	top_iph->saddr = *(struct in6_addr *)&x->props.saddr;
-	top_iph->daddr = *(struct in6_addr *)&x->id.daddr;
-	return 0;
-}
-
 static struct xfrm_mode xfrm6_tunnel_mode = {
-	.output2 = xfrm6_mode_tunnel_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 05926dcf5d17..9bdf16f13606 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -17,8 +17,11 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <net/dst.h>
+#include <net/inet_ecn.h>
 #include <net/xfrm.h>
 
+#include "xfrm_inout.h"
+
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb);
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 
@@ -141,6 +144,190 @@ static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
 #endif
 }
 
+/* Add encapsulation header.
+ *
+ * The top IP header will be constructed per draft-nikander-esp-beet-mode-06.txt.
+ */
+static int xfrm4_beet_encap_add(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct ip_beet_phdr *ph;
+	struct iphdr *top_iph;
+	int hdrlen, optlen;
+
+	hdrlen = 0;
+	optlen = XFRM_MODE_SKB_CB(skb)->optlen;
+	if (unlikely(optlen))
+		hdrlen += IPV4_BEET_PHMAXLEN - (optlen & 4);
+
+	skb_set_network_header(skb, -x->props.header_len - hdrlen +
+			       (XFRM_MODE_SKB_CB(skb)->ihl - sizeof(*top_iph)));
+	if (x->sel.family != AF_INET6)
+		skb->network_header += IPV4_BEET_PHMAXLEN;
+	skb->mac_header = skb->network_header +
+			  offsetof(struct iphdr, protocol);
+	skb->transport_header = skb->network_header + sizeof(*top_iph);
+
+	xfrm4_beet_make_header(skb);
+
+	ph = __skb_pull(skb, XFRM_MODE_SKB_CB(skb)->ihl - hdrlen);
+
+	top_iph = ip_hdr(skb);
+
+	if (unlikely(optlen)) {
+		if (WARN_ON(optlen < 0))
+			return -EINVAL;
+
+		ph->padlen = 4 - (optlen & 4);
+		ph->hdrlen = optlen / 8;
+		ph->nexthdr = top_iph->protocol;
+		if (ph->padlen)
+			memset(ph + 1, IPOPT_NOP, ph->padlen);
+
+		top_iph->protocol = IPPROTO_BEETPH;
+		top_iph->ihl = sizeof(struct iphdr) / 4;
+	}
+
+	top_iph->saddr = x->props.saddr.a4;
+	top_iph->daddr = x->id.daddr.a4;
+
+	return 0;
+}
+
+/* Add encapsulation header.
+ *
+ * The top IP header will be constructed per RFC 2401.
+ */
+static int xfrm4_tunnel_encap_add(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct iphdr *top_iph;
+	int flags;
+
+	skb_set_inner_network_header(skb, skb_network_offset(skb));
+	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
+
+	skb_set_network_header(skb, -x->props.header_len);
+	skb->mac_header = skb->network_header +
+			  offsetof(struct iphdr, protocol);
+	skb->transport_header = skb->network_header + sizeof(*top_iph);
+	top_iph = ip_hdr(skb);
+
+	top_iph->ihl = 5;
+	top_iph->version = 4;
+
+	top_iph->protocol = xfrm_af2proto(skb_dst(skb)->ops->family);
+
+	/* DS disclosing depends on XFRM_SA_XFLAG_DONT_ENCAP_DSCP */
+	if (x->props.extra_flags & XFRM_SA_XFLAG_DONT_ENCAP_DSCP)
+		top_iph->tos = 0;
+	else
+		top_iph->tos = XFRM_MODE_SKB_CB(skb)->tos;
+	top_iph->tos = INET_ECN_encapsulate(top_iph->tos,
+					    XFRM_MODE_SKB_CB(skb)->tos);
+
+	flags = x->props.flags;
+	if (flags & XFRM_STATE_NOECN)
+		IP_ECN_clear(top_iph);
+
+	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
+		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
+
+	top_iph->ttl = ip4_dst_hoplimit(xfrm_dst_child(dst));
+
+	top_iph->saddr = x->props.saddr.a4;
+	top_iph->daddr = x->id.daddr.a4;
+	ip_select_ident(dev_net(dst->dev), skb, NULL);
+
+	return 0;
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static int xfrm6_tunnel_encap_add(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct ipv6hdr *top_iph;
+	int dsfield;
+
+	skb_set_inner_network_header(skb, skb_network_offset(skb));
+	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
+
+	skb_set_network_header(skb, -x->props.header_len);
+	skb->mac_header = skb->network_header +
+			  offsetof(struct ipv6hdr, nexthdr);
+	skb->transport_header = skb->network_header + sizeof(*top_iph);
+	top_iph = ipv6_hdr(skb);
+
+	top_iph->version = 6;
+
+	memcpy(top_iph->flow_lbl, XFRM_MODE_SKB_CB(skb)->flow_lbl,
+	       sizeof(top_iph->flow_lbl));
+	top_iph->nexthdr = xfrm_af2proto(skb_dst(skb)->ops->family);
+
+	if (x->props.extra_flags & XFRM_SA_XFLAG_DONT_ENCAP_DSCP)
+		dsfield = 0;
+	else
+		dsfield = XFRM_MODE_SKB_CB(skb)->tos;
+	dsfield = INET_ECN_encapsulate(dsfield, XFRM_MODE_SKB_CB(skb)->tos);
+	if (x->props.flags & XFRM_STATE_NOECN)
+		dsfield &= ~INET_ECN_MASK;
+	ipv6_change_dsfield(top_iph, 0, dsfield);
+	top_iph->hop_limit = ip6_dst_hoplimit(xfrm_dst_child(dst));
+	top_iph->saddr = *(struct in6_addr *)&x->props.saddr;
+	top_iph->daddr = *(struct in6_addr *)&x->id.daddr;
+	return 0;
+}
+
+static int xfrm6_beet_encap_add(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct ipv6hdr *top_iph;
+	struct ip_beet_phdr *ph;
+	int optlen, hdr_len;
+
+	hdr_len = 0;
+	optlen = XFRM_MODE_SKB_CB(skb)->optlen;
+	if (unlikely(optlen))
+		hdr_len += IPV4_BEET_PHMAXLEN - (optlen & 4);
+
+	skb_set_network_header(skb, -x->props.header_len - hdr_len);
+	if (x->sel.family != AF_INET6)
+		skb->network_header += IPV4_BEET_PHMAXLEN;
+	skb->mac_header = skb->network_header +
+			  offsetof(struct ipv6hdr, nexthdr);
+	skb->transport_header = skb->network_header + sizeof(*top_iph);
+	ph = __skb_pull(skb, XFRM_MODE_SKB_CB(skb)->ihl - hdr_len);
+
+	xfrm6_beet_make_header(skb);
+
+	top_iph = ipv6_hdr(skb);
+	if (unlikely(optlen)) {
+		if (WARN_ON(optlen < 0))
+			return -EINVAL;
+
+		ph->padlen = 4 - (optlen & 4);
+		ph->hdrlen = optlen / 8;
+		ph->nexthdr = top_iph->nexthdr;
+		if (ph->padlen)
+			memset(ph + 1, IPOPT_NOP, ph->padlen);
+
+		top_iph->nexthdr = IPPROTO_BEETPH;
+	}
+
+	top_iph->saddr = *(struct in6_addr *)&x->props.saddr;
+	top_iph->daddr = *(struct in6_addr *)&x->id.daddr;
+	return 0;
+}
+#endif
+
+/* Add encapsulation header.
+ *
+ * On exit, the transport header will be set to the start of the
+ * encapsulation header to be filled in by x->type->output and the mac
+ * header will be set to the nextheader (protocol for IPv4) field of the
+ * extension header directly preceding the encapsulation header, or in
+ * its absence, that of the top IP header.
+ * The value of the network header will always point to the top IP header
+ * while skb->data will point to the payload.
+ */
 static int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err;
@@ -152,7 +339,15 @@ static int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 	IPCB(skb)->flags |= IPSKB_XFRM_TUNNEL_SIZE;
 	skb->protocol = htons(ETH_P_IP);
 
-	return x->outer_mode->output2(x, skb);
+	switch (x->outer_mode->encap) {
+	case XFRM_MODE_BEET:
+		return xfrm4_beet_encap_add(x, skb);
+	case XFRM_MODE_TUNNEL:
+		return xfrm4_tunnel_encap_add(x, skb);
+	}
+
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
 }
 
 static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
@@ -167,11 +362,18 @@ static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 	skb->ignore_df = 1;
 	skb->protocol = htons(ETH_P_IPV6);
 
-	return x->outer_mode->output2(x, skb);
-#else
-	WARN_ON_ONCE(1);
-	return -EOPNOTSUPP;
+	switch (x->outer_mode->encap) {
+	case XFRM_MODE_BEET:
+		return xfrm6_beet_encap_add(x, skb);
+	case XFRM_MODE_TUNNEL:
+		return xfrm6_tunnel_encap_add(x, skb);
+	default:
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
 #endif
+	WARN_ON_ONCE(1);
+	return -EAFNOSUPPORT;
 }
 
 static int xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
-- 
2.17.1

