Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22C04AF5FE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbiBIQFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbiBIQFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:05:14 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00208C0613C9;
        Wed,  9 Feb 2022 08:05:16 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p63so3691307iod.11;
        Wed, 09 Feb 2022 08:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1c/6l8Fp4RH5VPtrTh9qUA2jV+GD+5aUHsSlil0jKiA=;
        b=RmxhaIRcr+PwhQu4PtzxQSrXEXKyLT5HnRTvT+BDinZcRUK81PdCfNC5t6nFX3qr8C
         Lx3xEBUqecDkV+MHfhMouucqPtzvKsqRnTMjcLCscQ/AIZ/mJU7+rhkbWhYZ/lj4tYnW
         QYtMP3fkC+vmqjRkdOsy57ykqyLVa/lgWcocGwOQuILqJPTpx+EDRPFvzPuqoRTZcuyW
         8fRfsulDLSGHmU5/W3PnfzJ4xwp0k7hudmLhAUYDhDj9cKhHqy5aZqKJgMTQggp00/UF
         ZMn5HZiBEiW4ihI7aq5Bjf3cqAIy3usaOLTfTkdxEGUg5QoadOQ4b851sQIDXzicxctu
         NVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1c/6l8Fp4RH5VPtrTh9qUA2jV+GD+5aUHsSlil0jKiA=;
        b=aiBA2I+9qD0vN/pbi0BQhfY4sUeiiHVDmNJqNHuL+p0OhKEJrr9MX3yBP5k+oRDvz7
         4OWessttlzo9IYYB0jbxUpzDKaLg69zBOHc+eq1Au1X2nXXza4o1Uls/YyYNdr3OgIHQ
         BAqjjmUs6rw0iMYAiw8wRtdnXKDeS2Nq6VeDx+mLsXLm7EAAgkMlsrzUMCeFIdqpYNQ6
         p8f3qPdgLxcpVPfz/yFjGp36DTuFY3Fdy/+VtV+aYO1NqLUJ96nm1soxXO+/b/+Rw3oI
         fyFARwhEJ6iTlig+BxtZeqi85M4neHowZcrbze3WjV52AEmdxCOM96TMvo3kFhPRbG0w
         +qTQ==
X-Gm-Message-State: AOAM533KOSVvbJRuQ/TEsukbW6xLkOxGwlitznMN6BAbPn7x+5mgHUtF
        y3lzehCcSMyHQMhZiNIQ0mymTI4taFWFBEkg+Pk=
X-Google-Smtp-Source: ABdhPJzwUJh9RJL8FHv95KrO3ujW9aTtOQ3nrC3twvNd8fY/dXsrOtRrHd9PRm6dTN9PV+G+Q3G0ZbIpyQe+F3zYpnE=
X-Received: by 2002:a05:6638:2606:: with SMTP id m6mr1297132jat.93.1644422716327;
 Wed, 09 Feb 2022 08:05:16 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-3-jolsa@kernel.org>
 <CAEf4Bzbrj01RJq7ArAo-kX-+8rPx9j5OH1OvGHxVJxiq8rn3FA@mail.gmail.com> <YgPXVXJnPKQ7lOi9@krava>
In-Reply-To: <YgPXVXJnPKQ7lOi9@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Feb 2022 08:05:05 -0800
Message-ID: <CAEf4BzYxtoE8Gu62oNSdVxvsv2K_5CPSdGS3Qd0Jgaegvw7sfw@mail.gmail.com>
Subject: Re: [PATCH 2/8] bpf: Add bpf_get_func_ip kprobe helper for fprobe link
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Wed, Feb 9, 2022 at 7:01 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Mon, Feb 07, 2022 at 10:59:18AM -0800, Andrii Nakryiko wrote:
> > On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding support to call get_func_ip_fprobe helper from kprobe
> > > programs attached by fprobe link.
> > >
> > > Also adding support to inline it, because it's single load
> > > instruction.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/bpf/verifier.c    | 19 ++++++++++++++++++-
> > >  kernel/trace/bpf_trace.c | 16 +++++++++++++++-
> > >  2 files changed, 33 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 1ae41d0cf96c..a745ded00635 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -13625,7 +13625,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> > >                         continue;
> > >                 }
> > >
> > > -               /* Implement bpf_get_func_ip inline. */
> > > +               /* Implement tracing bpf_get_func_ip inline. */
> > >                 if (prog_type == BPF_PROG_TYPE_TRACING &&
> > >                     insn->imm == BPF_FUNC_get_func_ip) {
> > >                         /* Load IP address from ctx - 16 */
> > > @@ -13640,6 +13640,23 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> > >                         continue;
> > >                 }
> > >
> > > +               /* Implement kprobe/fprobe bpf_get_func_ip inline. */
> > > +               if (prog_type == BPF_PROG_TYPE_KPROBE &&
> > > +                   eatype == BPF_TRACE_FPROBE &&
> > > +                   insn->imm == BPF_FUNC_get_func_ip) {
> > > +                       /* Load IP address from ctx (struct pt_regs) ip */
> > > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
> > > +                                                 offsetof(struct pt_regs, ip));
> >
> > Isn't this architecture-specific? I'm starting to dislike this
>
> ugh, it is.. I'm not sure we want #ifdef CONFIG_X86 in here,
> or some arch_* specific function?


So not inlining it isn't even considered? this function will be called
once or at most a few times per BPF program invocation. Anyone calling
it in a tight loop is going to use it very-very suboptimally (and even
then useful program logic will dominate). There is no point in
inlining it.

>
> jirka
>
> > inlining whole more and more. It's just a complication in verifier
> > without clear real-world benefits. We are clearly prematurely
> > optimizing here. In practice you'll just call bpf_get_func_ip() once
> > and that's it. Function call overhead will be negligible compare to
> > other *userful* work you'll be doing in your BPF program.
> >
> >
> > > +
> > > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
> > > +                       if (!new_prog)
> > > +                               return -ENOMEM;
> > > +
> > > +                       env->prog = prog = new_prog;
> > > +                       insn      = new_prog->insnsi + i + delta;
> > > +                       continue;
> > > +               }
> > > +
> > >  patch_call_imm:
> > >                 fn = env->ops->get_func_proto(insn->imm, env->prog);
> > >                 /* all functions that have prototype and verifier allowed
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index a2024ba32a20..28e59e31e3db 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -1036,6 +1036,19 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > >         .arg1_type      = ARG_PTR_TO_CTX,
> > >  };
> > >
> > > +BPF_CALL_1(bpf_get_func_ip_fprobe, struct pt_regs *, regs)
> > > +{
> > > +       /* This helper call is inlined by verifier. */
> > > +       return regs->ip;
> > > +}
> > > +
> > > +static const struct bpf_func_proto bpf_get_func_ip_proto_fprobe = {
> > > +       .func           = bpf_get_func_ip_fprobe,
> > > +       .gpl_only       = false,
> > > +       .ret_type       = RET_INTEGER,
> > > +       .arg1_type      = ARG_PTR_TO_CTX,
> > > +};
> > > +
> > >  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
> > >  {
> > >         struct bpf_trace_run_ctx *run_ctx;
> > > @@ -1279,7 +1292,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >                 return &bpf_override_return_proto;
> > >  #endif
> > >         case BPF_FUNC_get_func_ip:
> > > -               return &bpf_get_func_ip_proto_kprobe;
> > > +               return prog->expected_attach_type == BPF_TRACE_FPROBE ?
> > > +                       &bpf_get_func_ip_proto_fprobe : &bpf_get_func_ip_proto_kprobe;
> > >         case BPF_FUNC_get_attach_cookie:
> > >                 return &bpf_get_attach_cookie_proto_trace;
> > >         default:
> > > --
> > > 2.34.1
> > >
