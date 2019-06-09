Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC83A6C9
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 18:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfFIQXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 12:23:25 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43135 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbfFIQXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 12:23:24 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so10486005edb.10
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 09:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NGKv5rxxh/VTWbc1sbUKUvhDIXTRtBsO10Bx3R+XN9A=;
        b=H9b7Hx1IAbciGC5VrKTJlU2EREA6bNq4uVbRyu+ntUlL6eX97kONZjjEPa7u/s75L6
         OblmLdj+ypHAYYezsSPaC1aCSz7W5pfo4bnQzdIJVgE/KXEfNNG/QEfUxqVdsJHUS14u
         2f7AY3y4qPVK/9gr1KUZz2ngLdCvljXySVGEtC+BMY/1aa/sy3/6F14Nszdd0w3xZJED
         5cRK2COm08ZizS/NnDdhhEwx0umwHAguefBuVbyXfvcsBOhZJwENvd+GO3wZXdEZ45Ks
         jtq2O3aC+VOHUNooMxN1QTXOCzzJbRTzRHYWazDnDdEbR0+m8U8SONtvFUW/r/dIsLnB
         yG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NGKv5rxxh/VTWbc1sbUKUvhDIXTRtBsO10Bx3R+XN9A=;
        b=II2jKhu5qroYZfMiRlOdLYqzRvbYLyeVS4xsRG2UTKBo9AvQW1Mu1J0WDWc0wjJvYn
         Wrn2SGz46ez/q8WYGn6gFJRTN0YhUrBCVJqgBkohYU9Mfdoh5+m3FbZzdAyql7hrs9s6
         Oqt7Y4SfgvpWWlWeVZNdRIome3REaJqeIGTHZo84eaZRVJqzj+LYkx5fVUwI012FXlAx
         M+ejQrzsUxxaZ4u/8xskL8pyc7E+VrJd8nBDiyQKLCJUrIeUXY2p5eWbXMgSGWuM8xs9
         q9y+7yU/40X3BvHWMP82dvi428vIl1SrrK03mT4UzDFqgLHiyzlt8uqLRz/c4+TcZUCM
         mtRw==
X-Gm-Message-State: APjAAAXCTZizrFnv2oIEKvCy+7WfV7mfB5mj+cf5c0iFMLom1CbUQm6d
        e6yRhlClHh5e6Xf37fIWlCUNyA==
X-Google-Smtp-Source: APXvYqzw2imWTX1a+WiGdb5jSrSlVLseE4auECK/xb4EGwk15eJWZ2MiQiY4/2ywP9sCG4XOuqNMjA==
X-Received: by 2002:a05:6402:184c:: with SMTP id v12mr1413755edy.292.1560097401221;
        Sun, 09 Jun 2019 09:23:21 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bd67a.dynamic.kabel-deutschland.de. [95.91.214.122])
        by smtp.gmail.com with ESMTPSA id r12sm1069489eda.39.2019.06.09.09.23.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 09:23:20 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Cc:     tyhicks@canonical.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH net-next v1 1/1] br_netfilter: namespace bridge netfilter sysctls
Date:   Sun,  9 Jun 2019 18:23:04 +0200
Message-Id: <20190609162304.3388-2-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609162304.3388-1-christian@brauner.io>
References: <20190609162304.3388-1-christian@brauner.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the /proc/sys/net/bridge folder is only created in the initial
network namespace. This patch ensures that the /proc/sys/net/bridge folder
is available in each network namespace if the module is loaded and
disappears from all network namespaces when the module is unloaded.

In doing so the patch makes the sysctls:

bridge-nf-call-arptables
bridge-nf-call-ip6tables
bridge-nf-call-iptables
bridge-nf-filter-pppoe-tagged
bridge-nf-filter-vlan-tagged
bridge-nf-pass-vlan-input-dev

apply per network namespace. This unblocks some use-cases where users would
like to e.g. not do bridge filtering for bridges in a specific network
namespace while doing so for bridges located in another network namespace.

The netfilter rules are afaict already per network namespace so it should
be safe for users to specify whether bridge devices inside a network
namespace are supposed to go through iptables et al. or not. Also, this can
already be done per-bridge by setting an option for each individual bridge
via Netlink. It should also be possible to do this for all bridges in a
network namespace via sysctls.

Cc: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
v1:
- Pablo Neira Ayuso <pablo@netfilter.org>:
  - port sysctl namespacing to use the brnf_net_ops infrastructure to avoid
    having to mess with struct net directly
---
 include/net/netfilter/br_netfilter.h |   3 +-
 net/bridge/br_netfilter_hooks.c      | 291 ++++++++++++++++++---------
 net/bridge/br_netfilter_ipv6.c       |   2 +-
 3 files changed, 204 insertions(+), 92 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 89808ce293c4..302fcd3aade2 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -42,7 +42,8 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 	return port ? &port->br->fake_rtable : NULL;
 }
 
-struct net_device *setup_pre_routing(struct sk_buff *skb);
+struct net_device *setup_pre_routing(struct sk_buff *skb,
+				     const struct net *net);
 
 #if IS_ENABLED(CONFIG_IPV6)
 int br_validate_ipv6(struct net *net, struct sk_buff *skb);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 34fa72c72ad8..2b58dd645fa4 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -47,24 +47,21 @@ static unsigned int brnf_net_id __read_mostly;
 
 struct brnf_net {
 	bool enabled;
-};
 
 #ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_call_iptables __read_mostly = 1;
-static int brnf_call_ip6tables __read_mostly = 1;
-static int brnf_call_arptables __read_mostly = 1;
-static int brnf_filter_vlan_tagged __read_mostly;
-static int brnf_filter_pppoe_tagged __read_mostly;
-static int brnf_pass_vlan_indev __read_mostly;
-#else
-#define brnf_call_iptables 1
-#define brnf_call_ip6tables 1
-#define brnf_call_arptables 1
-#define brnf_filter_vlan_tagged 0
-#define brnf_filter_pppoe_tagged 0
-#define brnf_pass_vlan_indev 0
+	struct ctl_table_header *ctl_hdr;
+
+	/* default value is 1 */
+	int call_iptables;
+	int call_ip6tables;
+	int call_arptables;
+
+	/* default value is 0 */
+	int filter_vlan_tagged;
+	int filter_pppoe_tagged;
+	int pass_vlan_indev;
 #endif
+};
 
 #define IS_IP(skb) \
 	(!skb_vlan_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
@@ -85,17 +82,42 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 		return 0;
 }
 
-#define IS_VLAN_IP(skb) \
-	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+static inline bool is_vlan_ip(const struct sk_buff *skb, const struct net *net)
+{
+#ifdef CONFIG_SYSCTL
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
 
-#define IS_VLAN_IPV6(skb) \
-	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	return (vlan_proto(skb) == htons(ETH_P_IP) &&
+		brnet->filter_vlan_tagged);
+#else
+	return (vlan_proto(skb) == htons(ETH_P_IP));
+#endif
+}
 
-#define IS_VLAN_ARP(skb) \
-	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+static inline bool is_vlan_ipv6(const struct sk_buff *skb,
+				const struct net *net)
+{
+#ifdef CONFIG_SYSCTL
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	return (vlan_proto(skb) == htons(ETH_P_IPV6) &&
+		brnet->filter_vlan_tagged);
+#else
+	return (vlan_proto(skb) == htons(ETH_P_IPV6));
+#endif
+}
+
+static inline bool is_vlan_arp(const struct sk_buff *skb, const struct net *net)
+{
+#ifdef CONFIG_SYSCTL
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	return (vlan_proto(skb) == htons(ETH_P_ARP) &&
+		brnet->filter_vlan_tagged);
+#else
+	return (vlan_proto(skb) == htons(ETH_P_ARP));
+#endif
+}
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -103,15 +125,35 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 			    sizeof(struct pppoe_hdr)));
 }
 
-#define IS_PPPOE_IP(skb) \
-	(skb->protocol == htons(ETH_P_PPP_SES) && \
-	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+static inline bool is_pppoe_ip(const struct sk_buff *skb, const struct net *net)
+{
+#ifdef CONFIG_SYSCTL
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
 
-#define IS_PPPOE_IPV6(skb) \
-	(skb->protocol == htons(ETH_P_PPP_SES) && \
-	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	return (skb->protocol == htons(ETH_P_PPP_SES) &&
+		pppoe_proto(skb) == htons(PPP_IP) &&
+		brnet->filter_pppoe_tagged);
+
+#else
+	return (skb->protocol == htons(ETH_P_PPP_SES) &&
+		pppoe_proto(skb) == htons(PPP_IP));
+#endif
+}
+
+static inline bool is_pppoe_ipv6(const struct sk_buff *skb,
+				 const struct net *net)
+{
+#ifdef CONFIG_SYSCTL
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	return (skb->protocol == htons(ETH_P_PPP_SES) &&
+		pppoe_proto(skb) == htons(PPP_IPV6) &&
+		brnet->filter_pppoe_tagged);
+#else
+	return (skb->protocol == htons(ETH_P_PPP_SES) &&
+		pppoe_proto(skb) == htons(PPP_IPV6));
+#endif
+}
 
 /* largest possible L2 header, see br_nf_dev_queue_xmit() */
 #define NF_BRIDGE_MAX_MAC_HEADER_LENGTH (PPPOE_SES_HLEN + ETH_HLEN)
@@ -408,12 +450,20 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 	return 0;
 }
 
-static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct net_device *dev)
+static struct net_device *brnf_get_logical_dev(struct sk_buff *skb,
+					       const struct net_device *dev,
+					       const struct net *net)
 {
 	struct net_device *vlan, *br;
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
 
 	br = bridge_parent(dev);
-	if (brnf_pass_vlan_indev == 0 || !skb_vlan_tag_present(skb))
+
+#ifdef CONFIG_SYSCTL
+	if (brnet->pass_vlan_indev == 0)
+		return br;
+#endif
+	if (!skb_vlan_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep_rcu(br, skb->vlan_proto,
@@ -423,7 +473,7 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 }
 
 /* Some common code for IPv4/IPv6 */
-struct net_device *setup_pre_routing(struct sk_buff *skb)
+struct net_device *setup_pre_routing(struct sk_buff *skb, const struct net *net)
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
@@ -434,7 +484,7 @@ struct net_device *setup_pre_routing(struct sk_buff *skb)
 
 	nf_bridge->in_prerouting = 1;
 	nf_bridge->physindev = skb->dev;
-	skb->dev = brnf_get_logical_dev(skb, skb->dev);
+	skb->dev = brnf_get_logical_dev(skb, skb->dev, net);
 
 	if (skb->protocol == htons(ETH_P_8021Q))
 		nf_bridge->orig_proto = BRNF_PROTO_8021Q;
@@ -460,6 +510,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	__u32 len = nf_bridge_encap_header_len(skb);
+	struct brnf_net *brnet;
 
 	if (unlikely(!pskb_may_pull(skb, len)))
 		return NF_DROP;
@@ -469,19 +520,27 @@ static unsigned int br_nf_pre_routing(void *priv,
 		return NF_DROP;
 	br = p->br;
 
-	if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
-		if (!brnf_call_ip6tables &&
-		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
-			return NF_ACCEPT;
+	brnet = net_generic(state->net, brnf_net_id);
+	if (IS_IPV6(skb) || is_vlan_ipv6(skb, state->net) ||
+	    is_pppoe_ipv6(skb, state->net)) {
+#ifdef CONFIG_SYSCTL
+		if (!brnet->call_ip6tables)
+#endif
+			if (!br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
+				return NF_ACCEPT;
 
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(priv, skb, state);
 	}
 
-	if (!brnf_call_iptables && !br_opt_get(br, BROPT_NF_CALL_IPTABLES))
-		return NF_ACCEPT;
+#ifdef CONFIG_SYSCTL
+	if (!brnet->call_iptables)
+#endif
+		if (!br_opt_get(br, BROPT_NF_CALL_IPTABLES))
+			return NF_ACCEPT;
 
-	if (!IS_IP(skb) && !IS_VLAN_IP(skb) && !IS_PPPOE_IP(skb))
+	if (!IS_IP(skb) && !is_vlan_ip(skb, state->net) &&
+	    !is_pppoe_ip(skb, state->net))
 		return NF_ACCEPT;
 
 	nf_bridge_pull_encap_header_rcsum(skb);
@@ -491,7 +550,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 
 	if (!nf_bridge_alloc(skb))
 		return NF_DROP;
-	if (!setup_pre_routing(skb))
+	if (!setup_pre_routing(skb, state->net))
 		return NF_DROP;
 
 	nf_bridge = nf_bridge_info_get(skb);
@@ -514,7 +573,7 @@ static int br_nf_forward_finish(struct net *net, struct sock *sk, struct sk_buff
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct net_device *in;
 
-	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
+	if (!IS_ARP(skb) && !is_vlan_arp(skb, net)) {
 
 		if (skb->protocol == htons(ETH_P_IP))
 			nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
@@ -569,9 +628,11 @@ static unsigned int br_nf_forward_ip(void *priv,
 	if (!parent)
 		return NF_DROP;
 
-	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
+	if (IS_IP(skb) || is_vlan_ip(skb, state->net) ||
+	    is_pppoe_ip(skb, state->net))
 		pf = NFPROTO_IPV4;
-	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
+	else if (IS_IPV6(skb) || is_vlan_ipv6(skb, state->net) ||
+		 is_pppoe_ipv6(skb, state->net))
 		pf = NFPROTO_IPV6;
 	else
 		return NF_ACCEPT;
@@ -602,7 +663,7 @@ static unsigned int br_nf_forward_ip(void *priv,
 		skb->protocol = htons(ETH_P_IPV6);
 
 	NF_HOOK(pf, NF_INET_FORWARD, state->net, NULL, skb,
-		brnf_get_logical_dev(skb, state->in),
+		brnf_get_logical_dev(skb, state->in, state->net),
 		parent,	br_nf_forward_finish);
 
 	return NF_STOLEN;
@@ -615,23 +676,28 @@ static unsigned int br_nf_forward_arp(void *priv,
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	struct net_device **d = (struct net_device **)(skb->cb);
+	struct brnf_net *brnet;
 
 	p = br_port_get_rcu(state->out);
 	if (p == NULL)
 		return NF_ACCEPT;
 	br = p->br;
 
-	if (!brnf_call_arptables && !br_opt_get(br, BROPT_NF_CALL_ARPTABLES))
-		return NF_ACCEPT;
+	brnet = net_generic(state->net, brnf_net_id);
+#ifdef CONFIG_SYSCTL
+	if (!brnet->call_arptables)
+#endif
+		if (!br_opt_get(br, BROPT_NF_CALL_ARPTABLES))
+			return NF_ACCEPT;
 
 	if (!IS_ARP(skb)) {
-		if (!IS_VLAN_ARP(skb))
+		if (!is_vlan_arp(skb, state->net))
 			return NF_ACCEPT;
 		nf_bridge_pull_encap_header(skb);
 	}
 
 	if (arp_hdr(skb)->ar_pln != 4) {
-		if (IS_VLAN_ARP(skb))
+		if (is_vlan_arp(skb, state->net))
 			nf_bridge_push_encap_header(skb);
 		return NF_ACCEPT;
 	}
@@ -791,9 +857,11 @@ static unsigned int br_nf_post_routing(void *priv,
 	if (!realoutdev)
 		return NF_DROP;
 
-	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
+	if (IS_IP(skb) || is_vlan_ip(skb, state->net) ||
+	    is_pppoe_ip(skb, state->net))
 		pf = NFPROTO_IPV4;
-	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
+	else if (IS_IPV6(skb) || is_vlan_ipv6(skb, state->net) ||
+		 is_pppoe_ipv6(skb, state->net))
 		pf = NFPROTO_IPV6;
 	else
 		return NF_ACCEPT;
@@ -946,23 +1014,6 @@ static int brnf_device_event(struct notifier_block *unused, unsigned long event,
 	return NOTIFY_OK;
 }
 
-static void __net_exit brnf_exit_net(struct net *net)
-{
-	struct brnf_net *brnet = net_generic(net, brnf_net_id);
-
-	if (!brnet->enabled)
-		return;
-
-	nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
-	brnet->enabled = false;
-}
-
-static struct pernet_operations brnf_net_ops __read_mostly = {
-	.exit = brnf_exit_net,
-	.id   = &brnf_net_id,
-	.size = sizeof(struct brnf_net),
-};
-
 static struct notifier_block brnf_notifier __read_mostly = {
 	.notifier_call = brnf_device_event,
 };
@@ -1021,49 +1072,122 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 static struct ctl_table brnf_table[] = {
 	{
 		.procname	= "bridge-nf-call-arptables",
-		.data		= &brnf_call_arptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-call-iptables",
-		.data		= &brnf_call_iptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-call-ip6tables",
-		.data		= &brnf_call_ip6tables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
-		.data		= &brnf_filter_vlan_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-pppoe-tagged",
-		.data		= &brnf_filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-pass-vlan-input-dev",
-		.data		= &brnf_pass_vlan_indev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{ }
 };
+
+static inline void br_netfilter_sysctl_default(struct brnf_net *brnf)
+{
+	brnf->call_iptables = 1;
+	brnf->call_ip6tables = 1;
+	brnf->call_arptables = 1;
+	brnf->filter_vlan_tagged = 0;
+	brnf->filter_pppoe_tagged = 0;
+	brnf->pass_vlan_indev = 0;
+}
+
+static int br_netfilter_sysctl_init_net(struct net *net)
+{
+	struct ctl_table *table = brnf_table;
+	struct brnf_net *brnet;
+
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(table, sizeof(brnf_table), GFP_KERNEL);
+		if (!table)
+			return -ENOMEM;
+	}
+
+	brnet = net_generic(net, brnf_net_id);
+	table[0].data = &brnet->call_arptables;
+	table[1].data = &brnet->call_iptables;
+	table[2].data = &brnet->call_ip6tables;
+	table[3].data = &brnet->filter_vlan_tagged;
+	table[4].data = &brnet->filter_pppoe_tagged;
+	table[5].data = &brnet->pass_vlan_indev;
+
+	br_netfilter_sysctl_default(brnet);
+
+	brnet->ctl_hdr = register_net_sysctl(net, "net/bridge", table);
+	if (!brnet->ctl_hdr) {
+		if (!net_eq(net, &init_net))
+			kfree(table);
+
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void br_netfilter_sysctl_exit_net(struct net *net,
+					 struct brnf_net *brnet)
+{
+	unregister_net_sysctl_table(brnet->ctl_hdr);
+	if (!net_eq(net, &init_net))
+		kfree(brnet->ctl_hdr->ctl_table_arg);
+}
+
+static int __net_init brnf_init_net(struct net *net)
+{
+	return br_netfilter_sysctl_init_net(net);
+}
+#endif
+
+static void __net_exit brnf_exit_net(struct net *net)
+{
+	struct brnf_net *brnet;
+
+	brnet = net_generic(net, brnf_net_id);
+	if (brnet->enabled) {
+		nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
+		brnet->enabled = false;
+	}
+
+#ifdef CONFIG_SYSCTL
+	br_netfilter_sysctl_exit_net(net, brnet);
+#endif
+}
+
+static struct pernet_operations brnf_net_ops __read_mostly = {
+#ifdef CONFIG_SYSCTL
+	.init = brnf_init_net,
 #endif
+	.exit = brnf_exit_net,
+	.id   = &brnf_net_id,
+	.size = sizeof(struct brnf_net),
+};
 
 static int __init br_netfilter_init(void)
 {
@@ -1079,16 +1203,6 @@ static int __init br_netfilter_init(void)
 		return ret;
 	}
 
-#ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
-		printk(KERN_WARNING
-		       "br_netfilter: can't register to sysctl.\n");
-		unregister_netdevice_notifier(&brnf_notifier);
-		unregister_pernet_subsys(&brnf_net_ops);
-		return -ENOMEM;
-	}
-#endif
 	RCU_INIT_POINTER(nf_br_ops, &br_ops);
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
@@ -1099,9 +1213,6 @@ static void __exit br_netfilter_fini(void)
 	RCU_INIT_POINTER(nf_br_ops, NULL);
 	unregister_netdevice_notifier(&brnf_notifier);
 	unregister_pernet_subsys(&brnf_net_ops);
-#ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
-#endif
 }
 
 module_init(br_netfilter_init);
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 0e63e5dc5ac4..e4e0c836c3f5 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -224,7 +224,7 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
 	nf_bridge = nf_bridge_alloc(skb);
 	if (!nf_bridge)
 		return NF_DROP;
-	if (!setup_pre_routing(skb))
+	if (!setup_pre_routing(skb, state->net))
 		return NF_DROP;
 
 	nf_bridge = nf_bridge_info_get(skb);
-- 
2.21.0

