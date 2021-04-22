Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282FA367EC0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhDVKhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:37:01 -0400
Received: from relay.sw.ru ([185.231.240.75]:33288 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235929AbhDVKgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=/uNzShRLhHQ69G7UXwNMIX/06UqJBVaRYCXTmQImuno=; b=XDpoAeOxLPrI2LkR3Fu
        9G83a2/vJgLbX6EGQbtKqhi7/8G0ZD4k/JA/imMUFnbshBTeuoIIXLpb++pRKYPSa+5eCSg7iK1dH
        FlAE7GdTfP6Th41WH1QHqmQWI2/24SrYhBlDNKOUPsJnzCByWzp/n6xvRsWlyjVbtMHGGn1nJ+w=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lZWgw-001AL1-KQ; Thu, 22 Apr 2021 13:36:14 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 02/16] memcg: enable accounting for IP address and
 routing-related objects
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Message-ID: <73ef2dfa-0239-fd65-367e-760d10bf1a4f@virtuozzo.com>
Date:   Thu, 22 Apr 2021 13:36:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An netadmin inside container can use 'ip a a' and 'ip r a'
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

