Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690F434D72D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhC2Saq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhC2Sai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:30:38 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE294C061574;
        Mon, 29 Mar 2021 11:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=Najrrc9y+/48DUXx4/endqtIY6BJkPiOWT
        uivmMc0is=; b=NaS9q8tOGiaDE2giyGJj/HhBdOzcB3LYDRI0hBV+yDVkKtANcj
        gpL2dYG897SXSmoXz60Ynj8BqdTBDNVRaJ5cuRGyjkamPcEJ7VRdY7NopN+oSKZU
        uSxF6gIhzhr9GWBYvd+h8POlcBCn7aOsxRc7Ky7u9/1EIJ8tcoSzUwgNI=
Received: from xhacker (unknown [101.86.19.180])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDn7Ei5HGJgEfdpAA--.51311S2;
        Tue, 30 Mar 2021 02:30:18 +0800 (CST)
Date:   Tue, 30 Mar 2021 02:25:21 +0800
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
Subject: [PATCH 7/9] riscv: bpf: Avoid breaking W^X
Message-ID: <20210330022521.2a904a8c@xhacker>
In-Reply-To: <20210330022144.150edc6e@xhacker>
References: <20210330022144.150edc6e@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LkAmygDn7Ei5HGJgEfdpAA--.51311S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GFyxtF45CF1ruF48Kr4UArb_yoWkKrg_Z3
        Wxta4xW3s5Jr4xCr4Durn5Zr1Ikw1FkFs5ur1xurW2y390vr1ftasaq3yrur9xZr4j9rW7
        WF9rXrWxZw42vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8JV
        WxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r4j6FyUMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUciihUU
        UUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

We allocate Non-executable pages, then call bpf_jit_binary_lock_ro()
to enable executable permission after mapping them read-only. This is
to prepare for STRICT_MODULE_RWX in following patch.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index d8da819290b7..0d5099f0dac8 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -152,6 +152,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
 
 	if (!prog->is_func || extra_pass) {
+		bpf_jit_binary_lock_ro(header);
 out_offset:
 		kfree(ctx->offset);
 		kfree(jit_data);
@@ -169,7 +170,7 @@ void *bpf_jit_alloc_exec(unsigned long size)
 {
 	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
 				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
-- 
2.31.0


