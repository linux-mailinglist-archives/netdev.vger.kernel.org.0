Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462B5D1F5C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbfJJEP1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 00:15:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48932 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732759AbfJJEPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4E8Yn014743
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:15:23 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhfsduu04-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:23 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 9 Oct 2019 21:15:22 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 90AC1760CF9; Wed,  9 Oct 2019 21:15:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 09/12] bpf: add support for BTF pointers to x86 JIT
Date:   Wed, 9 Oct 2019 21:15:00 -0700
Message-ID: <20191010041503.2526303-10-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010041503.2526303-1-ast@kernel.org>
References: <20191010041503.2526303-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=1
 clxscore=1034 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer to BTF object is a pointer to kernel object or NULL.
Such pointers can only be used by BPF_LDX instructions.
The verifier changed their opcode from LDX|MEM|size
to LDX|PROBE_MEM|size to make JITing easier.
The number of entries in extable is the number of BPF_LDX insns
that access kernel memory via "pointer to BTF type".
Only these load instructions can fault.
Since x86 extable is relative it has to be allocated in the same
memory region as JITed code.
Allocate it prior to last pass of JITing and let the last pass populate it.
Pointer to extable in bpf_prog_aux is necessary to make page fault
handling fast.
Page fault handling is done in two steps:
1. bpf_prog_kallsyms_find() finds BPF program that page faulted.
   It's done by walking rb tree.
2. then extable for given bpf program is binary searched.
This process is similar to how page faulting is done for kernel modules.
The exception handler skips over faulting x86 instruction and
initializes destination register with zero. This mimics exact
behavior of bpf_probe_read (when probe_kernel_read faults dest is zeroed).

JITs for other architectures can add support in similar way.
Until then they will reject unknown opcode and fallback to interpreter.

Since extable should be aligned and placed near JITed code
make bpf_jit_binary_alloc() return 4 byte aligned image offset,
so that extable aligning formula in bpf_int_jit_compile() doesn't need
to rely on internal implementation of bpf_jit_binary_alloc().
On x86 gcc defaults to 16-byte alignment for regular kernel functions
due to better performance. JITed code may be aligned to 16 in the future,
but it will use 4 in the meantime.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 97 +++++++++++++++++++++++++++++++++++--
 include/linux/bpf.h         |  3 ++
 include/linux/extable.h     | 10 ++++
 kernel/bpf/core.c           | 20 +++++++-
 kernel/bpf/verifier.c       |  1 +
 kernel/extable.c            |  2 +
 6 files changed, 128 insertions(+), 5 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 3ad2ba1ad855..8cd23d8309bf 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -9,7 +9,7 @@
 #include <linux/filter.h>
 #include <linux/if_vlan.h>
 #include <linux/bpf.h>
-
+#include <asm/extable.h>
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
 
@@ -123,6 +123,19 @@ static const int reg2hex[] = {
 	[AUX_REG] = 3,    /* R11 temp register */
 };
 
+static const int reg2pt_regs[] = {
+	[BPF_REG_0] = offsetof(struct pt_regs, ax),
+	[BPF_REG_1] = offsetof(struct pt_regs, di),
+	[BPF_REG_2] = offsetof(struct pt_regs, si),
+	[BPF_REG_3] = offsetof(struct pt_regs, dx),
+	[BPF_REG_4] = offsetof(struct pt_regs, cx),
+	[BPF_REG_5] = offsetof(struct pt_regs, r8),
+	[BPF_REG_6] = offsetof(struct pt_regs, bx),
+	[BPF_REG_7] = offsetof(struct pt_regs, r13),
+	[BPF_REG_8] = offsetof(struct pt_regs, r14),
+	[BPF_REG_9] = offsetof(struct pt_regs, r15),
+};
+
 /*
  * is_ereg() == true if BPF register 'reg' maps to x86-64 r8..r15
  * which need extra byte of encoding.
@@ -377,6 +390,19 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
 	*pprog = prog;
 }
 
+
+static bool ex_handler_bpf(const struct exception_table_entry *x,
+			   struct pt_regs *regs, int trapnr,
+			   unsigned long error_code, unsigned long fault_addr)
+{
+	u32 reg = x->fixup >> 8;
+
+	/* jump over faulting load and clear dest register */
+	*(unsigned long *)((void *)regs + reg) = 0;
+	regs->ip += x->fixup & 0xff;
+	return true;
+}
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		  int oldproglen, struct jit_context *ctx)
 {
@@ -384,7 +410,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	int insn_cnt = bpf_prog->len;
 	bool seen_exit = false;
 	u8 temp[BPF_MAX_INSN_SIZE + BPF_INSN_SAFETY];
-	int i, cnt = 0;
+	int i, cnt = 0, excnt = 0;
 	int proglen = 0;
 	u8 *prog = temp;
 
@@ -778,14 +804,17 @@ stx:			if (is_imm8(insn->off))
 
 			/* LDX: dst_reg = *(u8*)(src_reg + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
 			/* Emit 'movzx rax, byte ptr [rax + off]' */
 			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB6);
 			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_H:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
 			/* Emit 'movzx rax, word ptr [rax + off]' */
 			EMIT3(add_2mod(0x48, src_reg, dst_reg), 0x0F, 0xB7);
 			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_W:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
 			/* Emit 'mov eax, dword ptr [rax+0x14]' */
 			if (is_ereg(dst_reg) || is_ereg(src_reg))
 				EMIT2(add_2mod(0x40, src_reg, dst_reg), 0x8B);
@@ -793,6 +822,7 @@ stx:			if (is_imm8(insn->off))
 				EMIT1(0x8B);
 			goto ldx;
 		case BPF_LDX | BPF_MEM | BPF_DW:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
 			/* Emit 'mov rax, qword ptr [rax+0x14]' */
 			EMIT2(add_2mod(0x48, src_reg, dst_reg), 0x8B);
 ldx:			/*
@@ -805,6 +835,48 @@ stx:			if (is_imm8(insn->off))
 			else
 				EMIT1_off32(add_2reg(0x80, src_reg, dst_reg),
 					    insn->off);
+			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
+				struct exception_table_entry *ex;
+				u8 *_insn = image + proglen;
+				s64 delta;
+
+				if (!bpf_prog->aux->extable)
+					break;
+
+				if (excnt >= bpf_prog->aux->num_exentries) {
+					pr_err("ex gen bug\n");
+					return -EFAULT;
+				}
+				ex = &bpf_prog->aux->extable[excnt++];
+
+				delta = _insn - (u8 *)&ex->insn;
+				if (!is_simm32(delta)) {
+					pr_err("extable->insn doesn't fit into 32-bit\n");
+					return -EFAULT;
+				}
+				ex->insn = delta;
+
+				delta = (u8 *)ex_handler_bpf - (u8 *)&ex->handler;
+				if (!is_simm32(delta)) {
+					pr_err("extable->handler doesn't fit into 32-bit\n");
+					return -EFAULT;
+				}
+				ex->handler = delta;
+
+				if (dst_reg > BPF_REG_9) {
+					pr_err("verifier error\n");
+					return -EFAULT;
+				}
+				/*
+				 * Compute size of x86 insn and its target dest x86 register.
+				 * ex_handler_bpf() will use lower 8 bits to adjust
+				 * pt_regs->ip to jump over this x86 instruction
+				 * and upper bits to figure out which pt_regs to zero out.
+				 * End result: x86 insn "mov rbx, qword ptr [rax+0x14]"
+				 * of 4 bytes will be ignored and rbx will be zero inited.
+				 */
+				ex->fixup = (prog - temp) | (reg2pt_regs[dst_reg] << 8);
+			}
 			break;
 
 			/* STX XADD: lock *(u32*)(dst_reg + off) += src_reg */
@@ -1058,6 +1130,11 @@ xadd:			if (is_imm8(insn->off))
 		addrs[i] = proglen;
 		prog = temp;
 	}
+
+	if (image && excnt != bpf_prog->aux->num_exentries) {
+		pr_err("extable is not populated\n");
+		return -EFAULT;
+	}
 	return proglen;
 }
 
@@ -1158,12 +1235,24 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			break;
 		}
 		if (proglen == oldproglen) {
-			header = bpf_jit_binary_alloc(proglen, &image,
-						      1, jit_fill_hole);
+			/*
+			 * The number of entries in extable is the number of BPF_LDX
+			 * insns that access kernel memory via "pointer to BTF type".
+			 * The verifier changed their opcode from LDX|MEM|size
+			 * to LDX|PROBE_MEM|size to make JITing easier.
+			 */
+			u32 align = __alignof__(struct exception_table_entry);
+			u32 extable_size = prog->aux->num_exentries *
+				sizeof(struct exception_table_entry);
+
+			/* allocate module memory for x86 insns and extable */
+			header = bpf_jit_binary_alloc(roundup(proglen, align) + extable_size,
+						      &image, align, jit_fill_hole);
 			if (!header) {
 				prog = orig_prog;
 				goto out_addrs;
 			}
+			prog->aux->extable = (void *) image + roundup(proglen, align);
 		}
 		oldproglen = proglen;
 		cond_resched();
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4218e269be59..6edfe50f1c2c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -24,6 +24,7 @@ struct sock;
 struct seq_file;
 struct btf;
 struct btf_type;
+struct exception_table_entry;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -423,6 +424,8 @@ struct bpf_prog_aux {
 	 * main prog always has linfo_idx == 0
 	 */
 	u32 linfo_idx;
+	u32 num_exentries;
+	struct exception_table_entry *extable;
 	struct bpf_prog_stats __percpu *stats;
 	union {
 		struct work_struct work;
diff --git a/include/linux/extable.h b/include/linux/extable.h
index 81ecfaa83ad3..4ab9e78f313b 100644
--- a/include/linux/extable.h
+++ b/include/linux/extable.h
@@ -33,4 +33,14 @@ search_module_extables(unsigned long addr)
 }
 #endif /*CONFIG_MODULES*/
 
+#ifdef CONFIG_BPF_JIT
+const struct exception_table_entry *search_bpf_extables(unsigned long addr);
+#else
+static inline const struct exception_table_entry *
+search_bpf_extables(unsigned long addr)
+{
+	return NULL;
+}
+#endif
+
 #endif /* _LINUX_EXTABLE_H */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8a765bbd33f0..673f5d40a93e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -30,7 +30,7 @@
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
 #include <linux/perf_event.h>
-
+#include <linux/extable.h>
 #include <asm/unaligned.h>
 
 /* Registers */
@@ -712,6 +712,24 @@ bool is_bpf_text_address(unsigned long addr)
 	return ret;
 }
 
+const struct exception_table_entry *search_bpf_extables(unsigned long addr)
+{
+	const struct exception_table_entry *e = NULL;
+	struct bpf_prog *prog;
+
+	rcu_read_lock();
+	prog = bpf_prog_kallsyms_find(addr);
+	if (!prog)
+		goto out;
+	if (!prog->aux->num_exentries)
+		goto out;
+
+	e = search_extable(prog->aux->extable, prog->aux->num_exentries, addr);
+out:
+	rcu_read_unlock();
+	return e;
+}
+
 int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		    char *sym)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2ade5193b76c..3404caa2f196 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8674,6 +8674,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				return -EINVAL;
 			}
 			insn->code = BPF_LDX | BPF_PROBE_MEM | BPF_SIZE((insn)->code);
+			env->prog->aux->num_exentries++;
 			continue;
 		default:
 			continue;
diff --git a/kernel/extable.c b/kernel/extable.c
index f6c9406eec7d..f6920a11e28a 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -56,6 +56,8 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	e = search_kernel_exception_table(addr);
 	if (!e)
 		e = search_module_extables(addr);
+	if (!e)
+		e = search_bpf_extables(addr);
 	return e;
 }
 
-- 
2.23.0

