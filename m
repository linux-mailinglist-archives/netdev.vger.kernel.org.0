Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD472A1A0A
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgJaSwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbgJaSwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:52:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140E7C0617A6;
        Sat, 31 Oct 2020 11:52:20 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g12so7585110pgm.8;
        Sat, 31 Oct 2020 11:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=dZJpKnHtm08e7iEpqARoWphXgn85rOzARx2Y/aULXH0=;
        b=a519gQCOC9BTubF+E5U9ZEMSShdZH1M0MELR/Rv7kv3JEm9cCDz59sYrJC9w35YU+n
         ts8XA5FRqy33/mJv2jl69sP1SAmN+sDn4fMCtuVudQLz8Tl8Fpv2Dv5dm0c/r6XBhv3v
         w59WdVLoaWPxFj1ndMkIShFDWk+ZiWXWTxAmlPcwDDIeuCVbrWOoYDFUjRZNi5SAuVzn
         +wtwT8OAtPKX5GoLWrBVyZkKYq4dMweSInOey96VRisi4KtSv1wySCTi6DdVJX2hlkSW
         WkOllJTbZq/GnveT4wVy9VTAxfXxJa+EHu9Mp+RAc3OKhl0tWQs56lEb370OHZRg7paL
         bD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dZJpKnHtm08e7iEpqARoWphXgn85rOzARx2Y/aULXH0=;
        b=kGO1M8gHJas+62CnJm9peOL8SSySfz9HVP+4zFcXjFFoBOMVR1zi8wkf+XTQDxB3Zy
         +b05+CfjAzklMMOVYCuDoImBFPYUx9mURaKN5Jg/DVj9+0yII0NSp1MOMTYUQ8KOHD1h
         d4qbka8C3a0tQ//qG/l9GlgzIWL2iNEgT6Qcq/R/7CRLwq4o8yscCwUNYvAUGyVhADI2
         +wp6pZgB3V2PJs17eYIWIdrL1VmkQZyElBdGB0hhQ1JrQeMa/JfT8dmKCGViLdVkJBnE
         SF6Oa7axLS76o8uVl1LCcVxJFfEGxgv7pu0shCpnNmPZ3/sx+ktdw9NRfy8W/Q7XpURp
         vdDw==
X-Gm-Message-State: AOAM531fboTKZlKrFrmXWAotml6I6eygaSlrMNkSojP8yOhKQ7c8A7hg
        ot7CE5nm9Wi8yiKnwblR+qg=
X-Google-Smtp-Source: ABdhPJyAxtboTr1vDTySDOzG054RB4GzFQnKrN6K3ZnnGuEdJ6xSCEB4BZfOZoNCi0wJLWxNHEYbfA==
X-Received: by 2002:a63:1865:: with SMTP id 37mr7495501pgy.322.1604170339434;
        Sat, 31 Oct 2020 11:52:19 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id t32sm9063632pgl.0.2020.10.31.11.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:52:18 -0700 (PDT)
Subject: [bpf-next PATCH v2 2/5] selftests/bpf: Drop python client/server in
 favor of threads
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Sat, 31 Oct 2020 11:52:18 -0700
Message-ID: <160417033818.2823.4460428938483935516.stgit@localhost.localdomain>
In-Reply-To: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Drop the tcp_client/server.py files in favor of using a client and server
thread within the test case. Specifically we spawn a new thread to play the
role of the server, and the main testing thread plays the role of client.

Add logic to the end of the run_test function to guarantee that the sockets
are closed when we begin verifying results.

Doing this we are able to reduce overhead since we don't have two python
workers possibly floating around. In addition we don't have to worry about
synchronization issues and as such the retry loop waiting for the threads
to close the sockets can be dropped as we will have already closed the
sockets in the local executable and synchronized the server thread.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   96 ++++++++++++++++----
 tools/testing/selftests/bpf/tcp_client.py          |   50 ----------
 tools/testing/selftests/bpf/tcp_server.py          |   80 -----------------
 3 files changed, 78 insertions(+), 148 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 54f1dce97729..17d4299435df 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <inttypes.h>
 #include <test_progs.h>
+#include <network_helpers.h>
 
 #include "test_tcpbpf.h"
 
+#define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-user-test"
 
-/* 3 comes from one listening socket + both ends of the connection */
-#define EXPECTED_CLOSE_EVENTS		3
+static __u32 duration;
 
 #define EXPECT_EQ(expected, actual, fmt)			\
 	do {							\
@@ -42,7 +43,9 @@ int verify_result(const struct tcpbpf_globals *result)
 	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
 	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
 	EXPECT_EQ(1, result->num_listen, PRIu32);
-	EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
+
+	/* 3 comes from one listening socket + both ends of the connection */
+	EXPECT_EQ(3, result->num_close_events, PRIu32);
 
 	return ret;
 }
@@ -66,6 +69,75 @@ int verify_sockopt_result(int sock_map_fd)
 	return ret;
 }
 
+static int run_test(void)
+{
+	int listen_fd = -1, cli_fd = -1, accept_fd = -1;
+	char buf[1000];
+	int err = -1;
+	int i;
+
+	listen_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
+	if (CHECK(listen_fd == -1, "start_server", "listen_fd:%d errno:%d\n",
+		  listen_fd, errno))
+		goto done;
+
+	cli_fd = connect_to_fd(listen_fd, 0);
+	if (CHECK(cli_fd == -1, "connect_to_fd(listen_fd)",
+		  "cli_fd:%d errno:%d\n", cli_fd, errno))
+		goto done;
+
+	accept_fd = accept(listen_fd, NULL, NULL);
+	if (CHECK(accept_fd == -1, "accept(listen_fd)",
+		  "accept_fd:%d errno:%d\n", accept_fd, errno))
+		goto done;
+
+	/* Send 1000B of '+'s from cli_fd -> accept_fd */
+	for (i = 0; i < 1000; i++)
+		buf[i] = '+';
+
+	err = send(cli_fd, buf, 1000, 0);
+	if (CHECK(err != 1000, "send(cli_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
+
+	err = recv(accept_fd, buf, 1000, 0);
+	if (CHECK(err != 1000, "recv(accept_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
+
+	/* Send 500B of '.'s from accept_fd ->cli_fd */
+	for (i = 0; i < 500; i++)
+		buf[i] = '.';
+
+	err = send(accept_fd, buf, 500, 0);
+	if (CHECK(err != 500, "send(accept_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
+
+	err = recv(cli_fd, buf, 500, 0);
+	if (CHECK(err != 500, "recv(cli_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
+
+	/*
+	 * shutdown accept first to guarantee correct ordering for
+	 * bytes_received and bytes_acked when we go to verify the results.
+	 */
+	shutdown(accept_fd, SHUT_WR);
+	err = recv(cli_fd, buf, 1, 0);
+	if (CHECK(err, "recv(cli_fd) for fin", "err:%d errno:%d\n", err, errno))
+		goto done;
+
+	shutdown(cli_fd, SHUT_WR);
+	err = recv(accept_fd, buf, 1, 0);
+	CHECK(err, "recv(accept_fd) for fin", "err:%d errno:%d\n", err, errno);
+done:
+	if (accept_fd != -1)
+		close(accept_fd);
+	if (cli_fd != -1)
+		close(cli_fd);
+	if (listen_fd != -1)
+		close(listen_fd);
+
+	return err;
+}
+
 void test_tcpbpf_user(void)
 {
 	const char *file = "test_tcpbpf_kern.o";
@@ -74,7 +146,6 @@ void test_tcpbpf_user(void)
 	int error = EXIT_FAILURE;
 	struct bpf_object *obj;
 	int cg_fd = -1;
-	int retry = 10;
 	__u32 key = 0;
 	int rv;
 
@@ -94,11 +165,6 @@ void test_tcpbpf_user(void)
 		goto err;
 	}
 
-	if (system("./tcp_server.py")) {
-		fprintf(stderr, "FAILED: TCP server\n");
-		goto err;
-	}
-
 	map_fd = bpf_find_map(__func__, obj, "global_map");
 	if (map_fd < 0)
 		goto err;
@@ -107,21 +173,15 @@ void test_tcpbpf_user(void)
 	if (sock_map_fd < 0)
 		goto err;
 
-retry_lookup:
+	if (run_test())
+		goto err;
+
 	rv = bpf_map_lookup_elem(map_fd, &key, &g);
 	if (rv != 0) {
 		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
 		goto err;
 	}
 
-	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
-		fprintf(stderr,
-			"Unexpected number of close events (%d), retrying!\n",
-			g.num_close_events);
-		usleep(100);
-		goto retry_lookup;
-	}
-
 	if (verify_result(&g)) {
 		fprintf(stderr, "FAILED: Wrong stats\n");
 		goto err;
diff --git a/tools/testing/selftests/bpf/tcp_client.py b/tools/testing/selftests/bpf/tcp_client.py
deleted file mode 100755
index bfff82be3fc1..000000000000
--- a/tools/testing/selftests/bpf/tcp_client.py
+++ /dev/null
@@ -1,50 +0,0 @@
-#!/usr/bin/env python3
-#
-# SPDX-License-Identifier: GPL-2.0
-#
-
-import sys, os, os.path, getopt
-import socket, time
-import subprocess
-import select
-
-def read(sock, n):
-    buf = b''
-    while len(buf) < n:
-        rem = n - len(buf)
-        try: s = sock.recv(rem)
-        except (socket.error) as e: return b''
-        buf += s
-    return buf
-
-def send(sock, s):
-    total = len(s)
-    count = 0
-    while count < total:
-        try: n = sock.send(s)
-        except (socket.error) as e: n = 0
-        if n == 0:
-            return count;
-        count += n
-    return count
-
-
-serverPort = int(sys.argv[1])
-
-# create active socket
-sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
-try:
-    sock.connect(('::1', serverPort))
-except socket.error as e:
-    sys.exit(1)
-
-buf = b''
-n = 0
-while n < 1000:
-    buf += b'+'
-    n += 1
-
-sock.settimeout(1);
-n = send(sock, buf)
-n = read(sock, 500)
-sys.exit(0)
diff --git a/tools/testing/selftests/bpf/tcp_server.py b/tools/testing/selftests/bpf/tcp_server.py
deleted file mode 100755
index 42ab8882f00f..000000000000
--- a/tools/testing/selftests/bpf/tcp_server.py
+++ /dev/null
@@ -1,80 +0,0 @@
-#!/usr/bin/env python3
-#
-# SPDX-License-Identifier: GPL-2.0
-#
-
-import sys, os, os.path, getopt
-import socket, time
-import subprocess
-import select
-
-def read(sock, n):
-    buf = b''
-    while len(buf) < n:
-        rem = n - len(buf)
-        try: s = sock.recv(rem)
-        except (socket.error) as e: return b''
-        buf += s
-    return buf
-
-def send(sock, s):
-    total = len(s)
-    count = 0
-    while count < total:
-        try: n = sock.send(s)
-        except (socket.error) as e: n = 0
-        if n == 0:
-            return count;
-        count += n
-    return count
-
-
-SERVER_PORT = 12877
-MAX_PORTS = 2
-
-serverPort = SERVER_PORT
-serverSocket = None
-
-# create passive socket
-serverSocket = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
-
-try: serverSocket.bind(('::1', 0))
-except socket.error as msg:
-    print('bind fails: ' + str(msg))
-
-sn = serverSocket.getsockname()
-serverPort = sn[1]
-
-cmdStr = ("./tcp_client.py %d &") % (serverPort)
-os.system(cmdStr)
-
-buf = b''
-n = 0
-while n < 500:
-    buf += b'.'
-    n += 1
-
-serverSocket.listen(MAX_PORTS)
-readList = [serverSocket]
-
-while True:
-    readyRead, readyWrite, inError = \
-        select.select(readList, [], [], 2)
-
-    if len(readyRead) > 0:
-        waitCount = 0
-        for sock in readyRead:
-            if sock == serverSocket:
-                (clientSocket, address) = serverSocket.accept()
-                address = str(address[0])
-                readList.append(clientSocket)
-            else:
-                sock.settimeout(1);
-                s = read(sock, 1000)
-                n = send(sock, buf)
-                sock.close()
-                serverSocket.close()
-                sys.exit(0)
-    else:
-        print('Select timeout!')
-        sys.exit(1)


