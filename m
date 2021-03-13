Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3E7339AC7
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhCMBQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:1169 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: MDGgNrLR7CRT/XAz28fM3VA9tWOXX72cU7Elvc+gCRoSHAX3HVw8O6I+yB+v4DFQ4OEMNkKev3
 uXiSI/Yy30hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828249"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828249"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: 87cIs6kb7cDw9JDZQB+0pS0X5YCMP4cpu9W4DHDatXeX1KupUu9giHI8B/hWTy2hF78QDyUlFt
 zRavs1Lygskg==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197378"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/11] selftests: mptcp: add invert argument for chk_rm_nr
Date:   Fri, 12 Mar 2021 17:16:19 -0800
Message-Id: <20210313011621.211661-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Some of the removing testcases used two zeros as arguments for chk_rm_nr
like this: chk_rm_nr 0 0. This doesn't mean that no RM_ADDR has been sent.
It only means that RM_ADDR had been sent in the opposite direction that
chk_rm_nr is checking.

This patch added a new argument invert for chk_rm_nr to allow it can
check the RM_ADDR from the opposite direction.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 964db9ed544f..15b71ddee615 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -610,11 +610,22 @@ chk_rm_nr()
 {
 	local rm_addr_nr=$1
 	local rm_subflow_nr=$2
+	local invert=${3:-""}
 	local count
 	local dump_stats
+	local addr_ns
+	local subflow_ns
+
+	if [ -z $invert ]; then
+		addr_ns=$ns1
+		subflow_ns=$ns2
+	elif [ $invert = "invert" ]; then
+		addr_ns=$ns2
+		subflow_ns=$ns1
+	fi
 
 	printf "%-39s %s" " " "rm "
-	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtRmAddr | awk '{print $2}'`
+	count=`ip netns exec $addr_ns nstat -as | grep MPTcpExtRmAddr | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$rm_addr_nr" ]; then
 		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_nr"
@@ -625,7 +636,7 @@ chk_rm_nr()
 	fi
 
 	echo -n " - sf    "
-	count=`ip netns exec $ns2 nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}'`
+	count=`ip netns exec $subflow_ns nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$rm_subflow_nr" ]; then
 		echo "[fail] got $count RM_SUBFLOW[s] expected $rm_subflow_nr"
@@ -833,7 +844,7 @@ remove_tests()
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 	chk_join_nr "remove single address" 1 1 1
 	chk_add_nr 1 1
-	chk_rm_nr 0 0
+	chk_rm_nr 1 1 invert
 
 	# subflow and signal, remove
 	reset
@@ -945,7 +956,7 @@ ipv6_tests()
 	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
 	chk_join_nr "remove single address IPv6" 1 1 1
 	chk_add_nr 1 1
-	chk_rm_nr 0 0
+	chk_rm_nr 1 1 invert
 
 	# subflow and signal IPv6, remove
 	reset
@@ -1088,7 +1099,7 @@ add_addr_ports_tests()
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 	chk_join_nr "remove single address with port" 1 1 1
 	chk_add_nr 1 1 1
-	chk_rm_nr 0 0
+	chk_rm_nr 1 1 invert
 
 	# subflow and signal with port, remove
 	reset
-- 
2.30.2

