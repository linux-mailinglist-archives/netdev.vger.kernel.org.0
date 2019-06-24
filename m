Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D151892
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbfFXQZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:25:01 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:45283 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732009AbfFXQYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:52 -0400
Received: by mail-pg1-f201.google.com with SMTP id n7so4646769pgr.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E3/NjGxZJZpjVUvabQp7xEgi3RwHvVFfByy3GxO1FAE=;
        b=bvEA6RmxQCXJpGl6qQR2ZI1toOtawNiwlIVBlJT3aIXAUAwAF9zVWh5hPBTRlP/S+t
         x/unxfVDszvFocLCqBPeHj2iBobxlYFJ/5SYct/AQvp2IYF3D9e1G7cdN3yZ1c/wsoI0
         13Gy5/j85eDflK+YjrJRfRQugCxRo0FNP7m+gwqTvkoR4xsxkjgYST8Af/6+E1VODWGJ
         +UlzU6XLsBA8QeeWy2i54X0A6IAKdQelyW/PC7CQIfGt1VHmM8yKW1PkDEuUeKxqG9R9
         GLLIWDEMHdZ7hWvy/bdkd4hJZ/gafnKC5XLylkg1rvEWmE3AAplFdBLpPX88NBqNfuw4
         Fovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E3/NjGxZJZpjVUvabQp7xEgi3RwHvVFfByy3GxO1FAE=;
        b=oo8hJdGfvsz7DsV9ar2zKECM853TkKWBK1BqGciEppB5VTuHh8kdDLawxTEOZToXMS
         HR8OZxGee4WkbQakAc6FePpaqhWv/xqaYGE6M3P/oey/VaFossQmrV6CA3VWLrpMQIPJ
         DSiXsvNr2VWnbFespHMJzUmQEf+KNhll50eR3/1CIzbPspbcCXtkKg8OzbUhb+DhEySi
         pEx1a84/5rMtPh93BAcqoTOVeI2K4gTv4Sa3HOESOOgox/bdevEiAQFrO8lWKKb6166F
         ZIZM61NVjBJ1bidzPSfhfzJkc5rIpYQvMoGnNrTRN2XRA+fZeH3ZtF5OyDhs8Gx0dheW
         2CXg==
X-Gm-Message-State: APjAAAUbLN6O2t2ksu80eJcOzXI/svuMX0TBKJ0kZwmrElAMXM0BUQkp
        Ow98+sxYpGYd03JvU20VX8CpIzxt+2CoPSapy9cnsdaH3+behz2/cGnduXU1LLRyl6NlQCqPV7i
        ifiulcrH/1eG85zVP/mxtSRKxzHisBkINLlA5ZHE7dwgRi0ErOHArRQ==
X-Google-Smtp-Source: APXvYqwVDwN93gfHbyzeT85nhhBw+5FCM/CEFExHEF8pqsum1gRmDKsIT6a986N4VSbhwPMRV3Oimac=
X-Received: by 2002:a63:5508:: with SMTP id j8mr3385626pgb.278.1561393490721;
 Mon, 24 Jun 2019 09:24:50 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:27 -0700
In-Reply-To: <20190624162429.16367-1-sdf@google.com>
Message-Id: <20190624162429.16367-8-sdf@google.com>
Mime-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 7/9] selftests/bpf: add sockopt test that
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

sockopt test that verifies chaining behavior.

v7:
* rework the test to verify cgroup getsockopt chaining

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/progs/sockopt_multi.c       |  53 ++++
 .../selftests/bpf/test_sockopt_multi.c        | 276 ++++++++++++++++++
 4 files changed, 333 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_multi.c
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
index 1210b4e98d27..5615a5f13ce4 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk
+	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
+	test_sockopt_multi
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -105,6 +106,7 @@ $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
 $(OUTPUT)/test_sockopt: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
+$(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/progs/sockopt_multi.c b/tools/testing/selftests/bpf/progs/sockopt_multi.c
new file mode 100644
index 000000000000..1529fe3afe9f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/sockopt_multi.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <netinet/in.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+SEC("cgroup/getsockopt/child")
+int _getsockopt_child(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = ctx->optval_end;
+	__u8 *optval = ctx->optval;
+
+	if (ctx->level != SOL_IP || ctx->optname != IP_TOS)
+		return 1;
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	if (optval[0] != 0x80)
+		return 0; /* EPERM, unexpected optval from the kernel */
+
+	ctx->retval = 0; /* Reset system call return value to zero */
+
+	optval[0] = 0x90;
+	ctx->optlen = 1;
+
+	return 1;
+}
+
+SEC("cgroup/getsockopt/parent")
+int _getsockopt_parent(struct bpf_sockopt *ctx)
+{
+	__u8 *optval_end = ctx->optval_end;
+	__u8 *optval = ctx->optval;
+
+	if (ctx->level != SOL_IP || ctx->optname != IP_TOS)
+		return 1;
+
+	if (optval + 1 > optval_end)
+		return 0; /* EPERM, bounds check */
+
+	if (optval[0] != 0x90)
+		return 0; /* EPERM, unexpected optval from the kernel */
+
+	ctx->retval = 0; /* Reset system call return value to zero */
+
+	optval[0] = 0xA0;
+	ctx->optlen = 1;
+
+	return 1;
+}
diff --git a/tools/testing/selftests/bpf/test_sockopt_multi.c b/tools/testing/selftests/bpf/test_sockopt_multi.c
new file mode 100644
index 000000000000..71acdc861a55
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt_multi.c
@@ -0,0 +1,276 @@
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
+			      attach_type, BPF_F_ALLOW_MULTI);
+	if (err) {
+		log_err("Failed to attach %s BPF program", title);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int prog_detach(struct bpf_object *obj, int cgroup_fd, const char *title)
+{
+	enum bpf_attach_type attach_type;
+	enum bpf_prog_type prog_type;
+	struct bpf_program *prog;
+	int err;
+
+	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type);
+	if (err)
+		return -1;
+
+	prog = bpf_object__find_program_by_title(obj, title);
+	if (!prog)
+		return -1;
+
+	err = bpf_prog_detach2(bpf_program__fd(prog), cgroup_fd,
+			       attach_type);
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static int run_test(struct bpf_object *obj, int cg_parent, int cg_child,
+		    int sock_fd)
+{
+	socklen_t optlen;
+	__u8 buf;
+	int err;
+
+	/* Set IP_TOS to the expected value (0x80). */
+
+	buf = 0x80;
+	err = setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1);
+	if (err < 0) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	buf = 0x00;
+	optlen = 1;
+	err = getsockopt(sock_fd, SOL_IP, IP_TOS, &buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	if (buf != 0x80) {
+		log_err("Unexpected getsockopt 0x%x != 0x80 without BPF", buf);
+		err = -1;
+		goto detach;
+	}
+
+	/* Attach child program and make sure it returns new value:
+	 * - kernel:      -> 0x80
+	 * - child:  0x80 -> 0x90
+	 */
+
+	err = prog_attach(obj, cg_child, "cgroup/getsockopt/child");
+	if (err)
+		goto detach;
+
+	buf = 0x00;
+	optlen = 1;
+	err = getsockopt(sock_fd, SOL_IP, IP_TOS, &buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	if (buf != 0x90) {
+		log_err("Unexpected getsockopt 0x%x != 0x90", buf);
+		err = -1;
+		goto detach;
+	}
+
+	/* Attach parent program and make sure it returns new value:
+	 * - kernel:      -> 0x80
+	 * - child:  0x80 -> 0x90
+	 * - parent: 0x90 -> 0xA0
+	 */
+
+	err = prog_attach(obj, cg_parent, "cgroup/getsockopt/parent");
+	if (err)
+		goto detach;
+
+	buf = 0x00;
+	optlen = 1;
+	err = getsockopt(sock_fd, SOL_IP, IP_TOS, &buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	if (buf != 0xA0) {
+		log_err("Unexpected getsockopt 0x%x != 0xA0", buf);
+		err = -1;
+		goto detach;
+	}
+
+	/* Setting unexpected initial sockopt should return EPERM:
+	 * - kernel: -> 0x40
+	 * - child:  unexpected 0x40, EPERM
+	 * - parent: unexpected 0x40, EPERM
+	 */
+
+	buf = 0x40;
+	if (setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1) < 0) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	buf = 0x00;
+	optlen = 1;
+	err = getsockopt(sock_fd, SOL_IP, IP_TOS, &buf, &optlen);
+	if (!err) {
+		log_err("Unexpected success from getsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	/* Detach child program and make sure we still get EPERM:
+	 * - kernel: -> 0x40
+	 * - parent: unexpected 0x40, EPERM
+	 */
+
+	err = prog_detach(obj, cg_child, "cgroup/getsockopt/child");
+	if (err) {
+		log_err("Failed to detach child program");
+		goto detach;
+	}
+
+	buf = 0x00;
+	optlen = 1;
+	err = getsockopt(sock_fd, SOL_IP, IP_TOS, &buf, &optlen);
+	if (!err) {
+		log_err("Unexpected success from getsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	/* Set initial value to the one the parent program expects:
+	 * - kernel:      -> 0x90
+	 * - parent: 0x90 -> 0xA0
+	 */
+
+	buf = 0x90;
+	err = setsockopt(sock_fd, SOL_IP, IP_TOS, &buf, 1);
+	if (err < 0) {
+		log_err("Failed to call setsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	buf = 0x00;
+	optlen = 1;
+	err = getsockopt(sock_fd, SOL_IP, IP_TOS, &buf, &optlen);
+	if (err) {
+		log_err("Failed to call getsockopt(IP_TOS)");
+		goto detach;
+	}
+
+	if (buf != 0xA0) {
+		log_err("Unexpected getsockopt 0x%x != 0xA0", buf);
+		err = -1;
+		goto detach;
+	}
+
+detach:
+	prog_detach(obj, cg_child, "cgroup/getsockopt/child");
+	prog_detach(obj, cg_parent, "cgroup/getsockopt/parent");
+
+	return err;
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_prog_load_attr attr = {
+		.file = "./sockopt_multi.o",
+	};
+	int cg_parent = -1, cg_child = -1;
+	struct bpf_object *obj = NULL;
+	int sock_fd = -1;
+	int err = -1;
+	int ignored;
+
+	if (setup_cgroup_environment()) {
+		log_err("Failed to setup cgroup environment\n");
+		goto out;
+	}
+
+	cg_parent = create_and_get_cgroup("/parent");
+	if (cg_parent < 0) {
+		log_err("Failed to create cgroup /parent\n");
+		goto out;
+	}
+
+	cg_child = create_and_get_cgroup("/parent/child");
+	if (cg_child < 0) {
+		log_err("Failed to create cgroup /parent/child\n");
+		goto out;
+	}
+
+	if (join_cgroup("/parent/child")) {
+		log_err("Failed to join cgroup /parent/child\n");
+		goto out;
+	}
+
+	err = bpf_prog_load_xattr(&attr, &obj, &ignored);
+	if (err) {
+		log_err("Failed to load BPF object");
+		goto out;
+	}
+
+	sock_fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock_fd < 0) {
+		log_err("Failed to create socket");
+		goto out;
+	}
+
+	if (run_test(obj, cg_parent, cg_child, sock_fd))
+		err = -1;
+
+out:
+	close(sock_fd);
+	bpf_object__close(obj);
+	close(cg_child);
+	close(cg_parent);
+
+	printf("test_sockopt_multi: %s\n", err ? "FAILED" : "PASSED");
+	return err ? EXIT_FAILURE : EXIT_SUCCESS;
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

