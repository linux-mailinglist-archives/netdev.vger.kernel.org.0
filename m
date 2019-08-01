Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA57E2B8
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387804AbfHASzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbfHASzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:15 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28D921773;
        Thu,  1 Aug 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685714;
        bh=y3fyP9ZYru8xxv7ihOxEoMvPvkFqyRcvzHha3Jt1L78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipqCIkFSNq1hwC6N1t+4kQ+fVZpyn5vWZpMV20znk0ulwwVYd7K4XOS3MhKpIZxAz
         j2P9EH4y81RKYBYvW2SbeIOL2Vor8+aY8bpMtSPJVt3qFnIMPJivAHw/uVPmGfsetR
         t4CzuwN6Wh3bbwbYSBtoUMQW3CxSF9B75WDtL3xw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 10/15] selftests: Add ipv6 address bind tests to fcnal-test
Date:   Thu,  1 Aug 2019 11:56:43 -0700
Message-Id: <20190801185648.27653-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv6 address bind tests to fcnal-test.sh. Verifies socket binding to
local addresses for raw, tcp and udp including device and VRF cases.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 110 +++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 6023ee1c6980..48e74d62e009 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -2646,6 +2646,113 @@ ipv6_udp()
 }
 
 ################################################################################
+# IPv6 address bind
+
+ipv6_addr_bind_novrf()
+{
+	#
+	# raw socket
+	#
+	for a in ${NSA_IP6} ${NSA_LO_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address"
+
+		log_start
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${NSA_DEV} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
+	done
+
+	#
+	# tcp sockets
+	#
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s -l ${a} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to local address"
+
+	log_start
+	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Should fail with 'Cannot assign requested address'"
+	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 1 "TCP socket bind to out of scope local address"
+}
+
+ipv6_addr_bind_vrf()
+{
+	#
+	# raw socket
+	#
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${VRF} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address after vrf bind"
+
+		log_start
+		run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${NSA_DEV} -b
+		log_test_addr ${a} $? 0 "Raw socket bind to local address after device bind"
+	done
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Address on loopback is out of VRF scope"
+	run_cmd nettest -6 -s -R -P ipv6-icmp -l ${a} -d ${VRF} -b
+	log_test_addr ${a} $? 1 "Raw socket bind to invalid local address after vrf bind"
+
+	#
+	# tcp sockets
+	#
+	# address on enslaved device is valid for the VRF or device in a VRF
+	for a in ${NSA_IP6} ${VRF_IP6}
+	do
+		log_start
+		run_cmd nettest -6 -s -l ${a} -d ${VRF} -t1 -b
+		log_test_addr ${a} $? 0 "TCP socket bind to local address with VRF bind"
+	done
+
+	a=${NSA_IP6}
+	log_start
+	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 0 "TCP socket bind to local address with device bind"
+
+	a=${VRF_IP6}
+	log_start
+	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 1 "TCP socket bind to VRF address with device bind"
+
+	a=${NSA_LO_IP6}
+	log_start
+	show_hint "Address on loopback out of scope for VRF"
+	run_cmd nettest -6 -s -l ${a} -d ${VRF} -t1 -b
+	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for VRF"
+
+	log_start
+	show_hint "Address on loopback out of scope for device in VRF"
+	run_cmd nettest -6 -s -l ${a} -d ${NSA_DEV} -t1 -b
+	log_test_addr ${a} $? 1 "TCP socket bind to invalid local address for device bind"
+
+}
+
+ipv6_addr_bind()
+{
+	log_section "IPv6 address binds"
+
+	log_subsection "No VRF"
+	setup
+	ipv6_addr_bind_novrf
+
+	log_subsection "With VRF"
+	setup "yes"
+	ipv6_addr_bind_vrf
+}
+
+################################################################################
 # usage
 
 usage()
@@ -2666,7 +2773,7 @@ EOF
 # main
 
 TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind"
-TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind"
 PAUSE_ON_FAIL=no
 PAUSE=no
 
@@ -2712,6 +2819,7 @@ do
 	ipv6_ping|ping6) ipv6_ping;;
 	ipv6_tcp|tcp6)   ipv6_tcp;;
 	ipv6_udp|udp6)   ipv6_udp;;
+	ipv6_bind|bind6) ipv6_addr_bind;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
-- 
2.11.0

