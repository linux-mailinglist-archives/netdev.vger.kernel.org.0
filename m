Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75FDE5A12
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfJZLru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:50 -0400
Received: from correo.us.es ([193.147.175.20]:46440 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfJZLru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 328198C3C46
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24E7EA7EFC
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19607A7EE4; Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23EE1D190C;
        Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E90B242EE393;
        Sat, 26 Oct 2019 13:47:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/31] selftests: netfilter: add ipvs nat test case
Date:   Sat, 26 Oct 2019 13:47:14 +0200
Message-Id: <20191026114733.28111-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
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

