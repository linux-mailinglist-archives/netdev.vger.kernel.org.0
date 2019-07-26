Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF44676814
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbfGZNmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387418AbfGZNmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF6F22BF5;
        Fri, 26 Jul 2019 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148525;
        bh=jwyKKrIH0Sb3LUWowXcuRJ297ShxLiOtHjsxfr0bXBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pO5aPHJxePB3A5na1SQEVi0ksbB8X4/W0lmianAPdtLFJ4Sapxqu0Upn/899C8v56
         Bav46PtE7M6gNmUjihALnfKi7vW0dOLYuRYb4W3XW6koCN/BsNes+mGnzobjYKd/fr
         qj69X3excgIFeu6Hx8XSpCCWm274qB/xugGW6LVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 82/85] bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()
Date:   Fri, 26 Jul 2019 09:39:32 -0400
Message-Id: <20190726133936.11177-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 3193c0836f203a91bef96d88c64cccf0be090d9c ]

On x86-64, with CONFIG_RETPOLINE=n, GCC's "global common subexpression
elimination" optimization results in ___bpf_prog_run()'s jumptable code
changing from this:

	select_insn:
		jmp *jumptable(, %rax, 8)
		...
	ALU64_ADD_X:
		...
		jmp *jumptable(, %rax, 8)
	ALU_ADD_X:
		...
		jmp *jumptable(, %rax, 8)

to this:

	select_insn:
		mov jumptable, %r12
		jmp *(%r12, %rax, 8)
		...
	ALU64_ADD_X:
		...
		jmp *(%r12, %rax, 8)
	ALU_ADD_X:
		...
		jmp *(%r12, %rax, 8)

The jumptable address is placed in a register once, at the beginning of
the function.  The function execution can then go through multiple
indirect jumps which rely on that same register value.  This has a few
issues:

1) Objtool isn't smart enough to be able to track such a register value
   across multiple recursive indirect jumps through the jump table.

2) With CONFIG_RETPOLINE enabled, this optimization actually results in
   a small slowdown.  I measured a ~4.7% slowdown in the test_bpf
   "tcpdump port 22" selftest.

   This slowdown is actually predicted by the GCC manual:

     Note: When compiling a program using computed gotos, a GCC
     extension, you may get better run-time performance if you
     disable the global common subexpression elimination pass by
     adding -fno-gcse to the command line.

So just disable the optimization for this function.

Fixes: e55a73251da3 ("bpf: Fix ORC unwinding in non-JIT BPF code")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/30c3ca29ba037afcbd860a8672eef0021addf9fe.1563413318.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h   | 2 ++
 include/linux/compiler_types.h | 4 ++++
 kernel/bpf/core.c              | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index e8579412ad21..d7ee4c6bad48 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -170,3 +170,5 @@
 #else
 #define __diag_GCC_8(s)
 #endif
+
+#define __no_fgcse __attribute__((optimize("-fno-gcse")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 19e58b9138a0..0454d82f8bd8 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -187,6 +187,10 @@ struct ftrace_likely_data {
 #define asm_volatile_goto(x...) asm goto(x)
 #endif
 
+#ifndef __no_fgcse
+# define __no_fgcse
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 080e2bb644cc..ebfd189916dc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1295,7 +1295,7 @@ bool bpf_opcode_in_insntable(u8 code)
  *
  * Decode and execute eBPF instructions.
  */
-static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
+static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-- 
2.20.1

