Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8EB2B959F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgKSO74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgKSO74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 09:59:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDAB624695;
        Thu, 19 Nov 2020 14:59:52 +0000 (UTC)
Date:   Thu, 19 Nov 2020 09:59:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20201119095951.30269233@gandalf.local.home>
In-Reply-To: <20201119143735.GU2672@gate.crashing.org>
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
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 08:37:35 -0600
Segher Boessenkool <segher@kernel.crashing.org> wrote:

> > Note that we have a fairly extensive tradition of defining away UB with
> > language extentions, -fno-strict-overflow, -fno-strict-aliasing,  
> 
> These are options to make a large swath of not correct C programs
> compile (and often work) anyway.  This is useful because there are so
> many such programs, because a) people did not lint; and/or b) the
> problem never was obvious with some other (or older) compiler; and/or
> c) people do not care about writing portable C and prefer writing in
> their own non-C dialect.


Note, this is not about your average C program. This is about the Linux
kernel, which already does a lot of tricks in C. There's a lot of code in
assembly that gets called from C (and vise versa). We modify code on the
fly (which tracepoints use two methods of that - with asm-goto/jump-labels
and static functions).

As for your point c), I'm not sure what you mean about portable C (stuck to
a single compiler, or stuck to a single architecture?). Linux obviously
supports multiple architectures (more than any other OS), but it is pretty
stuck to gcc as a compiler (with LLVM just starting to work too).

We are fine with being stuck to a compiler if it gives us what we want.

-- Steve
