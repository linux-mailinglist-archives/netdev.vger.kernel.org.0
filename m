Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6324451FB2
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbfFYAOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:19 -0400
Received: from mail.us.es ([193.147.175.20]:38048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729360AbfFYAMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0234C04B3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD285DA70B
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2FBCDA709; Tue, 25 Jun 2019 02:12:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D064DA707;
        Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6DF574265A2F;
        Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/26] netfilter: bridge: namespace bridge netfilter sysctls
Date:   Tue, 25 Jun 2019 02:12:20 +0200
Message-Id: <20190625001233.22057-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 117 ++++++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 45 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 3c67754d8075..995a498534e9 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -49,13 +49,13 @@
 
 static unsigned int brnf_net_id __read_mostly;
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *brnf_sysctl_header;
-#endif
-
 struct brnf_net {
 	bool enabled;
 
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *ctl_hdr;
+#endif
+
 	/* default value is 1 */
 	int call_iptables;
 	int call_ip6tables;
@@ -980,23 +980,6 @@ static int brnf_device_event(struct notifier_block *unused, unsigned long event,
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
@@ -1102,12 +1085,79 @@ static inline void br_netfilter_sysctl_default(struct brnf_net *brnf)
 	brnf->pass_vlan_indev = 0;
 }
 
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
 #endif
+}
+
+static struct pernet_operations brnf_net_ops __read_mostly = {
+#ifdef CONFIG_SYSCTL
+	.init = brnf_init_net,
+#endif
+	.exit = brnf_exit_net,
+	.id   = &brnf_net_id,
+	.size = sizeof(struct brnf_net),
+};
 
 static int __init br_netfilter_init(void)
 {
 	int ret;
-	struct brnf_net *brnet;
 
 	ret = register_pernet_subsys(&brnf_net_ops);
 	if (ret < 0)
@@ -1119,26 +1169,6 @@ static int __init br_netfilter_init(void)
 		return ret;
 	}
 
-#ifdef CONFIG_SYSCTL
-	brnet = net_generic(&init_net, brnf_net_id);
-	brnf_table[0].data = &brnet->call_arptables;
-	brnf_table[1].data = &brnet->call_iptables;
-	brnf_table[2].data = &brnet->call_ip6tables;
-	brnf_table[3].data = &brnet->filter_vlan_tagged;
-	brnf_table[4].data = &brnet->filter_pppoe_tagged;
-	brnf_table[5].data = &brnet->pass_vlan_indev;
-
-	br_netfilter_sysctl_default(brnet);
-
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
@@ -1149,9 +1179,6 @@ static void __exit br_netfilter_fini(void)
 	RCU_INIT_POINTER(nf_br_ops, NULL);
 	unregister_netdevice_notifier(&brnf_notifier);
 	unregister_pernet_subsys(&brnf_net_ops);
-#ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
-#endif
 }
 
 module_init(br_netfilter_init);
-- 
2.11.0

