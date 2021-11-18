Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A9B455A8E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344092AbhKRLjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344206AbhKRLiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:38:55 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14CA6C06120D;
        Thu, 18 Nov 2021 03:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=u2o84AxwU8xhUErO2FYo4Qh1EzNzUfFohy
        WOsjH5TgM=; b=FCw9PF9iQ0HmsuVEkUsMUR+WnYxOM6yTs3ro59rzdA/R+mHtGP
        Lw4wRDt7BIyWivvAH8ysLNS3XpkAcFFZ6U2JuEGmWvAXnUMbndFKRTfgiDz6bvy3
        4VUNrWxbPOyxIgM/BgISi5xuNZonEYDy4szSfYL3nKn97NPFrD6h4TWHU=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHD99XOpZhwZ1cAQ--.27562S5;
        Thu, 18 Nov 2021 19:34:53 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:25:45 +0800
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
Subject: [PATCH 08/12] riscv: extable: consolidate definitions
Message-ID: <20211118192545.349f59b7@xhacker>
In-Reply-To: <20211118192130.48b8f04c@xhacker>
References: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygAHD99XOpZhwZ1cAQ--.27562S5
X-Coremail-Antispam: 1UD129KBjvJXoWxury3XrWrCw1rWFy5tFykuFg_yoW5ZF1kpF
        4qkF95KrZ5Cr1xCw1ayF9F9r4UKan8Ww1ayry7uFyqvw42ya10yrn0gr9rtrykAa1kZFyx
        Was29r45Wr4UZw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBmb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82
        IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
        0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMI
        IF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l
        IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
        A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU7BMKDUUUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

This is a riscv port of commit 819771cc2892 ("arm64: extable:
consolidate definitions").

In subsequent patches we'll alter the structure and usage of struct
exception_table_entry.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/asm-extable.h | 33 ++++++++++++++++++++++++++++
 arch/riscv/include/asm/futex.h       |  1 +
 arch/riscv/include/asm/uaccess.h     |  7 +-----
 arch/riscv/lib/uaccess.S             |  6 ++---
 4 files changed, 37 insertions(+), 10 deletions(-)
 create mode 100644 arch/riscv/include/asm/asm-extable.h

diff --git a/arch/riscv/include/asm/asm-extable.h b/arch/riscv/include/asm/asm-extable.h
new file mode 100644
index 000000000000..b790c02dbdda
--- /dev/null
+++ b/arch/riscv/include/asm/asm-extable.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_ASM_EXTABLE_H
+#define __ASM_ASM_EXTABLE_H
+
+#ifdef __ASSEMBLY__
+
+#define __ASM_EXTABLE_RAW(insn, fixup)		\
+	.pushsection	__ex_table, "a";	\
+	.balign		4;			\
+	.long		((insn) - .);		\
+	.long		((fixup) - .);		\
+	.popsection;
+
+	.macro		_asm_extable, insn, fixup
+	__ASM_EXTABLE_RAW(\insn, \fixup)
+	.endm
+
+#else /* __ASSEMBLY__ */
+
+#include <linux/stringify.h>
+
+#define __ASM_EXTABLE_RAW(insn, fixup)			\
+	".pushsection	__ex_table, \"a\"\n"		\
+	".balign	4\n"				\
+	".long		((" insn ") - .)\n"		\
+	".long		((" fixup ") - .)\n"		\
+	".popsection\n"
+
+#define _ASM_EXTABLE(insn, fixup) __ASM_EXTABLE_RAW(#insn, #fixup)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_ASM_EXTABLE_H */
diff --git a/arch/riscv/include/asm/futex.h b/arch/riscv/include/asm/futex.h
index 3191574e135c..2e15e8e89502 100644
--- a/arch/riscv/include/asm/futex.h
+++ b/arch/riscv/include/asm/futex.h
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/errno.h>
 #include <asm/asm.h>
+#include <asm/asm-extable.h>
 
 /* We don't even really need the extable code, but for now keep it simple */
 #ifndef CONFIG_MMU
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 0f2c5b9d2e8f..40e6099af488 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -8,14 +8,9 @@
 #ifndef _ASM_RISCV_UACCESS_H
 #define _ASM_RISCV_UACCESS_H
 
+#include <asm/asm-extable.h>
 #include <asm/pgtable.h>		/* for TASK_SIZE */
 
-#define _ASM_EXTABLE(from, to)						\
-	"	.pushsection	__ex_table, \"a\"\n"			\
-	"	.balign		4\n"					\
-	"	.long		(" #from " - .), (" #to " - .)\n"	\
-	"	.popsection\n"
-
 /*
  * User space memory access functions
  */
diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index 047f517ac780..8c475f4da308 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -1,15 +1,13 @@
 #include <linux/linkage.h>
 #include <asm-generic/export.h>
 #include <asm/asm.h>
+#include <asm/asm-extable.h>
 #include <asm/csr.h>
 
 	.macro fixup op reg addr lbl
 100:
 	\op \reg, \addr
-	.section __ex_table,"a"
-	.balign 4
-	.long (100b - .), (\lbl - .)
-	.previous
+	_asm_extable	100b, \lbl
 	.endm
 
 ENTRY(__asm_copy_to_user)
-- 
2.33.0


