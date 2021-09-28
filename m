Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D472241B6DE
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242384AbhI1TFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:05:34 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:36825 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242218AbhI1TFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 15:05:31 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 4A851200DB90;
        Tue, 28 Sep 2021 21:03:49 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4A851200DB90
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1632855829;
        bh=y43xvJ9Vuo8groR7CyTINOmwjUzUaLPPIVrwKIdgQ7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLoO2ZH+p7N3kgDt2BnebZW2uMhIhc+RZEf7W8c7j7yPzAIWZgpk+0x1xtuwofZUh
         C/FruXQG6ddhSB1xTN/M0iG1uCDhIGNbbEUOI9KjE3cOyalvN0SjaCe+uG/u+LjxxC
         m2J403ikAzZLRklIxyQYwPFYLZkIO9zIxC1BqoOC4det470uTUD/SrJx3iPwKS0UgW
         txn6YD+709b9/oe1qYr3bdDfSiAKeO84zjfK2O9d3Knmco94eLVgO94ZYCV79Pt2N4
         wxBfiHhvX7mWhxh2QPLg1CMnu0NzGvVS63T0OUJKIRbuurFOMXzdu0zeFnlCApSaUP
         Ou8Tcdt1GJYuA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6 encapsulation
Date:   Tue, 28 Sep 2021 21:03:27 +0200
Message-Id: <20210928190328.24097-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928190328.24097-1-justin.iurman@uliege.be>
References: <20210928190328.24097-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the ip6ip6 encapsulation by providing three encap
modes: inline, encap and auto.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/net/ioam6.h                 |   3 +-
 include/uapi/linux/ioam6_iptunnel.h |  19 +-
 net/ipv6/Kconfig                    |   6 +-
 net/ipv6/exthdrs.c                  |   2 +-
 net/ipv6/ioam6.c                    |  11 +-
 net/ipv6/ioam6_iptunnel.c           | 299 ++++++++++++++++++++--------
 6 files changed, 250 insertions(+), 90 deletions(-)

diff --git a/include/net/ioam6.h b/include/net/ioam6.h
index 3c2993bc48c8..3f45ba37a2c6 100644
--- a/include/net/ioam6.h
+++ b/include/net/ioam6.h
@@ -56,7 +56,8 @@ static inline struct ioam6_pernet_data *ioam6_pernet(struct net *net)
 struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id);
 void ioam6_fill_trace_data(struct sk_buff *skb,
 			   struct ioam6_namespace *ns,
-			   struct ioam6_trace_hdr *trace);
+			   struct ioam6_trace_hdr *trace,
+			   bool is_input);
 
 int ioam6_init(void);
 void ioam6_exit(void);
diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
index bae14636a8c8..4fb7e78018b5 100644
--- a/include/uapi/linux/ioam6_iptunnel.h
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -9,9 +9,26 @@
 #ifndef _UAPI_LINUX_IOAM6_IPTUNNEL_H
 #define _UAPI_LINUX_IOAM6_IPTUNNEL_H
 
+#include <linux/in6.h>
+#include <linux/ioam6.h>
+#include <linux/types.h>
+
+enum {
+	IOAM6_IPTUNNEL_MODE_UNSPEC,
+	IOAM6_IPTUNNEL_MODE_INLINE,	/* direct insertion only */
+	IOAM6_IPTUNNEL_MODE_ENCAP,	/* encap (ip6ip6) only */
+	IOAM6_IPTUNNEL_MODE_AUTO,	/* inline or encap based on situation */
+};
+
+struct ioam6_iptunnel_trace {
+	__u8 mode;
+	struct in6_addr tundst;	/* unused for inline mode */
+	struct ioam6_trace_hdr trace;
+};
+
 enum {
 	IOAM6_IPTUNNEL_UNSPEC,
-	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
+	IOAM6_IPTUNNEL_TRACE,
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
 
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 3a871a09f962..38ece3b7b839 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -979,7 +979,7 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 		if (!skb_valid_dst(skb))
 			ip6_route_input(skb);
 
-		ioam6_fill_trace_data(skb, ns, trace);
+		ioam6_fill_trace_data(skb, ns, trace, true);
 		break;
 	default:
 		break;
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 5e8961004832..4e5583dbadac 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -631,7 +631,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
 				    struct ioam6_schema *sc,
-				    u8 sclen)
+				    u8 sclen, bool is_input)
 {
 	struct __kernel_sock_timeval ts;
 	u64 raw64;
@@ -645,7 +645,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 	/* hop_lim and node_id */
 	if (trace->type.bit0) {
 		byte = ipv6_hdr(skb)->hop_limit;
-		if (skb->dev)
+		if (is_input)
 			byte--;
 
 		raw32 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id;
@@ -730,7 +730,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 	/* hop_lim and node_id (wide) */
 	if (trace->type.bit8) {
 		byte = ipv6_hdr(skb)->hop_limit;
-		if (skb->dev)
+		if (is_input)
 			byte--;
 
 		raw64 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id_wide;
@@ -786,7 +786,8 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 /* called with rcu_read_lock() */
 void ioam6_fill_trace_data(struct sk_buff *skb,
 			   struct ioam6_namespace *ns,
-			   struct ioam6_trace_hdr *trace)
+			   struct ioam6_trace_hdr *trace,
+			   bool is_input)
 {
 	struct ioam6_schema *sc;
 	u8 sclen = 0;
@@ -822,7 +823,7 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 		return;
 	}
 
-	__ioam6_fill_trace_data(skb, ns, trace, sc, sclen);
+	__ioam6_fill_trace_data(skb, ns, trace, sc, sclen, is_input);
 	trace->remlen -= trace->nodelen + sclen;
 }
 
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index f9ee04541c17..923a5aedad9e 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -17,18 +17,25 @@
 #include <net/sock.h>
 #include <net/lwtunnel.h>
 #include <net/ioam6.h>
+#include <net/ipv6.h>
+#include <net/dst_cache.h>
+#include <net/ip6_route.h>
+#include <net/addrconf.h>
 
 #define IOAM6_MASK_SHORT_FIELDS 0xff100000
 #define IOAM6_MASK_WIDE_FIELDS 0xe00000
 
 struct ioam6_lwt_encap {
-	struct ipv6_hopopt_hdr	eh;
-	u8			pad[2];	/* 2-octet padding for 4n-alignment */
-	struct ioam6_hdr	ioamh;
-	struct ioam6_trace_hdr	traceh;
+	struct ipv6_hopopt_hdr eh;
+	u8 pad[2];			/* 2-octet padding for 4n-alignment */
+	struct ioam6_hdr ioamh;
+	struct ioam6_trace_hdr traceh;
 } __packed;
 
 struct ioam6_lwt {
+	u8 mode;
+	struct in6_addr tundst;
+	struct dst_cache cache;
 	struct ioam6_lwt_encap	tuninfo;
 };
 
@@ -42,34 +49,15 @@ static struct ioam6_lwt_encap *ioam6_lwt_info(struct lwtunnel_state *lwt)
 	return &ioam6_lwt_state(lwt)->tuninfo;
 }
 
-static struct ioam6_trace_hdr *ioam6_trace(struct lwtunnel_state *lwt)
+static struct ioam6_trace_hdr *ioam6_lwt_trace(struct lwtunnel_state *lwt)
 {
 	return &(ioam6_lwt_state(lwt)->tuninfo.traceh);
 }
 
 static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
-	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
+	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_iptunnel_trace)),
 };
 
-static int nla_put_ioam6_trace(struct sk_buff *skb, int attrtype,
-			       struct ioam6_trace_hdr *trace)
-{
-	struct ioam6_trace_hdr *data;
-	struct nlattr *nla;
-	int len;
-
-	len = sizeof(*trace);
-
-	nla = nla_reserve(skb, attrtype, len);
-	if (!nla)
-		return -EMSGSIZE;
-
-	data = nla_data(nla);
-	memcpy(data, trace, len);
-
-	return 0;
-}
-
 static bool ioam6_validate_trace_hdr(struct ioam6_trace_hdr *trace)
 {
 	u32 fields;
@@ -95,11 +83,12 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[IOAM6_IPTUNNEL_MAX + 1];
-	struct ioam6_lwt_encap *tuninfo;
+	struct ioam6_iptunnel_trace *data;
 	struct ioam6_trace_hdr *trace;
+	struct ioam6_lwt_encap *info;
 	struct lwtunnel_state *s;
-	int len_aligned;
-	int len, err;
+	struct ioam6_lwt *lwt;
+	int len, aligned, err;
 
 	if (family != AF_INET6)
 		return -EINVAL;
@@ -114,36 +103,59 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	trace = nla_data(tb[IOAM6_IPTUNNEL_TRACE]);
-	if (!ioam6_validate_trace_hdr(trace)) {
+	data = nla_data(tb[IOAM6_IPTUNNEL_TRACE]);
+	if (!ioam6_validate_trace_hdr(&data->trace)) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[IOAM6_IPTUNNEL_TRACE],
 				    "invalid trace validation");
 		return -EINVAL;
 	}
 
-	len = sizeof(*tuninfo) + trace->remlen * 4;
-	len_aligned = ALIGN(len, 8);
+	switch (data->mode) {
+	case IOAM6_IPTUNNEL_MODE_INLINE:
+	case IOAM6_IPTUNNEL_MODE_ENCAP:
+	case IOAM6_IPTUNNEL_MODE_AUTO:
+		break;
+	default:
+		NL_SET_ERR_MSG_ATTR(extack, tb[IOAM6_IPTUNNEL_TRACE],
+				    "invalid mode");
+		return -EINVAL;
+	}
+
+	len = sizeof(*info) + data->trace.remlen * 4;
+	aligned = ALIGN(len, 8);
 
-	s = lwtunnel_state_alloc(len_aligned);
+	s = lwtunnel_state_alloc(aligned + sizeof(*lwt) - sizeof(*info));
 	if (!s)
 		return -ENOMEM;
 
-	tuninfo = ioam6_lwt_info(s);
-	tuninfo->eh.hdrlen = (len_aligned >> 3) - 1;
-	tuninfo->pad[0] = IPV6_TLV_PADN;
-	tuninfo->ioamh.type = IOAM6_TYPE_PREALLOC;
-	tuninfo->ioamh.opt_type = IPV6_TLV_IOAM;
-	tuninfo->ioamh.opt_len = sizeof(tuninfo->ioamh) - 2 + sizeof(*trace)
-					+ trace->remlen * 4;
+	lwt = ioam6_lwt_state(s);
+	lwt->mode = data->mode;
+	if (lwt->mode != IOAM6_IPTUNNEL_MODE_INLINE)
+		memcpy(&lwt->tundst, &data->tundst, sizeof(lwt->tundst));
+
+	err = dst_cache_init(&lwt->cache, GFP_ATOMIC);
+	if (err) {
+		kfree(s);
+		return err;
+	}
+
+	trace = ioam6_lwt_trace(s);
+	memcpy(trace, &data->trace, sizeof(*trace));
 
-	memcpy(&tuninfo->traceh, trace, sizeof(*trace));
+	info = ioam6_lwt_info(s);
+	info->eh.hdrlen = (aligned >> 3) - 1;
+	info->pad[0] = IPV6_TLV_PADN;
+	info->ioamh.type = IOAM6_TYPE_PREALLOC;
+	info->ioamh.opt_type = IPV6_TLV_IOAM;
+	info->ioamh.opt_len = sizeof(info->ioamh) - 2;
+	info->ioamh.opt_len += sizeof(*trace) + trace->remlen * 4;
 
-	len = len_aligned - len;
+	len = aligned - len;
 	if (len == 1) {
-		tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PAD1;
+		trace->data[trace->remlen * 4] = IPV6_TLV_PAD1;
 	} else if (len > 0) {
-		tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PADN;
-		tuninfo->traceh.data[trace->remlen * 4 + 1] = len - 2;
+		trace->data[trace->remlen * 4] = IPV6_TLV_PADN;
+		trace->data[trace->remlen * 4 + 1] = len - 2;
 	}
 
 	s->type = LWTUNNEL_ENCAP_IOAM6;
@@ -154,11 +166,26 @@ static int ioam6_build_state(struct net *net, struct nlattr *nla,
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
@@ -187,80 +214,194 @@ static int ioam6_do_inline(struct sk_buff *skb, struct ioam6_lwt_encap *tuninfo)
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
+	struct in6_addr daddr_prev;
+	struct ioam6_lwt *lwt;
 	int err = -EINVAL;
 
+	lwt = ioam6_lwt_state(dst->lwtstate);
+
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
+	daddr_prev = ipv6_hdr(skb)->daddr;
+
+	switch (lwt->mode) {
+	case IOAM6_IPTUNNEL_MODE_INLINE:
+do_inline:
+		/* Direct insertion - if there is no Hop-by-Hop yet */
+		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
+			goto out;
+
+		err = ioam6_do_inline(net, skb, &lwt->tuninfo);
+		if (unlikely(err))
+			goto drop;
+
+		break;
+	case IOAM6_IPTUNNEL_MODE_ENCAP:
+do_encap:
+		/* Encapsulation (ip6ip6) */
+		err = ioam6_do_encap(net, skb, &lwt->tuninfo, &lwt->tundst);
+		if (unlikely(err))
+			goto drop;
+
+		break;
+	case IOAM6_IPTUNNEL_MODE_AUTO:
+		/* Automatic (RFC8200 compliant):
+		 *  - local packet -> INLINE mode
+		 *  - forwarded packet -> ENCAP mode
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
 
+	if (!ipv6_addr_equal(&daddr_prev, &ipv6_hdr(skb)->daddr)) {
+		preempt_disable();
+		dst = dst_cache_get(&lwt->cache);
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
+			dst_cache_set_ip6(&lwt->cache, dst, &fl6.saddr);
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
-	struct ioam6_trace_hdr *trace = ioam6_trace(lwtstate);
+	struct ioam6_iptunnel_trace *info;
+	struct ioam6_trace_hdr *trace;
+	struct ioam6_lwt *lwt;
+	struct nlattr *nla;
 
-	if (nla_put_ioam6_trace(skb, IOAM6_IPTUNNEL_TRACE, trace))
+	nla = nla_reserve(skb, IOAM6_IPTUNNEL_TRACE, sizeof(*info));
+	if (!nla)
 		return -EMSGSIZE;
 
+	lwt = ioam6_lwt_state(lwtstate);
+	trace = ioam6_lwt_trace(lwtstate);
+
+	info = nla_data(nla);
+	info->mode = lwt->mode;
+	memcpy(&info->trace, trace, sizeof(*trace));
+	if (info->mode != IOAM6_IPTUNNEL_MODE_INLINE)
+		memcpy(&info->tundst, &lwt->tundst, sizeof(lwt->tundst));
+
 	return 0;
 }
 
 static int ioam6_encap_nlsize(struct lwtunnel_state *lwtstate)
 {
-	struct ioam6_trace_hdr *trace = ioam6_trace(lwtstate);
-
-	return nla_total_size(sizeof(*trace));
+	return nla_total_size(sizeof(struct ioam6_iptunnel_trace));
 }
 
 static int ioam6_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
 {
-	struct ioam6_trace_hdr *a_hdr = ioam6_trace(a);
-	struct ioam6_trace_hdr *b_hdr = ioam6_trace(b);
-
-	return (a_hdr->namespace_id != b_hdr->namespace_id);
+	struct ioam6_trace_hdr *trace_a = ioam6_lwt_trace(a);
+	struct ioam6_trace_hdr *trace_b = ioam6_lwt_trace(b);
+	struct ioam6_lwt *lwt_a = ioam6_lwt_state(a);
+	struct ioam6_lwt *lwt_b = ioam6_lwt_state(b);
+
+	return (lwt_a->mode != lwt_b->mode ||
+		(lwt_a->mode != IOAM6_IPTUNNEL_MODE_INLINE &&
+		 !ipv6_addr_equal(&lwt_a->tundst, &lwt_b->tundst)) ||
+		trace_a->namespace_id != trace_b->namespace_id);
 }
 
 static const struct lwtunnel_encap_ops ioam6_iptun_ops = {
-	.build_state	= ioam6_build_state,
+	.build_state		= ioam6_build_state,
+	.destroy_state		= ioam6_destroy_state,
 	.output		= ioam6_output,
-	.fill_encap	= ioam6_fill_encap_info,
+	.fill_encap		= ioam6_fill_encap_info,
 	.get_encap_size	= ioam6_encap_nlsize,
-	.cmp_encap	= ioam6_encap_cmp,
-	.owner		= THIS_MODULE,
+	.cmp_encap		= ioam6_encap_cmp,
+	.owner			= THIS_MODULE,
 };
 
 int __init ioam6_iptunnel_init(void)
-- 
2.25.1

