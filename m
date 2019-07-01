Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8A55C123
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfGAQbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:31:14 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:55330 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbfGAQbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:31:13 -0400
Received: by mail-pg1-f202.google.com with SMTP id b10so7888540pgb.22
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GO4y5VtWIJEbI5Ri+PS4Rm7/vHbI8UMMA44QF3Z6uII=;
        b=CQgHRv1itxK6dpYdG2eR2i9xxdgbtOIjp3iDrSrQvtO813s0R1oMsh4GWuOJi4WSlQ
         FTgJPdzq0I7asWtuUeHFg/1wbU0t5SzSZTjsaptaw68Ss9To7Z1sHzz30kAPDcoKms6y
         PGtI6i0qnfUDu3UQ/Ecxp21f1OElAa+m4GcOHmNYT96dmQDLmgHytOUbPqIfQ75+cl24
         5VPlxbsoXFbccArMA9qWYtf6YmOx6ynmkgghwxqr33w83b2KrtKEcr50eEr4YyiQEoSS
         hWutqgDqfHTh0JkD06t1o2LyBjWzPS8BSnRJNIZsptIbbvA1VDz9CAcA2DqPBnm8/7LM
         tAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GO4y5VtWIJEbI5Ri+PS4Rm7/vHbI8UMMA44QF3Z6uII=;
        b=Vyn9igLMuehsOu3wMLH8gvjYOa5p950ICCNTNryLvvrC5RP8UytxE3UrFGz42nM2bC
         9rErnip/4NrXOeOQKDWns7HfWExJCTM/mq5FL5XKYwzIfI8JqQ4AgOO5G2ulakUiUDlq
         LlkXDlUiYWUkoUEOp+dSigopWiRxItmpxtx7daAZjWqtpoaGUnn4zlKLspdQFYDhd62I
         2Ak0ixxul8AhKhAKnZo/7PWPtIBZcoVWZ2o0kWn8PX5NoXqm4/M9faxXUy1wxnZcUUDX
         gn/Sz21Xt0fDTS8XX4U25PPI3FJOqzLoj4iz27M7y1LUWXfUfNT0VZ6GIzZgj5Cjgb3E
         1+/A==
X-Gm-Message-State: APjAAAWx8frXcjpKn201WZ58/yBLtLajshiFzOt+7eT7jOA/gzvpPJsf
        CKYJKZVatIe9eE4jdOmzJ85PI+vUHRwdTV/MyMLc+ccoCIzKTNlnlQLDtw0m+RADYsgHs03ouxr
        BZlYLha7mYRBzMUrcs65ebGk2GPoNCVzvRSFWC7kK/tmpCy6NNhZW9w==
X-Google-Smtp-Source: APXvYqwm20+Vv4BbUvIKFLK/ZbV4k9koXMB7IZXw08tBxzDHpkvDPgykcI/BFsoYzO6zdF2tLg/zxaE=
X-Received: by 2002:a65:420c:: with SMTP id c12mr6037426pgq.125.1561998672771;
 Mon, 01 Jul 2019 09:31:12 -0700 (PDT)
Date:   Mon,  1 Jul 2019 09:31:03 -0700
In-Reply-To: <20190701163103.237550-1-sdf@google.com>
Message-Id: <20190701163103.237550-4-sdf@google.com>
Mime-Version: 1.0
References: <20190701163103.237550-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: add verifier tests for wide stores
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that wide stores are allowed at proper (aligned) addresses.
Note that user_ip6 is naturally aligned on 8-byte boundary, so
correct addresses are user_ip6[0] and user_ip6[2]. msg_src_ip6 is,
however, aligned on a 4-byte bondary, so only msg_src_ip6[1]
can be wide-stored.

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 17 +++++++--
 .../selftests/bpf/verifier/wide_store.c       | 36 +++++++++++++++++++
 2 files changed, 50 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c5514daf8865..b0773291012a 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -105,6 +105,7 @@ struct bpf_test {
 			__u64 data64[TEST_DATA_LEN / 8];
 		};
 	} retvals[MAX_TEST_RUNS];
+	enum bpf_attach_type expected_attach_type;
 };
 
 /* Note we want this to be 64 bit aligned so that the end of our array is
@@ -850,6 +851,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	int fd_prog, expected_ret, alignment_prevented_execution;
 	int prog_len, prog_type = test->prog_type;
 	struct bpf_insn *prog = test->insns;
+	struct bpf_load_program_attr attr;
 	int run_errs, run_successes;
 	int map_fds[MAX_NR_MAPS];
 	const char *expected_err;
@@ -881,8 +883,17 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		pflags |= BPF_F_STRICT_ALIGNMENT;
 	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
 		pflags |= BPF_F_ANY_ALIGNMENT;
-	fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
-				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type = prog_type;
+	attr.expected_attach_type = test->expected_attach_type;
+	attr.insns = prog;
+	attr.insns_cnt = prog_len;
+	attr.license = "GPL";
+	attr.log_level = 4;
+	attr.prog_flags = pflags;
+
+	fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
 	if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
 		printf("SKIP (unsupported program type %d)\n", prog_type);
 		skips++;
@@ -912,7 +923,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 			printf("FAIL\nUnexpected success to load!\n");
 			goto fail_log;
 		}
-		if (!strstr(bpf_vlog, expected_err)) {
+		if (!expected_err || !strstr(bpf_vlog, expected_err)) {
 			printf("FAIL\nUnexpected error message!\n\tEXP: %s\n\tRES: %s\n",
 			      expected_err, bpf_vlog);
 			goto fail_log;
diff --git a/tools/testing/selftests/bpf/verifier/wide_store.c b/tools/testing/selftests/bpf/verifier/wide_store.c
new file mode 100644
index 000000000000..8fe99602ded4
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/wide_store.c
@@ -0,0 +1,36 @@
+#define BPF_SOCK_ADDR(field, off, res, err) \
+{ \
+	"wide store to bpf_sock_addr." #field "[" #off "]", \
+	.insns = { \
+	BPF_MOV64_IMM(BPF_REG_0, 1), \
+	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, \
+		    offsetof(struct bpf_sock_addr, field[off])), \
+	BPF_EXIT_INSN(), \
+	}, \
+	.result = res, \
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
+	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
+	.errstr = err, \
+}
+
+/* user_ip6[0] is u64 aligned */
+BPF_SOCK_ADDR(user_ip6, 0, ACCEPT,
+	      NULL),
+BPF_SOCK_ADDR(user_ip6, 1, REJECT,
+	      "invalid bpf_context access off=12 size=8"),
+BPF_SOCK_ADDR(user_ip6, 2, ACCEPT,
+	      NULL),
+BPF_SOCK_ADDR(user_ip6, 3, REJECT,
+	      "invalid bpf_context access off=20 size=8"),
+
+/* msg_src_ip6[0] is _not_ u64 aligned */
+BPF_SOCK_ADDR(msg_src_ip6, 0, REJECT,
+	      "invalid bpf_context access off=44 size=8"),
+BPF_SOCK_ADDR(msg_src_ip6, 1, ACCEPT,
+	      NULL),
+BPF_SOCK_ADDR(msg_src_ip6, 2, REJECT,
+	      "invalid bpf_context access off=52 size=8"),
+BPF_SOCK_ADDR(msg_src_ip6, 3, REJECT,
+	      "invalid bpf_context access off=56 size=8"),
+
+#undef BPF_SOCK_ADDR
-- 
2.22.0.410.gd8fdbe21b5-goog

