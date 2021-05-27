Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064D139324B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhE0PTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:19:41 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37536 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbhE0PTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 11:19:24 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 0745A200EEDA;
        Thu, 27 May 2021 17:17:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 0745A200EEDA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622128649;
        bh=lfQYdUUdfCqfMi023M7KbyFg/mK+mHezN293EQ+dU/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiK/9PCD893mP1gL6LNuyEj4EuGjr0SEATlVUwwsRoqDcTQs8QnlIOezWlhXwmuso
         XyZNb4bmRVW6pony1uYZAYqYNlAnmyFH3QbqlVv1SfQ/XHNeyvCDIfMvozDmGbr0WM
         +jVT2UJARsKWqBd9K0tqcbJ4CMqvf4FGIi2BM/RXo/YN/tW/OPuHJNRhWVPTi6aQPd
         VPm2ycONL47oyT6eNk+HHApMLlnugKPLaGewkKB6lm0UMF6nOgMVjeoYcLhf/cHzXM
         l88jwYZrYWJnOz+LoVtSjdlyrxlmPsY/zqvbMF9m5WFUdOsoPfyykLsSmuYrv6Lpc6
         p+TgiF+44i+QA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for Pre-allocated Trace
Date:   Thu, 27 May 2021 17:16:49 +0200
Message-Id: <20210527151652.16074-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210527151652.16074-1-justin.iurman@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for processing the IOAM Pre-allocated Trace with IPv6,
see [1] and [2]. Introduce a new IPv6 Hop-by-Hop TLV option, see IANA [3].

A per-interface sysctl ioam6_enabled is provided to process/ignore IOAM
headers. Default is ignore (= disabled). Another per-interface sysctl
ioam6_id is provided to define the IOAM (unique) identifier of the
interface. Default is 0. A per-namespace sysctl ioam6_id is provided to
define the IOAM (unique) identifier of the node. Default is 0.
Documentation is provided at the end of this patchset.

Two relativistic hash tables: one for IOAM namespaces, the other for
IOAM schemas. A namespace can only have a single active schema and a
schema can only be attached to a single namespace (1:1 relationship).

  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
  [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ioam6.h      |  13 ++
 include/linux/ipv6.h       |   2 +
 include/net/ioam6.h        |  62 +++++++
 include/net/netns/ipv6.h   |   2 +
 include/uapi/linux/in6.h   |   1 +
 include/uapi/linux/ipv6.h  |   2 +
 net/ipv6/Makefile          |   2 +-
 net/ipv6/addrconf.c        |  20 +++
 net/ipv6/af_inet6.c        |   7 +
 net/ipv6/exthdrs.c         |  51 ++++++
 net/ipv6/ioam6.c           | 357 +++++++++++++++++++++++++++++++++++++
 net/ipv6/sysctl_net_ipv6.c |   7 +
 12 files changed, 525 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/ioam6.h
 create mode 100644 include/net/ioam6.h
 create mode 100644 net/ipv6/ioam6.c

diff --git a/include/linux/ioam6.h b/include/linux/ioam6.h
new file mode 100644
index 000000000000..94a24b36998f
--- /dev/null
+++ b/include/linux/ioam6.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ *  IPv6 IOAM
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+#ifndef _LINUX_IOAM6_H
+#define _LINUX_IOAM6_H
+
+#include <uapi/linux/ioam6.h>
+
+#endif /* _LINUX_IOAM6_H */
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3b9884..6cc372af2319 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -76,6 +76,8 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__u32		ioam6_enabled;
+	__u32           ioam6_id;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/net/ioam6.h b/include/net/ioam6.h
new file mode 100644
index 000000000000..828b83c70721
--- /dev/null
+++ b/include/net/ioam6.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ *  IPv6 IOAM implementation
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#ifndef _NET_IOAM6_H
+#define _NET_IOAM6_H
+
+#include <linux/net.h>
+#include <linux/ipv6.h>
+#include <linux/ioam6.h>
+#include <linux/rhashtable-types.h>
+
+struct ioam6_namespace {
+	struct rhash_head head;
+	struct rcu_head rcu;
+
+	__be16 id;
+	__be64 data;
+
+	struct ioam6_schema *schema;
+};
+
+struct ioam6_schema {
+	struct rhash_head head;
+	struct rcu_head rcu;
+
+	u32 id;
+	int len;
+	__be32 hdr;
+	u8 *data;
+
+	struct ioam6_namespace *ns;
+};
+
+struct ioam6_pernet_data {
+	struct mutex lock;
+	struct rhashtable namespaces;
+	struct rhashtable schemas;
+};
+
+static inline struct ioam6_pernet_data *ioam6_pernet(struct net *net)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	return net->ipv6.ioam6_data;
+#else
+	return NULL;
+#endif
+}
+
+extern struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id);
+extern void ioam6_fill_trace_data(struct sk_buff *skb,
+				  struct ioam6_namespace *ns,
+				  struct ioam6_trace_hdr *trace);
+
+extern int ioam6_init(void);
+extern void ioam6_exit(void);
+
+#endif /* _NET_IOAM6_H */
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index bde0b7adb4a3..a0d61a8fcfe1 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -53,6 +53,7 @@ struct netns_sysctl_ipv6 {
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
+	unsigned int ioam6_id;
 };
 
 struct netns_ipv6 {
@@ -110,6 +111,7 @@ struct netns_ipv6 {
 		spinlock_t	lock;
 		u32		seq;
 	} ip6addrlbl_table;
+	struct ioam6_pernet_data *ioam6_data;
 };
 
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 5ad396a57eb3..c4c53a9ab959 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -145,6 +145,7 @@ struct in6_flowlabel_req {
 #define IPV6_TLV_PADN		1
 #define IPV6_TLV_ROUTERALERT	5
 #define IPV6_TLV_CALIPSO	7	/* RFC 5570 */
+#define IPV6_TLV_IOAM		49	/* TEMPORARY IANA allocation for IOAM */
 #define IPV6_TLV_JUMBO		194
 #define IPV6_TLV_HAO		201	/* home address option */
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..885c29e3a8d6 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,8 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_IOAM6_ENABLED,
+	DEVCONF_IOAM6_ID,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index cf7b47bdb9b3..b7ef10d417d6 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -10,7 +10,7 @@ ipv6-objs :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udplite.o \
 		raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
-		udp_offload.o seg6.o fib6_notifier.o rpl.o
+		udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o
 
 ipv6-offload :=	ip6_offload.o tcpv6_offload.o exthdrs_offload.o
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b0ef65eb9bd2..c068d3b683c7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -237,6 +237,8 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ioam6_enabled		= 0,
+	.ioam6_id               = 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -293,6 +295,8 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ioam6_enabled		= 0,
+	.ioam6_id               = 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5526,6 +5530,8 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+	array[DEVCONF_IOAM6_ENABLED] = cnf->ioam6_enabled;
+	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6932,6 +6938,20 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "ioam6_enabled",
+		.data		= &ipv6_devconf.ioam6_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "ioam6_id",
+		.data		= &ipv6_devconf.ioam6_id,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2389ff702f51..aec9664ec909 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -62,6 +62,7 @@
 #include <net/rpl.h>
 #include <net/compat.h>
 #include <net/xfrm.h>
+#include <net/ioam6.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -1191,6 +1192,10 @@ static int __init inet6_init(void)
 	if (err)
 		goto rpl_fail;
 
+	err = ioam6_init();
+	if (err)
+		goto ioam6_fail;
+
 	err = igmp6_late_init();
 	if (err)
 		goto igmp6_late_err;
@@ -1214,6 +1219,8 @@ static int __init inet6_init(void)
 #endif
 igmp6_late_err:
 	rpl_exit();
+ioam6_fail:
+	ioam6_exit();
 rpl_fail:
 	seg6_exit();
 seg6_fail:
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 56e479d158b7..93c4e7a409e3 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -49,6 +49,9 @@
 #include <net/seg6_hmac.h>
 #endif
 #include <net/rpl.h>
+#include <linux/ioam6.h>
+#include <net/ioam6.h>
+#include <net/dst_metadata.h>
 
 #include <linux/uaccess.h>
 
@@ -929,6 +932,50 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
 	return false;
 }
 
+/* IOAM */
+
+static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
+{
+	struct ioam6_trace_hdr *trace;
+	struct ioam6_namespace *ns;
+	struct ioam6_hdr *hdr;
+
+	/* Must be 4n-aligned */
+	if (optoff & 3)
+		goto drop;
+
+	/* Ignore if IOAM is not enabled on ingress */
+	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
+		goto ignore;
+
+	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
+
+	switch (hdr->type) {
+	case IOAM6_TYPE_PREALLOC:
+		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
+		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);
+
+		/* Ignore if the IOAM namespace is unknown */
+		if (!ns)
+			goto ignore;
+
+		if (!skb_valid_dst(skb))
+			ip6_route_input(skb);
+
+		ioam6_fill_trace_data(skb, ns, trace);
+		break;
+	default:
+		break;
+	}
+
+ignore:
+	return true;
+
+drop:
+	kfree_skb(skb);
+	return false;
+}
+
 /* Jumbo payload */
 
 static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
@@ -1000,6 +1047,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
 		.type	= IPV6_TLV_ROUTERALERT,
 		.func	= ipv6_hop_ra,
 	},
+	{
+		.type	= IPV6_TLV_IOAM,
+		.func	= ipv6_hop_ioam,
+	},
 	{
 		.type	= IPV6_TLV_JUMBO,
 		.func	= ipv6_hop_jumbo,
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
new file mode 100644
index 000000000000..a9e4fc47be1a
--- /dev/null
+++ b/net/ipv6/ioam6.c
@@ -0,0 +1,357 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ *  IPv6 IOAM implementation
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/net.h>
+#include <linux/ioam6.h>
+#include <linux/rhashtable.h>
+
+#include <net/addrconf.h>
+#include <net/ioam6.h>
+
+#define IOAM6_EMPTY_u16 0xffff
+#define IOAM6_EMPTY_u24 0x00ffffff
+#define IOAM6_EMPTY_u32 0xffffffff
+#define IOAM6_EMPTY_u56 0x00ffffffffffffff
+
+#define IOAM6_MASK_u24	IOAM6_EMPTY_u24
+#define IOAM6_MASK_u56	IOAM6_EMPTY_u56
+
+static void ioam6_ns_release(struct ioam6_namespace *ns)
+{
+	kfree_rcu(ns, rcu);
+}
+
+static void ioam6_sc_release(struct ioam6_schema *sc)
+{
+	kfree_rcu(sc, rcu);
+}
+
+static void ioam6_free_ns(void *ptr, void *arg)
+{
+	struct ioam6_namespace *ns = (struct ioam6_namespace *)ptr;
+
+	if (ns)
+		ioam6_ns_release(ns);
+}
+
+static void ioam6_free_sc(void *ptr, void *arg)
+{
+	struct ioam6_schema *sc = (struct ioam6_schema *)ptr;
+
+	if (sc)
+		ioam6_sc_release(sc);
+}
+
+static int ioam6_ns_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	const struct ioam6_namespace *ns = obj;
+
+	return (ns->id != *(__be16 *)arg->key);
+}
+
+static int ioam6_sc_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
+{
+	const struct ioam6_schema *sc = obj;
+
+	return (sc->id != *(u32 *)arg->key);
+}
+
+static const struct rhashtable_params rht_ns_params = {
+	.key_len		= sizeof(__be16),
+	.key_offset		= offsetof(struct ioam6_namespace, id),
+	.head_offset		= offsetof(struct ioam6_namespace, head),
+	.automatic_shrinking	= true,
+	.obj_cmpfn		= ioam6_ns_cmpfn,
+};
+
+static const struct rhashtable_params rht_sc_params = {
+	.key_len		= sizeof(u32),
+	.key_offset		= offsetof(struct ioam6_schema, id),
+	.head_offset		= offsetof(struct ioam6_schema, head),
+	.automatic_shrinking	= true,
+	.obj_cmpfn		= ioam6_sc_cmpfn,
+};
+
+struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id)
+{
+	struct ioam6_pernet_data *nsdata = ioam6_pernet(net);
+
+	return rhashtable_lookup_fast(&nsdata->namespaces, &id, rht_ns_params);
+}
+
+static void __ioam6_fill_trace_data(struct sk_buff *skb,
+				    struct ioam6_namespace *ns,
+				    struct ioam6_trace_hdr *trace,
+				    u8 sclen)
+{
+	struct __kernel_sock_timeval ts;
+	u64 raw64;
+	u32 raw32;
+	u16 raw16;
+	u8 *data;
+	u8 byte;
+
+	data = trace->data + trace->remlen * 4 - trace->nodelen * 4 - sclen * 4;
+
+	/* hop_lim and node_id */
+	if (trace->type.bit0) {
+		byte = ipv6_hdr(skb)->hop_limit;
+		if (skb->dev)
+			byte--;
+
+		raw32 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
+		if (!raw32)
+			raw32 = IOAM6_EMPTY_u24;
+		else
+			raw32 &= IOAM6_MASK_u24;
+
+		*(__be32 *)data = cpu_to_be32((byte << 24) | raw32);
+		data += sizeof(__be32);
+	}
+
+	/* ingress_if_id and egress_if_id */
+	if (trace->type.bit1) {
+		if (!skb->dev) {
+			raw16 = IOAM6_EMPTY_u16;
+		} else {
+			raw16 = __in6_dev_get(skb->dev)->cnf.ioam6_id;
+			if (!raw16)
+				raw16 = IOAM6_EMPTY_u16;
+		}
+
+		*(__be16 *)data = cpu_to_be16(raw16);
+		data += sizeof(__be16);
+
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
+			raw16 = IOAM6_EMPTY_u16;
+		} else {
+			raw16 = __in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id;
+			if (!raw16)
+				raw16 = IOAM6_EMPTY_u16;
+		}
+
+		*(__be16 *)data = cpu_to_be16(raw16);
+		data += sizeof(__be16);
+	}
+
+	/* timestamp seconds */
+	if (trace->type.bit2) {
+		if (!skb->tstamp)
+			__net_timestamp(skb);
+
+		skb_get_new_timestamp(skb, &ts);
+
+		*(__be32 *)data = cpu_to_be32((u32)ts.tv_sec);
+		data += sizeof(__be32);
+	}
+
+	/* timestamp subseconds */
+	if (trace->type.bit3) {
+		if (!skb->tstamp)
+			__net_timestamp(skb);
+
+		if (!trace->type.bit2)
+			skb_get_new_timestamp(skb, &ts);
+
+		*(__be32 *)data = cpu_to_be32((u32)ts.tv_usec);
+		data += sizeof(__be32);
+	}
+
+	/* transit delay */
+	if (trace->type.bit4) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_u32);
+		data += sizeof(__be32);
+	}
+
+	/* namespace data */
+	if (trace->type.bit5) {
+		*(__be32 *)data = (__force __be32)ns->data;
+		data += sizeof(__be32);
+	}
+
+	/* queue depth */
+	if (trace->type.bit6) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_u32);
+		data += sizeof(__be32);
+	}
+
+	/* checksum complement */
+	if (trace->type.bit7) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_u32);
+		data += sizeof(__be32);
+	}
+
+	/* hop_lim and node_id (wide) */
+	if (trace->type.bit8) {
+		byte = ipv6_hdr(skb)->hop_limit;
+		if (skb->dev)
+			byte--;
+
+		raw64 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id;
+		if (!raw64)
+			raw64 = IOAM6_EMPTY_u56;
+		else
+			raw64 &= IOAM6_MASK_u56;
+
+		*(__be64 *)data = cpu_to_be64(((u64)byte << 56) | raw64);
+		data += sizeof(__be64);
+	}
+
+	/* ingress_if_id and egress_if_id (wide) */
+	if (trace->type.bit9) {
+		if (!skb->dev) {
+			raw32 = IOAM6_EMPTY_u32;
+		} else {
+			raw32 = __in6_dev_get(skb->dev)->cnf.ioam6_id;
+			if (!raw32)
+				raw32 = IOAM6_EMPTY_u32;
+		}
+
+		*(__be32 *)data = cpu_to_be32(raw32);
+		data += sizeof(__be32);
+
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
+			raw32 = IOAM6_EMPTY_u32;
+		} else {
+			raw32 = __in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id;
+			if (!raw32)
+				raw32 = IOAM6_EMPTY_u32;
+		}
+
+		*(__be32 *)data = cpu_to_be32(raw32);
+		data += sizeof(__be32);
+	}
+
+	/* namespace data (wide) */
+	if (trace->type.bit10) {
+		*(__be64 *)data = ns->data;
+		data += sizeof(__be64);
+	}
+
+	/* buffer occupancy */
+	if (trace->type.bit11) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_u32);
+		data += sizeof(__be32);
+	}
+
+	/* opaque state snapshot */
+	if (trace->type.bit22) {
+		if (!ns->schema) {
+			*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_u24);
+		} else {
+			*(__be32 *)data = ns->schema->hdr;
+			data += sizeof(__be32);
+
+			memcpy(data, ns->schema->data, ns->schema->len);
+		}
+	}
+}
+
+void ioam6_fill_trace_data(struct sk_buff *skb,
+			   struct ioam6_namespace *ns,
+			   struct ioam6_trace_hdr *trace)
+{
+	u8 sclen = 0;
+
+	/* Skip if Overflow flag is set OR
+	 * if an unknown type (bit 12-21) is set
+	 */
+	if (trace->overflow ||
+	    (trace->type.bit12 | trace->type.bit13 | trace->type.bit14 |
+	     trace->type.bit15 | trace->type.bit16 | trace->type.bit17 |
+	     trace->type.bit18 | trace->type.bit19 | trace->type.bit20 |
+	     trace->type.bit21)) {
+		return;
+	}
+
+	/* NodeLen does not include Opaque State Snapshot length. We need to
+	 * take it into account if the corresponding bit is set (bit 22) and
+	 * if the current IOAM namespace has an active schema attached to it
+	 */
+	if (trace->type.bit22) {
+		sclen = sizeof_field(struct ioam6_schema, hdr) / 4;
+
+		if (ns->schema)
+			sclen += ns->schema->len / 4;
+	}
+
+	/* If there is no space remaining, we set the Overflow flag and we
+	 * skip without filling the trace
+	 */
+	if (!trace->remlen || trace->remlen < (trace->nodelen + sclen)) {
+		trace->overflow = 1;
+		return;
+	}
+
+	__ioam6_fill_trace_data(skb, ns, trace, sclen);
+	trace->remlen -= trace->nodelen + sclen;
+}
+
+static int __net_init ioam6_net_init(struct net *net)
+{
+	struct ioam6_pernet_data *nsdata;
+	int err = -ENOMEM;
+
+	nsdata = kzalloc(sizeof(*nsdata), GFP_KERNEL);
+	if (!nsdata)
+		goto out;
+
+	mutex_init(&nsdata->lock);
+	net->ipv6.ioam6_data = nsdata;
+
+	err = rhashtable_init(&nsdata->namespaces, &rht_ns_params);
+	if (err)
+		goto free_nsdata;
+
+	err = rhashtable_init(&nsdata->schemas, &rht_sc_params);
+	if (err)
+		goto free_rht_ns;
+
+out:
+	return err;
+free_rht_ns:
+	rhashtable_destroy(&nsdata->namespaces);
+free_nsdata:
+	kfree(nsdata);
+	net->ipv6.ioam6_data = NULL;
+	goto out;
+}
+
+static void __net_exit ioam6_net_exit(struct net *net)
+{
+	struct ioam6_pernet_data *nsdata = ioam6_pernet(net);
+
+	rhashtable_free_and_destroy(&nsdata->namespaces, ioam6_free_ns, NULL);
+	rhashtable_free_and_destroy(&nsdata->schemas, ioam6_free_sc, NULL);
+
+	kfree(nsdata);
+}
+
+static struct pernet_operations ioam6_net_ops = {
+	.init = ioam6_net_init,
+	.exit = ioam6_net_exit,
+};
+
+int __init ioam6_init(void)
+{
+	int err = register_pernet_subsys(&ioam6_net_ops);
+
+	if (err)
+		return err;
+
+	pr_info("In-situ OAM (IOAM) with IPv6\n");
+	return 0;
+}
+
+void ioam6_exit(void)
+{
+	unregister_pernet_subsys(&ioam6_net_ops);
+}
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index d7cf26f730d7..b97aad7b6aca 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -196,6 +196,13 @@ static struct ctl_table ipv6_table_template[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &two,
 	},
+	{
+		.procname	= "ioam6_id",
+		.data		= &init_net.ipv6.sysctl.ioam6_id,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{ }
 };
 
-- 
2.17.1

