Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCFC9503
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfJBXiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbfJBXhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862638"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 41/45] selftests: mptcp: make tc delays random
Date:   Wed,  2 Oct 2019 16:36:51 -0700
Message-Id: <20191002233655.24323-42-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

test with less predictable setups:
tc qdisc delay is now random, same for reordering and loss.
Main motivation is to cover more scenarious without a large
increase in test-time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 28 +++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index d029bdc5946d..fb9bf9f4fc8b 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -277,8 +277,32 @@ for sender in 1 2 3 4;do
 	do_ping ns4 ns$sender 10.0.3.1
 done
 
-tc -net ns2 qdisc add dev ns2eth3 root netem loss random 1
-tc -net ns3 qdisc add dev ns3eth4 root netem delay 10ms reorder 25% 50% gap 5
+loss=$((RANDOM%101))
+if [ $loss -eq 100 ] ;then
+	loss=1%
+	tc -net ns2 qdisc add dev ns2eth3 root netem loss random $loss
+elif [ $loss -ge 10 ]; then
+	loss=0.$loss%
+	tc -net ns2 qdisc add dev ns2eth3 root netem loss random $loss
+elif [ $loss -ge 1 ]; then
+	loss=0.0$loss%
+	tc -net ns2 qdisc add dev ns2eth3 root netem loss random $loss
+fi
+
+delay=$((RANDOM%1200))
+reorder1=$((RANDOM%25))
+reorder2=$((RANDOM%50))
+gap=$((RANDOM%100))
+if [ $gap -gt 0 ]; then
+	gap="gap $gap"
+else
+	gap=""
+fi
+
+if [ $reorder1 -gt 0 ] && [ $reorder2 -gt 0 ]; then
+  tc -net ns3 qdisc add dev ns3eth4 root netem delay ${delay}ms reorder ${reorder1}% ${reorder2}% $gap
+fi
+echo "INFO: Using loss of $loss, delay $delay ms, reorder: $reorder1, $reorder2 $gap on ns3eth4"
 
 for sender in 1 2 3 4;do
 	run_tests ns1 ns$sender 10.0.1.1
-- 
2.23.0

