Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3633732F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfFFLmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:42:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55625 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbfFFLmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:42:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so1781659wmj.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 04:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=neS+sCJ5RsoScyaZbPRkUrjAbSi4FQUAdivp39FTODE=;
        b=DdGaeNDBsEvp6Xq7tC7vGVZOE6KGq4fY1WIHlFqqXgntDmpUk6lsa9FZo+8+8k86o7
         xNvMHwN4eXVP4p8/gJtprYprNWFylxWk39PII319Nr1wrxiIQvTYpcfgsFY9sVGKaNit
         8OiB6K3i1MNvThKKUfgqZdPN6n7QZ0GwXKMuvDZ9P901YFuaraPVD63NPg5FkI2ME9Ar
         irz6u6KpZ4xTsy4qRJq0bBaOQFhJkhnqpuDa24lyCcMEd92IJbTr8DrTLwPFbIXVbM8E
         sSQIuzIS3nQwHmFAH4w3rLX5voZAbEhLvECVM7Z8WbtX1xNBj+qKd0et8b/LUkF+p0Rp
         9+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=neS+sCJ5RsoScyaZbPRkUrjAbSi4FQUAdivp39FTODE=;
        b=NNv+OOpz5uILn8bIugcu8xTVaZbwBo6dwA3x3C8BUyR7VlB/YRJrl8g0gB+ltmLSUB
         Hjmh70u7fBIwL/lFsjqptPBybZNHPANVVJjw6Y5c50NiamAcGfaG9UjqBxl02+3wN51A
         Fb7S49INTagHdZEDKTQ1coO4bABVAcx9h3F8LckaTEt3Nuj85pcdtwQPfkfU9n+fRnjw
         QMlll8QH2J4JLYVwdFu4T0s0ZpFY7nvWe8Am4GNPnL7B7Q4QXjalH/uD6Fgr2zvaRMc4
         1DOodGaLt4/985ynf86vQidE+E8ZoNV4CDUpGvnkAXeWn9kAk13XBppesYM0iJqMvYIl
         uLrQ==
X-Gm-Message-State: APjAAAWKsXrLIbWqAhS3y0oUpweYI+4kzMScH2P11iwCEvhbrq7ib12s
        NzRUdM2MvVz8OfPJ7Npelg8tTg==
X-Google-Smtp-Source: APXvYqwPp2w5klCv6GgjCKO4OA/MN60KA72xzIc5PqD9dpXVee7bU+Tn1HRyr08p+LGeevzPcnI5KA==
X-Received: by 2002:a7b:cbcb:: with SMTP id n11mr9011116wmi.146.1559821333687;
        Thu, 06 Jun 2019 04:42:13 -0700 (PDT)
Received: from localhost.localdomain (p548C9938.dip0.t-ipconnect.de. [84.140.153.56])
        by smtp.gmail.com with ESMTPSA id 95sm2002583wrk.70.2019.06.06.04.42.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 04:42:13 -0700 (PDT)
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
Subject: [PATCH RESEND net-next 1/2] br_netfilter: add struct netns_brnf
Date:   Thu,  6 Jun 2019 13:41:41 +0200
Message-Id: <20190606114142.15972-2-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606114142.15972-1-christian@brauner.io>
References: <20190606114142.15972-1-christian@brauner.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds struct netns_brnf in preparation for per-network-namespace
br_netfilter settings. The individual br_netfilter sysctl options are moved
into a central place in struct net. The struct is only included when
the CONFIG_BRIDGE_NETFILTER kconfig option is enabled in the kernel.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
---
 include/net/net_namespace.h     |  3 ++
 include/net/netns/netfilter.h   | 16 ++++++++
 net/bridge/br_netfilter_hooks.c | 68 ++++++++++++++++-----------------
 3 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 12689ddfc24c..a958d09dc14d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -127,6 +127,9 @@ struct net {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	struct netns_ct		ct;
 #endif
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct netns_brnf	brnf;
+#endif
 #if defined(CONFIG_NF_TABLES) || defined(CONFIG_NF_TABLES_MODULE)
 	struct netns_nftables	nft;
 #endif
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index ca043342c0eb..eedbd1ac940e 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -35,4 +35,20 @@ struct netns_nf {
 	bool			defrag_ipv6;
 #endif
 };
+
+struct netns_brnf {
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *ctl_hdr;
+#endif
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
 #endif
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 34fa72c72ad8..b51c6b49fc6f 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -49,23 +49,6 @@ struct brnf_net {
 	bool enabled;
 };
 
-#ifdef CONFIG_SYSCTL
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
-#endif
-
 #define IS_IP(skb) \
 	(!skb_vlan_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
 
@@ -87,15 +70,15 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 
 #define IS_VLAN_IP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IP) && \
-	 brnf_filter_vlan_tagged)
+	 init_net.brnf.filter_vlan_tagged)
 
 #define IS_VLAN_IPV6(skb) \
 	(vlan_proto(skb) == htons(ETH_P_IPV6) && \
-	 brnf_filter_vlan_tagged)
+	 init_net.brnf.filter_vlan_tagged)
 
 #define IS_VLAN_ARP(skb) \
 	(vlan_proto(skb) == htons(ETH_P_ARP) &&	\
-	 brnf_filter_vlan_tagged)
+	 init_net.brnf.filter_vlan_tagged)
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
 {
@@ -106,12 +89,12 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
 #define IS_PPPOE_IP(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IP) && \
-	 brnf_filter_pppoe_tagged)
+	 init_net.brnf.filter_pppoe_tagged)
 
 #define IS_PPPOE_IPV6(skb) \
 	(skb->protocol == htons(ETH_P_PPP_SES) && \
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
-	 brnf_filter_pppoe_tagged)
+	 init_net.brnf.filter_pppoe_tagged)
 
 /* largest possible L2 header, see br_nf_dev_queue_xmit() */
 #define NF_BRIDGE_MAX_MAC_HEADER_LENGTH (PPPOE_SES_HLEN + ETH_HLEN)
@@ -413,7 +396,7 @@ static struct net_device *brnf_get_logical_dev(struct sk_buff *skb, const struct
 	struct net_device *vlan, *br;
 
 	br = bridge_parent(dev);
-	if (brnf_pass_vlan_indev == 0 || !skb_vlan_tag_present(skb))
+	if (init_net.brnf.pass_vlan_indev == 0 || !skb_vlan_tag_present(skb))
 		return br;
 
 	vlan = __vlan_find_dev_deep_rcu(br, skb->vlan_proto,
@@ -470,7 +453,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	br = p->br;
 
 	if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
-		if (!brnf_call_ip6tables &&
+		if (!init_net.brnf.call_ip6tables &&
 		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
 			return NF_ACCEPT;
 
@@ -478,7 +461,8 @@ static unsigned int br_nf_pre_routing(void *priv,
 		return br_nf_pre_routing_ipv6(priv, skb, state);
 	}
 
-	if (!brnf_call_iptables && !br_opt_get(br, BROPT_NF_CALL_IPTABLES))
+	if (!init_net.brnf.call_iptables &&
+	    !br_opt_get(br, BROPT_NF_CALL_IPTABLES))
 		return NF_ACCEPT;
 
 	if (!IS_IP(skb) && !IS_VLAN_IP(skb) && !IS_PPPOE_IP(skb))
@@ -621,7 +605,8 @@ static unsigned int br_nf_forward_arp(void *priv,
 		return NF_ACCEPT;
 	br = p->br;
 
-	if (!brnf_call_arptables && !br_opt_get(br, BROPT_NF_CALL_ARPTABLES))
+	if (!init_net.brnf.call_arptables &&
+	    !br_opt_get(br, BROPT_NF_CALL_ARPTABLES))
 		return NF_ACCEPT;
 
 	if (!IS_ARP(skb)) {
@@ -1021,42 +1006,42 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 static struct ctl_table brnf_table[] = {
 	{
 		.procname	= "bridge-nf-call-arptables",
-		.data		= &brnf_call_arptables,
+		.data		= &init_net.brnf.call_arptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-call-iptables",
-		.data		= &brnf_call_iptables,
+		.data		= &init_net.brnf.call_iptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-call-ip6tables",
-		.data		= &brnf_call_ip6tables,
+		.data		= &init_net.brnf.call_ip6tables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
-		.data		= &brnf_filter_vlan_tagged,
+		.data		= &init_net.brnf.filter_vlan_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-pppoe-tagged",
-		.data		= &brnf_filter_pppoe_tagged,
+		.data		= &init_net.brnf.filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
 		.procname	= "bridge-nf-pass-vlan-input-dev",
-		.data		= &brnf_pass_vlan_indev,
+		.data		= &init_net.brnf.pass_vlan_indev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
@@ -1065,6 +1050,16 @@ static struct ctl_table brnf_table[] = {
 };
 #endif
 
+static inline void br_netfilter_sysctl_default(struct netns_brnf *brnf)
+{
+	brnf->call_iptables = 1;
+	brnf->call_ip6tables = 1;
+	brnf->call_arptables = 1;
+	brnf->filter_vlan_tagged = 0;
+	brnf->filter_pppoe_tagged = 0;
+	brnf->pass_vlan_indev = 0;
+}
+
 static int __init br_netfilter_init(void)
 {
 	int ret;
@@ -1079,9 +1074,12 @@ static int __init br_netfilter_init(void)
 		return ret;
 	}
 
+	/* Always set default values. Even if CONFIG_SYSCTL is not set. */
+	br_netfilter_sysctl_default(&init_net.brnf);
+
 #ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
+	init_net.brnf.ctl_hdr = register_net_sysctl(&init_net, "net/bridge", brnf_table);
+	if (!init_net.brnf.ctl_hdr) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
 		unregister_netdevice_notifier(&brnf_notifier);
@@ -1100,7 +1098,7 @@ static void __exit br_netfilter_fini(void)
 	unregister_netdevice_notifier(&brnf_notifier);
 	unregister_pernet_subsys(&brnf_net_ops);
 #ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
+	unregister_net_sysctl_table(init_net.brnf.ctl_hdr);
 #endif
 }
 
-- 
2.21.0

