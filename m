Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06CB2F5905
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbhANDLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbhANDL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:11:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 377112388D;
        Thu, 14 Jan 2021 03:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593806;
        bh=KdpOZhx4t/80iWYthGadBw81vQnIrC1ljhbnih0tRBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjs4fC9+DgfRS6KrOg3lT+Si8GRZggkcKqsfT2cwAyXBseB4z800cZNxXeuJPerNx
         BcGp4x2lcOV2hkadsnZ2OPTVAvULq+NAOAD8qYdUWS54JpO0ZeYe69VRiarsU8LQRl
         EqSuH7P0aiPhlRUdyWvIOFMnpY0DgER0EPVKxc4KwTwI93jwDXm3rU3Kjb7pMCcAli
         5VNLIIwASsnJF+ZSl4PUuS9LxqpgzQrzf4XAYmKro/ow9y1pq4hZR/dRcvkhN/3uV6
         PK9cLv50yuU5gfQQcYzmC66gGj2Z0mSdX+m0eEII2GaGovvCrvCeKoI5WwexVk3Zjl
         0ZMeAvYw6hdXA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v4 13/13] selftests: Add separate option to nettest for address binding
Date:   Wed, 13 Jan 2021 20:09:49 -0700
Message-Id: <20210114030949.54425-14-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210114030949.54425-1-dsahern@kernel.org>
References: <20210114030949.54425-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add separate option to nettest to specify local address
binding in client mode.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 12 ++++++------
 tools/testing/selftests/net/nettest.c     | 11 +++++++++--
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 2514a9cb9530..a8ad92850e63 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -854,7 +854,7 @@ ipv4_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
@@ -922,7 +922,7 @@ ipv4_tcp_md5()
 	show_hint "Should timeout since client address is outside of prefix"
 	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
 	sleep 1
-	run_cmd_nsb nettest -l ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
@@ -1706,11 +1706,11 @@ ipv4_addr_bind_novrf()
 	#
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -l ${a} -r ${NSB_IP} -t1 -b
+	run_cmd nettest -c ${a} -r ${NSB_IP} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address"
 
 	log_start
-	run_cmd nettest -l ${a} -r ${NSB_IP} -d ${NSA_DEV} -t1 -b
+	run_cmd nettest -c ${a} -r ${NSB_IP} -d ${NSA_DEV} -t1 -b
 	log_test_addr ${a} $? 0 "TCP socket bind to local address after device bind"
 
 	# Sadly, the kernel allows binding a socket to a device and then
@@ -2318,7 +2318,7 @@ ipv6_tcp_md5_novrf()
 	show_hint "Should timeout due to MD5 mismatch"
 	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
@@ -2386,7 +2386,7 @@ ipv6_tcp_md5()
 	show_hint "Should timeout since client address is outside of prefix"
 	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
 	sleep 1
-	run_cmd_nsb nettest -6 -l ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
+	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 55c586eb2393..6365c7fd1262 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -48,6 +48,7 @@
 struct sock_args {
 	/* local address */
 	const char *local_addr_str;
+	const char *client_local_addr_str;
 	union {
 		struct in_addr  in;
 		struct in6_addr in6;
@@ -1630,6 +1631,7 @@ static int do_client(struct sock_args *args)
 		log_msg("Switched client netns\n");
 	}
 
+	args->local_addr_str = args->client_local_addr_str;
 	if (resolve_devices(args) || validate_addresses(args))
 		return 1;
 
@@ -1770,7 +1772,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6L:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6L:0:1:2:3:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1791,7 +1793,8 @@ static void print_usage(char *prog)
 	"    -6            IPv6 (default is IPv4)\n"
 	"    -P proto      protocol for socket: icmp, ospf (default: none)\n"
 	"    -D|R          datagram (D) / raw (R) socket (default stream)\n"
-	"    -l addr       local address to bind to\n"
+	"    -l addr       local address to bind to in server mode\n"
+	"    -c addr       local address to bind to in client mode\n"
 	"\n"
 	"    -d dev        bind socket to given device name\n"
 	"    -I dev        bind socket to given device name - server mode\n"
@@ -1859,6 +1862,10 @@ int main(int argc, char *argv[])
 			args.has_remote_ip = 1;
 			args.remote_addr_str = optarg;
 			break;
+		case 'c':
+			args.has_local_ip = 1;
+			args.client_local_addr_str = optarg;
+			break;
 		case 'p':
 			if (str_to_uint(optarg, 1, 65535, &tmp) != 0) {
 				fprintf(stderr, "Invalid port\n");
-- 
2.24.3 (Apple Git-128)

