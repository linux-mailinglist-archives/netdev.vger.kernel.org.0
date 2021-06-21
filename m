Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996E63AF29A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhFURze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232159AbhFURyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4AB361245;
        Mon, 21 Jun 2021 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297957;
        bh=68AJOoVwWxBdb/3/bzkAbDf6WVmDzmkEuw/hJ7ziSgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StAyDnyXAOQ8oPldjjCV6DRUjrR6a4y48Kx26RhZiEYkQEu6GHc4IkqTEp1yv9kMr
         wR2KdsDZmXRxzylUEWgXv8ULf0LpOczQKfMI/JP9JgXMEJuQxNlW8EaCs90P1pJ7YR
         aHP0uTMXSIUqK0sET3+tQwKDoXsXNhPVJuTlPnKO7v1+s0flooP4rZTHpUL8JOnEfD
         +gO5IkZ9T+4siI0RroDYZHwqvvuVJMNtUXlhXFyr7iC/S9eGMlShgkncq8hcVQ+jSZ
         erpqzTNEZFmsTgMcHjnNJrXdBcSvKbbAybuvDP+iHoObRyCo3allwgcE1Hpn8HEOU/
         mY1h5yxEKVQlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 24/39] bpf, selftests: Adjust few selftest outcomes wrt unreachable code
Date:   Mon, 21 Jun 2021 13:51:40 -0400
Message-Id: <20210621175156.735062-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 973377ffe8148180b2651825b92ae91988141b05 ]

In almost all cases from test_verifier that have been changed in here, we've
had an unreachable path with a load from a register which has an invalid
address on purpose. This was basically to make sure that we never walk this
path and to have the verifier complain if it would otherwise. Change it to
match on the right error for unprivileged given we now test these paths
under speculative execution.

There's one case where we match on exact # of insns_processed. Due to the
extra path, this will of course mismatch on unprivileged. Thus, restrict the
test->insn_processed check to privileged-only.

In one other case, we result in a 'pointer comparison prohibited' error. This
is similarly due to verifying an 'invalid' branch where we end up with a value
pointer on one side of the comparison.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c   |  2 +-
 tools/testing/selftests/bpf/verifier/and.c    |  2 ++
 tools/testing/selftests/bpf/verifier/bounds.c | 14 ++++++++++++
 .../selftests/bpf/verifier/dead_code.c        |  2 ++
 tools/testing/selftests/bpf/verifier/jmp32.c  | 22 +++++++++++++++++++
 tools/testing/selftests/bpf/verifier/jset.c   | 10 +++++----
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 ++
 .../selftests/bpf/verifier/value_ptr_arith.c  |  7 +++---
 8 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 58b5a349d3ba..ea3158b0d551 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1147,7 +1147,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		}
 	}
 
-	if (test->insn_processed) {
+	if (!unpriv && test->insn_processed) {
 		uint32_t insn_processed;
 		char *proc;
 
diff --git a/tools/testing/selftests/bpf/verifier/and.c b/tools/testing/selftests/bpf/verifier/and.c
index ca8fdb1b3f01..7d7ebee5cc7a 100644
--- a/tools/testing/selftests/bpf/verifier/and.c
+++ b/tools/testing/selftests/bpf/verifier/and.c
@@ -61,6 +61,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R1 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0
 },
diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 8a1caf46ffbc..e061e8799ce2 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -508,6 +508,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -528,6 +530,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -569,6 +573,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -589,6 +595,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -609,6 +617,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -674,6 +684,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -695,6 +707,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/dead_code.c b/tools/testing/selftests/bpf/verifier/dead_code.c
index 5cf361d8eb1c..721ec9391be5 100644
--- a/tools/testing/selftests/bpf/verifier/dead_code.c
+++ b/tools/testing/selftests/bpf/verifier/dead_code.c
@@ -8,6 +8,8 @@
 	BPF_JMP_IMM(BPF_JGE, BPF_REG_0, 10, -4),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 7,
 },
diff --git a/tools/testing/selftests/bpf/verifier/jmp32.c b/tools/testing/selftests/bpf/verifier/jmp32.c
index bd5cae4a7f73..1c857b2fbdf0 100644
--- a/tools/testing/selftests/bpf/verifier/jmp32.c
+++ b/tools/testing/selftests/bpf/verifier/jmp32.c
@@ -87,6 +87,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -150,6 +152,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -213,6 +217,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -280,6 +286,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -348,6 +356,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -416,6 +426,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -484,6 +496,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -552,6 +566,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -620,6 +636,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -688,6 +706,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -756,6 +776,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
diff --git a/tools/testing/selftests/bpf/verifier/jset.c b/tools/testing/selftests/bpf/verifier/jset.c
index 8dcd4e0383d5..11fc68da735e 100644
--- a/tools/testing/selftests/bpf/verifier/jset.c
+++ b/tools/testing/selftests/bpf/verifier/jset.c
@@ -82,8 +82,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.retval_unpriv = 1,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.retval = 1,
 	.result = ACCEPT,
 },
@@ -141,7 +141,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -162,6 +163,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/unpriv.c b/tools/testing/selftests/bpf/verifier/unpriv.c
index bd436df5cc32..111801aea5e3 100644
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -420,6 +420,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R7 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 7ae2859d495c..a3e593ddfafc 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -120,7 +120,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
+	.errstr_unpriv = "R2 pointer comparison prohibited",
 	.retval = 0,
 },
 {
@@ -159,7 +159,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	// fake-dead code; targeted from branch A to
-	// prevent dead code sanitization
+	// prevent dead code sanitization, rejected
+	// via branch B however
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
@@ -167,7 +168,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
 	.retval = 0,
 },
 {
-- 
2.30.2

