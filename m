Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D5238E84
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfFGPKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbfFGPJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:09:47 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9775621655;
        Fri,  7 Jun 2019 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559920186;
        bh=XZMdw6bawNXq9CrWS8caCSn4zATtXzv+tZODYwnIyKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ5Zlej/rt7zyiCBTtMgfABBTw/zONgnaek38rGZlgBht6HPlpJVpViRAgBtoxzo9
         XtxdrlkQAQx5T5UUVz9Op2LmEUwdn0ifREY9uva9SGmMrOYl5o1DWnYIizEBpzEkz/
         5k3aFcE9Qo+FIhEPp/QoH+lg/u66A8rLE66kX9PI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 15/20] selftests: pmtu: Move running of test into a new function
Date:   Fri,  7 Jun 2019 08:09:36 -0700
Message-Id: <20190607150941.11371-16-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607150941.11371-1-dsahern@kernel.org>
References: <20190607150941.11371-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the block of code that runs a test and prints the verdict to a
new function, run_test.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/pmtu.sh | 63 +++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 4a1275990d7e..3d6b21c4b1db 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1090,6 +1090,41 @@ test_cleanup_ipv4_exception() {
 	test_cleanup_vxlanX_exception 4
 }
 
+run_test() {
+	(
+	tname="$1"
+	tdesc="$2"
+
+	unset IFS
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "\n##########################################################################\n\n"
+	fi
+
+	eval test_${tname}
+	ret=$?
+
+	if [ $ret -eq 0 ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${tdesc}"
+	elif [ $ret -eq 1 ]; then
+		printf "TEST: %-60s  [FAIL]\n" "${tdesc}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "Pausing. Hit enter to continue"
+			read a
+		fi
+		err_flush
+		exit 1
+	elif [ $ret -eq 2 ]; then
+		printf "TEST: %-60s  [SKIP]\n" "${tdesc}"
+		err_flush
+	fi
+
+	return $ret
+	)
+	[ $? -ne 0 ] && exitcode=1
+}
+
 usage() {
 	echo
 	echo "$0 [OPTIONS] [TEST]..."
@@ -1147,33 +1182,7 @@ for t in ${tests}; do
 	done
 	[ $run_this -eq 0 ] && continue
 
-	(
-		unset IFS
-
-		if [ "$VERBOSE" = "1" ]; then
-			printf "\n##########################################################################\n\n"
-		fi
-
-		eval test_${name}
-		ret=$?
-
-		if [ $ret -eq 0 ]; then
-			printf "TEST: %-60s  [ OK ]\n" "${t}"
-		elif [ $ret -eq 1 ]; then
-			printf "TEST: %-60s  [FAIL]\n" "${t}"
-			if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
-				echo
-				echo "Pausing. Hit enter to continue"
-				read a
-			fi
-			err_flush
-			exit 1
-		elif [ $ret -eq 2 ]; then
-			printf "TEST: %-60s  [SKIP]\n" "${t}"
-			err_flush
-		fi
-	)
-	[ $? -ne 0 ] && exitcode=1
+	run_test "${name}" "${t}"
 done
 
 exit ${exitcode}
-- 
2.11.0

