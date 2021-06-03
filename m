Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F5539AE9B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhFCX0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:8114 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhFCX0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:30 -0400
IronPort-SDR: yuIgfWzdCgq4wJnYUpHleWxHOdoLYdr59eIj3ZWDGK1nik1FMPu1x1xbOFEuAD8XguBkkq/PqM
 wk60EgDAXedA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807813"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807813"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:44 -0700
IronPort-SDR: IoBk3vfl/ZSVuYUUPynlITzvPPcxIQBnju7qcAR9fZFa9kEAZwp1Idas8sBg5bXhaxjVcFo8za
 kZ+L7xMooN1Q==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669050"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/7] selftests: mptcp_connect: add SO_TIMESTAMPNS cmsg support
Date:   Thu,  3 Jun 2021 16:24:33 -0700
Message-Id: <20210603232433.260703-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This extends the existing setsockopt test case to also check for cmsg
timestamps.

mptcp_connect will abort/fail if the setockopt was passed but the
timestamp cmsg isn't present after successful recvmsg().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 125 +++++++++++++++++-
 .../selftests/net/mptcp/mptcp_sockopt.sh      |   4 +-
 2 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index d88e1fdfb147..89c4753c2760 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -6,6 +6,7 @@
 #include <limits.h>
 #include <fcntl.h>
 #include <string.h>
+#include <stdarg.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -25,6 +26,7 @@
 #include <netinet/in.h>
 
 #include <linux/tcp.h>
+#include <linux/time_types.h>
 
 extern int optind;
 
@@ -66,6 +68,13 @@ static unsigned int cfg_do_w;
 static int cfg_wait;
 static uint32_t cfg_mark;
 
+struct cfg_cmsg_types {
+	unsigned int cmsg_enabled:1;
+	unsigned int timestampns:1;
+};
+
+static struct cfg_cmsg_types cfg_cmsg_types;
+
 static void die_usage(void)
 {
 	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] [-m mode]"
@@ -80,11 +89,22 @@ static void die_usage(void)
 	fprintf(stderr, "\t-M mark -- set socket packet mark\n");
 	fprintf(stderr, "\t-u -- check mptcp ulp\n");
 	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
+	fprintf(stderr, "\t-c cmsg -- test cmsg type <cmsg>\n");
 	fprintf(stderr,
 		"\t-P [saveWithPeek|saveAfterPeek] -- save data with/after MSG_PEEK form tcp socket\n");
 	exit(1);
 }
 
+static void xerror(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+	exit(1);
+}
+
 static void handle_signal(int nr)
 {
 	quit = true;
@@ -338,6 +358,58 @@ static size_t do_write(const int fd, char *buf, const size_t len)
 	return offset;
 }
 
+static void process_cmsg(struct msghdr *msgh)
+{
+	struct __kernel_timespec ts;
+	bool ts_found = false;
+	struct cmsghdr *cmsg;
+
+	for (cmsg = CMSG_FIRSTHDR(msgh); cmsg ; cmsg = CMSG_NXTHDR(msgh, cmsg)) {
+		if (cmsg->cmsg_level == SOL_SOCKET && cmsg->cmsg_type == SO_TIMESTAMPNS_NEW) {
+			memcpy(&ts, CMSG_DATA(cmsg), sizeof(ts));
+			ts_found = true;
+			continue;
+		}
+	}
+
+	if (cfg_cmsg_types.timestampns) {
+		if (!ts_found)
+			xerror("TIMESTAMPNS not present\n");
+	}
+}
+
+static ssize_t do_recvmsg_cmsg(const int fd, char *buf, const size_t len)
+{
+	char msg_buf[8192];
+	struct iovec iov = {
+		.iov_base = buf,
+		.iov_len = len,
+	};
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_control = msg_buf,
+		.msg_controllen = sizeof(msg_buf),
+	};
+	int flags = 0;
+	int ret = recvmsg(fd, &msg, flags);
+
+	if (ret <= 0)
+		return ret;
+
+	if (msg.msg_controllen && !cfg_cmsg_types.cmsg_enabled)
+		xerror("got %lu bytes of cmsg data, expected 0\n",
+		       (unsigned long)msg.msg_controllen);
+
+	if (msg.msg_controllen == 0 && cfg_cmsg_types.cmsg_enabled)
+		xerror("%s\n", "got no cmsg data");
+
+	if (msg.msg_controllen)
+		process_cmsg(&msg);
+
+	return ret;
+}
+
 static ssize_t do_rnd_read(const int fd, char *buf, const size_t len)
 {
 	int ret = 0;
@@ -357,6 +429,8 @@ static ssize_t do_rnd_read(const int fd, char *buf, const size_t len)
 	} else if (cfg_peek == CFG_AFTER_PEEK) {
 		ret = recv(fd, buf, cap, MSG_PEEK);
 		ret = (ret < 0) ? ret : read(fd, buf, cap);
+	} else if (cfg_cmsg_types.cmsg_enabled) {
+		ret = do_recvmsg_cmsg(fd, buf, cap);
 	} else {
 		ret = read(fd, buf, cap);
 	}
@@ -786,6 +860,48 @@ static void init_rng(void)
 	srand(foo);
 }
 
+static void xsetsockopt(int fd, int level, int optname, const void *optval, socklen_t optlen)
+{
+	int err;
+
+	err = setsockopt(fd, level, optname, optval, optlen);
+	if (err) {
+		perror("setsockopt");
+		exit(1);
+	}
+}
+
+static void apply_cmsg_types(int fd, const struct cfg_cmsg_types *cmsg)
+{
+	static const unsigned int on = 1;
+
+	if (cmsg->timestampns)
+		xsetsockopt(fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW, &on, sizeof(on));
+}
+
+static void parse_cmsg_types(const char *type)
+{
+	char *next = strchr(type, ',');
+	unsigned int len = 0;
+
+	cfg_cmsg_types.cmsg_enabled = 1;
+
+	if (next) {
+		parse_cmsg_types(next + 1);
+		len = next - type;
+	} else {
+		len = strlen(type);
+	}
+
+	if (strncmp(type, "TIMESTAMPNS", len) == 0) {
+		cfg_cmsg_types.timestampns = 1;
+		return;
+	}
+
+	fprintf(stderr, "Unrecognized cmsg option %s\n", type);
+	exit(1);
+}
+
 int main_loop(void)
 {
 	int fd;
@@ -801,6 +917,8 @@ int main_loop(void)
 		set_rcvbuf(fd, cfg_rcvbuf);
 	if (cfg_sndbuf)
 		set_sndbuf(fd, cfg_sndbuf);
+	if (cfg_cmsg_types.cmsg_enabled)
+		apply_cmsg_types(fd, &cfg_cmsg_types);
 
 	return copyfd_io(0, fd, 1);
 }
@@ -887,7 +1005,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:hut:m:S:R:w:M:P:")) != -1) {
+	while ((c = getopt(argc, argv, "6jr:lp:s:hut:m:S:R:w:M:P:c:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
@@ -943,6 +1061,9 @@ static void parse_opts(int argc, char **argv)
 		case 'P':
 			cfg_peek = parse_peek(optarg);
 			break;
+		case 'c':
+			parse_cmsg_types(optarg);
+			break;
 		}
 	}
 
@@ -976,6 +1097,8 @@ int main(int argc, char *argv[])
 			set_sndbuf(fd, cfg_sndbuf);
 		if (cfg_mark)
 			set_mark(fd, cfg_mark);
+		if (cfg_cmsg_types.cmsg_enabled)
+			apply_cmsg_types(fd, &cfg_cmsg_types);
 
 		return main_loop_s(fd);
 	}
diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 2fa13946ac04..1579e471a5e7 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -178,7 +178,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
-			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} \
+			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} -c TIMESTAMPNS \
 				${local_addr} < "$sin" > "$sout" &
 	spid=$!
 
@@ -186,7 +186,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${connector_ns} \
-			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} \
+			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} -c TIMESTAMPNS \
 				$connect_addr < "$cin" > "$cout" &
 
 	cpid=$!
-- 
2.31.1

