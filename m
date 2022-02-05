Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8604AA4DA
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378631AbiBEADs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:46958 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378618AbiBEADp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019425; x=1675555425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5K0GkzhiVhM0zd+gJclgiynKr72PcHxICX10QYU9dw0=;
  b=dcXJEfWmePvpfsVtd65j5YXqs811+RmKWO5ZHpwf+4JVyOHpztS8ZGwx
   /abKbZO/ZQTi7Sdv+zx8sM74PQEd7H+zgxH7NvngjfAtxdRyNOOqejuL+
   99PVaxJL0ZpnLGKtU5Oo+85HoMtbZMpW1/b/9bT7ezNSP2QFTTV3GiN1M
   ZtaI/rU7Yt2lGj82BozbE9J2WmmtFfapb3SNxIKz8QMXOmf/dXG2yFlg+
   FX6bNwdukP7Iym+fPNsLpOrr4urEk1RiudErmfym1fu8ZD+ZGzmO4ybq7
   eKnvPTVlGcegURf7Q4fmJceBBmXUWuVsV8Hw+I0nlZ3y2t/ZusV/g1Fl3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115092"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115092"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097521"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/9] selftests: mptcp: add wrapper for showing addrs
Date:   Fri,  4 Feb 2022 16:03:33 -0800
Message-Id: <20220205000337.187292-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch implemented a new function named pm_nl_show_endpoints(), wrapped
the PM netlink commands 'ip mptcp endpoint show' and 'pm_nl_ctl dump' in
it, used a new argument 'ip_mptcp' to choose which one to use to show all
the PM endpoints.

Used this wrapper in do_transfer() instead of using the pm_nl_ctl commands
directly.

The original 'pos+=5' in the remoing tests only works for the output of
'pm_nl_ctl show':

  id 1 flags subflow 10.0.1.1

It doesn't work for the output of 'ip mptcp endpoint show':

  10.0.1.1 id 1 subflow

So implemented a more flexible approach to get the address ID from the PM
dump output to fit for both commands.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 78 ++++++++++++-------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 6ca6ed7336d0..093eb27f5c6d 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -365,6 +365,17 @@ pm_nl_flush_endpoint()
 	fi
 }
 
+pm_nl_show_endpoints()
+{
+	local ns=$1
+
+	if [ $ip_mptcp -eq 1 ]; then
+		ip -n $ns mptcp endpoint show
+	else
+		ip netns exec $ns ./pm_nl_ctl dump
+	fi
+}
+
 do_transfer()
 {
 	listener_ns="$1"
@@ -472,20 +483,25 @@ do_transfer()
 	elif [ $addr_nr_ns1 -lt 0 ]; then
 		let rm_nr_ns1=-addr_nr_ns1
 		if [ $rm_nr_ns1 -lt 8 ]; then
-			counter=1
-			pos=1
-			dump=(`ip netns exec ${listener_ns} ./pm_nl_ctl dump`)
-			if [ ${#dump[@]} -gt 0 ]; then
-				while [ $counter -le $rm_nr_ns1 ]
-				do
-					id=${dump[$pos]}
-					rm_addr=$(rm_addr_count ${connector_ns})
-					pm_nl_del_endpoint ${listener_ns} $id
-					wait_rm_addr ${connector_ns} ${rm_addr}
-					let counter+=1
-					let pos+=5
+			counter=0
+			pm_nl_show_endpoints ${listener_ns} | while read line; do
+				local arr=($line)
+				local nr=0
+
+				for i in ${arr[@]}; do
+					if [ $i = "id" ]; then
+						if [ $counter -eq $rm_nr_ns1 ]; then
+							break
+						fi
+						id=${arr[$nr+1]}
+						rm_addr=$(rm_addr_count ${connector_ns})
+						pm_nl_del_endpoint ${listener_ns} $id
+						wait_rm_addr ${connector_ns} ${rm_addr}
+						let counter+=1
+					fi
+					let nr+=1
 				done
-			fi
+			done
 		elif [ $rm_nr_ns1 -eq 8 ]; then
 			pm_nl_flush_endpoint ${listener_ns}
 		elif [ $rm_nr_ns1 -eq 9 ]; then
@@ -520,21 +536,27 @@ do_transfer()
 	elif [ $addr_nr_ns2 -lt 0 ]; then
 		let rm_nr_ns2=-addr_nr_ns2
 		if [ $rm_nr_ns2 -lt 8 ]; then
-			counter=1
-			pos=1
-			dump=(`ip netns exec ${connector_ns} ./pm_nl_ctl dump`)
-			if [ ${#dump[@]} -gt 0 ]; then
-				while [ $counter -le $rm_nr_ns2 ]
-				do
-					# rm_addr are serialized, allow the previous one to complete
-					id=${dump[$pos]}
-					rm_addr=$(rm_addr_count ${listener_ns})
-					pm_nl_del_endpoint ${connector_ns} $id
-					wait_rm_addr ${listener_ns} ${rm_addr}
-					let counter+=1
-					let pos+=5
+			counter=0
+			pm_nl_show_endpoints ${connector_ns} | while read line; do
+				local arr=($line)
+				local nr=0
+
+				for i in ${arr[@]}; do
+					if [ $i = "id" ]; then
+						if [ $counter -eq $rm_nr_ns2 ]; then
+							break
+						fi
+						# rm_addr are serialized, allow the previous one to
+						# complete
+						id=${arr[$nr+1]}
+						rm_addr=$(rm_addr_count ${listener_ns})
+						pm_nl_del_endpoint ${connector_ns} $id
+						wait_rm_addr ${listener_ns} ${rm_addr}
+						let counter+=1
+					fi
+					let nr+=1
 				done
-			fi
+			done
 		elif [ $rm_nr_ns2 -eq 8 ]; then
 			pm_nl_flush_endpoint ${connector_ns}
 		elif [ $rm_nr_ns2 -eq 9 ]; then
@@ -551,7 +573,7 @@ do_transfer()
 	if [ ! -z $sflags ]; then
 		sleep 1
 		for netns in "$ns1" "$ns2"; do
-			ip netns exec $netns ./pm_nl_ctl dump | while read line; do
+			pm_nl_show_endpoints $netns | while read line; do
 				local arr=($line)
 				local addr
 				local port=0
-- 
2.35.1

