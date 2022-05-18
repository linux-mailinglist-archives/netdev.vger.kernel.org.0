Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBEF52C784
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiERXaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiERXa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:30:27 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F83A453;
        Wed, 18 May 2022 16:30:26 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z18so4065185iob.5;
        Wed, 18 May 2022 16:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=djedkBDi+8zWqgyVt5n6pW1897poIA400VsIQL/2AmE=;
        b=FL2Ljq88KYPj2Npog0hufOGImM6ULpu1c9P/eWxubiUrTg18JKMC2KqgoYBBWHZc9e
         XchM9cth2XGNNfb2rIYLYnE9JHjmVCd3vtFZYIzMzwe7iApNQY40bQmQ1lL9IHeuARob
         i0NoGfjq12ejxPKfGDuGj6Vy1wm0WLAyXVHBYBkmvRW/vv/6k4c0n8USC/c8err7podN
         gbUbY8pPkjq3gxcME3b5nRJG7wMgEyDyiPuG0O+O1RWqXxnAx4eRWc+ZaCz09E/pesFf
         jJ8EjNqdnS7HPWX6luztYtALBIftHW73bZf5OveElqdOoeyBwjPKCjmZfZDIQNMnrAxA
         CUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djedkBDi+8zWqgyVt5n6pW1897poIA400VsIQL/2AmE=;
        b=cQPRWN4KATYdj7PQcOmxRkqoHBqSirRqIKqBqgwlHjtcKUHXhQiznyOHxko4QPh+WD
         GGS5y+6Pa4ZWJ2cMWXKtOwR2lljsRwMdqY2TrZcszlnNbB1C1fm9i3jBdqvEkUkmZ16i
         rGi97YnCCCpKtJdVRcRSX/K/EJ6mabpYIZr+ySK3O7enOsFUqc2jyQ+s7yJdkJi8L1G2
         1j2OYhTKGL8hcJmu20lEKAivuLgwMXOnDcBFMGM1hYq2+oCbETli47nruMP76dX8fAl3
         NBVwDgErNhVnxe8lKpBIxOU5AElMd75K77C/h3JeFXSoSWZwQ9ttP8dzhebWcCrNr7Og
         rYqw==
X-Gm-Message-State: AOAM530ied276DmtKEdm/evWEJ7Ql1CfJlqs8/sVjzMMTO6Ut20HIsvf
        vLpDlekCnC9r8WHBNyWPQ+ZnMqjYp0NvcPugIjqi3hif9XY=
X-Google-Smtp-Source: ABdhPJytTZMA2W2Z3i+RuSGnuqUXeAYwr/U7M6Hf6G5aB4AGspo8jAYctj/4m/xLHXO7tRX40uAcaXYdedJEw8fHi6s=
X-Received: by 2002:a05:6638:2393:b0:32e:319d:c7cc with SMTP id
 q19-20020a056638239300b0032e319dc7ccmr1088400jat.103.1652916625675; Wed, 18
 May 2022 16:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
In-Reply-To: <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 16:30:14 -0700
Message-ID: <CAEf4BzYpNZSY+D6_QP4NE2dN25g4wD43UmJyzmqXCL=HOE9HFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/4] bpf_trace: check size for overflow in bpf_kprobe_multi_link_attach
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
> Check that size would not overflow before calculation (and return
> -EOVERFLOW if it will), to prevent potential out-of-bounds write
> with the following copy_from_user.  Use kvmalloc_array
> in copy_user_syms to prevent out-of-bounds write into syms
> (and especially buf) as well.
>
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Cc: <stable@vger.kernel.org> # 5.18
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 7141ca8..9c041be 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2261,11 +2261,11 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
>         int err = -ENOMEM;
>         unsigned int i;
>
> -       syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
> +       syms = kvmalloc_array(cnt, sizeof(*syms), GFP_KERNEL);
>         if (!syms)
>                 goto error;
>
> -       buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
> +       buf = kvmalloc_array(cnt, KSYM_NAME_LEN, GFP_KERNEL);
>         if (!buf)
>                 goto error;
>
> @@ -2461,7 +2461,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>         if (!cnt)
>                 return -EINVAL;
>
> -       size = cnt * sizeof(*addrs);
> +       if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +               return -EOVERFLOW;
>         addrs = kvmalloc(size, GFP_KERNEL);

any good reason not to use kvmalloc_array() here as well and delegate
overflow to it. And then use long size (as expected by copy_from_user
anyway) everywhere?

>         if (!addrs)
>                 return -ENOMEM;
> --
> 2.1.4
>
