Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F89E1AD382
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 02:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgDQAAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 20:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726578AbgDQAAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 20:00:15 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A44C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 17:00:13 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id r5so208215uad.8
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 17:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=o1ixzjSmDRXRxbpBdm6/pKUbvi6GyqGWdNx6NzDK7xY=;
        b=PXCdAK3d3tBaw6kqsPb8vcGis/R2zpp+aDNtUJZYEVbxC6NrSt5rJWpNcyGVQkh/KD
         jP9lLHVBljzVSbiwZ1EWcc+E8XIlV+8gi/K0PVMJ9CDcRvC2SAsHH6vbDYHOrTmvmbZk
         wayBiSv4AxqUCm/c982HxZmDRbeHjqN8TtlV21Bk5+MIPjXZfeSxbUGmfGU8JhjqZiq0
         4JJojRnm3SCXVCF8Msgbxc2Zrz+a2rV0aebyHg+oWZw/1rqjUg0V/iwdWWiHEScWCFXK
         9IoEyZOc0VnNherFWKHNpI864ABD2DEBI3vbPYqXEdtwKm97Xnh436XbPY7Ulsz1tqZt
         NwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=o1ixzjSmDRXRxbpBdm6/pKUbvi6GyqGWdNx6NzDK7xY=;
        b=ADTydx8K7PwuFi3EblSsjlkj3uzubRTzIOAkis3buRUPPHVf+JYlS5NO3jhv8YxEjd
         P0jxH5M+P7zWexzsH+rzp1N0hcv5l3ukCoaplDKgfWM5rxE17ZixzS4XMaU/zporjMPW
         3oUJYY7kzURSEWYqx7czUkog8MzlP0jjoiv4nTVlNYJICSeeR8GP8p5tfVhj3nzOAOpr
         82iOCl3KyzuItmo+UEBphziSCvpicstav6sjiulLrxCq4ngJuMP46800FkH4aUjXF9vj
         n0AL5Z3GxRVDd4nj/QKhcMpAnkPLCbZcXZ3QCahr+eKVtXViLs4zzM4GNrJhGUrXY0+M
         jjJA==
X-Gm-Message-State: AGi0PuZodiMKtWSI8i5q2L5Hj1d2M3JvPukJyiRRvLipG5sc03Hjm0qF
        CKewLD1XTCcyrJQVL+WWMXYJVn0MAA==
X-Google-Smtp-Source: APiQypLGhwVpsiFWV0kz+aHZGYo2KNhREwT7oZoT3nuKhl0+e/KZ16M79NTvjR0IzM62ub0eXcugeeg7Ww==
X-Received: by 2002:a1f:9cc8:: with SMTP id f191mr449820vke.68.1587081612594;
 Thu, 16 Apr 2020 17:00:12 -0700 (PDT)
Date:   Fri, 17 Apr 2020 02:00:06 +0200
Message-Id: <20200417000007.10734-1-jannh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2 1/2] bpf: Forbid XADD on spilled pointers for unprivileged users
From:   Jann Horn <jannh@google.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 kernel/bpf/verifier.c                         | 28 +++++++++++++------
 .../bpf/verifier/value_illegal_alu.c          |  1 +
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 38cfcf701eeb7..9e92d3d5ffd17 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2118,6 +2118,15 @@ static bool register_is_const(struct bpf_reg_state *reg)
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
@@ -2308,6 +2317,16 @@ static int check_stack_read(struct bpf_verifier_env *env,
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
@@ -2673,15 +2692,6 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
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

base-commit: edadedf1c5b4e4404192a0a4c3c0c05e3b7672ab
-- 
2.26.1.301.g55bc3eb7cb9-goog

