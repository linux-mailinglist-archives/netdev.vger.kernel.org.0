Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7313BE18
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389935AbfFJVIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:08:47 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:38490 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389928AbfFJVIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:08:46 -0400
Received: by mail-qt1-f202.google.com with SMTP id r58so10061856qtb.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=brv+2FN4OBHSPMro59uiU/SRE06er3VJZqUqarTiTNE=;
        b=d18IVfd/AFSfwF2xQE3bFLINl6dIM3DXGvp7cnZ6RVOR0bMU43MZlNtkfr+OdCnRh7
         ijrd5sD6Xtfs2No5Q8hZ2Qtu4SH/DIIRPJMr1bVJ6vasse3hRha/+avDG+nMeXEVu4Kc
         FYRhaS0sJ9SUsHGyFzYF0S52IKNOl6mQNMtyjhkSAFmAngc5A7RH48i/tdM9dySn2vLQ
         fBM/wqMh4Auu9i17XRv2CRGGVGtlhATJBQ9ijVp8M1Z8FWUJAIveELbTRGlbpReW2c1f
         QfjM6AqtEkQsOjltxV2QX+mEkbksi9+rO4scz83s1U59zofsf9PtybWF+4VBMQoquJwV
         6g8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=brv+2FN4OBHSPMro59uiU/SRE06er3VJZqUqarTiTNE=;
        b=RwNaQ3iYW+euOTOqEMFpPfF8wfu4oVFZcthGmGSh4RAzbL1NSsgVg6hxRrze2OK9Jo
         BEmybox/pyKzY5fY8xFHKh2aE2lKWV3MH6OinIh+UqTmXgXIq9F9X1yzOzI4P+I2YvOI
         sPcCMTKQJ7Jqm0lw6spF3O05FpX5z37RDmo6adG+ZMgsNQRgTKJNzQ19G9LLMxECxVn4
         cPR4iz+MxLEMLBeqeAZXMjikomKoregNrpG7y9qdICHMLzmej87n2fLoXEkmLgbJ16LL
         1BA1VcmRWdWSLDK+7ezi4g7fsR/KTGXFun5N9ztDDTQZ5S9fe1iY3uIWlUs+/7qHP5bS
         QzQQ==
X-Gm-Message-State: APjAAAU+H1l18W0Rt67ELPx5iTyvNgfw49Mf9bcy8BAyoW83PQyf97rJ
        wuq5v/4COAIdDb+4ri520QYzt0fFqrX7mnuoPhCowDlDYZXXJt+HhI722jAJE4dW5rrS2atpm51
        h6TTuueIHz9QfTvFBdgjN4hNOYou+Pj3m3rVOf/OFDpuSKBMmW+4U4g==
X-Google-Smtp-Source: APXvYqycPubxCmIg1Un9oY1zltAQHht1beX+x0xux24E3EOaEFoQzjXAVnXzaEIf8h7HJN853St+K0E=
X-Received: by 2002:a0c:d4d0:: with SMTP id y16mr39439968qvh.191.1560200925306;
 Mon, 10 Jun 2019 14:08:45 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:08:27 -0700
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Message-Id: <20190610210830.105694-6-sdf@google.com>
Mime-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v5 5/8] selftests/bpf: add sockopt test
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

