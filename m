Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44272B7F32
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKROMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgKROMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:12:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D88DC0613D4;
        Wed, 18 Nov 2020 06:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dyKHycAKMMp/+Y5fbwqSpCe3GD5VyAzVk4hmnay49UY=; b=JXkj2GptKVopjLGtTx5/SfOVnQ
        ns5NhJMPZ9Ndrez6kOFoBVQrJI3fQOlSU17cQO5QnVSh0XGRfTASrzp1plndIc9sqgQ9x4dTLlzLu
        TlmtfHbZ42zaxFjqm+nZhwjoeN6yH1t+C7PCrnRsU5YIGRpeHxBagaXB/3uW8KPwEmBCNQb98WzXa
        3IG5nvF67A7f67ohMtAPRc11bPkB4pot7J7dWJLHBU1ZqKdPL7ifvowhsp3DA3er6Hs89WK77UETy
        Y/9vmwYQjSHJQHvFvuMvFN8o//Li+o6DJ96gka4RbgPVrX1XgCx2FxV+2TYF8AM/bfFC1yu6yM6Zx
        oPhQ3vhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfOCB-0002rI-LJ; Wed, 18 Nov 2020 14:12:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B845B3012C3;
        Wed, 18 Nov 2020 15:12:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A0C60200E0A44; Wed, 18 Nov 2020 15:12:26 +0100 (CET)
Date:   Wed, 18 Nov 2020 15:12:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Florian Weimer <fw@deneb.enyo.de>
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
Message-ID: <20201118141226.GV3121392@hirez.programming.kicks-ass.net>
References: <20201116175107.02db396d@gandalf.local.home>
 <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
 <20201117142145.43194f1a@gandalf.local.home>
 <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home>
 <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <87h7pmwyta.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7pmwyta.fsf@mid.deneb.enyo.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 02:59:29PM +0100, Florian Weimer wrote:
> * Peter Zijlstra:
> 
> > I think that as long as the function is completely empty (it never
> > touches any of the arguments) this should work in practise.
> >
> > That is:
> >
> >   void tp_nop_func(void) { }
> >
> > can be used as an argument to any function pointer that has a void
> > return. In fact, I already do that, grep for __static_call_nop().
> 
> You can pass it as a function parameter, but in general, you cannot
> call the function with a different prototype.  Even trivial
> differences such as variadic vs non-variadic prototypes matter.

I don't think any tracepoint uses variadic argument.

> The default Linux calling conventions are all of the cdecl family,
> where the caller pops the argument off the stack.  You didn't quote
> enough to context to tell whether other calling conventions matter in
> your case.

This is strictly in-kernel, and I think we're all cdecl, of which the
important part is caller-cleanup. The function compiles to:

	RET

so whatever the arguments are is irrelevant.

> > I'm not sure what the LLVM-CFI crud makes of it, but that's their
> > problem.
> 
> LTO can cause problems as well, particularly with whole-program
> optimization.

I don't think LTO can de-virtualize a dynamic array of function
pointers, so there's very little risk. That said, the __static_call_nop
case, where everything is inlined, is compiled sub-optimally for both
LLVM and GCC.
