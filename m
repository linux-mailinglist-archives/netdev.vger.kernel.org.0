Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE4130831B
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhA2BQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:16:30 -0500
Received: from mga07.intel.com ([134.134.136.100]:6703 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhA2BQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:16:06 -0500
IronPort-SDR: tLnfvbQpT8h4MCESpKZ/DV9779CYaHcM+aKlUvVIE3TyPECn95RP2k8U8KEPXlE2PXDl3gNC2C
 XNHD9btWS69w==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430171"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430171"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: kpS73eGJ/LMKYrvvmYZ10/NHhqF6DGt+8b3zpnucaIX3TlPm0eb/ueAFPZAMtv58DhR3nBV6Pe
 rGBkac49KE+Q==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538330"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/16] selftests: mptcp: add testcases for newly added addresses
Date:   Thu, 28 Jan 2021 17:11:05 -0800
Message-Id: <20210129011115.133953-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
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

