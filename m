Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BA11BE684
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD2Sp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2Sp6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 14:45:58 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6C72064C;
        Wed, 29 Apr 2020 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588185957;
        bh=iFAMi2cdSAb35yogTnaTrmw0J8V91HH93Uf7AY1r9/I=;
        h=From:To:Cc:Subject:Date:From;
        b=pXgOqz4mPcywQA/C8iwc/6ep/CUZEJ4X89dVk9XndSwI0dVXbQdPQ6Ly4ADjUYB7N
         M6AxhGLZE3k951kmTboMnCBa8BkuhcotiQUj8FMfa/stVhmMWNF02a4K2OCHA5Eyn4
         /iagd/aRMPvRAKfH3E8lGEbQ15su/HMCSG8UqHTs=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        David Ahern <dsahern@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net] ipv6: Use global sernum for dst validation with nexthop objects
Date:   Wed, 29 Apr 2020 12:45:42 -0600
Message-Id: <20200429184542.31170-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nik reported a bug with pcpu dst cache when nexthop objects are
used illustrated by the following:
    $ ip netns add foo
    $ ip -netns foo li set lo up
    $ ip -netns foo addr add 2001:db8:11::1/128 dev lo
    $ ip netns exec foo sysctl net.ipv6.conf.all.forwarding=1
    $ ip li add veth1 type veth peer name veth2
    $ ip li set veth1 up
    $ ip addr add 2001:db8:10::1/64 dev veth1
    $ ip li set dev veth2 netns foo
    $ ip -netns foo li set veth2 up
    $ ip -netns foo addr add 2001:db8:10::2/64 dev veth2
    $ ip -6 nexthop add id 100 via 2001:db8:10::2 dev veth1
    $ ip -6 route add 2001:db8:11::1/128 nhid 100

    Create a pcpu entry on cpu 0:
    $ taskset -a -c 0 ip -6 route get 2001:db8:11::1

    Re-add the route entry:
    $ ip -6 ro del 2001:db8:11::1
    $ ip -6 route add 2001:db8:11::1/128 nhid 100

    Route get on cpu 0 returns the stale pcpu:
    $ taskset -a -c 0 ip -6 route get 2001:db8:11::1
    RTNETLINK answers: Network is unreachable

    While cpu 1 works:
    $ taskset -a -c 1 ip -6 route get 2001:db8:11::1
    2001:db8:11::1 from :: via 2001:db8:10::2 dev veth1 src 2001:db8:10::1 metric 1024 pref medium

Conversion of FIB entries to work with external nexthop objects
missed an important difference between IPv4 and IPv6 - how dst
entries are invalidated when the FIB changes. IPv4 has a per-network
namespace generation id (rt_genid) that is bumped on changes to the FIB.
Checking if a dst_entry is still valid means comparing rt_genid in the
rtable to the current value of rt_genid for the namespace.

IPv6 also has a per network namespace counter, fib6_sernum, but the
count is saved per fib6_node. With the per-node counter only dst_entries
based on fib entries under the node are invalidated when changes are
made to the routes - limiting the scope of invalidations. IPv6 uses a
reference in the rt6_info, 'from', to track the corresponding fib entry
used to create the dst_entry. When validating a dst_entry, the 'from'
is used to backtrack to the fib6_node and check the sernum of it to the
cookie passed to the dst_check operation.

With the inline format (nexthop definition inline with the fib6_info),
dst_entries cached in the fib6_nh have a 1:1 correlation between fib
entries, nexthop data and dst_entries. With external nexthops, IPv6
looks more like IPv4 which means multiple fib entries across disparate
fib6_nodes can all reference the same fib6_nh. That means validation
of dst_entries based on external nexthops needs to use the IPv4 format
- the per-network namespace counter.

Add sernum to rt6_info and set it when creating a pcpu dst entry. Update
rt6_get_cookie to return sernum if it is set and update dst_check for
IPv6 to look for sernum set and based the check on it if so. Finally,
rt6_get_pcpu_route needs to validate the cached entry before returning
a pcpu entry (similar to the rt_cache_valid calls in __mkroute_input and
__mkroute_output for IPv4).

This problem only affects routes using the new, external nexthops.

Thanks to the kbuild test robot for catching the IS_ENABLED needed
around rt_genid_ipv6 before I sent this out.

Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Tested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/net/ip6_fib.h       |  4 ++++
 include/net/net_namespace.h |  7 +++++++
 net/ipv6/route.c            | 25 +++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 80262d2980f5..5bc78a99e8a2 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -203,6 +203,7 @@ struct fib6_info {
 struct rt6_info {
 	struct dst_entry		dst;
 	struct fib6_info __rcu		*from;
+	int				sernum;
 
 	struct rt6key			rt6i_dst;
 	struct rt6key			rt6i_src;
@@ -291,6 +292,9 @@ static inline u32 rt6_get_cookie(const struct rt6_info *rt)
 	struct fib6_info *from;
 	u32 cookie = 0;
 
+	if (rt->sernum)
+		return rt->sernum;
+
 	rcu_read_lock();
 
 	from = rcu_dereference(rt->from);
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ab96fb59131c..8e001e049497 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -437,6 +437,13 @@ static inline int rt_genid_ipv4(const struct net *net)
 	return atomic_read(&net->ipv4.rt_genid);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static inline int rt_genid_ipv6(const struct net *net)
+{
+	return atomic_read(&net->ipv6.fib6_sernum);
+}
+#endif
+
 static inline void rt_genid_bump_ipv4(struct net *net)
 {
 	atomic_inc(&net->ipv4.rt_genid);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 310cbddaa533..5d83564d55aa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1385,9 +1385,18 @@ static struct rt6_info *ip6_rt_pcpu_alloc(const struct fib6_result *res)
 	}
 	ip6_rt_copy_init(pcpu_rt, res);
 	pcpu_rt->rt6i_flags |= RTF_PCPU;
+
+	if (f6i->nh)
+		pcpu_rt->sernum = rt_genid_ipv6(dev_net(dev));
+
 	return pcpu_rt;
 }
 
+static inline bool rt6_is_valid(const struct rt6_info *rt6)
+{
+	return rt6->sernum == rt_genid_ipv6(dev_net(rt6->dst.dev));
+}
+
 /* It should be called with rcu_read_lock() acquired */
 static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 {
@@ -1395,6 +1404,19 @@ static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 
 	pcpu_rt = this_cpu_read(*res->nh->rt6i_pcpu);
 
+	if (pcpu_rt && pcpu_rt->sernum && !rt6_is_valid(pcpu_rt)) {
+		struct rt6_info *prev, **p;
+
+		p = this_cpu_ptr(res->nh->rt6i_pcpu);
+		prev = xchg(p, NULL);
+		if (prev) {
+			dst_dev_put(&prev->dst);
+			dst_release(&prev->dst);
+		}
+
+		pcpu_rt = NULL;
+	}
+
 	return pcpu_rt;
 }
 
@@ -2593,6 +2615,9 @@ static struct dst_entry *ip6_dst_check(struct dst_entry *dst, u32 cookie)
 
 	rt = container_of(dst, struct rt6_info, dst);
 
+	if (rt->sernum)
+		return rt6_is_valid(rt) ? dst : NULL;
+
 	rcu_read_lock();
 
 	/* All IPV6 dsts are created with ->obsolete set to the value
-- 
2.25.1

