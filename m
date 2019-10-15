Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80BD7034
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfJOHdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:33:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42146 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbfJOHdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:33:08 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id EB60A25BE36;
        Tue, 15 Oct 2019 18:32:56 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 836C5E207B6; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 5/6] selftests: netfilter: add ipvs nat test case
Date:   Tue, 15 Oct 2019 09:32:11 +0200
Message-Id: <20191015073212.19394-6-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
References: <20191015073212.19394-1-horms@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Test virtual server via NAT.

Tested:
# selftests: netfilter: ipvs.sh
# Testing DR mode...
# Testing NAT mode...
# ipvs.sh: PASS

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 tools/testing/selftests/netfilter/ipvs.sh | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/ipvs.sh b/tools/testing/selftests/netfilter/ipvs.sh
index 3d11d87f3e84..8b2e618d6a6a 100755
--- a/tools/testing/selftests/netfilter/ipvs.sh
+++ b/tools/testing/selftests/netfilter/ipvs.sh
@@ -154,20 +154,40 @@ test_dr() {
 	test_service
 }
 
+test_nat() {
+	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+
+	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
+	ip netns exec ns1 ipvsadm -a -m -t ${vip_v4}:${port} -r ${rip_v4}:${port}
+	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+
+	ip netns exec ns2 ip link del veth20
+	ip netns exec ns2 ip route add default via ${dip_v4} dev veth21
+
+	test_service
+}
+
 run_tests() {
 	local errors=
 
 	echo "Testing DR mode..."
+	cleanup
 	setup
 	test_dr
 	errors=$(( $errors + $? ))
 
+	echo "Testing NAT mode..."
+	cleanup
+	setup
+	test_nat
+	errors=$(( $errors + $? ))
+
 	return $errors
 }
 
 trap cleanup EXIT
 
-cleanup
 run_tests
 
 if [ $? -ne 0 ]; then
-- 
2.11.0

