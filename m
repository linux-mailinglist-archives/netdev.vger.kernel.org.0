Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2971183B0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLJJgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:36:09 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45500 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfLJJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:36:09 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so19148753wrj.12;
        Tue, 10 Dec 2019 01:36:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=mgAZ5+aB/GvC0mnzXTVn3f/oGiktcBasZAmAbLkZ9JE=;
        b=nx93M4IT9DSr/mpaNHid9wLdFHgRPoZGI4R09KrAJWMRYtmyogl3X9OhOhRI82k5ES
         yb3+up9pKS9FWpjfM+PKnnNjEX0s+JOuRvKR1csDiDCYjOIq94koN9qYZeSmXoA52day
         PqxtkHuFiI5sMppqvoZBhJQsBnaX/UGw6W8jH/vNSNrE2Z9RX8So/TlAELVo0XDdk94R
         pV62R+OJ+xddJMfrTREmP9VMluqVCgq3WR4Boska1Z6OY36fHPtC3Lkbe07T1PiMU/C+
         XK7TEj/qfDRy5AAjKjpXYNkr521uonm22zpfMt8NVYpa1jAN8SVsZUti6IedKwy5u+Pq
         RBrQ==
X-Gm-Message-State: APjAAAVJ8daZjsF2iKjUlnbZnKCEUlpA8UyG6VzqeyiVq6Pw47Kk80jn
        6L5nlz3cyRbJM628a3AKr7o=
X-Google-Smtp-Source: APXvYqw6FVjHfOx8q4A7LdcghN9XlvKV2lcjY8QJoImoDiAVgnjuYhzenEbMcT7oIrBlD+tcehYX5g==
X-Received: by 2002:a5d:6349:: with SMTP id b9mr2137418wrw.346.1575970567440;
        Tue, 10 Dec 2019 01:36:07 -0800 (PST)
Received: from Nover ([161.105.209.130])
        by smtp.gmail.com with ESMTPSA id m10sm2609149wrx.19.2019.12.10.01.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 01:36:06 -0800 (PST)
Date:   Tue, 10 Dec 2019 10:36:06 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Paul Burton <paulburton@kernel.org>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH bpf 1/2] bpf, riscv: limit to 33 tail calls
Message-ID: <20191210093605.GA31145@Nover>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
 <966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com>
 <CAJ+HfNgFo8viKn3KzNfbmniPNUpjOv_QM4ua_V0RFLBpWCOBYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNgFo8viKn3KzNfbmniPNUpjOv_QM4ua_V0RFLBpWCOBYw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 08:57:27PM +0100, Björn Töpel wrote:
> On Mon, 9 Dec 2019 at 19:52, Paul Chaignon <paul.chaignon@orange.com> wrote:
> >
> > All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
> > limit at runtime.  In addition, a test was recently added, in tailcalls2,
> > to check this limit.
> >
> > This patch updates the tail call limit in RISC-V's JIT compiler to allow
> > 33 tail calls.  I tested it using the above selftest on an emulated
> > RISCV64.
> >
> 
> 33! ICK! ;-) Thanks for finding this!

Actually, Mahshid found it during her internship because she wanted to
check that the number of tail calls was limited.  And now I feel so
naive for trusting the doc...

> 
> Acked-by: Björn Töpel <bjorn.topel@gmail.com>
> 
> > Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> > Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> > ---
> >  arch/riscv/net/bpf_jit_comp.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> > index 5451ef3845f2..7fbf56aab661 100644
> > --- a/arch/riscv/net/bpf_jit_comp.c
> > +++ b/arch/riscv/net/bpf_jit_comp.c
> > @@ -631,14 +631,14 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
> >                 return -1;
> >         emit(rv_bgeu(RV_REG_A2, RV_REG_T1, off >> 1), ctx);
> >
> > -       /* if (--TCC < 0)
> > +       /* if (TCC-- < 0)
> >          *     goto out;
> >          */
> >         emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
> >         off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> >         if (is_13b_check(off, insn))
> >                 return -1;
> > -       emit(rv_blt(RV_REG_T1, RV_REG_ZERO, off >> 1), ctx);
> > +       emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
> >
> >         /* prog = array->ptrs[index];
> >          * if (!prog)
> > --
> > 2.17.1
> >
