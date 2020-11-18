Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082F52B7E39
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKRNWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:22:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CEBC0613D4;
        Wed, 18 Nov 2020 05:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=304dWlgV4M2wRi89v82SUM37CJvIM8VxHmQweeYvBaI=; b=WJibo/P6oUNW82KjoGVgCSC64B
        vgFXenT8KrfcbWPEy3tncLCkyu21yLHxG2PHoRAG+3g/hhE1hILFlYMS4ES9flVs4G6BCdU5Yqr7v
        kw5wjRgJusQVf3KCWQg+67hz9+OVvkN2xQ4U2GKoSFqrhOJmYegImZeIVfWFDy+5V60Pe6pDgsEy3
        Cqf+zV10UPR0lMssdIi8ic+kHfv5b/2YX8aWcuCctA1SgQQebqvYTqCGNCY7jw6nHNuyNhOAl8H9R
        pjEQe3PFGzrYVzpggre8W0yZicwBGvO/P7DbbC2LOErQnywtsaNlvtkpr9dYuMLZ4SLj28w2jURt2
        V5KFJk5g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfNP4-0008CO-0n; Wed, 18 Nov 2020 13:21:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 17D0D3012DC;
        Wed, 18 Nov 2020 14:21:37 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 002E5200E0A39; Wed, 18 Nov 2020 14:21:36 +0100 (CET)
Date:   Wed, 18 Nov 2020 14:21:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: violating function pointer signature
Message-ID: <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
References: <20201116175107.02db396d@gandalf.local.home>
 <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
 <20201117142145.43194f1a@gandalf.local.home>
 <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117153451.3015c5c9@gandalf.local.home>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 03:34:51PM -0500, Steven Rostedt wrote:

> > > Since all tracepoints callbacks have at least one parameter (__data), we
> > > could declare tp_stub_func as:
> > > 
> > > static void tp_stub_func(void *data, ...)
> > > {
> > >	return;
> > > }
> > > 
> > > And now C knows that tp_stub_func() can be called with one or more
> > > parameters, and had better be able to deal with it!  
> > 
> > AFAIU this won't work.
> > 
> > C99 6.5.2.2 Function calls
> > 
> > "If the function is defined with a type that is not compatible with the type (of the
> > expression) pointed to by the expression that denotes the called function, the behavior is
> > undefined."
> 
> But is it really a problem in practice. I'm sure we could create an objtool
> function to check to make sure we don't break anything at build time.

I think that as long as the function is completely empty (it never
touches any of the arguments) this should work in practise.

That is:

  void tp_nop_func(void) { }

can be used as an argument to any function pointer that has a void
return. In fact, I already do that, grep for __static_call_nop().

I'm not sure what the LLVM-CFI crud makes of it, but that's their
problem.
