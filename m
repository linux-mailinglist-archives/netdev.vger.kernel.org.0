Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32A7F4087
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfKHGkv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 01:40:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52512 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfKHGku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:40:50 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86ceb6018517
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 22:40:48 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6snbn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 22:40:47 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 22:40:45 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 83ED6760F61; Thu,  7 Nov 2019 22:40:45 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 03/18] bpf: Introduce BPF trampoline
Date:   Thu, 7 Nov 2019 22:40:24 -0800
Message-ID: <20191108064039.2041889-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108064039.2041889-1-ast@kernel.org>
References: <20191108064039.2041889-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=4 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911080064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF trampoline concept to allow kernel code to call into BPF programs
with practically zero overhead.  The trampoline generation logic is
architecture dependent.  It's converting native calling convention into BPF
calling convention.  BPF ISA is 64-bit (even on 32-bit architectures). The
registers R1 to R5 are used to pass arguments into BPF functions. The main BPF
program accepts only single argument "ctx" in R1. Whereas CPU native calling
convention is different. x86-64 is passing first 6 arguments in registers
and the rest on the stack. x86-32 is passing first 3 arguments in registers.
sparc64 is passing first 6 in registers. And so on.

The trampolines between BPF and kernel already exist.  BPF_CALL_x macros in
include/linux/filter.h statically compile trampolines from BPF into kernel
helpers. They convert up to five u64 arguments into kernel C pointers and
integers. On 64-bit architectures this BPF_to_kernel trampolines are nops. On
32-bit architecture they're meaningful.

The opposite job kernel_to_BPF trampolines is done by CAST_TO_U64 macros and
__bpf_trace_##call() shim functions in include/trace/bpf_probe.h. They convert
kernel function arguments into array of u64s that BPF program consumes via
R1=ctx pointer.

This patch set is doing the same job as __bpf_trace_##call() static
trampolines, but dynamically for any kernel function. There are ~22k global
kernel functions that are attachable via nop at function entry. The function
arguments and types are described in BTF.  The job of btf_distill_func_proto()
function is to extract useful information from BTF into "function model" that
architecture dependent trampoline generators will use to generate assembly code
to cast kernel function arguments into array of u64s.  For example the kernel
function eth_type_trans has two pointers. They will be casted to u64 and stored
into stack of generated trampoline. The pointer to that stack space will be
passed into BPF program in R1. On x86-64 such generated trampoline will consume
16 bytes of stack and two stores of %rdi and %rsi into stack. The verifier will
make sure that only two u64 are accessed read-only by BPF program. The verifier
will also recognize the precise type of the pointers being accessed and will
not allow typecasting of the pointer to a different type within BPF program.

The tracing use case in the datacenter demonstrated that certain key kernel
functions have (like tcp_retransmit_skb) have 2 or more kprobes that are always
active.  Other functions have both kprobe and kretprobe.  So it is essential to
keep both kernel code and BPF programs executing at maximum speed. Hence
generated BPF trampoline is re-generated every time new program is attached or
detached to maintain maximum performance.

To avoid the high cost of retpoline the attached BPF programs are called
directly. __bpf_prog_enter/exit() are used to support per-program execution
stats.  In the future this logic will be optimized further by adding support
for bpf_stats_enabled_key inside generated assembly code. Introduction of
preemptible and sleepable BPF programs will completely remove the need to call
to __bpf_prog_enter/exit().

Detach of a BPF program from the trampoline should not fail. To avoid memory
allocation in detach path the half of the page is used as a reserve and flipped
after each attach/detach. 2k bytes is enough to call 40+ BPF programs directly
which is enough for BPF tracing use cases. This limit can be increased in the
future.

BPF_TRACE_FENTRY programs have access to raw kernel function arguments while
BPF_TRACE_FEXIT programs have access to kernel return value as well. Often
kprobe BPF program remembers function arguments in a map while kretprobe
fetches arguments from a map and analyzes them together with return value.
BPF_TRACE_FEXIT accelerates this typical use case.

Recursion prevention for kprobe BPF programs is done via per-cpu
bpf_prog_active counter. In practice that turned out to be a mistake. It
caused programs to randomly skip execution. The tracing tools missed results
they were looking for. Hence BPF trampoline doesn't provide builtin recursion
prevention. It's a job of BPF program itself and will be addressed in the
follow up patches.

BPF trampoline is intended to be used beyond tracing and fentry/fexit use cases
in the future. For example to remove retpoline cost from XDP programs.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 211 +++++++++++++++++++++++++++++-
 include/linux/bpf.h         |  98 ++++++++++++++
 include/uapi/linux/bpf.h    |   2 +
 kernel/bpf/Makefile         |   1 +
 kernel/bpf/btf.c            |  77 ++++++++++-
 kernel/bpf/core.c           |   1 +
 kernel/bpf/syscall.c        |  53 +++++++-
 kernel/bpf/trampoline.c     | 250 ++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c       |  39 ++++++
 9 files changed, 722 insertions(+), 10 deletions(-)
 create mode 100644 kernel/bpf/trampoline.c

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index bb8467fd6715..9ccf7cd51a21 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -98,6 +98,7 @@ static int bpf_size_to_x86_bytes(int bpf_size)
 
 /* Pick a register outside of BPF range for JIT internal work */
 #define AUX_REG (MAX_BPF_JIT_REG + 1)
+#define X86_REG_R9 (MAX_BPF_JIT_REG + 2)
 
 /*
  * The following table maps BPF registers to x86-64 registers.
@@ -106,8 +107,8 @@ static int bpf_size_to_x86_bytes(int bpf_size)
  * register in load/store instructions, it always needs an
  * extra byte of encoding and is callee saved.
  *
- * Also x86-64 register R9 is unused. x86-64 register R10 is
- * used for blinding (if enabled).
+ * x86-64 register R9 is not used by BPF programs, but can be used by BPF
+ * trampoline. x86-64 register R10 is used for blinding (if enabled).
  */
 static const int reg2hex[] = {
 	[BPF_REG_0] = 0,  /* RAX */
@@ -123,6 +124,7 @@ static const int reg2hex[] = {
 	[BPF_REG_FP] = 5, /* RBP readonly */
 	[BPF_REG_AX] = 2, /* R10 temp register */
 	[AUX_REG] = 3,    /* R11 temp register */
+	[X86_REG_R9] = 1, /* R9 register, 6th function argument */
 };
 
 static const int reg2pt_regs[] = {
@@ -150,6 +152,7 @@ static bool is_ereg(u32 reg)
 			     BIT(BPF_REG_7) |
 			     BIT(BPF_REG_8) |
 			     BIT(BPF_REG_9) |
+			     BIT(X86_REG_R9) |
 			     BIT(BPF_REG_AX));
 }
 
@@ -1234,6 +1237,210 @@ xadd:			if (is_imm8(insn->off))
 	return proglen;
 }
 
+static void save_regs(struct btf_func_model *m, u8 **prog, int nr_args,
+		      int stack_size)
+{
+	int i;
+	/* Store function arguments to stack.
+	 * For a function that accepts two pointers the sequence will be:
+	 * mov QWORD PTR [rbp-0x10],rdi
+	 * mov QWORD PTR [rbp-0x8],rsi
+	 */
+	for (i = 0; i < min(nr_args, 6); i++)
+		emit_stx(prog, bytes_to_bpf_size(m->arg_size[i]),
+			 BPF_REG_FP,
+			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
+			 -(stack_size - i * 8));
+}
+
+static void restore_regs(struct btf_func_model *m, u8 **prog, int nr_args,
+			 int stack_size)
+{
+	int i;
+
+	/* Restore function arguments from stack.
+	 * For a function that accepts two pointers the sequence will be:
+	 * EMIT4(0x48, 0x8B, 0x7D, 0xF0); mov rdi,QWORD PTR [rbp-0x10]
+	 * EMIT4(0x48, 0x8B, 0x75, 0xF8); mov rsi,QWORD PTR [rbp-0x8]
+	 */
+	for (i = 0; i < min(nr_args, 6); i++)
+		emit_ldx(prog, bytes_to_bpf_size(m->arg_size[i]),
+			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
+			 BPF_REG_FP,
+			 -(stack_size - i * 8));
+}
+
+static int invoke_bpf(struct btf_func_model *m, u8 **pprog,
+		      struct bpf_prog **progs, int prog_cnt, int stack_size)
+{
+	u8 *prog = *pprog;
+	int cnt = 0, i;
+
+	for (i = 0; i < prog_cnt; i++) {
+		if (emit_call(&prog, __bpf_prog_enter, prog))
+			return -EINVAL;
+		/* remember prog start time returned by __bpf_prog_enter */
+		emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
+
+		/* arg1: lea rdi, [rbp - stack_size] */
+		EMIT4(0x48, 0x8D, 0x7D, -stack_size);
+		/* arg2: progs[i]->insnsi for interpreter */
+		if (!progs[i]->jited)
+			emit_mov_imm64(&prog, BPF_REG_2,
+				       (long) progs[i]->insnsi >> 32,
+				       (u32) (long) progs[i]->insnsi);
+		/* call JITed bpf program or interpreter */
+		if (emit_call(&prog, progs[i]->bpf_func, prog))
+			return -EINVAL;
+
+		/* arg1: mov rdi, progs[i] */
+		emit_mov_imm64(&prog, BPF_REG_1, (long) progs[i] >> 32,
+			       (u32) (long) progs[i]);
+		/* arg2: mov rsi, rbx <- start time in nsec */
+		emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
+		if (emit_call(&prog, __bpf_prog_exit, prog))
+			return -EINVAL;
+	}
+	*pprog = prog;
+	return 0;
+}
+
+/* Example:
+ * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
+ * its 'struct btf_func_model' will be nr_args=2
+ * The assembly code when eth_type_trans is executing after trampoline:
+ *
+ * push rbp
+ * mov rbp, rsp
+ * sub rsp, 16                     // space for skb and dev
+ * push rbx                        // temp regs to pass start time
+ * mov qword ptr [rbp - 16], rdi   // save skb pointer to stack
+ * mov qword ptr [rbp - 8], rsi    // save dev pointer to stack
+ * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
+ * mov rbx, rax                    // remember start time in bpf stats are enabled
+ * lea rdi, [rbp - 16]             // R1==ctx of bpf prog
+ * call addr_of_jited_FENTRY_prog
+ * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
+ * mov rsi, rbx                    // prog start time
+ * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
+ * mov rdi, qword ptr [rbp - 16]   // restore skb pointer from stack
+ * mov rsi, qword ptr [rbp - 8]    // restore dev pointer from stack
+ * pop rbx
+ * leave
+ * ret
+ *
+ * eth_type_trans has 5 byte nop at the beginning. These 5 bytes will be
+ * replaced with 'call generated_bpf_trampoline'. When it returns
+ * eth_type_trans will continue executing with original skb and dev pointers.
+ *
+ * The assembly code when eth_type_trans is called from trampoline:
+ *
+ * push rbp
+ * mov rbp, rsp
+ * sub rsp, 24                     // space for skb, dev, return value
+ * push rbx                        // temp regs to pass start time
+ * mov qword ptr [rbp - 24], rdi   // save skb pointer to stack
+ * mov qword ptr [rbp - 16], rsi   // save dev pointer to stack
+ * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
+ * mov rbx, rax                    // remember start time if bpf stats are enabled
+ * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
+ * call addr_of_jited_FENTRY_prog  // bpf prog can access skb and dev
+ * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
+ * mov rsi, rbx                    // prog start time
+ * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
+ * mov rdi, qword ptr [rbp - 24]   // restore skb pointer from stack
+ * mov rsi, qword ptr [rbp - 16]   // restore dev pointer from stack
+ * call eth_type_trans+5           // execute body of eth_type_trans
+ * mov qword ptr [rbp - 8], rax    // save return value
+ * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
+ * mov rbx, rax                    // remember start time in bpf stats are enabled
+ * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
+ * call addr_of_jited_FEXIT_prog   // bpf prog can access skb, dev, return value
+ * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
+ * mov rsi, rbx                    // prog start time
+ * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
+ * mov rax, qword ptr [rbp - 8]    // restore eth_type_trans's return value
+ * pop rbx
+ * leave
+ * add rsp, 8                      // skip eth_type_trans's frame
+ * ret                             // return to its caller
+ */
+int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags,
+				struct bpf_prog **fentry_progs, int fentry_cnt,
+				struct bpf_prog **fexit_progs, int fexit_cnt,
+				void *orig_call)
+{
+	int cnt = 0, nr_args = m->nr_args;
+	int stack_size = nr_args * 8;
+	u8 *prog;
+
+	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
+	if (nr_args > 6)
+		return -ENOTSUPP;
+
+	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
+	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+		return -EINVAL;
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG)
+		stack_size += 8; /* room for return value of orig_call */
+
+	if (flags & BPF_TRAMP_F_SKIP_FRAME)
+		/* skip patched call instruction and point orig_call to actual
+		 * body of the kernel function.
+		 */
+		orig_call += X86_CALL_SIZE;
+
+	prog = image;
+
+	EMIT1(0x55);		 /* push rbp */
+	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
+	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
+	EMIT1(0x53);		 /* push rbx */
+
+	save_regs(m, &prog, nr_args, stack_size);
+
+	if (fentry_cnt)
+		if (invoke_bpf(m, &prog, fentry_progs, fentry_cnt, stack_size))
+			return -EINVAL;
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		if (fentry_cnt)
+			restore_regs(m, &prog, nr_args, stack_size);
+
+		/* call original function */
+		if (emit_call(&prog, orig_call, prog))
+			return -EINVAL;
+		/* remember return value in a stack for bpf prog to access */
+		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
+	}
+
+	if (fexit_cnt)
+		if (invoke_bpf(m, &prog, fexit_progs, fexit_cnt, stack_size))
+			return -EINVAL;
+
+	if (flags & BPF_TRAMP_F_RESTORE_REGS)
+		restore_regs(m, &prog, nr_args, stack_size);
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG)
+		/* restore original return value back into RAX */
+		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
+
+	EMIT1(0x5B); /* pop rbx */
+	EMIT1(0xC9); /* leave */
+	if (flags & BPF_TRAMP_F_SKIP_FRAME)
+		/* skip our return address and return to parent */
+		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
+	EMIT1(0xC3); /* ret */
+	/* One half of the page has active running trampoline.
+	 * Another half is an area for next trampoline.
+	 * Make sure the trampoline generation logic doesn't overflow.
+	 */
+	if (WARN_ON_ONCE(prog - (u8 *)image > PAGE_SIZE / 2 - BPF_INSN_SAFETY))
+		return -EFAULT;
+	return 0;
+}
+
 struct x64_jit_data {
 	struct bpf_binary_header *header;
 	int *addrs;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8b90db25348a..9206b7e86dde 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -14,6 +14,7 @@
 #include <linux/numa.h>
 #include <linux/wait.h>
 #include <linux/u64_stats_sync.h>
+#include <linux/refcount.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -384,6 +385,94 @@ struct bpf_prog_stats {
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
 
+struct btf_func_model {
+	u8 ret_size;
+	u8 nr_args;
+	u8 arg_size[MAX_BPF_FUNC_ARGS];
+};
+
+/* Restore arguments before returning from trampoline to let original function
+ * continue executing. This flag is used for fentry progs when there are no
+ * fexit progs.
+ */
+#define BPF_TRAMP_F_RESTORE_REGS	BIT(0)
+/* Call original function after fentry progs, but before fexit progs.
+ * Makes sense for fentry/fexit, normal calls and indirect calls.
+ */
+#define BPF_TRAMP_F_CALL_ORIG		BIT(1)
+/* Skip current frame and return to parent.  Makes sense for fentry/fexit
+ * programs only. Should not be used with normal calls and indirect calls.
+ */
+#define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
+
+/* Different use cases for BPF trampoline:
+ * 1. replace nop at the function entry (kprobe equivalent)
+ *    flags = BPF_TRAMP_F_RESTORE_REGS
+ *    fentry = a set of programs to run before returning from trampoline
+ *
+ * 2. replace nop at the function entry (kprobe + kretprobe equivalent)
+ *    flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME
+ *    orig_call = fentry_ip + MCOUNT_INSN_SIZE
+ *    fentry = a set of program to run before calling original function
+ *    fexit = a set of program to run after original function
+ *
+ * 3. replace direct call instruction anywhere in the function body
+ *    or assign a function pointer for indirect call (like tcp_congestion_ops->cong_avoid)
+ *    With flags = 0
+ *      fentry = a set of programs to run before returning from trampoline
+ *    With flags = BPF_TRAMP_F_CALL_ORIG
+ *      orig_call = original callback addr or direct function addr
+ *      fentry = a set of program to run before calling original function
+ *      fexit = a set of program to run after original function
+ */
+int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags,
+				struct bpf_prog **fentry_progs, int fentry_cnt,
+				struct bpf_prog **fexit_progs, int fexit_cnt,
+				void *orig_call);
+/* these two functions are called from generated trampoline */
+u64 notrace __bpf_prog_enter(void);
+void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
+
+enum bpf_tramp_prog_type {
+	BPF_TRAMP_FENTRY,
+	BPF_TRAMP_FEXIT,
+	BPF_TRAMP_MAX
+};
+
+struct bpf_trampoline {
+	struct hlist_node hlist;
+	refcount_t refcnt;
+	u64 key;
+	struct {
+		struct btf_func_model model;
+		void *addr;
+	} func;
+	struct hlist_head progs_hlist[BPF_TRAMP_MAX];
+	int progs_cnt[BPF_TRAMP_MAX];
+	void *image;
+	u64 selector;
+};
+#ifdef CONFIG_BPF_JIT
+struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
+int bpf_trampoline_link_prog(struct bpf_prog *prog);
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
+void bpf_trampoline_put(struct bpf_trampoline *tr);
+#else
+static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
+{
+	return NULL;
+}
+static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
+static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+{
+	return -ENOTSUPP;
+}
+static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
+#endif
+
 struct bpf_prog_aux {
 	atomic_t refcnt;
 	u32 used_map_cnt;
@@ -398,6 +487,9 @@ struct bpf_prog_aux {
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
+	enum bpf_tramp_prog_type trampoline_prog_type;
+	struct bpf_trampoline *trampoline;
+	struct hlist_node tramp_hlist;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
@@ -784,6 +876,12 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      u32 *next_btf_id);
 u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *, int);
 
+int btf_distill_func_proto(struct bpf_verifier_log *log,
+			   struct btf *btf,
+			   const struct btf_type *func_proto,
+			   const char *func_name,
+			   struct btf_func_model *m);
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index df6809a76404..69c200e6e696 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -201,6 +201,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
 	BPF_TRACE_RAW_TP,
+	BPF_TRACE_FENTRY,
+	BPF_TRACE_FEXIT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index e1d9adb212f9..3f671bf617e8 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
+obj-$(CONFIG_BPF_JIT) += trampoline.o
 obj-$(CONFIG_BPF_SYSCALL) += btf.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4639c4ba9a9b..9e1164e5b429 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3517,13 +3517,18 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		args++;
 		nr_args--;
 	}
-	if (arg >= nr_args) {
+
+	if (prog->expected_attach_type == BPF_TRACE_FEXIT &&
+	    arg == nr_args) {
+		/* function return type */
+		t = btf_type_by_id(btf_vmlinux, t->type);
+	} else if (arg >= nr_args) {
 		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
-			tname, arg);
+			tname, arg + 1);
 		return false;
+	} else {
+		t = btf_type_by_id(btf_vmlinux, args[arg].type);
 	}
-
-	t = btf_type_by_id(btf_vmlinux, args[arg].type);
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
 		t = btf_type_by_id(btf_vmlinux, t->type);
@@ -3784,6 +3789,70 @@ u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn, int arg)
 	return btf_id;
 }
 
+static int __get_type_size(struct btf *btf, u32 btf_id,
+			   const struct btf_type **bad_type)
+{
+	const struct btf_type *t;
+
+	if (!btf_id)
+		/* void */
+		return 0;
+	t = btf_type_by_id(btf, btf_id);
+	while (t && btf_type_is_modifier(t))
+		t = btf_type_by_id(btf, t->type);
+	if (!t)
+		return -EINVAL;
+	if (btf_type_is_ptr(t))
+		/* kernel size of pointer. Not BPF's size of pointer*/
+		return sizeof(void *);
+	if (btf_type_is_int(t) || btf_type_is_enum(t))
+		return t->size;
+	*bad_type = t;
+	return -EINVAL;
+}
+
+int btf_distill_func_proto(struct bpf_verifier_log *log,
+			   struct btf *btf,
+			   const struct btf_type *func,
+			   const char *tname,
+			   struct btf_func_model *m)
+{
+	const struct btf_param *args;
+	const struct btf_type *t;
+	u32 i, nargs;
+	int ret;
+
+	args = (const struct btf_param *)(func + 1);
+	nargs = btf_type_vlen(func);
+	if (nargs >= MAX_BPF_FUNC_ARGS) {
+		bpf_log(log,
+			"The function %s has %d arguments. Too many.\n",
+			tname, nargs);
+		return -EINVAL;
+	}
+	ret = __get_type_size(btf, func->type, &t);
+	if (ret < 0) {
+		bpf_log(log,
+			"The function %s return type %s is unsupported.\n",
+			tname, btf_kind_str[BTF_INFO_KIND(t->info)]);
+		return -EINVAL;
+	}
+	m->ret_size = ret;
+
+	for (i = 0; i < nargs; i++) {
+		ret = __get_type_size(btf, args[i].type, &t);
+		if (ret < 0) {
+			bpf_log(log,
+				"The function %s arg%d type %s is unsupported.\n",
+				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
+			return -EINVAL;
+		}
+		m->arg_size[i] = ret;
+	}
+	m->nr_args = nargs;
+	return 0;
+}
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m)
 {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c4bcec1014a9..75ad0f907eef 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2011,6 +2011,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	if (aux->prog->has_callchain_buf)
 		put_callchain_buffers();
 #endif
+	bpf_trampoline_put(aux->trampoline);
 	for (i = 0; i < aux->func_cnt; i++)
 		bpf_jit_free(aux->func[i]);
 	if (aux->func_cnt) {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6d9ce95e5a8d..e2e37bea86bc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1799,6 +1799,49 @@ static int bpf_obj_get(const union bpf_attr *attr)
 				attr->file_flags);
 }
 
+static int bpf_tracing_prog_release(struct inode *inode, struct file *filp)
+{
+	struct bpf_prog *prog = filp->private_data;
+
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
+	bpf_prog_put(prog);
+	return 0;
+}
+
+static const struct file_operations bpf_tracing_prog_fops = {
+	.release	= bpf_tracing_prog_release,
+	.read		= bpf_dummy_read,
+	.write		= bpf_dummy_write,
+};
+
+static int bpf_tracing_prog_attach(struct bpf_prog *prog)
+{
+	int tr_fd, err;
+
+	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
+	    prog->expected_attach_type != BPF_TRACE_FEXIT) {
+		err = -EINVAL;
+		goto out_put_prog;
+	}
+
+	err = bpf_trampoline_link_prog(prog);
+	if (err)
+		goto out_put_prog;
+
+	tr_fd = anon_inode_getfd("bpf-tracing-prog", &bpf_tracing_prog_fops,
+				 prog, O_CLOEXEC);
+	if (tr_fd < 0) {
+		WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
+		err = tr_fd;
+		goto out_put_prog;
+	}
+	return tr_fd;
+
+out_put_prog:
+	bpf_prog_put(prog);
+	return err;
+}
+
 struct bpf_raw_tracepoint {
 	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
@@ -1850,14 +1893,16 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 
 	if (prog->type == BPF_PROG_TYPE_TRACING) {
 		if (attr->raw_tracepoint.name) {
-			/* raw_tp name should not be specified in raw_tp
-			 * programs that were verified via in-kernel BTF info
+			/* The attach point for this category of programs
+			 * should be specified via btf_id during program load.
 			 */
 			err = -EINVAL;
 			goto out_put_prog;
 		}
-		/* raw_tp name is taken from type name instead */
-		tp_name = prog->aux->attach_func_name;
+		if (prog->expected_attach_type == BPF_TRACE_RAW_TP)
+			tp_name = prog->aux->attach_func_name;
+		else
+			return bpf_tracing_prog_attach(prog);
 	} else {
 		if (strncpy_from_user(buf,
 				      u64_to_user_ptr(attr->raw_tracepoint.name),
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
new file mode 100644
index 000000000000..814d749dd4f1
--- /dev/null
+++ b/kernel/bpf/trampoline.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+#include <linux/hash.h>
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+/* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
+#define TRAMPOLINE_HASH_BITS 10
+#define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
+
+static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
+
+static DEFINE_MUTEX(trampoline_mutex);
+
+struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
+{
+	struct bpf_trampoline *tr;
+	struct hlist_head *head;
+	void *image;
+	int i;
+
+	mutex_lock(&trampoline_mutex);
+	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
+	hlist_for_each_entry(tr, head, hlist) {
+		if (tr->key == key) {
+			refcount_inc(&tr->refcnt);
+			goto out;
+		}
+	}
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr)
+		goto out;
+
+	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
+	image = bpf_jit_alloc_exec(PAGE_SIZE);
+	if (!image) {
+		kfree(tr);
+		tr = NULL;
+		goto out;
+	}
+
+	tr->key = key;
+	INIT_HLIST_NODE(&tr->hlist);
+	hlist_add_head(&tr->hlist, head);
+	refcount_set(&tr->refcnt, 1);
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
+
+	set_vm_flush_reset_perms(image);
+	/* Keep image as writeable. The alternative is to keep flipping ro/rw
+	 * everytime new program is attached or detached.
+	 */
+	set_memory_x((long)image, 1);
+	tr->image = image;
+out:
+	mutex_unlock(&trampoline_mutex);
+	return tr;
+}
+
+/* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
+ * bytes on x86.  Pick a number to fit into PAGE_SIZE / 2
+ */
+#define BPF_MAX_TRAMP_PROGS 40
+
+static int bpf_trampoline_update(struct bpf_trampoline *tr)
+{
+	void *old_image = tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
+	void *new_image = tr->image + (tr->selector & 1) * PAGE_SIZE/2;
+	struct bpf_prog *progs_to_run[BPF_MAX_TRAMP_PROGS];
+	int fentry_cnt = tr->progs_cnt[BPF_TRAMP_FENTRY];
+	int fexit_cnt = tr->progs_cnt[BPF_TRAMP_FEXIT];
+	struct bpf_prog **progs, **fentry, **fexit;
+	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
+	struct bpf_prog_aux *aux;
+	int err;
+
+	if (fentry_cnt + fexit_cnt == 0) {
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL_TO_NOP,
+					 old_image, NULL);
+		tr->selector = 0;
+		goto out;
+	}
+
+	/* populate fentry progs */
+	fentry = progs = progs_to_run;
+	hlist_for_each_entry(aux, &tr->progs_hlist[BPF_TRAMP_FENTRY], tramp_hlist)
+		*progs++ = aux->prog;
+
+	/* populate fexit progs */
+	fexit = progs;
+	hlist_for_each_entry(aux, &tr->progs_hlist[BPF_TRAMP_FEXIT], tramp_hlist)
+		*progs++ = aux->prog;
+
+	if (fexit_cnt)
+		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
+
+	err = arch_prepare_bpf_trampoline(new_image, &tr->func.model, flags,
+					  fentry, fentry_cnt,
+					  fexit, fexit_cnt,
+					  tr->func.addr);
+	if (err)
+		goto out;
+
+	if (tr->selector)
+		/* progs already running at this address */
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL_TO_CALL,
+					 old_image, new_image);
+	else
+		/* first time registering */
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_NOP_TO_CALL,
+					 NULL, new_image);
+	if (err)
+		goto out;
+	tr->selector++;
+out:
+	return err;
+}
+
+static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
+{
+	switch (t) {
+	case BPF_TRACE_FENTRY:
+		return BPF_TRAMP_FENTRY;
+	default:
+		return BPF_TRAMP_FEXIT;
+	}
+}
+
+int bpf_trampoline_link_prog(struct bpf_prog *prog)
+{
+	enum bpf_tramp_prog_type kind;
+	struct bpf_trampoline *tr;
+	int err = 0;
+
+	tr = prog->aux->trampoline;
+	kind = bpf_attach_type_to_tramp(prog->expected_attach_type);
+	mutex_lock(&trampoline_mutex);
+	if (tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]
+	    >= BPF_MAX_TRAMP_PROGS) {
+		err = -E2BIG;
+		goto out;
+	}
+	if (!hlist_unhashed(&prog->aux->tramp_hlist)) {
+		/* prog already linked */
+		err = -EBUSY;
+		goto out;
+	}
+	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
+	tr->progs_cnt[kind]++;
+	err = bpf_trampoline_update(prog->aux->trampoline);
+	if (err) {
+		hlist_del(&prog->aux->tramp_hlist);
+		tr->progs_cnt[kind]--;
+	}
+out:
+	mutex_unlock(&trampoline_mutex);
+	return err;
+}
+
+/* bpf_trampoline_unlink_prog() should never fail. */
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
+{
+	enum bpf_tramp_prog_type kind;
+	struct bpf_trampoline *tr;
+	int err;
+
+	tr = prog->aux->trampoline;
+	kind = bpf_attach_type_to_tramp(prog->expected_attach_type);
+	mutex_lock(&trampoline_mutex);
+	hlist_del(&prog->aux->tramp_hlist);
+	tr->progs_cnt[kind]--;
+	err = bpf_trampoline_update(prog->aux->trampoline);
+	mutex_unlock(&trampoline_mutex);
+	return err;
+}
+
+void bpf_trampoline_put(struct bpf_trampoline *tr)
+{
+	if (!tr)
+		return;
+	mutex_lock(&trampoline_mutex);
+	if (!refcount_dec_and_test(&tr->refcnt))
+		goto out;
+	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
+		goto out;
+	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
+		goto out;
+	bpf_jit_free_exec(tr->image);
+	hlist_del(&tr->hlist);
+	kfree(tr);
+out:
+	mutex_unlock(&trampoline_mutex);
+}
+
+/* The logic is similar to BPF_PROG_RUN, but with explicit rcu and preempt that
+ * are needed for trampoline. The macro is split into
+ * call _bpf_prog_enter
+ * call prog->bpf_func
+ * call __bpf_prog_exit
+ */
+u64 notrace __bpf_prog_enter(void)
+{
+	u64 start = 0;
+
+	rcu_read_lock();
+	preempt_disable();
+	if (static_branch_unlikely(&bpf_stats_enabled_key))
+		start = sched_clock();
+	return start;
+}
+
+void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
+{
+	struct bpf_prog_stats *stats;
+
+	if (static_branch_unlikely(&bpf_stats_enabled_key) &&
+	    /* static_key could be enabled in __bpf_prog_enter
+	     * and disabled in __bpf_prog_exit.
+	     * And vice versa.
+	     * Hence check that 'start' is not zero.
+	     */
+	    start) {
+		stats = this_cpu_ptr(prog->aux->stats);
+		u64_stats_update_begin(&stats->syncp);
+		stats->cnt++;
+		stats->nsecs += sched_clock() - start;
+		u64_stats_update_end(&stats->syncp);
+	}
+	preempt_enable();
+	rcu_read_unlock();
+}
+
+int __weak
+arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags,
+			    struct bpf_prog **fentry_progs, int fentry_cnt,
+			    struct bpf_prog **fexit_progs, int fexit_cnt,
+			    void *orig_call)
+{
+	return -ENOTSUPP;
+}
+
+static int __init init_trampolines(void)
+{
+	int i;
+
+	for (i = 0; i < TRAMPOLINE_TABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&trampoline_table[i]);
+	return 0;
+}
+late_initcall(init_trampolines);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2f2374967b36..36542edd4936 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9382,8 +9382,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	struct bpf_prog *prog = env->prog;
 	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
+	struct bpf_trampoline *tr;
 	const struct btf_type *t;
 	const char *tname;
+	long addr;
+	int ret;
 
 	if (prog->type != BPF_PROG_TYPE_TRACING)
 		return 0;
@@ -9432,6 +9435,42 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		prog->aux->attach_func_proto = t;
 		prog->aux->attach_btf_trace = true;
 		return 0;
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
+		if (!btf_type_is_func(t)) {
+			verbose(env, "attach_btf_id %u is not a function\n",
+				btf_id);
+			return -EINVAL;
+		}
+		t = btf_type_by_id(btf_vmlinux, t->type);
+		if (!btf_type_is_func_proto(t))
+			return -EINVAL;
+		tr = bpf_trampoline_lookup(btf_id);
+		if (!tr)
+			return -ENOMEM;
+		prog->aux->attach_func_name = tname;
+		prog->aux->attach_func_proto = t;
+		if (tr->func.addr) {
+			prog->aux->trampoline = tr;
+			return 0;
+		}
+		ret = btf_distill_func_proto(&env->log, btf_vmlinux, t,
+					     tname, &tr->func.model);
+		if (ret < 0) {
+			bpf_trampoline_put(tr);
+			return ret;
+		}
+		addr = kallsyms_lookup_name(tname);
+		if (!addr) {
+			verbose(env,
+				"The address of function %s cannot be found\n",
+				tname);
+			bpf_trampoline_put(tr);
+			return -ENOENT;
+		}
+		tr->func.addr = (void *)addr;
+		prog->aux->trampoline = tr;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-- 
2.23.0

