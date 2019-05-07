Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF015911
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfEGFd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfEGFd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2A120B7C;
        Tue,  7 May 2019 05:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207206;
        bh=ljHDDdXyratzljjdrAbax9jGz9/dTE86P9+UvMbcDXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KepX4JqgQaVD4o6ZQeWrsI6IZqjar3QdHXMWYJuuFnB1AJ9tRb8KHokGPwMNX7pmz
         Lkr+J8eG9L8zYMQE2TwZX+Dt+i4ZSLaZaNxIVMrQOWkm+LTVW4XMILPFmvKtYhwPc0
         evQB6lPPMlyIAsbub72EsExoHXIcMTaSak8bz1p8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 26/99] selftests: fib_tests: Fix 'Command line is not complete' errors
Date:   Tue,  7 May 2019 01:31:20 -0400
Message-Id: <20190507053235.29900-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
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
index 1080ff55a788..0d2a5f4f1e63 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -605,6 +605,39 @@ run_cmd()
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
@@ -652,31 +685,7 @@ check_route6()
 	pfx=$1
 
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
@@ -725,7 +734,7 @@ route_setup()
 	ip -netns ns2 addr add 172.16.103.2/24 dev veth4
 	ip -netns ns2 addr add 172.16.104.1/24 dev dummy1
 
-	set +ex
+	set +e
 }
 
 # assumption is that basic add of a single path route works
@@ -960,7 +969,8 @@ ipv6_addr_metric_test()
 	run_cmd "$IP li set dev dummy2 down"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route6 ""
+		out=$($IP -6 ro ls match 2001:db8:104::/64)
+		check_expected "${out}" ""
 		rc=$?
 	fi
 	log_test $rc 0 "Prefix route removed on link down"
@@ -1091,38 +1101,13 @@ check_route()
 	local pfx
 	local expected="$1"
 	local out
-	local rc=0
 
 	set -- $expected
 	pfx=$1
 	[ "${pfx}" = "unreachable" ] && pfx=$2
 
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
@@ -1387,7 +1372,8 @@ ipv4_addr_metric_test()
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

