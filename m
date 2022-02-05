Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765114AA4D7
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378627AbiBEADr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:47 -0500
Received: from mga17.intel.com ([192.55.52.151]:46961 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378614AbiBEADo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019424; x=1675555424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WJ3o9djb7RDjLLnxwYDfL3OM/Q/wnk57yusoHFYWrrs=;
  b=iimgdW+dWfPUjs9oxs6n/gzw+gF9E2Y1UdOCW1rQEIoZNl+EPZXpzD78
   jlnTdqSHb2C3rYaYIhtDf2UO6+E0++TndrKWc/CjixORKMyilECoB+d8L
   wYwbXuJDjdlIEypGFr4ywm1ghUT65AJIeiR/6EV/7EQdsGd5Dm2r4cLZ0
   b75GF0c7G1oSItiWKRZra50RE+Zb3pKwKhMHtoSxkFqRhBaUCBbprKEgD
   1KRP2PIf73FI0bILcT0gXto0if0vaDoc0srA7LAq3mMqx/60e2LDXiRa3
   RpNcGBPZlThllRG80cSvSzbD6UIQw7cDeM5JG9LYw96ifb30e/aVxZuiF
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115089"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115089"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097520"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/9] selftests: mptcp: add ip mptcp wrappers
Date:   Fri,  4 Feb 2022 16:03:32 -0800
Message-Id: <20220205000337.187292-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added four basic 'ip mptcp' wrappers:

pm_nl_set_limits()
pm_nl_add_endpoint()
pm_nl_del_endpoint()
pm_nl_flush_endpoint().

Wrapped the PM netlink commands 'ip mptcp' and 'pm_nl_ctl' in them, and
used a new argument 'ip_mptcp' to choose which one to use for setting the
PM limits, adding or deleting the PM endpoint.

Used the wrappers in all the selftests in mptcp_join.sh instead of using
the pm_nl_ctl commands directly.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 737 ++++++++++--------
 1 file changed, 407 insertions(+), 330 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index eb945cebbd6d..6ca6ed7336d0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -15,6 +15,7 @@ timeout_test=$((timeout_poll * 2 + 1))
 mptcp_connect=""
 capture=0
 checksum=0
+ip_mptcp=0
 do_all_tests=1
 
 TEST_COUNT=0
@@ -288,6 +289,82 @@ wait_rm_addr()
 	done
 }
 
+pm_nl_set_limits()
+{
+	local ns=$1
+	local addrs=$2
+	local subflows=$3
+
+	if [ $ip_mptcp -eq 1 ]; then
+		ip -n $ns mptcp limits set add_addr_accepted $addrs subflows $subflows
+	else
+		ip netns exec $ns ./pm_nl_ctl limits $addrs $subflows
+	fi
+}
+
+pm_nl_add_endpoint()
+{
+	local ns=$1
+	local addr=$2
+	local flags
+	local port
+	local dev
+	local id
+	local nr=2
+
+	for p in $@
+	do
+		if [ $p = "flags" ]; then
+			eval _flags=\$"$nr"
+			[ ! -z $_flags ]; flags="flags $_flags"
+		fi
+		if [ $p = "dev" ]; then
+			eval _dev=\$"$nr"
+			[ ! -z $_dev ]; dev="dev $_dev"
+		fi
+		if [ $p = "id" ]; then
+			eval _id=\$"$nr"
+			[ ! -z $_id ]; id="id $_id"
+		fi
+		if [ $p = "port" ]; then
+			eval _port=\$"$nr"
+			[ ! -z $_port ]; port="port $_port"
+		fi
+
+		let nr+=1
+	done
+
+	if [ $ip_mptcp -eq 1 ]; then
+		ip -n $ns mptcp endpoint add $addr ${_flags//","/" "} $dev $id $port
+	else
+		ip netns exec $ns ./pm_nl_ctl add $addr $flags $dev $id $port
+	fi
+}
+
+pm_nl_del_endpoint()
+{
+	local ns=$1
+	local id=$2
+	local addr=$3
+
+	if [ $ip_mptcp -eq 1 ]; then
+		ip -n $ns mptcp endpoint delete id $id $addr
+	else
+		ip netns exec $ns ./pm_nl_ctl del $id $addr
+	fi
+}
+
+pm_nl_flush_endpoint()
+{
+	local ns=$1
+
+	if [ $ip_mptcp -eq 1 ]; then
+		ip -n $ns mptcp endpoint flush
+	else
+		ip netns exec $ns ./pm_nl_ctl flush
+	fi
+}
+
 do_transfer()
 {
 	listener_ns="$1"
@@ -388,7 +465,7 @@ do_transfer()
 			else
 				addr="10.0.$counter.1"
 			fi
-			ip netns exec $ns1 ./pm_nl_ctl add $addr flags signal
+			pm_nl_add_endpoint $ns1 $addr flags signal
 			let counter+=1
 			let add_nr_ns1-=1
 		done
@@ -403,16 +480,16 @@ do_transfer()
 				do
 					id=${dump[$pos]}
 					rm_addr=$(rm_addr_count ${connector_ns})
-					ip netns exec ${listener_ns} ./pm_nl_ctl del $id
+					pm_nl_del_endpoint ${listener_ns} $id
 					wait_rm_addr ${connector_ns} ${rm_addr}
 					let counter+=1
 					let pos+=5
 				done
 			fi
 		elif [ $rm_nr_ns1 -eq 8 ]; then
-			ip netns exec ${listener_ns} ./pm_nl_ctl flush
+			pm_nl_flush_endpoint ${listener_ns}
 		elif [ $rm_nr_ns1 -eq 9 ]; then
-			ip netns exec ${listener_ns} ./pm_nl_ctl del 0 ${connect_addr}
+			pm_nl_del_endpoint ${listener_ns} 0 ${connect_addr}
 		fi
 	fi
 
@@ -436,7 +513,7 @@ do_transfer()
 			else
 				addr="10.0.$counter.2"
 			fi
-			ip netns exec $ns2 ./pm_nl_ctl add $addr flags $flags
+			pm_nl_add_endpoint $ns2 $addr flags $flags
 			let counter+=1
 			let add_nr_ns2-=1
 		done
@@ -452,14 +529,14 @@ do_transfer()
 					# rm_addr are serialized, allow the previous one to complete
 					id=${dump[$pos]}
 					rm_addr=$(rm_addr_count ${listener_ns})
-					ip netns exec ${connector_ns} ./pm_nl_ctl del $id
+					pm_nl_del_endpoint ${connector_ns} $id
 					wait_rm_addr ${listener_ns} ${rm_addr}
 					let counter+=1
 					let pos+=5
 				done
 			fi
 		elif [ $rm_nr_ns2 -eq 8 ]; then
-			ip netns exec ${connector_ns} ./pm_nl_ctl flush
+			pm_nl_flush_endpoint ${connector_ns}
 		elif [ $rm_nr_ns2 -eq 9 ]; then
 			local addr
 			if is_v6 "${connect_addr}"; then
@@ -467,7 +544,7 @@ do_transfer()
 			else
 				addr="10.0.1.2"
 			fi
-			ip netns exec ${connector_ns} ./pm_nl_ctl del 0 $addr
+			pm_nl_del_endpoint ${connector_ns} 0 $addr
 		fi
 	fi
 
@@ -1001,51 +1078,51 @@ subflows_tests()
 
 	# subflow limited by client
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 0
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 0
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 0
+	pm_nl_set_limits $ns2 0 0
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow, limited by client" 0 0 0
 
 	# subflow limited by server
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 0
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 0
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow, limited by server" 1 1 0
 
 	# subflow
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow" 1 1 1
 
 	# multiple subflows
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple subflows" 2 2 2
 
 	# multiple subflows limited by server
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple subflows, limited by server" 2 2 1
 
 	# single subflow, dev
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow dev ns2eth3
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow dev ns2eth3
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow, dev" 1 1 1
 }
@@ -1055,28 +1132,28 @@ subflows_error_tests()
 	# If a single subflow is configured, and matches the MPC src
 	# address, no additional subflow should be created
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.1.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 	chk_join_nr "no MPC reuse with single endpoint" 0 0 0
 
 	# multiple subflows, with subflow creation error
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 	chk_join_nr "multi subflows, with failing subflow" 1 1 1
 
 	# multiple subflows, with subflow timeout on MPJ
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j DROP
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 	chk_join_nr "multi subflows, with subflow timeout" 1 1 1
@@ -1085,9 +1162,9 @@ subflows_error_tests()
 	# closed subflow (due to reset) is not reused if additional
 	# subflows are added later
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
 
@@ -1097,7 +1174,7 @@ subflows_error_tests()
 
 	# mpj subflow will be in TW after the reset
 	wait_for_tw $ns2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	wait
 
 	# additional subflow could be created only if the PM select
@@ -1109,16 +1186,16 @@ signal_address_tests()
 {
 	# add_address, unused
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "unused signal address" 0 0 0
 	chk_add_nr 1 1
 
 	# accept and use add_addr
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal address" 1 1 1
 	chk_add_nr 1 1
@@ -1128,59 +1205,59 @@ signal_address_tests()
 	# belong to different subnets or one of the listed local address could be
 	# used for 'add_addr' subflow
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflow and signal" 2 2 2
 	chk_add_nr 1 1
 
 	# accept and use add_addr with additional subflows
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple subflows and signal" 3 3 3
 	chk_add_nr 1 1
 
 	# signal addresses
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+	pm_nl_set_limits $ns2 3 3
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal addresses" 3 3 3
 	chk_add_nr 3 3
 
 	# signal invalid addresses
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+	pm_nl_set_limits $ns2 3 3
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal invalid addresses" 1 1 1
 	chk_add_nr 3 3
 
 	# signal addresses race test
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.1.2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
+	pm_nl_set_limits $ns1 4 4
+	pm_nl_set_limits $ns2 4 4
+	pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+	pm_nl_add_endpoint $ns2 10.0.1.2 flags signal
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags signal
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 
 	# the server will not signal the address terminating
@@ -1200,11 +1277,11 @@ link_failure_tests()
 	# active backup and link switch-over.
 	# Let's set some arbitrary (low) virtual link limits.
 	init_shapers
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 dev ns2eth4 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 1
 	chk_join_nr "multiple flows, signal, link failure" 3 3 3
 	chk_add_nr 1 1
@@ -1214,11 +1291,11 @@ link_failure_tests()
 	# for bidirectional transfer
 	reset
 	init_shapers
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 dev ns2eth4 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 2
 	chk_join_nr "multi flows, signal, bidi, link fail" 3 3 3
 	chk_add_nr 1 1
@@ -1228,11 +1305,11 @@ link_failure_tests()
 	# will never be used
 	reset
 	init_shapers
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+	pm_nl_set_limits $ns2 1 2
 	export FAILING_LINKS="1"
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow,backup
+	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 1
 	chk_join_nr "backup subflow unused, link failure" 2 2 2
 	chk_add_nr 1 1
@@ -1242,10 +1319,10 @@ link_failure_tests()
 	# the traffic
 	reset
 	init_shapers
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow,backup
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 	export FAILING_LINKS="1 2"
 	run_tests $ns1 $ns2 10.0.1.1 1
 	chk_join_nr "backup flow used, multi links fail" 2 2 2
@@ -1257,10 +1334,10 @@ link_failure_tests()
 	# for bidirectional transfer
 	reset
 	init_shapers
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 dev ns2eth3 flags subflow,backup
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 2
 	chk_join_nr "backup flow used, bidi, link failure" 2 2 2
 	chk_add_nr 1 1
@@ -1272,38 +1349,38 @@ add_addr_timeout_tests()
 {
 	# add_addr timeout
 	reset_with_add_addr_timeout
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 	chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
 	chk_add_nr 4 0
 
 	# add_addr timeout IPv6
 	reset_with_add_addr_timeout 6
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
 	chk_add_nr 4 0
 
 	# signal addresses timeout
 	reset_with_add_addr_timeout
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_set_limits $ns2 2 2
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 least
 	chk_join_nr "signal addresses, ADD_ADDR timeout" 2 2 2
 	chk_add_nr 8 0
 
 	# signal invalid addresses timeout
 	reset_with_add_addr_timeout
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_set_limits $ns2 2 2
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 least
 	chk_join_nr "invalid address, ADD_ADDR timeout" 1 1 1
 	chk_add_nr 8 0
@@ -1313,28 +1390,28 @@ remove_tests()
 {
 	# single subflow, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
 	chk_join_nr "remove single subflow" 1 1 1
 	chk_rm_nr 1 1
 
 	# multiple subflows, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
 	chk_join_nr "remove multiple subflows" 2 2 2
 	chk_rm_nr 2 2
 
 	# single address, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 	chk_join_nr "remove single address" 1 1 1
 	chk_add_nr 1 1
@@ -1342,10 +1419,10 @@ remove_tests()
 
 	# subflow and signal, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal" 2 2 2
 	chk_add_nr 1 1
@@ -1353,11 +1430,11 @@ remove_tests()
 
 	# subflows and signal, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
 	chk_join_nr "remove subflows and signal" 3 3 3
 	chk_add_nr 1 1
@@ -1365,11 +1442,11 @@ remove_tests()
 
 	# addresses remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal id 250
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+	pm_nl_set_limits $ns2 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
 	chk_join_nr "remove addresses" 3 3 3
 	chk_add_nr 3 3
@@ -1377,11 +1454,11 @@ remove_tests()
 
 	# invalid addresses remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+	pm_nl_set_limits $ns2 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
 	chk_join_nr "remove invalid addresses" 1 1 1
 	chk_add_nr 3 3
@@ -1389,11 +1466,11 @@ remove_tests()
 
 	# subflows and signal, flush
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 	chk_join_nr "flush subflows and signal" 3 3 3
 	chk_add_nr 1 1
@@ -1401,22 +1478,22 @@ remove_tests()
 
 	# subflows flush
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow id 150
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_set_limits $ns2 3 3
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow id 150
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 	chk_join_nr "flush subflows" 3 3 3
 	chk_rm_nr 3 3
 
 	# addresses flush
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal id 250
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+	pm_nl_set_limits $ns2 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 	chk_join_nr "flush addresses" 3 3 3
 	chk_add_nr 3 3
@@ -1424,11 +1501,11 @@ remove_tests()
 
 	# invalid addresses flush
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	pm_nl_set_limits $ns1 3 3
+	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+	pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+	pm_nl_set_limits $ns2 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
 	chk_join_nr "flush invalid addresses" 1 1 1
 	chk_add_nr 3 3
@@ -1436,18 +1513,18 @@ remove_tests()
 
 	# remove id 0 subflow
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 0 -9 slow
 	chk_join_nr "remove id 0 subflow" 1 1 1
 	chk_rm_nr 1 1
 
 	# remove id 0 address
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 -9 0 slow
 	chk_join_nr "remove id 0 address" 1 1 1
 	chk_add_nr 1 1
@@ -1458,37 +1535,37 @@ add_tests()
 {
 	# add single subflow
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
 	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
 	chk_join_nr "add single subflow" 1 1 1
 
 	# add signal address
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
 	chk_join_nr "add signal address" 1 1 1
 	chk_add_nr 1 1
 
 	# add multiple subflows
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
 	run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
 	chk_join_nr "add multiple subflows" 2 2 2
 
 	# add multiple subflows IPv6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
 	chk_join_nr "add multiple subflows IPv6" 2 2 2
 
 	# add multiple addresses IPv6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 2 2
 	run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
 	chk_join_nr "add multiple addresses IPv6" 2 2 2
 	chk_add_nr 2 2
@@ -1498,33 +1575,33 @@ ipv6_tests()
 {
 	# subflow IPv6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "single subflow IPv6" 1 1 1
 
 	# add_address, unused IPv6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "unused signal address IPv6" 0 0 0
 	chk_add_nr 1 1
 
 	# signal address IPv6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
 	chk_join_nr "single address IPv6" 1 1 1
 	chk_add_nr 1 1
 
 	# single address IPv6, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
 	chk_join_nr "remove single address IPv6" 1 1 1
 	chk_add_nr 1 1
@@ -1532,10 +1609,10 @@ ipv6_tests()
 
 	# subflow and signal IPv6, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 dev ns2eth3 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal IPv6" 2 2 2
 	chk_add_nr 1 1
@@ -1546,76 +1623,76 @@ v4mapped_tests()
 {
 	# subflow IPv4-mapped to IPv4-mapped
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
 	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
 	chk_join_nr "single subflow IPv4-mapped" 1 1 1
 
 	# signal address IPv4-mapped with IPv4-mapped sk
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
 	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
 	chk_join_nr "signal address IPv4-mapped" 1 1 1
 	chk_add_nr 1 1
 
 	# subflow v4-map-v6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
 	chk_join_nr "single subflow v4-map-v6" 1 1 1
 
 	# signal address v4-map-v6
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
 	chk_join_nr "signal address v4-map-v6" 1 1 1
 	chk_add_nr 1 1
 
 	# subflow v6-map-v4
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow v6-map-v4" 1 1 1
 
 	# signal address v6-map-v4
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal address v6-map-v4" 1 1 1
 	chk_add_nr 1 1
 
 	# no subflow IPv6 to v4 address
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 dead:beef:2::2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
 
 	# no subflow IPv6 to v4 address even if v6 has a valid v4 at the end
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 dead:beef:2::10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
 
 	# no subflow IPv4 to v6 address, no need to slow down too then
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 dead:beef:1::1
 	chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
 }
@@ -1624,18 +1701,18 @@ backup_tests()
 {
 	# single subflow, backup
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
 	chk_join_nr "single subflow, backup" 1 1 1
 	chk_prio_nr 0 1
 
 	# single address, backup
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
 	chk_join_nr "single address, backup" 1 1 1
 	chk_add_nr 1 1
@@ -1643,9 +1720,9 @@ backup_tests()
 
 	# single address with port, backup
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
 	chk_join_nr "single address with port, backup" 1 1 1
 	chk_add_nr 1 1
@@ -1656,28 +1733,28 @@ add_addr_ports_tests()
 {
 	# signal address with port
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal address with port" 1 1 1
 	chk_add_nr 1 1 1
 
 	# subflow and signal with port
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflow and signal with port" 2 2 2
 	chk_add_nr 1 1 1
 
 	# single address with port, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_set_limits $ns2 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 	chk_join_nr "remove single address with port" 1 1 1
 	chk_add_nr 1 1 1
@@ -1685,10 +1762,10 @@ add_addr_ports_tests()
 
 	# subflow and signal with port, remove
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal with port" 2 2 2
 	chk_add_nr 1 1 1
@@ -1696,11 +1773,11 @@ add_addr_ports_tests()
 
 	# subflows and signal with port, flush
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -2 slow
 	chk_join_nr "flush subflows and signal with port" 3 3 3
 	chk_add_nr 1 1
@@ -1708,20 +1785,20 @@ add_addr_ports_tests()
 
 	# multiple addresses with port
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10100
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10100
+	pm_nl_set_limits $ns2 2 2
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple addresses with port" 2 2 2
 	chk_add_nr 2 2 2
 
 	# multiple addresses with ports
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10101
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10101
+	pm_nl_set_limits $ns2 2 2
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple addresses with ports" 2 2 2
 	chk_add_nr 2 2 2
@@ -1731,56 +1808,56 @@ syncookies_tests()
 {
 	# single subflow, syncookies
 	reset_with_cookies
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow with syn cookies" 1 1 1
 
 	# multiple subflows with syn cookies
 	reset_with_cookies
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple subflows with syn cookies" 2 2 2
 
 	# multiple subflows limited by server
 	reset_with_cookies
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflows limited by server w cookies" 2 1 1
 
 	# test signal address with cookies
 	reset_with_cookies
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal address with syn cookies" 1 1 1
 	chk_add_nr 1 1
 
 	# test cookie with subflow and signal
 	reset_with_cookies
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 0 2
+	pm_nl_set_limits $ns2 1 2
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflow and signal w cookies" 2 2 2
 	chk_add_nr 1 1
 
 	# accept and use add_addr with additional subflows
 	reset_with_cookies
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	pm_nl_set_limits $ns1 0 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflows and signal w. cookies" 3 3 3
 	chk_add_nr 1 1
@@ -1790,29 +1867,29 @@ checksum_tests()
 {
 	# checksum test 0 0
 	reset_with_checksum 0 0
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_csum_nr "checksum test 0 0"
 
 	# checksum test 1 1
 	reset_with_checksum 1 1
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_csum_nr "checksum test 1 1"
 
 	# checksum test 0 1
 	reset_with_checksum 0 1
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_csum_nr "checksum test 0 1"
 
 	# checksum test 1 0
 	reset_with_checksum 1 0
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	pm_nl_set_limits $ns1 0 1
+	pm_nl_set_limits $ns2 0 1
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_csum_nr "checksum test 1 0"
 }
@@ -1821,26 +1898,26 @@ deny_join_id0_tests()
 {
 	# subflow allow join id0 ns1
 	reset_with_allow_join_id0 1 0
-	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 1 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow allow join id0 ns1" 1 1 1
 
 	# subflow allow join id0 ns2
 	reset_with_allow_join_id0 0 1
-	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 1 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "single subflow allow join id0 ns2" 0 0 0
 
 	# signal address allow join id0 ns1
 	# ADD_ADDRs are not affected by allow_join_id0 value.
 	reset_with_allow_join_id0 1 0
-	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 1 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal address allow join id0 ns1" 1 1 1
 	chk_add_nr 1 1
@@ -1848,28 +1925,28 @@ deny_join_id0_tests()
 	# signal address allow join id0 ns2
 	# ADD_ADDRs are not affected by allow_join_id0 value.
 	reset_with_allow_join_id0 0 1
-	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 1 1
+	pm_nl_set_limits $ns2 1 1
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "signal address allow join id0 ns2" 1 1 1
 	chk_add_nr 1 1
 
 	# subflow and address allow join id0 ns1
 	reset_with_allow_join_id0 1 0
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_set_limits $ns2 2 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflow and address allow join id0 1" 2 2 2
 
 	# subflow and address allow join id0 ns2
 	reset_with_allow_join_id0 0 1
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_set_limits $ns2 2 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflow and address allow join id0 2" 1 1 1
 }
@@ -1880,10 +1957,10 @@ fullmesh_tests()
 	# 2 fullmesh addrs in ns2, added before the connection,
 	# 1 non-fullmesh addr in ns1, added during the connection.
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 0 4
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 4
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow,fullmesh
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,fullmesh
+	pm_nl_set_limits $ns1 0 4
+	pm_nl_set_limits $ns2 1 4
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,fullmesh
+	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,fullmesh
 	run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
 	chk_join_nr "fullmesh test 2x1" 4 4 4
 	chk_add_nr 1 1
@@ -1892,9 +1969,9 @@ fullmesh_tests()
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 1 fullmesh addr in ns2, added during the connection.
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 1 3
+	pm_nl_set_limits $ns2 1 3
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow
 	chk_join_nr "fullmesh test 1x1" 3 3 3
 	chk_add_nr 1 1
@@ -1903,9 +1980,9 @@ fullmesh_tests()
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 2 fullmesh addrs in ns2, added during the connection.
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 5
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 5
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 2 5
+	pm_nl_set_limits $ns2 1 5
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
 	chk_join_nr "fullmesh test 1x2" 5 5 5
 	chk_add_nr 1 1
@@ -1915,36 +1992,36 @@ fullmesh_tests()
 	# 2 fullmesh addrs in ns2, added during the connection,
 	# limit max_subflows to 4.
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 2 4
-	ip netns exec $ns2 ./pm_nl_ctl limits 1 4
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	pm_nl_set_limits $ns1 2 4
+	pm_nl_set_limits $ns2 1 4
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
 	chk_join_nr "fullmesh test 1x2, limited" 4 4 4
 	chk_add_nr 1 1
 
 	# set fullmesh flag
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	pm_nl_set_limits $ns1 4 4
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
+	pm_nl_set_limits $ns2 4 4
 	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow fullmesh
 	chk_join_nr "set fullmesh flag test" 2 2 2
 	chk_rm_nr 0 1
 
 	# set nofullmesh flag
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags subflow,fullmesh
-	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	pm_nl_set_limits $ns1 4 4
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow,fullmesh
+	pm_nl_set_limits $ns2 4 4
 	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow nofullmesh
 	chk_join_nr "set nofullmesh flag test" 2 2 2
 	chk_rm_nr 0 1
 
 	# set backup,fullmesh flags
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	pm_nl_set_limits $ns1 4 4
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
+	pm_nl_set_limits $ns2 4 4
 	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow backup,fullmesh
 	chk_join_nr "set backup,fullmesh flags test" 2 2 2
 	chk_prio_nr 0 1
@@ -1952,9 +2029,9 @@ fullmesh_tests()
 
 	# set nobackup,nofullmesh flags
 	reset
-	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow,backup,fullmesh
+	pm_nl_set_limits $ns1 4 4
+	pm_nl_set_limits $ns2 4 4
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup,fullmesh
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup,nofullmesh
 	chk_join_nr "set nobackup,nofullmesh flags test" 2 2 2
 	chk_prio_nr 0 1
-- 
2.35.1

