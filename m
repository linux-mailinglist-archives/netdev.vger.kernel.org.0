Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC072B5314
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbgKPUoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:32872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgKPUol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 15:44:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F0722240;
        Mon, 16 Nov 2020 20:44:38 +0000 (UTC)
Date:   Mon, 16 Nov 2020 15:44:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201116154437.254a8b97@gandalf.local.home>
In-Reply-To: <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
References: <00000000000004500b05b31e68ce@google.com>
        <20201115055256.65625-1-mmullins@mmlx.us>
        <20201116121929.1a7aeb16@gandalf.local.home>
        <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 15:37:27 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > Mathieu,
> > 
> > Can't we do something that would still allow to unregister a probe even if
> > a new probe array fails to allocate? We could kick off a irq work to try to
> > clean up the probe at a later time, but still, the unregister itself should
> > not fail due to memory failure.  
> 
> Currently, the fast path iteration looks like:
> 
>                 struct tracepoint_func *it_func_ptr;
>                 void *it_func;
> 
>                 it_func_ptr =                                           \
>                         rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
>                 do {                                                    \
>                         it_func = (it_func_ptr)->func;                  \
>                         __data = (it_func_ptr)->data;                   \
>                         ((void(*)(void *, proto))(it_func))(__data, args); \
>                 } while ((++it_func_ptr)->func); 
> 
> So we RCU dereference the array, and iterate on the array until we find a NULL
> func. So you could not use NULL to skip items, but you could perhaps reserve
> a (void *)0x1UL tombstone for this.

Actually, you could just set it to a stub callback that does nothing. then
you don't even need to touch the above macro. Not sure why I didn't
recommend this to begin with, because that's exactly what the function
tracer does with ftrace_stub.


> 
> It should ideally be an unlikely branch, and it would be good to benchmark the
> change when multiple tracing probes are attached to figure out whether the
> overhead is significant when tracing is enabled.

If you use a stub function, it shouldn't affect anything. And the worse
that would happen is that you have a slight overhead of calling the stub
until you can properly remove the callback.

> 
> I wonder whether we really mind that much about using slightly more memory
> than required after a failed reallocation due to ENOMEM. Perhaps the irq work
> is not even needed. Chances are that the irq work would fail again and again if
> it's in low memory conditions. So maybe it's better to just keep the tombstone
> in place until the next successful callback array reallocation.
> 

True. If we just replace the function with a stub on memory failure (always
using __GFP_NOFAIL, and if it fails to reallocate a new array, just replace
the callback with the stub and be done with it. It may require some more
accounting to make sure the tracepoint.c code can handle these stubs, and
remove them on new additions to the code. Heck, if a stub exists, you could
just swap it with a new item. But on any new changes to the list, the stubs
should be purged.


-- Steve
