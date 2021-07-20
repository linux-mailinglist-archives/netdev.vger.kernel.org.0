Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3078A3D025E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhGTTOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:14:11 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37791 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhGTTNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:13:11 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 01989200F805;
        Tue, 20 Jul 2021 21:43:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 01989200F805
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626810206;
        bh=vyqu+pqmK/ZNa7HKakyrfz3AO/AosjGRWRAgsvDAWe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2WmxVTrRWYeX2kpG+wipOpOavXNNPY+FkubiSSWazL5V7ZTsForLSVdwX6EqyLkZ
         EZqzwpizqSYnNDAwBQT2vkqcSZ1g2qoBmlDPxDAeYK7+TLi/QBH+15NSrNReWCmA/1
         eRvBA8fWqXy9yXACkz8vjuTg4xzMxkEqMc1PUKx1LvI1Fw8oouPuRN2l4EZeix16/U
         wFkvR4wpcGBc7V0CKWuRfzx8he6njrVMQs7RAx0AI4JvDJ63M4c3AgxSWVSPOHNK+d
         z8aLU0YgFVLMmoN2fQnPsgMELJHQbZ4sTENb5zY3sO3hLJMvma7MqQIVOG40Icn90I
         DMfunDz4HwUwA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, justin.iurman@uliege.be
Subject: [PATCH net-next v5 2/6] ipv6: ioam: Data plane support for Pre-allocated Trace
Date:   Tue, 20 Jul 2021 21:42:57 +0200
Message-Id: <20210720194301.23243-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720194301.23243-1-justin.iurman@uliege.be>
References: <20210720194301.23243-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for processing the IOAM Pre-allocated Trace with IPv6,
see [1] and [2]. Introduce a new IPv6 Hop-by-Hop TLV option, see IANA [3].

A new per-interface sysctl is introduced. The value is a boolean to accept (=1)
or ignore (=0, by default) IPv6 IOAM options on ingress for an interface:
 - net.ipv6.conf.XXX.ioam6_enabled

Two other sysctls are introduced to define IOAM IDs, represented by an integer.
They are respectively per-namespace and per-interface:
 - net.ipv6.ioam6_id
 - net.ipv6.conf.XXX.ioam6_id

The value of the first one represents the IOAM ID of the node itself (u32; max
and default value = U32_MAX>>8, due to hop limit concatenation) while the other
represents the IOAM ID of an interface (u16; max and default value = U16_MAX).

Each "ioam6_id" sysctl has a "_wide" equivalent:
 - net.ipv6.ioam6_id_wide
 - net.ipv6.conf.XXX.ioam6_id_wide

The value of the first one represents the wide IOAM ID of the node itself (u64;
max and default value = U64_MAX>>8, due to hop limit concatenation) while the
other represents the wide IOAM ID of an interface (u32; max and default value
= U32_MAX).

The use of short and wide equivalents is not exclusive, a deployment could
choose to leverage both. For example, net.ipv6.conf.XXX.ioam6_id (short format)
could be an identifier for a physical interface, whereas
net.ipv6.conf.XXX.ioam6_id_wide (wide format) could be an identifier for a
logical sub-interface. Documentation about new sysctls is provided at the end
of this patchset.

Two relativistic hash tables are used: one for IOAM namespaces, the other for
IOAM schemas. A namespace can only have a single active schema and a schema
can only be attached to a single namespace (1:1 relationship).

  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
  [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ioam6.h      |  13 ++
 include/linux/ipv6.h       |   3 +
 include/net/ioam6.h        |  64 +++++++
 include/net/netns/ipv6.h   |   3 +
 include/uapi/linux/in6.h   |   1 +
 include/uapi/linux/ioam6.h |   9 +
 include/uapi/linux/ipv6.h  |   3 +
 net/ipv6/Makefile          |   2 +-
 net/ipv6/addrconf.c        |  37 +++++
 net/ipv6/af_inet6.c        |  10 ++
 net/ipv6/exthdrs.c         |  61 +++++++
 net/ipv6/ioam6.c           | 333 +++++++++++++++++++++++++++++++++++++
 net/ipv6/sysctl_net_ipv6.c |  19 +++
 13 files changed, 557 insertions(+), 1 deletion(-)
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
index 70b2ad3b9884..ef4a69865737 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -76,6 +76,9 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__u32		ioam6_id;
+	__u32		ioam6_id_wide;
+	__u8		ioam6_enabled;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/net/ioam6.h b/include/net/ioam6.h
new file mode 100644
index 000000000000..772b91ee2e87
--- /dev/null
+++ b/include/net/ioam6.h
@@ -0,0 +1,64 @@
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
+	struct ioam6_schema __rcu *schema;
+
+	__be16 id;
+	__be32 data;
+	__be64 data_wide;
+};
+
+struct ioam6_schema {
+	struct rhash_head head;
+	struct rcu_head rcu;
+
+	struct ioam6_namespace __rcu *ns;
+
+	u32 id;
+	int len;
+	__be32 hdr;
+
+	u8 data[0];
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
+struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id);
+void ioam6_fill_trace_data(struct sk_buff *skb,
+			   struct ioam6_namespace *ns,
+			   struct ioam6_trace_hdr *trace);
+
+int ioam6_init(void);
+void ioam6_exit(void);
+
+#endif /* _NET_IOAM6_H */
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index bde0b7adb4a3..a4b550380316 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -51,6 +51,8 @@ struct netns_sysctl_ipv6 {
 	int max_dst_opts_len;
 	int max_hbh_opts_len;
 	int seg6_flowlabel;
+	u32 ioam6_id;
+	u64 ioam6_id_wide;
 	bool skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
 };
@@ -110,6 +112,7 @@ struct netns_ipv6 {
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
 
diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
index 2177e4e49566..23ba6e85582f 100644
--- a/include/uapi/linux/ioam6.h
+++ b/include/uapi/linux/ioam6.h
@@ -12,6 +12,15 @@
 #include <asm/byteorder.h>
 #include <linux/types.h>
 
+#define IOAM6_U16_UNAVAILABLE U16_MAX
+#define IOAM6_U32_UNAVAILABLE U32_MAX
+#define IOAM6_U64_UNAVAILABLE U64_MAX
+
+#define IOAM6_DEFAULT_ID (IOAM6_U32_UNAVAILABLE >> 8)
+#define IOAM6_DEFAULT_ID_WIDE (IOAM6_U64_UNAVAILABLE >> 8)
+#define IOAM6_DEFAULT_IF_ID IOAM6_U16_UNAVAILABLE
+#define IOAM6_DEFAULT_IF_ID_WIDE IOAM6_U32_UNAVAILABLE
+
 /*
  * IPv6 IOAM Option Header
  */
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..b243a53fa985 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,9 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_IOAM6_ENABLED,
+	DEVCONF_IOAM6_ID,
+	DEVCONF_IOAM6_ID_WIDE,
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
index bc330fffb4a8..1802287977f1 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -89,12 +89,15 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/export.h>
+#include <linux/ioam6.h>
 
 #define	INFINITY_LIFE_TIME	0xFFFFFFFF
 
 #define IPV6_MAX_STRLEN \
 	sizeof("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255")
 
+static u32 ioam6_if_id_max = U16_MAX;
+
 static inline u32 cstamp_delta(unsigned long cstamp)
 {
 	return (cstamp - INITIAL_JIFFIES) * 100UL / HZ;
@@ -237,6 +240,9 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ioam6_enabled		= 0,
+	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
+	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -293,6 +299,9 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ioam6_enabled		= 0,
+	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
+	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5524,6 +5533,9 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+	array[DEVCONF_IOAM6_ENABLED] = cnf->ioam6_enabled;
+	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
+	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6930,6 +6942,31 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "ioam6_enabled",
+		.data		= &ipv6_devconf.ioam6_enabled,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= (void *)SYSCTL_ZERO,
+		.extra2		= (void *)SYSCTL_ONE,
+	},
+	{
+		.procname	= "ioam6_id",
+		.data		= &ipv6_devconf.ioam6_id,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= (void *)SYSCTL_ZERO,
+		.extra2		= (void *)&ioam6_if_id_max,
+	},
+	{
+		.procname	= "ioam6_id_wide",
+		.data		= &ipv6_devconf.ioam6_id_wide,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2389ff702f51..d92c90d97763 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -62,6 +62,7 @@
 #include <net/rpl.h>
 #include <net/compat.h>
 #include <net/xfrm.h>
+#include <net/ioam6.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -961,6 +962,9 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.fib_notify_on_flag_change = 0;
 	atomic_set(&net->ipv6.fib6_sernum, 1);
 
+	net->ipv6.sysctl.ioam6_id = IOAM6_DEFAULT_ID;
+	net->ipv6.sysctl.ioam6_id_wide = IOAM6_DEFAULT_ID_WIDE;
+
 	err = ipv6_init_mibs(net);
 	if (err)
 		return err;
@@ -1191,6 +1195,10 @@ static int __init inet6_init(void)
 	if (err)
 		goto rpl_fail;
 
+	err = ioam6_init();
+	if (err)
+		goto ioam6_fail;
+
 	err = igmp6_late_init();
 	if (err)
 		goto igmp6_late_err;
@@ -1213,6 +1221,8 @@ static int __init inet6_init(void)
 	igmp6_late_cleanup();
 #endif
 igmp6_late_err:
+	ioam6_exit();
+ioam6_fail:
 	rpl_exit();
 rpl_fail:
 	seg6_exit();
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 26882e165c9e..d897faa4e9e6 100644
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
 
@@ -928,6 +931,60 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
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
+	/* Bad alignment (must be 4n-aligned) */
+	if (optoff & 3)
+		goto drop;
+
+	/* Ignore if IOAM is not enabled on ingress */
+	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
+		goto ignore;
+
+	/* Truncated Option header */
+	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
+	if (hdr->opt_len < 2)
+		goto drop;
+
+	switch (hdr->type) {
+	case IOAM6_TYPE_PREALLOC:
+		/* Truncated Pre-allocated Trace header */
+		if (hdr->opt_len < 2 + sizeof(*trace))
+			goto drop;
+
+		/* Malformed Pre-allocated Trace header */
+		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
+		if (hdr->opt_len < 2 + sizeof(*trace) + trace->remlen * 4)
+			goto drop;
+
+		/* Ignore if the IOAM namespace is unknown */
+		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);
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
@@ -999,6 +1056,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
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
index 000000000000..ba629e1b9408
--- /dev/null
+++ b/net/ipv6/ioam6.c
@@ -0,0 +1,333 @@
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
+				    struct ioam6_schema *sc,
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
+
+		*(__be32 *)data = cpu_to_be32((byte << 24) | raw32);
+		data += sizeof(__be32);
+	}
+
+	/* ingress_if_id and egress_if_id */
+	if (trace->type.bit1) {
+		if (!skb->dev)
+			raw16 = IOAM6_U16_UNAVAILABLE;
+		else
+			raw16 = (__force u16)__in6_dev_get(skb->dev)->cnf.ioam6_id;
+
+		*(__be16 *)data = cpu_to_be16(raw16);
+		data += sizeof(__be16);
+
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK)
+			raw16 = IOAM6_U16_UNAVAILABLE;
+		else
+			raw16 = (__force u16)__in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id;
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
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* namespace data */
+	if (trace->type.bit5) {
+		*(__be32 *)data = ns->data;
+		data += sizeof(__be32);
+	}
+
+	/* queue depth */
+	if (trace->type.bit6) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* checksum complement */
+	if (trace->type.bit7) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* hop_lim and node_id (wide) */
+	if (trace->type.bit8) {
+		byte = ipv6_hdr(skb)->hop_limit;
+		if (skb->dev)
+			byte--;
+
+		raw64 = dev_net(skb->dev)->ipv6.sysctl.ioam6_id_wide;
+
+		*(__be64 *)data = cpu_to_be64(((u64)byte << 56) | raw64);
+		data += sizeof(__be64);
+	}
+
+	/* ingress_if_id and egress_if_id (wide) */
+	if (trace->type.bit9) {
+		if (!skb->dev)
+			raw32 = IOAM6_U32_UNAVAILABLE;
+		else
+			raw32 = __in6_dev_get(skb->dev)->cnf.ioam6_id_wide;
+
+		*(__be32 *)data = cpu_to_be32(raw32);
+		data += sizeof(__be32);
+
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK)
+			raw32 = IOAM6_U32_UNAVAILABLE;
+		else
+			raw32 = __in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id_wide;
+
+		*(__be32 *)data = cpu_to_be32(raw32);
+		data += sizeof(__be32);
+	}
+
+	/* namespace data (wide) */
+	if (trace->type.bit10) {
+		*(__be64 *)data = ns->data_wide;
+		data += sizeof(__be64);
+	}
+
+	/* buffer occupancy */
+	if (trace->type.bit11) {
+		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
+		data += sizeof(__be32);
+	}
+
+	/* opaque state snapshot */
+	if (trace->type.bit22) {
+		if (!sc) {
+			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE >> 8);
+		} else {
+			*(__be32 *)data = sc->hdr;
+			data += sizeof(__be32);
+
+			memcpy(data, sc->data, sc->len);
+		}
+	}
+}
+
+/* called with rcu_read_lock() */
+void ioam6_fill_trace_data(struct sk_buff *skb,
+			   struct ioam6_namespace *ns,
+			   struct ioam6_trace_hdr *trace)
+{
+	struct ioam6_schema *sc;
+	u8 sclen = 0;
+
+	/* Skip if Overflow flag is set OR
+	 * if an unknown type (bit 12-21) is set
+	 */
+	if (trace->overflow ||
+	    trace->type.bit12 | trace->type.bit13 | trace->type.bit14 |
+	    trace->type.bit15 | trace->type.bit16 | trace->type.bit17 |
+	    trace->type.bit18 | trace->type.bit19 | trace->type.bit20 |
+	    trace->type.bit21) {
+		return;
+	}
+
+	/* NodeLen does not include Opaque State Snapshot length. We need to
+	 * take it into account if the corresponding bit is set (bit 22) and
+	 * if the current IOAM namespace has an active schema attached to it
+	 */
+	sc = rcu_dereference(ns->schema);
+	if (trace->type.bit22) {
+		sclen = sizeof_field(struct ioam6_schema, hdr) / 4;
+
+		if (sc)
+			sclen += sc->len / 4;
+	}
+
+	/* If there is no space remaining, we set the Overflow flag and we
+	 * skip without filling the trace
+	 */
+	if (!trace->remlen || trace->remlen < trace->nodelen + sclen) {
+		trace->overflow = 1;
+		return;
+	}
+
+	__ioam6_fill_trace_data(skb, ns, trace, sc, sclen);
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
index d7cf26f730d7..d53dd142bf87 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -21,6 +21,7 @@
 #ifdef CONFIG_NETLABEL
 #include <net/calipso.h>
 #endif
+#include <linux/ioam6.h>
 
 static int two = 2;
 static int three = 3;
@@ -28,6 +29,8 @@ static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 static u32 rt6_multipath_hash_fields_all_mask =
 	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
+static u32 ioam6_id_max = IOAM6_DEFAULT_ID;
+static u64 ioam6_id_wide_max = IOAM6_DEFAULT_ID_WIDE;
 
 static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp, loff_t *ppos)
@@ -196,6 +199,22 @@ static struct ctl_table ipv6_table_template[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &two,
 	},
+	{
+		.procname	= "ioam6_id",
+		.data		= &init_net.ipv6.sysctl.ioam6_id,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra2		= &ioam6_id_max,
+	},
+	{
+		.procname	= "ioam6_id_wide",
+		.data		= &init_net.ipv6.sysctl.ioam6_id_wide,
+		.maxlen		= sizeof(u64),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra2		= &ioam6_id_wide_max,
+	},
 	{ }
 };
 
-- 
2.25.1

