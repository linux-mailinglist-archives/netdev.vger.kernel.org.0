Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5C74C44D
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbfFTAAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfFTAAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 20:00:40 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 338D030BB559;
        Thu, 20 Jun 2019 00:00:40 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D655F19C79;
        Thu, 20 Jun 2019 00:00:37 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v6 10/11] selftests: pmtu: Introduce list_flush_ipv4_exception test case
Date:   Thu, 20 Jun 2019 01:59:50 +0200
Message-Id: <1a0f37f619b130017cbff583c059e3f3c86ccded.1560987611.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560987611.git.sbrivio@redhat.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 20 Jun 2019 00:00:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test checks that route exceptions can be successfully listed and
flushed using ip -6 route {list,flush} cache.

v6:
  - Merge this patch into series including fix, as it's also targeted
    for net-next
  - Drop left-over print of 'ip route list cache | wc -l'

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 60 +++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 269e839b747e..f5004a9df229 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -112,6 +112,10 @@
 # - cleanup_ipv6_exception
 #	Same as above, but use IPv6 transport from A to B
 #
+# - list_flush_ipv4_exception
+#	Using the same topology as in pmtu_ipv4, create exceptions, and check
+#	they are shown when listing exception caches, gone after flushing them
+#
 # - list_flush_ipv6_exception
 #	Using the same topology as in pmtu_ipv6, create exceptions, and check
 #	they are shown when listing exception caches, gone after flushing them
@@ -156,6 +160,7 @@ tests="
 	pmtu_vti6_link_change_mtu	vti6: MTU changes on link changes	0
 	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions	1
 	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions	1
+	list_flush_ipv4_exception	ipv4: list and flush cached exceptions	1
 	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1"
 
 NS_A="ns-A"
@@ -1207,6 +1212,61 @@ run_test_nh() {
 	USE_NH=no
 }
 
+test_list_flush_ipv4_exception() {
+	setup namespaces routing || return 2
+	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
+	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
+	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
+
+	dst_prefix1="${prefix4}.${b_r1}."
+	dst2="${prefix4}.${b_r2}.1"
+
+	# Set up initial MTU values
+	mtu "${ns_a}"  veth_A-R1 2000
+	mtu "${ns_r1}" veth_R1-A 2000
+	mtu "${ns_r1}" veth_R1-B 1500
+	mtu "${ns_b}"  veth_B-R1 1500
+
+	mtu "${ns_a}"  veth_A-R2 2000
+	mtu "${ns_r2}" veth_R2-A 2000
+	mtu "${ns_r2}" veth_R2-B 1500
+	mtu "${ns_b}"  veth_B-R2 1500
+
+	fail=0
+
+	# Add 100 addresses for veth endpoint on B reached by default A route
+	for i in $(seq 100 199); do
+		run_cmd ${ns_b} ip addr add "${dst_prefix1}${i}" dev veth_B-R1
+	done
+
+	# Create 100 cached route exceptions for path via R1, one via R2. Note
+	# that with IPv4 we need to actually cause a route lookup that matches
+	# the exception caused by ICMP, in order to actually have a cached
+	# route, so we need to ping each destination twice
+	for i in $(seq 100 199); do
+		run_cmd ${ns_a} ping -q -M want -i 0.1 -c 2 -s 1800 "${dst_prefix1}${i}"
+	done
+	run_cmd ${ns_a} ping -q -M want -i 0.1 -c 2 -s 1800 "${dst2}"
+
+	# Each exception is printed as two lines
+	if [ "$(${ns_a} ip route list cache | wc -l)" -ne 202 ]; then
+		err "  can't list cached exceptions"
+		fail=1
+	fi
+
+	run_cmd ${ns_a} ip route flush cache
+	pmtu1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst_prefix}1)"
+	pmtu2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst_prefix}2)"
+	if [ -n "${pmtu1}" ] || [ -n "${pmtu2}" ] || \
+	   [ -n "$(${ns_a} ip route list cache)" ]; then
+		err "  can't flush cached exceptions"
+		fail=1
+	fi
+
+	return ${fail}
+}
+
 test_list_flush_ipv6_exception() {
 	setup namespaces routing || return 2
 	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
-- 
2.20.1

