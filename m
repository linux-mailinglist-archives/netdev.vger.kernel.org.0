Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4840C4E4823
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiCVVMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiCVVMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:12:40 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC642662;
        Tue, 22 Mar 2022 14:11:12 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id w7so21733125ioj.5;
        Tue, 22 Mar 2022 14:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOYK8So+AZd7TCdsavhK7vVzd9phodxyXPohOzcUiLk=;
        b=EBOGdm18SbzOZ7SoijcSpi89A8Gqmkx7spYqqvHhu/4nSaNWG5/41Lt3FtfJKHCYTB
         FE5dyMMy688ylsK9sbe0xNWkmo5UxHfQ5Q5WHzmK+5ekxQX28j7l85nexRBOFOtlGegG
         QrpOp7Fb136h56arpx54x2LvF+9jmLevFqhKyp9A18V7XhpjR2q0Eo0wlJa73sR+aPBa
         QnlpvemHgShB2Y32sHehxPxKUXS7SfH7UW94UkIsDszM1n1VvwGEjn7QlTioaNV6ZhjY
         Y0hxvH1GR7kevyMoiJCyZ2dPsWdE+svvPYUntdD1FNXZp+LAGtJcw7vcmf5vnv1lWCIU
         9Hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOYK8So+AZd7TCdsavhK7vVzd9phodxyXPohOzcUiLk=;
        b=sHVGOFSbZjstXtdeWXZYz/+KLmRkLM4QNycG8gJXPKHCW4GnTMwHlXFwsz9erMrHxn
         FqJdn1EA8blA6ZW/WoFeNivU+F6sO4+HRjLGdvJzPb8w/ca/lVQuvxmM3djUt0D9EeUj
         kf8eBYPmRUqf2rnGTgugTJxoekgixfqepZqNLGCydUTMSSId/ZTwiWgsEQkVD87e6S09
         zdShW0Fp9JMOUrxJqEzue3FY22GMOpXS6FL6mzFi6QLJ/MJPklCWW26NZVUZx/xzYVSL
         6ZogmZ8ZVk68yuDQqKHt9HhXaoSaWTXSG6aGlgG+2kTATHUYidDIpv5F4iZfhsZN0yKM
         FJ2g==
X-Gm-Message-State: AOAM531F3TlYyZrXNMX1qiq1afOiQCPpan9zsddUyo6mCdy2DLdP1UeL
        6eWcHyL55AfTAVxSrtU/T1qEjZ5G3MNGEF971ZA=
X-Google-Smtp-Source: ABdhPJxQ8ciZugCOaMDEqnXzdB8fCr1OaU+2a+phF5zQ6eW1zI6UgiSFdoJ96ZoyKdT2wraBHpWmXCVjtzoq+gFSLXA=
X-Received: by 2002:a05:6638:4516:b0:321:4911:c292 with SMTP id
 bs22-20020a056638451600b003214911c292mr4901855jab.145.1647983472263; Tue, 22
 Mar 2022 14:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220322112843.6687-1-hanyihao@vivo.com>
In-Reply-To: <20220322112843.6687-1-hanyihao@vivo.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Mar 2022 14:11:01 -0700
Message-ID: <CAEf4Bza5Lo8eyx3bkwV9jfoHFLm0sRSE8UFoatzVA0y4sJQr9A@mail.gmail.com>
Subject: Re: [PATCH] bpf: use vmemdup_user instead of kvmalloc and copy_from_user
To:     Yihao Han <hanyihao@vivo.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel@vivo.com
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

On Tue, Mar 22, 2022 at 4:29 AM Yihao Han <hanyihao@vivo.com> wrote:
>
> fix memdup_user.cocci warning:
> kernel/trace/bpf_trace.c:2450:12-20: WARNING opportunity
> for vmemdup_user
>
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>  kernel/trace/bpf_trace.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 7fa2ebc07f60..aff2461c1ea2 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2447,13 +2447,9 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>
>         ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>         if (ucookies) {
> -               cookies = kvmalloc(size, GFP_KERNEL);
> -               if (!cookies) {
> -                       err = -ENOMEM;
> -                       goto error;
> -               }
> -               if (copy_from_user(cookies, ucookies, size)) {
> -                       err = -EFAULT;
> +               cookies = vmemdup_user(ucookies, size);

does kvfree() handle ERR_PTR() values properly? I doubt so. Did you
validate your change or just blindly applied some tool?

> +               if (IS_ERR(cookies)) {
> +                       err = PTR_ERR(cookies);
>                         goto error;
>                 }
>         }
> --
> 2.17.1
>
