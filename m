Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C77751FBC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfFYAOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:34 -0400
Received: from mail.us.es ([193.147.175.20]:38008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbfFYAMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BD24C04B1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67D6CDA704
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5D839DA705; Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A276DA704;
        Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E50F24265A2F;
        Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/26] netfilter: bridge: port sysctls to use brnf_net
Date:   Tue, 25 Jun 2019 02:12:19 +0200
Message-Id: <20190625001233.22057-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

This ports the sysctls to use struct brnf_net.

With this patch we make it possible to namespace the br_netfilter module in
the following patch.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/br_netfilter.h |   3 +-
 net/bridge/br_netfilter_hooks.c      | 162 ++++++++++++++++++++++-------------
 net/bridge/br_netfilter_ipv6.c       |   2 +-
 3 files changed, 107 insertions(+), 60 deletions(-)

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
index 22afa566cbce..3c67754d8075 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -49,27 +49,24 @@
 
 static unsigned int brnf_net_id __read_mostly;
 
-struct brnf_net {
-	bool enabled;
-};
-
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
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
 #endif
 
+struct brnf_net {
+	bool enabled;
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
+};
+
 #define IS_IP(skb) \
 	(!skb_vlan_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
 
@@ -89,17 +86,28 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 		return 0;
 }
 
-#define IS_VLAN_IP(skb) \
-	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+static inline bool is_vlan_ip(const struct sk_buff *skb, const struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	return vlan_proto(skb) == htons(ETH_P_IP) && brnet->filter_vlan_tagged;
+}
+
+static inline bool is_vlan_ipv6(const struct sk_buff *skb,
+				const struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
 
-#define IS_VLAN_IPV6(skb) \
-	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	return vlan_proto(skb) == htons(ETH_P_IPV6) &&
+	       brnet->filter_vlan_tagged;
+}
 
-#define IS_VLAN_ARP(skb) \
-	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+static inline bool is_vlan_arp(const struct sk_buff *skb, const struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	return vlan_proto(skb) == htons(ETH_P_ARP) && brnet->filter_vlan_tagged;
+}
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -107,15 +115,23 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 			    sizeof(struct pppoe_hdr)));
 }
 
-#define IS_PPPOE_IP(skb) \
-	(skb->protocol == htons(ETH_P_PPP_SES) && \
-	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+static inline bool is_pppoe_ip(const struct sk_buff *skb, const struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	return skb->protocol == htons(ETH_P_PPP_SES) &&
+	       pppoe_proto(skb) == htons(PPP_IP) && brnet->filter_pppoe_tagged;
+}
+
+static inline bool is_pppoe_ipv6(const struct sk_buff *skb,
+				 const struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
 
-#define IS_PPPOE_IPV6(skb) \
-	(skb->protocol == htons(ETH_P_PPP_SES) && \
-	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	return skb->protocol == htons(ETH_P_PPP_SES) &&
+	       pppoe_proto(skb) == htons(PPP_IPV6) &&
+	       brnet->filter_pppoe_tagged;
+}
 
 /* largest possible L2 header, see br_nf_dev_queue_xmit() */
 #define NF_BRIDGE_MAX_MAC_HEADER_LENGTH (PPPOE_SES_HLEN + ETH_HLEN)
@@ -412,12 +428,16 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
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
+	if (brnet->pass_vlan_indev == 0 || !skb_vlan_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep_rcu(br, skb->vlan_proto,
@@ -427,7 +447,7 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 }
 
 /* Some common code for IPv4/IPv6 */
-struct net_device *setup_pre_routing(struct sk_buff *skb)
+struct net_device *setup_pre_routing(struct sk_buff *skb, const struct net *net)
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
@@ -438,7 +458,7 @@ struct net_device *setup_pre_routing(struct sk_buff *skb)
 
 	nf_bridge->in_prerouting = 1;
 	nf_bridge->physindev = skb->dev;
-	skb->dev = brnf_get_logical_dev(skb, skb->dev);
+	skb->dev = brnf_get_logical_dev(skb, skb->dev, net);
 
 	if (skb->protocol == htons(ETH_P_8021Q))
 		nf_bridge->orig_proto = BRNF_PROTO_8021Q;
@@ -464,6 +484,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	__u32 len = nf_bridge_encap_header_len(skb);
+	struct brnf_net *brnet;
 
 	if (unlikely(!pskb_may_pull(skb, len)))
 		return NF_DROP;
@@ -473,8 +494,10 @@ static unsigned int br_nf_pre_routing(void *priv,
 		return NF_DROP;
 	br = p->br;
 
-	if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
-		if (!brnf_call_ip6tables &&
+	brnet = net_generic(state->net, brnf_net_id);
+	if (IS_IPV6(skb) || is_vlan_ipv6(skb, state->net) ||
+	    is_pppoe_ipv6(skb, state->net)) {
+		if (!brnet->call_ip6tables &&
 		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
 			return NF_ACCEPT;
 
@@ -482,10 +505,11 @@ static unsigned int br_nf_pre_routing(void *priv,
 		return br_nf_pre_routing_ipv6(priv, skb, state);
 	}
 
-	if (!brnf_call_iptables && !br_opt_get(br, BROPT_NF_CALL_IPTABLES))
+	if (!brnet->call_iptables && !br_opt_get(br, BROPT_NF_CALL_IPTABLES))
 		return NF_ACCEPT;
 
-	if (!IS_IP(skb) && !IS_VLAN_IP(skb) && !IS_PPPOE_IP(skb))
+	if (!IS_IP(skb) && !is_vlan_ip(skb, state->net) &&
+	    !is_pppoe_ip(skb, state->net))
 		return NF_ACCEPT;
 
 	nf_bridge_pull_encap_header_rcsum(skb);
@@ -495,7 +519,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 
 	if (!nf_bridge_alloc(skb))
 		return NF_DROP;
-	if (!setup_pre_routing(skb))
+	if (!setup_pre_routing(skb, state->net))
 		return NF_DROP;
 
 	nf_bridge = nf_bridge_info_get(skb);
@@ -518,7 +542,7 @@ static int br_nf_forward_finish(struct net *net, struct sock *sk, struct sk_buff
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct net_device *in;
 
-	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
+	if (!IS_ARP(skb) && !is_vlan_arp(skb, net)) {
 
 		if (skb->protocol == htons(ETH_P_IP))
 			nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
@@ -573,9 +597,11 @@ static unsigned int br_nf_forward_ip(void *priv,
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
@@ -606,7 +632,7 @@ static unsigned int br_nf_forward_ip(void *priv,
 		skb->protocol = htons(ETH_P_IPV6);
 
 	NF_HOOK(pf, NF_INET_FORWARD, state->net, NULL, skb,
-		brnf_get_logical_dev(skb, state->in),
+		brnf_get_logical_dev(skb, state->in, state->net),
 		parent,	br_nf_forward_finish);
 
 	return NF_STOLEN;
@@ -619,23 +645,25 @@ static unsigned int br_nf_forward_arp(void *priv,
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	struct net_device **d = (struct net_device **)(skb->cb);
+	struct brnf_net *brnet;
 
 	p = br_port_get_rcu(state->out);
 	if (p == NULL)
 		return NF_ACCEPT;
 	br = p->br;
 
-	if (!brnf_call_arptables && !br_opt_get(br, BROPT_NF_CALL_ARPTABLES))
+	brnet = net_generic(state->net, brnf_net_id);
+	if (!brnet->call_arptables && !br_opt_get(br, BROPT_NF_CALL_ARPTABLES))
 		return NF_ACCEPT;
 
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
@@ -795,9 +823,11 @@ static unsigned int br_nf_post_routing(void *priv,
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
@@ -1025,53 +1055,59 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
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
 #endif
 
 static int __init br_netfilter_init(void)
 {
 	int ret;
+	struct brnf_net *brnet;
 
 	ret = register_pernet_subsys(&brnf_net_ops);
 	if (ret < 0)
@@ -1084,6 +1120,16 @@ static int __init br_netfilter_init(void)
 	}
 
 #ifdef CONFIG_SYSCTL
+	brnet = net_generic(&init_net, brnf_net_id);
+	brnf_table[0].data = &brnet->call_arptables;
+	brnf_table[1].data = &brnet->call_iptables;
+	brnf_table[2].data = &brnet->call_ip6tables;
+	brnf_table[3].data = &brnet->filter_vlan_tagged;
+	brnf_table[4].data = &brnet->filter_pppoe_tagged;
+	brnf_table[5].data = &brnet->pass_vlan_indev;
+
+	br_netfilter_sysctl_default(brnet);
+
 	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
 	if (brnf_sysctl_header == NULL) {
 		printk(KERN_WARNING
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e88d6641647b..d77304e4e31a 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -228,7 +228,7 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
 	nf_bridge = nf_bridge_alloc(skb);
 	if (!nf_bridge)
 		return NF_DROP;
-	if (!setup_pre_routing(skb))
+	if (!setup_pre_routing(skb, state->net))
 		return NF_DROP;
 
 	nf_bridge = nf_bridge_info_get(skb);
-- 
2.11.0

