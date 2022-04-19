Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0655063D7
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 07:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiDSFVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 01:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiDSFVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 01:21:11 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFCD2494F;
        Mon, 18 Apr 2022 22:18:28 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k29so22839131pgm.12;
        Mon, 18 Apr 2022 22:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKXKDpig7n84fkdU5EKrzxCImKQmohN4igE9S+2Lkao=;
        b=KP4s69fPav61CUreMrEmh70bJbOp42IDKWWxzxeBrYNMRzKxOedHSm3wOQbUtNjBMg
         Yrj0ZjPHM8wvrYAfp4BhDks/TgUrUWs0bDX2VEVp1oTqpOzczDvInh3oknLeIoNqS3sA
         /5AXCXH7nqQvM0yCac9ONTFiS8PiGWoxaww9Gat+5n5/y5pe5ffK5YQKCB2HOtj2ycFE
         zrt0SkXxury/EXltXoZBxuzhySpgu/rIhg7tb0LWFGdQaB7DDX5tstWioz3HMai6mNJD
         jDjhmM60okBXmpXhNKPlDedkV5XF+d7R/Plo8Lkv570gNiLHMZV0AybsnEslT4XnQkuH
         y82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKXKDpig7n84fkdU5EKrzxCImKQmohN4igE9S+2Lkao=;
        b=suQICV/6rKhFMyymGNTfsT60abhmbcTbQ4rMlBuPEBhzy86lO3dgJqf2/R1RxLGax+
         aMCoXB9p4x73ARqaDZtte41hAXF0WlY3g13MLcun5QrlwVMtME/Qfsazrlhs3E920/W1
         mHVuHsMi/E0WVygxBnckXMg6Ao7jkpJMQ6n3AJqCBgE1PcwIYLMjNqVu0k5dguCUG0Ud
         l7Gd2JkDEI02VB49zkrt3C+0u9vG1829FRhkdJFwdcjJvkneL212ZfpxpvTv5lVhKw07
         Be5AV00xgmqWHPre3lRORr83xrIoBunAkzUFtdW4j0oPZMqDve07b730jpNGPOkCjb1R
         rR5Q==
X-Gm-Message-State: AOAM530QKnK40pHH95ePfB7QtQiJtRrcUmINTeSOotNacfeUV3t6mVYT
        SdlHmc6T4jHusgZ/g8b5fqN43TZSHBmwNCBWo/o=
X-Google-Smtp-Source: ABdhPJw8AoAI/Pm62m0da7GsFs2Fcp4wJPrK5l6sLJntkg2Ket8/oxcyoXmTSUtKL4kP0l6u3uQ5UyouJflfq6/7bvk=
X-Received: by 2002:a05:6a00:24cb:b0:50a:8151:9abc with SMTP id
 d11-20020a056a0024cb00b0050a81519abcmr6086275pfv.57.1650345507268; Mon, 18
 Apr 2022 22:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com> <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
 <Yl2W5ThWCFPIeLW8@google.com>
In-Reply-To: <Yl2W5ThWCFPIeLW8@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Apr 2022 22:18:16 -0700
Message-ID: <CAADnVQ+X5HPDsqXX6mHWV4sT9=2gQSag5cc9w6iJG_YE577ZEw@mail.gmail.com>
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

On Mon, Apr 18, 2022 at 9:50 AM <sdf@google.com> wrote:
>
> On 04/16, Alexei Starovoitov wrote:
> > On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > +static int
> > > +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > +                           enum cgroup_bpf_attach_type atype,
> > > +                           const void *ctx, bpf_prog_run_fn run_prog,
> > > +                           int retval, u32 *ret_flags)
> > > +{
> > > +       const struct bpf_prog_array_item *item;
> > > +       const struct bpf_prog *prog;
> > > +       const struct bpf_prog_array *array;
> > > +       struct bpf_run_ctx *old_run_ctx;
> > > +       struct bpf_cg_run_ctx run_ctx;
> > > +       u32 func_ret;
> > > +
> > > +       run_ctx.retval = retval;
> > > +       migrate_disable();
> > > +       rcu_read_lock();
> > > +       array = rcu_dereference(cgrp->effective[atype]);
> > > +       item = &array->items[0];
> > > +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > +       while ((prog = READ_ONCE(item->prog))) {
> > > +               run_ctx.prog_item = item;
> > > +               func_ret = run_prog(prog, ctx);
> > ...
> > > +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
> > >                                     &ctx, bpf_prog_run, retval);
>
> > Did you check the asm that bpf_prog_run gets inlined
> > after being passed as a pointer to a function?
> > Crossing fingers... I suspect not every compiler can do that :(
> > De-virtualization optimization used to be tricky.
>
> No, I didn't, but looking at it right now, both gcc and clang
> seem to be doing inlining all way up to bpf_dispatcher_nop_func.
>
> clang:
>
>    0000000000001750 <__cgroup_bpf_run_filter_sock_addr>:
>    __cgroup_bpf_run_filter_sock_addr():
>    ./kernel/bpf/cgroup.c:1226
>    int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
>                                       struct sockaddr *uaddr,
>                                       enum cgroup_bpf_attach_type atype,
>                                       void *t_ctx,
>                                       u32 *flags)
>    {
>
>    ...
>
>    ./include/linux/filter.h:628
>                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
>        1980:    49 8d 75 48             lea    0x48(%r13),%rsi
>    bpf_dispatcher_nop_func():
>    ./include/linux/bpf.h:804
>         return bpf_func(ctx, insnsi);
>        1984:    4c 89 f7                mov    %r14,%rdi
>        1987:    41 ff 55 30             call   *0x30(%r13)
>        198b:    89 c3                   mov    %eax,%ebx
>
> gcc (w/retpoline):
>
>    0000000000001110 <__cgroup_bpf_run_filter_sock_addr>:
>    __cgroup_bpf_run_filter_sock_addr():
>    kernel/bpf/cgroup.c:1226
>    {
>
>    ...
>
>    ./include/linux/filter.h:628
>                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
>        11c5:    49 8d 75 48             lea    0x48(%r13),%rsi
>    bpf_dispatcher_nop_func():
>    ./include/linux/bpf.h:804
>        11c9:    48 8d 7c 24 10          lea    0x10(%rsp),%rdi
>        11ce:    e8 00 00 00 00          call   11d3
> <__cgroup_bpf_run_filter_sock_addr+0xc3>
>                         11cf: R_X86_64_PLT32    __x86_indirect_thunk_rax-0x4
>        11d3:    89 c3                   mov    %eax,%ebx

Hmm. I'm not sure how you've got this asm.
Here is what I see with gcc 8 and gcc 10:
bpf_prog_run_array_cg:
...
        movq    %rcx, %r12      # run_prog, run_prog
...
# ../kernel/bpf/cgroup.c:77:            run_ctx.prog_item = item;
        movq    %rbx, (%rsp)    # item, run_ctx.prog_item
# ../kernel/bpf/cgroup.c:78:            if (!run_prog(prog, ctx) &&
!IS_ERR_VALUE((long)run_ctx.retval))
        movq    %rbp, %rsi      # ctx,
        call    *%r12   # run_prog

__cgroup_bpf_run_filter_sk:
        movq    $bpf_prog_run, %rcx     #,
# ../kernel/bpf/cgroup.c:1202:  return
bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
        leaq    1520(%rax), %rdi        #, tmp92
# ../kernel/bpf/cgroup.c:1202:  return
bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
        jmp     bpf_prog_run_array_cg   #

This is without kasan, lockdep and all debug configs are off.

So the generated code is pretty bad as I predicted :(

So I'm afraid this approach is no go.
