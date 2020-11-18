Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB32B85E0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgKRUoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgKRUoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:44:38 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB5CD24686;
        Wed, 18 Nov 2020 20:44:34 +0000 (UTC)
Date:   Wed, 18 Nov 2020 15:44:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20201118154432.3e6e9c80@gandalf.local.home>
In-Reply-To: <20201118194837.GO2672@gate.crashing.org>
References: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
        <20201118121730.12ee645b@gandalf.local.home>
        <20201118181226.GK2672@gate.crashing.org>
        <87o8jutt2h.fsf@mid.deneb.enyo.de>
        <20201118135823.3f0d24b7@gandalf.local.home>
        <20201118191127.GM2672@gate.crashing.org>
        <20201118143343.4e86e79f@gandalf.local.home>
        <20201118194837.GO2672@gate.crashing.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 13:48:37 -0600
Segher Boessenkool <segher@kernel.crashing.org> wrote:

> > With it_func being the func from the struct tracepoint_func, which is a
> > void pointer, it is typecast to the function that is defined by the
> > tracepoint. args is defined as the arguments that match the proto.  
> 
> If you have at most four or so args, what you wnat to do will work on
> all systems the kernel currently supports, as far as I can tell.  It
> is not valid C, and none of the compilers have an extension for this
> either.  But it will likely work.

Well, unfortunately, there's tracepoints with many more than 4 arguments. I
think there's one with up to 13!

> 
> > The problem we are solving is on the removal case, if the memory is tight,
> > it is possible that the new array can not be allocated. But we must still
> > remove the called function. The idea in this case is to replace the
> > function saved with a stub. The above loop will call the stub and not the
> > removed function until another update happens.
> > 
> > This thread is about how safe is it to call:
> > 
> > void tp_stub_func(void) { return ; }
> > 
> > instead of the function that was removed?  
> 
> Exactly as safe as calling a stub defined in asm.  The undefined
> behaviour happens if your program has such a call, it doesn't matter
> how the called function is defined, it doesn't have to be C.
> 
> > Thus, we are indeed calling that stub function from a call site that is not
> > using the same parameters.
> > 
> > The question is, will this break?  
> 
> It is unlikely to break if you use just a few arguments, all of simple
> scalar types.  Just hope you will never encounter a crazy ABI :-)

But in most cases, all the arguments are of scaler types, as anything else
is not recommended, because copying is always slower than just passing a
pointer, especially since it would need to be copied for every instance of
that loop. I could do an audit to see if there's any that exist, and perhaps
even add some static checker to make sure they don't.

-- Steve
