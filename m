Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD8F7E2C5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbfHASze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387729AbfHASzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8E520B7C;
        Thu,  1 Aug 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685713;
        bh=0+Cz6Fk0fOUzA4tGlH0AOKyqGR0o/YaaDtXTYH6uL4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVuwFeEAts/dwCgZDm/U9QHMX0sWXA8u2Jhy29hhekHT0nsQ0/e5nxzznmdQxy4NG
         aJkeOkHuqnTS+YTPjc1No7vQWckMzMMm73UGcQgeqKvsrqWuplaYNMx/XLbBw4kaW+
         W8mNrxlFnn7Ji7KdXXW3P06+S4Kz9saJfWXewG7Q=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 09/15] selftests: Add ipv4 address bind tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:42 -0700
Message-Id: <20190801185648.27653-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add address bind tests to fcnal-test.sh. Verifies socket binding to
local addresses for raw, tcp and udp including device and VRF cases.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 111 +++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 2a2e692bc242..6023ee1c6980 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1401,6 +1401,114 @@ ipv4_udp()
 }
 
 ################################################################################
+# IPv4 address bind
+#
+# verifies ability or inability to bind to an address / device
+
+ipv4_addr_bind_novrf()
+{
+	#
+	# raw socket
+	#
+	for a in ${NSA_IP} ${NSA_LO_IP}
+	do
+		log_start
+		run_cmd nettest -s -R -P icmp -l ${a} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address"
+
+		log_start
+		run_cmd nettest -s -R -P icmp -l ${a} -d ${NSA_DEV} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
+	done
+
+	#
+	# tcp sockets
+	#
+	a=${NSA_IP}
+	log_start
+	run_cmd nettest -l ${a} -r ${NSB_IP} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to local address"
+
+	log_start
+	run_cmd nettest -l ${a} -r ${NSB_IP} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
+
+	# Sadly, the kernel allows binding a socket to a device and then
+	# binding to an address not on the device. The only restriction
+	# is that the address is valid in the L3 domain. So this test
+	# passes when it really should not
+	#a=${NSA_LO_IP}
+	#log_start
+	#show_hint "Should fail with 'Cannot assign requested address'"
+	#run_cmd nettest -s -l ${a} -d ${NSA_DEV} -t1 -b
+	#log_test_addr ${a} $? 1 "TCP socket bind to out of scope local address"
+}
+
+ipv4_addr_bind_vrf()
+{
+	#
+	# raw socket
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest -s -R -P icmp -l ${a} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address"
+
+		log_start
+		run_cmd nettest -s -R -P icmp -l ${a} -d ${NSA_DEV} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
+		log_start
+		run_cmd nettest -s -R -P icmp -l ${a} -d ${VRF} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address after VRF bind"
+	done
+
+	a=${NSA_LO_IP}
+	log_start
+	show_hint "Address on loopback is out of VRF scope"
+	run_cmd nettest -s -R -P icmp -l ${a} -d ${VRF} -b
+	log_test_addr ${a} $? 1 "Raw socket bind to out of scope address after VRF bind"
+
+	#
+	# tcp sockets
+	#
+	for a in ${NSA_IP} ${VRF_IP}
+	do
+		log_start
+		run_cmd nettest -s -l ${a} -d ${VRF} -t1 -b
+		log_test_addr ${a} $? 0 "TCP socket bind to local address"
+
+		log_start
+		run_cmd nettest -s -l ${a} -d ${NSA_DEV} -t1 -b
+		log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
+	done
+
+	a=${NSA_LO_IP}
+	log_start
+	show_hint "Address on loopback out of scope for VRF"
+	run_cmd nettest -s -l ${a} -d ${VRF} -t1 -b
+	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for VRF"
+
+	log_start
+	show_hint "Address on loopback out of scope for device in VRF"
+	run_cmd nettest -s -l ${a} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for device bind"
+}
+
+ipv4_addr_bind()
+{
+	log_section "IPv4 address binds"
+
+	log_subsection "No VRF"
+	setup
+	ipv4_addr_bind_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv4_addr_bind_vrf
+}
+
+################################################################################
 # IPv6
 
 ipv6_ping_novrf()
@@ -2557,7 +2665,7 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind"
 TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp"
 PAUSE_ON_FAIL=no
 PAUSE=no
@@ -2599,6 +2707,7 @@ do
 	ipv4_ping|ping)  ipv4_ping;;
 	ipv4_tcp|tcp)    ipv4_tcp;;
 	ipv4_udp|udp)    ipv4_udp;;
+	ipv4_bind|bind)  ipv4_addr_bind;;
 
 	ipv6_ping|ping6) ipv6_ping;;
 	ipv6_tcp|tcp6)   ipv6_tcp;;
-- 
2.11.0

