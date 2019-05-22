Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE126A8F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfEVTJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVTJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:09:18 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B24D20868;
        Wed, 22 May 2019 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552157;
        bh=/+BnNCN3lt+rC46Bi3cMxeZY7WEHIHK+o9kgnX9QQPc=;
        h=From:To:Cc:Subject:Date:From;
        b=SFom/7uAJ6tqPbBEGJrgcTSJO+VR/kPzkKqQmSlWxh3gsSXqyZlx21JQ55XDVXJ98
         1q+W5OBS7xlk26ePcdTh9OYpNugRzhF3tykgsx2qHJtb6hwHCWnOVGsrRZbsTjzaiK
         EnbzhtTtBMxufaVjCDP0ea5JTgHrc1VYricHdD8Y=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] selftests: fib-onlink: Make quiet by default
Date:   Wed, 22 May 2019 12:09:16 -0700
Message-Id: <20190522190916.15638-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add VERBOSE argument to fib-onlink-tests.sh and make output quiet by
default. Add getopt parsing of inputs and support for -v (verbose) and
-p (pause on fail).

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib-onlink-tests.sh | 48 ++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/fib-onlink-tests.sh b/tools/testing/selftests/net/fib-onlink-tests.sh
index 864f865eee55..c287b90b8af8 100755
--- a/tools/testing/selftests/net/fib-onlink-tests.sh
+++ b/tools/testing/selftests/net/fib-onlink-tests.sh
@@ -4,6 +4,7 @@
 # IPv4 and IPv6 onlink tests
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
+VERBOSE=0
 
 # Network interfaces
 # - odd in current namespace; even in peer ns
@@ -91,10 +92,10 @@ log_test()
 
 	if [ ${rc} -eq ${expected} ]; then
 		nsuccess=$((nsuccess+1))
-		printf "\n    TEST: %-50s  [ OK ]\n" "${msg}"
+		printf "    TEST: %-50s  [ OK ]\n" "${msg}"
 	else
 		nfail=$((nfail+1))
-		printf "\n    TEST: %-50s  [FAIL]\n" "${msg}"
+		printf "    TEST: %-50s  [FAIL]\n" "${msg}"
 		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
 			echo
 			echo "hit enter to continue, 'q' to quit"
@@ -121,9 +122,23 @@ log_subsection()
 
 run_cmd()
 {
-	echo
-	echo "COMMAND: $*"
-	eval $*
+	local cmd="$*"
+	local out
+	local rc
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "    COMMAND: $cmd\n"
+	fi
+
+	out=$(eval $cmd 2>&1)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "    $out"
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+
+	return $rc
 }
 
 get_linklocal()
@@ -451,11 +466,34 @@ run_onlink_tests()
 }
 
 ################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -p          Pause on fail
+        -v          verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
 # main
 
 nsuccess=0
 nfail=0
 
+while getopts :t:pPhv o
+do
+	case $o in
+		p) PAUSE_ON_FAIL=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
 cleanup
 setup
 run_onlink_tests
-- 
2.11.0

