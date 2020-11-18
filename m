Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F22B852A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgKRT5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:57:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:42142 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKRT5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:57:37 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 0AIJmcsd023146;
        Wed, 18 Nov 2020 13:48:38 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 0AIJmb2m023145;
        Wed, 18 Nov 2020 13:48:37 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 18 Nov 2020 13:48:37 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20201118194837.GO2672@gate.crashing.org>
References: <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com> <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de> <20201118135823.3f0d24b7@gandalf.local.home> <20201118191127.GM2672@gate.crashing.org> <20201118143343.4e86e79f@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118143343.4e86e79f@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 02:33:43PM -0500, Steven Rostedt wrote:
> On Wed, 18 Nov 2020 13:11:27 -0600
> Segher Boessenkool <segher@kernel.crashing.org> wrote:
> 
> > Calling this via a different declared function type is undefined
> > behaviour, but that is independent of how the function is *defined*.
> > Your program can make ducks appear from your nose even if that function
> > is never called, if you do that.  Just don't do UB, not even once!
> 
> But that's the whole point of this conversation. We are going to call this
> from functions that are going to have some random set of parameters.

<snip great summary>

> And you see the above, the macro does:
> 
> 	((void(*)(void *, proto))(it_func))(__data, args);

Yup.

> With it_func being the func from the struct tracepoint_func, which is a
> void pointer, it is typecast to the function that is defined by the
> tracepoint. args is defined as the arguments that match the proto.

If you have at most four or so args, what you wnat to do will work on
all systems the kernel currently supports, as far as I can tell.  It
is not valid C, and none of the compilers have an extension for this
either.  But it will likely work.

> The problem we are solving is on the removal case, if the memory is tight,
> it is possible that the new array can not be allocated. But we must still
> remove the called function. The idea in this case is to replace the
> function saved with a stub. The above loop will call the stub and not the
> removed function until another update happens.
> 
> This thread is about how safe is it to call:
> 
> void tp_stub_func(void) { return ; }
> 
> instead of the function that was removed?

Exactly as safe as calling a stub defined in asm.  The undefined
behaviour happens if your program has such a call, it doesn't matter
how the called function is defined, it doesn't have to be C.

> Thus, we are indeed calling that stub function from a call site that is not
> using the same parameters.
> 
> The question is, will this break?

It is unlikely to break if you use just a few arguments, all of simple
scalar types.  Just hope you will never encounter a crazy ABI :-)


Segher
