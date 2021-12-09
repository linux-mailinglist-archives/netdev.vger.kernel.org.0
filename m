Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE246DF43
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbhLIAMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:12:37 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41768 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbhLIAMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:12:33 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8D5D7607DF;
        Thu,  9 Dec 2021 01:06:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/7] selftests: netfilter: switch zone stress to socat
Date:   Thu,  9 Dec 2021 01:08:46 +0100
Message-Id: <20211209000847.102598-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211209000847.102598-1-pablo@netfilter.org>
References: <20211209000847.102598-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

centos9 has nmap-ncat which doesn't like the '-q' option, use socat.
While at it, mark test skipped if needed tools are missing.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_zones_many.sh     | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
index ac646376eb01..04633119b29a 100755
--- a/tools/testing/selftests/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -18,11 +18,17 @@ cleanup()
 	ip netns del $ns
 }
 
-ip netns add $ns
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $gw"
-	exit $ksft_skip
-fi
+checktool (){
+	if ! $1 > /dev/null 2>&1; then
+		echo "SKIP: Could not $2"
+		exit $ksft_skip
+	fi
+}
+
+checktool "nft --version" "run test without nft tool"
+checktool "ip -Version" "run test without ip tool"
+checktool "socat -V" "run test without socat tool"
+checktool "ip netns add $ns" "create net namespace"
 
 trap cleanup EXIT
 
@@ -71,7 +77,8 @@ EOF
 		local start=$(date +%s%3N)
 		i=$((i + 10000))
 		j=$((j + 1))
-		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" nc -w 1 -q 1 -u -p 12345 127.0.0.1 12345 > /dev/null
+		# nft rule in output places each packet in a different zone.
+		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
 		if [ $? -ne 0 ] ;then
 			ret=1
 			break
-- 
2.30.2

