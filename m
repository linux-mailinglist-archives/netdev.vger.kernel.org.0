Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5155F35DE2E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343993AbhDMMCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:02:55 -0400
Received: from mx1.infotecs.ru ([91.244.183.116]:54111 "EHLO mx1.infotecs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238034AbhDMMCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 08:02:54 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 08:02:53 EDT
Received: from mx1.infotecs-nt (localhost [127.0.0.1])
        by mx1.infotecs.ru (Postfix) with ESMTP id C7598219707D;
        Tue, 13 Apr 2021 14:56:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.infotecs.ru C7598219707D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1618315011; bh=1vpRhocFDWpE6nN7pdL62h+ArKE2njK1rckqjs3zr8g=;
        h=Date:From:To:CC:Subject:From;
        b=txivepodlg5WgOGGDYbsyMBNKIsbbcIqZWiwxX6iMHeMlREodvwO2JMDF0Cn2/d9U
         5y+xQgRv1A5DOGp0kWdB9ejaFpFfdTXxyRh97D85kigUDIYfShIW/gHPdo78l0QBBo
         kDBj5M76ZxKRvDQFEFOR/wMD7BhzKZCadg+d9Dug=
Received: from msk-exch-01.infotecs-nt (autodiscover.amonitoring.ru [10.0.7.191])
        by mx1.infotecs-nt (Postfix) with ESMTP id C5687208CE53;
        Tue, 13 Apr 2021 14:56:51 +0300 (MSK)
Date:   Tue, 13 Apr 2021 14:55:04 +0300
From:   Balaev Pavel <balaevpa@infotecs.ru>
To:     <netdev@vger.kernel.org>
CC:     <christophe.jaillet@wanadoo.fr>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>
Subject: [PATCH v3 net-next] net: multipath routing: configurable seed
Message-ID: <YHWGmPmvpQAT3BcV@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [11.0.8.107]
X-EXCLAIMER-MD-CONFIG: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 163055 [Apr 13 2021]
X-KLMS-AntiSpam-Version: 5.9.20.0
X-KLMS-AntiSpam-Envelope-From: BalaevPA@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09, {Tracking_from_domain_doesnt_match_to}
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2021/04/13 07:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/13 08:22:00 #16588500
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ability for a user to assign seed value to multipath route hashes.
Now kernel uses random seed value to prevent hash-flooding DoS attacks;
however, it disables some use cases, f.e:

+-------+        +------+        +--------+
|       |-eth0---| FW0  |---eth0-|        |
|       |        +------+        |        |
|  GW0  |ECMP                ECMP|  GW1   |
|       |        +------+        |        |
|       |-eth1---| FW1  |---eth1-|        |
+-------+        +------+        +--------+

In this use case, two ECMP routers balance traffic between
two firewalls. If some flow transmits a response over a different channel than request,
such flow will be dropped, because keep-state rules are created on
the other firewall.

This patch adds sysctl variable: net.ipv4.fib_multipath_hash_seed.
User can set the same seed value on GW0 and GW1 for traffic to be
mirror-balanced. By default, random value is used.

Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
---
 Documentation/networking/ip-sysctl.rst |  14 ++++
 include/net/flow_dissector.h           |   4 +
 include/net/netns/ipv4.h               |  20 +++++
 net/core/flow_dissector.c              |   9 +++
 net/ipv4/af_inet.c                     |   5 ++
 net/ipv4/route.c                       |  10 ++-
 net/ipv4/sysctl_net_ipv4.c             | 104 +++++++++++++++++++++++++
 7 files changed, 165 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 9701906f6..d1a67e6fe 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -100,6 +100,20 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4
 	- 2 - Layer 3 or inner Layer 3 if present
 
+fib_multipath_hash_seed - STRING
+	Controls seed value for multipath route hashes. By default
+	random value is used. Only valid for kernels built with
+	CONFIG_IP_ROUTE_MULTIPATH enabled.
+
+	Valid format: two hex values set off with comma or "random"
+	keyword.
+
+	Example to generate the seed value::
+
+		RAND=$(openssl rand -hex 16) && echo "${RAND:0:16},${RAND:16:16}"
+
+	Default: "random"
+
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
 	synchronize_rcu is forced.
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ffd386ea0..2bd4e28de 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -348,6 +348,10 @@ static inline bool flow_keys_have_l4(const struct flow_keys *keys)
 }
 
 u32 flow_hash_from_keys(struct flow_keys *keys);
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
+			   const siphash_key_t *seed);
+#endif /* CONFIG_IP_ROUTE_MULTIPATH */
 void skb_flow_get_icmp_tci(const struct sk_buff *skb,
 			   struct flow_dissector_key_icmp *key_icmp,
 			   const void *data, int thoff, int hlen);
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 87e161249..70a01817e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -11,6 +11,14 @@
 #include <linux/rcupdate.h>
 #include <linux/siphash.h>
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+/* Multipath seed key context */
+struct multipath_seed_ctx {
+	siphash_key_t	seed;
+	struct rcu_head	rcu;
+};
+#endif
+
 struct ctl_table_header;
 struct ipv4_devconf;
 struct fib_rules_ops;
@@ -222,6 +230,9 @@ struct netns_ipv4 {
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	u8 sysctl_fib_multipath_use_neigh;
 	u8 sysctl_fib_multipath_hash_policy;
+	int sysctl_fib_multipath_hash_seed;
+	struct multipath_seed_ctx __rcu *fib_multipath_hash_seed_ctx;
+	spinlock_t fib_multipath_hash_seed_ctx_lock;
 #endif
 
 	struct fib_notifier_ops	*notifier_ops;
@@ -233,4 +244,13 @@ struct netns_ipv4 {
 	atomic_t	rt_genid;
 	siphash_key_t	ip_id_key;
 };
+
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+/* Caller needs to wrap with rcu_read_(un)lock() */
+static inline
+struct multipath_seed_ctx *fib_multipath_seed_get_ctx(const struct netns_ipv4 *ipv4)
+{
+	return rcu_dereference(ipv4->fib_multipath_hash_seed_ctx);
+}
+#endif
 #endif
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5985029e4..457dfdab8 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1560,6 +1560,15 @@ u32 flow_hash_from_keys(struct flow_keys *keys)
 }
 EXPORT_SYMBOL(flow_hash_from_keys);
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
+					const siphash_key_t *seed)
+{
+	return __flow_hash_from_keys(keys, seed);
+}
+EXPORT_SYMBOL(flow_multipath_hash_from_keys);
+#endif /* CONFIG_IP_ROUTE_MULTIPATH */
+
 static inline u32 ___skb_get_hash(const struct sk_buff *skb,
 				  struct flow_keys *keys,
 				  const siphash_key_t *keyval)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f17870ee5..fd4c68966 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1874,6 +1874,11 @@ static __net_init int inet_init_net(struct net *net)
 
 	net->ipv4.sysctl_fib_notify_on_flag_change = 0;
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	net->ipv4.fib_multipath_hash_seed_ctx = NULL;
+	spin_lock_init(&net->ipv4.fib_multipath_hash_seed_ctx_lock);
+#endif
+
 	return 0;
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f6787c55f..36f72738d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1911,6 +1911,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
 {
 	u32 multipath_hash = fl4 ? fl4->flowi4_multipath_hash : 0;
+	struct multipath_seed_ctx *seed_ctx;
 	struct flow_keys hash_keys;
 	u32 mhash;
 
@@ -1989,7 +1990,14 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		}
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
+
+	rcu_read_lock();
+	seed_ctx = fib_multipath_seed_get_ctx(&net->ipv4);
+	if (seed_ctx)
+		mhash = flow_multipath_hash_from_keys(&hash_keys, &seed_ctx->seed);
+	else
+		mhash = flow_hash_from_keys(&hash_keys);
+	rcu_read_unlock();
 
 	if (multipath_hash)
 		mhash = jhash_2words(mhash, multipath_hash, 0);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a09e466ce..38ae8afc0 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -447,6 +447,8 @@ static int proc_tcp_available_ulp(struct ctl_table *ctl,
 }
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
+#define FIB_MULTIPATH_SEED_KEY_LENGTH sizeof(siphash_key_t)
+#define FIB_MULTIPATH_SEED_RANDOM "random"
 static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp,
 					  loff_t *ppos)
@@ -461,6 +463,100 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 
 	return ret;
 }
+
+static void fib_multipath_seed_ctx_free(struct rcu_head *head)
+{
+	struct multipath_seed_ctx *ctx =
+	    container_of(head, struct multipath_seed_ctx, rcu);
+
+	kfree_sensitive(ctx);
+}
+
+static int proc_fib_multipath_hash_seed(struct ctl_table *table, int write,
+					  void *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+	    ipv4.sysctl_fib_multipath_hash_seed);
+	/* maxlen to print the keys in hex (*2) and a comma in between keys. */
+	struct ctl_table tbl = {
+		.maxlen = ((FIB_MULTIPATH_SEED_KEY_LENGTH * 2) + 2)
+	};
+	siphash_key_t user_key;
+	__le64 key[2];
+	int ret;
+	struct multipath_seed_ctx *ctx;
+
+	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
+
+	if (!tbl.data)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(net->ipv4.fib_multipath_hash_seed_ctx);
+	if (ctx) {
+		put_unaligned_le64(ctx->seed.key[0], &key[0]);
+		put_unaligned_le64(ctx->seed.key[1], &key[1]);
+		user_key.key[0] = le64_to_cpu(key[0]);
+		user_key.key[1] = le64_to_cpu(key[1]);
+
+		snprintf(tbl.data, tbl.maxlen, "%016llx,%016llx",
+				user_key.key[0], user_key.key[1]);
+	} else {
+		snprintf(tbl.data, tbl.maxlen, "%s", FIB_MULTIPATH_SEED_RANDOM);
+	}
+	rcu_read_unlock();
+
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+
+	if (write && ret == 0) {
+		struct multipath_seed_ctx *new_ctx, *old_ctx;
+
+		if (!strcmp(tbl.data, FIB_MULTIPATH_SEED_RANDOM)) {
+			spin_lock(&net->ipv4.fib_multipath_hash_seed_ctx_lock);
+			old_ctx = rcu_dereference_protected(net->ipv4.fib_multipath_hash_seed_ctx,
+					lockdep_is_held(&net->ipv4.fib_multipath_hash_seed_ctx_lock));
+			RCU_INIT_POINTER(net->ipv4.fib_multipath_hash_seed_ctx, NULL);
+			spin_unlock(&net->ipv4.fib_multipath_hash_seed_ctx_lock);
+			if (old_ctx)
+				call_rcu(&old_ctx->rcu, fib_multipath_seed_ctx_free);
+
+			pr_debug("multipath hash seed set to random value\n");
+			goto out;
+		}
+
+		if (sscanf(tbl.data, "%llx,%llx", user_key.key, user_key.key + 1) != 2) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		key[0] = cpu_to_le64(user_key.key[0]);
+		key[1] = cpu_to_le64(user_key.key[1]);
+		pr_debug("multipath hash seed set to 0x%llx,0x%llx\n",
+				user_key.key[0], user_key.key[1]);
+
+		new_ctx = kmalloc(sizeof(*new_ctx), GFP_KERNEL);
+		if (!new_ctx) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		new_ctx->seed.key[0] = get_unaligned_le64(&key[0]);
+		new_ctx->seed.key[1] = get_unaligned_le64(&key[1]);
+
+		spin_lock(&net->ipv4.fib_multipath_hash_seed_ctx_lock);
+		old_ctx = rcu_dereference_protected(net->ipv4.fib_multipath_hash_seed_ctx,
+				lockdep_is_held(&net->ipv4.fib_multipath_hash_seed_ctx_lock));
+		rcu_assign_pointer(net->ipv4.fib_multipath_hash_seed_ctx, new_ctx);
+		spin_unlock(&net->ipv4.fib_multipath_hash_seed_ctx_lock);
+		if (old_ctx)
+			call_rcu(&old_ctx->rcu, fib_multipath_seed_ctx_free);
+	}
+
+out:
+	kfree(tbl.data);
+	return ret;
+}
 #endif
 
 static struct ctl_table ipv4_table[] = {
@@ -1052,6 +1148,14 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_seed",
+		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_seed,
+		/* maxlen to print the keys in hex (*2) and a comma in between keys. */
+		.maxlen		= (FIB_MULTIPATH_SEED_KEY_LENGTH * 2) + 2,
+		.mode		= 0600,
+		.proc_handler	= proc_fib_multipath_hash_seed,
+	},
 #endif
 	{
 		.procname	= "ip_unprivileged_port_start",
-- 
2.31.1

