Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637F24430A4
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhKBOng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:43:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15347 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBOnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:43:35 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HkCHx5rkPz900w;
        Tue,  2 Nov 2021 22:40:45 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 22:40:54 +0800
Received: from localhost.localdomain (10.175.112.125) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 22:40:52 +0800
From:   Tong Tiangen <tongtiangen@huawei.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <bjorn.topel@gmail.com>
CC:     <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>
Subject: [PATCH bpf-next] riscv, bpf: fix some compiler error
Date:   Tue, 2 Nov 2021 14:56:42 +0000
Message-ID: <20211102145642.724820-1-tongtiangen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix two compile errors:
1. when CONFIG_BPF_JIT and CONFIG_ARCH_32I is open, There is the following
compiler error:
  error: undefined symbol: rv_bpf_fixup_exception

2. when CONFIG_BPF_JIT and CONFIG_ARCH_64I is open, There is the following
compiler error (W=1):
  error: no previous prototype for 'rv_bpf_fixup_exception'

In this patch, asm/extable.h is introduced,  the rv_bpf_fixup_exception
function declaration is added to this file. in addition, the definition of
exception_table_entry is moved from asm-generic/extable.h to this file.

Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
---
 arch/riscv/include/asm/Kbuild    |  1 -
 arch/riscv/include/asm/extable.h | 49 ++++++++++++++++++++++++++++++++
 arch/riscv/include/asm/uaccess.h | 13 ---------
 arch/riscv/mm/extable.c          |  8 +-----
 4 files changed, 50 insertions(+), 21 deletions(-)
 create mode 100644 arch/riscv/include/asm/extable.h

diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
index 445ccc97305a..57b86fd9916c 100644
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 generic-y += early_ioremap.h
-generic-y += extable.h
 generic-y += flat.h
 generic-y += kvm_para.h
 generic-y += user.h
diff --git a/arch/riscv/include/asm/extable.h b/arch/riscv/include/asm/extable.h
new file mode 100644
index 000000000000..aa0332b053fb
--- /dev/null
+++ b/arch/riscv/include/asm/extable.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_EXTABLE_H
+#define __ASM_EXTABLE_H
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+struct pt_regs;
+int fixup_exception(struct pt_regs *regs);
+
+#if defined(CONFIG_MMU)
+static inline bool rv_in_bpf_jit(struct pt_regs *regs)
+{
+	if (!IS_ENABLED(CONFIG_BPF_JIT) || !IS_ENABLED(CONFIG_64BIT))
+		return false;
+
+	return regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END;
+}
+#else
+static inline bool rv_in_bpf_jit(struct pt_regs *regs)
+{
+	return false;
+}
+#endif
+
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_64BIT)
+int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
+#else
+static inline int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
+					 struct pt_regs *regs)
+{
+	return 0;
+}
+#endif
+
+#endif
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index f314ff44c48d..96ea91dc0e9c 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -56,19 +56,6 @@ static inline int __access_ok(unsigned long addr, unsigned long size)
 	return size <= TASK_SIZE && addr <= TASK_SIZE - size;
 }
 
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
 #define __LSW	0
 #define __MSW	1
 
diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
index 18bf338303b6..264f465db5bb 100644
--- a/arch/riscv/mm/extable.c
+++ b/arch/riscv/mm/extable.c
@@ -11,10 +11,6 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 
-#ifdef CONFIG_BPF_JIT
-int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
-#endif
-
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
@@ -23,10 +19,8 @@ int fixup_exception(struct pt_regs *regs)
 	if (!fixup)
 		return 0;
 
-#ifdef CONFIG_BPF_JIT
-	if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
+	if (rv_in_bpf_jit(regs))
 		return rv_bpf_fixup_exception(fixup, regs);
-#endif
 
 	regs->epc = fixup->fixup;
 	return 1;
-- 
2.25.1

