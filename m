Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD687E2C3
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfHASzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387723AbfHASzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A8820679;
        Thu,  1 Aug 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685713;
        bh=Ut+aBHjXBHPn6mbbJigaLaa4ohOeGl9Ws9eJGcP3cm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ez3++7v4MCYasgHcuvAzeBWxSck9hlaqbYZnUfygFLhtQvhN3g2kot6IocEvK047r
         /gnllVDeDrYLO0T987oom8t6fT6mU3DWPwGU8q6xiMS3uGVuQVlLMnlbkxq9sRtjDk
         5LJn5bayrUk6fnlBWauD2RKQGi3repZufJKmkjmQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 08/15] selftests: Add ipv6 udp tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:41 -0700
Message-Id: <20190801185648.27653-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv6 udp tests to fcnal-test.sh. Covers the permutations of directly
connected addresses, routed destinations, VRF and non-VRF, and expected
failures for both clients and servers. Includes permutations with
net.ipv4.udp_l3mdev_accept set to 0 and 1.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 492 +++++++++++++++++++++++++++++-
 1 file changed, 491 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index afe9eb55d04a..2a2e692bc242 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -2049,6 +2049,495 @@ ipv6_tcp()
 }
 
 ################################################################################
+# IPv6 UDP
+
+ipv6_udp_novrf()
+{
+	local a
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+
+		log_start
+		run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "Device server"
+	done
+
+	a=${NSA_LO_IP6}
+	log_start
+	run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd_nsb nettest -6 -D -r ${a}
+	log_test_addr ${a} $? 0 "Global server"
+
+	# should fail since loopback address is out of scope for a device
+	# bound server, but it does not - hence this is more documenting
+	# behavior.
+	#log_start
+	#show_hint "Should fail since loopback address is out of scope"
+	#run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	#sleep 1
+	#run_cmd_nsb nettest -6 -D -r ${a}
+	#log_test_addr ${a} $? 1 "Device server"
+
+	# negative test - should fail
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ${NSA_LINKIP6}%${NSB_DEV}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since there is no server"
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	#
+	# client
+	#
+	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
+	do
+		log_start
+		run_cmd_nsb nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -0 ${NSA_IP6}
+		log_test_addr ${a} $? 0 "Client"
+
+		log_start
+		run_cmd_nsb nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -0 ${NSA_IP6}
+		log_test_addr ${a} $? 0 "Client, device bind"
+
+		log_start
+		run_cmd_nsb nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -C -0 ${NSA_IP6}
+		log_test_addr ${a} $? 0 "Client, device send via cmsg"
+
+		log_start
+		run_cmd_nsb nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP6}
+		log_test_addr ${a} $? 0 "Client, device bind via IPV6_UNICAST_IF"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 1 "No server, unbound client"
+
+		log_start
+		show_hint "Should fail 'Connection refused'"
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "No server, device client"
+	done
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP6} ${NSA_LO_IP6} ::1
+	do
+		log_start
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -0 ${a} -1 ${a}
+		log_test_addr ${a} $? 0 "Global server, local connection"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s -D -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -r ${a}
+	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
+
+	for a in ${NSA_LO_IP6} ::1
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since address is out of device scope"
+		run_cmd nettest -6 -s -D -d ${NSA_DEV} &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 1 "Device server, local connection"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s -D &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device client, local connection"
+
+	log_start
+	run_cmd nettest -6 -s -D &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -C -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device send via cmsg, local connection"
+
+	log_start
+	run_cmd nettest -6 -s -D &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -S -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device client via IPV6_UNICAST_IF, local connection"
+
+	for a in ${NSA_LO_IP6} ::1
+	do
+		log_start
+		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV}
+		log_test_addr ${a} $? 1 "Global server, device client, local connection"
+
+		log_start
+		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -C
+		log_test_addr ${a} $? 1 "Global server, device send via cmsg, local connection"
+
+		log_start
+		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S
+		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -D -s -d ${NSA_DEV} -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a} -0 ${a}
+	log_test_addr ${a} $? 0 "Device server, device client, local conn"
+
+	log_start
+	show_hint "Should fail 'Connection refused'"
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 1 "No server, device client, local conn"
+
+	# LLA to GUA
+	run_cmd_nsb ip -6 addr del ${NSB_IP6}/64 dev ${NSB_DEV}
+	run_cmd_nsb ip -6 ro add ${NSA_IP6}/128 dev ${NSB_DEV}
+	log_start
+	run_cmd nettest -6 -s -D &
+	sleep 1
+	run_cmd_nsb nettest -6 -D -r ${NSA_IP6}
+	log_test $? 0 "UDP in - LLA to GUA"
+
+	run_cmd_nsb ip -6 ro del ${NSA_IP6}/128 dev ${NSB_DEV}
+	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV} nodad
+}
+
+ipv6_udp_vrf()
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
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since global server is disabled"
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 1 "Global server"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "Enslaved device server"
+	done
+
+	# negative test - should fail
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since there is no server"
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	#
+	# local address tests
+	#
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		show_hint "Should fail 'Connection refused' since global server is disabled"
+		run_cmd nettest -6 -D -s &
+		sleep 1
+		run_cmd nettest -6 -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 1 "Global server, VRF client, local conn"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -d ${VRF} -s &
+		sleep 1
+		run_cmd nettest -6 -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	show_hint "Should fail 'Connection refused' since global server is disabled"
+	run_cmd nettest -6 -D -s &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 1 "Global server, device client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
+
+	# disable global server
+	log_subsection "Global server enabled"
+	set_sysctl net.ipv4.udp_l3mdev_accept=1
+
+	#
+	# server tests
+	#
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "Global server"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "VRF server"
+	done
+
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+		sleep 1
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 0 "Enslaved device server"
+	done
+
+	# negative test - should fail
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd_nsb nettest -6 -D -r ${a}
+		log_test_addr ${a} $? 1 "No server"
+	done
+
+	#
+	# client tests
+	#
+	log_start
+	run_cmd_nsb nettest -6 -D -s &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${NSB_IP6}
+	log_test $? 0 "VRF client"
+
+	# negative test - should fail
+	log_start
+	run_cmd nettest -6 -D -d ${VRF} -r ${NSB_IP6}
+	log_test $? 1 "No server, VRF client"
+
+	log_start
+	run_cmd_nsb nettest -6 -D -s &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_IP6}
+	log_test $? 0 "Enslaved device client"
+
+	# negative test - should fail
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_IP6}
+	log_test $? 1 "No server, enslaved device client"
+
+	#
+	# local address tests
+	#
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
+
+	#log_start
+	run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
+
+
+	a=${VRF_IP6}
+	log_start
+	run_cmd nettest -6 -D -s -2 ${VRF} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${VRF} -s -2 ${VRF} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
+
+	# negative test - should fail
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -D -d ${VRF} -r ${a}
+		log_test_addr ${a} $? 1 "No server, VRF client, local conn"
+	done
+
+	# device to global IP
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -D -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Global server, device client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${VRF} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${VRF} -r ${a}
+	log_test_addr ${a} $? 0 "Device server, VRF client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -s -2 ${NSA_DEV} &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 0 "Device server, device client, local conn"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
+	log_test_addr ${a} $? 1 "No server, device client, local conn"
+
+
+	# link local addresses
+	log_start
+	run_cmd nettest -6 -D -s &
+	sleep 1
+	run_cmd_nsb nettest -6 -D -d ${NSB_DEV} -r ${NSA_LINKIP6}
+	log_test $? 0 "Global server, linklocal IP"
+
+	log_start
+	run_cmd_nsb nettest -6 -D -d ${NSB_DEV} -r ${NSA_LINKIP6}
+	log_test $? 1 "No server, linklocal IP"
+
+
+	log_start
+	run_cmd_nsb nettest -6 -D -s &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_LINKIP6}
+	log_test $? 0 "Enslaved device client, linklocal IP"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_LINKIP6}
+	log_test $? 1 "No server, device client, peer linklocal IP"
+
+
+	log_start
+	run_cmd nettest -6 -D -s &
+	sleep 1
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSA_LINKIP6}
+	log_test $? 0 "Enslaved device client, local conn - linklocal IP"
+
+	log_start
+	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSA_LINKIP6}
+	log_test $? 1 "No server, device client, local conn  - linklocal IP"
+
+	# LLA to GUA
+	run_cmd_nsb ip -6 addr del ${NSB_IP6}/64 dev ${NSB_DEV}
+	run_cmd_nsb ip -6 ro add ${NSA_IP6}/128 dev ${NSB_DEV}
+	log_start
+	run_cmd nettest -6 -s -D &
+	sleep 1
+	run_cmd_nsb nettest -6 -D -r ${NSA_IP6}
+	log_test $? 0 "UDP in - LLA to GUA"
+
+	run_cmd_nsb ip -6 ro del ${NSA_IP6}/128 dev ${NSB_DEV}
+	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV} nodad
+}
+
+ipv6_udp()
+{
+        # should not matter, but set to known state
+        set_sysctl net.ipv4.udp_early_demux=1
+
+        log_section "IPv6/UDP"
+        log_subsection "No VRF"
+        setup
+
+        # udp_l3mdev_accept should have no affect without VRF;
+        # run tests with it enabled and disabled to verify
+        log_subsection "udp_l3mdev_accept disabled"
+        set_sysctl net.ipv4.udp_l3mdev_accept=0
+        ipv6_udp_novrf
+        log_subsection "udp_l3mdev_accept enabled"
+        set_sysctl net.ipv4.udp_l3mdev_accept=1
+        ipv6_udp_novrf
+
+        log_subsection "With VRF"
+        setup "yes"
+        ipv6_udp_vrf
+}
+
+################################################################################
 # usage
 
 usage()
@@ -2069,7 +2558,7 @@ EOF
 # main
 
 TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp"
-TESTS_IPV6="ipv6_ping ipv6_tcp"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp"
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -2113,6 +2602,7 @@ do
 
 	ipv6_ping|ping6) ipv6_ping;;
 	ipv6_tcp|tcp6)   ipv6_tcp;;
+	ipv6_udp|udp6)   ipv6_udp;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
-- 
2.11.0

