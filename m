Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9631144DA7D
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhKKQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhKKQcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 11:32:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41FC6128E;
        Thu, 11 Nov 2021 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636648176;
        bh=bcAKWy7unFMtWR4ip2aBmeNmmZqBCXgNjDtTZ6zWd74=;
        h=From:To:Cc:Subject:Date:From;
        b=vDsMyGigrluYXT6T/zIUJZwgtksS9ahMl8m5sUsrTdUKDYycwADpAijGx82cQSozI
         heQuaY3KDkBiP/DhdTkNkkEeD1uTVa1tsT61sLIws1jvGvHG+pHckt0TddkXnR1a4N
         tlYQRzQ3Ba+vyVq2NdR7iUzKJ8hFEO/GZMfMI9kmqUl6wpW1ODGaIm+6MKrCdIqMPX
         hfA1HqHv8foE9lDd4g5ILxlckZa97xb+JxEfeQ1kyc+tOIHa/DUH+D5tcsOqnU6hqO
         yKFNFyG8verKmqpVPFIXSPAZyyokvwOQ3uwYEvIZZUFvl/k61A5eJupzgOGsNgCLwQ
         W4CprhDxXdztA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrea Righi <andrea.righi@canonical.com>
Subject: [PATCH net] selftests: net: switch to socat in the GSO GRE test
Date:   Thu, 11 Nov 2021 08:29:29 -0800
Message-Id: <20211111162929.530470-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a985442fdecb ("selftests: net: properly support IPv6 in GSO GRE test")
is not compatible with:

  Ncat: Version 7.80 ( https://nmap.org/ncat )

(which is distributed with Fedora/Red Hat), tests fail with:

  nc: invalid option -- 'N'

Let's switch to socat which is far more dependable.

Fixes: 025efa0a82df ("selftests: add simple GSO GRE test")
Fixes: a985442fdecb ("selftests: net: properly support IPv6 in GSO GRE test")
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/gre_gso.sh | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/gre_gso.sh b/tools/testing/selftests/net/gre_gso.sh
index fdeb44d621eb..3224651db97b 100755
--- a/tools/testing/selftests/net/gre_gso.sh
+++ b/tools/testing/selftests/net/gre_gso.sh
@@ -118,16 +118,18 @@ gre_gst_test_checks()
 	local addr=$2
 	local proto=$3
 
-	$NS_EXEC nc $proto -kl $port >/dev/null &
+	[ "$proto" == 6 ] && addr="[$addr]"
+
+	$NS_EXEC socat - tcp${proto}-listen:$port,reuseaddr,fork >/dev/null &
 	PID=$!
 	while ! $NS_EXEC ss -ltn | grep -q $port; do ((i++)); sleep 0.01; done
 
-	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
+	cat $TMPFILE | timeout 1 socat -u STDIN TCP:$addr:$port
 	log_test $? 0 "$name - copy file w/ TSO"
 
 	ethtool -K veth0 tso off
 
-	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
+	cat $TMPFILE | timeout 1 socat -u STDIN TCP:$addr:$port
 	log_test $? 0 "$name - copy file w/ GSO"
 
 	ethtool -K veth0 tso on
@@ -155,8 +157,8 @@ gre6_gso_test()
 
 	sleep 2
 
-	gre_gst_test_checks GREv6/v4 172.16.2.2
-	gre_gst_test_checks GREv6/v6 2001:db8:1::2 -6
+	gre_gst_test_checks GREv6/v4 172.16.2.2 4
+	gre_gst_test_checks GREv6/v6 2001:db8:1::2 6
 
 	cleanup
 }
@@ -212,8 +214,8 @@ if [ ! -x "$(command -v ip)" ]; then
 	exit $ksft_skip
 fi
 
-if [ ! -x "$(command -v nc)" ]; then
-	echo "SKIP: Could not run test without nc tool"
+if [ ! -x "$(command -v socat)" ]; then
+	echo "SKIP: Could not run test without socat tool"
 	exit $ksft_skip
 fi
 
-- 
2.31.1

