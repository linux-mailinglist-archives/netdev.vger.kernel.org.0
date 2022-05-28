Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74261536C9A
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349748AbiE1LmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 07:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiE1LmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 07:42:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C8A26D1;
        Sat, 28 May 2022 04:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4xeN+ZrRvrDIbRnl4vDOVj8KoJB0zoiMdh4uPwuP1YA=; b=LrqTfvgGt5xtusRNylgaS1e+C5
        MV2jC17uCfgxicGQLfi71ymA/nVudI2QdZQPkrllrF3XCfVlZc4/VhUJMWwM96qrZ6/HU5gWPzVcF
        lSxMPRxq0UiBx3P/SvEuR26pwZxGRGBVn+vAllolObjKK/LeF9/IWTaiO1VPRYNr0c1Zi23+GMWGk
        qTrH2TcbJHMdtghR8rB8ZzIjEJRDv7CUaFbY2bYeWV945yJoo27hAZ7BlfwarVQuoKQMHpukIE+W+
        oImQKOEq5PnhO8mPTzZQ26HWKexXaqYkjUBzRh+vWkMRYVK2BAdg9nncgYB5FPV9u9JyY6ScjlbKF
        ib+suyeg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuupD-002pwR-Pv; Sat, 28 May 2022 11:41:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 521753007A2;
        Sat, 28 May 2022 13:41:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 38E7C2083A861; Sat, 28 May 2022 13:41:41 +0200 (CEST)
Date:   Sat, 28 May 2022 13:41:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: [PATCH v4] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <YpIKdfPYrztMLOep@hirez.programming.kicks-ass.net>
References: <20220526141912.794c2786@gandalf.local.home>
 <20220527083043.022e8e36@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527083043.022e8e36@gandalf.local.home>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 08:30:43AM -0400, Steven Rostedt wrote:
> On Thu, 26 May 2022 14:19:12 -0400
> Steven Rostedt <rostedt@goodmis.org> (by way of Steven Rostedt
> <rostedt@goodmis.org>) wrote:
> 
> > +++ b/kernel/trace/ftrace.c
> > @@ -3654,6 +3654,31 @@ static void add_trampoline_func(struct seq_file *m, struct ftrace_ops *ops,
> >  		seq_printf(m, " ->%pS", ptr);
> >  }
> >  
> > +#ifdef FTRACE_MCOUNT_MAX_OFFSET
> > +static int print_rec(struct seq_file *m, unsigned long ip)
> > +{
> > +	unsigned long offset;
> > +	char str[KSYM_SYMBOL_LEN];
> > +	char *modname;
> > +	const char *ret;
> > +
> > +	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);
> > +	if (!ret || offset > FTRACE_MCOUNT_MAX_OFFSET)
> > +		return -1;
> 
> Unfortunately, I can't just skip printing these functions. The reason is
> because it breaks trace-cmd (libtracefs specifically). As trace-cmd can
> filter with full regular expressions (regex(3)), and does so by searching
> the available_filter_functions. It collects an index of functions to
> enabled, then passes that into set_ftrace_filter.
> 
> As a speed up, set_ftrace_filter allows you to pass an index, defined by the
> line in available_filter_functions, into it that uses array indexing into
> the ftrace table to enable/disable functions for tracing. By skipping
> entries, it breaks the indexing, because the index is a 1 to 1 paring of
> the lines of available_filter_functions.

In what order does available_filter_functions print the symbols?

The pending FGKASLR patches randomize kallsyms order and anything that
prints symbols in address order will be a security leak.

