Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E5D35539A
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344014AbhDFMWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34414 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343951AbhDFMVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:21:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5E15E63E59;
        Tue,  6 Apr 2021 14:21:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/28] netfilter: nf_log_netdev: merge with nf_log_syslog
Date:   Tue,  6 Apr 2021 14:21:09 +0200
Message-Id: <20210406122133.1644-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Provide netdev family support from the nf_log_syslog module.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig         |  4 --
 net/netfilter/Makefile        |  3 --
 net/netfilter/nf_log_netdev.c | 78 -----------------------------------
 net/netfilter/nf_log_syslog.c | 36 ++++++++++++++++
 4 files changed, 36 insertions(+), 85 deletions(-)
 delete mode 100644 net/netfilter/nf_log_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d5c047190eb9..6aef981a8446 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -74,10 +74,6 @@ config NF_CONNTRACK
 config NF_LOG_COMMON
 	tristate
 
-config NF_LOG_NETDEV
-	tristate "Netdev packet logging"
-	select NF_LOG_COMMON
-
 config NF_LOG_SYSLOG
 	tristate "Syslog packet logging"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 59642d9ab7a5..429be36fe4c7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -52,9 +52,6 @@ nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
 obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
 obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 
-# packet logging for netdev family
-obj-$(CONFIG_NF_LOG_NETDEV) += nf_log_netdev.o
-
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
 nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
diff --git a/net/netfilter/nf_log_netdev.c b/net/netfilter/nf_log_netdev.c
deleted file mode 100644
index 968dafa684c9..000000000000
--- a/net/netfilter/nf_log_netdev.c
+++ /dev/null
@@ -1,78 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/route.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_log.h>
-
-static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
-				 unsigned int hooknum,
-				 const struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 const struct nf_loginfo *loginfo,
-				 const char *prefix)
-{
-	nf_log_l2packet(net, pf, skb->protocol, hooknum, skb, in, out,
-			loginfo, prefix);
-}
-
-static struct nf_logger nf_netdev_logger __read_mostly = {
-	.name		= "nf_log_netdev",
-	.type		= NF_LOG_TYPE_LOG,
-	.logfn		= nf_log_netdev_packet,
-	.me		= THIS_MODULE,
-};
-
-static int __net_init nf_log_netdev_net_init(struct net *net)
-{
-	return nf_log_set(net, NFPROTO_NETDEV, &nf_netdev_logger);
-}
-
-static void __net_exit nf_log_netdev_net_exit(struct net *net)
-{
-	nf_log_unset(net, &nf_netdev_logger);
-}
-
-static struct pernet_operations nf_log_netdev_net_ops = {
-	.init = nf_log_netdev_net_init,
-	.exit = nf_log_netdev_net_exit,
-};
-
-static int __init nf_log_netdev_init(void)
-{
-	int ret;
-
-	/* Request to load the real packet loggers. */
-	nf_logger_request_module(NFPROTO_IPV4, NF_LOG_TYPE_LOG);
-	nf_logger_request_module(NFPROTO_IPV6, NF_LOG_TYPE_LOG);
-	nf_logger_request_module(NFPROTO_ARP, NF_LOG_TYPE_LOG);
-
-	ret = register_pernet_subsys(&nf_log_netdev_net_ops);
-	if (ret < 0)
-		return ret;
-
-	nf_log_register(NFPROTO_NETDEV, &nf_netdev_logger);
-	return 0;
-}
-
-static void __exit nf_log_netdev_exit(void)
-{
-	unregister_pernet_subsys(&nf_log_netdev_net_ops);
-	nf_log_unregister(&nf_netdev_logger);
-}
-
-module_init(nf_log_netdev_init);
-module_exit(nf_log_netdev_exit);
-
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_DESCRIPTION("Netfilter netdev packet logging");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 9ba71bc2ef84..617e0071c0c4 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -768,6 +768,25 @@ static struct nf_logger nf_ip6_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
+static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
+				 unsigned int hooknum,
+				 const struct sk_buff *skb,
+				 const struct net_device *in,
+				 const struct net_device *out,
+				 const struct nf_loginfo *loginfo,
+				 const char *prefix)
+{
+	nf_log_l2packet(net, pf, skb->protocol, hooknum, skb, in, out,
+			loginfo, prefix);
+}
+
+static struct nf_logger nf_netdev_logger __read_mostly = {
+	.name		= "nf_log_netdev",
+	.type		= NF_LOG_TYPE_LOG,
+	.logfn		= nf_log_netdev_packet,
+	.me		= THIS_MODULE,
+};
+
 static int __net_init nf_log_syslog_net_init(struct net *net)
 {
 	int ret = nf_log_set(net, NFPROTO_IPV4, &nf_ip_logger);
@@ -782,7 +801,13 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	ret = nf_log_set(net, NFPROTO_IPV6, &nf_ip6_logger);
 	if (ret)
 		goto err2;
+
+	ret = nf_log_set(net, NFPROTO_NETDEV, &nf_netdev_logger);
+	if (ret)
+		goto err3;
 	return 0;
+err3:
+	nf_log_unset(net, &nf_ip6_logger);
 err2:
 	nf_log_unset(net, &nf_arp_logger);
 err1:
@@ -794,6 +819,8 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 	nf_log_unset(net, &nf_arp_logger);
+	nf_log_unset(net, &nf_ip6_logger);
+	nf_log_unset(net, &nf_netdev_logger);
 }
 
 static struct pernet_operations nf_log_syslog_net_ops = {
@@ -821,7 +848,13 @@ static int __init nf_log_syslog_init(void)
 	if (ret < 0)
 		goto err3;
 
+	ret = nf_log_register(NFPROTO_NETDEV, &nf_netdev_logger);
+	if (ret < 0)
+		goto err4;
+
 	return 0;
+err4:
+	nf_log_unregister(&nf_ip6_logger);
 err3:
 	nf_log_unregister(&nf_arp_logger);
 err2:
@@ -838,6 +871,7 @@ static void __exit nf_log_syslog_exit(void)
 	nf_log_unregister(&nf_ip_logger);
 	nf_log_unregister(&nf_arp_logger);
 	nf_log_unregister(&nf_ip6_logger);
+	nf_log_unregister(&nf_netdev_logger);
 }
 
 module_init(nf_log_syslog_init);
@@ -849,6 +883,8 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("nf_log_arp");
 MODULE_ALIAS("nf_log_ipv4");
 MODULE_ALIAS("nf_log_ipv6");
+MODULE_ALIAS("nf_log_netdev");
 MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
 MODULE_ALIAS_NF_LOGGER(3, 0);
+MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
 MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
-- 
2.30.2

