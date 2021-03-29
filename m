Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C517934D724
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhC2S3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhC2S3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:29:35 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 410E4C061574;
        Mon, 29 Mar 2021 11:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=VCe4QmQLCwyArf7TfS2RTM//Ze/hAyVnYU
        NMw+5EuIc=; b=jtLZ/TQr6fGadMGyUcNKpSUzttVvRakB8hLlqZwgBeSmeffOjh
        qH88cJFcvfAduJb0Jl7ibCaUlXxN0+IrpVzameR1biQ13FpVB7FPUE5lFY/M0cD+
        8NVY+9zuiSutImScjETfwevsYdHU9pfEo9Cv0OBYm/m+RQ5keCXl/yRS0=
Received: from xhacker (unknown [101.86.19.180])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDX3Eh9HGJgUfVpAA--.35371S2;
        Tue, 30 Mar 2021 02:29:18 +0800 (CST)
Date:   Tue, 30 Mar 2021 02:24:21 +0800
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
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 5/9] riscv: kprobes: Implement alloc_insn_page()
Message-ID: <20210330022421.0ee61d0d@xhacker>
In-Reply-To: <20210330022144.150edc6e@xhacker>
References: <20210330022144.150edc6e@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygDX3Eh9HGJgUfVpAA--.35371S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GFyDGF45XF4kJrWxuw48WFg_yoWDGrb_C3
        WxKry3WrWYkrWxWFyDKw4Sqrsak343KFykWr12yryUtr1DWr13Ka95WF45G3sYqr97JFyf
        GrnxX3srWF42qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8JV
        WxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r4j6FyUMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU4yv3UU
        UUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

Allocate PAGE_KERNEL_READ_EXEC(read only, executable) page for kprobes
insn page. This is to prepare for STRICT_MODULE_RWX.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/kernel/probes/kprobes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 7e2c78e2ca6b..8c1f7a30aeed 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -84,6 +84,14 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	return 0;
 }
 
+void *alloc_insn_page(void)
+{
+	return  __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
+				     GFP_KERNEL, PAGE_KERNEL_READ_EXEC,
+				     VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
+				     __builtin_return_address(0));
+}
+
 /* install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-- 
2.31.0


