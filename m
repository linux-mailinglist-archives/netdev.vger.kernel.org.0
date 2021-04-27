Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74E536C8CA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhD0Pim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:38:42 -0400
Received: from mx0.infotecs.ru ([91.244.183.115]:41332 "EHLO mx0.infotecs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhD0Pil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:38:41 -0400
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 24E4C108A044;
        Tue, 27 Apr 2021 18:37:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 24E4C108A044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1619537876; bh=KS/M+VGEGuADqGAwb+xtHHF5/l2ZVT8iDvov9Ti3/js=;
        h=Date:From:To:CC:Subject:From;
        b=tpVyI1TYB5I+pUtLXfJoRguRPMLvLbdyYyrDCRI+qjIqyjjdp2F45ZIhluDiClqo0
         xkyfz9Cs1U6+YiWFVd+yW1IBU5hnabM3F9Cg6Y7S1dmFifUMhWad9LikaVBfM/9IFK
         cIxSO9Yw1Jb4LX2m+yi1MGJ3AVzO+08BzZVd16W0=
Received: from msk-exch-02.infotecs-nt (autodiscover.amonitoring.ru [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id 227983029CD2;
        Tue, 27 Apr 2021 18:37:56 +0300 (MSK)
Date:   Tue, 27 Apr 2021 18:36:06 +0300
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
Subject: [PATCH v5 net-next 2/3] net/ipv6: multipath routing: configurable
 seed
Message-ID: <YIgvZoZwBxqawnzm@rnd>
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

Ability for a user to assign seed value to IPv6 multipath route hashes.
This patch adds sysctl variable: net.ipv6.fib_multipath_hash_seed.

Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
---
 include/net/netns/ipv6.h   |  3 ++
 net/ipv6/route.c           | 10 +++-
 net/ipv6/sysctl_net_ipv6.c | 96 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 1 deletion(-)

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
-- 
2.31.1

