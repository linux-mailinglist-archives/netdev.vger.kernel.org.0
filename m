Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676C53A5175
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 02:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhFMA1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 20:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFMA1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 20:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9766D610C8;
        Sun, 13 Jun 2021 00:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623543903;
        bh=nqfU4LbqBJEpkjbADTLvO90Eq97LXEfhy0eteBALIdk=;
        h=From:To:Cc:Subject:Date:From;
        b=JsHwXHV70wy/oIFBI+HPGfwDU/9Ybu4EpmD8JGYobdij66/8O5TalEGISNAbTFzrC
         EDMTK7lQSJKABuqGutTiaW7vOxgskliSFpTWHA3xgpU2/KAj86rRmjLPxBG8gAuYjP
         dMnnsSnKBxcLWlR+3WpwTRwb5leDX091lcuSwxAmYGPzqcMVYZQ6XdaekfenNc/seI
         PD2LFKH4422poHLo479TllGQO+8EawBQqHmU9yGILRCe4cEpcAyIomOK32Rvex7EHi
         n760xz7lBchXudSuoYZj+HmRuOlqD5H0LShq9zXyyfAII0CweJ2y+Whny0cUqgrZYT
         ypp/iLjxUgb1g==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     oliver.peter.herms@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv4: Fix device used for dst_alloc with local routes
Date:   Sat, 12 Jun 2021 18:24:59 -0600
Message-Id: <20210613002500.63438-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver reported a use case where deleting a VRF device can hang
waiting for the refcnt to drop to 0. The root cause is that the dst
is allocated against the VRF device but cached on the loopback
device.

The use case (added to the selftests) has an implicit VRF crossing
due to the ordering of the FIB rules (lookup local is before the
l3mdev rule, but the problem occurs even if the FIB rules are
re-ordered with local after l3mdev because the VRF table does not
have a default route to terminate the lookup). The end result is
is that the FIB lookup returns the loopback device as the nexthop,
but the ingress device is in a VRF. The mismatch causes the dst
alloc against the VRF device but then cached on the loopback.

The fix is to bring the trick used for IPv6 (see ip6_rt_get_dev_rcu):
pick the dst alloc device based the fib lookup result but with checks
that the result has a nexthop device (e.g., not an unreachable or
prohibit entry).

Fixes: f5a0aab84b74 ("net: ipv4: dst for local input routes should use l3mdev if relevant")
Reported-by: Oliver Herms <oliver.peter.herms@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/route.c                         | 15 +++++++++++++-
 tools/testing/selftests/net/fib_tests.sh | 25 ++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f6787c55f6ab..6a36ac98476f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2056,6 +2056,19 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	return err;
 }
 
+/* get device for dst_alloc with local routes */
+static struct net_device *ip_rt_get_dev(struct net *net,
+					const struct fib_result *res)
+{
+	struct fib_nh_common *nhc = res->fi ? res->nhc : NULL;
+	struct net_device *dev = NULL;
+
+	if (nhc)
+		dev = l3mdev_master_dev_rcu(nhc->nhc_dev);
+
+	return dev ? : net->loopback_dev;
+}
+
 /*
  *	NOTE. We drop all the packets that has local source
  *	addresses, because every properly looped back packet
@@ -2212,7 +2225,7 @@ out:	return err;
 		}
 	}
 
-	rth = rt_dst_alloc(l3mdev_master_dev_rcu(dev) ? : net->loopback_dev,
+	rth = rt_dst_alloc(ip_rt_get_dev(net, res),
 			   flags | RTCF_LOCAL, res->type,
 			   IN_DEV_ORCONF(in_dev, NOPOLICY), false);
 	if (!rth)
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 76d9487fb03c..5abe92d55b69 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1384,12 +1384,37 @@ ipv4_rt_replace()
 	ipv4_rt_replace_mpath
 }
 
+# checks that cached input route on VRF port is deleted
+# when VRF is deleted
+ipv4_local_rt_cache()
+{
+	run_cmd "ip addr add 10.0.0.1/32 dev lo"
+	run_cmd "ip netns add test-ns"
+	run_cmd "ip link add veth-outside type veth peer name veth-inside"
+	run_cmd "ip link add vrf-100 type vrf table 1100"
+	run_cmd "ip link set veth-outside master vrf-100"
+	run_cmd "ip link set veth-inside netns test-ns"
+	run_cmd "ip link set veth-outside up"
+	run_cmd "ip link set vrf-100 up"
+	run_cmd "ip route add 10.1.1.1/32 dev veth-outside table 1100"
+	run_cmd "ip netns exec test-ns ip link set veth-inside up"
+	run_cmd "ip netns exec test-ns ip addr add 10.1.1.1/32 dev veth-inside"
+	run_cmd "ip netns exec test-ns ip route add 10.0.0.1/32 dev veth-inside"
+	run_cmd "ip netns exec test-ns ip route add default via 10.0.0.1"
+	run_cmd "ip netns exec test-ns ping 10.0.0.1 -c 1 -i 1"
+	run_cmd "ip link delete vrf-100"
+
+	# if we do not hang test is a success
+	log_test $? 0 "Cached route removed from VRF port device"
+}
+
 ipv4_route_test()
 {
 	route_setup
 
 	ipv4_rt_add
 	ipv4_rt_replace
+	ipv4_local_rt_cache
 
 	route_cleanup
 }
-- 
2.27.0

