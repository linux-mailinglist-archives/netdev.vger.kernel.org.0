Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A839958
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbfFGXGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731187AbfFGXGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 19:06:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBCD421530;
        Fri,  7 Jun 2019 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559948776;
        bh=1bGLcdKsyHfWIgdPK2scs5sdP6QGYVXDtTy6iQHxFdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQUm23XiatOyAy5tmOx26EUfWRJ4O8g881tDSh95yFNaNIgNw/ge4A31bBoa+oZ+P
         48Tijw7hOc+Nfo0OaXCBwioEjGpEQI41ZdCewdezSfTxB6G5w8Yjs89IkaMVDqoZVj
         /EUGdm74jBZ8ZgR8k/mx79uvI6m8Pytx+e4yWYJk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 15/20] selftests: pmtu: Move running of test into a new function
Date:   Fri,  7 Jun 2019 16:06:05 -0700
Message-Id: <20190607230610.10349-16-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607230610.10349-1-dsahern@kernel.org>
References: <20190607230610.10349-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the block of code that runs a test and prints the verdict to a
new function, run_test.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
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

