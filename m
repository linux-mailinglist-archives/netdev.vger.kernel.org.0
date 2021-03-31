Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17B33504AC
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhCaQec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhCaQeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 12:34:15 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36A4AC061574;
        Wed, 31 Mar 2021 09:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=rWZY9UwzK3VhbJb3NlTJX8W59dG2h3SG5j
        HHtJwc4J0=; b=H8FUPEu6pKHAwwuYYRBKOKNjGGOKNFVwdUIA/ZFoeose4zCZTu
        iz2T5jwJFwrqPRrc0r5Ag5n/AYAMR73E2g65OQ8ojROH0hkSvXaZL/sml+V2fwVX
        +IB+EPdfRa28Cu2e07XizxteA9sdAQ7pYE3Psh77p+GWcPwg77hfrOpYc=
Received: from xhacker (unknown [101.86.19.180])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHD0t1pGRgMb96AA--.13595S2;
        Thu, 01 Apr 2021 00:33:58 +0800 (CST)
Date:   Thu, 1 Apr 2021 00:29:00 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        " =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=" <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v2 8/9] riscv: module: Create module allocations without
 exec permissions
Message-ID: <20210401002900.470f3413@xhacker>
In-Reply-To: <20210401002442.2fe56b88@xhacker>
References: <20210401002442.2fe56b88@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygAHD0t1pGRgMb96AA--.13595S2
X-Coremail-Antispam: 1UD129KBjvJXoW7GFyfWF4rGrWktry5Wr1xXwb_yoW8JrWUpr
        4xCrn0vrWrWw4xG3ySyF1vgF95Cws7Gr4Sga9rWFy7AanxJr4rAwn0gwn5Zry2qFy8ur48
        Wr43ur1SvFyUA37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkEb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjc
        xK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
        64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r
        1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kI
        c2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Gr0_Zr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jnCz
        tUUUUU=
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

The core code manages the executable permissions of code regions of
modules explicitly, it is not necessary to create the module vmalloc
regions with RWX permissions. Create them with RW- permissions instead.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/kernel/module.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 104fba889cf7..e89367bba7c9 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -407,14 +407,20 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-#if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
+#ifdef CONFIG_MMU
+
+#ifdef CONFIG_64BIT
 #define VMALLOC_MODULE_START \
 	 max(PFN_ALIGN((unsigned long)&_end - SZ_2G), VMALLOC_START)
+#else
+#define VMALLOC_MODULE_START	VMALLOC_START
+#endif
+
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, VMALLOC_MODULE_START,
 				    VMALLOC_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 #endif
-- 
2.31.0


