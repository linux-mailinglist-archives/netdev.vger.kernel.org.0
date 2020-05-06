Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA321C7D65
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 00:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgEFWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 18:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729114AbgEFWcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 18:32:15 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F238C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 15:32:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 11so3444548qkh.7
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 15:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NJbOrBzYBPShSxY9fL3n/BK+8YUN1Mz7RXyop+p7IdQ=;
        b=qVLqEHzMU6zFxezlMYUthOuvQvQfp9BhizS+Njay3y1jjUl/VbiICDLpUnmQ7r4kLc
         HFWrnUkP2YLR2u4jeVULDTp0an/H28NxQc2Wj3lQrUcFm+bSfqg/J7dH+EitiYRAswhd
         26EuzR7MVi8RasrOifNcvoxb1eaGCm7Y+cABTklxBhAalpf2Vpq54w8kQOiHcPM1ncxx
         g0hNJEf3QvzShggNA6L03ikOLmJxwusIIVGSNDaUbar+PKvvkwkvbAXjJX5BIAEDoAUQ
         yC36U6ZcGPg6B9Sar9A/uiERjXllzREEg3UzV6s6wIg6Dg2grMtK0znYmniLcNoa3TRy
         k96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NJbOrBzYBPShSxY9fL3n/BK+8YUN1Mz7RXyop+p7IdQ=;
        b=VkHN7PkdwxRRRDn58xCRhILcUQNz2Xv3Hgzvpw18rXoehNNnZBnFq1shJhGYpLZ04q
         Pcq4cmnskpQmR6WXWOdwVUvRzAgMC2T13MC6Mv4FB+dGRDieLK3627BzfQ6UVwQK9oI7
         Y7M9Pma3N3lpR4pJ7VrLZo4DQjlQjvEuMIXNNDfzXxm0TiIW4GA5gQMWtCdrHk4E0edP
         v1iJQQT3ePgfP5kBiu7zBr2S2rST1gS7sbf/UGog7L1PIQOmlwwUbwGmxLkraDnfnJC2
         ZkO3K6iTpWoYmagE/iqwLCboOhoZevzWGJUJ/PI5HvGb3I7MBhxm8FRQt4cfCWD6bWY/
         vulw==
X-Gm-Message-State: AGi0PuZyzULHas+HS51lsXhrTr3d+Ji01QG15igVA9VtSXf1v85dNwDo
        Wz5rxmd5hDQkKaDF0P0Of1S7rE0v4S4Lgj373CxszFacheaEVa5Z9PHpHBnnFcNq0R9lDF/gQ7A
        e8yYDqT5gD30AEBY5ZdC95Xv8lY2MJzphgzFuSTO0no+H8HJOEsx3Xw==
X-Google-Smtp-Source: APiQypJEn0NKV9bXSsgOZxfLbZXC9L54wg+tBrOV+ctyQt4J5fpnZxn/oRSNCTfcaYdKOf/zDZA3SZo=
X-Received: by 2002:a0c:8b48:: with SMTP id d8mr10885752qvc.195.1588804333347;
 Wed, 06 May 2020 15:32:13 -0700 (PDT)
Date:   Wed,  6 May 2020 15:32:06 -0700
In-Reply-To: <20200506223210.93595-1-sdf@google.com>
Message-Id: <20200506223210.93595-2-sdf@google.com>
Mime-Version: 1.0
References: <20200506223210.93595-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v3 1/5] selftests/bpf: generalize helpers to control
 background listener
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the following routines that let us start a background listener
thread and connect to a server by fd to the test_prog:
* start_server_thread - start background INADDR_ANY thread
* stop_server_thread - stop the thread
* connect_to_fd - connect to the server identified by fd

These will be used in the next commit.

Also, extend these helpers to support AF_INET6 and accept the family
as an argument.

v3:
* export extra helper to start server without a thread (Martin KaFai Lau)

v2:
* put helpers into network_helpers.c (Andrii Nakryiko)

Cc: Andrey Ignatov <rdna@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/network_helpers.c | 164 ++++++++++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  12 ++
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 116 +------------
 4 files changed, 181 insertions(+), 113 deletions(-)
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
index 000000000000..6ad16dfebfb2
--- /dev/null
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -0,0 +1,164 @@
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
+#define CHECK_FAIL(condition) ({					\
+	int __ret = !!(condition);					\
+	int __save_errno = errno;					\
+	if (__ret) {							\
+		fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);	\
+	}								\
+	errno = __save_errno;						\
+	__ret;								\
+})
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
+static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
+static volatile bool server_done;
+pthread_t server_tid;
+
+static void *server_thread(void *arg)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd = *(int *)arg;
+	int client_fd;
+
+	pthread_mutex_lock(&server_started_mtx);
+	pthread_cond_signal(&server_started);
+	pthread_mutex_unlock(&server_started_mtx);
+
+	while (true) {
+		client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+		if (client_fd == -1 && errno == EAGAIN) {
+			usleep(50);
+			continue;
+		}
+		break;
+	}
+	if (CHECK_FAIL(client_fd < 0)) {
+		perror("Failed to accept client");
+		return ERR_PTR(-1);
+	}
+
+	while (!server_done)
+		usleep(50);
+
+	close(client_fd);
+
+	return NULL;
+}
+
+int start_server_thread(int family, int type)
+{
+	int fd = start_server(family, type);
+
+	if (fd < 0)
+		return -1;
+
+	if (CHECK_FAIL(pthread_create(&server_tid, NULL, server_thread,
+				      (void *)&fd)))
+		goto err;
+
+	pthread_mutex_lock(&server_started_mtx);
+	pthread_cond_wait(&server_started, &server_started_mtx);
+	pthread_mutex_unlock(&server_started_mtx);
+
+	return fd;
+err:
+	close(fd);
+	return -1;
+}
+
+void stop_server_thread(int fd)
+{
+	void *server_res;
+
+	server_done = true;
+	CHECK_FAIL(pthread_join(server_tid, &server_res));
+	CHECK_FAIL(IS_ERR(server_res));
+	close(fd);
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
index 000000000000..4ed31706b7f4
--- /dev/null
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NETWORK_HELPERS_H
+#define __NETWORK_HELPERS_H
+#include <sys/socket.h>
+#include <sys/types.h>
+
+int start_server(int family, int type);
+int start_server_thread(int family, int type);
+void stop_server_thread(int fd);
+int connect_to_fd(int family, int type, int server_fd);
+
+#endif
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index e56b52ab41da..4aaa1e6e33ad 100644
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
+	server_fd = start_server_thread(AF_INET, SOCK_STREAM);
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
+	stop_server_thread(server_fd);
 
-close_server_fd:
-	close(server_fd);
 close_cgroup_fd:
 	close(cgroup_fd);
 }
-- 
2.26.2.526.g744177e7f7-goog

