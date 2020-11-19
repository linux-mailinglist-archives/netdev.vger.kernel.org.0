Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F4C2B9BAD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgKSTqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:56904 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgKSTqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:11 -0500
IronPort-SDR: /OOzvEFki7Yr5q+0hmb50hXgKTPuK1eYF5ZbF0wz8btg4j3YD8xn56zZVZNo5ppA0Ktmj7pmKx
 ygvp0uBRiOpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171451135"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171451135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: KObGUR5icmHcSvB8vvgAte1I6tA6wV6oLCiz0489NmY/DZQ+JKiRWahUU873JkgUZctcWpD/NC
 OgBAU7Aohytw==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940486"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, kuba@kernel.org,
        mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/10] selftests: mptcp: add ADD_ADDR IPv6 test cases
Date:   Thu, 19 Nov 2020 11:46:01 -0800
Message-Id: <20201119194603.103158-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added IPv6 support for do_transfer, and the test cases for
ADD_ADDR IPv6.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 70 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f841ed8186c1..0eae628d1ffd 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -195,6 +195,12 @@ link_failure()
 	ip -net "$ns" link set "$veth" down
 }
 
+# $1: IP address
+is_v6()
+{
+	[ -z "${1##*:*}" ]
+}
+
 do_transfer()
 {
 	listener_ns="$1"
@@ -236,7 +242,15 @@ do_transfer()
 		mptcp_connect="./mptcp_connect -r"
 	fi
 
-	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
+	local local_addr
+	if is_v6 "${connect_addr}"; then
+		local_addr="::"
+	else
+		local_addr="0.0.0.0"
+	fi
+
+	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port \
+		-s ${srv_proto} ${local_addr} < "$sin" > "$sout" &
 	spid=$!
 
 	sleep 1
@@ -649,6 +663,60 @@ chk_join_nr "remove subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
 
+# subflow IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "single subflow IPv6" 1 1 1
+
+# add_address, unused IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "unused signal address IPv6" 0 0 0
+chk_add_nr 1 1
+
+# signal address IPv6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "single address IPv6" 1 1 1
+chk_add_nr 1 1
+
+# add_addr timeout IPv6
+reset_with_add_addr_timeout 6
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
+chk_add_nr 4 0
+
+# single address IPv6, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_tests $ns1 $ns2 dead:beef:1::1 0 1 0 slow
+chk_join_nr "remove single address IPv6" 1 1 1
+chk_add_nr 1 1
+chk_rm_nr 0 0
+
+# subflow and signal IPv6, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+run_tests $ns1 $ns2 dead:beef:1::1 0 1 1 slow
+chk_join_nr "remove subflow and signal IPv6" 2 2 2
+chk_add_nr 1 1
+chk_rm_nr 1 1
+
 # single subflow, syncookies
 reset_with_cookies
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.29.2

