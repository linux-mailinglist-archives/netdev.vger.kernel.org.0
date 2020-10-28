Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268F429D56C
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgJ1WCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbgJ1WCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:02:24 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4693D247FC;
        Wed, 28 Oct 2020 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603905317;
        bh=09phZTWmPiU017OVb0I9AGdf0nGRpJdaUisznwA8rFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzhzaduvGQhnnQYFgwb52JDBHh3+ug90qZrxGFJGWQCM6lPNWMTHRifXXXtMs/v2Q
         zxNhne+WYa1DRL0xtHYkvDE0PcFjgU/OFrJFWRajRqSaTQhvTFd0PJWHJpUnu310IL
         T4i0vL8mexPWBhTWWF4yOI11+ZNi9tvcZhk5lGBw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize)) to disable GCSE
Date:   Wed, 28 Oct 2020 18:15:05 +0100
Message-Id: <20201028171506.15682-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201028171506.15682-1-ardb@kernel.org>
References: <20201028171506.15682-1-ardb@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
function scope __attribute__((optimize("-fno-gcse"))), to disable a
GCC specific optimization that was causing trouble on x86 builds, and
was not expected to have any positive effect in the first place.

However, as the GCC manual documents, __attribute__((optimize))
is not for production use, and results in all other optimization
options to be forgotten for the function in question. This can
cause all kinds of trouble, but in one particular reported case,
it causes -fno-asynchronous-unwind-tables to be disregarded,
resulting in .eh_frame info to be emitted for the function.

This reverts commit 3193c0836, and instead, it disables the -fgcse
optimization for the entire source file, but only when building for
X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
original commit states that CONFIG_RETPOLINE=n triggers the issue,
whereas CONFIG_RETPOLINE=y performs better without the optimization,
so it is kept disabled in both cases.

Fixes: 3193c0836 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/compiler-gcc.h   | 2 --
 include/linux/compiler_types.h | 4 ----
 kernel/bpf/Makefile            | 6 +++++-
 kernel/bpf/core.c              | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index d1e3c6896b71..5deb37024574 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -175,5 +175,3 @@
 #else
 #define __diag_GCC_8(s)
 #endif
-
-#define __no_fgcse __attribute__((optimize("-fno-gcse")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 6e390d58a9f8..ac3fa37a84f9 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -247,10 +247,6 @@ struct ftrace_likely_data {
 #define asm_inline asm
 #endif
 
-#ifndef __no_fgcse
-# define __no_fgcse
-#endif
-
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index bdc8cd1b6767..c1b9f71ee6aa 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -1,6 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y := core.o
-CFLAGS_core.o += $(call cc-disable-warning, override-init)
+ifneq ($(CONFIG_BPF_JIT_ALWAYS_ON),y)
+# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
+cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
+endif
+CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9268d77898b7..55454d2278b1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1369,7 +1369,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
  *
  * Decode and execute eBPF instructions.
  */
-static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
+static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-- 
2.17.1

