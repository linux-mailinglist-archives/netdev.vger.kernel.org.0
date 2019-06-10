Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFF13BE9B
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389980AbfFJV0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:26:15 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40792 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389784AbfFJV0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:26:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so1907074eds.7
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rl1nreTTZTaCxfaIBD4B09zI2JxN3CleDjmJwdr2ayQ=;
        b=YSeaasbhhASW1qajvO6VL7J60Ac1JuSakpR18pGreViZqUcVX9UFmjIPI/n16rNSsb
         dqf57C8hfsjHY8LHSLcVs+CU82YJbycJHsTiCtESGuRCpLehSNt2BAd5tKGSYeA8v3Lz
         AMaBkL7yfvP+In0Nz6CYyZHKZeGlpdMovL11BshkX2f0ZsheDV1IWa5/4oF5eC0IBUB2
         wuOSqK5fu7YMepGmMDYT1EaoY8XnP5e51hF0bw+eoD7ZSK16JMfmAjd1ahaP6PaQzLC3
         nuqAK01tJkhFvQyc69TC2ByLkgtuBQL5jsNDyQdsfHxdobtSsFyb/EumIiVq1dXrzkzB
         54WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rl1nreTTZTaCxfaIBD4B09zI2JxN3CleDjmJwdr2ayQ=;
        b=AAGw9xpzRBUNCc4lvZ8Coc1lvdbGepjX3quiA/dSMrzyJaxJLD6ZTIh1hDCx6QjdVY
         wN2WpInLsZJrN1QjJbtyBWmbYqilavUj9x/AaO0rBB/ipDZSEeUSLWKqMtUaTbM7Ufn0
         nMFmpudTfFsqX/LNwxe2kucOqkSaRtR2W5yN5mwCu2ucX9CyQbj5wQ34sbCpoAIT+bus
         2o3hsN1PINh1Oj2HIb6bSsWNBAGb6SBLmICVtndBjGgGcmtHkiWrRDCF42YbXykEa5no
         5VHlVg51n1Xk/Mh/ROLN6b3OdGkLZmsM/snzWFrBGweM4htbSjzZDDDdVhvFSHoDHiW1
         94OQ==
X-Gm-Message-State: APjAAAXsaf+15j3Y9FK0qvfqyjotA+PZdQgYfhhSftluEnKGfDGpUTmz
        kJ5z2RhSv1na9bvBYvcTjmlttg==
X-Google-Smtp-Source: APXvYqyAhrRSwgLZRgp3b7+52Jom86tV6Lg2zY+ud5bCdWXkmk9RS30O6p+Fm4M8qmGS6YKNsXbClw==
X-Received: by 2002:a50:c28a:: with SMTP id o10mr8252944edf.182.1560201971929;
        Mon, 10 Jun 2019 14:26:11 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8109:9cc0:6dac:cd8f:f6e9:1b84:bbb1])
        by smtp.gmail.com with ESMTPSA id d28sm1092256edn.31.2019.06.10.14.26.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 14:26:11 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/2] br_netfilter: port sysctls to use brnf_net
Date:   Mon, 10 Jun 2019 23:26:05 +0200
Message-Id: <20190610212606.29743-2-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190610212606.29743-1-christian@brauner.io>
References: <20190610212606.29743-1-christian@brauner.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This ports the sysctls to use struct brnf_net.

With this patch we make it possible to namespace the br_netfilter module in
the following patch.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 include/net/netfilter/br_netfilter.h |   3 +-
 net/bridge/br_netfilter_hooks.c      | 162 +++++++++++++++++----------
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
index 34fa72c72ad8..4595c0d64e6a 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -45,27 +45,24 @@
 
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
 
@@ -85,17 +82,28 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
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
@@ -103,15 +111,23 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
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
@@ -408,12 +424,16 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
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
@@ -423,7 +443,7 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 }
 
 /* Some common code for IPv4/IPv6 */
-struct net_device *setup_pre_routing(struct sk_buff *skb)
+struct net_device *setup_pre_routing(struct sk_buff *skb, const struct net *net)
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
@@ -434,7 +454,7 @@ struct net_device *setup_pre_routing(struct sk_buff *skb)
 
 	nf_bridge->in_prerouting = 1;
 	nf_bridge->physindev = skb->dev;
-	skb->dev = brnf_get_logical_dev(skb, skb->dev);
+	skb->dev = brnf_get_logical_dev(skb, skb->dev, net);
 
 	if (skb->protocol == htons(ETH_P_8021Q))
 		nf_bridge->orig_proto = BRNF_PROTO_8021Q;
@@ -460,6 +480,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	__u32 len = nf_bridge_encap_header_len(skb);
+	struct brnf_net *brnet;
 
 	if (unlikely(!pskb_may_pull(skb, len)))
 		return NF_DROP;
@@ -469,8 +490,10 @@ static unsigned int br_nf_pre_routing(void *priv,
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
 
@@ -478,10 +501,11 @@ static unsigned int br_nf_pre_routing(void *priv,
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
@@ -491,7 +515,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 
 	if (!nf_bridge_alloc(skb))
 		return NF_DROP;
-	if (!setup_pre_routing(skb))
+	if (!setup_pre_routing(skb, state->net))
 		return NF_DROP;
 
 	nf_bridge = nf_bridge_info_get(skb);
@@ -514,7 +538,7 @@ static int br_nf_forward_finish(struct net *net, struct sock *sk, struct sk_buff
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct net_device *in;
 
-	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
+	if (!IS_ARP(skb) && !is_vlan_arp(skb, net)) {
 
 		if (skb->protocol == htons(ETH_P_IP))
 			nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
@@ -569,9 +593,11 @@ static unsigned int br_nf_forward_ip(void *priv,
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
@@ -602,7 +628,7 @@ static unsigned int br_nf_forward_ip(void *priv,
 		skb->protocol = htons(ETH_P_IPV6);
 
 	NF_HOOK(pf, NF_INET_FORWARD, state->net, NULL, skb,
-		brnf_get_logical_dev(skb, state->in),
+		brnf_get_logical_dev(skb, state->in, state->net),
 		parent,	br_nf_forward_finish);
 
 	return NF_STOLEN;
@@ -615,23 +641,25 @@ static unsigned int br_nf_forward_arp(void *priv,
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
@@ -791,9 +819,11 @@ static unsigned int br_nf_post_routing(void *priv,
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
@@ -1021,53 +1051,59 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
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
@@ -1080,6 +1116,16 @@ static int __init br_netfilter_init(void)
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

