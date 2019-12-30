Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0312D4C5
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfL3WTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbfL3WTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC186208C3;
        Mon, 30 Dec 2019 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743880;
        bh=mZl2kp78LXzZPE5XqeZSA6eMTL9nW7+eDxv+1nvpcY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cU+lY6+bqQFb2YELvWjuG6irsZSqXB+TeyL7VVSoPfxzGJZp1FwQIY/qIj8zYtG2i
         W2pjCPWYnr4rkKatHzG53ASxG2oU8HvPYxue1H0vJ0Zhh9fOL6i889YVOFa/ReEz1s
         vNXepdnz9XSwfQEsiWanMq6+unxvSx3IFuA43H9g=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 7/9] nettest: Add support for TCP_MD5 extensions
Date:   Mon, 30 Dec 2019 14:14:31 -0800
Message-Id: <20191230221433.2717-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Update nettest to implement TCP_MD5SIG_EXT for a prefix and a device.

Add a new option, -m, to specify a prefix and length to use with MD5
auth. The device option comes from the existing -d option. If either
are set and MD5 auth is requested, TCP_MD5SIG_EXT is used instead of
TCP_MD5SIG.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 82 +++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index bb6bb1ad11e2..93208caacbe6 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -74,7 +74,14 @@ struct sock_args {
 	int use_cmsg;
 	const char *dev;
 	int ifindex;
+
 	const char *password;
+	/* prefix for MD5 password */
+	union {
+		struct sockaddr_in v4;
+		struct sockaddr_in6 v6;
+	} md5_prefix;
+	unsigned int prefix_len;
 
 	/* expected addresses and device index for connection */
 	int expected_ifindex;
@@ -200,20 +207,33 @@ static void log_address(const char *desc, struct sockaddr *sa)
 	fflush(stdout);
 }
 
-static int tcp_md5sig(int sd, void *addr, socklen_t alen, const char *password)
+static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args)
 {
-	struct tcp_md5sig md5sig;
-	int keylen = password ? strlen(password) : 0;
+	int keylen = strlen(args->password);
+	struct tcp_md5sig md5sig = {};
+	int opt = TCP_MD5SIG;
 	int rc;
 
-	memset(&md5sig, 0, sizeof(md5sig));
-	memcpy(&md5sig.tcpm_addr, addr, alen);
 	md5sig.tcpm_keylen = keylen;
+	memcpy(md5sig.tcpm_key, args->password, keylen);
 
-	if (keylen)
-		memcpy(md5sig.tcpm_key, password, keylen);
+	if (args->prefix_len) {
+		opt = TCP_MD5SIG_EXT;
+		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_PREFIX;
+
+		md5sig.tcpm_prefixlen = args->prefix_len;
+		addr = &args->md5_prefix;
+	}
+	memcpy(&md5sig.tcpm_addr, addr, alen);
 
-	rc = setsockopt(sd, IPPROTO_TCP, TCP_MD5SIG, &md5sig, sizeof(md5sig));
+	if (args->ifindex) {
+		opt = TCP_MD5SIG_EXT;
+		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_IFINDEX;
+
+		md5sig.tcpm_ifindex = args->ifindex;
+	}
+
+	rc = setsockopt(sd, IPPROTO_TCP, opt, &md5sig, sizeof(md5sig));
 	if (rc < 0) {
 		/* ENOENT is harmless. Returned when a password is cleared */
 		if (errno == ENOENT)
@@ -254,7 +274,7 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 		exit(1);
 	}
 
-	if (tcp_md5sig(sd, addr, alen, args->password))
+	if (tcp_md5sig(sd, addr, alen, args))
 		return -1;
 
 	return 0;
@@ -1313,7 +1333,7 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (args->type != SOCK_STREAM)
 		goto out;
 
-	if (args->password && tcp_md5sig(sd, addr, alen, args->password))
+	if (args->password && tcp_md5sig(sd, addr, alen, args))
 		goto err;
 
 	if (args->bind_test_only)
@@ -1405,16 +1425,18 @@ enum addr_type {
 	ADDR_TYPE_MCAST,
 	ADDR_TYPE_EXPECTED_LOCAL,
 	ADDR_TYPE_EXPECTED_REMOTE,
+	ADDR_TYPE_MD5_PREFIX,
 };
 
 static int convert_addr(struct sock_args *args, const char *_str,
 			enum addr_type atype)
 {
+	int pfx_len_max = args->version == AF_INET6 ? 128 : 32;
 	int family = args->version;
+	char *str, *dev, *sep;
 	struct in6_addr *in6;
 	struct in_addr  *in;
 	const char *desc;
-	char *str, *dev;
 	void *addr;
 	int rc = 0;
 
@@ -1443,6 +1465,30 @@ static int convert_addr(struct sock_args *args, const char *_str,
 		desc = "expected remote";
 		addr = &args->expected_raddr;
 		break;
+	case ADDR_TYPE_MD5_PREFIX:
+		desc = "md5 prefix";
+		if (family == AF_INET) {
+			args->md5_prefix.v4.sin_family = AF_INET;
+			addr = &args->md5_prefix.v4.sin_addr;
+		} else if (family == AF_INET6) {
+			args->md5_prefix.v6.sin6_family = AF_INET6;
+			addr = &args->md5_prefix.v6.sin6_addr;
+		} else
+			return 1;
+
+		sep = strchr(str, '/');
+		if (sep) {
+			*sep = '\0';
+			sep++;
+			if (str_to_uint(sep, 1, pfx_len_max,
+					&args->prefix_len) != 0) {
+				fprintf(stderr, "Invalid port\n");
+				return 1;
+			}
+		} else {
+			args->prefix_len = pfx_len_max;
+		}
+		break;
 	default:
 		log_error("unknown address type");
 		exit(1);
@@ -1522,7 +1568,7 @@ static char *random_msg(int len)
 	return m;
 }
 
-#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:d:SCi6L:0:1:2:Fbq"
+#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:m:d:SCi6L:0:1:2:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1551,6 +1597,7 @@ static void print_usage(char *prog)
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M password   use MD5 sum protection\n"
+	"    -m prefix/len prefix and length to use for MD5 key\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
 	"\n"
@@ -1642,6 +1689,10 @@ int main(int argc, char *argv[])
 		case 'M':
 			args.password = optarg;
 			break;
+		case 'm':
+			if (convert_addr(&args, optarg, ADDR_TYPE_MD5_PREFIX) < 0)
+				return 1;
+			break;
 		case 'S':
 			args.use_setsockopt = 1;
 			break;
@@ -1706,11 +1757,16 @@ int main(int argc, char *argv[])
 	}
 
 	if (args.password &&
-	    (!args.has_remote_ip || args.type != SOCK_STREAM)) {
+	    ((!args.has_remote_ip && !args.prefix_len) || args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
+	if (args.prefix_len && !args.password) {
+		log_error("Prefix range for MD5 protection specified without a password\n");
+		return 1;
+	}
+
 	if ((args.use_setsockopt || args.use_cmsg) && !args.ifindex) {
 		fprintf(stderr, "Device binding not specified\n");
 		return 1;
-- 
2.11.0

