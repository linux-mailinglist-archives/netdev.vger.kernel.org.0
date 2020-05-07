Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0121C9A8A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgEGTMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726641AbgEGTMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:12:21 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C782FC05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 12:12:19 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a83so6843785qkc.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 12:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+LkKfoLPt4UR9jXEXfVxy/DY1LYZPfN4AZqflaKGMq4=;
        b=g9OnJYCm5/a6ZSdIeQsERYn42J9iTspqG1xOVqaCQP8Dg/4jH9Gyu85vTwDCri1wFT
         8R7Ow2+pldb3+5ib0bfZjTxateuUL+9MjV0rgrox5aB8jabw322mj1KbEITBeYPyvTtS
         b7vAbLs2u1rOJOyUc+XmYVdVxLmZRijdiQOKTwUaH/QNMTrAhr8+XqD+MozqM0AoFmwU
         GoiTI4nbqRvbxLNgcyRdzIPk/QWqBHHj4P00uSRzlxbOQFzHsU8FTQH1nVXWFQw1Dy5b
         88nLa60tkoSY1szOKEQRpej+jZcYWSbRtmYb8rWRkfQ90VZ5dckJIYxN9hlQP7sNq1J5
         fugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+LkKfoLPt4UR9jXEXfVxy/DY1LYZPfN4AZqflaKGMq4=;
        b=IgNSkSZSh1IG0fBjMX1DWXu+2lWbX2U+AJSoB9RrNZke10oeWJq913Y/XTmDmj0lgy
         GFhsFgjzZxYGW4mzKP4hTHnD5rHIKvlJ/ioE0KiPBg0goy+xYJm+zGp2Zjw037l43+tz
         C6wz2T1zodBJqauePN7MBLannfXg0+Vg3KuraNZpEDNpngcKhNmZXA1lvUThR5i6R0NF
         av9tDFbbMUnfTXLm/ZADpoiNXXba1KvYJAmhLnPcxdYWfhFPo/0FESTdRR+isDi0dtwW
         /mh8BzQNlAuV+nR6JXuLoAX19N72FLYlYz5YOHvHNynLZFehlChdMchMcFY0y8ywO1dM
         DCbQ==
X-Gm-Message-State: AGi0PuZOs7xfa7keYu9/hJxEgHjOZVPAt8xzKBkcu8TEsuTSAjRcOG97
        +XQMcQp0AtDkLDLV2WrxEmnMuUOsnyQgjSST0XHpFXGR/7KACT4FQXb/UmQZjoObApvlj5RZj8e
        9NdZqvUViTrgK1ss8T1+hOkfYMJvrdf5UsEmCen44wYY/pSG0uTc8tg==
X-Google-Smtp-Source: APiQypLWYgLhmqhA+l4DmOapcaQzCtwA8MCKwXJeiV1nlNiOWrISDuQn/1sVpqLZdcsPvzOqL4K4L1U=
X-Received: by 2002:ad4:4a27:: with SMTP id n7mr15342663qvz.80.1588878738825;
 Thu, 07 May 2020 12:12:18 -0700 (PDT)
Date:   Thu,  7 May 2020 12:12:12 -0700
In-Reply-To: <20200507191215.248860-1-sdf@google.com>
Message-Id: <20200507191215.248860-2-sdf@google.com>
Mime-Version: 1.0
References: <20200507191215.248860-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v4 1/4] selftests/bpf: generalize helpers to control
 background listener
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the following routines that let us start a background listener
thread and connect to a server by fd to the test_prog:
* start_server - socket+bind+listen
* connect_to_fd - connect to the server identified by fd

These will be used in the next commit.

Also, extend these helpers to support AF_INET6 and accept the family
as an argument.

v4:
* export extra helper to start server without a thread (Martin KaFai Lau)
* tcp_rtt is no longer starting background thread (Martin KaFai Lau)

v2:
* put helpers into network_helpers.c (Andrii Nakryiko)

Cc: Andrey Ignatov <rdna@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/network_helpers.c |  86 +++++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  10 ++
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 116 +-----------------
 4 files changed, 101 insertions(+), 113 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/network_helpers.c
 create mode 100644 tools/testing/selftests/bpf/network_helpers.h

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3d942be23d09..8f25966b500b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -354,7 +354,7 @@ endef
 TRUNNER_TESTS_DIR := prog_tests
 TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
-			 flow_dissector_load.h
+			 network_helpers.c flow_dissector_load.h
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
new file mode 100644
index 000000000000..8ea2b045452e
--- /dev/null
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <errno.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/err.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+
+#include "network_helpers.h"
+
+#define clean_errno() (errno == 0 ? "None" : strerror(errno))
+#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
+	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
+
+int start_server(int family, int type)
+{
+	struct sockaddr_storage addr = {};
+	socklen_t len;
+	int fd;
+
+	if (family == AF_INET) {
+		struct sockaddr_in *sin = (void *)&addr;
+
+		sin->sin_family = AF_INET;
+		len = sizeof(*sin);
+	} else {
+		struct sockaddr_in6 *sin6 = (void *)&addr;
+
+		sin6->sin6_family = AF_INET6;
+		len = sizeof(*sin6);
+	}
+
+	fd = socket(family, type | SOCK_NONBLOCK, 0);
+	if (fd < 0) {
+		log_err("Failed to create server socket");
+		return -1;
+	}
+
+	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
+		log_err("Failed to bind socket");
+		close(fd);
+		return -1;
+	}
+
+	if (type == SOCK_STREAM) {
+		if (listen(fd, 1) < 0) {
+			log_err("Failed to listed on socket");
+			close(fd);
+			return -1;
+		}
+	}
+
+	return fd;
+}
+
+int connect_to_fd(int family, int type, int server_fd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd;
+
+	fd = socket(family, type, 0);
+	if (fd < 0) {
+		log_err("Failed to create client socket");
+		return -1;
+	}
+
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get server addr");
+		goto out;
+	}
+
+	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
+		log_err("Fail to connect to server with family %d", family);
+		goto out;
+	}
+
+	return fd;
+
+out:
+	close(fd);
+	return -1;
+}
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
new file mode 100644
index 000000000000..30068eacc1a2
--- /dev/null
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NETWORK_HELPERS_H
+#define __NETWORK_HELPERS_H
+#include <sys/socket.h>
+#include <sys/types.h>
+
+int start_server(int family, int type);
+int connect_to_fd(int family, int type, int server_fd);
+
+#endif
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index e56b52ab41da..9013a0c01eed 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include "cgroup_helpers.h"
+#include "network_helpers.h"
 
 struct tcp_rtt_storage {
 	__u32 invoked;
@@ -87,34 +88,6 @@ static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
 	return err;
 }
 
-static int connect_to_server(int server_fd)
-{
-	struct sockaddr_storage addr;
-	socklen_t len = sizeof(addr);
-	int fd;
-
-	fd = socket(AF_INET, SOCK_STREAM, 0);
-	if (fd < 0) {
-		log_err("Failed to create client socket");
-		return -1;
-	}
-
-	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
-		log_err("Failed to get server addr");
-		goto out;
-	}
-
-	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
-		log_err("Fail to connect to server");
-		goto out;
-	}
-
-	return fd;
-
-out:
-	close(fd);
-	return -1;
-}
 
 static int run_test(int cgroup_fd, int server_fd)
 {
@@ -145,7 +118,7 @@ static int run_test(int cgroup_fd, int server_fd)
 		goto close_bpf_object;
 	}
 
-	client_fd = connect_to_server(server_fd);
+	client_fd = connect_to_fd(AF_INET, SOCK_STREAM, server_fd);
 	if (client_fd < 0) {
 		err = -1;
 		goto close_bpf_object;
@@ -180,103 +153,22 @@ static int run_test(int cgroup_fd, int server_fd)
 	return err;
 }
 
-static int start_server(void)
-{
-	struct sockaddr_in addr = {
-		.sin_family = AF_INET,
-		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
-	};
-	int fd;
-
-	fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
-	if (fd < 0) {
-		log_err("Failed to create server socket");
-		return -1;
-	}
-
-	if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
-		log_err("Failed to bind socket");
-		close(fd);
-		return -1;
-	}
-
-	return fd;
-}
-
-static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
-static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
-static volatile bool server_done = false;
-
-static void *server_thread(void *arg)
-{
-	struct sockaddr_storage addr;
-	socklen_t len = sizeof(addr);
-	int fd = *(int *)arg;
-	int client_fd;
-	int err;
-
-	err = listen(fd, 1);
-
-	pthread_mutex_lock(&server_started_mtx);
-	pthread_cond_signal(&server_started);
-	pthread_mutex_unlock(&server_started_mtx);
-
-	if (CHECK_FAIL(err < 0)) {
-		perror("Failed to listed on socket");
-		return ERR_PTR(err);
-	}
-
-	while (true) {
-		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
-		if (client_fd == -1 && errno == EAGAIN) {
-			usleep(50);
-			continue;
-		}
-		break;
-	}
-	if (CHECK_FAIL(client_fd < 0)) {
-		perror("Failed to accept client");
-		return ERR_PTR(err);
-	}
-
-	while (!server_done)
-		usleep(50);
-
-	close(client_fd);
-
-	return NULL;
-}
-
 void test_tcp_rtt(void)
 {
 	int server_fd, cgroup_fd;
-	pthread_t tid;
-	void *server_res;
 
 	cgroup_fd = test__join_cgroup("/tcp_rtt");
 	if (CHECK_FAIL(cgroup_fd < 0))
 		return;
 
-	server_fd = start_server();
+	server_fd = start_server(AF_INET, SOCK_STREAM);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 
-	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
-				      (void *)&server_fd)))
-		goto close_server_fd;
-
-	pthread_mutex_lock(&server_started_mtx);
-	pthread_cond_wait(&server_started, &server_started_mtx);
-	pthread_mutex_unlock(&server_started_mtx);
-
 	CHECK_FAIL(run_test(cgroup_fd, server_fd));
 
-	server_done = true;
-	CHECK_FAIL(pthread_join(tid, &server_res));
-	CHECK_FAIL(IS_ERR(server_res));
-
-close_server_fd:
 	close(server_fd);
+
 close_cgroup_fd:
 	close(cgroup_fd);
 }
-- 
2.26.2.526.g744177e7f7-goog

