Return-Path: <netdev+bounces-3434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3867071CF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CE86281733
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3754449AC;
	Wed, 17 May 2023 19:16:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1497B34CC5;
	Wed, 17 May 2023 19:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A537BC433AA;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684350995;
	bh=p0EvOzBCztilHL/SDblWqqPkxHoLTNRrTlbvKEjqEQs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wn9xLqJumVoWoHFjJdhePzT07lUrdklIn3rJEyuflfVnGGJu7h4N2NQdRRg1FXKh1
	 Uhsi134FtxG05IeXWrmKSDRCQJbslo7Ehq797p2tAiuR2ftZWjGxLWxSgY5o02L2un
	 DwM/pfk38Qs5+NcfaQWeSFpg/VgEzffKnoqTWa1NdM0f/heYyU9wxz6irRzVCWTjOW
	 DZDf/tZ3vEEgGo4G9HnSVYjv8dRkDWn2B5Ur4ZBYxxQBdFRYrsi1a1z7+fwRIQmzKs
	 36102DDwyEZcg7t2w/KWNYAFYoFk2VgLLRbRyu4PiJs1dyEvVm80YWoHhSy8Lzjym9
	 ZY+ypDwG/fEag==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 17 May 2023 12:16:18 -0700
Subject: [PATCH net-next 5/5] selftests: mptcp: centralize stats dumping
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230516-send-net-next-20220516-v1-5-e91822b7b6e0@kernel.org>
References: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
In-Reply-To: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

If a test case fails, the mptcp_join.sh script can dump the
netns MIBs multiple times, leading to confusing output.

Let's dump such info only once per test-case, when needed.
This additionally allow removing some code duplication.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 66 ++-----------------------
 1 file changed, 5 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index ca5bd2c3434a..e74d3074ef90 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -34,6 +34,7 @@ evts_ns1=""
 evts_ns2=""
 evts_ns1_pid=0
 evts_ns2_pid=0
+stats_dumped=0
 
 declare -A all_tests
 declare -a only_tests_ids
@@ -87,6 +88,7 @@ init_partial()
 		fi
 	done
 
+	stats_dumped=0
 	check_invert=0
 	validate_checksum=$checksum
 	FAILING_LINKS=""
@@ -347,6 +349,9 @@ fail_test()
 {
 	ret=1
 	failed_tests[${TEST_COUNT}]="${TEST_NAME}"
+
+	[ "${stats_dumped}" = 0 ] && dump_stats
+	stats_dumped=1
 }
 
 get_failed_tests_ids()
@@ -1120,7 +1125,6 @@ chk_csum_nr()
 	local csum_ns1=${1:-0}
 	local csum_ns2=${2:-0}
 	local count
-	local dump_stats
 	local extra_msg=""
 	local allow_multi_errors_ns1=0
 	local allow_multi_errors_ns2=0
@@ -1144,7 +1148,6 @@ chk_csum_nr()
 	   { [ "$count" -lt $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 1 ]; }; then
 		echo "[fail] got $count data checksum error[s] expected $csum_ns1"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1158,11 +1161,9 @@ chk_csum_nr()
 	   { [ "$count" -lt $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 1 ]; }; then
 		echo "[fail] got $count data checksum error[s] expected $csum_ns2"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
-	[ "${dump_stats}" = 1 ] && dump_stats
 
 	echo "$extra_msg"
 }
@@ -1173,7 +1174,6 @@ chk_fail_nr()
 	local fail_rx=$2
 	local ns_invert=${3:-""}
 	local count
-	local dump_stats
 	local ns_tx=$ns1
 	local ns_rx=$ns2
 	local extra_msg=""
@@ -1205,7 +1205,6 @@ chk_fail_nr()
 	   { [ "$count" -gt "$fail_tx" ] && [ $allow_tx_lost -eq 1 ]; }; then
 		echo "[fail] got $count MP_FAIL[s] TX expected $fail_tx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1220,13 +1219,10 @@ chk_fail_nr()
 	   { [ "$count" -gt "$fail_rx" ] && [ $allow_rx_lost -eq 1 ]; }; then
 		echo "[fail] got $count MP_FAIL[s] RX expected $fail_rx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && dump_stats
-
 	echo "$extra_msg"
 }
 
@@ -1236,7 +1232,6 @@ chk_fclose_nr()
 	local fclose_rx=$2
 	local ns_invert=$3
 	local count
-	local dump_stats
 	local ns_tx=$ns2
 	local ns_rx=$ns1
 	local extra_msg="   "
@@ -1254,7 +1249,6 @@ chk_fclose_nr()
 	if [ "$count" != "$fclose_tx" ]; then
 		echo "[fail] got $count MP_FASTCLOSE[s] TX expected $fclose_tx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1266,13 +1260,10 @@ chk_fclose_nr()
 	if [ "$count" != "$fclose_rx" ]; then
 		echo "[fail] got $count MP_FASTCLOSE[s] RX expected $fclose_rx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && dump_stats
-
 	echo "$extra_msg"
 }
 
@@ -1282,7 +1273,6 @@ chk_rst_nr()
 	local rst_rx=$2
 	local ns_invert=${3:-""}
 	local count
-	local dump_stats
 	local ns_tx=$ns1
 	local ns_rx=$ns2
 	local extra_msg=""
@@ -1299,7 +1289,6 @@ chk_rst_nr()
 	if [ $count -lt $rst_tx ]; then
 		echo "[fail] got $count MP_RST[s] TX expected $rst_tx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1310,13 +1299,10 @@ chk_rst_nr()
 	if [ "$count" -lt "$rst_rx" ]; then
 		echo "[fail] got $count MP_RST[s] RX expected $rst_rx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && dump_stats
-
 	echo "$extra_msg"
 }
 
@@ -1325,7 +1311,6 @@ chk_infi_nr()
 	local infi_tx=$1
 	local infi_rx=$2
 	local count
-	local dump_stats
 
 	printf "%-${nr_blank}s %s" " " "itx"
 	count=$(ip netns exec $ns2 nstat -as | grep InfiniteMapTx | awk '{print $2}')
@@ -1333,7 +1318,6 @@ chk_infi_nr()
 	if [ "$count" != "$infi_tx" ]; then
 		echo "[fail] got $count infinite map[s] TX expected $infi_tx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1344,12 +1328,9 @@ chk_infi_nr()
 	if [ "$count" != "$infi_rx" ]; then
 		echo "[fail] got $count infinite map[s] RX expected $infi_rx"
 		fail_test
-		dump_stats=1
 	else
 		echo "[ ok ]"
 	fi
-
-	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
 chk_join_nr()
@@ -1364,7 +1345,6 @@ chk_join_nr()
 	local infi_nr=${8:-0}
 	local corrupted_pkts=${9:-0}
 	local count
-	local dump_stats
 	local with_cookie
 	local title="${TEST_NAME}"
 
@@ -1378,7 +1358,6 @@ chk_join_nr()
 	if [ "$count" != "$syn_nr" ]; then
 		echo "[fail] got $count JOIN[s] syn expected $syn_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1396,7 +1375,6 @@ chk_join_nr()
 		else
 			echo "[fail] got $count JOIN[s] synack expected $syn_ack_nr"
 			fail_test
-			dump_stats=1
 		fi
 	else
 		echo -n "[ ok ]"
@@ -1408,11 +1386,9 @@ chk_join_nr()
 	if [ "$count" != "$ack_nr" ]; then
 		echo "[fail] got $count JOIN[s] ack expected $ack_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo "[ ok ]"
 	fi
-	[ "${dump_stats}" = 1 ] && dump_stats
 	if [ $validate_checksum -eq 1 ]; then
 		chk_csum_nr $csum_ns1 $csum_ns2
 		chk_fail_nr $fail_nr $fail_nr
@@ -1472,7 +1448,6 @@ chk_add_nr()
 	local mis_syn_nr=${7:-0}
 	local mis_ack_nr=${8:-0}
 	local count
-	local dump_stats
 	local timeout
 
 	timeout=$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
@@ -1486,7 +1461,6 @@ chk_add_nr()
 	if [ "$count" != "$add_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -lt "$add_nr" ]; }; then
 		echo "[fail] got $count ADD_ADDR[s] expected $add_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1497,7 +1471,6 @@ chk_add_nr()
 	if [ "$count" != "$echo_nr" ]; then
 		echo "[fail] got $count ADD_ADDR echo[s] expected $echo_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1509,7 +1482,6 @@ chk_add_nr()
 		if [ "$count" != "$port_nr" ]; then
 			echo "[fail] got $count ADD_ADDR[s] with a port-number expected $port_nr"
 			fail_test
-			dump_stats=1
 		else
 			echo "[ ok ]"
 		fi
@@ -1522,7 +1494,6 @@ chk_add_nr()
 			echo "[fail] got $count JOIN[s] syn with a different \
 				port-number expected $syn_nr"
 			fail_test
-			dump_stats=1
 		else
 			echo -n "[ ok ]"
 		fi
@@ -1535,7 +1506,6 @@ chk_add_nr()
 			echo "[fail] got $count JOIN[s] synack with a different \
 				port-number expected $syn_ack_nr"
 			fail_test
-			dump_stats=1
 		else
 			echo -n "[ ok ]"
 		fi
@@ -1548,7 +1518,6 @@ chk_add_nr()
 			echo "[fail] got $count JOIN[s] ack with a different \
 				port-number expected $ack_nr"
 			fail_test
-			dump_stats=1
 		else
 			echo "[ ok ]"
 		fi
@@ -1561,7 +1530,6 @@ chk_add_nr()
 			echo "[fail] got $count JOIN[s] syn with a mismatched \
 				port-number expected $mis_syn_nr"
 			fail_test
-			dump_stats=1
 		else
 			echo -n "[ ok ]"
 		fi
@@ -1574,22 +1542,18 @@ chk_add_nr()
 			echo "[fail] got $count JOIN[s] ack with a mismatched \
 				port-number expected $mis_ack_nr"
 			fail_test
-			dump_stats=1
 		else
 			echo "[ ok ]"
 		fi
 	else
 		echo ""
 	fi
-
-	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
 chk_add_tx_nr()
 {
 	local add_tx_nr=$1
 	local echo_tx_nr=$2
-	local dump_stats
 	local timeout
 	local count
 
@@ -1604,7 +1568,6 @@ chk_add_tx_nr()
 	if [ "$count" != "$add_tx_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -lt "$add_tx_nr" ]; }; then
 		echo "[fail] got $count ADD_ADDR[s] TX, expected $add_tx_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1615,12 +1578,9 @@ chk_add_tx_nr()
 	if [ "$count" != "$echo_tx_nr" ]; then
 		echo "[fail] got $count ADD_ADDR echo[s] TX, expected $echo_tx_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo "[ ok ]"
 	fi
-
-	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
 chk_rm_nr()
@@ -1630,7 +1590,6 @@ chk_rm_nr()
 	local invert
 	local simult
 	local count
-	local dump_stats
 	local addr_ns=$ns1
 	local subflow_ns=$ns2
 	local extra_msg=""
@@ -1657,7 +1616,6 @@ chk_rm_nr()
 	if [ "$count" != "$rm_addr_nr" ]; then
 		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1681,20 +1639,16 @@ chk_rm_nr()
 		else
 			echo "[fail] got $count RM_SUBFLOW[s] expected in range [$rm_subflow_nr:$((rm_subflow_nr*2))]"
 			fail_test
-			dump_stats=1
 		fi
 		return
 	fi
 	if [ "$count" != "$rm_subflow_nr" ]; then
 		echo "[fail] got $count RM_SUBFLOW[s] expected $rm_subflow_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && dump_stats
-
 	echo "$extra_msg"
 }
 
@@ -1708,13 +1662,10 @@ chk_rm_tx_nr()
 	if [ "$count" != "$rm_addr_tx_nr" ]; then
 		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_tx_nr"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && dump_stats
-
 	echo "$extra_msg"
 }
 
@@ -1723,7 +1674,6 @@ chk_prio_nr()
 	local mp_prio_nr_tx=$1
 	local mp_prio_nr_rx=$2
 	local count
-	local dump_stats
 
 	printf "%-${nr_blank}s %s" " " "ptx"
 	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioTx | awk '{print $2}')
@@ -1731,7 +1681,6 @@ chk_prio_nr()
 	if [ "$count" != "$mp_prio_nr_tx" ]; then
 		echo "[fail] got $count MP_PRIO[s] TX expected $mp_prio_nr_tx"
 		fail_test
-		dump_stats=1
 	else
 		echo -n "[ ok ]"
 	fi
@@ -1742,12 +1691,9 @@ chk_prio_nr()
 	if [ "$count" != "$mp_prio_nr_rx" ]; then
 		echo "[fail] got $count MP_PRIO[s] RX expected $mp_prio_nr_rx"
 		fail_test
-		dump_stats=1
 	else
 		echo "[ ok ]"
 	fi
-
-	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
 chk_subflow_nr()
@@ -1779,7 +1725,6 @@ chk_subflow_nr()
 		ss -N $ns1 -tOni
 		ss -N $ns1 -tOni | grep token
 		ip -n $ns1 mptcp endpoint
-		dump_stats
 	fi
 }
 
@@ -1819,7 +1764,6 @@ chk_mptcp_info()
 	if [ "$dump_stats" = 1 ]; then
 		ss -N $ns1 -inmHM
 		ss -N $ns2 -inmHM
-		dump_stats
 	fi
 }
 

-- 
2.40.1


