Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63402B9950
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgKSRax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgKSRaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:30:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 888B5208B6;
        Thu, 19 Nov 2020 17:30:49 +0000 (UTC)
Date:   Thu, 19 Nov 2020 12:30:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains@vger.kernel.org
Subject: Re: violating function pointer signature
Message-ID: <20201119123047.66a22235@gandalf.local.home>
In-Reply-To: <CAADnVQL8d5zKTE_TohUcGgKKp6K1Noo7M22t_hKYQjO_g0Mb0g@mail.gmail.com>
References: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
        <20201118121730.12ee645b@gandalf.local.home>
        <20201118181226.GK2672@gate.crashing.org>
        <87o8jutt2h.fsf@mid.deneb.enyo.de>
        <20201118135823.3f0d24b7@gandalf.local.home>
        <20201118191127.GM2672@gate.crashing.org>
        <20201119083648.GE3121392@hirez.programming.kicks-ass.net>
        <20201119143735.GU2672@gate.crashing.org>
        <20201119095951.30269233@gandalf.local.home>
        <CAADnVQL8d5zKTE_TohUcGgKKp6K1Noo7M22t_hKYQjO_g0Mb0g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 09:04:57 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Nov 19, 2020 at 6:59 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > Linux obviously
> > supports multiple architectures (more than any other OS), but it is pretty
> > stuck to gcc as a compiler (with LLVM just starting to work too).
> >
> > We are fine with being stuck to a compiler if it gives us what we want.  
> 
> I beg to disagree.

I think you misunderstood.

> android, chrome and others changed their kernel builds to
> "make LLVM=1" some time ago.
> It's absolutely vital for the health of the kernel to be built with
> both gcc and llvm.

That's what I meant with "LLVM just starting to work too".

LLVM has been working hard to make sure that it can do the same tricks that
the kernel depends on gcc for. And LLVM appears to be working fine with the
nop stub logic (it's already in 5.10-rc with with the static callers).

We can easily create a boot up test (config option) that will test it, and
if a compiler breaks it, this test would trigger a failure.

Again, both static calls and tracepoint callbacks are limited in what they
can do. Both return void, and both do are not variadic functions. Although
passing in a struct as a parameter is possible, we could add testing to
detect this, as that's rather slow to begin with.

-- Steve
