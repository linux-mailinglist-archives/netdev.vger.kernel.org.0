Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4D33B990
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfFJQek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:34:40 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:38660 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbfFJQej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:34:39 -0400
Received: by mail-pl1-f201.google.com with SMTP id s22so2035844plp.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=brv+2FN4OBHSPMro59uiU/SRE06er3VJZqUqarTiTNE=;
        b=SpSWHjjHzGkGNUqbAue5pkYrBg6X998Rg0mGRuWFuDGPr2EMdUgz2sgAKHyJznR2fN
         pietrRQIoQN34cCk4TvQqxQBKE9r/qZJAVKnz1zgFlw//edumYBzrCv5BAHDlmxycQdj
         j5y1GZx3jY6mIHK6IArAkrE26yQpH+Z1BAstfgqYKku/5p7DXd2mVJZd+DVlBcD07UhE
         c1n/0OpnVw5dGK2PyvO/+6PnjRFhCRfnR3tjZ2KjshjTDBCxAppGm0hY7NspyTpE4y0Z
         SvSTyrZnt3SyRIDCPDviRtLHBa+jSD+sJHl/bJT+DjBZjOQ1naHIrkQQnW615hbNwdj8
         RHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=brv+2FN4OBHSPMro59uiU/SRE06er3VJZqUqarTiTNE=;
        b=ljmEWF6SqllZyx73+WLZUDgkXwWD2o0RGiU4vQ6jW5JqdFj8Mhh7j9BPZjUFXd1gix
         La2e2N8Y54s2m5cBqnwh/yIPSyhQoTAELNy//B4NqiNuy4KV1KInkez6W83JDDRMDAWZ
         3Rk3XMzctjtAAwQ78RPadOm3gQTrVFgpZ5l7yrlISteCYdn389VIK1bOliOujjlPHu6P
         Ytw8AZf2lB5lfq6/95hfqDfv1kh+FJEUS71WMIQ1WcUNFPdjEbFJPpR2sZvzgEcHYRV4
         e5o9mv3tm8cE0UkMc+kKx38hp/+7dgCDk6RZHvNpSgnxWJVrx6w/5nAsmX2TJajhkaEl
         GZIA==
X-Gm-Message-State: APjAAAUVkFcQ936fIN47VSEsfGJFsmClAzrhVZKdgyxrW7KxOpo9fBb2
        n2KMPbqf4lDrOTOuTrAX8/mVAtl9Cekc8ADp8mQmFq4HVFlUJFAbpbkwoGVBFMxg36YZc6Dfp+1
        lf2o7WwT6oZP6NxySQnIpvm2QL8IzPCVCD+ReDzW5iRGV46N4dpveOg==
X-Google-Smtp-Source: APXvYqyOtyoWK5hSw/Ik7iQhxqhIkiEBYUDKZF2HnRlFjez5BBPp2zWK6BeWkIfUcSMs4YYteajT3lI=
X-Received: by 2002:a65:418d:: with SMTP id a13mr16628653pgq.332.1560184476777;
 Mon, 10 Jun 2019 09:34:36 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:34:18 -0700
In-Reply-To: <20190610163421.208126-1-sdf@google.com>
Message-Id: <20190610163421.208126-6-sdf@google.com>
Mime-Version: 1.0
References: <20190610163421.208126-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v4 5/8] selftests/bpf: add sockopt test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add sockopt selftests:
* require proper expected_attach_type
* enforce context field read/write access
* test bpf_sockopt_handled handler
* test EPERM
* test limiting optlen from getsockopt
* test out-of-bounds access

v3:
* use DW for optval{,_end} loads

v2:
* use return code 2 for kernel bypass

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore     |   1 +
 tools/testing/selftests/bpf/Makefile       |   3 +-
 tools/testing/selftests/bpf/test_sockopt.c | 773 +++++++++++++++++++++
 3 files changed, 776 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/test_sockopt.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 7470327edcfe..3fe92601223d 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,3 +39,4 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+test_sockopt
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2b426ae1cdc9..b982393b9181 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -26,7 +26,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
 	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping
+	test_btf_dump test_cgroup_attach xdping test_sockopt
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -101,6 +101,7 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
+$(OUTPUT)/test_sockopt: cgroup_helpers.c
 
 .PHONY: force
 
diff --git a/tools/testing/selftests/bpf/test_sockopt.c b/tools/testing/selftests/bpf/test_sockopt.c
new file mode 100644
index 000000000000..c007ad4d2c85
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockopt.c
@@ -0,0 +1,773 @@
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
+static char bpf_log_buf[4096];
+static bool verbose;
+
+enum sockopt_test_error {
+	OK = 0,
+	DENY_LOAD,
+	DENY_ATTACH,
+	EPERM_GETSOCKOPT,
+	EFAULT_GETSOCKOPT,
+	EPERM_SETSOCKOPT,
+};
+
+static struct sockopt_test {
+	const char			*descr;
+	const struct bpf_insn		insns[64];
+	enum bpf_attach_type		attach_type;
+	enum bpf_attach_type		expected_attach_type;
+
+	int				level;
+	int				optname;
+
+	const char			set_optval[64];
+	socklen_t			set_optlen;
+
+	const char			get_optval[64];
+	socklen_t			get_optlen;
+	socklen_t			get_optlen_ret;
+
+	enum sockopt_test_error		error;
+} tests[] = {
+
+	/* ==================== getsockopt ====================  */
+
+	{
+		.descr = "getsockopt: no expected_attach_type",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = 0,
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "getsockopt: wrong expected_attach_type",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+		.error = DENY_ATTACH,
+	},
+	{
+		.descr = "getsockopt: bypass bpf hook",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.set_optval = { 1 << 3 },
+		.set_optlen = 1,
+
+		.get_optval = { 1 << 3 },
+		.get_optlen = 1,
+	},
+	{
+		.descr = "getsockopt: return EPERM from bpf hook",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.get_optlen = 1,
+		.error = EPERM_GETSOCKOPT,
+	},
+	{
+		.descr = "getsockopt: no optval bounds check, deny loading",
+		.insns = {
+			/* r6 = ctx->optval */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval)),
+
+			/* ctx->optval[0] = 0x80 */
+			BPF_MOV64_IMM(BPF_REG_0, 0x80),
+			BPF_STX_MEM(BPF_W, BPF_REG_6, BPF_REG_0, 0),
+
+			/* return 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "getsockopt: read ctx->level",
+		.insns = {
+			/* r6 = ctx->level */
+			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, level)),
+
+			/* if (ctx->level == 123) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 123, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_JMP_A(1),
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.level = 123,
+
+		.get_optlen = 1,
+	},
+	{
+		.descr = "getsockopt: deny writing to ctx->level",
+		.insns = {
+			/* ctx->level = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, level)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "getsockopt: read ctx->optname",
+		.insns = {
+			/* r6 = ctx->optname */
+			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optname)),
+
+			/* if (ctx->optname == 123) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 123, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_JMP_A(1),
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.optname = 123,
+
+		.get_optlen = 1,
+	},
+	{
+		.descr = "getsockopt: deny writing to ctx->optname",
+		.insns = {
+			/* ctx->optname = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optname)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "getsockopt: read ctx->optlen",
+		.insns = {
+			/* r6 = ctx->optlen */
+			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optlen)),
+
+			/* if (ctx->optlen == 64) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 64, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_JMP_A(1),
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.get_optlen = 64,
+	},
+	{
+		.descr = "getsockopt: deny bigger ctx->optlen",
+		.insns = {
+			/* ctx->optlen = 65 */
+			BPF_MOV64_IMM(BPF_REG_0, 65),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optlen)),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.get_optlen = 64,
+
+		.error = EFAULT_GETSOCKOPT,
+	},
+	{
+		.descr = "getsockopt: support smaller ctx->optlen",
+		.insns = {
+			/* ctx->optlen = 32 */
+			BPF_MOV64_IMM(BPF_REG_0, 32),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optlen)),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.get_optlen = 64,
+		.get_optlen_ret = 32,
+	},
+	{
+		.descr = "getsockopt: deny writing to ctx->optval",
+		.insns = {
+			/* ctx->optval = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optval)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "getsockopt: deny writing to ctx->optval_end",
+		.insns = {
+			/* ctx->optval_end = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optval_end)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+
+	{
+		.descr = "getsockopt: rewrite value",
+		.insns = {
+			/* r6 = ctx->optval */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval)),
+			/* r2 = ctx->optval */
+			BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
+			/* r6 = ctx->optval + 1 */
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, 1),
+
+			/* r7 = ctx->optval_end */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval_end)),
+
+			/* if (ctx->optval + 1 <= ctx->optval_end) { */
+			BPF_JMP_REG(BPF_JGT, BPF_REG_6, BPF_REG_7, 1),
+			/* ctx->optval[0] = 0xF0 */
+			BPF_ST_MEM(BPF_B, BPF_REG_2, 0, 0xF0),
+			/* } */
+
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_GETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.get_optval = { 0xF0 },
+		.get_optlen = 1,
+	},
+
+	/* ==================== setsockopt ====================  */
+
+	{
+		.descr = "setsockopt: no expected_attach_type",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = 0,
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: wrong expected_attach_type",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_GETSOCKOPT,
+		.error = DENY_ATTACH,
+	},
+	{
+		.descr = "setsockopt: bypass bpf hook",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.set_optval = { 1 << 3 },
+		.set_optlen = 1,
+
+		.get_optval = { 1 << 3 },
+		.get_optlen = 1,
+	},
+	{
+		.descr = "setsockopt: return EPERM from bpf hook",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.set_optlen = 1,
+		.error = EPERM_SETSOCKOPT,
+	},
+	{
+		.descr = "setsockopt: no optval bounds check, deny loading",
+		.insns = {
+			/* r6 = ctx->optval */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval)),
+
+			/* r0 = ctx->optval[0] */
+			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_6, 0),
+
+			/* return 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: read ctx->level",
+		.insns = {
+			/* r6 = ctx->level */
+			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, level)),
+
+			/* if (ctx->level == 123) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 123, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_JMP_A(1),
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.level = 123,
+
+		.set_optlen = 1,
+	},
+	{
+		.descr = "setsockopt: deny writing to ctx->level",
+		.insns = {
+			/* ctx->level = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, level)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: read ctx->optname",
+		.insns = {
+			/* r6 = ctx->optname */
+			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optname)),
+
+			/* if (ctx->optname == 123) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 123, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_JMP_A(1),
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.optname = 123,
+
+		.set_optlen = 1,
+	},
+	{
+		.descr = "setsockopt: deny writing to ctx->optname",
+		.insns = {
+			/* ctx->optname = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optname)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: read ctx->optlen",
+		.insns = {
+			/* r6 = ctx->optlen */
+			BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optlen)),
+
+			/* if (ctx->optlen == 64) { */
+			BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 64, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_JMP_A(1),
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.set_optlen = 64,
+	},
+	{
+		.descr = "setsockopt: deny writing to ctx->optlen",
+		.insns = {
+			/* ctx->optlen = 32 */
+			BPF_MOV64_IMM(BPF_REG_0, 32),
+			BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optlen)),
+			BPF_MOV64_IMM(BPF_REG_0, 2),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.set_optlen = 64,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: deny writing to ctx->optval",
+		.insns = {
+			/* ctx->optval = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optval)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: deny writing to ctx->optval_end",
+		.insns = {
+			/* ctx->optval_end = 1 */
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0,
+				    offsetof(struct bpf_sockopt, optval_end)),
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.error = DENY_LOAD,
+	},
+	{
+		.descr = "setsockopt: allow IP_TOS <= 128",
+		.insns = {
+			/* r6 = ctx->optval */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval)),
+			/* r7 = ctx->optval + 1 */
+			BPF_MOV64_REG(BPF_REG_7, BPF_REG_6),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_7, 1),
+
+			/* r8 = ctx->optval_end */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_8, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval_end)),
+
+			/* if (ctx->optval + 1 <= ctx->optval_end) { */
+			BPF_JMP_REG(BPF_JGT, BPF_REG_7, BPF_REG_8, 4),
+
+			/* r9 = ctx->optval[0] */
+			BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_6, 0),
+
+			/* if (ctx->optval[0] < 128) */
+			BPF_JMP_IMM(BPF_JGT, BPF_REG_9, 128, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_JMP_A(1),
+			/* } */
+
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.set_optval = { 0x80 },
+		.set_optlen = 1,
+		.get_optval = { 0x80 },
+		.get_optlen = 1,
+	},
+	{
+		.descr = "setsockopt: deny IP_TOS > 128",
+		.insns = {
+			/* r6 = ctx->optval */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval)),
+			/* r7 = ctx->optval + 1 */
+			BPF_MOV64_REG(BPF_REG_7, BPF_REG_6),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_7, 1),
+
+			/* r8 = ctx->optval_end */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_8, BPF_REG_1,
+				    offsetof(struct bpf_sockopt, optval_end)),
+
+			/* if (ctx->optval + 1 <= ctx->optval_end) { */
+			BPF_JMP_REG(BPF_JGT, BPF_REG_7, BPF_REG_8, 4),
+
+			/* r9 = ctx->optval[0] */
+			BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_6, 0),
+
+			/* if (ctx->optval[0] < 128) */
+			BPF_JMP_IMM(BPF_JGT, BPF_REG_9, 128, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_JMP_A(1),
+			/* } */
+
+			/* } else { */
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			/* } */
+
+			BPF_EXIT_INSN(),
+		},
+		.attach_type = BPF_CGROUP_SETSOCKOPT,
+		.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+
+		.level = SOL_IP,
+		.optname = IP_TOS,
+
+		.set_optval = { 0x81 },
+		.set_optlen = 1,
+		.get_optval = { 0x00 },
+		.get_optlen = 1,
+
+		.error = EPERM_SETSOCKOPT,
+	},
+};
+
+static int load_prog(const struct bpf_insn *insns,
+		     enum bpf_attach_type expected_attach_type)
+{
+	struct bpf_load_program_attr attr = {
+		.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
+		.expected_attach_type = expected_attach_type,
+		.insns = insns,
+		.license = "GPL",
+		.log_level = 2,
+	};
+	int fd;
+
+	for (;
+	     insns[attr.insns_cnt].code != (BPF_JMP | BPF_EXIT);
+	     attr.insns_cnt++) {
+	}
+	attr.insns_cnt++;
+
+	fd = bpf_load_program_xattr(&attr, bpf_log_buf, sizeof(bpf_log_buf));
+	if (verbose && fd < 0)
+		fprintf(stderr, "%s\n", bpf_log_buf);
+
+	return fd;
+}
+
+static int run_test(int cgroup_fd, struct sockopt_test *test)
+{
+	int sock_fd, err, prog_fd;
+	void *optval = NULL;
+	int ret = 0;
+
+	prog_fd = load_prog(test->insns, test->expected_attach_type);
+	if (prog_fd < 0) {
+		if (test->error == DENY_LOAD)
+			return 0;
+
+		perror("bpf_program__load");
+		return -1;
+	}
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, test->attach_type, 0);
+	if (err < 0) {
+		if (test->error == DENY_ATTACH)
+			goto close_prog_fd;
+
+		perror("bpf_prog_attach");
+		ret = -1;
+		goto close_prog_fd;
+	}
+
+	sock_fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock_fd < 0) {
+		perror("socket");
+		ret = -1;
+		goto detach_prog;
+	}
+
+	if (test->set_optlen) {
+		err = setsockopt(sock_fd, test->level, test->optname,
+				 test->set_optval, test->set_optlen);
+		if (err) {
+			if (errno == EPERM && test->error == EPERM_SETSOCKOPT)
+				goto close_sock_fd;
+
+			perror("setsockopt");
+			ret = -1;
+			goto close_sock_fd;
+		}
+	}
+
+	if (test->get_optlen) {
+		optval = malloc(test->get_optlen);
+		socklen_t optlen = test->get_optlen;
+		socklen_t expected_get_optlen = test->get_optlen_ret ?:
+			test->get_optlen;
+
+		err = getsockopt(sock_fd, test->level, test->optname,
+				 optval, &optlen);
+		if (err) {
+			if (errno == EPERM && test->error == EPERM_GETSOCKOPT)
+				goto free_optval;
+			if (errno == EFAULT && test->error == EFAULT_GETSOCKOPT)
+				goto free_optval;
+
+			perror("getsockopt");
+			ret = -1;
+			goto free_optval;
+		}
+
+		if (optlen != expected_get_optlen) {
+			perror("getsockopt optlen");
+			ret = -1;
+			goto free_optval;
+		}
+
+		if (memcmp(optval, test->get_optval, optlen) != 0) {
+			perror("getsockopt optval");
+			ret = -1;
+			goto free_optval;
+		}
+	}
+
+	ret = test->error != OK;
+
+free_optval:
+	free(optval);
+close_sock_fd:
+	close(sock_fd);
+detach_prog:
+	bpf_prog_detach2(prog_fd, cgroup_fd, test->attach_type);
+close_prog_fd:
+	close(prog_fd);
+	return ret;
+}
+
+int main(int args, char **argv)
+{
+	int err = EXIT_FAILURE, error_cnt = 0;
+	int cgroup_fd, i;
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
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		int err = run_test(cgroup_fd, &tests[i]);
+
+		if (err)
+			error_cnt++;
+
+		printf("#%d %s: %s\n", i, err ? "FAIL" : "PASS",
+		       tests[i].descr);
+	}
+
+	printf("Summary: %ld PASSED, %d FAILED\n",
+	       ARRAY_SIZE(tests) - error_cnt, error_cnt);
+	err = error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
+
+cleanup_cgroup:
+	close(cgroup_fd);
+cleanup_cgroup_env:
+	cleanup_cgroup_environment();
+cleanup_obj:
+	return err;
+}
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

