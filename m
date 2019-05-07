Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98815BF4
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfEGFgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfEGFgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:36:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2D820989;
        Tue,  7 May 2019 05:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207399;
        bh=G0mL/H8gNfYgbuvpwiVRVokGWEdnGYTn1l78OE/dFUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXaVyuqBY3WCZb8HGfxYjUeZhbQIPmc5AbDxbO1sR6nm99fu+Fw2zTR3R62zMIxZx
         dJjQYqaQMQ78cAPbiobMrFEvdiU4v6ePLTpqS+qgchXnpwIWhj2OkWT67BE9B8LqoN
         5uwTnpzpO+u9wHYr/p6klnECADRDg2FTTzO2qDUk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/81] selftests: fib_tests: Fix 'Command line is not complete' errors
Date:   Tue,  7 May 2019 01:34:54 -0400
Message-Id: <20190507053554.30848-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit a5f622984a623df9a84cf43f6b098d8dd76fbe05 ]

A couple of tests are verifying a route has been removed. The helper
expects the prefix as the first part of the expected output. When
checking that a route has been deleted the prefix is empty leading
to an invalid ip command:

  $ ip ro ls match
  Command line is not complete. Try option "help"

Fix by moving the comparison of expected output and output to a new
function that is used by both check_route and check_route6. Use the
new helper for the 2 checks on route removal.

Also, remove the reset of 'set -x' in route_setup which overrides the
user managed setting.

Fixes: d69faad76584c ("selftests: fib_tests: Add prefix route tests with metric")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_tests.sh | 94 ++++++++++--------------
 1 file changed, 40 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index a4ccde0e473b..2f190aa8fc5f 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -602,6 +602,39 @@ run_cmd()
 	return $rc
 }
 
+check_expected()
+{
+	local out="$1"
+	local expected="$2"
+	local rc=0
+
+	[ "${out}" = "${expected}" ] && return 0
+
+	if [ -z "${out}" ]; then
+		if [ "$VERBOSE" = "1" ]; then
+			printf "\nNo route entry found\n"
+			printf "Expected:\n"
+			printf "    ${expected}\n"
+		fi
+		return 1
+	fi
+
+	# tricky way to convert output to 1-line without ip's
+	# messy '\'; this drops all extra white space
+	out=$(echo ${out})
+	if [ "${out}" != "${expected}" ]; then
+		rc=1
+		if [ "${VERBOSE}" = "1" ]; then
+			printf "    Unexpected route entry. Have:\n"
+			printf "        ${out}\n"
+			printf "    Expected:\n"
+			printf "        ${expected}\n\n"
+		fi
+	fi
+
+	return $rc
+}
+
 # add route for a prefix, flushing any existing routes first
 # expected to be the first step of a test
 add_route6()
@@ -646,31 +679,7 @@ check_route6()
 	local rc=0
 
 	out=$($IP -6 ro ls match ${pfx} | sed -e 's/ pref medium//')
-	[ "${out}" = "${expected}" ] && return 0
-
-	if [ -z "${out}" ]; then
-		if [ "$VERBOSE" = "1" ]; then
-			printf "\nNo route entry found\n"
-			printf "Expected:\n"
-			printf "    ${expected}\n"
-		fi
-		return 1
-	fi
-
-	# tricky way to convert output to 1-line without ip's
-	# messy '\'; this drops all extra white space
-	out=$(echo ${out})
-	if [ "${out}" != "${expected}" ]; then
-		rc=1
-		if [ "${VERBOSE}" = "1" ]; then
-			printf "    Unexpected route entry. Have:\n"
-			printf "        ${out}\n"
-			printf "    Expected:\n"
-			printf "        ${expected}\n\n"
-		fi
-	fi
-
-	return $rc
+	check_expected "${out}" "${expected}"
 }
 
 route_cleanup()
@@ -714,7 +723,7 @@ route_setup()
 	$IP addr add 172.16.103.2/24 dev veth4
 	$IP addr add 172.16.104.1/24 dev dummy1
 
-	set +ex
+	set +e
 }
 
 # assumption is that basic add of a single path route works
@@ -949,7 +958,8 @@ ipv6_addr_metric_test()
 	run_cmd "$IP li set dev dummy2 down"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route6 ""
+		out=$($IP -6 ro ls match 2001:db8:104::/64)
+		check_expected "${out}" ""
 		rc=$?
 	fi
 	log_test $rc 0 "Prefix route removed on link down"
@@ -1009,34 +1019,9 @@ check_route()
 	local pfx="172.16.104.0/24"
 	local expected="$1"
 	local out
-	local rc=0
 
 	out=$($IP ro ls match ${pfx})
-	[ "${out}" = "${expected}" ] && return 0
-
-	if [ -z "${out}" ]; then
-		if [ "$VERBOSE" = "1" ]; then
-			printf "\nNo route entry found\n"
-			printf "Expected:\n"
-			printf "    ${expected}\n"
-		fi
-		return 1
-	fi
-
-	# tricky way to convert output to 1-line without ip's
-	# messy '\'; this drops all extra white space
-	out=$(echo ${out})
-	if [ "${out}" != "${expected}" ]; then
-		rc=1
-		if [ "${VERBOSE}" = "1" ]; then
-			printf "    Unexpected route entry. Have:\n"
-			printf "        ${out}\n"
-			printf "    Expected:\n"
-			printf "        ${expected}\n\n"
-		fi
-	fi
-
-	return $rc
+	check_expected "${out}" "${expected}"
 }
 
 # assumption is that basic add of a single path route works
@@ -1301,7 +1286,8 @@ ipv4_addr_metric_test()
 	run_cmd "$IP li set dev dummy2 down"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route ""
+		out=$($IP ro ls match 172.16.104.0/24)
+		check_expected "${out}" ""
 		rc=$?
 	fi
 	log_test $rc 0 "Prefix route removed on link down"
-- 
2.20.1

