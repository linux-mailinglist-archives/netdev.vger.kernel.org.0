Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D31E520D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgE1ADt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgE1ADt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 20:03:49 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B787206A1;
        Thu, 28 May 2020 00:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590624228;
        bh=7akJeAxAcjqmFY+PHtkKVzDRAP3ETuX83PK1yZtld+Q=;
        h=From:To:Cc:Subject:Date:From;
        b=PoHRF+qtjDfdTKHNRZMsJU9mcB3f1D3Y1caGFRK7wixVm9IksMRu4cQaH2zvMx35U
         x36WRhQjVQu1YhnIMeLot839dFII/yekvWNmTtPxSTxnsSh+fheNdLHrbQn9VqW3Rn
         SG5kWrbu5PxB5SICe1qAlOLf28FtxjsDhkGp2Yns=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] selftests: Add torture tests to nexthop tests
Date:   Wed, 27 May 2020 18:03:44 -0600
Message-Id: <20200528000344.57809-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Nik's torture tests as a new set to stress the replace and cleanup
paths.

Torture test created by Nikolay Aleksandrov and then I adapted to
selftest and added IPv6 version.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 115 +++++++++++++++++++-
 1 file changed, 113 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 1e2f61262e4e..dee567f7576a 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,8 +19,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal ipv4_torture"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal ipv6_torture"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -767,6 +767,62 @@ ipv6_large_grp()
 	$IP nexthop flush >/dev/null 2>&1
 }
 
+ipv6_del_add_loop1()
+{
+	while :; do
+		$IP nexthop del id 100
+		$IP nexthop add id 100 via 2001:db8:91::2 dev veth1
+	done >/dev/null 2>&1
+}
+
+ipv6_grp_replace_loop()
+{
+	while :; do
+		$IP nexthop replace id 102 group 100/101
+	done >/dev/null 2>&1
+}
+
+ipv6_torture()
+{
+	local pid1
+	local pid2
+	local pid3
+	local pid4
+	local pid5
+
+	echo
+	echo "IPv6 runtime torture"
+	echo "--------------------"
+	if [ ! -x "$(command -v mausezahn)" ]; then
+		echo "SKIP: Could not run test; need mausezahn tool"
+		return
+	fi
+
+	run_cmd "$IP nexthop add id 100 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 101 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 102 group 100/101"
+	run_cmd "$IP route add 2001:db8:101::1 nhid 102"
+	run_cmd "$IP route add 2001:db8:101::2 nhid 102"
+
+	ipv6_del_add_loop1 &
+	pid1=$!
+	ipv6_grp_replace_loop &
+	pid2=$!
+	ip netns exec me ping -f 2001:db8:101::1 >/dev/null 2>&1 &
+	pid3=$!
+	ip netns exec me ping -f 2001:db8:101::2 >/dev/null 2>&1 &
+	pid4=$!
+	ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
+	pid5=$!
+
+	sleep 300
+	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
+
+	# if we did not crash, success
+	log_test 0 0 "IPv6 torture test"
+}
+
+
 ipv4_fcnal()
 {
 	local rc
@@ -1313,6 +1369,61 @@ ipv4_compat_mode()
 	sysctl_nexthop_compat_mode_set 1 "IPv4"
 }
 
+ipv4_del_add_loop1()
+{
+	while :; do
+		$IP nexthop del id 100
+		$IP nexthop add id 100 via 172.16.1.2 dev veth1
+	done >/dev/null 2>&1
+}
+
+ipv4_grp_replace_loop()
+{
+	while :; do
+		$IP nexthop replace id 102 group 100/101
+	done >/dev/null 2>&1
+}
+
+ipv4_torture()
+{
+	local pid1
+	local pid2
+	local pid3
+	local pid4
+	local pid5
+
+	echo
+	echo "IPv4 runtime torture"
+	echo "--------------------"
+	if [ ! -x "$(command -v mausezahn)" ]; then
+		echo "SKIP: Could not run test; need mausezahn tool"
+		return
+	fi
+
+	run_cmd "$IP nexthop add id 100 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 101 via 172.16.2.2 dev veth3"
+	run_cmd "$IP nexthop add id 102 group 100/101"
+	run_cmd "$IP route add 172.16.101.1 nhid 102"
+	run_cmd "$IP route add 172.16.101.2 nhid 102"
+
+	ipv4_del_add_loop1 &
+	pid1=$!
+	ipv4_grp_replace_loop &
+	pid2=$!
+	ip netns exec me ping -f 172.16.101.1 >/dev/null 2>&1 &
+	pid3=$!
+	ip netns exec me ping -f 172.16.101.2 >/dev/null 2>&1 &
+	pid4=$!
+	ip netns exec me mausezahn veth1 -B 172.16.101.2 -A 172.16.1.1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
+	pid5=$!
+
+	sleep 300
+	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
+
+	# if we did not crash, success
+	log_test 0 0 "IPv4 torture test"
+}
+
 basic()
 {
 	echo
-- 
2.17.1

