Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59A35539D
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344025AbhDFMWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34418 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343953AbhDFMVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:21:55 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 19C3B63E49;
        Tue,  6 Apr 2021 14:21:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/28] netfilter: nf_log_bridge: merge with nf_log_syslog
Date:   Tue,  6 Apr 2021 14:21:10 +0200
Message-Id: <20210406122133.1644-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Provide bridge log support from nf_log_syslog.

After the merge there is no need to load the "real packet loggers",
all of them now reside in the same module.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_log.h       |  1 -
 net/bridge/netfilter/Kconfig         |  4 --
 net/bridge/netfilter/Makefile        |  3 --
 net/bridge/netfilter/nf_log_bridge.c | 79 ----------------------------
 net/netfilter/nf_log.c               |  7 ---
 net/netfilter/nf_log_syslog.c        | 22 ++++++++
 6 files changed, 22 insertions(+), 94 deletions(-)
 delete mode 100644 net/bridge/netfilter/nf_log_bridge.c

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 716db4a0fed8..a6b85068c294 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -68,7 +68,6 @@ void nf_log_unbind_pf(struct net *net, u_int8_t pf);
 
 int nf_logger_find_get(int pf, enum nf_log_type type);
 void nf_logger_put(int pf, enum nf_log_type type);
-void nf_logger_request_module(int pf, enum nf_log_type type);
 
 #define MODULE_ALIAS_NF_LOGGER(family, type) \
 	MODULE_ALIAS("nf-logger-" __stringify(family) "-" __stringify(type))
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index ac5372121e60..7f304a19ac1b 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -23,10 +23,6 @@ config NFT_BRIDGE_REJECT
 	help
 	  Add support to reject packets.
 
-config NF_LOG_BRIDGE
-	tristate "Bridge packet logging"
-	select NF_LOG_COMMON
-
 endif # NF_TABLES_BRIDGE
 
 config NF_CONNTRACK_BRIDGE
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 8e2c5759d964..1c9ce49ab651 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -9,9 +9,6 @@ obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
 
-# packet logging
-obj-$(CONFIG_NF_LOG_BRIDGE) += nf_log_bridge.o
-
 obj-$(CONFIG_BRIDGE_NF_EBTABLES) += ebtables.o
 
 # tables
diff --git a/net/bridge/netfilter/nf_log_bridge.c b/net/bridge/netfilter/nf_log_bridge.c
deleted file mode 100644
index 1ad61d1017b6..000000000000
--- a/net/bridge/netfilter/nf_log_bridge.c
+++ /dev/null
@@ -1,79 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (C) 2014 by Pablo Neira Ayuso <pablo@netfilter.org>
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/skbuff.h>
-#include <linux/if_bridge.h>
-#include <linux/ip.h>
-#include <net/route.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_log.h>
-
-static void nf_log_bridge_packet(struct net *net, u_int8_t pf,
-				 unsigned int hooknum,
-				 const struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 const struct nf_loginfo *loginfo,
-				 const char *prefix)
-{
-	nf_log_l2packet(net, pf, eth_hdr(skb)->h_proto, hooknum, skb,
-			in, out, loginfo, prefix);
-}
-
-static struct nf_logger nf_bridge_logger __read_mostly = {
-	.name		= "nf_log_bridge",
-	.type		= NF_LOG_TYPE_LOG,
-	.logfn		= nf_log_bridge_packet,
-	.me		= THIS_MODULE,
-};
-
-static int __net_init nf_log_bridge_net_init(struct net *net)
-{
-	return nf_log_set(net, NFPROTO_BRIDGE, &nf_bridge_logger);
-}
-
-static void __net_exit nf_log_bridge_net_exit(struct net *net)
-{
-	nf_log_unset(net, &nf_bridge_logger);
-}
-
-static struct pernet_operations nf_log_bridge_net_ops = {
-	.init = nf_log_bridge_net_init,
-	.exit = nf_log_bridge_net_exit,
-};
-
-static int __init nf_log_bridge_init(void)
-{
-	int ret;
-
-	/* Request to load the real packet loggers. */
-	nf_logger_request_module(NFPROTO_IPV4, NF_LOG_TYPE_LOG);
-	nf_logger_request_module(NFPROTO_IPV6, NF_LOG_TYPE_LOG);
-	nf_logger_request_module(NFPROTO_ARP, NF_LOG_TYPE_LOG);
-
-	ret = register_pernet_subsys(&nf_log_bridge_net_ops);
-	if (ret < 0)
-		return ret;
-
-	nf_log_register(NFPROTO_BRIDGE, &nf_bridge_logger);
-	return 0;
-}
-
-static void __exit nf_log_bridge_exit(void)
-{
-	unregister_pernet_subsys(&nf_log_bridge_net_ops);
-	nf_log_unregister(&nf_bridge_logger);
-}
-
-module_init(nf_log_bridge_init);
-module_exit(nf_log_bridge_exit);
-
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_DESCRIPTION("Netfilter bridge packet logging");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 0);
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6cb9f9474b05..eaa8181f5ef7 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -151,13 +151,6 @@ void nf_log_unbind_pf(struct net *net, u_int8_t pf)
 }
 EXPORT_SYMBOL(nf_log_unbind_pf);
 
-void nf_logger_request_module(int pf, enum nf_log_type type)
-{
-	if (loggers[pf][type] == NULL)
-		request_module("nf-logger-%u-%u", pf, type);
-}
-EXPORT_SYMBOL_GPL(nf_logger_request_module);
-
 int nf_logger_find_get(int pf, enum nf_log_type type)
 {
 	struct nf_logger *logger;
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 617e0071c0c4..6b56251de22a 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -787,6 +787,13 @@ static struct nf_logger nf_netdev_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
+static struct nf_logger nf_bridge_logger __read_mostly = {
+	.name		= "nf_log_bridge",
+	.type		= NF_LOG_TYPE_LOG,
+	.logfn		= nf_log_netdev_packet,
+	.me		= THIS_MODULE,
+};
+
 static int __net_init nf_log_syslog_net_init(struct net *net)
 {
 	int ret = nf_log_set(net, NFPROTO_IPV4, &nf_ip_logger);
@@ -805,7 +812,13 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	ret = nf_log_set(net, NFPROTO_NETDEV, &nf_netdev_logger);
 	if (ret)
 		goto err3;
+
+	ret = nf_log_set(net, NFPROTO_BRIDGE, &nf_bridge_logger);
+	if (ret)
+		goto err4;
 	return 0;
+err4:
+	nf_log_unset(net, &nf_netdev_logger);
 err3:
 	nf_log_unset(net, &nf_ip6_logger);
 err2:
@@ -852,7 +865,13 @@ static int __init nf_log_syslog_init(void)
 	if (ret < 0)
 		goto err4;
 
+	ret = nf_log_register(NFPROTO_BRIDGE, &nf_bridge_logger);
+	if (ret < 0)
+		goto err5;
+
 	return 0;
+err5:
+	nf_log_unregister(&nf_netdev_logger);
 err4:
 	nf_log_unregister(&nf_ip6_logger);
 err3:
@@ -872,6 +891,7 @@ static void __exit nf_log_syslog_exit(void)
 	nf_log_unregister(&nf_arp_logger);
 	nf_log_unregister(&nf_ip6_logger);
 	nf_log_unregister(&nf_netdev_logger);
+	nf_log_unregister(&nf_bridge_logger);
 }
 
 module_init(nf_log_syslog_init);
@@ -881,9 +901,11 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Netfilter syslog packet logging");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("nf_log_arp");
+MODULE_ALIAS("nf_log_bridge");
 MODULE_ALIAS("nf_log_ipv4");
 MODULE_ALIAS("nf_log_ipv6");
 MODULE_ALIAS("nf_log_netdev");
+MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 0);
 MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
 MODULE_ALIAS_NF_LOGGER(3, 0);
 MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
-- 
2.30.2

