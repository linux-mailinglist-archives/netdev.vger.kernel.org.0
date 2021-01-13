Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2702F42BB
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbhAMEBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAMEBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:01:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 643D723136;
        Wed, 13 Jan 2021 04:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510457;
        bh=A7fICvUmlqY05fcclR5wKwuk/ao5eGVQ2x0uhWW8TTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWjch6M8YBA3Pu+b/ImYrzsGnVKV+EdTQ1WGrS/E5+FBmg3dyiqEdzYIyaAuBD1ky
         gNs1WnSw0wy/ldz4nzGzIRxH2qzXSS2MLUyeoerHqlZKukEh9ddIUiHCkKlysuz9Kc
         nJGyvu8JiypkG0lq5o+KqhkTWdtGkO0xUwZPVpcX3f6cmx6R9+gN0c8cDxmwXW+EUA
         LqeOLiSdprB47/lklCyKe3mkFORgO2OExSMMDWfgrkqhQb6GM1o33irO6KfLxKfe2L
         0ssmw52lX+Lc0EKv1CK1pteo62cmDDFsVVrJIY3Ua9Ddrf87ftfz+WIyTqmVKLIXAd
         o3gx6VpFbLq6w==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 03/13] selftests: Move address validation in nettest
Date:   Tue, 12 Jan 2021 21:00:30 -0700
Message-Id: <20210113040040.50813-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

IPv6 addresses can have a device name to declare a scope (e.g.,
fe80::5054:ff:fe12:3456%eth0). The next patch adds support to
switch network namespace before running client or server code
(or both), so move the address validation to the server and
client functions.

IPv4 multicast groups do not have the device scope in the address
specification, so they can be validated inline with option parsing.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 60 +++++++++++++++++++--------
 1 file changed, 43 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 337ae54e252d..3b083fad3577 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -43,12 +43,14 @@
 
 struct sock_args {
 	/* local address */
+	const char *local_addr_str;
 	union {
 		struct in_addr  in;
 		struct in6_addr in6;
 	} local_addr;
 
 	/* remote address */
+	const char *remote_addr_str;
 	union {
 		struct in_addr  in;
 		struct in6_addr in6;
@@ -77,6 +79,7 @@ struct sock_args {
 
 	const char *password;
 	/* prefix for MD5 password */
+	const char *md5_prefix_str;
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
@@ -88,12 +91,14 @@ struct sock_args {
 	int expected_ifindex;
 
 	/* local address */
+	const char *expected_laddr_str;
 	union {
 		struct in_addr  in;
 		struct in6_addr in6;
 	} expected_laddr;
 
 	/* remote address */
+	const char *expected_raddr_str;
 	union {
 		struct in_addr  in;
 		struct in6_addr in6;
@@ -753,6 +758,34 @@ static int convert_addr(struct sock_args *args, const char *_str,
 	return rc;
 }
 
+static int validate_addresses(struct sock_args *args)
+{
+	if (args->local_addr_str &&
+	    convert_addr(args, args->local_addr_str, ADDR_TYPE_LOCAL) < 0)
+		return 1;
+
+	if (args->remote_addr_str &&
+	    convert_addr(args, args->remote_addr_str, ADDR_TYPE_REMOTE) < 0)
+		return 1;
+
+	if (args->md5_prefix_str &&
+	    convert_addr(args, args->md5_prefix_str,
+			 ADDR_TYPE_MD5_PREFIX) < 0)
+		return 1;
+
+	if (args->expected_laddr_str &&
+	    convert_addr(args, args->expected_laddr_str,
+			 ADDR_TYPE_EXPECTED_LOCAL))
+		return 1;
+
+	if (args->expected_raddr_str &&
+	    convert_addr(args, args->expected_raddr_str,
+			 ADDR_TYPE_EXPECTED_REMOTE))
+		return 1;
+
+	return 0;
+}
+
 static int get_index_from_cmsg(struct msghdr *m)
 {
 	struct cmsghdr *cm;
@@ -1344,7 +1377,7 @@ static int do_server(struct sock_args *args)
 	fd_set rfds;
 	int rc;
 
-	if (resolve_devices(args))
+	if (resolve_devices(args) || validate_addresses(args))
 		return 1;
 
 	if (prog_timeout)
@@ -1532,7 +1565,7 @@ static int do_client(struct sock_args *args)
 		return 1;
 	}
 
-	if (resolve_devices(args))
+	if (resolve_devices(args) || validate_addresses(args))
 		return 1;
 
 	if ((args->use_setsockopt || args->use_cmsg) && !args->ifindex) {
@@ -1680,13 +1713,11 @@ int main(int argc, char *argv[])
 			break;
 		case 'l':
 			args.has_local_ip = 1;
-			if (convert_addr(&args, optarg, ADDR_TYPE_LOCAL) < 0)
-				return 1;
+			args.local_addr_str = optarg;
 			break;
 		case 'r':
 			args.has_remote_ip = 1;
-			if (convert_addr(&args, optarg, ADDR_TYPE_REMOTE) < 0)
-				return 1;
+			args.remote_addr_str = optarg;
 			break;
 		case 'p':
 			if (str_to_uint(optarg, 1, 65535, &tmp) != 0) {
@@ -1733,8 +1764,7 @@ int main(int argc, char *argv[])
 			args.password = optarg;
 			break;
 		case 'm':
-			if (convert_addr(&args, optarg, ADDR_TYPE_MD5_PREFIX) < 0)
-				return 1;
+			args.md5_prefix_str = optarg;
 			break;
 		case 'S':
 			args.use_setsockopt = 1;
@@ -1762,16 +1792,11 @@ int main(int argc, char *argv[])
 			break;
 		case '0':
 			args.has_expected_laddr = 1;
-			if (convert_addr(&args, optarg,
-					 ADDR_TYPE_EXPECTED_LOCAL))
-				return 1;
+			args.expected_laddr_str = optarg;
 			break;
 		case '1':
 			args.has_expected_raddr = 1;
-			if (convert_addr(&args, optarg,
-					 ADDR_TYPE_EXPECTED_REMOTE))
-				return 1;
-
+			args.expected_raddr_str = optarg;
 			break;
 		case '2':
 			args.expected_dev = optarg;
@@ -1786,12 +1811,13 @@ int main(int argc, char *argv[])
 	}
 
 	if (args.password &&
-	    ((!args.has_remote_ip && !args.prefix_len) || args.type != SOCK_STREAM)) {
+	    ((!args.has_remote_ip && !args.md5_prefix_str) ||
+	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if (args.prefix_len && !args.password) {
+	if (args.md5_prefix_str && !args.password) {
 		log_error("Prefix range for MD5 protection specified without a password\n");
 		return 1;
 	}
-- 
2.24.3 (Apple Git-128)

