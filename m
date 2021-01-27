Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C3A305E5A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhA0Ocb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhA0Obc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 09:31:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B8B207C8;
        Wed, 27 Jan 2021 14:30:49 +0000 (UTC)
Date:   Wed, 27 Jan 2021 09:30:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v2] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20210127093048.46a6c4eb@gandalf.local.home>
In-Reply-To: <5ca3fcc1-b8fb-546e-5e75-3684efb19a6f@ozlabs.ru>
References: <20201117211836.54acaef2@oasis.local.home>
        <CAADnVQJekaejHo0eTnnUp68tOhwUv8t47DpGoOgc9Y+_19PpeA@mail.gmail.com>
        <20201118074609.20fdf9c4@gandalf.local.home>
        <5ca3fcc1-b8fb-546e-5e75-3684efb19a6f@ozlabs.ru>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 18:08:34 +1100
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> 
> I am running syzkaller and the kernel keeps crashing in 
> __traceiter_##_name. This patch makes these crashes happen lot less 

I have another solution to the above issue. But I'm now concerned with what
you write below.

> often (and so did the v1) but the kernel still crashes (examples below 
> but the common thing is that they crash in tracepoints). Disasm points 
> to __DO_TRACE_CALL(name) and this fixes it:
> 
> ========================
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -313,6 +313,7 @@ static inline struct tracepoint 
> *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>                                                                          \
>                  it_func_ptr =                                           \
>  
> rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
> +               if (it_func_ptr)                                        \

Looking at v2 of the patch, I found a bug that could make this happen.

I'm looking at doing something else that doesn't affect the fast path nor
does it bloat the kernel more than necessary.

I'll see if I can get that patch out today.

Thanks for the report.

-- Steve
