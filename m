Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6731D886D2
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 01:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfHIXLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 19:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfHIXLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 19:11:45 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 308442086D;
        Fri,  9 Aug 2019 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565392304;
        bh=+aBbco4oASy821Kckd+3T6eOhVInP0auiGj+grXwjNo=;
        h=From:To:Cc:Subject:Date:From;
        b=EhegFTq8eU9luJCzrS4BIs2MF0sjumDV2omQMVECWwZ7q0wqRkrpdxU85pZuzrnoK
         G4/BXYHf6HDGz5P0gnGmKTerm2Ewh+vlrZU1SjjHNpjUqhEvWf9j84/OCVGzl443uV
         cV7CS/lXj0PEYvv34m4DkMhxJf3FDs1htc2cmG08=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] selftests: Fix detection of nettest command in fcnal-test
Date:   Fri,  9 Aug 2019 16:13:38 -0700
Message-Id: <20190809231338.29105-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Most of the tests run by fcnal-test.sh relies on the nettest command.
Rather than trying to cover all of the individual tests, check for the
binary only at the beginning.

Also removes the need for log_error which is undefined.

Fixes: 6f9d5cacfe07 ("selftests: Setup for functional tests for fib and socket lookups")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 38 +++++--------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index bd6b564382ec..9fd3a0b97f0d 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -998,13 +998,6 @@ ipv4_tcp_vrf()
 ipv4_tcp()
 {
 	log_section "IPv4/TCP"
-
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		log_error "nettest not found; skipping tests"
-		return
-	fi
-
 	log_subsection "No VRF"
 	setup
 
@@ -1375,12 +1368,6 @@ ipv4_udp_vrf()
 
 ipv4_udp()
 {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		log_error "nettest not found; skipping tests"
-		return
-	fi
-
 	log_section "IPv4/UDP"
 	log_subsection "No VRF"
 
@@ -2314,13 +2301,6 @@ ipv6_tcp_vrf()
 ipv6_tcp()
 {
 	log_section "IPv6/TCP"
-
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		log_error "nettest not found; skipping tests"
-		return
-	fi
-
 	log_subsection "No VRF"
 	setup
 
@@ -3156,12 +3136,6 @@ netfilter_icmp()
 
 ipv4_netfilter()
 {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		log_error "nettest not found; skipping tests"
-		return
-	fi
-
 	log_section "IPv4 Netfilter"
 	log_subsection "TCP reset"
 
@@ -3219,12 +3193,6 @@ netfilter_icmp6()
 
 ipv6_netfilter()
 {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		log_error "nettest not found; skipping tests"
-		return
-	fi
-
 	log_section "IPv6 Netfilter"
 	log_subsection "TCP reset"
 
@@ -3422,6 +3390,12 @@ elif [ "$TESTS" = "ipv6" ]; then
 	TESTS="$TESTS_IPV6"
 fi
 
+which nettest >/dev/null
+if [ $? -ne 0 ]; then
+	echo "'nettest' command not found; skipping tests"
+	exit 0
+fi
+
 declare -i nfail=0
 declare -i nsuccess=0
 
-- 
2.11.0

