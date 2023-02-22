Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6924869F13F
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjBVJVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjBVJVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:21:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F19227D48;
        Wed, 22 Feb 2023 01:21:45 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/8] netfilter: ip6t_rpfilter: Fix regression with VRF interfaces
Date:   Wed, 22 Feb 2023 10:21:33 +0100
Message-Id: <20230222092137.88637-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222092137.88637-1-pablo@netfilter.org>
References: <20230222092137.88637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

When calling ip6_route_lookup() for the packet arriving on the VRF
interface, the result is always the real (slave) interface. Expect this
when validating the result.

Fixes: acc641ab95b66 ("netfilter: rpfilter/fib: Populate flowic_l3mdev field")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c         |  4 ++-
 tools/testing/selftests/netfilter/rpath.sh | 32 ++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index a01d9b842bd0..67c87a88cde4 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,7 +72,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index f7311e66d219..5289c8447a41 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -62,10 +62,16 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-[ -n "$iptables" ] && ip netns exec "$ns2" \
-	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-[ -n "$ip6tables" ] && ip netns exec "$ns2" \
-	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$iptables" ] && {
+	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter --invert
+}
+[ -n "$ip6tables" ] && {
+	common='-t raw -A PREROUTING -s fec0::/16'
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter --invert
+}
 [ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
@@ -89,6 +95,11 @@ ipt_zero_rule() { # (command)
 	[ -n "$1" ] || return 0
 	ip netns exec "$ns2" "$1" -t raw -vS | grep -q -- "-m rpfilter -c 0 0"
 }
+ipt_zero_reverse_rule() { # (command)
+	[ -n "$1" ] || return 0
+	ip netns exec "$ns2" "$1" -t raw -vS | \
+		grep -q -- "-m rpfilter --invert -c 0 0"
+}
 nft_zero_rule() { # (family)
 	[ -n "$nft" ] || return 0
 	ip netns exec "$ns2" "$nft" list chain inet t c | \
@@ -101,8 +112,7 @@ netns_ping() { # (netns, args...)
 	ip netns exec "$netns" ping -q -c 1 -W 1 "$@" >/dev/null
 }
 
-testrun() {
-	# clear counters first
+clear_counters() {
 	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
 	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
 	if [ -n "$nft" ]; then
@@ -111,6 +121,10 @@ testrun() {
 			ip netns exec "$ns2" $nft -s list table inet t;
 		) | ip netns exec "$ns2" $nft -f -
 	fi
+}
+
+testrun() {
+	clear_counters
 
 	# test 1: martian traffic should fail rpfilter matches
 	netns_ping "$ns1" -I v0 192.168.42.1 && \
@@ -120,9 +134,13 @@ testrun() {
 
 	ipt_zero_rule "$iptables" || die "iptables matched martian"
 	ipt_zero_rule "$ip6tables" || die "ip6tables matched martian"
+	ipt_zero_reverse_rule "$iptables" && die "iptables not matched martian"
+	ipt_zero_reverse_rule "$ip6tables" && die "ip6tables not matched martian"
 	nft_zero_rule ip || die "nft IPv4 matched martian"
 	nft_zero_rule ip6 || die "nft IPv6 matched martian"
 
+	clear_counters
+
 	# test 2: rpfilter match should pass for regular traffic
 	netns_ping "$ns1" 192.168.23.1 || \
 		die "regular ping 192.168.23.1 failed"
@@ -131,6 +149,8 @@ testrun() {
 
 	ipt_zero_rule "$iptables" && die "iptables match not effective"
 	ipt_zero_rule "$ip6tables" && die "ip6tables match not effective"
+	ipt_zero_reverse_rule "$iptables" || die "iptables match over-effective"
+	ipt_zero_reverse_rule "$ip6tables" || die "ip6tables match over-effective"
 	nft_zero_rule ip && die "nft IPv4 match not effective"
 	nft_zero_rule ip6 && die "nft IPv6 match not effective"
 
-- 
2.30.2

