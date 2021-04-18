Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BCD3637BC
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbhDRVFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:05:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35002 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhDRVE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3A7CB63E8F;
        Sun, 18 Apr 2021 23:04:00 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/14] selftests: fib_tests: Add test cases for interaction with mangling
Date:   Sun, 18 Apr 2021 23:04:14 +0200
Message-Id: <20210418210415.4719-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that packets are correctly routed when netfilter mangling rules are
present.

Without previous patch:

 # ./fib_tests.sh -t ipv4_mangle

 IPv4 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [FAIL]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [FAIL]

 Tests passed:   3
 Tests failed:   2

 # ./fib_tests.sh -t ipv6_mangle

 IPv6 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [FAIL]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [FAIL]

 Tests passed:   3
 Tests failed:   2

With previous patch:

 # ./fib_tests.sh -t ipv4_mangle

 IPv4 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [ OK ]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [ OK ]

 Tests passed:   5
 Tests failed:   0

 # ./fib_tests.sh -t ipv6_mangle

 IPv6 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [ OK ]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [ OK ]

 Tests passed:   5
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/fib_tests.sh | 152 ++++++++++++++++++++++-
 1 file changed, 151 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 2b5707738609..76d9487fb03c 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr"
+TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -1653,6 +1653,154 @@ ipv4_route_v6_gw_test()
 	route_cleanup
 }
 
+socat_check()
+{
+	if [ ! -x "$(command -v socat)" ]; then
+		echo "socat command not found. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+iptables_check()
+{
+	iptables -t mangle -L OUTPUT &> /dev/null
+	if [ $? -ne 0 ]; then
+		echo "iptables configuration not supported. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+ip6tables_check()
+{
+	ip6tables -t mangle -L OUTPUT &> /dev/null
+	if [ $? -ne 0 ]; then
+		echo "ip6tables configuration not supported. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+ipv4_mangle_test()
+{
+	local rc
+
+	echo
+	echo "IPv4 mangling tests"
+
+	socat_check || return 1
+	iptables_check || return 1
+
+	route_setup
+	sleep 2
+
+	local tmp_file=$(mktemp)
+	ip netns exec ns2 socat UDP4-LISTEN:54321,fork $tmp_file &
+
+	# Add a FIB rule and a route that will direct our connection to the
+	# listening server.
+	$IP rule add pref 100 ipproto udp sport 12345 dport 54321 table 123
+	$IP route add table 123 172.16.101.0/24 dev veth1
+
+	# Add an unreachable route to the main table that will block our
+	# connection in case the FIB rule is not hit.
+	$IP route add unreachable 172.16.101.2/32
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters"
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=11111"
+	log_test $? 1 "    Connection with incorrect parameters"
+
+	# Add a mangling rule and make sure connection is still successful.
+	$NS_EXEC iptables -t mangle -A OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - mangling"
+
+	# Delete the mangling rule and make sure connection is still
+	# successful.
+	$NS_EXEC iptables -t mangle -D OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - no mangling"
+
+	# Verify connections were indeed successful on server side.
+	[[ $(cat $tmp_file | wc -l) -eq 3 ]]
+	log_test $? 0 "    Connection check - server side"
+
+	$IP route del unreachable 172.16.101.2/32
+	$IP route del table 123 172.16.101.0/24 dev veth1
+	$IP rule del pref 100
+
+	{ kill %% && wait %%; } 2>/dev/null
+	rm $tmp_file
+
+	route_cleanup
+}
+
+ipv6_mangle_test()
+{
+	local rc
+
+	echo
+	echo "IPv6 mangling tests"
+
+	socat_check || return 1
+	ip6tables_check || return 1
+
+	route_setup
+	sleep 2
+
+	local tmp_file=$(mktemp)
+	ip netns exec ns2 socat UDP6-LISTEN:54321,fork $tmp_file &
+
+	# Add a FIB rule and a route that will direct our connection to the
+	# listening server.
+	$IP -6 rule add pref 100 ipproto udp sport 12345 dport 54321 table 123
+	$IP -6 route add table 123 2001:db8:101::/64 dev veth1
+
+	# Add an unreachable route to the main table that will block our
+	# connection in case the FIB rule is not hit.
+	$IP -6 route add unreachable 2001:db8:101::2/128
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters"
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=11111"
+	log_test $? 1 "    Connection with incorrect parameters"
+
+	# Add a mangling rule and make sure connection is still successful.
+	$NS_EXEC ip6tables -t mangle -A OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - mangling"
+
+	# Delete the mangling rule and make sure connection is still
+	# successful.
+	$NS_EXEC ip6tables -t mangle -D OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - no mangling"
+
+	# Verify connections were indeed successful on server side.
+	[[ $(cat $tmp_file | wc -l) -eq 3 ]]
+	log_test $? 0 "    Connection check - server side"
+
+	$IP -6 route del unreachable 2001:db8:101::2/128
+	$IP -6 route del table 123 2001:db8:101::/64 dev veth1
+	$IP -6 rule del pref 100
+
+	{ kill %% && wait %%; } 2>/dev/null
+	rm $tmp_file
+
+	route_cleanup
+}
+
 ################################################################################
 # usage
 
@@ -1725,6 +1873,8 @@ do
 	ipv6_route_metrics)		ipv6_route_metrics_test;;
 	ipv4_route_metrics)		ipv4_route_metrics_test;;
 	ipv4_route_v6_gw)		ipv4_route_v6_gw_test;;
+	ipv4_mangle)			ipv4_mangle_test;;
+	ipv6_mangle)			ipv6_mangle_test;;
 
 	help) echo "Test names: $TESTS"; exit 0;;
 	esac
-- 
2.30.2

