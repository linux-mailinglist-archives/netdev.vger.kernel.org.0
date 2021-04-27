Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF836C8C4
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhD0Phx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:37:53 -0400
Received: from mx0.infotecs.ru ([91.244.183.115]:51114 "EHLO mx0.infotecs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhD0Phw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:37:52 -0400
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id BC4D5108A044;
        Tue, 27 Apr 2021 18:37:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru BC4D5108A044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1619537827; bh=UqwBPc+Ku2u8METgKn8mKgjMPuYW7uTvL3NIL2o22UQ=;
        h=Date:From:To:CC:Subject:From;
        b=XswCLT7roSKiKss+JZssSYt9jufbzvAfahF8SpPXPuzBZ8X9A/goNOk1WZ+9YcHcS
         4jCpRVi1YJkPvCu2tULAuxjVy4Jwt4ovWXxRd+lV8Rz9GMI3zvDyJnKHHdnOwhJ/gh
         8GYy3D69ePh/S3zdWEaH1SR5SCGve0BrQyrbvpc4=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id BA3B2316F917;
        Tue, 27 Apr 2021 18:37:07 +0300 (MSK)
Date:   Tue, 27 Apr 2021 18:35:18 +0300
From:   Balaev Pavel <balaevpa@infotecs.ru>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v5 net-next 1/3] net/ipv4: multipath routing: configurable
 seed
Message-ID: <YIgvNjnFUynNMUGO@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [11.0.8.107]
X-EXCLAIMER-MD-CONFIG: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 163354 [Apr 27 2021]
X-KLMS-AntiSpam-Version: 5.9.20.0
X-KLMS-AntiSpam-Envelope-From: BalaevPA@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0, {Tracking_from_domain_doesnt_match_to}
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2021/04/27 12:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/27 11:47:00 #16580367
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

This patch adds sysctl variable: net.ipv4.fib_multipath_hash_seed.
User can set the same seed value on GW0 and GW1 for traffic to be
mirror-balanced. By default, random value is used.

Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
---
 Documentation/networking/ip-sysctl.rst | 14 ++++
 include/net/flow_dissector.h           |  2 +
 include/net/netns/ipv4.h               |  2 +
 net/core/flow_dissector.c              |  7 ++
 net/ipv4/route.c                       | 10 ++-
 net/ipv4/sysctl_net_ipv4.c             | 97 ++++++++++++++++++++++++++
 6 files changed, 131 insertions(+), 1 deletion(-)

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
index ffd386ea0..d104c013a 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -348,6 +348,8 @@ static inline bool flow_keys_have_l4(const struct flow_keys *keys)
 }
 
 u32 flow_hash_from_keys(struct flow_keys *keys);
+u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
+			   const siphash_key_t *seed);
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
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5985029e4..febd1094c 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1560,6 +1560,13 @@ u32 flow_hash_from_keys(struct flow_keys *keys)
 }
 EXPORT_SYMBOL(flow_hash_from_keys);
 
+u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
+				  const siphash_key_t *seed)
+{
+	return __flow_hash_from_keys(keys, seed);
+}
+EXPORT_SYMBOL(flow_multipath_hash_from_keys);
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
-- 
2.31.1

