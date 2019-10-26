Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572CFE5A38
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfJZLs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:27 -0400
Received: from correo.us.es ([193.147.175.20]:46444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfJZLru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF6298C3C51
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF54121FF7
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B4F80DA840; Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDD25B7FF6;
        Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8E11042EE393;
        Sat, 26 Oct 2019 13:47:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/31] selftests: netfilter: add ipvs tunnel test case
Date:   Sat, 26 Oct 2019 13:47:15 +0200
Message-Id: <20191026114733.28111-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Test virtual server via ipip tunnel.

Tested:
# selftests: netfilter: ipvs.sh
# Testing DR mode...
# Testing NAT mode...
# Testing Tunnel mode...
# ipvs.sh: PASS
ok 6 selftests: netfilter: ipvs.sh

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 tools/testing/selftests/netfilter/ipvs.sh | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/netfilter/ipvs.sh b/tools/testing/selftests/netfilter/ipvs.sh
index 8b2e618d6a6a..c3b8f90c497e 100755
--- a/tools/testing/selftests/netfilter/ipvs.sh
+++ b/tools/testing/selftests/netfilter/ipvs.sh
@@ -168,6 +168,30 @@ test_nat() {
 	test_service
 }
 
+test_tun() {
+	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+
+	ip netns exec ns1 modprobe ipip
+	ip netns exec ns1 ip link set tunl0 up
+	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=0
+	ip netns exec ns1 sysctl -qw net.ipv4.conf.all.send_redirects=0
+	ip netns exec ns1 sysctl -qw net.ipv4.conf.default.send_redirects=0
+	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
+	ip netns exec ns1 ipvsadm -a -i -t ${vip_v4}:${port} -r ${rip_v4}:${port}
+	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+
+	ip netns exec ns2 modprobe ipip
+	ip netns exec ns2 ip link set tunl0 up
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_ignore=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_announce=2
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.rp_filter=0
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.tunl0.rp_filter=0
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.veth21.rp_filter=0
+	ip netns exec ns2 ip addr add ${vip_v4}/32 dev lo:1
+
+	test_service
+}
+
 run_tests() {
 	local errors=
 
@@ -183,6 +207,12 @@ run_tests() {
 	test_nat
 	errors=$(( $errors + $? ))
 
+	echo "Testing Tunnel mode..."
+	cleanup
+	setup
+	test_tun
+	errors=$(( $errors + $? ))
+
 	return $errors
 }
 
-- 
2.11.0

