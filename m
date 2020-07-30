Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78782338FF
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgG3T0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3T0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:26:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A006C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:26:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1ECQ-0003Xh-R3; Thu, 30 Jul 2020 21:26:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 9/9] selftests: mptcp: add test cases for mptcp join tests with syn cookies
Date:   Thu, 30 Jul 2020 21:25:58 +0200
Message-Id: <20200730192558.25697-10-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730192558.25697-1-fw@strlen.de>
References: <20200730192558.25697-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also add test cases with MP_JOIN when tcp_syncookies sysctl is 2 (i.e.,
syncookies are always-on).

While at it, also print the test number and add the test number
to the pcap files that can be generated optionally.

This makes it easier to match the pcap to the test case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 66 ++++++++++++++++++-
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index dd42c2f692d0..f39c1129ce5f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -72,6 +72,15 @@ reset()
 	init
 }
 
+reset_with_cookies()
+{
+	reset
+
+	for netns in "$ns1" "$ns2";do
+		ip netns exec $netns sysctl -q net.ipv4.tcp_syncookies=2
+	done
+}
+
 for arg in "$@"; do
 	if [ "$arg" = "-c" ]; then
 		capture=1
@@ -138,7 +147,7 @@ do_transfer()
 			capuser="-Z $SUDO_USER"
 		fi
 
-		capfile="mp_join-${listener_ns}.pcap"
+		capfile=$(printf "mp_join-%02u-%s.pcap" "$TEST_COUNT" "${listener_ns}")
 
 		echo "Capturing traffic for test $TEST_COUNT into $capfile"
 		ip netns exec ${listener_ns} tcpdump -i any -s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
@@ -227,7 +236,7 @@ chk_join_nr()
 	local count
 	local dump_stats
 
-	printf "%-36s %s" "$msg" "syn"
+	printf "%02u %-36s %s" "$TEST_COUNT" "$msg" "syn"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$syn_nr" ]; then
@@ -354,4 +363,57 @@ ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "multiple subflows and signal" 3 3 3
 
+# single subflow, syncookies
+reset_with_cookies
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "single subflow with syn cookies" 1 1 1
+
+# multiple subflows with syn cookies
+reset_with_cookies
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "multiple subflows with syn cookies" 2 2 2
+
+# multiple subflows limited by server
+reset_with_cookies
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "subflows limited by server w cookies" 2 2 1
+
+# test signal address with cookies
+reset_with_cookies
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "signal address with syn cookies" 1 1 1
+
+# test cookie with subflow and signal
+reset_with_cookies
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "subflow and signal w cookies" 2 2 2
+
+# accept and use add_addr with additional subflows
+reset_with_cookies
+ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "subflows and signal w. cookies" 3 3 3
+
 exit $ret
-- 
2.26.2

