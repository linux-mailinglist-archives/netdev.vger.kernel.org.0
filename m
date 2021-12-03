Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A763467FF8
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383434AbhLCWjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:21 -0500
Received: from mga18.intel.com ([134.134.136.126]:46471 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383431AbhLCWjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940936"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940936"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185311"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/10] selftests: mptcp: check IP_TOS in/out are the same
Date:   Fri,  3 Dec 2021 14:35:38 -0800
Message-Id: <20211203223541.69364-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Check that getsockopt(IP_TOS) returns what setsockopt(IP_TOS) did set
right before.

Also check that socklen_t == 0 and -1 input values match those
of normal tcp sockets.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_sockopt.c       | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
index 417b11cafafe..ac9a4d9c1764 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
@@ -4,6 +4,7 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <limits.h>
 #include <string.h>
 #include <stdarg.h>
@@ -13,6 +14,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <strings.h>
+#include <time.h>
 #include <unistd.h>
 
 #include <sys/socket.h>
@@ -594,6 +596,44 @@ static int server(int pipefd)
 	return 0;
 }
 
+static void test_ip_tos_sockopt(int fd)
+{
+	uint8_t tos_in, tos_out;
+	socklen_t s;
+	int r;
+
+	tos_in = rand() & 0xfc;
+	r = setsockopt(fd, SOL_IP, IP_TOS, &tos_in, sizeof(tos_out));
+	if (r != 0)
+		die_perror("setsockopt IP_TOS");
+
+	tos_out = 0;
+	s = sizeof(tos_out);
+	r = getsockopt(fd, SOL_IP, IP_TOS, &tos_out, &s);
+	if (r != 0)
+		die_perror("getsockopt IP_TOS");
+
+	if (tos_in != tos_out)
+		xerror("tos %x != %x socklen_t %d\n", tos_in, tos_out, s);
+
+	if (s != 1)
+		xerror("tos should be 1 byte");
+
+	s = 0;
+	r = getsockopt(fd, SOL_IP, IP_TOS, &tos_out, &s);
+	if (r != 0)
+		die_perror("getsockopt IP_TOS 0");
+	if (s != 0)
+		xerror("expect socklen_t == 0");
+
+	s = -1;
+	r = getsockopt(fd, SOL_IP, IP_TOS, &tos_out, &s);
+	if (r != -1 && errno != EINVAL)
+		die_perror("getsockopt IP_TOS did not indicate -EINVAL");
+	if (s != -1)
+		xerror("expect socklen_t == -1");
+}
+
 static int client(int pipefd)
 {
 	int fd = -1;
@@ -611,6 +651,8 @@ static int client(int pipefd)
 		xerror("Unknown pf %d\n", pf);
 	}
 
+	test_ip_tos_sockopt(fd);
+
 	connect_one_server(fd, pipefd);
 
 	return 0;
@@ -642,6 +684,25 @@ static int rcheck(int wstatus, const char *what)
 	return 111;
 }
 
+static void init_rng(void)
+{
+	int fd = open("/dev/urandom", O_RDONLY);
+
+	if (fd >= 0) {
+		unsigned int foo;
+		ssize_t ret;
+
+		/* can't fail */
+		ret = read(fd, &foo, sizeof(foo));
+		assert(ret == sizeof(foo));
+
+		close(fd);
+		srand(foo);
+	} else {
+		srand(time(NULL));
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int e1, e2, wstatus;
@@ -650,6 +711,8 @@ int main(int argc, char *argv[])
 
 	parse_opts(argc, argv);
 
+	init_rng();
+
 	e1 = pipe(pipefds);
 	if (e1 < 0)
 		die_perror("pipe");
-- 
2.34.1

