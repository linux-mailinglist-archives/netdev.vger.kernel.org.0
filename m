Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D337E2BB
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387855AbfHASzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387776AbfHASzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E5121783;
        Thu,  1 Aug 2019 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685714;
        bh=P8IOtQ87YmrCFt4jqkbAwxWNkZCtTatntk2PRimfzKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiG6Lln55U60ObBp9LWUkk8M9oQzoIwrMn5+0awHBIwlSAV5SPAg2ZYQxtxdJkSRV
         l/iqltWWrnlqkfqC3ceLgEQ77JYU3z9ERmBArlQnlbvRmZHbEL7lqJYstp0Wsb8NnM
         eDQAJLSaz6+bhuE2xogcqlb+ICb/ojai+Tr1o7Ck=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 12/15] selftests: Add ipv6 runtime tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:45 -0700
Message-Id: <20190801185648.27653-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv6 runtime tests where passive (no traffic flowing) and active
(with traffic) sockets are expected to be reset on device deletes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 188 +++++++++++++++++++++++++++++-
 1 file changed, 187 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index b8bdab733ecd..dcfe0b13dfe9 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -2935,6 +2935,191 @@ ipv6_addr_bind()
 }
 
 ################################################################################
+# IPv6 runtime tests
+
+ipv6_rt()
+{
+	local desc="$1"
+	local varg="-6 $2"
+	local with_vrf="yes"
+	local a
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest ${varg} -s &
+		sleep 1
+		run_cmd_nsb nettest ${varg} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, global server"
+
+		setup ${with_vrf}
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest ${varg} -d ${VRF} -s &
+		sleep 1
+		run_cmd_nsb nettest ${varg} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, VRF server"
+
+		setup ${with_vrf}
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest ${varg} -d ${NSA_DEV} -s &
+		sleep 1
+		run_cmd_nsb nettest ${varg} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, enslaved device server"
+
+		setup ${with_vrf}
+	done
+
+	#
+	# client test
+	#
+	log_start
+	run_cmd_nsb nettest ${varg} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${VRF} -r ${NSB_IP6} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test  0 0 "${desc}, VRF client"
+
+	setup ${with_vrf}
+
+	log_start
+	run_cmd_nsb nettest ${varg} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${NSB_IP6} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test  0 0 "${desc}, enslaved device client"
+
+	setup ${with_vrf}
+
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest ${varg} -s &
+		sleep 1
+		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, global server, VRF client"
+
+		setup ${with_vrf}
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest ${varg} -d ${VRF} -s &
+		sleep 1
+		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, VRF server and client"
+
+		setup ${with_vrf}
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest ${varg} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, global server, device client"
+
+	setup ${with_vrf}
+
+	log_start
+	run_cmd nettest ${varg} -d ${VRF} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, VRF server, device client"
+
+	setup ${with_vrf}
+
+	log_start
+	run_cmd nettest ${varg} -d ${NSA_DEV} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, device server, device client"
+}
+
+ipv6_ping_rt()
+{
+	local with_vrf="yes"
+	local a
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd_nsb ${ping6} -f ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "Device delete with active traffic - ping in"
+
+	setup ${with_vrf}
+
+	log_start
+	run_cmd ${ping6} -f ${NSB_IP6} -I ${VRF} &
+	sleep 1
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "Device delete with active traffic - ping out"
+}
+
+ipv6_runtime()
+{
+	log_section "Run time tests - ipv6"
+
+	setup "yes"
+	ipv6_ping_rt
+
+	setup "yes"
+	ipv6_rt "TCP active socket"  "-n -1"
+
+	setup "yes"
+	ipv6_rt "TCP passive socket" "-i"
+
+	setup "yes"
+	ipv6_rt "UDP active socket"  "-D -n -1"
+}
+
+################################################################################
 # usage
 
 usage()
@@ -2955,7 +3140,7 @@ EOF
 # main
 
 TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime"
-TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime"
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -3003,6 +3188,7 @@ do
 	ipv6_tcp|tcp6)   ipv6_tcp;;
 	ipv6_udp|udp6)   ipv6_udp;;
 	ipv6_bind|bind6) ipv6_addr_bind;;
+	ipv6_runtime)    ipv6_runtime;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
-- 
2.11.0

