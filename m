Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA00488D18
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbiAIXRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:00 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbiAIXQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:55 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 563C16468F;
        Mon, 10 Jan 2022 00:14:05 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/32] netfilter: flowtable: remove ipv4/ipv6 modules
Date:   Mon, 10 Jan 2022 00:16:18 +0100
Message-Id: <20220109231640.104123-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Just place the structs and registration in the inet module.
nf_flow_table_ipv6, nf_flow_table_ipv4 and nf_flow_table_inet share
same module dependencies: nf_flow_table, nf_tables.

before:
   text	   data	    bss	    dec	    hex	filename
   2278	   1480	      0	   3758	    eae	nf_flow_table_inet.ko
   1159	   1352	      0	   2511	    9cf	nf_flow_table_ipv6.ko
   1154	   1352	      0	   2506	    9ca	nf_flow_table_ipv4.ko

after:
   2369	   1672	      0	   4041	    fc9	nf_flow_table_inet.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig              |  8 ++----
 net/ipv4/netfilter/Makefile             |  3 --
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 37 ------------------------
 net/ipv6/netfilter/Kconfig              |  8 ++----
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 38 -------------------------
 net/netfilter/nf_flow_table_inet.c      | 26 +++++++++++++++++
 6 files changed, 30 insertions(+), 90 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 63cb953bd019..67087f95579f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -59,12 +59,8 @@ config NF_TABLES_ARP
 endif # NF_TABLES
 
 config NF_FLOW_TABLE_IPV4
-	tristate "Netfilter flow table IPv4 module"
-	depends on NF_FLOW_TABLE
-	help
-	  This option adds the flow table IPv4 support.
-
-	  To compile it as a module, choose M here.
+	tristate
+	select NF_FLOW_TABLE_INET
 
 config NF_DUP_IPV4
 	tristate "Netfilter IPv4 packet duplication to alternate destination"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index f38fb1368ddb..93bad1184251 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -24,9 +24,6 @@ obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 
-# flow table support
-obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
-
 # generic IP tables
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index aba65fe90345..e69de29bb2d1 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -1,37 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_flow_table.h>
-#include <net/netfilter/nf_tables.h>
-
-static struct nf_flowtable_type flowtable_ipv4 = {
-	.family		= NFPROTO_IPV4,
-	.init		= nf_flow_table_init,
-	.setup		= nf_flow_table_offload_setup,
-	.action		= nf_flow_rule_route_ipv4,
-	.free		= nf_flow_table_free,
-	.hook		= nf_flow_offload_ip_hook,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nf_flow_ipv4_module_init(void)
-{
-	nft_register_flowtable_type(&flowtable_ipv4);
-
-	return 0;
-}
-
-static void __exit nf_flow_ipv4_module_exit(void)
-{
-	nft_unregister_flowtable_type(&flowtable_ipv4);
-}
-
-module_init(nf_flow_ipv4_module_init);
-module_exit(nf_flow_ipv4_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
-MODULE_DESCRIPTION("Netfilter flow table support");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f22233e44ee9..97d3d1b36dbc 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -48,12 +48,8 @@ endif # NF_TABLES_IPV6
 endif # NF_TABLES
 
 config NF_FLOW_TABLE_IPV6
-	tristate "Netfilter flow table IPv6 module"
-	depends on NF_FLOW_TABLE
-	help
-	  This option adds the flow table IPv6 support.
-
-	  To compile it as a module, choose M here.
+	tristate
+	select NF_FLOW_TABLE_INET
 
 config NF_DUP_IPV6
 	tristate "Netfilter IPv6 packet duplication to alternate destination"
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index 667b8af2546a..e69de29bb2d1 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -1,38 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netfilter.h>
-#include <linux/rhashtable.h>
-#include <net/netfilter/nf_flow_table.h>
-#include <net/netfilter/nf_tables.h>
-
-static struct nf_flowtable_type flowtable_ipv6 = {
-	.family		= NFPROTO_IPV6,
-	.init		= nf_flow_table_init,
-	.setup		= nf_flow_table_offload_setup,
-	.action		= nf_flow_rule_route_ipv6,
-	.free		= nf_flow_table_free,
-	.hook		= nf_flow_offload_ipv6_hook,
-	.owner		= THIS_MODULE,
-};
-
-static int __init nf_flow_ipv6_module_init(void)
-{
-	nft_register_flowtable_type(&flowtable_ipv6);
-
-	return 0;
-}
-
-static void __exit nf_flow_ipv6_module_exit(void)
-{
-	nft_unregister_flowtable_type(&flowtable_ipv6);
-}
-
-module_init(nf_flow_ipv6_module_init);
-module_exit(nf_flow_ipv6_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
-MODULE_DESCRIPTION("Netfilter flow table IPv6 module");
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index bc4126d8ef65..5c57ade6bd05 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -54,8 +54,30 @@ static struct nf_flowtable_type flowtable_inet = {
 	.owner		= THIS_MODULE,
 };
 
+static struct nf_flowtable_type flowtable_ipv4 = {
+	.family		= NFPROTO_IPV4,
+	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_route_ipv4,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_ip_hook,
+	.owner		= THIS_MODULE,
+};
+
+static struct nf_flowtable_type flowtable_ipv6 = {
+	.family		= NFPROTO_IPV6,
+	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_route_ipv6,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_ipv6_hook,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nf_flow_inet_module_init(void)
 {
+	nft_register_flowtable_type(&flowtable_ipv4);
+	nft_register_flowtable_type(&flowtable_ipv6);
 	nft_register_flowtable_type(&flowtable_inet);
 
 	return 0;
@@ -64,6 +86,8 @@ static int __init nf_flow_inet_module_init(void)
 static void __exit nf_flow_inet_module_exit(void)
 {
 	nft_unregister_flowtable_type(&flowtable_inet);
+	nft_unregister_flowtable_type(&flowtable_ipv6);
+	nft_unregister_flowtable_type(&flowtable_ipv4);
 }
 
 module_init(nf_flow_inet_module_init);
@@ -71,5 +95,7 @@ module_exit(nf_flow_inet_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
+MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
 MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
 MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
-- 
2.30.2

