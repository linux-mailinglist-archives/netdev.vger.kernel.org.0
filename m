Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142077E2BD
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbfHASz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733246AbfHASzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 433FD21726;
        Thu,  1 Aug 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685713;
        bh=v+9o6BpfqSPqrBe/bDmoz8WOK9TJWVOW2EMcF0k0odM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkysnwPlppvUSd0C8HXTtGKdP7mDsFL7jwXDLqKkxlmszbHxscvlDMDj4uzl60QVO
         6DsTu5WkgjMTp7IF2wb/M31uAUukPiexOJ3RWJioGl9PM0w1jHd/lkedPdXzR2yUDL
         rNIAK9kPB9uelsGgmKLgZ+9BN+S2sBUNhBd1enZ4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 07/15] selftests: Add ipv4 udp tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:40 -0700
Message-Id: <20190801185648.27653-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add udp tests to fcnal-test.sh. Covers the permutations of directly
connected addresses, routed destinations, VRF and non-VRF, and expected
failures for both clients and servers. Includes permutations with
net.ipv4.udp_l3mdev_accept set to 0 and 1.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 381 +++++++++++++++++++++++++++++-
 1 file changed, 380 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 97291c6d17c5..afe9eb55d04a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1023,6 +1023,384 @@ ipv4_tcp()
 }
 
 ################################################################################
+# IPv4 UDP
+
+ipv4_udp_novrf()
+{
+	local a
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP}
+	do
+		log_start
+		run_cmd nettest -D -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+
+		log_start
+		show_hint "Should fail 'Connection refused' since there is no server"
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -D -r ${a}
+	log_test_addr ${a} $? 0 "Device server"
+
+	#
+	# client
+	#
+	for a in ${NSB_IP} ${NSB_LO_IP}
+	do
+		log_start
+		run_cmd_nsb nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -0 ${NSA_IP}
+		log_test_addr ${a} $? 0 "Client"
+
+		log_start
+		run_cmd_nsb nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -0 ${NSA_IP}
+		log_test_addr ${a} $? 0 "Client, device bind"
+
+		log_start
+		run_cmd_nsb nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -C -0 ${NSA_IP}
+		log_test_addr ${a} $? 0 "Client, device send via cmsg"
+
+		log_start
+		run_cmd_nsb nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP}
+		log_test_addr ${a} $? 0 "Client, device bind via IP_UNICAST_IF"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -D -r ${a}
+		log_test_addr ${a} $? 1 "No server, unbound client"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "No server, device client"
+	done
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -0 ${a} -1 ${a}
+		log_test_addr ${a} $? 0 "Global server, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -r ${a}
+	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
+
+	for a in ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since address is out of device scope"
+		run_cmd nettest -s -D -d ${NSA_DEV} &
+		sleep 1
+		run_cmd nettest -D -r ${a}
+		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -D &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device client, local connection"
+
+	log_start
+	run_cmd nettest -s -D &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -C -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device send via cmsg, local connection"
+
+	log_start
+	run_cmd nettest -s -D &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -S -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device client via IP_UNICAST_IF, local connection"
+
+	# IPv4 with device bind has really weird behavior - it overrides the
+	# fib lookup, generates an rtable and tries to send the packet. This
+	# causes failures for local traffic at different places
+	for a in ${NSA_LO_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Should fail since addresses on loopback are out of device scope"
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 2 "Global server, device client, local connection"
+
+		log_start
+		show_hint "Should fail since addresses on loopback are out of device scope"
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -C
+		log_test_addr ${a} $? 1 "Global server, device send via cmsg, local connection"
+
+		log_start
+		show_hint "Should fail since addresses on loopback are out of device scope"
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S
+		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -D -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, device client, local conn"
+
+	log_start
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 2 "No server, device client, local conn"
+}
+
+ipv4_udp_vrf()
+{
+	local a
+
+	# disable global server
+	log_subsection "Global server disabled"
+	set_sysctl net.ipv4.udp_l3mdev_accept=0
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		show_hint "Fails because ingress is in a VRF and global server is disabled"
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 1 "Global server"
+
+		log_start
+		run_cmd nettest -D -d ${VRF} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+
+		log_start
+		run_cmd nettest -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 0 "Enslaved device server"
+
+		log_start
+		show_hint "Should fail 'Connection refused' since there is no server"
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+
+		log_start
+		show_hint "Should fail 'Connection refused' since global server is out of scope"
+		run_cmd nettest -D -s &
+		sleep 1
+		run_cmd nettest -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 1 "Global server, VRF client, local connection"
+	done
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, enslaved device client, local connection"
+
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
+
+	# enable global server
+	log_subsection "Global server enabled"
+	set_sysctl net.ipv4.udp_l3mdev_accept=1
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest -D -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+
+		log_start
+		run_cmd nettest -D -d ${VRF} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+
+		log_start
+		run_cmd nettest -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 0 "Enslaved device server"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd_nsb nettest -D -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	#
+	# client tests
+	#
+	log_start
+	run_cmd_nsb nettest -D -s &
+	sleep 1
+	run_cmd nettest -d ${VRF} -D -r ${NSB_IP} -1 ${NSA_IP}
+	log_test $? 0 "VRF client"
+
+	log_start
+	run_cmd_nsb nettest -D -s &
+	sleep 1
+	run_cmd nettest -d ${NSA_DEV} -D -r ${NSB_IP} -1 ${NSA_IP}
+	log_test $? 0 "Enslaved device client"
+
+	# negative test - should fail
+	log_start
+	show_hint "Should fail 'Connection refused'"
+	run_cmd nettest -D -d ${VRF} -r ${NSB_IP}
+	log_test $? 1 "No server, VRF client"
+
+	log_start
+	show_hint "Should fail 'Connection refused'"
+	run_cmd nettest -D -d ${NSA_DEV} -r ${NSB_IP}
+	log_test $? 1 "No server, enslaved device client"
+
+	#
+	# local address tests
+	#
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -D -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -s -D -d ${VRF} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
+
+	log_start
+	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
+
+	for a in ${VRF_IP} 127.0.0.1
+	do
+		log_start
+		run_cmd nettest -D -s -2 ${VRF} &
+		sleep 1
+		run_cmd nettest -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
+	done
+
+	for a in ${VRF_IP} 127.0.0.1
+	do
+		log_start
+		run_cmd nettest -s -D -d ${VRF} -2 ${VRF} &
+		sleep 1
+		run_cmd nettest -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
+	done
+
+	# negative test - should fail
+	# verifies ECONNREFUSED
+	for a in ${NSA_IP} ${VRF_IP} 127.0.0.1
+	do
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 1 "No server, VRF client, local conn"
+	done
+}
+
+ipv4_udp()
+{
+	which nettest >/dev/null
+	if [ $? -ne 0 ]; then
+		log_error "nettest not found; skipping tests"
+		return
+	fi
+
+	log_section "IPv4/UDP"
+	log_subsection "No VRF"
+
+	setup
+
+	# udp_l3mdev_accept should have no affect without VRF;
+	# run tests with it enabled and disabled to verify
+	log_subsection "udp_l3mdev_accept disabled"
+	set_sysctl net.ipv4.udp_l3mdev_accept=0
+	ipv4_udp_novrf
+	log_subsection "udp_l3mdev_accept enabled"
+	set_sysctl net.ipv4.udp_l3mdev_accept=1
+	ipv4_udp_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv4_udp_vrf
+}
+
+################################################################################
 # IPv6
 
 ipv6_ping_novrf()
@@ -1690,7 +2068,7 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp"
 TESTS_IPV6="ipv6_ping ipv6_tcp"
 PAUSE_ON_FAIL=no
 PAUSE=no
@@ -1731,6 +2109,7 @@ do
 	case $t in
 	ipv4_ping|ping)  ipv4_ping;;
 	ipv4_tcp|tcp)    ipv4_tcp;;
+	ipv4_udp|udp)    ipv4_udp;;
 
 	ipv6_ping|ping6) ipv6_ping;;
 	ipv6_tcp|tcp6)   ipv6_tcp;;
-- 
2.11.0

