Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F446C5883
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCVVIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCVVIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:08:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B341BCB;
        Wed, 22 Mar 2023 14:08:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pf5h0-00042s-Kg; Wed, 22 Mar 2023 22:08:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 4/5] xtables: move icmp/icmpv6 logic to xt_tcpudp
Date:   Wed, 22 Mar 2023 22:08:01 +0100
Message-Id: <20230322210802.6743-5-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322210802.6743-1-fw@strlen.de>
References: <20230322210802.6743-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

icmp/icmp6 matches are baked into ip(6)_tables.ko.

This means that even if iptables-nft is used, a rule like
"-p icmp --icmp-type 1" will load the ip(6)tables modules.

Move them to xt_tcpdudp.ko instead to avoid this.

This will also allow to eventually add kconfig knobs to build kernels
that support iptables-nft but not iptables-legacy (old set/getsockopt
interface).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ip_tables.c  |  68 +-------------------
 net/ipv6/netfilter/ip6_tables.c |  68 +-------------------
 net/netfilter/xt_tcpudp.c       | 110 ++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 134 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index da5998011ab9..7da1df4997d0 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -14,7 +14,6 @@
 #include <linux/vmalloc.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
-#include <linux/icmp.h>
 #include <net/ip.h>
 #include <net/compat.h>
 #include <linux/uaccess.h>
@@ -31,7 +30,6 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv4 packet filter");
-MODULE_ALIAS("ipt_icmp");
 
 void *ipt_alloc_initial_table(const struct xt_table *info)
 {
@@ -1799,52 +1797,6 @@ void ipt_unregister_table_exit(struct net *net, const char *name)
 		__ipt_unregister_table(net, table);
 }
 
-/* Returns 1 if the type and code is matched by the range, 0 otherwise */
-static inline bool
-icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
-		     u_int8_t type, u_int8_t code,
-		     bool invert)
-{
-	return ((test_type == 0xFF) ||
-		(type == test_type && code >= min_code && code <= max_code))
-		^ invert;
-}
-
-static bool
-icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
-{
-	const struct icmphdr *ic;
-	struct icmphdr _icmph;
-	const struct ipt_icmp *icmpinfo = par->matchinfo;
-
-	/* Must not be a fragment. */
-	if (par->fragoff != 0)
-		return false;
-
-	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
-	if (ic == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		par->hotdrop = true;
-		return false;
-	}
-
-	return icmp_type_code_match(icmpinfo->type,
-				    icmpinfo->code[0],
-				    icmpinfo->code[1],
-				    ic->type, ic->code,
-				    !!(icmpinfo->invflags&IPT_ICMP_INV));
-}
-
-static int icmp_checkentry(const struct xt_mtchk_param *par)
-{
-	const struct ipt_icmp *icmpinfo = par->matchinfo;
-
-	/* Must specify no unknown invflags */
-	return (icmpinfo->invflags & ~IPT_ICMP_INV) ? -EINVAL : 0;
-}
-
 static struct xt_target ipt_builtin_tg[] __read_mostly = {
 	{
 		.name             = XT_STANDARD_TARGET,
@@ -1875,18 +1827,6 @@ static struct nf_sockopt_ops ipt_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
-static struct xt_match ipt_builtin_mt[] __read_mostly = {
-	{
-		.name       = "icmp",
-		.match      = icmp_match,
-		.matchsize  = sizeof(struct ipt_icmp),
-		.checkentry = icmp_checkentry,
-		.proto      = IPPROTO_ICMP,
-		.family     = NFPROTO_IPV4,
-		.me	    = THIS_MODULE,
-	},
-};
-
 static int __net_init ip_tables_net_init(struct net *net)
 {
 	return xt_proto_init(net, NFPROTO_IPV4);
@@ -1914,19 +1854,14 @@ static int __init ip_tables_init(void)
 	ret = xt_register_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 	if (ret < 0)
 		goto err2;
-	ret = xt_register_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
-	if (ret < 0)
-		goto err4;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&ipt_sockopts);
 	if (ret < 0)
-		goto err5;
+		goto err4;
 
 	return 0;
 
-err5:
-	xt_unregister_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
 err4:
 	xt_unregister_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 err2:
@@ -1939,7 +1874,6 @@ static void __exit ip_tables_fini(void)
 {
 	nf_unregister_sockopt(&ipt_sockopts);
 
-	xt_unregister_matches(ipt_builtin_mt, ARRAY_SIZE(ipt_builtin_mt));
 	xt_unregister_targets(ipt_builtin_tg, ARRAY_SIZE(ipt_builtin_tg));
 	unregister_pernet_subsys(&ip_tables_net_ops);
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0ce0ed17c758..fd9f049d6d41 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -18,7 +18,6 @@
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/poison.h>
-#include <linux/icmpv6.h>
 #include <net/ipv6.h>
 #include <net/compat.h>
 #include <linux/uaccess.h>
@@ -35,7 +34,6 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv6 packet filter");
-MODULE_ALIAS("ip6t_icmp6");
 
 void *ip6t_alloc_initial_table(const struct xt_table *info)
 {
@@ -1805,52 +1803,6 @@ void ip6t_unregister_table_exit(struct net *net, const char *name)
 		__ip6t_unregister_table(net, table);
 }
 
-/* Returns 1 if the type and code is matched by the range, 0 otherwise */
-static inline bool
-icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
-		     u_int8_t type, u_int8_t code,
-		     bool invert)
-{
-	return (type == test_type && code >= min_code && code <= max_code)
-		^ invert;
-}
-
-static bool
-icmp6_match(const struct sk_buff *skb, struct xt_action_param *par)
-{
-	const struct icmp6hdr *ic;
-	struct icmp6hdr _icmph;
-	const struct ip6t_icmp *icmpinfo = par->matchinfo;
-
-	/* Must not be a fragment. */
-	if (par->fragoff != 0)
-		return false;
-
-	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
-	if (ic == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		par->hotdrop = true;
-		return false;
-	}
-
-	return icmp6_type_code_match(icmpinfo->type,
-				     icmpinfo->code[0],
-				     icmpinfo->code[1],
-				     ic->icmp6_type, ic->icmp6_code,
-				     !!(icmpinfo->invflags&IP6T_ICMP_INV));
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int icmp6_checkentry(const struct xt_mtchk_param *par)
-{
-	const struct ip6t_icmp *icmpinfo = par->matchinfo;
-
-	/* Must specify no unknown invflags */
-	return (icmpinfo->invflags & ~IP6T_ICMP_INV) ? -EINVAL : 0;
-}
-
 /* The built-in targets: standard (NULL) and error. */
 static struct xt_target ip6t_builtin_tg[] __read_mostly = {
 	{
@@ -1882,18 +1834,6 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
-static struct xt_match ip6t_builtin_mt[] __read_mostly = {
-	{
-		.name       = "icmp6",
-		.match      = icmp6_match,
-		.matchsize  = sizeof(struct ip6t_icmp),
-		.checkentry = icmp6_checkentry,
-		.proto      = IPPROTO_ICMPV6,
-		.family     = NFPROTO_IPV6,
-		.me	    = THIS_MODULE,
-	},
-};
-
 static int __net_init ip6_tables_net_init(struct net *net)
 {
 	return xt_proto_init(net, NFPROTO_IPV6);
@@ -1921,19 +1861,14 @@ static int __init ip6_tables_init(void)
 	ret = xt_register_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 	if (ret < 0)
 		goto err2;
-	ret = xt_register_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
-	if (ret < 0)
-		goto err4;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&ip6t_sockopts);
 	if (ret < 0)
-		goto err5;
+		goto err4;
 
 	return 0;
 
-err5:
-	xt_unregister_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
 err4:
 	xt_unregister_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 err2:
@@ -1946,7 +1881,6 @@ static void __exit ip6_tables_fini(void)
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
 
-	xt_unregister_matches(ip6t_builtin_mt, ARRAY_SIZE(ip6t_builtin_mt));
 	xt_unregister_targets(ip6t_builtin_tg, ARRAY_SIZE(ip6t_builtin_tg));
 	unregister_pernet_subsys(&ip6_tables_net_ops);
 }
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 11ec2abf0c72..e8991130a3de 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <net/ip.h>
 #include <linux/ipv6.h>
+#include <linux/icmp.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <net/udp.h>
@@ -20,6 +21,8 @@ MODULE_ALIAS("ipt_udp");
 MODULE_ALIAS("ipt_tcp");
 MODULE_ALIAS("ip6t_udp");
 MODULE_ALIAS("ip6t_tcp");
+MODULE_ALIAS("ipt_icmp");
+MODULE_ALIAS("ip6t_icmp6");
 
 /* Returns 1 if the port is matched by the range, 0 otherwise */
 static inline bool
@@ -161,6 +164,95 @@ static int udp_mt_check(const struct xt_mtchk_param *par)
 	return (udpinfo->invflags & ~XT_UDP_INV_MASK) ? -EINVAL : 0;
 }
 
+/* Returns 1 if the type and code is matched by the range, 0 otherwise */
+static bool type_code_in_range(u8 test_type, u8 min_code, u8 max_code,
+			       u8 type, u8 code)
+{
+	return type == test_type && code >= min_code && code <= max_code;
+}
+
+static bool icmp_type_code_match(u8 test_type, u8 min_code, u8 max_code,
+				 u8 type, u8 code, bool invert)
+{
+	return (test_type == 0xFF ||
+		type_code_in_range(test_type, min_code, max_code, type, code))
+		^ invert;
+}
+
+static bool icmp6_type_code_match(u8 test_type, u8 min_code, u8 max_code,
+				  u8 type, u8 code, bool invert)
+{
+	return type_code_in_range(test_type, min_code, max_code, type, code) ^ invert;
+}
+
+static bool
+icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct icmphdr *ic;
+	struct icmphdr _icmph;
+	const struct ipt_icmp *icmpinfo = par->matchinfo;
+
+	/* Must not be a fragment. */
+	if (par->fragoff != 0)
+		return false;
+
+	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
+	if (!ic) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		par->hotdrop = true;
+		return false;
+	}
+
+	return icmp_type_code_match(icmpinfo->type,
+				    icmpinfo->code[0],
+				    icmpinfo->code[1],
+				    ic->type, ic->code,
+				    !!(icmpinfo->invflags & IPT_ICMP_INV));
+}
+
+static bool
+icmp6_match(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct icmp6hdr *ic;
+	struct icmp6hdr _icmph;
+	const struct ip6t_icmp *icmpinfo = par->matchinfo;
+
+	/* Must not be a fragment. */
+	if (par->fragoff != 0)
+		return false;
+
+	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
+	if (!ic) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		par->hotdrop = true;
+		return false;
+	}
+
+	return icmp6_type_code_match(icmpinfo->type,
+				     icmpinfo->code[0],
+				     icmpinfo->code[1],
+				     ic->icmp6_type, ic->icmp6_code,
+				     !!(icmpinfo->invflags & IP6T_ICMP_INV));
+}
+
+static int icmp_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct ipt_icmp *icmpinfo = par->matchinfo;
+
+	return (icmpinfo->invflags & ~IPT_ICMP_INV) ? -EINVAL : 0;
+}
+
+static int icmp6_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_icmp *icmpinfo = par->matchinfo;
+
+	return (icmpinfo->invflags & ~IP6T_ICMP_INV) ? -EINVAL : 0;
+}
+
 static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcp",
@@ -216,6 +308,24 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 		.proto		= IPPROTO_UDPLITE,
 		.me		= THIS_MODULE,
 	},
+	{
+		.name       = "icmp",
+		.match      = icmp_match,
+		.matchsize  = sizeof(struct ipt_icmp),
+		.checkentry = icmp_checkentry,
+		.proto      = IPPROTO_ICMP,
+		.family     = NFPROTO_IPV4,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "icmp6",
+		.match      = icmp6_match,
+		.matchsize  = sizeof(struct ip6t_icmp),
+		.checkentry = icmp6_checkentry,
+		.proto      = IPPROTO_ICMPV6,
+		.family     = NFPROTO_IPV6,
+		.me	    = THIS_MODULE,
+	},
 };
 
 static int __init tcpudp_mt_init(void)
-- 
2.39.2

