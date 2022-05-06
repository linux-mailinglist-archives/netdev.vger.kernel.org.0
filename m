Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE151DFB2
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377072AbiEFTmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiEFTme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:42:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749506A02F;
        Fri,  6 May 2022 12:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FIb54Tdtxwc7K9ZK3q50mKbEdk86SKKI/PZygVgAfU8=; b=TnNmxTB4/QP1hdHO03zzCX21LW
        wBYW++Kmfk9c6zCClKoGBZin7AfsCG+4bPSGnhBgndSd4ogQ7I9gI4n3+2MMSAKJNVp0IqTjoM9S+
        X9M3B3bv553oKRLsMM9N2d9hvG8r0m7cT0TmhdBifCGYB9At5UCWv51D5TuRWn8Tz0HHIYx+WY+gd
        /ndWv+dcsuQGHO2eO61WQYXdlTwaO+22Wq0wuD07I4p94xm61Uh/YKnwHo0IqZWz7r2C+juGkRgbM
        pQrEQiwdQXPR7B1usbPZpU75dZ9uw9OlHwl70nVNmLRE68aF66s2uKIBhK/JF7YaRd6ejb4VnXMS3
        0D2NakoQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nn3mY-00Bkkt-A5; Fri, 06 May 2022 19:38:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5F53430040C;
        Fri,  6 May 2022 21:38:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4ADAC2029A1AC; Fri,  6 May 2022 21:38:29 +0200 (CEST)
Date:   Fri, 6 May 2022 21:38:29 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, x86@kernel.org
Subject: Re: : [PATCH] ftrace/x86: Add FTRACE_MCOUNT_MAX_OFFSET to avoid
 adding weak functions
Message-ID: <YnV5NQ6lMwFY05nf@hirez.programming.kicks-ass.net>
References: <20220503150410.2d9e88aa@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150410.2d9e88aa@rorschach.local.home>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:04:10PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If an unused weak function was traced, it's call to fentry will still
> exist, which gets added into the __mcount_loc table. Ftrace will use
> kallsyms to retrieve the name for each location in __mcount_loc to display
> it in the available_filter_functions and used to enable functions via the
> name matching in set_ftrace_filter/notrace. Enabling these functions do
> nothing but enable an unused call to ftrace_caller. If a traced weak
> function is overridden, the symbol of the function would be used for it,
> which will either created duplicate names, or if the previous function was
> not traced, it would be incorrectly listed in available_filter_functions
> as a function that can be traced.
> 
> This became an issue with BPF[1] as there are tooling that enables the
> direct callers via ftrace but then checks to see if the functions were
> actually enabled. The case of one function that was marked notrace, but
> was followed by an unused weak function that was traced. The unused
> function's call to fentry was added to the __mcount_loc section, and
> kallsyms retrieved the untraced function's symbol as the weak function was
> overridden. Since the untraced function would not get traced, the BPF
> check would detect this and fail.
> 
> The real fix would be to fix kallsyms to not show address of weak
> functions as the function before it. But that would require adding code in
> the build to add function size to kallsyms so that it can know when the
> function ends instead of just using the start of the next known symbol.
> 
> In the mean time, this is a work around. Add a FTRACE_MCOUNT_MAX_OFFSET
> macro that if defined, ftrace will ignore any function that has its call
> to fentry/mcount that has an offset from the symbol that is greater than
> FTRACE_MCOUNT_MAX_OFFSET.

So for x86-64... objtool knows about these holes and *could* squash
these entries if you want (at the cost of requiring link time objtool
run).

Also see commit:

  4adb23686795 ("objtool: Ignore extra-symbol code")

But yeah, ensuring fentry is close ought to work.

> If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
> to zero, which will have ftrace ignore all locations that are not at the
> start of the function.

You forgot about IBT again? __fentry__ no longer lives at +0 on x86
anymore.
