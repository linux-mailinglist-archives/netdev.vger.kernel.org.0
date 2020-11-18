Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7AE2B7F09
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgKROFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:05:38 -0500
Received: from albireo.enyo.de ([37.24.231.21]:37868 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgKROFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 09:05:38 -0500
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Nov 2020 09:05:37 EST
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kfNzd-00007x-Om; Wed, 18 Nov 2020 13:59:29 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1kfNzd-00024M-Lt; Wed, 18 Nov 2020 14:59:29 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
Date:   Wed, 18 Nov 2020 14:59:29 +0100
In-Reply-To: <20201118132136.GJ3121378@hirez.programming.kicks-ass.net> (Peter
        Zijlstra's message of "Wed, 18 Nov 2020 14:21:36 +0100")
Message-ID: <87h7pmwyta.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Peter Zijlstra:

> I think that as long as the function is completely empty (it never
> touches any of the arguments) this should work in practise.
>
> That is:
>
>   void tp_nop_func(void) { }
>
> can be used as an argument to any function pointer that has a void
> return. In fact, I already do that, grep for __static_call_nop().

You can pass it as a function parameter, but in general, you cannot
call the function with a different prototype.  Even trivial
differences such as variadic vs non-variadic prototypes matter.

The default Linux calling conventions are all of the cdecl family,
where the caller pops the argument off the stack.  You didn't quote
enough to context to tell whether other calling conventions matter in
your case.

> I'm not sure what the LLVM-CFI crud makes of it, but that's their
> problem.

LTO can cause problems as well, particularly with whole-program
optimization.
