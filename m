Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEA51C9DD6
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 23:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEGVsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 17:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgEGVsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 17:48:20 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E12C05BD43;
        Thu,  7 May 2020 14:48:20 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z6so8565084wml.2;
        Thu, 07 May 2020 14:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3VucMel2VcMPBSW+yTXmQNjNtFkFkvQaIgxnkoAD4f8=;
        b=XTFfyL0XjPY7WSY1nM9GnAVxhp50hPvP6sxaihKi3WiXOAuDH3DX4mdLzFm4TnCmEU
         wNlVTgcnpgvZ9uMAvSogigH38BM16GIeef3g71BVQGlch6SiBNo9/Tl+EcV/Jchxbqt8
         tYRdXaXzY0+ewSiDtKZpt0mbfGs37IJWEmcSutt4xCJ11cA0sXQMR6qqmqQUzhAcMd7M
         R0AUmbnjP/TbbJ6i4lmJElqstbx+E3124Vbo+GpGHh3RIq+UgjYxuXENF46mC0Hc43Vj
         eCR6GnZp5L6fu273XIOX68PBA4gnjAN/krX0Rjp6LEloMSuXuNM5cWpgUn45n6E6+yfw
         i7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3VucMel2VcMPBSW+yTXmQNjNtFkFkvQaIgxnkoAD4f8=;
        b=jUhhZulnTVBtq1pADOsJq8HL6WMml5U/v0CL5S9NjuRmUwtmf2UmItH5LtWdFlQs97
         D36DUg3a9xvQGEEfbHSdA91K9PRbTyCWWXBxhp1AthuC+1tCTp8qnQRC7UPZw2OOjkBq
         8S/jDWmad3EDcSQEJv3XdToyE+jmP6u/JvtWIwqx7iLDH1ZcuQTpReA7Um52Sgoh/YX5
         GONFR+CfjaBymbNpMxUBhDrkLO2lRO/DTreO7F4/sJIo35JN8gLporrhcycVppwzRzLH
         9fkGxvSP5Qfy/KGnFe0/Y7YpP70KNxJJl++sng++g7yZBWnFdyyv7quadAtEaq6/vo/O
         RPZQ==
X-Gm-Message-State: AGi0PubN8pnd7iu1gNgeVaKoVGLIE9IvC+xlnjvn3Ty/raZ1Hx4BhcYl
        8QaB2cbX1ibfVqNNaMn2UjUQpZgTjUAE6vY/48iQhZ9s
X-Google-Smtp-Source: APiQypINamJQOY2oV75ue3+82pSJ4u2LSA3OnQvIdaIqkuTVDtYRYPW3plUx8czr0GGQwzQAwytf98uAG9THrTKORH0=
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr12017512wmu.94.1588888098625;
 Thu, 07 May 2020 14:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200507010504.26352-1-luke.r.nels@gmail.com> <20200507010504.26352-2-luke.r.nels@gmail.com>
 <20200507082934.GA28215@willie-the-truck> <20200507101224.33a44d71@why>
In-Reply-To: <20200507101224.33a44d71@why>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Thu, 7 May 2020 14:48:07 -0700
Message-ID: <CAB-e3NRCJ_4+vkFPkMN67DwBBtO=sJwR-oL4-AozVw2bBJHOzg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/3] arm64: insn: Fix two bugs in encoding
 32-bit logical immediates
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

Thanks for the comments! Responses below:

> It's a bit grotty spreading the checks out now. How about we tweak things
> slightly along the lines of:
>
>
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 4a9e773a177f..60ec788eaf33 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> [...]

Agreed; this new version looks much cleaner. I re-ran all the tests /
verification and everything seems good. Would you like me to submit a
v2 of this series with this new code?


>> We tested the new code against llvm-mc with all 1,302 encodable 32-bit
>> logical immediates and all 5,334 encodable 64-bit logical immediates.
>
> That, on its own, is awesome information. Do you have any pointer on
> how to set this up?

Sure! The process of running the tests is pretty involved, but I'll
describe it below and give some links here.

We found the bugs in insn.c while adding support for logical immediates
to the BPF JIT and verifying the changes with our tool, Serval:
https://github.com/uw-unsat/serval-bpf. The basic idea for how we tested /
verified logical immediates is the following:

First, we have a Python script [1] for generating every encodable
logical immediate and the corresponding instruction fields that encode
that immediate. The script validates the list by checking that llvm-mc
decodes each instruction back to the expected immediate.

Next, we use the list [2] from the first step to check a Racket
translation [3] of the logical immediate encoding function in insn.c.
We found the second mask bug by noticing that some (encodable) 32-bit
immediates were being rejected by the encoding function.

Last, we use the Racket translation of the encoding function to verify
the correctness of the BPF JIT implementation [4], i.e., the JIT
correctly compiles BPF_{AND,OR,XOR,JSET} BPF_K instructions to arm64
instructions with equivalent semantics. We found the first bug as the
verifier complained that the function was producing invalid encodings
for 32-bit -1 immediates, and we were able to reproduce a kernel crash
using the BPF tests.

We manually translated the C code to Racket because our verifier, Serval,
currently only works on Racket code.

Thanks again,
- Luke

[1]: https://github.com/uw-unsat/serval-bpf/blob/00838174659034e9527e67d9eccd2def2354cec6/racket/test/arm64/gen-logic-imm.py
[2]: https://github.com/uw-unsat/serval-bpf/blob/00838174659034e9527e67d9eccd2def2354cec6/racket/test/arm64/logic-imm.rkt
[3]: https://github.com/uw-unsat/serval-bpf/blob/00838174659034e9527e67d9eccd2def2354cec6/racket/arm64/insn.rkt#L66
[4]: https://github.com/uw-unsat/serval-bpf/blob/00838174659034e9527e67d9eccd2def2354cec6/racket/arm64/bpf_jit_comp.rkt
