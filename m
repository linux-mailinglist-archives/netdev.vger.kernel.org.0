Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7A148B2D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfFQSCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:02:03 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:45638 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfFQSCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:02:02 -0400
Received: by mail-pf1-f201.google.com with SMTP id i27so2864101pfk.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QOvCdMx8lS0T9jG22RJpZ/dXAJ7P9lLIIHx5Sw8+qPA=;
        b=Lvmzm3oGqaKwePBEbelirjw2EIIwVsJKYEmLipMzVsI8g3T+EM6N7D/mJtSYQwAlQo
         MXSVHUgXkUJQ4X03L8Nj1kzfr3VR537NrCOytiljw2fv68nZow/s8wDX2nMSvxeXon1k
         8IV9oG1W3czaulx/UpW63aJyN9FONL3WWQ9d4Uf/16jMSQTSzTlPSaF+ir2wIK3cuf4W
         fJ9rQzCEsdDVaCUOYFwahF7BtWQhXsua4MTHRwpJ/2Sn3v8HvqyWzq96QhKEI034Nmtm
         RlWEGENG5SiY87UybKhybPfW/OR/Sp8xgbw/XvwHvZlrIKVjiuM1N8x+b45L37jOn4r6
         IsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QOvCdMx8lS0T9jG22RJpZ/dXAJ7P9lLIIHx5Sw8+qPA=;
        b=aX3jqcv8oaP2ypqMZI8Rq16BQa6RMi0V0sYpY3m0KHzJ9PiMoeYYTu1WMTpDpSVuuD
         hItbAxrMsYIK91flpbPpS1Hgi2IkQYA+hNKSpU8mzJqz0iI8q2Y+j242ZiGSNNPHlOK2
         DMSwBixXLMjupL8Cb/p5meY0z5S0w51UM0ej2QaIt1VXihTuN9ll4v6RNFjk5RPd3k2D
         d63qJpWnenKLgapMc3HhZJntmc0h3sW6tQmTnXRuPL5qU9numae0hNy4MmhVtW8OWObV
         5Zwn1wgDNhYt+NiZ+qXByQKVdz1e4shPfIZaBY7/B7gQwH0HHiCd7yrTclVG973ZfKZX
         nMjQ==
X-Gm-Message-State: APjAAAUe+/iGihMyny4gAbKq6l+SjgLexqJqNFMw3gxr92dWri8m/6KV
        JC8M3qy7zcy9aDetLgs51/+is3b/r+PUmGyoP84UhB73QZGfcqa+lUk/UF5FVp9kEbsPiUOb5d+
        MjGoKxJGqOWeFKi37b47N5A1CVdoHoYFSMmQ07H0qWqSAcX8rbBTk+A==
X-Google-Smtp-Source: APXvYqy3ZCrpDaGw2Clm04piN+Ee8uk+X9b3ZsI76kj+DCWl9iF92edyBn6Ym4qWozYmiUzR0I6+WQ8=
X-Received: by 2002:a65:648e:: with SMTP id e14mr507pgv.317.1560794520074;
 Mon, 17 Jun 2019 11:02:00 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:01:07 -0700
In-Reply-To: <20190617180109.34950-1-sdf@google.com>
Message-Id: <20190617180109.34950-8-sdf@google.com>
Mime-Version: 1.0
References: <20190617180109.34950-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v6 7/9] selftests/bpf: add sockopt test that
 exercises BPF_F_ALLOW_MULTI
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sockopt test that verifies chaining behavior when 0/2 is returned.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/test_sockopt_multi.c        | 264 ++++++++++++++++++
 3 files changed, 268 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_multi.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 8ac076c311d4..a2f7f79c7908 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -41,3 +41,4 @@ test_btf_dump
 xdping
 test_sockopt
 test_sockopt_sk
+test_sockopt_multi
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 33aa4f97af28..d3a5b6f9080d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
 	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk
+	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
+	test_sockopt_multi
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -103,6 +104,7 @@ $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(OUTPUT)/test_sockopt: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
+$(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/test_sockopt_multi.c b/tools/testing/selftests/bpf/test_sockopt_multi.c
new file mode 100644
index 000000000000..e667d762e8d0
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt_multi.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <error.h>
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
+static char bpf_log_buf[BPF_LOG_BUF_SIZE];
+
+static struct bpf_insn prog_deny[] = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+};
+
+static struct bpf_insn prog_bypass[] = {
+	BPF_MOV64_IMM(BPF_REG_0, 2),
+	BPF_EXIT_INSN(),
+};
+
+static struct bpf_insn prog_inc[] = {
+	/* void *map_fd = NULL (to be filled by main()) */
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+
+	/* __u32 key = 0 */
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+	BPF_ST_MEM(BPF_W, BPF_REG_2, 0, 0),
+
+	/* r0 = bpf_map_lookup(map_fd, 0) */
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+		     BPF_FUNC_map_lookup_elem),
+	/* if (r0 != NULL) { */
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
+	/* *r0 += 1 */
+	BPF_MOV64_IMM(BPF_REG_1, 1),
+	BPF_STX_XADD(BPF_W, BPF_REG_0, BPF_REG_1, 0),
+	/* } */
+
+	/* return 1 */
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+};
+
+static int read_cnt(int map_fd)
+{
+	int key = 0;
+	int val;
+
+	if (bpf_map_lookup_elem(map_fd, &key, &val) < 0)
+		error(-1, errno, "Failed to lookup the map");
+
+	return val;
+}
+
+int main(int argc, char **argv)
+{
+	int prog_deny_fd = -1, prog_bypass_fd = -1, prog_inc_fd = -1;
+	struct bpf_load_program_attr load_attr = {};
+	int cg_a = -1, cg_a_b = -1;
+	int err = EXIT_FAILURE;
+	char buf[1] = { 0x08 };
+	int sock_fd = -1;
+	int map_fd = -1;
+	int ret;
+
+	load_attr.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	load_attr.license = "GPL",
+	load_attr.expected_attach_type = BPF_CGROUP_SETSOCKOPT;
+
+	map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY,
+				sizeof(int), sizeof(int), 1, 0);
+	if (map_fd < 0) {
+		log_err("Failed to create map");
+		goto out;
+	}
+
+	prog_inc[0].imm = map_fd;
+
+	if (setup_cgroup_environment()) {
+		log_err("Failed to setup cgroup environment\n");
+		goto out;
+	}
+
+	cg_a = create_and_get_cgroup("/a");
+	if (cg_a < 0) {
+		log_err("Failed to create cgroup /a\n");
+		goto out;
+	}
+
+	cg_a_b = create_and_get_cgroup("/a/b");
+	if (cg_a_b < 0) {
+		log_err("Failed to create cgroup /a/b\n");
+		goto out;
+	}
+
+	if (join_cgroup("/a/b")) {
+		log_err("Failed to join cgroup /a/b\n");
+		goto out;
+	}
+
+	sock_fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock_fd < 0) {
+		log_err("Failed to create socket");
+		goto out;
+	}
+
+	load_attr.insns = prog_deny;
+	load_attr.insns_cnt = ARRAY_SIZE(prog_deny);
+	prog_deny_fd = bpf_load_program_xattr(&load_attr, bpf_log_buf,
+					      sizeof(bpf_log_buf));
+	if (prog_deny_fd < 0) {
+		log_err("Failed to load prog_deny:\n%s\n", bpf_log_buf);
+		goto out;
+	}
+
+	load_attr.insns = prog_bypass;
+	load_attr.insns_cnt = ARRAY_SIZE(prog_bypass);
+	prog_bypass_fd = bpf_load_program_xattr(&load_attr, bpf_log_buf,
+						sizeof(bpf_log_buf));
+	if (prog_bypass_fd < 0) {
+		log_err("Failed to load prog_bypass:\n%s\n", bpf_log_buf);
+		goto out;
+	}
+
+	load_attr.insns = prog_inc;
+	load_attr.insns_cnt = ARRAY_SIZE(prog_inc);
+	prog_inc_fd = bpf_load_program_xattr(&load_attr, bpf_log_buf,
+					     sizeof(bpf_log_buf));
+	if (prog_inc_fd < 0) {
+		log_err("Failed to load prog_inc:\n%s\n", bpf_log_buf);
+		goto out;
+	}
+
+	if (bpf_prog_attach(prog_inc_fd, cg_a,
+			    BPF_CGROUP_SETSOCKOPT, BPF_F_ALLOW_MULTI)) {
+		log_err("Failed to attach prog_inc\n");
+		goto out;
+	}
+
+	/* No program was triggered so far, expected value is 0.
+	 */
+
+	ret = read_cnt(map_fd);
+	if (ret != 0) {
+		log_err("Unexpected initial map value %d != 0\n", ret);
+		goto out;
+	}
+
+	/* Call setsockopt that should trigger bpf program in the parent
+	 * cgroup and increase the counter to 1.
+	 */
+
+	if (setsockopt(sock_fd, SOL_IP, IP_TOS, buf, 1) < 0) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto out;
+	}
+
+	ret = read_cnt(map_fd);
+	if (ret != 1) {
+		log_err("Unexpected prog_inc sockopt map value %d != 1\n", ret);
+		goto out;
+	}
+
+	/* Attach program that returns 0 to current cgroup, parent program
+	 * should not trigger.
+	 */
+
+	if (bpf_prog_attach(prog_deny_fd, cg_a_b,
+			    BPF_CGROUP_SETSOCKOPT, BPF_F_ALLOW_MULTI)) {
+		log_err("Failed to attach prog_deny\n");
+		goto out;
+	}
+
+	if (setsockopt(sock_fd, SOL_IP, IP_TOS, buf, 1) >= 0) {
+		log_err("Unexpected success when calling setsockopt(IP_TOS)");
+		goto out;
+	}
+
+	ret = read_cnt(map_fd);
+	if (ret != 1) {
+		log_err("Unexpected prog_deny map value %d != 1\n", ret);
+		goto out;
+	}
+
+	/* Attach program that returns 2 to current cgroup, parent program
+	 * should not trigger.
+	 */
+
+	if (bpf_prog_detach2(prog_deny_fd, cg_a_b, BPF_CGROUP_SETSOCKOPT)) {
+		log_err("Failed to detach prog_deny\n");
+		goto out;
+	}
+
+	if (bpf_prog_attach(prog_bypass_fd, cg_a_b,
+			    BPF_CGROUP_SETSOCKOPT, BPF_F_ALLOW_MULTI)) {
+		log_err("Failed to attach prog_bypass\n");
+		goto out;
+	}
+
+	if (setsockopt(sock_fd, SOL_IP, IP_TOS, buf, 1) < 0) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto out;
+	}
+
+	ret = read_cnt(map_fd);
+	if (ret != 1) {
+		log_err("Unexpected prog_bypass map value %d != 1\n", ret);
+		goto out;
+	}
+
+	/* Attach the same program that increases the counters to current
+	 * cgroup, bpf program should trigger twice.
+	 */
+
+	if (bpf_prog_detach2(prog_bypass_fd, cg_a_b, BPF_CGROUP_SETSOCKOPT)) {
+		log_err("Failed to detach prog_deny\n");
+		goto out;
+	}
+
+	if (bpf_prog_attach(prog_inc_fd, cg_a_b,
+			    BPF_CGROUP_SETSOCKOPT, BPF_F_ALLOW_MULTI)) {
+		log_err("Failed to attach prog_inc\n");
+		goto out;
+	}
+
+	if (setsockopt(sock_fd, SOL_IP, IP_TOS, buf, 1) < 0) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto out;
+	}
+
+	ret = read_cnt(map_fd);
+	if (ret != 3) {
+		log_err("Unexpected 2x prog_inc map value %d != 3\n", ret);
+		goto out;
+	}
+
+	err = EXIT_SUCCESS;
+
+out:
+	bpf_prog_detach2(prog_inc_fd, cg_a, BPF_CGROUP_SETSOCKOPT);
+	bpf_prog_detach2(prog_inc_fd, cg_a_b, BPF_CGROUP_SETSOCKOPT);
+	close(prog_inc_fd);
+	close(prog_bypass_fd);
+	close(prog_deny_fd);
+	close(sock_fd);
+	close(cg_a_b);
+	close(cg_a);
+	close(map_fd);
+
+	printf("test_sockopt_multi: %s\n",
+	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
+	return err;
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

