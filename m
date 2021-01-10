Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F252F048C
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAJAUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:20:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbhAJAUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABCAA23A75;
        Sun, 10 Jan 2021 00:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237941;
        bh=p0kQLrRV+UiCIVCjRQ0vHbojKT0zP/ZuPfqmNSXn5Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYG/tf7JXPDEmVS3iLSH9lijaKhGj1wLGf4KF7SOHa2soOGmCNH7WnZl6Dw2vG4/8
         q/tR0ab5iH3kPtjuAF65oJuLN7pdv0I4zsus9VSW/haYK7zObTDWwqx37BfV5bODM/
         8Aqyfw+u4JzjsXW59GGlngAoLU9C0+38cBJ1X471q/FHjdDDZd0lwfO3ZUHSSkUfMy
         8c6bovd9AYwoWpI1Z2/v2sHt9CRj3qb6yAhQadZjOPLtHHiK2aPNx8QF8AqUfkBzBY
         Z6IjZrfX+Uy0LF3oNHwVPBf4k6LJ4jyYCoKbo2Pol6ORCuK/q1scCmLwVp7Gz1Sqqf
         IeUbUj3dVYH/Q==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v2 09/11] selftests: Consistently specify address for MD5 protection
Date:   Sat,  9 Jan 2021 17:18:50 -0700
Message-Id: <20210110001852.35653-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210110001852.35653-1-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
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
index 828dc7e879f2..8a3ddc51883f 100644
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

