Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5D3A6C81
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhFNQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhFNQ5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:57:44 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A543EC061767;
        Mon, 14 Jun 2021 09:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=cTQGzuLTNvXEGjTEb/xgHNPQ2J7ygTLFE8
        lIngQ6Kvo=; b=wWznm3uOYMP7ZaPY0FbHy2D0Gm9kzmPwgpizUTsOaAhFkkouL6
        NgLIEabXd3vxCW95bcATrbHvcnopyPoqkIiG0jF7PTENzeD7JXxe+NZmUPTEcImv
        k6mZ4qp6PVKmLg2Zy5cnPz508vd4/5GvVv+D22hQDEk7Ypjk7a60Ovf7o=
Received: from xhacker (unknown [101.86.20.15])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDHz8PpicdgdkfbAA--.3750S2;
        Tue, 15 Jun 2021 00:55:05 +0800 (CST)
Date:   Tue, 15 Jun 2021 00:49:27 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Andreas Schwab <schwab@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] riscv: Ensure BPF_JIT_REGION_START aligned with PMD size
Message-ID: <20210615004928.2d27d2ac@xhacker>
In-Reply-To: <87im2hsfvm.fsf@igel.home>
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker>
        <87o8ccqypw.fsf@igel.home>
        <20210612002334.6af72545@xhacker>
        <87bl8cqrpv.fsf@igel.home>
        <20210614010546.7a0d5584@xhacker>
        <87im2hsfvm.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygDHz8PpicdgdkfbAA--.3750S2
X-Coremail-Antispam: 1UD129KBjvJXoWxury3Cr1DGrWxGr4DZF4DCFg_yoWrGr4kpF
        15tr13GrW8Jry7XFy8Zry5Ar1UJw15A3W3JrnrJr15X3W7G3WDZr10qFW7ur1DXF4xJ3W7
        Kr4DXr48Kr4UAaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07b5sjbUUU
        UU=
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Andreas reported commit fc8504765ec5 ("riscv: bpf: Avoid breaking W^X")
breaks booting with one kind of config file, I reproduced a kernel panic
with the config:

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

The &_end is unlikely aligned with PMD size, so the front bpf jit
region sits with part of kernel .data section in one PMD size mapping.
But kernel is mapped in PMD SIZE, when bpf_jit_binary_lock_ro() is
called to make the first bpf jit prog ROX, we will make part of kernel
.data section RO too, so when we write to, for example memset the
.data section, MMU will trigger a store page fault.

To fix the issue, we need to ensure the BPF JIT region is PMD size
aligned. This patch acchieve this goal by restoring the BPF JIT region
to original position, I.E the 128MB before kernel .text section.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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
-- 
2.32.0


