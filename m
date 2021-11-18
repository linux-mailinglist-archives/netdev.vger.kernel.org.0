Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DED8455AB7
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbhKRLk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343953AbhKRLj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:39:28 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EF17C06122C;
        Thu, 18 Nov 2021 03:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=wixk569uf0n1TYoIXBryiuwd/MDJ0a4Am9
        56c85iGKU=; b=MvS6qGPToVllxhrgTgj0zZspYFulGyu+P+eXk5vJmOpZd/puzj
        HP+OVBd+r/FxfYHLK7STHyAUJAUnMVJM+wRpl/Lhit9yh2YR4WMXpfsgmOXx31CF
        HmC6nUgHXY6t7q+al6Pq7DfOgrmFx4YhxGoZ1yX1bSxqFveEpZRB600aQ=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBnLsxMOpZhi51cAQ--.6032S6;
        Thu, 18 Nov 2021 19:34:43 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:26:51 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "=?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?=" <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 11/12] riscv: extable: add a dedicated uaccess handler
Message-ID: <20211118192651.605d0c80@xhacker>
In-Reply-To: <20211118192130.48b8f04c@xhacker>
References: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygBnLsxMOpZhi51cAQ--.6032S6
X-Coremail-Antispam: 1UD129KBjvJXoW3AFy3Zr1xZw4xCr13uF18uFg_yoW3ZF15pa
        1qkr93KrW5KF1xuF97ta47ur1jgw48K3s0y3s7Kr1qv3W2k3W8CF1093s7ArykAayxAa4x
        J3ySkr1rWr4fZrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBCb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E
        87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
        kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm
        72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42
        xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWU
        GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI4
        8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWx
        Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
        vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU29mRUUUUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Inspired by commit 2e77a62cb3a6("arm64: extable: add a dedicated
uaccess handler"), do similar to riscv to add a dedicated uaccess
exception handler to update registers in exception context and
subsequently return back into the function which faulted, so we remove
the need for fixups specialized to each faulting instruction.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/asm-extable.h | 23 +++++++++
 arch/riscv/include/asm/futex.h       | 23 +++------
 arch/riscv/include/asm/uaccess.h     | 74 +++++++++-------------------
 arch/riscv/mm/extable.c              | 27 ++++++++++
 4 files changed, 78 insertions(+), 69 deletions(-)

diff --git a/arch/riscv/include/asm/asm-extable.h b/arch/riscv/include/asm/asm-extable.h
index 1b1f4ffd8d37..14be0673f5b5 100644
--- a/arch/riscv/include/asm/asm-extable.h
+++ b/arch/riscv/include/asm/asm-extable.h
@@ -5,6 +5,7 @@
 #define EX_TYPE_NONE			0
 #define EX_TYPE_FIXUP			1
 #define EX_TYPE_BPF			2
+#define EX_TYPE_UACCESS_ERR_ZERO	3
 
 #ifdef __ASSEMBLY__
 
@@ -23,7 +24,9 @@
 
 #else /* __ASSEMBLY__ */
 
+#include <linux/bits.h>
 #include <linux/stringify.h>
+#include <asm/gpr-num.h>
 
 #define __ASM_EXTABLE_RAW(insn, fixup, type, data)	\
 	".pushsection	__ex_table, \"a\"\n"		\
@@ -37,6 +40,26 @@
 #define _ASM_EXTABLE(insn, fixup)	\
 	__ASM_EXTABLE_RAW(#insn, #fixup, __stringify(EX_TYPE_FIXUP), "0")
 
+#define EX_DATA_REG_ERR_SHIFT	0
+#define EX_DATA_REG_ERR		GENMASK(4, 0)
+#define EX_DATA_REG_ZERO_SHIFT	5
+#define EX_DATA_REG_ZERO	GENMASK(9, 5)
+
+#define EX_DATA_REG(reg, gpr)						\
+	"((.L__gpr_num_" #gpr ") << " __stringify(EX_DATA_REG_##reg##_SHIFT) ")"
+
+#define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)		\
+	__DEFINE_ASM_GPR_NUMS						\
+	__ASM_EXTABLE_RAW(#insn, #fixup, 				\
+			  __stringify(EX_TYPE_UACCESS_ERR_ZERO),	\
+			  "("						\
+			    EX_DATA_REG(ERR, err) " | "			\
+			    EX_DATA_REG(ZERO, zero)			\
+			  ")")
+
+#define _ASM_EXTABLE_UACCESS_ERR(insn, fixup, err)			\
+	_ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ASM_ASM_EXTABLE_H */
diff --git a/arch/riscv/include/asm/futex.h b/arch/riscv/include/asm/futex.h
index 2e15e8e89502..fc8130f995c1 100644
--- a/arch/riscv/include/asm/futex.h
+++ b/arch/riscv/include/asm/futex.h
@@ -21,20 +21,14 @@
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)	\
 {								\
-	uintptr_t tmp;						\
 	__enable_user_access();					\
 	__asm__ __volatile__ (					\
 	"1:	" insn "				\n"	\
 	"2:						\n"	\
-	"	.section .fixup,\"ax\"			\n"	\
-	"	.balign 4				\n"	\
-	"3:	li %[r],%[e]				\n"	\
-	"	jump 2b,%[t]				\n"	\
-	"	.previous				\n"	\
-		_ASM_EXTABLE(1b, 3b)				\
+	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %[r])			\
 	: [r] "+r" (ret), [ov] "=&r" (oldval),			\
-	  [u] "+m" (*uaddr), [t] "=&r" (tmp)			\
-	: [op] "Jr" (oparg), [e] "i" (-EFAULT)			\
+	  [u] "+m" (*uaddr)					\
+	: [op] "Jr" (oparg)					\
 	: "memory");						\
 	__disable_user_access();				\
 }
@@ -96,15 +90,10 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	"2:	sc.w.aqrl %[t],%z[nv],%[u]		\n"
 	"	bnez %[t],1b				\n"
 	"3:						\n"
-	"	.section .fixup,\"ax\"			\n"
-	"	.balign 4				\n"
-	"4:	li %[r],%[e]				\n"
-	"	jump 3b,%[t]				\n"
-	"	.previous				\n"
-		_ASM_EXTABLE(1b, 4b)			\
-		_ASM_EXTABLE(2b, 4b)			\
+		_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %[r])	\
+		_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %[r])	\
 	: [r] "+r" (ret), [v] "=&r" (val), [u] "+m" (*uaddr), [t] "=&r" (tmp)
-	: [ov] "Jr" (oldval), [nv] "Jr" (newval), [e] "i" (-EFAULT)
+	: [ov] "Jr" (oldval), [nv] "Jr" (newval)
 	: "memory");
 	__disable_user_access();
 
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 40e6099af488..a4716c026386 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -81,22 +81,14 @@ static inline int __access_ok(unsigned long addr, unsigned long size)
 
 #define __get_user_asm(insn, x, ptr, err)			\
 do {								\
-	uintptr_t __tmp;					\
 	__typeof__(x) __x;					\
 	__asm__ __volatile__ (					\
 		"1:\n"						\
-		"	" insn " %1, %3\n"			\
+		"	" insn " %1, %2\n"			\
 		"2:\n"						\
-		"	.section .fixup,\"ax\"\n"		\
-		"	.balign 4\n"				\
-		"3:\n"						\
-		"	li %0, %4\n"				\
-		"	li %1, 0\n"				\
-		"	jump 2b, %2\n"				\
-		"	.previous\n"				\
-			_ASM_EXTABLE(1b, 3b)			\
-		: "+r" (err), "=&r" (__x), "=r" (__tmp)		\
-		: "m" (*(ptr)), "i" (-EFAULT));			\
+		_ASM_EXTABLE_UACCESS_ERR_ZERO(1b, 2b, %0, %1)	\
+		: "+r" (err), "=&r" (__x)			\
+		: "m" (*(ptr)));				\
 	(x) = __x;						\
 } while (0)
 
@@ -108,27 +100,18 @@ do {								\
 do {								\
 	u32 __user *__ptr = (u32 __user *)(ptr);		\
 	u32 __lo, __hi;						\
-	uintptr_t __tmp;					\
 	__asm__ __volatile__ (					\
 		"1:\n"						\
-		"	lw %1, %4\n"				\
+		"	lw %1, %3\n"				\
 		"2:\n"						\
-		"	lw %2, %5\n"				\
+		"	lw %2, %4\n"				\
 		"3:\n"						\
-		"	.section .fixup,\"ax\"\n"		\
-		"	.balign 4\n"				\
-		"4:\n"						\
-		"	li %0, %6\n"				\
-		"	li %1, 0\n"				\
-		"	li %2, 0\n"				\
-		"	jump 3b, %3\n"				\
-		"	.previous\n"				\
-			_ASM_EXTABLE(1b, 4b)			\
-			_ASM_EXTABLE(2b, 4b)			\
-		: "+r" (err), "=&r" (__lo), "=r" (__hi),	\
-			"=r" (__tmp)				\
-		: "m" (__ptr[__LSW]), "m" (__ptr[__MSW]),	\
-			"i" (-EFAULT));				\
+		_ASM_EXTABLE_UACCESS_ERR_ZERO(1b, 3b, %0, %1)	\
+		_ASM_EXTABLE_UACCESS_ERR_ZERO(2b, 3b, %0, %1)	\
+		: "+r" (err), "=&r" (__lo), "=r" (__hi)		\
+		: "m" (__ptr[__LSW]), "m" (__ptr[__MSW]))	\
+	if (err)						\
+		__hi = 0;					\
 	(x) = (__typeof__(x))((__typeof__((x)-(x)))(		\
 		(((u64)__hi << 32) | __lo)));			\
 } while (0)
@@ -216,21 +199,14 @@ do {								\
 
 #define __put_user_asm(insn, x, ptr, err)			\
 do {								\
-	uintptr_t __tmp;					\
 	__typeof__(*(ptr)) __x = x;				\
 	__asm__ __volatile__ (					\
 		"1:\n"						\
-		"	" insn " %z3, %2\n"			\
+		"	" insn " %z2, %1\n"			\
 		"2:\n"						\
-		"	.section .fixup,\"ax\"\n"		\
-		"	.balign 4\n"				\
-		"3:\n"						\
-		"	li %0, %4\n"				\
-		"	jump 2b, %1\n"				\
-		"	.previous\n"				\
-			_ASM_EXTABLE(1b, 3b)			\
-		: "+r" (err), "=r" (__tmp), "=m" (*(ptr))	\
-		: "rJ" (__x), "i" (-EFAULT));			\
+		_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %0)		\
+		: "+r" (err), "=m" (*(ptr))			\
+		: "rJ" (__x));					\
 } while (0)
 
 #ifdef CONFIG_64BIT
@@ -244,22 +220,16 @@ do {								\
 	uintptr_t __tmp;					\
 	__asm__ __volatile__ (					\
 		"1:\n"						\
-		"	sw %z4, %2\n"				\
+		"	sw %z3, %1\n"				\
 		"2:\n"						\
-		"	sw %z5, %3\n"				\
+		"	sw %z4, %2\n"				\
 		"3:\n"						\
-		"	.section .fixup,\"ax\"\n"		\
-		"	.balign 4\n"				\
-		"4:\n"						\
-		"	li %0, %6\n"				\
-		"	jump 3b, %1\n"				\
-		"	.previous\n"				\
-			_ASM_EXTABLE(1b, 4b)			\
-			_ASM_EXTABLE(2b, 4b)			\
-		: "+r" (err), "=r" (__tmp),			\
+		_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %0)		\
+		_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %0)		\
+		: "+r" (err),					\
 			"=m" (__ptr[__LSW]),			\
 			"=m" (__ptr[__MSW])			\
-		: "rJ" (__x), "rJ" (__x >> 32), "i" (-EFAULT));	\
+		: "rJ" (__x), "rJ" (__x >> 32));		\
 } while (0)
 #endif /* CONFIG_64BIT */
 
diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
index 91e52c4bb33a..05978f78579f 100644
--- a/arch/riscv/mm/extable.c
+++ b/arch/riscv/mm/extable.c
@@ -7,10 +7,12 @@
  */
 
 
+#include <linux/bitfield.h>
 #include <linux/extable.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <asm/asm-extable.h>
+#include <asm/ptrace.h>
 
 static inline unsigned long
 get_ex_fixup(const struct exception_table_entry *ex)
@@ -25,6 +27,29 @@ static bool ex_handler_fixup(const struct exception_table_entry *ex,
 	return true;
 }
 
+static inline void regs_set_gpr(struct pt_regs *regs, unsigned int offset,
+				unsigned long val)
+{
+	if (unlikely(offset > MAX_REG_OFFSET))
+		return;
+
+	if (!offset)
+		*(unsigned long *)((unsigned long)regs + offset) = val;
+}
+
+static bool ex_handler_uaccess_err_zero(const struct exception_table_entry *ex,
+					struct pt_regs *regs)
+{
+	int reg_err = FIELD_GET(EX_DATA_REG_ERR, ex->data);
+	int reg_zero = FIELD_GET(EX_DATA_REG_ZERO, ex->data);
+
+	regs_set_gpr(regs, reg_err, -EFAULT);
+	regs_set_gpr(regs, reg_zero, 0);
+
+	regs->epc = get_ex_fixup(ex);
+	return true;
+}
+
 bool fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *ex;
@@ -38,6 +63,8 @@ bool fixup_exception(struct pt_regs *regs)
 		return ex_handler_fixup(ex, regs);
 	case EX_TYPE_BPF:
 		return ex_handler_bpf(ex, regs);
+	case EX_TYPE_UACCESS_ERR_ZERO:
+		return ex_handler_uaccess_err_zero(ex, regs);
 	}
 
 	BUG();
-- 
2.33.0


