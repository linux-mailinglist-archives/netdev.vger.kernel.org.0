Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D07C3693FB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbhDWNrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:47:01 -0400
Received: from mx0.infotecs.ru ([91.244.183.115]:41062 "EHLO mx0.infotecs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236992AbhDWNq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 09:46:58 -0400
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id DC5C113664AA;
        Fri, 23 Apr 2021 16:46:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru DC5C113664AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1619185579; bh=6IhskHPOa38m/wTimNy1e3XCr+DowJ6QgTpDqrfWMrY=;
        h=Date:From:To:CC:Subject:From;
        b=biJ/P2kxCinyLIVSEHyK9mwiPLXyf7E9VVFYOAVvdVbMue7UfM4caCgwlR2xC5/bc
         begBC3HF/yNTM6vpXA2Dw1shK6tgSkKCZDQW9tujDZZqY3mYa2tXI7pqoOoginUSlM
         szcLhdnAB1EVgJmsxD/sWAVdfIksdh/E/TZZjtYg=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id D99BB316A6CA;
        Fri, 23 Apr 2021 16:46:18 +0300 (MSK)
Date:   Fri, 23 Apr 2021 16:44:28 +0300
From:   Balaev Pavel <balaevpa@infotecs.ru>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 net-next] net: multipath routing: configurable seed
Message-ID: <YILPPCyMjlnhPmEN@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [11.0.8.107]
X-EXCLAIMER-MD-CONFIG: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 163309 [Apr 23 2021]
X-KLMS-AntiSpam-Version: 5.9.20.0
X-KLMS-AntiSpam-Envelope-From: BalaevPA@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0, {Tracking_from_domain_doesnt_match_to}
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2021/04/23 12:17:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/23 11:06:00 #16598430
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

In this use case, two ECMP routers balance traffic between two firewalls.
If some flow transmits a response over a different channel than request,
such flow will be dropped, because keep-state rules are created on
the other firewall.

This patch adds sysctl variable: net.ipv4|ipv6.fib_multipath_hash_seed.
User can set the same seed value on GW0 and GW1 for traffic to be
mirror-balanced. By default, random value is used.

Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
---
 Documentation/networking/ip-sysctl.rst        |  14 +
 include/net/flow_dissector.h                  |   4 +
 include/net/netns/ipv4.h                      |   2 +
 include/net/netns/ipv6.h                      |   3 +
 net/core/flow_dissector.c                     |   9 +
 net/ipv4/route.c                              |  10 +-
 net/ipv4/sysctl_net_ipv4.c                    |  97 +++++
 net/ipv6/route.c                              |  10 +-
 net/ipv6/sysctl_net_ipv6.c                    |  96 +++++
 .../testing/selftests/net/forwarding/Makefile |   1 +
 tools/testing/selftests/net/forwarding/lib.sh |  41 +++
 .../net/forwarding/router_mpath_seed.sh       | 347 ++++++++++++++++++
 12 files changed, 632 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_seed.sh

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
index 87e161249..cb2830432 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -222,6 +222,8 @@ struct netns_ipv4 {
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	u8 sysctl_fib_multipath_use_neigh;
 	u8 sysctl_fib_multipath_hash_policy;
+	int sysctl_fib_multipath_hash_seed;
+	siphash_key_t __rcu *fib_multipath_hash_seed_ctx;
 #endif
 
 	struct fib_notifier_ops	*notifier_ops;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 808f0f79e..6bb383b0a 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -8,6 +8,7 @@
 #ifndef __NETNS_IPV6_H__
 #define __NETNS_IPV6_H__
 #include <net/dst_ops.h>
+#include <linux/siphash.h>
 #include <uapi/linux/icmpv6.h>
 
 struct ctl_table_header;
@@ -30,6 +31,7 @@ struct netns_sysctl_ipv6 {
 	int ip6_rt_min_advmss;
 	u8 bindv6only;
 	u8 multipath_hash_policy;
+	u8 multipath_hash_seed;
 	u8 flowlabel_consistency;
 	u8 auto_flowlabels;
 	int icmpv6_time;
@@ -107,6 +109,7 @@ struct netns_ipv6 {
 	struct fib_rules_ops	*mr6_rules_ops;
 #endif
 #endif
+	siphash_key_t __rcu	*multipath_hash_seed_ctx;
 	atomic_t		dev_addr_genid;
 	atomic_t		fib6_sernum;
 	struct seg6_pernet_data *seg6_data;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5985029e4..c9b53cb2b 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1560,6 +1560,15 @@ u32 flow_hash_from_keys(struct flow_keys *keys)
 }
 EXPORT_SYMBOL(flow_hash_from_keys);
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
+				  const siphash_key_t *seed)
+{
+	return __flow_hash_from_keys(keys, seed);
+}
+EXPORT_SYMBOL(flow_multipath_hash_from_keys);
+#endif /* CONFIG_IP_ROUTE_MULTIPATH */
+
 static inline u32 ___skb_get_hash(const struct sk_buff *skb,
 				  struct flow_keys *keys,
 				  const siphash_key_t *keyval)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f6787c55f..79866b429 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1912,6 +1912,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 {
 	u32 multipath_hash = fl4 ? fl4->flowi4_multipath_hash : 0;
 	struct flow_keys hash_keys;
+	siphash_key_t *seed_ctx;
 	u32 mhash;
 
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
@@ -1989,7 +1990,14 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		}
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
+
+	rcu_read_lock();
+	seed_ctx = rcu_dereference(net->ipv4.fib_multipath_hash_seed_ctx);
+	if (seed_ctx)
+		mhash = flow_multipath_hash_from_keys(&hash_keys, seed_ctx);
+	else
+		mhash = flow_hash_from_keys(&hash_keys);
+	rcu_read_unlock();
 
 	if (multipath_hash)
 		mhash = jhash_2words(mhash, multipath_hash, 0);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a09e466ce..5dff59733 100644
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
@@ -461,6 +463,93 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 
 	return ret;
 }
+
+static int proc_fib_multipath_hash_seed(struct ctl_table *table, int write,
+					void *buffer, size_t *lenp,
+					loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+	    ipv4.sysctl_fib_multipath_hash_seed);
+	/* maxlen to print the keys in hex (*2) and a comma in between keys. */
+	struct ctl_table tbl = {
+		.maxlen = ((FIB_MULTIPATH_SEED_KEY_LENGTH * 2) + 2)
+	};
+	siphash_key_t user_key, *ctx;
+	__le64 key[2];
+	int ret;
+
+	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
+
+	if (!tbl.data)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(net->ipv4.fib_multipath_hash_seed_ctx);
+	if (ctx) {
+		put_unaligned_le64(ctx->key[0], &key[0]);
+		put_unaligned_le64(ctx->key[1], &key[1]);
+		user_key.key[0] = le64_to_cpu(key[0]);
+		user_key.key[1] = le64_to_cpu(key[1]);
+
+		snprintf(tbl.data, tbl.maxlen, "%016llx,%016llx",
+			 user_key.key[0], user_key.key[1]);
+	} else {
+		snprintf(tbl.data, tbl.maxlen, "%s", FIB_MULTIPATH_SEED_RANDOM);
+	}
+	rcu_read_unlock();
+
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+
+	if (write && ret == 0) {
+		siphash_key_t *new_ctx, *old_ctx;
+
+		if (!strcmp(tbl.data, FIB_MULTIPATH_SEED_RANDOM)) {
+			rtnl_lock();
+			old_ctx = rtnl_dereference(net->ipv4.fib_multipath_hash_seed_ctx);
+			RCU_INIT_POINTER(net->ipv4.fib_multipath_hash_seed_ctx, NULL);
+			rtnl_unlock();
+			if (old_ctx) {
+				synchronize_net();
+				kfree_sensitive(old_ctx);
+			}
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
+			 user_key.key[0], user_key.key[1]);
+
+		new_ctx = kmalloc(sizeof(*new_ctx), GFP_KERNEL);
+		if (!new_ctx) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		new_ctx->key[0] = get_unaligned_le64(&key[0]);
+		new_ctx->key[1] = get_unaligned_le64(&key[1]);
+
+		rtnl_lock();
+		old_ctx = rtnl_dereference(net->ipv4.fib_multipath_hash_seed_ctx);
+		rcu_assign_pointer(net->ipv4.fib_multipath_hash_seed_ctx, new_ctx);
+		rtnl_unlock();
+		if (old_ctx) {
+			synchronize_net();
+			kfree_sensitive(old_ctx);
+		}
+	}
+
+out:
+	kfree(tbl.data);
+	return ret;
+}
 #endif
 
 static struct ctl_table ipv4_table[] = {
@@ -1052,6 +1141,14 @@ static struct ctl_table ipv4_net_table[] = {
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
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 28801ae80..70c488812 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2331,6 +2331,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
 {
 	struct flow_keys hash_keys;
+	siphash_key_t *seed_ctx;
 	u32 mhash;
 
 	switch (ip6_multipath_hash_policy(net)) {
@@ -2414,7 +2415,14 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		}
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
+
+	rcu_read_lock();
+	seed_ctx = rcu_dereference(net->ipv6.multipath_hash_seed_ctx);
+	if (seed_ctx)
+		mhash = flow_multipath_hash_from_keys(&hash_keys, seed_ctx);
+	else
+		mhash = flow_hash_from_keys(&hash_keys);
+	rcu_read_unlock();
 
 	return mhash >> 1;
 }
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 27102c3d6..349251cb7 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -40,6 +40,94 @@ static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 	return ret;
 }
 
+#define RT6_MULTIPATH_SEED_KEY_LENGTH sizeof(siphash_key_t)
+#define RT6_MULTIPATH_SEED_RANDOM "random"
+static int proc_rt6_multipath_hash_seed(struct ctl_table *table, int write,
+					void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+	    ipv6.sysctl.multipath_hash_seed);
+	/* maxlen to print the keys in hex (*2) and a comma in between keys. */
+	struct ctl_table tbl = {
+		.maxlen = ((RT6_MULTIPATH_SEED_KEY_LENGTH * 2) + 2)
+	};
+	siphash_key_t user_key, *ctx;
+	__le64 key[2];
+	int ret;
+
+	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
+
+	if (!tbl.data)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(net->ipv6.multipath_hash_seed_ctx);
+	if (ctx) {
+		put_unaligned_le64(ctx->key[0], &key[0]);
+		put_unaligned_le64(ctx->key[1], &key[1]);
+		user_key.key[0] = le64_to_cpu(key[0]);
+		user_key.key[1] = le64_to_cpu(key[1]);
+
+		snprintf(tbl.data, tbl.maxlen, "%016llx,%016llx",
+			 user_key.key[0], user_key.key[1]);
+	} else {
+		snprintf(tbl.data, tbl.maxlen, "%s", RT6_MULTIPATH_SEED_RANDOM);
+	}
+	rcu_read_unlock();
+
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+
+	if (write && ret == 0) {
+		siphash_key_t *new_ctx, *old_ctx;
+
+		if (!strcmp(tbl.data, RT6_MULTIPATH_SEED_RANDOM)) {
+			rtnl_lock();
+			old_ctx = rtnl_dereference(net->ipv6.multipath_hash_seed_ctx);
+			RCU_INIT_POINTER(net->ipv6.multipath_hash_seed_ctx, NULL);
+			rtnl_unlock();
+			if (old_ctx) {
+				synchronize_net();
+				kfree_sensitive(old_ctx);
+			}
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
+			 user_key.key[0], user_key.key[1]);
+
+		new_ctx = kmalloc(sizeof(*new_ctx), GFP_KERNEL);
+		if (!new_ctx) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		new_ctx->key[0] = get_unaligned_le64(&key[0]);
+		new_ctx->key[1] = get_unaligned_le64(&key[1]);
+
+		rtnl_lock();
+		old_ctx = rtnl_dereference(net->ipv6.multipath_hash_seed_ctx);
+		rcu_assign_pointer(net->ipv6.multipath_hash_seed_ctx, new_ctx);
+		rtnl_unlock();
+		if (old_ctx) {
+			synchronize_net();
+			kfree_sensitive(old_ctx);
+		}
+	}
+
+out:
+	kfree(tbl.data);
+	return ret;
+}
+
 static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "bindv6only",
@@ -151,6 +239,14 @@ static struct ctl_table ipv6_table_template[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_seed",
+		.data		= &init_net.ipv6.sysctl.multipath_hash_seed,
+		/* maxlen to print the keys in hex (*2) and a comma in between keys. */
+		.maxlen		= (RT6_MULTIPATH_SEED_KEY_LENGTH * 2) + 2,
+		.mode		= 0600,
+		.proc_handler	= proc_rt6_multipath_hash_seed,
+	},
 	{
 		.procname	= "seg6_flowlabel",
 		.data		= &init_net.ipv6.sysctl.seg6_flowlabel,
diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index d97bd6889..080af970c 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -38,6 +38,7 @@ TEST_PROGS = bridge_igmp.sh \
 	router_mpath_nh.sh \
 	router_multicast.sh \
 	router_multipath.sh \
+	router_mpath_seed.sh \
 	router.sh \
 	router_vid_1.sh \
 	sch_ets.sh \
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 42e28c983..15d5b8bfa 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -10,6 +10,7 @@ PING6=${PING6:=ping6}
 MZ=${MZ:=mausezahn}
 ARPING=${ARPING:=arping}
 TEAMD=${TEAMD:=teamd}
+OPENSSL=${OPENSSL:=openssl}
 WAIT_TIME=${WAIT_TIME:=5}
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 PAUSE_ON_CLEANUP=${PAUSE_ON_CLEANUP:=no}
@@ -693,11 +694,51 @@ link_stats_tx_packets_get()
 	link_stats_get $1 tx packets
 }
 
+link_stats_tx_packets_get()
+{
+	link_stats_get $1 tx packets
+}
+
 link_stats_rx_errors_get()
 {
 	link_stats_get $1 rx errors
 }
 
+ns_link_stats_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+	local dir=$1; shift
+	local stat=$1; shift
+
+	ip netns exec $netns ip -j -s link show dev $if_name \
+		| jq '.[]["stats64"]["'$dir'"]["'$stat'"]'
+}
+
+ns_link_stats_tx_packets_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+
+	ns_link_stats_get $netns $if_name tx packets
+}
+
+ns_link_stats_tx_packets_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+
+	ns_link_stats_get $netns $if_name tx packets
+}
+
+ns_link_stats_rx_errors_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+
+	ns_link_stats_get $netns $if_name rx errors
+}
+
 tc_rule_stats_get()
 {
 	local dev=$1; shift
diff --git a/tools/testing/selftests/net/forwarding/router_mpath_seed.sh b/tools/testing/selftests/net/forwarding/router_mpath_seed.sh
new file mode 100755
index 000000000..b2f99f428
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/router_mpath_seed.sh
@@ -0,0 +1,347 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="multipath_seed_test"
+NUM_NETIFS=8
+source lib.sh
+
+veth_prepare()
+{
+	ip link add ecmp1l type veth peer name ecmp1r
+	ip link add ecmp2l type veth peer name ecmp2r
+	ip link add ecmphost1l type veth peer name ecmphost1r
+	ip link add ecmphost2l type veth peer name ecmphost2r
+}
+
+cl1_create()
+{
+	local ns_exec="ip netns exec ecmp_cl1"
+
+	ip netns add ecmp_cl1
+	ip l set dev ecmphost1l netns ecmp_cl1
+	$ns_exec ip l set dev ecmphost1l up
+	$ns_exec ip a a 10.100.0.2/30 dev ecmphost1l
+	$ns_exec ip a a 2001:db8:3::2/64 dev ecmphost1l
+	$ns_exec ip r add default via 10.100.0.1
+	$ns_exec ip r add default via 2001:db8:3::1
+}
+
+cl2_create()
+{
+	local ns_exec="ip netns exec ecmp_cl2"
+
+	ip netns add ecmp_cl2
+	ip l set dev ecmphost2l netns ecmp_cl2
+	$ns_exec ip l set dev ecmphost2l up
+	$ns_exec ip a a 10.200.0.2/30 dev ecmphost2l
+	$ns_exec ip a a 2001:db8:4::2/64 dev ecmphost2l
+	$ns_exec ip r add default via 10.200.0.1
+	$ns_exec ip r add default via 2001:db8:4::1
+}
+
+r1_create()
+{
+	local ns_exec="ip netns exec ecmp1"
+
+	ip netns add ecmp1
+	ip l set dev ecmp1l netns ecmp1
+	ip l set dev ecmp2l netns ecmp1
+	ip l set dev ecmphost1r netns ecmp1
+	$ns_exec ip l set dev ecmphost1r up
+	$ns_exec ip l set dev ecmp1l up
+	$ns_exec ip l set dev ecmp2l up
+	$ns_exec ip a a 10.100.0.1/30 dev ecmphost1r
+	$ns_exec ip a a 10.10.0.1/30 dev ecmp1l
+	$ns_exec ip a a 10.20.0.1/30 dev ecmp2l
+	$ns_exec ip a a 2001:db8:3::1/64 dev ecmphost1r
+	$ns_exec ip a a 2001:db8:1::1/64 dev ecmp1l
+	$ns_exec ip a a 2001:db8:2::1/64 dev ecmp2l
+	$ns_exec sysctl -q net.ipv4.ip_forward=1
+	$ns_exec sysctl -q net.ipv6.conf.all.forwarding=1
+	$ns_exec sysctl -q net.ipv4.fib_multipath_hash_policy=1
+	$ns_exec sysctl -q net.ipv6.fib_multipath_hash_policy=1
+	$ns_exec ip route add 10.200.0.0/30 nexthop via 10.10.0.2 \
+		  weight 1 nexthop via 10.20.0.2 weight 1
+	$ns_exec ip route add 2001:db8:4::/64 nexthop via 2001:db8:1::2 \
+		  weight 1 nexthop via 2001:db8:2::2 weight 1
+}
+
+r2_create()
+{
+	local ns_exec="ip netns exec ecmp2"
+
+	ip netns add ecmp2
+	ip l set dev ecmp1r netns ecmp2
+	ip l set dev ecmp2r netns ecmp2
+	ip l set dev ecmphost2r netns ecmp2
+	$ns_exec ip l set dev ecmphost2r up
+	$ns_exec ip l set dev ecmp1r up
+	$ns_exec ip l set dev ecmp2r up
+	$ns_exec ip a a 10.200.0.1/30 dev ecmphost2r
+	$ns_exec ip a a 10.10.0.2/30 dev ecmp1r
+	$ns_exec ip a a 10.20.0.2/30 dev ecmp2r
+	$ns_exec ip a a 2001:db8:4::1/64 dev ecmphost2r
+	$ns_exec ip a a 2001:db8:1::2/64 dev ecmp1r
+	$ns_exec ip a a 2001:db8:2::2/64 dev ecmp2r
+	$ns_exec sysctl -q net.ipv4.ip_forward=1
+	$ns_exec sysctl -q net.ipv6.conf.all.forwarding=1
+	$ns_exec sysctl -q net.ipv4.fib_multipath_hash_policy=1
+	$ns_exec sysctl -q net.ipv6.fib_multipath_hash_policy=1
+	$ns_exec ip route add 10.100.0.0/30 nexthop via 10.10.0.1 \
+		  weight 1 nexthop via 10.20.0.1 weight 1
+	$ns_exec ip route add 2001:db8:3::/64 nexthop via 2001:db8:1::1 \
+		  weight 1 nexthop via 2001:db8:2::1 weight 1
+}
+
+cl1_destroy()
+{
+	ip netns del ecmp_cl1
+}
+
+cl2_destroy()
+{
+	ip netns del ecmp_cl2
+}
+
+r1_destroy()
+{
+	ip netns del ecmp1
+}
+
+r2_destroy()
+{
+	ip netns del ecmp2
+}
+
+gen_udp4()
+{
+	local sp=$1; shift
+	local dp=$1; shift
+	local tx1_1_start tx1_2_start tx2_1_start tx2_2_start
+	local tx1_1_end tx1_2_end tx2_1_end tx2_2_end
+	local tx1_1 tx1_2 tx2_1 tx2_2
+	local tx1_1_res tx1_2_res tx2_1_res tx2_2_res
+	local chan1 chan2
+	local cl1_exec="ip netns exec ecmp_cl1"
+	local cl2_exec="ip netns exec ecmp_cl2"
+
+	tx1_1_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	$cl1_exec $MZ ecmphost1l -q -c 20 -p 64 -A 10.100.0.2 -B 10.200.0.2 \
+		-t udp "sp=${sp},dp=${dp}"
+
+	$cl2_exec $MZ ecmphost2l -q -c 20 -p 64 -A 10.200.0.2 -B 10.100.0.2 \
+		-t udp "sp=${dp},dp=${sp}"
+
+	tx1_1_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	let "tx1_1 = $tx1_1_end - $tx1_1_start"
+	let "tx1_2 = $tx1_2_end - $tx1_2_start"
+	let "tx2_1 = $tx2_1_end - $tx2_1_start"
+	let "tx2_2 = $tx2_2_end - $tx2_2_start"
+
+	[ "$tx1_1" -ge 20 ] && tx1_1_res=1 || tx1_1_res=0
+	[ "$tx1_2" -ge 20 ] && tx1_2_res=1 || tx1_2_res=0
+	[ "$tx2_1" -ge 20 ] && tx2_1_res=1 || tx2_1_res=0
+	[ "$tx2_2" -ge 20 ] && tx2_2_res=1 || tx2_2_res=0
+
+	let "chan1 = $tx1_1_res + $tx2_1_res"
+	let "chan2 = $tx1_2_res + $tx2_2_res"
+
+	if [ $chan1 -eq 2 ] || [ $chan2 -eq 2 ]; then
+		return 0
+	fi
+
+	return 1;
+}
+
+gen_udp6()
+{
+	local sp=$1; shift
+	local dp=$1; shift
+	local tx1_1_start tx1_2_start tx2_1_start tx2_2_start
+	local tx1_1_end tx1_2_end tx2_1_end tx2_2_end
+	local tx1_1 tx1_2 tx2_1 tx2_2
+	local tx1_1_res tx1_2_res tx2_1_res tx2_2_res
+	local chan1 chan2
+	local cl1_exec="ip netns exec ecmp_cl1"
+	local cl2_exec="ip netns exec ecmp_cl2"
+
+	tx1_1_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	$cl1_exec $MZ ecmphost1l -6 -q -c 20 -p 64 -A 2001:db8:3::2 -B 2001:db8:4::2 \
+		-t udp "sp=${sp},dp=${dp}"
+
+	$cl2_exec $MZ ecmphost2l -6 -q -c 20 -p 64 -A 2001:db8:4::2 -B 2001:db8:3::2 \
+		-t udp "sp=${dp},dp=${sp}"
+
+	tx1_1_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	let "tx1_1 = $tx1_1_end - $tx1_1_start"
+	let "tx1_2 = $tx1_2_end - $tx1_2_start"
+	let "tx2_1 = $tx2_1_end - $tx2_1_start"
+	let "tx2_2 = $tx2_2_end - $tx2_2_start"
+
+	[ "$tx1_1" -ge 20 ] && tx1_1_res=1 || tx1_1_res=0
+	[ "$tx1_2" -ge 20 ] && tx1_2_res=1 || tx1_2_res=0
+	[ "$tx2_1" -ge 20 ] && tx2_1_res=1 || tx2_1_res=0
+	[ "$tx2_2" -ge 20 ] && tx2_2_res=1 || tx2_2_res=0
+
+	let "chan1 = $tx1_1_res + $tx2_1_res"
+	let "chan2 = $tx1_2_res + $tx2_2_res"
+
+	if [ $chan1 -eq 2 ] || [ $chan2 -eq 2 ]; then
+		return 0
+	fi
+
+	return 1;
+}
+
+
+seed4_test_equal()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed=$(${OPENSSL} rand -hex 16)
+
+	seed=${seed:0:16},${seed:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp4 $sp $dp && let res++
+	done
+
+	[ $res != 30 ] && RET=1
+	log_test "IPv4 multipath seed tests [equal seed]"
+}
+
+seed4_test_diff()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed1=$(${OPENSSL} rand -hex 16)
+	local seed2=$(${OPENSSL} rand -hex 16)
+
+	seed1=${seed1:0:16},${seed1:16:16}
+	seed2=${seed2:0:16},${seed2:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed1}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed2}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp4 $sp $dp && let res++
+	done
+
+	[ $res -eq 30 ] && RET=1
+	log_test "IPv4 multipath seed tests [different seed]"
+}
+
+seed6_test_equal()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed=$(${OPENSSL} rand -hex 16)
+
+	seed=${seed:0:16},${seed:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp6 $sp $dp && let res++
+	done
+
+	[ $res != 30 ] && RET=1
+	log_test "IPv6 multipath seed tests [equal seed]"
+}
+
+seed6_test_diff()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed1=$(${OPENSSL} rand -hex 16)
+	local seed2=$(${OPENSSL} rand -hex 16)
+
+	seed1=${seed1:0:16},${seed1:16:16}
+	seed2=${seed2:0:16},${seed2:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed1}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed2}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp4 $sp $dp && let res++
+	done
+
+	[ $res -eq 30 ] && RET=1
+	log_test "IPv6 multipath seed tests [different seed]"
+}
+
+multipath_seed_test()
+{
+	require_command $OPENSSL
+	veth_prepare
+	cl1_create
+	cl2_create
+	r1_create
+	r2_create
+
+	log_info "Running IPv4 multipath seed tests [equal seed]"
+	seed4_test_equal
+	log_info "Running IPv4 multipath seed tests [different seed]"
+	seed4_test_diff
+	log_info "Running IPv6 multipath seed tests [equal seed]"
+	seed6_test_equal
+	log_info "Running IPv6 multipath seed tests [different seed]"
+	seed6_test_diff
+
+	cl1_destroy
+	cl2_destroy
+	r1_destroy
+	r2_destroy
+}
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

