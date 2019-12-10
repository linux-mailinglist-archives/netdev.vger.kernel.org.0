Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0E6119F8C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLJXfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbfLJXfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 18:35:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3459206D9;
        Tue, 10 Dec 2019 23:35:21 +0000 (UTC)
Date:   Tue, 10 Dec 2019 18:35:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     <davem@davemloft.net>, <daniel@iogearbox.net>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf 1/3] ftrace: Fix function_graph tracer interaction
 with BPF trampoline
Message-ID: <20191210183519.41772e0f@gandalf.local.home>
In-Reply-To: <20191209000114.1876138-2-ast@kernel.org>
References: <20191209000114.1876138-1-ast@kernel.org>
        <20191209000114.1876138-2-ast@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Dec 2019 16:01:12 -0800
Alexei Starovoitov <ast@kernel.org> wrote:

>  #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
> index 67e0c462b059..a2659735db73 100644
> --- a/kernel/trace/fgraph.c
> +++ b/kernel/trace/fgraph.c
> @@ -101,6 +101,15 @@ int function_graph_enter(unsigned long ret, unsigned long func,
>  {
>  	struct ftrace_graph_ent trace;
>  
> +	/*
> +	 * Skip graph tracing if the return location is served by direct trampoline,
> +	 * since call sequence and return addresses is unpredicatable anymore.
> +	 * Ex: BPF trampoline may call original function and may skip frame
> +	 * depending on type of BPF programs attached.
> +	 */
> +	if (ftrace_direct_func_count &&
> +	    ftrace_find_rec_direct(ret - MCOUNT_INSN_SIZE))

My only worry is that this may not work for all archs that implement
it. But I figure we can cross that bridge when we get to it.

> +		return -EBUSY;
>  	trace.func = func;
>  	trace.depth = ++current->curr_ret_depth;
>  

I added this patch to my queue and it's about 70% done going through my
test suite (takes around 10 - 13 hours).

As I'm about to send a pull request to Linus tomorrow, I could include
this patch (as it will be fully tested), and then you could apply the
other two when it hits Linus's tree.

Would that work for you?

-- Steve
