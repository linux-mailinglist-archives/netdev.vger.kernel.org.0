Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656B32B757E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 05:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgKREyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 23:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKREyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 23:54:38 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF59C0613D4;
        Tue, 17 Nov 2020 20:54:37 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id b17so855065ljf.12;
        Tue, 17 Nov 2020 20:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24I/WT5xTNW1yvAVuhk4A7C50i+fvd2snMwqHW+u8Nk=;
        b=G6R3A11ahdh3cYIpWNa0N6dA0YYnKBFSFrzU4Ss+4TrPfX+pGkpi8kDODnHn//L9rr
         ravF95L84iESHOu4Q6oNmJDD5H+P5892x5ce89m34k3KonqNkWwCP1FERQjHdSDjCFDs
         rOUoxNSl/xaIVWWaB758D3HFcFGR/mr428sqg7szyX9teqSl/H49M94Uzh95MQiL1yh4
         XZX2EEV2I3AAbGMvaKKGK+icpD27qjUYbMz75Sce/GG3OOAFHik04W1MOCE7gjTf1+w/
         2m2LD6dBhUWuWdAApz3fcecNkVzZC8pnVW09/3Ht+skBbZuJn1uiQAoEEG2zZThuJFDP
         wcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24I/WT5xTNW1yvAVuhk4A7C50i+fvd2snMwqHW+u8Nk=;
        b=clrv7LlVvLT1XUNvZDwNmH7L2fkp+v7cR3aNblMiDAQ4oYuw6RWp7Yfx+TD8iGcUad
         T7Z7gXx89GIAFN+XASbBTkqi6iJP5tNypBbB7p+FmjZOkWp2KYqbYgY+c4cy4x/YJx6j
         +TiR2HAkReA1UVOHzU0NiLEYwssDO3HfqieN/tbQfNOP5V39cJUzqytdrVJ9HTQOqe79
         Mq6zw/FlvLY1vTK2RF1oNz0xPD1zpQcirjmjjSxo3TkHa/ngVSHm5TQG+YvzAdw0GTj1
         WC8j50VybU3rKMX3CPVj4kHlKzBYlUPVPzZH1ARgD19x4Sc9bhsL7GUEZJbyW0Y7gD+2
         AtFQ==
X-Gm-Message-State: AOAM530mgrjRreyFduwWSDe14NLsNLv/LNKmQ9EtIamTK/EZD0YBhQrS
        FBbyVwATtmT2JKxvxFgnrY0IIPArChUeW8wcQhk=
X-Google-Smtp-Source: ABdhPJz7nUymGspt8aiNrrgqyIe6rvpOCrj7CMFudnEGMVGpeR/xW3VUKLq8SFHlrz0MntLOYYN2Nmakg8//r/3FIhQ=
X-Received: by 2002:a2e:1643:: with SMTP id 3mr3615213ljw.290.1605675276080;
 Tue, 17 Nov 2020 20:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20201117211836.54acaef2@oasis.local.home>
In-Reply-To: <20201117211836.54acaef2@oasis.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Nov 2020 20:54:24 -0800
Message-ID: <CAADnVQJekaejHo0eTnnUp68tOhwUv8t47DpGoOgc9Y+_19PpeA@mail.gmail.com>
Subject: Re: [PATCH v2] tracepoint: Do not fail unregistering a probe due to
 memory allocation
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Matt Mullins <mmullins@mmlx.us>, paulmck <paulmck@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 6:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> The list of tracepoint callbacks is managed by an array that is protected
> by RCU. To update this array, a new array is allocated, the updates are
> copied over to the new array, and then the list of functions for the
> tracepoint is switched over to the new array. After a completion of an RCU
> grace period, the old array is freed.
>
> This process happens for both adding a callback as well as removing one.
> But on removing a callback, if the new array fails to be allocated, the
> callback is not removed, and may be used after it is freed by the clients
> of the tracepoint.
>
> There's really no reason to fail if the allocation for a new array fails
> when removing a function. Instead, the function can simply be replaced by a
> stub that will be ignored in the callback loop, and it will be cleaned up
> on the next modification of the array.
>
> Link: https://lore.kernel.org/r/20201115055256.65625-1-mmullins@mmlx.us
> Link: https://lkml.kernel.org/r/20201116175107.02db396d@gandalf.local.home
>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@chromium.org>
> Cc: netdev <netdev@vger.kernel.org>
> Cc: bpf <bpf@vger.kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: 97e1c18e8d17b ("tracing: Kernel Tracepoints")
> Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
> Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
> Reported-by: Matt Mullins <mmullins@mmlx.us>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> Changes since v1:
>    Use 1L value for stub function, and ignore calling it.
>
>  include/linux/tracepoint.h |  9 ++++-
>  kernel/tracepoint.c        | 80 +++++++++++++++++++++++++++++---------
>  2 files changed, 69 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 0f21617f1a66..2e06e05b9d2a 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -33,6 +33,8 @@ struct trace_eval_map {
>
>  #define TRACEPOINT_DEFAULT_PRIO        10
>
> +#define TRACEPOINT_STUB                ((void *)0x1L)
> +
>  extern struct srcu_struct tracepoint_srcu;
>
>  extern int
> @@ -310,7 +312,12 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>                 do {                                                    \
>                         it_func = (it_func_ptr)->func;                  \
>                         __data = (it_func_ptr)->data;                   \
> -                       ((void(*)(void *, proto))(it_func))(__data, args); \
> +                       /*                                              \
> +                        * Removed functions that couldn't be allocated \
> +                        * are replaced with TRACEPOINT_STUB.           \
> +                        */                                             \
> +                       if (likely(it_func != TRACEPOINT_STUB))         \
> +                               ((void(*)(void *, proto))(it_func))(__data, args); \

I think you're overreacting to the problem.
Adding run-time check to extremely unlikely problem seems wasteful.
99.9% of the time allocate_probes() will do kmalloc from slab of small
objects.
If that slab is out of memory it means it cannot allocate a single page.
In such case so many things will be failing to alloc that system
is unlikely operational. oom should have triggered long ago.
Imo Matt's approach to add __GFP_NOFAIL to allocate_probes()
when it's called from func_remove() is much better.
The error was reported by syzbot that was using
memory fault injections. ENOMEM in allocate_probes() was
never seen in real life and highly unlikely will ever be seen.
