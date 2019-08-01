Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD637E2BE
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387872AbfHASz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731751AbfHASzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 219342173E;
        Thu,  1 Aug 2019 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685714;
        bh=bzOKj2vGcb7hUG5HFS+uPR+pBJ25xTtspvriXHWTt58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oM1MOp785SbPHT+2ImpizA3c8ZJEd9WGO15EeZYEF9aigbpzlTQc2QSVkiHf/1LI3
         pM8e3ccVvL2hwbyoG/V3jpMY/Av1/qsfZUE2BueaSDrBjSL8mhSNrN0/4mDg+y7XuV
         xGbiriT9H3hL6zbvIjUnO/uVfb3LWIR6ez4cfu6c=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 11/15] selftests: Add ipv4 runtime tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:44 -0700
Message-Id: <20190801185648.27653-12-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add runtime tests where passive (no traffic flowing) and active (with
traffic) sockets are expected to be reset on device deletes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 185 +++++++++++++++++++++++++++++-
 1 file changed, 184 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 48e74d62e009..b8bdab733ecd 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1509,6 +1509,188 @@ ipv4_addr_bind()
 }
 
 ################################################################################
+# IPv4 runtime tests
+
+ipv4_rt()
+{
+	local desc="$1"
+	local varg="$2"
+	local with_vrf="yes"
+	local a
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP} ${VRF_IP}
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
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest ${varg} -s -d ${VRF} &
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
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest ${varg} -s -d ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest ${varg} -r ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, enslaved device server"
+
+	setup ${with_vrf}
+
+	#
+	# client test
+	#
+	log_start
+	run_cmd_nsb nettest ${varg} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${VRF} -r ${NSB_IP} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, VRF client"
+
+	setup ${with_vrf}
+
+	log_start
+	run_cmd_nsb nettest ${varg} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${NSB_IP} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, enslaved device client"
+
+	setup ${with_vrf}
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest ${varg} -s &
+		sleep 1
+		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, global server, VRF client, local"
+
+		setup ${with_vrf}
+	done
+
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest ${varg} -d ${VRF} -s &
+		sleep 1
+		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "${desc}, VRF server and client, local"
+
+		setup ${with_vrf}
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest ${varg} -s &
+	sleep 1
+	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "${desc}, global server, enslaved device client, local"
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
+	log_test_addr ${a} 0 0 "${desc}, VRF server, enslaved device client, local"
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
+	log_test_addr ${a} 0 0 "${desc}, enslaved device server and client, local"
+}
+
+ipv4_ping_rt()
+{
+	local with_vrf="yes"
+	local a
+
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd_nsb ping -f ${a} &
+		sleep 3
+		run_cmd ip link del ${VRF}
+		sleep 1
+		log_test_addr ${a} 0 0 "Device delete with active traffic - ping in"
+
+		setup ${with_vrf}
+	done
+
+	a=${NSB_IP}
+	log_start
+	run_cmd ping -f -I ${VRF} ${a} &
+	sleep 3
+	run_cmd ip link del ${VRF}
+	sleep 1
+	log_test_addr ${a} 0 0 "Device delete with active traffic - ping out"
+}
+
+ipv4_runtime()
+{
+	log_section "Run time tests - ipv4"
+
+	setup "yes"
+	ipv4_ping_rt
+
+	setup "yes"
+	ipv4_rt "TCP active socket"  "-n -1"
+
+	setup "yes"
+	ipv4_rt "TCP passive socket" "-i"
+}
+
+################################################################################
 # IPv6
 
 ipv6_ping_novrf()
@@ -2772,7 +2954,7 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime"
 TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind"
 PAUSE_ON_FAIL=no
 PAUSE=no
@@ -2815,6 +2997,7 @@ do
 	ipv4_tcp|tcp)    ipv4_tcp;;
 	ipv4_udp|udp)    ipv4_udp;;
 	ipv4_bind|bind)  ipv4_addr_bind;;
+	ipv4_runtime)    ipv4_runtime;;
 
 	ipv6_ping|ping6) ipv6_ping;;
 	ipv6_tcp|tcp6)   ipv6_tcp;;
-- 
2.11.0

