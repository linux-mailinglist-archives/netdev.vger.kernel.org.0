Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C413F04DB
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 15:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbhHRNea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 09:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhHRNe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 09:34:27 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C0CE6109E;
        Wed, 18 Aug 2021 13:33:51 +0000 (UTC)
Date:   Wed, 18 Aug 2021 09:33:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 50/63] tracing: Use memset_startat() to zero struct
 trace_iterator
Message-ID: <20210818093349.3144276b@oasis.local.home>
In-Reply-To: <20210818060533.3569517-51-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
        <20210818060533.3569517-51-keescook@chromium.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 23:05:20 -0700
Kees Cook <keescook@chromium.org> wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Use memset_startat() to avoid confusing memset() about writing beyond
> the target struct member.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/trace/trace.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 13587e771567..9ff8c31975cd 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6691,9 +6691,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  		cnt = PAGE_SIZE - 1;
>  
>  	/* reset all but tr, trace, and overruns */
> -	memset(&iter->seq, 0,
> -	       sizeof(struct trace_iterator) -
> -	       offsetof(struct trace_iterator, seq));
> +	memset_startat(iter, 0, seq);

I can't find memset_startat() in mainline nor linux-next. I don't see it
in this thread either, but since this has 63 patches, I could have
easily missed it.

This change really should belong to a patch set that just introduces
memset_startat() (and perhaps memset_after()) and then updates all the
places that should use it. That way I can give it a proper review. In
other words, you should break this patch set up into smaller, more
digestible portions for the reviewers.

Thanks,

-- Steve



>  	cpumask_clear(iter->started);
>  	trace_seq_init(&iter->seq);
>  	iter->pos = -1;

