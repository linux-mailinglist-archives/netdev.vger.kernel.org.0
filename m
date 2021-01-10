Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183B02F0487
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbhAJATj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbhAJATi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:19:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C7B423A01;
        Sun, 10 Jan 2021 00:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237938;
        bh=XSNvpuXX/43Px+JSR9m1SXDrGyusm6n3pqBeVNn5AWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDLNHbwip8rDA0EAYC94/jghFD7FGDCGWIyKbnqGfV5aa5Yat899Ie6hVDwxQLDHB
         WQ5uDEmxQSnGvKLD1Jg1AScVb3/wYzTu746cSIQIxrPd4QBmTLQhENI5FkKEdEoqlH
         EgSYScU7w5hSJz2eW8m202Z+2Ct+xcRZEa3Jo/X+dOk/EYw7B3cKeBDMcaZzI15iFt
         ffmp0082Dtm5Lc5L3wP+IGDjrxrPAql+sqEkcZuUuitXP01qh0pXjVqyriA6fzTf+K
         83Hdg4epOJCR/c56sD2VxFPGPyR3JIAw0aMFPZvCArZsgjgfjlJJa83XxaivTrtUWu
         HoxHpWiC0MSLQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v2 04/11] selftests: Add options to set network namespace to nettest
Date:   Sat,  9 Jan 2021 17:18:45 -0700
Message-Id: <20210110001852.35653-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210110001852.35653-1-dsahern@kernel.org>
References: <20210110001852.35653-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add options to specify server and client network namespace to
use before running respective functions.

Signed-off-by: Seth David Schoen <schoen@loyalty.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 56 ++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 3b083fad3577..cc9635b6461f 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 #include <sys/ioctl.h>
 #include <sys/socket.h>
+#include <sys/wait.h>
 #include <linux/tcp.h>
 #include <arpa/inet.h>
 #include <net/if.h>
@@ -17,6 +18,7 @@
 #include <fcntl.h>
 #include <libgen.h>
 #include <limits.h>
+#include <sched.h>
 #include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -34,6 +36,8 @@
 
 #define DEFAULT_PORT 12345
 
+#define NS_PREFIX "/run/netns/"
+
 #ifndef MAX
 #define MAX(a, b)  ((a) > (b) ? (a) : (b))
 #endif
@@ -77,6 +81,9 @@ struct sock_args {
 	const char *dev;
 	int ifindex;
 
+	const char *clientns;
+	const char *serverns;
+
 	const char *password;
 	/* prefix for MD5 password */
 	const char *md5_prefix_str;
@@ -213,6 +220,27 @@ static void log_address(const char *desc, struct sockaddr *sa)
 	fflush(stdout);
 }
 
+static int switch_ns(const char *ns)
+{
+	char path[PATH_MAX];
+	int fd, ret;
+
+	if (geteuid())
+		log_error("warning: likely need root to set netns %s!\n", ns);
+
+	snprintf(path, sizeof(path), "%s%s", NS_PREFIX, ns);
+	fd = open(path, 0);
+	if (fd < 0) {
+		log_err_errno("Failed to open netns path; can not switch netns");
+		return 1;
+	}
+
+	ret = setns(fd, CLONE_NEWNET);
+	close(fd);
+
+	return ret;
+}
+
 static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args)
 {
 	int keylen = strlen(args->password);
@@ -1377,6 +1405,15 @@ static int do_server(struct sock_args *args)
 	fd_set rfds;
 	int rc;
 
+	if (args->serverns) {
+		if (switch_ns(args->serverns)) {
+			log_error("Could not set server netns to %s\n",
+				  args->serverns);
+			return 1;
+		}
+		log_msg("Switched server netns\n");
+	}
+
 	if (resolve_devices(args) || validate_addresses(args))
 		return 1;
 
@@ -1565,6 +1602,15 @@ static int do_client(struct sock_args *args)
 		return 1;
 	}
 
+	if (args->clientns) {
+		if (switch_ns(args->clientns)) {
+			log_error("Could not set client netns to %s\n",
+				  args->clientns);
+			return 1;
+		}
+		log_msg("Switched client netns\n");
+	}
+
 	if (resolve_devices(args) || validate_addresses(args))
 		return 1;
 
@@ -1642,7 +1688,7 @@ static char *random_msg(int len)
 	return m;
 }
 
-#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:m:d:SCi6L:0:1:2:Fbq"
+#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:m:d:N:O:SCi6L:0:1:2:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1656,6 +1702,8 @@ static void print_usage(char *prog)
 	"    -t            timeout seconds (default: none)\n"
 	"\n"
 	"Optional:\n"
+	"    -N ns         set client to network namespace ns (requires root)\n"
+	"    -O ns         set server to network namespace ns (requires root)\n"
 	"    -F            Restart server loop\n"
 	"    -6            IPv6 (default is IPv4)\n"
 	"    -P proto      protocol for socket: icmp, ospf (default: none)\n"
@@ -1757,6 +1805,12 @@ int main(int argc, char *argv[])
 		case 'n':
 			iter = atoi(optarg);
 			break;
+		case 'N':
+			args.clientns = optarg;
+			break;
+		case 'O':
+			args.serverns = optarg;
+			break;
 		case 'L':
 			msg = random_msg(atoi(optarg));
 			break;
-- 
2.24.3 (Apple Git-128)

