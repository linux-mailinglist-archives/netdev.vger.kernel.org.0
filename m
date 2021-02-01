Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461C330B332
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhBAXOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:14:06 -0500
Received: from mga12.intel.com ([192.55.52.136]:51851 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhBAXN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:13:58 -0500
IronPort-SDR: IDp2Og854nsbwuRmhhUxAqB31gRCbsQFPMV9j2CcnyaFFNOtr5W+x5kDpxId4dDzsoQT5iHF4x
 cIYDIpV2tQEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934340"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934340"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
IronPort-SDR: /yDjdxC5QgmCFTHnXfLKqEP7+9LXwOLbK3s3Ix8ILkM4X/Qz1GUrzzhPkoVZfqJMrGlucrtt/z
 M3S9bvjlkIVA==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188469"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 06/15] selftests: mptcp: add testcases for newly added addresses
Date:   Mon,  1 Feb 2021 15:09:11 -0800
Message-Id: <20210201230920.66027-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds testcases to create subflows or signal addresses for the
newly added IPv4 or IPv6 addresses.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 73 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index e5fb2b01f31c..b5cd2a48831e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -264,7 +264,23 @@ do_transfer()
 	fi
 	cpid=$!
 
-	if [ $addr_nr_ns1 -lt 0 ]; then
+	if [ $addr_nr_ns1 -gt 0 ]; then
+		let add_nr_ns1=addr_nr_ns1
+		counter=2
+		sleep 1
+		while [ $add_nr_ns1 -gt 0 ]; do
+			local addr
+			if is_v6 "${connect_addr}"; then
+				addr="dead:beef:$counter::1"
+			else
+				addr="10.0.$counter.1"
+			fi
+			ip netns exec $ns1 ./pm_nl_ctl add $addr flags signal
+			let counter+=1
+			let add_nr_ns1-=1
+		done
+		sleep 1
+	elif [ $addr_nr_ns1 -lt 0 ]; then
 		let rm_nr_ns1=-addr_nr_ns1
 		if [ $rm_nr_ns1 -lt 8 ]; then
 			counter=1
@@ -282,7 +298,23 @@ do_transfer()
 		fi
 	fi
 
-	if [ $addr_nr_ns2 -lt 0 ]; then
+	if [ $addr_nr_ns2 -gt 0 ]; then
+		let add_nr_ns2=addr_nr_ns2
+		counter=3
+		sleep 1
+		while [ $add_nr_ns2 -gt 0 ]; do
+			local addr
+			if is_v6 "${connect_addr}"; then
+				addr="dead:beef:$counter::2"
+			else
+				addr="10.0.$counter.2"
+			fi
+			ip netns exec $ns2 ./pm_nl_ctl add $addr flags subflow
+			let counter+=1
+			let add_nr_ns2-=1
+		done
+		sleep 1
+	elif [ $addr_nr_ns2 -lt 0 ]; then
 		let rm_nr_ns2=-addr_nr_ns2
 		if [ $rm_nr_ns2 -lt 8 ]; then
 			counter=1
@@ -738,6 +770,43 @@ chk_join_nr "flush subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
 
+# add single subflow
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
+chk_join_nr "add single subflow" 1 1 1
+
+# add signal address
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
+chk_join_nr "add signal address" 1 1 1
+chk_add_nr 1 1
+
+# add multiple subflows
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
+chk_join_nr "add multiple subflows" 2 2 2
+
+# add multiple subflows IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
+chk_join_nr "add multiple subflows IPv6" 2 2 2
+
+# add multiple addresses IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
+chk_join_nr "add multiple addresses IPv6" 2 2 2
+chk_add_nr 2 2
+
 # subflow IPv6
 reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.30.0

