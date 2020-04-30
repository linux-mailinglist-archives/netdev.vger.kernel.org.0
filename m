Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830841BFD05
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgD3OJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbgD3Nvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99DD24959;
        Thu, 30 Apr 2020 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254703;
        bh=KUN+6WfYGZkb2XeMCziFwGaIqhaHITpeud5J6xzJ29U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBiA5r6iHpP3Cso8quIIzUjeI5gy2J8aG+69K3A9l+c+AAl4oAmDVZCi87wX/4nSM
         cwlhaF/0uKTX53VA0AkkkW86e/r0eTeHJJtNvwJ4Eyur5H1ugnxZnQmgyWt9Xodmc2
         eQoiiCOstQKKB+uwohDFhtdh4xNG18l1vJZgWOs0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 52/79] bpf: Forbid XADD on spilled pointers for unprivileged users
Date:   Thu, 30 Apr 2020 09:50:16 -0400
Message-Id: <20200430135043.19851-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 6e7e63cbb023976d828cdb22422606bf77baa8a9 ]

When check_xadd() verifies an XADD operation on a pointer to a stack slot
containing a spilled pointer, check_stack_read() verifies that the read,
which is part of XADD, is valid. However, since the placeholder value -1 is
passed as `value_regno`, check_stack_read() can only return a binary
decision and can't return the type of the value that was read. The intent
here is to verify whether the value read from the stack slot may be used as
a SCALAR_VALUE; but since check_stack_read() doesn't check the type, and
the type information is lost when check_stack_read() returns, this is not
enforced, and a malicious user can abuse XADD to leak spilled kernel
pointers.

Fix it by letting check_stack_read() verify that the value is usable as a
SCALAR_VALUE if no type information is passed to the caller.

To be able to use __is_pointer_value() in check_stack_read(), move it up.

Fix up the expected unprivileged error message for a BPF selftest that,
until now, assumed that unprivileged users can use XADD on stack-spilled
pointers. This also gives us a test for the behavior introduced in this
patch for free.

In theory, this could also be fixed by forbidding XADD on stack spills
entirely, since XADD is a locked operation (for operations on memory with
concurrency) and there can't be any concurrency on the BPF stack; but
Alexei has said that he wants to keep XADD on stack slots working to avoid
changes to the test suite [1].

The following BPF program demonstrates how to leak a BPF map pointer as an
unprivileged user using this bug:

    // r7 = map_pointer
    BPF_LD_MAP_FD(BPF_REG_7, small_map),
    // r8 = launder(map_pointer)
    BPF_STX_MEM(BPF_DW, BPF_REG_FP, BPF_REG_7, -8),
    BPF_MOV64_IMM(BPF_REG_1, 0),
    ((struct bpf_insn) {
      .code  = BPF_STX | BPF_DW | BPF_XADD,
      .dst_reg = BPF_REG_FP,
      .src_reg = BPF_REG_1,
      .off = -8
    }),
    BPF_LDX_MEM(BPF_DW, BPF_REG_8, BPF_REG_FP, -8),

    // store r8 into map
    BPF_MOV64_REG(BPF_REG_ARG1, BPF_REG_7),
    BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_FP),
    BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, -4),
    BPF_ST_MEM(BPF_W, BPF_REG_ARG2, 0, 0),
    BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
    BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
    BPF_EXIT_INSN(),
    BPF_STX_MEM(BPF_DW, BPF_REG_0, BPF_REG_8, 0),

    BPF_MOV64_IMM(BPF_REG_0, 0),
    BPF_EXIT_INSN()

[1] https://lore.kernel.org/bpf/20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com/

Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200417000007.10734-1-jannh@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 28 +++++++++++++------
 .../bpf/verifier/value_illegal_alu.c          |  1 +
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e5d12c54b552c..e4357a301fb8f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1918,6 +1918,15 @@ static bool register_is_const(struct bpf_reg_state *reg)
 	return reg->type == SCALAR_VALUE && tnum_is_const(reg->var_off);
 }
 
+static bool __is_pointer_value(bool allow_ptr_leaks,
+			       const struct bpf_reg_state *reg)
+{
+	if (allow_ptr_leaks)
+		return false;
+
+	return reg->type != SCALAR_VALUE;
+}
+
 static void save_register_state(struct bpf_func_state *state,
 				int spi, struct bpf_reg_state *reg)
 {
@@ -2108,6 +2117,16 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			 * which resets stack/reg liveness for state transitions
 			 */
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
+		} else if (__is_pointer_value(env->allow_ptr_leaks, reg)) {
+			/* If value_regno==-1, the caller is asking us whether
+			 * it is acceptable to use this value as a SCALAR_VALUE
+			 * (e.g. for XADD).
+			 * We must not allow unprivileged callers to do that
+			 * with spilled pointers.
+			 */
+			verbose(env, "leaking pointer from stack off %d\n",
+				off);
+			return -EACCES;
 		}
 		mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
 	} else {
@@ -2473,15 +2492,6 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	return -EACCES;
 }
 
-static bool __is_pointer_value(bool allow_ptr_leaks,
-			       const struct bpf_reg_state *reg)
-{
-	if (allow_ptr_leaks)
-		return false;
-
-	return reg->type != SCALAR_VALUE;
-}
-
 static struct bpf_reg_state *reg_state(struct bpf_verifier_env *env, int regno)
 {
 	return cur_regs(env) + regno;
diff --git a/tools/testing/selftests/bpf/verifier/value_illegal_alu.c b/tools/testing/selftests/bpf/verifier/value_illegal_alu.c
index 7f6c232cd8423..ed1c2cea1dea6 100644
--- a/tools/testing/selftests/bpf/verifier/value_illegal_alu.c
+++ b/tools/testing/selftests/bpf/verifier/value_illegal_alu.c
@@ -88,6 +88,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_48b = { 3 },
+	.errstr_unpriv = "leaking pointer from stack off -8",
 	.errstr = "R0 invalid mem access 'inv'",
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
-- 
2.20.1

