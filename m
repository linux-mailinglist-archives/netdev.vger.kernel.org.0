Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E62EFC79
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbhAIAwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:52:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:32288 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbhAIAwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:52:44 -0500
IronPort-SDR: QBAgPkoc8M08zO5JlFRcybEX8r2WB3Lgt/LklGZQv4S7WU5v1N+YhANIbAObgBD/pKofSwz7+l
 6Smi+SMAyzBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771952"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771952"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: gRwk64UWfvqREfxLbFLOTgiys9h/d+KhCQbYgFwgW9F1QZRq8mRyIap4rZG382T0ZxYgA+KQJV
 w+VetAOq7P/w==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124499"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/8] selftests: mptcp: add testcases for setting the address ID
Date:   Fri,  8 Jan 2021 16:47:56 -0800
Message-Id: <20210109004802.341602-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Since the address ID can be set from user-space, some of the tests in
pm_netlink.sh will fail. This patch fixed the failures, and add the
testcases for setting the address ID.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/pm_netlink.sh | 41 ++++++++++++++++++-
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 15f4f46ca3a9..a617e293734c 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -91,7 +91,7 @@ id 3 flags signal,backup 10.0.1.3" "dump addrs after del"
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.3
 check "ip netns exec $ns1 ./pm_nl_ctl get 4" "" "duplicate addr"
 
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.4 id 10 flags signal
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.4 flags signal
 check "ip netns exec $ns1 ./pm_nl_ctl get 4" "id 4 flags signal 10.0.1.4" "id addr increment"
 
 for i in `seq 5 9`; do
@@ -102,9 +102,10 @@ check "ip netns exec $ns1 ./pm_nl_ctl get 10" "" "above hard addr limit"
 
 for i in `seq 9 256`; do
 	ip netns exec $ns1 ./pm_nl_ctl del $i
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.9
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.9 id $((i+1))
 done
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags  10.0.1.1
+id 2 flags  10.0.0.9
 id 3 flags signal,backup 10.0.1.3
 id 4 flags signal 10.0.1.4
 id 5 flags signal 10.0.1.5
@@ -127,4 +128,40 @@ ip netns exec $ns1 ./pm_nl_ctl limits 8 8
 check "ip netns exec $ns1 ./pm_nl_ctl limits" "accept 8
 subflows 8" "set limits"
 
+ip netns exec $ns1 ./pm_nl_ctl flush
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.2
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.3 id 100
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.4
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.5 id 254
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.6
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.7
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.8
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags  10.0.1.1
+id 2 flags  10.0.1.2
+id 3 flags  10.0.1.7
+id 4 flags  10.0.1.8
+id 100 flags  10.0.1.3
+id 101 flags  10.0.1.4
+id 254 flags  10.0.1.5
+id 255 flags  10.0.1.6" "set ids"
+
+ip netns exec $ns1 ./pm_nl_ctl flush
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.2 id 254
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.4
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.5 id 253
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.6
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.7
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.0.8
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags  10.0.0.1
+id 2 flags  10.0.0.4
+id 3 flags  10.0.0.6
+id 4 flags  10.0.0.7
+id 5 flags  10.0.0.8
+id 253 flags  10.0.0.5
+id 254 flags  10.0.0.2
+id 255 flags  10.0.0.3" "wrap-around ids"
+
 exit $ret
-- 
2.30.0

