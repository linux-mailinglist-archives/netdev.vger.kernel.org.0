Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98688308327
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhA2BU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:20:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:6703 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhA2BUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:20:19 -0500
IronPort-SDR: 5WOxbu1MOCxqeM6F/U1PDo8bFjko/8v4WRdYjnd0kVPKR+qjAAihcwj3EE2AZ4ZgZxHntEEuUZ
 Ra2DhFKe/rqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430183"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430183"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:24 -0800
IronPort-SDR: KR9ShTex3HRrSOarTRhdZn3I/DH/YGyd4K4Bo9Crj7fNA5u3RnkavbQqzaZl3ikpDqlVexsR+g
 TApvYRUhUHaA==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538342"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:24 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 15/16] selftests: mptcp: add testcases for ADD_ADDR with port
Date:   Thu, 28 Jan 2021 17:11:14 -0800
Message-Id: <20210129011115.133953-16-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds testcases for ADD_ADDR with port and the related MIB
counters check in chk_add_nr. The output looks like this:

 24 signal address with port           syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       add[ ok ] - echo  [ ok ] - pt [ ok ]
                                       syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       syn[ ok ] - ack   [ ok ]
 25 subflow and signal with port       syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       add[ ok ] - echo  [ ok ] - pt [ ok ]
                                       syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       syn[ ok ] - ack   [ ok ]
 26 remove single address with port    syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       add[ ok ] - echo  [ ok ] - pt [ ok ]
                                       syn[ ok ] - synack[ ok ] - ack[ ok ]
                                       syn[ ok ] - ack   [ ok ]
                                       rm [ ok ] - sf    [ ok ]

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 160 +++++++++++++++++-
 1 file changed, 159 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index b5cd2a48831e..b8fd924033b1 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -487,6 +487,12 @@ chk_add_nr()
 {
 	local add_nr=$1
 	local echo_nr=$2
+	local port_nr=${3:-0}
+	local syn_nr=${4:-$port_nr}
+	local syn_ack_nr=${5:-$port_nr}
+	local ack_nr=${6:-$port_nr}
+	local mis_syn_nr=${7:-0}
+	local mis_ack_nr=${8:-0}
 	local count
 	local dump_stats
 
@@ -509,7 +515,87 @@ chk_add_nr()
 		ret=1
 		dump_stats=1
 	else
-		echo "[ ok ]"
+		echo -n "[ ok ]"
+	fi
+
+	if [ $port_nr -gt 0 ]; then
+		echo -n " - pt "
+		count=`ip netns exec $ns2 nstat -as | grep MPTcpExtPortAdd | awk '{print $2}'`
+		[ -z "$count" ] && count=0
+		if [ "$count" != "$port_nr" ]; then
+			echo "[fail] got $count ADD_ADDR[s] with a port-number expected $port_nr"
+			ret=1
+			dump_stats=1
+		else
+			echo "[ ok ]"
+		fi
+
+		printf "%-39s %s" " " "syn"
+		count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinPortSynRx |
+			awk '{print $2}'`
+		[ -z "$count" ] && count=0
+		if [ "$count" != "$syn_nr" ]; then
+			echo "[fail] got $count JOIN[s] syn with a different \
+				port-number expected $syn_nr"
+			ret=1
+			dump_stats=1
+		else
+			echo -n "[ ok ]"
+		fi
+
+		echo -n " - synack"
+		count=`ip netns exec $ns2 nstat -as | grep MPTcpExtMPJoinPortSynAckRx |
+			awk '{print $2}'`
+		[ -z "$count" ] && count=0
+		if [ "$count" != "$syn_ack_nr" ]; then
+			echo "[fail] got $count JOIN[s] synack with a different \
+				port-number expected $syn_ack_nr"
+			ret=1
+			dump_stats=1
+		else
+			echo -n "[ ok ]"
+		fi
+
+		echo -n " - ack"
+		count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinPortAckRx |
+			awk '{print $2}'`
+		[ -z "$count" ] && count=0
+		if [ "$count" != "$ack_nr" ]; then
+			echo "[fail] got $count JOIN[s] ack with a different \
+				port-number expected $ack_nr"
+			ret=1
+			dump_stats=1
+		else
+			echo "[ ok ]"
+		fi
+
+		printf "%-39s %s" " " "syn"
+		count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMismatchPortSynRx |
+			awk '{print $2}'`
+		[ -z "$count" ] && count=0
+		if [ "$count" != "$mis_syn_nr" ]; then
+			echo "[fail] got $count JOIN[s] syn with a mismatched \
+				port-number expected $mis_syn_nr"
+			ret=1
+			dump_stats=1
+		else
+			echo -n "[ ok ]"
+		fi
+
+		echo -n " - ack   "
+		count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMismatchPortAckRx |
+			awk '{print $2}'`
+		[ -z "$count" ] && count=0
+		if [ "$count" != "$mis_ack_nr" ]; then
+			echo "[fail] got $count JOIN[s] ack with a mismatched \
+				port-number expected $mis_ack_nr"
+			ret=1
+			dump_stats=1
+		else
+			echo "[ ok ]"
+		fi
+	else
+		echo ""
 	fi
 
 	if [ "${dump_stats}" = 1 ]; then
@@ -955,6 +1041,78 @@ chk_join_nr "single address, backup" 1 1 1
 chk_add_nr 1 1
 chk_prio_nr 1 0
 
+# signal address with port
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "signal address with port" 1 1 1
+chk_add_nr 1 1 1
+
+# subflow and signal with port
+reset
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "subflow and signal with port" 2 2 2
+chk_add_nr 1 1 1
+
+# single address with port, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
+chk_join_nr "remove single address with port" 1 1 1
+chk_add_nr 1 1 1
+chk_rm_nr 0 0
+
+# subflow and signal with port, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
+chk_join_nr "remove subflow and signal with port" 2 2 2
+chk_add_nr 1 1 1
+chk_rm_nr 1 1
+
+# subflows and signal with port, flush
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+chk_join_nr "flush subflows and signal with port" 3 3 3
+chk_add_nr 1 1
+chk_rm_nr 2 2
+
+# multiple addresses with port
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 2 2
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10100
+ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "multiple addresses with port" 2 2 2
+chk_add_nr 2 2 2
+
+# multiple addresses with ports
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 2 2
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10101
+ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "multiple addresses with ports" 2 2 2
+chk_add_nr 2 2 2
+
 # single subflow, syncookies
 reset_with_cookies
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.30.0

