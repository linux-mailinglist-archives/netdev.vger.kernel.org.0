Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B267E2CC
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbfHASzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387722AbfHASzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:13 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103DE2171F;
        Thu,  1 Aug 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685713;
        bh=ebAw+HyH3d3wdjcwck4TO9oA1xMirZ7dRlqxaAkQSR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sD79GUyvYMaN7HFp8WZflBB0ifo9l/RRc4rF+jR1zRils7PzSUFp9EcVuBheOj2E
         WTW7JvyPl7h7zbc5jsmnBoWM8Zgu7n8xeETrw9Lv50H6rhDZailMzy+8qj78yjrvpi
         2nhhAqRraPxxQKlOwNp1EugRI4f2GftiwxBG6ifw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 06/15] selftests: Add ipv6 tcp tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:39 -0700
Message-Id: <20190801185648.27653-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv6 tcp tests to fcnal-test.sh. Covers the permutations of directly
connected addresses, routed destinations, VRF and non-VRF, and expected
failures for both clients and servers. Includes permutations with
net.ipv4.tcp_l3mdev_accept set to 0 and 1.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 370 +++++++++++++++++++++++++++++-
 1 file changed, 369 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index f9e2f1464dcd..97291c6d17c5 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1304,6 +1304,373 @@ ipv6_ping()
 }
 
 ################################################################################
+# IPv6 TCP
+
+ipv6_tcp_novrf()
+{
+	local a
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		run_cmd nettest -6 -s &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+	done
+
+	# verify TCP reset received
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	#
+	# client
+	#
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
+	do
+		log_start
+		run_cmd_nsb nettest -6 -s &
+		sleep 1
+		run_cmd nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "Client"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
+	do
+		log_start
+		run_cmd_nsb nettest -6 -s &
+		sleep 1
+		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 0 "Client, device bind"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "No server, device client"
+	done
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ::1
+	do
+		log_start
+		run_cmd nettest -6 -s &
+		sleep 1
+		run_cmd nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "Global server, local connection"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -r ${a} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
+
+	for a in ${NSA_LO_IP6} ::1
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
+		run_cmd nettest -6 -s -d ${NSA_DEV} &
+		sleep 1
+		run_cmd nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s &
+	sleep 1
+	run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
+	log_test_addr ${a} $? 0 "Global server, device client, local connection"
+
+	for a in ${NSA_LO_IP6} ::1
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
+		run_cmd nettest -6 -s &
+		sleep 1
+		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "Global server, device client, local connection"
+	done
+
+	for a in ${NSA_IP6} ${NSA_LINKIP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd nettest -6  -d ${NSA_DEV} -r ${a}
+		log_test_addr ${a} $? 0 "Device server, device client, local conn"
+	done
+
+	for a in ${NSA_IP6} ${NSA_LINKIP6}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -6 -d ${NSA_DEV} -r ${a}
+		log_test_addr ${a} $? 1 "No server, device client, local conn"
+	done
+}
+
+ipv6_tcp_vrf()
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
+	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
+		run_cmd nettest -6 -s &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "Global server"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+	done
+
+	# link local is always bound to ingress device
+	a=${NSA_LINKIP6}%${NSB_DEV}
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${a}
+	log_test_addr ${a} $? 0 "VRF server"
+
+	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "Device server"
+	done
+
+	# verify TCP reset received
+	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	# local address tests
+	a=${NSA_IP6}
+	log_start
+	show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
+	run_cmd nettest -6 -s &
+	sleep 1
+	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
+	log_test_addr ${a} $? 1 "Global server, local connection"
+
+	#
+	# enable VRF global server
+	#
+	log_subsection "VRF Global server enabled"
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -2 ${VRF} &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+	done
+
+	# For LLA, child socket is bound to device
+	a=${NSA_LINKIP6}%${NSB_DEV}
+	log_start
+	run_cmd nettest -6 -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${a}
+	log_test_addr ${a} $? 0 "Global server"
+
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${a}
+	log_test_addr ${a} $? 0 "VRF server"
+
+	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 0 "Device server"
+	done
+
+	# verify TCP reset received
+	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd_nsb nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	# local address tests
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		show_hint "Fails 'No route to host' since client is not in VRF"
+		run_cmd nettest -6 -s -2 ${VRF} &
+		sleep 1
+		run_cmd nettest -6 -r ${a}
+		log_test_addr ${a} $? 1 "Global server, local connection"
+	done
+
+
+	#
+	# client
+	#
+	for a in ${NSB_IP6} ${NSB_LO_IP6}
+	do
+		log_start
+		run_cmd_nsb nettest -6 -s &
+		sleep 1
+		run_cmd nettest -6 -r ${a} -d ${VRF}
+		log_test_addr ${a} $? 0 "Client, VRF bind"
+	done
+
+	a=${NSB_LINKIP6}
+	log_start
+	show_hint "Fails since VRF device does not allow linklocal addresses"
+	run_cmd_nsb nettest -6 -s &
+	sleep 1
+	run_cmd nettest -6 -r ${a} -d ${VRF}
+	log_test_addr ${a} $? 1 "Client, VRF bind"
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}
+	do
+		log_start
+		run_cmd_nsb nettest -6 -s &
+		sleep 1
+		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 0 "Client, device bind"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -6 -r ${a} -d ${VRF}
+		log_test_addr ${a} $? 1 "No server, VRF client"
+	done
+
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "No server, device client"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6} ::1
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd nettest -6 -r ${a} -d ${VRF} -0 ${a}
+		log_test_addr ${a} $? 0 "VRF server, VRF client, local connection"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -2 ${VRF} &
+	sleep 1
+	run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
+	log_test_addr ${a} $? 0 "VRF server, device client, local connection"
+
+	a=${NSA_IP6}
+	log_start
+	show_hint "Should fail since unbound client is out of VRF scope"
+	run_cmd nettest -6 -s -d ${VRF} &
+	sleep 1
+	run_cmd nettest -6 -r ${a}
+	log_test_addr ${a} $? 1 "VRF server, unbound client, local connection"
+
+	log_start
+	run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -r ${a} -d ${VRF} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, VRF client, local connection"
+
+	for a in ${NSA_IP6} ${NSA_LINKIP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
+		log_test_addr ${a} $? 0 "Device server, device client, local connection"
+	done
+}
+
+ipv6_tcp()
+{
+	log_section "IPv6/TCP"
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
+	ipv6_tcp_novrf
+	log_subsection "tcp_l3mdev_accept enabled"
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+	ipv6_tcp_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv6_tcp_vrf
+}
+
+################################################################################
 # usage
 
 usage()
@@ -1324,7 +1691,7 @@ EOF
 # main
 
 TESTS_IPV4="ipv4_ping ipv4_tcp"
-TESTS_IPV6="ipv6_ping"
+TESTS_IPV6="ipv6_ping ipv6_tcp"
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -1366,6 +1733,7 @@ do
 	ipv4_tcp|tcp)    ipv4_tcp;;
 
 	ipv6_ping|ping6) ipv6_ping;;
+	ipv6_tcp|tcp6)   ipv6_tcp;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
-- 
2.11.0

