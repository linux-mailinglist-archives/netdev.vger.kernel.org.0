Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3766429D8ED
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389101AbgJ1WlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730725AbgJ1Wk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:40:58 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D610C0613CF;
        Wed, 28 Oct 2020 15:40:58 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b138so542324yba.5;
        Wed, 28 Oct 2020 15:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jg45dpTkIStnq7FH8sB1G6csIoi0LJaAOaqWI/KVCvI=;
        b=noS8dvS1P9698Fp6wHJWJPKA+/s9WfOrs3eI0eKM7tXYQIY+jDH6Ivu06+vFjdr6tR
         m82s7srotwXwMAhUpxBzkw9o/OMYtJra6MkONeYOdQZMK8DZ5nh9f0DuuUpXSzx9xjC/
         Is5X+0B55s4egZElRcBoYkhwSx5z+lbt43kRaGUeEyTJqn0EmwZZyr79GyLfJXIJZxyx
         mDGGiIO+maiihAloxafvli/rpUTQy8IoP/1sn9Hk4DEK+WFy0R4/7jpVFFzRfotzH8sR
         45ToxSia4MLemgUbQ9+HCYWdSwPzcwEC5U97K78w1YtRk5q3bBSM8687/prdUbe6YM1c
         rzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jg45dpTkIStnq7FH8sB1G6csIoi0LJaAOaqWI/KVCvI=;
        b=bNP0xXFHnzBit1JPYBlxKg1ev4E86bZ0uwAQeCaNgXE2lzN81q1T3oA3rSnJVr0/Hf
         lLlJZpX+0rwBwJlSEbhtO/9YXS42useXwywouY2N/6lqypr+XaHZPnh0KWmz9vAgs9rI
         5TCic22NNSVYMSkJ5b3gr+YjB2Abs264l/pDdP5pp2OjBw0eTC9U4oO7ryY0budz4a2E
         gKUAKyQCbWAXaUXQWfyDjNZe9abAhnaS6zpNpAnyQ+YyZpEWH8fxvCD0NWYzu3keLe5M
         nkHNSh9WQ+L9lLX+5g9QkxY45eC47rutejmM50+XLONjyuNE2N9fk6zYW23ZatQ2P/kk
         HfAw==
X-Gm-Message-State: AOAM532UOVWIJ6bUXLP1SxN9a2QHnwq9wCy0ZvpOIjuL1tWLJ5j+GXpC
        6wOigaEvulvjtLuRJ5yMPCzA6y2R22Y7VsY1qYQ=
X-Google-Smtp-Source: ABdhPJzjR9v72td9M8NZQP+eitD1eMiz3OsKtziYoQQJVouthGxKy6BQyiXpmiZ9+bPbeYxIQSPgdVC+fQkcTwS6lm4=
X-Received: by 2002:a25:c001:: with SMTP id c1mr1976005ybf.27.1603924857840;
 Wed, 28 Oct 2020 15:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-8-jolsa@kernel.org>
 <20201028182534.GS2900849@krava>
In-Reply-To: <20201028182534.GS2900849@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Oct 2020 15:40:46 -0700
Message-ID: <CAEf4BzarrQLrh4PXZvMmrL8KpBTjB65V9+jxn0os-Yd2jN2aYQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 07/16] kallsyms: Use rb tree for kallsyms name search
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 3:29 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 22, 2020 at 10:21:29AM +0200, Jiri Olsa wrote:
> > The kallsyms_expand_symbol function showed in several bpf related
> > profiles, because it's doing linear search.
> >
> > Before:
> >
> >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> >
> >      2,535,458,767      cycles:k                         ( +-  0.55% )
> >        940,046,382      cycles:u                         ( +-  0.27% )
> >
> >              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> >
> > Loading all the vmlinux symbols in rbtree and and switch to rbtree
> > search in kallsyms_lookup_name function to save few cycles and time.
> >
> > After:
> >
> >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> >
> >      2,199,433,771      cycles:k                         ( +-  0.55% )
> >        936,105,469      cycles:u                         ( +-  0.37% )
> >
> >              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
> >
> > Each symbol takes 160 bytes, so for my .config I've got about 18 MBs
> > used for 115285 symbols.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> FYI there's init_kprobes dependency on kallsyms_lookup_name in early
> init call, so this won't work as it is :-\ will address this in v2
>
> also I'll switch to sorted array and bsearch, because kallsyms is not
> dynamically updated

what about kernel modules then?

>
> jirka
>
> > ---
> >  kernel/kallsyms.c | 95 ++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 86 insertions(+), 9 deletions(-)
> >

[...]
