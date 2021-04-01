Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5744D352355
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhDAXT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:19:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:18944 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235535AbhDAXTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:19:54 -0400
IronPort-SDR: O6TNiz77rVt1zQFRSrhiVfcektNeW9671Q5KppsfIDtrlUuZHMJSwaX5k23lMcJpzdyEk5u1Ch
 +2q//0uFHpxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191829883"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="191829883"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:54 -0700
IronPort-SDR: ZlRe04CeEBLHF7SaLudhxXbpkdKE26a+z3oP6xCr7NPhQ4EW76F5ohnUmry3uaUcg6L6C2oIBA
 FLN8octHXXzw==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="446269196"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.128.105])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:19:54 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/7] selftests: mptcp: launch mptcp_connect with timeout
Date:   Thu,  1 Apr 2021 16:19:45 -0700
Message-Id: <20210401231947.162836-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
References: <20210401231947.162836-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

'mptcp_connect' already has a timeout for poll() but in some cases, it
is not enough.

With "timeout" tool, we will force the command to fail if it doesn't
finish on time. Thanks to that, the script will continue and display
details about the current state before marking the test as failed.
Displaying this state is very important to be able to understand the
issue. Best to have our CI reporting the issue than just "the test
hanged".

Note that in mptcp_connect.sh, we were using a long timeout to validate
the fact we cannot create a socket if a sysctl is set. We don't need
this timeout.

In diag.sh, we want to send signals to mptcp_connect instances that have
been started in the netns. But we cannot send this signal to 'timeout'
otherwise that will stop the timeout and messages telling us SIGUSR1 has
been received will be printed. Instead of trying to find the right PID
and storing them in an array, we can simply use the output of
'ip netns pids' which is all the PIDs we want to send signal to.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/160
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/diag.sh     | 55 ++++++++++++-------
 .../selftests/net/mptcp/mptcp_connect.sh      | 15 +++--
 .../testing/selftests/net/mptcp/mptcp_join.sh | 22 ++++++--
 .../selftests/net/mptcp/simult_flows.sh       | 13 ++++-
 4 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index 39edce4f541c..2674ba20d524 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -5,8 +5,9 @@ rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
 ns="ns1-$rndh"
 ksft_skip=4
 test_cnt=1
+timeout_poll=100
+timeout_test=$((timeout_poll * 2 + 1))
 ret=0
-pids=()
 
 flush_pids()
 {
@@ -14,18 +15,14 @@ flush_pids()
 	# give it some time
 	sleep 1.1
 
-	for pid in ${pids[@]}; do
-		[ -d /proc/$pid ] && kill -SIGUSR1 $pid >/dev/null 2>&1
-	done
-	pids=()
+	ip netns pids "${ns}" | xargs --no-run-if-empty kill -SIGUSR1 &>/dev/null
 }
 
 cleanup()
 {
+	ip netns pids "${ns}" | xargs --no-run-if-empty kill -SIGKILL &>/dev/null
+
 	ip netns del $ns
-	for pid in ${pids[@]}; do
-		[ -d /proc/$pid ] && kill -9 $pid >/dev/null 2>&1
-	done
 }
 
 ip -Version > /dev/null 2>&1
@@ -79,39 +76,57 @@ trap cleanup EXIT
 ip netns add $ns
 ip -n $ns link set dev lo up
 
-echo "a" | ip netns exec $ns ./mptcp_connect -p 10000 -l 0.0.0.0 -t 100 >/dev/null &
+echo "a" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
+				0.0.0.0 >/dev/null &
 sleep 0.1
-pids[0]=$!
 chk_msk_nr 0 "no msk on netns creation"
 
-echo "b" | ip netns exec $ns ./mptcp_connect -p 10000 127.0.0.1 -j -t 100 >/dev/null &
+echo "b" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10000 -j -t ${timeout_poll} \
+				127.0.0.1 >/dev/null &
 sleep 0.1
-pids[1]=$!
 chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
 flush_pids
 
 
-echo "a" | ip netns exec $ns ./mptcp_connect -p 10001 -s TCP -l 0.0.0.0 -t 100 >/dev/null &
-pids[0]=$!
+echo "a" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} \
+				0.0.0.0 >/dev/null &
 sleep 0.1
-echo "b" | ip netns exec $ns ./mptcp_connect -p 10001 127.0.0.1 -j -t 100 >/dev/null &
-pids[1]=$!
+echo "b" | \
+	timeout ${timeout_test} \
+		ip netns exec $ns \
+			./mptcp_connect -p 10001 -j -t ${timeout_poll} \
+				127.0.0.1 >/dev/null &
 sleep 0.1
 chk_msk_fallback_nr 1 "check fallback"
 flush_pids
 
 NR_CLIENTS=100
 for I in `seq 1 $NR_CLIENTS`; do
-	echo "a" | ip netns exec $ns ./mptcp_connect -p $((I+10001)) -l 0.0.0.0 -t 100 -w 10 >/dev/null  &
-	pids[$((I*2))]=$!
+	echo "a" | \
+		timeout ${timeout_test} \
+			ip netns exec $ns \
+				./mptcp_connect -p $((I+10001)) -l -w 10 \
+					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
 sleep 0.1
 
 for I in `seq 1 $NR_CLIENTS`; do
-	echo "b" | ip netns exec $ns ./mptcp_connect -p $((I+10001)) 127.0.0.1 -t 100 -w 10 >/dev/null &
-	pids[$((I*2 + 1))]=$!
+	echo "b" | \
+		timeout ${timeout_test} \
+			ip netns exec $ns \
+				./mptcp_connect -p $((I+10001)) -w 10 \
+					-t ${timeout_poll} 127.0.0.1 >/dev/null &
 done
 sleep 1.5
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 10a030b53b23..65b3b983efc2 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -11,7 +11,8 @@ cin=""
 cout=""
 ksft_skip=4
 capture=false
-timeout=30
+timeout_poll=30
+timeout_test=$((timeout_poll * 2 + 1))
 ipv6=true
 ethtool_random_on=true
 tc_delay="$((RANDOM%50))"
@@ -273,7 +274,7 @@ check_mptcp_disabled()
 	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
 
 	local err=0
-	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
+	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
 		grep -q "^socket: Protocol not available$" && err=1
 	ip netns delete ${disabled_ns}
 
@@ -430,14 +431,20 @@ do_transfer()
 	local stat_cookietx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	local stat_cookierx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 
-	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} $extra_args $local_addr < "$sin" > "$sout" &
+	timeout ${timeout_test} \
+		ip netns exec ${listener_ns} \
+			./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+				$extra_args $local_addr < "$sin" > "$sout" &
 	local spid=$!
 
 	wait_local_port_listen "${listener_ns}" "${port}"
 
 	local start
 	start=$(date +%s%3N)
-	ip netns exec ${connector_ns} ./mptcp_connect -t $timeout -p $port -s ${cl_proto} $extra_args $connect_addr < "$cin" > "$cout" &
+	timeout ${timeout_test} \
+		ip netns exec ${connector_ns} \
+			./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+				$extra_args $connect_addr < "$cin" > "$cout" &
 	local cpid=$!
 
 	wait $cpid
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index d2273b88e72c..56ffdad01526 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -8,7 +8,8 @@ cin=""
 cinsent=""
 cout=""
 ksft_skip=4
-timeout=30
+timeout_poll=30
+timeout_test=$((timeout_poll * 2 + 1))
 mptcp_connect=""
 capture=0
 do_all_tests=1
@@ -247,17 +248,26 @@ do_transfer()
 		local_addr="0.0.0.0"
 	fi
 
-	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port \
-		-s ${srv_proto} ${local_addr} < "$sin" > "$sout" &
+	timeout ${timeout_test} \
+		ip netns exec ${listener_ns} \
+			$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+				${local_addr} < "$sin" > "$sout" &
 	spid=$!
 
 	sleep 1
 
 	if [ "$test_link_fail" -eq 0 ];then
-		ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
+		timeout ${timeout_test} \
+			ip netns exec ${connector_ns} \
+				$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+					$connect_addr < "$cin" > "$cout" &
 	else
-		( cat "$cin" ; sleep 2; link_failure $listener_ns ; cat "$cin" ) | tee "$cinsent" | \
-		ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr > "$cout" &
+		( cat "$cin" ; sleep 2; link_failure $listener_ns ; cat "$cin" ) | \
+			tee "$cinsent" | \
+			timeout ${timeout_test} \
+				ip netns exec ${connector_ns} \
+					$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+						$connect_addr > "$cout" &
 	fi
 	cpid=$!
 
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index f039ee57eb3c..3aeef3bcb101 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -7,7 +7,8 @@ ns2="ns2-$rndh"
 ns3="ns3-$rndh"
 capture=false
 ksft_skip=4
-timeout=30
+timeout_poll=30
+timeout_test=$((timeout_poll * 2 + 1))
 test_cnt=1
 ret=0
 bail=0
@@ -157,14 +158,20 @@ do_transfer()
 		sleep 1
 	fi
 
-	ip netns exec ${ns3} ./mptcp_connect -jt $timeout -l -p $port 0.0.0.0 < "$sin" > "$sout" &
+	timeout ${timeout_test} \
+		ip netns exec ${ns3} \
+			./mptcp_connect -jt ${timeout_poll} -l -p $port \
+				0.0.0.0 < "$sin" > "$sout" &
 	local spid=$!
 
 	wait_local_port_listen "${ns3}" "${port}"
 
 	local start
 	start=$(date +%s%3N)
-	ip netns exec ${ns1} ./mptcp_connect -jt $timeout -p $port 10.0.3.3 < "$cin" > "$cout" &
+	timeout ${timeout_test} \
+		ip netns exec ${ns1} \
+			./mptcp_connect -jt ${timeout_poll} -p $port \
+				10.0.3.3 < "$cin" > "$cout" &
 	local cpid=$!
 
 	wait $cpid
-- 
2.31.1

