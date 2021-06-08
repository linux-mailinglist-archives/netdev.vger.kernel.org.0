Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE913A0568
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 22:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhFHVAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:00:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhFHVAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623185920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lZUsgbONkfUzos/C9Av5cRf1otAOa/sTV3ApgVVN1OI=;
        b=KiSNugb/uJgJi4uJj8jwFzpdjmvtO40cwJae4AHGI2uoZRHKNUaInJvU8M8BMPVHCRUL5/
        rpzUH0QdOIRyM0I3gmUUzSkZIO4aHm1BBnlLVGe9M2YmrZVF2PTGG9y4T/RglJmq2eIyun
        bctvuQAsU4siQCyxf+iCjBS4DOTbZjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-T76qJZJuNqy63ucnWwsgMw-1; Tue, 08 Jun 2021 16:58:38 -0400
X-MC-Unique: T76qJZJuNqy63ucnWwsgMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0D6B1854E27;
        Tue,  8 Jun 2021 20:58:36 +0000 (UTC)
Received: from krava (unknown [10.40.192.49])
        by smtp.corp.redhat.com (Postfix) with SMTP id BCEE8100238C;
        Tue,  8 Jun 2021 20:58:33 +0000 (UTC)
Date:   Tue, 8 Jun 2021 22:58:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH 10/19] bpf: Allow to store caller's ip as argument
Message-ID: <YL/Z+MMB8db5904r@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-11-jolsa@kernel.org>
 <CAEf4BzZH5ck1Do7oRxP9D5U2v659tFXNW2RfCYAQXV_d2dYc4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZH5ck1Do7oRxP9D5U2v659tFXNW2RfCYAQXV_d2dYc4g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 11:49:31AM -0700, Andrii Nakryiko wrote:
> On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > When we will have multiple functions attached to trampoline
> > we need to propagate the function's address to the bpf program.
> >
> > Adding new BPF_TRAMP_F_IP_ARG flag to arch_prepare_bpf_trampoline
> > function that will store origin caller's address before function's
> > arguments.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 18 ++++++++++++++----
> >  include/linux/bpf.h         |  5 +++++
> >  2 files changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index b77e6bd78354..d2425c18272a 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1951,7 +1951,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >                                 void *orig_call)
> >  {
> >         int ret, i, cnt = 0, nr_args = m->nr_args;
> > -       int stack_size = nr_args * 8;
> > +       int stack_size = nr_args * 8, ip_arg = 0;
> >         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
> >         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
> >         struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> > @@ -1975,6 +1975,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >                  */
> >                 orig_call += X86_PATCH_SIZE;
> >
> > +       if (flags & BPF_TRAMP_F_IP_ARG)
> > +               stack_size += 8;
> > +
> 
> nit: move it a bit up where we adjust stack_size for BPF_TRAMP_F_CALL_ORIG flag?

ok

> 
> >         prog = image;
> >
> >         EMIT1(0x55);             /* push rbp */
> > @@ -1982,7 +1985,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >         EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> >         EMIT1(0x53);             /* push rbx */
> >
> > -       save_regs(m, &prog, nr_args, stack_size);
> > +       if (flags & BPF_TRAMP_F_IP_ARG) {
> > +               emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> > +               EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE); /* sub $X86_PATCH_SIZE,%rax*/
> > +               emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> > +               ip_arg = 8;
> > +       }
> 
> why not pass flags into save_regs and let it handle this case without
> this extra ip_arg adjustment?
> 
> > +
> > +       save_regs(m, &prog, nr_args, stack_size - ip_arg);
> >
> >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> >                 /* arg1: mov rdi, im */
> > @@ -2011,7 +2021,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >         }
> >
> >         if (flags & BPF_TRAMP_F_CALL_ORIG) {
> > -               restore_regs(m, &prog, nr_args, stack_size);
> > +               restore_regs(m, &prog, nr_args, stack_size - ip_arg);
> >
> 
> similarly (and symmetrically), pass flags into restore_regs() to
> handle that ip_arg transparently?

so you mean something like:

	if (flags & BPF_TRAMP_F_IP_ARG)
		stack_size -= 8;

in both save_regs and restore_regs function, right?

jirka

> 
> >                 if (flags & BPF_TRAMP_F_ORIG_STACK) {
> >                         emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> > @@ -2052,7 +2062,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >                 }
> >
> >         if (flags & BPF_TRAMP_F_RESTORE_REGS)
> > -               restore_regs(m, &prog, nr_args, stack_size);
> > +               restore_regs(m, &prog, nr_args, stack_size - ip_arg);
> >
> >         /* This needs to be done regardless. If there were fmod_ret programs,
> >          * the return value is only updated on the stack and still needs to be
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 16fc600503fb..6cbf3c81c650 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -559,6 +559,11 @@ struct btf_func_model {
> >   */
> >  #define BPF_TRAMP_F_ORIG_STACK         BIT(3)
> >
> > +/* First argument is IP address of the caller. Makes sense for fentry/fexit
> > + * programs only.
> > + */
> > +#define BPF_TRAMP_F_IP_ARG             BIT(4)
> > +
> >  /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
> >   * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
> >   */
> > --
> > 2.31.1
> >
> 

