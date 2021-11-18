Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8BB455A93
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344115AbhKRLjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344207AbhKRLi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:38:56 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 158F3C06120F;
        Thu, 18 Nov 2021 03:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=MImYhdH7KtmtmyNxgxMYJv9ChC/U1LJ+nA
        F+ThMzzTs=; b=n1GqrCTk3CkgO6L1OgzelvSCXh7SJgeUdXDFMvaERgQdMUohGK
        ykyJ/f8D+L+F8ujbZwYqht/dH9hCAR/RBlTvuoGTGjCFCtymoOHJ10MiuPbm5TIR
        z+4+gk//4bcXcZsAGi7w2bb4NZplSB4a9FDoNTqB7cRChkUV7vnx+/HsQ=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHD99XOpZhwZ1cAQ--.27562S4;
        Thu, 18 Nov 2021 19:34:51 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:22:27 +0800
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
Subject: [PATCH 02/12] riscv: consolidate __ex_table construction
Message-ID: <20211118192227.6e03909b@xhacker>
In-Reply-To: <20211118192130.48b8f04c@xhacker>
References: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygAHD99XOpZhwZ1cAQ--.27562S4
X-Coremail-Antispam: 1UD129KBjvJXoWxury3tF4DZw4kKF1xJrW7XFb_yoW5urWDpw
        sFkrZ3KrZ8KF1xCFn7tFs7ur40ga1DGwnIy3sxWryv9r4qy3W0kF4vkr97W3ykJa13ZFyI
        gw18Krn5Jr4I9rUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBmb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82
        IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
        0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMI
        IF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l
        IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
        A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUzDGOUUUUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Consolidate all the __ex_table constuction code with a _ASM_EXTABLE
helper.

There should be no functional change as a result of this patch.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/riscv/include/asm/futex.h   | 12 +++---------
 arch/riscv/include/asm/uaccess.h | 30 ++++++++++++------------------
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/include/asm/futex.h b/arch/riscv/include/asm/futex.h
index 1b00badb9f87..3191574e135c 100644
--- a/arch/riscv/include/asm/futex.h
+++ b/arch/riscv/include/asm/futex.h
@@ -30,10 +30,7 @@
 	"3:	li %[r],%[e]				\n"	\
 	"	jump 2b,%[t]				\n"	\
 	"	.previous				\n"	\
-	"	.section __ex_table,\"a\"		\n"	\
-	"	.balign " RISCV_SZPTR "			\n"	\
-	"	" RISCV_PTR " 1b, 3b			\n"	\
-	"	.previous				\n"	\
+		_ASM_EXTABLE(1b, 3b)				\
 	: [r] "+r" (ret), [ov] "=&r" (oldval),			\
 	  [u] "+m" (*uaddr), [t] "=&r" (tmp)			\
 	: [op] "Jr" (oparg), [e] "i" (-EFAULT)			\
@@ -103,11 +100,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	"4:	li %[r],%[e]				\n"
 	"	jump 3b,%[t]				\n"
 	"	.previous				\n"
-	"	.section __ex_table,\"a\"		\n"
-	"	.balign " RISCV_SZPTR "			\n"
-	"	" RISCV_PTR " 1b, 4b			\n"
-	"	" RISCV_PTR " 2b, 4b			\n"
-	"	.previous				\n"
+		_ASM_EXTABLE(1b, 4b)			\
+		_ASM_EXTABLE(2b, 4b)			\
 	: [r] "+r" (ret), [v] "=&r" (val), [u] "+m" (*uaddr), [t] "=&r" (tmp)
 	: [ov] "Jr" (oldval), [nv] "Jr" (newval), [e] "i" (-EFAULT)
 	: "memory");
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 9f9219545e59..714cd311d9f1 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -10,6 +10,12 @@
 
 #include <asm/pgtable.h>		/* for TASK_SIZE */
 
+#define _ASM_EXTABLE(from, to)						\
+	"	.pushsection	__ex_table, \"a\"\n"			\
+	"	.balign "	RISCV_SZPTR "	 \n"			\
+	"	" RISCV_PTR	"(" #from "), (" #to ")\n"		\
+	"	.popsection\n"
+
 /*
  * User space memory access functions
  */
@@ -93,10 +99,7 @@ do {								\
 		"	li %1, 0\n"				\
 		"	jump 2b, %2\n"				\
 		"	.previous\n"				\
-		"	.section __ex_table,\"a\"\n"		\
-		"	.balign " RISCV_SZPTR "\n"			\
-		"	" RISCV_PTR " 1b, 3b\n"			\
-		"	.previous"				\
+			_ASM_EXTABLE(1b, 3b)			\
 		: "+r" (err), "=&r" (__x), "=r" (__tmp)		\
 		: "m" (*(ptr)), "i" (-EFAULT));			\
 	(x) = __x;						\
@@ -125,11 +128,8 @@ do {								\
 		"	li %2, 0\n"				\
 		"	jump 3b, %3\n"				\
 		"	.previous\n"				\
-		"	.section __ex_table,\"a\"\n"		\
-		"	.balign " RISCV_SZPTR "\n"			\
-		"	" RISCV_PTR " 1b, 4b\n"			\
-		"	" RISCV_PTR " 2b, 4b\n"			\
-		"	.previous"				\
+			_ASM_EXTABLE(1b, 4b)			\
+			_ASM_EXTABLE(2b, 4b)			\
 		: "+r" (err), "=&r" (__lo), "=r" (__hi),	\
 			"=r" (__tmp)				\
 		: "m" (__ptr[__LSW]), "m" (__ptr[__MSW]),	\
@@ -233,10 +233,7 @@ do {								\
 		"	li %0, %4\n"				\
 		"	jump 2b, %1\n"				\
 		"	.previous\n"				\
-		"	.section __ex_table,\"a\"\n"		\
-		"	.balign " RISCV_SZPTR "\n"			\
-		"	" RISCV_PTR " 1b, 3b\n"			\
-		"	.previous"				\
+			_ASM_EXTABLE(1b, 3b)			\
 		: "+r" (err), "=r" (__tmp), "=m" (*(ptr))	\
 		: "rJ" (__x), "i" (-EFAULT));			\
 } while (0)
@@ -262,11 +259,8 @@ do {								\
 		"	li %0, %6\n"				\
 		"	jump 3b, %1\n"				\
 		"	.previous\n"				\
-		"	.section __ex_table,\"a\"\n"		\
-		"	.balign " RISCV_SZPTR "\n"			\
-		"	" RISCV_PTR " 1b, 4b\n"			\
-		"	" RISCV_PTR " 2b, 4b\n"			\
-		"	.previous"				\
+			_ASM_EXTABLE(1b, 4b)			\
+			_ASM_EXTABLE(2b, 4b)			\
 		: "+r" (err), "=r" (__tmp),			\
 			"=m" (__ptr[__LSW]),			\
 			"=m" (__ptr[__MSW])			\
-- 
2.33.0


