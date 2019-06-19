Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118B24BF2C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfFSRAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:00:19 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:45776 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730014AbfFSRAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:00:18 -0400
Received: by mail-vk1-f202.google.com with SMTP id z6so7951507vkd.12
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VtADZPkKfN+VyKp9FAH9WKdPpYSccQCrHQLR5+8B0nc=;
        b=V9NHE6toGtMBJbQEF/6ko0oaxd3ZikVoFNSYJG5cUkKOZ1L0MWT7QwF3BgrMtueBsn
         u7nx5rc2o6MxU2TiPE1LV5lcwf/j0ONZt2PfLvJRyTi4n0W6hRpqokIqb8ZECFxYUGs4
         CMP0MnRsHNECno6RCj+stM7tuzw8PevrC2Xs34ukWOVvflPVTFDue1nV8aAQbe05ylDJ
         ZY5k+QpkGRUDB8qFnF36xE0ndyXNbUwY2oUKZQ8yHToUQqPBWZgSTu7abyERiL3j0MJ3
         17NobsJ4lRkvgQDZGkinNdSe2IQSOBPk0xZ1qgq9qfqRkPZpasrAitAFOSx5IBZhpInY
         /QHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VtADZPkKfN+VyKp9FAH9WKdPpYSccQCrHQLR5+8B0nc=;
        b=IxlwebrTeM7q+yN7EU9vsYvYRv66De8cs0G2A9H8ChNeD4PHJcrFZaoGOzbQl5BSuK
         iOjMHbmqPSU4LaO21jzrd0SpzfanXPxkuf4U6iBsoM7IwOmBmbI4NyMcWnM9NAEp+gpD
         vlWIYwiDQeCb0QVlv2VQBHeIbibWyzL6Xp1nByYZShiKuDiDwyddleomAHA2vgdpgDrs
         frVdplRUaVZ9XO5Rh0Sqbx8ijcFYzclpVbV5ZAZCcpA+1lbzM8s6+/FCUd9VRCtXW5dA
         w8qiyt3dPUfSZXFLxfBsCITH3GTjgGdUUdIVIl8yJ6fRdEVZUpX2gM3DjbdGhse/nwy0
         Nt1g==
X-Gm-Message-State: APjAAAWFhlT8VRnolcIZNR/qbksQ9iCQkk14nqKMHRt9Zn/Ua6qIRcEM
        IBGNZLmUC9nvVeXIHd4JES4k5YRcFnhlNpcp8T9CIX8PcV2h4EZ32uJoQj2CMwvFvSQrOqwT30e
        KxRfxseG7Gd2uAxwMTg8HEOocHzeTGveQNGOJyQGaLxbZu79oXQeWTQ==
X-Google-Smtp-Source: APXvYqyvO0A30/T16apmvRB5lgXWkuA/bOt14IKFU+hJ+tsvDSTebSD8Np1Yu3uIGs1v9jo8iQ7SyAA=
X-Received: by 2002:ab0:184e:: with SMTP id j14mr66697401uag.91.1560963617104;
 Wed, 19 Jun 2019 10:00:17 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:59:55 -0700
In-Reply-To: <20190619165957.235580-1-sdf@google.com>
Message-Id: <20190619165957.235580-8-sdf@google.com>
Mime-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v7 7/9] selftests/bpf: add sockopt test that
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

