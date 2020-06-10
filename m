Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9312F1F4BE8
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgFJDuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgFJDuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:50:00 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFF76207ED;
        Wed, 10 Jun 2020 03:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591761000;
        bh=FNKeL/Abtr/Ds1M9hz8iAPAvAFUctIULH8ZIyN6MAF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEiyxKonivrf8EOhE75FguWAQti8aHUzrAwJWUe/i25VeNYPvf6x+JoxqCwF4hyRL
         3dd/TrQLdWeahMriNvyLXNvanDbdLDB1tWf/ISSBIahfqMBWl1zwTgbcnaV7AAZqcC
         kVjzDNNEhVhy7rmk3k8Cco9PZYhDyT9jLvHUpKH4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 8/8] selftests: Add active-backup nexthop tests
Date:   Tue,  9 Jun 2020 21:49:53 -0600
Message-Id: <20200610034953.28861-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 334 +++++++++++++++++++-
 1 file changed, 330 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index dee567f7576a..4db390438885 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -5,11 +5,21 @@
 #   2001:db8:91::1     |       2001:db8:91::2  |
 #   172.16.1.1         |       172.16.1.2      |
 #            veth1 <---|---> veth2             |
-#                      |              veth5 <--|--> veth6  172.16.101.1
+#                      |              veth6 <--|--> veth5  172.16.101.1
 #            veth3 <---|---> veth4             |           2001:db8:101::1
 #   172.16.2.1         |       172.16.2.2      |
 #   2001:db8:92::1     |       2001:db8:92::2  |
 #
+# For active/backup testing:
+# ns: me               | ns: peer2             | ns: remote
+#   2001:db8:81::1     |       2001:db8:81::2  |
+#   172.16.81.1        |       172.16.81.2     |
+#           veth21 <---|---> veth22            |
+#                      |             veth26 <--|--> veth25 <--> br
+#           veth23 <---|---> veth24            |
+#   172.16.82.1        |       172.16.82.2     |
+#   2001:db8:82::1     |       2001:db8:82::2  |
+#
 # This test is for checking IPv4 and IPv6 FIB behavior with nexthop
 # objects. Device reference counts and network namespace cleanup tested
 # by use of network namespace for peer.
@@ -19,8 +29,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal ipv4_torture"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal ipv6_torture"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal ipv4_torture ipv4_ab_group"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal ipv6_torture ipv6_ab_group"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -179,11 +189,60 @@ setup()
 	set +e
 }
 
+setup_ab()
+{
+	create_ns peer2
+
+	set -e
+	$IP li add veth21 type veth peer name veth22
+	$IP li set veth21 up
+	$IP addr add 172.16.81.1/24 dev veth21
+	$IP -6 addr add 2001:db8:81::1/64 dev veth21 nodad
+
+	$IP li add veth23 type veth peer name veth24
+	$IP li set veth23 up
+	$IP addr add 172.16.82.1/24 dev veth23
+	$IP -6 addr add 2001:db8:82::1/64 dev veth23 nodad
+
+	$IP li set veth22 netns peer2 up
+	ip -netns peer2 addr add 172.16.81.2/24 dev veth22
+	ip -netns peer2 -6 addr add 2001:db8:81::2/64 dev veth22 nodad
+
+	$IP li set veth24 netns peer2 up
+	ip -netns peer2 addr add 172.16.82.2/24 dev veth24
+	ip -netns peer2 -6 addr add 2001:db8:82::2/64 dev veth24 nodad
+
+	ip -netns remote li set veth5 down
+	ip -netns remote addr flush dev veth5
+	ip -netns remote li add br0 type bridge
+	ip -netns remote li add veth25 type veth peer name veth26
+	ip -netns remote li set veth25 master br0 up
+	ip -netns remote li set veth5 master br0 up
+	ip -netns remote li set br0 up
+
+	ip -netns remote addr add dev br0 172.16.101.1/24
+	ip -netns remote -6 addr add dev br0 2001:db8:101::1/64 nodad
+
+	ip -netns remote li set veth26 netns peer2 up
+	ip -netns peer2 addr add dev veth26 172.16.101.3/24
+	ip -netns peer2 -6 addr add dev veth26 2001:db8:101::3/64 nodad
+
+	ip -netns remote ro add 172.16.1.0/24 nexthop via 172.16.101.2
+	ip -netns remote ro add 172.16.2.0/24 nexthop via 172.16.101.2
+	ip -netns remote ro add 172.16.81.0/24 nexthop via 172.16.101.3
+	ip -netns remote ro add 172.16.82.0/24 nexthop via 172.16.101.3
+	ip -netns remote -6 ro add 2001:db8:91::/64 nexthop via 2001:db8:101::2
+	ip -netns remote -6 ro add 2001:db8:92::/64 nexthop via 2001:db8:101::2
+	ip -netns remote -6 ro add 2001:db8:81::/64 nexthop via 2001:db8:101::3
+	ip -netns remote -6 ro add 2001:db8:82::/64 nexthop via 2001:db8:101::3
+	set +e
+}
+
 cleanup()
 {
 	local ns
 
-	for ns in me peer remote; do
+	for ns in me peer peer2 remote; do
 		ip netns del ${ns} 2>/dev/null
 	done
 }
@@ -335,6 +394,273 @@ stop_ip_monitor()
 	return $rc
 }
 
+################################################################################
+# active-backup nexthops
+
+check_nexthop_ab_support()
+{
+	$IP nexthop help 2>&1 | grep -q active-backup
+	if [ $? -ne 0 ]; then
+		echo "SKIP: iproute2 too old, missing active-backup nexthop support"
+		return $ksft_skip
+	fi
+}
+
+ipv6_ab_group()
+{
+	local rc
+
+	echo
+	echo "IPv6 active-backup groups"
+	echo "-------------------------"
+
+	check_nexthop_ab_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	setup_ab
+
+	run_cmd "$IP nexthop add id 11 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 2001:db8:81::2 dev veth21"
+	run_cmd "$IP nexthop add id 101 group 11/12 active-backup"
+	check_nexthop "id 101" "id 101 group 11/12 active-backup"
+	log_test $? 0 "Create active-backup group"
+
+	run_cmd "$IP ro add 2001:db8:101::/64 nhid 101"
+	check_route6 "2001:db8:101::1" "2001:db8:101::/64 nhid 101 via 2001:db8:91::2 dev veth1 metric 1024"
+	log_test $? 0 "Route list shows active device"
+
+	$IP -o ro get 2001:db8:101::1 2>/dev/null | grep -q "dev veth1"
+	log_test $? 0 "Route get shows active device"
+
+	# carrier down or admin down on nexthop device removes that entry
+	run_cmd "ip -netns peer li set veth2 down"
+	check_nexthop "id 101" "id 101 group 12 active-backup"
+	log_test $? 0 "Carrier down removes active"
+
+	$IP -o ro get 2001:db8:101::1 2>/dev/null | grep -q "dev veth21"
+	log_test $? 0 "Route get shows backup device"
+
+	run_cmd "$IP li set veth21 down"
+	$IP nexthop sh id 101 2>/dev/null
+	log_test $? 2 "Link down on backup removes nexthop"
+
+	check_route "2001:db8:101::1" ""
+	log_test $? 0 "Route removed after a-b nexthop removed"
+
+	# restore device state
+	run_cmd "ip -netns peer li set veth2 up"
+	run_cmd "$IP li set veth21 up"
+
+	# a/b with mpath
+	run_cmd "$IP nexthop flush"
+	run_cmd "$IP nexthop add id 11 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 21 via 2001:db8:81::2 dev veth21"
+	run_cmd "$IP nexthop add id 22 via 2001:db8:82::2 dev veth23"
+	run_cmd "$IP nexthop add id 101 group 11/21 active-backup"
+	run_cmd "$IP nexthop add id 102 group 12/22 active-backup"
+	run_cmd "$IP nexthop add id 103 group 101/102"
+	log_test $? 0 "Multipath with active-backup paths"
+
+	run_cmd "$IP nexthop ls"
+	run_cmd "$IP ro add 2001:db8:101::/64 nhid 103"
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "ping with multipath containing active-backup paths"
+
+	run_cmd "ip -netns peer li set veth2 down"
+	check_nexthop "id 103" "id 103 group 101/102"
+	log_test $? 0 "Multipath still shows 2 paths after carrier down in a/b"
+
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "ping with still works after carrier down"
+
+	run_cmd "ip -netns peer li set veth2 up"
+	run_cmd "$IP nexthop ls"
+	run_cmd "$IP -6 ro ls"
+
+	run_cmd "$IP li set veth21 down"
+	check_nexthop "id 103" "id 103 group 102"
+	log_test $? 0 "Multipath shows 1 path after admin down on new active"
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "ping with still works after mpath loss of a-b path"
+
+	run_cmd "$IP li set veth21 up"
+	run_cmd "$IP nexthop ls"
+	run_cmd "$IP -6 ro ls"
+
+	#
+	# negative tests
+	#
+	# active points to invalid gw
+	run_cmd "$IP nexthop flush"
+	run_cmd "$IP nexthop add id 11 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 2001:db8:81::2 dev veth21"
+	run_cmd "$IP nexthop add id 101 group 11/12 active-backup"
+	run_cmd "$IP ro add 2001:db8:101::/64 nhid 101"
+
+	# failed neigh for gateway - should fallback to backup
+	run_cmd "${IP} -6 neigh add 2001:db8:91::3 dev veth1 nud failed"
+	$IP -o ro get 2001:db8:101::1 2>/dev/null | grep -q "dev veth21"
+	log_test $? 0 "Route get shows backup device with invalid neigh"
+
+	run_cmd "$IP nexthop flush"
+	run_cmd "$IP nexthop add id 11 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 13 blackhole"
+	run_cmd "$IP nexthop add id 21 via 2001:db8:81::2 dev veth21"
+	run_cmd "$IP nexthop add id 22 via 2001:db8:82::2 dev veth23"
+
+	# must have 2 entries of equal weight
+	run_cmd "$IP nexthop add id 101 group 11 active-backup"
+	log_test $? 2 "Active-backup nexthop can not have 1 entry"
+	run_cmd "$IP nexthop add id 101 group 11/12/21 active-backup"
+	log_test $? 2 "Active-backup nexthop can not have more than 2 entries"
+	run_cmd "$IP nexthop add id 101 group 11,5/21,4 active-backup"
+	log_test $? 2 "Active-backup nexthops must have equal weight"
+	run_cmd "$IP nexthop add id 101 group 11,3/21,3 active-backup"
+	log_test $? 2 "Active-backup nexthops must have default weight"
+
+	# can not replace a/b group with mpath
+	run_cmd "$IP nexthop add id 101 group 11/21 active-backup"
+	run_cmd "$IP nexthop replace id 101 group 11/21 mpath"
+	log_test $? 2 "Can not change group type"
+
+	# a/b group can not have blackhole
+	run_cmd "$IP nexthop add id 102 group 11/13 active-backup"
+	log_test $? 2 "Active-backup can use blackhole as a path"
+}
+
+ipv4_ab_group()
+{
+	local rc
+
+	echo
+	echo "IPv4 active-backup groups"
+	echo "-------------------------"
+
+	check_nexthop_ab_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	setup_ab
+
+	run_cmd "$IP nexthop add id 11 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 172.16.81.2 dev veth21"
+	run_cmd "$IP nexthop add id 101 group 11/12 active-backup"
+	check_nexthop "id 101" "id 101 group 11/12 active-backup"
+	log_test $? 0 "Create active-backup group"
+
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 101"
+	check_route "172.16.101.1" "172.16.101.0/24 nhid 101 via 172.16.1.2 dev veth1"
+	log_test $? 0 "Route list shows active device"
+
+	$IP -o ro get 172.16.101.1 2>/dev/null | grep -q "dev veth1"
+	log_test $? 0 "Route get shows active device"
+
+	# carrier down or admin down on nexthop device removes that entry
+	run_cmd "ip -netns peer li set veth2 down"
+	check_nexthop "id 101" "id 101 group 12 active-backup"
+	log_test $? 0 "Carrier down removes active"
+
+	$IP -o ro get 172.16.101.1 2>/dev/null | grep -q "dev veth21"
+	log_test $? 0 "Route get shows backup device"
+
+	run_cmd "$IP li set veth21 down"
+	$IP nexthop sh id 101 2>/dev/null
+	log_test $? 2 "Link down on backup removes nexthop"
+
+	check_route "172.16.101.1" ""
+	log_test $? 0 "Route removed after a-b nexthop removed"
+
+	# restore device state
+	run_cmd "ip -netns peer li set veth2 up"
+	run_cmd "$IP li set veth21 up"
+
+	# a/b with mpath
+	run_cmd "$IP nexthop flush"
+	run_cmd "$IP nexthop add id 11 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 172.16.2.2 dev veth3"
+	run_cmd "$IP nexthop add id 21 via 172.16.81.2 dev veth21"
+	run_cmd "$IP nexthop add id 22 via 172.16.82.2 dev veth23"
+	run_cmd "$IP nexthop add id 101 group 11/21 active-backup"
+	run_cmd "$IP nexthop add id 102 group 12/22 active-backup"
+	run_cmd "$IP nexthop add id 103 group 101/102"
+	log_test $? 0 "Multipath with active-backup paths"
+
+	run_cmd "$IP nexthop ls"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 103"
+	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	log_test $? 0 "ping with multipath containing active-backup paths"
+
+	run_cmd "ip -netns peer li set veth2 down"
+	check_nexthop "id 103" "id 103 group 101/102"
+	log_test $? 0 "Multipath still shows 2 paths after carrier down in a/b"
+
+	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	log_test $? 0 "ping with still works after carrier down"
+
+	run_cmd "ip -netns peer li set veth2 up"
+	run_cmd "$IP nexthop ls"
+	run_cmd "$IP ro ls"
+
+	run_cmd "$IP li set veth21 down"
+	check_nexthop "id 103" "id 103 group 102"
+	log_test $? 0 "Multipath shows 1 path after admin down on new active"
+	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	log_test $? 0 "ping with still works after mpath loss of a-b path"
+
+	run_cmd "$IP li set veth21 up"
+	run_cmd "$IP nexthop ls"
+	run_cmd "$IP ro ls"
+
+	#
+	# negative tests
+	#
+	# active points to invalid gw
+	run_cmd "$IP nexthop flush"
+	run_cmd "$IP nexthop add id 11 via 172.16.1.3 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 172.16.81.2 dev veth21"
+	run_cmd "$IP nexthop add id 101 group 11/12 active-backup"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 101"
+
+	# failed neigh for gateway - should fallback to backup
+	run_cmd "${IP} neigh add 172.16.1.3 dev veth1 nud failed"
+	$IP -o ro get 172.16.101.1 2>/dev/null | grep -q "dev veth21"
+	log_test $? 0 "Route get shows backup device with invalid neigh"
+
+	run_cmd "$IP nexthop flush"
+	run_cmd "$IP nexthop add id 11 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 12 via 172.16.2.2 dev veth3"
+	run_cmd "$IP nexthop add id 13 blackhole"
+	run_cmd "$IP nexthop add id 21 via 172.16.81.2 dev veth21"
+	run_cmd "$IP nexthop add id 22 via 172.16.82.2 dev veth23"
+
+	# must have 2 entries of equal weight
+	run_cmd "$IP nexthop add id 101 group 11 active-backup"
+	log_test $? 2 "Active-backup nexthop can not have 1 entry"
+	run_cmd "$IP nexthop add id 101 group 11/12/21 active-backup"
+	log_test $? 2 "Active-backup nexthop can not have more than 2 entries"
+	run_cmd "$IP nexthop add id 101 group 11,5/21,4 active-backup"
+	log_test $? 2 "Active-backup nexthops must have equal weight"
+	run_cmd "$IP nexthop add id 101 group 11,3/21,3 active-backup"
+	log_test $? 2 "Active-backup nexthops must have default weight"
+
+	# can not replace a/b group with mpath
+	run_cmd "$IP nexthop add id 101 group 11/21 active-backup"
+	run_cmd "$IP nexthop replace id 101 group 11/21 mpath"
+	log_test $? 2 "Can not change group type"
+
+	# a/b group can not have blackhole
+	run_cmd "$IP nexthop add id 102 group 11/13 active-backup"
+	log_test $? 2 "Active-backup can use blackhole as a path"
+}
+
+################################################################################
+# fdb nexthops
+
 check_nexthop_fdb_support()
 {
 	$IP nexthop help 2>&1 | grep -q fdb
-- 
2.21.1 (Apple Git-122.3)

