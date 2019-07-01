Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9FA5C21C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfGARix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:38:53 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:38609 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbfGARix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:38:53 -0400
Received: by mail-qk1-f202.google.com with SMTP id n190so14270859qkd.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v1r29MqYaO/Cq43bRrhBm1H7TAMfY3ek9WtE+T1iazw=;
        b=SYsJg6hbTnC0ZvAKADsBB9K0xJo1/2ac7po8d8oWRcIJGcCmzbaC7SvQ9ENODpsmf+
         SUkrUSbc8Se0AoEpYkfMA6qIUuViloWgFLmWCyKUKjgbitD8OwRMiq7ccry1GPqO1hkM
         wC1OBeIo4QuMBVYt2uZ5en+dApIVBni5oRvY2QcgiyL9zKVaj2eeBrYeghDIGPosdcu3
         RNtZPLWhC6C8yIwZplHyWVHCQU1EZNS5XOR+MqATR3uUEc3WTrORQq/tHQlcN1+mDa3d
         ZHEAvA8Il2lX96QBmQ5knU+dhchzZy5ScM9Cke9PzJAzzQiIqSeAFEVX7F19pBqud1hn
         WAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v1r29MqYaO/Cq43bRrhBm1H7TAMfY3ek9WtE+T1iazw=;
        b=s04tABKeUICTYWie1kKgQ8O/obOfo5wjt3bDarLvUSuFxKiqm5IRQgBBSB92V3N/IS
         nSVnTp7SOwKRM+Bxxr007go/5jVw+jM6bivMagcaZs0qTd3cgEFnjSXoq/FJq2LquaKZ
         mGhJt8qVCeJcBqmvtHWN/NZq2lnOpRSnadPhJvteNjpHN2qSWaZq+534Af9C/WigX/p5
         ZKdNAwDG+XpDdK0VZycmdO7RNjrl/C2ysrURzRuFRzGLzhUO56OYHnRUAGduB3CaoPi3
         E5fcOzqpR7hQ69fKM08OFT60RYScEE3sbXzCPAwYnnZf+CkFU7ajKImdBQK8iX3dS9Pr
         nPBQ==
X-Gm-Message-State: APjAAAUtogv0NSyDjjRHsIbFxRF3554nCmVrU16dJJx/SrrMLa1qaLBX
        /9x8JLdkjd8RwlA/ZmTI8fbYUO7vzTE53kcHY6UmPFjhjLPvPKINH3e7HqPHKFiMn8N/eSnkpFP
        qPOHre6u7zoEbwvZriZaz0PSn8Y4+P9rTmBjXD5U34yoDBxvyJ7fPMg==
X-Google-Smtp-Source: APXvYqyzLaMfeB3/U3O6wlSdHFGy9xiW42koJ8DA3WsO/VRuxrj8fSH8sASzTW+J0V43RAjikKGa2dA=
X-Received: by 2002:ac8:2e59:: with SMTP id s25mr21284003qta.94.1562002731645;
 Mon, 01 Jul 2019 10:38:51 -0700 (PDT)
Date:   Mon,  1 Jul 2019 10:38:41 -0700
In-Reply-To: <20190701173841.32249-1-sdf@google.com>
Message-Id: <20190701173841.32249-4-sdf@google.com>
Mime-Version: 1.0
References: <20190701173841.32249-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v3 3/3] selftests/bpf: add verifier tests for wide stores
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
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

