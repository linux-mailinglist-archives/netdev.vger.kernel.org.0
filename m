Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA1A31A84A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhBLXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:24:23 -0500
Received: from mga04.intel.com ([192.55.52.120]:6184 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhBLXYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 18:24:06 -0500
IronPort-SDR: dvnkJLDM5IO7hujA5UwAX6jyP+P+PoJtmA+yccZmTz3c25b+LIxR5EVAH9dtNk732KQRbUdmCa
 HKehl9tBSccA==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179934368"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179934368"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
IronPort-SDR: QUa4ALXQklBTnUPKjLNyKM/tqBVupisZJloF1xUhTkGFffkXEtrHUuiI+ulrDs5v+mPHvSJUjl
 t5/swgYOfCyw==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="360595941"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] selftests: mptcp: fail if not enough SYN/3rd ACK
Date:   Fri, 12 Feb 2021 15:20:30 -0800
Message-Id: <20210212232030.377261-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
References: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

If we receive less MPCapable SYN or 3rd ACK than expected, we now mark
the test as failed.

On the other hand, if we receive more, we keep the warning but we add a
hint that it is probably due to retransmissions and that's why we don't
mark the test as failed.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/148
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 28 +++++++++++++------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 362e891f89cf..10a030b53b23 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -483,10 +483,6 @@ do_transfer()
 	check_transfer $cin $sout "file received by server"
 	rets=$?
 
-	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
-		printf "[ OK ]"
-	fi
-
 	local stat_synrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
 	local stat_ackrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
 	local stat_cookietx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
@@ -502,6 +498,22 @@ do_transfer()
 		expect_synrx=$((stat_synrx_last_l+1))
 		expect_ackrx=$((stat_ackrx_last_l+1))
 	fi
+
+	if [ ${stat_synrx_now_l} -lt ${expect_synrx} ]; then
+		printf "[ FAIL ] lower MPC SYN rx (%d) than expected (%d)\n" \
+			"${stat_synrx_now_l}" "${expect_synrx}" 1>&2
+		retc=1
+	fi
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ]; then
+		printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
+			"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2
+		rets=1
+	fi
+
+	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
+		printf "[ OK ]"
+	fi
+
 	if [ $cookies -eq 2 ];then
 		if [ $stat_cookietx_last -ge $stat_cookietx_now ] ;then
 			printf " WARN: CookieSent: did not advance"
@@ -518,12 +530,12 @@ do_transfer()
 		fi
 	fi
 
-	if [ $expect_synrx -ne $stat_synrx_now_l ] ;then
-		printf " WARN: SYNRX: expect %d, got %d" \
+	if [ ${stat_synrx_now_l} -gt ${expect_synrx} ]; then
+		printf " WARN: SYNRX: expect %d, got %d (probably retransmissions)" \
 			"${expect_synrx}" "${stat_synrx_now_l}"
 	fi
-	if [ $expect_ackrx -ne $stat_ackrx_now_l ] ;then
-		printf " WARN: ACKRX: expect %d, got %d" \
+	if [ ${stat_ackrx_now_l} -gt ${expect_ackrx} ]; then
+		printf " WARN: ACKRX: expect %d, got %d (probably retransmissions)" \
 			"${expect_ackrx}" "${stat_ackrx_now_l}"
 	fi
 
-- 
2.30.1

