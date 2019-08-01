Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76367E2BF
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbfHASzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387710AbfHASzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:13 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6978E20B7C;
        Thu,  1 Aug 2019 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685712;
        bh=SndvNu/f7Uo28acu4or7rLkiS5+ysc+kDAB+nGk1HYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boouvGBvmJ7bTgSe/b6jvLNwd68lpgRN1Ztx6Oy5uel/tknJGSvmdv29DvrOQYeHu
         o9Y/+4XfMPPkQQcFLelZd/nJlSwJ6VeWvXJJsgxJ6GSQG61zpzKW7jfNabTzVJNqKM
         Fw4/Im75qbKTWIAgbcJdJok4wGYmY3l0emfPjdRw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 03/15] selftests: Add ipv4 ping tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:36 -0700
Message-Id: <20190801185648.27653-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add ping tests to fcnal-test.sh. Covers the permutations of directly
connected addresses, routed destinations, VRF and non-VRF, and expected
failures.

Setup includes unreachable routes and fib rules blocking traffic.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 268 +++++++++++++++++++++++++++++-
 1 file changed, 267 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 22cfbd2fd09c..3f6e786b34ae 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -448,6 +448,270 @@ setup()
 }
 
 ################################################################################
+# IPv4
+
+ipv4_ping_novrf()
+{
+	local a
+
+	#
+	# out
+	#
+	for a in ${NSB_IP} ${NSB_LO_IP}
+	do
+		log_start
+		run_cmd ping -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping out"
+
+		log_start
+		run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 0 "ping out, device bind"
+
+		log_start
+		run_cmd ping -c1 -w1 -I ${NSA_LO_IP} ${a}
+		log_test_addr ${a} $? 0 "ping out, address bind"
+	done
+
+	#
+	# in
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP}
+	do
+		log_start
+		run_cmd_nsb ping -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping in"
+	done
+
+	#
+	# local traffic
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		run_cmd ping -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping local"
+	done
+
+	#
+	# local traffic, socket bound to device
+	#
+	# address on device
+	a=${NSA_IP}
+	log_start
+	run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 0 "ping local, device bind"
+
+	# loopback addresses not reachable from device bind
+	# fails in a really weird way though because ipv4 special cases
+	# route lookups with oif set.
+	for a in ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Fails since address on loopback device is out of device scope"
+		run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 1 "ping local, device bind"
+	done
+
+	#
+	# ip rule blocks reachability to remote address
+	#
+	log_start
+	setup_cmd ip rule add pref 32765 from all lookup local
+	setup_cmd ip rule del pref 0 from all lookup local
+	setup_cmd ip rule add pref 50 to ${NSB_LO_IP} prohibit
+	setup_cmd ip rule add pref 51 from ${NSB_IP} prohibit
+
+	a=${NSB_LO_IP}
+	run_cmd ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, blocked by rule"
+
+	# NOTE: ipv4 actually allows the lookup to fail and yet still create
+	# a viable rtable if the oif (e.g., bind to device) is set, so this
+	# case succeeds despite the rule
+	# run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+
+	a=${NSA_LO_IP}
+	log_start
+	show_hint "Response generates ICMP (or arp request is ignored) due to ip rule"
+	run_cmd_nsb ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, blocked by rule"
+
+	[ "$VERBOSE" = "1" ] && echo
+	setup_cmd ip rule del pref 32765 from all lookup local
+	setup_cmd ip rule add pref 0 from all lookup local
+	setup_cmd ip rule del pref 50 to ${NSB_LO_IP} prohibit
+	setup_cmd ip rule del pref 51 from ${NSB_IP} prohibit
+
+	#
+	# route blocks reachability to remote address
+	#
+	log_start
+	setup_cmd ip route replace unreachable ${NSB_LO_IP}
+	setup_cmd ip route replace unreachable ${NSB_IP}
+
+	a=${NSB_LO_IP}
+	run_cmd ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, blocked by route"
+
+	# NOTE: ipv4 actually allows the lookup to fail and yet still create
+	# a viable rtable if the oif (e.g., bind to device) is set, so this
+	# case succeeds despite not having a route for the address
+	# run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+
+	a=${NSA_LO_IP}
+	log_start
+	show_hint "Response is dropped (or arp request is ignored) due to ip route"
+	run_cmd_nsb ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, blocked by route"
+
+	#
+	# remove 'remote' routes; fallback to default
+	#
+	log_start
+	setup_cmd ip ro del ${NSB_LO_IP}
+
+	a=${NSB_LO_IP}
+	run_cmd ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 2 "ping out, unreachable default route"
+
+	# NOTE: ipv4 actually allows the lookup to fail and yet still create
+	# a viable rtable if the oif (e.g., bind to device) is set, so this
+	# case succeeds despite not having a route for the address
+	# run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+}
+
+ipv4_ping_vrf()
+{
+	local a
+
+	# should default on; does not exist on older kernels
+	set_sysctl net.ipv4.raw_l3mdev_accept=1 2>/dev/null
+
+	#
+	# out
+	#
+	for a in ${NSB_IP} ${NSB_LO_IP}
+	do
+		log_start
+		run_cmd ping -c1 -w1 -I ${VRF} ${a}
+		log_test_addr ${a} $? 0 "ping out, VRF bind"
+
+		log_start
+		run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 0 "ping out, device bind"
+
+		log_start
+		run_cmd ip vrf exec ${VRF} ping -c1 -w1 -I ${NSA_IP} ${a}
+		log_test_addr ${a} $? 0 "ping out, vrf device + dev address bind"
+
+		log_start
+		run_cmd ip vrf exec ${VRF} ping -c1 -w1 -I ${VRF_IP} ${a}
+		log_test_addr ${a} $? 0 "ping out, vrf device + vrf address bind"
+	done
+
+	#
+	# in
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd_nsb ping -c1 -w1 ${a}
+		log_test_addr ${a} $? 0 "ping in"
+	done
+
+	#
+	# local traffic, local address
+	#
+	for a in ${NSA_IP} ${VRF_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Source address should be ${a}"
+		run_cmd ping -c1 -w1 -I ${VRF} ${a}
+		log_test_addr ${a} $? 0 "ping local, VRF bind"
+	done
+
+	#
+	# local traffic, socket bound to device
+	#
+	# address on device
+	a=${NSA_IP}
+	log_start
+	run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 0 "ping local, device bind"
+
+	# vrf device is out of scope
+	for a in ${VRF_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Fails since address on vrf device is out of device scope"
+		run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+		log_test_addr ${a} $? 1 "ping local, device bind"
+	done
+
+	#
+	# ip rule blocks address
+	#
+	log_start
+	setup_cmd ip rule add pref 50 to ${NSB_LO_IP} prohibit
+	setup_cmd ip rule add pref 51 from ${NSB_IP} prohibit
+
+	a=${NSB_LO_IP}
+	run_cmd ping -c1 -w1 -I ${VRF} ${a}
+	log_test_addr ${a} $? 2 "ping out, vrf bind, blocked by rule"
+
+	log_start
+	run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, blocked by rule"
+
+	a=${NSA_LO_IP}
+	log_start
+	show_hint "Response lost due to ip rule"
+	run_cmd_nsb ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, blocked by rule"
+
+	[ "$VERBOSE" = "1" ] && echo
+	setup_cmd ip rule del pref 50 to ${NSB_LO_IP} prohibit
+	setup_cmd ip rule del pref 51 from ${NSB_IP} prohibit
+
+	#
+	# remove 'remote' routes; fallback to default
+	#
+	log_start
+	setup_cmd ip ro del vrf ${VRF} ${NSB_LO_IP}
+
+	a=${NSB_LO_IP}
+	run_cmd ping -c1 -w1 -I ${VRF} ${a}
+	log_test_addr ${a} $? 2 "ping out, vrf bind, unreachable route"
+
+	log_start
+	run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
+	log_test_addr ${a} $? 2 "ping out, device bind, unreachable route"
+
+	a=${NSA_LO_IP}
+	log_start
+	show_hint "Response lost by unreachable route"
+	run_cmd_nsb ping -c1 -w1 ${a}
+	log_test_addr ${a} $? 1 "ping in, unreachable route"
+}
+
+ipv4_ping()
+{
+	log_section "IPv4 ping"
+
+	log_subsection "No VRF"
+	setup
+	set_sysctl net.ipv4.raw_l3mdev_accept=0 2>/dev/null
+	ipv4_ping_novrf
+	setup
+	set_sysctl net.ipv4.raw_l3mdev_accept=1 2>/dev/null
+	ipv4_ping_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv4_ping_vrf
+}
+
+################################################################################
 # usage
 
 usage()
@@ -467,7 +731,7 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4=""
+TESTS_IPV4="ipv4_ping"
 TESTS_IPV6=""
 PAUSE_ON_FAIL=no
 PAUSE=no
@@ -506,6 +770,8 @@ declare -i nsuccess=0
 for t in $TESTS
 do
 	case $t in
+	ipv4_ping|ping)  ipv4_ping;;
+
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
-- 
2.11.0

