Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D2D2B8540
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgKRUCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgKRUCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:02:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9DDC20782;
        Wed, 18 Nov 2020 20:02:37 +0000 (UTC)
Date:   Wed, 18 Nov 2020 15:02:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Weimer <fw@deneb.enyo.de>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20201118150236.65a538eb@gandalf.local.home>
In-Reply-To: <CAADnVQLv2pnw1x66Y_cYmdBg=sF+7s31VVoEmSerDnbuR0pU_g@mail.gmail.com>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
        <87h7pmwyta.fsf@mid.deneb.enyo.de>
        <20201118092228.4f6e5930@gandalf.local.home>
        <CAADnVQLv2pnw1x66Y_cYmdBg=sF+7s31VVoEmSerDnbuR0pU_g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 11:46:02 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Nov 18, 2020 at 6:22 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Thus, all functions will be non-variadic in these cases.  
> 
> That's not the only case where it will blow up.
> Try this on sparc:
> struct foo {
> int a;
> };
> 
> struct foo foo_struct(void) {
> struct foo f = {};
> return f;
> }
> int foo_int(void) {
> return 0;
> }
> or this link:
> https://godbolt.org/z/EdM47b
> 
> Notice:
> jmp %i7+12
> The function that returns small struct will jump to a different
> instruction in the caller.
> 
> I think none of the tracepoints return structs and void foo(void) is
> fine on x86.
> Just pointing out that it's more than just variadic.

I also said that this is limited to only functions that have void return.

-- Steve
