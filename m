Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0976F2F02F3
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbhAISz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbhAISz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 13:55:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4242223A3C;
        Sat,  9 Jan 2021 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218454;
        bh=thWdAPYJqoOY8brcvqG/uV8hJ0QkXlxxE3FTf4ww0UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJodP6M2Xm7UQFv/u9KpwOrqIQNvKrcRGFnCQxVVS2afCGNEdDkHcmKOml9x2J+Db
         rA31Avurgp6uOX6+oAHSYNm0VF5ZuQPD1k4NZYb7HlcO7pH+lSSCBGbjxsOil09J/M
         t7O6JBHF58RhBdaeyeg7Pfw2nFOtPHc6ZMv0dLRf+xQypw+YAmZwHbRiOG+knHKCEX
         G11rgwQHB9ZRYyd0vVsQ27nHe70/5JLfxOgzGfTtKFclaNtWmqx65/SLr+tXC+Mnm+
         zD01PenZRPwLM/XxW4pMf9PvvKkCtoHG2xoYLIMfJz+Grw0uWZ/ZF4oOEv8/Aj7KmJ
         DKxYkEg49ogXg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/11] selftests: Add new option for client-side passwords
Date:   Sat,  9 Jan 2021 11:53:57 -0700
Message-Id: <20210109185358.34616-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210109185358.34616-1-dsahern@kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add new option to nettest to specify MD5 password to use for client
side. Update fcnal-test script. This is needed for a single instance
running both server and client modes to test password mismatches.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 88 +++++++++++------------
 tools/testing/selftests/net/nettest.c     |  9 ++-
 2 files changed, 52 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index edd33f83f80e..5d15ded2433b 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -803,7 +803,7 @@ ipv4_tcp_md5_novrf()
 	log_start
 	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
@@ -811,7 +811,7 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -s &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Server no config, client uses password"
 
 	# wrong password
@@ -819,7 +819,7 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
 
 	# client from different address
@@ -827,7 +827,7 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
 
 	#
@@ -838,7 +838,7 @@ ipv4_tcp_md5_novrf()
 	log_start
 	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: Prefix config"
 
 	# client in prefix, wrong password
@@ -846,7 +846,7 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Prefix config, client uses wrong password"
 
 	# client outside of prefix
@@ -854,7 +854,7 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
@@ -871,7 +871,7 @@ ipv4_tcp_md5()
 	log_start
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
@@ -879,7 +879,7 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since server does not have MD5 auth"
 	run_cmd nettest -s -d ${VRF} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
 
 	# wrong password
@@ -887,7 +887,7 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
 
 	# client from different address
@@ -895,7 +895,7 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since server config differs from client"
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
 
 	#
@@ -906,7 +906,7 @@ ipv4_tcp_md5()
 	log_start
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
 
 	# client in prefix, wrong password
@@ -914,7 +914,7 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
 
 	# client outside of prefix
@@ -922,7 +922,7 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since client address is outside of prefix"
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
@@ -933,14 +933,14 @@ ipv4_tcp_md5()
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsc nettest  -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
@@ -948,7 +948,7 @@ ipv4_tcp_md5()
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsc nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
@@ -956,21 +956,21 @@ ipv4_tcp_md5()
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsc nettest  -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
 
 	log_start
@@ -978,7 +978,7 @@ ipv4_tcp_md5()
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsc nettest -r ${NSA_IP} -M ${MD5_PW}
+	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
@@ -986,7 +986,7 @@ ipv4_tcp_md5()
 	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	#
@@ -2267,7 +2267,7 @@ ipv6_tcp_md5_novrf()
 	log_start
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
@@ -2275,7 +2275,7 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -6 -s &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Server no config, client uses password"
 
 	# wrong password
@@ -2283,7 +2283,7 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
 
 	# client from different address
@@ -2291,7 +2291,7 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
 
 	#
@@ -2302,7 +2302,7 @@ ipv6_tcp_md5_novrf()
 	log_start
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: Prefix config"
 
 	# client in prefix, wrong password
@@ -2310,7 +2310,7 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Prefix config, client uses wrong password"
 
 	# client outside of prefix
@@ -2318,7 +2318,7 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
@@ -2335,7 +2335,7 @@ ipv6_tcp_md5()
 	log_start
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
@@ -2343,7 +2343,7 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since server does not have MD5 auth"
 	run_cmd nettest -6 -s -d ${VRF} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
 
 	# wrong password
@@ -2351,7 +2351,7 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
 
 	# client from different address
@@ -2359,7 +2359,7 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since server config differs from client"
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
 
 	#
@@ -2370,7 +2370,7 @@ ipv6_tcp_md5()
 	log_start
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
 
 	# client in prefix, wrong password
@@ -2378,7 +2378,7 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since client uses wrong password"
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
 
 	# client outside of prefix
@@ -2386,7 +2386,7 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since client address is outside of prefix"
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
@@ -2397,14 +2397,14 @@ ipv6_tcp_md5()
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsc nettest -6  -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
@@ -2412,7 +2412,7 @@ ipv6_tcp_md5()
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
@@ -2420,21 +2420,21 @@ ipv6_tcp_md5()
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsc nettest -6  -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
 
 	log_start
@@ -2442,7 +2442,7 @@ ipv6_tcp_md5()
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
@@ -2450,7 +2450,7 @@ ipv6_tcp_md5()
 	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	#
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index ef82766dac98..d7f96faf4f46 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -85,6 +85,7 @@ struct sock_args {
 	const char *serverns;
 
 	const char *password;
+	const char *client_pw;
 	/* prefix for MD5 password */
 	const char *md5_prefix_str;
 	union {
@@ -1653,6 +1654,8 @@ static int do_client(struct sock_args *args)
 		break;
 	}
 
+	args->password = args->client_pw;
+
 	if (args->has_grp)
 		sd = msock_client(args);
 	else
@@ -1762,7 +1765,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:m:d:BN:O:SCi6L:0:1:2:Fbq"
+#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:X:m:d:BN:O:SCi6L:0:1:2:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1794,6 +1797,7 @@ static void print_usage(char *prog)
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M password   use MD5 sum protection\n"
+	"    -X password   MD5 password for client mode\n"
 	"    -m prefix/len prefix and length to use for MD5 key\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
@@ -1898,6 +1902,9 @@ int main(int argc, char *argv[])
 		case 'M':
 			args.password = optarg;
 			break;
+		case 'X':
+			args.client_pw = optarg;
+			break;
 		case 'm':
 			args.md5_prefix_str = optarg;
 			break;
-- 
2.24.3 (Apple Git-128)

