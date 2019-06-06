Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED5637B89
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbfFFRwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:52:05 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:47941 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbfFFRwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:52:05 -0400
Received: by mail-pl1-f202.google.com with SMTP id 59so1925321plb.14
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 10:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6oUp316SzqDKsPiapGS/VDivwhOjdFgQsSgfP9uTe2w=;
        b=LfSyxbWuDo/4FnG4aeRkPmr3WC+H0NbWJ/iKQC0/+207qg/MEaeVuwprcWzt+Tt3k4
         9Qscs53Sko6QXGAwwfmpf9T3LGjUXE/PzEjTLfQUG7AL0lmROB11I/W8pI2cAWq6BNf/
         vUNw7336cIpxW/Rzp1CsoLhtp/8nCTof8vW8TCH29NO4NzhpvDbEggL1h7zQ+jgzeein
         SKNq+VNCrpEPrUx+l+9DPDlz55OicKIzXX6nQBj8xUn+9PHEm8arGqNj0eT6vvjgyrHN
         pumbibq67rTXIaeToYQsJ6hIQp5JzlO9fgQjtvXO2fnhPUls8mrOt486SkyIqHQinDPO
         1CFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6oUp316SzqDKsPiapGS/VDivwhOjdFgQsSgfP9uTe2w=;
        b=qyMH0wZaL8PpIeHn1gpDy2vv6jKTmOsiDjcnOKb5Ecax5Y0CzaiB7eeem7vXoZGFrf
         wWNKq1Ow6Gsm2h9dsyyE4w6l5K5av+YuvC0HXHaTSv9p22vOa0M1afaMMMxRUciPqIRR
         rv8eyVV56qIODGF/euDPFZ2do+NfKXB8HTrbVm98Ky6ffu5GDHgXS51mcQfyjlDhWoUu
         P+g6tKD7p6N5ePvxzJbRwMVwhFUrajdqVzzd5+tl3qd3Jfq9qX3a0G40DQyGSENV1v97
         zmTRn5XQO9TdXZVh74RNEyTA25gDW1JY1YSfFRCVQHUI0Gadi1+DiXMEQCpq6qP0HT1Q
         VdJg==
X-Gm-Message-State: APjAAAWrFBsAErNzsdaTwJ+XEV+UaIpqC0g/Aze87xqGsTKv+ylChi19
        iLwNp7WIrBV1NUNFFQsWlObFkLjkEWzw5qoSoQ5nRs/lRb9p1CackF0XOyKhXW+FaYNxl684SEx
        yq2tpW40r9vfWaU1M6y8T/g+wD9etXVP2hU9jnRJX0YPE8U75HgctAw==
X-Google-Smtp-Source: APXvYqygRckqGROVxXvQdIyPrpsKGUs+1D+LGI/LKyFFLfCa0odRCdB5Qoi4k6sQPskqICNMufrrnNY=
X-Received: by 2002:a63:b00e:: with SMTP id h14mr4350012pgf.321.1559843523461;
 Thu, 06 Jun 2019 10:52:03 -0700 (PDT)
Date:   Thu,  6 Jun 2019 10:51:44 -0700
In-Reply-To: <20190606175146.205269-1-sdf@google.com>
Message-Id: <20190606175146.205269-7-sdf@google.com>
Mime-Version: 1.0
References: <20190606175146.205269-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next v2 6/8] selftests/bpf: add sockopt test that
 exercises sk helpers
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

socktop test that introduces new SOL_CUSTOM sockopt level and
stores whatever users sets in sk storage. Whenever getsockopt
is called, the original value is retrieved.

v2:
* new test

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  77 +++++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 156 ++++++++++++++++++
 4 files changed, 236 insertions(+), 1 deletion(-)
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
index b982393b9181..9c167bd5ac18 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
 	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_sockopt
+	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -102,6 +102,7 @@ $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(OUTPUT)/test_sockopt: cgroup_helpers.c
+$(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
new file mode 100644
index 000000000000..fcd48647dcd1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+#define SOL_CUSTOM			0xdeadbeef
+
+struct socket_storage {
+	__u8 val;
+};
+
+struct bpf_map_def SEC("maps") socket_storage_map = {
+	.type = BPF_MAP_TYPE_SK_STORAGE,
+	.key_size = sizeof(int),
+	.value_size = sizeof(struct socket_storage),
+	.map_flags = BPF_F_NO_PREALLOC,
+};
+BPF_ANNOTATE_KV_PAIR(socket_storage_map, int, struct socket_storage);
+
+SEC("cgroup/getsockopt")
+int _getsockopt(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = (__u8 *)(long)ctx->optval_end;
+	__u8 *optval = (__u8 *)(long)ctx->optval;
+	struct socket_storage *storage;
+	struct bpf_sock *sk;
+
+	sk = bpf_sk_fullsock(ctx->sk);
+	if (!sk)
+		return 0; /* EPERM, deny for non-full sockets */
+
+	if (ctx->level != SOL_CUSTOM)
+		return 0; /* EPERM, deny everything except custom level */
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 0; /* EPERM, couldn't get sk storage */
+
+	optval[0] = storage->val;
+	ctx->optlen = 1;
+
+	return 2; /* bypass kernel */
+}
+
+SEC("cgroup/setsockopt")
+int _setsockopt(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = (__u8 *)(long)ctx->optval_end;
+	__u8 *optval = (__u8 *)(long)ctx->optval;
+	struct socket_storage *storage;
+	struct bpf_sock *sk;
+
+	sk = bpf_sk_fullsock(ctx->sk);
+	if (!sk)
+		return 0; /* EPERM, deny for non-full sockets */
+
+	if (ctx->level != SOL_CUSTOM)
+		return 0; /* EPERM, deny everything except custom level */
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 0; /* EPERM, couldn't get sk storage */
+
+	storage->val = optval[0];
+
+	return 2; /* bypass kernel */
+}
diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testing/selftests/bpf/test_sockopt_sk.c
new file mode 100644
index 000000000000..1acc055f94ac
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt_sk.c
@@ -0,0 +1,156 @@
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
+	char buf[4] = { 0x01, 0x00, 0x00, 0x00 };
+	socklen_t optlen;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (fd < 0) {
+		log_err("Failed to create socket");
+		return -1;
+	}
+
+	err = setsockopt(fd, SOL_IP, IP_TOS, buf, 1);
+	if (!err || errno != EPERM) {
+		log_err("Unexpected success from setsockopt");
+		goto err;
+	}
+
+	err = setsockopt(fd, SOL_CUSTOM, 0, buf, 1);
+	if (err) {
+		log_err("Failed to call setsockopt");
+		goto err;
+	}
+
+	buf[0] = 0;
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
2.22.0.rc1.311.g5d7573a151-goog

