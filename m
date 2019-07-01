Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957FF3CCF5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391019AbfFKN2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:28:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42377 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728982AbfFKN2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 09:28:41 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Jun 2019 16:28:36 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5BDSaYO020504;
        Tue, 11 Jun 2019 16:28:36 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next 1/3] net/sched: Introduce action ct
Date:   Tue, 11 Jun 2019 16:28:31 +0300
Message-Id: <1560259713-25603-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow sending a packet to conntrack and set conntrack zone, mark,
labels and nat parameters.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Yossi Kuperman <yossiku@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h        |   5 +
 include/net/tc_act/tc_ct.h        |  64 +++
 include/uapi/linux/pkt_cls.h      |   2 +
 include/uapi/linux/tc_act/tc_ct.h |  41 ++
 net/sched/Kconfig                 |  11 +
 net/sched/Makefile                |   1 +
 net/sched/act_ct.c                | 901 ++++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c               |   5 +
 8 files changed, 1030 insertions(+)
 create mode 100644 include/net/tc_act/tc_ct.h
 create mode 100644 include/uapi/linux/tc_act/tc_ct.h
 create mode 100644 net/sched/act_ct.c

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 36fdb85..5b2c4fa 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -123,6 +123,7 @@ enum flow_action_id {
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
 	FLOW_ACTION_POLICE,
+	FLOW_ACTION_CT,
 };
 
 /* This is mirroring enum pedit_header_type definition for easy mapping between
@@ -172,6 +173,10 @@ struct flow_action_entry {
 			s64			burst;
 			u64			rate_bytes_ps;
 		} police;
+		struct {				/* FLOW_ACTION_CT */
+			int action;
+			u16 zone;
+		} ct;
 	};
 };
 
diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
new file mode 100644
index 0000000..59e4f5e
--- /dev/null
+++ b/include/net/tc_act/tc_ct.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_CT_H
+#define __NET_TC_CT_H
+
+#include <net/act_api.h>
+#include <uapi/linux/tc_act/tc_ct.h>
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_conntrack_labels.h>
+
+struct tcf_ct_params {
+	struct nf_conn *tmpl;
+	u16 zone;
+
+	u32 mark;
+	u32 mark_mask;
+
+	u32 labels[NF_CT_LABELS_MAX_SIZE / sizeof(u32)];
+	u32 labels_mask[NF_CT_LABELS_MAX_SIZE / sizeof(u32)];
+
+	struct nf_nat_range2 range;
+	bool ipv4_range;
+
+	u16 ct_action;
+
+	struct rcu_head rcu;
+
+};
+
+struct tcf_ct {
+	struct tc_action common;
+	struct tcf_ct_params __rcu *params;
+};
+
+#define to_ct(a) ((struct tcf_ct *)a)
+#define to_ct_params(a) ((struct tcf_ct_params *) \
+			 rtnl_dereference((to_ct(a)->params)))
+
+static inline uint16_t tcf_ct_zone(const struct tc_action *a)
+{
+	return to_ct_params(a)->zone;
+}
+
+static inline int tcf_ct_action(const struct tc_action *a)
+{
+	return to_ct_params(a)->ct_action;
+}
+
+#else
+static inline uint16_t tcf_ct_zone(const struct tc_action *a) { return 0; }
+static inline int tcf_ct_action(const struct tc_action *a) { return 0; }
+#endif /* CONFIG_NF_CONNTRACK */
+
+static inline bool is_tcf_ct(const struct tc_action *a)
+{
+#if defined(CONFIG_NET_CLS_ACT) && IS_ENABLED(CONFIG_NF_CONNTRACK)
+	if (a->ops && a->ops->id == TCA_ID_CT)
+		return true;
+#endif
+	return false;
+}
+
+#endif /* __NET_TC_CT_H */
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a93680f..c5264d7 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -83,6 +83,7 @@ enum {
 #define TCA_ACT_SIMP 22
 #define TCA_ACT_IFE 25
 #define TCA_ACT_SAMPLE 26
+#define TCA_ACT_CT 27
 
 /* Action type identifiers*/
 enum tca_id {
@@ -106,6 +107,7 @@ enum tca_id {
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
 	/* other actions go here */
 	TCA_ID_CTINFO,
+	TCA_ID_CT,
 	__TCA_ID_MAX = 255
 };
 
diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
new file mode 100644
index 0000000..5fb1d7a
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __UAPI_TC_CT_H
+#define __UAPI_TC_CT_H
+
+#include <linux/types.h>
+#include <linux/pkt_cls.h>
+
+enum {
+	TCA_CT_UNSPEC,
+	TCA_CT_PARMS,
+	TCA_CT_TM,
+	TCA_CT_ACTION,		/* u16 */
+	TCA_CT_ZONE,		/* u16 */
+	TCA_CT_MARK,		/* u32 */
+	TCA_CT_MARK_MASK,	/* u32 */
+	TCA_CT_LABELS,		/* u128 */
+	TCA_CT_LABELS_MASK,	/* u128 */
+	TCA_CT_NAT_IPV4_MIN,	/* be32 */
+	TCA_CT_NAT_IPV4_MAX,	/* be32 */
+	TCA_CT_NAT_IPV6_MIN,	/* struct in6_addr */
+	TCA_CT_NAT_IPV6_MAX,	/* struct in6_addr */
+	TCA_CT_NAT_PORT_MIN,	/* be16 */
+	TCA_CT_NAT_PORT_MAX,	/* be16 */
+	TCA_CT_PAD,
+	__TCA_CT_MAX
+};
+
+#define TCA_CT_MAX (__TCA_CT_MAX - 1)
+
+#define TCA_CT_ACT_COMMIT	(1 << 0)
+#define TCA_CT_ACT_FORCE	(1 << 1)
+#define TCA_CT_ACT_CLEAR	(1 << 2)
+#define TCA_CT_ACT_NAT		(1 << 3)
+#define TCA_CT_ACT_NAT_SRC	(1 << 4)
+#define TCA_CT_ACT_NAT_DST	(1 << 5)
+
+struct tc_ct {
+	tc_gen;
+};
+
+#endif /* __UAPI_TC_CT_H */
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index d104f7e..0481a2a 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -929,6 +929,17 @@ config NET_ACT_TUNNEL_KEY
 	  To compile this code as a module, choose M here: the
 	  module will be called act_tunnel_key.
 
+config NET_ACT_CT
+        tristate "connection tracking tc action"
+        depends on NET_CLS_ACT && NF_CONNTRACK
+        help
+	  Say Y here to allow sending the packets to conntrack module.
+
+	  If unsure, say N.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called act_ct.
+
 config NET_IFE_SKBMARK
         tristate "Support to encoding decoding skb mark on IFE action"
         depends on NET_ACT_IFE
diff --git a/net/sched/Makefile b/net/sched/Makefile
index d54bfcb..23d2202 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_NET_IFE_SKBMARK)	+= act_meta_mark.o
 obj-$(CONFIG_NET_IFE_SKBPRIO)	+= act_meta_skbprio.o
 obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
+obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
 obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
 obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
new file mode 100644
index 0000000..4eb0dd7
--- /dev/null
+++ b/net/sched/act_ct.c
@@ -0,0 +1,901 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* -
+ * net/sched/act_ct.c  Connection Tracking action
+ *
+ * Authors:   Paul Blakey <paulb@mellanox.com>
+ *            Yossi Kuperman <yossiku@mellanox.com>
+ *            Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/rtnetlink.h>
+#include <linux/pkt_cls.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/netlink.h>
+#include <net/pkt_sched.h>
+#include <net/act_api.h>
+#include <uapi/linux/tc_act/tc_ct.h>
+#include <net/tc_act/tc_ct.h>
+
+#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/pkt_cls.h>
+
+static struct tc_action_ops act_ct_ops;
+static unsigned int ct_net_id;
+
+struct tc_ct_action_net {
+	struct tc_action_net tn; /* Must be first */
+	bool labels;
+};
+
+/* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
+static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
+				   u16 zone_id, bool force)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return false;
+	if (!net_eq(net, read_pnet(&ct->ct_net)))
+		return false;
+	if (nf_ct_zone(ct)->id != zone_id)
+		return false;
+
+	/* Force conntrack entry direction. */
+	if (force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
+		nf_conntrack_put(&ct->ct_general);
+		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+
+		if (nf_ct_is_confirmed(ct))
+			nf_ct_kill(ct);
+
+		return false;
+	}
+
+	return true;
+}
+
+/* Trim the skb to the length specified by the IP/IPv6 header,
+ * removing any trailing lower-layer padding. This prepares the skb
+ * for higher-layer processing that assumes skb->len excludes padding
+ * (such as nf_ip_checksum). The caller needs to pull the skb to the
+ * network header, and ensure ip_hdr/ipv6_hdr points to valid data.
+ */
+static int tcf_ct_skb_network_trim(struct sk_buff *skb)
+{
+	unsigned int len;
+	int err;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		len = ntohs(ip_hdr(skb)->tot_len);
+		break;
+	case htons(ETH_P_IPV6):
+		len = sizeof(struct ipv6hdr)
+			+ ntohs(ipv6_hdr(skb)->payload_len);
+		break;
+	default:
+		len = skb->len;
+	}
+
+	err = pskb_trim_rcsum(skb, len);
+
+	return err;
+}
+
+static u8 tcf_ct_skb_nf_family(struct sk_buff *skb)
+{
+	u8 family = NFPROTO_UNSPEC;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		family = NFPROTO_IPV4;
+		break;
+	case htons(ETH_P_IPV6):
+		family = NFPROTO_IPV6;
+		break;
+	default:
+	break;
+	}
+
+	return family;
+}
+
+static void tcf_ct_params_free(struct rcu_head *head)
+{
+	struct tcf_ct_params *params = container_of(head,
+						    struct tcf_ct_params, rcu);
+
+	if (params->tmpl)
+		nf_conntrack_put(&params->tmpl->ct_general);
+	kfree(params);
+}
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+/* Modelled after nf_nat_ipv[46]_fn().
+ * range is only used for new, uninitialized NAT state.
+ * Returns either NF_ACCEPT or NF_DROP.
+ */
+static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
+			  enum ip_conntrack_info ctinfo,
+			  const struct nf_nat_range2 *range,
+			  enum nf_nat_manip_type maniptype)
+{
+	int hooknum, nh_off, err = NF_ACCEPT;
+
+	nh_off = skb_network_offset(skb);
+	skb_pull_rcsum(skb, nh_off);
+
+	/* See HOOK2MANIP(). */
+	if (maniptype == NF_NAT_MANIP_SRC)
+		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
+	else
+		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
+
+	switch (ctinfo) {
+	case IP_CT_RELATED:
+	case IP_CT_RELATED_REPLY:
+		if (skb->protocol == htons(ETH_P_IP) &&
+		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
+			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
+							   hooknum))
+				err = NF_DROP;
+			goto push;
+		} else if (IS_ENABLED(CONFIG_IPV6) &&
+			   skb->protocol == htons(ETH_P_IPV6)) {
+			__be16 frag_off;
+			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+			int hdrlen = ipv6_skip_exthdr(skb,
+						      sizeof(struct ipv6hdr),
+						      &nexthdr, &frag_off);
+
+			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
+				if (!nf_nat_icmpv6_reply_translation(skb, ct,
+								     ctinfo,
+								     hooknum,
+								     hdrlen))
+					err = NF_DROP;
+				goto push;
+			}
+		}
+		/* Non-ICMP, fall thru to initialize if needed. */
+		/* fall through */
+	case IP_CT_NEW:
+		/* Seen it before?  This can happen for loopback, retrans,
+		 * or local packets.
+		 */
+		if (!nf_nat_initialized(ct, maniptype)) {
+			/* Initialize according to the NAT action. */
+			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
+				/* Action is set up to establish a new
+				 * mapping.
+				 */
+				? nf_nat_setup_info(ct, range, maniptype)
+				: nf_nat_alloc_null_binding(ct, hooknum);
+			if (err != NF_ACCEPT)
+				goto push;
+		}
+		break;
+
+	case IP_CT_ESTABLISHED:
+	case IP_CT_ESTABLISHED_REPLY:
+		break;
+
+	default:
+		err = NF_DROP;
+		goto push;
+	}
+
+	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+push:
+	skb_push(skb, nh_off);
+	skb_postpush_rcsum(skb, skb->data, nh_off);
+
+	return err;
+}
+#endif /* CONFIG_NF_NAT */
+
+static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
+	u32 new_mark;
+
+	if (!mask)
+		return;
+
+	new_mark = mark | (ct->mark & ~(mask));
+	if (ct->mark != new_mark) {
+		ct->mark = new_mark;
+		if (nf_ct_is_confirmed(ct))
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+	}
+#endif
+}
+
+static void tcf_ct_act_set_labels(struct nf_conn *ct,
+				  u32 *labels,
+				  u32 *labels_m)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)
+	size_t labels_sz = FIELD_SIZEOF(struct tcf_ct_params, labels);
+
+	if (!memchr_inv(labels_m, 0, labels_sz))
+		return;
+
+	nf_connlabels_replace(ct, labels, labels_m, 4);
+#endif
+}
+
+static int tcf_ct_act_nat(struct sk_buff *skb,
+			  struct nf_conn *ct,
+			  enum ip_conntrack_info ctinfo,
+			  int ct_action,
+			  struct nf_nat_range2 *range,
+			  bool commit)
+{
+#if IS_ENABLED(CONFIG_NF_NAT)
+	enum nf_nat_manip_type maniptype;
+
+	if (!(ct_action & TCA_CT_ACT_NAT))
+		return NF_ACCEPT;
+
+	/* Add NAT extension if not confirmed yet. */
+	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
+		return NF_DROP;   /* Can't NAT. */
+
+	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
+	    (ctinfo != IP_CT_RELATED || commit)) {
+		/* NAT an established or related connection like before. */
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
+			/* This is the REPLY direction for a connection
+			 * for which NAT was applied in the forward
+			 * direction.  Do the reverse NAT.
+			 */
+			maniptype = ct->status & IPS_SRC_NAT
+				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
+		else
+			maniptype = ct->status & IPS_SRC_NAT
+				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
+	} else if (ct_action & TCA_CT_ACT_NAT_SRC) {
+		maniptype = NF_NAT_MANIP_SRC;
+	} else if (ct_action & TCA_CT_ACT_NAT_DST) {
+		maniptype = NF_NAT_MANIP_DST;
+	} else {
+		return NF_ACCEPT;
+	}
+
+	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+#else
+	return NF_ACCEPT;
+#endif
+}
+
+static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
+		      struct tcf_result *res)
+{
+	struct net *net = dev_net(skb->dev);
+	bool cached, commit, clear, force;
+	enum ip_conntrack_info ctinfo;
+	struct tcf_ct *c = to_ct(a);
+	struct nf_conn *tmpl = NULL;
+	struct nf_hook_state state;
+	struct tcf_ct_params *p;
+	struct nf_conn *ct;
+	int nh_ofs, err;
+	u8 family;
+
+	p = rcu_dereference_bh(c->params);
+
+	commit = p->ct_action & TCA_CT_ACT_COMMIT;
+	clear = p->ct_action & TCA_CT_ACT_CLEAR;
+	force = p->ct_action & TCA_CT_ACT_FORCE;
+	tmpl = p->tmpl;
+
+	if (clear) {
+		ct = nf_ct_get(skb, &ctinfo);
+		if (ct) {
+			nf_conntrack_put(&ct->ct_general);
+			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+		}
+
+		goto out;
+	}
+
+	/* The conntrack module expects to be working at L3. */
+	nh_ofs = skb_network_offset(skb);
+	skb_pull_rcsum(skb, nh_ofs);
+
+	err = tcf_ct_skb_network_trim(skb);
+	if (err)
+		goto drop;
+
+	family = tcf_ct_skb_nf_family(skb);
+	if (family == NFPROTO_UNSPEC)
+		goto drop;
+
+	state.hook = NF_INET_PRE_ROUTING;
+	state.net = net;
+	state.pf = family;
+
+	/* If we are recirculating packets to match on ct fields and
+	 * committing with a separate ct action, then we don't need to
+	 * actually run the packet through conntrack twice unless it's for a
+	 * different zone.
+	 */
+	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
+	if (!cached) {
+		/* Associate skb with specified zone. */
+		if (tmpl) {
+			if (skb_nfct(skb))
+				nf_conntrack_put(skb_nfct(skb));
+			nf_conntrack_get(&tmpl->ct_general);
+			nf_ct_set(skb, tmpl, IP_CT_NEW);
+		}
+
+		err = nf_conntrack_in(skb, &state);
+		if (err != NF_ACCEPT)
+			goto out_push;
+	}
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		goto out_push;
+	nf_ct_deliver_cached_events(ct);
+
+	err = tcf_ct_act_nat(skb, ct, ctinfo, p->ct_action, &p->range, commit);
+	if (err != NF_ACCEPT)
+		goto drop;
+
+	if (commit) {
+		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
+		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
+
+		/* This will take care of sending queued events
+		 * even if the connection is already confirmed.
+		 */
+		nf_conntrack_confirm(skb);
+	}
+
+out_push:
+	skb_push(skb, nh_ofs);
+	skb_postpush_rcsum(skb, skb->data, nh_ofs);
+
+out:
+	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+
+	return c->tcf_action;
+
+drop:
+	qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+	return TC_ACT_SHOT;
+}
+
+static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
+	[TCA_CT_ACTION] = { .type = NLA_U16 },
+	[TCA_CT_PARMS] = { .type = NLA_EXACT_LEN, .len = sizeof(struct tc_ct) },
+	[TCA_CT_ZONE] = { .type = NLA_U16 },
+	[TCA_CT_MARK] = { .type = NLA_U32 },
+	[TCA_CT_MARK_MASK] = { .type = NLA_U32 },
+	[TCA_CT_LABELS] = { .type = NLA_BINARY,
+			    .len = 128 / BITS_PER_BYTE },
+	[TCA_CT_LABELS_MASK] = { .type = NLA_BINARY,
+				 .len = 128 / BITS_PER_BYTE },
+	[TCA_CT_NAT_IPV4_MIN] = { .type = NLA_U32 },
+	[TCA_CT_NAT_IPV4_MAX] = { .type = NLA_U32 },
+	[TCA_CT_NAT_IPV6_MIN] = { .type = NLA_EXACT_LEN,
+				  .len = sizeof(struct in6_addr) },
+	[TCA_CT_NAT_IPV6_MAX] = { .type = NLA_EXACT_LEN,
+				   .len = sizeof(struct in6_addr) },
+	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
+	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
+};
+
+static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
+				  struct tc_ct *parm,
+				  struct nlattr **tb,
+				  struct netlink_ext_ack *extack)
+{
+	struct nf_nat_range2 *range;
+
+	if (!(p->ct_action & TCA_CT_ACT_NAT))
+		return 0;
+
+	if (!IS_ENABLED(CONFIG_NF_NAT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Netfilter nat isn't enabled in kernel");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(p->ct_action & (TCA_CT_ACT_NAT_SRC | TCA_CT_ACT_NAT_DST)))
+		return 0;
+
+	if ((p->ct_action & TCA_CT_ACT_NAT_SRC) &&
+	    (p->ct_action & TCA_CT_ACT_NAT_DST)) {
+		NL_SET_ERR_MSG_MOD(extack, "dnat and snat can't be enabled at the same time");
+		return -EOPNOTSUPP;
+	}
+
+	range = &p->range;
+	if (tb[TCA_CT_NAT_IPV4_MIN]) {
+		range->min_addr.ip =
+			nla_get_in_addr(tb[TCA_CT_NAT_IPV4_MIN]);
+		range->flags |= NF_NAT_RANGE_MAP_IPS;
+		p->ipv4_range = true;
+	}
+	if (tb[TCA_CT_NAT_IPV4_MAX]) {
+		range->max_addr.ip =
+			nla_get_in_addr(tb[TCA_CT_NAT_IPV4_MAX]);
+		range->flags |= NF_NAT_RANGE_MAP_IPS;
+		p->ipv4_range = true;
+	} else if (range->min_addr.ip) {
+		range->max_addr.ip = range->min_addr.ip;
+	}
+
+	if (tb[TCA_CT_NAT_IPV6_MIN]) {
+		range->min_addr.in6 =
+			nla_get_in6_addr(tb[TCA_CT_NAT_IPV6_MIN]);
+		range->flags |= NF_NAT_RANGE_MAP_IPS;
+		p->ipv4_range = false;
+	}
+	if (tb[TCA_CT_NAT_IPV6_MAX]) {
+		range->max_addr.in6 =
+			nla_get_in6_addr(tb[TCA_CT_NAT_IPV6_MAX]);
+		range->flags |= NF_NAT_RANGE_MAP_IPS;
+		p->ipv4_range = false;
+	} else if (memchr_inv(&range->min_addr.in6, 0,
+		   sizeof(range->min_addr.in6))) {
+		range->max_addr.in6 = range->min_addr.in6;
+	}
+
+	if (tb[TCA_CT_NAT_PORT_MIN]) {
+		range->min_proto.all =
+			htons(nla_get_u16(tb[TCA_CT_NAT_PORT_MIN]));
+		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+	if (tb[TCA_CT_NAT_PORT_MAX]) {
+		range->max_proto.all =
+			htons(nla_get_u16(tb[TCA_CT_NAT_PORT_MAX]));
+		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	} else if (range->min_proto.all) {
+		range->max_proto.all = range->min_proto.all;
+	}
+
+	return 0;
+}
+
+static void tcf_ct_set_key_val(struct nlattr **tb,
+			       void *val, int val_type,
+			       void *mask, int mask_type,
+			       int len)
+{
+	if (!tb[val_type])
+		return;
+	nla_memcpy(val, tb[val_type], len);
+
+	if (!mask)
+		return;
+
+	if (mask_type == TCA_CT_UNSPEC || !tb[mask_type])
+		memset(mask, 0xff, len);
+	else
+		nla_memcpy(mask, tb[mask_type], len);
+}
+
+static int tcf_ct_fill_params(struct net *net,
+			      struct tcf_ct_params *p,
+			      struct tc_ct *parm,
+			      struct nlattr **tb,
+			      struct netlink_ext_ack *extack)
+{
+	struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
+	struct nf_conntrack_zone zone;
+	struct nf_conn *tmpl;
+	int err;
+
+	p->zone = NF_CT_DEFAULT_ZONE_ID;
+
+	tcf_ct_set_key_val(tb,
+			   &p->ct_action, TCA_CT_ACTION,
+			   NULL, TCA_CT_UNSPEC,
+			   sizeof(p->ct_action));
+
+	if (p->ct_action & TCA_CT_ACT_CLEAR)
+		return 0;
+
+	err = tcf_ct_fill_params_nat(p, parm, tb, extack);
+	if (err)
+		return err;
+
+	if (tb[TCA_CT_MARK]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)) {
+			NL_SET_ERR_MSG_MOD(extack, "Conntrack mark isn't enabled.");
+			return -EOPNOTSUPP;
+		}
+		tcf_ct_set_key_val(tb,
+				   &p->mark, TCA_CT_MARK,
+				   &p->mark_mask, TCA_CT_MARK_MASK,
+				   sizeof(p->mark));
+	}
+
+	if (tb[TCA_CT_LABELS]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS)) {
+			NL_SET_ERR_MSG_MOD(extack, "Conntrack labels isn't enabled.");
+			return -EOPNOTSUPP;
+		}
+
+		if (!tn->labels) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to set connlabel length");
+			return -EOPNOTSUPP;
+		}
+		tcf_ct_set_key_val(tb,
+				   p->labels, TCA_CT_LABELS,
+				   p->labels_mask, TCA_CT_LABELS_MASK,
+				   sizeof(p->labels));
+	}
+
+	if (tb[TCA_CT_ZONE]) {
+		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
+			NL_SET_ERR_MSG_MOD(extack, "Conntrack zones isn't enabled.");
+			return -EOPNOTSUPP;
+		}
+
+		tcf_ct_set_key_val(tb,
+				   &p->zone, TCA_CT_ZONE,
+				   NULL, TCA_CT_UNSPEC,
+				   sizeof(p->zone));
+	}
+
+	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
+		return 0;
+
+	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
+	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
+	if (!tmpl) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate conntrack template");
+		return -ENOMEM;
+	}
+	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
+	nf_conntrack_get(&tmpl->ct_general);
+	p->tmpl = tmpl;
+
+	return 0;
+}
+
+static int tcf_ct_init(struct net *net, struct nlattr *nla,
+		       struct nlattr *est, struct tc_action **a,
+		       int replace, int bind, bool rtnl_held,
+		       struct tcf_proto *tp,
+		       struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, ct_net_id);
+	struct tcf_ct_params *params = NULL;
+	struct nlattr *tb[TCA_CT_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	struct tc_ct *parm;
+	struct tcf_ct *c;
+	int err, res = 0;
+
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "Ct requires attributes to be passed");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, TCA_CT_MAX, nla, ct_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_CT_PARMS]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing required ct parameters");
+		return -EINVAL;
+	}
+	parm = nla_data(tb[TCA_CT_PARMS]);
+
+	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	if (err < 0)
+		return err;
+
+	if (!err) {
+		err = tcf_idr_create(tn, parm->index, est, a,
+				     &act_ct_ops, bind, true);
+		if (err) {
+			tcf_idr_cleanup(tn, parm->index);
+			return err;
+		}
+		res = ACT_P_CREATED;
+	} else {
+		if (bind)
+			return 0;
+
+		if (!replace) {
+			tcf_idr_release(*a, bind);
+			return -EEXIST;
+		}
+	}
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto cleanup;
+
+	c = to_ct(*a);
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (unlikely(!params)) {
+		err = -ENOMEM;
+		goto cleanup;
+	}
+
+	err = tcf_ct_fill_params(net, params, parm, tb, extack);
+	if (err)
+		goto cleanup;
+
+	spin_lock_bh(&c->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	rcu_swap_protected(c->params, params, lockdep_is_held(&c->tcf_lock));
+	spin_unlock_bh(&c->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+	if (params)
+		kfree_rcu(params, rcu);
+	if (res == ACT_P_CREATED)
+		tcf_idr_insert(tn, *a);
+
+	return res;
+
+cleanup:
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+	kfree(params);
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static void tcf_ct_cleanup(struct tc_action *a)
+{
+	struct tcf_ct_params *params;
+	struct tcf_ct *c = to_ct(a);
+
+	params = rcu_dereference_protected(c->params, 1);
+	if (params)
+		call_rcu(&params->rcu, tcf_ct_params_free);
+}
+
+static int tcf_ct_dump_key_val(struct sk_buff *skb,
+			       void *val, int val_type,
+			       void *mask, int mask_type,
+			       int len)
+{
+	int err;
+
+	if (mask && !memchr_inv(mask, 0, len))
+		return 0;
+
+	err = nla_put(skb, val_type, len, val);
+	if (err)
+		return err;
+
+	if (mask_type != TCA_CT_UNSPEC) {
+		err = nla_put(skb, mask_type, len, mask);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tcf_ct_dump_nat(struct sk_buff *skb, struct tcf_ct_params *p)
+{
+	struct nf_nat_range2 *range = &p->range;
+
+	if (!(p->ct_action & TCA_CT_ACT_NAT))
+		return 0;
+
+	if (!(p->ct_action & (TCA_CT_ACT_NAT_SRC | TCA_CT_ACT_NAT_DST)))
+		return 0;
+
+	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
+		if (p->ipv4_range) {
+			if (nla_put_in_addr(skb, TCA_CT_NAT_IPV4_MIN,
+					    range->min_addr.ip))
+				return -1;
+			if (nla_put_in_addr(skb, TCA_CT_NAT_IPV4_MAX,
+					    range->max_addr.ip))
+				return -1;
+		} else {
+			if (nla_put_in6_addr(skb, TCA_CT_NAT_IPV6_MIN,
+					     &range->min_addr.in6))
+				return -1;
+			if (nla_put_in6_addr(skb, TCA_CT_NAT_IPV6_MAX,
+					     &range->max_addr.in6))
+				return -1;
+		}
+	}
+
+	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		if (nla_put_u16(skb, TCA_CT_NAT_PORT_MIN,
+				ntohs(range->min_proto.all)))
+			return -1;
+		if (nla_put_u16(skb, TCA_CT_NAT_PORT_MAX,
+				ntohs(range->max_proto.all)))
+			return -1;
+	}
+
+	return 0;
+}
+
+static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
+			      int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_ct *c = to_ct(a);
+	struct tcf_ct_params *p;
+
+	struct tc_ct opt = {
+		.index   = c->tcf_index,
+		.refcnt  = refcount_read(&c->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&c->tcf_bindcnt) - bind,
+	};
+	struct tcf_t t;
+
+	spin_lock_bh(&c->tcf_lock);
+	p = rcu_dereference_protected(c->params,
+				      lockdep_is_held(&c->tcf_lock));
+	opt.action = c->tcf_action;
+
+	if (tcf_ct_dump_key_val(skb,
+				&p->ct_action, TCA_CT_ACTION,
+				NULL, TCA_CT_UNSPEC,
+				sizeof(p->ct_action)))
+		goto nla_put_failure;
+
+	if (p->ct_action & TCA_CT_ACT_CLEAR)
+		goto skip_dump;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_MARK) &&
+	    tcf_ct_dump_key_val(skb,
+				&p->mark, TCA_CT_MARK,
+				&p->mark_mask, TCA_CT_MARK_MASK,
+				sizeof(p->mark)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
+	    tcf_ct_dump_key_val(skb,
+				p->labels, TCA_CT_LABELS,
+				p->labels_mask, TCA_CT_LABELS_MASK,
+				sizeof(p->labels)))
+		goto nla_put_failure;
+
+	if (IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES) &&
+	    tcf_ct_dump_key_val(skb,
+				&p->zone, TCA_CT_ZONE,
+				NULL, TCA_CT_UNSPEC,
+				sizeof(p->zone)))
+		goto nla_put_failure;
+
+	if (tcf_ct_dump_nat(skb, p))
+		goto nla_put_failure;
+
+skip_dump:
+	if (nla_put(skb, TCA_CT_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	tcf_tm_dump(&t, &c->tcf_tm);
+	if (nla_put_64bit(skb, TCA_CT_TM, sizeof(t), &t, TCA_CT_PAD))
+		goto nla_put_failure;
+	spin_unlock_bh(&c->tcf_lock);
+
+	return skb->len;
+nla_put_failure:
+	spin_unlock_bh(&c->tcf_lock);
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int tcf_ct_walker(struct net *net, struct sk_buff *skb,
+			 struct netlink_callback *cb, int type,
+			 const struct tc_action_ops *ops,
+			 struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, ct_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static int tcf_ct_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, ct_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
+			     u64 lastuse, bool hw)
+{
+	struct tcf_ct *c = to_ct(a);
+
+	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+
+	if (hw)
+		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
+				   bytes, packets);
+	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
+}
+
+static struct tc_action_ops act_ct_ops = {
+	.kind		=	"ct",
+	.id		=	TCA_ID_CT,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_ct_act,
+	.dump		=	tcf_ct_dump,
+	.init		=	tcf_ct_init,
+	.cleanup	=	tcf_ct_cleanup,
+	.walk		=	tcf_ct_walker,
+	.lookup		=	tcf_ct_search,
+	.stats_update	=	tcf_stats_update,
+	.size		=	sizeof(struct tcf_ct),
+};
+
+static __net_init int ct_init_net(struct net *net)
+{
+	struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
+	unsigned int n_bits = FIELD_SIZEOF(struct tcf_ct_params, labels) * 8;
+
+	if (nf_connlabels_get(net, n_bits - 1)) {
+		tn->labels = false;
+		pr_err("act_ct: Failed to set connlabels length");
+	} else {
+		tn->labels = true;
+	}
+
+	return tc_action_net_init(&tn->tn, &act_ct_ops);
+}
+
+static void __net_exit ct_exit_net(struct list_head *net_list)
+{
+	struct net *net;
+
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list) {
+		struct tc_ct_action_net *tn = net_generic(net, ct_net_id);
+
+		if (tn->labels)
+			nf_connlabels_put(net);
+	}
+	rtnl_unlock();
+
+	tc_action_net_exit(net_list, ct_net_id);
+}
+
+static struct pernet_operations ct_net_ops = {
+	.init = ct_init_net,
+	.exit_batch = ct_exit_net,
+	.id   = &ct_net_id,
+	.size = sizeof(struct tc_ct_action_net),
+};
+
+static int __init ct_init_module(void)
+{
+	return tcf_register_action(&act_ct_ops, &ct_net_ops);
+}
+
+static void __exit ct_cleanup_module(void)
+{
+	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
+}
+
+module_init(ct_init_module);
+module_exit(ct_cleanup_module);
+MODULE_AUTHOR("Paul Blakey <paulb@mellanox.com>");
+MODULE_AUTHOR("Yossi Kuperman <yossiku@mellanox.com>");
+MODULE_AUTHOR("Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>");
+MODULE_DESCRIPTION("Connection tracking action");
+MODULE_LICENSE("GPL v2");
+
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ad36bbc..4a7331c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -35,6 +35,7 @@
 #include <net/tc_act/tc_police.h>
 #include <net/tc_act/tc_sample.h>
 #include <net/tc_act/tc_skbedit.h>
+#include <net/tc_act/tc_ct.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -3266,6 +3267,10 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.burst = tcf_police_tcfp_burst(act);
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
+		} else if (is_tcf_ct(act)) {
+			entry->id = FLOW_ACTION_CT;
+			entry->ct.action = tcf_ct_action(act);
+			entry->ct.zone = tcf_ct_zone(act);
 		} else {
 			goto err_out;
 		}
-- 
1.8.3.1

