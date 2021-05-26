Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62AB391E1B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhEZR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:28:58 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46296 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhEZR25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:28:57 -0400
Received: from ubuntu18.home (135.19-200-80.adsl-dyn.isp.belgacom.be [80.200.19.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 4A012200E1D9;
        Wed, 26 May 2021 19:17:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4A012200E1D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622049431;
        bh=l6AnhrAY5jrfK/igHxxskO47gxkaP/lY24O2HfbMavg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBFNEALiSrkIs9P/O0eW7AwT5dTMekA7DIPX81jDdTPkuJp/gc1/N1Mz7wN+/kPzP
         ogHbRa/7gpWjf6vbvSfuG8wh5BJ3/kD1nKCVkpGaF/ZZUZDS44GmoIX6xf/hvaES+r
         R1luk6cVo8NnOIoD61/8iq6xbDgwx+yppekDcKLLInpfwe6ueiXcjanD3UTADSMANs
         wFW2JARaVMGQHmIGRO2X7veRyrhR75up7wv4bqLmZbsLhAPZB2L/LB2IulyxvO2o29
         5fyOl0CcnQz1h70Vd8WoX8IHa3tLydJ9A6j1eCEwQU03sdcnZY8yyNPXBn6I4EOIah
         FceC433YLcxqQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [RESEND PATCH net-next v3 4/5] ipv6: ioam: Support for IOAM injection with lwtunnels
Date:   Wed, 26 May 2021 19:16:39 +0200
Message-Id: <20210526171640.9722-5-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526171640.9722-1-justin.iurman@uliege.be>
References: <20210526171640.9722-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the IOAM inline insertion (only for the host-to-host use case)
which is per-route configured with lightweight tunnels. The target is iproute2
and the patch is ready. It will be posted as soon as this patchset is merged.
Here is an overview:

$ ip -6 ro ad fc00::1/128 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0

This example configures an IOAM Pre-allocated Trace option attached to the
fc00::1/128 prefix. The IOAM namespace (ns) is 1, the size of the pre-allocated
trace data block is 12 octets (size) and only the first IOAM data (bit 0:
hop_limit + node id) is included in the trace (type) represented as a bitfield.

The reason why the in-transit (IPv6-in-IPv6 encapsulation) use case is not
implemented is explained on the patchset cover.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ioam6_iptunnel.h      |  13 ++
 include/net/ioam6.h                 |   3 +
 include/uapi/linux/ioam6.h          |   1 +
 include/uapi/linux/ioam6_iptunnel.h |  19 ++
 include/uapi/linux/lwtunnel.h       |   1 +
 net/core/lwtunnel.c                 |   2 +
 net/ipv6/Kconfig                    |  11 ++
 net/ipv6/Makefile                   |   1 +
 net/ipv6/ioam6.c                    |  17 +-
 net/ipv6/ioam6_iptunnel.c           | 273 ++++++++++++++++++++++++++++
 10 files changed, 339 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/ioam6_iptunnel.h
 create mode 100644 include/uapi/linux/ioam6_iptunnel.h
 create mode 100644 net/ipv6/ioam6_iptunnel.c

diff --git a/include/linux/ioam6_iptunnel.h b/include/linux/ioam6_iptunnel.h
new file mode 100644
index 000000000000..07d9dfedd29d
--- /dev/null
+++ b/include/linux/ioam6_iptunnel.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ *  IPv6 IOAM Lightweight Tunnel API
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+#ifndef _LINUX_IOAM6_IPTUNNEL_H
+#define _LINUX_IOAM6_IPTUNNEL_H
+
+#include <uapi/linux/ioam6_iptunnel.h>
+
+#endif /* _LINUX_IOAM6_IPTUNNEL_H */
diff --git a/include/net/ioam6.h b/include/net/ioam6.h
index 828b83c70721..9eab3817e90b 100644
--- a/include/net/ioam6.h
+++ b/include/net/ioam6.h
@@ -59,4 +59,7 @@ extern void ioam6_fill_trace_data(struct sk_buff *skb,
 extern int ioam6_init(void);
 extern void ioam6_exit(void);
 
+extern int ioam6_iptunnel_init(void);
+extern void ioam6_iptunnel_exit(void);
+
 #endif /* _NET_IOAM6_H */
diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
index 2177e4e49566..0a1e09e43c28 100644
--- a/include/uapi/linux/ioam6.h
+++ b/include/uapi/linux/ioam6.h
@@ -117,6 +117,7 @@ struct ioam6_trace_hdr {
 #error "Please fix <asm/byteorder.h>"
 #endif
 
+#define IOAM6_TRACE_DATA_SIZE_MAX 244
 	__u8	data[0];
 } __attribute__((packed));
 
diff --git a/include/uapi/linux/ioam6_iptunnel.h b/include/uapi/linux/ioam6_iptunnel.h
new file mode 100644
index 000000000000..ed4ba9d523d6
--- /dev/null
+++ b/include/uapi/linux/ioam6_iptunnel.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 IOAM Lightweight Tunnel API
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#ifndef _UAPI_LINUX_IOAM6_IPTUNNEL_H
+#define _UAPI_LINUX_IOAM6_IPTUNNEL_H
+
+enum {
+	IOAM6_IPTUNNEL_UNSPEC,
+	IOAM6_IPTUNNEL_TRACE,		/* struct ioam6_trace_hdr */
+	__IOAM6_IPTUNNEL_MAX,
+};
+#define IOAM6_IPTUNNEL_MAX (__IOAM6_IPTUNNEL_MAX - 1)
+
+#endif /* _UAPI_LINUX_IOAM6_IPTUNNEL_H */
diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 568a4303ccce..2e206919125c 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -14,6 +14,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_BPF,
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
 	LWTUNNEL_ENCAP_RPL,
+	LWTUNNEL_ENCAP_IOAM6,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 8ec7d13d2860..d0ae987d2de9 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -43,6 +43,8 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 		return "SEG6LOCAL";
 	case LWTUNNEL_ENCAP_RPL:
 		return "RPL";
+	case LWTUNNEL_ENCAP_IOAM6:
+		return "IOAM6";
 	case LWTUNNEL_ENCAP_IP6:
 	case LWTUNNEL_ENCAP_IP:
 	case LWTUNNEL_ENCAP_NONE:
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 747f56e0c636..e504204bca92 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -328,4 +328,15 @@ config IPV6_RPL_LWTUNNEL
 
 	  If unsure, say N.
 
+config IPV6_IOAM6_LWTUNNEL
+	bool "IPv6: IOAM Pre-allocated Trace insertion support"
+	depends on IPV6
+	select LWTUNNEL
+	help
+	  Support for the inline insertion of IOAM Pre-allocated
+	  Trace Header (only on locally generated packets), using
+	  the lightweight tunnels mechanism.
+
+	  If unsure, say N.
+
 endif # IPV6
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index b7ef10d417d6..1bc7e143217b 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -27,6 +27,7 @@ ipv6-$(CONFIG_NETLABEL) += calipso.o
 ipv6-$(CONFIG_IPV6_SEG6_LWTUNNEL) += seg6_iptunnel.o seg6_local.o
 ipv6-$(CONFIG_IPV6_SEG6_HMAC) += seg6_hmac.o
 ipv6-$(CONFIG_IPV6_RPL_LWTUNNEL) += rpl_iptunnel.o
+ipv6-$(CONFIG_IPV6_IOAM6_LWTUNNEL) += ioam6_iptunnel.o
 
 ipv6-objs += $(ipv6-y)
 
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 09fb93f4cf1f..57dcde80cda4 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -600,7 +600,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		if (skb->dev)
 			byte--;
 
-		raw32 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
+		raw32 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id;
 		if (!raw32)
 			raw32 = IOAM6_EMPTY_u24;
 		else
@@ -688,7 +688,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		if (skb->dev)
 			byte--;
 
-		raw64 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
+		raw64 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id;
 		if (!raw64)
 			raw64 = IOAM6_EMPTY_u56;
 		else
@@ -843,10 +843,20 @@ int __init ioam6_init(void)
 	if (err)
 		goto out_unregister_pernet_subsys;
 
+#ifdef CONFIG_IPV6_IOAM6_LWTUNNEL
+	err = ioam6_iptunnel_init();
+	if (err)
+		goto out_unregister_genl;
+#endif
+
 	pr_info("In-situ OAM (IOAM) with IPv6\n");
 
 out:
 	return err;
+#ifdef CONFIG_IPV6_IOAM6_LWTUNNEL
+out_unregister_genl:
+	genl_unregister_family(&ioam6_genl_family);
+#endif
 out_unregister_pernet_subsys:
 	unregister_pernet_subsys(&ioam6_net_ops);
 	goto out;
@@ -854,6 +864,9 @@ int __init ioam6_init(void)
 
 void ioam6_exit(void)
 {
+#ifdef CONFIG_IPV6_IOAM6_LWTUNNEL
+	ioam6_iptunnel_exit();
+#endif
 	genl_unregister_family(&ioam6_genl_family);
 	unregister_pernet_subsys(&ioam6_net_ops);
 }
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
new file mode 100644
index 000000000000..e19b5c3aa792
--- /dev/null
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -0,0 +1,273 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ *  IPv6 IOAM Lightweight Tunnel implementation
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/net.h>
+#include <linux/netlink.h>
+#include <linux/in6.h>
+#include <linux/ioam6.h>
+#include <linux/ioam6_iptunnel.h>
+#include <net/dst.h>
+#include <net/sock.h>
+#include <net/lwtunnel.h>
+#include <net/ioam6.h>
+
+struct ioam6_lwt_encap {
+	struct ipv6_hopopt_hdr	eh;
+	u8			pad[2];	/* 2-octet padding for 4n-alignment */
+	struct ioam6_hdr	ioamh;
+	struct ioam6_trace_hdr	traceh;
+} __attribute__((packed));
+
+struct ioam6_lwt {
+	struct ioam6_lwt_encap	tuninfo;
+};
+
+static inline struct ioam6_lwt *ioam6_lwt_state(struct lwtunnel_state *lwt)
+{
+	return (struct ioam6_lwt *)lwt->data;
+}
+
+static inline struct ioam6_lwt_encap *ioam6_lwt_info(struct lwtunnel_state *lwt)
+{
+	return &ioam6_lwt_state(lwt)->tuninfo;
+}
+
+static inline struct ioam6_trace_hdr *ioam6_trace(struct lwtunnel_state *lwt)
+{
+	return &(ioam6_lwt_state(lwt)->tuninfo.traceh);
+}
+
+static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
+	[IOAM6_IPTUNNEL_TRACE]	= { .type = NLA_BINARY },
+};
+
+static int nla_put_ioam6_trace(struct sk_buff *skb, int attrtype,
+			       struct ioam6_trace_hdr *trace)
+{
+	struct ioam6_trace_hdr *data;
+	struct nlattr *nla;
+	int len;
+
+	len = sizeof(*trace);
+
+	nla = nla_reserve(skb, attrtype, len);
+	if (!nla)
+		return -EMSGSIZE;
+
+	data = nla_data(nla);
+	memcpy(data, trace, len);
+
+	return 0;
+}
+
+static bool ioam6_validate_trace_hdr(struct ioam6_trace_hdr *trace)
+{
+	if (!trace->type_be32 || !trace->remlen ||
+	    trace->remlen > IOAM6_TRACE_DATA_SIZE_MAX / 4)
+		return false;
+
+	trace->nodelen = 0;
+	if (trace->type.bit0) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit1) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit2) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit3) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit4) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit5) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit6) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit7) trace->nodelen += sizeof(__be32) / 4;
+	if (trace->type.bit8) trace->nodelen += sizeof(__be64) / 4;
+	if (trace->type.bit9) trace->nodelen += sizeof(__be64) / 4;
+	if (trace->type.bit10) trace->nodelen += sizeof(__be64) / 4;
+	if (trace->type.bit11) trace->nodelen += sizeof(__be32) / 4;
+
+	return true;
+}
+
+static int ioam6_build_state(struct net *net, struct nlattr *nla,
+			     unsigned int family, const void *cfg,
+			     struct lwtunnel_state **ts,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IOAM6_IPTUNNEL_MAX + 1];
+	struct ioam6_lwt_encap *tuninfo;
+	struct ioam6_trace_hdr *trace;
+	struct lwtunnel_state *s;
+	int len_aligned;
+	int len, err;
+
+	if (family != AF_INET6)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, IOAM6_IPTUNNEL_MAX, nla,
+			       ioam6_iptunnel_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[IOAM6_IPTUNNEL_TRACE])
+		return -EINVAL;
+
+	trace = nla_data(tb[IOAM6_IPTUNNEL_TRACE]);
+	if (nla_len(tb[IOAM6_IPTUNNEL_TRACE]) != sizeof(*trace))
+		return -EINVAL;
+
+	if (!ioam6_validate_trace_hdr(trace))
+		return -EINVAL;
+
+	len = sizeof(*tuninfo) + trace->remlen * 4;
+	len_aligned = ALIGN(len, 8);
+
+	s = lwtunnel_state_alloc(len_aligned);
+	if (!s)
+		return -ENOMEM;
+
+	tuninfo = ioam6_lwt_info(s);
+	tuninfo->eh.hdrlen = (len_aligned >> 3) - 1;
+	tuninfo->pad[0] = IPV6_TLV_PADN;
+	tuninfo->ioamh.type = IOAM6_TYPE_PREALLOC;
+	tuninfo->ioamh.opt_type = IPV6_TLV_IOAM;
+	tuninfo->ioamh.opt_len = sizeof(tuninfo->ioamh) - 2 + sizeof(*trace)
+					+ trace->remlen * 4;
+
+	memcpy(&tuninfo->traceh, trace, sizeof(*trace));
+
+	len = len_aligned - len;
+	if (len == 1) {
+		tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PAD1;
+	} else if (len > 0) {
+		tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PADN;
+		tuninfo->traceh.data[trace->remlen * 4 + 1] = len - 2;
+	}
+
+	s->type = LWTUNNEL_ENCAP_IOAM6;
+	s->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
+
+	*ts = s;
+
+	return 0;
+}
+
+static int ioam6_do_inline(struct sk_buff *skb, struct ioam6_lwt_encap *tuninfo)
+{
+	struct ioam6_trace_hdr *trace;
+	struct ipv6hdr *oldhdr, *hdr;
+	struct ioam6_namespace *ns;
+	int hdrlen, err;
+
+	hdrlen = (tuninfo->eh.hdrlen + 1) << 3;
+
+	err = skb_cow_head(skb, hdrlen + skb->mac_len);
+	if (unlikely(err))
+		return err;
+
+	oldhdr = ipv6_hdr(skb);
+	skb_pull(skb, sizeof(*oldhdr));
+	skb_postpull_rcsum(skb, skb_network_header(skb), sizeof(*oldhdr));
+
+	skb_push(skb, sizeof(*oldhdr) + hdrlen);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
+	hdr = ipv6_hdr(skb);
+	memmove(hdr, oldhdr, sizeof(*oldhdr));
+	tuninfo->eh.nexthdr = hdr->nexthdr;
+
+	skb_set_transport_header(skb, sizeof(*hdr));
+	skb_postpush_rcsum(skb, hdr, sizeof(*hdr) + hdrlen);
+
+	memcpy(skb_transport_header(skb), (u8*)tuninfo, hdrlen);
+
+	hdr->nexthdr = NEXTHDR_HOP;
+	hdr->payload_len = cpu_to_be16(skb->len - sizeof(*hdr));
+
+	trace = (struct ioam6_trace_hdr *)(skb_transport_header(skb)
+					   + sizeof(struct ipv6_hopopt_hdr) + 2
+					   + sizeof(struct ioam6_hdr));
+
+	ns = ioam6_namespace(dev_net(skb_dst(skb)->dev), trace->namespace_id);
+	if (ns)
+		ioam6_fill_trace_data(skb, ns, trace);
+
+	return 0;
+}
+
+static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct lwtunnel_state *lwt = skb_dst(skb)->lwtstate;
+	int err = -EINVAL;
+
+	if (skb->protocol != htons(ETH_P_IPV6))
+		goto drop;
+
+	/* Only for packets we send and
+	 * that do not contain a Hop-by-Hop yet
+	 */
+	if (skb->dev || ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
+		goto out;
+
+	err = ioam6_do_inline(skb, ioam6_lwt_info(lwt));
+	if (unlikely(err))
+		goto drop;
+
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(skb_dst(skb)->dev));
+	if (unlikely(err))
+		goto drop;
+
+out:
+	return lwt->orig_output(net, sk, skb);
+
+drop:
+	kfree_skb(skb);
+	return err;
+}
+
+static int ioam6_fill_encap_info(struct sk_buff *skb,
+				 struct lwtunnel_state *lwtstate)
+{
+	struct ioam6_trace_hdr *trace = ioam6_trace(lwtstate);
+
+	if (nla_put_ioam6_trace(skb, IOAM6_IPTUNNEL_TRACE, trace))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int ioam6_encap_nlsize(struct lwtunnel_state *lwtstate)
+{
+	struct ioam6_trace_hdr *trace = ioam6_trace(lwtstate);
+
+	return nla_total_size(sizeof(*trace));
+}
+
+static int ioam6_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
+{
+	struct ioam6_trace_hdr *a_hdr = ioam6_trace(a);
+	struct ioam6_trace_hdr *b_hdr = ioam6_trace(b);
+
+	return (a_hdr->namespace_id != b_hdr->namespace_id);
+}
+
+static const struct lwtunnel_encap_ops ioam6_iptun_ops = {
+	.build_state	= ioam6_build_state,
+	.output		= ioam6_output,
+	.fill_encap	= ioam6_fill_encap_info,
+	.get_encap_size	= ioam6_encap_nlsize,
+	.cmp_encap	= ioam6_encap_cmp,
+	.owner		= THIS_MODULE,
+};
+
+int __init ioam6_iptunnel_init(void)
+{
+	return lwtunnel_encap_add_ops(&ioam6_iptun_ops, LWTUNNEL_ENCAP_IOAM6);
+}
+
+void ioam6_iptunnel_exit(void)
+{
+	lwtunnel_encap_del_ops(&ioam6_iptun_ops, LWTUNNEL_ENCAP_IOAM6);
+}
-- 
2.17.1

