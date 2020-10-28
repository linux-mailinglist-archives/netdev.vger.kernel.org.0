Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946CC29D46A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgJ1VwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgJ1VwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:52:00 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E01C0613CF;
        Wed, 28 Oct 2020 14:52:00 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id y10so261177vkl.5;
        Wed, 28 Oct 2020 14:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=YIOUqWyBZIfavDIAu4dN9j2zqYJXRubizG/6KqaU4Tc=;
        b=u7r1f/kzAgex8NQbV5A+cSGwPBWrxSgYHYVYq3UTXzrwJ4YU7nfo8dsp5WcVZcEfCI
         GulNQZmgev3dGGvhpv4oYCC464jFTl/7vW9BIQKFLSAQTmPT91nIdCkC6Nd+CADn8mPR
         2IIMGprRctKbhZzAVQgXCc+dNRPfaqGCwoS7cMqAW5UW16E6AsIOEyzJ9XRGxHXzUNVg
         toRtxgmDmA4xsib5NYUFPHkAZs3Rlh+KLhIbuGqzwOAAORcSc5F/NLpsEbMxu0P8C7kD
         w/4UfmzCkvd+K+HmcKsM9z5mcU5jRFdBATK99B/APFNKVp4sFORJlGIlbwq9dNIrTjru
         ks1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YIOUqWyBZIfavDIAu4dN9j2zqYJXRubizG/6KqaU4Tc=;
        b=mXpW5pYE8VcNoF1+rKje5RPHPvnTb/3gmv25vYvYadnmXthio5zpZjY2EKDywHzJGE
         F7/re78ognjxeQlwPCrdgX+idH1a72lzmIg2/K5rG8Wnlw5SBQ+DViUOj7y6W0oiRjpl
         ad7khHQLXPCS4X03PE3BTLsCod4br4+LzrjBhD72ehKo3hBahQcO+pB3NELXEXwwkhNl
         Cg5jyzBr/1arrAVX6rMlvqAcVmNwzflf1v2a/ed5Z7TAZteJZu01ZD7pAS6JGxFmFjeV
         5ZIjvauW/+BYb4agKckZE2Y/bT9ZAV4ad60PIQVKglbTXNj88BVpgn7PIVgw1vM2+GdK
         gC2g==
X-Gm-Message-State: AOAM531mACDltVVRkiuj+h5nXrFxU6YWUOvOnseUPFQs9TBmSn00sKbk
        8s2ZeFgWgRfK9B/F9aGZ15ytin2EsLjVkg==
X-Google-Smtp-Source: ABdhPJzoSPlqBzE395zc0+3gCtAIjluHEduOK2pyLmq6FNkdc50liDSOjjTgzYbtBsYk4mWYTOtnEA==
X-Received: by 2002:a0c:9e53:: with SMTP id z19mr5356512qve.23.1603849635467;
        Tue, 27 Oct 2020 18:47:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 185sm2080485qke.16.2020.10.27.18.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 18:47:14 -0700 (PDT)
Subject: [bpf-next PATCH 2/4] selftests/bpf: Drop python client/server in
 favor of threads
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com
Date:   Tue, 27 Oct 2020 18:47:13 -0700
Message-ID: <160384963313.698509.13129692731727238158.stgit@localhost.localdomain>
In-Reply-To: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
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

Doing this we are able to reduce overhead since we don't have two python
workers possibly floating around. In addition we don't have to worry about
synchronization issues and as such the retry loop waiting for the threads
to close the sockets can be dropped as we will have already closed the
sockets in the local executable and synchronized the server thread.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  125 +++++++++++++++++---
 tools/testing/selftests/bpf/tcp_client.py          |   50 --------
 tools/testing/selftests/bpf/tcp_server.py          |   80 -------------
 3 files changed, 107 insertions(+), 148 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 5becab8b04e3..71ab82e37eb7 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -1,14 +1,65 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <inttypes.h>
 #include <test_progs.h>
+#include <network_helpers.h>
 
 #include "test_tcpbpf.h"
 #include "cgroup_helpers.h"
 
+#define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-user-test"
 
-/* 3 comes from one listening socket + both ends of the connection */
-#define EXPECTED_CLOSE_EVENTS		3
+static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
+
+static void *server_thread(void *arg)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd = *(int *)arg;
+	char buf[1000];
+	int client_fd;
+	int err = 0;
+	int i;
+
+	err = listen(fd, 1);
+
+	pthread_mutex_lock(&server_started_mtx);
+	pthread_cond_signal(&server_started);
+	pthread_mutex_unlock(&server_started_mtx);
+
+	if (err < 0) {
+		perror("Failed to listen on socket");
+		err = errno;
+		goto err;
+	}
+
+	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+	if (client_fd < 0) {
+		perror("Failed to accept client");
+		err = errno;
+		goto err;
+	}
+
+	if (recv(client_fd, buf, 1000, 0) < 1000) {
+		perror("failed/partial recv");
+		err = errno;
+		goto out_clean;
+	}
+
+	for (i = 0; i < 500; i++)
+		buf[i] = '.';
+
+	if (send(client_fd, buf, 500, 0) < 500) {
+		perror("failed/partial send");
+		err = errno;
+		goto out_clean;
+	}
+out_clean:
+	close(client_fd);
+err:
+	return (void *)(long)err;
+}
 
 #define EXPECT_EQ(expected, actual, fmt)			\
 	do {							\
@@ -43,7 +94,9 @@ int verify_result(const struct tcpbpf_globals *result)
 	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
 	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
 	EXPECT_EQ(1, result->num_listen, PRIu32);
-	EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
+
+	/* 3 comes from one listening socket + both ends of the connection */
+	EXPECT_EQ(3, result->num_close_events, PRIu32);
 
 	return ret;
 }
@@ -67,6 +120,52 @@ int verify_sockopt_result(int sock_map_fd)
 	return ret;
 }
 
+static int run_test(void)
+{
+	int server_fd, client_fd;
+	void *server_err;
+	char buf[1000];
+	pthread_t tid;
+	int err = -1;
+	int i;
+
+	server_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		return err;
+
+	pthread_mutex_lock(&server_started_mtx);
+	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
+				      (void *)&server_fd)))
+		goto close_server_fd;
+
+	pthread_cond_wait(&server_started, &server_started_mtx);
+	pthread_mutex_unlock(&server_started_mtx);
+
+	client_fd = connect_to_fd(server_fd, 0);
+	if (client_fd < 0)
+		goto close_server_fd;
+
+	for (i = 0; i < 1000; i++)
+		buf[i] = '+';
+
+	if (CHECK_FAIL(send(client_fd, buf, 1000, 0) < 1000))
+		goto close_client_fd;
+
+	if (CHECK_FAIL(recv(client_fd, buf, 500, 0) < 500))
+		goto close_client_fd;
+
+	pthread_join(tid, &server_err);
+
+	err = (int)(long)server_err;
+	CHECK_FAIL(err);
+
+close_client_fd:
+	close(client_fd);
+close_server_fd:
+	close(server_fd);
+	return err;
+}
+
 void test_tcpbpf_user(void)
 {
 	const char *file = "test_tcpbpf_kern.o";
@@ -74,7 +173,6 @@ void test_tcpbpf_user(void)
 	struct tcpbpf_globals g = {0};
 	struct bpf_object *obj;
 	int cg_fd = -1;
-	int retry = 10;
 	__u32 key = 0;
 	int rv;
 
@@ -94,11 +192,6 @@ void test_tcpbpf_user(void)
 		goto err;
 	}
 
-	if (CHECK_FAIL(system("./tcp_server.py"))) {
-		fprintf(stderr, "FAILED: TCP server\n");
-		goto err;
-	}
-
 	map_fd = bpf_find_map(__func__, obj, "global_map");
 	if (CHECK_FAIL(map_fd < 0))
 		goto err;
@@ -107,21 +200,17 @@ void test_tcpbpf_user(void)
 	if (CHECK_FAIL(sock_map_fd < 0))
 		goto err;
 
-retry_lookup:
+	if (run_test()) {
+		fprintf(stderr, "FAILED: TCP server\n");
+		goto err;
+	}
+
 	rv = bpf_map_lookup_elem(map_fd, &key, &g);
 	if (CHECK_FAIL(rv != 0)) {
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
 	if (CHECK_FAIL(verify_result(&g))) {
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


