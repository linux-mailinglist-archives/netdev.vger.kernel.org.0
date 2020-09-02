Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA625B529
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIBUO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:14:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:48036 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgIBUOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:14:24 -0400
IronPort-SDR: 0gHLwHmbnwWiJPGZhoMAU93B2gzMAUrUNlRvGlqmhvU0LRA8BjbS+/41H/iV4bL6EA0Dl7XrjG
 Odl/En3E96pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="242291930"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="242291930"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 13:14:22 -0700
IronPort-SDR: yRQdCnGzZoQWh+M75Om0pm/qIH7GOEtENji4qqsyrH4FOfHD0CPMqG1ZwgmNz7l4S8bGEZ97CI
 g3FrRmXQpqsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="477778240"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 02 Sep 2020 13:14:21 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 bpf-next 1/7] bpf, x64: use %rcx instead of %rax for tail call retpolines
Date:   Wed,  2 Sep 2020 22:08:09 +0200
Message-Id: <20200902200815.3924-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, %rax is used to store the jump target when BPF program is
emitting the retpoline instructions that are handling the indirect
tailcall.

There is a plan to use %rax for different purpose, which is storing the
tail call counter. In order to preserve this value across the tailcalls,
adjust the BPF indirect tailcalls so that the target program will reside
in %rcx and teach the retpoline instructions about new location of jump
target.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/include/asm/nospec-branch.h | 16 ++++++++--------
 arch/x86/net/bpf_jit_comp.c          | 20 ++++++++++----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index e7752b4038ff..e491c3d9f227 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -314,19 +314,19 @@ static inline void mds_idle_clear_cpu_buffers(void)
  *    lfence
  *    jmp spec_trap
  *  do_rop:
- *    mov %rax,(%rsp) for x86_64
+ *    mov %rcx,(%rsp) for x86_64
  *    mov %edx,(%esp) for x86_32
  *    retq
  *
  * Without retpolines configured:
  *
- *    jmp *%rax for x86_64
+ *    jmp *%rcx for x86_64
  *    jmp *%edx for x86_32
  */
 #ifdef CONFIG_RETPOLINE
 # ifdef CONFIG_X86_64
-#  define RETPOLINE_RAX_BPF_JIT_SIZE	17
-#  define RETPOLINE_RAX_BPF_JIT()				\
+#  define RETPOLINE_RCX_BPF_JIT_SIZE	17
+#  define RETPOLINE_RCX_BPF_JIT()				\
 do {								\
 	EMIT1_off32(0xE8, 7);	 /* callq do_rop */		\
 	/* spec_trap: */					\
@@ -334,7 +334,7 @@ do {								\
 	EMIT3(0x0F, 0xAE, 0xE8); /* lfence */			\
 	EMIT2(0xEB, 0xF9);       /* jmp spec_trap */		\
 	/* do_rop: */						\
-	EMIT4(0x48, 0x89, 0x04, 0x24); /* mov %rax,(%rsp) */	\
+	EMIT4(0x48, 0x89, 0x0C, 0x24); /* mov %rcx,(%rsp) */	\
 	EMIT1(0xC3);             /* retq */			\
 } while (0)
 # else /* !CONFIG_X86_64 */
@@ -352,9 +352,9 @@ do {								\
 # endif
 #else /* !CONFIG_RETPOLINE */
 # ifdef CONFIG_X86_64
-#  define RETPOLINE_RAX_BPF_JIT_SIZE	2
-#  define RETPOLINE_RAX_BPF_JIT()				\
-	EMIT2(0xFF, 0xE0);       /* jmp *%rax */
+#  define RETPOLINE_RCX_BPF_JIT_SIZE	2
+#  define RETPOLINE_RCX_BPF_JIT()				\
+	EMIT2(0xFF, 0xE1);       /* jmp *%rcx */
 # else /* !CONFIG_X86_64 */
 #  define RETPOLINE_EDX_BPF_JIT()				\
 	EMIT2(0xFF, 0xE2)        /* jmp *%edx */
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 7d9ea7b41c71..6fb8c9435980 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -370,7 +370,7 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	EMIT2(0x89, 0xD2);                        /* mov edx, edx */
 	EMIT3(0x39, 0x56,                         /* cmp dword ptr [rsi + 16], edx */
 	      offsetof(struct bpf_array, map.max_entries));
-#define OFFSET1 (41 + RETPOLINE_RAX_BPF_JIT_SIZE) /* Number of bytes to jump */
+#define OFFSET1 (41 + RETPOLINE_RCX_BPF_JIT_SIZE) /* Number of bytes to jump */
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
 	label1 = cnt;
 
@@ -380,36 +380,36 @@ static void emit_bpf_tail_call_indirect(u8 **pprog)
 	 */
 	EMIT2_off32(0x8B, 0x85, -36 - MAX_BPF_STACK); /* mov eax, dword ptr [rbp - 548] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
-#define OFFSET2 (30 + RETPOLINE_RAX_BPF_JIT_SIZE)
+#define OFFSET2 (30 + RETPOLINE_RCX_BPF_JIT_SIZE)
 	EMIT2(X86_JA, OFFSET2);                   /* ja out */
 	label2 = cnt;
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
 
 	/* prog = array->ptrs[index]; */
-	EMIT4_off32(0x48, 0x8B, 0x84, 0xD6,       /* mov rax, [rsi + rdx * 8 + offsetof(...)] */
+	EMIT4_off32(0x48, 0x8B, 0x8C, 0xD6,       /* mov rcx, [rsi + rdx * 8 + offsetof(...)] */
 		    offsetof(struct bpf_array, ptrs));
 
 	/*
 	 * if (prog == NULL)
 	 *	goto out;
 	 */
-	EMIT3(0x48, 0x85, 0xC0);		  /* test rax,rax */
-#define OFFSET3 (8 + RETPOLINE_RAX_BPF_JIT_SIZE)
+	EMIT3(0x48, 0x85, 0xC9);		  /* test rcx,rcx */
+#define OFFSET3 (8 + RETPOLINE_RCX_BPF_JIT_SIZE)
 	EMIT2(X86_JE, OFFSET3);                   /* je out */
 	label3 = cnt;
 
 	/* goto *(prog->bpf_func + prologue_size); */
-	EMIT4(0x48, 0x8B, 0x40,                   /* mov rax, qword ptr [rax + 32] */
+	EMIT4(0x48, 0x8B, 0x49,                   /* mov rcx, qword ptr [rcx + 32] */
 	      offsetof(struct bpf_prog, bpf_func));
-	EMIT4(0x48, 0x83, 0xC0, PROLOGUE_SIZE);   /* add rax, prologue_size */
+	EMIT4(0x48, 0x83, 0xC1, PROLOGUE_SIZE);   /* add rcx, prologue_size */
 
 	/*
-	 * Wow we're ready to jump into next BPF program
+	 * Now we're ready to jump into next BPF program
 	 * rdi == ctx (1st arg)
-	 * rax == prog->bpf_func + prologue_size
+	 * rcx == prog->bpf_func + prologue_size
 	 */
-	RETPOLINE_RAX_BPF_JIT();
+	RETPOLINE_RCX_BPF_JIT();
 
 	/* out: */
 	BUILD_BUG_ON(cnt - label1 != OFFSET1);
-- 
2.20.1

