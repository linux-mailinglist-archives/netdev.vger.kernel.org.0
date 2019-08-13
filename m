Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA4F8BE7E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfHMQ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:26:45 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:51465 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbfHMQ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:26:44 -0400
Received: by mail-pl1-f202.google.com with SMTP id p9so4209805pls.18
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3r0eGXMwKmmnTZqIRfJVO18PL+/2mGjDXdNa18xnfDU=;
        b=D0i4KObJ0KrhjWrEoVMzWyNYb8b5dFo3wVbRDAo6EZ7lqo+Ngrsii/NFfUBu7qvN5f
         ZXOU96uGDFnp73X9FTnS3bQtk83Ps0viRZiqlEdY7z8o6AIfpyXeywCtE9BjzggNeSE7
         D+epJ5KkSVlNOzenoveRIg6km3+exZNTv3jS+kkNT72VvnuvwuvcpDt4FZ73eubavRA1
         7Xxru89w3ZmQIrTfbRKPo9eZhkus3mPVAB5+FI4KfdMv6tcRTgNZiNw/h6Gv0qrPdsfu
         L2iT3QPs78ixLzViHAAqKGX0VPRGQDjfDMcoM4qnQMvuAZKp30kIiX37Vlqj6ypV8cIH
         be3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3r0eGXMwKmmnTZqIRfJVO18PL+/2mGjDXdNa18xnfDU=;
        b=IJ1p64Q7s9vuNqnhbVtwjRFvXF7eIGlvKeSxx+pcV/lWnNDXTN3msb7Sb+YYr+W/si
         of8c4YolOB53hoHYr34BZRvGWD4hD90pG+rz/tWEAkeIsNpzCrFRnPnXxPS5Y1zW7YGd
         3kUyxdYW70PGghBP5NZhOdvMss7pDnX5lmF50ZHqjbNj9TUhnxxttJX3dqw9NZrNryzD
         MplXlPp3jHcvzncwIhR9kXMqN7K4XYRh0c28lqea8VR9uo9vjLEkuxu8yn8KBuFd73jI
         eNYhGRjSzKPsg6dxyjtOtNI8JPsgvG4pQzX6Mz21QRSahYpp8vJyk29/KBHGLlsjISr0
         50aQ==
X-Gm-Message-State: APjAAAXFHIWDsp5ZVu1QMBnsHJFF8vb6nYI7oyYFZOSLd//MAz+/0pyU
        6SzwVK6c4wjEb+yFmgLzoq2RqQG10DkopVKuBrevbRoOj5Qskf+dHDk1u6OpQXRF0OEvp5uPT5m
        xfnDHjtnyKTQUbnLvIRMFKzNBiQ1AuILNWkuUHEoah59iKlezDl5fzg==
X-Google-Smtp-Source: APXvYqwosFcN1XV6N6twsmj3KRFzEY+c3KZTYjhccDRzRqQovbT2wBgopyBsn5DyMyutV7bD7vzriyw=
X-Received: by 2002:a65:464d:: with SMTP id k13mr31452627pgr.99.1565713603421;
 Tue, 13 Aug 2019 09:26:43 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:26:30 -0700
In-Reply-To: <20190813162630.124544-1-sdf@google.com>
Message-Id: <20190813162630.124544-5-sdf@google.com>
Mime-Version: 1.0
References: <20190813162630.124544-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v3 4/4] selftests/bpf: add sockopt clone/inheritance test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that calls setsockopt on the listener socket which triggers
BPF program. This BPF program writes to the sk storage and sets
clone flag. Make sure that sk storage is cloned for a newly
accepted connection.

We have two cloned maps in the tests to make sure we hit both cases
in bpf_sk_storage_clone: first element (sk_storage_alloc) and
non-first element(s) (selem_link_map).

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/sockopt_inherit.c     |  97 +++++++
 .../selftests/bpf/test_sockopt_inherit.c      | 253 ++++++++++++++++++
 4 files changed, 353 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 90f70d2c7c22..60c9338cd9b4 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -42,4 +42,5 @@ xdping
 test_sockopt
 test_sockopt_sk
 test_sockopt_multi
+test_sockopt_inherit
 test_tcp_rtt
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3bd0f4a0336a..c875763a851a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
-	test_sockopt_multi test_tcp_rtt
+	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -110,6 +110,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(OUTPUT)/test_sockopt: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
+$(OUTPUT)/test_sockopt_inherit: cgroup_helpers.c
 $(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
 
 .PHONY: force
diff --git a/tools/testing/selftests/bpf/progs/sockopt_inherit.c b/tools/testing/selftests/bpf/progs/sockopt_inherit.c
new file mode 100644
index 000000000000..dede0fcd6102
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/sockopt_inherit.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+#define SOL_CUSTOM			0xdeadbeef
+#define CUSTOM_INHERIT1			0
+#define CUSTOM_INHERIT2			1
+#define CUSTOM_LISTENER			2
+
+struct sockopt_inherit {
+	__u8 val;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC | BPF_F_CLONE);
+	__type(key, int);
+	__type(value, struct sockopt_inherit);
+} cloned1_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC | BPF_F_CLONE);
+	__type(key, int);
+	__type(value, struct sockopt_inherit);
+} cloned2_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct sockopt_inherit);
+} listener_only_map SEC(".maps");
+
+static __inline struct sockopt_inherit *get_storage(struct bpf_sockopt *ctx)
+{
+	if (ctx->optname == CUSTOM_INHERIT1)
+		return bpf_sk_storage_get(&cloned1_map, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE);
+	else if (ctx->optname == CUSTOM_INHERIT2)
+		return bpf_sk_storage_get(&cloned2_map, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE);
+	else
+		return bpf_sk_storage_get(&listener_only_map, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE);
+}
+
+SEC("cgroup/getsockopt")
+int _getsockopt(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = ctx->optval_end;
+	struct sockopt_inherit *storage;
+	__u8 *optval = ctx->optval;
+
+	if (ctx->level != SOL_CUSTOM)
+		return 1; /* only interested in SOL_CUSTOM */
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	storage = get_storage(ctx);
+	if (!storage)
+		return 0; /* EPERM, couldn't get sk storage */
+
+	ctx->retval = 0; /* Reset system call return value to zero */
+
+	optval[0] = storage->val;
+	ctx->optlen = 1;
+
+	return 1;
+}
+
+SEC("cgroup/setsockopt")
+int _setsockopt(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = ctx->optval_end;
+	struct sockopt_inherit *storage;
+	__u8 *optval = ctx->optval;
+
+	if (ctx->level != SOL_CUSTOM)
+		return 1; /* only interested in SOL_CUSTOM */
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	storage = get_storage(ctx);
+	if (!storage)
+		return 0; /* EPERM, couldn't get sk storage */
+
+	storage->val = optval[0];
+	ctx->optlen = -1;
+
+	return 1;
+}
diff --git a/tools/testing/selftests/bpf/test_sockopt_inherit.c b/tools/testing/selftests/bpf/test_sockopt_inherit.c
new file mode 100644
index 000000000000..1bf699815b9b
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt_inherit.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <error.h>
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <pthread.h>
+
+#include <linux/filter.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+#include "cgroup_helpers.h"
+
+#define CG_PATH				"/sockopt_inherit"
+#define SOL_CUSTOM			0xdeadbeef
+#define CUSTOM_INHERIT1			0
+#define CUSTOM_INHERIT2			1
+#define CUSTOM_LISTENER			2
+
+static int connect_to_server(int server_fd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
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
+		log_err("Fail to connect to server");
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
+static int verify_sockopt(int fd, int optname, const char *msg, char expected)
+{
+	socklen_t optlen = 1;
+	char buf = 0;
+	int err;
+
+	err = getsockopt(fd, SOL_CUSTOM, optname, &buf, &optlen);
+	if (err) {
+		log_err("%s: failed to call getsockopt", msg);
+		return 1;
+	}
+
+	printf("%s %d: got=0x%x ? expected=0x%x\n", msg, optname, buf, expected);
+
+	if (buf != expected) {
+		log_err("%s: unexpected getsockopt value %d != %d", msg,
+			buf, expected);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void *server_thread(void *arg)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd = *(int *)arg;
+	int client_fd;
+	int err = 0;
+
+	if (listen(fd, 1) < 0)
+		error(1, errno, "Failed to listed on socket");
+
+	err += verify_sockopt(fd, CUSTOM_INHERIT1, "listen", 1);
+	err += verify_sockopt(fd, CUSTOM_INHERIT2, "listen", 1);
+	err += verify_sockopt(fd, CUSTOM_LISTENER, "listen", 1);
+
+	client_fd = accept(fd, (struct sockaddr *)&addr, &len);
+	if (client_fd < 0)
+		error(1, errno, "Failed to accept client");
+
+	err += verify_sockopt(client_fd, CUSTOM_INHERIT1, "accept", 1);
+	err += verify_sockopt(client_fd, CUSTOM_INHERIT2, "accept", 1);
+	err += verify_sockopt(client_fd, CUSTOM_LISTENER, "accept", 0);
+
+	close(client_fd);
+
+	return (void *)(long)err;
+}
+
+static int start_server(void)
+{
+	struct sockaddr_in addr = {
+		.sin_family = AF_INET,
+		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
+	};
+	char buf;
+	int err;
+	int fd;
+	int i;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("Failed to create server socket");
+		return -1;
+	}
+
+	for (i = CUSTOM_INHERIT1; i <= CUSTOM_LISTENER; i++) {
+		buf = 0x01;
+		err = setsockopt(fd, SOL_CUSTOM, i, &buf, 1);
+		if (err) {
+			log_err("Failed to call setsockopt(%d)", i);
+			close(fd);
+			return -1;
+		}
+	}
+
+	if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
+		log_err("Failed to bind socket");
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static int prog_attach(struct bpf_object *obj, int cgroup_fd, const char *title)
+{
+	enum bpf_attach_type attach_type;
+	enum bpf_prog_type prog_type;
+	struct bpf_program *prog;
+	int err;
+
+	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type);
+	if (err) {
+		log_err("Failed to deduct types for %s BPF program", title);
+		return -1;
+	}
+
+	prog = bpf_object__find_program_by_title(obj, title);
+	if (!prog) {
+		log_err("Failed to find %s BPF program", title);
+		return -1;
+	}
+
+	err = bpf_prog_attach(bpf_program__fd(prog), cgroup_fd,
+			      attach_type, 0);
+	if (err) {
+		log_err("Failed to attach %s BPF program", title);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int run_test(int cgroup_fd)
+{
+	struct bpf_prog_load_attr attr = {
+		.file = "./sockopt_inherit.o",
+	};
+	int server_fd = -1, client_fd;
+	struct bpf_object *obj;
+	void *server_err;
+	pthread_t tid;
+	int ignored;
+	int err;
+
+	err = bpf_prog_load_xattr(&attr, &obj, &ignored);
+	if (err) {
+		log_err("Failed to load BPF object");
+		return -1;
+	}
+
+	err = prog_attach(obj, cgroup_fd, "cgroup/getsockopt");
+	if (err)
+		goto close_bpf_object;
+
+	err = prog_attach(obj, cgroup_fd, "cgroup/setsockopt");
+	if (err)
+		goto close_bpf_object;
+
+	server_fd = start_server();
+	if (server_fd < 0) {
+		err = -1;
+		goto close_bpf_object;
+	}
+
+	pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
+
+	client_fd = connect_to_server(server_fd);
+	if (client_fd < 0) {
+		err = -1;
+		goto close_server_fd;
+	}
+
+	err += verify_sockopt(client_fd, CUSTOM_INHERIT1, "connect", 0);
+	err += verify_sockopt(client_fd, CUSTOM_INHERIT2, "connect", 0);
+	err += verify_sockopt(client_fd, CUSTOM_LISTENER, "connect", 0);
+
+	pthread_join(tid, &server_err);
+
+	err += (int)(long)server_err;
+
+	close(client_fd);
+
+close_server_fd:
+	close(server_fd);
+close_bpf_object:
+	bpf_object__close(obj);
+	return err;
+}
+
+int main(int args, char **argv)
+{
+	int cgroup_fd;
+	int err = EXIT_SUCCESS;
+
+	if (setup_cgroup_environment())
+		return err;
+
+	cgroup_fd = create_and_get_cgroup(CG_PATH);
+	if (cgroup_fd < 0)
+		goto cleanup_cgroup_env;
+
+	if (join_cgroup(CG_PATH))
+		goto cleanup_cgroup;
+
+	if (run_test(cgroup_fd))
+		err = EXIT_FAILURE;
+
+	printf("test_sockopt_inherit: %s\n",
+	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
+
+cleanup_cgroup:
+	close(cgroup_fd);
+cleanup_cgroup_env:
+	cleanup_cgroup_environment();
+	return err;
+}
-- 
2.23.0.rc1.153.gdeed80330f-goog

