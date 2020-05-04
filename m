Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D031C42ED
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgEDReg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbgEDRef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:34:35 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8370C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:34:34 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 30so19769699qkp.21
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BDtpxMOHMu29VlDCmhk8Jml8cnhXkmsBBTxOcB7wsx8=;
        b=WwLQiw0xH7zc6Vjn+vdpz5+ChyW2zcVg8uEBZwX8mpm5wzQSB4ZrWh3zrCgEIeqEzz
         FbQV639dGmTzgmyipQLgurTjayr0uD/3tDdi+XYXcDvkdnl+0wx+DE9LQLk+F3M9iRAF
         SGWgexWtI9hPIVBhZlDwmNLo6wz9zVGg+gLBE1HKiBiZ6zCg6NnZR2aIz6NMqw411JTa
         Spg26LZgLJlfMVTQveJcMn7FtA7AE7M9Ja41qYkrDKNbOjCb3cBLAHkgYs/wJkdFmTBQ
         /rQf+r+jVLwK/T0pN2QIEkFLkW19wd6wCShCLYPfRWi4DFUqykEBSmYyi3Fkp4VKKDkg
         WnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BDtpxMOHMu29VlDCmhk8Jml8cnhXkmsBBTxOcB7wsx8=;
        b=R/beYdxr6cjuLw7v9lxaieTyVKgH5kuvtzguLpwikAsIiFZKwIXYZwygzjq7IhGP0O
         4O85SOHbQ/Y1B6ZlT8Dvp+uWj2K/jfLUBgXfQhyikdbJsTx8FqL9QCQGefuby10JfLHn
         ouTHiRYnV4awL0qvC6Ets8aQxAi6Rh2goHg9ft1NR4FNfEuabnugXFa24BZdmJCxO2JO
         Rus+o3Wk+HWDQ2uiwJShspIR69VOsKw/L/cqdA+XOcPWEbwR9wvtN0MKIOShOObiuz+0
         d8Q61zokU/bK53YjeQrE38AiMvaXujFfsSHlun2DVm/IkDAWSVeFt76J1qU6hIisgxFE
         DVog==
X-Gm-Message-State: AGi0PuYBhfPvjBped2FiJQQi9WBCGaC73T8AeZm9eoMG7oeINUqDvmEO
        W0Ik1wROR/bzyubUN2yqkCOIzAgxSxYTiVYMiietred1/83rwqrCwYOUXhx5dxN6Z7G4gyOOGGs
        RdSBOZCS7OpedA6dKqlKTXNY0A6H7ivEsMWBWggdzbUBiYYnTUo52nw==
X-Google-Smtp-Source: APiQypKF5GaqCDIgzfBDsKDpSR2CJqMZ4bfXMEV1UQXqFgbfcp3afwSnU58XTGKUY5p1poUrR+lRsbU=
X-Received: by 2002:a05:6214:a0e:: with SMTP id dw14mr169886qvb.185.1588613673835;
 Mon, 04 May 2020 10:34:33 -0700 (PDT)
Date:   Mon,  4 May 2020 10:34:27 -0700
In-Reply-To: <20200504173430.6629-1-sdf@google.com>
Message-Id: <20200504173430.6629-2-sdf@google.com>
Mime-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next 1/4] selftests/bpf: generalize helpers to control
 backround listener
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
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

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 115 +--------------
 tools/testing/selftests/bpf/test_progs.c      | 138 ++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h      |   3 +
 3 files changed, 144 insertions(+), 112 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index e56b52ab41da..7d2b3b269b5f 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -87,34 +87,6 @@ static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
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
@@ -145,7 +117,7 @@ static int run_test(int cgroup_fd, int server_fd)
 		goto close_bpf_object;
 	}
 
-	client_fd = connect_to_server(server_fd);
+	client_fd = connect_to_fd(AF_INET, server_fd);
 	if (client_fd < 0) {
 		err = -1;
 		goto close_bpf_object;
@@ -180,103 +152,22 @@ static int run_test(int cgroup_fd, int server_fd)
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
+	server_fd = start_server_thread(AF_INET);
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
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 93970ec1c9e9..ebf1b3272848 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -371,6 +371,144 @@ void *spin_lock_thread(void *arg)
 	pthread_exit(arg);
 }
 
+static int start_server(int family)
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
+	fd = socket(family, SOCK_STREAM | SOCK_NONBLOCK, 0);
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
+	int err;
+
+	err = listen(fd, 1);
+
+	pthread_mutex_lock(&server_started_mtx);
+	pthread_cond_signal(&server_started);
+	pthread_mutex_unlock(&server_started_mtx);
+
+	if (CHECK_FAIL(err < 0)) {
+		perror("Failed to listed on socket");
+		return ERR_PTR(err);
+	}
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
+		return ERR_PTR(err);
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
+int start_server_thread(int family)
+{
+	int fd = start_server(family);
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
+int connect_to_fd(int family, int server_fd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd;
+
+	fd = socket(family, SOCK_STREAM, 0);
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
+
 /* extern declarations for test funcs */
 #define DEFINE_TEST(name) extern void test_##name(void);
 #include <prog_tests/tests.h>
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 10188cc8e9e0..363a3f2273a4 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -157,6 +157,9 @@ int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
 int extract_build_id(char *build_id, size_t size);
 void *spin_lock_thread(void *arg);
+int start_server_thread(int family);
+void stop_server_thread(int fd);
+int connect_to_fd(int family, int server_fd);
 
 #ifdef __x86_64__
 #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
-- 
2.26.2.526.g744177e7f7-goog

