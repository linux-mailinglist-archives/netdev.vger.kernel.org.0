Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57747E2B5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387771AbfHASzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731751AbfHASzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:13 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DAF020679;
        Thu,  1 Aug 2019 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685712;
        bh=HOOi+cNotB6y7hVDtYuUqkxVEMgefp4xCRYmGmTcVmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoU0uEP+sfxW+HpNu1sezzyet4EhMplq+8GgxJn5TguRK16MzBC3xWddBqbtxlkPT
         ty0RR/PbK6S6hAhtWHgB3+/iH2vwCHo3d89unaZMCnIS4e0uH8KA1Cw0NCMPyUC84P
         EpxPZJy6b+CMeJAp6jOl9VOzZ/dTdrymAjxcRJtk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 04/15] selftests: Add ipv6 ping tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:37 -0700
Message-Id: <20190801185648.27653-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv6 ping tests to fcnal-test.sh. Covers the permutations of directly
connected addresses, routed destinations, VRF and non-VRF, and expected
failures.

Setup includes unreachable routes and fib rules blocking traffic.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 284 +++++++++++++++++++++++++++++-
 1 file changed, 283 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3f6e786b34ae..4da510f6d625 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -712,6 +712,287 @@ ipv4_ping()
 }
 
 ################################################################################
+# IPv6
+
+ipv6_ping_novrf()
+{
+	local a
+
+	# should not have an impact, but make a known state
+	set_sysctl net.ipv4.raw_l3mdev_accept=0 2>/dev/null
+
+	#
+	# out
+	#
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping out"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 0 "ping out, device bind"
+
+		log_start
+		run_cmd ${ping6} -c1 -w1 -I ${NSA_LO_IP6} ${a}
+		log_test_addr ${a} $? 0 "ping out, loopback address bind"
+	done
+
+	#
+	# in
+	#
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ${NSA_LINKIP6}%${NSB_DEV} ${MCAST}%${NSB_DEV}
+	do
+		log_start
+		run_cmd_nsb ${ping6} -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping in"
+	done
+
+	#
+	# local traffic, local address
+	#
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ::1 ${NSA_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping local, no bind"
+	done
+
+	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 0 "ping local, device bind"
+	done
+
+	for a in ${NSA_LO_IP6} ::1
+	do
+		log_start
+		show_hint "Fails since address on loopback is out of device scope"
+		run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 2 "ping local, device bind"
+	done
+
+	#
+	# ip rule blocks address
+	#
+	log_start
+	setup_cmd ip -6 rule add pref 32765 from all lookup local
+	setup_cmd ip -6 rule del pref 0 from all lookup local
+	setup_cmd ip -6 rule add pref 50 to ${NSB_LO_IP6} prohibit
+	setup_cmd ip -6 rule add pref 51 from ${NSB_IP6} prohibit
+
+	a=${NSB_LO_IP6}
+	run_cmd ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, blocked by rule"
+
+	log_start
+	run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, blocked by rule"
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Response lost due to ip rule"
+	run_cmd_nsb ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, blocked by rule"
+
+	setup_cmd ip -6 rule add pref 0 from all lookup local
+	setup_cmd ip -6 rule del pref 32765 from all lookup local
+	setup_cmd ip -6 rule del pref 50 to ${NSB_LO_IP6} prohibit
+	setup_cmd ip -6 rule del pref 51 from ${NSB_IP6} prohibit
+
+	#
+	# route blocks reachability to remote address
+	#
+	log_start
+	setup_cmd ip -6 route del ${NSB_LO_IP6}
+	setup_cmd ip -6 route add unreachable ${NSB_LO_IP6} metric 10
+	setup_cmd ip -6 route add unreachable ${NSB_IP6} metric 10
+
+	a=${NSB_LO_IP6}
+	run_cmd ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, blocked by route"
+
+	log_start
+	run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, blocked by route"
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Response lost due to ip route"
+	run_cmd_nsb ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, blocked by route"
+
+
+	#
+	# remove 'remote' routes; fallback to default
+	#
+	log_start
+	setup_cmd ip -6 ro del unreachable ${NSB_LO_IP6}
+	setup_cmd ip -6 ro del unreachable ${NSB_IP6}
+
+	a=${NSB_LO_IP6}
+	run_cmd ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, unreachable route"
+
+	log_start
+	run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, unreachable route"
+}
+
+ipv6_ping_vrf()
+{
+	local a
+
+	# should default on; does not exist on older kernels
+	set_sysctl net.ipv4.raw_l3mdev_accept=1 2>/dev/null
+
+	#
+	# out
+	#
+	for a in ${NSB_IP6} ${NSB_LO_IP6}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 -I ${VRF} ${a}
+		log_test_addr ${a} $? 0 "ping out, VRF bind"
+	done
+
+	for a in ${NSB_LINKIP6}%${VRF} ${MCAST}%${VRF}
+	do
+		log_start
+		show_hint "Fails since VRF device does not support linklocal or multicast"
+		run_cmd ${ping6} -c1 -w1 ${a}
+		log_test_addr ${a} $? 2 "ping out, VRF bind"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 0 "ping out, device bind"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
+	do
+		log_start
+		run_cmd ip vrf exec ${VRF} ${ping6} -c1 -w1 -I ${VRF_IP6} ${a}
+		log_test_addr ${a} $? 0 "ping out, vrf device+address bind"
+	done
+
+	#
+	# in
+	#
+	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV} ${MCAST}%${NSB_DEV}
+	do
+		log_start
+		run_cmd_nsb ${ping6} -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping in"
+	done
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Fails since loopback address is out of VRF scope"
+	run_cmd_nsb ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in"
+
+	#
+	# local traffic, local address
+	#
+	for a in ${NSA_IP6} ${VRF_IP6} ::1
+	do
+		log_start
+		show_hint "Source address should be ${a}"
+		run_cmd ${ping6} -c1 -w1 -I ${VRF} ${a}
+		log_test_addr ${a} $? 0 "ping local, VRF bind"
+	done
+
+	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSA_DEV} ${MCAST}%${NSA_DEV}
+	do
+		log_start
+		run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 0 "ping local, device bind"
+	done
+
+	# LLA to GUA - remove ipv6 global addresses from ns-B
+	setup_cmd_nsb ip -6 addr del ${NSB_IP6}/64 dev ${NSB_DEV}
+	setup_cmd_nsb ip -6 addr del ${NSB_LO_IP6}/128 dev lo
+	setup_cmd_nsb ip -6 ro add ${NSA_IP6}/128 via ${NSA_LINKIP6} dev ${NSB_DEV}
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd_nsb ${ping6} -c1 -w1 ${NSA_IP6}
+		log_test_addr ${a} $? 0 "ping in, LLA to GUA"
+	done
+
+	setup_cmd_nsb ip -6 ro del ${NSA_IP6}/128 via ${NSA_LINKIP6} dev ${NSB_DEV}
+	setup_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV}
+	setup_cmd_nsb ip -6 addr add ${NSB_LO_IP6}/128 dev lo
+
+	#
+	# ip rule blocks address
+	#
+	log_start
+	setup_cmd ip -6 rule add pref 50 to ${NSB_LO_IP6} prohibit
+	setup_cmd ip -6 rule add pref 51 from ${NSB_IP6} prohibit
+
+	a=${NSB_LO_IP6}
+	run_cmd ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, blocked by rule"
+
+	log_start
+	run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, blocked by rule"
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Response lost due to ip rule"
+	run_cmd_nsb ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, blocked by rule"
+
+	log_start
+	setup_cmd ip -6 rule del pref 50 to ${NSB_LO_IP6} prohibit
+	setup_cmd ip -6 rule del pref 51 from ${NSB_IP6} prohibit
+
+	#
+	# remove 'remote' routes; fallback to default
+	#
+	log_start
+	setup_cmd ip -6 ro del ${NSB_LO_IP6} vrf ${VRF}
+
+	a=${NSB_LO_IP6}
+	run_cmd ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, unreachable route"
+
+	log_start
+	run_cmd ${ping6} -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, unreachable route"
+
+	ip -netns ${NSB} -6 ro del ${NSA_LO_IP6}
+	a=${NSA_LO_IP6}
+	log_start
+	run_cmd_nsb ${ping6} -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping in, unreachable route"
+}
+
+ipv6_ping()
+{
+	log_section "IPv6 ping"
+
+	log_subsection "No VRF"
+	setup
+	ipv6_ping_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv6_ping_vrf
+}
+
+################################################################################
 # usage
 
 usage()
@@ -732,7 +1013,7 @@ EOF
 # main
 
 TESTS_IPV4="ipv4_ping"
-TESTS_IPV6=""
+TESTS_IPV6="ipv6_ping"
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -771,6 +1052,7 @@ for t in $TESTS
 do
 	case $t in
 	ipv4_ping|ping)  ipv4_ping;;
+	ipv6_ping|ping6) ipv6_ping;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
-- 
2.11.0

