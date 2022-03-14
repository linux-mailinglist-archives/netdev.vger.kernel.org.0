Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402AE4D8E6C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbiCNUrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbiCNUrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1023D39B9C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E6D61306
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79810C340E9;
        Mon, 14 Mar 2022 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647290754;
        bh=vE1mx8vHBIjJm+5cObj4efwVFWohDEEVYPC8SKlcjWY=;
        h=From:To:Cc:Subject:Date:From;
        b=rwLzZzTz5oCcu6ZboXPHy01u/Oyg5lxPTBT8J/Ksz+0ua44xclBssRcUNrM5EbOmA
         yds0ZOazKYvI+YfiHTmbVc2+DXh2x/X9bmbd7g11mgpGe7oJIwTfb8Db85koCNmAZN
         nYmqeLFoKc22icJ8JXeOkSfc4bw3fa6R4qVKgHE8I/H76IjBQNc93G1WHjsZ2nVHjs
         JPz5CduaVjuJY4gF3K/wbxMhRNPcp0vfZDiBIMPTndiY8Er92Y5/AzKJS9iz3ufuVE
         OKLd683dOLEPlnarPV+wzFPae2IM1oPqUoXQx+4wyI3ZAfn2vHJN6R1XUg4nYwdxUv
         O+/2tJfgSFzUA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     greearb@candelatech.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] net: Add l3mdev index to flow struct and avoid oif reset for port devices
Date:   Mon, 14 Mar 2022 14:45:51 -0600
Message-Id: <20220314204551.16369-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fundamental premise of VRF and l3mdev core code is binding a socket
to a device (l3mdev or netdev with an L3 domain) to indicate L3 scope.
Legacy code resets flowi_oif to the l3mdev losing any original port
device binding. Ben (among others) has demonstrated use cases where the
original port device binding is important and needs to be retained.
This patch handles that by adding a new entry to the common flow struct
that can indicate the l3mdev index for later rule and table matching
avoiding the need to reset flowi_oif.

In addition to allowing more use cases that require port device binds,
this patch brings a few datapath simplications:

1. l3mdev_fib_rule_match is only called when walking fib rules and
   always after l3mdev_update_flow. That allows an optimization to bail
   early for non-VRF type uses cases when flowi_l3mdev is not set. Also,
   only that index needs to be checked for the FIB table id.

2. l3mdev_update_flow can be called with flowi_oif set to a l3mdev
   (e.g., VRF) device. By resetting flowi_oif only for this case the
   FLOWI_FLAG_SKIP_NH_OIF flag is not longer needed and can be removed,
   removing several checks in the datapath. The flowi_iif path can be
   simplified to only be called if the it is not loopback (loopback can
   not be assigned to an L3 domain) and the l3mdev index is not already
   set.

3. Avoid another device lookup in the output path when the fib lookup
   returns a reject failure.

Note: 2 functional tests for local traffic with reject fib rules are
updated to reflect the new direct failure at FIB lookup time for ping
rather than the failure on packet path. The current code fails like this:

    HINT: Fails since address on vrf device is out of device scope
    COMMAND: ip netns exec ns-A ping -c1 -w1 -I eth1 172.16.3.1
    ping: Warning: source address might be selected on device other than: eth1
    PING 172.16.3.1 (172.16.3.1) from 172.16.3.1 eth1: 56(84) bytes of data.

    --- 172.16.3.1 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 0ms

where the test now directly fails:

    HINT: Fails since address on vrf device is out of device scope
    COMMAND: ip netns exec ns-A ping -c1 -w1 -I eth1 172.16.3.1
    ping: connect: No route to host

Signed-off-by: David Ahern <dsahern@kernel.org>
Tested-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/vrf.c                         |  7 ++--
 include/net/flow.h                        |  6 +++-
 net/ipv4/fib_frontend.c                   |  7 ++--
 net/ipv4/fib_semantics.c                  |  2 +-
 net/ipv4/fib_trie.c                       |  7 ++--
 net/ipv4/route.c                          |  4 +--
 net/ipv4/xfrm4_policy.c                   |  4 +--
 net/ipv6/ip6_output.c                     |  3 +-
 net/ipv6/route.c                          | 12 -------
 net/ipv6/xfrm6_policy.c                   |  3 +-
 net/l3mdev/l3mdev.c                       | 43 +++++++++--------------
 tools/testing/selftests/net/fcnal-test.sh |  2 +-
 12 files changed, 37 insertions(+), 63 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 714cafcf6c6c..85e362461d71 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -472,14 +472,13 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 
 	memset(&fl6, 0, sizeof(fl6));
 	/* needed to match OIF rule */
-	fl6.flowi6_oif = dev->ifindex;
+	fl6.flowi6_l3mdev = dev->ifindex;
 	fl6.flowi6_iif = LOOPBACK_IFINDEX;
 	fl6.daddr = iph->daddr;
 	fl6.saddr = iph->saddr;
 	fl6.flowlabel = ip6_flowinfo(iph);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = iph->nexthdr;
-	fl6.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF;
 
 	dst = ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
 	if (IS_ERR(dst) || dst == dst_null)
@@ -551,10 +550,10 @@ static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 
 	memset(&fl4, 0, sizeof(fl4));
 	/* needed to match OIF rule */
-	fl4.flowi4_oif = vrf_dev->ifindex;
+	fl4.flowi4_l3mdev = vrf_dev->ifindex;
 	fl4.flowi4_iif = LOOPBACK_IFINDEX;
 	fl4.flowi4_tos = RT_TOS(ip4h->tos);
-	fl4.flowi4_flags = FLOWI_FLAG_ANYSRC | FLOWI_FLAG_SKIP_NH_OIF;
+	fl4.flowi4_flags = FLOWI_FLAG_ANYSRC;
 	fl4.flowi4_proto = ip4h->protocol;
 	fl4.daddr = ip4h->daddr;
 	fl4.saddr = ip4h->saddr;
diff --git a/include/net/flow.h b/include/net/flow.h
index 58beb16a49b8..987bd511d652 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -29,6 +29,7 @@ struct flowi_tunnel {
 struct flowi_common {
 	int	flowic_oif;
 	int	flowic_iif;
+	int     flowic_l3mdev;
 	__u32	flowic_mark;
 	__u8	flowic_tos;
 	__u8	flowic_scope;
@@ -36,7 +37,6 @@ struct flowi_common {
 	__u8	flowic_flags;
 #define FLOWI_FLAG_ANYSRC		0x01
 #define FLOWI_FLAG_KNOWN_NH		0x02
-#define FLOWI_FLAG_SKIP_NH_OIF		0x04
 	__u32	flowic_secid;
 	kuid_t  flowic_uid;
 	struct flowi_tunnel flowic_tun_key;
@@ -70,6 +70,7 @@ struct flowi4 {
 	struct flowi_common	__fl_common;
 #define flowi4_oif		__fl_common.flowic_oif
 #define flowi4_iif		__fl_common.flowic_iif
+#define flowi4_l3mdev		__fl_common.flowic_l3mdev
 #define flowi4_mark		__fl_common.flowic_mark
 #define flowi4_tos		__fl_common.flowic_tos
 #define flowi4_scope		__fl_common.flowic_scope
@@ -102,6 +103,7 @@ static inline void flowi4_init_output(struct flowi4 *fl4, int oif,
 {
 	fl4->flowi4_oif = oif;
 	fl4->flowi4_iif = LOOPBACK_IFINDEX;
+	fl4->flowi4_l3mdev = 0;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_tos = tos;
 	fl4->flowi4_scope = scope;
@@ -132,6 +134,7 @@ struct flowi6 {
 	struct flowi_common	__fl_common;
 #define flowi6_oif		__fl_common.flowic_oif
 #define flowi6_iif		__fl_common.flowic_iif
+#define flowi6_l3mdev		__fl_common.flowic_l3mdev
 #define flowi6_mark		__fl_common.flowic_mark
 #define flowi6_scope		__fl_common.flowic_scope
 #define flowi6_proto		__fl_common.flowic_proto
@@ -177,6 +180,7 @@ struct flowi {
 	} u;
 #define flowi_oif	u.__fl_common.flowic_oif
 #define flowi_iif	u.__fl_common.flowic_iif
+#define flowi_l3mdev	u.__fl_common.flowic_l3mdev
 #define flowi_mark	u.__fl_common.flowic_mark
 #define flowi_tos	u.__fl_common.flowic_tos
 #define flowi_scope	u.__fl_common.flowic_scope
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 7408051632ac..af8209f912ab 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -291,7 +291,7 @@ __be32 fib_compute_spec_dst(struct sk_buff *skb)
 		bool vmark = in_dev && IN_DEV_SRC_VMARK(in_dev);
 		struct flowi4 fl4 = {
 			.flowi4_iif = LOOPBACK_IFINDEX,
-			.flowi4_oif = l3mdev_master_ifindex_rcu(dev),
+			.flowi4_l3mdev = l3mdev_master_ifindex_rcu(dev),
 			.daddr = ip_hdr(skb)->saddr,
 			.flowi4_tos = ip_hdr(skb)->tos & IPTOS_RT_MASK,
 			.flowi4_scope = scope,
@@ -353,9 +353,8 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	bool dev_match;
 
 	fl4.flowi4_oif = 0;
-	fl4.flowi4_iif = l3mdev_master_ifindex_rcu(dev);
-	if (!fl4.flowi4_iif)
-		fl4.flowi4_iif = oif ? : LOOPBACK_IFINDEX;
+	fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(dev);
+	fl4.flowi4_iif = oif ? : LOOPBACK_IFINDEX;
 	fl4.daddr = src;
 	fl4.saddr = dst;
 	fl4.flowi4_tos = tos;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index c5a29703185a..cc8e84ef2ae4 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2234,7 +2234,7 @@ void fib_select_multipath(struct fib_result *res, int hash)
 void fib_select_path(struct net *net, struct fib_result *res,
 		     struct flowi4 *fl4, const struct sk_buff *skb)
 {
-	if (fl4->flowi4_oif && !(fl4->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF))
+	if (fl4->flowi4_oif)
 		goto check_saddr;
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2af2b99e0bea..fb0e49c36c2e 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1429,11 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
 	    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
 		return false;
 
-	if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
-		if (flp->flowi4_oif &&
-		    flp->flowi4_oif != nhc->nhc_oif)
-			return false;
-	}
+	if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
+		return false;
 
 	return true;
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f444f5983405..63f3256a407d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2263,6 +2263,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	/*
 	 *	Now we are ready to route packet.
 	 */
+	fl4.flowi4_l3mdev = 0;
 	fl4.flowi4_oif = 0;
 	fl4.flowi4_iif = dev->ifindex;
 	fl4.flowi4_mark = skb->mark;
@@ -2738,8 +2739,7 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 		res->fi = NULL;
 		res->table = NULL;
 		if (fl4->flowi4_oif &&
-		    (ipv4_is_multicast(fl4->daddr) ||
-		    !netif_index_is_l3_master(net, fl4->flowi4_oif))) {
+		    (ipv4_is_multicast(fl4->daddr) || !fl4->flowi4_l3mdev)) {
 			/* Apparently, routing tables are wrong. Assume,
 			 * that the destination is on link.
 			 *
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 9e83bcb6bc99..6fde0b184791 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -28,13 +28,11 @@ static struct dst_entry *__xfrm4_dst_lookup(struct net *net, struct flowi4 *fl4,
 	memset(fl4, 0, sizeof(*fl4));
 	fl4->daddr = daddr->a4;
 	fl4->flowi4_tos = tos;
-	fl4->flowi4_oif = l3mdev_master_ifindex_by_index(net, oif);
+	fl4->flowi4_l3mdev = l3mdev_master_ifindex_by_index(net, oif);
 	fl4->flowi4_mark = mark;
 	if (saddr)
 		fl4->saddr = saddr->a4;
 
-	fl4->flowi4_flags = FLOWI_FLAG_SKIP_NH_OIF;
-
 	rt = __ip_route_output_key(net, fl4);
 	if (!IS_ERR(rt))
 		return &rt->dst;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e69fac576970..a76fba3dd47a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1035,8 +1035,7 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
 #ifdef CONFIG_IPV6_SUBTREES
 	    ip6_rt_check(&rt->rt6i_src, &fl6->saddr, np->saddr_cache) ||
 #endif
-	   (!(fl6->flowi6_flags & FLOWI_FLAG_SKIP_NH_OIF) &&
-	      (fl6->flowi6_oif && fl6->flowi6_oif != dst->dev->ifindex))) {
+	   (fl6->flowi6_oif && fl6->flowi6_oif != dst->dev->ifindex)) {
 		dst_release(dst);
 		dst = NULL;
 	}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6188712f24b0..2fa10e60cccd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1209,9 +1209,6 @@ INDIRECT_CALLABLE_SCOPE struct rt6_info *ip6_pol_route_lookup(struct net *net,
 	struct fib6_node *fn;
 	struct rt6_info *rt;
 
-	if (fl6->flowi6_flags & FLOWI_FLAG_SKIP_NH_OIF)
-		flags &= ~RT6_LOOKUP_F_IFACE;
-
 	rcu_read_lock();
 	fn = fib6_node_lookup(&table->tb6_root, &fl6->daddr, &fl6->saddr);
 restart:
@@ -2181,9 +2178,6 @@ int fib6_table_lookup(struct net *net, struct fib6_table *table, int oif,
 	fn = fib6_node_lookup(&table->tb6_root, &fl6->daddr, &fl6->saddr);
 	saved_fn = fn;
 
-	if (fl6->flowi6_flags & FLOWI_FLAG_SKIP_NH_OIF)
-		oif = 0;
-
 redo_rt6_select:
 	rt6_select(net, fn, oif, res, strict);
 	if (res->f6i == net->ipv6.fib6_null_entry) {
@@ -3058,12 +3052,6 @@ INDIRECT_CALLABLE_SCOPE struct rt6_info *__ip6_route_redirect(struct net *net,
 	struct fib6_info *rt;
 	struct fib6_node *fn;
 
-	/* l3mdev_update_flow overrides oif if the device is enslaved; in
-	 * this case we must match on the real ingress device, so reset it
-	 */
-	if (fl6->flowi6_flags & FLOWI_FLAG_SKIP_NH_OIF)
-		fl6->flowi6_oif = skb->dev->ifindex;
-
 	/* Get the "current" route for this destination and
 	 * check if the redirect has come from appropriate router.
 	 *
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 55bb2cbae13d..e64e427a51cf 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -33,8 +33,7 @@ static struct dst_entry *xfrm6_dst_lookup(struct net *net, int tos, int oif,
 	int err;
 
 	memset(&fl6, 0, sizeof(fl6));
-	fl6.flowi6_oif = l3mdev_master_ifindex_by_index(net, oif);
-	fl6.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF;
+	fl6.flowi6_l3mdev = l3mdev_master_ifindex_by_index(net, oif);
 	fl6.flowi6_mark = mark;
 	memcpy(&fl6.daddr, daddr, sizeof(fl6.daddr));
 	if (saddr)
diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index 17927966abb3..4eb8892fb2ff 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -250,25 +250,19 @@ int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
 	struct net_device *dev;
 	int rc = 0;
 
-	rcu_read_lock();
+	/* update flow ensures flowi_l3mdev is set when relevant */
+	if (!fl->flowi_l3mdev)
+		return 0;
 
-	dev = dev_get_by_index_rcu(net, fl->flowi_oif);
-	if (dev && netif_is_l3_master(dev) &&
-	    dev->l3mdev_ops->l3mdev_fib_table) {
-		arg->table = dev->l3mdev_ops->l3mdev_fib_table(dev);
-		rc = 1;
-		goto out;
-	}
+	rcu_read_lock();
 
-	dev = dev_get_by_index_rcu(net, fl->flowi_iif);
+	dev = dev_get_by_index_rcu(net, fl->flowi_l3mdev);
 	if (dev && netif_is_l3_master(dev) &&
 	    dev->l3mdev_ops->l3mdev_fib_table) {
 		arg->table = dev->l3mdev_ops->l3mdev_fib_table(dev);
 		rc = 1;
-		goto out;
 	}
 
-out:
 	rcu_read_unlock();
 
 	return rc;
@@ -277,31 +271,28 @@ int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
 void l3mdev_update_flow(struct net *net, struct flowi *fl)
 {
 	struct net_device *dev;
-	int ifindex;
 
 	rcu_read_lock();
 
 	if (fl->flowi_oif) {
 		dev = dev_get_by_index_rcu(net, fl->flowi_oif);
 		if (dev) {
-			ifindex = l3mdev_master_ifindex_rcu(dev);
-			if (ifindex) {
-				fl->flowi_oif = ifindex;
-				fl->flowi_flags |= FLOWI_FLAG_SKIP_NH_OIF;
-				goto out;
-			}
+			if (!fl->flowi_l3mdev)
+				fl->flowi_l3mdev = l3mdev_master_ifindex_rcu(dev);
+
+			/* oif set to L3mdev directs lookup to its table;
+			 * reset to avoid oif match in fib_lookup
+			 */
+			if (netif_is_l3_master(dev))
+				fl->flowi_oif = 0;
+			goto out;
 		}
 	}
 
-	if (fl->flowi_iif) {
+	if (fl->flowi_iif > LOOPBACK_IFINDEX && !fl->flowi_l3mdev) {
 		dev = dev_get_by_index_rcu(net, fl->flowi_iif);
-		if (dev) {
-			ifindex = l3mdev_master_ifindex_rcu(dev);
-			if (ifindex) {
-				fl->flowi_iif = ifindex;
-				fl->flowi_flags |= FLOWI_FLAG_SKIP_NH_OIF;
-			}
-		}
+		if (dev)
+			fl->flowi_l3mdev = l3mdev_master_ifindex_rcu(dev);
 	}
 
 out:
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3f4c8cfe7aca..47c4d4b4a44a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -750,7 +750,7 @@ ipv4_ping_vrf()
 		log_start
 		show_hint "Fails since address on vrf device is out of device scope"
 		run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
-		log_test_addr ${a} $? 1 "ping local, device bind"
+		log_test_addr ${a} $? 2 "ping local, device bind"
 	done
 
 	#
-- 
2.25.1

