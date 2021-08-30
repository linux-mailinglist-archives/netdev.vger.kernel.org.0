Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3F23FB349
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhH3JkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:40:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42602 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbhH3JkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:40:02 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id DF62A600B0;
        Mon, 30 Aug 2021 11:38:08 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 8/8] netfilter: add netfilter hooks to SRv6 data plane
Date:   Mon, 30 Aug 2021 11:38:52 +0200
Message-Id: <20210830093852.21654-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryoga Saito <contact@proelbtn.com>

This patch introduces netfilter hooks for solving the problem that
conntrack couldn't record both inner flows and outer flows.

This patch also introduces a new sysctl toggle for enabling lightweight
tunnel netfilter hooks.

Signed-off-by: Ryoga Saito <contact@proelbtn.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../networking/nf_conntrack-sysctl.rst        |   7 ++
 include/net/lwtunnel.h                        |   3 +
 include/net/netfilter/nf_hooks_lwtunnel.h     |   7 ++
 net/core/lwtunnel.c                           |   3 +
 net/ipv6/seg6_iptunnel.c                      |  75 +++++++++++-
 net/ipv6/seg6_local.c                         | 111 ++++++++++++------
 net/netfilter/Makefile                        |   3 +
 net/netfilter/nf_conntrack_standalone.c       |  15 +++
 net/netfilter/nf_hooks_lwtunnel.c             |  53 +++++++++
 9 files changed, 241 insertions(+), 36 deletions(-)
 create mode 100644 include/net/netfilter/nf_hooks_lwtunnel.h
 create mode 100644 net/netfilter/nf_hooks_lwtunnel.c

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 024d784157c8..34ca762ea56f 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -184,6 +184,13 @@ nf_conntrack_gre_timeout_stream - INTEGER (seconds)
 	This extended timeout will be used in case there is an GRE stream
 	detected.
 
+nf_hooks_lwtunnel - BOOLEAN
+	- 0 - disabled (default)
+	- not 0 - enabled
+
+	If this option is enabled, the lightweight tunnel netfilter hooks are
+	enabled. This option cannot be disabled once it is enabled.
+
 nf_flowtable_tcp_timeout - INTEGER (seconds)
         default 30
 
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 05cfd6ff6528..6f15e6fa154e 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -51,6 +51,9 @@ struct lwtunnel_encap_ops {
 };
 
 #ifdef CONFIG_LWTUNNEL
+
+DECLARE_STATIC_KEY_FALSE(nf_hooks_lwtunnel_enabled);
+
 void lwtstate_free(struct lwtunnel_state *lws);
 
 static inline struct lwtunnel_state *
diff --git a/include/net/netfilter/nf_hooks_lwtunnel.h b/include/net/netfilter/nf_hooks_lwtunnel.h
new file mode 100644
index 000000000000..52e27920f829
--- /dev/null
+++ b/include/net/netfilter/nf_hooks_lwtunnel.h
@@ -0,0 +1,7 @@
+#include <linux/sysctl.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_SYSCTL
+int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+				     void *buffer, size_t *lenp, loff_t *ppos);
+#endif
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index d0ae987d2de9..2820aca2173a 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -23,6 +23,9 @@
 #include <net/ip6_fib.h>
 #include <net/rtnh.h>
 
+DEFINE_STATIC_KEY_FALSE(nf_hooks_lwtunnel_enabled);
+EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_enabled);
+
 #ifdef CONFIG_MODULES
 
 static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 897fa59c47de..6ebc7aa24466 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -26,6 +26,8 @@
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
+#include <net/lwtunnel.h>
+#include <linux/netfilter.h>
 
 static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 {
@@ -295,11 +297,19 @@ static int seg6_do_srh(struct sk_buff *skb)
 
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+	nf_reset_ct(skb);
 
 	return 0;
 }
 
-static int seg6_input(struct sk_buff *skb)
+static int seg6_input_finish(struct net *net, struct sock *sk,
+			     struct sk_buff *skb)
+{
+	return dst_input(skb);
+}
+
+static int seg6_input_core(struct net *net, struct sock *sk,
+			   struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
@@ -337,10 +347,41 @@ static int seg6_input(struct sk_buff *skb)
 	if (unlikely(err))
 		return err;
 
-	return dst_input(skb);
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
+			       dev_net(skb->dev), NULL, skb, NULL,
+			       skb_dst(skb)->dev, seg6_input_finish);
+
+	return seg6_input_finish(dev_net(skb->dev), NULL, skb);
 }
 
-static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+static int seg6_input_nf(struct sk_buff *skb)
+{
+	struct net_device *dev = skb_dst(skb)->dev;
+	struct net *net = dev_net(skb->dev);
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, NULL,
+			       skb, NULL, dev, seg6_input_core);
+	case htons(ETH_P_IPV6):
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, NULL,
+			       skb, NULL, dev, seg6_input_core);
+	}
+
+	return -EINVAL;
+}
+
+static int seg6_input(struct sk_buff *skb)
+{
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return seg6_input_nf(skb);
+
+	return seg6_input_core(dev_net(skb->dev), NULL, skb);
+}
+
+static int seg6_output_core(struct net *net, struct sock *sk,
+			    struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
@@ -387,12 +428,40 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (unlikely(err))
 		goto drop;
 
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk, skb,
+			       NULL, skb_dst(skb)->dev, dst_output);
+
 	return dst_output(net, sk, skb);
 drop:
 	kfree_skb(skb);
 	return err;
 }
 
+static int seg6_output_nf(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct net_device *dev = skb_dst(skb)->dev;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, sk, skb,
+			       NULL, dev, seg6_output_core);
+	case htons(ETH_P_IPV6):
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
+			       NULL, dev, seg6_output_core);
+	}
+
+	return -EINVAL;
+}
+
+static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return seg6_output_nf(net, sk, skb);
+
+	return seg6_output_core(net, sk, skb);
+}
+
 static int seg6_build_state(struct net *net, struct nlattr *nla,
 			    unsigned int family, const void *cfg,
 			    struct lwtunnel_state **ts,
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 60bf3b877957..ddc8dfcd4e2b 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -30,6 +30,8 @@
 #include <net/seg6_local.h>
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
+#include <net/lwtunnel.h>
+#include <linux/netfilter.h>
 
 #define SEG6_F_ATTR(i)		BIT(i)
 
@@ -413,12 +415,33 @@ static int input_action_end_dx2(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+static int input_action_end_dx6_finish(struct net *net, struct sock *sk,
+				       struct sk_buff *skb)
+{
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct in6_addr *nhaddr = NULL;
+	struct seg6_local_lwt *slwt;
+
+	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
+
+	/* The inner packet is not associated to any local interface,
+	 * so we do not call netif_rx().
+	 *
+	 * If slwt->nh6 is set to ::, then lookup the nexthop for the
+	 * inner packet's DA. Otherwise, use the specified nexthop.
+	 */
+	if (!ipv6_addr_any(&slwt->nh6))
+		nhaddr = &slwt->nh6;
+
+	seg6_lookup_nexthop(skb, nhaddr, 0);
+
+	return dst_input(skb);
+}
+
 /* decapsulate and forward to specified nexthop */
 static int input_action_end_dx6(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
 {
-	struct in6_addr *nhaddr = NULL;
-
 	/* this function accepts IPv6 encapsulated packets, with either
 	 * an SRH with SL=0, or no SRH.
 	 */
@@ -429,40 +452,30 @@ static int input_action_end_dx6(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto drop;
 
-	/* The inner packet is not associated to any local interface,
-	 * so we do not call netif_rx().
-	 *
-	 * If slwt->nh6 is set to ::, then lookup the nexthop for the
-	 * inner packet's DA. Otherwise, use the specified nexthop.
-	 */
-
-	if (!ipv6_addr_any(&slwt->nh6))
-		nhaddr = &slwt->nh6;
-
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+	nf_reset_ct(skb);
 
-	seg6_lookup_nexthop(skb, nhaddr, 0);
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
+			       dev_net(skb->dev), NULL, skb, NULL,
+			       skb_dst(skb)->dev, input_action_end_dx6_finish);
 
-	return dst_input(skb);
+	return input_action_end_dx6_finish(dev_net(skb->dev), NULL, skb);
 drop:
 	kfree_skb(skb);
 	return -EINVAL;
 }
 
-static int input_action_end_dx4(struct sk_buff *skb,
-				struct seg6_local_lwt *slwt)
+static int input_action_end_dx4_finish(struct net *net, struct sock *sk,
+				       struct sk_buff *skb)
 {
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct seg6_local_lwt *slwt;
 	struct iphdr *iph;
 	__be32 nhaddr;
 	int err;
 
-	if (!decap_and_validate(skb, IPPROTO_IPIP))
-		goto drop;
-
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-		goto drop;
-
-	skb->protocol = htons(ETH_P_IP);
+	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 
 	iph = ip_hdr(skb);
 
@@ -470,14 +483,34 @@ static int input_action_end_dx4(struct sk_buff *skb,
 
 	skb_dst_drop(skb);
 
-	skb_set_transport_header(skb, sizeof(struct iphdr));
-
 	err = ip_route_input(skb, nhaddr, iph->saddr, 0, skb->dev);
-	if (err)
-		goto drop;
+	if (err) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	return dst_input(skb);
+}
+
+static int input_action_end_dx4(struct sk_buff *skb,
+				struct seg6_local_lwt *slwt)
+{
+	if (!decap_and_validate(skb, IPPROTO_IPIP))
+		goto drop;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto drop;
+
+	skb->protocol = htons(ETH_P_IP);
+	skb_set_transport_header(skb, sizeof(struct iphdr));
+	nf_reset_ct(skb);
+
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
+			       dev_net(skb->dev), NULL, skb, NULL,
+			       skb_dst(skb)->dev, input_action_end_dx4_finish);
 
+	return input_action_end_dx4_finish(dev_net(skb->dev), NULL, skb);
 drop:
 	kfree_skb(skb);
 	return -EINVAL;
@@ -645,6 +678,7 @@ static struct sk_buff *end_dt_vrf_core(struct sk_buff *skb,
 	skb_dst_drop(skb);
 
 	skb_set_transport_header(skb, hdrlen);
+	nf_reset_ct(skb);
 
 	return end_dt_vrf_rcv(skb, family, vrf);
 
@@ -1078,7 +1112,8 @@ static void seg6_local_update_counters(struct seg6_local_lwt *slwt,
 	u64_stats_update_end(&pcounters->syncp);
 }
 
-static int seg6_local_input(struct sk_buff *skb)
+static int seg6_local_input_core(struct net *net, struct sock *sk,
+				 struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct seg6_action_desc *desc;
@@ -1086,11 +1121,6 @@ static int seg6_local_input(struct sk_buff *skb)
 	unsigned int len = skb->len;
 	int rc;
 
-	if (skb->protocol != htons(ETH_P_IPV6)) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
 	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 	desc = slwt->desc;
 
@@ -1104,6 +1134,21 @@ static int seg6_local_input(struct sk_buff *skb)
 	return rc;
 }
 
+static int seg6_local_input(struct sk_buff *skb)
+{
+	if (skb->protocol != htons(ETH_P_IPV6)) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN,
+			       dev_net(skb->dev), NULL, skb, skb->dev, NULL,
+			       seg6_local_input_core);
+
+	return seg6_local_input_core(dev_net(skb->dev), NULL, skb);
+}
+
 static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_ACTION]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_SRH]	= { .type = NLA_BINARY },
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 049890e00a3d..aab20e575ecd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -212,3 +212,6 @@ obj-$(CONFIG_IP_SET) += ipset/
 
 # IPVS
 obj-$(CONFIG_IP_VS) += ipvs/
+
+# lwtunnel
+obj-$(CONFIG_LWTUNNEL) += nf_hooks_lwtunnel.o
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e84b499b7bfa..7e0d956da51d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -22,6 +22,9 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
+#ifdef CONFIG_LWTUNNEL
+#include <net/netfilter/nf_hooks_lwtunnel.h>
+#endif
 #include <linux/rculist_nulls.h>
 
 static bool enable_hooks __read_mostly;
@@ -612,6 +615,9 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
 #endif
+#ifdef CONFIG_LWTUNNEL
+	NF_SYSCTL_CT_LWTUNNEL,
+#endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -958,6 +964,15 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
+#endif
+#ifdef CONFIG_LWTUNNEL
+	[NF_SYSCTL_CT_LWTUNNEL] = {
+		.procname	= "nf_hooks_lwtunnel",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
+	},
 #endif
 	{}
 };
diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
new file mode 100644
index 000000000000..00e89ffd78f6
--- /dev/null
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/sysctl.h>
+#include <net/lwtunnel.h>
+#include <net/netfilter/nf_hooks_lwtunnel.h>
+
+static inline int nf_hooks_lwtunnel_get(void)
+{
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return 1;
+	else
+		return 0;
+}
+
+static inline int nf_hooks_lwtunnel_set(int enable)
+{
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled)) {
+		if (!enable)
+			return -EBUSY;
+	} else if (enable) {
+		static_branch_enable(&nf_hooks_lwtunnel_enabled);
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_SYSCTL
+int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+				     void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int proc_nf_hooks_lwtunnel_enabled = 0;
+	struct ctl_table tmp = {
+		.procname = table->procname,
+		.data = &proc_nf_hooks_lwtunnel_enabled,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+	int ret;
+
+	if (!write)
+		proc_nf_hooks_lwtunnel_enabled = nf_hooks_lwtunnel_get();
+
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+
+	if (write && ret == 0)
+		ret = nf_hooks_lwtunnel_set(proc_nf_hooks_lwtunnel_enabled);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
+#endif /* CONFIG_SYSCTL */
-- 
2.20.1

