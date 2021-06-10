Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06783A3782
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFJXBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:01:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:55161 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhFJXBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 19:01:48 -0400
IronPort-SDR: jNvB6LMd8HCDl16I5CoUa3e7yQ2g5DM+8bzUQsNjS0EVSY5zaRGvG12XmYvmbP8OL9ZifdgxTh
 VmNNMQEGi+rA==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="205383805"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="205383805"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:50 -0700
IronPort-SDR: v1fW9fIqXiF1jvD+m5rmac24OyBq9uKJcZj0HNpIM52NhtUUnYIW/GjZEHvs1f96XXqF1n8ls1
 bLTMJMp8T1Pw==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="441387042"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.70.185])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, fw@strlen.de,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/5] selftests: mptcp: enable syncookie only in absence of reorders
Date:   Thu, 10 Jun 2021 15:59:43 -0700
Message-Id: <20210610225944.351224-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
References: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Syncookie validation may fail for OoO packets, causing spurious
resets and self-tests failures, so let's force syncookie only
for tests iteration with no OoO.

Fixes: fed61c4b584c ("selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/198
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 9ca5f1ba461e..2b495dc8d78e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -197,9 +197,6 @@ ip -net "$ns4" link set ns4eth3 up
 ip -net "$ns4" route add default via 10.0.3.2
 ip -net "$ns4" route add default via dead:beef:3::2
 
-# use TCP syn cookies, even if no flooding was detected.
-ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=2
-
 set_ethtool_flags() {
 	local ns="$1"
 	local dev="$2"
@@ -737,6 +734,14 @@ for sender in $ns1 $ns2 $ns3 $ns4;do
 		exit $ret
 	fi
 
+	# ns1<->ns2 is not subject to reordering/tc delays. Use it to test
+	# mptcp syncookie support.
+	if [ $sender = $ns1 ]; then
+		ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=2
+	else
+		ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=1
+	fi
+
 	run_tests "$ns2" $sender 10.0.1.2
 	run_tests "$ns2" $sender dead:beef:1::2
 	run_tests "$ns2" $sender 10.0.2.1
-- 
2.32.0

