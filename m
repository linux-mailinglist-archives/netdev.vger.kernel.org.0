Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14613455AAE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344255AbhKRLkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344280AbhKRLj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:39:26 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F0ABC06122B;
        Thu, 18 Nov 2021 03:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=UDqCaonUErBkG0UT8jd/OWpcu02UqrjqL2
        rLnvms00s=; b=lhFZd3ArxTgRlp/DnW1MYpEcOtNdAO1fHOMJ834ctgQd+zFTxE
        94DNmNMEhAj+adYOI2XI0rUIC82YZ6gdiwS9MvXEVkGicq4+fP2Bb2fWndE5LfEN
        QRCbsGI2+HBpQ0xTbX+J4D+m//7Ltv+YSicJihwq/VcvILHkGsfc0l9YA=
Received: from xhacker (unknown [101.86.18.22])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBnLsxMOpZhi51cAQ--.6032S5;
        Thu, 18 Nov 2021 19:34:41 +0800 (CST)
Date:   Thu, 18 Nov 2021 19:24:14 +0800
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
Subject: [PATCH 05/12] riscv: extable: make fixup_exception() return bool
Message-ID: <20211118192414.2c574541@xhacker>
In-Reply-To: <20211118192130.48b8f04c@xhacker>
References: <20211118192130.48b8f04c@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygBnLsxMOpZhi51cAQ--.6032S5
X-Coremail-Antispam: 1UD129KBjvJXoWxury3ZryfWry5Gr4xKF17KFg_yoW5CFWkpF
        4DCas7GrZYgrn3ur47tw40gF15Kw40g34xCr18Gwn8t3W2krWrJr1ftasIyr15CrWUWF18
        AFySgryrCws5Z37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBqb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82
        IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
        0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMI
        IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI
        42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
        80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8FD73UUUUU==
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

The return values of fixup_exception() and riscv_bpf_fixup_exception()
represent a boolean condition rather than an error code, so it's better
to return `bool` rather than `int`.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/extable.h | 8 ++++----
 arch/riscv/mm/extable.c          | 6 +++---
 arch/riscv/net/bpf_jit_comp64.c  | 6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/extable.h b/arch/riscv/include/asm/extable.h
index c48c020fcf4d..e4374dde02b4 100644
--- a/arch/riscv/include/asm/extable.h
+++ b/arch/riscv/include/asm/extable.h
@@ -21,16 +21,16 @@ struct exception_table_entry {
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
-int fixup_exception(struct pt_regs *regs);
+bool fixup_exception(struct pt_regs *regs);
 
 #if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
-int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
+bool rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
 #else
-static inline int
+static inline bool
 rv_bpf_fixup_exception(const struct exception_table_entry *ex,
 		       struct pt_regs *regs)
 {
-	return 0;
+	return false;
 }
 #endif
 
diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
index cbb0db11b28f..d41bf38e37e9 100644
--- a/arch/riscv/mm/extable.c
+++ b/arch/riscv/mm/extable.c
@@ -11,17 +11,17 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 
-int fixup_exception(struct pt_regs *regs)
+bool fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(regs->epc);
 	if (!fixup)
-		return 0;
+		return false;
 
 	if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
 		return rv_bpf_fixup_exception(fixup, regs);
 
 	regs->epc = (unsigned long)&fixup->fixup + fixup->fixup;
-	return 1;
+	return true;
 }
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 2ca345c7b0bf..7714081cbb64 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -459,8 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
 #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
 #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
 
-int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
-				struct pt_regs *regs)
+bool rv_bpf_fixup_exception(const struct exception_table_entry *ex,
+			    struct pt_regs *regs)
 {
 	off_t offset = FIELD_GET(BPF_FIXUP_OFFSET_MASK, ex->fixup);
 	int regs_offset = FIELD_GET(BPF_FIXUP_REG_MASK, ex->fixup);
@@ -468,7 +468,7 @@ int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
 	*(unsigned long *)((void *)regs + pt_regmap[regs_offset]) = 0;
 	regs->epc = (unsigned long)&ex->fixup - offset;
 
-	return 1;
+	return true;
 }
 
 /* For accesses to BTF pointers, add an entry to the exception table */
-- 
2.33.0


