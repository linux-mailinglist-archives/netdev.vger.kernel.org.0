Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AF4224EE0
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 05:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgGSDwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 23:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgGSDwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 23:52:39 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6C4C0619D2;
        Sat, 18 Jul 2020 20:52:38 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so5980171qvb.11;
        Sat, 18 Jul 2020 20:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HH+LFV8ckb7MRgw6RiflBdfDfAcUZi2F+LZQ/h34g2E=;
        b=G6zbQL2BdKZN9zkB9eB/o8yJ1EIuO+inpr88GMjZB2FDXt5swCzdtRzjJsONVnjI1Z
         /uaXMPqLb+Sa1/IT3S70pz2QEcc3khjTDHzwZeDNzvR2czU6SuTlLDP1A+gkj4q/Y4dn
         KQ7JRn9Z2iLYrMLl5mfkpR/KKja9gZDK3PgmttJ6RK5tNxMlB3bwIyO4TUGxHxHctlzO
         AqVMdbDeeCPJ6NJWNnD7gybR+cj45qigTVKspkuA/scFO/NorDHf7zPI3uUtoDFmUOx5
         1arRJxN3lo+IKOlENRwknFt4eip52AQSPK/7IHJfYkdZB/hNUjHRZdZiy0k1P8kd5w05
         r5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HH+LFV8ckb7MRgw6RiflBdfDfAcUZi2F+LZQ/h34g2E=;
        b=OGJ4xzw7InvqDaZxJzKU0o44ZsnAqYH1tx1kbdMJgUh4JIQKJG+Ur5haOP4Y1qmz8w
         ZJCVF41CdXSGEmt+E6XXZxaed04SgrIMcsD03IDeMUP7fmNRi4TZGm8tEvFTvSM/VNg5
         Cf8qVzDCMPFTQMCHfjq1J0GTUk69k46zIk5Zdsf2U4vbSs4fpWazNcr0WeiWQrHah0I7
         KOzVpwpEXKgRxnjco+V0GjTVxeUblaMq90TEt7lZ2VDStr6zgrrr09PkyJEoG0GBfc0+
         2ReaD8yVElRhGIQVTZ2TYF1r44b2mL7gl4cbZcBzmNinPW56je1i72Tq5vSvy2kkr1dX
         +aXg==
X-Gm-Message-State: AOAM531KyMkLDdOgNyAOdXNqhr6b82Pm20N76aNVyjNM1i0yLnQ8tXXo
        2mCJsK6OA89aED2DNJGwXiQHHOFiDjzMG46OieY=
X-Google-Smtp-Source: ABdhPJxVfFTd4fl3vlr8dWi+hOaHpZfcw5bPem+4YNYL19k5vZ//gCbkSWsPxcwnw/YxRXCDwsl7jUSt0whKIikfnjw=
X-Received: by 2002:a05:6214:946:: with SMTP id dn6mr15722853qvb.224.1595130758033;
 Sat, 18 Jul 2020 20:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200717072319.101302-1-irogers@google.com>
In-Reply-To: <20200717072319.101302-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 18 Jul 2020 20:52:27 -0700
Message-ID: <CAEf4BzbAAzOL-7dqLnvmuhm3HZ_sNH5UWMTwzk2xbWkNggzY+g@mail.gmail.com>
Subject: Re: [PATCH] libbpf bpf_helpers: Use __builtin_offsetof for offsetof
 if available
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:24 AM Ian Rogers <irogers@google.com> wrote:
>
> The non-builtin route for offsetof has a dependency on size_t from
> stdlib.h/stdint.h that is undeclared and may break targets.
> The offsetof macro in bpf_helpers may disable the same macro in other
> headers that have a #ifdef offsetof guard. Rather than add additional
> dependencies improve the offsetof macro declared here to use the
> builtin if available.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index a510d8ed716f..ed2ac74fc515 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -40,8 +40,12 @@
>   * Helper macro to manipulate data structures
>   */
>  #ifndef offsetof
> +#if __has_builtin(__builtin_offsetof)
> +#define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
> +#else
>  #define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)

Let's either always use __builtin_offsetof (as Yonghong mentioned, it
should always be available on relevant LLVM versions). Or instead of
size_t, just cast to (unsigned long), I think it will have absolutely
the same effect as size_t casting?

>  #endif
> +#endif
>  #ifndef container_of
>  #define container_of(ptr, type, member)                                \
>         ({                                                      \
> --
> 2.28.0.rc0.105.gf9edc3c819-goog
>
