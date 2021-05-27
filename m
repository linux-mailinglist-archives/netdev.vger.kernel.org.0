Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF07A39394E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhE0Xd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:33:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:8586 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235540AbhE0XdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:33:20 -0400
IronPort-SDR: jqwianawy/h7xacCbbfnuvt364hQMTLbH3t+LANTVjpmPCKePlJpl0ufDcfiRo8K44TX1Ojcjk
 XYGMFT+B10KA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="190227182"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="190227182"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
IronPort-SDR: mab1Qem+WKbXV9Qcq1Ffq23iPa8bfYct/siRzKEEEyHIdJtmkQTW5uLc5HyBuTHfip52a9cgC9
 QdsGsb94mxQA==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="477700335"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/4] mptcp: update selftest for fallback due to OoO
Date:   Thu, 27 May 2021 16:31:40 -0700
Message-Id: <20210527233140.182728-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
References: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The previous commit noted that we can have fallback
scenario due to OoO (or packet drop). Update the self-tests
accordingly

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 3c4cb72ed8a4..9ca5f1ba461e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -501,6 +501,7 @@ do_transfer()
 	local stat_ackrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
 	local stat_cookietx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	local stat_cookierx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	local stat_ooo_now=$(get_mib_counter "${listener_ns}" "TcpExtTCPOFOQueue")
 
 	expect_synrx=$((stat_synrx_last_l))
 	expect_ackrx=$((stat_ackrx_last_l))
@@ -518,10 +519,14 @@ do_transfer()
 			"${stat_synrx_now_l}" "${expect_synrx}" 1>&2
 		retc=1
 	fi
-	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ]; then
-		printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
-			"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2
-		rets=1
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} -a ${stat_ooo_now} -eq 0 ]; then
+		if [ ${stat_ooo_now} -eq 0 ]; then
+			printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
+				"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2
+			rets=1
+		else
+			printf "[ Note ] fallback due to TCP OoO"
+		fi
 	fi
 
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
-- 
2.31.1

