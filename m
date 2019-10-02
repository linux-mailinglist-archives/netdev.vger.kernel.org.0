Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63213C94FE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfJBXh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbfJBXhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862641"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:25 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 44/45] selftests: mptcp: add ipv6 connectivity
Date:   Wed,  2 Oct 2019 16:36:54 -0700
Message-Id: <20191002233655.24323-45-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

prepare for ipv6 mptcp tests.
Once someone starts to implement mptcp v6 support, just set ipv6=true in
the script and the selftest will attempt to connect via ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 77 ++++++++++++++++---
 1 file changed, 66 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index fb9bf9f4fc8b..615691434a34 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -9,6 +9,7 @@ cout=""
 ksft_skip=4
 capture=0
 timeout=30
+ipv6=false
 
 TEST_COUNT=0
 
@@ -58,29 +59,48 @@ ip link add ns2eth3 netns ns2 type veth peer name ns3eth2 netns ns3
 ip link add ns3eth4 netns ns3 type veth peer name ns4eth3 netns ns4
 
 ip -net ns1 addr add 10.0.1.1/24 dev ns1eth2
+if $ipv6 ; then
+	ip -net ns1 addr add dead:beef:1::1/64 dev ns1eth2
+	if [ $? -ne 0 ] ;then
+		echo "SKIP: Can't add ipv6 address, skip ipv6 tests" 1>&2
+		ipv6=false
+	fi
+fi
+
 ip -net ns1 link set ns1eth2 up
 ip -net ns1 route add default via 10.0.1.2
+$ipv6 && ip -net ns1 route add default via dead:beef:1::2
 
 ip -net ns2 addr add 10.0.1.2/24 dev ns2eth1
+$ipv6 && ip -net ns2 addr add dead:beef:1::2/64 dev ns2eth1
 ip -net ns2 link set ns2eth1 up
 
 ip -net ns2 addr add 10.0.2.1/24 dev ns2eth3
+$ipv6 && ip -net ns2 addr add dead:beef:2::1/64 dev ns2eth3
 ip -net ns2 link set ns2eth3 up
 ip -net ns2 route add default via 10.0.2.2
+$ipv6 && ip -net ns2 route add default via dead:beef:2::2
 ip netns exec ns2 sysctl -q net.ipv4.ip_forward=1
+$ipv6 && ip netns exec ns2 sysctl -q net.ipv6.conf.all.forwarding=1
 
 ip -net ns3 addr add 10.0.2.2/24 dev ns3eth2
+$ipv6 && ip -net ns3 addr add dead:beef:2::2/64 dev ns3eth2
 ip -net ns3 link set ns3eth2 up
 
 ip -net ns3 addr add 10.0.3.2/24 dev ns3eth4
+$ipv6 && ip -net ns3 addr add dead:beef:3::2/64 dev ns3eth4
 ip -net ns3 link set ns3eth4 up
 ip -net ns3 route add default via 10.0.2.1
+$ipv6 && ip -net ns3 route add default via dead:beef:2::1
 ip netns exec ns3 ethtool -K ns3eth2 tso off 2>/dev/null
 ip netns exec ns3 sysctl -q net.ipv4.ip_forward=1
+$ipv6 && ip netns exec ns3 sysctl -q net.ipv6.conf.all.forwarding=1
 
 ip -net ns4 addr add 10.0.3.1/24 dev ns4eth3
+$ipv6 && ip -net ns4 addr add dead:beef:3::1/64 dev ns4eth3
 ip -net ns4 link set ns4eth3 up
 ip -net ns4 route add default via 10.0.3.2
+$ipv6 && ip -net ns4 route add default via dead:beef:3::2
 
 print_file_err()
 {
@@ -138,7 +158,11 @@ do_ping()
 	if [ $? -ne 0 ] ; then
 		echo "$listener_ns -> $connect_addr connectivity [ FAIL ]" 1>&2
 		ret=1
+
+		return 1
 	fi
+
+	return 0
 }
 
 do_transfer()
@@ -148,6 +172,7 @@ do_transfer()
 	cl_proto="$3"
 	srv_proto="$4"
 	connect_addr="$5"
+	local_addr="$6"
 
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
@@ -173,7 +198,7 @@ do_transfer()
 	    sleep 1
 	fi
 
-	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
+	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} $local_addr < "$sin" > "$sout" &
 	spid=$!
 
 	sleep 1
@@ -241,23 +266,26 @@ run_tests()
 	listener_ns="$1"
 	connector_ns="$2"
 	connect_addr="$3"
+	local_addr="$4"
 	lret=0
 
 	for proto in MPTCP TCP;do
-		do_transfer ${listener_ns} ${connector_ns} MPTCP "$proto" ${connect_addr}
+		do_transfer ${listener_ns} ${connector_ns} MPTCP "$proto" ${connect_addr} ${local_addr}
 		lret=$?
 		if [ $lret -ne 0 ]; then
 			ret=$lret
-			return
+			return 1
 		fi
 	done
 
-	do_transfer ${listener_ns} ${connector_ns} TCP MPTCP ${connect_addr}
+	do_transfer ${listener_ns} ${connector_ns} TCP MPTCP ${connect_addr} ${local_addr}
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
-		return
+		return 1
 	fi
+
+	return 0
 }
 
 make_file "$cin" "client"
@@ -265,16 +293,31 @@ make_file "$sin" "server"
 
 check_mptcp_disabled
 
+# Allow DAD to finish
+$ipv6 && sleep 2
+
 for sender in 1 2 3 4;do
 	do_ping ns1 ns$sender 10.0.1.1
+	if $ipv6;then
+		do_ping ns1 ns$sender dead:beef:1::1
+		if [ $? -ne 0 ]; then
+			echo "SKIP: IPv6 tests" 2>&1
+			ipv6=false
+		fi
+	fi
 
 	do_ping ns2 ns$sender 10.0.1.2
+	$ipv6 && do_ping ns2 ns$sender dead:beef:1::2
 	do_ping ns2 ns$sender 10.0.2.1
+	$ipv6 && do_ping ns2 ns$sender dead:beef:2::1
 
 	do_ping ns3 ns$sender 10.0.2.2
+	$ipv6 && do_ping ns3 ns$sender dead:beef:2::2
 	do_ping ns3 ns$sender 10.0.3.2
+	$ipv6 && do_ping ns3 ns$sender dead:beef:3::2
 
 	do_ping ns4 ns$sender 10.0.3.1
+	$ipv6 && do_ping ns4 ns$sender dead:beef:3::1
 done
 
 loss=$((RANDOM%101))
@@ -305,15 +348,27 @@ fi
 echo "INFO: Using loss of $loss, delay $delay ms, reorder: $reorder1, $reorder2 $gap on ns3eth4"
 
 for sender in 1 2 3 4;do
-	run_tests ns1 ns$sender 10.0.1.1
+	run_tests ns1 ns$sender 10.0.1.1 0.0.0.0
+	if $ipv6;then
+		run_tests ns1 ns$sender dead:beef:1::1 ::
+		if [ $? -ne 0 ] ;then
+			echo "SKIP: IPv6 tests" 2>&1
+			ipv6=false
+		fi
+	fi
 
-	run_tests ns2 ns$sender 10.0.1.2
-	run_tests ns2 ns$sender 10.0.2.1
+	run_tests ns2 ns$sender 10.0.1.2 0.0.0.0
+	$ipv6 && run_tests ns2 ns$sender dead:beef:1::2 ::
+	run_tests ns2 ns$sender 10.0.2.1 0.0.0.0
+	$ipv6 && run_tests ns2 ns$sender dead:beef:2::1 ::
 
-	run_tests ns3 ns$sender 10.0.2.2
-	run_tests ns3 ns$sender 10.0.3.2
+	run_tests ns3 ns$sender 10.0.2.2 0.0.0.0
+	$ipv6 && run_tests ns3 ns$sender dead:beef:2::2 ::
+	run_tests ns3 ns$sender 10.0.3.2 0.0.0.0
+	$ipv6 && run_tests ns3 ns$sender dead:beef:3::2 ::
 
-	run_tests ns4 ns$sender 10.0.3.1
+	run_tests ns4 ns$sender 10.0.3.1 0.0.0.0
+	$ipv6 && run_tests ns4 ns$sender dead:beef:3::1 ::
 done
 
 exit $ret
-- 
2.23.0

