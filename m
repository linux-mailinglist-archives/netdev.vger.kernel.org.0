Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAAE170BF0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBZWzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:55:02 -0500
Received: from correo.us.es ([193.147.175.20]:36434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgBZWzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 17:55:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 536D61C4384
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41D33DA390
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:54:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 36E64DA3C4; Wed, 26 Feb 2020 23:54:52 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4377ADA3C3;
        Wed, 26 Feb 2020 23:54:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 23:54:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1FC9242EF4E0;
        Wed, 26 Feb 2020 23:54:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/6] selftests: nft_concat_range: Add test for reported add/flush/add issue
Date:   Wed, 26 Feb 2020 23:54:41 +0100
Message-Id: <20200226225442.9598-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200226225442.9598-1-pablo@netfilter.org>
References: <20200226225442.9598-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Add a specific test for the crash reported by Phil Sutter and addressed
in the previous patch. The test cases that, in my intention, should
have covered these cases, that is, the ones from the 'concurrency'
section, don't run these sequences tightly enough and spectacularly
failed to catch this.

While at it, define a convenient way to add these kind of tests, by
adding a "reported issues" test section.

It's more convenient, for this particular test, to execute the set
setup in its own function. However, future test cases like this one
might need to call setup functions, and will typically need no tools
other than nft, so allow for this in check_tools().

The original form of the reproducer used here was provided by Phil.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_concat_range.sh        | 43 ++++++++++++++++++++--
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index 5c1033ee1b39..5a4938d6dcf2 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -13,11 +13,12 @@
 KSELFTEST_SKIP=4
 
 # Available test groups:
+# - reported_issues: check for issues that were reported in the past
 # - correctness: check that packets match given entries, and only those
 # - concurrency: attempt races between insertion, deletion and lookup
 # - timeout: check that packets match entries until they expire
 # - performance: estimate matching rate, compare with rbtree and hash baselines
-TESTS="correctness concurrency timeout"
+TESTS="reported_issues correctness concurrency timeout"
 [ "${quicktest}" != "1" ] && TESTS="${TESTS} performance"
 
 # Set types, defined by TYPE_ variables below
@@ -25,6 +26,9 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net_port_net net_mac net_mac_icmp net6_mac_icmp net6_port_net6_port
        net_port_mac_proto_net"
 
+# Reported bugs, also described by TYPE_ variables below
+BUGS="flush_remove_add"
+
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
 	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -327,6 +331,12 @@ flood_spec	ip daddr . tcp dport . meta l4proto . ip saddr
 perf_duration	0
 "
 
+# Definition of tests for bugs reported in the past:
+# display	display text for test report
+TYPE_flush_remove_add="
+display		Add two elements, flush, re-add
+"
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -440,6 +450,8 @@ setup_set() {
 
 # Check that at least one of the needed tools is available
 check_tools() {
+	[ -z "${tools}" ] && return 0
+
 	__tools=
 	for tool in ${tools}; do
 		if [ "${tool}" = "nc" ] && [ "${proto}" = "udp6" ] && \
@@ -1430,6 +1442,23 @@ test_performance() {
 	kill "${perf_pid}"
 }
 
+test_bug_flush_remove_add() {
+	set_cmd='{ set s { type ipv4_addr . inet_service; flags interval; }; }'
+	elem1='{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
+	elem2='{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'
+	for i in `seq 1 100`; do
+		nft add table t ${set_cmd}	|| return ${KSELFTEST_SKIP}
+		nft add element t s ${elem1}	2>/dev/null || return 1
+		nft flush set t s		2>/dev/null || return 1
+		nft add element t s ${elem2}	2>/dev/null || return 1
+	done
+	nft flush ruleset
+}
+
+test_reported_issues() {
+	eval test_bug_"${subtest}"
+}
+
 # Run everything in a separate network namespace
 [ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
 tmp="$(mktemp)"
@@ -1438,9 +1467,15 @@ trap cleanup EXIT
 # Entry point for test runs
 passed=0
 for name in ${TESTS}; do
-	printf "TEST: %s\n" "${name}"
-	for type in ${TYPES}; do
-		eval desc=\$TYPE_"${type}"
+	printf "TEST: %s\n" "$(echo ${name} | tr '_' ' ')"
+	if [ "${name}" = "reported_issues" ]; then
+		SUBTESTS="${BUGS}"
+	else
+		SUBTESTS="${TYPES}"
+	fi
+
+	for subtest in ${SUBTESTS}; do
+		eval desc=\$TYPE_"${subtest}"
 		IFS='
 '
 		for __line in ${desc}; do
-- 
2.11.0

