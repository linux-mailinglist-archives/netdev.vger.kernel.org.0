Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D98E2B84DC
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgKRTU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:20:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:43809 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgKRTU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:20:26 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 0AIJBT7B020479;
        Wed, 18 Nov 2020 13:11:29 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 0AIJBR35020478;
        Wed, 18 Nov 2020 13:11:27 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 18 Nov 2020 13:11:27 -0600
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
Message-ID: <20201118191127.GM2672@gate.crashing.org>
References: <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com> <20201118121730.12ee645b@gandalf.local.home> <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de> <20201118135823.3f0d24b7@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118135823.3f0d24b7@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 01:58:23PM -0500, Steven Rostedt wrote:
> I wonder if we should define on all architectures a void void_stub(void),
> in assembly, that just does a return, an not worry about gcc messing up the
> creation of the stub function.
> 
> On x86_64:
> 
> GLOBAL(void_stub)
> 	retq
> 
> 
> And so on.

I don't see how you imagine a compiler to mess this up?

void void_stub(void) { }

will do fine?

        .globl  void_stub
        .type   void_stub, @function
void_stub:
.LFB0:
        .cfi_startproc
        ret
        .cfi_endproc
.LFE0:
        .size   void_stub, .-void_stub


Calling this via a different declared function type is undefined
behaviour, but that is independent of how the function is *defined*.
Your program can make ducks appear from your nose even if that function
is never called, if you do that.  Just don't do UB, not even once!


Segher
