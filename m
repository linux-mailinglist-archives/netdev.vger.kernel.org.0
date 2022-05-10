Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527C05223A7
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348837AbiEJSR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348991AbiEJSQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:16:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B6D48E76;
        Tue, 10 May 2022 11:10:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id bo5so15591586pfb.4;
        Tue, 10 May 2022 11:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NxitTfSKesnnva4llqspEEmH1JhQn8Yta6nGnZ+J5WY=;
        b=E1t4DfqR5lOpRtgjzpMuYOACkMtYGWCtsmn6b+l80lYiPm4y99wFweIdHuSEA6iqh5
         m12L00jUGX3nwKYailyCKKMmkSDavY3+QTooUO3w34tL5zSoILl9Ix+N5a4U3L9Pg72v
         8hzPT8TArXiny5qpPCEM/DzqQFMVXW/VT3wG1dd1OnRAvb+wxxvasD1AevPTYcK9HDBZ
         BH4lrG1n9kONQ3AoTmjlS/sQwlLa7GMVrQxZdFFegxHaPpIjm+A9FRQtRhl6vPePwEbm
         mtPW/cqAr3yglubYMgbTGw/hKjdrN2G3DySdkeQHxDYiex1F13LeqMzluQn573GYwv3F
         BbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NxitTfSKesnnva4llqspEEmH1JhQn8Yta6nGnZ+J5WY=;
        b=OtrTiFRvp+Yk+Xr9292ggDpHjhI4qIFf1upJcJuthXdxwbuLdTLeNJMR6iO2txOBfP
         9i2QCocW7UqahsQUmFZIr/GsPG3+W1Ege2BSOFulbdyY+K966SI0ql7kc3Mbu2LUzXzf
         ck7O6A4XTCyVmqOJKZXE6L1YCXKq2llOWcFQy3dvYzSMiUzCkUr2sYnvkdNF3DK/Qtnd
         ULp39BMHinKKMUwC6RPC88W6tKWAroAZMZJ3UcvjIGGCXfs43dYH/VVaaoYgmv5Xa7Pr
         l4iUMPFGj1XA1pAeY5rgt0sl9sLV2Y4UE/lg2LvUfZ0YbM4xX6vDu5atBSsDFZM74BdD
         V8cQ==
X-Gm-Message-State: AOAM5331tQyKbFAd9IYcPBpg1F59p+oNDnN7EFzsZLEi/BrtvXCtcz/O
        1Kpo1lxkTBWvM6yEeg8ivbnJJHLdg47gxi40lyQ=
X-Google-Smtp-Source: ABdhPJxAAG9qIczR0J4LIkXo822fcHu4YrI6RMm9dcwY50p31FqMcWiUMufc4c3dp6Q5Pv/3f6gK7zX+CrubStqosko=
X-Received: by 2002:a63:8343:0:b0:3c6:b375:9584 with SMTP id
 h64-20020a638343000000b003c6b3759584mr9717554pge.546.1652206246513; Tue, 10
 May 2022 11:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220506142148.GA24802@asgard.redhat.com>
In-Reply-To: <20220506142148.GA24802@asgard.redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 10 May 2022 11:10:35 -0700
Message-ID: <CAADnVQKNkEX-caBjozegRaOb67g1HNOHn1e-enRk_s-7Gtt=gg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf_trace: bail out from bpf_kprobe_multi_link_attach
 when in compat
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
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
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

On Fri, May 6, 2022 at 7:22 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
> for whatever reason,

Jiri,
why did you add this restriction?

> having it enabled for compat processes on 64-bit
> kernels makes even less sense due to discrepances in the type sizes
> that it does not handle.

I don't follow this logic.
bpf progs are always 64-bit. Even when user space is 32-bit.
Jiri's check is for the kernel.

> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d8553f4..9560af6 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2410,7 +2410,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>         int err;
>
>         /* no support for 32bit archs yet */
> -       if (sizeof(u64) != sizeof(void *))
> +       if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
>                 return -EOPNOTSUPP;
>
>         if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
> --
> 2.1.4
>
