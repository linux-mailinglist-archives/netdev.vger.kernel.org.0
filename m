Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9911A49EF0D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344157AbiA0Xws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:48 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43020 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343822AbiA0Xwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:44 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E4D5060880;
        Fri, 28 Jan 2022 00:49:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/8] selftests: nft_concat_range: add test for reload with no element add/del
Date:   Fri, 28 Jan 2022 00:52:34 +0100
Message-Id: <20220127235235.656931-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add a specific test for the reload issue fixed with
commit 23c54263efd7cb ("netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone").

Add to set, then flush set content + restore without other add/remove in
the transaction.

On kernels before the fix, this test case fails:
  net,mac with reload    [FAIL]

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_concat_range.sh   | 72 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index ed61f6cab60f..df322e47a54f 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -27,7 +27,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add"
+BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -354,6 +354,23 @@ TYPE_flush_remove_add="
 display		Add two elements, flush, re-add
 "
 
+TYPE_reload="
+display		net,mac with reload
+type_spec	ipv4_addr . ether_addr
+chain_spec	ip daddr . ether saddr
+dst		addr4
+src		mac
+start		1
+count		1
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1473,6 +1490,59 @@ test_bug_flush_remove_add() {
 	nft flush ruleset
 }
 
+# - add ranged element, check that packets match it
+# - reload the set, check packets still match
+test_bug_reload() {
+	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+	rstart=${start}
+
+	range_size=1
+	for i in $(seq "${start}" $((start + count))); do
+		end=$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=${end}
+			end=$((end + 1))
+		fi
+		srcstart=$((start + src_delta))
+		srcend=$((end + src_delta))
+
+		add "$(format)" || return 1
+		range_size=$((range_size + 1))
+		start=$((end + range_size))
+	done
+
+	# check kernel does allocate pcpu sctrach map
+	# for reload with no elemet add/delete
+	( echo flush set inet filter test ;
+	  nft list set inet filter test ) | nft -f -
+
+	start=${rstart}
+	range_size=1
+
+	for i in $(seq "${start}" $((start + count))); do
+		end=$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=${end}
+			end=$((end + 1))
+		fi
+		srcstart=$((start + src_delta))
+		srcend=$((end + src_delta))
+
+		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+			send_match "${j}" $((j + src_delta)) || return 1
+		done
+
+		range_size=$((range_size + 1))
+		start=$((end + range_size))
+	done
+
+	nft flush ruleset
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.30.2

