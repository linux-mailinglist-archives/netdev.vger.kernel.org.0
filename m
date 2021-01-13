Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CE72F42C0
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhAMECU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbhAMECT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:02:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E34512313E;
        Wed, 13 Jan 2021 04:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510462;
        bh=t8EYqIYmqi0yaDBNziRHBBGMed6d2n9kpX29/jgErM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7OXPinW2YLJtn4jjfZPggTJrx0TNjMwYGxICHwe8Bg7IoWedEnG3Wq9nCbuDbIas
         UTd+j0PZ7v6aCCxZV8t+5F1jAr/d4gDsDJT9WZxgLGwfX3z+v4oPqaUL5fkJiOh06/
         OHBKZySAs2yx8WotJAwDuoa39zn1mX4G7P24MVyHSn6uNSneFalZKPAlh+m7+9piOQ
         wjjeQTnvsJv62JCw8THPSHb1e+auvZKXE6basd8M49mFcIOZLGlrLqDaMRbi/nPW9T
         NhBsp0lFqVIaI5y6f625gn7rEfVTmOZA4LI9zhqTTn4Yz9Lky1UVp4aVtj9t16c7Mm
         dWM9arcWi9uOA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 09/13] selftests: Consistently specify address for MD5 protection
Date:   Tue, 12 Jan 2021 21:00:36 -0700
Message-Id: <20210113040040.50813-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

nettest started with -r as the remote address for MD5 passwords.
The -m argument was added to use prefixes with a length when that
feature was added to the kernel. Since -r is used to specify
remote address for client mode, change nettest to only use -m
for MD5 passwords and update fcnal-test script.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 60 +++++++++++------------
 tools/testing/selftests/net/nettest.c     |  6 +--
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 02b0b9ead40b..edd33f83f80e 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -801,7 +801,7 @@ ipv4_tcp_md5_novrf()
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
@@ -817,7 +817,7 @@ ipv4_tcp_md5_novrf()
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
@@ -825,7 +825,7 @@ ipv4_tcp_md5_novrf()
 	# client from different address
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -s -M ${MD5_PW} -r ${NSB_LO_IP} &
+	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
@@ -869,7 +869,7 @@ ipv4_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
@@ -885,7 +885,7 @@ ipv4_tcp_md5()
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
@@ -893,7 +893,7 @@ ipv4_tcp_md5()
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_LO_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
@@ -930,31 +930,31 @@ ipv4_tcp_md5()
 	#
 
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest  -r ${NSA_IP} -M ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsc nettest  -r ${NSA_IP} -M ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsc nettest -r ${NSA_IP} -M ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -r ${NSB_IP} &
+	run_cmd nettest -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
 	sleep 1
 	run_cmd_nsb nettest -r ${NSA_IP} -M ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
@@ -993,7 +993,7 @@ ipv4_tcp_md5()
 	# negative tests
 	#
 	log_start
-	run_cmd nettest -s -d ${NSA_DEV} -M ${MD5_PW} -r ${NSB_IP}
+	run_cmd nettest -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
 
 	log_start
@@ -2265,7 +2265,7 @@ ipv6_tcp_md5_novrf()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
@@ -2281,7 +2281,7 @@ ipv6_tcp_md5_novrf()
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
@@ -2289,7 +2289,7 @@ ipv6_tcp_md5_novrf()
 	# client from different address
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -6 -s -M ${MD5_PW} -r ${NSB_LO_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
@@ -2333,7 +2333,7 @@ ipv6_tcp_md5()
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
@@ -2349,7 +2349,7 @@ ipv6_tcp_md5()
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
@@ -2357,7 +2357,7 @@ ipv6_tcp_md5()
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_LO_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
@@ -2394,31 +2394,31 @@ ipv6_tcp_md5()
 	#
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6  -r ${NSA_IP6} -M ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsc nettest -6  -r ${NSA_IP6} -M ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -M ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -r ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -r ${NSB_IP6} &
+	run_cmd nettest -6 -s -d ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
 	sleep 1
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -M ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
@@ -2457,7 +2457,7 @@ ipv6_tcp_md5()
 	# negative tests
 	#
 	log_start
-	run_cmd nettest -6 -s -d ${NSA_DEV} -M ${MD5_PW} -r ${NSB_IP6}
+	run_cmd nettest -6 -s -d ${NSA_DEV} -M ${MD5_PW} -m ${NSB_IP6}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - single address"
 
 	log_start
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index b436e2942e86..e8c998f0a566 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -291,13 +291,13 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 	switch (args->version) {
 	case AF_INET:
 		sin.sin_port = htons(args->port);
-		sin.sin_addr = args->remote_addr.in;
+		sin.sin_addr = args->md5_prefix.v4.sin_addr;
 		addr = &sin;
 		alen = sizeof(sin);
 		break;
 	case AF_INET6:
 		sin6.sin6_port = htons(args->port);
-		sin6.sin6_addr = args->remote_addr.in6;
+		sin6.sin6_addr = args->md5_prefix.v6.sin6_addr;
 		addr = &sin6;
 		alen = sizeof(sin6);
 		break;
@@ -725,7 +725,7 @@ static int convert_addr(struct sock_args *args, const char *_str,
 				return 1;
 			}
 		} else {
-			args->prefix_len = pfx_len_max;
+			args->prefix_len = 0;
 		}
 		break;
 	default:
-- 
2.24.3 (Apple Git-128)

