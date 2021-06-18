Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5DB3ACD4B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhFRORj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFRORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:17:35 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F3CAC061574;
        Fri, 18 Jun 2021 07:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=R5rGWfYjWzannEPfCFi17k2rcSwUm8SqL8TNYdn/BEM=; b=s7whCFqb7FLUu
        kEGCCMwhOpiWfcIUIGwYidH0mGDW/FoKMrc96cyok59W4hsU7T1htQ2r76jFyOIP
        YFS1jr5YtCfjFGlghncCdqGReB6SBs5x8MbYy8IdjmGq/O9kSdzQcRJF1uN2hk30
        8QhvQx85uOKcI2gJXwcjOSKtGEGAYA=
Received: from xhacker (unknown [101.86.20.15])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHk6BXqsxgBAv_AA--.19232S2;
        Fri, 18 Jun 2021 22:14:48 +0800 (CST)
Date:   Fri, 18 Jun 2021 22:09:13 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc:     linux-doc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v3] riscv: Ensure BPF_JIT_REGION_START aligned with PMD size
Message-ID: <20210618220913.6fde1957@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygAHk6BXqsxgBAv_AA--.19232S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AFy3GrWDWF1xCw4UAr4fKrg_yoW7Zw1xpr
        45Jr1xGrW8JryUXw18Ary5Cr1UA3WUC3W3JrnxJr15XFyUGF1UAr1UtFW3Xr1DXF4rJ3W7
        tr1DGrWUtr1UAw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
        WxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07b0NVkUUU
        UU=
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
breaks booting with one kind of defconfig, I reproduced a kernel panic
with the defconfig:

[    0.138553] Unable to handle kernel paging request at virtual address ffffffff81201220
[    0.139159] Oops [#1]
[    0.139303] Modules linked in:
[    0.139601] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-default+ #1
[    0.139934] Hardware name: riscv-virtio,qemu (DT)
[    0.140193] epc : __memset+0xc4/0xfc
[    0.140416]  ra : skb_flow_dissector_init+0x1e/0x82
[    0.140609] epc : ffffffff8029806c ra : ffffffff8033be78 sp : ffffffe001647da0
[    0.140878]  gp : ffffffff81134b08 tp : ffffffe001654380 t0 : ffffffff81201158
[    0.141156]  t1 : 0000000000000002 t2 : 0000000000000154 s0 : ffffffe001647dd0
[    0.141424]  s1 : ffffffff80a43250 a0 : ffffffff81201220 a1 : 0000000000000000
[    0.141654]  a2 : 000000000000003c a3 : ffffffff81201258 a4 : 0000000000000064
[    0.141893]  a5 : ffffffff8029806c a6 : 0000000000000040 a7 : ffffffffffffffff
[    0.142126]  s2 : ffffffff81201220 s3 : 0000000000000009 s4 : ffffffff81135088
[    0.142353]  s5 : ffffffff81135038 s6 : ffffffff8080ce80 s7 : ffffffff80800438
[    0.142584]  s8 : ffffffff80bc6578 s9 : 0000000000000008 s10: ffffffff806000ac
[    0.142810]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 0000000000000000
[    0.143042]  t5 : 0000000000000155 t6 : 00000000000003ff
[    0.143220] status: 0000000000000120 badaddr: ffffffff81201220 cause: 000000000000000f
[    0.143560] [<ffffffff8029806c>] __memset+0xc4/0xfc
[    0.143859] [<ffffffff8061e984>] init_default_flow_dissectors+0x22/0x60
[    0.144092] [<ffffffff800010fc>] do_one_initcall+0x3e/0x168
[    0.144278] [<ffffffff80600df0>] kernel_init_freeable+0x1c8/0x224
[    0.144479] [<ffffffff804868a8>] kernel_init+0x12/0x110
[    0.144658] [<ffffffff800022de>] ret_from_exception+0x0/0xc
[    0.145124] ---[ end trace f1e9643daa46d591 ]---

After some investigation, I think I found the root cause: commit
2bfc6cd81bd ("move kernel mapping outside of linear mapping") moves
BPF JIT region after the kernel:

| #define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)

The &_end is unlikely aligned with PMD size, so the front bpf jit
region sits with part of kernel .data section in one PMD size mapping.
But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
called to make the first bpf jit prog ROX, we will make part of kernel
.data section RO too, so when we write to, for example memset the
.data section, MMU will trigger a store page fault.

To fix the issue, we need to ensure the BPF JIT region is PMD size
aligned. This patch acchieve this goal by restoring the BPF JIT region
to original position, I.E the 128MB before kernel .text section. The
modification to kasan_init.c is inspired by Alexandre.

Fixes: fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
Since v2:
 - Split the local vars rename modification into another patch per Alexandre
   suggestion
 - Add Fixes tag

Since v1:
 - Fix early boot hang when kasan is enabled
 - Update Documentation/riscv/vm-layout.rst

 Documentation/riscv/vm-layout.rst | 4 ++--
 arch/riscv/include/asm/pgtable.h  | 5 ++---
 arch/riscv/mm/kasan_init.c        | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/riscv/vm-layout.rst b/Documentation/riscv/vm-layout.rst
index 329d32098af4..b7f98930d38d 100644
--- a/Documentation/riscv/vm-layout.rst
+++ b/Documentation/riscv/vm-layout.rst
@@ -58,6 +58,6 @@ RISC-V Linux Kernel SV39
                                                               |
   ____________________________________________________________|____________________________________________________________
                     |            |                  |         |
-   ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | modules
-   ffffffff80000000 |   -2    GB | ffffffffffffffff |    2 GB | kernel, BPF
+   ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | modules, BPF
+   ffffffff80000000 |   -2    GB | ffffffffffffffff |    2 GB | kernel
   __________________|____________|__________________|_________|____________________________________________________________
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 9469f464e71a..380cd3a7e548 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -30,9 +30,8 @@
 
 #define BPF_JIT_REGION_SIZE	(SZ_128M)
 #ifdef CONFIG_64BIT
-/* KASLR should leave at least 128MB for BPF after the kernel */
-#define BPF_JIT_REGION_START	PFN_ALIGN((unsigned long)&_end)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
+#define BPF_JIT_REGION_START	(BPF_JIT_REGION_END - BPF_JIT_REGION_SIZE)
+#define BPF_JIT_REGION_END	(MODULES_END)
 #else
 #define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
 #define BPF_JIT_REGION_END	(VMALLOC_END)
diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 9daacae93e33..55c113345460 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -201,7 +201,7 @@ void __init kasan_init(void)
 
 	/* Populate kernel, BPF, modules mapping */
 	kasan_populate(kasan_mem_to_shadow((const void *)MODULES_VADDR),
-		       kasan_mem_to_shadow((const void *)BPF_JIT_REGION_END));
+		       kasan_mem_to_shadow((const void *)MODULES_VADDR + SZ_2G));
 
 	for (i = 0; i < PTRS_PER_PTE; i++)
 		set_pte(&kasan_early_shadow_pte[i],
-- 
2.32.0


