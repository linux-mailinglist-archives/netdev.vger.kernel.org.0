Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE54D4EC7F
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfFUPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:47:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfFUPr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:47:29 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 802D3C18B2C4;
        Fri, 21 Jun 2019 15:47:29 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9B2719C6A;
        Fri, 21 Jun 2019 15:47:23 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v7 11/11] selftests: pmtu: Make list_flush_ipv6_exception test more demanding
Date:   Fri, 21 Jun 2019 17:45:30 +0200
Message-Id: <c8a79cbeca4454354425d893f9f195d9385100d4.1561131177.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 21 Jun 2019 15:47:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of just listing and flushing two cached exceptions, create
a relatively big number of them, and count how many are listed. Single
netlink dump messages contain approximately 25 entries each, and this
way we can make sure the partial dump tracking mechanism is working
properly.

While at it, also ensure that no cached routes can be listed after
flush, and remove 'sleep 1' calls, they are not actually needed.

v7: No changes

v6:
  - Merge this patch into series including fix, as it's also targeted
    for net-next. No actual changes

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index f5004a9df229..ab367e75f095 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1274,7 +1274,7 @@ test_list_flush_ipv6_exception() {
 	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
 	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
 
-	dst1="${prefix6}:${b_r1}::1"
+	dst_prefix1="${prefix6}:${b_r1}::"
 	dst2="${prefix6}:${b_r2}::1"
 
 	# Set up initial MTU values
@@ -1290,20 +1290,26 @@ test_list_flush_ipv6_exception() {
 
 	fail=0
 
-	# Create route exceptions
-	run_cmd ${ns_a} ${ping6} -q -M want -i 0.1 -w 1 -s 1800 ${dst1}
-	run_cmd ${ns_a} ${ping6} -q -M want -i 0.1 -w 1 -s 1800 ${dst2}
+	# Add 100 addresses for veth endpoint on B reached by default A route
+	for i in $(seq 100 199); do
+		run_cmd ${ns_b} ip addr add "${dst_prefix1}${i}" dev veth_B-R1
+	done
 
-	if [ "$(${ns_a} ip -6 route list cache | wc -l)" -ne 2 ]; then
+	# Create 100 cached route exceptions for path via R1, one via R2
+	for i in $(seq 100 199); do
+		run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s 1800 "${dst_prefix1}${i}"
+	done
+	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s 1800 "${dst2}"
+	if [ "$(${ns_a} ip -6 route list cache | wc -l)" -ne 101 ]; then
 		err "  can't list cached exceptions"
 		fail=1
 	fi
 
 	run_cmd ${ns_a} ip -6 route flush cache
-	sleep 1
-	pmtu1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst1})"
+	pmtu1="$(route_get_dst_pmtu_from_exception "${ns_a}" "${dst_prefix1}100")"
 	pmtu2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
-	if [ -n "${pmtu1}" ] || [ -n "${pmtu2}" ]; then
+	if [ -n "${pmtu1}" ] || [ -n "${pmtu2}" ] || \
+	   [ -n "$(${ns_a} ip -6 route list cache)" ]; then
 		err "  can't flush cached exceptions"
 		fail=1
 	fi
-- 
2.20.1

