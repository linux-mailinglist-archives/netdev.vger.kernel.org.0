Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA6F08A
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfD3Gho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:44 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48886 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfD3Ghl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F22C720279;
        Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FDnNeZFZlRgZ; Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7421E20280;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:32 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4C2633180685;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 17/18] xfrm: remove decode_session indirection from afinfo_policy
Date:   Tue, 30 Apr 2019 08:37:26 +0200
Message-ID: <20190430063727.10908-18-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: FF060B61-A155-44BB-850F-3DF57094911A
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No external dependencies, might as well handle this directly.
xfrm_afinfo_policy is now 40 bytes on x86_64.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |   3 -
 net/ipv4/xfrm4_policy.c | 114 --------------------
 net/ipv6/xfrm6_policy.c | 106 ------------------
 net/xfrm/xfrm_policy.c  | 231 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 222 insertions(+), 232 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b8de1622141a..18d6b33501b9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -326,9 +326,6 @@ struct xfrm_policy_afinfo {
 					     xfrm_address_t *saddr,
 					     xfrm_address_t *daddr,
 					     u32 mark);
-	void			(*decode_session)(struct sk_buff *skb,
-						  struct flowi *fl,
-						  int reverse);
 	int			(*fill_dst)(struct xfrm_dst *xdst,
 					    struct net_device *dev,
 					    const struct flowi *fl);
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 6e89378668ae..414ab0420604 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -12,7 +12,6 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/inetdevice.h>
-#include <linux/if_tunnel.h>
 #include <net/dst.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
@@ -96,118 +95,6 @@ static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	return 0;
 }
 
-static void
-_decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-	u8 *xprth = skb_network_header(skb) + iph->ihl * 4;
-	struct flowi4 *fl4 = &fl->u.ip4;
-	int oif = 0;
-
-	if (skb_dst(skb))
-		oif = skb_dst(skb)->dev->ifindex;
-
-	memset(fl4, 0, sizeof(struct flowi4));
-	fl4->flowi4_mark = skb->mark;
-	fl4->flowi4_oif = reverse ? skb->skb_iif : oif;
-
-	if (!ip_is_fragment(iph)) {
-		switch (iph->protocol) {
-		case IPPROTO_UDP:
-		case IPPROTO_UDPLITE:
-		case IPPROTO_TCP:
-		case IPPROTO_SCTP:
-		case IPPROTO_DCCP:
-			if (xprth + 4 < skb->data ||
-			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be16 *ports;
-
-				xprth = skb_network_header(skb) + iph->ihl * 4;
-				ports = (__be16 *)xprth;
-
-				fl4->fl4_sport = ports[!!reverse];
-				fl4->fl4_dport = ports[!reverse];
-			}
-			break;
-
-		case IPPROTO_ICMP:
-			if (xprth + 2 < skb->data ||
-			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
-				u8 *icmp;
-
-				xprth = skb_network_header(skb) + iph->ihl * 4;
-				icmp = xprth;
-
-				fl4->fl4_icmp_type = icmp[0];
-				fl4->fl4_icmp_code = icmp[1];
-			}
-			break;
-
-		case IPPROTO_ESP:
-			if (xprth + 4 < skb->data ||
-			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be32 *ehdr;
-
-				xprth = skb_network_header(skb) + iph->ihl * 4;
-				ehdr = (__be32 *)xprth;
-
-				fl4->fl4_ipsec_spi = ehdr[0];
-			}
-			break;
-
-		case IPPROTO_AH:
-			if (xprth + 8 < skb->data ||
-			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
-				__be32 *ah_hdr;
-
-				xprth = skb_network_header(skb) + iph->ihl * 4;
-				ah_hdr = (__be32 *)xprth;
-
-				fl4->fl4_ipsec_spi = ah_hdr[1];
-			}
-			break;
-
-		case IPPROTO_COMP:
-			if (xprth + 4 < skb->data ||
-			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be16 *ipcomp_hdr;
-
-				xprth = skb_network_header(skb) + iph->ihl * 4;
-				ipcomp_hdr = (__be16 *)xprth;
-
-				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
-			}
-			break;
-
-		case IPPROTO_GRE:
-			if (xprth + 12 < skb->data ||
-			    pskb_may_pull(skb, xprth + 12 - skb->data)) {
-				__be16 *greflags;
-				__be32 *gre_hdr;
-
-				xprth = skb_network_header(skb) + iph->ihl * 4;
-				greflags = (__be16 *)xprth;
-				gre_hdr = (__be32 *)xprth;
-
-				if (greflags[0] & GRE_KEY) {
-					if (greflags[0] & GRE_CSUM)
-						gre_hdr++;
-					fl4->fl4_gre_key = gre_hdr[1];
-				}
-			}
-			break;
-
-		default:
-			fl4->fl4_ipsec_spi = 0;
-			break;
-		}
-	}
-	fl4->flowi4_proto = iph->protocol;
-	fl4->daddr = reverse ? iph->saddr : iph->daddr;
-	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
-}
-
 static void xfrm4_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			      struct sk_buff *skb, u32 mtu)
 {
@@ -260,7 +147,6 @@ static const struct xfrm_policy_afinfo xfrm4_policy_afinfo = {
 	.dst_ops =		&xfrm4_dst_ops_template,
 	.dst_lookup =		xfrm4_dst_lookup,
 	.get_saddr =		xfrm4_get_saddr,
-	.decode_session =	_decode_session4,
 	.fill_dst =		xfrm4_fill_dst,
 	.blackhole_route =	ipv4_blackhole_route,
 };
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 358e834fedce..699e0730ce8e 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -22,9 +22,6 @@
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/l3mdev.h>
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-#include <net/mip6.h>
-#endif
 
 static struct dst_entry *xfrm6_dst_lookup(struct net *net, int tos, int oif,
 					  const xfrm_address_t *saddr,
@@ -100,108 +97,6 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	return 0;
 }
 
-static inline void
-_decode_session6(struct sk_buff *skb, struct flowi *fl, int reverse)
-{
-	struct flowi6 *fl6 = &fl->u.ip6;
-	int onlyproto = 0;
-	const struct ipv6hdr *hdr = ipv6_hdr(skb);
-	u32 offset = sizeof(*hdr);
-	struct ipv6_opt_hdr *exthdr;
-	const unsigned char *nh = skb_network_header(skb);
-	u16 nhoff = IP6CB(skb)->nhoff;
-	int oif = 0;
-	u8 nexthdr;
-
-	if (!nhoff)
-		nhoff = offsetof(struct ipv6hdr, nexthdr);
-
-	nexthdr = nh[nhoff];
-
-	if (skb_dst(skb))
-		oif = skb_dst(skb)->dev->ifindex;
-
-	memset(fl6, 0, sizeof(struct flowi6));
-	fl6->flowi6_mark = skb->mark;
-	fl6->flowi6_oif = reverse ? skb->skb_iif : oif;
-
-	fl6->daddr = reverse ? hdr->saddr : hdr->daddr;
-	fl6->saddr = reverse ? hdr->daddr : hdr->saddr;
-
-	while (nh + offset + sizeof(*exthdr) < skb->data ||
-	       pskb_may_pull(skb, nh + offset + sizeof(*exthdr) - skb->data)) {
-		nh = skb_network_header(skb);
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
-
-		switch (nexthdr) {
-		case NEXTHDR_FRAGMENT:
-			onlyproto = 1;
-			/* fall through */
-		case NEXTHDR_ROUTING:
-		case NEXTHDR_HOP:
-		case NEXTHDR_DEST:
-			offset += ipv6_optlen(exthdr);
-			nexthdr = exthdr->nexthdr;
-			exthdr = (struct ipv6_opt_hdr *)(nh + offset);
-			break;
-
-		case IPPROTO_UDP:
-		case IPPROTO_UDPLITE:
-		case IPPROTO_TCP:
-		case IPPROTO_SCTP:
-		case IPPROTO_DCCP:
-			if (!onlyproto && (nh + offset + 4 < skb->data ||
-			     pskb_may_pull(skb, nh + offset + 4 - skb->data))) {
-				__be16 *ports;
-
-				nh = skb_network_header(skb);
-				ports = (__be16 *)(nh + offset);
-				fl6->fl6_sport = ports[!!reverse];
-				fl6->fl6_dport = ports[!reverse];
-			}
-			fl6->flowi6_proto = nexthdr;
-			return;
-
-		case IPPROTO_ICMPV6:
-			if (!onlyproto && (nh + offset + 2 < skb->data ||
-			    pskb_may_pull(skb, nh + offset + 2 - skb->data))) {
-				u8 *icmp;
-
-				nh = skb_network_header(skb);
-				icmp = (u8 *)(nh + offset);
-				fl6->fl6_icmp_type = icmp[0];
-				fl6->fl6_icmp_code = icmp[1];
-			}
-			fl6->flowi6_proto = nexthdr;
-			return;
-
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		case IPPROTO_MH:
-			offset += ipv6_optlen(exthdr);
-			if (!onlyproto && (nh + offset + 3 < skb->data ||
-			    pskb_may_pull(skb, nh + offset + 3 - skb->data))) {
-				struct ip6_mh *mh;
-
-				nh = skb_network_header(skb);
-				mh = (struct ip6_mh *)(nh + offset);
-				fl6->fl6_mh_type = mh->ip6mh_type;
-			}
-			fl6->flowi6_proto = nexthdr;
-			return;
-#endif
-
-		/* XXX Why are there these headers? */
-		case IPPROTO_AH:
-		case IPPROTO_ESP:
-		case IPPROTO_COMP:
-		default:
-			fl6->fl6_ipsec_spi = 0;
-			fl6->flowi6_proto = nexthdr;
-			return;
-		}
-	}
-}
-
 static void xfrm6_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			      struct sk_buff *skb, u32 mtu)
 {
@@ -273,7 +168,6 @@ static const struct xfrm_policy_afinfo xfrm6_policy_afinfo = {
 	.dst_ops =		&xfrm6_dst_ops_template,
 	.dst_lookup =		xfrm6_dst_lookup,
 	.get_saddr =		xfrm6_get_saddr,
-	.decode_session =	_decode_session6,
 	.fill_dst =		xfrm6_fill_dst,
 	.blackhole_route =	ip6_blackhole_route,
 };
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 5359c312f016..03b6bf85d70b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -27,10 +27,14 @@
 #include <linux/cpu.h>
 #include <linux/audit.h>
 #include <linux/rhashtable.h>
+#include <linux/if_tunnel.h>
 #include <net/dst.h>
 #include <net/flow.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+#include <net/mip6.h>
+#endif
 #ifdef CONFIG_XFRM_STATISTICS
 #include <net/snmp.h>
 #endif
@@ -3256,20 +3260,229 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 	return start;
 }
 
+static void
+decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	u8 *xprth = skb_network_header(skb) + iph->ihl * 4;
+	struct flowi4 *fl4 = &fl->u.ip4;
+	int oif = 0;
+
+	if (skb_dst(skb))
+		oif = skb_dst(skb)->dev->ifindex;
+
+	memset(fl4, 0, sizeof(struct flowi4));
+	fl4->flowi4_mark = skb->mark;
+	fl4->flowi4_oif = reverse ? skb->skb_iif : oif;
+
+	if (!ip_is_fragment(iph)) {
+		switch (iph->protocol) {
+		case IPPROTO_UDP:
+		case IPPROTO_UDPLITE:
+		case IPPROTO_TCP:
+		case IPPROTO_SCTP:
+		case IPPROTO_DCCP:
+			if (xprth + 4 < skb->data ||
+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
+				__be16 *ports;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ports = (__be16 *)xprth;
+
+				fl4->fl4_sport = ports[!!reverse];
+				fl4->fl4_dport = ports[!reverse];
+			}
+			break;
+		case IPPROTO_ICMP:
+			if (xprth + 2 < skb->data ||
+			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
+				u8 *icmp;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				icmp = xprth;
+
+				fl4->fl4_icmp_type = icmp[0];
+				fl4->fl4_icmp_code = icmp[1];
+			}
+			break;
+		case IPPROTO_ESP:
+			if (xprth + 4 < skb->data ||
+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
+				__be32 *ehdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ehdr = (__be32 *)xprth;
+
+				fl4->fl4_ipsec_spi = ehdr[0];
+			}
+			break;
+		case IPPROTO_AH:
+			if (xprth + 8 < skb->data ||
+			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
+				__be32 *ah_hdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ah_hdr = (__be32 *)xprth;
+
+				fl4->fl4_ipsec_spi = ah_hdr[1];
+			}
+			break;
+		case IPPROTO_COMP:
+			if (xprth + 4 < skb->data ||
+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
+				__be16 *ipcomp_hdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ipcomp_hdr = (__be16 *)xprth;
+
+				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
+			}
+			break;
+		case IPPROTO_GRE:
+			if (xprth + 12 < skb->data ||
+			    pskb_may_pull(skb, xprth + 12 - skb->data)) {
+				__be16 *greflags;
+				__be32 *gre_hdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				greflags = (__be16 *)xprth;
+				gre_hdr = (__be32 *)xprth;
+
+				if (greflags[0] & GRE_KEY) {
+					if (greflags[0] & GRE_CSUM)
+						gre_hdr++;
+					fl4->fl4_gre_key = gre_hdr[1];
+				}
+			}
+			break;
+		default:
+			fl4->fl4_ipsec_spi = 0;
+			break;
+		}
+	}
+	fl4->flowi4_proto = iph->protocol;
+	fl4->daddr = reverse ? iph->saddr : iph->daddr;
+	fl4->saddr = reverse ? iph->daddr : iph->saddr;
+	fl4->flowi4_tos = iph->tos;
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static void
+decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
+{
+	struct flowi6 *fl6 = &fl->u.ip6;
+	int onlyproto = 0;
+	const struct ipv6hdr *hdr = ipv6_hdr(skb);
+	u32 offset = sizeof(*hdr);
+	struct ipv6_opt_hdr *exthdr;
+	const unsigned char *nh = skb_network_header(skb);
+	u16 nhoff = IP6CB(skb)->nhoff;
+	int oif = 0;
+	u8 nexthdr;
+
+	if (!nhoff)
+		nhoff = offsetof(struct ipv6hdr, nexthdr);
+
+	nexthdr = nh[nhoff];
+
+	if (skb_dst(skb))
+		oif = skb_dst(skb)->dev->ifindex;
+
+	memset(fl6, 0, sizeof(struct flowi6));
+	fl6->flowi6_mark = skb->mark;
+	fl6->flowi6_oif = reverse ? skb->skb_iif : oif;
+
+	fl6->daddr = reverse ? hdr->saddr : hdr->daddr;
+	fl6->saddr = reverse ? hdr->daddr : hdr->saddr;
+
+	while (nh + offset + sizeof(*exthdr) < skb->data ||
+	       pskb_may_pull(skb, nh + offset + sizeof(*exthdr) - skb->data)) {
+		nh = skb_network_header(skb);
+		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
+
+		switch (nexthdr) {
+		case NEXTHDR_FRAGMENT:
+			onlyproto = 1;
+			/* fall through */
+		case NEXTHDR_ROUTING:
+		case NEXTHDR_HOP:
+		case NEXTHDR_DEST:
+			offset += ipv6_optlen(exthdr);
+			nexthdr = exthdr->nexthdr;
+			exthdr = (struct ipv6_opt_hdr *)(nh + offset);
+			break;
+		case IPPROTO_UDP:
+		case IPPROTO_UDPLITE:
+		case IPPROTO_TCP:
+		case IPPROTO_SCTP:
+		case IPPROTO_DCCP:
+			if (!onlyproto && (nh + offset + 4 < skb->data ||
+			     pskb_may_pull(skb, nh + offset + 4 - skb->data))) {
+				__be16 *ports;
+
+				nh = skb_network_header(skb);
+				ports = (__be16 *)(nh + offset);
+				fl6->fl6_sport = ports[!!reverse];
+				fl6->fl6_dport = ports[!reverse];
+			}
+			fl6->flowi6_proto = nexthdr;
+			return;
+		case IPPROTO_ICMPV6:
+			if (!onlyproto && (nh + offset + 2 < skb->data ||
+			    pskb_may_pull(skb, nh + offset + 2 - skb->data))) {
+				u8 *icmp;
+
+				nh = skb_network_header(skb);
+				icmp = (u8 *)(nh + offset);
+				fl6->fl6_icmp_type = icmp[0];
+				fl6->fl6_icmp_code = icmp[1];
+			}
+			fl6->flowi6_proto = nexthdr;
+			return;
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+		case IPPROTO_MH:
+			offset += ipv6_optlen(exthdr);
+			if (!onlyproto && (nh + offset + 3 < skb->data ||
+			    pskb_may_pull(skb, nh + offset + 3 - skb->data))) {
+				struct ip6_mh *mh;
+
+				nh = skb_network_header(skb);
+				mh = (struct ip6_mh *)(nh + offset);
+				fl6->fl6_mh_type = mh->ip6mh_type;
+			}
+			fl6->flowi6_proto = nexthdr;
+			return;
+#endif
+		/* XXX Why are there these headers? */
+		case IPPROTO_AH:
+		case IPPROTO_ESP:
+		case IPPROTO_COMP:
+		default:
+			fl6->fl6_ipsec_spi = 0;
+			fl6->flowi6_proto = nexthdr;
+			return;
+		}
+	}
+}
+#endif
+
 int __xfrm_decode_session(struct sk_buff *skb, struct flowi *fl,
 			  unsigned int family, int reverse)
 {
-	const struct xfrm_policy_afinfo *afinfo = xfrm_policy_get_afinfo(family);
-	int err;
-
-	if (unlikely(afinfo == NULL))
+	switch (family) {
+	case AF_INET:
+		decode_session4(skb, fl, reverse);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		decode_session6(skb, fl, reverse);
+		break;
+#endif
+	default:
 		return -EAFNOSUPPORT;
+	}
 
-	afinfo->decode_session(skb, fl, reverse);
-
-	err = security_xfrm_decode_session(skb, &fl->flowi_secid);
-	rcu_read_unlock();
-	return err;
+	return security_xfrm_decode_session(skb, &fl->flowi_secid);
 }
 EXPORT_SYMBOL(__xfrm_decode_session);
 
-- 
2.17.1

