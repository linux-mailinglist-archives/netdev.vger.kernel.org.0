Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5557F092
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfD3GiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:38:00 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48836 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfD3Ghi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EB13220268;
        Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Sdwy3X5Ebg4B; Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3C79B20275;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2AB6D318060B;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/18] xfrm: remove input2 indirection from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:18 +0200
Message-ID: <20190430063727.10908-10-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: 834C4980-A95A-4947-A481-F846B28A81F6
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No external dependencies on any module, place this in the core.
Increase is about 1800 byte for xfrm_input.o.

The beet helpers get added to internal header, as they can be reused
from xfrm_output.c in the next patch (kernel contains several
copies of them in the xfrm{4,6}_mode_beet.c files).

Before:
   text    data     bss     dec filename
   5578     176    2364    8118 net/xfrm/xfrm_input.o
   1180      64       0    1244 net/ipv4/xfrm4_mode_beet.o
    171      40       0     211 net/ipv4/xfrm4_mode_transport.o
   1163      40       0    1203 net/ipv4/xfrm4_mode_tunnel.o
   1083      52       0    1135 net/ipv6/xfrm6_mode_beet.o
    172      40       0     212 net/ipv6/xfrm6_mode_ro.o
    172      40       0     212 net/ipv6/xfrm6_mode_transport.o
   1056      40       0    1096 net/ipv6/xfrm6_mode_tunnel.o

After:
   text    data     bss     dec filename
   7373     200    2364    9937 net/xfrm/xfrm_input.o
    587      44       0     631 net/ipv4/xfrm4_mode_beet.o
    171      32       0     203 net/ipv4/xfrm4_mode_transport.o
    649      32       0     681 net/ipv4/xfrm4_mode_tunnel.o
    625      44       0     669 net/ipv6/xfrm6_mode_beet.o
    172      32       0     204 net/ipv6/xfrm6_mode_ro.o
    172      32       0     204 net/ipv6/xfrm6_mode_transport.o
    599      32       0     631 net/ipv6/xfrm6_mode_tunnel.o

v2: pass inner_mode to xfrm_inner_mode_encap_remove to fix
    AF_UNSPEC selector breakage (bisected by Benedict Wong)

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h           |  13 ---
 net/ipv4/xfrm4_mode_beet.c   |  47 ---------
 net/ipv4/xfrm4_mode_tunnel.c |  39 --------
 net/ipv6/xfrm6_mode_beet.c   |  27 -----
 net/ipv6/xfrm6_mode_tunnel.c |  46 ---------
 net/xfrm/xfrm_inout.h        |  38 +++++++
 net/xfrm/xfrm_input.c        | 185 ++++++++++++++++++++++++++++++++++-
 7 files changed, 222 insertions(+), 173 deletions(-)
 create mode 100644 net/xfrm/xfrm_inout.h

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index de103a6d1ef8..bdda545cf740 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -423,19 +423,6 @@ int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned sh
 int xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 
 struct xfrm_mode {
-	/*
-	 * Remove encapsulation header.
-	 *
-	 * The IP header will be moved over the top of the encapsulation
-	 * header.
-	 *
-	 * On entry, the transport header shall point to where the IP header
-	 * should be and the network header shall be set to where the IP
-	 * header currently is.  skb->data shall point to the start of the
-	 * payload.
-	 */
-	int (*input2)(struct xfrm_state *x, struct sk_buff *skb);
-
 	/*
 	 * Add encapsulation header.
 	 *
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
index f02cc8237d54..500960172933 100644
--- a/net/ipv4/xfrm4_mode_beet.c
+++ b/net/ipv4/xfrm4_mode_beet.c
@@ -80,54 +80,7 @@ static int xfrm4_beet_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-static int xfrm4_beet_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct iphdr *iph;
-	int optlen = 0;
-	int err = -EINVAL;
-
-	if (unlikely(XFRM_MODE_SKB_CB(skb)->protocol == IPPROTO_BEETPH)) {
-		struct ip_beet_phdr *ph;
-		int phlen;
-
-		if (!pskb_may_pull(skb, sizeof(*ph)))
-			goto out;
-
-		ph = (struct ip_beet_phdr *)skb->data;
-
-		phlen = sizeof(*ph) + ph->padlen;
-		optlen = ph->hdrlen * 8 + (IPV4_BEET_PHMAXLEN - phlen);
-		if (optlen < 0 || optlen & 3 || optlen > 250)
-			goto out;
-
-		XFRM_MODE_SKB_CB(skb)->protocol = ph->nexthdr;
-
-		if (!pskb_may_pull(skb, phlen))
-			goto out;
-		__skb_pull(skb, phlen);
-	}
-
-	skb_push(skb, sizeof(*iph));
-	skb_reset_network_header(skb);
-	skb_mac_header_rebuild(skb);
-
-	xfrm4_beet_make_header(skb);
-
-	iph = ip_hdr(skb);
-
-	iph->ihl += optlen / 4;
-	iph->tot_len = htons(skb->len);
-	iph->daddr = x->sel.daddr.a4;
-	iph->saddr = x->sel.saddr.a4;
-	iph->check = 0;
-	iph->check = ip_fast_csum(skb_network_header(skb), iph->ihl);
-	err = 0;
-out:
-	return err;
-}
-
 static struct xfrm_mode xfrm4_beet_mode = {
-	.input2 = xfrm4_beet_input,
 	.output2 = xfrm4_beet_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index b5d4ba41758e..31645319aaeb 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -15,14 +15,6 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 
-static inline void ipip_ecn_decapsulate(struct sk_buff *skb)
-{
-	struct iphdr *inner_iph = ipip_hdr(skb);
-
-	if (INET_ECN_is_ce(XFRM_MODE_SKB_CB(skb)->tos))
-		IP_ECN_set_ce(inner_iph);
-}
-
 /* Add encapsulation header.
  *
  * The top IP header will be constructed per RFC 2401.
@@ -71,38 +63,7 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-static int xfrm4_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err = -EINVAL;
-
-	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPIP)
-		goto out;
-
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-		goto out;
-
-	err = skb_unclone(skb, GFP_ATOMIC);
-	if (err)
-		goto out;
-
-	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv4_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipip_hdr(skb));
-	if (!(x->props.flags & XFRM_STATE_NOECN))
-		ipip_ecn_decapsulate(skb);
-
-	skb_reset_network_header(skb);
-	skb_mac_header_rebuild(skb);
-	if (skb->mac_len)
-		eth_hdr(skb)->h_proto = skb->protocol;
-
-	err = 0;
-
-out:
-	return err;
-}
-
 static struct xfrm_mode xfrm4_tunnel_mode = {
-	.input2 = xfrm4_mode_tunnel_input,
 	.output2 = xfrm4_mode_tunnel_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
index 6f35e24f0077..a0537b4f62f8 100644
--- a/net/ipv6/xfrm6_mode_beet.c
+++ b/net/ipv6/xfrm6_mode_beet.c
@@ -76,34 +76,7 @@ static int xfrm6_beet_output(struct xfrm_state *x, struct sk_buff *skb)
 	top_iph->daddr = *(struct in6_addr *)&x->id.daddr;
 	return 0;
 }
-
-static int xfrm6_beet_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct ipv6hdr *ip6h;
-	int size = sizeof(struct ipv6hdr);
-	int err;
-
-	err = skb_cow_head(skb, size + skb->mac_len);
-	if (err)
-		goto out;
-
-	__skb_push(skb, size);
-	skb_reset_network_header(skb);
-	skb_mac_header_rebuild(skb);
-
-	xfrm6_beet_make_header(skb);
-
-	ip6h = ipv6_hdr(skb);
-	ip6h->payload_len = htons(skb->len - size);
-	ip6h->daddr = x->sel.daddr.in6;
-	ip6h->saddr = x->sel.saddr.in6;
-	err = 0;
-out:
-	return err;
-}
-
 static struct xfrm_mode xfrm6_beet_mode = {
-	.input2 = xfrm6_beet_input,
 	.output2 = xfrm6_beet_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 8e23a2fba617..79c57decb472 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -18,14 +18,6 @@
 #include <net/ipv6.h>
 #include <net/xfrm.h>
 
-static inline void ipip6_ecn_decapsulate(struct sk_buff *skb)
-{
-	struct ipv6hdr *inner_iph = ipipv6_hdr(skb);
-
-	if (INET_ECN_is_ce(XFRM_MODE_SKB_CB(skb)->tos))
-		IP6_ECN_set_ce(skb, inner_iph);
-}
-
 /* Add encapsulation header.
  *
  * The top IP header will be constructed per RFC 2401.
@@ -65,45 +57,7 @@ static int xfrm6_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-#define for_each_input_rcu(head, handler)	\
-	for (handler = rcu_dereference(head);	\
-	     handler != NULL;			\
-	     handler = rcu_dereference(handler->next))
-
-
-static int xfrm6_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err = -EINVAL;
-
-	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPV6)
-		goto out;
-	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-		goto out;
-
-	err = skb_unclone(skb, GFP_ATOMIC);
-	if (err)
-		goto out;
-
-	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
-	if (!(x->props.flags & XFRM_STATE_NOECN))
-		ipip6_ecn_decapsulate(skb);
-
-	skb_reset_network_header(skb);
-	skb_mac_header_rebuild(skb);
-	if (skb->mac_len)
-		eth_hdr(skb)->h_proto = skb->protocol;
-
-	err = 0;
-
-out:
-	return err;
-}
-
-
 static struct xfrm_mode xfrm6_tunnel_mode = {
-	.input2 = xfrm6_mode_tunnel_input,
 	.output2 = xfrm6_mode_tunnel_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
diff --git a/net/xfrm/xfrm_inout.h b/net/xfrm/xfrm_inout.h
new file mode 100644
index 000000000000..c7b0318938e2
--- /dev/null
+++ b/net/xfrm/xfrm_inout.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/ipv6.h>
+#include <net/dsfield.h>
+#include <net/xfrm.h>
+
+#ifndef XFRM_INOUT_H
+#define XFRM_INOUT_H 1
+
+static inline void xfrm6_beet_make_header(struct sk_buff *skb)
+{
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+
+	iph->version = 6;
+
+	memcpy(iph->flow_lbl, XFRM_MODE_SKB_CB(skb)->flow_lbl,
+	       sizeof(iph->flow_lbl));
+	iph->nexthdr = XFRM_MODE_SKB_CB(skb)->protocol;
+
+	ipv6_change_dsfield(iph, 0, XFRM_MODE_SKB_CB(skb)->tos);
+	iph->hop_limit = XFRM_MODE_SKB_CB(skb)->ttl;
+}
+
+static inline void xfrm4_beet_make_header(struct sk_buff *skb)
+{
+	struct iphdr *iph = ip_hdr(skb);
+
+	iph->ihl = 5;
+	iph->version = 4;
+
+	iph->protocol = XFRM_MODE_SKB_CB(skb)->protocol;
+	iph->tos = XFRM_MODE_SKB_CB(skb)->tos;
+
+	iph->id = XFRM_MODE_SKB_CB(skb)->id;
+	iph->frag_off = XFRM_MODE_SKB_CB(skb)->frag_off;
+	iph->ttl = XFRM_MODE_SKB_CB(skb)->ttl;
+}
+
+#endif
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 0edf3fb73585..e0fd9561ffe5 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -21,6 +21,8 @@
 #include <net/ip_tunnels.h>
 #include <net/ip6_tunnel.h>
 
+#include "xfrm_inout.h"
+
 struct xfrm_trans_tasklet {
 	struct tasklet_struct tasklet;
 	struct sk_buff_head queue;
@@ -166,6 +168,187 @@ int xfrm_parse_spi(struct sk_buff *skb, u8 nexthdr, __be32 *spi, __be32 *seq)
 }
 EXPORT_SYMBOL(xfrm_parse_spi);
 
+static int xfrm4_remove_beet_encap(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	int optlen = 0;
+	int err = -EINVAL;
+
+	if (unlikely(XFRM_MODE_SKB_CB(skb)->protocol == IPPROTO_BEETPH)) {
+		struct ip_beet_phdr *ph;
+		int phlen;
+
+		if (!pskb_may_pull(skb, sizeof(*ph)))
+			goto out;
+
+		ph = (struct ip_beet_phdr *)skb->data;
+
+		phlen = sizeof(*ph) + ph->padlen;
+		optlen = ph->hdrlen * 8 + (IPV4_BEET_PHMAXLEN - phlen);
+		if (optlen < 0 || optlen & 3 || optlen > 250)
+			goto out;
+
+		XFRM_MODE_SKB_CB(skb)->protocol = ph->nexthdr;
+
+		if (!pskb_may_pull(skb, phlen))
+			goto out;
+		__skb_pull(skb, phlen);
+	}
+
+	skb_push(skb, sizeof(*iph));
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
+	xfrm4_beet_make_header(skb);
+
+	iph = ip_hdr(skb);
+
+	iph->ihl += optlen / 4;
+	iph->tot_len = htons(skb->len);
+	iph->daddr = x->sel.daddr.a4;
+	iph->saddr = x->sel.saddr.a4;
+	iph->check = 0;
+	iph->check = ip_fast_csum(skb_network_header(skb), iph->ihl);
+	err = 0;
+out:
+	return err;
+}
+
+static void ipip_ecn_decapsulate(struct sk_buff *skb)
+{
+	struct iphdr *inner_iph = ipip_hdr(skb);
+
+	if (INET_ECN_is_ce(XFRM_MODE_SKB_CB(skb)->tos))
+		IP_ECN_set_ce(inner_iph);
+}
+
+static int xfrm4_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
+{
+	int err = -EINVAL;
+
+	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPIP)
+		goto out;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto out;
+
+	err = skb_unclone(skb, GFP_ATOMIC);
+	if (err)
+		goto out;
+
+	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
+		ipv4_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipip_hdr(skb));
+	if (!(x->props.flags & XFRM_STATE_NOECN))
+		ipip_ecn_decapsulate(skb);
+
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	if (skb->mac_len)
+		eth_hdr(skb)->h_proto = skb->protocol;
+
+	err = 0;
+
+out:
+	return err;
+}
+
+static void ipip6_ecn_decapsulate(struct sk_buff *skb)
+{
+	struct ipv6hdr *inner_iph = ipipv6_hdr(skb);
+
+	if (INET_ECN_is_ce(XFRM_MODE_SKB_CB(skb)->tos))
+		IP6_ECN_set_ce(skb, inner_iph);
+}
+
+static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
+{
+	int err = -EINVAL;
+
+	if (XFRM_MODE_SKB_CB(skb)->protocol != IPPROTO_IPV6)
+		goto out;
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		goto out;
+
+	err = skb_unclone(skb, GFP_ATOMIC);
+	if (err)
+		goto out;
+
+	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
+		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
+			       ipipv6_hdr(skb));
+	if (!(x->props.flags & XFRM_STATE_NOECN))
+		ipip6_ecn_decapsulate(skb);
+
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	if (skb->mac_len)
+		eth_hdr(skb)->h_proto = skb->protocol;
+
+	err = 0;
+
+out:
+	return err;
+}
+
+static int xfrm6_remove_beet_encap(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct ipv6hdr *ip6h;
+	int size = sizeof(struct ipv6hdr);
+	int err;
+
+	err = skb_cow_head(skb, size + skb->mac_len);
+	if (err)
+		goto out;
+
+	__skb_push(skb, size);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
+	xfrm6_beet_make_header(skb);
+
+	ip6h = ipv6_hdr(skb);
+	ip6h->payload_len = htons(skb->len - size);
+	ip6h->daddr = x->sel.daddr.in6;
+	ip6h->saddr = x->sel.saddr.in6;
+	err = 0;
+out:
+	return err;
+}
+
+/* Remove encapsulation header.
+ *
+ * The IP header will be moved over the top of the encapsulation
+ * header.
+ *
+ * On entry, the transport header shall point to where the IP header
+ * should be and the network header shall be set to where the IP
+ * header currently is.  skb->data shall point to the start of the
+ * payload.
+ */
+static int
+xfrm_inner_mode_encap_remove(struct xfrm_state *x,
+			     const struct xfrm_mode *inner_mode,
+			     struct sk_buff *skb)
+{
+	switch (inner_mode->encap) {
+	case XFRM_MODE_BEET:
+		if (inner_mode->family == AF_INET)
+			return xfrm4_remove_beet_encap(x, skb);
+		if (inner_mode->family == AF_INET6)
+			return xfrm6_remove_beet_encap(x, skb);
+		break;
+	case XFRM_MODE_TUNNEL:
+		if (inner_mode->family == AF_INET)
+			return xfrm4_remove_tunnel_encap(x, skb);
+		if (inner_mode->family == AF_INET6)
+			return xfrm6_remove_tunnel_encap(x, skb);
+		break;
+	}
+
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+}
+
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	struct xfrm_mode *inner_mode = x->inner_mode;
@@ -182,7 +365,7 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 	}
 
 	skb->protocol = inner_mode->afinfo->eth_proto;
-	return inner_mode->input2(x, skb);
+	return xfrm_inner_mode_encap_remove(x, inner_mode, skb);
 }
 
 /* Remove encapsulation header.
-- 
2.17.1

