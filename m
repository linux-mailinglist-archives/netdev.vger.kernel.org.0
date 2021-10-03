Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A50D420378
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhJCSrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:47:48 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39520 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhJCSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 14:47:44 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id E0873200BE68;
        Sun,  3 Oct 2021 20:45:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be E0873200BE68
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633286755;
        bh=akO9WzdXV0uLnhT9TjYz/wK+HTi0rdFVTDgNMGLSpMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxgE+sILl1WSgbl5OsWeOiyfu5GLp21Z9eyu2/sGJYzTsPWfam8DPSiCP/ZUwvPs9
         k22W4QL6gQasnGPmsBKjAY8r70+poCDGmZmF4rEWoNmtwTERuvP3nOBtzTSO6PdWDE
         eoKt9lMn1oEBpYiQJqCF6SeHrq9MKSAe091FTFhOJ0FOWc4yM44VIZKOLrPYjBWn0y
         KL7eMLGI4ZwXLyJT+ejOv4gc0/34PWQlB1ycxSCdfq/ncPVG3bSE5lmRjGfi+WBTvE
         CabO11y3t4O0V250KKvM6jLg/9XzsF6njAsGCLOMDsnblej/jzOoF/Qhh5J5WFvnsm
         pQHP88H6ql+Cg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next v2 3/4] ipv6: ioam: Add support for the ip6ip6 encapsulation
Date:   Sun,  3 Oct 2021 20:45:38 +0200
Message-Id: <20211003184539.23629-4-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003184539.23629-1-justin.iurman@uliege.be>
References: <20211003184539.23629-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the ip6ip6 encapsulation by providing three encap
modes: inline, encap and auto.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/uapi/linux/ioam6_iptunnel.h |  29 ++++
 net/ipv6/Kconfig                    |   6 +-
 net/ipv6/ioam6_iptunnel.c           | 261 ++++++++++++++++++++++------
 3 files changed, 242 insertions(+), 54 deletions(-)

diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
index bae14636a8c8..829ffdfcacca 100644
--- a/include/uapi/linux/ioam6_iptunnel.h
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -9,9 +9,38 @@
 #ifndef _UAPI_LINUX_IOAM6_IPTUNNEL_H
 #define _UAPI_LINUX_IOAM6_IPTUNNEL_H
 
+/* Encap modes:
+ *  - inline: direct insertion
+ *  - encap: ip6ip6 encapsulation
+ *  - auto: inline for local packets, encap for in-transit packets
+ */
+enum {
+	__IOAM6_IPTUNNEL_MODE_MIN,
+
+	IOAM6_IPTUNNEL_MODE_INLINE,
+	IOAM6_IPTUNNEL_MODE_ENCAP,
+	IOAM6_IPTUNNEL_MODE_AUTO,
+
+	__IOAM6_IPTUNNEL_MODE_MAX,
+};
+
+#define IOAM6_IPTUNNEL_MODE_MIN (__IOAM6_IPTUNNEL_MODE_MIN + 1)
+#define IOAM6_IPTUNNEL_MODE_MAX (__IOAM6_IPTUNNEL_MODE_MAX - 1)
+
 enum {
 	IOAM6_IPTUNNEL_UNSPEC,
+
+	/* Encap mode */
+	IOAM6_IPTUNNEL_MODE,		/* u8 */
+
+	/* Tunnel dst address.
+	 * For encap,auto modes.
+	 */
+	IOAM6_IPTUNNEL_DST,		/* struct in6_addr */
+
+	/* IOAM Trace Header */
 	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
+
 	__IOAM6_IPTUNNEL_MAX,
 };
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index e504204bca92..bf2e5e5fe142 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -332,10 +332,10 @@ config IPV6_IOAM6_LWTUNNEL
 	bool "IPv6: IOAM Pre-allocated Trace insertion support"
 	depends on IPV6
 	select LWTUNNEL
+	select DST_CACHE
 	help
-	  Support for the inline insertion of IOAM Pre-allocated
-	  Trace Header (only on locally generated packets), using
-	  the lightweight tunnels mechanism.
+	  Support for the insertion of IOAM Pre-allocated Trace
+	  Header using the lightweight tunnels mechanism.
 
 	  If unsure, say N.
 
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index 5d03101724b9..392c183076ce 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -17,6 +17,10 @@
 #include <net/lwtunnel.h>
 #include <net/ioam6.h>
 #include <net/netlink.h>
+#include <net/ipv6.h>
+#include <net/dst_cache.h>
+#include <net/ip6_route.h>
+#include <net/addrconf.h>
 
 #define IOAM6_MASK_SHORT_FIELDS 0xff100000
 #define IOAM6_MASK_WIDE_FIELDS 0xe00000
@@ -29,6 +33,9 @@ struct ioam6_lwt_encap {
 } __packed;
 
 struct ioam6_lwt {
+	struct dst_cache cache;
+	u8 mode;
+	struct in6_addr tundst;
 	struct ioam6_lwt_encap	tuninfo;
 };
 
@@ -48,6 +55,10 @@ static struct ioam6_trace_hdr *ioam6_lwt_trace(struct lwtunnel_state *lwt)
 }
 
 static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
+	[IOAM6_IPTUNNEL_MODE]	= NLA_POLICY_RANGE(NLA_U8,
+						   IOAM6_IPTUNNEL_MODE_MIN,
+						   IOAM6_IPTUNNEL_MODE_MAX),
+	[IOAM6_IPTUNNEL_DST]	= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
 };
 
@@ -78,9 +89,10 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 	struct nlattr *tb[IOAM6_IPTUNNEL_MAX + 1];
 	struct ioam6_lwt_encap *tuninfo;
 	struct ioam6_trace_hdr *trace;
-	struct lwtunnel_state *s;
-	int len_aligned;
-	int len, err;
+	struct lwtunnel_state *lwt;
+	struct ioam6_lwt *ilwt;
+	int len_aligned, err;
+	u8 mode;
 
 	if (family != AF_INET6)
 		return -EINVAL;
@@ -90,6 +102,16 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		return err;
 
+	if (!tb[IOAM6_IPTUNNEL_MODE])
+		mode = IOAM6_IPTUNNEL_MODE_INLINE;
+	else
+		mode = nla_get_u8(tb[IOAM6_IPTUNNEL_MODE]);
+
+	if (!tb[IOAM6_IPTUNNEL_DST] && mode != IOAM6_IPTUNNEL_MODE_INLINE) {
+		NL_SET_ERR_MSG(extack, "this mode needs a tunnel destination");
+		return -EINVAL;
+	}
+
 	if (!tb[IOAM6_IPTUNNEL_TRACE]) {
 		NL_SET_ERR_MSG(extack, "missing trace");
 		return -EINVAL;
@@ -102,15 +124,24 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	len = sizeof(*tuninfo) + trace->remlen * 4;
-	len_aligned = ALIGN(len, 8);
-
-	s = lwtunnel_state_alloc(len_aligned);
-	if (!s)
+	len_aligned = ALIGN(trace->remlen * 4, 8);
+	lwt = lwtunnel_state_alloc(sizeof(*ilwt) + len_aligned);
+	if (!lwt)
 		return -ENOMEM;
 
-	tuninfo = ioam6_lwt_info(s);
-	tuninfo->eh.hdrlen = (len_aligned >> 3) - 1;
+	ilwt = ioam6_lwt_state(lwt);
+	err = dst_cache_init(&ilwt->cache, GFP_ATOMIC);
+	if (err) {
+		kfree(lwt);
+		return err;
+	}
+
+	ilwt->mode = mode;
+	if (tb[IOAM6_IPTUNNEL_DST])
+		ilwt->tundst = nla_get_in6_addr(tb[IOAM6_IPTUNNEL_DST]);
+
+	tuninfo = ioam6_lwt_info(lwt);
+	tuninfo->eh.hdrlen = ((sizeof(*tuninfo) + len_aligned) >> 3) - 1;
 	tuninfo->pad[0] = IPV6_TLV_PADN;
 	tuninfo->ioamh.type = IOAM6_TYPE_PREALLOC;
 	tuninfo->ioamh.opt_type = IPV6_TLV_IOAM;
@@ -119,27 +150,39 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 
 	memcpy(&tuninfo->traceh, trace, sizeof(*trace));
 
-	len = len_aligned - len;
-	if (len == 1) {
-		tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PAD1;
-	} else if (len > 0) {
+	if (len_aligned - trace->remlen * 4) {
 		tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PADN;
-		tuninfo->traceh.data[trace->remlen * 4 + 1] = len - 2;
+		tuninfo->traceh.data[trace->remlen * 4 + 1] = 2;
 	}
 
-	s->type = LWTUNNEL_ENCAP_IOAM6;
-	s->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
+	lwt->type = LWTUNNEL_ENCAP_IOAM6;
+	lwt->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
 
-	*ts = s;
+	*ts = lwt;
 
 	return 0;
 }
 
-static int ioam6_do_inline(struct sk_buff *skb, struct ioam6_lwt_encap *tuninfo)
+static int ioam6_do_fill(struct net *net, struct sk_buff *skb)
 {
 	struct ioam6_trace_hdr *trace;
-	struct ipv6hdr *oldhdr, *hdr;
 	struct ioam6_namespace *ns;
+
+	trace = (struct ioam6_trace_hdr *)(skb_transport_header(skb)
+					   + sizeof(struct ipv6_hopopt_hdr) + 2
+					   + sizeof(struct ioam6_hdr));
+
+	ns = ioam6_namespace(net, trace->namespace_id);
+	if (ns)
+		ioam6_fill_trace_data(skb, ns, trace, false);
+
+	return 0;
+}
+
+static int ioam6_do_inline(struct net *net, struct sk_buff *skb,
+			   struct ioam6_lwt_encap *tuninfo)
+{
+	struct ipv6hdr *oldhdr, *hdr;
 	int hdrlen, err;
 
 	hdrlen = (tuninfo->eh.hdrlen + 1) << 3;
@@ -168,79 +211,195 @@ static int ioam6_do_inline(struct sk_buff *skb, struct ioam6_lwt_encap *tuninfo)
 	hdr->nexthdr = NEXTHDR_HOP;
 	hdr->payload_len = cpu_to_be16(skb->len - sizeof(*hdr));
 
-	trace = (struct ioam6_trace_hdr *)(skb_transport_header(skb)
-					   + sizeof(struct ipv6_hopopt_hdr) + 2
-					   + sizeof(struct ioam6_hdr));
+	return ioam6_do_fill(net, skb);
+}
 
-	ns = ioam6_namespace(dev_net(skb_dst(skb)->dev), trace->namespace_id);
-	if (ns)
-		ioam6_fill_trace_data(skb, ns, trace);
+static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
+			  struct ioam6_lwt_encap *tuninfo,
+			  struct in6_addr *tundst)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct ipv6hdr *hdr, *inner_hdr;
+	int hdrlen, len, err;
 
-	return 0;
+	hdrlen = (tuninfo->eh.hdrlen + 1) << 3;
+	len = sizeof(*hdr) + hdrlen;
+
+	err = skb_cow_head(skb, len + skb->mac_len);
+	if (unlikely(err))
+		return err;
+
+	inner_hdr = ipv6_hdr(skb);
+
+	skb_push(skb, len);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	skb_set_transport_header(skb, sizeof(*hdr));
+
+	tuninfo->eh.nexthdr = NEXTHDR_IPV6;
+	memcpy(skb_transport_header(skb), (u8 *)tuninfo, hdrlen);
+
+	hdr = ipv6_hdr(skb);
+	memcpy(hdr, inner_hdr, sizeof(*hdr));
+
+	hdr->nexthdr = NEXTHDR_HOP;
+	hdr->payload_len = cpu_to_be16(skb->len - sizeof(*hdr));
+	hdr->daddr = *tundst;
+	ipv6_dev_get_saddr(net, dst->dev, &hdr->daddr,
+			   IPV6_PREFER_SRC_PUBLIC, &hdr->saddr);
+
+	skb_postpush_rcsum(skb, hdr, len);
+
+	return ioam6_do_fill(net, skb);
 }
 
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct lwtunnel_state *lwt = skb_dst(skb)->lwtstate;
+	struct dst_entry *dst = skb_dst(skb);
+	struct in6_addr orig_daddr;
+	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		goto drop;
 
-	/* Only for packets we send and
-	 * that do not contain a Hop-by-Hop yet
-	 */
-	if (skb->dev || ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
-		goto out;
-
-	err = ioam6_do_inline(skb, ioam6_lwt_info(lwt));
-	if (unlikely(err))
+	ilwt = ioam6_lwt_state(dst->lwtstate);
+	orig_daddr = ipv6_hdr(skb)->daddr;
+
+	switch (ilwt->mode) {
+	case IOAM6_IPTUNNEL_MODE_INLINE:
+do_inline:
+		/* Direct insertion - if there is no Hop-by-Hop yet */
+		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
+			goto out;
+
+		err = ioam6_do_inline(net, skb, &ilwt->tuninfo);
+		if (unlikely(err))
+			goto drop;
+
+		break;
+	case IOAM6_IPTUNNEL_MODE_ENCAP:
+do_encap:
+		/* Encapsulation (ip6ip6) */
+		err = ioam6_do_encap(net, skb, &ilwt->tuninfo, &ilwt->tundst);
+		if (unlikely(err))
+			goto drop;
+
+		break;
+	case IOAM6_IPTUNNEL_MODE_AUTO:
+		/* Automatic (RFC8200 compliant):
+		 *  - local packets -> INLINE mode
+		 *  - in-transit packets -> ENCAP mode
+		 */
+		if (!skb->dev)
+			goto do_inline;
+
+		goto do_encap;
+	default:
 		goto drop;
+	}
 
-	err = skb_cow_head(skb, LL_RESERVED_SPACE(skb_dst(skb)->dev));
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
 		goto drop;
 
+	if (!ipv6_addr_equal(&orig_daddr, &ipv6_hdr(skb)->daddr)) {
+		preempt_disable();
+		dst = dst_cache_get(&ilwt->cache);
+		preempt_enable();
+
+		if (unlikely(!dst)) {
+			struct ipv6hdr *hdr = ipv6_hdr(skb);
+			struct flowi6 fl6;
+
+			memset(&fl6, 0, sizeof(fl6));
+			fl6.daddr = hdr->daddr;
+			fl6.saddr = hdr->saddr;
+			fl6.flowlabel = ip6_flowinfo(hdr);
+			fl6.flowi6_mark = skb->mark;
+			fl6.flowi6_proto = hdr->nexthdr;
+
+			dst = ip6_route_output(net, NULL, &fl6);
+			if (dst->error) {
+				err = dst->error;
+				dst_release(dst);
+				goto drop;
+			}
+
+			preempt_disable();
+			dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
+			preempt_enable();
+		}
+
+		skb_dst_drop(skb);
+		skb_dst_set(skb, dst);
+
+		return dst_output(net, sk, skb);
+	}
 out:
-	return lwt->orig_output(net, sk, skb);
-
+	return dst->lwtstate->orig_output(net, sk, skb);
 drop:
 	kfree_skb(skb);
 	return err;
 }
 
+static void ioam6_destroy_state(struct lwtunnel_state *lwt)
+{
+	dst_cache_destroy(&ioam6_lwt_state(lwt)->cache);
+}
+
 static int ioam6_fill_encap_info(struct sk_buff *skb,
 				 struct lwtunnel_state *lwtstate)
 {
-	struct ioam6_trace_hdr *trace;
+	struct ioam6_lwt *ilwt = ioam6_lwt_state(lwtstate);
 	int err;
 
-	trace = ioam6_lwt_trace(lwtstate);
-
-	err = nla_put(skb, IOAM6_IPTUNNEL_TRACE, sizeof(*trace), trace);
+	err = nla_put_u8(skb, IOAM6_IPTUNNEL_MODE, ilwt->mode);
 	if (err)
-		return err;
+		goto ret;
 
-	return 0;
+	if (ilwt->mode != IOAM6_IPTUNNEL_MODE_INLINE) {
+		err = nla_put_in6_addr(skb, IOAM6_IPTUNNEL_DST, &ilwt->tundst);
+		if (err)
+			goto ret;
+	}
+
+	err = nla_put(skb, IOAM6_IPTUNNEL_TRACE, sizeof(ilwt->tuninfo.traceh),
+		      &ilwt->tuninfo.traceh);
+ret:
+	return err;
 }
 
 static int ioam6_encap_nlsize(struct lwtunnel_state *lwtstate)
 {
-	struct ioam6_trace_hdr *trace = ioam6_lwt_trace(lwtstate);
+	struct ioam6_lwt *ilwt = ioam6_lwt_state(lwtstate);
+	int nlsize;
+
+	nlsize = nla_total_size(sizeof(ilwt->mode)) +
+		  nla_total_size(sizeof(ilwt->tuninfo.traceh));
 
-	return nla_total_size(sizeof(*trace));
+	if (ilwt->mode != IOAM6_IPTUNNEL_MODE_INLINE)
+		nlsize += nla_total_size(sizeof(ilwt->tundst));
+
+	return nlsize;
 }
 
 static int ioam6_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
 {
-	struct ioam6_trace_hdr *a_hdr = ioam6_lwt_trace(a);
-	struct ioam6_trace_hdr *b_hdr = ioam6_lwt_trace(b);
-
-	return (a_hdr->namespace_id != b_hdr->namespace_id);
+	struct ioam6_trace_hdr *trace_a = ioam6_lwt_trace(a);
+	struct ioam6_trace_hdr *trace_b = ioam6_lwt_trace(b);
+	struct ioam6_lwt *ilwt_a = ioam6_lwt_state(a);
+	struct ioam6_lwt *ilwt_b = ioam6_lwt_state(b);
+
+	return (ilwt_a->mode != ilwt_b->mode ||
+		(ilwt_a->mode != IOAM6_IPTUNNEL_MODE_INLINE &&
+		 !ipv6_addr_equal(&ilwt_a->tundst, &ilwt_b->tundst)) ||
+		trace_a->namespace_id != trace_b->namespace_id);
 }
 
 static const struct lwtunnel_encap_ops ioam6_iptun_ops = {
 	.build_state		= ioam6_build_state,
+	.destroy_state		= ioam6_destroy_state,
 	.output		= ioam6_output,
 	.fill_encap		= ioam6_fill_encap_info,
 	.get_encap_size	= ioam6_encap_nlsize,
-- 
2.25.1

