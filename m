Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2252F048E
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAJAUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbhAJAUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:20:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E02F523A1C;
        Sun, 10 Jan 2021 00:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237942;
        bh=v/2E+jDqIc4ZgeYhzm60WjVbmfnkMDz4RKB06ymX+Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5dSa5uZ7ZAdgRBW5rmxVlb/oHDEN+hkdoEpEjwlt3tD6xZ3/JSw8TEbik49V17U2
         KafaAnnWm1ZV3Bx9p3ep3ofUySyDl1lpvJXnNLx0GZSehw8HyRdDkBQ/9YW1B72xhf
         zsTSHqPHyOdg9no2Z3q8kI7u6TQoEK+oXYwSC23wpivFvAKOtV4d4Tc8N7sx3rSrT7
         N8ZQMpefW9D03JEa1nYeXRuybAumLFZiojWidscDguOgmwKaai2Uef2IhlVaKFbbJ9
         AfhIaPa7W5/DfdvdLQHX3W5U3iPrexTyGkQCwyYe1BTEXxzESe5XQeoSn8jCVloWg1
         jWqVG0w3POuVA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v2 11/11] selftests: Add separate options for server device bindings
Date:   Sat,  9 Jan 2021 17:18:52 -0700
Message-Id: <20210110001852.35653-12-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210110001852.35653-1-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add new options to nettest to specify device binding and expected
device binding for server mode, and update fcnal-test script. This
is needed to allow a single instance of nettest running both server
and client modes to use different device bindings.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 282 +++++++++++-----------
 tools/testing/selftests/net/nettest.c     |  14 +-
 2 files changed, 154 insertions(+), 142 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 5d15ded2433b..2514a9cb9530 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -869,7 +869,7 @@ ipv4_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
@@ -877,7 +877,7 @@ ipv4_tcp_md5()
 	# client sends MD5, server not configured
 	log_start
 	show_hint "Should timeout since server does not have MD5 auth"
-	run_cmd nettest -s -d ${VRF} &
+	run_cmd nettest -s -I ${VRF} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
@@ -885,7 +885,7 @@ ipv4_tcp_md5()
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
@@ -893,7 +893,7 @@ ipv4_tcp_md5()
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
@@ -904,7 +904,7 @@ ipv4_tcp_md5()
 
 	# client in prefix
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
@@ -912,7 +912,7 @@ ipv4_tcp_md5()
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
@@ -920,7 +920,7 @@ ipv4_tcp_md5()
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout since client address is outside of prefix"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
@@ -930,14 +930,14 @@ ipv4_tcp_md5()
 	#
 
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
@@ -945,7 +945,7 @@ ipv4_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
@@ -953,21 +953,21 @@ ipv4_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
@@ -975,7 +975,7 @@ ipv4_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
@@ -983,7 +983,7 @@ ipv4_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
@@ -993,11 +993,11 @@ ipv4_tcp_md5()
 	# negative tests
 	#
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP}
+	run_cmd nettest -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
 
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET}
+	run_cmd nettest -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
 
 }
@@ -1020,7 +1020,7 @@ ipv4_tcp_novrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} &
+	run_cmd nettest -s -I ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -r ${a}
 	log_test_addr ${a} $? 0 "Device server"
@@ -1076,7 +1076,7 @@ ipv4_tcp_novrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} &
+	run_cmd nettest -s -I ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
@@ -1085,7 +1085,7 @@ ipv4_tcp_novrf()
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
-		run_cmd nettest -s -d ${NSA_DEV} &
+		run_cmd nettest -s -I ${NSA_DEV} &
 		sleep 1
 		run_cmd nettest -r ${a}
 		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
@@ -1110,7 +1110,7 @@ ipv4_tcp_novrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest  -d ${NSA_DEV} -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local connection"
@@ -1145,13 +1145,13 @@ ipv4_tcp_vrf()
 		log_test_addr ${a} $? 1 "Global server"
 
 		log_start
-		run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -s -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		log_start
-		run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
@@ -1186,14 +1186,14 @@ ipv4_tcp_vrf()
 	do
 		log_start
 		show_hint "client socket should be bound to VRF"
-		run_cmd nettest -s -2 ${VRF} &
+		run_cmd nettest -s -3 ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
 		show_hint "client socket should be bound to VRF"
-		run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -s -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
@@ -1208,7 +1208,7 @@ ipv4_tcp_vrf()
 	a=${NSA_IP}
 	log_start
 	show_hint "client socket should be bound to device"
-	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -r ${a}
 	log_test_addr ${a} $? 0 "Device server"
@@ -1218,7 +1218,7 @@ ipv4_tcp_vrf()
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since client is not bound to VRF"
-		run_cmd nettest -s -d ${VRF} &
+		run_cmd nettest -s -I ${VRF} &
 		sleep 1
 		run_cmd nettest -r ${a}
 		log_test_addr ${a} $? 1 "Global server, local connection"
@@ -1255,7 +1255,7 @@ ipv4_tcp_vrf()
 	for a in ${NSA_IP} ${VRF_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -s -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd nettest -r ${a} -d ${VRF} -0 ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local connection"
@@ -1263,26 +1263,26 @@ ipv4_tcp_vrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+	run_cmd nettest -s -I ${VRF} -3 ${VRF} &
 	sleep 1
 	run_cmd nettest -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local connection"
 
 	log_start
 	show_hint "Should fail 'No route to host' since client is out of VRF scope"
-	run_cmd nettest -s -d ${VRF} &
+	run_cmd nettest -s -I ${VRF} &
 	sleep 1
 	run_cmd nettest -r ${a}
 	log_test_addr ${a} $? 1 "VRF server, unbound client, local connection"
 
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -r ${a} -d ${VRF} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, VRF client, local connection"
 
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local connection"
@@ -1321,7 +1321,7 @@ ipv4_udp_novrf()
 	for a in ${NSA_IP} ${NSA_LO_IP}
 	do
 		log_start
-		run_cmd nettest -D -s -2 ${NSA_DEV} &
+		run_cmd nettest -D -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
@@ -1334,7 +1334,7 @@ ipv4_udp_novrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -D -r ${a}
 	log_test_addr ${a} $? 0 "Device server"
@@ -1393,7 +1393,7 @@ ipv4_udp_novrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -r ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
@@ -1402,7 +1402,7 @@ ipv4_udp_novrf()
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since address is out of device scope"
-		run_cmd nettest -s -D -d ${NSA_DEV} &
+		run_cmd nettest -s -D -I ${NSA_DEV} &
 		sleep 1
 		run_cmd nettest -D -r ${a}
 		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
@@ -1456,7 +1456,7 @@ ipv4_udp_novrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -D -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -D -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local conn"
@@ -1487,13 +1487,13 @@ ipv4_udp_vrf()
 		log_test_addr ${a} $? 1 "Global server"
 
 		log_start
-		run_cmd nettest -D -d ${VRF} -s -2 ${NSA_DEV} &
+		run_cmd nettest -D -I ${VRF} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		log_start
-		run_cmd nettest -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
@@ -1513,26 +1513,26 @@ ipv4_udp_vrf()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, enslaved device client, local connection"
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
@@ -1547,19 +1547,19 @@ ipv4_udp_vrf()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest -D -s -2 ${NSA_DEV} &
+		run_cmd nettest -D -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
-		run_cmd nettest -D -d ${VRF} -s -2 ${NSA_DEV} &
+		run_cmd nettest -D -I ${VRF} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		log_start
-		run_cmd nettest -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
@@ -1601,31 +1601,31 @@ ipv4_udp_vrf()
 	#
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -D -s -2 ${NSA_DEV} &
+	run_cmd nettest -D -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
@@ -1633,7 +1633,7 @@ ipv4_udp_vrf()
 	for a in ${VRF_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -D -s -2 ${VRF} &
+		run_cmd nettest -D -s -3 ${VRF} &
 		sleep 1
 		run_cmd nettest -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
@@ -1642,7 +1642,7 @@ ipv4_udp_vrf()
 	for a in ${VRF_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -s -D -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -s -D -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd nettest -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
@@ -1697,7 +1697,7 @@ ipv4_addr_bind_novrf()
 		log_test_addr ${a} $? 0 "Raw socket bind to local address"
 
 		log_start
-		run_cmd nettest -s -R -P icmp -l ${a} -d ${NSA_DEV} -b
+		run_cmd nettest -s -R -P icmp -l ${a} -I ${NSA_DEV} -b
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
 	done
 
@@ -1720,7 +1720,7 @@ ipv4_addr_bind_novrf()
 	#a=${NSA_LO_IP}
 	#log_start
 	#show_hint "Should fail with 'Cannot assign requested address'"
-	#run_cmd nettest -s -l ${a} -d ${NSA_DEV} -t1 -b
+	#run_cmd nettest -s -l ${a} -I ${NSA_DEV} -t1 -b
 	#log_test_addr ${a} $? 1 "TCP socket bind to out of scope local address"
 }
 
@@ -1736,17 +1736,17 @@ ipv4_addr_bind_vrf()
 		log_test_addr ${a} $? 0 "Raw socket bind to local address"
 
 		log_start
-		run_cmd nettest -s -R -P icmp -l ${a} -d ${NSA_DEV} -b
+		run_cmd nettest -s -R -P icmp -l ${a} -I ${NSA_DEV} -b
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
 		log_start
-		run_cmd nettest -s -R -P icmp -l ${a} -d ${VRF} -b
+		run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after VRF bind"
 	done
 
 	a=${NSA_LO_IP}
 	log_start
 	show_hint "Address on loopback is out of VRF scope"
-	run_cmd nettest -s -R -P icmp -l ${a} -d ${VRF} -b
+	run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "Raw socket bind to out of scope address after VRF bind"
 
 	#
@@ -1755,23 +1755,23 @@ ipv4_addr_bind_vrf()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest -s -l ${a} -d ${VRF} -t1 -b
+		run_cmd nettest -s -l ${a} -I ${VRF} -t1 -b
 		log_test_addr ${a} $? 0 "TCP socket bind to local address"
 
 		log_start
-		run_cmd nettest -s -l ${a} -d ${NSA_DEV} -t1 -b
+		run_cmd nettest -s -l ${a} -I ${NSA_DEV} -t1 -b
 		log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
 	done
 
 	a=${NSA_LO_IP}
 	log_start
 	show_hint "Address on loopback out of scope for VRF"
-	run_cmd nettest -s -l ${a} -d ${VRF} -t1 -b
+	run_cmd nettest -s -l ${a} -I ${VRF} -t1 -b
 	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for VRF"
 
 	log_start
 	show_hint "Address on loopback out of scope for device in VRF"
-	run_cmd nettest -s -l ${a} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for device bind"
 }
 
@@ -1818,7 +1818,7 @@ ipv4_rt()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${varg} -s -d ${VRF} &
+		run_cmd nettest ${varg} -s -I ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
@@ -1831,7 +1831,7 @@ ipv4_rt()
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest ${varg} -s -d ${NSA_DEV} &
+	run_cmd nettest ${varg} -s -I ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest ${varg} -r ${a} &
 	sleep 3
@@ -1886,7 +1886,7 @@ ipv4_rt()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${varg} -d ${VRF} -s &
+		run_cmd nettest ${varg} -I ${VRF} -s &
 		sleep 1
 		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
 		sleep 3
@@ -1910,7 +1910,7 @@ ipv4_rt()
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -d ${VRF} -s &
+	run_cmd nettest ${varg} -I ${VRF} -s &
 	sleep 1
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
@@ -1921,7 +1921,7 @@ ipv4_rt()
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -d ${NSA_DEV} -s &
+	run_cmd nettest ${varg} -I ${NSA_DEV} -s &
 	sleep 1
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
@@ -2333,7 +2333,7 @@ ipv6_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
@@ -2341,7 +2341,7 @@ ipv6_tcp_md5()
 	# client sends MD5, server not configured
 	log_start
 	show_hint "Should timeout since server does not have MD5 auth"
-	run_cmd nettest -6 -s -d ${VRF} &
+	run_cmd nettest -6 -s -I ${VRF} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
@@ -2349,7 +2349,7 @@ ipv6_tcp_md5()
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
@@ -2357,7 +2357,7 @@ ipv6_tcp_md5()
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
@@ -2368,7 +2368,7 @@ ipv6_tcp_md5()
 
 	# client in prefix
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
@@ -2376,7 +2376,7 @@ ipv6_tcp_md5()
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
@@ -2384,7 +2384,7 @@ ipv6_tcp_md5()
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout since client address is outside of prefix"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
@@ -2394,14 +2394,14 @@ ipv6_tcp_md5()
 	#
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
@@ -2409,7 +2409,7 @@ ipv6_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
@@ -2417,21 +2417,21 @@ ipv6_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
@@ -2439,7 +2439,7 @@ ipv6_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
@@ -2447,7 +2447,7 @@ ipv6_tcp_md5()
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
@@ -2457,11 +2457,11 @@ ipv6_tcp_md5()
 	# negative tests
 	#
 	log_start
-	run_cmd nettest -6 -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP6}
+	run_cmd nettest -6 -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP6}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
 
 	log_start
-	run_cmd nettest -6 -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET6}
+	run_cmd nettest -6 -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET6}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
 
 }
@@ -2534,7 +2534,7 @@ ipv6_tcp_novrf()
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
@@ -2543,7 +2543,7 @@ ipv6_tcp_novrf()
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
-		run_cmd nettest -6 -s -d ${NSA_DEV} &
+		run_cmd nettest -6 -s -I ${NSA_DEV} &
 		sleep 1
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
@@ -2569,7 +2569,7 @@ ipv6_tcp_novrf()
 	for a in ${NSA_IP6} ${NSA_LINKIP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd nettest -6  -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 0 "Device server, device client, local conn"
@@ -2611,7 +2611,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
@@ -2620,7 +2620,7 @@ ipv6_tcp_vrf()
 	# link local is always bound to ingress device
 	a=${NSA_LINKIP6}%${NSB_DEV}
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -2 ${NSA_DEV} &
+	run_cmd nettest -6 -s -I ${VRF} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${a}
 	log_test_addr ${a} $? 0 "VRF server"
@@ -2628,7 +2628,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
@@ -2664,7 +2664,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -2 ${VRF} &
+		run_cmd nettest -6 -s -3 ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
@@ -2673,7 +2673,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
@@ -2682,13 +2682,13 @@ ipv6_tcp_vrf()
 	# For LLA, child socket is bound to device
 	a=${NSA_LINKIP6}%${NSB_DEV}
 	log_start
-	run_cmd nettest -6 -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${a}
 	log_test_addr ${a} $? 0 "Global server"
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -2 ${NSA_DEV} &
+	run_cmd nettest -6 -s -I ${VRF} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${a}
 	log_test_addr ${a} $? 0 "VRF server"
@@ -2696,7 +2696,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
@@ -2716,7 +2716,7 @@ ipv6_tcp_vrf()
 	do
 		log_start
 		show_hint "Fails 'Connection refused' since client is not in VRF"
-		run_cmd nettest -6 -s -d ${VRF} &
+		run_cmd nettest -6 -s -I ${VRF} &
 		sleep 1
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Global server, local connection"
@@ -2771,7 +2771,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6} ::1
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
 		sleep 1
 		run_cmd nettest -6 -r ${a} -d ${VRF} -0 ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local connection"
@@ -2779,7 +2779,7 @@ ipv6_tcp_vrf()
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+	run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
 	sleep 1
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local connection"
@@ -2787,13 +2787,13 @@ ipv6_tcp_vrf()
 	a=${NSA_IP6}
 	log_start
 	show_hint "Should fail since unbound client is out of VRF scope"
-	run_cmd nettest -6 -s -d ${VRF} &
+	run_cmd nettest -6 -s -I ${VRF} &
 	sleep 1
 	run_cmd nettest -6 -r ${a}
 	log_test_addr ${a} $? 1 "VRF server, unbound client, local connection"
 
 	log_start
-	run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -r ${a} -d ${VRF} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, VRF client, local connection"
@@ -2801,7 +2801,7 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${NSA_LINKIP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
 		log_test_addr ${a} $? 0 "Device server, device client, local connection"
@@ -2841,13 +2841,13 @@ ipv6_udp_novrf()
 	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
-		run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
@@ -2855,7 +2855,7 @@ ipv6_udp_novrf()
 
 	a=${NSA_LO_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd_nsb nettest -6 -D -r ${a}
 	log_test_addr ${a} $? 0 "Global server"
@@ -2865,7 +2865,7 @@ ipv6_udp_novrf()
 	# behavior.
 	#log_start
 	#show_hint "Should fail since loopback address is out of scope"
-	#run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	#run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 	#sleep 1
 	#run_cmd_nsb nettest -6 -D -r ${a}
 	#log_test_addr ${a} $? 1 "Device server"
@@ -2933,7 +2933,7 @@ ipv6_udp_novrf()
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -6 -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -r ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
@@ -2942,7 +2942,7 @@ ipv6_udp_novrf()
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since address is out of device scope"
-		run_cmd nettest -6 -s -D -d ${NSA_DEV} &
+		run_cmd nettest -6 -s -D -I ${NSA_DEV} &
 		sleep 1
 		run_cmd nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 1 "Device server, local connection"
@@ -2993,7 +2993,7 @@ ipv6_udp_novrf()
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -s -I ${NSA_DEV} -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local conn"
@@ -3040,7 +3040,7 @@ ipv6_udp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
@@ -3049,7 +3049,7 @@ ipv6_udp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
@@ -3080,7 +3080,7 @@ ipv6_udp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -d ${VRF} -s &
+		run_cmd nettest -6 -D -I ${VRF} -s &
 		sleep 1
 		run_cmd nettest -6 -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
@@ -3095,19 +3095,19 @@ ipv6_udp_vrf()
 	log_test_addr ${a} $? 1 "Global server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
@@ -3122,7 +3122,7 @@ ipv6_udp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
@@ -3131,7 +3131,7 @@ ipv6_udp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
@@ -3140,7 +3140,7 @@ ipv6_udp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 		sleep 1
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
@@ -3184,13 +3184,13 @@ ipv6_udp_vrf()
 	#
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 
 	#log_start
-	run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
@@ -3198,13 +3198,13 @@ ipv6_udp_vrf()
 
 	a=${VRF_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -2 ${VRF} &
+	run_cmd nettest -6 -D -s -3 ${VRF} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${VRF} -s -2 ${VRF} &
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${VRF} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
@@ -3220,25 +3220,25 @@ ipv6_udp_vrf()
 	# device to global IP
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
 	sleep 1
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local conn"
@@ -3332,7 +3332,7 @@ ipv6_addr_bind_novrf()
 		log_test_addr ${a} $? 0 "Raw socket bind to local address"
 
 		log_start
-		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${NSA_DEV} -b
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -I ${NSA_DEV} -b
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
 	done
 
@@ -3345,13 +3345,13 @@ ipv6_addr_bind_novrf()
 	log_test_addr ${a} $? 0 "TCP socket bind to local address"
 
 	log_start
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
 
 	a=${NSA_LO_IP6}
 	log_start
 	show_hint "Should fail with 'Cannot assign requested address'"
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 1 "TCP socket bind to out of scope local address"
 }
 
@@ -3363,18 +3363,18 @@ ipv6_addr_bind_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${VRF} -b
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -I ${VRF} -b
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after vrf bind"
 
 		log_start
-		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${NSA_DEV} -b
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -I ${NSA_DEV} -b
 		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
 	done
 
 	a=${NSA_LO_IP6}
 	log_start
 	show_hint "Address on loopback is out of VRF scope"
-	run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${VRF} -b
+	run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 1 "Raw socket bind to invalid local address after vrf bind"
 
 	#
@@ -3384,29 +3384,29 @@ ipv6_addr_bind_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -l ${a} -d ${VRF} -t1 -b
+		run_cmd nettest -6 -s -l ${a} -I ${VRF} -t1 -b
 		log_test_addr ${a} $? 0 "TCP socket bind to local address with VRF bind"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address with device bind"
 
 	a=${VRF_IP6}
 	log_start
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 1 "TCP socket bind to VRF address with device bind"
 
 	a=${NSA_LO_IP6}
 	log_start
 	show_hint "Address on loopback out of scope for VRF"
-	run_cmd nettest -6 -s -l ${a} -d ${VRF} -t1 -b
+	run_cmd nettest -6 -s -l ${a} -I ${VRF} -t1 -b
 	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for VRF"
 
 	log_start
 	show_hint "Address on loopback out of scope for device in VRF"
-	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -6 -s -l ${a} -I ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for device bind"
 
 }
@@ -3454,7 +3454,7 @@ ipv6_rt()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -d ${VRF} -s &
+		run_cmd nettest ${varg} -I ${VRF} -s &
 		sleep 1
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
@@ -3468,7 +3468,7 @@ ipv6_rt()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -d ${NSA_DEV} -s &
+		run_cmd nettest ${varg} -I ${NSA_DEV} -s &
 		sleep 1
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
@@ -3525,7 +3525,7 @@ ipv6_rt()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -d ${VRF} -s &
+		run_cmd nettest ${varg} -I ${VRF} -s &
 		sleep 1
 		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
 		sleep 3
@@ -3549,7 +3549,7 @@ ipv6_rt()
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -d ${VRF} -s &
+	run_cmd nettest ${varg} -I ${VRF} -s &
 	sleep 1
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
@@ -3560,7 +3560,7 @@ ipv6_rt()
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -d ${NSA_DEV} -s &
+	run_cmd nettest ${varg} -I ${NSA_DEV} -s &
 	sleep 1
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index a835cab08029..8822ca4f1baf 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -79,6 +79,7 @@ struct sock_args {
 	int use_setsockopt;
 	int use_cmsg;
 	const char *dev;
+	const char *server_dev;
 	int ifindex;
 
 	const char *clientns;
@@ -96,6 +97,7 @@ struct sock_args {
 
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
+	const char *expected_server_dev;
 	int expected_ifindex;
 
 	/* local address */
@@ -1424,6 +1426,8 @@ static int do_server(struct sock_args *args, int ipc_fd)
 		log_msg("Switched server netns\n");
 	}
 
+	args->dev = args->server_dev;
+	args->expected_dev = args->expected_server_dev;
 	if (resolve_devices(args) || validate_addresses(args))
 		goto err_exit;
 
@@ -1764,7 +1768,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:X:m:d:BN:O:SCi6L:0:1:2:Fbq"
+#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6L:0:1:2:3:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1788,6 +1792,7 @@ static void print_usage(char *prog)
 	"    -l addr       local address to bind to\n"
 	"\n"
 	"    -d dev        bind socket to given device name\n"
+	"    -I dev        bind socket to given device name - server mode\n"
 	"    -S            use setsockopt (IP_UNICAST_IF or IP_MULTICAST_IF)\n"
 	"                  to set device binding\n"
 	"    -C            use cmsg and IP_PKTINFO to specify device binding\n"
@@ -1804,6 +1809,7 @@ static void print_usage(char *prog)
 	"    -0 addr       Expected local address\n"
 	"    -1 addr       Expected remote address\n"
 	"    -2 dev        Expected device name (or index) to receive packet\n"
+	"    -3 dev        Expected device name (or index) to receive packets - server mode\n"
 	"\n"
 	"    -b            Bind test only.\n"
 	"    -q            Be quiet. Run test without printing anything.\n"
@@ -1916,6 +1922,9 @@ int main(int argc, char *argv[])
 		case 'd':
 			args.dev = optarg;
 			break;
+		case 'I':
+			args.server_dev = optarg;
+			break;
 		case 'i':
 			interactive = 1;
 			break;
@@ -1942,6 +1951,9 @@ int main(int argc, char *argv[])
 		case '2':
 			args.expected_dev = optarg;
 			break;
+		case '3':
+			args.expected_server_dev = optarg;
+			break;
 		case 'q':
 			quiet = 1;
 			break;
-- 
2.24.3 (Apple Git-128)

