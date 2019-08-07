Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0108A8503A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 17:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388773AbfHGPrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 11:47:35 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:45794 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388769AbfHGPre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 11:47:34 -0400
Received: by mail-pl1-f201.google.com with SMTP id y9so52674418plp.12
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 08:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M6byKaHGe26X/impW6A8TxjPi6g1ymIHGY4QV6eTCh4=;
        b=k30Q2TOVI1GypfzhO8/kRMrw3ZEZHYFmRXQ37t5ReYhmj+esCbwUgd+v8IoByf1zjJ
         rqTM/ZpsalZsNld+02ipkh9KQg8qaa2ptYletOHWLn0hF4vwUmVIzAViLNjrbOeErTjc
         G+p1EYMaCBQsI9/Y1NKKFJnB9aB+KpmC0apF0Xsv/NXKPAZV2tnoSZYSmlEJleGdQdX7
         R4F7lNuzsqonYz0Lcch0OFZwXnABYjKSAwcvTLwzqv1Jdqr5sxEwen2CDygoKa1b8yrZ
         aJOBPs/8Puy2v/LbIcQBYV3Eze9xF2yMbcVudF+nXyMNCssvYMDnNim+1ZI8L7WIP8IK
         xRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M6byKaHGe26X/impW6A8TxjPi6g1ymIHGY4QV6eTCh4=;
        b=UtRu6kSU/lg1GGOmelaDxkS0+pT5izYcD0qtqEkbmyGteysHuLiYJF5xPLLJh2XtXB
         ALbYDLeAe6hA2MeEV6pF0qncw+yLDfNh61HpXpD5nWep1tZJMCOMmSvE455mNcM70x6E
         YuEpgbZvY3YA1OVZnRi6+OcRMLW9pvemsorMKWElQpPGPtLpkWvjNYHJD5ws3SEbldpA
         U+1KzDYaM/axgrOvY+66H+0PkaHWrZlEHbseDFAz8WiDwb8cVhYWKA18KqkFeDxDD5CZ
         VlPLQaQd/DQMic2CC/CZb9ZxcYsEt5PxLIvVKiBCWeAhAGc44OUWKUMgk5mq6B1pQgFP
         ov+w==
X-Gm-Message-State: APjAAAWXDSdOI0XqFHuTAe8wLSoDIaRJb/rRTWwjFE4LkCyo/NkNp9Bq
        MGm/K8B+RMUEgG7pqSaOzCwysD77vPTbmanTVYSGzn4OjBR1Kvnm9vLAsqozgEA/57DSSMiBW5A
        weWjxBZUXR07mMzwA159iAaFBKcTYNUI7To701UhNy/i8k62BOnK1mQ==
X-Google-Smtp-Source: APXvYqyzlX3p7cqR6r1Jd9XayXiZVH2yvozGZa1rOmQMUwPh+ve0yMgtlMsRNsFORKydULoldtI3XZs=
X-Received: by 2002:a63:d301:: with SMTP id b1mr8148611pgg.379.1565192853566;
 Wed, 07 Aug 2019 08:47:33 -0700 (PDT)
Date:   Wed,  7 Aug 2019 08:47:20 -0700
In-Reply-To: <20190807154720.260577-1-sdf@google.com>
Message-Id: <20190807154720.260577-4-sdf@google.com>
Mime-Version: 1.0
References: <20190807154720.260577-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next 3/3] selftests/bpf: add sockopt clone/inheritance test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
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
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/sockopt_inherit.c     | 102 +++++++
 .../selftests/bpf/test_sockopt_inherit.c      | 252 ++++++++++++++++++
 4 files changed, 357 insertions(+), 1 deletion(-)
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
index 000000000000..357fc9db5874
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/sockopt_inherit.c
@@ -0,0 +1,102 @@
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
+struct bpf_map_def SEC("maps") cloned1_map = {
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct sockopt_inherit),
+	.map_flags = BPF_F_NO_PREALLOC,
+};
+BPF_ANNOTATE_KV_PAIR(cloned1_map, int, struct sockopt_inherit);
+
+struct bpf_map_def SEC("maps") cloned2_map = {
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct sockopt_inherit),
+	.map_flags = BPF_F_NO_PREALLOC,
+};
+BPF_ANNOTATE_KV_PAIR(cloned2_map, int, struct sockopt_inherit);
+
+struct bpf_map_def SEC("maps") listener_map = {
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct sockopt_inherit),
+	.map_flags = BPF_F_NO_PREALLOC,
+};
+BPF_ANNOTATE_KV_PAIR(listener_map, int, struct sockopt_inherit);
+
+static __inline struct sockopt_inherit *get_storage(struct bpf_sockopt *ctx)
+{
+	if (ctx->optname == CUSTOM_INHERIT1)
+		return bpf_sk_storage_get(&cloned1_map, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE |
+					  BPF_SK_STORAGE_GET_F_CLONE);
+	else if (ctx->optname == CUSTOM_INHERIT2)
+		return bpf_sk_storage_get(&cloned2_map, ctx->sk, 0,
+					  BPF_SK_STORAGE_GET_F_CREATE |
+					  BPF_SK_STORAGE_GET_F_CLONE);
+	else
+		return bpf_sk_storage_get(&listener_map, ctx->sk, 0,
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
index 000000000000..e47b9c28d743
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt_inherit.c
@@ -0,0 +1,252 @@
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
+	log_err("%s %d: got=0x%x ? expected=0x%x", msg, optname, buf, expected);
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
+		goto close_bpf_object;
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
+close_bpf_object:
+	bpf_object__close(obj);
+	close(server_fd);
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
2.22.0.770.g0f2c4a37fd-goog

