Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318F652C7DD
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiERXkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiERXkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:40:16 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC8A19F9C;
        Wed, 18 May 2022 16:40:09 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id j4so2568924ilo.12;
        Wed, 18 May 2022 16:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ds55Bsv2GoSLlas6Dx1JEfsoZ0HMGPTIqjaaEFNjM4s=;
        b=MVMSLxVIfMq48TSV7NuTXRJi2JtJzM91wrtDADX9u2HqOcsQUMjXvUm4zvK4CPu36c
         wDxujsuklyIUW0r6/LEpbQB7hK7CUJpIk/ovM3JmNfqK3wJ8QnegsLalRNx1N5FGhYTP
         KG7GsiZnAJ4FASfvM/GjdpMZ1/lSweyRDeLkTzdgFQ9aqo5rdTOlPkgzh8445SQQ0469
         BI64pssj+QQE53NHn/jMCxOrrc8VjOJ8kNJ7yBReJvmrra9H3kYcF20VWUwgUrnzHltL
         yAlbgsBuJs8PkGP+MeL3bod+O/uFHTaksgZC0z6rEFF3upqPDWv4IVmoYbWm5C5NhB9h
         odPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ds55Bsv2GoSLlas6Dx1JEfsoZ0HMGPTIqjaaEFNjM4s=;
        b=DPCXA1O3OJ6jhDGw/HbDuPchBAwqPHbiMCk5xvt0YwiZGzhlDUGMioGal3dWsLEOvS
         +U7ZCfrH/+vo8vOL4F4jbwRMhqSNMhX6PE+pr3LCDR4r6fhjVAHksqnz3rmuVTtXIRJz
         Dp3XXITXr/AmY2IgnMj2xSQ3B0ZZGHzzXrt3ZrJ4mON07MgpgEEDMWTQwc0Gg65OYsHC
         7YknHJeYbDyWGEos3S0bUVDVauv8M9wesIKHjzLcy56puxcepWZQN8F2E+cSfEzV9flU
         pTyT3uh4qm1npz9wbguy5DFc0vAOtsJUln0j03jZoV69NyI0TP2goT8IIPO488iJjakg
         RN+Q==
X-Gm-Message-State: AOAM531QDmqUKgSsw1SoC1lKtnqpfbrZv3cpdmM3NWhk1+XcUdoAmP8K
        uAw/uvL4wfwvhHG0X9lsF04SDkyrQ4ERsQC1nqrfxurq
X-Google-Smtp-Source: ABdhPJx71PNkY/+fugXu0eLFpyXyRIK3eZEfdpKQ/KC0+btRbofLGvd6mL81LdgeIgjGNpQxGpU+oyIwAPfF1yq1fH4=
X-Received: by 2002:a05:6e02:1c01:b0:2d1:262e:8d5f with SMTP id
 l1-20020a056e021c0100b002d1262e8d5fmr1115383ilh.98.1652917208798; Wed, 18 May
 2022 16:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <2a56d66cf4b9430982e81233f49d6c54988df056.1652772731.git.esyr@redhat.com>
In-Reply-To: <2a56d66cf4b9430982e81233f49d6c54988df056.1652772731.git.esyr@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 16:39:58 -0700
Message-ID: <CAEf4BzbnWM9BfQwjQtgwjx+OXBEkejxs2czz3DQbeoCAXPj11g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/4] bpf_trace: handle compat in copy_user_syms
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Tue, May 17, 2022 at 12:36 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> For compat processes, userspace size for syms pointers is different.
> Provide compat handling for copying array elements from the user space.
>
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index a93a54f..9d3028a 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2253,6 +2253,24 @@ struct user_syms {
>         char *buf;
>  };
>
> +static inline int get_arr_ptr(unsigned long *p,
> +                             unsigned long __user *uaddr, u32 idx)

no need for inline, let compiler decide on inlining

> +{
> +       if (unlikely(in_compat_syscall())) {

not sure unlikely() is justified for code...

> +               compat_uptr_t __user *compat_uaddr = (compat_uptr_t __user *)uaddr;
> +               compat_uptr_t val;
> +               int err;
> +
> +               err = __get_user(val, compat_uaddr + idx);
> +               if (!err)
> +                       *p = val;
> +
> +               return err;
> +       } else {
> +               return __get_user(*p, uaddr + idx);
> +       }
> +}
> +
>  static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32 cnt)
>  {
>         unsigned long __user usymbol;
> @@ -2270,7 +2288,7 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
>                 goto error;
>
>         for (p = buf, i = 0; i < cnt; i++) {
> -               if (__get_user(usymbol, usyms + i)) {
> +               if (get_arr_ptr(&usymbol, usyms, i)) {
>                         err = -EFAULT;
>                         goto error;
>                 }
> --
> 2.1.4
>
