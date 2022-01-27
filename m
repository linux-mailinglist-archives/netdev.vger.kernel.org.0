Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A876C49EF08
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbiA0Xwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:45 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43012 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343752AbiA0Xwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:43 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A06E460867;
        Fri, 28 Jan 2022 00:49:37 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/8] selftests: netfilter: reduce zone stress test running time
Date:   Fri, 28 Jan 2022 00:52:30 +0100
Message-Id: <20220127235235.656931-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This selftests needs almost 3 minutes to complete, reduce the
insertes zones to 1000.  Test now completes in about 20 seconds.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_zones_many.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
index 04633119b29a..5a8db0b48928 100755
--- a/tools/testing/selftests/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -9,7 +9,7 @@ ns="ns-$sfx"
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-zones=20000
+zones=2000
 have_ct_tool=0
 ret=0
 
@@ -75,10 +75,10 @@ EOF
 
 	while [ $i -lt $max_zones ]; do
 		local start=$(date +%s%3N)
-		i=$((i + 10000))
+		i=$((i + 1000))
 		j=$((j + 1))
 		# nft rule in output places each packet in a different zone.
-		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
+		dd if=/dev/zero of=/dev/stdout bs=8k count=1000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
 		if [ $? -ne 0 ] ;then
 			ret=1
 			break
@@ -86,7 +86,7 @@ EOF
 
 		stop=$(date +%s%3N)
 		local duration=$((stop-start))
-		echo "PASS: added 10000 entries in $duration ms (now $i total, loop $j)"
+		echo "PASS: added 1000 entries in $duration ms (now $i total, loop $j)"
 	done
 
 	if [ $have_ct_tool -eq 1 ]; then
@@ -128,11 +128,11 @@ test_conntrack_tool() {
 			break
 		fi
 
-		if [ $((i%10000)) -eq 0 ];then
+		if [ $((i%1000)) -eq 0 ];then
 			stop=$(date +%s%3N)
 
 			local duration=$((stop-start))
-			echo "PASS: added 10000 entries in $duration ms (now $i total)"
+			echo "PASS: added 1000 entries in $duration ms (now $i total)"
 			start=$stop
 		fi
 	done
-- 
2.30.2

