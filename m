Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD6731952
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfFADg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbfFADgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:25 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB4C6270E5;
        Sat,  1 Jun 2019 03:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360185;
        bh=XZMdw6bawNXq9CrWS8caCSn4zATtXzv+tZODYwnIyKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elMrMTGejOM/u4LlZbZD7LWMJ6Y/B5y5wD57GxCfCjVF7IbGv8/NhKFdjHgj9F1jM
         w3lZEaooRdvoVPp2nbgDOrclzgAZWdGDW/Cf6QlyUlknCfAjWGY9c5rLHS6/HX0+hp
         wrOennUnoFF+g4huo/lfIg16dvvEJBHgcyGDa5yI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 23/27] selftests: pmtu: Move running of test into a new function
Date:   Fri, 31 May 2019 20:36:14 -0700
Message-Id: <20190601033618.27702-24-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
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

