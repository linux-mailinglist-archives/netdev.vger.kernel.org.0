Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0524E36D275
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbhD1Gwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:52:35 -0400
Received: from relay.sw.ru ([185.231.240.75]:48036 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236270AbhD1Gwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 02:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=kZ+0slWaAK9FBfngJ8GRZqHTcURIreN4cLH6OoR/nkc=; b=bSNOmsLq4JE5Mf56NWm
        KJUnDdSMUQVsPiw01FHmq8XToR2W6L5I3xoqZi1re3UK2eaNzacD4AXY1MV8ymO18lVu5yJ9lbMNA
        J9uiZI/CHmJjNdm7ollLlDJu8+aUtK0mtyx7PBYiXqA2ee8ieoATtXh0/e3+PoWnIkZOfsosqFQ=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lbe32-001ViL-7F; Wed, 28 Apr 2021 09:51:48 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 02/16] memcg: enable accounting for IP address and
 routing-related objects
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Message-ID: <270cd5ae-02ab-925b-a679-9b4e7a6ff76d@virtuozzo.com>
Date:   Wed, 28 Apr 2021 09:51:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netadmin inside container can use 'ip a a' and 'ip r a'
to assign a large number of ipv4/ipv6 addresses and routing entries
and force kernel to allocate megabytes of unaccounted memory
for long-lived per-netdevice related kernel objects:
'struct in_ifaddr', 'struct inet6_ifaddr', 'struct fib6_node',
'struct rt6_info', 'struct fib_rules' and ip_fib caches.

These objects can be manually removed, though usually they lives
in memory till destroy of its net namespace.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

One of such objects is the 'struct fib6_node' mostly allocated in
net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:

 write_lock_bh(&table->tb6_lock);
 err = fib6_add(&table->tb6_root, rt, info, mxc);
 write_unlock_bh(&table->tb6_lock);

In this case it is not enough to simply add SLAB_ACCOUNT to corresponding
kmem cache. The proper memory cgroup still cannot be found due to the
incorrect 'in_interrupt()' check used in memcg_kmem_bypass().

Obsoleted in_interrupt() does not describe real execution context properly.
From include/linux/preempt.h:

 The following macros are deprecated and should not be used in new code:
 in_interrupt()	- We're in NMI,IRQ,SoftIRQ context or have BH disabled

To verify the current execution context new macro should be used instead:
 in_task()	- We're in task context

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 mm/memcontrol.c      | 2 +-
 net/core/fib_rules.c | 4 ++--
 net/ipv4/devinet.c   | 2 +-
 net/ipv4/fib_trie.c  | 4 ++--
 net/ipv6/addrconf.c  | 2 +-
 net/ipv6/ip6_fib.c   | 4 ++--
 net/ipv6/route.c     | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e064ac0d..15108ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
 		return false;
 
 	/* Memcg to charge can't be determined. */
-	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
 		return true;
 
 	return false;
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index cd80ffe..65d8b1d 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -57,7 +57,7 @@ int fib_default_rule_add(struct fib_rules_ops *ops,
 {
 	struct fib_rule *r;
 
-	r = kzalloc(ops->rule_size, GFP_KERNEL);
+	r = kzalloc(ops->rule_size, GFP_KERNEL_ACCOUNT);
 	if (r == NULL)
 		return -ENOMEM;
 
@@ -541,7 +541,7 @@ static int fib_nl2rule(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto errout;
 	}
 
-	nlrule = kzalloc(ops->rule_size, GFP_KERNEL);
+	nlrule = kzalloc(ops->rule_size, GFP_KERNEL_ACCOUNT);
 	if (!nlrule) {
 		err = -ENOMEM;
 		goto errout;
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 2e35f68da..9b90413 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -215,7 +215,7 @@ static void devinet_sysctl_unregister(struct in_device *idev)
 
 static struct in_ifaddr *inet_alloc_ifa(void)
 {
-	return kzalloc(sizeof(struct in_ifaddr), GFP_KERNEL);
+	return kzalloc(sizeof(struct in_ifaddr), GFP_KERNEL_ACCOUNT);
 }
 
 static void inet_rcu_free_ifa(struct rcu_head *head)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 25cf387..8060524 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2380,11 +2380,11 @@ void __init fib_trie_init(void)
 {
 	fn_alias_kmem = kmem_cache_create("ip_fib_alias",
 					  sizeof(struct fib_alias),
-					  0, SLAB_PANIC, NULL);
+					  0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	trie_leaf_kmem = kmem_cache_create("ip_fib_trie",
 					   LEAF_SIZE,
-					   0, SLAB_PANIC, NULL);
+					   0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 }
 
 struct fib_table *fib_trie_table(u32 id, struct fib_table *alias)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a9e53f5..d56a15a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1080,7 +1080,7 @@ static int ipv6_add_addr_hash(struct net_device *dev, struct inet6_ifaddr *ifa)
 			goto out;
 	}
 
-	ifa = kzalloc(sizeof(*ifa), gfp_flags);
+	ifa = kzalloc(sizeof(*ifa), gfp_flags | __GFP_ACCOUNT);
 	if (!ifa) {
 		err = -ENOBUFS;
 		goto out;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 679699e..0982b7c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2444,8 +2444,8 @@ int __init fib6_init(void)
 	int ret = -ENOMEM;
 
 	fib6_node_kmem = kmem_cache_create("fib6_nodes",
-					   sizeof(struct fib6_node),
-					   0, SLAB_HWCACHE_ALIGN,
+					   sizeof(struct fib6_node), 0,
+					   SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
 					   NULL);
 	if (!fib6_node_kmem)
 		goto out;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 373d480..5dc5c68 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6510,7 +6510,7 @@ int __init ip6_route_init(void)
 	ret = -ENOMEM;
 	ip6_dst_ops_template.kmem_cachep =
 		kmem_cache_create("ip6_dst_cache", sizeof(struct rt6_info), 0,
-				  SLAB_HWCACHE_ALIGN, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (!ip6_dst_ops_template.kmem_cachep)
 		goto out;
 
-- 
1.8.3.1

