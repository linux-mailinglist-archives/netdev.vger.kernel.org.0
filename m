Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2E43EBE38
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhHMWQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:29033 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235128AbhHMWQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520908"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520908"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320459"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] selftests: mptcp: add testcase for active-back
Date:   Fri, 13 Aug 2021 15:15:48 -0700
Message-Id: <20210813221548.111990-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Add more test-case for link failures scenario,
including recovery from link failure using only
backup subflows and bi-directional transfer.

Additionally explicitly check for stale count

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 218 +++++++++++++++---
 1 file changed, 187 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f02f4de2f3a0..52762eaa2d8e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3,8 +3,10 @@
 
 ret=0
 sin=""
+sinfail=""
 sout=""
 cin=""
+cinfail=""
 cinsent=""
 cout=""
 ksft_skip=4
@@ -76,6 +78,14 @@ init()
 	done
 }
 
+init_shapers()
+{
+	for i in `seq 1 4`; do
+		tc -n $ns1 qdisc add dev ns1eth$i root netem rate 20mbit delay 1
+		tc -n $ns2 qdisc add dev ns2eth$i root netem rate 20mbit delay 1
+	done
+}
+
 cleanup_partial()
 {
 	rm -f "$capout"
@@ -88,8 +98,8 @@ cleanup_partial()
 
 cleanup()
 {
-	rm -f "$cin" "$cout"
-	rm -f "$sin" "$sout" "$cinsent"
+	rm -f "$cin" "$cout" "$sinfail"
+	rm -f "$sin" "$sout" "$cinsent" "$cinfail"
 	cleanup_partial
 }
 
@@ -211,11 +221,15 @@ link_failure()
 {
 	ns="$1"
 
-	l=$((RANDOM%4))
-	l=$((l+1))
+	if [ -z "$FAILING_LINKS" ]; then
+		l=$((RANDOM%4))
+		FAILING_LINKS=$((l+1))
+	fi
 
-	veth="ns1eth$l"
-	ip -net "$ns" link set "$veth" down
+	for l in $FAILING_LINKS; do
+		veth="ns1eth$l"
+		ip -net "$ns" link set "$veth" down
+	done
 }
 
 # $1: IP address
@@ -280,10 +294,17 @@ do_transfer()
 		local_addr="0.0.0.0"
 	fi
 
-	timeout ${timeout_test} \
-		ip netns exec ${listener_ns} \
-			$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
-				${local_addr} < "$sin" > "$sout" &
+	if [ "$test_link_fail" -eq 2 ];then
+		timeout ${timeout_test} \
+			ip netns exec ${listener_ns} \
+				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${cl_proto} \
+					${local_addr} < "$sinfail" > "$sout" &
+	else
+		timeout ${timeout_test} \
+			ip netns exec ${listener_ns} \
+				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
+					${local_addr} < "$sin" > "$sout" &
+	fi
 	spid=$!
 
 	sleep 1
@@ -294,7 +315,7 @@ do_transfer()
 				$mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
 					$connect_addr < "$cin" > "$cout" &
 	else
-		( cat "$cin" ; sleep 2; link_failure $listener_ns ; cat "$cin" ) | \
+		( cat "$cinfail" ; sleep 2; link_failure $listener_ns ; cat "$cinfail" ) | \
 			tee "$cinsent" | \
 			timeout ${timeout_test} \
 				ip netns exec ${connector_ns} \
@@ -434,7 +455,11 @@ do_transfer()
 		return 1
 	fi
 
-	check_transfer $sin $cout "file received by client"
+	if [ "$test_link_fail" -eq 2 ];then
+		check_transfer $sinfail $cout "file received by client"
+	else
+		check_transfer $sin $cout "file received by client"
+	fi
 	retc=$?
 	if [ "$test_link_fail" -eq 0 ];then
 		check_transfer $cin $sout "file received by server"
@@ -477,29 +502,33 @@ run_tests()
 	lret=0
 	oldin=""
 
-	if [ "$test_linkfail" -eq 1 ];then
-		size=$((RANDOM%1024))
+	# create the input file for the failure test when
+	# the first failure test run
+	if [ "$test_linkfail" -ne 0 -a -z "$cinfail" ]; then
+		# the client file must be considerably larger
+		# of the maximum expected cwin value, or the
+		# link utilization will be not predicable
+		size=$((RANDOM%2))
 		size=$((size+1))
-		size=$((size*128))
+		size=$((size*8192))
+		size=$((size + ( $RANDOM % 8192) ))
 
-		oldin=$(mktemp)
-		cp "$cin" "$oldin"
-		make_file "$cin" "client" $size
+		cinfail=$(mktemp)
+		make_file "$cinfail" "client" $size
 	fi
 
-	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
-		${test_linkfail} ${addr_nr_ns1} ${addr_nr_ns2} ${speed} ${bkup}
-	lret=$?
+	if [ "$test_linkfail" -eq 2 -a -z "$sinfail" ]; then
+		size=$((RANDOM%16))
+		size=$((size+1))
+		size=$((size*2048))
 
-	if [ "$test_linkfail" -eq 1 ];then
-		cp "$oldin" "$cin"
-		rm -f "$oldin"
+		sinfail=$(mktemp)
+		make_file "$sinfail" "server" $size
 	fi
 
-	if [ $lret -ne 0 ]; then
-		ret=$lret
-		return
-	fi
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
+		${test_linkfail} ${addr_nr_ns1} ${addr_nr_ns2} ${speed} ${bkup}
+	lret=$?
 }
 
 chk_csum_nr()
@@ -593,6 +622,46 @@ chk_join_nr()
 	fi
 }
 
+# a negative value for 'stale_max' means no upper bound:
+# for bidirectional transfer, if one peer sleep for a while
+# - as these tests do - we can have a quite high number of
+# stale/recover conversions, proportional to
+# sleep duration/ MPTCP-level RTX interval.
+chk_stale_nr()
+{
+	local ns=$1
+	local stale_min=$2
+	local stale_max=$3
+	local stale_delta=$4
+	local dump_stats
+	local stale_nr
+	local recover_nr
+
+	printf "%-39s %-18s" " " "stale"
+	stale_nr=`ip netns exec $ns nstat -as | grep MPTcpExtSubflowStale | awk '{print $2}'`
+	[ -z "$stale_nr" ] && stale_nr=0
+	recover_nr=`ip netns exec $ns nstat -as | grep MPTcpExtSubflowRecover | awk '{print $2}'`
+	[ -z "$recover_nr" ] && recover_nr=0
+
+	if [ $stale_nr -lt $stale_min ] ||
+	   [ $stale_max -gt 0 -a $stale_nr -gt $stale_max ] ||
+	   [ $((stale_nr - $recover_nr)) -ne $stale_delta ]; then
+		echo "[fail] got $stale_nr stale[s] $recover_nr recover[s], " \
+		     " expected stale in range [$stale_min..$stale_max]," \
+		     " stale-recover delta $stale_delta "
+		ret=1
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	if [ "${dump_stats}" = 1 ]; then
+		echo $ns stats
+		ip netns exec $ns ip -s link show
+		ip netns exec $ns nstat -as | grep MPTcp
+	fi
+}
+
 chk_add_nr()
 {
 	local add_nr=$1
@@ -801,6 +870,27 @@ chk_prio_nr()
 	fi
 }
 
+chk_link_usage()
+{
+	local ns=$1
+	local link=$2
+	local out=$3
+	local expected_rate=$4
+	local tx_link=`ip netns exec $ns cat /sys/class/net/$link/statistics/tx_bytes`
+	local tx_total=`ls -l $out | awk '{print $5}'`
+	local tx_rate=$((tx_link * 100 / $tx_total))
+	local tolerance=5
+
+	printf "%-39s %-18s" " " "link usage"
+	if [ $tx_rate -lt $((expected_rate - $tolerance)) -o \
+	     $tx_rate -gt $((expected_rate + $tolerance)) ]; then
+		echo "[fail] got $tx_rate% usage, expected $expected_rate%"
+		ret=1
+	else
+		echo "[ ok ]"
+	fi
+}
+
 subflows_tests()
 {
 	reset
@@ -924,14 +1014,80 @@ link_failure_tests()
 {
 	# accept and use add_addr with additional subflows and link loss
 	reset
+
+	# without any b/w limit each veth could spool the packets and get
+	# them acked at xmit time, so that the corresponding subflow will
+	# have almost always no outstanding pkts, the scheduler will pick
+	# always the first subflow and we will have hard time testing
+	# active backup and link switch-over.
+	# Let's set some arbitrary (low) virtual link limits.
+	init_shapers
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 dev ns2eth4 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 1
 	chk_join_nr "multiple flows, signal, link failure" 3 3 3
 	chk_add_nr 1 1
+	chk_stale_nr $ns2 1 5 1
+
+	# accept and use add_addr with additional subflows and link loss
+	# for bidirectional transfer
+	reset
+	init_shapers
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 dev ns2eth4 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 2
+	chk_join_nr "multi flows, signal, bidi, link fail" 3 3 3
+	chk_add_nr 1 1
+	chk_stale_nr $ns2 1 -1 1
+
+	# 2 subflows plus 1 backup subflow with a lossy link, backup
+	# will never be used
+	reset
+	init_shapers
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	export FAILING_LINKS="1"
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow,backup
+	run_tests $ns1 $ns2 10.0.1.1 1
+	chk_join_nr "backup subflow unused, link failure" 2 2 2
+	chk_add_nr 1 1
+	chk_link_usage $ns2 ns2eth3 $cinsent 0
+
+	# 2 lossy links after half transfer, backup will get half of
+	# the traffic
+	reset
+	init_shapers
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow,backup
+	export FAILING_LINKS="1 2"
+	run_tests $ns1 $ns2 10.0.1.1 1
+	chk_join_nr "backup flow used, multi links fail" 2 2 2
+	chk_add_nr 1 1
+	chk_stale_nr $ns2 2 4 2
+	chk_link_usage $ns2 ns2eth3 $cinsent 50
+
+	# use a backup subflow with the first subflow on a lossy link
+	# for bidirectional transfer
+	reset
+	init_shapers
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow,backup
+	run_tests $ns1 $ns2 10.0.1.1 2
+	chk_join_nr "backup flow used, bidi, link failure" 2 2 2
+	chk_add_nr 1 1
+	chk_stale_nr $ns2 1 -1 2
+	chk_link_usage $ns2 ns2eth3 $cinsent 50
 }
 
 add_addr_timeout_tests()
-- 
2.32.0

