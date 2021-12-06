Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB09E46AA9D
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352269AbhLFVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352228AbhLFVo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:44:56 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5470C0613F8;
        Mon,  6 Dec 2021 13:41:27 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id x32so35063202ybi.12;
        Mon, 06 Dec 2021 13:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxZy0XR9HlJMLfuceIjDkbVn420DcQmmb11xM7v+pC4=;
        b=Uy4wpl27CC6YUhcs4vMM8bzdvcMUN96yWwKoi6QIbs/0SRbl8kKo5Q0I1qsAzabDYa
         ppqV7z4tTdnNTApPZZoy/OHbum0UqMV87y1+Y1VYbvI4uJjZE4LZgiADsi8qE8FhHHFe
         age8I8KTGLWzwyq0IDoDwsM7Pd3QWiW6pN0f23SV5X2bhwZBnCyKKZ4t/RIfYpe/ojxC
         9FM3s4MSJoZPnQpp/tFUGRx2jv7qX0bkbGVRThB3zqK6dsLz+slB2POKEhierLXgKFuU
         wODBeF7sV3LX1hWu9JWwHSt7dhiauTrdSoJ1GxgklmKGoHI87FipafRGEzvXdx9dYwc3
         ymhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxZy0XR9HlJMLfuceIjDkbVn420DcQmmb11xM7v+pC4=;
        b=ezpySTiTRUqqYZ43IDV58fn9Thf06dUmWm5Uk4aq7IenmTQCIr/JDWfSsTN4soMW2f
         EEetAql+5EhD7zCjz0auenUjc2tHYPUwgKqlQ2CRr9VvpHPtzcK3PVUnZ1YUrTsm7AhL
         0a2rlP0nt3yU5wt5Amwm/UZ/ABEGBCobu1pGauqGzRPyEXPWJIDu4acM6mRrLoFV77id
         ykLnEHJs4H+DQj0bMHySg1E6hcc4MSnxcE2LgQSukaFz/bWvqnXPErYfMKkytVVB1c3Z
         i1vQqde35/71zZkhWnNUCTSu8I1hfYd+HlGeBxJ4l3Fgm+LoZh34nEvWcT/HzjSE+JsZ
         KqCA==
X-Gm-Message-State: AOAM531W4oPhXe3QbgDk9JRljuxrFaHhghB4c8qEXGiB8Z+iokBDcOak
        dRv5yLp5ie0sgIwBpAAG5eGDhJn2B7+1d1s7QqI=
X-Google-Smtp-Source: ABdhPJzu8GLPMPPYWZcNRWvmOS1fpwI+HDUJe9wRLBoKB0+NVeBf9dCRmjbImw/D/lmpwAul7tBD5ZUOwCTFnKu/pQs=
X-Received: by 2002:a25:6d4:: with SMTP id 203mr45537909ybg.83.1638826886839;
 Mon, 06 Dec 2021 13:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20211204140700.396138-1-jolsa@kernel.org> <20211204140700.396138-2-jolsa@kernel.org>
In-Reply-To: <20211204140700.396138-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 13:41:15 -0800
Message-ID: <CAEf4BzYGKW1mJ28TtL3iD5-AcDb+Ua0aqPAdnPjtbneEZqyr2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf, x64: Replace some stack_size usage with
 offset variables
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 6:07 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> As suggested by Andrii, adding variables for registers and ip
> address offsets, which makes the code more clear, rather than
> abusing single stack_size variable for everything.
>
> Also describing the stack layout in the comment.
>
> There is no function change.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 42 ++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 1d7b0c69b644..b106e80e8d9c 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>                                 void *orig_call)
>  {
>         int ret, i, nr_args = m->nr_args;
> -       int stack_size = nr_args * 8;
> +       int regs_off, ip_off, stack_size = nr_args * 8;
>         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
>         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
>         struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> @@ -1956,14 +1956,33 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>         if (!is_valid_bpf_tramp_flags(flags))
>                 return -EINVAL;
>
> +       /* Generated trampoline stack layout:
> +        *
> +        * RBP + 8         [ return address  ]
> +        * RBP + 0         [ RBP             ]
> +        *
> +        * RBP - 8         [ return value    ]  BPF_TRAMP_F_CALL_ORIG or
> +        *                                      BPF_TRAMP_F_RET_FENTRY_RET flags
> +        *
> +        *                 [ reg_argN        ]  always
> +        *                 [ ...             ]
> +        * RBP - regs_off  [ reg_arg1        ]
> +        *

I think it's also worth mentioning that context passed into
fentry/fexit programs are pointing here (makes it a bit easier to
track those ctx[-1] and ctx[-2] in the next patch.


> +        * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
> +        */
> +
>         /* room for return value of orig_call or fentry prog */
>         save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
>         if (save_ret)
>                 stack_size += 8;
>
> +       regs_off = stack_size;
> +
>         if (flags & BPF_TRAMP_F_IP_ARG)
>                 stack_size += 8; /* room for IP address argument */
>
> +       ip_off = stack_size;
> +

[...]
