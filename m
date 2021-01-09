Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4B32EFC74
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAIAvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:51:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:32283 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbhAIAvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:51:17 -0500
IronPort-SDR: JdEZb/c6HsrXPuEX1NR355lh+DPOP5CUkvl6MrkmxyVSb7uVRQrGkI2Gb69vaS21nt6ApqOzeT
 T3mOxG5X2VNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771959"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771959"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:10 -0800
IronPort-SDR: xF1f8kWuMf7ER3c58hvz0Oo9B28BJ2cW9IzB6/zKKIUi17F5dmFd6X9MwdUyW4GUnkrriUUqdl
 T0sxGJVL+Fcg==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124505"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] selftests: mptcp: add the MP_PRIO testcases
Date:   Fri,  8 Jan 2021 16:48:02 -0800
Message-Id: <20210109004802.341602-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the MP_PRIO testcases:

Add a new argument bkup for run_tests and do_transfer, it can be set as
"backup" or "nobackup", the default value is "".

Add a new function chk_prio_nr to check the MP_PRIO related MIB counters.

The output looks like this:

29 single subflow, backup      syn[ ok ] - synack[ ok ] - ack[ ok ]
                               ptx[ ok ] - prx   [ ok ]
30 single address, backup      syn[ ok ] - synack[ ok ] - ack[ ok ]
                               add[ ok ] - echo  [ ok ]
                               ptx[ ok ] - prx   [ ok ]

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 72 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 9aa9624cff97..f74cd993b168 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -212,6 +212,7 @@ do_transfer()
 	rm_nr_ns1="$7"
 	rm_nr_ns2="$8"
 	speed="$9"
+	bkup="${10}"
 
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
@@ -297,6 +298,18 @@ do_transfer()
 		fi
 	fi
 
+	if [ ! -z $bkup ]; then
+		sleep 1
+		for netns in "$ns1" "$ns2"; do
+			dump=(`ip netns exec $netns ./pm_nl_ctl dump`)
+			if [ ${#dump[@]} -gt 0 ]; then
+				addr=${dump[${#dump[@]} - 1]}
+				backup="ip netns exec $netns ./pm_nl_ctl set $addr flags $bkup"
+				$backup
+			fi
+		done
+	fi
+
 	wait $cpid
 	retc=$?
 	wait $spid
@@ -358,6 +371,7 @@ run_tests()
 	rm_nr_ns1="${5:-0}"
 	rm_nr_ns2="${6:-0}"
 	speed="${7:-fast}"
+	bkup="${8:-""}"
 	lret=0
 	oldin=""
 
@@ -372,7 +386,7 @@ run_tests()
 	fi
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
-		${test_linkfail} ${rm_nr_ns1} ${rm_nr_ns2} ${speed}
+		${test_linkfail} ${rm_nr_ns1} ${rm_nr_ns2} ${speed} ${bkup}
 	lret=$?
 
 	if [ "$test_linkfail" -eq 1 ];then
@@ -509,6 +523,43 @@ chk_rm_nr()
 	fi
 }
 
+chk_prio_nr()
+{
+	local mp_prio_nr_tx=$1
+	local mp_prio_nr_rx=$2
+	local count
+	local dump_stats
+
+	printf "%-39s %s" " " "ptx"
+	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioTx | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$mp_prio_nr_tx" ]; then
+		echo "[fail] got $count MP_PRIO[s] TX expected $mp_prio_nr_tx"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - prx   "
+	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioRx | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$mp_prio_nr_rx" ]; then
+		echo "[fail] got $count MP_PRIO[s] RX expected $mp_prio_nr_rx"
+		ret=1
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	if [ "${dump_stats}" = 1 ]; then
+		echo Server ns stats
+		ip netns exec $ns1 nstat -as | grep MPTcp
+		echo Client ns stats
+		ip netns exec $ns2 nstat -as | grep MPTcp
+	fi
+}
+
 sin=$(mktemp)
 sout=$(mktemp)
 cin=$(mktemp)
@@ -739,6 +790,25 @@ chk_join_nr "remove subflow and signal IPv6" 2 2 2
 chk_add_nr 1 1
 chk_rm_nr 1 1
 
+# single subflow, backup
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
+run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
+chk_join_nr "single subflow, backup" 1 1 1
+chk_prio_nr 0 1
+
+# single address, backup
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+chk_join_nr "single address, backup" 1 1 1
+chk_add_nr 1 1
+chk_prio_nr 1 0
+
 # single subflow, syncookies
 reset_with_cookies
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.30.0

