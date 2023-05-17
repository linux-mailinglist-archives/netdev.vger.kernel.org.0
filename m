Return-Path: <netdev+bounces-3435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F22F7071D4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936391C20B04
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A80449B7;
	Wed, 17 May 2023 19:16:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9B31F16;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588D0C4339E;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684350995;
	bh=R4YpFZTl+oXNewsjYriHjMMokwZrKw/2xqb0ZCvX8KI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=m4aPRRE2SkMilCv8ZQVMXxatc7nXi0lJzt6AK5gMzj38BkUrH+XlQenaZuKKfl8sO
	 oESA+w82ouGGC2m8wDBOQhhv5RbtybzC7Lk2/Ky+XxzAiw8r71gBdEuZRHSD/koeFv
	 7TAozFV35zNV9DLJxWVz1Z2dONwrKtUqVlesLEaAhikagoV5zrW2A2GxFWpq+Tzh7F
	 ZWPZ4Icc0GZ3L8U++jK3Pe2+QeY85QnCJZmOe3Uno1pafIg6e+5OGdy3Wq5us0IL+K
	 YIvc8TfIXL/BB9kVUA+4RJ32HVikfUCRWiFPNkGiQXIl9Cvz6QE2ilqIkb+7E9jISV
	 DoVOn8aEC6G9A==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 17 May 2023 12:16:17 -0700
Subject: [PATCH net-next 4/5] selftests: mptcp: add explicit check for new
 mibs
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230516-send-net-next-20220516-v1-4-e91822b7b6e0@kernel.org>
References: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
In-Reply-To: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

Instead of duplicating the all existing TX check with
the TX side, add the new ones on selected test cases.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 62 +++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0886ed2c59ea..ca5bd2c3434a 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1585,6 +1585,44 @@ chk_add_nr()
 	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
+chk_add_tx_nr()
+{
+	local add_tx_nr=$1
+	local echo_tx_nr=$2
+	local dump_stats
+	local timeout
+	local count
+
+	timeout=$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
+
+	printf "%-${nr_blank}s %s" " " "add TX"
+	count=$(ip netns exec $ns1 nstat -as MPTcpExtAddAddrTx | grep MPTcpExtAddAddrTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+
+	# if the test configured a short timeout tolerate greater then expected
+	# add addrs options, due to retransmissions
+	if [ "$count" != "$add_tx_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -lt "$add_tx_nr" ]; }; then
+		echo "[fail] got $count ADD_ADDR[s] TX, expected $add_tx_nr"
+		fail_test
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - echo TX "
+	count=$(ip netns exec $ns2 nstat -as MPTcpExtEchoAddTx | grep MPTcpExtEchoAddTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$echo_tx_nr" ]; then
+		echo "[fail] got $count ADD_ADDR echo[s] TX, expected $echo_tx_nr"
+		fail_test
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	[ "${dump_stats}" = 1 ] && dump_stats
+}
+
 chk_rm_nr()
 {
 	local rm_addr_nr=$1
@@ -1660,6 +1698,26 @@ chk_rm_nr()
 	echo "$extra_msg"
 }
 
+chk_rm_tx_nr()
+{
+	local rm_addr_tx_nr=$1
+
+	printf "%-${nr_blank}s %s" " " "rm TX "
+	count=$(ip netns exec $ns2 nstat -as MPTcpExtRmAddrTx | grep MPTcpExtRmAddrTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$rm_addr_tx_nr" ]; then
+		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_tx_nr"
+		fail_test
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	[ "${dump_stats}" = 1 ] && dump_stats
+
+	echo "$extra_msg"
+}
+
 chk_prio_nr()
 {
 	local mp_prio_nr_tx=$1
@@ -1939,6 +1997,7 @@ signal_address_tests()
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 0 0 0
+		chk_add_tx_nr 1 1
 		chk_add_nr 1 1
 	fi
 
@@ -2120,6 +2179,7 @@ add_addr_timeout_tests()
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 		chk_join_nr 1 1 1
+		chk_add_tx_nr 4 4
 		chk_add_nr 4 0
 	fi
 
@@ -2165,6 +2225,7 @@ remove_tests()
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
 		chk_join_nr 1 1 1
+		chk_rm_tx_nr 1
 		chk_rm_nr 1 1
 	fi
 
@@ -2263,6 +2324,7 @@ remove_tests()
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 		chk_join_nr 3 3 3
+		chk_rm_tx_nr 0
 		chk_rm_nr 0 3 simult
 	fi
 

-- 
2.40.1


