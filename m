Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2307E2BC
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387907AbfHASza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387718AbfHASzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D136B216C8;
        Thu,  1 Aug 2019 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685712;
        bh=4sWu2YD/TRZu4iyRNWaNAQaxOM/L5AAofZDYSAdgzrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bG87LGfkIZwTE32giVgWc+Xhwyupuulv0xgRuC+L8b43Ek4xdjmVUmAAMZEVIJsRx
         2oNoJsBO07ZoL47kq31huSuYqHVW+Z2A2mv1x5x3VkWwuqiX6SViXUa2UEtH5dgtR2
         DS1q2UPLrAoKgQ0I/mnomW3PEMSyOWQvxJFP/1NI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 05/15] selftests: Add ipv4 tcp tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:38 -0700
Message-Id: <20190801185648.27653-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add tcp tests to fcnal-test.sh. Covers the permutations of directly
connected addresses, routed destinations, VRF and non-VRF, and expected
failures for both clients and servers. Includes permutations with
net.ipv4.tcp_l3mdev_accept set to 0 and 1.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 315 +++++++++++++++++++++++++++++-
 1 file changed, 314 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 4da510f6d625..f9e2f1464dcd 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -712,6 +712,317 @@ ipv4_ping()
 }
 
 ################################################################################
+# IPv4 TCP
+
+ipv4_tcp_novrf()
+{
+	local a
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP}
+	do
+		log_start
+		run_cmd nettest -s &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -r ${a}
+	log_test_addr ${a} $? 0 "Device server"
+
+	# verify TCP reset sent and received
+	for a in ${NSA_IP} ${NSA_LO_IP}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since there is no server"
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	#
+	# client
+	#
+	for a in ${NSB_IP} ${NSB_LO_IP}
+	do
+		log_start
+		run_cmd_nsb nettest -s &
+		sleep 1
+		run_cmd nettest -r ${a} -0 ${NSA_IP}
+		log_test_addr ${a} $? 0 "Client"
+
+		log_start
+		run_cmd_nsb nettest -s &
+		sleep 1
+		run_cmd nettest -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 0 "Client, device bind"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -r ${a}
+		log_test_addr ${a} $? 1 "No server, unbound client"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "No server, device client"
+	done
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		run_cmd nettest -s &
+		sleep 1
+		run_cmd nettest -r ${a} -0 ${a} -1 ${a}
+		log_test_addr ${a} $? 0 "Global server, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -r ${a} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
+
+	for a in ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
+		run_cmd nettest -s -d ${NSA_DEV} &
+		sleep 1
+		run_cmd nettest -r ${a}
+		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s &
+	sleep 1
+	run_cmd nettest -r ${a} -0 ${a} -d ${NSA_DEV}
+	log_test_addr ${a} $? 0 "Global server, device client, local connection"
+
+	for a in ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
+		run_cmd nettest -s &
+		sleep 1
+		run_cmd nettest -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "Global server, device client, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest  -d ${NSA_DEV} -r ${a} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, device client, local connection"
+
+	log_start
+	show_hint "Should fail 'Connection refused'"
+	run_cmd nettest -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 1 "No server, device client, local conn"
+}
+
+ipv4_tcp_vrf()
+{
+	local a
+
+	# disable global server
+	log_subsection "Global server disabled"
+
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
+		run_cmd nettest -s &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 1 "Global server"
+
+		log_start
+		run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+
+		log_start
+		run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 0 "Device server"
+
+		# verify TCP reset received
+		log_start
+		show_hint "Should fail 'Connection refused' since there is no server"
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	# local address tests
+	# (${VRF_IP} and 127.0.0.1 both timeout)
+	a=${NSA_IP}
+	log_start
+	show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
+	run_cmd nettest -s &
+	sleep 1
+	run_cmd nettest -r ${a} -d ${NSA_DEV}
+	log_test_addr ${a} $? 1 "Global server, local connection"
+
+	#
+	# enable VRF global server
+	#
+	log_subsection "VRF Global server enabled"
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		show_hint "client socket should be bound to VRF"
+		run_cmd nettest -s -2 ${VRF} &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+
+		log_start
+		show_hint "client socket should be bound to VRF"
+		run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+
+		# verify TCP reset received
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd_nsb nettest -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	a=${NSA_IP}
+	log_start
+	show_hint "client socket should be bound to device"
+	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -r ${a}
+	log_test_addr ${a} $? 0 "Device server"
+
+	# local address tests
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		show_hint "Should fail 'No route to host' since client is not bound to VRF"
+		run_cmd nettest -s -2 ${VRF} &
+		sleep 1
+		run_cmd nettest -r ${a}
+		log_test_addr ${a} $? 1 "Global server, local connection"
+	done
+
+	#
+	# client
+	#
+	for a in ${NSB_IP} ${NSB_LO_IP}
+	do
+		log_start
+		run_cmd_nsb nettest -s &
+		sleep 1
+		run_cmd nettest -r ${a} -d ${VRF}
+		log_test_addr ${a} $? 0 "Client, VRF bind"
+
+		log_start
+		run_cmd_nsb nettest -s &
+		sleep 1
+		run_cmd nettest -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 0 "Client, device bind"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -r ${a} -d ${VRF}
+		log_test_addr ${a} $? 1 "No server, VRF client"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "No server, device client"
+	done
+
+	for a in ${NSA_IP} ${VRF_IP} 127.0.0.1
+	do
+		log_start
+		run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd nettest -r ${a} -d ${VRF} -0 ${a}
+		log_test_addr ${a} $? 0 "VRF server, VRF client, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -d ${VRF} -2 ${VRF} &
+	sleep 1
+	run_cmd nettest -r ${a} -d ${NSA_DEV} -0 ${a}
+	log_test_addr ${a} $? 0 "VRF server, device client, local connection"
+
+	log_start
+	show_hint "Should fail 'No route to host' since client is out of VRF scope"
+	run_cmd nettest -s -d ${VRF} &
+	sleep 1
+	run_cmd nettest -r ${a}
+	log_test_addr ${a} $? 1 "VRF server, unbound client, local connection"
+
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -r ${a} -d ${VRF} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, VRF client, local connection"
+
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -r ${a} -d ${NSA_DEV} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, device client, local connection"
+}
+
+ipv4_tcp()
+{
+	log_section "IPv4/TCP"
+
+	which nettest >/dev/null
+	if [ $? -ne 0 ]; then
+		log_error "nettest not found; skipping tests"
+		return
+	fi
+
+	log_subsection "No VRF"
+	setup
+
+	# tcp_l3mdev_accept should have no affect without VRF;
+	# run tests with it enabled and disabled to verify
+	log_subsection "tcp_l3mdev_accept disabled"
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+	ipv4_tcp_novrf
+	log_subsection "tcp_l3mdev_accept enabled"
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+	ipv4_tcp_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv4_tcp_vrf
+}
+
+################################################################################
 # IPv6
 
 ipv6_ping_novrf()
@@ -1012,7 +1323,7 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping"
+TESTS_IPV4="ipv4_ping ipv4_tcp"
 TESTS_IPV6="ipv6_ping"
 PAUSE_ON_FAIL=no
 PAUSE=no
@@ -1052,6 +1363,8 @@ for t in $TESTS
 do
 	case $t in
 	ipv4_ping|ping)  ipv4_ping;;
+	ipv4_tcp|tcp)    ipv4_tcp;;
+
 	ipv6_ping|ping6) ipv6_ping;;
 
 	# setup namespaces and config, but do not run any tests
-- 
2.11.0

