Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C022D6BA7
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390796AbgLJXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:11:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:9089 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388801AbgLJWal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:30:41 -0500
IronPort-SDR: hCWuCWZKvXhRp+610u0yxw5gFVz+8/Dae+8i7B19+2G1+tzilytwlq77rlI86V5GBS1zRdELhY
 YYxZW891FzVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776483"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776483"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
IronPort-SDR: 116MGG3TsU1cEbjdfbSBPwat1pitLPGCzsA0uU7C1pl3Nz5/WjWArKPSIbAMbxkQ/mxSX49Ui6
 5e/pA/yYW41g==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703753"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/9] selftests: mptcp: add the flush addrs testcase
Date:   Thu, 10 Dec 2020 14:25:00 -0800
Message-Id: <20201210222506.222251-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the flush addrs testcase. In do_transfer, if the number
of removing addresses is less than 8, use the del addr command to remove
the addresses one by one. If the number is more than 8, use the flush addrs
command to remove the addresses.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 50 +++++++++++++------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0eae628d1ffd..9aa9624cff97 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -264,27 +264,37 @@ do_transfer()
 	cpid=$!
 
 	if [ $rm_nr_ns1 -gt 0 ]; then
-		counter=1
-		sleep 1
+		if [ $rm_nr_ns1 -lt 8 ]; then
+			counter=1
+			sleep 1
 
-		while [ $counter -le $rm_nr_ns1 ]
-		do
-			ip netns exec ${listener_ns} ./pm_nl_ctl del $counter
+			while [ $counter -le $rm_nr_ns1 ]
+			do
+				ip netns exec ${listener_ns} ./pm_nl_ctl del $counter
+				sleep 1
+				let counter+=1
+			done
+		else
 			sleep 1
-			let counter+=1
-		done
+			ip netns exec ${listener_ns} ./pm_nl_ctl flush
+		fi
 	fi
 
 	if [ $rm_nr_ns2 -gt 0 ]; then
-		counter=1
-		sleep 1
+		if [ $rm_nr_ns2 -lt 8 ]; then
+			counter=1
+			sleep 1
 
-		while [ $counter -le $rm_nr_ns2 ]
-		do
-			ip netns exec ${connector_ns} ./pm_nl_ctl del $counter
+			while [ $counter -le $rm_nr_ns2 ]
+			do
+				ip netns exec ${connector_ns} ./pm_nl_ctl del $counter
+				sleep 1
+				let counter+=1
+			done
+		else
 			sleep 1
-			let counter+=1
-		done
+			ip netns exec ${connector_ns} ./pm_nl_ctl flush
+		fi
 	fi
 
 	wait $cpid
@@ -663,6 +673,18 @@ chk_join_nr "remove subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
 
+# subflows and signal, flush
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1 0 8 8 slow
+chk_join_nr "flush subflows and signal" 3 3 3
+chk_add_nr 1 1
+chk_rm_nr 2 2
+
 # subflow IPv6
 reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.29.2

