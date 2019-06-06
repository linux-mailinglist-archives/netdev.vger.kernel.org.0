Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99CE37E47
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfFFURE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729088AbfFFUPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 16:15:20 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37AD03086209;
        Thu,  6 Jun 2019 20:15:15 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D961619E6;
        Thu,  6 Jun 2019 20:15:11 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] selftests: pmtu: Introduce list_flush_ipv6_exception test case
Date:   Thu,  6 Jun 2019 22:15:09 +0200
Message-Id: <557584d1724aba01c3ba56c5c39173334e180db6.1559851698.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 06 Jun 2019 20:15:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test checks that route exceptions can be successfully listed and
flushed using ip -6 route {list,flush} cache.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
This will cause a minor conflict with David Ahern's patch:
"[PATCH net-next 17/19] selftests: pmtu: Add support for routing
via nexthop objects", currently under review. The "re-run with nh"
flag for this test in the test list will need to be set to 1.

I can also re-submit this based on that patch, if it helps.

 tools/testing/selftests/net/pmtu.sh | 51 ++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 4a1275990d7e..efda4fb1c989 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -111,6 +111,10 @@
 #
 # - cleanup_ipv6_exception
 #	Same as above, but use IPv6 transport from A to B
+#
+# - list_flush_ipv6_exception
+#	Using the same topology as in pmtu_ipv6, create exceptions, and check
+#	they are shown when listing exception caches, gone after flushing them
 
 
 # Kselftest framework requirement - SKIP code is 4.
@@ -150,7 +154,8 @@ tests="
 	pmtu_vti6_link_add_mtu		vti6: MTU setting on link creation
 	pmtu_vti6_link_change_mtu	vti6: MTU changes on link changes
 	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions
-	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions"
+	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions
+	list_flush_ipv6_exception	ipv6: list and flush cached exceptions"
 
 NS_A="ns-A"
 NS_B="ns-B"
@@ -1090,6 +1095,50 @@ test_cleanup_ipv4_exception() {
 	test_cleanup_vxlanX_exception 4
 }
 
+test_list_flush_ipv6_exception() {
+	setup namespaces routing || return 2
+	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
+	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
+	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
+
+	dst1="${prefix6}:${b_r1}::1"
+	dst2="${prefix6}:${b_r2}::1"
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
+	# Create route exceptions
+	run_cmd ${ns_a} ${ping6} -q -M want -i 0.1 -w 1 -s 1800 ${dst1}
+	run_cmd ${ns_a} ${ping6} -q -M want -i 0.1 -w 1 -s 1800 ${dst2}
+
+	if [ "$(${ns_a} ip -6 route list cache | wc -l)" -ne 2 ]; then
+		err "  can't list cached exceptions"
+		fail=1
+	fi
+
+	run_cmd ${ns_a} ip -6 route flush cache
+	sleep 1
+	pmtu1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst1})"
+	pmtu2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
+	if [ -n "${pmtu1}" ] || [ -n "${pmtu2}" ]; then
+		err "  can't flush cached exceptions"
+		fail=1
+	fi
+
+	return ${fail}
+}
+
 usage() {
 	echo
 	echo "$0 [OPTIONS] [TEST]..."
-- 
2.20.1

