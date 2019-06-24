Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501185188A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731988AbfFXQYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:24:51 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:51013 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731838AbfFXQYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:49 -0400
Received: by mail-pg1-f202.google.com with SMTP id z35so6169282pgl.17
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7rzKhN92sRL4pCiMOcgJ+oVcqEO/hspYwJXUq7M/U/s=;
        b=oXWtiyNYExFz2bt+xZ3g2MT/csK/eR39Qy69PieQuJkedRJzeg5CpW7Gqb7tbzoeBZ
         uKgXuL8cE8gI1s82M23qrcCRw2HraT1tCqpCpulB6OSREwA15YZJJP71PSWRRr6QROz5
         fVsAiyUk8c8mFWAYQCWqv//pptb6HTX4xLhvs2Y9zILELnaMf7MrHZGPb5roP31z3UMH
         gcRBZU9ROaEzMbUzjhIYeeI+ZRPbkbpr6djqo58m/HIR6mqHroaq8Q0Ho6yyd7HOKWWA
         vdBE8r4Jjm/C0aLo2SaTBXB6gBVo8zhkvcEs4RYlljJS0Xoo+aCSKhVEWniFu2wdstPW
         iVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7rzKhN92sRL4pCiMOcgJ+oVcqEO/hspYwJXUq7M/U/s=;
        b=KELS38qtRtHz0Nd0v25d2gXuDePy+r9vKqFOJQaXcOIDv8GZCNy8EGXLBIIf8bNOZz
         Bt/bKFm+73F9qmFYqqLA6mfOi0g+WTgMTbJ4jQ004oBjZ0kGqsJQbwuVyDv3YlkkZ27z
         vhA9Rl7hSp1A0C0x9wCo7g6M35HSD3ITFJ+pcnTINJjyySPyz6+bdFi1M4sipMAgf1qo
         dyAeCXXMRoc87qhbtzB32mF7JQMlrI7+tUinLHSN/utknoTnXS/8ixIEB4RALYUR9p8Z
         hN1MBjlHdItSqtcMKx2QnMdRBy2q2muuH+vk4fBi5Jq9mhOF/d+EE1sJSEVGa48bC4nL
         ugjA==
X-Gm-Message-State: APjAAAVKbClKWpvjevzHdfkWbuWmVO1hoqnyii2pdB3Y/5Qd81fnqa0f
        d6PnUpGLDgXeirszKmnYee1bUoQ+jLeXDvaDVlV0HCax5llm6vMBxx+3WmZgaNvUuxBKvFkSG2M
        D2kgebKvOmro/9XBSzZySGxFPL5vyDB3xEz57Xu4Z1lR3w8tixJV5vQ==
X-Google-Smtp-Source: APXvYqyz7XtemhF9nJd7djzz0mpQZGc6rtJnMlyP4eK6Yu3B0z4lvpG0y48wHMoZrNBNGXjhzrxtpXE=
X-Received: by 2002:a63:2985:: with SMTP id p127mr31802709pgp.400.1561393488148;
 Mon, 24 Jun 2019 09:24:48 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:26 -0700
In-Reply-To: <20190624162429.16367-1-sdf@google.com>
Message-Id: <20190624162429.16367-7-sdf@google.com>
Mime-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 6/9] selftests/bpf: add sockopt test that
 exercises sk helpers
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

socktop test that introduces new SOL_CUSTOM sockopt level and
stores whatever users sets in sk storage. Whenever getsockopt
is called, the original value is retrieved.

v7:
* use retval=0 and optlen-1

v6:
* test 'ret=1' use-case as well (Alexei Starovoitov)

v4:
* don't call bpf_sk_fullsock helper

v3:
* drop (__u8 *)(long) casts for optval{,_end}

v2:
* new test

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  91 +++++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 185 ++++++++++++++++++
 4 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 3fe92601223d..8ac076c311d4 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -40,3 +40,4 @@ test_hashmap
 test_btf_dump
 xdping
 test_sockopt
+test_sockopt_sk
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index afd7b3d298d8..1210b4e98d27 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_sockopt
+	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -104,6 +104,7 @@ $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(OUTPUT)/test_sockopt: cgroup_helpers.c
+$(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
new file mode 100644
index 000000000000..ad4c5db2bc29
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <netinet/in.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+#define SOL_CUSTOM			0xdeadbeef
+
+struct sockopt_sk {
+	__u8 val;
+};
+
+struct bpf_map_def SEC("maps") socket_storage_map = {
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct sockopt_sk),
+	.map_flags = BPF_F_NO_PREALLOC,
+};
+BPF_ANNOTATE_KV_PAIR(socket_storage_map, int, struct sockopt_sk);
+
+SEC("cgroup/getsockopt")
+int _getsockopt(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = ctx->optval_end;
+	__u8 *optval = ctx->optval;
+	struct sockopt_sk *storage;
+
+	if (ctx->level == SOL_IP && ctx->optname == IP_TOS)
+		/* Not interested in SOL_IP:IP_TOS;
+		 * let next BPF program in the cgroup chain or kernel
+		 * handle it.
+		 */
+		return 1;
+
+	if (ctx->level != SOL_CUSTOM)
+		return 0; /* EPERM, deny everything except custom level */
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	storage = bpf_sk_storage_get(&socket_storage_map, ctx->sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 0; /* EPERM, couldn't get sk storage */
+
+	if (!ctx->retval)
+		return 0; /* EPERM, kernel should not have handled
+			   * SOL_CUSTOM, something is wrong!
+			   */
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
+	__u8 *optval = ctx->optval;
+	struct sockopt_sk *storage;
+
+	if (ctx->level == SOL_IP && ctx->optname == IP_TOS)
+		/* Not interested in SOL_IP:IP_TOS;
+		 * let next BPF program in the cgroup chain or kernel
+		 * handle it.
+		 */
+		return 1;
+
+	if (ctx->level != SOL_CUSTOM)
+		return 0; /* EPERM, deny everything except custom level */
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	storage = bpf_sk_storage_get(&socket_storage_map, ctx->sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 0; /* EPERM, couldn't get sk storage */
+
+	storage->val = optval[0];
+	ctx->optlen = -1; /* BPF has consumed this option, don't call kernel
+			   * setsockopt handler.
+			   */
+
+	return 1;
+}
diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testing/selftests/bpf/test_sockopt_sk.c
new file mode 100644
index 000000000000..67558e2c5427
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt_sk.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+
+#include <linux/filter.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+#include "cgroup_helpers.h"
+
+#define CG_PATH				"/sockopt"
+
+#define SOL_CUSTOM			0xdeadbeef
+
+static int getsetsockopt(void)
+{
+	int fd, err;
+	char buf[4] = {};
+	socklen_t optlen;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("Failed to create socket");
+		return -1;
+	}
+
+	/* IP_TOS - BPF bypass */
+
+	buf[0] = 0x08;
+	err = setsockopt(fd, SOL_IP, IP_TOS, buf, 1);
+	if (err) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto err;
+	}
+
+	buf[0] = 0x00;
+	optlen = 1;
+	err = getsockopt(fd, SOL_IP, IP_TOS, buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt(IP_TOS)");
+		goto err;
+	}
+
+	if (buf[0] != 0x08) {
+		log_err("Unexpected getsockopt(IP_TOS) buf[0] 0x%02x != 0x08",
+			buf[0]);
+		goto err;
+	}
+
+	/* IP_TTL - EPERM */
+
+	buf[0] = 1;
+	err = setsockopt(fd, SOL_IP, IP_TTL, buf, 1);
+	if (!err || errno != EPERM) {
+		log_err("Unexpected success from setsockopt(IP_TTL)");
+		goto err;
+	}
+
+	/* SOL_CUSTOM - handled by BPF */
+
+	buf[0] = 0x01;
+	err = setsockopt(fd, SOL_CUSTOM, 0, buf, 1);
+	if (err) {
+		log_err("Failed to call setsockopt");
+		goto err;
+	}
+
+	buf[0] = 0x00;
+	optlen = 4;
+	err = getsockopt(fd, SOL_CUSTOM, 0, buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt");
+		goto err;
+	}
+
+	if (optlen != 1) {
+		log_err("Unexpected optlen %d != 1", optlen);
+		goto err;
+	}
+	if (buf[0] != 0x01) {
+		log_err("Unexpected buf[0] 0x%02x != 0x01", buf[0]);
+		goto err;
+	}
+
+	close(fd);
+	return 0;
+err:
+	close(fd);
+	return -1;
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
+		.file = "./sockopt_sk.o",
+	};
+	struct bpf_object *obj;
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
+	err = getsetsockopt();
+
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
+		goto cleanup_obj;
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
+	printf("test_sockopt_sk: %s\n",
+	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
+
+cleanup_cgroup:
+	close(cgroup_fd);
+cleanup_cgroup_env:
+	cleanup_cgroup_environment();
+cleanup_obj:
+	return err;
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

