Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CBD2B8D97
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgKSIhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKSIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:37:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E8BC0613CF;
        Thu, 19 Nov 2020 00:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EQ5bBRTWq6ELqPUgP7TVxM2lYlJzPItyKiYHy5i08tU=; b=RUZctQwcZN8oIJJn+j5hHOtuSI
        VGVegOMV0ogh8QHOuimZalpzMAMUxd/bbKIMQ3cKPZY5hbgrX0m3yeQb+nnhYGfqmWp59lXpBdtcI
        8vcEMQj+9ww5i60gcb8L+08RM5hyKPBmNFjwVgPH5Lgz9FZLpfwGR4O/Rb4LdSUDZELcT1nHvoqJL
        WTCuAMFsuIwOkDpXDbsMqIoC5HmJVjYbmClOhHrBpgFPP8+tO4lWZEwu4ivix9tFfAun0JGr2Zj1v
        N+dWrdYRyavq3WpDcyXIhsfhuc7zkWZjs76X8C5WpX40AR08FnRq0PzY71Brso55d7WfDM9eq2i/e
        f3idustw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kffQv-0003tZ-JT; Thu, 19 Nov 2020 08:36:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5A4F0300F7A;
        Thu, 19 Nov 2020 09:36:48 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3604B200DF1AB; Thu, 19 Nov 2020 09:36:48 +0100 (CET)
Date:   Thu, 19 Nov 2020 09:36:48 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20201119083648.GE3121392@hirez.programming.kicks-ass.net>
References: <20201117142145.43194f1a@gandalf.local.home>
 <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home>
 <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
 <20201118121730.12ee645b@gandalf.local.home>
 <20201118181226.GK2672@gate.crashing.org>
 <87o8jutt2h.fsf@mid.deneb.enyo.de>
 <20201118135823.3f0d24b7@gandalf.local.home>
 <20201118191127.GM2672@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118191127.GM2672@gate.crashing.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 01:11:27PM -0600, Segher Boessenkool wrote:
> Calling this via a different declared function type is undefined
> behaviour, but that is independent of how the function is *defined*.
> Your program can make ducks appear from your nose even if that function
> is never called, if you do that.  Just don't do UB, not even once!

Ah, see, here I think we disagree. UB is a flaw of the spec, but the
real world often has very sane behaviour there (sometimes also very
much not).

In this particular instance the behaviour is UB because the C spec
doesn't want to pin down the calling convention, which is something I
can understand. But once you combine the C spec with the ABI(s) at hand,
there really isn't two ways about it. This has to work, under the
premise that the ABI defines a caller cleanup calling convention.

So in the view that the compiler is a glorified assembler, I'll take UB
every day if it means I can get the thing to do what I want it to.

Obviously in the interest of co-operation and longer term viability, it
would be nice if we can agree on the behaviour and get a language
extention covering it.

Note that we have a fairly extensive tradition of defining away UB with
language extentions, -fno-strict-overflow, -fno-strict-aliasing,
-fno-delete-null-pointer-checks etc..


