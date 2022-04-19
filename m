Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36185072D9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiDSQXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 12:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244793AbiDSQW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 12:22:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3AF1ADB7;
        Tue, 19 Apr 2022 09:20:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id be5so16210211plb.13;
        Tue, 19 Apr 2022 09:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpmsPVuh5gD407HNflz5sTTKTm92evyJFyu/dYazDZo=;
        b=pnQqoPHJCVZ7osuaM6ziIdZpm2hz+AabFwJ8YK6FroHsyTh4vi04iu04G7U6YX3lDx
         z7NSvoIzKwHnnpG511hZ5rEuR4SVcfoz91moRNElfykbxxif/HnGbL8MeV7L8y/6bo1Q
         AwPD2DtyNeVHeYSH/q5mEy/lDtjo2+1TV16H9TmHWPEuXn4WlPz7ueam7dqIA18U5WqZ
         QJr/80nWRD/jOjMvaWbJG+kthBP2La19NIevGNgZlsPeRQs8zy6KI8fCOE9YWSQ9LQWt
         nivh0z2dcmoS7RHgPXBT9f4weoKQ2pL+c/JBfH2RLtG88axkMatwhiQAHuvEJK9olS1g
         fM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpmsPVuh5gD407HNflz5sTTKTm92evyJFyu/dYazDZo=;
        b=MNjQCQBGUWCRuHB+v8mLNqCGXgOaw7wYYB1ZjBBhSF8sL8E30y6ri9lmCMXT+o9cUv
         lGpsdwIHnUYv5y5HY0DCp/5tf0WIiTN4VBYC4tt+rou/OrxgWL61LKNn8iUPldyzMcQe
         Di/Oad/2SYy1U8nnp67sBkH7qxMMIQHVBm8JDBAjU9b2Q2W9UXa919HKtOojYQhUbWrA
         e4a04b/pJL3OHazzBKstyKUCsSqx3fFA7zbSN4fwB1zVslXJiF0akfhO8k2D4rITbQVs
         YmJ/Hy+qindA3ZErVe4+M+66Oq+SZhj5q8GKs0jFqIBccvz5GettPh0KU+SN5Etb/3bK
         wolQ==
X-Gm-Message-State: AOAM530Im/JScNprNw+9QjTygc6UH+5S6ENriRdF6yep2qS4YHE5pwZ0
        4nRrs2/lDPVeoM2jrUyFVAGeOai7cpkZKFgspWg=
X-Google-Smtp-Source: ABdhPJyXucgwjBUCNws7QdnR9RRUpd2+6dEbAAmKY2yrSY46/uXzNb3Tc8/z20cflB5jonVCuA1plDQ5pepJtZr+yYs=
X-Received: by 2002:a17:903:2d1:b0:156:7ceb:b56f with SMTP id
 s17-20020a17090302d100b001567cebb56fmr16493322plk.11.1650385214168; Tue, 19
 Apr 2022 09:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com> <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
 <Yl2W5ThWCFPIeLW8@google.com> <CAADnVQ+X5HPDsqXX6mHWV4sT9=2gQSag5cc9w6iJG_YE577ZEw@mail.gmail.com>
 <Yl7YXXIG/EECZxd9@google.com>
In-Reply-To: <Yl7YXXIG/EECZxd9@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Apr 2022 09:20:03 -0700
Message-ID: <CAADnVQK8ARjeY2Vro0B0-6vxhgrWg-jhJqkbHh0s1xinSq2-+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 8:42 AM <sdf@google.com> wrote:
>
> On 04/18, Alexei Starovoitov wrote:
> > On Mon, Apr 18, 2022 at 9:50 AM <sdf@google.com> wrote:
> > >
> > > On 04/16, Alexei Starovoitov wrote:
> > > > On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com>
> > wrote:
> > > > > +static int
> > > > > +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > > > +                           enum cgroup_bpf_attach_type atype,
> > > > > +                           const void *ctx, bpf_prog_run_fn
> > run_prog,
> > > > > +                           int retval, u32 *ret_flags)
> > > > > +{
> > > > > +       const struct bpf_prog_array_item *item;
> > > > > +       const struct bpf_prog *prog;
> > > > > +       const struct bpf_prog_array *array;
> > > > > +       struct bpf_run_ctx *old_run_ctx;
> > > > > +       struct bpf_cg_run_ctx run_ctx;
> > > > > +       u32 func_ret;
> > > > > +
> > > > > +       run_ctx.retval = retval;
> > > > > +       migrate_disable();
> > > > > +       rcu_read_lock();
> > > > > +       array = rcu_dereference(cgrp->effective[atype]);
> > > > > +       item = &array->items[0];
> > > > > +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > > > +       while ((prog = READ_ONCE(item->prog))) {
> > > > > +               run_ctx.prog_item = item;
> > > > > +               func_ret = run_prog(prog, ctx);
> > > > ...
> > > > > +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
> > > > >                                     &ctx, bpf_prog_run, retval);
> > >
> > > > Did you check the asm that bpf_prog_run gets inlined
> > > > after being passed as a pointer to a function?
> > > > Crossing fingers... I suspect not every compiler can do that :(
> > > > De-virtualization optimization used to be tricky.
> > >
> > > No, I didn't, but looking at it right now, both gcc and clang
> > > seem to be doing inlining all way up to bpf_dispatcher_nop_func.
> > >
> > > clang:
> > >
> > >    0000000000001750 <__cgroup_bpf_run_filter_sock_addr>:
> > >    __cgroup_bpf_run_filter_sock_addr():
> > >    ./kernel/bpf/cgroup.c:1226
> > >    int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
> > >                                       struct sockaddr *uaddr,
> > >                                       enum cgroup_bpf_attach_type atype,
> > >                                       void *t_ctx,
> > >                                       u32 *flags)
> > >    {
> > >
> > >    ...
> > >
> > >    ./include/linux/filter.h:628
> > >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> > >        1980:    49 8d 75 48             lea    0x48(%r13),%rsi
> > >    bpf_dispatcher_nop_func():
> > >    ./include/linux/bpf.h:804
> > >         return bpf_func(ctx, insnsi);
> > >        1984:    4c 89 f7                mov    %r14,%rdi
> > >        1987:    41 ff 55 30             call   *0x30(%r13)
> > >        198b:    89 c3                   mov    %eax,%ebx
> > >
> > > gcc (w/retpoline):
> > >
> > >    0000000000001110 <__cgroup_bpf_run_filter_sock_addr>:
> > >    __cgroup_bpf_run_filter_sock_addr():
> > >    kernel/bpf/cgroup.c:1226
> > >    {
> > >
> > >    ...
> > >
> > >    ./include/linux/filter.h:628
> > >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> > >        11c5:    49 8d 75 48             lea    0x48(%r13),%rsi
> > >    bpf_dispatcher_nop_func():
> > >    ./include/linux/bpf.h:804
> > >        11c9:    48 8d 7c 24 10          lea    0x10(%rsp),%rdi
> > >        11ce:    e8 00 00 00 00          call   11d3
> > > <__cgroup_bpf_run_filter_sock_addr+0xc3>
> > >                         11cf: R_X86_64_PLT32
> > __x86_indirect_thunk_rax-0x4
> > >        11d3:    89 c3                   mov    %eax,%ebx
>
> > Hmm. I'm not sure how you've got this asm.
> > Here is what I see with gcc 8 and gcc 10:
> > bpf_prog_run_array_cg:
> > ...
> >          movq    %rcx, %r12      # run_prog, run_prog
> > ...
> > # ../kernel/bpf/cgroup.c:77:            run_ctx.prog_item = item;
> >          movq    %rbx, (%rsp)    # item, run_ctx.prog_item
> > # ../kernel/bpf/cgroup.c:78:            if (!run_prog(prog, ctx) &&
> > !IS_ERR_VALUE((long)run_ctx.retval))
> >          movq    %rbp, %rsi      # ctx,
> >          call    *%r12   # run_prog
>
> > __cgroup_bpf_run_filter_sk:
> >          movq    $bpf_prog_run, %rcx     #,
> > # ../kernel/bpf/cgroup.c:1202:  return
> > bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
> >          leaq    1520(%rax), %rdi        #, tmp92
> > # ../kernel/bpf/cgroup.c:1202:  return
> > bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
> >          jmp     bpf_prog_run_array_cg   #
>
> > This is without kasan, lockdep and all debug configs are off.
>
> > So the generated code is pretty bad as I predicted :(
>
> > So I'm afraid this approach is no go.
>
> I've retested again and it still unrolls it for me on gcc 11 :-/
> Anyway, I guess we have two options:
>
> 1. Go back to defines.
> 2. Don't pass a ptr to func, but pass an enum which indicates whether
>     to use bpf_prog_run or __bpf_prog_run_save_cb. Seems like in this
>     case the compiler shouldn't have any trouble unwrapping it?
>
> I'll prototype and send (2). If it won't work out we can always get back
> to (1).

Going back to defines is probably not necessary.
Could you try moving bpf_prog_run_array_cg*() back to .h
and use static __always_inline ?
