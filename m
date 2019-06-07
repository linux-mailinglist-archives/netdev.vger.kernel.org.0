Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C900C38E7B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbfFGPJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbfFGPJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:09:48 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FD90214AE;
        Fri,  7 Jun 2019 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559920187;
        bh=+A92KC74npAf4nzCNBgqr2fSDpcV3Y6OjsRQhUwY2G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2lj6rkBJp1zXzLio7laM82Q9G0NUig4q5zS65OS5KZuT98b8xxzmLSbi5YlhyyVD
         Vko0uHGZf9DCblyDE+A53Er1wMiaJeyywSBc+LC9qDkFxJms4c/NBgrCrznmBK4qdC
         FBWelylrSHMd02wc3vQhoS9x3io+3JVct64poQOU=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 18/20] selftests: icmp_redirect: Add support for routing via nexthop objects
Date:   Fri,  7 Jun 2019 08:09:39 -0700
Message-Id: <20190607150941.11371-19-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607150941.11371-1-dsahern@kernel.org>
References: <20190607150941.11371-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a second pass to icmp_redirect.sh to use nexthop objects for
routes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/icmp_redirect.sh | 49 ++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index 76a7c4472dc3..18c5de53558a 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -331,6 +331,38 @@ run_ping()
 	run_cmd ip netns exec h1 ${ping6} -q -M want -i 0.5 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP6}
 }
 
+replace_route_new()
+{
+	# r1 to h2 via r2 and eth0
+	run_cmd ip -netns r1 nexthop replace id 1 via ${R2_N1_IP} dev eth0
+	run_cmd ip -netns r1 nexthop replace id 2 via ${R2_LLADDR} dev eth0
+}
+
+reset_route_new()
+{
+	run_cmd ip -netns r1 nexthop flush
+	run_cmd ip -netns h1 nexthop flush
+
+	initial_route_new
+}
+
+initial_route_new()
+{
+	# r1 to h2 via r2 and eth1
+	run_cmd ip -netns r1 nexthop add id 1 via ${R2_R1_N1_IP} dev eth1
+	run_cmd ip -netns r1 ro add ${H2_N2} nhid 1
+
+	run_cmd ip -netns r1 nexthop add id 2 via ${R2_R1_N1_IP6} dev eth1
+	run_cmd ip -netns r1 -6 ro add ${H2_N2_6} nhid 2
+
+	# h1 to h2 via r1
+	run_cmd ip -netns h1 nexthop add id 1 via ${R1_N1_IP} dev br0
+	run_cmd ip -netns h1 ro add ${H1_VRF_ARG} ${H2_N2} nhid 1
+
+	run_cmd ip -netns h1 nexthop add id 2 via ${R1_LLADDR} dev br0
+	run_cmd ip -netns h1 -6 ro add ${H1_VRF_ARG} ${H2_N2_6} nhid 2
+}
+
 replace_route_legacy()
 {
 	# r1 to h2 via r2 and eth0
@@ -479,6 +511,23 @@ WITH_VRF=yes
 setup
 do_test "legacy"
 
+cleanup
+log_section "Routing with nexthop objects"
+ip nexthop ls >/dev/null 2>&1
+if [ $? -eq 0 ]; then
+	WITH_VRF=no
+	setup
+	do_test "new"
+
+	cleanup
+	log_section "Routing with nexthop objects and VRF"
+	WITH_VRF=yes
+	setup
+	do_test "new"
+else
+	echo "Nexthop objects not supported; skipping tests"
+fi
+
 printf "\nTests passed: %3d\n" ${nsuccess}
 printf "Tests failed: %3d\n"   ${nfail}
 
-- 
2.11.0

