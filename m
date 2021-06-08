Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682C33A0575
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhFHVFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhFHVFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:05:02 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CF9C061787;
        Tue,  8 Jun 2021 14:03:08 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i4so32254121ybe.2;
        Tue, 08 Jun 2021 14:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RLjgsFnKC4L7IcgxiiV4HyzmCPppo7n+3ZonyTCNhNc=;
        b=JNvnPU6xcNUVR2XnBre+lPvftUOVDXdSNZtM7nuBwBU/hWaTMYBAFi4msQLii16eIu
         ITNmli1Fxlgt5+2AnEX6n7mXx181IpTaAjs6/xCNc6vsd/UkESFyNsu7DKJxt1vvDmhL
         dtacalmEIz/na/idxCkXXXVHzTnivsLkVjLM8Xt+xpx+r4q4z9cm8RKURhUU7AK0MAVq
         BoB9EbtOsB0P1uFjA3M6SyhHpUUNJfG47hjo1TjNhLDaTfsoO/3hLryOWgArae/RNYcF
         nFfGHnvX/Yi3mZBA0U91PmyUoyWSnGB0ocVg9G6f0Vw7yzEHHAE0BgACpBI/W075kOb+
         IH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLjgsFnKC4L7IcgxiiV4HyzmCPppo7n+3ZonyTCNhNc=;
        b=jIcrqvX/xMq4XsBBLjTzKsmyZvNONhqY0ZZo8+ATPSE00iuYaQ/RFB2WSZehOAu6L+
         EyCdfq96+TmaG0d97JQXEmSsRr4g2aGIzuCSj/i0qrpd+WIpY1XWAG0lz16ddVdPq4Ee
         32cnr/QAzobfi4Y6MplZWRwTDZHxrrA+e98P34ydQ2bBmwGcyXizdAZcXgtUjbpjWlnn
         T9nCDtP7tySkMVNcb4dxOmnPGfWLdEdafTY3rGKkFtxCZyppeae2rsrJZKkxMvq+xrDG
         QJB/vPPu4zlQPEjOysxFgnuoSslP/wsOK3+33eo/aRN3JHfi6b3Zhsu87wLzoNvUKzKs
         Ue5g==
X-Gm-Message-State: AOAM533EXI5kcz9o/MJUcT5+N6WgyQR4IVhUqSJlRSd3Q1yRZLIU2486
        GXwu5UzIB5eytaR2HTszUjr26XINY52rGGL6v1U=
X-Google-Smtp-Source: ABdhPJyZcQg075Q25ka4UEJEGwBI+hI7HPVhnTmvoWXUDmtDsYXNub8XC2rhVz8Euyp7yfXu0BM4PIioouQt2gHiLaE=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr32159539ybg.459.1623186187814;
 Tue, 08 Jun 2021 14:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-11-jolsa@kernel.org>
 <CAEf4BzZH5ck1Do7oRxP9D5U2v659tFXNW2RfCYAQXV_d2dYc4g@mail.gmail.com> <YL/Z+MMB8db5904r@krava>
In-Reply-To: <YL/Z+MMB8db5904r@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 14:02:56 -0700
Message-ID: <CAEf4Bza2u_bHFkCVj4t0yPsNqBqvVkda8mQ-ff-rcgH1rAvRuw@mail.gmail.com>
Subject: Re: [PATCH 10/19] bpf: Allow to store caller's ip as argument
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 1:58 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jun 08, 2021 at 11:49:31AM -0700, Andrii Nakryiko wrote:
> > On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > When we will have multiple functions attached to trampoline
> > > we need to propagate the function's address to the bpf program.
> > >
> > > Adding new BPF_TRAMP_F_IP_ARG flag to arch_prepare_bpf_trampoline
> > > function that will store origin caller's address before function's
> > > arguments.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  arch/x86/net/bpf_jit_comp.c | 18 ++++++++++++++----
> > >  include/linux/bpf.h         |  5 +++++
> > >  2 files changed, 19 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > index b77e6bd78354..d2425c18272a 100644
> > > --- a/arch/x86/net/bpf_jit_comp.c
> > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > @@ -1951,7 +1951,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >                                 void *orig_call)
> > >  {
> > >         int ret, i, cnt = 0, nr_args = m->nr_args;
> > > -       int stack_size = nr_args * 8;
> > > +       int stack_size = nr_args * 8, ip_arg = 0;
> > >         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
> > >         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
> > >         struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> > > @@ -1975,6 +1975,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >                  */
> > >                 orig_call += X86_PATCH_SIZE;
> > >
> > > +       if (flags & BPF_TRAMP_F_IP_ARG)
> > > +               stack_size += 8;
> > > +
> >
> > nit: move it a bit up where we adjust stack_size for BPF_TRAMP_F_CALL_ORIG flag?
>
> ok
>
> >
> > >         prog = image;
> > >
> > >         EMIT1(0x55);             /* push rbp */
> > > @@ -1982,7 +1985,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >         EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> > >         EMIT1(0x53);             /* push rbx */
> > >
> > > -       save_regs(m, &prog, nr_args, stack_size);
> > > +       if (flags & BPF_TRAMP_F_IP_ARG) {
> > > +               emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> > > +               EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE); /* sub $X86_PATCH_SIZE,%rax*/
> > > +               emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> > > +               ip_arg = 8;
> > > +       }
> >
> > why not pass flags into save_regs and let it handle this case without
> > this extra ip_arg adjustment?
> >
> > > +
> > > +       save_regs(m, &prog, nr_args, stack_size - ip_arg);
> > >
> > >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> > >                 /* arg1: mov rdi, im */
> > > @@ -2011,7 +2021,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >         }
> > >
> > >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> > > -               restore_regs(m, &prog, nr_args, stack_size);
> > > +               restore_regs(m, &prog, nr_args, stack_size - ip_arg);
> > >
> >
> > similarly (and symmetrically), pass flags into restore_regs() to
> > handle that ip_arg transparently?
>
> so you mean something like:
>
>         if (flags & BPF_TRAMP_F_IP_ARG)
>                 stack_size -= 8;
>
> in both save_regs and restore_regs function, right?

yes, but for save_regs it will do more (emit_ldx and stuff)

>
> jirka
>
> >
> > >                 if (flags & BPF_TRAMP_F_ORIG_STACK) {
> > >                         emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> > > @@ -2052,7 +2062,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > >                 }
> > >
> > >         if (flags & BPF_TRAMP_F_RESTORE_REGS)
> > > -               restore_regs(m, &prog, nr_args, stack_size);
> > > +               restore_regs(m, &prog, nr_args, stack_size - ip_arg);
> > >
> > >         /* This needs to be done regardless. If there were fmod_ret programs,
> > >          * the return value is only updated on the stack and still needs to be
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 16fc600503fb..6cbf3c81c650 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -559,6 +559,11 @@ struct btf_func_model {
> > >   */
> > >  #define BPF_TRAMP_F_ORIG_STACK         BIT(3)
> > >
> > > +/* First argument is IP address of the caller. Makes sense for fentry/fexit
> > > + * programs only.
> > > + */
> > > +#define BPF_TRAMP_F_IP_ARG             BIT(4)
> > > +
> > >  /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
> > >   * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
> > >   */
> > > --
> > > 2.31.1
> > >
> >
>
