Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7C912D4C6
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfL3WTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727747AbfL3WTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:36 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A80D21D7D;
        Mon, 30 Dec 2019 22:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743881;
        bh=ZeX7BmyzQShH8ksFQKaMq6Ah84dk9tqC4ydQFIGxzVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHBbKXqqLqOO3nq0dhIENI+PWHudXBatHi3IY8Jlo/jyzxxa9NgeCsamRRuhu7QSz
         2UCYl3UwAoJELHa54E3s8vwTo/uneO5SyWh53G0E0EnU3cO8r8La10C1SxDiM3U+ZA
         ZBLQwop2GY7w/N2LhN/Y9OYkACQaIoMeFwT/NQQk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 9/9] fcnal-test: Add TCP MD5 tests for VRF
Date:   Mon, 30 Dec 2019 14:14:33 -0800
Message-Id: <20191230221433.2717-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add tests for new TCP MD5 API for L3 domains (VRF).

A new namespace is added to create a duplicate configuration between
the VRF and default VRF to verify overlapping config is handled properly.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 313 ++++++++++++++++++++++++++++++
 1 file changed, 313 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index e630c6a7ee72..15cb8ab68c7c 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -32,12 +32,17 @@
 #      lo2: 127.0.0.1/8, ::1/128
 #           172.16.2.2/32, 2001:db8:2::2/128
 #
+# ns-A to ns-C connection - only for VRF and same config
+# as ns-A to ns-B
+#
 # server / client nomenclature relative to ns-A
 
 VERBOSE=0
 
 NSA_DEV=eth1
+NSA_DEV2=eth2
 NSB_DEV=eth1
+NSC_DEV=eth2
 VRF=red
 VRF_TABLE=1101
 
@@ -68,9 +73,11 @@ NSB_LINKIP6=
 
 NSA=ns-A
 NSB=ns-B
+NSC=ns-C
 
 NSA_CMD="ip netns exec ${NSA}"
 NSB_CMD="ip netns exec ${NSB}"
+NSC_CMD="ip netns exec ${NSC}"
 
 which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
 
@@ -200,6 +207,11 @@ run_cmd_nsb()
 	do_run_cmd ${NSB_CMD} $*
 }
 
+run_cmd_nsc()
+{
+	do_run_cmd ${NSC_CMD} $*
+}
+
 setup_cmd()
 {
 	local cmd="$*"
@@ -406,6 +418,7 @@ cleanup()
 	fi
 
 	ip netns del ${NSB}
+	ip netns del ${NSC} >/dev/null 2>&1
 }
 
 setup()
@@ -437,6 +450,12 @@ setup()
 
 		ip -netns ${NSB} ro add ${VRF_IP}/32 via ${NSA_IP} dev ${NSB_DEV}
 		ip -netns ${NSB} -6 ro add ${VRF_IP6}/128 via ${NSA_IP6} dev ${NSB_DEV}
+
+		# some VRF tests use ns-C which has the same config as
+		# ns-B but for a device NOT in the VRF
+		create_ns ${NSC} "-" "-"
+		connect_ns ${NSA} ${NSA_DEV2} ${NSA_IP}/24 ${NSA_IP6}/64 \
+			   ${NSC} ${NSC_DEV} ${NSB_IP}/24 ${NSB_IP6}/64
 	else
 		ip -netns ${NSA} ro add ${NSB_LO_IP}/32 via ${NSB_IP} dev ${NSA_DEV}
 		ip -netns ${NSA} ro add ${NSB_LO_IP6}/128 via ${NSB_IP6} dev ${NSA_DEV}
@@ -787,6 +806,150 @@ ipv4_tcp_md5_novrf()
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
+#
+# MD5 tests with VRF
+#
+ipv4_tcp_md5()
+{
+	#
+	# single address
+	#
+
+	# basic use case
+	log_start
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Single address config"
+
+	# client sends MD5, server not configured
+	log_start
+	show_hint "Should timeout since server does not have MD5 auth"
+	run_cmd nettest -s -d ${VRF} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Server no config, client uses password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Client uses wrong password"
+
+	# client from different address
+	log_start
+	show_hint "Should timeout since server config differs from client"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
+
+	#
+	# MD5 extension - prefix length
+	#
+
+	# client in prefix
+	log_start
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout since client address is outside of prefix"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
+
+	#
+	# duplicate config between default VRF and a VRF
+	#
+
+	log_start
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
+
+	log_start
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest  -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
+
+	log_start
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
+
+	log_start
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsc nettest  -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
+
+	#
+	# negative tests
+	#
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} -M ${MD5_PW} -r ${NSB_IP}
+	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
+
+	log_start
+	run_cmd nettest -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET}
+	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
+
+}
+
 ipv4_tcp_novrf()
 {
 	local a
@@ -958,6 +1121,9 @@ ipv4_tcp_vrf()
 	run_cmd nettest -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
+	# run MD5 tests
+	ipv4_tcp_md5
+
 	#
 	# enable VRF global server
 	#
@@ -2104,6 +2270,150 @@ ipv6_tcp_md5_novrf()
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
+#
+# MD5 tests with VRF
+#
+ipv6_tcp_md5()
+{
+	#
+	# single address
+	#
+
+	# basic use case
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Single address config"
+
+	# client sends MD5, server not configured
+	log_start
+	show_hint "Should timeout since server does not have MD5 auth"
+	run_cmd nettest -6 -s -d ${VRF} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Server no config, client uses password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Client uses wrong password"
+
+	# client from different address
+	log_start
+	show_hint "Should timeout since server config differs from client"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_LO_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
+
+	#
+	# MD5 extension - prefix length
+	#
+
+	# client in prefix
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout since client address is outside of prefix"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
+
+	#
+	# duplicate config between default VRF and a VRF
+	#
+
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6  -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
+
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsc nettest -6  -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
+
+	#
+	# negative tests
+	#
+	log_start
+	run_cmd nettest -6 -s -d ${NSA_DEV} -M ${MD5_PW} -r ${NSB_IP6}
+	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
+
+	log_start
+	run_cmd nettest -6 -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET6}
+	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
+
+}
+
 ipv6_tcp_novrf()
 {
 	local a
@@ -2290,6 +2600,9 @@ ipv6_tcp_vrf()
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
+	# run MD5 tests
+	ipv6_tcp_md5
+
 	#
 	# enable VRF global server
 	#
-- 
2.11.0

