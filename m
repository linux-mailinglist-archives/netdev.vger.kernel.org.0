Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC7E30E095
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhBCRKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhBCRKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:10:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0E1C061573;
        Wed,  3 Feb 2021 09:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J4K2nebfZ5sj1F2zLOnhiqiETjsh6I5r3Rd8GZdqQ/Q=; b=SHmozGM1UpKuswJmoH+fXAkDyK
        GhygfNUmsfed3rJRVxv7MSXU6KbeWlA2+cTj0faaOwIqD1luySI5VbAdgP7Q3QhDoF8hxcBin0cdC
        2foVHWuDO5WF3j9YbJ6FyBnqvvMdcN/gyFD+fUS+/RRzOwNVrE3r3pOERzVBVryUB+7XeZHr3dcPZ
        Rb6OKxS6zECMOeN1RmhVGuHy1doMCzQLQU+QXS2ID5k23+hzf7tDdroB1BMJXbcK+BLCnXtBxS+ZI
        Hmi+ycXgNUfeJHojgxFsBgkMAV3Xp6gZVmoAwjXdH2KlxvnyGj/GE3090yY8+NbpzMf+NlMzhkYDR
        fwWaI0vA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Lei-00HEDQ-Vn; Wed, 03 Feb 2021 17:09:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DB57D305C1C;
        Wed,  3 Feb 2021 18:09:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AB74F20C633CC; Wed,  3 Feb 2021 18:09:27 +0100 (CET)
Date:   Wed, 3 Feb 2021 18:09:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        Florian Weimer <fw@deneb.enyo.de>,
        syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com,
        syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com,
        Matt Mullins <mmullins@mmlx.us>
Subject: Re: [for-next][PATCH 14/15] tracepoint: Do not fail unregistering a
 probe due to memory failure
Message-ID: <YBrYx3kCqiEH8HEw@hirez.programming.kicks-ass.net>
References: <20210203160517.982448432@goodmis.org>
 <20210203160550.710877069@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203160550.710877069@goodmis.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 11:05:31AM -0500, Steven Rostedt wrote:
> +		if (new) {
> +			for (i = 0; old[i].func; i++)
> +				if ((old[i].func != tp_func->func
> +				     || old[i].data != tp_func->data)
> +				    && old[i].func != tp_stub_func)

logical operators go at the end..

> +					new[j++] = old[i];
> +			new[nr_probes - nr_del].func = NULL;
> +			*funcs = new;
> +		} else {
> +			/*
> +			 * Failed to allocate, replace the old function
> +			 * with calls to tp_stub_func.
> +			 */
> +			for (i = 0; old[i].func; i++)

							{

> +				if (old[i].func == tp_func->func &&
> +				    old[i].data == tp_func->data) {

like here.

> +					old[i].func = tp_stub_func;
> +					/* Set the prio to the next event. */
> +					if (old[i + 1].func)
> +						old[i].prio =
> +							old[i + 1].prio;

multi line demands { }, but in this case just don't line-break.

> +					else
> +						old[i].prio = -1;
> +				}

			}

> +			*funcs = old;
> +		}
>  	}
>  	debug_print_probes(*funcs);
>  	return old;
> @@ -295,10 +341,12 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  	tp_funcs = rcu_dereference_protected(tp->funcs,
>  			lockdep_is_held(&tracepoints_mutex));
>  	old = func_remove(&tp_funcs, func);
> -	if (IS_ERR(old)) {
> -		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
> +	if (WARN_ON_ONCE(IS_ERR(old)))
>  		return PTR_ERR(old);
> -	}
> +
> +	if (tp_funcs == old)
> +		/* Failed allocating new tp_funcs, replaced func with stub */
> +		return 0;

{ }
